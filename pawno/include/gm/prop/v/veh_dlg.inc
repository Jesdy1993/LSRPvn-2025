Dialog:DuplicateKey(playerid, response, listitem, inputtext[])
{
	if (!response)																			return 1;
    if (!IsValidVehicle(PlayerInfo[playerid][pCarKey]))										return SendErrorMessage(playerid, "Phuong tien cua ban khong duoc tao ra.");
	if (VehicleInfo[PlayerInfo[playerid][pCarKey]][carOwnerID] != PlayerInfo[playerid][pID])	return 1;

    static const str_size[] = "{ffffff}Tao ban sao cho %s. Type {C3C3C3}[ID/Ten] {ffffff}ban muon cung cap khoa ban sao cho ai:";
	new mes[sizeof(str_size) - 2 + 1 + 32];

	format(mes, sizeof(mes), str_size, VehicleNames[GetVehicleModel(PlayerInfo[playerid][pCarKey])-400]);
	    
    new userid;

	if (sscanf(inputtext, "u", userid))
	{
	    Dialog_Show(playerid, DuplicateKey, DIALOG_STYLE_INPUT, "{FFFFFF}Tao ban sao", mes, "Mua", "Huy bo");
	    return SendErrorMessage(playerid, "Nhap ID nguoi choi.");
	}

	if (!IsPlayerLogged(userid) || userid == playerid)
	{
	    Dialog_Show(playerid, DuplicateKey, DIALOG_STYLE_INPUT, "{FFFFFF}Tao ban sao", mes, "Mua", "Huy bo");
		return SendNotConnected(playerid);
	}

	if (!PlayerNearPlayer(5.0, playerid, userid))
	{
	    Dialog_Show(playerid, DuplicateKey, DIALOG_STYLE_INPUT, "{FFFFFF}Tao ban sao", mes, "Mua", "Huy bo");
		return SendNotNearPlayer(playerid);
	}
	
	if (GetCash(playerid) < 150)	 return SendNotCash(playerid);
	    
	GiveCash(playerid, -150);
	PlayerInfo[userid][pSpareKey] = VehicleInfo[PlayerInfo[playerid][pCarKey]][carID];
	SendSyntaxMessage(playerid, "Cac khoa ban sao duoc tao ra boi %s va chuyen cho nguoi choi %s.", VehicleNames[GetVehicleModel(PlayerInfo[playerid][pCarKey])-400], GetNameEx(userid));
    SendSyntaxMessage(userid, "%s da mua ban sao chia khoa tu %s. (/dropkey - vut bo khoa ban sao).", GetNameEx(playerid), VehicleNames[GetVehicleModel(PlayerInfo[playerid][pCarKey])-400]);
	return 1;
}

Dialog:ScrapSell(playerid, response, listitem, inputtext[])
{
	if (!response)	return 1;

	new veh = PlayerInfo[playerid][pCarKey], string1[128], mes[32];

	if (IsABicycle(veh)) format(mes, sizeof(mes), "%s", VehicleNames[VehicleInfo[veh][carModel]-400]);

	else
	{
		if (VehicleInfo[veh][carRegistered])	format(mes, sizeof(mes), "{FFFFFF}%s [%s]", VehicleNames[VehicleInfo[veh][carModel]-400], VehicleInfo[veh][carPlate]);
		else								format(mes, sizeof(mes), "{FFFFFF}%s", VehicleNames[VehicleInfo[veh][carModel]-400]);
	}

	format(string1, sizeof(string1), "{FFFFFF}Ban co chac chan muon ban chiec xe nay voi gia $%i?", GetVehiclePrice(VehicleInfo[veh][carModel])/2);
	Dialog_Show(playerid, ScrapVehicle, DIALOG_STYLE_MSGBOX, mes, string1, "Co", "Khong");
	return 1;
}

Dialog:ScrapVehicle(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		new veh = PlayerInfo[playerid][pCarKey];

        SendSyntaxMessage(playerid, "Ban da ban phuong tien \"%s\" voi gia $%i.", VehicleNames[VehicleInfo[veh][carModel]-400], GetVehiclePrice(VehicleInfo[veh][carModel])/2);
		GiveCash(playerid,  GetVehiclePrice(VehicleInfo[veh][carModel])/2);

        new query[256], money = PlayerInfo[playerid][pCash];

		format(query, sizeof(query), "%s [MYSQL: %i | IP: %s | Money(WAS): %i | Money(BECOME): %i] ban chiec xe %s(Model: %i) voi gia -- $%i", GetName(playerid), PlayerInfo[playerid][pID], q_GetPlayerIP(playerid), money, 
		GetCash(playerid), VehicleNames[VehicleInfo[veh][carModel]-400], VehicleInfo[veh][carModel], GetVehiclePrice(VehicleInfo[veh][carModel])/2);
	    insert_log(query, VEHICLE_LOG, 3, PlayerInfo[playerid][pAccID]);

		DeleteVehicleTickets(veh);
		
		mysql_format(dbHandle, query, sizeof(query), "DELETE FROM `cars` WHERE `id` = %i", VehicleInfo[veh][carID]);
		mysql_tquery(dbHandle, query);

		PlayerInfo[playerid][pCarKey] = 0;
		VehicleInfo[veh][carOwnerPlayer] = INVALID_PLAYER_ID;
		DestroyVehicle(veh);
	}
	return 1;
}

Dialog:BuyingVehicleList(playerid, response, listitem, inputtext[])
{
	if (response)	ShowBuyingVehicleDetails(playerid);
	else
	{
	    new registerveh 	= price_reg[GetPVarInt(playerid, "BuyingVehicleRegister")], 
			alarmveh 		= price_alarm[GetPVarInt(playerid, "BuyingVehicleAlarm")],
			lockveh 		= price_lock[GetPVarInt(playerid, "BuyingVehicleLock")],
			immobveh 		= price_immob[GetPVarInt(playerid, "BuyingVehicleImmob")], 
			insuranceveh 	= GetInsurancePrice(GetPVarInt(playerid, "BuyingVehicleModel")) * GetPVarInt(playerid, "BuyingVehicleInsurance"),
			xmradioveh 		= price_radio[GetPVarInt(playerid, "BuyingVehicleRadio")], 
			gpsveh 			= price_gps[GetPVarInt(playerid, "BuyingVehicleGps")];

    	new mes[56];

		format(mes, sizeof(mes), "{FFFFFF}%s - {35B835}$%i", VehicleNames[GetPVarInt(playerid, "BuyingVehicleModel")-400], GetVehiclePrice(GetPVarInt(playerid, "BuyingVehicleModel"))+registerveh+alarmveh+lockveh+immobveh+insuranceveh+xmradioveh+gpsveh);
		Dialog_Show(playerid, BuyingVehicleDone, DIALOG_STYLE_MSGBOX, mes, "{FFFFFF}Ban co chac chan muon mua chiec xe nay khong?", "Mua", "Huy bo");
	}
	return 1;
}

Dialog:BuyingVehicleDone(playerid, response, listitem, inputtext[])
{
	if (!response) return 1;

	new query[128];
   	mysql_format(dbHandle, query, sizeof(query), "SELECT `id` FROM `cars` WHERE `owner` = %i", PlayerInfo[playerid][pID]);
	mysql_tquery(dbHandle, query, "BuyVehicleForPlayer", "i", playerid);
	return 1;
}

Dialog:RansomVehicle(playerid, response, listitem, inputtext[])
{
	if (!response) {
		DeletePVar(playerid, #RansomVehModel);
		DeletePVar(playerid, #RansomVehID);
		return 1;
	}

	Dialog_Show(playerid, RansomVehicle2, DIALOG_STYLE_LIST, "Doi cac tuy chon", "Doi phuong tien\nXoa phuong tien cua toi", "Chon", "<<");
	return 1;
}
Dialog:RansomVehicle2(playerid, response, listitem, inputtext[])
{
	if (!response) {
		DeletePVar(playerid, #RansomVehModel);
		DeletePVar(playerid, #RansomVehID);
		return 1;
	}

	if (listitem == 0)
	{
		new model = GetPVarInt(playerid, #RansomVehModel),
			vehid = GetPVarInt(playerid, #RansomVehID);
		
		DeletePVar(playerid, #RansomVehModel);
		DeletePVar(playerid, #RansomVehID);

		new price = floatround(GetVehiclePrice(model)*0.5);
		if (GetCash(playerid) < price)	return SendNotCash(playerid);
		
		SendSyntaxMessage(playerid, "Ban da mua %s voi gia $%i.", VehicleNames[model-400], price);
		SQL_SetInteger("cars", "jacking", 0, vehid);
		GiveCash(playerid, -price);
	} else {
		new mes[128];
		format(mes, sizeof(mes), "{FFFFFF}Ban co thuc su muon {FF6347}xoa{FFFFFF} %s mai mai khong?", GetVehName(pTemp[playerid][MyCars][listitem]));
		ConfirmDialog(playerid, "Xac nhan xoa phuong tien", mes, "DELETE_VEHICLE");
	}
	return 1;
}

Dialog:MyCars(playerid, response, listitem, inputtext[])
{
	if (!response) return 1;
	
	if (IsValidVehicle(PlayerInfo[playerid][pCarKey]) && pTemp[playerid][MyCarSpawn][listitem])
		return cmd::vmenu(playerid, "");
	else
	{
		if (!IsValidVehicle(PlayerInfo[playerid][pCarKey]))
		{
			pTemp[playerid][MyCarSpawn][0] = listitem;

			new dlgmes[64];
			format(dlgmes, sizeof(dlgmes), "{FFFFFF}Ban co thuc su muon tao %s ra khong?", GetVehName(pTemp[playerid][MyCars][listitem]));
			ConfirmDialog(playerid, "Xac nhan", dlgmes, "MyCarsSpawn");
		}
		else 
		{
			SendErrorMessage(playerid, "Ban da tao ra chiec xe.");
			cmd::mycars(playerid, "");
		}
	}

	return 1;
}

Dialog:BuyingVehicleDetails(playerid, response, listitem, inputtext[])
{
	new registerveh = price_reg[GetPVarInt(playerid, "BuyingVehicleRegister")], 
		alarmveh = price_alarm[GetPVarInt(playerid, "BuyingVehicleAlarm")], 
		lockveh = price_lock[GetPVarInt(playerid, "BuyingVehicleLock")], 
		immobveh = price_immob[GetPVarInt(playerid, "BuyingVehicleImmob")], 
		insuranceveh = GetInsurancePrice(GetPVarInt(playerid, "BuyingVehicleModel")) * GetPVarInt(playerid, "BuyingVehicleInsurance"), 
		xmradioveh = price_radio[GetPVarInt(playerid, "BuyingVehicleRadio")], gpsveh = price_gps[GetPVarInt(playerid, "BuyingVehicleGps")];
		
	new registeruse[128], lockuse[128], alarmuse[250], immobuse[260], insuranceuse[260], xmradiouse[128], gpsuse[128];

	if (GetPVarInt(playerid, "BuyingVehicleRegister"))			format(registeruse, sizeof(registeruse), "{ffffff}Dang ky: \t{ecc317}$%i\n{ecc317}+ {ffffff}Dang ky bien so xe.\n\n", registerveh);
	
	if (GetPVarInt(playerid, "BuyingVehicleAlarm") == 1)			format(alarmuse, sizeof(alarmuse), "{ffffff}Bao dong: \t{bab9ba}1 cap do \t{ecc317}$%i\n{ecc317}+ {ffffff}Bao dong bang am thanh lon.\n\n", alarmveh);
	else if (GetPVarInt(playerid, "BuyingVehicleAlarm") == 2)	format(alarmuse, sizeof(alarmuse), "{ffffff}Bao dong: \t{bab9ba}2 cap do \t{ecc317}$%i\n{ecc317}+ {ffffff}Bao dong bang am thanh lon.\n{ecc317}+ {ffffff}Canh bao cho canh sat.\n\n", alarmveh);
	else if (GetPVarInt(playerid, "BuyingVehicleAlarm") == 3)	format(alarmuse, sizeof(alarmuse), "{ffffff}Bao dong: \t{bab9ba}3 cap do \t{ecc317}$%i\n{ecc317}+ {ffffff}Bao dong bang am thanh lon.\n{ecc317}+ {ffffff}Canh bao cho canh sat.\n{ecc317}+ {ffffff}Thong bao hack cho chu so huu qua SMS.\n\n", alarmveh);
	else if (GetPVarInt(playerid, "BuyingVehicleAlarm") == 4)	format(alarmuse, sizeof(alarmuse), "{ffffff}Bao dong: \t{bab9ba}4 cap do \t{ecc317}$%i\n{ecc317}+ {ffffff}Bao dong bang am thanh lon.\n{ecc317}+ {ffffff}Canh bao cho canh sat.\n{ecc317}+ {ffffff}Thong bao hack cho chu so huu qua SMS va thanh toan.\n\n", alarmveh);
	
	if (GetPVarInt(playerid, "BuyingVehicleLock") > 0)			format(lockuse, sizeof(lockuse), "{ffffff}Khoa: \t\t\t{bab9ba}%i cap do \t{ecc317}$%i\n{ecc317}+ {ffffff}%i khoa lay xe.\n\n", GetPVarInt(playerid, "BuyingVehicleLock"), lockveh, 250 + (GetPVarInt(playerid, "BuyingVehicleLock") * 250));
	
	if (GetPVarInt(playerid, "BuyingVehicleImmob") > 0)			format(immobuse, sizeof(immobuse), "{ffffff}Immobilizer: \t{bab9ba}%i cap do \t{ecc317}$%i\n{ecc317}+ {ffffff}Giup cong tac danh lua khong bi hong.\n\n", GetPVarInt(playerid, "BuyingVehicleImmob"), immobveh);
 	
	if (GetPVarInt(playerid, "BuyingVehicleInsurance") == 1)		format(insuranceuse, sizeof(insuranceuse), "{ffffff}Bao hiem: \t\t{bab9ba}1 cap do \t{ecc317}$%i\n{ecc317}+ {ffffff}Phuong tien se luon hoi sinh voi \n suc khoe toi da.\n\n", insuranceveh);
	else if (GetPVarInt(playerid, "BuyingVehicleInsurance") == 2)	format(insuranceuse, sizeof(insuranceuse), "{ffffff}Bao hiem: \t\t{bab9ba}2 cap do \t{ecc317}$%i\n{ecc317}+ {ffffff}Phuong tien se luon hoi sinh voi \n suc khoe toi da.\n{ecc317}+ {ffffff}Xe se hoi sinh ma khong bi hu hai.\n\n", insuranceveh);
	else if (GetPVarInt(playerid, "BuyingVehicleInsurance") == 3)	format(insuranceuse, sizeof(insuranceuse), "{ffffff}Bao hiem: \t\t{bab9ba}3 cap do \t{ecc317}$%i\n{ecc317}+ {ffffff}Phuong tien se luon hoi sinh voi \n suc khoe toi da.\n{ecc317}+ {ffffff}Xe se hoi sinh ma khong bi hu hai.\n{ecc317}+ {ffffff}Dang luu dieu chinh va dai.\n\n", insuranceveh);


	if (GetPVarInt(playerid, "BuyingVehicleRadio") == 1)	format(xmradiouse, sizeof(xmradiouse), "{ffffff}XM Radio: \t{ecc317}$%i\n{ecc317}+ {ffffff}Lap dat dai va cac thanh phan khac cua he thong am thanh.\n\n", xmradioveh);

	if (GetPVarInt(playerid, "BuyingVehicleGps") == 1) 	format(gpsuse, sizeof(gpsuse), "{ffffff}GPS: \t\t{ecc317}$%i\n{ecc317}+ {ffffff}Cai dat dinh vi GPS tren xe.\n\n", gpsveh);

	new mes[56];

	format(mes, sizeof(mes), "{ffffff}%s - {35B835}$%i", VehicleNames[GetPVarInt(playerid, "BuyingVehicleModel")-400], GetVehiclePrice(GetPVarInt(playerid, "BuyingVehicleModel"))+registerveh+alarmveh+lockveh+immobveh+insuranceveh+xmradioveh+gpsveh);
	if (!response)
	{
		new vehFuel[32], 
			vehDrive[32],
			modelid = GetPVarInt(playerid, "BuyingVehicleModel"),
			Float:vehMass = GetVehicleModelInfoAsFloat(modelid, "fMass"); 
						
        if (GetVehicleModelInfoAsInt(modelid, "TransmissionData_nDriveType") == 'F')
	    	vehDrive = "Phia truoc";
	    else if (GetVehicleModelInfoAsInt(modelid, "TransmissionData_nDriveType") == 'R')
	    	vehDrive = "Phia sau";
	    else if (GetVehicleModelInfoAsInt(modelid, "TransmissionData_nDriveType") == '4')
	    	vehDrive = "Xe 4 banh";
											
	    if (GetVehicleModelInfoAsInt(modelid, "TransmissionData_nEngineType") == 'P')
	    	vehFuel = "Xang";
	    else if (GetVehicleModelInfoAsInt(modelid, "TransmissionData_nEngineType") == 'D')
	    	vehFuel = "Dau diesel";
	    else if (GetVehicleModelInfoAsInt(modelid, "TransmissionData_nEngineType") == 'E')
	   		vehFuel = "Dien";
					
	    static const str_size[] = "{ecc317}Gia: \t\t			{ffffff}$%s\n\
                                    {ecc317}Toc do toi da: \t		{ffffff}%.1f km/h\n\
                                    {ecc317}Do ben toi da: \t		{ffffff}%.1f\n\
                                    {ecc317}Trong luong: \t\t		{ffffff}%.1f kf\n\n\
                                    {ecc317}Don vi truyen dong: \t		{ffffff}%s\n\
                                    {ecc317}Nhien lieu \t\t			{ffffff}%s\n\
                                    {ecc317}Tieu thu: \t		{ffffff}%.1f l/100 km\n\
                                    {ecc317}Dung tich bon: \t	{ffffff}%.1f l\n\n";

		new string[sizeof(str_size) + 1228];

		format(string, sizeof(string), str_size,
            FormatNumber(GetVehiclePrice(modelid)), 
            GetVehicleMaxSpeed[modelid-400], 
            GetVehicleMaxHealth(modelid), 
            vehMass, 
            vehDrive, 
            vehFuel,
            GetVehicleFuelUsage(modelid),
            GetVehicleFuelCapacity(modelid),
			VehicleColoursTableRGBA[GetPVarInt(playerid, #veh_color1)] >>> 8, GetPVarInt(playerid, #veh_color1), 
			VehicleColoursTableRGBA[GetPVarInt(playerid, #veh_color2)] >>> 8, GetPVarInt(playerid, #veh_color2)
		);
		
		format(string, sizeof(string), "%s{ecc317}Mau sac 1{ffffff} - [{%06x}#%i{ffffff}]\n{ecc317}Mau sac 2{ffffff} - [{%06x}#%i{ffffff}]\n\n", string, VehicleColoursTableRGBA[GetPVarInt(playerid, #veh_color1)] >>> 8, GetPVarInt(playerid, #veh_color1), VehicleColoursTableRGBA[GetPVarInt(playerid, #veh_color2)] >>> 8, GetPVarInt(playerid, #veh_color2));
		format(string, sizeof(string), "%s%s%s%s%s%s%s%s\n{ffffff}Nhan '{ecc317}Thanh toan{ffffff}' de mua phuong tien.", string, lockuse, alarmuse, immobuse, insuranceuse, registeruse, xmradiouse, gpsuse);
		
		Dialog_Show(playerid, BuyingVehicleList, DIALOG_STYLE_MSGBOX, mes, string, "Chinh sua", "Thanh toan");
	    return 1;
	}

	new string[301];
	switch(listitem)
	{
		case 0:
		{
				if (GetPVarInt(playerid, "BuyingVehicleRegister") == 0)		format(string, sizeof(string), "{eaf133}>> {ffffff}Chua cai dat\nDang ky - $%i", price_reg[1]);
				else if (GetPVarInt(playerid, "BuyingVehicleRegister") == 1)	format(string, sizeof(string), "{ffffff}Chua cai dat\n{eaf133}>> {ffffff}Dang ky - $%i", price_reg[1]);
					
				Dialog_Show(playerid, BuyVehDetReg, DIALOG_STYLE_LIST, mes, string, "Dat", "<<");
		}
		case 1:
		{
				if (GetPVarInt(playerid, "BuyingVehicleAlarm") == 0)			format(string, sizeof(string), "{ecc317} {ffffff}Chua cai dat\nbao dong muc 1- $%i\nbao dong muc 2- $%i\nbao dong muc 3- $%i\nbao dong muc 4- $%i", price_alarm[1], price_alarm[2], price_alarm[3], price_alarm[4]);
				else if (GetPVarInt(playerid, "BuyingVehicleAlarm") == 1)	format(string, sizeof(string), "Chua cai dat\n{ecc317} {ffffff}bao dong muc 1- $%i\nbao dong muc 2- $%i\nbao dong muc 3- $%i\nbao dong muc 4- $%i", price_alarm[1], price_alarm[2], price_alarm[3], price_alarm[4]);
				else if (GetPVarInt(playerid, "BuyingVehicleAlarm") == 2)	format(string, sizeof(string), "Chua cai dat\nbao dong muc 1- $%i\n{ecc317} {ffffff}bao dong muc 2- $%i\nbao dong muc 3- $%i\nbao dong muc 4- $%i", price_alarm[1], price_alarm[2], price_alarm[3], price_alarm[4]);
				else if (GetPVarInt(playerid, "BuyingVehicleAlarm") == 3)	format(string, sizeof(string), "Chua cai dat\nbao dong muc 1- $%i\nbao dong muc 2- $%i\n{ecc317} {ffffff}bao dong muc 3- $%i\nbao dong muc 4- $%i", price_alarm[1], price_alarm[2], price_alarm[3], price_alarm[4]);
				else if (GetPVarInt(playerid, "BuyingVehicleAlarm") == 4)	format(string, sizeof(string), "Chua cai dat\nbao dong muc 1- $%i\nbao dong muc 2- $%i\nbao dong muc 3- $%i\n{ecc317} {ffffff}bao dong muc 4- $%i", price_alarm[1], price_alarm[2], price_alarm[3], price_alarm[4]);

				Dialog_Show(playerid, BuyVehDetAlarm, DIALOG_STYLE_LIST, mes, string, "Dat", "<<");
		}
		case 2:
		{
				if (GetPVarInt(playerid, "BuyingVehicleLock") == 0)		format(string, sizeof(string), "{ecc317} {ffffff}Chua cai dat\nKhoa muc 1 - $%i\nKhoa muc 2 - $%i\nKhoa muc 3 - $%i\nKhoa muc 4 - $%i\nKhoa muc 5 - $%i", price_lock[1], price_lock[2], price_lock[3], price_lock[4], price_lock[5]);
				else if (GetPVarInt(playerid, "BuyingVehicleLock") == 1)	format(string, sizeof(string), "Chua cai dat\n{ecc317} {ffffff}Khoa muc 1 - $%i\nKhoa muc 2 - $%i\nKhoa muc 3 - $%i\nKhoa muc 4 - $%i\nKhoa muc 5 - $%i", price_lock[1], price_lock[2], price_lock[3], price_lock[4], price_lock[5]);
				else if (GetPVarInt(playerid, "BuyingVehicleLock") == 2)	format(string, sizeof(string), "Chua cai dat\nKhoa muc 1 - $%i\n{ecc317} {ffffff}Khoa muc 2 - $%i\nKhoa muc 3 - $%i\nKhoa muc 4 - $%i\nKhoa muc 5 - $%i", price_lock[1], price_lock[2], price_lock[3], price_lock[4], price_lock[5]);
				else if (GetPVarInt(playerid, "BuyingVehicleLock") == 3)	format(string, sizeof(string), "Chua cai dat\nKhoa muc 1 - $%i\nKhoa muc 2 - $%i\n{ecc317} {ffffff}Khoa muc 3 - $%i\nKhoa muc 4 - $%i\nKhoa muc 5 - $%i", price_lock[1], price_lock[2], price_lock[3], price_lock[4], price_lock[5]);
				else if (GetPVarInt(playerid, "BuyingVehicleLock") == 4)	format(string, sizeof(string), "Chua cai dat\nKhoa muc 1 - $%i\nKhoa muc 2 - $%i\nKhoa muc 3 - $%i\n{ecc317} {ffffff}Khoa muc 4 - $%i\nKhoa muc 5 - $%i", price_lock[1], price_lock[2], price_lock[3], price_lock[4], price_lock[5]);
				else if (GetPVarInt(playerid, "BuyingVehicleLock") == 5)	format(string, sizeof(string), "Chua cai dat\nKhoa muc 1 - $%i\nKhoa muc 2 - $%i\nKhoa muc 3 - $%i\nKhoa muc 4 - $%i\n{ecc317} {ffffff}Khoa muc 5 - $%i", price_lock[1], price_lock[2], price_lock[3], price_lock[4], price_lock[5]);

				Dialog_Show(playerid, BuyVehDetLock, DIALOG_STYLE_LIST, mes, string, "Dat", "<<");
		}
		case 3:
		{
				if (GetPVarInt(playerid, "BuyingVehicleImmob") == 0)			format(string, sizeof(string), "{ecc317} {ffffff}Chua cai dat\nimmobilizer muc 1 - $%i\nimmobilizer muc 2 - $%i\nimmobilizer muc 3 - $%i\nimmobilizer muc 4 - $%i", price_immob[1], price_immob[2], price_immob[3], price_immob[4]);
				else if (GetPVarInt(playerid, "BuyingVehicleImmob") == 1)	format(string, sizeof(string), "Chua cai dat\n{ecc317} {ffffff}immobilizer muc 1 - $%i\nimmobilizer muc 2 - $%i\nimmobilizer muc 3 - $%i\nimmobilizer muc 4 - $%i", price_immob[1], price_immob[2], price_immob[3], price_immob[4]);
				else if (GetPVarInt(playerid, "BuyingVehicleImmob") == 2)	format(string, sizeof(string), "Chua cai dat\nimmobilizer muc 1 - $%i\n{ecc317} {ffffff}immobilizer muc 2 - $%i\nimmobilizer muc 3 - $%i\nimmobilizer muc 4 - $%i", price_immob[1], price_immob[2], price_immob[3], price_immob[4]);
				else if (GetPVarInt(playerid, "BuyingVehicleImmob") == 3)	format(string, sizeof(string), "Chua cai dat\nimmobilizer muc 1 - $%i\nimmobilizer muc 2 - $%i\n{ecc317} {ffffff}immobilizer muc 3 - $%i\nimmobilizer muc 4 - $%i", price_immob[1], price_immob[2], price_immob[3], price_immob[4]);
				else if (GetPVarInt(playerid, "BuyingVehicleImmob") == 4)	format(string, sizeof(string), "Chua cai dat\nimmobilizer muc 1 - $%i\nimmobilizer muc 2 - $%i\nimmobilizer muc 3 - $%i\n{ecc317} {ffffff}immobilizer muc 4 - $%i");

				Dialog_Show(playerid, BuyVehDetImmob, DIALOG_STYLE_LIST, mes, string, "Dat", "<<");
		}
		case 4:
		{
			    new amount = GetInsurancePrice(GetPVarInt(playerid, "BuyingVehicleModel"));

				if (GetPVarInt(playerid, "BuyingVehicleInsurance") == 0)			format(string, sizeof(string), "{ecc317} {ffffff}Chua cai dat\nbao hiem muc 1 - $%i\nbao hiem muc 2 - $%i\nbao hiem muc 3 - $%i", amount * 1, amount * 2, amount * 3);
				else if (GetPVarInt(playerid, "BuyingVehicleInsurance") == 1)	format(string, sizeof(string), "Chua cai dat\n{ecc317} {ffffff}bao hiem muc 1 - $%i\nbao hiem muc 2 - $%i\nbao hiem muc 3 - $%i", amount * 1, amount * 2, amount * 3);
				else if (GetPVarInt(playerid, "BuyingVehicleInsurance") == 2)	format(string, sizeof(string), "Chua cai dat\nbao hiem muc 1 - $%i\n{ecc317} {ffffff}bao hiem muc 2 - $%i\nbao hiem muc 3 - $%i", amount * 1, amount * 2, amount * 3);
				else if (GetPVarInt(playerid, "BuyingVehicleInsurance") == 3)	format(string, sizeof(string), "Chua cai dat\nbao hiem muc 1 - $%i\nbao hiem muc 2 - $%i\n{ecc317} {ffffff}bao hiem muc 3 - $%i", amount * 1, amount * 2, amount * 3);

				Dialog_Show(playerid, BuyVehDetInsur, DIALOG_STYLE_LIST, mes, string, "Dat", "<<");
		}
		case 5:
		{
				if (GetPVarInt(playerid, "BuyingVehicleRadio") == 0)			format(string, sizeof(string), "{ecc317} {ffffff}Chua cai dat\nXM Radio - $%i", price_radio[1]);
				else if (GetPVarInt(playerid, "BuyingVehicleRadio") == 1)	format(string, sizeof(string), "Chua cai dat\n{ecc317} {ffffff}XM Radio - $%i", price_radio[1]);

				Dialog_Show(playerid, BuyVehDetRadio, DIALOG_STYLE_LIST, mes, string, "Dat", "<<");
		}
		case 6:
		{
				if (GetPVarInt(playerid, "BuyingVehicleGps") == 0)			format(string, sizeof(string), "{ecc317} {ffffff}Chua cai dat\nGPS - $%i", price_gps[1]);
				else if (GetPVarInt(playerid, "BuyingVehicleGps") == 1)		format(string, sizeof(string), "Chua cai dat\n{ecc317} {ffffff}GPS - $%i", price_gps[1]);

				Dialog_Show(playerid, BuyVehDetGPS, DIALOG_STYLE_LIST, mes, string, "Dat", "<<");
		}
		case 7:
		{
			SendSyntaxMessage(playerid, "Vui long chon mau {ffc46a}dau tien{FFFFFF}.");

			new vehiclescolor[256], List:colorss = list_new();
			for(new i; i < 256; i++)
			{
				vehiclescolor[i] = i;
				AddModelMenuItem(colorss, 400, "", true, -87.00, 0.0, 270.0, 0.190, vehiclescolor[i], vehiclescolor[i]);
				
			}
			ShowModelSelectionMenu(playerid, "Colors", MODEL_BUING_COLOR, colorss);
		}
	}
	return 1;
}

Dialog:BuyVehDetGPS(playerid, response, listitem, inputtext[])
{
	if (response) SetPVarInt(playerid, "BuyingVehicleGps", listitem);
		
	ShowBuyingVehicleDetails(playerid);
	return 1;
}

Dialog:BuyVehDetRadio(playerid, response, listitem, inputtext[])
{
	if (response) SetPVarInt(playerid, "BuyingVehicleRadio", listitem);

	ShowBuyingVehicleDetails(playerid);
	return 1;
}

Dialog:BuyVehDetInsur(playerid, response, listitem, inputtext[])
{
	if (response) SetPVarInt(playerid, "BuyingVehicleInsurance", listitem);

	ShowBuyingVehicleDetails(playerid);
	return 1;
}

Dialog:BuyVehDetImmob(playerid, response, listitem, inputtext[])
{
	if (response) SetPVarInt(playerid, "BuyingVehicleImmob", listitem);

	ShowBuyingVehicleDetails(playerid);
	return 1;
}

Dialog:BuyVehDetLock(playerid, response, listitem, inputtext[])
{
	if (response) SetPVarInt(playerid, "BuyingVehicleLock", listitem);

	ShowBuyingVehicleDetails(playerid);
	return 1;
}

Dialog:BuyVehDetAlarm(playerid, response, listitem, inputtext[])
{
	if (response) SetPVarInt(playerid, "BuyingVehicleAlarm", listitem);

	ShowBuyingVehicleDetails(playerid);
	return 1;
}

Dialog:BuyVehDetReg(playerid, response, listitem, inputtext[])
{
	if (response) SetPVarInt(playerid, "BuyingVehicleRegister", listitem);

	ShowBuyingVehicleDetails(playerid);
	return 1;
}

Dialog:VehFastAccess(playerid, response, listitem, inputtext[]) 
{
	if (!response) 										return 1;
	if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendErrorMessage(playerid, "Ban phai dang lai mot chiec xe!");

	switch(listitem)
	{
		case 0: cmd::engine(playerid, "");
		case 1: cmd::vehicle(playerid, "lock");
		case 2: cmd::lights(playerid, "");
		case 3: cmd::trunk(playerid, "");
		case 4: cmd::hood(playerid, "");
		case 5: cmd::window(playerid, "1");
		case 6: cmd::setstation(playerid, "");
		case 7:	cmd::vfa(playerid, "");
		case 8: cmd::vmenu(playerid, "");
	}

	return 1;
}

Dialog:VehMenu(playerid, response, listitem, inputtext[])
{
	if (!response) 										return 1;
    if (!IsValidVehicle(PlayerInfo[playerid][pCarKey]))	return SendErrorMessage(playerid, "Phuong tien cua ban khong duoc tao ra.");

	new vehicle = PlayerInfo[playerid][pCarKey];
	if (!vehicle || VehicleInfo[vehicle][carOwnerID] != PlayerInfo[playerid][pID]) return 1;
	
	switch(listitem)
	{
	    case 0: cmd::vehicle(playerid, "stats");
		case 1: cmd::vehicle(playerid, "fines");
	    case 2: cmd::vehicle(playerid, "park");
		case 3:	cmd::vehicle(playerid, "find");
		case 4: cmd::alarmoff(playerid, "");
		case 5: cmd::vehicle(playerid, "tow");
		case 6: cmd::vehicle(playerid, "sell");
		case 7: Dialog_Show(playerid, SellVehTo, DIALOG_STYLE_INPUT, "Ban xe", "{ffffff}Ban xe. Nhap 2 so nguyen: {C3C3C3}[ID/Ten] [gia ban]\nVi du: 1 35000", "Ban", "Huy bo");
	}
	return 1;
}

Dialog:SellVehTo(playerid, response, listitem, inputtext[])
{
	if (!response)										return cmd::vmenu(playerid, "");
    if (!IsValidVehicle(PlayerInfo[playerid][pCarKey]))	return SendErrorMessage(playerid, "Phuong tien cua ban khong duoc tao ra.");

	new vehicle = GetPlayerVehicleID(playerid);
	
	if (!vehicle)														return 1;
	if (VehicleInfo[vehicle][carOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Ban khong phai la chu so huu chiec xe nay.");

    new userid, price;

	if (sscanf(inputtext, "ui", userid, price))
	{
	    Dialog_Show(playerid, SellVehTo, DIALOG_STYLE_INPUT, "{FFFFFF}Ban xe", "{ffffff}Ban xe. Nhap 2 so nguyen: {C3C3C3}[ID/Ten] [gia ban]\nVi du: 1 35000", "Ban", "Huy bo");
	    return SendErrorMessage(playerid, "Dinh dang khong hop le.");
	}

	if (!IsPlayerLogged(userid))
	{
	    Dialog_Show(playerid, SellVehTo, DIALOG_STYLE_INPUT, "{FFFFFF}Ban xe", "{ffffff}Ban xe. Nhap 2 so nguyen: {C3C3C3}[ID/Ten] [gia ban]\nVi du: 1 35000", "Ban", "Huy bo");
		return SendNotConnected(playerid);
	}

	if (!PlayerNearPlayer(3.0, playerid, userid))
	{
	    Dialog_Show(playerid, SellVehTo, DIALOG_STYLE_INPUT, "{FFFFFF}Ban xe", "{ffffff}Ban xe. Nhap 2 so nguyen: {C3C3C3}[ID/Ten] [gia ban]\nVi du: 1 35000", "Ban", "Huy bo");
		return SendNotNearPlayer(playerid);
	}

	if (price < 0 || price > 100000000)
	{
	    Dialog_Show(playerid, SellVehTo, DIALOG_STYLE_INPUT, "{FFFFFF}Ban xe", "{ffffff}Ban xe. Nhap 2 so nguyen: {C3C3C3}[ID/Ten] [gia ban]\nVi du: 1 35000", "Ban", "Huy bo");
	    return SendErrorMessage(playerid, "Nhap dung gia ban");
	}

	new str[32];
	format(str, sizeof(str), "sellto %i %i", userid, price);
	cmd::vehicle(playerid, str);
	return 1;
}

Dialog:SelectClass(playerid, response, listitem, inputtext[])
{
	if (!response) return 1;

	switch(listitem)
	{
		case 0: ShowBclass(playerid);
		case 1: ShowLowriders(playerid);
		case 2: ShowAclass(playerid);
		case 3: ShowSport(playerid);
		case 4: ShowPickups(playerid);
		case 5: ShowOffRoad(playerid);
		case 6: ShowIndustrial(playerid);
		case 7: ShowMotoBike(playerid);
		case 8: ShowOther(playerid);
		case 9: ShowDonate(playerid);
	}
	return 1;
}

Dialog:Autoservice(playerid, response, listitem, inputtext[])
{
	if (!response) return 1;
	if (!IsDriver(playerid))	return SendNotInVehicle(playerid);

	new Float: health;
	
	AntiCheatGetVehicleHealth(GetPlayerVehicleID(playerid), health);

	new panels, doors, lights, tires;
	GetVehicleStatus(playerid, panels, doors, lights, tires);

	new 
		vehicle = GetPlayerVehicleID(playerid),
		model = GetVehicleModel(vehicle),
		hp_cost = floatround(((health/GetVehicleMaxHealth(model))) * (GetVehiclePrice(model)/1000), floatround_round)
	;
	if (hp_cost < 0) hp_cost = 0;
	new 
		cost = floatround(GetVehiclePrice(model) / 4, floatround_round),
		common_cost = hp_cost +  floatround((cost * 0.5 * panels/100) + (cost * 0.25 * doors/100) + (cost * 0.1 * lights/100) + (cost * 0.15 * tires/100), floatround_round)
	;
	
	switch(listitem) 
	{
		case 0: 
		{ // Complete Renovation
			if (common_cost <= 0)	return cmd::enter(playerid, "");
			static const dlgstr[] = "{FFFFFF}Ban co chac chan muon sua chua hoan toan chiec xe cua minh voi gia {1b8922}$%i{FFFFFF}?";
			new mes[sizeof(dlgstr)+6];

			format(mes, sizeof(mes), dlgstr, common_cost);

			ConfirmDialog(playerid, "Xac nhan", mes, "RepairAll");
		}
		case 1: 
		{ // // Select Item
			new panel_cost = floatround((cost * 0.5 * panels/100), floatround_round),
				door_cost = floatround((cost * 0.25 * doors/100), floatround_round),
				light_cost = floatround((cost * 0.1 * lights/100), floatround_round),
				tire_cost = floatround((cost * 0.15 * tires/100), floatround_round);

			static const dlgstr[] = "Chon cac muc ban muon sua:\n\
									{C5C5C5}[ - ]{FFFFFF} Sua chua than xe: {1b8922}$%i {c5c5c5}(Thiet hai: {FF6347}%i%%{c5c5c5})\n\
									{C5C5C5}[ - ]{FFFFFF} Sua chua canh cua: {1b8922}$%i {c5c5c5}(Thiet hai: {FF6347}%i%%{c5c5c5})\n\
									{C5C5C5}[ - ]{FFFFFF} Sua chua den pha: {1b8922}$%i {c5c5c5}(Thiet hai: {FF6347}%i%%{c5c5c5})\n\
									{C5C5C5}[ - ]{FFFFFF} Sua chua lop xe: {1b8922}$%i {c5c5c5}(Thiet hai: {FF6347}%i%%{c5c5c5})\n\
									{C5C5C5} >> SUA CHUA >>";
			new mes[526+8*4];

			format(mes, sizeof(mes), dlgstr, 
				panel_cost, panels,
				door_cost, doors,
				light_cost, lights,
				tire_cost, tires
			);

			for(new i; i < 4; i++) pTemp[playerid][pListed][i] = 0;
			Dialog_Show(playerid, SELECT_Autoservice, DIALOG_STYLE_TABLIST_HEADERS, "Sua chua xe - Chon cac hang muc", mes, "Chon", "Huy bo");
		}
		case 2: 
		{ // // Restore General Condition
			if (hp_cost == 0)	return cmd::enter(playerid, "");
			static const dlgstr[] = "{FFFFFF}Ban co chac chan muon khoi phuc lai tinh trang chung cua chiec xe voi gia {1b8922}$%i{FFFFFF} khong?";
			new mes[sizeof(dlgstr)+6];

			format(mes, sizeof(mes), dlgstr, hp_cost);

			ConfirmDialog(playerid, "Xac nhan", mes, "RepairHP");
		}
		case 3: 
		{ // Restore Battery Health
			if (VehicleInfo[vehicle][carBattery] >= 20.0)	
			{
				cmd::enter(playerid, "");
				return SendErrorMessage(playerid, "Binh ac quy xe nay khong can sua chua ( > 20%%).");
			}
			static const dlgstr[] = "{FFFFFF}Ban co chac chan muon khoi phuc lai tinh trang cua binh ac quy {1b8922}$%i{FFFFFF}?";
			new mes[sizeof(dlgstr)+6];

			format(mes, sizeof(mes), dlgstr, floatround(GetVehiclePrice(model) / 100 * 5, floatround_round));

			ConfirmDialog(playerid, "Xac nhan", mes, "ChangeBattery");
		}
		case 4: 
		{ // Restore Vehicle Engine
			if (VehicleInfo[vehicle][carEngine] >= 20.0)	
			{
				cmd::enter(playerid, "");
				return SendErrorMessage(playerid, "Dong co cua xe nay khong can sua chua ( > 20%%).");
			}
			static const dlgstr[] = "{FFFFFF}Ban co chac chan muon thay dong co xe voi gia {1b8922}$%i{FFFFFF} khong?";
			new mes[sizeof(dlgstr)+6];

			format(mes, sizeof(mes), dlgstr, floatround(GetVehiclePrice(model) / 100 * 10, floatround_round));

			ConfirmDialog(playerid, "Xac nhan", mes, "ChangeEngine");
		}
	}
	return 1;
}


Dialog:SELECT_Autoservice(playerid, response, listitem, inputtext[])
{
	if (!response) return cmd::enter(playerid, "");

	new panels, doors, lights, tires;
	GetVehicleStatus(playerid, panels, doors, lights, tires);

	new vehicle = GetPlayerVehicleID(playerid),
		model = GetVehicleModel(vehicle),
		cost = floatround(GetVehiclePrice(model) / 4, floatround_round), 
		panel_cost = floatround((cost * 0.5 * panels/100), floatround_round), 
		door_cost = floatround((cost * 0.25 * doors/100), floatround_round),
		light_cost = floatround((cost * 0.1 * lights/100), floatround_round),
		tire_cost = floatround((cost * 0.15 * tires/100), floatround_round);

	if (listitem == 4) {
		new count;
		for(new i; i < 4; i++) if (pTemp[playerid][pListed][i]) count++;

		if (count) {
			count = 0;

			if (pTemp[playerid][pListed][0]) count += panel_cost;
			if (pTemp[playerid][pListed][1]) count += door_cost;
			if (pTemp[playerid][pListed][2]) count += light_cost;
			if (pTemp[playerid][pListed][3]) count += tire_cost;

			if (count) {
				static const dlgstr[] = "{FFFFFF}Ban co chac chan muon sua xe voi gia {1b8922}$%i{FFFFFF} khong?";
				new mes[sizeof(dlgstr)+6];

				SetPVarInt(playerid, #auto_cost, count);

				format(mes, sizeof(mes), dlgstr, count);
				return ConfirmDialog(playerid, "Xac nhan", mes, "RepairList");
			}
		}
	}

	if (!pTemp[playerid][pListed][listitem]) 	pTemp[playerid][pListed][listitem] = 1;
	else 										pTemp[playerid][pListed][listitem] = 0;

	if (listitem == 0 && !panel_cost)		pTemp[playerid][pListed][listitem] = 0;
	else if (listitem == 1 && !door_cost)	pTemp[playerid][pListed][listitem] = 0;
	else if (listitem == 2 && !light_cost)	pTemp[playerid][pListed][listitem] = 0;
	else if (listitem == 3 && !tire_cost)	pTemp[playerid][pListed][listitem] = 0;

	static const select[] = "{FFFF00}[ X ]{FFFFFF}";
	static const unselect[] = "{C5C5C5}[ - ]{FFFFFF}";

	new mes[526 + 8*4] = "Chon cac hang muc ban muon sua chua:\n";

	if (pTemp[playerid][pListed][0]) format(mes, sizeof(mes), "%s%s Sua chua than xe: {1b8922}$%i {c5c5c5}(Thiet hai: {FF6347}%i%%{c5c5c5})\n", mes, select, panel_cost, panels);
	else							format(mes, sizeof(mes), "%s%s Sua chua than xe: {1b8922}$%i {c5c5c5}(Thiet hai: {FF6347}%i%%{c5c5c5})\n", mes, unselect, panel_cost, panels);		

	if (pTemp[playerid][pListed][1]) format(mes, sizeof(mes), "%s%s Sua chua canh cua: {1b8922}$%i {c5c5c5}(Thiet hai: {FF6347}%i%%{c5c5c5})\n", mes, select, door_cost, doors);
	else							format(mes, sizeof(mes), "%s%s Sua chua canh cua: {1b8922}$%i {c5c5c5}(Thiet hai: {FF6347}%i%%{c5c5c5})\n", mes, unselect, door_cost, doors);			

	if (pTemp[playerid][pListed][2]) format(mes, sizeof(mes), "%s%s Sua chua den pha: {1b8922}$%i {c5c5c5}(Thiet hai: {FF6347}%i%%{c5c5c5})\n", mes, select, light_cost, lights);
	else							format(mes, sizeof(mes), "%s%s Sua chua den pha: {1b8922}$%i {c5c5c5}(Thiet hai: {FF6347}%i%%{c5c5c5})\n", mes, unselect, light_cost, lights);			

	if (pTemp[playerid][pListed][3]) format(mes, sizeof(mes), "%s%s Sua chua lop xe: {1b8922}$%i {c5c5c5}(Thiet hai: {FF6347}%i%%{c5c5c5})\n", mes, select, tire_cost, tires);
	else							format(mes, sizeof(mes), "%s%s Sua chua lop xe: {1b8922}$%i {c5c5c5}(Thiet hai: {FF6347}%i%%{c5c5c5})\n", mes, unselect, tire_cost, tires);			

	format(mes, sizeof(mes), "%s{C5C5C5} >> SUA CHUA >>", mes);
	Dialog_Show(playerid, SELECT_Autoservice, DIALOG_STYLE_TABLIST_HEADERS, "Sua chua xe - chon doanh muc", mes, "Chon", "Huy bo");
	return 1;
}


Dialog:ModDialog(playerid, response, listitem, inputtext[])
{
	if (!response) return 1;

	new vehicle = GetPlayerVehicleID(playerid);
	
	if (!IsPlayerInAnyVehicle(playerid) || !VehicleInfo[vehicle][carOwnerID])	return 1;
   	if (ModShop_Nearest(playerid) == -1)										return 1;

	if (listitem == 0)
	{
	    if (IsABicycle(vehicle) || IsABiker(vehicle) || IsATaxi(vehicle))	return SendErrorMessage(playerid, "Chuc nang nay khong kha dung cho xe dap, xe may va taxi.");
			
	    if (IsVehicleUpgradeCompatible(GetVehicleModel(vehicle), 1008) != 1 && IsVehicleUpgradeCompatible(GetVehicleModel(vehicle), 1009) != 1 && IsVehicleUpgradeCompatible(GetVehicleModel(vehicle), 1010) != 1)
		{
		    ShowModMenu(playerid);
			return SendErrorMessage(playerid, "Ban khong the cai dat nitro tren xe nay.");
		}

        Dialog_Show(playerid, NitroDialog, DIALOG_STYLE_TABLIST, "{33AA33}Dieu chinh phuong tien", "Nitro x2\t$4.500\nNitro x5\t$9.000\nNitro x10\t$15000", "Chon", "Quay lai");
		return 1;
	}

	else if (listitem == 1)
	{
	    if (!IsVehiclePaintJob(GetVehicleModel(vehicle)))	return SendErrorMessage(playerid, "Tac pham hoi hoa khong co san cho phuong tien nay.");

		new mes[128];

		for(new i; i != IsVehiclePaintJob(GetVehicleModel(vehicle)); i++)
		{
			format(mes, sizeof(mes), "%s\nPainting work %i", mes, i+1);
	    }

	    Dialog_Show(playerid, PaintjobDialog, DIALOG_STYLE_LIST, "{33AA33}Gia: $3.000", mes, "Chon", "Quay lai");
	    return 1;
	}

	else if (listitem == 2)
	{
	    new vehiclescolor[256], List:colorss = list_new();
		for(new i; i < 256; i++)
		{
			vehiclescolor[i] = i;
			AddModelMenuItem(colorss, 400, "", true, -87.00, 0.0, 270.0, 0.190, vehiclescolor[i], vehiclescolor[i]);
			
		}
		ShowModelSelectionMenu(playerid, "Colors", MODEL_SELECTION_COLOR, colorss);
	    SetPVarInt(playerid, #veh_color1, -1);
	    SetPVarInt(playerid, #veh_color_type, 2);
	    return 1;
	}

	else if (listitem == 3)
	{
	    if (IsABicycle(vehicle) || IsABiker(vehicle) || IsATaxi(vehicle))	return SendErrorMessage(playerid, "Chuc nang nay khong kha dung cho xe dap, xe may va taxi. ");
			
	    if (VehicleInfo[vehicle][carComponent][CARMODTYPE_HYDRAULICS])
		{
		    ShowModMenu(playerid);
			return SendErrorMessage(playerid, "Ban da cai dat he thong thuy luc. ");
		}
	    Dialog_Show(playerid, HydralicConfrim, DIALOG_STYLE_MSGBOX, "{33AA33}Dieu chinh phuong tien", "{FFFFFF}Ban chac chan muon lap dat he thong thuy luc voi gia $8.000?", "Co", "Quay lai");
		return 1;
	}

	else if (listitem == 4)
	{
	    if (IsABicycle(vehicle) || IsABiker(vehicle) || IsATaxi(vehicle))	return SendErrorMessage(playerid, "Chuc nang nay khong kha dung cho xe dap, xe may va taxi.");
			
		if (VehicleInfo[vehicle][carRadio])
		{
		    ShowModMenu(playerid);
			return SendErrorMessage(playerid, "Ban da co mot may ghi am radio.");
		}

		Dialog_Show(playerid, RadioConfrim, DIALOG_STYLE_MSGBOX, "{33AA33}Dieu chinh phuong tien", "{FFFFFF}Ban chac chan muon cai dat may ghi am radio voi gia $400?", "Co", "Quay lai");
	    return 1;
	}
	else if (listitem == 5)
	{
		if (VehicleInfo[vehicle][carGps])
		{
		    ShowModMenu(playerid);
			return SendErrorMessage(playerid, "Ban da co mot GPS.");
		}

		Dialog_Show(playerid, GPSConfrim, DIALOG_STYLE_MSGBOX, "{33AA33}Dieu chinh phuong tien", "{FFFFFF}Ban chac chan muon cai dat GPS voi gia $1.500?", "Co", "Quay lai");
	    return 1;
	}
	else if (listitem == 6)
	{
		new cost = GetVehiclePrice(GetVehicleModel(vehicle)) / 100 * 10;

		if (cost < 1) 					return 1;
		if (GetCash(playerid) < cost)	return SendErrorMessage(playerid, "Chi phi thay doi dong co la $%i.", cost);

		StartVehicleUpgrade(playerid, vehicle, 9, cost);
		return 1;
	}
	else if (listitem == 7)
	{
		new cost = GetVehiclePrice(GetVehicleModel(vehicle)) / 100 * 5;

		if (cost < 1)					return 1;
		if (GetCash(playerid) < cost)	return SendErrorMessage(playerid, "Chi phi thay doi ac quy la $%i.", cost);

		StartVehicleUpgrade(playerid, vehicle, 11, cost);
		return 1;
	}
	else if (listitem == 8)
	{
		Dialog_Show(playerid, ChangeLock, DIALOG_STYLE_MSGBOX, "{33AA33}Thay doi khoa", "{FFFFFF}Ban chac chan muon thay o khoa voi gia $300?\nTat ca cac chia khoa trung lap da cap tu xe cua ban se tro nen khong hop le.", "Co", "Quay lai");
	    return 1;
	}
	else if (listitem == 9)
	{
	    static const str_size[] = "1. Khoa\t[cap do %i]\n2. Bao dong\t[cap do %i]\n3. Immobilizer\t[cap do %i]\n4. Bao hiem\t[cap do %i]\n5. Giap\t[%.0f HP]";
		new mes[sizeof(str_size) - 18 + 1 + 48];
  		
		format(mes, sizeof(mes), str_size, VehicleInfo[vehicle][carLock], VehicleInfo[vehicle][carAlarm], VehicleInfo[vehicle][carImmob], VehicleInfo[vehicle][carInsurance], VehicleInfo[vehicle][carArmour]);
  		Dialog_Show(playerid, VehUpgrade, DIALOG_STYLE_TABLIST, "{FFFFFF}Cai tien", mes, "Chon", "Quay lai");
		return 1;
	}
	else if (listitem == 10)
	{
	    if (IsABicycle(vehicle) || IsABiker(vehicle) || IsATaxi(vehicle)) return SendErrorMessage(playerid, "Chuc nang nay khong kha dung cho xe dap, xe may va taxi. ");
			
		new mes[512] = "{AFAFAF}Xoa{FFFFFF} nitro\n{AFAFAF}Xoa{FFFFFF} painting works\n{AFAFAF}Xoa{FFFFFF} hydraulics\n{AFAFAF}Xoa{FFFFFF} may ghi am vo tuyen";

	    Dialog_Show(playerid, DeleteTuning, DIALOG_STYLE_LIST, "{33AA33}Xoa dieu chinh", mes, "Chon", "Quay lai");
	    return 1;
	}

	ShowComponentMenu(playerid, vehicle, listitem);
	return 1;
}

Dialog:ModDialogBike(playerid, response, listitem, inputtext[])
{
	if (!response)	return 1;

	new vehicle = GetPlayerVehicleID(playerid);

	if (!IsPlayerInAnyVehicle(playerid) || !VehicleInfo[vehicle][carOwnerID])	return 1;
   	if (ModShop_Nearest(playerid) == -1)											return 1;
  		
	if (listitem == 0)
	{
	    new vehiclescolor[256], List:colorss = list_new();
		for(new i; i < 256; i++)
		{
			vehiclescolor[i] = i;
			AddModelMenuItem(colorss, 400, "", true, -87.00, 0.0, 270.0, 0.190, vehiclescolor[i], vehiclescolor[i]);
			
		}
		ShowModelSelectionMenu(playerid, "Colors", MODEL_SELECTION_COLOR, colorss);
	    SetPVarInt(playerid, #veh_color1, -1);
	    SetPVarInt(playerid, #veh_color_type, 1);
	    return 1;
	}
	return 1;
}

Dialog:BuyVehArmour(playerid, response, listitem, inputtext[])
{
	if (!response)	return ShowModMenu(playerid);
	    
    new vehicle = GetPlayerVehicleID(playerid);

	if (!IsPlayerInAnyVehicle(playerid) || !VehicleInfo[vehicle][carOwnerID])	return 1;
   	if (ModShop_Nearest(playerid) == -1)											return 1;

	new amount = strval(inputtext);

    if (amount < 10 || amount > 250)
	{
	    Dialog_Show(playerid, BuyVehArmour, DIALOG_STYLE_INPUT, "{FFFFFF}Cai dat giap", "{ffffff}Nhap so luong ao giap 10 - 250 ban muon mua [1 don vi co gia $10]:", "Mua", "Quay lai");
	    return SendErrorMessage(playerid, "{FFFFFF}so luong giap chi tu 10 - 250. ");
	}

    if (VehicleInfo[vehicle][carArmour] + amount > 250.0)
	{
	    Dialog_Show(playerid, BuyVehArmour, DIALOG_STYLE_INPUT, "{FFFFFF}Cai dat giap", "{ffffff}Nhap so luong ao giap 10 - 250 ban muon mua [1 don vi co gia $10]:", "Mua", "Quay lai");
	    return SendErrorMessage(playerid, "Ban chi co the mua  %.0f chi so giap.", 250.0 - VehicleInfo[vehicle][carArmour]);
	}
	
    if (VehicleInfo[vehicle][carAttach3DtextUse]) return SendErrorMessage(playerid, "Cho da, hoat dong da duoc tien hanh.");

	if (GetCash(playerid) < amount * 10)
	{
	    Dialog_Show(playerid, BuyVehArmour, DIALOG_STYLE_INPUT, "{FFFFFF}Cai dat giap", "{ffffff}Nhap so luong ao giap 10 - 250 ban muon mua [1 don vi co gia $10]:", "Mua", "Quay lai");
 		return SendErrorMessage(playerid, "Gia cua cai giap la $%i.", amount * 10);
	}

	StartVehicleUpgrade(playerid, vehicle, 6, 10 * amount, amount);
	FreezePlayer(playerid);
	return 1;
}

Dialog:BuyVehInsurance(playerid, response, listitem, inputtext[])
{
	if (!response) return ShowModMenu(playerid);
	    
    new vehicle = GetPlayerVehicleID(playerid);

	if (!IsPlayerInAnyVehicle(playerid) || !VehicleInfo[vehicle][carOwnerID])	return 1;
   	if (ModShop_Nearest(playerid) == -1)										return 1;
  		
    new cost = GetInsurancePrice(GetVehicleModel(vehicle));

    if (!cost)										return SendErrorMessage(playerid, "Bao hiem khong co san cho chiec xe nay.");
    if (!VehicleInfo[vehicle][carRegistered])		return SendErrorMessage(playerid, "Phuong tien nay chua duoc dang ky.");
	if (VehicleInfo[vehicle][carAttach3DtextUse])	return SendErrorMessage(playerid, "Cho da, hoat dong da duoc tien hanh.");

	new level = strval(inputtext);

	if (level < 1 || level > 3)						return SendErrorMessage(playerid, "Cap do bao hiem tu 1 den 3. ");
	if (VehicleInfo[vehicle][carInsurance] >= level)	return SendErrorMessage(playerid, "Ban da co bao hiem cap do %i.", VehicleInfo[vehicle][carInsurance]);
	if (GetCash(playerid) < cost * level)			return SendNotCash(playerid);

	StartVehicleUpgrade(playerid, vehicle, 5, cost * level, level);
	return 1;
}

Dialog:VehUpgrade(playerid, response, listitem, inputtext[])
{
	if (!response)	return ShowModMenu(playerid);
	    
    new vehicle = GetPlayerVehicleID(playerid);

	if (!IsPlayerInAnyVehicle(playerid) || !VehicleInfo[vehicle][carOwnerID])	return 1;
   	if (ModShop_Nearest(playerid) == -1)											return 1;

    if (listitem == 3)
	{
	    new cost = GetInsurancePrice(GetVehicleModel(vehicle));

	    if (!cost)	return SendErrorMessage(playerid, "Bao hiem khong co san cho chiec xe nay.");
	    
	    new mes[590] = "{ffffff}1 cap do \t- $%i\n{ecc317}+ {ffffff}Phuong tien se hoi sinh voi suc khoe toi da.\n\n{ffffff}2 cap do \t- $%i\n\
		{ecc317}+ {ffffff}Phuong tien se hoi sinh voi suc khoe toi da.\n{ecc317}+ {ffffff}Xe se hoi sinh ma khong bi hu hai.\n\n{ffffff}3 cap do \t- $%i\n";
		
	    strcat(mes, "{ecc317}+ {ffffff}Phuong tien se hoi sinh voi suc khoe toi da.\n{ecc317}+ {ffffff}Xe se hoi sinh ma khong bi hu hai.\n{ecc317}+ {ffffff}Bao quan dieu chinh va dai phat thanh.\n\nNhap cap do \tbao hiem ma ban muon mua vao o ben duoi:");
	    format(mes, sizeof(mes), mes, cost * 1, cost * 2, cost * 3);
	    Dialog_Show(playerid, BuyVehInsurance, DIALOG_STYLE_INPUT, "{FFFFFF}Mua bao hiem", mes, "Mua", "Quay lai");
	    return 1;
	}

	else if (listitem == 4)
	{
	    return Dialog_Show(playerid, BuyVehArmour, DIALOG_STYLE_INPUT, "{FFFFFF}Cai dat giap", "{ffffff}Nhap so luong ao giap 10 - 250 ban muon mua [1 don vi co gia $10]:", "Mua", "Quay lai");
	}

	new alarm_mes[][] =
	{
	    {"{ecc317}+ {ffffff}Bao dong bang am thanh lon."}, {"{ecc317}+ {ffffff}Bao dong bang am thanh lon.\n{ecc317}+ {ffffff}Canh bao cho canh sat."}, 
		{"{ecc317}+ {ffffff}Bao dong bang am thanh lon.\n{ecc317}+ {ffffff}Canh bao cho canh sat.\n{ecc317}+ {ffffff}Thong bao ve viec hack cho chu so huu bang SMS. "},
		{"{ecc317}+ {ffffff}Bao dong bang am thanh lon.\n{ecc317}+ {ffffff}Canh bao cho canh sat.\n{ecc317}+ {ffffff}Thong bao ve viec hack cho chu so huu bang SMS + hoa don. "}
	};

	new mes[256];

	switch(listitem)
	{
	    case 0:
		{
		    if (VehicleInfo[vehicle][carLock] >= sizeof(price_mod_lock))		return SendErrorMessage(playerid, "Cap do khoa da dat toi da.");

			format(mes, sizeof(mes), "{ffffff}Nang cap khoa cap do %i voi gia $%i?\n{ecc317}+ {ffffff}%i giay pha khoa xe.", VehicleInfo[vehicle][carLock]+1, price_mod_lock[VehicleInfo[vehicle][carLock]], 250 + (GetPVarInt(playerid, "BuyingVehicleLock") * 250));
		}
		case 1:
		{
		    if (VehicleInfo[vehicle][carAlarm] >= sizeof(price_mod_alarm))	return SendErrorMessage(playerid, "Cap do bao dong dat toi da.");

			format(mes, sizeof(mes), "{ffffff}Nang cap bao dong cap do %i voi gia $%i?\n%s", VehicleInfo[vehicle][carAlarm]+1, price_mod_alarm[VehicleInfo[vehicle][carAlarm]], alarm_mes[VehicleInfo[vehicle][carAlarm]]);
		}
		case 2:
		{
		    if (VehicleInfo[vehicle][carImmob] >= sizeof(price_mod_immob))	return SendErrorMessage(playerid, "Cap do immobilizer dat toi da.");

			format(mes, sizeof(mes), "{ffffff}Nang cap immobilizer cap do %i voi gia $%i?\n{ecc317}+ {ffffff}Giup cong tac danh lua khong bi hong.", VehicleInfo[vehicle][carImmob]+1, price_mod_immob[VehicleInfo[vehicle][carImmob]]);
		}
	}

	SetPVarInt(playerid, #upgrade_veh, listitem);
	Dialog_Show(playerid, BuyVehUpgrade2, DIALOG_STYLE_MSGBOX, "{FFFFFF}Nang cap", mes, "Mua", "Quay lai");
 	return 1;
}

Dialog:BuyVehUpgrade2(playerid, response, listitem, inputtext[])
{
    if (!response)	return ShowModMenu(playerid);

    new vehicle = GetPlayerVehicleID(playerid);

	if (!IsPlayerInAnyVehicle(playerid) || !VehicleInfo[vehicle][carOwnerID])	return 1;
   	if (ModShop_Nearest(playerid) == -1)										return 1;
  		
    listitem = GetPVarInt(playerid, #upgrade_veh);

    switch(listitem)
    {
        case 0: StartVehicleUpgrade(playerid, vehicle, 2, price_mod_lock[VehicleInfo[vehicle][carLock]], VehicleInfo[vehicle][carLock]+1);
        case 1: StartVehicleUpgrade(playerid, vehicle, 3, price_mod_alarm[VehicleInfo[vehicle][carAlarm]], VehicleInfo[vehicle][carAlarm]+1);
        case 2: StartVehicleUpgrade(playerid, vehicle, 4, price_mod_immob[VehicleInfo[vehicle][carImmob]], VehicleInfo[vehicle][carImmob]+1);
    }
	return 1;
}

Dialog:SelectModDialog(playerid, response, listitem, inputtext[])
{
    new vehicle = GetPlayerVehicleID(playerid), comptype = GetPVarInt(playerid, #component_type), compid = -1;

    if (!IsPlayerInAnyVehicle(playerid) || !VehicleInfo[vehicle][carOwnerID])	return 1;
    if (!response)																return ShowModMenu(playerid);
   	if (ModShop_Nearest(playerid) == -1)										return 1;

    for(new i; i != max_vehicle_components[comptype]; i++)
	{
		if (!vehicle_component[comptype][i][compID] || IsVehicleUpgradeCompatible(GetVehicleModel(vehicle), vehicle_component[comptype][i][compID]) != 1) continue;

		compid++;
		if (listitem == compid)
		{
			compid = i;
			break;
		}
   	}

   	new modelid = vehicle_component[comptype][compid][compID];

   	if (GetVehicleComponentType(modelid) == -1 || IsVehicleUpgradeCompatible(GetVehicleModel(vehicle), modelid) != 1)
	{
		ShowModMenu(playerid);
		return SendErrorMessage(playerid, "Bo phan nay khong phu hop voi xe cua ban.");
	}

	if (comptype == -1 || compid == -1)	return SendErrorMessage(playerid, "Chi tiet loi ID, vui long lien he quan tri. ");

    new mes[128];
    format(mes, sizeof(mes), "{FFFFFF}Ban co chac chan muon cai dat %s voi gia $%i?", GetComponentName(modelid), vehicle_component[comptype][compid][compPrice]);

    Dialog_Show(playerid, ModConfrim, DIALOG_STYLE_MSGBOX, "{33AA33}Dieu chinh phuong tien", mes, "Co", "Quay lai");
    SetPVarInt(playerid, #component_model, modelid);
    SetPVarInt(playerid, #component_type, comptype);
    AddVehicleComponent(vehicle, modelid);
	return 1;
}

Dialog:DeleteTuning(playerid, response, listitem, inputtext)
{
    if (!response)	return ShowModMenu(playerid);

    new vehicle = GetPlayerVehicleID(playerid);

	if (!IsPlayerInAnyVehicle(playerid) || !VehicleInfo[vehicle][carOwnerID])	return 1;
   	if (ModShop_Nearest(playerid) == -1)											return 1;
	if (listitem == 9 && VehicleInfo[vehicle][carPaintJob] == 3)
	{
	    ShowModMenu(playerid);
	    return SendErrorMessage(playerid, "Ban khong co tac pham son nao duoc cai dat.");
	}
    if (listitem == 11 && VehicleInfo[vehicle][carRadio] == 0)
    {
	    ShowModMenu(playerid);
	    return SendErrorMessage(playerid, "Ban chua cai dat may ghi am vo tuyen.");
	}

  	new comp_type[11] = {CARMODTYPE_WHEELS, CARMODTYPE_SPOILER, CARMODTYPE_HOOD, CARMODTYPE_ROOF, CARMODTYPE_SIDESKIRT, CARMODTYPE_EXHAUST, CARMODTYPE_FRONT_BUMPER, CARMODTYPE_REAR_BUMPER, CARMODTYPE_NITRO, 0, CARMODTYPE_HYDRAULICS};

	if (listitem != 9 && listitem != 11 && VehicleInfo[vehicle][carComponent][comp_type[listitem]] == 0)
	{
	    ShowModMenu(playerid);
	    return SendErrorMessage(playerid, "Ban chua cai dat phan nay.");
	}

	new comp_name[12][32] = {"banh xe", "spoiler", "khi nap","mui","vay ben","ong xa","can truoc","can sau","nitro","paint work"," thuy luc ","radio"};

	new mes[128];
	format(mes, sizeof(mes), "{FFFFFF}Ban co chac chan muon xoa bo bo phan %s?", comp_name[listitem]);
	Dialog_Show(playerid, DeleteTuningConfrim, DIALOG_STYLE_MSGBOX, "{33AA33}Xoa dieu chinh", mes, "Co", "Quay lai");
    SetPVarInt(playerid, #select_deltun, listitem);
	return 1;
}

Dialog:DeleteTuningConfrim(playerid, response, listitem, inputtext)
{
    if (!response)	return ShowModMenu(playerid);

    listitem = GetPVarInt(playerid, #select_deltun);

    new vehicle = GetPlayerVehicleID(playerid);

	if (!IsPlayerInAnyVehicle(playerid) || !VehicleInfo[vehicle][carOwnerID])	return 1;
   	if (ModShop_Nearest(playerid) == -1)											return 1;
	if (listitem == 9 && VehicleInfo[vehicle][carPaintJob] == 3)
	{
	    ShowModMenu(playerid);
	    return SendErrorMessage(playerid, "Ban chua co tac pham son nao duoc cai dat.");
	}

    if (listitem == 11 && VehicleInfo[vehicle][carRadio] == 0)
    {
	    ShowModMenu(playerid);
	    return SendErrorMessage(playerid, "Ban chua cai dat may ghi am vo tuyen.");
	}

  	new comp_type[11] = {CARMODTYPE_WHEELS, CARMODTYPE_SPOILER, CARMODTYPE_HOOD, CARMODTYPE_ROOF, CARMODTYPE_SIDESKIRT, CARMODTYPE_EXHAUST, CARMODTYPE_FRONT_BUMPER, CARMODTYPE_REAR_BUMPER, CARMODTYPE_NITRO, 0, CARMODTYPE_HYDRAULICS};

	if (listitem != 9 && listitem != 11 && VehicleInfo[vehicle][carComponent][comp_type[listitem]] == 0)
	{
	    ShowModMenu(playerid);
	    return SendErrorMessage(playerid, "Ban chua cai dat phan nay.");
	}
    if (listitem == 9)
	{
	    VehicleInfo[vehicle][carPaintJob] = 3;
	    ChangeVehiclePaintjob(vehicle, 3);
	}
    else if (listitem == 11)
	{
        VehicleInfo[vehicle][carRadio] = 0;
	}
	else
	{
	    RemoveVehicleComponent(vehicle, VehicleInfo[vehicle][carComponent][comp_type[listitem]]);
	    VehicleInfo[vehicle][carComponent][comp_type[listitem]] = 0;
	}

	new comp_name[12][32] = {"banh xe", "spoiler", "khi nap","mui","vay ben","ong xa","can truoc","can sau","nitro","paint work"," thuy luc ","radio"};

	SendSyntaxMessage(playerid, "Ban da xoa thanh cong bo phan %s khoi phuong tien.", comp_name[listitem]);
	return 1;
}

Dialog:HydralicConfrim(playerid, response, listitem, inputtext[])
{
	if (!response)	return ShowModMenu(playerid);

	new modshop = -1, vehicle = GetPlayerVehicleID(playerid);

	if (!IsPlayerInAnyVehicle(playerid) || !VehicleInfo[vehicle][carOwnerID])	return 1;
   	if ((modshop = ModShop_Nearest(playerid)) == -1)							return 1;
	if (GetCash(playerid) < 8000)
	{
	   	ShowModMenu(playerid);
		return SendNotCash(playerid);
	}
	if (IsVehicleUpgradeCompatible(GetVehicleModel(vehicle), 1087) != 1)
	{
	    ShowModMenu(playerid);
	    return SendErrorMessage(playerid, "Khong the lap dat thuy luc tren phuong tien nay.");
	}

    if (BizInfo[modshop][bizOwnerID] && !BizInfo[modshop][bizProduct])	return SendErrorMessage(playerid, "Khong co du bo phan trong studio dieu chinh de thuc hien cong viec.");
    
	GiveCash(playerid, -8000);
    SetVehicleComponent(vehicle, 1087, GetVehicleComponentType(1087));
	SendSyntaxMessage(playerid, "Ban da mua he thong thuy luc voi gia $8,000.");
	
	if (BizInfo[modshop][bizOwnerID])
	{
		BizInfo[modshop][bizProduct]--;
		GiveBizCash(modshop, 8000 / 100 * 80);
	}

	PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	return 1;
}

Dialog:RadioConfrim(playerid, response, listitem, inputtext[])
{
	if (!response)	return ShowModMenu(playerid);

	new modshop = -1, vehicle = GetPlayerVehicleID(playerid);

	if (!IsPlayerInAnyVehicle(playerid) || !VehicleInfo[vehicle][carOwnerID])	return 1;
   	if ((modshop = ModShop_Nearest(playerid)) == -1)								return 1;

	if (VehicleInfo[vehicle][carRadio] == 1)
	{
	    ShowModMenu(playerid);
		return SCM(playerid, COLOR_LIGHTRED, "Ban da co mot may ghi am vo tuyen.");
	}
	if (GetCash(playerid) < 400)
	{
	    ShowModMenu(playerid);
		return SendNotCash(playerid);
	}

	GiveCash(playerid, -400);
	VehicleInfo[vehicle][carRadio] = 1;
	SendSyntaxMessage(playerid, "Ban da mua radio voi gia $400. Su dung /setstation de dieu chinh radio.");
    GiveBizCash(modshop, 400);
	PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	return 1;
}

Dialog:GPSConfrim(playerid, response, listitem, inputtext[])
{
	if (!response)	return ShowModMenu(playerid);

	new modshop = -1, vehicle = GetPlayerVehicleID(playerid);

	if (!IsPlayerInAnyVehicle(playerid) || !VehicleInfo[vehicle][carOwnerID])	return 1;
   	if ((modshop = ModShop_Nearest(playerid)) == -1)								return 1;
	if (VehicleInfo[vehicle][carGps] == 1)
	{
	    ShowModMenu(playerid);
		return SendErrorMessage(playerid, "Ban da co mot GPS.");
	}

	if (GetCash(playerid) < 1500)
	{
	    ShowModMenu(playerid);
		return SendNotCash(playerid);
	}

	GiveCash(playerid, -1500);
	VehicleInfo[vehicle][carGps] = 1;
	SendSyntaxMessage(playerid, "Ban da mua mot cai GPS voi gia $1,500. Su dung /v find de tim phuong tien.");
    GiveBizCash(modshop, 1500);
	PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	return 1;
}

Dialog:ChangeLock(playerid, response, listitem, inputtext[])
{
	if (!response)	return ShowModMenu(playerid);

	new modshop = -1, vehicle = GetPlayerVehicleID(playerid);

	if (!IsPlayerInAnyVehicle(playerid) || VehicleInfo[vehicle][carOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Ban phai o trong mot phuong tien ca nhan.");
   	if ((modshop = ModShop_Nearest(playerid)) == -1)														return 1;

	if (VehicleInfo[vehicle][carGps] == 1)
	{
	    ShowModMenu(playerid);
		return SendErrorMessage(playerid, "Ban da co mot GPS.");
	}

	if (GetCash(playerid) < 300)
	{
	    ShowModMenu(playerid);
		return SendNotCash(playerid);
	}

	GiveCash(playerid, -300);
	foreach(new i : Player)
	{
		if (!IsPlayerLogged(i) || PlayerInfo[i][pSpareKey] != VehicleInfo[vehicle][carID]) continue;
			
        PlayerInfo[i][pSpareKey] = 0;
	}
	
	new query[128];
    mysql_format(dbHandle, query, sizeof(query), "UPDATE `users` SET `sparekey`='0' WHERE `sparekey`=%i", VehicleInfo[vehicle][carID]);
	mysql_tquery(dbHandle, query);
	
	SendSyntaxMessage(playerid, "Ban da thay doi khoa voi gia $300.");
    GiveBizCash(modshop, 300);
	PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	return 1;
}

Dialog:ModConfrim(playerid, response, listitem, inputtext[])
{
   	new modshop = -1, vehicle = GetPlayerVehicleID(playerid), modelid = GetPVarInt(playerid, #component_model);
    
	RemoveVehicleComponent(vehicle, modelid);
    LoadComp(vehicle);
    
   	if (!response)																return ShowComponentMenu(playerid, vehicle, GetPVarInt(playerid, #component_type));
	if (!IsPlayerInAnyVehicle(playerid) || !VehicleInfo[vehicle][carOwnerID])	return 1;
	if ((modshop = ModShop_Nearest(playerid)) == -1)							return 1;
	if (GetVehicleComponentType(modelid) == -1 || IsVehicleUpgradeCompatible(GetVehicleModel(vehicle), modelid) != 1)
	{
 		ShowModMenu(playerid);
   		return SendErrorMessage(playerid, "Bo phan nay khong phu hop voi xe cua ban.");
	}

	new compid = -1, comptype = -1;

	for(new i; i != sizeof(vehicle_component); i++)
	{
	    for(new a; a != max_vehicle_components[i]; a++)
		{
	    	if (vehicle_component[i][a][compID] != modelid) continue;

			comptype = i;
			compid = a;
			break;
		}

		if (comptype != -1 && compid != -1) break;
	}

	if (comptype == -1 || compid == -1)	return SendErrorMessage(playerid,"Loi phan ID, vui long lien he quan tri.");

	if (GetCash(playerid) < vehicle_component[comptype][compid][compPrice])
	{
	    ShowModMenu(playerid);
	    return SendErrorMessage(playerid, "Ban khong co du tien. Chi phi cua phan nay $%i.", vehicle_component[comptype][compid][compPrice]);
	}

	if (HasComponent(vehicle, modelid))
 	{
  		ShowModMenu(playerid);
		return SendErrorMessage(playerid, "Ban da co phan nay.");
	}

    if (BizInfo[modshop][bizOwnerID] && !BizInfo[modshop][bizProduct])	return SendErrorMessage(playerid, "Khong co du bo phan trong studio dieu chinh de thuc hien cong viec.");
        
	GiveCash(playerid, -vehicle_component[comptype][compid][compPrice]);
	
	if (BizInfo[modshop][bizOwnerID] != 0)
	{
		BizInfo[modshop][bizProduct]--;
		GiveBizCash(modshop, vehicle_component[comptype][compid][compPrice] / 100 * 80);
	}
	
	SendSyntaxMessage(playerid, "Ban da mua duoc %s voi gia $%i.", GetComponentName(modelid), vehicle_component[comptype][compid][compPrice]);
	SetVehicleComponent(vehicle, modelid, GetVehicleComponentType(modelid));
	PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	return 1;
}

Dialog:PaintjobDialog(playerid, response, listitem, inputtext[])
{
	if (!response)	return ShowModMenu(playerid);

	new vehicle = GetPlayerVehicleID(playerid);

	if (!IsPlayerInAnyVehicle(playerid) || !VehicleInfo[vehicle][carOwnerID])	return 1;
    if (IsVehiclePaintJob(GetVehicleModel(vehicle)) < listitem+1)				return 1;
   	if (ModShop_Nearest(playerid) == -1)											return 1;

    if (VehicleInfo[vehicle][carPaintJob] == listitem)
    {
        ShowModMenu(playerid);
		return SendErrorMessage(playerid, "Ban da cai dat paintjob nay.");
	}

	new mes[128];

	format(mes, sizeof(mes), "{FFFFFF}Ban co chan chan muon cai dat paintjob %i voi gia $3.000?", listitem+1);
	Dialog_Show(playerid, PaintjobConfrim, DIALOG_STYLE_MSGBOX, "{33AA33}Dieu chinh phuong tien", mes, "Co", "Quay lai");
    SetPVarInt(playerid, #select_paintjob, listitem);

	ChangeVehiclePaintjob(vehicle, listitem);
	return 1;
}

Dialog:PaintjobConfrim(playerid, response, listitem, inputtext[])
{
    listitem = GetPVarInt(playerid, #select_paintjob);

	new modshop = -1, vehicle = GetPlayerVehicleID(playerid);

    ChangeVehiclePaintjob(vehicle, VehicleInfo[vehicle][carPaintJob]);
    
    if (!response)																return ShowModMenu(playerid);
	if (!IsPlayerInAnyVehicle(playerid) || !VehicleInfo[vehicle][carOwnerID])	return 1;
   	if ((modshop = ModShop_Nearest(playerid)) == -1)							return 1;
	if (!IsVehiclePaintJob(GetVehicleModel(vehicle)))							return SendErrorMessage(playerid, "Paintjob khong co san cho phuong tien nay");
	if (VehicleInfo[vehicle][carPaintJob] == listitem)
    {
        ShowModMenu(playerid);
		return SendErrorMessage(playerid, "Ban da cai dat paintjob nay.");
	}
	if (GetCash(playerid) < 3000)
	{
	    ShowModMenu(playerid);
		return SendNotCash(playerid);
	}
	if (BizInfo[modshop][bizOwnerID] && !BizInfo[modshop][bizProduct])	return SendErrorMessage(playerid,"Khong co du bo phan trong studio dieu chinh de thuc hien cong viec.");
	
	GiveCash(playerid, -3000);
	VehicleInfo[vehicle][carPaintJob] = listitem;
	ChangeVehiclePaintjob(vehicle, listitem);
	Save_Car(vehicle);
	SendSyntaxMessage(playerid, "Ban da mua paintjob %i voi gia $3.000.", listitem+1);

    if (BizInfo[modshop][bizOwnerID] != 0)
    {
		BizInfo[modshop][bizProduct]--;
		GiveBizCash(modshop, 3000 / 100 * 80);
	}
	PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
	return 1;
}

Dialog:NitroDialog(playerid, response, listitem, inputtext[])
{
	if (!response)	return ShowModMenu(playerid);

	new vehicle = GetPlayerVehicleID(playerid);

	if (!IsPlayerInAnyVehicle(playerid) || !VehicleInfo[vehicle][carOwnerID])	return 1;
   	if (ModShop_Nearest(playerid) == -1)										return 1;

	new nitro_id[3] = {1009, 1008, 1010}, nitro_price[3] = {4500, 9000, 15000};

    if (HasComponent(vehicle, nitro_id[listitem]))
    {
        ShowModMenu(playerid);
		return SendErrorMessage(playerid, "Ban da cai dat nitro.");
	}

	new mes[128];

	format(mes, sizeof(mes), "{FFFFFF}Ban co chac chan muon cai dat nitro %i voi gia $%i?", (listitem == 0)?(2):((listitem == 1)?(5):(10)), nitro_price[listitem]);
	Dialog_Show(playerid, NitroConfrim, DIALOG_STYLE_MSGBOX, "{33AA33}Dieu chinh phuong tien", mes, "Co", "Quay lai");
    SetPVarInt(playerid, #select_nitro, listitem);
	return 1;
}

Dialog:NitroConfrim(playerid, response, listitem, inputtext[])
{
	if (!response) return ShowModMenu(playerid);

    listitem = GetPVarInt(playerid, #select_nitro);

	new modshop = -1, vehicle = GetPlayerVehicleID(playerid);

	if (!IsPlayerInAnyVehicle(playerid) || !VehicleInfo[vehicle][carOwnerID])	return 1;
   	if ((modshop = ModShop_Nearest(playerid)) == -1)								return 1;

	new nitro_id[3] = {1009, 1008, 1010}, nitro_price[3] = {15000, 15500, 16000}, nitro_level[3] = {2, 5, 10};

    if (HasComponent(vehicle, nitro_id[listitem]))
    {
        ShowModMenu(playerid);
		return SendErrorMessage(playerid, "Ban da cai dat nitro.");
	}

    if (IsVehicleUpgradeCompatible(GetVehicleModel(vehicle), nitro_id[listitem]) != 1)
    {
        ShowModMenu(playerid);
    	return SendErrorMessage(playerid, "Ban khong the cai dat nitro tren xe nay.");
	}

	if (GetCash(playerid) < nitro_price[listitem])
	{
	    ShowModMenu(playerid);
		return SendNotCash(playerid);
	}

	if (PlayerInfo[playerid][pPremium] < 2)								return SendErrorMessage(playerid, "Chi nguoi choi co tai khoan cao cap 'Sliver' tro len moi co the mua nitro.");
    if (BizInfo[modshop][bizOwnerID] && !BizInfo[modshop][bizProduct])	return SendErrorMessage(playerid, "Khong co du bo phan trong studio dieu chinh de thuc hien cong viec.");
        
	GiveCash(playerid, -nitro_price[listitem]);
	SetVehicleComponent(vehicle, nitro_id[listitem], CARMODTYPE_NITRO);
	SendSyntaxMessage(playerid, "Ban da mua nitro %i voi gia $%i.", nitro_level[listitem], nitro_price[listitem]);

    if (BizInfo[modshop][bizOwnerID] != 0)
    {
		BizInfo[modshop][bizProduct]--;
		GiveBizCash(modshop, nitro_price[listitem] / 100 * 80);
	}
	PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	return 1;
}

Dialog:StartJackingLock(playerid, response, listitem, inputtext[])
{	
	if (!response)											 return 1;

	new vehicle = GetPVarInt(playerid, #JackingVehicle);
	if (!vehicle || !GetNearVehicle(playerid, 3.0, vehicle)) return SendErrorMessage(playerid, "Ban phai o gan phuong tien.");
	if (!IsPlayerInFrontVDoor(playerid, vehicle)) 			 return SendErrorMessage(playerid, "Ban nen o gan cua tai xe.");
	if (!VehicleInfo[vehicle][carLocked])					 return SendErrorMessage(playerid, "Cua xe dang mo.");

	if (pTemp[playerid][JackingType] == 2) 
	{
		if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return SendErrorMessage(playerid, "Ban can dung day.");
		switch(VehicleInfo[vehicle][carLock])
		{
			case 0: VehicleInfo[vehicle][eDoorHealth] = 25, VehicleInfo[vehicle][eDoorEffect] = BLOCK_NONE;
			case 1: VehicleInfo[vehicle][eDoorHealth] = 50, VehicleInfo[vehicle][eDoorEffect] = LESS_DAMAGE_FIST;
			case 2: VehicleInfo[vehicle][eDoorHealth] = 75, VehicleInfo[vehicle][eDoorEffect] = BLOCK_FIST;
			case 3: VehicleInfo[vehicle][eDoorHealth] = 150, VehicleInfo[vehicle][eDoorEffect] = LESS_DAMAGE_MELEE;
			case 4: VehicleInfo[vehicle][eDoorHealth] = 200, VehicleInfo[vehicle][eDoorEffect] = BLOCK_PHYSICAL;
			case 5: VehicleInfo[vehicle][eDoorHealth] = 250, VehicleInfo[vehicle][eDoorEffect] = BLOCK_PHYSICAL;
		}
				
		PlaySound(playerid, 1138);
		AlarmOn(vehicle);
		SendHelpMessage(playerid, "Ban phai bat dau dap cua de mo xe!");
		VehicleInfo[vehicle][ePhysicalAttack] = true;

		new doorhealth[12];
		format(doorhealth, 12, "%d%%", VehicleInfo[vehicle][eDoorHealth]);
		VehicleInfo[vehicle][eVehicleLabel] = CreateDynamic3DTextLabel(doorhealth, COLOR_WHITE, 0.0, 0.0, 0.0, 15.0, INVALID_PLAYER_ID, vehicle, 1, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), playerid);
		JackingVehicle[playerid] = vehicle;
		return 1;
	} 
	else if (pTemp[playerid][JackingType] == 1) 
	{
		if (IsPlayerCrouching(playerid) == false) return SendErrorMessage(playerid, "Ban phai ngoi xuong.");
		if (!CheckHanditem(playerid,18634)) 	  return SendErrorMessage(playerid, "Ban nen co mot chiec xa beng trong tay.");
		
		JackingLock[playerid] = 250 + VehicleInfo[vehicle][carLock] * 250;
		
		new mes[128];
		format(mes, sizeof(mes), "lay ra thu gi do va bat dau nghich ngom o khoa %s.", VehicleNames[GetVehicleModel(vehicle)-400]);
		cmd::me(playerid, mes);
		JackingVehicle[playerid] = vehicle;
		return 1;
	} 
	return 1;
}

Dialog:StartJackingEngine(playerid, response, listitem, inputtext[])
{
	if (!response)	return 1;

    new vehicle = GetPlayerVehicleID(playerid);

    if (!vehicle || !IsDriver(playerid))					return SendErrorMessage(playerid, "Ban phai ngoi sau ghe lai xe.");
	if (!VehicleInfo[vehicle][carOwnerID])					return SendErrorMessage(playerid, "Phuong tien nay khong the mo duoc.");
	if (JackingEngine[playerid])							return SendErrorMessage(playerid, "Ban dang co gang khoi dong dong co. ");
	if (VehicleInfo[vehicle][carEngineOn])					return SendErrorMessage(playerid, "Dong co da khoi dong.");
    if (VehicleInfo[vehicle][carFuel] == 0.0)				return SendErrorMessage(playerid, "Khong co nhien lieu trong xe.");
	if (GetPVarInt(playerid, #vehicle_upgrade_timer) > 0)	return SendErrorMessage(playerid, "Hien tai khong the no may duoc.");
	if (GetPVarInt(playerid, #UsePump))						return SendErrorMessage(playerid, "Hien tai khong the no may duoc.");
    if (!IsPlayerHasItem(playerid, INV_TOOLS))				return SendErrorMessage(playerid, "Ban khong co gi de xam nhap vao dong co cua xe. ");

	new mes[128];
	format(mes, sizeof(mes), "chon bo danh lua %s.", VehicleNames[GetVehicleModel(vehicle)-400]);
	cmd::me(playerid, mes);
		
	pTemp[playerid][pUnscrambleID] = random(sizeof(UnscrambleInfo));
		
	switch(VehicleInfo[vehicle][carImmob])
	{
		case 0: JackingEngine[playerid] = 125;
		case 1: JackingEngine[playerid] = 100;
		case 2: JackingEngine[playerid] = 75;
		case 3: JackingEngine[playerid] = 50;
		case 4: JackingEngine[playerid] = 25;
	}
	
	return 1;
}