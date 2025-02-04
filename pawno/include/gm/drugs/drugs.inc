stock Drugs_OnPlayerStateChange(playerid, newstate)
{
    if (newstate == PLAYER_STATE_SPAWNED)
	{
		new Float: health = 100.0;
			
		switch(pTemp[playerid][pDrugUse])
		{
		    case INV_GANJA, INV_MED_GANJA: health += 5.0;
		    case INV_DRUG: health += 15.0;
		}
		SetPlayerHealth(playerid, health);
		SetPlayerArmour(playerid, PlayerInfo[playerid][pArmour]);
	}
    return 1;
}

stock Drugs_OnGameModeInit()
{
    return mysql_tquery(dbHandle, "SELECT * FROM `plants`", "LoadDynamicPlants");
}

stock Drugs_OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if (!IsPlayerInAnyVehicle(playerid) && PRESSING(newkeys, KEY_AIM) && pTemp[playerid][pDemolitionTime]) 		SetPlayerDrunkLevel(playerid, 50000);
	else if (!IsPlayerInAnyVehicle(playerid) && PRESSING(oldkeys, KEY_AIM) && pTemp[playerid][pDemolitionTime])	SetPlayerDrunkLevel(playerid, 1000);
	if (PRESSING(newkeys, KEY_SPRINT) && pTemp[playerid][pDrugUse] == INV_COCAINE && random(10) == 0)			ApplyAnimation(playerid, "PED", "FALL_collapse", 4.1, 0, 1, 1, 0, 0);

    if (HOLDING(KEY_FIRE) && IsPlayerAttachedObjectSlotUsed(playerid, ATTACH_HANDS) && GetPVarInt(playerid, #use_ganja) && GetPVarInt(playerid, #time_ganja) < gettime())
	{
	    SetPVarInt(playerid, #time_ganja, gettime()+2);
		SetPVarInt(playerid, #use_ganja, GetPVarInt(playerid, #use_ganja)-1);
		if (GetPVarInt(playerid, #use_ganja) == 0)
		{
		    DeletePVar(playerid, #use_ganja);
			RemovePlayerAttachedObject(playerid, ATTACH_HANDS);
		}
		else
		{
			ApplyAnimation(playerid, "GANGS", "SMKCIG_PRTL", 4.1, 0, 0, 0, 0, 0, 1);
		}
	}
	return 1;
}

stock Drugs_PlayerTimer(playerid)
{
	if (pTemp[playerid][pDemolitionTime])
	{
		if (pTemp[playerid][pDemolitionTime] < gettime())
		{
		    pTemp[playerid][pDemolitionTime] = gettime() + 600*2;

		    new Float: phealth, Float: minus = (PlayerInfo[playerid][pDependence] >= 70) ? (20.0) : (10.0);

		    AntiCheatGetHealth(playerid, phealth);

			if (!random(5) && !IsPlayerInAnyVehicle(playerid) && !PlayerInfo[playerid][pInjured])
			{
				OnPlayAnim(playerid, "FOOD", "EAT_Vomit_P", 3.0, 0, 0, 0, 0, 0);
			}
               
			if (phealth - minus > 10.0)	SetPlayerHealth(playerid, phealth - minus);
			else						SetPlayerHealth(playerid, 10.0);
		}
 		
		SetPlayerWeather(playerid, 20);
		
	}
		
	if (PlayerInfo[playerid][pDemolition])	PlayerInfo[playerid][pDemolition]--;
		    
	if (PlayerInfo[playerid][pDemolition] == 1 && PlayerInfo[playerid][pDependence] >= 40)
	{
	    PlayerInfo[playerid][pDemolition] = 600 + random(1200);
	    SendSyntaxMessage(playerid, "Ban da len con nghien. Cu sau 20 phut ban se mat %i HP.", (PlayerInfo[playerid][pDependence] >= 70) ? (20) : (10));
		SendHelpMessage(playerid, "Ban can dung thuoc de ngan con.");
	    SetPlayerWeather(playerid, 20);
	    pTemp[playerid][pDemolitionTime] = gettime();
	}
	
	if (pTemp[playerid][pDrugUse] != 0 && pTemp[playerid][pDrugTime] < gettime())
	{
		pTemp[playerid][pDrugUse] = 0;
		pTemp[playerid][pDrugTime] = 0;
		SetPlayerCurrentTimeAndWeather(playerid);
	}
	
	else if ((pTemp[playerid][pDrugUse] == INV_GANJA || pTemp[playerid][pDrugUse] == INV_MED_GANJA) && pTemp[playerid][pDrugTime] > gettime())
	{
		SetPlayerTime(playerid, 21, 0);
		SetPlayerWeather(playerid, 229);
	}

	return 1;
}

Drug_OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	new Float:oldX, Float:oldY, Float:oldZ, Float:oldRotX, Float:oldRotY, Float:oldRotZ;
	
	GetDynamicObjectPos(objectid, oldX, oldY, oldZ);
	GetDynamicObjectRot(objectid, oldRotX, oldRotY, oldRotZ);

	if (GetPVarInt(playerid, #edit_drug) != 0 && (response == EDIT_RESPONSE_FINAL || response == EDIT_RESPONSE_CANCEL))
	{
	    new id = GetPVarInt(playerid, #edit_drug)-1;
	    DeletePVar(playerid, #edit_drug);

	    if (GetDistanceBetweenPoints(x, y, z, oldX, oldY, oldZ) > 10.0)
	    {
     		SetDynamicObjectPos(objectid, DropChemistry[id][dropPosX], DropChemistry[id][dropPosY], DropChemistry[id][dropPosZ]);
        	SetDynamicObjectRot(objectid, DropChemistry[id][dropPosRX], DropChemistry[id][dropPosRY], DropChemistry[id][dropPosRZ]);
	        return SendErrorMessage(playerid, "Doi tuong qua xa so voi vi tri bat dau.");
	    }

	    if (objectid != DropChemistry[id][dropObject]) return SendErrorMessage(playerid, "Loi chinh sua vat pham. ");

		SetDynamicObjectPos(objectid, x, y, z);
		SetDynamicObjectRot(objectid, rx, ry, rz);

		ChemistryDrop_Update(id);

		ApplyAnimation(playerid, "carry", "putdwn", 1, 0, 1, 1, 0, 1000);
		//ApplyAnimation(playerid, "carry", "putdwn", 1, 0, 1, 1, 0, 1000);
	}
	return 1;
}

this::startReacting(idx)
{
	if (Chemistry[idx][Control] == 1) // ����������
	{
		if (Chemistry[idx][Temperature] > Chemistry[idx][curTemperature])
		{
			Chemistry[idx][curTemperature] += 0.01*random(5);
			if (Chemistry[idx][curTemperature] > 10.0) Chemistry[idx][curTemperature] += 0.1*random(5);
			if (Chemistry[idx][curTemperature] > 50.0) Chemistry[idx][curTemperature] += 0.2*random(10);
		}
	}
	else if (Chemistry[idx][Control] == 2) // ����������
	{
		if (Chemistry[idx][Temperature] < Chemistry[idx][curTemperature])
		{
			if (Chemistry[idx][curTemperature] < 0)
			{
				Chemistry[idx][curTemperature] -= 0.01*random(5);
				if (Chemistry[idx][curTemperature] < -10.0) Chemistry[idx][curTemperature] -= 0.1*random(5);
				if (Chemistry[idx][curTemperature] < -50.0) Chemistry[idx][curTemperature] -= 0.2*random(10);
			}
			else if (Chemistry[idx][curTemperature] > 0)
			{
				Chemistry[idx][curTemperature] -= 0.01*random(5);
				if (Chemistry[idx][curTemperature] > 10.0) Chemistry[idx][curTemperature] -= 0.2*random(10);
				if (Chemistry[idx][curTemperature] > 50.0) Chemistry[idx][curTemperature] -= 0.1*random(5);
			}
		}
	}
	else return 1; // �������

	if (Chemistry[idx][Temperature] != 0)
	{
		format(gString, sizeof(gString), "{ffffff}Lo phan ung\n{b5c8b6}%.1f / gram\n\n{FFFF00}[ %s%.2f 'do C' ]", Chemistry[idx][Amount], (Chemistry[idx][curTemperature] > 0) ? ("+") : (""), Chemistry[idx][curTemperature]);
		UpdateDynamic3DTextLabelText(Chemistry[idx][osLabel], 0x008080FF, gString);

		if ((Chemistry[idx][curTemperature] > E_CHEMICAL[Chemistry[idx][Material]][POINT] + 3.0 && E_CHEMICAL[Chemistry[idx][Material]][CONTROL] == 1) || (Chemistry[idx][curTemperature] < E_CHEMICAL[Chemistry[idx][Material]][POINT] - 3.0 && E_CHEMICAL[Chemistry[idx][Material]][CONTROL] == 2))
		{
			Chemistry[idx][OverPoint] ++;
			if (Chemistry[idx][OverPoint] >= 40)
			{
				UpdateDynamic3DTextLabelText(Chemistry[idx][osLabel], COLOR_LIGHTRED, "NGUOI PHAN UNG DANG O TRANG THAI TIN NGUONG!!");
				
				new Float:bp_X, Float:bp_Y, Float:bp_Z, bp_vw, bp_int, 
					f = Chemistry[idx][FurnID], building = Chemistry[idx][BuildingID];
					
				switch(Chemistry[idx][BuildingType])
				{
					case 0: {
						bp_X = HFurn[building][f][fPosX];
						bp_Y = HFurn[building][f][fPosY];
						bp_Z = HFurn[building][f][fPosZ];
						bp_vw = HFurn[building][f][fVirtualWorld];
						bp_int = HFurn[building][f][fInterior];
					} case 1: {
						bp_X = BFurn[building][f][fPosX];
						bp_Y = BFurn[building][f][fPosY];
						bp_Z = BFurn[building][f][fPosZ];
						bp_vw = BFurn[building][f][fVirtualWorld];
						bp_int = BFurn[building][f][fInterior];
					} case 2: {
						bp_X = GFurn[building][f][fPosX];
						bp_Y = GFurn[building][f][fPosY];
						bp_Z = GFurn[building][f][fPosZ];
						bp_vw = GFurn[building][f][fVirtualWorld];
						bp_int = GFurn[building][f][fInterior];
					} 
				}
				
				Chemistry[idx][reactorSmoke] = CreateDynamicObject(18723, bp_X, bp_Y-0.2, bp_Z+0.4, 0.0, 0.0, 0.0, bp_vw, bp_int, -1, 300.0);

				if (Chemistry[idx][OverPoint] >= 80)
				{
					switch(E_CHEMICAL[Chemistry[idx][Material]][STATUS])
					{
						case 0: CreateReactorExplosion(idx, f); // non-stable
						case 1: // stable
						{
							new Float:fHitPosX = bp_X, 
								Float:fHitPosY = bp_Y,
								Float:fHitPosZ = bp_Z,
								furnint = bp_int,
								furnvw = bp_vw
							;

							new fireid = -1;
							for(new j; j != MAX_FIRES; j++)
							{
								if (FiresInfo[j][fireOn] != 0) continue;

								fireid = j;
								break;
							}
							if (fireid != -1)
							{
								FiresInfo[fireid][fireOn] = 1;
								FiresInfo[fireid][fireObj] = CreateDynamicObject(18691, fHitPosX, fHitPosY, fHitPosZ-2.0, 0.0, 0.0, 0.0, furnvw, furnint);
								FiresInfo[fireid][firePos][0] = fHitPosX;
								FiresInfo[fireid][firePos][1] = fHitPosY;
								FiresInfo[fireid][firePos][2] = fHitPosZ;
								FiresInfo[fireid][fireVW] = furnvw;
								FiresInfo[fireid][fireInt] = furnint;
								FiresInfo[fireid][fireHealth] = 100;
								FiresInfo[fireid][fireTimer] = 1800;

								FiresInfo[fireid][fireLabel] = CreateDynamic3DTextLabel("100 %", 0xCC0500FFF, fHitPosX, fHitPosY, fHitPosZ+2.3, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, furnvw, furnint, -1, 100.0);
							}

							ClearFurnitureData(f, idx);
							OnPlayerSellFurniture(Chemistry[idx][BuildingType], Chemistry[idx][BuildingID], f);
						}
					}
				}
			}
		}
		else if (Chemistry[idx][curTemperature] - E_CHEMICAL[Chemistry[idx][Material]][POINT] < 2.5 && Chemistry[idx][curTemperature] - E_CHEMICAL[Chemistry[idx][Material]][POINT] > -2.5)
		{
			Chemistry[idx][OverPoint] ++;
			if (Chemistry[idx][OverPoint] == 3600)
			{
				Chemistry[idx][OverPoint] = -1;
			}
		}
		else Chemistry[idx][OverPoint] = 0;

		if (Chemistry[idx][OverPoint] == -1)
		{
			KillTimer(Chemistry[idx][Timer]);
			Chemistry[idx][curTemperature] = 0.0;
			Chemistry[idx][Temperature] = 0.0;
			format(gString, sizeof(gString), "{ffffff}Lo phan ung\n{FFFF00}(Ket tinh)\n{C3C3C3}%s (OAS: %.1f%%)\n{C0C0C0}/reactor", E_CHEMICAL[Chemistry[idx][Material]][NAME], Chemistry[idx][Quality]);
			UpdateDynamic3DTextLabelText(Chemistry[idx][osLabel], 0x008080FF, gString);
			Chemistry[idx][OverPoint] = 0;
		}
	}
	return 1;
}

this::mintueMixing(idx)
{
	if (Chemistry[idx][IsWorking])
	{
		Chemistry[idx][NeedTime]--;
		
		if (Chemistry[idx][NeedTime] > 0)
		{
			switch(Chemistry[idx][WorkType])
			{
				case 1: format(gString, sizeof(gString), "{FFFFFF}Nha may say kho\n{b5c8b6}(%s+%s+%s)\n{39c622}[ %d phut ]", E_CHEMICAL[Chemistry[idx][Extra][0]][CODE], E_CHEMICAL[Chemistry[idx][Extra][1]][CODE], E_CHEMICAL[Chemistry[idx][Extra][2]][CODE], Chemistry[idx][NeedTime]);
				case 2: format(gString, sizeof(gString), "{FFFFFF}May ly tam\n{b5c8b6}(%s+%s+%s)\n{39c622}[ %d phut ]", E_CHEMICAL[Chemistry[idx][Extra][0]][CODE], E_CHEMICAL[Chemistry[idx][Extra][1]][CODE], E_CHEMICAL[Chemistry[idx][Extra][2]][CODE], Chemistry[idx][NeedTime]);
			}
			UpdateDynamic3DTextLabelText(Chemistry[idx][osLabel], 0x008080FF, gString);
		}

		else if (Chemistry[idx][NeedTime] == 0)
		{
		    Chemistry[idx][IsWorking] = false;
			switch(Chemistry[idx][WorkType])
			{	
				case 1: format(gString, sizeof(gString), "{FFFFFF}Nha may say kho\n{C3C3C3}[ SAN SANG ]");
				case 2: format(gString, sizeof(gString), "{FFFFFF}May ly tam\n{C3C3C3}[ SAN SANG ]"); 
			}
			UpdateDynamic3DTextLabelText(Chemistry[idx][osLabel], 0xFFFFFFFF, gString);
			KillTimer(Chemistry[idx][Timer]);
	    }
    }
	return 1;
}

