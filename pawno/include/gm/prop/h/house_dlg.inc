Dialog:HouseMenu(playerid, response, listitem, inputtext[])
{
	if (!response)	return 1;

	new houseid;
	if ((houseid = GetNearHouse(playerid)) == -1)					return SendErrorMessage(playerid, "Ban khong o gan ngoi nha.");
	if (HouseInfo[houseid][hOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Ngoi nha nay khong thuoc ve ban.");

	switch(listitem)
	{
	    case 0: cmd::lock(playerid, ""); // дверной замок
		case 1: { //Улучшения дома
			static dlgtxt[] = "{FFFFFF}Sua canh cua [% s] {33CC33} [$300] {FFFFFF}\n\
								Mua Radio {33CC33} [$500] {FFFFFF}\n\
								Nang cap cua\n\
								Nang cap khoa\n\
								Cai thien bao dong\n\
								Mua tu quan ao {33CC33} [$600] {FFFFFF}\n\
								Mua bo so cuu ";

			new diatxt[sizeof(dlgtxt) + 30], door[30];	

			if (!HouseInfo[houseid][hDDoor]) format(door, sizeof(door), "{9ACD32}KHONG YEU CAU{FFFFFF}");
			else 							format(door, sizeof(door), "{FF6347}YEU CAU{FFFFFF}");

			format(diatxt, sizeof(diatxt), dlgtxt, door);

			Dialog_Show(playerid, HouseUpgrade, DIALOG_STYLE_LIST, "Cai tien nha", diatxt, "Chon", "Quay lai");
		}
		case 2: cmd::furniture(playerid, ""); //Управление мебелью
		case 3: //Жильцы
		{
		    new query[128];
			mysql_format(dbHandle, query, sizeof(query), "SELECT `id`, `name` FROM `users` WHERE `rent_key` = %i LIMIT %i", HouseInfo[houseid][hID], MAX_TENAT_SPACE);
			mysql_tquery(dbHandle, query, "ShowTenantsAmount", "i", playerid);
		}
		case 4: //Инвентарь дома
		{
		    if (!IsPlayerInsideHouse(playerid, houseid))		return SendErrorMessage(playerid, "Ban phai o trong ngoi nha..");
		        
			PrintHouseInv(playerid, houseid);
		}
		case 5: //Сейф с деньгами
		{
			static dlgtxt[] = "So du: $%i\n\
								{FF6347}>{FFFFFF} Gui vao\n\
								{FF6347}>{FFFFFF} Lay ra";

			new diatxt[sizeof(dlgtxt) + 11];		
			format(diatxt, sizeof(diatxt), dlgtxt, HouseInfo[houseid][hCash]);

			Dialog_Show(playerid, HouseSafeChoose, DIALOG_STYLE_TABLIST, "Ket sat", diatxt, "Chon", "Quay lai");
			return 1;
		}
		case 6: cmd::clothes(playerid, ""); //Шкаф с одеждой
		case 7: Dialog_Show(playerid, SellHouseChoose, DIALOG_STYLE_LIST, "{FFFFFF}Ban nha", "Ban ngoi nha cho nguoi chiu\nBan ngoi nha cho nha nuoc", "Chon", "Quay lai");
	}
	return 1;
}

Dialog:HouseUpgrade(playerid, response, listitem, inputtext[])
{
    if (!response)	return cmd::hmenu(playerid, "");

	new houseid;
	if ((houseid = GetNearInsideHouse(playerid)) == -1)				return SendErrorMessage(playerid, "Ban phai o trong ngoi nha cua ban.");
	if (HouseInfo[houseid][hOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Ngoi nha nay khong thuoc ve ban.");

	switch(listitem)
	{
		case 0: { //Починить дверь
			if (!HouseInfo[houseid][hDDoor])	return SendErrorMessage(playerid, "Cua truoc cua ban khong bi hu hong.");
			if (GetCash(playerid) < 300)		return SendErrorMessage(playerid, "Chi phi sua chua cua la $300. ");

			HouseInfo[houseid][hDDoor] = 0;
			SQL_SetInteger("houses", "ddoor", HouseInfo[houseid][hDDoor], HouseInfo[houseid][hID]);
			UpdateHouseDoor(houseid);
			GiveCash(playerid, -300);
			SendSyntaxMessage(playerid, "Ban da sua cua truoc voi gia $300. ");
			return 1;
		}
		case 1: { //Купить радио
			if (HouseInfo[houseid][hRadio])	return SendErrorMessage(playerid, "Mot dai phat thanh da duoc lap dat trong ngoi nha nay. ");
			if (GetCash(playerid) < 500)		return SendErrorMessage(playerid, "Ban khong co du tien. Ban can $500.");

			HouseInfo[houseid][hRadio] = 1;
			SQL_SetInteger("houses", "radio", HouseInfo[houseid][hRadio], HouseInfo[houseid][hID]);
			GiveCash(playerid, -500);
			SendSyntaxMessage(playerid, "Ban da mua dai phat thanh voi gia $500. Su dung /setstation.");
			return 1;
		}
		case 2: { // Улучшить дверь
			static dlgtxt[] = "Cap do\tLoai cua\tDac diem\tGia\n\
								{C3C3C3} Cap do 1 {FFFFFF}\t Go\t + 5%% chong trom\t {33CC33} $750\n\
								{C3C3C3} Cap do 2 {FFFFFF}\tSat\t + 15%% chong trom\t {33CC33} $1500\n ";

			Dialog_Show(playerid, HouseUpgradeDoor, DIALOG_STYLE_TABLIST_HEADERS, "Nang cap cua", dlgtxt, "Mua", "Quay lai");
		}
		case 3: { //Улучшить замок
			static dlgtxt[] = "Cap do\tDac diem\tGia\n\
							{C3C3C3} Cap do 1 {FFFFFF}\t + 5%% chong trom\t {33CC33} $250\n\
							{C3C3C3} Cap do 2 {FFFFFF}\t + 10%% chong trom\t {33CC33} $500\n\
							{C3C3C3} Cap do 3 {FFFFFF}\t + 15%% chong trom\t {33CC33} $750\n\
							{C3C3C3} Cap do 4 {FFFFFF}\t + 20%% chong trom\t {33CC33} $1000\n\
							{C3C3C3} Cap do 5 {FFFFFF}\t + 25%% chong trom\t {33CC33} $1250\n ";

			Dialog_Show(playerid, HouseUpgradeLock, DIALOG_STYLE_TABLIST_HEADERS, "Nang cap khoa", dlgtxt, "Mua", "Quay lai");
		}
		case 4: { // Улучшить сигнализацию
			static dlgtxt[] = "Cap do \tDac diem \tGia \n\
							{C3C3C3} Cap do 1 {FFFFFF} \tTieu chuan \t {33CC33} $500 \n\
							{C3C3C3} Cap do 2 {FFFFFF} \tTrung binh \t {33CC33} $1000 \n\
							{C3C3C3} Cap do 3 {FFFFFF} \tTot \t {33CC33} $1500 \n ";
			Dialog_Show(playerid, HouseUpgradeAlarm, DIALOG_STYLE_TABLIST_HEADERS, "Nang cap bao dong", dlgtxt, "Mua", "Quay lai");
		}
		case 5: { // Купить шкаф
			if (HouseInfo[houseid][hCupboard])	return SendErrorMessage(playerid, "Ban da co mot tu quan ao. ");
			if (GetCash(playerid) < 600)		return SendErrorMessage(playerid, "Gia cua tu quan ao la $600.");

			HouseInfo[houseid][hCupboard] = 1;
			SQL_SetInteger("houses", "cupboard", HouseInfo[houseid][hCupboard], HouseInfo[houseid][hID]);
			GiveCash(playerid, -600);
			SendSyntaxMessage(playerid, "Baan da mua mot cai tu quan ao voi gia $600.");
			SendSyntaxMessage(playerid, "Nhap /clothes de su dung. ");
			return 1;
		}
		case 6: { // Купить аптечку
			static dlgtxt[] = "Cap do \tSuc khoe \tHoi phuc \tGia \n\
							{C3C3C3} Cap do 1 {FFFFFF} \t + 20 HP \t + 60 giay \t {33CC33} $400 \n\
							{C3C3C3} Cap do 2 {FFFFFF} \t + 40 HP \t + 80 giay \t {33CC33} $800 \n\
							{C3C3C3} Cap do 3 {FFFFFF} \t + 60 HP \t + 100 giay \t {33CC33} $1200 \n\
							{C3C3C3} Cap do 4 {FFFFFF} \t + 80 HP \t + 120 giay \t {33CC33} $1600 \n\
							{C3C3C3} Cap do 5 {FFFFFF} \t + 100 HP \t + 140 giay \t {33CC33} $2000 \n";

			Dialog_Show(playerid, HouseUpgradeHeal, DIALOG_STYLE_TABLIST_HEADERS, "Mua bo so cuu", dlgtxt, "Mua", "Quay lai");	
		}
	}

	return 1;
}

Dialog:HouseUpgradeDoor(playerid, response, listitem, inputtext[])
{
	if (!response)	return cmd::hmenu(playerid, "");

	new houseid;
	if ((houseid = GetNearInsideHouse(playerid)) == -1)				return SendErrorMessage(playerid, "Ban phai o trong ngoi nha cua ban.");
	if (HouseInfo[houseid][hOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Ngoi nha nay khong thuoc ve ban.");

	listitem += 1;

	if (HouseInfo[houseid][hDoor] >= listitem)	return SendErrorMessage(playerid, "Ban da cai dat canh cua cap do %i.", HouseInfo[houseid][hDoor]);
	if (GetCash(playerid) < 750 * listitem)		return SendErrorMessage(playerid, "Ban khong co du $%i.", listitem * 750);

	HouseInfo[houseid][hDoor] = listitem;
	SQL_SetInteger("houses", "door", HouseInfo[houseid][hDoor], HouseInfo[houseid][hID]);
	GiveCash(playerid, -listitem * 750);
	SendSyntaxMessage(playerid, "Ban da mua canh cua cap do %i voi gia $%i.", HouseInfo[houseid][hDoor], listitem * 750);
	return 1;
}

Dialog:HouseUpgradeLock(playerid, response, listitem, inputtext[])
{
	if (!response)	return cmd::hmenu(playerid, "");

	new houseid;
	if ((houseid = GetNearInsideHouse(playerid)) == -1)				return SendErrorMessage(playerid, "Ban phai o trong ngoi nha cua ban.");
	if (HouseInfo[houseid][hOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Ngoi nha nay khong thuoc ve ban.");

	listitem += 1;

	if (HouseInfo[houseid][hLock] >= listitem)	return SendErrorMessage(playerid, "Ban da co khoa cap do %i.", HouseInfo[houseid][hLock]);
	if (GetCash(playerid) < 250 * listitem)		return SendErrorMessage(playerid, "Ban khong co du $%i.", listitem * 250);
	
	HouseInfo[houseid][hLock] = listitem;
	SQL_SetInteger("houses", "lock", HouseInfo[houseid][hLock], HouseInfo[houseid][hID]);
	GiveCash(playerid, -listitem * 250);
	SendSyntaxMessage(playerid, "Ban da mua khoa cap do %i voi gia $%i.", HouseInfo[houseid][hLock], listitem * 250);
	return 1;
}

Dialog:HouseUpgradeAlarm(playerid, response, listitem, inputtext[])
{
	if (!response)	return cmd::hmenu(playerid, "");

	new houseid;
	if ((houseid = GetNearInsideHouse(playerid)) == -1)				return SendErrorMessage(playerid, "Ban phai o trong ngoi nha cua ban.");
	if (HouseInfo[houseid][hOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Ngoi nha nay khong thuoc ve ban.");

	listitem += 1;

	if (HouseInfo[houseid][hAlarm] >= listitem)	return SendErrorMessage(playerid, "Ban da cai dat bao dong cap do %i.", HouseInfo[houseid][hAlarm]);
	if (GetCash(playerid) < 500 * listitem)		return SendErrorMessage(playerid, "Ban khong co du $%i.", listitem * 500);

	HouseInfo[houseid][hAlarm] = listitem;
	SQL_SetInteger("houses", "alarm", HouseInfo[houseid][hAlarm], HouseInfo[houseid][hID]);
	GiveCash(playerid, -listitem * 500);
	SendSyntaxMessage(playerid, "Ban da mua mot he thong bao dong cap do %i voi gia $%i.", HouseInfo[houseid][hAlarm], listitem * 500);
	return 1;
}

Dialog:HouseUpgradeHeal(playerid, response, listitem, inputtext[])
{
	if (!response)	return cmd::hmenu(playerid, "");

	new houseid;
	if ((houseid = GetNearInsideHouse(playerid)) == -1)				return SendErrorMessage(playerid, "Ban nen o trong ngoi nha cua ban.");
	if (HouseInfo[houseid][hOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Ngoi nha nay khong thuoc ve ban.");

	listitem += 1;
	
	if (HouseInfo[houseid][hHeal] >= listitem)	return SendErrorMessage(playerid, "Ngoi nha da co mot bo so cuu.");
	if (GetCash(playerid) < listitem * 400)		return SendErrorMessage(playerid, "Ban khong co du $%i.", listitem * 400);

	HouseInfo[houseid][hHeal] = listitem;
	HouseInfo[houseid][hHealAmount] = 3;
	SQL_SetInteger("houses", "heal", HouseInfo[houseid][hHeal], HouseInfo[houseid][hID]);
	SQL_SetInteger("houses", "heal_amount", HouseInfo[houseid][hHealAmount], HouseInfo[houseid][hID]);
	GiveCash(playerid, -listitem * 400);
	SendSyntaxMessage(playerid, "Ban da mua mot bo so cuu cap do %i voi gia $%i.", HouseInfo[houseid][hHeal], listitem * 400);
	return 1;
}

Dialog:HouseSafeChoose(playerid, response, listitem, inputtext[])
{
    if (!response)	return cmd::hmenu(playerid, "");
	if (!listitem)	return cmd::hmenu(playerid, "");

	new houseid;
	if ((houseid = GetNearInsideHouse(playerid)) == -1)				return SendErrorMessage(playerid, "Ban phai o trong ngoi nha cua ban. ");
	if (HouseInfo[houseid][hOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Ngoi nha nay khong thuoc ve ban.");

	if (listitem == 1)
	{
		Dialog_Show(playerid, HouseDeposit, DIALOG_STYLE_INPUT, "Gui tien vao ket sat ", "Nhap so tien ma ban muon\ngui vao ket sat:\n\t\t(toi da $25.000.000)", "Chon", "Huy bo");
	}
	
	if (listitem == 2)
	{
		static dlgtxt[] = "Nhap so tien ma ban muon\nlay tu ket sat:\n\t\t(toi da $%s)";

		new diatxt[sizeof(dlgtxt) + 10];

		format(diatxt, sizeof(diatxt), dlgtxt, FormatNumber(HouseInfo[houseid][hCash]));
		Dialog_Show(playerid, HouseWithDraw, DIALOG_STYLE_INPUT, "Lay tien tu ket sat", diatxt, "Chon", "Huy bo");
	}
	
	return 1;
}

Dialog:HouseDeposit(playerid, response, listitem, inputtext[])
{
	if (!response)	return cmd::hmenu(playerid, "");

	new houseid;
	if ((houseid = GetNearInsideHouse(playerid)) == -1)				return SendErrorMessage(playerid, "Ban phai o trong ngoi nha cua ban.");
	if (HouseInfo[houseid][hOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Ngoi nha nay khong thuoc ve ban.");

	new amount;
	if (sscanf(inputtext, "i", amount))			 return Dialog_Show(playerid, HouseDeposit, DIALOG_STYLE_INPUT, "Gui tien vao ket sat", "Nhap so tien ma ban muon\ngui vao ket sat:\n\t\t(toi da $25.000.000)", "Chon", "Huy bo");
	if (amount > GetCash(playerid) || amount < 1) return Dialog_Show(playerid, HouseDeposit, DIALOG_STYLE_INPUT, "Gui tien vao ket sat", "BAN KHONG CO QUA NHIEU TIEN\n\nNhap so tien ma ban muon\ngui vao ket sat:\n\t\t(toi da $25.000.000)", "Chon", "Huy bo");

	GiveCash(playerid, -amount);
	HouseInfo[houseid][hCash] += amount;
	SQL_SetInteger("houses", "cash", HouseInfo[houseid][hCash], HouseInfo[houseid][hID]);
	SendSyntaxMessage(playerid, "Ban da gui $%i vao ket sat. So du: $%i.", amount, HouseInfo[houseid][hCash]);
	return 1;
}

Dialog:HouseWithDraw(playerid, response, listitem, inputtext[])
{
	if (!response)	return cmd::hmenu(playerid, "");

	new houseid;
	if ((houseid = GetNearInsideHouse(playerid)) == -1)				return SendErrorMessage(playerid, "Ban phai o trong ngoi nha cua ban. ");
	if (HouseInfo[houseid][hOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Ngoi nha nay khong thuoc ve ban.");

	new amount;
	if (sscanf(inputtext, "i", amount))			 		 return Dialog_Show(playerid, HouseDeposit, DIALOG_STYLE_INPUT, "Lay tien tu ket sat", "Nhap so tien ma ban muon\nlay tu ket sat:\n\t\t(до $25.000.000)", "Chon", "Huy bo");
	if (amount > HouseInfo[houseid][hCash] || amount > 1) return Dialog_Show(playerid, HouseDeposit, DIALOG_STYLE_INPUT, "Lay tien tu ket sat", "KET SAT CUA BAN KHONG CO QUA NHIEU TIEN!\n\nNhap so tien ma ban muon\nlay tu ket sat:\n\t\t(до $25.000.000)", "Chon", "Huy bo");

	HouseInfo[houseid][hCash] -= amount;
	SQL_SetInteger("houses", "cash", HouseInfo[houseid][hCash], HouseInfo[houseid][hID]);
	GiveCash(playerid, amount);
	SendSyntaxMessage(playerid, "Ban da lay $%i ra khoi ket sat. So tien con lai $%i.", amount, HouseInfo[houseid][hCash]);

	return 1;
}

Dialog:SellHouseChoose(playerid, response, listitem, inputtext[])
{
	if (!response)	return cmd::hmenu(playerid, "");

	new houseid;

	if ((houseid = GetNearHouse(playerid)) == -1)					return SendErrorMessage(playerid, "Ban khong o gan ngoi nha.");
	if (HouseInfo[houseid][hOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Ngoi nha nay khong thuoc ve ban.");

	switch(listitem)
	{
		case 0:
		{
		    Dialog_Show(playerid, SellHouseTo, DIALOG_STYLE_INPUT, "{FFFFFF}Ban nha", "{ffffff}Ban nha. Nhap {C3C3C3}[ID/Ten] [so tien]", "Ban", "Huy bo");
		}
		case 1:
		{
		    if (!IsPlayerOutsideHouse(playerid, houseid))	return SendErrorMessage(playerid, "Ban phai o ben ngoai ngoi nha.");
		        
		    static const str_size[] = "{FFFFFF}Ban co muon ban ngoi nha voi gia $%i khong. {FFFF00}(50 phan tram tu so tien)? ";
			new mes[sizeof(str_size) - 2 + 12];

		 	format(mes, sizeof(mes), str_size, HouseInfo[houseid][hPrice]/2/*+GetFurniturePrice(0, houseid)*/, '%');
			Dialog_Show(playerid, SellHouse, DIALOG_STYLE_MSGBOX, "Ban nha", mes, "Ban", "Huy bo");
		}
	}

	return 1;
}

Dialog:BuyInterior(playerid, response, listitem, inputtext[])
{
	if (!response) return 1;
	    
	new houseid = strval(inputtext);

    if (houseid < 0 || houseid >= MAX_HOUSES || !HouseInfo[houseid][hID])
	{
	    Dialog_Show(playerid, BuyInterior, DIALOG_STYLE_INPUT, "{FFFFFF}Dat hang noi that", "{FFFFFF}Nhap ID cua ngoi nha ban muon thay doi noi that:\nNgoi nha nay phai thuoc ve ban!", ">>>", "Dong");
		return SendErrorMessage(playerid, "Khong tim thay ngoi nha.");
	}
	if (HouseInfo[houseid][hOwnerID] != PlayerInfo[playerid][pID])
	{
	    Dialog_Show(playerid, BuyInterior, DIALOG_STYLE_INPUT, "{FFFFFF}Dat hang noi that", "{FFFFFF}Nhap ID cua ngoi nha ban muon thay doi noi that:\nNgoi nha nay phai thuoc ve ban!", ">>>", "Dong");
		return SendErrorMessage(playerid, "Ngoi nha nay khong thuoc ve ban.");
	}
	
	SetPlayerBuyInterior(playerid, 1, houseid);
	return 1;
}

Dialog:BuyInteriorAccept(playerid, response, listitem, inputtext[])
{
	if (!response)	return ShowMenuForPlayer(buy_interior, playerid);

	new houseid = pTemp[playerid][pInteriorHouse]-1;

    if (houseid < 0 || houseid >= MAX_HOUSES || !HouseInfo[houseid][hID])	return SetPlayerBuyInterior(playerid, 0);
	if (HouseInfo[houseid][hOwnerID] != PlayerInfo[playerid][pID])
	{
	    SetPlayerBuyInterior(playerid, 0);
		return SendErrorMessage(playerid, "Ngoi nha nay khong thuoc ve ban.");
	}
	if (GetCash(playerid) < 750)
	{
	    ShowMenuForPlayer(buy_interior, playerid);
	    return SendNotCash(playerid);
	}
	
	GiveCash(playerid, -750);
	SendSyntaxMessage(playerid, "Ban da thay doi noi that cua ngoi nha [ID: %i] voi gia $750.", houseid);
    SetHouseInterior(houseid, pTemp[playerid][pInteriorID]);
	SetPlayerBuyInterior(playerid, 0);
	
	new paycheck;

	for(new i; i < MAX_FURNITURE; i++)
	{
	    if (!HFurn[houseid][i][fID] || !HFurn[houseid][i][fOn]) continue;
	    paycheck += (HFurn[houseid][i][fMarketPrice] - (HFurn[houseid][i][fMarketPrice] & 2))  / 2;
	    HFurn[houseid][i][fID] =
	    HFurn[houseid][i][fOn] = 0;
	    DestroyDynamicObject(HFurn[houseid][i][fObject]);
	}

    HouseInfo[houseid][hFurniture] =
    HouseInfo[houseid][hOutsideFurniture] = 0;
    GiveCash(playerid, paycheck);

   	new query[128];
	mysql_format(dbHandle, query, sizeof(query), "DELETE FROM `furnitures` WHERE `building` = %i AND `bType` = 0", HouseInfo[houseid][hID]);
	mysql_tquery(dbHandle, query);
	return 1;
}

Dialog:SellHouseTo(playerid, response, listitem, inputtext[])
{
	if (!response)	return 1;

    new houseid;

	if ((houseid = GetNearHouse(playerid)) == -1)					return SendErrorMessage(playerid, "Ban khong o gan ngoi nha.");
	if (HouseInfo[houseid][hOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Ngoi nha nay khong thuoc ve ban.");

	if (houseid < 0 || houseid >= MAX_HOUSES || HouseInfo[houseid][hOwnerID] != PlayerInfo[playerid][pID])	return 1;
	    
    new userid, price;

	if (sscanf(inputtext, "ui", userid, price))
	{
	    Dialog_Show(playerid, SellHouseTo, DIALOG_STYLE_INPUT, "{FFFFFF}Ban nha", "{ffffff}Ban nha. Nhap {C3C3C3}[ID/Ten] [gia]", "Ban", "Huy bo");
	    return SendErrorMessage(playerid, "Dinh dang khong hop le.");
	}
	if (userid == playerid)
	{
	    Dialog_Show(playerid, SellHouseTo, DIALOG_STYLE_INPUT, "{FFFFFF}Ban nha", "{ffffff}Ban nha. Nhap {C3C3C3}[ID/Ten] [gia]", "Ban", "Huy bo");
		return SendErrorMessage(playerid, "Ban khong the ban nha cho chinh minh.");
	}
	if (!IsPlayerLogged(userid))
	{
	    Dialog_Show(playerid, SellHouseTo, DIALOG_STYLE_INPUT, "{FFFFFF}Ban nha", "{ffffff}Ban nha. Nhap {C3C3C3}[ID/Ten] [gia]", "Ban", "Huy bo");
		return SendNotConnected(playerid);
	}
	
	if (!PlayerNearPlayer(3.0, playerid, userid))
	{
	    Dialog_Show(playerid, SellHouseTo, DIALOG_STYLE_INPUT, "{FFFFFF}Ban nha", "{ffffff}Ban nha. Nhap {C3C3C3}[ID/Ten] [gia]", "Ban", "Huy bo");
		return SendNotNearPlayer(playerid);
	}
	
	if (price < 0 || price > 100000000)
	{
	    Dialog_Show(playerid, SellHouseTo, DIALOG_STYLE_INPUT, "{FFFFFF}Ban nha", "{ffffff}Ban nha. Type {C3C3C3}[ID/Ten] [gia]", "Ban", "Huy bo");
	    return SendErrorMessage(playerid, "Gia ban chi tu $0 den $100,000,000.");
	}
	
	new mes[64];
	format(mes, sizeof(mes), "ban cho %s", inputtext);
	cmd::house(playerid, mes);
	return 1;
}

Dialog:SellHouse(playerid, response, listitem, inputtext[])
{
	if (!response) return 1;

    new houseid;

	if ((houseid = GetNearOutsideHouse(playerid)) == -1)			return SendErrorMessage(playerid, "Khong co ngoi nha ben canh ban.");
	if (HouseInfo[houseid][hOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Ngoi nha nay khong thuoc ve ban.");

    if (PlayerInfo[playerid][pSpawnPoint] == HouseInfo[houseid][hID]) {
		PlayerInfo[playerid][pSpawnType] = 0;
		PlayerInfo[playerid][pSpawnPoint] = 1;
		SendHelpMessage(playerid, "Vi tri xuat hien cua ban da tu dong thay doi tai Palomino Creek. (/settings)");
	}

    new money = PlayerInfo[playerid][pCash], cash;

	GiveCash(playerid, HouseInfo[houseid][hPrice]/2/*+GetFurniturePrice(0, houseid)*/);
	PlaySound(playerid, 1052);
	SendSyntaxMessage(playerid, "Ban da ban ngoi nha thanh cong voi gia $%i.", HouseInfo[houseid][hPrice]/2/*+GetFurniturePrice(0, houseid)*/);

	if (HouseInfo[houseid][hCash] > 0) 
	{
		SendSyntaxMessage(playerid, "Ban da de lai $%i trong ket sat sau khi ban nha, ban da lay thanh cong.", HouseInfo[houseid][hCash]);
		GiveCash(playerid, HouseInfo[houseid][hCash]);
		cash = HouseInfo[houseid][hCash];
	}

    new mes[256];
	format(mes, sizeof(mes), "%s [MYSQL: %i | IP: %s | Money(WAS): %i | Money(BECOME): %i] ban ngoi nha [H_MYSQL: %i] voi gia -- $%i + $%i", GetName(playerid), PlayerInfo[playerid][pID], q_GetPlayerIP(playerid), money, GetCash(playerid), 
	HouseInfo[houseid][hID], HouseInfo[houseid][hPrice]/2, cash);
    insert_log(mes, PROPERTY_LOG, 1, PlayerInfo[playerid][pAccID]);

	Sell_House(houseid);
	return 1;
}

Dialog:ChangeHouseSpawn(playerid, response, listitem, inputtext[])
{
	if (!response) return 1;

	new houseid = strval(inputtext);

	if (houseid < 0 || houseid >= MAX_HOUSES)																													return SendErrorMessage(playerid, "Khong tim thay ngoi nha.");
	if (!HouseInfo[houseid][hID] || (HouseInfo[houseid][hOwnerID] != PlayerInfo[playerid][pID] && HouseInfo[houseid][hID] != PlayerInfo[playerid][pRentKey]))	return SendErrorMessage(playerid, "Ban khong song trong nha.");

    SendSyntaxMessage(playerid, "Bay gio ban se xuat hien tai ngoi nha cua ban: %s.", (!HouseInfo[houseid][hApart])?(GetHouseZone(houseid)):(GetApartmentZone(HouseInfo[houseid][hApart])));
	PlayerInfo[playerid][pSpawnType] = 1;
	PlayerInfo[playerid][pSpawnPoint] = HouseInfo[houseid][hID];
	
	SQL_SetInteger("users", "spawntype", PlayerInfo[playerid][pSpawnType], PlayerInfo[playerid][pID]);
	SQL_SetInteger("users", "spawnpoint", PlayerInfo[playerid][pSpawnPoint], PlayerInfo[playerid][pID]);
	return 1;
}

Dialog:ChangeHouseInterior(playerid, response, listitem, inputtext[])
{
	if (!response) return 1;

	new index, houseid = GetPVarInt(playerid, "house_change");

    if (houseid < 0 || houseid >= MAX_HOUSES || !HouseInfo[houseid][hID])	return SendErrorMessage(playerid, "Khong tim thay ngoi nha.");

	for(new i = 0; i < MAX_INTERIORS; i++)
	{
		if (!AdminTeles[i][telesOn] || HouseInfo[houseid][hClass] != AdminTeles[i][telesType]) continue;

		if (index == listitem)
		{
		    index = i;
		    break;
		}
		index++;
	}

	SetHouseInterior(houseid, index);
	SendAdmMessageToPlayer(playerid, "Ngoi nha [ID: %i | INT: %s].", houseid, AdminTeles[index][telesMapName]);
	return 1;
}

Dialog:EvictTenant(playerid, response, listitem, inputtext[])
{
	if (!response)	return cmd::hmenu(playerid, "");

	new 
		dlgmes[70],
		name[MAX_PLAYER_NAME]
	;

	if (!listitem) Dialog_Show(playerid, HouseRequestRent, DIALOG_STYLE_INPUT, "Nguoi thue moi", "{FFFFFF}Nhap ID / ten cua nguoi choi ma ban muon dinh cu trong nha cua minh", ">>>", "Quay lai");
	else 		  listitem--;

	SetPVarInt(playerid, #Temp, listitem);

	format(name, sizeof(name), "%s", GetNameFromBD(pTemp[playerid][pListed][listitem]));		
	format(dlgmes, sizeof(dlgmes), "{FFFFFF}Ban co thuc su muon duoi %s khong??", name);
	
	ConfirmDialog(playerid, "Xac nhan", dlgmes, "EvictTenantConfirm");
	return 1;
}

Dialog:HouseRequestRent(playerid, response, listitem, inputtext[])
{
	if (!response)	return cmd::hmenu(playerid, "");
	
	new userid;
	if (sscanf(inputtext,"u", userid)) 								return Dialog_Show(playerid, HouseRequestRent, DIALOG_STYLE_INPUT, "Nguoi thue moi", "{FFFFFF}Nhap ID / ten cua nguoi choi ma ban muon dinh cu trong nha cua minh", ">>>", "Quay lai");
    if (userid == playerid) 			  							return Dialog_Show(playerid, HouseRequestRent, DIALOG_STYLE_INPUT, "Nguoi thue moi", "{FF6347}ID NGUOI CHOI KHONG HOP LE!\n{FFFFFF}Nhap ID / ten cua nguoi choi ma ban muon dinh cu trong nha cua minh", ">>>", "Quay lai");
	if (!IsPlayerLogged(userid))		  							return Dialog_Show(playerid, HouseRequestRent, DIALOG_STYLE_INPUT, "Nguoi thue moi", "{FF6347}ID NGUOI CHOI KHONG HOP LE!\n{FFFFFF}Nhap ID / ten cua nguoi choi ma ban muon dinh cu trong nha cua minh", ">>>", "Quay lai");
    if (!PlayerNearPlayer(3.0, playerid, userid))					return Dialog_Show(playerid, HouseRequestRent, DIALOG_STYLE_INPUT, "Nguoi thue moi", "{FF6347}NGUOI CHOI PHAI GAN DAY!\n{FFFFFF}Nhap ID / ten cua nguoi choi ma ban muon dinh cu trong nha cua minh", ">>>", "Quay lai");
    if (GetPlayerHouses(userid) || PlayerInfo[userid][pRentKey])	return SendErrorMessage(playerid, "Nguoi choi da mua / thue nha.");

	SetPVarInt(playerid, #RentUserid, userid);
	Dialog_Show(playerid, HouseRequestRent2, DIALOG_STYLE_INPUT, "Nguoi thue moi", "{FFFFFF}Nhap gia thue:", ">>>", "Quay lai");
	return 1;
}

Dialog:HouseRequestRent2(playerid, response, listitem, inputtext[])
{
	if (!response)	return 1;
	
	new price, userid = GetPVarInt(playerid, #RentUserid);
	if (sscanf(inputtext,"i", price)) 	return Dialog_Show(playerid, HouseRequestRent2, DIALOG_STYLE_INPUT, "Nguoi thue moi", "{FFFFFF}Nhap gia thue:", ">>>", "Quay lai");
	if (price < 0 || price > 500) 		return Dialog_Show(playerid, HouseRequestRent2, DIALOG_STYLE_INPUT, "Nguoi thue moi", "{FF6347}Chi phi thue nha tu $0 den $500!\n{FFFFFF}Nhap gia thue:", ">>>", "Quay lai");
	if (GetCash(userid) < price)		return SendErrorMessage(playerid, "Nguoi choi khong co du tien.");

	new houseid;
	if ((houseid = GetNearInsideHouse(playerid)) == -1)				return SendErrorMessage(playerid, "Ban phai o trong ngoi nha cua ban.");
	if (HouseInfo[houseid][hOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Ngoi nha nay khong thuoc ve ban.");

	new query[128];
	mysql_format(dbHandle, query, sizeof(query), "SELECT `id` FROM `users` WHERE `rent_key`=%i", HouseInfo[houseid][hID]);
	mysql_tquery(dbHandle, query, "OfferRentRoom", "iii", playerid, userid, price);

	return 1;
}

Dialog:StartBreakingLock(playerid, response, listitem, inputtext[])
{
	new houseid = BreakingHouse[playerid];
    
	BreakingHouse[playerid] = 0;
	
	if (!response)									  return 1;
	if (!IsPlayerOutsideHouse(playerid, houseid, 3.0)) return SendErrorMessage(playerid, "Ban nen o gan loi vao nha.");
	if (HouseInfo[houseid][hOwnerID] == 0)   		  return SendErrorMessage(playerid, "Chi nhung ngoi nha da mua moi co the bi trom.");
	if (HouseInfo[houseid][hLocked] == 0)   			  return SendErrorMessage(playerid, "Cua nha dang mo.");
	if (IsPlayerCrouching(playerid) == false)		  return SendErrorMessage(playerid, "Ban phai ngoi xuong.");
 
	if (pTemp[playerid][JackingType] == 3) {
		if (!IsPlayerHasItem(playerid, INV_PICKLOCK)) return SendErrorMessage(playerid, "Ban phai co mot cai moc khoa de chon o khoa cua xe. ");
		
		new htime;
		
		switch(HouseInfo[houseid][hDoor]) {
			case 0: htime = 250+HouseInfo[houseid][hLock]*250;
			case 1: htime = 250+HouseInfo[houseid][hLock]*250 + floatround((250+HouseInfo[houseid][hLock]*250) * 0.05);
			case 2: htime = 250+HouseInfo[houseid][hLock]*250 + floatround((250+HouseInfo[houseid][hLock]*250) * 0.15);
		}

		JackingLock[playerid] = htime;	
		RemovePlayerItem(playerid, INV_PICKLOCK, 1);

	} else if (pTemp[playerid][JackingType] == 4) {
		if (!CheckHanditem(playerid,18634)) return SendErrorMessage(playerid, "Ban nen co mot chiec xa beng trong tay.");
		PlaySound(playerid, 1138);
		HouseAlarm(houseid, true);

		new htime;
		
		switch(HouseInfo[houseid][hDoor]) {
			case 0: htime = 250+HouseInfo[houseid][hLock]*250;
			case 1: htime = 250+HouseInfo[houseid][hLock]*250 + floatround((250+HouseInfo[houseid][hLock]*250) * 0.05);
			case 2: htime = 250+HouseInfo[houseid][hLock]*250 + floatround((250+HouseInfo[houseid][hLock]*250) * 0.15);
		}

		JackingLock[playerid] = htime;	

	} else return 1;
	
	BreakingHouse[playerid] = houseid;
	cmd::me(playerid, "lay ra thu gi do va bat dau loay hoay voi o khoa cua cua truoc. ");
	return 1;
}