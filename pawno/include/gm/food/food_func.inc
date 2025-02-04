Fo_OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
	for(new i; i < MAX_FOOD_STAND; i++)
	{
		if (FoodStand[i][fPickUp] == pickupid)
		{
			CreateLableText(playerid,"~h~~p~HANG RONG~n~~y~\"Cluckin' Bell\"", "~w~~h~Nhan ~y~~h~'F' ~w~de mua hoac ~n~nhap ~y~~h~/buyfood~h~~w~");
			break;
		}
	}
	return 1;
}

this::LoadDynamicStands()
{
    new rows = cache_num_rows(), time = GetTickCount(), total;

	if (!rows)
	{
	    print("[FoodStand] Khong co du lieu duoc tim thay.");
	    return 1;
	}

	for(new i; i < rows; i++)
	{
	    FoodStand[i][fID] = cache_get_field_content_int(i, "id", dbHandle);
	    FoodStand[i][fType] = cache_get_field_content_int(i, "type", dbHandle);
	    FoodStand[i][fPosX] = cache_get_field_content_float(i, "posx", dbHandle);
	    FoodStand[i][fPosY] = cache_get_field_content_float(i, "posy", dbHandle);
	    FoodStand[i][fPosZ] = cache_get_field_content_float(i, "posz", dbHandle);
	    FoodStand[i][fPosRX] = cache_get_field_content_float(i, "posrx", dbHandle);
	    FoodStand[i][fPosRY] = cache_get_field_content_float(i, "posry", dbHandle);
	    FoodStand[i][fPosRZ] = cache_get_field_content_float(i, "posrz", dbHandle);

	    FoodStand[i][fVW] = cache_get_field_content_int(i, "vw", dbHandle);
	    FoodStand[i][fInt] = cache_get_field_content_int(i, "interior", dbHandle);

	    if (FoodStand[i][fType] == 1)
	    {
		    FoodStand[i][fObject] =	CreateDynamicObject(1340, FoodStand[i][fPosX], FoodStand[i][fPosY], FoodStand[i][fPosZ], FoodStand[i][fPosRX], FoodStand[i][fPosRY], FoodStand[i][fPosRZ], FoodStand[i][fVW], FoodStand[i][fInt], -1, 200.0);

		    if (FoodStand[i][fPosRZ] < -50.0)	FoodStand[i][fPosY] += (1.2 * floatcos((-FoodStand[i][fPosRZ]+90), degrees));
			if (FoodStand[i][fPosRZ] < -150.0) 	FoodStand[i][fPosX] += (1.2 * floatsin((-FoodStand[i][fPosRZ]+90), degrees));
			if (FoodStand[i][fPosRZ] >= 0.0) 	FoodStand[i][fPosX] += (1.2 * floatsin((-FoodStand[i][fPosRZ]+90), degrees));
			if (FoodStand[i][fPosRZ] > 50.0) 	FoodStand[i][fPosY] += (1.2 * floatcos((-FoodStand[i][fPosRZ]+90), degrees));
	    }

	    //FoodStand[i][fLabel] = CreateDynamic3DTextLabel(""EMBED_RED"["EMBED_WHITE"Палатка с едой"EMBED_RED"]\n"EMBED_CYAN"/buyfood.", -1, FoodStand[i][fPosX], FoodStand[i][fPosY], FoodStand[i][fPosZ], 2.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, FoodStand[i][fVW], FoodStand[i][fInt], -1, 100.0);
		FoodStand[i][fPickUp] =	CreateDynamicPickup(1239, 1, FoodStand[i][fPosX], FoodStand[i][fPosY], FoodStand[i][fPosZ], FoodStand[i][fVW], FoodStand[i][fInt], -1, 100.0);
	    FoodStand[i][fStandOn] = 1;

	    total++;
	}
	printf("[FoodStand] Rows - %i. Load - %i. Time: %i ms.", rows, total, GetTickCount()-time);
	return 1;
}

this::OnFoodStandInsert(StandID)
{
	return FoodStand[StandID][fID] = cache_insert_id();
}

AddFoodStandToFile(standid, type, Float:x, Float:y, Float:z, vw, interior)
{
    new query[128 + 128];
	mysql_format(dbHandle, query, sizeof(query), "INSERT INTO `foodstand` (type, posx, posy, posz, vw, interior) VALUES (%i, %f, %f, %f, %i, %i)", type, x, y, z, vw, interior);
	mysql_tquery(dbHandle, query, "OnFoodStandInsert", "d", standid);
	return 1;
}