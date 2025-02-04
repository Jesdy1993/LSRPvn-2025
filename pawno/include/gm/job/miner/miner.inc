Miner_OnGamemodeInit()
{
	Vein_Generate();
	SetTimer("Vein_Generate", REGEN_TIME * 60000, true);
	
	new label[128];
	for(new i; i < sizeof(DropPoints); i++)
	{
	    format(label, sizeof(label), "Ore Drop Point - %s\n\n{FFFFFF}Mang quang cua ban den day de nhan tien!", DropPoints[i][Location]);
		DropPoints[i][PointLabel] = CreateDynamic3DTextLabel(label, 0xF1C40FFF, DropPoints[i][PointX], DropPoints[i][PointY], DropPoints[i][PointZ] + 0.5, 15.0, .testlos = 1);
		DropPoints[i][PointCP] = CreateDynamicCP(DropPoints[i][PointX], DropPoints[i][PointY], DropPoints[i][PointZ], 6.0);
	}

	for(new i, pool = GetPlayerPoolSize(); i <= pool; i++)
	{
	    if (!IsPlayerConnected(i)) continue;
	    MinerPlayer_Init(i);
	}
	
	return 1;
}

Miner_OnPlayerDisconnect(playerid)
{
	Player_CleanUp(playerid, 1);
	if (IsValidPlayerProgressBar(playerid, MiningBar[playerid]))
	{
		DestroyPlayerProgressBar(playerid, MiningBar[playerid]);
	} 
	
	return 1;
}

Miner_OnPlayerConnect(playerid)
{
    MinerPlayer_Init(playerid);
	return 1;
}

Miner_OnPlayerStateChange(playerid, newstate, oldstate)
{
	if (newstate == PLAYER_STATE_DRIVER)
	{
	    new vehicleid = GetPlayerVehicleID(playerid);
	    if (IsMinerCar(vehicleid) > 0)
	    {
	        new string[128];
	        format(string, sizeof(string), "MINING: {FFFFFF}Mang quang cua ban den day de nhan tien {F39C12}%d {FFFFFF}quang - no co gia tri {2ECC71}$%d.", Vehicle_LoadedOres(vehicleid), Vehicle_GetOreValue(vehicleid));
			SendClientMessage(playerid, 0x2ECC71FF, string);
			SendClientMessage(playerid, 0x2ECC71FF, "MINING: {FFFFFF}Ban co the ban quang da tai cua minh de lay diem duoc danh dau bang bieu tuong xe tai.");
			SendClientMessage(playerid, 0x2ECC71FF, "MINING: {FFFFFF}Ban co the su dung /miner de xem them thong tin.");
			for(new i; i < sizeof(DropPoints); i++)
			{
			    PointIcons[playerid][i] = CreateDynamicMapIcon(DropPoints[i][PointX], DropPoints[i][PointY], DropPoints[i][PointZ], 51, 0, _, _, playerid, 8000.0, MAPICON_GLOBAL);
				TogglePlayerDynamicCP(playerid, DropPoints[i][PointCP], 1);
			}
	    }
	    
		SetPVarInt(playerid, "LastVehicleID", vehicleid);
	}
	
	if (oldstate == PLAYER_STATE_DRIVER)
	{
		for(new i; i < sizeof(DropPoints); i++)
		{
		    if (IsValidDynamicMapIcon(PointIcons[playerid][i]))
		    {
		        DestroyDynamicMapIcon(PointIcons[playerid][i]);
		        PointIcons[playerid][i] = -1;
		    }
		    
			TogglePlayerDynamicCP(playerid, DropPoints[i][PointCP], 0);
		}
	}
	
	Player_CleanUp(playerid, 1);
	return 1;
}

Miner_OnPlayerKeyStateChange(playerid, newkeys)
{
	if ((newkeys & KEY_NO) && CarryingOre[playerid] != -1)
	{
		new id = Ore_FindFreeID();
		if (id != -1)
		{
		    if (Player_GetClosestOre(playerid, 1.5) != -1) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Ban khong the bo quang cua minh o day.");
		    new label[48], type = CarryingOre[playerid], Float: x, Float: y, Float: z, Float: a;
		    GetPlayerPos(playerid, x, y, z);
		    GetPlayerFacingAngle(playerid, a);
		    x += (1.25 * floatsin(-a, degrees));
			y += (1.25 * floatcos(-a, degrees));
			
		    DroppedOres[id][Type] = type;
			DroppedOres[id][OreTimer] = SetTimerEx("Ore_Destroy", ORE_TIME * 60000, false, "i", id);
		    DroppedOres[id][OreObject] = CreateDynamicObject(3929, x, y, z - 0.65, 0.0, 0.0, random(360));
	  		SetDynamicObjectMaterial(DroppedOres[id][OreObject], 0, 2936, "kmb_rckx", "larock256", RGBAToARGB(OreData[type][Color]));
			format(label, sizeof(label), "%s Ore\n{FFFFFF}\n\n/ore take", OreData[type][Name]);
	  		DroppedOres[id][OreLabel] = CreateDynamic3DTextLabel(label, OreData[type][Color], x, y, z, 5.0, .testlos = 1);
		    DroppedOres[id][OreExists] = true;
		}
		
	    ApplyAnimation(playerid, "CARRY", "putdwn05", 4.1, 0, 1, 1, 0, 0, 1);
		Player_CleanUp(playerid, 1);
	}
	
	return 1;
}

Miner_OnVehicleSpawn(vehicleid)
{
	Vehicle_CleanUp(vehicleid);
	return 1;
}

Miner_OnPlayerEnterDynamicCP(playerid, checkpointid)
{
	if (checkpointid == LoadingPoint[playerid])
	{
	    if (GetPVarInt(playerid, "LoadingCooldown") > gettime()) return 1;
		new vehicleid = GetPVarInt(playerid, "LastVehicleID");
		if (Vehicle_LoadedOres(vehicleid) >= VEHICLE_LIMIT) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Ban khong the tai them quang vao xe nay.");
		LoadedOres[vehicleid][ CarryingOre[playerid] ]++;
		
		SendSyntaxMessage(playerid, "Loaded %s.", OreData[ CarryingOre[playerid] ][Name]); 
		ApplyAnimation(playerid, "CARRY", "putdwn05", 4.1, 0, 1, 1, 0, 0, 1);
		Player_CleanUp(playerid, 1);
		return 1;
	}
	
	if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		for(new i; i < sizeof(DropPoints); i++)
		{
		    if (checkpointid == DropPoints[i][PointCP])
		    {
		        new vehicleid = GetPlayerVehicleID(playerid), cash = Vehicle_GetOreValue(vehicleid);
		        SendSyntaxMessage(playerid, "Ban {F39C12}%d {FFFFFF}quang va kiem duoc {2ECC71}$%d.", Vehicle_LoadedOres(vehicleid), cash);
				GiveCash(playerid, cash);
		        Vehicle_CleanUp(vehicleid);
		        
		        for(new x; x < sizeof(DropPoints); x++)
				{
				    if (IsValidDynamicMapIcon(PointIcons[playerid][x]))
				    {
				        DestroyDynamicMapIcon(PointIcons[playerid][x]);
				        PointIcons[playerid][x] = -1;
				    }

					TogglePlayerDynamicCP(playerid, DropPoints[x][PointCP], 0);
				}

		        break;
		    }
		}
	}
	
	return 1;
}