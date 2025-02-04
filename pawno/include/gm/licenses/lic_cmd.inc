CMD:licenseexam(playerid, params[])
{
	new vehicle = GetPlayerVehicleID(playerid);
	
	if (!IsADMVCar(vehicle) && !IsADMVHeli(vehicle) && !IsADMVTaxi(vehicle)) return SendErrorMessage(playerid, "Ban phai o trong phuong tien DMV.");
	if (!IsDriver(playerid))												 return SendErrorMessage(playerid, "Ban phai dang lai mot chiec xe.");
    if (pTemp[playerid][pLicenseExam] != 0)									 return SendErrorMessage(playerid, "Ban da tham gia mot trong cac bai kiem tra.");
	        
	if (IsADMVCar(vehicle))
	{
        if (PlayerInfo[playerid][pCarLic] != 0)	return SendErrorMessage(playerid, "Ban da co bang lai xe.");
		if (GetCash(playerid) < CARLIC_PRICE)	return SendNotCash(playerid);

		VehicleEngine(vehicle, true); //завести двигатель
		SendSyntaxMessage(playerid, "Ban da bat dau ky thi lay giay phep lai xe.");
		SendSyntaxMessage(playerid, "Ban co %i phut de hoan thanh, neu khong ban se truot ky thi.", EXAM_TIME / 60);
		
		pTemp[playerid][pLicenseExam] = 1;
		SetPVarInt(playerid, #exam_second, EXAM_TIME);
		TogglePlayerDynamicRaceCP(playerid, license_exam_cp[0], true);
		GiveCash(playerid, -CARLIC_PRICE);

		new bizid = LicenseOffice_Nearest(playerid);
		if (bizid != -1) GiveBizCash(bizid, CARLIC_PRICE);
	
		if (!IsPlayerInAnyVehicle(playerid)) {
			pTemp[playerid][pLicenseExam] = 0;
			DeletePVar(playerid, #exam_second);
			SendSyntaxMessage(playerid, "Ban da truot ky thi vi ban da roi khoi phuong tien.");
			TogglePlayerAllDynamicRaceCPs(playerid, false);
			RespawnVehicle(vehicle);
			return 1;
		}
	}
	else if (IsADMVHeli(vehicle))
	{
	    if (PlayerInfo[playerid][pFlyLic] != 0)	return SendErrorMessage(playerid, "Ban da co giay phep dieu khien phuong tien hang khong.");
		if (PlayerInfo[playerid][pFlyLic] == 2)	return SendErrorMessage(playerid, "Ban bi dua vao danh sach den voi tu cach la nguoi co bang phi cong.");
		if (GetCash(playerid) < FLYLIC_PRICE)	return SendNotCash(playerid);

		VehicleEngine(vehicle, true);
		SendSyntaxMessage(playerid, "Ban da bat dau ky thi lay giay phep khong luu.");
		SendSyntaxMessage(playerid, "[1]: Co gang khong va cham vao bat cu thu gi trong chuyen bay.");
		SendSyntaxMessage(playerid, "[2]: Lai ky thuat rat can than va mat thoi gian cua ban.");
		
		pTemp[playerid][pLicenseExam] = 2;
		SetPVarInt(playerid, #exam_second, EXAM_TIME);
		TogglePlayerDynamicRaceCP(playerid, fly_exam_cp[0], true);
		GiveCash(playerid, -FLYLIC_PRICE);
	}
	else if (IsADMVTaxi(vehicle))
	{
	    if (PlayerInfo[playerid][pCarLic] == 0)		return SendErrorMessage(playerid, "De co bang lai xe taxi, ban phai co bang lai xe.");
        if (PlayerInfo[playerid][pTaxiLic] != 0)	return SendErrorMessage(playerid, "Ban da co bang lai xe taxi.");
		if (PlayerInfo[playerid][pTaxiLic] == 2)	return SendErrorMessage(playerid, "Ban bi liet vao danh sach den voi tu cach la mot tai xe taxi.");
		if (GetCash(playerid) < TAXILIC_PRICE)		return SendNotCash(playerid);

		VehicleEngine(vehicle, true);
		SendSyntaxMessage(playerid, "Ban da bat dau ky thi lay bang lai xe taxi.");
		SendSyntaxMessage(playerid, "Ban co %i phut de hoan thanh, neu khong ban se truot ky thi.", EXAM_TIME / 60);

		pTemp[playerid][pLicenseExam] = 3;
		SetPVarInt(playerid, #exam_second, EXAM_TIME);
		TogglePlayerDynamicRaceCP(playerid, license_exam_cp[0], true);
		GiveCash(playerid, -TAXILIC_PRICE);

		new bizid = LicenseOffice_Nearest(playerid);

		if (bizid != -1)	GiveBizCash(bizid, TAXILIC_PRICE);
	}
	return 1;
}