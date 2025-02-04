ALTX:biz("/business");
CMD:biz(playerid, params[])
{
	new option[16], secoption[129];
	if (sscanf(params, "s[16]S()[128]", option, secoption))
	{
		SendHelpMessage(playerid, "/biz [buy / text / name / info]");
		SendSyntaxMessage(playerid, "Cac lenh khac: /bmenu /furniture");
		return 1;
	}
	
	new bizid;

	if ((bizid = GetNearOutsideBiz(playerid)) == -1) 				bizid = GetNearInsideBiz(playerid);
	if (bizid == -1)													return SendErrorMessage(playerid, "Khong co doanh nghiep nao gan ban. ");

	if (CompareStrings(option, "info"))
	{
		if (BizInfo[bizid][bizOwnerID] != PlayerInfo[playerid][pID])		return SendErrorMessage(playerid, "Doanh nghiep nay khong thuoc ve ban.");
		
		new diatxt[300];
		format(diatxt, sizeof(diatxt), "{FFFFFF}bdID:\t\t\t%i\nTen:\t\t %s\nLoai doanh nghiep:\t\t %s\nTrang thai:\t\t %s\n", BizInfo[bizid][bizID], BizInfo[bizid][bizName], biz_types[BizInfo[bizid][bizType]], (BizInfo[bizid][bizLocked]) ? ("Closed") : ("Open"));
		format(diatxt, sizeof(diatxt), "%sSo tien:\t\t $%i\nPhi vao cua:\t $%i\n\nTinh trang kho hang: %i / 400\n", diatxt, BizInfo[bizid][bizCash], BizInfo[bizid][bizEntrance], BizInfo[bizid][bizProduct]);

		new id = biz_prod_types[BizInfo[bizid][bizType]];

		format(diatxt, sizeof(diatxt), "%sDat hang: %s voi gia $%i / 1 san pham", diatxt, truckcargo_product[id], BizInfo[bizid][bizBuyPrice]);

		Dialog_Show(playerid, None, DIALOG_STYLE_MSGBOX, "Thong tin Doanh Nghiep", diatxt, ">>", "");
		return 1;
	}

	else if (CompareStrings(option, "fee"))
	{
		if (BizInfo[bizid][bizOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Doanh nghiep nay khong thuoc ve ban.");

		new fee;

		if (sscanf(secoption, "i", fee)) return SendErrorMessage(playerid, "/biz fee [gia (0-100)]");
		if (fee < 0 || fee > 100) 		 return SendErrorMessage(playerid, "Phi vao cua chi tu $0 - $100.");

		BizInfo[bizid][bizEntrance] = fee;
		SQL_SetInteger("business", "entrance", BizInfo[bizid][bizEntrance], BizInfo[bizid][bizID]);
		SendSyntaxMessage(playerid, "Ban da dat phi vao cua cho doanh nghiep la [ID: %d] $%i.", bizid, fee);
		return 1;
	}

	else if (CompareStrings(option, "text"))
	{
		if (BizInfo[bizid][bizOwnerID] != PlayerInfo[playerid][pID]) return SendErrorMessage(playerid, "Doanh nghiep nay khong thuoc ve ban.");

		new name[129];
		
		if (sscanf(secoption, "s[128]", name))
		{
			SendHelpMessage(playerid, "/biz text [text]");
			SendSyntaxMessage(playerid, "De xoa van ban gi dang nhap, nhap {FFFF00}/biz text delete"); 
			SendSyntaxMessage(playerid, "Mau HTML co the duoc su dung trong van ban. Vi du ve mau sac: ~FFFF00~ - mau vang.");
			SendSyntaxMessage(playerid, "Vi du van ban \"~FFFF00~Hello\" se hien thi van ban nay - \"{FFFF00}Hello\""); //��������
			return 1;
		}
		if (CompareStrings(name, "delete"))
		{
			
			return 1;
		}

		if (strlen(name) < 2 || strlen(name) > 127)	return SendErrorMessage(playerid, "Van ban doanh nghiep khong duoc chua nhieu hon 127 ky tu.");
		if (strfind(name, "\n", true) != -1) 		return SendErrorMessage(playerid, "Ban khong the thay doi so dong trong ten doanh nghiep.");

		format(BizInfo[bizid][bizMes], 128, "%s", name);
		place_color(BizInfo[bizid][bizMes]);
		SQL_SetString("business", "entermsg", BizInfo[bizid][bizMes], BizInfo[bizid][bizID]);
		SendSyntaxMessage(playerid, "Ban da dat van ban khi vao doanh nghiep la: %s", BizInfo[bizid][bizMes]);
		return 1;
	}

	else if (CompareStrings(option, "name"))
	{
		if (BizInfo[bizid][bizOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Doanh nghiep nay khong thuoc ve ban.");

		new name[32];
	
		if (sscanf(secoption, "s[32]", name)) 		return SendHelpMessage(playerid, "/biz name [ten]");
		if (strlen(name) > 30)						return SendErrorMessage(playerid, "Ten doanh nghiep co the dai toi da 30 ky tu. ");
		if (strfind(name, "~n~", true) != -1)		return SendErrorMessage(playerid, "Ban khong the thay doi so dong trong ten doanh nghiep.");
		if (CheckTextDrawString(name))				return SendErrorMessage(playerid, "Ten doanh nghiep khong duoc chua ky tu '~'.");

		format(BizInfo[bizid][bizName], 32, "%s", name);
		SQL_SetString("business", "name", BizInfo[bizid][bizName], BizInfo[bizid][bizID]);
		SendSyntaxMessage(playerid, "Ban da dat ten doanh nghiep la: %s", BizInfo[bizid][bizName]);
		return 1;
	}
	
	else if (CompareStrings(option, "deposit"))
	{
		if (BizInfo[bizid][bizOwnerID] != PlayerInfo[playerid][pID]) return SendErrorMessage(playerid, "Doanh nghiep nay khong thuoc ve ban.");

		new amount;

		if (sscanf(secoption, "d", amount))
		{
			SendHelpMessage(playerid, "/biz deposit [money]");
			SendSyntaxMessage(playerid, "Hien tai dang co $%i", BizInfo[bizid][bizCash]);
			return 1;
		}
		if (GetCash(playerid) < amount || amount < 1)		return SendNotCash(playerid);
		if (BizInfo[bizid][bizCash] + amount > 25000000)	return SendErrorMessage(playerid, "Khi thanh toan, khong qua $25.000.000.");

		GiveCash(playerid, -amount);
		GiveBizCash(bizid, amount);
		SQL_SetInteger("business", "cash", BizInfo[bizid][bizCash], BizInfo[bizid][bizID]);
		SendSyntaxMessage(playerid, "Ban da dua vao thanh toan $%i.", amount);
		return 1;
	}

	else if (CompareStrings(option, "withdraw"))
	{
		if (BizInfo[bizid][bizOwnerID] != PlayerInfo[playerid][pID]) return SendErrorMessage(playerid, "Doanh nghiep nay khong thuoc ve ban.");
		
		new amount;

		if (sscanf(secoption, "d", amount))
		{
			SendHelpMessage(playerid, "/biz withdraw [money]");
			SendSyntaxMessage(playerid, "Hien tai dang co $%i.", BizInfo[bizid][bizCash]);
			return 1;
		}
		if (BizInfo[bizid][bizCash] < amount) 	return SendErrorMessage(playerid, "Khong co du tien trong thanh toan.");
		if (amount < 1 || amount > 25000000)	return SendErrorMessage(playerid, "Ban co the bo ra it nhat $1 va khong qua $25.000.000.");

		GiveCash(playerid, amount);
		GiveBizCashWithdraw(playerid, -amount);
		SQL_SetInteger("business", "cash", BizInfo[bizid][bizCash], BizInfo[bizid][bizID]);
		SendSyntaxMessage(playerid, "Ban da lay tu thanh toan $%i.", amount);
		return 1;
	}

	else if (CompareStrings(option, "buy"))
	{
		if (GetPlayerBizes(playerid) >= GetMaxPlayerBiz(playerid)) 		return SendErrorMessage(playerid, "Ban khong the mua them doanh nghiep.");
		if (BizInfo[bizid][bizOwnerID] != 0) 							return SendErrorMessage(playerid, "Doanh nghiep nay khong duoc ban.");
		if (BizInfo[bizid][bizFreeze] != 0) 							return SendErrorMessage(playerid, "Khong the mua doanh nghiep nay.");
		if (PlayerInfo[playerid][pLevel] < BizInfo[bizid][bizLevelbuy])	return SendErrorMessage(playerid, "De mua doanh nghiep nay, ban can cap do %i.", BizInfo[bizid][bizLevelbuy]);
		if (GetCash(playerid) < BizInfo[bizid][bizPrice])				return SendNotCash(playerid);

		BizInfo[bizid][bizOwnerID] = PlayerInfo[playerid][pID];
		BizInfo[bizid][bizLocked] = 0;
		BizInfo[bizid][bizProduct] = 150;
		BizInfo[bizid][bizBuyPrice] = 50;
		format(BizInfo[bizid][bizOwner], MAX_PLAYER_NAME, "%s", GetNameEx(playerid));
		GiveCash(playerid, -BizInfo[bizid][bizPrice]);
		Save_Business(bizid);
		SendSyntaxMessage(playerid, "Ban da mua doanh nghiep %s voi gia $%i.", BizInfo[bizid][bizName], BizInfo[bizid][bizPrice]);

		for(new i = 0; i < MAX_GARAGES; i++)
		{
			if (!GarageInfo[i][garageID] || GarageInfo[i][garageBiz] != BizInfo[bizid][bizID]) continue;
			
			GarageInfo[i][garageOwner] = PlayerInfo[playerid][pID];
			SQL_SetInteger("garage", "owner", GarageInfo[i][garageOwner], GarageInfo[i][garageID]);
			SendSyntaxMessage(playerid, "Cung voi doanh nghiep, ban da co mot ga ra [ID: %i].", i);
		}

		new mes[256];
		format(mes, sizeof(mes), "%s [MYSQL: %i | IP: %s | Money (WAS): %i | Money (BECOME): %i] mua mot doanh nghiep [B_MYSQL: %i] voi gia -- $%i.", 
		GetName(playerid), PlayerInfo[playerid][pID], q_GetPlayerIP(playerid), PlayerInfo[playerid][pCash] + BizInfo[bizid][bizPrice], GetCash(playerid), BizInfo[bizid][bizID], BizInfo[bizid][bizPrice]);
		insert_log(mes, PROPERTY_LOG, 4, PlayerInfo[playerid][pAccID]);
		return 1;
	}

	else if (CompareStrings(option, "Ban"))
	{
		if (BizInfo[bizid][bizOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Doanh nghiep nay khong thuoc ve ban.");

		static const str_size[] = "{FFFFFF}Ban muon ban doanh nghiep cua minh voi gia $%i?";
		new mes[sizeof(str_size) - 2 + 12];

		format(mes, sizeof(mes), str_size, BizInfo[bizid][bizPrice] / 2);
		Dialog_Show(playerid, SellBiz, DIALOG_STYLE_MSGBOX, "{FFFFFF}Ban doanh nghiep", mes, "Ban", "Huy bo");
		return 1;
	}

	else if (CompareStrings(option, "buyprod"))
	{
		if (BizInfo[bizid][bizOwnerID] != PlayerInfo[playerid][pID]) return SendErrorMessage(playerid, "Doanh nghiep nay khong thuoc ve ban.");

		new price, id = biz_prod_types[BizInfo[bizid][bizType]];

		if (id == -1)						return SendErrorMessage(playerid, "Doanh nghiep cua ban khong can san pham.");
		if (sscanf(secoption, "i", price))	return SendHelpMessage(playerid, "/biz buyprod [price]");
		if (price > 50 && price < 1000) 		return SendErrorMessage(playerid, "Gia mua tu $50 den $1000.");

		BizInfo[bizid][bizBuyPrice] = price;
		SQL_SetInteger("business", "buy_price", price, BizInfo[bizid][bizID]);
		SendSyntaxMessage(playerid, "Bay gio ban dang mua %s voi gia $%i cho mot don vi.", truckcargo_product[id], price);
		return 1;
	}

	else if (CompareStrings(option, "upgrade"))
	{
		new opt[16];

		if (BizInfo[bizid][bizOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Doanh nghiep nay khong thuoc ve ban.");
		if (sscanf(secoption, "s[16]", opt)) 
		{
			SendHelpMessage(playerid, "/biz upgrade [radio | repairdoor]");
			return 1;
		}

		if (CompareStrings(opt, "radio"))
		{
			if (BizInfo[bizid][bizRadio] == 1)				return SendErrorMessage(playerid, "Radio da duoc cai dat trong doanh nghiep nay.");
			if (GetCash(playerid) < UPGRADE_PRICE_RADIO)	return SendErrorMessage(playerid, "Gia cua radio la $%i.", UPGRADE_PRICE_RADIO);

			BizInfo[bizid][bizRadio] = 1;
			SQL_SetInteger("business", "radio", BizInfo[bizid][bizRadio], BizInfo[bizid][bizID]);
			GiveCash(playerid, -UPGRADE_PRICE_RADIO);
			SendSyntaxMessage(playerid, "Ban da mua mot dai phat thanh cho doanh nghiep cua minh.");
			SendSyntaxMessage(playerid, "Nhap /setstation de su dung radio. ");
			return 1;
		}

		else if (CompareStrings(opt, "repairdoor"))
		{
			if (BizInfo[bizid][bizDDoor] == 0)			return SendErrorMessage(playerid, "Cua khong can sua.");
			if (GetCash(playerid) < UPGRADE_PRICE_DOOR)	return SendErrorMessage(playerid, "Gia sua canh cua la $%i.", UPGRADE_PRICE_DOOR);

			BizInfo[bizid][bizDDoor] = 0;
			SQL_SetInteger("business", "ddoor", BizInfo[bizid][bizDDoor], BizInfo[bizid][bizID]);
			UpdateBusinessDoor(bizid);
			GiveCash(playerid, -UPGRADE_PRICE_DOOR);
			SendSyntaxMessage(playerid, "Ban da sua canh cua voi gia $%i.", UPGRADE_PRICE_DOOR);
			return 1;
		}
	}

	else if (CompareStrings(option, "hire"))
	{
		if (BizInfo[bizid][bizOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Doanh nghiep nay khong thuoc ve ban.");

		new userid;

		if (sscanf(secoption, "u", userid))				return SendHelpMessage(playerid, "/biz hire [ID/Ten]");
		if (userid == playerid)							return SendErrorMessage(playerid, "Ban khong the thue chinh minh.");
		if (!IsPlayerLogged(userid))					return SendNotConnected(playerid);
		if (!PlayerNearPlayer(3.0, playerid, userid))	return SendNotNearPlayer(playerid);
		if (pTemp[userid][pHirePlayer] == playerid)		return SendErrorMessage(playerid, "Ban da cung cap cho nguoi choi mot cong viec.");

		pTemp[userid][pHirePlayer] = playerid;
		SetPVarInt(userid, #accept_time, gettime() + 30);
		SendSyntaxMessage(userid, "%s moi ban vao lam viec trong doanh nghiep.", GetNameWithMask(playerid));
		SendHelpMessage(userid, "Nhan Y de chap nhan loi de nghi.");
		SendSyntaxMessage(playerid, "Ban da moi %s vao lam viec cho doanh nghiep cua ban.", GetNameWithMask(userid));
		return 1;
	}

	else if (CompareStrings(option, "fire"))
	{
		if (BizInfo[bizid][bizOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Doanh nghiep nay khong thuoc ve ban.");
	
		new userid;

		if (sscanf(secoption, "u", userid))							return SendHelpMessage(playerid, "/biz fire [ID/Ten]");
		if (userid == playerid)										return SendErrorMessage(playerid, "Ban khong the sa thai chinh minh.");
		if (!IsPlayerLogged(userid))								return SendNotConnected(playerid);
		if (PlayerInfo[userid][pWorkOn] != BizInfo[bizid][bizID])	return SendErrorMessage(playerid, "Nguoi choi khong lam viec trong doanh nghiep cua ban.");

		PlayerInfo[userid][pWorkOn] = 0;

		SendSyntaxMessage(userid, "%s da sa thai ban khoi doanh nghiep.", GetNameWithMask(playerid));
		SendSyntaxMessage(playerid, "Ban da sa thai %s khoi doanh nghiep cua minh.", GetNameWithMask(userid));
		return 1;
	}

	else if (CompareStrings(option, "prices"))
	{
		if (BizInfo[bizid][bizOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Doanh nghiep nay khong thuoc ve ban.");

		new biz = BizInfo[bizid][bizType];
		if (biz != BIZ_STORE && biz != BIZ_BAR && biz != BIZ_PHARMACY && biz != BIZ_PIZZA && biz != BIZ_CLUCKIN && biz != BIZ_BURGER && biz != BIZ_DONUT)	
			return SendErrorMessage(playerid, "Ban khong the thay doi gia trong doanh nghiep nay.");
		
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
			format(mes, sizeof(mes), "%s{FFFFFF}Chinh sua gia san pham #%i {AFAFAF}[%s, $%i]\n", mes, i+1, name_order[type][i], BizInfo[bizid][bizProductPrice][i]);
		}

		Dialog_Show(playerid, ConfigPrices, DIALOG_STYLE_LIST, "{9ACD32}Cau hinh gia", mes, "Chon", "Quay lai");
		return 1;
	}

	else
	{
		SendHelpMessage(playerid, "/biz [options]");
		SendSyntaxMessage(playerid, "info | fee | text | name | hire | fire");
		SendSyntaxMessage(playerid, "deposit | withdraw | upgrade | buyprod");
		SendSyntaxMessage(playerid, "buy | sell | prices");
	}
	return 1;
}

CMD:bmenu(playerid, params[])
{
	new bizid;

	if ((bizid = GetNearOutsideBiz(playerid)) == -1) 				bizid = GetNearInsideBiz(playerid);
	if (bizid == -1)													return SendErrorMessage(playerid, "Khong co doanh nghiep nao gan ban. ");
	if (BizInfo[bizid][bizOwnerID] != PlayerInfo[playerid][pID])		return SendErrorMessage(playerid, "Doanh nghiep nay khong thuoc ve ban.");

	static diastr[] = "Thong tin doanh nghiep\n\
					Thong tin nhan vien\n\
					Thanh toan - gui / rut\n\
					Cau hinh gia\n\
					Cai tien doanh nghiep\n\
					Chinh sua noi that\n\
					Mua san pham\n\
					Thay doi ten\n\
					Thay doi MOTD o loi vao\n\
					Ban doanh nghiep";

	Dialog_Show(playerid, BusinessMenu, DIALOG_STYLE_LIST, "Menu doanh nghiep", diastr, "Chon", "Thoat");
	return 1;
}

CMD:meal(playerid, params[])
{
	if (isnull(params))
	{
		SendHelpMessage(playerid, "/meal [tuy chon]");
		SCM(playerid, COLOR_LIGHTRED,"/meal order {FFFFFF}- mo menu voi cac mon an.");
		SCM(playerid, COLOR_LIGHTRED,"/meal place {FFFFFF}- dat mon an tren ban. ");
		SCM(playerid, COLOR_LIGHTRED,"/meal pickup {FFFFFF}- lay mot mon an tu tren ban. ");
		SCM(playerid, COLOR_LIGHTRED,"/meal throw {FFFFFF}- vut khay. ");
		return 1;
	}

	if (CompareStrings(params, "order"))
	{
	    new bizid;

		if ((bizid = GetNearInsideBiz(playerid)) == -1)	return SendErrorMessage(playerid, "Ban phai o trong doanh nghiep. ");
		if (BizInfo[bizid][bizType] != BIZ_PIZZA && BizInfo[bizid][bizType] != BIZ_CLUCKIN && BizInfo[bizid][bizType] != BIZ_BURGER && BizInfo[bizid][bizType] != BIZ_DONUT)
		{
		    SendErrorMessage(playerid, "Ban khong o trong nha hang.");
			return 1;
		}

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
		return 1;
	}

	else if (CompareStrings(params, "place"))
	{
        if (!pTemp[playerid][pFoodStand]) return SendErrorMessage(playerid, "Ban khong co khay trong tay.");

		new dropid = -1;
        for(new i; i != MAX_FOOD_DROPS; i++)
        {
            if (FoodDrop[i][foodDropped] != 0)	continue;

			dropid = i;
			break;
		}

		if (dropid == -1) return SendErrorMessage(playerid, "Da dat den so luong khay thuc an toi da.");

        RemovePlayerAttachedObject(playerid, ATTACH_HANDS);
        GetXYInFrontOfPlayer(playerid, FoodDrop[dropid][foodPosX], FoodDrop[dropid][foodPosY], FoodDrop[dropid][foodPosZ], 0.5);
		FoodDrop[dropid][foodPosZ] -= 0.1;
		FoodDrop[dropid][foodInt] = GetInterior(playerid);
		FoodDrop[dropid][foodVW] = GetWorld(playerid);
		FoodDrop[dropid][foodModel] = pTemp[playerid][pFoodStand];
  		FoodDrop[dropid][foodObject] = CreateDynamicObject(pTemp[playerid][pFoodStand], FoodDrop[dropid][foodPosX], FoodDrop[dropid][foodPosY], FoodDrop[dropid][foodPosZ], -25.300008, 23.200012, -16.699985, GetWorld(playerid), GetInterior(playerid));
		EditDynamicObject(playerid, FoodDrop[dropid][foodObject]);
		SetPVarInt(playerid, #edit_food, dropid+1);
        FoodDrop[dropid][foodDropped] = 1;
        FoodDrop[dropid][foodTime] = 15;
		OnPlayAnim(playerid,"CASINO","cards_win",4.1,0,0,0,0,0);
		pTemp[playerid][pFoodStand] = 0;
		SendSyntaxMessage(playerid, "Ban dang chinh sua vi tri cua khay. Nhan \"SPACE\" - de di chuyen may anh.");
		return 1;
	}

	else if (CompareStrings(params, "pickup"))
	{
	    if (pTemp[playerid][pFoodStand] != 0 || IsPlayerAttachedObjectSlotUsed(playerid, ATTACH_HANDS)) return SendWarningMessage(playerid, "Ban tay cua ban dang duoc thuc hien..");

		new dropid = DropFood_Nearest(playerid);

		if (dropid == -1) return SendErrorMessage(playerid, "Khong co khay ben canh ban.");

		OnPlayAnim(playerid,"CARRY","crry_prtial",4.1,1,1,1,1,1);
		SetPlayerAttachedObject(playerid, ATTACH_HANDS, FoodDrop[dropid][foodModel], 5, 0.091998, 0.021999, 0.409, -104.9, 27.6, 0, 1, 1, 1);
        pTemp[playerid][pFoodStand] = FoodDrop[dropid][foodModel];
        FoodDrop[dropid][foodModel] = 0;
        FoodDrop[dropid][foodDropped] = 0;
        if (IsValidDynamicObject(FoodDrop[dropid][foodObject])) DestroyDynamicObject(FoodDrop[dropid][foodObject]);

		return 1;
	}

	else if (CompareStrings(params, "throw"))
	{
		if (pTemp[playerid][pFoodStand] == 0) return SendErrorMessage(playerid, "Khong co khay trong tay.");

		OnPlayAnim(playerid,"CASINO","cards_win",4.1,0,0,0,0,0);
		RemovePlayerAttachedObject(playerid, ATTACH_HANDS);
		pTemp[playerid][pFoodStand] = 0;
		return 1;
	}

	else
	{
		SendHelpMessage(playerid, "/meal [tuy chon]");
		SCM(playerid, COLOR_LIGHTRED,"/meal order {FFFFFF}- mo menu voi cac mon an.");
		SCM(playerid, COLOR_LIGHTRED,"/meal place {FFFFFF}- dat mon an tren ban. ");
		SCM(playerid, COLOR_LIGHTRED,"/meal pickup {FFFFFF}- lay mot mon an tu tren ban. ");
		SCM(playerid, COLOR_LIGHTRED,"/meal throw {FFFFFF}- vut khay. ");
	}
	return 1;
}