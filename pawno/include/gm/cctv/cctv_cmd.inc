CMD:cctv(playerid, params[])
{
	new id;

	if (!IsPlayerFactionPolice(playerid))	return SendErrorMessage(playerid, "Ban phai la canh sat.");

	new option[16], secoption[128];

	if (sscanf(params, "s[16]S()[128]", option, secoption))
	{
		SendHelpMessage(playerid, "/cctv [show / exit / list]");
		return 1;
	}

	if (CompareStrings(option, "show"))
	{
		new factionid = PlayerInfo[playerid][pFaction];
		if (!IsPlayerInRangeOfPoint(playerid, 30.0, Factions[factionid][fPosX], Factions[factionid][fPosY], Factions[factionid][fPosZ])) {	
			return SendErrorMessage(playerid, "Tinh nang nay chi co o HQ.");
		}

		if (sscanf(secoption,"d", id))								return SendHelpMessage(playerid, "/cctv show [ID cameras]");
		if (id < 0 || id > MAX_CCTV-1 || !CCTVInfo[id][tvObjectOn])	return SendErrorMessage(playerid, "Camera khong hop le.");
		if (CCTVInfo[id][tvBreak])	{
			Waypoint_Set(playerid, CCTVInfo[id][tvPosX],CCTVInfo[id][tvPosY],CCTVInfo[id][tvPosZ], 3.0);
			return SendErrorMessage(playerid, "Camera bi loi.");
		}

    	if (!pTemp[playerid][pCCTV])
		{
			SavePlayerPos(playerid);
			pTemp[playerid][pCCTV] = 1;
            SetPVarInt(playerid, "CCTV:ID", id + 1);

			if (IsPlayerInAnyVehicle(playerid)) {
				SetPVarInt(playerid, #CCTV_VEH, GetPlayerVehicleID(playerid));
				SetPVarInt(playerid, #CCTV_VEH_SEAT, GetPlayerVehicleSeat(playerid));
				RemovePlayerFromVehicle(playerid);
			}
			
			SetInterior(playerid, CCTVInfo[id][tvInt]);
			SetWorld(playerid, CCTVInfo[id][tvVW]);

			if (MdcInfo[playerid][mdcCreated]) {
				MDC_Hide(playerid);
				SetPVarInt(playerid, #CCTV_MDC_USE, 1);
			}

			for(new i; i < 11;i++) TextDrawShowForPlayer(playerid, zond_cam[i]);

			SetTimerEx("CCTV_PLA_TIMER", 1000, false, "ii", playerid, id);
		}
	}

	else if (CompareStrings(option, "list"))
	{
		new dialog_header[96] = "{FFFFFF}Camera\t{FFFFFF}ID cameras\t{FFFFFF}tinh trang\n", dialog_body[3072];

		format(dialog_body, sizeof(dialog_body), "%s", dialog_header);

		new count;
		for(new i = 0; i < MAX_CCTV; i++)
		{
			if (CCTVInfo[i][tvObjectOn])
			{
                new break_str[24];
				count++;

                if (CCTVInfo[i][tvBreak])    format(break_str, sizeof(break_str), "{CC0000}Khong hoat dong");
                else                        format(break_str, sizeof(break_str), "{00B200}Hoat dong");

				format(dialog_body, sizeof(dialog_body), "%s%s\t%i\t%s\n", dialog_body, CCTVInfo[i][tvName], i, break_str);
			}
		}
		if (!count)	dialog_body = "Khong co may anh nao co san..";
		Dialog_Show(playerid, None, DIALOG_STYLE_TABLIST_HEADERS, "{FFFFFF}Danh sach Camera", dialog_body, "Dong", "");
		return 1;
	}

	else if (CompareStrings(option, "exit"))
	{
		if (!pTemp[playerid][pCCTV]) return SendErrorMessage(playerid, "Ban khong xem camera.");

		TogglePlayerSpectating(playerid, 0);		

		SetInterior(playerid, PlayerInfo[playerid][pInt]);
		SetWorld(playerid, PlayerInfo[playerid][pWorld]);

		for(new i; i < 11; i++) TextDrawHideForPlayer(playerid, zond_cam[i]);

		if (GetPVarInt(playerid, #CCTV_MDC_USE) && !MdcInfo[playerid][mdcCreated]) {
			MDC_Show(playerid, PAGE_CCTV);
			DeletePVar(playerid, #CCTV_MDC_USE);
		}

		if (GetPVarInt(playerid, #CCTV_VEH)) SetTimerEx("CCTV_VEH_TIMER", 1000, false, "i", playerid); 
	}

	else 
	{
		SendHelpMessage(playerid, "/cctv [tuy chon]");
		SendSyntaxMessage(playerid, "hien thi danh sach thoat");
	}
	return 1;
}

this::CCTV_VEH_TIMER(playerid) {
	PutPlayerInVehicle(playerid, GetPVarInt(playerid, #CCTV_VEH), GetPVarInt(playerid, #CCTV_VEH_SEAT));
	DeletePVar(playerid, #CCTV_VEH);
	DeletePVar(playerid, #CCTV_VEH_SEAT);
	return 1;
}

this::CCTV_PLA_TIMER(playerid, id) {
	TogglePlayerSpectating(playerid, 1);
	AttachCameraToDynamicObject(playerid, CCTVInfo[id][tvObject]);
	SendHelpMessage(playerid, "Su dung chuot cua ban de dieu khien may anh, {DABB3E}/cctv exit {FFFFFF}de thoat.");
	return 1;
}//î