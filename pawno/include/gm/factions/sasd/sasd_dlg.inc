Dialog:LSPDElevator(playerid, response, listitem, inputtext[])
{
	if (!response) return 1;
    if (!IsPlayerInRangeOfPoint(playerid, 2.0, 2268.0640,2448.2449,3.5313) && !IsPlayerInRangeOfPoint(playerid, 2.0, 2781.0559,-1056.2823,1028.4969) && !IsPlayerInRangeOfPoint(playerid, 2.0, 2874.6665,-940.6707,1035.9259) && !IsPlayerInRangeOfPoint(playerid, 2.0, 2872.8813,-1072.9934,1037.1782)) return 1;
		
	new world_list[] = {2, 1, 2, 3};

	switch(listitem)
	{
	    case 0: SetPlayerPosEx(playerid, 2268.0640,2448.2449,3.5313), SetPlayerFacingAngle(playerid, 181.2476);
	    case 1: SetPlayerPosEx(playerid, 2780.9036,-1056.2358,1028.4969), SetPlayerFacingAngle(playerid, 87.9492);
	    case 2: SetPlayerPosEx(playerid, 2873.9063,-940.8126,1035.9259), SetPlayerFacingAngle(playerid, 84.3340);
	    case 3: SetPlayerPosEx(playerid, 2872.7168,-1072.2004,1037.1770), SetPlayerFacingAngle(playerid, 0.2384);
	}

	SetWorld(playerid, world_list[listitem]);
	SetInterior(playerid, (listitem == 0)?(0):(1));
	return 1;
}

Dialog:MPCarVoice(playerid, response, listitem, inputtext[])
{
	if (!response) return 1;
	    
    MegaphoneSoundVoice(playerid, listitem + 1);
	return 1;
}

/*Dialog:MainMDC(playerid, response, listitem, inputtext[])
{
	if (!response) return 1;

	switch(listitem)
	{
		case 0:	Dialog_Show(playerid, MDCSearch, DIALOG_STYLE_INPUT, "{8D8DFF}MDC - Поиск по имени", "{B4B5B7}ПОИСК ПО ИМЕНИ\n\nВведите имя:\n\nФорма ввода: Имя_Фамилия (( или ID игрока ))", "Done", "Quay lai");
		case 1:	Dialog_Show(playerid, MDCRecord, DIALOG_STYLE_INPUT, "{8D8DFF}MDC - Предъявление обвинения", "{B4B5B7}ПРЕДЪЯВЛЕНИЕ ОБВИНЕНИЙ\n\nВведите имя:\n\nФорма ввода: Имя_Фамилия (( или ID игрока ))", "Done", "Quay lai");
		case 2:	Dialog_Show(playerid, MDCAddWarn, DIALOG_STYLE_INPUT, "{8D8DFF}MDC - Предупреждение на лицензию", "{B4B5B7}ДОБАВИТЬ ПРЕДУПРЕЖДЕНИЯ НА ЛИЦЕНЗИЮ\n\nВведите имя:\n\n(( Имя_Фамилия / ID игрока ))", "Done", "Quay lai");
		case 3:	Dialog_Show(playerid, MDCVehicle, DIALOG_STYLE_INPUT, "{8D8DFF}MDC - Поиск автомобиля", "{B4B5B7}ПОИСК ИНФОРМАЦИИ ОБ АВТОМОБИЛЕ\n\nВведите номерной знак:\n\n(( Номер ТС ))", "Done", "Quay lai");
		case 4: Get_Calls(playerid);
		case 5:
		{
			new string[MAX_CALLS_AND_ARREST * 32], count;

			for(new i = 0; i != MAX_CALLS_AND_ARREST; i++)
			{
				if (!ArrestInfo[i][arrestExists]) continue;

				format(string, sizeof(string), "%s\n%i. %s", string, count+1, GetNameEx(ArrestInfo[i][arrestSuspect]));
			}

			Dialog_Show(playerid, MDCLastArrest, DIALOG_STYLE_LIST, "{8D8DFF}MDC - Последние аресты", string, "Chon", "Quay lai");
		}
		case 6:
		{
		    new string[1024], count;

		    for(new i = 0; i != MAX_PATROL; i++)
		    {
				if (!PatrolInfo[GetPatrolID(playerid)][i][patrulExists]) continue;

				format(string, sizeof(string), "%s\n{8c8cfe}%s:{FFFFFF}  ", string, PatrolInfo[GetPatrolID(playerid)][i][patrulName]);

				if (IsPlayerLogged(PatrolInfo[GetPatrolID(playerid)][i][patrulOfficer][0]))	format(string, sizeof(string), "%s%s  ", string, GetNameEx(PatrolInfo[GetPatrolID(playerid)][i][patrulOfficer][0]));
                if (IsPlayerLogged(PatrolInfo[GetPatrolID(playerid)][i][patrulOfficer][1]))	format(string, sizeof(string), "%s%s  ", string, GetNameEx(PatrolInfo[GetPatrolID(playerid)][i][patrulOfficer][1]));

				count++;
			}

			if (!count) return SendErrorMessage(playerid, "Активные патрули не найдены.");

			Dialog_Show(playerid, None, DIALOG_STYLE_LIST, "{8D8DFF}MDC - Активные патрули", string, "Close", "");
		}
		case 7: ShowWeaponLicense(playerid, 0);
	}
	return 1;
}

Dialog:MDCLastArrest(playerid, response, listitem, inputtext[])
{
	if (!response) return 1;

	new count;

    for(new i = 0; i != MAX_CALLS_AND_ARREST; i++)
	{
		if (!ArrestInfo[i][arrestExists]) continue;

		if (count == listitem)
		{
            new string[500];

			format(string, sizeof(string), "{B4B5B7}ИНФОРМАЦИЯ ОБ АРЕСТЕ\n\nВремя ареста: %s\nАрестованый: %s\nПроизвел арест: %s\nДата: %s", ConvertSecond(ArrestInfo[i][arrestTime]), ArrestInfo[i][arrestSuspect], ArrestInfo[i][arrestOfficer], ArrestInfo[i][arrestDate]);
			Dialog_Show(playerid, None, DIALOG_STYLE_MSGBOX, "{8D8DFF}MDC - Информация об аресте", string, "-", "");
		    return 1;
		}
		count++;
	}

	SendErrorMessage(playerid, "Ошибка ареста.");
	return 1;
}

Dialog:MDCWeapon(playerid, response, listitem, inputtext[])
{
	if (!response)	return cmd::mdc(playerid, "");
	    
	if (listitem == 0)
	{
	    if (GetPVarInt(playerid, #weapon_list) < 1) 	ShowWeaponLicense(playerid, 0);
		else										ShowWeaponLicense(playerid, GetPVarInt(playerid, #weapon_list)-1);
	    
		return 1;
	}

    else if (listitem == 1)
	{
	    return ShowWeaponLicense(playerid, GetPVarInt(playerid, #weapon_list)+1);
	}
	
	listitem -= 2;

	if (pTemp[playerid][pWeaponListed][listitem] == 0)	return SendErrorMessage(playerid, "Ошибка запроса.");
	    
	new query[128];
	mysql_format(dbHandle, query, sizeof(query), "SELECT * FROM `users` WHERE `id`=%i", pTemp[playerid][pWeaponListed][listitem]);
	mysql_tquery(dbHandle, query, "ShowWeaponLicensePlayer", "i", playerid);

	for(new i; i != 30; i++)
	{
		pTemp[playerid][pWeaponListed][i] = 0;
	}
	return 1;
}*/


Dialog:MDCCall(playerid, response, listitem, inputtext[])
{
	if (!response)						return 1;
    if (!IsPlayerFactionPolice(playerid) &&
		!IsPlayerFactionMedic(playerid) &&
		!IsPlayerFactionFire(playerid))	return 1;

	new mes[512], count, type = (IsPlayerFactionMedic(playerid) || IsPlayerFactionFire(playerid))?(2):(1);

    for(new i = 0; i != MAX_CALLS_AND_ARREST; i++)
	{
	    if (!CallInfo[i][callExists]) continue;
		if (CallInfo[i][callType] != 3) {
			if (CallInfo[i][callType] != type) continue;
		}

		if (listitem == count)
		{
			new statusmes[65];
			if (CallInfo[i][callAccept]) format(statusmes, sizeof(statusmes), "%s", CallInfo[i][callAcceptBy]);
			else format(statusmes, sizeof(statusmes), "{A9C4E4}Cuoc goi khong duoc chap nhan{B4B5B7}");

			format(mes, sizeof(mes), "{B4B5B7}911-THONG TIN CUOC GOI - #%i\n\n\
            						Goi tu:\t\t%s\n\
            						So dien thoai:\t%i\n\
           							Tinh huong:\t\t%s\n\
            						Vi tri:\t%s\n\
            						Thoi gian:\t\t\t%s\n\n\
									Trang thai:\t\t\t%s\n\
            						Cuoc goi da duoc tra loi %i lan", 
			i+1, CallInfo[i][callName], CallInfo[i][callPhone], CallInfo[i][callText], CallInfo[i][callLocation], CallInfo[i][callDate], statusmes, CallInfo[i][callAccept]);
			
			Dialog_Show(playerid, MDCCall2, DIALOG_STYLE_MSGBOX, "{8D8DFF}MDC - Thong tin Cuoc goi", mes, "Tuy chon", "Quay lai");
			SetPVarInt(playerid, #last_call, i);
		    return 1;
		}
		count++;
	}
	return 1;
}

Dialog:MDCCall2(playerid, response, listitem, inputtext[])
{
	if (!response) return 1;

    Dialog_Show(playerid, MDCCallRespond, DIALOG_STYLE_LIST, "{8D8DFF}MDC - Thong tin Cuoc goi", "- Nhan cuoc goi khan cap\n- Xoa cuoc goi", "Chon", "Quay lai");
	return 1;
}

Dialog:MDCCallRespond(playerid, response, listitem, inputtext[])
{
	if (!response) 																													
		return 1;

    if (!IsPlayerFactionPolice(playerid) &&
		!IsPlayerFactionMedic(playerid) &&
		!IsPlayerFactionFire(playerid))
		return 1;

	new type = (IsPlayerFactionMedic(playerid) || IsPlayerFactionFire(playerid))? (2) : (1), 
		id = GetPVarInt(playerid, #last_call);

    if (!CallInfo[id][callExists]) return 1;
	if (CallInfo[id][callType] != 3) {
		if (CallInfo[id][callType] != type) return 1;
	}

	if (!listitem)
	{
		if (pTemp[playerid][pPatrol])	SendFactionMessage(FACTION_POLICE, COLOR_LSPD, "* [%s] %s %s [%s] da chap nhan cuoc goi khan cap 911. #%i.", GetInitials(Factions[PlayerInfo[playerid][pFaction]][fName]), GetRankName(playerid), GetNameEx(playerid), PatrolInfo[GetPatrolID(playerid)][pTemp[playerid][pPatrol]-1][patrulName], id+1);
		else							SendFactionMessage(FACTION_POLICE, COLOR_LSPD, "* [%s] %s %s da chap nhan cuoc goi khan cap 911. #%i.", GetInitials(Factions[PlayerInfo[playerid][pFaction]][fName]), GetRankName(playerid), GetNameEx(playerid), id+1);
		
		if (pTemp[playerid][pPatrol])    format(CallInfo[id][callAcceptBy], 64, "Xu ly boi %s (%s)", GetNameEx(playerid), PatrolInfo[GetPatrolID(playerid)][pTemp[playerid][pPatrol]-1][patrulName]);
        else                             format(CallInfo[id][callAcceptBy], 64, "Xu ly boi %s", GetNameEx(playerid));
		
		Waypoint_Set(playerid, CallInfo[id][callPosX],CallInfo[id][callPosY],CallInfo[id][callPosZ], 3.0);

	    CallInfo[id][callAccept]++;
		pTemp[playerid][pPoliceCalls]++;

		MDC_PAGE(playerid, PAGE_CALLS);
	}
	else
	{
		SendFactionMessage(FACTION_POLICE, COLOR_LSPD, "* [%s] %s %s da xoa bo cuoc goi 911. #%i.", GetInitials(Factions[PlayerInfo[playerid][pFaction]][fName]), GetRankName(playerid), GetNameEx(playerid), id+1);
		
		SendWarningMessage(playerid, "Call [ID: %i] was removed.", id+1);
	    CallInfo[id][callExists] = 0;
 		CallInfo[id][callType] = 0;
		CallInfo[id][callAccept] = 0;

		MDC_PAGE(playerid, PAGE_MAIN);
	}
	
	return 1;
}

/*Dialog:MDCSearch(playerid, response, listitem, inputtext[])
{
	if (!response) return 1;

    new userid;
	if (sscanf(inputtext, "u", userid))	return Dialog_Show(playerid, MDCSearch, DIALOG_STYLE_INPUT, "{8D8DFF}MDC - Поиск по имени", "{B4B5B7}ПОИСК ПО ИМЕНИ\n\nВведите имя:\n\nФорма ввода: Имя_Фамилия (( или ID игрока ))", "Done", "Huy bo");
	if (!IsPlayerLogged(userid))			return Dialog_Show(playerid, MDCSearch, DIALOG_STYLE_INPUT, "{8D8DFF}MDC - Поиск по имени", "{B4B5B7}ПОИСК ПО ИМЕНИ\n\nВведите имя:\n\nФорма ввода: Имя_Фамилия (( или ID игрока ))\n"EMBED_RED"Данный человек отсутствует в базе данных.", "Done", "Huy bo");

	new query[128];
	mysql_format(dbHandle, query, sizeof(query), "SELECT * FROM `criminalrecords` WHERE `userid` = %i", PlayerInfo[userid][pID]);
	mysql_tquery(dbHandle, query, "PersonInfo", "ii", playerid, userid);
	return 1;
}*/

Dialog:MDCRecord(playerid, response, listitem, inputtext[])
{
	if (!response)												return 1;
	if (sscanf(inputtext, "u", pTemp[playerid][pMDCPlayer]))	return SendErrorMessage(playerid, "Nguoi choi nay khong truc tuyen!");
	if (!IsPlayerLogged(pTemp[playerid][pMDCPlayer]))			return SendErrorMessage(playerid, "Ban khong co quyen han!");

	new mes[256];
	format(mes, sizeof(mes), "{B4B5B7}CHARGING\n\nBi cao buoc: %s\n\nNhap van ban buoc toi: (( Mot toi ac / 128 ky tu ))", GetNameEx(pTemp[playerid][pMDCPlayer]));
	Dialog_Show(playerid, MDCRecord2, DIALOG_STYLE_INPUT, "{8D8DFF}MDC - Cao buoc", mes, "Nhap", "Huy bo");
	return 1;
}

Dialog:MDCRecord2(playerid, response, listitem, inputtext[])
{
	if (!response)										return 1;
    if (!IsPlayerLogged(pTemp[playerid][pMDCPlayer]))	return 1;

	if (strlen(inputtext) < 1 || strlen(inputtext) > 127)
	{
	    new mes[256];
		format(mes, sizeof(mes), "{B4B5B7}CHARGING\n\nBi cao buoc: %s\n\nNhap van ban buoc toi: (( Mot toi ac / 128 ky tu ))", GetNameEx(pTemp[playerid][pMDCPlayer]));
		Dialog_Show(playerid, MDCRecord2, DIALOG_STYLE_INPUT, "{8D8DFF}MDC - Cao buoc", mes, "Nhap", "Huy bo");
		return 1;
	}

    AddCriminalRecord(pTemp[playerid][pMDCPlayer], inputtext, PlayerInfo[playerid][pUsername], PlayerInfo[playerid][pFaction]);
    SendFactionMessage(FACTION_POLICE, COLOR_POLICECHAT, "[WANTED] Bi cao buoc: %s, Cong to vien: %s, Toi ac: %s.", GetNameEx(pTemp[playerid][pMDCPlayer]), GetNameEx(playerid), inputtext);
	SendWarningMessage(playerid, "Bi can da duoc dua vao danh sach truy na thanh cong.");
	pTemp[playerid][pMDCPlayer] = INVALID_PLAYER_ID;
	return 1;
}

Dialog:MDCAddWarn(playerid, response, listitem, inputtext[])
{
	if (!response) return 1;

	new userid;

    //if (sscanf(inputtext, "u", userid))	return Dialog_Show(playerid, MDCAddWarn, DIALOG_STYLE_INPUT, "{8D8DFF}MDC - Предупреждение на лицензию", "{B4B5B7}ДОБАВИТЬ ПРЕДУПРЕЖДЕНИЯ НА ЛИЦЕНЗИЮ\n\nВведите имя:\n\n(( Имя_Фамилия / ID игрока ))\n"EMBED_RED"Данный человек отсутствует в базе данных.", "Done", "Huy bo");
	//if (!IsPlayerLogged(userid))			return Dialog_Show(playerid, MDCAddWarn, DIALOG_STYLE_INPUT, "{8D8DFF}MDC - Предупреждение на лицензию", "{B4B5B7}ДОБАВИТЬ ПРЕДУПРЕЖДЕНИЯ НА ЛИЦЕНЗИЮ\n\nВведите имя:\n\n(( Имя_Фамилия / ID игрока ))\n"EMBED_RED"Данный человек отсутствует в базе данных.", "Done", "Huy bo");
    //if (!PlayerInfo[userid][pCarLic])	return Dialog_Show(playerid, MDCAddWarn, DIALOG_STYLE_INPUT, "{8D8DFF}MDC - Предупреждение на лицензию", "{B4B5B7}ДОБАВИТЬ ПРЕДУПРЕЖДЕНИЯ НА ЛИЦЕНЗИЮ\n\nВведите имя:\n\n(( Имя_Фамилия / ID игрока ))\n"EMBED_RED"У данного человека отсутствует лицензия на вождение.", "Done", "Huy bo");

	new mes[128];
	format(mes, sizeof(mes), "canh bao tren giay phep lai xe %s.", GetNameEx(userid));
	cmd::me(playerid, mes);

	SendSyntaxMessage(playerid, "Ban da them mot canh bao doi voi giay phep lai xe cua %s.", GetName(userid));

	PlayerInfo[userid][pDriveWarns]++;
	SQL_SetInteger("users", "drivewarns", PlayerInfo[userid][pDriveWarns], PlayerInfo[userid][pID]);

	if (PlayerInfo[userid][pDriveWarns] >= 3)
	{
		SendSyntaxMessage(playerid, "Vi da co 3 canh bao doi voi giay phep lai xe cua %s's, nen no da tu dong bi thu hoi.", GetNameEx(userid));
		PlayerInfo[userid][pDriveWarns] = 0;
		PlayerInfo[userid][pCarLic] = 0;

		SQL_SetInteger("users", "drivewarns", PlayerInfo[userid][pDriveWarns], PlayerInfo[userid][pID]);
		SQL_SetInteger("users", "carlic", PlayerInfo[userid][pCarLic], PlayerInfo[userid][pID]);
	}
	return 1;
}

/*Dialog:MDCVehicle(playerid, response, listitem, inputtext[])
{
	if (!response)										return 1;
	if (!strlen(inputtext) || strlen(inputtext) > 23)	return Dialog_Show(playerid, MDCVehicle, DIALOG_STYLE_INPUT, "{8D8DFF}MDC - Поиск автомобиля", "{B4B5B7}ПОИСК ИНФОРМАЦИИ ОБ АВТОМОБИЛЕ\n\nВведите номерной знак:\n\n(( Номер ТС ))", "Done", "Quay lai");
	    
	new query[156];
	mysql_format(dbHandle, query, sizeof(query), "SELECT *, (SELECT `name` FROM `users` WHERE id =cars.owner) as ownername FROM `cars` WHERE `plate` = '%e' AND `registered`=1", inputtext);
	mysql_tquery(dbHandle, query, "OnCheckNumber", "d", playerid);
	return 1;
}*/

Dialog:MDCWeaponPlayer(playerid, response, listitem, inputtext[])
{
	if (!response)	return ShowWeaponLicense(playerid, GetPVarInt(playerid, #weapon_list));
	    
	if (listitem == 5)
	{
	    if (IsPlayerFactionPolice(playerid))	 return SendErrorMessage(playerid, "Chi cac LSPD co lien quan den viec huy bo, vui long gui yeu cau.");
		if (PlayerInfo[playerid][pAuthwep] != 1) return SendErrorMessage(playerid, "Ban khong co quyen thu hoi giay phep vu khi.");
		    
		new userid;

	    if ((userid = GetIDByID(pTemp[playerid][pMDCWepPlayer])) != INVALID_PLAYER_ID)
		{
		    SendSyntaxMessage(userid, "%s %s da thu hoi giay phep vu khi cua ban.", GetRankName(playerid), GetNameEx(playerid));
			PlayerInfo[userid][pWepLic] = 0;
			PlayerInfo[userid][pWepWarns] = 0;
			PlayerInfo[userid][pWepCount] = 0;
		}
	    new query[156];
		mysql_format(dbHandle, query, sizeof(query), "UPDATE `users` SET `weplic`='0',`wepwarns`='0',`wep_officer`='-',`wep_data`='-',`wep_price`='0',`wep_count`='0' WHERE `id` = %i", pTemp[playerid][pMDCWepPlayer]);
		mysql_tquery(dbHandle, query);
		
		SendSyntaxMessage(playerid, "Ban da thu hoi giay phep vu khi cua %s.", pTemp[playerid][pMDCWepName]);
	    return 1;
	}

	else if (listitem == 6)
	{
		new userid;
	    if ((userid = GetIDByID(pTemp[playerid][pMDCWepPlayer])) != INVALID_PLAYER_ID)
	    {
	        SendSyntaxMessage(userid, "%s %s da viet mot canh bao doi voi giay phep vu khi cua ban.", GetRankName(playerid), GetNameEx(playerid));
			PlayerInfo[userid][pWepWarns]++;
		}
		
	    new query[128];
		mysql_format(dbHandle, query, sizeof(query), "UPDATE `users` SET `wepwarns`= `wepwarns` + 1 WHERE `id` = %i", pTemp[playerid][pMDCWepPlayer]);
		mysql_tquery(dbHandle, query);

		SendSyntaxMessage(playerid, "Ban da viet mot canh bao doi voi giay phep vu khi cua %s.", pTemp[playerid][pMDCWepName]);
	    return 1;
	}
	
	ShowWeaponLicense(playerid, GetPVarInt(playerid, #weapon_list));
	return 1;
}

Dialog:ShowTrace(playerid, response, listitem, inputtext[])
{
	if (pTemp[playerid][pTraceStage] < 7)
	{
		Dialog_Show(playerid, None, DIALOG_STYLE_MSGBOX, "He thong theo doi - Nhan ESC / ENTER de thoat", "{B4B5B7}Ban da dang xuat khoi he thong theo doi.", "Chap nhan", "");
		
		if (pTemp[playerid][pTraceGZ] != -1)	GangZoneDestroy(pTemp[playerid][pTraceGZ]);
 		
		pTemp[playerid][pTraceGZ] = -1;
		pTemp[playerid][pTracePlayer] = INVALID_PLAYER_ID;
 		pTemp[playerid][pTraceStage] = 0;
	}
	return 1;
}

Dialog:LSPDGUN(playerid, response, listitem, inputtext[])
{
	if (!response)															return cmd::duty(playerid, "");
    if (!IsPlayerFactionPolice(playerid))									return 1;
	if (!PlayerInfo[playerid][pOnDuty])										return SendErrorMessage(playerid, "Truoc tien ban can trong gio lam viec.");
	if (!IsPlayerAtUniform(playerid) && !IsPlayerAtSecondUniform(playerid))	return SendErrorMessage(playerid, "Ban khong o trong phong thay do / phuong tien to chuc.");
	
	GameTextForPlayer(playerid, "~r~-", 1500, 4);

	switch(listitem)
	{
		case 0: if (!GivePlayerWeaponEx(playerid, 3, 1, GetDefaultAmmoType(3), PlayerInfo[playerid][pPlayerSerial])) 	return SendErrorMessage(playerid, "Tui do da day!");
		case 1: if (!GivePlayerWeaponEx(playerid, 41, 999, GetDefaultAmmoType(41), PlayerInfo[playerid][pPlayerSerial])) return SendErrorMessage(playerid, "Tui do da day!");
		case 2: if (!GivePlayerWeaponEx(playerid, 24, 85, GetDefaultAmmoType(24), PlayerInfo[playerid][pPlayerSerial])) 	return SendErrorMessage(playerid, "Tui do da day!");
		case 3: if (GiveInvItem(playerid, 85, CheckAmmo(85)) == -1) return SendErrorMessage(playerid, "Tui do da day!");// desert eagle patrons 85
		case 4: if (!GivePlayerWeaponEx(playerid, 29, 91, GetDefaultAmmoType(29), PlayerInfo[playerid][pPlayerSerial])) 	return SendErrorMessage(playerid, "Tui do da day!");
		case 5: if (GiveInvItem(playerid, 91, CheckAmmo(91)) == -1) return SendErrorMessage(playerid, "Tui do da day!");// MP5 patrons 91
		case 6: if (!GivePlayerWeaponEx(playerid, 25, 89, GetDefaultAmmoType(25), PlayerInfo[playerid][pPlayerSerial])) 	return SendErrorMessage(playerid, "Tui do da day!");
		case 7: if (GiveInvItem(playerid, 86, CheckAmmo(86)) == -1) return SendErrorMessage(playerid, "Tui do da day!");// Shotgun patrons 86
		case 8: if (GiveInvItem(playerid, 89, CheckAmmo(89)) == -1) return SendErrorMessage(playerid, "Tui do da day!");// Shotgun neletalnoe patrons 89
		case 9: if (!GivePlayerWeaponEx(playerid, 31, 98, GetDefaultAmmoType(31), PlayerInfo[playerid][pPlayerSerial])) 	return SendErrorMessage(playerid, "Tui do da day!");
		case 10: if (GiveInvItem(playerid, 98, CheckAmmo(98)) == -1) return SendErrorMessage(playerid, "Tui do da day!");// M4 patrons 98
		case 11: if (GiveInvItem(playerid, 99, CheckAmmo(99)) == -1) return SendErrorMessage(playerid, "Tui do da day!");// M4 neletalnoe patrons 99
		case 12: if (!GivePlayerWeaponEx(playerid, 34, 96, GetDefaultAmmoType(34), PlayerInfo[playerid][pPlayerSerial])) return SendErrorMessage(playerid, "Tui do da day!");
		case 13: if (GiveInvItem(playerid, 96, CheckAmmo(96)) == -1) return SendErrorMessage(playerid, "Tui do da day!");// Sniper Rifle patrons 96
		case 14: if (!GivePlayerWeaponEx(playerid, 17, 1, GetDefaultAmmoType(17), PlayerInfo[playerid][pPlayerSerial])) 	return SendErrorMessage(playerid, "Tui do da day!");
		case 15: if (!GivePlayerWeaponEx(playerid, 43, 50, GetDefaultAmmoType(43), PlayerInfo[playerid][pPlayerSerial])) return SendErrorMessage(playerid, "Tui do da day!");
		case 16: ResetPlayerWeaponsEx(playerid);
	}

	GameTextForPlayer(playerid, "~g~+", 1500, 4);

	Dialog_Show(playerid, LSPDGUN, DIALOG_STYLE_LIST, "Vu khi", "{FFFFFF}• Cudgel\n• Pepper spray\n• Desert Eagle ( .50AE .ext )\n\t{ffc46a}- Take extra magazines ( .50AE .ext )\n{FFFFFF}• MP5 ( 9x19mm .ext )\n\t{ffc46a}- Take extra magazines ( 9x19mm .ext )\n{FFFFFF}• Shotgun ( 12-G BIRDSHOT )\n\t{ffc46a}- Take extra magazines ( 12-G BIRDSHOT )\n\t{ffc46a}- Take non-lethal ammo ( 12-G BEANBAG )\n{FFFFFF}• М4 ( 5.56x45mm (drum) )\n\t{ffc46a}- Take extra magazines ( 5.56x45mm (drum) )\n\t{ffc46a}- Take non-lethal ammo ( 5.56x45mm (rubber) )\n{FFFFFF}• Sniper Rifle (7.62x51mm)\n\t{ffc46a}- Take extra magazines ( 7.62x51mm )\n{FFFFFF}• Gas grenade\n• Camera\n{FF6347}• Surrender all weapons", "Chon", "Close");
	return 1;
}

Dialog:LSPDArmoury(playerid, response, listitem, inputtext[])
{
	if (!response)															return cmd::duty(playerid, "");
    if (!IsPlayerAtUniform(playerid) && !IsPlayerAtSecondUniform(playerid))	return SendErrorMessage(playerid, "Ban khong o trong phong thay do / phuong tien to chuc.");
	
	switch(listitem) {
		case 0: {
			GameTextForPlayer(playerid, "~r~-", 1500, 4);
			if (GiveInvItem(playerid, INV_RADIO, 1) == -1) return SendErrorMessage(playerid, "Tui do da day!"); // рация
			GameTextForPlayer(playerid, "~g~+", 1500, 4);
		} 
		case 1: {
			return Dialog_Show(playerid, LSPDGUN, DIALOG_STYLE_LIST, "Vu khi", "{FFFFFF}• Cudgel\n• Pepper spray\n• Desert Eagle ( .50AE .ext )\n\t{ffc46a}- Take extra magazines ( .50AE .ext )\n{FFFFFF}• MP5 ( 9x19mm .ext )\n\t{ffc46a}- Take extra magazines ( 9x19mm .ext )\n{FFFFFF}• Shotgun ( 12-G BIRDSHOT )\n\t{ffc46a}- Take extra magazines ( 12-G BIRDSHOT )\n\t{ffc46a}- Take non-lethal ammo ( 12-G BEANBAG )\n{FFFFFF}• М4 ( 5.56x45mm (drum) )\n\t{ffc46a}- Take extra magazines ( 5.56x45mm (drum) )\n\t{ffc46a}- Take non-lethal ammo ( 5.56x45mm (rubber) )\n{FFFFFF}• Sniper Rifle (7.62x51mm)\n\t{ffc46a}- Take extra magazines ( 7.62x51mm )\n{FFFFFF}• Gas grenade\n• Camera\n{FF6347}• Surrender all weapons", "Chon", "Close");
		}
		case 2: {
			if (!PlayerInfo[playerid][pSwat]&& !isLeader(playerid)) return SendErrorMessage(playerid, "Bo S.W.A.T khong co san cho ban");

			if (!PlayerInfo[playerid][pSwatDuty])
			{
				PlayerInfo[playerid][pSwatDuty] = 1;
				SetPlayerArmour(playerid, 150);
				PlayerInfo[playerid][pChar] = (!IsPlayerFactionPolice(playerid))?(287):(285);
				SetPlayerSkin(playerid, PlayerInfo[playerid][pChar]);
				SetPlayerColor(playerid, RemoveAlpha(Factions[PlayerInfo[playerid][pFaction]][fColor]));
				SendFactionMessage(FACTION_POLICE, COLOR_POLICECHAT, "** HQ: %s %s da dang nhap vao doi S.W.A.T **",GetRankName(playerid), GetNameEx(playerid));
				return 1;
			}
			
			PlayerInfo[playerid][pSwatDuty] = 0;
			SetPlayerArmour(playerid, 100);
			PlayerInfo[playerid][pChar] = 0;
			SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
			SendFactionMessage(FACTION_POLICE, COLOR_POLICECHAT, "** HQ: %s %s da dang xuat khoi doi S.W.A.T **",GetRankName(playerid), GetNameEx(playerid));
		}
	}

	return 1;
}