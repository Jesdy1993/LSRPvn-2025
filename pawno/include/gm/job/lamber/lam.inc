LumberJack_OnGameModeInit()
{
	for(new i; i < MAX_TREES; i++)
	{
		TreeData[i][treeObjID] = TreeData[i][treeTimer] = -1;
		TreeData[i][treeLabel] = Text3D: -1;
	}
	
	for(new i; i < MAX_LOGS; i++)
	{
	    LogData[i][logObjID] = LogData[i][logTimer] = -1;
	    LogData[i][logLabel] = Text3D: -1;
	}
	
	for(new i; i < MAX_BUYERS; i++)
	{
	    BuyerData[i][buyerActorID] = -1;
	    BuyerData[i][buyerLabel] = Text3D: -1;
	}
	
	for(new i; i < MAX_VEHICLES; i++) for(new x; x < LOG_LIMIT; x++) LogObjects[i][x] = -1;
	
	foreach(new i : Player) Player_Init(i);
	return 1;
}


LumberJack_OnPlayerConnect(playerid)
{
	Player_Init(playerid);
	return 1;
}

LumberJack_OnPlayerDisconnect(playerid)
{
	Player_ResetCutting(playerid);
	Player_RemoveLog(playerid);
	
	EditingTreeID[playerid] = -1;
	return 1;
}

LumberJack_OnVehicleSpawn(vehicleid)
{
	Vehicle_RemoveLogs(vehicleid);
	return 1;
}

LumberJack_OnVehicleDeath(vehicleid)
{
	Vehicle_RemoveLogs(vehicleid);
	return 1;
}

LumberJack_OnPlayerDeath(playerid)
{
    Player_ResetCutting(playerid);
    Player_DropLog(playerid, 1);
	return 1;
}

LumberJack_OnPlayerStateChange(playerid, newstate)
{
	if (newstate != PLAYER_STATE_WASTED)
	{
	    Player_ResetCutting(playerid);
	    Player_RemoveLog(playerid);
	}
	
	return 1;
}

stock Lumber_OnPlayerKeyStateChange(playerid, newkeys)
{
	if (PRESSING(newkeys, KEY_FIRE) && PlayerInfo[playerid][pJob] == JOB_LAMBERJACKER)
	{
	    if (CarryingLog[playerid]) return Player_DropLog(playerid);
	    
		if(PlayerInfo[playerid][pPlayerWeapon] == 9 && CuttingTreeID[playerid] == -1 && !CarryingLog[playerid])
		{
			new id = GetNearTree(playerid);

			if (id != -1)
			{
				if (!Tree_BeingEdited(id) && !TreeData[id][treeGettingCut] && TreeData[id][treeSeconds] < 1)
				{
					SetPlayerLookAt(playerid, TreeData[id][treeX], TreeData[id][treeY]);

					Streamer_SetIntData(STREAMER_TYPE_3D_TEXT_LABEL, TreeData[id][treeLabel], E_STREAMER_COLOR, 0xE74C3CFF);
					CuttingTimer[playerid] = SetTimerEx("CutTree", 1000, true, "i", playerid);
					CuttingTreeID[playerid] = id;
					SetPlayerProgressBarValue(playerid, CuttingBar[playerid], 0.0);
					ShowPlayerProgressBar(playerid, CuttingBar[playerid]);
					ApplyAnimation(playerid, "CHAINSAW", "WEAPON_csaw", 4.1, 1, 0, 0, 1, 0, 1);

					TreeData[id][treeGettingCut] = true;
				}
			}
		}
	}
	return 1;
}

LJob_OnPlayerEditDynamicObject(playerid, STREAMER_TAG_OBJECT objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	if (EditingTreeID[playerid] != -1 && Iter_Contains(Trees, EditingTreeID[playerid]))
	{
	    if (response == EDIT_RESPONSE_FINAL)
	    {
	        new id = EditingTreeID[playerid];
	        TreeData[id][treeX] = x;
	        TreeData[id][treeY] = y;
	        TreeData[id][treeZ] = z;
	        TreeData[id][treeRX] = rx;
	        TreeData[id][treeRY] = ry;
	        TreeData[id][treeRZ] = rz;

	        SetDynamicObjectPos(objectid, TreeData[id][treeX], TreeData[id][treeY], TreeData[id][treeZ]);
	        SetDynamicObjectRot(objectid, TreeData[id][treeRX], TreeData[id][treeRY], TreeData[id][treeRZ]);

			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, TreeData[id][treeLabel], E_STREAMER_X, TreeData[id][treeX]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, TreeData[id][treeLabel], E_STREAMER_Y, TreeData[id][treeY]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, TreeData[id][treeLabel], E_STREAMER_Z, TreeData[id][treeZ] + 1.5);

			new query[128 + 56];
			mysql_format(dbHandle, query, sizeof(query), "UPDATE `trees` SET `PosX` = %f, `PosY` = %f, `PosZ` = %f, `RotX` = %f, `RotY` = %f, `RotZ` = %f WHERE `id` = %i", x, y, z, rx, ry, rz, id);
			mysql_tquery(dbHandle, query);

	        EditingTreeID[playerid] = -1;
	    }

	    if (response == EDIT_RESPONSE_CANCEL)
	    {
	        new id = EditingTreeID[playerid];
	        SetDynamicObjectPos(objectid, TreeData[id][treeX], TreeData[id][treeY], TreeData[id][treeZ]);
	        SetDynamicObjectRot(objectid, TreeData[id][treeRX], TreeData[id][treeRY], TreeData[id][treeRZ]);
	        EditingTreeID[playerid] = -1;
	    }
	}

	return 1;
}