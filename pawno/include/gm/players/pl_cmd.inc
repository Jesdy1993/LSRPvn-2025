ALTX:setspawn("/spawnpoint");
CMD:setspawn(playerid, params[])
{
	new type;

	if (sscanf(params,"d",type))	return SendHelpMessage(playerid, "/setspawn [0 - xuat hien chuan, 1 - nha o, 2 - to chuc, 3 - loi ra cuoi cung] ");
	if (type > 3 || type < 0)		return SendHelpMessage(playerid, "/setspawn [0 - xuat hien chuan, 1 - nha o, 2 - to chuc, 3 - loi ra cuoi cung]");

	if (type == 0)
	{
	    Dialog_Show(playerid, SelectSpawn, DIALOG_STYLE_LIST, "{8D8DFF}Chon vi tri xuat hien "," Palomino Creek \nMontgomery \nDillimore \nFort Carson ", "Chon", "Huy bo");
		return 1;
	}
	else if (type == 1)
	{
        Dialog_Show(playerid, ChangeHouseSpawn, DIALOG_STYLE_INPUT, "{"COL_TITLE"}[Chon mot ngoi nha]", "Nhap ID cua ngoi nha ban muon xuat hien. Ban co the tim ra ID ngoi nha bang cach su dung /property.", "Chon","Huy bo");
	}
	else if (type == 2)
	{
		if (!PlayerInfo[playerid][pFaction])	return SendErrorMessage(playerid, "Ban khong phai la thanh vien cua mot to chuc.");

		SendSyntaxMessage(playerid, "Bay gio ban se xuat hien trong to chuc.");
		PlayerInfo[playerid][pSpawnType] = 2;
	}
	else if (type == 3)
	{
		SendSyntaxMessage(playerid, "Bay gio ban se xuat hien o vi tri cuoi cung. ");
		PlayerInfo[playerid][pSpawnType] = 3;
	}

	SQL_SetInteger("users", "spawntype", PlayerInfo[playerid][pSpawnType], PlayerInfo[playerid][pID]);
	return 1;
}

ALTX:location("/street");
CMD:location(playerid, params[])
{
	new location[MAX_ZONE_NAME],
		Float:x, Float:y, Float:z;

	GetPlayerPos(playerid, x, y, z);
	GetZone(x, y, location, MAX_ZONE_NAME);

	if (IsPlayerInAnyDynamicArea(playerid)) 
	{
		new areas[5], street_area[2], j = GetPlayerNumberDynamicAreas(playerid);
		GetPlayerDynamicAreas(playerid, areas, sizeof(areas));

		if (GetStreet(areas, j, street_area)) 
		{
			if (street_area[1] == -1)
				return SendSpecialMessage(playerid, "%s, %s.", location, street_names[street_area[0]]);
			else
				return SendSpecialMessage(playerid, "%s, o giao lo %s va %s.", location, street_names[street_area[0]],street_names[street_area[1]]);
		}
	}

	SendSpecialMessage(playerid, "%s.", location);
	return 1;
}

ALTX:address("/adres", "/adress", "addres");
CMD:address(playerid, params[])
{
	new houseid;
	if (sscanf(params,"d", houseid)) 			return SendHelpMessage(playerid, "/address [House ID]");
	if (houseid < 0 || houseid >= MAX_HOUSES)	return SendErrorMessage(playerid,"Khong co ngoi nha duoc tim thay");
	if (!HouseInfo[houseid][hID])				return SendErrorMessage(playerid, "Khong tim thay dia chi nay.");
	
	if (HouseInfo[houseid][hApart])	Waypoint_Set(playerid, ApartInfo[HouseInfo[houseid][hApart]][aPosX], ApartInfo[HouseInfo[houseid][hApart]][aPosY], ApartInfo[HouseInfo[houseid][hApart]][aPosZ]);
	else 							Waypoint_Set(playerid, HouseInfo[houseid][hPosX], HouseInfo[houseid][hPosY], HouseInfo[houseid][hPosZ]);
			
	SendSyntaxMessage(playerid, "Ngoi nha (%s) duoc danh dau tren GPS. (/removecp)", (!HouseInfo[houseid][hApart])?(GetHouseZone(houseid)):(GetApartmentZone(HouseInfo[houseid][hApart])));
	return 1;
}
ALTX:pay("/duatien", "/chotien");
CMD:pay(playerid, params[])
{
    if (PlayerInfo[playerid][pInjured] != 0 || GetPVarInt(playerid, "Freeze") || pTemp[playerid][pTaserTime] || pTemp[playerid][pCuffed]) 
		return SendErrorMessage(playerid, "Ban khong the su dung chuc nang nay ngay bay gio.");
		
	new userid, amount;
 
	if (sscanf(params,"ud", userid, amount))				return SendHelpMessage(playerid, "/duatien [ID/Ten] [so tien]");
	if (userid == playerid)								return 1;
	if (PlayerInfo[playerid][pHours] < 2)				return SendErrorMessage(playerid, "Ban co so gio choi duoi 2 gio tren may chu. Chuc nang nay khong kha dung.");
	if (GetPVarInt(playerid, #just_paid) > gettime())	return SendErrorMessage(playerid, "Doi 2 giay. ");
	if (!IsPlayerLogged(userid))							return SendNotConnected(playerid);
	if (amount > GetCash(playerid) || amount <= 0)		return SendNotCash(playerid);
	if (!PlayerNearPlayer(3.0, playerid, userid))		return SendNotNearPlayer(playerid);

	SetPVarInt(playerid, #just_paid, gettime() + 2);

	new money1 = PlayerInfo[playerid][pCash], money2 = PlayerInfo[userid][pCash];

	GiveCash(playerid, -amount);
	GiveCash(userid, amount);
	PlaySound(playerid, 1052);
	PlaySound(userid, 1052);
	SendSyntaxMessage(playerid, "Ban da dua $%i cho %s [ID:%i].", amount, GetNameWithMask(userid), userid);
	SendSyntaxMessage(userid, "Ban nhan duoc $%i tu %s [ID:%i].", amount, GetNameWithMask(playerid), playerid);
	SendAdmMessage("%s (ID: %i) chuyen cho %s (ID: %i) $%i", GetNameEx(playerid), playerid, GetNameEx(userid), userid, amount);

	new mes[256];
	format(mes, 128, "lay tien ra va dua no cho %s.", GetNameWithMask(userid));
	cmd::me(playerid, mes);

    format(mes, sizeof(mes), "%s [MYSQL: %i | IP: %s | Money(WAS): %i | Money(BECOME): %i] transferred money %s [MYSQL: %i | IP: %s | Money(WAS): %i | Money(BECOME): %i] -- $%i", 
	GetName(playerid), PlayerInfo[playerid][pID], q_GetPlayerIP(playerid), money1, GetCash(playerid), GetName(userid), PlayerInfo[userid][pID], q_GetPlayerIP(userid), money2, GetCash(userid), amount);
    insert_log(mes, MONEY_LOG, 1, playerid);
	return 1;
}

CMD:licenses(playerid, params[])
{
	new userid;
	if (sscanf(params,"u", userid))	return SendHelpMessage(playerid, "/licenses [ID/Ten]");
	if (userid == playerid)
	{
		cmd::server_ame(playerid, "nhin vao ID Card cua anh ay.");
		ShowLicenses(playerid, playerid);
		return 1;
	}
	
	if (!IsPlayerLogged(userid))						return SendNotConnected(playerid);
	if (!PlayerNearPlayer(8.0, playerid, userid))	return SendNotNearPlayer(playerid);

	new mes[128];
	format(mes, sizeof(mes), "hien thi ID card cho %s.", GetNameWithMask(userid));
	SetPlayerChatBubble(playerid, mes, COLOR_PURPLE, 20.0, 4000);
	ShowLicenses(playerid, userid);
	return 1;
}

CMD:id(playerid, params[])
{
	if (isnull(params))		return SendHelpMessage(playerid, "/id [ID/Ten]");
	if (isNumeric(params))
	{
	    new userid = strval(params);
	    if (!IsPlayerLogged(userid))	return SendErrorMessage(playerid, "Tim kiem khong co ket qua.");
		
	    SendClientMessageEx(playerid, COLOR_GREY, "[ID: %i] %s [%s]", userid, GetNameEx(userid), GetAccName(userid));
	    return 1;
	}

	new count;
	foreach(new i : Player)
	{
	    if (!IsPlayerLogged(i) || strfind(GetName(i), params, true) == -1) continue;
	        
        SendClientMessageEx(playerid, COLOR_GREY, "[ID: %i] %s [%s]", i, GetNameEx(i), GetAccName(i));
        count = 1;
	}
	
	if (!count) SendErrorMessage(playerid, "Tim kiem khong co ket qua.");
	return 1;
}

CMD:admins(playerid, params[])
{
	if (!CheckAdmin(playerid, ADMIN_LEVEL_1))	return SendNotAdmin(playerid);
	SCM(playerid, COLOR_WHITE, "|_______DANH SACH QUAN TRI VIEN:______|");

	foreach(new i : Player)
	{
		if(PlayerInfo[i][pAdmin] > 0)
		{
			new admin[12];
			
			if (PlayerInfo[i][pAdmin] == DEVELOPER_LEVEL)
			{
				admin = "Developer";
			}		
			else if (PlayerInfo[i][pAdmin] == HIGH_ADMIN_LEVEL)
		 	{
				 admin = "Lead Admin";
			} 	
			else
			{
				format(admin, sizeof(admin), "Quan tri %i", PlayerInfo[i][pAdmin]);
			}												
			if (!IsAdminDuty(i))
			{
				SendClientMessageEx(playerid, COLOR_LIGHTRED, " * {C7C7C7}%s | %s (%s) [ID: %i]", admin, GetAccName(i), GetNameEx(i), i);
			}	
			else
			{
				SendClientMessageEx(playerid, COLOR_GREEN2, " * {FFFFFF}%s | %s (%s) [ID: %i] (Hoat dong)", admin, GetAccName(i), GetNameEx(i), i);
			}				
		}
		else if (PlayerInfo[i][pHelper] > 0) 
		{
			if (!IsTesterDuty(i))
			{
				SendClientMessageEx(playerid, COLOR_LIGHTRED, " * {C7C7C7}Tester | %s [ID: %i] [%s]", GetNameEx(i), i, GetAccName(i));
			}	
			else
			{
				SendClientMessageEx(playerid, COLOR_GREEN2, " * {FFFFFF}Tester | %s [ID:%i] [%s] (Hoat dong)", GetNameEx(i), i, GetAccName(i));
			}					
		}
	}
	return 1;
}

CMD:testers(playerid, params[])
{
	SCM(playerid, COLOR_WHITE, "|_______DANH SACH HO TRO:______|");
	foreach(new i : Player)
	{
		if (!IsPlayerLogged(i) || PlayerInfo[i][pHelper] < 1) continue;

        if (!IsTesterDuty(i))	SendClientMessageEx(playerid, COLOR_LIGHTRED, " * {C7C7C7}Tester | %s [ID: %i] [%s]", GetNameEx(i), i, GetAccName(i));
		else					SendClientMessageEx(playerid, COLOR_GREEN2, " * {FFFFFF}Tester | %s [ID:%i] [%s] (Hoat dong)", GetNameEx(i), i, GetAccName(i));
	}
	return 1;
}

CMD:blockpm(playerid, params[])
{
    if (PlayerInfo[playerid][pPremium] < 1) return SendErrorMessage(playerid, "Tinh nang nay chi co san cho cac tai khoan tra phi.");
	
	new userid;

	if (sscanf(params,"u", userid))	return SendHelpMessage(playerid, "/blockpm [ID/Ten]");
	if (userid == playerid)			return 1;
	if (!IsPlayerLogged(userid)) 	return SendNotConnected(playerid);

    if (people_blocking[playerid][userid] == 1)
    {
		SendSyntaxMessage(playerid, "Ban da loai bo %s [ID: %i] khoi danh sach den PM.", GetNameEx(userid), userid);
		people_blocking[playerid][userid] = 0;
		return 1;
	}

    SendSyntaxMessage(playerid, "Ban da them %s [ID: %i] vao danh sach den PM.", GetNameEx(userid), userid);
	people_blocking[playerid][userid] = 1;
	return 1;
}

CMD:blocklist(playerid, params[])
{
	if (PlayerInfo[playerid][pPremium] < 1) return SendErrorMessage(playerid, "Tinh nang nay chi co san cho cac tai khoan tra phi.");

	SCM(playerid, COLOR_LIGHTRED, "|______DANH SACH DEN "ProjectName"______|");
	foreach(new i : Player)
	{
		if (people_blocking[playerid][i] == 0) continue;

		SendClientMessageEx(playerid, COLOR_INFO, "[ID: %i] %s", i, GetNameEx(i));
	}
	return 1;
}

CMD:time(playerid, params[])
{
	new hour, minute, mes[128];

	gettime(hour,minute);
	format(mes, sizeof(mes), "~w~%02d:%02d~n~Lanh luong: %02i phut", hour, minute, 60 - PlayerInfo[playerid][pPayDayTime]);

	if (PlayerInfo[playerid][pMutedTime] > 0)	format(mes, sizeof(mes), "%s~n~~r~Thoi gian tat tieng con lai: %i", mes, PlayerInfo[playerid][pMutedTime]);

	if (PlayerInfo[playerid][pJailed] == PALOMINO_JAIL) //|| PlayerInfo[playerid][pJailed] == LSPD_JAIL || PlayerInfo[playerid][pJailed] == SASD_JAIL)
	{
		format(mes, sizeof(mes), "~y~Thoi gian tu con lai: %i~n~%s", PlayerInfo[playerid][pJailTime], mes);
		GameTextForPlayer(playerid, mes, 5000, 1);
		ApplyAnimation(playerid,"COP_AMBIENT","Coplook_watch",4.1,0,0,0,0,0,1);
		return 1;
	}
	else if (PlayerInfo[playerid][pIsolateTime] != 0)
	{
		format(mes, sizeof(mes), "~y~Co lap thoi gian con lai: %i~n~%s", PlayerInfo[playerid][pIsolateTime], mes);
		GameTextForPlayer(playerid, mes, 5000, 1);
		ApplyAnimation(playerid,"COP_AMBIENT","Coplook_watch",4.1,0,0,0,0,0,1);
		return 1;
	}
	else if (PlayerInfo[playerid][pJailed] == PRISON_JAIL)
	{
		format(mes, sizeof(mes), "~y~Thoi gian trong tu con lai: %i~n~%s", PlayerInfo[playerid][pJailTime], mes);
		GameTextForPlayer(playerid, mes, 5000, 1);
		ApplyAnimation(playerid,"COP_AMBIENT","Coplook_watch",4.1,0,0,0,0,0,1);
		return 1;
	}
	else
	{
		GameTextForPlayer(playerid, mes, 5000, 1);
		cmd::server_ame(playerid, "nhin vao chiec dong ho.");
		
		if (GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)	ApplyAnimation(playerid,"COP_AMBIENT","Coplook_watch",4.1,0,0,0,0,0,1);
	}
	return 1;
}

CMD:coin(playerid, params[])
{
	SendNearbyMessage(Range_Normal, playerid, COLOR_WHITE, "* %s tung dong xu va roi ra %s.", GetNameWithMask(playerid), (random(2) == 0)?("dau"):("duoi"));
	return 1;
}

CMD:dice(playerid, params[])
{
	if (!IsPlayerHasItem(playerid, INV_DICE))	return SendErrorMessage(playerid, "Ban khong co xuc xac.");

	SendNearbyMessage(Range_Normal, playerid, COLOR_WHITE, "* %s tung mot cuc xuc xac va ra con so %i.", GetNameWithMask(playerid), random(6)+1);
	return 1;
}

CMD:mask(playerid, params[])
{
	new nametag[246];
	if (!IsPlayerHasItem(playerid, INV_MASK))	return SendErrorMessage(playerid, "Ban khong co mot cai mat na.");
	if (PlayerInfo[playerid][pOnDuty])			return SendErrorMessage(playerid, "Ban khong the deo mat na khi dang lam nhiem vu!");

	if (!maskOn{playerid})
	{
		//RemoveInvItem(playerid, INV_MASK, 1);
	    cmd::server_ame(playerid, "* Deo mot cai mat na. ");
		GameTextForPlayer(playerid, "~w~BAN DA ~g~DEO ~w~MAT NA", 4000, 4);
		maskOn{playerid} = true;
		//ShowPlayerName(playerid, false);
  		DestroyDynamic3DTextLabel(CustomNametag[playerid]);
		cmd::server_ame(playerid, "* Deo mot cai mat na.");
		format(PlayerInfo[playerid][pMaskname], 32, "Mask_%i", randomEx(100000, 999999));
		cNametag[playerid] = CreateDynamic3DTextLabel(PlayerInfo[playerid][pMaskname], 0xFFFFFFFF, 0.0, 0.0, 0.1, NT_DISTANCE, .attachedplayer = playerid, .testlos = 1);
	}
	else
	{
		//GiveInvItem(playerid, INV_MASK, 1);
	    cmd::server_ame(playerid, "* Go mot cai mat na. ");
		GameTextForPlayer(playerid, "~w~BAN DA ~r~GO ~w~MAT NA", 4000, 4);
		format(nametag, sizeof(nametag), "%s [%i]", GetNameEx(playerid), playerid);
		CustomNametag[playerid] = CreateDynamic3DTextLabel("", -1, 0.0, 0.0, 0.0, 15.0, .attachedplayer = playerid, .testlos = 1);
		RemovePlayerMask(playerid);
	}
	return 1;
}

CMD:isafk(playerid, params[])
{
	new id;
	
	if (sscanf(params, "u", id))	return SendHelpMessage(playerid, "/isafk [ID/Ten]");
	if (!IsPlayerLogged(id))		return SendNotConnected(playerid);

	if (IsPlayerAFK(id))	SendClientMessageEx(playerid, COLOR_LIGHTRED, "[ ! ] Nguoi choi %s [ID: %i] dang AFK trong %i giay.", GetNameEx(id), id, pTemp[id][pDarkAFK]-2);
	else				SendClientMessageEx(playerid, COLOR_LIGHTRED, "[ ! ] Nguoi choi %s [ID: %i] khong AFK.", GetNameEx(id), id);
	return 1;
}

CMD:showprescribe(playerid, params[])
{
    if (PlayerInfo[playerid][pPrescribe] < gettime())	return SendErrorMessage(playerid, "Ban khong co don thuoc can sa y te. ");

    new userid;

	if (sscanf(params,"u",userid))					return SendHelpMessage(playerid, "/showprescribe [ID/Ten]");
	if (!IsPlayerLogged(userid))					return SendNotConnected(playerid);
	if (!PlayerNearPlayer(3.0, playerid, userid))	return SendNotNearPlayer(playerid);
		
    SCM(userid, COLOR_GREEN, "__________Cong thuc__________");
	SendClientMessageEx(userid, COLOR_WHITE, "Cap cho: %s Ngay sinh: %s", GetNameEx(playerid), PlayerInfo[playerid][pBirthdate]);
	SendClientMessage(userid, COLOR_WHITE, "Noi cap: Benh vien Da khoa All Saints.");
	SendClientMessage(userid, COLOR_WHITE, "Ke don de mua, luu tru va su dung can sa y te. ");
	SCM(userid, COLOR_GREEN, "_________________________________");
	
	new mes[128];
	format(mes, sizeof(mes), "cho %s thay cong thuc.", GetNameWithMask(userid));
	SetPlayerChatBubble(playerid, mes, COLOR_PURPLE, 20.0, 4000);
	return 1;
}
ALTX:stats("/thongtin");
CMD:stats(playerid, params[])
{
	ShowStats(playerid, playerid);
	return 1;
}

CMD:charity(playerid, params[])
{
	new amount;

	if (sscanf(params,"d",amount))					return SendHelpMessage(playerid, "/charity [so tien]");
	if (amount > GetCash(playerid) || amount <= 0)	return SendNotCash(playerid);

	PlaySound(playerid, 1052);
	SendSyntaxMessage(playerid, "Ban da tu thien $%i.", amount);
	AMSG(COLOR_LIGHTRED, "Warning: %s tu thien (/charity) $%i.", GetNameEx(playerid), amount);

	new money = PlayerInfo[playerid][pCash];
	GiveCash(playerid, -amount);

	new mes[256];
	format(mes, sizeof(mes), "%s [MYSQL: %i | IP: %s | Money(BEFORE): %i | Money(AFTER): %i] leaked (/charity) -- $%i", GetName(playerid), PlayerInfo[playerid][pID], q_GetPlayerIP(playerid), money, GetCash(playerid), amount);
    insert_log(mes, MONEY_LOG, 5, PlayerInfo[playerid][pAccID]);
	return 1;
}

CMD:myprisonnumber(playerid, params[])
{
	if (PlayerInfo[playerid][pJailed] != PRISON_JAIL)	return SendErrorMessage(playerid, "Ban khong o trong tu.");

	SendClientMessageEx(playerid, COLOR_GRAD2, "Ten: %s | So nha tu: %s%i", GetNameEx(playerid), (PlayerInfo[playerid][pIsolateTime] != 0)?("B"):("A"),PlayerInfo[playerid][pPrisoned]+100);
	return 1;
}

CMD:helpme(playerid, params[])
{
	if (isnull(params))	return SendHelpMessage(playerid, "/helpme [van ban cau hoi]");

	SendSyntaxMessage(playerid, "Thong diep cua ban da duoc gui den nguoi kiem tra! Vui long doi cau tra loi cho cau hoi cua ban.");

    if (strlen(params) > MAXLEN)
	{
		new pos = MAXLEN;

		if (pos < MAXLEN-1) pos = MAXLEN;

		foreach(new i : Player)
		{
			if (!IsPlayerLogged(i) || (!CheckAdminNoDuty(i, ADMIN_LEVEL_1) && !IsTester(i)) || (PlayerInfo[i][pSettings] & togService))	continue;

			SendClientMessageEx(i, 0x00CC99AA, "[CAU HOI] %s [ID: %i]: %.*s ...", GetNameEx(playerid), playerid, pos, params);
			SendClientMessageEx(i, 0x00CC99AA, "... %s", params[pos]);		
		}
	}
	else
	{
	    foreach(new i : Player)
		{
			if (!IsPlayerLogged(i) || (!CheckAdminNoDuty(i, ADMIN_LEVEL_1) && !IsTester(i)) || (PlayerInfo[i][pSettings] & togService))	continue;

			SendClientMessageEx(i, 0x00CC99AA, "[CAU HOI] %s [ID: %i]: %s", GetNameEx(playerid), playerid, params);
		}
	}
	return 1;
}

CMD:report(playerid, params[])
{
	if (isnull(params))								return SendHelpMessage(playerid, "/report [van ban khieu nai]");
	if (pTemp[playerid][pReportTime] > gettime())	return SendSpecialMessage(playerid, "Ban co the ghi mot bao cao nua trong %i giay nua.", pTemp[playerid][pReportTime] - gettime());

    pTemp[playerid][pReportTime] = gettime() + 60;
	SendSyntaxMessage(playerid, "Khieu nai cua ban da duoc chuyen den ban quan tri may chu, hay cho phan hoi.");

    if (strlen(params) > MAXLEN)
	{
		new pos = MAXLEN;

		if (pos < MAXLEN-1) pos = MAXLEN;

		foreach(new i : Player)
		{
		    if (!IsPlayerLogged(i) || !CheckAdminNoDuty(i, ADMIN_LEVEL_1) || (PlayerInfo[i][pSettings] & togService)) continue;

			SendClientMessageEx(i, COLOR_YELLOWG, "[BAO CAO] %s [ID: %i]: %.*s ...", GetNameEx(playerid), playerid, pos, params);
			SendClientMessageEx(i, COLOR_YELLOWG, "... %s", params[pos]);
		}
	}
	else
	{
	    foreach(new i : Player)
		{
		    if (!IsPlayerLogged(i) || !CheckAdminNoDuty(i, ADMIN_LEVEL_1) || (PlayerInfo[i][pSettings] & togService)) continue;

			SendClientMessageEx(i, COLOR_YELLOWG, "[BAO CAO] %s [ID: %i]: %s", GetNameEx(playerid), playerid, params);
		}
	}
	return 1;
}

CMD:request(playerid, params[])
{
	if (isnull(params)) 				return SendHelpMessage(playerid, "/request [van ban yeu cau]");
	if (request_time > gettime())	return SendSpecialMessage(playerid, "Doi %i giay.", request_time - gettime());

	request_time = gettime() + 60;
	SendSyntaxMessage(playerid, "Yeu cau cua ban da duoc chuyen den ban quan tri may chu. Hay cho cau tra loi. ");
	
	if (strlen(params) > MAXLEN)
	{
		new pos = MAXLEN;

		if (pos < MAXLEN-1) pos = MAXLEN;

		foreach(new i : Player)
		{
			if (!IsPlayerLogged(i) || !CheckAdminNoDuty(i, ADMIN_LEVEL_1) || (PlayerInfo[i][pSettings] & togService)) continue;

			SendClientMessageEx(i, 0x00CC99AA, "[TRO GIUP] %s (ID: %i): %.*s ...", GetNameEx(playerid), playerid, pos, params);
			SendClientMessageEx(i, 0x00CC99AA, "... %s", params[pos]);
		}
	}
 	else
	{
	    foreach(new i : Player)
		{
		    if (!IsPlayerLogged(i) || !CheckAdminNoDuty(i, ADMIN_LEVEL_1) || (PlayerInfo[i][pSettings] & togService)) continue;

			SendClientMessageEx(i, 0x00CC99AA, "[TRO GIUP] %s (ID: %i) yeu cau su tro giup: %s", GetNameEx(playerid), playerid, params);
		}
	}
	return 1;
}

CMD:sell(playerid, params[])
{
	new bizid;

	if ((bizid = GetNearInsideBiz(playerid)) != -1)
	{
		if (BizInfo[bizid][bizType] == BIZ_PAWN)
		{
			Dialog_Show(playerid, SellPawn, DIALOG_STYLE_LIST, "Pawnshop", "Ban radio", "Ban", "Huy bo");
		}
	}
	return 1;
}

ALTX:buy("/mua");
CMD:buy(playerid, params[])
{
	new string[1024], bizid = -1;

	if ((bizid = GetNearInsideBiz(playerid)) != -1)
	{
	    if (BizInfo[bizid][bizType] == BIZ_BUILD)
	    {
	        Dialog_Show(playerid, BuyInterior, DIALOG_STYLE_INPUT, "{FFFFFF}Dat hang noi that", "{FFFFFF}Nhap ID cua ngoi nha ban muon thay doi noi that: \nNgoi nha nay phai thuoc ve ban! ( /property )", ">>>", "Dong");
	    }

		if (BizInfo[bizid][bizType] == BIZ_PAWN)
		{
			SendHelpMessage(playerid, "/sell.");
		}
	    else if (BizInfo[bizid][bizType] == BIZ_STORE || BizInfo[bizid][bizType] == BIZ_PHARMACY || BizInfo[bizid][bizType] == BIZ_BAR) //4
	    {
			new type; 
			switch(BizInfo[bizid][bizType])
			{
				case BIZ_STORE: type = 4;		
				case BIZ_BAR: type = 5;			
				case BIZ_PHARMACY: type = 6;	 
			} 
			if (!type)	return SendErrorMessage(playerid, "Loi he thong! (pl_cmd.inc:493)"); //return 1;

			new diatxt[LIMIT_MAX_PRODUCTS*128];

			for(new i = 0; i < max_product[type]; i++)
			{
				format(diatxt, sizeof(diatxt), "%s%i(0.0, 0.0, 63.0, 0.8)\t~w~%s~n~~g~~h~$%i\n", diatxt, model_order[type][i], name_order[type][i], BizInfo[bizid][bizProductPrice][i]);
			}

			new title[32+23];
			format(title, sizeof(title), "%s____-____Chon san pham", BizInfo[bizid][bizName]);

			Dialog_Show(playerid, StoreDialog, DIALOG_STYLE_PREVIEW_MODEL, title, diatxt, "Mua", "Huy bo");
	    }
	    else if (BizInfo[bizid][bizType] == BIZ_BARBER)
	    {
	        if (GetPVarInt(playerid, #buy_attach))	return SendErrorMessage(playerid, "Ket thuc hoat dong hien tai.");
			if (GetNextToySlot(playerid) == -1)		return SendWarningMessage(playerid, "Tat ca cac vi tri quan ao da duoc su dung.");

			for(new x; x < sizeof(BarberShop); x++)
			{
				format(string, sizeof(string), "%s%s - $%i\n", string, BarberShop[x][toyName], BarberShop[x][toyPrice]);
			}

			Dialog_Show(playerid, BarberDialog, DIALOG_STYLE_LIST, "{FFFFFF}Chon san pham", string, "Chon", "Dong");
		}
		else if (BizInfo[bizid][bizType] == BIZ_PIZZA || BizInfo[bizid][bizType] == BIZ_CLUCKIN || BizInfo[bizid][bizType] == BIZ_BURGER || BizInfo[bizid][bizType] == BIZ_DONUT)
		{
			for(new i; i != 4; i++)
			{
			    TextDrawShowForPlayer(playerid, TD_restaurant[i]);
			}

			new mes[128], type = BizInfo[bizid][bizType] - BIZ_PIZZA;

			for(new i; i != max_product[type]; i++)
			{
			    format(mes, sizeof(mes), "%s~n~~r~Suc khoe: +%i~n~~r~Loai bo con doi~n~~p~Gia: $%i~n~", name_order[type][i], 30 + (i * 10), BizInfo[bizid][bizProductPrice][i]);
				PlayerTextDrawSetString(playerid, TD_restaurant_prod[playerid][i], mes);
				PlayerTextDrawShow(playerid, TD_restaurant_prod[playerid][i]);
	            PlayerTextDrawSetPreviewModel(playerid, TD_restaurant_prod[playerid][i + 4], model_order[type][i]);
	            PlayerTextDrawShow(playerid, TD_restaurant_prod[playerid][i + 4]);
			}

			SelectTextDraw(playerid, 0x00cb77FF);
			SetPVarInt(playerid, #restaurant, 1);
		}
		else if (BizInfo[bizid][bizType] == BIZ_PHONES) // ������� ��������
		{
			new phonebuy_names[9][16] = {"Den","Xanh", "Do", "Xanh la", "Cam", "Xanh dam", "Xanh la dam", "Hong", "Vang"};

			new diatxt[sizeof(phone_model)*128];

			for(new i = 0; i < sizeof(phone_model); i++)
			{
				format(diatxt, sizeof(diatxt), "%s%i(180.0, 45.0, 0.0, 0.8)\t%s dien thoai~n~~g~~h~$1000\n", diatxt, phone_model[i], phonebuy_names[i]);
			}

			

			Dialog_Show(playerid, ComputerStore, DIALOG_STYLE_PREVIEW_MODEL, "Chon dien thoai", diatxt, "Chon", "Dong");
		}
		else if (BizInfo[bizid][bizType] == BIZ_AMMO) // ������� ������
		{
			cmd::buygun(playerid, "");
		}
		else if (pTemp[playerid][pBizEntered] != -1 && BizInfo[pTemp[playerid][pBizEntered]][bizType] == BIZ_BARBER)
		{
			if (GetPVarInt(playerid, #buy_attach))	return SendErrorMessage(playerid, "Ket thuc hoat dong hien tai.");
			if (GetNextToySlot(playerid) == -1)		return SendErrorMessage(playerid, "Tat ca cac vi tri quan ao da duoc su dung.");

			for(new x; x < sizeof(BarberShop); x++)
			{
				format(string, sizeof(string), "%s%s - $%i\n", string, BarberShop[x][toyName], BarberShop[x][toyPrice]);
			}
			Dialog_Show(playerid, BarberDialog, DIALOG_STYLE_LIST, "{FFFFFF}Chon san pham ", string, "Chon", "Dong");
		}
		else if (BizInfo[bizid][bizType] == BIZ_ATTACH)
		{
			if (GetPVarInt(playerid, #buy_attach))	return SendErrorMessage(playerid, "Ket thuc hoat dong hien tai.");
			if (GetNextToySlot(playerid) == -1)		return SendErrorMessage(playerid, "Tat ca cac vi tri quan ao da duoc su dung.");
			
			Dialog_Show(playerid, BizAttachDialog, DIALOG_STYLE_LIST, "{FFFFFF}Chon mot doanh muc", "1. Nhac cu\n2. Dong ho\n3. Cong cu\n4. Thiet bi the thao\n5. Phu kien", "Chon", "Dong");
		}
	}
	
	return 1;
}

CMD:buyclothes(playerid, params[])
{
    if (PlayerInfo[playerid][pOnDuty])	return SendErrorMessage(playerid, "Ban phai ngoai gio lam viec.");
	new id;

	if ((id = GetNearInsideBiz(playerid)) == -1)	return SendErrorMessage(playerid, "Ban khong o trong cua hang quan ao");
	if (BizInfo[id][bizType] != BIZ_CLOTHES)		return SendErrorMessage(playerid, "Ban khong o trong cua hang quan ao");
	if (GetCash(playerid) < 100)					return SendErrorMessage(playerid, "Ban khong du tien. ($ 100)");

	if (PlayerInfo[playerid][pSex] == 1)	
	{
		//new mes[sizeof(male_skins)*16];
		new List:skins = list_new();
		for(new i = 0; i < sizeof(male_skins); i++)
		{
			//format(mes, sizeof(mes), "%s%i\tID: %i\n", mes, male_skins[i], male_skins[i]); 
			AddModelMenuItem(skins, male_skins[i]);
			
		}
		ShowModelSelectionMenu(playerid, "Lua chon trang phuc Nam", SKIN_MALES, skins);	
		//Dialog_Show(playerid, MODEL_SEL_BUYCLOTHES, DIALOG_STYLE_PREVIEW_MODEL, "Buying clothes:", mes, "Chon", "Dong");
	}
	else
	{
		new List:skins = list_new();
		for(new i = 0; i < sizeof(female_skins); i++)
		{
			//format(mes, sizeof(mes), "%s%i\tID: %i\n", mes, male_skins[i], male_skins[i]); 
			AddModelMenuItem(skins, female_skins[i]);
		}
		ShowModelSelectionMenu(playerid, "Lua chon trang phuc Nu", SKIN_FEMALES, skins);	
	}
	return 1;
}

CMD:fire(playerid, params[])
{
	if (!FireOnline() || !PoliceOnline())	return SendErrorMessage(playerid,"It nhat phai co %i canh sat va %i linh cuu hoa trong gio lam viec!", NEED_COPS_TO_CRIME, NEED_FIRE_TO_CRIME);

	if (!IsPlayerHasItem(playerid, INV_LIGHTER)) return SendErrorMessage(playerid, "Ban khong co bat lua.");
	if (!IsPlayerHasItem(playerid, INV_GASCAN))  return SendErrorMessage(playerid, "Ban khong co mot binh xang.");
	if (pTemp[playerid][pFireTime] > 0)			return SendErrorMessage(playerid, "Ban dang thap lua.");

	new type = GetNearBuilding(playerid, 0.0, 2.0), building;
	switch(type) 
	{
		case 0: 
		{
			building = GetNearOutsideHouse(playerid);
			if (building == -1 || HouseInfo[building][hFireTimer] != 0) return SendErrorMessage(playerid, "Thu lai sau!");
		}
		case 1: 
		{
			building = GetNearOutsideGarage(playerid);
			if (building == -1 || BizInfo[building][bFireTimer] != 0) return SendErrorMessage(playerid,"Thu lai sau!");
		}
		case 2: 
		{ 
			building = GetNearOutsideBiz(playerid);
			if (building == -1 || GarageInfo[building][gFireTimer] != 0) return SendErrorMessage(playerid, "Thu lai sau!");
		}

		default: return SendErrorMessage(playerid, "Di den loi vao cua toa nha.");
	}

	if (building == -1) return SendErrorMessage(playerid, "Di den loi vao cua toa nha.");

	pTemp[playerid][pFireTime] = 30;
	SetPVarInt(playerid, #firetype, type);
	SetPVarInt(playerid, #firebuildID, building);

	SendSyntaxMessage(playerid, "Ban da bat dau dot lua. Su dung {FF6347}/stop{FFFFFF} neu ban muon hoan tac hanh dong.");

	RemovePlayerItem(playerid, INV_GASCAN, 1);

	SavePlayerPos(playerid);
	FreezePlayer(playerid);
	ApplyAnimation(playerid,"BOMBER","BOM_Plant_Loop", 4.0, 1, 0, 0, 0, 0, 0);
	return 1;
}

CMD:offclothes(playerid, params[])
{
	new	race;

	if (PlayerInfo[playerid][pOnDuty])	return SendErrorMessage(playerid, "Ban khong nen trong gio lam viec. ");

	if (PlayerInfo[playerid][pSkin] != GetPlayerSkin(playerid)) 
	{
	    if (!PlayerInfo[playerid][pSkin]) return SendErrorMessage(playerid, "Ban khong the tra lai quan ao vi ban khong co chung.. ");

	    SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
	    SendSyntaxMessage(playerid, "Ban da nhan lai quan ao cua ban.");
	    return 1;
	}

	if (sscanf(params, "d", race))	return SendHelpMessage(playerid, "/offclothes [1-2] [1-den / 2-trang]");
	if (race < 1 || race > 2)		return SendErrorMessage(playerid, "Loai: 1-den / 2-trang ");

    switch (PlayerInfo[playerid][pSex])
   	{
  		case 1:
  		{
			switch(race)
			{
			    case 1: SendSyntaxMessage(playerid, "Ban da coi bo quan ao cua ban"), SetPlayerSkin(playerid, 18);
			    case 2:
				{
				    switch(random(3))
				    {
				        case 0: SetPlayerSkin(playerid, 45);
				        case 1: SetPlayerSkin(playerid, 97);
				        case 2: SetPlayerSkin(playerid, 154);
				    }
					SendSyntaxMessage(playerid, "Ban da coi bo quan ao cua ban");
				}
			}
		}
		case 2:
		{
			switch(race)
			{
			    case 1: SendSyntaxMessage(playerid, "Ban da coi bo quan ao cua ban"), SetPlayerSkin(playerid, 139);
			    case 2:
				{
				    switch(random(3))
				    {
				        case 0: SetPlayerSkin(playerid, 251);
				        case 1: SetPlayerSkin(playerid, 140);
				        case 2: SetPlayerSkin(playerid, 138);
				    }
					SendSyntaxMessage(playerid, "Ban da coi bo quan ao cua ban");
				}
			}
		}
  	}
	return 1;
}

CMD:setstyle(playerid, params[])
{
	new option, secoption;

	if (sscanf(params,"iI(-1)", option, secoption))	return SendHelpMessage(playerid, "/setstyle (1 - Walking style(/walk) | 2 - Conversation style | 3 - Combat style | 4 - Speedometer style)");

	if (option == 1)
	{
		new style;

		if (sscanf(params,"{d}d",style))			return SendHelpMessage(playerid, "/setstyle 1 [Walking style (0-17)]");
		if (style < 0 || style > 17)				return SendErrorMessage(playerid, "Phong cach di chi tu 0 - 17.");

		PlayerInfo[playerid][pWalk] = style;
		
		if (!style)		SendSyntaxMessage(playerid, "Ban da vo hieu hoa kieu dang di cua minh.");
		else			SendSyntaxMessage(playerid, "Kieu dang di da thay doi thanh %i.", style);

		return 1;
	}
	else if (option == 2)
	{
		new style;

		if (sscanf(params,"{d}d",style))		return SendHelpMessage(playerid, "/setstyle [Conversation style (0-9)]");
		if (style < 0 || style > 9)				return SendErrorMessage(playerid, "Conversation style chi tu 0 - 9.");

		PlayerInfo[playerid][pTalk] = style;

		if (!style)		SendSyntaxMessage(playerid, "Ban da tat hoat anh khi noi chuyen.");
		else			SendSyntaxMessage(playerid, "Conversation style doi thanh %i.", style);

		return 1;
	}
	else if (option == 3)
	{
	    if (PlayerInfo[playerid][pPremium] < 1)	return SendErrorMessage(playerid, "Combat style chi danh cho Premium Account.");
	        
		new style;

		if (sscanf(params,"{i}i",style))			return SendHelpMessage(playerid, "/setstyle [Combat style (1-5)]");
		if (style < 1 || style > 5)				return SendErrorMessage(playerid, "Combat style tu 1 den 5.");

        SetPlayerFightingStyle(playerid, fight_id[style-1]);
        PlayerInfo[playerid][pFightStyle] = fight_id[style-1];
		SendSyntaxMessage(playerid, "Combat style doi thanh %s.", fight_name[style-1]);

		return 1;
	}
	else if (option == 4)
	{
	    if (PlayerInfo[playerid][pPremium] < 1)	return SendErrorMessage(playerid, "Thay doi HUD chi duoc ap dung cho Premium Account.");
			
		new style;

		if (sscanf(params,"{d}d",style))			return SendHelpMessage(playerid, "/setstyle [Speedometer style (1-4)]");
		if (style < 1 || style > 4)				return SendSyntaxMessage(playerid, "Speedometer style tu 1 den 4.");

        PlayerInfo[playerid][pHud] = style-1;
        HideHudTextDraw(playerid);
        
        if (!(PlayerInfo[playerid][pSettings] & togHUD))	ShowHudTextDraw(playerid);
		
	}
	return 1;
}

CMD:checkatt(playerid, params[])
{
	new userid;

	if (sscanf(params,"i",userid))							return SendHelpMessage(playerid, "/checkatt [Player ID]");
	if (!IsPlayerLogged(userid))							return SendNotConnected(playerid);
	if (!PlayerNearPlayer(3.0, playerid, userid))			return SendNotNearPlayer(playerid);

	SendSyntaxMessage(playerid,  "%s Thuoc tinh: %s", GetNameWithMask(userid), PlayerInfo[userid][pAppearance]);
	return 1;
}

CMD:showatt(playerid, params[])
{
	new mes[128];
	format(mes, sizeof(mes), "%s", PlayerInfo[playerid][pAppearance]);
	cmd::me(playerid, mes);
	return 1;
}

CMD:fixmyview(playerid, params[])
{
	if(GetWorld(playerid) > 0 && GetInterior(playerid) == 0)
	{
		SetWorld(playerid, 0);
	    SetPlayerVirtualWorld(playerid, 0);
		SendSyntaxMessage(playerid, "Ban hien dang dong bo hoa trong may chu.");
	}
	else
	{
		SendSyntaxMessage(playerid, "Ban khong bi Bug View.");
	}

	return 1;
}

CMD:blindme(playerid, params[])
{
	if (Blind[playerid] == true)
	{
		Blind[playerid] = false;
		PlayerTextDrawDestroy(playerid, BlindMe[playerid][0]);
	}
	else if (Blind[playerid] == false)
	{
		BlindMe[playerid][0] = CreatePlayerTextDraw(playerid, 322.000000, -11.000000, "_");
		PlayerTextDrawFont(playerid, BlindMe[playerid][0], 1);
		PlayerTextDrawLetterSize(playerid, BlindMe[playerid][0], 0.600000, 52.800003);
		PlayerTextDrawTextSize(playerid, BlindMe[playerid][0], 298.500000, 645.000000);
		PlayerTextDrawSetOutline(playerid, BlindMe[playerid][0], 1);
		PlayerTextDrawSetShadow(playerid, BlindMe[playerid][0], 0);
		PlayerTextDrawAlignment(playerid, BlindMe[playerid][0], 2);
		PlayerTextDrawColor(playerid, BlindMe[playerid][0], -1);
		PlayerTextDrawBackgroundColor(playerid, BlindMe[playerid][0], 255);
		PlayerTextDrawBoxColor(playerid, BlindMe[playerid][0], 255);
		PlayerTextDrawUseBox(playerid, BlindMe[playerid][0], 1);
		PlayerTextDrawSetProportional(playerid, BlindMe[playerid][0], 1);
		PlayerTextDrawSetSelectable(playerid, BlindMe[playerid][0], 0);
		PlayerTextDrawShow(playerid, BlindMe[playerid][0]);
		Blind[playerid] = true;
	}
	return 1;
}

CMD:myspeed(playerid, params[])
{
	SendSyntaxMessage(playerid, "%.1f day la toc do cua ban.", GetPlayerSpeed(playerid));
	return 1;
}
