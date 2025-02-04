SendTaxiRequest(playerid, location[])
{
    foreach(new i : Player)
	{
	    if (!IsPlayerLogged(i) || !TaxiDuty[i] || PlayerInfo[i][pJob] != JOB_TAXI) continue;

        SendClientMessage(i, COLOR_GREEN, "|___________TAXI CALL___________|");
		if (pTemp[playerid][pPayphone] == -1) 
			SendClientMessageEx(i, COLOR_WHITE, "Cuoc goi tu: %s Ph: %i", GetNameEx(playerid), PlayerInfo[playerid][pNumber]);
		else
			SendClientMessageEx(i, COLOR_WHITE, "Cuoc goi tu: Dien thoai cong cong, Ph: %i", PayphoneInfo[pTemp[playerid][pPayphone]][phNumber]);
		SendClientMessageEx(i, COLOR_WHITE, "Vi tri: %s", location);
		SendClientMessageEx(i, COLOR_WHITE, "*/taxi accept %i de chap nhan cuoc goi **", playerid);
	}
	return 1;
}

Taxi_OnGameModeInit()
{
    return SetTimer("Taxi_FiveSecTimer", 5000, false);
}