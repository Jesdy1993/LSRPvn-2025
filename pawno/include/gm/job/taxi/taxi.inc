Taxi_OnPlayerStateChange(playerid, newstate)
{
    if (newstate == PLAYER_STATE_PASSENGER)
	{
	    new vehicle = GetPlayerVehicleID(playerid), driver = VehicleInfo[vehicle][carDriver];
        if (IsPlayerLogged(driver) && TaxiDuty[driver] && TaxiPassenger[driver] == INVALID_PLAYER_ID)
        {
            if (GetCash(playerid) < TaxiFare[driver])
			{
		 		SendErrorMessage(playerid, "Ban khong co du tien.");
		 		SendErrorMessage(driver, "Hanh khach khong co du tien.");
		 		return 1;
			}
			TaxiPassenger[driver] = playerid;
            SendClientMessageEx(playerid, COLOR_YELLOWG, "[TAXI]Ban da bat taxi den %s. Gia: $%i/5 giay.", GetNameEx(driver), TaxiFare[driver]);
		}
	}
    return 1;
}