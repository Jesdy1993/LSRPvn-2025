CMD:paypark(playerid, params[]) //оплата парковки
{
	new id = -1, 
        vid = -1, 
        Float:x, Float:y, Float:z;
	
	if (IsPlayerInAnyVehicle(playerid))				 return SendErrorMessage(playerid, "Ban phai o ben ngoai chiec xe.");
	if ((id = ParkMeter_Nearest(playerid)) == -1)     return SendErrorMessage(playerid, "Khong co dong ho do xe gan ban. ");
    if (!pMeter[id][parkAvailable])                   return SendErrorMessage(playerid, "Da tra tien dau xe! "); 

    if (GetPlayerMoney(playerid) < CASH_PARKING)      return SendErrorMessage(playerid, "Ban khong co du tien. Ban can $%d de thay toan tien do xe.", CASH_PARKING);
		
    for(new i = 1; i < MAX_VEHICLES; i++)
    {
        if (IsValidVehicle(i) && (!IsAPlane(i) || !IsABiker(i) || !IsAHelicopter(i) || !IsABoat(i) || !IsABicycle(i)))
        {
            GetVehiclePos(i, x, y, z);
            if (IsPlayerInRangeOfPoint(playerid, 6.0, x, y, z))
            {
                vid = i;
                break;
            }
        }
    }

    if (vid == -1) return SendErrorMessage(playerid, "Khong co phuong tien phu hop gan day.");

    SendClientMessageEx(playerid, 0x33AA33FF, "> Ban da thanh toan tien cho viec dau xe cho %s voi gia $%d.", VehicleNames[GetVehicleModel(vid)-400], CASH_PARKING);
		
    GivePlayerMoney(playerid, -CASH_PARKING);

    pMeter[id][parkVehicle] = vid;
    pMeter[id][parkAvailable] = false;
		
	return 1;
}