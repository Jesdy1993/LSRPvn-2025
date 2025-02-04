ALTX:garage("/g");
CMD:garage(playerid, params[])
{
	new id = GetNearGarage(playerid);

	if (id == -1)	return SendErrorMessage(playerid, "Ban nen o gan nha de xe.");

	new option[16], secoption[128];

	if (sscanf(params, "s[16]S()[128]", option, secoption))
	{
		SendHelpMessage(playerid, "(/g)arage [info / buy / sell / repairdoor]");
		return 1;
	}

	if (CompareStrings(option, "info"))
	{
		new dialog_header[64] = "{FFFFFF}Thong tin\t{FFFFFF}Gia tri\n", dialog_body[1024], temp[128];

		format(dialog_body, sizeof(dialog_body), "%s", dialog_header);

		format(temp, sizeof(temp), "ID\t%i\nGia\t%i\nGate\t%s\n", id, GarageInfo[id][garagePrice], (GarageInfo[id][garageLocked]) ? ("Dong") : ("Mo"));
		strcat(dialog_body, temp);

		if (GarageInfo[id][garageHouse])
		{
			format(temp, sizeof(temp), "Gan lien voi ngoi nha\t%i\n", GarageInfo[id][garageHouse]);
			strcat(dialog_body, temp);
		}

		if (GarageInfo[id][garageBiz])
		{
			format(temp, sizeof(temp), "Gan lien voi doanh nghiep\t%i\n", GarageInfo[id][garageBiz]);
			strcat(dialog_body, temp);
		}

		if (GarageInfo[id][garageOwner])
		{
			format(temp, sizeof(temp), "Chu so huu\t%s", GarageInfo[id][garageOwnerName]);
			strcat(dialog_body, temp);
		}

		Dialog_Show(playerid, None, DIALOG_STYLE_TABLIST_HEADERS, "{FFFFFF}Thong tin Nha de xe", dialog_body, "Dong", "");
		return 1;
	}

	else if (CompareStrings(option, "buy"))
	{
		if (GarageInfo[id][garageOwner])	return SendErrorMessage(playerid, "Nha de xe nay khong duoc ban.");
		if (GarageInfo[id][garageHouse])	return SendErrorMessage(playerid, "Nha de xe nay gan lien voi ngoi nha.");
		if (GarageInfo[id][garageBiz])		return SendErrorMessage(playerid, "Nha de xe nay gan lien voi doanh nghiep.");

		new count = 0;

		for(new i = 0; i < MAX_GARAGES; i++)
		{
			if (!GarageInfo[i][garageID] || GarageInfo[i][garageHouse] || GarageInfo[i][garageBiz] || PlayerInfo[playerid][pID] != GarageInfo[i][garageOwner]) continue;

			count++;
			break;
		}

		if (count)												return SendErrorMessage(playerid, "Ban khong the mua nhieu nha de xe.");
		if (GetCash(playerid) < GarageInfo[id][garagePrice])	return SendNotCash(playerid);

		new money = PlayerInfo[playerid][pCash];

		GiveCash(playerid, -GarageInfo[id][garagePrice]);
		SendSyntaxMessage(playerid, "Ban da mua mot Garage [ID: %i] voi gia $%i.", id, GarageInfo[id][garagePrice]);
		GarageInfo[id][garageOwner] = PlayerInfo[playerid][pID];
		format(GarageInfo[id][garageOwnerName], 24, "%s", GetNameEx(playerid));
		
		SQL_SetInteger("garage", "owner", GarageInfo[id][garageOwner], GarageInfo[id][garageID]);
		SQL_SetString("garage", "ownername", GarageInfo[id][garageOwnerName], GarageInfo[id][garageID]);

		new mes[256];
		format(mes, sizeof(mes), "%s [MYSQL: %i | IP: %s | Money (WAS): %s | Money (BECOME): %s] mua mot garage [G_MYSQL: %i] voi gia -- $%i", GetName(playerid), PlayerInfo[playerid][pID], q_GetPlayerIP(playerid), money, GetCash(playerid),
		GarageInfo[id][garageID], GarageInfo[id][garagePrice]);
		insert_log(mes, PROPERTY_LOG, 5, PlayerInfo[playerid][pAccID]);
		return 1;
	}

	else if (CompareStrings(option, "sell"))
	{
		if (GarageInfo[id][garageOwner] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Nha de xe nay khong thuoc ve ban.");
		if (GarageInfo[id][garageHouse])								return SendErrorMessage(playerid, "Nha de xe nay gan lien voi ngoi nha.");
		if (GarageInfo[id][garageBiz])									return SendErrorMessage(playerid, "Nha de xe nay gan lien voi doanh nghiep.");

		

		new money = PlayerInfo[playerid][pCash];
		
		GiveCash(playerid, GarageInfo[id][garagePrice]);
		SendSyntaxMessage(playerid, "Ban da ban nha de xe cua minh [ID: %i] voi gia $%i.", id, GarageInfo[id][garagePrice]);
		GarageInfo[id][garageOwner] = 0;
		GarageInfo[id][garageOwnerName][0] = EOS;
		SQL_SetInteger("garage", "owner", 0, GarageInfo[id][garageID]);
		SQL_SetString("garage", "ownername", "", GarageInfo[id][garageID]);

		new mes[256];
		format(mes, sizeof(mes), "%s [MYSQL: %i | IP: %s | Money (WAS): %i | Money (BECOME): %i] ban garage [G_MYSQL: %i] voi gia -- $%i", GetName(playerid), PlayerInfo[playerid][pID], q_GetPlayerIP(playerid), money, GetCash(playerid),
		GarageInfo[id][garageID], GarageInfo[id][garagePrice]);
		insert_log(mes, PROPERTY_LOG, 6, PlayerInfo[playerid][pAccID]);
	}

	else if (CompareStrings(option, "repairdoor"))
	{
		if (!GarageInfo[id][garageDDoor])	 return SendErrorMessage(playerid,"Cua truoc cua ban khong bi hong.");
		if (GetCash(playerid) < 300)		 return SendErrorMessage(playerid, "Gia sua cua la $300.");

		GarageInfo[id][garageDDoor] = 0;
		SQL_SetInteger("garage", "ddoor", GarageInfo[id][garageDDoor], GarageInfo[id][garageID]);
		UpdateGarageDoor(id);
		GiveCash(playerid, -300); //переделать под givecashex
		SendSyntaxMessage(playerid, "Ban da sua canh cua voi gia $300.");
		return 1;
	}
	return 1;
}