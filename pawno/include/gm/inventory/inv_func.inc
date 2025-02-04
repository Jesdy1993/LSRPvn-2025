stock LoadPlayerInventory(playerid)
{
    new query[128];
    mysql_format(dbHandle, query, sizeof(query), "SELECT * FROM `inventory` WHERE `userid`=%i", PlayerInfo[playerid][pID]);
   	mysql_tquery(dbHandle, query, "P_LoadInventory", "i", playerid);
	return 1;
}

this::P_LoadInventory(playerid)
{
	if (!cache_num_rows())
	{
	    new query[128];
        mysql_format(dbHandle, query, sizeof(query), "INSERT INTO `inventory` (`userid`) VALUES (%i)", PlayerInfo[playerid][pID]);
	    mysql_tquery(dbHandle, query);
	    return 1;
	}

	SetPVarInt(playerid, #pDelay, 1);
	for(new i = 0; i < MAX_INV_SLOTS; i++)
	{
		new invnum[24];

		format(invnum, sizeof(invnum), "id_%d", i+1);
		new itID = cache_get_field_content_int(0, invnum);

		if (itID != 0) 
		{
			new invnum2[24], invnum3[24], invnum4[24], invnum5[24];
			format(invnum3, sizeof(invnum3), "ex_%d", i+1);
			format(invnum4, sizeof(invnum4), "s_%d", i+1);
			

			switch(itID)
			{
				case INV_GANJA, INV_MED_GANJA, 103 .. 118:
				{
					format(invnum2, sizeof(invnum2), "f_%d", i+1);
					GiveFloatInvItem(playerid, itID, cache_get_field_content_float(0, invnum2), cache_get_field_content_int(0, invnum3), cache_get_field_content_int(0, invnum4));
				}

				case INV_DRUG: {
					format(invnum2, sizeof(invnum2), "f_%d", i+1);
					format(invnum5, sizeof(invnum5), "n_%d", i+1);

					new name[16];
					cache_get_field_content(0, invnum5, name);	

					GiveDrugInvItem(playerid, name, cache_get_field_content_float(0, invnum2), cache_get_field_content_int(0, invnum3), cache_get_field_content_int(0, invnum4));
				}

				default:
				{
					format(invnum2, sizeof(invnum2), "a_%d", i+1);
					GiveInvItem(playerid, itID, cache_get_field_content_int(0, invnum2), cache_get_field_content_int(0, invnum3), cache_get_field_content_int(0, invnum4));
				}
			}
		}
	}
	SetPVarInt(playerid, #pDelay, 0);
	return 1;
}

stock RemoveItem(playerid, slot)
{
	Inventory[playerid][slot][pInvItem] = 0;
	Inventory[playerid][slot][pInvQ] = 0;
	Inventory[playerid][slot][pInvQFloat] = 0.0;
	Inventory[playerid][slot][pInvEx] = 0;
	Inventory[playerid][slot][pInvS] = 0;
	format(Inventory[playerid][slot][pInvName], 16, "");
	return 1;
}

stock GivePlayerInvItem(playerid = -1, itemid = 0, amount = 0, Float:f_amount = 0.0, ex = 0, serial = 0, name[] = EOS, split = 0)
{

	//if (!GetPVarInt(playerid, #pDelay))			 return GivePlayerInvItem(playerid, itemid, amount, f_amount, ex, serial, name);
	if (!IsPlayerLogged(playerid))				 return -1;
	if (playerid == -1) 							 return -1; // по фану сделал
	if (itemid < 0 || itemid >= MAX_ITEM_LIST)	 return -1;
	//if (!isnull(name) && strlen(name) > 16)		 return -1;

	if (inventory_items[itemid][itemFloat]) // FLOAT
	{
		if (f_amount <= 0.0 || f_amount > 1000.0)	return -1;

		for(new i = 0; i < MAX_INV_SLOTS; i++) 
		{
			if (itemid == INV_DRUG) // DRUGS
			{
				if (CompareStrings(name, Inventory[playerid][i][pInvName]) && !isnull(name) && !isnull(Inventory[playerid][i][pInvName]) && Inventory[playerid][i][pInvS] == serial && Inventory[playerid][i][pInvEx] == ex && Inventory[playerid][i][pInvQFloat] + amount <= 1000.0)
				{
					Inventory[playerid][i][pInvQFloat] += amount;
					SaveUser_Inventory(playerid);
					return i;
				}
			} else if (!split) {
				if (Inventory[playerid][i][pInvQFloat] + f_amount <= 1000.0 && Inventory[playerid][i][pInvItem] == itemid && inventory_items[itemid][itemSplit] == 1) {
					Inventory[playerid][i][pInvQFloat] += f_amount;
					SaveUser_Inventory(playerid);
					return i;
				}
			}
			
			if (Inventory[playerid][i][pInvItem] != 0) continue;

			Inventory[playerid][i][pInvItem] 	= itemid;
			Inventory[playerid][i][pInvQ]		= amount;
			Inventory[playerid][i][pInvQFloat]	= f_amount;
			Inventory[playerid][i][pInvEx]		= ex;
			Inventory[playerid][i][pInvS]		= serial;
			format(Inventory[playerid][i][pInvName], 16, "%s", name);

			SaveUser_Inventory(playerid);
			return i;
		}

	} else { // INTEGER
		if (amount < 0 || amount > 1000)	return -1;

		for(new i = 0; i < MAX_INV_SLOTS; i++) 
		{
			if (Inventory[playerid][i][pInvQ] + amount <= 1000 && Inventory[playerid][i][pInvItem] == itemid && inventory_items[itemid][itemSplit] == 1)
			{
				Inventory[playerid][i][pInvQ] += amount;
				SaveUser_Inventory(playerid);
				return i;
			}

			if (Inventory[playerid][i][pInvItem] != 0) continue;

			Inventory[playerid][i][pInvItem] 	= itemid;
			Inventory[playerid][i][pInvQ]		= amount;
			Inventory[playerid][i][pInvQFloat]	= f_amount;
			Inventory[playerid][i][pInvEx]		= ex;
			Inventory[playerid][i][pInvS]		= serial;
			format(Inventory[playerid][i][pInvName], 16, "%s", name);

			if (GetWeaponType(Inventory[playerid][i][pInvItem]) != -1) CallRemoteFunction("LoadHolsters","i",playerid);

			SaveUser_Inventory(playerid);
			return i; // Возвращает слот, в который положили объект
		}
	}

	return -1;
}

stock RemovePlayerInvItem(playerid, itemid, amount = 0, Float:f_amount = 0.0, slot = -1)
{
	//SM1(playerid, "playerid = %i, itemid = %i, amount = %i, Float:f_amount = %i, slot = %i", playerid, itemid, amount, f_amount, slot);
	
	if (slot == -1) 
	{
		for(new i = 0; i < MAX_INV_SLOTS; i++)
		{
			if (Inventory[playerid][i][pInvItem] == itemid)
			{
				if (amount == 0 && f_amount == 0.0) RemoveItem(playerid, i);
				else 
				{
					if (inventory_items[itemid][itemFloat]) if (Inventory[playerid][i][pInvQFloat] > 1 && Inventory[playerid][i][pInvQFloat] - f_amount > 0.0) Inventory[playerid][i][pInvQFloat] = Inventory[playerid][i][pInvQFloat] - f_amount;
					else if (Inventory[playerid][i][pInvQ] > 1 && Inventory[playerid][i][pInvQ] - amount > 0) Inventory[playerid][i][pInvQ] = Inventory[playerid][i][pInvQ] - amount;
					else RemoveItem(playerid, i);
				}

				FixInv(playerid);
				CallRemoteFunction("LoadHolsters","i",playerid);
				SaveUser_Inventory(playerid);
				return 1; 
			}
		}
	} 
	else if (Inventory[playerid][slot][pInvItem] == itemid) 
	{
		if (amount == 0 && f_amount == 0.0) RemoveItem(playerid, slot);
		else {
			if (inventory_items[itemid][itemFloat]) if (Inventory[playerid][slot][pInvQFloat] >= 0.0 && Inventory[playerid][slot][pInvQFloat] - f_amount > 0.0) Inventory[playerid][slot][pInvQFloat] = Inventory[playerid][slot][pInvQFloat] - f_amount;
			else if (Inventory[playerid][slot][pInvQ] >= 0 && Inventory[playerid][slot][pInvQ] - amount > 0) Inventory[playerid][slot][pInvQ] = Inventory[playerid][slot][pInvQ] - amount;
			else RemoveItem(playerid, slot);
		}

		FixInv(playerid);
		CallRemoteFunction("LoadHolsters","i",playerid);
		SaveUser_Inventory(playerid);
		return 1;
	}
	return 0;
}

stock GiveInvItem(playerid = -1, itemid = 0, amount = 0, ex = 0, serial = 0, name[] = EOS, split = 0) {
	return GivePlayerInvItem(playerid, itemid, amount, 0.0, ex, serial, name, split);
}

stock GiveDrugInvItem(playerid, name[], Float:f_amount, ex = 0, serial = 0) {
	return GivePlayerInvItem(playerid, INV_DRUG, 0, f_amount, ex, serial, name);
}
	
stock GiveFloatInvItem(playerid, itemid, Float:f_amount, ex = 0, serial = 0, name[] = EOS, split = 0) {
	return GivePlayerInvItem(playerid, itemid, 0, f_amount, ex, serial, name, split);
}

stock RemoveInvItem(playerid, itemid, amount = 0, slot = -1) {
	return RemovePlayerInvItem(playerid, itemid, amount, 0.0, slot);
}	
stock RemoveFloatInvItem(playerid, itemid, Float:amount = 0.0, slot = -1) {
	return RemovePlayerInvItem(playerid, itemid, 0, amount, slot);
}

stock CheckInv(playerid)
{
    for(new i = 0; i < MAX_INV_SLOTS; i++) if (Inventory[playerid][i][pInvItem] == 0) return 1;
	return 0;
}

stock GetInvNextSlot(playerid)
{
    for(new i = 0; i < MAX_INV_SLOTS; i++) if (Inventory[playerid][i][pInvItem] == 0) return i;
	return -1;
}

stock PrintIid(InvItem)
{
    for(new i = 0; i < sizeof(inventory_items); i++) if (inventory_items[i][itemID] == InvItem) return inventory_items[i][itemModel];
	return -1;
}

stock FixInv(playerid) 
{
	SetPVarInt(playerid, #pDelay, 1);
	new lastPrim = PlayerInfo[playerid][pLastPrim], 
		lastSec = PlayerInfo[playerid][pLastSec], 
		lastMelee = PlayerInfo[playerid][pLastMelee];

	for(new i = 0; i < MAX_INV_SLOTS; i++) 
	{
		if (Inventory[playerid][i][pInvItem] == 0 && i != (MAX_INV_SLOTS - 1)) 
		{
			new i2 = i + 1;
			Inventory[playerid][i][pInvItem] 	= Inventory[playerid][i2][pInvItem];
			Inventory[playerid][i][pInvQ] 		= Inventory[playerid][i2][pInvQ];
			Inventory[playerid][i][pInvQFloat] 	= Inventory[playerid][i2][pInvQFloat];
			Inventory[playerid][i][pInvEx] 		= Inventory[playerid][i2][pInvEx];
			Inventory[playerid][i][pInvS] 		= Inventory[playerid][i2][pInvS];
			format(Inventory[playerid][i][pInvName], 16, "%s", Inventory[playerid][i2][pInvName]);

			Inventory[playerid][i2][pInvItem] 	= 0;
			Inventory[playerid][i2][pInvQ]		= 0;
			Inventory[playerid][i2][pInvQFloat] = 0;
			Inventory[playerid][i2][pInvEx] 	= 0;
			Inventory[playerid][i2][pInvS] 		= 0;
			format(Inventory[playerid][i2][pInvName], 16, "%s", Inventory[playerid][i][pInvName]);

			if (lastPrim == i2) 
			{
				PlayerInfo[playerid][pLastPrim] = i;
				SQL_SetInteger("users", "LastPrim", i, PlayerInfo[playerid][pID]);
			} 
			else if (lastSec == i2) 
			{
				PlayerInfo[playerid][pLastSec] = i;
				SQL_SetInteger("users", "LastSec", i, PlayerInfo[playerid][pID]);
			} 
			else if (lastMelee == i2) 
			{
				PlayerInfo[playerid][pLastMelee] = i;
				SQL_SetInteger("users", "LastMelee", i, PlayerInfo[playerid][pID]);
			}
		}
	}
	SetPVarInt(playerid, #pDelay, 0);
	return 1;
}
