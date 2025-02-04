#define    MAX_TICKETS    	999

enum ENUM_TICKET 
{
	ticket_id,
	ticket_for,
    ticket_createtime,
	ticket_timestamp,
	ticket_price,
	ticket_reason[128],
	ticket_officer[128],
    ticket_badgenum[32],
    ticket_charge,
    ticket_streetname[128],
    ticket_city[64],
    Float:ticket_streetcode,
    ticket_name[128],
    ticket_birthdate[64],
    ticket_age,
    ticket_sex
}	

new Ticket[MAX_TICKETS][ENUM_TICKET];

hook OnGameModeInit()
{
	LoadTicketS();
}

stock LoadTicketS() 
{
	mysql_function_query(MainPipeline, "SELECT * FROM `ticket`", false, "LoadedTicket", "i", SENDDATA_THREAD);
	return 1;
}

forward LoadedTicket();
public LoadedTicket()
{
    new rows = cache_num_rows(), total;
    new string[128];
	if (rows == 0) return print("[Ticket Dynamic] khong co du lieu duoc tim thay.");
	for(new i = 1; i < rows; i++)
	{
		Ticket[i][ticket_id] = cache_get_field_content_int(i, "id", MainPipeline);
		Ticket[i][ticket_for] = cache_get_field_content_int(i, "ticket_for", MainPipeline);
        Ticket[i][ticket_createtime] = cache_get_field_content_int(i, "createtime", MainPipeline);
		Ticket[i][ticket_timestamp] = cache_get_field_content_int(i, "timestamp", MainPipeline);

		Ticket[i][ticket_price] = cache_get_field_content_int(i, "price", MainPipeline);
		cache_get_field_content(i,  "reason", Ticket[i][ticket_reason], MainPipeline, 128);
		cache_get_field_content(i,  "officer", Ticket[i][ticket_officer], MainPipeline, 128);
        cache_get_field_content(i,  "badgenum", Ticket[i][ticket_badgenum], MainPipeline, 32);

        Ticket[i][ticket_charge] = cache_get_field_content_int(i, "charge", MainPipeline);

        cache_get_field_content(i,  "streetname", Ticket[i][ticket_streetname], MainPipeline, 128);
        cache_get_field_content(i,  "city", Ticket[i][ticket_city], MainPipeline, 64);
        cache_get_field_content(i,  "streetcode", string, MainPipeline); Ticket[i][ticket_streetcode] = floatstr(string);

        cache_get_field_content(i,  "name", Ticket[i][ticket_name], MainPipeline, 128);
        cache_get_field_content(i,  "birthdate", Ticket[i][ticket_birthdate], MainPipeline, 128);
        Ticket[i][ticket_age] = cache_get_field_content_int(i, "age", MainPipeline);
        Ticket[i][ticket_sex] = cache_get_field_content_int(i, "sex", MainPipeline);

        total++;
	}
	printf("[Ticket Dynamic] Loaded.");
	return 1;
}

stock SetPlayerTicketData(playerid, money, const reason[], officerid)
{
    new query[514],
        Float: x, 
        Float: y, 
        Float: z,
        location[MAX_ZONE_NAME],
        location2[MAX_ZONE_NAME];


    GetPlayerPos(playerid, x, y, z);
    GetPlayer3DZone(playerid, location2, sizeof(location2));
    GetPlayerStreetZone(x, y, location, location2, sizeof(location));

    new mainzone[MAX_ZONE_NAME];
    GetPlayerMainZone(playerid, mainzone, MAX_ZONE_NAME);

    GetPlayerPos(playerid, x, y, z);

    format(query, sizeof(query), "INSERT INTO `ticket` (`ticket_for`, `createtime`, `timestamp`, `price`, `reason`, `officer`, `badgenum`, `charge`, `streetname`, `city`, `streetcode`, `name`, `birthdate`, `sex`)\
                                                         VALUES (%d, %d, %d, %d, '%s', '%s', '%s', 0, '%s', '%s', '%0.2f', '%s', '%s', %d)",
                                                        GetPlayerSQLId(playerid), gettime()+25200, gettime()+284400, money, reason, GetPlayerNameEx(officerid), PlayerInfo[officerid][pMPH],
                                                        location, mainzone, x,
                                                        GetPlayerNameEx(playerid), PlayerInfo[playerid][pBirthDate],PlayerInfo[playerid][pSex]);
    mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
    return 1;
}

stock RemovePlayerTicketData(playerid, ticketid)
{
	new query[514];
	format(query, sizeof(query), "SELECT * FROM `ticket` WHERE `id` = '%d' AND `ticket_for` = '%d'", ticketid, GetPlayerSQLId(playerid));
    mysql_function_query(MainPipeline, query, false, "OnTicketCheck", "ii", playerid, ticketid);
    return 1;
}

forward OnTicketCheck(playerid, extraid);
public OnTicketCheck(playerid, extraid)
{
    if(IsPlayerConnected(playerid))
    {
        new string[128], szResult[128], price;
        new rows, fields;
        cache_get_data(rows, fields, MainPipeline);

        if(rows)
        {
        	cache_get_field_content(0, "price", szResult, MainPipeline);
        	price = strval(szResult);

        	GivePlayerMoneyEx(playerid, -price);
        	
        	format(string, sizeof(string), "~w~Ban da dong phat ~g~$%s~w~ cho Ticket ~y~#%d~w~.", number_format(price), extraid);
        	ShowNotifyTextMain(playerid, string);

            format(string, sizeof(string), "DELETE FROM `ticket` WHERE `id` = '%d'", extraid);
			mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);
        }
        else
        {
        	format(string, sizeof(string), "~w~Ticket ~y~#%d~w~ khong phai la cua ban.", extraid);
            ShowNotifyTextMain(playerid, string);
        }
    }
    return 1;
}

stock ShowPlayerTicketMenu(playerid)
{
	new query[514];
	format(query, sizeof(query), "SELECT `id`, `timestamp`, `price`, `reason`, `officer` FROM `ticket` WHERE `ticket_for` = %d ORDER BY `id` DESC LIMIT 10", GetPlayerSQLId(playerid));
    mysql_function_query(MainPipeline, query, true, "OnTicketMenu", "i", playerid);
    return 1;
}

forward OnTicketMenu(playerid);
public OnTicketMenu(playerid)
{
    new string[128], title[128], rows, fields, noidung[10000],
    	id, timestamp, price, reason[128], officer[64];
    cache_get_data(rows, fields, MainPipeline);
    if(rows)
    {
    	noidung = "(#) Noi dung\tOfficer\tSo tien phat\tThoi han\n";
        for(new i; i < rows; i++)
        {
            cache_get_field_content(i, "id", string, MainPipeline);
            id = strval(string);

            cache_get_field_content(i, "timestamp", string, MainPipeline);
            timestamp = strval(string);

            cache_get_field_content(i, "price", string, MainPipeline);
            price = strval(string);

            cache_get_field_content(i, "reason", reason, MainPipeline, sizeof(reason));
            cache_get_field_content(i, "officer", officer, MainPipeline, sizeof(officer));

            format(noidung, sizeof(noidung), "%s{9E9E9E}({829bba}#%d{9E9E9E}) {829bba}%s\t{a2aebd}%s\t{4e7350}$%s\t{a2aebd}%s\n", noidung, id, reason, officer, number_format(price), date(timestamp));	

        }
        format(title, sizeof(title), "[Police Station] Ticket cua %s", GetPlayerNameEx(playerid));
        Dialog_Show(playerid, PRESS_TICKET, DIALOG_STYLE_TABLIST_HEADERS, title, noidung, ">", "");

    }
    else
    {
    	format(title, sizeof(title), "[Police Station] Ticket cua %s", GetPlayerNameEx(playerid));
    	Dialog_Show(playerid, 0, DIALOG_STYLE_TABLIST, title, "Khong co ve phat nao ca.", ">", "");
    }
    return 1;
}

Dialog:PRESS_TICKET(playerid, response, listitem, inputtext[]) 
{
	new string[1024];
    if(response)
    {
    	format(string, sizeof(string), "\t\t\t\t{829bba}[ Police Station - Ticket Pay-fines ]\n\n\
    									\t\t{9E9E9E}Vui long nhap ma Ticket vao phia ben duoi de thanh toan\n\
    									\t{9E9E9E}Ma ticket: Dau {829bba}#{9E9E9E} trong phan {829bba}Noi dung{9E9E9E} | {9E9E9E}e.g: ({829bba}28{9E9E9E}) Vi pham luat giao thong duong bo.");
        Dialog_Show(playerid, CONFIRM_TICKET, DIALOG_STYLE_INPUT, "[Polcie Station] Thanh toan ve phat", string, "Xac nhan", "<");
    }
    return 1;
}

Dialog:CONFIRM_TICKET(playerid, response, listitem, inputtext[]) 
{
	new query[518];
    if(response)
    {
    	new TicketID = strval(inputtext);

    	SetPVarInt(playerid, "getTicketID", TicketID);
    	printf("Ticket ID = %d", TicketID);

    	format(query, sizeof(query), "SELECT * FROM `ticket` WHERE `id` = '%d' AND `ticket_for` = '%d'", TicketID, GetPlayerSQLId(playerid));
    	mysql_function_query(MainPipeline, query, false, "OnLoadPlayerTicket", "ii", playerid, TicketID);
    }
    else
    {
    	ShowPlayerTicketMenu(playerid);
    }
    return 1;
}

forward OnLoadPlayerTicket(playerid, extraid);
public OnLoadPlayerTicket(playerid, extraid)
{
    if(IsPlayerConnected(playerid))
    {
        new string[1028], szResult[128];
        new rows, fields;
        cache_get_data(rows, fields, MainPipeline);

        if(rows)
        {
        	new reason[128];
        	cache_get_field_content(0, "reason", reason, MainPipeline, sizeof(reason));

        	cache_get_field_content(0, "createtime", szResult, MainPipeline);
        	new create_time = strval(szResult);

        	cache_get_field_content(0, "timestamp", szResult, MainPipeline);
        	new expire_time = strval(szResult);

        	new officer[128];
        	cache_get_field_content(0, "officer", officer, MainPipeline, sizeof(officer));
            new badgenum[128];
            cache_get_field_content(0, "badgenum", badgenum, MainPipeline, sizeof(badgenum));

            new streetname[128];
            cache_get_field_content(0, "streetname", streetname, MainPipeline, sizeof(streetname));
            new city[128];
            cache_get_field_content(0, "city", city, MainPipeline, sizeof(city));
            new Float:streetcode;
            cache_get_field_content(0, "streetcode", szResult, MainPipeline);
            streetcode = floatstr(szResult);


        	cache_get_field_content(0, "price", szResult, MainPipeline);
        	new price = strval(szResult);

        	format(string, sizeof(string), "\t{829bba}[ Police Station - Look Up: Ticket #%d ]\t\n\
    										\t{9E9E9E}Hay kiem tra ki truoc khi thanh toan.\t\n\n\
    										\
                                            {9E9E9E}Officer thuc hien: {829bba}%s{9E9E9E} (%s).\n\
                                            {9E9E9E}So tien cua ve phat: {829bba}$%s{9E9E9E}.\n\
                                            {9E9E9E}Noi dung: {829bba}%s{9E9E9E}.\n\n\
                                            \
    										{9E9E9E}Ve phat duoc viet luc: {829bba}%s{9E9E9E}.\n\
    										{9E9E9E}Thoi han cua ve phat: {829bba}%s{9E9E9E}.\n\n\
                                            \
                                            {9E9E9E}Duoc viet tai: {829bba}%s{9E9E9E}, {829bba}%s{9E9E9E}.\n\
                                            {9E9E9E}Street Code: {829bba}%0.2f{9E9E9E}.",
    										extraid,

                                            officer, badgenum,
                                            number_format(price),
    										reason,

    										date(create_time), date(expire_time),

                                            streetname, city,
                                            streetcode);

        	Dialog_Show(playerid, PAYFINES_TICKET, DIALOG_STYLE_MSGBOX, "[Polcie Station] Kiem tra thanh toan", string, "Xac nhan", "<");
        }
        else
        {
        	format(string, sizeof(string), "~w~Ticket ~y~#%d~w~ khong phai la cua ban.", extraid);
            ShowNotifyTextMain(playerid, string);
        }
    }
    return 1;
}


Dialog:PAYFINES_TICKET(playerid, response, listitem, inputtext[]) 
{
    new string[128];
    if(response)
    {
    	new TicketID = GetPVarInt(playerid, "getTicketID");
    	RemovePlayerTicketData(playerid, TicketID);

        foreach(new i : Player)
        {
            if(IsACop(i))
            {
                format(string, sizeof(string), "** HQ: %s da thanh toan Ticket #%d.", GetPlayerNameEx(playerid), TicketID);
                SendClientMessageEx(i, 0x9579F7FF, string);
            }
        }

    }
    else
    {
    	ShowPlayerTicketMenu(playerid);
    }
    return 1;
}

forward OnTicketCheckVar(playerid);
public OnTicketCheckVar(playerid)
{
    new szResult[128], string[128], rows, fields;
    cache_get_data(rows, fields, MainPipeline);
    if(rows)
    {
    	cache_get_field_content(0, "timestamp", szResult, MainPipeline);
       	new expire_time = strval(szResult);
       	
       	cache_get_field_content(0, "id", szResult, MainPipeline);
        new ticketid = strval(szResult);

        cache_get_field_content(0, "charge", szResult, MainPipeline);
        new charge = strval(szResult);

        if(expire_time < gettime()+25200 && charge == 0)
        {
        	PlayerInfo[playerid][pWantedLevel] += 1;
        	AddFlag(playerid, INVALID_PLAYER_ID, "Expired Ticket");
        	format(string, sizeof(string), "[Ticket Warning] Ticket #%d cua ban da qua han va ban dang co them 1 toi danh (Toi danh hien tai: %d)", ticketid, PlayerInfo[playerid][pFlagged]);
        	SendClientMessageEx(playerid, COLOR_LIGHTRED, string);

        	format(string, sizeof(string), "UPDATE `ticket` SET `charge` = 1 WHERE `id` = '%d'", ticketid);
        	mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);

        	foreach(new i : Player)
            {
                if(IsACop(i))
                {
                    format(string, sizeof(string), "** HQ: Co mot thong bao thiet lap toi danh moi tu Police Station.");
                    SendClientMessageEx(i, 0x9579F7FF, string);
                    format(string, sizeof(string), ">> Doi tuong: %s - Toi danh: Expired Ticket.", GetPlayerNameEx(playerid));
                    SendClientMessageEx(i, 0x9579F7FF, string);
                }
            }

        }
    }
    else
    {
    	//SendClientMessageEx(playerid, COLOR_CHAT, "No more");
    }
    return 1;
}