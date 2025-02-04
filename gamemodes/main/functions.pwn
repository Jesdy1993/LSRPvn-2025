stock GetVehicleBoot(vehicleid, &Float:x, &Float:y, &Float:z)  // get vi tri trunk
{ 
    if (!GetVehicleModel(vehicleid) || vehicleid == INVALID_VEHICLE_ID) 
        return (x = 0.0, y = 0.0, z = 0.0), 0; 

    static 
        Float:pos[7] 
    ; 
    GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_SIZE, pos[0], pos[1], pos[2]); 
    GetVehiclePos(vehicleid, pos[3], pos[4], pos[5]); 
    GetVehicleZAngle(vehicleid, pos[6]); 

    x = pos[3] - (floatsqroot(pos[1] + pos[1]) * floatsin(-pos[6], degrees)); 
    y = pos[4] - (floatsqroot(pos[1] + pos[1]) * floatcos(-pos[6], degrees)); 
    z = pos[5]; 

    return 1; 
} 
/*  ---------------- FUNCTIONS ----------------- */
stock FIXES_valstr(dest[], value, bool:pack = false)
{
	// "format" can't handle cellmin properly.
	static const
		sc_szCellmin[] = !"-2147483648";
	if (value == cellmin)
	{
		pack && strpack(dest, sc_szCellmin, 12) || strunpack(dest, sc_szCellmin, 12);
	}
	else
	{
		format(dest, 12, "%d", value);
		pack && strpack(dest, dest, 12);
	}
	return 0;
}
stock RandomEx(min, max)
{
	max++;
	new a = random(max - min) + min;
	return a;
}
#if defined zombiemode
forward Float:GetPointDistanceToPoint(Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2);
Float:GetPointDistanceToPoint(Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2)
{
  new Float:x, Float:y, Float:z;
  x = x1-x2;
  y = y1-y2;
  z = z1-z2;
  return floatsqroot(x*x+y*y+z*z);
}
#endif


CheckPointCheck(iTargetID)  {
	if(GetPVarType(iTargetID, "hFind") > 0 || GetPVarType(iTargetID, "TrackCar") > 0 || GetPVarType(iTargetID, "DV_TrackCar") > 0 || GetPVarType(iTargetID, "Packages") > 0 || TaxiAccepted[iTargetID] != INVALID_PLAYER_ID || EMSAccepted[iTargetID] != INVALID_PLAYER_ID || BusAccepted[iTargetID] != INVALID_PLAYER_ID || gPlayerCheckpointStatus[iTargetID] != CHECKPOINT_NONE || MedicAccepted[iTargetID] != INVALID_PLAYER_ID || MechanicCallTime[iTargetID] >= 1) {
		return 1;
	}
	return 0;
}

NationSel_InitNationNameText(Text:txtInit)
{
  	TextDrawUseBox(txtInit, 0);
	TextDrawLetterSize(txtInit,1.25,3.0);
	TextDrawFont(txtInit, 0);
	TextDrawSetShadow(txtInit,0);
    TextDrawSetOutline(txtInit,1);
    TextDrawColor(txtInit,0xEEEEEEFF);
    TextDrawBackgroundColor(txtNationSelHelper,0x000000FF);
}

NationSel_InitTextDraws()
{
    // Init our observer helper text display
	txtSanAndreas = TextDrawCreate(10.0, 380.0, "");
	NationSel_InitNationNameText(txtSanAndreas);
	txtTierraRobada = TextDrawCreate(10.0, 380.0, "");
	NationSel_InitNationNameText(txtTierraRobada);

    // Init our observer helper text display
	txtNationSelHelper = TextDrawCreate(10.0, 415.0,
 	" Nhan ~b~~k~~GO_LEFT~ ~w~hoac ~b~~k~~GO_RIGHT~ ~w~de chuyen quoc tich.~n~ Nhan ~r~~k~~PED_FIREWEAPON~ ~w~de chon.");
	TextDrawUseBox(txtNationSelHelper, 1);
	TextDrawBoxColor(txtNationSelHelper,0x222222BB);
	TextDrawLetterSize(txtNationSelHelper,0.3,1.0);
	TextDrawTextSize(txtNationSelHelper,400.0,40.0);
	TextDrawFont(txtNationSelHelper, 2);
	TextDrawSetShadow(txtNationSelHelper,0);
    TextDrawSetOutline(txtNationSelHelper,1);
    TextDrawBackgroundColor(txtNationSelHelper,0x000000FF);
    TextDrawColor(txtNationSelHelper,0xFFFFFFFF);

	txtNationSelMain = TextDrawCreate(10.0, 50.0, "Ban hay chon quoc tich cua minh");
	TextDrawUseBox(txtNationSelMain, 0);
	TextDrawLetterSize(txtNationSelMain, 0.5, 1.0);
	TextDrawFont(txtNationSelMain, 1);
	TextDrawSetShadow(txtNationSelMain, 0);
    TextDrawSetOutline(txtNationSelMain, 1);
    TextDrawBackgroundColor(txtNationSelMain, 0x000000FF);
    TextDrawColor(txtNationSelMain, 0xFFFFFFFF);
}

NationSel_SetupSelectedNation(playerid)
{
	if(PlayerNationSelection[playerid] == -1) {
		PlayerNationSelection[playerid] = NATION_SAN_ANDREAS;
	}

	if(PlayerNationSelection[playerid] == NATION_SAN_ANDREAS) {
		SetPlayerInterior(playerid,0);
   		SetPlayerCameraPos(playerid,1630.6136,-2286.0298,110.0);
		SetPlayerCameraLookAt(playerid,1887.6034,-1682.1442,47.6167);

		TextDrawShowForPlayer(playerid,txtSanAndreas);
		TextDrawHideForPlayer(playerid,txtTierraRobada);
	}
	else if(PlayerNationSelection[playerid] == NATION_TIERRA_ROBADA) {
		SetPlayerInterior(playerid,0);
   		SetPlayerCameraPos(playerid,-1846.606201,1509.823120,123.755050);
		SetPlayerCameraLookAt(playerid,-1790.602783,892.187805,42.851142);

		TextDrawHideForPlayer(playerid,txtSanAndreas);
		TextDrawShowForPlayer(playerid,txtTierraRobada);
	}
}

NationSel_SwitchToNextNation(playerid)
{
    PlayerNationSelection[playerid]++;
	if(PlayerNationSelection[playerid] > NATION_TIERRA_ROBADA) {
	    PlayerNationSelection[playerid] = NATION_SAN_ANDREAS;
	}
	PlayerPlaySound(playerid,1052,0.0,0.0,0.0);
	NationSel_SetupSelectedNation(playerid);
	TogglePlayerControllable(playerid, 0);
}

NationSel_SwitchToPrevNation(playerid)
{
    PlayerNationSelection[playerid]--;
	if(PlayerNationSelection[playerid] < NATION_SAN_ANDREAS) {
	    PlayerNationSelection[playerid] = NATION_TIERRA_ROBADA;
	}
	PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
	NationSel_SetupSelectedNation(playerid);
	TogglePlayerControllable(playerid, 0);
}

NationSel_HandleNationSelection(playerid)
{
	new Keys,ud,lr;
	//new Float:diff = float(TRCitizens)/float(TotalCitizens)*100;
    GetPlayerKeys(playerid,Keys,ud,lr);

    if(PlayerNationSelection[playerid] == -1) {
		NationSel_SwitchToNextNation(playerid);
		return;
	}

	if(Keys & KEY_FIRE)
	{

	    return;
	}

	if(lr > 0) {
	   NationSel_SwitchToNextNation(playerid);
	}
	else if(lr < 0) {
	   NationSel_SwitchToPrevNation(playerid);
	}
}

OnPlayerChangeWeapon(playerid, newweapon)
{
	if(pTazer{playerid} == 1) SetPlayerArmedWeapon(playerid,23);
	if(GetPVarInt(playerid, "WeaponsHolstered") == 1)
	{
	    SetPlayerArmedWeapon(playerid, 0);
	}

 	if(GetPVarInt(playerid, "IsInArena") >= 0)
	{
	    new a = GetPVarInt(playerid, "IsInArena");
	    if(PaintBallArena[a][pbGameType] == 3)
	    {
	        if(PaintBallArena[a][pbFlagNoWeapons] == 1)
	        {
	        	if(GetPVarInt(playerid, "AOSlotPaintballFlag") != -1)
	        	{
					SetPlayerArmedWeapon(playerid, 0);
	        	}
			}
	    }
	}
	if(PlayerInfo[playerid][pAdmin] < 4)
	{
		if(GetPVarInt(playerid, "EventToken") != 0) return 1;
		if(GetPlayerState(playerid) == PLAYER_STATE_NONE || GetPlayerState(playerid) == PLAYER_STATE_DRIVER || GetPlayerState(playerid) == PLAYER_STATE_WASTED || GetPlayerState(playerid) == PLAYER_STATE_SPAWNED || GetPlayerState(playerid) == PLAYER_STATE_SPECTATING) return 1;

		if( PlayerInfo[playerid][pGuns][1] != 2 && GetPlayerWeapon( playerid ) == 2)
		{
		    //Code Here
		}
		else if( PlayerInfo[playerid][pGuns][1] != 3 && GetPlayerWeapon( playerid ) == 3)
		{
			ExecuteHackerAction( playerid, newweapon );
		}
		else if( PlayerInfo[playerid][pGuns][1] != 4 && GetPlayerWeapon( playerid ) == 4)
		{
		    if(PlayerInfo[playerid][pConnectHours] < 2 || PlayerInfo[playerid][pMember] != 8)
		    {
			    new WeaponName[32];
				GetWeaponName(newweapon, WeaponName, sizeof(WeaponName));
				new String[128];
	            format( String, sizeof( String ), "AdmCmd: %s da bi khoa tai khoan, ly do: Hack vu khi (%s).", GetPlayerNameEx(playerid), WeaponName );
				ABroadCast( COLOR_LIGHTRED, String, 2 );
				SendClientMessage(playerid, COLOR_LIGHTRED, String );
				SetPVarInt(playerid, "_HACK_WARNINGS", 0 );
				PlayerInfo[playerid][pBanned] = 3;
				new playerip[32];
				GetPlayerIp(playerid, playerip, sizeof(playerip));
				format( String, sizeof( String ), "AdmCmd: %s (IP:%s) da bi khoa tai khoan, ly do: Hack vu khi (%s)", GetPlayerNameEx(playerid), playerip, WeaponName);
				PlayerInfo[playerid][pBanned] = 3;
				Log("logs/ban.log", String);
				SystemBan(playerid, "[System] (Hack vu khi)");
				MySQLBan(GetPlayerSQLId(playerid), playerip, "Hack vu khi", 1,"System");
				SetTimerEx("KickEx", 1000, 0, "i", playerid);
				TotalAutoBan++;
			}
			ExecuteHackerAction( playerid, newweapon );
		}
		else if( PlayerInfo[playerid][pGuns][1] != 5 && GetPlayerWeapon( playerid ) == 5)
		{
			ExecuteHackerAction( playerid, newweapon );
		}
        else if( PlayerInfo[playerid][pGuns][1] != 6 && GetPlayerWeapon( playerid ) == 6)
		{
			ExecuteHackerAction( playerid, newweapon );
		}
		else if( PlayerInfo[playerid][pGuns][1] != 7 && GetPlayerWeapon( playerid ) == 7)
        {
            ExecuteHackerAction( playerid, newweapon );
        }
        else if( PlayerInfo[playerid][pGuns][1] != 8 && GetPlayerWeapon( playerid ) == 8)
        {
            ExecuteHackerAction( playerid, newweapon );
        }
        else if( PlayerInfo[playerid][pGuns][1] != 9 && GetPlayerWeapon( playerid ) == 9)
        {
            if(PlayerInfo[playerid][pConnectHours] < 2)
		    {
			    new WeaponName[32];
				GetWeaponName(newweapon, WeaponName, sizeof(WeaponName));
				new String[128];
	            format( String, sizeof( String ), "AdmCmd: %s da bi khoa tai khoan, ly do: Hack vu khi (%s).", GetPlayerNameEx(playerid), WeaponName );
				ABroadCast( COLOR_LIGHTRED, String, 2 );
				SetPVarInt(playerid, "_HACK_WARNINGS", 0 );
				PlayerInfo[playerid][pBanned] = 3;
				new playerip[32];
				GetPlayerIp(playerid, playerip, sizeof(playerip));
				format( String, sizeof( String ), "AdmCmd: %s (IP:%s) da bi khoa tai khoan, ly do: Hack vu khi (%s)", GetPlayerNameEx(playerid), playerip, WeaponName);
				PlayerInfo[playerid][pBanned] = 3;
				Log("logs/ban.log", String);
				new ip[32];
				GetPlayerIp(playerid,ip,sizeof(ip));
				SystemBan(playerid, "[System] (Hack vu khi)");
				MySQLBan(GetPlayerSQLId(playerid),playerip,"Hack vu khi", 1,"System");
				SetTimerEx("KickEx", 1000, 0, "i", playerid);
				TotalAutoBan++;
			}
			ExecuteHackerAction( playerid, newweapon );
        }
        else if( PlayerInfo[playerid][pGuns][2] != 22 && GetPlayerWeapon( playerid ) == 22)
        {
            if(PlayerInfo[playerid][pConnectHours] < 2)
		    {
			    new WeaponName[32];
				GetWeaponName(newweapon, WeaponName, sizeof(WeaponName));
				new String[128];
	            format( String, sizeof( String ), "AdmCmd: %s da bi khoa tai khoan, ly do: Hack vu khi (%s).", GetPlayerNameEx(playerid), WeaponName );
				ABroadCast( COLOR_LIGHTRED, String, 2 );
				SetPVarInt(playerid, "_HACK_WARNINGS", 0 );
				PlayerInfo[playerid][pBanned] = 3;
				new playerip[32];
				GetPlayerIp(playerid, playerip, sizeof(playerip));
				format( String, sizeof( String ), "AdmCmd: %s (IP:%s) da bi khoa tai khoan, ly do: Hack vu khi (%s)", GetPlayerNameEx(playerid), playerip, WeaponName);
				PlayerInfo[playerid][pBanned] = 3;
				Log("logs/ban.log", String);
				new ip[32];
				GetPlayerIp(playerid,ip,sizeof(ip));
				SystemBan(playerid, "[System] (Hack vu khi)");
				MySQLBan(GetPlayerSQLId(playerid),playerip,"Hack vu khi", 1,"System");
				SetTimerEx("KickEx", 1000, 0, "i", playerid);
				TotalAutoBan++;
			}
            ExecuteHackerAction( playerid, newweapon );
        }
        else if( PlayerInfo[playerid][pGuns][2] != 23 && GetPlayerWeapon( playerid ) == 23)
        {
            if(IsACop(playerid) || PlayerInfo[playerid][pMember] == 3 && PlayerInfo[playerid][pDivision] == 2 || PlayerInfo[playerid][pMember] == 3 && PlayerInfo[playerid][pRank] >= 5) {}
            else
            {
            	if(PlayerInfo[playerid][pConnectHours] < 2)
			    {
				    new WeaponName[32];
					GetWeaponName(newweapon, WeaponName, sizeof(WeaponName));
					new String[128];
		            format( String, sizeof( String ), "AdmCmd: %s da bi khoa tai khoan, ly do: Hack vu khi (%s).", GetPlayerNameEx(playerid), WeaponName );
                    ABroadCast( COLOR_LIGHTRED, String, 2 );
					SetPVarInt(playerid, "_HACK_WARNINGS", 0 );
					PlayerInfo[playerid][pBanned] = 3;
					new playerip[32];
					GetPlayerIp(playerid, playerip, sizeof(playerip));
					format( String, sizeof( String ), "AdmCmd: %s (IP:%s) da bi khoa tai khoan, ly do: Hack vu khi (%s)", GetPlayerNameEx(playerid), playerip, WeaponName);
					PlayerInfo[playerid][pBanned] = 3;
					Log("logs/ban.log", String);
					new ip[32];
					GetPlayerIp(playerid,ip,sizeof(ip));
					SystemBan(playerid, "[System] (Hack vu khi)");
					MySQLBan(GetPlayerSQLId(playerid),playerip,"Hack vu khi", 1,"System");
					SetTimerEx("KickEx", 1000, 0, "i", playerid);
					TotalAutoBan++;
				}
            	ExecuteHackerAction( playerid, newweapon );
            }
        }
        else if( PlayerInfo[playerid][pGuns][2] != 24 && GetPlayerWeapon( playerid ) == 24)
        {
            if(IsACop(playerid)) {}
            else
            {
                if(PlayerInfo[playerid][pConnectHours] < 2)
			    {
				    new WeaponName[32];
					GetWeaponName(newweapon, WeaponName, sizeof(WeaponName));
					new String[128];
		            format( String, sizeof( String ), "AdmCmd: %s da bi khoa tai khoan, ly do: Hack vu khi (%s).", GetPlayerNameEx(playerid), WeaponName );
					ABroadCast( COLOR_LIGHTRED, String, 2 );
					SetPVarInt(playerid, "_HACK_WARNINGS", 0 );
					PlayerInfo[playerid][pBanned] = 3;
					new playerip[32];
					GetPlayerIp(playerid, playerip, sizeof(playerip));
					format( String, sizeof( String ), "AdmCmd: %s (IP:%s) da bi khoa tai khoan, ly do: Hack vu khi (%s)", GetPlayerNameEx(playerid), playerip, WeaponName);
					PlayerInfo[playerid][pBanned] = 3;
					Log("logs/ban.log", String);
					new ip[32];
					GetPlayerIp(playerid,ip,sizeof(ip));
					SystemBan(playerid, "[System] (Hack vu khi)");
					MySQLBan(GetPlayerSQLId(playerid),playerip,"Hack vu khi", 1,"System");
					SetTimerEx("KickEx", 1000, 0, "i", playerid);
					TotalAutoBan++;
				}
            	ExecuteHackerAction( playerid, newweapon );
            }
        }
        else if( PlayerInfo[playerid][pGuns][3] != 25 && GetPlayerWeapon( playerid ) == 25)
        {
            if(IsACop(playerid)) {}
            else
            {
                if(PlayerInfo[playerid][pConnectHours] < 2)
			    {
				    new WeaponName[32];
					GetWeaponName(newweapon, WeaponName, sizeof(WeaponName));
					new String[128];
		            format( String, sizeof( String ), "AdmCmd: %s da bi khoa tai khoan, ly do: Hack vu khi (%s).", GetPlayerNameEx(playerid), WeaponName );
					ABroadCast( COLOR_LIGHTRED, String, 2 );
					SetPVarInt(playerid, "_HACK_WARNINGS", 0 );
					PlayerInfo[playerid][pBanned] = 3;
					new playerip[32];
					GetPlayerIp(playerid, playerip, sizeof(playerip));
					format( String, sizeof( String ), "AdmCmd: %s (IP:%s) da bi khoa tai khoan, ly do: Hack vu khi (%s)", GetPlayerNameEx(playerid), playerip, WeaponName);
					PlayerInfo[playerid][pBanned] = 3;
					Log("logs/ban.log", String);
					new ip[32];
					GetPlayerIp(playerid,ip,sizeof(ip));
					SystemBan(playerid, "[System] (Hack vu khi)");
					MySQLBan(GetPlayerSQLId(playerid),playerip,"Hack vu khi", 1,"System");
					SetTimerEx("KickEx", 1000, 0, "i", playerid);
					TotalAutoBan++;
				}
            	ExecuteHackerAction( playerid, newweapon );
            }
        }
        else if( PlayerInfo[playerid][pGuns][3] != 26 && GetPlayerWeapon( playerid ) == 26)
        {
            if(PlayerInfo[playerid][pConnectHours] < 2)
    		{
		    	new WeaponName[32];
				GetWeaponName(newweapon, WeaponName, sizeof(WeaponName));
				new String[128];
    			format( String, sizeof( String ), "AdmCmd: %s da bi khoa tai khoan, ly do: Hack vu khi (%s).", GetPlayerNameEx(playerid), WeaponName );
				ABroadCast( COLOR_LIGHTRED, String, 2 );
				SetPVarInt(playerid, "_HACK_WARNINGS", 0 );
				PlayerInfo[playerid][pBanned] = 3;
				new playerip[32];
				GetPlayerIp(playerid, playerip, sizeof(playerip));
				format( String, sizeof( String ), "AdmCmd: %s (IP:%s) da bi khoa tai khoan, ly do: Hack vu khi (%s)", GetPlayerNameEx(playerid), playerip, WeaponName);
				PlayerInfo[playerid][pBanned] = 3;
				Log("logs/ban.log", String);
				new ip[32];
				GetPlayerIp(playerid,ip,sizeof(ip));
				SystemBan(playerid, "[System] (Hack vu khi)");
				MySQLBan(GetPlayerSQLId(playerid),playerip,"Hack vu khi", 1,"System");
				SetTimerEx("KickEx", 1000, 0, "i", playerid);
				TotalAutoBan++;
			}
            ExecuteHackerAction( playerid, newweapon );
        }
        else if( PlayerInfo[playerid][pGuns][3] != 27 && GetPlayerWeapon( playerid ) == 27)
        {
            if(PlayerInfo[playerid][pConnectHours] < 2)
    		{
		    	new WeaponName[32];
				GetWeaponName(newweapon, WeaponName, sizeof(WeaponName));
				new String[128];
    			format( String, sizeof( String ), "AdmCmd: %s da bi khoa tai khoan, ly do: Hack vu khi (%s).", GetPlayerNameEx(playerid), WeaponName );
				ABroadCast( COLOR_LIGHTRED, String, 2 );
				SetPVarInt(playerid, "_HACK_WARNINGS", 0 );
				PlayerInfo[playerid][pBanned] = 3;
				new playerip[32];
				GetPlayerIp(playerid, playerip, sizeof(playerip));
				format( String, sizeof( String ), "AdmCmd: %s (IP:%s) da bi khoa tai khoan, ly do: Hack vu khi (%s)", GetPlayerNameEx(playerid), playerip, WeaponName);
				PlayerInfo[playerid][pBanned] = 3;
				Log("logs/ban.log", String);
				new ip[32];
				GetPlayerIp(playerid,ip,sizeof(ip));
				SystemBan(playerid, "[System] (Hack vu khi)");
				MySQLBan(GetPlayerSQLId(playerid),playerip,"Hack vu khi", 1,"System");
				SetTimerEx("KickEx", 1000, 0, "i", playerid);
				TotalAutoBan++;
			}
            ExecuteHackerAction( playerid, newweapon );
        }
        else if( PlayerInfo[playerid][pGuns][4] != 28 && GetPlayerWeapon( playerid ) == 28)
        {
            if(PlayerInfo[playerid][pConnectHours] < 2)
    		{
		    	new WeaponName[32];
				GetWeaponName(newweapon, WeaponName, sizeof(WeaponName));
				new String[128];
    			format( String, sizeof( String ), "AdmCmd: %s da bi khoa tai khoan, ly do: Hack vu khi (%s).", GetPlayerNameEx(playerid), WeaponName );
				ABroadCast( COLOR_LIGHTRED, String, 2 );
				SetPVarInt(playerid, "_HACK_WARNINGS", 0 );
				PlayerInfo[playerid][pBanned] = 3;
				new playerip[32];
				GetPlayerIp(playerid, playerip, sizeof(playerip));
				format( String, sizeof( String ), "AdmCmd: %s (IP:%s) da bi khoa tai khoan, ly do: Hack vu khi (%s)", GetPlayerNameEx(playerid), playerip, WeaponName);
				PlayerInfo[playerid][pBanned] = 3;
				Log("logs/ban.log", String);
                new ip[32];
				GetPlayerIp(playerid,ip,sizeof(ip));
				SystemBan(playerid, "[System] (Hack vu khi)");
				MySQLBan(GetPlayerSQLId(playerid),playerip,"Hack vu khi", 1,"System");
				SetTimerEx("KickEx", 1000, 0, "i", playerid);
				TotalAutoBan++;
			}
            ExecuteHackerAction( playerid, newweapon );
        }
        else if( PlayerInfo[playerid][pGuns][4] != 29 && GetPlayerWeapon( playerid ) == 29)
        {
            if(PlayerInfo[playerid][pConnectHours] < 2)
    		{
		    	new WeaponName[32];
				GetWeaponName(newweapon, WeaponName, sizeof(WeaponName));
				new String[128];
    			format( String, sizeof( String ), "AdmCmd: %s da bi khoa tai khoan, ly do: Hack vu khi (%s).", GetPlayerNameEx(playerid), WeaponName );
				ABroadCast( COLOR_LIGHTRED, String, 2 );
				SetPVarInt(playerid, "_HACK_WARNINGS", 0 );
				PlayerInfo[playerid][pBanned] = 3;
				new playerip[32];
				GetPlayerIp(playerid, playerip, sizeof(playerip));
				format( String, sizeof( String ), "AdmCmd: %s (IP:%s) da bi khoa tai khoan, ly do: Hack vu khi (%s)", GetPlayerNameEx(playerid), playerip, WeaponName);
				PlayerInfo[playerid][pBanned] = 3;
				Log("logs/ban.log", String);
				new ip[32];
				GetPlayerIp(playerid,ip,sizeof(ip));
				SystemBan(playerid, "[System] (Hack vu khi)");
				MySQLBan(GetPlayerSQLId(playerid),playerip,"Hack vu khi", 1,"System");
				SetTimerEx("KickEx", 1000, 0, "i", playerid);
				TotalAutoBan++;
			}
            ExecuteHackerAction( playerid, newweapon );
        }
        else if( PlayerInfo[playerid][pGuns][5] != 30 && GetPlayerWeapon( playerid ) == 30)
        {
            if(PlayerInfo[playerid][pConnectHours] < 2)
    		{
		    	new WeaponName[32];
				GetWeaponName(newweapon, WeaponName, sizeof(WeaponName));
				new String[128];
    			format( String, sizeof( String ), "AdmCmd: %s da bi khoa tai khoan, ly do: Hack vu khi (%s).", GetPlayerNameEx(playerid), WeaponName );
				ABroadCast( COLOR_LIGHTRED, String, 2 );
				SetPVarInt(playerid, "_HACK_WARNINGS", 0 );
				PlayerInfo[playerid][pBanned] = 3;
				new playerip[32];
				GetPlayerIp(playerid, playerip, sizeof(playerip));
				format( String, sizeof( String ), "AdmCmd: %s (IP:%s) da bi khoa tai khoan, ly do: Hack vu khi (%s)", GetPlayerNameEx(playerid), playerip, WeaponName);
				PlayerInfo[playerid][pBanned] = 3;
				Log("logs/ban.log", String);
				new ip[32];
				GetPlayerIp(playerid,ip,sizeof(ip));
				SystemBan(playerid, "[System] (Hack vu khi)");
				MySQLBan(GetPlayerSQLId(playerid),playerip,"Hack vu khi", 1,"System");
				SetTimerEx("KickEx", 1000, 0, "i", playerid);
				TotalAutoBan++;
			}
            ExecuteHackerAction( playerid, newweapon );
        }
        else if( PlayerInfo[playerid][pGuns][4] != 32 && GetPlayerWeapon( playerid ) == 32)
        {
            if(PlayerInfo[playerid][pConnectHours] < 2)
    		{
		    	new WeaponName[32];
				GetWeaponName(newweapon, WeaponName, sizeof(WeaponName));
				new String[128];
    			format( String, sizeof( String ), "AdmCmd: %s da bi khoa tai khoan, ly do: Hack vu khi (%s).", GetPlayerNameEx(playerid), WeaponName );
				ABroadCast( COLOR_LIGHTRED, String, 2 );
				SetPVarInt(playerid, "_HACK_WARNINGS", 0 );
				PlayerInfo[playerid][pBanned] = 3;
				new playerip[32];
				GetPlayerIp(playerid, playerip, sizeof(playerip));
				format( String, sizeof( String ), "AdmCmd: %s (IP:%s) da bi khoa tai khoan, ly do: Hack vu khi (%s)", GetPlayerNameEx(playerid), playerip, WeaponName);
				PlayerInfo[playerid][pBanned] = 3;
				Log("logs/ban.log", String);
				new ip[32];
				GetPlayerIp(playerid,ip,sizeof(ip));
				SystemBan(playerid, "[System] (Hack vu khi)");
				MySQLBan(GetPlayerSQLId(playerid),playerip,"Hack vu khi", 1,"System");
				SetTimerEx("KickEx", 1000, 0, "i", playerid);
				TotalAutoBan++;
			}
            ExecuteHackerAction( playerid, newweapon );
        }
        else if( PlayerInfo[playerid][pGuns][5] != 31 && GetPlayerWeapon( playerid ) == 31)
        {
            if(PlayerInfo[playerid][pConnectHours] < 2)
    		{
		    	new WeaponName[32];
				GetWeaponName(newweapon, WeaponName, sizeof(WeaponName));
				new String[128];
    			format( String, sizeof( String ), "AdmCmd: %s da bi khoa tai khoan, ly do: Hack vu khi (%s).", GetPlayerNameEx(playerid), WeaponName );
				ABroadCast( COLOR_LIGHTRED, String, 2 );
				SetPVarInt(playerid, "_HACK_WARNINGS", 0 );
				PlayerInfo[playerid][pBanned] = 3;
				new playerip[32];
				GetPlayerIp(playerid, playerip, sizeof(playerip));
				format( String, sizeof( String ), "AdmCmd: %s (IP:%s) da bi khoa tai khoan, ly do: Hack vu khi (%s)", GetPlayerNameEx(playerid), playerip, WeaponName);
				PlayerInfo[playerid][pBanned] = 3;
				Log("logs/ban.log", String);
				new ip[32];
				GetPlayerIp(playerid,ip,sizeof(ip));
				SystemBan(playerid, "[System] (Hack vu khi)");
				MySQLBan(GetPlayerSQLId(playerid),playerip,"Hack vu khi", 1,"System");
				SetTimerEx("KickEx", 1000, 0, "i", playerid);
				TotalAutoBan++;
			}
            ExecuteHackerAction( playerid, newweapon );
        }
        else if( PlayerInfo[playerid][pGuns][6] != 33 && GetPlayerWeapon( playerid ) == 33)
        {
            if(PlayerInfo[playerid][pConnectHours] < 2)
    		{
		    	new WeaponName[32];
				GetWeaponName(newweapon, WeaponName, sizeof(WeaponName));
				new String[128];
    			format( String, sizeof( String ), "AdmCmd: %s da bi khoa tai khoan, ly do: Hack vu khi (%s).", GetPlayerNameEx(playerid), WeaponName );
				ABroadCast( COLOR_LIGHTRED, String, 2 );
				SetPVarInt(playerid, "_HACK_WARNINGS", 0 );
				PlayerInfo[playerid][pBanned] = 3;
				new playerip[32];
				GetPlayerIp(playerid, playerip, sizeof(playerip));
				format( String, sizeof( String ), "AdmCmd: %s (IP:%s) da bi khoa tai khoan, ly do: Hack vu khi (%s)", GetPlayerNameEx(playerid), playerip, WeaponName);
				PlayerInfo[playerid][pBanned] = 3;
				Log("logs/ban.log", String);
				new ip[32];
				GetPlayerIp(playerid,ip,sizeof(ip));
				SystemBan(playerid, "[System] (Hack vu khi)");
				MySQLBan(GetPlayerSQLId(playerid),playerip,"Hack vu khi", 1,"System");
				SetTimerEx("KickEx", 1000, 0, "i", playerid);
				TotalAutoBan++;
			}
            ExecuteHackerAction( playerid, newweapon );
        }
        else if( PlayerInfo[playerid][pGuns][6] != 34 && GetPlayerWeapon( playerid ) == 34)
        {
            if(PlayerInfo[playerid][pConnectHours] < 2)
    		{
		    	new WeaponName[32];
				GetWeaponName(newweapon, WeaponName, sizeof(WeaponName));
				new String[128];
    			format( String, sizeof( String ), "AdmCmd: %s da bi khoa tai khoan, ly do: Hack vu khi (%s).", GetPlayerNameEx(playerid), WeaponName );
				ABroadCast( COLOR_LIGHTRED, String, 2 );
				SetPVarInt(playerid, "_HACK_WARNINGS", 0 );
				PlayerInfo[playerid][pBanned] = 3;
				new playerip[32];
				GetPlayerIp(playerid, playerip, sizeof(playerip));
				format( String, sizeof( String ), "AdmCmd: %s (IP:%s) da bi khoa tai khoan, ly do: Hack vu khi (%s)", GetPlayerNameEx(playerid), playerip, WeaponName);
				PlayerInfo[playerid][pBanned] = 3;
				Log("logs/ban.log", String);
				new ip[32];
				GetPlayerIp(playerid,ip,sizeof(ip));
				SystemBan(playerid, "[System] (Hack vu khi)");
				MySQLBan(GetPlayerSQLId(playerid),playerip,"Hack vu khi", 1,"System");
				SetTimerEx("KickEx", 1000, 0, "i", playerid);
				TotalAutoBan++;
			}
            ExecuteHackerAction( playerid, newweapon );
        }
        else if( PlayerInfo[playerid][pGuns][7] != 35 && GetPlayerWeapon( playerid ) == 35)
        {
            new WeaponName[32];
			GetWeaponName(newweapon, WeaponName, sizeof(WeaponName));
			new String[128];
            format( String, sizeof( String ), "AdmCmd: %s da bi khoa tai khoan, ly do: Hack vu khi (%s).", GetPlayerNameEx(playerid), WeaponName );
			ABroadCast( COLOR_LIGHTRED, String, 2 );
			SetPVarInt(playerid, "_HACK_WARNINGS", 0 );
			PlayerInfo[playerid][pBanned] = 3;
			new playerip[32];
			GetPlayerIp(playerid, playerip, sizeof(playerip));
			format( String, sizeof( String ), "AdmCmd: %s (IP:%s) da bi khoa tai khoan, ly do: Hack vu khi (%s)", GetPlayerNameEx(playerid), playerip, WeaponName);
			PlayerInfo[playerid][pBanned] = 3;
			Log("logs/ban.log", String);
			new ip[32];
			GetPlayerIp(playerid,ip,sizeof(ip));
			SystemBan(playerid, "[System] (Hack vu khi)");
			MySQLBan(GetPlayerSQLId(playerid),playerip,"Hack vu khi", 1,"System");
			SetTimerEx("KickEx", 1000, 0, "i", playerid);
			TotalAutoBan++;
            ExecuteHackerAction( playerid, newweapon );
        }
        else if( PlayerInfo[playerid][pGuns][7] != 36 && GetPlayerWeapon( playerid ) == 36)
        {
            new WeaponName[32];
			GetWeaponName(newweapon, WeaponName, sizeof(WeaponName));
            new String[128];
			format( String, sizeof( String ), "AdmCmd: %s da bi khoa tai khoan, ly do: Hack vu khi (%s).", GetPlayerNameEx(playerid), WeaponName );
			ABroadCast( COLOR_LIGHTRED, String, 2 );
			SetPVarInt(playerid, "_HACK_WARNINGS", 0 );
			PlayerInfo[playerid][pBanned] = 3;
			new playerip[32];
			GetPlayerIp(playerid, playerip, sizeof(playerip));
			format( String, sizeof( String ), "AdmCmd: %s (IP:%s) da bi khoa tai khoan, ly do: Hack vu khi (%s)", GetPlayerNameEx(playerid), playerip, WeaponName);
			PlayerInfo[playerid][pBanned] = 3;
			Log("logs/ban.log", String);
			new ip[32];
			GetPlayerIp(playerid,ip,sizeof(ip));
			SystemBan(playerid, "[System] (Hack vu khi)");
			MySQLBan(GetPlayerSQLId(playerid),playerip,"Hack vu khi", 1,"System");
			SetTimerEx("KickEx", 1000, 0, "i", playerid);
			TotalAutoBan++;
            ExecuteHackerAction( playerid, newweapon );
        }
        else if( PlayerInfo[playerid][pGuns][7] != 37 && GetPlayerWeapon( playerid ) == 37)
        {
			new WeaponName[32];
			GetWeaponName(newweapon, WeaponName, sizeof(WeaponName));
			new String[128];
            format( String, sizeof( String ), "AdmCmd: %s da bi khoa tai khoan, ly do: Hack vu khi (%s).", GetPlayerNameEx(playerid), WeaponName );
			ABroadCast( COLOR_LIGHTRED, String, 2 );
			SetPVarInt(playerid, "_HACK_WARNINGS", 0 );
			PlayerInfo[playerid][pBanned] = 3;
			new playerip[32];
			GetPlayerIp(playerid, playerip, sizeof(playerip));
			format( String, sizeof( String ), "AdmCmd: %s (IP:%s) da bi khoa tai khoan, ly do: Hack vu khi (%s)", GetPlayerNameEx(playerid), playerip, WeaponName);
			PlayerInfo[playerid][pBanned] = 3;
			Log("logs/ban.log", String);
			new ip[32];
			GetPlayerIp(playerid,ip,sizeof(ip));
			SystemBan(playerid, "[System] (Hack vu khi)");
			MySQLBan(GetPlayerSQLId(playerid),playerip,"Hack vu khi", 1,"System");
			SetTimerEx("KickEx", 1000, 0, "i", playerid);
			TotalAutoBan++;
            ExecuteHackerAction( playerid, newweapon );
        }
        else if( PlayerInfo[playerid][pGuns][7] != 38 && GetPlayerWeapon( playerid ) == 38)
        {
            new WeaponName[32];
			GetWeaponName(newweapon, WeaponName, sizeof(WeaponName));
            new String[128];
			format( String, sizeof( String ), "AdmCmd: %s da bi khoa tai khoan, ly do: Hack vu khi (%s).", GetPlayerNameEx(playerid), WeaponName );
			ABroadCast( COLOR_LIGHTRED, String, 2 );
			SetPVarInt(playerid, "_HACK_WARNINGS", 0 );
			PlayerInfo[playerid][pBanned] = 3;
			new playerip[32];
			GetPlayerIp(playerid, playerip, sizeof(playerip));
			format( String, sizeof( String ), "AdmCmd: %s (IP:%s) da bi khoa tai khoan, ly do: Hack vu khi (%s)", GetPlayerNameEx(playerid), playerip, WeaponName);
			Log("logs/ban.log", String);
			new ip[32];
			GetPlayerIp(playerid,ip,sizeof(ip));
			SystemBan(playerid, "[System] (Hack vu khi)");
			MySQLBan(GetPlayerSQLId(playerid),playerip,"Hack vu khi", 1,"System");
			SetTimerEx("KickEx", 1000, 0, "i", playerid);
			TotalAutoBan++;
            ExecuteHackerAction( playerid, newweapon );
        }
        else if( PlayerInfo[playerid][pGuns][8] != 16 && GetPlayerWeapon( playerid ) == 16)
        {
            new WeaponName[32];
			GetWeaponName(newweapon, WeaponName, sizeof(WeaponName));
			new String[128];
            format( String, sizeof( String ), "AdmCmd: %s da bi khoa tai khoan, ly do: Hack vu khi (%s).", GetPlayerNameEx(playerid), WeaponName );
			ABroadCast( COLOR_LIGHTRED, String, 2 );
			SetPVarInt(playerid, "_HACK_WARNINGS", 0 );
			PlayerInfo[playerid][pBanned] = 3;
			new playerip[32];
			GetPlayerIp(playerid, playerip, sizeof(playerip));
			format( String, sizeof( String ), "AdmCmd: %s (IP:%s) da bi khoa tai khoan, ly do: Hack vu khi (%s)", GetPlayerNameEx(playerid), playerip, WeaponName);
			PlayerInfo[playerid][pBanned] = 3;
			Log("logs/ban.log", String);
			new ip[32];
			GetPlayerIp(playerid,ip,sizeof(ip));
			SystemBan(playerid, "[System] (Hack vu khi)");
			MySQLBan(GetPlayerSQLId(playerid),playerip,"Hack vu khi", 1,"System");
			SetTimerEx("KickEx", 1000, 0, "i", playerid);
			TotalAutoBan++;
            ExecuteHackerAction( playerid, newweapon );
        }
        else if( PlayerInfo[playerid][pGuns][8] != 17 && GetPlayerWeapon( playerid ) == 17)
        {
            ExecuteHackerAction( playerid, newweapon );
        }
        else if( PlayerInfo[playerid][pGuns][8] != 18 && GetPlayerWeapon( playerid ) == 18)
        {
            new WeaponName[32];
			GetWeaponName(newweapon, WeaponName, sizeof(WeaponName));
			new String[128];
            format( String, sizeof( String ), "AdmCmd: %s da bi khoa tai khoan, ly do: Hack vu khi (%s).", GetPlayerNameEx(playerid), WeaponName );
			ABroadCast( COLOR_LIGHTRED, String, 2 );
			SetPVarInt(playerid, "_HACK_WARNINGS", 0 );
			PlayerInfo[playerid][pBanned] = 3;
			new playerip[32];
			GetPlayerIp(playerid, playerip, sizeof(playerip));
			format( String, sizeof( String ), "AdmCmd: %s (IP:%s) da bi khoa tai khoan, ly do: Hack vu khi (%s)", GetPlayerNameEx(playerid), playerip, WeaponName);
			PlayerInfo[playerid][pBanned] = 3;
			Log("logs/ban.log", String);
			new ip[32];
			GetPlayerIp(playerid,ip,sizeof(ip));
			SystemBan(playerid, "[System] (Hack vu khi)");
			MySQLBan(GetPlayerSQLId(playerid),playerip,"Hack vu khi", 1,"System");
			SetTimerEx("KickEx", 1000, 0, "i", playerid);
			TotalAutoBan++;
            ExecuteHackerAction( playerid, newweapon );
        }
        else if( PlayerInfo[playerid][pGuns][8] != 39 && GetPlayerWeapon( playerid ) == 39)
        {
            new WeaponName[32];
			GetWeaponName(newweapon, WeaponName, sizeof(WeaponName));
			new String[128];
            format( String, sizeof( String ), "AdmCmd: %s da bi khoa tai khoan, ly do: Hack vu khi (%s).", GetPlayerNameEx(playerid), WeaponName );
			ABroadCast( COLOR_LIGHTRED, String, 2 );
			SetPVarInt(playerid, "_HACK_WARNINGS", 0 );
			PlayerInfo[playerid][pBanned] = 3;
			new playerip[32];
			GetPlayerIp(playerid, playerip, sizeof(playerip));
			format( String, sizeof( String ), "AdmCmd: %s (IP:%s) da bi khoa tai khoan, ly do: Hack vu khi (%s)", GetPlayerNameEx(playerid), playerip, WeaponName);
			PlayerInfo[playerid][pBanned] = 3;
			Log("logs/ban.log", String);
			new ip[32];
			GetPlayerIp(playerid,ip,sizeof(ip));
			SystemBan(playerid, "[System] (Hack vu khi)");
			MySQLBan(GetPlayerSQLId(playerid),playerip,"Hack vu khi", 1,"System");
			SetTimerEx("KickEx", 1000, 0, "i", playerid);
			TotalAutoBan++;
            ExecuteHackerAction( playerid, newweapon );
        }
        else if( PlayerInfo[playerid][pGuns][9] != 41 && GetPlayerWeapon( playerid ) == 41)
        {
            if(PlayerInfo[playerid][pConnectHours] < 2)
    		{
		    	new WeaponName[32];
				GetWeaponName(newweapon, WeaponName, sizeof(WeaponName));
				new String[128];
    			format( String, sizeof( String ), "AdmCmd: %s da bi khoa tai khoan, ly do: Hack vu khi (%s).", GetPlayerNameEx(playerid), WeaponName );
				ABroadCast( COLOR_LIGHTRED, String, 2 );
				SetPVarInt(playerid, "_HACK_WARNINGS", 0 );
				PlayerInfo[playerid][pBanned] = 3;
				new playerip[32];
				GetPlayerIp(playerid, playerip, sizeof(playerip));
				format( String, sizeof( String ), "AdmCmd: %s (IP:%s) da bi khoa tai khoan, ly do: Hack vu khi (%s)", GetPlayerNameEx(playerid), playerip, WeaponName);
				PlayerInfo[playerid][pBanned] = 3;
				Log("logs/ban.log", String);
				new ip[32];
				GetPlayerIp(playerid,ip,sizeof(ip));
				SystemBan(playerid, "[System] (Hack vu khi)");
				MySQLBan(GetPlayerSQLId(playerid),playerip,"Hack vu khi", 1,"System");
				SetTimerEx("KickEx", 1000, 0, "i", playerid);
				TotalAutoBan++;
			}
            ExecuteHackerAction( playerid, newweapon );
        }
        else if( PlayerInfo[playerid][pGuns][9] != 42 && GetPlayerWeapon( playerid ) == 42)
        {
            if(PlayerInfo[playerid][pConnectHours] < 2)
    		{
		    	new WeaponName[32];
				GetWeaponName(newweapon, WeaponName, sizeof(WeaponName));
				new String[128];
    			format( String, sizeof( String ), "AdmCmd: %s da bi khoa tai khoan, ly do: Hack vu khi (%s).", GetPlayerNameEx(playerid), WeaponName );
				ABroadCast( COLOR_LIGHTRED, String, 2 );
				SetPVarInt(playerid, "_HACK_WARNINGS", 0 );
				PlayerInfo[playerid][pBanned] = 3;
				new playerip[32];
				GetPlayerIp(playerid, playerip, sizeof(playerip));
				format( String, sizeof( String ), "AdmCmd: %s (IP:%s) da bi khoa tai khoan, ly do: Hack vu khi (%s)", GetPlayerNameEx(playerid), playerip, WeaponName);
				PlayerInfo[playerid][pBanned] = 3;
				Log("logs/ban.log", String);
				new ip[32];
				GetPlayerIp(playerid,ip,sizeof(ip));
				SystemBan(playerid, "[System] (Hack vu khi)");
				MySQLBan(GetPlayerSQLId(playerid),playerip,"Hack vu khi", 1,"System");
				SetTimerEx("KickEx", 1000, 0, "i", playerid);
				TotalAutoBan++;
			}
            ExecuteHackerAction( playerid, newweapon );
        }
        else if( PlayerInfo[playerid][pGuns][9] != 43 && GetPlayerWeapon( playerid ) == 43)
        {
            ExecuteHackerAction( playerid, newweapon );
        }
        else if( PlayerInfo[playerid][pGuns][10] != 11 && GetPlayerWeapon( playerid ) == 11)
        {
            ExecuteHackerAction( playerid, newweapon );
        }
        else if( PlayerInfo[playerid][pGuns][10] != 12 && GetPlayerWeapon( playerid ) == 12)
        {
            ExecuteHackerAction( playerid, newweapon );
        }
        else if( PlayerInfo[playerid][pGuns][10] != 13 && GetPlayerWeapon( playerid ) == 13)
        {
            ExecuteHackerAction( playerid, newweapon );
        }
        else if( PlayerInfo[playerid][pGuns][10] != 14 && GetPlayerWeapon( playerid ) == 14)
        {
            ExecuteHackerAction( playerid, newweapon );
        }
        else if( PlayerInfo[playerid][pGuns][10] != 15 && GetPlayerWeapon( playerid ) == 15)
        {
            ExecuteHackerAction( playerid, newweapon );
        }
        else if( PlayerInfo[playerid][pGuns][11] != 44 && GetPlayerWeapon( playerid ) == 44)
        {
            ExecuteHackerAction( playerid, newweapon );
        }
        else if( PlayerInfo[playerid][pGuns][11] != 45 && GetPlayerWeapon( playerid ) == 45)
        {
            ExecuteHackerAction( playerid, newweapon );
        }
        else if( PlayerInfo[playerid][pGuns][11] != 46 && GetPlayerWeapon( playerid ) == 46)
        {
            PlayerInfo[playerid][pGuns][11] = 46;
        }
	}

	if(GetPlayerState(playerid) == PLAYER_STATE_PASSENGER)
	{
		new gun,tmp;
	 	GetPlayerWeaponData(playerid,4,gun,tmp);
	  	#pragma unused tmp
	   	if(gun)SetPlayerArmedWeapon(playerid,gun);
	   	else SetPlayerArmedWeapon(playerid,0);
	}
	return 1;
}

IsNumeric(szInput[]) {

	new
		iChar,
		i = 0;

	while ((iChar = szInput[i++])) if (!('0' <= iChar <= '9')) return 0;
	return 1;
}

ReturnUser(text[]) {

	new
		strPos,
		returnID = 0,
		bool: isnum = true;

	while(text[strPos]) {
		if(isnum) {
			if ('0' <= text[strPos] <= '9') returnID = (returnID * 10) + (text[strPos] - '0');
			else isnum = false;
		}
		strPos++;
	}
	if (isnum) {
		if(IsPlayerConnected(returnID)) return returnID;
	}
	else {

		new
			sz_playerName[MAX_PLAYER_NAME];

		foreach(new i: Player)
		{
			GetPlayerName(i, sz_playerName, MAX_PLAYER_NAME);
			if(!strcmp(sz_playerName, text, true, strPos)) return i;
		}
	}
	return INVALID_PLAYER_ID;
}

MainMenuUpdateForPlayer(playerid)
{
	new string[156];

	if(InsideMainMenu{playerid} == 1 || InsideTut{playerid} == 1)
	{
		format(string, sizeof(string), "~y~MOTD~w~: %s", GlobalMOTD);
		TextDrawSetString(MainMenuTxtdraw[9], string);
	}
}

vehicleSpawnCountCheck(playerid) {
	switch(PlayerInfo[playerid][pDonateRank]) {
		case 0, 1, 2: if(VehicleSpawned[playerid] >= 2) return 0;
		case 3: if(VehicleSpawned[playerid] >= 3) return 0;
		case 4, 5: if(VehicleSpawned[playerid] >= 5) return 0;
		default: return 0;
	}
	return 1;
}

vehicleCountCheck(playerid) {

	new
		iCount = GetPlayerVehicleCount(playerid);

	switch(PlayerInfo[playerid][pDonateRank]) {
		case 0: if(iCount >= 5 + PlayerInfo[playerid][pVehicleSlot]) return 0;
		case 1: if((iCount >= 6 + PlayerInfo[playerid][pVehicleSlot]) || (PlayerInfo[playerid][pTempVIP] > 0 && iCount >= 5 + PlayerInfo[playerid][pVehicleSlot])) return 0;
		case 2: if(iCount >= 7 + PlayerInfo[playerid][pVehicleSlot]) return 0;
		case 3: if(iCount >= 8 + PlayerInfo[playerid][pVehicleSlot]) return 0;
		case 4, 5: if(iCount >= 10 + PlayerInfo[playerid][pVehicleSlot]) return 0;
		default: return 0;
	}
	return 1;
}

GetPlayerVehicleCount(playerid)
{
	new cars = 0;
	for(new i = 0; i < MAX_PLAYERVEHICLES; i++) if(PlayerVehicleInfo[playerid][i][pvModelId]) ++cars;
	return cars;
}

GetPlayerVehicleSlots(playerid)
{
	switch(PlayerInfo[playerid][pDonateRank]) {
		case 0: return 5 + PlayerInfo[playerid][pVehicleSlot];
		case 1:
		{
			if(PlayerInfo[playerid][pTempVIP] > 0)
			{
				return 5 +  PlayerInfo[playerid][pVehicleSlot];
			}
			else
			{
				return 6 + PlayerInfo[playerid][pVehicleSlot];
			}
		}
		case 2: return 7 + PlayerInfo[playerid][pVehicleSlot];
		case 3: return 8 + PlayerInfo[playerid][pVehicleSlot];
		case 4, 5: return 10 + PlayerInfo[playerid][pVehicleSlot];
		default: return 0;
	}
	return 0;
}

toyCountCheck(playerid) {

	new
		iCount = GetPlayerToyCount(playerid),
		special = GetSpecialPlayerToyCount(playerid);
	if(iCount >= 10 + PlayerInfo[playerid][pToySlot] + special) return 0;
	return 1;
}

GetPlayerToyCount(playerid)
{
	new toys = 0;
	for(new i = 0; i < MAX_PLAYERTOYS; i++) if(PlayerToyInfo[playerid][i][ptModelID]) ++toys;
	return toys;
}

GetSpecialPlayerToyCount(playerid)
{
	new toys = 0;
	for(new i = 0; i < MAX_PLAYERTOYS; i++) if(PlayerToyInfo[playerid][i][ptSpecial] == 1) ++toys;
	return toys;
}

GetFreeToySlot(playerid)
{
	for(new i = 0; i < 11; i++) {
		if(i + 1 < 11) {
			if(PlayerHoldingObject[playerid][i+1] == 0) {
				return i+1;
			}
		}
		else {
			return -1;
		}
	}
	return -1;
}

GetPlayerToySlots(playerid)
{
	new special =  GetSpecialPlayerToyCount(playerid);
	return PlayerInfo[playerid][pToySlot] + 10 + special;
}

CheckPlayerVehiclesForDesync(playerid) {
	for(new i = 0; i != MAX_PLAYERVEHICLES; ++i) {
		if(PlayerVehicleInfo[playerid][i][pvId] != INVALID_PLAYER_VEHICLE_ID && GetVehicleModel(PlayerVehicleInfo[playerid][i][pvId]) != PlayerVehicleInfo[playerid][i][pvModelId]) {
			UnloadPlayerVehicles(playerid);
			LoadPlayerVehicles(playerid);
			return SendClientMessageEx(playerid, COLOR_YELLOW, "Xe cua ban thoi duoc dong bo hoa; da duoc khoi phuc ve vi tri dau xe de dam bao khong co loi phat sinh.");
	    }
	}
	return 1;
}

Vehicle_ResetData(iVehicleID) {
	if(GetVehicleModel(iVehicleID)) {
		for(new cv = 0; cv < 6; cv++)
	    {
			CrateVehicleLoad[iVehicleID][vCrateID][cv] = -1;
		}
		Vehicle_Armor(iVehicleID);
		LockStatus{iVehicleID} = 0;
		VehicleStatus{iVehicleID} = 0;
		arr_Engine{iVehicleID} = 0;
		stationidv[iVehicleID][0] = 0;
		TruckContents{iVehicleID} = 0;
		TruckDeliveringTo[iVehicleID] = INVALID_BUSINESS_ID;
		VehicleFuel[iVehicleID] = 100.0;

		if(LockStatus{iVehicleID}) {
			foreach(new i: Player)
			{
				if(PlayerInfo[i][pLockCar] == iVehicleID) {
					PlayerInfo[i][pLockCar] = INVALID_VEHICLE_ID;
				}
			}
		}
		if(VehicleBomb{iVehicleID} == 1) {
			foreach(new i: Player)
			{
				if(PlacedVehicleBomb[i] == iVehicleID) {
					VehicleBomb{iVehicleID} = 0;
					PlacedVehicleBomb[i] = INVALID_VEHICLE_ID;
					PickUpC4(i);
					PlayerInfo[i][pC4Used] = 0;
					PlayerInfo[i][pC4Get] = 1;
				}
			}
		}
	}
}

Vehicle_Armor(iVehicleID) {
	if(DynVeh[iVehicleID] != -1 && iVehicleID == DynVehicleInfo[DynVeh[iVehicleID]][gv_iSpawnedID])
	{
	    SetVehicleHealth(iVehicleID, DynVehicleInfo[DynVeh[iVehicleID]][gv_fMaxHealth]);
	}
	else
	{
		switch(GetVehicleModel(iVehicleID)) {
			case 596, 597, 598: SetVehicleHealth(iVehicleID, 2000.0);
			case 490: SetVehicleHealth(iVehicleID, 1500.0);
			case 407, 470: SetVehicleHealth(iVehicleID, 1500.0);
			case 428, 433, 447, 427: SetVehicleHealth(iVehicleID, 3000.0);
			case 601, 528: SetVehicleHealth(iVehicleID, 3000.0);
			case 432, 425: SetVehicleHealth(iVehicleID, 7500.0);
		}
	}
}

LockPlayerVehicle(ownerid, carid, type)
{
	new v = GetPlayerVehicle(ownerid, carid);
	printf("v = %d,%d == %d %d",v,PlayerVehicleInfo[ownerid][v][pvId] == carid ,type);
	if(PlayerVehicleInfo[ownerid][v][pvId] == carid )
	{
	    LockStatus{carid} = 1;
	    vehicle_lock_doors(carid);

	}
}

UnLockPlayerVehicle(ownerid, carid, type)
{
	new v = GetPlayerVehicle(ownerid, carid);
	if(PlayerVehicleInfo[ownerid][v][pvId] == carid )
	{
	    LockStatus{carid} = 0;
		vehicle_unlock_doors(carid);
	}
}

TimeConvert(time) {
	new jhour;
    new jmin;
	new jdiv;
    new jsec;
    new string[128];
	if(time > 3599){
		jhour = floatround(time / (60*60));
		jdiv = floatround(time % (60*60));
        jmin = floatround(jdiv / 60, floatround_floor);
        jsec = floatround(jdiv % 60, floatround_ceil);
        format(string,sizeof(string),"%02d:%02d:%02d",jhour,jmin,jsec);
    }
    else if(time > 59 && time < 3600){
        jmin = floatround(time/60);
        jsec = floatround(time - jmin*60);
        format(string,sizeof(string),"%02d:%02d",jmin,jsec);
    }
    else{
        jsec = floatround(time);
        format(string,sizeof(string),"%02d seconds",jsec);
    }
    return string;
}

PlacePlant(id, ownerid, planttype, objectid, drugskill, Float:x, Float:y, Float:z, virtualworld, interior)
{
    Plants[id][pObjectSpawned] = 0;
	Plants[id][pOwner] = ownerid;
	Plants[id][pPlantType] = planttype;
	Plants[id][pObject] = objectid;
	Plants[id][pGrowth] = 0;
	Plants[id][pPos][0] = x;
	Plants[id][pPos][1] = y;
	Plants[id][pPos][2] = z;
	Plants[id][pVirtual] = virtualworld;
	Plants[id][pInterior] = interior;
	Plants[id][pExpires] = gettime()+86400;
	Plants[id][pDrugsSkill] = drugskill;
	Plants[id][pObjectSpawned] = CreateDynamicObject(objectid, x, y, z, 0.0, 0.0, 0.0, virtualworld, interior);
	return id;
}

DestroyPlant(i)
{
    DestroyDynamicObject(Plants[i][pObjectSpawned]);
	Plants[i][pObjectSpawned] = 0;
	Plants[i][pOwner] = 0;
	Plants[i][pPlantType] = 0;
	Plants[i][pObject] = 0;
	Plants[i][pGrowth] = 0;
	Plants[i][pPos][0] = 0.0;
	Plants[i][pPos][1] = 0.0;
	Plants[i][pPos][2] = 0.0;
	Plants[i][pVirtual] = 0;
	Plants[i][pInterior] = 0;
	Plants[i][pExpires] = 0;
	Plants[i][pDrugsSkill] = 0;
	if(IsValidDynamicObject(Plants[i][pObjectSpawned])) DestroyDynamicObject(Plants[i][pObjectSpawned]);
	return i;
}

RemovePlayerWeapon(playerid, weaponid)
{
    ResetPlayerWeapons(playerid);
    PlayerInfo[playerid][pGuns][GetWeaponSlot(weaponid)] = 0;
    PlayerInfo[playerid][pAmmo][GetWeaponSlot(weaponid)-1] = 0;
    SetPlayerWeaponsEx(playerid);
    return 1;
}


stock GivePlayerAmmoEx(Player, weapon, Ammo)
{
    switch(weapon)
    {
        case 16, 17, 18, 39: // SATCHEL, GRENADE, TEARGAS, MOLTOV
        {
            PlayerInfo[Player][pAmmo][ 7 ] += Ammo;
            SetPlayerAmmo(Player, weapon, PlayerInfo[Player][pAmmo][ 7 ]);
        }
        case 22, 23, 24: // 9mm, sdpid, DE
        {
            PlayerInfo[Player][pAmmo][ 1 ] += Ammo;
            SetPlayerAmmo(Player, weapon, PlayerInfo[Player][pAmmo][ 1 ]);
        }
        case 25,26,27:// Shotgun, spawn-off, combat shotgun
        {
            PlayerInfo[Player][pAmmo][ 2 ] += Ammo;
            SetPlayerAmmo(Player, weapon, PlayerInfo[Player][pAmmo][ 2 ]);
        }
        case 28,29,32: // Uzi, Tec9, Mp5
        {
            PlayerInfo[Player][pAmmo][ 3 ] += Ammo;
            SetPlayerAmmo(Player, weapon, PlayerInfo[Player][pAmmo][ 3 ]);
        }
        case 30,31: // M4, Ak 47
        {
            PlayerInfo[Player][pAmmo][ 4 ] += Ammo;
            SetPlayerAmmo(Player, weapon, PlayerInfo[Player][pAmmo][ 4 ]);
        }
        case 33,34: // rifle, sniper
        {
            PlayerInfo[Player][pAmmo][ 5 ] += Ammo;
            SetPlayerAmmo(Player, weapon, PlayerInfo[Player][pAmmo][ 5 ]);
        }
        case 35,36,37,38: // Bazoka, RPG, Firegun, minigun
        {
            PlayerInfo[Player][pAmmo][ 6 ] += Ammo;
            SetPlayerAmmo(Player, weapon, PlayerInfo[Player][pAmmo][ 6 ]);
        }
    }
    DeletePVar(Player, "CurrentAmmoSlot");
    DeletePVar(Player, "CurrentWeaponSlot");
    return 1;
}

IsPlayerInRangeOfVehicle(playerid, vehicleid, Float: radius) {

	new
		Float:Floats[3];

	GetVehiclePos(vehicleid, Floats[0], Floats[1], Floats[2]);
	return IsPlayerInRangeOfPoint(playerid, radius, Floats[0], Floats[1], Floats[2]);
}

encode_tires(tire1, tire2, tire3, tire4)
{
	return tire1 | (tire2 << 1) | (tire3 << 2) | (tire4 << 3);
}

ini_GetValue(szParse[], szValueName[], szDest[], iDestLen) { // brian!!1

	new
		iPos = strfind(szParse, "=", false),
		iLength = strlen(szParse);

	while(iLength-- && szParse[iLength] <= ' ') {
		szParse[iLength] = 0;
	}

	if(strcmp(szParse, szValueName, false, iPos) == 0) {
		strmid(szDest, szParse, iPos + 1, iLength + 1, iDestLen);
		return 1;
	}
	return 0;
}

PayDay(i) {
	new
		string[128],
		interest,
		year,
		month,
		day;

	getdate(year, month, day);

 	if(PlayerInfo[i][pLevel] > 0) {
		if(GetPVarType(i, "debtMsg")) {
			if(GetPlayerCash(i) < 0 && PlayerInfo[i][pJailTime] < 1 && !IsACop(i) && PlayerInfo[i][pWantedLevel] < 6) {
				format(string,sizeof(string),"Ban no $%s - hay tim cach tra lai tien hoac ban se gap rac roi!", number_format(GetPlayerCash(i)));
				SendClientMessageEx(i, COLOR_LIGHTRED, string);
			}
			else DeletePVar(i, "debtMsg");
		}

		if(0 <= PlayerInfo[i][pRenting] < sizeof HouseInfo) {
			if(HouseInfo[PlayerInfo[i][pRenting]][hRentFee] > PlayerInfo[i][pAccount]) {
				PlayerInfo[i][pRenting] = INVALID_HOUSE_ID;
				SendClientMessageEx(i, COLOR_WHITE, "Ban bi duoi, ban khong co du tien de nop phi thue nha.");
			}
			else {
				HouseInfo[PlayerInfo[i][pRenting]][hSafeMoney] += HouseInfo[PlayerInfo[i][pRenting]][hRentFee];
				PlayerInfo[i][pAccount] -= HouseInfo[PlayerInfo[i][pRenting]][hRentFee];
			}
		}
		if(PlayerInfo[i][pConnectSeconds] >= 3600) {
			if(GetPVarType(i, "AdvisorDuty")) {
				PlayerInfo[i][pDutyHours]++;
			}
			if(SpecTimer) AddSpecialToken(i);
			SendClientMessageEx(i, COLOR_WHITE, "________ THONG TIN NGAN HANG ________");
			if(PlayerInfo[i][pNation] == 0)
			{
				format(string, sizeof(string), "  Paycheck: $%s  |  SA Gov Tax: $%s (%d phan tram)", number_format(PlayerInfo[i][pPayCheck]), number_format((PlayerInfo[i][pPayCheck] / 100) * TaxValue), TaxValue);
				PlayerInfo[i][pAccount] -= (PlayerInfo[i][pPayCheck] / 100) * TaxValue;
				Tax += (PlayerInfo[i][pPayCheck] / 100) * TaxValue;
			}
			else if(PlayerInfo[i][pNation] == 1)
			{
				format(string, sizeof(string), "  Paycheck: $%s  |  TR Gov Tax: $%s (%d phan tram)", number_format(PlayerInfo[i][pPayCheck]), number_format((PlayerInfo[i][pPayCheck] / 100) * TRTaxValue), TRTaxValue);
				PlayerInfo[i][pAccount] -= (PlayerInfo[i][pPayCheck] / 100) * TRTaxValue;
				TRTax += (PlayerInfo[i][pPayCheck] / 100) * TRTaxValue;
			}
			SendClientMessageEx(i, COLOR_GRAD1, string);
			interest = (PlayerInfo[i][pAccount] + 1) / 100;

			switch(PlayerInfo[i][pDonateRank]) {
				case 0: {
					if(interest > 50) interest = 50;
					format(string, sizeof(string), "  Tien con lai: $%s  |  Lai suat: 0.1 phan tram ($50 max)", number_format(PlayerInfo[i][pAccount]));
					SendClientMessageEx(i, COLOR_GRAD1, string);
				}
				case 1: {
					if(interest > 60) interest = 60;
					format(string, sizeof(string), "  Tien con lai: $%s  |  Lai suat: 0.1 phan tram ($60 max)", number_format(PlayerInfo[i][pAccount]));
					SendClientMessageEx(i, COLOR_GRAD1, string);
				}
				case 2:	{
					if(interest > 70) interest = 70;
					format(string, sizeof(string), "  Tien con lai: $%s  |  Lai suat: 0.1 phan tram ($70 max)", number_format(PlayerInfo[i][pAccount]));
					SendClientMessageEx(i, COLOR_GRAD1, string);
				}
				case 3: {
					if(interest > 80) interest = 80;
					format(string, sizeof(string), "  Tien con lai: $%s  |  Lai suat: 0.1 phan tram ($80 max)", number_format(PlayerInfo[i][pAccount]));
					SendClientMessageEx(i, COLOR_GRAD1, string);
				}
				case 4, 5: {
					if(interest > 90) interest = 90;
					format(string, sizeof(string), "  Tien con lai: $%s  |  Lai suat: 0.1 phan tram ($90 max)", number_format(PlayerInfo[i][pAccount]));
					SendClientMessageEx(i, COLOR_GRAD1, string);
				}
			}
			if(PlayerInfo[i][pTaxiLicense] == 1) {
				PlayerInfo[i][pAccount] -= (PlayerInfo[i][pPayCheck] / 100) * 1;
				Tax += (PlayerInfo[i][pPayCheck] / 100) * 1;
				format(string, sizeof(string), "  Le phi giay phep Taxi (1 phan tram): $%s", number_format((PlayerInfo[i][pPayCheck] / 100) * 5));
				SendClientMessageEx(i, COLOR_GRAD2, string);
			}
			for(new iGroupID; iGroupID < MAX_GROUPS; iGroupID++)
			{
				if(PlayerInfo[i][pNation] == 0)
				{
					if(arrGroupData[iGroupID][g_iAllegiance] == 1)
					{
						if(arrGroupData[iGroupID][g_iGroupType] == 5)
						{
							new str[128], file[32];
							format(str, sizeof(str), "%s da tra $%s tien thue.", GetPlayerNameEx(i), number_format((PlayerInfo[i][pPayCheck] / 100) * TaxValue));
							format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", iGroupID, month, day, year);
							Log(file, str);
						}
					}
				}
				else if (PlayerInfo[i][pNation] == 1)
				{
					if(arrGroupData[iGroupID][g_iAllegiance] == 2)
					{
						if(arrGroupData[iGroupID][g_iGroupType] == 5)
						{
							new str[128], file[32];
							format(str, sizeof(str), "%s da tra $%s tien thue.", GetPlayerNameEx(i), number_format((PlayerInfo[i][pPayCheck] / 100) * TaxValue));
							format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", iGroupID, month, day, year);
							Log(file, str);
						}
					}
				}
			}
			PlayerInfo[i][pAccount] += interest;
			format(string, sizeof(string), "  Lai thu duoc: $%s", number_format(interest));
			SendClientMessageEx(i, COLOR_GRAD3, string);
			SendClientMessageEx(i, COLOR_GRAD4, "______________________________________");
			format(string, sizeof(string), "  Moi-Tien con lai: $%s  |  Tra thue: $%s", number_format(PlayerInfo[i][pAccount]), number_format((0 <= PlayerInfo[i][pRenting] < sizeof HouseInfo) ? (HouseInfo[PlayerInfo[i][pRenting]][hRentFee]) : (0)));
			SendClientMessageEx(i, COLOR_GRAD5, string);

            if(PlayerInfo[i][pPayCheck] > 300 * PlayerInfo[i][pLevel]) PlayerInfo[i][pPayCheck] = 300 * PlayerInfo[i][pLevel];
            format(string, sizeof(string), "[PAYCHECK] Ban nhan duoc so tien: $%s ( 300 x %d )", number_format(PlayerInfo[i][pPayCheck]),PlayerInfo[i][pLevel]);
			SendClientMessageEx(i, COLOR_GRAD3, string);
			GivePlayerMoneyEx(i, PlayerInfo[i][pPayCheck]);

			new string_log[229];
            format(string_log, sizeof(string_log), "[%s] %s(%s) đã nhận được $%s Payday.", GetLogTime(),
            	GetPlayerNameEx(i),GetDiscordUser(i) , number_format(PlayerInfo[i][pPayCheck]));         
            SendLogDiscordMSG(ddpayment, string_log);


			new
				iGroupID = PlayerInfo[i][pMember],
				iRank = PlayerInfo[i][pRank];

			if((0 <= iGroupID < MAX_GROUPS) && 0 <= iRank <= 9 && arrGroupData[iGroupID][g_iPaycheck][iRank] > 0) {
				if(arrGroupData[iGroupID][g_iAllegiance] == 1)
				{
					if(Tax > 0) {
						Tax -= arrGroupData[iGroupID][g_iPaycheck][iRank];
						GivePlayerMoneyEx(i, arrGroupData[iGroupID][g_iPaycheck][iRank]);
						format(string,sizeof(string),"  SA Government pay: $%s", number_format(arrGroupData[iGroupID][g_iPaycheck][iRank]));
						SendClientMessageEx(i, COLOR_GRAD2, string);
						for(new z; z < MAX_GROUPS; z++)
						{
							if(arrGroupData[z][g_iAllegiance] == 1)
							{
								if(arrGroupData[z][g_iGroupType] == 5)
								{
									new str[128], file[32];
       							    format(str, sizeof(str), "%s da duoc tra $%s luong Chinh phu.", GetPlayerNameEx(i), number_format(arrGroupData[iGroupID][g_iPaycheck][iRank]));
									format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", z, month, day, year);
									Log(file, str);
									break;
								}
							}
						}
					}
					else SendClientMessageEx(i, COLOR_RED, "[SA] Chinh phu no tien luong cua ban; quy chinh phu khong co tien de chi tra.");
				}
				else if(arrGroupData[iGroupID][g_iAllegiance] == 2)
				{
					if(TRTax > 0) {
						TRTax -= arrGroupData[iGroupID][g_iPaycheck][iRank];
						GivePlayerMoneyEx(i, arrGroupData[iGroupID][g_iPaycheck][iRank]);
						format(string,sizeof(string),"  TR Government pay: $%s", number_format(arrGroupData[iGroupID][g_iPaycheck][iRank]));
						SendClientMessageEx(i, COLOR_GRAD2, string);
						for(new z; z < MAX_GROUPS; z++)
						{
							if(arrGroupData[z][g_iAllegiance] == 2)
							{
								if(arrGroupData[z][g_iGroupType] == 5)
								{
									new str[128], file[32];
									format(str, sizeof(str), "%s da duoc tra $%s luong chinh phu.", GetPlayerNameEx(i), number_format(arrGroupData[iGroupID][g_iPaycheck][iRank]));
									format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", z, month, day, year);
									Log(file, str);
									break;
								}
							}
						}
					}
					else SendClientMessageEx(i, COLOR_RED, "[TR] Chinh phu no tien luong cua ban; quy chinh phu khong co tien de chi tra.");
				}
			}
   			if (PlayerInfo[i][pBusiness] != INVALID_BUSINESS_ID) {
				if (Businesses[PlayerInfo[i][pBusiness]][bAutoPay] && PlayerInfo[i][pBusinessRank] >= 0 && PlayerInfo[i][pBusinessRank] < 5) {
				    if (Businesses[PlayerInfo[i][pBusiness]][bSafeBalance] < Businesses[PlayerInfo[i][pBusiness]][bRankPay][PlayerInfo[i][pBusinessRank]]) {
				    	SendClientMessageEx(i,COLOR_RED,"Cua hang khong co du tien de chi tra cho ban.");
				    }
					else {
						GivePlayerMoneyEx(i, Businesses[PlayerInfo[i][pBusiness]][bRankPay][PlayerInfo[i][pBusinessRank]]);
						Businesses[PlayerInfo[i][pBusiness]][bSafeBalance] -= Businesses[PlayerInfo[i][pBusiness]][bRankPay][PlayerInfo[i][pBusinessRank]];
						SaveBusiness(PlayerInfo[i][pBusiness]);
						format(string,sizeof(string),"  Business pay: $%s", number_format(Businesses[PlayerInfo[i][pBusiness]][bRankPay][PlayerInfo[i][pBusinessRank]]));
						SendClientMessageEx(i, COLOR_GRAD2, string);
					}
				}
			}
	 		GameTextForPlayer(i, "~y~PayDay~n~~w~Paycheck", 5000, 1);

            format(string_log, sizeof(string_log), "[%s] %s(%s) đã nhận được payday.", GetLogTime(),GetPlayerNameEx(i),GetDiscordUser(i));         
            SendLogDiscordMSG(co_payment, string_log);

		    PlayerInfo[i][pConnectSeconds] = 0;
			PlayerInfo[i][pPayCheck] = 0;
			PlayerInfo[i][pPayDay] = 0; 
			PlayerInfo[i][pPayDayCode] = 0; 

			if(PlayerInfo[i][pCompany] != 0) {
				if(Company[PlayerInfo[i][pCompany]][CompanyBudget] > PlayerInfo[i][pPayment]) {
					new str[129];
					format(str,sizeof(str),"[COMPANY-PAYDAY] Ban da nhan duoc $%s tien luong cua @%s.co.",number_format(PlayerInfo[i][pPayment]),GetCompanyName(PlayerInfo[i][pCompany]));
					SendClientMessageEx(i,COLOR_YELLOW,str);

                    format(string_log, sizeof(string_log), "[%s] %s đã nhận được $%s lương của @%s.co [Budget $%s còn lại $%s]", GetLogTime(),
                    	GetPlayerNameEx(i) , number_format(PlayerInfo[i][pPayment]),GetCompanyName(PlayerInfo[i][pCompany]),Company[PlayerInfo[i][pCompany]][CompanyBudget] ,Company[PlayerInfo[i][pCompany]][CompanyBudget] -PlayerInfo[i][pPayment]);         
                    SendLogDiscordMSG(co_payment, string_log);
					Company[PlayerInfo[i][pCompany]][CompanyBudget] -= PlayerInfo[i][pPayment];
					GivePlayerMoneyEx(i, PlayerInfo[i][pPayment]);
				}
				else {
					SendClientMessageEx(i,COLOR_LIGHTRED, "Cong ty sap pha san? khong con du tien ngan sach de chi tra luong cho ban.");
	
                    format(string_log, sizeof(string_log), "[%s] Tổ chức không đủ tiền chi trả cho %s số tiền $%s @%s.co [Budget $%s]", GetLogTime(),
                    	GetPlayerNameEx(i),number_format(PlayerInfo[i][pPayment]),GetCompanyName(PlayerInfo[i][pCompany]),Company[PlayerInfo[i][pCompany]][CompanyBudget]);         
                    SendLogDiscordMSG(co_payment, string_log);
				}
			}
	
			if(++PlayerInfo[i][pConnectHours] == 2) {
				SendClientMessageEx(i, COLOR_LIGHTRED, "Bay gio ban co the su dung/so huu vu khi!");
			}
			if(PlayerInfo[i][pDonateRank] > 0 && ++PlayerInfo[i][pPayDayHad] >= 5) {
				PlayerInfo[i][pExp]++;
				PlayerInfo[i][pPayDayHad] = 0;
			}

			// Zombie Halloween
			if(month == 10 && day == 30)
			{
				if(PlayerInfo[i][pFallIntoFun] < 4)
				{
					PlayerInfo[i][pFallIntoFun]++;
				}
				else {
					 PlayerInfo[i][pFallIntoFun] = 0;
					 PlayerInfo[i][pVials] += 1;
				}
			}

			if((month == 12 && day == 24) || (month == 10 && day == 31))
			{
				if(PlayerInfo[i][pTrickortreat] > 0)
				{
					PlayerInfo[i][pTrickortreat]--;
				}
			}
			Misc_Save();
			

			if(DoubleXP) {
				format(string, sizeof(string), "[EXP] Ban duoc tang %s XP", number_format((PlayerInfo[i][pLevel] * XP_RATE * 2) * XP_RATE_HOURLY));
				SendClientMessageEx(i, COLOR_GREEN, string);
				PlayerInfo[i][pExp] += 2;
				PlayerInfo[i][pXP] += (PlayerInfo[i][pLevel] * XP_RATE * 2) * XP_RATE_HOURLY;
			}
			else
			if(PlayerInfo[i][pDoubleEXP] > 0 && !DoubleXP) {
				PlayerInfo[i][pDoubleEXP]--;
				format(string, sizeof(string), "[EXP] Ban duoc tang %s XP, x2 XP", number_format((PlayerInfo[i][pLevel] * XP_RATE * 2) * XP_RATE_HOURLY));
				SendClientMessageEx(i, COLOR_GREEN, string);
				PlayerInfo[i][pExp] += 2;
				PlayerInfo[i][pXP] += (PlayerInfo[i][pLevel] * XP_RATE * 2) * XP_RATE_HOURLY;
			}
			else
			{
				PlayerInfo[i][pExp]++;
				PlayerInfo[i][pXP] += PlayerInfo[i][pLevel] * XP_RATE * XP_RATE_HOURLY;
				format(string, sizeof(string), "[EXP] Ban da tang %s XP.", number_format(PlayerInfo[i][pLevel] * XP_RATE * XP_RATE_HOURLY));
				SendClientMessageEx(i, COLOR_GREEN, string);
			}

		

			
		}
		else SendClientMessageEx(i, COLOR_LIGHTRED, "* Ban da khong choi du lau de nhan paycheck.");
	}

	if (GetPVarType(i, "UnreadMails") && HasMailbox(i))
	{
		SendClientMessageEx(i, COLOR_YELLOW, "Ban co mot tin nhan chua doc trong Mailbox, vui long kiem tra mailbox");
	}
}

CreateGate(gateid) {
	if(IsValidDynamicObject(GateInfo[gateid][gGATE])) DestroyDynamicObject(GateInfo[gateid][gGATE]);
	switch(GateInfo[gateid][gRenderHQ]) {
		case 1: GateInfo[gateid][gGATE] = CreateDynamicObject(GateInfo[gateid][gModel], GateInfo[gateid][gPosX], GateInfo[gateid][gPosY], GateInfo[gateid][gPosZ], GateInfo[gateid][gRotX], GateInfo[gateid][gRotY], GateInfo[gateid][gRotZ], GateInfo[gateid][gVW], GateInfo[gateid][gInt], -1, 100.0);
		case 2: GateInfo[gateid][gGATE] = CreateDynamicObject(GateInfo[gateid][gModel], GateInfo[gateid][gPosX], GateInfo[gateid][gPosY], GateInfo[gateid][gPosZ], GateInfo[gateid][gRotX], GateInfo[gateid][gRotY], GateInfo[gateid][gRotZ], GateInfo[gateid][gVW], GateInfo[gateid][gInt], -1, 150.0);
		case 3: GateInfo[gateid][gGATE] = CreateDynamicObject(GateInfo[gateid][gModel], GateInfo[gateid][gPosX], GateInfo[gateid][gPosY], GateInfo[gateid][gPosZ], GateInfo[gateid][gRotX], GateInfo[gateid][gRotY], GateInfo[gateid][gRotZ], GateInfo[gateid][gVW], GateInfo[gateid][gInt], -1, 200.0);
		default: GateInfo[gateid][gGATE] = CreateDynamicObject(GateInfo[gateid][gModel], GateInfo[gateid][gPosX], GateInfo[gateid][gPosY], GateInfo[gateid][gPosZ], GateInfo[gateid][gRotX], GateInfo[gateid][gRotY], GateInfo[gateid][gRotZ], GateInfo[gateid][gVW], GateInfo[gateid][gInt], -1, 60.0);
	}
	if(GateInfo[gateid][gPosX] == 0.0 && GateInfo[gateid][gPosY] == 0.0) {
		if(IsValidDynamicObject(GateInfo[gateid][gGATE])) DestroyDynamicObject(GateInfo[gateid][gGATE]);
	}
	if(GateInfo[gateid][gModel] == 0) {
		if(IsValidDynamicObject(GateInfo[gateid][gGATE])) DestroyDynamicObject(GateInfo[gateid][gGATE]);
	}
}

IsAtTruckDeliveryPoint(playerid)
{
	for(new i = 0; i < sizeof(TruckerDropoffs); i++)
	{
		if(IsPlayerInRangeOfPoint(playerid, 10, TruckerDropoffs[i][PosX], TruckerDropoffs[i][PosY], TruckerDropoffs[i][PosZ])) {
		    return 1;
		}
	}
	return false;
}
CancelTruckDelivery(playerid)
{
    new vehicleid = GetPlayerVehicleID(playerid);
	if(TruckDeliveringTo[TruckUsed[playerid]] != INVALID_BUSINESS_ID)
	{
	    if(TruckDeliveringTo[TruckUsed[playerid]] == BUSINESS_TYPE_GASSTATION)
	    {
	        DestroyVehicle(GetPVarInt(playerid, "Gas_TrailerID"));
	        DeletePVar(playerid, "Gas_TrailerID");
	    }
	    Businesses[TruckDeliveringTo[TruckUsed[playerid]]][bOrderState] = 1;
		SaveBusiness(TruckDeliveringTo[TruckUsed[playerid]]);
	}
	if(1 <= TruckUsed[playerid] <= MAX_VEHICLES){
		TruckDeliveringTo[TruckUsed[playerid]] = INVALID_BUSINESS_ID, TruckContents{TruckUsed[playerid]} = 0;
	}
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		if(IsATruckerCar(vehicleid)) SetVehicleToRespawn(vehicleid);
	}
	gPlayerCheckpointStatus[playerid] = CHECKPOINT_NONE;
	TruckUsed[playerid] = INVALID_VEHICLE_ID;
 	DisablePlayerCheckpoint(playerid);
 	DeletePVar(playerid, "TruckDeliver");
	return 1;
}

AntiDeAMX()
{
    new a[][] = {
        "Unarmed (Fist)",
        "Brass K"
    };
    #pragma unused a
}

ProxDetector(Float: f_Radius, playerid, string[],col1,col2,col3,col4,col5,chat=0)
{
	if(WatchingTV[playerid] != 1) {

		new
			Float: f_playerPos[3];

		GetPlayerPos(playerid, f_playerPos[0], f_playerPos[1], f_playerPos[2]);
		new str[128];
		foreach(new i: Player)
		{
			if((InsidePlane[playerid] == GetPlayerVehicleID(i) && GetPlayerState(i) == 2) || (InsidePlane[i] == GetPlayerVehicleID(playerid) && GetPlayerState(playerid) == 2) || (InsidePlane[playerid] != INVALID_VEHICLE_ID && InsidePlane[playerid] == InsidePlane[i])) {
				SendClientMessageEx(i, col1, string);
			}
			else if(GetPlayerVirtualWorld(i) == GetPlayerVirtualWorld(playerid)) {
				if(chat && IsPlayerInRangeOfPoint(i, f_Radius * 0.6, f_playerPos[0], f_playerPos[1], f_playerPos[2]) && PlayerInfo[i][pBugged] >= 0 && PlayerInfo[playerid][pAdmin] < 2 && PlayerInfo[i][pAdmin] < 2)
				{
				    if(playerid == i)
				    {
				    	format(str, sizeof(str), "{8D8DFF}(NGHE TROM) {CBCCCE}%s", string);
				    }
				    else {
				    	format(str, sizeof(str), "{8D8DFF}(BUG ID %d) {CBCCCE}%s", i,string);
				    }
				    SendBugMessage(PlayerInfo[i][pBugged], str);
				}

				if(IsPlayerInRangeOfPoint(i, f_Radius / 16, f_playerPos[0], f_playerPos[1], f_playerPos[2])) {
					SendClientMessageEx(i, col1, string);
				}
				else if(IsPlayerInRangeOfPoint(i, f_Radius / 8, f_playerPos[0], f_playerPos[1], f_playerPos[2])) {
					SendClientMessageEx(i, col2, string);
				}
				else if(IsPlayerInRangeOfPoint(i, f_Radius / 4, f_playerPos[0], f_playerPos[1], f_playerPos[2])) {
					SendClientMessageEx(i, col3, string);
				}
				else if(IsPlayerInRangeOfPoint(i, f_Radius / 2, f_playerPos[0], f_playerPos[1], f_playerPos[2])) {
					SendClientMessageEx(i, col4, string);
				}
				else if(IsPlayerInRangeOfPoint(i, f_Radius, f_playerPos[0], f_playerPos[1], f_playerPos[2])) {
					SendClientMessageEx(i, col5, string);
				}
			}
			if(GetPVarInt(i, "BigEar") == 1 || GetPVarInt(i, "BigEar") == 6 && GetPVarInt(i, "BigEarPlayer") == playerid) {
				new string2[128] = "(BE) ";
				strcat(string2,string, sizeof(string2));
				SendClientMessageEx(i, col1,string);
			}
		}
	}
	return 1;
}

ProxDetectorS(Float:radi, playerid, targetid)
{
	if(WatchingTV[playerid] != 1)
	{
	    if(Spectating[targetid] != 0 && PlayerInfo[playerid][pAdmin] < 2)
	    {
	    	return 0;
	    }

		new
			Float: fp_playerPos[3];

		GetPlayerPos(targetid, fp_playerPos[0], fp_playerPos[1], fp_playerPos[2]);

		if(IsPlayerInRangeOfPoint(playerid, radi, fp_playerPos[0], fp_playerPos[1], fp_playerPos[2]) && GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(targetid))
		{
			return 1;
		}
	}
	return 0;
}

ProxDetectorWrap(playerid, string[], width, Float:wrap_radius, col1, col2, col3, col4, col5)
{
	if(strlen(string) > width)
	{
		new firstline[128], secondline[128];
		strmid(firstline, string, 0, 88);
		strmid(secondline, string, 88, 150);
		format(firstline, sizeof(firstline), "%s...", firstline);
		format(secondline, sizeof(secondline), "...%s", secondline);
		ProxDetector(wrap_radius, playerid, firstline, col1, col2, col3, col4, col5);
		ProxDetector(wrap_radius, playerid, secondline, col1, col2, col3, col4, col5);
	}
	else ProxDetector(wrap_radius, playerid, string, col1, col2, col3, col4, col5);
}

GetXYInFrontOfPlayer(playerid, &Float:x, &Float:y, Float:distance)
{
    new Float:a;
    GetPlayerPos(playerid, x, y, a);
    GetPlayerFacingAngle(playerid, a);
    if (GetPlayerVehicleID(playerid))
    {
      GetVehicleZAngle(GetPlayerVehicleID(playerid), a);
    }
    x += (distance * floatsin(-a, degrees));
    y += (distance * floatcos(-a, degrees));
}

// GetXYBehindPlayer(playerid, &Float:x, &Float:y, Float:distance)
// {
//     new Float:a;
//     GetPlayerPos(playerid, x, y, a);
//     GetPlayerFacingAngle(playerid, a);
//     if (GetPlayerVehicleID(playerid))
//     {
//       GetVehicleZAngle(GetPlayerVehicleID(playerid), a);
//     }
//     x += (distance * floatsin(-a+180, degrees));
//     y += (distance * floatcos(-a+180, degrees));
// }

/*GetXYInFrontOfVehicle(playerid, &Float:x, &Float:y, Float:distance)
{
    new Float:a;
    GetVehiclePos(playerid, x, y, a);
    GetVehicleZAngle(playerid, a);
    x += (distance * floatsin(-a, degrees));
    y += (distance * floatcos(-a, degrees));
}*/

IsInRangeOfPoint(Float: fPosX, Float: fPosY, Float: fPosZ, Float: fPosX2, Float: fPosY2, Float: fPosZ2, Float: fDist) {
    fPosX -= fPosX2;
	fPosY -= fPosY2;
    fPosZ -= fPosZ2;
    return ((fPosX * fPosX) + (fPosY * fPosY) + (fPosZ * fPosZ)) < (fDist * fDist);
}



ReadyToCapture(pointid)
{
	new string[128];
	foreach(new i: Player)
	{
		if(PlayerInfo[i][pFMember] < INVALID_FAMILY_ID)
		{
			if(Points[pointid][Type] == 3 && Points[pointid][Type] == 4) return 1;
			if(Points[pointid][CapCrash] != 1)
			{
				format(string, sizeof(string), "%s da co the san sang bi chiem dong! Dung o day va /chiemdong de chiem dong no!", Points[pointid][Name]);
				Points[pointid][CaptureProccessEx] = 1;
				Points[pointid][CaptureProccess] = CreateDynamic3DTextLabel(string, COLOR_YELLOW, Points[pointid][Pointx], Points[pointid][Pointy], Points[pointid][Pointz], 10.0, _, _, _, _, _,i);
			}
		}
	}
	if(Points[pointid][CapCrash] == 1)
	{
		format(string, sizeof(string), "%s da co gang de chiem dong %s cho gia dinh %s, no se la cua ho trong %d phut nua!", Points[pointid][PlayerNameCapping], Points[pointid][Name], FamilyInfo[Points[pointid][ClaimerTeam]][FamilyName], Points[pointid][TakeOverTimer]);
		Points[pointid][CaptureProccessEx] = 2;
		Points[pointid][CaptureProccess] = CreateDynamic3DTextLabel(string, COLOR_YELLOW, Points[pointid][Pointx], Points[pointid][Pointy], Points[pointid][Pointz], 10.0, _, _, _, _, _,_);
	}
	return 1;
}

IsValidName(szPlayerName[]) {

	new
		iLength,
		 tmpName[MAX_PLAYER_NAME];


	mysql_escape_string(szPlayerName, tmpName);
	if(strcmp(szPlayerName, tmpName, false) != 0)
	{
		return 0;
	}
	iLength = strlen(szPlayerName);

	if(strfind(szPlayerName, "_", false) == -1 || szPlayerName[iLength - 1] == '_' || szPlayerName[0] == '_') {
		return 0;
	}
	else for(new i; i < iLength; ++i) {
		if(!('a' <= szPlayerName[i] <= 'z' || 'A' <= szPlayerName[i] <= 'Z' || szPlayerName[i] == '_')) {
			return 0;
		}
	}
	return 1;
}

GetPlayerPriority(Player)
{
	if(PlayerInfo[Player][pDonateRank] >= 4 || PlayerInfo[Player][pRewardHours] > 150) return 2;
	else if(PlayerInfo[Player][pAdmin] >= 1 || PlayerInfo[Player][pHelper] >= 2) return 3;
	else return 4;
}

IsPlayerInRangeOfDynamicObject(iPlayerID, iObjectID, Float: fRadius) {

	new
		Float: zfPos[3];

	GetDynamicObjectPos(iObjectID, zfPos[0], zfPos[1], zfPos[2]);
	return IsPlayerInRangeOfPoint(iPlayerID, fRadius, zfPos[0], zfPos[1], zfPos[2]);
}

Weapon_ReturnName(iModelID) {

	new
		szWepName[32] = "(none)";

	switch(iModelID) {
		case 0: szWepName = "punch";
		case 1: szWepName = "Brass Knuckles";
		case 2: szWepName = "Golf Club";
		case 3: szWepName = "Nitestick";
		case 4: szWepName = "Knife";
		case 5: szWepName = "Baseball Bat";
		case 6: szWepName = "Shovel";
		case 7: szWepName = "Pool Cue";
		case 8: szWepName = "Katana";
		case 9: szWepName = "Chainsaw";
		case 10: szWepName = "purple dildo";
		case 11: szWepName = "small white vibrator";
		case 12: szWepName = "large white vibrator";
		case 13: szWepName = "silver vibrator";
		case 14: szWepName = "bouquet of flowers";
		case 15: szWepName = "Cane";
		case 16: szWepName = "Grenade";
		case 17: szWepName = "Tear Gas";
		case 18: szWepName = "Molotov Cocktail";
		case 19: szWepName = "Jetpack";
		case 20: szWepName = "";
		case 21: szWepName = "";
		case 22: szWepName = "Colt .45";
		case 23: szWepName = "Silenced Colt .45";
		case 24: szWepName = "Desert Eagle";
		case 25: szWepName = "Shotgun";
		case 26: szWepName = "Sawn-off Shotgun";
		case 27: szWepName = "SPAS-12";
		case 28: szWepName = "Micro Uzi";
		case 29: szWepName = "MP5";
		case 30: szWepName = "AK-47";
		case 31: szWepName = "M4A1";
		case 32: szWepName = "TEC-9";
		case 33: szWepName = "Rifle";
		case 34: szWepName = "Sniper Rifle";
		case 35: szWepName = "RPG";
		case 36: szWepName = "Heat Seeker";
		case 37: szWepName = "Flamethrower";
		case 38: szWepName = "Minigun";
		case 39: szWepName = "Satchel Charge";
		case 40: szWepName = "Detonator";
		case 41: szWepName = "Spray Can";
		case 42: szWepName = "Fire Extinguisher";
		case 43: szWepName = "Camera";
		case 44: szWepName = "Nightvision Goggles";
		case 45: szWepName = "Thermal Goggles";
		case 46: szWepName = "Parachute";
	}
	return szWepName;
}

Group_ReturnAllegiance(iAllegianceID) {

	new
		szResult[16] = "None";

	switch(iAllegianceID) {
		case 1: szResult = "Los Santos";
		case 2: szResult = "San Fierro";
	}
	return szResult;
}

Group_ReturnType(iGroupType) {

	new
		szResult[32] = "None";

	switch(iGroupType) {
		case 1: szResult = "Law Enforcement";
		case 2: szResult = "Contract Agency";
		case 3: szResult = "Fire/Medic";
		case 4: szResult = "News Agency";
		case 5: szResult = "Government";
		case 6: szResult = "Judicial";
		case 7: szResult = "Transport";
		case 8: szResult = "Towing";
		case 9: szResult = "URL";
	}
	return szResult;
}

Group_DisplayDialog(iPlayerID, iGroupID) {

	new
		szTitle[22 + GROUP_MAX_NAME_LEN],
		szDialog[2048];

	format(szDialog, sizeof(szDialog),
		"{BBBBBB}Name:{FFFFFF} %s\n\
		{BBBBBB}Type:{FFFFFF} %s\n\
		{BBBBBB}Allegiance:{FFFFFF} %s\n\
		{BBBBBB}Jurisdiction:\n\
		{BBBBBB}Duty colour: {%s}(edit)\n\
		{BBBBBB}Radio colour: {%s}(edit)\n",
		arrGroupData[iGroupID][g_szGroupName],
		Group_ReturnType(arrGroupData[iGroupID][g_iGroupType]),
		Group_ReturnAllegiance(arrGroupData[iGroupID][g_iAllegiance]),
		Group_NumToDialogHex(arrGroupData[iGroupID][g_hDutyColour]),
		Group_NumToDialogHex(arrGroupData[iGroupID][g_hRadioColour])
	);

	format(szDialog, sizeof(szDialog), "%s\
		{BBBBBB}Radio access:{FFFFFF} %s (rank %i)\n\
		{BBBBBB}Department radio access:{FFFFFF} %s (rank %i)\n\
		{BBBBBB}Int radio access:{FFFFFF} %s (rank %i)\n\
		{BBBBBB}Bug access:{FFFFFF} %s (rank %i)\n\
		{BBBBBB}Government announcement:{FFFFFF} %s (rank %i)\n\
		{BBBBBB}Free name change:{FFFFFF} %s (rank %i)\n\
		{BBBBBB}Spike Strips:{FFFFFF} %s (rank %i)\n\
		{BBBBBB}Barricades:{FFFFFF} %s (rank %i)\n\
		{BBBBBB}Cones:{FFFFFF} %s (rank %i)\n\
		{BBBBBB}Flares:{FFFFFF} %s (rank %i)\n",
		szDialog,
		(arrGroupData[iGroupID][g_iRadioAccess] != INVALID_RANK) ? ("Yes") : ("No"), arrGroupData[iGroupID][g_iRadioAccess],
		(arrGroupData[iGroupID][g_iDeptRadioAccess] != INVALID_RANK) ? ("Yes") : ("No"), arrGroupData[iGroupID][g_iDeptRadioAccess],
		(arrGroupData[iGroupID][g_iIntRadioAccess] != INVALID_RANK) ? ("Yes") : ("No"), arrGroupData[iGroupID][g_iIntRadioAccess],
		(arrGroupData[iGroupID][g_iBugAccess] != INVALID_RANK) ? ("Yes") : ("No"), arrGroupData[iGroupID][g_iBugAccess],
		(arrGroupData[iGroupID][g_iGovAccess] != INVALID_RANK) ? ("Yes") : ("No"), arrGroupData[iGroupID][g_iGovAccess],
		(arrGroupData[iGroupID][g_iFreeNameChange] != INVALID_RANK) ? ("Yes") : ("No"), arrGroupData[iGroupID][g_iFreeNameChange],
		(arrGroupData[iGroupID][g_iSpikeStrips] != INVALID_RANK) ? ("Yes") : ("No"), arrGroupData[iGroupID][g_iSpikeStrips],
		(arrGroupData[iGroupID][g_iBarricades] != INVALID_RANK) ? ("Yes") : ("No"), arrGroupData[iGroupID][g_iBarricades],
		(arrGroupData[iGroupID][g_iCones] != INVALID_RANK) ? ("Yes") : ("No"), arrGroupData[iGroupID][g_iCones],
		(arrGroupData[iGroupID][g_iFlares] != INVALID_RANK) ? ("Yes") : ("No"), arrGroupData[iGroupID][g_iFlares]
	);

	format(szDialog, sizeof(szDialog),
		"%s\
		{BBBBBB}Barrels:{FFFFFF} %s (rank %i)\n\
		{BBBBBB}Crate Island Control:{FFFFFF} %s (rank %i)\n\
		{EEEEEE}Edit Locker Stock (%i)\n\
		{EEEEEE}Edit Locker Weapons (%i defined)\n\
		{EEEEEE}Edit Payments\n\
		{EEEEEE}Edit Divisions (%i defined)\n\
		{EEEEEE}Edit Ranks (%i defined)\n\
		{EEEEEE}Edit Lockers\n\
		{EEEEEE}Edit Crate Delivery Position (current distance: %.0f)\n\
		{EEEEEE}Locker Cost Type: %s\n\
		{EEEEEE}Edit the Garage Position (current distance: %.0f)",
		szDialog,
		(arrGroupData[iGroupID][g_iBarrels] != INVALID_RANK) ? ("Yes") : ("No"), arrGroupData[iGroupID][g_iBarrels],
		(arrGroupData[iGroupID][g_iCrateIsland] != INVALID_RANK) ? ("Yes") : ("No"), arrGroupData[iGroupID][g_iCrateIsland],
		arrGroupData[iGroupID][g_iLockerStock],
		Array_Count(arrGroupData[iGroupID][g_iLockerGuns], MAX_GROUP_WEAPONS),
		String_Count(arrGroupDivisions[iGroupID], MAX_GROUP_DIVS),
		String_Count(arrGroupRanks[iGroupID], MAX_GROUP_RANKS),
		GetPlayerDistanceFromPoint(iPlayerID, arrGroupData[iGroupID][g_fCratePos][0], arrGroupData[iGroupID][g_fCratePos][1], arrGroupData[iGroupID][g_fCratePos][2]),
		lockercosttype[arrGroupData[iGroupID][g_iLockerCostType]], arrGroupData[iGroupID][g_fGaragePos][0], arrGroupData[iGroupID][g_fGaragePos][1], arrGroupData[iGroupID][g_fGaragePos][2]
	);

	if(PlayerInfo[iPlayerID][pAdmin] >= 1337) strcat(szDialog, "\nGiai tan nhom");
	format(szTitle, sizeof szTitle, "{FFFFFF}Chinh sua {%s}%s", Group_NumToDialogHex(arrGroupData[iGroupID][g_hDutyColour]), arrGroupData[iGroupID][g_szGroupName]);
	return ShowPlayerDialog(iPlayerID, DIALOG_EDITGROUP, DIALOG_STYLE_LIST, szTitle, szDialog, "Lua chon", "Huy bo");
}

Array_Count(arrCount[], iMax = sizeof arrCount) {

	new
		iCount,
		iPos;

	while(iPos < iMax) if(arrCount[iPos++]) ++iCount;
	return iCount;
}

String_Count(arrCount[][], iMax = sizeof arrCount) {

	new
		iCount,
		iPos;

	while(iPos < iMax) if(arrCount[iPos++][0]) ++iCount;
	return iCount;
}

Group_GetMaxRank(iGroupID) {

	new
		iCount = MAX_GROUP_RANKS;

	while(iCount--) if(arrGroupRanks[iGroupID][iCount][0]) return iCount;
	return MAX_GROUP_RANKS-1;
}

Group_GetMaxDiv(iGroupID) {

	new
		iCount = MAX_GROUP_DIVS;

	while(iCount--) if(arrGroupDivisions[iGroupID][iCount][0]) return iCount;
	return MAX_GROUP_DIVS;
}

Group_ListGroups(iPlayerID, iDialogID = DIALOG_LISTGROUPS) {

	new
		szDialogStr[MAX_GROUPS * (GROUP_MAX_NAME_LEN + 16)],
		iCount;

	while(iCount < MAX_GROUPS) {
		if(arrGroupData[iCount][g_szGroupName][0])
			format(szDialogStr, sizeof szDialogStr, "%s\n(%i) {%s}%s{FFFFFF}", szDialogStr, iCount+1, Group_NumToDialogHex(arrGroupData[iCount][g_hDutyColour]), arrGroupData[iCount][g_szGroupName]);

		else
			format(szDialogStr, sizeof szDialogStr, "%s\n(%i) (trong)", szDialogStr, iCount+1);

		++iCount;
	}
	if(iDialogID == DIALOG_MAKELEADER)
	{
		new diagTitle[64];
		format(diagTitle, sizeof(diagTitle), "Group List - Set Leadership for %s", GetPlayerNameEx(GetPVarInt(iPlayerID, "MakingLeader")));
		return ShowPlayerDialog(iPlayerID, iDialogID, DIALOG_STYLE_LIST, diagTitle, szDialogStr, "Lua chon", "Huy bo");
	}
	else return ShowPlayerDialog(iPlayerID, iDialogID, DIALOG_STYLE_LIST, "Group List", szDialogStr, "Lua chon", "Huy bo");
}

			/*  ---------------- PUBLIC FUNCTIONS -----------------  */

forward OnPlayerModelSelection(playerid, response, listid, modelid);
forward OnPlayerModelSelectionEx(playerid, response, extraid, modelid);
//forward strfind(const string[],const sub[],bool:ignorecase=false,pos=0);
forward TruyDuoiC(playerid,pid);
public TruyDuoiC(playerid,pid)
{
    new ss[128];
    format(ss,128,"Doi tuong %s da het hieu luc truy duoi cua ban",GetPlayerNameExt(playerid));
    SendClientMessageEx(pid, COLOR_LIGHTRED,ss);
    SendClientMessageEx(playerid, COLOR_LIGHTRED, "Ban da het hieu luc su truy duoi cua canh sat");
    PlayerInfo[playerid][pTruyDuoi] = 0;
    KillTimer(timetrd[playerid]);
    return 1;
}
forward UpdateNametag();
public UpdateNametag()
{
	foreach(new i : Player)
	{
        if(IsPlayerConnected(i))
        {
            new nametag[128],Float:armour;
            GetPlayerArmour(i, armour);
            new name[40];
            if(UseMask[i] == 2 ) {
            	format(name, sizeof(name), "Stranger(%d)",UseMaskCode[i]);
            }
            else {
            	format(name, sizeof(name), "%s (%i)", GetPlayerNameEx(i),i);
            }
			if(GetPVarInt(i,#LastDMG) >= gettime() ) {

				if(armour > 1.0)
			    {
			    	format(nametag, sizeof(nametag), "{cb3030}%s\n{cb3030}%s\n{FF0000}%s", name, GetArmorDots(i), GetHealthDots(i));
			    }
			    else
			    {
			    	format(nametag, sizeof(nametag), "{cb3030}%s\n{FF0000}%s",  name, GetHealthDots(i));
			    }
			    UpdateDynamic3DTextLabelText(cNametag[i], 0xFFFFFFFF, nametag);
			}
			else {
				format(nametag, sizeof(nametag), "{%06x}%s", GetPlayerColor(i) >>> 8, name);
				UpdateDynamic3DTextLabelText(cNametag[i], 0xFFFFFFFF, nametag);

			}
		}
	}
}
stock Carspeed(playerid)
{
    new Float:Speed[3];
    GetVehicleVelocity(GetPlayerVehicleID(playerid), Speed[0], Speed[1], Speed[2]);
    return floatround(1.61*floatsqroot(floatpower(floatabs(Speed[0]), 2.0) + floatpower(floatabs(Speed[1]), 2.0) + floatpower(floatabs(Speed[2]), 2.0)) *  111.8);
}
forward LoadPlayer();
public LoadPlayer()
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(Loaded[i] == 1)
			{
				TogglePlayerControllable(i,true);
				Loaded[i] = 0;
			}
		}
	}
}

forward OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ);
public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
    if(GetPVarInt(playerid, "IsInArena") == -1)
    {
        if(GetPVarInt( playerid, "EventToken") == 0)
        {
            new string[128], mess[128];
            switch(weaponid)
            {
                case 16, 17, 18, 39: // SATCHEL, GRENADE, TEARGAS, MOLTOV
                {
                    if(PlayerInfo[playerid][pAmmo][ 7 ] >= 0)
                    {
                        PlayerInfo[playerid][pAmmo][ 7 ] -= 1;

                    }
                    if(PlayerInfo[playerid][pAmmo][ 7 ] < 0)
                    {
                        format(mess, sizeof(mess), "[LSRP-AC] %s (%d) da bi kick khoi may chu [Reason: LSRP-AC Weapon-Ammo].", GetPlayerNameEx(playerid), playerid);
                        SendClientMessageToAllEx(COLOR_LIGHTRED, mess);
                        SetTimerEx("KickPublic", 100, 0, "d", playerid);
                        format(string, sizeof(string), "* %s co the dang hack dan %d.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pAmmo][ 7 ]);
                        ABroadCast( COLOR_YELLOW, string, 2 );
                        Log("logs/hackdan.log", string);            
                    }
                }
                case 22, 23, 24: // 9mm, sdpid, DE
                {
                    if(PlayerInfo[playerid][pAmmo][ 1 ] >= 0)
                    {
                        PlayerInfo[playerid][pAmmo][ 1 ] -= 1;
                    }
                    if(PlayerInfo[playerid][pAmmo][ 1 ] < 0)
                    {
                        format(mess, sizeof(mess), "[LSRP-AC] %s (%d) da bi kick khoi may chu [Reason: LSRP-AC Weapon-Ammo].", GetPlayerNameEx(playerid), playerid);
                        SendClientMessageToAllEx(COLOR_LIGHTRED, mess);
                        SetTimerEx("KickPublic", 100, 0, "d", playerid);
                        format(string, sizeof(string), "* %s co the dang hack dan %d.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pAmmo][ 1 ]);
                        ABroadCast( COLOR_YELLOW, string, 2 );
                        Log("logs/hackdan.log", string);
                    }
                }
                case 25,26,27: // Shotgun, spawn-off, combat shotgun
                {
                    if(PlayerInfo[playerid][pAmmo][ 2 ] >= 0)
                    {
                        PlayerInfo[playerid][pAmmo][ 2 ] -= 1;
                    }
                    if(PlayerInfo[playerid][pAmmo][ 2 ] < 0)
                    {
                        format(mess, sizeof(mess), "[LSRP-AC] %s (%d) da bi kick khoi may chu [Reason: LSRP-AC Weapon-Ammo].", GetPlayerNameEx(playerid), playerid);
                        SendClientMessageToAllEx(COLOR_LIGHTRED, mess);
                        SetTimerEx("KickPublic", 100, 0, "d", playerid);
                        format(string, sizeof(string), "* %s co the dang hack dan %d.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pAmmo][ 2 ]);
                        ABroadCast( COLOR_YELLOW, string, 2 );
                        Log("logs/hackdan.log", string);
                    }
                }
                case 28,29,32: // Uzi, Tec9, Mp5
                {
                    if(PlayerInfo[playerid][pAmmo][ 3 ] >= 0)
                    {
                        PlayerInfo[playerid][pAmmo][ 3 ] -= 1;
                    }
                    if(PlayerInfo[playerid][pAmmo][ 3 ] < 0)
                    {
                        format(mess, sizeof(mess), "[LSRP-AC] %s (%d) da bi kick khoi may chu [Reason: LSRP-AC Weapon-Ammo].", GetPlayerNameEx(playerid), playerid);
                        SendClientMessageToAllEx(COLOR_LIGHTRED, mess);
                        SetTimerEx("KickPublic", 100, 0, "d", playerid);
                        format(string, sizeof(string), "* %s co the dang hack dan %d.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pAmmo][ 3 ]);
                        ABroadCast( COLOR_YELLOW, string, 2 );
                        Log("logs/hackdan.log", string);
                    }
                }
                case 30,31: // M4, Ak 47
                {
                    if(PlayerInfo[playerid][pAmmo][ 4 ] >= 0)
                    {
                        PlayerInfo[playerid][pAmmo][ 4 ] -= 1;
                    }
                    if(PlayerInfo[playerid][pAmmo][ 4 ] < 0)
                    {
                        format(mess, sizeof(mess), "[LSRP-AC] %s (%d) da bi kick khoi may chu [Reason: LSRP-AC Weapon-Ammo].", GetPlayerNameEx(playerid), playerid);
                        SendClientMessageToAllEx(COLOR_LIGHTRED, mess);
                        SetTimerEx("KickPublic", 100, 0, "d", playerid);
                        format(string, sizeof(string), "* %s co the dang hack dan %d.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pAmmo][ 4 ]);
                        ABroadCast( COLOR_YELLOW, string, 2 );
                        Log("logs/hackdan.log", string);
                    }
                }
                case 33,34: // rifle, sniper
                {
                    if(PlayerInfo[playerid][pAmmo][ 5 ] >= 0)
                    {
                        PlayerInfo[playerid][pAmmo][ 5 ] -= 1;
                    }
                    if(PlayerInfo[playerid][pAmmo][ 5 ] < 0)
                    {
                        format(mess, sizeof(mess), "[LSRP-AC] %s (%d) da bi kick khoi may chu [Reason: LSRP-AC Weapon-Ammo].", GetPlayerNameEx(playerid), playerid);
                        SendClientMessageToAllEx(COLOR_LIGHTRED, mess);
                        SetTimerEx("KickPublic", 100, 0, "d", playerid);
                        format(string, sizeof(string), "* %s co the dang hack dan %d.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pAmmo][ 5 ]);
                        ABroadCast( COLOR_YELLOW, string, 2 );
                        Log("logs/hackdan.log", string);
                    }
                }
                case 35,36,37,38: // Bazoka, RPG, Firegun, minigun
                {
                    if(PlayerInfo[playerid][pAmmo][ 6 ] >= 0)
                    {
                        PlayerInfo[playerid][pAmmo][ 6 ] -= 1;
                    }
                    if(PlayerInfo[playerid][pAmmo][ 6 ] < 0)
                    {
                        format(mess, sizeof(mess), "[LSRP-AC] %s (%d) da bi kick khoi may chu [Reason: LSRP-AC Weapon-Ammo].", GetPlayerNameEx(playerid), playerid);
                        SendClientMessageToAllEx(COLOR_LIGHTRED, mess);
                        SetTimerEx("KickPublic", 100, 0, "d", playerid);
                        format(string, sizeof(string), "* %s co the dang hack dan %d.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pAmmo][ 6 ]);
                        ABroadCast( COLOR_YELLOW, string, 2 );
                        Log("logs/hackdan.log", string);
                    }
                }
                case 40,41,42,43: // SPRAYCAN, FIREEXTINGUISHER, CAMERA
                {
                    if(PlayerInfo[playerid][pAmmo][ 8 ] >= 0)
                    {
                        PlayerInfo[playerid][pAmmo][ 8 ] -= 1;
                    }
                    if(PlayerInfo[playerid][pAmmo][ 8 ] < 0)
                    {
                        format(mess, sizeof(mess), "[LSRP-AC] %s (%d) da bi kick khoi may chu [Reason: LSRP-AC Weapon-Ammo].", GetPlayerNameEx(playerid), playerid);
                        SendClientMessageToAllEx(COLOR_LIGHTRED, mess);
                        SetTimerEx("KickPublic", 100, 0, "d", playerid);
                        format(string, sizeof(string), "* %s co the dang hack dan %d.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pAmmo][ 8 ]);
                        ABroadCast( COLOR_YELLOW, string, 2 );
                        Log("logs/hackdan.log", string);
                    }
                }
            }
        }
    }
    // for(new Sz; Sz < MAX_SZ; Sz++)
 	// {
  	// 	if(IsPlayerInRangeOfPoint(playerid, SafeZoneInfo[Sz][szKhoangcach], SafeZoneInfo[Sz][szExteriorX], SafeZoneInfo[Sz][szExteriorY], SafeZoneInfo[Sz][szExteriorZ]))
  	// 	{
  	// 	    if(!IsACop(playerid) && PlayerInfo[playerid][pAdmin] < 1)
	// 		{
	//   		    if(PlayerInfo[playerid][pWated2] >= 2)
	// 			{
	// 			    new string[120];
	// 			    format(string, sizeof(string), "AdmCmd: %s da bi phat tu boi System, ly do: Safezone", GetPlayerNameEx(playerid));
	// 				SendClientMessageToAll( COLOR_LIGHTRED,string);
	// 				new rand = random(sizeof(LSPDJailSpawns));
	// 				SetPlayerFacingAngle(playerid, LSPDJailSpawns[rand][2]);
	// 				SetPlayerPos(playerid, LSPDJailSpawns[rand][0], LSPDJailSpawns[rand][1], LSPDJailSpawns[rand][2]);
	// 	        	ResetPlayerWeapons(playerid);
	// 		        SetPlayerHealth(playerid, 100);
	// 		        SetPlayerSkin(playerid, 50);
	// 		        PlayerInfo[playerid][pModel] = 50;
	//     			SetPlayerColor(playerid, TEAM_APRISON_COLOR);
	// 		        ResetPlayerWeaponsEx(playerid);
	// 			    PlayerInfo[playerid][pJailTime] += 300;//Seconds "5 Ph?t"
	// 			    PlayerInfo[playerid][pWated2] = 0;
	// 				strcpy(PlayerInfo[playerid][pPrisonReason], "[IC] Anti Safezone", 128);
	// 				strcpy(PlayerInfo[playerid][pPrisonedBy], "System", 128);
	// 			}
	// 			else
	// 			{
	//             	PlayerInfo[playerid][pWated2] += 1;
	//             	SendClientMessageEx(playerid, COLOR_GREY, "Ban vua no sung trong khu vuc bao ve, neu ban van tiep tu no sung ban se bi phat tu.");
	//             }
	//         }
  	// 	}
 	// }
 	if (hittype == BULLET_HIT_TYPE_VEHICLE) {
        new
			target = INVALID_PLAYER_ID
		;
		for (new i; i < MAX_PLAYERS; i++) {
            if (i != playerid && IsPlayerConnected(i) && GetPlayerVehicleID(i) == hitid && GetPlayerVehicleSeat(i) == 0) {
                target = i;
                break;
            }
        }
        for(new Sz; Sz < MAX_SZ; Sz++)
 	    {
  		    if (target != INVALID_PLAYER_ID && IsPlayerInRangeOfPoint(playerid, SafeZoneInfo[Sz][szKhoangcach], SafeZoneInfo[Sz][szExteriorX], SafeZoneInfo[Sz][szExteriorY], SafeZoneInfo[Sz][szExteriorZ])) {
				    return 0;
  		    }
  		    if(target != INVALID_PLAYER_ID && !IsPlayerInRangeOfPoint(playerid, SafeZoneInfo[Sz][szKhoangcach], SafeZoneInfo[Sz][szExteriorX], SafeZoneInfo[Sz][szExteriorY], SafeZoneInfo[Sz][szExteriorZ] ))
  		    {
				if(IsPlayerInRangeOfPoint(hitid, SafeZoneInfo[Sz][szKhoangcach], SafeZoneInfo[Sz][szExteriorX], SafeZoneInfo[Sz][szExteriorY], SafeZoneInfo[Sz][szExteriorZ]))
				{
				    return 0;
				}
  		    }
  		}
    }
	if((22 <= weaponid <= 34) && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && PlayerInfo[playerid][pAdmin] < 2)
	{
	    new time = NetStats_GetConnectedTime(playerid);
		new string[128];
	    if((28 <= weaponid <= 32))
	    {
	        if((time - PlayerInfo[playerid][pLastFire]) < 85)
	        {
       		PlayerInfo[playerid][pRapidFire]++;
	        if(PlayerInfo[playerid][pRapidFire] >= 3)
	        {
	            format(string,sizeof(string),"{AA3333}AdmWarning{FFFF00}: %s (ID: %d) co the dang su dung hack rapid fire.",GetPlayerNameEx(playerid), playerid);
				ABroadCast(COLOR_YELLOW , string, 2);
	        }
	        }
	    }
	    if(weaponid == 24 || weaponid == 33 || weaponid == 34)
	    {
	        if((time - PlayerInfo[playerid][pLastFire]) < 700)
	        {
	       	PlayerInfo[playerid][pRapidFire]++;
	        if(PlayerInfo[playerid][pRapidFire] >= 3)
	        {
	            format(string,sizeof(string),"{AA3333}AdmWarning{FFFF00}: %s (ID: %d) co the dang su dung hack rapid fire.",GetPlayerNameEx(playerid), playerid);
				ABroadCast(COLOR_YELLOW , string, 2);
	        }
	        }
	    }
	    if((25 <= weaponid <= 27) || weaponid == 22 || weaponid == 23)
	    {
	        if((time - PlayerInfo[playerid][pLastFire]) < 300)
	        {
	       	PlayerInfo[playerid][pRapidFire]++;
	        if(PlayerInfo[playerid][pRapidFire] >= 3)
	        {
	            format(string,sizeof(string),"{AA3333}AdmWarning{FFFF00}: %s (ID: %d) co the dang su dung hack rapid fire.",GetPlayerNameEx(playerid), playerid);
				ABroadCast(COLOR_YELLOW , string, 2);
	        }
	        }
	    }
	    PlayerInfo[playerid][pLastFire] = time;
	}
    return 1;
}

forward AntiSpeed(playerid);
public AntiSpeed(playerid)
{
    if(IsPlayerInAnyVehicle(playerid))
    {
        if(GetVehicleSpeed(GetPlayerVehicleID(playerid)) > 200)
        {
            new antispeed2[128], Float:slx, Float:sly, Float:slz, vehicleid;
            GetPlayerPos(playerid, slx, sly, slz);
            SetPlayerPos(playerid, slx, sly, slz+1.3);
            PlayerPlaySound(playerid, 1130, slx, sly, slz+1.3);
            format(antispeed2, sizeof(antispeed2), "AdmWarnings: %s (ID %d) (Vehicle %d) Nghi Van Hack Speed Vehicle", GetPlayerNameEx(playerid), playerid, GetVehicleName(vehicleid), vehicleid);
            ABroadCast(COLOR_YELLOW, antispeed2, 1);
            ShowPlayerDialog(playerid, DIALOG_STYLE_MSGBOX, DIALOG_STYLE_MSGBOX, "Anti Cheat V1", "Phat hien nghi van hack", "Thoat Ra", "");
        }
    }
}


stock SendHelperMessage(color,mess[])
{
	foreach(new i:Player)
	{
	    if(!IsPlayerConnected(i)) continue;
	    if(PlayerInfo[i][pHelper] >= 1)
	    {
	        SendClientMessageEx(i,color,mess);
	    }
	}
	return 1;
}
stock LoadWeaponFactory() {
new tmpobjid;
tmpobjid = CreateDynamicObjectEx(19377, -721.126953, 1449.876953, -91.590583, 0.000000, 90.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14387, "dr_gsnew", "la_flair1", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19377, -731.625549, 1449.878784, -91.590583, 0.000000, 90.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14387, "dr_gsnew", "la_flair1", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19379, -716.204589, 1449.508911, -91.507522, 0.000000, 0.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 12850, "cunte_block1", "ws_redbrickold", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19379, -720.787109, 1444.993896, -91.507499, 0.000000, 0.000000, 90.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 12850, "cunte_block1", "ws_redbrickold", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19379, -720.877014, 1463.727294, -91.507499, 0.000000, 0.000000, 90.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 12850, "cunte_block1", "ws_redbrickold", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19379, -716.204650, 1459.130737, -91.507522, 0.000000, 0.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 12850, "cunte_block1", "ws_redbrickold", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19379, -730.418579, 1444.995361, -91.507499, 0.000000, 0.000000, 90.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 12850, "cunte_block1", "ws_redbrickold", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19379, -725.728027, 1458.965087, -91.507522, 0.000000, 0.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 12850, "cunte_block1", "ws_redbrickold", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19379, -730.457824, 1454.234619, -91.507499, 0.000000, 0.000000, 90.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 12850, "cunte_block1", "ws_redbrickold", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19379, -731.192749, 1449.509643, -91.507522, 0.000000, 0.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 12850, "cunte_block1", "ws_redbrickold", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19376, -731.188659, 1449.822509, -95.071563, 0.000000, 0.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14581, "ab_mafiasuitea", "cof_wood2", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19381, -736.347961, 1449.327758, -90.458702, 0.000000, 90.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14392, "dr_gsstudio", "la_flair2", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19376, -730.454589, 1454.232177, -95.071601, 0.000000, 0.000000, 90.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14581, "ab_mafiasuitea", "cof_wood2", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19381, -730.883056, 1458.956665, -90.286758, 0.000000, 90.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14392, "dr_gsstudio", "la_flair2", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19381, -736.347900, 1449.325683, -90.286758, 0.000000, 90.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14392, "dr_gsstudio", "la_flair2", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19376, -725.722778, 1458.961791, -95.071563, 0.000000, 0.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14581, "ab_mafiasuitea", "cof_wood2", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19376, -721.016906, 1463.724731, -95.071601, 0.000000, 0.000000, 90.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14581, "ab_mafiasuitea", "cof_wood2", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19376, -716.205505, 1458.922973, -95.071563, 0.000000, 0.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14581, "ab_mafiasuitea", "cof_wood2", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19376, -716.206665, 1449.297485, -95.071563, 0.000000, 0.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14581, "ab_mafiasuitea", "cof_wood2", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19376, -721.059753, 1444.997802, -95.071601, 0.000000, 0.000000, 90.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14581, "ab_mafiasuitea", "cof_wood2", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19376, -730.692321, 1444.998291, -95.071601, 0.000000, 0.000000, 90.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14581, "ab_mafiasuitea", "cof_wood2", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19381, -720.414611, 1468.450073, -89.737701, 0.000000, 90.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14392, "dr_gsstudio", "la_flair2", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19381, -711.047302, 1458.895751, -90.286758, 0.000000, 90.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14392, "dr_gsstudio", "la_flair2", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19381, -721.546447, 1440.274902, -90.286758, 0.000000, 90.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14392, "dr_gsstudio", "la_flair2", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19381, -711.048889, 1449.269409, -90.286758, 0.000000, 90.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14392, "dr_gsstudio", "la_flair2", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19381, -732.045471, 1440.272827, -90.286758, 0.000000, 90.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14392, "dr_gsstudio", "la_flair2", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19381, -730.883117, 1458.956665, -90.458702, 0.000000, 90.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14392, "dr_gsstudio", "la_flair2", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19381, -732.045471, 1440.272827, -90.458702, 0.000000, 90.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14392, "dr_gsstudio", "la_flair2", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19381, -721.546386, 1440.274902, -90.458702, 0.000000, 90.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14392, "dr_gsstudio", "la_flair2", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19381, -711.048889, 1449.269409, -90.458702, 0.000000, 90.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14392, "dr_gsstudio", "la_flair2", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19381, -711.047302, 1458.895751, -90.458702, 0.000000, 90.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14392, "dr_gsstudio", "la_flair2", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19381, -720.414611, 1468.450073, -90.458702, 0.000000, 90.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14392, "dr_gsstudio", "la_flair2", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19381, -720.414550, 1468.450073, -90.286758, 0.000000, 90.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14392, "dr_gsstudio", "la_flair2", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19381, -711.047302, 1458.895751, -89.737701, 0.000000, 90.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14392, "dr_gsstudio", "la_flair2", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19381, -711.048889, 1449.269409, -89.737701, 0.000000, 90.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14392, "dr_gsstudio", "la_flair2", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19381, -721.546386, 1440.274902, -89.737701, 0.000000, 90.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14392, "dr_gsstudio", "la_flair2", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19381, -720.825683, 1457.600097, -81.285003, 0.000000, 0.000000, 90.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19381, -730.883117, 1458.956665, -86.445701, 0.000000, 90.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19381, -736.347900, 1449.325683, -89.737701, 0.000000, 90.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14392, "dr_gsstudio", "la_flair2", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19929, -720.047668, 1462.102783, -92.014389, 0.000000, 0.000000, 90.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 1, 3095, "a51jdrx", "sam_camo", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19929, -718.293090, 1463.182495, -91.200187, 0.000000, 0.000000, 153.003890, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 1259, "billbrd", "ws_oldpainted2", 0x00000000);
SetDynamicObjectMaterial(tmpobjid, 1, 3095, "a51jdrx", "sam_camo", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19929, -720.047424, 1462.104736, -91.198196, 0.000000, 0.000000, 90.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 1259, "billbrd", "ws_oldpainted2", 0x00000000);
SetDynamicObjectMaterial(tmpobjid, 1, 3095, "a51jdrx", "sam_camo", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19929, -718.291625, 1463.181152, -92.014396, 0.000000, 0.000000, 153.003906, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 1, 3095, "a51jdrx", "sam_camo", 0x00000000);
tmpobjid = CreateDynamicObjectEx(1569, -731.095703, 1448.050292, -91.505500, 0.000000, 0.000000, 90.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 10763, "airport1_sfse", "ws_airportdoors1", 0x00000000);
tmpobjid = CreateDynamicObjectEx(1569, -731.102661, 1451.050292, -91.505500, 0.000000, 0.000000, 270.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 10763, "airport1_sfse", "ws_airportdoors1", 0x00000000);
tmpobjid = CreateDynamicObjectEx(631, -730.542602, 1445.598632, -90.612297, 0.000000, 0.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 17958, "burnsalpha", "plantb256", 0xFF99FF33);
tmpobjid = CreateDynamicObjectEx(631, -730.598022, 1453.617797, -90.612297, 0.000000, 0.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 17958, "burnsalpha", "plantb256", 0xFF99FF33);
tmpobjid = CreateDynamicObjectEx(2387, -724.982299, 1450.978637, -91.505073, 0.000000, 0.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 3076, "ad_rmx", "ammo_tube", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19430, -721.129211, 1454.610595, -91.354141, 0.000000, 10.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 1259, "billbrd", "ws_oldpainted2", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19430, -720.739990, 1453.764770, -91.360702, 0.000000, 0.000000, 90.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19430, -720.345703, 1454.612548, -91.354103, 0.000000, -10.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 1259, "billbrd", "ws_oldpainted2", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19430, -721.127258, 1456.202148, -91.354141, 0.000000, 10.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 1259, "billbrd", "ws_oldpainted2", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19430, -721.129760, 1457.806030, -91.354141, 0.000000, 10.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 1259, "billbrd", "ws_oldpainted2", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19430, -720.345825, 1456.215576, -91.354103, 0.000000, -10.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 1259, "billbrd", "ws_oldpainted2", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19430, -720.345947, 1457.807861, -91.354103, 0.000000, -10.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 1259, "billbrd", "ws_oldpainted2", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19430, -720.699768, 1458.537353, -91.360702, 0.000000, 0.000000, 90.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19430, -720.398986, 1447.850708, -91.354103, 0.000000, -10.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 1259, "billbrd", "ws_oldpainted2", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19430, -720.399108, 1449.453735, -91.354103, 0.000000, -10.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 1259, "billbrd", "ws_oldpainted2", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19430, -721.180541, 1449.440307, -91.354141, 0.000000, 10.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 1259, "billbrd", "ws_oldpainted2", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19430, -721.183044, 1451.044189, -91.354141, 0.000000, 10.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 1259, "billbrd", "ws_oldpainted2", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19430, -720.399230, 1451.046020, -91.354103, 0.000000, -10.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 1259, "billbrd", "ws_oldpainted2", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19430, -720.753051, 1451.775512, -91.360702, 0.000000, 0.000000, 90.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19430, -720.793273, 1447.002929, -91.360702, 0.000000, 0.000000, 90.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19430, -721.182495, 1447.848754, -91.354141, 0.000000, 10.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 1259, "billbrd", "ws_oldpainted2", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19360, -721.428283, 1448.671386, -92.731498, 0.000000, 10.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19360, -721.426757, 1450.094604, -92.731498, 0.000000, 10.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19360, -721.375366, 1455.444824, -92.731498, 0.000000, 10.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19360, -720.096862, 1455.430053, -92.731498, 0.000000, -10.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19360, -720.151184, 1450.093994, -92.731498, 0.000000, -10.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19360, -720.095214, 1456.871093, -92.731498, 0.000000, -10.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19360, -720.150390, 1448.553955, -92.731498, 0.000000, -10.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19844, -725.137573, 1447.530029, -89.844001, -0.006000, 0.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 10370, "alleys_sfs", "ws_asphalt", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19844, -725.137573, 1447.530029, -90.825996, -0.006000, 0.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 10370, "alleys_sfs", "ws_asphalt", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19452, -720.750610, 1451.235595, -91.585899, 0.000000, 90.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14383, "burg_1", "carpet4kb", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19452, -720.751342, 1454.259643, -91.587898, 0.000000, 90.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14383, "burg_1", "carpet4kb", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19450, -718.916320, 1454.259521, -93.247596, 0.000000, 0.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14786, "ab_sfgymbeams", "knot_wood128", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19450, -718.917053, 1451.238525, -93.237594, 0.000000, 0.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14786, "ab_sfgymbeams", "knot_wood128", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19450, -722.587768, 1451.233642, -93.247596, 0.000000, 0.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14786, "ab_sfgymbeams", "knot_wood128", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19450, -722.585510, 1454.258056, -93.237586, 0.000000, 0.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14786, "ab_sfgymbeams", "knot_wood128", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19358, -720.432006, 1459.006103, -93.243598, 0.000000, 0.000000, 90.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14786, "ab_sfgymbeams", "knot_wood128", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19358, -721.069946, 1459.006835, -93.245597, 0.000000, 0.000000, 90.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14786, "ab_sfgymbeams", "knot_wood128", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19358, -721.071899, 1446.504882, -93.245597, 0.000000, 0.000000, 90.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14786, "ab_sfgymbeams", "knot_wood128", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19358, -720.433593, 1446.505615, -93.243598, 0.000000, 0.000000, 90.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14786, "ab_sfgymbeams", "knot_wood128", 0x00000000);
tmpobjid = CreateDynamicObjectEx(2387, -723.458801, 1460.792358, -91.505073, 0.000000, 0.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 3076, "ad_rmx", "ammo_tube", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19377, -721.126892, 1459.508056, -86.286491, 0.000000, 90.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 3095, "a51jdrx", "sam_camo", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19087, -725.132873, 1447.527587, -89.803100, 0.000000, 0.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 18049, "ammu_twofloor", "gun_ceiling2", 0x00000000);
tmpobjid = CreateDynamicObjectEx(631, -716.891540, 1463.002075, -90.623703, 0.000000, 0.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF99FF33);
tmpobjid = CreateDynamicObjectEx(19360, -721.377380, 1456.885864, -92.731498, 0.000000, 10.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19430, -716.208923, 1456.934936, -88.490310, 90.000000, 0.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 1259, "billbrd", "ws_oldpainted2", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19430, -716.214904, 1449.007080, -88.490310, 90.000000, 0.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 1259, "billbrd", "ws_oldpainted2", 0x00000000);
tmpobjid = CreateDynamicObjectEx(2036, -716.343688, 1456.192504, -88.368362, 90.000000, 0.000000, 270.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "ab_wood02", 0x00000000);
tmpobjid = CreateDynamicObjectEx(2036, -716.343688, 1456.192504, -88.774398, 90.000000, 0.000000, 270.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "ab_wood02", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19430, -723.349792, 1445.004760, -88.490303, 90.000000, 0.000000, 90.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 1259, "billbrd", "ws_oldpainted2", 0x00000000);
tmpobjid = CreateDynamicObjectEx(2035, -722.421569, 1445.097900, -88.635200, 90.000000, 0.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19443, -723.349304, 1444.297729, -89.344802, 0.000000, 90.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19443, -723.349304, 1444.297729, -87.670700, 0.000000, 90.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19439, -725.176940, 1443.353271, -88.383102, 90.000000, 0.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19439, -725.176757, 1443.351318, -88.630096, 90.000000, 0.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19439, -721.552062, 1443.352661, -88.632102, 90.000000, 0.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19439, -721.552062, 1443.354614, -88.383102, 90.000000, 0.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19439, -715.503112, 1449.008300, -89.291000, 0.000000, 90.000000, 90.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19439, -715.503112, 1449.008300, -87.754997, 0.000000, 90.000000, 90.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19439, -715.497436, 1456.936035, -87.754997, 0.000000, 90.000000, 90.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19439, -715.498657, 1456.935180, -89.291000, 0.000000, 90.000000, 90.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19439, -714.549072, 1455.101806, -88.469001, 90.000000, 90.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19439, -714.549133, 1455.101806, -88.581947, 90.000000, 90.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19439, -714.548278, 1458.772216, -88.582000, 90.000000, 90.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19439, -714.550292, 1458.772216, -88.469001, 90.000000, 90.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19439, -714.556579, 1450.833496, -88.469001, 90.000000, 90.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19439, -714.556640, 1450.833496, -88.581947, 90.000000, 90.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19439, -714.557922, 1447.257080, -88.468002, 90.000000, 90.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19439, -714.555908, 1447.256958, -88.581947, 90.000000, 90.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
tmpobjid = CreateDynamicObjectEx(631, -716.718139, 1445.573242, -90.623703, 0.000000, 0.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF99FF33);
tmpobjid = CreateDynamicObjectEx(19377, -721.126892, 1459.508056, -91.590583, 0.000000, 90.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14387, "dr_gsnew", "la_flair1", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19377, -731.625488, 1449.878784, -86.286499, 0.000000, 90.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 3095, "a51jdrx", "sam_camo", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19377, -721.127014, 1449.876953, -86.286499, 0.000000, 90.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 3095, "a51jdrx", "sam_camo", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19381, -732.045471, 1440.273193, -89.737701, 0.000000, 90.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14392, "dr_gsstudio", "la_flair2", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19381, -720.826904, 1457.431396, -81.285003, 0.000000, 0.000000, 90.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19381, -720.820373, 1461.097534, -81.285003, 0.000000, 0.000000, 90.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19381, -720.827514, 1460.930786, -81.285003, 0.000000, 0.000000, 90.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19381, -726.396362, 1452.275390, -81.285003, 0.000000, 0.000000, 90.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19381, -726.306457, 1446.991210, -81.285003, 0.000000, 0.000000, 90.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19381, -726.305847, 1447.161743, -81.285003, 0.000000, 0.000000, 90.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19381, -726.401733, 1452.101684, -81.285003, 0.000000, 0.000000, 90.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19381, -716.773559, 1452.101684, -81.285003, 0.000000, 0.000000, 90.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19381, -716.768554, 1452.279418, -81.285003, 0.000000, 0.000000, 90.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19381, -716.699279, 1447.161010, -81.285003, 0.000000, 0.000000, 90.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19381, -716.681396, 1446.989257, -81.285003, 0.000000, 0.000000, 90.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19381, -730.883117, 1458.956665, -89.737701, 0.000000, 90.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14392, "dr_gsstudio", "la_flair2", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19381, -720.414611, 1468.450073, -86.445701, 0.000000, 90.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19381, -711.047302, 1458.895751, -86.445701, 0.000000, 90.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19381, -711.048889, 1449.269409, -86.445701, 0.000000, 90.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19381, -721.546386, 1440.274902, -86.445701, 0.000000, 90.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19381, -732.045471, 1440.283203, -86.445701, 0.000000, 90.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19381, -736.347900, 1449.325683, -86.445701, 0.000000, 90.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
tmpobjid = CreateDynamicObjectEx(2267, -725.602111, 1456.341796, -88.703903, 0.000000, 0.000000, 90.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 1, 14489, "carlspics", "AH_landscap1", 0x00000000);
tmpobjid = CreateDynamicObjectEx(2267, -725.599426, 1461.510620, -88.097877, 0.000000, 0.000000, 90.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 1, 14489, "carlspics", "AH_picture2", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19967, -723.106689, 1463.608886, -91.505783, 0.000000, 0.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 2, 18064, "ab_sfammuunits", "gun_targetb", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19974, -724.829345, 1463.601318, -91.505073, 0.000000, 0.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 2, 18064, "ab_sfammuunits", "gun_targetc", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19974, -724.038085, 1463.646484, -92.886001, 0.000000, 0.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 2, 18064, "ab_sfammuunits", "gun_targeta", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19948, -725.605163, 1462.005249, -91.505302, 0.000000, 0.000000, 90.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 2, 18064, "ab_sfammuunits", "gun_targetb", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19948, -722.149902, 1463.635375, -92.214347, 0.000000, 0.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 2, 18064, "ab_sfammuunits", "gun_targetc", 0x00000000);
tmpobjid = CreateDynamicObjectEx(11699, -725.571105, 1460.811767, -92.210418, 0.000000, 0.000000, 90.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 2, 18064, "ab_sfammuunits", "gun_targeta", 0x00000000);
tmpobjid = CreateDynamicObjectEx(2267, -718.238952, 1463.609619, -88.097900, 0.000000, 0.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 1, 19165, "gtamap", "gtasavectormap1", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19439, -729.782104, 1449.557373, -92.295600, 90.000000, 0.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14786, "ab_sfgymbeams", "knot_wood128", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19439, -731.403320, 1447.423706, -92.293601, 90.000000, 0.000000, 105.480598, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14786, "ab_sfgymbeams", "knot_wood128", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19439, -731.402404, 1451.687255, -92.293601, 90.000000, 0.000000, -105.480598, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14786, "ab_sfgymbeams", "knot_wood128", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19430, -730.603759, 1449.558715, -91.583198, 0.000000, 90.000000, 90.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14383, "burg_1", "carpet4kb", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19439, -731.845764, 1447.987548, -90.750900, 0.000000, 0.000000, 90.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14786, "ab_sfgymbeams", "knot_wood128", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19439, -731.845336, 1451.110229, -90.750900, 0.000000, 0.000000, 90.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14786, "ab_sfgymbeams", "knot_wood128", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19439, -732.794616, 1450.396728, -88.952598, 0.000000, 90.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14786, "ab_sfgymbeams", "knot_wood128", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19439, -732.795532, 1448.794189, -88.952598, 0.000000, 90.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14786, "ab_sfgymbeams", "knot_wood128", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19439, -732.795166, 1448.702880, -88.952598, 0.000000, 90.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14786, "ab_sfgymbeams", "knot_wood128", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19089, -725.631225, 1463.625854, -86.324661, 0.000000, 0.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19089, -716.290954, 1463.625854, -86.324661, 0.000000, 0.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19089, -716.310974, 1445.094238, -86.324661, 0.000000, 0.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19089, -731.091979, 1445.094238, -86.324661, 0.000000, 0.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19089, -731.091979, 1454.136352, -86.324661, 0.000000, 0.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19089, -725.641601, 1454.146362, -86.324661, 0.000000, 0.000000, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterial(tmpobjid, 0, 14789, "ab_sfgymmain", "gym_floor6", 0x00000000);
tmpobjid = CreateDynamicObjectEx(19939, -731.113464, 1451.850708, -90.959785, 0.000000, 90.799995, 0.000000, 120.00, 120.00); 
SetDynamicObjectMaterialText(tmpobjid, 0, "{ffffff} by  Kova", 130, "Engravers MT", 62, 1, 0x00000000, 0x00000000, 1);
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
tmpobjid = CreateDynamicObjectEx(349, -720.246520, 1455.260620, -90.691802, -8.000000, 270.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(1744, -720.946289, 1455.264282, -91.306701, 0.000000, 0.000000, 270.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(1744, -720.946411, 1457.190307, -91.306701, 0.000000, 0.000000, 270.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(1744, -720.947692, 1458.110839, -91.304702, 0.000000, 0.000000, 270.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(1744, -720.529479, 1456.224487, -91.306701, 0.000000, 0.000000, 90.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(1744, -720.530883, 1457.065185, -91.308700, 0.000000, 0.000000, 90.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(2387, -726.248718, 1450.975219, -91.505073, 0.000000, 0.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(1744, -720.999572, 1448.502441, -91.306701, 0.000000, 0.000000, 270.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(1744, -720.999694, 1450.428466, -91.306701, 0.000000, 0.000000, 270.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(1744, -721.000976, 1451.348999, -91.304702, 0.000000, 0.000000, 270.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(1744, -720.583129, 1447.526367, -91.306701, 0.000000, 0.000000, 90.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(1744, -720.582763, 1449.462646, -91.306701, 0.000000, 0.000000, 90.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(1744, -720.584167, 1450.303344, -91.308700, 0.000000, 0.000000, 90.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(349, -720.314880, 1449.104003, -90.691802, -8.000000, 270.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(349, -721.245605, 1451.044677, -90.691802, -7.000000, 270.000000, 181.814605, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(349, -721.270080, 1451.315673, -90.691802, -7.000000, 270.000000, 181.814605, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(349, -721.267822, 1451.615356, -90.691802, -7.000000, 270.000000, 181.814605, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(349, -721.244262, 1450.788085, -90.691802, -7.000000, 270.000000, 181.814605, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(349, -721.249389, 1449.378295, -90.691802, -7.000000, 270.000000, 181.814605, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(349, -721.264892, 1449.108520, -90.691802, -7.000000, 270.000000, 181.814605, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(349, -721.262451, 1448.860351, -90.691802, -7.000000, 270.000000, 181.814605, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(349, -721.256713, 1448.560424, -90.691802, -7.000000, 270.000000, 181.814605, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(349, -721.272216, 1448.290649, -90.691802, -7.000000, 270.000000, 181.814605, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(349, -721.270874, 1448.034057, -90.691802, -7.000000, 270.000000, 181.814605, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(349, -721.265136, 1447.734130, -90.691802, -7.000000, 270.000000, 181.814605, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(349, -721.280639, 1447.464355, -90.691802, -7.000000, 270.000000, 181.814605, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(349, -721.246704, 1450.504516, -90.691802, -7.000000, 270.000000, 181.814605, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(349, -721.240966, 1450.204589, -90.691802, -7.000000, 270.000000, 181.814605, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(349, -721.256469, 1449.934814, -90.691802, -7.000000, 270.000000, 181.814605, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(349, -721.255126, 1449.678222, -90.691802, -7.000000, 270.000000, 181.814605, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(357, -720.323974, 1450.988281, -90.706298, -8.000000, 270.000000, 1.426200, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(357, -720.330200, 1451.148193, -90.706298, -8.000000, 270.000000, 1.426200, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(357, -720.322387, 1451.308227, -90.706298, -8.000000, 270.000000, 1.426200, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(357, -720.316894, 1449.340820, -90.706298, -8.000000, 270.000000, 1.426200, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(357, -720.323120, 1449.500732, -90.706298, -8.000000, 270.000000, 1.426200, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(357, -720.321411, 1450.813476, -90.706298, -8.000000, 270.000000, 1.426200, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(349, -720.325561, 1450.361816, -90.691802, -8.000000, 270.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(349, -720.314636, 1450.581665, -90.691802, -8.000000, 270.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(349, -720.317565, 1448.909790, -90.691802, -8.000000, 270.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(357, -720.325622, 1448.283325, -90.706298, -8.000000, 270.000000, 1.426200, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(357, -720.333374, 1448.123291, -90.706298, -8.000000, 270.000000, 1.426200, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(357, -720.327087, 1447.963378, -90.706298, -8.000000, 270.000000, 1.426200, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(357, -720.324523, 1447.788574, -90.706298, -8.000000, 270.000000, 1.426200, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(357, -720.326293, 1447.628173, -90.706298, -8.000000, 270.000000, 1.426200, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(357, -720.320129, 1447.468261, -90.706298, -8.000000, 270.000000, 1.426200, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(349, -720.328735, 1448.489257, -90.691802, -8.000000, 270.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(349, -720.317810, 1448.709106, -90.691802, -8.000000, 270.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(349, -720.318054, 1447.231445, -90.691802, -8.000000, 270.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(357, -720.322387, 1450.155883, -90.706298, -8.000000, 270.000000, 1.426200, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(357, -720.330200, 1449.995849, -90.706298, -8.000000, 270.000000, 1.426200, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(357, -720.323974, 1449.835937, -90.706298, -8.000000, 270.000000, 1.426200, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(357, -720.321411, 1449.661132, -90.706298, -8.000000, 270.000000, 1.426200, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(349, -720.315917, 1451.506103, -90.691802, -8.000000, 270.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(357, -721.220581, 1456.614379, -90.706298, -7.000000, 270.000000, 181.426193, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(356, -721.270690, 1457.937133, -90.693603, -5.000000, 260.000000, 180.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(356, -721.271667, 1457.135986, -90.693603, -5.000000, 260.000000, 180.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(356, -721.274169, 1456.029052, -90.693603, -5.000000, 260.000000, 180.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(356, -721.263854, 1456.747680, -90.693603, -5.000000, 260.000000, 180.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(357, -721.206909, 1454.235473, -90.706298, -7.000000, 270.000000, 181.426193, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(349, -721.218750, 1454.068115, -90.691802, -7.000000, 270.000000, 181.814605, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(356, -721.268432, 1456.947631, -90.693603, -5.000000, 260.000000, 180.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(356, -721.268310, 1455.009521, -90.693603, -5.000000, 260.000000, 180.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(349, -721.230529, 1457.551513, -90.691802, -7.000000, 270.000000, 181.814605, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(357, -721.218688, 1457.718872, -90.706298, -7.000000, 270.000000, 181.426193, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(357, -721.219604, 1456.444458, -90.706298, -7.000000, 270.000000, 181.426193, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(356, -721.265747, 1455.643188, -90.693603, -5.000000, 260.000000, 180.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(357, -721.213684, 1455.424926, -90.706298, -7.000000, 270.000000, 181.426193, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(349, -721.225585, 1455.257568, -90.691802, -7.000000, 270.000000, 181.814605, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(349, -721.231445, 1456.277099, -90.691802, -7.000000, 270.000000, 181.814605, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(356, -721.270324, 1455.843139, -90.693603, -5.000000, 260.000000, 180.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(356, -721.266723, 1454.842041, -90.693603, -5.000000, 260.000000, 180.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(356, -721.263488, 1454.653686, -90.693603, -5.000000, 260.000000, 180.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(356, -721.258911, 1454.453735, -90.693603, -5.000000, 260.000000, 180.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(357, -721.228576, 1457.338012, -90.706298, -7.000000, 270.000000, 181.426193, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(349, -721.263488, 1458.132568, -90.691802, -7.000000, 270.000000, 181.814605, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(349, -721.261535, 1458.292724, -90.691802, -7.000000, 270.000000, 181.814605, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(356, -720.197326, 1455.500000, -90.693603, -5.000000, 260.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(357, -720.240783, 1457.019042, -90.694297, -6.000000, 270.000000, 1.426200, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(355, -720.193115, 1457.237915, -90.639602, -5.000000, 260.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(355, -720.186157, 1457.417846, -90.639602, -5.000000, 260.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(355, -720.187500, 1457.575927, -90.639602, -5.000000, 260.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(355, -720.188842, 1457.734008, -90.639602, -5.000000, 260.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(355, -720.189697, 1455.104003, -90.639602, -5.000000, 260.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(355, -720.188354, 1454.945922, -90.639602, -5.000000, 260.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(355, -720.187011, 1454.787841, -90.639602, -5.000000, 260.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(355, -720.193969, 1454.607910, -90.639602, -5.000000, 260.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(357, -720.241699, 1454.389038, -90.706298, -8.000000, 270.000000, 1.426200, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(356, -720.210083, 1454.222045, -90.693603, -5.000000, 260.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(349, -720.259277, 1453.982666, -90.691802, -8.000000, 270.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(356, -720.198303, 1456.859863, -90.693603, -5.000000, 260.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(356, -720.207153, 1457.912841, -90.693603, -5.000000, 260.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(356, -720.196838, 1456.716308, -90.693603, -5.000000, 260.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(355, -720.176940, 1456.381958, -90.639602, -5.000000, 260.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(355, -720.175598, 1456.223876, -90.639602, -5.000000, 260.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(355, -720.174255, 1456.065795, -90.639602, -5.000000, 260.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(355, -720.181213, 1455.885864, -90.639602, -5.000000, 260.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(356, -720.195251, 1456.560791, -90.693603, -5.000000, 260.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(357, -720.228881, 1455.666992, -90.694297, -6.000000, 270.000000, 1.426200, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(357, -720.219177, 1458.267089, -90.694297, -6.000000, 270.000000, 1.426200, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(357, -720.221740, 1458.059082, -90.694297, -6.000000, 270.000000, 1.426200, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(358, -725.498168, 1447.622192, -90.459396, -5.000000, 280.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(19939, -725.601074, 1447.528564, -91.293701, 90.000000, 0.000000, 90.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(358, -725.447509, 1447.329467, -90.459396, -5.000000, 280.000000, 49.104198, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(358, -725.498168, 1447.413696, -90.459396, -5.000000, 280.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(358, -725.213745, 1447.171875, -90.459396, -5.000000, 280.000000, 90.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(358, -725.293945, 1447.172241, -90.459396, -5.000000, 280.000000, 49.104198, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(358, -725.000061, 1447.162597, -90.459396, -5.000000, 280.000000, 90.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(358, -724.940246, 1447.224365, -90.459396, -5.000000, 280.000000, 139.958007, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(358, -724.780578, 1447.449829, -90.459396, -5.000000, 280.000000, 183.167755, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(358, -724.816162, 1447.356323, -90.459396, -5.000000, 280.000000, 139.958007, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(358, -724.843750, 1447.755249, -90.459396, -5.000000, 280.000000, 225.412597, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(358, -724.780151, 1447.670532, -90.459396, -5.000000, 280.000000, 183.167755, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(358, -724.970764, 1447.884521, -90.459396, -5.000000, 280.000000, 220.001586, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(358, -725.078063, 1447.894287, -90.459396, -5.000000, 280.000000, 270.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(358, -725.329895, 1447.852661, -90.459396, -5.000000, 280.000000, 324.016662, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(358, -725.258056, 1447.893188, -90.459396, -5.000000, 280.000000, 270.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(358, -725.438354, 1447.718750, -90.459396, -5.000000, 280.000000, 324.016662, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(19939, -725.464416, 1447.861694, -91.291702, 90.000000, 0.000000, 45.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(19939, -725.467956, 1447.199584, -91.293701, 90.000000, 0.000000, 135.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(19939, -725.134460, 1447.059570, -91.293701, 90.000000, 0.000000, 180.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(19939, -724.805297, 1447.197265, -91.293701, 90.000000, 0.000000, 225.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(19939, -724.667724, 1447.531616, -91.293701, 90.000000, 0.000000, 270.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(19939, -724.806518, 1447.859985, -91.293701, 90.000000, 0.000000, 315.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(19939, -725.133605, 1447.996093, -91.293701, 90.000000, 0.000000, 360.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(2387, -724.981872, 1452.211791, -91.505073, 0.000000, 0.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(2413, -716.576049, 1447.518188, -91.504203, 0.000000, 0.000000, 270.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(2413, -716.576049, 1449.279174, -91.504203, 0.000000, 0.000000, 270.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(2413, -716.563293, 1451.020751, -91.504203, 0.000000, 0.000000, 270.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(2368, -716.669677, 1459.149658, -91.505996, 0.000000, 0.000000, 270.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(2368, -716.668029, 1456.230590, -91.505996, 0.000000, 0.000000, 270.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(2368, -725.238342, 1455.067138, -91.505996, 0.000000, 0.000000, 90.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(2413, -725.241882, 1458.143554, -91.504203, 0.000000, 0.000000, 90.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(2368, -726.506530, 1445.452880, -91.505996, 0.000000, 0.000000, 180.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(2040, -724.995971, 1455.642578, -90.784698, 0.000000, 0.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(2040, -725.008056, 1456.178710, -90.784698, 0.000000, 0.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(2040, -725.196350, 1457.760253, -90.841499, 0.006000, 0.000000, 90.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(2040, -725.193786, 1458.028320, -90.841499, 0.006000, 0.000000, 90.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(2040, -725.202392, 1458.271972, -90.841499, 0.006000, 0.000000, 90.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(2040, -725.200866, 1458.504394, -90.841499, 0.006000, 0.000000, 90.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(2040, -725.210571, 1458.746337, -90.841499, 0.006000, 0.000000, 90.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(2040, -725.314453, 1458.996948, -91.177497, 0.006000, 0.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(2040, -725.216491, 1458.976928, -90.841499, 0.006000, 0.000000, 90.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(2040, -725.123657, 1459.000854, -91.177497, 0.006000, 0.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(2040, -724.932067, 1459.002807, -91.177497, 0.006000, 0.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(2040, -725.330505, 1458.577392, -91.177497, 0.006000, 0.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(2040, -725.130432, 1458.572631, -91.177497, 0.006000, 0.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(2040, -724.926696, 1458.585571, -91.177497, 0.006000, 0.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(2040, -725.341125, 1458.122924, -91.177497, 0.006000, 0.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(2040, -725.139343, 1458.150268, -91.177497, 0.006000, 0.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(343, -725.097595, 1455.481933, -90.584503, 0.000000, 0.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(343, -725.104614, 1455.615844, -90.584503, 0.000000, 0.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(343, -725.111572, 1455.749877, -90.584503, 0.000000, 0.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(343, -725.118530, 1455.883789, -90.584503, 0.000000, 0.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(343, -725.122741, 1456.040649, -90.584503, 0.000000, 0.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(343, -725.104187, 1456.200927, -90.584503, 0.000000, 0.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(346, -716.770874, 1458.652709, -90.653800, 90.000000, 0.000000, 180.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(346, -716.789123, 1458.430053, -90.653800, 90.000000, 0.000000, 180.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(346, -716.802246, 1458.226806, -90.653800, 90.000000, 0.000000, 180.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(346, -716.855224, 1457.938110, -90.830802, 90.000000, 0.000000, 180.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(346, -716.787048, 1457.987182, -90.653800, 90.000000, 0.000000, 180.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(346, -716.868591, 1458.150756, -90.830802, 90.000000, 0.000000, 180.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(346, -716.861572, 1458.358886, -90.830802, 90.000000, 0.000000, 180.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(346, -716.832824, 1458.572509, -90.830802, 90.000000, 0.000000, 180.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(348, -716.892456, 1457.390380, -90.638603, 90.000000, 0.000000, 90.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(348, -717.009277, 1456.810546, -90.815597, 90.000000, 0.000000, 90.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(348, -716.887756, 1456.806396, -90.638603, 90.000000, 0.000000, 90.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(348, -717.030761, 1457.233764, -90.815597, 90.000000, 0.000000, 90.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(351, -717.014892, 1455.117553, -90.790298, 90.000000, 0.000000, 90.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(351, -717.031494, 1454.036499, -90.784301, 90.000000, 0.000000, 96.726501, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(2358, -716.743103, 1446.822509, -91.161399, 0.000000, 0.000000, 270.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(2358, -716.731323, 1447.654174, -91.161399, 0.000000, 0.000000, 270.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(2358, -716.744689, 1449.340209, -91.161399, 0.000000, 0.000000, 270.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(2358, -716.743530, 1448.634521, -91.161399, 0.000000, 0.000000, 270.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(2040, -716.620544, 1449.607910, -90.837097, 0.000000, 0.000000, 90.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(2040, -716.633789, 1449.336547, -90.837097, 0.000000, 0.000000, 90.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(2040, -716.620361, 1449.100463, -90.837097, 0.000000, 0.000000, 90.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(2040, -716.618896, 1448.854248, -90.837097, 0.000000, 0.000000, 90.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(2040, -716.626281, 1448.441772, -90.837097, 0.000000, 0.000000, 90.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(353, -716.723815, 1446.680541, -90.913803, 90.000000, 0.000000, 90.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(353, -716.760803, 1447.493164, -90.913803, 90.000000, 0.000000, 90.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(2358, -716.674743, 1451.023193, -91.161399, 0.000000, 0.000000, 270.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(353, -716.701293, 1450.893798, -90.913803, 90.000000, 0.000000, 90.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(353, -716.661621, 1450.115356, -90.913803, 90.000000, 0.000000, 90.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(2358, -716.677856, 1450.290283, -91.161399, 0.000000, 0.000000, 270.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(347, -727.222290, 1445.712768, -90.645500, 90.000000, 0.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(347, -727.546997, 1445.713989, -90.645500, 90.000000, 0.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(347, -727.793579, 1445.704589, -90.645500, 90.000000, 0.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(352, -727.037048, 1445.598876, -90.831901, 90.000000, 0.000000, 90.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(352, -727.555236, 1445.565429, -90.831901, 90.000000, 0.000000, 90.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(352, -728.087463, 1445.609619, -90.831901, 90.000000, 0.000000, 90.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(352, -728.623535, 1445.544799, -90.831901, 90.000000, 0.000000, 90.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(350, -728.751892, 1445.703491, -90.633102, 90.000000, 0.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(358, -716.283142, 1457.490112, -88.602256, 0.000000, 0.000000, 96.016471, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(358, -716.283142, 1457.490112, -89.003257, 0.000000, 0.000000, 96.016471, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(358, -716.283142, 1457.490112, -88.200271, 0.000000, 0.000000, 96.016471, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(353, -716.299499, 1450.027954, -88.160026, 0.000000, 0.000000, 95.107559, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(353, -716.299560, 1450.027832, -88.972099, 0.000000, 0.000000, 95.107559, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(353, -716.295715, 1449.726928, -88.566062, 0.000000, 0.000000, 95.107559, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(351, -716.407348, 1449.541625, -88.244583, 0.000000, 10.000000, 279.561309, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(351, -716.407348, 1449.541625, -88.951599, 0.000000, 10.000000, 279.561309, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(351, -716.407348, 1449.541625, -88.648590, 0.000000, 10.000000, 279.561309, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(352, -716.283081, 1448.357543, -88.095703, 0.000000, 0.000000, 95.414367, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(352, -716.304626, 1448.057373, -88.908813, 0.000000, 0.000000, 95.414367, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(352, -716.357849, 1447.641967, -88.605796, 0.000000, 0.000000, 275.414398, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(372, -716.345886, 1447.927368, -88.121902, 0.000000, 0.000000, 270.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(372, -716.344604, 1448.187622, -88.536102, 0.000000, 0.000000, 270.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(355, -722.476440, 1445.098510, -89.049591, 0.000000, 0.000000, 3.504139, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(349, -723.093994, 1445.153076, -89.125892, 0.000000, 5.000000, 184.450805, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(349, -723.093994, 1445.153076, -88.825897, 0.000000, 5.000000, 184.450805, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(356, -722.570007, 1445.139404, -87.949859, 0.000000, 0.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(356, -722.570007, 1445.139404, -88.250846, 0.000000, 0.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(357, -723.998229, 1445.129516, -88.074386, 0.000000, 4.000000, 186.235992, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(357, -723.498229, 1445.135620, -88.377403, 0.000000, 4.000000, 186.235992, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(355, -724.717346, 1445.075073, -88.949592, 0.000000, 0.000000, 5.269559, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(1744, -720.529846, 1454.288208, -91.306701, 0.000000, 0.000000, 90.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(1893, -723.166198, 1457.500610, -86.537818, 0.000000, 0.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(1893, -723.243164, 1461.022827, -86.537818, 0.000000, 0.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(1893, -719.904357, 1461.005249, -86.537818, 0.000000, 0.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(1893, -719.792846, 1457.509033, -86.537818, 0.000000, 0.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(1893, -719.295227, 1447.042480, -86.537818, 0.000000, 0.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(1893, -728.515625, 1447.066650, -86.537818, 0.000000, 0.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(1893, -724.341430, 1452.167114, -86.537818, 0.000000, 0.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(1893, -724.254760, 1447.044311, -86.537818, 0.000000, 0.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(1893, -719.588256, 1452.171752, -86.537818, 0.000000, 0.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(1893, -728.741638, 1452.096313, -86.537818, 0.000000, 0.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(2266, -725.116882, 1458.194213, -89.498107, 0.000000, 0.000000, 90.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(2282, -720.073852, 1463.152832, -88.975433, 0.000000, 0.000000, 0.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(2066, -725.229064, 1459.613647, -91.503799, 0.000000, 0.000000, 90.000000, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(19430, -731.023071, 1449.751586, -91.585197, 0.000000, 90.000000, 75.513702, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(19430, -731.152832, 1449.367431, -91.585197, 0.000000, 90.000000, -75.513702, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(2056, -720.367797, 1462.220947, -90.254524, -89.700012, 0.000000, 13.300001, 120.00, 120.00); 
tmpobjid = CreateDynamicObjectEx(2056, -719.994689, 1462.113647, -90.255256, -89.700012, 0.000000, -4.399999, 120.00, 120.00);

}
forward InitiateGamemode();
public InitiateGamemode()
{
	AddPlayerClass(0, 1958.33, 1343.12, 15.36, 269.15, 0, 0, 0, 0, 0, 0);
	


	SetGameModeText(SERVER_GM_TEXT);
	// MySQL
    g_mysql_LoadMOTD();
 	g_mysql_AccountOnlineReset();
	g_mysql_LoadGiftBox();
 	mysql_LoadCrates();
 	mysql_tquery(MainPipeline, "SELECT * FROM `spraytag`", "OnSpraytagRetrieved", "d", 0);

 	LoadSafeZones();

	LoadHouses();

    LoadFurniture();
    Loadshipemnt();

	for(new i = 0 ; i < 20; i++) {
	    LoadCarDealer(i);
	}
	LoadDynamicDoors();
	LoadCompany(1); // load mechanic
	LoadCompany(2); // load casino company
	LoadDynamicMapIcons();
	LoadMailboxes();
	LoadBusinesses();
	LoadAuctions();
//	LoadTxtLabels();
	LoadPlants();
	LoadSpeedCameras();
	LoadPayNSprays();
	LoadArrestPoints();
	LoadImpoundPoints();
 	g_mysql_LoadSales();
 	g_mysql_LoadPrices();

 	LoadBusinessSales();
 	ToyList = LoadModelSelectionMenu("ToyList.txt");
	ToyList2 = LoadModelSelectionMenu("ToyList.txt");
	CarList2 = LoadModelSelectionMenu("CarList.txt");
	SkinList = LoadModelSelectionMenu("SkinList.txt");
	BinCoList = LoadModelSelectionMenu("BinCoList.txt");

	/*---[Miscs]---*/
	InitPaintballArenas();
	LoadPaintballArenas();
	InitEventPoints();
	LoadEventPoints();
	LoadGates();
	LoadElevatorStuff();
	LoadFamilies();
	LoadPoints();
	Misc_Load();
	ResetElevatorQueue();
	Elevator_Initialize();
	AntiDeAMX();
	EnableStuntBonusForAll(0);
	ShowPlayerMarkers(PLAYER_MARKERS_MODE_STREAMED);
	DisableInteriorEnterExits();
	ClearReports();
	NationSel_InitTextDraws();
	CountCitizens();
	SetNameTagDrawDistance(40.0);
	AllowInteriorWeapons(1);
 	AddPlayerClass(0, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
	ManualVehicleEngineAndLights();
	GiftAllowed = 1;
	ResetNews();
	ResetVariables();
	FixServerTime();
	SetTimer("RotateWheel",3*1000,0);
	SetTimer("MailDeliveryTimer", 60000, 1);
    SetTimer("AntiSpeed", 3000, true);
	//Island for crate system
    MAXCRATES = 10; // Sets Default Max Crates

	//LoadCarrier()
	//SelectCharmPoint();

	gWeather = random(19) + 1;
	if(gWeather == 1) gWeather=10;
	SetWeather(gWeather);

    // Streamer
    Streamer_TickRate(125);
    print("[Streamer] Loading Dynamic Static Vehicles...");
    LoadStreamerStaticVehicles();
    print("[Streamer] Loading Dynamic Pickups...");
    LoadStreamerDynamicPickups();
    print("[Streamer] Loading 3D Text Labels...");
    LoadStreamerDynamic3DTextLabels();
    UpdateSANewsBroadcast();
    print("[Streamer] Loading Dynamic Buttons...");
    LoadStreamerDynamicButtons();
    print("[Streamer] Loading Dynamic Objects...");
    LoadStreamerDynamicObjects();
    BikeParkourObjectStage[0] = 0; //BikeParkourObjectStage[1] = 0;

    // Textdraws
    print("[Textdraws] Loading Textdraws...");
    LoadTextDraws();

    // Dynamic Groups
    print("[Dynamic Groups] Loading Dynamic Groups...");
    LoadDynamicGroups();
    print("[Dynamic Groups] Loading Dynamic Groups Vehicles...");
    LoadDynamicGroupVehicles();
	print("Da chay thanh cong gamemode...");
	return 1;
}



forward CloseWestLobby();
public CloseWestLobby()
{
	MoveDynamicObject(westlobby1,239.71582031,116.09179688,1002.21502686,4);
	MoveDynamicObject(westlobby2,239.67968750,119.09960938,1002.21502686,4);
	return 1;
}

forward CloseEastLobby();
public CloseEastLobby()
{
	MoveDynamicObject(eastlobby1,253.14941406,110.59960938,1002.21502686,4);
	MoveDynamicObject(eastlobby2,253.18457031,107.59960938,1002.21502686,4);
	return 1;
}

forward LoadUser_data(playerid,name[],value[]);
public LoadUser_data(playerid,name[],value[])
{
	INI_Int("dlish",PlayerInfodl[playerid][dlish]);
    INI_Int("dlgetumd",PlayerInfodl[playerid][dlgetumd]);
 	return 1;
}
forward ClosePrisonDoor2();
public ClosePrisonDoor2()
{
	MoveDynamicObject(BlastDoors[1],-2088.76562500,-211.33984375,994.66918945, 1);
	MoveDynamicObject(BlastDoors[6] ,-2088.76562500,-209.21093750,994.66918945, 1);
	return 1;
}

forward ClosePrisonDoor3();
public ClosePrisonDoor3()
{
    MoveDynamicObject(BlastDoors[11], -2050.50097656,-205.82617188,984.02539062, 1);
    return 1;
}

forward ClosePrisonDoor4();
public ClosePrisonDoor4()
{
	MoveDynamicObject(BlastDoors[16], -2057.9 , -144.905 ,987.24, 1);
	return 1;
}

forward CloseBlastDoor();
public CloseBlastDoor()
{
	MoveDynamicObject(blastdoor[0],-764.11816406,2568.81445312,10021.5,2);
	return 1;
}

forward CloseBlastDoor2();
public CloseBlastDoor2()
{
    MoveDynamicObject(blastdoor[1],-746.02636719,2535.19433594,10021.5,2);
	return 1;
}

forward CloseBlastDoor3();
public CloseBlastDoor3()
{
	MoveDynamicObject(blastdoor[2],-765.26171875,2552.31347656,10021.5,2);
	return 1;
}

forward CloseCage();
public CloseCage()
{
   	MoveDynamicObject(cage,-773.52050781,2545.62109375,10022.29492188,2);
	return 1;
}

forward CloseLocker();
public CloseLocker()
{
	MoveDynamicObject(locker1,267.29980469,112.56640625,1003.61718750,4);
	MoveDynamicObject(locker2,264.29980469,112.52929688,1003.61718750,4);
	return 1;
}

forward CloseEntranceDoor();
public CloseEntranceDoor()
{
    MoveDynamicObject(entrancedoor,-766.27539062,2536.58691406,10019.5,2);
	return 1;
}

forward CloseCCTV();
public CloseCCTV()
{
	MoveDynamicObject(cctv1,264.44921875,115.79980469,1003.61718750,4);
	MoveDynamicObject(cctv2,267.46875000,115.83691406,1003.61718750,4);
	return 1;
}

forward CloseChief();
public CloseChief()
{
	MoveDynamicObject(chief1,229.59960938,119.50000000,1009.21875000,4);
	MoveDynamicObject(chief2,232.59960938,119.53515625,1009.21875000,4);
	return 1;
}

forward CloseSASD1();
public CloseSASD1()
{
	MoveDynamicObject(sasd1A,2511.65332031,-1697.00976562,561.79223633,4);
	MoveDynamicObject(sasd1B,2514.67211914,-1696.97485352,561.79223633,4);
	return 1;
}

forward CloseSASD2();
public CloseSASD2()
{
	MoveDynamicObject(sasd2A,2516.87548828,-1697.01525879,561.79223633,4);
	MoveDynamicObject(sasd2B,2519.89257812,-1696.97509766,561.79223633,4);
	return 1;
}

forward CloseSASD3();
public CloseSASD3()
{
	MoveDynamicObject(sasd3A,2522.15600586,-1697.01550293,561.79223633,4);
	MoveDynamicObject(sasd3B,2525.15893555,-1696.98010254,561.79223633,4);
	return 1;
}

forward CloseSASD4();
public CloseSASD4()
{
	MoveDynamicObject(sasd4A,2511.84130859,-1660.08081055,561.79528809,4);
	MoveDynamicObject(sasd4B,2514.81982422,-1660.04650879,561.80004883,4);
	return 1;
}

forward CloseSASD5();
public CloseSASD5()
{
	MoveDynamicObject(sasd5A,2522.86059570,-1660.07177734,561.80206299,4);
	MoveDynamicObject(sasd5B,2519.84228516,-1660.10888672,561.80004883,4);
	return 1;
}

forward CloseSANewsStudio();
public CloseSANewsStudio()
{
	MoveDynamicObject(SANewsStudioA,625.60937500,-10.80000019,1106.96081543,4);
	MoveDynamicObject(SANewsStudioB,625.64941406,-13.77000046,1106.96081543,4);
	return 1;
}

forward CloseSANewsPrivate();
public CloseSANewsPrivate()
{
	MoveDynamicObject(SANewsPrivateA,625.61999512,-0.55000001,1106.96081543,4);
	MoveDynamicObject(SANewsPrivateB,625.65002441,-3.54999995,1106.96081543,4);
	return 1;
}

forward CloseSANewsOffice();
public CloseSANewsOffice()
{
	MoveDynamicObject(SANewsOfficeA,614.66998291,17.82812500,1106.98425293,4);
	MoveDynamicObject(SANewsOfficeB,617.69000244,17.86899948,1106.98425293,4);
	return 1;
}

forward CloseFBILobbyLeft();
public CloseFBILobbyLeft()
{
	MoveDynamicObject(FBILobbyLeft,295.40136719,-1498.43457031,-46.13965225,4);
	return 1;
}

forward CloseFBILobbyRight();
public CloseFBILobbyRight()
{
	MoveDynamicObject(FBILobbyRight,302.39355469,-1521.62988281,-46.13965225,4);
	return 1;
}

forward CloseFBIPrivate();
public CloseFBIPrivate()
{
	MoveDynamicObject(FBIPrivate[0],299.29986572,-1492.82666016,-28.73300552,4);
	MoveDynamicObject(FBIPrivate[1],299.33737183,-1495.83911133,-28.73300552,4);
	return 1;
}
forward HideReportText(playerid);
public HideReportText(playerid)
{
  
    return 1;
}

forward Countdown(playerid);
public Countdown(playerid)
{
	if(PlayerInfo[playerid][pAdmin] >= 3 && PlayerInfo[playerid][pTogReports] == 0) {
	    if(CountDown == 0) {
	 		CountDown++;
	 		SendClientMessageToAll(COLOR_LIGHTBLUE, "** 3");
	 		SetTimerEx("Countdown", 1000, false, "i", playerid);
		} else if(CountDown == 1) {
		    CountDown++;
		    SendClientMessageToAll(COLOR_LIGHTBLUE, "** 2");
		    SetTimerEx("Countdown", 1000, false, "i", playerid);
		} else if(CountDown == 2) {
		    CountDown++;
		    SendClientMessageToAll(COLOR_LIGHTBLUE, "** 1");
		    SetTimerEx("Countdown", 1000, false, "i", playerid);
		} else if(CountDown == 3) {
		    CountDown = 0;
		    SendClientMessageToAll(COLOR_LIGHTBLUE, "** Go Go Go!");
		}
	}
	else if(IsARacer(playerid)){
	    if(CountDown == 0) {
	 		CountDown++;
			ProxDetector(30.0, playerid, "** [Bat dau dem nguoc] 3 **", 0xEB41000, 0xEB41000, 0xEB41000, 0xEB41000, 0xEB41000);
			SetTimerEx("Countdown", 1000, false, "i", playerid);
		} else if(CountDown == 1) {
		    CountDown++;
		    ProxDetector(30.0, playerid, "** [Bat dau dem nguoc] 2 **", 0xEB41000, 0xEB41000, 0xEB41000, 0xEB41000, 0xEB41000);
		    SetTimerEx("Countdown", 1000, false, "i", playerid);
		} else if(CountDown == 2) {
		    CountDown++;
		    ProxDetector(30.0, playerid, "** [Bat dau dem nguoc] 1 **", 0xEB41000, 0xEB41000, 0xEB41000, 0xEB41000, 0xEB41000);
		    SetTimerEx("Countdown", 1000, false, "i", playerid);
		} else if(CountDown == 3) {
		    CountDown = 0;
		    ProxDetector(30.0, playerid, "** [Bat dau dem nguoc] Go Go Go! **", 0xEB41000, 0xEB41000, 0xEB41000, 0xEB41000, 0xEB41000);
		}
	}
	else if(IsARacer(playerid) && PlayerInfo[playerid][pTogReports] == 1) {
	    if(CountDown == 0) {
	 		CountDown++;
			ProxDetector(30.0, playerid, "** [Bat dau dem nguoc] 3 **", 0xEB41000, 0xEB41000, 0xEB41000, 0xEB41000, 0xEB41000);
			SetTimerEx("Countdown", 1000, false, "i", playerid);
		} else if(CountDown == 1) {
		    CountDown++;
		    ProxDetector(30.0, playerid, "** [Bat dau dem nguoc] 2 **", 0xEB41000, 0xEB41000, 0xEB41000, 0xEB41000, 0xEB41000);
		    SetTimerEx("Countdown", 1000, false, "i", playerid);
		} else if(CountDown == 2) {
		    CountDown++;
		    ProxDetector(30.0, playerid, "** [Bat dau dem nguoc] 1 **", 0xEB41000, 0xEB41000, 0xEB41000, 0xEB41000, 0xEB41000);
		    SetTimerEx("Countdown", 1000, false, "i", playerid);
		} else if(CountDown == 3) {
		    CountDown = 0;
		    ProxDetector(30.0, playerid, "** [Bat dau dem nguoc] Go Go Go! **", 0xEB41000, 0xEB41000, 0xEB41000, 0xEB41000, 0xEB41000);
		}
	}
	return 1;
}
forward killPlayer(playerid);
public killPlayer(playerid)
{
	new query[128];
	if(GetPVarInt(playerid, "commitSuicide") == 1)
	{
		format(query, sizeof(query), "INSERT INTO `kills` (`id`, `killerid`, `killedid`, `date`, `weapon`) VALUES (NULL, %d, %d, NOW(), '/kill')", GetPlayerSQLId(playerid), GetPlayerSQLId(playerid));
		mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);

		SetPlayerHealth(playerid, 0);
	}
	else
		return SendClientMessageEx(playerid, COLOR_RED, "Ban da bi tan cong trong vong 10 giay, ban khong the tu tu vao luc nay...");
	return 1;
}

//Leave this here
new Float:FloorZOffsets[21] =
{
    0.0,		// 0.0,
    8.5479,		// 8.5479,
    13.99945,   // 8.5479 + (5.45155 * 1.0),
    19.45100,   // 8.5479 + (5.45155 * 2.0),
    24.90255,   // 8.5479 + (5.45155 * 3.0),
    30.35410,   // 8.5479 + (5.45155 * 4.0),
    35.80565,   // 8.5479 + (5.45155 * 5.0),
    41.25720,   // 8.5479 + (5.45155 * 6.0),
    46.70875,   // 8.5479 + (5.45155 * 7.0),
    52.16030,   // 8.5479 + (5.45155 * 8.0),
    57.61185,   // 8.5479 + (5.45155 * 9.0),
    63.06340,   // 8.5479 + (5.45155 * 10.0),
    68.51495,   // 8.5479 + (5.45155 * 11.0),
    73.96650,   // 8.5479 + (5.45155 * 12.0),
    79.41805,   // 8.5479 + (5.45155 * 13.0),
    84.86960,   // 8.5479 + (5.45155 * 14.0),
    90.32115,   // 8.5479 + (5.45155 * 15.0),
    95.77270,   // 8.5479 + (5.45155 * 16.0),
    101.22425,  // 8.5479 + (5.45155 * 17.0),
    106.67580,	// 8.5479 + (5.45155 * 18.0),
    112.12735	// 8.5479 + (5.45155 * 19.0)
};
stock Float:GetElevatorZCoordForFloor(floorid)
{
    return (GROUND_Z_COORD + FloorZOffsets[floorid] + ELEVATOR_OFFSET); // A small offset for the elevator object itself.
}

stock Float:GetDoorsZCoordForFloor(floorid)
{
	return (GROUND_Z_COORD + FloorZOffsets[floorid]);
}

forward Elevator_Boost(floorid);
public Elevator_Boost(floorid)
{
	// Increases the elevator's speed until it reaches 'floorid'

	MoveDynamicObject(Obj_Elevator, 1786.678100, -1303.459472, GetElevatorZCoordForFloor(floorid), ELEVATOR_SPEED);
    MoveDynamicObject(Obj_ElevatorDoors[0], X_DOOR_CLOSED, -1303.459472, GetDoorsZCoordForFloor(floorid), ELEVATOR_SPEED);
    MoveDynamicObject(Obj_ElevatorDoors[1], X_DOOR_CLOSED, -1303.459472, GetDoorsZCoordForFloor(floorid), ELEVATOR_SPEED);
}

forward Elevator_TurnToIdle();
public Elevator_TurnToIdle()
{
	ElevatorState = ELEVATOR_STATE_IDLE;
	ReadNextFloorInQueue();
}

forward DisableVehicleAlarm(vehicleid);
public DisableVehicleAlarm(vehicleid)
{
	new engine,lights,alarm,doors,bonnet,boot,objective;
 	GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
    SetVehicleParamsEx(vehicleid,engine,lights,VEHICLE_PARAMS_OFF,doors,bonnet,boot,objective);
	return 1;
}

forward ReleasePlayer(playerid);
public ReleasePlayer(playerid)
{
	DeletePVar(playerid, "IsFrozen");
	if(PlayerCuffed[playerid] == 0)
	{
		TogglePlayerControllable(playerid,1);
	}
}

forward ControlCam(playerid);
public ControlCam(playerid)
{
    new Float:X, Float:Y, Float:Z;
	GetDynamicObjectPos(Carrier[0], X, Y, Z);
 	SetPlayerCameraPos(playerid, X-200, Y, Z+40);
  	SetPlayerCameraLookAt(playerid, X, Y, Z);
}

forward SFPD(playerid);
public SFPD(playerid)
{
	MoveDynamicObject(SFPDObject[0], -1636.02539062,701.49707031,19994.54101562, 2.5);
 	return 1;
}

forward SFPD1(playerid);
public SFPD1(playerid)
{
	MoveDynamicObject(SFPDObject[1], -1635.99414062, 696.53320312, 19994.55078125, 2.5);
 	return 1;
}

forward SFPD2(playerid);
public SFPD2(playerid)
{
	MoveDynamicObject(SFPDObject[2],-1625.28808594,712.56250000,19994.85937500, 2.5);
 	return 1;
}

forward SFPD3(playerid);
public SFPD3(playerid)
{
	MoveDynamicObject(SFPDObject[3], -1613.92871094,681.78125000,19989.05468750, 2.5);
 	return 1;
}

forward SFPD4(playerid);
public SFPD4(playerid)
{
	MoveDynamicObject(SFPDObject[4], -1634.79492188, 712.56250000, 19994.85937500, 2.5);
 	return 1;
}

forward DoorOpen(playerid);
public DoorOpen(playerid)
{
	  MoveDynamicObject(lspddoor1, 247.2763671875,72.536186218262,1002.640625, 3.5000);
	  MoveDynamicObject(lspddoor2, 244.0330657959,72.580932617188,1002.640625, 3.5000);
	  return 1;
}
forward DoorClose(playerid);
public DoorClose(playerid)
{
	  MoveDynamicObject(lspddoor1, 246.35150146484,72.547714233398,1002.640625, 3.5000);
	  MoveDynamicObject(lspddoor2, 245.03300476074,72.568511962891,1002.640625, 3.5000);
	  return 1;
}

forward IdiotSound(playerid);
public IdiotSound(playerid)
{
    ShowPlayerDialog(playerid,DIALOG_NOTHING,DIALOG_STYLE_MSGBOX,"BUSTED!","Nghi an 15% CLEO da duoc danh gia vao tai khoan cua ban, do do ban bi ngoi tu 3 gio - neu ban vi pham trong tuong lai, ban co the bi khoa tai khoan vinh vien","Thoat","");
}

forward GasPumpSaleTimer(playerid, iBusinessID, iPumpID);
public GasPumpSaleTimer(playerid, iBusinessID, iPumpID)
{

	new
		Float: fPumpAmount = FUEL_PUMP_RATE / 4,
		iVehicleID = Businesses[iBusinessID][GasPumpVehicleID][iPumpID];

	if (fPumpAmount*10 + VehicleFuel[iVehicleID] > 100.0)
	{
		SendClientMessageEx(playerid, COLOR_GREEN, "Nhien lieu xe ban da day binh.");
	    StopRefueling(playerid, iBusinessID, iPumpID);
	    return 1;
	}
	else if (GetPVarInt(playerid, "Refueling") == -1)
	{
		SendClientMessageEx(playerid, COLOR_GREEN, "Ban da dung lai de tiep nhien lieu.");
	    StopRefueling(playerid, iBusinessID, iPumpID);
	    return 1;
	}
	else if (fPumpAmount > Businesses[iBusinessID][GasPumpGallons][iPumpID])
	{
		SendClientMessageEx(playerid, COLOR_RED, "Khong co xang tai tram xang nay.");
	    StopRefueling(playerid, iBusinessID, iPumpID);
	    return 1;
	}
	else if (GetPlayerCash(playerid) < floatround(Businesses[iBusinessID][GasPumpSalePrice][iPumpID]))
	{
		SendClientMessageEx(playerid, COLOR_RED, "Ban khong con tien tren nguoi.");
	    StopRefueling(playerid, iBusinessID, iPumpID);
	    return 1;
	}
	else if (GetVehicleDistanceFromPoint(iVehicleID, Businesses[iBusinessID][GasPumpPosX][iPumpID], Businesses[iBusinessID][GasPumpPosY][iPumpID], Businesses[iBusinessID][GasPumpPosZ][iPumpID]) > 5.0)
	{
	    StopRefueling(playerid, iBusinessID, iPumpID);
	    return 1;
	}

	Businesses[iBusinessID][GasPumpGallons][iPumpID] -= fPumpAmount;
	VehicleFuel[iVehicleID] += fPumpAmount*10;
	Businesses[iBusinessID][GasPumpSaleGallons][iPumpID] += fPumpAmount;
	Businesses[iBusinessID][GasPumpSalePrice][iPumpID] += fPumpAmount * Businesses[iBusinessID][bGasPrice];

	new szSaleText[148];
	format(szSaleText,sizeof(szSaleText),"Gia xang: $%.2f\nGia ban: $%.2f\nXang A93: %.3f\nXang co san: %.2f/%.2f A93", Businesses[iBusinessID][bGasPrice], Businesses[iBusinessID][GasPumpSalePrice][iPumpID], Businesses[iBusinessID][GasPumpSaleGallons][iPumpID], Businesses[iBusinessID][GasPumpGallons][iPumpID], Businesses[iBusinessID][GasPumpCapacity][iPumpID]);
	UpdateDynamic3DTextLabelText(Businesses[iBusinessID][GasPumpSaleTextID][iPumpID], COLOR_YELLOW, szSaleText);
	return 1;
}

forward DynVeh_CreateDVQuery(playerid, model, col1, col2);
public DynVeh_CreateDVQuery(playerid, model, col1, col2)
{
	new
			iFields,
			iRows,
			sqlid,
			szResult[128];

	cache_get_data(iRows, iFields, MainPipeline);
	cache_get_field_content(0, "id", szResult, MainPipeline); sqlid = strval(szResult);
	DynVehicleInfo[sqlid][gv_iModel] = model;
	DynVehicleInfo[sqlid][gv_iCol1] = col1;
	DynVehicleInfo[sqlid][gv_iCol2] = col2;
	new Float:X, Float:Y, Float:Z;
	GetPlayerPos(playerid, X, Y, Z);
	DynVehicleInfo[sqlid][gv_iVW] = GetPlayerVirtualWorld(playerid);
	DynVehicleInfo[sqlid][gv_iInt] = GetPlayerInterior(playerid);
	DynVehicleInfo[sqlid][gv_fX] = X+2;
	DynVehicleInfo[sqlid][gv_fY] = Y;
	DynVehicleInfo[sqlid][gv_fZ] = Z;
	DynVehicleInfo[sqlid][gv_igID] = INVALID_GROUP_ID;
	DynVehicleInfo[sqlid][gv_ifID] = 0;
	format(szResult, sizeof(szResult), "%s's DV Creation query has returned - attempting to spawn vehicle - SQL ID %d", GetPlayerNameEx(playerid), sqlid);
	Log("logs/dv.log", szResult);
	DynVeh_Save(sqlid);
	DynVeh_Spawn(sqlid);
	return 1;
}

forward StationSearchHTTP(index, response_code, data[]);
public StationSearchHTTP(index, response_code, data[])
{
    DeletePVar(index, "pHTTPWait");

 	if(response_code == 200)
 	{
		ShowPlayerDialog(index,STATIONSEARCHLIST,DIALOG_STYLE_LIST,"Stations",data,"Lua chon", "Quay lai");
	}
	return 1;
}

forward StationSearchInfoHTTP(index, response_code, data[]);
public StationSearchInfoHTTP(index, response_code, data[])
{
    DeletePVar(index, "pHTTPWait");

 	if(response_code == 200)
 	{
		ShowPlayerDialog(index,STATIONSEARCHLISTEN,DIALOG_STYLE_MSGBOX,"Station Info",data,"Nghe", "Quay lai");
	}
	return 1;
}

forward StationSelectHTTP(index, response_code, data[]);
public StationSelectHTTP(index, response_code, data[])
{
    DeletePVar(index, "pHTTPWait");
//    HideNoticeGUIFrame(index);
 	if(response_code == 200)
 	{
		if(IsPlayerInAnyVehicle(index))
		{
	 	    foreach(new i: Player)
			{
				if(GetPlayerVehicleID(i) != 0 && GetPlayerVehicleID(i) == GetPlayerVehicleID(index)) {
					PlayAudioStreamForPlayerEx(i, data);
				}
			}
		  	format(stationidv[GetPlayerVehicleID(index)], 64, "%s", data);
		  	new string[53];
		  	format(string, sizeof(string), "* %s thay doi tan so radio.", GetPlayerNameEx(index), string);
			ProxDetector(10.0, index, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	        DeletePVar(index, "pSelectGenre");
	        DeletePVar(index, "pSelectStation");
		}
		else if(GetPVarType(index, "pBoomBox"))
		{
		    foreach(new i: Player)
			{
				if(IsPlayerInDynamicArea(i, GetPVarInt(index, "pBoomBoxArea")))
				{
					PlayAudioStreamForPlayerEx(i, data, GetPVarFloat(index, "pBoomBoxX"), GetPVarFloat(index, "pBoomBoxY"), GetPVarFloat(index, "pBoomBoxZ"), 30.0, 1);
				}
			}
		  	SetPVarString(index, "pBoomBoxStation", data);
		}
		else
		{
		    PlayAudioStreamForPlayerEx(index, data);
		    SetPVarInt(index, "MusicIRadio", 1);
		}
	}
	return 1;
}

forward PickUpC4(playerid);
public PickUpC4(playerid)
{
   	DestroyDynamicObject(PlayerInfo[playerid][pC4]);
   	PlayerInfo[playerid][pC4] = 0;
	return 1;
}

forward Top50HTTP(index, response_code, data[]);
public Top50HTTP(index, response_code, data[])
{
	DeletePVar(index, "pHTTPWait");
 	if(response_code == 200)
 	{
		ShowPlayerDialog(index,TOP50LIST,DIALOG_STYLE_LIST,"Top 50 Stations",data,"Lua chon", "Quay lai");
	}
	return 1;
}

forward Top50InfoHTTP(index, response_code, data[]);
public Top50InfoHTTP(index, response_code, data[])
{
	DeletePVar(index, "pHTTPWait");
 	if(response_code == 200)
 	{
		ShowPlayerDialog(index,TOP50LISTEN,DIALOG_STYLE_MSGBOX,"Station Info",data,"Nghe", "Quay lai");
	}
	return 1;
}

forward GenreHTTP(index, response_code, data[]);
public GenreHTTP(index, response_code, data[])
{
	DeletePVar(index, "pHTTPWait");
 	if(response_code == 200)
 	{
		ShowPlayerDialog(index,GENRES,DIALOG_STYLE_LIST,"The loai",data,"Lua chon", "Quay lai");
	}
	return 1;
}

forward StationListHTTP(index, response_code, data[]);
public StationListHTTP(index, response_code, data[])
{
    DeletePVar(index, "pHTTPWait");
 	if(response_code == 200)
 	{
		ShowPlayerDialog(index,STATIONLIST,DIALOG_STYLE_LIST,"Stations",data,"Lua chon", "Quay lai");
	}
	return 1;
}

forward StationInfoHTTP(index, response_code, data[]);
public StationInfoHTTP(index, response_code, data[])
{
    DeletePVar(index, "pHTTPWait");
 	if(response_code == 200)
 	{
		ShowPlayerDialog(index,STATIONLISTEN,DIALOG_STYLE_MSGBOX,"Station Info",data,"Nghe", "Quay lai");
	}
	return 1;
}

forward SetCamBack(playerid);
public SetCamBack(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		new Float:plocx,Float:plocy,Float:plocz;
		GetPlayerPos(playerid, plocx, plocy, plocz);
		SetPlayerPos(playerid, -1863.15, -21.6598, 1060.15); // Warp the player
		SetPlayerInterior(playerid,14);
	}
}

forward FixHour(hourt);
public FixHour(hourt)
{
	hourt = timeshift+hourt;
	if (hourt < 0)
	{
		hourt = hourt+24;
	}
	else if (hourt > 23)
	{
		hourt = hourt-24;
	}
	shifthour = hourt;
	return 1;
}

forward HttpCallback_ShopIDCheck(index, response_code, data[]);
public HttpCallback_ShopIDCheck(index, response_code, data[])
{
	new string[128], shopstring[512], shoptechs, confirmed = strval(data);
	PlayerInfo[index][pOrderConfirmed] = confirmed;

	if(response_code == 200)
	{
		foreach(new i: Player)
		{
			if(PlayerInfo[i][pShopTech] > 0)
			{
				shoptechs++;
			}
		}

		if(shoptechs > 0)
		{
			if(confirmed)
			{
				format(shopstring, sizeof(shopstring), "{FFFFFF}Ban dang cho doi de nhan don dat hang ID: %d (Xac nhan)\n\nBan se giao hang shop tech cang som cang tot.\n\nNeu ban co nhieu don dat hang, hay lien he voi shop tech biet khi ban da giao hang den noi.\n\nShop Techs Online: %d\n\nCHU Y: Cua hang van dang cho doi neu nhu ban thoat ra hoac dang nhap lai.", PlayerInfo[index][pOrder], shoptechs);
				ShowPlayerDialog(index, DIALOG_SHOPSENT, DIALOG_STYLE_MSGBOX, "{3399FF}Shop Order", shopstring, "Dong lai", "");

				format(string, sizeof(string), "Don dat hang ID %d (Xac nhan) tu %s (ID: %d) hien dang cho.", PlayerInfo[index][pOrder], GetPlayerNameEx(index), index);
				ShopTechBroadCast(COLOR_SHOP, string);
			}
			else
			{
				format(shopstring, sizeof(shopstring), "{FFFFFF}Ban dang cho doi de nhan don dat hang ID: %d (Vi hieu)\n\nBan se giao hang shop tech cang som cang tot.\n\nNeu ban co nhieu don dat hang, hay lien he voi shop tech biet khi ban da giao hang den noi.\n\nShop Techs Online: %d\n\nCHU Y: Cua hang van dang cho doi neu nhu ban thoat ra hoac dang nhap lai.", PlayerInfo[index][pOrder], shoptechs);
				ShowPlayerDialog(index, DIALOG_SHOPSENT, DIALOG_STYLE_MSGBOX, "{3399FF}Shop Order", shopstring, "Dong lai", "");

				format(string, sizeof(string), "Don dat hang ID %d (Vo hieu) tu %s (ID: %d) hien dang cho.", PlayerInfo[index][pOrder], GetPlayerNameEx(index), index);
				ShopTechBroadCast(COLOR_SHOP, string);
			}
		}
		else
		{
			if(confirmed)
			{
				format(shopstring, sizeof(shopstring), "{FFFFFF}Ban dang cho doi de nhan don dat hang ID: %d (Xac nhan)\n\nBan se giao hang cho shop tech som cang tot.\n\nNeu ban doi qua lau xin vui long doi de nhan duoc don hang cua shop tech.\n\nHien khong co cua hang truoc tuyen nao, ban se tiep tuc choi binh thuong cho toi khi chu cua hang dang nhap vao.\n\nCHU Y: Cua hang van dang cho doi neu nhu ban thoat ra hoac dang nhap lai.", PlayerInfo[index][pOrder]);
				ShowPlayerDialog(index, DIALOG_SHOPSENT, DIALOG_STYLE_MSGBOX, "{3399FF}Shop Order", shopstring, "Dong lai", "");
			}
			else
			{
				format(shopstring, sizeof(shopstring), "{FFFFFF}Ban dang cho doi de nhan don dat hang ID: %d (Vo hieu)\n\nBan se giao hang cho shop tech som cang tot.\n\nNeu ban doi qua lau xin vui long doi de nhan duoc don hang cua shop tech.\n\nHien khong co cua hang truoc tuyen nao, ban se tiep tuc choi binh thuong cho toi khi chu cua hang dang nhap vao.\n\nCHU Y: Cua hang van dang cho doi neu nhu ban thoat ra hoac dang nhap lai.", PlayerInfo[index][pOrder]);
				ShowPlayerDialog(index, DIALOG_SHOPSENT, DIALOG_STYLE_MSGBOX, "{3399FF}Shop Order", shopstring, "Dong lai", "");
			}
		}
		new playerip[32];
		GetPlayerIp(index, playerip, sizeof(playerip));
		format(string, sizeof(string), "Don dat hang ID %d tu %s(IP: %s) hien dang cho.", PlayerInfo[index][pOrder], GetPlayerNameEx(index), playerip);
		Log("logs/shoporders.log", string);
	}
	else
	{
		PlayerInfo[index][pOrder] = 0;
		PlayerInfo[index][pOrderConfirmed] = 0;
		ShowPlayerDialog(index, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "{3399FF}Shop Order - Loi ket noi may chu", "{FFFFFF}Chung toi khong the su ly don hang cua ban vao thoi diem nay.\n\nVui long thu lai sau.", "Dong lai", "");
	}
}

forward ERequested();
public ERequested()
{
	EventKernel[EventAdvisor] = 0;
	return 1;
}

forward SetAllCopCheckpoint(Float:allx, Float:ally, Float:allz, Float:radi);
public SetAllCopCheckpoint(Float:allx, Float:ally, Float:allz, Float:radi)
{
	foreach(new i: Player)
	{
		if(IsACop(i))
		{
			SetPlayerCheckpoint(i,allx,ally,allz, radi);
		}
	}
	return 1;
}

forward ShowPlayerBeaconForCops(playerid);
public ShowPlayerBeaconForCops(playerid)
{
	foreach(new i: Player)
	{
		if(IsACop(i))
		{
			SetPlayerMarkerForPlayer(i, playerid, COP_GREEN_COLOR);
		}
	}
	return 1;
}

forward HidePlayerBeaconForCops(playerid);
public HidePlayerBeaconForCops(playerid)
{
	foreach(new i: Player)
	{
		if(IsACop(i))
		{
			SetPlayerMarkerForPlayer(i, playerid, TEAM_HIT_COLOR);
		}
	}
	SetPlayerToTeamColor(playerid);
	return 1;
}

forward ShowPlayerBeaconForMedics(playerid);
public ShowPlayerBeaconForMedics(playerid)
{
	foreach(new i: Player)
	{
		if(IsAMedic(i))
		{
			SetPlayerMarkerForPlayer(i, playerid, COP_GREEN_COLOR);
		}
	}
	return 1;
}

forward HidePlayerBeaconForMedics(playerid);
public HidePlayerBeaconForMedics(playerid)
{
	foreach(new i: Player)
	{
		if(IsAMedic(i))
		{
			SetPlayerMarkerForPlayer(i, playerid, TEAM_HIT_COLOR);
		}
	}
	SetPlayerToTeamColor(playerid);
	return 1;
}

forward TickCTF(playerid);
public TickCTF(playerid)
{
	if(GetPVarInt(playerid, "IsInArena") >= 0)
	{
	    new arenaid = GetPVarInt(playerid, "IsInArena");
	    if(PaintBallArena[arenaid][pbGameType] == 3)
	    {
	        // Flag Active Codes
			//
			// Active -1 = Flag is being carried by someone, not pickupable by anyone intill dropping.
			// Active 0 = Flag is on the stand, pickupable by only the opp team.
			// Active 1 = Flag is lying on the ground somewhere, pickupable by both teams, same team resets the flag.

			// Inactive Teams Check
			if(PaintBallArena[arenaid][pbTeamRed] == 0)
			{
			    return 1;
			}
			if(PaintBallArena[arenaid][pbTeamBlue] == 0)
			{
			    return 1;
			}

	        new teamid = PlayerInfo[playerid][pPaintTeam];
	        switch(teamid)
	        {
	            case 1: // Red Team's Tick
	            {
	                // Red Flag Checks
	                if(PaintBallArena[arenaid][pbFlagRedActive] == 0)
					{
					    if(GetPVarInt(playerid, "AOSlotPaintballFlag") != -1)
					    {
					    	if(IsPlayerInRangeOfPoint(playerid, 3.0, PaintBallArena[arenaid][pbFlagRedPos][0], PaintBallArena[arenaid][pbFlagRedPos][1], PaintBallArena[arenaid][pbFlagRedPos][2]))
	                		{
	                		    ScoreFlagPaintballArena(playerid, arenaid, 2);
	                		}
						}
					}
	                if(PaintBallArena[arenaid][pbFlagRedActive] == 1)
	                {
	                	if(IsPlayerInRangeOfPoint(playerid, 3.0, PaintBallArena[arenaid][pbFlagRedPos][0], PaintBallArena[arenaid][pbFlagRedPos][1], PaintBallArena[arenaid][pbFlagRedPos][2]))
	                	{
	                	    ResetFlagPaintballArena(arenaid, 1);
	                	}
					}

					// Blue Flag Checks
	                if(PaintBallArena[arenaid][pbFlagBlueActive] == 0)
					{
					    if(IsPlayerInRangeOfPoint(playerid, 3.0, PaintBallArena[arenaid][pbFlagBluePos][0], PaintBallArena[arenaid][pbFlagBluePos][1], PaintBallArena[arenaid][pbFlagBluePos][2]))
					    {
					        if(PaintBallArena[arenaid][pbFlagInstagib] == 1)
					        {
					            SetPlayerHealth(playerid, 1);
					            RemoveArmor(playerid);
					        }
					        if(PaintBallArena[arenaid][pbFlagNoWeapons] == 1)
					        {
					            SetPlayerArmedWeapon(playerid, 0);
					        }
							PickupFlagPaintballArena(playerid, arenaid, 2);
					    }
					}
	                if(PaintBallArena[arenaid][pbFlagBlueActive] == 1)
	                {
	                    if(IsPlayerInRangeOfPoint(playerid, 3.0, PaintBallArena[arenaid][pbFlagBluePos][0], PaintBallArena[arenaid][pbFlagBluePos][1], PaintBallArena[arenaid][pbFlagBluePos][2]))
					    {
					        if(PaintBallArena[arenaid][pbFlagInstagib] == 1)
					        {
					            SetPlayerHealth(playerid, 1);
					            RemoveArmor(playerid);
					        }
					        if(PaintBallArena[arenaid][pbFlagNoWeapons] == 1)
					        {
					            SetPlayerArmedWeapon(playerid, 0);
					        }
							PickupFlagPaintballArena(playerid, arenaid, 2);
					    }
					}
	            }
	            case 2: // Blue Team's Tick
	            {
	                // Blue Flag Checks
	                if(PaintBallArena[arenaid][pbFlagBlueActive] == 0)
	                {
	                    if(GetPVarInt(playerid, "AOSlotPaintballFlag") != -1)
	                    {
	                        if(IsPlayerInRangeOfPoint(playerid, 3.0, PaintBallArena[arenaid][pbFlagBluePos][0], PaintBallArena[arenaid][pbFlagBluePos][1], PaintBallArena[arenaid][pbFlagBluePos][2]))
	                		{
	                		    ScoreFlagPaintballArena(playerid, arenaid, 1);
	                		}
	                    }
	                }
	                if(PaintBallArena[arenaid][pbFlagBlueActive] == 1)
	                {
	                    if(IsPlayerInRangeOfPoint(playerid, 3.0, PaintBallArena[arenaid][pbFlagBluePos][0], PaintBallArena[arenaid][pbFlagBluePos][1], PaintBallArena[arenaid][pbFlagBluePos][2]))
	                	{
	                	    ResetFlagPaintballArena(arenaid, 2);
	                	}
	                }

	                // Red Flag Checks
	                if(PaintBallArena[arenaid][pbFlagRedActive] == 0)
	                {
                        if(IsPlayerInRangeOfPoint(playerid, 3.0, PaintBallArena[arenaid][pbFlagRedPos][0], PaintBallArena[arenaid][pbFlagRedPos][1], PaintBallArena[arenaid][pbFlagRedPos][2]))
					    {
					        if(PaintBallArena[arenaid][pbFlagInstagib] == 1)
					        {
					            SetPlayerHealth(playerid, 1);
                                RemoveArmor(playerid);
					        }
					        if(PaintBallArena[arenaid][pbFlagNoWeapons] == 1)
					        {
					            SetPlayerArmedWeapon(playerid, 0);
					        }
							PickupFlagPaintballArena(playerid, arenaid, 1);
					    }
	                }
	                if(PaintBallArena[arenaid][pbFlagRedActive] == 1)
	                {
	                    if(IsPlayerInRangeOfPoint(playerid, 3.0, PaintBallArena[arenaid][pbFlagRedPos][0], PaintBallArena[arenaid][pbFlagRedPos][1], PaintBallArena[arenaid][pbFlagRedPos][2]))
					    {
					        if(PaintBallArena[arenaid][pbFlagInstagib] == 1)
					        {
					            SetPlayerHealth(playerid, 1);
					            RemoveArmor(playerid);
					        }
					        if(PaintBallArena[arenaid][pbFlagNoWeapons] == 1)
					        {
					            SetPlayerArmedWeapon(playerid, 0);
					        }
							PickupFlagPaintballArena(playerid, arenaid, 1);
					    }
					}
	            }
	        }
	    }
	}
	return 1;
}
stock GetPlayerStreetZone(Float: x, Float: y, zone[], zone2[], len)
{
    for(new i = 0; i != sizeof(Streets); ++i)
    {
        if(x >= Streets[i][STREET_AREA][0] && x <= Streets[i][STREET_AREA][2] && y >= Streets[i][STREET_AREA][1] && y <= Streets[i][STREET_AREA][3])
        {
            return format(zone, len, Streets[i][STREET_NAME], 0);
        }
    }
    return format(zone, len, zone2, 0);
}
forward TickKOTH(playerid);
public TickKOTH(playerid)
{
	if(GetPVarInt(playerid, "IsInArena") >= 0)
	{
	    new arenaid = GetPVarInt(playerid, "IsInArena");

   		// Inactive Players Check
       	if(PaintBallArena[arenaid][pbPlayers] < 2)
       	{
			return 1;
		}

	    if(PaintBallArena[arenaid][pbGameType] == 4) // King of the Hill
		{
		    if(IsPlayerInCheckpoint(playerid))
			{
			    new Float:health;
			    GetPlayerHealth(playerid, health);
			    SetPlayerHealth(playerid, health+1);

			    PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
			    PlayerInfo[playerid][pKills] += 1;
			}
		}
		if(PaintBallArena[arenaid][pbGameType] == 5) // Team King of the Hill
		{
		    if(IsPlayerInCheckpoint(playerid))
			{
			    new Float:health;
			    GetPlayerHealth(playerid, health);
			    SetPlayerHealth(playerid, health+1);

			    PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);


			    switch(PlayerInfo[playerid][pPaintTeam])
			    {
			        case 1:
			        {
						PaintBallArena[arenaid][pbTeamRedScores] += 1;
			        }
			        case 2:
			        {
			            PaintBallArena[arenaid][pbTeamBlueScores] += 1;
					}
			    }
			}
		}
	}
	return 1;
}

forward MoveEMS(playerid);
public MoveEMS(playerid)
{
    new Float:mX, Float:mY, Float:mZ;
    GetPlayerPos(playerid, mX, mY, mZ);

    SetPVarFloat(GetPVarInt(playerid, "MovingStretcher"), "MedicX", mX);
	SetPVarFloat(GetPVarInt(playerid, "MovingStretcher"), "MedicY", mY);
	SetPVarFloat(GetPVarInt(playerid, "MovingStretcher"), "MedicZ", mZ);
	SetPVarInt(GetPVarInt(playerid, "MovingStretcher"), "MedicVW", GetPlayerVirtualWorld(playerid));
	SetPVarInt(GetPVarInt(playerid, "MovingStretcher"), "MedicInt", GetPlayerInterior(playerid));

	Streamer_UpdateEx(GetPVarInt(playerid, "MovingStretcher"), mX, mY, mZ);
	SetPlayerPos(GetPVarInt(playerid, "MovingStretcher"), mX, mY, mZ);
	SetPlayerInterior(GetPVarInt(playerid, "MovingStretcher"), GetPlayerVirtualWorld(playerid));
	SetPlayerVirtualWorld(GetPVarInt(playerid, "MovingStretcher"), GetPlayerVirtualWorld(playerid));

	ClearAnimations(GetPVarInt(playerid, "MovingStretcher"));
	ApplyAnimation(GetPVarInt(playerid, "MovingStretcher"), "SWAT", "gnstwall_injurd", 4.0, 0, 1, 1, 1, 0, 1);

	DeletePVar(GetPVarInt(playerid, "MovingStretcher"), "OnStretcher");
	SetPVarInt(playerid, "MovingStretcher", -1);
}

forward KillEMSQueue(playerid);
public KillEMSQueue(playerid)
{
    DeletePVar(playerid, "Injured");
    DeletePVar(playerid, "EMSAttempt");
	SetPVarInt(playerid, "MedicBill", 1);
	SetPVarInt(playerid, "ThoiGianChet", 0);
	DeletePVar(playerid, "MedicCall");
	DeletePVar(playerid, "EMSWarns");
	return 1;
}

forward SendEMSQueue(playerid,type);
public SendEMSQueue(playerid,type)
{
    #if defined zombiemode
	if(zombieevent == 1 && GetPVarType(playerid, "pIsZombie"))
	{
		KillEMSQueue(playerid);
		SpawnPlayer(playerid);
		return 1;
	}
	if(zombieevent == 1 && GetPVarType(playerid, "pZombieBit"))
	{
 		KillEMSQueue(playerid);
		ClearAnimations(playerid);
		MakeZombie(playerid);
		return 1;
	}
	#endif
	switch (type)
	{
		case 1:
		{
		    Streamer_UpdateEx(playerid, GetPVarFloat(playerid,"MedicX"), GetPVarFloat(playerid,"MedicY"), GetPVarFloat(playerid,"MedicZ"));
			SetPlayerPos(playerid, GetPVarFloat(playerid,"MedicX"), GetPVarFloat(playerid,"MedicY"), GetPVarFloat(playerid,"MedicZ"));
			SetPlayerVirtualWorld(playerid, GetPVarInt(playerid,"MedicVW"));
	  		SetPlayerInterior(playerid, GetPVarInt(playerid,"MedicInt"));

			SetPVarInt(playerid, "EMSAttempt", -1);

            if(GetPlayerInterior(playerid) > 0) Player_StreamPrep(playerid, GetPVarFloat(playerid,"MedicX"), GetPVarFloat(playerid,"MedicY"), GetPVarFloat(playerid,"MedicZ"), FREEZE_TIME);
//			GameTextForPlayer(playerid, "~r~BI THUONG~n~~w~/chapnhan chet hoac /dichvu capcuu", 5000, 3);
			ClearAnimations(playerid);
			TogglePlayerControllable(playerid, 0);
			ApplyAnimation(playerid, "WUZI", "CS_Dead_Guy", 4.1, 1, 1, 1, 1, 0, 1);
			SetPlayerHealth(playerid, 100);
			RemoveArmor(playerid);
			if(GetPVarInt(playerid, "usingfirstaid") == 1)
			{
			    firstaidexpire(playerid);
			}
			SetPVarInt(playerid,"MedicCall",1);
		}
		case 2:
		{
		    SetPVarInt(playerid,"EMSAttempt", 2);
			ClearAnimations(playerid);
		 	ApplyAnimation(playerid, "SWAT", "gnstwall_injurd", 4.0, 0, 1, 1, 1, 0, 1);
			SetPlayerHealth(playerid, 100);
			RemoveArmor(playerid);
		}
	}
	return 1;
}

forward BackupClear(playerid, calledbytimer);
public BackupClear(playerid, calledbytimer)
{
	if(IsPlayerConnected(playerid))
	{
		if(IsACop(playerid) || IsAMedic(playerid))
		{
			if (Backup[playerid] > 0)
			{
			    foreach(new i: Player)
				{
					if(IsACop(i))
					{
     					SetPlayerMarkerForPlayer(i, playerid, TEAM_HIT_COLOR);
					}
				}
				SetPlayerToTeamColor(playerid);
				new string[128];
				if (calledbytimer != 1)
				{
					SendClientMessageEx(playerid, COLOR_GRAD2, "Yeu cau backup cua ban da bi xoa.");
					format(string, sizeof(string), "* %s khong con yeu cau backup.", GetPlayerNameEx(playerid));
					foreach(new i: Player)
					{
					    switch(Backup[playerid]) {
						    case 1, 2:
							{
								if(PlayerInfo[playerid][pMember] == PlayerInfo[i][pMember]) {
									SendClientMessageEx(i, arrGroupData[PlayerInfo[playerid][pMember]][g_hRadioColour] * 256 + 255, string);
								}
							}
							default: if(IsACop(i)) {
								SendClientMessageEx(i, DEPTRADIO, string);
							}
						}
					}
				}
				else
				{
					SendClientMessageEx(playerid, COLOR_GRAD2, "Yeu cau backup da tu dong bi xoa.");
					format(string, sizeof(string), "* %s's yeu cau backup da thoi gian.", GetPlayerNameEx(playerid));
					foreach(new i: Player)
					{
					    switch(Backup[playerid]) {
						    case 1, 2:
							{
								if(PlayerInfo[playerid][pMember] == PlayerInfo[i][pMember]) {
									SendClientMessageEx(i, arrGroupData[PlayerInfo[playerid][pMember]][g_hRadioColour] * 256 + 255, string);
								}
							}
							default: if(IsACop(i)) {
								SendClientMessageEx(i, DEPTRADIO, string);
							}
						}
					}
				}
				HideBackupActiveForPlayer(playerid);
				Backup[playerid] = 0;
				BackupClearTimer[playerid] = 0;
			}
			else
			{
				if (calledbytimer != 1)
				{
					SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong co yeu cau backup con hoat dong!");
				}
			}
		}
		else
		{
			if (calledbytimer != 1)
			{
				SendClientMessageEx(playerid, COLOR_GRAD2, "   Ban phai la nhan vien thuc thi phap luat!");
			}
		}
	}
	return 1;
}

forward TurnOffFlash(playerid);
public TurnOffFlash(playerid)
{
	PlayerTextDrawHide(playerid, _vhudFlash[playerid]);
	return 1;
}

forward ClearDrugs(playerid);
public ClearDrugs(playerid)
{
	UsedWeed[playerid] = 0;
	UsedCrack[playerid] = 0;
	return 1;
}

forward PrepareLotto();
public PrepareLotto()
{
 	SetTimerEx("StartLotto", 60000, 0, "d", 1);
	return 1;
}

forward StartLotto(stage);
public StartLotto(stage)
{
	new minutes, string[128];
	if(stage <= 3 && stage != 0)
	{
	    if(stage == 1) minutes = 6;
	    else if(stage == 2) minutes = 4;
	    else if(stage == 3) minutes = 2;
		format(string, sizeof(string), "[VE SO]: Con %d phut nua ket qua xo so se co, hay nhanh chong mua ve so tai cua hang nhe.", minutes);
		OOCOff(0x0e491bFF, string);
		if(stage > 0)
		{
			SetTimerEx("StartLotto", 120000, 0, "d", stage+1);
		}
	}
	else if(stage == 4)
	{
	    SetTimerEx("EndLotto", 1000, 0, "d", 3);
	}
	return 1;
}

forward EndLotto(secondt);
public EndLotto(secondt)
{
	new string[128];
	if(secondt != 0)
	{
		format(string, sizeof(string), "Con lai %d giay nua ket qua xo so se cong bo", secondt);
		OOCOff(COLOR_WHITE, string);
		SetTimerEx("EndLotto", 1000, 0, "d", secondt-1);
	}
	else
	{
	    format(string, sizeof(string), "Tin Tuc Xo So: Xo so vi nguoi ngheo da duoc bat dau.");
		OOCOff(COLOR_WHITE, string);
		new rand = Random(1, 300);
		Lotto(rand);
	}
	return 1;
}

forward Firework(playerid, type);
public Firework(playerid, type)
{
	if(!IsPlayerConnected(playerid))
	{
	    DestroyDynamicObject(Rocket[playerid]);
	    DestroyDynamicObject(RocketLight[playerid]);
	    DestroyDynamicObject(RocketSmoke[playerid]);
	    return 1;
	}
    new Float:x, Float:y, Float:z;
    x = GetPVarFloat(playerid, "fxpos");
    y = GetPVarFloat(playerid, "fypos");
    z = GetPVarFloat(playerid, "fzpos");
    if (type == TYPE_COUNTDOWN)
    {
        new string[128];
		format(string, sizeof(string), "Phao hoa se no trong 5giay nua!", GetPlayerNameEx(playerid));
	    ProxDetector(30.0, playerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
	    SetTimerEx("Firework", 5000, 0, "ii", playerid, TYPE_LAUNCH);
    }
	else if(type == TYPE_LAUNCH)
	{
	    CreateExplosion(x ,y, z, 12, 5);
		new time = MoveDynamicObject(Rocket[playerid], x, y, z + RocketHeight, 10);
		MoveDynamicObject(RocketLight[playerid], x, y, z + 2 + RocketHeight, 10);
		MoveDynamicObject(RocketSmoke[playerid], x, y, z + RocketHeight, 10);
		SetTimerEx("Firework", time, 0, "ii", playerid, TYPE_EXPLODE);
	}
	else if(type == TYPE_EXPLODE)
	{
	    z += RocketHeight;
	    if (RocketExplosions[playerid] == 0)
		{
		    DestroyDynamicObject(Rocket[playerid]);
		    DestroyDynamicObject(RocketLight[playerid]);
		    DestroyDynamicObject(RocketSmoke[playerid]);
		    CreateExplosion(x ,y, z, 4, 10);
		    CreateExplosion(x ,y, z, 5, 10);
		    CreateExplosion(x ,y, z, 6, 10);
		}
		else if (RocketExplosions[playerid] >= MAX_FIREWORKS)
		{
		    for (new i = 0; i <= FireworkSpread; i++)
		    {
		    	CreateExplosion(x + float(i - (FireworkSpread / 2)), y, z, 7, 10);
		    	CreateExplosion(x, y + float(i - (FireworkSpread / 2)), z, 7, 10);
		    	CreateExplosion(x, y, z + float(i - (FireworkSpread / 2)), 7, 10);
		    }
		    RocketExplosions[playerid] = -1;
		    return 1;
		}
		else
		{
			x += float(random(FireworkSpread) - (FireworkSpread / 2));
			y += float(random(FireworkSpread) - (FireworkSpread / 2));
			z += float(random(FireworkSpread) - (FireworkSpread / 2));
		    CreateExplosion(x, y, z, 7, 10);
		}
		RocketExplosions[playerid]++;
  		SetTimerEx("Firework", 250, 0, "ii", playerid, TYPE_EXPLODE);
	}
	return 1;
}

forward KickEx(playerid);
public KickEx(playerid)
{
	Kick(playerid);
}

forward SetVehicleEngine(vehicleid, playerid);
public SetVehicleEngine(vehicleid, playerid)
{
	new string[128];
	new engine,lights,alarm,doors,bonnet,boot,objective;
    GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
    if(engine == VEHICLE_PARAMS_ON)
	{
		SetVehicleParamsEx(vehicleid,VEHICLE_PARAMS_OFF,lights,alarm,doors,bonnet,boot,objective);
		ShowNotifyTextMain(playerid,"Phuong tien da tat dong co ~g~thanh cong~w~, neu muon mo bam ~r~'N'~w~",6);
		format(string, sizeof(string), "{FF8000}**{C2A2DA} %s da tat dong co phuong tien.", GetPlayerNameEx(playerid));
        ProxDetector(15.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		arr_Engine{vehicleid} = 0;
	}
    else if(engine == VEHICLE_PARAMS_OFF || engine == VEHICLE_PARAMS_UNSET)
	{
		new
			Float: f_vHealth;

  		GetVehicleHealth(vehicleid, f_vHealth);
		if (GetPVarInt(playerid, "Refueling")) return ShowNotifyTextMain(playerid,"Phuong tien dang bi ~r~hu hong~w~ rat nang khong the khoi dong",6); 
		if(f_vHealth < 350.0) return  ShowNotifyTextMain(playerid,"Khoi dong phuong tien ~r~that bai~w~, phuong tien da het xang",6); 
	   if(IsRefuelableVehicle(vehicleid) && !IsVIPcar(vehicleid) && !IsAdminSpawnedVehicle(vehicleid) && VehicleFuel[vehicleid] <= 0.0) return ShowNotifyTextMain(playerid, "Phuong tien khong the khoi dong - Khong con nhien lieu trong xe!",6);
		SetVehicleParamsEx(vehicleid,VEHICLE_PARAMS_ON,lights,alarm,doors,bonnet,boot,objective);
		if(DynVeh[vehicleid] != -1 && DynVehicleInfo[DynVeh[vehicleid]][gv_iType] == 1 && IsAPlane(vehicleid)) { ShowNotifyTextMain(playerid, "Dong co xe khoi dong thanh cong (/announcetakeoff de tat may).",6); }
		else ShowNotifyTextMain(playerid,"Phuong tien da khoi dong ~g~thanh cong~w~ su dung ~r~N~w~ neu muon tat",6); 
		arr_Engine{vehicleid} = 1;
		if(GetChased[playerid] != INVALID_PLAYER_ID && VehicleBomb{vehicleid} == 1)
		{
			if(PlayerInfo[playerid][pHeadValue] >= 1)
			{
				if (IsAHitman(playerid))
				{
					new Float:boomx, Float:boomy, Float:boomz;
					GetPlayerPos(playerid,boomx, boomy, boomz);
					CreateExplosion(boomx, boomy , boomz, 7, 1);
					VehicleBomb{vehicleid} = 0;
					PlacedVehicleBomb[GetChased[playerid]] = INVALID_VEHICLE_ID;
					new takemoney = (PlayerInfo[playerid][pHeadValue] / 4) * 2;
					GivePlayerMoneyEx(GetChased[playerid], takemoney);
					GivePlayerMoneyEx(playerid, -takemoney);
					format(string,sizeof(string),"Hitman %s da hoan thanh hop dong tren %s va kiem duoc $%d.",GetPlayerNameEx(GetChased[playerid]),GetPlayerNameEx(playerid),takemoney);
					SendGroupMessage(2, COLOR_YELLOW, string);
					format(string,sizeof(string),"Ban da bi thuong nang boi mot sat thu va mat $%d!",takemoney);
					ResetPlayerWeaponsEx(playerid);
					SendClientMessageEx(playerid, COLOR_YELLOW, string);
					PlayerInfo[playerid][pHeadValue] = 0;
					PlayerInfo[GetChased[playerid]][pCHits] += 1;
					SetPlayerHealth(playerid, 0.0);
					GoChase[GetChased[playerid]] = INVALID_PLAYER_ID;
					PlayerInfo[GetChased[playerid]][pC4Used] = 0;
					PlayerInfo[GetChased[playerid]][pC4] = 0;
					GotHit[playerid] = 0;
					GetChased[playerid] = INVALID_PLAYER_ID;
					return 1;
				}
			}
		}
	}
	return 1;
}

forward SurfingFix(playerid, Float:x, Float:y, Float:z);
public SurfingFix(playerid, Float:x, Float:y, Float:z)
{
	SetPlayerPos(playerid, x, y, z);
	return 1;
}

forward TazerTimer(playerid);
public TazerTimer(playerid)
{
	if (TazerTimeout[playerid] > 0)
   	{
		new string[128];
   		format(string,sizeof(string),"~n~~n~~n~~n~~n~~n~~n~~n~~r~Dang nap dien... ~w~%d", TazerTimeout[playerid]);
		GameTextForPlayer(playerid, string,1500, 3);
		TazerTimeout[playerid] -= 1;
		SetTimerEx("TazerTimer",1000,false,"d",playerid);
   	}
	return 1;
}

forward IslandThreatElim();
public IslandThreatElim()
{
	MoveDynamicObject(IslandGate, -1083.90002441,4289.70019531,14.10000038, 2);
    IslandGateStatus = 0;
    foreach(new i: Player)
    {
        if(IsPlayerInRangeOfPoint(i, 500, -1083.90002441,4289.70019531,7.59999990))
        {
            SendClientMessageEx(i, COLOR_YELLOW, "** MEGAPHONE ** INTRUDER THREAT ELIMINATED!! ");
			StopAudioStreamForPlayer(i);
		}
    }
	return 1;
}

forward firstaid5(playerid);
public firstaid5(playerid)
{
	if(GetPVarInt(playerid, "usingfirstaid") == 1)
	{
		new Float:health;
		GetPlayerHealth(playerid, health);
		if(health < 100.0)
		{
			if((health+5.0) <= 100.0)
			{
 				SetPlayerHealth(playerid, health+5.0);
			}
		}
	}
}
forward firstaidexpire(playerid);
public firstaidexpire(playerid)
{
	SendClientMessageEx(playerid, COLOR_GRAD1, "Bo dung cu so cuu cua ban khong con co tac dung.");
	KillTimer(GetPVarInt(playerid, "firstaid5"));
	SetPVarInt(playerid, "usingfirstaid", 0);
	foreach(new i: Player)
	{
		if(PlayerInfo[i][pAdmin] >= 2 && GetPVarType(i, "_dCheck") && GetPVarInt(i, "_dCheck") == playerid)
		{
			SendClientMessageEx(i, COLOR_ORANGE, "Note{ffffff}: First Aid effect has expired on the person you are damage checking.");
		}
	}
}
forward rccam(playerid);
public rccam(playerid)
{
	DestroyVehicle(GetPVarInt(playerid, "rcveh"));
 	SetPlayerPos(playerid, GetPVarFloat(playerid, "rcX"), GetPVarFloat(playerid, "rcY"), GetPVarFloat(playerid, "rcZ"));
  	SendClientMessageEx(playerid, COLOR_GRAD1, "RC Cam cua ban da het pin!");
   	SetPVarInt(playerid, "rccam", 0);
}
forward cameraexpire(playerid);
public cameraexpire(playerid)
{
	SetPVarInt(playerid, "cameraactive", 0);
 	SetCameraBehindPlayer(playerid);
 	if(GetPVarInt(playerid, "camerasc") == 1)
 	{
	 	SetPlayerPos(playerid, GetPVarFloat(playerid, "cameraX2"), GetPVarFloat(playerid, "cameraY2"), GetPVarFloat(playerid, "cameraZ2"));
	  	SetPlayerVirtualWorld(playerid, GetPVarInt(playerid, "cameravw2"));
	  	SetPlayerInterior(playerid, GetPVarInt(playerid, "cameraint2"));
	}
 	TogglePlayerControllable(playerid,1);
  	DestroyDynamic3DTextLabel(Camera3D[playerid]);
   	SendClientMessageEx(playerid, COLOR_GRAD1, "May anh cua ban da het pin!");
}

forward split(const strsrc[], strdest[][], delimiter);
public split(const strsrc[], strdest[][], delimiter)
{
	new i, li;
	new aNum;
	new len;
	while(i <= strlen(strsrc)){
	    if(strsrc[i]==delimiter || i==strlen(strsrc)){
	        len = strmid(strdest[aNum], strsrc, li, i, 128);
	        strdest[aNum][len] = 0;
	        li = i+1;
	        aNum++;
		}
		i++;
	}
	return 1;
}

forward KickNonRP(playerid);
public KickNonRP(playerid)
{
	new name[MAX_PLAYER_NAME];
	GetPVarString(playerid, "KickNonRP", name, sizeof(name));
	if(strcmp(GetPlayerNameEx(playerid), name) == 0)
	{
	    SendClientMessage(playerid, COLOR_WHITE, "Ban da bi kick ra khoi he thong vi ten khong dung voi quy dinh (VD: Trong_Dat).");
		SetTimerEx("KickEx", 1000, 0, "i", playerid);
	}
}

forward RotateWheel();
public RotateWheel()
{
    UpdateWheelTarget();

    new Float:fModifyWheelZPos = 0.0;
    if(gWheelTransAlternate) fModifyWheelZPos = 0.05;

    MoveObject( gFerrisWheel, gFerrisOrigin[0], gFerrisOrigin[1], gFerrisOrigin[2]+fModifyWheelZPos,
				0.01, 0.0, gCurrentTargetYAngle, -270.0 );
}

forward SetPlayerFree(playerid,declare,reason[]);
public SetPlayerFree(playerid,declare,reason[])
{
	if(IsPlayerConnected(playerid))
	{
		ClearCrimes(playerid);
		new string[128];
		foreach(new i: Player)
		{
			if(IsACop(i))
			{
				format(string, sizeof(string), "HQ: Tat ca don vi, nhan vien %s da hoan thanh nhiem vu cua minh.", GetPlayerNameEx(declare));
				SendClientMessageEx(i, COLOR_DBLUE, string);
				format(string, sizeof(string), "HQ: %s da duoc xu ly, %s.", GetPlayerNameEx(playerid), reason);
				SendClientMessageEx(i, COLOR_DBLUE, string);
			}
		}
	}
}

forward RingToner();
public RingToner()
{
	foreach(new i: Player)
	{
		if(RingTone[i] != 6 && RingTone[i] != 0 && RingTone[i] < 11)
		{
			RingTone[i] = RingTone[i] -1;
			PlayerPlaySound(i, 1138, 0.0, 0.0, 0.0);
		}
		if(RingTone[i] == 6)
		{
			RingTone[i] = RingTone[i] -1;
		}
		if(RingTone[i] == 20)
		{
			RingTone[i] = RingTone[i] -1;
			PlayerPlaySound(i, 1139, 0.0, 0.0, 0.0);
		}
	}
	SetTimer("RingTonerRev", 1000, 0);
	return 1;
}

forward RingTonerRev();
public RingTonerRev()
{
	foreach(new i: Player)
	{
		if(RingTone[i] != 5 && RingTone[i] != 0 && RingTone[i] < 10)
		{
			RingTone[i] = RingTone[i] -1;
			PlayerPlaySound(i, 1137, 0.0, 0.0, 0.0);
		}
		if(RingTone[i] == 5)
		{
			RingTone[i] = RingTone[i] -1;
		}
		if(RingTone[i] == 19)
		{
			PlayerPlaySound(i, 1139, 0.0, 0.0, 0.0);
			RingTone[i] = 0;
		}
	}
	SetTimer("RingToner", 1000, 0);
	return 1;
}

forward OtherTimerEx(playerid, type);
public OtherTimerEx(playerid, type)
{
	switch(type) {

		
		case TYPE_TPMATRUNTIMER:
		{
			if(GetPVarInt(playerid, "tpMatRunTimer") > 0)
			{
				SetPVarInt(playerid, "tpMatRunTimer", GetPVarInt(playerid, "tpMatRunTimer")-1);
				SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_TPMATRUNTIMER);
			}
		}
		case TYPE_THOIGIANCHET:
		{
			if(GetPVarInt(playerid, "ThoiGianChet") > 0)
			{
				SetPVarInt(playerid, "ThoiGianChet", GetPVarInt(playerid, "ThoiGianChet")-1);
				SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_THOIGIANCHET);
			}
		}
		case TYPE_TPDRUGRUNTIMER:
		{
			if(GetPVarInt(playerid, "tpDrugRunTimer") > 0)
			{
				SetPVarInt(playerid, "tpDrugRunTimer", GetPVarInt(playerid, "tpDrugRunTimer")-1);
				SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_TPDRUGRUNTIMER);
			}
		}
		case TYPE_TPTRUCKRUNTIMER:
		{
			if(GetPVarInt(playerid, "tpTruckRunTimer") > 0)
			{
				SetPVarInt(playerid, "tpTruckRunTimer", GetPVarInt(playerid, "tpTruckRunTimer")-1);
				SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_TPTRUCKRUNTIMER);
			}
		}
		case TYPE_ARMSTIMER:
		{
			if(GetPVarInt(playerid, "ArmsTimer") > 0)
			{
				SetPVarInt(playerid, "ArmsTimer", GetPVarInt(playerid, "ArmsTimer")-1);
				SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_ARMSTIMER);
			}
		}
		case TYPE_GUARDTIMER:
		{
			if(GetPVarInt(playerid, "GuardTimer") > 0)
			{
				SetPVarInt(playerid, "GuardTimer", GetPVarInt(playerid, "GuardTimer")-1);
				SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GUARDTIMER);
			}
		}
		case TYPE_GIVEWEAPONTIMER:
		{
			if(GetPVarInt(playerid, "GiveWeaponTimer") > 0)
			{
				SetPVarInt(playerid, "GiveWeaponTimer", GetPVarInt(playerid, "GiveWeaponTimer")-1);
				SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
			}
		}
		case TYPE_SHOPORDERTIMER:
		{
			if(GetPVarInt(playerid, "ShopOrderTimer") > 0)
			{
				SetPVarInt(playerid, "ShopOrderTimer", GetPVarInt(playerid, "ShopOrderTimer")-1);
				SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_SHOPORDERTIMER);
			}
		}
		case TYPE_SELLMATSTIMER:
		{
			if(GetPVarInt(playerid, "SellMatsTimer") > 0)
			{
				SetPVarInt(playerid, "SellMatsTimer", GetPVarInt(playerid, "SellMatsTimer")-1);
				SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_SELLMATSTIMER);
			}
		}
		case TYPE_HOSPITALTIMER:
		{
			if(GetPVarInt(playerid, "HospitalTimer") > 0)
			{
				new Float:curhealth;
				GetPlayerHealth(playerid, curhealth);
				SetPVarInt(playerid, "HospitalTimer", GetPVarInt(playerid, "HospitalTimer")-1);
				SetPlayerHealth(playerid, curhealth+1);
				SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_HOSPITALTIMER);
				if(GetPVarInt(playerid, "HospitalTimer") == 0)
				{
					HospitalSpawn(playerid);
				}
			}
		}
		case TYPE_FLOODPROTECTION:
		{
			if( CommandSpamUnmute[playerid] >= 1)
			{
				CommandSpamUnmute[playerid]--;
				SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_FLOODPROTECTION);
			}
			if( TextSpamUnmute[playerid] >= 1)
			{
				TextSpamUnmute[playerid]--;
				SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_FLOODPROTECTION);
			}
		}
		case TYPE_HEALTIMER:
		{
			if( GetPVarInt(playerid, "TriageTimer") >= 1)
			{
				SetPVarInt(playerid, "TriageTimer", GetPVarInt(playerid, "TriageTimer")-1);
				SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_HEALTIMER);
			}
		}
		case TYPE_TPPIZZARUNTIMER:
		{
			if(GetPVarInt(playerid, "tpPizzaTimer") > 0 && GetPVarInt(playerid, "Pizza"))
			{
				SetPVarInt(playerid, "tpPizzaTimer", GetPVarInt(playerid, "tpPizzaTimer")-1);
				SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_TPPIZZARUNTIMER);
			}
		}
		case TYPE_PIZZATIMER:
		{
			if(GetPVarInt(playerid, "pizzaTimer") == 0)
			{
				SendClientMessageEx(playerid, 0xa5bbd0FF, "Do ban giao qua lau, khach hang da huy don hang.");
				DeletePVar(playerid, "Pizza");
				DisablePlayerCheckpoint(playerid);
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
				RemovePlayerAttachedObject(playerid, 0);
			}
			else if (GetPVarInt(playerid, "Pizza") == 0)
			{
				DisablePlayerCheckpoint(playerid);
			}
			else if (GetPVarInt(playerid, "pizzaTimer") > 0 && GetPVarInt(playerid, "Pizza") > 0)
			{
				SetPVarInt(playerid, "pizzaTimer", GetPVarInt(playerid, "pizzaTimer")-1);
				new string[128];
				format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~%d giay con lai", GetPVarInt(playerid, "pizzaTimer"));
				GameTextForPlayer(playerid, string, 1100, 3);
				SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_PIZZATIMER);
			}
		}
		case TYPE_CRATETIMER:
		{
			if(GetPVarInt(playerid, "tpForkliftTimer") > 0)
			{
			    if(IsPlayerInVehicle(playerid, GetPVarInt(playerid, "tpForkliftID")))
			    {
				    new Float: pX = GetPVarFloat(playerid, "tpForkliftX"), Float: pY = GetPVarFloat(playerid, "tpForkliftY"), Float: pZ = GetPVarFloat(playerid, "tpForkliftZ");
				    if(GetPlayerDistanceFromPoint(playerid, pX, pY, pZ) > 500)
				    {
				        if(GetPVarInt(playerid, "tpJustEntered") == 0)
				        {
				        	new string[128];
							format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s co the dang TP hacking voi thung xe nang.", GetPlayerNameEx(playerid));
							ABroadCast(COLOR_YELLOW, string, 2);
							SetPVarInt(playerid, "tpForkliftTimer", GetPVarInt(playerid, "tpForkliftTimer")+15);
						}
						else
						{
						    DeletePVar(playerid, "tpJustEntered");
						}
				    }
					GetPlayerPos(playerid, pX, pY, pZ);
					SetPVarFloat(playerid, "tpForkliftX", pX);
			 		SetPVarFloat(playerid, "tpForkliftY", pY);
			  		SetPVarFloat(playerid, "tpForkliftZ", pZ);
					SetPVarInt(playerid, "tpForkliftTimer", GetPVarInt(playerid, "tpForkliftTimer")-1);
					SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_CRATETIMER);
					if(GetPVarInt(playerid, "tpForkliftTimer") == 0)
					{
					    DeletePVar(playerid, "tpForkliftTimer");
					    DeletePVar(playerid, "tpForkliftID");
					    DeletePVar(playerid, "tpForkliftX");
					    DeletePVar(playerid, "tpForkliftY");
					    DeletePVar(playerid, "tpForkliftZ");
					}
				}
				else
				{
				    DeletePVar(playerid, "tpForkliftTimer");
				    DeletePVar(playerid, "tpForkliftID");
				    DeletePVar(playerid, "tpForkliftX");
				    DeletePVar(playerid, "tpForkliftY");
				    DeletePVar(playerid, "tpForkliftZ");
				}
			}
		}
	}
}

forward Player_StreamPrep(iPlayer, Float: fPosX, Float: fPosY, Float: fPosZ, iTime);
public Player_StreamPrep(iPlayer, Float: fPosX, Float: fPosY, Float: fPosZ, iTime) {
    if(sobeitCheckvar[iPlayer] == 0)
	{
		if(sobeitCheckIsDone[iPlayer] == 0)
		{
   			if(PlayerInfo[iPlayer][pAdmin] < 2)
   			{
   		
		    	sobeitCheckIsDone[iPlayer] = 1;
		    	//   				SetTimerEx("sobeitCheck", 10000, 0, "i", iPlayer);
			//	TogglePlayerControllable(iPlayer, false);
				return 1;
			}
		}
	}
	switch(GetPVarInt(iPlayer, "StreamPrep")) {
		case 0: {

		
			TogglePlayerControllable(iPlayer, false);
			SetPVarInt(iPlayer, "StreamPrep", 1);
			SetTimerEx("Player_StreamPrep", iTime / 2, false, "ifffi", iPlayer, fPosX, fPosY, fPosZ, iTime);
		}
		case 1: {

			if(GetPlayerState(iPlayer) == PLAYER_STATE_DRIVER)
				SetVehiclePos(GetPlayerVehicleID(iPlayer), fPosX, fPosY, fPosZ + 2.0);

			else
				SetPlayerPos(iPlayer, fPosX, fPosY, fPosZ + 0.5);

			SetPVarInt(iPlayer, "StreamPrep", 2);
			SetTimerEx("Player_StreamPrep", iTime / 2, false, "ifffi", iPlayer, fPosX, fPosY, fPosZ, iTime);
		}
		default: {
			//GameTextForPlayer(iPlayer, "~r~Loaded!", 1000, 3);
			
			TogglePlayerControllable(iPlayer, true);

			if(GetPlayerState(iPlayer) == PLAYER_STATE_DRIVER)
				SetVehiclePos(GetPlayerVehicleID(iPlayer), fPosX, fPosY, fPosZ);

			else
				SetPlayerPos(iPlayer, fPosX, fPosY, fPosZ);

			if(GetPVarType(iPlayer, "MedicCall")) {
				ClearAnimations(iPlayer);
				ApplyAnimation(iPlayer, "KNIFE", "KILL_Knife_Ped_Die", 4.0, 0, 1, 1, 1, 0, 1);
			}
			DeletePVar(iPlayer, "StreamPrep");
		}
	}
	SetCameraBehindPlayer(iPlayer);
	Streamer_UpdateEx(iPlayer, fPosX, fPosY, fPosZ);
	return 1;
}

#if defined zombiemode
forward SyncPlayerTime(playerid);
public SyncPlayerTime(playerid)
{
	if(zombieevent == 0) SetPlayerTime(playerid, hour, minuite);
	else SetPlayerTime(playerid, 0, 0);
	return 1;
}

forward SyncMinTime();
public SyncMinTime()
{
	foreach(Player, i)
	{
 		if(GetPlayerVirtualWorld(i) == 133769)
		{
  			SetPlayerWeather(i, 45);
			SetPlayerTime(i, 0, 0);
		}
		else
		{
  			if(zombieevent == 0) SetPlayerTime(i, hour, minuite);
	    	else SetPlayerTime(i, 0, 0);
		}
	}
	return 1;
}
#else
forward SyncPlayerTime(playerid);
public SyncPlayerTime(playerid)
{
	SetPlayerTime(playerid, hour, minuite);
	return 1;
}

forward SyncMinTime();
public SyncMinTime()
{
	foreach(new i: Player)
	{
		if(GetPlayerVirtualWorld(i) == 133769)
		{
			SetPlayerWeather(i, 45);
			SetPlayerTime(i, 0, 0);
		}
		else
		{
			SetPlayerTime(i, hour, minuite);
		}
	}
	return 1;
}
#endif

forward Lotto(number);
public Lotto(number)
{
	new JackpotFallen = 0, TotalWinners = 0, string[128];

	format(string, sizeof(string), "Tin Tuc Xo So: Xo so trung thuong cua ngay hom nay la... %d!.", number);
	OOCOff(COLOR_WHITE, string);

	foreach(new i: Player)
	{
		if(PlayerInfo[i][pLottoNr] > 0)
		{
  			for(new t = 0; t < 5; t++)
  			{
    			if(LottoNumbers[i][t] == number)
				{
				    TotalWinners++;
				    SetPVarInt(i, "Winner", 1);
       				break;
				}
				else
				{
				    LottoNumbers[i][t] = 0;
				    if(t == 4) {
				        SendClientMessageEx(i, COLOR_GREY, "Xin loi, ve so cua ban chon mua khong may man de trung thuong.");
				    }
				}
			}
			DeleteTickets(i);
			PlayerInfo[i][pLottoNr] = 0;
		}
		else {
		    SendClientMessageEx(i, COLOR_GREY, "Ban khong tham gia chuong trinh xo so nao.");
		}
	}
	if(TotalWinners == 1)
	{
		foreach(new i: Player)
		{
		    if(GetPVarType(i, "Winner"))
		    {
		        for(new t = 0; t < 5; t++) {
  					LottoNumbers[i][t] = 0;
    			}
    			if(SpecLotto) {
    			    AddFlag(i, INVALID_PLAYER_ID, LottoPrize);
    			}
		        JackpotFallen = 1;
				format(string, sizeof(string), "Tin Tuc Xo So: %s da trung so doc dac $%s khi mua ve so tai cua hang 24/7.", GetPlayerNameEx(i), number_format(Jackpot));
				OOCOff(COLOR_WHITE, string);
				format(string, sizeof(string), "* Ban da chien thang $%s voi ve so cua ban - chuc mung ban!", number_format(Jackpot));
				SendClientMessageEx(i, COLOR_YELLOW, string);
				GivePlayerMoneyEx(i, Jackpot);
				DeletePVar(i, "Winner");
		    }
		}
	}
	else if(TotalWinners > 1)
	{
	    foreach(new i: Player)
	    {
	        if(GetPVarType(i, "Winner"))
	        {
	            for(new t = 0; t < 5; t++) {
  					LottoNumbers[i][t] = 0;
    			}
    			if(SpecLotto) {
    			    AddFlag(i, INVALID_PLAYER_ID, LottoPrize);
    			}
                JackpotFallen = 1;
				format(string, sizeof(string), "Tin Tuc Xo So: %s da trung so doc dac $%s khi mua ve so tai cua hang 24/7.", GetPlayerNameEx(i), number_format(Jackpot/TotalWinners));
				OOCOff(COLOR_WHITE, string);
				format(string, sizeof(string), "* Ban da chien thang $%s voi ve so cua ban - chuc mung ban!", number_format(Jackpot/TotalWinners));
				SendClientMessageEx(i, COLOR_YELLOW, string);
				GivePlayerMoneyEx(i, Jackpot/TotalWinners);
				DeletePVar(i, "Winner");
	        }
	    }
	}
	TicketsSold = 0;
	SpecLotto = 0;
	if(!JackpotFallen)
	{
		Misc_Save();
		format(string, sizeof(string), "Tin Tuc Xo So: So tien thuong da duoc tang len $%s.", number_format(Jackpot));
		OOCOff(COLOR_WHITE, string);
	}
	else
	{
	    Jackpot = 10;
	    format(string, sizeof(string), "Tin Tuc Xo So: Vong moi da duoc bat dau voi $%s.", number_format(Jackpot));
		OOCOff(COLOR_WHITE, string);
	}
	return 1;
}

forward Disconnect(playerid);
public Disconnect(playerid)
{
	new string[24];
    GetPlayerIp(playerid, unbanip[playerid], 16);
    format(string, sizeof(string),"banip %s", unbanip[playerid]);
	SendRconCommand(string);
	Kick(playerid);
	return 1;
}

forward GetColorCode(clr[]);
public GetColorCode(clr[])
{
	new color = -1;

	if (IsNumeric(clr)) {
		color = strval(clr);
		return color;
	}

	if(strcmp(clr, "black", true)==0) color=0;
	if(strcmp(clr, "white", true)==0) color=1;
	if(strcmp(clr, "blue", true)==0) color=2;
	if(strcmp(clr, "red", true)==0) color=3;
	if(strcmp(clr, "green", true)==0) color=16;
	if(strcmp(clr, "purple", true)==0) color=5;
	if(strcmp(clr, "yellow", true)==0) color=6;
	if(strcmp(clr, "lightblue", true)==0) color=7;
	if(strcmp(clr, "navy", true)==0) color=94;
	if(strcmp(clr, "beige", true)==0) color=102;
	if(strcmp(clr, "darkgreen", true)==0) color=51;
	if(strcmp(clr, "darkblue", true)==0) color=103;
	if(strcmp(clr, "darkgrey", true)==0) color=13;
	if(strcmp(clr, "gold", true)==0) color=99;
	if(strcmp(clr, "brown", true)==0 || strcmp(clr, "dennell", true)==0) color=55;
	if(strcmp(clr, "darkbrown", true)==0) color=84;
	if(strcmp(clr, "darkred", true)==0) color=74;
	if(strcmp(clr, "maroon", true)==0) color=115;
	if(strcmp(clr, "pink", true)==0) color=126;
	return color;
}

forward DeliverCrate(playerid);
public DeliverCrate(playerid)
{
    new vehicleid = GetPlayerVehicleID(playerid);
    SetPVarInt(playerid, "DeliverCrateTime", GetPVarInt(playerid, "DeliverCrateTime")-1);
	new string[128];
	format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~%d giay con lai", GetPVarInt(playerid, "DeliverCrateTime"));
	GameTextForPlayer(playerid, string, 1100, 3);
	new CrateFound = GetPVarInt(playerid, "dc_CrateFound");

	if(GetPVarInt(playerid, "SecuricarID") != vehicleid) {
		SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong con dieu khien xe - giao hang  bi huy bo.");
		TogglePlayerControllable(playerid, 1);
	    DeletePVar(playerid, "dc_CrateFound");
        DeletePVar(playerid, "delivercratecrateid");
        DeletePVar(playerid, "DeliverCrateTime");
        DeletePVar(playerid, "SecuricarID");
        DeletePVar(playerid, "dc_GroupID");
        DeletePVar(playerid, "dc_i");
		return 1;
	}

	if(!CrateFound)
	{
	    return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong co thung chua.");
	}

	if(GetPVarInt(playerid, "DeliverCrateTime") > 0) SetTimerEx("DeliverCrate", 1000, 0, "d", playerid);


	if(GetPVarInt(playerid, "DeliverCrateTime") <= 0)
	{
	    if(GetPVarInt(playerid, "Speedo"))
	    {
	        PlayerInfo[playerid][pSpeedo] = 1;
	        DeletePVar(playerid, "Speedo");
	    }
	    new CrateID = GetPVarInt(playerid, "delivercratecrateid"), group = GetPVarInt(playerid, "dc_GroupID"), i = GetPVarInt(playerid, "dc_i");
        if( arrGroupData[group][g_iLockerStock] + floatround(CrateInfo[CrateID][GunQuantity] * 2) < MAX_LOCKER_STOCK)
        {
            if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 530 && CrateVehicleLoad[GetPlayerVehicleID(playerid)][vForkLoaded] == 1)
            {
			    DestroyDynamicObject(CrateVehicleLoad[vehicleid][vForkObject]);
			    CrateVehicleLoad[vehicleid][vForkObject] = INVALID_OBJECT_ID;
			    CrateVehicleLoad[vehicleid][vForkLoaded] = 0;
			    CrateVehicleLoad[vehicleid][vCrateID][0] = -1;
			}
            new Float: quantcalc = floatdiv(CrateInfo[CrateID][GunQuantity], 50);
            new Float: costcalc = (CRATE_COST * 1.2);
            new discount = floatround(floatmul(quantcalc, costcalc));
			arrGroupData[group][g_iLockerStock] += floatround(CrateInfo[CrateID][GunQuantity] * 2);
			arrGroupData[group][g_iBudget] -= discount;
			arrGroupData[group][g_iCratesOrder]--;
			Tax += floatround(CRATE_COST * 1.2);
			CrateInfo[CrateID][GunQuantity] = 0;
			CrateInfo[CrateID][crActive] = 0;
			CrateVehicleLoad[vehicleid][vCrateID][i] = -1;
            mysql_SaveCrates();
            SaveGroup(group);
            new str[128], file[32];
            format(str, sizeof(str), "%s da chuyen mot thung vi khi voi gia $%d cho %s's von ngan sach",GetPlayerNameEx(playerid), discount, arrGroupData[group][g_szGroupName]);
			new month, day, year;
			getdate(year,month,day);
			format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", group, month, day, year);
			Log(file, str);
		}
		else
		{
		    if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 530 && CrateVehicleLoad[GetPlayerVehicleID(playerid)][vForkLoaded] == 1)
            {
			    DestroyDynamicObject(CrateVehicleLoad[vehicleid][vForkObject]);
			    CrateVehicleLoad[vehicleid][vForkObject] = INVALID_OBJECT_ID;
			    CrateVehicleLoad[vehicleid][vForkLoaded] = 0;
			    CrateVehicleLoad[vehicleid][vCrateID][0] = -1;
			}
		    new Float: quantcalc = floatdiv((MAX_LOCKER_STOCK - arrGroupData[group][g_iLockerStock]), 100);
            new Float: costcalc = (CRATE_COST * 1.2);
            new discount = floatround(floatmul(quantcalc, costcalc));
		    arrGroupData[group][g_iLockerStock] = MAX_LOCKER_STOCK;
		    arrGroupData[group][g_iBudget] -= discount;
		    arrGroupData[group][g_iCratesOrder]--;
			Tax += discount;
			CrateInfo[CrateID][GunQuantity] = 0;
			CrateInfo[CrateID][crActive] = 0;
			CrateVehicleLoad[vehicleid][vCrateID][i] = -1;
			mysql_SaveCrates();
			SaveGroup(group);
			new str[128], file[32];
            format(str, sizeof(str), "%s da chuyen mot thung vi khi voi gia $%d cho %s's von ngan sach.",GetPlayerNameEx(playerid), floatround(CRATE_COST * 0.8), arrGroupData[group][g_szGroupName]);
            new month, day, year;
			getdate(year,month,day);
			format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", group, month, day, year);
			Log(file, str);
		}
	    DeletePVar(playerid, "dc_CrateFound");
        DeletePVar(playerid, "delivercratecrateid");
        DeletePVar(playerid, "DeliverCrateTime");
        DeletePVar(playerid, "SecuricarID");
        DeletePVar(playerid, "dc_GroupID");
        DeletePVar(playerid, "dc_i");
        TogglePlayerControllable(playerid, 1);
	    if(CrateFound)
	    {
	        SendClientMessageEx(playerid, COLOR_GRAD2, "Ban da phan phoi cac vat lieu cao cap den cac tu do.");
		}

	}
	return 1;
}

forward LoadForklift(playerid);
public LoadForklift(playerid)
{
    new vehicleid = GetPlayerVehicleID(playerid);
    SetPVarInt(playerid, "LoadForkliftTime", GetPVarInt(playerid, "LoadForkliftTime")-1);
	new string[128];
	format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~%d giay con lai", GetPVarInt(playerid, "LoadForkliftTime"));
	GameTextForPlayer(playerid, string, 1100, 3);

	if(GetPVarInt(playerid, "ForkliftID") != vehicleid) {
		SendClientMessageEx(playerid, COLOR_GRAD2, "Ban da ra khoi xe - huy tai hang.");
		TogglePlayerControllable(playerid, 1);
		DeletePVar(playerid, "LoadForkliftTime");
		DeletePVar(playerid, "ForkliftID");
		LoadForkliftStatus = 0;
		return 1;
	}

	if(GetPVarInt(playerid, "LoadForkliftTime") > 0) SetTimerEx("LoadForklift", 1000, 0, "d", playerid);


	if(GetPVarInt(playerid, "LoadForkliftTime") <= 0)
	{
	    if(GetPVarInt(playerid, "Speedo"))
	    {
	        PlayerInfo[playerid][pSpeedo] = 1;
	        DeletePVar(playerid, "Speedo");
	    }
	    LoadForkliftStatus = 0;
		DeletePVar(playerid, "LoadForkliftTime");
		DeletePVar(playerid, "ForkliftID");
		TogglePlayerControllable(playerid, 1);
		CrateVehicleLoad[vehicleid][vForkLoaded] = 1;
		CrateVehicleLoad[vehicleid][vForkObject] = CreateDynamicObject(964,-1077.59997559,4274.39990234,3.40000010,0.00000000,0.00000000,0.00000000);
		AttachDynamicObjectToVehicle(CrateVehicleLoad[vehicleid][vForkObject], vehicleid, 0, 0.9, -0.2, 0, 0, 0);
		Streamer_Update(playerid);
		SendClientMessageEx(playerid, COLOR_GRAD2, " Ban da nap thanh cong cac thung hang!");
		new Float: pX, Float: pY, Float: pZ;
		GetPlayerPos(playerid, pX, pY, pZ);
		SetPVarFloat(playerid, "tpForkliftX", pX);
 		SetPVarFloat(playerid, "tpForkliftY", pY);
  		SetPVarFloat(playerid, "tpForkliftZ", pZ);
		SetPVarInt(playerid, "tpForkliftTimer", 80);
		SetPVarInt(playerid, "tpForkliftID", GetPlayerVehicleID(playerid));
		SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_CRATETIMER);
		Tax -= CRATE_COST;
		Misc_Save();
		HideCrate();
		SetTimer("ShowCrate", 30000, 0);
		for(new i = 0; i < sizeof(CrateInfo); i++)
		{
		    if(!CrateInfo[i][crActive])
			{
				CrateInfo[i][InVehicle] = vehicleid;
				CrateInfo[i][GunQuantity] = 50;
				CrateInfo[i][crActive] = 1;
				CrateVehicleLoad[vehicleid][vCrateID][0] = i;
				break;
			}
		}
	}
	return 1;
}

forward HideCrate();
public HideCrate()
{
    Streamer_SetArrayData(STREAMER_TYPE_OBJECT, CrateLoad, E_STREAMER_WORLD_ID, { 1 });
    return 1;
}

forward ShowCrate();
public ShowCrate()
{
    Streamer_SetArrayData(STREAMER_TYPE_OBJECT, CrateLoad, E_STREAMER_WORLD_ID, { 0 });
    return 1;
}

forward Maintenance();
public Maintenance()
{
	new string[128];
    ABroadCast(COLOR_YELLOW, "{AA3333}Bao tri{FFFF00}: Tai khoan bi dong bang...", 1);

    foreach(new i: Player)
	{
        TogglePlayerControllable(i, false);
    }

    ABroadCast(COLOR_YELLOW, "{AA3333}Bao tri{FFFF00}: Khoa Paintball...", 1);

    for(new i = 0; i < MAX_ARENAS; i++)
    {
		foreach(new p: Player)
		{
		    new arenaid = GetPVarInt(p, "IsInArena");
		    if(arenaid == i)
		    {
		        if(PaintBallArena[arenaid][pbBidMoney] > 0)
		        {
		            GivePlayerMoneyEx(p,PaintBallArena[GetPVarInt(p, "IsInArena")][pbBidMoney]);
					format(string,sizeof(string),"Ban da duoc hoan tra $%d vi arena dong cua som.",PaintBallArena[GetPVarInt(p, "IsInArena")][pbBidMoney]);
		            SendClientMessageEx(p, COLOR_WHITE, string);
		        }
		        if(arenaid == GetPVarInt(p, "ArenaNumber"))
	            {
					switch(PaintBallArena[arenaid][pbGameType])
					{
					    case 1:
					    {
					        if(PlayerInfo[p][pDonateRank] < 3)
					        {
					        	PlayerInfo[p][pPaintTokens] += 3;
								format(string,sizeof(string),"Ban da duoc hoan tra %d vi arena dong cua  som.",3);
	            				SendClientMessageEx(p, COLOR_WHITE, string);
							}
					    }
					    case 2:
					    {
					        if(PlayerInfo[p][pDonateRank] < 3)
					        {
					        	PlayerInfo[p][pPaintTokens] += 4;
								format(string,sizeof(string),"Ban da duoc hoan tra %d vi arena dong cua  som.",4);
	            				SendClientMessageEx(p, COLOR_WHITE, string);
							}
					    }
					    case 3:
					    {
					        if(PlayerInfo[p][pDonateRank] < 3)
					        {
				        		PlayerInfo[p][pPaintTokens] += 5;
								format(string,sizeof(string),"Ban da duoc hoan tra %d vi arena dong cua  som.",5);
								SendClientMessageEx(p, COLOR_WHITE, string);
							}
					    }
					    case 4:
					    {
					        if(PlayerInfo[p][pDonateRank] < 3)
					        {
					            PlayerInfo[p][pPaintTokens] += 5;
					            format(string,sizeof(string),"Ban da duoc hoan tra %d vi arena dong cua  som.",5);
								SendClientMessageEx(p, COLOR_WHITE, string);
					        }
					    }
					    case 5:
					    {
					        if(PlayerInfo[p][pDonateRank] < 3)
					        {
					            PlayerInfo[p][pPaintTokens] += 6;
					            format(string,sizeof(string),"Ban da duoc hoan tra %d vi arena dong cua  som.",6);
								SendClientMessageEx(p, COLOR_WHITE, string);
					        }
					    }
					}
				}
		        LeavePaintballArena(p, arenaid);
		    }
		}
		ResetPaintballArena(i);
		PaintBallArena[i][pbLocked] = 2;
    }
    foreach(new i: Player)
	{
	    GameTextForPlayer(i, "Scheduled Maintenance..", 5000, 5);
	}


    ABroadCast(COLOR_YELLOW, "{AA3333}Bao tri{FFFF00}: Luu tai khoan thanh cong...", 1);
	SendRconCommand("password lsrpvn");
	SendRconCommand("hostname [Bao tri] Los Santos Roleplay");
	foreach(new i: Player)
	{
		if(gPlayerLogged{i}) {
			SetPVarInt(i, "RestartKick", 1);
			OnPlayerStatsUpdate(i);
			break; // We only need to save one person at a time.
		}
	}
	SetTimer("FinishMaintenance", 5000, false);
	SetTimer("kickbaotri", 5000, false);
	return 1;
}

forward kickbaotri();
public kickbaotri()
{
    foreach(new i: Player)
	{
		Kick(i);
	}
}

forward HelpTimer(playerid);
public HelpTimer(playerid)
{
	if(GetPVarInt(playerid, "HelpTime") > 0)
 	{
  		SetPVarInt(playerid, "HelpTime", GetPVarInt(playerid, "HelpTime")-1);
    	if(GetPVarInt(playerid, "HelpTime") == 0)
     	{
      		SendClientMessageEx(playerid, COLOR_GREY, "Yeu cau tro giup cua ban da het han. Neu day la mot loi Hay bao loi Nhe.");
        	DeletePVar(playerid, "COMMUNITY_ADVISOR_REQUEST");
         	return 1;
        }
		SetTimerEx("HelpTimer", 60000, 0, "d", playerid);
	}
	return 1;
}

forward ReportTimer(reportid);
public ReportTimer(reportid)
{
	if(Reports[reportid][BeingUsed] == 1)
	{
	    if(Reports[reportid][TimeToExpire] >= 0)
	    {
	        Reports[reportid][TimeToExpire]++;
	      /*  if(Reports[reportid][TimeToExpire] == 0)
	        {
	            SendClientMessageEx(Reports[reportid][ReportFrom], COLOR_GRAD2, "Your report has expired. You can attempt to report again if you wish.");
	            SendClientMessageEx(Reports[reportid][ReportFrom], COLOR_GRAD2, "But its recommended you seek additonal help on the forums (www.ng-gaming.net/forums)");
	            Reports[reportid][BeingUsed] = 0;
	            Reports[reportid][ReportFrom] = INVALID_PLAYER_ID;
	            return 1;
	        } */
  			Reports[reportid][ReportExpireTimer] = SetTimerEx("ReportTimer", 60000, 0, "d", reportid);
		}
	}
	return 1;
}

forward CallTimer(callid);
public CallTimer(callid)
{
	if(Calls[callid][BeingUsed] == 1)
	{
	    if(Calls[callid][TimeToExpire] >= 0)
	    {
	        Calls[callid][TimeToExpire]++;
  			Calls[callid][CallExpireTimer] = SetTimerEx("CallTimer", 60000, 0, "d", callid);
		}
	}
	return 1;
}

forward DrinkCooldown(playerid);
public DrinkCooldown(playerid)
{
	SetPVarInt(playerid, "DrinkCooledDown", 1);
	return 1;
}

forward RadarCooldown(playerid);
public RadarCooldown(playerid)
{
   DeletePVar(playerid, "RadarTimeout");
   return 1;
}

forward CopGetUp(playerid);
public CopGetUp(playerid)
{
    SetPVarInt(playerid, "CopTackleCooldown", 30);
    SendClientMessageEx(playerid, COLOR_GRAD2, "Se can 30 giay sau ban moi co the giai quyet mot lan nua.");
	TogglePlayerControllable(playerid, 1);
	PreloadAnimLib(playerid, "SUNBATHE");
	ApplyAnimation(playerid, "SUNBATHE", "Lay_Bac_out", 4.0, 0, 1, 1, 0, 0, 1);
	return 1;
}

stock TacklePlayer(playerid, tacklee)
{
	new string[128], Float: posx, Float: posy, Float: posz, group[GROUP_MAX_NAME_LEN], rank[GROUP_MAX_RANK_LEN], division[GROUP_MAX_DIV_LEN];
	PreloadAnimLib(playerid, "PED");
	format(string, sizeof(string), "** %s troi chat %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(tacklee));
	ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	SetPVarInt(tacklee, "IsTackled", playerid);
	TogglePlayerControllable(tacklee, 0);
	SetPVarInt(tacklee, "TackleCooldown", 20);
	SetPVarInt(playerid, "Tackling", tacklee);
	GetPlayerPos(tacklee, posx, posy,posz);
	SetPlayerFacingAngle(playerid, 180.0);
	SetPlayerFacingAngle(tacklee, 0.0);
	GetXYBehindPlayer(tacklee, posx, posy, 0.8);
	ApplyAnimation(playerid, "PED", "KO_shot_stom", 4.0, 0, 1, 1, 1, 20000, 1);
	ApplyAnimation(tacklee, "DILDO", "Dildo_Hit_3", 4.1, 0, 1, 1, 1, 20000, 1);
	GetPlayerGroupInfo(playerid, group, rank, division);
	GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~w~Bam ~r~'~k~~CONVERSATION_YES~' ~n~~w~de khang cu.", 15000, 3);
	format(string, sizeof(string), "%s %s %s da troi ban.  Ban co muon khang cu lai?", group, rank, GetPlayerNameEx(playerid));
	ShowPlayerDialog(tacklee, DIALOG_TACKLED, DIALOG_STYLE_MSGBOX, "Ban bi troi", string, "Tuan theo", "Chong cu");
	SetPVarInt(playerid, "TackleMode", 0);
	SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Khang cu bi vo hieu hoa. Bay gio ban co the cat vu khi vao tui. (/holster)");
	return 1;
}

forward CaptureTimer(point);
public CaptureTimer(point)
{
	new string[128];
	new fam;
	if (Points[point][ClaimerId] != INVALID_PLAYER_ID && Points[point][TimeToClaim])
	{
		new claimer = Points[point][ClaimerId];
		new Float: x, Float: y, Float: z;
		GetPlayerPos(claimer, x, y, z);
		if (Points[point][Capturex] != x || Points[point][Capturey] != y || Points[point][Capturez] != z || GetPVarInt(Points[point][ClaimerId],"Injured") == 1)
		{
			SendClientMessageEx(Points[point][ClaimerId], COLOR_LIGHTBLUE, "Ban khong chiem duoc. Ban da di chuyen hoac da bi chet khi dang co gang chiem capture.");
			Points[point][ClaimerId] = INVALID_PLAYER_ID;
			Points[point][TimeToClaim] = 0;
		}
		else
		{
			if(Points[point][Vulnerable] > 0)
			{
			    SendClientMessageEx(Points[point][ClaimerId], COLOR_LIGHTBLUE, "Ban khong the chiem, captured nay da bi chiem.");
				Points[point][ClaimerId] = INVALID_PLAYER_ID;
				Points[point][TimeToClaim] = 0;
				return 1;
			}
			if(playerTabbed[claimer] != 0)
			{
			    SendClientMessageEx(Points[point][ClaimerId], COLOR_LIGHTBLUE, "Ban khong chiem duoc, ban da alt-tabbed.");
			    format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s (ID %d) co the dang alt-tabbed khi dang chiem dong.", GetPlayerNameEx(claimer), claimer);
				ABroadCast( COLOR_YELLOW, string, 2 );
   				Points[point][ClaimerId] = INVALID_PLAYER_ID;
				Points[point][TimeToClaim] = 0;
			    return 1;
			}
			new cappervw = GetPlayerVirtualWorld(Points[point][ClaimerId]);
			if(cappervw != Points[point][pointVW])
			{
			    SendClientMessageEx(Points[point][ClaimerId], COLOR_LIGHTBLUE, "Ban khong the chiem, virtual world cua ban da bi sai - hay lien he voi admin de khac phuc.");
			    format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s (ID %d) may have possibly desynced himself to capture a point.", GetPlayerNameEx(claimer), claimer);
				ABroadCast( COLOR_YELLOW, string, 2 );
   				Points[point][ClaimerId] = INVALID_PLAYER_ID;
				Points[point][TimeToClaim] = 0;
			    return 1;
			}
			fam = PlayerInfo[claimer][pFMember];
            Points[point][PlayerNameCapping] = GetPlayerNameEx(claimer);
		   	format(string, sizeof(string), "%s da co gang kiem soat %s cho %s, no se la cua ho sau %d phut.", Points[point][PlayerNameCapping], Points[point][Name], FamilyInfo[fam][FamilyName], TIME_TO_TAKEOVER);
			SendClientMessageToAllEx(COLOR_YELLOW, string);
			if(Points[point][CaptureProccessEx] >= 1)
			{
				UpdateDynamic3DTextLabelText(Points[point][CaptureProccess], COLOR_YELLOW, string);
				Points[point][CaptureProccessEx] = 2;
			}
			Points[point][TakeOverTimerStarted] = 1;
			Points[point][TakeOverTimer] = 10;
			Points[point][ClaimerId] = INVALID_PLAYER_ID;
			Points[point][ClaimerTeam] = fam;
			Points[point][TimeToClaim] = 0;
			PointCrashProtection(point);
			if(Points[point][CaptureTimerEx2] != -1) KillTimer(Points[point][CaptureTimerEx2]);
			Points[point][CaptureTimerEx2] = SetTimerEx("CaptureTimerEx", 60000, 1, "d", point);
		}
	}
	return 1;
}

// Akatony Note: You need to destroy the 3D Label text no matter what's the state of the capture.
forward ProgressTimer(point);
public ProgressTimer(point)
{
	if (Points[point][ClaimerId] != INVALID_PLAYER_ID && Points[point][TimeToClaim])
	{
	    new string[128];
		Points[point][TimeLeft]--;
		format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~%d giay con lai", Points[point][TimeLeft]);
		GameTextForPlayer(Points[point][ClaimerId], string, 1100, 3);
		if(Points[point][TimeLeft] >= 1) SetTimerEx("ProgressTimer", 1000, 0, "d", point);
		format(string, sizeof(string), "%s dang co gang kiem soat capture, thoi gian con lai: %d", GetPlayerNameEx(Points[point][ClaimerId]), Points[point][TimeLeft]);
		if(Points[point][TimeLeft] == 9) Points[point][CaptureProgress] = CreateDynamic3DTextLabel(string, COLOR_RED, Points[point][Pointx], Points[point][Pointy], Points[point][Pointz]+1.0, 10.0);
				else if(Points[point][TimeLeft] < 9 && Points[point][TimeLeft] >= 0) UpdateDynamic3DTextLabelText(Points[point][CaptureProgress], COLOR_RED, string);
	}
	else
	{
	    DestroyDynamic3DTextLabel(Points[point][CaptureProgress]);
	    Points[point][ClaimerId] = INVALID_PLAYER_ID;
		Points[point][TimeToClaim] = 0;
	}

	if(Points[point][TimeLeft] <= 0)
	{
		DestroyDynamic3DTextLabel(Points[point][CaptureProgress]);
	    CaptureTimer(point);
	    Points[point][TimeLeft] = 0;
	}
	return 1;
}

forward HealthHackCheck(playerid, giveplayerid);
public HealthHackCheck(playerid, giveplayerid)
{
	new string[128];
 	if(giveplayerid == INVALID_PLAYER_ID)
    {
        SendClientMessageEx(playerid, COLOR_YELLOW, "Kiem tra suc khoe nguoi choi khong duoc thuc hien, da thoat game.");
        HHcheckUsed = 0;
        return 1;
    }
	if(playerTabbed[giveplayerid] != 0)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "Kiem tra suc khoe nguoi choi khong duoc thuc hien, nguoi choi alt-tabbed.");

		SetPlayerHealth(giveplayerid, HHcheckFloats[giveplayerid][0]);
		if(HHcheckFloats[giveplayerid][1] > 0) {
			SetPlayerArmor(giveplayerid, HHcheckFloats[giveplayerid][1]);
		}
		SetPlayerPos(giveplayerid, HHcheckFloats[giveplayerid][2], HHcheckFloats[giveplayerid][3], HHcheckFloats[giveplayerid][4]);
		SetPlayerFacingAngle(giveplayerid, HHcheckFloats[giveplayerid][5]);
		SetCameraBehindPlayer(giveplayerid);
		SetPlayerVirtualWorld(giveplayerid, HHcheckVW[giveplayerid]);
 		SetPlayerInterior(giveplayerid, HHcheckInt[giveplayerid]);

  		for(new i = 0; i < 6; i++)
		{
			HHcheckFloats[giveplayerid][i] = 0;
		}
		HHcheckVW[giveplayerid] = 0;
		HHcheckInt[giveplayerid] = 0;

		HHcheckUsed = 0;
  		return 1;
	}
    if(!IsPlayerInRangeOfPoint(giveplayerid,20,-1400.994873, 106.899650, 1032.273437))
    {
        SendClientMessageEx(playerid, COLOR_WHITE, "Kiem tra suc khoe nguoi choi khong duoc thuc hien, nguoi choi co mot ket noi mang yeu");

		SetPlayerHealth(giveplayerid, HHcheckFloats[giveplayerid][0]);
        if(HHcheckFloats[giveplayerid][1] > 0) {
			SetPlayerArmor(giveplayerid, HHcheckFloats[giveplayerid][1]);
		}
		SetPlayerPos(giveplayerid, HHcheckFloats[giveplayerid][2], HHcheckFloats[giveplayerid][3], HHcheckFloats[giveplayerid][4]);
		SetPlayerFacingAngle(giveplayerid, HHcheckFloats[giveplayerid][5]);
		SetCameraBehindPlayer(giveplayerid);
		SetPlayerVirtualWorld(giveplayerid, HHcheckVW[giveplayerid]);
 		SetPlayerInterior(giveplayerid, HHcheckInt[giveplayerid]);

  		for(new i = 0; i < 6; i++)
		{
			HHcheckFloats[giveplayerid][i] = 0;
		}
		HHcheckVW[giveplayerid] = 0;
		HHcheckInt[giveplayerid] = 0;

        HHcheckUsed = 0;
		return 1;
    }

    new Float:health;
    GetPlayerHealth(giveplayerid, health);
    if(health == 100)
	{
        SendClientMessageEx(playerid, COLOR_GREEN, "____________________ KIEM TRA HACK MAU_______________");
        format(string, sizeof(string), "Kiem tra hack suc khoe tre %s la {00F70C}tich cuc{FFFFFF}. Nguoi choi co the dang hack suc khoe.", GetPlayerNameEx(giveplayerid));
        SendClientMessageEx(playerid, COLOR_WHITE, string);
        SendClientMessageEx(playerid, COLOR_WHITE, "Suc khoe truoc khi kiem tra: 100.0");
        format(string, sizeof(string), "Suc khoe sau kiem tra: %.1f", health);
        SendClientMessageEx(playerid, COLOR_WHITE, string);
        SendClientMessageEx(playerid, COLOR_GREEN, "_______________________________________________________________");
    }
    else
	{
        SendClientMessageEx(playerid, COLOR_GREEN, "____________________ KIEM TRA HACK MAU_______________");
        format(string, sizeof(string), "Kiem tra hack suc khoe tre %s la {FF0606}tieu cuc{FFFFFF}. Nguoi choi khong hack suc khoe.", GetPlayerNameEx(giveplayerid));
        SendClientMessageEx(playerid, COLOR_WHITE, string);
        SendClientMessageEx(playerid, COLOR_WHITE, "Suc khoe truoc khi kiem tra: 100.0");
        format(string, sizeof(string), "Suc khoe sau kiem tra: %.1f", health);
        SendClientMessageEx(playerid, COLOR_WHITE, string);
        SendClientMessageEx(playerid, COLOR_GREEN, "_______________________________________________________________");
    }

	SetPlayerHealth(giveplayerid, HHcheckFloats[giveplayerid][0]);
	if(HHcheckFloats[giveplayerid][1] > 0) {
		SetPlayerArmor(giveplayerid, HHcheckFloats[giveplayerid][1]);
	}
	SetPlayerPos(giveplayerid, HHcheckFloats[giveplayerid][2], HHcheckFloats[giveplayerid][3], HHcheckFloats[giveplayerid][4]);
	SetPlayerFacingAngle(giveplayerid, HHcheckFloats[giveplayerid][5]);
	SetCameraBehindPlayer(giveplayerid);
	SetPlayerVirtualWorld(giveplayerid, HHcheckVW[giveplayerid]);
 	SetPlayerInterior(giveplayerid, HHcheckInt[giveplayerid]);

  	for(new i = 0; i < 6; i++)
	{
		HHcheckFloats[giveplayerid][i] = 0;
	}
	HHcheckVW[giveplayerid] = 0;
	HHcheckInt[giveplayerid] = 0;

    HHcheckUsed = 0;
    return 1;
}

forward OnPlayerPickUpDynamicPickup(playerid, pickupid);
public OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
    PickUPTruck(playerid,pickupid) ;
	for(new i = 0; i < MAX_DDOORS; i++) {
        if(pickupid == DDoorsInfo[i][ddPickupID])
        {
            new gstr[129];
            format(gstr,sizeof gstr,"~y~%s (DID: %d)~n~Su dung ~r~N~w~ de ra/vao", DDoorsInfo[i][ddDescription], i);
            ShowNotifyTextMain(playerid,gstr,5);
            //format(gstr, sizeof(gstr), "[Door Ext] %s (%d) - /enter de vao ben trong.", DDoorsInfo[i][ddDescription], i);
            //SendClientMessageEx(playerid, COLOR_GREEN, gstr);
        }
    }
    for(new i = 1; i < MAX_HOUSES; i++) 
    {
        if(pickupid == HouseInfo[i][hPickupID] )
        {
            new gstr[129];
            new location[MAX_ZONE_NAME],
                location2[MAX_ZONE_NAME];

            Get3DZone(HouseInfo[i][hExteriorX], HouseInfo[i][hExteriorY], HouseInfo[i][hExteriorZ], location2, sizeof(location2));
            GetPlayerStreetZone(HouseInfo[i][hExteriorX], HouseInfo[i][hExteriorY], location, location2, sizeof(location));
            format(gstr,sizeof gstr,"~y~S:%d-%s~n~Su dung ~r~N~w~ de ra/vao", i, location);
            ShowNotifyTextMain(playerid, gstr,5);
          
        }
    }
    for(new i = 0; i < MAX_BUSINESSES; i++) {
        if(pickupid == Businesses[i][bPickup]) 
        {
            new gstr[129];
            format(gstr,sizeof gstr,"~y~%s (BID: %d)~n~Su dung ~r~N~w~ de ra/vao", GetBusinessTypeName(Businesses[i][bType]), i);
            ShowNotifyTextMain(playerid,gstr,5);
        }
    }
   	for(new i = 0; i < sizeof(MoneyInfo); i++)
	{
		if(pickupid == MoneyInfo[i][mPickup]) // Moneybag
		{
		    if(MoneyInfo[i][mMoneybag] == 0) return 1;
		    if(IsPlayerInRangeOfPoint(playerid, 5.0, MoneyInfo[i][mbX], MoneyInfo[i][mbY], MoneyInfo[i][mbZ]))
           	{
			    new string[128];
			    new Float:plax, Float:play, Float:plaz;
			    new location[MAX_ZONE_NAME];
			    GivePlayerMoneyEx(playerid, MoneyInfo[i][mAmount]);
			    format(string, sizeof(string), "~w~bao tien~n~~g~%d $", MoneyInfo[i][mAmount]);
			    GameTextForPlayer(playerid, string, 5000, 3);
			    GetPlayerPos(playerid, plax, play, plaz);
			    PlayerPlaySound(playerid, 1056, plax, play, plaz);
			    DestroyDynamicPickup(MoneyInfo[i][mPickup]);
			    MoneyInfo[i][mCreated]=0;
			    GetPlayer2DZone(playerid, location, MAX_ZONE_NAME);
				format(string, sizeof(string), "WARNING: %s da nhan mot bao tien trong %s co gia tri %d $", GetPlayerNameEx(playerid), location, MoneyInfo[i][mAmount]);
				ABroadCast( COLOR_YELLOW, string, 2);
				format(string, sizeof(string), "{FF6347}%s da tim thay tui tien o %s co gia tri %d $", GetPlayerNameEx(playerid), location, MoneyInfo[i][mAmount]);
				SendClientMessageToAll(COLOR_LIGHTRED, string);
				return 1;
			}
		}
	}
	new vehicleid = GetPlayerVehicleID(playerid);
	for(new x = 0; x < sizeof(SpikeStrips); ++x)
	{
		if(SpikeStrips[x][sX] != 0 && pickupid == SpikeStrips[x][sPickupID])
		{
			DestroyDynamicPickup(SpikeStrips[x][sPickupID]);
			SpikeStrips[x][sPickupID] = CreateDynamicPickup(19300, 14, SpikeStrips[x][sX], SpikeStrips[x][sY], SpikeStrips[x][sZ]);
			if(GetVehicleDistanceFromPoint(vehicleid, SpikeStrips[x][sX], SpikeStrips[x][sY], SpikeStrips[x][sZ]) <= 6.0)
			{
				new Float:pos[4];
				GetVehiclePos(vehicleid, pos[0], pos[1], pos[2]);
				GetVehicleZAngle(vehicleid, pos[3]);
				// TODO: This should be more specific to the vehicle
				// TODO: Bike tires should be checked differently

				if(GetDistanceBetweenPoints(pos[0], pos[1], pos[2], SpikeStrips[x][sX], SpikeStrips[x][sY], SpikeStrips[x][sZ]) <= 4)
				{
						// Pop Front
					SetVehicleTireState(vehicleid, 0, 0, 0, 0);
				}
			}
		}
	}
	if (GetPVarInt(playerid, "_BikeParkourStage") > 0)
	{
		new stage = GetPVarInt(playerid, "_BikeParkourStage");
		new slot = GetPVarInt(playerid, "_BikeParkourSlot");
		new bikePickup = GetPVarInt(playerid, "_BikeParkourPickup");
		new business = InBusiness(playerid);

		if (pickupid != bikePickup)
		{
			SendClientMessageEx(playerid, COLOR_GRAD2, "Day khong phai muc tieu cua ban!");
			return 1;
		}

		if (stage > 1 && !IsPlayerInAnyVehicle(playerid))
		{
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban phai di bang xe dap cua ban de tien hanh Parkour!");
			return 1;
		}

		switch (GetPVarInt(playerid, "_BikeParkourStage"))
		{
			case 1:
			{
				DestroyDynamicPickup(bikePickup);

				new Float:pos[4];
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				GetPlayerFacingAngle(playerid, pos[3]);

				new vehicleId = CreateVehicle(481, pos[0], pos[1], pos[2], pos[3], 0, 0, 0);
				SetVehicleVirtualWorld(vehicleId, GetPlayerVirtualWorld(playerid));
				LinkVehicleToInterior(vehicleId, GetPlayerInterior(playerid));
				Businesses[business][bGymBikeVehicles][slot] = vehicleId;

				SendClientMessageEx(playerid, COLOR_WHITE, "Thuc hien theo huong mui ten de tien hanh Parkour.");
				//SendClientMessageEx(playerid, COLOR_WHITE, "Type /leaveparkour to quit the activity without completing it.");

				bikePickup = CreateDynamicPickup(1318, 14, 2823.5071, -2260.9243, 97.5347, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 2);
			}

			case 2:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2821.0806, -2254.6775, 98.6094, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 3);
			}

			case 3:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2817.6206, -2246.4187, 98.6221, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 4);
			}

			case 4:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2813.2246, -2235.4602, 98.6094, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 5);
			}

			case 5:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2817.3789, -2228.5271, 98.6919, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 6);
			}

			case 6:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2823.3210, -2232.0654, 98.6221, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 7);
			}

			case 7:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2828.3071, -2231.8882, 99.2544, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 8);
			}

			case 8:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2831.8652, -2235.8438, 99.8750, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 9);
			}

			case 9:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2832.3789, -2243.1646, 98.8604, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 10);
			}

			case 10:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2830.2227, -2247.3076, 98.6094, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 11);
			}

			case 11:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2830.8708, -2251.3501, 99.7329, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 12);
			}

			case 12:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2840.0076, -2252.7549, 99.7329, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 13);
			}

			case 13:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2858.3438, -2252.1355, 99.2871, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 14);
			}

			case 14:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2857.1311, -2239.4653, 99.2373, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 15);
			}

			case 15:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2852.6345, -2239.1692, 98.6665, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 16);
			}

			case 16:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2846.7661, -2226.1548, 98.8716, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 17);
			}

			case 17:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2838.6113, -2228.2808, 98.7231, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 18);
			}

			case 18:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2837.6887, -2219.9446, 100.5010, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 19);
			}

			case 19:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2833.5979, -2215.8831, 100.4380, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 20);
			}

			case 20:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2825.3645, -2220.9446, 100.4761, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 21);
			}

			case 21:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2818.7837, -2223.2014, 98.6221, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 22);
			}

			case 22:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2823.7703, -2224.3865, 98.9653, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 23);
			}

			case 23:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2836.5769, -2232.2056, 96.0278, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 24);
			}

			case 24:
			{
				DestroyDynamicPickup(bikePickup);

				new vehicle = Businesses[business][bGymBikeVehicles][slot];
				DestroyVehicle(vehicle);

				Businesses[business][bGymBikePlayers][slot] = INVALID_PLAYER_ID;
				Businesses[business][bGymBikeVehicles][slot] = INVALID_VEHICLE_ID;

				SendClientMessageEx(playerid, COLOR_WHITE, "Ket thuc Parkour.");

				DeletePVar(playerid, "_BikeParkourStage");
				DeletePVar(playerid, "_BikeParkourSlot");
				DeletePVar(playerid, "_BikeParkourPickup");
			}
		}
	}
	return 1;
}

forward ReplyTimer(reportid);
public ReplyTimer(reportid)
{
    Reports[reportid][ReportPriority] = 0;
    Reports[reportid][ReportLevel] = 0;
    Reports[reportid][BeingUsed] = 0;
	Reports[reportid][ReportFrom] = INVALID_PLAYER_ID;
    Reports[reportid][CheckingReport] = INVALID_PLAYER_ID;
}

forward PayNSpray(playerid, id, vehicleid);
public PayNSpray(playerid, id, vehicleid)
{
	if(DynVeh[vehicleid] != -1 && DynVehicleInfo[DynVeh[vehicleid]][gv_igID] != INVALID_GROUP_ID)
	{
		new iGroupID = DynVehicleInfo[DynVeh[vehicleid]][gv_igID];
		if(arrGroupData[iGroupID][g_iBudget] >= PayNSprays[id][pnsGroupCost])
		{
			arrGroupData[iGroupID][g_iBudget] -= PayNSprays[id][pnsGroupCost];
			new str[128], file[32];
			format(str, sizeof(str), "%s da sua xe %d voi so tien $%s tai diem sua xe cua %s's.", GetPlayerNameEx(playerid), GetPlayerVehicleID(playerid), number_format(PayNSprays[id][pnsGroupCost]), arrGroupData[iGroupID][g_szGroupName]);
			new month, day, year;
			getdate(year,month,day);
			format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", iGroupID, month, day, year);
			Log(file, str);
			SendClientMessageEx(playerid, COLOR_GREY, "Chiec xe nay da duoc tra tien boi chinh phu.");
		}
		else
		{
			SendClientMessage(playerid, COLOR_WHITE, "Chinh phu khong con tien da tri tra cho viec sua chua chiec xe nay!");
			TogglePlayerControllable(playerid, 1);
			return 1;
		}
	}
	else
	{
		if(PlayerInfo[playerid][pCash] >= PayNSprays[id][pnsRegCost])
		{
			GivePlayerMoneyEx(playerid, -PayNSprays[id][pnsRegCost]);
		}
		else
		{
			SendClientMessage(playerid, COLOR_WHITE, "Ban khong du tien de tra cho  dich vu nay!");
			TogglePlayerControllable(playerid, 1);
			return 1;
		}
	}
	RepairVehicle(vehicleid);
	Vehicle_Armor(vehicleid);
	if(IsTrailerAttachedToVehicle(vehicleid))
	{
		RepairVehicle(GetVehicleTrailer(vehicleid));
		Vehicle_Armor(GetVehicleTrailer(vehicleid));
	}
	SendClientMessage(playerid, COLOR_WHITE, "(SUA CHUA XE) Chiec xe cua ban da duoc sua chua thanh cong!");
	PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
	TogglePlayerControllable(playerid, 1);
	return 1;
}

forward DisableCheckPoint(playerid);
public DisableCheckPoint(playerid)
{
    return DisablePlayerCheckpoint(playerid);
}

forward StopaniTimer(playerid);
public StopaniTimer(playerid)
{
	new Float:posX, Float:posY, Float:posZ;
    GetPlayerPos(playerid, posX, posY, posZ);

    if(StopaniFloats[playerid][0] != posX || StopaniFloats[playerid][1] != posY || StopaniFloats[playerid][2] != posZ)
	{
	    SendClientMessageEx (playerid, COLOR_YELLOW, "Ban da di chuyen trong viec su dung hanh dong!");
    	for(new i = 0; i < 3; i++)
		{
			StopaniFloats[playerid][i] = 0;
		}
	    return 1;
	}
	SendClientMessageEx (playerid, COLOR_YELLOW, "Hanh dong cua ban da duoc xoa!");
	ClearAnimations(playerid);
	SetPlayerSkin(playerid, GetPlayerSkin(playerid));
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);

	for(new i = 0; i < 3; i++)
	{
		StopaniFloats[playerid][i] = 0;
	}
	return 1;
}


forward HijackTruck(playerid);
public HijackTruck(playerid)
{
    new vehicleid = GetPlayerVehicleID(playerid);
	SetPVarInt(playerid, "LoadTruckTime", GetPVarInt(playerid, "LoadTruckTime")-1);
	new string[128];
	format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~%d giay nua", GetPVarInt(playerid, "LoadTruckTime"));
	GameTextForPlayer(playerid, string, 1100, 3);
	if(GetPVarInt(playerid, "LoadTruckTime") > 0) SetTimerEx("HijackTruck", 1000, 0, "d", playerid);

	if(GetPVarInt(playerid, "LoadTruckTime") <= 0)
	{
		DeletePVar(playerid, "IsFrozen");
		TogglePlayerControllable(playerid, 1);
  		DeletePVar(playerid, "LoadTruckTime");

        if(!IsPlayerInVehicle(playerid, vehicleid))
        {
			TruckUsed[playerid] = INVALID_VEHICLE_ID;
			gPlayerCheckpointStatus[playerid] = CHECKPOINT_NONE;
 			DisablePlayerCheckpoint(playerid);
            SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* Ban cuop hang khong thanh cong.");
			return 1;
        }

		foreach(new i: Player)
		{
  			if(TruckUsed[i] == vehicleid)
  			{
				DeletePVar(i, "LoadTruckTime");
				TruckUsed[i] = INVALID_VEHICLE_ID;
				DisablePlayerCheckpoint(i);
				gPlayerCheckpointStatus[i] = CHECKPOINT_NONE;
 				SendClientMessageEx(i, COLOR_WHITE, "Vu van chuyen khong thanh cong, ban da bi cuop.");
			}
		}
  		TruckUsed[playerid] = vehicleid;
  		if(IsABoat(vehicleid))
  		{
		    SetPVarInt(playerid, "TruckDeliver", TruckContents{vehicleid});
			new route = TruckRoute[vehicleid];
			switch(TruckContents{vehicleid})
			{
				case 1:
				{
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"Ban da cuop hang food & beverages.");
					SetPlayerCheckpoint(playerid, BoatDropoffs[route][PosX], BoatDropoffs[route][PosY], BoatDropoffs[route][PosZ], 10);
				}
				case 2:
				{
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"Ban da cuop hang clothing.");
					SetPlayerCheckpoint(playerid, BoatDropoffs[route][PosX], BoatDropoffs[route][PosY], BoatDropoffs[route][PosZ], 10);
				}
				case 3:
				{
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"Ban da cuop hang materials.");
					SetPlayerCheckpoint(playerid, BoatDropoffs[route][PosX], BoatDropoffs[route][PosY], BoatDropoffs[route][PosZ], 10);
				}
				case 4:
				{
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* Ban da cuop hang stolen 24/7 items - Can than nguoi thi hanh cong vu!");
					SetPlayerCheckpoint(playerid, BoatDropoffs[route][PosX], BoatDropoffs[route][PosY], BoatDropoffs[route][PosZ], 10);
				}
				case 5:
				{
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* Ban da cuop hang weapons - Can than nguoi thi hanh cong vu!");
					SetPlayerCheckpoint(playerid, BoatDropoffs[route][PosX], BoatDropoffs[route][PosY], BoatDropoffs[route][PosZ], 10);
				}
				case 6:
				{
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"Ban da cuop hang drugs - Can than nguoi thi hanh cong vu!");
					SetPlayerCheckpoint(playerid, BoatDropoffs[route][PosX], BoatDropoffs[route][PosY], BoatDropoffs[route][PosZ], 10);
				}
				case 7:
				{
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"Ban da cuop hang illegal materials - Can than nguoi thi hanh cong vu!");
					SetPlayerCheckpoint(playerid, BoatDropoffs[route][PosX], BoatDropoffs[route][PosY], BoatDropoffs[route][PosZ], 10);
				}
				case 8:
				{
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"Ban da cuop hang illegal materials - Can than nguoi thi hanh cong vu!");
					SetPlayerCheckpoint(playerid, BoatDropoffs[route][PosX], BoatDropoffs[route][PosY], BoatDropoffs[route][PosZ], 10);
				}
				default: return SendClientMessageEx(playerid, COLOR_GRAD2, "Trong xe khong co hang.");
			}
			SendClientMessageEx(playerid, COLOR_REALRED, "Canh Bao: Can than bon cuop, chung co the cuop hang cua ban.");
		}
		else
		{
			new route = TruckRoute[vehicleid];
			SetPVarInt(playerid, "TruckDeliver", TruckContents{vehicleid});
			switch(TruckContents{vehicleid}) {
			    case 0:
				{
				    SendClientMessage(playerid, -1, "Cai Case 0 ne");
				}
				case 1:
				{
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"Ban da cuop hang food & beverages.");
					SetPlayerCheckpoint(playerid, TruckerDropoffs[route][PosX], TruckerDropoffs[route][PosY], TruckerDropoffs[route][PosZ], 10);
				}
				case 2:
				{
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"Ban da cuop hang clothing.");
					SetPlayerCheckpoint(playerid, TruckerDropoffs[route][PosX], TruckerDropoffs[route][PosY], TruckerDropoffs[route][PosZ], 10);
				}
				case 3:
				{
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"Ban da cuop hang materials.");
					SetPlayerCheckpoint(playerid, TruckerDropoffs[route][PosX], TruckerDropoffs[route][PosY], TruckerDropoffs[route][PosZ], 10);
				}
				case 4:
				{
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* Ban da cuop hang 24/7 items - Can than nguoi thi hanh cong vu!");
					SetPlayerCheckpoint(playerid, TruckerDropoffs[route][PosX], TruckerDropoffs[route][PosY], TruckerDropoffs[route][PosZ], 10);
				}
				case 5:
				{
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"*Ban da cuop hang weapons - Can than nguoi thi hanh cong vu!");
					SetPlayerCheckpoint(playerid, TruckerDropoffs[route][PosX], TruckerDropoffs[route][PosY], TruckerDropoffs[route][PosZ], 10);
				}
				case 6:
				{
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"Ban da cuop hang drugs - Can than nguoi thi hanh cong vu!");
					SetPlayerCheckpoint(playerid, TruckerDropoffs[route][PosX], TruckerDropoffs[route][PosY], TruckerDropoffs[route][PosZ], 10);
				}
				case 7:
				{
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"Ban da cuop hang illegal materials - Can than nguoi thi hanh cong vu!");
					SetPlayerCheckpoint(playerid, TruckerDropoffs[route][PosX], TruckerDropoffs[route][PosY], TruckerDropoffs[route][PosZ], 10);
				}
				case 8:
				{
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"Ban da cuop hang illegal materials - Can than nguoi thi hanh cong vu!");
					SetPlayerCheckpoint(playerid, TruckerDropoffs[route][PosX], TruckerDropoffs[route][PosY], TruckerDropoffs[route][PosZ], 10);
				}
				case 9:
				{
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"Ban da cuop hang illegal materials - Can than nguoi thi hanh cong vu!");
					SetPlayerCheckpoint(playerid, BoatDropoffs[route][PosX], BoatDropoffs[route][PosY], BoatDropoffs[route][PosZ], 10);
				}
			}
			SendClientMessageEx(playerid, COLOR_REALRED, "Canh Bao: Can than bon cuop, chung co the cuop hang cua ban.");
		}
		SendClientMessageEx(playerid, COLOR_WHITE, "Dua hang den checkpoint tren ban do (Xem tren ban do).");
	}
	return 1;
}

forward LoadTruckOld(playerid);
public LoadTruckOld(playerid)
{
    SetPVarInt(playerid, "LoadTruckTime", GetPVarInt(playerid, "LoadTruckTime")-1);
	new string[128];
	format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~%d giay nua", GetPVarInt(playerid, "LoadTruckTime"));
	GameTextForPlayer(playerid, string, 1100, 3);

	if(GetPVarInt(playerid, "LoadTruckTime") > 0) SetTimerEx("LoadTruckOld", 1000, 0, "d", playerid);

	if(GetPVarInt(playerid, "LoadTruckTime") <= 0)
	{
		DeletePVar(playerid, "LoadTruckTime");
		DeletePVar(playerid, "IsFrozen");
		TogglePlayerControllable(playerid, 1);

  		new vehicleid = GetPlayerVehicleID(playerid);
  		new truckdeliver = GetPVarInt(playerid, "TruckDeliver");
  		TruckContents{vehicleid} = truckdeliver;
  		TruckUsed[playerid] = vehicleid;
  		if(IsABoat(vehicleid))
  		{
	        new route = random(sizeof(BoatDropoffs));
	        TruckRoute[vehicleid] = route;
			if(truckdeliver == 1)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* Thuyen cua ban chua day food & beverages.");
				SetPlayerCheckpoint(playerid, BoatDropoffs[route][PosX], BoatDropoffs[route][PosY], BoatDropoffs[route][PosZ], 10);
			}
			else if(truckdeliver == 2)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* Thuyen cua ban chua day clothing.");
				SetPlayerCheckpoint(playerid, BoatDropoffs[route][PosX], BoatDropoffs[route][PosY], BoatDropoffs[route][PosZ], 10);
			}
			else if(truckdeliver == 3)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* Thuyen cua ban chua day materials.");
				SetPlayerCheckpoint(playerid, BoatDropoffs[route][PosX], BoatDropoffs[route][PosY], BoatDropoffs[route][PosZ], 10);
			}
			else if(truckdeliver == 4)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* Thuyen cua ban chua day 24/7 items.");
				SetPlayerCheckpoint(playerid, BoatDropoffs[route][PosX], BoatDropoffs[route][PosY], BoatDropoffs[route][PosZ], 10);
			}
			else if(truckdeliver == 5)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* Thuyen cua ban chua day weapons.");
				SetPlayerCheckpoint(playerid, BoatDropoffs[route][PosX], BoatDropoffs[route][PosY], BoatDropoffs[route][PosZ], 10);
			}
			else if(truckdeliver == 6)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* Thuyen cua ban chua day drugs.");
				SetPlayerCheckpoint(playerid, BoatDropoffs[route][PosX], BoatDropoffs[route][PosY], BoatDropoffs[route][PosZ], 10);
			}
			else if(truckdeliver == 7)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* Thuyen cua ban chua day illegal materials.");
				SetPlayerCheckpoint(playerid, BoatDropoffs[route][PosX], BoatDropoffs[route][PosY], BoatDropoffs[route][PosZ], 10);
			}
   			else if(truckdeliver == 8)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* Thuyen cua ban chua day illegal materials.");
				SetPlayerCheckpoint(playerid, BoatDropoffs[route][PosX], BoatDropoffs[route][PosY], BoatDropoffs[route][PosZ], 10);
			}
			SendClientMessageEx(playerid, COLOR_REALRED, "Canh Bao: Can than bon cuop, chung co the cuop hang cua ban.");
		}
		else
		{
			new route = random(sizeof(TruckerDropoffs));
			TruckRoute[vehicleid] = route;
			if(truckdeliver == 1)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* Truck cua ban da duoc chat day food & beverages.");
				SetPlayerCheckpoint(playerid, TruckerDropoffs[route][PosX], TruckerDropoffs[route][PosY], TruckerDropoffs[route][PosZ], 10);
			}
			else if(truckdeliver == 2)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* Truck cua ban da duoc chat day clothing.");
				SetPlayerCheckpoint(playerid, TruckerDropoffs[route][PosX], TruckerDropoffs[route][PosY], TruckerDropoffs[route][PosZ], 10);
			}
			else if(truckdeliver == 3)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* Truck cua ban da duoc chat day materials.");
				SetPlayerCheckpoint(playerid, TruckerDropoffs[route][PosX], TruckerDropoffs[route][PosY], TruckerDropoffs[route][PosZ], 10);
			}
			else if(truckdeliver == 4)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* Truck cua ban da duoc chat day 24/7 items.");
				SetPlayerCheckpoint(playerid, TruckerDropoffs[route][PosX], TruckerDropoffs[route][PosY], TruckerDropoffs[route][PosZ], 10);
			}
			else if(truckdeliver == 5)
			{
				SendClientMessageEx(playerid, 0x4c5b74FF, "Da lay hang xong.");
				SetPlayerCheckpoint(playerid, TruckerDropoffs[route][PosX], TruckerDropoffs[route][PosY], TruckerDropoffs[route][PosZ], 10);
			}
			else if(truckdeliver == 6)
			{
				SendClientMessageEx(playerid, 0x4c5b74FF, "Da lay hang xong.");
				SetPlayerCheckpoint(playerid, TruckerDropoffs[route][PosX], TruckerDropoffs[route][PosY], TruckerDropoffs[route][PosZ], 10);
			}
			else if(truckdeliver == 7)
			{
				SendClientMessageEx(playerid, 0x4c5b74FF, "Da lay hang xong.");
				SetPlayerCheckpoint(playerid, TruckerDropoffs[route][PosX], TruckerDropoffs[route][PosY], TruckerDropoffs[route][PosZ], 10);
			}
			else if(truckdeliver == 8)
			{
				SendClientMessageEx(playerid, 0x4c5b74FF, "Da lay hang xong.");
				SetPlayerCheckpoint(playerid, TruckerDropoffs[route][PosX], TruckerDropoffs[route][PosY], TruckerDropoffs[route][PosZ], 10);
			}
			else if(truckdeliver == 9)
			{
				SendClientMessageEx(playerid, 0x4c5b74FF, "Da lay hang xong.");
				SetPlayerCheckpoint(playerid, TruckerDropoffs[route][PosX], TruckerDropoffs[route][PosY], TruckerDropoffs[route][PosZ], 10);
			}
			SendClientMessageEx(playerid, COLOR_REALRED, "[WARNING] Ban co the bi cuop hang bat cu luc nao.");
		}
		SendClientMessageEx(playerid, COLOR_GREY, "Hay giao hang den dia diem chi dinh [CHECKPOINT].");
		SetPVarInt(playerid, "tpTruckRunTimer", 30);
		SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_TPTRUCKRUNTIMER);
	}
	return 1;
}

#if defined zombiemode
forward OnZombieCheck(playerid);
public OnZombieCheck(playerid)
{
	if(IsPlayerConnected(playerid))
	{
 		new rows, fields;
   		cache_get_data(rows, fields, MainPipeline);
		if(rows)
		{
			MakeZombie(playerid);
		}
	}
	return 1;
}
#endif

forward LoadTruck(playerid);
public LoadTruck(playerid)
{
    SetPVarInt(playerid, "LoadTruckTime", GetPVarInt(playerid, "LoadTruckTime")-1);
	new string[128];
	format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~%d giay con lai", GetPVarInt(playerid, "LoadTruckTime"));
	GameTextForPlayer(playerid, string, 1100, 3);

	if(GetPVarInt(playerid, "LoadTruckTime") > 0) SetTimerEx("LoadTruck", 1000, 0, "d", playerid);

	if(GetPVarInt(playerid, "LoadTruckTime") <= 0)
	{
		DeletePVar(playerid, "LoadTruckTime");
		DeletePVar(playerid, "IsFrozen");
		TogglePlayerControllable(playerid, 1);

  		new vehicleid = GetPlayerVehicleID(playerid);
  		new business = TruckDeliveringTo[vehicleid];
  		TruckUsed[playerid] = vehicleid;


		gPlayerCheckpointStatus[playerid] = CHECKPOINT_DELIVERYBIZ;

		format(string, sizeof(string), "* Xe tai cua ban da day %s", GetInventoryType(business));
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);

        SetPlayerCheckpoint(playerid, Businesses[business][bSupplyPos][0], Businesses[business][bSupplyPos][1], Businesses[business][bSupplyPos][2], 10.0);

		SendClientMessageEx(playerid, COLOR_WHITE, "HUONG DAN: Dua hang hoa yeu cau den dia diem nhan hang (di theo diem do tren rada).");
		SendClientMessageEx(playerid, COLOR_REALRED, "CANH BAO: Coi chung nhung ten cuop, chung co the lay hang hoa cua ban va tau thoat...");

		if (Businesses[business][bType] == BUSINESS_TYPE_GUNSHOP)
		{
			SendClientMessageEx(playerid, COLOR_REALRED, "CANH BAO #2: Ban dang dua hang pham phap, hay coi chung nhan vien thuc thi phap luat.");
		}
		else if (Businesses[business][bType] == BUSINESS_TYPE_GASSTATION)
		{
		  	new Float:x, Float:y, Float:z, Float:ang;
		  	SetVehiclePos(vehicleid, -1570.9833,96.7547,4.1442);
		  	SetVehicleZAngle(vehicleid, 136.18);
		    GetPlayerPos(playerid, x, y, z);
		    GetVehicleZAngle(vehicleid, ang);
		    new iTrailer = CreateVehicle(584, x, y, z+1, ang, -1, -1, 1000);
		    SetPVarInt(playerid, "Gas_TrailerID", iTrailer);
			SetTimerEx("AttachGasTrailer", 500, false, "ii", iTrailer, vehicleid);
		}
		SetPVarInt(playerid, "tpTruckRunTimer", floatround(GetPlayerDistanceFromPoint(playerid, Businesses[business][bSupplyPos][0], Businesses[business][bSupplyPos][1], Businesses[business][bSupplyPos][2]) / 100));
		SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_TPTRUCKRUNTIMER);
	}
	return 1;
}


forward EndAuction(auction);
public EndAuction(auction)
{
	if(Auctions[auction][InProgress] == 1 && Auctions[auction][Bidder] != 0) {
		if(Auctions[auction][Expires] == 0) {

			new string[128];
		    format( string, sizeof( string ), "{AA3333}AdmWarning{FFFF00}: %s da gianh duoc dau gia %s voi $%d", Auctions[auction][Wining], Auctions[auction][BiddingFor], Auctions[auction][Bid]);
			ABroadCast( COLOR_YELLOW, string, 2 );

			format(string, sizeof(string), "%s(%d) da thang dau gia cho mat hang %s(%i) va da thanh toan $%d", Auctions[auction][Wining], Auctions[auction][Bidder], Auctions[auction][BiddingFor], auction, Auctions[auction][Bid]);
			Log("logs/auction.log", string);

			new Player = ReturnUser(Auctions[auction][Wining]);
			if(IsPlayerConnected(Player) && GetPlayerSQLId(Player) == Auctions[auction][Bidder])
			{
	 			format(string, sizeof(string), "(Dau gia thang) %s %s", Auctions[auction][Wining], Auctions[auction][BiddingFor]);
			   	AddFlag(Player, INVALID_PLAYER_ID, string);

				format(string, sizeof(string), "Ban da thang dau gia %s!", Auctions[auction][BiddingFor]);
		  		SendClientMessageEx(Player, COLOR_GREEN, string);
			}
			else
			{
		 		format(string, sizeof(string), "(Dau gia thang) %s %s", Auctions[auction][Wining], Auctions[auction][BiddingFor]);
		   		AddOFlag(Auctions[auction][Bidder], INVALID_PLAYER_ID, string);
			}

			Auctions[auction][InProgress] = 0;
			Auctions[auction][Bid] = 0;
			Auctions[auction][Bidder] = 0;
			Auctions[auction][Expires] = 0;
			strcpy(Auctions[auction][Wining], "(none)", MAX_PLAYER_NAME);
			strcpy(Auctions[auction][BiddingFor], "(none)", 64);
			Auctions[auction][Increment] = 0;
			KillTimer(Auctions[auction][Timer]);
			SaveAuction(auction);
		}
		else
		{
		    Auctions[auction][Expires] += -1;
		}
	}
	else
	{
	    KillTimer(Auctions[auction][Timer]);
	}
	return 1;
}

forward AttachGasTrailer(trailerid,vehicleid);
public AttachGasTrailer(trailerid,vehicleid)
{
	return AttachTrailerToVehicle(trailerid, vehicleid);
}

forward AttemptPurify(playerid);
public AttemptPurify(playerid)
{
	if(IsPlayerInRangeOfPoint(playerid, 5.0, -882.2048,1109.3385,5442.8193))
	{
	    if(playerTabbed[playerid] != 0)
		{
   			SendClientMessageEx(playerid, COLOR_GREY, "Ban da alt-tabbed trong qua trinh thanh loc.");
			Purification[0] = 0;
	    	KillTimer(GetPVarInt(playerid, "AttemptPurify"));
	    	DeletePVar(playerid, "PurifyTime");
	    	DeletePVar(playerid, "AttemptPurify");
    		return 1;
		}
	    if(GetPVarInt(playerid, "PurifyTime") == 30)
	    {
	        new szMessage[128];
	        if(PlayerInfo[playerid][pRawOpium] > 30)
	        {
	        	format(szMessage, sizeof(szMessage), "Ban da tinh che thanh cong %d milligrams  heroin!", 30);
	        	SendClientMessageEx(playerid, COLOR_GREEN, szMessage);

	        	format(szMessage, sizeof(szMessage), "* %s da tinh che thanh cong %d milligrams heroin.", GetPlayerNameEx(playerid), 30);
				ProxDetector(25.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

				PlayerInfo[playerid][pHeroin] += 30;
	        	PlayerInfo[playerid][pRawOpium] -= 30;
            	KillTimer(GetPVarInt(playerid, "AttemptPurify"));
	        	Purification[0] = 0;
	        	DeletePVar(playerid, "PurifyTime");
	        	DeletePVar(playerid, "AttemptPurify");
			}
			else
			{
	        	format(szMessage, sizeof(szMessage), "Ban da tinh che thanh cong %d milligrams heroin!", PlayerInfo[playerid][pRawOpium]);
	        	SendClientMessageEx(playerid, COLOR_GREEN, szMessage);

	        	format(szMessage, sizeof(szMessage), "* %s da tinh che thanh cong %d milligrams  heroin.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pRawOpium]);
				ProxDetector(25.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

				PlayerInfo[playerid][pHeroin] += PlayerInfo[playerid][pRawOpium];
	        	PlayerInfo[playerid][pRawOpium] = 0;
            	KillTimer(GetPVarInt(playerid, "AttemptPurify"));
	        	Purification[0] = 0;
	        	DeletePVar(playerid, "PurifyTime");
	        	DeletePVar(playerid, "AttemptPurify");
			}
		}
	    else
	    {
	    	SetPVarInt(playerid, "PurifyTime", GetPVarInt(playerid, "PurifyTime")+1);
		}
	}
	else
	{
	    DeletePVar(playerid, "PurifyTime");
	    Purification[0] = 0;
	    KillTimer(GetPVarInt(playerid, "AttemptPurify"));
	    DeletePVar(playerid, "AttemptPurify");
	    SendClientMessageEx(playerid, COLOR_GREY, "Ban ngung qua trinh thanh loc.");
	}
	return 1;
}

forward DragPlayer(dragger, dragee);
public DragPlayer(dragger, dragee)
{
	if(!IsPlayerConnected(dragee))
	{
		SetPVarInt(dragger, "DraggingPlayer", INVALID_PLAYER_ID);
		SendClientMessageEx(dragger, COLOR_GRAD2, "Nguoi choi ban dang dan di da mat ket noi.");
	}
	if(GetPVarInt(dragger, "DraggingPlayer") != INVALID_PLAYER_ID)
	{
		new Float:dX, Float:dY, Float:dZ;
		GetPlayerPos(dragger, dX, dY, dZ);
		floatsub(dX, 0.4);
		floatsub(dY, 0.4);

		SetPVarFloat(dragee, "DragX", dX);
		SetPVarFloat(dragee, "DragY", dY);
		SetPVarFloat(dragee, "DragZ", dZ);
		SetPVarInt(dragee, "DragWorld", GetPlayerVirtualWorld(dragger));
		SetPVarInt(dragee, "DragInt", GetPlayerInterior(dragger));
		Streamer_UpdateEx(dragee, dX, dY, dZ);
		SetPlayerPos(dragee, dX, dY, dZ);
		SetPlayerInterior(dragee, GetPlayerInterior(dragger));
		SetPlayerVirtualWorld(dragee, GetPlayerVirtualWorld(dragger));
		ClearAnimations(dragee);
		ApplyAnimation(dragee, "ped","cower",1,1,0,0,0,0,1);
        SetTimerEx("DragPlayer", 1000, 0, "ii", dragger, dragee);
	}
	return 1;
}

forward CuffTackled(playerid, giveplayerid);
public CuffTackled(playerid, giveplayerid)
{
	new string[128];
	if(!GetPVarType(giveplayerid, "IsTackled"))
	{
	    return SendClientMessageEx(playerid, COLOR_GRAD1, "Ke tinh nghi da thoat khoi tay ban, su dung hanh dong hoac tazer de bat nguoi do!");
	}
	if(GetPVarType(giveplayerid, "TackledResisting")) // If they haven't chosen - we assume they're resisting
	{
	    if(GetPVarInt(giveplayerid, "TackledResisting") == 1) // complying
	    {
			if(GetPVarType(giveplayerid, "IsTackled"))
			{
				return CuffTacklee(playerid, giveplayerid);
			}
		}
	    if(GetPVarInt(giveplayerid, "TackledResisting") == 2) // resisting
	    {
	        new copcount;
			foreach(new j: Player)
			{
				if(ProxDetectorS(4.0, giveplayerid, j) && IsACop(j) && j != giveplayerid)
				{
					copcount++;
				}
			}
	        format(string, sizeof(string), "* %s day va co gang khang cu lai %s.", GetPlayerNameEx(giveplayerid), GetPlayerNameEx(playerid));
    		ProxDetector(30.0, giveplayerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	        new cuffchance = random(11);
	        if(copcount >= 2 && copcount < 5) cuffchance = random(6);
			else if(copcount >= 5) cuffchance = 1;
			switch(cuffchance)
			{
			    case 0..4: // success
			    {
			        return CuffTacklee(playerid, giveplayerid);
			    }
				default: // fail
				{
					format(string, sizeof(string), "* %s day %s sang mot ben va tau thoat.", GetPlayerNameEx(giveplayerid), GetPlayerNameEx(playerid));
    				ProxDetector(30.0, giveplayerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
    				TogglePlayerControllable(playerid, 0);
					ApplyAnimation(playerid, "SWEET", "Sweet_injuredloop", 4.0, 1, 1, 1, 1, 0, 1);
					SetTimerEx("CopGetUp", 3500, 0, "i", playerid);
				 	ClearTackle(giveplayerid);
				}
			}
	    }
	}
	else
	{
	    ShowPlayerDialog(giveplayerid, -1, DIALOG_STYLE_LIST, "Dong lai", "Dong lai", "Dong lai", "Dong lai");
	    SetPVarInt(giveplayerid, "TackledResisting", 2);
		CuffTackled(playerid, giveplayerid);
	}
	return 1;
}

forward HeroinEffect(playerid);
public HeroinEffect(playerid)
{
	if(GetPVarInt(playerid, "Health") != 0)
	{
		SetPVarInt(playerid, "Health", GetPVarInt(playerid, "Health")-1);
		SetPlayerHealth(playerid, GetPVarInt(playerid, "Health"));
	}
	else
	{
	    KillTimer(GetPVarInt(playerid, "HeroinEffect"));
	    DeletePVar(playerid, "HeroinEffect");
	}
	return 1;
}

forward InjectHeroin(playerid);
public InjectHeroin(playerid)
{
    KillEMSQueue(playerid);
	ClearAnimations(playerid);
	SetPlayerHealth(playerid, 30);
	SetPVarInt(playerid, "HeroinEffect", SetTimerEx("HeroinEffect", 1000, 1, "i", playerid));
	return 1;
}

forward HeroinEffectStanding(playerid);
public HeroinEffectStanding(playerid)
{
	SetPVarInt(playerid, "HeroinDamageResist", 0);
	SendClientMessageEx(playerid, COLOR_GREEN, "Tac dong cua heroin da dan bien mat.");
	return 1;
}

forward InjectHeroinStanding(playerid);
public InjectHeroinStanding(playerid)
{
	SetPVarInt(playerid, "HeroinDamageResist", 1);
	SendClientMessageEx(playerid, COLOR_GREEN, "Anh huong cua ma tuy da bat dau.");
	SetPVarInt(playerid, "HeroinEffectStanding", SetTimerEx("HeroinEffectStanding", 30000, 0, "i", playerid));
	return 1;
}

forward ParkVehicle(playerid, ownerid, vehicleid, d, Float:X, Float:Y, Float:Z);
public ParkVehicle(playerid, ownerid, vehicleid, d, Float:X, Float:Y, Float:Z)
{
	if(IsPlayerInRangeOfPoint(playerid, 1.0, X, Y, Z))
	{
	    new Float:x, Float:y, Float:z, Float:angle, Float:health, string[29 + (MAX_PLAYER_NAME * 2)];
	    GetVehicleHealth(vehicleid, health);
     	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessageEx(playerid, COLOR_GREY, "Ban phai ngoi o nghe lai xe.");
     	if(health < 800) return SendClientMessageEx(playerid, COLOR_GREY, " Xe cua ban da bi hu hong qua nang de dau xe.");
		if(ownerid != INVALID_PLAYER_ID)
	    {
			GetVehiclePos(vehicleid, x, y, z);
			GetVehicleZAngle(vehicleid, angle);
			SurfingCheck(vehicleid);
			UpdatePlayerVehicleParkPosition(ownerid, d, x, y, z, angle, health, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
			IsPlayerEntering{playerid} = true;
			PutPlayerInVehicle(playerid, vehicleid, 0);
			SetPlayerArmedWeapon(playerid, 0);
			format(string, sizeof(string), "* %s da dau xe %s's.", GetPlayerNameEx(playerid), GetPlayerNameEx(ownerid));
		}
		else
		{
		    GetVehiclePos(vehicleid, x, y, z);
			GetVehicleZAngle(vehicleid, angle);
			SurfingCheck(vehicleid);
			UpdatePlayerVehicleParkPosition(playerid, d, x, y, z, angle, health, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
			IsPlayerEntering{playerid} = true;
			PutPlayerInVehicle(playerid, vehicleid, 0);
			SetPlayerArmedWeapon(playerid, 0);
			format(string, sizeof(string), "* %s da dau chiec xe cua ho tai day.", GetPlayerNameEx(playerid), GetPlayerNameEx(ownerid));
		}
		ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	}
	else
	{
	    SendClientMessage(playerid, COLOR_WHITE, "Xe khong dau thanh cong do ban di chuyen!");
	}
	return 1;
}

/*forward RevisionListHTTP(index, response_code, data[]);
public RevisionListHTTP(index, response_code, data[])
{
	ShowPlayerDialog(index, DIALOG_REVISION, DIALOG_STYLE_LIST, "Current Version: "SERVER_GM_TEXT" -- View full changes at http://dev.ng-gaming.net", data, "Close", "");
	return 1;
}*/

forward MoveTimerGate(gateid);
public MoveTimerGate(gateid)
{
	if(GateInfo[gateid][gTimer] != 0)
	{
		MoveDynamicObject(GateInfo[gateid][gGATE], GateInfo[gateid][gPosX], GateInfo[gateid][gPosY], GateInfo[gateid][gPosZ], GateInfo[gateid][gSpeed], GateInfo[gateid][gRotX], GateInfo[gateid][gRotY], GateInfo[gateid][gRotZ]);
		GateInfo[gateid][gStatus] = 0;
	}
	return 1;
}

forward CaptureTimerEx(point);
public CaptureTimerEx(point)
{
	new string[128];
	new fam;
	if (Points[point][TakeOverTimerStarted])
	{
		fam = Points[point][ClaimerTeam];
		if (Points[point][TakeOverTimer] > 0)
		{
			Points[point][TakeOverTimer]--;
			format(string, sizeof(string), "%s da co gang tiep nhan thanh cong %s cho %s, no se la cua ho sau %d phut nua!",
			Points[point][PlayerNameCapping], Points[point][Name], FamilyInfo[fam][FamilyName], Points[point][TakeOverTimer]);
			UpdateDynamic3DTextLabelText(Points[point][CaptureProccess], COLOR_YELLOW, string);
			PointCrashProtection(point);
		}
		else
		{
			Points[point][ClaimerTeam] = INVALID_PLAYER_ID;
			Points[point][TakeOverTimer] = 0;
			Points[point][TakeOverTimerStarted] = 0;
			Points[point][Announced] = 0;
			Points[point][CapCrash] = 0;
			Points[point][Vulnerable] = NEW_VULNERABLE+1;
			DestroyDynamic3DTextLabel(Points[point][CaptureProccess]);
			Points[point][CaptureProccessEx] = 0;
			strmid(Points[point][Owner], FamilyInfo[fam][FamilyName], 0, 32, 32);
			strmid(Points[point][CapperName], Points[point][PlayerNameCapping], 0, 32, 32);
			format(string, sizeof(string), "%s da thanh cong viec kiem soat %s cho %s.", Points[point][CapperName], Points[point][Name], Points[point][Owner]);
			SendClientMessageToAllEx(COLOR_YELLOW, string);
			UpdatePoints();
			PointCrashProtection(point);
			KillTimer(Points[point][CaptureTimerEx2]);
			Points[point][CaptureTimerEx2] = -1;
		}
	}
}

forward StopMusic();
public StopMusic()
{
	foreach(new i: Player)
	{
		PlayerPlaySound(i, 1069, 0.0, 0.0, 0.0);
	}
}

forward PlayerFixRadio2();
public PlayerFixRadio2()
{
	foreach(new i: Player)
	{
		if(Fixr[i])
		{
			PlayerPlaySound(i, 1069, 0.0, 0.0, 0.0);
			Fixr[i] = 0;
		}
	}
}

forward Float: GetDistanceToCar(playerid, veh);
public Float: GetDistanceToCar(playerid, veh) {

	new
		Float: fVehiclePos[3];

	GetVehiclePos(veh, fVehiclePos[0], fVehiclePos[1], fVehiclePos[2]);
	return GetPlayerDistanceFromPoint(playerid, fVehiclePos[0], fVehiclePos[1], fVehiclePos[2]);
}


forward Float: vehicle_get_speed(vehicleid);
public Float: vehicle_get_speed(vehicleid)
{
	new
		Float: fVelocity[3];

	GetVehicleVelocity(vehicleid, fVelocity[0], fVelocity[1], fVelocity[2]);
	return floatsqroot((fVelocity[0] * fVelocity[0]) + (fVelocity[1] * fVelocity[1]) + (fVelocity[2] * fVelocity[2])) * 100;
}

// Float:GetDistanceBetweenPlayers(iPlayerOne, iPlayerTwo)
// {
// 	new
// 		Float: fPlayerPos[3];

// 	GetPlayerPos(iPlayerOne, fPlayerPos[0], fPlayerPos[1], fPlayerPos[2]);
// 	return GetPlayerDistanceFromPoint(iPlayerTwo, fPlayerPos[0], fPlayerPos[1], fPlayerPos[2]);
// }

// This needs to be tested! - Akatony
forward Float: player_get_speed(playerid);
public Float: player_get_speed(playerid)
{
	new
		Float: fVelocity[3];

	GetVehicleVelocity(GetPlayerVehicleID(playerid), fVelocity[0], fVelocity[1], fVelocity[2]);
	return floatsqroot((fVelocity[0] * fVelocity[0]) + (fVelocity[1] * fVelocity[1]) + (fVelocity[2] * fVelocity[2])) * 100;
}

forward Float: GetDistance( Float: x1, Float: y1, Float: z1, Float: x2, Float: y2, Float: z2 );
public Float: GetDistance( Float: x1, Float: y1, Float: z1, Float: x2, Float: y2, Float: z2 )
{
	new Float:d;
	d += floatpower(x1-x2, 2.0 );
	d += floatpower(y1-y2, 2.0 );
	d += floatpower(z1-z2, 2.0 );
	d = floatsqroot(d);
	IsInRangeOfPoint(5, 5, 5, 6, 6, 6, 10.0);
	return d;
}


forward UpdateCarRadars();
public UpdateCarRadars()
{
	foreach(new p : Player)
	{
		if (!IsPlayerConnected(p) || !IsPlayerInAnyVehicle(p) || CarRadars[p] == 0) continue;

		new target = -1;
		new Float:tempDist = 50.0;

		if(CarRadars[p] == 1)
		{
			foreach(new t : Player)
			{
				if (!IsPlayerInAnyVehicle(t) || t == p || IsPlayerInVehicle(t, GetPlayerVehicleID(p))) continue;

				new Float:distance = GetDistanceBetweenPlayers(p, t);

				if (distance < tempDist)
				{
					target = t;
					tempDist = distance;
				}
			}

			if (target == -1)
			{
				// no target was found
				PlayerTextDrawSetString(p, _crTextTarget[p], "Target Vehicle: ~r~N/A");
				PlayerTextDrawSetString(p, _crTextSpeed[p], "Toc do: ~r~N/A");
				PlayerTextDrawSetString(p, _crTickets[p], "Ve phat: ~r~N/A");
			}
			else
			{
				new targetVehicle = GetPlayerVehicleID(target);
				new Float: speed = player_get_speed(target);

				new str[60];


				format(str, sizeof(str), "Target Vehicle: ~r~%s (%i)", GetVehicleName(targetVehicle), targetVehicle);
				PlayerTextDrawSetString(p, _crTextTarget[p], str);
				format(str, sizeof(str), "Toc do: ~r~%d MPH", floatround(speed, floatround_round));
				PlayerTextDrawSetString(p, _crTextSpeed[p], str);
				foreach(new i : Player)
				{
					new veh = GetPlayerVehicle(i, targetVehicle);
					if (veh != -1 && PlayerVehicleInfo[i][veh][pvTicket] > 0)
					{
						format(str, sizeof(str), "Ve phat: ~r~$%s", number_format(PlayerVehicleInfo[i][veh][pvTicket]));
						PlayerTextDrawSetString(p, _crTickets[p], str);
						if (gettime() >= (GetPVarInt(p, "_lastTicketWarning") + 10))
						{
							SetPVarInt(p, "_lastTicketWarning", gettime());
							PlayerPlaySound(p, 4202, 0.0, 0.0, 0.0);
						}
					}
				}
			}
		}
	}
}

forward WateringStation(playerid);
public WateringStation(playerid)
{
    if(GetPVarInt(playerid, "EventToken") == 1 && GetPVarInt(playerid, "InWaterStationRCP") == 1)
	{
	    if(PlayerInfo[playerid][pHydration] < 100) {
	    	PlayerInfo[playerid][pHydration] += 4;
		} else {
			KillTimer(GetPVarInt(playerid, "WSRCPTimerId"));
	    	SetPVarInt(playerid, "WSRCPTimerId", 0);
     		SetPVarInt(playerid, "InWaterStationRCP", 0);
     		RCPIdCurrent[playerid]++;
     		if(EventRCPT[RCPIdCurrent[playerid]] == 1) {
	    	    DisablePlayerCheckpoint(playerid);
				SetPlayerCheckpoint(playerid, EventRCPX[RCPIdCurrent[playerid]], EventRCPY[RCPIdCurrent[playerid]], EventRCPZ[RCPIdCurrent[playerid]], EventRCPS[RCPIdCurrent[playerid]]);
			}
			else if(EventRCPT[RCPIdCurrent[playerid]] == 4) {
		   		DisablePlayerCheckpoint(playerid);
		    	SetPlayerCheckpoint(playerid, EventRCPX[RCPIdCurrent[playerid]], EventRCPY[RCPIdCurrent[playerid]], EventRCPZ[RCPIdCurrent[playerid]], EventRCPS[RCPIdCurrent[playerid]]);
			} else {
			    DisablePlayerCheckpoint(playerid);
			    SetPlayerCheckpoint(playerid, EventRCPX[RCPIdCurrent[playerid]], EventRCPY[RCPIdCurrent[playerid]], EventRCPZ[RCPIdCurrent[playerid]], EventRCPS[RCPIdCurrent[playerid]]);
			}
			SendClientMessageEx(playerid, COLOR_WHITE, "You are now fully rehydrated you can continue to your next checkpoint.");
		}
	} else {
        KillTimer(GetPVarInt(playerid, "WSRCPTimerId"));
	}
}


forward FinishMaintenance();
public FinishMaintenance()
{
	ABroadCast(COLOR_YELLOW, "{AA3333}Maintenance{FFFF00}: Force Saving Safe Zones...", 1);
	SaveSafeZones();
    ABroadCast(COLOR_YELLOW, "{AA3333}Bao tri{FFFF00}: Force Saving Houses...", 1);
	SaveHouses();
	ABroadCast(COLOR_YELLOW, "{AA3333}Bao tri{FFFF00}: Force Saving Dynamic Doors...", 1);
	SaveDynamicDoors();
	ABroadCast(COLOR_YELLOW, "{AA3333}Bao tri{FFFF00}: Force Saving Map Icons...", 1);
	SaveDynamicMapIcons();
	ABroadCast(COLOR_YELLOW, "{AA3333}Bao tri{FFFF00}: Force Saving Gates...", 1);
	SaveGates();
	ABroadCast(COLOR_YELLOW, "{AA3333}Bao tri{FFFF00}: Force Saving Event Points...", 1);
	SaveEventPoints();
	ABroadCast(COLOR_YELLOW, "{AA3333}Bao tri{FFFF00}: Force Saving Paintball...", 1);
	SavePaintballArenas();
	ABroadCast(COLOR_YELLOW, "{AA3333}Bao tri{FFFF00}: Force Saving Server Configuration", 1);
    Misc_Save();
    ABroadCast(COLOR_YELLOW, "{AA3333}Bao tri{FFFF00}: Force Saving Office Elevator...", 1);
	SaveElevatorStuff();
	ABroadCast(COLOR_YELLOW, "{AA3333}Bao tri{FFFF00}: Force Saving Mail Boxes...", 1);
	SaveMailboxes();
	ABroadCast(COLOR_YELLOW, "{AA3333}Bao tri{FFFF00}: Force Saving Plants...", 1);
	SavePlants();
	ABroadCast(COLOR_YELLOW, "{AA3333}Bao tri{FFFF00}: Force Saving Speed Cameras...", 1);
	SaveSpeedCameras();
	ABroadCast(COLOR_YELLOW, "{AA3333}Bao tri{FFFF00}: Streamer Plugin Shutting Down...", 1);
	DestroyAllDynamicObjects();
	DestroyAllDynamic3DTextLabels();
	DestroyAllDynamicCPs();
	DestroyAllDynamicMapIcons();
	DestroyAllDynamicRaceCPs();
	DestroyAllDynamicAreas();
	SetTimer("ShutDown", 120000, false);
	return 1;
}

forward ShutDown();
public ShutDown()
{
	return SendRconCommand("exit");
}

stock CheckXP(nextlevel)
{
	new completed = 0;
	if(nextlevel > 0)
	{
		return nextlevel;
	}
	else
	{
		return completed;
	}
}

stock XoaXeEvent()
{
	for(new i = 0; i < sizeof(EventCars); i++)
	{
        if(EventCars[i] != INVALID_VEHICLE_ID)
		{
            DestroyVehicle(EventCars[i]);
            EventCars[i] = INVALID_VEHICLE_ID;
        }
    }
	return 1;
}

stock XoaXeEventAlone(playerid)
{
    new vehicleid = GetPlayerVehicleID(playerid);
    SetPVarInt(playerid, "XeChuanBiXoa", vehicleid);
    SetTimerEx("XoaXeNguoiChoiE", 5000, 0, "d", playerid);
	return 1;
}

forward XoaXeNguoiChoiE(playerid);
public XoaXeNguoiChoiE(playerid)
{
    DestroyVehicle(EventCars[GetPVarInt(playerid, "XeChuanBiXoa")]);
    EventCars[GetPVarInt(playerid, "XeChuanBiXoa")] = INVALID_VEHICLE_ID;
}

stock IsRefuelableVehicle(vehicleid)
{
	new modelid = GetVehicleModel(vehicleid);
	switch (modelid)
	{
		case 481, 509, 510: return 0; // Bikes
		//case 457, 530: return 0; // Electric (Caddy, Forklift)
	}
	return 1;
}

stock SetVehicleTireState(vehicleid, tire1, tire2, tire3, tire4)
{
    new panels, doors, Lights, tires;
   	GetVehicleDamageStatus(vehicleid, panels, doors, Lights, tires);
    tires = encode_tires(!tire1, !tire2, !tire3, !tire4);
    UpdateVehicleDamageStatus(vehicleid, panels, doors, Lights, tires);
}
stock CheckPlayerDistanceToVehicle(Float:radi, playerid, vehicleid)
{
	if(IsPlayerConnected(playerid))
	{
	    new Float:PX, Float:PY, Float:PZ, Float:X, Float:Y, Float:Z;
	    GetPlayerPos(playerid, PX, PY, PZ);
	    GetVehiclePos(vehicleid, X, Y, Z);
	    new Float:ddd = (X - PX) * (X - PX) + (Y - PY) * (Y - PY) + (Z - PZ) * (Z - PZ);
	    if(ddd <= radi * radi)
	    {
	        if (GetPlayerVirtualWorld(playerid) == GetVehicleVirtualWorld(vehicleid))
	        {
	        	return 1;
			}
	    }
	}
	return 0;
}
stock GetVehicleTireState(vehicleid, &tire1, &tire2, &tire3, &tire4)
{
    new panels, doors, Lights, tires;
   	GetVehicleDamageStatus(vehicleid, panels, doors, Lights, tires);
    tire1 = !(tires >> 0 & 0x1);
	tire2 = !(tires >> 1 & 0x1);
	tire3 = !(tires >> 2 & 0x1);
	tire4 = !(tires >> 3 & 0x1);
}
forward Float:GetDistanceBetweenPoints(Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2);
stock Float:GetDistanceBetweenPoints(Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2) 
{
    return floatsqroot(floatpower(x1 - x2, 2) + floatpower(y1 - y2, 2) + floatpower(z1 - z2, 2));
}

stock ClearMarriage(playerid)
{
	if(IsPlayerConnected(playerid)) {
		new string[MAX_PLAYER_NAME];
		format(string, sizeof(string), "Nobody");
		strmid(PlayerInfo[playerid][pMarriedName], string, 0, strlen(string), MAX_PLAYER_NAME);
		PlayerInfo[playerid][pMarriedID] = -1;
	}
	return 1;
}

stock ClearHouse(houseid) {
	HouseInfo[houseid][hOwned] = 0;
	HouseInfo[houseid][hSafeMoney] = 0;
	HouseInfo[houseid][hPot] = 0;
	HouseInfo[houseid][hCrack] = 0;
	HouseInfo[houseid][hMaterials] = 0;
	HouseInfo[houseid][hHeroin] = 0;
	HouseInfo[houseid][hWeapons][0] = 0;
	HouseInfo[houseid][hWeapons][1] = 0;
	HouseInfo[houseid][hWeapons][2] = 0;
	HouseInfo[houseid][hWeapons][3] = 0;
	HouseInfo[houseid][hWeapons][4] = 0;
	HouseInfo[houseid][hGLUpgrade] = 1;
	HouseInfo[houseid][hClosetX] = 0.0;
	HouseInfo[houseid][hClosetY] = 0.0;
	HouseInfo[houseid][hClosetZ] = 0.0;
	DestroyDynamic3DTextLabel(Text3D:HouseInfo[houseid][hClosetTextID]);
}

stock ClearHouseMailbox(houseid)
{
	HouseInfo[houseid][hMailX] = 0.0;
	HouseInfo[houseid][hMailY] = 0.0;
	HouseInfo[houseid][hMailZ] = 0.0;
	HouseInfo[houseid][hMailA] = 0.0;
	HouseInfo[houseid][hMailType] = 0;
	SaveHouse(houseid);
}

stock ClearStreetMailbox(boxid)
{
	MailBoxes[boxid][mbVW] = 0;
	MailBoxes[boxid][mbInt] = 0;
	MailBoxes[boxid][mbModel] = 0;
	MailBoxes[boxid][mbPosX] = 0.0;
	MailBoxes[boxid][mbPosY] = 0.0;
	MailBoxes[boxid][mbPosZ] = 0.0;
	MailBoxes[boxid][mbAngle] = 0.0;
	SaveMailbox(boxid);
}

stock ClearFamily(family)
{
	foreach(new i: Player)
	{
		if(PlayerInfo[i][pFMember] == family) {
			SendClientMessageEx(i, COLOR_LIGHTBLUE, "* Family cua ban da bi xoa boi mot Admin, ban da tu dong bi duoi ra khoi family.");
			PlayerInfo[i][pFMember] = INVALID_FAMILY_ID;
		}
	}

	new string[MAX_PLAYER_NAME];
	format(string, sizeof(string), "None");
	FamilyInfo[family][FamilyTaken] = 0;
	strmid(FamilyInfo[family][FamilyName], string, 0, strlen(string), 255);
	strmid(FamilyMOTD[family][0], string, 0, strlen(string), 128);
	strmid(FamilyMOTD[family][1], string, 0, strlen(string), 128);
	strmid(FamilyMOTD[family][2], string, 0, strlen(string), 128);
	strmid(FamilyInfo[family][FamilyLeader], string, 0, strlen(string), 255);
	format(string, sizeof(string), "Newb");
	strmid(FamilyRankInfo[family][0], string, 0, strlen(string), 30);
	format(string, sizeof(string), "Outsider");
	strmid(FamilyRankInfo[family][1], string, 0, strlen(string), 30);
	format(string, sizeof(string), "Associate");
	strmid(FamilyRankInfo[family][2], string, 0, strlen(string), 30);
	format(string, sizeof(string), "Soldier");
	strmid(FamilyRankInfo[family][3], string, 0, strlen(string), 30);
	format(string, sizeof(string), "Capo");
	strmid(FamilyRankInfo[family][4], string, 0, strlen(string), 30);
	format(string, sizeof(string), "Underboss");
	strmid(FamilyRankInfo[family][5], string, 0, strlen(string), 30);
	format(string, sizeof(string), "Godfather");
	strmid(FamilyRankInfo[family][6], string, 0, strlen(string), 30);
	format(string, sizeof(string), "None");
	strmid(FamilyDivisionInfo[family][0], string, 0, 16, 30);
	strmid(FamilyDivisionInfo[family][1], string, 0, 16, 30);
	strmid(FamilyDivisionInfo[family][2], string, 0, 16, 30);
	strmid(FamilyDivisionInfo[family][3], string, 0, 16, 30);
	strmid(FamilyDivisionInfo[family][4], string, 0, 16, 30);
	FamilyInfo[family][FamilyColor] = 0;
	FamilyInfo[family][FamilyTurfTokens] = 24;
	FamilyInfo[family][FamilyMembers] = 0;
	FamilyInfo[family][FamilySpawn][0] = 0.0;
	FamilyInfo[family][FamilySpawn][1] = 0.0;
	FamilyInfo[family][FamilySpawn][2] = 0.0;
	FamilyInfo[family][FamilySpawn][3] = 0.0;
    FamilyInfo[family][FamilyGuns][0] = 0;
    FamilyInfo[family][FamilyGuns][2] = 0;
    FamilyInfo[family][FamilyGuns][3] = 0;
    FamilyInfo[family][FamilyGuns][4] = 0;
    FamilyInfo[family][FamilyGuns][5] = 0;
    FamilyInfo[family][FamilyGuns][6] = 0;
    FamilyInfo[family][FamilyGuns][7] = 0;
	FamilyInfo[family][FamilyGuns][8] = 0;
	FamilyInfo[family][FamilyGuns][9] = 0;
	FamilyInfo[family][FamilyCash] = 0;
	FamilyInfo[family][FamilyMats] = 0;
	FamilyInfo[family][FamilyHeroin] = 0;
	FamilyInfo[family][FamilyPot] = 0;
	FamilyInfo[family][FamilyCrack] = 0;
	FamilyInfo[family][FamilySafe][0] = 0.0;
	FamilyInfo[family][FamilySafe][1] = 0.0;
	FamilyInfo[family][FamilySafe][2] = 0.0;
	FamilyInfo[family][FamilySafeVW] = 0;
	FamilyInfo[family][FamilySafeInt] = 0;
	FamilyInfo[family][FamilyUSafe] = 0;
	DestroyDynamicPickup( FamilyInfo[family][FamilyEntrancePickup] );
	DestroyDynamicPickup( FamilyInfo[family][FamilyExitPickup] );
	DestroyDynamic3DTextLabel( Text3D:FamilyInfo[family][FamilyEntranceText] );
	DestroyDynamic3DTextLabel( Text3D:FamilyInfo[family][FamilyExitText] );
	DestroyDynamicPickup( FamilyInfo[family][FamilyPickup] );
	SaveFamilies();
	return 1;
}

stock FishCost(playerid, fish)
{
	if(IsPlayerConnected(playerid)) {
		new cost = 0;
		switch (fish)
		{
			case 1:
			{
				cost = 1;
			}
			case 2:
			{
				cost = 3;
			}
			case 3:
			{
				cost = 3;
			}
			case 5:
			{
				cost = 5;
			}
			case 6:
			{
				cost = 2;
			}
			case 8:
			{
				cost = 8;
			}
			case 9:
			{
				cost = 12;
			}
			case 11:
			{
				cost = 9;
			}
			case 12:
			{
				cost = 7;
			}
			case 14:
			{
				cost = 12;
			}
			case 15:
			{
				cost = 9;
			}
			case 16:
			{
				cost = 7;
			}
			case 17:
			{
				cost = 7;
			}
			case 18:
			{
				cost = 10;
			}
			case 19:
			{
				cost = 4;
			}
			case 21:
			{
				cost = 3;
			}
		}
		return cost;
	}
	return 0;
}

stock ClearFishes(playerid)
{
	if(IsPlayerConnected(playerid)) {
		Fishes[playerid][pFid1] = 0; Fishes[playerid][pFid2] = 0; Fishes[playerid][pFid3] = 0;
		Fishes[playerid][pFid4] = 0; Fishes[playerid][pFid5] = 0;
		Fishes[playerid][pWeight1] = 0; Fishes[playerid][pWeight2] = 0; Fishes[playerid][pWeight3] = 0;
		Fishes[playerid][pWeight4] = 0; Fishes[playerid][pWeight5] = 0;

		new string[MAX_PLAYER_NAME];
		format(string, sizeof(string), "None");
		strmid(Fishes[playerid][pFish1], string, 0, strlen(string), 255);
		strmid(Fishes[playerid][pFish2], string, 0, strlen(string), 255);
		strmid(Fishes[playerid][pFish3], string, 0, strlen(string), 255);
		strmid(Fishes[playerid][pFish4], string, 0, strlen(string), 255);
		strmid(Fishes[playerid][pFish5], string, 0, strlen(string), 255);
	}
	return 1;
}
stock UserPath(playerid)
{
	new string[128],playername[MAX_PLAYER_NAME];
	GetPlayerName(playerid,playername,sizeof(playername));
	format(string,sizeof(string),PATH,playername);
	return string;
}
stock ClearFishID(playerid, fish)
{
	if(IsPlayerConnected(playerid))
	{
		new string[MAX_PLAYER_NAME];
		format(string, sizeof(string), "None");
		switch (fish)
		{
			case 1:
			{
				strmid(Fishes[playerid][pFish1], string, 0, strlen(string), 255);
				Fishes[playerid][pWeight1] = 0;
				Fishes[playerid][pFid1] = 0;
			}
			case 2:
			{
				strmid(Fishes[playerid][pFish2], string, 0, strlen(string), 255);
				Fishes[playerid][pWeight2] = 0;
				Fishes[playerid][pFid2] = 0;
			}
			case 3:
			{
				strmid(Fishes[playerid][pFish3], string, 0, strlen(string), 255);
				Fishes[playerid][pWeight3] = 0;
				Fishes[playerid][pFid3] = 0;
			}
			case 4:
			{
				strmid(Fishes[playerid][pFish4], string, 0, strlen(string), 255);
				Fishes[playerid][pWeight4] = 0;
				Fishes[playerid][pFid4] = 0;
			}
			case 5:
			{
				strmid(Fishes[playerid][pFish5], string, 0, strlen(string), 255);
				Fishes[playerid][pWeight5] = 0;
				Fishes[playerid][pFid5] = 0;
			}
		}
	}
	return 1;
}

stock BubbleSort(a[], size)
{
	new tmp=0, bool:swapped;

	do
	{
		swapped = false;
		for(new i=1; i < size; i++) {
			if(a[i-1] > a[i]) {
				tmp = a[i];
				a[i] = a[i-1];
				a[i-1] = tmp;
				swapped = true;
			}
		}
	} while(swapped);
}

stock SendClientMessageEx(playerid, color, string[])
{
	if(InsideMainMenu{playerid} == 1 || InsideTut{playerid} == 1 || ActiveChatbox[playerid] == 0)
		return 0;

	else SendClientMessage(playerid, color, string);
	return 1;
}

stock SendClientMessageToAllEx(color, string[])
{
	foreach(new i: Player)
	{
		if(InsideMainMenu{i} == 1 || InsideTut{i} == 1 || ActiveChatbox[i] == 0) {}
		else SendClientMessage(i, color, string);
	}
	return 1;
}

stock SendClientMessageWrap(playerid, color, width, string[])
{
	if(strlen(string) > width)
	{
		new firstline[128], secondline[128];
		strmid(firstline, string, 0, 88);
		strmid(secondline, string, 88, 128);
		format(firstline, sizeof(firstline), "%s...", firstline);
		format(secondline, sizeof(secondline), "...%s", secondline);
		SendClientMessageEx(playerid, color, firstline);
		SendClientMessageEx(playerid, color, secondline);
	}

	else SendClientMessageEx(playerid, color, string);
}

stock ShowMainMenuDialog(playerid, frame)
{
	new titlestring[64];
	new string[512];

	switch(frame)
	{
		case 1:
		{
			format(string, sizeof(string), "{B4B5B7}Ten tai khoan: %s\n\nDia chi IP: %s\n\nLan cuoi dang nhap luc: %s\n\nThoi gian tao tai khoan: %s\n\nTai khoan cua ban da duoc dang ky, xin nhap mat khau de dang nhap:", GetPlayerNameEx(playerid), GetPlayerIpEx(playerid),PlayerInfo[playerid][LastLogin],PlayerInfo[playerid][RegiDate]);
			ShowPlayerDialog(playerid,MAINMENU,DIALOG_STYLE_PASSWORD,"Dang nhap tai khoan",string,"Dang Nhap","Thoat");
			SetPlayerCameraPos(playerid, 2301.3403, -1301.3948, 52.4688);
			SetPlayerCameraLookAt(playerid, 2300.3408, -1301.4949, 52.1188);
			SetPlayerPos(playerid, 2234.2881,-1329.2982,24.5313);
			SetPlayerVirtualWorld(playerid, 0);
			PlayerInfo[playerid][pVW] = 0;
		}
		case 2:
		{
			format(string, sizeof(string), "{B4B5B7}Chao mung ban den voi may chu, %s.\n\nDia chi IP: %s\n\nTai khoan chua duoc dang ky , hay nhap mat khau de dang ky:", GetPlayerNameEx(playerid), GetPlayerIpEx(playerid));
			ShowPlayerDialog(playerid,MAINMENU2,DIALOG_STYLE_PASSWORD,"Dang Ki tai khoan",string,"Dang ki","Thoat");
			SetPlayerCameraPos(playerid, 2183.9360, -1748.5735, 57.1525);
			SetPlayerCameraLookAt(playerid, 2182.9751, -1748.8673, 56.6776);
			SetPlayerPos(playerid, 2151.0425,-1786.4374,13.5093);
			SetPlayerVirtualWorld(playerid, 0);
			PlayerInfo[playerid][pVW] = 0;
		}
		case 3:
		{
			format(string, sizeof(string), "{c94848}Mat khau ban vua nhap khong chinh xac, hay kiem tra lai!{B4B5B7}\n\nTen tai khoan: %s\n\nDia chi IP: %s\n\nLan cuoi dang nhap luc: %s\n\nThoi gian tao tai khoan: %s\n\nTai khoan cua ban da duoc dang ky, xin nhap mat khau de dang nhap:", GetPlayerNameEx(playerid), GetPlayerIpEx(playerid),PlayerInfo[playerid][LastLogin],PlayerInfo[playerid][RegiDate]);
			ShowPlayerDialog(playerid,MAINMENU,DIALOG_STYLE_PASSWORD,"Loi dang nhap",string,"Dang nhap","Thoat");
			SetPlayerCameraPos(playerid, 2301.3403, -1301.3948, 52.4688);
			SetPlayerCameraLookAt(playerid, 2300.3408, -1301.4949, 52.1188);
			SetPlayerPos(playerid, 2234.2881,-1329.2982,24.5313);
			SetPlayerVirtualWorld(playerid, 0);
			PlayerInfo[playerid][pVW] = 0;
		}
		case 4:
		{
			format(titlestring, sizeof(titlestring), "{3399FF}Tai khoan dang tham gia - %s", GetPlayerNameEx(playerid));
			format(string, sizeof(string), "{FFFFFF}Co so du lieu cua chung toi chi ra rang %s hien dang dang nhap, neu khong phai la ban vui long lien he mot quan tri administrator de duoc giai quyet.", GetPlayerNameEx(playerid));
			ShowPlayerDialog(playerid,MAINMENU3,DIALOG_STYLE_MSGBOX,titlestring,string,"Thoat","");
			SetPlayerCameraPos(playerid, 2301.3403, -1301.3948, 52.4688);
			SetPlayerCameraLookAt(playerid, 2300.3408, -1301.4949, 52.1188);
			SetPlayerPos(playerid, 2234.2881,-1329.2982,24.5313);
			SetPlayerVirtualWorld(playerid, 0);
			PlayerInfo[playerid][pVW] = 0;
		}
	}
}
stock SafeLogin(playerid, type)
{
	switch(type)
	{
		case 1: // Account Exists
		{

		    new string[229], ip[32];
			GetPlayerIp(playerid, ip, 32);
			format(string,sizeof (string),"{b4b4b4}Last Login: %s (%s)\nVui long nhap mat khau de dang nhap:",MasterInfo[playerid][acc_lastlogin],ip);
			ShowPlayerDialog(playerid,DANGNHAP,DIALOG_STYLE_PASSWORD,"Login",string,"Dang nhap","Thoat");
			SetPlayerCameraPos(playerid, 1527.1915, -1388.5413, 405.3455);
			SetPlayerCameraLookAt(playerid, 1527.1210, -1389.5367, 403.4106);
			SetPlayerPos(playerid, 1535.3447,-1357.3451,329.4568);
		}
		case 2: // No Account Exists
		{
			SendErrorMessage(playerid, " Truy cap https://lsrp.vn/ de dang ky tai khoan va tao nhan vat.");
		    new string[229],ip[32];
		    GetPlayerIp(playerid, ip, 32);
		    ShowPlayerDialog(playerid,DANGKY,DIALOG_STYLE_PASSWORD,"Register","{b4b4b4}Tai khoan ban chua dang ky, hay nhap mat khau de dang ky:","Dang ky","Thoat");
		    SetPlayerCameraPos(playerid, 1527.1915, -1388.5413, 405.3455);
		    SetPlayerCameraLookAt(playerid, 1527.1210, -1389.5367, 403.4106);
		    SetPlayerPos(playerid, 1535.3447,-1357.3451,329.4568);
		}
	}
}
stock InvalidNameCheck(playerid) {

	new
		arrForbiddenNames[][] = {
			"com1", "com2", "com3", "com4",
			"com5", "com6", "com7", "com8",
			"com9", "lpt4", "lpt5", "lpt6",
			"lpt7", "lpt8", "lpt9", "nul",
			"clock$", "aux", "prn", "con",
			"ngg", "abc", "fuck", "dit",
			"cho", "role", "play", "sex",
			"InvalidNick"
	    };

	new i = 0;
	while(i < sizeof(arrForbiddenNames)) if(strcmp(arrForbiddenNames[i++], GetPlayerNameExt(playerid), true) == 0) {
		SetPlayerName(playerid, "InvalidNick");
		SendClientMessage(playerid, COLOR_RED, "Ban da bi kick khoi he thong vi su dung ten nguoi dung bi cam truy cap.");
		SetTimerEx("KickEx", 1000, 0, "i", playerid);
		return 0;

	}
	return 1;
}

stock Float: GetVehicleFuelCapacity(vehicleid)
{
	new Float: capacity;
	if (IsABike(vehicleid)) {
		capacity = 5.0;
	}
 	else {
	 	capacity = 20.00;
	}
	return capacity;
	//TODO optimise more
}

stock UpdateSANewsBroadcast()
{
    new string[42];
	if(broadcasting == 0)
	{
	    format(string, sizeof(string), "Hien tai: Khong phat song\nLuot xem: %d", viewers);
	}
	else
	{
	    format(string, sizeof(string), "Hien tai: TRUC TIEP\nLuot xem: %d", viewers);
	}
	UpdateDynamic3DTextLabelText(SANews3DText, COLOR_LIGHTBLUE, string);
}

stock RespawnNearbyVehicles(iPlayerID, Float: fRadius) {

	new
		Float: fPlayerPos[3];

    GetPlayerPos(iPlayerID, fPlayerPos[0], fPlayerPos[1], fPlayerPos[2]);
    for(new i = 1; i < MAX_VEHICLES; i++)
	{
		if(GetVehicleModel(i) && GetVehicleDistanceFromPoint(i, fPlayerPos[0], fPlayerPos[1], fPlayerPos[2]) <= fRadius && !IsVehicleOccupied(i))
		{
			if(DynVeh[i] != -1)
			{
			    DynVeh_Spawn(DynVeh[i]);
			    TruckDeliveringTo[i] = INVALID_BUSINESS_ID;
			}
			SetVehicleToRespawn(i);
		}
	}
	return 1;
}

stock IsVehicleOccupied(iVehicleID, iSeatID = 0) {
	foreach(new x : Player)
	{
		if(GetPlayerVehicleID(x) == iVehicleID && GetPlayerVehicleSeat(x) == iSeatID) {
			return 1;
		}
	}
	return 0;
}

stock IsVehicleInTow(iVehicleID) {
	foreach(new x : Player)
	{
		if(arr_Towing[x] == iVehicleID) {
			return 1;
		}
	}
	return 0;
}

stock FindFreeAttachedObjectSlot(playerid)
{
	new index;
 	while (index < MAX_PLAYER_ATTACHED_OBJECTS && IsPlayerAttachedObjectSlotUsed(playerid, index))
	{
		index++;
	}
	if (index == MAX_PLAYER_ATTACHED_OBJECTS) return -1;
	return index;
}

stock dini_Exists(filename[]) {
	return fexist(filename);
}

stock dini_Remove(filename[]) {
	return fremove(filename);
}

stock dini_Create(filename[]) {
	if (fexist(filename)) return false;
	new File:fhnd;
	fhnd=fopen(filename,io_write);
	if (fhnd) {
		fclose(fhnd);
		return true;
	}
	return false;
}

stock dini_Set(filename[],key[],value[]) {
	// If we have no key, it can't be set
	// we also have no chance to set the value, if all together is bigger then the max string
	new key_length = strlen(key);
	new value_length = strlen(value);
	if (key_length==0 || key_length+value_length+2>DINI_MAX_STRING) return false;

	new File:fohnd, File:fwhnd;
	new tmpres[DINI_MAX_STRING];
	new bool:wasset=false;

	// Let's remove the old *.part file if there was one.
	format(tmpres,sizeof(tmpres),"%s.part",filename);
	fremove(tmpres);

	// We'll open the source file.
	fohnd=fopen(filename,io_read);
	if (!fohnd) return false;

	fwhnd=fopen(tmpres,io_write);
	if (!fwhnd) {
		// we can't open the second file for writing, so .. let's close the open one and exit.
		fclose(fohnd);
		return false;
	}

	while (fread(fohnd,tmpres)) {
		if (
			!wasset
			&& tmpres[key_length]=='='
			&& !strcmp(tmpres, key, true, key_length)
		) {
				// We've got what needs to be replaced!
				format(tmpres,sizeof(tmpres),"%s=%s",key,value);
				wasset=true;
		} else {
			DINI_StripNewLine(tmpres);
		}
		fwrite(fwhnd,tmpres);
		fwrite(fwhnd,"\r\n");
	}

	if (!wasset) {
		format(tmpres,sizeof(tmpres),"%s=%s",key,value);
		fwrite(fwhnd,tmpres);
		fwrite(fwhnd,"\r\n");
	}

	fclose(fohnd);
	fclose(fwhnd);

	format(tmpres,sizeof(tmpres),"%s.part",filename);
	if (DINI_fcopytextfile(tmpres,filename)) {
		return fremove(tmpres);
	}
	return false;
}


stock dini_IntSet(filename[],key[],value) {
   new valuestring[DINI_MAX_STRING];
   format(valuestring,DINI_MAX_STRING,"%d",value);
   return dini_Set(filename,key,valuestring);
}

stock dini_Int(filename[],key[]) {
   return strval(dini_Get(filename,key));
}

stock dini_FloatSet(filename[],key[],Float:value) {
   new valuestring[DINI_MAX_STRING];
   format(valuestring,DINI_MAX_STRING,"%f",value);
   return dini_Set(filename,key,valuestring);
}

stock Float:dini_Float(filename[],key[]) {
   return floatstr(dini_Get(filename,key));
}

stock dini_Bool(filename[],key[]) {
   return strval(dini_Get(filename,key));
}

stock dini_BoolSet(filename[],key[],value) {
	if (value) {
		return dini_Set(filename,key,"1");
	}
	return dini_Set(filename,key,"0");
}

stock dini_Unset(filename[],key[]) {
	// If we have no key, it can't be set
	// we also have no chance to unset the key, if all together is bigger then the max string
	new key_length = strlen(key);
	if (key_length==0 || key_length+2>DINI_MAX_STRING) return false;

	new File:fohnd, File:fwhnd;
	new tmpres[DINI_MAX_STRING];

	// Let's remove the old *.part file if there was one.
	format(tmpres,DINI_MAX_STRING,"%s.part",filename);
	fremove(tmpres);

	// We'll open the source file.
	fohnd=fopen(filename,io_read);
	if (!fohnd) return false;

	fwhnd=fopen(tmpres,io_write);
	if (!fwhnd) {
		// we can't open the second file for writing, so .. let's close the open one and exit.
		fclose(fohnd);
		return false;
	}

	while (fread(fohnd,tmpres)) {
		if (
			tmpres[key_length]=='='
			&& !strcmp(tmpres, key, true, key_length)
		) {
				// We've got what needs to be removed!
		} else {
			DINI_StripNewLine(tmpres);
			fwrite(fwhnd,tmpres);
			fwrite(fwhnd,"\r\n");
		}
	}

	fclose(fohnd);
	fclose(fwhnd);

	format(tmpres,DINI_MAX_STRING,"%s.part",filename);
	if (DINI_fcopytextfile(tmpres,filename)) {
		return fremove(tmpres);
	}
	return false;
}

stock dini_Get(filename[],key[]) {
	new tmpres[DINI_MAX_STRING];

	new key_length = strlen(key);
	if (key_length==0 || key_length+2>DINI_MAX_STRING) return tmpres;

	new File:fohnd;
	fohnd=fopen(filename,io_read);
	if (!fohnd) return tmpres;

	while (fread(fohnd,tmpres)) {
		if (
			tmpres[key_length]=='='
			&& !strcmp(tmpres, key, true, key_length)
		) {
			/* We've got what we need */
			DINI_StripNewLine(tmpres);
			strmid(tmpres, tmpres, key_length + 1, strlen(tmpres), DINI_MAX_STRING);
			fclose(fohnd);
			return tmpres;
		}
	}
	fclose(fohnd);
	return tmpres;
}


stock dini_Isset(filename[],key[]) {
	new key_length = strlen(key);
	if (key_length==0 || key_length+2>DINI_MAX_STRING) return false;

	new File:fohnd;
	fohnd=fopen(filename,io_read);
	if (!fohnd) return false;

	new tmpres[DINI_MAX_STRING];
	while (fread(fohnd,tmpres)) {
		if (
				tmpres[key_length]=='='
			&&  !strcmp(tmpres, key, true, key_length)
		) {
			// We've got what we need
			fclose(fohnd);
			return true;
		}
	}
	fclose(fohnd);
	return false;
}



stock DINI_StripNewLine(string[]) {
	new len = strlen(string);
	if (string[0]==0) return ;
	if ((string[len - 1] == '\n') || (string[len - 1] == '\r')) {
		string[len - 1] = 0;
		if (string[0]==0) return ;
		if ((string[len - 2] == '\n') || (string[len - 2] == '\r')) string[len - 2] = 0;
	}
}

stock DINI_fcopytextfile(oldname[],newname[]) {
	new File:ohnd,File:nhnd;
	if (!fexist(oldname)) return false;
	ohnd=fopen(oldname,io_read);
	if (!ohnd) return false;
	nhnd=fopen(newname,io_write);
	if (!nhnd) {
		fclose(ohnd);
		return false;
	}
	new tmpres[DINI_MAX_STRING];
	while (fread(ohnd,tmpres)) {
		DINI_StripNewLine(tmpres);
		format(tmpres,sizeof(tmpres),"%s\r\n",tmpres);
		fwrite(nhnd,tmpres);
	}
	fclose(ohnd);
	fclose(nhnd);
	return true;
}
stock HideModelSelectionMenu(playerid)
{
	mS_DestroySelectionMenu(playerid);
	SetPVarInt(playerid, "mS_ignore_next_esc", 1);
	CancelSelectTextDraw(playerid);
	return 1;
}

stock mS_DestroySelectionMenu(playerid)
{
	if(GetPVarInt(playerid, "mS_list_active") == 1)
	{
		if(mS_GetPlayerCurrentListID(playerid) == mS_CUSTOM_LISTID)
		{
			DeletePVar(playerid, "mS_custom_Xrot");
			DeletePVar(playerid, "mS_custom_Yrot");
			DeletePVar(playerid, "mS_custom_Zrot");
			DeletePVar(playerid, "mS_custom_Zoom");
			DeletePVar(playerid, "mS_custom_extraid");
			DeletePVar(playerid, "mS_custom_item_amount");
		}
		DeletePVar(playerid, "mS_list_time");
		SetPVarInt(playerid, "mS_list_active", 0);
		mS_DestroyPlayerMPs(playerid);

		PlayerTextDrawDestroy(playerid, gHeaderTextDrawId[playerid]);
		PlayerTextDrawDestroy(playerid, gBackgroundTextDrawId[playerid]);
		PlayerTextDrawDestroy(playerid, gCurrentPageTextDrawId[playerid]);
		PlayerTextDrawDestroy(playerid, gNextButtonTextDrawId[playerid]);
		PlayerTextDrawDestroy(playerid, gPrevButtonTextDrawId[playerid]);
		PlayerTextDrawDestroy(playerid, gCancelButtonTextDrawId[playerid]);

		gHeaderTextDrawId[playerid] = PlayerText:INVALID_TEXT_DRAW;
		gBackgroundTextDrawId[playerid] = PlayerText:INVALID_TEXT_DRAW;
		gCurrentPageTextDrawId[playerid] = PlayerText:INVALID_TEXT_DRAW;
		gNextButtonTextDrawId[playerid] = PlayerText:INVALID_TEXT_DRAW;
		gPrevButtonTextDrawId[playerid] = PlayerText:INVALID_TEXT_DRAW;
		gCancelButtonTextDrawId[playerid] = PlayerText:INVALID_TEXT_DRAW;
	}
}
const

    // íàñògîéêè

    // GÅÊÎÌÅÍÄÓÅÒÑß ÈÇÌÅÍÈÒÜ ÏÎÄ ÑÅÁß
    INI_MAX_OPENED_FILES    = 2,        // ìàêñèìóì, îòêgûòûõ îäíîâgåìåííî, ôàéëîâ
    INI_MAX_FILE_SIZE       = 65536,    // áàéò,        ìàêñ. gàçìåg ôàéëà
    INI_MAX_FILENAME_SIZE   = 128,      // ñèìâîëîâ,    ìàêñ. gàçìåg ïóòè ê ôàéëó
    INI_MAX_KEYS_IN_FILE    = 255,     // ìàêñèìóì êës÷åé â îòêgûòîì ôàéëå

    // â ÎÇÓ áóäåò âûäåëåíî äëÿ âgåìåííîãî õgàíåíèÿ ôàéëîâ ïgèìågíî âîò ñòîëüêî áàéò:
    // INI_MAX_OPENED_FILES * ( INI_MAX_FILE_SIZE + INI_MAX_FILENAME_SIZE*4 + INI_MAX_KEYS_IN_FILE*4 )


    // ÍÅËÜÇß ÌÅÍßÒÜ
    INI_INTEGER_SIZE        = 12,       // gàçìåg ñògîêè ñ öåëî÷èñëåííûì çíà÷åíèåì
    INI_FLOAT_SIZE          = 40,       // gàçìåg ñògîêè ñ ägîáíûì ÷èñëîâûì çíà÷åíèåì

    INI_STRING_DELIMITER    = '\n',     // gàçäåëèòåëü ñògîê
    INI_DELIMITER           = '=',      // gàçäåëèòåëü êës÷à è çíà÷åíèÿ


    // êîäû îøèáîê, âîçâgàùàåìûå ôóíêöèÿìè

    // GÅÊÎÌÅÍÄÓÅÒÑß ÍÅ ÈÇÌÅÍßÒÜ
    INI_OK                  =  0,       // ôóíêöèÿ óñïåøíî âûïîëíåíà

        // ïgîâågÿòü íà îøèáêó ìîæíî òàê:
        // if ( âîçâgàùàåìîå_çíà÷åíèå_ôóíêöèè < 0 ) ...

    INI_FILE_NOT_FOUND      = -1,       // ôàéë íå íàéäåí ïî óêàçàííîìó ïóòè
    INI_FILE_ALREADY_EXIST  = -2,       // ôàéë íå íàéäåí ïî óêàçàííîìó ïóòè
    INI_TOO_LARGE_FILE      = -3,       // gàçìåg ôàéëà ïgåâûñèë äîïóñòèìûé ëèìèò
    INI_WRONG_PATH_SIZE     = -4,       // íåïgàâèëüíûé gàçìåg ïóòè ê ôàéëó
    INI_READ_ERROR          = -5,       // îøèáêà ÷òåíèÿ ôàéëà
    INI_WRITE_ERROR         = -6,       // îøèáêà ïgè çàïèñè â ôàéë
    INI_NO_FREE_SLOT        = -7,       // íåò ñâîáîäíîãî ñëîòà äëÿ îòêgûòèÿ ôàéëà
    INI_WRONG_SLOT          = -8,       // óêàçàí íåâågíûé ñëîò îòêgûòîãî ôàéëà
    INI_KEY_NOT_FOUND       = -9,       // êës÷ â îòêgûòîì ôàéëå íå íàéäåí
    INI_WRONG_RETURN_SIZE   = -10,      // gàçìåg ñògîêè, â êîòîgós áóäåò ïîìåùåíî çíà÷åíèå êës÷à - óêàçàí íåâågíî (<= 0)


    // ägóãèå âñïîìîãàòåëüíûå êîíñòàíòû

    // ÍÅËÜÇß ÌÅÍßÒÜ
    cellbytes = cellbits / charbits;    // êîë-âî áàéò â îäíîé ÿ÷åéêå





// ñïèñêè gàçíûõ ñèìâîëîâ äëÿ îïågàòîgà case â îäíîé èç ôóíêöèé

static stock



    _ini_nSlotUsed      [ INI_MAX_OPENED_FILES ],
    _ini_nFileChanged   [ INI_MAX_OPENED_FILES ],
    _ini_nFileBusy      [ INI_MAX_OPENED_FILES ],
    _ini_nFileSize      [ INI_MAX_OPENED_FILES ],
    _ini_nDelimPos      [ INI_MAX_OPENED_FILES ] [ INI_MAX_KEYS_IN_FILE ],
    _ini_nKeysCount     [ INI_MAX_OPENED_FILES ],
    _ini_szFilePath     [ INI_MAX_OPENED_FILES ] [ INI_MAX_FILENAME_SIZE ],
    _ini_szFileContent  [ INI_MAX_OPENED_FILES ] [ INI_MAX_FILE_SIZE char ];

stock ini_createFile ( szFilePath[], szDefaultContent[] = "" )
{
    //
    //  íåñêîëüêî áëîêîâ ñ ïgîâågêàìè
    //

    // ------------
    new nFileNameSize = strlen( szFilePath ); // óçíàåì gàçìåg ïóòè

    // åñëè gàçìåg ïóòè íåïgàâèëüíûé
    if ( nFileNameSize <= 0 || nFileNameSize >= INI_MAX_FILENAME_SIZE )
        return INI_WRONG_PATH_SIZE; // âågíåì êîä îøèáêè
    // ------------


    // ------------
    if ( fexist( szFilePath ) ) // åñëè ôàéë óæå ñóùåñòâóåò
        return INI_FILE_ALREADY_EXIST; // âågíåì êîä îøèáêè - ôàéë óæå ñóùåñòâóåò

    for ( new slot = 0; slot < INI_MAX_OPENED_FILES; slot++ ) // ïågåáîg âñåõ ñëîòîâ ÎÇÓ
        if // åñëè óæå åñòü òàêîé îòêgûòûé ôàéë
        (
                _ini_nSlotUsed[slot] != 0
            &&  strcmp( szFilePath, _ini_szFilePath[slot], false ) == 0
        )
            return INI_FILE_ALREADY_EXIST; // âågíåì êîä îøèáêè - ôàéë óæå ñóùåñòâóåò
    // ------------



    // ------------
    new nFileSize = strlen( szDefaultContent ); // óçíàåì gàçìåg êîíòåíòa ôàéëà ïî óìîë÷àíès

    // åñëè gàçìåg íåïgàâèëüíûé
    if ( nFileSize < 0 || nFileSize >= INI_MAX_FILE_SIZE )
        return INI_TOO_LARGE_FILE; // âågíåì êîä îøèáêè
    // ------------




    //
    //  ïîèñê ñâîáîäíîãî ñëîòà äëÿ çàïèñè â ÎÇÓ
    //

    for ( new slot = 0; slot < INI_MAX_OPENED_FILES; slot++ ) // ïågåáîg âñåõ ñëîòîâ ÎÇÓ
    {
        if ( _ini_nSlotUsed[slot] != 1 ) // åñëè ñëîò íàéäåí
        {
            // ------------
            _ini_nSlotUsed[slot]        = 1; // çàñòîëáèì íàéäåííîå ìåñòî
            _ini_nFileChanged[slot]     = 0; // ôàéë íå áûë èçìåíåí
            _ini_nFileSize[slot]        = nFileSize; // ñêîïègóåì gàçìåg ôàéëà â ñëîò
            _ini_nKeysCount[slot]       = 0; // êîë-âî êës÷åé âûñòàâèì 0
            // ------------


            // ------------
            // ñêîïègóåì â ÎÇÓ âåñü ôàéë,
            // çàïîìíèâ âñå ïîçèöèè INI_DELIMITER è èõ êîë-âî
            for ( new i = 0;  i < nFileSize && i < INI_MAX_FILE_SIZE;  i++ )
            {
                if (
                        szDefaultContent[i] == INI_DELIMITER // åñëè ñèìâîë iòî INI_DELIMITER
                    &&  _ini_nKeysCount[slot] < INI_MAX_KEYS_IN_FILE // è ëèìèò êës÷åé åùå íå èñ÷ågïàí
                ) {
                    _ini_nDelimPos[slot][ _ini_nKeysCount[slot] ] = i; // äîáàâèì åùå îäíó ïîçèöès INI_DELIMITER
                    _ini_nKeysCount[slot]++; // óâåëè÷èì êîë-âî íàéäåííûõ êës÷åé
                }

                _ini_szFileContent[slot]{i} = szDefaultContent[i];
            }

            _ini_szFileContent[slot]{nFileSize} = 0; // ñèìâîë êîíöà ñògîêè äëÿ êîíòåíòà
            // ------------


            // ------------
            // ñêîïègóåì â îçó ïóòü ê ôàéëó
            memcpy( _ini_szFilePath[slot], szFilePath, 0, nFileNameSize * cellbytes );

            _ini_szFilePath[slot][nFileNameSize] = 0; // ñèìâîë êîíöà ñògîêè äëÿ ïóòè
            // ------------


            return slot; // âågíåì ÈÄ ñëîòà
        }
    }




    //
    //  åñëè ñâîáîäíûé ñëîò â ïàìÿòè íå íàéäåí
    //

    return INI_NO_FREE_SLOT; // âågíåì êîä îøèáêè
    // ------------
}

stock ini_openFile ( szFilePath[] )
{
    //
    //  íåñêîëüêî áëîêîâ ñ ïgîâågêàìè
    //

    // ------------
    new nFileNameSize = strlen( szFilePath ); // óçíàåì gàçìåg ïóòè

    // åñëè gàçìåg ïóòè íåïgàâèëüíûé
    if ( nFileNameSize <= 0 || nFileNameSize >= INI_MAX_FILENAME_SIZE )
        return INI_WRONG_PATH_SIZE; // âågíåì êîä îøèáêè
    // ------------


    if ( ! fexist( szFilePath ) ) // åñëè ôàéë íå íàéäåí
        return INI_FILE_NOT_FOUND; // âågíåì êîä îøèáêè


    // ------------
    // ïgîâågêà - îòêgûò ëè óæå ôàéë ñ òàêèì èìåíåì
    for ( new slot = 0; slot < INI_MAX_OPENED_FILES; slot++ ) // ïågåáîg âñåõ ñëîòîâ ÎÇÓ
        if // åñëè óæå åñòü òàêîé îòêgûòûé ôàéë
        (
                _ini_nSlotUsed[slot] != 0
            &&  strcmp( szFilePath, _ini_szFilePath[slot], false ) == 0
        )
            return slot; // ïgîñòî âågíåì åãî ñëîò
    // ------------


    // ------------
    new File: pFile = fopen( szFilePath, io_read ); // ïûòàåìñÿ îòêgûòü ôàéë äëÿ ÷òåíèÿ

    if ( ! pFile ) // åñëè ôàéë íå îòêgûëñÿ
        return INI_READ_ERROR; // âågíåì êîä îøèáêè
    // ------------


    // ------------
    new nFileSize = flength( pFile ); // óçíàåì gàçìåg ôàéëà

    if ( nFileSize >= INI_MAX_FILE_SIZE ) // åñëè gàçìåg ôàéëà ñëèøêîì áîëüøîé
    {
        fclose(pFile); // çàêgîåì ôàéë
        return INI_TOO_LARGE_FILE; // âågíåì êîä îøèáêè
    }
    // ------------




    //
    //  ïîèñê ñâîáîäíîãî ñëîòà äëÿ çàïèñè â ÎÇÓ
    //

    // ------------
    for ( new slot = 0; slot < INI_MAX_OPENED_FILES; slot++ ) // ïågåáîg âñåõ ñëîòîâ ÎÇÓ
    {
        if ( _ini_nSlotUsed[slot] != 1 ) // åñëè ñëîò íàéäåí
        {
            // ------------
            _ini_nSlotUsed[slot]        = 1; // çàñòîëáèì íàéäåííîå ìåñòî
            _ini_nFileChanged[slot]     = 0; // ôàéë íå áûë èçìåíåí
            _ini_nFileSize[slot]        = nFileSize; // ñêîïègóåì gàçìåg ôàéëà â ñëîò
            _ini_nKeysCount[slot]       = 0; // êîë-âî êës÷åé âûñòàâèì 0
            // ------------


            // ------------
            // ñêîïègóåì â ÎÇÓ âåñü ôàéë,
            // çàïîìíèâ âñå ïîçèöèè INI_DELIMITER è èõ êîë-âî
            for ( new i = 0, symbol; i < nFileSize && i < INI_MAX_FILE_SIZE; i++ )
            {
                symbol = fgetchar( pFile, 0, false ); // ÷èòàåì èç ôàéëà ñëåäósùèé ñèìâîë

                if (
                        symbol == INI_DELIMITER // åñëè ñèìâîë iòî INI_DELIMITER
                    &&  _ini_nKeysCount[slot] < INI_MAX_KEYS_IN_FILE // è ëèìèò êës÷åé åùå íå èñ÷ågïàí
                ) {
                    _ini_nDelimPos[slot][ _ini_nKeysCount[slot] ] = i; // äîáàâèì åùå îäíó ïîçèöès INI_DELIMITER
                    _ini_nKeysCount[slot]++; // óâåëè÷èì êîë-âî íàéäåííûõ êës÷åé
                }

                _ini_szFileContent[slot]{i} = symbol;
            }

            _ini_szFileContent[slot]{nFileSize} = 0; // ñèìâîë êîíöà ñògîêè äëÿ êîíòåíòà

            fclose(pFile); // çàêgîåì ôàéë
            // ------------


            // ------------
            // ñêîïègóåì â îçó ïóòü ê ôàéëó
            memcpy( _ini_szFilePath[slot], szFilePath, 0, nFileNameSize * cellbytes );

            _ini_szFilePath[slot][nFileNameSize] = 0; // ñèìâîë êîíöà ñògîêè äëÿ ïóòè
            // ------------


            return slot; // âågíåì ÈÄ ñëîòà
        }
    }
    // ------------




    //
    //  åñëè ñâîáîäíûé ñëîò â ïàìÿòè íå íàéäåí
    //

    // ------------
    fclose(pFile); // çàêgîåì ôàéë

    return INI_NO_FREE_SLOT; // âågíåì êîä îøèáêè
    // ------------
}




/*
    Çàêgûâàåò INI ôàéë, åñëè îí áûë îòêgûò.

    ÏÎÄGÎÁÍÅÅ
        Åñëè ôàéë íå áûë èçìåíåí - îñâîáîäèò ñëîò äëÿ õgàíåíèÿ ôàéëà â ÎÇÓ.
        Åñëè ôàéë áûë èçìåíåí - ïîëíîñòüs ïågåçàïèøåò ôàéë íà äèñêå.

    ÏÀGÀÌÅÒGÛ:
        nFilePointer    ÈÄ_îòêgûòîãî_ôàéëà, ïîëó÷åííûé îò ini_openFile / ini_createFile

    ÂÅGÍÅÒ:
        êîä îøèáêè < 0 èëè 0 ïgè óñïåõå
*/

stock ini_closeFile ( nFilePointer )
{
    if
    (   // åñëè ÈÄ îòêgûòîãî ôàéëà óêàçàí âågíî
            nFilePointer >= 0
        &&  nFilePointer < INI_MAX_OPENED_FILES
        &&  _ini_nSlotUsed[nFilePointer] != 0
    )
    {
        if ( _ini_nFileChanged[nFilePointer] != 0 ) // åñëè ôàéë áûë èçìåíåí
        {
            new File: pFile = fopen( _ini_szFilePath[nFilePointer], io_write ); // ïûòàåìñÿ îòêgûòü ôàéë äëÿ çàïèñè

            if ( ! pFile ) // åñëè ôàéë íå îòêgûëñÿ
                return INI_WRITE_ERROR; // âågíåì êîä îøèáêè

            // çàïèøåì êîíòåíò ôàéëà èç ÎÇÓ íà äèñê
            for ( new i = 0;  i < _ini_nFileSize[nFilePointer];  i++ )
                fputchar( pFile, _ini_szFileContent[nFilePointer]{i}, false );

            fclose(pFile); // çàêgîåì ôàéë
        }

        _ini_nSlotUsed[nFilePointer] = 0; // îñâîáîäèòü ñëîò îòêgûòîãî ôàéëà

        return INI_OK; // âågíóòü êîä îá óñïåøíîì âûïîëíåíèè ôóíêöèè
    }

    return INI_WRONG_SLOT; // âågíóòü êîä: íåâågíûé óêàçàòåëü íà îòêgûòûé ôàéë
}











/*
    Ïîëó÷àåò èç îòêgûòîãî INI ôàéëà çíà÷åíèå óêàçàííîãî êës÷à.

    ÏÎÄGÎÁÍÅÅ
        Ïàgñåg èùåò â ÎÇÓ â êîíòåíòå ôàéëà óêàçàííûé êës÷ è ïîìåùàåò â
        szReturnValue åãî ñògîêîâîå çíà÷åíèå. szReturnValue íóæíî ñîçäàòü çàgàíåå.

        nSizeOfReturn ìîæíî íå óêàçûâàòü, åñëè òîëüêî íå íóæíî òî÷íîå êîë-âî
        âîçâgàùàåìûõ ñèìâîëîâ â ñògîêå (â îïèñàíèè iòîãî ïàgàìåògà íèæå äàíû
        äîïîëíèòåëüíûå óêàçàíèÿ).

        Êàê êës÷ òàê è çíà÷åíèå â ôàéëå, ìîãóò áûòü ësáîé äëèíû è
        ìîãóò ñîäågæàòü ësáûå ñèìâîëû, êgîìå 2 ñèìâîëîâ êîíöà ñògîêè \r è \n.

        Ïàgñåg íå âèäèò ïgîáåëû è çíàêè òàáóëÿöèè âîêgóã èìåíè êës÷à è
        ïågåä çíà÷åíèåì, îí ñ÷èòàåò èõ îòñòóïàìè.

    ÏÀGÀÌÅÒGÛ:
        nFilePointer        ÈÄ_îòêgûòîãî_ôàéëà, ïîëó÷åííûé îò ini_openFile / ini_createFile
        szKeyName[]         èìÿ êës÷à
        szReturnValue[]     ñsäà áóäåò ïîìåùåíî çíà÷åíèå êës÷à â âèäå ñògîêè
        nSizeOfReturn       ìàêñ. gàçìåg âîçâgàùàåìîé ñògîêè, îáû÷íî, iòî gàçìåg szReturnValue.
                            åñëè âàøà ñògîêà szReturnValue ÿâëÿåòñÿ ÷àñòüs ìàññèâà, êîòîgûé áûë ñîçäàí ñ ïîìîùüs enum,
                            iòîò ïàgàìåòg íóæíî îáÿçàòåëüíî óêàçûâàòü êàê ÷èñëî

    ÂÅGÍÅÒ:
        êîä îøèáêè < 0 èëè 0 ïgè óñïåõå
*/

stock ini_getString ( nFilePointer, szKeyName[], szReturnValue[], nSizeOfReturn = sizeof(szReturnValue) )
{
    // ----------------
    if // åñëè ÈÄ îòêgûòîãî ôàéëà óêàçàí íåâågíî
    (
            nFilePointer < 0
        ||  nFilePointer >= INI_MAX_OPENED_FILES
        ||  _ini_nSlotUsed[nFilePointer] != 1
    )
        return INI_WRONG_SLOT; // âågíóòü êîä: íåâågíûé óêàçàòåëü íà îòêgûòûé ôàéë
    // ----------------


    if ( nSizeOfReturn <= 0 ) // åñëè ïî êàêîé-òî ïgè÷èíå gàçìåg âîçâgàùàåìîãî çíà÷åíèÿ óêàçàí/gàññ÷èòàí êàê 0
        return INI_WRONG_RETURN_SIZE;


    // ----------------
    new nKeyLen = strlen(szKeyName); // óçíàåì äëèíó èìåíè óêàçàííîãî êës÷à

    if ( nKeyLen <= 0 ) // åñëè óêàçàí ïóñòîé êës÷
        return INI_KEY_NOT_FOUND;
    // ----------------


    // ----------------
    for // ïågåáîg è ñgàâíåíèå âñåõ êës÷åé ôàéëà ñ óêàçàííûì êës÷îì
    (
        new kPos = 0, curFilePos, found = 0;
        kPos < _ini_nKeysCount[nFilePointer];
        kPos++
    )
    {
        // ----------------
        found = 0; // ôëàã, íàéäåíà ëè ïîçèöèÿ êîíöà êës÷à = 0

        for // èùåì ïîçèöès êîíöà êës÷à
        (
            curFilePos = _ini_nDelimPos[nFilePointer][kPos] - 1; // òåêóù. ïîç. ôàéëà = ïîç. òåêóù. INI_DELIMITER - 1
            curFilePos >= 0; // ïgîäîëæàòü ïîêà ïîç. ôàéëà >= 0
            curFilePos-- // ïîñëå êàæäîãî ïîâòîgà òåêóù. ïîç. ôàéëà -= 1
        )
        {
            switch ( _ini_szFileContent[nFilePointer]{curFilePos} ) // óçíàåì ÷òî çà ñèìâîë â òåêóù. ïîç. ôàéëà
            {
                case INI_SPACE_CHAR :           continue; // åñëè iòî ïgîáåëüíûé ñèìâîë, ïågåéäåì ê ïgåä. ñèìâîëó ôàéëà
                case INI_STRING_DELIMITER :     break; // åñëè iòî êîíåö ñògîêè
                default : // åñëè iòî ägóãîé ñèìâîë
                {
                    found = 1; // ïîçèöèÿ êîíöà êës÷à íàéäåíà
                    break; // êîíåö öèêëà
                }
            }
        }

        // åñëè ïîçèöèÿ êîíöà êës÷à íå íàéäåíà, ïågåõîä ê ñëåä. ïîçèöèè INI_DELIMITER
        if ( found != 1 ) continue;
        // ----------------


        // ñgàâíèâàåì ïîñèìâîëüíî òåêóùèé êës÷ ôàéëà è óêàçàííûé êës÷
        for ( new curKeyPos = nKeyLen - 1;  curKeyPos >= 0;  curFilePos--, curKeyPos-- )
        {
            if
            (
                    curFilePos < 0 // åñëè ïîç ôàéëà ñòàëà < 0
                ||  _ini_szFileContent[nFilePointer]{curFilePos} != szKeyName[curKeyPos] // åñëè ñèìâîëû èç êës÷åé íå gàâíû
                ||  _ini_szFileContent[nFilePointer]{curFilePos} == INI_STRING_DELIMITER // åñëè ñèìâîë èç êës÷à iòî INI_STRING_DELIMITER
            )
            {
                found = 0; // ôëàã, êës÷ íå íàéäåí
                break; // êîíåö ñgàâíåíèÿ
            }
        }


        // ----------------
        if ( found != 0 ) // åñëè óêàçàííûé êës÷ íàéäåí â ôàéëå
        {
            // åñëè íàéäåíî ñîâïàäåíèå íå öåëîãî êës÷à ôàéëà, à åãî îêîí÷àíèÿ ñ óêàçàííûì êës÷îì
            if ( curFilePos >= 0 )
            {
                switch ( _ini_szFileContent[nFilePointer]{curFilePos} )
                {
                    case INI_KEY_STARTS : {}
                    default: continue;
                }
            }


            // ----------------
            // òåêóùàÿ ïîçèöèÿ â ôàéëå áóäåò íà 1 áîëüøå òåêóùåé ïîçèöèè INI_DELIMITER
            curFilePos = _ini_nDelimPos[nFilePointer][kPos] + 1;

            // èùåì ïîçèöès íà÷àëà çíà÷åíèÿ, îíà áóäåò ïîìåùåíà â curFilePos
            for ( ; ; curFilePos++ )
            {
                if ( curFilePos >= _ini_nFileSize[nFilePointer] ) break;

                switch ( _ini_szFileContent[nFilePointer]{curFilePos} )
                {
                    case INI_SPACE_CHAR :   continue; // åñëè iòî ïgîáåëüíûé ñèìâîë, ïågåéäåì ê ñëåä. ñèìâîëó
                    default :               break; // åñëè iòî ägóãîé ñèìâîë
                }
            }
            // ----------------


            // ----------------
            // ñêîïègóåì ïîñèìâîëüíî â szReturnValue çíà÷åíèå êës÷à èç ôàéëà
            // âîñïîëüçóåìñÿ ñîçäàííîé ïågåìåííîé found êàê ïîçèöèåé â âîçâgàùàåìîì çíà÷åíèè
            for ( found = 0;  found < nSizeOfReturn;  found++, curFilePos++ )
            {
                switch ( _ini_szFileContent[nFilePointer]{curFilePos} )
                {
                    case INI_STRING_ENDS : // åñëè iòî ñèìâîë êîíöà çíà÷åíèÿ
                    {
                        szReturnValue[found] = 0; // çàïèøåì ñèìâîë êîíöà ñògîêè
                        break; // êîíåö êîïègîâàíèÿ
                    }
                    default :
                        // êîïègóåì ñèìâîë èç ôàéëà â szReturnValue
                        szReturnValue[found] = _ini_szFileContent[nFilePointer]{curFilePos};
                }
            }

            szReturnValue[nSizeOfReturn - 1] = 0; // íà âñÿêèé ñëó÷àé îágåæåì ïgàâèëüíî ñògîêó

            return INI_OK;
            // ----------------
        }
        // ----------------
    }
    // ----------------


    // ----------------
    return INI_KEY_NOT_FOUND;
    // ----------------
}




/*
    Ïîëó÷àåò èç îòêgûòîãî INI ôàéëà öåëî÷èñëåííîå çíà÷åíèå óêàçàííîãî êës÷à.

    ÏÎÄGÎÁÍÅÅ
        Ïàgñåg èùåò â ÎÇÓ â êîíòåíòå ôàéëà óêàçàííûé êës÷ è ïîìåùàåò â
        nReturnValue åãî öåëî÷èñëåííîå çíà÷åíèå. nReturnValue íóæíî ñîçäàòü çàgàíåå.

        Èìÿ êës÷à â ôàéëå ìîæåò áûòü ësáîé äëèíû, à òàêæå ìîæåò ñîäågæàòü
        ësáûå ñèìâîëû, êgîìå 2 ñèìâîëîâ êîíöà ñògîêè \r è \n.

        Çíà÷åíèå ìîæåò áûòü òîëüêî ôèêñègîâàííîé äëèíû, êîòîgàÿ gàâíà INI_INTEGER_SIZE - 1.
        Ïàgñåg íå âèäèò ïgîáåëû è çíàêè òàáóëÿöèè âîêgóã èìåíè êës÷à/çíà÷åíèÿ,
        îí ñ÷èòàåò èõ îòñòóïàìè.

    ÏÀGÀÌÅÒGÛ:
        nFilePointer        ÈÄ_îòêgûòîãî_ôàéëà, ïîëó÷åííûé îò ini_openFile / ini_createFile
        szKeyName[]         èìÿ êës÷à
        nReturnValue        ñsäà áóäåò ïîìåùåíî çíà÷åíèå êës÷à â âèäå öåëîãî ÷èñëà

    ÂÅGÍÅÒ:
        êîä îøèáêè < 0 èëè 0 ïgè óñïåõå
*/

stock ini_getInteger ( nFilePointer, szKeyName[], & nReturnValue )
{
    // ----------------
    if // åñëè ÈÄ îòêgûòîãî ôàéëà óêàçàí íåâågíî
    (
            nFilePointer < 0
        ||  nFilePointer >= INI_MAX_OPENED_FILES
        ||  _ini_nSlotUsed[nFilePointer] != 1
    )
        return INI_WRONG_SLOT; // âågíóòü êîä: íåâågíûé óêàçàòåëü íà îòêgûòûé ôàéë
    // ----------------


    // ----------------
    new nKeyLen = strlen(szKeyName); // óçíàåì äëèíó èìåíè óêàçàííîãî êës÷à

    if ( nKeyLen <= 0 ) // åñëè óêàçàí ïóñòîé êës÷
        return INI_KEY_NOT_FOUND;
    // ----------------


    // ----------------
    for // ïågåáîg è ñgàâíåíèå âñåõ êës÷åé ôàéëà ñ óêàçàííûì êës÷îì
    (
        new kPos = 0, curFilePos, found = 0;
        kPos < _ini_nKeysCount[nFilePointer];
        kPos++
    )
    {
        // ----------------
        found = 0; // ôëàã, íàéäåíà ëè ïîçèöèÿ êîíöà êës÷à = 0

        for // èùåì ïîçèöès êîíöà êës÷à
        (
            curFilePos = _ini_nDelimPos[nFilePointer][kPos] - 1; // òåêóù. ïîç. ôàéëà = ïîç. òåêóù. INI_DELIMITER - 1
            curFilePos >= 0; // ïgîäîëæàòü ïîêà ïîç. ôàéëà >= 0
            curFilePos-- // ïîñëå êàæäîãî ïîâòîgà òåêóù. ïîç. ôàéëà -= 1
        )
        {
            switch ( _ini_szFileContent[nFilePointer]{curFilePos} ) // óçíàåì ÷òî çà ñèìâîë â òåêóù. ïîç. ôàéëà
            {
                case INI_SPACE_CHAR :           continue; // åñëè iòî ïgîáåëüíûé ñèìâîë, ïågåéäåì ê ïgåä. ñèìâîëó ôàéëà
                case INI_STRING_DELIMITER :     break; // åñëè iòî êîíåö ñògîêè
                default : // åñëè iòî ägóãîé ñèìâîë
                {
                    found = 1; // ïîçèöèÿ êîíöà êës÷à íàéäåíà
                    break; // êîíåö öèêëà
                }
            }
        }

        // åñëè ïîçèöèÿ êîíöà êës÷à íå íàéäåíà, ïågåõîä ê ñëåä. ïîçèöèè INI_DELIMITER
        if ( found != 1 ) continue;
        // ----------------


        // ñgàâíèâàåì ïîñèìâîëüíî òåêóùèé êës÷ ôàéëà è óêàçàííûé êës÷
        for ( new curKeyPos = nKeyLen - 1;  curKeyPos >= 0;  curFilePos--, curKeyPos-- )
        {
            if
            (
                    curFilePos < 0 // åñëè ïîç ôàéëà ñòàëà < 0
                ||  _ini_szFileContent[nFilePointer]{curFilePos} != szKeyName[curKeyPos] // åñëè ñèìâîëû èç êës÷åé íå gàâíû
                ||  _ini_szFileContent[nFilePointer]{curFilePos} == INI_STRING_DELIMITER // åñëè ñèìâîë èç êës÷à iòî INI_STRING_DELIMITER
            )
            {
                found = 0; // ôëàã, êës÷ íå íàéäåí
                break; // êîíåö ñgàâíåíèÿ
            }
        }


        // ----------------
        if ( found != 0 ) // åñëè óêàçàííûé êës÷ íàéäåí â ôàéëå
        {
            // åñëè íàéäåíî ñîâïàäåíèå íå öåëîãî êës÷à ôàéëà, à åãî îêîí÷àíèÿ ñ óêàçàííûì êës÷îì
            if ( curFilePos >= 0 )
            {
                switch ( _ini_szFileContent[nFilePointer]{curFilePos} )
                {
                    case INI_KEY_STARTS : {}
                    default: continue;
                }
            }


            // ----------------
            // òåêóùàÿ ïîçèöèÿ â ôàéëå áóäåò íà 1 áîëüøå òåêóùåé ïîçèöèè INI_DELIMITER
            curFilePos = _ini_nDelimPos[nFilePointer][kPos] + 1;

            // èùåì ïîçèöès íà÷àëà çíà÷åíèÿ, îíà áóäåò ïîìåùåíà â curFilePos
            for ( ; ; curFilePos++ )
            {
                if ( curFilePos >= _ini_nFileSize[nFilePointer] ) break;

                switch ( _ini_szFileContent[nFilePointer]{curFilePos} )
                {
                    case INI_SPACE_CHAR :   continue; // åñëè iòî ïgîáåëüíûé ñèìâîë, ïågåéäåì ê ñëåä. ñèìâîëó
                    default :               break; // åñëè iòî ägóãîé ñèìâîë
                }
            }
            // ----------------


            // ----------------
            new strValue[INI_INTEGER_SIZE]; // âgåìåííàÿ ñògîêà äëÿ ÷èñëåííîãî çíà÷åíèÿ

            // ñêîïègóåì ïîñèìâîëüíî â strValue çíà÷åíèå êës÷à èç ôàéëà
            // âîñïîëüçóåìñÿ ñîçäàííîé ïågåìåííîé found êàê ïîçèöèåé â âîçâgàùàåìîì çíà÷åíèè
            for ( found = 0;  found < INI_INTEGER_SIZE;  found++, curFilePos++ )
            {
                switch ( _ini_szFileContent[nFilePointer]{curFilePos} )
                {
                    case INI_NUMBER_ENDS : // åñëè iòî ñèìâîë êîíöà ÷èñëåííîãî çíà÷åíèÿ
                    {
                        strValue[found] = 0; // çàïèøåì ñèìâîë êîíöà ñògîêè
                        break; // êîíåö êîïègîâàíèÿ
                    }
                    default :
                        // êîïègóåì ñèìâîë èç ôàéëà â strValue
                        strValue[found] = _ini_szFileContent[nFilePointer]{curFilePos};
                }
            }

            strValue[INI_INTEGER_SIZE - 1] = 0; // íà âñÿêèé ñëó÷àé îágåæåì ïgàâèëüíî ñògîêó

            nReturnValue = strval(strValue); // çàïèøåì â nReturnValue ÷èñëåííîå çíà÷åíèå êës÷à

            return INI_OK;
            // ----------------
        }
        // ----------------
    }
    // ----------------


    // ----------------
    return INI_KEY_NOT_FOUND;
    // ----------------
}




/*
    Ïîëó÷àåò èç îòêgûòîãî INI ôàéëà ägîáíîå ÷èñëåííîå çíà÷åíèå óêàçàííîãî êës÷à.

    ÏÎÄGÎÁÍÅÅ
        Ïàgñåg èùåò â ÎÇÓ â êîíòåíòå ôàéëà óêàçàííûé êës÷ è ïîìåùàåò â
        fReturnValue åãî ägîáíîå çíà÷åíèå. fReturnValue íóæíî ñîçäàòü çàgàíåå.

        Èìÿ êës÷à â ôàéëå ìîæåò áûòü ësáîé äëèíû, à òàêæå ìîæåò ñîäågæàòü
        ësáûå ñèìâîëû, êgîìå 2 ñèìâîëîâ êîíöà ñògîêè \r è \n.

        Çíà÷åíèå ìîæåò áûòü òîëüêî ôèêñègîâàííîé äëèíû, êîòîgàÿ gàâíà INI_FLOAT_SIZE - 1.
        Ïàgñåg íå âèäèò ïgîáåëû è çíàêè òàáóëÿöèè âîêgóã èìåíè êës÷à/çíà÷åíèÿ,
        îí ñ÷èòàåò èõ îòñòóïàìè.

    ÏÀGÀÌÅÒGÛ:
        nFilePointer        ÈÄ_îòêgûòîãî_ôàéëà, ïîëó÷åííûé îò ini_openFile / ini_createFile
        szKeyName[]         èìÿ êës÷à
        fReturnValue        ñsäà áóäåò ïîìåùåíî çíà÷åíèå êës÷à â âèäå ägîáíîãî ÷èñëà

    ÂÅGÍÅÒ:
        êîä îøèáêè < 0 èëè 0 ïgè óñïåõå
*/

stock ini_getFloat ( nFilePointer, szKeyName[], & Float: fReturnValue )
{
    // ----------------
    if // åñëè ÈÄ îòêgûòîãî ôàéëà óêàçàí íåâågíî
    (
            nFilePointer < 0
        ||  nFilePointer >= INI_MAX_OPENED_FILES
        ||  _ini_nSlotUsed[nFilePointer] != 1
    )
        return INI_WRONG_SLOT; // âågíóòü êîä: íåâågíûé óêàçàòåëü íà îòêgûòûé ôàéë
    // ----------------


    // ----------------
    new nKeyLen = strlen(szKeyName); // óçíàåì äëèíó èìåíè óêàçàííîãî êës÷à

    if ( nKeyLen <= 0 ) // åñëè óêàçàí ïóñòîé êës÷
        return INI_KEY_NOT_FOUND;
    // ----------------


    // ----------------
    for // ïågåáîg è ñgàâíåíèå âñåõ êës÷åé ôàéëà ñ óêàçàííûì êës÷îì
    (
        new kPos = 0, curFilePos, found = 0;
        kPos < _ini_nKeysCount[nFilePointer];
        kPos++
    )
    {
        // ----------------
        found = 0; // ôëàã, íàéäåíà ëè ïîçèöèÿ êîíöà êës÷à = 0

        for // èùåì ïîçèöès êîíöà êës÷à
        (
            curFilePos = _ini_nDelimPos[nFilePointer][kPos] - 1; // òåêóù. ïîç. ôàéëà = ïîç. òåêóù. INI_DELIMITER - 1
            curFilePos >= 0; // ïgîäîëæàòü ïîêà ïîç. ôàéëà >= 0
            curFilePos-- // ïîñëå êàæäîãî ïîâòîgà òåêóù. ïîç. ôàéëà -= 1
        )
        {
            switch ( _ini_szFileContent[nFilePointer]{curFilePos} ) // óçíàåì ÷òî çà ñèìâîë â òåêóù. ïîç. ôàéëà
            {
                case INI_SPACE_CHAR :           continue; // åñëè iòî ïgîáåëüíûé ñèìâîë, ïågåéäåì ê ïgåä. ñèìâîëó ôàéëà
                case INI_STRING_DELIMITER :     break; // åñëè iòî êîíåö ñògîêè
                default : // åñëè iòî ägóãîé ñèìâîë
                {
                    found = 1; // ïîçèöèÿ êîíöà êës÷à íàéäåíà
                    break; // êîíåö öèêëà
                }
            }
        }

        // åñëè ïîçèöèÿ êîíöà êës÷à íå íàéäåíà, ïågåõîä ê ñëåä. ïîçèöèè INI_DELIMITER
        if ( found != 1 ) continue;
        // ----------------


        // ñgàâíèâàåì ïîñèìâîëüíî òåêóùèé êës÷ ôàéëà è óêàçàííûé êës÷
        for ( new curKeyPos = nKeyLen - 1;  curKeyPos >= 0;  curFilePos--, curKeyPos-- )
        {
            if
            (
                    curFilePos < 0 // åñëè ïîç ôàéëà ñòàëà < 0
                ||  _ini_szFileContent[nFilePointer]{curFilePos} != szKeyName[curKeyPos] // åñëè ñèìâîëû èç êës÷åé íå gàâíû
                ||  _ini_szFileContent[nFilePointer]{curFilePos} == INI_STRING_DELIMITER // åñëè ñèìâîë èç êës÷à iòî INI_STRING_DELIMITER
            )
            {
                found = 0; // ôëàã, êës÷ íå íàéäåí
                break; // êîíåö ñgàâíåíèÿ
            }
        }


        // ----------------
        if ( found != 0 ) // åñëè óêàçàííûé êës÷ íàéäåí â ôàéëå
        {
            // åñëè íàéäåíî ñîâïàäåíèå íå öåëîãî êës÷à ôàéëà, à åãî îêîí÷àíèÿ ñ óêàçàííûì êës÷îì
            if ( curFilePos >= 0 )
            {
                switch ( _ini_szFileContent[nFilePointer]{curFilePos} )
                {
                    case INI_KEY_STARTS : {}
                    default: continue;
                }
            }


            // ----------------
            // òåêóùàÿ ïîçèöèÿ â ôàéëå áóäåò íà 1 áîëüøå òåêóùåé ïîçèöèè INI_DELIMITER
            curFilePos = _ini_nDelimPos[nFilePointer][kPos] + 1;

            // èùåì ïîçèöès íà÷àëà çíà÷åíèÿ, îíà áóäåò ïîìåùåíà â curFilePos
            for ( ; ; curFilePos++ )
            {
                if ( curFilePos >= _ini_nFileSize[nFilePointer] ) break;

                switch ( _ini_szFileContent[nFilePointer]{curFilePos} )
                {
                    case INI_SPACE_CHAR :   continue; // åñëè iòî ïgîáåëüíûé ñèìâîë, ïågåéäåì ê ñëåä. ñèìâîëó
                    default :               break; // åñëè iòî ägóãîé ñèìâîë
                }
            }
            // ----------------


            // ----------------
            new strValue[INI_FLOAT_SIZE]; // âgåìåííàÿ ñògîêà äëÿ ägîáíîãî çíà÷åíèÿ

            // ñêîïègóåì ïîñèìâîëüíî â strValue çíà÷åíèå êës÷à èç ôàéëà
            // âîñïîëüçóåìñÿ ñîçäàííîé ïågåìåííîé found êàê ïîçèöèåé â âîçâgàùàåìîì çíà÷åíèè
            for ( found = 0;  found < INI_INTEGER_SIZE;  found++, curFilePos++ )
            {
                switch ( _ini_szFileContent[nFilePointer]{curFilePos} )
                {
                    case INI_NUMBER_ENDS : // åñëè iòî ñèìâîë êîíöà ÷èñëåííîãî çíà÷åíèÿ
                    {
                        strValue[found] = 0; // çàïèøåì ñèìâîë êîíöà ñògîêè
                        break; // êîíåö êîïègîâàíèÿ
                    }
                    default :
                        // êîïègóåì ñèìâîë èç ôàéëà â strValue
                        strValue[found] = _ini_szFileContent[nFilePointer]{curFilePos};
                }
            }

            strValue[INI_FLOAT_SIZE - 1] = 0; // íà âñÿêèé ñëó÷àé îágåæåì ïgàâèëüíî ñògîêó

            fReturnValue = floatstr(strValue); // çàïèøåì â fReturnValue ägîáíîå çíà÷åíèå êës÷à

            return INI_OK;
            // ----------------
        }
        // ----------------
    }
    // ----------------


    // ----------------
    return INI_KEY_NOT_FOUND;
    // ----------------
}











/*
    Èçìåíÿåò/äîáàâëÿåò â îòêgûòûé INI ôàéë óêàçàííûé êës÷ è åãî çíà÷åíèå.

    ÏÎÄGÎÁÍÅÅ
        Ïàgñåg èùåò â ÎÇÓ â êîíòåíòå ôàéëà óêàçàííûé êës÷ è èçìåíÿåò åãî
        ñògîêîâîå çíà÷åíèå íà szKeyValue.

        Ôîgìàòègîâàíèå ôàéëà íå ìåíÿåòñÿ. Åñëè òîëüêî óêàçàííîå èìÿ êës÷à
        íå áûëî íàéäåíî, òîãäà êës÷ è çíà÷åíèå áóäóò äîáàâëåíû â êîíåö ôàéëà.

        Èìÿ êës÷à/çíà÷åíèå â ôàéëå ìîæåò áûòü ësáîé äëèíû, à òàêæå ìîæåò ñîäågæàòü
        ësáûå ñèìâîëû, êgîìå 2 ñèìâîëîâ êîíöà ñògîêè \r è \n. Åñëè iòè ñèìâîëû åñòü
        â èìåíè êës÷à èëè â çíà÷åíèè, âû äîëæíû äîëæíû õîgîøî çíàòü è îñîçíàâàòü
        ïîñëåäñòâèÿ.

    ÏÀGÀÌÅÒGÛ:
        nFilePointer        ÈÄ_îòêgûòîãî_ôàéëà, ïîëó÷åííûé îò ini_openFile / ini_createFile
        szKeyName[]         èìÿ êës÷à
        szKeyValue[]        ñògîêà ñî çíà÷åíèåì êës÷à

    ÂÅGÍÅÒ:
        êîä îøèáêè < 0 èëè 0 ïgè óñïåõå
*/

stock ini_setString ( nFilePointer, szKeyName[], szKeyValue[] )
{
    // ----------------
    if // åñëè ÈÄ îòêgûòîãî ôàéëà óêàçàí íåâågíî
    (
            nFilePointer < 0
        ||  nFilePointer >= INI_MAX_OPENED_FILES
        ||  _ini_nSlotUsed[nFilePointer] != 1
    )
        return INI_WRONG_SLOT; // âågíóòü êîä: íåâågíûé óêàçàòåëü íà îòêgûòûé ôàéë
    // ----------------


    // ----------------
    new nKeyLen = strlen(szKeyName); // óçíàåì äëèíó èìåíè óêàçàííîãî êës÷à

    if ( nKeyLen <= 0 ) // åñëè óêàçàí ïóñòîé êës÷
        return INI_KEY_NOT_FOUND;
    // ----------------


    // ----------------
    for // ïågåáîg è ñgàâíåíèå âñåõ êës÷åé ôàéëà ñ óêàçàííûì êës÷îì
    (
        new kPos = 0, curFilePos, found;
        kPos < _ini_nKeysCount[nFilePointer];
        kPos++
    )
    {
        // ----------------
        found = 0; // ôëàã, íàéäåíà ëè ïîçèöèÿ êîíöà êës÷à = 0

        for // èùåì ïîçèöès êîíöà êës÷à
        (
            curFilePos = _ini_nDelimPos[nFilePointer][kPos] - 1; // òåêóù. ïîç. ôàéëà = ïîç. òåêóù. INI_DELIMITER - 1
            curFilePos >= 0; // ïgîäîëæàòü ïîêà ïîç. ôàéëà >= 0
            curFilePos-- // ïîñëå êàæäîãî ïîâòîgà òåêóù. ïîç. ôàéëà -= 1
        )
        {
            switch ( _ini_szFileContent[nFilePointer]{curFilePos} ) // óçíàåì ÷òî çà ñèìâîë â òåêóù. ïîç. ôàéëà
            {
                case INI_SPACE_CHAR :           continue; // åñëè iòî ïgîáåëüíûé ñèìâîë, ïågåéäåì ê ïgåä. ñèìâîëó ôàéëà
                case INI_STRING_DELIMITER :     break; // åñëè iòî êîíåö ñògîêè
                default : // åñëè iòî ägóãîé ñèìâîë
                {
                    found = 1; // ïîçèöèÿ êîíöà êës÷à íàéäåíà
                    break; // êîíåö öèêëà
                }
            }
        }

        // åñëè ïîçèöèÿ êîíöà êës÷à íå íàéäåíà, ïågåõîä ê ñëåä. ïîçèöèè INI_DELIMITER
        if ( found != 1 ) continue;
        // ----------------


        // ñgàâíèâàåì ïîñèìâîëüíî òåêóùèé êës÷ ôàéëà è óêàçàííûé êës÷
        for ( new curKeyPos = nKeyLen - 1;  curKeyPos >= 0;  curFilePos--, curKeyPos-- )
        {
            if
            (
                    curFilePos < 0 // åñëè ïîç ôàéëà ñòàëà < 0
                ||  _ini_szFileContent[nFilePointer]{curFilePos} != szKeyName[curKeyPos] // åñëè ñèìâîëû èç êës÷åé íå gàâíû
                ||  _ini_szFileContent[nFilePointer]{curFilePos} == INI_STRING_DELIMITER // åñëè ñèìâîë èç êës÷à iòî INI_STRING_DELIMITER
            )
            {
                found = 0; // ôëàã, êës÷ íå íàéäåí
                break; // êîíåö ñgàâíåíèÿ
            }
        }


        if ( found != 0 ) // åñëè óêàçàííûé êës÷ ÍÀÉÄÅÍ â ôàéëå
        {
            // åñëè íàéäåíî ñîâïàäåíèå íå öåëîãî êës÷à ôàéëà, à åãî îêîí÷àíèÿ ñ óêàçàííûì êës÷îì
            if ( curFilePos >= 0 )
            {
                switch ( _ini_szFileContent[nFilePointer]{curFilePos} )
                {
                    case INI_KEY_STARTS : {}
                    default: continue;
                }
            }


            // ----------------
            // òåêóùàÿ ïîçèöèÿ â ôàéëå áóäåò íà 1 áîëüøå òåêóùåé ïîçèöèè INI_DELIMITER
            curFilePos = _ini_nDelimPos[nFilePointer][kPos] + 1;

            // èùåì ïîçèöès íà÷àëà çíà÷åíèÿ, îíà áóäåò ïîìåùåíà â curFilePos
            for ( ; ; curFilePos++ )
            {
                if ( curFilePos >= _ini_nFileSize[nFilePointer] ) break;

                switch ( _ini_szFileContent[nFilePointer]{curFilePos} )
                {
                    case INI_SPACE_CHAR :   continue; // åñëè iòî ïgîáåëüíûé ñèìâîë, ïågåéäåì ê ñëåä. ñèìâîëó
                    default :               break; // åñëè iòî ägóãîé ñèìâîë
                }
            }
            // ----------------


            // ----------------
            new nValueLen = strlen(szKeyValue); // óçíàåì gàçìåg çíà÷åíèÿ óêàçàííîãî êës÷à

            // åñëè áóäóùèé gàçìåg ôàéëà ïgåâûøàåò ëèìèò
            if ( ( curFilePos + nValueLen ) >= INI_MAX_FILE_SIZE )
                return INI_TOO_LARGE_FILE; // âågíåì êîä îøèáêè î ïågåïîëíåíèè ôàéëà
            // ----------------


            // ----------------
            new fileValueStartPos = curFilePos; // ñîõgàíèì ïîçèöès íà÷àëà çíà÷åíèÿ

            // èùåì ïîçèöès êîíöà çíà÷åíèÿ, îíà áóäåò ïîìåùåíà â curFilePos
            for ( ; ; curFilePos++ )
            {
                if ( curFilePos >= _ini_nFileSize[nFilePointer] ) break;

                switch ( _ini_szFileContent[nFilePointer]{curFilePos} )
                {
                    case INI_STRING_ENDS :  break; // åñëè iòî êîíåö ñògîêè - ñòîï
                    default :               continue; // åñëè iòî ägóãîé ñèìâîë, ïågåéäåì ê ñëåä. ñèìâîëó
                }
            }

            // âû÷èñëèì ñìåùåíèå îñòàâøèõñÿ ïîçèöèé äëÿ INI_DELIMITER ïîñëå èçìåíåíèÿ çíà÷åíèÿ
            new filePosOffset = nValueLen - ( /*òåêóù äëèíà çíà÷åíèÿ*/ curFilePos - fileValueStartPos );
            // ----------------


            if ( _ini_nFileBusy[nFilePointer] != 0 ) // åñëè ïgÿìî ñåé÷àñ ôàéë èçìåíÿåòñÿ ägóãîé ôóíêöèåé
                return INI_WRITE_ERROR; // âågíåì êîä îøèáêè ïgè çàïèñè â ôàéë


            // ----------------
            _ini_nFileBusy[nFilePointer] = 1; // ôëàã: ôàéë èçìåíÿåòñÿ = 1

            if ( filePosOffset != 0 ) // åñëè äëèíû ñòàgîãî è íîâîãî çíà÷åíèé gàçíûå
            {
                if ( filePosOffset < 0 ) // åñëè äëèíà íîâîãî çíà÷åíèÿ ìåíüøå
                {
                    for // êîïègóåì ñèìâîëû, ñòîÿùèå ïîñëå òåêóùåãî çíà÷åíèÿ íà èõ íîâûå ìåñòà,
                    ( // êîòîgûå òåïågü áóäóò áëèæå ê íà÷àëó ôàéëà
                        ;
                        curFilePos < _ini_nFileSize[nFilePointer];
                        curFilePos++
                    )
                        _ini_szFileContent[nFilePointer]{ curFilePos + filePosOffset } =
                            _ini_szFileContent[nFilePointer]{curFilePos};
                }
                else if ( filePosOffset > 0 ) // åñëè äëèíà íîâîãî çíà÷åíèÿ áîëüøå
                {
                    new fileValueEndPos = curFilePos;

                    for // êîïègóåì ñèìâîëû, ñòîÿùèå ïîñëå òåêóùåãî çíà÷åíèÿ íà èõ íîâûå ìåñòà,
                    ( // íà÷èíàÿ ñ êîíöà ôàéëà
                        curFilePos = _ini_nFileSize[nFilePointer] - 1;
                        curFilePos >= fileValueEndPos;
                        curFilePos--
                    )
                        _ini_szFileContent[nFilePointer]{ curFilePos + filePosOffset } =
                            _ini_szFileContent[nFilePointer]{curFilePos};
                }

                // èçìåíèì ïîçèöèè âñåõ INI_DELIMITER, êîòîgûå íàõîäèëèñü ïîñëå òåêóùåãî INI_DELIMITER
                for ( kPos++;  kPos < _ini_nKeysCount[nFilePointer];  kPos++ )
                    _ini_nDelimPos[nFilePointer][kPos] += filePosOffset;

                _ini_nFileSize[nFilePointer] += filePosOffset; // èçìåíèì gàçìåg ôàéëà
                _ini_szFileContent[nFilePointer]{ _ini_nFileSize[nFilePointer] } = 0; // êîíåö ñògîêè äëÿ êîíöà ôàéëà
            }

            curFilePos = fileValueStartPos; // òåêóù ïîç ôàéëà = ïîç íà÷àëà ñòàgîãî çíà÷åíèÿ
            for // çàïèøåì íîâîå çíà÷åíèå ïîâågõ ñòàgîãî
            (
                new valuePos = 0;
                valuePos < nValueLen;
                curFilePos++, valuePos++
            )
                _ini_szFileContent[nFilePointer]{curFilePos} = szKeyValue[valuePos];

            _ini_nFileChanged[nFilePointer]     = 1; // ôëàã: ôàéë èçìåíåí = 1
            _ini_nFileBusy[nFilePointer]        = 0; // ôëàã: ôàéë èçìåíÿåòñÿ = 0

            return INI_OK;
            // ----------------
        }
    }
    // ----------------


    //
    // åñëè óêàçàííûé êës÷ ÍÅ ÍÀÉÄÅÍ â ôàéëå
    //

    // ----------------
    new nValueLen = strlen(szKeyValue); // óçíàåì gàçìåg çíà÷åíèÿ êës÷à

    // åñëè áóäóùèé gàçìåg ôàéëà ïgåâûøàåò ëèìèò
    if ( ( _ini_nFileSize[nFilePointer] + 5 + nKeyLen + nValueLen ) >= INI_MAX_FILE_SIZE )
        return INI_TOO_LARGE_FILE; // âågíåì êîä îøèáêè î ïågåïîëíåíèè ôàéëà
    // ----------------


    // ----------------
    if ( _ini_nFileBusy[nFilePointer] != 0 ) // åñëè ïgÿìî ñåé÷àñ ôàéë èçìåíÿåòñÿ ägóãîé ôóíêöèåé
        return INI_WRITE_ERROR; // âågíåì êîä îøèáêè ïgè çàïèñè â ôàéë

    _ini_nFileBusy[nFilePointer] = 1; // ôëàã: ôàéë èçìåíÿåòñÿ = 1
    // ----------------


    // ----------------
    if // åñëè ïîñëåäíèé ñèìâîë ôàéëà íå ÿâëÿåòñÿ gàçäåëèòåëåì ñògîê
    (
            _ini_nFileSize[nFilePointer] > 0
        &&  _ini_szFileContent[nFilePointer]{ _ini_nFileSize[nFilePointer] - 1 } != INI_STRING_DELIMITER
    )
    {
        // âñòàâèì â êîíåö ôàéëà ïågåâîä êàgåòêè è gàçäåëèòåëü ñògîê
        _ini_szFileContent[nFilePointer]{ _ini_nFileSize[nFilePointer] }        = '\r';
        _ini_szFileContent[nFilePointer]{ _ini_nFileSize[nFilePointer] + 1 }    = INI_STRING_DELIMITER;

        _ini_nFileSize[nFilePointer] += 2; // óâåëè÷èì gàçìåg ôàéëà íà 2
    }

    new curFilePos, strPos; // áóäóò âgåìåííûì õgàíèëèùàìè ïîçèöèé â ôàéëå/êës÷å/çíà÷åíèè

    for // äîáàâèì ïîñèìâîëüíî èìÿ êës÷à â ôàéë
    (
        curFilePos = _ini_nFileSize[nFilePointer], strPos = 0;
        strPos < nKeyLen;
        curFilePos++, strPos++
    )
        _ini_szFileContent[nFilePointer]{curFilePos} = szKeyName[strPos];

    _ini_szFileContent[nFilePointer]{ curFilePos++ }                = ' '; // ïîñëå êës÷à äîáàâèì ïgîáåë

    _ini_nDelimPos[nFilePointer][ _ini_nKeysCount[nFilePointer] ]   = curFilePos; // äîáàâèì íîâós ïîçèöès INI_DELIMITER
    _ini_nKeysCount[nFilePointer]++; // êîë-âî êës÷åé â ôàéëå +1

    _ini_szFileContent[nFilePointer]{ curFilePos++ }                = INI_DELIMITER; // ïîñëå ïgîáåëà âûøå äîáàâèì INI_DELIMITER
    _ini_szFileContent[nFilePointer]{ curFilePos++ }                = ' '; // ïîñëå INI_DELIMITER äîáàâèì ïgîáåë

    // äîáàâèì ïîñèìâîëüíî çíà÷åíèå êës÷à â ôàéë
    for ( strPos = 0;  strPos < nValueLen;  curFilePos++, strPos++ )
        _ini_szFileContent[nFilePointer]{curFilePos} = szKeyValue[strPos];

    _ini_szFileContent[nFilePointer]{curFilePos}    = 0; // äîáàâèì ñèìâîë êîíöà ñògîêè
    _ini_nFileSize[nFilePointer]                    = curFilePos; // èçìåíèì gàçìåg ôàéëà
    _ini_nFileChanged[nFilePointer]                 = 1; // ôëàã: ôàéë èçìåíåí = 1
    _ini_nFileBusy[nFilePointer]                    = 0; // ôëàã: ôàéë èçìåíÿåòñÿ = 0

    return INI_OK;
    // ----------------
}




/*
    Èçìåíÿåò/äîáàâëÿåò â îòêgûòûé INI ôàéë óêàçàííûé êës÷ è åãî öåëî÷èñëåííîå çíà÷åíèå.

    ÏÎÄGÎÁÍÅÅ
        Ïàgñåg èùåò â ÎÇÓ â êîíòåíòå ôàéëà óêàçàííûé êës÷ è èçìåíÿåò åãî
        öåëî÷èñëåííîå çíà÷åíèå íà nKeyValue.

        Ôîgìàòègîâàíèå ôàéëà íå ìåíÿåòñÿ, åñëè òîëüêî óêàçàííîå èìÿ êës÷à
        íå áûëî íàéäåíî, òîãäà êës÷ è çíà÷åíèå áóäóò äîáàâëåíû â êîíåö ôàéëà.

        Èìÿ êës÷à â ôàéëå ìîæåò áûòü ësáîé äëèíû, à òàêæå ìîæåò ñîäågæàòü
        ësáûå ñèìâîëû, êgîìå 2 ñèìâîëîâ êîíöà ñògîêè \r è \n. Åñëè âû â êà÷åñòâå
        çíà÷åíèÿ óêàçûâàåòå ÷èñëî áîëüøå, ÷åì cellmax èëè ìåíüøå, ÷åì cellmin,
        âû äîëæíû äîëæíû õîgîøî çíàòü è îñîçíàâàòü ïîñëåäñòâèÿ.

    ÏÀGÀÌÅÒGÛ:
        nFilePointer        ÈÄ_îòêgûòîãî_ôàéëà, ïîëó÷åííûé îò ini_openFile / ini_createFile
        szKeyName[]         èìÿ êës÷à
        nKeyValue           öåëî÷èñëåííîå çíà÷åíèå êës÷à

    ÂÅGÍÅÒ:
        êîä îøèáêè < 0 èëè 0 ïgè óñïåõå
*/

stock ini_setInteger ( nFilePointer, szKeyName[], nKeyValue )
{
    // ----------------
    if // åñëè ÈÄ îòêgûòîãî ôàéëà óêàçàí íåâågíî
    (
            nFilePointer < 0
        ||  nFilePointer >= INI_MAX_OPENED_FILES
        ||  _ini_nSlotUsed[nFilePointer] != 1
    )
        return INI_WRONG_SLOT; // âågíóòü êîä: íåâågíûé óêàçàòåëü íà îòêgûòûé ôàéë
    // ----------------


    // ----------------
    new nKeyLen = strlen(szKeyName); // óçíàåì äëèíó èìåíè óêàçàííîãî êës÷à

    if ( nKeyLen <= 0 ) // åñëè óêàçàí ïóñòîé êës÷
        return INI_KEY_NOT_FOUND;
    // ----------------


    // ----------------
    for // ïågåáîg è ñgàâíåíèå âñåõ êës÷åé ôàéëà ñ óêàçàííûì êës÷îì
    (
        new kPos = 0, curFilePos, found;
        kPos < _ini_nKeysCount[nFilePointer];
        kPos++
    )
    {
        // ----------------
        found = 0; // ôëàã, íàéäåíà ëè ïîçèöèÿ êîíöà êës÷à = 0

        for // èùåì ïîçèöès êîíöà êës÷à
        (
            curFilePos = _ini_nDelimPos[nFilePointer][kPos] - 1; // òåêóù. ïîç. ôàéëà = ïîç. òåêóù. INI_DELIMITER - 1
            curFilePos >= 0; // ïgîäîëæàòü ïîêà ïîç. ôàéëà >= 0
            curFilePos-- // ïîñëå êàæäîãî ïîâòîgà òåêóù. ïîç. ôàéëà -= 1
        )
        {
            switch ( _ini_szFileContent[nFilePointer]{curFilePos} ) // óçíàåì ÷òî çà ñèìâîë â òåêóù. ïîç. ôàéëà
            {
                case INI_SPACE_CHAR :           continue; // åñëè iòî ïgîáåëüíûé ñèìâîë, ïågåéäåì ê ïgåä. ñèìâîëó ôàéëà
                case INI_STRING_DELIMITER :     break; // åñëè iòî êîíåö ñògîêè
                default : // åñëè iòî ägóãîé ñèìâîë
                {
                    found = 1; // ïîçèöèÿ êîíöà êës÷à íàéäåíà
                    break; // êîíåö öèêëà
                }
            }
        }

        // åñëè ïîçèöèÿ êîíöà êës÷à íå íàéäåíà, ïågåõîä ê ñëåä. ïîçèöèè INI_DELIMITER
        if ( found != 1 ) continue;
        // ----------------


        // ñgàâíèâàåì ïîñèìâîëüíî òåêóùèé êës÷ ôàéëà è óêàçàííûé êës÷
        for ( new curKeyPos = nKeyLen - 1;  curKeyPos >= 0;  curFilePos--, curKeyPos-- )
        {
            if
            (
                    curFilePos < 0 // åñëè ïîç ôàéëà ñòàëà < 0
                ||  _ini_szFileContent[nFilePointer]{curFilePos} != szKeyName[curKeyPos] // åñëè ñèìâîëû èç êës÷åé íå gàâíû
                ||  _ini_szFileContent[nFilePointer]{curFilePos} == INI_STRING_DELIMITER // åñëè ñèìâîë èç êës÷à iòî INI_STRING_DELIMITER
            )
            {
                found = 0; // ôëàã, êës÷ íå íàéäåí
                break; // êîíåö ñgàâíåíèÿ
            }
        }


        if ( found != 0 ) // åñëè óêàçàííûé êës÷ ÍÀÉÄÅÍ â ôàéëå
        {
            // åñëè íàéäåíî ñîâïàäåíèå íå öåëîãî êës÷à ôàéëà, à åãî îêîí÷àíèÿ ñ óêàçàííûì êës÷îì
            if ( curFilePos >= 0 )
            {
                switch ( _ini_szFileContent[nFilePointer]{curFilePos} )
                {
                    case INI_KEY_STARTS : {}
                    default: continue;
                }
            }


            // ----------------
            // òåêóùàÿ ïîçèöèÿ â ôàéëå áóäåò íà 1 áîëüøå òåêóùåé ïîçèöèè INI_DELIMITER
            curFilePos = _ini_nDelimPos[nFilePointer][kPos] + 1;

            // èùåì ïîçèöès íà÷àëà çíà÷åíèÿ, îíà áóäåò ïîìåùåíà â curFilePos
            for ( ; ; curFilePos++ )
            {
                if ( curFilePos >= _ini_nFileSize[nFilePointer] ) break;

                switch ( _ini_szFileContent[nFilePointer]{curFilePos} )
                {
                    case INI_SPACE_CHAR :   continue; // åñëè iòî ïgîáåëüíûé ñèìâîë, ïågåéäåì ê ñëåä. ñèìâîëó
                    default :               break; // åñëè iòî ägóãîé ñèìâîë
                }
            }
            // ----------------


            // ----------------
            new szKeyValue[INI_INTEGER_SIZE]; // ñîçäàäèì ñògîêó äëÿ õgàíåíèÿ öåëî÷èñëåííîãî çíà÷åíèÿ
            format( szKeyValue, INI_INTEGER_SIZE, "%i", nKeyValue );
            // ----------------


            // ----------------
            new nValueLen = strlen(szKeyValue); // óçíàåì gàçìåg çíà÷åíèÿ óêàçàííîãî êës÷à

            // åñëè áóäóùèé gàçìåg ôàéëà ïgåâûøàåò ëèìèò
            if ( ( curFilePos + nValueLen ) >= INI_MAX_FILE_SIZE )
                return INI_TOO_LARGE_FILE; // âågíåì êîä îøèáêè î ïågåïîëíåíèè ôàéëà
            // ----------------


            // ----------------
            new fileValueStartPos = curFilePos; // ñîõgàíèì ïîçèöès íà÷àëà çíà÷åíèÿ

            // èùåì ïîçèöès êîíöà çíà÷åíèÿ, îíà áóäåò ïîìåùåíà â curFilePos
            for ( ; ; curFilePos++ )
            {
                if ( curFilePos >= _ini_nFileSize[nFilePointer] ) break;

                switch ( _ini_szFileContent[nFilePointer]{curFilePos} )
                {
                    case INI_NUMBER_ENDS :  break; // åñëè iòî êîíåö ÷èñëà - ñòîï
                    default :               continue; // åñëè iòî ägóãîé ñèìâîë, ïågåéäåì ê ñëåä. ñèìâîëó
                }
            }

            // âû÷èñëèì ñìåùåíèå îñòàâøèõñÿ ïîçèöèé äëÿ INI_DELIMITER ïîñëå èçìåíåíèÿ çíà÷åíèÿ
            new filePosOffset = nValueLen - ( /*òåêóù äëèíà çíà÷åíèÿ*/ curFilePos - fileValueStartPos );
            // ----------------


            if ( _ini_nFileBusy[nFilePointer] != 0 ) // åñëè ïgÿìî ñåé÷àñ ôàéë èçìåíÿåòñÿ ägóãîé ôóíêöèåé
                return INI_WRITE_ERROR; // âågíåì êîä îøèáêè ïgè çàïèñè â ôàéë


            // ----------------
            _ini_nFileBusy[nFilePointer] = 1; // ôëàã: ôàéë èçìåíÿåòñÿ = 1

            if ( filePosOffset != 0 ) // åñëè äëèíû ñòàgîãî è íîâîãî çíà÷åíèé gàçíûå
            {
                if ( filePosOffset < 0 ) // åñëè äëèíà íîâîãî çíà÷åíèÿ ìåíüøå
                {
                    for // êîïègóåì ñèìâîëû, ñòîÿùèå ïîñëå òåêóùåãî çíà÷åíèÿ íà èõ íîâûå ìåñòà,
                    ( // êîòîgûå òåïågü áóäóò áëèæå ê íà÷àëó ôàéëà
                        ;
                        curFilePos < _ini_nFileSize[nFilePointer];
                        curFilePos++
                    )
                        _ini_szFileContent[nFilePointer]{ curFilePos + filePosOffset } =
                            _ini_szFileContent[nFilePointer]{curFilePos};
                }
                else if ( filePosOffset > 0 ) // åñëè äëèíà íîâîãî çíà÷åíèÿ áîëüøå
                {
                    new fileValueEndPos = curFilePos;

                    for // êîïègóåì ñèìâîëû, ñòîÿùèå ïîñëå òåêóùåãî çíà÷åíèÿ íà èõ íîâûå ìåñòà,
                    ( // íà÷èíàÿ ñ êîíöà ôàéëà
                        curFilePos = _ini_nFileSize[nFilePointer] - 1;
                        curFilePos >= fileValueEndPos;
                        curFilePos--
                    )
                        _ini_szFileContent[nFilePointer]{ curFilePos + filePosOffset } =
                            _ini_szFileContent[nFilePointer]{curFilePos};
                }

                // èçìåíèì ïîçèöèè âñåõ INI_DELIMITER, êîòîgûå íàõîäèëèñü ïîñëå òåêóùåãî INI_DELIMITER
                for ( kPos++;  kPos < _ini_nKeysCount[nFilePointer];  kPos++ )
                    _ini_nDelimPos[nFilePointer][kPos] += filePosOffset;

                _ini_nFileSize[nFilePointer] += filePosOffset; // èçìåíèì gàçìåg ôàéëà
                _ini_szFileContent[nFilePointer]{ _ini_nFileSize[nFilePointer] } = 0; // êîíåö ñògîêè äëÿ êîíöà ôàéëà
            }

            curFilePos = fileValueStartPos; // òåêóù ïîç ôàéëà = ïîç íà÷àëà ñòàgîãî çíà÷åíèÿ
            for // çàïèøåì íîâîå çíà÷åíèå ïîâågõ ñòàgîãî
            (
                new valuePos = 0;
                valuePos < nValueLen;
                curFilePos++, valuePos++
            )
                _ini_szFileContent[nFilePointer]{curFilePos} = szKeyValue[valuePos];

            _ini_nFileChanged[nFilePointer]     = 1; // ôëàã: ôàéë èçìåíåí = 1
            _ini_nFileBusy[nFilePointer]        = 0; // ôëàã: ôàéë èçìåíÿåòñÿ = 0

            return INI_OK;
            // ----------------
        }
    }
    // ----------------


    //
    // åñëè óêàçàííûé êës÷ ÍÅ ÍÀÉÄÅÍ â ôàéëå
    //

    // ----------------
    new szKeyValue[INI_INTEGER_SIZE]; // ñîçäàäèì ñògîêó äëÿ õgàíåíèÿ öåëî÷èñëåííîãî çíà÷åíèÿ
    format( szKeyValue, INI_INTEGER_SIZE, "%i", nKeyValue );
    // ----------------


    // ----------------
    new nValueLen = strlen(szKeyValue); // óçíàåì gàçìåg çíà÷åíèÿ êës÷à

    // åñëè áóäóùèé gàçìåg ôàéëà ïgåâûøàåò ëèìèò
    if ( ( _ini_nFileSize[nFilePointer] + 5 + nKeyLen + nValueLen ) >= INI_MAX_FILE_SIZE )
        return INI_TOO_LARGE_FILE; // âågíåì êîä îøèáêè î ïågåïîëíåíèè ôàéëà
    // ----------------


    // ----------------
    if ( _ini_nFileBusy[nFilePointer] != 0 ) // åñëè ïgÿìî ñåé÷àñ ôàéë èçìåíÿåòñÿ ägóãîé ôóíêöèåé
        return INI_WRITE_ERROR; // âågíåì êîä îøèáêè ïgè çàïèñè â ôàéë

    _ini_nFileBusy[nFilePointer] = 1; // ôëàã: ôàéë èçìåíÿåòñÿ = 1
    // ----------------


    // ----------------
    if // åñëè ïîñëåäíèé ñèìâîë ôàéëà íå ÿâëÿåòñÿ gàçäåëèòåëåì ñògîê
    (
            _ini_nFileSize[nFilePointer] > 0
        &&  _ini_szFileContent[nFilePointer]{ _ini_nFileSize[nFilePointer] - 1 } != INI_STRING_DELIMITER
    )
    {
        // âñòàâèì â êîíåö ôàéëà ïågåâîä êàgåòêè è gàçäåëèòåëü ñògîê
        _ini_szFileContent[nFilePointer]{ _ini_nFileSize[nFilePointer] }        = '\r';
        _ini_szFileContent[nFilePointer]{ _ini_nFileSize[nFilePointer] + 1 }    = INI_STRING_DELIMITER;

        _ini_nFileSize[nFilePointer] += 2; // óâåëè÷èì gàçìåg ôàéëà íà 2
    }

    new curFilePos, strPos; // áóäóò âgåìåííûì õgàíèëèùàìè ïîçèöèé â ôàéëå/êës÷å/çíà÷åíèè

    for // äîáàâèì ïîñèìâîëüíî èìÿ êës÷à â ôàéë
    (
        curFilePos = _ini_nFileSize[nFilePointer], strPos = 0;
        strPos < nKeyLen;
        curFilePos++, strPos++
    )
        _ini_szFileContent[nFilePointer]{curFilePos} = szKeyName[strPos];

    _ini_szFileContent[nFilePointer]{ curFilePos++ }                = ' '; // ïîñëå êës÷à äîáàâèì ïgîáåë

    _ini_nDelimPos[nFilePointer][ _ini_nKeysCount[nFilePointer] ]   = curFilePos; // äîáàâèì íîâós ïîçèöès INI_DELIMITER
    _ini_nKeysCount[nFilePointer]++; // êîë-âî êës÷åé â ôàéëå +1

    _ini_szFileContent[nFilePointer]{ curFilePos++ }                = INI_DELIMITER; // ïîñëå ïgîáåëà âûøå äîáàâèì INI_DELIMITER
    _ini_szFileContent[nFilePointer]{ curFilePos++ }                = ' '; // ïîñëå INI_DELIMITER äîáàâèì ïgîáåë

    // äîáàâèì ïîñèìâîëüíî çíà÷åíèå êës÷à â ôàéë
    for ( strPos = 0;  strPos < nValueLen;  curFilePos++, strPos++ )
        _ini_szFileContent[nFilePointer]{curFilePos} = szKeyValue[strPos];

    _ini_szFileContent[nFilePointer]{curFilePos}    = 0; // äîáàâèì ñèìâîë êîíöà ñògîêè
    _ini_nFileSize[nFilePointer]                    = curFilePos; // èçìåíèì gàçìåg ôàéëà
    _ini_nFileChanged[nFilePointer]                 = 1; // ôëàã: ôàéë èçìåíåí = 1
    _ini_nFileBusy[nFilePointer]                    = 0; // ôëàã: ôàéë èçìåíÿåòñÿ = 0

    return INI_OK;
    // ----------------
}




/*
    Èçìåíÿåò/äîáàâëÿåò â îòêgûòûé INI ôàéë óêàçàííûé êës÷ è åãî ägîáíîå ÷èñëåííîå çíà÷åíèå.

    ÏÎÄGÎÁÍÅÅ
        Ïàgñåg èùåò â ÎÇÓ â êîíòåíòå ôàéëà óêàçàííûé êës÷ è èçìåíÿåò åãî
        ägîáíîå çíà÷åíèå íà fKeyValue.

        Ôîgìàòègîâàíèå ôàéëà íå ìåíÿåòñÿ, åñëè òîëüêî óêàçàííîå èìÿ êës÷à
        íå áûëî íàéäåíî, òîãäà êës÷ è çíà÷åíèå áóäóò äîáàâëåíû â êîíåö ôàéëà.

        Èìÿ êës÷à â ôàéëå ìîæåò áûòü ësáîé äëèíû, à òàêæå ìîæåò ñîäågæàòü
        ësáûå ñèìâîëû, êgîìå 2 ñèìâîëîâ êîíöà ñògîêè \r è \n. Åñëè âû â êà÷åñòâå
        çíà÷åíèÿ óêàçûâàåòå î÷åíü áîëüøîå/ìàëåíüêîå ägîáíîå ÷èñëî, âû äîëæíû
        õîgîøî çíàòü è îñîçíàâàòü ïîñëåäñòâèÿ.

    ÏÀGÀÌÅÒGÛ:
        nFilePointer        ÈÄ_îòêgûòîãî_ôàéëà, ïîëó÷åííûé îò ini_openFile / ini_createFile
        szKeyName[]         èìÿ êës÷à
        fKeyValue           ägîáíîå ÷èñëåííîå çíà÷åíèå êës÷à

    ÂÅGÍÅÒ:
        êîä îøèáêè < 0 èëè 0 ïgè óñïåõå
*/

stock ini_setFloat ( nFilePointer, szKeyName[], Float: fKeyValue )
{
    // ----------------
    if // åñëè ÈÄ îòêgûòîãî ôàéëà óêàçàí íåâågíî
    (
            nFilePointer < 0
        ||  nFilePointer >= INI_MAX_OPENED_FILES
        ||  _ini_nSlotUsed[nFilePointer] != 1
    )
        return INI_WRONG_SLOT; // âågíóòü êîä: íåâågíûé óêàçàòåëü íà îòêgûòûé ôàéë
    // ----------------


    // ----------------
    new nKeyLen = strlen(szKeyName); // óçíàåì äëèíó èìåíè óêàçàííîãî êës÷à

    if ( nKeyLen <= 0 ) // åñëè óêàçàí ïóñòîé êës÷
        return INI_KEY_NOT_FOUND;
    // ----------------


    // ----------------
    for // ïågåáîg è ñgàâíåíèå âñåõ êës÷åé ôàéëà ñ óêàçàííûì êës÷îì
    (
        new kPos = 0, curFilePos, found;
        kPos < _ini_nKeysCount[nFilePointer];
        kPos++
    )
    {
        // ----------------
        found = 0; // ôëàã, íàéäåíà ëè ïîçèöèÿ êîíöà êës÷à = 0

        for // èùåì ïîçèöès êîíöà êës÷à
        (
            curFilePos = _ini_nDelimPos[nFilePointer][kPos] - 1; // òåêóù. ïîç. ôàéëà = ïîç. òåêóù. INI_DELIMITER - 1
            curFilePos >= 0; // ïgîäîëæàòü ïîêà ïîç. ôàéëà >= 0
            curFilePos-- // ïîñëå êàæäîãî ïîâòîgà òåêóù. ïîç. ôàéëà -= 1
        )
        {
            switch ( _ini_szFileContent[nFilePointer]{curFilePos} ) // óçíàåì ÷òî çà ñèìâîë â òåêóù. ïîç. ôàéëà
            {
                case INI_SPACE_CHAR :           continue; // åñëè iòî ïgîáåëüíûé ñèìâîë, ïågåéäåì ê ïgåä. ñèìâîëó ôàéëà
                case INI_STRING_DELIMITER :     break; // åñëè iòî êîíåö ñògîêè
                default : // åñëè iòî ägóãîé ñèìâîë
                {
                    found = 1; // ïîçèöèÿ êîíöà êës÷à íàéäåíà
                    break; // êîíåö öèêëà
                }
            }
        }

        // åñëè ïîçèöèÿ êîíöà êës÷à íå íàéäåíà, ïågåõîä ê ñëåä. ïîçèöèè INI_DELIMITER
        if ( found != 1 ) continue;
        // ----------------


        // ñgàâíèâàåì ïîñèìâîëüíî òåêóùèé êës÷ ôàéëà è óêàçàííûé êës÷
        for ( new curKeyPos = nKeyLen - 1;  curKeyPos >= 0;  curFilePos--, curKeyPos-- )
        {
            if
            (
                    curFilePos < 0 // åñëè ïîç ôàéëà ñòàëà < 0
                ||  _ini_szFileContent[nFilePointer]{curFilePos} != szKeyName[curKeyPos] // åñëè ñèìâîëû èç êës÷åé íå gàâíû
                ||  _ini_szFileContent[nFilePointer]{curFilePos} == INI_STRING_DELIMITER // åñëè ñèìâîë èç êës÷à iòî INI_STRING_DELIMITER
            )
            {
                found = 0; // ôëàã, êës÷ íå íàéäåí
                break; // êîíåö ñgàâíåíèÿ
            }
        }


        if ( found != 0 ) // åñëè óêàçàííûé êës÷ ÍÀÉÄÅÍ â ôàéëå
        {
            // åñëè íàéäåíî ñîâïàäåíèå íå öåëîãî êës÷à ôàéëà, à åãî îêîí÷àíèÿ ñ óêàçàííûì êës÷îì
            if ( curFilePos >= 0 )
            {
                switch ( _ini_szFileContent[nFilePointer]{curFilePos} )
                {
                    case INI_KEY_STARTS : {}
                    default: continue;
                }
            }


            // ----------------
            // òåêóùàÿ ïîçèöèÿ â ôàéëå áóäåò íà 1 áîëüøå òåêóùåé ïîçèöèè INI_DELIMITER
            curFilePos = _ini_nDelimPos[nFilePointer][kPos] + 1;

            // èùåì ïîçèöès íà÷àëà çíà÷åíèÿ, îíà áóäåò ïîìåùåíà â curFilePos
            for ( ; ; curFilePos++ )
            {
                if ( curFilePos >= _ini_nFileSize[nFilePointer] ) break;

                switch ( _ini_szFileContent[nFilePointer]{curFilePos} )
                {
                    case INI_SPACE_CHAR :   continue; // åñëè iòî ïgîáåëüíûé ñèìâîë, ïågåéäåì ê ñëåä. ñèìâîëó
                    default :               break; // åñëè iòî ägóãîé ñèìâîë
                }
            }
            // ----------------


            // ----------------
            new szKeyValue[INI_FLOAT_SIZE]; // ñîçäàäèì ñògîêó äëÿ õgàíåíèÿ ägîáíîãî çíà÷åíèÿ
            format( szKeyValue, INI_FLOAT_SIZE, "%f", fKeyValue ); // ïîìåñòèì ñògîêîâîå çíà÷åíèå fKeyValue â szKeyValue
            // ----------------


            // ----------------
            new nValueLen = strlen(szKeyValue); // óçíàåì gàçìåg çíà÷åíèÿ óêàçàííîãî êës÷à

            // åñëè áóäóùèé gàçìåg ôàéëà ïgåâûøàåò ëèìèò
            if ( ( curFilePos + nValueLen ) >= INI_MAX_FILE_SIZE )
                return INI_TOO_LARGE_FILE; // âågíåì êîä îøèáêè î ïågåïîëíåíèè ôàéëà
            // ----------------


            // ----------------
            new fileValueStartPos = curFilePos; // ñîõgàíèì ïîçèöès íà÷àëà çíà÷åíèÿ

            // èùåì ïîçèöès êîíöà çíà÷åíèÿ, îíà áóäåò ïîìåùåíà â curFilePos
            for ( ; ; curFilePos++ )
            {
                if ( curFilePos >= _ini_nFileSize[nFilePointer] ) break;

                switch ( _ini_szFileContent[nFilePointer]{curFilePos} )
                {
                    case INI_NUMBER_ENDS :  break; // åñëè iòî êîíåö ÷èñëà - ñòîï
                    default :               continue; // åñëè iòî ägóãîé ñèìâîë, ïågåéäåì ê ñëåä. ñèìâîëó
                }
            }

            // âû÷èñëèì ñìåùåíèå îñòàâøèõñÿ ïîçèöèé äëÿ INI_DELIMITER ïîñëå èçìåíåíèÿ çíà÷åíèÿ
            new filePosOffset = nValueLen - ( /*òåêóù äëèíà çíà÷åíèÿ*/ curFilePos - fileValueStartPos );
            // ----------------


            if ( _ini_nFileBusy[nFilePointer] != 0 ) // åñëè ïgÿìî ñåé÷àñ ôàéë èçìåíÿåòñÿ ägóãîé ôóíêöèåé
                return INI_WRITE_ERROR; // âågíåì êîä îøèáêè ïgè çàïèñè â ôàéë


            // ----------------
            _ini_nFileBusy[nFilePointer] = 1; // ôëàã: ôàéë èçìåíÿåòñÿ = 1

            if ( filePosOffset != 0 ) // åñëè äëèíû ñòàgîãî è íîâîãî çíà÷åíèé gàçíûå
            {
                if ( filePosOffset < 0 ) // åñëè äëèíà íîâîãî çíà÷åíèÿ ìåíüøå
                {
                    for // êîïègóåì ñèìâîëû, ñòîÿùèå ïîñëå òåêóùåãî çíà÷åíèÿ íà èõ íîâûå ìåñòà,
                    ( // êîòîgûå òåïågü áóäóò áëèæå ê íà÷àëó ôàéëà
                        ;
                        curFilePos < _ini_nFileSize[nFilePointer];
                        curFilePos++
                    )
                        _ini_szFileContent[nFilePointer]{ curFilePos + filePosOffset } =
                            _ini_szFileContent[nFilePointer]{curFilePos};
                }
                else if ( filePosOffset > 0 ) // åñëè äëèíà íîâîãî çíà÷åíèÿ áîëüøå
                {
                    new fileValueEndPos = curFilePos;

                    for // êîïègóåì ñèìâîëû, ñòîÿùèå ïîñëå òåêóùåãî çíà÷åíèÿ íà èõ íîâûå ìåñòà,
                    ( // íà÷èíàÿ ñ êîíöà ôàéëà
                        curFilePos = _ini_nFileSize[nFilePointer] - 1;
                        curFilePos >= fileValueEndPos;
                        curFilePos--
                    )
                        _ini_szFileContent[nFilePointer]{ curFilePos + filePosOffset } =
                            _ini_szFileContent[nFilePointer]{curFilePos};
                }

                // èçìåíèì ïîçèöèè âñåõ INI_DELIMITER, êîòîgûå íàõîäèëèñü ïîñëå òåêóùåãî INI_DELIMITER
                for ( kPos++;  kPos < _ini_nKeysCount[nFilePointer];  kPos++ )
                    _ini_nDelimPos[nFilePointer][kPos] += filePosOffset;

                _ini_nFileSize[nFilePointer] += filePosOffset; // èçìåíèì gàçìåg ôàéëà
                _ini_szFileContent[nFilePointer]{ _ini_nFileSize[nFilePointer] } = 0; // êîíåö ñògîêè äëÿ êîíöà ôàéëà
            }

            curFilePos = fileValueStartPos; // òåêóù ïîç ôàéëà = ïîç íà÷àëà ñòàgîãî çíà÷åíèÿ
            for // çàïèøåì íîâîå çíà÷åíèå ïîâågõ ñòàgîãî
            (
                new valuePos = 0;
                valuePos < nValueLen;
                curFilePos++, valuePos++
            )
                _ini_szFileContent[nFilePointer]{curFilePos} = szKeyValue[valuePos];

            _ini_nFileChanged[nFilePointer]     = 1; // ôëàã: ôàéë èçìåíåí = 1
            _ini_nFileBusy[nFilePointer]        = 0; // ôëàã: ôàéë èçìåíÿåòñÿ = 0

            return INI_OK;
            // ----------------
        }
    }
    // ----------------


    //
    // åñëè óêàçàííûé êës÷ ÍÅ ÍÀÉÄÅÍ â ôàéëå
    //

    // ----------------
    new szKeyValue[INI_FLOAT_SIZE]; // ñîçäàäèì ñògîêó äëÿ õgàíåíèÿ ägîáíîãî çíà÷åíèÿ
    format( szKeyValue, INI_FLOAT_SIZE, "%f", fKeyValue ); // ïîìåñòèì ñògîêîâîå çíà÷åíèå fKeyValue â szKeyValue
    // ----------------


    // ----------------
    new nValueLen = strlen(szKeyValue); // óçíàåì gàçìåg çíà÷åíèÿ êës÷à

    // åñëè áóäóùèé gàçìåg ôàéëà ïgåâûøàåò ëèìèò
    if ( ( _ini_nFileSize[nFilePointer] + 5 + nKeyLen + nValueLen ) >= INI_MAX_FILE_SIZE )
        return INI_TOO_LARGE_FILE; // âågíåì êîä îøèáêè î ïågåïîëíåíèè ôàéëà
    // ----------------


    // ----------------
    if ( _ini_nFileBusy[nFilePointer] != 0 ) // åñëè ïgÿìî ñåé÷àñ ôàéë èçìåíÿåòñÿ ägóãîé ôóíêöèåé
        return INI_WRITE_ERROR; // âågíåì êîä îøèáêè ïgè çàïèñè â ôàéë

    _ini_nFileBusy[nFilePointer] = 1; // ôëàã: ôàéë èçìåíÿåòñÿ = 1
    // ----------------


    // ----------------
    if // åñëè ïîñëåäíèé ñèìâîë ôàéëà íå ÿâëÿåòñÿ gàçäåëèòåëåì ñògîê
    (
            _ini_nFileSize[nFilePointer] > 0
        &&  _ini_szFileContent[nFilePointer]{ _ini_nFileSize[nFilePointer] - 1 } != INI_STRING_DELIMITER
    )
    {
        // âñòàâèì â êîíåö ôàéëà ïågåâîä êàgåòêè è gàçäåëèòåëü ñògîê
        _ini_szFileContent[nFilePointer]{ _ini_nFileSize[nFilePointer] }        = '\r';
        _ini_szFileContent[nFilePointer]{ _ini_nFileSize[nFilePointer] + 1 }    = INI_STRING_DELIMITER;

        _ini_nFileSize[nFilePointer] += 2; // óâåëè÷èì gàçìåg ôàéëà íà 2
    }

    new curFilePos, strPos; // áóäóò âgåìåííûì õgàíèëèùàìè ïîçèöèé â ôàéëå/êës÷å/çíà÷åíèè

    for // äîáàâèì ïîñèìâîëüíî èìÿ êës÷à â ôàéë
    (
        curFilePos = _ini_nFileSize[nFilePointer], strPos = 0;
        strPos < nKeyLen;
        curFilePos++, strPos++
    )
        _ini_szFileContent[nFilePointer]{curFilePos} = szKeyName[strPos];

    _ini_szFileContent[nFilePointer]{ curFilePos++ }                = ' '; // ïîñëå êës÷à äîáàâèì ïgîáåë

    _ini_nDelimPos[nFilePointer][ _ini_nKeysCount[nFilePointer] ]   = curFilePos; // äîáàâèì íîâós ïîçèöès INI_DELIMITER
    _ini_nKeysCount[nFilePointer]++; // êîë-âî êës÷åé â ôàéëå +1

    _ini_szFileContent[nFilePointer]{ curFilePos++ }                = INI_DELIMITER; // ïîñëå ïgîáåëà âûøå äîáàâèì INI_DELIMITER
    _ini_szFileContent[nFilePointer]{ curFilePos++ }                = ' '; // ïîñëå INI_DELIMITER äîáàâèì ïgîáåë

    // äîáàâèì ïîñèìâîëüíî çíà÷åíèå êës÷à â ôàéë
    for ( strPos = 0;  strPos < nValueLen;  curFilePos++, strPos++ )
        _ini_szFileContent[nFilePointer]{curFilePos} = szKeyValue[strPos];

    _ini_szFileContent[nFilePointer]{curFilePos}    = 0; // äîáàâèì ñèìâîë êîíöà ñògîêè
    _ini_nFileSize[nFilePointer]                    = curFilePos; // èçìåíèì gàçìåg ôàéëà
    _ini_nFileChanged[nFilePointer]                 = 1; // ôëàã: ôàéë èçìåíåí = 1
    _ini_nFileBusy[nFilePointer]                    = 0; // ôëàã: ôàéë èçìåíÿåòñÿ = 0

    return INI_OK;
    // ----------------
}




/*
    Óäàëÿåò èç îòêgûòîãî INI ôàéëà óêàçàííûé êës÷ è åãî çíà÷åíèå.

    ÏÎÄGÎÁÍÅÅ
        Ïàgñåg èùåò â ÎÇÓ â êîíòåíòå ôàéëà óêàçàííûé êës÷ è óäàëÿåò íàéäåííós
        ïàgó êës÷/çíà÷åíèå.

        Èìÿ êës÷à/çíà÷åíèå â ôàéëå ìîæåò áûòü ësáîé äëèíû,
        à òàêæå ìîæåò ñîäågæàòü ësáûå ñèìâîëû, êgîìå 2 ñèìâîëîâ êîíöà ñògîêè \r è \n.

        Åñëè iòè ñèìâîëû åñòü â èìåíè êës÷à èëè â çíà÷åíèè,
        âû äîëæíû äîëæíû õîgîøî çíàòü è îñîçíàâàòü ïîñëåäñòâèÿ.

    ÏÀGÀÌÅÒGÛ:
        nFilePointer        ÈÄ_îòêgûòîãî_ôàéëà, ïîëó÷åííûé îò ini_openFile / ini_createFile
        szKeyName[]         èìÿ êës÷à

    ÂÅGÍÅÒ:
        êîä îøèáêè < 0 èëè 0 ïgè óñïåõå
*/

stock ini_removeKey ( nFilePointer, szKeyName[] )
{
    // ----------------
    if // åñëè ÈÄ îòêgûòîãî ôàéëà óêàçàí íåâågíî
    (
            nFilePointer < 0
        ||  nFilePointer >= INI_MAX_OPENED_FILES
        ||  _ini_nSlotUsed[nFilePointer] != 1
    )
        return INI_WRONG_SLOT; // âågíóòü êîä: íåâågíûé óêàçàòåëü íà îòêgûòûé ôàéë
    // ----------------


    // ----------------
    new nKeyLen = strlen(szKeyName); // óçíàåì äëèíó èìåíè óêàçàííîãî êës÷à

    if ( nKeyLen <= 0 ) // åñëè óêàçàí ïóñòîé êës÷
        return INI_KEY_NOT_FOUND;
    // ----------------


    // ----------------
    for // ïågåáîg è ñgàâíåíèå âñåõ êës÷åé ôàéëà ñ óêàçàííûì êës÷îì
    (
        new kPos = 0, curFilePos, found;
        kPos < _ini_nKeysCount[nFilePointer];
        kPos++
    )
    {
        // ----------------
        found = 0; // ôëàã, íàéäåíà ëè ïîçèöèÿ êîíöà êës÷à = 0

        for // èùåì ïîçèöès êîíöà êës÷à
        (
            curFilePos = _ini_nDelimPos[nFilePointer][kPos] - 1; // òåêóù. ïîç. ôàéëà = ïîç. òåêóù. INI_DELIMITER - 1
            curFilePos >= 0; // ïgîäîëæàòü ïîêà ïîç. ôàéëà >= 0
            curFilePos-- // ïîñëå êàæäîãî ïîâòîgà òåêóù. ïîç. ôàéëà -= 1
        )
        {
            switch ( _ini_szFileContent[nFilePointer]{curFilePos} ) // óçíàåì ÷òî çà ñèìâîë â òåêóù. ïîç. ôàéëà
            {
                case INI_SPACE_CHAR :           continue; // åñëè iòî ïgîáåëüíûé ñèìâîë, ïågåéäåì ê ïgåä. ñèìâîëó ôàéëà
                case INI_STRING_DELIMITER :     break; // åñëè iòî êîíåö ñògîêè
                default : // åñëè iòî ägóãîé ñèìâîë
                {
                    found = 1; // ïîçèöèÿ êîíöà êës÷à íàéäåíà
                    break; // êîíåö öèêëà
                }
            }
        }

        // åñëè ïîçèöèÿ êîíöà êës÷à íå íàéäåíà, ïågåõîä ê ñëåä. ïîçèöèè INI_DELIMITER
        if ( found != 1 ) continue;
        // ----------------


        // ñgàâíèâàåì ïîñèìâîëüíî òåêóùèé êës÷ ôàéëà è óêàçàííûé êës÷
        for ( new curKeyPos = nKeyLen - 1;  curKeyPos >= 0;  curFilePos--, curKeyPos-- )
        {
            if
            (
                    curFilePos < 0 // åñëè ïîç ôàéëà ñòàëà < 0
                ||  _ini_szFileContent[nFilePointer]{curFilePos} != szKeyName[curKeyPos] // åñëè ñèìâîëû èç êës÷åé íå gàâíû
                ||  _ini_szFileContent[nFilePointer]{curFilePos} == INI_STRING_DELIMITER // åñëè ñèìâîë èç êës÷à iòî INI_STRING_DELIMITER
            )
            {
                found = 0; // ôëàã, êës÷ íå íàéäåí
                break; // êîíåö ñgàâíåíèÿ
            }
        }


        if ( found != 0 ) // åñëè óêàçàííûé êës÷ ÍÀÉÄÅÍ â ôàéëå
        {
            // åñëè íàéäåíî ñîâïàäåíèå íå öåëîãî êës÷à ôàéëà, à åãî îêîí÷àíèÿ ñ óêàçàííûì êës÷îì
            if ( curFilePos >= 0 )
            {
                switch ( _ini_szFileContent[nFilePointer]{curFilePos} )
                {
                    case INI_KEY_STARTS : {}
                    default: continue;
                }
            }


            // ñîõgàíèì ïîçèöès íà÷àëà êës÷à
            new keyStartPos = ( curFilePos <= 0 ) ? 0 : curFilePos + 1;


            // ----------------
            // òåêóùàÿ ïîçèöèÿ â ôàéëå áóäåò íà 1 áîëüøå òåêóùåé ïîçèöèè INI_DELIMITER
            curFilePos = _ini_nDelimPos[nFilePointer][kPos] + 1;

            // èùåì ïîçèöès íà÷àëà çíà÷åíèÿ, îíà áóäåò ïîìåùåíà â curFilePos
            for ( ; ; curFilePos++ )
            {
                if ( curFilePos >= _ini_nFileSize[nFilePointer] ) break;

                switch ( _ini_szFileContent[nFilePointer]{curFilePos} )
                {
                    case INI_SPACE_CHAR :   continue; // åñëè iòî ïgîáåëüíûé ñèìâîë, ïågåéäåì ê ñëåä. ñèìâîëó
                    default :               break; // åñëè iòî ägóãîé ñèìâîë
                }
            }
            // ----------------


            // ----------------
            // èùåì ïîçèöès êîíöà çíà÷åíèÿ, îíà áóäåò ïîìåùåíà â curFilePos
            for ( ; ; curFilePos++ )
            {
                if ( curFilePos >= _ini_nFileSize[nFilePointer] ) break;

                switch ( _ini_szFileContent[nFilePointer]{curFilePos} )
                {
                    case INI_STRING_ENDS :  break; // åñëè iòî êîíåö ñògîêè - ñòîï
                    default :               continue; // åñëè iòî ägóãîé ñèìâîë, ïågåéäåì ê ñëåä. ñèìâîëó
                }
            }

            // âû÷èñëèì ñìåùåíèå îñòàâøèõñÿ ïîçèöèé äëÿ INI_DELIMITER ïîñëå èçìåíåíèÿ çíà÷åíèÿ
            new filePosOffset = keyStartPos - curFilePos;
            // ----------------


            if ( _ini_nFileBusy[nFilePointer] != 0 ) // åñëè ïgÿìî ñåé÷àñ ôàéë èçìåíÿåòñÿ ägóãîé ôóíêöèåé
                return INI_WRITE_ERROR; // âågíåì êîä îøèáêè ïgè çàïèñè â ôàéë


            // ----------------
            _ini_nFileBusy[nFilePointer] = 1; // ôëàã: ôàéë èçìåíÿåòñÿ = 1

            // çàòègàåì êîíòåíò êës÷à, ñëåäósùèìè çà íèì äàííûìè ôàéëà
            for ( ; curFilePos <= _ini_nFileSize[nFilePointer]; curFilePos++ )
                _ini_szFileContent[nFilePointer]{ curFilePos + filePosOffset } =
                    _ini_szFileContent[nFilePointer]{curFilePos};

            // çàòègàåì òåêóùèé INI_DELIMITER, è ìåíÿåì ïîçèöèè ïîñëåäósùèõ INI_DELIMITER
            for ( ;  kPos < _ini_nKeysCount[nFilePointer];  kPos++ )
                _ini_nDelimPos[nFilePointer][kPos] = _ini_nDelimPos[nFilePointer][kPos + 1] + filePosOffset;

            _ini_nKeysCount[nFilePointer]--;
            _ini_nFileSize[nFilePointer] += filePosOffset; // èçìåíèì gàçìåg ôàéëà
            _ini_szFileContent[nFilePointer]{ _ini_nFileSize[nFilePointer] } = 0; // êîíåö ñògîêè äëÿ êîíöà ôàéëà

            _ini_nFileChanged[nFilePointer]     = 1; // ôëàã: ôàéë èçìåíåí = 1
            _ini_nFileBusy[nFilePointer]        = 0; // ôëàã: ôàéë èçìåíÿåòñÿ = 0

            return INI_OK;
            // ----------------
        }
    }
    // ----------------


    //
    // åñëè óêàçàííûé êës÷ ÍÅ ÍÀÉÄÅÍ â ôàéëå
    //

    // ----------------
    return INI_KEY_NOT_FOUND;
    // ----------------
}




/*
    Âîçâgàùàåò ñògîêó ñ îïèñàíèåì óêàçàííîãî êîäà îøèáêè íà góññêîì ÿçûêå.

    ÏÎÄGÎÁÍÅÅ
        Åñëè êàêàÿ-òî ôóíêöèÿ âàì âågíóëà íå 0 (âñ¸ â ïîgÿäêå), à îògèöàòåëüíîå
        çíà÷åíèå, çíà÷èò, èìåëà ìåñòî îøèáêà. Åñëè âû õîòèòå âûâåñòè â ësáîé ëîã èëè
        â äèàëîã ÷åëîâå÷åñêîå îïèñàíèå iòîé îøèáêè, òî ïågåäàéòå iòîé ôóíêöèè êîä
        îøèáêè è îíà âàì âågíåò îïèñàíèå iòîé îøèáêè íà góññêîì ÿçûêå.

        Îïèñàíèå îøèáîê äîâîëüíî äëèííûå è ïgåâûøàsò gàçìåg â 128 ñèìâîëîâ,
        ïîiòîìó âûâîäèòü iòè îïèñàíèÿ â ÷àòå íå gåêîìåíäóåòñÿ!

    ÏÀGÀÌÅÒGÛ:
        nErrorCode      êîä îøèáêè, ïîëó÷åííûé îò ësáîé ôóíêöèè

    ÂÅGÍÅÒ:
        ñògîêó ñ ÷åëîâå÷åñêèì îïèñàíèåì îøèáêè, ïîä óêàçàííûì êîäîì

    ÏGÈÌÅG:
        new ini = ini_openFile("íåñóùåñòâósùèé ôàéë"); // ïûòàåìñÿ îòêgûòü íåñóùåñòâósùèé ôàéë

        if ( ini < 0 ) print( ini_getErrorInfo(ini) );
        else
        {
            new number, result = ini_getInteger( ini, "íåñóùåñòâósùèé êës÷", number ); // ïgîáóåì ïîëó÷èòü çíà÷åíèå íåñóùåñòâósùåãî êës÷à

            if ( result < 0 ) print( ini_getErrorInfo(result) );

            ini_closeFile(ini);
        }
*/

stock ini_getErrorInfo ( nErrorCode )
{
    new error_ms[200] = "Îøèáîê íåò";

    if ( nErrorCode >= 0 ) return error_ms;

    switch ( nErrorCode )
    {
        case INI_FILE_NOT_FOUND :     error_ms = "INI ôàéë, óêàçàííûé â `ini_openFile`, íå ñóùåñòâóåò, âîçìîæíî, óêàçàí íåâågíûé ïóòü ê íåìó";
        case INI_FILE_ALREADY_EXIST : error_ms = "INI ôàéë, óêàçàííûé â `ini_createFile`, óæå ñóùåñòâóåò, óêàæèòå ägóãîå èìÿ/ïóòü ê ôàéëó";
        case INI_TOO_LARGE_FILE :     error_ms = "Íåâîçìîæíî äîáàâèòü íîâûé êës÷ â INI ôàéë, ò.ê. gàçìåg INI ôàéëà ïgåâûñèò äîïóñòèìûé ëèìèò â " #INI_MAX_FILE_SIZE " ñèìâîë(îâ), èëè áóäåò ïgåâûøåí ëèìèò â " #INI_MAX_KEYS_IN_FILE " êës÷åé";
        case INI_WRONG_PATH_SIZE :    error_ms = "Äëèíà ïóòè ê INI ôàéëó, óêàçàííîãî â `ini_openFile` / `ini_createFile`, ïgåâûøàåò ëèìèò â " #INI_MAX_FILENAME_SIZE " ñèìâîë(îâ)";
        case INI_READ_ERROR :         error_ms = "Îøèáêà ïgè ÷òåíèè INI ôàéëà ñ äèñêà, âîçìîæíî, ôàéë çàíÿò ägóãèì ïgîöåññîì";
        case INI_WRITE_ERROR :        error_ms = "Îøèáêà ïgè çàïèñè ñîäågæèìîãî INI ôàéëà íà äèñê, âîçìîæíî, ôàéë çàíÿò ägóãèì ïgîöåññîì";
        case INI_NO_FREE_SLOT :       error_ms = "Ëèìèò â " #INI_MAX_OPENED_FILES " îäíîâgåìåííî îòêgûòûõ INI ôàéëîâ èñ÷ågïàí, ïîiòîìó îòêgûòü/ñîçäàòü åùå 1 ôàéë íåëüçÿ, ïîêà íå çàêgûò õîòü 1 èç îòêgûòûõ ôàéëîâ";
        case INI_WRONG_SLOT :         error_ms = "Óêàçàí íåâågíûé ID îòêgûòîãî INI ôàéëà, âîçìîæíî, ïgè îòêgûòèè INI ôàéëà ïgîèçîøëà îøèáêà, ïîiòîìó âìåñòî ID ôàéëà âû ïîëó÷èëè êîä îøèáêè";
        case INI_KEY_NOT_FOUND :      error_ms = "Óêàçàííûé êës÷ íå íàéäåí â îòêgûòîì INI ôàéëå";
        case INI_WRONG_RETURN_SIZE :  error_ms = "Ïgè ïîïûòêå ÷òåíèÿ ñògîêîâîãî çíà÷åíèÿ èç INI ôàéëà, ïîñëåäíèé ïàgàìåòg `nSizeOfReturn` â `ini_getString` îêàçàëñÿ <= 0, óêàæèòå âgó÷íós çíà÷åíèå > 0 äëÿ íåãî";

        default:                      error_ms = "Íåèçâåñòíàÿ îøèáêà";
    }

    return error_ms;
}
stock LoadModelSelectionMenu(f_name[])
{
	new File:f, str[75];
	format(str, sizeof(str), "%s", f_name);
	f = fopen(str, io_read);
	if( !f ) {
		printf("-mSelection- WARNING: Khong the tai danh sach: \"%s\"", f_name);
		return mS_INVALID_LISTID;
	}

	if(gListAmount >= mS_TOTAL_LISTS)
	{
		printf("-mSelection- WARNING: Reached maximum amount of lists, increase \"mS_TOTAL_LISTS\"", f_name);
		return mS_INVALID_LISTID;
	}
	new tmp_ItemAmount = gItemAmount; // copy value if loading fails


	new line[128], idxx;
	while(fread(f,line,sizeof(line),false))
	{
		if(tmp_ItemAmount >= mS_TOTAL_ITEMS)
		{
			printf("-mSelection- WARNING: Reached maximum amount of items, increase \"mS_TOTAL_ITEMS\"", f_name);
			break;
		}
		idxx = 0;
		if(!line[0]) continue;
		new mID = strval( mS_strtok(line,idxx) );
		if(0 <= mID < 20000)
		{
			gItemList[tmp_ItemAmount][mS_ITEM_MODEL] = mID;

			new tmp_mS_strtok[20];
			new Float:mRotation[3], Float:mZoom = 1.0;
			new bool:useRotation = false;

			tmp_mS_strtok = mS_strtok(line,idxx);
			if(tmp_mS_strtok[0]) {
				useRotation = true;
				mRotation[0] = floatstr(tmp_mS_strtok);
			}
			tmp_mS_strtok = mS_strtok(line,idxx);
			if(tmp_mS_strtok[0]) {
				useRotation = true;
				mRotation[1] = floatstr(tmp_mS_strtok);
			}
			tmp_mS_strtok = mS_strtok(line,idxx);
			if(tmp_mS_strtok[0]) {
				useRotation = true;
				mRotation[2] = floatstr(tmp_mS_strtok);
			}
			tmp_mS_strtok = mS_strtok(line,idxx);
			if(tmp_mS_strtok[0]) {
				useRotation = true;
				mZoom = floatstr(tmp_mS_strtok);
			}
			if(useRotation)
			{
				new bool:foundRotZoom = false;
				for(new i=0; i < gRotZoomAmount; i++)
				{
					if(gRotZoom[i][0] == mRotation[0] && gRotZoom[i][1] == mRotation[1] && gRotZoom[i][2] == mRotation[2] && gRotZoom[i][3] == mZoom)
					{
						foundRotZoom = true;
						gItemList[tmp_ItemAmount][mS_ITEM_ROT_ZOOM_ID] = i;
						break;
					}
				}
				if(gRotZoomAmount < mS_TOTAL_ROT_ZOOM)
				{
					if(!foundRotZoom)
					{
						gRotZoom[gRotZoomAmount][0] = mRotation[0];
						gRotZoom[gRotZoomAmount][1] = mRotation[1];
						gRotZoom[gRotZoomAmount][2] = mRotation[2];
						gRotZoom[gRotZoomAmount][3] = mZoom;
						gItemList[tmp_ItemAmount][mS_ITEM_ROT_ZOOM_ID] = gRotZoomAmount;
						gRotZoomAmount++;
					}
				}
				else print("-mSelection- WARNING: Not able to save rotation/zoom information. Reached maximum rotation/zoom information count. Increase '#define mS_TOTAL_ROT_ZOOM' to fix the issue");
			}
			else gItemList[tmp_ItemAmount][mS_ITEM_ROT_ZOOM_ID] = -1;
			tmp_ItemAmount++;
		}
	}
	if(tmp_ItemAmount > gItemAmount) // any models loaded ?
	{
		gLists[gListAmount][mS_LIST_START] = gItemAmount;
		gItemAmount = tmp_ItemAmount; // copy back
		gLists[gListAmount][mS_LIST_END] = (gItemAmount-1);

		gListAmount++;
		return (gListAmount-1);
	}
	printf("-mSelection- WARNING: Khong co item duoc tim thay trong tap tin: %s", f_name);
	return mS_INVALID_LISTID;
}



stock mS_strtok(const string[], &index)
{
	new length = strlen(string);
	while ((index < length) && (string[index] <= ' '))
	{
		index++;
	}

	new offset = index;
	new result[20];
	while ((index < length) && (string[index] > ' ') && ((index - offset) < (sizeof(result) - 1)))
	{
		result[index - offset] = string[index];
		index++;
	}
	result[index - offset] = EOS;
	return result;
}

stock mS_GetNumberOfPages(ListID)
{
	new ItemAmount = mS_GetAmountOfListItems(ListID);
	if((ItemAmount >= mS_SELECTION_ITEMS) && (ItemAmount % mS_SELECTION_ITEMS) == 0)
	{
		return (ItemAmount / mS_SELECTION_ITEMS);
	}
	else return (ItemAmount / mS_SELECTION_ITEMS) + 1;
}

stock mS_GetNumberOfPagesEx(playerid)
{
	new ItemAmount = mS_GetAmountOfListItemsEx(playerid);
	if((ItemAmount >= mS_SELECTION_ITEMS) && (ItemAmount % mS_SELECTION_ITEMS) == 0)
	{
		return (ItemAmount / mS_SELECTION_ITEMS);
	}
	else return (ItemAmount / mS_SELECTION_ITEMS) + 1;
}

stock mS_GetAmountOfListItems(ListID)
{
	return (gLists[ListID][mS_LIST_END] - gLists[ListID][mS_LIST_START])+1;
}

stock mS_GetAmountOfListItemsEx(playerid)
{
	return GetPVarInt(playerid, "mS_custom_item_amount");
}

stock mS_GetPlayerCurrentListID(playerid)
{
	if(GetPVarInt(playerid, "mS_list_active") == 1) return GetPVarInt(playerid, "mS_list_id");
	else return mS_INVALID_LISTID;
}

stock PlayerText:mS_CreateCurrentPageTextDraw(playerid, Float:Xpos, Float:Ypos)
{
	new PlayerText:txtInit;
   	txtInit = CreatePlayerTextDraw(playerid, Xpos, Ypos, "0/0");
   	PlayerTextDrawUseBox(playerid, txtInit, 0);
	PlayerTextDrawLetterSize(playerid, txtInit, 0.4, 1.1);
	PlayerTextDrawFont(playerid, txtInit, 1);
	PlayerTextDrawSetShadow(playerid, txtInit, 0);
    PlayerTextDrawSetOutline(playerid, txtInit, 1);
    PlayerTextDrawColor(playerid, txtInit, 0xACCBF1FF);
    PlayerTextDrawShow(playerid, txtInit);
    return txtInit;
}

stock PlayerText:mS_CreatePlayerDialogButton(playerid, Float:Xpos, Float:Ypos, Float:Width, Float:Height, button_text[])
{
 	new PlayerText:txtInit;
   	txtInit = CreatePlayerTextDraw(playerid, Xpos, Ypos, button_text);
   	PlayerTextDrawUseBox(playerid, txtInit, 1);
   	PlayerTextDrawBoxColor(playerid, txtInit, 0x000000FF);
   	PlayerTextDrawBackgroundColor(playerid, txtInit, 0x000000FF);
	PlayerTextDrawLetterSize(playerid, txtInit, 0.4, 1.1);
	PlayerTextDrawFont(playerid, txtInit, 1);
	PlayerTextDrawSetShadow(playerid, txtInit, 0); // no shadow
    PlayerTextDrawSetOutline(playerid, txtInit, 0);
    PlayerTextDrawColor(playerid, txtInit, 0x4A5A6BFF);
    PlayerTextDrawSetSelectable(playerid, txtInit, 1);
    PlayerTextDrawAlignment(playerid, txtInit, 2);
    PlayerTextDrawTextSize(playerid, txtInit, Height, Width); // The width and height are reversed for centering.. something the game does <g>
    PlayerTextDrawShow(playerid, txtInit);
    return txtInit;
}

stock PlayerText:mS_CreatePlayerHeaderTextDraw(playerid, Float:Xpos, Float:Ypos, header_text[])
{
	new PlayerText:txtInit;
   	txtInit = CreatePlayerTextDraw(playerid, Xpos, Ypos, header_text);
   	PlayerTextDrawUseBox(playerid, txtInit, 0);
	PlayerTextDrawLetterSize(playerid, txtInit, 1.25, 3.0);
	PlayerTextDrawFont(playerid, txtInit, 0);
	PlayerTextDrawSetShadow(playerid, txtInit, 0);
    PlayerTextDrawSetOutline(playerid, txtInit, 1);
    PlayerTextDrawColor(playerid, txtInit, 0xACCBF1FF);
    PlayerTextDrawShow(playerid, txtInit);
    return txtInit;
}

stock PlayerText:mS_CreatePlayerBGTextDraw(playerid, Float:Xpos, Float:Ypos, Float:Width, Float:Height, bgcolor)
{
	new PlayerText:txtBackground = CreatePlayerTextDraw(playerid, Xpos, Ypos,"                                            ~n~"); // enough space for everyone
    PlayerTextDrawUseBox(playerid, txtBackground, 1);
    PlayerTextDrawBoxColor(playerid, txtBackground, bgcolor);
	PlayerTextDrawLetterSize(playerid, txtBackground, 5.0, 5.0);
	PlayerTextDrawFont(playerid, txtBackground, 0);
	PlayerTextDrawSetShadow(playerid, txtBackground, 0);
    PlayerTextDrawSetOutline(playerid, txtBackground, 0);
    PlayerTextDrawColor(playerid, txtBackground,0x000000FF);
    PlayerTextDrawTextSize(playerid, txtBackground, Width, Height);
   	PlayerTextDrawBackgroundColor(playerid, txtBackground, bgcolor);
    PlayerTextDrawShow(playerid, txtBackground);
    return txtBackground;
}

stock PlayerText:mS_CreateMPTextDraw(playerid, modelindex, Float:Xpos, Float:Ypos, Float:Xrot, Float:Yrot, Float:Zrot, Float:mZoom, Float:width, Float:height, bgcolor)
{
    new PlayerText:txtPlayerSprite = CreatePlayerTextDraw(playerid, Xpos, Ypos, ""); // it has to be set with SetText later
    PlayerTextDrawFont(playerid, txtPlayerSprite, TEXT_DRAW_FONT_MODEL_PREVIEW);
    PlayerTextDrawColor(playerid, txtPlayerSprite, 0xFFFFFFFF);
    PlayerTextDrawBackgroundColor(playerid, txtPlayerSprite, bgcolor);
    PlayerTextDrawTextSize(playerid, txtPlayerSprite, width, height); // Text size is the Width:Height
    PlayerTextDrawSetPreviewModel(playerid, txtPlayerSprite, modelindex);
    PlayerTextDrawSetPreviewRot(playerid,txtPlayerSprite, Xrot, Yrot, Zrot, mZoom);
    PlayerTextDrawSetSelectable(playerid, txtPlayerSprite, 1);
    PlayerTextDrawShow(playerid,txtPlayerSprite);
    return txtPlayerSprite;
}

stock mS_DestroyPlayerMPs(playerid)
{
	new x=0;
	while(x != mS_SELECTION_ITEMS) {
	    if(gSelectionItems[playerid][x] != PlayerText:INVALID_TEXT_DRAW) {
			PlayerTextDrawDestroy(playerid, gSelectionItems[playerid][x]);
			gSelectionItems[playerid][x] = PlayerText:INVALID_TEXT_DRAW;
		}
		x++;
	}
}

stock mS_ShowPlayerMPs(playerid)
{
	new bgcolor = GetPVarInt(playerid, "mS_previewBGcolor");
    new x=0;
	new Float:BaseX = mS_DIALOG_BASE_X;
	new Float:BaseY = mS_DIALOG_BASE_Y - (mS_SPRITE_DIM_Y * 0.33); // down a bit
	new linetracker = 0;

	new mS_listID = mS_GetPlayerCurrentListID(playerid);
	if(mS_listID == mS_CUSTOM_LISTID)
	{
		new itemat = (GetPVarInt(playerid, "mS_list_page") * mS_SELECTION_ITEMS);
		new Float:rotzoom[4];
		rotzoom[0] = GetPVarFloat(playerid, "mS_custom_Xrot");
		rotzoom[1] = GetPVarFloat(playerid, "mS_custom_Yrot");
		rotzoom[2] = GetPVarFloat(playerid, "mS_custom_Zrot");
		rotzoom[3] = GetPVarFloat(playerid, "mS_custom_Zoom");
		new itemamount = mS_GetAmountOfListItemsEx(playerid);
		// Destroy any previous ones created
		mS_DestroyPlayerMPs(playerid);

		while(x != mS_SELECTION_ITEMS && itemat < (itemamount)) {
			if(linetracker == 0) {
				BaseX = mS_DIALOG_BASE_X + 25.0; // in a bit from the box
				BaseY += mS_SPRITE_DIM_Y + 1.0; // move on the Y for the next line
			}
			gSelectionItems[playerid][x] = mS_CreateMPTextDraw(playerid, gCustomList[playerid][itemat], BaseX, BaseY, rotzoom[0], rotzoom[1], rotzoom[2], rotzoom[3], mS_SPRITE_DIM_X, mS_SPRITE_DIM_Y, bgcolor);
			gSelectionItemsTag[playerid][x] = gCustomList[playerid][itemat];
			BaseX += mS_SPRITE_DIM_X + 1.0; // move on the X for the next sprite
			linetracker++;
			if(linetracker == mS_ITEMS_PER_LINE) linetracker = 0;
			itemat++;
			x++;
		}
	}
	else
	{
		new itemat = (gLists[mS_listID][mS_LIST_START] + (GetPVarInt(playerid, "mS_list_page") * mS_SELECTION_ITEMS));

		// Destroy any previous ones created
		mS_DestroyPlayerMPs(playerid);

		while(x != mS_SELECTION_ITEMS && itemat < (gLists[mS_listID][mS_LIST_END]+1)) {
			if(linetracker == 0) {
				BaseX = mS_DIALOG_BASE_X + 25.0; // in a bit from the box
				BaseY += mS_SPRITE_DIM_Y + 1.0; // move on the Y for the next line
			}
			new rzID = gItemList[itemat][mS_ITEM_ROT_ZOOM_ID]; // avoid long line
			if(rzID > -1) gSelectionItems[playerid][x] = mS_CreateMPTextDraw(playerid, gItemList[itemat][mS_ITEM_MODEL], BaseX, BaseY, gRotZoom[rzID][0], gRotZoom[rzID][1], gRotZoom[rzID][2], gRotZoom[rzID][3], mS_SPRITE_DIM_X, mS_SPRITE_DIM_Y, bgcolor);
			else gSelectionItems[playerid][x] = mS_CreateMPTextDraw(playerid, gItemList[itemat][mS_ITEM_MODEL], BaseX, BaseY, 0.0, 0.0, 0.0, 1.0, mS_SPRITE_DIM_X, mS_SPRITE_DIM_Y, bgcolor);
			gSelectionItemsTag[playerid][x] = gItemList[itemat][mS_ITEM_MODEL];
			BaseX += mS_SPRITE_DIM_X + 1.0; // move on the X for the next sprite
			linetracker++;
			if(linetracker == mS_ITEMS_PER_LINE) linetracker = 0;
			itemat++;
			x++;
		}
	}
}

stock mS_UpdatePageTextDraw(playerid)
{
	new PageText[64+1];
	new listID = mS_GetPlayerCurrentListID(playerid);
	if(listID == mS_CUSTOM_LISTID)
	{
		format(PageText, 64, "%d/%d", GetPVarInt(playerid,"mS_list_page") + 1, mS_GetNumberOfPagesEx(playerid));
		PlayerTextDrawSetString(playerid, gCurrentPageTextDrawId[playerid], PageText);
	}
	else
	{
		format(PageText, 64, "%d/%d", GetPVarInt(playerid,"mS_list_page") + 1, mS_GetNumberOfPages(listID));
		PlayerTextDrawSetString(playerid, gCurrentPageTextDrawId[playerid], PageText);
	}
}

stock ShowModelSelectionMenu(playerid, ListID, header_text[], dialogBGcolor = 0x4A5A6BBB, previewBGcolor = 0x88888899 , tdSelectionColor = 0xFFFF00AA)
{
	if(!(0 <= ListID < mS_TOTAL_LISTS && gLists[ListID][mS_LIST_START] != gLists[ListID][mS_LIST_END])) return 0;
	mS_DestroySelectionMenu(playerid);
	SetPVarInt(playerid, "mS_list_page", 0);
	SetPVarInt(playerid, "mS_list_id", ListID);
	SetPVarInt(playerid, "mS_list_active", 1);
	SetPVarInt(playerid, "mS_list_time", GetTickCount());

    gBackgroundTextDrawId[playerid] = mS_CreatePlayerBGTextDraw(playerid, mS_DIALOG_BASE_X, mS_DIALOG_BASE_Y + 20.0, mS_DIALOG_WIDTH, mS_DIALOG_HEIGHT, dialogBGcolor);
    gHeaderTextDrawId[playerid] = mS_CreatePlayerHeaderTextDraw(playerid, mS_DIALOG_BASE_X, mS_DIALOG_BASE_Y, header_text);
    gCurrentPageTextDrawId[playerid] = mS_CreateCurrentPageTextDraw(playerid, mS_DIALOG_WIDTH - 30.0, mS_DIALOG_BASE_Y + 15.0);
    gNextButtonTextDrawId[playerid] = mS_CreatePlayerDialogButton(playerid, mS_DIALOG_WIDTH - 30.0, mS_DIALOG_BASE_Y+mS_DIALOG_HEIGHT+100.0, 50.0, 16.0, mS_NEXT_TEXT);
    gPrevButtonTextDrawId[playerid] = mS_CreatePlayerDialogButton(playerid, mS_DIALOG_WIDTH - 90.0, mS_DIALOG_BASE_Y+mS_DIALOG_HEIGHT+100.0, 50.0, 16.0, mS_PREV_TEXT);
    gCancelButtonTextDrawId[playerid] = mS_CreatePlayerDialogButton(playerid, mS_DIALOG_WIDTH - 150.0, mS_DIALOG_BASE_Y+mS_DIALOG_HEIGHT+100.0, 50.0, 16.0, mS_CANCEL_TEXT);

	SetPVarInt(playerid, "mS_previewBGcolor", previewBGcolor);
    mS_ShowPlayerMPs(playerid);
    mS_UpdatePageTextDraw(playerid);

	SelectTextDraw(playerid, tdSelectionColor);
	return 1;
}

stock ShowModelSelectionMenuEx(playerid, items_array[], item_amount, header_text[], extraid, Float:Xrot = 0.0, Float:Yrot = 0.0, Float:Zrot = 0.0, Float:mZoom = 1.0, dialogBGcolor = 0x4A5A6BBB, previewBGcolor = 0x88888899 , tdSelectionColor = 0xFFFF00AA)
{
	mS_DestroySelectionMenu(playerid);
	if(item_amount > mS_CUSTOM_MAX_ITEMS)
	{
		item_amount = mS_CUSTOM_MAX_ITEMS;
		print("-mSelection- WARNING: Too many items given to \"ShowModelSelectionMenuEx\", increase \"mS_CUSTOM_MAX_ITEMS\" to fix this");
	}
	if(item_amount > 0)
	{
		for(new i=0;i<item_amount;i++)
		{
			gCustomList[playerid][i] = items_array[i];
		}
		SetPVarInt(playerid, "mS_list_page", 0);
		SetPVarInt(playerid, "mS_list_id", mS_CUSTOM_LISTID);
		SetPVarInt(playerid, "mS_list_active", 1);
		SetPVarInt(playerid, "mS_list_time", GetTickCount());

		SetPVarInt(playerid, "mS_custom_item_amount", item_amount);
		SetPVarFloat(playerid, "mS_custom_Xrot", Xrot);
		SetPVarFloat(playerid, "mS_custom_Yrot", Yrot);
		SetPVarFloat(playerid, "mS_custom_Zrot", Zrot);
		SetPVarFloat(playerid, "mS_custom_Zoom", mZoom);
		SetPVarInt(playerid, "mS_custom_extraid", extraid);


		gBackgroundTextDrawId[playerid] = mS_CreatePlayerBGTextDraw(playerid, mS_DIALOG_BASE_X, mS_DIALOG_BASE_Y + 20.0, mS_DIALOG_WIDTH, mS_DIALOG_HEIGHT, dialogBGcolor);
		gHeaderTextDrawId[playerid] = mS_CreatePlayerHeaderTextDraw(playerid, mS_DIALOG_BASE_X, mS_DIALOG_BASE_Y, header_text);
		gCurrentPageTextDrawId[playerid] = mS_CreateCurrentPageTextDraw(playerid, mS_DIALOG_WIDTH - 30.0, mS_DIALOG_BASE_Y + 15.0);
		gNextButtonTextDrawId[playerid] = mS_CreatePlayerDialogButton(playerid, mS_DIALOG_WIDTH - 30.0, mS_DIALOG_BASE_Y+mS_DIALOG_HEIGHT+100.0, 50.0, 16.0, mS_NEXT_TEXT);
		gPrevButtonTextDrawId[playerid] = mS_CreatePlayerDialogButton(playerid, mS_DIALOG_WIDTH - 90.0, mS_DIALOG_BASE_Y+mS_DIALOG_HEIGHT+100.0, 50.0, 16.0, mS_PREV_TEXT);
		gCancelButtonTextDrawId[playerid] = mS_CreatePlayerDialogButton(playerid, mS_DIALOG_WIDTH - 150.0, mS_DIALOG_BASE_Y+mS_DIALOG_HEIGHT+100.0, 50.0, 16.0, mS_CANCEL_TEXT);

		SetPVarInt(playerid, "mS_previewBGcolor", previewBGcolor);
		mS_ShowPlayerMPs(playerid);
		mS_UpdatePageTextDraw(playerid);

		SelectTextDraw(playerid, tdSelectionColor);
		return 1;
	}
	return 0;
}

stock date( timestamp, _form=0 )
{
    /*
        date( 1247182451 )  will print >> 09.07.2009-23:34:11
        date( 1247182451, 1) will print >> 09/07/2009, 23:34:11
        date( 1247182451, 2) will print >> July 09, 2009, 23:34:11
        date( 1247182451, 3) will print >> 9 Jul 2009, 23:34
    */
    new year=1970, day=0, month=0, hourt=0, mins=0, sec=0;

    new days_of_month[12] = { 31,28,31,30,31,30,31,31,30,31,30,31 };
    new names_of_month[12][10] = {"January","February","March","April","May","June","July","August","September","October","November","December"};
    new returnstring[32];

    while(timestamp>31622400){
        timestamp -= 31536000;
        if ( ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0) ) timestamp -= 86400;
        year++;
    }

    if ( ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0) )
        days_of_month[1] = 29;
    else
        days_of_month[1] = 28;


    while(timestamp>86400){
        timestamp -= 86400, day++;
        if(day==days_of_month[month]) day=0, month++;
    }

    while(timestamp>60){
        timestamp -= 60, mins++;
        if( mins == 60) mins=0, hourt++;
    }

    sec=timestamp;

    switch( _form ){
        case 1: format(returnstring, 31, "%02d/%02d/%d %02d:%02d:%02d", day+1, month+1, year, hourt, mins, sec);
        case 2: format(returnstring, 31, "%s %02d, %d, %02d:%02d:%02d", names_of_month[month],day+1,year, hourt, mins, sec);
        case 3: format(returnstring, 31, "%d %c%c%c %d, %02d:%02d", day+1,names_of_month[month][0],names_of_month[month][1],names_of_month[month][2], year,hourt,mins);
		case 4: format(returnstring, 31, "%s %02d, %d", names_of_month[month],day+1,year);
        default: format(returnstring, 31, "%02d.%02d.%d-%02d:%02d:%02d", day+1, month+1, year, hourt, mins, sec);
    }

    return returnstring;
}

stock InvalidModCheck(model, partid) {
    switch(model) {
		case 430, 446, 452, 453, 454, 472, 473, 484, 493, 595, 573, 556, 557, 539, 471, 432, 406, 444,
		448, 461, 462, 463, 468, 481, 509, 510, 521, 522, 581, 586, 417, 425, 447, 460, 469, 476, 487,
		488, 511, 512, 513, 519, 520, 548, 553, 563, 577, 592, 593: return 0;
		default: switch(GetVehicleComponentType(partid)) {
			case 5: switch(partid) {
				case 1008, 1009, 1010: return 1;
				default: return 0;
			}
			case 7: switch(partid) {
				case 1073, 1074, 1075, 1076, 1077, 1078, 1079, 1080, 1081, 1082, 1083, 1084, 1085, 1096, 1097, 1098, 1025: return 1;
				default: return 0;
			}
			case 8: switch(partid) {
				case 1086: return 1;
				default: return 0;
			}
			case 9: switch(partid) {
				case 1087: return 1;
				default: return 0;
			}
			case 12, 13: switch(partid) {
				case 1142, 1144, 1143, 1145: return 1;
				default: return 0;
			}
		}
	}
	return 1;
}

stock JudgeOnlineCheck()
{
	foreach(new i: Player)
	{
		if(IsAJudge(i))	return 1;
	}
	return 0;
}

stock TaxSale(amount)
{
	new iTaxAmount = floatround(amount / 100 * BUSINESS_TAX_PERCENT);
	Tax += iTaxAmount;
	for(new iGroupID; iGroupID < MAX_GROUPS; iGroupID++)
	{
		if(arrGroupData[iGroupID][g_iGroupType] == 5 && arrGroupData[iGroupID][g_iAllegiance] == 1)
		{
			new str[128], file[32], month, day, year;
			getdate(year,month,day);
			format(str, sizeof(str), "(THUE DOANH NGHIEP) Mot cua hang da tra $%s thue doanh thu.", number_format(iTaxAmount));
			format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", iGroupID, month, day, year);
			Log(file, str);
		}
	}
	Misc_Save();
	return amount - iTaxAmount;
}

stock SendAudioURLToRange(url[], Float:x, Float:y, Float:z, Float:range)
{
    audiourlid = CreateDynamicSphere(x, y, z, range);
	format(audiourlurl, sizeof(audiourlurl), "%s", url);
	audiourlparams[0] = x;
	audiourlparams[1] = y;
	audiourlparams[2] = z;
	audiourlparams[3] = range;

	return 1;
}


stock SetVehicleLights(vehicleid, playerid)
{
	new engine,lights,alarm,doors,bonnet,boot,objective;
    GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
    if(lights == VEHICLE_PARAMS_ON)
	{
		SetVehicleParamsEx(vehicleid,engine,VEHICLE_PARAMS_OFF,alarm,doors,bonnet,boot,objective);
		SendClientMessageEx(playerid, COLOR_WHITE, "Den xe da tat thanh cong.");
	}
    else if(lights == VEHICLE_PARAMS_OFF || lights == VEHICLE_PARAMS_UNSET)
	{
		SetVehicleParamsEx(vehicleid,engine,VEHICLE_PARAMS_ON,alarm,doors,bonnet,boot,objective);
		SendClientMessageEx(playerid, COLOR_WHITE, "Den xe da bat thanh cong.");
	}
	return 1;
}

stock SetVehicleHood(vehicleid, playerid)
{
	new engine,lights,alarm,doors,bonnet,boot,objective;
    GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
    if(bonnet == VEHICLE_PARAMS_ON)
	{
		SetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,VEHICLE_PARAMS_OFF,boot,objective);
		SendClientMessageEx(playerid, COLOR_WHITE, "Mui xe dong thanh cong.");
	}
    else if(bonnet == VEHICLE_PARAMS_OFF || bonnet == VEHICLE_PARAMS_UNSET)
	{
		SetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,VEHICLE_PARAMS_ON,boot,objective);
		SendClientMessageEx(playerid, COLOR_WHITE, "Mui xe mo thanh cong.");
	}
	return 1;
}

stock SetVehicleTrunk(vehicleid, playerid)
{
	new engine,lights,alarm,doors,bonnet,boot,objective;
    GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
    if(boot == VEHICLE_PARAMS_ON)
	{
		SetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,VEHICLE_PARAMS_OFF,objective);
		SendClientMessageEx(playerid, COLOR_WHITE, "Thung xe dong thanh cong.");
	}
    else if(boot == VEHICLE_PARAMS_OFF || boot == VEHICLE_PARAMS_UNSET)
	{
		SetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,VEHICLE_PARAMS_ON,objective);
		SendClientMessageEx(playerid, COLOR_WHITE, "Thung xe mo thanh cong.");
	}
	return 1;
}

stock SetVehicleDoors(vehicleid, playerid)
{
	new engine,lights,alarm,doors,bonnet,boot,objective;
    GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
    if(doors == VEHICLE_PARAMS_ON)
	{
		SetVehicleParamsEx(vehicleid,engine,lights,alarm,VEHICLE_PARAMS_OFF,bonnet,boot,objective);
		SendClientMessageEx(playerid, COLOR_WHITE, "Cua {AA3333}xe {FFFFFF}dong {33AA33}thanh cong{FFFFFF}.");
	}
    else if(doors == VEHICLE_PARAMS_OFF || doors == VEHICLE_PARAMS_UNSET)
	{
		SetVehicleParamsEx(vehicleid,engine,lights,alarm,VEHICLE_PARAMS_ON,bonnet,boot,objective);
		SendClientMessageEx(playerid, COLOR_WHITE, "Cua {AA3333}xe {FFFFFF}mo {33AA33}thanh cong{FFFFFF}.");
	}
	return 1;
}

stock ClearChatbox(playerid)
{
	for(new i = 0; i < 60; i++) {
		SendClientMessage(playerid, COLOR_WHITE, "");
	}
	return 1;
}



stock ShowMainMenuGUI(playerid)
{
	InsideMainMenu{playerid} = true;
	MainMenuUpdateForPlayer(playerid);

	TextDrawShowForPlayer(playerid, MainMenuTxtdraw[0]);
	TextDrawShowForPlayer(playerid, MainMenuTxtdraw[1]);
	TextDrawShowForPlayer(playerid, MainMenuTxtdraw[2]);
	TextDrawShowForPlayer(playerid, MainMenuTxtdraw[3]);
	TextDrawShowForPlayer(playerid, MainMenuTxtdraw[4]);
	TextDrawShowForPlayer(playerid, MainMenuTxtdraw[5]);
	TextDrawShowForPlayer(playerid, MainMenuTxtdraw[6]);
	TextDrawShowForPlayer(playerid, MainMenuTxtdraw[9]);
	TextDrawShowForPlayer(playerid, MainMenuTxtdraw[10]);
}

stock HideMainMenuGUI(playerid)
{
	InsideMainMenu{playerid} = false;

	TextDrawHideForPlayer(playerid, MainMenuTxtdraw[0]);
	TextDrawHideForPlayer(playerid, MainMenuTxtdraw[1]);
	TextDrawHideForPlayer(playerid, MainMenuTxtdraw[2]);
	TextDrawHideForPlayer(playerid, MainMenuTxtdraw[3]);
	TextDrawHideForPlayer(playerid, MainMenuTxtdraw[4]);
	TextDrawHideForPlayer(playerid, MainMenuTxtdraw[5]);
	TextDrawHideForPlayer(playerid, MainMenuTxtdraw[6]);
	TextDrawHideForPlayer(playerid, MainMenuTxtdraw[9]);
	TextDrawHideForPlayer(playerid, MainMenuTxtdraw[10]);
}

stock ShowNMuteFine(playerid)
{
	new playername[MAX_PLAYER_NAME];
	GetPlayerName(playerid, playername, sizeof(playername));

	new totalwealth = PlayerInfo[playerid][pAccount] + GetPlayerCash(playerid);
	if(PlayerInfo[playerid][pPhousekey] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[playerid][pPhousekey]][hOwnerID] == GetPlayerSQLId(playerid)) totalwealth += HouseInfo[PlayerInfo[playerid][pPhousekey]][hSafeMoney];
	if(PlayerInfo[playerid][pPhousekey2] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[playerid][pPhousekey2]][hOwnerID] == GetPlayerSQLId(playerid)) totalwealth += HouseInfo[PlayerInfo[playerid][pPhousekey2]][hSafeMoney];

    new fine = 10*totalwealth/100;
	if(PlayerInfo[playerid][pNMuteTotal] < 4)
	{
		new string[64];
		format(string,sizeof(string),"Di tu %d phut\nTru tien ($%d)",PlayerInfo[playerid][pNMuteTotal] * 15, fine);
		ShowPlayerDialog(playerid,NMUTE,DIALOG_STYLE_LIST,"Newbie Chat Unmute - Chon hinh phat cua ban:",string,"Lua chon","Huy bo");
	}
	else if(PlayerInfo[playerid][pNMuteTotal] == 4) ShowPlayerDialog(playerid,NMUTE,DIALOG_STYLE_LIST,"Newbie Chat Unmute - Chon hinh phat cua ban:","Di tu 1 gio","Lua chon","Huy bo");
	else if(PlayerInfo[playerid][pNMuteTotal] == 5) ShowPlayerDialog(playerid,NMUTE,DIALOG_STYLE_LIST,"Newbie Chat Unmute - Chon hinh phat cua ban:","Di tu 1 gio 15 phut","Lua chon","Huy bo");
	else if(PlayerInfo[playerid][pNMuteTotal] == 6) ShowPlayerDialog(playerid,NMUTE,DIALOG_STYLE_LIST,"Newbie Chat Unmute - Chon hinh phat cua ban:","Di tu 1 gio 30 phut","Lua chon","Huy bo");
}

stock ShowAdMuteFine(playerid)
{
	new string[128];
	new playername[MAX_PLAYER_NAME];
	GetPlayerName(playerid, playername, sizeof(playername));

	new totalwealth = PlayerInfo[playerid][pAccount] + GetPlayerCash(playerid);
	if(PlayerInfo[playerid][pPhousekey] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[playerid][pPhousekey]][hOwnerID] == GetPlayerSQLId(playerid)) totalwealth += HouseInfo[PlayerInfo[playerid][pPhousekey]][hSafeMoney];
	if(PlayerInfo[playerid][pPhousekey2] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[playerid][pPhousekey2]][hOwnerID] == GetPlayerSQLId(playerid)) totalwealth += HouseInfo[PlayerInfo[playerid][pPhousekey2]][hSafeMoney];

    new fine = 10*totalwealth/100;
	if(PlayerInfo[playerid][pADMuteTotal] < 4)
	{
		format(string,sizeof(string),"Di tu %d Phut\nTru Tien ($%d)",PlayerInfo[playerid][pADMuteTotal]*15,fine);
	}
	if(PlayerInfo[playerid][pADMuteTotal] == 4)
	{
	    format(string,sizeof(string),"Di tu 1 gio");
	}
	if(PlayerInfo[playerid][pADMuteTotal] == 5)
	{
	    format(string,sizeof(string),"Di tu 1 gio 15 phut)");
	}
	if(PlayerInfo[playerid][pADMuteTotal] == 6)
	{
	    format(string,sizeof(string),"Di tu 1 gio 30 phut");
	}
	ShowPlayerDialog(playerid,ADMUTE,DIALOG_STYLE_LIST,"Quang cao Unmute - Chon hinh phat cua ban:",string,"Lua chon","Huy bo");
}

stock PaintballEditMenu(playerid)
{
	new string[1024], status[64];
	for(new i = 0; i < MAX_ARENAS; i++)
	{
	    if(PaintBallArena[i][pbLocked] == 0)
 	    {
 	        format(status,sizeof(status),"Open");
 	    }
 	    if(PaintBallArena[i][pbLocked] == 1)
 	    {
 	        format(status,sizeof(status),"Active");
 	    }
 	    if(PaintBallArena[i][pbLocked] == 2)
 	    {
 	        format(status,sizeof(status),"Closed");
 	    }
 	    if(PaintBallArena[i][pbLocked] == 3)
 	    {
 	        format(status,sizeof(status),"Setup");
 	    }
		format(string,sizeof(string),"%s%s - \t(%s)\n",string,PaintBallArena[i][pbArenaName],status);
	}
	ShowPlayerDialog(playerid,PBEDITMENU,DIALOG_STYLE_LIST,"Paintball - Edit Menu:",string,"Chon","Quay lai");
}

stock PaintballEditArenaMenu(playerid)
{
	if(GetPVarInt(playerid, "ArenaNumber") == -1) { return 1; }
	new string[1024];
	new arenaid = GetPVarInt(playerid, "ArenaNumber");
	format(string,sizeof(string),"Edit Arena Name - (%s)\nEdit Deathmatch Positions...\nEdit Team Positions...\nEdit Flag Positions...\nEdit Hill Position...\nHill Radius (%f)\nInterior (%d)\nVirtual World (%d)",PaintBallArena[arenaid][pbArenaName],PaintBallArena[arenaid][pbHillRadius],PaintBallArena[arenaid][pbInterior],PaintBallArena[arenaid][pbVirtual]);
	ShowPlayerDialog(playerid,PBEDITARENAMENU,DIALOG_STYLE_LIST,"Paintball - Edit Arena Menu:",string,"Chon","Quay lai");
	return 1;
}

stock PaintballEditArenaName(playerid)
{
	if(GetPVarInt(playerid, "ArenaNumber") == -1) { return 1; }
	new string[128];
	new arenaid = GetPVarInt(playerid, "ArenaNumber");
	format(string,sizeof(string),"Enter a new Arena Name for Arena Slot %d:",arenaid);
	ShowPlayerDialog(playerid,PBEDITARENANAME,DIALOG_STYLE_INPUT,"Paintball - Edit Arena Name:",string,"Thay doi","Quay lai");
	return 1;
}

stock PaintballEditArenaDMSpawns(playerid)
{
    if(GetPVarInt(playerid, "ArenaNumber") == -1) { return 1; }
	ShowPlayerDialog(playerid,PBEDITARENADMSPAWNS,DIALOG_STYLE_LIST,"Paintball - Edit Arena DM Spawns:","Deathmatch Spawn 1\nDeathmatch Spawn 2\nDeathmatch Spawn 3\nDeathmatch Spawn 4","Thay doi","Quay lai");
	return 1;
}

stock PaintballEditArenaTeamSpawns(playerid)
{
	if(GetPVarInt(playerid, "ArenaNumber") == -1) { return 1; }
	ShowPlayerDialog(playerid,PBEDITARENATEAMSPAWNS,DIALOG_STYLE_LIST,"Paintball - Edit Arena Team Spawns:","Red Team Spawn 1\nRed Team Spawn 2\nRed Team Spawn 3\nBlue Team Spawn 1\nBlue Team Spawn 2\nBlue Team Spawn 3","Thay doi","Quay lai");
	return 1;
}

stock PaintballEditArenaFlagSpawns(playerid)
{
	if(GetPVarInt(playerid, "ArenaNumber") == -1) { return 1; }
	ShowPlayerDialog(playerid,PBEDITARENAFLAGSPAWNS,DIALOG_STYLE_LIST,"Paintball - Edit Arena Flag Spawns:","Red Team Flag\nBlue Team Flag","Thay doi","Quay lai");
	return 1;
}

stock PaintballEditArenaInt(playerid)
{
	if(GetPVarInt(playerid, "ArenaNumber") == -1) { return 1; }
	ShowPlayerDialog(playerid,PBEDITARENAINT,DIALOG_STYLE_INPUT,"Paintball - Edit Arena Interior:","Please enter a new interior id to place on the Arena:","Thay doi","Quay lai");
	return 1;
}

stock PaintballEditArenaVW(playerid)
{
	if(GetPVarInt(playerid, "ArenaNumber") == -1) { return 1; }
	ShowPlayerDialog(playerid,PBEDITARENAVW,DIALOG_STYLE_INPUT,"Paintball - Edit Arena Virtual World:","Please enter a new virtual world id to place on the Arena:","Thay doi","Quay lai");
	return 1;
}

stock PaintballEditArenaHillRadius(playerid)
{
	if(GetPVarInt(playerid, "ArenaNumber") == -1) { return 1; }
	ShowPlayerDialog(playerid,PBEDITARENAHILLRADIUS,DIALOG_STYLE_INPUT,"Paintball - Sua ban kinh arena:","Xin vui long chon ban kinh cho Arena:","Thay doi","Quay lai");
	return 1;
}

stock PaintballScoreboard(playerid, arenaid)
{
	if(GetPVarInt(playerid, "IsInArena") == -1) { return 1; }
	new titlestring[128];
	new string[2048];
 	foreach(new p: Player)
  	{
		if(GetPVarInt(p, "IsInArena") == arenaid)
		{
		    if(PaintBallArena[arenaid][pbGameType] == 1)
		    {
				format(string,sizeof(string),"%s(ID: %d) %s - (Giet: %d) (Chet: %d) (Ping: %d)\n", string, p, GetPlayerNameEx(p),PlayerInfo[p][pKills],PlayerInfo[p][pDeaths],GetPlayerPing(p));
			}
			if(PaintBallArena[arenaid][pbGameType] == 2 || PaintBallArena[arenaid][pbGameType] == 3)
			{
			    switch(PlayerInfo[p][pPaintTeam])
			    {
			        case 1: // Red Team
			        {
			            format(string,sizeof(string),"%s(ID: %d) ({FF0000}Team Do{FFFFFF}) %s - (Diem: %d) (Ping: %d)\n", string, p, GetPlayerNameEx(p),PlayerInfo[p][pKills],GetPlayerPing(p));
			        }
			        case 2: // Blue Team
			        {
			            format(string,sizeof(string),"%s(ID: %d) ({0000FF}Team Xanh{FFFFFF}) %s - (Diem: %d) (Ping: %d)\n", string, p, GetPlayerNameEx(p),PlayerInfo[p][pKills],GetPlayerPing(p));
			        }
			    }
			}
			if(PaintBallArena[arenaid][pbGameType] == 4)
			{
			    format(string,sizeof(string),"%s(ID: %d) %s - (Diem: %d) (Ping: %d)\n", string, p, GetPlayerNameEx(p),PlayerInfo[p][pKills],GetPlayerPing(p));
			}
			if(PaintBallArena[arenaid][pbGameType] == 5)
			{
			    switch(PlayerInfo[p][pPaintTeam])
			    {
			        case 1: // Red Team
			        {
			            format(string,sizeof(string),"%s(ID: %d) ({FF0000}Team Do{FFFFFF}) %s - (Diem: %d) (Ping: %d)\n", string, p, GetPlayerNameEx(p),PlayerInfo[p][pKills],GetPlayerPing(p));
			        }
			        case 2: // Blue Team
					{
					    format(string,sizeof(string),"%s(ID: %d) ({0000FF}Team Xanh{FFFFFF}) %s - (Diem: %d) (Ping: %d)\n", string, p, GetPlayerNameEx(p),PlayerInfo[p][pKills],GetPlayerPing(p));
					}
			    }
			}
		}
	}
	switch (PaintBallArena[arenaid][pbGameType])
	{
		case 1: // Deathmatch
		{
			format(titlestring,sizeof(titlestring),"(DM) Bang diem - Thoi gian con lai: (%d)",PaintBallArena[arenaid][pbTimeLeft]);
		}
		case 2: // Team Deathmatch
		{
		    format(titlestring,sizeof(titlestring),"(TDM) Bang diem - Do: (%d) - Xanh: (%d) - Thoi gian con lai: (%d)",
			PaintBallArena[arenaid][pbTeamRedKills],
			PaintBallArena[arenaid][pbTeamBlueKills],
			PaintBallArena[arenaid][pbTimeLeft]);
		}
		case 3: // Capture The Flag
		{
		    format(titlestring,sizeof(titlestring),"(CTF) Bang diem - Do: (%d) - Xanh: (%d) - Thoi gian con lai: (%d)",PaintBallArena[arenaid][pbTeamRedScores],PaintBallArena[arenaid][pbTeamBlueScores],PaintBallArena[arenaid][pbTimeLeft]);
		}
		case 4: // King of the Hill
		{
		    format(titlestring,sizeof(titlestring),"(KOTH) Bang diem - Thoi gian con lai: (%d)",PaintBallArena[arenaid][pbTimeLeft]);
		}
		case 5: // Team King of the Hill
		{
		    format(titlestring,sizeof(titlestring),"(TKOTH) Bang diem - Do: (%d) - Xanh: (%d) - Thoi gian con lai (%d)",PaintBallArena[arenaid][pbTeamRedScores],PaintBallArena[arenaid][pbTeamBlueScores],PaintBallArena[arenaid][pbTimeLeft]);
		}
	}
	ShowPlayerDialog(playerid,PBARENASCORES,DIALOG_STYLE_LIST,titlestring,string,"Cap nhat","Dong lai");
	return 1;
}

stock PaintballArenaSelection(playerid)
{
	new string[2048], status[64], gametype[64], eperm[64], limit, count, money;
 	for(new i = 0; i < MAX_ARENAS; i++) if(!isnull(PaintBallArena[i][pbArenaName]))
 	{
 	    limit = PaintBallArena[i][pbLimit];
 	    count = PaintBallArena[i][pbPlayers];
 	    money = PaintBallArena[i][pbBidMoney];

 	    if(PaintBallArena[i][pbLocked] == 0)
 	    {
 	        format(status,sizeof(status),"{00FF00}Mo{FFFFFF}");
 	    }
 	    if(PaintBallArena[i][pbLocked] == 1)
 	    {
 	        format(status,sizeof(status),"{00FF00}Hoat dong{FFFFFF}");
 	    }
 	    if(PaintBallArena[i][pbLocked] == 2)
 	    {
 	        format(status,sizeof(status),"{FF0000}Dong{FFFFFF}");
 	    }
 	    if(PaintBallArena[i][pbLocked] == 3)
 	    {
 	        format(status,sizeof(status),"{FF6600}Cat dat{FFFFFF}");
 	    }

 	    if(PaintBallArena[i][pbGameType] == 1)
 	    {
 	        format(gametype,sizeof(gametype),"DM");
		}
		if(PaintBallArena[i][pbGameType] == 2)
		{
		    format(gametype,sizeof(gametype),"TDM");
		}
		if(PaintBallArena[i][pbGameType] == 3)
		{
		    format(gametype,sizeof(gametype),"CTF");
		}
		if(PaintBallArena[i][pbGameType] == 4)
		{
		    format(gametype,sizeof(gametype),"KOTH");
		}
		if(PaintBallArena[i][pbGameType] == 5)
		{
		    format(gametype,sizeof(gametype),"TKOTH");
		}

		if(PaintBallArena[i][pbExploitPerm] == 0)
		{
		    format(eperm,sizeof(eperm),"{FF0000}No QS/CS{FFFFFF}");
		}
		if(PaintBallArena[i][pbExploitPerm] == 1)
		{
		    format(eperm,sizeof(eperm),"{00FF00}QS/CS{FFFFFF}");
		}

		if(!strcmp(PaintBallArena[i][pbPassword], "None", false))
		{
 	    	format(string,sizeof(string),"%s{FFFFFF}%s - \t(%s) (%s) (%s) (%d/%d) ($%d) (%s)\n",string,PaintBallArena[i][pbArenaName],PaintBallArena[i][pbOwner],status,gametype,count,limit,money,eperm);
		}
		else
		{
		    format(string,sizeof(string),"%s{FFFFFF}%s - \t(%s) (%s) (%s) (%d/%d) ($%d) (%s) (PW)\n",string,PaintBallArena[i][pbArenaName],PaintBallArena[i][pbOwner],status,gametype,count,limit,money,eperm);
		}
	}
	ShowPlayerDialog(playerid,PBARENASELECTION,DIALOG_STYLE_LIST,"Paintball - Chon loai Arena:",string,"Chon","Quay lai");
}

stock PaintballTokenBuyMenu(playerid)
{
	new string[150];
	format(string,sizeof(string),"{FFFFFF}Ban muon mua bao nhieu Paintball Tokens?\n\nMoi token co gia $%d. Ban hien co {AA3333}%d{FFFFFF} Tokens.", 100, PlayerInfo[playerid][pPaintTokens]);
	ShowPlayerDialog(playerid,PBTOKENBUYMENU,DIALOG_STYLE_INPUT,"Paintball - Paintball Tokens:",string,"Mua","Quay lai");
}

stock PaintballSetupArena(playerid)
{
	new string[1024], gametype[32], password[64], wepname1[128], wepname2[128], wepname3[128], eperm[64], finstagib[64], fnoweapons[64];
	new timelimit, limit, money, Float:health, Float:armor, wep1, wep2, wep3;
	new a = GetPVarInt(playerid, "ArenaNumber");

	format(password,sizeof(password),"%s", PaintBallArena[a][pbPassword]);
	timelimit = PaintBallArena[a][pbTimeLeft]/60;
	limit = PaintBallArena[a][pbLimit];
	money = PaintBallArena[a][pbBidMoney];
	health = PaintBallArena[a][pbHealth];
	armor = PaintBallArena[a][pbArmor];
	wep1 = PaintBallArena[a][pbWeapons][0];
	wep2 = PaintBallArena[a][pbWeapons][1];
	wep3 = PaintBallArena[a][pbWeapons][2];

	GetWeaponName(wep1,wepname1,sizeof(wepname1));
	GetWeaponName(wep2,wepname2,sizeof(wepname2));
	GetWeaponName(wep3,wepname3,sizeof(wepname3));

	if(PaintBallArena[a][pbGameType] == 1)
	{
		format(gametype,sizeof(gametype),"DM");
	}
	if(PaintBallArena[a][pbGameType] == 2)
	{
	    format(gametype,sizeof(gametype),"TDM");
	}
	if(PaintBallArena[a][pbGameType] == 3)
	{
	    format(gametype,sizeof(gametype),"CTF");
	}
	if(PaintBallArena[a][pbGameType] == 4)
	{
	    format(gametype,sizeof(gametype),"KOTH");
	}
	if(PaintBallArena[a][pbGameType] == 5)
	{
	    format(gametype,sizeof(gametype),"TKOTH");
	}

	if(PaintBallArena[a][pbExploitPerm] == 0)
	{
		format(eperm,sizeof(eperm),"Khong duoc phep");
	}
	if(PaintBallArena[a][pbExploitPerm] == 1)
	{
	    format(eperm,sizeof(eperm),"Duoc phep");
	}

	if(PaintBallArena[a][pbFlagInstagib] == 0)
	{
	    format(finstagib,sizeof(finstagib),"Tat");
	}
	if(PaintBallArena[a][pbFlagInstagib] == 1)
	{
	    format(finstagib,sizeof(finstagib),"Mo");
	}

	if(PaintBallArena[a][pbFlagNoWeapons] == 0)
	{
	    format(fnoweapons,sizeof(fnoweapons),"Tat");
	}
	if(PaintBallArena[a][pbFlagNoWeapons] == 1)
	{
	    format(fnoweapons,sizeof(fnoweapons),"Mo");
	}

	switch(PaintBallArena[a][pbGameType])
	{
	    case 1:
	    {
	        format(string,sizeof(string),"Mat khau - (%s)\nLoai Game - (%s)\nGioi han - (%d)\nGioi han thoi gian - (%d Phut)\nDat coc tien - ($%d)\nMau - (%.2f)\nGiap - (%.2f)\nSlot vu khi 1 - (%s)\nSlot vu khi 2 - (%s)\nSlot vu khi 3 - (%s)\nQS/CS - (%s)\nBat dau Arena",password,gametype,limit,timelimit,money,health,armor,wepname1,wepname2,wepname3,eperm);
	    }
	    case 2:
	    {
	        format(string,sizeof(string),"Mat khau - (%s)\nLoai Game - (%s)\nGioi han - (%d)\nGioi han thoi gian - (%d Phut)\nDat coc tien - ($%d)\nMau - (%.2f)\nGiap - (%.2f)\nSlot vu khi 1 - (%s)\nSlot vu khi 2 - (%s)\nSlot vu khi 3 - (%s)\nQS/CS - (%s)\nBat dau Arena",password,gametype,limit,timelimit,money,health,armor,wepname1,wepname2,wepname3,eperm);
	    }
	    case 3:
	    {
	        format(string,sizeof(string),"Mat khau - (%s)\nLoai Game - (%s)\nGioi han - (%d)\nGioi han thoi gian - (%d Phut)\nDat coc tien - ($%d)\nMau - (%.2f)\nGiap - (%.2f)\nSlot vu khi 1 - (%s)\nSlot vu khi 2 - (%s)\nSlot vu khi 3 - (%s)\nQS/CS - (%s)\nFlag Instagib - (%s)\nFlag No Weapons - (%s)\nBat dau Arena",password,gametype,limit,timelimit,money,health,armor,wepname1,wepname2,wepname3,eperm,finstagib,fnoweapons);
	    }
	    case 4:
	    {
	        format(string,sizeof(string),"Mat khau - (%s)\nLoai Game - (%s)\nGioi han - (%d)\nGioi han thoi gian - (%d Phut)\nDat coc tien - ($%d)\nMau - (%.2f)\nGiap - (%.2f)\nSlot vu khi 1 - (%s)\nSlot vu khi 2 - (%s)\nSlot vu khi 3 - (%s)\nQS/CS - (%s)\nBat dau Arena",password,gametype,limit,timelimit,money,health,armor,wepname1,wepname2,wepname3,eperm);
	    }
	    case 5:
	    {
	        format(string,sizeof(string),"Mat khau - (%s)\nLoai Game - (%s)\nGioi han - (%d)\nGioi han thoi gian - (%d Phut)\nDat coc tien - ($%d)\nMau - (%.2f)\nGiap - (%.2f)\nSlot vu khi 1 - (%s)\nSlot vu khi 2 - (%s)\nSlot vu khi 3 - (%s)\nQS/CS - (%s)\nBat dau Arena",password,gametype,limit,timelimit,money,health,armor,wepname1,wepname2,wepname3,eperm);
	    }
	}
	ShowPlayerDialog(playerid,PBSETUPARENA,DIALOG_STYLE_LIST,"Paintball - Cai dat:",string,"Chon","Thoat");
}

stock PaintballSwitchTeam(playerid)
{
	new arenaid = GetPVarInt(playerid, "IsInArena");
	new teamlimit = PaintBallArena[arenaid][pbLimit]/2;
	new string[128];
	format(string,sizeof(string),"{FF0000}Team Do (%d/%d)\n{0000FF}Team Xanh (%d/%d)",PaintBallArena[arenaid][pbTeamRed],teamlimit,PaintBallArena[arenaid][pbTeamBlue],teamlimit);
	ShowPlayerDialog(playerid,PBSWITCHTEAM,DIALOG_STYLE_LIST,"Paintball - Chon mot team:",string,"Chon","Huy bo");
}

stock SendBugMessage(member, string[])
{
    if(!(0 <= member < MAX_GROUPS))
        return 0;

	new iGroupID;
	foreach(new i: Player)
	{
		iGroupID = PlayerInfo[i][pMember];
 		if(iGroupID == member && PlayerInfo[i][pRank] >= arrGroupData[iGroupID][g_iBugAccess] && gBug{i} == 1)	{
			SendClientMessageEx(i, COLOR_LIGHTGREEN, string);
		}
	}
	return 1;
}

/*stock ReplacePH(oldph, newph)
{
    #pragma unused oldph
    #pragma unused newph
    new File: file2 = fopen("tmpPHList.cfg", io_write);
    new number;
    new string[32];
    new PHList[32];
    format(string, sizeof(string), "%d\r\n", newph);
    fwrite(file2, string);
    fclose(file2);
    file2 = fopen("tmpPHList.cfg", io_append);
    if(fexist("PHList.cfg"))
	{
		new File: file = fopen("PHList.cfg", io_read);
	    while(fread(file, string))
		{
	        strmid(PHList, string, 0, strlen(string)-1, 255);
	        number = strval(PHList);
	    	if (number != oldph)
			{
	            format(string, sizeof(string), "%d\r\n", number);
	        	fwrite(file2, string);
	    	}
	    }
	    fclose(file);
	    fclose(file2);
	    file2 = fopen("PHList.cfg", io_write);
	    file = fopen("tmpPHList.cfg", io_read);
		while(fread(file, string))
		{
	        strmid(PHList, string, 0, strlen(string)-1, 255);
	        number = strval(PHList);
	        if (number != oldph)
			{
	            format(string, sizeof(string), "%d\r\n", number);
	        	fwrite(file2, string);
	    	}
	    }
	    fclose(file);
	    fclose(file2);
		fremove("tmpPHList.cfg");
	}
	return 1;
}*/


stock SearchingHit(playerid)
{
	new string[128], group = PlayerInfo[playerid][pMember];
   	SendClientMessageEx(playerid, COLOR_WHITE, "Available Contracts:");
   	new hits;
	foreach(new i: Player)
	{
		if(!IsAHitman(i) && PlayerInfo[i][pHeadValue] > 0)
		{
	 		if(GotHit[i] == 0)
  			{
				hits++;
				format(string, sizeof(string), "%s (ID %d) | $%s | Hop dong boi: %s | Ly do: %s | San boi: Nobody", GetPlayerNameEx(i), i, number_format(PlayerInfo[i][pHeadValue]), PlayerInfo[i][pContractBy], PlayerInfo[i][pContractDetail]);
				SendClientMessageEx(playerid, COLOR_GRAD2, string);
			}
			else
			{
  				format(string, sizeof(string), "%s (ID %d) | $%s | Hop dong boi: %s | Ly do: %s | San boi: %s", GetPlayerNameEx(i), i, number_format(PlayerInfo[i][pHeadValue]), PlayerInfo[i][pContractBy], PlayerInfo[i][pContractDetail], GetPlayerNameEx(GetChased[i]));
				SendClientMessageEx(playerid, COLOR_GRAD2, string);
			}
  		}
	}
	if(hits && PlayerInfo[playerid][pRank] <= 1 && arrGroupData[group][g_iGroupType] == 2)
	{
		SendClientMessageEx(playerid, COLOR_YELLOW, "Su dung /givemehit nhan hop dong cho chinh minh.");
	}
	if(hits && PlayerInfo[playerid][pRank] >= 6 && arrGroupData[group][g_iGroupType] == 2)
	{
		SendClientMessageEx(playerid, COLOR_YELLOW, "Su dung /givehit de dua mot hop dong cho mot hitman.");
	}
	if(hits == 0)
	{
	    SendClientMessageEx(playerid, COLOR_GREY, "Khong co luot truy cap co san.");
	}
	return 0;
}

stock GetWeaponSlot(weaponid)
{
	switch( weaponid )
	{
		case 0, 1:
		{
			return 0;
		}
		case 2, 3, 4, 5, 6, 7, 8, 9:
		{
			return 1;
		}
		case 22, 23, 24:
		{
			return 2;
		}
		case 25, 26, 27:
		{
			return 3;
		}
		case 28, 29, 32:
		{
			return 4;
		}
		case 30, 31:
		{
			return 5;
		}
		case 33, 34:
		{
			return 6;
		}
		case 35, 36, 37, 38:
		{
			return 7;
		}
		case 16, 17, 18, 39, 40:
		{
			return 8;
		}
		case 41, 42, 43:
		{
			return 9;
		}
		case 10, 11, 12, 13, 14, 15:
		{
			return 10;
		}
		case 44, 45, 46:
		{
			return 11;
		}
	}
	return -1;
}

stock ExecuteHackerAction( playerid, weaponid )
{
	if(playerTabbed[playerid] >= 1) { return 1; }
	if(GetPVarInt(playerid, "IsInArena") >= 0) { return 1; }

	new String[ 128 ], WeaponName[ 128 ];
	GetWeaponName( weaponid, WeaponName, sizeof( WeaponName ) );

	format( String, sizeof( String ), "{AA3333}Canh bao Admin{FFFF00}: %s (ID %d) co the la dang hack vu khi (%s).", GetPlayerNameEx(playerid), playerid, WeaponName );
	ABroadCast( COLOR_YELLOW, String, 2 );
	Log("logs/Hack/HackWeapons.log", String);

	return 1;
}
stock IsValidIP(ip[])
{
    new a;
	for (new i = 0; i < strlen(ip); i++)
	{
		if (ip[i] == '.')
		{
		    a++;
		}
	}
	if (a != 3)
	{
	    return 1;
	}
	return 0;
}
stock OnePlayAnim(playerid,animlib[],animname[], Float:Speed, looping, lockx, locky, lockz, lp)
{
	ApplyAnimation(playerid, animlib, animname, Speed, looping, lockx, locky, lockz, lp);
}
stock GetPlayersName(playerid)
{
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	return name;
}

stock IsValidSkin(skinid)
{
	if (skinid < 0 || skinid > 311)
	    return 0;

	switch (skinid)
	{
	    case
		0, 105, 106, 107, 102, 103, 69, 123,
		104, 114, 115, 116, 174, 175, 100, 247, 173,
		248, 117, 118, 147, 163, 21, 24, 143, 71,
		156, 176, 177, 108, 109, 110, 165, 166,
		265, 266, 267, 269, 270, 271, 274, 276,
		277, 278, 279, 280, 281, 282, 283, 284,
		285, 286, 287, 288, 294, 296, 297: return 0;
	}

	return 1;
}

stock IsFemaleSpawnSkin(skinid)
{
	switch (skinid)
	{
	    case
		9, 11, 12, 13, 31, 38, 39, 40, 41, 53, 54,
		55, 56, 65, 76, 77, 89, 91, 93, 129, 130,
		131, 141, 148, 150, 151, 157, 169, 172, 190,
		191, 192, 193, 194, 195, 196, 197, 198, 199,
		211, 214, 215, 216, 218, 219, 224, 225, 226,
		231, 232, 233, 263, 298: return 1;
	}

	return 0;
}

stock IsFemaleSkin(skinid)
{
	switch (skinid)
	{
	    case
		9, 11, 12, 13, 31, 38, 39, 40, 41, 53, 54, 55,
		56, 63, 64, 65, 75, 76, 77, 85, 87, 88, 89, 90,
		91, 92, 93, 129, 130, 131, 138, 139, 140, 141,
		145, 148, 150, 151, 152, 157, 169, 172, 178, 190,
		191, 192, 193, 194, 195, 196, 197, 198, 199, 201,
		205, 207, 211, 214, 215, 216, 218, 219, 224, 225,
		226, 231, 232, 233, 237, 238, 243, 244, 245, 246,
		251, 256, 257, 263, 298: return 1;
	}

	return 0;
}

stock PlayerFacePlayer( playerid, targetplayerid )
{
	new Float: Angle;
	GetPlayerFacingAngle( playerid, Angle );
	SetPlayerFacingAngle( targetplayerid, Angle+180 );
	return true;
}

stock GivePlayerEventWeapons( playerid )
{
	if( GetPVarInt( playerid, "EventToken" ) == 1 )
	{
	/*    new string[129];
		for(new i =0 ; i < 2 ; i++) {
			if(PlayerInfo[playerid][pSlotUse][i] != 0) {
			    RemovePlayerWeapon(playerid,GetWeaponIDWithItem(PlayerInfo[playerid][pSlotUse][i]));
			//	AddInvItem(playerid, PlayerInfo[playerid][pSlotUse][i],1);
				yerInfo[playerid][pSlotUse][i] = 0;
				formatPla(string, sizeof string, "mdl-2020:%s", GetItemString( PlayerInfo[playerid][pSlotUse][i]));
            	PlayerTextDrawSetString(playerid, Inventory_Use[playerid][i], string);
            	PlayerTextDrawShow(playerid, Inventory_Use[playerid][i]);           
 		        RemovePlayerAttachedObject(playerid, 9);
			}    
		}*/
		GivePlayerWeapon( playerid, EventKernel[ EventWeapons ][ 0 ], 60000 );
		GivePlayerWeapon( playerid, EventKernel[ EventWeapons ][ 1 ], 60000 );
		GivePlayerWeapon( playerid, EventKernel[ EventWeapons ][ 2 ], 60000 );
		GivePlayerWeapon( playerid, EventKernel[ EventWeapons ][ 3 ], 60000 );
		GivePlayerWeapon( playerid, EventKernel[ EventWeapons ][ 4 ], 60000 );

	}

	return 1;
}

stock crc32(string[])
{
	new crc_table[256] = {
			0x00000000, 0x77073096, 0xEE0E612C, 0x990951BA, 0x076DC419, 0x706AF48F, 0xE963A535,
			0x9E6495A3, 0x0EDB8832, 0x79DCB8A4, 0xE0D5E91E, 0x97D2D988, 0x09B64C2B, 0x7EB17CBD,
			0xE7B82D07, 0x90BF1D91, 0x1DB71064, 0x6AB020F2, 0xF3B97148, 0x84BE41DE, 0x1ADAD47D,
			0x6DDDE4EB, 0xF4D4B551, 0x83D385C7, 0x136C9856, 0x646BA8C0, 0xFD62F97A, 0x8A65C9EC,
			0x14015C4F, 0x63066CD9, 0xFA0F3D63, 0x8D080DF5, 0x3B6E20C8, 0x4C69105E, 0xD56041E4,
			0xA2677172, 0x3C03E4D1, 0x4B04D447, 0xD20D85FD, 0xA50AB56B, 0x35B5A8FA, 0x42B2986C,
			0xDBBBC9D6, 0xACBCF940, 0x32D86CE3, 0x45DF5C75, 0xDCD60DCF, 0xABD13D59, 0x26D930AC,
			0x51DE003A, 0xC8D75180, 0xBFD06116, 0x21B4F4B5, 0x56B3C423, 0xCFBA9599, 0xB8BDA50F,
			0x2802B89E, 0x5F058808, 0xC60CD9B2, 0xB10BE924, 0x2F6F7C87, 0x58684C11, 0xC1611DAB,
			0xB6662D3D, 0x76DC4190, 0x01DB7106, 0x98D220BC, 0xEFD5102A, 0x71B18589, 0x06B6B51F,
			0x9FBFE4A5, 0xE8B8D433, 0x7807C9A2, 0x0F00F934, 0x9609A88E, 0xE10E9818, 0x7F6A0DBB,
			0x086D3D2D, 0x91646C97, 0xE6635C01, 0x6B6B51F4, 0x1C6C6162, 0x856530D8, 0xF262004E,
			0x6C0695ED, 0x1B01A57B, 0x8208F4C1, 0xF50FC457, 0x65B0D9C6, 0x12B7E950, 0x8BBEB8EA,
			0xFCB9887C, 0x62DD1DDF, 0x15DA2D49, 0x8CD37CF3, 0xFBD44C65, 0x4DB26158, 0x3AB551CE,
			0xA3BC0074, 0xD4BB30E2, 0x4ADFA541, 0x3DD895D7, 0xA4D1C46D, 0xD3D6F4FB, 0x4369E96A,
			0x346ED9FC, 0xAD678846, 0xDA60B8D0, 0x44042D73, 0x33031DE5, 0xAA0A4C5F, 0xDD0D7CC9,
			0x5005713C, 0x270241AA, 0xBE0B1010, 0xC90C2086, 0x5768B525, 0x206F85B3, 0xB966D409,
			0xCE61E49F, 0x5EDEF90E, 0x29D9C998, 0xB0D09822, 0xC7D7A8B4, 0x59B33D17, 0x2EB40D81,
			0xB7BD5C3B, 0xC0BA6CAD, 0xEDB88320, 0x9ABFB3B6, 0x03B6E20C, 0x74B1D29A, 0xEAD54739,
			0x9DD277AF, 0x04DB2615, 0x73DC1683, 0xE3630B12, 0x94643B84, 0x0D6D6A3E, 0x7A6A5AA8,
			0xE40ECF0B, 0x9309FF9D, 0x0A00AE27, 0x7D079EB1, 0xF00F9344, 0x8708A3D2, 0x1E01F268,
			0x6906C2FE, 0xF762575D, 0x806567CB, 0x196C3671, 0x6E6B06E7, 0xFED41B76, 0x89D32BE0,
			0x10DA7A5A, 0x67DD4ACC, 0xF9B9DF6F, 0x8EBEEFF9, 0x17B7BE43, 0x60B08ED5, 0xD6D6A3E8,
			0xA1D1937E, 0x38D8C2C4, 0x4FDFF252, 0xD1BB67F1, 0xA6BC5767, 0x3FB506DD, 0x48B2364B,
			0xD80D2BDA, 0xAF0A1B4C, 0x36034AF6, 0x41047A60, 0xDF60EFC3, 0xA867DF55, 0x316E8EEF,
			0x4669BE79, 0xCB61B38C, 0xBC66831A, 0x256FD2A0, 0x5268E236, 0xCC0C7795, 0xBB0B4703,
			0x220216B9, 0x5505262F, 0xC5BA3BBE, 0xB2BD0B28, 0x2BB45A92, 0x5CB36A04, 0xC2D7FFA7,
			0xB5D0CF31, 0x2CD99E8B, 0x5BDEAE1D, 0x9B64C2B0, 0xEC63F226, 0x756AA39C, 0x026D930A,
			0x9C0906A9, 0xEB0E363F, 0x72076785, 0x05005713, 0x95BF4A82, 0xE2B87A14, 0x7BB12BAE,
			0x0CB61B38, 0x92D28E9B, 0xE5D5BE0D, 0x7CDCEFB7, 0x0BDBDF21, 0x86D3D2D4, 0xF1D4E242,
			0x68DDB3F8, 0x1FDA836E, 0x81BE16CD, 0xF6B9265B, 0x6FB077E1, 0x18B74777, 0x88085AE6,
			0xFF0F6A70, 0x66063BCA, 0x11010B5C, 0x8F659EFF, 0xF862AE69, 0x616BFFD3, 0x166CCF45,
			0xA00AE278, 0xD70DD2EE, 0x4E048354, 0x3903B3C2, 0xA7672661, 0xD06016F7, 0x4969474D,
			0x3E6E77DB, 0xAED16A4A, 0xD9D65ADC, 0x40DF0B66, 0x37D83BF0, 0xA9BCAE53, 0xDEBB9EC5,
			0x47B2CF7F, 0x30B5FFE9, 0xBDBDF21C, 0xCABAC28A, 0x53B39330, 0x24B4A3A6, 0xBAD03605,
			0xCDD70693, 0x54DE5729, 0x23D967BF, 0xB3667A2E, 0xC4614AB8, 0x5D681B02, 0x2A6F2B94,
			0xB40BBE37, 0xC30C8EA1, 0x5A05DF1B, 0x2D02EF8D
	};
	new crc = -1;
	for(new i = 0; i < strlen(string); i++)
	{
 		crc = ( crc >>> 8 ) ^ crc_table[(crc ^ string[i]) & 0xFF];
  	}
  	return crc ^ -1;
}

stock GetPlayerSQLId(playerid)
{
	if(gPlayerLogged{playerid})
	{
		return PlayerInfo[playerid][pId];
	}
	return -1;
}

stock GetPlayerNameExt(playerid)
{
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	return name;
}

stock GetWeaponNameEx(weaponid)
{
	new name[MAX_PLAYER_NAME];
	GetWeaponName(weaponid, name, sizeof(name));
	return name;
}

stock GetPlayerNameEx(playerid) {

	new
		szName[MAX_PLAYER_NAME],
		iPos;
   
	GetPlayerName(playerid, szName, MAX_PLAYER_NAME);
	
	while ((iPos = strfind(szName, "_", false, iPos)) != -1) szName[iPos] = ' ';

	
	return szName;
}

stock StripUnderscore(string[]) // Doesn't remove underscore from original string any more
{
	new iPos, newstring[128];
	format(newstring, sizeof(newstring), "%s", string);
	while ((iPos = strfind(newstring, "_", false, iPos)) != -1) newstring[iPos] = ' ';
	return newstring;
}

stock GetPlayerIpEx(playerid)
{
    new ip[16];
	GetPlayerIp(playerid, ip, sizeof(ip));
	return ip;
}

stock GetJobName(job)
{
	new name[20];
	switch(job)
	{
		case 1: name = "Tham tu";
		case 2: name = "Luat su";
		case 3: name = "Gai diem";
		case 4: name = "Ban thuoc phien";
		case 6: name = "Phong vien tin tuc";
		case 7: name = "Tho sua xe";
		case 8: name = "Ve si";
		case 9: name = "Nguoi ban vu khi";
		case 10: name = "Dai ly xe hoi";
		case 12: name = "Boxer";
		case 14: name = "Buon lau ma tuy";
		case 15: name = "Paper Boy";
		case 16: name = "Nguoi dua hang";
		case 17: name = "Tai xe taxi";
		case 18: name = "Tho thu cong";
		case 19: name = "Nguoi pha che";
		case 20: name = "Miner";
		case 21: name = "Trucker";
		case 22: name = "Trashman";
		case 23: name = "Worker";
		case 24: name = "Pizzaboy";
		case 25: name = "Tho sua dien";
		default: name = "That nghiep";
	}
	return name;
}

stock GetJobLevel(playerid, job)
{
	new jlevel;
	switch(job)
	{
		case 1:
		{
			new skilllevel = PlayerInfo[playerid][pDetSkill];
			if(skilllevel >= 0 && skilllevel <= 50) jlevel = 1;
			else if(skilllevel >= 51 && skilllevel <= 100) jlevel = 2;
			else if(skilllevel >= 101 && skilllevel <= 200) jlevel = 3;
			else if(skilllevel >= 201 && skilllevel <= 400) jlevel = 4;
			else if(skilllevel >= 401) jlevel = 5;
		}
		case 2:
		{
			new skilllevel = PlayerInfo[playerid][pLawSkill];
			if(skilllevel >= 0 && skilllevel <= 50) jlevel = 1;
			else if(skilllevel >= 51 && skilllevel <= 100) jlevel = 2;
			else if(skilllevel >= 101 && skilllevel <= 200) jlevel = 3;
			else if(skilllevel >= 201 && skilllevel <= 400) jlevel = 4;
			else if(skilllevel >= 401) jlevel = 5;
		}
		case 3:
		{
			new skilllevel = PlayerInfo[playerid][pSexSkill];
			if(skilllevel >= 0 && skilllevel <= 50) jlevel = 1;
			else if(skilllevel >= 51 && skilllevel <= 100) jlevel = 2;
			else if(skilllevel >= 101 && skilllevel <= 200) jlevel = 3;
			else if(skilllevel >= 201 && skilllevel <= 400) jlevel = 4;
			else if(skilllevel >= 401) jlevel = 5;
		}
		case 4:
		{
			new skilllevel = PlayerInfo[playerid][pDrugsSkill];
			if(skilllevel >= 0 && skilllevel <= 50) jlevel = 1;
			else if(skilllevel >= 51 && skilllevel <= 100) jlevel = 2;
			else if(skilllevel >= 101 && skilllevel <= 200) jlevel = 3;
			else if(skilllevel >= 201 && skilllevel <= 400) jlevel = 4;
			else if(skilllevel >= 401) jlevel = 5;
		}
		case 7:
		{
			new skilllevel = PlayerInfo[playerid][pMechSkill];
			if(skilllevel >= 0 && skilllevel <= 50) jlevel = 1;
			else if(skilllevel >= 51 && skilllevel <= 100) jlevel = 2;
			else if(skilllevel >= 101 && skilllevel <= 200) jlevel = 3;
			else if(skilllevel >= 201 && skilllevel <= 400) jlevel = 4;
			else if(skilllevel >= 401) jlevel = 5;
		}
		case 9:
		{
			new skilllevel = PlayerInfo[playerid][pArmsSkill];
			if(skilllevel >= 0 && skilllevel < 50) jlevel = 1;
			else if(skilllevel >= 50 && skilllevel < 100) jlevel = 2;
			else if(skilllevel >= 100 && skilllevel < 200) jlevel = 3;
			else if(skilllevel >= 200 && skilllevel < 400) jlevel = 4;
			else if(skilllevel >= 400) jlevel = 5;
		}
		case 12:
		{
			new skilllevel = PlayerInfo[playerid][pBoxSkill];
			if(skilllevel >= 0 && skilllevel <= 50) jlevel = 1;
			else if(skilllevel >= 51 && skilllevel <= 100) jlevel = 2;
			else if(skilllevel >= 101 && skilllevel <= 200) jlevel = 3;
			else if(skilllevel >= 201 && skilllevel <= 400) jlevel = 4;
			else if(skilllevel >= 401) jlevel = 5;
		}
		case 14: jlevel = 1;
		case 20:
		{
			new skilllevel = PlayerInfo[playerid][pTruckSkill];
			if(skilllevel >= 0 && skilllevel <= 100) jlevel = 1;
			else if(skilllevel >= 101 && skilllevel <= 200) jlevel = 2;
			else if(skilllevel >= 201 && skilllevel <= 300) jlevel = 3;
			else if(skilllevel >= 301 && skilllevel <= 400) jlevel = 4;
			else if(skilllevel >= 401) jlevel = 5;
		}
		case 22:
		{
			new skilllevel = PlayerInfo[playerid][pTreasureSkill];
			if(skilllevel >= 0 && skilllevel <= 24) jlevel = 1;
			else if(skilllevel >= 25 && skilllevel <= 149) jlevel = 2;
			else if(skilllevel >= 150 && skilllevel <= 299) jlevel = 3;
			else if(skilllevel >= 300 && skilllevel <= 599) jlevel = 4;
			else if(skilllevel >= 600) jlevel = 5;
		}
	}
	return jlevel;
}

stock StripNewLine(string[])
{
  new len = strlen(string);
  if (string[0]==0) return ;
  if ((string[len - 1] == '\n') || (string[len - 1] == '\r'))
    {
      string[len - 1] = 0;
      if (string[0]==0) return ;
      if ((string[len - 2] == '\n') || (string[len - 2] == '\r')) string[len - 2] = 0;
    }
}

stock StripColorEmbedding(string[])
{
 	new i, tmp[7];
  	while (i < strlen(string) - 7)
	{
	    if (string[i] == '{' && string[i + 7] == '}')
		{
		    strmid(tmp, string, i + 1, i + 7);
			if (ishex(tmp))
			{
				strdel(string, i, i + 8);
				i = 0;
				continue;
			}
		}
		i++;
  	}
}

stock strtoupper(string[])
{
        new retStr[128], i, j;
        while ((j = string[i])) retStr[i++] = chrtoupper(j);
        retStr[i] = '\0';
        return retStr;
}

stock wordwrap(string[], width, seperator[] = "\n", dest[], size = sizeof(dest))
{
    if (dest[0])
    {
        dest[0] = '\0';
    }
    new
        length,
        multiple,
        processed,
        tmp[192];

    strmid(tmp, string, 0, width);
    length = strlen(string);

    if (width > length || !width)
    {
        memcpy(dest, string, _, size * 4, size);
        return 0;
    }
    for (new i = 1; i < length; i ++)
    {
        if (tmp[0] == ' ')
        {
            strdel(tmp, 0, 1);
        }
        multiple = !(i % width);
        if (multiple)
        {
            strcat(dest, tmp, size);
            strcat(dest, seperator, size);
            strmid(tmp, string, i, width + i);
            if (strlen(tmp) < width)
            {
                strmid(tmp, string, (width * processed) + width, length);
                if (tmp[0] == ' ')
                {
                    strdel(tmp, 0, 1);
                }
                strcat(dest, tmp, size);
                break;
            }
            processed++;
            continue;
        }
        else if (i == length - 1)
        {
            strmid(tmp, string, (width * processed), length);
            strcat(dest, tmp, size);
            break;
        }
    }
    return 1;
}

stock IsACop(playerid)
{
	if((0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS) && (arrGroupData[PlayerInfo[playerid][pMember]][g_iGroupType] == 1)) return 1;
	return 0;
}

stock IsAHitman(playerid)
{
	if((0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS) && (arrGroupData[PlayerInfo[playerid][pMember]][g_iGroupType] == 2)) return 1;
	return 0;
}

stock IsAMedic(playerid)
{
	if((0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS) && (arrGroupData[PlayerInfo[playerid][pMember]][g_iGroupType] == 3)) return 1;
	return 0;
}

stock IsAReporter(playerid)
{
	if((0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS) && (arrGroupData[PlayerInfo[playerid][pMember]][g_iGroupType] == 7)) return 1;
	return 0;
}

stock IsAGovernment(playerid)
{
	if((0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS) && (arrGroupData[PlayerInfo[playerid][pMember]][g_iGroupType] == 5)) return 1;
	return 0;
}

stock IsAJudge(playerid)
{
	if((0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS) && (arrGroupData[PlayerInfo[playerid][pMember]][g_iGroupType] == 6)) return 1;
	return 0;
}

stock IsATaxiDriver(playerid)
{
	if((0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS) && (arrGroupData[PlayerInfo[playerid][pMember]][g_iGroupType] == 7))	return 1;
	return 0;
}

stock IsATowman(playerid)
{
	if((0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS) && (arrGroupData[PlayerInfo[playerid][pMember]][g_iGroupType] == 8)) return 1;
	return 0;
}

stock IsARacer(playerid)
{
	if((0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS) && (arrGroupData[PlayerInfo[playerid][pMember]][g_iGroupType] == 9)) return 1;
	return 0;
}

stock IsMDCPermitted(playerid)
{
	if(IsACop(playerid))
	{
		return 1;
	}
	return 0;
}

stock GetPlayerGroupInfo(targetid, rank[], division[], employer[])
{
	new
		iGroupID = PlayerInfo[targetid][pMember],
	 	iRankID = PlayerInfo[targetid][pRank];

	if (0 <= iGroupID < MAX_GROUPS)
	{
	    if(0 <= iRankID < MAX_GROUP_RANKS)
	    {
		    if(arrGroupRanks[iGroupID][iRankID][0]) {
				format(rank, (GROUP_MAX_RANK_LEN), "%s", arrGroupRanks[iGroupID][iRankID]);
			}
			else format(rank, (GROUP_MAX_RANK_LEN), "undefined");
		}
	    if(0 <= PlayerInfo[targetid][pDivision] < MAX_GROUP_DIVS)
		{
			if(arrGroupDivisions[iGroupID][PlayerInfo[targetid][pDivision]][0]) { format(division, (GROUP_MAX_DIV_LEN), "%s", arrGroupDivisions[iGroupID][PlayerInfo[targetid][pDivision]]); }
			else format(division, (GROUP_MAX_DIV_LEN), "undefined");
		}
	    else format(division, (GROUP_MAX_DIV_LEN), "G.D.");
	    if(arrGroupData[iGroupID][g_szGroupName][0]) {
			format(employer, (GROUP_MAX_NAME_LEN), "%s", arrGroupData[iGroupID][g_szGroupName]);
		}
		else
		{
		    format(employer, (GROUP_MAX_NAME_LEN), "undefined");
		}
	}
	else
	{
	    format(rank, (GROUP_MAX_RANK_LEN), "N/A");
	    format(division, (GROUP_MAX_DIV_LEN), "None");
	    format(employer, (GROUP_MAX_NAME_LEN), "None");
	}
	return 1;
}

stock IsAtNameChange(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		if(IsPlayerInRangeOfPoint(playerid, 3.0,-2765.932,382.128,5.885))
		{
			return 1;
		}
	}
	return 0;
}

stock IsAtATM(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		if(IsPlayerInRangeOfPoint(playerid,3.0,2325.9099,-1359.6656,25.0782) || IsPlayerInRangeOfPoint(playerid,3.0,2065.439453125, -1897.5510253906, 13.19670009613) || IsPlayerInRangeOfPoint(playerid,3.0,1497.7467041016, -1749.8747558594, 15.088212013245) || IsPlayerInRangeOfPoint(playerid,3.0,2093.5124511719, -1359.5474853516, 23.62727355957) || IsPlayerInRangeOfPoint(playerid,3.0,1155.6235351563, -1464.9141845703, 15.44321346283))
		{//ATMS
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,3.0,2139.4487304688, -1164.0811767578, 23.63508605957) || IsPlayerInRangeOfPoint(playerid,3.0,1482.7761230469, -1010.3353881836, 26.48664855957) || IsPlayerInRangeOfPoint(playerid,3.0,1482.7761230469, -1010.3353881836, 26.48664855957) || IsPlayerInRangeOfPoint(playerid,3.0,387.16552734375, -1816.0512695313, 7.4834146499634))
		{//ATMS
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,3.0,-24.385023117065, -92.001075744629, 1003.1897583008) || IsPlayerInRangeOfPoint(playerid,3.0,-31.811220169067, -58.106018066406, 1003.1897583008) || IsPlayerInRangeOfPoint(playerid,3.0,1212.7785644531, 2.451762676239, 1000.5647583008) || IsPlayerInRangeOfPoint(playerid,3.0,2324.4028320313, -1644.9445800781, 14.469946861267))
		{//ATMS
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,3.0,2228.39, -1707.78, 13.25) || IsPlayerInRangeOfPoint(playerid,3.0,651.19305419922, -520.48815917969, 15.978837013245) || IsPlayerInRangeOfPoint(playerid, 3.0, 45.78035736084, -291.80926513672, 1.5024013519287) || IsPlayerInRangeOfPoint(playerid,3.0,1275.7958984375, 368.31481933594, 19.19758605957) || IsPlayerInRangeOfPoint(playerid,3.0,2303.4577636719, -13.539554595947, 26.12727355957))/*End of Red County Random ATM's*/
		{//ATMS
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,3.0,294.80, -84.01, 1001.0) || /*Start of Red County Random ATM's*/IsPlayerInRangeOfPoint(playerid,3.0,691.08215332031, -618.5625, 15.978837013245) || IsPlayerInRangeOfPoint(playerid,3.0,173.23471069336, -155.07606506348, 1.2210245132446) || IsPlayerInRangeOfPoint(playerid,3.0,1260.8796386719, 209.30152893066, 19.19758605957) || IsPlayerInRangeOfPoint(playerid,3.0,2316.1015625, -88.522567749023, 26.12727355957))/*End of Red County Random ATM's*/
		{//ATMS
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,3.0,1311.0361,-1446.2249,0.2216))
		{//ATMS
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,3.0,2052.9246, -1660.6346, 13.1300) || IsPlayerInRangeOfPoint(playerid,3.0,-1980.6300,121.5300,27.3100))
		{
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,3.0,-2453.7600,754.8200,34.8000) || IsPlayerInRangeOfPoint(playerid,3.0,-2678.6201,-283.3400,6.8000))
		{
		    return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,5.0,519.8157,-2890.8601,4.4609))
		{
		    return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,5.0,2565.667480, 1406.839355, 7699.584472) || IsPlayerInRangeOfPoint(playerid, 5.0, 3265.30004883, -631.90002441, 8423.90039062) || IsPlayerInRangeOfPoint(playerid, 5.0, 1829.5000, 1391.0000, 1464.0000) || IsPlayerInRangeOfPoint(playerid, 5.0, 1755.8000, 1434.1000, 2013.4000))
		{// VIP Lounge ATM || Package Club Interior
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,5.0,-665.975341, -4033.334716, 20.779014) || IsPlayerInRangeOfPoint(playerid,5.0,-1619.9645996094,713.67535400391, 19995.501953125))
		{// Random Island ATM
			return 1;
		}
		// Famed Lounge
		else if(IsPlayerInRangeOfPoint(playerid, 3.0, 883.7170, 1442.4282, -82.3370))
		{
		    return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid, 3.0, 2926.9199, -1529.9800, 10.6900)) return 1; //NGG Shop
	}
	return 0;
}

stock HospitalSpawn(playerid)
{
	DeletePVar(playerid,"MedicCall");
	SetUPFitness@Reg(playerid,0);
	TogglePlayerControllable(playerid,1);

	if(GetPVarInt(playerid, "MedicBill") == 1 && PlayerInfo[playerid][pJailTime] == 0)
	{
        switch(PlayerInfo[playerid][pHospital])
		{
			case 1:
			{
			    if(PlayerInfo[playerid][pSHealth] > 0)
				{
					SetPlayerArmor(playerid, PlayerInfo[playerid][pSHealth]);
				}
				SetPlayerHealth(playerid, 50.0);
				DeletePVar(playerid, "MedicBill");
				GivePlayerMoneyEx(playerid, -650);
				for(new z; z < MAX_GROUPS; z++)
				{
					if(arrGroupData[z][g_iAllegiance] == 1)
					{
						if(arrGroupData[z][g_iGroupType] == 5)
						{
							new str[128], file[32], month, day, year;
							getdate(year,month,day);
							Tax += 1500;
							format(str, sizeof(str), "%s has their medical fees, adding $15to the vault.", GetPlayerNameEx(playerid));
							format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", z, month, day, year);
							Log(file, str);
							break;
						}
					}
				}
				Misc_Save();
				SendClientMessageEx(playerid, TEAM_CYAN_COLOR, "None , benh vien nay xoa roi thi phai muabaohiem khac di");
				PlayerInfo[playerid][pVW] = 0;
				SetPlayerPos(playerid, 1153.7006, -1330.3177, -41.9554);
				Streamer_UpdateEx(playerid, 1153.7006, -1330.3177, -41.9554);
				Player_StreamPrep(playerid, 1153.7006, -1330.3177, -41.9554,FREEZE_TIME);
				SetPlayerFacingAngle(playerid, 179.4258);
				PlayerInfo[playerid][pHospital] = 0;
				PlayerInfo[playerid][pInjured] = 0;
			}
			case 2:
			{
			    if(PlayerInfo[playerid][pSHealth] > 0)
				{
					SetPlayerArmor(playerid, PlayerInfo[playerid][pSHealth]);
				}
				SetPlayerHealth(playerid, 50.0);
				DeletePVar(playerid, "MedicBill");
				
				for(new z; z < MAX_GROUPS; z++)
				{
					if(arrGroupData[z][g_iAllegiance] == 1)
					{
						if(arrGroupData[z][g_iGroupType] == 5)
						{
							new str[128], file[32], month, day, year;
							getdate(year,month,day);
							Tax += 500;
							format(str, sizeof(str), "%s da chi tra tien vien phi la $500, so tien duoc cong vao quy.", GetPlayerNameEx(playerid));
							format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", z, month, day, year);
							Log(file, str);
							break;
						}
					}
				}
				Misc_Save();
				
				if(AcceptDeath[playerid] != 0) {
					ResetAttach(playerid);
	                Inventory_@ResetWeapon(playerid);
	
					GivePlayerMoneyEx(playerid, -5000);
				    SendClientMessageEx(playerid, COLOR_LIGHTRED, "[RESPAWN DEAD] Ban da su dung chap nhan chet, nhan vat bi tru $5.000.");
				}
				else {
					GivePlayerMoneyEx(playerid, -500);
				    SendClientMessageEx(playerid, COLOR_LIGHTRED, "[HOSPITAL] Ban ton $500 cho tien vien phi.");
				}
				AcceptDeath[playerid] = 0;
				PlayerInfo[playerid][pVW] = 0;
				SetPlayerHunger(playerid,1,1000);
                SetPlayerHunger(playerid,2,1000);
				SetPlayerPos(playerid, 1153.7006, -1330.3177, -41.9554);
				Streamer_UpdateEx(playerid, 1153.7006, -1330.3177, -41.9554);
				Player_StreamPrep(playerid, 1153.7006, -1330.3177, -41.9554,FREEZE_TIME);
				SetPlayerFacingAngle(playerid, 179.4258);
				PlayerInfo[playerid][pHospital] = 0;
				PlayerInfo[playerid][pInjured] = 0;
				SetCameraBehindPlayer(playerid);
				TogglePlayerControllable(playerid, 1);
			}
			case 3:
			{
                if(PlayerInfo[playerid][pSHealth] > 0) {
					SetPlayerArmor(playerid, PlayerInfo[playerid][pSHealth]);
				}
				SetPlayerHealth(playerid, 50.0);
				DeletePVar(playerid, "MedicBill");
				for(new z; z < MAX_GROUPS; z++)
				{
					if(arrGroupData[z][g_iAllegiance] == 1)
					{
						if(arrGroupData[z][g_iGroupType] == 5)
						{
							new str[128], file[32], month, day, year;
							getdate(year,month,day);
							Tax += 650;
							format(str, sizeof(str), "%s has their medical fees, adding $500 to the vault.", GetPlayerNameEx(playerid));
							format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", z, month, day, year);
							Log(file, str);
							break;
						}
					}
				}
				Misc_Save();//SF , Old Red county
				if(AcceptDeath[playerid] != 0) {
					ResetAttach(playerid);
	                Inventory_@ResetWeapon(playerid);
	
					GivePlayerMoneyEx(playerid, -5000);
				    SendClientMessageEx(playerid, COLOR_LIGHTRED, "[RESPAWN DEAD] Ban da su dung chap nhan chet, nhan vat bi tru $5.000.");
				}
				else {
					GivePlayerMoneyEx(playerid, -500);
				    SendClientMessageEx(playerid, COLOR_LIGHTRED, "[HOSPITAL] Ban ton $500 cho tien vien phi.");
				}
				PlayerInfo[playerid][pVW] = 0;
				SetPlayerPos(playerid, 1153.7006, -1330.3177, -41.9554);
				Streamer_UpdateEx(playerid, 1153.7006, -1330.3177, -41.9554);
				Player_StreamPrep(playerid, 1153.7006, -1330.3177, -41.9554,FREEZE_TIME);
				SetPlayerFacingAngle(playerid, 179.4258);
				PlayerInfo[playerid][pHospital] = 0;
				PlayerInfo[playerid][pInjured] = 0;
				TogglePlayerControllable(playerid,1);
			}
			case 4:
			{
			    if(PlayerInfo[playerid][pSHealth] > 0) {
					SetPlayerArmor(playerid, PlayerInfo[playerid][pSHealth]);
				}
				SetPlayerHealth(playerid, 50.0);
				DeletePVar(playerid, "MedicBill");

				for(new z; z < MAX_GROUPS; z++)
				{
					if(arrGroupData[z][g_iAllegiance] == 1)
					{
						if(arrGroupData[z][g_iGroupType] == 5)
						{
							new str[128], file[32], month, day, year;
							getdate(year,month,day);
							Tax += 250;
							format(str, sizeof(str), "%s has their medical fees, adding $650 to the vault.", GetPlayerNameEx(playerid));
							format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", z, month, day, year);
							Log(file, str);
							break;
						}
					}
				}
				Misc_Save();
				if(AcceptDeath[playerid] != 0) {
					ResetAttach(playerid);
	                Inventory_@ResetWeapon(playerid);
	
					AcceptDeath[playerid] = 0;
					GivePlayerMoneyEx(playerid, -5000);
				    SendClientMessageEx(playerid, COLOR_LIGHTRED, "[RESPAWN DEAD] Ban da su dung chap nhan chet, nhan vat bi tru $5.000.");
				}
				else {
					GivePlayerMoneyEx(playerid, -500);
				    SendClientMessageEx(playerid, COLOR_LIGHTRED, "[HOSPITAL] Ban ton $500 cho tien vien phi.");
				}
				PlayerInfo[playerid][pVW] = 0;
				SetPlayerPos(playerid, 1153.7006, -1330.3177, -41.9554);
				Streamer_UpdateEx(playerid, 1153.7006, -1330.3177, -41.9554);
				Player_StreamPrep(playerid, 1153.7006, -1330.3177, -41.9554,FREEZE_TIME);
				SetPlayerFacingAngle(playerid, 179.4258);
				PlayerInfo[playerid][pHospital] = 0;
				PlayerInfo[playerid][pInjured] = 0;
				TogglePlayerControllable(playerid,1);
			}
			case 5:
			{
			    if(PlayerInfo[playerid][pSHealth] > 0) {
					SetPlayerArmor(playerid, PlayerInfo[playerid][pSHealth]);
				}
				SetPlayerHealth(playerid, 50.0);
				DeletePVar(playerid, "MedicBill");
				if(AcceptDeath[playerid] != 0) {
					ResetAttach(playerid);
	                Inventory_@ResetWeapon(playerid);
	
					AcceptDeath[playerid] = 0;
					GivePlayerMoneyEx(playerid, -5000);
				    SendClientMessageEx(playerid, COLOR_LIGHTRED, "[RESPAWN DEAD] Ban da su dung chap nhan chet, nhan vat bi tru $5.000.");
				}
				else {
					GivePlayerMoneyEx(playerid, -500);
				    SendClientMessageEx(playerid, COLOR_LIGHTRED, "[HOSPITAL] Ban ton $500 cho tien vien phi.");
				}
				for(new z; z < MAX_GROUPS; z++)
				{
					if(arrGroupData[z][g_iAllegiance] == 1)
					{
						if(arrGroupData[z][g_iGroupType] == 5)
						{
							new str[128], file[32], month, day, year;
							getdate(year,month,day);
							Tax += 650;
							format(str, sizeof(str), "%s has their medical fees, adding $650 to the vault.", GetPlayerNameEx(playerid));
							format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", z, month, day, year);
							Log(file, str);
							break;
						}
					}
				}
				Misc_Save();//SF
				PlayerInfo[playerid][pVW] = 0;
				SetPlayerPos(playerid, 1153.7006, -1330.3177, -41.9554);
				Streamer_UpdateEx(playerid, 1153.7006, -1330.3177, -41.9554);
				Player_StreamPrep(playerid, 1153.7006, -1330.3177, -41.9554,FREEZE_TIME);
				SetPlayerFacingAngle(playerid, 179.4258);
				PlayerInfo[playerid][pHospital] = 0;
				PlayerInfo[playerid][pInjured] = 0;
				TogglePlayerControllable(playerid,1);
			}
			case 6: {
                if(PlayerInfo[playerid][pSHealth] > 0) {
					SetPlayerArmor(playerid, PlayerInfo[playerid][pSHealth]);
				}
				SetPlayerHealth(playerid, 50.0);
				DeletePVar(playerid, "MedicBill");
				if(AcceptDeath[playerid] != 0) {
					ResetAttach(playerid);
	                Inventory_@ResetWeapon(playerid);
	
					AcceptDeath[playerid] = 0;
					GivePlayerMoneyEx(playerid, -5000);
				    SendClientMessageEx(playerid, COLOR_LIGHTRED, "[RESPAWN DEAD] Ban da su dung chap nhan chet, nhan vat bi tru $5.000.");
				}
				else {
					GivePlayerMoneyEx(playerid, -500);
				    SendClientMessageEx(playerid, COLOR_LIGHTRED, "[HOSPITAL] Ban ton $500 cho tien vien phi.");
				}
				for(new z; z < MAX_GROUPS; z++)
				{
					if(arrGroupData[z][g_iAllegiance] == 1)
					{
						if(arrGroupData[z][g_iGroupType] == 5)
						{
							new str[128], file[32], month, day, year;
							getdate(year,month,day);
							Tax += 1500;
							format(str, sizeof(str), "%s has their medical fees, adding $650 to the vault.", GetPlayerNameEx(playerid));
							format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", z, month, day, year);
							Log(file, str);
							break;
						}
					}
				}
				Misc_Save();
				PlayerInfo[playerid][pVW] = 0;
				SetPlayerPos(playerid, 1153.7006, -1330.3177, -41.9554);
				Streamer_UpdateEx(playerid, 1153.7006, -1330.3177, -41.9554);
				Player_StreamPrep(playerid, 1153.7006, -1330.3177, -41.9554,FREEZE_TIME);
				SetPlayerFacingAngle(playerid, 179.4258);
				PlayerInfo[playerid][pHospital] = 0;
				PlayerInfo[playerid][pInjured] = 0;
				TogglePlayerControllable(playerid,1);
			}
			case 7:
			{
			    if(PlayerInfo[playerid][pSHealth] > 0) {
					SetPlayerArmor(playerid, PlayerInfo[playerid][pSHealth]);
				}
				SetPlayerHealth(playerid, 50.0);
				DeletePVar(playerid, "MedicBill");
				if(AcceptDeath[playerid] != 0) {
					ResetAttach(playerid);
	                Inventory_@ResetWeapon(playerid);
	
					AcceptDeath[playerid] = 0;
					GivePlayerMoneyEx(playerid, -5000);
				    SendClientMessageEx(playerid, COLOR_LIGHTRED, "[RESPAWN DEAD] Ban da su dung chap nhan chet, nhan vat bi tru $5.000.");
				}
				else {
					GivePlayerMoneyEx(playerid, -500);
				    SendClientMessageEx(playerid, COLOR_LIGHTRED, "[HOSPITAL] Ban ton $500 cho tien vien phi.");
				}
				for(new z; z < MAX_GROUPS; z++)
				{
					if(arrGroupData[z][g_iAllegiance] == 1)
					{
						if(arrGroupData[z][g_iGroupType] == 5)
						{
							new str[128], file[32], month, day, year;
							getdate(year,month,day);
							Tax += 650;
							format(str, sizeof(str), "%s has their medical fees, adding $650 to the vault.", GetPlayerNameEx(playerid));
							format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", z, month, day, year);
							Log(file, str);
							break;
						}
					}
				}
				Misc_Save();
				SendClientMessageEx(playerid, TEAM_CYAN_COLOR, "Hoa don benh vien $650. Chuc mot ngay tot lanh!!");
				PlayerInfo[playerid][pVW] = 0;
				SetPlayerPos(playerid, 1153.7006, -1330.3177, -41.9554);
				Streamer_UpdateEx(playerid, 1153.7006, -1330.3177, -41.9554);
				Player_StreamPrep(playerid, 1153.7006, -1330.3177, -41.9554,FREEZE_TIME);
				SetPlayerFacingAngle(playerid, 179.4258);
				PlayerInfo[playerid][pHospital] = 0;
				PlayerInfo[playerid][pInjured] = 0;
				TogglePlayerControllable(playerid,1);
			}
			case 8:
			{
			    if(PlayerInfo[playerid][pSHealth] > 0)
				{
					SetPlayerArmor(playerid, PlayerInfo[playerid][pSHealth]);
				}
				SetPlayerHealth(playerid, 50.0);
				DeletePVar(playerid, "MedicBill");
				if(AcceptDeath[playerid] != 0) {
					AcceptDeath[playerid] = 0;
					ResetAttach(playerid);
	                Inventory_@ResetWeapon(playerid);
	
					GivePlayerMoneyEx(playerid, -5000);
				    SendClientMessageEx(playerid, COLOR_LIGHTRED, "[RESPAWN DEAD] Ban da su dung chap nhan chet, nhan vat bi tru $5.000.");
				}
				else {
					GivePlayerMoneyEx(playerid, -500);
				    SendClientMessageEx(playerid, COLOR_LIGHTRED, "[HOSPITAL] Ban ton $500 cho tien vien phi.");
				}
				for(new z; z < MAX_GROUPS; z++)
				{
					if(arrGroupData[z][g_iAllegiance] == 1)
					{
						if(arrGroupData[z][g_iGroupType] == 5)
						{
							new str[128], file[32], month, day, year;
							getdate(year,month,day);
							Tax += 650;
							format(str, sizeof(str), "%s has their medical fees, adding $650 to the vault.", GetPlayerNameEx(playerid));
							format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", z, month, day, year);
							Log(file, str);
							break;
						}
					}
				}
				Misc_Save();
				SendClientMessageEx(playerid, TEAM_CYAN_COLOR, "(-) FDSA Phi Ra Vien : Ban Da Mat 650$ Tien Ra Vien (Spawnathome)");
				for(new i = 0; i < sizeof(HouseInfo); i++)
				{
					if(PlayerInfo[playerid][pPhousekey] == i || PlayerInfo[playerid][pPhousekey2] == i)
					{
						Streamer_UpdateEx(playerid, HouseInfo[i][hInteriorX],HouseInfo[i][hInteriorY],HouseInfo[i][hInteriorZ]);
						SetPlayerInterior(playerid,HouseInfo[i][hIntIW]);
						SetPlayerPos(playerid,HouseInfo[i][hInteriorX],HouseInfo[i][hInteriorY],HouseInfo[i][hInteriorZ]);
						GameTextForPlayer(playerid, "~w~Welcome Home", 5000, 1);
						PlayerInfo[playerid][pInt] = HouseInfo[i][hIntIW];
						PlayerInfo[playerid][pVW] = HouseInfo[i][hIntVW];
						SetPlayerVirtualWorld(playerid,HouseInfo[i][hIntVW]);
						if(HouseInfo[i][hCustomInterior] == 1) Player_StreamPrep(playerid, HouseInfo[i][hInteriorX],HouseInfo[i][hInteriorY],HouseInfo[i][hInteriorZ], FREEZE_TIME);
						break;
					}
				}
				PlayerInfo[playerid][pHospital] = 0;
				PlayerInfo[playerid][pInjured] = 0;
				SetCameraBehindPlayer(playerid);
				TogglePlayerControllable(playerid, 1);
			}
			case 9:
			{
                if(PlayerInfo[playerid][pSHealth] > 0) {
					SetPlayerArmor(playerid, PlayerInfo[playerid][pSHealth]);
				}
				SetPlayerHealth(playerid, 50.0);
				DeletePVar(playerid, "MedicBill");
				SendClientMessageEx(playerid, TEAM_CYAN_COLOR, "DOC: Chuc mot ngay tot lanh.");
				new Float:X, Float:Y, Float:Z;
				GetDynamicObjectPos(Carrier[0], X, Y, Z);
				SetPlayerPos(playerid, (X-0.377671),(Y-10.917018),11.6986);
				SetPlayerFacingAngle(playerid, 0);
				PlayerInfo[playerid][pHospital] = 0;
				PlayerInfo[playerid][pInjured] = 0;
				SetCameraBehindPlayer(playerid);
				TogglePlayerControllable(playerid, 1);
				//DeathDrop(playerid);
			}
			case 10:
			{
			    if(PlayerInfo[playerid][pSHealth] > 0) {
					SetPlayerArmor(playerid, PlayerInfo[playerid][pSHealth]);
				}
				SetPlayerHealth(playerid, 50.0);
				DeletePVar(playerid, "MedicBill");
				if(AcceptDeath[playerid] != 0) {
					ResetAttach(playerid);
	                Inventory_@ResetWeapon(playerid);
	
					AcceptDeath[playerid] = 0;
					GivePlayerMoneyEx(playerid, -5000);
				    SendClientMessageEx(playerid, COLOR_LIGHTRED, "[RESPAWN DEAD] Ban da su dung chap nhan chet, nhan vat bi tru $5.000.");
				}
				else {
					GivePlayerMoneyEx(playerid, -500);
				    SendClientMessageEx(playerid, COLOR_LIGHTRED, "[HOSPITAL] Ban ton $500 cho tien vien phi.");
				}
				for(new z; z < MAX_GROUPS; z++)
				{
					if(arrGroupData[z][g_iAllegiance] == 1)
					{
						if(arrGroupData[z][g_iGroupType] == 5)
						{
							new str[128], file[32], month, day, year;
							getdate(year,month,day);
							Tax += 250;
							format(str, sizeof(str), "%s has their medical fees, adding $250 to the vault.", GetPlayerNameEx(playerid));
							format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", z, month, day, year);
							Log(file, str);
							break;
						}
					}
				}
				Misc_Save();
				SendClientMessageEx(playerid, TEAM_CYAN_COLOR, "Hoa don benh vien $650. Chuc mot ngay tot lanh!");
				SetPlayerPos(playerid, -1514.809204, 2526.305175, 55.759651);
				SetPlayerFacingAngle(playerid, 357.79);
				PlayerInfo[playerid][pHospital] = 0;
				PlayerInfo[playerid][pInjured] = 0;
				SetCameraBehindPlayer(playerid);
				TogglePlayerControllable(playerid, 1);
				//DeathDrop(playerid);
			}
			case 11:
			{
                if(PlayerInfo[playerid][pSHealth] > 0) {
					SetPlayerArmor(playerid, PlayerInfo[playerid][pSHealth]);
				}
				SetPlayerHealth(playerid, 50.0);
				SendClientMessageEx(playerid, TEAM_CYAN_COLOR, "DOC: Hoa don cua ban duoc chi tra mien phi, chuc mot ngay vui ve!");
				SetPlayerPos(playerid, -1680.8573, 284.6186, 7.1875);
				SetCameraBehindPlayer(playerid);
				PlayerInfo[playerid][pHospital] = 0;
				PlayerInfo[playerid][pInjured] = 0;
				SetCameraBehindPlayer(playerid);
				TogglePlayerControllable(playerid, 1);
				//DeathDrop(playerid);
			}
			case 12:
			{
                if(PlayerInfo[playerid][pSHealth] > 0) {
					SetPlayerArmor(playerid, PlayerInfo[playerid][pSHealth]);
				}
				SetPlayerHealth(playerid, 50.0);
				SendClientMessageEx(playerid, TEAM_CYAN_COLOR, "DOC: Hoa don cua ban duoc chi tra mien phi, chuc mot ngay vui ve!");
				SetPlayerPos(playerid, 1607.4916, 1817.4746, 10.8203);
				SetCameraBehindPlayer(playerid);
				PlayerInfo[playerid][pHospital] = 0;
				PlayerInfo[playerid][pInjured] = 0;
				SetCameraBehindPlayer(playerid);
				TogglePlayerControllable(playerid, 1);
				//DeathDrop(playerid);
			}
			case 13: //Famed Lounge
			{
                if(PlayerInfo[playerid][pSHealth] > 0) {
					SetPlayerArmor(playerid, PlayerInfo[playerid][pSHealth]);
				}
				SetPlayerHealth(playerid, 50.0);
				SendClientMessageEx(playerid, TEAM_CYAN_COLOR, "DOC: Hoa don cua ban duoc chi tra mien phi, chuc mot ngay vui ve!");
				SetPlayerPos(playerid, 914.8001, 1427.6847, -81.1762);
				SetCameraBehindPlayer(playerid);
				PlayerInfo[playerid][pHospital] = 0;
				PlayerInfo[playerid][pInjured] = 0;
				SetCameraBehindPlayer(playerid);
				TogglePlayerControllable(playerid, 1);
				//DeathDrop(playerid);
			}
			case 14: //DeMorgan
			{
				if(PlayerInfo[playerid][pSHealth] > 0) {
					SetPlayerArmor(playerid, PlayerInfo[playerid][pSHealth]);
				}
				SetPlayerHealth(playerid, 50.0);
				SendClientMessageEx(playerid, TEAM_CYAN_COLOR, "DOC: Hoa don cua ban duoc chi tra mien phi, chuc mot ngay vui ve!");
				SetPlayerPos(playerid, 230.8369, 1980.1620, 17.6406);
				SetPlayerFacingAngle(playerid, 0);
				PlayerInfo[playerid][pHospital] = 0;
				PlayerInfo[playerid][pInjured] = 0;
				SetCameraBehindPlayer(playerid);
				TogglePlayerControllable(playerid, 1);
			}
			case 15: //TR - Bayside
			{
				if(PlayerInfo[playerid][pSHealth] > 0) {
					SetPlayerArmor(playerid, PlayerInfo[playerid][pSHealth]);
				}
				SetPlayerHealth(playerid, 50.0);
				DeletePVar(playerid, "MedicBill");
				if(AcceptDeath[playerid] != 0) {
					ResetAttach(playerid);
	                Inventory_@ResetWeapon(playerid);
	
					AcceptDeath[playerid] = 0;
					GivePlayerMoneyEx(playerid, -5000);
				    SendClientMessageEx(playerid, COLOR_LIGHTRED, "[RESPAWN DEAD] Ban da su dung chap nhan chet, nhan vat bi tru $5.000.");
				}
				else {
					GivePlayerMoneyEx(playerid, -500);
				    SendClientMessageEx(playerid, COLOR_LIGHTRED, "[HOSPITAL] Ban ton $500 cho tien vien phi.");
				}
				for(new z; z < MAX_GROUPS; z++)
				{
					if(arrGroupData[z][g_iAllegiance] == 1)
					{
						if(arrGroupData[z][g_iGroupType] == 5)
						{
							new str[128], file[32], month, day, year;
							getdate(year,month,day);
							Tax += 500;
							format(str, sizeof(str), "%s has their medical fees, adding $500 to the vault.", GetPlayerNameEx(playerid));
							format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", z, month, day, year);
							Log(file, str);
							break;
						}
					}
				}
				Misc_Save();
				SendClientMessageEx(playerid, TEAM_CYAN_COLOR, "Hoa don benh vien $500. Chuc mot ngay tot lanh!");
				SetPlayerPos(playerid, -2486.7124,2234.5493,4.8438);
				SetPlayerFacingAngle(playerid, -90);
				PlayerInfo[playerid][pHospital] = 0;
				PlayerInfo[playerid][pInjured] = 0;
				SetCameraBehindPlayer(playerid);
				TogglePlayerControllable(playerid, 1);
	            PlayerInfodl[playerid][dlish] = 50;
	            SetPlayerHealth(playerid, 50);
		        PlayerInfo[playerid][pHydration] = 100;
		        TogglePlayerControllable(playerid,1);
			}
	    }
	}

}

stock SetPlayerSpawn(playerid)
{
    if(IsPlayerConnected(playerid))
	{
	    SetPlayerSkin(playerid, PlayerInfo[playerid][pModel]);
		if(GetPVarInt(playerid, "IsInArena") >= 0)
		{
			SpawnPaintballArena(playerid, GetPVarInt(playerid, "IsInArena"));
			return 1;
		}
		if(GetPVarType(playerid, "SpecOff"))
		{
			SetPlayerInterior(playerid, GetPVarInt(playerid, "SpecInt"));
			PlayerInfo[playerid][pInt] = GetPVarInt(playerid, "SpecInt");
			SetPlayerVirtualWorld(playerid, GetPVarInt(playerid, "SpecVW"));
			PlayerInfo[playerid][pVW] = GetPVarInt(playerid, "SpecVW");
			SetPlayerPos(playerid, GetPVarFloat(playerid, "SpecPosX"), GetPVarFloat(playerid, "SpecPosY"), GetPVarFloat(playerid, "SpecPosZ"));
			if(GetPVarInt(playerid, "SpecInt") > 0) {
				Player_StreamPrep(playerid, GetPVarFloat(playerid, "SpecPosX"), GetPVarFloat(playerid, "SpecPosY"), GetPVarFloat(playerid, "SpecPosZ"), FREEZE_TIME);
			}
			DeletePVar(playerid, "SpecOff");
			DeletePVar(playerid, "SpecInt");
			DeletePVar(playerid, "SpecVW");
			DeletePVar(playerid, "SpecPosX");
			DeletePVar(playerid, "SpecPosY");
			DeletePVar(playerid, "SpecPosZ");
			if(GetPVarType(playerid, "pGodMode"))
	    	{
	        	SetPlayerHealth(playerid, 0x7FB00000);
		    	SetPlayerArmor(playerid, 0x7FB00000);
			}
			return 1;
		}
		if(PlayerInfo[playerid][pTut] == 0)
		{
			gOoc[playerid] = 1; gNews[playerid] = 1; gFam[playerid] = 1;
			TogglePlayerControllable(playerid, false);
			SetPlayerColor(playerid,TEAM_HIT_COLOR);
			PlayerNationSelection[playerid] = -1;
			PlayerHasNationSelected[playerid] = 0;
			SetPlayerInterior(playerid, 0);
			Streamer_UpdateEx(playerid, 2229.4968,-1722.0701,13.5625);
			SetPlayerCameraPos(playerid, 1527.1915, -1388.5413, 405.3455);
			SetPlayerCameraLookAt(playerid, 1527.1210, -1389.5367, 403.4106);
			SetPlayerPos(playerid, 1535.3447,-1357.3451,329.4568);
            PlayerInfo[playerid][pVW] = 0;
            SetPlayerVirtualWorld(playerid,0);
   			RegistrationStep[playerid] = 1;
   			SetPVarInt(playerid,"DangTaoAcc",1);
   			ShowPlayerDialog(playerid, REGISTERSEX, DIALOG_STYLE_LIST, "{FF0000}Nhan vat cua ban gioi tinh gi?", "Nam\nNu", "Lua chon", "");
			return 1;
		}
		new rand;
		if(PlayerInfo[playerid][pBeingSentenced] > 0)
		{
		    PhoneOnline[playerid] = 1;
		    rand = random(sizeof(WarrantJail));
			SetPlayerPos(playerid, WarrantJail[rand][0], WarrantJail[rand][1], WarrantJail[rand][2]);
			if(rand != 0) courtjail[playerid] = 2;
			else courtjail[playerid] = 1;
			Player_StreamPrep(playerid, WarrantJail[rand][0], WarrantJail[rand][1], WarrantJail[rand][2], FREEZE_TIME);
			PlayerInfo[playerid][pInt] = 0;
			DeletePVar(playerid, "Injured");
			SetPlayerColor(playerid, SHITTY_JUDICIALSHITHOTCH);
			return 1;
		}
		if(PlayerInfo[playerid][pJailTime] > 0)
		{
			DeletePVar(playerid, "Injured");
       	 	PlayerInfo[playerid][pInjured] = 0;
		    if(strfind(PlayerInfo[playerid][pPrisonReason], "[IC]", true) != -1)
		    {
                PhoneOnline[playerid] = 1;
				SetPlayerInterior(playerid, 6);
				SetPlayerVirtualWorld(playerid, 97);
				PlayerInfo[playerid][pInt] = 0;
				rand = random(sizeof(DocPrison));
    			SetPlayerPos(playerid, DocPrison[rand][0], DocPrison[rand][1], DocPrison[rand][2]);
				SetPlayerSkin(playerid, 50);
				SetPlayerColor(playerid, TEAM_ORANGE_COLOR);
				SetPlayerHealth(playerid, 100);
				DeletePVar(playerid, "Injured");
				Player_StreamPrep(playerid, DocPrison[rand][0], DocPrison[rand][1], DocPrison[rand][2], FREEZE_TIME);
				return 1;
		    }
		    else if(strfind(PlayerInfo[playerid][pPrisonReason], "[ISOLATE]", true) != -1)
		    {
		        PhoneOnline[playerid] = 1;
				SetPlayerInterior(playerid, 6);
				PlayerInfo[playerid][pInt] = 0;
				
				SetPlayerPos(playerid, -2095.3391, -215.8563, 978.8315);
				SetPlayerSkin(playerid, 50);
				SetPlayerHealth(playerid, 100);
				SetPlayerColor(playerid, TEAM_ORANGE_COLOR);
				DeletePVar(playerid, "Injured");
				Player_StreamPrep(playerid, -2095.3391, -215.8563, 978.8315, FREEZE_TIME);
				return 1;
		    }
		    else
		    {
		        SetPlayerHealth(playerid, 0x7FB00000);
		       	PhoneOnline[playerid] = 1;
				SetPlayerInterior(playerid, 6);
				PlayerInfo[playerid][pInt] = 6;
				rand = random(sizeof(OOCPrisonSpawns));
				SetPlayerPos(playerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2]);
				SetPlayerSkin(playerid, 50);
				SetPlayerColor(playerid, TEAM_APRISON_COLOR);
				new string[128];
				format(string, sizeof(string), "Ban bi vao tu, ly do: %s", PlayerInfo[playerid][pPrisonReason]);
				SendClientMessageEx(playerid, COLOR_LIGHTRED, string);
				ResetPlayerWeaponsEx(playerid);
				DeletePVar(playerid, "Injured");
				Player_StreamPrep(playerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2], FREEZE_TIME);
				return 1;
		    }
		}
		if(GetPVarInt(playerid, "Injured") == 1)
		{
		    SendEMSQueue(playerid,1);
		    return 1;
		}
		if(GetPVarInt(playerid, "EventToken") == 1)
		{
			for(new i; i < sizeof(EventKernel[EventStaff]); i++)
			{
				if(EventKernel[EventStaff][i] == playerid)
				{
					new Float:health, Float:armor;
					ResetPlayerWeapons( playerid );
					DeletePVar(playerid, "EventToken");
					SetPlayerWeapons(playerid);
					SetPlayerToTeamColor(playerid);
					SetPlayerSkin(playerid, PlayerInfo[playerid][pModel]);
					SetPlayerPos(playerid,EventFloats[playerid][1],EventFloats[playerid][2],EventFloats[playerid][3]);
					SetPlayerVirtualWorld(playerid, EventLastVW[playerid]);
					SetPlayerFacingAngle(playerid, EventFloats[playerid][0]);
					SetPlayerInterior(playerid,EventLastInt[playerid]);
					Player_StreamPrep(playerid, EventFloats[playerid][1],EventFloats[playerid][2],EventFloats[playerid][3], FREEZE_TIME);
					if(EventKernel[EventType] == 4)
					{
						if(GetPVarType(playerid, "pEventZombie")) DeletePVar(playerid, "pEventZombie");
						SetPlayerToTeamColor(playerid);
					}
					for(new d = 0; d < 6; d++)
					{
						EventFloats[playerid][d] = 0.0;
					}
					EventLastVW[playerid] = 0;
					EventLastInt[playerid] = 0;
					RemovePlayerWeapon(playerid, 38);
					health = GetPVarFloat(playerid, "pPreGodHealth");
					SetPlayerHealth(playerid,health);
					armor = GetPVarFloat(playerid, "pPreGodArmor");
					SetPlayerArmor(playerid, armor);
					DeletePVar(playerid, "pPreGodHealth");
					DeletePVar(playerid, "pPreGodArmor");
					DeletePVar(playerid, "eventStaff");
					return 1;
				}
			}
            if(EventKernel[EventType] == 4)
			{
			   	SetPlayerPos(playerid, EventKernel[ EventPositionX ], EventKernel[ EventPositionY ], EventKernel[ EventPositionZ ] );
				SetPlayerInterior(playerid, EventKernel[ EventInterior ] );
				SetPlayerVirtualWorld(playerid, EventKernel[ EventWorld ] );
				SendClientMessageEx(playerid, COLOR_WHITE, "Ban la zombie! Su dung /bite de lay nhiem nguoi khac");
				SetPlayerHealth(playerid, 30);
				RemoveArmor(playerid);
				SetPlayerSkin(playerid, 20001);
				SetPlayerColor(playerid, 0x0BC43600);
				SetPVarInt(playerid, "pEventZombie", 1);
				return 1;
			}
			else
			{
			    DeletePVar(playerid, "EventToken");
			    SetPlayerWeapons(playerid);
			    SetPlayerPos(playerid,EventFloats[playerid][1],EventFloats[playerid][2],EventFloats[playerid][3]);
				//PlayerInfo[playerid][pInterior] = PlayerInfo[playerid][pInt];
				SetPlayerVirtualWorld(playerid, EventLastVW[playerid]);
				SetPlayerFacingAngle(playerid, EventFloats[playerid][0]);
				SetPlayerInterior(playerid,EventLastInt[playerid]);
				Player_StreamPrep(playerid, EventFloats[playerid][1],EventFloats[playerid][2],EventFloats[playerid][3], FREEZE_TIME);
				SetPlayerHealth(playerid, EventFloats[playerid][4]);
				if(EventFloats[playerid][5] > 0) {
					SetPlayerArmor(playerid, EventFloats[playerid][5]);
				}
				for(new i = 0; i < 6; i++)
				{
				    EventFloats[playerid][i] = 0.0;
				}
				EventLastVW[playerid] = 0;
				EventLastInt[playerid] = 0;
				return 1;
			}
		}
		// if(PlayerInfo[playerid][pInjured] != 0 && AcceptDeath[playerid] == 0 ) {
		// 	print("alo");
            
        //     PlayerInfo[playerid][pPos_x] = GetPVarFloat(playerid,#DeathX);
        //     PlayerInfo[playerid][pPos_y] = GetPVarFloat(playerid,#DeathY);
        //     PlayerInfo[playerid][pPos_z] = GetPVarFloat(playerid,#DeathZ);
        //     printf("%f, %f, %f",PlayerInfo[playerid][pPos_x] ,PlayerInfo[playerid][pPos_y] ,PlayerInfo[playerid][pPos_z] );
        //     SetPVarInt(playerid, "InjuredVW", GetPlayerVirtualWorld(playerid));
        //     SetPVarInt(playerid, "InjuredInt", GetPlayerInterior(playerid));
        //     SetPlayerHealth(playerid, 25);
            
        //     SetPlayerPos(playerid, PlayerInfo[playerid][pPos_x], PlayerInfo[playerid][pPos_y], PlayerInfo[playerid][pPos_z]);

        //     SetPlayerInterior(playerid, GetPVarInt(playerid, "InjuredInt"));
        //     SetPlayerVirtualWorld(playerid, GetPVarInt(playerid, "InjuredVW"));
                


        //     ApplyAnimation(playerid, "SWEET", "Sweet_injuredloop", 4.1, 1, 0, 0, 1, 0, 1);

        //     PlayerInfo[playerid][pInjured] = 1;
        //     AcceptDeath[playerid] = 0;
		// }
		if(GetPVarInt(playerid, "MedicBill") == 1 && PlayerInfo[playerid][pJailTime] == 0 && AcceptDeath[playerid] == 1)
		{
		    #if defined zombiemode
	    	if(zombieevent == 1 && GetPVarType(playerid, "pIsZombie"))
			{
				SpawnZombie(playerid);
  				return 1;
			}
			#endif
			PlayerInfo[playerid][pDuty] = 0;
			PlayerInfo[playerid][pVW] = 0;
			PlayerInfo[playerid][pInt] = 0;

			//Tazer & Cuff reset
			PlayerInfo[playerid][pHasCuff] = 0;
			PlayerInfo[playerid][pHasTazer] = 0;

		

			SetPlayerVirtualWorld(playerid, 0);
			ResetPlayerWeapons(playerid);

			PlayerInfo[playerid][pInjured] = 0;
    
			if( GetPVarInt( playerid, "EventToken" ) == 1 )
			{
			    //Code Here
			}
			else
			{
				ResetPlayerWeaponsEx(playerid);
			}

			SetPVarInt(playerid, "MedicBill", 1);
			SetPlayerInterior(playerid, 0);
			new string[70+MAX_PLAYER_NAME];
			if(PlayerInfo[playerid][pWantedLevel] > 1 && PlayerInfo[playerid][pInsurance] > 5)
			{
				new randhos = Random(1, 6);
				switch (randhos)
   				{
    				case 1:
  	    			{
						SendClientMessageEx(playerid, COLOR_YELLOW, " Canh sat da duoc thong bao rang ban dang bi truy na va ho dang tren duong toi.");
						format(string, sizeof(string), " County General Hospital da bao cao doi tuong truy na %s dang o day.", GetPlayerNameEx(playerid));
						SetPlayerCameraPos(playerid,1999.5308,-1449.3281,13.5594+6.0);
						SetPlayerCameraLookAt(playerid,2036.2179,-1410.3223,17.1641);
						SetPlayerPos(playerid, 1999.5308,-1449.3281,10.5594);
						PlayerInfo[playerid][pHospital] = 2;
					}
					case 2:
					{
						SendClientMessageEx(playerid, COLOR_YELLOW, " Canh sat da duoc thong bao rang ban dang bi truy na va ho dang tren duong toi.");
						format(string, sizeof(string), " All Saints Hospital da bao cao doi tuong truy na %s dang o day.", GetPlayerNameEx(playerid));
						SetPlayerCameraPos(playerid,1188.4574,-1309.2242,13.5625+6.0);
						SetPlayerCameraLookAt(playerid,1175.5581,-1324.7922,18.1610);
						SetPlayerPos(playerid, 1188.4574,-1309.2242,10.5625); // Warp the player
						PlayerInfo[playerid][pHospital] = 1;
					}
					case 3:
					{
						SendClientMessageEx(playerid, COLOR_YELLOW, " Canh sat da duoc thong bao rang ban dang bi truy na va ho dang tren duong toi.");
						format(string, sizeof(string), " Red County Hospital da bao cao doi tuong truy na %s dang o day.", GetPlayerNameEx(playerid));
						SetPlayerCameraPos(playerid,1248.4147,338.8385,19.4063+6.0);
						SetPlayerCameraLookAt(playerid,1241.4449,326.3389,19.7555);
						SetPlayerPos(playerid, 1248.4147,338.8385,19.4063);
						PlayerInfo[playerid][pHospital] = 3;
					}
					case 4:
					{
						SendClientMessageEx(playerid, COLOR_YELLOW, " Canh sat da duoc thong bao rang ban dang bi truy na va ho dang tren duong toi.");
						format(string, sizeof(string), " Fort Carson Hospital da bao cao doi tuong truy na %s dang o day.", GetPlayerNameEx(playerid));
						SetPlayerCameraPos(playerid,-314.0242,1060.7919,19.5938+6.0);
						SetPlayerCameraLookAt(playerid,-320.0992,1049.0341,20.3403);
						SetPlayerPos(playerid, -314.0242,1060.7919,19.5938);
						PlayerInfo[playerid][pHospital] = 4;
					}
					case 5:
					{
						SendClientMessageEx(playerid, COLOR_YELLOW, " Canh sat da duoc thong bao rang ban dang bi truy na va ho dang tren duong toi.");
						format(string, sizeof(string), " San Fierro Hospital da bao cao doi tuong truy na %s dang o day.", GetPlayerNameEx(playerid));
						SetPlayerCameraPos(playerid,-2571.2766,558.7813,68.1754);
						SetPlayerCameraLookAt(playerid,-2619.2883,596.2850,49.0966);
						SetPlayerPos(playerid, -2653.6685,626.6485,4.8930);
						PlayerInfo[playerid][pHospital] = 5;
					}
				}
				SendGroupMessage(1, DEPTRADIO, string);
			}
			else if(PlayerInfo[playerid][pInsurance] == 1)
			{
				SetPlayerCameraPos(playerid, 1155.9202, -1310.7156, -42.7173);//SF
				SetPlayerCameraLookAt(playerid, 1155.9202, -1310.7156, -42.7173);
				SetPlayerPos(playerid, 1155.9202, -1310.7156, -42.7173);
				PlayerInfo[playerid][pHospital] = 2;
			}
			else if(PlayerInfo[playerid][pInsurance] == 2)
			{
				SetPlayerCameraPos(playerid,1188.4574,-1309.2242,13.5625+6.0);
				SetPlayerCameraLookAt(playerid,1175.5581,-1324.7922,18.1610);
				SetPlayerPos(playerid, 1188.4574,-1309.2242,10.5625); // Warp the player
				PlayerInfo[playerid][pHospital] = 1;
			}
			else if(PlayerInfo[playerid][pInsurance] == 3)
			{
				SetPlayerCameraPos(playerid,1237.849243, 352.657409, 23.576650);
				SetPlayerCameraLookAt(playerid,1239.147705, 348.883331, 23.311220);
				SetPlayerPos(playerid, 1248.4147,338.8385,16.0);
				PlayerInfo[playerid][pHospital] = 3;
			}
   			else if(PlayerInfo[playerid][pInsurance] == 4)
			{
				SetPlayerCameraPos(playerid,-314.0242,1060.7919,19.5938+6.0);
				SetPlayerCameraLookAt(playerid,-320.0992,1049.0341,20.3403);
				SetPlayerPos(playerid, -314.0242,1060.7919,19.5938);
				PlayerInfo[playerid][pHospital] = 4;
			}
			else if(PlayerInfo[playerid][pInsurance] == 5)
			{
				SetPlayerCameraPos(playerid,-2571.2766,558.7813,68.1754);
				SetPlayerCameraLookAt(playerid,-2619.2883,596.2850,49.0966);
				SetPlayerPos(playerid, -2653.6685,626.6485,4.8930);
				PlayerInfo[playerid][pHospital] = 5;
			}
			else if(PlayerInfo[playerid][pInsurance] == 6)
			{
			    if(PlayerInfo[playerid][pDonateRank] >= 3)
			    {
					SetPlayerCameraPos(playerid,2787.102050, 2392.162841, 1243.898681);
					SetPlayerCameraLookAt(playerid,2801.281982, 2404.575683, 1240.531127);
					SetPlayerPos(playerid, 2788.561523, 2387.321044, 1227.350219);
					PlayerInfo[playerid][pHospital] = 7;
				}
				else
				{
					PlayerInfo[playerid][pInsurance] = 0;
			        SetPlayerSpawn(playerid);
				}
			}
			else if(PlayerInfo[playerid][pInsurance] == 7)
			{
				SetPlayerCameraPos(playerid,2787.102050, 2392.162841, 1243.898681);
				SetPlayerCameraLookAt(playerid,2801.281982, 2404.575683, 1240.531127);
				SetPlayerPos(playerid, 2788.561523, 2387.321044, 1227.350219);
				PlayerInfo[playerid][pHospital] = 8;
			}
			else if(PlayerInfo[playerid][pInsurance] == 8)
			{

			    new Float:X, Float:Y, Float:Z;
				GetDynamicObjectPos(Carrier[0], X, Y, Z);
				SetPlayerCameraPos(playerid,(X-100),(Y-100),30);
				SetPlayerCameraLookAt(playerid,X, Y, Z);
				SetPlayerPos(playerid, (X-0.377671),(Y-10.917018),0);
				PlayerInfo[playerid][pHospital] = 9;
			}
			else if(PlayerInfo[playerid][pInsurance] == 9)
			{
				SetPlayerCameraPos(playerid, -1529.847167, 2539.394042, 62.038913);
				SetPlayerCameraLookAt(playerid, -1514.883300, 2527.161132, 55.743553);
				SetPlayerPos(playerid, -1514.809204, 2526.305175, 51.865501);
				PlayerInfo[playerid][pHospital] = 10;
			}
			else if(PlayerInfo[playerid][pInsurance] == 10)
			{
				if(!IsACop(playerid))
				{
			        PlayerInfo[playerid][pInsurance] = 0;
			        SetPlayerSpawn(playerid);
				}
				else
				{
					SetPlayerPos(playerid,-1633.0745, 266.1379, 1.2124);
					SetPlayerCameraPos(playerid, -1633.7493, 266.4792, 28.4621);
					SetPlayerCameraLookAt(playerid, -1634.6990, 266.8079, 28.1269);
					TogglePlayerControllable(playerid, 0);
					PlayerInfo[playerid][pHospital] = 11;
				}
			}
            else if(PlayerInfo[playerid][pInsurance] == 11)
			{
				SetPlayerCameraPos(playerid, 1575.5074, 1862.8700, 22.8418);
				SetPlayerCameraLookAt(playerid, 1607.4342, 1826.3204, 10.8203);
				SetPlayerPos(playerid, 1578.7942, 1862.1686, 3.6148);
				PlayerInfo[playerid][pHospital] = 12;
			}
			else if(PlayerInfo[playerid][pInsurance] == 12)
			{
				SetPlayerCameraPos(playerid, 922.253, 1430.680, -80.411);
    			SetPlayerCameraLookAt(playerid,917.2774,1425.5016,-80.7928);
				SetPlayerPos(playerid, 922.4749, 1430.8566, -85.9349);
				PlayerInfo[playerid][pHospital] = 13;
			}
			else if(PlayerInfo[playerid][pInsurance] == 13) //DeMorgan
			{
				SetPlayerCameraPos(playerid, 241.085021, 2018.862182, 24.019464);
				SetPlayerCameraLookAt(playerid, 239.654739, 2015.127685, 23.928848);
				SetPlayerPos(playerid, 226.7881,1981.7726,11.6014);
				PlayerInfo[playerid][pHospital] = 14;
			}
			else if(PlayerInfo[playerid][pInsurance] == 14) //TR - Bayside
			{
				SetPlayerCameraPos(playerid, -2472.393310, 2255.071777, 8.939566);
				SetPlayerCameraLookAt(playerid, -2475.382324, 2252.422119, 9.152222);
				SetPlayerPos(playerid, -2486.7124,2234.5493,1.0);
				PlayerInfo[playerid][pHospital] = 15;
			}
   			if(PlayerInfo[playerid][pInsurance] == 0)
			{
				new randhos = Random(1,3);
 				switch (randhos)
   				{
    				case 1:
  	    			{
    					if(PlayerInfo[playerid][pWantedLevel] >= 1)
						{
				    		SendClientMessageEx(playerid, COLOR_YELLOW, " Canh sat da duoc thong bao rang ban dang bi truy na va ho dang tren duong toi.");
				    		format(string, sizeof(string), " All Saints Hospital da bao cao doi tuong truy na %s dang o day.", GetPlayerNameEx(playerid));
				    		SendGroupMessage(1, DEPTRADIO, string);
						}

						SetPlayerCameraPos(playerid,1188.4574,-1309.2242,13.5625+6.0);
						SetPlayerCameraLookAt(playerid,1175.5581,-1324.7922,18.1610);
						SetPlayerPos(playerid, 1188.4574,-1309.2242,10.5625); // Warp the player
						PlayerInfo[playerid][pHospital] = 6;
  	    			}
    	    		case 2:
	    	    	{
    			    	if(PlayerInfo[playerid][pWantedLevel] >= 1)
						{
				    		SendClientMessageEx(playerid, COLOR_YELLOW, " Canh sat da duoc thong bao rang ban dang bi truy na va ho dang tren duong toi.");
				    		format(string, sizeof(string), " County General Hospital da bao cao doi tuong truy na %s dang o day.", GetPlayerNameEx(playerid));
				    		SendGroupMessage(1, DEPTRADIO, string);
						}

						SetPlayerCameraPos(playerid,1999.5308,-1449.3281,13.5594+6.0);
						SetPlayerCameraLookAt(playerid,2036.2179,-1410.3223,17.1641);
						SetPlayerPos(playerid, 1999.5308,-1449.3281,10.5594);
						PlayerInfo[playerid][pHospital] = 2;
   					}
   				}
			}
			TogglePlayerControllable(playerid, 0);
			SetPlayerHealth(playerid, 0.5);
			if(PlayerInfo[playerid][pHealthCare] == 0)
			{
			    //SendClientMessageEx(playerid, COLOR_CYAN, "Ban khong co tieu chuan de cham soc suc khoe tot hon, su dung /chamsocsuckhoe de mua goi cham soc suc khoe khi vao vien.");
				SetPVarInt(playerid, "HospitalTimer", 35);
			}
			else if(PlayerInfo[playerid][pHealthCare] == 1)
			{
			    if(PlayerInfo[playerid][pCredits] >= ShopItems[18][sItemPrice])
			    {
			        GivePlayerCredits(playerid, -ShopItems[18][sItemPrice], 1);
			        printf("Price18: %d", 1);
			    	SetPVarInt(playerid, "HealthCareActive", 1);

                    AmountSold[18]++;
                    AmountMade[18] += ShopItems[18][sItemPrice];
					new szQuery[128];
				 	format(szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold18` = '%d', `AmountMade18` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[18], AmountMade[18]);
					mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "i", SENDDATA_THREAD);

					format(string, sizeof(string), "[HC] [User: %s(%i)][IP: %s][Credits: %s][Binh thuong][Gia: %s]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[18][sItemPrice]));
					Log("logs/credits.log", string), print(string);
				}
				else
				{
				    SendClientMessageEx(playerid, COLOR_CYAN, "Ban khong du credits de mua goi cham soc suc khoe binh thuong.");
				}
			    SetPVarInt(playerid, "HospitalTimer", 35);
			}
			else
			{
			    if(PlayerInfo[playerid][pCredits] >= ShopItems[19][sItemPrice])
			    {
			        GivePlayerCredits(playerid, -ShopItems[19][sItemPrice], 1);
			        printf("Price19: %d", 2);
			    	SetPVarInt(playerid, "HospitalTimer", 5);
			    	SetPVarInt(playerid, "HealthCareActive", 1);
                    AmountSold[19]++;
					AmountMade[19] += ShopItems[19][sItemPrice];
					new szQuery[128];
					format(szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold19` = '%d', `AmountMade19` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[19], AmountMade[19]);
					mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "i", SENDDATA_THREAD);

			    	format(string, sizeof(string), "[HC] [User: %s(%i)][IP: %s][Credits: %s][Nang cao][Gia: %s]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[19][sItemPrice]));
					Log("logs/credits.log", string), print(string);
				}
				else
				{
				    SetPVarInt(playerid, "HospitalTimer", 35);
				    SendClientMessageEx(playerid, COLOR_CYAN, "Ban khong du credits de mua goi cham soc suc khoe nang cao.");
				}
			}
			SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_HOSPITALTIMER);
			return 1;
		}
		if(PlayerInfo[playerid][pHospital] == 0)
		{
			SetPlayerPos(playerid,PlayerInfo[playerid][pPos_x],PlayerInfo[playerid][pPos_y],PlayerInfo[playerid][pPos_z]);
			SetPlayerVirtualWorld(playerid, PlayerInfo[playerid][pVW]);
			SetPlayerFacingAngle(playerid, PlayerInfo[playerid][pPos_r]);
			SetPlayerInterior(playerid,PlayerInfo[playerid][pInt]);
			if(PlayerInfo[playerid][pHealth] < 1) PlayerInfo[playerid][pHealth] = 100;
			SetPlayerHealth(playerid, PlayerInfo[playerid][pHealth]);
			if(PlayerInfo[playerid][pArmor] > 0) {
				SetPlayerArmor(playerid, PlayerInfo[playerid][pArmor]);
			}
			SetCameraBehindPlayer(playerid);
			if(PlayerInfo[playerid][pInt] > 0) Player_StreamPrep(playerid, PlayerInfo[playerid][pPos_x],PlayerInfo[playerid][pPos_y],PlayerInfo[playerid][pPos_z], FREEZE_TIME);
		}
		else
		{
		    PlayerInfo[playerid][pDuty] = 0;
			PlayerInfo[playerid][pVW] = 0;
			PlayerInfo[playerid][pInt] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			if( GetPVarInt( playerid, "EventToken" ) == 1 )
			{
				//SendClientMessageEx( playerid, COLOR_WHITE, "As you've just come from an event, your weapons have been refunded." );
			}
			else
			{
				ResetPlayerWeaponsEx(playerid);
			}

			SetPVarInt(playerid, "MedicBill", 1);
			new string[70+MAX_PLAYER_NAME];
			if(PlayerInfo[playerid][pInsurance] == 1)
			{
			    if(PlayerInfo[playerid][pWantedLevel] >= 1)
				{
				    SendClientMessageEx(playerid, COLOR_YELLOW, "Canh sat da duoc thong bao rang ban dang bi truy na va ho dang tren duong toi.");
				    format(string, sizeof(string), " County General Hospital da bao cao doi tuong truy na %s dang o day.", GetPlayerNameEx(playerid));
				    SendGroupMessage(1, DEPTRADIO, string);
				}
				SetPlayerCameraPos(playerid,1999.5308,-1449.3281,13.5594+6.0);
				SetPlayerCameraLookAt(playerid,2036.2179,-1410.3223,17.1641);
				SetPlayerPos(playerid, 1999.5308,-1449.3281,10.5594);
				PlayerInfo[playerid][pHospital] = 2;
			}
			else if(PlayerInfo[playerid][pInsurance] == 2)
			{
			    if(PlayerInfo[playerid][pWantedLevel] >= 1)
				{
				    SendClientMessageEx(playerid, COLOR_YELLOW, "Canh sat da duoc thong bao rang ban dang bi truy na va ho dang tren duong toi.");
				    format(string, sizeof(string), " All Saints Hospital da bao cao doi tuong truy na %s dang o day.", GetPlayerNameEx(playerid));
				    SendGroupMessage(1, DEPTRADIO, string);
				}
				SetPlayerCameraPos(playerid,1188.4574,-1309.2242,13.5625+6.0);
				SetPlayerCameraLookAt(playerid,1175.5581,-1324.7922,18.1610);
				SetPlayerPos(playerid, 1188.4574,-1309.2242,10.5625); // Warp the player
				PlayerInfo[playerid][pHospital] = 1;
			}
			else if(PlayerInfo[playerid][pInsurance] == 3)
			{
			    if(PlayerInfo[playerid][pWantedLevel] >= 1)
				{
				    SendClientMessageEx(playerid, COLOR_YELLOW, "Canh sat da duoc thong bao rang ban dang bi truy na va ho dang tren duong toi.");
				    format(string, sizeof(string), " Red County Hospital da bao cao doi tuong truy na %s dang o day.", GetPlayerNameEx(playerid));
				    SendGroupMessage(1, DEPTRADIO, string);
				}
				SetPlayerCameraPos(playerid,1248.4147,338.8385,19.4063+6.0);
				SetPlayerCameraLookAt(playerid,1241.4449,326.3389,19.7555);
				SetPlayerPos(playerid, 1248.4147,338.8385,19.4063);
				PlayerInfo[playerid][pHospital] = 3;
			}
   			else if(PlayerInfo[playerid][pInsurance] == 4)
			{
			    if(PlayerInfo[playerid][pWantedLevel] >= 1)
				{
				    SendClientMessageEx(playerid, COLOR_YELLOW, "Canh sat da duoc thong bao rang ban dang bi truy na va ho dang tren duong toi.");
				    format(string, sizeof(string), " Fort Carson Hospital da bao cao doi tuong truy na %s dang o day.", GetPlayerNameEx(playerid));
				    SendGroupMessage(1, DEPTRADIO, string);
				}
				SetPlayerCameraPos(playerid,-314.0242,1060.7919,19.5938+6.0);
				SetPlayerCameraLookAt(playerid,-320.0992,1049.0341,20.3403);
				SetPlayerPos(playerid, -314.0242,1060.7919,19.5938);
				PlayerInfo[playerid][pHospital] = 4;
			}
			else if(PlayerInfo[playerid][pInsurance] == 5)
			{
			    if(PlayerInfo[playerid][pWantedLevel] >= 1)
				{
				    SendClientMessageEx(playerid, COLOR_YELLOW, " Canh sat da duoc thong bao rang ban dang bi truy na va ho dang tren duong toi.");
				    format(string, sizeof(string), " San Fierro Hospital da bao cao doi tuong truy na %s dang o day.", GetPlayerNameEx(playerid));
				    SendGroupMessage(1, DEPTRADIO, string);
				}
				SetPlayerCameraPos(playerid,-2571.2766,558.7813,68.1754);
				SetPlayerCameraLookAt(playerid,-2619.2883,596.2850,49.0966);
				SetPlayerPos(playerid, -2653.6685,626.6485,4.8930);
				PlayerInfo[playerid][pHospital] = 5;
			}
			else if(PlayerInfo[playerid][pInsurance] == 6)
			{
				SetPlayerCameraPos(playerid,2787.102050, 2392.162841, 1243.898681);
				SetPlayerCameraLookAt(playerid,2801.281982, 2404.575683, 1240.531127);
				SetPlayerPos(playerid, 2788.561523, 2387.321044, 1227.350219);
				PlayerInfo[playerid][pHospital] = 7;
			}
			else if(PlayerInfo[playerid][pInsurance] == 7)
			{
				SetPlayerCameraPos(playerid,2787.102050, 2392.162841, 1243.898681);
				SetPlayerCameraLookAt(playerid,2801.281982, 2404.575683, 1240.531127);
				SetPlayerPos(playerid, 2788.561523, 2387.321044, 1227.350219);
				PlayerInfo[playerid][pHospital] = 8;
			}
			else if(PlayerInfo[playerid][pInsurance] == 8)
			{
			    new Float:X, Float:Y, Float:Z;
				GetDynamicObjectPos(Carrier[0], X, Y, Z);
				SetPlayerCameraPos(playerid,(X-100),(Y-100),30);
				SetPlayerCameraLookAt(playerid,X, Y, Z);
				SetPlayerPos(playerid, (X-0.377671),(Y-10.917018),0);
				PlayerInfo[playerid][pHospital] = 9;
			}
			else if(PlayerInfo[playerid][pInsurance] == 9)
			{
				SetPlayerCameraPos(playerid, -1529.847167, 2539.394042, 62.038913);
				SetPlayerCameraLookAt(playerid, -1514.883300, 2527.161132, 55.743553);
				SetPlayerPos(playerid, -1514.809204, 2526.305175, 51.865501);
				PlayerInfo[playerid][pHospital] = 10;
			}
   			if(PlayerInfo[playerid][pInsurance] == 0)
			{
				new randhos = Random(1,3);
 				switch(randhos)
   				{
    				case 1:
  	    			{
    					if(PlayerInfo[playerid][pWantedLevel] >= 1)
						{
				    		SendClientMessageEx(playerid, COLOR_YELLOW, " Canh sat da duoc thong bao rang ban dang bi truy na va ho dang tren duong toi.");
				    		format(string, sizeof(string), " All Saints Hospital da bao cao doi tuong truy na %s dang o day.", GetPlayerNameEx(playerid));
				    		SendGroupMessage(1, DEPTRADIO, string);
						}

						SetPlayerCameraPos(playerid,1188.4574,-1309.2242,13.5625+6.0);
						SetPlayerCameraLookAt(playerid,1175.5581,-1324.7922,18.1610);
						SetPlayerPos(playerid, 1188.4574,-1309.2242,10.5625); // Warp the player
						PlayerInfo[playerid][pHospital] = 6;
  	    			}
    	    		case 2:
	    	    	{
    			    	if(PlayerInfo[playerid][pWantedLevel] >= 1)
						{
				    		SendClientMessageEx(playerid, COLOR_YELLOW, " Canh sat da duoc thong bao rang ban dang bi truy na va ho dang tren duong toi.");
				    		format(string, sizeof(string), " County General Hospital da bao cao doi tuong truy na %s dang o day", GetPlayerNameEx(playerid));
				    		SendGroupMessage(1, DEPTRADIO, string);
						}

						SetPlayerCameraPos(playerid,1999.5308,-1449.3281,13.5594+6.0);
						SetPlayerCameraLookAt(playerid,2036.2179,-1410.3223,17.1641);
						SetPlayerPos(playerid, 1999.5308,-1449.3281,10.5594);
						PlayerInfo[playerid][pHospital] = 2;
   					}
   				}
			}
			TogglePlayerControllable(playerid, 0);
			SetPlayerHealth(playerid, 0.5);
			if(PlayerInfo[playerid][pHealthCare] == 0)
			{
		//	    SendClientMessageEx(playerid, COLOR_CYAN, "Ban khong co tieu chuan de cham soc suc khoe tot hon, su dung /chamsocsuckhoe de mua goi cham soc suc khoe khi vao vien.");
				SetPVarInt(playerid, "HospitalTimer", 35);
			}
			else if(PlayerInfo[playerid][pHealthCare] == 1)
			{
			    if(PlayerInfo[playerid][pCredits] >= ShopItems[18][sItemPrice])
			    {
			        GivePlayerCredits(playerid, -ShopItems[18][sItemPrice], 1);
			        printf("Price18: %d", 1);
			    	SetPVarInt(playerid, "HealthCareActive", 1);
                    AmountSold[18]++;
					AmountMade[18] += ShopItems[18][sItemPrice];
			    	//ShopItems[18][sSold]++;
					//ShopItems[18][sMade] += ShopItems[18][sItemPrice];
					new szQuery[128];
				 	format(szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold18` = '%d', `AmountMade18` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[18], AmountMade[18]);
					mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "i", SENDDATA_THREAD);

					format(string, sizeof(string), "[HC] [User: %s(%i)][IP: %s][Credits: %s][Binh thuong][Gia: %s]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[18][sItemPrice]));
					Log("logs/credits.log", string), print(string);
				}
				else
				{
				    SendClientMessageEx(playerid, COLOR_CYAN, "Ban khong du credits de mua goi cham soc suc khoe binh thuong");
				}
			    SetPVarInt(playerid, "HospitalTimer", 35);
			}
			else
			{
			    if(PlayerInfo[playerid][pCredits] >= ShopItems[19][sItemPrice])
			    {
			        GivePlayerCredits(playerid, -ShopItems[19][sItemPrice], 1);
			        printf("Price19: %d", ShopItems[19][sItemPrice]);
			    	SetPVarInt(playerid, "HospitalTimer", 5);
			    	SetPVarInt(playerid, "HealthCareActive", 1);
                    AmountSold[19]++;
					AmountMade[19] += ShopItems[19][sItemPrice];
			    	//ShopItems[19][sSold]++;
					//ShopItems[19][sMade] += ShopItems[19][sItemPrice];
					new szQuery[128];
				 	format(szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold19` = '%d', `AmountMade19` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[19], AmountMade[19]);
					mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "i", SENDDATA_THREAD);

			    	format(string, sizeof(string), "[HC] [User: %s(%i)][IP: %s][Credits: %s][Nang cao][Price: %s]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[19][sItemPrice]));
					Log("logs/credits.log", string), print(string);
				}
				else
				{
				    SetPVarInt(playerid, "HospitalTimer", 35);
				    SendClientMessageEx(playerid, COLOR_CYAN, "Ban khong du credits de mua goi cham soc suc khoe nang cao.");
				}
			}
			SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_HOSPITALTIMER);
		}
		if( PlayerInfo[playerid][pInjured] != 0) {
			SetPlayerPos(playerid, PlayerInfo[playerid][pPos_x], PlayerInfo[playerid][pPos_y],PlayerInfo[playerid][pPos_z]);
			SetPlayerFacingAngle(playerid,PlayerInfo[playerid][pPos_r]);
		}
		new Float: x, Float: y, Float: z;
		GetPlayerPos(playerid, x, y, z);
		if(x == 0.0 && y == 0.0 && gPlayerLogged{playerid} == 1 && PlayerInfo[playerid][pInjured] != 0)
		{
  			SetPlayerInterior(playerid,0);
			SetPlayerPos(playerid, 1715.1201,-1903.1711,13.5665);
			SetPlayerFacingAngle(playerid, 359.4621);
			SetCameraBehindPlayer(playerid);
		}
		SetPlayerToTeamColor(playerid);
		return 1;
	}
	return 1;
}

stock IsAtFishPlace(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		if(IsPlayerInRangeOfPoint(playerid,1.0,403.8266,-2088.7598,7.8359) || IsPlayerInRangeOfPoint(playerid,1.0,398.7553,-2088.7490,7.8359))
		{//Fishplace at the bigwheel
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,1.0,396.2197,-2088.6692,7.8359) || IsPlayerInRangeOfPoint(playerid,1.0,391.1094,-2088.7976,7.8359))
		{//Fishplace at the bigwheel
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,1.0,383.4157,-2088.7849,7.8359) || IsPlayerInRangeOfPoint(playerid,1.0,374.9598,-2088.7979,7.8359))
		{//Fishplace at the bigwheel
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,1.0,369.8107,-2088.7927,7.8359) || IsPlayerInRangeOfPoint(playerid,1.0,367.3637,-2088.7925,7.8359))
		{//Fishplace at the bigwheel
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,1.0,362.2244,-2088.7981,7.8359) || IsPlayerInRangeOfPoint(playerid,1.0,354.5382,-2088.7979,7.8359))
		{//Fishplace at the bigwheel
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,2.0,-1630.1006,1298.6746,7.1797) || IsPlayerInRangeOfPoint(playerid,2.0,-1630.1006,1298.6746,7.1797))
		{//Fishplace at the bigwheel
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,2.0,-1647.4844,1317.5016,7.1747) || IsPlayerInRangeOfPoint(playerid,2.0,-1647.4844,1317.5016,7.1747))
		{//Fishplace at the bigwheel
			return 1;
		}
	}
	return 0;
}
stock fcreate(filename[])
{
	if (fexist(filename)) return false;
	new File:fhnd;
	fhnd=fopen(filename,io_write);
	if (fhnd) {
		fclose(fhnd);
		return true;
	}
	return false;
}

stock IsAtBar(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		if(IsPlayerInRangeOfPoint(playerid,3.0,495.7801,-76.0305,998.7578) || IsPlayerInRangeOfPoint(playerid,3.0,499.9654,-20.2515,1000.6797) || IsPlayerInRangeOfPoint(playerid,9.0,1497.5735,-1811.6150,825.3397))
		{//In grove street bar (with girlfriend), and in Havanna
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,4.0,1215.9480,-13.3519,1000.9219) || IsPlayerInRangeOfPoint(playerid,10.0,-2658.9749,1407.4136,906.2734) || IsPlayerInRangeOfPoint(playerid,10.0,2155.3367,-97.3984,3.8308))
		{//PIG Pen
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,10.0,1131.3655,-1641.2759,18.6054) || IsPlayerInRangeOfPoint(playerid,10.0,-2676.4509,1540.6925,900.8359))
		{//Families 8 & SaC
		    return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,5.0,2492.5532,-1698.2817,1715.5508) || IsPlayerInRangeOfPoint(playerid,5.0,2462.8247,-1649.5435,1732.0295) || IsPlayerInRangeOfPoint(playerid,5.0,2498.9863,-1666.6274,1738.3696))
		{
		    //Custom House
		    return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,5.0,878.6188,1431.0234,-82.3449) || IsPlayerInRangeOfPoint(playerid,5.0,918.7236,1421.3997,-81.1839))
		{
		    //VIP
		    return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,10.0,2574.3931,-1682.1548,1030.0206))
		{
			//The Cove
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,10.0,1266.14,-1073.00,1082.92))
		{
			//The Cove
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,10.0,1886.993652, -734.707275, 3380.847656))
		{
			//Syndicate HQ Bar
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,10.0,252.205978, -54.826644, 1.577644))
		{
			//Red County Liquor Store
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,10.0,453.2437,-105.4000,999.5500) || IsPlayerInRangeOfPoint(playerid,10.0,1255.69, -791.76, 1085.38) ||
		IsPlayerInRangeOfPoint(playerid,10.0,2561.94, -1296.44, 1062.04) || IsPlayerInRangeOfPoint(playerid,10.0,1139.72, -3.96, 1000.67) ||
		IsPlayerInRangeOfPoint(playerid,10.0,1139.72, -3.96, 1000.67) || IsPlayerInRangeOfPoint(playerid, 10.0, 880.06, 1430.86, -82.34) ||
		IsPlayerInRangeOfPoint(playerid,10.0,499.96, -20.66, 1000.68) || IsPlayerInRangeOfPoint(playerid,10.0,3282, -635, 8424))
		{
			//Bars
			return 1;
		}
	}
	return 0;
}

stock IsAtArrestPoint(playerid, type)
{
	if(IsPlayerConnected(playerid))
	{
		for(new x; x < MAX_ARRESTPOINTS; x++)
		{
			if(ArrestPoints[x][arrestPosX] != 0)
			{
				if(ArrestPoints[x][arrestType] == type)
				{
					switch(ArrestPoints[x][arrestType])
					{
						case 0:
						{
							if(IsPlayerInRangeOfPoint(playerid, 4.0, ArrestPoints[x][arrestPosX], ArrestPoints[x][arrestPosY], ArrestPoints[x][arrestPosZ]) && GetPlayerInterior(playerid) == ArrestPoints[x][arrestInt] && GetPlayerVirtualWorld(playerid) == ArrestPoints[x][arrestVW]) return 1;
						}
						case 1:
						{
							if(IsPlayerInRangeOfPoint(playerid, 50.0, ArrestPoints[x][arrestPosX], ArrestPoints[x][arrestPosY], ArrestPoints[x][arrestPosZ]) && GetPlayerInterior(playerid) == ArrestPoints[x][arrestInt] && GetPlayerVirtualWorld(playerid) == ArrestPoints[x][arrestVW]) return 1;
						}
						case 2:
						{
							if(IsPlayerInRangeOfPoint(playerid, 10.0, ArrestPoints[x][arrestPosX], ArrestPoints[x][arrestPosY], ArrestPoints[x][arrestPosZ]) && GetPlayerInterior(playerid) == ArrestPoints[x][arrestInt] && GetPlayerVirtualWorld(playerid) == ArrestPoints[x][arrestVW]) return 1;
						}
						case 3:
						{
							if(IsPlayerInRangeOfPoint(playerid, 4.0, ArrestPoints[x][arrestPosX], ArrestPoints[x][arrestPosY], ArrestPoints[x][arrestPosZ]) && GetPlayerInterior(playerid) == ArrestPoints[x][arrestInt] && GetPlayerVirtualWorld(playerid) == ArrestPoints[x][arrestVW]) return 1;
						}
						case 4:
						{
							if(IsPlayerInRangeOfPoint(playerid, 4.0, ArrestPoints[x][arrestPosX], ArrestPoints[x][arrestPosY], ArrestPoints[x][arrestPosZ]) && GetPlayerInterior(playerid) == ArrestPoints[x][arrestInt] && GetPlayerVirtualWorld(playerid) == ArrestPoints[x][arrestVW]) return 1;
						}
					}
				}
			}
		}
	}
	return 0;
}

stock IsAtDeliverPatientPoint(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		if(IsPlayerInRangeOfPoint(playerid, 3.0,1142.4733,-1326.3633,13.6259) || IsPlayerInRangeOfPoint(playerid, 5.0, 1165.1564,-1368.8240,26.6502) || IsPlayerInRangeOfPoint(playerid, 3.0,2027.0599,-1410.6870,16.9922) || IsPlayerInRangeOfPoint(playerid, 5.0, 2024.5742,-1382.7844,48.3359))
		{//ALLSAINTS, ALL SAINTS ROOF, COUNTY GENERAL, COUNTY ROOF
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid, 4.0, 1227.2339,306.4730,19.7028) || IsPlayerInRangeOfPoint(playerid, 5.0, 1233.3384,316.4022,24.7578) || IsPlayerInRangeOfPoint(playerid, 3.0,-339.2989,1055.8138,19.7392) || IsPlayerInRangeOfPoint(playerid, 5.0, -334.1560,1051.4434,26.0125))
		{//RED COUNTY, RED COUNTY ROOF, FORT CARSON, Fortcarson ROOF
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, -2573.300,611.013,14.030) || IsPlayerInRangeOfPoint(playerid, 5.0, -2656.0339,615.2567,66.0938))
		{//SF, SF ROOF
		    return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, -1528.814331, 2540.706054, 55.835937) || IsPlayerInRangeOfPoint(playerid, 5.0, -2482.4338,2231.1106,4.8463) || IsPlayerInRangeOfPoint(playerid, 5.0, 225.3467,1981.8497,17.6406))
		{//El Quebrados , Bayside, Demorgan
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, 1446.7561, -276.9353, 1.1067))
		{// Red County near SASD Boat Patrol HQ
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, 1579.58, 1768.88, 10.82))
		{// Las Venturas Hospital
			return 1;
		}
	}
	return 0;
}

stock IsAtImpoundingPoint(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		for(new x; x < MAX_IMPOUNDPOINTS; x++)
		{
			if(ImpoundPoints[x][impoundPosX] != 0)
			{
				if(IsPlayerInRangeOfPoint(playerid, 4.0, ImpoundPoints[x][impoundPosX], ImpoundPoints[x][impoundPosY], ImpoundPoints[x][impoundPosZ]) && GetPlayerInterior(playerid) == ImpoundPoints[x][impoundInt] && GetPlayerVirtualWorld(playerid) == ImpoundPoints[x][impoundVW]) return 1;
			}
		}
	}
	return 0;
}

stock IsAtPostOffice(playerid)
{
	return IsPlayerInRangeOfPoint(playerid,100.0,-262.0643, 6.0924, 2000.9038);
}

stock IsNearHouseMailbox(playerid)
{
	if (PlayerInfo[playerid][pPhousekey] != INVALID_HOUSE_ID && IsPlayerInRangeOfPoint(playerid,3.0,HouseInfo[PlayerInfo[playerid][pPhousekey]][hMailX], HouseInfo[PlayerInfo[playerid][pPhousekey]][hMailY], HouseInfo[PlayerInfo[playerid][pPhousekey]][hMailZ])) return 1;
	if (PlayerInfo[playerid][pPhousekey2] != INVALID_HOUSE_ID && IsPlayerInRangeOfPoint(playerid,3.0,HouseInfo[PlayerInfo[playerid][pPhousekey2]][hMailX], HouseInfo[PlayerInfo[playerid][pPhousekey2]][hMailY], HouseInfo[PlayerInfo[playerid][pPhousekey2]][hMailZ])) return 1;
	return 0;
}

stock IsNearPublicMailbox(playerid)
{
    for(new i = 0; i < sizeof(MailBoxes); i++) if (IsPlayerInRangeOfPoint(playerid, 3.0, MailBoxes[i][mbPosX], MailBoxes[i][mbPosY], MailBoxes[i][mbPosZ])) return 1;
	return 0;
}

stock InRangeOfWhichHouse(playerid, Float: range)
{
	if (PlayerInfo[playerid][pPhousekey] != INVALID_HOUSE_ID && IsPlayerInRangeOfPoint(playerid,range,HouseInfo[PlayerInfo[playerid][pPhousekey]][hExteriorX], HouseInfo[PlayerInfo[playerid][pPhousekey]][hExteriorY], HouseInfo[PlayerInfo[playerid][pPhousekey]][hExteriorZ]) && GetPlayerInterior(playerid) == HouseInfo[PlayerInfo[playerid][pPhousekey]][hExtIW] && GetPlayerVirtualWorld(playerid) == HouseInfo[PlayerInfo[playerid][pPhousekey]][hExtVW]) return PlayerInfo[playerid][pPhousekey];
	if (PlayerInfo[playerid][pPhousekey2] != INVALID_HOUSE_ID && IsPlayerInRangeOfPoint(playerid,range,HouseInfo[PlayerInfo[playerid][pPhousekey2]][hExteriorX], HouseInfo[PlayerInfo[playerid][pPhousekey2]][hExteriorY], HouseInfo[PlayerInfo[playerid][pPhousekey2]][hExteriorZ]) && GetPlayerInterior(playerid) == HouseInfo[PlayerInfo[playerid][pPhousekey2]][hExtIW] && GetPlayerVirtualWorld(playerid) == HouseInfo[PlayerInfo[playerid][pPhousekey2]][hExtVW]) return PlayerInfo[playerid][pPhousekey2];
	return INVALID_HOUSE_ID;
}

stock IsVIPcar(carid)
{
	for(new i = 0; i < sizeof(VIPVehicles); i++)
	{
		if(carid == VIPVehicles[i]) return 1;
	}
	return 0;
}

stock IsVIPModel(carid)
{
	new Cars[] = { 451, 411, 429, 522, 444, 556, 557 };
	for(new i = 0; i < sizeof(Cars); i++)
	{
		if(GetVehicleModel(carid) == Cars[i]) return 1;
	}
	return 0;
}

stock IsARC(carid)
{
	switch(GetVehicleModel(carid)) {
		case 441, 464, 465, 501, 564: return 1;
	}
	return 0;
}

stock IsABoat(carid) {
	switch(GetVehicleModel(carid)) {
		case 472, 473, 493, 484, 430, 454, 453, 452, 446, 595: return 1;
	}
	return 0;
}

stock IsABike(carid) {
	switch(GetVehicleModel(carid)) {
		case 509, 481, 510, 462, 448, 581, 522, 461, 521, 523, 463, 586, 468, 471: return 1;
	}
	return 0;
}

stock IsATrain(modelid) {
	switch(modelid) {
		case 538, 537, 449, 590, 569, 570: return 1;
	}
	return 0;
}

stock IsASpawnedTrain(carid) {
	switch(GetVehicleModel(carid)) {
		case 538, 537, 449, 590, 569, 570: return 1;
	}
	return 0;
}

stock IsAPlane(carid, type = 0)
{
	if(type == 0)
	{
		switch(GetVehicleModel(carid)) {
			case 592, 577, 511, 512, 593, 520, 553, 476, 519, 460, 513, 548, 425, 417, 487, 488, 497, 563, 447, 469: return 1;
		}
	}
	else
	{
		switch(carid) {
			case 592, 577, 511, 512, 593, 520, 553, 476, 519, 460, 513, 548, 425, 417, 487, 488, 497, 563, 447, 469: return 1;
		}
	}
	return 0;
}

stock IsRestrictedVehicle(modelid)
{
	switch(modelid) {
		case 406, 407, 408, 416, 425, 430, 432, 433, 447, 464, 465, 476, 486, 488, 490, 497, 501, 520, 523, 524, 525, 528, 532, 544, 548, 552, 563, 564, 577, 582, 592, 594, 596, 597, 598, 599, 601, 610, 611: return 1;
	}
	return 0;
}

stock IsWeaponizedVehicle(modelid)
{
	switch(modelid) {
		case 425, 432, 447, 476, 520: return 1;
	}
	return 0;
}

stock IsATruckerCar(carid)
{
	for(new v = 0; v < sizeof(TruckerVehicles); v++) {
	    if(carid == TruckerVehicles[v]) return 1;
	}
	return 0;
}

stock IsATowTruck(carid)
{
	if(GetVehicleModel(carid) == 525) {
		return 1;
	}
	return 0;
}

stock IsAAircraftTowTruck(carid)
{
	if(GetVehicleModel(carid) == 485 || GetVehicleModel(carid) == 583) {
		return 1;
	}
	return 0;
}
stock IsAHelicopter(carid)
{
	if(GetVehicleModel(carid) == 548 || GetVehicleModel(carid) == 425 || GetVehicleModel(carid) == 417 || GetVehicleModel(carid) == 487 || GetVehicleModel(carid) == 488 || GetVehicleModel(carid) == 497 || GetVehicleModel(carid) == 563 || GetVehicleModel(carid) == 447 || GetVehicleModel(carid) == 469 || GetVehicleModel(carid) == 593) {
		return 1;
	}
	return 0;
}


stock IsAnBus(carid)
{
	if(GetVehicleModel(carid) == 431 || GetVehicleModel(carid) == 437) {
		return 1;
	}
	return 0;
}

stock IsAnTaxi(carid)
{
	if(GetVehicleModel(carid) == 420 || GetVehicleModel(carid) == 438) {
		return 1;
	}
	return 0;
}

stock IsFamedVeh(carid)
{
	for(new i = 0; i < sizeof(FamedVehicles); i++)
	{
	    if(carid == FamedVehicles[i]) return 1;
	}
	return 0;
}

stock IsOSModel(carid)
{
	new Cars[] = {461, 559, 579, 426, 468};
	for(new i = 0; i < sizeof(Cars); i++)
	{
	    if(GetVehicleModel(carid) == Cars[i]) return 1;
	}
	return 0;
}

stock IsCOSModel(carid)
{
	new Cars[] = {560, 506, 411};
	for(new i = 0; i < sizeof(Cars); i++)
	{
	    if(GetVehicleModel(carid) == Cars[i]) return 1;
	}
	return 0;
}

stock IsFamedModel(carid)
{
	new Cars[] = {415, 522, 480, 541, 429, 558};
	for(new i = 0; i < sizeof(Cars); i++)
	{
	    if(GetVehicleModel(carid) == Cars[i]) return 1;
	}
	return 0;
}

stock partType(type)
{
	new name[32];
	switch(type)
	{
	    case 0:
		{
			name = "Spoiler";
        }
        case 1:
		{
			name = "Hood";
        }
        case 2:
		{
			name = "Roof";
        }
        case 3:
		{
			name = "Sideskirt";
        }
        case 4:
		{
			name = "Lamps";
        }
        case 5:
		{
			name = "Nitro";
        }
        case 6:
		{
			name = "Exhaust";
        }
        case 7:
		{
			name = "Wheels";
        }
        case 8:
		{
			name = "Stereo";
        }
        case 9:
		{
			name = "Hydraulics";
        }
        case 10:
		{
			name = "Front Bumper";
        }
        case 11:
		{
			name = "Rear Bumper";
        }
        case 12:
		{
			name = "Left Vent";
        }
        case 13:
		{
			name = "Right Vent";
        }
        default:
        {
            name = "Unknown";
		}
	}
	return name;
}

stock partName(part)
{
	new name[32];
	switch(part - 1000)
	{
		case 0:
		{
			name = "Pro";
        }
		case 1:
        {
			name = "Win";
        }
		case 2:
        {
			name = "Drag";
        }
		case 3:
        {
			name = "Alpha";
        }
		case 4:
        {
			name = "Champ Scoop";
        }
		case 5:
        {
			name = "Fury Scoop";
        }
		case 6:
        {
			name = "Roof Scoop";
        }
		case 7:
        {
			name = "Sideskirt";
        }
        case 8:
        {
            name = "2x";
        }
        case 9:
        {
            name = "5x";
        }
        case 10:
        {
            name = "10x";
        }
		case 11:
        {
			name = "Race Scoop";
        }
		case 12:
        {
			name = "Worx Scoop";
        }
		case 13:
        {
			name = "Round Fog";
        }
		case 14:
        {
			name = "Champ";
        }
		case 15:
        {
			name = "Race";
        }
		case 16:
        {
			name = "Worx";
        }
		case 17:
        {
			name = "Sideskirt";
        }
		case 18:
        {
			name = "Upswept";
        }
		case 19:
        {
			name = "Twin";
        }
		case 20:
		{
			name = "Large";
        }
		case 21:
        {
			name = "Medium";
        }
		case 22:
        {
			name = "Small";
        }
		case 23:
        {
			name = "Fury";
        }
		case 24:
        {
			name = "Square Fog";
        }
        case 25:
        {
            name = "Offroad";
        }
		case 26:
        {
			name = "Alien";
        }
		case 27:
        {
			name = "Alien";
        }
		case 28:
        {
			name = "Alien";
        }
		case 29:
        {
			name = "X-Flow";
        }
		case 30:
        {
			name = "X-Flow";
        }
		case 31:
        {
			name = "X-Flow";
        }
		case 32:
        {
			name = "Alien Roof Vent";
        }
		case 33:
        {
			name = "X-Flow Roof Vent";
        }
		case 34:
        {
			name = "Alien";
        }
		case 35:
        {
			name = "X-Flow Roof Vent";
        }
		case 36:
        {
			name = "Alien";
        }
		case 37:
        {
			name = "X-Flow";
        }
		case 38:
        {
			name = "Alien Roof Vent";
        }
		case 39:
        {
			name = "X-Flow";
        }
		case 40:
        {
			name = "Alien";
        }
		case 41:
        {
			name = "X-Flow";
        }
		case 42:
        {
			name = "Chrome";
        }
		case 43:
        {
			name = "Slamin";
        }
		case 44:
        {
			name = "Chrome";
        }
		case 45:
        {
			name = "X-Flow";
        }
		case 46:
        {
			name = "Alien";
        }
		case 47:
        {
			name = "Alien";
        }
		case 48:
        {
			name = "X-Flow";
        }
		case 49:
        {
			name = "Alien";
        }
		case 50:
        {
			name = "X-Flow";
        }
		case 51:
        {
			name = "Alien";
        }
		case 52:
        {
			name = "X-Flow";
        }
		case 53:
        {
			name = "X-Flow";
        }
		case 54:
        {
			name = "Alien";
        }
		case 55:
        {
			name = "Alien";
        }
		case 56:
        {
			name = "Alien";
        }
		case 57:
        {
			name = "X-Flow";
        }
		case 58:
        {
			name = "Alien";
        }
		case 59:
        {
			name = "X-Flow";
        }
		case 60:
        {
			name = "X-Flow";
        }
		case 61:
        {
			name = "X-Flow";
        }
		case 62:
        {
			name = "Alien";
        }
		case 63:
        {
			name = "X-Flow";
        }
		case 64:
        {
			name = "Alien";
        }
		case 65:
        {
			name = "Alien";
        }
		case 66:
        {
			name = "X-Flow";
        }
		case 67:
        {
			name = "Alien";
        }
		case 68:
        {
			name = "X-Flow";
        }
		case 69:
        {
			name = "Alien";
        }
		case 70:
        {
			name = "X-Flow";
        }
		case 71:
        {
			name = "Alien";
        }
		case 72:
        {
			name = "X-Flow";
        }
        case 73:
        {
            name = "Shadow";
        }
        case 74:
        {
            name = "Mega";
        }
        case 75:
        {
            name = "Rimshine";
        }
        case 76:
        {
            name = "Wires";
        }
        case 77:
        {
            name = "Classic";
        }
        case 78:
        {
            name = "Twist";
        }
        case 79:
        {
            name = "Cutter";
        }
        case 80:
        {
            name = "Switch";
        }
        case 81:
        {
            name = "Grove";
        }
        case 82:
        {
            name = "Import";
        }
        case 83:
        {
            name = "Dollar";
        }
        case 84:
        {
            name = "Trance";
        }
        case 85:
        {
            name = "Atomic";
        }
		case 88:
        {
			name = "Alien";
        }
		case 89:
        {
			name = "X-Flow";
        }
		case 90:
        {
			name = "Alien";
        }
		case 91:
        {
			name = "X-Flow";
        }
		case 92:
        {
			name = "Alien";
        }
		case 93:
        {
			name = "X-Flow";
        }
		case 94:
        {
			name = "Alien";
        }
		case 95:
        {
			name = "X-Flow";
        }
        case 96:
        {
            name = "Ahab";
        }
        case 97:
        {
            name = "Virtual";
        }
        case 98:
        {
            name = "Access";
        }
		case 99:
        {
			name = "Chrome";
        }
		case 100:
        {
			name = "Chrome Grill";
        }
 		case 101:
        {
			name = "Chrome Flames";
        }
		case 102:
        {
			name = "Chrome Strip";
        }
		case 103:
        {
			name = "Covertible";
        }
		case 104:
        {
			name = "Chrome";
        }
		case 105:
        {
			name = "Slamin";
        }
		case 106:
        {
			name = "Chrome Arches";
        }
		case 107:
        {
			name = "Chrome Strip";
        }
		case 108:
        {
			name = "Chrome Strip";
        }
		case 109:
        {
			name = "Chrome";
        }
		case 110:
        {
			name = "Slamin";
        }
		case 113:
        {
			name = "Chrome";
        }
		case 114:
        {
			name = "Slamin";
        }
		case 115:
        {
			name = "Chrome";
        }
		case 116:
        {
			name = "Slamin";
        }
		case 117:
        {
			name = "Chrome";
        }
		case 118:
        {
			name = "Chrome Trim";
        }
		case 119:
        {
			name = "Wheelcovers";
        }
		case 120:
        {
			name = "Chrome Trim";
        }
		case 121:
        {
			name = "Wheelcovers";
        }
		case 122:
        {
			name = "Chrome Flames";
        }
		case 123:
        {
			name = "Bullbar Chrome Bars";
        }
		case 124:
        {
			name = "Chrome Arches";
        }
		case 125:
        {
			name = "Bullbar Chrome Lights";
        }
		case 126:
        {
			name = "Chrome";
        }
		case 127:
        {
			name = "Slamin";
        }
		case 128:
        {
			name = "Vinyl Hardtop";
        }
		case 129:
        {
			name = "Chrome";
        }
		case 130:
        {
			name = "Hardtop";
        }
		case 131:
        {
			name = "Softtop";
        }
		case 132:
        {
			name = "Slamin";
        }
		case 133:
        {
			name = "Chrome Strip";
        }
		case 134:
        {
			name = "Chrome Strip";
        }
		case 135:
        {
			name = "Slamin";
        }
		case 136:
        {
			name = "Chrome";
        }
		case 137:
        {
			name = "Chrome Strip";
        }
		case 138:
        {
			name = "Alien";
        }
		case 139:
        {
			name = "X-Flow";
        }
		case 140:
        {
			name = "X-Flow";
        }
		case 141:
        {
			name = "Alien";
        }
		case 142:
        {
			name = "Left Oval Vents";
        }
		case 143:
        {
			name = "Right Oval Vents";
        }
		case 144:
        {
			name = "Left Square Vents";
        }
		case 145:
        {
			name = "Right Square Vents";
        }
		case 146:
        {
			name = "X-Flow";
        }
		case 147:
        {
			name = "Alien";
        }
		case 148:
        {
			name = "X-Flow";
        }
		case 149:
        {
			name = "Alien";
        }
		case 150:
        {
			name = "Alien";
        }
		case 151:
        {
			name = "X-Flow";
        }
		case 152:
        {
			name = "X-Flow";
        }
		case 153:
        {
			name = "Alien";
        }
		case 154:
        {
			name = "Alien";
        }
		case 155:
        {
			name = "Alien";
        }
		case 156:
        {
			name = "X-Flow";
        }
		case 157:
        {
			name = "X-Flow";
        }
		case 158:
        {
			name = "X-Flow";
        }
		case 159:
        {
			name = "Alien";
        }
		case 160:
        {
			name = "Alien";
        }
		case 161:
        {
			name = "X-Flow";
        }
		case 162:
        {
			name = "Alien";
        }
		case 163:
        {
			name = "X-Flow";
        }
		case 164:
        {
			name = "Alien";
        }
		case 165:
        {
			name = "X-Flow";
        }
		case 166:
        {
			name = "Alien";
        }
		case 167:
        {
			name = "X-Flow";
        }
		case 168:
        {
			name = "Alien";
        }
		case 169:
        {
			name = "Alien";
        }
		case 170:
        {
			name = "X-Flow";
        }
		case 171:
        {
			name = "Alien";
        }
		case 172:
        {
			name = "X-Flow";
        }
		case 173:
        {
			name = "X-Flow";
        }
		case 174:
        {
			name = "Chrome";
        }
		case 175:
        {
			name = "Slamin";
        }
		case 176:
        {
			name = "Chrome";
        }
		case 177:
        {
			name = "Slamin";
        }
		case 178:
        {
			name = "Slamin";
        }
		case 179:
        {
			name = "Chrome";
        }
		case 180:
        {
			name = "Chrome";
        }
		case 181:
        {
			name = "Slamin";
        }
		case 182:
        {
			name = "Chrome";
        }
		case 183:
        {
			name = "Slamin";
        }
		case 184:
        {
			name = "Chrome";
        }
		case 185:
        {
			name = "Slamin";
        }
		case 186:
        {
			name = "Slamin";
        }
		case 187:
        {
			name = "Chrome";
        }
		case 188:
        {
			name = "Slamin";
        }
		case 189:
        {
			name = "Chrome";
        }
		case 190:
        {
			name = "Slamin";
        }
		case 191:
        {
			name = "Chrome";
        }
		case 192:
        {
			name = "Chrome";
        }
		case 193:
        {
			name = "Slamin";
        }
   	}
	return name;
}

stock GetXYBehindVehicle(vehicleid, &Float:x, &Float:y, Float:distance)
{
    new
        Float:a;
    GetVehiclePos( vehicleid, x, y, a );
    GetVehicleZAngle( vehicleid, a );
    x += ( distance * floatsin( -a+180, degrees ));
    y += ( distance * floatcos( -a+180, degrees ));
}

stock GetPosBehindVehicle(vehicleid, &Float:x, &Float:y, &Float:z, Float:offset=1.0)
{
	new Float:vehicleSize[3], Float:vehiclePos[3];
	GetVehiclePos(vehicleid, vehiclePos[0], vehiclePos[1], vehiclePos[2]);
	GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_SIZE, vehicleSize[0], vehicleSize[1], vehicleSize[2]);
	GetXYBehindVehicle(vehicleid, vehiclePos[0], vehiclePos[1], (vehicleSize[1]/2)+offset);
	x = vehiclePos[0];
	y = vehiclePos[1];
	z = vehiclePos[2];
	return 1;
}

stock ShowEditMenu(playerid)
{
	new
		iIndex = GetPVarInt(playerid, "ToySlot");

	new toys = 99999;
	for(new i; i < 11; i++)
	{
		printf("Toy%d %d", i, PlayerHoldingObject[playerid][i]);
		if(PlayerHoldingObject[playerid][i] == iIndex+1)
		{
			toys = i;
			if(IsPlayerAttachedObjectSlotUsed(playerid, toys-1))
			{
				PlayerHoldingObject[playerid][i] = 0;
				RemovePlayerAttachedObject(playerid, toys-1);
			}
			break;
		}
	}
	if(PlayerToyInfo[playerid][iIndex][ptScaleX] == 0) {
		PlayerToyInfo[playerid][iIndex][ptScaleX] = 1.0;
		PlayerToyInfo[playerid][iIndex][ptScaleY] = 1.0;
		PlayerToyInfo[playerid][iIndex][ptScaleZ] = 1.0;
	}
	new toycount = GetFreeToySlot(playerid);
	if(toycount > 10 || toycount == -1) return SendClientMessageEx(playerid, COLOR_GRAD1, "Ban da co 10 do choi trong slot, vui long xoa bot..");
	PlayerHoldingObject[playerid][toycount] = iIndex+1;
	SetPlayerAttachedObject(playerid, toycount-1, PlayerToyInfo[playerid][iIndex][ptModelID],
	PlayerToyInfo[playerid][iIndex][ptBone], PlayerToyInfo[playerid][iIndex][ptPosX],
	PlayerToyInfo[playerid][iIndex][ptPosY], PlayerToyInfo[playerid][iIndex][ptPosZ],
	PlayerToyInfo[playerid][iIndex][ptRotX], PlayerToyInfo[playerid][iIndex][ptRotY],
	PlayerToyInfo[playerid][iIndex][ptRotZ], PlayerToyInfo[playerid][iIndex][ptScaleX],
	PlayerToyInfo[playerid][iIndex][ptScaleY], PlayerToyInfo[playerid][iIndex][ptScaleZ]);

    new stringg[128];
    format(stringg, sizeof(stringg), "Vi tri dat (%s)\nSua chi tiet", HoldingBones[PlayerToyInfo[playerid][iIndex][ptBone]]);
 	ShowPlayerDialog(playerid, EDITTOYS2, DIALOG_STYLE_LIST, "Chinh sua do choi", stringg, "Lua chon", "Huy bo");
	return 1;
}

stock DynVeh_Spawn(iDvSlotID)
{
	if(!(0 <= iDvSlotID < MAX_DYNAMIC_VEHICLES)) return 1;
	new string[128];
	format(string, sizeof(string), "Co gang de tao DV Slot ID %d", iDvSlotID);
	Log("logs/dvspawn.log", string);
	new tmpdv = INVALID_VEHICLE_ID;
	if(DynVehicleInfo[iDvSlotID][gv_iSpawnedID] != INVALID_VEHICLE_ID)
	{
		tmpdv = DynVeh[DynVehicleInfo[iDvSlotID][gv_iSpawnedID]];
		DynVeh[DynVehicleInfo[iDvSlotID][gv_iSpawnedID]] = -1;
	}
	if(DynVehicleInfo[iDvSlotID][gv_iSpawnedID] != INVALID_VEHICLE_ID) {
		if(tmpdv == iDvSlotID) {
			format(string, sizeof(string), "Pha huy xe ID %d trong DV Slot %d",DynVehicleInfo[iDvSlotID][gv_iSpawnedID], iDvSlotID);
			Log("logs/dvspawn.log", string);
			DestroyVehicle(DynVehicleInfo[iDvSlotID][gv_iSpawnedID]);
			DynVehicleInfo[iDvSlotID][gv_iSpawnedID] = INVALID_VEHICLE_ID;
			for(new i = 0; i != MAX_DV_OBJECTS; i++)
			{
				if(DynVehicleInfo[iDvSlotID][gv_iAttachedObjectID][i] != INVALID_OBJECT_ID) {
					DestroyDynamicObject(DynVehicleInfo[iDvSlotID][gv_iAttachedObjectID][i]);
					DynVehicleInfo[iDvSlotID][gv_iAttachedObjectID][i] = INVALID_OBJECT_ID;
				}
			}
		}
	}
    if(!(400 < DynVehicleInfo[iDvSlotID][gv_iModel] < 612)) {
		format(string, sizeof(string), "Khong hop le Vehicle Model ID cho DV Slot %d", iDvSlotID);
		Log("logs/dvspawn.log", string);
		return 1;
	}
    if(DynVehicleInfo[iDvSlotID][gv_iDisabled] == 1) {
    	format(string, sizeof(string), "Disable %d", iDvSlotID);
		Log("logs/dvspawn.log", string);
    	return 1;
    } 
    if(DynVehicleInfo[iDvSlotID][gv_igID] != INVALID_GROUP_ID && tmpdv != -1) {
        new iGroupID = DynVehicleInfo[iDvSlotID][gv_igID];
        if(arrGroupData[iGroupID][g_iGroupType] == 1 || arrGroupData[iGroupID][g_iGroupType] == 3 || arrGroupData[iGroupID][g_iGroupType] == 6 || arrGroupData[iGroupID][g_iGroupType] == 7)
        {
            if(arrGroupData[iGroupID][g_iBudget] >= floatround(DynVehicleInfo[iDvSlotID][gv_iUpkeep] / 2))
            {
                arrGroupData[iGroupID][g_iBudget] -= floatround(DynVehicleInfo[iDvSlotID][gv_iUpkeep] / 2);
                new str[128], file[32];
                format(str, sizeof(str), "Vehicle Slot ID %d RTB fee cost $%d to %s's budget fund.", iDvSlotID, floatround(DynVehicleInfo[iDvSlotID][gv_iUpkeep] / 2), arrGroupData[iGroupID][g_szGroupName]);
                new month, day, year;
				getdate(year,month,day);
				format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", iGroupID, month, day, year);
				Log(file, str);
            }
            else
            {
                DynVehicleInfo[iDvSlotID][gv_iDisabled] = 1;
                return 1;
            }
        }
	}
	DynVehicleInfo[iDvSlotID][gv_iSpawnedID] = CreateVehicle(DynVehicleInfo[iDvSlotID][gv_iModel], DynVehicleInfo[iDvSlotID][gv_fX], DynVehicleInfo[iDvSlotID][gv_fY], DynVehicleInfo[iDvSlotID][gv_fZ], DynVehicleInfo[iDvSlotID][gv_fRotZ], DynVehicleInfo[iDvSlotID][gv_iCol1], DynVehicleInfo[iDvSlotID][gv_iCol2], VEHICLE_RESPAWN);
	DynVeh_Save(iDvSlotID);
	format(string, sizeof(string), "Xe ID %d tao ra trong DV Slot %d",DynVehicleInfo[iDvSlotID][gv_iSpawnedID], iDvSlotID);
	Log("logs/dvspawn.log", string);
	SetVehicleHealth(DynVehicleInfo[iDvSlotID][gv_iSpawnedID], DynVehicleInfo[iDvSlotID][gv_fMaxHealth]);
    SetVehicleVirtualWorld(DynVehicleInfo[iDvSlotID][gv_iSpawnedID], DynVehicleInfo[iDvSlotID][gv_iVW]);
    LinkVehicleToInterior(DynVehicleInfo[iDvSlotID][gv_iSpawnedID], DynVehicleInfo[iDvSlotID][gv_iInt]);
    VehicleFuel[DynVehicleInfo[iDvSlotID][gv_iSpawnedID]] = DynVehicleInfo[iDvSlotID][gv_fFuel];
    DynVeh[DynVehicleInfo[iDvSlotID][gv_iSpawnedID]] = iDvSlotID;
	for(new i = 0; i != MAX_DV_OBJECTS; i++)
	{
	    if(DynVehicleInfo[iDvSlotID][gv_iAttachedObjectModel][i] != INVALID_OBJECT_ID && DynVehicleInfo[iDvSlotID][gv_iAttachedObjectModel][i] != 0)
	    {
	        DynVehicleInfo[iDvSlotID][gv_iAttachedObjectID][i] = CreateDynamicObject(DynVehicleInfo[iDvSlotID][gv_iAttachedObjectModel][i],0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
	        AttachDynamicObjectToVehicle(DynVehicleInfo[iDvSlotID][gv_iAttachedObjectID][i], DynVehicleInfo[iDvSlotID][gv_iSpawnedID], DynVehicleInfo[iDvSlotID][gv_fObjectX][i], DynVehicleInfo[iDvSlotID][gv_fObjectY][i], DynVehicleInfo[iDvSlotID][gv_fObjectZ][i], DynVehicleInfo[iDvSlotID][gv_fObjectRX][i], DynVehicleInfo[iDvSlotID][gv_fObjectRY][i], DynVehicleInfo[iDvSlotID][gv_fObjectRZ][i]);

	    }
	}
	if(!isnull(DynVehicleInfo[iDvSlotID][gv_iPlate])) {
		SetVehicleNumberPlate(DynVehicleInfo[iDvSlotID][gv_iSpawnedID], DynVehicleInfo[iDvSlotID][gv_iPlate]);
	}
	Vehicle_ResetData(DynVehicleInfo[iDvSlotID][gv_iSpawnedID]);
	LoadGroupVehicleMods(DynVehicleInfo[iDvSlotID][gv_iSpawnedID]);
    return 1;
}

stock Group_NumToDialogHex(iValue)
{
	new szValue[7];
	format(szValue, sizeof(szValue), "%x", iValue);
	new i, padlength = 6 - strlen(szValue);
	while (i++ != padlength) {
		strins(szValue, "0", 0, 7);
	}
	return szValue;
}

stock GivePlayerStoreItem(playerid, type, business, item, price)
{
	new string[256];
	if(Businesses[business][bInventory] >= StoreItemCost[item][ItemValue]) Businesses[business][bInventory] -= StoreItemCost[item][ItemValue];
	else return SendClientMessageEx(playerid, COLOR_GRAD2, "Cua hang khong co du cho item do");
	switch (item)
  	{
  		case ITEM_CELLPHONE:
		{
			if(CheckInventorySlotEmpty(playerid,2,1) == -1) return SendErrorMessage(playerid,"Tui do cua ban da day khong the mua vat pham.");
			new randphone = 99999 + random(900000);
			new query[128];
			SetPVarInt(playerid, "WantedPh", randphone);
			SetPVarInt(playerid, "CurrentPh", PlayerInfo[playerid][pPnumber]);

			format(query, sizeof(query), "SELECT `Username` FROM `accounts` WHERE `PhoneNr` = '%d'",randphone);
			mysql_function_query(MainPipeline, query, true, "OnPhoneNumberCheck", "ii", playerid, 2);
			Inventory_@Add(playerid, 2, 1);
			SendClientMessageEx(playerid, 0x729a77AA, "[SHOP]: Ban da mua thanh cong dien thoai, hay kiem tra trong tui do cua ban (/my inv).");

		}
  		case ITEM_CIGAR:
		{
			if(CheckInventorySlotEmpty(playerid,4,1) == -1) return SendErrorMessage(playerid,"Tui do cua ban da day khong the mua vat pham.");
			Inventory_@Add(playerid, 4, 1);
			SendClientMessageEx(playerid, 0x729a77AA, "[SHOP]: Ban da mua thanh cong 1 bao thuoc la Jet, hay kiem tra tui do (/my inv).");
		}

  		case ITEM_RADIO:
		{
			PlayerInfo[playerid][pRadio] = 1;
			PlayerInfo[playerid][pRadioFreq] = 0;
			SendClientMessageEx(playerid, COLOR_GRAD4, "Ban da mua radio lien lac.");
			SendClientMessageEx(playerid, COLOR_WHITE, "HUONG DAN: Su dung /pr de lien lac voi nhung nguoi trong cung tan so.");
			SendClientMessageEx(playerid, COLOR_WHITE, "HUONG DAN: Su dung /tanso de thay doi tan so radio.");
			SendClientMessageEx(playerid, COLOR_WHITE, "HUONG DAN: Su dung /xemtanso de xem tan so hien tai.");
		}
		
		case ITEM_GPS:
		{

			if(CheckInventorySlotEmpty(playerid,3,1) == -1) return SendErrorMessage(playerid,"Tui do cua ban da day khong the mua vat pham.");
			Inventory_@Add(playerid, 3, 1);
			SendClientMessageEx(playerid, 0x729a77AA, "[SHOP]: Ban da mua thanh cong 1 GPS, hay kiem tra tui do (/my inv).");
		    if(Question_@TutorialQues[playerid]  == 0) CompletePlayerTutorial(playerid);
		}
		case ITEM_PIZZA:
		{
			if(CheckInventorySlotEmpty(playerid,12,1) == -1) return SendErrorMessage(playerid,"Tui do cua ban da day khong the mua vat pham.");
			Inventory_@Add(playerid, 12, 1);
			SendClientMessageEx(playerid, 0x729a77AA, "[SHOP]: Ban da mua thanh cong 1 banh Pizza, hay kiem tra tui do (/my inv).");
		  
		}
		case ITEM_CAPHESUA:
		{
			if(CheckInventorySlotEmpty(playerid,13,1) == -1) return SendErrorMessage(playerid,"Tui do cua ban da day khong the mua vat pham.");
			Inventory_@Add(playerid, 13, 1);
			SendClientMessageEx(playerid, 0x729a77AA, "[SHOP]: Ban da mua thanh cong 1 banh Ca phe sua, hay kiem tra tui do (/my inv).");
		}
		case ITEM_SPRAYTAG:
		{
			if(CheckInventorySlotEmpty(playerid,19,1) == -1) return SendErrorMessage(playerid,"Tui do cua ban da day khong the mua vat pham.");
			Inventory_@Add(playerid, 19, 1);
			SendClientMessageEx(playerid, 0x729a77AA, "[SHOP]: Ban da mua thanh cong 1 Spraycan, hay kiem tra tui do (/my inv).");
		}
		case ITEM_NUOCNGOT:
		{
			if(CheckInventorySlotEmpty(playerid,34,1) == -1) return SendErrorMessage(playerid,"Tui do cua ban da day khong the mua vat pham.");
			Inventory_@Add(playerid, 34, 1);
			SendClientMessageEx(playerid, 0x729a77AA, "[SHOP]: Ban da mua thanh cong 1 Lon nuoc, hay kiem tra tui do (/my inv).");
		}
		case ITEM_LONBIA:
		{
			if(CheckInventorySlotEmpty(playerid,35,1) == -1) return SendErrorMessage(playerid,"Tui do cua ban da day khong the mua vat pham.");
			Inventory_@Add(playerid, 35, 1);
			SendClientMessageEx(playerid, 0x729a77AA, "[SHOP]: Ban da mua thanh cong 1 Chai bia, hay kiem tra tui do (/my inv).");
		}
		case ITEM_MASK:
		{
			if(CheckInventorySlotEmpty(playerid,37,1) == -1) return SendErrorMessage(playerid,"Tui do cua ban da day khong the mua vat pham.");
			Inventory_@Add(playerid, 37, 1);
			SendClientMessageEx(playerid, 0x729a77AA, "[SHOP]: Ban da mua thanh cong 1 mat na, hay kiem tra tui do (/my inv).");
		}
		default:
		{
		    return 0;
		}
	}
	
	Businesses[business][bTotalSales]++;
	Businesses[business][bSafeBalance] += TaxSale(price);
	GivePlayerMoneyEx(playerid, -price);
	if(PlayerInfo[playerid][pBusiness] != InBusiness(playerid)) Businesses[business][bLevelProgress]++;
	SaveBusiness(business);
	PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	switch(type)
	{
		case 0:
		{
			format(string,sizeof(string),"%s (IP: %s) da mua %s tai %s (%d) voi gia $%s.", GetPlayerNameEx(playerid), GetPlayerIpEx(playerid), StoreItems[item-1], Businesses[business][bName], business, number_format(price));
			Log("logs/business.log", string);
		}
		case 1:
		{
			new offerer = GetPVarInt(playerid, "Business_ItemOfferer");
			format(string, sizeof(string), "%s %s (IP: %s) da ban %s cho %s (IP: %s) voi gia $%s tai %s (%d)", GetBusinessRankName(PlayerInfo[offerer][pBusinessRank]), GetPlayerNameEx(offerer), GetPlayerIpEx(offerer), StoreItems[item], GetPlayerNameEx(playerid), GetPlayerIpEx(playerid), number_format(price), Businesses[business][bName], business);
			Log("logs/business.log", string);
			format(string,sizeof(string),"* %s da mua %s tu ban voi gia $%s.", GetPlayerNameEx(playerid), StoreItems[item], number_format(price));
			SendClientMessage(offerer, COLOR_GRAD2, string);
			DeletePVar(playerid, "Business_ItemType");
			DeletePVar(playerid, "Business_ItemPrice");
			DeletePVar(playerid, "Business_ItemOfferer");
			DeletePVar(playerid, "Business_ItemOffererSQLId");
		}
	}
	return 1;
}

// stock FIXES_valstr(dest[], value, bool:pack = false)
// {
//     // format can't handle cellmin properly
//     static const cellmin_value[] = !"-2147483648";

//     if (value == cellmin)
//         pack && strpack(dest, cellmin_value, 12) || strunpack(dest, cellmin_value, 12);
//     else
//         format(dest, 12, "%d", value) && pack && strpack(dest, dest, 12);
// }

stock GetClosestPlayer(p1)
{
	new Float:dis,Float:dis2,player;
	player = -1;
	dis = 99999.99;
	foreach(new x: Player)
	{
			if(x != p1)
			{
				dis2 = GetDistanceBetweenPlayers(x,p1);
				if(dis2 < dis && dis2 != -1.00)
				{
					dis = dis2;
					player = x;
				}
			}
	}
	return player;
}

stock Float: FormatFloat(Float:number) {
    if(number != number) return 0.0;
    else return number;
}

stock OnPlayerStatsUpdate(playerid)
{
	if(!GetPVarType(playerid, "TempName") && !GetPVarInt(playerid, "EventToken") && GetPVarInt(playerid, "IsInArena") == -1)
	{
	    new Float: Pos[4], Float: Health[2];
		GetPlayerHealth(playerid, Health[0]);
		GetPlayerArmour(playerid, Health[1]);

		PlayerInfo[playerid][pInt] = GetPlayerInterior(playerid);
		PlayerInfo[playerid][pVW] = GetPlayerVirtualWorld(playerid);

		GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
		GetPlayerFacingAngle(playerid, Pos[3]);

		PlayerInfo[playerid][pHealth] = FormatFloat(Health[0]);
		PlayerInfo[playerid][pArmor] = FormatFloat(Health[1]);
	    if(IsPlayerInRangeOfPoint(playerid, 1200, -1083.90002441,4289.70019531,7.59999990) && PlayerInfo[playerid][pMember] == INVALID_GROUP_ID)
		{
			PlayerInfo[playerid][pInt] = 0;
			PlayerInfo[playerid][pVW] = 0;
			GetPlayerFacingAngle(playerid, PlayerInfo[playerid][pPos_r]);
			PlayerInfo[playerid][pPos_x] = 1529.6;
			PlayerInfo[playerid][pPos_y] = -1691.2;
			PlayerInfo[playerid][pPos_z] = 13.3;
		}
	}
	g_mysql_SaveAccount(playerid);
	return 1;
}

stock ConvertToTwelveHour(tHour)
{
	new string[56], suffix[3], cHour;
	if(tHour > 12 && tHour < 24)
	{
		cHour = tHour - 12;
		suffix = "PM";
	}
	else if(tHour == 12)
	{
		cHour = 12;
		suffix = "PM";
	}
	else if(tHour > 0 && tHour < 12)
	{
		cHour = tHour;
		suffix = "AM";
	}
	else if(tHour == 0)
	{
		cHour = 12;
		suffix = "AM";
	}
	format(string, sizeof(string), "%d%s", cHour, suffix);
	return string;
}

forward SyncTime();
public SyncTime()
{
	new string[128], tmphour, tmpminute, tmpsecond;
	gettime(tmphour, tmpminute, tmpsecond);
	FixHour(tmphour);
	tmphour = shifthour;
	if ((tmphour > ghour) || (tmphour == 0 && ghour == 23))
	{
	    SavePlants();
	
		for(new iGroupID; iGroupID < MAX_GROUPS; iGroupID++)
		{
			if(arrGroupData[iGroupID][g_iGroupType] == 5 && arrGroupData[iGroupID][g_iAllegiance] == 1)
			{
				new str[128], file[32];
				format(str, sizeof(str), "The tax vault is at $%s", number_format(Tax));
				new month, day, year;
				getdate(year,month,day);
				format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", iGroupID, month, day, year);
				Log(file, str);
			}
			else if(arrGroupData[iGroupID][g_iGroupType] == 5 && arrGroupData[iGroupID][g_iAllegiance] == 2)
			{
				new str[128], file[32];
				format(str, sizeof(str), "The tax vault is at $%s", number_format(TRTax));
				new month, day, year;
				getdate(year,month,day);
				format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", iGroupID, month, day, year);
				Log(file, str);
			}
			else
			{
				new str[128], file[32];
				format(str, sizeof(str), "The faction vault is at $%s", number_format(arrGroupData[iGroupID][g_iBudget]));
				new month, day, year;
				getdate(year,month,day);
				format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", iGroupID, month, day, year);
				Log(file, str);
			}
			if(arrGroupData[iGroupID][g_iGroupType] == 1 || arrGroupData[iGroupID][g_iGroupType] == 3 || arrGroupData[iGroupID][g_iGroupType] == 6 || arrGroupData[iGroupID][g_iGroupType] == 7)
			{
				if(arrGroupData[iGroupID][g_iBudgetPayment] > 0)
				{
					if(Tax > arrGroupData[iGroupID][g_iBudgetPayment] && arrGroupData[iGroupID][g_iAllegiance] == 1)
					{
						Tax -= arrGroupData[iGroupID][g_iBudgetPayment];
						arrGroupData[iGroupID][g_iBudget] += arrGroupData[iGroupID][g_iBudgetPayment];
						new str[128], file[32];
						format(str, sizeof(str), "SA Gov Paid $%s to %s budget fund.", number_format(arrGroupData[iGroupID][g_iBudgetPayment]), arrGroupData[iGroupID][g_szGroupName]);
						new month, day, year;
						getdate(year,month,day);
						format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", iGroupID, month, day, year);
						Log(file, str);
						Misc_Save();
						SaveGroup(iGroupID);
						for(new z; z < MAX_GROUPS; z++)
						{
							if(arrGroupData[z][g_iAllegiance] == 1)
							{
								if(arrGroupData[z][g_iGroupType] == 5)
								{
									format(str, sizeof(str), "SA Gov Paid $%s to %s budget fund.", number_format(arrGroupData[iGroupID][g_iBudgetPayment]), arrGroupData[iGroupID][g_szGroupName]);
									format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", z, month, day, year);
									Log(file, str);
									break;
								}
							}
						}
					}
					else if(TRTax > arrGroupData[iGroupID][g_iBudgetPayment] && arrGroupData[iGroupID][g_iAllegiance] == 2)
					{
						TRTax -= arrGroupData[iGroupID][g_iBudgetPayment];
						arrGroupData[iGroupID][g_iBudget] += arrGroupData[iGroupID][g_iBudgetPayment];
						new str[128], file[32];
						format(str, sizeof(str), "TR Gov Paid $%s to %s budget fund.", number_format(arrGroupData[iGroupID][g_iBudgetPayment]), arrGroupData[iGroupID][g_szGroupName]);
						new month, day, year;
						getdate(year,month,day);
						format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", iGroupID, month, day, year);
						Log(file, str);
						Misc_Save();
						SaveGroup(iGroupID);
						for(new z; z < MAX_GROUPS; z++)
						{
							if(arrGroupData[z][g_iAllegiance] == 2)
							{
								if(arrGroupData[z][g_iGroupType] == 5)
								{
									format(str, sizeof(str), "TR Gov Paid $%s to %s budget fund.", number_format(arrGroupData[iGroupID][g_iBudgetPayment]), arrGroupData[iGroupID][g_szGroupName]);
									format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", z, month, day, year);
									Log(file, str);
									break;
								}
							}
						}
					}
					else
					{
						format(string, sizeof(string), "Warning: Ngan sach chinh phu khong du tien de tai tro %s.", arrGroupData[iGroupID][g_szGroupName]);
						SendGroupMessage(5, COLOR_RED, string);
					}
				}
				for(new iDvSlotID = 0; iDvSlotID < MAX_DYNAMIC_VEHICLES; iDvSlotID++)
				{
					if(DynVehicleInfo[iDvSlotID][gv_igID] != INVALID_GROUP_ID && DynVehicleInfo[iDvSlotID][gv_igID] == iGroupID)
					{
						if(DynVehicleInfo[iDvSlotID][gv_iModel] != 0 && (400 < DynVehicleInfo[iDvSlotID][gv_iModel] < 612))
						{
							if(arrGroupData[iGroupID][g_iBudget] >= DynVehicleInfo[iDvSlotID][gv_iUpkeep])
							{
								arrGroupData[iGroupID][g_iBudget] -= DynVehicleInfo[iDvSlotID][gv_iUpkeep];
								new str[128], file[32];
								format(str, sizeof(str), "Vehicle ID %d (Slot ID %d) Maintainence fee cost $%s to %s's budget fund.",DynVehicleInfo[iDvSlotID][gv_iSpawnedID], iDvSlotID, number_format(DynVehicleInfo[iDvSlotID][gv_iUpkeep]), arrGroupData[iGroupID][g_szGroupName]);
								new month, day, year;
								getdate(year,month,day);
								format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", iGroupID, month, day, year);
								Log(file, str);
							}
							else
							{
								DynVehicleInfo[iDvSlotID][gv_iDisabled] = 1;
								DynVeh_Save(iDvSlotID);
								DynVeh_Spawn(iDvSlotID);
							}
						}
					}
				}
				SaveGroup(iGroupID);
			}
		}

		WeatherCalling += random(5) + 1;
		#if defined zombiemode
  		if(WeatherCalling > 20)
		{
  			WeatherCalling = 0;
	    	gWeather = random(19) + 1;
		    if(gWeather == 1) gWeather=10;
		    if(zombieevent == 0) SetWeather(gWeather);
		}
		#else
		if(WeatherCalling > 20)
		{
 			WeatherCalling = 0;
   			gWeather = random(19) + 1;
		    if(gWeather == 1) gWeather=10;
		    SetWeather(gWeather);
		}
		#endif

		ghour = tmphour;
		TotalUptime += 1;
		GiftAllowed = 1;

		foreach(new i: Player)
		{
			if(PlayerInfo[i][pAdmin] >= 2 || PlayerInfo[i][pHelper] > 0)
			{
				if(tmphour == 0) {
					ReportCount[i] = 0;
					PlayerInfo[i][pAdvisorCount] = 0;
				}
				ReportHourCount[i] = 0;
			}
		}

	

		if(tmphour == 0) CountCitizens();

		for (new x = 0; x < MAX_POINTS; x++)
		{
			Points[x][Announced] = 0;
			if (Points[x][Vulnerable] > 0)
			{
				Points[x][Vulnerable]--;
				UpdatePoints();
			}
			if (Points[x][Vulnerable] == 0 && Points[x][Type] >= 0 && Points[x][Announced] == 0 && Points[x][ClaimerId] == INVALID_PLAYER_ID)
			{
			//	format(string, sizeof(string), "%s da san sang de chiem dong.", Points[x][Name]);
			//	SendClientMessageToAllEx(COLOR_YELLOW, string);
				//SetPlayerCheckpoint(i, Points[i][Pointx], Points[i][Pointy], Points[i][Pointz], 3);
				ReadyToCapture(x);
				Points[x][Announced] = 1;
			}
		}
		Misc_Save();
		FMemberCounter(); // Family member counter (requested by game affairs to track gang activity)

		for(new i = 1; i < MAX_FAMILY; i++)
		{
		    if(FamilyInfo[i][FamilyTurfTokens] < 24)
		    {
		        FamilyInfo[i][FamilyTurfTokens]++;
		        switch(FamilyInfo[i][FamilyTurfTokens])
		        {
					case 12:
					{
		        		SendNewFamilyMessage(i, COLOR_WHITE, "Family/gang cua ban co 1 Turf Tolen, ban co the /claim de su dung no.");
					}
					case 24:
					{
					    SendNewFamilyMessage(i, COLOR_WHITE, "Family/gang cua ban co 2 Turf Tolen, ban co the /claim de su dung no.");
					}
		        }
		    }
		}
		SaveFamilies();
	}
}

stock splits(const strsrc[], strdest[][], delimiter)
{
	new i, li;
	new aNum;
	new len;
	while(i <= strlen(strsrc)){
		if(strsrc[i]==delimiter || i==strlen(strsrc)){
			len = strmid(strdest[aNum], strsrc, li, i, 128);
			strdest[aNum][len] = 0;
			li = i+1;
			aNum++;
		}
		i++;
	}
	return 1;
}

Float:DistanceCameraTargetToLocation(Float:CamX, Float:CamY, Float:CamZ,  Float:ObjX, Float:ObjY, Float:ObjZ,  Float:FrX, Float:FrY, Float:FrZ)
{

    new Float:TGTDistance;

    // get distance from camera to target
    TGTDistance = floatsqroot((CamX - ObjX) * (CamX - ObjX) + (CamY - ObjY) * (CamY - ObjY) + (CamZ - ObjZ) * (CamZ - ObjZ));

    new Float:tmpX, Float:tmpY, Float:tmpZ;

    tmpX = FrX * TGTDistance + CamX;
    tmpY = FrY * TGTDistance + CamY;
    tmpZ = FrZ * TGTDistance + CamZ;

    return floatsqroot((tmpX - ObjX) * (tmpX - ObjX) + (tmpY - ObjY) * (tmpY - ObjY) + (tmpZ - ObjZ) * (tmpZ - ObjZ));
}

stock IsPlayerAimingAt(playerid, Float:x, Float:y, Float:z, Float:radius)
{
    new Float:cx,Float:cy,Float:cz,Float:fx,Float:fy,Float:fz;
    GetPlayerCameraPos(playerid, cx, cy, cz);
    GetPlayerCameraFrontVector(playerid, fx, fy, fz);
    return (radius >= DistanceCameraTargetToLocation(cx, cy, cz, x, y, z, fx, fy, fz));
}

stock HireCost(carid)
{
	switch (carid)
	{
		case 69:
		{
			return 90000; //bullit
		}
		case 70:
		{
			return 130000; //infurnus
		}
		case 71:
		{
			return 100000; //turismo
		}
		case 72:
		{
			return 80000;
		}
		case 73:
		{
			return 70000;
		}
		case 74:
		{
			return 60000;
		}
	}
	return 0;
}

stock player_remove_vip_toys(iTargetID)
{
	if(PlayerInfo[iTargetID][pDonateRank] >= 3) return 1;
	else for(new iToyIter; iToyIter < MAX_PLAYER_ATTACHED_OBJECTS; ++iToyIter) {
		for(new LoopRapist; LoopRapist < sizeof(HoldingObjectsCop); ++LoopRapist) {
			if(HoldingObjectsCop[LoopRapist][holdingmodelid] == PlayerToyInfo[iTargetID][iToyIter][ptModelID]) {
				PlayerToyInfo[iTargetID][iToyIter][ptModelID] = 0;
				PlayerToyInfo[iTargetID][iToyIter][ptBone] = 0;
				PlayerToyInfo[iTargetID][iToyIter][ptPosX] = 0.0;
				PlayerToyInfo[iTargetID][iToyIter][ptPosY] = 0.0;
				PlayerToyInfo[iTargetID][iToyIter][ptPosZ] = 0.0;
				PlayerToyInfo[iTargetID][iToyIter][ptPosX] = 0.0;
				PlayerToyInfo[iTargetID][iToyIter][ptPosY] = 0.0;
				PlayerToyInfo[iTargetID][iToyIter][ptPosZ] = 0.0;
				if(IsPlayerAttachedObjectSlotUsed(iTargetID, iToyIter)) RemovePlayerAttachedObject(iTargetID, iToyIter);

				g_mysql_SaveToys(iTargetID, iToyIter);
			}
		}
	}
	SendClientMessageEx(iTargetID, COLOR_WHITE, "Tat ca do choi/toys cua chu nhan cu cua ban se bi xoa bo.");
	return 1;
}

stock CreateSpeedCamera(Float:x, Float:y, Float:z, Float:rotation, Float:range, Float:limit)
{
	new loadedCams = 0;
	new index;

	for (new i = 0; i < MAX_SPEEDCAMERAS; i++)
	{
		if (SpeedCameras[i][_scActive])
		{
			loadedCams++;
		}
		else
		{
			index = i;
			break;
		}
	}

	if (loadedCams == MAX_SPEEDCAMERAS)
		return -1;

	SpeedCameras[index][_scActive] = true;
	SpeedCameras[index][_scPosX] = x;
	SpeedCameras[index][_scPosY] = y;
	SpeedCameras[index][_scPosZ] = z;
	SpeedCameras[index][_scRotation] = rotation;
	SpeedCameras[index][_scRange] = range;
	SpeedCameras[index][_scLimit] = limit;
	SpeedCameras[index][_scObjectId] = -1;

	StoreNewSpeedCameraInMySQL(index);
	SpawnSpeedCamera(index);

	return index;
}

stock ShowPlayerCrimeDialog(playerid)
{
	new szCrime[1200];
	format(szCrime, sizeof(szCrime), "----Toi nhe----\n");
	for(new i = 0; i < sizeof(SuspectCrimes); i++)
	{
		if(SuspectCrimeInfo[i][0] == 0)
		{
		    strcat(szCrime, "{FFFF00}");
		    strcat(szCrime, SuspectCrimes[i]);
		    strcat(szCrime, "\n");
		}
	}
	strcat(szCrime, "----Trong toi----\n");
	for(new i = 0; i < sizeof(SuspectCrimes); i++)
	{
		if(SuspectCrimeInfo[i][0] == 1)
		{
		    strcat(szCrime, "{AA3333}");
		    strcat(szCrime, SuspectCrimes[i]);
			strcat(szCrime, "\n");
		}
	}
	strcat(szCrime, "Khac (Not Listed)");
	return ShowPlayerDialog(playerid, DIALOG_SUSPECTMENU, DIALOG_STYLE_LIST, "Chon mot toi pham cam ket", szCrime, "Chon", "Thoat");
}

stock SpawnSpeedCamera(i)
{
	if (SpeedCameras[i][_scActive] && SpeedCameras[i][_scObjectId] == -1)
	{
		SpeedCameras[i][_scObjectId] = CreateDynamicObject(18880, SpeedCameras[i][_scPosX], SpeedCameras[i][_scPosY], SpeedCameras[i][_scPosZ], 0, 0, SpeedCameras[i][_scRotation]);
		new szLimit[50];
		format(szLimit, sizeof(szLimit), "{FFFFFF}Gioi han toc do\n{FF0000}%i {FFFFFF}MPH", floatround(SpeedCameras[i][_scLimit], floatround_round));
		SpeedCameras[i][_scTextID] = CreateDynamic3DTextLabel(szLimit, COLOR_TWWHITE, SpeedCameras[i][_scPosX], SpeedCameras[i][_scPosY], SpeedCameras[i][_scPosZ]+5, 30.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, -1, -1, -1);
	}
}

stock DespawnSpeedCamera(i)
{
	if (SpeedCameras[i][_scActive])
	{
		DestroyDynamicObject(SpeedCameras[i][_scObjectId]);
		DestroyDynamic3DTextLabel(SpeedCameras[i][_scTextID]);
		SpeedCameras[i][_scObjectId] = -1;
	}
}

stock SaveMailboxes()
{
	for(new i = 0; i < MAX_MAILBOXES; i++)
	{
		SaveMailbox(i);
	}
	return 1;
}

stock SaveSpeedCameras()
{
	for (new c = 0; c < MAX_SPEEDCAMERAS; c++)
	{
		SaveSpeedCamera(c);
	}
}

stock UpdatePoints()
{
	for(new i; i < MAX_POINTS; i++)
	{
		SavePoint(i);
	}
}

stock LoadPaintballArenas() {

	if(!fexist("arenas.cfg"))
		return 1;

	new
		szFileStr[1024],
		File: fHandle = fopen("arenas.cfg", io_read),
		iIndex;

	while(iIndex < MAX_ARENAS && fread(fHandle, szFileStr)) {
	    if(!sscanf(szFileStr, "p<|>s[64]iiffffffffffffffffffffffffffffffffffffffffffffffffff",
			PaintBallArena[iIndex][pbArenaName],
			PaintBallArena[iIndex][pbVirtual],
			PaintBallArena[iIndex][pbInterior],
			PaintBallArena[iIndex][pbDeathmatch1][0],
			PaintBallArena[iIndex][pbDeathmatch1][1],
			PaintBallArena[iIndex][pbDeathmatch1][2],
			PaintBallArena[iIndex][pbDeathmatch1][3],
			PaintBallArena[iIndex][pbDeathmatch2][0],
			PaintBallArena[iIndex][pbDeathmatch2][1],
			PaintBallArena[iIndex][pbDeathmatch2][2],
			PaintBallArena[iIndex][pbDeathmatch2][3],
			PaintBallArena[iIndex][pbDeathmatch3][0],
			PaintBallArena[iIndex][pbDeathmatch3][1],
			PaintBallArena[iIndex][pbDeathmatch3][2],
			PaintBallArena[iIndex][pbDeathmatch3][3],
			PaintBallArena[iIndex][pbDeathmatch4][0],
			PaintBallArena[iIndex][pbDeathmatch4][1],
			PaintBallArena[iIndex][pbDeathmatch4][2],
			PaintBallArena[iIndex][pbDeathmatch4][3],
			PaintBallArena[iIndex][pbTeamRed1][0],
			PaintBallArena[iIndex][pbTeamRed1][1],
			PaintBallArena[iIndex][pbTeamRed1][2],
			PaintBallArena[iIndex][pbTeamRed1][3],
			PaintBallArena[iIndex][pbTeamRed2][0],
			PaintBallArena[iIndex][pbTeamRed2][1],
			PaintBallArena[iIndex][pbTeamRed2][2],
			PaintBallArena[iIndex][pbTeamRed2][3],
			PaintBallArena[iIndex][pbTeamRed3][0],
			PaintBallArena[iIndex][pbTeamRed3][1],
			PaintBallArena[iIndex][pbTeamRed3][2],
			PaintBallArena[iIndex][pbTeamRed3][3],
			PaintBallArena[iIndex][pbTeamBlue1][0],
			PaintBallArena[iIndex][pbTeamBlue1][1],
			PaintBallArena[iIndex][pbTeamBlue1][2],
			PaintBallArena[iIndex][pbTeamBlue1][3],
			PaintBallArena[iIndex][pbTeamBlue2][0],
			PaintBallArena[iIndex][pbTeamBlue2][1],
			PaintBallArena[iIndex][pbTeamBlue2][2],
			PaintBallArena[iIndex][pbTeamBlue2][3],
			PaintBallArena[iIndex][pbTeamBlue3][0],
			PaintBallArena[iIndex][pbTeamBlue3][1],
			PaintBallArena[iIndex][pbTeamBlue3][2],
			PaintBallArena[iIndex][pbTeamBlue3][3],
			PaintBallArena[iIndex][pbFlagRedSpawn][0],
			PaintBallArena[iIndex][pbFlagRedSpawn][1],
			PaintBallArena[iIndex][pbFlagRedSpawn][2],
			PaintBallArena[iIndex][pbFlagBlueSpawn][0],
			PaintBallArena[iIndex][pbFlagBlueSpawn][1],
			PaintBallArena[iIndex][pbFlagBlueSpawn][2],
			PaintBallArena[iIndex][pbHillX],
			PaintBallArena[iIndex][pbHillY],
			PaintBallArena[iIndex][pbHillZ],
			PaintBallArena[iIndex][pbHillRadius]
		)) ++iIndex;
	}
	printf("[LoadPaintballArenas] %i paintball loaded.", iIndex);
	return fclose(fHandle);
}

stock SavePaintballArenas() {

	new
		szFileStr[2048],
		File: fHandle = fopen("arenas.cfg", io_write);

	if(fHandle)
	{
		for(new iIndex; iIndex < MAX_ARENAS; ++iIndex) {
		    format(szFileStr, sizeof(szFileStr), "%s|%d|%d|%f|%f|%f|%f|%f|%f|%f|%f|%f|%f|%f|%f|%f|%f|%f|%f|%f|%f|%f|%f|%f|%f|%f|%f|%f|%f|%f|%f|%f|%f|%f|%f|%f|%f|%f|%f|%f|%f|%f|%f|%f|%f|%f|%f|%f|%f|%f|%f|%f|%f\r\n",
				PaintBallArena[iIndex][pbArenaName],
				PaintBallArena[iIndex][pbVirtual],
				PaintBallArena[iIndex][pbInterior],
				PaintBallArena[iIndex][pbDeathmatch1][0],
				PaintBallArena[iIndex][pbDeathmatch1][1],
				PaintBallArena[iIndex][pbDeathmatch1][2],
				PaintBallArena[iIndex][pbDeathmatch1][3],
				PaintBallArena[iIndex][pbDeathmatch2][0],
				PaintBallArena[iIndex][pbDeathmatch2][1],
				PaintBallArena[iIndex][pbDeathmatch2][2],
				PaintBallArena[iIndex][pbDeathmatch2][3],
				PaintBallArena[iIndex][pbDeathmatch3][0],
				PaintBallArena[iIndex][pbDeathmatch3][1],
				PaintBallArena[iIndex][pbDeathmatch3][2],
				PaintBallArena[iIndex][pbDeathmatch3][3],
				PaintBallArena[iIndex][pbDeathmatch4][0],
				PaintBallArena[iIndex][pbDeathmatch4][1],
				PaintBallArena[iIndex][pbDeathmatch4][2],
				PaintBallArena[iIndex][pbDeathmatch4][3],
				PaintBallArena[iIndex][pbTeamRed1][0],
				PaintBallArena[iIndex][pbTeamRed1][1],
				PaintBallArena[iIndex][pbTeamRed1][2],
				PaintBallArena[iIndex][pbTeamRed1][3],
				PaintBallArena[iIndex][pbTeamRed2][0],
				PaintBallArena[iIndex][pbTeamRed2][1],
				PaintBallArena[iIndex][pbTeamRed2][2],
				PaintBallArena[iIndex][pbTeamRed2][3],
				PaintBallArena[iIndex][pbTeamRed3][0],
				PaintBallArena[iIndex][pbTeamRed3][1],
				PaintBallArena[iIndex][pbTeamRed3][2],
				PaintBallArena[iIndex][pbTeamRed3][3],
				PaintBallArena[iIndex][pbTeamBlue1][0],
				PaintBallArena[iIndex][pbTeamBlue1][1],
				PaintBallArena[iIndex][pbTeamBlue1][2],
				PaintBallArena[iIndex][pbTeamBlue1][3],
				PaintBallArena[iIndex][pbTeamBlue2][0],
				PaintBallArena[iIndex][pbTeamBlue2][1],
				PaintBallArena[iIndex][pbTeamBlue2][2],
				PaintBallArena[iIndex][pbTeamBlue2][3],
				PaintBallArena[iIndex][pbTeamBlue3][0],
				PaintBallArena[iIndex][pbTeamBlue3][1],
				PaintBallArena[iIndex][pbTeamBlue3][2],
				PaintBallArena[iIndex][pbTeamBlue3][3],
				PaintBallArena[iIndex][pbFlagRedSpawn][0],
				PaintBallArena[iIndex][pbFlagRedSpawn][1],
				PaintBallArena[iIndex][pbFlagRedSpawn][2],
				PaintBallArena[iIndex][pbFlagBlueSpawn][0],
				PaintBallArena[iIndex][pbFlagBlueSpawn][1],
				PaintBallArena[iIndex][pbFlagBlueSpawn][2],
				PaintBallArena[iIndex][pbHillX],
				PaintBallArena[iIndex][pbHillY],
				PaintBallArena[iIndex][pbHillZ],
				PaintBallArena[iIndex][pbHillRadius]
			);
			fwrite(fHandle, szFileStr);
		}
		return fclose(fHandle);
	}
	return 0;
}

stock ReloadHouseText(houseid)
{
	new string[128];
	if(HouseInfo[houseid][hOwned])
	{
		if(HouseInfo[houseid][hRentable]) format(string, sizeof(string), "House (%d)\nChu so huu%s", houseid,StripUnderscore(HouseInfo[houseid][hOwnerName]));
		else format(string, sizeof(string), "House (%d)\nChu so huu%s", houseid,StripUnderscore(HouseInfo[houseid][hOwnerName]));
	}
	else format(string, sizeof(string), "House (%d) dang duoc ban voi gia: %s\nChua co chu so huu, su dung /muanha de giao dich", houseid, number_format(HouseInfo[houseid][hValue]) );
	UpdateDynamic3DTextLabelText(HouseInfo[houseid][hTextID], COLOR_GREEN, string);
}

stock ReloadHousePickup(houseid)
{
	if(HouseInfo[houseid][hExteriorX] != 0.0 && HouseInfo[houseid][hExteriorY] != 0.0) {
	    new string[128], szTrasStr[128];
	    if(IsValidDynamicPickup(HouseInfo[houseid][hPickupID])) DestroyDynamicPickup(HouseInfo[houseid][hPickupID]);
	    if(IsValidDynamic3DTextLabel(HouseInfo[houseid][hTextID])) DestroyDynamic3DTextLabel(HouseInfo[houseid][hTextID]);
	    if(HouseInfo[houseid][hOwned])
	    {
//	        format(szTrasStr, sizeof(szTrasStr), "Trash can %d\nChu so huu: %s",houseid,StripUnderscore(HouseInfo[houseid][hOwnerName]));
   	    //	HouseInfo[houseid][hTrasText] = CreateDynamic3DTextLabel( szTrasStr, COLOR_THUNGRAC, HouseInfo[houseid][hTrasX], HouseInfo[houseid][hTrasY], HouseInfo[houseid][hTrasZ]+0.3,10.0, .testlos = 1, .streamdistance = 10.0);
	    //	HouseInfo[houseid][hTrasObjectId] = CreateDynamicObject(1339, HouseInfo[houseid][hTrasX], HouseInfo[houseid][hTrasY], HouseInfo[houseid][hTrasZ]-0.4, 0.00000, 0.00000, HouseInfo[houseid][hTrasA]);
	    	if(HouseInfo[houseid][hRentable])
	    	{
	    		format(string, sizeof(string), "House %d\nChu so huu: %s", houseid,StripUnderscore(HouseInfo[houseid][hOwnerName]));
	    		HouseInfo[houseid][hTextID] = CreateDynamic3DTextLabel(string, COLOR_LIGHTGREEN, HouseInfo[houseid][hExteriorX], HouseInfo[houseid][hExteriorY], HouseInfo[houseid][hExteriorZ]+0.5,10.0, .testlos = 1, .worldid = HouseInfo[houseid][hExtVW], .interiorid = HouseInfo[houseid][hExtIW], .streamdistance = 10.0);
	    		HouseInfo[houseid][hPickupID] = CreateDynamicPickup(1273, 23, HouseInfo[houseid][hExteriorX], HouseInfo[houseid][hExteriorY], HouseInfo[houseid][hExteriorZ], .worldid = HouseInfo[houseid][hExtVW], .interiorid = HouseInfo[houseid][hExtIW]);
	    	}
	    	else
	    	{
	    		format(string, sizeof(string), "House %d\nChu so huu: %s", houseid,StripUnderscore(HouseInfo[houseid][hOwnerName]) );
	    		HouseInfo[houseid][hTextID] = CreateDynamic3DTextLabel(string, COLOR_GREEN, HouseInfo[houseid][hExteriorX], HouseInfo[houseid][hExteriorY], HouseInfo[houseid][hExteriorZ]+0.5,10.0, .testlos = 1, .worldid = HouseInfo[houseid][hExtVW], .interiorid = HouseInfo[houseid][hExtIW], .streamdistance = 10.0);
	    		HouseInfo[houseid][hPickupID] = CreateDynamicPickup(1273, 23, HouseInfo[houseid][hExteriorX], HouseInfo[houseid][hExteriorY], HouseInfo[houseid][hExteriorZ], .worldid = HouseInfo[houseid][hExtVW], .interiorid = HouseInfo[houseid][hExtIW]);
	    	}
	    }
	    else
	    {
//	        format(szTrasStr, sizeof(szTrasStr), "Trash can: %d",houseid);
	    //    HouseInfo[houseid][hTrasText] = CreateDynamic3DTextLabel( szTrasStr, COLOR_THUNGRAC, HouseInfo[houseid][hTrasX], HouseInfo[houseid][hTrasY], HouseInfo[houseid][hTrasZ]+0.3,10.0, .testlos = 1, .streamdistance = 10.0);
	    //	HouseInfo[houseid][hTrasObjectId] = CreateDynamicObject(1339, HouseInfo[houseid][hTrasX], HouseInfo[houseid][hTrasY], HouseInfo[houseid][hTrasZ]-0.4, 0.00000, 0.00000, HouseInfo[houseid][hTrasA]);
	    	format(string, sizeof(string), "House (%d) dang duoc ban voi gia: %s\nChua co chu so huu, su dung /muanha de giao dich", houseid,number_format(HouseInfo[houseid][hValue]));
	    	HouseInfo[houseid][hTextID] = CreateDynamic3DTextLabel(string, COLOR_GREEN, HouseInfo[houseid][hExteriorX], HouseInfo[houseid][hExteriorY], HouseInfo[houseid][hExteriorZ]+0.5,10.0, .testlos = 1, .worldid = HouseInfo[houseid][hExtVW], .interiorid = HouseInfo[houseid][hExtIW], .streamdistance = 10.0);
	    	HouseInfo[houseid][hPickupID] = CreateDynamicPickup(1273, 23, HouseInfo[houseid][hExteriorX], HouseInfo[houseid][hExteriorY], HouseInfo[houseid][hExteriorZ], .worldid = HouseInfo[houseid][hExtVW], .interiorid = HouseInfo[houseid][hExtIW]);
	    }
	}
}
SaveSafeZones()
{
	new
		szFileStr[1024],
		File: fHandle = fopen("SafeZones.cfg", io_write);

	for(new iIndex; iIndex < MAX_SZ; iIndex++) {
  	 		format(szFileStr, sizeof(szFileStr), "%f|%f|%f|%d|%d\r\n",
			SafeZoneInfo[iIndex][szExteriorX],
			SafeZoneInfo[iIndex][szExteriorY],
			SafeZoneInfo[iIndex][szExteriorZ],
			SafeZoneInfo[iIndex][szKhoangcach],
			SafeZoneInfo[iIndex][szPickupID]
		    );
		    fwrite(fHandle, szFileStr);
	}
	return fclose(fHandle);
}

LoadSafeZones()
{
    if(!fexist("SafeZones.cfg")) return 1;

	new szFileStr[128],
		File: iFileHandle = fopen("SafeZones.cfg", io_read),
		iIndex;

	while(iIndex < sizeof(SafeZoneInfo) && fread(iFileHandle, szFileStr)) {
		sscanf(szFileStr, "p<|>fffii",
			SafeZoneInfo[iIndex][szExteriorX],
			SafeZoneInfo[iIndex][szExteriorY],
			SafeZoneInfo[iIndex][szExteriorZ],
			SafeZoneInfo[iIndex][szKhoangcach],
			SafeZoneInfo[iIndex][szPickupID]
		);

		
        if(SafeZoneInfo[iIndex][szExteriorX] != 0.0)
		{
			SafeZoneInfo[iIndex][szArea] = CreateDynamicSphere(SafeZoneInfo[iIndex][szExteriorX],SafeZoneInfo[iIndex][szExteriorY],SafeZoneInfo[iIndex][szExteriorZ],SafeZoneInfo[iIndex][szKhoangcach]);
			SafeZoneInfo[iIndex][szPickupID] = CreateDynamicPickup(1314, 23, SafeZoneInfo[iIndex][szExteriorX], SafeZoneInfo[iIndex][szExteriorY], SafeZoneInfo[iIndex][szExteriorZ]);
				}
		++iIndex;
	}
	return fclose(iFileHandle);
}
stock SaveHouses()
{
	for(new i = 0; i < MAX_HOUSES; i++)
	{
		SaveHouse(i);
	}
	return 1;
}

stock RehashHouse(houseid)
{
	DestroyDynamicPickup(HouseInfo[houseid][hPickupID]);
	if(IsValidDynamic3DTextLabel(HouseInfo[houseid][hTextID])) DestroyDynamic3DTextLabel(HouseInfo[houseid][hTextID]);
	HouseInfo[houseid][hSQLId] = -1;
	HouseInfo[houseid][hOwned] = 0;
	HouseInfo[houseid][hLevel] = 0;
	HouseInfo[houseid][hExteriorX] = 0.0;
	HouseInfo[houseid][hExteriorY] = 0.0;
	HouseInfo[houseid][hExteriorZ] = 0.0;
	HouseInfo[houseid][hExteriorR] = 0.0;
	HouseInfo[houseid][hInteriorX] = 0.0;
	HouseInfo[houseid][hInteriorY] = 0.0;
	HouseInfo[houseid][hInteriorZ] = 0.0;
	HouseInfo[houseid][hInteriorR] = 0.0;
	HouseInfo[houseid][hExtIW] = 0;
	HouseInfo[houseid][hExtVW] = 0;
	HouseInfo[houseid][hIntIW] = 0;
	HouseInfo[houseid][hIntVW] = 0;
	HouseInfo[houseid][hLock] = 0;
	HouseInfo[houseid][hRentable] = 0;
	HouseInfo[houseid][hRentFee] = 0;
	HouseInfo[houseid][hValue] = 0;
	HouseInfo[houseid][hSafeMoney] = 0;
	HouseInfo[houseid][hPot] = 0;
	HouseInfo[houseid][hCrack] = 0;
	HouseInfo[houseid][hMaterials] = 0;
	HouseInfo[houseid][hWeapons][0] = 0;
	HouseInfo[houseid][hWeapons][1] = 0;
	HouseInfo[houseid][hWeapons][2] = 0;
	HouseInfo[houseid][hWeapons][3] = 0;
	HouseInfo[houseid][hWeapons][4] = 0;
	HouseInfo[houseid][hGLUpgrade] = 1;
	HouseInfo[houseid][hCustomInterior] = 0;
	HouseInfo[houseid][hCustomExterior] = 0;
	HouseInfo[houseid][hExteriorA] = 0;
	HouseInfo[houseid][hInteriorA] = 0;
	HouseInfo[houseid][hMailX] = 0.0;
	HouseInfo[houseid][hMailY] = 0.0;
	HouseInfo[houseid][hMailZ] = 0.0;
	HouseInfo[houseid][hMailA] = 0.0;
	if(IsValidDynamic3DTextLabel(HouseInfo[houseid][hClosetTextID])) DestroyDynamic3DTextLabel(Text3D:HouseInfo[houseid][hClosetTextID]);
	HouseInfo[houseid][hClosetX] = 0.0;
	HouseInfo[houseid][hClosetY] = 0.0;
	HouseInfo[houseid][hClosetZ] = 0.0;
	LoadHouse(houseid);
}

stock RehashHouses()
{
	printf("[RehashHouses] Deleting houses from server...");
	for(new i = 0; i < MAX_HOUSES; i++)
	{
		RehashHouse(i);
	}
	LoadHouses();
}
stock SaveDynamicDoors()
{
	for(new i = 0; i < MAX_DDOORS; i++)
	{
		SaveDynamicDoor(i);
	}
	return 1;
}

stock RehashDynamicDoor(doorid)
{
	DestroyDynamicPickup(DDoorsInfo[doorid][ddPickupID]);
	if(IsValidDynamic3DTextLabel(DDoorsInfo[doorid][ddTextID])) DestroyDynamic3DTextLabel(DDoorsInfo[doorid][ddTextID]);
	DDoorsInfo[doorid][ddSQLId] = -1;
	DDoorsInfo[doorid][ddOwner] = -1;
	DDoorsInfo[doorid][ddCustomInterior] = 0;
	DDoorsInfo[doorid][ddExteriorVW] = 0;
	DDoorsInfo[doorid][ddExteriorInt] = 0;
	DDoorsInfo[doorid][ddInteriorVW] = 0;
	DDoorsInfo[doorid][ddInteriorInt] = 0;
	DDoorsInfo[doorid][ddExteriorX] = 0.0;
	DDoorsInfo[doorid][ddExteriorY] = 0.0;
	DDoorsInfo[doorid][ddExteriorZ] = 0.0;
	DDoorsInfo[doorid][ddExteriorA] = 0.0;
	DDoorsInfo[doorid][ddInteriorX] = 0.0;
	DDoorsInfo[doorid][ddInteriorY] = 0.0;
	DDoorsInfo[doorid][ddInteriorZ] = 0.0;
	DDoorsInfo[doorid][ddInteriorA] = 0.0;
	DDoorsInfo[doorid][ddCustomExterior] = 0;
	DDoorsInfo[doorid][ddType] = 0;
	DDoorsInfo[doorid][ddRank] = 0;
	DDoorsInfo[doorid][ddVIP] = 0;
	DDoorsInfo[doorid][ddAllegiance] = 0;
	DDoorsInfo[doorid][ddGroupType] = 0;
	DDoorsInfo[doorid][ddFamily] = 0;
	DDoorsInfo[doorid][ddFaction] = 0;
	DDoorsInfo[doorid][ddAdmin] = 0;
	DDoorsInfo[doorid][ddWanted] = 0;
	DDoorsInfo[doorid][ddVehicleAble] = 0;
	DDoorsInfo[doorid][ddColor] = 0;
	DDoorsInfo[doorid][ddPickupModel] = 0;
	DDoorsInfo[doorid][ddLocked] = 0;
	LoadDynamicDoor(doorid);
}

stock RehashDynamicDoors()
{
	printf("[RehashDynamicDoors] Deleting dynamic doors from server...");
	for(new i = 0; i < MAX_DDOORS; i++)
	{
		RehashDynamicDoor(i);
	}
	LoadDynamicDoors();
}

stock CreateDynamicDoor(doorid)
{
	if(DDoorsInfo[doorid][ddExteriorX] != 0.0 && DDoorsInfo[doorid][ddExteriorY] != 0.0) {
	    switch(DDoorsInfo[doorid][ddPickupModel])
	    {
	        case -1: { /* Disable Pickup */ }
	    	case 1:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1210, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
	    	case 2:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1212, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
	    	case 3:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1239, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
	    	case 4:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1240, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
	    	case 5:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1241, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
	    	case 6:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1242, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
	    	case 7:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1247, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
	    	case 8:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1248, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
	    	case 9:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1252, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
	    	case 10:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1253, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
	    	case 11:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1254, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
	    	case 12:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1313, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
	    	case 13:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1272, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
	    	case 14:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1273, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
	    	case 15:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1274, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
	    	case 16:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1275, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
	    	case 17:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1276, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
	    	case 18:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1277, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
	    	case 19:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1279, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
	    	case 20:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1314, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
	    	case 21:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1316, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
	    	case 22:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1317, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
	    	case 23:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1559, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
	    	case 24:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1582, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
	    	case 25:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(2894, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
	        default:
	        {
	    		DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1318, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);
	        }
	    }
	}

}

stock LoadEventPoints() {

	if(!fexist("eventpoints.cfg"))
		return 1;

	new
		szFileStr[256],
		File: fHandle = fopen("eventpoints.cfg", io_read),
		iIndex;

	while(iIndex < MAX_EVENTPOINTS && fread(fHandle, szFileStr)) {
		if(!sscanf(szFileStr, "p<|>fffiis[64]i",
			EventPoints[iIndex][epPosX],
			EventPoints[iIndex][epPosY],
			EventPoints[iIndex][epPosZ],
			EventPoints[iIndex][epVW],
			EventPoints[iIndex][epInt],
			EventPoints[iIndex][epPrize],
			EventPoints[iIndex][epFlagable]
		) && EventPoints[iIndex][epPosX] != 0.0) {
			EventPoints[iIndex][epObjectID] = CreateDynamicPickup(1274, 1, EventPoints[iIndex][epPosX], EventPoints[iIndex][epPosY], EventPoints[iIndex][epPosZ], EventPoints[iIndex][epVW]);
			format(szFileStr,sizeof(szFileStr),"Diem Event (ID: %d)\nPrize: %s\nSu dung /claimpoint de yeu cau giai thuong!", iIndex, EventPoints[iIndex][epPrize]);
			EventPoints[iIndex][epText3dID] = CreateDynamic3DTextLabel(szFileStr, COLOR_YELLOW, EventPoints[iIndex][epPosX], EventPoints[iIndex][epPosY], EventPoints[iIndex][epPosZ]+0.5, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, EventPoints[iIndex][epVW], EventPoints[iIndex][epInt]);
			++iIndex;
		}
	}
	printf("[LoadEventPoints] %i event points loaded.", iIndex);
	return fclose(fHandle);
}

stock SaveDynamicMapIcons()
{
	for(new i = 1; i < MAX_DMAPICONS; i++)
	{
		SaveDynamicMapIcon(i);
	}
	return 1;
}

stock RehashDynamicMapIcon(mapiconid)
{
	if(IsValidDynamicMapIcon(DMPInfo[mapiconid][dmpMapIconID])) DestroyDynamicMapIcon(DMPInfo[mapiconid][dmpMapIconID]);
	DMPInfo[mapiconid][dmpMarkerType] = 0;
	DMPInfo[mapiconid][dmpColor] = 0;
	DMPInfo[mapiconid][dmpVW] = 0;
	DMPInfo[mapiconid][dmpInt] = 0;
	DMPInfo[mapiconid][dmpPosX] = 0.0;
	DMPInfo[mapiconid][dmpPosY] = 0.0;
	DMPInfo[mapiconid][dmpPosZ] = 0.0;
	LoadDynamicMapIcon(mapiconid);
}

stock RehashDynamicMapIcons()
{
	printf("[RehashDynamicMapIcons] Deleting map icons from server...");
	for(new i = 1; i < MAX_DMAPICONS; i++)
	{
		RehashDynamicMapIcon(i);
	}
	LoadDynamicMapIcons();
}

stock InitEventPoints()
{
	for(new i = 0; i < MAX_EVENTPOINTS; i++)
	{
	    EventPoints[i][epObjectID] = 0;
	}
	return 1;
}

stock InitPaintballArenas()
{
    new string[64];
	for(new i = 0; i < MAX_ARENAS; i++)
	{
	    format(string, sizeof(string), "Unoccupied");
		strmid(PaintBallArena[i][pbOwner], string, 0, strlen(string), 64);

		format(string, sizeof(string), "None");
		strmid(PaintBallArena[i][pbPassword], string, 0, strlen(string), 64);

	    PaintBallArena[i][pbGameType] = 1;
  		PaintBallArena[i][pbActive] = 0;
  		PaintBallArena[i][pbExploitPerm] = 0;
  		PaintBallArena[i][pbFlagInstagib] = 0;
  		PaintBallArena[i][pbFlagNoWeapons] = 0;
  		PaintBallArena[i][pbTimeLeft] = 900;
  		PaintBallArena[i][pbHealth] = 100;
   		PaintBallArena[i][pbArmor] = 99;
   		PaintBallArena[i][pbLocked] = 0;
		PaintBallArena[i][pbLimit] = 16;
		PaintBallArena[i][pbPlayers] = 0;
		PaintBallArena[i][pbTeamRed] = 0;
		PaintBallArena[i][pbTeamBlue] = 0;
		PaintBallArena[i][pbBidMoney] = 50;
		PaintBallArena[i][pbMoneyPool] = 0;
		PaintBallArena[i][pbWeapons][0] = 29;
		PaintBallArena[i][pbWeapons][1] = 24;
		PaintBallArena[i][pbWeapons][2] = 27;
		PaintBallArena[i][pbHillX] = 0.0;
		PaintBallArena[i][pbHillY] = 0.0;
		PaintBallArena[i][pbHillZ] = 0.0;
		PaintBallArena[i][pbHillRadius] = 0.0;
	}
	return 1;
}

stock ResetPaintballArena(arenaid)
{
	new string[64];

	format(string, sizeof(string), "Unoccupied");
	strmid(PaintBallArena[arenaid][pbOwner], string, 0, strlen(string), 64);
	format(string, sizeof(string), "None");
	strmid(PaintBallArena[arenaid][pbPassword], string, 0, strlen(string), 64);

	if(PaintBallArena[arenaid][pbGameType] == 3) {
	    if(PaintBallArena[arenaid][pbFlagRedActive] == 1) {
	        Delete3DTextLabel(PaintBallArena[arenaid][pbFlagRedTextID]);
		}
		if(PaintBallArena[arenaid][pbFlagBlueActive] == 1) {
		    Delete3DTextLabel(PaintBallArena[arenaid][pbFlagBlueTextID]);
		}
	    Delete3DTextLabel(PaintBallArena[arenaid][pbTeamRedTextID]);
		Delete3DTextLabel(PaintBallArena[arenaid][pbTeamBlueTextID]);
		DestroyDynamicObject(PaintBallArena[arenaid][pbFlagRedID]);
		DestroyDynamicObject(PaintBallArena[arenaid][pbFlagBlueID]);
	}

	if(PaintBallArena[arenaid][pbGameType] == 4 || PaintBallArena[arenaid][pbGameType] == 5) {
	    ResetPaintballArenaHill(arenaid);
	}

  	PaintBallArena[arenaid][pbGameType] = 1;
  	PaintBallArena[arenaid][pbActive] = 0;
  	PaintBallArena[arenaid][pbExploitPerm] = 0;
  	PaintBallArena[arenaid][pbFlagInstagib] = 0;
	PaintBallArena[arenaid][pbFlagNoWeapons] = 0;
  	PaintBallArena[arenaid][pbTimeLeft] = 900;
  	//PaintBallArena[arenaid][pbHealth] = 100;
   	PaintBallArena[arenaid][pbLocked] = 0;
	PaintBallArena[arenaid][pbLimit] = 16;
	PaintBallArena[arenaid][pbPlayers] = 0;
	PaintBallArena[arenaid][pbTeamRed] = 0;
	PaintBallArena[arenaid][pbTeamBlue] = 0;
	PaintBallArena[arenaid][pbBidMoney] = 50;
	PaintBallArena[arenaid][pbMoneyPool] = 0;
	PaintBallArena[arenaid][pbWeapons][0] = 29;
	PaintBallArena[arenaid][pbWeapons][1] = 24;
	PaintBallArena[arenaid][pbWeapons][2] = 27;
	PaintBallArena[arenaid][pbTeamRedKills] = 0;
	PaintBallArena[arenaid][pbTeamBlueKills] = 0;
	PaintBallArena[arenaid][pbTeamRedDeaths] = 0;
	PaintBallArena[arenaid][pbTeamBlueDeaths] = 0;
	return 1;
}

stock CreatePaintballArenaHill(arenaid) {
	PaintBallArena[arenaid][pbHillTextID] = Create3DTextLabel("Hill", COLOR_GREEN, PaintBallArena[arenaid][pbHillX], PaintBallArena[arenaid][pbHillY], PaintBallArena[arenaid][pbHillZ], 200.0, PaintBallArena[arenaid][pbVirtual], 0);
}

stock ResetPaintballArenaHill(arenaid) {
    Delete3DTextLabel(PaintBallArena[arenaid][pbHillTextID]);
}

stock SortWinnerPaintballScores(arenaid)
{
	new highscore = 0;
	new score = 0;
	new winnerid;
	for(new i = 0; i < PaintBallArena[arenaid][pbLimit]; i++) {
	    foreach(new p: Player) {
	        if(GetPVarInt(p, "IsInArena") == arenaid) {
	            score = PlayerInfo[p][pKills];
	            if(score > highscore) {
					highscore = score;
					winnerid = p;
	            }
	        }
	    }
	}
	return winnerid;
}

stock SendPaintballArenaTextMessage(arenaid, style, message[])
{
	foreach(new p: Player) {
	    new carenaid = GetPVarInt(p, "IsInArena");
	    if(arenaid == carenaid) {
	        GameTextForPlayer(p, message, 5000, style);
	    }
	}
	return 1;
}

stock SendPaintballArenaMessage(arenaid, color, message[])
{
	foreach(new p: Player) {
   		new carenaid = GetPVarInt(p, "IsInArena");
   		if(arenaid == carenaid) {
	      	SendClientMessageEx(p, color, message);
		}
	}
	return 1;
}
/*
stock SendPaintballArenaSound(arenaid, soundid)
{
    foreach(new p: Player) {
   		new carenaid = GetPVarInt(p, "IsInArena");
   		if(arenaid == carenaid) {
	      	PlayerPlaySound(p, soundid, 0.0, 0.0, 0.0);
		}
	}
	return 1;
}

stock //SendPaintballArenaAudio(arenaid)
{
	foreach(new p: Player) {
	    new carenaid = GetPVarInt(p, "IsInArena");
	    if(arenaid == carenaid) {
	        //SendAudioToPlayer(p, soundid, volume);
	    }
	}
	return 1;
}

stock SendPaintballArenaAudioTeam(arenaid, team)
{
	foreach(new p: Player) {
	    new carenaid = GetPVarInt(p, "IsInArena");
	    if(arenaid == carenaid) {
	        if(PlayerInfo[p][pPaintTeam] == team) {
	            //SendAudioToPlayer(p, soundid, volume);
	        }
	    }
	}
}*/

stock ResetFlagPaintballArena(arenaid, flagid)
{
	switch(flagid)
	{
	    case 1: // Red Flag
	    {
	        if(PaintBallArena[arenaid][pbFlagRedActive] == 1)
	        {
	            Delete3DTextLabel(PaintBallArena[arenaid][pbFlagRedTextID]);
	        }
	        ////SendPaintballArenaAudio(arenaid, 24, 75);
	        //SetTimerEx("//SendPaintballArenaAudio", 250, false, "iii", arenaid, 29, 100);
	        PaintBallArena[arenaid][pbFlagRedActive] = 0;
	        SendPaintballArenaTextMessage(arenaid, 5, "~w~Tro lai ~r~Co Do!");
	        DestroyDynamicObject(PaintBallArena[arenaid][pbFlagRedID]);
	        PaintBallArena[arenaid][pbFlagRedID] = CreateDynamicObject(RED_FLAG_OBJ, PaintBallArena[arenaid][pbFlagRedSpawn][0], PaintBallArena[arenaid][pbFlagRedSpawn][1], PaintBallArena[arenaid][pbFlagRedSpawn][2], 0.0, 0.0, 0.0, PaintBallArena[arenaid][pbVirtual], PaintBallArena[arenaid][pbInterior], -1);


	        PaintBallArena[arenaid][pbFlagRedPos][0] = PaintBallArena[arenaid][pbFlagRedSpawn][0];
	        PaintBallArena[arenaid][pbFlagRedPos][1] = PaintBallArena[arenaid][pbFlagRedSpawn][1];
	        PaintBallArena[arenaid][pbFlagRedPos][2] = PaintBallArena[arenaid][pbFlagRedSpawn][2];
	    }
	    case 2: // Blue Flag
	    {
	        if(PaintBallArena[arenaid][pbFlagBlueActive] == 1)
	        {
	            Delete3DTextLabel(PaintBallArena[arenaid][pbFlagBlueTextID]);
	        }
	        ////SendPaintballArenaAudio(arenaid, 24, 75);
	        //SetTimerEx("//SendPaintballArenaAudio", 250, false, "iii", arenaid, 11, 100);
	        PaintBallArena[arenaid][pbFlagBlueActive] = 0;
	        SendPaintballArenaTextMessage(arenaid, 5, "~w~Tro lai ~b~Co Xanh!");
	        DestroyDynamicObject(PaintBallArena[arenaid][pbFlagBlueID]);
	        PaintBallArena[arenaid][pbFlagBlueID] = CreateDynamicObject(BLUE_FLAG_OBJ, PaintBallArena[arenaid][pbFlagBlueSpawn][0], PaintBallArena[arenaid][pbFlagBlueSpawn][1], PaintBallArena[arenaid][pbFlagBlueSpawn][2], 0.0, 0.0, 0.0, PaintBallArena[arenaid][pbVirtual], PaintBallArena[arenaid][pbInterior], -1);

	        PaintBallArena[arenaid][pbFlagBluePos][0] = PaintBallArena[arenaid][pbFlagBlueSpawn][0];
	        PaintBallArena[arenaid][pbFlagBluePos][1] = PaintBallArena[arenaid][pbFlagBlueSpawn][1];
	        PaintBallArena[arenaid][pbFlagBluePos][2] = PaintBallArena[arenaid][pbFlagBlueSpawn][2];
	    }
	}
}

stock ScoreFlagPaintballArena(playerid, arenaid, flagid)
{
	new string[128];
	switch(flagid)
	{
	    case 1: // Red Flag
	    {
	        if(PaintBallArena[arenaid][pbFlagInstagib] == 1)
	        {
	            SetPlayerHealth(playerid, PaintBallArena[arenaid][pbHealth]);
	            if(PaintBallArena[arenaid][pbArmor] > 0) {
	            	SetPlayerArmor(playerid, PaintBallArena[arenaid][pbArmor]);
	            }
	        }

	        PlayerInfo[playerid][pKills] += 5;

			////SendPaintballArenaAudio(arenaid, 25, 75);
         	//SetTimerEx("//SendPaintballArenaAudio", 250, false, "iii", arenaid, 15, 100);
	        RemovePlayerAttachedObject(playerid, GetPVarInt(playerid, "AOSlotPaintballFlag"));
	        SetPVarInt(playerid, "AOSlotPaintballFlag", -1);
	        PaintBallArena[arenaid][pbFlagRedActive] = 0;
	        PaintBallArena[arenaid][pbTeamBlueScores]++;
	        SendPaintballArenaTextMessage(arenaid, 5, "~b~Team Xanh ~w~Ghi diem!");
			format(string,sizeof(string),"[Paintball] %s da nghi diem cho team Xanh!", GetPlayerNameEx(playerid));
	        SendPaintballArenaMessage(arenaid, COLOR_YELLOW, string);
	        PaintBallArena[arenaid][pbFlagRedID] = CreateDynamicObject(RED_FLAG_OBJ, PaintBallArena[arenaid][pbFlagRedSpawn][0], PaintBallArena[arenaid][pbFlagRedSpawn][1], PaintBallArena[arenaid][pbFlagRedSpawn][2], 0.0, 0.0, 0.0, PaintBallArena[arenaid][pbVirtual], PaintBallArena[arenaid][pbInterior], -1);

	        PaintBallArena[arenaid][pbFlagRedPos][0] = PaintBallArena[arenaid][pbFlagRedSpawn][0];
	        PaintBallArena[arenaid][pbFlagRedPos][1] = PaintBallArena[arenaid][pbFlagRedSpawn][1];
	        PaintBallArena[arenaid][pbFlagRedPos][2] = PaintBallArena[arenaid][pbFlagRedSpawn][2];
	    }
	    case 2: // Blue Flag
	    {
	        if(PaintBallArena[arenaid][pbFlagInstagib] == 1)
	        {
	            SetPlayerHealth(playerid, PaintBallArena[arenaid][pbHealth]);
	            if(PaintBallArena[arenaid][pbArmor] > 0) {
	            	SetPlayerArmor(playerid, PaintBallArena[arenaid][pbArmor]);
	            }
	        }

	        PlayerInfo[playerid][pKills] += 5;

			////SendPaintballArenaAudio(arenaid, 25, 75);
	        //SetTimerEx("//SendPaintballArenaAudio", 250, false, "iii", arenaid, 33, 100);
	        RemovePlayerAttachedObject(playerid, GetPVarInt(playerid, "AOSlotPaintballFlag"));
	        SetPVarInt(playerid, "AOSlotPaintballFlag", -1);
	        PaintBallArena[arenaid][pbFlagBlueActive] = 0;
	        PaintBallArena[arenaid][pbTeamRedScores]++;
	        SendPaintballArenaTextMessage(arenaid, 5, "~r~Team Do ~w~nghi diem!");
			format(string,sizeof(string),"[Paintball] %s da nghi diem cho team Do!", GetPlayerNameEx(playerid));
	        SendPaintballArenaMessage(arenaid, COLOR_YELLOW, string);
	        PaintBallArena[arenaid][pbFlagBlueID] = CreateDynamicObject(BLUE_FLAG_OBJ, PaintBallArena[arenaid][pbFlagBlueSpawn][0], PaintBallArena[arenaid][pbFlagBlueSpawn][1], PaintBallArena[arenaid][pbFlagBlueSpawn][2], 0.0, 0.0, 0.0, PaintBallArena[arenaid][pbVirtual], PaintBallArena[arenaid][pbInterior], -1);

	        PaintBallArena[arenaid][pbFlagBluePos][0] = PaintBallArena[arenaid][pbFlagBlueSpawn][0];
	        PaintBallArena[arenaid][pbFlagBluePos][1] = PaintBallArena[arenaid][pbFlagBlueSpawn][1];
	        PaintBallArena[arenaid][pbFlagBluePos][2] = PaintBallArena[arenaid][pbFlagBlueSpawn][2];
	    }
	}
}

stock DropFlagPaintballArena(playerid, arenaid, flagid)
{
	new string[128];
	new Float:X, Float:Y, Float:Z;
	GetPlayerPos(playerid, X, Y, Z);
	RemovePlayerAttachedObject(playerid, GetPVarInt(playerid, "AOSlotPaintballFlag"));
	SetPVarInt(playerid, "AOSlotPaintballFlag", -1);

	switch(flagid)
	{
	    case 1: // Red Flag
	    {
  			////SendPaintballArenaAudio(arenaid, 28, 100);
	        PaintBallArena[arenaid][pbFlagRedActive] = 1;
	        SendPaintballArenaTextMessage(arenaid, 5, "~w~Loai bo ~r~Co Do!");
			format(string,sizeof(string),"[Paintball] %s da loai bo co Do!", GetPlayerNameEx(playerid));
	        SendPaintballArenaMessage(arenaid, COLOR_YELLOW, string);
	        PaintBallArena[arenaid][pbFlagRedID] = CreateDynamicObject(RED_FLAG_OBJ, X, Y, Z, 0.0, 0.0, 0.0, PaintBallArena[arenaid][pbVirtual], PaintBallArena[arenaid][pbInterior], -1);
	        PaintBallArena[arenaid][pbFlagRedTextID] = Create3DTextLabel("Red Flag", COLOR_RED, X, Y, Z, 200.0, PaintBallArena[arenaid][pbVirtual], 0);
	        //PaintBallArena[arenaid][pbFlagRedTextID] = CreateDynamic3DTextLabel("Red Flag", COLOR_RED, X, Y, Z, 200.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, PaintBallArena[arenaid][pbVirtual], PaintBallArena[arenaid][pbInterior]);
	        PaintBallArena[arenaid][pbFlagRedActiveTime] = 30;

	        PaintBallArena[arenaid][pbFlagRedPos][0] = X;
	        PaintBallArena[arenaid][pbFlagRedPos][1] = Y;
	        PaintBallArena[arenaid][pbFlagRedPos][2] = Z;
	    }
	    case 2: // Blue Flag
	    {
	        ////SendPaintballArenaAudio(arenaid, 10, 100);
	        PaintBallArena[arenaid][pbFlagBlueActive] = 1;
	        SendPaintballArenaTextMessage(arenaid, 5, "~w~Loai bo ~b~Co Xanh!");
			format(string,sizeof(string),"[Paintball] %s da loai bo co Xanh!", GetPlayerNameEx(playerid));
	        SendPaintballArenaMessage(arenaid, COLOR_YELLOW, string);
	        PaintBallArena[arenaid][pbFlagBlueID] = CreateDynamicObject(BLUE_FLAG_OBJ, X, Y, Z, 0.0, 0.0, 0.0, PaintBallArena[arenaid][pbVirtual], PaintBallArena[arenaid][pbInterior], -1);
	        PaintBallArena[arenaid][pbFlagBlueTextID] = Create3DTextLabel("Blue Flag", COLOR_DBLUE, X, Y, Z, 200.0, PaintBallArena[arenaid][pbVirtual], 0);
	        //PaintBallArena[arenaid][pbFlagBlueTextID] = CreateDynamic3DTextLabel("Blue Flag", COLOR_DBLUE, X, Y, Z, 200.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, PaintBallArena[arenaid][pbVirtual], PaintBallArena[arenaid][pbInterior]);
	        PaintBallArena[arenaid][pbFlagBlueActiveTime] = 30;

	        PaintBallArena[arenaid][pbFlagBluePos][0] = X;
	        PaintBallArena[arenaid][pbFlagBluePos][1] = Y;
	        PaintBallArena[arenaid][pbFlagBluePos][2] = Z;
	    }
	}
}

stock PickupFlagPaintballArena(playerid, arenaid, flagid)
{
	new string[128];
	new index = -1;
    if(GetPlayerState(playerid) == PLAYER_STATE_WASTED) { return 1; }
	switch(flagid)
	{
	    case 1: // Red Flag
	    {
	        if(PaintBallArena[arenaid][pbFlagRedActive] == 1)
	        {
	            Delete3DTextLabel(PaintBallArena[arenaid][pbFlagRedTextID]);
	        }
	        ////SendPaintballArenaAudio(arenaid, 23, 75);
	        //SetTimerEx("//SendPaintballArenaAudio", 250, false, "iii", arenaid, 30, 100);
	        PaintBallArena[arenaid][pbFlagRedActive] = -1;
	        SendPaintballArenaTextMessage(arenaid, 5, "~w~Lay la co ~r~Do!");
			format(string,sizeof(string),"[Paintball] %s da lay la co DO!", GetPlayerNameEx(playerid));
	        SendPaintballArenaMessage(arenaid, COLOR_YELLOW, string);
	        //SetTimerEx("//SendAudioToPlayer", 1500, false, "iii", playerid, 42, 100);
			index = FindFreeAttachedObjectSlot(playerid);
			if(index == -1) { RemovePlayerAttachedObject(playerid, 4), index = 4; }
	        SetPlayerAttachedObject(playerid,index,RED_FLAG_OBJ,5,0.0,0.0,0.0,30.0,0.0,0.0);
	        DestroyDynamicObject(PaintBallArena[arenaid][pbFlagRedID]);
	    }
	    case 2: // Blug Flag
	    {
	        if(PaintBallArena[arenaid][pbFlagBlueActive] == 1)
	        {
	            Delete3DTextLabel(PaintBallArena[arenaid][pbFlagBlueTextID]);
	        }
	        ////SendPaintballArenaAudio(arenaid, 23, 75);
	        //SetTimerEx("//SendPaintballArenaAudio", 250, false, "iii", arenaid, 12, 100);
	        PaintBallArena[arenaid][pbFlagBlueActive] = -1;
	        SendPaintballArenaTextMessage(arenaid, 5, "~w~Lay la co ~b~Xanh!");
			format(string,sizeof(string),"[Paintball] %s da lay la co Xanh!", GetPlayerNameEx(playerid));
	        SendPaintballArenaMessage(arenaid, COLOR_YELLOW, string);
	        //SetTimerEx("//SendAudioToPlayer", 1500, false, "iii", playerid, 42, 100);
			index = FindFreeAttachedObjectSlot(playerid);
			if(index == -1) { RemovePlayerAttachedObject(playerid, 4), index = 4; }
	        SetPlayerAttachedObject(playerid,index,BLUE_FLAG_OBJ,5,0.0,0.0,0.0,30.0,0.0,0.0);
	        DestroyDynamicObject(PaintBallArena[arenaid][pbFlagBlueID]);
	    }
	}
	SetPVarInt(playerid, "AOSlotPaintballFlag", index);
	return 1;
}

stock SpawnPaintballArena(playerid, arenaid)
{
	switch(PaintBallArena[arenaid][pbGameType])
	{
	    case 1,4: // Deathmatch, KOTH
	    {
			new rand = Random(1,5);
			switch (rand)
			{
	    		case 1:
	    		{
	        		SetPlayerPos(playerid, PaintBallArena[arenaid][pbDeathmatch1][0],PaintBallArena[arenaid][pbDeathmatch1][1],PaintBallArena[arenaid][pbDeathmatch1][2]);
 					SetPlayerFacingAngle(playerid, PaintBallArena[arenaid][pbDeathmatch1][3]);
	    		}
	    		case 2:
				{
		    		SetPlayerPos(playerid, PaintBallArena[arenaid][pbDeathmatch2][0],PaintBallArena[arenaid][pbDeathmatch2][1],PaintBallArena[arenaid][pbDeathmatch2][2]);
 					SetPlayerFacingAngle(playerid, PaintBallArena[arenaid][pbDeathmatch2][3]);
				}
				case 3:
				{
		    		SetPlayerPos(playerid, PaintBallArena[arenaid][pbDeathmatch3][0],PaintBallArena[arenaid][pbDeathmatch3][1],PaintBallArena[arenaid][pbDeathmatch3][2]);
 					SetPlayerFacingAngle(playerid, PaintBallArena[arenaid][pbDeathmatch3][3]);
				}
				case 4:
				{
		    		SetPlayerPos(playerid, PaintBallArena[arenaid][pbDeathmatch4][0],PaintBallArena[arenaid][pbDeathmatch4][1],PaintBallArena[arenaid][pbDeathmatch4][2]);
 					SetPlayerFacingAngle(playerid, PaintBallArena[arenaid][pbDeathmatch4][3]);
				}
			}
		}
		case 2,3,5: // Team Deathmatch, Capture the Flag or Team KOTH
		{
		    if(PlayerInfo[playerid][pPaintTeam] == 1) // Red
		    {
		    	new rand = Random(1,4);
		    	switch (rand)
		    	{
		    	    case 1:
		    	    {
		    	        SetPlayerPos(playerid, PaintBallArena[arenaid][pbTeamRed1][0],PaintBallArena[arenaid][pbTeamRed1][1],PaintBallArena[arenaid][pbTeamRed1][2]);
 						SetPlayerFacingAngle(playerid, PaintBallArena[arenaid][pbTeamRed1][3]);
		    	    }
		    	    case 2:
		    	    {
		    	        SetPlayerPos(playerid, PaintBallArena[arenaid][pbTeamRed2][0],PaintBallArena[arenaid][pbTeamRed2][1],PaintBallArena[arenaid][pbTeamRed2][2]);
 						SetPlayerFacingAngle(playerid, PaintBallArena[arenaid][pbTeamRed2][3]);
		    	    }
		    	    case 3:
		    	    {
		    	        SetPlayerPos(playerid, PaintBallArena[arenaid][pbTeamRed3][0],PaintBallArena[arenaid][pbTeamRed3][1],PaintBallArena[arenaid][pbTeamRed3][2]);
 						SetPlayerFacingAngle(playerid, PaintBallArena[arenaid][pbTeamRed3][3]);
		    	    }
		    	}
				SetPlayerColor(playerid, PAINTBALL_TEAM_RED);
			}
			if(PlayerInfo[playerid][pPaintTeam] == 2) // Blue
			{
			    new rand = Random(1,4);
			    switch (rand)
			    {
			        case 1:
		    	    {
		    	        SetPlayerPos(playerid, PaintBallArena[arenaid][pbTeamBlue1][0],PaintBallArena[arenaid][pbTeamBlue1][1],PaintBallArena[arenaid][pbTeamBlue1][2]);
 						SetPlayerFacingAngle(playerid, PaintBallArena[arenaid][pbTeamBlue1][3]);
		    	    }
		    	    case 2:
		    	    {
		    	        SetPlayerPos(playerid, PaintBallArena[arenaid][pbTeamBlue2][0],PaintBallArena[arenaid][pbTeamBlue2][1],PaintBallArena[arenaid][pbTeamBlue2][2]);
 						SetPlayerFacingAngle(playerid, PaintBallArena[arenaid][pbTeamBlue2][3]);
		    	    }
		    	    case 3:
		    	    {
		    	        SetPlayerPos(playerid, PaintBallArena[arenaid][pbTeamBlue3][0],PaintBallArena[arenaid][pbTeamBlue3][1],PaintBallArena[arenaid][pbTeamBlue3][2]);
 						SetPlayerFacingAngle(playerid, PaintBallArena[arenaid][pbTeamBlue3][3]);
		    	    }
			    }
			    SetPlayerColor(playerid, PAINTBALL_TEAM_BLUE);
			}
		}
	}
	PlayerInfo[playerid][pVW] = PaintBallArena[arenaid][pbVirtual];
	PlayerInfo[playerid][pInt] = PaintBallArena[arenaid][pbInterior];


	pTazer{playerid} = 0; // Reset Tazer
	ResetPlayerWeapons(playerid);

 	SetPlayerInterior(playerid, PaintBallArena[arenaid][pbInterior]);
 	SetPlayerVirtualWorld(playerid, PaintBallArena[arenaid][pbVirtual]);
 	SetPlayerHealth(playerid, PaintBallArena[arenaid][pbHealth]);
 	if(PaintBallArena[arenaid][pbArmor] >= 0) {
 		SetPlayerArmor(playerid, PaintBallArena[arenaid][pbArmor]);
 	}
 	GivePlayerWeapon(playerid, PaintBallArena[arenaid][pbWeapons][0], 60000);
 	GivePlayerWeapon(playerid, PaintBallArena[arenaid][pbWeapons][1], 60000);
 	GivePlayerWeapon(playerid, PaintBallArena[arenaid][pbWeapons][2], 60000);
}

stock JoinPaintballArena(playerid, arenaid, password[])
{
	new string[128];
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid,name,sizeof(name));

	if(PaintBallArena[arenaid][pbPlayers] >= PaintBallArena[arenaid][pbLimit]) {
	   	return 0;
	}

	if(strcmp(PaintBallArena[arenaid][pbPassword], password, false)) {
	    return 0;
	}

	new team = GetPVarInt(playerid, "pbTeamChoice");
	new teamlimit = PaintBallArena[arenaid][pbLimit]/2;
	new Float:oldX, Float:oldY, Float:oldZ, Float:oldHealth, Float:oldArmor;
	GetPlayerPos(playerid, oldX, oldY, oldZ);

	SetPVarFloat(playerid, "pbOldX", oldX);
	SetPVarFloat(playerid, "pbOldY", oldY);
	SetPVarFloat(playerid, "pbOldZ", oldZ);

	GetPlayerHealth(playerid,oldHealth);
	GetPlayerArmour(playerid,oldArmor);
	SetPVarInt(playerid, "pbOldInt", GetPlayerInterior(playerid));
	SetPVarInt(playerid, "pbOldVW", GetPlayerVirtualWorld(playerid));
	SetPVarFloat(playerid, "pbOldHealth", oldHealth);
	SetPVarFloat(playerid, "pbOldArmor", oldArmor);

 	PaintBallArena[arenaid][pbPlayers]++;

 	if(PaintBallArena[arenaid][pbGameType] == 3) {
		SetPVarInt(playerid, "TickCTFID", SetTimerEx("TickCTF", 1000, true, "d", playerid)); // Player's CTF Tick Function
	}

 	if(PaintBallArena[arenaid][pbGameType] == 4 || PaintBallArena[arenaid][pbGameType] == 5) {
 		SetPlayerCheckpoint(playerid, PaintBallArena[arenaid][pbHillX], PaintBallArena[arenaid][pbHillY], PaintBallArena[arenaid][pbHillZ], PaintBallArena[arenaid][pbHillRadius]);
   		SetPVarInt(playerid, "TickKOTHID", SetTimerEx("TickKOTH", 1000, true, "d", playerid)); // Player's KOTH Tick Function
	}

 	SetPVarInt(playerid, "IsInArena", arenaid);
	switch(team)
	{
	    case 0: // No Team
	    {
	        format(string,sizeof(string),"[Paintball] %s da tham gia vao Paintball", name);
	        SendPaintballArenaMessage(arenaid,COLOR_WHITE,string);
	    }
	    case 1: // Red Team
		{
		    if(PaintBallArena[arenaid][pbTeamRed] >= teamlimit)
		    {
		        SendClientMessageEx(playerid, COLOR_WHITE, "Team DO hien da day, ban duoc chuyen sang team XANH.");
		        PlayerInfo[playerid][pPaintTeam] = 2;
		    	PaintBallArena[arenaid][pbTeamBlue]++;
		    	format(string,sizeof(string),"[Paintball] %s da tham gia vao Paintball va chon team XANH!", name);
		       	SendPaintballArenaMessage(arenaid,PAINTBALL_TEAM_BLUE,string);
		    }
		    else
		    {
		        if(PaintBallArena[arenaid][pbTeamRed] > PaintBallArena[arenaid][pbTeamBlue])
		        {
		            SendClientMessageEx(playerid, COLOR_WHITE, "Team DO hien da day, ban duoc chuyen sang team XANH.");
		        	PlayerInfo[playerid][pPaintTeam] = 2;
		    		PaintBallArena[arenaid][pbTeamBlue]++;
		    		format(string,sizeof(string),"[Paintball] %s da tham gia vao Paintball va chon team XANH!", name);
		       		SendPaintballArenaMessage(arenaid,PAINTBALL_TEAM_BLUE,string);
		        }
		        else
		        {
		        	PlayerInfo[playerid][pPaintTeam] = 1;
		    		PaintBallArena[arenaid][pbTeamRed]++;
		    		format(string,sizeof(string),"[Paintball] %s da tham gia vao Paintball va chon team DO!", name);
		       		SendPaintballArenaMessage(arenaid,PAINTBALL_TEAM_RED,string);
				}
		    }
		}
  		case 2: // Blue Team
	   	{
     		if(PaintBallArena[arenaid][pbTeamBlue] >= teamlimit)
   			{
      			SendClientMessageEx(playerid, COLOR_WHITE, "Team XANH hien da day, ban duoc chuyen sang team DO.");
	        	PlayerInfo[playerid][pPaintTeam] = 1;
	    		PaintBallArena[arenaid][pbTeamRed]++;
	    		format(string,sizeof(string),"[Paintball] %s da tham gia vao team DO!", name);
      			SendPaintballArenaMessage(arenaid,PAINTBALL_TEAM_RED,string);
		    }
	    	else
		    {
		        if(PaintBallArena[arenaid][pbTeamBlue] > PaintBallArena[arenaid][pbTeamRed])
		        {
		            SendClientMessageEx(playerid, COLOR_WHITE, "Team dang khoi dong, ban da duoc chuyen den team DO.");
	        		PlayerInfo[playerid][pPaintTeam] = 1;
	    			PaintBallArena[arenaid][pbTeamRed]++;
	    			format(string,sizeof(string),"[Paintball] %s da tham gia vao Paintball va chon team DO!", name);
      				SendPaintballArenaMessage(arenaid,PAINTBALL_TEAM_RED,string);
		        }
		        else
		        {
      				PlayerInfo[playerid][pPaintTeam] = 2;
	    			PaintBallArena[arenaid][pbTeamBlue]++;
		    		format(string,sizeof(string),"[Paintball] %s da tham gia vao Paintball va chon team XANH!", name);
      				SendPaintballArenaMessage(arenaid,PAINTBALL_TEAM_BLUE,string);
				}
		    }
	    }
	}
 	SendClientMessageEx(playerid, COLOR_WHITE, "Paintball Arena Commands: /scores - /roipaintball - /vaopaintball - /switchpaintball");

	if(PaintBallArena[arenaid][pbExploitPerm] == 0)
 	{
 	    SendClientMessageEx(playerid, COLOR_YELLOW, "Warning: Phong nay khong cho phep QS/CS, ai vi pham se bi loai bo khoi cuoc choi.");
 	}
 	else
 	{
 	    SendClientMessageEx(playerid, COLOR_YELLOW, "Warning: Phong nay cho phep QS/CS, neu ban khong thich, ban co the roi cuoc choi.");
 	}

 	PlayerInfo[playerid][pKills] = 0;
  	PlayerInfo[playerid][pDeaths] = 0;

  	GivePlayerMoneyEx(playerid,-PaintBallArena[GetPVarInt(playerid, "IsInArena")][pbBidMoney]);
    PaintBallArena[GetPVarInt(playerid, "IsInArena")][pbMoneyPool] += PaintBallArena[GetPVarInt(playerid, "IsInArena")][pbBidMoney];

 	SpawnPaintballArena(playerid,GetPVarInt(playerid, "IsInArena"));
 	return 1;
}

stock LeavePaintballArena(playerid, arenaid)
{
	if(arenaid == GetPVarInt(playerid, "IsInArena"))
	{
	    new string[128];
	    new name[MAX_PLAYER_NAME];
	    GetPlayerName(playerid, name, sizeof(name));

		if(arenaid == GetPVarInt(playerid, "ArenaNumber"))
		{
		    SetPVarInt(playerid, "ArenaNumber", -1);
		}
		SetPVarInt(playerid, "IsInArena", -1);

		PlayerInfo[playerid][pKills] = 0;
	    PlayerInfo[playerid][pDeaths] = 0;

		if(PaintBallArena[arenaid][pbGameType] == 4 || PaintBallArena[arenaid][pbGameType] == 5)
		{
		    KillTimer(GetPVarInt(playerid, "TickKOTHID"));
		    DisablePlayerCheckpoint(playerid);
		}
		if(PlayerInfo[playerid][pPaintTeam] == 1)
		{
		    if(GetPVarInt(playerid, "AOSlotPaintballFlag") != -1)
		    {
				DropFlagPaintballArena(playerid, arenaid, 2);
		    }
		    KillTimer(GetPVarInt(playerid, "TickCTFID"));
		    PaintBallArena[arenaid][pbTeamRed]--;
		    PlayerInfo[playerid][pPaintTeam] = 0;
		}
		if(PlayerInfo[playerid][pPaintTeam] == 2)
		{
		    if(GetPVarInt(playerid, "AOSlotPaintballFlag") != -1)
		    {
				DropFlagPaintballArena(playerid, arenaid, 1);
		    }
		    KillTimer(GetPVarInt(playerid, "TickCTFID"));
		    PaintBallArena[arenaid][pbTeamBlue]--;
		    PlayerInfo[playerid][pPaintTeam] = 0;
		}
		PaintBallArena[arenaid][pbPlayers]--;
		if(PaintBallArena[arenaid][pbTimeLeft] > 30)
		{
			format(string,sizeof(string),"[Paintball] %s Da Roi Khoi Paintball", name);
			SendPaintballArenaMessage(arenaid, COLOR_WHITE, string);
		}
		if(PaintBallArena[arenaid][pbPlayers] == 0)
		{
		    ResetPaintballArena(arenaid);
		}
		SetPlayerWeapons(playerid);
  		SetPlayerColor(playerid,TEAM_HIT_COLOR);
  		SetPlayerSkin(playerid, PlayerInfo[playerid][pModel]);
		SetPlayerPos(playerid, GetPVarFloat(playerid, "pbOldX"), GetPVarFloat(playerid, "pbOldY"), GetPVarFloat(playerid, "pbOldZ"));
		SetPlayerHealth(playerid, GetPVarFloat(playerid, "pbOldHealth"));
		SetPlayerArmor(playerid, GetPVarFloat(playerid, "pbOldArmor"));
		SetPlayerVirtualWorld(playerid, GetPVarInt(playerid, "pbOldVW"));
		SetPlayerInterior(playerid, GetPVarInt(playerid, "pbOldInt"));
		PlayerInfo[playerid][pVW] = GetPVarInt(playerid, "pbOldVW");
		PlayerInfo[playerid][pInt] = GetPVarInt(playerid, "pbOldInt");
        PlayerInfo[playerid][pPaintTeam] = 0;
        DeletePVar(playerid, "pbTeamChoice");
		Player_StreamPrep(playerid, GetPVarFloat(playerid, "pbOldX"), GetPVarFloat(playerid, "pbOldY"), GetPVarFloat(playerid, "pbOldZ"), FREEZE_TIME);
	}
}

stock vehicle_lock_doors(vehicle) {

	new
		vParamArr[7];
    print("locked");
	GetVehicleParamsEx(vehicle, vParamArr[0], vParamArr[1], vParamArr[2], vParamArr[3], vParamArr[4], vParamArr[5], vParamArr[6]);
	SetVehicleParamsEx(vehicle, vParamArr[0], vParamArr[1], vParamArr[2], 1, vParamArr[4], vParamArr[5], vParamArr[6]);
	return 1;
}

stock vehicle_unlock_doors(vehicle) {

	new
		vParamArr[7];
		print("unlocked");

	GetVehicleParamsEx(vehicle, vParamArr[0], vParamArr[1], vParamArr[2], vParamArr[3], vParamArr[4], vParamArr[5], vParamArr[6]);
	SetVehicleParamsEx(vehicle, vParamArr[0], vParamArr[1], vParamArr[2], 0, vParamArr[4], vParamArr[5], vParamArr[6]);
	return 1;
}

stock IsSeatAvailable(vehicleid, seat)
{
	switch(GetVehicleModel(vehicleid)) {
		case 425, 430, 432, 441, 446, 448, 452, 453, 454, 464, 465, 472, 473, 476, 481, 484, 485, 486, 493, 501, 509, 510, 519, 520, 530, 531, 532, 539, 553, 564, 568, 571, 572, 574, 583, 592, 594, 595: return 0;
		default: if(IsVehicleOccupied(vehicleid, seat)) return 0;
	}
	return 1;
}

stock IsPlayerInInvalidNosVehicle(playerid)
{
	switch(GetVehicleModel(GetPlayerVehicleID(playerid))) {
		case 430, 446, 448, 449, 452, 453, 454, 461, 462, 463, 468, 472, 473, 481, 484, 493, 509, 510, 521, 522, 523, 537, 538, 569, 570, 581, 586, 590, 595: return 1;
	}
	return 0;
}

stock SetPlayerArmor(Player, Float:Armor)
{
	CurrentArmor[Player] = floatround(Armor, floatround_ceil);
	SetPlayerArmour(Player, Armor);
	return 1;
}

stock RemoveArmor(Player)
{
	DeletePVar(Player, "ArmorWarning");
	CurrentArmor[Player] = 0.0;
	SetPlayerArmour(Player, 0.0);
	return 1;
}

stock GetVehicleSpeed(vehicleid)
{
     new Float:Px,Float:Py,Float:Pz;GetVehicleVelocity(vehicleid,Px,Py,Pz);
     return floatround(floatsqroot(Px*Px+Py*Py+Pz*Pz) * 100.0);
}

stock SurfingCheck(vehicleid)
{
	foreach(new p: Player)
	{
		if(GetPlayerSurfingVehicleID(p) == vehicleid)
		{
			new Float:x, Float:y, Float:z;
			GetPlayerPos(p, x, y, z);
			SetTimerEx("SurfingFix", 2000, 0, "ifff", p, x, y, z);
		}
	}
}

stock AddSpecialToken(playerid)
{

	new
		sz_FileStr[10 + MAX_PLAYER_NAME],
		sz_playerName[MAX_PLAYER_NAME],
		File: fPointer;

	GetPlayerName(playerid, sz_playerName, MAX_PLAYER_NAME);
	format(sz_FileStr, sizeof(sz_FileStr), "stokens/%s", sz_playerName);
	if(fexist(sz_FileStr)) {
		fPointer = fopen(sz_FileStr, io_read);
		fread(fPointer, sz_playerName), fclose(fPointer);

		new
			i_tokenVal = strval(sz_playerName);

		format(sz_playerName, sizeof(sz_playerName), "%i", i_tokenVal + 1);
		fPointer = fopen(sz_FileStr, io_write);
		if(fPointer)
		{
			fwrite(fPointer, sz_playerName);
			fclose(fPointer);
		}
	}
	else {
		fPointer = fopen(sz_FileStr, io_write);
	    if(fPointer)
		{
			fwrite(fPointer, "1");
			fclose(fPointer);
		}
	}
	return 1;
}

stock SeeSpecialTokens(playerid, hoursneeded)
{
	if(PlayerInfo[playerid][pAdmin] >= 2) return 0; // Admins cant win
	if(hoursneeded <= 0) return 1;

	new
		szName[MAX_PLAYER_NAME],
		szFileStr[10 + MAX_PLAYER_NAME];

	GetPlayerName(playerid, szName, MAX_PLAYER_NAME);
	format(szFileStr, sizeof(szFileStr), "stokens/%s", szName);
	if(fexist(szFileStr)) {

		new
			File: iFile = fopen(szFileStr, io_read);

		fread(iFile, szFileStr);
		fclose(iFile);
		if(strval(szFileStr) >= hoursneeded) return 1;
	}
	return 0;
}

stock GetBusinessDefaultPickup(business)
{
	switch (Businesses[business][bType]) {
		case BUSINESS_TYPE_GASSTATION: return 1650;
		case BUSINESS_TYPE_CLOTHING: return 1275;
		case BUSINESS_TYPE_RESTAURANT: return 19094;
		case BUSINESS_TYPE_SEXSHOP: return 321;
		case BUSINESS_TYPE_BAR:
		{
		    new rnd = random(4);
		    if (rnd == 0) return 1486;
		    if (rnd == 1) return 1543;
		    if (rnd == 2) return 1544;
		    if (rnd == 3) return 1951;
		}
		case BUSINESS_TYPE_GYM: return 1318;
		default: return 1274;
	}
	return 1318;
}

stock GetBusinessRankName(rank)
{
	new string[16];
	switch (rank) {
		case 0: string = "Trainee";
		case 1: string = "Employee";
		case 2: string = "Senior Employee";
		case 3: string = "Manager";
		case 4: string = "Co-Owner";
		case 5: string = "Owner";
		default: string = "Undefined";
	}
	return string;
}

stock GetBusinessTypeName(type)
{
	new string[20];
	switch (type) {
		case 1: string = "Tram xang";
		case 2: string = "Shop quan ao";
		case 3: string = "Nha hang";
		case 4: string = "Shop vu khi";
		case 5: string = "Dai ly xe moi";
		case 6: string = "Dai ly xe cu";
		case 7: string = "Tram sua xe";
		case 8: string = "24/7";
		case 9: string = "Bar";
		case 10: string = "Club";
		case 11: string = "Shop nguoi lon";
		case 12: string = "Gym";
		default: string = "Khong xac dinh";
	}
	return string;
}

stock GetInventoryType(businessid)
{
	new string[30];
	if(businessid == INVALID_BUSINESS_ID) {
        string = "Empty";
		return string;
	}
	switch (Businesses[businessid][bType]) {
		case BUSINESS_TYPE_NEWCARDEALERSHIP: string = "Phuong tien";
		case BUSINESS_TYPE_GASSTATION: string = "Xang dau";
		case BUSINESS_TYPE_GUNSHOP: string = "Vat lieu pham phap";
		case BUSINESS_TYPE_MECHANIC: string = "Linh kien xe";
		case BUSINESS_TYPE_STORE: string = "Vat pham 24/7";
		case BUSINESS_TYPE_CLOTHING: string = "Quan ao";
		case BUSINESS_TYPE_RESTAURANT, BUSINESS_TYPE_BAR, BUSINESS_TYPE_CLUB: string = "Thuc pham & Do uong";
		default: string = "Empty";
	}
	return string;
}

stock GetSupplyState(stateid)
{
	new string[28];
	switch (stateid)	{
		case 1: string = "{FFFF00}Pending Shipment";
		case 2: string = "{FFAA00}Shipping";
		case 3: string = "{00AA00}Delivered";
		case 4: string = "{FF3333}Huy bo";
		default: string = "Undefined";
	}
	return string;
}

stock InBusiness(playerid)
{
    if(GetPVarType(playerid, "BusinessesID")) return GetPVarInt(playerid, "BusinessesID");
    else return INVALID_BUSINESS_ID;
}

stock GetClosestGasPump(playerid, &businessid, &pumpslot)
{
	new Float: minrange = 5.0, Float: range;

	businessid = INVALID_BUSINESS_ID;

    for(new b = 0; b < MAX_BUSINESSES; b++)
    {
	    for(new i = 0; i < MAX_BUSINESS_GAS_PUMPS; i++)
	    {
	        range = GetPlayerDistanceFromPoint(playerid, Businesses[b][GasPumpPosX][i], Businesses[b][GasPumpPosY][i], Businesses[b][GasPumpPosZ][i]);
	 	    if (range < minrange)
			{
				businessid = b;
				pumpslot = i;
			    minrange = range;
		    }
	   	}
 	}
}

stock IsBusinessGasAble(iBusinessType) {
 	switch (iBusinessType) {
 		case 1,7,8: return 1;
	}
	return 0;
}

stock GetFreeGasPumpID(biz)
{
    for (new i; i < MAX_BUSINESS_GAS_PUMPS; i++) {
		if (Businesses[biz][GasPumpPosX][i] == 0.0) return i;
	}
	return INVALID_GAS_PUMP;
}

stock ResetPlayerCash(playerid)
{
	PlayerInfo[playerid][pCash] = 0;
	ResetPlayerMoney(playerid);
	return 1;
}

stock RefreshBusinessPickup(i)
{
    DestroyDynamic3DTextLabel(Businesses[i][bDoorText]);
    DestroyDynamic3DTextLabel(Businesses[i][bStateText]);
    DestroyDynamic3DTextLabel(Businesses[i][bSupplyText]);
    DestroyDynamicPickup(Businesses[i][bPickup]);
    if (!(Businesses[i][bExtPos][0] == 0.0 && Businesses[i][bExtPos][1] == 0.0 && Businesses[i][bExtPos][2] == 0.0)) {
        new string[128];
        
        Businesses[i][bPickup] = CreateDynamicPickup(GetBusinessDefaultPickup(i), 23, Businesses[i][bExtPos][0], Businesses[i][bExtPos][1], Businesses[i][bExtPos][2]);
        format(string,sizeof(string),"%s\nSupply Delivery Point", Businesses[i][bName]);
    }
    if (Businesses[i][bExtPos][0] == 0.0 && Businesses[i][bExtPos][1] == 0.0) { 
        DestroyDynamic3DTextLabel(Businesses[i][bDoorText]);
        DestroyDynamic3DTextLabel(Businesses[i][bStateText]);
        DestroyDynamic3DTextLabel(Businesses[i][bSupplyText]);
        DestroyDynamicPickup(Businesses[i][bPickup]);
    }
}

stock SaveGates()
{
	for(new i = 0; i < MAX_GATES; i++)
	{
		SaveGate(i);
	}
	return 1;
}

stock SaveEventPoints() {

	new
		szFileStr[256],
		File: fHandle = fopen("eventpoints.cfg", io_write);

	if(fHandle)
	{
		for(new iIndex; iIndex < MAX_EVENTPOINTS; iIndex++) {
			format(szFileStr, sizeof(szFileStr), "%f|%f|%f|%d|%d|%s|%d\r\n",
				EventPoints[iIndex][epPosX],
				EventPoints[iIndex][epPosY],
				EventPoints[iIndex][epPosZ],
				EventPoints[iIndex][epVW],
				EventPoints[iIndex][epInt],
				EventPoints[iIndex][epPrize],
				EventPoints[iIndex][epFlagable]
			);
			fwrite(fHandle, szFileStr);
		}
		return fclose(fHandle);
	}
	return 0;
}
stock ShopTechBroadCast(color,string[])
{
	foreach(new i: Player)
	{
		if ((PlayerInfo[i][pShopTech] >= 1 || PlayerInfo[i][pAdmin] >= 1338) && PlayerInfo[i][pTogReports] == 0)
		{
			SendClientMessageEx(i, color, string);
		}
	}
	return 1;
}

stock ABroadCast(hColor, szMessage[], iLevel, bool: bUndercover = false) {
	foreach(new i: Player)
	{
		if(PlayerInfo[i][pAdmin] >= iLevel && (bUndercover || !PlayerInfo[i][pTogReports])) {
			SendClientMessageEx(i, hColor, szMessage);
		}
	}
	return 1;
}

stock CBroadCast(color,string[],level)
{
	foreach(new i: Player)
	{
		if (PlayerInfo[i][pHelper] >= level)
		{
			SendClientMessageEx(i, color, string);
			//printf("%s", string);
		}
	}
	return 1;
}

stock OOCOff(color,string[])
{
	foreach(new i: Player)
	{
		if(!gOoc[i]) {
			SendClientMessageEx(i, color, string);
		}
	}
}

stock OOCNews(color,string[])
{
	foreach(new i: Player)
	{
		if(!gNews[i]) {
			SendClientMessageEx(i, color, string);
		}
	}
}

stock SendGroupMessage(iGroupType, color, string[], allegiance = 0)
{
	new iGroupID;
	foreach(new i: Player)
	{
	    iGroupID = PlayerInfo[i][pMember];
		if( iGroupType == -1 || ((0 <= iGroupID < MAX_GROUPS) && arrGroupData[iGroupID][g_iGroupType] == iGroupType) )
		{
		    if(allegiance == 0 || allegiance == arrGroupData[iGroupID][g_iAllegiance])
			{
				SendClientMessageEx(i, color, string);
			}
		}
	}
}

stock SendDivisionMessage(member, division, color, string[])
{
	foreach(new i: Player)
	{
		if(PlayerInfo[i][pMember] == member && PlayerInfo[i][pDivision] == division) {
			SendClientMessageEx(i, color, string);
		}
	}
}

stock SendJobMessage(job, color, string[])
{
	foreach(new i: Player)
	{
		if(((PlayerInfo[i][pJob] == job || PlayerInfo[i][pJob2] == job) && JobDuty[i] == 1) || ((PlayerInfo[i][pJob] == job || PlayerInfo[i][pJob2] == job) && (GetPVarInt(i, "MechanicDuty") == 1 || GetPVarInt(i, "LawyerDuty") == 1))) {
			SendClientMessageEx(i, color, string);
		}
	}
}

stock SendNewFamilyMessage(family, color, string[])
{
	foreach(new i: Player)
	{
		if(PlayerInfo[i][pFMember] == family) {
			if(!gFam[i]) {
				SendClientMessageEx(i, color, string);
			}
		}
		if(PlayerInfo[i][pAdmin] > 1 && GetPVarInt(i, "BigEarFamily") == family && GetPVarInt(i, "BigEar") == 5) {
			new szAntiprivacy[128];
			format(szAntiprivacy, sizeof(szAntiprivacy), "(BE) %s", string);
			SendClientMessageEx(i, color, szAntiprivacy);
		}
	}
}

stock SendFamilyMessage(family, color, string[])
{
	foreach(new i: Player)
	{
		if(PlayerInfo[i][pMember] == family || PlayerInfo[i][pLeader] == family) {
			if(!gFam[i]) {
				SendClientMessageEx(i, color, string);
			}
		}
	}
}

stock SendTaxiMessage(color, string[])
{
	foreach(new i: Player)
	{
 		if(IsATaxiDriver(i) && PlayerInfo[i][pDuty] > 0) {
 		    SendClientMessageEx(i, color, string);
		}

		if(TransportDuty[i] > 0 && (PlayerInfo[i][pJob] == 17 || PlayerInfo[i][pJob2] == 17 || PlayerInfo[i][pTaxiLicense] == 1)) {
		    if(!IsATaxiDriver(i)) {
		    	SendClientMessageEx(i, color, string);
			}
		}
	}
}

stock RadioBroadCast(playerid, string[])
{
	new MiscString[128], Float: aaaPositions[3];
	foreach(new i: Player)
	{
		if(PlayerInfo[i][pRadioFreq] == PlayerInfo[playerid][pRadioFreq] && PlayerInfo[i][pRadio] >= 1 && gRadio{i} != 0)
		{
		    PlayerInfo[playerid][pServiceTime] = gettime()+3;
			GetPlayerPos(i, aaaPositions[0], aaaPositions[1], aaaPositions[2]);
			format(MiscString, sizeof(MiscString), "** (Radio) %s: %s", GetPlayerNameEx(playerid), string);
			SendClientMessageEx(i, COLOR_RADIOFAC, MiscString);
			format(MiscString, sizeof(MiscString), "(Radio) %s", string);
			SetPlayerChatBubble(playerid,MiscString,COLOR_WHITE,15.0,5000);
		}
	}
}

stock SendTeamBeepMessage(color, string[])
{
	foreach(new i: Player)
	{
		if(IsACop(i))
		{
			SendClientMessageEx(i, color, string);
			RingTone[i] = 20;
		}
	}
}

stock SendVIPMessage(color, string[])
{
	foreach(new i: Player)
	{
		if((PlayerInfo[i][pDonateRank] >= 1 || PlayerInfo[i][pAdmin] >= 2) && GetPVarType(i, "togVIP")) {
			SendClientMessageEx(i, color, string);
		}
	}
}

stock SendFamedMessage(color, string[])
{
	foreach(new i: Player)
	{
		if((PlayerInfo[i][pFamed] >= 1 || PlayerInfo[i][pAdmin] >= 4) && GetPVarInt(i, "togFamed") == 1) {
			SendClientMessageEx(i, color, string);
		}
	}
}
stock SendHelperMessage1(color, string[])
{
	foreach(new i: Player)
	{
		if(PlayerInfo[i][pAdmin] >= 2 || PlayerInfo[i][pHelper] == 1)
		{
			SendClientMessageEx(i, color, string);
		}
	}
}
stock SendAdvisorMessage(color, string[])
{
	foreach(new i: Player)
	{
		if((PlayerInfo[i][pHelper] >= 2 || PlayerInfo[i][pDonateRank] == 5 || PlayerInfo[i][pWatchdog] == 1) && advisorchat[i])
		{
			SendClientMessageEx(i, color, string);
		}
		else
		{
			if(PlayerInfo[i][pAdmin] >= 1 && advisorchat[i])
			{
				SendClientMessageEx(i, color, string);
			}
		}
	}
}

stock SendDutyAdvisorMessage(color, string[])
{
	foreach(new i: Player)
	{
		if(PlayerInfo[i][pHelper] >= 2 && GetPVarInt(i, "AdvisorDuty") == 1) {
			SendClientMessageEx(i, color, string);
		}
	}
}

stock PlayerPlayMusic(playerid)
{
	if(IsPlayerConnected(playerid)) {
		SetTimer("StopMusic", 5000, 0);
		PlayerPlaySound(playerid, 1068, 0.0, 0.0, 0.0);
	}
}

stock PlayerFixRadio(playerid)
{
	if(IsPlayerConnected(playerid)) {
		SetTimer("PlayerFixRadio2", 1000, 0);
		PlayerPlaySound(playerid, 1068, 0.0, 0.0, 0.0);
		Fixr[playerid] = 1;
	}
}

stock SavePlants()
{
	new i = 0;
	while(i < MAX_PLANTS)
	{
		SavePlant(i);
		i++;
	}
	if(i > 0) printf("[plant] %i plants saved", i);
	else printf("[plant] Error: No plants saved!");
	return 1;
}

stock number_format(number)
{
	new i, string[15];
	FIXES_valstr(string, number);
	if(strfind(string, "-") != -1) i = strlen(string) - 4;
	else i = strlen(string) - 3;
	while (i >= 1)
 	{
		if(strfind(string, "-") != -1) strins(string, ",", i + 1);
		else strins(string, ",", i);
		i -= 3;
	}
	return string;
}

stock abs(value)
{
    return ((value < 0 ) ? (-value) : (value));
}

stock IsValidBusinessID(id)
{
	if(id == INVALID_BUSINESS_ID) return 0;
	else if(id >= 0 && id < MAX_BUSINESSES) return 1;
	return 0;
}

stock DestroyDynamicGasPump(iBusiness, iPump)
{
	DestroyDynamicObject(Businesses[iBusiness][GasPumpObjectID][iPump]);
	DestroyDynamic3DTextLabel(Businesses[iBusiness][GasPumpInfoTextID][iPump]);
	DestroyDynamic3DTextLabel(Businesses[iBusiness][GasPumpSaleTextID][iPump]);
}

stock CreateDynamicGasPump(iPlayerID = INVALID_PLAYER_ID, iBusiness, iPump)
{
	if (iPlayerID != INVALID_PLAYER_ID)
	{
		new Float: arr_fPos[4];
		GetPlayerPos(iPlayerID, arr_fPos[0], arr_fPos[1], arr_fPos[2]);
		GetPlayerFacingAngle(iPlayerID, arr_fPos[3]);
		Businesses[iBusiness][GasPumpPosX][iPump] = arr_fPos[0];
		Businesses[iBusiness][GasPumpPosY][iPump] = arr_fPos[1];
		Businesses[iBusiness][GasPumpPosZ][iPump] = arr_fPos[2] + 0.4;
		Businesses[iBusiness][GasPumpAngle][iPump] = arr_fPos[3];
	}
	new szLabel[148];
	Businesses[iBusiness][GasPumpObjectID][iPump] = CreateDynamicObject(1676, Businesses[iBusiness][GasPumpPosX][iPump], Businesses[iBusiness][GasPumpPosY][iPump], Businesses[iBusiness][GasPumpPosZ][iPump], 0, 0, Businesses[iBusiness][GasPumpAngle][iPump], .worldid = 0, .streamdistance = 100);
	format(szLabel, sizeof(szLabel), "Fuel Station #%d\nsu dung '/doxang' de bat dau do xang.", iPump);
	Businesses[iBusiness][GasPumpInfoTextID][iPump] = CreateDynamic3DTextLabel(szLabel, COLOR_BASIC, Businesses[iBusiness][GasPumpPosX][iPump], Businesses[iBusiness][GasPumpPosY][iPump], Businesses[iBusiness][GasPumpPosZ][iPump] - 0.3, 10.00);
	format(szLabel, sizeof(szLabel), "Fuel price: $%.2f\nFuel/Price bill: $0.00\nFuel fill: 0.000\nFuel Stock: %.2f/%.2f gallons", Businesses[iBusiness][bGasPrice], Businesses[iBusiness][GasPumpGallons][iPump], Businesses[iBusiness][GasPumpCapacity][iPump]);
	Businesses[iBusiness][GasPumpSaleTextID][iPump] = CreateDynamic3DTextLabel(szLabel, COLOR_BASIC, Businesses[iBusiness][GasPumpPosX][iPump], Businesses[iBusiness][GasPumpPosY][iPump], Businesses[iBusiness][GasPumpPosZ][iPump] + 0.7, 10.00);
}

stock GetWeaponParam(id, WeaponsEnum: param)
{
	for (new i; i < sizeof(Weapons); i++)
	{
		if (Weapons[i][WeaponId] == id)	return Weapons[i][param];
	}
	return 0;
}

stock GetWeaponPrice(business, id)
{
	for (new i; i < sizeof(Weapons); i++)
	{
		if (Weapons[i][WeaponId] == id) return Businesses[business][bItemPrices][i];
	}
	return 0;
}

stock GetCarBusiness(carid)
{
    for(new b = 0; b < MAX_BUSINESSES; b++)
    {
	    for(new i = 0; i < MAX_BUSINESS_DEALERSHIP_VEHICLES; i++)
	    {
	        if (Businesses[b][bVehID][i] == carid) return b;
	    }
	}
	return INVALID_BUSINESS_ID;
}

stock GetBusinessCarSlot(carid)
{
    for(new b = 0; b < MAX_BUSINESSES; b++)
    {
	    for(new i = 0; i < MAX_BUSINESS_DEALERSHIP_VEHICLES; i++)
	    {
	        if (Businesses[b][bVehID][i] == carid) return i;
	    }
	}
	return INVALID_BUSINESS_ID;
}

stock HigherBid(playerid)
{
	new
    	AuctionItem = GetPVarInt(playerid, "AuctionItem");

	if(Auctions[AuctionItem][InProgress] == 1) {
		if(Auctions[AuctionItem][Bidder] != 0) {

			new Player = ReturnUser(Auctions[AuctionItem][Wining]);
			if(IsPlayerConnected(Player) && GetPlayerSQLId(Player) == Auctions[AuctionItem][Bidder])
			{
	  			GivePlayerMoneyEx(Player, Auctions[AuctionItem][Bid]);
	    		SendClientMessageEx(Player, COLOR_WHITE, "Ai do da tra gia cao hon ban, tien cua ban duoc dat lai.");
		    	new szMessage[128];
		    	format(szMessage, sizeof(szMessage), "So tien $%d da duoc tra lai cho %s (IP:%s) de co tra gia khac cao hon", Auctions[AuctionItem][Bid], GetPlayerNameEx(Player), GetPlayerIpEx(Player));
				Log("logs/auction.log", szMessage);

                GivePlayerMoneyEx(playerid, -GetPVarInt(playerid, "BidPlaced"));
				Auctions[AuctionItem][Bid] = GetPVarInt(playerid, "BidPlaced");
				Auctions[AuctionItem][Bidder] = GetPlayerSQLId(playerid);
				strcpy(Auctions[AuctionItem][Wining], GetPlayerNameExt(playerid), MAX_PLAYER_NAME);

				format(szMessage, sizeof(szMessage), "Ban da dat mot gia thau $%i tren %s.", GetPVarInt(playerid, "BidPlaced"), Auctions[AuctionItem][BiddingFor]);
				SendClientMessageEx(playerid, COLOR_WHITE, szMessage);

				format(szMessage, sizeof(szMessage), "%s (IP:%s) da dat mot gia thau $%i tren %s(%i)", GetPlayerNameEx(playerid), GetPlayerIpEx(playerid), GetPVarInt(playerid, "BidPlaced"), Auctions[AuctionItem][BiddingFor], AuctionItem);
				Log("logs/auction.log", szMessage);

				SaveAuction(AuctionItem);

				DeletePVar(playerid, "BidPlaced");
				DeletePVar(playerid, "AuctionItem");
			}
			else
			{
	  			new query[128];
	    		format(query, sizeof(query), "SELECT `Money` FROM `accounts` WHERE `id` = %d", Auctions[AuctionItem][Bidder]);
	    		mysql_function_query(MainPipeline, query, true, "ReturnMoney", "i", playerid);
		   }
		}
		else
		{
		    new
		        szMessage[128];

  			GivePlayerMoneyEx(playerid, -GetPVarInt(playerid, "BidPlaced"));
			Auctions[AuctionItem][Bid] = GetPVarInt(playerid, "BidPlaced");
			Auctions[AuctionItem][Bidder] = GetPlayerSQLId(playerid);
			strcpy(Auctions[AuctionItem][Wining], GetPlayerNameExt(playerid), MAX_PLAYER_NAME);

			format(szMessage, sizeof(szMessage), "Ban da dat mot gia thau $%i tren %s.", GetPVarInt(playerid, "BidPlaced"), Auctions[AuctionItem][BiddingFor]);
			SendClientMessageEx(playerid, COLOR_WHITE, szMessage);

			format(szMessage, sizeof(szMessage), "%s (IP:%s) da dat mot gia thau $%i tren %s(%i)", GetPlayerNameEx(playerid), GetPlayerIpEx(playerid), GetPVarInt(playerid, "BidPlaced"), Auctions[AuctionItem][BiddingFor], AuctionItem);
			Log("logs/auction.log", szMessage);

			SaveAuction(AuctionItem);

			DeletePVar(playerid, "BidPlaced");
			DeletePVar(playerid, "AuctionItem");
		}
	}
	return 1;
}

stock legalRims(playerid, compenent, vehicleid)
{
	if(IsPlayerInRangeOfPoint(playerid, 20, 617.5360,-1.9900,1000.6592)) // Transfender
	{
		switch(compenent)
		{
		    case 1098, 1096, 1085, 1081, 1082, 1074, 1025, 1078, 1097, 1076:
		    {
		        switch(GetVehicleModel(vehicleid))
		        {
		            case  579, 400, 500, 418, 404, 489, 479, 442, 458, 602, 496, 401, 518, 527, 589, 419, 533, 526, 474, 545,
		            517, 410, 600, 436, 439, 549, 491, 555, 445, 507, 585, 604, 466, 492, 546, 551, 516, 467, 426, 405, 580, 409, 550,
		            540, 421, 529, 402, 542, 603, 475, 429, 541, 415, 480, 587, 411, 506, 451, 477, 422, 478, 438, 420, 547: return 1;
		            default: return 0;
		        }
			}
		}
	}
	if(IsPlayerInRangeOfPoint(playerid, 20,615.2861,-124.2390,997.6703)) //Wheel Arch
	{
	    switch(compenent)
		{
		    case 1085, 1077, 1079, 1083, 1081, 1082, 1074, 1075, 1073, 1080:
		    {
		        switch(GetVehicleModel(vehicleid))
		        {
		            case  562, 565, 559, 561, 560, 558: return 1;
		            default: return 0;
		        }
			}
		}
	}
	if(IsPlayerInRangeOfPoint(playerid, 20, 616.7914,-74.8150,997.8929)) // Loco
	{
	    switch(compenent)
		{
		    case 1098, 1077, 1079, 1083, 1075, 1084, 1078, 1097, 1076:
		    {
		        switch(GetVehicleModel(vehicleid))
		        {
		            case  536, 575, 534, 567, 535, 566, 576, 412: return 1;
		            default: return 0;
		        }
			}
		}
	}
	return 0;
}

stock DestroyPlayerVehicle(playerid, playervehicleid)
{
	if(PlayerVehicleInfo[playerid][playervehicleid][pvModelId])
	{
	
	    VehicleSpawned[playerid]--;
	    PlayerCars--;
		DestroyVehicle(PlayerVehicleInfo[playerid][playervehicleid][pvId]);
		PlayerVehicleInfo[playerid][playervehicleid][pvModelId] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvPosX] = 0.0;
		PlayerVehicleInfo[playerid][playervehicleid][pvPosY] = 0.0;
		PlayerVehicleInfo[playerid][playervehicleid][pvPosZ] = 0.0;
		PlayerVehicleInfo[playerid][playervehicleid][pvPosAngle] = 0.0;
		PlayerVehicleInfo[playerid][playervehicleid][pvPaintJob] = -1;
		PlayerVehicleInfo[playerid][playervehicleid][pvColor1] = 126;
		PlayerVehicleInfo[playerid][playervehicleid][pvColor2] = 126;
		PlayerVehicleInfo[playerid][playervehicleid][pvPrice] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvFuel] = 0.0;
		PlayerVehicleInfo[playerid][playervehicleid][pvImpounded] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvSpawned] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvVW] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvInt] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvTicket] = 0;
        PlayerVehicleInfo[playerid][playervehicleid][pvWeapons][0] = 0;
        PlayerVehicleInfo[playerid][playervehicleid][pvWeapons][1] = 0;
        PlayerVehicleInfo[playerid][playervehicleid][pvWeapons][2] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvAmmos][0] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvAmmos][1] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvAmmos][2] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvPlate] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvLock] = 0;
        PlayerVehicleInfo[playerid][playervehicleid][pvLocked] = 0;
		VehicleFuel[PlayerVehicleInfo[playerid][playervehicleid][pvId]] = 0.0;
	    PlayerVehicleInfo[playerid][playervehicleid][pvId] = INVALID_PLAYER_VEHICLE_ID;
	    if(PlayerVehicleInfo[playerid][playervehicleid][pvAllowedPlayerId] != INVALID_PLAYER_ID)
	    {
	        PlayerInfo[PlayerVehicleInfo[playerid][playervehicleid][pvAllowedPlayerId]][pVehicleKeys] = INVALID_PLAYER_VEHICLE_ID;
	        PlayerInfo[PlayerVehicleInfo[playerid][playervehicleid][pvAllowedPlayerId]][pVehicleKeysFrom] = INVALID_PLAYER_ID;
	    	PlayerVehicleInfo[playerid][playervehicleid][pvAllowedPlayerId] = INVALID_PLAYER_ID;
		}

		new query[128];
		format(query, sizeof(query), "DELETE FROM `vehicles` WHERE `id` = '%d'", PlayerVehicleInfo[playerid][playervehicleid][pvSlotId]);
		mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
		PlayerVehicleInfo[playerid][playervehicleid][pvSlotId] = 0;

		//g_mysql_SaveVehicle(playerid, playervehicleid);
	}
}

stock LoadPlayerVehicles(playerid) {
	for(new v = 0; v < MAX_PLAYERVEHICLES; v++) {
		if(vehicleSpawnCountCheck(playerid)) {
			if(PlayerVehicleInfo[playerid][v][pvModelId] >= 400) {
				if(PlayerVehicleInfo[playerid][v][pvSpawned] && !PlayerVehicleInfo[playerid][v][pvDisabled] && !PlayerVehicleInfo[playerid][v][pvImpounded]) {

					PlayerCars++;
					VehicleSpawned[playerid]++;
					new carcreated = CreateVehicle(PlayerVehicleInfo[playerid][v][pvModelId], PlayerVehicleInfo[playerid][v][pvPosX], PlayerVehicleInfo[playerid][v][pvPosY], PlayerVehicleInfo[playerid][v][pvPosZ], PlayerVehicleInfo[playerid][v][pvPosAngle],PlayerVehicleInfo[playerid][v][pvColor1], PlayerVehicleInfo[playerid][v][pvColor2], -1);

					SetVehicleVirtualWorld(carcreated, PlayerVehicleInfo[playerid][v][pvVW]);
  					LinkVehicleToInterior(carcreated, PlayerVehicleInfo[playerid][v][pvInt]);

					Vehicle_ResetData(carcreated);
					PlayerVehicleInfo[playerid][v][pvId] = carcreated;
					VehicleFuel[carcreated] = PlayerVehicleInfo[playerid][v][pvFuel];

					if(PlayerVehicleInfo[playerid][v][pvLocked]) {
						LockPlayerVehicle(playerid, carcreated, PlayerVehicleInfo[playerid][v][pvLock]);
					}
					LoadPlayerVehicleMods(playerid, v);

					if(PlayerVehicleInfo[playerid][v][pvCrashFlag] == 1 && PlayerVehicleInfo[playerid][v][pvCrashX] != 0.0)
					{
						SetVehiclePos(carcreated, PlayerVehicleInfo[playerid][v][pvCrashX], PlayerVehicleInfo[playerid][v][pvCrashY], PlayerVehicleInfo[playerid][v][pvCrashZ]);
						SetVehicleZAngle(carcreated, PlayerVehicleInfo[playerid][v][pvCrashAngle]);
						SetVehicleVirtualWorld(carcreated, PlayerVehicleInfo[playerid][v][pvCrashVW]);
						PlayerVehicleInfo[playerid][v][pvCrashFlag] = 0;
						PlayerVehicleInfo[playerid][v][pvCrashVW] = 0;
						PlayerVehicleInfo[playerid][v][pvCrashX] = 0.0;
						PlayerVehicleInfo[playerid][v][pvCrashY] = 0.0;
						PlayerVehicleInfo[playerid][v][pvCrashZ] = 0.0;
						PlayerVehicleInfo[playerid][v][pvCrashAngle] = 0.0;
						SendClientMessageEx(playerid, COLOR_WHITE, "Xe cua ban da duoc khoi phuc lai vi tri cuoi cung ma ban do xe, hay su dung /timxe de tim lai xe.");
					}
				}
				else if(PlayerVehicleInfo[playerid][v][pvSpawned] != 0) {
					PlayerVehicleInfo[playerid][v][pvSpawned] = 0;
				}
			}
			else if(PlayerVehicleInfo[playerid][v][pvImpounded] != 0) {
				PlayerVehicleInfo[playerid][v][pvImpounded] = 0;
			}
			else if(PlayerVehicleInfo[playerid][v][pvSpawned] != 0) {
				PlayerVehicleInfo[playerid][v][pvSpawned] = 0;
			}
		}
		else PlayerVehicleInfo[playerid][v][pvSpawned] = 0;
	}
	return 1;
}

stock UnloadPlayerVehicles(playerid) {
	for(new v = 0; v < MAX_PLAYERVEHICLES; v++)  {
	    if(PlayerVehicleInfo[playerid][v][pvSpawned] == 1 && PlayerVehicleInfo[playerid][v][pvId] != INVALID_PLAYER_ID) {
            new Float:vhp;
	    	GetVehicleHealth(PlayerVehicleInfo[playerid][v][pvId], vhp);
	    	PlayerVehicleInfo[playerid][v][pvHealth] = vhp;
	    	
	    	new query[129];
	        format(query, sizeof(query), "UPDATE `vehicles` SET `pvHealth` = %0.5f,`pvFuel` = %.05f WHERE `id` = '%d'",  PlayerVehicleInfo[playerid][v][pvHealth],VehicleFuel[PlayerVehicleInfo[playerid][v][pvId]] ,PlayerVehicleInfo[playerid][v][pvSlotId]);
	        print(query);
	        mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);


	    }
    }

	for(new v = 0; v < MAX_PLAYERVEHICLES; v++) if(PlayerVehicleInfo[playerid][v][pvId] != INVALID_PLAYER_VEHICLE_ID && !PlayerVehicleInfo[playerid][v][pvImpounded] && PlayerVehicleInfo[playerid][v][pvSpawned]) {
		PlayerCars--;
		if(LockStatus{PlayerVehicleInfo[playerid][v][pvId]} != 0) LockStatus{PlayerVehicleInfo[playerid][v][pvId]} = 0;
		DestroyVehicle(PlayerVehicleInfo[playerid][v][pvId]);
		PlayerVehicleInfo[playerid][v][pvId] = INVALID_PLAYER_VEHICLE_ID;
		if(PlayerVehicleInfo[playerid][v][pvAllowedPlayerId] != INVALID_PLAYER_ID)
		{
			PlayerInfo[PlayerVehicleInfo[playerid][v][pvAllowedPlayerId]][pVehicleKeys] = INVALID_PLAYER_VEHICLE_ID;
			PlayerInfo[PlayerVehicleInfo[playerid][v][pvAllowedPlayerId]][pVehicleKeysFrom] = INVALID_PLAYER_ID;
			PlayerVehicleInfo[playerid][v][pvAllowedPlayerId] = INVALID_PLAYER_ID;
		}
    }
	VehicleSpawned[playerid] = 0;
}

stock UpdatePlayerVehicleParkPosition(playerid, playervehicleid, Float:newx, Float:newy, Float:newz, Float:newangle, Float:health, VW, Int)
{
	if(PlayerVehicleInfo[playerid][playervehicleid][pvId] != INVALID_PLAYER_VEHICLE_ID && GetVehicleModel(PlayerVehicleInfo[playerid][playervehicleid][pvId]))
	{
		new Float:oldx, Float:oldy, Float:oldz, Float: oldfuel, arrDamage[4];
		oldx = PlayerVehicleInfo[playerid][playervehicleid][pvPosX];
		oldy = PlayerVehicleInfo[playerid][playervehicleid][pvPosY];
		oldz = PlayerVehicleInfo[playerid][playervehicleid][pvPosZ];

		if(oldx == newx && oldy == newy && oldz == newz) return 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvPosX] = newx;
		PlayerVehicleInfo[playerid][playervehicleid][pvPosY] = newy;
		PlayerVehicleInfo[playerid][playervehicleid][pvPosZ] = newz;
		PlayerVehicleInfo[playerid][playervehicleid][pvPosAngle] = newangle;
		PlayerVehicleInfo[playerid][playervehicleid][pvVW] = VW;
		PlayerVehicleInfo[playerid][playervehicleid][pvInt] = Int;
		oldfuel = VehicleFuel[PlayerVehicleInfo[playerid][playervehicleid][pvId]];
		UpdatePlayerVehicleMods(playerid, playervehicleid);
		GetVehicleDamageStatus(PlayerVehicleInfo[playerid][playervehicleid][pvId], arrDamage[0], arrDamage[1], arrDamage[2], arrDamage[3]);
		DestroyVehicle(PlayerVehicleInfo[playerid][playervehicleid][pvId]);
		new carcreated = CreateVehicle(PlayerVehicleInfo[playerid][playervehicleid][pvModelId], PlayerVehicleInfo[playerid][playervehicleid][pvPosX], PlayerVehicleInfo[playerid][playervehicleid][pvPosY], PlayerVehicleInfo[playerid][playervehicleid][pvPosZ],
		PlayerVehicleInfo[playerid][playervehicleid][pvPosAngle],PlayerVehicleInfo[playerid][playervehicleid][pvColor1], PlayerVehicleInfo[playerid][playervehicleid][pvColor2], -1);
		SetVehicleVirtualWorld(carcreated, PlayerVehicleInfo[playerid][playervehicleid][pvVW]);
  		LinkVehicleToInterior(carcreated, PlayerVehicleInfo[playerid][playervehicleid][pvInt]);
		PlayerVehicleInfo[playerid][playervehicleid][pvId] = carcreated;
		Vehicle_ResetData(carcreated);
		VehicleFuel[carcreated] = oldfuel;
		// SetVehicleNumberPlate(carcreated, PlayerVehicleInfo[playerid][playervehicleid][pvNumberPlate]);
		SetVehicleHealth(carcreated, health);
		if(PlayerVehicleInfo[playerid][playervehicleid][pvLocked] == 1) LockPlayerVehicle(playerid, PlayerVehicleInfo[playerid][playervehicleid][pvId], PlayerVehicleInfo[playerid][playervehicleid][pvLock]);
		LoadPlayerVehicleMods(playerid, playervehicleid);
		UpdateVehicleDamageStatus(PlayerVehicleInfo[playerid][playervehicleid][pvId], arrDamage[0], arrDamage[1], arrDamage[2], arrDamage[3]);

		g_mysql_SaveVehicle(playerid, playervehicleid);
		return 1;
	}
	return 0;
}

stock UpdatePlayerVehicleMods(playerid, playervehicleid)
{
	if(GetVehicleModel(PlayerVehicleInfo[playerid][playervehicleid][pvId]) && PlayerVehicleInfo[playerid][playervehicleid][pvImpounded] == 0 && PlayerVehicleInfo[playerid][playervehicleid][pvSpawned] == 1 && !PlayerVehicleInfo[playerid][playervehicleid][pvDisabled]) {
		new carid = PlayerVehicleInfo[playerid][playervehicleid][pvId];
		new exhaust, frontbumper, rearbumper, roof, spoilers, sideskirt1,
			sideskirt2, wheels, hydraulics, nitro, hood, lamps, stereo, ventright, ventleft;
		exhaust = GetVehicleComponentInSlot(carid, CARMODTYPE_EXHAUST);
		frontbumper = GetVehicleComponentInSlot(carid, CARMODTYPE_FRONT_BUMPER);
		rearbumper = GetVehicleComponentInSlot(carid, CARMODTYPE_REAR_BUMPER);
		roof = GetVehicleComponentInSlot(carid, CARMODTYPE_ROOF);
		spoilers = GetVehicleComponentInSlot(carid, CARMODTYPE_SPOILER);
		sideskirt1 = GetVehicleComponentInSlot(carid, CARMODTYPE_SIDESKIRT);
		sideskirt2 = GetVehicleComponentInSlot(carid, CARMODTYPE_SIDESKIRT);
		wheels = GetVehicleComponentInSlot(carid, CARMODTYPE_WHEELS);
		hydraulics = GetVehicleComponentInSlot(carid, CARMODTYPE_HYDRAULICS);
		nitro = GetVehicleComponentInSlot(carid, CARMODTYPE_NITRO);
		hood = GetVehicleComponentInSlot(carid, CARMODTYPE_HOOD);
		lamps = GetVehicleComponentInSlot(carid, CARMODTYPE_LAMPS);
		stereo = GetVehicleComponentInSlot(carid, CARMODTYPE_STEREO);
		ventright = GetVehicleComponentInSlot(carid, CARMODTYPE_VENT_RIGHT);
		ventleft = GetVehicleComponentInSlot(carid, CARMODTYPE_VENT_LEFT);
		if(spoilers >= 1000)    PlayerVehicleInfo[playerid][playervehicleid][pvMods][0] = spoilers;
		if(hood >= 1000)        PlayerVehicleInfo[playerid][playervehicleid][pvMods][1] = hood;
		if(roof >= 1000)        PlayerVehicleInfo[playerid][playervehicleid][pvMods][2] = roof;
		if(sideskirt1 >= 1000)  PlayerVehicleInfo[playerid][playervehicleid][pvMods][3] = sideskirt1;
		if(lamps >= 1000)       PlayerVehicleInfo[playerid][playervehicleid][pvMods][4] = lamps;
		if(nitro >= 1000)       PlayerVehicleInfo[playerid][playervehicleid][pvMods][5] = nitro;
		if(exhaust >= 1000)     PlayerVehicleInfo[playerid][playervehicleid][pvMods][6] = exhaust;
		if(wheels >= 1000)      PlayerVehicleInfo[playerid][playervehicleid][pvMods][7] = wheels;
		if(stereo >= 1000)      PlayerVehicleInfo[playerid][playervehicleid][pvMods][8] = stereo;
		if(hydraulics >= 1000)  PlayerVehicleInfo[playerid][playervehicleid][pvMods][9] = hydraulics;
		if(frontbumper >= 1000) PlayerVehicleInfo[playerid][playervehicleid][pvMods][10] = frontbumper;
		if(rearbumper >= 1000)  PlayerVehicleInfo[playerid][playervehicleid][pvMods][11] = rearbumper;
		if(ventright >= 1000)   PlayerVehicleInfo[playerid][playervehicleid][pvMods][12] = ventright;
		if(ventleft >= 1000)    PlayerVehicleInfo[playerid][playervehicleid][pvMods][13] = ventleft;
		if(sideskirt2 >= 1000)  PlayerVehicleInfo[playerid][playervehicleid][pvMods][14] = sideskirt2;

		g_mysql_SaveVehicle(playerid, playervehicleid);
	}
}

stock UpdateGroupVehicleMods(groupvehicleid)
{
	if(GetVehicleModel(DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][gv_iSpawnedID])) {
		new carid = DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][gv_iSpawnedID];
		new exhaust, frontbumper, rearbumper, roof, spoilers, sideskirt1,
			sideskirt2, wheels, hydraulics, nitro, hood, lamps, stereo, ventright, ventleft;
		exhaust = GetVehicleComponentInSlot(carid, CARMODTYPE_EXHAUST);
		frontbumper = GetVehicleComponentInSlot(carid, CARMODTYPE_FRONT_BUMPER);
		rearbumper = GetVehicleComponentInSlot(carid, CARMODTYPE_REAR_BUMPER);
		roof = GetVehicleComponentInSlot(carid, CARMODTYPE_ROOF);
		spoilers = GetVehicleComponentInSlot(carid, CARMODTYPE_SPOILER);
		sideskirt1 = GetVehicleComponentInSlot(carid, CARMODTYPE_SIDESKIRT);
		sideskirt2 = GetVehicleComponentInSlot(carid, CARMODTYPE_SIDESKIRT);
		wheels = GetVehicleComponentInSlot(carid, CARMODTYPE_WHEELS);
		hydraulics = GetVehicleComponentInSlot(carid, CARMODTYPE_HYDRAULICS);
		nitro = GetVehicleComponentInSlot(carid, CARMODTYPE_NITRO);
		hood = GetVehicleComponentInSlot(carid, CARMODTYPE_HOOD);
		lamps = GetVehicleComponentInSlot(carid, CARMODTYPE_LAMPS);
		stereo = GetVehicleComponentInSlot(carid, CARMODTYPE_STEREO);
		ventright = GetVehicleComponentInSlot(carid, CARMODTYPE_VENT_RIGHT);
		ventleft = GetVehicleComponentInSlot(carid, CARMODTYPE_VENT_LEFT);
		if(spoilers >= 1000)    DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][0] = spoilers;
		if(hood >= 1000)        DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][1] = hood;
		if(roof >= 1000)        DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][2] = roof;
		if(sideskirt1 >= 1000)  DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][3] = sideskirt1;
		if(lamps >= 1000)       DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][4] = lamps;
		if(nitro >= 1000)       DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][5] = nitro;
		if(exhaust >= 1000)     DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][6] = exhaust;
		if(wheels >= 1000)      DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][7] = wheels;
		if(stereo >= 1000)      DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][8] = stereo;
		if(hydraulics >= 1000)  DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][9] = hydraulics;
		if(frontbumper >= 1000) DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][10] = frontbumper;
		if(rearbumper >= 1000)  DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][11] = rearbumper;
		if(ventright >= 1000)   DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][12] = ventright;
		if(ventleft >= 1000)    DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][13] = ventleft;
		if(sideskirt2 >= 1000)  DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][14] = sideskirt2;

		DynVeh_Save(DynVeh[groupvehicleid]);
	}
}

stock LoadGroupVehicleMods(groupvehicleid)
{
	if(GetVehicleModel(DynVehicleInfo[DynVeh[groupvehicleid]][gv_iSpawnedID])) {

        /*if(strlen(PlayerVehicleInfo[playerid][groupvehicleid][pvPlate]) > 0)
		{
		    SetVehicleNumberPlate(PlayerVehicleInfo[playerid][groupvehicleid][pvId], PlayerVehicleInfo[playerid][groupvehicleid][pvPlate]);
		    SetVehiclePos(PlayerVehicleInfo[playerid][groupvehicleid][pvId], 9999.9, 9999.9, 9999.9);
		    SetVehiclePos(PlayerVehicleInfo[playerid][groupvehicleid][pvId], PlayerVehicleInfo[playerid][groupvehicleid][pvPosX], PlayerVehicleInfo[playerid][groupvehicleid][pvPosY], PlayerVehicleInfo[playerid][groupvehicleid][pvPosZ]);
		}*/

		/*if(PlayerVehicleInfo[playerid][groupvehicleid][pvPaintJob] != -1)
		{
			 ChangeVehiclePaintjob(PlayerVehicleInfo[playerid][groupvehicleid][pvId], PlayerVehicleInfo[playerid][groupvehicleid][pvPaintJob]);
			 ChangeVehicleColor(PlayerVehicleInfo[playerid][groupvehicleid][pvId], PlayerVehicleInfo[playerid][groupvehicleid][pvColor1], PlayerVehicleInfo[playerid][groupvehicleid][pvColor2]);
		}*/
		for(new m = 0; m < MAX_MODS; m++)
		{
		    if (DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][m] >= 1000  && DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][m] <= 1193)
		    {
				if (InvalidModCheck(GetVehicleModel(DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][gv_iSpawnedID]),DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][m]))
				{
					AddVehicleComponent(DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][gv_iSpawnedID], DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][m]);
				}
				else
				{
				    DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][m] = 0;
				}
			}
		}
	}
}

stock LoadPlayerVehicleMods(playerid, playervehicleid)
{
	if(GetVehicleModel(PlayerVehicleInfo[playerid][playervehicleid][pvId]) && PlayerVehicleInfo[playerid][playervehicleid][pvImpounded] == 0 && PlayerVehicleInfo[playerid][playervehicleid][pvSpawned] == 1) {

        if(strlen(PlayerVehicleInfo[playerid][playervehicleid][pvPlate]) > 0)
		{
		    SetVehicleNumberPlate(PlayerVehicleInfo[playerid][playervehicleid][pvId], PlayerVehicleInfo[playerid][playervehicleid][pvPlate]);
		    SetVehiclePos(PlayerVehicleInfo[playerid][playervehicleid][pvId], 9999.9, 9999.9, 9999.9);
		    SetVehiclePos(PlayerVehicleInfo[playerid][playervehicleid][pvId], PlayerVehicleInfo[playerid][playervehicleid][pvPosX], PlayerVehicleInfo[playerid][playervehicleid][pvPosY], PlayerVehicleInfo[playerid][playervehicleid][pvPosZ]);
		}

		if(PlayerVehicleInfo[playerid][playervehicleid][pvPaintJob] != -1)
		{
			 ChangeVehiclePaintjob(PlayerVehicleInfo[playerid][playervehicleid][pvId], PlayerVehicleInfo[playerid][playervehicleid][pvPaintJob]);
			 ChangeVehicleColor(PlayerVehicleInfo[playerid][playervehicleid][pvId], PlayerVehicleInfo[playerid][playervehicleid][pvColor1], PlayerVehicleInfo[playerid][playervehicleid][pvColor2]);
		}
		for(new m = 0; m < MAX_MODS; m++)
		{
		    if (PlayerVehicleInfo[playerid][playervehicleid][pvMods][m] >= 1000  && PlayerVehicleInfo[playerid][playervehicleid][pvMods][m] <= 1193)
		    {
				if (InvalidModCheck(GetVehicleModel(PlayerVehicleInfo[playerid][playervehicleid][pvId]),PlayerVehicleInfo[playerid][playervehicleid][pvMods][m]))
				{
					AddVehicleComponent(PlayerVehicleInfo[playerid][playervehicleid][pvId], PlayerVehicleInfo[playerid][playervehicleid][pvMods][m]);
				}
				else
				{
				    PlayerVehicleInfo[playerid][playervehicleid][pvMods][m] = 0;
				}
			}
		}
	}
}

stock GetPlayerFreeVehicleId(playerid) {
	for(new i; i < MAX_PLAYERVEHICLES; ++i) {
		if(PlayerVehicleInfo[playerid][i][pvModelId] == 0) return i;
	}
	return -1;
}

stock GetPlayerVehicle(playerid, vehicleid)
{
    for(new v = 0; v < MAX_PLAYERVEHICLES; v++)
    {
        if(PlayerVehicleInfo[playerid][v][pvId] == vehicleid)
        {
            return v;
        }
    }
    return -1;
}

stock str_replacez(sSearch[], sReplace[], const sSubject[], &iCount = 0)
{
	new
		iLengthTarget = strlen(sSearch),
		iLengthReplace = strlen(sReplace),
		iLengthSource = strlen(sSubject),
		iItterations = (iLengthSource - iLengthTarget) + 1;

	new
		sTemp[128],
		sReturn[128];

	strcat(sReturn, sSubject, 256);
	iCount = 0;

	for(new iIndex; iIndex < iItterations; ++iIndex)
	{
		strmid(sTemp, sReturn, iIndex, (iIndex + iLengthTarget), (iLengthTarget + 1));

		if(!strcmp(sTemp, sSearch, false))
		{
			strdel(sReturn, iIndex, (iIndex + iLengthTarget));
			strins(sReturn, sReplace, iIndex, iLengthReplace);

			iIndex += iLengthTarget;
			iCount++;
		}
	}
	return sReturn;
}

stock SaveAllAccountsUpdate()
{
	foreach(new i: Player)
	{
		if(gPlayerLogged{i} > 0)
		{
	    	GetPlayerIp(i, PlayerInfo[i][pIP], 16);
			SetPVarInt(i, "AccountSaving", 1);
			SetPVarInt(i, "AccountSaved", 0);
			OnPlayerStatsUpdate(i);
			break; // We only need to save one person at a time.
		}
	}
}

stock ClearTackle(playerid)
{
    TogglePlayerControllable(playerid, 1);
	PreloadAnimLib(playerid, "SUNBATHE");
	PreloadAnimLib(GetPVarInt(playerid, "IsTackled"), "SUNBATHE");
    ApplyAnimation(playerid, "SUNBATHE", "Lay_Bac_out", 4.1, 0, 1, 1, 0, 0, 1);
	DeletePVar(GetPVarInt(playerid, "IsTackled"), "Tackling");
	DeletePVar(playerid, "IsTackled");
	DeletePVar(playerid, "TackleCooldown");
	DeletePVar(playerid, "TackledResisting");
	ShowPlayerDialog(playerid, -1, DIALOG_STYLE_LIST, "Dong lai", "Dong lai", "Dong lai", "Dong lai");
	return 1;
}

stock Elevator_Initialize()
{
	// Initializes the elevator.

	Obj_Elevator 			= CreateDynamicObject(18755, 1786.678100, -1303.459472, GROUND_Z_COORD + ELEVATOR_OFFSET, 0.000000, 0.000000, 270.000000);
	Obj_ElevatorDoors[0] 	= CreateDynamicObject(18757, X_DOOR_CLOSED, -1303.459472, GROUND_Z_COORD, 0.000000, 0.000000, 270.000000);
	Obj_ElevatorDoors[1] 	= CreateDynamicObject(18756, X_DOOR_CLOSED, -1303.459472, GROUND_Z_COORD, 0.000000, 0.000000, 270.000000);

	Label_Elevator          = CreateDynamic3DTextLabel("Bam '~k~~GROUP_CONTROL_BWD~' de su dung thang may", COLOR_YELLOW, 1784.9822, -1302.0426, 13.6491, 4.0);


	new string[128],
		Float:z;

	for(new i; i < sizeof(Obj_FloorDoors); i ++)
	{
	    Obj_FloorDoors[i][0] 	= CreateDynamicObject(18757, X_DOOR_CLOSED, -1303.171142, GetDoorsZCoordForFloor(i), 0.000000, 0.000000, 270.000000);
		Obj_FloorDoors[i][1] 	= CreateDynamicObject(18756, X_DOOR_CLOSED, -1303.171142, GetDoorsZCoordForFloor(i), 0.000000, 0.000000, 270.000000);

		format(string, sizeof(string), "%s\nBam '~k~~GROUP_CONTROL_BWD~' de goi", LAElevatorFloorData[0][i]);

		if(i == 0)
		    z = 13.4713;
		else
		    z = 13.4713 + 8.7396 + ((i-1) * 5.45155);

		Label_Floors[i]         = CreateDynamic3DTextLabel(string, COLOR_YELLOW, 1783.9799, -1300.7660, z, 10.5);
		// Label_Elevator, Text3D:Label_Floors[21];
	}

	// Open ground floor doors:
	Floor_OpenDoors(0);
	Elevator_OpenDoors();
}

stock Elevator_OpenDoors()
{
	// Opens the elevator's doors.

	new Float:x, Float:y, Float:z;

	GetDynamicObjectPos(Obj_ElevatorDoors[0], x, y, z);
	MoveDynamicObject(Obj_ElevatorDoors[0], X_DOOR_L_OPENED, y, z, DOORS_SPEED);
	MoveDynamicObject(Obj_ElevatorDoors[1], X_DOOR_R_OPENED, y, z, DOORS_SPEED);
}

stock Elevator_CloseDoors()
{
    // Closes the elevator's doors.

    if(ElevatorState == ELEVATOR_STATE_MOVING)
	    return 0;

    new Float:x, Float:y, Float:z;

	GetDynamicObjectPos(Obj_ElevatorDoors[0], x, y, z);
	MoveDynamicObject(Obj_ElevatorDoors[0], X_DOOR_CLOSED, y, z, DOORS_SPEED);
	MoveDynamicObject(Obj_ElevatorDoors[1], X_DOOR_CLOSED, y, z, DOORS_SPEED);
	return 1;
}

stock Floor_OpenDoors(floorid)
{
    // Opens the doors at the specified floor.
    MoveDynamicObject(Obj_FloorDoors[floorid][0], X_DOOR_L_OPENED, -1303.171142, GetDoorsZCoordForFloor(floorid), DOORS_SPEED);
	MoveDynamicObject(Obj_FloorDoors[floorid][1], X_DOOR_R_OPENED, -1303.171142, GetDoorsZCoordForFloor(floorid), DOORS_SPEED);
}

stock Floor_CloseDoors(floorid)
{
    // Closes the doors at the specified floor.

    MoveDynamicObject(Obj_FloorDoors[floorid][0], X_DOOR_CLOSED, -1303.171142, GetDoorsZCoordForFloor(floorid), DOORS_SPEED);
	MoveDynamicObject(Obj_FloorDoors[floorid][1], X_DOOR_CLOSED, -1303.171142, GetDoorsZCoordForFloor(floorid), DOORS_SPEED);
}

stock Elevator_MoveToFloor(floorid)
{
	// Moves the elevator to specified floor (doors are meant to be already closed).

	ElevatorState = ELEVATOR_STATE_MOVING;
	ElevatorFloor = floorid;

	// Move the elevator slowly, to give time to clients to sync the object surfing. Then, boost it up:
	MoveDynamicObject(Obj_Elevator, 1786.678100, -1303.459472, GetElevatorZCoordForFloor(floorid), 0.25);
    MoveDynamicObject(Obj_ElevatorDoors[0], X_DOOR_CLOSED, -1303.459472, GetDoorsZCoordForFloor(floorid), 0.25);
    MoveDynamicObject(Obj_ElevatorDoors[1], X_DOOR_CLOSED, -1303.459472, GetDoorsZCoordForFloor(floorid), 0.25);
    DestroyDynamic3DTextLabel(Label_Elevator);

	ElevatorBoostTimer = SetTimerEx("Elevator_Boost", 2000, 0, "i", floorid);
}

stock RemoveFirstQueueFloor()
{
	// Removes the data in ElevatorQueue[0], and reorders the queue accordingly.

	for(new i; i < sizeof(ElevatorQueue) - 1; i ++)
	    ElevatorQueue[i] = ElevatorQueue[i + 1];

	ElevatorQueue[sizeof(ElevatorQueue) - 1] = INVALID_FLOOR;
}

stock AddFloorToQueue(floorid)
{
 	// Adds 'floorid' at the end of the queue.

	// Scan for the first empty space:
	new slot = -1;
	for(new i; i < sizeof(ElevatorQueue); i ++)
	{
	    if(ElevatorQueue[i] == INVALID_FLOOR)
	    {
	        slot = i;
	        break;
	    }
	}

	if(slot != -1)
	{
	    ElevatorQueue[slot] = floorid;

     	// If needed, move the elevator.
	    if(ElevatorState == ELEVATOR_STATE_IDLE)
	        ReadNextFloorInQueue();

	    return 1;
	}
	return 0;
}

stock ResetElevatorQueue()
{
	// Resets the queue.

	for(new i; i < sizeof(ElevatorQueue); i ++)
	{
	    ElevatorQueue[i] 	= INVALID_FLOOR;
	    FloorRequestedBy[i] = INVALID_PLAYER_ID;
	}
}

stock IsFloorInQueue(floorid)
{
	// Checks if the specified floor is currently part of the queue.

	for(new i; i < sizeof(ElevatorQueue); i ++)
	    if(ElevatorQueue[i] == floorid)
	        return 1;

	return 0;
}

stock ReadNextFloorInQueue()
{
	// Reads the next floor in the queue, closes doors, and goes to it.

	if(ElevatorState != ELEVATOR_STATE_IDLE || ElevatorQueue[0] == INVALID_FLOOR)
	    return 0;

	Elevator_CloseDoors();
	Floor_CloseDoors(ElevatorFloor);
	return 1;
}

stock DidPlayerRequestElevator(playerid)
{
	for(new i; i < sizeof(FloorRequestedBy); i ++)
	    if(FloorRequestedBy[i] == playerid)
	        return 1;

	return 0;
}

stock ShowElevatorDialog(playerid, elev)
{
	new string[512], maxfloors;
	switch(elev)
	{
		case 1: maxfloors = 20;
		case 2: maxfloors = 8;
	}
 	for(new x; x < maxfloors; x++)
	{
  		format(string, sizeof(string), "%s%d - %s\n", string, (x+1), LAElevatorFloorData[0][x]);
	}

	ShowPlayerDialog(playerid, LAELEVATOR, DIALOG_STYLE_LIST, "Thang may", string, "Lua chon", "Huy bo");
}

stock CallElevator(playerid, floorid)
{
	// Calls the elevator (also used with the elevator dialog).

	if(FloorRequestedBy[floorid] != INVALID_PLAYER_ID || IsFloorInQueue(floorid))
	    return 0;

	FloorRequestedBy[floorid] = playerid;
	AddFloorToQueue(floorid);
	return 1;
}
stock PlayAudioStreamForPlayerEx(playerid, url[], Float:posX = 0.0, Float:posY = 0.0, Float:posZ = 0.0, Float:distance = 50.0, usepos = 0)
{
	if(GetPVarType(playerid, "pAudioStream")) StopAudioStreamForPlayer(playerid);
	else SetPVarInt(playerid, "pAudioStream", 1);
    PlayAudioStreamForPlayer(playerid, url, posX, posY, posZ, distance, usepos);
}

stock StopAudioStreamForPlayerEx(playerid)
{
	DeletePVar(playerid, "pAudioStream");
    StopAudioStreamForPlayer(playerid);
}

stock Misc_Save() {

	new
		szFileStr[32],
		File: iFileHandle = fopen("serverConfig.ini", io_write);

	ini_SetInteger(iFileHandle, szFileStr, "RaceLaps", RaceTotalLaps);
	ini_SetInteger(iFileHandle, szFileStr, "RaceJoins", TotalJoinsRace);
	ini_SetInteger(iFileHandle, szFileStr, "Jackpot", Jackpot);
	ini_SetInteger(iFileHandle, szFileStr, "Tax", Tax);
	ini_SetInteger(iFileHandle, szFileStr, "TaxVal", TaxValue);
	ini_SetInteger(iFileHandle, szFileStr, "VIPM", VIPM);
	ini_SetInteger(iFileHandle, szFileStr, "LoginCount", TotalLogin);
	ini_SetInteger(iFileHandle, szFileStr, "ConnCount", TotalConnect);
	ini_SetInteger(iFileHandle, szFileStr, "ABanCount", TotalAutoBan);
	ini_SetInteger(iFileHandle, szFileStr, "RegCount", TotalRegister);
	ini_SetInteger(iFileHandle, szFileStr, "MaxPCount", MaxPlayersConnected);
	ini_SetInteger(iFileHandle, szFileStr, "MaxPDay", MPDay);
	ini_SetInteger(iFileHandle, szFileStr, "MaxPMonth", MPMonth);
	ini_SetInteger(iFileHandle, szFileStr, "MaxPYear", MPYear);
	ini_SetInteger(iFileHandle, szFileStr, "Uptime", TotalUptime);
	ini_SetInteger(iFileHandle, szFileStr, "BoxWins", Titel[TitelWins]);
	ini_SetInteger(iFileHandle, szFileStr, "BoxLosses", Titel[TitelLoses]);
	ini_SetInteger(iFileHandle, szFileStr, "SpecTimer", SpecTimer);
	ini_SetInteger(iFileHandle, szFileStr, "TRTax", TRTax);
	ini_SetInteger(iFileHandle, szFileStr, "TRTaxVal", TRTaxValue);
	ini_SetInteger(iFileHandle, szFileStr, "SpeedingTickets", SpeedingTickets);

	if(iRewardPlay) {
		ini_SetInteger(iFileHandle, szFileStr, "RewardPlay", true);
	}
	if(iRewardBox) {

	    new
			Float: fObjectPos[3];

		GetDynamicObjectPos(iRewardObj, fObjectPos[0], fObjectPos[1], fObjectPos[2]);
	    ini_SetFloat(iFileHandle, szFileStr, "RewardPosX", fObjectPos[0]);
		ini_SetFloat(iFileHandle, szFileStr, "RewardPosY", fObjectPos[1]);
		ini_SetFloat(iFileHandle, szFileStr, "RewardPosZ", fObjectPos[2]);
	}
	ini_SetInteger(iFileHandle, szFileStr, "TicketsSold", TicketsSold);
	if(DoubleXP) {
		ini_SetInteger(iFileHandle, szFileStr, "DoubleXP", true);
	}
	fclose(iFileHandle);
}

stock Misc_Load() {

	new
		szResult[32],
		szFileStr[160],
		Float: fObjectPos[3],
		File: iFileHandle = fopen("serverConfig.ini", io_read);

	while(fread(iFileHandle, szFileStr, sizeof(szFileStr))) {

		if(ini_GetValue(szFileStr, "RaceLaps", szResult, sizeof(szResult)))													RaceTotalLaps = strval(szResult);
		else if(ini_GetValue(szFileStr, "RaceJoins", szResult, sizeof(szResult)))											TotalJoinsRace = strval(szResult);
		else if(ini_GetValue(szFileStr, "Jackpot", szResult, sizeof(szResult)))												Jackpot = strval(szResult);
		else if(ini_GetValue(szFileStr, "Tax", szResult, sizeof(szResult)))													Tax = strval(szResult);
		else if(ini_GetValue(szFileStr, "TaxVal", szResult, sizeof(szResult)))												TaxValue = strval(szResult);
		else if(ini_GetValue(szFileStr, "VIPM", szResult, sizeof(szResult)))												VIPM = strval(szResult);
		else if(ini_GetValue(szFileStr, "LoginCount", szResult, sizeof(szResult)))											TotalLogin = strval(szResult);
		else if(ini_GetValue(szFileStr, "ConnCount", szResult, sizeof(szResult)))											TotalConnect = strval(szResult);
		else if(ini_GetValue(szFileStr, "ABanCount", szResult, sizeof(szResult)))											TotalAutoBan = strval(szResult);
		else if(ini_GetValue(szFileStr, "RegCount", szResult, sizeof(szResult)))											TotalRegister = strval(szResult);
		else if(ini_GetValue(szFileStr, "MaxPCount", szResult, sizeof(szResult)))											MaxPlayersConnected	= strval(szResult);
		else if(ini_GetValue(szFileStr, "MaxPDay", szResult, sizeof(szResult)))												MPDay = strval(szResult);
		else if(ini_GetValue(szFileStr, "MaxPMonth", szResult, sizeof(szResult)))											MPMonth = strval(szResult);
		else if(ini_GetValue(szFileStr, "MaxPYear", szResult, sizeof(szResult)))											MPYear = strval(szResult);
		else if(ini_GetValue(szFileStr, "Uptime", szResult, sizeof(szResult)))												TotalUptime = strval(szResult);
		else if(ini_GetValue(szFileStr, "BoxWins", szResult, sizeof(szResult)))												Titel[TitelWins] = strval(szResult);
		else if(ini_GetValue(szFileStr, "BoxLosses", szResult, sizeof(szResult)))											Titel[TitelLoses] = strval(szResult);
		else if(ini_GetValue(szFileStr, "SpecTimer", szResult, sizeof(szResult)))											SpecTimer = strval(szResult);
		else if(ini_GetValue(szFileStr, "RewardPlay", szResult, sizeof(szResult)))											iRewardPlay = strval(szResult);
		else if(ini_GetValue(szFileStr, "RewardPosX", szResult, sizeof(szResult)))											fObjectPos[0] = floatstr(szResult);
		else if(ini_GetValue(szFileStr, "RewardPosY", szResult, sizeof(szResult)))											fObjectPos[1] = floatstr(szResult);
		else if(ini_GetValue(szFileStr, "RewardPosZ", szResult, sizeof(szResult)))											fObjectPos[2] = floatstr(szResult);
		else if(ini_GetValue(szFileStr, "TicketsSold", szResult, sizeof(szResult)))                                         TicketsSold = strval(szResult);
		else if(ini_GetValue(szFileStr, "TRTax", szResult, sizeof(szResult)))												TRTax = strval(szResult);
		else if(ini_GetValue(szFileStr, "TRTaxVal", szResult, sizeof(szResult)))											TRTaxValue = strval(szResult);
		else if(ini_GetValue(szFileStr, "SpeedingTickets", szResult, sizeof(szResult)))										SpeedingTickets = strval(szResult);
		else if(ini_GetValue(szFileStr, "DoubleXP", szResult, sizeof(szResult)))											DoubleXP = strval(szResult);

	}
	if(iRewardBox) {
		iRewardObj = CreateDynamicObject(19055, fObjectPos[0], fObjectPos[1], fObjectPos[2], 0.0, 0.0, 0.0, .streamdistance = 100.0);
		tRewardText = CreateDynamic3DTextLabel("Gold Reward Gift Box\n{FFFFFF}/getrewardgift{F3FF02} de nhan qua cua ban!", COLOR_YELLOW, fObjectPos[0], fObjectPos[1], fObjectPos[2], 10.0, .testlos = 1, .streamdistance = 50.0);
	}
	fclose(iFileHandle);
	printf("[MiscLoad] Misc Loaded");
}
stock ini_GetInt(szParse[], szValueName[], &iValue) {

	new
		iPos = strfind(szParse, "=", false);

	if(strcmp(szParse, szValueName, false, iPos) == 0) {
		iValue = strval(szParse[iPos + 1]);
		return 1;
	}
	return 0;
}

stock ini_GetFloat(szParse[], szValueName[], & Float: iValue) {

	new
		iPos = strfind(szParse, "=", false);

	if(strcmp(szParse, szValueName, false, iPos) == 0) {
		iValue = floatstr(szParse[iPos + 1]);
		return 1;
	}
	return 0;
}

stock ini_GetString(szParse[], szValueName[], szDest[], iLength = sizeof(szDest)) {

	new
		iPos = strfind(szParse, "=", false);

	if(strcmp(szParse, szValueName, false, iPos) == 0) {
		strcat(szDest, szParse[iPos + 1], iLength);
		return 1;
	}
	return 0;
}

stock Log(sz_fileName[], sz_input[]) {

	new
		sz_logEntry[180],
		#if defined _LINUX
		File: logfile,
		#endif
		i_dateTime[2][3];

	gettime(i_dateTime[0][0], i_dateTime[0][1], i_dateTime[0][2]);
	getdate(i_dateTime[1][0], i_dateTime[1][1], i_dateTime[1][2]);

	format(sz_logEntry, sizeof(sz_logEntry), "[%i/%i/%i - %i:%02i:%02i] %s\r\n", i_dateTime[1][0], i_dateTime[1][1], i_dateTime[1][2], i_dateTime[0][0], i_dateTime[0][1], i_dateTime[0][2], sz_input);
	if(logfile) fclose(logfile);
	if(!fexist(sz_fileName)) logfile = fopen(sz_fileName, io_write);
	else logfile = fopen(sz_fileName, io_append);
	if(logfile)
	{
		fwrite(logfile, sz_logEntry);
		fclose(logfile);
	}
	return 1;
}

stock LoadElevatorStuff() {

	if(!fexist("elevator.ini")) return 1;

	new
		szFileStr[64],
		iIndex,
		File: iFileHandle = fopen("elevator.ini", io_read);

	while(iIndex < 20 && fread(iFileHandle, szFileStr)) {
		sscanf(szFileStr, "p<|>s[24]s[24]", LAElevatorFloorData[0][iIndex], LAElevatorFloorData[1][iIndex]);
		StripNL(LAElevatorFloorData[1][iIndex]);
	 	iIndex++;
	}
	printf("[LoadElevatorStuff] %i floors loaded.", iIndex);
	return fclose(iFileHandle);
}

stock SaveElevatorStuff() {

	new
		File: iFileHandle = fopen("elevator.ini", io_write);

	for(new iIndex; iIndex < 20; ++iIndex) {
		fwrite(iFileHandle, LAElevatorFloorData[0][iIndex]);
		fputchar(iFileHandle, '|', false);
		fwrite(iFileHandle, LAElevatorFloorData[1][iIndex]);
		fwrite(iFileHandle, "\r\n");
	}
	return fclose(iFileHandle);
}

stock DealerBuy(playerid, playervehicleid, modelid, Float: x, Float: y, Float: z, Float: angle, color1, color2, price, VW, Int,dlid)
{
	if(PlayerVehicleInfo[playerid][playervehicleid][pvId] == INVALID_PLAYER_VEHICLE_ID)
	{

 		VehicleSpawned[playerid]++;
	    PlayerCars++;
		PlayerVehicleInfo[playerid][playervehicleid][pvModelId] = modelid;
		PlayerVehicleInfo[playerid][playervehicleid][pvOldBuy] = 1;
		PlayerVehicleInfo[playerid][playervehicleid][pvPosX] = x;
		PlayerVehicleInfo[playerid][playervehicleid][pvPosY] = y;
		PlayerVehicleInfo[playerid][playervehicleid][pvPosZ] = z;
		PlayerVehicleInfo[playerid][playervehicleid][pvPosAngle] = angle;
		PlayerVehicleInfo[playerid][playervehicleid][pvColor1] = color1;
		PlayerVehicleInfo[playerid][playervehicleid][pvColor2] = color2;
		PlayerVehicleInfo[playerid][playervehicleid][pvPark] = 1;
		PlayerVehicleInfo[playerid][playervehicleid][pvPrice] = price;
		for(new w = 0; w < 3; w++)
	    {
	    	PlayerVehicleInfo[playerid][playervehicleid][pvWeapons][w] = 0;
		}
		for(new j = 0; j < 3; j++)
		{
			PlayerVehicleInfo[playerid][playervehicleid][pvAmmos][j] = 0;
		}
		PlayerVehicleInfo[playerid][playervehicleid][pvWepUpgrade] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvImpounded] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvVW] = VW;
		PlayerVehicleInfo[playerid][playervehicleid][pvInt] = Int;
		PlayerVehicleInfo[playerid][playervehicleid][pvTicket] = 0;
        PlayerVehicleInfo[playerid][playervehicleid][pvWeapons][0] = 0;
        PlayerVehicleInfo[playerid][playervehicleid][pvWeapons][1] = 0;
        PlayerVehicleInfo[playerid][playervehicleid][pvWeapons][2] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvAmmos][0] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvAmmos][1] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvAmmos][2] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvPlate] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvLock] = 1;

		SendClientMessageEx(playerid, COLOR_BASIC, "HUONG DAN: Su dung /veh pvlock de khoa/mo phuong tien cua ban.");
        PlayerVehicleInfo[playerid][playervehicleid][pvLocked] = 0;
		for(new m = 0; m < MAX_MODS; m++)
	    {
	    	PlayerVehicleInfo[playerid][playervehicleid][pvMods][m] = 0;
		}
		new carcreated = CreateVehicle(modelid,x,y,z,angle,color1,color2,-1);
		SetVehicleVirtualWorld(carcreated, PlayerVehicleInfo[playerid][playervehicleid][pvVW]);
  		LinkVehicleToInterior(carcreated, PlayerVehicleInfo[playerid][playervehicleid][pvInt]);
		Vehicle_ResetData(carcreated);
		PlayerVehicleInfo[playerid][playervehicleid][pvId] = carcreated;
		PlayerVehicleInfo[playerid][playervehicleid][pvSpawned] = 1;
		PlayerVehicleInfo[playerid][playervehicleid][pvFuel] = 100.0;
		//SetVehicleNumberPlate(carcreated, PlayerVehicleInfo[playerid][playervehicleid][pvNumberPlate]);
		SetDealerPlayerBuy(playerid,playervehicleid,dlid);

		new string[128];
        format(string, sizeof(string), "INSERT INTO `vehicles` (`sqlID`) VALUES ('%d')", GetPlayerSQLId(playerid));
		mysql_function_query(MainPipeline, string, true, "OnQueryCreateVehicle", "ii", playerid, playervehicleid);

		return carcreated;
	}
	return INVALID_PLAYER_VEHICLE_ID;
}
stock CreatePlayerVehicle(playerid, playervehicleid, modelid, Float: x, Float: y, Float: z, Float: angle, color1, color2, price, VW, Int)
{
	if(PlayerVehicleInfo[playerid][playervehicleid][pvId] == INVALID_PLAYER_VEHICLE_ID)
	{

 		VehicleSpawned[playerid]++;
	    PlayerCars++;
		PlayerVehicleInfo[playerid][playervehicleid][pvModelId] = modelid;
		PlayerVehicleInfo[playerid][playervehicleid][pvPosX] = x;
		PlayerVehicleInfo[playerid][playervehicleid][pvPosY] = y;
		PlayerVehicleInfo[playerid][playervehicleid][pvPosZ] = z;
		PlayerVehicleInfo[playerid][playervehicleid][pvPosAngle] = angle;
		PlayerVehicleInfo[playerid][playervehicleid][pvColor1] = color1;
		PlayerVehicleInfo[playerid][playervehicleid][pvColor2] = color2;
		PlayerVehicleInfo[playerid][playervehicleid][pvPark] = 1;
		PlayerVehicleInfo[playerid][playervehicleid][pvPrice] = price;
		for(new w = 0; w < 3; w++)
	    {
	    	PlayerVehicleInfo[playerid][playervehicleid][pvWeapons][w] = 0;
		}
		for(new j = 0; j < 3; j++)
		{
			PlayerVehicleInfo[playerid][playervehicleid][pvAmmos][j] = 0;
		}
		PlayerVehicleInfo[playerid][playervehicleid][pvWepUpgrade] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvImpounded] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvOldBuy] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvVW] = VW;
		PlayerVehicleInfo[playerid][playervehicleid][pvInt] = Int;
		PlayerVehicleInfo[playerid][playervehicleid][pvTicket] = 0;
        PlayerVehicleInfo[playerid][playervehicleid][pvWeapons][0] = 0;
        PlayerVehicleInfo[playerid][playervehicleid][pvWeapons][1] = 0;
        PlayerVehicleInfo[playerid][playervehicleid][pvWeapons][2] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvAmmos][0] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvAmmos][1] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvAmmos][2] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvPlate] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvLock] = 1;

		SendClientMessageEx(playerid, COLOR_BASIC, "HUONG DAN: Su dung /veh pvlock de khoa/mo phuong tien cua ban.");
        PlayerVehicleInfo[playerid][playervehicleid][pvLocked] = 0;
		for(new m = 0; m < MAX_MODS; m++)
	    {
	    	PlayerVehicleInfo[playerid][playervehicleid][pvMods][m] = 0;
		}
		new carcreated = CreateVehicle(modelid,x,y,z,angle,color1,color2,-1);
		SetVehicleVirtualWorld(carcreated, PlayerVehicleInfo[playerid][playervehicleid][pvVW]);
  		LinkVehicleToInterior(carcreated, PlayerVehicleInfo[playerid][playervehicleid][pvInt]);
		Vehicle_ResetData(carcreated);
		PlayerVehicleInfo[playerid][playervehicleid][pvId] = carcreated;
		PlayerVehicleInfo[playerid][playervehicleid][pvSpawned] = 1;
		PlayerVehicleInfo[playerid][playervehicleid][pvFuel] = 100.0;
		//SetVehicleNumberPlate(carcreated, PlayerVehicleInfo[playerid][playervehicleid][pvNumberPlate]);

		new string[128];
        format(string, sizeof(string), "INSERT INTO `vehicles` (`sqlID`) VALUES ('%d')", GetPlayerSQLId(playerid));
		mysql_function_query(MainPipeline, string, true, "OnQueryCreateVehicle", "ii", playerid, playervehicleid);

		return carcreated;
	}
	return INVALID_PLAYER_VEHICLE_ID;
}

stock SetPlayerWeapons(playerid)
{
    if(GetPVarInt(playerid, "IsInArena") >= 0) { return 1; }
    ResetPlayerWeapons(playerid);
    {
        if(PlayerInfo[playerid][pGuns][0] > 0 && PlayerInfo[playerid][pAGuns][0] == 0)
        {
            GivePlayerValidWeapon(playerid, PlayerInfo[playerid][pGuns][0], 60000);
        }
        if(PlayerInfo[playerid][pGuns][1] > 0 && PlayerInfo[playerid][pAGuns][1] == 0)
        {
            GivePlayerValidWeapon(playerid, PlayerInfo[playerid][pGuns][1], 60000);
        }
        if(PlayerInfo[playerid][pGuns][2] > 0 && PlayerInfo[playerid][pAGuns][2] == 0 && PlayerInfo[playerid][pAmmo][1] > 0)
        {
            GivePlayerValidWeapon(playerid, PlayerInfo[playerid][pGuns][2], PlayerInfo[playerid][pAmmo][1]);
        }
        if(PlayerInfo[playerid][pGuns][3] > 0 && PlayerInfo[playerid][pAGuns][3] == 0 && PlayerInfo[playerid][pAmmo][2] > 0)
        {
            GivePlayerValidWeapon(playerid, PlayerInfo[playerid][pGuns][3], PlayerInfo[playerid][pAmmo][2]);
        }
        if(PlayerInfo[playerid][pGuns][4] > 0 && PlayerInfo[playerid][pAGuns][4] == 0 && PlayerInfo[playerid][pAmmo][3] > 0)
        {
            GivePlayerValidWeapon(playerid, PlayerInfo[playerid][pGuns][4], PlayerInfo[playerid][pAmmo][3]);
        }
        if(PlayerInfo[playerid][pGuns][5] > 0 && PlayerInfo[playerid][pAGuns][5] == 0 && PlayerInfo[playerid][pAmmo][4] > 0)
        {
            GivePlayerValidWeapon(playerid, PlayerInfo[playerid][pGuns][5], PlayerInfo[playerid][pAmmo][4]);
        }
        if(PlayerInfo[playerid][pGuns][6] > 0 && PlayerInfo[playerid][pAGuns][6] == 0 && PlayerInfo[playerid][pAmmo][5] > 0)
        {
            GivePlayerValidWeapon(playerid, PlayerInfo[playerid][pGuns][6], PlayerInfo[playerid][pAmmo][5]);
        }
        if(PlayerInfo[playerid][pGuns][7] > 0 && PlayerInfo[playerid][pAGuns][7] == 0 && PlayerInfo[playerid][pAmmo][6] > 0)
        {
            GivePlayerValidWeapon(playerid, PlayerInfo[playerid][pGuns][7], PlayerInfo[playerid][pAmmo][6]);
        }
        if(PlayerInfo[playerid][pGuns][8] > 0 && PlayerInfo[playerid][pAGuns][8] == 0 && PlayerInfo[playerid][pAmmo][7] > 0)
        {
            GivePlayerValidWeapon(playerid, PlayerInfo[playerid][pGuns][8], PlayerInfo[playerid][pAmmo][7]);
        }
        if(PlayerInfo[playerid][pGuns][9] > 0 && PlayerInfo[playerid][pAGuns][9] == 0 && PlayerInfo[playerid][pAmmo][8] > 0)
        {
            GivePlayerValidWeapon(playerid, PlayerInfo[playerid][pGuns][9], PlayerInfo[playerid][pAmmo][8]);
        }
        if(PlayerInfo[playerid][pGuns][10] > 0 && PlayerInfo[playerid][pAGuns][10] == 0)
        {
            GivePlayerValidWeapon(playerid, PlayerInfo[playerid][pGuns][10], 60000);
        }
        if(PlayerInfo[playerid][pGuns][11] > 0 && PlayerInfo[playerid][pAGuns][11] == 0)
        {
            GivePlayerValidWeapon(playerid, PlayerInfo[playerid][pGuns][11], 60000);
        }
    }
    return 1;
}

stock SetPlayerWeaponsEx(playerid)
{
    ResetPlayerWeapons(playerid);
    {
        if(PlayerInfo[playerid][pGuns][0] > 0 && PlayerInfo[playerid][pAGuns][0] == 0)
        {
            GivePlayerValidWeapon(playerid, PlayerInfo[playerid][pGuns][0], 60000);
        }
        if(PlayerInfo[playerid][pGuns][1] > 0 && PlayerInfo[playerid][pAGuns][1] == 0)
        {
            GivePlayerValidWeapon(playerid, PlayerInfo[playerid][pGuns][1], 60000);
        }
        if(PlayerInfo[playerid][pGuns][2] > 0 && PlayerInfo[playerid][pAGuns][2] == 0 && PlayerInfo[playerid][pAmmo][1] > 0)
        {
            GivePlayerValidWeapon(playerid, PlayerInfo[playerid][pGuns][2], PlayerInfo[playerid][pAmmo][1]);
        }
        if(PlayerInfo[playerid][pGuns][3] > 0 && PlayerInfo[playerid][pAGuns][3] == 0 && PlayerInfo[playerid][pAmmo][2] > 0)
        {
            GivePlayerValidWeapon(playerid, PlayerInfo[playerid][pGuns][3], PlayerInfo[playerid][pAmmo][2]);
        }
        if(PlayerInfo[playerid][pGuns][4] > 0 && PlayerInfo[playerid][pAGuns][4] == 0 && PlayerInfo[playerid][pAmmo][3] > 0)
        {
            GivePlayerValidWeapon(playerid, PlayerInfo[playerid][pGuns][4], PlayerInfo[playerid][pAmmo][3]);
        }
        if(PlayerInfo[playerid][pGuns][5] > 0 && PlayerInfo[playerid][pAGuns][5] == 0 && PlayerInfo[playerid][pAmmo][4] > 0)
        {
            GivePlayerValidWeapon(playerid, PlayerInfo[playerid][pGuns][5], PlayerInfo[playerid][pAmmo][4]);
        }
        if(PlayerInfo[playerid][pGuns][6] > 0 && PlayerInfo[playerid][pAGuns][6] == 0 && PlayerInfo[playerid][pAmmo][5] > 0)
        {
            GivePlayerValidWeapon(playerid, PlayerInfo[playerid][pGuns][6], PlayerInfo[playerid][pAmmo][5]);
        }
        if(PlayerInfo[playerid][pGuns][7] > 0 && PlayerInfo[playerid][pAGuns][7] == 0 && PlayerInfo[playerid][pAmmo][6] > 0)
        {
            GivePlayerValidWeapon(playerid, PlayerInfo[playerid][pGuns][7], PlayerInfo[playerid][pAmmo][6]);
        }
        if(PlayerInfo[playerid][pGuns][8] > 0 && PlayerInfo[playerid][pAGuns][8] == 0 && PlayerInfo[playerid][pAmmo][7] > 0)
        {
            GivePlayerValidWeapon(playerid, PlayerInfo[playerid][pGuns][8], PlayerInfo[playerid][pAmmo][7]);
        }
        if(PlayerInfo[playerid][pGuns][9] > 0 && PlayerInfo[playerid][pAGuns][9] == 0 && PlayerInfo[playerid][pAmmo][8] > 0)
        {
            GivePlayerValidWeapon(playerid, PlayerInfo[playerid][pGuns][9], PlayerInfo[playerid][pAmmo][8]);
        }
        if(PlayerInfo[playerid][pGuns][10] > 0 && PlayerInfo[playerid][pAGuns][10] == 0)
        {
            GivePlayerValidWeapon(playerid, PlayerInfo[playerid][pGuns][10], 60000);
        }
        if(PlayerInfo[playerid][pGuns][11] > 0 && PlayerInfo[playerid][pAGuns][11] == 0)
        {
            GivePlayerValidWeapon(playerid, PlayerInfo[playerid][pGuns][11], 60000);
        }
    }
    SetPlayerArmedWeapon(playerid, GetPVarInt(playerid, "LastWeapon"));
}

stock IsPlayerInRangeOfActor(playerid, actorid, Float:radius = 5.0)
{
        new Float:x,
            Float:y,
            Float:z;

        if (GetActorPos(actorid, x, y, z))
        {
            return IsPlayerInRangeOfPoint(playerid, radius, x, y, z);
        }
        return 0;
}
stock ShowStats(playerid,targetid)
{
	if(IsPlayerConnected(targetid))
	{
		new resultline[1024], header[65], org[128], employer[GROUP_MAX_NAME_LEN], rank[GROUP_MAX_RANK_LEN], division[GROUP_MAX_DIV_LEN];
		new sext[16], std[20], nation[24], biz[128];
		if(PlayerInfo[targetid][pSex] == 1) { sext = "Male"; } else { sext = "Female"; }
		switch(GetPVarInt(targetid, "STD"))
		{
		    case 1: std = "Chlamydia";
		    case 2: std = "Gonorrhea";
		    case 3: std = "Syphilis";
		    default: std = "None";
		}
		if(PlayerInfo[targetid][pMember] != INVALID_GROUP_ID)
		{
			GetPlayerGroupInfo(targetid, rank, division, employer);
			format(org, sizeof(org), "Faction: %s (%d)\nRank: %s (%d)\nDivision: %s (%d)\n", employer, PlayerInfo[targetid][pMember], rank, PlayerInfo[targetid][pRank], division, PlayerInfo[targetid][pDivision]);
		}
		else if(PlayerInfo[targetid][pFMember] < INVALID_FAMILY_ID)
		{
			if(0 <= PlayerInfo[targetid][pDivision] < 5) format(division, sizeof(division), "%s", FamilyDivisionInfo[PlayerInfo[targetid][pFMember]][PlayerInfo[targetid][pDivision]]);
			else division = "None";
			format(org, sizeof(org), "Family: %s (%d)\nRank: %s (%d)\nDivision: %s (%d)\n", FamilyInfo[PlayerInfo[targetid][pFMember]][FamilyName], PlayerInfo[targetid][pFMember], FamilyRankInfo[PlayerInfo[targetid][pFMember]][PlayerInfo[targetid][pRank]], PlayerInfo[targetid][pRank], division, PlayerInfo[targetid][pDivision]);
		}
		else format(org, sizeof(org), "");
		if(PlayerInfo[targetid][pBusiness] != INVALID_BUSINESS_ID) format(biz, sizeof(biz), "Business: %s (%d)\nRank: %s (%d)\n", Businesses[PlayerInfo[targetid][pBusiness]][bName], PlayerInfo[targetid][pBusiness], GetBusinessRankName(PlayerInfo[targetid][pBusinessRank]), PlayerInfo[targetid][pBusinessRank]);
		else format(biz, sizeof(biz), "");
		switch(PlayerInfo[targetid][pNation])
		{
			case 0: nation = "San Andreas";
			case 1: nation = "Tierra Robada";
		}
		new insur[20];
		switch(PlayerInfo[targetid][pInsurance])
		{
			case 1: insur = "County General";
			case 2: insur = "All Saints";
			case 3: insur = "Montgomery";
			case 4: insur = "Fort Carson";
			case 5: insur = "San Fierro";
			case 6: insur = "Club VIP";
			case 7: insur = "Home Care";
			case 9: insur = "El Quebrados";
			case 10: insur = "SAAS Base Hospital";
			case 11: insur = "Las Venturas";
			case 12: insur = "Famed Room";
			case 13: insur = "DeMorgan";
			case 14: insur = "Bayside";
			default: insur = "None";
		}
		new staffrank[64];
		if(PlayerInfo[targetid][pHelper] > 0 || PlayerInfo[targetid][pAdmin] == 1 || (PlayerInfo[targetid][pAdmin] > 1 && PlayerInfo[playerid][pAdmin] <= PlayerInfo[targetid][pAdmin])) format(staffrank, sizeof(staffrank), "%s", GetStaffRank(targetid));
		else staffrank = "";
		new drank[64];
		if(PlayerInfo[targetid][pDonateRank] > 0)
		{
			switch(PlayerInfo[targetid][pDonateRank])
			{
				case 1: drank = "{800080}Bronze VIP{FFFFFF}\n";
				case 2: drank = "{800080}Silver VIP{FFFFFF}\n";
				case 3: drank = "{FFD700}Gold VIP{FFFFFF}\n";
				case 4: drank = "{E5E4E2}Platinum VIP{FFFFFF}\n";
				case 5: drank = "{800080}VIP Moderator{FFFFFF}\n";
			}
		}
		new famedrank[64];
		if(PlayerInfo[targetid][pFamed] > 0)
		{
			switch(PlayerInfo[targetid][pFamed])
			{
				case 1: famedrank = "{228B22}Old-School{FFFFFF}\n";
				case 2: famedrank = "{FF7F00}Chartered Old-School{FFFFFF}\n";
				case 3: famedrank = "{ADFF2F}Famed{FFFFFF}\n";
				case 4: famedrank = "{8F00FF}Famed Commissioner{FFFFFF}\n";
				case 5: famedrank = "{8F00FF}Famed Moderator{FFFFFF}\n";
				case 6: famedrank = "{8F00FF}Famed Vice-Chairman{FFFFFF}\n";
				case 7: famedrank = "{8F00FF}Famed Chairman{FFFFFF}\n";
			}
		}
		if(PlayerInfo[targetid][pMarriedID] == -1) format(PlayerInfo[targetid][pMarriedName], MAX_PLAYER_NAME, "Nobody");
		new nxtlevel = PlayerInfo[targetid][pLevel]+1;
		//new expamount = nxtlevel*4;
		new costlevel = nxtlevel*100;
		new exp = ((50 * (PlayerInfo[targetid][pLevel]) * (PlayerInfo[targetid][pLevel]) * (PlayerInfo[targetid][pLevel]) - 150 * (PlayerInfo[targetid][pLevel]) * (PlayerInfo[targetid][pLevel]) + 600 * (PlayerInfo[targetid][pLevel])) / 5) - PlayerInfo[playerid][pXP];
		new Float:health, Float:armor;
		GetPlayerHealth(targetid, health);
		GetPlayerArmour(targetid, armor);
		new Float:px,Float:py,Float:pz;
		GetPlayerPos(targetid, px, py, pz);
		new zone[MAX_ZONE_NAME];
		GetPlayer3DZone(targetid, zone, sizeof(zone));

  		SetPVarInt(playerid, "ShowStats", targetid);
		format(header, sizeof(header), "Thong tin cua %s", GetPlayerNameEx(targetid));
		format(resultline, sizeof(resultline),"%s\n\
		%s\
		%s\
		{FFFFFF}Cap do: %d\n\
		Gioi tinh: %s\n\
		Ngay sinh: %s\n\
		Vi tri hien tai: %s (%0.2f, %0.2f, %0.2f)\n\
		Da ket hon: %s\n\
		Mau: %.1f\n\
		Giap: %.1f\n\
		Gio da choi: %s\n\
		Diem nang cap: %s\n\
		XP can thiet de nang cap: %s va $%s)\n\
		Quoc tich: %s\n\
		%s\
		%s\
		Cong viec: %s (Cap do: %d)\n\
		Cong viec 2: %s (Cap do: %d)\n\
		Bao hiem: %s",
		staffrank,
		famedrank,
		drank,
		PlayerInfo[targetid][pLevel],
		sext,
		PlayerInfo[targetid][pBirthDate],
		zone, px, py, pz,
		PlayerInfo[targetid][pMarriedName],
		health,
		armor,
		number_format(PlayerInfo[targetid][pConnectHours]),
		number_format(PlayerInfo[targetid][gPupgrade]),
		number_format(CheckXP(exp)),
		number_format(costlevel),
		nation,
		org,
		biz,
		GetJobName(PlayerInfo[targetid][pJob]),
		GetJobLevel(targetid, PlayerInfo[targetid][pJob]),
		GetJobName(PlayerInfo[targetid][pJob2]),
		GetJobLevel(targetid, PlayerInfo[targetid][pJob2]),
		insur);
		ShowPlayerDialog(playerid, DISPLAY_STATS, DIALOG_STYLE_MSGBOX, header, resultline, "Trang Sau", "Dong lai");
	}
	return 1;
}



stock ShowInventory(playerid,targetid)
{
	if(IsPlayerConnected(targetid))
	{
		new resultline[1024], header[64], pnumber[20], pvtstring[128];
		if(PlayerInfo[targetid][pPnumber] == 0) pnumber = "None"; else format(pnumber, sizeof(pnumber), "%d", PlayerInfo[targetid][pPnumber]);
		if (PlayerInfo[playerid][pAdmin] >= 2)
		{
			format(pvtstring, sizeof(pvtstring), "Gift Box Tokens: %s\n", number_format(PlayerInfo[targetid][pGoldBoxTokens]));
		}

		new totalwealth;
		totalwealth = PlayerInfo[targetid][pAccount] + GetPlayerCash(targetid);
		if(PlayerInfo[targetid][pPhousekey] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[targetid][pPhousekey]][hOwnerID] == GetPlayerSQLId(targetid)) totalwealth += HouseInfo[PlayerInfo[targetid][pPhousekey]][hSafeMoney];
		if(PlayerInfo[targetid][pPhousekey2] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[targetid][pPhousekey2]][hOwnerID] == GetPlayerSQLId(targetid)) totalwealth += HouseInfo[PlayerInfo[targetid][pPhousekey2]][hSafeMoney];

		SetPVarInt(playerid, "ShowInventory", targetid);
		format(header, sizeof(header), "Tui do cua %s", GetPlayerNameEx(targetid));
		format(resultline, sizeof(resultline),"Tong tien: $%s\n\
		Tien: $%s\n\
		Tien ngan hang: $%s\n\
		So dien thoai: %s\n\
		Tan so Radio: %dkhz\n\
		VIP Tokens: %s\n\
		Paintball Tokens: %s\n\
		EXP Tokens: %s\n\
		EXP Gio choi: %s\n\
		The su kien: %s\n\
		Vat lieu: %s\n\
		Crack: %s\n\
		Pot: %s\n\
		Heroin: %s\n\
		Crates: %s\n\
		Hat Giong Can sa: %s\n\
		Raw Opium: %s\n\
		Ong tiem: %s\n\
		Giay: %s\n\
		Day thung: %s\n\
		Sprunk Cans: %s\n\
		Spraycans: %s\n\
		Tua vit: %s\n\
		SMSLog: %d\n\
		Dong ho: %d\n\
		Giam sat: %d\n\
		Lop xe: %d\n\
		%s",
		number_format(totalwealth),
		number_format(GetPlayerCash(targetid)),
		number_format(PlayerInfo[targetid][pAccount]),
		pnumber,
		PlayerInfo[targetid][pRadioFreq],
		number_format(PlayerInfo[targetid][pTokens]),
		number_format(PlayerInfo[targetid][pPaintTokens]),
		number_format(PlayerInfo[targetid][pEXPToken]),
		number_format(PlayerInfo[targetid][pDoubleEXP]),
		number_format(PlayerInfo[targetid][pTrickortreat]),
		number_format(PlayerInfo[targetid][pMats]),
		number_format(PlayerInfo[targetid][pCrack]),
		number_format(PlayerInfo[targetid][pPot]),
		number_format(PlayerInfo[targetid][pHeroin]),
		number_format(PlayerInfo[targetid][pCrates]),
		number_format(PlayerInfo[targetid][pWSeeds]),
		number_format(PlayerInfo[targetid][pRawOpium]),
		number_format(PlayerInfo[targetid][pSyringes]),
		number_format(PlayerInfo[targetid][pPaper]),
		number_format(PlayerInfo[targetid][pRope]),
		number_format(PlayerInfo[targetid][pSprunk]),
		number_format(PlayerInfo[targetid][pSpraycan]),
		number_format(PlayerInfo[targetid][pScrewdriver]),
		PlayerInfo[targetid][pSmslog],
		PlayerInfo[targetid][pWristwatch],
		PlayerInfo[targetid][pSurveillance],
		PlayerInfo[targetid][pTire],
		pvtstring);
		ShowPlayerDialog(playerid, DISPLAY_INV, DIALOG_STYLE_MSGBOX, header, resultline, "Trang tiep", "Dong lai");
	}
	return 1;
}

stock SetPlayerToTeamColor(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		if(PlayerInfo[playerid][pWantedLevel] > 0) {
			SetPlayerWantedLevel(playerid, PlayerInfo[playerid][pWantedLevel]);
		}
	    if(GetPVarInt(playerid, "IsInArena") >= 0)
	    {
	        new arenaid = GetPVarInt(playerid, "IsInArena");
	        if(PaintBallArena[arenaid][pbGameType] == 2 || PaintBallArena[arenaid][pbGameType] == 3 || PaintBallArena[arenaid][pbGameType] == 5) switch(PlayerInfo[playerid][pPaintTeam]) {
				case 1: SetPlayerColor(playerid, PAINTBALL_TEAM_RED);
				case 2: SetPlayerColor(playerid, PAINTBALL_TEAM_BLUE);
	        }
	    }
	    #if defined zombiemode
   		if(GetPVarType(playerid, "pZombieBit"))
    	{
	    	SetPlayerColor(playerid, 0xFFCC0000);
  	   		return 1;
		}
		if(GetPVarType(playerid, "pIsZombie"))
		{
  			SetPlayerColor(playerid, 0x0BC43600);
	    	return 1;
		}
 		if(GetPVarType(playerid, "pEventZombie"))
		{
			SetPlayerColor(playerid, 0x0BC43600);
			return 1;
		}
		#endif
	    if(PlayerInfo[playerid][pJailTime] > 0) {
            if(strfind(PlayerInfo[playerid][pPrisonReason], "[IC]", true) != -1 || strfind(PlayerInfo[playerid][pPrisonReason], "[ISOLATE]", true) != -1) {
				SetPlayerColor(playerid,TEAM_ORANGE_COLOR);
			}
			else if(strfind(PlayerInfo[playerid][pPrisonReason], "[OOC]", true) != -1) {
    			SetPlayerColor(playerid,TEAM_APRISON_COLOR);
			}
		}
		else if(PlayerInfo[playerid][pBeingSentenced] != 0)
		{
			SetPlayerColor(playerid, SHITTY_JUDICIALSHITHOTCH);
		}
		else if((PlayerInfo[playerid][pJob] == 17 || PlayerInfo[playerid][pJob2] == 17 || PlayerInfo[playerid][pTaxiLicense] == 1) && TransportDuty[playerid] != 0) {
			SetPlayerColor(playerid,TEAM_TAXI_COLOR);
		}
	    else if(0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS && PlayerInfo[playerid][pDuty]) {
			return SetPlayerColor(playerid, arrGroupData[PlayerInfo[playerid][pMember]][g_hDutyColour] * 256);
		}
		else if(GetPVarType(playerid, "HitmanBadgeColour") && IsAHitman(playerid))
		{
		    SetPlayerColor(playerid, GetPVarInt(playerid, "HitmanBadgeColour"));
		}
		else {
			SetPlayerColor(playerid,TEAM_HIT_COLOR);
		}
	}
	return 1;
}

stock strfindcount(substring[], string[], bool:ignorecase = false, startpos = 0)
{
	new ncount, start = strfind(string, substring, ignorecase, startpos);
	while(start >- 1)
	{
		start = strfind(string, substring, ignorecase, start + strlen(substring));
		ncount++;
	}
	return ncount;
}

stock IsInvalidSkin(skin) {
	if(!(0 <= skin <= 30000)) return 1;
    return 0;
}

stock IsKeyJustDown(key, newkeys, oldkeys)
{
	if((newkeys & key) && !(oldkeys & key)) return 1;
	return 0;
}

stock ResetPlayerWeaponsEx( playerid )
{
	ResetPlayerWeapons(playerid);
	PlayerInfo[playerid][pGuns][ 0 ] = 0;
	PlayerInfo[playerid][pGuns][ 1 ] = 0;
	PlayerInfo[playerid][pGuns][ 2 ] = 0;
	PlayerInfo[playerid][pGuns][ 3 ] = 0;
	PlayerInfo[playerid][pGuns][ 4 ] = 0;
	PlayerInfo[playerid][pGuns][ 5 ] = 0;
	PlayerInfo[playerid][pGuns][ 6 ] = 0;
	PlayerInfo[playerid][pGuns][ 7 ] = 0;
	PlayerInfo[playerid][pGuns][ 8 ] = 0;
	PlayerInfo[playerid][pGuns][ 9 ] = 0;
	PlayerInfo[playerid][pGuns][ 10 ] = 0;
	PlayerInfo[playerid][pGuns][ 11 ] = 0;
	PlayerInfo[playerid][pAGuns][ 0 ] = 0;
	PlayerInfo[playerid][pAGuns][ 1 ] = 0;
	PlayerInfo[playerid][pAGuns][ 2 ] = 0;
	PlayerInfo[playerid][pAGuns][ 3 ] = 0;
	PlayerInfo[playerid][pAGuns][ 4 ] = 0;
	PlayerInfo[playerid][pAGuns][ 5 ] = 0;
	PlayerInfo[playerid][pAGuns][ 6 ] = 0;
	PlayerInfo[playerid][pAGuns][ 7 ] = 0;
	PlayerInfo[playerid][pAGuns][ 8 ] = 0;
	PlayerInfo[playerid][pAGuns][ 9 ] = 0;
	PlayerInfo[playerid][pAGuns][ 10 ] = 0;
	PlayerInfo[playerid][pAGuns][ 11 ] = 0;
	return 1;
}


stock ShowVehicleHUDForPlayer(playerid)
{
	PlayerTextDrawShow(playerid, _vhudTextFuel[playerid]);
	PlayerTextDrawShow(playerid, _vhudTextSpeed[playerid]);
	PlayerTextDrawShow(playerid, _vhudSeatBelt[playerid]);
	PlayerTextDrawShow(playerid, _vhudLights[playerid]);
	_vhudVisible[playerid] = 1;
}


stock HideVehicleHUDForPlayer(playerid)
{
	PlayerTextDrawHide(playerid, _vhudTextFuel[playerid]);
	PlayerTextDrawHide(playerid, _vhudTextSpeed[playerid]);
	PlayerTextDrawHide(playerid, _vhudSeatBelt[playerid]);
	PlayerTextDrawHide(playerid, _vhudLights[playerid]);
	_vhudVisible[playerid] = 0;
}

stock ShowBackupActiveForPlayer(playerid)
{
	PlayerTextDrawShow(playerid, BackupText[playerid]);
}

stock HideBackupActiveForPlayer(playerid)
{
	PlayerTextDrawHide(playerid, BackupText[playerid]);
}

/*stock UpdateVehicleHUDForPlayer(p, fuel)
{
	new str[128], vehicleid = GetPlayerVehicleID(p);
	new engine,lights,alarm,doors,bonnet,boot,objective;
	//fCurrentSpeed = player_get_speed(p);
	GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);

	if (IsVIPcar(vehicleid) || IsAdminSpawnedVehicle(vehicleid) || IsFamedVeh(vehicleid) || GetVehicleModel(vehicleid) == 481 || GetVehicleModel(vehicleid) == 509 || GetVehicleModel(vehicleid) == 510)
		format(str, sizeof(str), "~b~Xang: ~g~100");
	else
		format(str, sizeof(str), "~b~Xang: ~g~%i",fuel);

	PlayerTextDrawSetString(p, _vhudTextFuel[p], str);

	format(str, sizeof(str), "~b~MPH: ~g~%.2f/h", player_get_speed(p));
	PlayerTextDrawSetString(p, _vhudTextSpeed[p], str);

	if(Seatbelt[p] == 0)
	{
		format(str, sizeof(str), "~b~SB: ~r~Ko");
		PlayerTextDrawSetString(p, _vhudSeatBelt[p], str);
	}
	else {
		format(str, sizeof(str), "~b~SB: ~g~Co");
		PlayerTextDrawSetString(p, _vhudSeatBelt[p], str);
	}
	if(lights != VEHICLE_PARAMS_ON) {
		format(str, sizeof(str), "~b~Den: ~r~Tat");
		PlayerTextDrawSetString(p, _vhudLights[p], str);
	}
	else {
		format(str, sizeof(str), "~b~Den: ~g~Mo");
		PlayerTextDrawSetString(p, _vhudLights[p], str);
	}
}
*/
stock UpdateSpeedCamerasForPlayer(p)
{
	if (!IsPlayerConnected(p) || !IsPlayerInAnyVehicle(p) || GetPlayerState(p) != PLAYER_STATE_DRIVER) return;

	// static speed cameras
	for (new c = 0; c < MAX_SPEEDCAMERAS; c++)
	{
		if (SpeedCameras[c][_scActive] == false) continue;

		if (IsPlayerInRangeOfPoint(p, SpeedCameras[c][_scRange], SpeedCameras[c][_scPosX], SpeedCameras[c][_scPosY], SpeedCameras[c][_scPosZ]))
		{
		    if(PlayerInfo[p][pConnectHours] > 16)
		    {
				new Float:speedLimit = SpeedCameras[c][_scLimit];
				new Float:vehicleSpeed = player_get_speed(p);

				if (vehicleSpeed > speedLimit && PlayerInfo[p][pTicketTime] == 0)
				{
					new vehicleid = GetPlayerVehicleID(p);
					if(!IsAPlane(vehicleid) && !IsAHelicopter(vehicleid) && GetVehicleModel(vehicleid) != 481 && GetVehicleModel(vehicleid) != 509 && GetVehicleModel(vehicleid) != 510)
					{
					    foreach(new i: Player)
						{
	        	        	new v = GetPlayerVehicle(i, vehicleid);
	        	    	    if(v != -1)
							{
								new string[128], Amount = floatround(2*(vehicleSpeed-speedLimit), floatround_round)+2;
      							PlayerVehicleInfo[i][v][pvTicket] += Amount;
      							PlayerInfo[p][pTicketTime] = 60;
								format(string, sizeof(string), "Ban da di qua toc do cho phep trong thanh pho,Xin chuc mung: ban bi mot ve phat $%s", number_format(Amount));
      							SendClientMessageEx(p, COLOR_WHITE, string);
        		                PlayerPlaySound(p, 1132, 0.0, 0.0, 0.0);
        		                PlayerTextDrawShow(p, _vhudFlash[p]);
        	    	            SetTimerEx("TurnOffFlash", 500, 0, "i", p);
        	    	            g_mysql_SaveVehicle(i, v);
							}
						}
					}
			  	}
			}
		}
	}
}

stock UpdateWheelTarget()
{
    gCurrentTargetYAngle += 36.0; // There are 10 carts, so 360 / 10
    if(gCurrentTargetYAngle >= 360.0) {
		gCurrentTargetYAngle = 0.0;
    }
	if(gWheelTransAlternate) gWheelTransAlternate = 0;
	else gWheelTransAlternate = 1;
}

stock ConvertTimeS(seconds)
{
	new string[64];
    if(seconds > 86400)
	{
 		if(floatround((seconds/86400), floatround_floor) > 1) format(string, sizeof(string), "%d ngay", floatround((seconds/86400), floatround_floor));
		else format(string, sizeof(string), "%d ngay", floatround((seconds/86400), floatround_floor));
		seconds=seconds-((floatround((seconds/86400), floatround_floor))*86400);
	}
	if(seconds > 3600)
	{
 		if(floatround((seconds/3600), floatround_floor) > 1) format(string, sizeof(string), "%s, %d gio", string, floatround((seconds/3600), floatround_floor));
   		else format(string, sizeof(string), "%s, %d gio", string, floatround((seconds/3600), floatround_floor));
		seconds=seconds-((floatround((seconds/3600), floatround_floor))*3600);
	}
	if(seconds > 60)
	{
 		if(floatround((seconds/60), floatround_floor) > 1) format(string, sizeof(string), "%s, %d phut", string, floatround((seconds/60), floatround_floor));
   		else format(string, sizeof(string), "%s, %d phut", string, floatround((seconds/60), floatround_floor));
		seconds=seconds-((floatround((seconds/60), floatround_floor))*60);
	}
	if(seconds > 1) format(string, sizeof(string), "%s, %d giay", string, seconds);
	else format(string, sizeof(string), "%s, %d giay", string, seconds);
	return string;
}

stock ConvertTime(cts, &ctm=-1,&cth=-1,&ctd=-1,&ctw=-1,&ctmo=-1,&cty=-1)
{
    //Defines to drastically reduce the code..

    #define PLUR(%0,%1,%2) (%0),((%0) == 1)?((#%1)):((#%2))

    #define CTM_cty 31536000
    #define CTM_ctmo 2628000
    #define CTM_ctw 604800
    #define CTM_ctd 86400
    #define CTM_cth 3600
    #define CTM_ctm 60

    #define CT(%0) %0 = cts / CTM_%0; cts %= CTM_%0


    new strii[128];

    if(cty != -1)
    {
        CT(cty); CT(ctmo); CT(ctw); CT(ctd); CT(cth); CT(ctm);
        format(strii, sizeof(strii), "%d %s, %d %s, %d %s, %d %s, %d %s, %d %s, va %d %s",PLUR(cty,"year","years"),PLUR(ctmo,"month","months"),PLUR(ctw,"week","weeks"),PLUR(ctd,"day","days"),PLUR(cth,"hour","hours"),PLUR(ctm,"minute","minutes"),PLUR(cts,"second","seconds"));
        return strii;
    }
    if(ctmo != -1)
    {
        CT(ctmo); CT(ctw); CT(ctd); CT(cth); CT(ctm);
        format(strii, sizeof(strii), "%d %s, %d %s, %d %s, %d %s, %d %s, va %d %s",PLUR(ctmo,"month","months"),PLUR(ctw,"week","weeks"),PLUR(ctd,"day","days"),PLUR(cth,"hour","hours"),PLUR(ctm,"minute","minutes"),PLUR(cts,"second","seconds"));
        return strii;
    }
    if(ctw != -1)
    {
        CT(ctw); CT(ctd); CT(cth); CT(ctm);
        format(strii, sizeof(strii), "%d %s, %d %s, %d %s, %d %s, va %d %s",PLUR(ctw,"week","weeks"),PLUR(ctd,"day","days"),PLUR(cth,"hour","hours"),PLUR(ctm,"minute","minutes"),PLUR(cts,"second","seconds"));
        return strii;
    }
    if(ctd != -1)
    {
        CT(ctd); CT(cth); CT(ctm);
        format(strii, sizeof(strii), "%d %s, %d %s, %d %s, va %d %s",PLUR(ctd,"day","days"),PLUR(cth,"hour","hours"),PLUR(ctm,"minute","minutes"),PLUR(cts,"second","seconds"));
        return strii;
    }
    if(cth != -1)
    {
        CT(cth); CT(ctm);
        format(strii, sizeof(strii), "%d %s, %d %s, va %d %s",PLUR(cth,"hour","hours"),PLUR(ctm,"minute","minutes"),PLUR(cts,"second","seconds"));
        return strii;
    }
    if(ctm != -1)
    {
        CT(ctm);
        format(strii, sizeof(strii), "%d %s, va %d %s",PLUR(ctm,"minute","minutes"),PLUR(cts,"second","seconds"));
        return strii;
    }
    format(strii, sizeof(strii), "%d %s", PLUR(cts,"second","seconds"));
    return strii;
}

stock IsValidVehicleID(vehicleid)
{
   if(GetVehicleModel(vehicleid)) return 1;
   return 0;
}

stock ExecuteNOPAction(playerid)
{
	new string[128];
	new newcar = GetPlayerVehicleID(playerid);
	if(NOPTrigger[playerid] >= MAX_NOP_WARNINGS) { return 1; }
	NOPTrigger[playerid]++;
	RemovePlayerFromVehicle(playerid);
	new Float:X, Float:Y, Float:Z;
	GetPlayerPos(playerid, X, Y, Z);
	SetPlayerPos(playerid, X, Y, Z+2);
	defer NOPCheck(playerid);
	if(NOPTrigger[playerid] > 1)
	{
		new sec = (NOPTrigger[playerid] * 5000)/1000-1;
		format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s (ID %d) NOP hacking - co gang len mot chiec xe bi han che (model %d) cho %d giay.", GetPlayerNameEx(playerid), playerid, GetVehicleModel(newcar),sec);
		ABroadCast(COLOR_YELLOW, string, 2);
	}
	return 1;
}

stock Random(min, max)
{
    new a = random(max - min) + min;
    return a;
}

stock SendReportToQue(reportfrom, report[], reportlevel, reportpriority)
{
    new bool:breakingloop = false, newid = INVALID_REPORT_ID, string[128];

	for(new i=0;i<MAX_REPORTS;i++)
	{
		if(!breakingloop)
		{
			if(Reports[i][HasBeenUsed] == 0)
			{
				breakingloop = true;
				newid = i;
			}
		}
    }
    if(newid != INVALID_REPORT_ID)
    {
        switch(reportpriority)
       	{
   	    	case 1:
   	    	{
	        	
    		}
 	    	case 2:
  	    	{
        		
			}
   			case 3..4:
 	    	{
       			
    		}
 	    	case 5:
  	    	{
        		
    		}
     	}
     	foreach(new i: Player)
     	{
     	    if(PlayerInfo[i][pAdmin] >= 2 && PlayerInfo[i][pTogReports] == 0 && !GetPVarType(i, "TogReports")) {
     	        format(string, sizeof(string), "%s (ID: %i) | RID: %i | Bao cao: %s | Da gui: 0 phut | Muc do uu tien: %i", GetPlayerNameEx(reportfrom), reportfrom, newid, report, reportpriority);
				SendClientMessageEx(i, COLOR_REPORT, string);
     	    }
     	    else if((reportpriority == 1 || reportpriority == 2) && PlayerInfo[i][pTogReports] == 0 && GetPVarType(i, "TogReports")) {
     	        format(string, sizeof(string), "%s (ID: %i) | RID: %i | Bao cao: %s | Da gui: 0 phut | Muc do uu tien: %i", GetPlayerNameEx(reportfrom), reportfrom, newid, report, reportpriority);
				SendClientMessageEx(i, COLOR_REPORT, string);
     	    }
     	}
     	SetPVarInt(reportfrom, "HasReport", 1);
        if(reportlevel == 2)
		{
        	strmid(Reports[newid][Report], report, 0, strlen(report), 128);
        	Reports[newid][ReportFrom] = reportfrom;
        	Reports[newid][TimeToExpire] = 0;
        	Reports[newid][HasBeenUsed] = 1;
        	Reports[newid][BeingUsed] = 1;
        	Reports[newid][ReportPriority] = reportpriority;
        	Reports[newid][ReportExpireTimer] = SetTimerEx("ReportTimer", 60000, 0, "d", newid);
		}
		else
		{
		    strmid(Reports[newid][Report], report, 0, strlen(report), 128);
        	Reports[newid][ReportFrom] = reportfrom;
        	Reports[newid][TimeToExpire] = 0;
        	Reports[newid][HasBeenUsed] = 1;
        	Reports[newid][BeingUsed] = 1;
        	Reports[newid][ReportPriority] = reportpriority;
        	Reports[newid][ReportExpireTimer] = SetTimerEx("ReportTimer", 60000, 0, "d", newid);
		}
    }
    else
    {
        ClearReports();
        SendReportToQue(reportfrom, report, reportlevel, reportpriority);
    }
}

stock ClearReports()
{
	for(new i=0;i<MAX_REPORTS;i++)
	{
	    if(Reports[i][BeingUsed] == 1) {
			DeletePVar(Reports[i][ReportFrom], "HasReport");
		}
		strmid(Reports[i][Report], "None", 0, 4, 4);
		Reports[i][CheckingReport] = INVALID_PLAYER_ID;
        Reports[i][ReportFrom] = INVALID_PLAYER_ID;
        Reports[i][TimeToExpire] = 0;
        Reports[i][HasBeenUsed] = 0;
        Reports[i][BeingUsed] = 0;
        Reports[i][ReportPriority] = 0;
        Reports[i][ReportLevel] = 0;
	}
	return 1;
}

stock RenderHouseMailbox(h)
{
	DestroyDynamicObject(HouseInfo[h][hMailObjectId]);
	DestroyDynamic3DTextLabel(HouseInfo[h][hMailTextID]);
	if (HouseInfo[h][hMailX] != 0.0)
	{
		HouseInfo[h][hMailObjectId] = CreateDynamicObject((HouseInfo[h][hMailType] == 1) ? 1478 : 3407, HouseInfo[h][hMailX], HouseInfo[h][hMailY], HouseInfo[h][hMailZ], 0, 0, HouseInfo[h][hMailA]);
		new string[10];
		format(string, sizeof(string), "HID: %d",h);
		HouseInfo[h][hMailTextID] = CreateDynamic3DTextLabel(string, 0xFFFFFF88, HouseInfo[h][hMailX], HouseInfo[h][hMailY], HouseInfo[h][hMailZ]+0.5,10.0, .testlos = 1, .streamdistance = 10.0);
	}
}

stock RenderStreetMailbox(id)
{
	DestroyDynamicObject(MailBoxes[id][mbObjectId]);
	DestroyDynamic3DTextLabel(MailBoxes[id][mbTextId]);
	if(MailBoxes[id][mbPosX] != 0.0)
	{
	    new string[128];
		MailBoxes[id][mbObjectId] = CreateDynamicObject(1258, MailBoxes[id][mbPosX], MailBoxes[id][mbPosY], MailBoxes[id][mbPosZ], 0.0, 0.0, MailBoxes[id][mbAngle], MailBoxes[id][mbVW], MailBoxes[id][mbInt], .streamdistance = 100.0);
		format(string,sizeof(string),"Mailbox (ID: %d)\nSu dung /guithu de gui thu.", id);
		MailBoxes[id][mbTextId] = CreateDynamic3DTextLabel(string, COLOR_YELLOW, MailBoxes[id][mbPosX], MailBoxes[id][mbPosY], MailBoxes[id][mbPosZ] + 0.5, 10.0, .worldid = MailBoxes[id][mbVW], .testlos = 0, .streamdistance = 25.0);
	}
}

stock HasMailbox(playerid)
{
	if (PlayerInfo[playerid][pPhousekey] != INVALID_HOUSE_ID &&	HouseInfo[PlayerInfo[playerid][pPhousekey]][hMailX] != 0.0) return 1;
	if (PlayerInfo[playerid][pPhousekey2] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[playerid][pPhousekey2]][hMailX] != 0.0) return 1;
	return 0;
}

stock GetFreeMailboxId()
{
    for (new i; i < MAX_MAILBOXES; i++) {
		if (MailBoxes[i][mbPosX] == 0.0) return i;
	}
	return -1;
}

stock CheckServerAd(szInput[]) {

	new
		iCount,
		iPeriod,
		iPos,
		iChar,
		iColon;

	while((iChar = szInput[iPos++])) {
		if('0' <= iChar <= '9') iCount++;
		else if(iChar == '.') iPeriod++;
		else if(iChar == ':') iColon++;
	}
	if(iCount >= 7 && iPeriod >= 3 && iColon >= 1) {
		return 1;
	}

	return 0;
}

stock FMemberCounter()
{

	new
		arrCounts[sizeof(FamilyInfo)],
		szFileStr[128],
		arrTimeStamp[2][3],
		File: iFileHandle;
	if(!fexist("logs/fmembercount.log")) {
		iFileHandle = fopen("logs/fmembercount.log", io_write);
	}
	else {
		iFileHandle = fopen("logs/fmembercount.log", io_append);
	}
	if(iFileHandle)
	{
		gettime(arrTimeStamp[0][0], arrTimeStamp[0][1], arrTimeStamp[0][2]);
		getdate(arrTimeStamp[1][0], arrTimeStamp[1][1], arrTimeStamp[1][2]);
		foreach(new i: Player)
		{
			if(PlayerInfo[i][pAdmin] < 2 && playerTabbed[i] == 0 && PlayerInfo[i][pFMember] != 255) ++arrCounts[PlayerInfo[i][pFMember]];
		}
		format(szFileStr, sizeof(szFileStr), "----------------------------------------\r\nNgay: %d/%d/%d - Thoi gian: %d:%d\r\n", arrTimeStamp[1][1], arrTimeStamp[1][2], arrTimeStamp[1][0], arrTimeStamp[0][0], arrTimeStamp[0][1]);
		fwrite(iFileHandle, szFileStr);

		for(new iFam; iFam < sizeof(FamilyInfo); ++iFam) format(szFileStr, sizeof(szFileStr), "(%i) %s: %i\r\n", iFam+1, FamilyInfo[iFam][FamilyName], arrCounts[iFam]), fwrite(iFileHandle, szFileStr);
		return fclose(iFileHandle);

	}
	return 0;
}

stock SaveFamilies()
{
	for(new i = 1; i < MAX_FAMILY; i++)
	{
		SaveFamily(i);
	}
	return 1;
}

stock StopRefueling(playerid, iBusinessID, iPumpID)
{

	new
		iCost = floatround(Businesses[iBusinessID][GasPumpSalePrice][iPumpID]),
		iVehicleID = Businesses[iBusinessID][GasPumpVehicleID][iPumpID],
		string[128];

	format(string, sizeof(string), "Xe cua ban da duoc nap day nhien lieu voi gia $%d.", iCost);

	if( DynVeh[iVehicleID] != -1)
	{
	    DynVehicleInfo[DynVeh[iVehicleID]][gv_fFuel] = VehicleFuel[iVehicleID];
	    DynVeh_Save(DynVeh[iVehicleID]);
	}
	if (DynVeh[iVehicleID] != -1 && DynVehicleInfo[DynVeh[iVehicleID]][gv_igID] != INVALID_GROUP_ID)
 	{
 		new iGroupID = DynVehicleInfo[DynVeh[iVehicleID]][gv_igID];
		arrGroupData[iGroupID][g_iBudget] -= iCost;
		new str[128], file[32];
        format(str, sizeof(str), "%s da tiep nhien lieu %d voi chi phi $%d vao ngan sach cua hang %s's.", GetPlayerNameEx(playerid), iVehicleID, iCost, arrGroupData[iGroupID][g_szGroupName]);
		new month, day, year;
		getdate(year,month,day);
		format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", iGroupID, month, day, year);
		Log(file, str);
 		SendClientMessageEx(playerid, COLOR_GREY, "Chiec xe da duoc chinh phu chi tra de tiep nhien lieu.");
	}
	else GivePlayerMoneyEx(playerid, -iCost);

	Businesses[iBusinessID][bSafeBalance] += TaxSale(iCost);

	KillTimer(Businesses[iBusinessID][GasPumpTimer][iPumpID]);

	SendClientMessageEx(playerid, COLOR_WHITE, string);

	new vehicleslot = GetPlayerVehicle(playerid, iVehicleID);

	// Save Fuel to MySQL
	if(vehicleslot != -1) {
	    PlayerVehicleInfo[playerid][vehicleslot][pvFuel] = VehicleFuel[iVehicleID];
		format(string, sizeof(string), "UPDATE `vehicles` SET `pvFuel` = %0.5f WHERE `id` = '%d'", VehicleFuel[iVehicleID], PlayerVehicleInfo[playerid][vehicleslot][pvSlotId]);
		mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
	}

	Businesses[iBusinessID][GasPumpVehicleID][iPumpID] = 0;

	DeletePVar(playerid, "Refueling");

	format(string,sizeof(string),"%s (IP: %s) da do xang cho xe voi gia $%d tai %s (%d)",GetPlayerNameEx(playerid),GetPlayerIpEx(playerid),iCost,Businesses[iBusinessID][bName], iBusinessID);
	Log("logs/business.log", string);

	return true;
}

stock GivePlayerValidWeapon( playerid, WeaponID, Ammo )
{
    #if defined zombiemode
    if(zombieevent == 1 && GetPVarType(playerid, "pIsZombie")) return SendErrorMessage(playerid, "  Zombies can't have guns.");
    #endif
//  if(PlayerInfo[playerid][pGunLic] == 0) return SendErrorMessage(playerid, "  Ban khong co giay phep su dung sung");
    switch( WeaponID )
    {
        case 0, 1:
        {
            PlayerInfo[playerid][pGuns][ 0 ] = WeaponID;
            GivePlayerWeapon( playerid, WeaponID, Ammo );
        }
        case 2, 3, 4, 5, 6, 7, 8, 9:
        {
            PlayerInfo[playerid][pGuns][ 1 ] = WeaponID;
            GivePlayerWeapon( playerid, WeaponID, Ammo );
        }
        case 22, 23, 24:
        {
            PlayerInfo[playerid][pGuns][ 2 ] = WeaponID;
            PlayerInfo[playerid][pAmmo][ 1 ] = Ammo;
            GivePlayerWeapon( playerid, WeaponID, Ammo );
        }
        case 25, 26, 27:
        {
            PlayerInfo[playerid][pGuns][ 3 ] = WeaponID;
            PlayerInfo[playerid][pAmmo][ 2 ] = Ammo;
            GivePlayerWeapon( playerid, WeaponID, Ammo );
        }
        case 28, 29, 32:
        {
            PlayerInfo[playerid][pGuns][ 4 ] = WeaponID;
            PlayerInfo[playerid][pAmmo][ 3 ] = Ammo;
            GivePlayerWeapon( playerid, WeaponID, Ammo );
        }
        case 30, 31:
        {
            PlayerInfo[playerid][pGuns][ 5 ] = WeaponID;
            PlayerInfo[playerid][pAmmo][ 4 ] = Ammo;
            GivePlayerWeapon( playerid, WeaponID, Ammo );
        }
        case 33, 34:
        {
            PlayerInfo[playerid][pGuns][ 6 ] = WeaponID;
            PlayerInfo[playerid][pAmmo][ 5 ] = Ammo;
            GivePlayerWeapon( playerid, WeaponID, Ammo );
        }
        case 35, 36, 37, 38:
        {
            PlayerInfo[playerid][pGuns][ 7 ] = WeaponID;
            PlayerInfo[playerid][pAmmo][ 6 ] = Ammo;
            GivePlayerWeapon( playerid, WeaponID, Ammo );
        }
        case 16, 17, 18, 39, 40:
        {
            PlayerInfo[playerid][pGuns][ 8 ] = WeaponID;
            PlayerInfo[playerid][pAmmo][ 7 ] = Ammo;
            GivePlayerWeapon( playerid, WeaponID, Ammo );
        }
        case 41, 42, 43:
        {
            PlayerInfo[playerid][pGuns][ 9 ] = WeaponID;
            PlayerInfo[playerid][pAmmo][ 8 ] = Ammo;
            GivePlayerWeapon( playerid, WeaponID, Ammo );
        }
        case 10, 11, 12, 13, 14, 15:
        {
            PlayerInfo[playerid][pGuns][ 10 ] = WeaponID;
            GivePlayerWeapon( playerid, WeaponID, Ammo );
        }
        case 44, 45, 46:
        {
            PlayerInfo[playerid][pGuns][ 11 ] = WeaponID;
            GivePlayerWeapon( playerid, WeaponID, Ammo );
        }
    }
    return 1;
}

stock RegisterVehicleNumberPlate(vehicleid, sz_NumPlate[]) {
	new
	    Float: a_CarPos[4], Float: fuel; // X, Y, Z, Z Angle, Fuel

	GetVehiclePos(vehicleid, a_CarPos[0], a_CarPos[1], a_CarPos[2]);
	GetVehicleZAngle(vehicleid, a_CarPos[3]);
	fuel = VehicleFuel[vehicleid];
	SetVehicleNumberPlate(vehicleid, sz_NumPlate);
	SetVehicleToRespawn(vehicleid);
	SetVehiclePos(vehicleid, a_CarPos[0], a_CarPos[1], a_CarPos[2]);
	SetVehicleZAngle(vehicleid, a_CarPos[3]);
	VehicleFuel[vehicleid] = fuel;
	return 1;
}
stock DisplayOrders(playerid)
{
	new szDialog[5000];
	new vehicleid = GetPlayerVehicleID(playerid);
	if (!szDialog[0])
	{
  		if(IsATruckerCar(vehicleid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
   			ShowPlayerDialog(playerid, DIALOG_LOADTRUCKOLD, DIALOG_STYLE_LIST, "Chon hang", "{782727}Hang Lau\n{27785d}Hang Thuong", "Lua chon", "Huy bo");
		}
	}
	return 1;
}

stock DisplayStampDialog(playerid)
{
	ShowPlayerDialog(playerid, DIALOG_POSTAMP, DIALOG_STYLE_LIST, "Mua mot con tem", "Thu thuong xuyen		$100\nThu uu tien		$250\nThu cao cap		$500 (Gold VIP+)\nThu chinh phu	Mien phi", "Tiep tuc", "Huy bo");
}


stock SendCallToQueue(callfrom, description[], area[], mainzone[], type)
{
    new bool:breakingloop = false, newid = INVALID_CALL_ID, string[128];

	for(new i; i < MAX_CALLS; i++)
	{
		if(!breakingloop)
		{
			if(Calls[i][HasBeenUsed] == 0)
			{
				breakingloop = true;
				newid = i;
			}
		}
    }
    if(newid != INVALID_CALL_ID)
    {
     	foreach(new i: Player)
     	{
     	    if(0 <= PlayerInfo[i][pMember] < MAX_GROUPS)
			{
				for(new j; j < arrGroupData[PlayerInfo[i][pMember]][g_iJCount]; j++)
				{
					if(strcmp(arrGroupJurisdictions[PlayerInfo[i][pMember]][j][g_iAreaName], area, true) == 0 || strcmp(arrGroupJurisdictions[PlayerInfo[i][pMember]][j][g_iAreaName], mainzone, true) == 0)
					{
						if(type == 0 && IsACop(i))
						{
							format(string, sizeof(string), "HQ: Tat ca cac don vi APB: Nguoi trinh bao: %s", GetPlayerNameEx(callfrom));
							SendClientMessageEx(i, TEAM_BLUE_COLOR, string);
							format(string, sizeof(string), "HQ: Dia diem: %s, Mieu ta: %s", area, description);
							SendClientMessageEx(i, TEAM_BLUE_COLOR, string);
						}
						if(type == 1 && IsAMedic(i))
						{
							format(string, sizeof(string), "HQ: Tat ca cac don vi APB: Nguoi trinh bao: %s", GetPlayerNameEx(callfrom));
							SendClientMessageEx(i, TEAM_BLUE_COLOR, string);
							format(string, sizeof(string), "HQ: Dia diem: %s, Mieu ta: %s", area, description);
							SendClientMessageEx(i, TEAM_BLUE_COLOR, string);
						}
						if(type == 2 && IsACop(i))
						{
							format(string, sizeof(string), "HQ: Tat ca cac don vi APB: Nguoi trinh bao: %s", GetPlayerNameEx(callfrom));
							SendClientMessageEx(i, TEAM_BLUE_COLOR, string);
							format(string, sizeof(string), "HQ: Dia diem: %s, Mieu ta: %s", area, description);
							SendClientMessageEx(i, TEAM_BLUE_COLOR, string);
						}
						if(type == 3 && (IsACop(i) || IsATowman(i)))
						{
							format(string, sizeof(string), "HQ: Tat ca cac don vi APB: Nguoi trinh bao: %s", GetPlayerNameEx(callfrom));
							SendClientMessageEx(i, TEAM_BLUE_COLOR, string);
							format(string, sizeof(string), "HQ: Dia diem: %s, Mieu ta: %s", area, description);
							SendClientMessageEx(i, TEAM_BLUE_COLOR, string);
						}
					}
				}
     	    }
     	}
     	SetPVarInt(callfrom, "Has911Call", 1);
		strmid(Calls[newid][Area], area, 0, strlen(area), 28);
		strmid(Calls[newid][MainZone], mainzone, 0, strlen(mainzone), 28);
		strmid(Calls[newid][Description], description, 0, strlen(description), 128);
		Calls[newid][CallFrom] = callfrom;
		Calls[newid][Type] = type;
		Calls[newid][TimeToExpire] = 0;
		Calls[newid][HasBeenUsed] = 1;
		Calls[newid][BeingUsed] = 1;
		Calls[newid][CallExpireTimer] = SetTimerEx("CallTimer", 60000, 0, "d", newid);
    }
    else
    {
        ClearCalls();
        SendCallToQueue(callfrom, description, area, mainzone, type);
    }
}

stock ClearCalls()
{
	for(new i; i < MAX_CALLS; i++)
	{
	    if(Calls[i][BeingUsed] == 1) DeletePVar(Calls[i][CallFrom], "Has911Call");
		strmid(Calls[i][Area], "None", 0, 4, 4);
		strmid(Calls[i][MainZone], "None", 0, 4, 4);
		strmid(Calls[i][Description], "None", 0, 4, 4);
		Calls[i][RespondingID] = INVALID_PLAYER_ID;
        Calls[i][CallFrom] = INVALID_PLAYER_ID;
		Calls[i][Type] = -1;
        Calls[i][TimeToExpire] = 0;
        Calls[i][HasBeenUsed] = 0;
        Calls[i][BeingUsed] = 0;
	}
	return 1;
}

stock GetClosestCar(iPlayer, iException = INVALID_VEHICLE_ID, Float: fRange = Float: 0x7F800000) {

	new
		iReturnID = INVALID_VEHICLE_ID,
		Float: fVehiclePos[4];

	for(new i = 1; i <= MAX_VEHICLES; ++i) if(GetVehicleModel(i) && i != iException) {
		GetVehiclePos(i, fVehiclePos[0], fVehiclePos[1], fVehiclePos[2]);
		if((fVehiclePos[3] = GetPlayerDistanceFromPoint(iPlayer, fVehiclePos[0], fVehiclePos[1], fVehiclePos[2])) < fRange) {
			fRange = fVehiclePos[3];
			iReturnID = i;
		}
	}
	return iReturnID;
}

stock CountCrates()
{
	new count;
	for(new i = 0; i < sizeof(CrateInfo); i++)
	{
	    if(CrateInfo[i][crActive]) count++;
	}
	return count;
}

#if defined zombiemode
stock SpawnZombie(playerid)
{
	new Float:maxdis, Float:dis, tpto;
	maxdis=9999.9;
	SetPlayerSkin(playerid, 20001);
	SetPlayerHealth(playerid, 200);
	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 0);
	for(new x;x<sizeof(ZombieSpawns);x++)
	{
        dis = GetPointDistanceToPoint(ZombieSpawns[x][0], ZombieSpawns[x][1], ZombieSpawns[x][2], GetPVarFloat(playerid,"MedicX"), GetPVarFloat(playerid,"MedicY"), GetPVarFloat(playerid,"MedicZ"));
        if((dis < maxdis) && (dis > 50.0))
        {
            tpto=x;
            maxdis=dis;
        }
	}
	SetPlayerPos(playerid, ZombieSpawns[tpto][0], ZombieSpawns[tpto][1], ZombieSpawns[tpto][2]);
	SetPlayerFacingAngle(playerid, ZombieSpawns[tpto][3]);
	ClearAnimations(playerid);
	return 1;
}



stock Hienradio(playerid)
{
	PlayerTextDrawShow(playerid,radio[playerid]);
	return 1;
}

stock tatradio(playerid)
{
	PlayerTextDrawHide(playerid,radio[playerid]);
	return 1;
}

stock xoaradio(playerid)
{
	PlayerTextDrawDestroy(playerid, radio[playerid]);
}

stock XoaSpeedo(playerid)
{
    PlayerTextDrawDestroy(playerid, SpeedoText[0][playerid]);
	PlayerTextDrawDestroy(playerid, SpeedoText[1][playerid]);
	PlayerTextDrawDestroy(playerid, SpeedoText[2][playerid]);
	PlayerTextDrawDestroy(playerid, SpeedoText[3][playerid]);
}

stock SetPlayerAttachedObjectEx(playerid, index, modelid, bone, Float:fOffsetX = 0.0, Float:fOffsetY = 0.0, Float:fOffsetZ = 0.0, Float:fRotX = 0.0, Float:fRotY = 0.0, Float:fRotZ = 0.0, Float:fScaleX = 1.0, Float:fScaleY = 1.0, Float:fScaleZ = 1.0, materialcolor = 0, materialcolor2 = 0)
{
	new string[128];
	if (IsPlayerConnected(playerid))
	{
	    if (IsPlayerAttachedObjectSlotUsed(playerid, index))
	    {
			format(string, sizeof(string), "Your attached object in slot #%d has been removed for another object.", index + 1);
			SendClientMessage(playerid, -1, string);
			RemovePlayerAttachedObject(playerid, index);
		}
		return SetPlayerAttachedObject(playerid, index, modelid, bone, fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, fScaleX, fScaleY, fScaleZ, materialcolor, materialcolor2);
	}
	return 0;
}

stock MakeZombie(playerid)
{
    new Float:X, Float:Y, Float:Z, string[128];
    GetPlayerPos(playerid, X, Y, Z);

    if(IsPlayerConnected(GetPVarInt(playerid, "pZombieBiter")))
	{
		format(string, sizeof(string), "INSERT INTO zombiekills (id,num) VALUES (%d,1) ON DUPLICATE KEY UPDATE num = num + 1", GetPlayerSQLId(GetPVarInt(playerid, "pZombieBiter")));
		mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
		DeletePVar(playerid, "pZombieBiter");
	}

	SendClientMessageEx(playerid, COLOR_RED, "Ban dang la Zombie, su dung /bite de lay nhiem sang nguoi khac!");
 	SetPVarInt(playerid, "pIsZombie", 1);
  	DeletePVar(playerid, "pZombieBit");
   	SetPlayerToTeamColor(playerid);

	SetPlayerHealth(playerid, 200);
	SetPlayerSkin(playerid, 20001);

	ResetPlayerWeaponsEx(playerid);

 	//SendAudioToRange(70, 100, X, Y, Z, 30); RESCRIPT NEW SOUND

 	format(string, sizeof(string), "INSERT INTO `zombie` (`id`) VALUES ('%d')", GetPlayerSQLId(playerid));
	mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
	return 1;
}

stock UnZombie(playerid)
{
	DeletePVar(playerid, "pIsZombie");
  	DeletePVar(playerid, "pZombieBit");
  	SetPlayerSkin(playerid, PlayerInfo[playerid][pModel]);
   	SetPlayerToTeamColor(playerid);
	return 1;
}
#endif

stock MoveGate(playerid, gateid)
{
	new string[128];
	if(GateInfo[gateid][gStatus] == 0)
	{
		format(string, sizeof(string), "* %s su dung dieu khien mo canh cong tu xa.", GetPlayerNameEx(playerid));
		ProxDetector(GateInfo[gateid][gRange], playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		MoveDynamicObject(GateInfo[gateid][gGATE], GateInfo[gateid][gPosXM], GateInfo[gateid][gPosYM], GateInfo[gateid][gPosZM], GateInfo[gateid][gSpeed], GateInfo[gateid][gRotXM], GateInfo[gateid][gRotYM], GateInfo[gateid][gRotZM]);
		GateInfo[gateid][gStatus] = 1;
		if(GateInfo[gateid][gTimer] != 0)
		{
			switch(GateInfo[gateid][gTimer])
			{
				case 1: SetTimerEx("MoveTimerGate", 3000, false, "i", gateid);
				case 2: SetTimerEx("MoveTimerGate", 5000, false, "i", gateid);
				case 3: SetTimerEx("MoveTimerGate", 8000, false, "i", gateid);
				case 4: SetTimerEx("MoveTimerGate", 10000, false, "i", gateid);
			}
		}
	}
	else if(GateInfo[gateid][gStatus] == 1 && GateInfo[gateid][gTimer] == 0)
	{
		format(string, sizeof(string), "* %s su dung dieu khien de dong canh cong.", GetPlayerNameEx(playerid));
		ProxDetector(GateInfo[gateid][gRange], playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		MoveDynamicObject(GateInfo[gateid][gGATE], GateInfo[gateid][gPosX], GateInfo[gateid][gPosY], GateInfo[gateid][gPosZ], GateInfo[gateid][gSpeed], GateInfo[gateid][gRotX], GateInfo[gateid][gRotY], GateInfo[gateid][gRotZ]);
		GateInfo[gateid][gStatus] = 0;
	}
}

stock TransferStorage(playerid, storageid, fromplayerid, fromstorageid, itemid, amount, price, special)
{
	if(playerid == fromplayerid)
	{
		return SendClientMessageEx(playerid, COLOR_WHITE, "ERROR! Ban khong the chuyen cho chinh minh");
	}

	storageid=0; fromstorageid=0; //temp
	//printf("TransferStorage(playerid=%d, storageid=%d, fromplayerid=%d, fromstorageid=%d, itemid=%d, amount=%d, price=%d, special=%d)", playerid, storageid, fromplayerid, fromstorageid, itemid, amount, price, special);

	if(GetPVarInt(playerid, "Storage_transaction") == 1)
	{
		if(fromplayerid != -1 && fromstorageid != -1) {
			SendClientMessageEx(fromplayerid, COLOR_WHITE, "Nguoi choi dang thuc hien mot giao dich khac.");
		}
		return 0;
	}

	new string[128];

	// Disable Prices for Cash Transfers
	if(price != -1 && itemid == 1) price = -1;

	// Ask the player where to store
	if(storageid == -1)
	{
		//UNCOMMENT WHEN RE RELEASE
		//ShowStorageDialog(playerid, fromplayerid, fromstorageid, itemid, amount, price, special);
		return 0;
	}

	// Check if such item is equipped.
	if(storageid > 0 && storageid < 4)
	{
		if(StorageInfo[playerid][storageid-1][sAttached] == 0)
		{
			format(string, sizeof(string), "Ban khong co %s duoc trang bi!", storagetype[storageid]);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			return 0;
		}
	}

	if(fromplayerid != -1 && fromstorageid != -1)
	{
		if(!IsPlayerConnected(fromplayerid)) return 0;
		if(amount < 0) return 0;

		if(fromstorageid > 0 && fromstorageid < 4)
		{
			if(StorageInfo[fromplayerid][fromstorageid-1][sAttached] == 0)
			{
				format(string, sizeof(string), "Ban khong co %s duoc trang bi!", storagetype[fromstorageid]);
				SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
				return 0;
			}
		}
	}
    if(special == 1 && itemid == 2) // Pot Special "Selling"
	{
        GivePlayerMoneyEx(PotOffer[playerid], PotPrice[playerid]);
		GivePlayerMoneyEx(playerid, -PotPrice[playerid]);

		if(DoubleXP) {
			SendClientMessageEx(playerid, COLOR_YELLOW, "Ban nhan duoc 1 diem buon ma tuy");
			PlayerInfo[PotOffer[playerid]][pDrugsSkill] += 1;
		}
		else
  		if(PlayerInfo[PotOffer[playerid]][pDoubleEXP] > 0 && !DoubleXP)
		{
			format(string, sizeof(string), "Ban nhan duoc 2 diem buon ma tuy thay vi 1. Ban con %d gio nhan doi EXP token.", PlayerInfo[PotOffer[playerid]][pDoubleEXP]);
			SendClientMessageEx(PotOffer[playerid], COLOR_YELLOW, string);
			PlayerInfo[PotOffer[playerid]][pDrugsSkill] += 1;
		}
		else
		{
			PlayerInfo[PotOffer[playerid]][pDrugsSkill] += 1;
		}

        if(PlayerInfo[PotOffer[playerid]][pDrugsSkill] == 50)
        { SendClientMessageEx(PotOffer[playerid], COLOR_YELLOW, "* Diem ky nang ban ma tuy hien tai cua ban la Level 2, Ban co the lay them ma tuy va co gia re hon."); }
        else if(PlayerInfo[PotOffer[playerid]][pDrugsSkill] == 100)
        { SendClientMessageEx(PotOffer[playerid], COLOR_YELLOW, "* Diem ky nang ban ma tuy hien tai cua ban la Level 3, Ban co the lay them ma tuy va co gia re hon."); }
        else if(PlayerInfo[PotOffer[playerid]][pDrugsSkill] == 200)
        { SendClientMessageEx(PotOffer[playerid], COLOR_YELLOW, "* Diem ky nang ban ma tuy hien tai cua ban la Level 4, Ban co the lay them ma tuy va co gia re hon."); }
        else if(PlayerInfo[PotOffer[playerid]][pDrugsSkill] == 400)
        { SendClientMessageEx(PotOffer[playerid], COLOR_YELLOW, "* Diem ky nang ban ma tuy hien tai cua ban la Level 5, Ban co the lay them ma tuy va co gia re hon."); }
        OnPlayerStatsUpdate(playerid);
        OnPlayerStatsUpdate(PotOffer[playerid]);
		PotOffer[playerid] = INVALID_PLAYER_ID;
		PotStorageID[playerid] = -1;
        PotPrice[playerid] = 0;
        PotGram[playerid] = 0;

	}
	if(special == 1 && itemid == 3) // Crack Special "Selling"
	{
        GivePlayerMoneyEx(CrackOffer[playerid], CrackPrice[playerid]);
		GivePlayerMoneyEx(playerid, -CrackPrice[playerid]);

		if(DoubleXP) {
			SendClientMessageEx(playerid, COLOR_YELLOW, "Ban nhan duoc 2 diem buon ma tuy thay vi 1. (Nhan doi XP dang Su dung)");
			PlayerInfo[CrackOffer[playerid]][pDrugsSkill] += 2;
			PlayerInfo[CrackOffer[playerid]][pXP] += PlayerInfo[CrackOffer[playerid]][pLevel] * XP_RATE * 2;
		}
		else
		if(PlayerInfo[CrackOffer[playerid]][pDoubleEXP] > 0 && !DoubleXP)
		{
			format(string, sizeof(string), "Ban nhan duoc 2 diem buon ma tuy thay vi 1. Ban con %d gio nhan doi EXP token.", PlayerInfo[CrackOffer[playerid]][pDoubleEXP]);
			SendClientMessageEx(CrackOffer[playerid], COLOR_YELLOW, string);
			PlayerInfo[CrackOffer[playerid]][pDrugsSkill] += 2;
			PlayerInfo[CrackOffer[playerid]][pXP] += PlayerInfo[CrackOffer[playerid]][pLevel] * XP_RATE * 2;
		}
		else
		{
			PlayerInfo[CrackOffer[playerid]][pDrugsSkill] += 1;
			PlayerInfo[CrackOffer[playerid]][pXP] += PlayerInfo[CrackOffer[playerid]][pLevel] * XP_RATE;
		}

        PlayerInfo[playerid][pCrack] += CrackGram[playerid];
        PlayerInfo[CrackOffer[playerid]][pCrack] -= CrackGram[playerid];
        if(PlayerInfo[CrackOffer[playerid]][pDrugsSkill] == 50)
        { SendClientMessageEx(CrackOffer[playerid], COLOR_YELLOW, "* Diem ky nang ban ma tuy hien tai cua ban dat cap do 2, Ban co the lay them ma tuy va co gia re hon."); }
        else if(PlayerInfo[CrackOffer[playerid]][pDrugsSkill] == 100)
		{ SendClientMessageEx(CrackOffer[playerid], COLOR_YELLOW, "* Diem ky nang ban ma tuy hien tai cua ban dat cap do 3, Ban co the lay them ma tuy va co gia re hon."); }
        else if(PlayerInfo[CrackOffer[playerid]][pDrugsSkill] == 200)
        { SendClientMessageEx(CrackOffer[playerid], COLOR_YELLOW, "* Diem ky nang ban ma tuy hien tai cua ban dat cap do 4, Ban co the lay them ma tuy va co gia re hon."); }
        else if(PlayerInfo[CrackOffer[playerid]][pDrugsSkill] == 400)
        { SendClientMessageEx(CrackOffer[playerid], COLOR_YELLOW, "* Diem ky nang ban ma tuy hien tai cua ban dat cap do 5, Ban co the lay them ma tuy va co gia re hon."); }
		OnPlayerStatsUpdate(playerid);
        OnPlayerStatsUpdate(CrackOffer[playerid]);
		CrackOffer[playerid] = INVALID_PLAYER_ID;
		CrackStorageID[playerid] = -1;
        CrackPrice[playerid] = 0;
        CrackGram[playerid] = 0;
	}
	if(special == 2 && itemid == 2) // Pot Special "Getting"
	{
		new mypoint = -1;
		for (new i=0; i<MAX_POINTS; i++)
		{
			if (IsPlayerInRangeOfPoint(playerid, 3.0, Points[i][Pointx], Points[i][Pointy], Points[i][Pointz]) && Points[i][Type] == 3)
			{
				new myvw = GetPlayerVirtualWorld(playerid);
				if(myvw == Points[i][pointVW])
				{
					mypoint = i;
				}
			}
		}

		if(PlayerInfo[playerid][pDonateRank] < 1)
		{
			Points[mypoint][Stock] -= amount;
			format(string, sizeof(string), " POT/THUOC PHIEN CO SAN: %d/1000.", Points[mypoint][Stock]);
			UpdateDynamic3DTextLabelText(Points[mypoint][TextLabel], COLOR_YELLOW, string);
		}
		for(new i = 0; i < sizeof(FamilyInfo); i++)
		{
			if(strcmp(Points[mypoint][Owner], FamilyInfo[i][FamilyName], true) == 0)
			{
				FamilyInfo[i][FamilyBank] = FamilyInfo[i][FamilyBank]+price/2;
			}
		}
	}
	if(special == 2 && itemid == 3) // Crack Special "Getting"
	{
		new mypoint = -1;
		for (new i=0; i<MAX_POINTS; i++)
		{
			if (IsPlayerInRangeOfPoint(playerid, 3.0, Points[i][Pointx], Points[i][Pointy], Points[i][Pointz]) && Points[i][Type] == 4)
			{
				new myvw = GetPlayerVirtualWorld(playerid);
				if(myvw == Points[i][pointVW])
				{
					mypoint = i;
				}
			}
		}
		if(PlayerInfo[playerid][pDonateRank] < 1)
		{
			Points[mypoint][Stock] -= amount;
			format(string, sizeof(string), " CRACK CO SAN: %d/500.", Points[mypoint][Stock]);
			UpdateDynamic3DTextLabelText(Points[mypoint][TextLabel], COLOR_YELLOW, string);
		}
		for(new i = 0; i < sizeof(FamilyInfo); i++)
		{
			if(strcmp(Points[mypoint][Owner], FamilyInfo[i][FamilyName], true) == 0)
			{
				FamilyInfo[i][FamilyBank] = FamilyInfo[i][FamilyBank]+price/2;
			}
		}
	}
	if(special == 2 && itemid == 4) // Materials Special "Getting"
	{
		DeletePVar(playerid, "Packages");
		DeletePVar(playerid, "MatDeliver");
		DisablePlayerCheckpoint(playerid);
	}
	if(special == 4 && itemid == 1) // House Withdraw - Cash
	{
		new houseid = GetPVarInt(playerid, "Special_HouseID");
		DeletePVar(playerid, "Special_HouseID");

		HouseInfo[houseid][hSafeMoney] -= amount;
	}
	if(special == 4 && itemid == 2) // House Withdraw - Pot
	{
		new houseid = GetPVarInt(playerid, "Special_HouseID");
		DeletePVar(playerid, "Special_HouseID");

		HouseInfo[houseid][hPot] -= amount;
	}
	if(special == 4 && itemid == 3) // House Withdraw - Crack
	{
		new houseid = GetPVarInt(playerid, "Special_HouseID");
		DeletePVar(playerid, "Special_HouseID");

		HouseInfo[houseid][hCrack] -= amount;
	}
	if(special == 4 && itemid == 4) // House Withdraw - Mats
	{
		new houseid = GetPVarInt(playerid, "Special_HouseID");
		DeletePVar(playerid, "Special_HouseID");

		HouseInfo[houseid][hMaterials] -= amount;
	}
	if(special == 5 && itemid == 1) // Family Safe Withdraw - Cash
	{
		new file[32], month, day, year, family = GetPVarInt(playerid, "Special_FamilyID");
		DeletePVar(playerid, "Special_FamilyID");
		getdate(year,month,day);

		FamilyInfo[family][FamilyCash] -= amount;
		format(string, sizeof(string), "%s da lay $%s tu %s's safe", GetPlayerNameEx(playerid), number_format(amount), FamilyInfo[family][FamilyName]);
		format(file, sizeof(file), "family_logs/%d/%d-%02d-%02d.log", family, year, month, day);
		Log(file, string);
	}
	if(special == 5 && itemid == 2 && (PlayerInfo[playerid][pPot] + amount <= onhandlimit[itemid-1])) // Family Safe Withdraw - Pot
	{
		new file[32], month, day, year, family = GetPVarInt(playerid, "Special_FamilyID");
		DeletePVar(playerid, "Special_FamilyID");
		getdate(year,month,day);

		FamilyInfo[family][FamilyPot] -= amount;
		format(string, sizeof(string), "%s da lay %s pot tu %s's safe", GetPlayerNameEx(playerid), number_format(amount), FamilyInfo[family][FamilyName]);
		format(file, sizeof(file), "family_logs/%d/%d-%02d-%02d.log", family, year, month, day);
		Log(file, string);
	}
	if(special == 5 && itemid == 3 && (PlayerInfo[playerid][pCrack] + amount <= onhandlimit[itemid-1])) // Family Safe Withdraw - Crack
	{
		new file[32], month, day, year, family = GetPVarInt(playerid, "Special_FamilyID");
		DeletePVar(playerid, "Special_FamilyID");
		getdate(year,month,day);

		FamilyInfo[family][FamilyCrack] -= amount;
		format(string, sizeof(string), "%s da lay %s crack tu %s's safe", GetPlayerNameEx(playerid), number_format(amount), FamilyInfo[family][FamilyName]);
		format(file, sizeof(file), "family_logs/%d/%d-%02d-%02d.log", family, year, month, day);
		Log(file, string);
	}
	if(special == 5 && itemid == 4) // Family Safe Withdraw - Materials
	{
		new file[32], month, day, year, family = GetPVarInt(playerid, "Special_FamilyID");
		DeletePVar(playerid, "Special_FamilyID");
		getdate(year,month,day);

		FamilyInfo[family][FamilyMats] -= amount;
		format(string, sizeof(string), "%s da lay %s vat lieu tu %s's safe", GetPlayerNameEx(playerid), number_format(amount), FamilyInfo[family][FamilyName]);
		format(file, sizeof(file), "family_logs/%d/%d-%02d-%02d.log", family, year, month, day);
		Log(file, string);
	}

	switch(storageid)
	{
		case 0: // Pocket or On Hand
		{
			if(itemid == 1)
			{
				// Check if Sending Player has sufficient amount.
				if(fromplayerid != -1 && fromstorageid != -1)
				{
					if(fromstorageid == 0)
					{
						if(PlayerInfo[fromplayerid][pCash] < amount)
						{
							format(string, sizeof(string), "Ban khong du so luong de cung cap cho $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}
					else
					{
						if(StorageInfo[fromplayerid][fromstorageid-1][sCash] < amount)
						{
							format(string, sizeof(string), "Ban khong du so luong de cung cap cho $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}

					if(fromstorageid == 0) PlayerInfo[fromplayerid][pCash] -= amount;
					else StorageInfo[fromplayerid][fromstorageid-1][sCash] -= amount;
				}
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				PlayerInfo[playerid][pCash] += amount;
				OnPlayerStatsUpdate(playerid);
				if(fromplayerid != -1) {
        			OnPlayerStatsUpdate(fromplayerid);
        		}
				format(string, sizeof(string), "$%dda duoc dua vao Pocket cua ban ($%d).", amount, PlayerInfo[playerid][pCash]);
				SendClientMessage(playerid, COLOR_WHITE, string);

				if(fromplayerid != -1 && fromstorageid != -1 && playerid != fromplayerid) {
					format(string, sizeof(string), "$%d da duoc chuyen vao Briefcase %s cho %s's %s.", amount, storagetype[fromstorageid], GetPlayerNameEx(playerid), storagetype[storageid]);
					SendClientMessage(fromplayerid, COLOR_WHITE, string);

					PlayerPlaySound(fromplayerid, 1052, 0.0, 0.0, 0.0);
					format(string, sizeof(string), "* %s lay mot so %s tu %s, va dua no cho %s.", GetPlayerNameEx(fromplayerid), itemtype[itemid], storagetype[fromstorageid], GetPlayerNameEx(playerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

					if(PlayerInfo[fromplayerid][pAdmin] >= 2)
					{
						format(string, sizeof(string), "[Admin] %s (IP:%s) has given $%s %s to %s (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerIpEx(fromplayerid), number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerIpEx(playerid));
						Log("logs/adminpay.log", string);
						format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s (IP:%s) has given $%s %s to %s (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerIpEx(fromplayerid), number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerIpEx(playerid));
						ABroadCast(COLOR_YELLOW, string, 2);
					}
					else if(PlayerInfo[fromplayerid][pAdmin] < 2)
					{
						format(string, sizeof(string), "%s (IP:%s) has given $%s %s to %s (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerIpEx(fromplayerid), number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerIpEx(playerid));
						Log("logs/pay.log", string);

						if(amount >= 100000 && PlayerInfo[fromplayerid][pLevel] <= 3 && itemid == 1) ABroadCast(COLOR_YELLOW, string, 2);
						if(amount >= 1000000 && itemid == 1)	ABroadCast(COLOR_YELLOW,string,2);
					}
				}
				return 1;
			}
			if(itemid == 2 && (PlayerInfo[playerid][pPot] + amount <= onhandlimit[itemid-1]))
			{
				// Check if Sending Player has sufficient amount.
				if(fromplayerid != -1 && fromstorageid != -1)
				{
					if(fromstorageid == 0)
					{
						if(PlayerInfo[fromplayerid][pPot] < amount)
						{
							format(string, sizeof(string), "Ban khong du so luong de cung cap cho $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}
					else
					{
						if(StorageInfo[fromplayerid][fromstorageid-1][sPot] < amount)
						{
							format(string, sizeof(string), "Ban khong du so luong de cung cap cho $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}

					if(fromstorageid == 0) PlayerInfo[fromplayerid][pPot] -= amount;
					else StorageInfo[fromplayerid][fromstorageid-1][sPot] -= amount;
				}
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				PlayerInfo[playerid][pPot] += amount;
				//format(string, sizeof(string), "%d Pot has been transfered to your Pocket (%d/%d).", amount, PlayerInfo[playerid][pPot], onhandlimit[itemid-1]);
				format(string, sizeof(string), "%d Pot has been transfered to your Pocket (%d).", amount, PlayerInfo[playerid][pPot]);
				SendClientMessage(playerid, COLOR_WHITE, string);

				if(fromplayerid != -1 && fromstorageid != -1 && playerid != fromplayerid) {
					format(string, sizeof(string), "%d Pot da duoc chuyen vao Briefcase %s cho %s's %s.", amount, storagetype[fromstorageid], GetPlayerNameEx(playerid), storagetype[storageid]);
					SendClientMessage(fromplayerid, COLOR_WHITE, string);

					PlayerPlaySound(fromplayerid, 1052, 0.0, 0.0, 0.0);
					format(string, sizeof(string), "* %s lay mot so %s tu %s, va dua no cho %s.", GetPlayerNameEx(fromplayerid), itemtype[itemid], storagetype[fromstorageid], GetPlayerNameEx(playerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

					if(PlayerInfo[fromplayerid][pAdmin] >= 2)
					{
						format(string, sizeof(string), "[Admin] %s (IP:%s) da chuyen %s %s cho %s (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerIpEx(fromplayerid), number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerIpEx(playerid));
						Log("logs/adminpay.log", string);
						format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s (IP:%s) da chuyen %s %s cho %s (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerIpEx(fromplayerid), number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerIpEx(playerid));
						ABroadCast(COLOR_YELLOW, string, 2);
					}
					else if(PlayerInfo[fromplayerid][pAdmin] < 2)
					{
						format(string, sizeof(string), "%s (IP:%s) da chuyen %s %s cho %s (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerIpEx(fromplayerid), number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerIpEx(playerid));
						Log("logs/pay.log", string);

						if(amount >= 100000 && PlayerInfo[fromplayerid][pLevel] <= 3 && itemid == 1) ABroadCast(COLOR_YELLOW, string, 2);
						if(amount >= 1000000 && itemid == 1)	ABroadCast(COLOR_YELLOW,string,2);
					}
				}
				return 1;
			}
			if(itemid == 3 && (PlayerInfo[playerid][pCrack] + amount <= onhandlimit[itemid-1]))
			{
				// Check if Sending Player has sufficient amount.
				if(fromplayerid != -1 && fromstorageid != -1)
				{
					if(fromstorageid == 0)
					{
						if(PlayerInfo[fromplayerid][pCrack] < amount)
						{
							format(string, sizeof(string), "Ban khong du so luong de cung cap cho $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}
					else
					{
						if(StorageInfo[fromplayerid][fromstorageid-1][sCrack] < amount)
						{
							format(string, sizeof(string), "Ban khong du so luong de cung cap cho $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}

					if(fromstorageid == 0) PlayerInfo[fromplayerid][pCrack] -= amount;
					else StorageInfo[fromplayerid][fromstorageid-1][sCrack] -= amount;
				}
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				PlayerInfo[playerid][pCrack] += amount;
				//format(string, sizeof(string), "%d Crack has been transfered to your Pocket (%d/%d).", amount, PlayerInfo[playerid][pCrack], onhandlimit[itemid-1]);
				format(string, sizeof(string), "%d Crack has been transfered to your Pocket (%d).", amount, PlayerInfo[playerid][pCrack]);
				SendClientMessage(playerid, COLOR_WHITE, string);

				if(fromplayerid != -1 && fromstorageid != -1 && playerid != fromplayerid) {
					format(string, sizeof(string), "%d Crack da duoc chuyen vao Briefcase %s cho %s's %s.", amount, storagetype[fromstorageid], GetPlayerNameEx(playerid), storagetype[storageid]);
					SendClientMessage(fromplayerid, COLOR_WHITE, string);

					PlayerPlaySound(fromplayerid, 1052, 0.0, 0.0, 0.0);
					format(string, sizeof(string), "* %s lay mot so %s tu %s, va dua no cho %s.", GetPlayerNameEx(fromplayerid), itemtype[itemid], storagetype[fromstorageid], GetPlayerNameEx(playerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

					if(PlayerInfo[fromplayerid][pAdmin] >= 2)
					{
						format(string, sizeof(string), "[Admin] %s (IP:%s) da chuyen %s %s cho %s (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerIpEx(fromplayerid), number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerIpEx(playerid));
						Log("logs/adminpay.log", string);
						format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s (IP:%s) da chuyen %s %s cho %s (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerIpEx(fromplayerid), number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerIpEx(playerid));
						ABroadCast(COLOR_YELLOW, string, 2);
					}
					else if(PlayerInfo[fromplayerid][pAdmin] < 2)
					{
						format(string, sizeof(string), "%s (IP:%s) da chuyen %s %s cho %s (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerIpEx(fromplayerid), number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerIpEx(playerid));
						Log("logs/pay.log", string);

						if(amount >= 100000 && PlayerInfo[fromplayerid][pLevel] <= 3 && itemid == 1) ABroadCast(COLOR_YELLOW, string, 2);
						if(amount >= 1000000 && itemid == 1)	ABroadCast(COLOR_YELLOW,string,2);
					}
				}
				return 1;
			}
			if(itemid == 4 && (PlayerInfo[playerid][pMats] + amount <= onhandlimit[itemid-1]))
			{
				// Check if Sending Player has sufficient amount.
				if(fromplayerid != -1 && fromstorageid != -1)
				{
					if(fromstorageid == 0)
					{
						if(PlayerInfo[fromplayerid][pMats] < amount)
						{
							format(string, sizeof(string), "Ban khong du so luong de cung cap cho %d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}
					else
					{
						if(StorageInfo[fromplayerid][fromstorageid-1][sMats] < amount)
						{
							format(string, sizeof(string), "Ban khong du so luong de cung cap cho %d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}

					if(fromstorageid == 0) PlayerInfo[fromplayerid][pMats] -= amount;
					else StorageInfo[fromplayerid][fromstorageid-1][sMats] -= amount;
				}
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				PlayerInfo[playerid][pMats] += amount;
				//format(string, sizeof(string), "%d Vat lieu has been transfered to your Pocket (%d/%d).", amount, PlayerInfo[playerid][pMats], onhandlimit[itemid-1]);
				format(string, sizeof(string), "%d Vat lieu has been transfered to your Pocket (%d).", amount, PlayerInfo[playerid][pMats]);
				SendClientMessage(playerid, COLOR_WHITE, string);

				if(fromplayerid != -1 && fromstorageid != -1 && playerid != fromplayerid) {
					format(string, sizeof(string), "%d Vat lieu da duoc chuyen vao Briefcase %s cho %s's %s.", amount, storagetype[fromstorageid], GetPlayerNameEx(playerid), storagetype[storageid]);
					SendClientMessage(fromplayerid, COLOR_WHITE, string);

					PlayerPlaySound(fromplayerid, 1052, 0.0, 0.0, 0.0);
					format(string, sizeof(string), "* %s lay mot so %s tu %s, va dua no cho %s.", GetPlayerNameEx(fromplayerid), itemtype[itemid], storagetype[fromstorageid], GetPlayerNameEx(playerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

					new ipplayerid[16], ipfromplayerid[16];
					GetPlayerIp(playerid, ipplayerid, sizeof(ipplayerid));
					GetPlayerIp(fromplayerid, ipfromplayerid, sizeof(ipfromplayerid));

					if(PlayerInfo[fromplayerid][pAdmin] >= 2)
					{
						format(string, sizeof(string), "[Admin] %s (IP:%s) da chuyen %s %s cho %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						Log("logs/adminpay.log", string);
						format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s (IP:%s) da chuyen %s %s cho %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						ABroadCast(COLOR_YELLOW, string, 2);
					}
					else if(PlayerInfo[fromplayerid][pAdmin] < 2)
					{
						format(string, sizeof(string), "%s (IP:%s) da chuyen %s %s cho %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						Log("logs/pay.log", string);

						if(amount >= 100000 && PlayerInfo[fromplayerid][pLevel] <= 3 && itemid == 1) ABroadCast(COLOR_YELLOW, string, 2);
						if(amount >= 1000000 && itemid == 1)	ABroadCast(COLOR_YELLOW,string,2);
					}
				}
				return 1;
			}
			/*if(itemid == 4)
			{
				SendClientMessageEx(playerid, COLOR_WHITE, "You need at least a Bag to be able to store Materials.");
				return 0;
			}*/

			if(itemid == 1) format(string, sizeof(string), "Khong the chuyen $%d cho %s ($%d).", amount, storagetype[storageid], PlayerInfo[playerid][pCash]);
			else if(itemid == 2) format(string, sizeof(string), "Khong the chuyen %d %s cho %s (%d/%d).", amount, itemtype[itemid], storagetype[storageid], PlayerInfo[playerid][pPot], onhandlimit[itemid-1]);
			else if(itemid == 3) format(string, sizeof(string), "Khong the chuyen %d %s cho %s (%d/%d).", amount, itemtype[itemid], storagetype[storageid], PlayerInfo[playerid][pCrack], onhandlimit[itemid-1]);
			else if(itemid == 4) format(string, sizeof(string), "Khong the chuyen %d %s cho %s (%d/%d).", amount, itemtype[itemid], storagetype[storageid], PlayerInfo[playerid][pMats], onhandlimit[itemid-1]);

			SendClientMessageEx(playerid, COLOR_WHITE, string);
		}
		case 1: // Bag
		{
			if(StorageInfo[playerid][0][sStorage] == 0)
			{
				SendClientMessageEx(playerid, COLOR_WHITE, "You do not own a Bag. You may purchase one at a 24/7 store.");
				return 0;
			}

			if(itemid == 1 && (StorageInfo[playerid][0][sCash] + amount <= bbackpacklimit[itemid-1]))
			{
				// Check if Sending Player has sufficient amount.
				if(fromplayerid != -1 && fromstorageid != -1)
				{
					if(fromstorageid == 0)
					{
						if(PlayerInfo[fromplayerid][pCash] < amount)
						{
							format(string, sizeof(string), "Ban khong du so luong de cung cap cho $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}
					else
					{
						if(StorageInfo[fromplayerid][fromstorageid-1][sCash] < amount)
						{
							format(string, sizeof(string), "Ban khong du so luong de cung cap cho $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}

					if(fromstorageid == 0) PlayerInfo[fromplayerid][pCash] -= amount;
					else StorageInfo[fromplayerid][fromstorageid-1][sCash] -= amount;
				}
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				StorageInfo[playerid][0][sCash] += amount;
				format(string, sizeof(string), "$%d has been transfered to your Bag ($%d/$%d).", amount, StorageInfo[playerid][0][sCash], bbackpacklimit[itemid-1]);
				SendClientMessage(playerid, COLOR_WHITE, string);

				if(fromplayerid != -1 && fromstorageid != -1 && playerid != fromplayerid) {
					format(string, sizeof(string), "$%d da duoc chuyen vao Briefcase %s cho %s's %s.", amount, storagetype[fromstorageid], GetPlayerNameEx(playerid), storagetype[storageid]);
					SendClientMessage(fromplayerid, COLOR_WHITE, string);

					PlayerPlaySound(fromplayerid, 1052, 0.0, 0.0, 0.0);
					format(string, sizeof(string), "* %s lay mot so %s tu %s, va dua no cho %s.", GetPlayerNameEx(fromplayerid), itemtype[itemid], storagetype[fromstorageid], GetPlayerNameEx(playerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

					new ipplayerid[16], ipfromplayerid[16];
					GetPlayerIp(playerid, ipplayerid, sizeof(ipplayerid));
					GetPlayerIp(fromplayerid, ipfromplayerid, sizeof(ipfromplayerid));

					if(PlayerInfo[fromplayerid][pAdmin] >= 2)
					{
						format(string, sizeof(string), "[Admin] %s (IP:%s) da chuyen %s %s cho %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						Log("logs/adminpay.log", string);
						format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s (IP:%s) da chuyen %s %s cho %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						ABroadCast(COLOR_YELLOW, string, 2);
					}
					else if(PlayerInfo[fromplayerid][pAdmin] < 2)
					{
						format(string, sizeof(string), "%s (IP:%s) da chuyen %s %s cho %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						Log("logs/pay.log", string);

						if(amount >= 100000 && PlayerInfo[fromplayerid][pLevel] <= 3 && itemid == 1) ABroadCast(COLOR_YELLOW, string, 2);
						if(amount >= 1000000 && itemid == 1)	ABroadCast(COLOR_YELLOW,string,2);
					}
				}
				return 1;
			}
			if(itemid == 2 && (StorageInfo[playerid][0][sPot] + amount <= bbackpacklimit[itemid-1]))
			{
				// Check if Sending Player has sufficient amount.
				if(fromplayerid != -1 && fromstorageid != -1)
				{
					if(fromstorageid == 0)
					{
						if(PlayerInfo[fromplayerid][pPot] < amount)
						{
							format(string, sizeof(string), "Ban khong du so luong de cung cap cho $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}
					else
					{
						if(StorageInfo[fromplayerid][fromstorageid-1][sPot] < amount)
						{
							format(string, sizeof(string), "Ban khong du so luong de cung cap cho $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}

					if(fromstorageid == 0) PlayerInfo[fromplayerid][pPot] -= amount;
					else StorageInfo[fromplayerid][fromstorageid-1][sPot] -= amount;
				}
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				StorageInfo[playerid][0][sPot] += amount;
				format(string, sizeof(string), "%d Pot has been transfered to your Bag (%d/%d).", amount, StorageInfo[playerid][0][sPot], bbackpacklimit[itemid-1]);
				SendClientMessage(playerid, COLOR_WHITE, string);

				if(fromplayerid != -1 && fromstorageid != -1 && playerid != fromplayerid) {
					format(string, sizeof(string), "%d Pot da duoc chuyen vao Briefcase %s cho %s's %s.", amount, storagetype[fromstorageid], GetPlayerNameEx(playerid), storagetype[storageid]);
					SendClientMessage(fromplayerid, COLOR_WHITE, string);

					PlayerPlaySound(fromplayerid, 1052, 0.0, 0.0, 0.0);
					format(string, sizeof(string), "* %s lay mot so %s tu %s, va dua no cho %s.", GetPlayerNameEx(fromplayerid), itemtype[itemid], storagetype[fromstorageid], GetPlayerNameEx(playerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

					new ipplayerid[16], ipfromplayerid[16];
					GetPlayerIp(playerid, ipplayerid, sizeof(ipplayerid));
					GetPlayerIp(fromplayerid, ipfromplayerid, sizeof(ipfromplayerid));

					if(PlayerInfo[fromplayerid][pAdmin] >= 2)
					{
						format(string, sizeof(string), "[Admin] %s (IP:%s) da chuyen %s %s cho %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						Log("logs/adminpay.log", string);
						format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s (IP:%s) da chuyen %s %s cho %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						ABroadCast(COLOR_YELLOW, string, 2);
					}
					else if(PlayerInfo[fromplayerid][pAdmin] < 2)
					{
						format(string, sizeof(string), "%s (IP:%s) da chuyen %s %s cho %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						Log("logs/pay.log", string);

						if(amount >= 100000 && PlayerInfo[fromplayerid][pLevel] <= 3 && itemid == 1) ABroadCast(COLOR_YELLOW, string, 2);
						if(amount >= 1000000 && itemid == 1)	ABroadCast(COLOR_YELLOW,string,2);
					}
				}
				return 1;
			}
			if(itemid == 3 && (StorageInfo[playerid][0][sCrack] + amount <= bbackpacklimit[itemid-1]))
			{
				// Check if Sending Player has sufficient amount.
				if(fromplayerid != -1 && fromstorageid != -1)
				{
					if(fromstorageid == 0)
					{
						if(PlayerInfo[fromplayerid][pCrack] < amount)
						{
							format(string, sizeof(string), "Ban khong du so luong de cung cap cho $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}
					else
					{
						if(StorageInfo[fromplayerid][fromstorageid-1][sCrack] < amount)
						{
							format(string, sizeof(string), "Ban khong du so luong de cung cap cho $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}

					if(fromstorageid == 0) PlayerInfo[fromplayerid][pCrack] -= amount;
					else StorageInfo[fromplayerid][fromstorageid-1][sCrack] -= amount;
				}
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				StorageInfo[playerid][0][sCrack] += amount;
				format(string, sizeof(string), "%d Crack has been transfered to your Bag (%d/%d).", amount, StorageInfo[playerid][0][sCrack], bbackpacklimit[itemid-1]);
				SendClientMessage(playerid, COLOR_WHITE, string);

				if(fromplayerid != -1 && fromstorageid != -1 && playerid != fromplayerid) {
					format(string, sizeof(string), "%d Crack da duoc chuyen vao Briefcase %s cho %s's %s.", amount, storagetype[fromstorageid], GetPlayerNameEx(playerid), storagetype[storageid]);
					SendClientMessage(fromplayerid, COLOR_WHITE, string);

					PlayerPlaySound(fromplayerid, 1052, 0.0, 0.0, 0.0);
					format(string, sizeof(string), "* %s lay mot so %s tu %s, va dua no cho %s.", GetPlayerNameEx(fromplayerid), itemtype[itemid], storagetype[fromstorageid], GetPlayerNameEx(playerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

					new ipplayerid[16], ipfromplayerid[16];
					GetPlayerIp(playerid, ipplayerid, sizeof(ipplayerid));
					GetPlayerIp(fromplayerid, ipfromplayerid, sizeof(ipfromplayerid));

					if(PlayerInfo[fromplayerid][pAdmin] >= 2)
					{
						format(string, sizeof(string), "[Admin] %s (IP:%s) da chuyen %s %s cho %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						Log("logs/adminpay.log", string);
						format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s (IP:%s) da chuyen %s %s cho %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						ABroadCast(COLOR_YELLOW, string, 2);
					}
					else if(PlayerInfo[fromplayerid][pAdmin] < 2)
					{
						format(string, sizeof(string), "%s (IP:%s) da chuyen %s %s cho %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						Log("logs/pay.log", string);

						if(amount >= 100000 && PlayerInfo[fromplayerid][pLevel] <= 3 && itemid == 1) ABroadCast(COLOR_YELLOW, string, 2);
						if(amount >= 1000000 && itemid == 1)	ABroadCast(COLOR_YELLOW,string,2);
					}
				}
				return 1;
			}
			if(itemid == 4 && (StorageInfo[playerid][0][sMats] + amount <= bbackpacklimit[itemid-1]))
			{
				// Check if Sending Player has sufficient amount.
				if(fromplayerid != -1 && fromstorageid != -1)
				{
					if(fromstorageid == 0)
					{
						if(PlayerInfo[fromplayerid][pMats] < amount)
						{
							format(string, sizeof(string), "Ban khong du so luong de cung cap cho $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}
					else
					{
						if(StorageInfo[fromplayerid][fromstorageid-1][sMats] < amount)
						{
							format(string, sizeof(string), "Ban khong du so luong de cung cap cho $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}

					if(fromstorageid == 0) PlayerInfo[fromplayerid][pMats] -= amount;
					else StorageInfo[fromplayerid][fromstorageid-1][sMats] -= amount;
				}
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				StorageInfo[playerid][0][sMats] += amount;
				format(string, sizeof(string), "%d Vat lieu has been transfered to your Bag (%d/%d).", amount, StorageInfo[playerid][0][sMats], bbackpacklimit[itemid-1]);
				SendClientMessage(playerid, COLOR_WHITE, string);

				if(fromplayerid != -1 && fromstorageid != -1 && playerid != fromplayerid) {
					format(string, sizeof(string), "%d Vat lieu da duoc chuyen vao Briefcase %s cho %s's %s.", amount, storagetype[fromstorageid], GetPlayerNameEx(playerid), storagetype[storageid]);
					SendClientMessage(fromplayerid, COLOR_WHITE, string);

					PlayerPlaySound(fromplayerid, 1052, 0.0, 0.0, 0.0);
					format(string, sizeof(string), "* %s lay mot so %s tu %s, va dua no cho %s.", GetPlayerNameEx(fromplayerid), itemtype[itemid], storagetype[fromstorageid], GetPlayerNameEx(playerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

					new ipplayerid[16], ipfromplayerid[16];
					GetPlayerIp(playerid, ipplayerid, sizeof(ipplayerid));
					GetPlayerIp(fromplayerid, ipfromplayerid, sizeof(ipfromplayerid));

					if(PlayerInfo[fromplayerid][pAdmin] >= 2)
					{
						format(string, sizeof(string), "[Admin] %s (IP:%s) da chuyen %s %s cho %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						Log("logs/adminpay.log", string);
						format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s (IP:%s) da chuyen %s %s cho %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						ABroadCast(COLOR_YELLOW, string, 2);
					}
					else if(PlayerInfo[fromplayerid][pAdmin] < 2)
					{
						format(string, sizeof(string), "%s (IP:%s) da chuyen %s %s cho %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						Log("logs/pay.log", string);

						if(amount >= 100000 && PlayerInfo[fromplayerid][pLevel] <= 3 && itemid == 1) ABroadCast(COLOR_YELLOW, string, 2);
						if(amount >= 1000000 && itemid == 1)	ABroadCast(COLOR_YELLOW,string,2);
					}
				}
				return 1;
			}

			if(itemid == 1) format(string, sizeof(string), "Khong the chuyen $%d cho %s ($%d/$%d).", amount, storagetype[storageid], StorageInfo[playerid][0][sCash], bbackpacklimit[itemid-1]);
			else if(itemid == 2) format(string, sizeof(string), "Khong the chuyen %d %s cho %s (%d/%d).", amount, itemtype[itemid], storagetype[storageid], StorageInfo[playerid][0][sPot], bbackpacklimit[itemid-1]);
			else if(itemid == 3) format(string, sizeof(string), "Khong the chuyen %d %s cho %s (%d/%d).", amount, itemtype[itemid], storagetype[storageid], StorageInfo[playerid][0][sCrack], bbackpacklimit[itemid-1]);
			else if(itemid == 4) format(string, sizeof(string), "Khong the chuyen %d %s cho %s (%d/%d).", amount, itemtype[itemid], storagetype[storageid], StorageInfo[playerid][0][sMats], bbackpacklimit[itemid-1]);
			SendClientMessageEx(playerid, COLOR_WHITE, string);

		}
		case 2: // Backpack
		{
			if(StorageInfo[playerid][1][sStorage] == 0)
			{
				SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong co Backpack. Ban co the mua tren Gshop (/gshop).");
				return 0;
			}

			if(itemid == 1 && (StorageInfo[playerid][1][sCash] + amount <= backpacklimit[itemid-1]))
			{
				// Check if Sending Player has sufficient amount.
				if(fromplayerid != -1 && fromstorageid != -1)
				{
					if(fromstorageid == 0)
					{
						if(PlayerInfo[fromplayerid][pCash] < amount)
						{
							format(string, sizeof(string), "Ban khong du so luong de cung cap cho $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}
					else
					{
						if(StorageInfo[fromplayerid][fromstorageid-1][sCash] < amount)
						{
							format(string, sizeof(string), "Ban khong du so luong de cung cap cho $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}

					if(fromstorageid == 0) PlayerInfo[fromplayerid][pCash] -= amount;
					else StorageInfo[fromplayerid][fromstorageid-1][sCash] -= amount;
				}
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				StorageInfo[playerid][1][sCash] += amount;
				format(string, sizeof(string), "$%d has been transfered to your Backpack ($%d/$%d).", amount, StorageInfo[playerid][1][sCash], backpacklimit[itemid-1]);
				SendClientMessage(playerid, COLOR_WHITE, string);

				if(fromplayerid != -1 && fromstorageid != -1 && playerid != fromplayerid) {
					format(string, sizeof(string), "$%d da duoc chuyen vao Briefcase %s cho %s's %s.", amount, storagetype[fromstorageid], GetPlayerNameEx(playerid), storagetype[storageid]);
					SendClientMessage(fromplayerid, COLOR_WHITE, string);

					PlayerPlaySound(fromplayerid, 1052, 0.0, 0.0, 0.0);
					format(string, sizeof(string), "* %s lay mot so %s tu %s, va dua no cho %s.", GetPlayerNameEx(fromplayerid), itemtype[itemid], storagetype[fromstorageid], GetPlayerNameEx(playerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

					new ipplayerid[16], ipfromplayerid[16];
					GetPlayerIp(playerid, ipplayerid, sizeof(ipplayerid));
					GetPlayerIp(fromplayerid, ipfromplayerid, sizeof(ipfromplayerid));

					if(PlayerInfo[fromplayerid][pAdmin] >= 2)
					{
						format(string, sizeof(string), "[Admin] %s (IP:%s) da chuyen %s %s cho %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						Log("logs/adminpay.log", string);
						format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s (IP:%s) da chuyen %s %s cho %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						ABroadCast(COLOR_YELLOW, string, 2);
					}
					else if(PlayerInfo[fromplayerid][pAdmin] < 2)
					{
						format(string, sizeof(string), "%s (IP:%s) da chuyen %s %s cho %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						Log("logs/pay.log", string);

						if(amount >= 100000 && PlayerInfo[fromplayerid][pLevel] <= 3 && itemid == 1) ABroadCast(COLOR_YELLOW, string, 2);
						if(amount >= 1000000 && itemid == 1)	ABroadCast(COLOR_YELLOW,string,2);
					}
				}
				return 1;
			}
			if(itemid == 2 && (StorageInfo[playerid][1][sPot] + amount <= backpacklimit[itemid-1]))
			{
				// Check if Sending Player has sufficient amount.
				if(fromplayerid != -1 && fromstorageid != -1)
				{
					if(fromstorageid == 0)
					{
						if(PlayerInfo[fromplayerid][pPot] < amount)
						{
							format(string, sizeof(string), "Ban khong du so luong de cung cap cho $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}
					else
					{
						if(StorageInfo[fromplayerid][fromstorageid-1][sPot] < amount)
						{
							format(string, sizeof(string), "Ban khong du so luong de cung cap cho $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}

					if(fromstorageid == 0) PlayerInfo[fromplayerid][pPot] -= amount;
					else StorageInfo[fromplayerid][fromstorageid-1][sPot] -= amount;
				}
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				StorageInfo[playerid][1][sPot] += amount;
				format(string, sizeof(string), "%d Pot has been transfered to your Backpack (%d/%d).", amount, StorageInfo[playerid][1][sPot], backpacklimit[itemid-1]);
				SendClientMessage(playerid, COLOR_WHITE, string);

				if(fromplayerid != -1 && fromstorageid != -1 && playerid != fromplayerid) {
					format(string, sizeof(string), "%d Pot da duoc chuyen vao Briefcase %s cho %s's %s.", amount, storagetype[fromstorageid], GetPlayerNameEx(playerid), storagetype[storageid]);
					SendClientMessage(fromplayerid, COLOR_WHITE, string);

					PlayerPlaySound(fromplayerid, 1052, 0.0, 0.0, 0.0);
					format(string, sizeof(string), "* %s lay mot so %s tu %s, va dua no cho %s.", GetPlayerNameEx(fromplayerid), itemtype[itemid], storagetype[fromstorageid], GetPlayerNameEx(playerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

					new ipplayerid[16], ipfromplayerid[16];
					GetPlayerIp(playerid, ipplayerid, sizeof(ipplayerid));
					GetPlayerIp(fromplayerid, ipfromplayerid, sizeof(ipfromplayerid));

					if(PlayerInfo[fromplayerid][pAdmin] >= 2)
					{
						format(string, sizeof(string), "[Admin] %s (IP:%s) da chuyen %s %s cho %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						Log("logs/adminpay.log", string);
						format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s (IP:%s) da chuyen %s %s cho %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						ABroadCast(COLOR_YELLOW, string, 2);
					}
					else if(PlayerInfo[fromplayerid][pAdmin] < 2)
					{
						format(string, sizeof(string), "%s (IP:%s) da chuyen %s %s cho %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						Log("logs/pay.log", string);

						if(amount >= 100000 && PlayerInfo[fromplayerid][pLevel] <= 3 && itemid == 1) ABroadCast(COLOR_YELLOW, string, 2);
						if(amount >= 1000000 && itemid == 1)	ABroadCast(COLOR_YELLOW,string,2);
					}
				}
				return 1;
			}
			if(itemid == 3 && (StorageInfo[playerid][1][sCrack] + amount <= backpacklimit[itemid-1]))
			{
				// Check if Sending Player has sufficient amount.
				if(fromplayerid != -1 && fromstorageid != -1)
				{
					if(fromstorageid == 0)
					{
						if(PlayerInfo[fromplayerid][pCrack] < amount)
						{
							format(string, sizeof(string), "Ban khong du so luong de cung cap cho $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}
					else
					{
						if(StorageInfo[fromplayerid][fromstorageid-1][sCrack] < amount)
						{
							format(string, sizeof(string), "Ban khong du so luong de cung cap cho $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}

					if(fromstorageid == 0) PlayerInfo[fromplayerid][pCrack] -= amount;
					else StorageInfo[fromplayerid][fromstorageid-1][sCrack] -= amount;
				}
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				StorageInfo[playerid][1][sCrack] += amount;
				format(string, sizeof(string), "%d Crack has been transfered to your Backpack (%d/%d).", amount, StorageInfo[playerid][1][sCrack], backpacklimit[itemid-1]);
				SendClientMessage(playerid, COLOR_WHITE, string);

				if(fromplayerid != -1 && fromstorageid != -1 && playerid != fromplayerid) {
					format(string, sizeof(string), "%d Crack da duoc chuyen vao Briefcase %s cho %s's %s.", amount, storagetype[fromstorageid], GetPlayerNameEx(playerid), storagetype[storageid]);
					SendClientMessage(fromplayerid, COLOR_WHITE, string);

					PlayerPlaySound(fromplayerid, 1052, 0.0, 0.0, 0.0);
					format(string, sizeof(string), "* %s lay mot so %s tu %s, va dua no cho %s.", GetPlayerNameEx(fromplayerid), itemtype[itemid], storagetype[fromstorageid], GetPlayerNameEx(playerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

					new ipplayerid[16], ipfromplayerid[16];
					GetPlayerIp(playerid, ipplayerid, sizeof(ipplayerid));
					GetPlayerIp(fromplayerid, ipfromplayerid, sizeof(ipfromplayerid));

					if(PlayerInfo[fromplayerid][pAdmin] >= 2)
					{
						format(string, sizeof(string), "[Admin] %s (IP:%s) da chuyen %s %s cho %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						Log("logs/adminpay.log", string);
						format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s (IP:%s) da chuyen %s %s cho %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						ABroadCast(COLOR_YELLOW, string, 2);
					}
					else if(PlayerInfo[fromplayerid][pAdmin] < 2)
					{
						format(string, sizeof(string), "%s (IP:%s) da chuyen %s %s cho %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						Log("logs/pay.log", string);

						if(amount >= 100000 && PlayerInfo[fromplayerid][pLevel] <= 3 && itemid == 1) ABroadCast(COLOR_YELLOW, string, 2);
						if(amount >= 1000000 && itemid == 1)	ABroadCast(COLOR_YELLOW,string,2);
					}
				}
				return 1;
			}
			if(itemid == 4 && (StorageInfo[playerid][1][sMats] + amount <= backpacklimit[itemid-1]))
			{
				// Check if Sending Player has sufficient amount.
				if(fromplayerid != -1 && fromstorageid != -1)
				{
					if(fromstorageid == 0)
					{
						if(PlayerInfo[fromplayerid][pMats] < amount)
						{
							format(string, sizeof(string), "Ban khong du so luong de cung cap cho $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}
					else
					{
						if(StorageInfo[fromplayerid][fromstorageid-1][sMats] < amount)
						{
							format(string, sizeof(string), "Ban khong du so luong de cung cap cho $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}

					if(fromstorageid == 0) PlayerInfo[fromplayerid][pMats] -= amount;
					else StorageInfo[fromplayerid][fromstorageid-1][sMats] -= amount;
				}
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				StorageInfo[playerid][1][sMats] += amount;
				format(string, sizeof(string), "%d Vat lieu has been transfered to your Backpack (%d/%d).", amount, StorageInfo[playerid][1][sMats], backpacklimit[itemid-1]);
				SendClientMessage(playerid, COLOR_WHITE, string);

				if(fromplayerid != -1 && fromstorageid != -1 && playerid != fromplayerid) {
					format(string, sizeof(string), "%d Vat lieu da duoc chuyen vao Briefcase %s cho %s's %s.", amount, storagetype[fromstorageid], GetPlayerNameEx(playerid), storagetype[storageid]);
					SendClientMessage(fromplayerid, COLOR_WHITE, string);

					PlayerPlaySound(fromplayerid, 1052, 0.0, 0.0, 0.0);
					format(string, sizeof(string), "* %s lay mot so %s tu %s, va dua no cho %s.", GetPlayerNameEx(fromplayerid), itemtype[itemid], storagetype[fromstorageid], GetPlayerNameEx(playerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

					new ipplayerid[16], ipfromplayerid[16];
					GetPlayerIp(playerid, ipplayerid, sizeof(ipplayerid));
					GetPlayerIp(fromplayerid, ipfromplayerid, sizeof(ipfromplayerid));

					if(PlayerInfo[fromplayerid][pAdmin] >= 2)
					{
						format(string, sizeof(string), "[Admin] %s (IP:%s) da chuyen %s %s cho %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						Log("logs/adminpay.log", string);
						format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s (IP:%s) da chuyen %s %s cho %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						ABroadCast(COLOR_YELLOW, string, 2);
					}
					else if(PlayerInfo[fromplayerid][pAdmin] < 2)
					{
						format(string, sizeof(string), "%s (IP:%s) da chuyen %s %s cho %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						Log("logs/pay.log", string);

						if(amount >= 100000 && PlayerInfo[fromplayerid][pLevel] <= 3 && itemid == 1) ABroadCast(COLOR_YELLOW, string, 2);
						if(amount >= 1000000 && itemid == 1)	ABroadCast(COLOR_YELLOW,string,2);
					}
				}
				return 1;
			}
			if(itemid == 1) format(string, sizeof(string), "Khong the chuyen $%d cho %s ($%d/$%d).", amount, storagetype[storageid], StorageInfo[playerid][1][sCash], backpacklimit[itemid-1]);
			else if(itemid == 2) format(string, sizeof(string), "Khong the chuyen %d %s cho %s (%d/%d).", amount, itemtype[itemid], storagetype[storageid], StorageInfo[playerid][1][sPot], backpacklimit[itemid-1]);
			else if(itemid == 3) format(string, sizeof(string), "Khong the chuyen %d %s cho %s (%d/%d).", amount, itemtype[itemid], storagetype[storageid], StorageInfo[playerid][1][sCrack], backpacklimit[itemid-1]);
			else if(itemid == 4) format(string, sizeof(string), "Khong the chuyen %d %s cho %s (%d/%d).", amount, itemtype[itemid], storagetype[storageid], StorageInfo[playerid][1][sMats], backpacklimit[itemid-1]);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
		}
		case 3: // Briefcase
		{
			if(StorageInfo[playerid][2][sStorage] == 0)
			{
				SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong so huu Briefcase. Ban co the mua tren Gshop (/gshop).");
				return 0;
			}

			if(itemid == 1 && (StorageInfo[playerid][2][sCash] + amount <= briefcaselimit[itemid-1]))
			{
				// Check if Sending Player has sufficient amount.
				if(fromplayerid != -1 && fromstorageid != -1)
				{
					if(fromstorageid == 0)
					{
						if(PlayerInfo[fromplayerid][pCash] < amount)
						{
							format(string, sizeof(string), "Ban khong du so luong de cung cap cho $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}
					else
					{
						if(StorageInfo[fromplayerid][fromstorageid-1][sCash] < amount)
						{
							format(string, sizeof(string), "Ban khong du so luong de cung cap cho $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}

					if(fromstorageid == 0) PlayerInfo[fromplayerid][pCash] -= amount;
					else StorageInfo[fromplayerid][fromstorageid-1][sCash] -= amount;
				}
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				StorageInfo[playerid][2][sCash] += amount;
				format(string, sizeof(string), "$%d da dua dua vao vao tui do cua ban ($%d/$%d).", amount, StorageInfo[playerid][2][sCash], briefcaselimit[itemid-1]);
				SendClientMessage(playerid, COLOR_WHITE, string);

				if(fromplayerid != -1 && fromstorageid != -1 && playerid != fromplayerid) {
					format(string, sizeof(string), "$%d da duoc chuyen vao Briefcase %s cho %s's %s.", amount, storagetype[fromstorageid], GetPlayerNameEx(playerid), storagetype[storageid]);
					SendClientMessage(fromplayerid, COLOR_WHITE, string);

					PlayerPlaySound(fromplayerid, 1052, 0.0, 0.0, 0.0);
					format(string, sizeof(string), "* %s lay mot so %s tu %s, va dua no cho %s.", GetPlayerNameEx(fromplayerid), itemtype[itemid], storagetype[fromstorageid], GetPlayerNameEx(playerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

					new ipplayerid[16], ipfromplayerid[16];
					GetPlayerIp(playerid, ipplayerid, sizeof(ipplayerid));
					GetPlayerIp(fromplayerid, ipfromplayerid, sizeof(ipfromplayerid));

					if(PlayerInfo[fromplayerid][pAdmin] >= 2)
					{
						format(string, sizeof(string), "[Admin] %s (IP:%s) da chuyen %s %s cho %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						Log("logs/adminpay.log", string);
						format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s (IP:%s) da chuyen %s %s cho %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						ABroadCast(COLOR_YELLOW, string, 2);
					}
					else if(PlayerInfo[fromplayerid][pAdmin] < 2)
					{
						format(string, sizeof(string), "%s (IP:%s) da chuyen %s %s cho %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						Log("logs/pay.log", string);

						if(amount >= 100000 && PlayerInfo[fromplayerid][pLevel] <= 3 && itemid == 1) ABroadCast(COLOR_YELLOW, string, 2);
						if(amount >= 1000000 && itemid == 1)	ABroadCast(COLOR_YELLOW,string,2);
					}
				}
				return 1;
			}
			if(itemid == 2 && (StorageInfo[playerid][2][sPot] + amount <= briefcaselimit[itemid-1]))
			{
				// Check if Sending Player has sufficient amount.
				if(fromplayerid != -1 && fromstorageid != -1)
				{
					if(fromstorageid == 0)
					{
						if(PlayerInfo[fromplayerid][pPot] < amount)
						{
							format(string, sizeof(string), "Ban khong du so luong de cung cap cho $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}
					else
					{
						if(StorageInfo[fromplayerid][fromstorageid-1][sPot] < amount)
						{
							format(string, sizeof(string), "Ban khong du so luong de cung cap cho $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}

					if(fromstorageid == 0) PlayerInfo[fromplayerid][pPot] -= amount;
					else StorageInfo[fromplayerid][fromstorageid-1][sPot] -= amount;
				}
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				StorageInfo[playerid][2][sPot] += amount;
				format(string, sizeof(string), "%d Pot da dua dua vao vao tui do cua ban (%d/%d).", amount, StorageInfo[playerid][2][sPot], briefcaselimit[itemid-1]);
				SendClientMessage(playerid, COLOR_WHITE, string);

				if(fromplayerid != -1 && fromstorageid != -1 && playerid != fromplayerid) {
					format(string, sizeof(string), "%d Pot da duoc chuyen vao Briefcase %s cho %s's %s.", amount, storagetype[fromstorageid], GetPlayerNameEx(playerid), storagetype[storageid]);
					SendClientMessage(fromplayerid, COLOR_WHITE, string);

					PlayerPlaySound(fromplayerid, 1052, 0.0, 0.0, 0.0);
					format(string, sizeof(string), "* %s lay mot so %s tu %s, va dua no cho %s.", GetPlayerNameEx(fromplayerid), itemtype[itemid], storagetype[fromstorageid], GetPlayerNameEx(playerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

					new ipplayerid[16], ipfromplayerid[16];
					GetPlayerIp(playerid, ipplayerid, sizeof(ipplayerid));
					GetPlayerIp(fromplayerid, ipfromplayerid, sizeof(ipfromplayerid));

					if(PlayerInfo[fromplayerid][pAdmin] >= 2)
					{
						format(string, sizeof(string), "[Admin] %s (IP:%s) da chuyen %s %s cho %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						Log("logs/adminpay.log", string);
						format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s (IP:%s) da chuyen %s %s cho %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						ABroadCast(COLOR_YELLOW, string, 2);
					}
					else if(PlayerInfo[fromplayerid][pAdmin] < 2)
					{
						format(string, sizeof(string), "%s (IP:%s) da chuyen %s %s cho %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						Log("logs/pay.log", string);

						if(amount >= 100000 && PlayerInfo[fromplayerid][pLevel] <= 3 && itemid == 1) ABroadCast(COLOR_YELLOW, string, 2);
						if(amount >= 1000000 && itemid == 1)	ABroadCast(COLOR_YELLOW,string,2);
					}
				}
				return 1;
			}
			if(itemid == 3 && (StorageInfo[playerid][2][sCrack] + amount <= briefcaselimit[itemid-1]))
			{
				// Check if Sending Player has sufficient amount.
				if(fromplayerid != -1 && fromstorageid != -1)
				{
					if(fromstorageid == 0)
					{
						if(PlayerInfo[fromplayerid][pCrack] < amount)
						{
							format(string, sizeof(string), "Ban khong du so luong de cung cap cho $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}
					else
					{
						if(StorageInfo[fromplayerid][fromstorageid-1][sCrack] < amount)
						{
							format(string, sizeof(string), "Ban khong du so luong de cung cap cho $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}

					if(fromstorageid == 0) PlayerInfo[fromplayerid][pCrack] -= amount;
					else StorageInfo[fromplayerid][fromstorageid-1][sCrack] -= amount;
				}
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				StorageInfo[playerid][2][sCrack] += amount;
				format(string, sizeof(string), "%d Crack da dua dua vao vao tui do cua ban. (%d/%d)", amount, StorageInfo[playerid][2][sCrack], briefcaselimit[itemid-1]);
				SendClientMessage(playerid, COLOR_WHITE, string);

				if(fromplayerid != -1 && fromstorageid != -1 && playerid != fromplayerid) {
					format(string, sizeof(string), "%d Crack da duoc chuyen vao Briefcase %s cho %s's %s.", amount, storagetype[fromstorageid], GetPlayerNameEx(playerid), storagetype[storageid]);
					SendClientMessage(fromplayerid, COLOR_WHITE, string);

					PlayerPlaySound(fromplayerid, 1052, 0.0, 0.0, 0.0);
					format(string, sizeof(string), "* %s lay mot so %s tu %s, va dua no cho %s.", GetPlayerNameEx(fromplayerid), itemtype[itemid], storagetype[fromstorageid], GetPlayerNameEx(playerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

					new ipplayerid[16], ipfromplayerid[16];
					GetPlayerIp(playerid, ipplayerid, sizeof(ipplayerid));
					GetPlayerIp(fromplayerid, ipfromplayerid, sizeof(ipfromplayerid));

					if(PlayerInfo[fromplayerid][pAdmin] >= 2)
					{
						format(string, sizeof(string), "[Admin] %s (IP:%s) da chuyen %s %s cho %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						Log("logs/adminpay.log", string);
						format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s (IP:%s) da chuyen %s %s cho %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						ABroadCast(COLOR_YELLOW, string, 2);
					}
					else if(PlayerInfo[fromplayerid][pAdmin] < 2)
					{
						format(string, sizeof(string), "%s (IP:%s) da chuyen %s %s cho %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						Log("logs/pay.log", string);

						if(amount >= 100000 && PlayerInfo[fromplayerid][pLevel] <= 3 && itemid == 1) ABroadCast(COLOR_YELLOW, string, 2);
						if(amount >= 1000000 && itemid == 1)	ABroadCast(COLOR_YELLOW,string,2);
					}
				}
				return 1;
			}
			if(itemid == 4 && (StorageInfo[playerid][2][sMats] + amount <= briefcaselimit[itemid-1]))
			{
				// Check if Sending Player has sufficient amount.
				if(fromplayerid != -1 && fromstorageid != -1)
				{
					if(fromstorageid == 0)
					{
						if(PlayerInfo[fromplayerid][pMats] < amount)
						{
							format(string, sizeof(string), "Ban khong du so luong de cung cap cho $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}
					else
					{
						if(StorageInfo[fromplayerid][fromstorageid-1][sMats] < amount)
						{
							format(string, sizeof(string), "Ban khong du so luong de cung cap cho $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}

					if(fromstorageid == 0) PlayerInfo[fromplayerid][pMats] -= amount;
					else StorageInfo[fromplayerid][fromstorageid-1][sMats] -= amount;
				}
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				StorageInfo[playerid][2][sMats] += amount;
				format(string, sizeof(string), "%d Vat lieu da dua dua vao vao tui do cua ban (%d/%d).", amount, StorageInfo[playerid][2][sMats], briefcaselimit[itemid-1]);
				SendClientMessage(playerid, COLOR_WHITE, string);

				if(fromplayerid != -1 && fromstorageid != -1 && playerid != fromplayerid) {
					format(string, sizeof(string), "%d Vat lieu da duoc chuyen vao Briefcase %s cho %s's %s.", amount, storagetype[fromstorageid], GetPlayerNameEx(playerid), storagetype[storageid]);
					SendClientMessage(fromplayerid, COLOR_WHITE, string);

					PlayerPlaySound(fromplayerid, 1052, 0.0, 0.0, 0.0);
					format(string, sizeof(string), "* %s lay mot so %s tu %s, va dua no cho %s.", GetPlayerNameEx(fromplayerid), itemtype[itemid], storagetype[fromstorageid], GetPlayerNameEx(playerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

					new ipplayerid[16], ipfromplayerid[16];
					GetPlayerIp(playerid, ipplayerid, sizeof(ipplayerid));
					GetPlayerIp(fromplayerid, ipfromplayerid, sizeof(ipfromplayerid));

					if(PlayerInfo[fromplayerid][pAdmin] >= 2)
					{
						format(string, sizeof(string), "[Admin] %s (IP:%s) da chuyen %s %s cho %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						Log("logs/adminpay.log", string);
						format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s (IP:%s) da chuyen %s %s cho %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						ABroadCast(COLOR_YELLOW, string, 2);
					}
					else if(PlayerInfo[fromplayerid][pAdmin] < 2)
					{
						format(string, sizeof(string), "%s (IP:%s) da chuyen %s %s cho %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						Log("logs/pay.log", string);

						if(amount >= 100000 && PlayerInfo[fromplayerid][pLevel] <= 3 && itemid == 1) ABroadCast(COLOR_YELLOW, string, 2);
						if(amount >= 1000000 && itemid == 1)	ABroadCast(COLOR_YELLOW,string,2);
					}
				}
				return 1;
			}

			if(itemid == 1) format(string, sizeof(string), "Khong the chuyen $%d cho %s ($%d/$%d).", amount, storagetype[storageid], StorageInfo[playerid][2][sCash], briefcaselimit[itemid-1]);
			else if(itemid == 2) format(string, sizeof(string), "Khong the chuyen %d %s cho %s (%d/%d).", amount, itemtype[itemid], storagetype[storageid], StorageInfo[playerid][2][sPot], briefcaselimit[itemid-1]);
			else if(itemid == 3) format(string, sizeof(string), "Khong the chuyen %d %s cho %s (%d/%d).", amount, itemtype[itemid], storagetype[storageid], StorageInfo[playerid][2][sCrack], briefcaselimit[itemid-1]);
			else if(itemid == 4) format(string, sizeof(string), "Khong the chuyen %d %s cho %s (%d/%d).", amount, itemtype[itemid], storagetype[storageid], StorageInfo[playerid][2][sMats], briefcaselimit[itemid-1]);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
		}
	}
	return 0;
}

stock IsAt247(playerid)
{
    new iBusiness = InBusiness(playerid);
   	return (iBusiness != INVALID_BUSINESS_ID && (Businesses[iBusiness][bType] == BUSINESS_TYPE_STORE || Businesses[iBusiness][bType] == BUSINESS_TYPE_GASSTATION));
}

stock IsAtClothingStore(playerid)
{
    new iBusiness = InBusiness(playerid);
   	return (iBusiness != INVALID_BUSINESS_ID && Businesses[iBusiness][bType] == BUSINESS_TYPE_CLOTHING);
}

stock IsAtRestaurant(playerid)
{
	new iBusiness = InBusiness(playerid);
	return (iBusiness != INVALID_BUSINESS_ID && Businesses[iBusiness][bType] == BUSINESS_TYPE_RESTAURANT);
}

stock IsAtGym(playerid)
{
	new iBusiness = InBusiness(playerid);
	return (iBusiness != INVALID_BUSINESS_ID && Businesses[iBusiness][bType] == BUSINESS_TYPE_GYM);
}

stock IsAnSFPDCar(carid)
{
	if(DynVeh[carid] != -1)
	{
	    new iDvSlotID = DynVeh[carid], iGroupID = DynVehicleInfo[iDvSlotID][gv_igID];
	    if((0 <= iGroupID < MAX_GROUPS))
	    {
	    	if(arrGroupData[iGroupID][g_iGroupType] == 4) return 1;
		}
	}
	return 0;
}

stock IsAnAmbulance(carid)
{
	if(DynVeh[carid] != -1)
	{
	    new iDvSlotID = DynVeh[carid], iGroupID = DynVehicleInfo[iDvSlotID][gv_igID];
	    if((0 <= iGroupID < MAX_GROUPS))
	    {
	    	if(arrGroupData[iGroupID][g_iGroupType] == 3) return 1;
		}
	}
	return 0;
}

stock DisplayItemPricesDialog(businessid, playerid)
{

	new szDialog[712], pvar[25], iListIndex, i;
	if (Businesses[businessid][bType] == BUSINESS_TYPE_STORE || Businesses[businessid][bType] == BUSINESS_TYPE_GASSTATION) i = sizeof(StoreItems);
	if (Businesses[businessid][bType] == BUSINESS_TYPE_SEXSHOP) i = sizeof(SexItems);
	if (Businesses[businessid][bType] == BUSINESS_TYPE_RESTAURANT) i = sizeof(RestaurantItems);
	for(new item; item < i; item++)
	{
	    if(Businesses[businessid][bItemPrices][item] == 0) continue;
		new cost = (PlayerInfo[playerid][pDonateRank] >= 1) ? (floatround(Businesses[businessid][bItemPrices][item] * 0.8)) : (Businesses[businessid][bItemPrices][item]);
	    if(Businesses[businessid][bType] == BUSINESS_TYPE_STORE || Businesses[businessid][bType] == BUSINESS_TYPE_GASSTATION)
	    {
	    	format(szDialog, sizeof(szDialog), "%s%i\t%s~n~~g~$%s\n", szDialog,StoreItemsObject[item],StoreItems[item], number_format(cost));
            printf("%d,%s",item,StoreItems[item]);

	    }
	    else if(Businesses[businessid][bType] == BUSINESS_TYPE_SEXSHOP) format(szDialog, sizeof(szDialog), "%s%s  ($%s)\n", szDialog, SexItems[item], number_format(cost));
	    else if(Businesses[businessid][bType] == BUSINESS_TYPE_RESTAURANT) format(szDialog, sizeof(szDialog), "%s%s  ($%s)\n", szDialog, RestaurantItems[item], number_format(cost));
		format(pvar, sizeof(pvar), "Business_MenuItem%d", iListIndex);
		SetPVarInt(playerid, pvar, item + 1);
		printf("%d ilistindex = %d",item+1,iListIndex);
	    format(pvar, sizeof(pvar), "Business_MenuItemPrice%d", iListIndex++);
		SetPVarInt(playerid, pvar, Businesses[businessid][bItemPrices][item]);
	}

   	if(strlen(szDialog) == 0) {
        SendClientMessageEx(playerid, COLOR_GRAD2, "   Cua hang khong con ban mat hang nay!");
    }
    else {
        if (Businesses[businessid][bType] == BUSINESS_TYPE_SEXSHOP)
        {
			ShowPlayerDialog(playerid, SHOPMENU, DIALOG_STYLE_LIST, GetBusinessTypeName(Businesses[businessid][bType]), szDialog, "Mua", "Huy bo");
        }
		else if (Businesses[businessid][bType] == BUSINESS_TYPE_RESTAURANT)
		{
			ShowPlayerDialog(playerid, RESTAURANTMENU2, DIALOG_STYLE_LIST, GetBusinessTypeName(Businesses[businessid][bType]), szDialog, "Mua", "Huy bo");
		}
        else
        {
    		ShowPlayerDialog(playerid, STOREMENU, DIALOG_STYLE_PREVIEW_MODEL, GetBusinessTypeName(Businesses[businessid][bType]), szDialog, "Mua", "Huy bo");
		}
    }
}

stock CuffTacklee(playerid, giveplayerid)
{
	new string[128], Float: health, Float: armor;
    ClearTackle(giveplayerid);
	format(string, sizeof(string), "* Ban da bi cong tay boi %s.", GetPlayerNameEx(playerid));
	SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
	format(string, sizeof(string), "* Ban cong tay %s.", GetPlayerNameEx(giveplayerid));
	SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	format(string, sizeof(string), "* %s khoa tay %s va that chat cong an toan.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
	ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	GameTextForPlayer(giveplayerid, "~r~Cong tay", 2500, 3);
	TogglePlayerControllable(giveplayerid, 0);
	ClearAnimations(giveplayerid);
	ClearAnimations(playerid);
	GetPlayerHealth(giveplayerid, health);
	GetPlayerArmour(giveplayerid, armor);
	SetPVarFloat(giveplayerid, "cuffhealth",health);
	SetPVarFloat(giveplayerid, "cuffarmor",armor);
	SetPlayerSpecialAction(giveplayerid, SPECIAL_ACTION_CUFFED);
	ApplyAnimation(giveplayerid,"ped","cower",1,1,0,0,0,0,1);
	PlayerCuffed[giveplayerid] = 2;
	SetPVarInt(giveplayerid, "PlayerCuffed", 2);
	SetPVarInt(giveplayerid, "IsFrozen", 1);
	//Frozen[giveplayerid] = 1;
	PlayerCuffedTime[giveplayerid] = 300;
	PlayerFacePlayer(playerid, giveplayerid);
	return 1;
}

stock StaffAccountCheck(playerid, ip[])
{
	new string[128];
	format(string, sizeof(string), "SELECT NULL FROM `accounts` WHERE (`IP` = '%s' OR `SecureIP` = '%s') AND `AdminLevel` > 0", ip, ip);
	mysql_function_query(MainPipeline, string, false, "OnStaffAccountCheck", "i", playerid);
}

stock GetStaffRank(playerid)
{
	new string[42];

	if(PlayerInfo[playerid][pHelper] > 0)
	{
		switch(PlayerInfo[playerid][pHelper])
		{
			case 1: format(string, sizeof(string), "{6495ED}Helper{FFFFFF}");
			case 2: format(string, sizeof(string), "{00FFFF}Community Advisor{FFFFFF}");
			case 3: format(string, sizeof(string), "{00FFFF}Senior Advisor{FFFFFF}");
			case 4: format(string, sizeof(string), "{00FFFF}Chief Advisor{FFFFFF}");
		}
	}
	else if(PlayerInfo[playerid][pAdmin] == 1)
	{
		switch(PlayerInfo[playerid][pSMod])
		{
			case 0: format(string, sizeof(string), "{FFFF00}Server Moderator{FFFFFF}");
			case 1: format(string, sizeof(string), "{FFFF00}Senior Server Moderator{FFFFFF}");
		}
	}
	else if(PlayerInfo[playerid][pAdmin] > 1)
	{
		switch(PlayerInfo[playerid][pAdmin])
		{
			case 2: format(string, sizeof(string), "{00FF00}Junior Administrator{FFFFFF}");
			case 3: format(string, sizeof(string), "{00FF00}General Administrator{FFFFFF}");
			case 4: format(string, sizeof(string), "{F4A460}Senior Administrator{FFFFFF}");
			case 1337: format(string, sizeof(string), "{FF0000}Head Administrator{FFFFFF}");
			case 1338: format(string, sizeof(string), "{298EFF}Director Administrator{FFFFFF}");
			case 99999: format(string, sizeof(string), "{298EFF}Executive Administrator{FFFFFF}");
			default: format(string, sizeof(string), "Undefined Administrator (%d)", PlayerInfo[playerid][pAdmin]);
		}
	}
	return string;
}

LoadPlayerDisabledVehicles(playerid)
{
	new vehiclecount;
	switch(PlayerInfo[playerid][pDonateRank]) {
		case 0: {
			for(new v = 0; v < MAX_PLAYERVEHICLES; v++)
			{
				vehiclecount++;
				if(PlayerInfo[playerid][pVehicleSlot] + 6 <= vehiclecount) {
					PlayerVehicleInfo[playerid][v][pvDisabled] = 1;
				} else {
					PlayerVehicleInfo[playerid][v][pvDisabled] = 0;
				}
			}
		}
		case 1: {
            for(new v = 0; v < MAX_PLAYERVEHICLES; v++)
			{
				vehiclecount++;
				if(PlayerInfo[playerid][pVehicleSlot] + 7 <= vehiclecount) {
					PlayerVehicleInfo[playerid][v][pvDisabled] = 1;
				} else {
					PlayerVehicleInfo[playerid][v][pvDisabled] = 0;
				}
			}
		}
		case 2: {
            for(new v = 0; v < MAX_PLAYERVEHICLES; v++)
			{
				vehiclecount++;
				if(PlayerInfo[playerid][pVehicleSlot] + 8 <= vehiclecount) {
					PlayerVehicleInfo[playerid][v][pvDisabled] = 1;
				} else {
					PlayerVehicleInfo[playerid][v][pvDisabled] = 0;
				}
			}
        }
		case 3: {
            for(new v = 0; v < MAX_PLAYERVEHICLES; v++)
			{
				vehiclecount++;
				if(PlayerInfo[playerid][pVehicleSlot] + 9 <= vehiclecount) {
					PlayerVehicleInfo[playerid][v][pvDisabled] = 1;
				} else {
					PlayerVehicleInfo[playerid][v][pvDisabled] = 0;
				}
			}
        }
        default: {
        	for(new v = 0; v < MAX_PLAYERVEHICLES; v++)
			{
				vehiclecount++;
				if(PlayerInfo[playerid][pVehicleSlot] + 11 <= vehiclecount) {
					PlayerVehicleInfo[playerid][v][pvDisabled] = 1;
				} else {
					PlayerVehicleInfo[playerid][v][pvDisabled] = 0;
				}
			}
        }
	}
	return 1;
}

stock CompleteToyTrade(playerid)
{
	new string[156],
		sellerid = GetPVarInt(playerid, "ttSeller"),
		name[24],
		toyid = GetPVarInt(sellerid, "ttToy");

	for(new i;i<sizeof(HoldingObjectsAll);i++)
	{
		if(HoldingObjectsAll[i][holdingmodelid] == toyid)
		{
			format(name, sizeof(name), "(%s)", HoldingObjectsAll[i][holdingmodelname]);
		}
	}
	if(toyid != 0 && (strcmp(name, "None", true) == 0))
	{
		format(name, sizeof(name), "(ID: %d)", toyid);
	}

	new icount = GetPlayerToySlots(playerid);

	if(!toyCountCheck(playerid))
	{
		format(string, sizeof(string), "%s da tu choi mua do choi. (Da het slot toys)", GetPlayerNameEx(playerid));
		SendClientMessageEx(sellerid, COLOR_GREY, string);
		SendClientMessageEx(playerid, COLOR_GREY, "Ban khong con slot toys.");
		SetPVarInt(GetPVarInt(playerid, "ttSeller"), "ttBuyer", INVALID_PLAYER_ID);
		SetPVarInt(GetPVarInt(playerid, "ttSeller"), "ttCost", 0);
		SetPVarInt(playerid, "ttSeller", INVALID_PLAYER_ID);

		HideTradeToysGUI(playerid);
		return 1;
	}

	if(GetPlayerCash(playerid) < GetPVarInt(sellerid, "ttCost"))
	{
		format(string, sizeof(string), "%s da tu choi mua do choi. (Khong du tien)", GetPlayerNameEx(playerid));
		SendClientMessageEx(sellerid, COLOR_GREY, string);
		SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co du tien mat.");
		SetPVarInt(GetPVarInt(playerid, "ttSeller"), "ttBuyer", INVALID_PLAYER_ID);
		SetPVarInt(GetPVarInt(playerid, "ttSeller"), "ttCost", 0);
		SetPVarInt(playerid, "ttSeller", INVALID_PLAYER_ID);

		HideTradeToysGUI(playerid);
		return 1;
	}

	GivePlayerMoneyEx(playerid, -GetPVarInt(sellerid, "ttCost"));
	GivePlayerMoneyEx(sellerid, GetPVarInt(sellerid, "ttCost"));

	for(new i = 0; i < icount; i++)
	{
		if(!PlayerToyInfo[playerid][i][ptModelID])
		{
			PlayerToyInfo[playerid][i][ptModelID] = toyid;
			PlayerToyInfo[playerid][i][ptBone] = 1; // Doesn't need to be accurate, you can let the player choose.
			PlayerToyInfo[playerid][i][ptPosX] = 1.0;
			PlayerToyInfo[playerid][i][ptPosY] = 1.0;
			PlayerToyInfo[playerid][i][ptPosZ] = 1.0;
			PlayerToyInfo[playerid][i][ptRotX] = 0.0;
			PlayerToyInfo[playerid][i][ptRotY] = 0.0;
			PlayerToyInfo[playerid][i][ptRotZ] = 0.0;
			PlayerToyInfo[playerid][i][ptScaleX] = 1.0;
			PlayerToyInfo[playerid][i][ptScaleY] = 1.0;
			PlayerToyInfo[playerid][i][ptScaleZ] = 1.0;
			PlayerToyInfo[playerid][i][ptTradable] = 1;

			if(PlayerToyInfo[playerid][i][ptSpecial] == 1)
			{
				PlayerToyInfo[playerid][i][ptSpecial] = 0;
			}

			// Seller
			format(string, sizeof(string), "DELETE FROM `toys` WHERE `id` = '%d'", PlayerToyInfo[sellerid][GetPVarInt(sellerid, "ttToySlot")][ptID]);
			mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "ii", SENDDATA_THREAD, sellerid);

			g_mysql_NewToy(playerid, i);
			break;
		}
	}

	PlayerToyInfo[sellerid][GetPVarInt(sellerid, "ttToySlot")][ptID] = 0;
	PlayerToyInfo[sellerid][GetPVarInt(sellerid, "ttToySlot")][ptModelID] = 0;
	PlayerToyInfo[sellerid][GetPVarInt(sellerid, "ttToySlot")][ptBone] = 0;

	OnPlayerStatsUpdate(playerid);
	OnPlayerStatsUpdate(sellerid);

	format(string, sizeof(string), "%s da chap nhan de nghi mua do choi cua ban voi gia $%s. %s", GetPlayerNameEx(playerid), number_format(GetPVarInt(sellerid, "ttCost")), name);
	SendClientMessageEx(sellerid, COLOR_LIGHTBLUE, string);
	format(string, sizeof(string), "Ban da chap nhan mua do choi cua %s's voi gia $%s. %s", GetPlayerNameEx(sellerid), number_format(GetPVarInt(sellerid, "ttCost")), name);
	SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	format(string, sizeof(string), "[S %s(%d)][IP %s][B %s(%d)][IP %s][P $%s][T: %s(%d)]", GetPlayerNameEx(sellerid), GetPlayerSQLId(sellerid), GetPlayerIpEx(sellerid),
	GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(GetPVarInt(sellerid, "ttCost")), name, toyid);
	Log("logs/toys.log", string);

	SetPVarInt(GetPVarInt(playerid, "ttSeller"), "ttSeller", INVALID_PLAYER_ID);
	SetPVarInt(GetPVarInt(playerid, "ttSeller"), "ttBuyer", INVALID_PLAYER_ID);
	SetPVarInt(GetPVarInt(playerid, "ttSeller"), "ttCost", 0);
	SetPVarInt(playerid, "ttSeller", INVALID_PLAYER_ID);

	HideTradeToysGUI(playerid);
	return 1;
}

forward RFLCheckpointu(playerid);
public RFLCheckpointu(playerid)
{
	SetPlayerCheckpoint(playerid, EventRCPX[ConfigEventCPId[playerid]], EventRCPY[ConfigEventCPId[playerid]], EventRCPZ[ConfigEventCPId[playerid]], EventRCPS[ConfigEventCPId[playerid]]);
}

forward FixServerTime();
public FixServerTime()
{
	gettime(ghour, gminute, gsecond);
	FixHour(ghour);
	ghour = shifthour;

	new tmphour;
	new tmpminute;
	new tmpsecond;
	gettime(tmphour, tmpminute, tmpsecond);
	FixHour(tmphour);
	tmphour = shifthour;
//	SetWorldTime(tmphour);
	print("Adjusted the server time...");
	return 1;
}

forward ResetVariables();
public ResetVariables()
{
	for(new i = 1; i < MAX_VEHICLES; i++)  {
		DynVeh[i] = -1;
		TruckDeliveringTo[i] = INVALID_BUSINESS_ID;
	}

	if(Jackpot < 0) Jackpot = 0;
	if(TaxValue < 0) TaxValue = 0;

	for(new i = 0; i < MAX_VEHICLES; ++i) {
		VehicleFuel[i] = 100.0;
	}
	for(new i = 0; i < sizeof(CreatedCars); ++i) {
		CreatedCars[i] = INVALID_VEHICLE_ID;
	}

	EventKernel[EventRequest] = INVALID_PLAYER_ID;
	EventKernel[EventCreator] = INVALID_PLAYER_ID;
	for(new x; x < sizeof(EventKernel[EventStaff]); x++) {
		EventKernel[EventStaff][x] = INVALID_PLAYER_ID;
	}
	print("Resetting default server variables..");
	return 1;
}

forward ResetNews();
public ResetNews()
{
	News[hTaken1] = 0; News[hTaken2] = 0; News[hTaken3] = 0; News[hTaken4] = 0; News[hTaken5] = 0;
	strcat(News[hAdd1], "Nothing");
	strcat(News[hAdd2], "Nothing");
	strcat(News[hAdd3], "Nothing");
	strcat(News[hAdd4], "Nothing");
	strcat(News[hAdd5], "Nothing");
	strcat(News[hContact1], "No-one");
	strcat(News[hContact2], "No-one");
	strcat(News[hContact3], "No-one");
	strcat(News[hContact4], "No-one");
	strcat(News[hContact5], "No-one");
	print("Resetting news...");
	return 1;
}

forward SpecUpdate(playerid);
public SpecUpdate(playerid)
{
	if(Spectating[playerid] > 0 && Spectate[playerid] != INVALID_PLAYER_ID) {
		for(new i = 0; i < 2; i++) {
			TogglePlayerSpectating(playerid, true);
			PlayerSpectatePlayer( playerid, Spectate[playerid] );
			SetPlayerInterior( playerid, GetPlayerInterior( Spectate[playerid] ) );
			SetPlayerVirtualWorld( playerid, GetPlayerVirtualWorld( Spectate[playerid] ) );
		}
	}
	return 1;
}

forward Float: GetPlayerSpeed(playerid);
public Float: GetPlayerSpeed(playerid)
{
	new Float: fVelocity[3];
	GetPlayerVelocity(playerid, fVelocity[0], fVelocity[1], fVelocity[2]);
	return floatsqroot((fVelocity[0] * fVelocity[0]) + (fVelocity[1] * fVelocity[1]) + (fVelocity[2] * fVelocity[2])) * 100;
}

stock ShowVouchers(playerid, targetid)
{
	if(IsPlayerConnected(targetid))
	{
		new szDialog[1024], szTitle[MAX_PLAYER_NAME+9];
		SetPVarInt(playerid, "WhoIsThis", targetid);

		format(szTitle, sizeof(szTitle), "%s Vouchers", GetPlayerNameEx(targetid));
		format(szDialog, sizeof(szDialog), "Car Voucher(s):\t\t\t{18F0F0}%d\nSilver VIP Voucher(s):\t\t{18F0F0}%d\nGold VIP Voucher(s):\t\t{18F0F0}%d\nPlatinum VIP Voucher(s):\t{18F0F0}%d\nRestricted Car Voucher(s):\t{18F0F0}%d\nGift Reset Voucher(s):\t\t{18F0F0}%d\n" \
		"Priority Advert Voucher(s):\t{18F0F0}%d\n7 Ngay SVIP Voucher(s): \t{18F0F0}%d\n7 Ngay GVIP Voucher(s):\t{18F0F0}%d\n",
		PlayerInfo[targetid][pVehVoucher], PlayerInfo[targetid][pSVIPVoucher], PlayerInfo[targetid][pGVIPVoucher], PlayerInfo[targetid][pPVIPVoucher], PlayerInfo[targetid][pCarVoucher], PlayerInfo[targetid][pGiftVoucher], PlayerInfo[targetid][pAdvertVoucher], PlayerInfo[targetid][pSVIPExVoucher], PlayerInfo[targetid][pGVIPExVoucher]);
		ShowPlayerDialog(playerid, DIALOG_VOUCHER, DIALOG_STYLE_LIST, szTitle, szDialog, "Lua chon", "Dong lai");
	}
	return 1;
}

stock SpectatePlayer(playerid, giveplayerid)
{
	if(IsPlayerConnected(giveplayerid)) {
		if( InsideTut{giveplayerid} >= 1 ) {
			SendClientMessageEx(playerid, COLOR_WHITE, "NOTE: Nguoi nay dang trong bai tro giup huong dan tham gia server.");
		}
		if(Spectating[playerid] == 0) {
			new Float: pPositions[3];
			GetPlayerPos(playerid, pPositions[0], pPositions[1], pPositions[2]);
			SetPVarFloat(playerid, "SpecPosX", pPositions[0]);
			SetPVarFloat(playerid, "SpecPosY", pPositions[1]);
			SetPVarFloat(playerid, "SpecPosZ", pPositions[2]);
			SetPVarInt(playerid, "SpecInt", GetPlayerInterior(playerid));
			SetPVarInt(playerid, "SpecVW", GetPlayerVirtualWorld(playerid));
			if(IsPlayerInAnyVehicle(giveplayerid)) {
				TogglePlayerSpectating(playerid, true);
				new carid = GetPlayerVehicleID( giveplayerid );
				PlayerSpectateVehicle( playerid, carid );
				SetPlayerInterior( playerid, GetPlayerInterior( giveplayerid ) );
				SetPlayerVirtualWorld( playerid, GetPlayerVirtualWorld( giveplayerid ) );
			}
			else if(InsidePlane[giveplayerid] != INVALID_VEHICLE_ID) {
				TogglePlayerSpectating(playerid, true);
				PlayerSpectateVehicle(playerid, InsidePlane[giveplayerid]);
				SetPlayerInterior(playerid, GetPlayerInterior(giveplayerid));
				SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(giveplayerid));
			}
			else {
				for(new i = 0; i < 2; i++) {
					TogglePlayerSpectating(playerid, true);
					PlayerSpectatePlayer( playerid, giveplayerid );
					SetPlayerInterior( playerid, GetPlayerInterior( giveplayerid ) );
					SetPlayerVirtualWorld( playerid, GetPlayerVirtualWorld( giveplayerid ) );
				}
			}
			GettingSpectated[giveplayerid] = playerid;
			Spectate[playerid] = giveplayerid;
			Spectating[playerid] = 1;
		}
		else {
			if(IsPlayerInAnyVehicle(giveplayerid)) {
				TogglePlayerSpectating(playerid, true);
				new carid = GetPlayerVehicleID( giveplayerid );
				PlayerSpectateVehicle( playerid, carid );
				SetPlayerInterior( playerid, GetPlayerInterior( giveplayerid ) );
				SetPlayerVirtualWorld( playerid, GetPlayerVirtualWorld( giveplayerid ) );
			}
			else if(InsidePlane[giveplayerid] != INVALID_VEHICLE_ID) {
				TogglePlayerSpectating(playerid, true);
				PlayerSpectateVehicle(playerid, InsidePlane[giveplayerid]);
				SetPlayerInterior(playerid, GetPlayerInterior(giveplayerid));
				SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(giveplayerid));
			}
			else {
				for(new i = 0; i < 2; i++) {
					TogglePlayerSpectating(playerid, true);
					PlayerSpectatePlayer( playerid, giveplayerid );
					SetPlayerInterior( playerid, GetPlayerInterior( giveplayerid ) );
					SetPlayerVirtualWorld( playerid, GetPlayerVirtualWorld( giveplayerid ) );
				}
			}
			GettingSpectated[Spectate[playerid]] = INVALID_PLAYER_ID;
			GettingSpectated[giveplayerid] = playerid;
			Spectate[playerid] = giveplayerid;
			Spectating[playerid] = 1;
		}
		new string[64];
		format(string, sizeof(string), "Ban dang theo doi %s (ID: %d).", GetPlayerNameEx(giveplayerid), giveplayerid);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
	}
	return 1;
}

forward ForceSpawn(playerid);
public ForceSpawn(playerid)
{
	SpawnPlayer(playerid);
	return 1;
}

stock MoveAutomaticGate(playerid, gateid)
{
	MoveDynamicObject(GateInfo[gateid][gGATE], GateInfo[gateid][gPosXM], GateInfo[gateid][gPosYM], GateInfo[gateid][gPosZM], GateInfo[gateid][gSpeed], GateInfo[gateid][gRotXM], GateInfo[gateid][gRotYM], GateInfo[gateid][gRotZM]);
	GateInfo[gateid][gStatus] = 1;
	switch(GateInfo[gateid][gTimer])
	{
		case 1: SetTimerEx("AutomaticGateTimerClose", 3000, false, "ii", playerid, gateid);
		case 2: SetTimerEx("AutomaticGateTimerClose", 5000, false, "ii", playerid, gateid);
		case 3: SetTimerEx("AutomaticGateTimerClose", 8000, false, "ii", playerid, gateid);
		case 4: SetTimerEx("AutomaticGateTimerClose", 10000, false, "ii", playerid, gateid);
		default: SetTimerEx("AutomaticGateTimerClose", 3000, false, "ii", playerid, gateid);
	}
	return 1;
}

forward AutomaticGateTimer(playerid, gateid);
public AutomaticGateTimer(playerid, gateid)
{
	if(GateInfo[gateid][gLocked] == 0)
	{
		if(GateInfo[gateid][gStatus] == 0 && IsPlayerInRangeOfPoint(playerid, GateInfo[gateid][gRange], GateInfo[gateid][gPosX], GateInfo[gateid][gPosY], GateInfo[gateid][gPosZ]))
		{
			if(GateInfo[gateid][gFamilyID] != -1 && PlayerInfo[playerid][pFMember] == GateInfo[gateid][gFamilyID]) MoveAutomaticGate(playerid, gateid);
			else if(GateInfo[gateid][gGroupID] != -1 && (0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS) && PlayerInfo[playerid][pMember] == GateInfo[gateid][gGroupID]) MoveAutomaticGate(playerid, gateid);
			else if(GateInfo[gateid][gAllegiance] != 0 && GateInfo[gateid][gGroupType] != 0 && (0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS) && arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance] == GateInfo[gateid][gAllegiance] && arrGroupData[PlayerInfo[playerid][pMember]][g_iGroupType] == GateInfo[gateid][gGroupType]) MoveAutomaticGate(playerid, gateid);
			else if(GateInfo[gateid][gAllegiance] != 0 && GateInfo[gateid][gGroupType] == 0 && (0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS) && arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance] == GateInfo[gateid][gAllegiance]) MoveAutomaticGate(playerid, gateid);
			else if(GateInfo[gateid][gAllegiance] == 0 && GateInfo[gateid][gGroupType] != 0 && (0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS) && arrGroupData[PlayerInfo[playerid][pMember]][g_iGroupType] == GateInfo[gateid][gGroupType]) MoveAutomaticGate(playerid, gateid);
			else MoveAutomaticGate(playerid, gateid);
		}
		SetTimerEx("AutomaticGateTimer", 1000, false, "ii", playerid, gateid);
	}
	else
	{
		if(GateInfo[gateid][gStatus] == 1 && !IsPlayerInRangeOfPoint(playerid, GateInfo[gateid][gRange], GateInfo[gateid][gPosXM], GateInfo[gateid][gPosYM], GateInfo[gateid][gPosZM]))
		{
			MoveDynamicObject(GateInfo[gateid][gGATE], GateInfo[gateid][gPosX], GateInfo[gateid][gPosY], GateInfo[gateid][gPosZ], GateInfo[gateid][gSpeed], GateInfo[gateid][gRotX], GateInfo[gateid][gRotY], GateInfo[gateid][gRotZ]);
			SetTimerEx("AutomaticGateTimer", 1000, false, "ii", playerid, gateid);
			GateInfo[gateid][gStatus] = 0;
			return 1;
		}
	}
	return 1;
}

forward AutomaticGateTimerClose(playerid, gateid);
public AutomaticGateTimerClose(playerid, gateid)
{
	if(GateInfo[gateid][gLocked] == 0)
	{
		if(GateInfo[gateid][gStatus] == 1 && !IsPlayerInRangeOfPoint(playerid, GateInfo[gateid][gRange], GateInfo[gateid][gPosXM], GateInfo[gateid][gPosYM], GateInfo[gateid][gPosZM]))
		{
			MoveDynamicObject(GateInfo[gateid][gGATE], GateInfo[gateid][gPosX], GateInfo[gateid][gPosY], GateInfo[gateid][gPosZ], GateInfo[gateid][gSpeed], GateInfo[gateid][gRotX], GateInfo[gateid][gRotY], GateInfo[gateid][gRotZ]);
			SetTimerEx("AutomaticGateTimer", 1000, false, "ii", playerid, gateid);
			GateInfo[gateid][gStatus] = 0;
			return 1;
		}
		switch(GateInfo[gateid][gTimer])
		{
			case 1: SetTimerEx("AutomaticGateTimerClose", 3000, false, "ii", playerid, gateid);
			case 2: SetTimerEx("AutomaticGateTimerClose", 5000, false, "ii", playerid, gateid);
			case 3: SetTimerEx("AutomaticGateTimerClose", 8000, false, "ii", playerid, gateid);
			case 4: SetTimerEx("AutomaticGateTimerClose", 10000, false, "ii", playerid, gateid);
			default: SetTimerEx("AutomaticGateTimerClose", 3000, false, "ii", playerid, gateid);
		}
	}
	else
	{
		if(GateInfo[gateid][gStatus] == 1 && !IsPlayerInRangeOfPoint(playerid, GateInfo[gateid][gRange], GateInfo[gateid][gPosXM], GateInfo[gateid][gPosYM], GateInfo[gateid][gPosZM]))
		{
			MoveDynamicObject(GateInfo[gateid][gGATE], GateInfo[gateid][gPosX], GateInfo[gateid][gPosY], GateInfo[gateid][gPosZ], GateInfo[gateid][gSpeed], GateInfo[gateid][gRotX], GateInfo[gateid][gRotY], GateInfo[gateid][gRotZ]);
			SetTimerEx("AutomaticGateTimer", 1000, false, "ii", playerid, gateid);
			GateInfo[gateid][gStatus] = 0;
			return 1;
		}
	}
	return 1;
}

stock NextAvailableBackpack()
{
	if(hgBackpackCount+1 == 200) return false;
	return hgBackpackCount+1;
}

stock GetBackpackName(id)
{
	new string[24];
	switch(HungerBackpackInfo[id][hgBackpackType])
	{
		case 1: format(string, sizeof(string), "15 phan tram giap");
		case 2: format(string, sizeof(string), "Vu khi ngau nhien");
		case 3: format(string, sizeof(string), "Day no bug");
		case 4: format(string, sizeof(string), "Day mau");
		default: format(string, sizeof(string), "NULL");
	}
	return string;
}

forward LoginCheck(playerid);
public LoginCheck(playerid)
{
	if(gPlayerLogged{playerid} == 0 && IsPlayerConnected(playerid))
	{
		new string[128];
		format(string, sizeof(string), "%s [%s] da tam ngung ket noi tai man hinh dang nhap.", GetPlayerNameEx(playerid), GetPlayerIpEx(playerid));
		Log("logs/security.log", string);
		SendClientMessage(playerid, COLOR_WHITE, "(SERVER) Dang nhap tai khoan khong co phan hoi, ban vui long thu lai sau 60s!");
		ShowPlayerDialog(playerid, -1, DIALOG_STYLE_MSGBOX, "", "", "", "");
		SetTimerEx("KickEx", 1000, 0, "i", playerid);
	}
	return 1;
}

stock ShowLoginDialogs(playerid, index)
{
	switch(index)
	{
 		case 0: ShowPlayerDialog(playerid, REGISTERSEX, DIALOG_STYLE_LIST, "{FF0000}Gioi tinh cua nhan vat ban la gi?", "Nam\nNu", "Chon", "");
		case 1: ShowPlayerDialog(playerid, PMOTDNOTICE, DIALOG_STYLE_MSGBOX, "Notice", pMOTD, "Dismiss", "");
	}
}

stock InvalidEmailCheck(playerid, email[])
{
	new string[128];
	if(GetPVarInt(playerid, "NullEmail") == 1)
	{
		SetPVarString(playerid, "pTmpEmail", email);
		format(string, sizeof(string), "%s/checks/email.php?check=2&email=%s&id=%d", SAMP_WEB, email, GetPlayerSQLId(playerid));
		HTTP(playerid, HTTP_GET, string, "", "OnInvalidEmailCheck");
	}
	else if(GetPVarInt(playerid, "NullEmail") == 2)
	{
		format(string, sizeof(string), "%s/checks/email.php?check=3&email=%s&id=%d", SAMP_WEB, email, GetPlayerSQLId(playerid));
		HTTP(playerid, HTTP_GET, string, "", "OnInvalidEmailCheck");
		DeletePVar(playerid, "pTmpEmail");
	}
	else if(GetPVarInt(playerid, "NullEmail") == 3)
	{
		ShowPlayerDialog(playerid, EMAIL_VALIDATION, DIALOG_STYLE_MSGBOX, "Email xac minh", "Dia chi email cua ban dang cho de xac minh, xin vui long kiem tra hop thu cua ban\n\nMa xac nhan se hieu luc sau 1 gio", "Dong lai", "");
	}
	else
	{
		SetPVarString(playerid, "pTmpEmail", email);
		format(string, sizeof(string), "%s/checks/email.php?check=1&email=%s&id=%d", SAMP_WEB, email, GetPlayerSQLId(playerid));
		HTTP(playerid, HTTP_GET, string, "", "OnInvalidEmailCheck");
	}
	return 1;
}

forward OnInvalidEmailCheck(playerid, response_code, data[]);
public OnInvalidEmailCheck(playerid, response_code, data[])
{
	new result = strval(data);
	if(result == 0)
	{
		SetPVarInt(playerid, "NullEmail", 1);
		ShowLoginDialogs(playerid, 2);
	}
	else if(result == 1) ShowPlayerDialog(playerid, NULLEMAIL, DIALOG_STYLE_INPUT, "{3399FF}Dang ki Email", "{FFFFFF}XIn vui long nhap Email hop le de xac nhan tai khoan.", "Xac nhan", "Bo qua");
	else if(result == 2)
	{
		new tmpEmail[128];
		GetPVarString(playerid, "pTmpEmail", tmpEmail, sizeof(tmpEmail));
		SetPVarInt(playerid, "NullEmail", 2);
		InvalidEmailCheck(playerid, tmpEmail);
	}
	else if(result == 3)
	{
		DeletePVar(playerid, "NullEmail");
		ShowPlayerDialog(playerid, EMAIL_VALIDATION, DIALOG_STYLE_MSGBOX, "Xac minh Email", "Ma xac nhan da duoc gui ve Email cua ban\n\nMa xac nhan se hieu luc trong 1gio.", "Dong lai", "");
	}
	else if(result == 4)
	{
		DeletePVar(playerid, "NullEmail");
		DeletePVar(playerid, "pTmpEmail");
		return 1;
	}
	return 1;
}

stock IsEmailPending(playerid, SQLid, email[])
{
	new query[128];
	format(query, sizeof(query), "SELECT NULL FROM `cp_cache_email` WHERE `user_id` = %d", SQLid);
	return mysql_function_query(MainPipeline, query, false, "OnIsEmailPending", "is", playerid, email);
}

forward OnIsEmailPending(playerid, email[]);
public OnIsEmailPending(playerid, email[])
{
	new rows, fields;
	cache_get_data(rows, fields, MainPipeline);
	if(rows > 0)
	{
		SetPVarInt(playerid, "NullEmail", 3);
		ShowLoginDialogs(playerid, 3);
	}
	else InvalidEmailCheck(playerid, email);
	return 1;
}

stock ShowPlayerDynamicGiftBox(playerid)
{
	new string[1024];

	format(string, sizeof(string), "{1B7A3C}Giftbox Settings{FFFFFF}");
	if(dgMoney[0] == 1)
		format(string, sizeof(string), "%s\n{00FF61}Money", string);
	else
		format(string, sizeof(string), "%s\n{F2070B}Money", string);
	if(dgRimKit[0] == 1)
		format(string, sizeof(string), "%s\n{00FF61}Rimkit", string);
	else
		format(string, sizeof(string), "%s\n{F2070B}Rimkit", string);
	if(dgFirework[0] == 1)
		format(string, sizeof(string), "%s\n{00FF61}Firework", string);
	else
		format(string, sizeof(string), "%s\n{F2070B}Firework", string);
	if(dgGVIP[0] == 1)
		format(string, sizeof(string), "%s\n{00FF61}7 Ngay Gold VIP", string);
	else
		format(string, sizeof(string), "%s\n{F2070B}7 Ngay Gold VIP", string);
	if(dgGVIPEx[0] == 1)
		format(string, sizeof(string), "%s\n{00FF61}1 Thang Gold VIP", string);
	else
		format(string, sizeof(string), "%s\n{F2070B}1 Thang Gold VIP", string);
	if(dgSVIP[0] == 1)
		format(string, sizeof(string), "%s\n{00FF61}7 Ngay Silver VIP", string);
	else
		format(string, sizeof(string), "%s\n{F2070B}7 Ngay Silver VIP", string);
	if(dgSVIPEx[0] == 1)
		format(string, sizeof(string), "%s\n{00FF61}1 Thang Silver VIP", string);
	else
		format(string, sizeof(string), "%s\n{F2070B}1 Thang Silver VIP", string);
	if(dgCarSlot[0] == 1)
		format(string, sizeof(string), "%s\n{00FF61}Car Slot", string);
	else
		format(string, sizeof(string), "%s\n{F2070B}Car Slot", string);
	if(dgToySlot[0] == 1)
		format(string, sizeof(string), "%s\n{00FF61}Toy Slot", string);
	else
		format(string, sizeof(string), "%s\n{F2070B}Toy Slot", string);
	if(dgArmor[0] == 1)
		format(string, sizeof(string), "%s\n{00FF61}Full Armor", string);
	else
		format(string, sizeof(string), "%s\n{F2070B}Full Armor", string);
	if(dgFirstaid[0] == 1)
		format(string, sizeof(string), "%s\n{00FF61}Firstaid", string);
	else
		format(string, sizeof(string), "%s\n{F2070B}Firstaid", string);
	if(dgDDFlag[0] == 1)
		format(string, sizeof(string), "%s\n{00FF61}Dynamic Door Flag", string);
	else
		format(string, sizeof(string), "%s\n{F2070B}Dynamic Door Flag", string);
	if(dgGateFlag[0] == 1)
		format(string, sizeof(string), "%s\n{00FF61}Dynamic Gate Flag", string);
	else
		format(string, sizeof(string), "%s\n{F2070B}Dynamic Gate Flag", string);
	if(dgCredits[0] == 1)
		format(string, sizeof(string), "%s\n{00FF61}Credits", string);
	else
		format(string, sizeof(string), "%s\n{F2070B}Credits", string);
	if(dgHealthNArmor[0] == 1)
		format(string, sizeof(string), "%s\n{00FF61}Health & Armor", string);
	else
		format(string, sizeof(string), "%s\n{F2070B}Health & Armor", string);
	if(dgGiftReset[0] == 1)
		format(string, sizeof(string), "%s\n{00FF61}Gift Reset", string);
	else
		format(string, sizeof(string), "%s\n{F2070B}Gift Reset", string);
	if(dgMaterial[0] == 1)
		format(string, sizeof(string), "%s\n{00FF61}Material", string);
	else
		format(string, sizeof(string), "%s\n{F2070B}Material", string);
	if(dgWarning[0] == 1)
		format(string, sizeof(string), "%s\n{00FF61}Warning", string);
	else
		format(string, sizeof(string), "%s\n{F2070B}Warning", string);
	if(dgPot[0] == 1)
		format(string, sizeof(string), "%s\n{00FF61}Pot", string);
	else
		format(string, sizeof(string), "%s\n{F2070B}Pot", string);
	if(dgCrack[0] == 1)
		format(string, sizeof(string), "%s\n{00FF61}Crack", string);
	else
		format(string, sizeof(string), "%s\n{F2070B}Crack", string);
	if(dgPaintballToken[0] == 1)
		format(string, sizeof(string), "%s\n{00FF61}Paintball Token", string);
	else
		format(string, sizeof(string), "%s\n{F2070B}Paintball Token", string);
	if(dgVIPToken[0] == 1)
		format(string, sizeof(string), "%s\n{00FF61}VIP Token", string);
	else
		format(string, sizeof(string), "%s\n{F2070B}VIP Token", string);
	if(dgRespectPoint[0] == 1)
		format(string, sizeof(string), "%s\n{00FF61}Respect Point", string);
	else
		format(string, sizeof(string), "%s\n{F2070B}Respect Point", string);
	if(dgCarVoucher[0] == 1)
		format(string, sizeof(string), "%s\n{00FF61}Car Voucher", string);
	else
		format(string, sizeof(string), "%s\n{F2070B}Car Voucher", string);
	if(dgBuddyInvite[0] == 1)
		format(string, sizeof(string), "%s\n{00FF61}Buddy Invite", string);
	else
		format(string, sizeof(string), "%s\n{F2070B}Buddy Invite", string);
	if(dgLaser[0] == 1)
		format(string, sizeof(string), "%s\n{00FF61}Laser", string);
	else
		format(string, sizeof(string), "%s\n{F2070B}Laser", string);
	if(dgCustomToy[0] == 1)
		format(string, sizeof(string), "%s\n{00FF61}Custom Toy", string);
	else
		format(string, sizeof(string), "%s\n{F2070B}Custom Toy", string);
	if(dgAdmuteReset[0] == 1)
		format(string, sizeof(string), "%s\n{00FF61}Mo khoa quang cao", string);
	else
		format(string, sizeof(string), "%s\n{F2070B}Mo khoa quang cao", string);
	if(dgNewbieMuteReset[0] == 1)
		format(string, sizeof(string), "%s\n{00FF61}Mo khoa newbie", string);
	else
		format(string, sizeof(string), "%s\n{F2070B}Mo khoa newbie", string);
	if(dgRestrictedCarVoucher[0] == 1)
		format(string, sizeof(string), "%s\n{00FF61}Restricted Car Voucher", string);
	else
		format(string, sizeof(string), "%s\n{F2070B}Restricted Car Voucher", string);
	if(dgPlatinumVIPVoucher[0] == 1)
		format(string, sizeof(string), "%s\n{00FF61}Platinum VIP Voucher", string);
	else
		format(string, sizeof(string), "%s\n{F2070B}Platinum VIP Voucher", string);

	return ShowPlayerDialog(playerid, DIALOG_GIFTBOX_VIEW, DIALOG_STYLE_LIST, "Dynamic Giftbox", string, "Lua chon", "Dong lai");
}
stock CreateMoney(Float:x,Float:y,Float:z,amount) // Money
{
    for(new i = 0; i < sizeof(MoneyInfo); i++)
  	{
  	    if(MoneyInfo[i][mCreated] == 0)
  	    {
            MoneyInfo[i][mCreated]=1;
            MoneyInfo[i][mbX]=x;
            MoneyInfo[i][mbY]=y;
            MoneyInfo[i][mbZ]=z;
            MoneyInfo[i][mPickup] = CreateDynamicPickup(1550, 23, x, y, z);
			MoneyInfo[i][mAmount] = amount;
			MoneyInfo[i][mMoneybag] = 1;
			return 1;
  	    }
  	}
  	return 0;
}

stock DeleteClosestBag(playerid)
{
    for(new i = 0; i < sizeof(MoneyInfo); i++)
  	{
  	    if(IsPlayerInRangeOfPoint(playerid, 4.0, MoneyInfo[i][mbX], MoneyInfo[i][mbY], MoneyInfo[i][mbZ]))
        {
  	        if(MoneyInfo[i][mCreated] == 1)
            {
                new sendername[MAX_PLAYER_NAME];
                new string[128];
                new location[MAX_ZONE_NAME];
                GetPlayerName(playerid, sendername, sizeof(sendername));
				GetPlayer2DZone(playerid, location, MAX_ZONE_NAME);
                format(string, sizeof(string), "WARNING: %s has destroyed a money bag in %s (%0.2f, %0.2f, %0.2f).", sendername, location, MoneyInfo[i][mbX], MoneyInfo[i][mbY], MoneyInfo[i][mbZ]);
				ABroadCast( COLOR_YELLOW, string, 2);
                MoneyInfo[i][mCreated]=0;
            	MoneyInfo[i][mbX]=0.0;
            	MoneyInfo[i][mbY]=0.0;
            	MoneyInfo[i][mbZ]=0.0;
            	MoneyInfo[i][mAmount] = 0;
            	MoneyInfo[i][mMoneybag] = 0;
            	DestroyDynamicPickup(MoneyInfo[i][mPickup]);
                return 1;
  	        }
  	    }
  	}
    return 0;
}

stock DeleteAllBags()
{
    for(new i = 0; i < sizeof(MoneyInfo); i++)
  	{
  	    if(MoneyInfo[i][mCreated] == 1)
  	    {
  	        MoneyInfo[i][mCreated]=0;
            MoneyInfo[i][mbX]=0.0;
            MoneyInfo[i][mbY]=0.0;
            MoneyInfo[i][mbZ]=0.0;
            MoneyInfo[i][mAmount] = 0;
            MoneyInfo[i][mMoneybag] = 0;
            DestroyDynamicPickup(MoneyInfo[i][mPickup]);
  	    }
	}
    return 0;
}
stock GiftPlayer(playerid, giveplayerid, gtype = 2) // Default is the normal giftbox
{
	if(gtype == 1)
	{
		if(GetPVarInt(giveplayerid, "GiftFail") >= 20)
		{
			new string[128];
			GivePlayerMoneyEx(giveplayerid, 20000);
			SendClientMessageEx(giveplayerid, COLOR_GRAD2, "Xin chuc mung, ban nhan duoc $20,000!");
			format(string, sizeof(string), "* %s da nhan hop qua $20,000, chuc vui ve!", GetPlayerNameEx(giveplayerid));
			ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
			SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
			return true;
		}
		SetPVarInt(giveplayerid, "GiftFail", GetPVarInt(giveplayerid, "GiftFail")+1);
	}

	new string[128], value = 0;
	if(gtype == 1)
	{
		if(IsPlayerConnected(giveplayerid))
		{
			if(playerid != MAX_PLAYERS && PlayerInfo[playerid][pAdmin] < 2) return true;

			if(playerid != MAX_PLAYERS) return GiftPlayer(MAX_PLAYERS, giveplayerid, 1);

			new randgift = Random(0, 100);
			printf("randgift %d", randgift);
			switch(randgift)
			{
				case 0..50: // cat 1 - Common gifts
				{
					new randy = random(32);
					printf("cat 1 %d", randy);
					if(randy == 0)
					{
						if(dgMoney[3] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgMoney[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgMoney[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);

						GivePlayerMoneyEx(giveplayerid, dgMoney[2]);
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc $%s!", number_format(dgMoney[2]));
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s nhan hop qua $%s, chuc vui ve!", GetPlayerNameEx(giveplayerid), number_format(dgMoney[2]));
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgMoney[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 1)
					{
						if(dgRimKit[3] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgRimKit[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgRimKit[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pRimMod] += dgRimKit[2];
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc %d rimkit!", dgRimKit[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d rimkit, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgRimKit[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgRimKit[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 2)
					{
						if(dgFirework[3] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgFirework[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgFirework[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pFirework] += dgFirework[2];
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc %d firework!", dgFirework[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d firework, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgFirework[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgFirework[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 3)
					{
						if(dgGVIP[3] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgGVIP[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgGVIP[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);

						SendClientMessageEx(giveplayerid, COLOR_GRAD2, "Chuc ban may man lan sau");
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 4)
					{
						if(dgGVIPEx[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgGVIPEx[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgGVIPEx[3] == 0) return GiftPlayer(playerid, giveplayerid, 1);

						SendClientMessageEx(giveplayerid, COLOR_GRAD2, "Chuc ban may man lan sau");
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 5)
					{
						if(dgSVIP[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgSVIP[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgSVIP[3] == 0) return GiftPlayer(playerid, giveplayerid, 1);

      					PlayerInfo[giveplayerid][pSVIPExVoucher]++;
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc %d Seven day Silver VIP Voucher!", dgSVIP[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Seven day Silver VIP Voucher, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgSVIP[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgSVIP[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 6)
					{
						if(dgSVIPEx[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgSVIPEx[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgSVIPEx[3] == 0) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pSVIPVoucher] += dgSVIPEx[2];
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc %d Mot thang dung Silver VIP Voucher!", dgSVIPEx[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Mot thang dung Silver VIP Voucher, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgSVIPEx[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgSVIPEx[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 7)
					{
						if(dgCarSlot[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgCarSlot[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgCarSlot[3] == 0) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pVehicleSlot] += dgCarSlot[2];
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc %d Car Slot!", dgCarSlot[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Car Slot, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgCarSlot[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgCarSlot[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 8)
					{
						if(dgToySlot[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgCarSlot[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgCarSlot[3] == 0) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pToySlot] += dgToySlot[2];
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc %d Toy Slot!", dgToySlot[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Toy Slot, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgToySlot[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgToySlot[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 9)
					{
						if(dgArmor[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgArmor[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgArmor[3] == 0) return GiftPlayer(playerid, giveplayerid, 1);

						new Float: armor;
						GetPlayerArmour(giveplayerid, armor);

						if(armor+dgArmor[2] >= 100) return GiftPlayer(playerid, giveplayerid, 1);

						SetPlayerArmor(giveplayerid, armor + dgArmor[2]);
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc %d Armour!", dgArmor[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Armour, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgArmor[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgArmor[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 10)
					{
						if(dgFirstaid[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgFirstaid[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgFirstaid[3] == 0) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pFirstaid] += dgFirstaid[2];
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc %d Firstaid!", dgFirstaid[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Firstaid, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgFirstaid[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgFirstaid[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 11)
					{
						if(dgDDFlag[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgDDFlag[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgDDFlag[3] == 0) return GiftPlayer(playerid, giveplayerid, 1);

						AddFlag(giveplayerid, INVALID_PLAYER_ID, "Dynamic Gift Box: 1 Dynamic Door");

						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc %d Dynamic Door Flag!", dgDDFlag[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Chu y: giai thuong nay co the mat toi 48 gio de nhan thuong..");
						format(string, sizeof(string), "* %s da nhan duoc %d Dynamic Door Flag, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgDDFlag[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgDDFlag[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 12)
					{
						if(dgGateFlag[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgGateFlag[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgGateFlag[3] == 0) return GiftPlayer(playerid, giveplayerid, 1);

						AddFlag(giveplayerid, INVALID_PLAYER_ID, "Dynamic Gift Box: 1 Gate Gate");

						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc %d Gate Flag!", dgGateFlag[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Chu y: giai thuong nay co the mat toi 48 gio de nhan thuong..");
						format(string, sizeof(string), "* %s da nhan duoc %d Dynamic Gate Flag, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgGateFlag[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgGateFlag[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 13)
					{
						if(dgCredits[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgCredits[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgCredits[3] == 0) return GiftPlayer(playerid, giveplayerid, 1);

						GivePlayerCredits(giveplayerid, dgCredits[2], 1);
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc %d Credit!", dgCredits[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Credit, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgCredits[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgCredits[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 14)
					{
						if(dgPriorityAd[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgPriorityAd[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgPriorityAd[3] == 0) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pAdvertVoucher]++;
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc %d Quang cao uu tien Voucher!", dgPriorityAd[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Quang cao uu tien Voucher, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgPriorityAd[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgPriorityAd[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 15)
					{
						if(dgHealthNArmor[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgHealthNArmor[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgHealthNArmor[3] == 0) return GiftPlayer(playerid, giveplayerid, 1);

						SetPlayerHealth(giveplayerid, 100.0);
						SetPlayerArmor(giveplayerid, 100);
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc Full Health & Armor!");
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Full Health & Armor, chuc vui ve!", GetPlayerNameEx(giveplayerid));
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgHealthNArmor[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 16)
					{
						if(dgGiftReset[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgGiftReset[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgGiftReset[3] == 0) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pGiftVoucher] += dgGiftReset[2];
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc a %d Gift Reset Voucher!", dgGiftReset[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Gift Reset Voucher, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgGiftReset[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgGiftReset[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 17)
					{
						if(dgMaterial[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgMaterial[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgMaterial[3] == 0) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pMats] += dgMaterial[2];
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc a %d Material!", dgMaterial[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Material, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgMaterial[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgMaterial[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 18)
					{
						if(dgWarning[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgWarning[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgWarning[3] == 0) return GiftPlayer(playerid, giveplayerid, 1);

						if(dgWarning[2] > 3 || dgWarning[2] < 0)
						{
							if(PlayerInfo[giveplayerid][pWarns] == 0) return GiftPlayer(playerid, giveplayerid, 1);

							PlayerInfo[giveplayerid][pWarns] -= dgWarning[2];
						}
						else
							return GiftPlayer(playerid, giveplayerid, 1);

						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc a %d Warning Removal!", dgWarning[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Warning Removal, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgWarning[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgWarning[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 19)
					{
						if(dgPot[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgPot[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgPot[3] == 0) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pPot] += dgPot[2];
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc a %d Pot!", dgPot[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Pot, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgPot[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgPot[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 20)
					{
						if(dgCrack[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgCrack[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgCrack[3] == 0) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pCrack] += dgCrack[2];
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc a %d Crack!", dgCrack[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Crack, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgCrack[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgCrack[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 21)
					{
						if(dgPaintballToken[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgPaintballToken[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgPaintballToken[3] == 0) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pPaintTokens] += dgPaintballToken[2];
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc a %d Paintball Token!", dgPaintballToken[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Paintball Token, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgPaintballToken[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgPaintballToken[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 22)
					{
						if(dgVIPToken[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVIPToken[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVIPToken[3] == 0) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pTokens] += dgVIPToken[2];
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc a %d VIP Token!", dgVIPToken[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d VIP Token, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgVIPToken[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVIPToken[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 23)
					{
						if(dgRespectPoint[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgRespectPoint[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgRespectPoint[3] == 0) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pExp] += dgRespectPoint[2];
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc a %d Respect Point!", dgRespectPoint[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Respect Point, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgRespectPoint[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgRespectPoint[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 24)
					{
						if(dgCarVoucher[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgCarVoucher[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgCarVoucher[3] == 0) return GiftPlayer(playerid, giveplayerid, 1);

						SendClientMessageEx(giveplayerid, COLOR_GRAD2, "Chuc ban may man lan sau");
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 25)
					{
						if(dgBuddyInvite[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgBuddyInvite[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgBuddyInvite[3] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(PlayerInfo[giveplayerid][pDonateRank] != 0) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pDonateRank] = 1;
						PlayerInfo[giveplayerid][pTempVIP] = 10800;
						PlayerInfo[giveplayerid][pBuddyInvited] = 1;
						format(string, sizeof(string), "BUDDY INVITE: %s has been invited to VIP by System", GetPlayerNameEx(giveplayerid));
						Log("logs/setvip.log", string);

						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc a Buddy Invite!");
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc mot BuddyInvite, chuc vui ve!", GetPlayerNameEx(giveplayerid));
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgBuddyInvite[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 26)
					{
						if(dgLaser[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgLaser[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgLaser[3] == 0) return GiftPlayer(playerid, giveplayerid, 1);

						new icount = GetPlayerToySlots(giveplayerid), success = 0;
						for(new v = 0; v < icount; v++)
						{
							if(PlayerToyInfo[giveplayerid][v][ptModelID] == 0)
							{
								PlayerToyInfo[giveplayerid][v][ptModelID] = 18643;
								PlayerToyInfo[giveplayerid][v][ptBone] = 6;
								PlayerToyInfo[giveplayerid][v][ptPosX] = 0.0;
								PlayerToyInfo[giveplayerid][v][ptPosY] = 0.0;
								PlayerToyInfo[giveplayerid][v][ptPosZ] = 0.0;
								PlayerToyInfo[giveplayerid][v][ptRotX] = 0.0;
								PlayerToyInfo[giveplayerid][v][ptRotY] = 0.0;
								PlayerToyInfo[giveplayerid][v][ptRotZ] = 0.0;
								PlayerToyInfo[giveplayerid][v][ptScaleX] = 1.0;
								PlayerToyInfo[giveplayerid][v][ptScaleY] = 1.0;
								PlayerToyInfo[giveplayerid][v][ptScaleZ] = 1.0;
								PlayerToyInfo[giveplayerid][v][ptTradable] = 1;

								g_mysql_NewToy(giveplayerid, v);
								success = 1;
								break;
							}
						}

						if(success == 0)
						{
							for(new i = 0; i < MAX_PLAYERTOYS; i++)
							{
								if(PlayerToyInfo[giveplayerid][i][ptModelID] == 0)
								{
									PlayerToyInfo[giveplayerid][i][ptModelID] = 18643;
									PlayerToyInfo[giveplayerid][i][ptBone] = 6;
									PlayerToyInfo[giveplayerid][i][ptPosX] = 0.0;
									PlayerToyInfo[giveplayerid][i][ptPosY] = 0.0;
									PlayerToyInfo[giveplayerid][i][ptPosZ] = 0.0;
									PlayerToyInfo[giveplayerid][i][ptRotX] = 0.0;
									PlayerToyInfo[giveplayerid][i][ptRotY] = 0.0;
									PlayerToyInfo[giveplayerid][i][ptRotZ] = 0.0;
									PlayerToyInfo[giveplayerid][i][ptScaleX] = 1.0;
									PlayerToyInfo[giveplayerid][i][ptScaleY] = 1.0;
									PlayerToyInfo[giveplayerid][i][ptScaleZ] = 1.0;
									PlayerToyInfo[giveplayerid][i][ptTradable] = 1;
									PlayerToyInfo[giveplayerid][i][ptSpecial] = 1;

									g_mysql_NewToy(giveplayerid, i);

									SendClientMessageEx(giveplayerid, COLOR_GRAD1, "Due to you not having any available slots, we've temporarily gave you an additional slot to use/sell/trade your laser.");
									SendClientMessageEx(giveplayerid, COLOR_RED, "Note: Please take note that after selling the laser, the temporarily additional toy slot will be removed.");
									break;
								}
							}
						}

						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc a Laser!");
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc mot Laser, chuc vui ve!", GetPlayerNameEx(giveplayerid));
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgLaser[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 27)
					{
						if(dgCustomToy[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgCustomToy[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgCustomToy[3] == 0) return GiftPlayer(playerid, giveplayerid, 1);

						new icount = GetPlayerToySlots(giveplayerid), success = 0;
						for(new v = 0; v < icount; v++)
						{
							if(PlayerToyInfo[giveplayerid][v][ptModelID] == 0)
							{
								PlayerToyInfo[giveplayerid][v][ptModelID] = dgCustomToy[2];
								PlayerToyInfo[giveplayerid][v][ptBone] = 1;
								PlayerToyInfo[giveplayerid][v][ptPosX] = 0.0;
								PlayerToyInfo[giveplayerid][v][ptPosY] = 0.0;
								PlayerToyInfo[giveplayerid][v][ptPosZ] = 0.0;
								PlayerToyInfo[giveplayerid][v][ptRotX] = 0.0;
								PlayerToyInfo[giveplayerid][v][ptRotY] = 0.0;
								PlayerToyInfo[giveplayerid][v][ptRotZ] = 0.0;
								PlayerToyInfo[giveplayerid][v][ptScaleX] = 1.0;
								PlayerToyInfo[giveplayerid][v][ptScaleY] = 1.0;
								PlayerToyInfo[giveplayerid][v][ptScaleZ] = 1.0;
								PlayerToyInfo[giveplayerid][v][ptTradable] = 1;

								g_mysql_NewToy(giveplayerid, v);
								success = 1;
								break;
							}
						}

						if(success == 0)
						{
							for(new i = 0; i < MAX_PLAYERTOYS; i++)
							{
								if(PlayerToyInfo[giveplayerid][i][ptModelID] == 0)
								{
									PlayerToyInfo[giveplayerid][i][ptModelID] = dgCustomToy[2];
									PlayerToyInfo[giveplayerid][i][ptBone] = 6;
									PlayerToyInfo[giveplayerid][i][ptPosX] = 0.0;
									PlayerToyInfo[giveplayerid][i][ptPosY] = 0.0;
									PlayerToyInfo[giveplayerid][i][ptPosZ] = 0.0;
									PlayerToyInfo[giveplayerid][i][ptRotX] = 0.0;
									PlayerToyInfo[giveplayerid][i][ptRotY] = 0.0;
									PlayerToyInfo[giveplayerid][i][ptRotZ] = 0.0;
									PlayerToyInfo[giveplayerid][i][ptScaleX] = 1.0;
									PlayerToyInfo[giveplayerid][i][ptScaleY] = 1.0;
									PlayerToyInfo[giveplayerid][i][ptScaleZ] = 1.0;
									PlayerToyInfo[giveplayerid][i][ptTradable] = 1;
									PlayerToyInfo[giveplayerid][i][ptSpecial] = 1;

									g_mysql_NewToy(giveplayerid, i);

									SendClientMessageEx(giveplayerid, COLOR_GRAD1, "Due to you not having any available slots, we've temporarily gave you an additional slot to use/sell/trade your custom toy.");
									SendClientMessageEx(giveplayerid, COLOR_RED, "Note: Please take note that after selling the custom toy, the temporarily additional toy slot will be removed.");
									break;
								}
							}
						}

						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc a Custom Toy!");
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc mot Custom Toy, chuc vui ve!", GetPlayerNameEx(giveplayerid));
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgCustomToy[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 28)
					{
						if(dgAdmuteReset[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgAdmuteReset[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgAdmuteReset[3] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(PlayerInfo[giveplayerid][pADMuteTotal] == 0) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pADMuteTotal] -= dgAdmuteReset[2];

						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc %d Admute Reset!", dgAdmuteReset[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Admute Reset, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgAdmuteReset[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgAdmuteReset[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 29)
					{
						if(dgNewbieMuteReset[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgNewbieMuteReset[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgNewbieMuteReset[3] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(PlayerInfo[giveplayerid][pNMuteTotal] == 0) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pNMuteTotal] -= dgNewbieMuteReset[2];

						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc %d Mo khoa newbie!", dgNewbieMuteReset[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Mo khoa newbie, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgNewbieMuteReset[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgNewbieMuteReset[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 30)
					{
						if(dgRestrictedCarVoucher[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgRestrictedCarVoucher[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgRestrictedCarVoucher[3] == 0) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pCarVoucher] += dgRestrictedCarVoucher[2];
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc a %d Restricted Car Voucher!", dgRestrictedCarVoucher[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Restricted Car Voucher, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgRestrictedCarVoucher[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgRestrictedCarVoucher[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 31)
					{
						if(dgPlatinumVIPVoucher[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgPlatinumVIPVoucher[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgPlatinumVIPVoucher[3] == 0) return GiftPlayer(playerid, giveplayerid, 1);

						SendClientMessageEx(giveplayerid, COLOR_GRAD2, "Chuc ban may man lan sau");
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					else return SendClientMessageEx(giveplayerid, COLOR_RED, "Seems like the dynamic giftbox is empty, please try again.");
				}
				case 51..80: // cat 2 - Slightly more rare gifts
				{
					new randy = random(32);
					printf("cat 1 %d", randy);

					if(randy == 0)
					{
						if(dgMoney[3] == 1) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgMoney[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgMoney[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);

						GivePlayerMoneyEx(giveplayerid, dgMoney[2]);
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc $%s!", number_format(dgMoney[2]));
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc $%s, chuc vui ve!", GetPlayerNameEx(giveplayerid), number_format(dgMoney[2]));
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgMoney[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 1)
					{
						if(dgRimKit[3] == 1) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgRimKit[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgRimKit[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pRimMod] += dgRimKit[2];
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc %d rimkit!", dgRimKit[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d rimkit, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgRimKit[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgRimKit[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 2)
					{
						if(dgFirework[3] == 1) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgFirework[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgFirework[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pFirework] += dgFirework[2];
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc %d firework!", dgFirework[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d firework, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgFirework[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgFirework[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 3)
					{
						if(dgGVIP[3] == 1) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgGVIP[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgGVIP[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);

						SendClientMessageEx(giveplayerid, COLOR_GRAD2, "Chuc ban may man lan sau");
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 4)
					{
						if(dgGVIPEx[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgGVIPEx[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgGVIPEx[3] == 1) return GiftPlayer(playerid, giveplayerid, 1);

						SendClientMessageEx(giveplayerid, COLOR_GRAD2, "Chuc ban may man lan sau");
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 5)
					{
						if(dgSVIP[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgSVIP[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgSVIP[3] == 1) return GiftPlayer(playerid, giveplayerid, 1);

						AddFlag(giveplayerid, INVALID_PLAYER_ID, "Dynamic Gift Box: 7 Day Silver VIP");

						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc %d Seven day Silver VIP!", dgSVIP[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Chu y: giai thuong nay co the mat toi 48 gio de nhan thuong..");
						format(string, sizeof(string), "* %s da nhan duoc %d Seven day Silver VIP, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgSVIP[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgSVIP[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 6)
					{
						if(dgSVIPEx[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgSVIPEx[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgSVIPEx[3] == 1) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pSVIPVoucher] += dgSVIPEx[2];
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc %d Mot thang dung Silver VIP Voucher!", dgSVIPEx[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Mot thang dung Silver VIP Voucher, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgSVIPEx[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgSVIPEx[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 7)
					{
						if(dgCarSlot[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgCarSlot[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgCarSlot[3] == 1) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pVehicleSlot] += dgCarSlot[2];
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc %d Car Slot!", dgCarSlot[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Car Slot, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgCarSlot[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgCarSlot[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 8)
					{
						if(dgToySlot[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgCarSlot[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgCarSlot[3] == 1) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pToySlot] += dgToySlot[2];
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc %d Toy Slot!", dgToySlot[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Toy Slot, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgToySlot[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgToySlot[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 9)
					{
						if(dgArmor[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgArmor[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgArmor[3] == 1) return GiftPlayer(playerid, giveplayerid, 1);

						new Float: armor;
						GetPlayerArmour(giveplayerid, armor);

						if(armor+dgArmor[2] >= 100) return GiftPlayer(playerid, giveplayerid, 1);

						SetPlayerArmor(giveplayerid, armor + dgArmor[2]);
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc %d Armour!", dgArmor[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Armour, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgArmor[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgArmor[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 10)
					{
						if(dgFirstaid[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgFirstaid[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgFirstaid[3] == 1) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pFirstaid] += dgFirstaid[2];
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc %d Firstaid!", dgFirstaid[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Firstaid, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgFirstaid[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgFirstaid[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 11)
					{
						if(dgDDFlag[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgDDFlag[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgDDFlag[3] == 1) return GiftPlayer(playerid, giveplayerid, 1);

						AddFlag(giveplayerid, INVALID_PLAYER_ID, "Dynamic Gift Box: 1 Dynamic Door");

						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc %d Dynamic Door Flag!", dgDDFlag[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Chu y: giai thuong nay co the mat toi 48 gio de nhan thuong..");
						format(string, sizeof(string), "* %s da nhan duoc %d Dynamic Door Flag, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgDDFlag[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgDDFlag[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 12)
					{
						if(dgGateFlag[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgGateFlag[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgGateFlag[3] == 1) return GiftPlayer(playerid, giveplayerid, 1);

						AddFlag(giveplayerid, INVALID_PLAYER_ID, "Dynamic Gift Box: 1 Dynamic Gate");

						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc %d Dynamic Door Flag!", dgGateFlag[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Chu y: giai thuong nay co the mat toi 48 gio de nhan thuong..");
						format(string, sizeof(string), "* %s da nhan duoc %d Dynamic Gate Flag, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgGateFlag[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgGateFlag[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 13)
					{
						if(dgCredits[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgCredits[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgCredits[3] == 1) return GiftPlayer(playerid, giveplayerid, 1);

						GivePlayerCredits(giveplayerid, dgCredits[2], 1);
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc %d Credit!", dgCredits[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Credit, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgCredits[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgCredits[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 14)
					{
						if(dgPriorityAd[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgPriorityAd[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgPriorityAd[3] == 1) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pAdvertVoucher]++;
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc %d Quang cao uu tien Voucher!", dgPriorityAd[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Quang cao uu tien Voucher, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgPriorityAd[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgPriorityAd[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 15)
					{
						if(dgHealthNArmor[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgHealthNArmor[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgHealthNArmor[3] == 1) return GiftPlayer(playerid, giveplayerid, 1);

						SetPlayerHealth(giveplayerid, 100.0);
						SetPlayerArmor(giveplayerid, 100);
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc Full Health & Armor!");
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Full Health & Armor, chuc vui ve!", GetPlayerNameEx(giveplayerid));
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgHealthNArmor[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 16)
					{
						if(dgGiftReset[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgGiftReset[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgGiftReset[3] == 1) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pGiftVoucher] += dgGiftReset[2];
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc a %d Gift Reset Voucher!", dgGiftReset[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Gift Reset Voucher, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgGiftReset[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgGiftReset[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 17)
					{
						if(dgMaterial[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgMaterial[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgMaterial[3] == 1) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pMats] += dgMaterial[2];
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc a %d Material!", dgMaterial[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Material, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgMaterial[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgMaterial[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 18)
					{
						if(dgWarning[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgWarning[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgWarning[3] == 1) return GiftPlayer(playerid, giveplayerid, 1);

						if(dgWarning[2] > 3 || dgWarning[2] < 0)
						{
							if(PlayerInfo[giveplayerid][pWarns] == 0) return GiftPlayer(playerid, giveplayerid, 1);

							PlayerInfo[giveplayerid][pWarns] -= dgWarning[2];
						}
						else
							return GiftPlayer(playerid, giveplayerid, 1);

						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc a %d Warning Removal!", dgWarning[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Warning Removal, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgWarning[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgWarning[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 19)
					{
						if(dgPot[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgPot[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgPot[3] == 1) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pPot] += dgPot[2];
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc a %d Pot!", dgPot[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Pot, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgPot[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgPot[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 20)
					{
						if(dgCrack[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgCrack[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgCrack[3] == 1) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pCrack] += dgCrack[2];
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc a %d Crack!", dgCrack[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Crack, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgCrack[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgCrack[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 21)
					{
						if(dgPaintballToken[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgPaintballToken[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgPaintballToken[3] == 1) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pPaintTokens] += dgPaintballToken[2];
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc a %d Paintball Token!", dgPaintballToken[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Paintball Token, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgPaintballToken[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgPaintballToken[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 22)
					{
						if(dgVIPToken[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVIPToken[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVIPToken[3] == 1) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pTokens] += dgVIPToken[2];
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc a %d VIP Token!", dgVIPToken[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d VIP Token, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgVIPToken[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVIPToken[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 23)
					{
						if(dgRespectPoint[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgRespectPoint[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgRespectPoint[3] == 1) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pExp] += dgRespectPoint[2];
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc a %d Respect Point!", dgRespectPoint[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Respect Point, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgRespectPoint[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgRespectPoint[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 24)
					{
						if(dgCarVoucher[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgCarVoucher[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgCarVoucher[3] == 1) return GiftPlayer(playerid, giveplayerid, 1);

						SendClientMessageEx(giveplayerid, COLOR_GRAD2, "Chuc ban may man lan sau");
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 25)
					{
						if(dgBuddyInvite[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgBuddyInvite[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgBuddyInvite[3] == 1) return GiftPlayer(playerid, giveplayerid, 1);
						if(PlayerInfo[giveplayerid][pDonateRank] != 0) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pDonateRank] = 1;
						PlayerInfo[giveplayerid][pTempVIP] = 10800;
						PlayerInfo[giveplayerid][pBuddyInvited] = 1;
						format(string, sizeof(string), "BUDDY INVITE: %s has been invited to VIP by System", GetPlayerNameEx(giveplayerid));
						Log("logs/setvip.log", string);

						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc a Buddy Invite!");
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc mot BuddyInvite, chuc vui ve!", GetPlayerNameEx(giveplayerid));
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgBuddyInvite[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 26)
					{
						if(dgLaser[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgLaser[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgLaser[3] == 1) return GiftPlayer(playerid, giveplayerid, 1);

						new icount = GetPlayerToySlots(giveplayerid), success = 0;
						for(new v = 0; v < icount; v++)
						{
							if(PlayerToyInfo[giveplayerid][v][ptModelID] == 0)
							{
								PlayerToyInfo[giveplayerid][v][ptModelID] = 18643;
								PlayerToyInfo[giveplayerid][v][ptBone] = 6;
								PlayerToyInfo[giveplayerid][v][ptPosX] = 0.0;
								PlayerToyInfo[giveplayerid][v][ptPosY] = 0.0;
								PlayerToyInfo[giveplayerid][v][ptPosZ] = 0.0;
								PlayerToyInfo[giveplayerid][v][ptRotX] = 0.0;
								PlayerToyInfo[giveplayerid][v][ptRotY] = 0.0;
								PlayerToyInfo[giveplayerid][v][ptRotZ] = 0.0;
								PlayerToyInfo[giveplayerid][v][ptScaleX] = 1.0;
								PlayerToyInfo[giveplayerid][v][ptScaleY] = 1.0;
								PlayerToyInfo[giveplayerid][v][ptScaleZ] = 1.0;
								PlayerToyInfo[giveplayerid][v][ptTradable] = 1;

								g_mysql_NewToy(giveplayerid, v);
								success = 1;
								break;
							}
						}

						if(success == 0)
						{
							for(new i = 0; i < MAX_PLAYERTOYS; i++)
							{
								if(PlayerToyInfo[giveplayerid][i][ptModelID] == 0)
								{
									PlayerToyInfo[giveplayerid][i][ptModelID] = 18643;
									PlayerToyInfo[giveplayerid][i][ptBone] = 6;
									PlayerToyInfo[giveplayerid][i][ptPosX] = 0.0;
									PlayerToyInfo[giveplayerid][i][ptPosY] = 0.0;
									PlayerToyInfo[giveplayerid][i][ptPosZ] = 0.0;
									PlayerToyInfo[giveplayerid][i][ptRotX] = 0.0;
									PlayerToyInfo[giveplayerid][i][ptRotY] = 0.0;
									PlayerToyInfo[giveplayerid][i][ptRotZ] = 0.0;
									PlayerToyInfo[giveplayerid][i][ptScaleX] = 1.0;
									PlayerToyInfo[giveplayerid][i][ptScaleY] = 1.0;
									PlayerToyInfo[giveplayerid][i][ptScaleZ] = 1.0;
									PlayerToyInfo[giveplayerid][i][ptTradable] = 1;
									PlayerToyInfo[giveplayerid][i][ptSpecial] = 1;

									g_mysql_NewToy(giveplayerid, i);

									SendClientMessageEx(giveplayerid, COLOR_GRAD1, "Due to you not having any available slots, we've temporarily gave you an additional slot to use/sell/trade your laser.");
									SendClientMessageEx(giveplayerid, COLOR_RED, "Note: Please take note that after selling the laser, the temporarily additional toy slot will be removed.");
									break;
								}
							}
						}

						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc a Laser!");
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc mot Laser, chuc vui ve!", GetPlayerNameEx(giveplayerid));
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgLaser[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 27)
					{
						if(dgCustomToy[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgCustomToy[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgCustomToy[3] == 1) return GiftPlayer(playerid, giveplayerid, 1);

						new icount = GetPlayerToySlots(giveplayerid), success = 0;
						for(new v = 0; v < icount; v++)
						{
							if(PlayerToyInfo[giveplayerid][v][ptModelID] == 0)
							{
								PlayerToyInfo[giveplayerid][v][ptModelID] = dgCustomToy[2];
								PlayerToyInfo[giveplayerid][v][ptBone] = 1;
								PlayerToyInfo[giveplayerid][v][ptPosX] = 0.0;
								PlayerToyInfo[giveplayerid][v][ptPosY] = 0.0;
								PlayerToyInfo[giveplayerid][v][ptPosZ] = 0.0;
								PlayerToyInfo[giveplayerid][v][ptRotX] = 0.0;
								PlayerToyInfo[giveplayerid][v][ptRotY] = 0.0;
								PlayerToyInfo[giveplayerid][v][ptRotZ] = 0.0;
								PlayerToyInfo[giveplayerid][v][ptScaleX] = 1.0;
								PlayerToyInfo[giveplayerid][v][ptScaleY] = 1.0;
								PlayerToyInfo[giveplayerid][v][ptScaleZ] = 1.0;
								PlayerToyInfo[giveplayerid][v][ptTradable] = 1;

								g_mysql_NewToy(giveplayerid, v);
								success = 1;
								break;
							}
						}

						if(success == 0)
						{
							for(new i = 0; i < MAX_PLAYERTOYS; i++)
							{
								if(PlayerToyInfo[giveplayerid][i][ptModelID] == 0)
								{
									PlayerToyInfo[giveplayerid][i][ptModelID] = dgCustomToy[2];
									PlayerToyInfo[giveplayerid][i][ptBone] = 6;
									PlayerToyInfo[giveplayerid][i][ptPosX] = 0.0;
									PlayerToyInfo[giveplayerid][i][ptPosY] = 0.0;
									PlayerToyInfo[giveplayerid][i][ptPosZ] = 0.0;
									PlayerToyInfo[giveplayerid][i][ptRotX] = 0.0;
									PlayerToyInfo[giveplayerid][i][ptRotY] = 0.0;
									PlayerToyInfo[giveplayerid][i][ptRotZ] = 0.0;
									PlayerToyInfo[giveplayerid][i][ptScaleX] = 1.0;
									PlayerToyInfo[giveplayerid][i][ptScaleY] = 1.0;
									PlayerToyInfo[giveplayerid][i][ptScaleZ] = 1.0;
									PlayerToyInfo[giveplayerid][i][ptTradable] = 1;
									PlayerToyInfo[giveplayerid][i][ptSpecial] = 1;

									g_mysql_NewToy(giveplayerid, i);

									SendClientMessageEx(giveplayerid, COLOR_GRAD1, "Due to you not having any available slots, we've temporarily gave you an additional slot to use/sell/trade your custom toy.");
									SendClientMessageEx(giveplayerid, COLOR_RED, "Note: Please take note that after selling the custom toy, the temporarily additional toy slot will be removed.");
									break;
								}
							}
						}

						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc a Custom Toy!");
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc mot Custom Toy, chuc vui ve!", GetPlayerNameEx(giveplayerid));
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgCustomToy[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 28)
					{
						if(dgAdmuteReset[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgAdmuteReset[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgAdmuteReset[3] == 1) return GiftPlayer(playerid, giveplayerid, 1);
						if(PlayerInfo[giveplayerid][pADMuteTotal] == 0) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pADMuteTotal] -= dgAdmuteReset[2];

						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc %d Mo khoa quang cao!", dgAdmuteReset[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Admute Reset, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgAdmuteReset[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgAdmuteReset[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 29)
					{
						if(dgNewbieMuteReset[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgNewbieMuteReset[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgNewbieMuteReset[3] == 1) return GiftPlayer(playerid, giveplayerid, 1);
						if(PlayerInfo[giveplayerid][pNMuteTotal] == 0) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pNMuteTotal] -= dgNewbieMuteReset[2];

						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc %d Mo khoa newbie!", dgNewbieMuteReset[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Mo khoa newbie, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgNewbieMuteReset[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgNewbieMuteReset[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 30)
					{
						if(dgRestrictedCarVoucher[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgRestrictedCarVoucher[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgRestrictedCarVoucher[3] == 1) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pCarVoucher] += dgRestrictedCarVoucher[2];
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc a %d Restricted Car Voucher!", dgRestrictedCarVoucher[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Restricted Car Voucher, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgRestrictedCarVoucher[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgRestrictedCarVoucher[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 31)
					{
						if(dgPlatinumVIPVoucher[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgPlatinumVIPVoucher[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgPlatinumVIPVoucher[3] == 1) return GiftPlayer(playerid, giveplayerid, 1);

						SendClientMessageEx(giveplayerid, COLOR_GRAD2, "Chuc ban may man lan sau");
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					else return SendClientMessageEx(giveplayerid, COLOR_RED, "Seems like the dynamic giftbox is empty, please try again.");
				}
				case 81..95: // cat 3 rarish
				{
					new randy = random(32);
					printf("cat 1 %d", randy);

					if(randy == 0)
					{
						if(dgMoney[3] == 2) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgMoney[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgMoney[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);

						GivePlayerMoneyEx(giveplayerid, dgMoney[2]);
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc $%s!", number_format(dgMoney[2]));
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc $%s, chuc vui ve!", GetPlayerNameEx(giveplayerid), number_format(dgMoney[2]));
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgMoney[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 1)
					{
						if(dgRimKit[3] == 2) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgRimKit[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgRimKit[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pRimMod] += dgRimKit[2];
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc %d rimkit!", dgRimKit[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d rimkit, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgRimKit[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgRimKit[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 2)
					{
						if(dgFirework[3] == 2) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgFirework[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgFirework[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pFirework] += dgFirework[2];
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc %d firework!", dgFirework[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d firework, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgFirework[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgFirework[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 3)
					{
						if(dgGVIP[3] == 2) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgGVIP[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgGVIP[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);

						SendClientMessageEx(giveplayerid, COLOR_GRAD2, "Chuc ban may man lan sau");
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 4)
					{
						if(dgGVIPEx[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgGVIPEx[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgGVIPEx[3] == 2) return GiftPlayer(playerid, giveplayerid, 1);

						SendClientMessageEx(giveplayerid, COLOR_GRAD2, "Chuc ban may man lan sau");
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 5)
					{
						if(dgSVIP[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgSVIP[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgSVIP[3] == 2) return GiftPlayer(playerid, giveplayerid, 1);

						AddFlag(giveplayerid, INVALID_PLAYER_ID, "Dynamic Gift Box: 7 Day Silver VIP");

						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc %d Seven day Silver VIP!", dgSVIP[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Chu y: giai thuong nay co the mat toi 48 gio de nhan thuong..");
						format(string, sizeof(string), "* %s da nhan duoc %d Seven day Silver VIP, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgSVIP[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgSVIP[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 6)
					{
						if(dgSVIPEx[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgSVIPEx[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgSVIPEx[3] == 2) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pSVIPVoucher] += dgSVIPEx[2];
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc %d Mot thang dung Silver VIP Voucher!", dgSVIPEx[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Mot thang dung Silver VIP Voucher, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgSVIPEx[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgSVIPEx[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 7)
					{
						if(dgCarSlot[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgCarSlot[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgCarSlot[3] == 2) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pVehicleSlot] += dgCarSlot[2];
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc %d Car Slot!", dgCarSlot[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Car Slot, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgCarSlot[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgCarSlot[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 8)
					{
						if(dgToySlot[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgCarSlot[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgCarSlot[3] == 2) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pToySlot] += dgToySlot[2];
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc %d Toy Slot!", dgToySlot[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Toy Slot, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgToySlot[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgToySlot[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 9)
					{
						if(dgArmor[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgArmor[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgArmor[3] == 2) return GiftPlayer(playerid, giveplayerid, 1);

						new Float: armor;
						GetPlayerArmour(giveplayerid, armor);

						if(armor+dgArmor[2] >= 100) return GiftPlayer(playerid, giveplayerid, 1);

						SetPlayerArmor(giveplayerid, armor + dgArmor[2]);
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc %d Armour!", dgArmor[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Armour, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgArmor[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgArmor[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 10)
					{
						if(dgFirstaid[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgFirstaid[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgFirstaid[3] == 2) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pFirstaid] += dgFirstaid[2];
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc %d Firstaid!", dgFirstaid[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Firstaid, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgFirstaid[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgFirstaid[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 11)
					{
						if(dgDDFlag[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgDDFlag[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgDDFlag[3] == 2) return GiftPlayer(playerid, giveplayerid, 1);

						AddFlag(giveplayerid, INVALID_PLAYER_ID, "Dynamic Gift Box: 1 Dynamic Door");

						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc %d Dynamic Door Flag!", dgDDFlag[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Chu y: giai thuong nay co the mat toi 48 gio de nhan thuong..");
						format(string, sizeof(string), "* %s da nhan duoc %d Dynamic Door Flag, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgDDFlag[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgDDFlag[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 12)
					{
						if(dgGateFlag[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgGateFlag[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgGateFlag[3] == 2) return GiftPlayer(playerid, giveplayerid, 1);

						AddFlag(giveplayerid, INVALID_PLAYER_ID, "Dynamic Gift Box: 1 Dynamic Gate");

						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc %d Dynamic Door Flag!", dgGateFlag[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Chu y: giai thuong nay co the mat toi 48 gio de nhan thuong..");
						format(string, sizeof(string), "* %s da nhan duoc %d Dynamic Gate Flag, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgGateFlag[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgGateFlag[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 13)
					{
						if(dgCredits[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgCredits[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgCredits[3] == 2) return GiftPlayer(playerid, giveplayerid, 1);

						GivePlayerCredits(giveplayerid, dgCredits[2], 1);
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc %d Credit!", dgCredits[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Credit, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgCredits[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgCredits[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 14)
					{
						if(dgPriorityAd[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgPriorityAd[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgPriorityAd[3] == 2) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pAdvertVoucher]++;
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc %d Quang cao uu tien Voucher!", dgPriorityAd[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Quang cao uu tien Voucher, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgPriorityAd[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgPriorityAd[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 15)
					{
						if(dgHealthNArmor[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgHealthNArmor[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgHealthNArmor[3] == 2) return GiftPlayer(playerid, giveplayerid, 1);

						SetPlayerHealth(giveplayerid, 100.0);
						SetPlayerArmor(giveplayerid, 100);
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc Full Health & Armor!");
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Full Health & Armor, chuc vui ve!", GetPlayerNameEx(giveplayerid));
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgHealthNArmor[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 16)
					{
						if(dgGiftReset[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgGiftReset[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgGiftReset[3] == 2) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pGiftVoucher] += dgGiftReset[2];
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc a %d Gift Reset Voucher!", dgGiftReset[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Gift Reset Voucher, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgGiftReset[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgGiftReset[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 17)
					{
						if(dgMaterial[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgMaterial[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgMaterial[3] == 2) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pMats] += dgMaterial[2];
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc a %d Material!", dgMaterial[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Material, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgMaterial[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgMaterial[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 18)
					{
						if(dgWarning[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgWarning[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgWarning[3] == 2) return GiftPlayer(playerid, giveplayerid, 1);

						if(dgWarning[2] > 3 || dgWarning[2] < 0)
						{
							if(PlayerInfo[giveplayerid][pWarns] == 0) return GiftPlayer(playerid, giveplayerid, 1);

							PlayerInfo[giveplayerid][pWarns] -= dgWarning[2];
						}
						else
							return GiftPlayer(playerid, giveplayerid, 1);

						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc a %d Warning Removal!", dgWarning[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Warning Removal, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgWarning[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgWarning[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 19)
					{
						if(dgPot[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgPot[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgPot[3] == 2) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pPot] += dgPot[2];
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc a %d Pot!", dgPot[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Pot, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgPot[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgPot[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 20)
					{
						if(dgCrack[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgCrack[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgCrack[3] == 2) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pCrack] += dgCrack[2];
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc a %d Crack!", dgCrack[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Crack, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgCrack[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgCrack[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 21)
					{
						if(dgPaintballToken[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgPaintballToken[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgPaintballToken[3] == 2) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pPaintTokens] += dgPaintballToken[2];
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc a %d Paintball Token!", dgPaintballToken[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Paintball Token, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgPaintballToken[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgPaintballToken[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 22)
					{
						if(dgVIPToken[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVIPToken[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVIPToken[3] == 2) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pTokens] += dgVIPToken[2];
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc a %d VIP Token!", dgVIPToken[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d VIP Token, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgVIPToken[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVIPToken[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 23)
					{
						if(dgRespectPoint[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgRespectPoint[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgRespectPoint[3] == 2) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pExp] += dgRespectPoint[2];
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc a %d Respect Point!", dgRespectPoint[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Respect Point, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgRespectPoint[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgRespectPoint[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 24)
					{
						if(dgCarVoucher[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgCarVoucher[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgCarVoucher[3] == 2) return GiftPlayer(playerid, giveplayerid, 1);

						SendClientMessageEx(giveplayerid, COLOR_GRAD2, "Chuc ban may man lan sau");
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 25)
					{
						if(dgBuddyInvite[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgBuddyInvite[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgBuddyInvite[3] == 2) return GiftPlayer(playerid, giveplayerid, 1);
						if(PlayerInfo[giveplayerid][pDonateRank] != 0) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pDonateRank] = 1;
						PlayerInfo[giveplayerid][pTempVIP] = 10800;
						PlayerInfo[giveplayerid][pBuddyInvited] = 1;
						format(string, sizeof(string), "BUDDY INVITE: %s has been invited to VIP by System", GetPlayerNameEx(giveplayerid));
						Log("logs/setvip.log", string);

						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc a Buddy Invite!");
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc mot BuddyInvite, chuc vui ve!", GetPlayerNameEx(giveplayerid));
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgBuddyInvite[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 26)
					{
						if(dgLaser[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgLaser[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgLaser[3] == 2) return GiftPlayer(playerid, giveplayerid, 1);

						new icount = GetPlayerToySlots(giveplayerid), success = 0;
						for(new v = 0; v < icount; v++)
						{
							if(PlayerToyInfo[giveplayerid][v][ptModelID] == 0)
							{
								PlayerToyInfo[giveplayerid][v][ptModelID] = 18643;
								PlayerToyInfo[giveplayerid][v][ptBone] = 6;
								PlayerToyInfo[giveplayerid][v][ptPosX] = 0.0;
								PlayerToyInfo[giveplayerid][v][ptPosY] = 0.0;
								PlayerToyInfo[giveplayerid][v][ptPosZ] = 0.0;
								PlayerToyInfo[giveplayerid][v][ptRotX] = 0.0;
								PlayerToyInfo[giveplayerid][v][ptRotY] = 0.0;
								PlayerToyInfo[giveplayerid][v][ptRotZ] = 0.0;
								PlayerToyInfo[giveplayerid][v][ptScaleX] = 1.0;
								PlayerToyInfo[giveplayerid][v][ptScaleY] = 1.0;
								PlayerToyInfo[giveplayerid][v][ptScaleZ] = 1.0;
								PlayerToyInfo[giveplayerid][v][ptTradable] = 1;

								g_mysql_NewToy(giveplayerid, v);
								success = 1;
								break;
							}
						}

						if(success == 0)
						{
							for(new i = 0; i < MAX_PLAYERTOYS; i++)
							{
								if(PlayerToyInfo[giveplayerid][i][ptModelID] == 0)
								{
									PlayerToyInfo[giveplayerid][i][ptModelID] = 18643;
									PlayerToyInfo[giveplayerid][i][ptBone] = 6;
									PlayerToyInfo[giveplayerid][i][ptPosX] = 0.0;
									PlayerToyInfo[giveplayerid][i][ptPosY] = 0.0;
									PlayerToyInfo[giveplayerid][i][ptPosZ] = 0.0;
									PlayerToyInfo[giveplayerid][i][ptRotX] = 0.0;
									PlayerToyInfo[giveplayerid][i][ptRotY] = 0.0;
									PlayerToyInfo[giveplayerid][i][ptRotZ] = 0.0;
									PlayerToyInfo[giveplayerid][i][ptScaleX] = 1.0;
									PlayerToyInfo[giveplayerid][i][ptScaleY] = 1.0;
									PlayerToyInfo[giveplayerid][i][ptScaleZ] = 1.0;
									PlayerToyInfo[giveplayerid][i][ptTradable] = 1;
									PlayerToyInfo[giveplayerid][i][ptSpecial] = 1;

									g_mysql_NewToy(giveplayerid, i);

									SendClientMessageEx(giveplayerid, COLOR_GRAD1, "Due to you not having any available slots, we've temporarily gave you an additional slot to use/sell/trade your laser.");
									SendClientMessageEx(giveplayerid, COLOR_RED, "Note: Please take note that after selling the laser, the temporarily additional toy slot will be removed.");
									break;
								}
							}
						}

						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc a Laser!");
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc mot Laser, chuc vui ve!", GetPlayerNameEx(giveplayerid));
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgLaser[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 27)
					{
						if(dgCustomToy[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgCustomToy[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgCustomToy[3] == 2) return GiftPlayer(playerid, giveplayerid, 1);

						new icount = GetPlayerToySlots(giveplayerid), success = 0;
						for(new v = 0; v < icount; v++)
						{
							if(PlayerToyInfo[giveplayerid][v][ptModelID] == 0)
							{
								PlayerToyInfo[giveplayerid][v][ptModelID] = dgCustomToy[2];
								PlayerToyInfo[giveplayerid][v][ptBone] = 1;
								PlayerToyInfo[giveplayerid][v][ptPosX] = 0.0;
								PlayerToyInfo[giveplayerid][v][ptPosY] = 0.0;
								PlayerToyInfo[giveplayerid][v][ptPosZ] = 0.0;
								PlayerToyInfo[giveplayerid][v][ptRotX] = 0.0;
								PlayerToyInfo[giveplayerid][v][ptRotY] = 0.0;
								PlayerToyInfo[giveplayerid][v][ptRotZ] = 0.0;
								PlayerToyInfo[giveplayerid][v][ptScaleX] = 1.0;
								PlayerToyInfo[giveplayerid][v][ptScaleY] = 1.0;
								PlayerToyInfo[giveplayerid][v][ptScaleZ] = 1.0;
								PlayerToyInfo[giveplayerid][v][ptTradable] = 1;

								g_mysql_NewToy(giveplayerid, v);
								success = 1;
								break;
							}
						}

						if(success == 0)
						{
							for(new i = 0; i < MAX_PLAYERTOYS; i++)
							{
								if(PlayerToyInfo[giveplayerid][i][ptModelID] == 0)
								{
									PlayerToyInfo[giveplayerid][i][ptModelID] = dgCustomToy[2];
									PlayerToyInfo[giveplayerid][i][ptBone] = 6;
									PlayerToyInfo[giveplayerid][i][ptPosX] = 0.0;
									PlayerToyInfo[giveplayerid][i][ptPosY] = 0.0;
									PlayerToyInfo[giveplayerid][i][ptPosZ] = 0.0;
									PlayerToyInfo[giveplayerid][i][ptRotX] = 0.0;
									PlayerToyInfo[giveplayerid][i][ptRotY] = 0.0;
									PlayerToyInfo[giveplayerid][i][ptRotZ] = 0.0;
									PlayerToyInfo[giveplayerid][i][ptScaleX] = 1.0;
									PlayerToyInfo[giveplayerid][i][ptScaleY] = 1.0;
									PlayerToyInfo[giveplayerid][i][ptScaleZ] = 1.0;
									PlayerToyInfo[giveplayerid][i][ptTradable] = 1;
									PlayerToyInfo[giveplayerid][i][ptSpecial] = 1;

									g_mysql_NewToy(giveplayerid, i);

									SendClientMessageEx(giveplayerid, COLOR_GRAD1, "Due to you not having any available slots, we've temporarily gave you an additional slot to use/sell/trade your custom toy.");
									SendClientMessageEx(giveplayerid, COLOR_RED, "Note: Please take note that after selling the custom toy, the temporarily additional toy slot will be removed.");
									break;
								}
							}
						}

						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc a Custom Toy!");
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc mot Custom Toy, chuc vui ve!", GetPlayerNameEx(giveplayerid));
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgCustomToy[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 28)
					{
						if(dgAdmuteReset[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgAdmuteReset[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgAdmuteReset[3] == 2) return GiftPlayer(playerid, giveplayerid, 1);
						if(PlayerInfo[giveplayerid][pADMuteTotal] == 0) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pADMuteTotal] -= dgAdmuteReset[2];

						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc %d Admute Reset!", dgAdmuteReset[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Admute Reset, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgAdmuteReset[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgAdmuteReset[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 29)
					{
						if(dgNewbieMuteReset[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgNewbieMuteReset[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgNewbieMuteReset[3] == 2) return GiftPlayer(playerid, giveplayerid, 1);
						if(PlayerInfo[giveplayerid][pNMuteTotal] == 0) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pNMuteTotal] -= dgNewbieMuteReset[2];

						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc %d Mo khoa newbie!", dgNewbieMuteReset[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Mo khoa newbie, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgNewbieMuteReset[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgNewbieMuteReset[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 30)
					{
						if(dgRestrictedCarVoucher[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgRestrictedCarVoucher[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgRestrictedCarVoucher[3] == 2) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pCarVoucher] += dgRestrictedCarVoucher[2];
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc mot %d Restricted Car Voucher!", dgRestrictedCarVoucher[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Restricted Car Voucher, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgRestrictedCarVoucher[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgRestrictedCarVoucher[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 31)
					{
						if(dgPlatinumVIPVoucher[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgPlatinumVIPVoucher[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgPlatinumVIPVoucher[3] == 2) return GiftPlayer(playerid, giveplayerid, 1);

						SendClientMessageEx(giveplayerid, COLOR_GRAD2, "Chuc ban may man lan sau");
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					else return SendClientMessageEx(giveplayerid, COLOR_RED, "Seems like the dynamic giftbox is empty, please try again.");
				}
				case 96..100: // cat 4 super rare
				{
					new randy = random(32);
					printf("cat 1 %d", randy);

					if(randy == 0)
					{
						if(dgMoney[3] == 3) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgMoney[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgMoney[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);

						GivePlayerMoneyEx(giveplayerid, dgMoney[2]);
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc $%s!", number_format(dgMoney[2]));
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc $%s, chuc vui ve!", GetPlayerNameEx(giveplayerid), number_format(dgMoney[2]));
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgMoney[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 1)
					{
						if(dgRimKit[3] == 3) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgRimKit[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgRimKit[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pRimMod] += dgRimKit[2];
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc %d rimkit!", dgRimKit[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d rimkit, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgRimKit[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgRimKit[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 2)
					{
						if(dgFirework[3] == 3) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgFirework[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgFirework[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pFirework] += dgFirework[2];
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc %d firework!", dgFirework[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d firework, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgFirework[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgFirework[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 3)
					{
						if(dgGVIP[3] == 3) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgGVIP[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgGVIP[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);

						SendClientMessageEx(giveplayerid, COLOR_GRAD2, "Chuc ban may man lan sau");
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 4)
					{
						if(dgGVIPEx[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgGVIPEx[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgGVIPEx[3] == 3) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pGVIPVoucher] += dgGVIPEx[2];
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc %d Mot thang dung Gold VIP Voucher!", dgGVIPEx[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Mot thang dung Gold VIP Voucher, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgGVIPEx[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgGVIPEx[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 5)
					{
						if(dgSVIP[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgSVIP[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgSVIP[3] == 3) return GiftPlayer(playerid, giveplayerid, 1);

						AddFlag(giveplayerid, INVALID_PLAYER_ID, "Dynamic Gift Box: 7 ngay dung Silver VIP");

      					format(string, sizeof(string), "Xin chuc mung, ban nhan duoc %d 7 ngay dung Silver VIP!", dgSVIP[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Chu y: giai thuong se phai mat toi 48 gio de nhan duoc..");
						format(string, sizeof(string), "* %s da nhan duoc %d 7 ngay dung Silver VIP, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgSVIP[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgSVIP[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 6)
					{
						if(dgSVIPEx[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgSVIPEx[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgSVIPEx[3] == 3) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pSVIPVoucher] += dgSVIPEx[2];
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc %d mot thang Silver VIP Voucher!", dgSVIPEx[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d mot thang Silver VIP Voucher, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgSVIPEx[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgSVIPEx[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 7)
					{
						if(dgCarSlot[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgCarSlot[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgCarSlot[3] == 3) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pVehicleSlot] += dgCarSlot[2];
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc %d Car Slot!", dgCarSlot[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Car Slot, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgCarSlot[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgCarSlot[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 8)
					{
						if(dgToySlot[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgCarSlot[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgCarSlot[3] == 3) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pToySlot] += dgToySlot[2];
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc %d Toy Slot!", dgToySlot[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Toy Slot, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgToySlot[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgToySlot[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 9)
					{
						if(dgArmor[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgArmor[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgArmor[3] == 3) return GiftPlayer(playerid, giveplayerid, 1);

						new Float: armor;
						GetPlayerArmour(giveplayerid, armor);

						if(armor+dgArmor[2] >= 100) return GiftPlayer(playerid, giveplayerid, 1);

						SetPlayerArmor(giveplayerid, armor + dgArmor[2]);
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc %d Armour!", dgArmor[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Armour, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgArmor[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgArmor[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 10)
					{
						if(dgFirstaid[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgFirstaid[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgFirstaid[3] == 3) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pFirstaid] += dgFirstaid[2];
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc %d Firstaid!", dgFirstaid[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Firstaid, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgFirstaid[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgFirstaid[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 11)
					{
						if(dgDDFlag[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgDDFlag[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgDDFlag[3] == 3) return GiftPlayer(playerid, giveplayerid, 1);

						AddFlag(giveplayerid, INVALID_PLAYER_ID, "Dynamic Gift Box: 1 Dynamic Door");

						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc %d Dynamic Door Flag!", dgDDFlag[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Chu y: giai thuong se phai mat toi 48 gio de nhan duoc..");
						format(string, sizeof(string), "* %s da nhan duoc %d Dynamic Door Flag, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgDDFlag[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgDDFlag[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 12)
					{
						if(dgGateFlag[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgGateFlag[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgGateFlag[3] == 3) return GiftPlayer(playerid, giveplayerid, 1);

						AddFlag(giveplayerid, INVALID_PLAYER_ID, "Dynamic Gift Box: 1 Dynamic Gate");

						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc %d Dynamic Door Flag!", dgGateFlag[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Chu y: giai thuong se phai mat toi 48 gio de nhan duoc..");
						format(string, sizeof(string), "* %s da nhan duoc %d Dynamic Gate Flag, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgGateFlag[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgGateFlag[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 13)
					{
						if(dgCredits[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgCredits[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgCredits[3] == 3) return GiftPlayer(playerid, giveplayerid, 1);

						GivePlayerCredits(giveplayerid, dgCredits[2], 1);
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc %d Credit!", dgCredits[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Credit, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgCredits[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgCredits[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 14)
					{
						if(dgPriorityAd[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgPriorityAd[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgPriorityAd[3] == 3) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pAdvertVoucher]++;
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc %d Voucher Quang cao uu tien!", dgPriorityAd[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d quang cao uu tien, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgPriorityAd[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgPriorityAd[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 15)
					{
						if(dgHealthNArmor[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgHealthNArmor[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgHealthNArmor[3] == 3) return GiftPlayer(playerid, giveplayerid, 1);

						SetPlayerHealth(giveplayerid, 100.0);
						SetPlayerArmor(giveplayerid, 100);
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc Full Health & Armor!");
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Full Health & Armor, chuc vui ve!", GetPlayerNameEx(giveplayerid));
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgHealthNArmor[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 16)
					{
						if(dgGiftReset[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgGiftReset[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgGiftReset[3] == 3) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pGiftVoucher] += dgGiftReset[2];
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc a %d Gift Reset Voucher!", dgGiftReset[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Gift Reset Voucher, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgGiftReset[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgGiftReset[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 17)
					{
						if(dgMaterial[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgMaterial[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgMaterial[3] == 3) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pMats] += dgMaterial[2];
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc a %d vat lieu!", dgMaterial[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d vat lieu, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgMaterial[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgMaterial[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 18)
					{
						if(dgWarning[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgWarning[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgWarning[3] == 3) return GiftPlayer(playerid, giveplayerid, 1);

						if(dgWarning[2] > 3 || dgWarning[2] < 0)
						{
							if(PlayerInfo[giveplayerid][pWarns] == 0) return GiftPlayer(playerid, giveplayerid, 1);

							PlayerInfo[giveplayerid][pWarns] -= dgWarning[2];
						}
						else
							return GiftPlayer(playerid, giveplayerid, 1);

						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc mot %d loai bo canh cao!", dgWarning[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d loai bo canh cao, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgWarning[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgWarning[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 19)
					{
						if(dgPot[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgPot[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgPot[3] == 3) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pPot] += dgPot[2];
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc a %d Pot!", dgPot[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Pot, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgPot[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgPot[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 20)
					{
						if(dgCrack[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgCrack[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgCrack[3] == 3) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pCrack] += dgCrack[2];
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc a %d Crack!", dgCrack[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Crack, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgCrack[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgCrack[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 21)
					{
						if(dgPaintballToken[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgPaintballToken[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgPaintballToken[3] == 3) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pPaintTokens] += dgPaintballToken[2];
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc a %d Paintball Token!", dgPaintballToken[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Paintball Token, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgPaintballToken[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgPaintballToken[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 22)
					{
						if(dgVIPToken[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVIPToken[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVIPToken[3] == 3) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pTokens] += dgVIPToken[2];
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc a %d VIP Token!", dgVIPToken[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d VIP Token, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgVIPToken[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVIPToken[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 23)
					{
						if(dgRespectPoint[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgRespectPoint[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgRespectPoint[3] == 3) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pExp] += dgRespectPoint[2];
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc a %d Respect Point!", dgRespectPoint[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Respect Point, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgRespectPoint[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgRespectPoint[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 24)
					{
						if(dgCarVoucher[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgCarVoucher[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgCarVoucher[3] == 3) return GiftPlayer(playerid, giveplayerid, 1);

						SendClientMessageEx(giveplayerid, COLOR_GRAD2, "Chuc ban may man lan sau");
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 25)
					{
						if(dgBuddyInvite[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgBuddyInvite[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgBuddyInvite[3] == 3) return GiftPlayer(playerid, giveplayerid, 1);
						if(PlayerInfo[giveplayerid][pDonateRank] != 0) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pDonateRank] = 1;
						PlayerInfo[giveplayerid][pTempVIP] = 10800;
						PlayerInfo[giveplayerid][pBuddyInvited] = 1;
						format(string, sizeof(string), "BUDDY INVITE: %s da duoc moi dung VIP tu he thong", GetPlayerNameEx(giveplayerid));
						Log("logs/setvip.log", string);

						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc mot Buddy Invite!");
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc mot BuddyInvite, chuc vui ve!", GetPlayerNameEx(giveplayerid));
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgBuddyInvite[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 26)
					{
						if(dgLaser[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgLaser[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgLaser[3] == 3) return GiftPlayer(playerid, giveplayerid, 1);

						new icount = GetPlayerToySlots(giveplayerid), success = 0;
						for(new v = 0; v < icount; v++)
						{
							if(PlayerToyInfo[giveplayerid][v][ptModelID] == 0)
							{
								PlayerToyInfo[giveplayerid][v][ptModelID] = 18643;
								PlayerToyInfo[giveplayerid][v][ptBone] = 6;
								PlayerToyInfo[giveplayerid][v][ptPosX] = 0.0;
								PlayerToyInfo[giveplayerid][v][ptPosY] = 0.0;
								PlayerToyInfo[giveplayerid][v][ptPosZ] = 0.0;
								PlayerToyInfo[giveplayerid][v][ptRotX] = 0.0;
								PlayerToyInfo[giveplayerid][v][ptRotY] = 0.0;
								PlayerToyInfo[giveplayerid][v][ptRotZ] = 0.0;
								PlayerToyInfo[giveplayerid][v][ptScaleX] = 1.0;
								PlayerToyInfo[giveplayerid][v][ptScaleY] = 1.0;
								PlayerToyInfo[giveplayerid][v][ptScaleZ] = 1.0;
								PlayerToyInfo[giveplayerid][v][ptTradable] = 1;

								g_mysql_NewToy(giveplayerid, v);
								success = 1;
								break;
							}
						}

						if(success == 0)
						{
							for(new i = 0; i < MAX_PLAYERTOYS; i++)
							{
								if(PlayerToyInfo[giveplayerid][i][ptModelID] == 0)
								{
									PlayerToyInfo[giveplayerid][i][ptModelID] = 18643;
									PlayerToyInfo[giveplayerid][i][ptBone] = 6;
									PlayerToyInfo[giveplayerid][i][ptPosX] = 0.0;
									PlayerToyInfo[giveplayerid][i][ptPosY] = 0.0;
									PlayerToyInfo[giveplayerid][i][ptPosZ] = 0.0;
									PlayerToyInfo[giveplayerid][i][ptRotX] = 0.0;
									PlayerToyInfo[giveplayerid][i][ptRotY] = 0.0;
									PlayerToyInfo[giveplayerid][i][ptRotZ] = 0.0;
									PlayerToyInfo[giveplayerid][i][ptScaleX] = 1.0;
									PlayerToyInfo[giveplayerid][i][ptScaleY] = 1.0;
									PlayerToyInfo[giveplayerid][i][ptScaleZ] = 1.0;
									PlayerToyInfo[giveplayerid][i][ptTradable] = 1;
									PlayerToyInfo[giveplayerid][i][ptSpecial] = 1;

									g_mysql_NewToy(giveplayerid, i);

									SendClientMessageEx(giveplayerid, COLOR_GRAD1, "Do ban da het slot toys, chung toi da cho ban them 1 slot toys , hay su dung /selltoy.");
									SendClientMessageEx(giveplayerid, COLOR_RED, "Chu y:sau khi ban toys, slot do se khong duoc su dung.");
									break;
								}
							}
						}

						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc mot Laser!");
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc mot Laser, chuc vui ve!", GetPlayerNameEx(giveplayerid));
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgLaser[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 27)
					{
						if(dgCustomToy[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgCustomToy[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgCustomToy[3] == 3) return GiftPlayer(playerid, giveplayerid, 1);

						new icount = GetPlayerToySlots(giveplayerid), success = 0;
						for(new v = 0; v < icount; v++)
						{
							if(PlayerToyInfo[giveplayerid][v][ptModelID] == 0)
							{
								PlayerToyInfo[giveplayerid][v][ptModelID] = dgCustomToy[2];
								PlayerToyInfo[giveplayerid][v][ptBone] = 1;
								PlayerToyInfo[giveplayerid][v][ptPosX] = 0.0;
								PlayerToyInfo[giveplayerid][v][ptPosY] = 0.0;
								PlayerToyInfo[giveplayerid][v][ptPosZ] = 0.0;
								PlayerToyInfo[giveplayerid][v][ptRotX] = 0.0;
								PlayerToyInfo[giveplayerid][v][ptRotY] = 0.0;
								PlayerToyInfo[giveplayerid][v][ptRotZ] = 0.0;
								PlayerToyInfo[giveplayerid][v][ptScaleX] = 1.0;
								PlayerToyInfo[giveplayerid][v][ptScaleY] = 1.0;
								PlayerToyInfo[giveplayerid][v][ptScaleZ] = 1.0;
								PlayerToyInfo[giveplayerid][v][ptTradable] = 1;

								g_mysql_NewToy(giveplayerid, v);
								success = 1;
								break;
							}
						}

						if(success == 0)
						{
							for(new i = 0; i < MAX_PLAYERTOYS; i++)
							{
								if(PlayerToyInfo[giveplayerid][i][ptModelID] == 0)
								{
									PlayerToyInfo[giveplayerid][i][ptModelID] = dgCustomToy[2];
									PlayerToyInfo[giveplayerid][i][ptBone] = 6;
									PlayerToyInfo[giveplayerid][i][ptPosX] = 0.0;
									PlayerToyInfo[giveplayerid][i][ptPosY] = 0.0;
									PlayerToyInfo[giveplayerid][i][ptPosZ] = 0.0;
									PlayerToyInfo[giveplayerid][i][ptRotX] = 0.0;
									PlayerToyInfo[giveplayerid][i][ptRotY] = 0.0;
									PlayerToyInfo[giveplayerid][i][ptRotZ] = 0.0;
									PlayerToyInfo[giveplayerid][i][ptScaleX] = 1.0;
									PlayerToyInfo[giveplayerid][i][ptScaleY] = 1.0;
									PlayerToyInfo[giveplayerid][i][ptScaleZ] = 1.0;
									PlayerToyInfo[giveplayerid][i][ptTradable] = 1;
									PlayerToyInfo[giveplayerid][i][ptSpecial] = 1;

									g_mysql_NewToy(giveplayerid, i);

									SendClientMessageEx(giveplayerid, COLOR_GRAD1, "Do ban da het slot toys, chung toi da cho ban them 1 slot toys , hay su dung /selltoy.");
									SendClientMessageEx(giveplayerid, COLOR_RED, "Chu y:sau khi ban toys, slot do se khong duoc su dung.");
									break;
								}
							}
						}

						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc a Custom Toy!");
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc mot Custom Toy, chuc vui ve!", GetPlayerNameEx(giveplayerid));
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgCustomToy[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 28)
					{
						if(dgAdmuteReset[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgAdmuteReset[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgAdmuteReset[3] == 3) return GiftPlayer(playerid, giveplayerid, 1);
						if(PlayerInfo[giveplayerid][pADMuteTotal] == 0) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pADMuteTotal] -= dgAdmuteReset[2];

						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc %d bo khoa quang cao!", dgAdmuteReset[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d bo khoa quang cao, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgAdmuteReset[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgAdmuteReset[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 29)
					{
						if(dgNewbieMuteReset[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgNewbieMuteReset[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgNewbieMuteReset[3] == 3) return GiftPlayer(playerid, giveplayerid, 1);
						if(PlayerInfo[giveplayerid][pNMuteTotal] == 0) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pNMuteTotal] -= dgNewbieMuteReset[2];

						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc %d bo khoa newbie!", dgNewbieMuteReset[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d bo khoa newbie, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgNewbieMuteReset[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgNewbieMuteReset[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 30)
					{
						if(dgRestrictedCarVoucher[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgRestrictedCarVoucher[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgRestrictedCarVoucher[3] == 3) return GiftPlayer(playerid, giveplayerid, 1);

						PlayerInfo[giveplayerid][pCarVoucher] += dgRestrictedCarVoucher[2];
						format(string, sizeof(string), "Xin chuc mung, ban nhan duoc a %d Restricted Car Voucher!", dgRestrictedCarVoucher[2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s da nhan duoc %d Restricted Car Voucher, chuc vui ve!", GetPlayerNameEx(giveplayerid), dgRestrictedCarVoucher[2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgRestrictedCarVoucher[1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 31)
					{
						if(dgPlatinumVIPVoucher[1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgPlatinumVIPVoucher[0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgPlatinumVIPVoucher[3] == 3) return GiftPlayer(playerid, giveplayerid, 1);

						SendClientMessageEx(giveplayerid, COLOR_GRAD2, "Chuc ban may man lan sau");
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					else return SendClientMessageEx(giveplayerid, COLOR_RED, "Co ve gift box khong con qua tang, hay thu lai");
				}
			}
		}
		SaveDynamicGiftBox();
	}
	if(gtype == 2)
	{
		if(playerid == MAX_PLAYERS || PlayerInfo[playerid][pAdmin] >= 2)
		{
			new randgift = Random(1, 103);
			if(randgift >= 1 && randgift <= 83)
			{
				new gift = Random(1, 12);
				if(gift == 1)
				{
					if(PlayerInfo[giveplayerid][pConnectHours] < 2 || PlayerInfo[giveplayerid][pWRestricted] > 0) return GiftPlayer(playerid, giveplayerid);
					GivePlayerValidWeapon(giveplayerid, 27, 1);
					GivePlayerValidWeapon(giveplayerid, 24, 1);
					GivePlayerValidWeapon(giveplayerid, 31, 1);
					GivePlayerValidWeapon(giveplayerid, 34, 1);
					GivePlayerValidWeapon(giveplayerid, 29, 1);
					SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Xin chuc mung - ban da nhan duoc 1 pack vu khi!");
					format(string, sizeof(string), "* %s da nhan duoc mot 1 pack vu khi, chuc vui ve!", GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
				}
				else if(gift == 2)
				{
					if(PlayerInfo[giveplayerid][pDonateRank] > 2) return GiftPlayer(playerid, giveplayerid);
					PlayerInfo[giveplayerid][pFirstaid]++;
					SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Xin chuc mung - ban da nhan duoc mot first aid kit!");
					format(string, sizeof(string), "* %s da nhan duoc mot first aid kit, chuc vui ve!", GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
				}
				else if(gift == 3)
				{
					PlayerInfo[giveplayerid][pMats] += 2000;
					SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Xin chuc mung - ban da nhan duoc 2,000 vat lieu!");
					format(string, sizeof(string), "* %s da nhan duoc 2,000 vat lieu, chuc vui ve!", GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
				}
				else if(gift == 4)
				{
					if(PlayerInfo[giveplayerid][pWarns] != 0)
					{
						PlayerInfo[giveplayerid][pWarns]--;
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Xin chuc mung - ban da nhan duoc mot loai bo canh cao!");
						format(string, sizeof(string), "* %s nhan duoc 1 loai bo canh cao, chuc vui ve!", GetPlayerNameEx(giveplayerid));
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
					}
					else
					{
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, "Mot canh cao cua ban da bi loai bo - hay thu lai!");
						GiftPlayer(playerid, giveplayerid);
						return 1;
					}
				}
				else if(gift == 5)
				{
					PlayerInfo[giveplayerid][pPot] += 50;
					SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Xin chuc mung - ban da nhan duoc 50 grams pot!");
					format(string, sizeof(string), "* %s da nhan duoc 50 grams pot, chuc vui ve!", GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
				}
				else if(gift == 6)
				{
					PlayerInfo[giveplayerid][pCrack] += 25;
					SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Xin chuc mung - ban da nhan duoc 25 grams crack!");
					format(string, sizeof(string), "* %s da nhan duoc 25 grams crack, chuc vui ve!", GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
				}
				else if(gift == 7)
				{
					GivePlayerMoneyEx(giveplayerid, 20000);
					SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Xin chuc mung - ban da nhan duoc $20,000!");
					format(string, sizeof(string), "* %s da nhan duoc $20,000, chuc vui ve!", GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
				}
				else if(gift == 8)
				{
					PlayerInfo[giveplayerid][pPaintTokens] += 10;
					SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Xin chuc mung - ban da nhan duoc 10 paintball tokens!");
					format(string, sizeof(string), "* %s da nhan duoc 10 paintball tokens, chuc vui ve!", GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
				}
				else if(gift == 9)
				{
					if(PlayerInfo[giveplayerid][pDonateRank] < 1) return GiftPlayer(playerid, giveplayerid);
					PlayerInfo[giveplayerid][pTokens] += 5;
					SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Xin chuc mung - ban da nhan duoc 5 VIP tokens!");
					format(string, sizeof(string), "* %s da nhan duoc 5 VIP tokens, chuc vui ve!", GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
				}
				else if(gift == 10)
				{
					PlayerInfo[giveplayerid][pFirework] += 2;
					SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Xin chuc mung - ban da nhan duoc 2 Fireworks!");
					format(string, sizeof(string), "* %s da nhan duoc 2 Fireworks, chuc vui ve!", GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
				}
				else if(gift == 11)
				{
					PlayerInfo[giveplayerid][pExp] += 5;
					SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Xin chuc mung - ban da nhan duoc 5 Respect Points!");
					format(string, sizeof(string), "* %s da nhan duoc 5 Respect Points, chuc vui ve!", GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
				}
			}
			else if(randgift > 83 && randgift <= 98)
			{
				new gift = Random(1, 9);
				if(gift == 1)
				{
					GivePlayerMoneyEx(giveplayerid, 150000);
					SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Xin chuc mung - ban da nhan duoc $150,000!");
					format(string, sizeof(string), "* %s da nhan duoc $150,000, chuc vui ve!", GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
				}
				else if(gift == 2)
				{
					PlayerInfo[giveplayerid][pMats] += 15000;
					SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Xin chuc mung - ban da nhan duoc 15,000 vat lieu!");
					format(string, sizeof(string), "* %s da nhan duoc 15,000 materials, chuc vui ve!", GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
				}
				else if(gift == 3)
				{
					PlayerInfo[giveplayerid][pExp] += 10;
					SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Xin chuc mung - ban da nhan duoc 10 respect points!");
					format(string, sizeof(string), "* %s da nhan duoc 10 respect points, chuc vui ve!", GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
				}
				else if(gift == 4)
				{
					SendClientMessageEx(giveplayerid, COLOR_GRAD2, "Chuc ban may man lan sau");
				}
				else if(gift == 5)
				{
					if(PlayerInfo[giveplayerid][pDonateRank] > 0)
					{
						PlayerInfo[giveplayerid][pTokens] += 15;
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Xin chuc mung - ban da nhan duoc 15 VIP tokens!");
						format(string, sizeof(string), "* %s da nhan duoc 15 VIP tokens, chuc vui ve!", GetPlayerNameEx(giveplayerid));
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
					}
					else
					{
						PlayerInfo[giveplayerid][pDonateRank] = 1;
						PlayerInfo[giveplayerid][pTempVIP] = 10800;
						PlayerInfo[giveplayerid][pBuddyInvited] = 1;
						format(string, sizeof(string), "Ban da tro thanh 1 VIP cap do 1 trong 3 gio. chuc vui ve!", GetPlayerNameEx(giveplayerid));
						SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
						format(string, sizeof(string), "BUDDY INVITE: %s da nhan duoc mot buddyinvite.", GetPlayerNameEx(giveplayerid));
						Log("logs/setvip.log", string);
						format(string, sizeof(string), "* %s da nhan duoc 3 gio dung VIP, chuc vui ve!", GetPlayerNameEx(giveplayerid));
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
					}
				}
				else if(gift == 6)
				{
					SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Xin chuc mung - ban da nhan duoc mot Free Laser Pointer!");
					format(string, sizeof(string), "* %s da nhan duoc mot Free Laser Pointer, chuc vui ve!", GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
					new icount = GetPlayerToySlots(giveplayerid);
					for(new v = 0; v < icount; v++)
					{
						if(PlayerToyInfo[giveplayerid][v][ptModelID] == 0)
						{
							PlayerToyInfo[giveplayerid][v][ptModelID] = 18643;
							PlayerToyInfo[giveplayerid][v][ptBone] = 6;
							PlayerToyInfo[giveplayerid][v][ptPosX] = 0.0;
							PlayerToyInfo[giveplayerid][v][ptPosY] = 0.0;
							PlayerToyInfo[giveplayerid][v][ptPosZ] = 0.0;
							PlayerToyInfo[giveplayerid][v][ptRotX] = 0.0;
							PlayerToyInfo[giveplayerid][v][ptRotY] = 0.0;
							PlayerToyInfo[giveplayerid][v][ptRotZ] = 0.0;
							PlayerToyInfo[giveplayerid][v][ptScaleX] = 1.0;
							PlayerToyInfo[giveplayerid][v][ptScaleY] = 1.0;
							PlayerToyInfo[giveplayerid][v][ptScaleZ] = 1.0;
							PlayerToyInfo[giveplayerid][v][ptTradable] = 1;

							g_mysql_NewToy(giveplayerid, v);
							return 1;
						}
					}

					for(new i = 0; i < MAX_PLAYERTOYS; i++)
					{
						if(PlayerToyInfo[giveplayerid][i][ptModelID] == 0)
						{
							PlayerToyInfo[giveplayerid][i][ptModelID] = 18643;
							PlayerToyInfo[giveplayerid][i][ptBone] = 6;
							PlayerToyInfo[giveplayerid][i][ptPosX] = 0.0;
							PlayerToyInfo[giveplayerid][i][ptPosY] = 0.0;
							PlayerToyInfo[giveplayerid][i][ptPosZ] = 0.0;
							PlayerToyInfo[giveplayerid][i][ptRotX] = 0.0;
							PlayerToyInfo[giveplayerid][i][ptRotY] = 0.0;
							PlayerToyInfo[giveplayerid][i][ptRotZ] = 0.0;
							PlayerToyInfo[giveplayerid][i][ptScaleX] = 1.0;
							PlayerToyInfo[giveplayerid][i][ptScaleY] = 1.0;
							PlayerToyInfo[giveplayerid][i][ptScaleZ] = 1.0;
							PlayerToyInfo[giveplayerid][i][ptTradable] = 1;
							PlayerToyInfo[giveplayerid][i][ptSpecial] = 1;

							g_mysql_NewToy(giveplayerid, i);

							SendClientMessageEx(giveplayerid, COLOR_GRAD1, "Do ban da het slot toys, chung toi da cho ban them 1 slot toys , hay su dung /selltoy.");
							SendClientMessageEx(giveplayerid, COLOR_RED, "Chu y:sau khi ban toy, slot do se khong duoc su dung them nua.");
							break;
						}
					}
					//AddFlag(giveplayerid, INVALID_PLAYER_ID, "Free Laser Pointer (Gift)");
					//SendClientMessageEx(giveplayerid, COLOR_GREY, "You have no empty toy slots, so you have been flagged for a free laser.");
				}
				else if(gift == 7)
				{
					if(PlayerInfo[giveplayerid][pADMuteTotal] < 1) return GiftPlayer(playerid, giveplayerid);
					PlayerInfo[giveplayerid][pADMuteTotal] = 0;
					SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Xin chuc mung - ban nhan duoc mo khoa quang cao mien phi!");
					format(string, sizeof(string), "* %s ban nhan duoc mo khoa quang cao mien phi, chuc vui ve!", GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
				}
				else if(gift == 8)
				{
					if(PlayerInfo[giveplayerid][pNMuteTotal] < 1) return GiftPlayer(playerid, giveplayerid);
					PlayerInfo[giveplayerid][pNMuteTotal] = 0;
					SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Xin chuc mung - ban nhan duoc mo khoa newb mien phi!");
					format(string, sizeof(string), "* %s ban nhan duoc mo khoa newb mine phi, chuc vui ve!", GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
				}
			}
			else if(randgift > 98 && randgift <= 100)
			{
				new gift = Random(1, 6);
				if(gift == 1 && PlayerInfo[giveplayerid][pDonateRank] <= 2) // Silver VIP can get it extended, I suppose
				{
					SendClientMessageEx(giveplayerid, COLOR_GRAD2, "Chuc ban may man lan sau");
				}
				else if(gift == 2)
				{
					SendClientMessageEx(giveplayerid, COLOR_GRAD2, "Chuc ban may man lan sau");
				}
				else if(gift == 3)
				{
					if(PlayerInfo[giveplayerid][pDonateRank] < 1) return GiftPlayer(playerid, giveplayerid);
					PlayerInfo[giveplayerid][pTokens] += 50;
					SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Chuc mung ban - ban nhan duoc 50 VIP tokens!");
					format(string, sizeof(string), "* %s da nhan duoc 50 VIP tokens, chuc vui ve!", GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
				}
				else if(gift == 4)
				{

					GivePlayerMoneyEx(giveplayerid, 500000);
					SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Chuc mung ban - ban nhan duoc $500,000!");
					if(playerid == MAX_PLAYERS) {
						format(string, sizeof(string), "AdmCmd: %s da nhan duoc $500,000 tu he thong.", GetPlayerNameEx(giveplayerid));
						format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s da nhan duoc $500,000 tu he thong.", GetPlayerNameEx(giveplayerid));
					}
					else {
						format(string, sizeof(string), "AdmCmd: %s dung la thien tai, %s duoc $500,000.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
						format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s dung la thien tai, %s duoc $500,000.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
					}
					Log("logs/gifts.log", string);
					ABroadCast(COLOR_YELLOW, string, 2);
					format(string, sizeof(string), "* %s nhan duoc $500,000, chuc vui ve!", GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
				}
				else if(gift == 5)
				{
     				SendClientMessageEx(giveplayerid, COLOR_GRAD2, "Chuc ban may man lan sau");
				}
			}
			else if(randgift > 100 && randgift <= 103) // Rim Mod
			{
				new gift = Random(1, 10);
				if(gift >= 1 && gift <= 3)
				{
					if(RimMod > 0) // Rim Kit
					{
						PlayerInfo[giveplayerid][pRimMod]++;
						RimMod--;
						g_mysql_SaveMOTD();

						if(playerid == MAX_PLAYERS) {
							format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s nhan duoc 1 bo mod goldrim mien phi tu he thong. (%d left)", GetPlayerNameEx(giveplayerid), RimMod);
						}
						else {
							format(string, sizeof(string), "AdmCmd: %s dung la thien tai, %s duoc 1 bo mod goldrim mien phi. (%d left)", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), RimMod);
						}

						Log("logs/gifts.log", string);
						format(string, sizeof(string), "* %s nhan duoc 1 bo mod goldrim mien phi, chuc vui ve! Chi con %d kits con lai.", GetPlayerNameEx(giveplayerid), RimMod);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
					}
					else
					{
						GiftPlayer(MAX_PLAYERS, giveplayerid);
						return 1;
					}
				}
				else if(gift == 4) //
				{
					if(CarVoucher > 0)
					{
						PlayerInfo[giveplayerid][pCarVoucher]++;
						CarVoucher--;
						g_mysql_SaveMOTD();

						if(playerid == MAX_PLAYERS) {
							format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s nhan duoc 1 phieu mo them slot xe tu he thong. (%d con lai)", GetPlayerNameEx(giveplayerid), CarVoucher);
						}
						else {
							format(string, sizeof(string), "AdmCmd: %s dung la thien tai, %s duoc them mot slot xe. (%d con lai)", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), CarVoucher);
						}

						Log("logs/gifts.log", string);
						format(string, sizeof(string), "* %s da nhan them 1slot xe mien phi tu he thong, chuc vui ve! Chi con %d car vouchers con lai.", GetPlayerNameEx(giveplayerid), CarVoucher);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
						SendClientMessageEx(giveplayerid, COLOR_CYAN, " Mot phieu mo them slot xe da duoc them vao tai khoan cua ban.");
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Ban co the kiem tra voucher cua minh bang /myvouchers");
					}
					else
					{
						GiftPlayer(MAX_PLAYERS, giveplayerid);
						return 1;
					}
				}
				else if(gift == 5) //
				{
					new gift2 = Random(1, 15);
					if(gift2 == 3)
					{
						if(PVIPVoucher > 0)
						{
							PlayerInfo[giveplayerid][pPVIPVoucher]++;
							PVIPVoucher--;
							g_mysql_SaveMOTD();

							if(playerid == MAX_PLAYERS)
							{
								format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s da may man nhan duoc Platinum VIP Voucher tu he thong. (%d con lai)", GetPlayerNameEx(giveplayerid), PVIPVoucher);
							}
							else
							{
								format(string, sizeof(string), "AdmCmd: %s dung la thien tai, %s da nhan duoc Platinum VIP Voucher. (%d con lai)", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), PVIPVoucher);
							}

							Log("logs/gifts.log", string);
							format(string, sizeof(string), "* %s that may man da nhan duoc Platinum VIP Voucher, Chuc vui ve! Co %d Platinum VIP Vouchers con lai.", GetPlayerNameEx(giveplayerid), PVIPVoucher);
							ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
							SendClientMessageEx(giveplayerid, COLOR_CYAN, " 1 Platinum VIP Voucher da duoc them vao tai khoan cua ban.");
							SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Ban co the kiem tra vao cac phieu cua ban hien co bang cach /myvouchers");

							SendClientMessageToAll(COLOR_WHITE, string);
						}
						else
						{
							GiftPlayer(MAX_PLAYERS, giveplayerid);
							return 1;
						}
					}
					else
					{
						GiftPlayer(MAX_PLAYERS, giveplayerid);
						return 1;
					}
				}
				else
				{
					GiftPlayer(MAX_PLAYERS, giveplayerid);
					return 1;
				}
			}
			PlayerInfo[giveplayerid][pGiftTime] = 300;
		}
	}
	return 1;
}

stock GetDynamicGiftBoxType(value)
{
	new string[128];
	if(value == 0)
		format(string, sizeof(string), "Less Common");
	else if(value == 1)
		format(string, sizeof(string), "Common");
	else if(value == 2)
		format(string, sizeof(string), "Rare");
	else if(value == 3)
		format(string, sizeof(string), "Super Rare");
	return string;
}

forward TeleportToShop(playerid);
public TeleportToShop(playerid)
{
	if(GetPVarType(playerid, "PlayerCuffed") || GetPVarType(playerid, "Injured") || GetPVarType(playerid, "IsFrozen") || PlayerInfo[playerid][pHospital] || PlayerInfo[playerid][pJailTime] > 0 || GetPVarInt(playerid, "EventToken") == 1 || GetPVarInt(playerid, "IsInArena") >= 0)
		return DeletePVar(playerid, "ShopTP"), SendClientMessage(playerid, COLOR_GRAD2, "(SERVER) Teleportation da bi huy bo.");
	if(gettime() - LastShot[playerid] < 30) return DeletePVar(playerid, "ShopTP"), SendClientMessageEx(playerid, COLOR_GRAD2, "ban da bi thuong trong 30s cuoi cung, ban se khong duoc dich chuyen den cac cua hang.");
	if(GetPVarInt(playerid, "ShopTP") == 1)
	{
		SetPlayerPos(playerid, 2957.9670, -1459.4045, 10.8092);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		TogglePlayerControllable(playerid, 1);
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Neu ban muon roi khoi cua hang, su dung /leaveshop de quay ve vi tri cu.");
		SendClientMessageEx(playerid, COLOR_ORANGE, "{ff0000}Chu y{ffffff}: ban se khong the quay tro lai vi tri truoc cua ban khi mua mot chiec xe.");
	}
	return 1;
}

forward HidePlayerTextDraw(playerid, PlayerText:txd);
public HidePlayerTextDraw(playerid, PlayerText:txd) return PlayerTextDrawHide(playerid, txd);

forward LoginCheckEx(i);
public LoginCheckEx(i)
{
	new ok = 0, count = 0, Float: pos[3], string[128];
	if(gPlayerLogged{i} == 0 && IsPlayerConnected(i))
	{
		GetPlayerPos(i, pos[0], pos[1], pos[2]);
		for(new x; x < sizeof(JoinCameraPosition); x++)
		{
			if(pos[0] != JoinCameraPosition[x][0] && pos[1] != JoinCameraPosition[x][1] && pos[2] != JoinCameraPosition[x][2] && (count == 8))
			{
				format(string, sizeof(string), "%s [%s] da di chuyen vi tri dang nhap.", GetPlayerNameEx(i), GetPlayerIpEx(i));
				Log("logs/security.log", string);
				SendClientMessage(i, COLOR_WHITE, "(SERVER) Ban da di chuyen khoi man hinh dang nhap!");
				ShowPlayerDialog(i, -1, DIALOG_STYLE_MSGBOX, "", "", "", "");
				SetTimerEx("KickEx", 1000, 0, "i", i);
				ok = 1;
			}
			count++;
		}

		if(ok == 0)
		{
			SetTimerEx("LoginCheckEx", 5000, 0, "i", i);
		}
	}
	return true;
}

forward ClaimShopItems(playerid); public ClaimShopItems(playerid)
{
	new string[128];
	if(CpStore[playerid][cXP] > 0)
	{
		PlayerInfo[playerid][pXP] += CpStore[playerid][cXP];
		format(string, sizeof(string), "Ban da yeu cau %s XP tu cua hang.", number_format(CpStore[playerid][cXP]));
		SendClientMessageEx(playerid, COLOR_YELLOW, string);
	}
	// now we delete all the rows found by the result data.
	new query[128];
	format(query, sizeof(query), "DELETE FROM `cp_store` WHERE `User_Id`= %d", PlayerInfo[playerid][pId]);
	mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
	return 1;
}

CMD:todlol(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] >= 2)
	{
		new string[128], time;
		if(sscanf(params, "d", time)) return SendClientMessageEx(playerid, COLOR_WHITE, "Su Dung: /tod [time] (0-23)");

		SetWorldTime(time);
		format(string, sizeof(string), "Thoi gian bay gio la %d:00.", time);
		SendClientMessageToAllEx(COLOR_GRAD1,string);
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "Ban ko du kha nang de thuc hien lenh nay!");
	}
	return 1;
}
// stock SaveHealthVehicle(vehicleid) {
// 	foreach(new i: Player)
// 	{
// 	   	new v = GetPlayerVehicle(i, vehicleid);
// 		if(v != -1) {
// 			new query[129];
// 	        format(query, sizeof(query), "UPDATE `vehicles` SET `pvHealth` = %0.5f WHERE `id` = '%d'", PlayerVehicleInfo[i][v][pvHealth],PlayerVehicleInfo[i][v][pvSlotId]);
// 	        mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "ii", SENDDATA_THREAD, i);
// 	    }
// 	}
// }

// stock strreplace(sSearch[], sReplace[], const sSubject[], &iCount = 0)
// {
// 	new
// 		iLengthTarget = strlen(sSearch),
// 		iLengthReplace = strlen(sReplace),
// 		iLengthSource = strlen(sSubject),
// 		iItterations = (iLengthSource - iLengthTarget) + 1;

// 	new
// 		sTemp[128],
// 		sReturn[_strlib_med_string];

// 	strcat(sReturn, sSubject, _strlib_med_string);
// 	iCount = 0;

// 	for(new iIndex; iIndex < iItterations; ++iIndex)
// 	{
// 		strmid(sTemp, sReturn, iIndex, (iIndex + iLengthTarget), (iLengthTarget + 1));

// 		if(!strcmp(sTemp, sSearch, false))
// 		{
// 			strdel(sReturn, iIndex, (iIndex + iLengthTarget));
// 			strins(sReturn, sReplace, iIndex, iLengthReplace);

// 			iIndex += iLengthTarget;
// 			iCount++;
// 		}
// 	}

// 	return sReturn;
// }
