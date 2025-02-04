forward LoadDynamicSpeed();
forward OnSpeedInsert(speedid);

public LoadDynamicSpeed()
{
    new rows = cache_num_rows(), time = GetTickCount(), total;

	if (!rows) return print("[Speedcams] Khong co du lieu duoc tim thay.");

	for(new i; i < rows; i++)
	{
	    speedcam[i][sc_id]      = cache_get_field_content_int(i, "id");
        speedcam[i][sc_speed]   = cache_get_field_content_int(i, "speed");

        cache_get_field_content(i, "name", speedcam[i][sc_name], dbHandle, 32);

        speedcam[i][sc_x]       = cache_get_field_content_float(i, "posx");
        speedcam[i][sc_y]       = cache_get_field_content_float(i, "posy");
        speedcam[i][sc_z]       = cache_get_field_content_float(i, "posz");
        speedcam[i][sc_rx]      = cache_get_field_content_float(i, "posrx");
        speedcam[i][sc_ry]      = cache_get_field_content_float(i, "posry");
        speedcam[i][sc_rz]      = cache_get_field_content_float(i, "posrz");
        speedcam[i][sc_int]     = cache_get_field_content_int(i, "interior");
        speedcam[i][sc_vw]      = cache_get_field_content_int(i, "virworld");


	    speedcam[i][sc_object] = CreateDynamicObject(18880, speedcam[i][sc_x], speedcam[i][sc_y], speedcam[i][sc_z], speedcam[i][sc_rx], speedcam[i][sc_ry], speedcam[i][sc_rz], speedcam[i][sc_vw], speedcam[i][sc_int]);
        speedcam[i][sc_areaid] = CreateDynamicSphere(speedcam[i][sc_x], speedcam[i][sc_y], speedcam[i][sc_z], SC_DEF_RADIUS, speedcam[i][sc_vw], speedcam[i][sc_int]);

        total++;
	}
	printf("[Speedcams] Rows - %i. Load - %i. Time: %i ms.", rows, total, GetTickCount()-time);
	return 1;
}

public OnSpeedInsert(speedid)
{
	speedcam[speedid][sc_id] = cache_insert_id();
	return 1;
}

AddSpeedcamToFile(scam, speed_fl, speed_name[], Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, speedint, speedvw)
{
    new query[612];
	mysql_format(dbHandle, query, sizeof(query), "INSERT INTO `speedcams` (`speed`,`name`,`posx`,`posy`,`posz`,`posrx`,`posry`,`posrz`,`interior`,`virworld`) VALUES (%i,'%s',%f,%f,%f,%f,%f,%f,%i,%i)", speed_fl, speed_name, x, y, z, rx, ry, rz, speedint, speedvw);
    mysql_tquery(dbHandle, query, "OnSpeedInsert", "d", scam);
	return 1;
}

SC_GetFreeID()
{
	for(new i; i < MAX_SPEEDCAMS; i++)
	{
	    if (!speedcam[i][sc_id]) return i;
	}
	return -1;
}

GetNearestSpeed(playerid, Float:speed_range, speed_status = 0)
{
    if (speed_status)
    {
        if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return -1;
    }

    for(new i; i < MAX_SPEEDCAMS; i++)
    {
        if (!IsValidDynamicObject(speedcam[i][sc_object]))                                                           continue;
        if (!IsPlayerInRangeOfPoint(playerid, speed_range, speedcam[i][sc_x], speedcam[i][sc_y], speedcam[i][sc_z])) continue;
        
        if (speed_status)
        {
            if (speedcam[i][sc_speed] >= GetVehicleSpeed(GetPlayerVehicleID(playerid)))  return -1;
        }
        return i;
    }
    return -1;
}

