/*Vehicle_OnPlayerEnterDynamicCP(playerid, checkpointid)
{
	if (checkpointid == pTemp[playerid][JackingCP])
	{
		if (!IsPlayerInAnyVehicle(playerid)) 							  return InfoMSG(playerid, "�� ������ ���� � ~r~�������� ~w~����������!", 3);
		if (GetPlayerVehicleID(playerid) != pTemp[playerid][JackingVehID]) return InfoMSG(playerid, "�� �� ~r~������� ~w~ ���� ���������!", 3);
		if (IsPoliceNear(playerid)){
			InfoMSG(playerid, "�� ���� ��� ~y~�����~w~! ������� �� ������ ~r~��������", 3);

			DisableWaypoint(playerid);
			if (IsValidDynamicCP(pTemp[playerid][JackingCP])) DestroyDynamicCP(pTemp[playerid][JackingCP]);
			pTemp[playerid][JackingCP] = 0;

			new randomCP = random(sizeof(Jacking_CP));
			pTemp[playerid][JackingCP] = CreateDynamicCP(Jacking_CP[randomCP][0], Jacking_CP[randomCP][1], Jacking_CP[randomCP][2], 1.5, 0, 0, playerid, 15000.0);
			TogglePlayerDynamicCP(playerid, pTemp[playerid][JackingCP], true);
    		Streamer_Update(playerid, STREAMER_TYPE_CP);

			return 1;
		}

		new vehid = pTemp[playerid][JackingVehID],
			model = GetVehicleModel(vehid),
			price = floatround(GetVehiclePrice(model)*0.1);

		VehicleInfo[vehid][carDestroyed]++;

		SQL_SetInteger("cars", "jacking", 1, VehicleInfo[vehid][carID]);
		SQL_SetInteger("cars", "destroys", VehicleInfo[vehid][carDestroyed], VehicleInfo[vehid][carID]);
		
		new userid;
		foreach(new i : Player) {
			if (PlayerInfo[i][pID] == VehicleInfo[vehid][carOwnerID]) {
				userid = i; 
				break;
			}
		}

		SendClientMessageEx(userid, COLOR_LIGHTRED, "[ ��������� ] ��� %s ��� �����. (/mycars)", VehicleNames[GetVehicleModel(vehid)-400]);

		InfoMSG(playerid, "�� ~g~������� ~w~����� ���������", 3);
		GiveCash(playerid, price);
		RemovePlayerFromVehicle(playerid);

		ResetVehicleStuff(vehid);
		DestroyVehicle(vehid);

		if (IsValidDynamicCP(pTemp[playerid][JackingCP])) DestroyDynamicCP(pTemp[playerid][JackingCP]);
		pTemp[playerid][JackingCP] = 0;
		pTemp[playerid][JackingVehID] = 0;
		SetPVarInt(playerid, #JACKING_PROCESS, 0);
	}
	return 1;
}*/

Veh_OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
    new Float:oldX, Float:oldY, Float:oldZ,
	Float:oldRotX, Float:oldRotY, Float:oldRotZ;

    GetDynamicObjectPos(objectid, oldX, oldY, oldZ);
	GetDynamicObjectRot(objectid, oldRotX, oldRotY, oldRotZ);

    if (GetPVarInt(playerid, #veh_editor) != 0 && (response == EDIT_RESPONSE_FINAL || response == EDIT_RESPONSE_CANCEL))
	{
	    new vehicle = GetPVarInt(playerid, #veh_editor), slot = GetPVarInt(playerid, #veh_slot), attobj = GetPVarInt(playerid, #veh_obj);

		DeletePVar(playerid, #veh_editor);
		DeletePVar(playerid, #veh_slot);
		DeletePVar(playerid, #veh_obj);

		new Float:ofx, Float:ofy, Float:ofz, Float:ofaz, Float:finalx, Float:finaly, Float:px, Float:py, Float:pz, Float:roz;
			
		GetVehiclePos(vehicle, px, py, pz);
		GetVehicleZAngle(vehicle, roz);
			
		ofx = x-px, ofy = y-py, ofz = z-pz, ofaz = rz-roz;
		finalx = ofx*floatcos(roz, degrees)+ofy*floatsin(roz, degrees);
		finaly = -ofx*floatsin(roz, degrees)+ofy*floatcos(roz, degrees);
		AttachDynamicObjectToVehicle(objectid, vehicle, finalx, finaly, ofz, rx, ry, ofaz);
		VehicleInfo[vehicle][carAttachObj][slot] = attobj;
		VehicleInfo[vehicle][carAttachPosX][slot] = finalx;
		VehicleInfo[vehicle][carAttachPosY][slot] = finaly;
		VehicleInfo[vehicle][carAttachPosZ][slot] = ofz;
		VehicleInfo[vehicle][carAttachRotX][slot] = rx;
		VehicleInfo[vehicle][carAttachRotY][slot] = ry;
		VehicleInfo[vehicle][carAttachRotZ][slot] = ofaz;

	    if (!GetPVarInt(playerid, "Vehicle:AttEdit")) 
		{
			GiveCash(playerid, -250);
			InfoMSG(playerid, "~w~Ban da dinh kem ~y~doi tuong~w~ voi gia ~g~$250~w~,~n~~y~~w~/attmenu - de quan ly dinh kem tren phuong tien.", 5);
		}
		else InfoMSG(playerid, "~w~Ban da thay doi thanh cong vi tri ~y~doi tuong~w~!", 5);

		Save_CarAttach(vehicle, slot);
	}
	return 1;
}
 
this::Cars_OnGameModeInit()
{
	return mysql_tquery(dbHandle, "SELECT * FROM cars WHERE owner = 0", "LoadDynamicCars", "");
}


Vehicle_OnPlayerStateChange(playerid, newstate, oldstate)
{
	if (newstate == PLAYER_STATE_DRIVER)
	{
		new vehicle = GetPlayerVehicleID(playerid), Float: vhealth;
 		
		AntiCheatGetVehicleHealth(vehicle, vhealth);

		if (!GetPlayerHasRightDrive(playerid, vehicle))  return 1;
	    if (IsABicycle(vehicle)) 						VehicleEngine(vehicle, true);
		
	    VehicleInfo[vehicle][carDriver] = playerid;
	    pTemp[playerid][pDriver] = vehicle;

		if (IsRentCar(vehicle) && VehicleInfo[vehicle][carRent] == 0)
		{
		    SendSyntaxMessage(playerid, "Phuong tien nay duoc thue voi gia $300.");
		    SendHelpMessage(playerid, "Nhap /rentcar de thue phuong tien.");
		}
		if(InfoSkate[playerid][sActive] == true)
		{
			SendErrorMessage(playerid, "Ban khong the lai xe khi dang co van truot.");
			RemovePlayerFromVehicle(playerid);
		}
		if(IsPizzaCar(vehicle) && PlayerInfo[playerid][pSideJob] == JOB_PIZZA || IsTaxiCar(vehicle) && PlayerInfo[playerid][pJob] == JOB_TAXI || IsMinerCar(vehicle) && PlayerInfo[playerid][pJob] == JOB_MINER || IsTrashMasterCar(vehicle) && PlayerInfo[playerid][pJob] == JOB_TRASHMASTER || IsLamberJackCar(vehicle) && PlayerInfo[playerid][pJob] == JOB_LAMBERJACKER || IsTruckCar(vehicle) && PlayerInfo[playerid][pJob] == JOB_TRUCKER && GetAvailableTruck(playerid, GetVehicleModel(vehicle)))
		{
			SendSyntaxMessage(playerid, "Ban da len mot chiec xe lam viec.");
		    SendHelpMessage(playerid, "Nhap /rentcarjob(/rcj), de dieu khien phuong tien nay. ");
		}
		
		if (VehicleInfo[vehicle][carOwnerID] == PlayerInfo[playerid][pID]) 
			SM2(playerid, "Chao mung tro lai %s cua ban.",  VehicleNames[GetVehicleModel(vehicle) - 400]);
		
		if (!VehicleInfo[vehicle][carEngineOn] && !IsADMVCar(vehicle) && !IsADMVTaxi(vehicle) && !IsADMVHeli(vehicle) && !IsABicycle(vehicle))
			SCM(playerid, COLOR_GREEN,"-> Phuong tien chua khoi dong - Nhan '2' hoac nhap /(en)gine.");

		if (pTemp[playerid][pCallLine] != INVALID_PLAYER_ID || pTemp[playerid][pEmergency])
			SetPlayerCellphoneAction(playerid, 1);

		TextDrawShowForPlayer(playerid, TD_vehicle_info[0]);
     	TextDrawShowForPlayer(playerid, TD_vehicle_info[1]);
	    PlayerTextDrawSetString(playerid, TD_vehicle_name[playerid], VehicleNames[GetVehicleModel(vehicle)-400]);
		PlayerTextDrawShow(playerid, TD_vehicle_name[playerid]);
		SetPVarInt(playerid, #vehicle_info, 5);
	}

	if (oldstate == PLAYER_STATE_DRIVER)
	{
     	new veh = pTemp[playerid][pDriver];
     	
		pTemp[playerid][pDriver] = INVALID_VEHICLE_ID;

		if (veh != INVALID_VEHICLE_ID && VehicleInfo[veh][carDriver] == playerid)	VehicleInfo[veh][carDriver] = INVALID_PLAYER_ID;
		if (JackingEngine[playerid]) 												StopJackingEngine(playerid);
		if (GetPVarInt(playerid, #UsePump))											Fuel_ResetPlayer(playerid);
	}
	return 1;
}

Vehicle_OnPlayerExitVehicle(playerid, vehicleid)
{
	if (JackingEngine[playerid]) 			StopJackingEngine(playerid);
	if (PlayerInfo[playerid][InMission])	LeaveMission(playerid);
	if (IsPlayerUseMDC(playerid))			MDC_Hide(playerid);
	if (VehicleInfo[vehicleid][carRadioOn])	StopAudioStreamForPlayer(playerid);

	return 1;
}

V_OnVehicleDamageStatusUpdate(vehicleid)
{
	new panels, doorsd, lightsf, tires;

	GetVehicleDamageStatus(vehicleid, panels, doorsd, lightsf, tires);

	if (!VehicleInfo[vehicleid][carOwnerID]) return 1;

	if (!panels && !doorsd && !lightsf && !tires) return 1;

	new Float:health;

	AntiCheatGetVehicleHealth(vehicleid, health);

	if (health > 750.0)	UpdateVehicleDamageStatus(vehicleid, 0, 0, 0, 0);
	
	if (health < 350.0)
	{
	   	if (VehicleInfo[vehicleid][carEngine] > 0.0)	VehicleInfo[vehicleid][carEngine] -= 1.0;
		if (VehicleInfo[vehicleid][carEngine] < 0.0)
		{
	    	if (VehicleInfo[vehicleid][carEngineOn])	VehicleEngine(vehicleid, false);
			
			VehicleInfo[vehicleid][carEngine] = 0.0;
		}
	}
	return 1;
}