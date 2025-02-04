CMD:streamer(playerid, params[])
{
	new objects;

	if (!CheckAdmin(playerid, HIGH_ADMIN_LEVEL))	SendNotAdmin(playerid);

	if (sscanf(params, "i", objects))
	{
		SendHelpMessage(playerid, "/streamer [number of objects]");
		SendSyntaxMessage(playerid, "Current number of objects: %i", Streamer_GetVisibleItems(STREAMER_TYPE_OBJECT));
		return 1;
	}
	if (objects < 1 || objects > 1499)	return SendErrorMessage(playerid, "Object chi tu 1 den 1499.");

	new Float:x, Float:y, Float:z;

    Streamer_SetVisibleItems(STREAMER_TYPE_OBJECT, objects);

    foreach(new i : Player)
	{
		if (!IsPlayerLogged(i))	continue;

		GetPlayerPos(i, x, y, z);
		Streamer_DestroyAllVisibleItems(playerid, STREAMER_TYPE_OBJECT);
		Streamer_UpdateEx(i, x, y, z, -1, -1, STREAMER_TYPE_OBJECT);
	}
	return 1;
}

CMD:resetcode(playerid, params[])
{
	if (!CheckAdmin(playerid, HIGH_ADMIN_LEVEL))	return SendNotAdmin(playerid);

	new userid;

	if (sscanf(params, "u", userid))					return SendHelpMessage(playerid, "/resetcode [ID/Ten]");
	if (userid == INVALID_PLAYER_ID)					return SendErrorMessage(playerid, "Khong tim thay nguoi choi. ");
	if (!PlayerInfo[userid][pAdmin])					return SendErrorMessage(playerid, "Nguoi choi nay khong phai admin.");
	if (isempty(PlayerInfo[userid][pAdminCode]))		return SendErrorMessage(playerid, "Ma cua admin nay chua duoc set");
	
	if (IsAdminDuty(userid)) cmd::aduty(userid, "");
	ResetAdminCode(userid);
	SendAdmMessageToPlayer(playerid, "Ban da resetcode cho %s [ID: %i].", GetName(userid), userid);
	return 1;
}

CMD:setstat(playerid, params[])
{
	new userid, option[16], secoption[64];

	if (!CheckAdmin(playerid, HIGH_ADMIN_LEVEL))	SendNotAdmin(playerid);

	if (sscanf(params, "us[16]S()[10]", userid, option, secoption))
	{
		SendHelpMessage(playerid, "/setstat [ID/Ten] [tuy chon] [value]");
		SendSyntaxMessage(playerid, "level/sex/bank/hours/cash/druglabaccess"); //exp
		SendSyntaxMessage(playerid, "carlic/weplic/flylic/taxilic/whours");
		return 1;
	}

	if (!IsPlayerLogged(userid)) return SendNotConnected(playerid);

	if (CompareStrings(option, "level"))
	{
		new level;

		if (sscanf(secoption, "i", level))	return SendHelpMessage(playerid, "/setstat [ID/Ten] level [level]");
		if (level <= 0 || level > 30)		return SendErrorMessage(playerid, "Level 1 to 30.");

		PlayerInfo[userid][pLevel] = level;
		SQL_SetInteger("users", "level", PlayerInfo[userid][pLevel], PlayerInfo[userid][pID]);
		SetPlayerScore(userid, PlayerInfo[userid][pLevel]);
		SendAdmMessage("%s da thay doi cap do cua %s [ID: %i] thanh %i.", GetNameEx(playerid), GetNameEx(userid), userid, level);
		SendAdmMessageToPlayer(userid, "Administrator %s da thay doi cap do cua ban thanh %i.", GetAccName(playerid), level);
		return 1;
	}

	if (CompareStrings(option, "druglabaccess"))
	{
		new level;

		if (sscanf(secoption, "i", level))	return SendHelpMessage(playerid, "/setstat [ID/Ten] druglabaccess [level]");
		if (level <= 0 || level > 1)		return SendErrorMessage(playerid, "Access level 0 to 1.");

		PlayerInfo[userid][pDrugLabAccess] = level;
		SQL_SetInteger("users", "drugaccess", PlayerInfo[userid][pDrugLabAccess], PlayerInfo[userid][pID]);
		SendAdmMessage("%s da thay doi cap do phong thi nghiem thuoc %s [ID: %i] thanh %i.", GetNameEx(playerid), GetNameEx(userid), userid, level);
		SendAdmMessageToPlayer(userid, "Administrator %s da thay doi cap do phong thi nghiem thuoc cua ban thanh %i.", GetAccName(playerid), level);
		return 1;
	}
	
	/*else if (CompareStrings(option, "exp"))
	{
		new exp;

		if (sscanf(secoption, "i", exp))	return SendHelpMessage(playerid, "/setstat [ID/Ten] exp [Experience points]");
		if (exp < 0 || exp > 8192)		return SendErrorMessage(playerid, "Experience points from 0 to 8192.");

		PlayerInfo[userid][pExp] = exp;
		SQL_SetInteger("users", "exp", PlayerInfo[userid][pExp], PlayerInfo[userid][pID]);
		SendAdmMessage("%s changed Experience points %s [ID: %i] to %i.", GetNameEx(playerid), GetNameEx(userid), userid, exp);
		SendSyntaxMessage(userid, "Administrator %s changed your Experience points to %i.", GetAccName(playerid), exp);
		return 1;
	}*/

	else if (CompareStrings(option, "sex"))
	{
		new sex;

		if (sscanf(secoption, "i", sex))	return SendHelpMessage(playerid, "/setstat [ID/Ten] sex [1 - male | 2 - female]");
		if (sex < 1 || sex > 2) 			return SendErrorMessage(playerid, "Gioi tinh tu 1 den 2.");

		PlayerInfo[userid][pSex] = sex;
		SQL_SetInteger("users", "sex", PlayerInfo[userid][pSex], PlayerInfo[userid][pID]);

		new sex_naming[16];

		if (sex == 1)	format(sex_naming, sizeof(sex_naming), "Male");
		else 			format(sex_naming, sizeof(sex_naming), "Female");

		SendAdmMessage("%s da thay doi gioi tinh cua %s [ID: %i] thanh %s.", GetNameEx(playerid), GetNameEx(userid), userid, sex_naming);
		SendAdmMessageToPlayer(userid, "Administrator %s da thay doi gioi tinh cua ban thanh %s.", GetAccName(playerid), sex_naming);
		return 1;
	}

	else if (CompareStrings(option, "bank"))
	{
		new abank;

		if (sscanf(secoption, "i", abank))	return SendHelpMessage(playerid, "/setstat [ID/Ten] bank [sum]");
		if (abank < 0 || abank > 50000000)	return SendErrorMessage(playerid, "So luong tien chi tu $0 den $50 000 000.");

		PlayerInfo[userid][pBank] = abank;
		SQL_SetInteger("users", "bank", PlayerInfo[userid][pBank], PlayerInfo[userid][pID]);
		SendAdmMessage("%s da thay doi so tien trong ngan hang cua %s [ID: %i] thanh $%i.", GetNameEx(playerid), GetNameEx(userid), userid, abank);
		SendAdmMessageToPlayer(userid, "Administrator %s da thay doi so tien trong ngan hang cua ban thanh $%i.", GetAccName(playerid), abank);

		new mes[128];
		format(mes, sizeof(mes), "[/givemoney] Administrator %s da cho nguoi choi %s $%i.", GetAccName(playerid), GetNameEx(userid), abank);
		insert_log(mes, ADMIN_LOG, 8, PlayerInfo[userid][pAccID], PlayerInfo[playerid][pAccID]);
		return 1;
	}

	else if (CompareStrings(option, "hours"))
	{
		new hor;

		if (sscanf(secoption, "i", hor))	return SendHelpMessage(playerid, "/setstat [ID/Ten] hours [number of hours in the game]");
		if (hor < 0 || hor > 8192)			return SendErrorMessage(playerid, "The number of hours in the game from 0 to 8192.");

		PlayerInfo[userid][pHours] = hor;
		SQL_SetInteger("users", "hours", PlayerInfo[userid][pHours], PlayerInfo[userid][pID]);
		SendAdmMessage("%s da thay doi so gio trong may chu %s [ID: %i] thanh %i.", GetNameEx(playerid), GetNameEx(userid), userid, hor);
		SendAdmMessageToPlayer(userid, "Administrator %s da thay doi so gio choi cua ban thanh %i.", GetAccName(playerid), hor);
		return 1;
	}

	else if (CompareStrings(option, "cash"))
	{
		new acash;

		if (sscanf(secoption, "i", acash))	return SendHelpMessage(playerid, "/setstat [ID/Ten] cash [money]");
		if (acash < 0 || acash > 50000000)	return SendErrorMessage(playerid, "So tien chi tu $0 den $50000000.");

		SetCash(userid, acash);
		SQL_SetInteger("users", "cash", PlayerInfo[userid][pCash], PlayerInfo[userid][pID]);
		SendAdmMessage("%s da thay doi so tien cua %s [ID: %i] thanh $%i.", GetNameEx(playerid), GetNameEx(userid), userid, acash);
		SendSyntaxMessage(userid, "Administrator %s da thay doi so tien cua ban thanh $%i.", GetAccName(playerid), acash);
		return 1;
	}

	else if (CompareStrings(option, "carlic"))
	{
		new lic;
		
		if (sscanf(secoption, "i", lic)) return SendHelpMessage(playerid, "/setstat [ID/Ten] carlic [0 - took away | 1 - issued]");
		if (lic < 0 || lic > 1)			 return SendErrorMessage(playerid, "Value from 0 to 1.");

		PlayerInfo[userid][pCarLic] = lic;
		SQL_SetInteger("users", "carlic", PlayerInfo[userid][pCarLic], PlayerInfo[userid][pID]);

		new lic_name[16];

		if (PlayerInfo[userid][pCarLic])	format(lic_name, sizeof(lic_name), "da cung cap");
		else 								format(lic_name, sizeof(lic_name), "da tich thu");

		SendAdmMessage("%s %s giay phep %s [ID: %i].", GetNameEx(playerid), lic_name, GetNameEx(userid), userid);
		SendAdmMessageToPlayer(userid, "Administrator %s %s %s giay phep.", GetAccName(playerid), lic_name, (PlayerInfo[userid][pCarLic]) ? ("Ban") : ("Ban"));
		return 1;
	}

	else if (CompareStrings(option, "flylic"))
	{
		new lic;

		if (sscanf(secoption, "i", lic)) return SendHelpMessage(playerid, "/setstat [ID/Ten] flylic [0 - took away | 1 - issued | 2 - Blacklist]");
		if (lic < 0 || lic > 2)			 return SendSyntaxMessage(playerid, "Value from 0 to 2.");

		PlayerInfo[userid][pFlyLic] = lic;
		SQL_SetInteger("users", "flylic", PlayerInfo[userid][pFlyLic], PlayerInfo[userid][pID]);

		new lic_name[20];

		switch(PlayerInfo[userid][pFlyLic])
		{
			case 0: format(lic_name, sizeof(lic_name), "da tich thu");
			case 1: format(lic_name, sizeof(lic_name), "da cung cap");
			case 2: format(lic_name, sizeof(lic_name), "them vao danh sach den");
		}

		SendAdmMessage("%s %s bang lai may bay %s [ID: %i].", GetNameEx(playerid), lic_name, GetNameEx(userid), userid);
		SendAdmMessageToPlayer(userid, "Administrator %s %s %s bang lai may bay.", GetAccName(playerid), lic_name, (PlayerInfo[userid][pFlyLic]) ? ("Ban") : ("Ban"));
		return 1;
	}

	else if (CompareStrings(option, "taxilic"))
	{
		new lic;

		if (sscanf(secoption, "i", lic))	return SendHelpMessage(playerid, "/setstat [ID/Ten] taxilic [0 - took away | 1 - issued | 2 - blacklist]");
		if (lic < 0 || lic > 2)			return SendSyntaxMessage(playerid, "Value from 0 to 2.");

		PlayerInfo[userid][pTaxiLic] = lic;
		SQL_SetInteger("users", "taxilic", PlayerInfo[userid][pTaxiLic], PlayerInfo[userid][pID]);

		new lic_name[20];

		switch(PlayerInfo[userid][pTaxiLic])
		{
			case 0: format(lic_name, sizeof(lic_name), "da tich thu");
			case 1: format(lic_name, sizeof(lic_name), "da cung cap");
			case 2: format(lic_name, sizeof(lic_name), "them vao danh sach den");
		}

		SendAdmMessage("%s %s giay phep taxi %s [ID: %i].", GetNameEx(playerid), lic_name, GetNameEx(userid), userid);
		SendAdmMessageToPlayer(userid, "Administrator %s %s %s giay phep taxi.", GetAccName(playerid), lic_name, (PlayerInfo[userid][pTaxiLic]) ? ("Ban") : ("Ban"));
		return 1;
	}

	else if (CompareStrings(option, "weplic"))
	{
		new lic;

		if (sscanf(secoption, "i", lic))	return SendHelpMessage(playerid, "/setstat [ID/Ten] weplic [0 - took away | 1 - issued]");
		if (lic < 0 || lic > 1)			return SendSyntaxMessage(playerid, "Value from 0 to 1.");

		PlayerInfo[userid][pWepLic] = lic;
		SQL_SetInteger("users", "weplic", PlayerInfo[userid][pWepLic], PlayerInfo[userid][pID]);

		new lic_name[16];

		if (PlayerInfo[userid][pWepLic])	format(lic_name, sizeof(lic_name), "da cung cap");
		else							format(lic_name, sizeof(lic_name), "da tich thu");

		SendAdmMessage("%s %s giay phep su dung vu khi %s [ID: %i].", GetNameEx(playerid), lic_name, GetNameEx(userid), userid);
		SendAdmMessageToPlayer(userid, "Administrator %s %s %s giay phep su dung vu khi.", GetAccName(playerid), lic_name, (PlayerInfo[userid][pWepLic]) ? ("Ban") : ("Ban"));
		return 1;
	}

	else if (CompareStrings(option, "whours"))
	{
		new whours;

		if (sscanf(secoption, "i", whours))	return SendHelpMessage(playerid, "/setstat [ID/Ten] whours [value]");
		if (whours < 0 || whours > 256)		return SendErrorMessage(playerid, "Career hours from 0 to 256.");

		PlayerInfo[userid][pCareer] = whours;
		SQL_SetInteger("users", "career", PlayerInfo[userid][pCareer], PlayerInfo[userid][pID]);
		SendAdmMessage("%s changed career hours %s [ID: %i] to %i.", GetNameEx(playerid), GetNameEx(userid), userid, whours);
		SendAdmMessageToPlayer(playerid, "Administrator %s changed your career hours to %i.", GetAccName(playerid), whours);
	}
	return 1;
}

CMD:gmx(playerid, params[])
{
	new time;

	if (!CheckAdmin(playerid, HIGH_ADMIN_LEVEL)) return SendNotAdmin(playerid);
	if (restart_time)
	{
		SAMALL("%s canceled server restart.", GetAccName(playerid));

		restart_time = 0;
	    return 1;
	}

	if (sscanf(params, "i", time)) 	return SendHelpMessage(playerid, "/gmx [time in seconds]");
	if (time < 10 || time > 300)	return SendErrorMessage(playerid, "Restart time from 10 to 300 seconds.");

    restart_time = time;

	SAMALL("%s da bat dau bao tri may chu sau %i giay.", GetAccName(playerid), time);
	return 1;
}

CMD:copstocrime(playerid, params[])
{
	new amount;
	if (!CheckAdmin(playerid, HIGH_ADMIN_LEVEL)) return SendNotAdmin(playerid);
	if (sscanf(params, "d", amount))			return SendHelpMessage(playerid, "/copstocrime [quantity]");
	if (amount < 0)								return SendErrorMessage(playerid, "A negative number!");

	NEED_COPS_TO_CRIME = amount;
	SendAdmMessageToAll("Administrator %s da thay nguong cua canh sat doi voi toi pham thanh %i.", GetAccName(playerid), amount);
	return 1;
}

CMD:firetocrime(playerid, params[])
{
	new amount;
	if (!CheckAdmin(playerid, HIGH_ADMIN_LEVEL)) return SendNotAdmin(playerid);
	if (sscanf(params, "d", amount))			return SendHelpMessage(playerid, "/firetocrime [quantity]");
	if (amount < 0)								return SendErrorMessage(playerid, "A negative number!");

	NEED_FIRE_TO_CRIME = amount;
	SendAdmMessageToAll("Administrator %s da thay doi nguong cua toi pham thanh %i.", GetAccName(playerid), amount);
	return 1;
}

CMD:admin(playerid, params[])
{
	new userid, level;

	if (!CheckAdmin(playerid, HIGH_ADMIN_LEVEL))	return SendNotAdmin(playerid);
	if (sscanf(params, "ud", userid, level))		return SendHelpMessage(playerid, "/admin [ID/Ten] [level]");
	if (!IsPlayerLogged(userid))					return SendNotConnected(playerid);
	if (userid == playerid)							return 1;
	if (!level && !PlayerInfo[userid][pAdmin])		return SendErrorMessage(playerid, "The player has no administration rights.");
	
	if (PlayerInfo[userid][pAdmin] == HIGH_ADMIN_LEVEL) {
		if (level < 0 || level > HIGH_ADMIN_LEVEL-1)	return SendErrorMessage(playerid, "Administration level from 0 to 3.");
	} else if (PlayerInfo[userid][pAdmin] == DEVELOPER_LEVEL) {
		if (level < 0 || level > HIGH_ADMIN_LEVEL)		return SendErrorMessage(playerid, "Administration level from 0 to 4.");
	}
	
	if (!level)
	{
		if (IsAdminDuty(userid)) cmd::aduty(userid, "");
		
		SendAdmMessage("%s deprived %s administrator rights.", GetAccName(playerid), GetAccName(userid));
		SendAdmMessageToPlayer(userid, "%s deprived you of administrator rights.", GetAccName(playerid));
		PlayerInfo[userid][pAdmin] = 0;
		SQL_SetInteger("accounts", "admin", PlayerInfo[userid][pAdmin], PlayerInfo[userid][pAccID]);		
		return 1;
	}

	PlayerInfo[userid][pAdmin] = level;
	SQL_SetInteger("accounts", "admin", PlayerInfo[userid][pAdmin], PlayerInfo[userid][pAccID]);
	SendAdmMessage("%s issued %s %i access level.", GetAccName(playerid), GetNameEx(userid), level);
	SendAdmMessageToPlayer(userid, "%s issued to you %i access level.", GetAccName(playerid), level);
	return 1;
}

CMD:makepremium(playerid, params[])
{
	new userid, rank;
	if (sscanf(params, "ui", userid, rank))		return SendHelpMessage(playerid, "/makepremium [ID/Ten] [0-3]");
	if (!IsPlayerLogged(userid))					return SendNotConnected(playerid);
	if (rank < 0 || rank > 3)					return SendErrorMessage(playerid, "Premium account tier 0 to 3.");

	new status_premium[4][32] = {"usual", "Bronze", "Silver", "Gold"};

	PlayerInfo[userid][pPremium] = rank;
	PlayerInfo[userid][pPremiumTime] = gettime() + 30 * 86400;
	SQL_SetInteger("users", "vip", PlayerInfo[userid][pPremium], PlayerInfo[userid][pID]);
	SQL_SetInteger("users", "vip_time", PlayerInfo[userid][pPremiumTime], PlayerInfo[userid][pID]);
	SQL_SetFloat("users", "spawnhealth", 75.0, PlayerInfo[userid][pID]);
	
	SendAdmMessage("%s da thiet lap %s Premium %s tai khoan.", GetAccName(playerid), GetAccName(userid), status_premium[rank]);
	SendAdmMessageToPlayer(userid, "Administrator %s da thiet lap cho ban Premium %s.", GetAccName(playerid), status_premium[rank]);
	return 1;
}

CMD:tester(playerid, params[])
{
	new userid, level;
	
	if (!CheckAdmin(playerid, HIGH_ADMIN_LEVEL))	return SendNotAdmin(playerid);
	if (sscanf(params, "ui", userid, level))		return SendHelpMessage(playerid, "/tester [ID/Ten] [0 - take off | 1 - install]");
	if (!IsPlayerLogged(playerid))					return SendNotConnected(playerid);
	if (level < 0 || level > 1)						return SendErrorMessage(playerid, "Level 0 to 1.");
	if (!level && !PlayerInfo[userid][pHelper])		return SendErrorMessage(playerid, "This player does not have tester rights.");
	if (level && PlayerInfo[userid][pHelper])		return SendErrorMessage(playerid, "This player is already a tester.");

	if (!level)
	{
		if (IsTesterDuty(userid)) cmd::tduty(userid, "");

		PlayerInfo[userid][pHelper] = level;
		SQL_SetInteger("accounts", "helper", PlayerInfo[userid][pHelper], PlayerInfo[userid][pAccID]);
		SendAdmMessage("%s da take %s tester powers.", GetAccName(playerid), GetNameEx(userid));
		SendAdmMessageToPlayer(userid, "Administrator %s da take tester cua ban.", GetAccName(playerid));
		return 1;
	}

	PlayerInfo[userid][pHelper] = level;
	SQL_SetInteger("accounts", "helper", PlayerInfo[userid][pHelper], PlayerInfo[userid][pAccID]);
	SendAdmMessage("%s cai dat %s tester powers.", GetAccName(playerid), GetNameEx(userid));
	SendAdmMessageToPlayer(userid, "Administrator %s da cho ban quyen tester.", GetAccName(playerid));
	return 1;
}

CMD:givemoney(playerid, params[])
{
	new userid, amount;
	if (sscanf(params, "ui", userid, amount))	return SendHelpMessage(playerid, "/givemoney [ID/Ten] [sum]");
	if (!IsPlayerLogged(userid))					return SendNotConnected(playerid);
	if (amount < 0 || amount > 50000000)			return SendErrorMessage(playerid, "Amount from $0 to $50000000.");

	GiveCash(userid, amount);
	
	new mes[128];
	format(mes, sizeof(mes), "[/givemoney] Administrator %s gave %s - money $%i.", GetAccName(playerid), GetNameEx(userid), amount);
	insert_log(mes, ADMIN_LOG, 8, PlayerInfo[userid][pAccID], PlayerInfo[playerid][pAccID]);

	if (amount < 0)
	{
		SendAdmMessage("%s lay tu %s $%i.", GetAccName(playerid), GetNameEx(userid), amount);
		SendAdmMessageToPlayer(userid, "%s lay tu ban $%i.", GetAccName(playerid), amount);
		return 1;
	}
	else
	{
		SendAdmMessage("%s da cho %s $%i.", GetAccName(playerid), GetNameEx(userid), amount);
		SendAdmMessageToPlayer(userid, "%s da cho ban $%i.", GetAccName(playerid), amount);
	}
	return 1;
}

ALTX:aobject("/aobj");
CMD:aobject(playerid, params[])
{
	if (!CheckAdmin(playerid, HIGH_ADMIN_LEVEL))	return SendNotAdmin(playerid);

	new option[16], secoption[128];

	if (sscanf(params, "s[16]S()[128]", option, secoption))
	{
		SendHelpMessage(playerid, "(/aobj)ect [options]");
		SendSyntaxMessage(playerid, "create/remove/edit/editobjects/goto");
		return 1;
	}

	if (CompareStrings(option, "create"))
	{
		new modelid;

		if (sscanf(secoption, "d", modelid))	return SendHelpMessage(playerid, "(/aobj)ect create [ID object]");

		new objectid = -1;

		for(new i = 0; i < MAX_OBJECTS; i++)
		{
			if (ObjectsInfo[i][oID] || ObjectsInfo[i][oObjectOn]) continue;

			objectid = i;
			break;
		}

		if (objectid == -1)	return SendErrorMessage(playerid, "The maximum number of objects to be created has been reached.");

		GetPlayerPos(playerid, ObjectsInfo[objectid][oPosX], ObjectsInfo[objectid][oPosY], ObjectsInfo[objectid][oPosZ]);
		
		ObjectsInfo[objectid][oModel] = modelid;
		ObjectsInfo[objectid][oPosRX] = 
		ObjectsInfo[objectid][oPosRY] = 
		ObjectsInfo[objectid][oPosRZ] = 0.0;
		ObjectsInfo[objectid][oInt] = GetInterior(playerid);
		ObjectsInfo[objectid][oVW] = GetWorld(playerid);
		ObjectsInfo[objectid][oObject] = CreateDynamicObject(modelid, ObjectsInfo[objectid][oPosX], ObjectsInfo[objectid][oPosY], ObjectsInfo[objectid][oPosZ], 0.0, 0.0, 0.0, ObjectsInfo[objectid][oVW], ObjectsInfo[objectid][oInt], -1, 200.0);

		if (ObjectsInfo[objectid][oObject] == INVALID_OBJECT_ID)	return SendErrorMessage(playerid, "Failed to create object.");

		ObjectsInfo[objectid][oObjectOn] = 1;

		AddObjectToFile(objectid, modelid, ObjectsInfo[objectid][oInt], ObjectsInfo[objectid][oVW], ObjectsInfo[objectid][oPosX], ObjectsInfo[objectid][oPosY], ObjectsInfo[objectid][oPosZ]);
		SendAdmMessageToPlayer(playerid, "You have created an object [ID: %i | MODEL: %i].", objectid, modelid);
		return 1;
	}

	else if (CompareStrings(option, "remove"))
	{
		new objectid;

		if (sscanf(secoption, "i", objectid))		return SendHelpMessage(playerid, "(/aobj)ect remove [ID object]");
		if (ObjectsInfo[objectid][oObjectOn] != 1)	return SendErrorMessage(playerid,"Object not found.");

		new query[128];
		mysql_format(dbHandle, query, sizeof(query), "DELETE FROM `objects` WHERE `id` = %i", ObjectsInfo[objectid][oID]);
		mysql_tquery(dbHandle, query);

		if (IsValidDynamicObject(ObjectsInfo[objectid][oObject]))	DestroyDynamicObject(ObjectsInfo[objectid][oObject]);

		ObjectsInfo[objectid][oPosX] = 
		ObjectsInfo[objectid][oPosY] = 
		ObjectsInfo[objectid][oPosZ] = 
		ObjectsInfo[objectid][oPosRX] = 
		ObjectsInfo[objectid][oPosRY] = 
		ObjectsInfo[objectid][oPosRZ] = 0.0;
		ObjectsInfo[objectid][oObjectOn] =
		ObjectsInfo[objectid][oID] = 0;
		
		SendAdmMessageToPlayer(playerid, "You have successfully deleted the object. [ID: %i]", objectid);
		return 1;
	}

	else if (CompareStrings(option, "edit"))
	{
		new id, parameters[16], arg[112];

		if (sscanf(secoption, "is[12]S()[112]", parameters, arg))
		{
			SendHelpMessage(playerid, "(/aobj)ect edit [ID object] [options]");
			SendSyntaxMessage(playerid, "pos/texture/deltexture");
			return 1;
		}

		if (id < 0 || id > MAX_OBJECTS - 1 || ObjectsInfo[id][oObjectOn] != 1)	return SendErrorMessage(playerid,"Object not found.");

		if (CompareStrings(parameters, "pos"))
		{
			SetPVarInt(playerid, #edit_object, id + 1);
			EditDynamicObject(playerid, ObjectsInfo[id][oObject]);
			return 1;
		}

		else if (CompareStrings(parameters, "texture"))
		{
			new slot, model, txdname[32], texturename[32];

			if (sscanf(arg, "iis[32]s[32]", slot, model, txdname, texturename))
			{
				SendHelpMessage (playerid, "(/aobj)ect edit [object ID] texture [replacement slot (0-15)] [model ID] [TXD name] [texture name]");
				SendSyntaxMessage (playerid, "The list of textures with images is available on the site: http://texture.xyin.ws");
				return 1;
			}
			
			if (slot <0 || slot> 15) return SendErrorMessage (playerid, "Slot 0 to 15.");
			if (model <0) return SendErrorMessage (playerid, "Model ID is greater than 0.");
			if (strlen (txdname)>= 32) return SendErrorMessage (playerid, "TXD name is not more than 32 characters.");
			if (strlen (texturename)>= 32) return SendErrorMessage (playerid, "Texture name, 32 characters max.");
			
			if (!SetDynamicObjectMaterial(ObjectsInfo[id][oObject], slot, model, txdname, texturename, 0))	return SendErrorMessage(playerid, "Failed to change the texture of the object.");

			new query[128];
			mysql_format(dbHandle, query, sizeof(query), "SELECT * FROM `objects_texture` WHERE `objectid` = %i AND `slot` = %i", ObjectsInfo[id][oID], slot);
			mysql_tquery(dbHandle, query, "OnObjectTextureInsert", "iiiiss", playerid, id, slot, model, txdname, texturename);
			return 1;
		}

		else if (CompareStrings(parameters, "deltexture"))
		{
			if (isnull(arg))	return SendHelpMessage(playerid, "(/aobj)ect edit [ID object] deltexture [slot (0-15)]");

			new slot = strval(arg);

			if (slot < 0 || slot > 15)	return SendErrorMessage(playerid,"Slot from 0 to 15.");
			
			if (!SetDynamicObjectMaterial(ObjectsInfo[id][oObject], slot, -1, "none", "none", 0))	return SendErrorMessage(playerid, "Failed to remove texture from object.");

			new query[128];
			mysql_format(dbHandle, query, sizeof(query), "DELETE FROM `objects_texture` WHERE `objectid` = %i AND `slot` = %i", ObjectsInfo[id][oID], slot);
			mysql_tquery(dbHandle, query);

			SendAdmMessageToPlayer(playerid,"You have deleted the object's [ID: %i] texture [SLOT: %i].", id, slot);
			return 1;
		}
	}

	else if (CompareStrings(option, "goto"))
	{
		new objectid;

		if (sscanf(secoption, "i", objectid))													return SendHelpMessage(playerid, "(/aobj)ect goto [ID object]");
		if (objectid < 0 || objectid > MAX_OBJECTS || ObjectsInfo[objectid][oObjectOn] != 1)	return SendErrorMessage(playerid, "Object not found.");

		SetPlayerPosEx(playerid, ObjectsInfo[objectid][oPosX], ObjectsInfo[objectid][oPosY], ObjectsInfo[objectid][oPosZ]);
		SetInterior(playerid, ObjectsInfo[objectid][oInt]);
		SetWorld(playerid, ObjectsInfo[objectid][oVW]);
		SendSpecialMessage(playerid, "You teleported to the object [ID: %i].", objectid);
		return 1;
	}
	
	else if (CompareStrings(option, "editobjects"))
	{
		SetPVarInt(playerid, #edit_objects, 1);
		SelectObject(playerid);
		SendAdmMessageToPlayer(playerid, "Select one of the objects by clicking on it.");
		return 1;
	}

	else 
	{
		SendHelpMessage(playerid, "(/aobj)ect [options]");
		SendSyntaxMessage(playerid, "create/remove/edit/editobjects/goto");
	}
	return 1;
}

CMD:atower(playerid, params[])
{
	if (!CheckAdmin(playerid, HIGH_ADMIN_LEVEL))	return SendNotAdmin(playerid);

	new option[16], secoption[128];

	if (sscanf(params, "s[16]S()[128]", option, secoption))
	{
		SendHelpMessage(playerid, "/atower [options]");
		SendSyntaxMessage(playerid, "create/remove/edit/goto");
		return 1;
	}	

	if (CompareStrings(option, "create"))
	{
		if (GetWorld(playerid) || GetInterior(playerid))	return SendErrorMessage(playerid, "You cannot create a tower indoors.");

		new type;

		if (sscanf(secoption, "i", type))	return SendHelpMessage(playerid, "/atower create [0 - small | 1 - large] ");
		if (type < 0 || type > 1)			return SendErrorMessage(playerid, "Tower type from 0 to 1.");
		new towerid = -1;

		for(new i; i < MAX_TOWERS; i++)
		{
			if (TowerInfo[i][towerOn]) continue;

			towerid = i;
			break;
		}

		if (towerid == -1)	return SendErrorMessage(playerid, "The maximum number of communication towers has been reached.");

		new Float:x, Float:y, Float:z, Float:angle;

		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, angle);	
		x += 1.0 * floatsin(-angle, degrees);
		y += 1.0 * floatsin(-angle, degrees);
		z -= 1.6;

		TowerInfo[towerid][towerModel] = (type) ? (3763) : (3030);
		TowerInfo[towerid][towerPosX] = x;
		TowerInfo[towerid][towerPosY] = y;
		TowerInfo[towerid][towerPosZ] = z;
		TowerInfo[towerid][towerPosRX] = 0;
		TowerInfo[towerid][towerPosRY] = 0;
		TowerInfo[towerid][towerPosRZ] = angle;
		TowerInfo[towerid][towerOn] = 1;
		TowerInfo[towerid][towerObject] = CreateDynamicObject(TowerInfo[towerid][towerModel], x, y, z, 0.0, 0.0, angle, 0, 0);

		new query[128];
		mysql_format(dbHandle, query, sizeof(query), "INSERT INTO `towers` (`model`, `x`, `y`, `z`, `rz`) VALUES (%i, %f, %f, %f, %f)", type, x, y, z, angle);
		mysql_tquery(dbHandle, query, "OnTowerInsert", "i", towerid);

		new tower_name[16];

		if (!type)	format(tower_name, sizeof(tower_name), "small");
		else 		format(tower_name, sizeof(tower_name), "great");

		SendAdmMessageToPlayer(playerid, "You have created% s communications tower [ID:%i].", tower_name, towerid);
		return 1;
	}

	else if (CompareStrings(option, "remove"))
	{
		new towerid;

		if (sscanf(secoption, "d", towerid))										return SendHelpMessage(playerid, "/atower remove [tower ID]");
		if (towerid < 0 || towerid > MAX_TOWERS || !TowerInfo[towerid][towerOn])	return SendErrorMessage(playerid, "Tower not found.");
		
		if (IsValidDynamicObject(TowerInfo[towerid][towerObject])) DestroyDynamicObject(TowerInfo[towerid][towerObject]);

		new query[128];
		mysql_format(dbHandle, query, sizeof(query), "DELETE FROM `towers` WHERE `id` = %i", TowerInfo[towerid][towerID]);
		mysql_tquery(dbHandle, query);

		TowerInfo[towerid][towerOn] = 
		TowerInfo[towerid][towerID] = 0;
		SendAdmMessageToPlayer(playerid, "Tower of communication [ID:%i] has been removed.", towerid);
		return 1;
	}

	else if (CompareStrings(option, "edit"))
	{
		new towerid, parameters[16], arg[112];

		if (sscanf(secoption, "d", towerid))
		{
			SendHelpMessage(playerid, "/atower edit [Tower ID] [parameter] ");
			SendSyntaxMessage(playerid, "pos type");
			return 1;
		}

		if (towerid < 0 || towerid > MAX_TOWERS || !TowerInfo[towerid][towerID])	return SendErrorMessage (playerid, "No tower found.");

		if (CompareStrings(parameters, "pos"))
		{
			if (GetWorld(playerid) || GetInterior(playerid))																							return SendErrorMessage (playerid, "You cannot edit the tower indoors.");
			if (!IsPlayerInRangeOfPoint(playerid, 10.0, TowerInfo[towerid][towerPosX], TowerInfo[towerid][towerPosY], TowerInfo[towerid][towerPosZ]))	return SendErrorMessage (playerid, "You should be near the tower.");
			if (GetPVarInt(playerid, #edit_tower) != 0)																									return SendErrorMessage (playerid, "You are already editing the tower.");

			SetPVarInt(playerid, #edit_tower, towerid + 1);
			EditDynamicObject(playerid, TowerInfo[towerid][towerObject]);
			return 1;
		}
		else if (CompareStrings(parameters, "type"))
		{
			new type;
			if (sscanf (arg, "i", type)) return SendHelpMessage (playerid, "/atower edit [tower ID] type [0 - small | 1 - large]");
			if (type <0 || type> 1) return SendErrorMessage (playerid, "Tower type from 0 to 1.");

			TowerInfo[towerid][towerModel] = (type) ? (3763) : (3030);
			SQL_SetInteger("towers", "model", TowerInfo[towerid][towerModel], TowerInfo[towerid][towerID]);

			if (IsValidDynamicObject(TowerInfo[towerid][towerObject])) DestroyDynamicObject(TowerInfo[towerid][towerObject]);

			TowerInfo[towerid][towerObject] = CreateDynamicObject(TowerInfo[towerid][towerModel], TowerInfo[towerid][towerPosX], TowerInfo[towerid][towerPosY], TowerInfo[towerid][towerPosZ], TowerInfo[towerid][towerPosRX],
			TowerInfo[towerid][towerPosRY], TowerInfo[towerid][towerPosRZ], 0, 0);
			SendAdmMessageToPlayer(playerid,"You have changed the tower type [ID:%i].", towerid);
			return 1;
		}
	}

	else if (CompareStrings(option, "goto"))
	{
		new towerid; 

		if (sscanf(secoption, "d", towerid))										return SendHelpMessage(playerid, "/atower goto [Tower ID] ");
		if (towerid < 0 || towerid > MAX_TOWERS || !TowerInfo[towerid][towerID])	return SendErrorMessage(playerid, "Tower not found.");

		SetWorld(playerid, 0);
		SetInterior(playerid, 0);
		SetPlayerPosEx(playerid, TowerInfo[towerid][towerPosX], TowerInfo[towerid][towerPosY], TowerInfo[towerid][towerPosZ]);
		SendSpecialMessage (playerid, "You teleported to the tower[ID: %i].", towerid);
	}
	return 1;
}

CMD:departship(playerid, params[])
{
    if (!CheckAdmin(playerid, HIGH_ADMIN_LEVEL)) return SendNotAdmin(playerid);

	new depart;

	if (sscanf(params,"i", depart))	return SendHelpMessage(playerid, "/departship[sending time in seconds] ");

	ship_depart = gettime() + depart;
	return 1;
}

CMD:timetruck(playerid, params[])
{
    if (!CheckAdmin(playerid, HIGH_ADMIN_LEVEL)) return SendNotAdmin(playerid);

	new depart;

	if (sscanf(params,"i", depart))	return SendHelpMessage(playerid, "/timetruck [time in seconds] ");

	time_truck = depart;
	return 1;
}

CMD:nexttship(playerid, params[])
{
    if (!CheckAdmin(playerid, HIGH_ADMIN_LEVEL)) return SendNotAdmin(playerid);

	new depart;

	if (sscanf(params,"i", depart))	return SendHelpMessage(playerid, "/nexttship [return time in seconds] ");

	ship_next = gettime() + depart;
	return 1;
}

CMD:agarage(playerid, params[])
{
	if (!CheckAdmin(playerid, HIGH_ADMIN_LEVEL))	return SendNotAdmin(playerid);

	new option[16], secoption[128];

	if (sscanf(params, "s[16]S()[128]", option, secoption))
	{
		SendHelpMessage(playerid, "/agarage [options]");
		SendSyntaxMessage(playerid, "create/remove/edit/goto/createbiz/createhouse");
		return 1;
	}

	if (CompareStrings(option, "create"))
	{
		new type, price;

		if (sscanf (secoption, "ii", type, price)) return SendHelpMessage (playerid, "/agarage create [type] [cost]");
		if (type <1 || type> 9) return SendErrorMessage (playerid, "Type from 1 to 9.");
		if (price <= 0 || price> 1000000) return SendErrorMessage (playerid, "Price from $ 1 to $ 1,000,000.");
		if (GetInterior (playerid) || GetWorld (playerid)) return SendErrorMessage (playerid, "You must be outdoors.");
		if (IsPlayerInAnyVehicle (playerid)) return SendErrorMessage (playerid, "You must be out of the vehicle.");
		if (Garage_Create (playerid, type, price) == -1) return SendErrorMessage (playerid, "The maximum number of garages has been reached.");

		return 1;
	}

	else if (CompareStrings(option, "remove"))
	{
		new id;

		if (sscanf(secoption, "i", id))								return SendHelpMessage(playerid, "/agarage remove [ID garage]");
		if (id < 0 || id > MAX_GARAGES || !GarageInfo[id][garageID])	return SendErrorMessage (playerid, "No garage found.");

		new query[128];
		mysql_format(dbHandle, query, sizeof(query), "DELETE FROM `garage` WHERE `id` = %i", GarageInfo[id][garageID]);
		mysql_tquery(dbHandle, query);

		if (IsValidDynamicCP(GarageInfo[id][garageCP]))	DestroyDynamicCP(GarageInfo[id][garageCP]);

		GarageInfo[id][garageID] = 0;
		SendAdmMessageToPlayer (playerid, "You have removed garage [ID:%i].", id);
		return 1;
	}

	else if (CompareStrings(option, "edit"))
	{
		new id, parameters[16], arg[112];

		if (sscanf(secoption, "is[12]S()[112]", id, parameters, arg))
		{
			SendHelpMessage(playerid, "/agarage edit [ID garage] [options]");
			SendSyntaxMessage(playerid, "pos / vehpos / int / customint / exitdoor / price / locked");
			return 1;
		}

		if (id < 0 || id >= MAX_GARAGES || !GarageInfo[id][garageID])	return SendErrorMessage (playerid, "Garage not found.");

		if (CompareStrings(parameters, "pos"))
		{
			if (IsPlayerInAnyVehicle (playerid)) return SendErrorMessage (playerid, "You must be out of the vehicle.");
			if (GetInterior (playerid) || GetWorld (playerid)) return SendErrorMessage (playerid, "You must be outdoors.");

			GetPlayerPos(playerid, GarageInfo[id][garagePlayer_Enter][0], GarageInfo[id][garagePlayer_Enter][1], GarageInfo[id][garagePlayer_Enter][2]);
			GarageInfo[id][garageEnterInt] = 
			GarageInfo[id][garageEnterVW] = 0;

			if (IsValidDynamicCP(GarageInfo[id][garageCP]))	DestroyDynamicCP(GarageInfo[id][garageCP]);

			GarageInfo[id][garageCP] = CreateDynamicCP(GarageInfo[id][garagePlayer_Enter][0], GarageInfo[id][garagePlayer_Enter][1], GarageInfo[id][garagePlayer_Enter][2], 0.9, 0, 0, -1, 3.0);
			SendAdmMessageToPlayer (playerid, "You have moved the garage entrance [ID:%i].", id);

			SQL_SetFloat("garage", "player_enter_x", GarageInfo[id][garagePlayer_Enter][0], GarageInfo[id][garageID]);
			SQL_SetFloat("garage", "player_enter_y", GarageInfo[id][garagePlayer_Enter][1], GarageInfo[id][garageID]);
			SQL_SetFloat("garage", "player_enter_z", GarageInfo[id][garagePlayer_Enter][2], GarageInfo[id][garageID]);
			SQL_SetInteger("garage", "enter_int", 0, GarageInfo[id][garageID]);
			SQL_SetInteger("garage", "enter_vw", 0, GarageInfo[id][garageID]);
			return 1;
		}
		
		else if (CompareStrings(parameters, "vehpos"))
		{
			//if (!IsPlayerInAnyVehicle(playerid))				return SendErrorMessage (playerid, "You must be in the vehicle.");
			if (GetInterior (playerid) || GetWorld (playerid)) return SendErrorMessage (playerid, "You must be outdoors.");

			GetVehiclePos(GetPlayerVehicleID(playerid), GarageInfo[id][garageVeh_Enter][0], GarageInfo[id][garageVeh_Enter][1], GarageInfo[id][garageVeh_Enter][2]);
			GetVehicleZAngle(GetPlayerVehicleID(playerid), GarageInfo[id][garageVeh_Enter][3]);
			SendAdmMessageToPlayer (playerid, "You have moved the entrance to the garage [ID:%i].", id);

			SQL_SetFloat("garage", "veh_enter_x", GarageInfo[id][garageVeh_Enter][0], GarageInfo[id][garageID]);
			SQL_SetFloat("garage", "veh_enter_y", GarageInfo[id][garageVeh_Enter][1], GarageInfo[id][garageID]);
			SQL_SetFloat("garage", "veh_enter_z", GarageInfo[id][garageVeh_Enter][2], GarageInfo[id][garageID]);
			SQL_SetFloat("garage", "veh_enter_fa", GarageInfo[id][garageVeh_Enter][3], GarageInfo[id][garageID]);
			return 1;
		}

		else if (CompareStrings(parameters, "int"))
		{
			new type;

			if (sscanf(arg, "i", type))						return SendHelpMessage(playerid, "/agarage edit [Garage ID] int [type] ");
			if (type <1 || type> 9) return SendErrorMessage (playerid, "Type 1 to 9.");
			if (GetInterior(playerid) || GetWorld(playerid))	return SendErrorMessage(playerid, "You must be outdoors. ");

			GarageInfo[id][garagePlayer_Exit][0] = garage_player_pos[type-1][0];
			GarageInfo[id][garagePlayer_Exit][1] = garage_player_pos[type-1][1];
			GarageInfo[id][garagePlayer_Exit][2] = garage_player_pos[type-1][2];
			GarageInfo[id][garageVeh_Exit][0] = garage_veh_pos[type-1][0];
			GarageInfo[id][garageVeh_Exit][1] = garage_veh_pos[type-1][1];
			GarageInfo[id][garageVeh_Exit][2] = garage_veh_pos[type-1][2];
			GarageInfo[id][garageVeh_Exit][3] = garage_veh_pos[type-1][3];
			GarageInfo[id][garageExitInt] = garage_int[type-1];
			SendAdmMessageToPlayer(playerid, "You have changed the interior of the garage [ID: %i] on %i.", id, type);

			SQL_SetFloat("garage", "player_exit_x", GarageInfo[id][garagePlayer_Exit][0], GarageInfo[id][garageID]);
			SQL_SetFloat("garage", "player_exit_y", GarageInfo[id][garagePlayer_Exit][1], GarageInfo[id][garageID]);
			SQL_SetFloat("garage", "player_exit_z", GarageInfo[id][garagePlayer_Exit][2], GarageInfo[id][garageID]);
			SQL_SetFloat("garage", "veh_exit_x", GarageInfo[id][garageVeh_Exit][0], GarageInfo[id][garageID]);
			SQL_SetFloat("garage", "veh_exit_y", GarageInfo[id][garageVeh_Exit][1], GarageInfo[id][garageID]);
			SQL_SetFloat("garage", "veh_exit_z", GarageInfo[id][garageVeh_Exit][2], GarageInfo[id][garageID]);
			SQL_SetFloat("garage", "veh_exit_fa", GarageInfo[id][garageVeh_Exit][3], GarageInfo[id][garageID]);
			SQL_SetInteger("garage", "exit_int", GarageInfo[id][garageExitInt], GarageInfo[id][garageID]);
			return 1;
		}
		else if (CompareStrings(parameters, "customint"))
		{
			new Float:x, Float:y, Float:z, Float:a;
			GetPlayerPos(playerid, x, y, z);
			GetPlayerFacingAngle(playerid, a);
			GarageInfo[id][garagePlayer_Exit][0] = x;
			GarageInfo[id][garagePlayer_Exit][1] = y;
			GarageInfo[id][garagePlayer_Exit][2] = z;
			GarageInfo[id][garageVeh_Exit][0] = x;
			GarageInfo[id][garageVeh_Exit][1] = y;
			GarageInfo[id][garageVeh_Exit][2] = z;
			GarageInfo[id][garageVeh_Exit][3] = a;
			GarageInfo[id][garageExitInt] = GetInterior(playerid);
			GarageInfo[id][garageExitVW] = GetWorld(playerid);
			SendAdmMessageToPlayer(playerid, "You have changed the interior of the garage [ID: %i]", id);

			SQL_SetFloat("garage", "player_exit_x", GarageInfo[id][garagePlayer_Exit][0], GarageInfo[id][garageID]);
			SQL_SetFloat("garage", "player_exit_y", GarageInfo[id][garagePlayer_Exit][1], GarageInfo[id][garageID]);
			SQL_SetFloat("garage", "player_exit_z", GarageInfo[id][garagePlayer_Exit][2], GarageInfo[id][garageID]);
			SQL_SetFloat("garage", "veh_exit_x", GarageInfo[id][garageVeh_Exit][0], GarageInfo[id][garageID]);
			SQL_SetFloat("garage", "veh_exit_y", GarageInfo[id][garageVeh_Exit][1], GarageInfo[id][garageID]);
			SQL_SetFloat("garage", "veh_exit_z", GarageInfo[id][garageVeh_Exit][2], GarageInfo[id][garageID]);
			SQL_SetFloat("garage", "veh_exit_fa", GarageInfo[id][garageVeh_Exit][3], GarageInfo[id][garageID]);
			SQL_SetInteger("garage", "exit_int", GarageInfo[id][garageExitInt], GarageInfo[id][garageID]);
			SQL_SetInteger("garage", "exit_vw", GarageInfo[id][garageExitVW], GarageInfo[id][garageID]);
			return 1;
		}
		else if (CompareStrings(parameters, "exitdoor"))
		{
			new Float:x, Float:y, Float:z, Float:a;
			GetPlayerPos(playerid, x, y, z);
			GetPlayerFacingAngle(playerid, a);
			GarageInfo[id][garagePlayer_Exit][0] = x;
			GarageInfo[id][garagePlayer_Exit][1] = y;
			GarageInfo[id][garagePlayer_Exit][2] = z;
			GarageInfo[id][garageExitInt] = GetInterior(playerid);
			GarageInfo[id][garageExitVW] = GetWorld(playerid);
			SendAdmMessageToPlayer(playerid, "You have changed the exit point of the garage [ID: %i]", id);

			SQL_SetFloat("garage", "player_exit_x", GarageInfo[id][garagePlayer_Exit][0], GarageInfo[id][garageID]);
			SQL_SetFloat("garage", "player_exit_y", GarageInfo[id][garagePlayer_Exit][1], GarageInfo[id][garageID]);
			SQL_SetFloat("garage", "player_exit_z", GarageInfo[id][garagePlayer_Exit][2], GarageInfo[id][garageID]);
			return 1;
		}

		else if (CompareStrings(parameters, "price"))
		{
			new price;

			if (sscanf(arg, "i", price))			return SendHelpMessage(playerid, "/agarage edit [ID garage] price [price]");
			if (price <= 0 || price > 1000000)	return SendErrorMessage(playerid, "Price from $1 to $1000000.");

			GarageInfo[id][garagePrice] = price;
			SQL_SetInteger("garage", "price", GarageInfo[id][garagePrice], GarageInfo[id][garageID]);
			SendAdmMessageToPlayer(playerid, "You have changed the cost of the garage [ID: %i] on $%i.", id, price);
			return 1;
		}

		else if (CompareStrings(parameters, "locked"))
		{
			new locked;

			if (sscanf(arg, "i", locked))	return SendHelpMessage(playerid, "/agarage edit [ID garage] locked [0 - open | 1 - close]");
			if (locked < 0 || locked > 1)	return SendErrorMessage(playerid, "Value from 0 to 1.");

			GarageInfo[id][garageLocked] = locked;
			SQL_SetInteger("garage", "locked", GarageInfo[id][garageLocked], GarageInfo[id][garageID]);
			SendAdmMessageToPlayer(playerid, "You %s garage [ID: %i].", (locked) ? ("lock") : ("unlock"));
			return 1;
		}

		else 
		{
			SendHelpMessage(playerid, "/agarage edit [ID garage] [options]");
			SendSyntaxMessage(playerid, "pos vehpos int price locked");
		}
	}

	else if (CompareStrings(option, "goto"))
	{
		new id;

		if (sscanf(secoption, "i", id))									return SendHelpMessage(playerid, "/agarage goto [ID garage]");
		if (id < 0 || id >= MAX_GARAGES || !GarageInfo[id][garageID])	return SendErrorMessage(playerid, "Garage not found.");

		SetPlayerPosEx(playerid, GarageInfo[id][garagePlayer_Enter][0], GarageInfo[id][garagePlayer_Enter][1], GarageInfo[id][garagePlayer_Enter][2]);
		SetInterior(playerid, GarageInfo[id][garageEnterInt]);
		SetWorld(playerid, GarageInfo[id][garageEnterVW]);
		return 1;
	}

	else if (CompareStrings(option, "createbiz"))
	{
		new type, id, price;

		if (sscanf(secoption, "iii", type, price, id))			return SendHelpMessage(playerid, "/agarage createbiz[type] [cost] [business ID] ");
		if (type <1 || type> 9) return SendErrorMessage (playerid, "Type 1 to 9.");
		if (price <= 0 || price> 1000000) return SendErrorMessage (playerid, "Price from $ 1 to $ 1000000.");
		if (id <0 || id>= MAX_BIZ ||! BizInfo [id] [bizID]) return SendErrorMessage (playerid, "Business not found.");
		if (Garage_Create(playerid, type, price, 2, id) == -1)	return SendErrorMessage(playerid, "The maximum number of garages has been reached.");

		return 1;
	}

	else if (CompareStrings(option, "createhouse"))
	{
		new type, id, price;
		
		if (sscanf(secoption, "iii", type, price, id))			return SendHelpMessage(playerid, "/agarage createhouse [a type] [cost] [ID houses]");
		if (type < 1 || type > 9)								return SendErrorMessage(playerid, "Type from 1 to 9.");
		if (price <= 0 || price > 1000000)						return SendErrorMessage(playerid, "Price from $ 1 to $100000.");
		if (id < 0 || id >= MAX_HOUSES || !HouseInfo[id][hID])	return SendErrorMessage(playerid, "House not found.");
		if (Garage_Create(playerid, type, price, 1, id) == -1)	return SendErrorMessage(playerid, "The maximum number of garages has been reached.");

		return 1;
	}

	else 
	{
		SendHelpMessage(playerid, "/agarage [options]");
		SendSyntaxMessage(playerid, "create/remove/edit/goto/createbiz/createhouse");
	}
	return 1;
}

CMD:changefight(playerid, params[]) //TO DO MOVE TO SETSTAT
{
	new pid;

	if (!CheckAdmin(playerid, HIGH_ADMIN_LEVEL)) return SendNotAdmin(playerid);
	if (sscanf(params, "u", pid)) 				return SendHelpMessage(playerid, "/changefight [ID/Ten]");
	if (!IsPlayerLogged(pid)) 					return SendNotConnected(playerid);
	
	SetPVarInt(playerid, "ChangeFightTo", pid);
	Dialog_Show(playerid, ChangeFight, DIALOG_STYLE_LIST, "{FFFFFF}Change fighting style","Normal\nBoxing\nKungFu\nKneeHead\nGrabKick\nElbow","Change","Cancel");
	return 1;
}

CMD:adminhide(playerid, params[])
{
	if (!CheckAdmin(playerid, HIGH_ADMIN_LEVEL))	return SendNotAdmin(playerid);

    PlayerInfo[playerid][pAdminHide] = (PlayerInfo[playerid][pAdminHide]) ? (0) : (1);
    SendAdmMessageToPlayer(playerid, "You %s yourself as an administrator.", (PlayerInfo[playerid][pAdminHide]) ? ("hide") : ("showed"));

	if (PlayerInfo[playerid][pAdminHide] && IsAdminDuty(playerid))		SetPlayerColor(playerid, TEAM_HIT_COLOR);
	else if (!PlayerInfo[playerid][pAdminHide] && IsAdminDuty(playerid))	SetPlayerColor(playerid, TEAM_ADMIN_COLOR);

	return 1;
}

ALTX:afoodstand("afood");
CMD:afoodstand(playerid, params[])
{
	if (!CheckAdmin(playerid, HIGH_ADMIN_LEVEL))	return SendNotAdmin(playerid);

	new option[16], secoption[128];

	if (sscanf(params, "s[16]S()[128]", option, secoption))
	{
		SendHelpMessage(playerid, "(/food)stand [options]");
		SendSyntaxMessage(playerid, "create/remove/goto");
		return 1;
	}

	if (CompareStrings(option, "create"))
	{
		new type;

		if (sscanf (secoption, "i", type)) return SendHelpMessage (playerid, "(/food) stand create [0 - without object | 1 - with object]");
		if (type <0 || type> 1) return SendErrorMessage (playerid, "Type 0 to 1.");
		if (IsPlayerInAnyVehicle (playerid)) return SendErrorMessage (playerid, "You must be out of the vehicle.");

		new standid = -1;

		for(new i; i < MAX_FOOD_STAND; i++)
		{
			if (FoodStand[i][fStandOn]) continue;

			standid = i;
			break;
		}

		if (standid == -1)	return SendErrorMessage(playerid, "The maximum number of food tents has been reached.");

		GetPlayerPos(playerid, FoodStand[standid][fPosX], FoodStand[standid][fPosY], FoodStand[standid][fPosZ]);
		
		FoodStand[standid][fPosRX] = 
		FoodStand[standid][fPosRY] = 
		FoodStand[standid][fPosRZ] = 0.0;
		FoodStand[standid][fVW] = GetWorld(playerid);
		FoodStand[standid][fInt] = GetInterior(playerid);
		FoodStand[standid][fType] = type;

		if (type)
		{
			FoodStand[standid][fObject] = CreateDynamicObject(1340, FoodStand[standid][fPosX], FoodStand[standid][fPosY], FoodStand[standid][fPosZ], 0.0, 0.0, 0.0, FoodStand[standid][fVW], FoodStand[standid][fInt], -1, 200.0);
		}

		//FoodStand[standid][fLabel] = CreateDynamic3DTextLabel(""EMBED_CYAN"/buyfood", -1, FoodStand[standid][fPosX] + 1.5, FoodStand[standid][fPosY], FoodStand[standid][fPosZ], 2.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, FoodStand[standid][fVW], FoodStand[standid][fInt], -1, 100.0);
		FoodStand[standid][fPickUp] = CreateDynamicPickup(1239, 1, FoodStand[standid][fPosX] + 1.5, FoodStand[standid][fPosY], FoodStand[standid][fPosZ], FoodStand[standid][fVW], FoodStand[standid][fInt], -1, 100.0);
		FoodStand[standid][fStandOn] = 1;
		AddFoodStandToFile(standid, FoodStand[standid][fType], FoodStand[standid][fPosX], FoodStand[standid][fPosY], FoodStand[standid][fPosZ], FoodStand[standid][fVW], FoodStand[standid][fInt]);
		SendAdmMessageToPlayer(playerid, "You created a food tent [ID: %i].", standid);
		return 1;
	}

	else if (CompareStrings(option, "remove"))
	{
		new standid;

		if (sscanf(secoption, "i", standid))											return SendHelpMessage(playerid, "(/food)stand remove [ID Tent]");
		if (standid < 0 || standid >= MAX_FOOD_STAND || !FoodStand[standid][fStandOn])	return SendErrorMessage(playerid,"Tent not found.");

		if (FoodStand[standid][fType] && IsValidDynamicObject(FoodStand[standid][fObject]))
		{
			DestroyDynamicObject(FoodStand[standid][fObject]);
			FoodStand[standid][fObject] = INVALID_OBJECT_ID;
		}

		/*if (IsValidDynamic3DTextLabel(FoodStand[standid][fLabel]))
		{
			DestroyDynamic3DTextLabel(FoodStand[standid][fLabel]);
			FoodStand[standid][fLabel] = Text3D:INVALID_3DTEXT_ID;
		}*/

		if (IsValidDynamicPickup(FoodStand[standid][fPickUp]))	DestroyDynamicPickup(FoodStand[standid][fPickUp]);

		new query[128];
		mysql_format(dbHandle, query, sizeof(query), "DELETE FROM `foodstand` WHERE `id` = %i", FoodStand[standid][fID]);
		mysql_tquery(dbHandle, query);

		FoodStand[standid][fStandOn] = 
		FoodStand[standid][fID] = 0;
		SendAdmMessageToPlayer(playerid, "Food tent [ID: %i] deleted.", standid);
		return 1;
	}

	else if (CompareStrings(option, "goto"))
	{
		new standid;

		if (sscanf(secoption, "i", standid))											return SendHelpMessage(playerid, "(/food)stand goto [ID tent]");
		if (standid < 0 || standid >= MAX_FOOD_STAND || !FoodStand[standid][fStandOn])	return SendErrorMessage(playerid, "No tent found. ");

		SetPlayerPosEx(playerid, FoodStand[standid][fPosX], FoodStand[standid][fPosY], FoodStand[standid][fPosZ]);
		SetWorld(playerid, FoodStand[standid][fVW]);
		SetInterior(playerid, FoodStand[standid][fInt]);
	}

	else 
	{
		SendHelpMessage(playerid, "(/food)stand [options]");
		SendSyntaxMessage(playerid, "create/remove/goto");
	}
	return 1;
}

CMD:ajob(playerid, params[])
{
	if (!CheckAdmin(playerid, HIGH_ADMIN_LEVEL))	return SendNotAdmin(playerid);

	new option[16], secoption[128];

	if (sscanf(params, "s[16]S()[128]", option, secoption))
	{
		SendHelpMessage(playerid, "/ajob [options]");
		SendSyntaxMessage(playerid, "create/remove/goto");
	}

	if (CompareStrings(option, "create"))
	{
		new type;

		if (sscanf(secoption, "i", type))
		{
			SendHelpMessage(playerid, "/ajob create [type of job]");
			SendSyntaxMessage(playerid, "1 - truck driver | 2 - mechanic | 3 - taxi driver | 6 - pizza delivery | 7 - car thief");
			SendSyntaxMessage(playerid, "8 - lumberjack | 9 - garbage truck | 10 - miner");
			return 1;
		}
		if (type < 0 || type > 10)			return SendErrorMessage(playerid, "Invalid job type specified.");
		if (IsPlayerInAnyVehicle (playerid)) return SendErrorMessage (playerid, "You must be out of the vehicle.");

		new jobid = -1;

		for(new i = 0; i < MAX_JOBS; i++)
		{
			if (JobsInfo[i][jobOn])	continue;

			jobid = i;
			continue;
		}

		if (jobid == -1)	return SendErrorMessage(playerid, "The maximum number of jobs has been reached. ");

		GetPlayerPos(playerid, JobsInfo[jobid][jobX], JobsInfo[jobid][jobY], JobsInfo[jobid][jobZ]);
		
		JobsInfo[jobid][jobVW] = GetWorld(playerid);
		JobsInfo[jobid][jobInt] = GetInterior(playerid);
		JobsInfo[jobid][jobType] = type;
		JobsInfo[jobid][jobOn] = 1;

		JobsInfo[jobid][jobPickUp] = CreateDynamicPickup(1314, 1, JobsInfo[jobid][jobX], JobsInfo[jobid][jobY], JobsInfo[jobid][jobZ], JobsInfo[jobid][jobVW], JobsInfo[jobid][jobInt], -1, 100.0);

		new jobtext[32];

		switch(type)
		{
			case JOB_MECHANIC:	jobtext = "Mechanic";
			case JOB_TRUCKER:	jobtext = "Trucker";
			case JOB_TAXI:		jobtext = "Taxi driver";
			case JOB_PIZZA:		jobtext = "Pizza delivery";
			case JOB_CARJACKER: jobtext = "Car thief";
		}

		AddJobToFile(jobid, JobsInfo[jobid][jobType], JobsInfo[jobid][jobX], JobsInfo[jobid][jobY], JobsInfo[jobid][jobZ], JobsInfo[jobid][jobInt], JobsInfo[jobid][jobVW]);
		SendAdmMessageToPlayer(playerid, "You have created a job %s [ID: %i].", jobtext, jobid);
		return 1;
	}

	else if (CompareStrings(option, "remove"))
	{
		new jobid;

		if (sscanf(secoption, "i", jobid))								return SendHelpMessage(playerid, "/ajob remove [ID work]");
		if (jobid < 0 || jobid >= MAX_JOBS || !JobsInfo[jobid][jobOn])	return SendErrorMessage(playerid, "Job not found.");

		if (IsValidDynamicPickup(JobsInfo[jobid][jobPickUp]))		DestroyDynamicPickup(JobsInfo[jobid][jobPickUp]);

		new query[128];
		mysql_format(dbHandle, query, sizeof(query), "DELETE FROM `jobs` WHERE `id` = %i", JobsInfo[jobid][jobID]);
		mysql_tquery(dbHandle, query);

		JobsInfo[jobid][jobID] = 
		JobsInfo[jobid][jobOn] = 0;
		SendAdmMessageToPlayer(playerid, "You deleted the job [ID: %i].", jobid);
		return 1;
	}

	else if (CompareStrings(option, "goto"))
	{
		new jobid;

		if (sscanf(secoption, "i", jobid))								return SendHelpMessage(playerid, "/ajob goto [ID work] ");
		if (jobid <0 || jobid>= MAX_JOBS ||! JobsInfo [jobid] [jobOn]) return SendErrorMessage (playerid, "Job not found.");

		SetPlayerPosEx(playerid, JobsInfo[jobid][jobX], JobsInfo[jobid][jobY], JobsInfo[jobid][jobZ]);
		SetInterior(playerid, JobsInfo[jobid][jobInt]);
		SetWorld(playerid, JobsInfo[jobid][jobVW]);
	}

	else 
	{
		SendHelpMessage(playerid, "/ajob [options]");
		SendSyntaxMessage(playerid, "create/remove/goto");
	}
	return 1;
}

ALTX:asc("/aspeedcam");
CMD:asc(playerid, params[])
{
	if (!CheckAdmin(playerid, HIGH_ADMIN_LEVEL))	return SendNotAdmin(playerid);

	new option[16], secoption[128];

	if (sscanf(params, "s[16]S()[128]", option, secoption))
	{
		SendHelpMessage(playerid, "/asc [options]");
		SendHelpMessage(playerid, "create remove edit list");
	}

	if (CompareStrings(option, "create"))
	{
		new sp_limit, sp_zone[64], id = SC_GetFreeID();
		if (id == -1)									return SendErrorMessage (playerid, "All camera slots are occupied.");
		if (sscanf(secoption, "d", sp_limit))			return SendHelpMessage (playerid, "/asc create [speed limit] ");
		if (sp_limit <= 0 || sp_limit> SC_MAX_SPEED)	return SendErrorMessage (playerid, "Speed ??limit from 1 to %d.", SC_MAX_SPEED);
		
        GetPlayerPos(playerid, speedcam[id][sc_x], speedcam[id][sc_y], speedcam[id][sc_z]);
        GetPlayer2DZone(playerid, sp_zone, sizeof(sp_zone));

		format(speedcam[id][sc_name], 64, "%s 12%i", sp_zone, id);

		new Float:x, Float:y, Float:z;
		GetPlayerPos(playerid, x, y, z); 

        speedcam[id][sc_speed] = sp_limit;
        speedcam[id][sc_x] = x;
        speedcam[id][sc_y] = y+1;
        speedcam[id][sc_z] = z;
		speedcam[id][sc_rx] = 0;
        speedcam[id][sc_ry] = 0;
        speedcam[id][sc_rz] = 0;
        speedcam[id][sc_int] = GetPlayerInterior(playerid);
        speedcam[id][sc_vw] = GetPlayerVirtualWorld(playerid);
        speedcam[id][sc_object] = CreateDynamicObject(18880, speedcam[id][sc_x], speedcam[id][sc_y], speedcam[id][sc_z], speedcam[id][sc_rx], speedcam[id][sc_ry], speedcam[id][sc_rz], speedcam[id][sc_vw], speedcam[id][sc_int]);

		speedcam[id][sc_areaid] = CreateDynamicSphere(speedcam[id][sc_x], speedcam[id][sc_y], speedcam[id][sc_z], SC_DEF_RADIUS, speedcam[id][sc_vw], speedcam[id][sc_int]);

		AddSpeedcamToFile(id, sp_limit, speedcam[id][sc_name], speedcam[id][sc_x], speedcam[id][sc_y], speedcam[id][sc_z], 0.0, 0.0, 0.0, speedcam[id][sc_int], speedcam[id][sc_vw]);
        SendAdmMessageToPlayer(playerid, "You have created a video capture camera [ID: %i] %s | Speed ??limit: %d.", id, speedcam[id][sc_name], sp_limit);
		return 1;
	}

	else if (CompareStrings(option, "remove"))
	{
		new sp_near = GetNearestSpeed(playerid, 20.0);
        
        if (sp_near == -1)                                   return SendErrorMessage(playerid, "There are no speed cameras in this radius.");

        if (IsValidDynamicObject(speedcam[sp_near][sc_object]))
        {
            DestroyDynamicObject(speedcam[sp_near][sc_object]);
            speedcam[sp_near][sc_object] = INVALID_OBJECT_ID;
        }

        new sql_query[128];

        SendAdmMessageToPlayer(playerid, "You have removed the SpeedCam [ID: %i | %s].", sp_near, speedcam[sp_near][sc_name]);

        speedcam[sp_near][sc_name] = EOS;
    
		
        mysql_format(dbHandle, sql_query, sizeof(sql_query), "DELETE FROM `speedcams` WHERE `id` = %i", sp_near);
        mysql_tquery(dbHandle, sql_query);
        return 1;
	}

	else if (CompareStrings(option, "edit"))
    {
        new sp_near = GetNearestSpeed(playerid, 15.0), thirdoption[64], fouroption[64];

        if (sp_near == -1)	return SendErrorMessage(playerid, "There are no speed cameras in this radius.");     

        if (sscanf(secoption, "s[64]S()[64]", thirdoption, fouroption))        
        {
            SendHelpMessage(playerid, "/sc edit [options]");
            SendHelpMessage(playerid, "pos limit");
            return 1;
        }
        else if (CompareStrings(thirdoption, "limit"))
        {
            new sp_limit;

            if (sscanf(fouroption, "d", sp_limit))           return SendHelpMessage(playerid, "/sc edit limit [speed limit]");
            if (sp_limit <= 0 || sp_limit > SC_MAX_SPEED) 	return SendErrorMessage(playerid, "Speed ??Limit from 1 to %d.", SC_MAX_SPEED);

            speedcam[sp_near][sc_speed] = sp_limit;
            SQL_SetInteger("speedcams", "speed", speedcam[sp_near][sc_speed], speedcam[sp_near][sc_id]);
            SendAdmMessageToPlayer(playerid, "You have changed the speed mode of the video capture camera [ID: %i] %s on %d.", sp_near, speedcam[sp_near][sc_name], sp_limit);
            return 1;
        }

        else if (CompareStrings(thirdoption, "pos"))
        {
            SetPVarInt(playerid, "SC:ID", sp_near + 1);
            SetPVarInt(playerid, "SC:Edit", 1);
            EditDynamicObject(playerid, speedcam[sp_near][sc_object]);
            return 1;
        }
    }

    else if (CompareStrings(option, "list"))
    {
		new dialog_header[96] = "{FFFFFF}SpeedCam\t{FFFFFF}SpeedCam ID\t{FFFFFF}Speed ??limit\n", dialog_body[3072];

		format(dialog_body, sizeof(dialog_body), "%s", dialog_header);

		for(new i; i < MAX_SPEEDCAMS; i++)
		{
			format(dialog_body, sizeof(dialog_body), "%s%s\t%i\t%d\n", dialog_body, speedcam[i][sc_name], i, speedcam[i][sc_speed]);
		}

		Dialog_Show(playerid, None, DIALOG_STYLE_TABLIST_HEADERS, "{FFFFFF}SpeedCam List", dialog_body, "Close", "");
    }  
	return 1;
}

CMD:acctv(playerid, params[])
{
	if (!CheckAdmin(playerid, HIGH_ADMIN_LEVEL))	return SendNotAdmin(playerid);
	
	new option[16], secoption[128];

	if (sscanf(params, "s[16]S()[128]", option, secoption)) return SendHelpMessage(playerid, "/acctv [create/remove/edit/list/repall/goto]");

	if (CompareStrings(option, "create"))
	{
		new name[32];

		if (sscanf(secoption, "s[32]", name))		return SendHelpMessage(playerid, "/acctv create[name]");
		if (strlen (name) <4 || strlen (name)> 30) return SendErrorMessage (playerid, "Camera name from 4 to 30 characters.");
		if (! CheckCCTVEquals (name)) return SendErrorMessage (playerid, "This camera name already exists.");

		new nearcam = GetNearestCamera(playerid, 5.0);

		if (nearcam!= -1) return SendErrorMessage (playerid, "The camera is already operating in this radius.");

		new id = -1;

		for(new i = 0; i < MAX_CCTV; i++)
		{
			if (CCTVInfo[i][tvObjectOn])	continue;

			id = i;
			break;
		}

		if (id == -1)	return SendErrorMessage(playerid, "The maximum number of CCTV has been reached.");
		format(CCTVInfo[id][tvName], 32, "%s", name);
		GetPlayerPos(playerid, CCTVInfo[id][tvPosX], CCTVInfo[id][tvPosY], CCTVInfo[id][tvPosZ]);

		CCTVInfo[id][tvPosRX] = 
		CCTVInfo[id][tvPosRY] = 
		CCTVInfo[id][tvPosRZ] = 0.0;
		CCTVInfo[id][tvInt] = GetInterior(playerid);
		CCTVInfo[id][tvVW] = GetWorld(playerid);
		CCTVInfo[id][tvObject] = CreateDynamicObject(1886, CCTVInfo[id][tvPosX], CCTVInfo[id][tvPosY], CCTVInfo[id][tvPosZ], 0.0, 0.0, 0.0, CCTVInfo[id][tvVW], CCTVInfo[id][tvInt]);
		CCTVInfo[id][tvCollision] = CreateDynamicObject(3800, CCTVInfo[id][tvPosX], CCTVInfo[id][tvPosY], CCTVInfo[id][tvPosZ]-1.0, CCTVInfo[id][tvPosRX], CCTVInfo[id][tvPosRY], CCTVInfo[id][tvPosRZ], CCTVInfo[id][tvVW], CCTVInfo[id][tvInt]);
		SetDynamicObjectMaterial(CCTVInfo[id][tvCollision], 0, 16644, "a51_detailstuff", "roucghstonebrtb", 0x00000000);
		CCTVInfo[id][tvObjectOn] = 1;
		AddCameraToFile(id, CCTVInfo[id][tvInt], CCTVInfo[id][tvVW], CCTVInfo[id][tvPosX], CCTVInfo[id][tvPosY], CCTVInfo[id][tvPosZ], 0.0, 0.0, 0.0, name);
		SendAdmMessageToPlayer(playerid, "You have created a camera %s [ID: %i].", CCTVInfo[id][tvName], id);
		return 1;
	}

	else if (CompareStrings(option, "remove"))
	{
		new id;

		if (sscanf(secoption, "i", id))								return SendHelpMessage(playerid, "/acctv remove [ID camera]");
		if (id < 0 || id >= MAX_CCTV || !CCTVInfo[id][tvObjectOn])	return SendErrorMessage(playerid, "CCTV not found.");

		new query[128];
		mysql_format(dbHandle, query, sizeof(query), "DELETE FROM `cctvs` WHERE `id` = %i", CCTVInfo[id][tvID]);
		mysql_tquery(dbHandle, query);

		if (IsValidDynamicObject(CCTVInfo[id][tvObject]))
		{
			DestroyDynamicObject(CCTVInfo[id][tvObject]);
			DestroyDynamicObject(CCTVInfo[id][tvCollision]);
			CCTVInfo[id][tvObject] = INVALID_OBJECT_ID;
			CCTVInfo[id][tvCollision] = INVALID_OBJECT_ID;
		}
		
		CCTVInfo[id][tvID] = 
		CCTVInfo[id][tvObjectOn] = 0;
		SendAdmMessageToPlayer(playerid, "You have removed the camera [ID: %i].", id);
		return 1;
	}

	else if (CompareStrings(option, "edit"))
	{
		new id, parameters[16], arg[112];

		if (sscanf(secoption, "is[16]S()[112]", id, parameters, arg)) return SendHelpMessage(playerid, "/acctv edit [ID CCTVs] [pos/name]");

		if (id < 0 || id >= MAX_CCTV || !CCTVInfo[id][tvObjectOn] || !IsValidDynamicObject(CCTVInfo[id][tvObjectOn]))	return SendErrorMessage (playerid, "CCTV not found.");

		if (CompareStrings(parameters, "pos"))
		{
			if (GetPVarInt(playerid, #edit_cctv))																			return SendErrorMessage(playerid, "You are already editing the CCTV.");
			if (!IsPlayerInRangeOfPoint(playerid, 5.0, CCTVInfo[id][tvPosX], CCTVInfo[id][tvPosY], CCTVInfo[id][tvPosZ]))	return SendErrorMessage(playerid, "You must be near the CCTV.");

			SetPVarInt(playerid, #edit_cctv, id + 1);
			EditDynamicObject(playerid, CCTVInfo[id][tvObject]);
			return 1;
		}

		else if (CompareStrings(parameters, "name"))
		{
			new name[32];

			if (sscanf(arg, "s[32]", name))				return SendHelpMessage(playerid, "/acctv edit [ID CCTVs] name [name]");
			if (strlen(name) < 4 || strlen(name) > 30)	return SendErrorMessage(playerid, "CCTV name from 4 to 30 characters. ");
			if (!CheckCCTVEquals(name))					return SendErrorMessage(playerid, "This CCTV name already exists.");

			format(CCTVInfo[id][tvName], 32, "%s", name);
			SQL_SetString("cctvs", "info", CCTVInfo[id][tvName], CCTVInfo[id][tvID]);
			SendAdmMessageToPlayer(playerid, "You have changed the name of the CCTV [ID: %i] on %s.", id, CCTVInfo[id][tvName]);
			return 1;
		}
	}
	
	else if (CompareStrings(option, "list"))
	{
		new dialog_header[96] = "{FFFFFF}CCTV name\t{FFFFFF}ID\tState\n", dialog_body[3072];

		format(dialog_body, sizeof(dialog_body), "%s", dialog_header);

		for(new i = 0; i < MAX_CCTV; i++)
		{
			if (!CCTVInfo[i][tvObjectOn]) continue;

			new break_str[24];

            if (CCTVInfo[i][tvBreak])    format(break_str, sizeof(break_str), "{CC0000}Offline");
            else                        format(break_str, sizeof(break_str), "{00B200}Online");

			format(dialog_body, sizeof(dialog_body), "%s%s\t%i\t%s\n", dialog_body, CCTVInfo[i][tvName], i, break_str);
		}

		Dialog_Show(playerid, None, DIALOG_STYLE_TABLIST_HEADERS, "{FFFFFF} CCTV list ", dialog_body, "Close", "");
		return 1;
	}

	else if (CompareStrings(option, "repall"))
	{
		for(new i = 0; i < MAX_CCTV; i++)
		{
			if (!CCTVInfo[i][tvObjectOn])                        continue;
        	if (!IsValidDynamicObject(CCTVInfo[i][tvObject])) continue;
			if (!CCTVInfo[i][tvBreak])							continue;

			SetCameraBreakState(i, 0);	
		}

		SendAdmMessageToPlayer(playerid,"You have repaired all CCTV CCTVs.");
	}

	else if (CompareStrings(option, "goto"))
	{
		new id;

		if (sscanf(secoption, "i", id))								return SendHelpMessage(playerid, "/acctv goto [ID cctv]");
		if (id < 0 || id > MAX_CCTV || !CCTVInfo[id][tvObjectOn])	return SendErrorMessage(playerid, "CCTV not found.");

		SetPlayerPosEx(playerid, CCTVInfo[id][tvPosX], CCTVInfo[id][tvPosY], CCTVInfo[id][tvPosZ]);
		SetWorld(playerid, CCTVInfo[id][tvVW]);
		SetInterior(playerid, CCTVInfo[id][tvInt]);
		return 1;
	}
	
	else SendHelpMessage(playerid, "/acctv [create/remove/edit/list/repall/goto]");
	
	return 1;
}

CMD:aatm(playerid, params[])
{
	if (!CheckAdmin(playerid, HIGH_ADMIN_LEVEL))	return SendNotAdmin(playerid);

	new option[16], secoption[128];
	
	if (sscanf(params, "s[16]S()[128]", option, secoption)) return SendHelpMessage(playerid, "/aatm [create/remove/edit/goto]");

	if (CompareStrings(option, "create"))
	{
		new id = -1;

		for(new i; i < MAX_ATMS; i++)
		{
			if (ATMInfo[i][atmID]) continue;

			id = i;
			break;
		}

		if (id == -1)	return SendErrorMessage (playerid, "The maximum number of ATMs has been reached.");

		new Float:x, Float:y, Float:z, Float:angle;

		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, angle);

		x += 1.0 * floatsin(-angle, degrees);
		y += 1.0 * floatcos(-angle, degrees);

		ATMInfo[id][atmPosX] = x;
		ATMInfo[id][atmPosY] = y;
		ATMInfo[id][atmPosZ] = z - 0.4;
		ATMInfo[id][atmPosRZ] = angle;
		ATMInfo[id][atmInt] = GetInterior(playerid);
		ATMInfo[id][atmVW] = GetWorld(playerid);
		ATMInfo[id][atmObject] = CreateDynamicObject(2942, ATMInfo[id][atmPosX], ATMInfo[id][atmPosY], ATMInfo[id][atmPosZ], 0.0, 0.0, ATMInfo[id][atmPosRZ], ATMInfo[id][atmVW], ATMInfo[id][atmInt]);
		
		SetPVarInt(playerid, #edit_atm, id + 1);
		EditDynamicObject(playerid, ATMInfo[id][atmObject]);

		AddATMToFile(id, ATMInfo[id][atmPosX], ATMInfo[id][atmPosY], ATMInfo[id][atmPosZ], ATMInfo[id][atmPosRZ], ATMInfo[id][atmInt], ATMInfo[id][atmVW]);
		SendAdmMessageToPlayer(playerid, "You have created an ATM [ID: %i].", id);
		return 1;
	}

	else if (CompareStrings(option, "remove"))
	{
		new id;
		
		if (sscanf(secoption, "i", id))							return SendHelpMessage(playerid, "/aatm remove [ID ATM]");
		if (id < 0 || id >= MAX_ATMS || !ATMInfo[id][atmID])	return SendErrorMessage(playerid, "ATM not found.");

		if (IsValidDynamicObject(ATMInfo[id][atmObject]))
		{
			DestroyDynamicObject(ATMInfo[id][atmObject]);
			ATMInfo[id][atmObject] = INVALID_OBJECT_ID;
		}

		new query[128];
		mysql_format(dbHandle, query, sizeof(query), "DELETE FROM `atms` WHERE `id` = %i", ATMInfo[id][atmID]);
		mysql_tquery(dbHandle, query);

		ATMInfo[id][atmID] = 0;
		SendAdmMessageToPlayer(playerid, "You removed the ATM [ID: %i].", id);
		return 1;
	}

	else if (CompareStrings(option, "edit"))
	{
		new id;

		if (sscanf(secoption, "d", id))						return SendHelpMessage(playerid, "/aatm edit [ID ATM]");
		if (id < 0 || id > MAX_ATMS || !ATMInfo[id][atmID])	return SendErrorMessage (playerid, "ATM not found.");
		if (ATM_Nearest (playerid)!= id) 					return SendErrorMessage (playerid, "You must be near the ATM.");

		SetPVarInt(playerid, #edit_atm, id + 1);
		EditDynamicObject(playerid, ATMInfo[id][atmObject]);
		return 1;
	}

	else if (CompareStrings(option, "goto"))
	{
		new id;

		if (sscanf(secoption, "i", id))						return SendHelpMessage(playerid, "/aatm goto [ATM ID] ");
		if (id < 0 || id > MAX_ATMS || !ATMInfo[id][atmID])	return SendErrorMessage(playerid, "ATM not found. ");

		SetPlayerPosEx(playerid, ATMInfo[id][atmPosX], ATMInfo[id][atmPosY], ATMInfo[id][atmPosZ]);
		SetWorld(playerid, ATMInfo[id][atmVW]);
		SetInterior(playerid, ATMInfo[id][atmInt]);
		return 1;
	}
	
	else
	{
		SendHelpMessage(playerid, "/aatm [create/remove/edit/goto]");
	}
	return 1;
}

CMD:agate(playerid, params[])
{
	new option[16], secoption[128], modelid, faction, gateid, Float:o_rad, toption;

	if (!CheckAdmin(playerid, HIGH_ADMIN_LEVEL)) return SendNotAdmin(playerid);
	if (sscanf(params, "s[16]S()[128]", option, secoption))
	{
		SendHelpMessage(playerid, "/agate [create/remove/edit/goto]");
		return 1;
	}

	if (CompareStrings(option, "create"))
	{
		if (sscanf(secoption, "ii", modelid, faction)) 	return SendHelpMessage(playerid, "/agate create [ID object] [ID factions (/afaction list)]");
		if (faction < 0 || faction > MAX_FACTIONS-1) 	return SendErrorMessage(playerid, "A fraction with this ID was not found.");

		new gate = -1;
		for(new i; i < MAX_GATES; i++)
		{
			if (Gates[i][gateID] != 0 || Gates[i][gateObjectOn] != 0) continue;
			gate = i;
			break;
		}

		if (gate == -1) return SendErrorMessage(playerid, "The maximum number of gates has been reached.");

		GetPlayerPos(playerid, Gates[gate][gatePosX], Gates[gate][gatePosY], Gates[gate][gatePosZ]);
		GetPlayerPos(playerid, Gates[gate][gateMoveX], Gates[gate][gateMoveY], Gates[gate][gateMoveZ]);

		Gates[gate][gateObject] = CreateDynamicObject(modelid, Gates[gate][gatePosX], Gates[gate][gatePosY], Gates[gate][gatePosZ], 0.0, 0.0, 0.0, GetWorld(playerid), GetInterior(playerid), -1, 200.0);

		if (Gates[gate][gateObject] == INVALID_OBJECT_ID) return SendErrorMessage(playerid,"The object was not created.");

		Gates[gate][gateSpeed] = 0.5;
		Gates[gate][gateRadius] = 5.0;
		Gates[gate][gateModel] = modelid;
		Gates[gate][gateMoveRX] = 
		Gates[gate][gateMoveRY] = 
		Gates[gate][gateMoveRZ] = 
		Gates[gate][gatePosRX] = 
		Gates[gate][gatePosRY] = 
		Gates[gate][gatePosRZ] = 0.0;
		Gates[gate][gateInt] = GetInterior(playerid);
		Gates[gate][gateVW] = GetWorld(playerid);
		Gates[gate][gateSound] = 0;
		Gates[gate][gateFaction] = faction;
		Gates[gate][gateOpened] = 0;
		Gates[gate][gateObjectOn] = 1;

		AddGateToFile(gate, modelid, faction, GetInterior(playerid), GetWorld(playerid), Gates[gate][gatePosX], Gates[gate][gatePosY], Gates[gate][gatePosZ]);
		SendAdmMessageToPlayer(playerid, "Gate [ID: %i] created.", gate);
		return 1;
	}

	else if (CompareStrings(option, "remove"))
	{
		if (sscanf(secoption, "i", gateid)) return SendHelpMessage(playerid, "/agate remove [Gate ID]");
		if (!Gates[gateid][gateObjectOn])	return SendErrorMessage(playerid, "No gate with this ID was found.");

		new query[128];

		mysql_format(dbHandle, query, sizeof(query), "DELETE FROM `gates` WHERE `id`= %i", Gates[gateid][gateID]);
		mysql_tquery(dbHandle, query, "OnGateRemove", "i", gateid);

		if (IsValidDynamicObject(Gates[gateid][gateObject])) DestroyDynamicObject(Gates[gateid][gateObject]);

		Gates[gateid][gatePosX] = 
		Gates[gateid][gatePosY] = 
		Gates[gateid][gatePosZ] = 
		Gates[gateid][gatePosRX] =
		Gates[gateid][gatePosRY] = 
		Gates[gateid][gatePosRZ] = 
		Gates[gateid][gateSpeed] = 
		Gates[gateid][gateRadius] =
		Gates[gateid][gateMoveX] = 
		Gates[gateid][gateMoveY] = 
		Gates[gateid][gateMoveZ] = 
		Gates[gateid][gateMoveRX] = 
		Gates[gateid][gateMoveRY] =
		Gates[gateid][gateMoveRZ] = 0.0;
		Gates[gateid][gateObjectOn] = 
		Gates[gateid][gateInt] = 
		Gates[gateid][gateFaction] = 
		Gates[gateid][gateOpened] = 
		Gates[gateid][gateVW] = 
		Gates[gateid][gateID] = 0;

		SendAdmMessageToPlayer(playerid, "You removed the gate [ID: %i].", gateid);
		return 1;
	}

	else if (CompareStrings(option, "edit"))
	{
		new parameters[16], arg[112];

		if (sscanf(secoption, "s[16]S()[5]", parameters, arg))
		{
			SendHelpMessage(playerid, "/agate edit [pos/move/speed/radius/sound]");
			return 1;
		}

		if (CompareStrings(parameters, "pos"))
		{
			if (sscanf(arg, "i", gateid)) 															return SendHelpMessage(playerid, "/agate edit pos [Gate ID]");
			if (gateid < 0 || gateid >= MAX_GATES || !Gates[gateid][gateObjectOn]) 					return SendErrorMessage(playerid, "No gate found.");
			if (GetPVarInt(playerid, #2_edit_gate) != 0 || GetPVarInt(playerid, #edit_gate) != 0) 	return SendErrorMessage(playerid, "You are already editing the object.");

			SetPVarInt(playerid, #edit_gate, gateid+1);
			EditDynamicObject(playerid, Gates[gateid][gateObject]);
			return 1;

		}

		else if (CompareStrings(parameters, "move"))
		{
			if (sscanf(arg, "i", gateid)) 															return SendHelpMessage(playerid, "/agate edit move [Gate ID]");
			if (gateid < 0 || gateid >= MAX_GATES || !Gates[gateid][gateObjectOn])					return SendErrorMessage(playerid, "No gate found.");
			if (GetPVarInt(playerid, #2_edit_gate) != 0 || GetPVarInt(playerid, #edit_gate) != 0) 	return SendErrorMessage(playerid, "You are already editing the object. ");

			SetPVarInt(playerid, #2_edit_gate, gateid+1);
			EditDynamicObject(playerid, Gates[gateid][gateObject]);
			return 1;
		}

		else if (CompareStrings(parameters, "speed"))
		{
			if (sscanf(arg, "if", gateid, o_rad)) 									return SendHelpMessage(playerid, "/agate edit speed [Gate ID] [speed (0.1 - 255.0)]");
			if (gateid < 0 || gateid >= MAX_GATES || !Gates[gateid][gateObjectOn]) 	return SendErrorMessage(playerid, "No gate found.");
			if (o_rad < 0.1 || o_rad > 255.0) 										return SendErrorMessage(playerid, "Movement speed from 0.1 to 255.0.");

			Gates[gateid][gateSpeed] = o_rad;
			SQL_SetFloat("gates", "speed", Gates[gateid][gateSpeed], Gates[gateid][gateID]);
			SendAdmMessageToPlayer(playerid, "You have changed the speed of the gate [ID: %i] on %.2f", gateid, o_rad);
			return 1;
		}

		else if (CompareStrings(parameters, "radius"))
		{
			if (sscanf(arg, "if", gateid, o_rad)) 									return SendHelpMessage(playerid, "/agate edit radius [Gate ID] [radius of action (0.1 - 30.0)] ");
			if (gateid < 0 || gateid >= MAX_GATES || !Gates[gateid][gateObjectOn])	return SendErrorMessage(playerid, "No gate found.");
			if (o_rad < 0.1 || o_rad > 30.0)										return SendErrorMessage (playerid, "Range from 0.1 to 30.0.");

			Gates[gateid][gateRadius] = o_rad;
			SQL_SetFloat("gates", "radius", Gates[gateid][gateRadius], Gates[gateid][gateID]);
			SendAdmMessageToPlayer(playerid, "You have changed the radius of the gate [ID: %i] on %.2f", gateid, o_rad);
			return 1;
		}

		else if (CompareStrings(parameters, "sound"))
		{
			if (sscanf(arg, "ii", gateid, toption))									return SendHelpMessage(playerid, "/agate edit sound [Gate ID][Sound ID | 0 - remove sound] ");
			if (gateid < 0 || gateid >= MAX_GATES || !Gates[gateid][gateObjectOn]) 	return SendErrorMessage(playerid, "No gate found.");
			if (toption < 0)														return SendErrorMessage(playerid, "Sound not found.");

			Gates[gateid][gateSound] = toption;
			SQL_SetInteger("gates", "sound", Gates[gateid][gateSound], Gates[gateid][gateID]);
			SendAdmMessageToPlayer(playerid, "You have changed the sound of the gate [ID: %i] on %d.", gateid, toption);
			return 1;
		}

		else 
		{
			SendHelpMessage(playerid, "/agate edit [pos/move/speed/radius/sound]");
		}
		return 1;
	}

	else if (CompareStrings(option, "goto"))
	{
		if (sscanf(secoption, "i", gateid)) 									return SendHelpMessage(playerid, "/agate goto [Gate ID]");
		if (gateid < 0 || gateid >= MAX_GATES || !Gates[gateid][gateObjectOn])	return SendErrorMessage(playerid, "No gate found.");

		SetPlayerPosEx(playerid, Gates[gateid][gatePosX], Gates[gateid][gatePosY], Gates[gateid][gatePosZ]);
		SetWorld(playerid, Gates[gateid][gateVW]);
		SetInterior(playerid, Gates[gateid][gateInt]);
		return 1;	
	}

	else 
	{
		SendHelpMessage(playerid, "/agate [options]");
		SendSyntaxMessage(playerid, "create/remove/edit/goto");
	}
	return 1;
}

CMD:astreet(playerid, params[])
{
	if (!CheckAdmin(playerid, HIGH_ADMIN_LEVEL))	return SendNotAdmin(playerid);

	new option[5], secoption[5];
	if (sscanf(params, "s[7]S()[5]", option, secoption)) return SendHelpMessage(playerid, "/astreet [add/edit/remove/goto]");

	if (CompareStrings(option, "add")) {
		if (!GetPlayerVirtualWorld(playerid) && !GetPlayerInterior(playerid)) {
			new Float:x, Float:y, Float:z;
			GetPlayerPos(playerid, x, y, z);

			x += 1.0;

			/*pTemp[playerid][editPos][0] = x;
			pTemp[playerid][editPos][1] = y;
			pTemp[playerid][editPos][2] = z;

			pTemp[playerid][editPos][3] = x;
			pTemp[playerid][editPos][4] = y;
			pTemp[playerid][editPos][5] = z;*/

			//GetGroupCenter(pTemp[playerid][editPos][3], pTemp[playerid][editPos][4], pTemp[playerid][editPos][5]);
			SetPVarInt(playerid, #edit_street, 1);

			new Street_Sign = CreateDynamicObject(19981, x, y, z, 0.0, 0.0, 0.0, -1, -1, -1, 300.00, 300.00);
			EditDynamicObject(playerid, Street_Sign);
		}
	}
	else if (CompareStrings(option, "edit")) {
		new id;
		if (sscanf(secoption,"i", id)) 	return SendHelpMessage(playerid, "/astreet edit [id]");
		if (!street_data[id][street_id])	return SendErrorMessage(playerid, "Invalid ID. (( /near ))");
		if (GetPlayerDistanceFromPoint(playerid, street_data[id][sSign][0], street_data[id][sSign][1], street_data[id][sSign][2]) > 5.0)
			return SendErrorMessage(playerid, "You are too far from the sign!");

		SetPVarInt(playerid, #edit_street, 2);
		SetPVarInt(playerid, #id_street, id);

		EditDynamicObject(playerid, street_data[id][street_object][0]);
	}
	else if (CompareStrings(option, "remove")) {
		new id;
		if (sscanf(secoption,"i", id))	return SendHelpMessage(playerid, "/astreet remove [id]");
		if (!street_data[id][street_id])	return SendErrorMessage(playerid, "Invalid ID. (( /near ))");

		DeleteStreet(playerid, id);
	}
	else if (CompareStrings(option, "goto")) {
		new id;
		if (sscanf(secoption,"i", id))	return SendHelpMessage(playerid, "/astreet goto [id]");
		if (!street_data[id][street_id])	return SendErrorMessage(playerid, "Invalid ID. (( /near ))");

		SetPlayerPosEx(playerid, street_data[id][sSign][0],street_data[id][sSign][1],street_data[id][sSign][2]);
	}
	return 1;
}

CMD:stname(playerid, params[])
{
	if (!CheckAdmin(playerid, HIGH_ADMIN_LEVEL))	return SendNotAdmin(playerid);
	
	new id;
	if (sscanf(params,"i", id)) 		return SendHelpMessage(playerid, "/stname [id]");
	if (!street_data[id][street_id])	return SendErrorMessage(playerid, "Invalid ID. (( /near ))");
	if (GetPlayerDistanceFromPoint(playerid, street_data[id][sSign][0], street_data[id][sSign][1], street_data[id][sSign][2]) > 5.0)
		return SendErrorMessage(playerid, "You are too far from the sign!");

	SetPVarInt(playerid, #edit_street, 3);
	EditDynamicObject(playerid, street_data[id][street_object][1]); //Name
	return 1;
}

CMD:stdir(playerid, params[])
{
	if (!CheckAdmin(playerid, HIGH_ADMIN_LEVEL))	return SendNotAdmin(playerid);

	new id;
	if (sscanf(params,"i", id)) 		return SendHelpMessage(playerid, "/stdir [id]");
	if (!street_data[id][street_id])	return SendErrorMessage(playerid, "Invalid ID. (( /near ))");
	if (GetPlayerDistanceFromPoint(playerid, street_data[id][sSign][0], street_data[id][sSign][1], street_data[id][sSign][2]) > 5.0)
		return SendErrorMessage(playerid, "You are too far from the sign!");

	SetPVarInt(playerid, #edit_street, 3);
	EditDynamicObject(playerid, street_data[id][street_object][2]); //sDirection
	return 1; 
}

CMD:getareas(playerid, params[])
{
	if (!CheckAdmin(playerid, HIGH_ADMIN_LEVEL))	return SendNotAdmin(playerid);
	
	new areas[10], j = GetPlayerNumberDynamicAreas(playerid);
	GetPlayerDynamicAreas(playerid, areas, sizeof(areas));

	for(new s; s < 10; s ++) {
		for(new i; i < sizeof(street_names); i++) {
			if (IsValidDynamicArea(areas[s]) && areas[s] == street_zones[i]) {
				SM1(playerid, "[%i] %i. %s", s, i, street_names[i]);
			}
		}
	}

	SM2(playerid, "-------TOTAL: %i-------", j);
	return 1;
}

ALTX:abillboard("/abb");
CMD:abillboard(playerid, params[])
{
	if (!CheckAdmin(playerid, HIGH_ADMIN_LEVEL)) return SendNotAdmin(playerid);
	
	new option[16], secoption[128];

	if (sscanf(params, "s[16]S()[7]", option, secoption))
	{
		SendHelpMessage(playerid, "/abillboard [create/delete/edit/goto]");
		return 1;
	}

	if (CompareStrings(option, "create"))
	{
        new bb = GetUnusedBillBoard();
	    if (bb == -1) return SendErrorMessage(playerid, "Billboards limit exceeded!");
		
		if (strval(secoption) <= 0) return SendHelpMessage(playerid, "/abb create [price]");

		SetPVarInt(playerid, #BB_COST, strval(secoption));
		new List:billobj = list_new();
		AddModelMenuItem(billobj, 7302);
		AddModelMenuItem(billobj, 9314);
		ShowModelSelectionMenu(playerid, "Billboards", MODEL_SELECTION_BB, billobj);
	}
	if (CompareStrings(option, "remove"))
	{
		new id;
		if (sscanf(secoption, "I(-1)", id)) return SendHelpMessage(playerid, "/abb remove {c7c7c7}[ID billboard]");
		
		if (id == -1) {
			if ((id = GetClosestBillBoard(playerid, 15.0)) == -1) return SendErrorMessage(playerid, "There is no billboard next to you!");
		}
		
		if (id >= MAX_BILLBOARDS || id < 0)	return SendErrorMessage(playerid, "Invalid ID.");
		if (!BillboardInfo[id][bbActive])	return SendErrorMessage(playerid, "Invalid ID.");

		SendAdmMessageToPlayer(playerid, "You have successfully removed the billboard #%i!", id+1);
		DeleteBillBoard(id);
	}
	if (CompareStrings(option, "edit"))
	{
		new id;
		if (sscanf(secoption, "I(-1)", id)) return SendHelpMessage(playerid, "/abb edit {c7c7c7}[ID billboard]");
		
		if (id == -1) {
			if ((id = GetClosestBillBoard(playerid, 15.0)) == -1) return SendErrorMessage(playerid, "There is no billboard next to you!");
		}
		
		if (id >= MAX_BILLBOARDS || id < 0)	return SendErrorMessage(playerid, "Invalid ID.");
		if (!BillboardInfo[id][bbActive])	return SendErrorMessage(playerid, "Invalid ID.");

		SetPVarInt(playerid, "BB:Edit", id+1);
		EditDynamicObject(playerid, BillboardInfo[id][bbObject]);
	}
	if (CompareStrings(option, "goto"))
	{
		new id;
		if (sscanf(secoption, "i", id)) return SendHelpMessage(playerid, "/abb goto {c7c7c7}[ID billboard]");
		
		if (id >= MAX_BILLBOARDS || id < 0)	return SendErrorMessage(playerid, "Invalid ID.");
		if (!BillboardInfo[id][bbActive])	return SendErrorMessage(playerid, "Invalid ID.");

		SetPlayerPosEx(playerid, BillboardInfo[id][bbPosX], BillboardInfo[id][bbPosY], BillboardInfo[id][bbPosZ]);
		SetInterior(playerid, BillboardInfo[id][bbInt]);
		SetWorld(playerid, BillboardInfo[id][bbVW]);
	} 
	else SendHelpMessage(playerid, "/abillboard [create/remove/edit/goto]");

	return 1;
}

