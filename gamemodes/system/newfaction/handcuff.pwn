
stock FixLoi(playerid)
{
    if(HandCuff[playerid] != 0 || GetPVarInt(playerid, "Injured") == 1 || GetPVarInt(playerid, "IsFrozen") == 1 )
	{
   		//SendClientMessage(playerid, COLOR_GRAD2, " Ban khong the lam vao thoi diem nay.");
   		return 0;
	}
	return 1;
}