GetPlayerAcceptAction(playerid)
{
	if (GetPVarInt(playerid, #accept_time) < gettime()) return 0;

	if (pTemp[playerid][pGreetPlayer] != INVALID_PLAYER_ID)
	{
	    new userid = pTemp[playerid][pGreetPlayer], type = pTemp[playerid][pGreetType];

	    pTemp[playerid][pGreetPlayer] = INVALID_PLAYER_ID;
		pTemp[playerid][pGreetType] = 0;

		if (IsPlayerLogged(userid) == 0)				return SendErrorMessage(playerid, "Nguoi choi da gui loi de nghi bat tay da khong truc tuyen.");
		if (!PlayerNearPlayer(1.0, playerid, userid))	return SendNotNearPlayer(playerid);

		StopPlayerAnims(playerid);
		StopPlayerAnims(userid);
		SetPlayerFacePlayer(playerid, userid);
		SetPlayerFacePlayer(userid, playerid);
		
		switch(type)
		{
			case 1:
			{
				ApplyAnimation(playerid, "KISSING", "Playa_Kiss_02", 2.0, 0, 0, 1, 0, 0, 1);
				ApplyAnimation(userid, "KISSING", "Playa_Kiss_02", 2.0, 0, 0, 1, 0, 0, 1);
			}
			case 2:
			{
				ApplyAnimation(playerid, "GANGS", "hndshkfa_swt", 2.0, 0, 0, 0, 0, 0, 1);
				ApplyAnimation(userid, "GANGS", "hndshkfa_swt", 2.0, 0, 0, 0, 0, 0, 1);
			}
			case 3:
			{
				ApplyAnimation(playerid, "GANGS", "hndshkba", 2.0, 0, 0, 0, 0, 0, 1);
				ApplyAnimation(userid, "GANGS", "hndshkba", 2.0, 0, 0, 0, 0, 0, 1);
			}
			case 4:
			{
				ApplyAnimation(playerid, "GANGS", "hndshkca", 2.0, 0, 0, 0, 0, 0, 1);
				ApplyAnimation(userid, "GANGS", "hndshkca", 2.0, 0, 0, 0, 0, 0, 1);
			}
			case 5:
			{
				ApplyAnimation(playerid, "GANGS", "hndshkcb", 2.0, 0, 0, 0, 0, 0, 1);
				ApplyAnimation(userid, "GANGS", "hndshkcb", 2.0, 0, 0, 0, 0, 0, 1);
			}
			case 6:
			{
				ApplyAnimation(playerid, "GANGS", "hndshkda", 2.0, 0, 0, 0, 0, 0, 1);
				ApplyAnimation(userid, "GANGS", "hndshkda", 2.0, 0, 0, 0, 0, 0, 1);
			}
			case 7:
			{
				ApplyAnimation(playerid, "GANGS", "hndshkda", 2.0, 0, 0, 0, 0, 0, 1);
				ApplyAnimation(userid, "GANGS", "hndshkda", 2.0, 0, 0, 0, 0, 0, 1);
			}
			case 8:
			{
				ApplyAnimation(playerid, "GANGS", "hndshkaa", 2.0, 0, 0, 0, 0, 0, 1);
				ApplyAnimation(userid, "GANGS", "hndshkaa", 2.0, 0, 0, 0, 0, 0, 1);
			}
			case 9:
			{
				ApplyAnimation(playerid, "GANGS", "prtial_hndshk_biz_01", 2.0, 0, 0, 0, 0, 0, 1);
				ApplyAnimation(userid, "GANGS", "prtial_hndshk_biz_01", 2.0, 0, 0, 0, 0, 0, 1);
			}
		}
		return 1;
	}

    else if (pTemp[playerid][pCarPlayer] != INVALID_PLAYER_ID)
	{
  		new query[128];
    	mysql_format(dbHandle, query, sizeof(query), "SELECT `id` FROM `cars` WHERE `owner` = %i", PlayerInfo[playerid][pID]);
		mysql_tquery(dbHandle, query, "BuyVehicleAtPlayer", "i", playerid);
   		return 1;
	}

    else if (pTemp[playerid][pHealPlayer] != INVALID_PLAYER_ID)
	{
	    new userid = pTemp[playerid][pHealPlayer];
	    pTemp[playerid][pHealPlayer] = INVALID_PLAYER_ID;

	    if (!IsPlayerLogged(userid))				return SendErrorMessage(playerid, "Nguoi choi da de nghi dieu tri cho ban khong truc tuyen.");
        if (PlayerInfo[playerid][pInjured] != 0)	return SendErrorMessage(playerid, "Ban dang trong giai doan bi thuong / chet.");

		SendSyntaxMessage(playerid, "Ban da dieu tri cho %s.", GetNameWithMask(userid));
		SendSyntaxMessage(userid, "Ban da duoc dieu tri suc khoe boi %s.", GetNameWithMask(playerid));
		SetPlayerHealth(playerid, 100.0);
		return 1;
	}
	else if (pTemp[playerid][pWepPlayer] != INVALID_PLAYER_ID)
	{
		new userid = pTemp[playerid][pWepPlayer],
		    price = pTemp[playerid][pWepPrice];

        pTemp[playerid][pWepPlayer] = INVALID_PLAYER_ID;

		if (!IsPlayerLogged(userid))		return SendErrorMessage(playerid, "Nguoi choi cung cap giay phep vu khi cho ban khong truc tuyen.");
		if (GetCash(playerid) < price)	return SendNotCash(playerid);

		GiveCash(playerid, -price);
		PlayerInfo[playerid][pWepLic] = 1;
		PlayerInfo[playerid][pWepWarns] = 0;
        PlayerInfo[playerid][pWepCount] = 3;

        new query[168];
		mysql_format(dbHandle, query, sizeof(query), "UPDATE `users` SET `wep_count`='3',`weplic`='1',`wepwarns`='0',`wep_officer`='%s',`wep_data`='%s',`wep_price`=%i WHERE `id` = %i", GetNameEx(userid), GetFullDate(), price, PlayerInfo[playerid][pID]);
		mysql_tquery(dbHandle, query);

		SendSyntaxMessage(userid, "%s da mua giay phep vu khi tu ban voi gia $%i.", GetNameEx(playerid), price);
        SendSyntaxMessage(playerid, "Ban da mua giay phep vu khi tu %s voi gia $%i.", GetNameEx(userid), price);
		return 1;
	}

	else if (pTemp[playerid][pHirePlayer] != INVALID_PLAYER_ID)
	{
        new userid = pTemp[playerid][pHirePlayer];

        pTemp[playerid][pHirePlayer] = INVALID_PLAYER_ID;

        if (!IsPlayerLogged(userid))					return SendErrorMessage(playerid, "Nguoi choi da de nghi ban mot cong viec trong doanh nghiep khong truc tuyen.");
        if (!PlayerNearPlayer(3.0, playerid, userid))	return SendNotNearPlayer(playerid);

        new bizid;

		if ((bizid = GetNearOutsideBiz(playerid)) == -1)			return SendErrorMessage(playerid, "Khong co doanh nghiep nao gan ban.");
		if (BizInfo[bizid][bizOwnerID] != PlayerInfo[userid][pID])	return SendErrorMessage(playerid, "Ban phai o gan doanh nghiep nha tuyen dung.");

		PlayerInfo[playerid][pWorkOn] = BizInfo[bizid][bizID];
		SQL_SetInteger("users", "workon", BizInfo[bizid][bizID], PlayerInfo[playerid][pID]);

		new j = WorkSpace(bizid);
		BizWorkers[bizid][j][bizJobOn] = PlayerInfo[playerid][pID];
		format(BizWorkers[bizid][j][bizWorker], MAX_PLAYER_NAME, "%s", GetAccName(playerid));
		format(BizWorkers[bizid][j][bizPosition], MAX_PLAYER_NAME, "No position");

		SendSyntaxMessage(playerid, "�� Da chap nhan loi moi lam viec. ");
		SendSyntaxMessage(userid, "%s da chap nhan loi moi lam viec cua ban.",GetNameEx(playerid));
		return 1;
	}

	else if (pTemp[playerid][pFactionPlayer] != INVALID_PLAYER_ID)
	{
		new targetid = pTemp[playerid][pFactionPlayer];

		pTemp[playerid][pFactionPlayer] = INVALID_PLAYER_ID;

        if (!IsPlayerLogged(targetid))								return SendErrorMessage(playerid, "Nguoi choi moi ban tham gia to chuc khong truc tuyen");
        if (!isLeader(targetid) || !GetInviteRight(targetid))		return 1;
	    if (!Factions[PlayerInfo[targetid][pFaction]][fJoinRank])	return SendErrorMessage(playerid, "Tham gia bi cam. Cap bac va muc luong trong cau truc khong duoc dinh cau hinh.");

		PlayerInfo[playerid][pFaction] = PlayerInfo[targetid][pFaction];
		PlayerInfo[playerid][pRank] = Factions[PlayerInfo[targetid][pFaction]][fJoinRank];
		PlayerInfo[playerid][pBadgeNumber] = randomEx(23465, 99999);

		SendSyntaxMessage(playerid, "Ban da tham gia to chuc %s.", Factions[PlayerInfo[targetid][pFaction]][fName]);
		SendFactionMessageF(PlayerInfo[targetid][pFaction], COLOR_LIGHTBLUE, "[To chuc] %s da chap nhan loi de nghi tham gia to chuc cua %s.", GetNameEx(playerid), GetNameEx(targetid));
		return 1;
	}

	else if (RefillOffer[playerid] != INVALID_PLAYER_ID)
	{
		new userid = RefillOffer[playerid], price = RefillPrice[playerid], vehicle = GetPlayerVehicleID(playerid);

        if (!IsPlayerLogged(userid)) return SendErrorMessage(playerid, "Nguoi choi cung cap cho ban nhien lieu khong truc tuyen.");
		    
        RefillPrice[playerid] = 0;
		RefillOffer[playerid] = INVALID_PLAYER_ID;

		if (!IsDriver(playerid))						return SendErrorMessage(playerid, "Ban can phai dieu khien mot phuong tien.");
		if (!PlayerNearPlayer(6.0, playerid, userid))	return SendNotNearPlayer(playerid);
		if (GetCash(playerid) < price)					return SendNotCash(playerid);

		GiveCash(playerid, -price);
		GiveCash(userid, price);
		VehicleInfo[vehicle][carFuel] = GetVehicleFuelCapacity(GetVehicleModel(vehicle));

		new mes[128];
		format(mes, sizeof(mes), "da chap nhan loi de nghi cung cap nhien lieu cho phuong tien tu %s voi gia $%i.", GetNameWithMask(userid), price);
		cmd::me(playerid, mes);

		return 1;
	}

	else if (pTemp[playerid][pServePlayer] != INVALID_PLAYER_ID && pTemp[playerid][pServeType] == 5) //����
	{
		new mechanicid = pTemp[playerid][pServePlayer], vehicle = GetPlayerVehicleID(playerid);

		pTemp[playerid][pServePlayer] = INVALID_PLAYER_ID;
        pTemp[playerid][pServeType] = 0;

        if (!IsPlayerLogged(mechanicid))															return SendErrorMessage(playerid, "Nguoi choi de nghi keo ban khong truc tueyn.");
		if (!IsPlayerFactionMech(mechanicid))														return SendErrorMessage(playerid, "Ban khong phai la tho sua xe.");
		if (!IsDriver(mechanicid) || !IsATowTruck(GetPlayerVehicleID(mechanicid)))					return SendErrorMessage(playerid, "Nguoi tho lai xe phai dieu khien mot phuong tien keo.");
		if (!PlayerNearPlayer(7.0, playerid, mechanicid))											return SendNotNearPlayer(playerid);
        if (GetNearVehicle(mechanicid, 7.0, vehicle) == 0)											return SendErrorMessage(playerid, "Phuong tien cua ban phai o gan do.");
        if (IsABoat(vehicle) || IsAPlane(vehicle) || IsAHelicopter(vehicle) || IsABiker(vehicle))	return SendErrorMessage(playerid, "Phuong tien nay khong the keo.");

		new mes[128];
		format(mes, sizeof(mes), "took action from %s and cleared the hook %s.", GetNameWithMask(mechanicid), VehicleNames[GetVehicleModel(vehicle)-400]);
		cmd::me(playerid, mes); 

		AttachTrailerToVehicle(vehicle, GetPlayerVehicleID(mechanicid));
		return 1;
	}

	/*else if (pTemp[playerid][pServePlayer] != INVALID_PLAYER_ID && (pTemp[playerid][pServeType] > 0 && pTemp[playerid][pServeType] < 5))
	{
		new vehicle = GetPlayerVehicleID(playerid), mechanicid = pTemp[playerid][pServePlayer], type = pTemp[playerid][pServeType], vehid = GetPlayerVehicleID(mechanicid);

        pTemp[playerid][pServePlayer] = INVALID_PLAYER_ID;
        pTemp[playerid][pServeType] = 0;

        if (!IsPlayerLogged(mechanicid))										return SendErrorMessage(playerid, "The player who offered you the services of a mechanic is not online.");
       	if (!IsPlayerFactionMech(mechanicid))									return SendErrorMessage(playerid, "You are not a mechanic.");
		if (!IsDriver(mechanicid) || !IsATowTruck(vehid))						return SendErrorMessage(playerid, "The mechanic must be in the tow truck as a driver. ");
		if (!IsDriver(playerid))												return SendErrorMessage(playerid, "You must be in the driver's seat. ");
		if (!PlayerNearPlayer(6.0, playerid, mechanicid))						return SendNotNearPlayer(playerid);
        if (VehicleInfo[vehicle][carFaction] != 0 && type != 1 && type != 2)	return SendErrorMessage(playerid, "This vehicle belongs to the state structure.");

		new mes[128];

		switch(type)
		{
		    case 1: format(mes, sizeof(mes), "accepts a form for work on the engine %s.", VehicleNames[GetVehicleModel(vehicle)-400]);
		    case 2: format(mes, sizeof(mes), "accepts a form for bodywork on vehicle %s.", VehicleNames[GetVehicleModel(vehicle)-400]);
		    case 3: format(mes, sizeof(mes), "accepts a form for repairing damage over vehicle %s.", VehicleNames[GetVehicleModel(vehicle)-400]);
		    case 4: format(mes, sizeof(mes), "accepts a form for painting %s.", VehicleNames[GetVehicleModel(vehicle)-400]);
		}
		cmd::me(playerid, mes);

		RepairOffer[mechanicid] = playerid;
		RepairToVehicle[mechanicid] = vehicle;
		RepairService[mechanicid] = type;
		RepairTowTruck[mechanicid] = vehid;

		ShowJobMessage(mechanicid, "~h~~p~PULL OUT YOUR SPRAYCAN.");
		switch(type)
		{
		    case 1: // Engine and Visual Repair
			{
				new Float: health;
				AntiCheatGetVehicleHealth(GetPlayerVehicleID(playerid), health);

				new panels, doors, lights, tires;
				GetVehicleStatus(playerid, panels, doors, lights, tires);

				new
					model = GetVehicleModel(vehicle),
					hp_cost = floatround(((health/GetVehicleMaxHealth(model))) * (GetVehiclePrice(model)/1000), floatround_round),
					cost = floatround(GetVehiclePrice(model) / 4, floatround_round),
					common_cost = hp_cost +  floatround((cost * 0.5 * panels/100) + (cost * 0.25 * doors/100) + (cost * 0.1 * lights/100) + (cost * 0.15 * tires/100), floatround_round)
				;

				if (GetCash(playerid) < common_cost)
				{
					return SendErrorMessage(playerid, "For repairs you need $%i. ", common_cost);
				}	

				StartVehicleUpgrade(playerid, vehicle, 13, common_cost);
				UpdateDynamic3DTextLabelText(status_update[vehicle], 0x33AA33FF, "(( ---------- ))\nVEHICLE REPAIR");
			} 
		    case 2: // Health Repair Only
			{
				format(mes, sizeof(mes), "accepts a form for bodywork on vehicle %s.", VehicleNames[GetVehicleModel(vehicle)-400]);
			} 
		    case 3: // Battery Repair
			{
				format(mes, sizeof(mes), "accepts a form for repairing damage over vehicle %s.", VehicleNames[GetVehicleModel(vehicle)-400]);
			} 
		    case 4: // Engine Health Repair
			{
				format(mes, sizeof(mes), "accepts a form for painting %s.", VehicleNames[GetVehicleModel(vehicle)-400]);
			} 
		}
		return 1;
	}*/

	else if (pTemp[playerid][pVendingPlayer] != INVALID_PLAYER_ID)
	{
	    new userid = pTemp[playerid][pVendingPlayer], price = pTemp[playerid][pVendingPrice], vendingid = pTemp[playerid][pVendingVending];

        pTemp[playerid][pVendingVending] = -1;
		pTemp[playerid][pVendingPrice] = 0;
		pTemp[playerid][pVendingPlayer] = INVALID_PLAYER_ID;

        if (!IsPlayerLogged(userid))											return SendErrorMessage(playerid, "Nguoi choi de nghi ban mua may ban hang khong truc tuyen");
		if (vendingid == -1)													return SendErrorMessage(playerid, "Khong co ai de nghi ban mua may ban hang.");
        if (price < 0 || price > 100000000)										return SendErrorMessage(playerid, "So tien co the ban tu $0 den $100000000.");
		if (!PlayerNearPlayer(3.0, playerid, userid))							return SendNotNearPlayer(playerid);
	    if (IsPlayerOutsideHouse(playerid, vendingid) == 0)						return SendErrorMessage(playerid, "Ban phai o gan may ban hang ban muon mua.");
		if (VendingInfo[vendingid][vendingOwnerID] != PlayerInfo[userid][pID])	return SendErrorMessage(playerid, "May ban hang nay khong thuoc so huu cua %s.", GetNameEx(userid));
		if (GetCash(playerid) < price)											return SendNotCash(playerid);

		VendingInfo[vendingid][vendingOwnerID] = PlayerInfo[playerid][pID];
        format(VendingInfo[vendingid][vendingOwner], MAX_PLAYER_NAME, GetNameEx(playerid));
		GiveCash(playerid, -price);
		GiveCash(userid, price);

		Save_VM(vendingid);

		SendSyntaxMessage(playerid, "Ban da mua may ban hang tu dong tu %s voi gia $%i.", GetNameEx(userid), price);
    	SendSyntaxMessage(userid, "%s da mua may ban hang tu dong tu ban voi gia $%i.", GetNameEx(playerid), price);
    	return 1;
	}

	else if (pTemp[playerid][pHousePlayer] != INVALID_PLAYER_ID)
	{
	    new userid = pTemp[playerid][pHousePlayer], price = pTemp[playerid][pHousePrice], houseid = pTemp[playerid][pHouseHouse];

        pTemp[playerid][pHouseHouse] = -1;
		pTemp[playerid][pHousePrice] = 0;
		pTemp[playerid][pHousePlayer] = INVALID_PLAYER_ID;

        if (!IsPlayerLogged(userid))									return SendErrorMessage(playerid, "Nguoi choi de nghi ban mua nha khong truc tuyen.");
		if (houseid == -1)												return SendErrorMessage(playerid, "Khong co ai de nghi ban mua nha.");
        if (price < 0 || price > 100000000)								return SendErrorMessage(playerid, "So tien co the ban tu $0 den $100000000.");
		if (!PlayerNearPlayer(3.0, playerid, userid))					return SendNotNearPlayer(playerid);
	    if (IsPlayerOutsideHouse(playerid, houseid) == 0)				return SendErrorMessage(playerid, "Ban phai o gan mot ngoi nha ban muon mua.");
		if (HouseInfo[houseid][hOwnerID] != PlayerInfo[userid][pID])	return SendErrorMessage(playerid, "Ngoi nha nay khong thuoc so huu cua %s.", GetNameEx(userid));
		if (GetCash(playerid) < price)									return SendNotCash(playerid);
        if (GetPlayerHouses(playerid) >= GetMaxPlayerHouse(playerid))	return SendErrorMessage(playerid, "Ban khong the mua nhieu ngoi nha. ");

		HouseInfo[houseid][hOwnerID] = PlayerInfo[playerid][pID];
        format(HouseInfo[houseid][hOwner], MAX_PLAYER_NAME, GetNameEx(playerid));
		GiveCash(playerid, -price);
		GiveCash(userid, price);

        for(new i = 0; i != MAX_GARAGES; i++)
		{
		    if (!GarageInfo[i][garageID] || GarageInfo[i][garageHouse] != HouseInfo[houseid][hID]) continue;

			SendSyntaxMessage(playerid, "Cung voi ngoi nha, ban co mot Nha de xe [ID: %i].", i);

			GarageInfo[i][garageOwner] = PlayerInfo[playerid][pID];
			format(GarageInfo[i][garageOwnerName], 24, "%s", GetNameEx(playerid));
		
			SQL_SetInteger("garage", "owner", GarageInfo[i][garageOwner], GarageInfo[i][garageID]);
			SQL_SetString("garage", "ownername", GarageInfo[i][garageOwnerName], GarageInfo[i][garageID]);
		}

		Save_House(houseid);

		SendSyntaxMessage(playerid, "Ban da mua mot ngoi nha tu %s voi gia $%i.", GetNameEx(userid), price);
    	SendSyntaxMessage(userid, "%s mua mot ngoi nha tu ban voi gia $%i.", GetNameEx(playerid), price);
    	return 1;
	}

	else if (pTemp[playerid][pBizPlayer] != INVALID_PLAYER_ID)
	{
	    new userid = pTemp[playerid][pBizPlayer], price = pTemp[playerid][pBizPrice], bizid = pTemp[playerid][pBizID];

        pTemp[playerid][pBizPlayer] = INVALID_PLAYER_ID;
		pTemp[playerid][pBizPrice] = 0;
		pTemp[playerid][pBizID] = INVALID_PLAYER_ID;

        if (!IsPlayerLogged(userid))									return SendErrorMessage(playerid, "Nguoi choi de nghi ban mua doanh nghiep khong truc tuyen. ");
		if (bizid == -1)												return SendErrorMessage(playerid, "Khong co ai de nghi ban mua doanh nghiep. ");
        if (price < 0 || price > 100000000)								return SendErrorMessage(playerid, "So tien co the ban tu $0 den $100000000.");
		if (!PlayerNearPlayer(3.0, playerid, userid))					return SendNotNearPlayer(playerid);
		if (BizInfo[bizid][bizOwnerID] != PlayerInfo[userid][pID])		return SendErrorMessage(playerid, "Doanh nghiep nay khong thuoc so huu cua %s.", GetNameEx(userid));
		if (GetCash(playerid) < price)									return SendNotCash(playerid);
        if (GetPlayerBizes(playerid) >= GetMaxPlayerBiz(playerid))		return SendErrorMessage(playerid, "Ban khong the mua nhieu doanh nghiep.");

		if (IsPlayerBizOutside(playerid, bizid) == 0 && IsPlayerBizInside(playerid, bizid) == 0) return SendErrorMessage(playerid, "Ban phai o gan doanh nghiep ma ban muon mua.");
		
		BizInfo[bizid][bizOwnerID] = PlayerInfo[playerid][pID];
		format(BizInfo[bizid][bizOwner], MAX_PLAYER_NAME, "%s", GetAccName(playerid));

		GiveCash(playerid, -price);
		GiveCash(userid, price);

		for(new i = 0; i != MAX_GARAGES; i++)
		{
			if (!GarageInfo[i][garageID] || GarageInfo[i][garageBiz] != BizInfo[bizid][bizID]) continue;

			GarageInfo[i][garageOwner] = PlayerInfo[playerid][pID];
			SendSyntaxMessage(playerid, "Cung voi doanh nghiep, ban co mot Nha de xe [ID: %i].", i);

			new query[128];
			mysql_format(dbHandle, query, sizeof(query), "UPDATE `garage` SET `owner`=%i WHERE `id`=%i", PlayerInfo[playerid][pID], GarageInfo[i][garageID]);
			mysql_tquery(dbHandle, query);
		}

		RemoveAllWorkers(bizid);
		Save_Business(bizid);

		SendSyntaxMessage(playerid, "Ban da mua mot doanh nghiep tu %s voi gia $%i.", GetNameEx(userid), price);
    	SendSyntaxMessage(userid, "%s da mua mot doanh nghiep tu ban voi gia $%i.", GetNameEx(playerid), price);
    	return 1;
	}

	else if (pTemp[playerid][pRentPlayer] != INVALID_PLAYER_ID)
	{
	    new userid = pTemp[playerid][pRentPlayer], price = pTemp[playerid][pRentPrice];

        pTemp[playerid][pRentPlayer] = INVALID_PLAYER_ID;
		pTemp[playerid][pRentPrice] = 0;

		if (!IsPlayerLogged(userid))					return SendErrorMessage(playerid, "Nguoi de nghi ban thue nha hien khong truc tuyen.");
        if (!PlayerNearPlayer(3.0, playerid, userid))	return SendNotNearPlayer(playerid);

		new houseid;

		if ((houseid = GetNearInsideHouse(userid)) == -1)				return SendErrorMessage(userid, "Ban phai o trong ngoi nha.");
		if (HouseInfo[houseid][hOwnerID] != PlayerInfo[userid][pID])	return SendErrorMessage(userid, "Ngoi nha nay khong thuoc ve ban.");
        if (GetCash(playerid) < price)									return SendErrorMessage(playerid, "Ban khong co du $%i de tra truoc.", price);

		PlayerInfo[playerid][pRentKey] = HouseInfo[houseid][hID];
		PlayerInfo[playerid][pRentPrice] = price;
		SendSyntaxMessage(playerid, "Ban da thue mot ngoi nha tu %s. Ban se tra $%i cho moi lan luong.", GetNameWithMask(userid), price);
		SendSyntaxMessage(playerid, "Ban co the ra khoi nha bat cu luc nao bang lenh: /unrent.");
		SendSyntaxMessage(userid, "%s da thue ngoi nha cua ban. Anh ay se tra $%i voi moi lan luong cho ban.", GetNameWithMask(playerid), price);

		new query[128];
        format(query, sizeof(query), "UPDATE `users` SET `rent_key`=%i,`rent_price`=%i WHERE `id`=%i", PlayerInfo[playerid][pRentKey], PlayerInfo[playerid][pRentPrice], PlayerInfo[playerid][pID]);
		mysql_tquery(dbHandle, query);

		return 1;
	}

	else if (pTemp[playerid][pInterviewPlayer] != INVALID_PLAYER_ID)
	{
		if (PlayerInfo[playerid][pSettings] & togNews)	return SendErrorMessage(playerid, "Dau tien, hay cho phep hien thi thong bao tu SAN (/tog news).");

		new userid = pTemp[playerid][pInterviewPlayer];

    	pTemp[playerid][pInterviewPlayer] = INVALID_PLAYER_ID;

        if (!IsPlayerLogged(userid))						return SendErrorMessage(playerid, "Nguoi choi de nghi ban phong van hien khong truc tueyn.");
		if (!PlayerNearPlayer(3.0, playerid, userid))	return SendNotNearPlayer(playerid);
    	if (!IsPlayerFactionNews(playerid))				return SendErrorMessage(playerid, "Ban phai la mot nhan vien cua SAN. ");

		pTemp[playerid][pInterview] = userid;
		SendSyntaxMessage(playerid, "Ban da chap nhan loi de nghi phong van tu phong vien %s.", GetNameWithMask(userid));
    	SendSyntaxMessage(playerid, "Su dung tro chuyen cuc bo de phat truc tiep. /exitinterview - de hoan thanh phong van.");
		SendSyntaxMessage(userid, "%s da chap nhan loi de nghi phong van tu ban.", GetNameWithMask(playerid));

		return 1;
	}
	
	return 0;
}

GetPlayerDeniedAction(playerid) {
	if (GetPVarInt(playerid, #accept_time) < gettime()) return 0;
	DeletePVar(playerid, #accept_time);
	return 1;
}