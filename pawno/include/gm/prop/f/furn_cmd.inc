CMD:furniture(playerid, params[])
{
    if (GetPVarInt(playerid, "buy_furniture"))	return SendErrorMessage (playerid, "Hanh dong da duoc tien hang.");
        
	new type = GetNearBuilding(playerid);
	if (type == -1) return SendErrorMessage(playerid, "Ban nen o ben trong / ben canh tai san cua ban."); //ошибка

	switch(type)
	{
		case 0: HouseFurn(playerid);
		case 1: BizFurn(playerid);
		case 2: GarageFurn(playerid);
	}

	Check3DMenu(playerid);
	return 1;
}