this::VehicleUpgrade(playerid, cost, level, color2)
{
	new 
		uptime = 1000,
		vehicleid = PlayerInfo[playerid][pCarKey],
		model = GetVehicleModel(vehicleid)
	;
	
	if (!IsValidVehicle(vehicleid) || !IsPlayerLogged(playerid) || VehicleInfo[vehicleid][carEngineOn])
	{
	    DeletePVar(playerid, #vehicle_upgrade_timer);
		UpdateDynamic3DTextLabelText(status_update[vehicleid], 0x33AA3300, "(( ---------- ))");
		VehicleInfo[vehicleid][carAttach3DtextUse] = 0;
		return 1;
	}

	new upgrade_name[13][64] = {
		"TOWING TRANSPORT",
		"LOCK UPDATE",
		"ALARM UPDATE",
		"IMMOBILIZER UPDATE",
		"UPDATE INSURANCE",
		"UPDATE ARMOR",
		"TRANSPORT REGISTRATION",
		"REMOVAL OF TRANSPORT FROM REGISTRATION",
		"CHANGE ENGINE",
		"PAINTING TRANSPORT",
		"REPLACING THE BATTERY",
		"FUELING TRANSPORT",
		"CAR REPAIR"
	};

	new string[128] = "(( ", upgrade = 0;

	if (upgrade == 12) uptime = 15/11*1000;

	for(new i; i != 10; i++)
	{
	    if (GetPVarInt(playerid, #vehicle_upgrade_timer) >= i)	strcat(string, "I");
		else													strcat(string, "-");
	}

	format(string, sizeof(string), "%s ))\n%s", string, upgrade_name[VehicleInfo[vehicleid][carAttach3DtextUse]-1]);
	UpdateDynamic3DTextLabelText(status_update[vehicleid], 0x33AA33FF, string);
	SetPVarInt(playerid, #vehicle_upgrade_timer, GetPVarInt(playerid, #vehicle_upgrade_timer) + 1);

	if (GetPVarInt(playerid, #vehicle_upgrade_timer) == 11)
	{
	    upgrade = VehicleInfo[vehicleid][carAttach3DtextUse];
	    DeletePVar(playerid, #vehicle_upgrade_timer);
		UpdateDynamic3DTextLabelText(status_update[vehicleid], 0x33AA3300, "(( ---------- ))");
		VehicleInfo[vehicleid][carAttach3DtextUse] = 0;
		
	}
	else
	{
		SetTimerEx("VehicleUpgrade", uptime, 0, "iiii", playerid, cost, level, color2);
	}

	if (upgrade == 0) return 1;

	new dealer = -1;

	if (upgrade != 13 && upgrade != 12 && upgrade != 1 && upgrade != 7 && (dealer = ModShop_Nearest(playerid)) == -1) 
		return SendErrorMessage(playerid, "Ban nen o gan Tuning Studio. ");
	if (upgrade == 12 && AZC_Nearest(playerid) == -1) 
		return SendErrorMessage(playerid, "Ban phai o gan mot tram xang.");
	if (upgrade == 13 && PAS_Nearest(playerid) == -1)
		return SendErrorMessage(playerid, "Ban nen o gan mot dich vu xe hoi. "); 
	
	if (upgrade == 1)
	{
	    if (GetCash(playerid) < cost)	return SendNotCash(playerid);

		GiveCash(playerid, -cost);
		RespawnVehicle(vehicleid);
		return SendSyntaxMessage(playerid, "Ban %s da duoc keo thanh cong den mot diem dau xe.", VehicleNames[model-400]);
	}
	else if (upgrade == 2)
	{
		if (GetCash(playerid) < cost)	return SendNotCash(playerid);

		GiveCash(playerid, -cost);
		SendSyntaxMessage(playerid, "Nang cap lau dai len cap %i da duoc thuc hien voi $%i.", level, cost);
        UnFreezePlayer(playerid);
		VehicleInfo[vehicleid][carLock] = level;
		Save_Car(vehicleid);
		GiveBizCash(dealer, cost / 100 * 80);
		return 1;
	}
	else if (upgrade == 3)
	{
		if (GetCash(playerid) < cost)	return SendNotCash(playerid);

		GiveCash(playerid, -cost);
		SendSyntaxMessage(playerid, "Nang cap canh bao len muc %i voi gia $%i.", level, cost);
        UnFreezePlayer(playerid);
		VehicleInfo[vehicleid][carAlarm] = level;
		Save_Car(vehicleid);
		GiveBizCash(dealer, cost / 100 * 80);
		return 1;
	}
	else if (upgrade == 4)
	{
	    if (GetCash(playerid) < cost)	return SendNotCash(playerid);

		GiveCash(playerid, -cost);
		SendSyntaxMessage(playerid, "Nang cap bo co dinh len cap %i toi da duoc thuc hien cho $%i.", level, cost);
        UnFreezePlayer(playerid);
		VehicleInfo[vehicleid][carImmob] = level;
		Save_Car(vehicleid);
		GiveBizCash(dealer, cost / 100 * 80);
		return 1;
	}
	else if (upgrade == 5)
	{
        if (GetCash(playerid) < cost)	return SendNotCash(playerid);

		GiveCash(playerid, -cost);
		SendSyntaxMessage(playerid, "Cai thien bao hiem len den muc %i da duoc thuc hien cho $%i.", level, cost);
        UnFreezePlayer(playerid);
		VehicleInfo[vehicleid][carInsurance] = level;
		Save_Car(vehicleid);
		GiveBizCash(dealer, cost / 100 * 80);
		return 1;
	}
	else if (upgrade == 6)
	{
	    if (GetCash(playerid) < cost)	return SendNotCash(playerid);

		GiveCash(playerid, -cost);
		SendSyntaxMessage(playerid, "%i da them dat cho, viet tat tu ban $%i.", level, cost);
        UnFreezePlayer(playerid);
		VehicleInfo[vehicleid][carArmour] += float(level);

		if (VehicleInfo[vehicleid][carArmour] > 250.0)	VehicleInfo[vehicleid][carArmour] = 250.0;
		
		SetVehicleHealth(vehicleid, GetVehicleMaxHealth(GetVehicleModel(vehicleid)) + VehicleInfo[vehicleid][carArmour]);
		UpdateVehicleDamageStatus(vehicleid, 0, 0, 0, 0);
		Save_Car(vehicleid);
		GiveBizCash(dealer, cost / 100 * 80);
		return 1;
	}
	else if (upgrade == 7)
	{
		if (GetCash(playerid) < cost)	return SendNotCash(playerid);

        if (!IsVehicleInRangeOfPoint(vehicleid, 15.0, 697.6670, 1624.8490, 785.5494))
		{
			return SendErrorMessage(playerid, "Phuong tien di lai cua ban phai gan don canh sat o Palomino.");
		}
		
		format(VehicleInfo[vehicleid][carPlate], 24, "%s", GetVehicleNumber());
		VehicleInfo[vehicleid][carRegistered] = 1;
		SetVehicleNumberPlate(vehicleid, VehicleInfo[vehicleid][carPlate]);
		RespawnVehicle(vehicleid, 1);
		GiveCash(playerid, -cost);
		SendSyntaxMessage(playerid, "Xe duoc dang ky voi gia $%i. Bien xe moi cua ban: %s", cost, VehicleInfo[vehicleid][carPlate]);
		UnFreezePlayer(playerid);

		new mes[128];
		format(mes, sizeof(mes), "~w~Ban da dat bien so xe moi~n~~y~%s voi gia $%i.", VehicleInfo[vehicleid][carPlate], cost);
		JobMessage(playerid, mes, 6);

		Save_Car(vehicleid);
		GiveBizCash(dealer, cost / 100 * 80);
        return 1;
	}
	else if (upgrade == 8)
	{
	    if (GetCash(playerid) < cost)	return SendNotCash(playerid);

		if (!IsVehicleInRangeOfPoint(vehicleid, 15.0, 697.6670, 1624.8490, 785.5494))
		{
			return SendErrorMessage(playerid, "Phuong tien di lai cua ban phai gan don canh sat o Palomino.");
		}

		format(VehicleInfo[vehicleid][carPlate], 24, "_");
		VehicleInfo[vehicleid][carRegistered] = 0;
		SetVehicleNumberPlate(vehicleid, "_");
		RespawnVehicle(vehicleid, 1);
		Save_Car(vehicleid);

		SendSyntaxMessage(playerid, "Xe da duoc thao dang kiem. ");
		JobMessage(playerid, "~w~Xe cua ban da duoc dang ky.", 2);
		UnFreezePlayer(playerid);
		return 1;
	}
	else if (upgrade == 9)
	{
		if (GetCash(playerid) < cost)	return SendNotCash(playerid);
			
		format(string, sizeof(string), "~w~Dong co duoc thay the (100,00) voi gia $%i.", cost);
		JobMessage(playerid, string, 6);
        SendSyntaxMessage(playerid, "Dong co da duoc thay the voi gia $%i.", cost);
		GiveCash(playerid, -cost);
		UnFreezePlayer(playerid);
		VehicleInfo[vehicleid][carEngine] = 100.00;
		GiveBizCash(dealer, cost / 100 * 80);
		return 1;
	}
	else if (upgrade == 10)
	{
	    if (GetCash(playerid) < cost)	return SendNotCash(playerid);

		SendSyntaxMessage(playerid, "Ban da son lai chiec xe cua minh voi gia $%i.", cost);
		GiveCash(playerid, -cost);
		UnFreezePlayer(playerid);
		ChangeVehicleColor(vehicleid, level, color2);
		VehicleInfo[vehicleid][carColor1] = level;
		VehicleInfo[vehicleid][carColor2] = color2;
		Save_Car(vehicleid);
		GiveBizCash(dealer, cost / 100 * 80);
	    return 1;
	}
	else if (upgrade == 11)
	{
		if (GetCash(playerid) < cost)	return SendNotCash(playerid);

		format(string, sizeof(string), "~w~Binh ac quy da duoc thay the (100.00) voi gia $%i.", cost);
		JobMessage(playerid, string, 6);
        SendSyntaxMessage(playerid, "Binh ac quy da duoc thay the voi gia $%i.", cost);
		GiveCash(playerid, -cost);
		UnFreezePlayer(playerid);
		VehicleInfo[vehicleid][carBattery] = 100.00;
		GiveBizCash(dealer, cost / 100 * 80);
		return 1;
	}
	else if (upgrade == 12)
	{
		if (GetCash(playerid) < cost)	return SendNotCash(playerid);
		/*GiveCash(playerid, -cost);

		new Float:toFill = GetVehicleFuelCapacity(GetVehicleModel(vehicleid)) - VehicleInfo[vehicleid][carFuel];
		VehicleInfo[vehicleid][carFuel] += toFill;

		if (BizInfo[GetPVarInt(playerid, #bizid)][bizOwnerID] != 0)
		{
			if (BizInfo[GetPVarInt(playerid, #bizid)][bizProduct] > 10) BizInfo[GetPVarInt(playerid, #bizid)][bizProduct]--;
			GiveBizCash(GetPVarInt(playerid, #bizid), cost);
		}

		format(string, sizeof(string), "~w~�� ������� ����������� �� ~h~~g~$%i.", cost);
		InfoMSG(playerid, string, 5);
		SM2(playerid,"���� ������������ �������� ���� ���������� �� $%i.", cost);*/
		
		return 1;
	}
	else if (upgrade == 13) //all
	{
		if (GetCash(playerid) < cost)	return SendNotCash(playerid);
		GiveCash(playerid, -cost);

		FixVehicle(vehicleid);

		if (BizInfo[GetPVarInt(playerid, #bizid)][bizOwnerID] != 0)
		{
			if (BizInfo[GetPVarInt(playerid, #bizid)][bizProduct] > 10) BizInfo[GetPVarInt(playerid, #bizid)][bizProduct]--;
			GiveBizCash(GetPVarInt(playerid, #bizid), cost);
		}

		format(string, sizeof(string), "~w~Ban da sua chua chiec xe\ncua minh voi gia ~h~~g~$%i.", cost);
		InfoMSG(playerid, string, 5);
		SM2(playerid,"Xe cua ban da duoc sua chua voi gia $%i.", cost);		
		
		return 1;
	}
	else if (upgrade == 14) //list
	{
		if (GetCash(playerid) < cost)	return SendNotCash(playerid);
		GiveCash(playerid, -cost);

		UpdateVehicleDamageStatus(vehicleid, pTemp[playerid][pListed][0], pTemp[playerid][pListed][1], pTemp[playerid][pListed][2], pTemp[playerid][pListed][3]);
		for(new i; i < 4; i++) pTemp[playerid][pListed][i] = 0;

		if (BizInfo[GetPVarInt(playerid, #bizid)][bizOwnerID] != 0)
		{
			if (BizInfo[GetPVarInt(playerid, #bizid)][bizProduct] > 10) BizInfo[GetPVarInt(playerid, #bizid)][bizProduct]--;
			GiveBizCash(GetPVarInt(playerid, #bizid), cost);
		}

		format(string, sizeof(string), "~w~Xe cua ban da duoc do xang voi gia ~h~~g~$%i.", cost);
		InfoMSG(playerid, string, 5);
		SM2(playerid,"Xe cua ban da duoc do xang voi gia $%i.", cost);		
		
		return 1;
	}
	else if (upgrade == 15)//HP
	{
		if (GetCash(playerid) < cost)	return SendNotCash(playerid);
		GiveCash(playerid, -cost);
		
		SetVehicleHealth(vehicleid, GetVehicleMaxHealth(GetVehicleModel(vehicleid)));

		if (BizInfo[GetPVarInt(playerid, #bizid)][bizOwnerID] != 0)
		{
			if (BizInfo[GetPVarInt(playerid, #bizid)][bizProduct] > 10) BizInfo[GetPVarInt(playerid, #bizid)][bizProduct]--;
			GiveBizCash(GetPVarInt(playerid, #bizid), cost);
		}

		format(string, sizeof(string), "~w~Xe cua ban da duoc sua voi gia ~h~~g~$%i.", cost);
		InfoMSG(playerid, string, 5);
		return 1;
	}
	return 1;
}

SendMechanicHelp(playerid, location[])
{
	foreach(new i : Player)
	{
	    if (!IsPlayerLogged(i) || !IsPlayerFactionMech(i)) continue;

       	SendClientMessage(i, COLOR_GREEN, "|_________Goi dien toi dich vu sua xe_________|");
		if (pTemp[playerid][pPayphone] == -1) 	SendClientMessageEx(i, COLOR_WHITE, "Cuoc goi tu: %s Ph: %i", GetNameEx(playerid), PlayerInfo[playerid][pNumber]);
		else 									SendClientMessageEx(i, COLOR_WHITE, "Cuoc goi tu: Dien thoai cong cong, Ph: %i", PayphoneInfo[pTemp[playerid][pPayphone]][phNumber]);
		SendClientMessageEx(i, COLOR_WHITE, "Tinh hinh: %s", location);
 	}
	return 1;
}

Mechanic_OnPlayerExitVehicle(playerid)
{
    if (RepairService[playerid] != 0)
	{
		ShowJobMessage(playerid, "~h~~p~BAT DAU SON PHUONG TIEN");
		GivePlayerWeaponEx(playerid, 41, 999);
	}
    return 1;
}

StartVehicleUpgrade(playerid, vehicleid, type, cost, level = 0, color2 = 0)
{
	if (type != 12 && VehicleInfo[vehicleid][carOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Phuong tien nay phai o gan ban. ");
    if (VehicleInfo[vehicleid][carAttach3DtextUse] != 0)									return SendErrorMessage(playerid, "Cho da, hoat dong da duoc tien hanh.");
		
    VehicleInfo[vehicleid][carAttach3DtextUse] = type;
	SetTimerEx("VehicleUpgrade", 1, 0, "iiii", playerid, cost, level, color2);
	SetPVarInt(playerid, #vehicle_upgrade_timer, 0);
	return 1;
}