CMD:checkint(playerid, params[])
{
	new houseid;

	if ((houseid = GetNearOutsideHouse(playerid)) == -1)	return SendErrorMessage(playerid, "Khong co nha de ban gan ban.");
	if (HouseInfo[houseid][hOwnerID])						return SendErrorMessage(playerid, "Ngoi nha nay da duoc mua.");
	
	if (!GetWorld(playerid) && !GetInterior(playerid))		GetPlayerPos(playerid, PlayerInfo[playerid][pLocationPos][0], PlayerInfo[playerid][pLocationPos][1], PlayerInfo[playerid][pLocationPos][2]);
	PlayerEnterFreeze(playerid);
	SetPlayerPos(playerid,HouseInfo[houseid][hExitX],HouseInfo[houseid][hExitY],HouseInfo[houseid][hExitZ]);
	SetInterior(playerid,HouseInfo[houseid][hExitInt]);
	SetWorld(playerid,HouseInfo[houseid][hExitVW]);
	pTemp[playerid][pHouseEntered] = houseid;
	
	SetPVarInt(playerid, #check_int, 30);
	SendSyntaxMessage(playerid, "Ban dang xem noi that. Ban co 30 giay.");
	return 1;
}

ALTX:house("/h");
CMD:house(playerid, params[])
{
	new option[16], secoption[128];

	if (sscanf(params, "s[16]S()[128]", option, secoption))
	{
		SendHelpMessage(playerid, "/h(ouse) [tuy chon]");
		SendSyntaxMessage(playerid, "buy | menu | upgrade | withdraw | deposit | sell | sellto | backdoor");
         
		/*if (!randomEx(0,5)) {
			SendHelpMessage(playerid, "Neu ban can them mot nha de xe / thay doi vi tri cua loi vao / loi ra chinh hoac bo sung");
			SendHelpMessage(playerid, "Tham khao dien dan trong phan \"Property\"!");
		}		*/
		 
		return 1;
	}

	if (CompareStrings(option, "buy"))
	{
		new houseid;

		if ((houseid = GetNearOutsideHouse(playerid)) == -1)				return SendErrorMessage(playerid, "Ban khong o gan nha de ban.");
		if (HouseInfo[houseid][hOwnerID])									return SendErrorMessage(playerid, "Ngoi nha nay da thuoc ve ai do.");
		if (GetPlayerHouses(playerid) >= GetMaxPlayerHouse(playerid))		return SendErrorMessage(playerid, "Ban khong the mua nhieu ngoi nha.");
		if (PlayerInfo[playerid][pLevel] < HouseInfo[houseid][hLevelbuy])	return SendErrorMessage(playerid, "De mua ngoi nha nay ban can cap do %i.", HouseInfo[houseid][hLevelbuy]);
		if (GetCash(playerid) < HouseInfo[houseid][hPrice])					return SendNotCash(playerid);

		HouseInfo[houseid][hOwnerID] = PlayerInfo[playerid][pID];
		HouseInfo[houseid][hLocked] = 1;
		HouseInfo[houseid][hCash] = 0;
		format(HouseInfo[houseid][hOwner], MAX_PLAYER_NAME, GetNameEx(playerid));

		new money = PlayerInfo[playerid][pCash];

		GiveCash(playerid, -HouseInfo[houseid][hPrice]);
		SendSyntaxMessage(playerid, "Ban da mua ngoi nha [ID: %i] voi gia $%i.", houseid, HouseInfo[houseid][hPrice]);
		
		for(new i = 0; i < MAX_GARAGES; i++)
		{
			if (!GarageInfo[i][garageID] || GarageInfo[i][garageHouse] != HouseInfo[houseid][hID]) continue;

			SendSyntaxMessage(playerid, "Ngoi nha cua ban co mot nha de xe [ID: %i].", i);
			GarageInfo[i][garageOwner] = PlayerInfo[playerid][pID];
			format(GarageInfo[i][garageOwnerName], 24, "%s", GetNameEx(playerid));
		
			SQL_SetInteger("garage", "owner", GarageInfo[i][garageOwner], GarageInfo[i][garageID]);
			SQL_SetString("garage", "ownername", GarageInfo[i][garageOwnerName], GarageInfo[i][garageID]);
		}

		if (HouseInfo[houseid][hExtX][0] && HouseInfo[houseid][hExtY][0] && HouseInfo[houseid][hExtZ][0]) {
			SendSyntaxMessage(playerid, "Nha ban co cua sau. Ban can lap dat mot loi ra trong noi that. ( /h backdoor )");
		}

		SendHelpMessage(playerid, "Su dung /househelp de xem tro giup quan ly ngoi nha. ");
		Save_House(houseid);

		new mes[256];
		format(mes, sizeof(mes), "%s [MYSQL: %i | IP: %s | Money(WAS): %i | Money(BECOME): %i] bought a house [H_MYSQL: %i] for -- $%i", GetName(playerid), PlayerInfo[playerid][pID], q_GetPlayerIP(playerid), money, GetCash(playerid), 
		HouseInfo[houseid][hID], HouseInfo[houseid][hPrice]);
    	insert_log(mes, PROPERTY_LOG, 3, PlayerInfo[playerid][pAccID]);
		return 1;
	}
	else if (CompareStrings(option, "hmenu"))	return cmd::hmenu(playerid, "");
	else if (CompareStrings(option, "upgrade"))
	{
		new houseid;

		if ((houseid = GetNearInsideHouse(playerid)) == -1)				return SendErrorMessage(playerid, "Ban can phai o trong ngoi nha.");
		if (HouseInfo[houseid][hOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Ngoi nha nay khong thuoc ve ban.");

		new parameters[16], arg[112];

		if (sscanf(secoption, "s[16]S()[112]", parameters, arg))
		{
			SendHelpMessage(playerid, "/house upgrade [tuy chon]");
			SendSyntaxMessage(playerid, "radio {33CC33}[$500]{FFFFFF} | lock | alarm | tudo {33CC33}[$600]{FFFFFF} | door | repairdoor | heal");
			return 1;
		}

		if (CompareStrings(parameters, "radio"))
		{
			if (HouseInfo[houseid][hRadio])		return SendErrorMessage(playerid, "Mot dai phat thanh da duoc lap dat trong ngoi nha nay.");
			if (GetCash(playerid) < 500)		return SendErrorMessage(playerid, "Ban khong co du tien. Ban can $500.");

			HouseInfo[houseid][hRadio] = 1;
			SQL_SetInteger("houses", "radio", HouseInfo[houseid][hRadio], HouseInfo[houseid][hID]);
			GiveCash(playerid, -500);
			SendSyntaxMessage(playerid, "Ban da mua mot dai phat thanh voi gia $500. Su dung /setstation.");
			return 1;
		}

		else if (CompareStrings(parameters, "lock"))
		{
			new level;

			if (sscanf(arg, "i", level))
			{
				SendHelpMessage(playerid, "/house upgrade lock [cap ddo (1-5)]");
				SendSyntaxMessage(playerid, "Moi cap do dat hon $250 so voi cap do truoc do[1 cap do - $250 | 5 cap do - $1250].");
				return 1;
			}
			if (level < 1 || level > 5)				return SendErrorMessage(playerid, "Cap do khoa tu 1 den 5.");
			if (GetCash(playerid) < 250 * level)	return SendErrorMessage(playerid, "Gia cua khoa cap do %i la $%i.", level, level * 250);
			if (HouseInfo[houseid][hLock] >= level)	return SendErrorMessage(playerid, "Ban da co o khoa cap do %i.", HouseInfo[houseid][hLock]);

			HouseInfo[houseid][hLock] = level;
			SQL_SetInteger("houses", "lock", HouseInfo[houseid][hLock], HouseInfo[houseid][hID]);
			GiveCash(playerid, -level * 250);
			SendSyntaxMessage(playerid, "Ban da mua mot cai khoa cap do %i voi gia $%i.", HouseInfo[houseid][hLock], level * 250);
			return 1;
		}

		else if (CompareStrings(parameters, "alarm"))
		{
			new level;

			if (sscanf(arg, "i", level))
			{
				SendHelpMessage(playerid, "/house upgrade alarm [level (1-3)]");
				SendSyntaxMessage(playerid, "Moi cap do dat hon $500 so voi cap do truoc do [1 cap do - $500 | 3 cap do - $1500].");
				return 1;
			}
			if (level < 1 || level > 3)					return SendErrorMessage(playerid, "Cap do bao dong tu 1 den 3.");
			if (GetCash(playerid) < 500 * level)		return SendErrorMessage(playerid, "Gia cua bao dong cap do %i la $%i.", level, level * 500);
			if (HouseInfo[houseid][hAlarm] >= level)	return SendErrorMessage(playerid, "Ban da cai dat bao dong cap do %i.", HouseInfo[houseid][hAlarm]);

			HouseInfo[houseid][hAlarm] = level;
			SQL_SetInteger("houses", "alarm", HouseInfo[houseid][hAlarm], HouseInfo[houseid][hID]);
			GiveCash(playerid, -level * 500);
			SendSyntaxMessage(playerid, "Ban da mua mot bao dong cap do %i voi gia $%i.", HouseInfo[houseid][hAlarm], level * 500);
			return 1;
		}
		
		else if (CompareStrings(parameters, "door"))
		{
			new level;

			if (sscanf(arg, "i", level))
			{
				SendHelpMessage(playerid, "/house upgrade door [level (1-2)]");
				SendSyntaxMessage(playerid, "Moi cap do dat hon $750 so voi cap do truoc do [1 cap do - $750 | 2 cap do - $1500].");
				return 1;
			}
			if (level < 1 || level > 2)				return SendErrorMessage(playerid, "Cap do cua tu 1 den 2.");
			if (GetCash(playerid) < 750 * level)	return SendErrorMessage(playerid, "Gia cua canh cua cap do %i la $%i.", level, level * 750);
			if (HouseInfo[houseid][hDoor] >= level)	return SendErrorMessage(playerid, "Ban da cai dat canh cua cap do %i.", HouseInfo[houseid][hDoor]);

			HouseInfo[houseid][hDoor] = level;
			SQL_SetInteger("houses", "door", HouseInfo[houseid][hDoor], HouseInfo[houseid][hID]);
			GiveCash(playerid, -level * 750);
			SendSyntaxMessage(playerid, "Ban da mua mot canh cua cap do %i voi gia $%i.", HouseInfo[houseid][hDoor], level * 750);
			return 1;
		}

		else if (CompareStrings(parameters, "tudo"))
		{
			if (HouseInfo[houseid][hCupboard])	return SendErrorMessage(playerid, "Ban da co mot tu quan ao. ");
			if (GetCash(playerid) < 600)			return SendErrorMessage(playerid, "Gia cua tu quan ao la $600.");

			HouseInfo[houseid][hCupboard] = 1;
			SQL_SetInteger("houses", "cupboard", HouseInfo[houseid][hCupboard], HouseInfo[houseid][hID]);
			GiveCash(playerid, -600);
			SendSyntaxMessage(playerid, "Ban da mua tu do voi gia $600.");
			SendSyntaxMessage(playerid, "Nhap /clothesfor de su dung.");
			return 1;
		}

		else if (CompareStrings(parameters, "repairdoor"))
		{
			if (!HouseInfo[houseid][hDDoor])	return SendErrorMessage(playerid,"Cua truoc cua ban khong bi hu hong.");
			if (GetCash(playerid) < 300)		return SendErrorMessage(playerid, "Gia sua canh cua la $300.");

			HouseInfo[houseid][hDDoor] = 0;
			SQL_SetInteger("houses", "ddoor", HouseInfo[houseid][hDDoor], HouseInfo[houseid][hID]);
			UpdateHouseDoor(houseid);
			GiveCash(playerid, -300);
			SendSyntaxMessage(playerid, "Ban da sua canh cua voi gia $300.");
			return 1;
		}

		else if (CompareStrings(parameters, "heal"))
		{
			new level;
			
			if (sscanf(arg, "i", level))
			{
				SendHelpMessage(playerid, "/house upgrade heal [cap do (1-5)]");
				SendSyntaxMessage(playerid, "Moi cap do dat hon $400 so voi cap do truoc do [1 cap do - $400 | 5 cap do - $2000].");
				SendSyntaxMessage(playerid, "Moi cap do tang luong mau phuc hoi them 20 HP [1 cap do - +20 HP | 5 cap do - +100 HP].");
				SendSyntaxMessage(playerid, "Moi cap do tang do tre cua lenh len 20 giay [1 cap do - 60 giay. | 5 cap do - 140 giay.].");
				return 1;
			}
			if (HouseInfo[houseid][hHeal])			return SendErrorMessage(playerid, "Nha da co san bo so cuu.");
			if (level < 1 || level > 5)				return SendErrorMessage(playerid, "Cap do bo so cuu tu 1 den 5. ");
			if (GetCash(playerid) < level * 400)	return SendErrorMessage(playerid, "Gia cua bo so cuu cap do %i la $%i.", level, level * 400);

			HouseInfo[houseid][hHeal] = level;
			HouseInfo[houseid][hHealAmount] = 3;
			SQL_SetInteger("houses", "heal", HouseInfo[houseid][hHeal], HouseInfo[houseid][hID]);
			SQL_SetInteger("houses", "heal_amount", HouseInfo[houseid][hHealAmount], HouseInfo[houseid][hID]);
			GiveCash(playerid, -level * 400);
			SendSyntaxMessage(playerid, "Ban da mua bo so cuu cap do %i voi gia $%i.", HouseInfo[houseid][hHeal], level * 400);
			return 1;
		}
	}

	else if (CompareStrings(option, "withdraw"))
	{
		new houseid; 

		if ((houseid = GetNearInsideHouse(playerid)) == -1)				return SendErrorMessage(playerid, "Ban can phai o trong ngoi nha.");
		if (HouseInfo[houseid][hOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Ngoi nha nay khong thuoc ve ban.");

		new amount;

		if (sscanf(secoption, "i", amount))
		{
			SendHelpMessage(playerid, "/house withdraw [so tien]");
			SendSyntaxMessage(playerid, "So tien trong ket sat la $%i.", HouseInfo[houseid][hCash]);
			return 1;
		}
		if (amount > HouseInfo[houseid][hCash] || amount > 1)	return SendErrorMessage(playerid, "Ban khong co du tien trong ket sat.");

		HouseInfo[houseid][hCash] -= amount;
		SQL_SetInteger("houses", "cash", HouseInfo[houseid][hCash], HouseInfo[houseid][hID]);
		GiveCash(playerid, amount);
		SendSyntaxMessage(playerid, "Ban da lay $%i tu ket sat. So tien con lai $%i.", amount, HouseInfo[houseid][hCash]);
		return 1;
	}

	else if (CompareStrings(option, "deposit"))
	{
		new houseid;

		if ((houseid = GetNearInsideHouse(playerid)) == -1)				return SendErrorMessage(playerid, "Ban can phai o trong ngoi nha. ");
		if (HouseInfo[houseid][hOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Ngoi nha nay khong thuoc ve ban.");

		new amount;

		if (sscanf(secoption, "i", amount))
		{
			SendHelpMessage(playerid, "/house deposit [so tien]");
			SendSyntaxMessage(playerid, "So tien trong ket sat la $%i.", HouseInfo[houseid][hCash]);
			return 1;
		}
		if (amount > GetCash(playerid) || amount < 1)	return SendNotCash(playerid);

		GiveCash(playerid, -amount);
		HouseInfo[houseid][hCash] += amount;
		SQL_SetInteger("houses", "cash", HouseInfo[houseid][hCash], HouseInfo[houseid][hID]);
		SendSyntaxMessage(playerid, "Ban da dua $%i vao ket sat. So tien moi la: $%i.", amount, HouseInfo[houseid][hCash]);
		return 1;
	}

	else if (CompareStrings(option, "Ban"))
	{
		new houseid;

		if ((houseid = GetNearOutsideHouse(playerid)) == -1)			return SendErrorMessage(playerid, "Ban khong o gan nha.");
		if (HouseInfo[houseid][hOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Ngoi nha nay khong thuoc ve ban.");

		static const str_size[] = "{FFFFFF}Ban co chac chan muon ban ngoi nha cua ban voi gia $%i. {FFFF00}(50%% so voi chi phi ban dau)?";
		new mes[sizeof(str_size) - 2 + 12];
 		format(mes, sizeof(mes), str_size, HouseInfo[houseid][hPrice]/2);
		Dialog_Show(playerid, SellHouse, DIALOG_STYLE_MSGBOX, "{FFFFFF}Ban nha", mes, "Ban", "Huy bo");
		return 1;
	}

	else if (CompareStrings(option, "sellto"))
	{
		new userid, price;

		if (sscanf(secoption, "ui", userid, price))			return SendHelpMessage(playerid, "/house sellto [ID/Ten] [gia]");

		new houseid;

		if ((houseid = GetNearOutsideHouse(playerid)) == -1)			return SendErrorMessage(playerid, "Ban khong o gan nha. ");
		if (HouseInfo[houseid][hOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Ngoi nha nay khong thuoc ve ban.");
		if (!IsPlayerLogged(userid))									return SendNotConnected(playerid);
		if (!PlayerNearPlayer(3.0, playerid, userid))					return SendNotNearPlayer(playerid);
		if (price < 0 || price > 100000000)								return SendErrorMessage(playerid, "Gia ban ngoi nha tu $0 den $100.000.000.");

		pTemp[userid][pHousePrice] = price;
		pTemp[userid][pHousePlayer] = playerid;
		pTemp[userid][pHouseHouse] = houseid;
		SetPVarInt(userid, #accept_time, gettime() + 30);
		SendSyntaxMessage(playerid, "Ban da de nghi %s mua ngoi nha cua minh voi gia $%i.", GetNameEx(userid), price);
		SendSyntaxMessage(userid, "%s muon ban ngoi nha cua minh cho ban voi gia $%i. Nhan Y de xac nhan mua.", GetNameEx(playerid), price);
	}

	if (CompareStrings(option, "backdoor"))
	{
		new houseid = GetNearInsideHouse(playerid);
		
		if (houseid == -1) return SendErrorMessage(playerid, "Ban phai o trong ngoi nha cua ban!");

		if (GetInterior(playerid) != HouseInfo[houseid][hExitInt] || GetWorld(playerid) != HouseInfo[houseid][hExitVW]) {
			return SendErrorMessage(playerid, "Ban phai o trong ngoi nha cua ban!");
		}

		if (!HouseInfo[houseid][hExtX][0] && !HouseInfo[houseid][hExtY][0] && !HouseInfo[houseid][hExtZ][0]) {
			return SendErrorMessage(playerid, "Nha khong co loi vao phia sau! (Tham khao dien dan trong phan tai san)");
		}
		
		new Float: posX, Float: posY, Float: posZ;
		GetPlayerPos(playerid, posX, posY, posZ);

		HouseInfo[houseid][hExtX][1] = posX;
		HouseInfo[houseid][hExtY][1] = posY;
		HouseInfo[houseid][hExtZ][1] = posZ;

		HouseInfo[houseid][hExtVW][1] = GetPlayerVirtualWorld(playerid);
		HouseInfo[houseid][hExtInt][1] = GetPlayerInterior(playerid);

		Save_House(houseid);
		SendSyntaxMessage(playerid, "Ban da dat vi tri cua sau bo sung cho ngoi nha cua minh.");
	}

	return 1;
}

CMD:hmenu(playerid, params[])
{
    new houseid;

	if ((houseid = GetNearHouse(playerid)) == -1)					return SendErrorMessage(playerid, "Ban khong o gan nha.");
	if (HouseInfo[houseid][hOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Ngoi nha nay khong thuoc ve ban.");

	static const str_size[] = "%s khoa cua\n\
								Cai tien nha\n\
								Quan ly noi that\n\
								Nguoi thue nha\n\
								Hang ton kho\n\
								Ket sat\n\
								Tu quan ao\n\
								Ban ngoi nha";
	new mes[sizeof(str_size) - 4 + 7 + 1 + 1];
 	
	format(mes, sizeof(mes), str_size, (HouseInfo[houseid][hLocked] != 0) ? ("Mo") : ("Dong"));
	Dialog_Show(playerid, HouseMenu, DIALOG_STYLE_LIST, "Home menu", mes, "Chon", "Huy bo");
	return 1;
}

CMD:rentroom(playerid, params[])
{
    new houseid;
	if ((houseid = GetNearInsideHouse(playerid)) == -1)				return SendErrorMessage(playerid, "Ban can phai o trong ngoi nha cua ban ");
	if (HouseInfo[houseid][hOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Ngoi nha nay khong thuoc ve ban.");
	    
    new userid, price;

	if (sscanf(params,"ud", userid, price))							return SendHelpMessage(playerid, "/rentroom [ID/Ten] [chi phi sinh hoat moi gio]");
    if (userid == playerid)											return 1;	
	if (!IsPlayerLogged(userid))									return SendNotConnected(playerid);
    if (!PlayerNearPlayer(3.0, playerid, userid))					return SendNotNearPlayer(playerid);
	if (price < 0 || price > 500)									return SendErrorMessage(playerid, "Sinh hoat phi tu $0 den $500.");
    if (GetPlayerHouses(userid) || PlayerInfo[userid][pRentKey])	return SendErrorMessage(playerid, "Nguoi choi da mua / thue nha.");
	if (GetCash(userid) < price)									return SendErrorMessage(playerid, "Nguoi choi khong co du tien.");

    new query[128];
	mysql_format(dbHandle, query, sizeof(query), "SELECT `id` FROM `users` WHERE `rent_key`=%i", HouseInfo[houseid][hID]);
	mysql_tquery(dbHandle, query, "OfferRentRoom", "iii", playerid, userid, price);
	return 1;
}


CMD:unrent(playerid, params[])
{
	if (PlayerInfo[playerid][pRentKey] < 1)	return SendErrorMessage(playerid, "Ban khong co thue ngoi nha nao.");

	PlayerInfo[playerid][pRentKey] = 0;
	SQL_SetInteger("users", "rent_key", 0, PlayerInfo[playerid][pID]);
	SendSyntaxMessage(playerid, "Ban da huy hop dong thue nha cua minh.");
	return 1;
}

/*
CMD:tenants(playerid, params[])
{
	new houseid;

	if ((houseid = GetNearHouse(playerid)) == -1)					return SendErrorMessage(playerid, "Ban khong o gan nha.");
	if (HouseInfo[houseid][hOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Ngoi nha nay khong thuoc ve ban.");

    new query[128];
	mysql_format(dbHandle, query, sizeof(query), "SELECT `id`, `name` FROM `users` WHERE `rent_key` = %i", HouseInfo[houseid][hID]);
	mysql_tquery(dbHandle, query, "ShowTenantsAmount", "i", playerid);
	return 1;
}*/

CMD:heal(playerid, params[])
{
	new id, userid;

	if ((id = GetNearInsideHouse(playerid)) != -1 && PlayerInfo[playerid][pID] == HouseInfo[id][hOwnerID])
	{
	    if (HouseInfo[id][hHeal] == 0)					return SendErrorMessage(playerid, "Khong co bo so cuu trong nha.");
	    if (pTemp[playerid][pHealTime] > gettime())		return SendErrorMessage(playerid, "Ban co the su dung bo so cuu trong %i giay.", pTemp[playerid][pHealTime]-gettime());
	    if (sscanf(params,"u", userid))					return SendHelpMessage(playerid, "/heal [ID/Ten]");
        if (!IsPlayerLogged(userid))					return SendNotConnected(playerid);
        if (!PlayerNearPlayer(3.0, playerid, userid))	return SendNotNearPlayer(playerid);
        if (PlayerInfo[userid][pInjured])				return SendErrorMessage(playerid, "Nguoi choi da chet / bi ha guc / bi thuong.");
        if (GetPlayerHealthEx(userid) >= 100.0)			return SendErrorMessage(playerid, "Nguoi choi khoe manh. ");

		if (playerid != userid)
		{
        	SendSyntaxMessage(playerid, "Ban da su dung bo so cuu (+%i HP) tren nguoi choi %s. Doi %i giay nua de su dung lai lenh nay.", (HouseInfo[id][hHeal] * 20), GetNameWithMask(userid), 40 + (HouseInfo[id][hHeal] * 20));
			SendSyntaxMessage(userid, "%s da su dung bo so cuu cho ban. (+%i HP)", GetNameWithMask(playerid), (HouseInfo[id][hHeal] * 20));
		}
		else
		{
		    SendSyntaxMessage(playerid, "Ban la su dung bo so cuu (+%i HP) tren chinh minh. Doi %i giay nua de su dung lai lenh nay.", (HouseInfo[id][hHeal] * 20), 40 + (HouseInfo[id][hHeal] * 20));
		}

		ResetDamages(userid);
		
        StopPlayerAnims(userid);
		UnFreezePlayer(userid);

		pTemp[playerid][pHealTime] = gettime() + 40 + (HouseInfo[id][hHeal] * 20);

        new Float:hp;

		AntiCheatGetHealth(playerid, hp);
	    SetPlayerHealth(playerid, hp + float(HouseInfo[id][hHeal]) * 20.0);

		if (GetPlayerHealthEx(userid) > 100.0)  SetPlayerHealth(userid, 100.0);

		HouseInfo[id][hHealAmount]--;
		if (!HouseInfo[id][hHealAmount]) HouseInfo[id][hHeal] = 0;
		Save_House(id);
		return 1;
	}

	else if (IsPlayerFactionMedic(playerid) || IsPlayerFactionFire(playerid)) //FD Heal
	{
		if (sscanf(params,"u", userid))					return SendHelpMessage(playerid, "/heal [ID/Ten]");
		if (!PlayerInfo[playerid][pOnDuty])				return SendErrorMessage(playerid, "Ban can phai trong gio lam viec.");
		if (!IsPlayerLogged(userid))					return SendNotConnected(playerid);
		if (userid == playerid)							return 1;
		if (!PlayerNearPlayer(3.0, playerid, userid))	return SendNotNearPlayer(playerid);
		if (pTemp[userid][pHealPlayer] == playerid)		return SendErrorMessage(playerid, "Ban da de nghi dieu tri doi voi nguoi choi nay. ");
		if (PlayerInfo[userid][pInjured] != 0)			return SendErrorMessage(playerid, "Nguoi choi nay dang trong giai doan bi thuong / tu vong.");
		if (GetPlayerHealthEx(userid) >= 100.0)			return SendErrorMessage(playerid, "Nguoi choi khoe manh.");

		pTemp[userid][pHealPlayer] = playerid;
		SetPVarInt(userid, #accept_time, gettime() + 30);
		SendSyntaxMessage(userid, "%s muon dieu tri cho ban. Nhan Y de chap nhan.", GetNameWithMask(playerid));
		SendSyntaxMessage(playerid, "Ban da de nghi dieu tri cho %s.", GetNameWithMask(userid));
	}
	
	else return SendErrorMessage(playerid, "Ban khong o trong ngoi nha.");

	return 1;
}

CMD:grantbuild(playerid, params[])
{
    new userid;

	if (sscanf(params,"u", userid))					return SendHelpMessage(playerid, "/grantbuild [ID/Ten]");
    if (!IsPlayerLogged(userid))					return SendNotConnected(playerid);
	if (userid == playerid)							return 1;
	if (!PlayerNearPlayer(3.0, playerid, userid))	return SendNotNearPlayer(playerid);

    new houseid;

	if ((houseid = GetNearInsideHouse(playerid)) == -1)				return SendErrorMessage(playerid, "Ban phai o trong ngoi nha.");
	if (HouseInfo[houseid][hOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid,"Ngoi nha nay khong thuoc ve ban.");

	if (pTemp[userid][pBuildHouse] == HouseInfo[houseid][hID])
	{
	    SendSyntaxMessage(playerid, "Ban da lay di quyen truy cap vao noi that chinh sua tu nguoi choi %s.", GetNameWithMask(userid));
	    SendSyntaxMessage(userid, "%s da lay di quyen truy cap noi that cua ban.", GetNameWithMask(playerid));
	    pTemp[userid][pBuildHouse] = 0;
	    return 1;
	}
	SendSyntaxMessage(playerid, "Ban da cap quyen truy cap chinh sua noi that cho %s.", GetNameWithMask(userid));
 	SendSyntaxMessage(userid, "%s da cap quyen truy cap chinh sua noi that cho ban.", GetNameWithMask(playerid));
    pTemp[userid][pBuildHouse] = HouseInfo[houseid][hID];
	return 1;
}

CMD:cache(playerid, params[])
{
    new houseid;

	if ((houseid = GetNearInsideHouse(playerid)) == -1)				return SendErrorMessage(playerid, "Ban phai o trong ngoi nha.");
	if (HouseInfo[houseid][hOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Ngoi nha nay khong thuoc ve ban.");

 	GetPlayerPos(playerid, HouseInfo[houseid][hCheckPosX], HouseInfo[houseid][hCheckPosY], HouseInfo[houseid][hCheckPosZ]);
	
 	Save_House(houseid);
 	SendSyntaxMessage(playerid, "Ban da thay doi vi tri cua bo nho cache.");
	return 1;
}

ALTX:hbreaklock("/hbl", "/hbreak");
CMD:hbreaklock(playerid, params[])
{
	if (!PoliceOnline())	return SendErrorMessage(playerid, "Phai co it nhat %i canh sat trong may chu.", NEED_COPS_TO_CRIME);

	new houseid = GetNearHouse(playerid);
	if (houseid == -1)						 		  return SendErrorMessage(playerid, "Ban nen o gan loi vao nha.");
	if (!IsPlayerOutsideHouse(playerid, houseid, 3.0)) return SendErrorMessage(playerid,"Ban nen o gan loi vao nha.");
	if (HouseInfo[houseid][hOwnerID] == 0)   		  return SendErrorMessage(playerid,"Chi nhung ngoi nha da mua moi co the bi trom.");
	if (HouseInfo[houseid][hLocked] == 0)   		  return SendErrorMessage(playerid,"Cua nha dang mo.");
	if (JackingLock[playerid] != 0)         		  return SendErrorMessage(playerid, "Ban da pha cua roi.");
	if (IsPlayerCrouching(playerid) == false) 		  return SendErrorMessage(playerid, "Ban phai ngoi xuong.");

	foreach(new i : Player) {
		if (BreakingHouse[i] == houseid) return SendErrorMessage(playerid, "Ai do da pha cua cua ngoi nha nay.");
	}

	new param[10];
	if (sscanf(params, "s[10]", param)) {
		SendHelpMessage(playerid, "/hbl [loai] hoac hbreaklock [loai]");
		SendSyntaxMessage(playerid, "(q)uite - am tham pha cua nha bang cay khoa. (lau hon)");
		SendSyntaxMessage(playerid, "(n)oisy - trom lon cua ngoi nha bang xa beng, kich hoat bao dong, neu co. (nhanh hon)");
		return 1;
	}	

	if (CompareStrings(param, "q") || CompareStrings(param, "quite"))
	{
		if (!IsPlayerHasItem(playerid, INV_PICKLOCK)) return SendErrorMessage(playerid, "Ban phai co mot cai moc khoa (picklock).");
		
		pTemp[playerid][JackingType] = 3;
		BreakingHouse[playerid] = houseid;
		
		new htime;
		
		switch(HouseInfo[houseid][hDoor]) {
			case 0: htime = 250+HouseInfo[houseid][hLock]*250;
			case 1: htime = 250+HouseInfo[houseid][hLock]*250 + floatround((250+HouseInfo[houseid][hLock]*250) * 0.05);
			case 2: htime = 250+HouseInfo[houseid][hLock]*250 + floatround((250+HouseInfo[houseid][hLock]*250) * 0.15);
		}

		static const str_size[] = "{"COL_GREY"}Ban co muon bat dau pha cua nha nay khong? Ban can %i giay.";
		new mes[sizeof(str_size) + 6 + 70];
		format(mes, sizeof(mes), str_size, (!HouseInfo[houseid][hApart])?(GetHouseZone(houseid)):(GetApartmentZone(HouseInfo[houseid][hApart])), htime);
        Dialog_Show(playerid, StartBreakingLock, DIALOG_STYLE_MSGBOX, "{FFFFFF}Pha cua", mes, "Bat dau", "Huy bo");
	}
	else if (CompareStrings(param, "n") || CompareStrings(param, "noisy"))
	{
		if (!CheckHanditem(playerid,18634)) return SendErrorMessage(playerid, "Ban nen co mot chiec xa beng trong tay. (/clothing)");
		pTemp[playerid][JackingType] = 4;
		BreakingHouse[playerid] = houseid;

		new htime;
		
		switch(HouseInfo[houseid][hDoor]) {
			case 0: htime = floatround((250+HouseInfo[houseid][hLock]*250)*0.6);
			case 1: htime = floatround((250+HouseInfo[houseid][hLock]*250 + floatround((250+HouseInfo[houseid][hLock]*250) * 0.05))*0.6);
			case 2: htime = floatround((250+HouseInfo[houseid][hLock]*250 + floatround((250+HouseInfo[houseid][hLock]*250) * 0.15))*0.6);
		}

		static const str_size[] = "{"COL_GREY"}Ban co muon bat dau pha cua nha %s, %i khong? Ban can %i giay.";
		new mes[sizeof(str_size) + 76];
		format(mes, sizeof(mes), str_size, (!HouseInfo[houseid][hApart])?(GetHouseZone(houseid)):(GetApartmentZone(HouseInfo[houseid][hApart])), htime);
        Dialog_Show(playerid, StartBreakingLock, DIALOG_STYLE_MSGBOX, "{FFFFFF}Breaking doors", mes, "Bat dau", "Huy bo");
	} else {
		SendHelpMessage(playerid, "/hbl [loai] hoac hbreaklock [loai]");
		SendSyntaxMessage(playerid, "(q)uite - am tham pha cua nha bang cay khoa. (lau hon)");
		SendSyntaxMessage(playerid, "(n)oisy - trom lon cua ngoi nha bang xa beng, kich hoat bao dong, neu co. (nhanh hon)");
		return 1;
	}

	return 1;
}