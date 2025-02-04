Job_OnGameModeInit()
{
    mysql_tquery(dbHandle, "SELECT * FROM `jobs` ORDER BY `jobid`", "LoadDynamicJobs");
	mysql_tquery(dbHandle, "SELECT * FROM `trashes` ORDER BY `id`", "LoadDynamicTrashes");
	mysql_tquery(dbHandle, "SELECT * FROM `factories` ORDER BY `id`", "LoadDynamicFactories");
	mysql_tquery(dbHandle, "SELECT * FROM `buyers`", "LoadBuyers");
	mysql_tquery(dbHandle, "SELECT * FROM `trees`", "LoadTrees");
	return 1;
}

Job_OnPlayerDisconnect(playerid)
{
 	RefillPrice[playerid] = 0;
 	RefillOffer[playerid] = INVALID_PLAYER_ID;
	RepairOffer[playerid] = INVALID_PLAYER_ID;
	RepairToVehicle[playerid] = INVALID_VEHICLE_ID;
	RepairTowTruck[playerid] = INVALID_VEHICLE_ID;
	RepairTime[playerid] = 0;
    RepairService[playerid] = 0;

	TaxiDuty[playerid] = false;
	TaxiFare[playerid] = 0;
	TaxiMoney[playerid] = 0;
	TaxiMade[playerid] = 0;
	TaxiPassenger[playerid] = INVALID_PLAYER_ID;
    return 1;
}

Job_SecondTimer(playerid)
{
    if (GetPVarInt(playerid, #hide_job_message) && GetPVarInt(playerid, #hide_job_message) < gettime())
	{
		PlayerTextDrawHide(playerid, TD_job_message[playerid]);
		DeletePVar(playerid, #hide_job_message);
	}
    return 1;
}