CMD:delivercar(playerid, params[])
{
	if (IsPoliceNear(playerid))	return InfoMSG(playerid, "O day co ~p~~b~canh sat ~w~gan day!", 4);
	if (!PoliceOnline())		return SendErrorMessage(playerid, "Phai co it nhat %i canh sat trong tro choi. ", NEED_COPS_TO_CRIME);

	new
		id = GetChopshopID(playerid),
		vehID = GetPlayerVehicleID(playerid)
	;
	
	if (PlayerInfo[playerid][pJob] != JOB_CARJACKER) return SendErrorMessage(playerid, "Ban khong phai la mot ten trom xe hoi.");
	if (id == -1 || !IsPlayerInAnyVehicle(playerid)) return SendErrorMessage(playerid, "Khong co xuong nao gan ban, hoac ban khong lai xe.");
	
	if (VehicleInfo[vehID][carOwnerID] == PlayerInfo[playerid][pID] || PlayerInfo[playerid][pSpareKey] == VehicleInfo[vehID][carOwnerID])
		return SendErrorMessage(playerid, "Ban khong the tao ra chiec xe cua minh.");

	if (VehicleInfo[vehID][carOwnerID] == 0) 			return SendErrorMessage(playerid, "Chi phuong tien ca nhan moi co the bi hack.");
	if (PlayerInfo[playerid][InMission]) 				return SendErrorMessage(playerid,"Ban da lam mot nhiem vu.");
	if (!CheckWantedModel(id, GetVehicleModel(vehID))) 	return SendErrorMessage(playerid, "Phuong tien nay khong can thiet.");
	
	new count, time[64];
	for(new i; i < 14; i++) if (VehicleInfo[vehID][carComponent][i] > 0) count++;

	if (VehicleInfo[vehID][carEngineOn]) ToggleVehicleEngine(vehID, playerid);

	PlayerInfo[playerid][InMission] = CARJACKER_DELIVER;
	PlayerInfo[playerid][MissionTime] = 15 + count;
	PlayerInfo[playerid][MissionTarget][0] = vehID;
	PlayerInfo[playerid][MissionTarget][1] = id;
			
	format(time, sizeof(time), "~r~PHAN BIET CAC BO PHAN PHU TUNG CUA XE~n~~w~CON LAI ~y~%d ~w~GIAY", PlayerInfo[playerid][MissionTime]);
	InfoMSG(playerid, time, 2);
	
	return 1;
}

CMD:leavemission(playerid, params[])
{
	if (!PlayerInfo[playerid][InMission]) return SendErrorMessage(playerid, "Ban khong co trong mot nhiem vu. ");
	LeaveMission(playerid);
	return 1;
}

CMD:dropoff(playerid, params[])
{
	if (IsPoliceNear(playerid))	return InfoMSG(playerid, "O day co ~p~~b~canh sat ~w~gan day!", 4);
	
	new vehID = PlayerInfo[playerid][MissionTarget][0],
		id = PlayerInfo[playerid][MissionTarget][1],
		Float: playerPos[3];

	GetPlayerPos(playerid, playerPos[0], playerPos[1], playerPos[2]);

	if (PlayerInfo[playerid][pJob] != JOB_CARJACKER) return SendErrorMessage(playerid, "Ban khong phai la mot ten trom xe hoi.");
	if (!PlayerInfo[playerid][InMission]) 			return SendErrorMessage(playerid, "Ban khong co trong mot nhiem vu.");

	if (PlayerInfo[playerid][InMission] != CARJACKER_DROPOFF) 				   return SendErrorMessage(playerid, "Ban dang khong trom xe.");
	if (GetPlayerVehicleID(playerid) != PlayerInfo[playerid][MissionTarget][0]) return SendErrorMessage(playerid, "Day khong phai la phuong tien phu hop!");

	if (!IsPlayerInRangeOfPoint(playerid, 50.0, chopshop_data[id][chopshop_pos][0], chopshop_data[id][chopshop_pos][1], chopshop_data[id][chopshop_pos][2]))
	{
	    new Float: distance_reward = XB_GetDistanceBetweenTPoints(playerPos[0], playerPos[1], playerPos[2], chopshop_data[id][chopshop_pos][0], chopshop_data[id][chopshop_pos][1], chopshop_data[id][chopshop_pos][2]);

	    if (distance_reward > 200.0) PlayerInfo[playerid][MissionReward] += 400;
	    else 						PlayerInfo[playerid][MissionReward] += floatround(distance_reward) * 2;
	    
	    new money[32];
	    format(money, 32, "~g~MISSION COMPLETED~n~~w~BAN DA NHAN DUOC ~y~$%s", FormatNumber(PlayerInfo[playerid][MissionReward]));
		InfoMSG(playerid, money, 5);

		GiveCash(playerid, PlayerInfo[playerid][MissionReward]);
			
		//GetPlayerPos(playerid, VehicleInfo[vehID][eVehicleStolenPos][0], VehicleInfo[vehID][eVehicleStolenPos][1], VehicleInfo[vehID][eVehicleStolenPos][2]);
		//VehicleInfo[vehID][eVehicleStolen] = true;
		
		new userid;
		foreach(new i : Player) {
			if (PlayerInfo[i][pID] == VehicleInfo[vehID][carOwnerID]) {
				userid = i; 
				break;
			}
		}

		SendClientMessageEx(userid, COLOR_LIGHTRED, "[ VEHICLE ] Ban %s da bi trom. (/mycars)", VehicleNames[GetVehicleModel(vehID)-400]);

		VehicleInfo[vehID][carDestroyed]++;

		SQL_SetInteger("cars", "jacking", 1, VehicleInfo[vehID][carID]);
		SQL_SetInteger("cars", "destroys", VehicleInfo[vehID][carDestroyed], VehicleInfo[vehID][carID]);

		new money_str[70];
		format(money_str, sizeof(money_str), "BAN ~g~DA HOAN THANH ~w~NHAN XE~n~VA NHAN DUOC ~g~$%i", PlayerInfo[playerid][MissionReward]);
		InfoMSG(playerid, money_str, 5);
		RemovePlayerFromVehicle(playerid);

		ResetVehicleStuff(vehID);
		DestroyVehicle(vehID);

		PlayerInfo[playerid][MissionReward] = 0;
		PlayerInfo[playerid][InMission] = MISSION_NONE;
		PlayerInfo[playerid][MissionTime] = 0;
		PlayerInfo[playerid][MissionTarget][0] = 0;
		PlayerInfo[playerid][MissionTarget][1] = 0;
	}
	else return SendErrorMessage(playerid, "Ban o qua gan xuong!"); //������

	return 1;
}
