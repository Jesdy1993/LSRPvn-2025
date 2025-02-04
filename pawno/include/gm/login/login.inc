Login_OnPlayerDisconnect(playerid, reason)
{
    if (IsPlayerNPC(playerid)) return 1;

    new reason_name[3][18] = {" (crash)", "", " (kicked/banned)"};

    DisableWaypoint(playerid);
	ResetDamages(playerid);
	DestroyAllBort(playerid);
    Destroy_Boombox(playerid);

	if (GetPVarInt(playerid, #Chase_Timer)) KillTimer(GetPVarInt(playerid, #Chase_Timer));

	DeletePVar(playerid, "Admin:CodeInputted");

    if (IsAdminDuty(playerid)) server_admins--;

	if (TaxiMade[playerid])
	{
		GiveCash(playerid, TaxiMade[playerid]);
        TaxiMade[playerid] = 0;
	}
    
	if (GetPVarInt(playerid, #show_fish) == 1)
	{
	    DeletePVar(playerid, #show_fish);
	    
		for(new i; i < MAX_FISH_ZONES; i++) GangZoneHideForPlayer(playerid, gz_fish[i]);
	}

	if (IsValidVehicle(JackingVehicle[playerid]))
	{
		new Float:ccX, Float:ccY, Float:ccZ;
		GetVehiclePos(JackingVehicle[playerid], ccX, ccY, ccZ);

	    VehicleInfo[JackingVehicle[playerid]][ePhysicalAttack] = false;
	    DestroyDynamic3DTextLabel(VehicleInfo[JackingVehicle[playerid]][eVehicleLabel]);
	    VehicleInfo[JackingVehicle[playerid]][vCooldown] = false;
	    JackingVehicle[playerid] = 0;
	}

    pTemp[playerid][pRamType] =
    pTemp[playerid][pRamTime] = 0;

    if (IsValidDynamicObject(pTemp[playerid][pRamObj]))
	{
		DestroyDynamicObject(pTemp[playerid][pRamObj]);
		pTemp[playerid][pRamObj] = INVALID_OBJECT_ID;
	}

	if (GetPVarInt(playerid, "3DLabel"))
    {
		DestroyDynamic3DTextLabel(Text3D:GetPVarInt(playerid, "3DLabel"));
		DeletePVar(playerid, "3DLabel");
    }

    if (pTemp[playerid][pPatrol])
	{
	    new id = pTemp[playerid][pPatrol]-1;
	    pTemp[playerid][pPatrol] = 0;

        if (PatrolInfo[GetPatrolID(playerid)][id][patrulOfficer][0] == playerid) PatrolInfo[GetPatrolID(playerid)][id][patrulOfficer][0] = INVALID_PLAYER_ID;
        if (PatrolInfo[GetPatrolID(playerid)][id][patrulOfficer][1] == playerid) PatrolInfo[GetPatrolID(playerid)][id][patrulOfficer][1] = INVALID_PLAYER_ID;
		if (PatrolInfo[GetPatrolID(playerid)][id][patrulOfficer][0] == INVALID_PLAYER_ID && PatrolInfo[GetPatrolID(playerid)][id][patrulOfficer][0] == INVALID_PLAYER_ID) PatrolInfo[GetPatrolID(playerid)][id][patrulExists] = 0;

	    SendFactionMessage(FACTION_POLICE, COLOR_POLICECHAT, "[DISP] %s %s roi khoi cuoc tuan tra duoi nhan hieu %s%s.", GetRankName(playerid), GetNameEx(playerid), PatrolInfo[GetPatrolID(playerid)][id][patrulName], reason_name[reason]);
	}

    if (IsPlayerPhoneCreated(playerid)) Phone_Hide(playerid);

	if (pTemp[playerid][p3DMenu] != -1)
	{
    	Destroy3DMenu(pTemp[playerid][p3DMenu]);
		pTemp[playerid][p3DMenu] = -1;
	}

	if (pTemp[playerid][pTracePlayer] != INVALID_PLAYER_ID)
	{
	    pTemp[playerid][pTracePlayer] = INVALID_PLAYER_ID;
		pTemp[playerid][pTraceStage] = 0;
		if (pTemp[playerid][pTraceGZ] != -1) GangZoneDestroy(pTemp[playerid][pTraceGZ]);
		pTemp[playerid][pTraceGZ] = -1;
	}

	if (IsValidDynamic3DTextLabel(PrisonLabel[playerid]))
	{
		DestroyDynamic3DTextLabel(PrisonLabel[playerid]);
        PrisonLabel[playerid] = Text3D:INVALID_3DTEXT_ID;
	}

    if (pTemp[playerid][pInteriorBiz] != 0)
	{
		SetPlayerBuyInterior(playerid, 0);
        pTemp[playerid][pInteriorBiz] = 0;
	}
	
	if (pTemp[playerid][pZond] != 0)
	{
		SetPlayerZond(playerid, 0);
        pTemp[playerid][pZond] = 0;
	}

	if (PlayerInfo[playerid][pInjured] == 3) 
	{
		if (IsValidDynamic3DTextLabel(status_upd[playerid])) DestroyDynamic3DTextLabel(status_upd[playerid]);
	}

    if (pTemp[playerid][pPayphone] != -1)
    {
		PayphoneInfo[pTemp[playerid][pPayphone]][phUsed] = INVALID_PLAYER_ID;
		pTemp[playerid][pPayphone] = -1;
	}
	
	if (pTemp[playerid][pCallLine] != INVALID_PLAYER_ID)
	{
	    if (IsPlayerLogged(pTemp[playerid][pCallLine])) SendPhoneMessage(pTemp[playerid][pCallLine], "Lien lac voi nguoi dang ky da bi cat ... ");
		HangupCall(playerid);
	}
	
	if (IsPlayerLogged(playerid))
	{
	    foreach(new i : Player)
		{
			if(pTemp[i][pSpecPlayer] == playerid) TogglePlayerSpectating(i, 0);

			if (!IsPlayerLogged(i))
				SendClientMessageEx(i, COLOR_GRAD2, "* %s da thoat%s.", GetNameEx(playerid), reason_name[reason]);

			if (!(PlayerInfo[i][pSettings] & togJoin))
			{
				if (CheckAdmin(i, ADMIN_LEVEL_1))
					SendClientMessageEx(i, COLOR_GRAD2, "*** %s da thoat khoi may chu%s (cash: $%s, bank: $%s)", GetNameEx(playerid), reason_name[reason], FormatNumber(PlayerInfo[playerid][pCash]), FormatNumber(PlayerInfo[playerid][pBank]));

				else if (GetPlayerDistanceFromPlayer(playerid, i) < 15.0 && GetWorld(playerid) == GetWorld(i) && GetInterior(playerid) == GetInterior(i))
                	SendClientMessageEx(i, COLOR_GRAD2, "* %s da thoat%s.", GetNameEx(playerid), reason_name[reason]);
			}
		}

		if (pTemp[playerid][pRentveh] != 0)
		{
		    new vehicle = pTemp[playerid][pRentveh];

    		VehicleInfo[vehicle][carTerminate] = 600;
    		pTemp[playerid][pRentveh] = 0;
    	}
		if (PlayerInfo[playerid][pCarKey] != 0)
		{
			new vehicle = PlayerInfo[playerid][pCarKey];
			if(VehicleInfo[vehicle][carOwnerID] == PlayerInfo[playerid][pID])
			{
				Save_Car(vehicle);
				DestroyVehicle(vehicle);
				PlayerInfo[playerid][pCarKey] = 0;
			}
		}
		if (InfoSkate[playerid][sActive] == true)
		{
			InfoSkate[playerid][sActive] = false;
			DestroyDynamicObject(InfoSkate[playerid][sSkate]);
		}
		
		CheckPMBlockList(playerid);

		SQL_SetInteger("users", "online", 0, PlayerInfo[playerid][pID]);
		SQL_SetInteger("users", "last_login", gettime(), PlayerInfo[playerid][pID]);
		
		Save_User(playerid);
	}

	pTemp[playerid][pLogged] = 0;
	DestroyDynamic3DTextLabel(CustomNametag[playerid]);
	ResetPlayerVariables(playerid);

	Streamer_ToggleIdleUpdate(playerid, 0);
	return 1;
}

Login_OnPlayerConnect(playerid)
{
	SetPlayerCameraMoving(playerid);
    if (IsPlayerNPC(playerid)) return 1;
		
	for(new i = 0; i < 10; i++)
	{
		RemovePlayerAttachedObject(playerid, i);
	}
	CustomNametag[playerid] = CreateDynamic3DTextLabel("", -1, 0.0, 0.0, 0.0, 15.0, .attachedplayer = playerid, .testlos = 1);
	PreloadAnimations(playerid);
	StopAudioStreamForPlayer(playerid);
	ResetPlayerVariables(playerid);
	TDraw_OnPlayerConnect(playerid);
	Miner_OnPlayerConnect(playerid);
    TogglePlayerAllDynamicRaceCPs(playerid, false);
    SetPlayerColor(playerid, TEAM_HIT_COLOR);
	GetNameForPlayer(playerid);
	SetTimerEx("CheckAccount", 1500, false, "i", playerid);
	Streamer_ToggleIdleUpdate(playerid, 1);

    return 1;
}

Login_OnPlayerSpawn(playerid)
{
    if (!IsPlayerLogged(playerid))
	{
	    //SendErrorMessage(playerid, "Please login.");
		//KickEx(playerid);
		return 1;
	}

	SetPlayerFightingStyle(playerid, PlayerInfo[playerid][pFightStyle]);
	SetPlayerSkill(playerid);

	for(new i = 0; i < MAX_PLAYER_ATTACH; i++)
	{
	    RemovePlayerAttachedObject(playerid, i);
		
		if (!AttachInfo[playerid][i][aID] || !AttachInfo[playerid][i][aUsed]) continue;

		SetPlayerAttachedObject(playerid, i, AttachInfo[playerid][i][aModel], AttachInfo[playerid][i][aBone], AttachInfo[playerid][i][aOffsetX], AttachInfo[playerid][i][aOffsetY], AttachInfo[playerid][i][aOffsetZ], AttachInfo[playerid][i][aRotX], AttachInfo[playerid][i][aRotY], AttachInfo[playerid][i][aRotZ], AttachInfo[playerid][i][aScaleX], AttachInfo[playerid][i][aScaleY], AttachInfo[playerid][i][aScaleZ]);
	}

	SetPlayerWeapons(playerid);

	if (PlayerInfo[playerid][pChar] > 0 && PlayerInfo[playerid][pOnDuty])	SetPlayerSkin(playerid, PlayerInfo[playerid][pChar]);
	else																	SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
	
    SetPlayerCurrentTimeAndWeather(playerid);
    SetPlayerScore(playerid, PlayerInfo[playerid][pLevel]);
 	SetPlayerSpawn(playerid);
    CallRemoteFunction("LoadHolsters","i",playerid);
	return 1;
}

Login_PlayerTimer(playerid)
{
	if (pTemp[playerid][pLogged] == 1 && pTemp[playerid][pLoggedTime]++ >= AUTH_TIME)
	{
	    SendErrorMessage(playerid, "Mat khau khong duoc nhap trong vong %i giay.", AUTH_TIME); //���
		KickEx(playerid);
		return 0;
	}

	if (pTemp[playerid][pLogged] != 2) return 0;
	
	return 1;
}