this::OfflineBlockPlayer (playerid, account [], reason [])
{
    if (cache_num_rows () == 0)
	return SendErrorMessage (playerid, "Character \"%s\" khong tim thay trong du lieu.", account);

	new status = cache_get_field_content_int (0, "status");

	if (status == 3) return SendErrorMessage (playerid, "Nhan vat \"%s\" da bi cam roi.", account);
    if (status != 1) return SendErrorMessage (playerid, "Nhan vat \"%s\" da bi cam.", account);

	new query [128];
	mysql_format (dbHandle, query, sizeof (query), "UPDATE` users` SET `block_name`='%e',` block_reason`='%e', `status`='3' WHERE` name`='%e'", GetAccName (playerid), reason, account);
	mysql_tquery (dbHandle, query);

    format (query, sizeof (query), "AdmCmd: Nhan vat %s (offline) da bi cam boi Admin %s. [Ly do: %s]", account, GetAccName (playerid), reason);
	SendClientMessageByAdmin (COLOR_LIGHTRED, query);
	return 1;
}

this::UnBlockPlayer(playerid, account[])
{
	if (cache_num_rows() == 0) return SendErrorMessage(playerid, "Nhan vat \"%s\" khong tim thay trong du lieu.", account);
	if (cache_get_field_content_int(0, "status") != 3) return SendErrorMessage(playerid, "Nhan vat \"%s\" is not locked.", account);
    
	SendAdmMessage("%s da bi bo cam boi Admin %s.", account, GetAccName(playerid));
    
	new query[128];

	mysql_format(dbHandle, query, sizeof(query), "UPDATE `users` SET `status`='1' WHERE `name`='%e'", account);
	mysql_tquery(dbHandle, query);
	return 1;
}

this::OfflineBanPlayer(playerid, account[], time, reason[])
{
    if (cache_num_rows() == 0) return SendErrorMessage(playerid, "Nhan vat \"%s\" khong tim thay trong du lieu.", account);
	if (cache_get_field_content_int(0, "banid") != 0) return SendErrorMessage(playerid, "Tai khoan \"%s\" da bi cam roi.", account);

	new admin = cache_get_field_content_int(0, "admin");
	new accountid = cache_get_field_content_int(0, "accountid");

	if (admin > PlayerInfo[playerid][pAdmin]) return SendAdmMessage("%s [ID: %i] co gang de cam (offline) %s. [Ly do: %s].", GetAccName(playerid), account, reason);
    new query[256];
	mysql_format(dbHandle, query, sizeof(query), "INSERT INTO `bans` (accountid,name,admin,reason,date) VALUES (%i,'%e','%s','%e','%s')", accountid, account, GetAccName(playerid), reason, GetFullDate());
	mysql_tquery(dbHandle, query);

    format(query, sizeof(query), "[/offban] %s da cam %i Ngay boi Admin %s. [Ly do: %s]", account, time, GetAccName(playerid), reason);
	insert_log(query, ADMIN_LOG, 1, accountid, PlayerInfo[playerid][pAccID]);

    format(query, sizeof(query), "AdmCmd: %s (offline) da bi cam %i ngay boi Admin %s. [Ly do: %s]", time, account, GetAccName(playerid), reason);
	SendClientMessageByAdmin(COLOR_LIGHTRED, query);
	return 1;
}

this::UnBanPlayer(playerid, account[])
{
	if (!cache_num_rows())	return SendErrorMessage(playerid, "Account \"%s\" khong bi cam.", account);
    SendAdmMessage("%s da bo cam boi Admin %s.", account, GetAccName(playerid));
	
    new query[128];
	mysql_format(dbHandle, query, sizeof(query), "DELETE FROM `bans` WHERE `name` = '%e'", account);
	mysql_tquery(dbHandle, query);

	mysql_format(dbHandle, query, sizeof(query), "SELECT accountid FROM `bans` WHERE `name` = '%e' LIMIT 1", account);
	new Cache:cache = mysql_query(dbHandle, query),
		accountid = cache_get_field_content_int(0, "accountid", dbHandle);

	cache_delete(cache);

	format(query, sizeof(query), "[/unban] %s da bi bo cam boi Admin %s", account, GetAccName(playerid));
	insert_log(query, ADMIN_LOG, 12, accountid, PlayerInfo[playerid][pAccID]);
	return 1;
}

this::UnBanAnIP(playerid, ip[])
{
	if (!cache_num_rows())	return SendErrorMessage(playerid, "IP \"%s\" khong bi cam.", ip);

    SendAdmMessage("%s bo cam IP %s.", GetAccName(playerid), ip);

	new query[128];
	mysql_format(dbHandle, query, sizeof(query), "DELETE FROM `bans` WHERE `ip` = '%e'", ip);
	mysql_tquery(dbHandle, query);

	mysql_format(dbHandle, query, sizeof(query), "SELECT accountid FROM `bans` WHERE `ip` = '%e' LIMIT 1", ip);
	new Cache:cache = mysql_query(dbHandle, query),
		accountid = cache_get_field_content_int(0, "accountid", dbHandle);

	cache_delete(cache);
	
	new mes[128];
	format(mes, sizeof(mes), "[/unbanip] IP: %s da bi bo cam boi Admin %s", ip, GetAccName(playerid));
	insert_log(query, ADMIN_LOG, 12, accountid, PlayerInfo[playerid][pAccID]);
	return 1;
}

this::OnChangeName(playerid, userid, newname[])
{
	if (cache_num_rows())	return SendErrorMessage(playerid, "Ten nhan vat \"%s\" da ton tai.", newname);

	foreach(new i : Player)
	{
	    if (!IsPlayerLogged(i) || !CompareStrings(GetName(i), newname)) continue;

		SendErrorMessage(playerid, "Ten nhan vat \"%s\" da ton tai.", newname);
		return 1;
	}

	if (!PlayerInfo[userid][pNameChanges]) return SendErrorMessage(playerid, "Nguoi choi khong co dac quyen.");

    PlayerInfo[userid][pNameChanges]--;
	SQL_SetString("accounts", "name_changes", PlayerInfo[userid][pNameChanges], PlayerInfo[userid][pAccID]);

	new oldname[MAX_PLAYER_NAME];
	GetPlayerName(userid, oldname, MAX_PLAYER_NAME);

	ChangeName(userid, newname);
	SendAdmMessage("%s da chap nhan thay doi ten cho %s thanh %s.", GetAccName(playerid), oldname, newname);
	SendSyntaxMessage(userid, "Ban da thay doi ten %s thanh %s administrator %s.", oldname, newname, GetAccName(playerid));
	return 1;
}

this::OnAdminNRN(playerid, userid, newname[])
{
	if (cache_num_rows())	return SendErrorMessage(playerid, "Ten nhan vat \"%s\" da ton tai.", newname);

	foreach(new i : Player)
	{
	    if (!IsPlayerLogged(i) || !CompareStrings(GetName(i), newname)) continue;

		SendErrorMessage(playerid, "Ten nhan vat \"%s\" da ton tai.", newname);
		return 1;
	}


	new oldname[MAX_PLAYER_NAME];
	GetPlayerName(userid, oldname, MAX_PLAYER_NAME);

	ChangeName(userid, newname);
	SendAdmMessage("%s da chap nhan thay doi ten %s thanh %s.", GetAccName(playerid), oldname, newname);
	SendSyntaxMessage(userid, "Ten cua ban da duoc thay doi tu %s thanh %s administrator %s.", oldname, newname, GetAccName(playerid));
	return 1;
}

ChangeName(userid, newname[])
{
    new oldname[MAX_PLAYER_NAME];
	GetPlayerName(userid, oldname, MAX_PLAYER_NAME);

	format(PlayerInfo[userid][pUsername], MAX_PLAYER_NAME+1, newname);
    format(PlayerInfo[userid][pUsername_], MAX_PLAYER_NAME+1, newname);
    strreplace(PlayerInfo[userid][pUsername_], '_', ' ');

    if (!maskOn{userid}) 
	{
	    SetPlayerName(userid, newname);
    	format(PlayerInfo[userid][pMaskname], 32, PlayerInfo[userid][pUsername_]);
	}
	
	for(new i; i != MAX_HOUSES; i++)
	{
	    if (!HouseInfo[i][hID] || HouseInfo[i][hOwnerID] != PlayerInfo[userid][pID]) continue;

		format(HouseInfo[i][hOwner], MAX_PLAYER_NAME, GetNameEx(userid));
	}

	for(new i; i != MAX_BIZ; i++)
	{
	    if (!BizInfo[i][bizID] || BizInfo[i][bizOwnerID] != PlayerInfo[userid][pID]) continue;

		format(BizInfo[i][bizOwner], MAX_PLAYER_NAME, GetName(userid));
	}
	
	for(new i; i < MAX_VEHICLES; i++)
	{
		if (VehicleInfo[i][carOwnerID] != PlayerInfo[userid][pID]) continue;

		format(VehicleInfo[i][carOwner], MAX_PLAYER_NAME, GetNameEx(userid));
	}
	
	SQL_SetString("users", "name", newname, PlayerInfo[userid][pID]);
	
	new query[128];
	mysql_format(dbHandle, query, sizeof(query), "DELETE FROM `tickets` WHERE `userid`=%i", PlayerInfo[userid][pID]);
	mysql_tquery(dbHandle, query);
	
	DeletePlayerTickets(userid);
	return 1;
}

this::AdminSetPlate(playerid, vehicleid, plate[])
{
	if (cache_num_rows())	return SendErrorMessage(playerid, "Bien so xe khac da duoc su dung.");
	    
    format(VehicleInfo[vehicleid][carPlate], 24, "%s", plate);
	SetVehicleNumberPlate(vehicleid, VehicleInfo[vehicleid][carPlate]);
	RespawnVehicle(vehicleid, 1);
	Save_Car(vehicleid);

	SendSyntaxMessage(playerid, "Ban da thay doi bien so xe %s. Bien so xe moi: %s.", VehicleNames[GetVehicleModel(vehicleid)-400], plate);
	
	SAMALL("%s Da thay doi bien so cua chiec xe (%s) ID %i thanh: %s.", GetAccName(playerid), VehicleNames[GetVehicleModel(vehicleid)-400], vehicleid, plate);
	
	new mes[128];
	format(mes, sizeof(mes), "[/asetplate] Administrator %s Da thay doi bien so cua chiec xe (%s) thanh: %s.", GetAccName(playerid), VehicleNames[GetVehicleModel(vehicleid)-400], plate);
	insert_log(mes, ADMIN_LOG, 6, 0, PlayerInfo[playerid][pAccID]);
	return 1;
}

this::OnPlayerOfflineJail(playerid, name[32], time, reason[32])
{
    new rows, fields;

	cache_get_data(rows, fields, dbHandle);

	if (cache_affected_rows(dbHandle))
	{
		new prefix[16] = "admin jail";
		if (PlayerInfo[playerid][pAdmin] > 0) prefix = "administrator";

		new query[128];
		mysql_format(dbHandle, query, sizeof(query), "SELECT accountid FROM `bans` WHERE `name` = '%e' LIMIT 1", name);
		new Cache:cache = mysql_query(dbHandle, query),
			accountid = cache_get_field_content_int(0, "accountid", dbHandle);

		cache_delete(cache);

		new mes[128];
		format(mes, sizeof(mes), "AdmCmd: %s da bo admin jail %s %s va hinh phat trong %i phut, [Ly do: %s]", name, prefix, GetAccName(playerid), time, reason);
		SendClientMessageByAdmin(COLOR_LIGHTRED, mes);

		format(mes, sizeof(mes), "[/offjail] %s da bo admin jail %s %s va hinh phat trong %i phut, [Ly do: %s]", name, prefix, GetAccName(playerid), time, reason);
		insert_log(mes, ADMIN_LOG, 51, accountid, PlayerInfo[playerid][pAccID]);
	}
	else
	{
		SendErrorMessage(playerid, "Ban da that bai trong viec gui %s toi admin jail.", name);
	}
	return 1;
}

this::BanAnIP(playerid, ip[], reason[])
{
	if (cache_num_rows()) return SendErrorMessage(playerid, "IP \"%s\" da bi cam roi.", ip);

    SendAdmMessage("%s da cam IP address: %s.", GetAccName(playerid), ip);

	new pIP[24];
	foreach(new i : Player)
	{
		GetPlayerIp(i, pIP, sizeof(pIP));

		if (!IsPlayerLogged(i) || !CompareStrings(ip, pIP)) continue;

		SendErrorMessage(i, " IP %s da bi cam khoi may chu.", ip);
		KickEx(i);
	}

    new query[256];
	mysql_format(dbHandle, query, sizeof(query), "INSERT INTO `bans` (admin, reason, date, ip) VALUES ('%s', '%e', '%s', '%e')", GetAccName(playerid), reason, GetFullDate(), ip);
	mysql_tquery(dbHandle, query);
	return 1;
}

ClearKillFeed(playerid = INVALID_PLAYER_ID)
{
	if ((playerid != INVALID_PLAYER_ID) && (0 == IsPlayerConnected(playerid))) return 0;

	goto L_start;
	{
		new dummy[16/(cellbits/charbits)];
		#emit const.pri dummy
	}

	#if __Pawn < 0x030A
		SendDeathMessage(0, 0, 0),
		SendDeathMessageToPlayer(0, 0, 0, 0);
	#endif

	L_start:

	const SDM_MAGIC_ID = INVALID_PLAYER_ID-1;
	new i = 5;

	#emit    push.c    SDM_MAGIC_ID
	#emit    push.c    SDM_MAGIC_ID

	if (playerid == INVALID_PLAYER_ID)
	{
		#emit    push.c    12
		do
		{
			#emit    sysreq.c    SendDeathMessage
		}
		while(--i != 0);

		#emit    stack    12
	}
	else
	{
		#emit    push.s    playerid
		#emit    push.c    16
		do
		{	
			#emit    sysreq.c    SendDeathMessageToPlayer
		}
		while(--i != 0);

		#emit    stack    16
	}
	return 1;
}

SendClientMessageByAdmin(color, string[])
{
    foreach(new i : Player)
	{
		if (!IsPlayerLogged(i) || (PlayerInfo[i][pSettings] & togAdmCmds)) continue;

		SendClientMessage(i, color, string);
	}
	return 1;
}


AMSG(color, const str[], {Float,_}:...)
{
    static args, start, end, string[144];
	#emit LOAD.S.pri 8
	#emit STOR.pri args

	if (args > 8)
	{
		#emit ADDR.pri str
		#emit STOR.pri start

	    for (end = start + (args - 8); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}
		#emit PUSH.S str
		#emit PUSH.C 144
		#emit PUSH.C string

		#emit LOAD.S.pri 8
		#emit ADD.C 4
		#emit PUSH.pri

		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4

        foreach(new i : Player)
		{
		    if (!IsPlayerLogged(i) || !PlayerInfo[i][pAdmin]) continue;
			if(PlayerInfo[i][pAdmin])
			{
				SendClientMessage(i, color, string);
			}
			
		}
		return 1;
	}

	foreach(new i : Player)
	{
	    if (!IsPlayerLogged(i) || !PlayerInfo[i][pAdmin]) continue;

		if(PlayerInfo[i][pAdmin])
		{
			SendClientMessage(i, color, str);
		}
	}
	return 1;
}

StaffMSG(color, const str[], {Float,_}:...)
{
    static args, start, end, string[144];

	#emit LOAD.S.pri 8
	#emit STOR.pri args

	if (args > 8)
	{
		#emit ADDR.pri str
		#emit STOR.pri start

	    for (end = start + (args - 8); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}

		#emit PUSH.S str
		#emit PUSH.C 144
		#emit PUSH.C string

		#emit LOAD.S.pri 8
		#emit ADD.C 4
		#emit PUSH.pri

		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4

        foreach(new i : Player)
		{
		    if (!IsPlayerLogged(i) || (!CheckAdminNoDuty(i, ADMIN_LEVEL_1) && !IsTester(i))) continue;
		    SendClientMessage(i, color, string);
		}
		return 1;
	}
	foreach(new i : Player)
	{
	    if (!IsPlayerLogged(i) || (!CheckAdminNoDuty(i, ADMIN_LEVEL_1) && !IsTester(i))) continue;
	    SendClientMessage(i, color, str);
	}
	return 1;
}

CheckAdmin(playerid, level)
{
	return PlayerInfo[playerid][pAdmin] >= level && IsAdminDuty(playerid) ? 1 : 0;
}

CheckAdminNoDuty(playerid, level)
{
	return PlayerInfo[playerid][pAdmin] >= level;
}

IsTester(playerid)
{
	return PlayerInfo[playerid][pHelper] >= 1 && IsTesterDuty(playerid) ? 1 : 0;
}

IsAdminDuty(playerid)
{
	return pTemp[playerid][pAdminDuty] == 1 ? 1 : 0;
}

IsTesterDuty(playerid)
{
	return pTemp[playerid][pTesterDuty] == 1 ? 1 : 0;
}

SendStaffMessage(color, string[])
{
	foreach(new i : Player)
	{
	    if (!IsPlayerLogged(i) || (!IsTester(i) && !CheckAdmin(i, ADMIN_LEVEL_1)) || (PlayerInfo[i][pSettings] & togTester)) continue;

        SCM(i, color, string);
	}
	return 1;
}

SetAdminCode(playerid, adm_code[])
{
	new hashed_code[65];

	SHA256_PassHash(adm_code, ADMIN_HASH, hashed_code, MAX_HASH_LENGTH);
	SQL_SetString("accounts", "admin_code", hashed_code, PlayerInfo[playerid][pAccID]);
	
	SendAdmMessageToPlayer(playerid, "Admin code cua ban da duoc thay doi thanh: %s.", adm_code);
	SendHelpMessage(playerid, "Remember it or write it down!");

	format(PlayerInfo[playerid][pAdminCode], MAX_HASH_LENGTH, "%s", hashed_code);
	return 1;
}

ResetAdminCode(playerid)
{
	DeletePVar(playerid, "Admin:CodeInputted");
	format(PlayerInfo[playerid][pAdminCode], 65, "");
	SQL_SetString("accounts", "admin_code", "", PlayerInfo[playerid][pAccID]);
	SendSyntaxMessage(playerid, "Admin code cua ban da duoc reset.");
	return 1;
}

VerifyAdminCode(playerid, adm_code[])
{
	new hashed_password[65];

	SHA256_PassHash(adm_code, ADMIN_HASH, hashed_password, MAX_HASH_LENGTH);

	if (CompareStrings(hashed_password, PlayerInfo[playerid][pAdminCode]))
	{
		return 1;
	}
	return 0;
}