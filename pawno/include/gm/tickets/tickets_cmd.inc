ALTX:tickets("/ticket");
CMD:tickets(playerid, params[])
{
	new query[255];
	mysql_format(dbHandle, query, sizeof(query), "SELECT * FROM `tickets` WHERE `userid`=%i AND `paid`=0 ORDER BY `id` DESC LIMIT %i", PlayerInfo[playerid][pID], MAX_TICKETS);
	mysql_tquery(dbHandle, query, "ShowPlayersTickets", "ii", playerid, 0);

	pTemp[playerid][pDialogList] = 0;

	return 1;
}

ALTX:vtickets("/vticket");
CMD:vtickets(playerid, params[])
{
	new vehicle = GetPlayerVehicleID(playerid);

	if (!IsValidVehicle(PlayerInfo[playerid][pCarKey]))					return SendErrorMessage(playerid, "Phuong tien cua ban khong duoc tao ra.");
	if (!vehicle)														return SendNotInVehicle(playerid);
	if (VehicleInfo[vehicle][carOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Ban khong phai la chu so huu cua chiec xe nay.");

	pTemp[playerid][pDialogList] = 0;	
	
	new query[255];
	mysql_format(dbHandle, query, sizeof(query), "SELECT * FROM `tickets` WHERE `vehicle`=%i AND `paid`=0 ORDER BY `id` DESC LIMIT %i", VehicleInfo[vehicle][carID], MAX_TICKETS);
	mysql_tquery(dbHandle, query, "ShowCarsTickets", "i", playerid);
	return 1;
}
//î