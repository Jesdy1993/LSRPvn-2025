CMD:atrash(playerid, params[])
{
	if (!CheckAdmin(playerid, DEVELOPER_LEVEL))	return SendNotAdmin(playerid);

	new option[16], secoption[128];

	if (sscanf(params, "s[16]S()[128]", option, secoption))
	{
		SendHelpMessage(playerid, "/atrash [create / remove / edit / goto]");
		return 1;
	}

	if (CompareStrings(option, "create"))
	{
		new type;

		if (sscanf(secoption, "i", type))    return SendHelpMessage(playerid, "/atrash create [1 - trash can | 2 - garbage container]");
		if (type < 1 || type > 2)		    return SendErrorMessage(playerid, "Production type from 1 to 2.");

        if (GetPlayerInterior(playerid) != 0 ||
            GetPlayerVirtualWorld(playerid) != 0) return SendErrorMessage(playerid, "You must be on the street in the game (0) virtual world.");

        new id = Trash_CheckFreeSlot();
		if (id == -1) return SendErrorMessage(playerid, "The maximum number of trash cans has been reached.");

		GetPlayerPos(playerid, TrashData[id][TrashX], TrashData[id][TrashY], TrashData[id][TrashZ]);
		TrashData[id][TrashX] += 0.5;

        TrashData[id][TrashType] = (type == 1) ? (TYPE_BIN) : (TYPE_DUMPSTER);
       	TrashData[id][TrashLevel] = (TrashData[id][TrashType] == TYPE_BIN) ? 1 : 2;

		new label[64];
        format(label, sizeof(label), "%s", (TrashData[id][TrashType] == TYPE_BIN) ? ("Trash can") : ("Waste container"));
		TrashData[id][TrashLabel] = CreateDynamic3DTextLabel(label, 0x2ECC71FF, TrashData[id][TrashX], TrashData[id][TrashY], TrashData[id][TrashZ]+1.25, 15.0, .testlos = 1);
        
        new trashModel = (TrashData[id][TrashType] == TYPE_DUMPSTER) ? 1344 : 1337;
        TrashData[id][TrashObject] = CreateDynamicObject(trashModel, TrashData[id][TrashX], TrashData[id][TrashY], TrashData[id][TrashZ], 0.0, 0.0, TrashData[id][TrashRZ], 0, 0);

		new query[256];
		mysql_format(dbHandle, query, sizeof(query), "INSERT INTO `trashes` (type,x,y,z,rz) VALUES (%i,%f,%f,%f,%f)", 
            TrashData[id][TrashType],
            TrashData[id][TrashX], TrashData[id][TrashY], TrashData[id][TrashZ], TrashData[id][TrashRZ]
        );
		mysql_tquery(dbHandle, query, "OnTrashInsert", "d", id);

        SetPVarInt(playerid, #edit_trash, id + 1);
		EditDynamicObject(playerid, TrashData[id][TrashObject]);

		SendSyntaxMessage(playerid, "You created trash %s [ ID: %i ].", (TrashData[id][TrashType] == TYPE_BIN)?("can"):("container"), id);
		return 1;
	}

	else if (CompareStrings(option, "remove"))
	{
		new id;
		
		if (sscanf(secoption, "i", id))						        return SendHelpMessage(playerid, "/atrash remove [ID garbage]");
		if (id < 0 || id >= MAX_TRASHES || !TrashData[id][TrashID])	return SendErrorMessage(playerid, "Garbage not found.");

		if (IsValidDynamicObject(TrashData[id][TrashObject]))
		{
			DestroyDynamicObject(TrashData[id][TrashObject]);
			TrashData[id][TrashObject] = INVALID_OBJECT_ID;
		}
        
        if (IsValidDynamic3DTextLabel(TrashData[id][TrashLabel]))
		{
			DestroyDynamic3DTextLabel(TrashData[id][TrashLabel]);
			TrashData[id][TrashLabel] = Text3D:INVALID_3DTEXT_ID;
		}

		new query[128];
		mysql_format(dbHandle, query, sizeof(query), "DELETE FROM `trashes` WHERE `id` = %i", TrashData[id][TrashID]);
		mysql_tquery(dbHandle, query);

		TrashData[id][TrashID] = 0;
		SendAdmMessageToPlayer(playerid, "You removed the garbage [ID: %i].", id);
		return 1;
	}

	else if (CompareStrings(option, "edit"))
	{
		new id;

		if (sscanf(secoption, "d", id))						        return SendHelpMessage(playerid, "/atrash edit [ID garbage]");
		if (id < 0 || id > MAX_TRASHES || !TrashData[id][TrashID])	return SendErrorMessage(playerid, "Garbage not found.");
		if (Trash_Nearest(playerid) != id)						    return SendErrorMessage(playerid, "You should be near the trash can.");

		SetPVarInt(playerid, #edit_trash, id + 1);
		EditDynamicObject(playerid, TrashData[id][TrashObject]);
		return 1;
	}

	else if (CompareStrings(option, "goto"))
	{
		new id;

		if (sscanf(secoption, "i", id))						        return SendHelpMessage(playerid, "/atrash goto [ID garbage]");
		if (id < 0 || id > MAX_TRASHES || !TrashData[id][TrashID])	return SendErrorMessage(playerid, "Garbage not found.");

		SetPlayerPosEx(playerid, TrashData[id][TrashX], TrashData[id][TrashY], TrashData[id][TrashZ]);
		SetWorld(playerid, 0);
		SetInterior(playerid, 0);
		return 1;
	}
	
	else
	{
		SendHelpMessage(playerid, "/atrash [create / remove / edit / goto]");
	}
	return 1;
}

CMD:afactory(playerid, params[])
{
	if (!CheckAdmin(playerid, DEVELOPER_LEVEL))	return SendNotAdmin(playerid);

	new option[16], secoption[128];

	if (sscanf(params, "s[16]S()[128]", option, secoption))
	{
		SendHelpMessage(playerid, "/afactory [create / remove / goto]");
		return 1;
	}

	if (CompareStrings(option, "create"))
	{
		new name[32];

		if (sscanf(secoption, "S()[32]", name))     return SendHelpMessage(playerid, "/afactory create [Name]");
		if (strlen(name) < 4 || strlen(name) > 32)	return SendErrorMessage(playerid, "The maximum number of characters is 32. ");

        if (GetPlayerInterior(playerid) != 0 ||
            GetPlayerVirtualWorld(playerid) != 0) return SendErrorMessage(playerid, "You must be to the street in the game (0) virtual world.");

        new id = Factory_CheckFreeSlot();
		if (id == -1) return SendErrorMessage(playerid, "The maximum number of waste processing plants has been reached.");

		GetPlayerPos(playerid, FactoryData[id][FactoryX], FactoryData[id][FactoryY], FactoryData[id][FactoryZ]);
		format(FactoryData[id][FactoryName], 32, "%s", name);

		new label[256];
        format(label, sizeof(label), "Nha may xu ly chat thai - %s\n\n{FFFFFF}Luong rac tai che hien tai: {F39C12}0", FactoryData[id][FactoryName]);
		FactoryData[id][FactoryLabel] = CreateDynamic3DTextLabel(label, 0x2ECC71FF, FactoryData[id][FactoryX], FactoryData[id][FactoryY], FactoryData[id][FactoryZ] + 0.5, 15.0, .testlos = 1);
		FactoryData[id][FactoryCP] = CreateDynamicCP(FactoryData[id][FactoryX], FactoryData[id][FactoryY], FactoryData[id][FactoryZ], 3.0);

		new query[256];
		mysql_format(dbHandle, query, sizeof(query), "INSERT INTO `factories` (name,x,y,z) VALUES ('%e',%f,%f,%f)", 
            FactoryData[id][FactoryName],
            FactoryData[id][FactoryX], FactoryData[id][FactoryY], FactoryData[id][FactoryZ]
        );
		mysql_tquery(dbHandle, query, "OnFactoryInsert", "d", id);

		SendSyntaxMessage(playerid, "You have created a waste recycling plant '%s' [ ID: %i ].", FactoryData[id][FactoryName], id);
		return 1;
	}

	else if (CompareStrings(option, "remove"))
	{
		new id;
		
		if (sscanf(secoption, "i", id))						                return SendHelpMessage(playerid, "/afactory remove [ID]");
		if (id < 0 || id >= MAX_FACTORIES || !FactoryData[id][FactoryID])	return SendErrorMessage(playerid, "ID not found.");

		if (IsValidDynamicCP(FactoryData[id][FactoryCP]))
		{
			DestroyDynamicCP(FactoryData[id][FactoryCP]);
			FactoryData[id][FactoryCP] = INVALID_OBJECT_ID;
		}
        
        if (IsValidDynamic3DTextLabel(FactoryData[id][FactoryLabel]))
		{
			DestroyDynamic3DTextLabel(FactoryData[id][FactoryLabel]);
			FactoryData[id][FactoryLabel] = Text3D:INVALID_3DTEXT_ID;
		}

		new query[128];
		mysql_format(dbHandle, query, sizeof(query), "DELETE FROM `factories` WHERE `id` = %i", FactoryData[id][FactoryID]);
		mysql_tquery(dbHandle, query);

		
		
        FactoryData[id][FactoryCurrent] = 0;
		FactoryData[id][FactoryID] = 
		
        SendAdmMessageToPlayer(playerid, "You have deleted the waste recycling plant [ID: %i].", FactoryData[id][FactoryID]);
		return 1;
	}

	else if (CompareStrings(option, "goto"))
	{
		new id;

		if (sscanf(secoption, "i", id))						                return SendHelpMessage(playerid, "/afactory goto [ID]");
		if (id < 0 || id >= MAX_FACTORIES || !FactoryData[id][FactoryID])	return SendErrorMessage(playerid, "ID not found.");

		SetPlayerPosEx(playerid, FactoryData[id][FactoryX], FactoryData[id][FactoryY], FactoryData[id][FactoryZ]);
		SetWorld(playerid, 0);
		SetInterior(playerid, 0);
		return 1;
	}
	
	else
	{
		SendHelpMessage(playerid, "/afactory [create / remove / goto]");
	}
	return 1;
}

CMD:aindustry(playerid, params[])
{
	if (!CheckAdmin(playerid, DEVELOPER_LEVEL))	return SendNotAdmin(playerid);

	new option[16], secoption[128];

	if (sscanf(params, "s[16]S()[128]", option, secoption))
	{
		SendHelpMessage(playerid, "/aindustry [create / remove / edit / goto / list]");
		return 1;
	}

	if (CompareStrings(option, "create"))
	{
		new type, name[64], cargoid = -1, product;

		if (sscanf(secoption, "is[64]i", type, name, product)) return SendHelpMessage(playerid, "/aindustry create [0 - raw materials | 1 - production | 2 - ship | 3 - production requirement] [name industry] [product id]");
		
		if (type < 0 || type > 3)					 return SendErrorMessage(playerid, "Production type from 0 to 3. ");
		if (strlen(name) < 4 || strlen(name) > 63)	 return SendErrorMessage(playerid, "The maximum number of characters is 63. ");
		if ((cargoid = GetNextIndustryID()) == -1)	 return SendErrorMessage(playerid, "The maximum number of industry has been reached.");

		GetPlayerPos(playerid, TruckCargo[cargoid][tPosX], TruckCargo[cargoid][tPosY], TruckCargo[cargoid][tPosZ]);

		TruckCargo[cargoid][tType] = type;
		TruckCargo[cargoid][tStorageSize] = 200;
		TruckCargo[cargoid][tProductID] = product;
		TruckCargo[cargoid][tProductAmount] = 
		TruckCargo[cargoid][tPrice] = 
		TruckCargo[cargoid][tStorage] = 
		TruckCargo[cargoid][tPack] = 
		TruckCargo[cargoid][tGps] =
		TruckCargo[cargoid][tLocked] = 0;
		format(TruckCargo[cargoid][tName], 64, "%s", name);

		new mes[128];

		format(mes, sizeof(mes), "[{FFFF00}%s{FFFFFF}]\nStorage %i/%i\nPrice: $%i/units.", truckcargo_product[TruckCargo[cargoid][tProductID]], TruckCargo[cargoid][tStorage], TruckCargo[cargoid][tStorageSize], TruckCargo[cargoid][tPrice]);
		TruckCargo[cargoid][tLabel] = CreateDynamic3DTextLabel(mes, 0xFFFFFFFF, TruckCargo[cargoid][tPosX], TruckCargo[cargoid][tPosY], TruckCargo[cargoid][tPosZ]+0.8, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0, -1, 100.0);
		TruckCargo[cargoid][tPickup] = CreateDynamicPickup(1318, 1, TruckCargo[cargoid][tPosX], TruckCargo[cargoid][tPosY], TruckCargo[cargoid][tPosZ], 0, 0, -1, 100.0);
		TruckCargo[cargoid][tOn] = 1;

		new query[256];
		mysql_format(dbHandle, query, sizeof(query), "INSERT INTO `truck_cargo` (x, y, z, type, name, storage_size, product_id) VALUES (%f, %f, %f, %i, '%e', %i, 200)", TruckCargo[cargoid][tPosX], TruckCargo[cargoid][tPosY], TruckCargo[cargoid][tPosZ], 
		type, name, TruckCargo[cargoid][tProductID]);
		mysql_tquery(dbHandle, query, "OnTruckCargoInsert", "d", cargoid);

		SendSyntaxMessage(playerid, "You have created an enterprise [ Name: %s | ID: %i | Type: %s ].", TruckCargo[cargoid][tName], cargoid, TruckCargo[cargoid][tPack]);
		return 1;
	}

	else if (CompareStrings(option, "remove"))
	{
		new cargoid, query[128];

		if (sscanf(secoption, "i", cargoid))										return SendHelpMessage(playerid, "/aindustry remove [ID industry]");
		if (cargoid < 0 || cargoid >= MAX_TRUCK_CARGO || !TruckCargo[cargoid][tOn])	return SendErrorMessage(playerid, "The company was not found.");

		mysql_format(dbHandle, query, sizeof(query), "DELETE FROM `truck_cargo` WHERE `id` = %i", TruckCargo[cargoid][tID]);
		mysql_tquery(dbHandle, query);

		if (IsValidDynamic3DTextLabel(TruckCargo[cargoid][tLabel]))
		{
			DestroyDynamic3DTextLabel(TruckCargo[cargoid][tLabel]);
			TruckCargo[cargoid][tLabel] = Text3D:INVALID_3DTEXT_ID;
		}
		if (IsValidDynamicPickup(TruckCargo[cargoid][tPickup]))	DestroyDynamicPickup(TruckCargo[cargoid][tPickup]);

		TruckCargo[cargoid][tOn] = 
		TruckCargo[cargoid][tID] = 0;
		SendSyntaxMessage(playerid, "Industry [ID: %i] deleted.", cargoid);
		return 1;
	}

	else if (CompareStrings(option, "edit"))
	{
		new id, parameters[16], arg[112];

		if (sscanf(secoption, "is[12]S()[112]", id, parameters, arg))
		{
			SendHelpMessage(playerid, "/aindustry edit [ID industry] [storage / size / price / unit / group / locked / gps / products]");
			return 1;
		}

		if (id < 0 || id >= MAX_TRUCK_CARGO || !TruckCargo[id][tOn])	return SendErrorMessage(playerid, "Industry not found.");

		new mes[128];

		if (CompareStrings(parameters, "storage"))
		{
			new storage;

			if (sscanf(arg, "i", storage))								return SendHelpMessage(playerid, "/aindustry edit [ID industry] storage [number of products to stock] ");
			if (storage < 0 || storage > TruckCargo[id][tStorageSize])	return SendErrorMessage(playerid, "number of products from 0 to% i.", TruckCargo[id][tStorageSize]);

			TruckCargo[id][tStorage] = storage;
			SQL_SetInteger("truck_cargo", "storage", TruckCargo[id][tStorage], TruckCargo[id][tID]);
			format(mes, sizeof(mes), "[{FFFF00}%s{FFFFFF}]\nStorage %i/%i\nPrice $%i/units.", truckcargo_product[TruckCargo[id][tProductID]], TruckCargo[id][tStorage], TruckCargo[id][tStorageSize], TruckCargo[id][tPrice]);
			UpdateDynamic3DTextLabelText(TruckCargo[id][tLabel], 0xFFFFFFFF, mes);
			SendSyntaxMessage(playerid, "You have changed the number of products to stock [ID: %i] to %i.", id, TruckCargo[id][tStorage]);
			return 1;
		}

		else if (CompareStrings(parameters, "locked"))
		{
			new locked;

			if (sscanf(arg, "i", locked))	return SendHelpMessage(playerid, "/aindustry edit [ID industry] locked [0 - open | 1 - closed] ");
			if (locked < 0 || locked > 1)	return SendErrorMessage (playerid, "Value from 0 to 1.");

			TruckCargo[id][tLocked] = locked;
			SQL_SetInteger("truck_cargo", "locked", TruckCargo[id][tLocked], TruckCargo[id][tID]);
			SendSyntaxMessage(playerid, "You %s Industry [ID: %i].", (!locked) ? ("opened") : ("shut down"), id);
			return 1;
		}

		else if (CompareStrings(parameters, "products"))
		{
			new product;

			if (sscanf(arg, "i", product))	return SendHelpMessage(playerid, "/aindustry edit [ID industry] products [product id] ");
			if (product < 0 || product > 24)	return SendErrorMessage (playerid, "Value from 0 to 24.");

			TruckCargo[id][tProductID] = product;
			SQL_SetInteger("truck_cargo", "product_id", TruckCargo[id][tProductID], TruckCargo[id][tID]);
			format(mes, sizeof(mes), "[{FFFF00}%s{FFFFFF}]\nStorage %i/%i\nPrice $%i/units.", truckcargo_product[TruckCargo[id][tProductID]], TruckCargo[id][tStorage], TruckCargo[id][tStorageSize], TruckCargo[id][tPrice]);
			UpdateDynamic3DTextLabelText(TruckCargo[id][tLabel], 0xFFFFFFFF, mes);
			return 1;
		}

		else if (CompareStrings(parameters, "type"))
		{
			new type;

			if (sscanf(arg, "i", type))	return SendHelpMessage(playerid, "/aindustry edit [ID industry] type [0 - raw materials | 1 - production | 2 - ship | 3 - production requirement] ");
			if (type < 0 || type > 3)	return SendErrorMessage(playerid, "Type from 0 to 3.");

			TruckCargo[id][tType] = type;
			SQL_SetInteger("truck_cargo", "type", TruckCargo[id][tType], TruckCargo[id][tID]);
			SendSyntaxMessage(playerid, "You changed the type industry [ID: %i] to %i.", id, type);
			return 1;
		}
		
		else if (CompareStrings(parameters, "gps"))
		{
			new locked;

			if (sscanf(arg, "i", locked))	return SendHelpMessage(playerid, "/aindustry edit [ID industry] gps [0-hide/1-show]");
			if (locked < 0 || locked > 1)	return SendErrorMessage(playerid, "Value from 0 to 1.");

			TruckCargo[id][tGps] = locked;
			SQL_SetInteger("truck_cargo", "gps", TruckCargo[id][tGps], TruckCargo[id][tID]);
			SendSyntaxMessage(playerid, "You %s Industry [ID: %i] in /tpda.", (!locked) ? ("show") : ("hide"), id);
			return 1;
		}

		else if (CompareStrings(parameters, "size"))
		{
			new size;

			if (sscanf(arg, "i", size))		return SendHelpMessage(playerid, "/aindustry edit [ID industry] size [the size]");
			if (size <= 0 || size > 10000)	return SendErrorMessage(playerid,"Size from 1 to 10000.");

			TruckCargo[id][tStorageSize] = size;
			SQL_SetInteger("truck_cargo", "storage_size", TruckCargo[id][tStorageSize], TruckCargo[id][tID]);
			format(mes, sizeof(mes), "[{FFFF00}%s{FFFFFF}]\nStorage %i/%i\nPrice $%i/units.", truckcargo_product[TruckCargo[id][tProductID]], TruckCargo[id][tStorage], TruckCargo[id][tStorageSize], TruckCargo[id][tPrice]);
        	UpdateDynamic3DTextLabelText(TruckCargo[id][tLabel], 0xFFFFFFFF, mes);
			SendSyntaxMessage(playerid, "You have changed the size of the warehouse [ID: %i] to %i.", id, TruckCargo[id][tStorageSize]);
			return 1;
		}

		else if (CompareStrings(parameters, "price"))
		{
			new price;

			if (sscanf(arg, "i", price))		return SendHelpMessage(playerid, "/aindustry edit [ID industry] price [cost]");
			if (price < 1 || price > 10000)	return SendErrorMessage(playerid, "Cost from $ 1 to $ 10000.");
			
			TruckCargo[id][tPrice] = price;
			SQL_SetInteger("truck_cargo", "price", TruckCargo[id][tPrice], TruckCargo[id][tID]);
			format(mes, sizeof(mes), "[{FFFF00}%s{FFFFFF}]\nStorage %i/%i\nPrice $%i/units.", truckcargo_product[TruckCargo[id][tProductID]], TruckCargo[id][tStorage], TruckCargo[id][tStorageSize], TruckCargo[id][tPrice]);
        	UpdateDynamic3DTextLabelText(TruckCargo[id][tLabel], 0xFFFFFFFF, mes);
			SendSyntaxMessage(playerid, "You have changed the unit cost industry [ID: %i] to $%i.", id, TruckCargo[id][tPrice]);
			return 1;
		}

		else if (CompareStrings(parameters, "unit"))
		{
			new unit;

			if (sscanf(arg, "i", unit))		return SendHelpMessage(playerid, "/aindustry edit [ID enterprises] unit [units per hour]");
			if (unit < -100 || unit > 100)	return SendErrorMessage(playerid, "Value from -100 to 100.");

			TruckCargo[id][tProductAmount] = unit;
			SQL_SetInteger("truck_cargo", "product_amount", TruckCargo[id][tProductAmount], TruckCargo[id][tID]);
			format(mes, sizeof(mes), "[{FFFF00}%s{FFFFFF}]\nStorage %i/%i\nPrice $%i/units.", truckcargo_product[TruckCargo[id][tProductID]], TruckCargo[id][tStorage], TruckCargo[id][tStorageSize], TruckCargo[id][tPrice]);
        	UpdateDynamic3DTextLabelText(TruckCargo[id][tLabel], 0xFFFFFFFF, mes);
			SendSyntaxMessage(playerid, "You have changed the addition of goods per hour at the enterprise [ID: %i] on %i.", id, TruckCargo[id][tProductAmount]);
			return 1;
		}

		else if (CompareStrings(parameters, "group"))
		{
			new pack;

			if (sscanf(arg, "i", pack))	
			{
				SendHelpMessage(playerid, "/aindustry edit [ID industry] group [group]");
				SendSyntaxMessage(playerid, "Current group industry %i.", TruckCargo[id][tPack]);
				return 1;
			}	//�
			if (pack < 0 || pack > MAX_TRUCK_PACK)	return SendErrorMessage(playerid, "Group industry from 0 to %i.", MAX_TRUCK_PACK);

			TruckCargo[id][tPack] = pack;
			SQL_SetInteger("truck_cargo", "pack", TruckCargo[id][tPack], TruckCargo[id][tID]);
			SendSyntaxMessage(playerid, "You changed the group industry [ID: %i] to %i.", id, TruckCargo[id][tPack]);
			return 1;
		}
		
		else 
		{
			SendHelpMessage(playerid, "/aindustry edit [ID industry] [storage / size / price / unit / group / locked / gps]");
			return 1;
		}
	}
	
	else if (CompareStrings(option, "goto"))
	{
		new cargoid;

		if (sscanf(secoption, "i", cargoid))										return SendHelpMessage(playerid, "/aindustry goto [ID industry]");
		if (cargoid < 0 || cargoid >= MAX_TRUCK_CARGO || !TruckCargo[cargoid][tOn])	return SendErrorMessage(playerid, "Company not found.");

		SetPlayerPosEx(playerid, TruckCargo[cargoid][tPosX], TruckCargo[cargoid][tPosY], TruckCargo[cargoid][tPosZ]);
		SetInterior(playerid, 0);
		SetWorld(playerid, 0);
		SendSpecialMessage(playerid, "You teleported to the facility %s [ID: %i].", TruckCargo[cargoid][tName], cargoid);
		return 1;
	}

	else if (CompareStrings(option, "list"))
	{
		pTemp[playerid][pDialogList] = 0;
		DisplayCargoGroups(playerid);
	}
	else if (CompareStrings(option, "products"))
	{
		new dialog_header[64] = "{FFFFFF}Product ID\t{FFFFFF}Name\n", dialog_body[256];
		dialog_body[0] = EOS;

		format(dialog_body, sizeof(dialog_body), "%s0\tFuel\n1\tFood\n2\tDrink\n3\tClothes\n4\tCars\n5\tFurniture\n6\tMeat\n7\tEggs\n8\tMilk\n9\tCereal\n10\tCotton\n11\tDyes\n12\tComponents\n13\tMalt\n14\tMoney\n15\tPaper\n16\tAggregate\n17\tWoods\n18\tGun Powder\n19\tScrap\n20\tSteel\n21\tGuns\n22\tBricks\n23\tAppliances\n24\tFruits", dialog_header);
		Dialog_Show(playerid, None, DIALOG_STYLE_TABLIST_HEADERS, "{FFFFFF}Product types", dialog_body, "Close", "");
	}
	return 1;
}

CMD:payday(playerid, params[])
{
	new userid;
	if (!CheckAdmin(playerid, DEVELOPER_LEVEL))		return SendNotAdmin(playerid);
	if (sscanf(params, "u", userid))		return SendHelpMessage(playerid, "/payday [ID/Part Of Name]");
	if (userid == INVALID_PLAYER_ID)		return SendErrorMessage(playerid, "Player not found. ");
	
	PayDay(userid);
	
	SendAdmMessageToPlayer(userid, "Administrator %s da cho ban PayDay.", GetAccName(playerid));
	SendAdmMessageToPlayer(playerid, "Ban da Payday cho %s.", GetNameEx(userid));
	return 1;
}

CMD:paydayall(playerid, params[])
{
	if (!CheckAdmin(playerid, DEVELOPER_LEVEL))		return SendNotAdmin(playerid);

	for(new i = 0; i < MAX_PLAYERS; i++)
		PayDay(i);
	
	SendAdmMessageToAll("Administrator %s da PayDay cho tat ca nguoi choi.", GetAccName(playerid));
	return 1;
}

CMD:testmsgs(playerid, params[]) 
{
	if (!CheckAdmin(playerid, DEVELOPER_LEVEL))		return SendNotAdmin(playerid);

	new type, str[64];
	if (sscanf(params, "is[64]", type, str))		return SendHelpMessage(playerid, "/testmsgs [type] [txt]");
	if (type < 0 || type > 1)					return 1;

	switch(type)
	{
		case 0: JobMessage(playerid, str, 10);
		case 1: InfoMSG(playerid, str, 10);
	}
	
	return 1;
}

CMD:healnear(playerid, params[])
{
	new Float:radius, Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	if(!CheckAdmin(playerid, ADMIN_LEVEL_3))	return SendNotAdmin(playerid);
	if(sscanf(params, "f", radius))				return SendHelpMessage(playerid, "Usage: /healrange [radius]");
	if(!(1.0 <= radius <= 50.0))				return SendErrorMessage(playerid, "The radius can't be below 1.0 or above 50.0.");

	foreach(new i : Player)
	{
		if(IsPlayerInRangeOfPoint(i, radius, x, y, z))
		{
			SetPlayerHealth(i, 100.0);
		}
	}
	SendNearbyMessage(4.0, playerid, COLOR_WHITE, "INFO:{FFFFFF} %s da hoi mau cho nhung nguoi o khu vuc gan.", GetAccName(playerid));
	return 1;
}

CMD:afklist(playerid, params[])
{
	if (!CheckAdmin(playerid, ADMIN_LEVEL_1))				return SendNotAdmin(playerid);

	foreach(new i : Player)
	{
	    if (IsPlayerAFK(i))
	    {
			SendClientMessageEx(playerid, COLOR_LIGHTRED, "(ID: %i) %s - Thoi gian: %i giay", i, GetAccName(i), pTemp[i][pDarkAFK]-2);
		}
	}
	return 1;
}