new ThueXePizza[MAX_PLAYERS] = INVALID_VEHICLE_ID;
CMD:takepizza(playerid, params[])
{
	if (PlayerInfo[playerid][pInjured] != 0 || GetPVarInt(playerid, "Freeze") || pTemp[playerid][pTaserTime] || pTemp[playerid][pCuffed] || PhoneInfo[playerid][current_page] == PAGE_NOTIFICATION || PlayerInfo[playerid][pJailed] != 0)
		return SendErrorMessage(playerid, "Ban khong the su dung tinh nang nay ngay bay gio.");

	if (!pTemp[playerid][pPizzaBoy])								return SendErrorMessage(playerid, "Ban khong hoan thanh don dat hang.");
    if (IsPlayerAttachedObjectSlotUsed(playerid, ATTACH_HANDS))		return SendWarningMessage(playerid, "Ban tay cua ban da duoc thuc hien.");
        
	new vehicle = GetPlayerVehicleID(playerid);

	if (vehicle != 0)																		return SendErrorMessage(playerid, "Ban phai o ben ngoai xe.");
    if ((vehicle = GetNearVehicle(playerid, 3.0)) == 0 || GetVehicleModel(vehicle) != 448)	return SendErrorMessage(playerid, "Ban nen o gan tiem banh pizza.");
    
    SetPlayerAttachedObject(playerid, ATTACH_HANDS, 19571, 6, -0.157999, -0.002000, -0.169000, -21.999990, 87.000022, 0.000000, 1.186000, 1.000000, 1.170000);
  	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
  	InfoMSG(playerid, "Nhan \" ~r~ENTER ~w~\" de tha pizza.", 5); //���������
	return 1;
}
CMD:veh(playerid,params[]) {
	if (!CheckAdmin(playerid, ADMIN_LEVEL_2)) return SendErrorMessage(playerid, "Ban khong the su dung lenh nay.");
	new vehid,Float:Pos[3];
	if (sscanf(params, "d", vehid))
	{
		SendHelpMessage(playerid, "/veh [ veh id]");
	}
	GetPlayerPos(playerid,Pos[0],Pos[1],Pos[2]);
	CreateVehicle(vehid, Pos[0], Pos[1], Pos[2], 0, -1, -1, -1);
	return 1;
}
CMD:destroycar(playerid,params[]) {
	if (!CheckAdmin(playerid, ADMIN_LEVEL_2)) return SendErrorMessage(playerid, "Ban khong the su dung lenh nay.");
	new vehid;
	if (sscanf(params, "d", vehid))
	{
		SendHelpMessage(playerid, "/veh [ veh id]");
	}
	DestroyVehicle(vehid);
	return 1;
}
pizza_OnPlayerDisconnect(playerid) {
	if(ThueXePizza[playerid] != INVALID_VEHICLE_ID ) {
		DestroyVehicle(ThueXePizza[playerid]);
	    ThueXePizza[playerid] = INVALID_VEHICLE_ID;
    }
}

CMD:thuexepizza(playerid,params[]) {
	if(!IsPlayerInRangeOfPoint(playerid, 5,  2098.5264,-1800.0336,13.3889)) return SendErrorMessage(playerid,"Ban khong o gan dia diem");
    if(ThueXePizza[playerid] != INVALID_VEHICLE_ID) return SendErrorMessage(playerid,"Ban da thue xe Pizza roi");
	if(PlayerInfo[playerid][pCash] < 100) return SendErrorMessage(playerid,"Ban khong co du $100");
	ThueXePizza[playerid] = CreateVehicle(448, 2098.1968,-1813.4401,12.9765,89.8073, 1, 0, -1);
	SendClientMessage(playerid, -1, "Ban da thue xe Pizza Thanh cong, ban dat coc $100 sau khi hoan thanh va tra xe ban se duoc hoan tien");
	PlayerInfo[playerid][pCash] -= 100;
	return 1;
}
CMD:traxepizza(playerid,params[]) {
	if(!IsPlayerInRangeOfPoint(playerid, 5,2098.5264,-1800.0336,13.3889)) return SendErrorMessage(playerid,"Ban khong o gan dia diem");
    if(ThueXePizza[playerid] == INVALID_VEHICLE_ID) return SendErrorMessage(playerid,"Ban chua thue xe Pizza");
	DestroyVehicle(ThueXePizza[playerid]);
	ThueXePizza[playerid] = INVALID_VEHICLE_ID;
	SendClientMessage(playerid, -1, "Ban da tra xe Pizza Thanh cong va nhan duoc $100 tien hoan tra");
	PlayerInfo[playerid][pCash] += 100;
	return 1;
}
Pizza_OnGameModeInt() {
	CreateDynamic3DTextLabel("/thuexepizza & /traxepizza", -1, 2098.5264,-1800.0336,13.3889, 30);
}
CMD:pizzajob(playerid, params[])
{
	if(LockPizza == true) return SendErrorMessage(playerid,"He thong nay dang bi khoa");
	/*if (pTemp[playerid][pPizzaBoy])
	{
	    pTemp[playerid][pPizzaBoy] = 0;
	    SendSyntaxMessage(playerid, "Ban da tu choi giao don dat hang cua minh. Don hang moi se co sau hai phut.");
	    DisableWaypoint(playerid);
	    SetPVarInt(playerid, #pizza_time, gettime() + 120);
	    return 1;
	}*/
	
	if (GetPVarInt(playerid, #pizza_time) > gettime())									return SendErrorMessage(playerid, "[Radio]: Khong co don dat hang, vui long lien he sau.");
	if (!IsDriver(playerid) || GetVehicleModel(GetPlayerVehicleID(playerid)) != 448)	return SendErrorMessage(playerid, "Ban phai lai xe pizzaboy. ");
		
	new i, houseid = random(MAX_HOUSES);
		
	while(i == 0)
	{
	    if (!HouseInfo[houseid][hID] || HouseInfo[houseid][hPosInt] || HouseInfo[houseid][hPosVW])
		{
			houseid = random(MAX_HOUSES);
		}
		else
		{
		    i = 1;
		    pTemp[playerid][pPizzaBoy] = houseid+1;
		    SendClientMessageEx(playerid, COLOR_GREEN, "[PIZZA]: Don hang moi. Mang pizza den dia chi: %s", (!HouseInfo[houseid][hApart])?(GetHouseZone(houseid)):(GetApartmentZone(HouseInfo[houseid][hApart])));
            SendHelpMessage(playerid, "Su dung /takepizza - de lay pizza.");

			if (!HouseInfo[houseid][hApart]) 
				Waypoint_Set(playerid, HouseInfo[houseid][hPosX], HouseInfo[houseid][hPosY], HouseInfo[houseid][hPosZ]);
			else 
				Waypoint_Set(playerid, ApartInfo[houseid][aPosX], ApartInfo[houseid][aPosY], ApartInfo[houseid][aPosZ]);

		    return 1;
		}
	}
	return 1;
}
