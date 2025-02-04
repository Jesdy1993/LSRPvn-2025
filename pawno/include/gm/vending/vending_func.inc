GetNextVendingMachineID()
{
	for(new i; i != MAX_VENDINGMACHINE; i++)
	{
	    if (VendingInfo[i][vendingID] == 0) return i;
	}
	return -1;
}

Vending_Nearest(playerid)
{
	for(new i; i != MAX_VENDINGMACHINE; i++)
	{
	    if (GetWorld(playerid) == VendingInfo[i][vendingVW] && VendingInfo[i][vendingInt] == GetInterior(playerid) && IsPlayerInRangeOfPoint(playerid, 2.0, VendingInfo[i][vendingX], VendingInfo[i][vendingY], VendingInfo[i][vendingZ]) && VendingInfo[i][vendingObject])
		{
			return i;
		}
	}
	return -1;
}

this::OnVendingInsert(id)
{
	return VendingInfo[id][vendingID] = cache_insert_id();	
}

Save_VM(vendingid)
{
	if (vendingid < 0 || vendingid >= MAX_VENDINGMACHINE || !VendingInfo[vendingid][vendingID]) return 1;

	new query[1024];
	mysql_format(dbHandle, query, sizeof(query), "UPDATE `vendingmachines` SET  `posx` = %f, `posy` = %f, `posz` = %f, `rx` = %f, `ry` = %f, `rz` = %f, `owner`='%s', `ownerid` = %i, `type` = %i, `price` =%i, `lock` = %i, `alarm` = %i, `vault` = %i, `interior` = %i, `world` = %i WHERE `id` = %i",
	VendingInfo[vendingid][vendingX], VendingInfo[vendingid][vendingY], VendingInfo[vendingid][vendingZ],
	VendingInfo[vendingid][vendingRX], VendingInfo[vendingid][vendingRY], VendingInfo[vendingid][vendingRZ],
	VendingInfo[vendingid][vendingOwner], VendingInfo[vendingid][vendingOwnerID], VendingInfo[vendingid][vendingType],
	VendingInfo[vendingid][vendingPrice], VendingInfo[vendingid][vendingLock], VendingInfo[vendingid][vendingAlarm],
	VendingInfo[vendingid][vendingVault], VendingInfo[vendingid][vendingInt], VendingInfo[vendingid][vendingVW],
	VendingInfo[vendingid][vendingID]);
	mysql_tquery(dbHandle, query);
	return 1;
}

AddVendingInfoToFile(standid, type, Float:x, Float:y, Float:z, vw, interior, price)
{
    new query[128 + 128];
	mysql_format(dbHandle, query, sizeof(query), "INSERT INTO `vendingmachines` (type, posx, posy, posz, world, interior, price) VALUES (%i, %f, %f, %f, %i, %i, %i)", type, x, y, z, vw, interior, price);
	mysql_tquery(dbHandle, query, "OnVendingInsert", "d", standid);
	return 1;
}


this::LoadVendingMachines()
{
    new rows = cache_num_rows(), time = GetTickCount(), total, label[64];

	if (!rows)	return print("[Vending Machines] No records found.");

	for(new i; i < rows; i++)
	{
	    VendingInfo[i][vendingID] = cache_get_field_content_int(i, "id", dbHandle);
		VendingInfo[i][vendingX] = cache_get_field_content_float(i, "posx", dbHandle);
		VendingInfo[i][vendingY] = cache_get_field_content_float(i, "posy", dbHandle);
		VendingInfo[i][vendingZ] = cache_get_field_content_float(i, "posz", dbHandle);
		VendingInfo[i][vendingRX] = cache_get_field_content_float(i, "rx", dbHandle);
		VendingInfo[i][vendingRY] = cache_get_field_content_float(i, "ry", dbHandle);
		VendingInfo[i][vendingRZ] = cache_get_field_content_float(i, "rz", dbHandle);
		cache_get_field_content(i, "owner", VendingInfo[i][vendingOwner], dbHandle, 32);
		VendingInfo[i][vendingOwnerID] = cache_get_field_content_int(i, "ownerid", dbHandle);
		VendingInfo[i][vendingType] = cache_get_field_content_int(i, "type", dbHandle);
		VendingInfo[i][vendingPrice] = cache_get_field_content_int(i, "price", dbHandle);
		VendingInfo[i][vendingLock] = cache_get_field_content_int(i, "lock", dbHandle);
		VendingInfo[i][vendingAlarm] = cache_get_field_content_int(i, "alarm", dbHandle);
		VendingInfo[i][vendingVault] = cache_get_field_content_int(i, "vault", dbHandle);
		VendingInfo[i][vendingInt] = cache_get_field_content_int(i, "interior", dbHandle);
		VendingInfo[i][vendingVW] = cache_get_field_content_int(i, "world", dbHandle);


		new vendingModel = (VendingInfo[i][vendingType] == TYPE_FOOD) ? 1776 : 1775;
		VendingInfo[i][vendingObject] = CreateDynamicObject(vendingModel, VendingInfo[i][vendingX], VendingInfo[i][vendingY], VendingInfo[i][vendingZ], VendingInfo[i][vendingRX], VendingInfo[i][vendingRY], VendingInfo[i][vendingRZ], VendingInfo[i][vendingVW], VendingInfo[i][vendingInt], -1, 200.0);

		if(!VendingInfo[i][vendingOwnerID])
		{
			format(label, sizeof(label), "Vending %i\nPrice: %i", i, VendingInfo[i][vendingPrice]);
			VendingInfo[i][vendingLabel] = CreateDynamic3DTextLabel(label, COLOR_GOLD, VendingInfo[i][vendingX], VendingInfo[i][vendingY], VendingInfo[i][vendingZ]+1.3, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, VendingInfo[i][vendingVW], VendingInfo[i][vendingInt], -1, 50.0);
		}
		else
		{
			format(label, sizeof(label), "Vending %i", i);
			VendingInfo[i][vendingLabel] = CreateDynamic3DTextLabel(label, COLOR_GOLD, VendingInfo[i][vendingX], VendingInfo[i][vendingY], VendingInfo[i][vendingZ]+1.3, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, VendingInfo[i][vendingVW], VendingInfo[i][vendingInt], -1, 50.0);
		}

		total++;
	}
	printf("[Vending Machines] Rows - %i. Load - %i. Time: %i ms.", rows, total, GetTickCount()-time);
	return 1;
}