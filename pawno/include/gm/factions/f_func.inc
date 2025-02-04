this::LoadDynamicFactions()
{
	new rows = cache_num_rows(), time = GetTickCount(), total, id;

	if (!rows)
	{
	    print("[Factions] Khong co du lieu duoc tim thay.");
	    return 1;
	}

	for(new i = 0; i < rows && i < MAX_FACTIONS; i ++)
	{
	    id = cache_get_field_content_int(i, "factionid", dbHandle);
		Factions[id][fON] = 1;
		Factions[id][fID] = cache_get_field_content_int(i, "id", dbHandle);
		cache_get_field_content(i, "name", Factions[id][fName], dbHandle, 32);
		cache_get_field_content(i, "shortname", Factions[id][fShortName], dbHandle, 8);
		Factions[id][fPosX] = cache_get_field_content_float(i, "spawnx", dbHandle);
		Factions[id][fPosY] = cache_get_field_content_float(i, "spawny", dbHandle);
		Factions[id][fPosZ] = cache_get_field_content_float(i, "spawnz", dbHandle);
		Factions[id][fSpawnInt] = cache_get_field_content_int(i, "spawnint", dbHandle);
		Factions[id][fSpawnVW] = cache_get_field_content_int(i, "spawnvw", dbHandle);
		Factions[id][fJoinRank] = cache_get_field_content_int(i, "joinrank", dbHandle);
		Factions[id][fType] = cache_get_field_content_int(i, "type", dbHandle);
		Factions[id][fRanks] = cache_get_field_content_int(i, "ranks", dbHandle);

		for(new j = 0; j < Factions[id][fRanks]; j++)
		{
			new field_name[32], temp[128];
			format(field_name, sizeof(field_name), "rank%i", j+1);
			cache_get_field_content(i, field_name, temp, dbHandle, 128);
			sscanf(temp, "p<,>iiiiiiiiis[32]", 
			FRank[id][j][rInvite],
			FRank[id][j][rUninvite],
			FRank[id][j][rRank],
			FRank[id][j][r_eRank],
			FRank[id][j][rSpawn],
			FRank[id][j][rChat],
			FRank[id][j][rTow],
			FRank[id][j][rBodyCam],
			FRank[id][j][r_eRights],
			FactionRanks[id][j]);
		}

		Factions[id][fChatON] = cache_get_field_content_int(i, "chaton", dbHandle);
		Factions[id][fColor] = cache_get_field_content_int(i, "color", dbHandle);
		Factions[id][fPoint] = cache_get_field_content_int(i, "point", dbHandle);
		Factions[id][fPointTime] = cache_get_field_content_int(i, "point_time", dbHandle);

		if (IsFactionLegal(id)) 
		{
			Factions[id][fUniformX] = cache_get_field_content_float(i, "uniform_x", dbHandle);
			Factions[id][fUniformY] = cache_get_field_content_float(i, "uniform_y", dbHandle);
			Factions[id][fUniformZ] = cache_get_field_content_float(i, "uniform_z", dbHandle);
			Factions[id][fUniformInt] = cache_get_field_content_int(i, "uniform_int", dbHandle);
			Factions[id][fUniformVW] = cache_get_field_content_int(i, "uniform_vw", dbHandle);
			
			if (Factions[id][fUniformX]) Factions[id][fPickUp] = CreateDynamicPickup(1239, 1, Factions[id][fUniformX], Factions[id][fUniformY], Factions[id][fUniformZ], Factions[id][fUniformVW], Factions[id][fUniformInt], -1, 100.0);
			
			Factions[id][Carfix][fixX] = cache_get_field_content_float(i, "fix_X", dbHandle);
			Factions[id][Carfix][fixY] = cache_get_field_content_float(i, "fix_Y", dbHandle); 
			Factions[id][Carfix][fixZ] = cache_get_field_content_float(i, "fix_Z", dbHandle);
			Factions[id][Carfix][fixInt] = cache_get_field_content_int(i, "fix_Int", dbHandle);
			Factions[id][Carfix][fixVW] = cache_get_field_content_int(i, "fix_VW", dbHandle);

			if (Factions[id][Carfix][fixX]) Factions[id][Carfix][fixPickUp] = CreateDynamicPickup(1650, 1, Factions[id][Carfix][fixX], Factions[id][Carfix][fixY], Factions[id][Carfix][fixZ], Factions[id][Carfix][fixVW], Factions[id][Carfix][fixInt], -1, 20.0);
		}

		total++;
	}
	printf("[Factions] Rows - %i. Load - %i. Time: %i ms.", rows, total, GetTickCount()-time);
	return 1;
}

RemovePlayerFaction(userid)
{
    if (pTemp[userid][pPatrol])
	{
	    new id = pTemp[userid][pPatrol]-1;
	    pTemp[userid][pPatrol] = 0;

        if (PatrolInfo[GetPatrolID(userid)][id][patrulOfficer][0] == userid) PatrolInfo[GetPatrolID(userid)][id][patrulOfficer][0] = INVALID_PLAYER_ID;
        if (PatrolInfo[GetPatrolID(userid)][id][patrulOfficer][1] == userid) PatrolInfo[GetPatrolID(userid)][id][patrulOfficer][1] = INVALID_PLAYER_ID;
		if (PatrolInfo[GetPatrolID(userid)][id][patrulOfficer][0] == INVALID_PLAYER_ID && PatrolInfo[GetPatrolID(userid)][id][patrulOfficer][0] == INVALID_PLAYER_ID)
		{
		    PatrolInfo[GetPatrolID(userid)][id][patrulExists] = 0;
		}
	}

	if (PlayerInfo[userid][pOnDuty])
	{
		if (IsPlayerAttachedObjectSlotUsed(userid, 5))	RemovePlayerAttachedObject(userid, 5);
		if (IsPlayerAttachedObjectSlotUsed(userid, 6))	RemovePlayerAttachedObject(userid, 6);
		if (IsPlayerAttachedObjectSlotUsed(userid, 7))	RemovePlayerAttachedObject(userid, 7);

		new copsitems = 0, playersitems = 0;
		for(new i; i < MAX_INV_SLOTS; i++)
		{
			if (i < MAX_COP_SLOTS) if (PlayerInfo[userid][pCopItem][i]) copsitems++;
			if (!Inventory[userid][i][pInvItem]) playersitems++;
		}

		if (playersitems - copsitems >= 0)
		{
			for(new i; i < MAX_COP_SLOTS; i++)
			{
				new slotid = GetInvNextSlot(userid);
				if (slotid == -1)	continue;

				Inventory[userid][slotid][pInvItem] = PlayerInfo[userid][pCopItem][i];
				Inventory[userid][slotid][pInvQ] = PlayerInfo[userid][pCopQ][i];
				Inventory[userid][slotid][pInvEx] = PlayerInfo[userid][pCopEx][i];
				Inventory[userid][slotid][pInvS] = PlayerInfo[userid][pCopS][i];
			}
		}
		else
		{
			for(new i; i < playersitems; i++)
			{
				if (PlayerInfo[userid][pCopItem][i] == 0) continue;

				new slotid = GetInvNextSlot(userid);
				if (slotid == -1)	continue;

				Inventory[userid][slotid][pInvItem] = PlayerInfo[userid][pCopItem][i];
				Inventory[userid][slotid][pInvQ] = PlayerInfo[userid][pCopQ][i];
				Inventory[userid][slotid][pInvEx] = PlayerInfo[userid][pCopEx][i];
				Inventory[userid][slotid][pInvS] = PlayerInfo[userid][pCopS][i];
			}
			for(new d = playersitems; d < MAX_COP_SLOTS; d++)	ItemDrop_Drop(userid, PlayerInfo[userid][pCopItem][d], PlayerInfo[userid][pCopQ][d], PlayerInfo[userid][pCopEx][d], PlayerInfo[userid][pCopS][d]);
		}
		
		for(new j; j < MAX_INV_SLOTS; j++)
		{
			PlayerInfo[userid][pCopItem][j] = 0;
			PlayerInfo[userid][pCopQ][j] = 0;
			PlayerInfo[userid][pCopEx][j] = 0;
			PlayerInfo[userid][pCopS][j] = 0;
		}

		CallRemoteFunction("LoadHolsters","i",userid);
        SetPlayerArmour(userid, 0.0);
		Save_User(userid);
	}

    SetRadioChannel(userid, 0);
	SetRadioSlot(userid, 0);

	if (PlayerInfo[userid][pSpawnType] == 2) {
		PlayerInfo[userid][pSpawnType] = 0;
		PlayerInfo[userid][pSpawnPoint] = 1;
		SendHelpMessage(userid, "Vi tri bat dau cua ban da duoc tu dong thay doi tro lai binh thuong trong Palomino Creek. (/settings)");
	}

	PlayerInfo[userid][pFaction] = 0;
	PlayerInfo[userid][pRank] = 0;
	PlayerInfo[userid][pBadgeNumber] = 0;
	PlayerInfo[userid][pOnDuty] = false;
	PlayerInfo[userid][pSwatDuty] = false;
	PlayerInfo[userid][pAuthwep] = 0;
	PlayerInfo[userid][pSwat] = 0;
	PlayerInfo[userid][pSideJob] = 0;
	PlayerInfo[userid][pChar] = 0;

	SetPlayerSkin(userid, PlayerInfo[userid][pSkin]);

 	if (IsTesterDuty(userid) == 1)	SetPlayerColor(userid, HELPER_DUTY);
    else if (IsAdminDuty(userid))	SetPlayerColor(userid, TEAM_ADMIN_COLOR);
	else							SetPlayerColor(userid, TEAM_HIT_COLOR);
	
	return 1;
}

isLeader(playerid)
{
	return PlayerInfo[playerid][pFaction] != 0 && PlayerInfo[playerid][pRank] == Factions[PlayerInfo[playerid][pFaction]][fRanks] ? 1 : 0;
}

SendFactionMessageF(factionid, color, const text[], {Float,_}:...)
{
	static
  	    args,
	    str[192];

	if((args = numargs()) <= 3)
	{
	    foreach(new i : Player)
	    {
	        if(IsPlayerLogged(i) && PlayerInfo[i][pFaction] == factionid)
	        {
	    		SCM(i, color, text);
			}
		}
	}
	else
	{
		while(--args >= 3)
		{
			#emit LCTRL 	5
			#emit LOAD.alt 	args
			#emit SHL.C.alt 2
			#emit ADD.C 	12
			#emit ADD
			#emit LOAD.I
			#emit PUSH.pri
		}
		#emit PUSH.S 	text
		#emit PUSH.C 	192
		#emit PUSH.C 	str
		#emit PUSH.S	8
		#emit SYSREQ.C 	format
		#emit LCTRL 	5
		#emit SCTRL 	4

		foreach(new i : Player)
	    {
	        if(IsPlayerLogged(i) && PlayerInfo[i][pFaction] == factionid)
	        {
	    		SendClientMessage(i, color, str);
			}
		}

		#emit RETN
	}
	return 1;
}

SendFactionMessage(factionid, color, const text[], {Float,_}:...)
{
	static
  	    args,
	    str[192];

	if((args = numargs()) <= 3)
	{
	    foreach(new i : Player)
	    {
	        if (PlayerFactionType(i) == factionid || PlayerInfo[i][pOnDuty])
	        {
	    		SendClientMessage(i, color, text);
			}
		}
	}
	else
	{
		while(--args >= 3)
		{
			#emit LCTRL 	5
			#emit LOAD.alt 	args
			#emit SHL.C.alt 2
			#emit ADD.C 	12
			#emit ADD
			#emit LOAD.I
			#emit PUSH.pri
		}
		#emit PUSH.S 	text
		#emit PUSH.C 	192
		#emit PUSH.C 	str
		#emit PUSH.S	8
		#emit SYSREQ.C 	format
		#emit LCTRL 	5
		#emit SCTRL 	4

		foreach(new i : Player)
		{
			if (PlayerFactionType(i) == factionid || PlayerInfo[i][pOnDuty])
			{
				SendClientMessage(i, color, str);
			}
			
		}

		#emit RETN
	}
	return 1;
}

CreateFactionVehicle(bool: crt, model, Float: x, Float: y, Float: z, Float: a, color1, color2, type, faction, plate[], vw, interior, sqlid = 0)
{
	new vehicle;

    if (type == WITHSIGNAL_CAR)						vehicle = CreateVehicle(model, x, y, z, a, color1, color2, -1, 1);
    else if (type == RENT_CAR || type == PIZZA_CAR)	vehicle = CreateVehicle(model, x, y, z, a, color1, color2, 600);
 	else											vehicle = CreateVehicle(model, x, y, z, a, color1, color2, -1);

    if (vehicle == INVALID_VEHICLE_ID)				return 0;

	SetVehicleHealth(vehicle, 1000.0);
	SetVehicleNumberPlate(vehicle, plate);
 	SetVehicleVirtualWorldEx(vehicle, vw);
	SetVehicleInteriorEx(vehicle, interior);

	VehicleInfo[vehicle][carModel] = model;
	VehicleInfo[vehicle][carParkX] = x;
	VehicleInfo[vehicle][carParkY] = y;
	VehicleInfo[vehicle][carParkZ] = z;
	VehicleInfo[vehicle][carParkA] = a;
	VehicleInfo[vehicle][carColor1] = color1;
	VehicleInfo[vehicle][carColor2] = color2;
	VehicleInfo[vehicle][carType] = type;
	VehicleInfo[vehicle][carFaction] = faction;
	VehicleInfo[vehicle][carVW] = vw;
	VehicleInfo[vehicle][carInt] = interior;
    VehicleInfo[vehicle][carFuel] = GetVehicleFuelCapacity(GetVehicleModel(vehicle));
    VehicleInfo[vehicle][carDriver] = INVALID_PLAYER_ID;
	VehicleInfo[vehicle][carOwnerID] = 0;
    
	format(VehicleInfo[vehicle][carPlate], 24, plate);

	if (crt)
	{
	    new query[128 + 128];
		mysql_format(dbHandle, query, sizeof(query), "INSERT INTO `cars` (`date`,`model`,`x`,`y`,`z`,`fa`,`color1`,`color2`,`type`,`faction`,`plate`,`vw`,`int`) VALUES ('%s',%i, %f, %f, %f, %f, %i, %i, %i, %i, '%e', %i, %i)",
		GetFullDate(), model, x, y, z, a, color1, color2, type, faction, plate, vw, interior);
		mysql_tquery(dbHandle, query, "OnVehicleInsert", "d", vehicle);
	}
	else VehicleInfo[vehicle][carID] = sqlid;
	
	return vehicle;
}

IsPlayerAtSecondUniform(playerid)
{
	new vehicle;
	if ((vehicle = GetPlayerVehicleID(playerid)) == 0) return 0;
	    

	if (IsPlayerFactionPolice(playerid) && GetVehicleModel(vehicle) == 427) return 1;
	else if (IsPlayerFactionMedic(playerid) && IsFactionMedic(VehicleInfo[vehicle][carFaction])) return 1;
	else if (IsPlayerFactionFire(playerid) && IsFactionFire(VehicleInfo[vehicle][carFaction])) return 1;

	return 0;
}

IsPlayerAtUniform(playerid)
{
	new faction = PlayerInfo[playerid][pFaction];
	return (faction == 0 || !PlayerToPoint(2.0, playerid, Factions[faction][fUniformX], Factions[faction][fUniformY], Factions[faction][fUniformZ]) || GetWorld(playerid) != Factions[faction][fUniformVW] || GetInterior(playerid) != Factions[faction][fUniformInt]) ? (0):(1);
}

DestroyAllBort(playerid)
{
	for(new i; i < MAX_BORTES; i++)
	{
	    if (BortInfo[playerid][i][bortOn] == 0) continue;

        BortInfo[playerid][i][bortOn] = 0;
		BortInfo[playerid][i][bortUsing] = 0;
		BortInfo[playerid][i][bortName] = EOS;
		
	    if (IsValidDynamicObject(BortInfo[playerid][i][bortObject])) DestroyDynamicObject(BortInfo[playerid][i][bortObject]);
       		
       	BortInfo[playerid][i][bortObject] = INVALID_OBJECT_ID;
	}
	return 1;
}

AddFactionToFile(factionid, shortname[], name[], color, type, ranks, pointtime)
{
    new query[128 + 128];
	mysql_format(dbHandle, query, sizeof(query), "INSERT INTO `factions` (factionid,shortname,name,color,type,ranks,point_time) VALUES (%i,'%s','%s',%i,%i,%i,%i)", factionid, shortname, name, color, type, ranks, pointtime);
	mysql_tquery(dbHandle, query, "FactionInsertId", "i", factionid);
	return 1;
}

this::FactionInsertId(factionid)
{
	Factions[factionid][fID] = cache_insert_id();
	return 1;
}

UpdateFactionRank(FactionID, Rank)
{
	new query[512], update_string[256];
	format(update_string, sizeof(update_string), "%i,%i,%i,%i,%i,%i,%i,%i,%i,%s", 
	FRank[FactionID][Rank-1][rInvite], FRank[FactionID][Rank-1][rUninvite], FRank[FactionID][Rank-1][rRank], FRank[FactionID][Rank-1][r_eRank],
	FRank[FactionID][Rank-1][rSpawn], FRank[FactionID][Rank-1][rChat], FRank[FactionID][Rank-1][rTow], FRank[FactionID][Rank-1][rBodyCam], 
	FRank[FactionID][Rank-1][r_eRights], FactionRanks[FactionID][Rank-1]);
	mysql_format(dbHandle, query, sizeof(query), "UPDATE `factions` SET `rank%i` = '%s' WHERE `factionid` = %i", Rank, update_string, FactionID);
	mysql_tquery(dbHandle, query);
	return 1; 
}

ShowRightsForRank(playerid, listitem)
{
	new faction_rights[640] = "{FFFFFF}Right\tAccess\tCMD";
	new right[9][16], faction = PlayerInfo[playerid][pFaction];

	if (FRank[faction][listitem][rInvite])		format(right[0], 16, "%s", RIGHT_YES);
	else 										format(right[0], 16, "%s", RIGHT_NO);

	if (FRank[faction][listitem][rUninvite])	format(right[1], 16, "%s", RIGHT_YES);
	else										format(right[1], 16, "%s", RIGHT_NO);

	if (FRank[faction][listitem][rRank])		format(right[2], 16, "%s", RIGHT_YES);
	else 										format(right[2], 16, "%s", RIGHT_NO);

	if (FRank[faction][listitem][r_eRank])		format(right[3], 16, "%s", RIGHT_YES);
	else 										format(right[3], 16, "%s", RIGHT_NO);

	if (FRank[faction][listitem][rSpawn])		format(right[4], 16, "%s", RIGHT_YES);
	else 										format(right[4], 16, "%s", RIGHT_NO);

	if (FRank[faction][listitem][rChat])		format(right[5], 16, "%s", RIGHT_YES);
	else										format(right[5], 16, "%s", RIGHT_NO);

	if (FRank[faction][listitem][rTow])			format(right[6], 16, "%s", RIGHT_YES);
	else 										format(right[6], 16, "%s", RIGHT_NO);

	if (FRank[faction][listitem][rBodyCam])		format(right[7], 16, "%s", RIGHT_YES);
	else 										format(right[7], 16, "%s", RIGHT_NO);

	if (FRank[faction][listitem][r_eRights])	format(right[8], 16, "%s", RIGHT_YES);
	else 										format(right[8], 16, "%s", RIGHT_NO);

	for(new i = 0; i < 9; i++)
	{
		format(faction_rights, sizeof(faction_rights), "%s\n%s\t%s\t%s", faction_rights, RS[i][right_name], right[i], RS[i][right_cmd]);
	}

	new title[32];
	format(title, sizeof(title), "{9189EF}%s", FactionRanks[faction][listitem]);
	SetPVarInt(playerid, "Faction:RankEdit", listitem+1);

	Dialog_Show(playerid, FactionSettings_Set, DIALOG_STYLE_TABLIST_HEADERS, title, faction_rights, "Edit", "Return");
	
	return 1;
}

ShowMyRights(playerid)
{
	new faction_rights[512] = "{FFFFFF}Right\tAccess\tCMD";
	new right[9][16], faction = PlayerInfo[playerid][pFaction], rank = PlayerInfo[playerid][pRank]-1;

	if (FRank[faction][rank][rInvite])		format(right[0], 16, "%s", RIGHT_YES);
	else 									format(right[0], 16, "%s", RIGHT_NO);

	if (FRank[faction][rank][rUninvite])	format(right[1], 16, "%s", RIGHT_YES);
	else									format(right[1], 16, "%s", RIGHT_NO);

	if (FRank[faction][rank][rRank])		format(right[2], 16, "%s", RIGHT_YES);
	else 									format(right[2], 16, "%s", RIGHT_NO);

	if (FRank[faction][rank][r_eRank])		format(right[3], 16, "%s", RIGHT_YES);
	else 									format(right[3], 16, "%s", RIGHT_NO);

	if (FRank[faction][rank][rSpawn])		format(right[4], 16, "%s", RIGHT_YES);
	else 									format(right[4], 16, "%s", RIGHT_NO);

	if (FRank[faction][rank][rChat])		format(right[5], 16, "%s", RIGHT_YES);
	else									format(right[5], 16, "%s", RIGHT_NO);

	if (FRank[faction][rank][rTow])			format(right[6], 16, "%s", RIGHT_YES);
	else 									format(right[6], 16, "%s", RIGHT_NO);

	if (FRank[faction][rank][rBodyCam])			format(right[7], 16, "%s", RIGHT_YES);
	else 									format(right[7], 16, "%s", RIGHT_NO);

	if (FRank[faction][rank][r_eRights])	format(right[8], 16, "%s", RIGHT_YES);
	else 									format(right[8], 16, "%s", RIGHT_NO);

	for(new i = 0; i < 9; i++)
	{
		format(faction_rights, sizeof(faction_rights), "%s\n%s\t%s\t%s", faction_rights, RS[i][right_name], right[i], RS[i][right_cmd]);
	}

	new title[32];
	format(title, sizeof(title), "{9189EF}%s", FactionRanks[faction][rank]);
	Dialog_Show(playerid, None, DIALOG_STYLE_TABLIST_HEADERS, title, faction_rights, "Dong", "");
	return 1;
}

Dialog:MODEL_SELECTION_UNIFORM(playerid, response, listitem, inputtext[])
{
	if (!response) return 1;

	if (!PlayerInfo[playerid][pOnDuty])	 return SendErrorMessage(playerid, "De thay doi hinh thuc ban can trong gio lam viec (/duty).");
	if (!IsPlayerAtUniform(playerid))	 return SendErrorMessage(playerid, "Ban khong o trong phong thay doi.");
	if (PlayerInfo[playerid][pSwatDuty]) return SendErrorMessage(playerid, "Dat S.W.A.T cua ban xuong. thiet bi truoc khi thay dong phuc cua ban. ");

	new modelid,
		faction = PlayerInfo[playerid][pFaction];

	if (IsFactionPolice(faction)) 								modelid = police_skins[listitem];
	else if (IsFactionMedic(faction) || IsFactionFire(faction))	modelid = fd_skins[listitem];
	else if (IsFactionDocs(faction))								modelid = docs_skins[listitem];
	else if (IsFactionCity(faction))								modelid = city_skins[listitem];
			
	PlayerInfo[playerid][pChar] = modelid;
	SetPlayerSkin(playerid, modelid);
	Save_User(playerid);
	return 1;
}

Dialog:MODEL_SELECTION_SHAPE(playerid, response, listitem, inputtext[])
{
	if (!response) return 1;

	if (!IsFactionFire(PlayerInfo[playerid][pFaction])) return SendErrorMessage(playerid, "Ban phai la mot nguoi linh cuu hoa.");
	if (!PlayerInfo[playerid][pOnDuty])					return SendErrorMessage(playerid, "De thay doi hinh thuc ban can trong gio lam viec (/duty). ");
	
	if (listitem == 0)		listitem = 277;
	else if (listitem == 1)	listitem = 278;
	else if (listitem == 2)	listitem = 279;
	else if (listitem == 3)	listitem = 191;

	SetPlayerSkin(playerid, listitem);
	return 1;
}

Dialog:MODEL_SELECTION_BORT(playerid, response, listitem, inputtext[])
{
	if (!response) return 1;

    new faction = PlayerInfo[playerid][pFaction];

	if (!IsFactionLegal(faction))		return SendErrorMessage(playerid, "Ban phai la canh sat / nhan vien nha tu / nhan vien y te.");
    if (IsPlayerInAnyVehicle(playerid))	return SendErrorMessage(playerid, "Ban khong duoc o trong phuong tien.");
    if (!PlayerInfo[playerid][pOnDuty])	return SendErrorMessage(playerid, "Ban can phai trong gio lam viec (/duty).");

	for(new i=0; i<MAX_BORTES;i++)
	{
	    if (BortInfo[playerid][i][bortOn] != 0) continue;

		new modelid;
		if (IsFactionMedic(faction) || IsFactionFire(faction))	modelid = bort_list_fd[listitem];
		else if (IsFactionCity(faction))						modelid = bort_list_city[listitem];
		else													modelid = bort_list[listitem];
	
	    new Float:x, Float:y, Float:z;

	  	GetXYInFrontOfPlayer(playerid, x, y, z, 1.5);

		BortInfo[playerid][i][bortOn] = 1;
		BortInfo[playerid][i][bortUsing] = 0;
		BortInfo[playerid][i][bortObject] = CreateDynamicObject(modelid, x, y, z - 0.5, 0.0, 0.0, 0.0, GetWorld(playerid), GetInterior(playerid));
		EditDynamicObject(playerid, BortInfo[playerid][i][bortObject]);
		format(BortInfo[playerid][i][bortName], 32, "%s", (IsFactionMedic(faction) || IsFactionFire(faction))?(bort_names_fd[listitem]):((IsFactionCity(faction))?(bort_names_city[listitem]):(bort_names[listitem])));

		pTemp[playerid][pEditBort] = i+1;
	    return 1;
	}

	SendErrorMessage(playerid, "Da dat den gioi han tao doi tuong (15).");
    return 1;
}

FireOnline()
{
    new count = 0;
    foreach(new i : Player)
    {
        if (IsPlayerLogged(i) == 0)		continue;
		if (IsPlayerFactionFire(i))	continue;
		if (IsPlayerAFK(i))				continue;
		if (!PlayerInfo[i][pOnDuty])		continue;
		
        count++;
    }
   	if (count < NEED_FIRE_TO_CRIME)	return 0;
	else 							return 1; 
}