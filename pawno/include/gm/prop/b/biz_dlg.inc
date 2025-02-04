Dialog:BuyGunMenu(playerid, response, listitem, inputtext[])
{
	if (!response)	return 1;

	new bizid = -1;

	if ((bizid = GetNearInsideBiz(playerid)) == -1 || BizInfo[bizid][bizType] != BIZ_AMMO)	return 1;
	
	if (listitem == 0) { // ������
		static const str[] = "Vu khi\tGia\n\
							M1911\t{33CC33}$2000\n\
							Desert Eagle\t{33CC33}$3900\n\
							Shotgun\t{33CC33}$4700\n\
							Uzi\t{33CC33}$400\n\
							MP5\t{33CC33}$4000\n\
							Tec-9\t{33CC33}$4000\n\
							Country Rifle\t{33CC33}$5800\n\
							Knife\t{33CC33}$200\n\
							Katana\t{33CC33}$1000";

		new dlg[sizeof(str)+12] = "";
		format(dlg, sizeof(dlg), str);

		Dialog_Show(playerid, BuyGun, DIALOG_STYLE_TABLIST_HEADERS, "Lua chon vu khi", dlg, "Mua", "Quay lai");
		
	} else if (listitem == 1) {	// �������
		static const str[] = "Vu khi\tDan duoc\tSo luong\tGia\n\
							M1911\t.45 ACP\t7 round(s)\t{33CC33}$35\n\
							{000000}.	\t.45 ACP .ext\t14 round(s)\t{33CC33}$80\n\
							Desert Eagle\t.50AE\t7 round(s)\t{33CC33}$60\n\
							{000000}.	\t.50AE .ext\t14 round(s)\t{33CC33}$130\n\
							Shotgun\t12-G BIRDSHOT\t6 round(s)\t{33CC33}$300\n\
							{000000}.	\t12-G BUCKSHOT\t6 round(s)\t{33CC33}$200\n\
							{000000}.	\t12-G SLUG\t6 round(s)\t{33CC33}$150\n\
							Tec-9 / MP5 / Uzi\t9x19mm\t30 round(s)\t{33CC33}$200\n\
							{000000}.	\t9x19mm .ext\t60 round(s)\t{33CC33}$450\n\
							Country Rifle\t7.62x51mm\t4 round(s)\t{33CC33}$400";

		new dlg[sizeof(str)];
		format(dlg, sizeof(dlg), str);

		Dialog_Show(playerid, BuyAmmo, DIALOG_STYLE_TABLIST_HEADERS, "Lua chon dan duoc vu khi", dlg, "Mua", "Quay lai");

	} else if (listitem == 2) {
		static const str[] = "San pham\tGia\n\
							Kinh quang hoc\t{33CC33}$2700\n\
							Giam thanh\t{33CC33}$1000\n\
							Ao giap nhe {c7c7c7}(60%)\t{33CC33}$1000\n\
							Ao giap tieu chuan {c7c7c7}(80%)\t{33CC33}$1500\n\
							Ao giap nang {c7c7c7}(100%)\t{33CC33}$2000";

		new dlg[sizeof(str)+12];
		format(dlg, sizeof(dlg), str);
		
		Dialog_Show(playerid, BuyAdditional, DIALOG_STYLE_TABLIST_HEADERS, "Them vao", dlg, "Mua", "Quay lai");

	} else {
		cmd::ammohelp(playerid, "");
	}

	return 1;
}

Dialog:BuyGun(playerid, response, listitem, inputtext[])
{
	if (!response)	return BuyGunMenu(playerid);

	new bizid = -1;

	if ((bizid = GetNearInsideBiz(playerid)) == -1 || BizInfo[bizid][bizType] != BIZ_AMMO)	return 1;
	if (!CheckInv(playerid)) return SendErrorMessage(playerid, "Khong du dung luong cho tui do.");
	        
	new gun_list[] = {WEAPON_COLT45, WEAPON_DEAGLE, WEAPON_SHOTGUN, WEAPON_UZI, WEAPON_MP5, WEAPON_TEC9, WEAPON_RIFLE, WEAPON_KNIFE, WEAPON_KATANA},
		prc_list[] = {2000, 3900, 4700, 4000, 4000, 4000, 5800, 200, 1000};

	if (GetCash(playerid) < prc_list[listitem])							return SendErrorMessage(playerid, "Ban can $%i de mua.", prc_list[listitem]);
	if (BizInfo[bizid][bizOwnerID] != 0 && !BizInfo[bizid][bizProduct])	return SendErrorMessage(playerid, "Khong du san pham de ban. ");
    	
	switch(listitem) 
	{
		case 0..6: 
		{
			if (PlayerInfo[playerid][pWepLic] != 1)	 return SendErrorMessage(playerid, "Ban khong co giay phep vu khi.");
			if (PlayerInfo[playerid][pWepCount] != 0) return SendErrorMessage(playerid, "Ban co the thuc hien lan mua vu khi tiep theo trong %i lan lanh luong.", PlayerInfo[playerid][pWepCount]);
			
			PlayerInfo[playerid][pWepCount] = 6;
			SQL_SetInteger("users", "wep_count", 6, PlayerInfo[playerid][pID]);
			SendHelpMessage(playerid, "Ban co the thuc hien lan mua vu khi tiep theo trong %i lan lanh luong.", PlayerInfo[playerid][pWepCount]);
		}
	}

	new money = GetCash(playerid),
		weapon = gun_list[listitem],
		ammotype = GetDefaultAmmoType(weapon),
		ammo = CheckAmmo(ammotype);
		
	if (BizInfo[bizid][bizOwnerID] != 0)
	{
		BizInfo[bizid][bizProduct]--;
		GiveBizCash(bizid, prc_list[listitem] / 100 * 80);
	}

	GiveCash(playerid, -prc_list[listitem]);
	GiveInvItem(playerid, weapon, ammo+1, ammotype, PlayerInfo[playerid][pPlayerSerial]);

	SendSyntaxMessage(playerid, "Ban da mua %s voi gia $%i.", inventory_items[weapon][itemName], prc_list[listitem]);

	new query[128];
	format(query, sizeof(query), "%s [MYSQL: %i | IP: %s | Money(WAS): %i | Money(BECOME): %i] mua (%s) voi gia -- $%i", 
	GetName(playerid), PlayerInfo[playerid][pID], q_GetPlayerIP(playerid), money, GetCash(playerid), inventory_items[weapon][itemName], prc_list[listitem]);
	insert_log(query, WEAPON_LOG, 1, PlayerInfo[playerid][pAccID]);

	BuyGunMenu(playerid);
	return 1;
}

Dialog:BuyAmmo(playerid, response, listitem, inputtext[])
{
	if (!response) return BuyGunMenu(playerid);

    new bizid = -1;
	if ((bizid = GetNearInsideBiz(playerid)) == -1 || BizInfo[bizid][bizType] != BIZ_AMMO) 	return 1;
	
	new gun_list[][20] = {"M1911","M1911","Desert Eagle","Desert Eagle","Shotgun","Shotgun","Shotgun","Tec-9 / MP5 / Uzi", "Tec-9 / MP5 / Uzi","Country Rifle"},
		ammo_list[] = {82, 83, 84, 85, 86, 87, 88, 90, 91, 96},
		ammo_pr[] = {35, 80, 60, 130, 300, 200, 100, 200, 450, 400};

	if (!CheckInv(playerid)) 					return SendErrorMessage(playerid, "Khong co du dung luong trong tui do. ");
	if (GetCash(playerid) < ammo_pr[listitem])	return SendErrorMessage(playerid, "Ban can $%i de mua.", ammo_pr[listitem]);
	if (!PlayerInfo[playerid][pWepLic])			return SendErrorMessage(playerid, "Ban khong co giay phep vu khi.");
    
	if (BizInfo[bizid][bizOwnerID] != 0 && !BizInfo[bizid][bizProduct])	
		return SendErrorMessage(playerid, "Khong du san pham de ban.");

	new money = GetCash(playerid);
	if (BizInfo[bizid][bizOwnerID] != 0)
	{
		BizInfo[bizid][bizProduct]--;
		GiveBizCash(bizid, ammo_pr[listitem]);
	}

	GiveCash(playerid, -ammo_pr[listitem]);
	GiveInvItem(playerid, ammo_list[listitem], CheckAmmo(ammo_list[listitem])); 

	SendSyntaxMessage(playerid, "Ban da mua bang dan %s [%i round(s)] cho %s voi gia $%i.", inventory_items[ammo_list[listitem]][itemName], CheckAmmo(ammo_list[listitem]), gun_list[listitem], ammo_pr[listitem]);

	new query[128];
	format(query, sizeof(query), "%s [MYSQL: %i | IP: %s | Money(WAS): %i | Money(BECOME): %i] bought (Rounds:%s) for -- $%i",GetName(playerid), PlayerInfo[playerid][pID], q_GetPlayerIP(playerid), money, GetCash(playerid), ammo_list[listitem], ammo_pr[listitem]);
	insert_log(query, WEAPON_LOG, 2, PlayerInfo[playerid][pAccID]);

	BuyGunMenu(playerid);
	return 1;
}

Dialog:BuyAdditional(playerid, response, listitem, inputtext[])
{
	if (!response) return BuyGunMenu(playerid);

	new bizid = -1;
	if ((bizid = GetNearInsideBiz(playerid)) == -1 || BizInfo[bizid][bizType] != BIZ_AMMO) 	return 1;

	new add_name[][36] = {"Kinh quang hoc","Giam thanh","Ao giap nhe","Ao giap tieu chuan","Ao giap nang"},
		add_list[] = {INV_OPTICS, INV_SILENCER, 0, 0, 0},
		add_pr[] = {2700, 1000, 1000, 1500, 2000};

	if (GetCash(playerid) < add_pr[listitem]) 		return SendErrorMessage(playerid, "Ban can $%i de mua.", add_pr[listitem]);
	if (add_list[listitem] && !CheckInv(playerid)) 	return SendErrorMessage(playerid, "Khong co du dung luong trong tui do. ");

	if (BizInfo[bizid][bizOwnerID] != 0 && !BizInfo[bizid][bizProduct])	
		return SendErrorMessage(playerid, "Khong du san pham de ban. ");
	
	new money = GetCash(playerid);
	if (BizInfo[bizid][bizOwnerID] != 0)
	{
		BizInfo[bizid][bizProduct]--;
		GiveBizCash(bizid, add_pr[listitem]/100*90);
	}

	GiveCash(playerid, -add_pr[listitem]);

	if (add_list[listitem] != 0) GiveInvItem(playerid, add_list[listitem], 1); 
	else {
		new Float:armour;
		if (listitem == 2) 		armour = 60.0;
		else if (listitem == 3) 	armour = 80.0;
		else if (listitem == 4) 	armour = 100.0;
		
		SetPlayerArmour(playerid, armour);
	}

	SendSyntaxMessage(playerid,"Ban da mua %s voi gia $%i.", add_name[listitem], add_pr[listitem]);

	new query[128];
	format(query, sizeof(query), "%s [MYSQL: %i | IP: %s | Money(WAS): %i | Money(BECOME): %i] mua %s voi gia -- $%i",GetName(playerid), PlayerInfo[playerid][pID], q_GetPlayerIP(playerid), money, GetCash(playerid), add_name[listitem], add_pr[listitem]);
	insert_log(query, WEAPON_LOG, 2, PlayerInfo[playerid][pAccID]);

	BuyGunMenu(playerid);
	return 1;
}

Dialog:BusinessMenu(playerid, response, listitem, inputtext[])
{
    if (!response)	return 1;
	
	new bizid;

	if ((bizid = GetNearOutsideBiz(playerid)) == -1) 				bizid = GetNearInsideBiz(playerid);
	if (bizid == -1)												return SendErrorMessage(playerid, "Khong co doanh nghiep nao gan ban. ");
	if (BizInfo[bizid][bizOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Doanh nghiep nay khong thuoc ve ban.");

	switch(listitem)
	{
		case 0: //���������� � �������
		{
			new diatxt[300];
			format(diatxt, sizeof(diatxt), "{FFFFFF}bdID:\t\t\t%i\nTen:\t\t %s\nLoai doanh nghiep:\t\t %s\nTrang thai:\t\t %s\n", BizInfo[bizid][bizID], BizInfo[bizid][bizName], biz_types[BizInfo[bizid][bizType]], (BizInfo[bizid][bizLocked]) ? ("Dongd") : ("Open"));
			format(diatxt, sizeof(diatxt), "%sSo tien:\t\t $%i\nPhi vao cuaa:\t $%i\n\nTinh trinh kho hang: %i / 400\n", diatxt, BizInfo[bizid][bizCash], BizInfo[bizid][bizEntrance], BizInfo[bizid][bizProduct]);

			new id = biz_prod_types[BizInfo[bizid][bizType]];

			format(diatxt, sizeof(diatxt), "%sDat hang: %s voi gia $%i / 1 san pham", diatxt, truckcargo_product[id], BizInfo[bizid][bizBuyPrice]);

			Dialog_Show(playerid, BusinessMenuInfo, DIALOG_STYLE_MSGBOX, "Thong tin doanh nghiep", diatxt, "Quay lai", "");
			return 1;
		}
		case 1: //���������� � �����������
		{
			static dlgtxt[] = "Ten\tVi tri\n\
					{FF6347}>{FFFFFF} Thue mot nhan vien moi\n";

			new diatxt[sizeof(dlgtxt) + 10*(24+32)],
				count;

			format(diatxt, sizeof(diatxt), "%s", dlgtxt);
			for(new i = 0; i < MAX_WORK_SPACE; i++)
			{
				if (!BizWorkers[bizid][i][bizJobOn]) continue;

				count++;
				format(diatxt, sizeof(diatxt), "%s%i. %s\t%s\n", diatxt, i+1, BizWorkers[bizid][i][bizWorker], BizWorkers[bizid][i][bizPosition]);
			}

			if (!count) format(diatxt, sizeof(diatxt), "%s- Ban chua thue ai..", dlgtxt);			
			
			Dialog_Show(playerid, WorkerInfo, DIALOG_STYLE_TABLIST_HEADERS, "Thong tin nhan vien", diatxt, "Chon", "Quay lai");
			return 1;
		}
		case 2: //����� - �������� / �����
		{
			static dlgtxt[] = "Tai quay thu ngan: $%i\n\
								{FF6347}>{FFFFFF} Dat\n\
								{FF6347}>{FFFFFF} Lay";

			new diatxt[sizeof(dlgtxt) + 11];		
			format(diatxt, sizeof(diatxt), dlgtxt, BizInfo[bizid][bizCash]);

			Dialog_Show(playerid, TillOperations, DIALOG_STYLE_TABLIST, "Quay thu ngan", diatxt, "Chon", "Quay lai");
			return 1;
		}
		case 3: //������������ ���
		{
			new diatxt[128];
			
			if (BizInfo[bizid][bizType] == BIZ_GAS_STATION)	format(diatxt, sizeof(diatxt), "{FFFFFF}Gia moi lit: $%i", BizInfo[bizid][bizEntrance]);
			else 											format(diatxt, sizeof(diatxt), "{FFFFFF}Phi vao cua: $%i", BizInfo[bizid][bizEntrance]);

			new biz = BizInfo[bizid][bizType];
			if (biz == BIZ_STORE || 
				biz == BIZ_BAR ||
				biz == BIZ_PHARMACY || 
				biz == BIZ_PIZZA || 
				biz == BIZ_CLUCKIN || 
				biz == BIZ_BURGER || 
				biz == BIZ_DONUT) format(diatxt, sizeof(diatxt), "%s\n> Thay doi gia san pham", diatxt);
	
			Dialog_Show(playerid, ChooseConfigPrices, DIALOG_STYLE_TABLIST, "Cau truc gia", diatxt, "Chon", "Quay lai");
			return 1;
		}
		case 4: //��������� �������
		{
			Dialog_Show(playerid, BizUpgrade, DIALOG_STYLE_TABLIST, "Cai tien doanh nghiep", "Mua boombox {33CC33}[$100]{FFFFFF}\nSua cua {33CC33}[$1500]{FFFFFF}", "Chon", "Quay lai");
			return 1;
		}
		case 5: cmd::furniture(playerid, "");
		case 6: //������� ���������
		{
			static dlgtxt[] = "Ban dang mua san pham (%s) voi gia $%i cho mot don vi.\nNhap gia mua moi cho san pham";

			new diatxt[sizeof(dlgtxt) + 24 + 3],
				id = biz_prod_types[BizInfo[bizid][bizType]];	

			format(diatxt, sizeof(diatxt), dlgtxt, truckcargo_product[id], BizInfo[bizid][bizBuyPrice]);
			Dialog_Show(playerid, ProductBuying, DIALOG_STYLE_INPUT, "Mua san pham", diatxt, "Chon", "Quay lai");
			return 1;
		}
		case 7: //�������� ��������
		{
			static dlgtxt[] = "Ten doanh nghiep cua ban: %s\nNhap ten moi:";

			new diatxt[sizeof(dlgtxt) + 24];

			format(diatxt, sizeof(diatxt), dlgtxt, BizInfo[bizid][bizName]);
			Dialog_Show(playerid, ChangeBizName, DIALOG_STYLE_INPUT, "Thay doi ten", diatxt, "Chon", "Quay lai");
			return 1;
		}
		case 8: //�������� ������� ��� �����
		{	
			Dialog_Show(playerid, DoorName, DIALOG_STYLE_LIST, "Thay doi bien bao o loi vao", "Chinh sua\nXoa bo", "Chon", "Quay lai");
			return 1;
		}
		case 9: //������� ������
		{
			Dialog_Show(playerid, SellBiz, DIALOG_STYLE_LIST, "Ban doanh nghiep", "Ban cho nguoi choi\nBan cho nha nuoc", "Chon", "Quay lai");
			return 1;
		}
	}

	return 1;
}

Dialog:SellBiz(playerid, response, listitem, inputtext[])
{
	if (!response) return cmd::bmenu(playerid, "");

    new bizid;

	if ((bizid = GetNearOutsideBiz(playerid)) == -1) 			bizid = GetNearInsideBiz(playerid);
	if (bizid == -1)												return SendErrorMessage(playerid, "Khong co doanh nghiep nao gan ban. ");
	if (BizInfo[bizid][bizOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Doanh nghiep nay khong thuoc ve ban.");

	switch(listitem)
	{
		case 0:
		{
			Dialog_Show(playerid, SellBizTo, DIALOG_STYLE_INPUT, "{FFFFFF}Ban doanh nghiep", "{ffffff}Enter {C3C3C3}[ID/Ten] [gia ban]", "Ban", "Huy bo");
		}
		case 1:
		{
			static const str_size[] = "{FFFFFF}Ban co muon ban doanh nghiep cua minh voi gia $%i?";
			new mes[sizeof(str_size) - 2 + 12];

			format(mes, sizeof(mes), str_size, BizInfo[bizid][bizPrice] / 2);
			Dialog_Show(playerid, SellBizState, DIALOG_STYLE_MSGBOX, "{FFFFFF}Ban doanh nghiep", mes, "Ban", "Huy bo");
		}
	}
	return 1;
}

Dialog:SellBizTo(playerid, response, listitem, inputtext[])
{
	if (!response)	return 1;

    new bizid;

	if ((bizid = GetNearOutsideBiz(playerid)) == -1) 			bizid = GetNearInsideBiz(playerid);
	if (bizid == -1)												return SendErrorMessage(playerid, "Khong co doanh nghiep nao gan ban. ");
	if (BizInfo[bizid][bizOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Doanh nghiep nay khong thuoc ve ban.");

	if (bizid < 0 || bizid >= MAX_BIZ || BizInfo[bizid][bizOwnerID] != PlayerInfo[playerid][pID])	return 1;
	    
    new userid, price;

	if (sscanf(inputtext, "ui", userid, price))
	{
	    Dialog_Show(playerid, SellBizTo, DIALOG_STYLE_INPUT, "{FFFFFF}Ban doanh nghiep", "{ffffff}Nhap {C3C3C3}[ID/Ten] [gia ban]", "Ban", "Huy bo");
	    return SendErrorMessage(playerid, "Invalid format.");
	}
	
	if (!IsPlayerLogged(userid))
	{
	    Dialog_Show(playerid, SellBizTo, DIALOG_STYLE_INPUT, "{FFFFFF}Ban doanh nghiep", "{ffffff}Nhap {C3C3C3}[ID/Ten] [gia ban]", "Ban", "Huy bo");
		return SendNotConnected(playerid);
	}
	
	if (!PlayerNearPlayer(3.0, playerid, userid))
	{
	    Dialog_Show(playerid, SellBizTo, DIALOG_STYLE_INPUT, "{FFFFFF}Ban doanh nghiep", "{ffffff}Nhap {C3C3C3}[ID/Ten] [gia ban]", "Ban", "Huy bo");
		return SendNotNearPlayer(playerid);
	}
	
	if (price < 0 || price > 100000000)
	{
	    Dialog_Show(playerid, SellBizTo, DIALOG_STYLE_INPUT, "{FFFFFF}Ban doanh nghiep", "{ffffff}Nhap {C3C3C3}[ID/Ten] [gia ban]", "Ban", "Huy bo");
	    return SendErrorMessage(playerid, "Gia ban tu $0 den $100000000.");
	}
	
	pTemp[userid][pBizPrice] = price;
	pTemp[userid][pBizPlayer] = playerid;
	pTemp[userid][pBizID] = bizid;

	SetPVarInt(userid, #accept_time, gettime() + 30);
	SendSyntaxMessage(playerid, "Ban da de nghi %s mua doanh nghiep voi gia $%i.", GetNameEx(userid), price);
	SendSyntaxMessage(userid, "%s muon ban mua doanh nghiep voi gia $%i. Nhan Y de mua.", GetNameEx(playerid), price);
	return 1;
}

Dialog:SellBizState(playerid, response, listitem, inputtext[])
{
    if (!response)	return 1;

	new bizid;

	if ((bizid = GetNearOutsideBiz(playerid)) == -1) 				bizid = GetNearInsideBiz(playerid);
	if (bizid == -1)												return SendErrorMessage(playerid, "Khong co doanh nghiep nao gan ban. ");
	if (BizInfo[bizid][bizOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Doanh nghiep nay khong thuoc ve ban.");

	PlaySound(playerid, 1052);

	new biz_cost = BizInfo[bizid][bizPrice] / 2, money = PlayerInfo[playerid][pCash], cash;

	GiveCash(playerid, biz_cost);
	SendSyntaxMessage(playerid, "Ban da ban thanh cong doanh nghiep \"%s\" cua minh voi gia $%i.",BizInfo[bizid][bizName], biz_cost);

	if (BizInfo[bizid][bizCash] > 0)
	{
		SendSyntaxMessage(playerid,"Sau khi ban doanh nghiep, da co $%i, da duoc quay thanh cong.", BizInfo[bizid][bizCash]);
		GiveCash(playerid, BizInfo[bizid][bizCash]);
		cash = BizInfo[bizid][bizCash];
	}

    new mes[256];
	format(mes, sizeof(mes), "%s [MYSQL: %i | IP: %s | Money(WAS): %i | Money(BECOME): %i] ban doanh nghiep [B_MYSQL: %i] voi gia -- $%i + $%i",
	GetName(playerid), PlayerInfo[playerid][pID], q_GetPlayerIP(playerid), money, GetCash(playerid), BizInfo[bizid][bizID], biz_cost, cash);
    insert_log(mes, PROPERTY_LOG, 2, PlayerInfo[playerid][pAccID]);

	RemoveAllWorkers(bizid);
    Sell_Business(bizid);

	return 1;
}

Dialog:BizUpgrade(playerid, response, listitem, inputtext[])
{
    if (!response)	return cmd::bmenu(playerid, "");

	new bizid;

	if ((bizid = GetNearOutsideBiz(playerid)) == -1) 				bizid = GetNearInsideBiz(playerid);
	if (bizid == -1)												return SendErrorMessage(playerid, "Khong co doanh nghiep nao gan ban. ");
	if (BizInfo[bizid][bizOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Doanh nghiep nay khong thuoc ve ban.");

	if (listitem == 0)
	{
		if (BizInfo[bizid][bizRadio] == 1)				return SendErrorMessage(playerid, "Dai phat thanh da duoc cai dat trong doanh nghiep nay.");
		if (GetCash(playerid) < UPGRADE_PRICE_RADIO)	return SendErrorMessage(playerid, "Gia radio la $%i.", UPGRADE_PRICE_RADIO);

		BizInfo[bizid][bizRadio] = 1;
		SQL_SetInteger("business", "radio", BizInfo[bizid][bizRadio], BizInfo[bizid][bizID]);
		GiveCash(playerid, -UPGRADE_PRICE_RADIO);
		SendSyntaxMessage(playerid, "Ban da mua mot dai phat thanh cho doanh nghiep cua minh. ");
		SendHelpMessage(playerid, "Nhap /setstation, de su dung doanh nghiep. ");
	}
	else
	{
		if (BizInfo[bizid][bizDDoor] == 0)			return SendErrorMessage(playerid, "Cua khong can sua chua");
		if (GetCash(playerid) < UPGRADE_PRICE_DOOR)	return SendErrorMessage(playerid, "Gia sua canh cua la $%i.", UPGRADE_PRICE_DOOR);

		BizInfo[bizid][bizDDoor] = 0;
		SQL_SetInteger("business", "ddoor", BizInfo[bizid][bizDDoor], BizInfo[bizid][bizID]);
		UpdateBusinessDoor(bizid);
		GiveCash(playerid, -UPGRADE_PRICE_DOOR);
		SendSyntaxMessage(playerid, "Ban da sua canh cua la $%i.", UPGRADE_PRICE_DOOR);
	}
	return 1;
}

Dialog:ProductBuying(playerid, response, listitem, inputtext[])
{
    if (!response)	return cmd::bmenu(playerid, "");

	new bizid;

	if ((bizid = GetNearOutsideBiz(playerid)) == -1) 				bizid = GetNearInsideBiz(playerid);
	if (bizid == -1)												return SendErrorMessage(playerid, "Khong co doanh nghiep nao gan ban. ");
	if (BizInfo[bizid][bizOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Doanh nghiep nay khong thuoc ve ban.");

	new price = strval(inputtext), 
		id = biz_prod_types[BizInfo[bizid][bizType]];

	if (id == -1)					return SendErrorMessage(playerid, "Doanh nghiep cua ban khong can san pham.");
	if (price < 50 && price > 1000)	return SendErrorMessage(playerid, "Gia mua tu $50 den $1000.");

	BizInfo[bizid][bizBuyPrice] = price;
	SQL_SetInteger("business", "buy_price", price, BizInfo[bizid][bizID]);
	SendSyntaxMessage(playerid, "Bay gio ban da mua %s voi gia $%i cho mot don vi.", truckcargo_product[id], price);
	return 1;
}

Dialog:ChangeBizName(playerid, response, listitem, inputtext[])
{
    if (!response)	return cmd::bmenu(playerid, "");

	new bizid;

	if ((bizid = GetNearOutsideBiz(playerid)) == -1) 				bizid = GetNearInsideBiz(playerid);
	if (bizid == -1)												return SendErrorMessage(playerid, "Khong co doanh nghiep nao gan ban. ");
	if (BizInfo[bizid][bizOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Doanh nghiep nay khong thuoc ve ban.");

	new name[32];
	
	if (sscanf(inputtext, "s[32]", name)) return 1;
	if (strlen(name) > 30)				 	return SendErrorMessage(playerid, "Ten doanh nghiep co the co toi da 30 ky tu.");
	if (strfind(name, "~n~", true) != -1) 	return SendErrorMessage(playerid, "Ban khong the thay doi so dong trong ten doanh nghiep.");
	if (strfind(name, "\n", true) != -1)	return SendErrorMessage(playerid, "Ban khong the thay doi so dong trong ten doanh nghiep.");
	if (strfind(name, "'", true) != -1) 	return SendErrorMessage(playerid, "Khong the su dung dau hieu ' trong ten cua doanh nghiep.");
	if (CheckTextDrawString(name))			return SendErrorMessage(playerid, "Ten doanh nghiep khong duoc chua ky tu '~'.");

	format(BizInfo[bizid][bizName], 32, "%s", name);
	SQL_SetString("business", "name", BizInfo[bizid][bizName], BizInfo[bizid][bizID]);
	SendSyntaxMessage(playerid, "Ban da dat ten cua doanh nghiep la: %s", BizInfo[bizid][bizName]);

	return 1;
}

Dialog:TillOperations(playerid, response, listitem, inputtext[])
{
    if (!response)	return cmd::bmenu(playerid, "");
	if (!listitem)	return cmd::bmenu(playerid, "");

	new bizid;

	if ((bizid = GetNearOutsideBiz(playerid)) == -1) 				bizid = GetNearInsideBiz(playerid);
	if (bizid == -1)												return SendErrorMessage(playerid, "Khong co doanh nghiep nao gan ban. ");
	if (BizInfo[bizid][bizOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Doanh nghiep nay khong thuoc ve ban.");

	if (listitem == 1)
	{
		Dialog_Show(playerid, TillDeposit, DIALOG_STYLE_INPUT, "Gui tien vao quay thu ngan", "Nhap so tien\nBan muon gui vao quay thu ngan:\n\t\t(toi da $25.000.000)", "Chon", "Huy bo");
	}
	
	if (listitem == 2)
	{
		static dlgtxt[] = "Nhap so tien\nBan muon rut tu quay thu ngan:\n\t\t(toi da $%s)";

		new diatxt[sizeof(dlgtxt) + 10];

		format(diatxt, sizeof(diatxt), dlgtxt, FormatNumber(BizInfo[bizid][bizCash]));
		Dialog_Show(playerid, TillWithDraw, DIALOG_STYLE_INPUT, "Rut tien tu quay thu ngan", diatxt, "Chon", "Huy bo");
	}
	
	return 1;
}

Dialog:TillWithDraw(playerid, response, listitem, inputtext[])
{
    if (!response)	return 1;

	new bizid;

	if ((bizid = GetNearOutsideBiz(playerid)) == -1) 				bizid = GetNearInsideBiz(playerid);
	if (bizid == -1)												return SendErrorMessage(playerid, "Khong co doanh nghiep nao gan ban. ");
	if (BizInfo[bizid][bizOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Doanh nghiep nay khong thuoc ve ban.");

	new amount = strval(inputtext);

	if (BizInfo[bizid][bizCash] < amount) 	return SendErrorMessage(playerid, "Khong co tien trong quay thu ngan.");
	if (amount < 1 || amount > 25000000)	return SendErrorMessage(playerid, "Ban co the lay it nhat la $1 va nhieu nhat la $25.000.000.");

	GiveCash(playerid, amount);
	GiveBizCashWithdraw(playerid, -amount);
	SQL_SetInteger("business", "cash", BizInfo[bizid][bizCash], BizInfo[bizid][bizID]);
	SendSyntaxMessage(playerid, "Ban da lay $%i tu quay thu ngan.", amount);
	
	return 1;
}

Dialog:TillDeposit(playerid, response, listitem, inputtext[])
{
    if (!response)	return 1;

	new bizid;

	if ((bizid = GetNearOutsideBiz(playerid)) == -1) 			bizid = GetNearInsideBiz(playerid);
	if (bizid == -1)												return SendErrorMessage(playerid, "Khong co doanh nghiep nao gan ban. ");
	if (BizInfo[bizid][bizOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Doanh nghiep nay khong thuoc ve ban.");

	new amount = strval(inputtext);

	if (GetCash(playerid) < amount || amount < 1)	return SendNotCash(playerid);
	if (BizInfo[bizid][bizCash] + amount > 25000000)	return SendErrorMessage(playerid, "Tai quay thu ngan, khong qua $25.000.000.");

	GiveCash(playerid, -amount);
	GiveBizCash(bizid, amount);
	SQL_SetInteger("business", "cash", BizInfo[bizid][bizCash], BizInfo[bizid][bizID]);
	SendSyntaxMessage(playerid, "Ban da gui $%i vao quay thu ngan.", amount);
	
	return 1;
}

Dialog:DoorName(playerid, response, listitem, inputtext[])
{
    if (!response)	return cmd::bmenu(playerid, "");

	new bizid;

	if ((bizid = GetNearOutsideBiz(playerid)) == -1) 				bizid = GetNearInsideBiz(playerid);
	if (bizid == -1)												return SendErrorMessage(playerid, "Khong co doanh nghiep nao gan ban. ");
	if (BizInfo[bizid][bizOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Doanh nghiep nay khong thuoc ve ban.");

	if (listitem == 0)
	{
		static dlgtxt[] = "%s\n\
						{FFFFFF}Mau HTML co the duoc su dung trong van ban. Vi du ve mau sac: ~FFFF00~ - mau vang.\n\
						Vi du van ban: \"~FFFF00~Hello\" se hien thi van ban nay - \"{FFFF00}Hello{FFFFFF}\" \n\n\
						Nhap van ban duoi day:";

		new diatxt[sizeof(dlgtxt) + 24];

		format(diatxt, sizeof(diatxt), dlgtxt, BizInfo[bizid][bizMes]);
		Dialog_Show(playerid, ChangeDoorName, DIALOG_STYLE_INPUT, "Thay doi dong chu o loi vao", diatxt, "Chon", "Huy bo");
	}
	else 
	{
		format(BizInfo[bizid][bizMes], 128, "!");
		SQL_SetString("business", "entermsg", "!", BizInfo[bizid][bizID]);
		SendSyntaxMessage(playerid, "Bay gio van ban se khong duoc hien thi khi vao. ");
	}

	return 1;
}

Dialog:ChangeDoorName(playerid, response, listitem, inputtext[])
{
    if (!response)	return 1;

	new bizid;

	if ((bizid = GetNearOutsideBiz(playerid)) == -1) 			bizid = GetNearInsideBiz(playerid);
	if (bizid == -1)												return SendErrorMessage(playerid, "Khong co doanh nghiep nao gan ban. ");
	if (BizInfo[bizid][bizOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Doanh nghiep nay khong thuoc ve ban.");

	if (strlen(inputtext) < 2 || strlen(inputtext) > 127) return SendErrorMessage(playerid, "Van ban doanh nghiep khong duoc chua nhieu hon 127 ky tu. ");
	if (strfind(inputtext, "\n", true) != -1) 			 return SendErrorMessage(playerid, "Ban khong the thay doi so dong trong ten doanh nghiep.");

	format(BizInfo[bizid][bizMes], 128, "%s", inputtext);
	place_color(BizInfo[bizid][bizMes]);
	SQL_SetString("business", "entermsg", BizInfo[bizid][bizMes], BizInfo[bizid][bizID]);
	SendSyntaxMessage(playerid, "Ban da dat van ban khi vao doanh nghiep la: %s", BizInfo[bizid][bizMes]);

	return 1;
}

Dialog:WorkerInfo(playerid, response, listitem, inputtext[])
{
    if (!response)	return cmd::bmenu(playerid, "");

	new bizid;

	if ((bizid = GetNearOutsideBiz(playerid)) == -1) 				bizid = GetNearInsideBiz(playerid);
	if (bizid == -1)												return SendErrorMessage(playerid, "Khong co doanh nghiep nao gan ban. ");
	if (BizInfo[bizid][bizOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Doanh nghiep nay khong thuoc ve ban.");

	if (listitem == 0) return Dialog_Show(playerid, WorkerInvite, DIALOG_STYLE_INPUT, "Thue mot nhan vien", "{FFFFFF}Nhap ID/Ten nguoi choi ban muon thue:", ">>>", "Quay lai");
	
	listitem -= 1;
	SetPVarInt(playerid, #WorkerID, listitem);

	static dlgtxt[] = "{FFFFFF}TEN:\t\t %s\n\
					VI TRI:\t %s\n\
					{FF6347}>{FFFFFF} Thay doi vi tri\n\
					{FF6347}>{FFFFFF} Sa thai";
	
	new diatxt[sizeof(dlgtxt) + 24 + 32];

	format(diatxt, sizeof(diatxt), dlgtxt, BizWorkers[bizid][listitem][bizWorker], BizWorkers[bizid][listitem][bizPosition]);

	Dialog_Show(playerid, WorkerEdit, DIALOG_STYLE_TABLIST_HEADERS, "Thong tin Nhan vien", diatxt, "Chon", "Quay lai");
	return 1;
}

Dialog:WorkerEdit(playerid, response, listitem, inputtext[])
{
    if (!response)	return cmd::bmenu(playerid, "");

	new bizid;

	if ((bizid = GetNearOutsideBiz(playerid)) == -1) 				bizid = GetNearInsideBiz(playerid);
	if (bizid == -1)												return SendErrorMessage(playerid, "Khong co doanh nghiep nao gan ban. ");
	if (BizInfo[bizid][bizOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Doanh nghiep nay khong thuoc ve ban.");

	if (listitem == 1) return Dialog_Show(playerid, WorkerEditPos, DIALOG_STYLE_INPUT, "Thay doi vi tri", "{FFFFFF}Nhap vi tri moi cua nhan vien:", "Chon", "Huy bo");
	if (listitem == 2)
	{
		listitem = GetPVarInt(playerid, #WorkerID);
		static dlgtxt[] = "{FFFFFF}Ban thuc su muon sa thai %s (%s)?";
		new diatxt[sizeof(dlgtxt) + 24 + 32];

		format(diatxt, sizeof(diatxt), dlgtxt, BizWorkers[bizid][listitem][bizWorker], BizWorkers[bizid][listitem][bizPosition]);
		Dialog_Show(playerid, WorkerFire, DIALOG_STYLE_INPUT, "Sa thai mot nhan vien", diatxt, "Co", "Huy bo");
	}
	return 1;
}

Dialog:WorkerInvite(playerid, response, listitem, inputtext[])
{
    if (!response)	return 1;

	new bizid, userid;

	if ((bizid = GetNearOutsideBiz(playerid)) == -1) 				bizid = GetNearInsideBiz(playerid);
	if (bizid == -1)												return SendErrorMessage(playerid, "Khong co doanh nghiep nao gan ban. ");
	if (BizInfo[bizid][bizOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Doanh nghiep nay khong thuoc ve ban.");

	if (WorkSpace(bizid) == -1)						return SendErrorMessage(playerid, "Ban khong co vi tri tuyen dung. ");

	if (sscanf(inputtext, "u", userid))				return 1;
	if (userid == playerid)							return SendErrorMessage(playerid, "Ban khong the thue chinh minh. ");
	if (!IsPlayerLogged(userid))					return SendNotConnected(playerid);
	if (!PlayerNearPlayer(3.0, playerid, userid))	return SendNotNearPlayer(playerid);
	if (pTemp[userid][pHirePlayer] == playerid)		return SendErrorMessage(playerid, "Ban da cung cap cho nguoi choi mot cong viec. ");

	pTemp[userid][pHirePlayer] = playerid;
	SetPVarInt(userid, #accept_time, gettime() + 30);

	SendSyntaxMessage(userid, "%s da moi ban vao lam viec cho doanh nghiep.", GetNameWithMask(playerid));
	SendHelpMessage(userid, "Nhan Y de chap nhan loi de nghi.");
	SendSyntaxMessage(playerid, "Ban da moi %s vao lam viec cho doanh nghiep cua minh.", GetNameWithMask(userid));

	return 1;
}

Dialog:WorkerEditPos(playerid, response, listitem, inputtext[])
{
	if (!response)	return 1;
	
	new bizid;

	if ((bizid = GetNearOutsideBiz(playerid)) == -1) 				bizid = GetNearInsideBiz(playerid);
	if (bizid == -1)												return SendErrorMessage(playerid, "Khong co doanh nghiep nao gan ban. ");
	if (BizInfo[bizid][bizOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Doanh nghiep nay khong thuoc ve ban.");

	listitem = GetPVarInt(playerid, #WorkerID);

	format(BizWorkers[bizid][listitem][bizPosition], 24, "%s", inputtext);

	SQL_SetString("users", "position", BizWorkers[bizid][listitem][bizPosition], BizWorkers[bizid][listitem][bizJobOn]);

	SendSyntaxMessage(playerid, "Ban da thay doi vi tri %s thanh %s.", BizWorkers[bizid][listitem][bizWorker], BizWorkers[bizid][listitem][bizPosition]);

	for(new i; i < GetPlayerPoolSize(); i++)
	{
		if (PlayerInfo[i][pID] == BizWorkers[bizid][listitem][bizJobOn])
		{
			SendSyntaxMessage(i, "%s thay doi vi tri cua ban thanh %s.", GetNameEx(playerid), BizWorkers[bizid][listitem][bizPosition]);
			break;
		}
	}
	
	return 1;
}

Dialog:WorkerFire(playerid, response, listitem, inputtext[])
{
    if (!response)	return 1;
	
	new bizid;

	if ((bizid = GetNearOutsideBiz(playerid)) == -1) 				bizid = GetNearInsideBiz(playerid);
	if (bizid == -1)												return SendErrorMessage(playerid, "Khong co doanh nghiep nao gan ban. ");
	if (BizInfo[bizid][bizOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Doanh nghiep nay khong thuoc ve ban.");

	listitem = GetPVarInt(playerid, #WorkerID);

	SQL_SetString("users", "position", "-", BizWorkers[bizid][listitem][bizJobOn]);
	SQL_SetInteger("users", "workon", 0, BizWorkers[bizid][listitem][bizJobOn]);
	
	for(new i; i < GetPlayerPoolSize(); i++)
	{
		if (PlayerInfo[i][pID] == BizWorkers[bizid][listitem][bizJobOn])
		{
			SendSyntaxMessage(i, "%s da sa thai ban khoi doanh nghiep.", GetNameEx(playerid));
			PlayerInfo[i][pWorkOn] = 0;
			break;
		}
	}

	SendSyntaxMessage(playerid, "Ban da sa thai %s (%s) ra khoi doanh nghiep cua minh.", BizWorkers[bizid][listitem][bizWorker], BizWorkers[bizid][listitem][bizPosition]);

	BizWorkers[bizid][listitem][bizWorker] = EOS;
	BizWorkers[bizid][listitem][bizPosition] = EOS;
	BizWorkers[bizid][listitem][bizJobOn] = 0;
	return 1;
}

Dialog:BusinessMenuInfo(playerid, response, listitem, inputtext[])
{
    if (!response)	return cmd::bmenu(playerid, "");
	return 	cmd::bmenu(playerid, "");
}

Dialog:ChooseConfigPrices(playerid, response, listitem, inputtext[])
{
	if (!response)	return cmd::bmenu(playerid, "");

	new bizid;

	if ((bizid = GetNearOutsideBiz(playerid)) == -1) 			bizid = GetNearInsideBiz(playerid);
	if (bizid == -1)												return SendErrorMessage(playerid, "Khong co doanh nghiep nao gan ban. ");
	if (BizInfo[bizid][bizOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Doanh nghiep nay khong thuoc ve ban.");

	if (listitem == 0)
	{
		Dialog_Show(playerid, ConfigEntranceFee, DIALOG_STYLE_INPUT, "Cau hinh gia", "Nhap gia tri moi:", "Chon", "Huy bo");
	}
	else 
	{
		new biz = BizInfo[bizid][bizType];
		if (biz != BIZ_STORE && biz != BIZ_BAR && biz != BIZ_PHARMACY && biz != BIZ_PIZZA && biz != BIZ_CLUCKIN && biz != BIZ_BURGER && biz != BIZ_DONUT)	
			return SendErrorMessage(playerid,"Ban khong the thay doi gia trong doanh nghiep nay.");
		
		new type;
		switch(biz)
		{
			case BIZ_PIZZA:		type = 0;
			case BIZ_CLUCKIN:	type = 1;
			case BIZ_BURGER:	type = 2;
			case BIZ_DONUT:		type = 3;
			case BIZ_STORE:		type = 4;
			case BIZ_BAR:		type = 5;
			case BIZ_PHARMACY:	type = 6;
		}
		
		new mes[LIMIT_MAX_PRODUCTS*128];

		for(new i = 0; i < max_product[type]; i++)
		{
			format(mes, sizeof(mes), "%s{FFFFFF}Thay doi gia san pham #%i {AFAFAF}[%s, $%i]\n", mes, i+1, name_order[type][i], BizInfo[bizid][bizProductPrice][i]);
		}

		Dialog_Show(playerid, ConfigPrices, DIALOG_STYLE_LIST, "Cau hinh gia", mes, "Chon", "Quay lai");
		return 1;
	}

	return 1;
}

Dialog:ConfigEntranceFee(playerid, response, listitem, inputtext[])
{
	if (!response)	return 1;

	new bizid;

	if ((bizid = GetNearOutsideBiz(playerid)) == -1) 			bizid = GetNearInsideBiz(playerid);
	if (bizid == -1)												return SendErrorMessage(playerid, "Khong co doanh nghiep nao gan ban. ");
	if (BizInfo[bizid][bizOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Doanh nghiep nay khong thuoc ve ban.");

	new fee = strval(inputtext);

	if (fee < 0 || fee > 100) 
	{
		Dialog_Show(playerid, ConfigEntranceFee, DIALOG_STYLE_INPUT, "Cau hinh gia", "Nhap gia moi:", "Chon", "Huy bo");
		return SendErrorMessage(playerid, "Gia chi co the: tu $0 den $100.");
	}

	BizInfo[bizid][bizEntrance] = fee;
	SQL_SetInteger("business", "entrance", BizInfo[bizid][bizEntrance], BizInfo[bizid][bizID]);
	
	if (BizInfo[bizid][bizType] == BIZ_GAS_STATION)	SendSyntaxMessage(playerid, "Ban da dat gia cho nhien lieu cua doanh nghiep [ID: %d] la - $%i/l.", bizid, fee);
	else 											SendSyntaxMessage(playerid, "Ban da dat gia vao doanh nghiep [ID: %d] la $%i.", bizid, fee);
	
	return 1;
}


Dialog:ConfigPrices(playerid, response, listitem, inputtext[])
{
    if (!response)	return 1;

    new bizid;

	if ((bizid = GetNearInsideBiz(playerid)) == -1)				return SendErrorMessage(playerid, "Ban phai o ben trong doanh nghiep cua ban.");
	if (BizInfo[bizid][bizOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Doanh nghiep nay khong thuoc ve ban.");
	
	new biz = BizInfo[bizid][bizType];
	if (biz != BIZ_STORE && biz != BIZ_BAR && biz != BIZ_PHARMACY && biz != BIZ_PIZZA && biz != BIZ_CLUCKIN && biz != BIZ_BURGER && biz != BIZ_DONUT)	
		return SendErrorMessage(playerid, "Ban khong the thay doi gia cho doanh nghiep nay.");
	new type;
	switch(biz)
	{
		case BIZ_PIZZA:		type = 0;
		case BIZ_CLUCKIN:	type = 1;
		case BIZ_BURGER:	type = 2;
		case BIZ_DONUT:		type = 3;
		case BIZ_STORE:		type = 4;
		case BIZ_BAR:		type = 5;
		case BIZ_PHARMACY:	type = 6;
	}

	new mes[128];

	format(mes, sizeof(mes), "{FFFFFF}Thay doi gia san pham #%i {AFAFAF}[%s, $%i]", listitem+1, name_order[type][listitem], BizInfo[bizid][bizProductPrice][listitem]);
	Dialog_Show(playerid, ConfigPricesEnd, DIALOG_STYLE_INPUT, "Cau hinh gia", mes, "Nhap", "Dong");
	SetPVarInt(playerid, "ConfigPrices", listitem);
	return 1;
}

Dialog:ConfigPricesEnd(playerid, response, listitem, inputtext[])
{
    if (!response)	return 1;

    new bizid;

	if ((bizid = GetNearInsideBiz(playerid)) == -1)					return SendErrorMessage(playerid, "Ban phai o ben trong doanh nghiep cua ban.");
	if (BizInfo[bizid][bizOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Doanh nghiep nay khong thuoc ve ban.");

	new money = strval(inputtext);
	listitem = GetPVarInt(playerid, "ConfigPrices");

	new biz = BizInfo[bizid][bizType];
	if (biz != BIZ_STORE && biz != BIZ_BAR && biz != BIZ_PHARMACY && biz != BIZ_PIZZA && biz != BIZ_CLUCKIN && biz != BIZ_BURGER && biz != BIZ_DONUT)	return SendErrorMessage(playerid,"Ban khong the thay doi gia cho doanh nghiep nay.");
	new type;
	switch(biz)
	{
		case BIZ_PIZZA:		type = 0;
		case BIZ_CLUCKIN:	type = 1;
		case BIZ_BURGER:	type = 2;
		case BIZ_DONUT:		type = 3;
		case BIZ_STORE:		type = 4;
		case BIZ_BAR:		type = 5;
		case BIZ_PHARMACY:	type = 6;
	}

	if (money < biz_prices[type][listitem]/2 || money > biz_prices[type][listitem]*2)
	{
	    new mes[256];
		format(mes, sizeof(mes), ""EMBED_RED"So tien nhap it nhat phai $%i va khong nhieu hon $%i!\n{FFFFFF}Thay doi gia san pham #%i {AFAFAF}[%s, $%i]", biz_prices[type][listitem]/2, biz_prices[type][listitem]*2, listitem+1, name_order[type][listitem], BizInfo[bizid][bizProductPrice][listitem]);
		Dialog_Show(playerid, ConfigPricesEnd, DIALOG_STYLE_INPUT, "Cau hinh gia", mes, "Nhap", "Dong");
		return 1;
	}

	BizInfo[bizid][bizProductPrice][listitem] = money;
	SendSyntaxMessage(playerid,"Ban da thanh doi gia san pham {FF6347}%s {FFFFFF}thanh {FF6347}$%i{FFFFFF}.", name_order[type][listitem], BizInfo[bizid][bizProductPrice][listitem]);
	
	Save_Business(bizid);
	DeletePVar(playerid,"ConfigPrices");
	return 1;
}

Dialog:StoreDialog(playerid, response, listitem, inputtext[])
{
	if (!response)	return 1;

	new bizid = GetNearInsideBiz(playerid);

	if (bizid == -1)														return 1;
    if (BizInfo[bizid][bizOwnerID] != 0 && !BizInfo[bizid][bizProduct])	return SendErrorMessage(playerid,"Khong co du san pham trong doanh nghiep.");
    if (GetCash(playerid) < BizInfo[bizid][bizProductPrice][listitem])	return SendNotCash(playerid);
	
	if (BizInfo[bizid][bizType] == BIZ_STORE)
	{
		switch(listitem)
		{
			case 0:
			{
				SetPlayerNumber(playerid);
				SendSyntaxMessage(playerid,"Ban da mua mot The SIM voi gia $%i.", BizInfo[bizid][bizProductPrice][listitem]);
			}
			case 1:
			{
				if (GiveInvItem(playerid, INV_RADIO, 1) == -1)	return SendErrorMessage(playerid, "Tui do da day.");

				SendSyntaxMessage(playerid, "Ban da mua mot cai bo dam voi gia $%i.", BizInfo[bizid][bizProductPrice][listitem]);
				SendSyntaxMessage(playerid, "Su dung /radiohelp de biet them chi tiet. ");
			}
			case 2:
			{
				if (PlayerInfo[playerid][pLevel] < 2)			return SendErrorMessage(playerid, "Ban can dat cap do 2 de mua mat na.");
				if (GiveInvItem(playerid, INV_MASK, 1) == -1)	return SendErrorMessage(playerid, "Tui do da day.");
				
				SendSyntaxMessage(playerid, "Ban da mua mat na voi gia $%i.", BizInfo[bizid][bizProductPrice][listitem]);
				SendHelpMessage(playerid, "/mask de deo no. ");
			}
			case 3:
			{
				if (GiveInvItem(playerid, INV_LIGHTER, 1) == -1)	return SendErrorMessage(playerid, "Tui do da day.");

				SendSyntaxMessage(playerid, "Ban da mua mot chiec bat lua voi gia $%i.", BizInfo[bizid][bizProductPrice][listitem]);
			}
			case 4:
			{
				if (GiveInvItem(playerid, INV_CIGAR, 20) == -1)	return SendErrorMessage(playerid, "Tui do da day.");

				SendSyntaxMessage(playerid, "Ban da mua thuoc la voi gia $%i.", BizInfo[bizid][bizProductPrice][listitem]);
			}
			case 5:
			{
				if (GiveInvItem(playerid, INV_DICE, 1) == -1)		return SendErrorMessage(playerid, "Tui do da day.");
				
				SendSyntaxMessage(playerid, "Ban da mua xuc xac voi gia $%i.", BizInfo[bizid][bizProductPrice][listitem]);
				SendHelpMessage(playerid, "/dice de tung xuc xac. ");
			}
			case 6:
			{
				if (GiveInvItem(playerid, INV_GASCAN, 1) == -1)	return SendErrorMessage(playerid, "Tui do da day.");

				SendSyntaxMessage(playerid, "Ban da mua mot binh xang voi gia $%i.", BizInfo[bizid][bizProductPrice][listitem]);
			}
			case 7:
			{
				if (GiveInvItem(playerid, INV_PEN, 1) == -1)		return SendErrorMessage(playerid, "Tui do da day.");

				SendSyntaxMessage(playerid, "Ban da mua mot cay but voi gia $%i.", BizInfo[bizid][bizProductPrice][listitem]);
				SendHelpMessage(playerid, "/note de viet vao so tay. ");
			}
			case 8:
			{
				if (GiveInvItem(playerid, INV_CARDS, 1) == -1)	return SendErrorMessage(playerid, "Tui do da day.");

				SendSyntaxMessage(playerid, "Ban da mua mot the choi voi gia $%i.", BizInfo[bizid][bizProductPrice][listitem]);
				SendHelpMessage(playerid, "/givecard de bat dau tro choi.");
			}
			case 9:
			{
				if (GiveInvItem(playerid, 43, 200) == -1)		return SendErrorMessage(playerid, "Tui do da day.");
				SendClientMessageEx(playerid, COLOR_WHITE, "Ban da mua mot cai may anh voi gia $%i.", BizInfo[bizid][bizProductPrice][listitem]);
			}
			case 10:
			{
				if (GiveInvItem(playerid, INV_SIGN, 1) == -1)	return SendErrorMessage(playerid, "Tui do da day.");
				SendSyntaxMessage(playerid, "Ban da mua mot hinh dan xe voi gia $%i.",  BizInfo[bizid][bizProductPrice][listitem]);
			}
			case 11:
			{
				if (GiveInvItem(playerid, 14, 1) == -1)	return SendErrorMessage(playerid, "Tui do da day.");
				SendSyntaxMessage(playerid, "Ban da mua mot bo hoa voi gia $%i.",  BizInfo[bizid][bizProductPrice][listitem]);
			}
		}
	}
	else if (BizInfo[bizid][bizType] == BIZ_BAR)
	{
		new name_drink[8][20] = {"beer", "vodka", "cola", "nuoc khoang", "whiskey", "brandy", "soda", "wine"};

		if (GiveInvItem(playerid, INV_BEER + listitem, 1) == -1)	return SendErrorMessage(playerid, "Tui do da day.");
		SendSyntaxMessage(playerid, "Ban da mua %s voi gia $%i.", name_drink[listitem], BizInfo[bizid][bizProductPrice][listitem]);
	}
	else if (BizInfo[bizid][bizType] == BIZ_PHARMACY)
	{
		switch(listitem)
		{
			case 0:
			{
				if (PlayerInfo[playerid][pPrescribe] < gettime())		return SendErrorMessage(playerid, "Ban khong co cong thuc.");
				if (PlayerInfo[playerid][pGanjaTime] > gettime())		return SendErrorMessage(playerid, "Ban chi co the lay can sa y te thong qua: %s.", ConvertSecond(PlayerInfo[playerid][pGanjaTime] - gettime()));
				if (GiveInvItem(playerid, INV_MED_GANJA, 2) == -1)		return SendErrorMessage(playerid, "Tui do da day.");

				PlayerInfo[playerid][pGanjaTime] = gettime() + 86400;
				SendSyntaxMessage(playerid, "Ban da mua can sa y te voi gia $%i.", BizInfo[bizid][bizProductPrice][listitem]);
			}
			case 1:
			{
				if (IsPlayerHasItem(playerid, INV_HEAL))	  return SendErrorMessage(playerid,"Ban da co mot bo so cuu.");
				if (GiveInvItem(playerid, INV_HEAL, 1) == -1) return SendErrorMessage(playerid, "Tui do da day.");
					
				SendSyntaxMessage(playerid, "Ban da mua mot bo so cuu voi gia $%i.", BizInfo[bizid][bizProductPrice][listitem]);
			}
			case 2..11: //103..112 
			{
				if (GiveFloatInvItem(playerid, 101+listitem, 100.0) == -1)	return SendErrorMessage(playerid, "Tui do da day.");
				SendSyntaxMessage(playerid, "Ban da mua '%s' voi gia $%i.", name_order[6][listitem], BizInfo[bizid][bizProductPrice][listitem]);
			}
		}
	}
	else return 1;

	if (BizInfo[bizid][bizOwnerID] != 0)
 	{
 		BizInfo[bizid][bizProduct]--;
		GiveBizCash(bizid, BizInfo[bizid][bizProductPrice][listitem]);
	}

	GiveCash(playerid, -BizInfo[bizid][bizProductPrice][listitem]);
	return 1;
}

Dialog:ComputerStore(playerid, response, listitem, inputtext[])
{
	if (!response)	return 1;

	if (IsPlayerPhoneCreated(playerid)) 	Phone_Hide(playerid);
	else 								LoadPhoneTextDraw(playerid);
	
	PlayerTextDrawBoxColor(playerid, PhDisplay[playerid], 255);
	PlayerTextDrawShow(playerid, PhDisplay[playerid]);

	PlayerTextDrawBoxColor(playerid, PhoneTDbox[0][playerid], phone_display_color[listitem]);
	PlayerTextDrawShow(playerid, PhoneTDbox[0][playerid]);

	for(new i = 1; i < 5; i++)
	{
		if (i < 3) PlayerTextDrawColor(playerid, PhoneTDbox[i][playerid], phone_model_color[listitem]);
		PlayerTextDrawShow(playerid, PhoneTDbox[i][playerid]);
		if (i < 4) PlayerTextDrawShow(playerid, PhArrow[i][playerid]);
	}

	for(new i = 0; i < 2; i++) 
	{
		PlayerTextDrawColor(playerid, PhBtn[i][playerid], phone_btns_color[listitem]);
		PlayerTextDrawBackgroundColor(playerid,PhBtn[i][playerid], phone_btns_color[listitem]);
		PlayerTextDrawShow(playerid, PhBtn[i][playerid]);
	}

	new phone_names[5][10] = {"den", "xanh", "do", "xanh la", "cam"};
	new diatxt[64];

	format(diatxt, sizeof(diatxt), "{FFFFFF}Ban co muon mua chiec dien thoai co mau %s? ", phone_names[listitem]);
	FreezePlayer(playerid);

	SetPVarInt(playerid, #buing_phone, listitem+1);
	ConfirmDialog(playerid, "Mua dien thoai", diatxt, "BuyingPhone");
	return 1;
}

this::BuyingPhone(playerid, response)
{
	if (!response)	
	{
		new listitem = PlayerInfo[playerid][pPhoneModel];
		PlayerTextDrawBoxColor(playerid, PhoneTDbox[0][playerid], phone_display_color[listitem]);
	
		for(new i = 0; i < 5; i++)
		{
			if (i < 3) PlayerTextDrawColor(playerid,PhoneTDbox[i][playerid], phone_model_color[listitem]);
			PlayerTextDrawHide(playerid, PhoneTDbox[i][playerid]);
			if (i < 4) PlayerTextDrawHide(playerid, PhArrow[i][playerid]);
		}

		for(new i = 0; i < 2; i++) 
		{
			PlayerTextDrawColor(playerid,PhBtn[i][playerid], phone_btns_color[listitem]);
			PlayerTextDrawBackgroundColor(playerid,PhBtn[i][playerid], phone_btns_color[listitem]);
			PlayerTextDrawHide(playerid, PhBtn[i][playerid]);
		}

		PlayerTextDrawHide(playerid, PhDisplay[playerid]);

		SetPVarInt(playerid, #buing_phone, 0);
		cmd::buy(playerid, "");
		return UnFreezePlayer(playerid);
	}

	new listitem = GetPVarInt(playerid, #buing_phone),
		phone_names[5][10] = {"den", "xanh", "do", "xanh la", "cam"};

    //if (PlayerInfo[playerid][pPhoneModel] == listitem-1)	return SendErrorMessage(playerid, "You already have such a phone.");
	if (GetCash(playerid) < MOBILEMODELPRICE)				return SendNotCash(playerid);

	GiveCash(playerid, -MOBILEMODELPRICE);

	if (!PlayerInfo[playerid][pNumber])	SetPlayerNumber(playerid);

	PlayerInfo[playerid][pPhoneModel] = listitem;

	SendSyntaxMessage(playerid, "Ban da mua mot chiec dien thoai mau %s.", phone_names[listitem]);
	SendHelpMessage(playerid, "Nhan Y hoac nhap (/ph)one de mo dien thoai.");

	UnFreezePlayer(playerid);
	SetPVarInt(playerid, #buing_phone, 0);
	
	for(new i = 0; i < 5; i++) {
		PlayerTextDrawHide(playerid, PhoneTDbox[i][playerid]);
		if (i < 4) PlayerTextDrawHide(playerid, PhArrow[i][playerid]);
	}

	for(new i = 0; i < 2; i++) PlayerTextDrawHide(playerid, PhBtn[i][playerid]);
	PlayerTextDrawHide(playerid, PhDisplay[playerid]);
		
	return 1;
}

Dialog:ChangeBizInterior(playerid, response, listitem, inputtext[])
{
	if (!response)	return 1;

	new index, bizid = GetPVarInt(playerid, "biz_change");

    if (bizid < 0 || bizid > MAX_BIZ-1 || !BizInfo[bizid][bizID])	return SendErrorMessage(playerid,"Doanh nghiep khong ton tai duoi ID nay.");

    for(new i = 0; i < MAX_INTERIORS; i++)
	{
		if (!AdminTeles[i][telesOn] || BUSSINESS_INT_TYPE != AdminTeles[i][telesType]) continue;

		if (index == listitem)
		{
		    index = i;
		    break;
		}
		index++;
	}

	SetBizInterior(playerid, bizid, index);
	return 1;
}
