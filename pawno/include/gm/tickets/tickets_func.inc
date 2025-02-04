this::ShowCarsTickets(playerid, back)
{
	new 
		fetch[128], 
		string[600]
	;

    if (cache_num_rows())
    {
		format(string, sizeof(string), "#\tGia\tMo ta\tNgay");
		if (pTemp[playerid][pDialogList]) format(string, sizeof(string), "%s\n{bccd32}<<{FFFFFF}", string);

		if (!back)
		{
			for(new i = 0; i < cache_num_rows(); i++)
			{
				new 
					amount,
					reason[12]
				;

				amount = cache_get_field_content_int(i, "amount");

				cache_get_field_content(i, "reason", fetch);
				format(reason, sizeof(reason), fetch);

				Tickets[playerid][i][tID] = cache_get_field_content_int(i, "id");
				cache_get_field_content(i, "date", fetch);
				format(string, sizeof(string), "%s\n%i\t$%d\t%.50s...\t%s", string, i+1+pTemp[playerid][pDialogList]*MAX_TICKETS, amount, reason, fetch);
			}
		} else {
			for(new i = cache_num_rows()-1; i >= 0; i--)
			{
				new 
					amount,
					reason[12]
				;

				amount = cache_get_field_content_int(i, "amount");
	
				cache_get_field_content(i, "reason", fetch);
				format(reason, sizeof(reason), fetch);

				Tickets[playerid][cache_num_rows()-1-i][tID] = cache_get_field_content_int(i, "id");
				cache_get_field_content(i, "date", fetch);
				format(string, sizeof(string), "%s\n%i\t$%d\t%.50s...\t%s", string, cache_num_rows()-i+pTemp[playerid][pDialogList]*MAX_TICKETS, amount, reason, fetch);
			}
		}
		
		if (CountVehicleIDTickets(cache_get_field_content_int(0, "vehicle")) > MAX_TICKETS*(pTemp[playerid][pDialogList]+1)) format(string, sizeof(string), "%s\n{bccd32}>>", string);
    }
    else return SendWarningMessage(playerid, "Phuong tien nay khong co tien phat chua thanh toan.");

	return Dialog_Show(playerid, VehicleFines, DIALOG_STYLE_TABLIST_HEADERS, "{FFFFFF} Danh sach cac khoan phat chua thanh toan", string, "Lua chon", "Huy");
}

this::ShowCarTicket(playerid)
{
	new 
		fetch[128], 
		mes[256],
		vehicleid = GetPlayerVehicleID(playerid)
	;
    if (!cache_num_rows())	return 1;
	
	Ticket[playerid][tID] = cache_get_field_content_int(0, "id");
	
	format(mes, sizeof(mes), "{a9c4e4}Issuer:\t\t {ffffff}%s\n", VehicleNames[GetVehicleModel(vehicleid)-400]); 

	cache_get_field_content(0, "officer", fetch);
	format(mes, sizeof(mes), "%s{a9c4e4}Officer:\t\t {ffffff}%s ", mes, fetch);

	cache_get_field_content(0, "faction", fetch);
	format(mes, sizeof(mes), "%s[%s]\n", mes, GetInitials(Factions[strval(fetch)][fName]));

	Ticket[playerid][tAmount] = cache_get_field_content_int(0, "amount");
	format(mes, sizeof(mes), "%s{a9c4e4}Price:\t\t\t {ffffff}$%i{a9c4e4}\n", mes, Ticket[playerid][tAmount]);

	cache_get_field_content(0, "date", fetch);
	format(mes, sizeof(mes), "%s{a9c4e4}Date:\t\t\t {ffffff}%s\n\n", mes, fetch);

	cache_get_field_content(0, "reason", fetch);
	format(Ticket[playerid][tReason], 128, "%s", fetch);
	format(mes, sizeof(mes), "%s{a9c4e4}Description:{ffffff}\n%s", mes, Ticket[playerid][tReason]);

	if (IsPlayerFactionPolice(playerid) && PlayerInfo[playerid][pOnDuty] && GetPVarInt(playerid, #ticketsuse))
		Dialog_Show(playerid, None, DIALOG_STYLE_MSGBOX, "{F5DEB3}Chi tiet ve tien phat", mes, "Huy", "");
	else Dialog_Show(playerid, VehicleFinesTake, DIALOG_STYLE_MSGBOX, "{F5DEB3}Chi tiet ve tien phat", mes, "Pick up", "Quay lai");

	return 1;
}

this::ShowPlayersTickets(playerid, back)
{
	new 
		fetch[128], 
		string[600]
	;

    if (cache_num_rows())
    {
		format(string, sizeof(string), "#\tGia\tMo ta\tNgay");
		if (pTemp[playerid][pDialogList]) format(string, sizeof(string), "%s\n{bccd32}<<{FFFFFF}", string);

		if (!back)
		{
			for(new i = 0; i < cache_num_rows(); i++)
			{
				new 
					amount,
					reason[12]
				;

				amount = cache_get_field_content_int(i, "amount");

				cache_get_field_content(i, "reason", fetch);
				format(reason, sizeof(reason), fetch);

				Tickets[playerid][i][tID] = cache_get_field_content_int(i, "id");

				cache_get_field_content(i, "date", fetch);
				format(string, sizeof(string), "%s\n%i\t$%d\t%.50s...\t%s", string, i+1+pTemp[playerid][pDialogList]*MAX_TICKETS, amount, reason, fetch);
			}
		}
		else
		{
			for(new i = cache_num_rows()-1; i >= 0; i--)
			{
				new 
					amount,
					reason[12]
				;

				amount = cache_get_field_content_int(i, "amount");

				cache_get_field_content(i, "reason", fetch);
				format(reason, sizeof(reason), fetch);

				Tickets[playerid][cache_num_rows()-1-i][tID] = cache_get_field_content_int(i, "id");

				cache_get_field_content(i, "date", fetch);
				format(string, sizeof(string), "%s\n%i\t$%d\t%.50s...\t%s", string, cache_num_rows()-i+pTemp[playerid][pDialogList]*MAX_TICKETS, amount, reason, fetch);
			}
		}
		
		if (CountPlayerTickets(playerid) > MAX_TICKETS*(pTemp[playerid][pDialogList]+1)) format(string, sizeof(string), "%s\n{bccd32}>>", string);
    }
    else return SendWarningMessage(playerid, "Khong co tien phat chua thanh toan!");

	Dialog_Show(playerid, ShowPlayerFinesShow, DIALOG_STYLE_TABLIST_HEADERS, "{FFFFFF}Danh sach cac khoan tien phat chua thanh toan", string, "Lua chon", "Huy");
	return 1;
}


this::ShowPlayerTicket(playerid)
{
	new fetch[128], 
		mes[256],
		ownername[MAX_PLAYER_NAME]
	;

    if (!cache_num_rows())	return 1;
	
	Ticket[playerid][tID] = cache_get_field_content_int(0, "id");

	cache_get_field_content(0, "name", ownername);
	strreplace(fetch, '_', ' ');
	format(mes, sizeof(mes), "{a9c4e4}Issuer:\t\t {ffffff}%s\n", ownername);

	cache_get_field_content(0, "officer", fetch);
	format(mes, sizeof(mes), "%s{a9c4e4}Officer:\t\t {ffffff}%s ", mes, fetch);

	cache_get_field_content(0, "faction", fetch);
	format(mes, sizeof(mes), "%s[%s]\n", mes, GetInitials(Factions[strval(fetch)][fName]));

	Ticket[playerid][tAmount] = cache_get_field_content_int(0, "amount");
	format(mes, sizeof(mes), "%s{a9c4e4}Price:\t\t\t {ffffff}$%i\n", mes, Ticket[playerid][tAmount]);

	cache_get_field_content(0, "date", fetch);
	format(mes, sizeof(mes), "%s{a9c4e4}Date:\t\t\t {ffffff}%s\n\n", mes, fetch);

	cache_get_field_content(0, "reason", fetch);
	format(Ticket[playerid][tReason], 128, fetch);
	format(mes, sizeof(mes), "%s{a9c4e4}Description:{ffffff}\n%s", mes, fetch);

	if (IsPlayerFactionPolice(playerid) && PlayerInfo[playerid][pOnDuty] && GetPVarInt(playerid, #ticketsuse))
		Dialog_Show(playerid, None, DIALOG_STYLE_MSGBOX, "{F5DEB3}Chi tiet ve tien phat", mes, "Huy", "");
	else Dialog_Show(playerid, PlayerFinesPay, DIALOG_STYLE_MSGBOX, "{F5DEB3}Chi tiet ve tien phat", mes, "Pay", "Quay lai");

	return 1;
}

GivePlayerTicket(officerid, playerid, amount, reason[], iscam = 0)
{  
    new query[96 + 11 + MAX_PLAYER_NAME + 1 + 64 + 24 + 1];

	if (!iscam)
	{
    	mysql_format(dbHandle, query, sizeof(query), "INSERT INTO `tickets` (userid, officer, faction, amount, reason, date) VALUES (%i, '%e', %i, %i, '%e', '%s')", PlayerInfo[playerid][pID], GetNameEx(officerid), PlayerInfo[officerid][pFaction], amount, reason, GetFullDate());
	}
	else
	{
		mysql_format(dbHandle, query, sizeof(query), "INSERT INTO `tickets` (userid, officer, faction, amount, reason, date) VALUES (%i, 'Speed Camera', 3, %i, '%e', '%s')", playerid, amount, reason, GetFullDate());
	}
    
	mysql_tquery(dbHandle, query);
	return 1;
}

GiveVehicleTicket(officerid, vehicle, amount, reason[], iscam = 0)
{
    new query[97 + 11 + MAX_PLAYER_NAME + 1 + 64 + 24 + 1];

	if (!iscam)
	{
    	mysql_format(dbHandle, query, sizeof(query), "INSERT INTO `tickets` (vehicle, officer, faction, amount, reason, date) VALUES (%i, '%e', %i, %i, '%e', '%s')", VehicleInfo[vehicle][carID], GetNameEx(officerid), PlayerInfo[officerid][pFaction], amount, reason, GetFullDate());
	}
	else
	{
		mysql_format(dbHandle, query, sizeof(query), "INSERT INTO `tickets` (vehicle, officer, faction, amount, reason, date) VALUES (%i, 'Speed Camera', 3, %i, '%e', '%s')", VehicleInfo[vehicle][carID], amount, reason, GetFullDate());
	}
	mysql_tquery(dbHandle, query);
	return 1;
}//î

DeleteVehicleTickets(vehicle)
{
	new query[128];
  	mysql_format(dbHandle, query, sizeof(query), "DELETE FROM `tickets` WHERE `vehicle`=%i", VehicleInfo[vehicle][carID]);
	mysql_tquery(dbHandle, query);
	return 1;
}

DeletePlayerTickets(playerid)
{
	new query[128];
  	mysql_format(dbHandle, query, sizeof(query), "DELETE FROM `tickets` WHERE `userid`=%i", PlayerInfo[playerid][pID]);
	mysql_tquery(dbHandle, query);
	return 1;
}

CountPlayerTickets(playerid)
{
	new 
		query[128]
	;

 	mysql_format(dbHandle, query, sizeof(query), "SELECT COUNT(id) AS total FROM `tickets` WHERE `userid` = %i AND `paid` = 0", PlayerInfo[playerid][pID]);
	new Cache:cache = mysql_query(dbHandle, query),
		count = cache_get_field_content_int(0, "total");

	cache_delete(cache);
	return count;
}


CountPlayerTicketsID(userid)
{
	new 
		query[128]
	;

 	mysql_format(dbHandle, query, sizeof(query), "SELECT COUNT(id) AS total FROM `tickets` WHERE `userid` = %i AND `paid` = 0", userid);
	new Cache:cache = mysql_query(dbHandle, query),
		count = cache_get_field_content_int(0, "total");

	cache_delete(cache);
	return count;
}

CountVehicleTickets(vehicle)
{
	new 
		query[128]
	;

 	mysql_format(dbHandle, query, sizeof(query), "SELECT COUNT(id) AS total FROM `tickets` WHERE `vehicle` = %i AND `paid` = 0", VehicleInfo[vehicle][carID]);
	new Cache:cache = mysql_query(dbHandle, query),
		count = cache_get_field_content_int(0, "total");
	
	cache_delete(cache);
	return count;
}
 
CountVehicleIDTickets(vehicle)
{
	new 
		query[128]
	;

 	mysql_format(dbHandle, query, sizeof(query), "SELECT COUNT(id) AS total FROM `tickets` WHERE `vehicle` = %i AND `paid` = 0", VehicleInfo[vehicle][carID]);
	new Cache:cache = mysql_query(dbHandle, query),
		count = cache_get_field_content_int(0, "total");

	cache_delete(cache);
	return count;
}

/*
MDC_CountPlayerTickets(playerid)
{
	new 
		query[128]
	;

 	mysql_format(dbHandle, query, sizeof(query), "SELECT COUNT(id) AS total FROM `tickets` WHERE `userid` = %i", PlayerInfo[playerid][pID]);
	new Cache:cache = mysql_query(dbHandle, query),
		count = cache_get_field_content_int(0, "total");
	
	cache_delete(cache);
	return count;
}

MDC_CountVehicleTickets(vehicle)
{
	new 
		query[128]
	;

 	mysql_format(dbHandle, query, sizeof(query), "SELECT COUNT(id) AS total FROM `tickets` WHERE `vehicle` = %i", VehicleInfo[vehicle][carID]);
	new Cache:cache = mysql_query(dbHandle, query),
		count = cache_get_field_content_int(0, "total");
	
	cache_delete(cache);
	return count;
}*/