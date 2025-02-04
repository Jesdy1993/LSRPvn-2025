ALTX:channel("/ch");
CMD:channel(playerid, params[])
{
	new option[16], secoption[128];

	if (sscanf(params, "s[16]S()[128]", option, secoption))
	{
		SendSyntaxMessage(playerid, "/(ch)annel [set / leave / rent / sell]");
		return 1;
	}

	if (CompareStrings(option, "set"))
	{
		if (!IsPlayerHasItem(playerid, INV_RADIO))	return SendErrorMessage(playerid, "Ban khong co bo dam.");
		
		new channelid;

		if (sscanf(secoption, "i", channelid))						return SendHelpMessage(playerid, "(/ch)annel set [channel]");
		if (!ChannelExists(channelid))								return SendErrorMessage(playerid, "Kenh khong duoc tim thay.");
		if (channelid == 911 && !IsPlayerFactionPolice(playerid))	return SendErrorMessage(playerid,"Kenh radio da duoc bao luu");
		if (channelid == 912 && !IsPlayerFactionMedic(playerid))	return SendErrorMessage(playerid, "Kenh radio da duoc bao luu");
		if (channelid == 998 && !IsPlayerFactionFire(playerid))		return SendErrorMessage(playerid, "Kenh radio da duoc bao luu");
		if (channelid == GetPlayerChannel(playerid))				return SendErrorMessage(playerid, "Ban da duoc ket noi voi kenh nay.");
		
		if (channelid == 911 && IsPlayerFactionPolice(playerid))
		{
			SendRadioMsg(playerid, "Thay doi kenh [CH: %i].", channelid);
			PlayerInfo[playerid][pAuthed] = 1;
			SetRadioChannel(playerid, channelid);
			return 1;
		}

		else if (channelid == 912 && IsPlayerFactionMedic(playerid))
		{
			SendRadioMsg(playerid, "Thay doi kenh [CH: %i].", channelid);
			PlayerInfo[playerid][pAuthed] = 1;
			SetRadioChannel(playerid, channelid);
			return 1;
		}

		else if (channelid == 998 && IsPlayerFactionFire(playerid))
		{
			SendRadioMsg(playerid, "Thay doi kenh [CH: %i].", channelid);
			PlayerInfo[playerid][pAuthed] = 1;
			SetRadioChannel(playerid, channelid);
			return 1;
		}

		PlayerInfo[playerid][pAuthed] = 0;
		SetRadioChannel(playerid, channelid);
		SendRadioMsg(playerid, "Thay doi kenh [CH: %i].", channelid);
		SendHelpMessage(playerid, "Su dung /auth de dang nhap.");
		return 1;
	}

	else if (CompareStrings(option, "leave"))
	{
		if (!IsPlayerHasItem(playerid, INV_RADIO))	return SendErrorMessage(playerid, "Ban khong co bo dam.");
		if (!GetPlayerChannel(playerid))				return SendErrorMessage(playerid, "Ban chua ket noi voi bat ky kenh nao.");

		SendRadioMsg(playerid, "Ban da roi khoi kenh [CH: %i].", GetPlayerChannel(playerid));
		SetRadioChannel(playerid, 0);
		PlaySound(playerid, 6400);
		return 1;
	}

	else if (CompareStrings(option, "rent"))
	{
		if (!IsPlayerInRangeOfPoint(playerid, 2.0, 2269.65, -74.306, 26.772))
		{
			Waypoint_Set(playerid, 2269.65, -74.306, 26.772);
			SendWarningMessage(playerid, "Ban nen o gan thu vien thanh pho.");
			return 1;
		}

		new channel, pass[33];

		if (sscanf(secoption, "iS()[33]", channel, pass))	return SendHelpMessage(playerid, "(/ch)annel rent [kenh (1-9999)] [mat khau | de trong neu ban khong muon dat mat khau]");
		if (strlen(pass) > 30)								return SendErrorMessage(playerid, "Mat khau chi co the 30 ky tu.");
		if (channel >= MAX_RADIOS || channel < 1)			return SendErrorMessage(playerid, "Kenh 1 den %i.", MAX_RADIOS - 1);
		if (PlayerInfo[playerid][pOwnedChannel])			return SendErrorMessage(playerid, "Ban da co mot kenh, truoc tien hay ban no.");
		if (ChannelExists(channel))							return SendErrorMessage(playerid, "Kenh radio da duoc bao luu ");
		if (StringHasSymbols(pass))							return SendErrorMessage(playerid, "Mat khau chi co the chua cac chu cai va so. ");
		
		new cost = 1500;

		if (GetCash(playerid) < cost)						return SendNotCash(playerid);

		new id = -1;

		for(new i = 0; i < MAX_RADIOS; i++)
		{
			if (RadiosInfo[i][radioOn]) continue;

			id = i;
			break;
		}

		if (id == -1)	return SendErrorMessage(playerid, "Tat ca cac tan so deu ban, quay lai sau.");

		GiveCash(playerid, -cost);
		SendRadioMsg(playerid, "Ban da thue mot kenh [CH: %i] voi gia $%i.", channel, cost);
		SendHelpMessage(playerid, "Su dung /radiohelp de xem tro giup.");
		RadiosInfo[id][radioChannel] = channel;
		RadiosInfo[id][radioOwner] = PlayerInfo[playerid][pID];
		format(RadiosInfo[id][radioPass], 32, "%s", pass);
		AddChannelToFile(playerid, channel, pass, id);
		return 1;
	}

	else if (CompareStrings(option, "sell"))
	{
		if (!PlayerInfo[playerid][pOwnedChannel])	return SendErrorMessage(playerid, "Ban khong thue mot kenh nao.");
		
		new id = -1;

		if ((id = GetChannelID(PlayerInfo[playerid][pOwnedChannel])) == -1)
		{
			PlayerInfo[playerid][pOwnedChannel] = 0;
			SendWarningMessage(playerid, "Kenh khong duoc tim thay.");
			return 1;
		}

		new award = 750;

		GiveCash(playerid, award);
		SendRadioMsg(playerid, "Ban da ban mot kenh [CH: %i] voi gia $%i.", RadiosInfo[id][radioChannel], award);

		foreach(new i : Player)
		{
			if (!IsPlayerLogged(i) || GetPlayerChannel(i) != RadiosInfo[id][radioChannel] || i == playerid) continue;

			SendRadioMsg(i, "Kenh ban ket noi da duoc ban.");
			SetRadioChannel(i, 0);
		}

		new query[128];
		mysql_format(dbHandle, query, sizeof(query), "UPDATE `users` SET `channel` = 0, `authed` = 0 WHERE `channel` = %i", RadiosInfo[id][radioChannel]);
		mysql_tquery(dbHandle, query);
		mysql_format(dbHandle, query, sizeof(query), "DELETE FROM `radios` WHERE `id` = %i", RadiosInfo[id][radioID]);
		mysql_tquery(dbHandle, query);

		RadiosInfo[id][radioOn] = 
		RadiosInfo[id][radioID] = 
		RadiosInfo[id][radioChannel] = 
		RadiosInfo[id][radioOwner] = 0;
		SetRadioChannel(playerid, 0);
		PlayerInfo[playerid][pOwnedChannel] = 0;
		return 1;
	}

	else 
	{
		SendHelpMessage(playerid, "/(ch)annel [set / leave / rent / sell]");
	}
	return 1;
}

CMD:setslot(playerid, params[])
{
    if (!IsPlayerHasItem(playerid, INV_RADIO))	return SendErrorMessage(playerid, "Ban khong co bo dam.");

	new slot;

	if (sscanf(params,"d",slot))			return SendHelpMessage(playerid, "/setslot [vi tri (0-100)]");
	if (slot < 0 || slot > 100)			return SendErrorMessage(playerid, "Vi tri tu 0 den 100. ");
	if (slot == GetPlayerSlot(playerid))	return SendErrorMessage(playerid, "Ban da su dung vi tri nay. ");

	SetRadioSlot(playerid, slot);
	SendRadioMsg(playerid, "Tan suat thay the [VI TRI: %i]", slot);
	return 1;
}

CMD:auth(playerid, params[])
{
    if (!IsPlayerHasItem(playerid, INV_RADIO))	return SendErrorMessage(playerid, "Ban khong co bo dam.");
	if (!GetPlayerChannel(playerid))					return SendErrorMessage(playerid, "Radio cua ban dang tat.");
	if (PlayerInfo[playerid][pAuthed])				return SendErrorRadioMessage(playerid, "Ban da dang nhap vao kenh nay. ");

	new id = -1;

	if ((id = ChannelExists(GetPlayerChannel(playerid))) == 0)	return SendErrorMessage(playerid, "Kenh khong duoc tim thay.");

	if (CompareStrings(RadiosInfo[id][radioPass], ""))
	{
	    SendRadioMsg(playerid, "Ban da dang nhap vao kenh %i.", GetPlayerChannel(playerid));
		PlayerInfo[playerid][pAuthed] = 1;
		PlaySound(playerid, 6400);
	    return 1;
	}

	if (isnull(params))										return SendHelpMessage(playerid, "/auth [mat khau kenh]");
	if (CompareStrings(RadiosInfo[id][radioPass], params))	return SendErrorRadioMessage(playerid, "Ban da nhap sai mat khau.");

	SendRadioMsg(playerid, "Ban da dang nhap vao kenh [CH: %i].", GetPlayerChannel(playerid));
	PlayerInfo[playerid][pAuthed] = 1;
	PlaySound(playerid, 6400);
	return 1;
}

CMD:newauth(playerid, params[])
{
	if (!PlayerInfo[playerid][pOwnedChannel])	return SendErrorMessage(playerid, "Ban khong co thue mot kenh nao.");

    new id = -1;

	if ((id = GetChannelID(PlayerInfo[playerid][pOwnedChannel])) == -1)				return SendErrorMessage(playerid, "Kenh khong duoc tim thay."); 
	if (isnull(params))																return SendHelpMessage(playerid, "/newauth [mat khau moi | neu ban muon xoa mat khau, sau do khong nhap bat cu dieu gi]");
	if (strlen(params) < 1 || strlen(params) > 32)									return SendErrorMessage(playerid, "Ky tu chi tu 1 den 32.");
	if (CompareStrings(RadiosInfo[id][radioPass], "") && CompareStrings(params, ""))	return SendErrorMessage(playerid, "Kenh cua ban khong co mat khau.");
	if (!CompareStrings(params, "") && StringHasSymbols(params))						return SendErrorMessage(playerid, "Chi cac chu cai va so co the duoc su dung trong mat khau.");

	if (CompareStrings(params, ""))	SendRadioMsg(playerid, "Kenh cua ban hien khong co mat khau. ");
	else							SendRadioMsg(playerid, "Ban da thay doi mat khau kenh cua minh thanh %s.", params);

	format(RadiosInfo[id][radioPass], 33, "%s", params);
	SQL_SetString("radios", "pass", RadiosInfo[id][radioPass], RadiosInfo[id][radioID]);
	return 1;
}

CMD:radiomembers(playerid, params[])
{
    if (!PlayerInfo[playerid][pOwnedChannel])	return SendErrorMessage(playerid, "Ban khong co thue mot kenh nao.");

    new id = -1;

	if ((id = GetChannelID(PlayerInfo[playerid][pOwnedChannel])) == -1)	return SendErrorMessage(playerid, "Kenh khong duoc tim thay.");

	new dialog_header[64] = "{FFFFFF}Ten\t{FFFFFF}ID\n", dialog_body[2048];

	format(dialog_body, sizeof(dialog_body), "%s", dialog_header);

	foreach(new i : Player)
	{
	    if (!IsPlayerLogged(i) || GetPlayerChannel(i) != RadiosInfo[id][radioChannel]) continue;

	    format(dialog_body, sizeof(dialog_body), "%s%s\t%i\n", GetNameEx(i), i);
	}
	
	Dialog_Show(playerid, None, DIALOG_STYLE_TABLIST_HEADERS, "{FFFFFF}Danh sach thanh vien trong kenh", dialog_body, "Dong", "");
	return 1;
}

CMD:kickoffradio(playerid, params[])
{
    if (!PlayerInfo[playerid][pOwnedChannel])	return SendErrorMessage(playerid, "Ban khong co thue mot kenh nao.");

	new userid;

	if (sscanf(params,"u", userid))	return SendHelpMessage(playerid, "/kickoffradio [ID/Ten]");
	if (!IsPlayerLogged(userid))		return SendNotConnected(playerid);
	if (userid == playerid)			return SendErrorMessage(playerid, "Ban khong the truc xuat chinh minh ra khoi kenhl.");

    new id = -1;

	if ((id = GetChannelID(PlayerInfo[playerid][pOwnedChannel])) == -1)	return SendErrorMessage(playerid, "Kenh khong duoc tim thay.");
	if (RadiosInfo[id][radioChannel] != GetPlayerChannel(playerid))		return SendErrorMessage(playerid, "Ban phai o trong kenh cua ban [CH: %i].", RadiosInfo[id][radioChannel]);
	if (GetPlayerChannel(userid) != GetPlayerChannel(playerid))			return SendErrorMessage(playerid, "Nguoi choi nay khong co trong kenh ");

	SendRadioMsg(playerid, "Ban da truc xuat %s.", GetNameEx(id));
	SendRadioMsg(userid, "Ban da bi truc xuat ra khoi kenh. ");
	SetRadioChannel(userid, 0);
	return 1;
}

ALTX:r("/radio");
CMD:r(playerid, params[])
{
    if (PlayerInfo[playerid][pMutedTime] > 0)		return SendErrorMessage(playerid,"Tro chuyen cuc bo cua ban bi he thong chan.");

    new channel = GetPlayerChannel(playerid);

	if (!IsPlayerHasItem(playerid, INV_RADIO))	return SendErrorMessage(playerid, "Ban khong co bo dam.");
	if (channel == 0)							return SendErrorMessage(playerid, "Ban khong co tan suat.");
	if (!PlayerInfo[playerid][pAuthed])			return SendErrorMessage(playerid, "Ban chua dang nhap vao tan suat.");

	if (channel == 911) {
		new tag[6], arg[25];
		if (!sscanf(params, "s[6]s[24]", tag, arg)) { 
			if (CompareStrings(tag, "10-27")) {
				new userid;
				if (sscanf(arg, "u", userid)) return SendErrorMessage(playerid, "/r 10-27 [ID/Ten]");
				if (!IsPlayerLogged(userid))	 return SendClientMessageEx(playerid, COLOR_POLICECHAT, "* HQ: Khong co ket qua nao duoc tim thay..");

				SendClientMessageEx(playerid, COLOR_POLICECHAT, "* HQ: %s, gioi tinh: %s, tuoi: %i, tien phat chua thanh toan: %s, tim kiem: %s.", GetNameEx(userid), (PlayerInfo[userid][pSex]==1)?("male"):("female"), PlayerInfo[userid][pAge], (CountPlayerTickets(userid))?("{FF6347}%i{9189EF}"):("No"), (IsPlayerWanted(userid))?("Yes"):("No"));
				SendLocalMessage(5.0, playerid, COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5, "(Radio) %s noi: Dieu phoi vien, 10-27 %s.", GetNameWithMask(playerid), GetNameEx(userid));
				return 1;
			} else if (CompareStrings(tag, "10-28")) {
				new plates[10], vehicle;
				if (sscanf(arg, "s[10]", plates))				 return SendErrorMessage(playerid, "/r 10-28 [plates]");
				if ((vehicle = FindVehicleByPlate(plates)) == -1) return SendClientMessageEx(playerid, COLOR_POLICECHAT, "* HQ: Khong co ket qua nao duoc tim thay..");
				
				PlayCrimeReportForPlayer(playerid, playerid, 13);
				
				SendClientMessageEx(playerid, COLOR_POLICECHAT, "* HQ: %s [%s], chu so huu: %s, tien phat chua thanh toan: %s, tim kiem: %s.", VehicleNames[GetVehicleModel(vehicle)-400], VehicleInfo[vehicle][carPlate], VehicleInfo[vehicle][carOwner], (CountVehicleTickets(vehicle))?("%i"):("No"), (VehicleInfo[vehicle][carWanted])?("Yes"):("No"));
				SendLocalMessage(5.0, playerid, COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5, "(Radio) %s noi: Dieu phoi vien, 10-28 %s.", GetNameWithMask(playerid), VehicleInfo[vehicle][carPlate]);
				return 1;
			}
		}
	}
	
	if (sscanf(params, "s[144]", params)) 		return SendHelpMessage(playerid, "/r [van ban]");

	new mes[128];

	if (strlen(params) > MAXLEN)
	{
		new pos = MAXLEN;

		if (pos < MAXLEN-1) pos = MAXLEN;
		
		if (pTemp[playerid][pPatrol] && channel == 911) {
			format(mes, sizeof(mes), "**[CH: %i, S: 0] [%s] %s: %.*s ...", channel, PatrolInfo[GetPatrolID(playerid)][pTemp[playerid][pPatrol]-1][patrulName], GetNameEx(playerid), pos, params);
		} else {
			format(mes, sizeof(mes), "**[CH: %i, S: 0] %s: %.*s ...", channel, GetNameEx(playerid), pos, params);
		}

		SendRadioMessage(channel, COLOR_RADIO, mes);
		format(mes, sizeof(mes), "... %s", params[pos]);
		SendRadioMessage(channel, COLOR_RADIO, mes);
		SendLocalMessage(5.0, playerid, COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5, "(Radio) %s noi: %.*s ...", GetNameWithMask(playerid), pos, params);
		SendLocalMessage(5.0, playerid, COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5, "... %s", params[pos]);
	}
	else
	{
	    if (pTemp[playerid][pPatrol] && channel == 911) {
			format(mes, sizeof(mes), "**[CH: %i, S: 0] [%s] %s: %s", channel, PatrolInfo[GetPatrolID(playerid)][pTemp[playerid][pPatrol]-1][patrulName], GetNameEx(playerid), params);
		} else {
			format(mes, sizeof(mes), "**[CH: %i, S: 0] %s: %s", channel, GetNameEx(playerid), params);
		}
			
		SendRadioMessage(channel, COLOR_RADIO, mes);
		SendLocalMessage(5.0, playerid, COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5, "(Radio) %s noi: %s", GetNameWithMask(playerid), params);
	}
	return 1;
}

CMD:rr(playerid, params[])
{
	if (isnull(params))							return SendHelpMessage(playerid, "/rr [van ban]");
    if (PlayerInfo[playerid][pMutedTime] > 0)	return SendErrorMessage(playerid, "Tro chuyen cuc bo cua ban bi he thong chan.");

    new channel = GetPlayerChannel(playerid),
		slot = GetPlayerSlot(playerid);

	if (!IsPlayerHasItem(playerid, INV_RADIO))	return SendErrorMessage(playerid, "Ban khong co bo dam.");
	if (channel == 0)							return SendErrorRadioMessage(playerid, "Ban khong co tan suat.");
	if (PlayerInfo[playerid][pAuthed] == 0)		return SendErrorRadioMessage(playerid, "Ban chua dang nhap vao tan suat.");

	new mes[128];
	if (strlen(params) > MAXLEN)
	{
		new pos = MAXLEN;
		if (pos < MAXLEN-1) pos = MAXLEN;
		if (pTemp[playerid][pPatrol])
		    format(mes, sizeof(mes), "**[CH: %i, S: %i] [%s] %s: %.*s ...", channel, slot, PatrolInfo[GetPatrolID(playerid)][pTemp[playerid][pPatrol]-1][patrulName], GetNameEx(playerid), pos, params);
		else
			format(mes, sizeof(mes), "**[CH: %i, S: %i] %s: %.*s ...", channel, slot, GetNameEx(playerid), pos, params);

		SendSlotRadioMessage(channel, slot, COLOR_RADIO, mes);
		format(mes, sizeof(mes), "... %s", params[pos]);
		SendSlotRadioMessage(channel, slot, COLOR_RADIO, mes);

		SendLocalMessage(5.0, playerid, COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5, "(Radio) %s noi: %.*s ...", GetNameWithMask(playerid), pos, params);
		SendLocalMessage(5.0, playerid, COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5, "... %s", params[pos]);
	}
	else
	{
	    if (pTemp[playerid][pPatrol])
			format(mes, sizeof(mes), "**[CH: %i, S: %i] [%s] %s: %s", channel, slot, PatrolInfo[GetPatrolID(playerid)][pTemp[playerid][pPatrol]-1][patrulName], GetNameEx(playerid), params);
		else
			format(mes, sizeof(mes), "**[CH: %i, S: %i] %s: %s", channel, slot, GetNameEx(playerid), params);

		SendSlotRadioMessage(channel, slot, COLOR_RADIO, mes);
		SendLocalMessage(5.0, playerid, COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5, "(Radio) %s noi: %s", GetNameWithMask(playerid), params);
	}
	return 1;
}

ALTX:rlow("/rl");
CMD:rlow(playerid, params[])
{
	if (isnull(params))							return SendHelpMessage(playerid, "/rlow [van ban]");
    if (PlayerInfo[playerid][pMutedTime] > 0)	return SendErrorMessage(playerid, "Tro chuyen cuc bo cua ban bi he thong chan.");

    new channel = GetPlayerChannel(playerid);

	if (!IsPlayerHasItem(playerid, INV_RADIO))	return SendErrorMessage(playerid, "Ban khong co bo dam.");
	if (!channel)								return SendErrorMessage(playerid, "Ban khong co tan suat.");
	if (!PlayerInfo[playerid][pAuthed])			return SendErrorMessage(playerid, "Ban chua dang nhap vao tan suat.");

	new mes[128];

	if (strlen(params) > MAXLEN)
	{
		new pos = MAXLEN;

		if (pos < MAXLEN-1) pos = MAXLEN;
		
		if (pTemp[playerid][pPatrol])	format(mes, sizeof(mes), "**[CH: %i, S: 0] [%s] %s [im lang]: %.*s ...", channel, PatrolInfo[GetPatrolID(playerid)][pTemp[playerid][pPatrol]-1][patrulName], GetNameEx(playerid), pos, params);
		else							format(mes, sizeof(mes), "**[CH: %i, S: 0] %s [im lang]: %.*s ...", channel, GetNameEx(playerid), pos, params);

		SendRadioMessage(channel, COLOR_RADIO, mes);
		format(mes, sizeof(mes), "... %s", params[pos]);
		SendRadioMessage(channel, COLOR_RADIO, mes);
		SendLocalMessage(2.0, playerid, COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5, "(Radio) %s noi [im lang]: %.*s ...", GetNameWithMask(playerid), pos, params);
		SendLocalMessage(2.0, playerid, COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5, "... %s", params[pos]);
	}
	else
	{
	    if (pTemp[playerid][pPatrol])	format(mes, sizeof(mes), "**[CH: %i, S: 0] [%s] %s [im lang]: %s", channel, PatrolInfo[GetPatrolID(playerid)][pTemp[playerid][pPatrol]-1][patrulName], GetNameEx(playerid), params);
		else							format(mes, sizeof(mes), "**[CH: %i, S: 0] %s [im lang]: %s", channel, GetNameEx(playerid), params);

		SendRadioMessage(channel, COLOR_RADIO, mes);
		SendLocalMessage(2.0, playerid, COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5, "(Radio) %s noi [im lang]: %s", GetNameWithMask(playerid), params);
	}
	return 1;
}

ALTX:rrlow("/rrl");
CMD:rrlow(playerid, params[])
{
	if (isnull(params))							return SendHelpMessage(playerid, "/rrlow [van ban]");
    if (PlayerInfo[playerid][pMutedTime] > 0)	return SendErrorMessage(playerid,"Tro chuyen cuc bo cua ban bi he thong chan.");

    new channel = GetPlayerChannel(playerid), slot = GetPlayerSlot(playerid);

	if (!IsPlayerHasItem(playerid, INV_RADIO))	return SendErrorMessage(playerid, "Ban khong co bo dam.");
	if (!channel)								return SendErrorRadioMessage(playerid, "Ban khong co tan suat.");
	if (!PlayerInfo[playerid][pAuthed])			return SendErrorRadioMessage(playerid, "Ban chua dang nhap vao tan suat.");

	new mes[128];

	if (strlen(params) > MAXLEN)
	{
		new pos = MAXLEN;

		if (pos < MAXLEN-1) pos = MAXLEN;
		
		if (pTemp[playerid][pPatrol])	format(mes, sizeof(mes), "**[CH: %i, S: %i] [%s] %s [im lang]: %.*s ...", channel, slot, PatrolInfo[GetPatrolID(playerid)][pTemp[playerid][pPatrol]-1][patrulName], GetNameEx(playerid), pos, params);
		else							format(mes, sizeof(mes), "**[CH: %i, S: %i] %s [im lang]: %.*s ...", channel, slot, GetNameEx(playerid), pos, params);

		SendSlotRadioMessage(channel, slot, COLOR_RADIO, mes);
		format(mes, sizeof(mes), "... %s", params[pos]);
		SendSlotRadioMessage(channel, slot, COLOR_RADIO, mes);
		SendLocalMessage(2.0, playerid, COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5, "(Radio) %s noi [im lang]: %.*s ...", GetNameWithMask(playerid), pos, params);
		SendLocalMessage(2.0, playerid, COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5, "... %s", params[pos]);
	}
	else
	{
	    if (pTemp[playerid][pPatrol])	format(mes, sizeof(mes), "**[CH: %i, S: %i] [%s] %s [im lang]: %s", channel, slot, PatrolInfo[GetPatrolID(playerid)][pTemp[playerid][pPatrol]-1][patrulName], GetNameEx(playerid), params);
		else							format(mes, sizeof(mes), "**[CH: %i, S: %i] %s [im lang]: %s", channel, slot, GetNameEx(playerid), params);

		SendSlotRadioMessage(channel, slot, COLOR_RADIO, mes);
		SendLocalMessage(2.0, playerid, COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5, "(Radio) %s noi [im lang]: %s", GetNameWithMask(playerid), params);
	}
	return 1;
} //�