this::LoadDynamicEntrance()
{
	new rows = cache_num_rows(), time = GetTickCount(), total;

	if (!rows) return print("[Entrance] Khong co du lieu duoc tim thay.");
	

	for(new i; i < rows; i++)
	{
		EntranceInfo[i][eID] = cache_get_field_content_int(i, "id");
		EntranceInfo[i][eEnterX] = cache_get_field_content_float(i, "enterx");
		EntranceInfo[i][eEnterY] = cache_get_field_content_float(i, "entery");
		EntranceInfo[i][eEnterZ] = cache_get_field_content_float(i, "enterz");
		EntranceInfo[i][eEnterA] = cache_get_field_content_float(i, "entera");
		EntranceInfo[i][eEnterVW] = cache_get_field_content_int(i, "entervw");
		EntranceInfo[i][eEnterInt] = cache_get_field_content_int(i, "enterint");
		EntranceInfo[i][eExitX] = cache_get_field_content_float(i, "exitx");
		EntranceInfo[i][eExitY] = cache_get_field_content_float(i, "exity");
		EntranceInfo[i][eExitZ] = cache_get_field_content_float(i, "exitz");
		EntranceInfo[i][eExitA] = cache_get_field_content_float(i, "exita");
		EntranceInfo[i][eExitVW] = cache_get_field_content_int(i, "exitvw");
		EntranceInfo[i][eExitInt] = cache_get_field_content_int(i, "exitint");
		EntranceInfo[i][eFaction] = cache_get_field_content_int(i, "faction");
		EntranceInfo[i][eVehicle] = cache_get_field_content_int(i, "vehicle");
		cache_get_field_content(i, "text", EntranceInfo[i][eText], dbHandle, 128);
		cache_get_field_content(i, "gpsname", EntranceInfo[i][gpsText], dbHandle, 128);

		if (EntranceInfo[i][eFaction]) EntranceInfo[i][eLocked] = 1;

		EntranceInfo[i][entranceOn] = 1;
		EntranceInfo[i][eEnterPickup] = CreateDynamicPickup(1239, 1, EntranceInfo[i][eEnterX], EntranceInfo[i][eEnterY], EntranceInfo[i][eEnterZ], EntranceInfo[i][eEnterVW], EntranceInfo[i][eEnterInt], -1, 100.0);
        EntranceInfo[i][eExitPickup] = CreateDynamicPickup(1239, 1, EntranceInfo[i][eExitX], EntranceInfo[i][eExitY], EntranceInfo[i][eExitZ], EntranceInfo[i][eExitVW], EntranceInfo[i][eExitInt], -1, 100.0);
		total++;
	}
	printf("[Entrance] Rows - %i. Load - %i. Time: %i ms.", rows, total, GetTickCount()-time);
	return 1;
}

this::OnInsertEntrance(id)
{
	return EntranceInfo[id][eID] = cache_insert_id();
}

IsPlayerEntranceOutside(playerid, i, Float: radius = 1.0)
{
    return (IsPlayerInRangeOfPoint(playerid, radius, EntranceInfo[i][eEnterX], EntranceInfo[i][eEnterY], EntranceInfo[i][eEnterZ]) && GetWorld(playerid) == EntranceInfo[i][eEnterVW] && GetInterior(playerid) == EntranceInfo[i][eEnterInt]) ? (1) : (0);
}

IsPlayerEntranceInside(playerid, i, Float: radius = 1.0)
{
    return (IsPlayerInRangeOfPoint(playerid, radius, EntranceInfo[i][eExitX], EntranceInfo[i][eExitY], EntranceInfo[i][eExitZ]) && GetWorld(playerid) == EntranceInfo[i][eExitVW] && GetInterior(playerid) == EntranceInfo[i][eExitInt]) ? (1) : (0);
}

GetNearEntranceOutside(playerid, Float: radius = 1.0)
{
    for(new i; i != MAX_ENTRANCE; i++)
	{
	    if (!EntranceInfo[i][entranceOn]) 					continue;
	    if (IsPlayerEntranceOutside(playerid, i, radius))	return i;
	}
	return -1;
}

GetNearEntranceInside(playerid, Float: radius = 1.0)
{
    for(new i; i != MAX_ENTRANCE; i++)
	{
	    if (!EntranceInfo[i][entranceOn]) 				continue;
	    if (IsPlayerEntranceInside(playerid, i, radius)) return i;
	}
	return -1;
}

GetEntranceZone(entranceid, type = 0)
{
	new string[70], zone[28];

	GetZone(EntranceInfo[entranceid][eEnterX], EntranceInfo[entranceid][eEnterY], zone, sizeof(zone));
	
	if (IsPointInAnyDynamicArea(EntranceInfo[entranceid][eEnterX], EntranceInfo[entranceid][eEnterY], EntranceInfo[entranceid][eEnterZ])) 
	{
		new areas[5], street_area[1], j = GetNumberDynamicAreasForPoint(EntranceInfo[entranceid][eEnterX],EntranceInfo[entranceid][eEnterY],EntranceInfo[entranceid][eEnterZ]);
		GetDynamicAreasForPoint(EntranceInfo[entranceid][eEnterX], EntranceInfo[entranceid][eEnterY], EntranceInfo[entranceid][eEnterZ], areas, sizeof(areas));

		if (GetStreet(areas, j, street_area)) 
		{
			if (type == 0) 		format(string, sizeof(string), "%s, %s %i", zone, street_names[street_area[0]], 35+entranceid); 
			else if (type == 1) 	format(string, sizeof(string), "%03d %s,~n~%s", 35+entranceid, street_names[street_area[0]], zone);
			else if (type == 2) 	format(string, sizeof(string), "%s %i", street_names[street_area[0]], 35+entranceid); 

			return string;
		}
	}

	format(string, sizeof(string), "%s %i", zone, 35+entranceid);
	return string;
}