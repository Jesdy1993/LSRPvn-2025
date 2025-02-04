forward OnCameraInsert(cameraid);

this::LoadDynamicCCTV()
{
    new rows = cache_num_rows(), time = GetTickCount(), total;

	if (!rows) return print("[CCTV] Khong co du lieu duoc tim thay.");

	for(new i; i < rows; i++)
	{
	    CCTVInfo[i][tvID] = cache_get_field_content_int(i, "id", dbHandle);
		CCTVInfo[i][tvPosX] = cache_get_field_content_float(i, "posx", dbHandle);
		CCTVInfo[i][tvPosY] = cache_get_field_content_float(i, "posy", dbHandle);
		CCTVInfo[i][tvPosZ] = cache_get_field_content_float(i, "posz", dbHandle);
		CCTVInfo[i][tvPosRX] = cache_get_field_content_float(i, "posrx", dbHandle);
		CCTVInfo[i][tvPosRY] = cache_get_field_content_float(i, "posry", dbHandle);
		CCTVInfo[i][tvPosRZ] = cache_get_field_content_float(i, "posrz", dbHandle);
		CCTVInfo[i][tvInt] = cache_get_field_content_int(i, "interior", dbHandle);
		CCTVInfo[i][tvVW] = cache_get_field_content_int(i, "virworld", dbHandle);
        CCTVInfo[i][tvBreak] = cache_get_field_content_int(i, "break", dbHandle);
        
        CCTVInfo[i][tvObjectOn] = 1;
		cache_get_field_content(i, "info", CCTVInfo[i][tvName], dbHandle, 32);

	    CCTVInfo[i][tvObject] = CreateDynamicObject(1886, CCTVInfo[i][tvPosX], CCTVInfo[i][tvPosY], CCTVInfo[i][tvPosZ], CCTVInfo[i][tvPosRX], CCTVInfo[i][tvPosRY], CCTVInfo[i][tvPosRZ], CCTVInfo[i][tvVW], CCTVInfo[i][tvInt]);
        CCTVInfo[i][tvCollision] = CreateDynamicObject(3800, CCTVInfo[i][tvPosX], CCTVInfo[i][tvPosY], CCTVInfo[i][tvPosZ]-1.0, CCTVInfo[i][tvPosRX], CCTVInfo[i][tvPosRY], CCTVInfo[i][tvPosRZ], CCTVInfo[i][tvVW], CCTVInfo[i][tvInt]);
        SetDynamicObjectMaterial(CCTVInfo[i][tvCollision], 0, 16644, "a51_detailstuff", "roucghstonebrtb", 0x00000000);

        if (CCTVInfo[i][tvBreak])    CCTVInfo[i][tvText] = CreateDynamic3DTextLabel("(( BI HONG ))", COLOR_GREY, CCTVInfo[i][tvPosX], CCTVInfo[i][tvPosY], CCTVInfo[i][tvPosZ]-0.5, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, CCTVInfo[i][tvVW], CCTVInfo[i][tvInt]);
        
        total++;
	}
	printf("[CCTV] Rows - %i. Load - %i. Time: %i ms.", rows, total, GetTickCount()-time);
	return 1;
}

public OnCameraInsert(cameraid)
{
	CCTVInfo[cameraid][tvID] = cache_insert_id();
	return 1;
}

AddCameraToFile(cameraid, interior, virworld, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, name[])
{
    new query[256];
	mysql_format(dbHandle, query, sizeof(query), "INSERT INTO `cctvs` (posx, posy, posz, posrx, posry, posrz, interior, virworld, break, info) VALUES (%f, %f, %f, %f, %f, %f, %i, %i, 0, '%e')",x,y,z, rx, ry, rz, interior,virworld,name);
	mysql_tquery(dbHandle, query, "OnCameraInsert", "d", cameraid);
	return 1;
}

SetCameraBreakState(cameraid, camerastate)
{
    if (camerastate < 0 || camerastate > 1) return 1;

    CCTVInfo[cameraid][tvBreak] = camerastate;
    SQL_SetInteger("cctvs", "break", CCTVInfo[cameraid][tvBreak], CCTVInfo[cameraid][tvID]);

    if (!camerastate)
    {
        if (IsValidDynamic3DTextLabel(CCTVInfo[cameraid][tvText]))
        {
            DestroyDynamic3DTextLabel(CCTVInfo[cameraid][tvText]);
            CCTVInfo[cameraid][tvText] = Text3D:INVALID_3DTEXT_ID;
        }
    }

    else
    {
        if (!IsValidDynamic3DTextLabel(CCTVInfo[cameraid][tvText]))
        {
            CCTVInfo[cameraid][tvText] = CreateDynamic3DTextLabel("(( BI HONG ))", COLOR_GREY, CCTVInfo[cameraid][tvPosX], CCTVInfo[cameraid][tvPosY], CCTVInfo[cameraid][tvPosZ]-0.5, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, CCTVInfo[cameraid][tvVW], CCTVInfo[cameraid][tvInt]);
        }
    }
    return 1;
}

GetNearestCamera(playerid, Float:near_cam = 15.0, camera_state = 0)
{
    for(new i = 0; i < MAX_CCTV; i++)
    {
        if (!CCTVInfo[i][tvObjectOn])                        continue;
        if (!IsValidDynamicObject(CCTVInfo[i][tvCollision])) continue;
        if (camera_state)
        {
            if (CCTVInfo[i][tvBreak])                        continue;
            if (CCTVInfo[i][tvSignal])                       continue;
            if (PCamera[playerid][i][pc_used])               continue;
        }

        if (IsPlayerInRangeOfPoint(playerid, near_cam, CCTVInfo[i][tvPosX], CCTVInfo[i][tvPosY], CCTVInfo[i][tvPosZ]) && GetPlayerInterior(playerid) == CCTVInfo[i][tvInt] && GetPlayerVirtualWorld(playerid) == CCTVInfo[i][tvVW])
        {
            return i;
        }
    }
    return -1;
}

CheckCCTVEquals(cctv_name[])
{
    for(new i = 0; i < MAX_CCTV; i++)
    {
        if (!CCTVInfo[i][tvObjectOn])    continue;
        if (isequal(CCTVInfo[i][tvName], cctv_name)) return 0;
    }
    return 1;
} //î