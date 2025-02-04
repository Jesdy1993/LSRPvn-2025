ItemDrop_Init()
{
	new query[128];
	mysql_format(dbHandle, query, sizeof(query), "DELETE FROM `drop_items` WHERE dropTime-%i > 24*60*60", gettime());
	mysql_tquery(dbHandle, query);

	mysql_tquery(dbHandle, "SELECT * FROM `drop_items`", "ItemDrop_Load");
	return 1;
}

this::ItemDrop_Load()
{
	new rows = cache_num_rows(), time = GetTickCount(), total;

	if (!rows) return print("[ItemsDrop] No records found.");
	
	for(new i; i < rows; i++)
	{
		ItemDrop[i][dropBDID] = cache_get_field_content_int(i, "id");
		ItemDrop[i][dropID] = cache_get_field_content_int(i, "item");
		ItemDrop[i][dropAmount] = cache_get_field_content_int(i, "amount");
		ItemDrop[i][dropQFloat] = cache_get_field_content_float(i, "a_float");
		cache_get_field_content(i, "dropname", ItemDrop[i][dropInvName], dbHandle, 16);
		ItemDrop[i][dropEx] = cache_get_field_content_int(i, "ex");
		ItemDrop[i][dropS] = cache_get_field_content_int(i, "serial");
        ItemDrop[i][dropPosX] = cache_get_field_content_float(i, "dropPosX"); 
		ItemDrop[i][dropPosY] = cache_get_field_content_float(i, "dropPosY"); 
		ItemDrop[i][dropPosZ] = cache_get_field_content_float(i, "dropPosZ"); 
		ItemDrop[i][dropPosRX] = cache_get_field_content_float(i, "dropPosRX"); 
		ItemDrop[i][dropPosRY] = cache_get_field_content_float(i, "dropPosRY"); 
		ItemDrop[i][dropPosRZ] = cache_get_field_content_float(i, "dropPosRZ"); 
		ItemDrop[i][dropInt] = cache_get_field_content_int(i, "dropInt");
		ItemDrop[i][dropVW] = cache_get_field_content_int(i, "dropVW");
		ItemDrop[i][dropTime] = cache_get_field_content_int(i, "dropTime");

		ItemDrop[i][dropObject] = CreateDynamicObject(inventory_items[ItemDrop[i][dropID]][itemModel], ItemDrop[i][dropPosX], ItemDrop[i][dropPosY], ItemDrop[i][dropPosZ], ItemDrop[i][dropPosRX], ItemDrop[i][dropPosRY], ItemDrop[i][dropPosRZ], ItemDrop[i][dropInt], ItemDrop[i][dropVW]);
	}

	printf("[ItemsDrop] Rows - %i. Load - %i. Time: %i ms.", rows, total, GetTickCount()-time);
	return 1;
}

ItemDrop_Update(i) {
	new query[256];
	mysql_format(dbHandle, query, sizeof(query), "UPDATE `drop_items` SET `dropPosX`=%f,`dropPosY`=%f,`dropPosZ`=%f,`dropPosRX`=%f,`dropPosRY`=%f,`dropPosRZ`=%f WHERE `id` = %i", ItemDrop[i][dropPosX], ItemDrop[i][dropPosY], ItemDrop[i][dropPosZ],ItemDrop[i][dropPosRX], ItemDrop[i][dropPosRY], ItemDrop[i][dropPosRZ], ItemDrop[i][dropBDID]);
	return mysql_tquery(dbHandle, query);
}

DeleteDrop_fromBD(bd_dropid)
{
	new query[128];
	mysql_format(dbHandle, query, sizeof(query), "DELETE FROM `drop_items` WHERE `id` = %i", bd_dropid);
	return mysql_tquery(dbHandle, query);
}		

this::GetIDforItemDrop(i) {
	ItemDrop[i][dropBDID] = cache_insert_id();
	return 1;
}

ItemDrop_Drop(playerid, item, amount, Float:a_float = 0.0, ex = 0, serial = 0, name[] = EOS)
{
	if (GetPVarInt(playerid, #pDelay)) return -1;

	SetPVarInt(playerid, #pDelay, 1);
	for(new i; i != MAX_ITEM_DROPS; i++)
	{
	    if (ItemDrop[i][dropID] != 0) continue;
    
  		ItemDrop[i][dropID] = item;
		ItemDrop[i][dropAmount] = amount;
		ItemDrop[i][dropQFloat] = a_float;
		ItemDrop[i][dropEx] = ex;
		ItemDrop[i][dropS] = serial;
		format(ItemDrop[i][dropInvName], 16, "%s", name);

        GetXYInFrontOfPlayer(playerid, ItemDrop[i][dropPosX], ItemDrop[i][dropPosY], ItemDrop[i][dropPosZ], 1.5);
		ItemDrop[i][dropPosZ] -= 1.0;
		ItemDrop[i][dropInt] = GetInterior(playerid);
		ItemDrop[i][dropVW] = GetWorld(playerid);
		ItemDrop[i][dropTime] = gettime();

		new mes[128], drop_name[32] = "money", drop_model = 1212;
		    
		if (item != 9999)
		{
		    format(drop_name, sizeof(drop_name), inventory_items[item][itemName]);
            drop_model = inventory_items[item][itemModel];
		}

		format(mes, sizeof(mes), "vut %s xuong dat.", drop_name);
		SetPlayerChatBubble(playerid, mes, COLOR_PURPLE, 20.0, 4000);
		
		ItemDrop[i][dropObject] = CreateDynamicObject(drop_model, ItemDrop[i][dropPosX], ItemDrop[i][dropPosY], ItemDrop[i][dropPosZ], 93.7, 120.0, 120.0, GetWorld(playerid), GetInterior(playerid));
		EditDynamicObject(playerid, ItemDrop[i][dropObject]);
		SetPVarInt(playerid, #edit_item, i+1);

    	new query[350];
		if (ValidWeaponForInventory(drop_model))
		{
		    format(query, sizeof(query), "%s [MYSQL: %i | IP: %s] threw on the ground %e (amount: %i)",
			GetName(playerid), PlayerInfo[playerid][pID], q_GetPlayerIP(playerid), drop_name, amount);
		 	insert_log(query, WEAPON_LOG, 3, PlayerInfo[playerid][pAccID], 0);
		}
		else
		{
		    format(query, sizeof(query), "%s [MYSQL: %i | IP: %s] threw on the ground %e (amount: %i)",
			GetName(playerid), PlayerInfo[playerid][pID], q_GetPlayerIP(playerid), drop_name, amount);
		 	insert_log(query, ITEM_LOG, 1, PlayerInfo[playerid][pAccID], 0);
		}

		mysql_format(dbHandle, query, sizeof(query), 
			"INSERT INTO `drop_items` (`item`,`amount`,`a_float`,`dropname`,`ex`,`serial`,`dropPosX`,`dropPosY`,`dropPosZ`,`dropPosRX`,`dropPosRY`,`dropPosRZ`,`dropInt`,`dropVW`,`dropTime`) VALUES (%i,%i,%f,'%e',%i,%i,%f,%f,%f,%f,%f,%f,%i,%i,%i)",
			ItemDrop[i][dropID],
			ItemDrop[i][dropAmount],
			ItemDrop[i][dropQFloat],
			ItemDrop[i][dropEx],
			ItemDrop[i][dropInvName],
			ItemDrop[i][dropS],
			ItemDrop[i][dropPosX], ItemDrop[i][dropPosY], ItemDrop[i][dropPosZ],
			ItemDrop[i][dropPosRX], ItemDrop[i][dropPosRY], ItemDrop[i][dropPosRZ],
			ItemDrop[i][dropInt],
			ItemDrop[i][dropVW],
			ItemDrop[i][dropTime]
		);
		mysql_tquery(dbHandle, query, "GetIDforItemDrop", "d", i);		

		FixInv(playerid);
		SetPVarInt(playerid, #pDelay, 0);
  		return i;
	}
	SetPVarInt(playerid, #pDelay, 0);
	return -1;
}

ItemDrop_Pickup(playerid, dropid)
{
	if (ItemDrop[dropid][dropID] == 0) return 1;
	if (GetPVarInt(playerid, #pDelay)) return 1;
	
	SetPVarInt(playerid, #pDelay, 1);

	new item = ItemDrop[dropid][dropID];
	
	if (item == 9999) GiveCash(playerid, ItemDrop[dropid][dropAmount]);
	else 
	{
		if (GivePlayerInvItem(playerid, item, ItemDrop[dropid][dropAmount], ItemDrop[dropid][dropQFloat], ItemDrop[dropid][dropEx], ItemDrop[dropid][dropS], ItemDrop[dropid][dropInvName]) == -1) {		
			SetPVarInt(playerid, #pDelay, 0);
			return SendErrorMessage(playerid, "Tui do da day.");
		}

		if (inventory_items[item][itemType] == ITEM_TYPE_WEAPON)
		{
			/*if (PlayerInfo[playerid][pOnDuty] && PlayerInfo[playerid][pFaction] == LSPD) 
			{		
				SetPVarInt(playerid, #pDelay, 0);
				return SendErrorMessage(playerid, "¬ы не можете подн€ть оружие, наход€сь на дежурстве.");
			}*/
			//if (PlayerInfo[playerid][pJailed] || 
			if (PlayerInfo[playerid][pAJailed])	
			{		
				SetPVarInt(playerid, #pDelay, 0);
				return SendErrorMessage(playerid,"Ban khong the nhat vu khi khi dang o trong tu.");
			}
			
			if (ItemDrop[dropid][dropAmount])	SM2(playerid, "Ban da nhat %s [%s / %i round].", inventory_items[item][itemName], inventory_items[ItemDrop[dropid][dropEx]][itemName], ItemDrop[dropid][dropAmount]);
			else								SM2(playerid, "Ban da nhat %s [trong].", inventory_items[item][itemName]);
		}
		else 									SM2(playerid, "Ban da nhat %s.", inventory_items[item][itemName]);
	}

    new mes[128], drop_name[32] = "money";

	if (item != 9999) format(drop_name, sizeof(drop_name), inventory_items[item][itemName]);
	format(mes, sizeof(mes), "* %s tang %s.", GetNameWithMask(playerid), drop_name);
	SetPlayerChatBubble(playerid, mes, COLOR_PURPLE, Range_Normal, 10000);

    new query[128];
	if (ValidWeaponForInventory(item))
	{
	    format(query, sizeof(query), "%s [MYSQL: %i | IP: %s] picked up from the ground %e (amount: %i)",
		GetName(playerid), PlayerInfo[playerid][pID], q_GetPlayerIP(playerid), drop_name, ItemDrop[dropid][dropAmount]);
	 	insert_log(query, WEAPON_LOG, 4, PlayerInfo[playerid][pAccID]);
	}
	else
	{
	    format(query, sizeof(query), "%s [MYSQL: %i | IP: %s] picked up from the ground %e (amount: %i)",
		GetName(playerid), PlayerInfo[playerid][pID], q_GetPlayerIP(playerid), drop_name, ItemDrop[dropid][dropAmount]);
	 	insert_log(query, ITEM_LOG, 2, PlayerInfo[playerid][pAccID]);
	}
	
	ItemDrop_Delete(dropid);
	SetPVarInt(playerid, #pDelay, 0);
	return 1;
}

ItemDrop_Delete(dropid)
{
	if (ItemDrop[dropid][dropID] == 0) return 1;
	if (IsValidDynamicObject(ItemDrop[dropid][dropObject])) DestroyDynamicObject(ItemDrop[dropid][dropObject]);

	DeleteDrop_fromBD(ItemDrop[dropid][dropBDID]);

	ItemDrop[dropid][dropBDID] =
	ItemDrop[dropid][dropID] =
	ItemDrop[dropid][dropAmount] = 0;
	ItemDrop[dropid][dropPosX] =
	ItemDrop[dropid][dropPosY] =
	ItemDrop[dropid][dropPosZ] = 0.0;
	ItemDrop[dropid][dropInvName] = EOS;
	return 1;
}

ItemDrop_Nearest(playerid)
{
	for(new i; i != MAX_ITEM_DROPS; i++)
	{
	    if (ItemDrop[i][dropID] == 0) continue;
		if (IsPlayerInRangeOfPoint(playerid, 1.5, ItemDrop[i][dropPosX], ItemDrop[i][dropPosY], ItemDrop[i][dropPosZ]) && GetWorld(playerid) == ItemDrop[i][dropVW] && GetInterior(playerid) == ItemDrop[i][dropInt]) return i;
	}
	return -1;
}

MixDrop_Nearest(playerid)
{
	for(new i; i != MAX_CHEM_DROPS; i++)
	{
		if (DropChemistry[i][temp_ID] == 0) continue;
		if (IsPlayerInRangeOfPoint(playerid, 1.5, DropChemistry[i][dropPosX], DropChemistry[i][dropPosY], DropChemistry[i][dropPosZ]) && GetWorld(playerid) == DropChemistry[i][dropVW] && GetInterior(playerid) == DropChemistry[i][dropInt]) {
			return i;
		}
	}
	return -1;
}

DropFood_Nearest(playerid)
{
	for(new i; i != MAX_FOOD_DROPS; i++)
	{
	    if (FoodDrop[i][foodDropped] == 0) continue;
		if (IsPlayerInRangeOfPoint(playerid, 2.0, FoodDrop[i][foodPosX], FoodDrop[i][foodPosY], FoodDrop[i][foodPosZ]) && FoodDrop[i][foodInt] == GetInterior(playerid) && FoodDrop[i][foodVW] == GetWorld(playerid)) return i;
	}
	return -1;
}