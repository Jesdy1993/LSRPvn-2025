CMD:taxi(playerid, params[])
{
	new option[11], secoption, vehicle = GetPlayerVehicleID(playerid);

	if (PlayerInfo[playerid][pJob] != JOB_TAXI)	return SendErrorMessage(playerid, "Ban khong phai la tai xe taxi.");
	if (sscanf(params,"s[11]D(-1)", option, secoption))
	{
		SendHelpMessage(playerid, "/taxi [option]"); //доступные
		SendSyntaxMessage(playerid, "duty / fare / accept");
		return 1;
	}

	if (!IsDriver(playerid))	return SendErrorMessage(playerid, "Ban phai lai xe Taxi hoac xe Cabbie voi tu cach la nguoi lai xe.");
	if (!IsATaxi(vehicle))	return SendErrorMessage(playerid, "Ban phai di xe Taxi hoac xe Cabbie. ");

	if (CompareStrings(option, "duty"))
	{
		if (TaxiDuty[playerid])
		{
			SCM(playerid, COLOR_YELLOWG, "[TAXI] Ban da roi khoi nhiem vu va cac cuoc goi khong con kha dung cho ban. ");
			SendClientMessageEx(playerid, COLOR_YELLOWG, "[TAXI] Ban da duoc ghi co so tien $%i.", TaxiMade[playerid]);
			GiveCash(playerid, TaxiMade[playerid]);
			SetPlayerColor(playerid, TEAM_HIT_COLOR);
			TaxiDuty[playerid] = false;
			TaxiMade[playerid] = 0;
			TaxiMoney[playerid] = 0;
			TaxiPassenger[playerid] = INVALID_PLAYER_ID;
			return 1;
		}

		SendClientMessageEx(playerid, COLOR_YELLOWG, "[TAXI] Ban dang lam nhiem vu va co the nhan cuoc goi. Gia: $%i/5 giay.", TaxiFare[playerid]);
		SetPlayerColor(playerid, TAXI_DUTY);
		TaxiDuty[playerid] = true;
		TaxiMoney[playerid] = 0;
		TaxiMade[playerid] = 0;
		TaxiPassenger[playerid] = INVALID_PLAYER_ID;

		foreach(new i : Player)
		{
		    if (!IsPlayerLogged(i) || !IsPlayerInVehicle(i, vehicle) || GetPlayerState(i) != PLAYER_STATE_PASSENGER)	continue;

			TaxiPassenger[playerid] = i;
			SendClientMessageEx(i, COLOR_YELLOWG, "[TAXI] Ban da bat taxi den %s. Gia: $%i/5 giay.", GetNameEx(playerid), TaxiFare[playerid]);
			break;
		}

		return 1;
	}

	else if (CompareStrings(option, "fare"))
	{
		new fare;

		if (sscanf(params,"{s[11]}d",fare))			return SendHelpMessage(playerid, "/taxi fare [cost]");
		if (fare < 0 || fare > 25)					return SendErrorMessage(playerid, "Gia ve khong duoc duoi $0 va khong duoc nhieu hon$ 25.");
		if (IsPlayerLogged(TaxiPassenger[playerid]))	return SendErrorMessage(playerid, "Thuc day khach hang truoc khi thay doi Gia ve.");
		    
		SendClientMessageEx(playerid,COLOR_YELLOWG,"[TAXI] Ban da dat gia ve cho $%i/5 giay.", fare);
		TaxiFare[playerid] = fare;
	}

	else if (CompareStrings(option, "accept"))
	{
		new id, Float:x, Float:y, Float:z;

		if (sscanf(params,"{s[11]}u",id))	return SendHelpMessage(playerid, "/taxi accept [ID/Part Of Name]");
		if (!TaxiDuty[playerid])				return SendErrorMessage(playerid, "De chap nhan cuoc goi, ban can phai dam nhan nhiem vu(/taxi duty).");
		if (!IsPlayerLogged(id))				return SendNotConnected(playerid);
		if (GetPVarInt(id, "NeedTaxi") == 0)	return SendErrorMessage(playerid, "Nguoi choi nay da khong goi taxi, hoac ai do da nhan cuoc goi. ");

		SendSyntaxMessage(id, "%s da chap nhan cuoc goi cua ban. Gia: $%i/5 giay.", GetNameEx(playerid), TaxiFare[playerid]);
		SendSyntaxMessage(playerid, "Ban da chap nhan cuoc goi tu %s, ph.%i", GetNameEx(id), PlayerInfo[id][pNumber]);
		GetPlayerPos(id, x, y, z);
		Waypoint_Set(playerid, x, y, z, 3.0);
		DeletePVar(id, "NeedTaxi");
	}
	return 1;
}