ChemistryDrop_Init()
{
	new query[128];
	mysql_format(dbHandle, query, sizeof(query), "DELETE FROM `drop_chemistry` WHERE dropTime-%i > 24*60*60", gettime());
	mysql_tquery(dbHandle, query);

	mysql_tquery(dbHandle, "SELECT * FROM `drop_chemistry`", "ChemistryDrop_Load");
	return 1;
}

this::ChemistryDrop_Load()
{
	new rows = cache_num_rows(), time = GetTickCount(), total;

	if (!rows) return print("[ChemistryDrop] Khong co du lieu duoc tim thay.");
	
	for(new i; i < rows; i++)
	{
		DropChemistry[i][temp_ID] = cache_get_field_content_int(i, "id", dbHandle);
		DropChemistry[i][Material] = cache_get_field_content_int(i, "Material", dbHandle);
		DropChemistry[i][Type] = cache_get_field_content_int(i, "Type", dbHandle);
		DropChemistry[i][Amount] = cache_get_field_content_float(i, "Amount", dbHandle); 
		DropChemistry[i][Quality] = cache_get_field_content_float(i, "Quality", dbHandle); 
		DropChemistry[i][Extra][0] = cache_get_field_content_int(i, "Extra0", dbHandle);
		DropChemistry[i][Extra][1] = cache_get_field_content_int(i, "Extra1", dbHandle);
		DropChemistry[i][Extra][2] = cache_get_field_content_int(i, "Extra2", dbHandle);
        DropChemistry[i][dropPosX] = cache_get_field_content_float(i, "dropPosX", dbHandle); 
		DropChemistry[i][dropPosY] = cache_get_field_content_float(i, "dropPosY", dbHandle); 
		DropChemistry[i][dropPosZ] = cache_get_field_content_float(i, "dropPosZ", dbHandle); 
		DropChemistry[i][dropPosRX] = cache_get_field_content_float(i, "dropPosRX", dbHandle); 
		DropChemistry[i][dropPosRY] = cache_get_field_content_float(i, "dropPosRY", dbHandle); 
		DropChemistry[i][dropPosRZ] = cache_get_field_content_float(i, "dropPosRZ", dbHandle); 
		DropChemistry[i][dropInt] = cache_get_field_content_int(i, "dropInt", dbHandle);
		DropChemistry[i][dropVW] = cache_get_field_content_int(i, "dropVW", dbHandle);
		DropChemistry[i][dropTime] = cache_get_field_content_int(i, "dropTime", dbHandle);

		DropChemistry[i][dropObject] = CreateDynamicObject(1575, DropChemistry[i][dropPosX], DropChemistry[i][dropPosY], DropChemistry[i][dropPosZ], DropChemistry[i][dropPosRX], DropChemistry[i][dropPosRY], DropChemistry[i][dropPosRZ], DropChemistry[i][dropInt], DropChemistry[i][dropVW]);
	}

	printf("[ChemistryDrop] Rows - %i. Load - %i. Time: %i ms.", rows, total, GetTickCount()-time);
	return 1;
}

ChemistryDrop_Update(i) {
	GetDynamicObjectPos(DropChemistry[i][dropObject], DropChemistry[i][dropPosX], DropChemistry[i][dropPosY], DropChemistry[i][dropPosZ]);
    GetDynamicObjectRot(DropChemistry[i][dropObject], DropChemistry[i][dropPosRX], DropChemistry[i][dropPosRY], DropChemistry[i][dropPosRZ]);

	new query[256];
	mysql_format(dbHandle, query, sizeof(query), "UPDATE `drop_chemistry` SET `dropPosX`=%f,`dropPosY`=%f,`dropPosZ`=%f,`dropPosRX`=%f,`dropPosRY`=%f,`dropPosRZ`=%f WHERE `id` = %i", DropChemistry[i][dropPosX], DropChemistry[i][dropPosY], DropChemistry[i][dropPosZ],DropChemistry[i][dropPosRX], DropChemistry[i][dropPosRY], DropChemistry[i][dropPosRZ],DropChemistry[i][temp_ID]);
	return mysql_tquery(dbHandle, query);
}

DeleteChemistry_fromBD(bd_dropid)
{
	new query[128];
	mysql_format(dbHandle, query, sizeof(query), "DELETE FROM `drop_chemistry` WHERE `id` = %i", bd_dropid);
	return mysql_tquery(dbHandle, query);
}		

this::GetIDforChemistryDrop(i) {
	DropChemistry[i][temp_ID] = cache_insert_id();
	return 1;
}

DropChemistry_Delete(dropid)
{
	//if (DropChemistry[dropid][dropID] == 0) return 1;
	DestroyDynamicObject(DropChemistry[dropid][dropObject]);

	DropChemistry[dropid][Material] = 0;
	DropChemistry[dropid][Type] = 0;
	DropChemistry[dropid][Amount] = 0.0;
	DropChemistry[dropid][Quality] = 0.0;
	DropChemistry[dropid][Extra][0] = 0;
	DropChemistry[dropid][Extra][1] = 0;
	DropChemistry[dropid][Extra][2] = 0;
	DropChemistry[dropid][dropInt] = 0;
	DropChemistry[dropid][dropVW] = 0;
	DropChemistry[dropid][dropTime] = 0;

	DeleteChemistry_fromBD(DropChemistry[dropid][temp_ID]);
	DropChemistry[dropid][temp_ID] = 0;
	return 1;
}

Chemistry_Init()
{
	mysql_tquery(dbHandle, "SELECT * FROM `chemistry`", "Chemistry_Load");
	return 1;
}

this::Chemistry_Load()
{
	new rows = cache_num_rows(), time = GetTickCount(), total;

	if (!rows) return print("[Chemistry] Khong co du lieu duoc tim thay.");

	for(new i; i < rows; i++)
	{
		Chemistry[i][temp_ID] = 1;
		Chemistry[i][BuildingID] = cache_get_field_content_int(i, "building", dbHandle);
		Chemistry[i][BuildingType] = cache_get_field_content_int(i, "buildingtype", dbHandle);
		Chemistry[i][FurnID] = cache_get_field_content_int(i, "furnid", dbHandle);
		Chemistry[i][IsWorking] = bool:cache_get_field_content_int(i, "isworking", dbHandle); 
		Chemistry[i][WorkType] = cache_get_field_content_int(i, "worktype", dbHandle);
		Chemistry[i][NeedTime] = cache_get_field_content_int(i, "time", dbHandle);
		Chemistry[i][Material] = cache_get_field_content_int(i, "material", dbHandle);
		Chemistry[i][Amount] = cache_get_field_content_float(i, "amount", dbHandle); 
		Chemistry[i][Quality] = cache_get_field_content_float(i, "quality", dbHandle); 
		Chemistry[i][Type] = cache_get_field_content_int(i, "type", dbHandle);
		Chemistry[i][Extra][0] = cache_get_field_content_int(i, "extra0", dbHandle);
		Chemistry[i][Extra][1] = cache_get_field_content_int(i, "extra1", dbHandle);
		Chemistry[i][Extra][2] = cache_get_field_content_int(i, "extra2", dbHandle);
		Chemistry[i][Temperature] = cache_get_field_content_float(i, "temperature", dbHandle); 
		Chemistry[i][curTemperature] = cache_get_field_content_float(i, "curTemperature", dbHandle); 
		Chemistry[i][Degree] = cache_get_field_content_float(i, "degree", dbHandle);
		Chemistry[i][Control] = cache_get_field_content_int(i, "control", dbHandle);
		Chemistry[i][BeingCrystal] = cache_get_field_content_int(i, "ready", dbHandle);

		switch(Chemistry[i][WorkType]) {
			case 1..2: 	StartMixingDrug(i, Chemistry[i][NeedTime]+1, Chemistry[i][Amount], Chemistry[i][Quality], Chemistry[i][Type], Chemistry[i][Extra][2]);
			case 3:		ReactDrug(i, Chemistry[i][Material], Chemistry[i][Amount], Chemistry[i][Quality], Chemistry[i][Extra][0], Chemistry[i][Extra][1], Chemistry[i][Extra][2], Chemistry[i][Type], Chemistry[i][BuildingType], Chemistry[i][BuildingID], Chemistry[i][FurnID]);
		}
	}

	printf("[Chemistry] Rows - %i. Load - %i. Time: %i ms.", rows, total, GetTickCount()-time);
	mysql_tquery(dbHandle, "DELETE FROM `chemistry`");
	return 1;
}

ChemistrySave()
{
	for(new i; i < MAX_CHEMISTRY; i++) 
	{
		if (Chemistry[i][temp_ID] != 0) continue;
		
		new query[400];
		mysql_format(dbHandle, query, sizeof(query), 
			"INSERT INTO `chemistry` (`building`,`buildingtype`,`furnid`,`isworking`,`worktype`,`time`,`material`,`Type`,`Amount`,`Quality`,`Extra0`,`Extra1`,`Extra2`,`temperature`,`curTemperature`,`degree`,`control`,`ready`) VALUES (%i,%i,%i,%i,%i,%i,%i,%f,%f,%i,%i,%i,%i,%f,%f,%f,%i,%i)",
			Chemistry[i][BuildingID],
			Chemistry[i][BuildingType],
			Chemistry[i][FurnID],
			Chemistry[i][IsWorking],
			Chemistry[i][WorkType],
			Chemistry[i][NeedTime],
			Chemistry[i][Material],
			Chemistry[i][Type],
			Chemistry[i][Amount],
			Chemistry[i][Quality],
			Chemistry[i][Extra][0], Chemistry[i][Extra][1], Chemistry[i][Extra][2],
			Chemistry[i][Temperature],
			Chemistry[i][curTemperature],
			Chemistry[i][Degree],
			Chemistry[i][Control],
			Chemistry[i][BeingCrystal]
		);
		mysql_tquery(dbHandle, query);
	}
	return 1;
}

this::LoadDynamicPlants()
{
    new rows = cache_num_rows(), gTime = GetTickCount(), total;

	if (!rows)	return print("[Plants] Khong co du lieu duoc tim thay.");

	for (new i = 0; i < rows; i++)
	{
	    CropsInfo[i][pID] = cache_get_field_content_int(i, "id", dbHandle);
		CropsInfo[i][pType] = cache_get_field_content_int(i, "type", dbHandle);
		cache_get_field_content(i, "planter", CropsInfo[i][pPlanter], dbHandle, 52);
		CropsInfo[i][pGrowTime] = cache_get_field_content_int(i, "growtime", dbHandle);
		CropsInfo[i][pStartTime] = cache_get_field_content_int(i, "starttime", dbHandle);
		CropsInfo[i][pX] = cache_get_field_content_float(i, "posx", dbHandle);
		CropsInfo[i][pY] = cache_get_field_content_float(i, "posy", dbHandle);
		CropsInfo[i][pZ] = cache_get_field_content_float(i, "posz", dbHandle);
	    CropsInfo[i][pInt] = cache_get_field_content_int(i, "interior", dbHandle);
	    CropsInfo[i][pVW] = cache_get_field_content_int(i, "vw", dbHandle);
		cache_get_field_content(i, "c_date", CropsInfo[i][pPlantDate], dbHandle, 64);
		CropsInfo[i][pPlanted] = 1;

		CropsInfo[i][pObject] =	CreateDynamicObject(19473, CropsInfo[i][pX], CropsInfo[i][pY], CropsInfo[i][pZ], 0.0, 0.0, 0.0, CropsInfo[i][pVW], CropsInfo[i][pInt], -1, 200.0);
		
		new drugname[16];

		switch(CropsInfo[i][pType])
		{
			case 1: format(drugname, sizeof(drugname), "can sa");
			case 2: format(drugname, sizeof(drugname), "coca");
			case 3: format(drugname, sizeof(drugname), "thuoc phien");
		}
		
		if (CropsInfo[i][pGrowTime] - gettime() > CropsInfo[i][pStartTime])
		{
			static const str_size[] = "Cay %s\n{FF6347}Da phat trien";
			new mes[sizeof(str_size) + 16];

			format(mes, sizeof(mes), str_size, drugname);
			CropsInfo[i][pLabel] = CreateDynamic3DTextLabel(mes, -1, CropsInfo[i][pX], CropsInfo[i][pY], CropsInfo[i][pZ]+1.0, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, CropsInfo[i][pVW], CropsInfo[i][pInt], -1, 100.0);
		}
		else
		{
			static const str_size[] = "Cay %s\n{FF6347}%.0f%%";
			new mes[sizeof(str_size) + 16];

			new time = CropsInfo[i][pGrowTime] - gettime();

			format(mes, sizeof(mes), str_size, drugname, 100.0 - (float(time) / float(CropsInfo[i][pStartTime])) * 100.0);
			CropsInfo[i][pLabel] = CreateDynamic3DTextLabel(mes, -1, CropsInfo[i][pX], CropsInfo[i][pY], CropsInfo[i][pZ]+1.0, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, CropsInfo[i][pVW], CropsInfo[i][pInt], -1, 100.0);
		}

		total++;
	}

	printf("[Plants] Rows - %i. Load - %i. Time: %i ms.", rows, total, GetTickCount()-gTime);
	return 1;
}

GetFreeChemistyIndex()
{
	for(new i; i != MAX_CHEMISTRY; i++)
	{
	    if (Chemistry[i][temp_ID] != 0) continue;
		return i;
	}
	return -1;
}

UseDrug(playerid, item, slotid)
{
    //PlayerTextDrawHide(playerid, drug_effect[playerid]);
	SetPlayerCurrentTimeAndWeather(playerid);
    pTemp[playerid][pDrugUse] = item;

    RemoveFloatInvItem(playerid, item, 0.1, slotid);

	 
	static const str_size[] = "used drugs \"%s\"";
	new mes[sizeof(str_size) - 2 + 32 + 1];


    if (pTemp[playerid][pDrugUse] == 0)
    {
    	new Float: health;
    	AntiCheatGetHealth(playerid, health);

		switch(item)
		{
		    case INV_GANJA, INV_MED_GANJA: 	health += 5.0;
		}
		SetPlayerHealth(playerid, health);
	}
	
	if (item == INV_GANJA || item == INV_MED_GANJA)
	{
	    InfoMSG(playerid, "Nhan \"~g~LMB~w~\" de su dung. Nhan \" ~r~ENTER ~w~\" de hoan thanh", 8);
		
	    SetPVarInt(playerid, #use_ganja, 5);
		SetPVarInt(playerid, #time_ganja, gettime());
		SetPlayerAttachedObject(playerid, ATTACH_HANDS, 3027, 6, 0.109999, 0.011000, 0.003999, 69.000007, 46.699989, 0.000000, 1.000000, 1.000000, 1.000000);
	    pTemp[playerid][pDrugTime] = gettime() + 120;
	    PlayerInfo[playerid][pDemolition] = 3600 + 600 + random(1200);
	    SetPlayerDrunkLevel(playerid, 5000);
        SendWarningMessage(playerid, "Ban da su dung %s [+5 HP].", inventory_items[item][itemName]);

		format(mes, sizeof(mes), str_size, inventory_items[item][itemName]);

		new Float: health;
    	AntiCheatGetHealth(playerid, health);
		health += 5.0;
		SetPlayerHealth(playerid, health);

	}
	else if (item == INV_DRUG)
	{
		new Float: health, Float: oldhealth;
    	AntiCheatGetHealth(playerid, oldhealth);
		health = oldhealth;

		new zav;
		if (Inventory[playerid][slotid][pInvEx] < 10) {
			if (health > 15.0) health -= (15-Inventory[playerid][slotid][pInvEx]);
			pTemp[playerid][pDrugTime] = Inventory[playerid][slotid][pInvEx]*10;

			zav = floatround(Inventory[playerid][slotid][pInvEx]);
	   		PlayerInfo[playerid][pDependence] += zav;
		} else {
			health += Inventory[playerid][slotid][pInvEx];
			pTemp[playerid][pDrugTime] = Inventory[playerid][slotid][pInvEx]*5;

			zav = floatround(0.1*Inventory[playerid][slotid][pInvEx]);
	   		PlayerInfo[playerid][pDependence] += zav;
		}	    

		PlayerInfo[playerid][pDemolition] = 5400 + 600 + random(1200);
	    pTemp[playerid][pDrugChgWeather] = gettime() + 4;		

		SetPlayerCameraEffect(playerid, pTemp[playerid][pDrugTime]);

		if (PlayerInfo[playerid][pDependence] > 100) PlayerInfo[playerid][pDependence] = 100;

		format(mes, sizeof(mes), str_size, Inventory[playerid][slotid][pInvName]);

        SendWarningMessage(playerid, "Ban da su dung %s [%s%f HP | +%i phu thuoc].", Inventory[playerid][slotid][pInvName], (health-oldhealth > 0.0)?("+"):(""), health-oldhealth, zav);
		//(health-oldhealth == 0.0)?(""):((health-oldhealth > 0.0)?("+"):("-"))
		SetPlayerHealth(playerid, health);
	}

    pTemp[playerid][pDemolitionTime] = 0;
	SetPlayerChatBubble(playerid, mes, COLOR_PURPLE, 20.0, 4000);
	return 1;
}

Plant_Nearest(playerid, Float: radius = 2.5)
{
	for(new i; i != MAX_PLANTS; i++)
	{
	    if (CropsInfo[i][pPlanted] == 0) continue;
        if (IsPlayerInRangeOfPoint(playerid, radius, CropsInfo[i][pX], CropsInfo[i][pY], CropsInfo[i][pZ]) && CropsInfo[i][pInt] == GetInterior(playerid) && CropsInfo[i][pVW] == GetWorld(playerid)) return i;
	}
	return -1;
}

CreateCrop(playerid, type = 0)
{
	/*
	����:
		�������� 	= 1
		���� 		= 2
		���			= 3
	*/

    UnFreezePlayer(playerid);
	StopPlayerAnims(playerid);

	if (type == 0)	return 1;

	switch(type)
	{
		case 1: if (!IsPlayerHasItem(playerid, INV_SEED_GANJA)) 	return SendErrorMessage(playerid, "Ban khong co hat giong can sa.");
		case 2: if (!IsPlayerHasItem(playerid, INV_SEED_COCA)) 	return SendErrorMessage(playerid, "Ban khong co hat cocaine.");
		case 3: if (!IsPlayerHasItem(playerid, INV_SEED_POPPY)) 	return SendErrorMessage(playerid, "Ban khong co hat thuoc phien.");
	}
        
	new plant = -1;
	for(new i; i != MAX_PLANTS; i++)
	{
	    if (CropsInfo[i][pPlanted] != 0) continue;

		plant = i;
		break;
 	}

	if (plant == -1) return SendErrorMessage(playerid, "So luong nha may toi da da dat duoc.");

	new hours = 12 + random(12);
	    
    RemovePlayerItem(playerid, INV_SEED_GANJA, 1);
	GetPlayerPos(playerid, CropsInfo[plant][pX], CropsInfo[plant][pY], CropsInfo[plant][pZ]);
 	CropsInfo[plant][pZ] -= 1.0;
	CropsInfo[plant][pInt] = GetInterior(playerid);
 	CropsInfo[plant][pVW] = GetWorld(playerid);

	CropsInfo[plant][pType] = type;
	format(CropsInfo[plant][pPlanter], 52, "%s", GetName(playerid), PlayerInfo[playerid][pID]);
	CropsInfo[plant][pGrowTime] = gettime() + (hours * 3600);
	CropsInfo[plant][pStartTime] = hours * 3600;
	CropsInfo[plant][pPlanted] = 1;
	format(CropsInfo[plant][pPlantDate], 64, "%s", GetFullDate());

	CropsInfo[plant][pObject] = CreateDynamicObject(19473, CropsInfo[plant][pX], CropsInfo[plant][pY], CropsInfo[plant][pZ], 0.0, 0.0, 0.0, CropsInfo[plant][pVW], CropsInfo[plant][pInt], -1, 200.0);

	new drugname[16];
	switch(type)
	{
		case 1: format(drugname, sizeof(drugname), "can sa");
		case 2: format(drugname, sizeof(drugname), "coca");
		case 3: format(drugname, sizeof(drugname), "thuoc phien");
	}

	SM1(playerid, "Ban vua gieo hat %s. Thoi gian tang truong: %i gio.", drugname, hours);
	SendClientMessageEx(playerid, COLOR_LIGHTRED, "CHU Y!{FFFFFF} Ban co the bi trung phat vi lam dung /plant! ");

    new query[400];
	mysql_format(dbHandle, query, sizeof(query), "INSERT INTO `plants` (type, planter, posx, posy, posz, interior, vw, growtime, starttime, c_date) VALUES (%i, '%s', %f, %f, %f, %i, %i, %i, %i,'%s')",
	CropsInfo[plant][pType], CropsInfo[plant][pPlanter], CropsInfo[plant][pX], CropsInfo[plant][pY], CropsInfo[plant][pZ], CropsInfo[plant][pInt], CropsInfo[plant][pVW], CropsInfo[plant][pGrowTime], CropsInfo[plant][pStartTime], CropsInfo[plant][pPlantDate]);
	mysql_tquery(dbHandle, query);

	CropsInfo[plant][pID] = cache_insert_id();

	static const str_size[] = "Cay %s\n{FF6347}0%%";
	new mes[sizeof(str_size) + 16];

	format(mes, sizeof(mes), str_size, drugname);
	CropsInfo[plant][pLabel] = CreateDynamic3DTextLabel(mes, -1, CropsInfo[plant][pX], CropsInfo[plant][pY], CropsInfo[plant][pZ]+1.0, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, CropsInfo[plant][pVW], CropsInfo[plant][pInt], -1, 100.0);
	return 1;
}

DestroyCrop(crop)
{
	if (CropsInfo[crop][pPlanted] != 1)	return 1;

	new query[128];
	mysql_format(dbHandle, query, sizeof(query), "DELETE FROM `plants` WHERE `id` = %i", CropsInfo[crop][pID]);
	mysql_tquery(dbHandle, query);

	CropsInfo[crop][pGrowTime] = 0;
	CropsInfo[crop][pStartTime] = 0;
	CropsInfo[crop][pX] = 0.0;
	CropsInfo[crop][pY] = 0.0;
	CropsInfo[crop][pZ] = 0.0;
	CropsInfo[crop][pPlanted] = 0;
	CropsInfo[crop][pType] = 0;
	CropsInfo[crop][pID] = 0;
	format(CropsInfo[crop][pPlantDate], 64, "");

	if (IsValidDynamicObject(CropsInfo[crop][pObject]))	DestroyDynamicObject(CropsInfo[crop][pObject]);

	if (IsValidDynamic3DTextLabel(CropsInfo[crop][pLabel]))
	{
		DestroyDynamic3DTextLabel(CropsInfo[crop][pLabel]);
        CropsInfo[crop][pLabel] = Text3D:INVALID_3DTEXT_ID;
	}
	return 1;
}


stock GetFurnitureWorkType(furnitureid, building, where)
{
	new type = 0, model;

	switch(where)
	{
		case 0: model = HFurn[building][furnitureid][fModel];
		case 1: model = BFurn[building][furnitureid][fModel];
		case 2: model = GFurn[building][furnitureid][fModel];
	}

	switch(model)
	{
		case DRYER_OBJECT: 			type = 1; // dryer
		case CENTRIFUGE_OBJECT: 	type = 2; // centrifuge
		case REACTOR_OBJECT: 		type = 3; // reactor
		case MIXER_OBJECT: 			type = 4; // mix�r
		case DEHYDRATER_OBJECT: 	type = 5; // dehydrater
		case PUMP_OBJECT: 			type = 6; // Pickup pump
		default: 					type = -1;
	}

	return type;
}

stock ShowMixingDialog(playerid, part = Part_Mixing)
{
	if (GetClosestFurniture(playerid, 1.5, CENTRIFUGE_OBJECT, DRUG_LAB) == -1)
	{
		SendErrorMessage(playerid, "Khong co may ly tam ben canh ban.");
		return 0;
	}

	for(new g = 0; g < MAX_INV_SLOTS; g++) P_CHEMICAL[playerid][g][pSlot] = 0;

	new pickDialog[MAX_INV_SLOTS*(20+32+32+2+10) + 36], count = 0;
    format(gString, sizeof(gString), "Vi tri\tThuoc thu\tCong thuc\tSo luong\n");
    strcat(pickDialog, gString);
	
	for(new g = 0; g < MAX_INV_SLOTS; g++)
	{
		if (Inventory[playerid][g][pInvItem] == 0) 											continue;
		if (inventory_items[Inventory[playerid][g][pInvItem]][itemType] != ITEM_TYPE_REACT)	continue;
		
		new selected[20] = "";

		if (P_CHEMICAL[playerid][g][Selected])
		{
			if (E_CHEMICAL[Inventory[playerid][g][pInvItem]-103][MAIN])
				format(selected, sizeof(selected), "{FFFF00}[ CHINH ]");
			else
				format(selected, sizeof(selected), "{FFFF00}[ X ]");
		}

	    format(gString, sizeof(gString), "%d\t%s\t%s\t%.1f %s\n", 
			count, 
			E_CHEMICAL[Inventory[playerid][g][pInvItem]-103][NAME], 
			E_CHEMICAL[Inventory[playerid][g][pInvItem]-103][CODE], 
			Inventory[playerid][g][pInvQFloat],
			selected
		);

		strcat(pickDialog, gString);
		
		P_CHEMICAL[playerid][count][pSlot] = g;
		count++;
	}

	if (count <= 0)
	{
		Dialog_Show(playerid, None, DIALOG_STYLE_LIST, "May ly tam", "Ban khong co mot thuoc thu nao..", ">>", ""); //LackOfMaterial
		return 0;
	}
	else ShowPlayerDialog(playerid, part, DIALOG_STYLE_TABLIST_HEADERS, "May ly tam", pickDialog, "Chon", "<<");
	
	return 1;
}

stock ResetMixingInfo(playerid)
{
	for(new g = 0; g < MAX_INV_SLOTS; g++)
	{
	    P_CHEMICAL[playerid][g][Selected] = false;
		P_CHEMICAL[playerid][g][pSlot] = 0;
	}

	DeletePVar(playerid, "chosingItem");
	DeletePVar(playerid, "chemicalItem");
	DeletePVar(playerid, "chemicalItem1");
	DeletePVar(playerid, "chemicalItem2");
	DeletePVar(playerid, "MainChemical");
	DeletePVar(playerid, #DrugsAmount);
	DeletePVar(playerid, #DrugsTemp);
	return 1;
}

stock StartMixingDrug(mixerid, mix_time, Float: mix_amount, Float: mix_quality, mix_type, mix_native)
{
	new building = Chemistry[mixerid][BuildingID],
		furnid = Chemistry[mixerid][FurnID]
	;

	if (IsValidDynamic3DTextLabel(Chemistry[mixerid][osLabel])) DestroyDynamic3DTextLabel(Chemistry[mixerid][osLabel]);

	Chemistry[mixerid][temp_ID] = 1;
    Chemistry[mixerid][Material] = mix_native;
    Chemistry[mixerid][Type] = mix_type;
    Chemistry[mixerid][NeedTime] = mix_time;
    Chemistry[mixerid][Quality] = mix_quality;
	Chemistry[mixerid][Amount] = mix_amount;
    Chemistry[mixerid][IsWorking] = true;
    Chemistry[mixerid][WorkType] = GetFurnitureWorkType(furnid, Chemistry[mixerid][BuildingID], Chemistry[mixerid][BuildingType]);
	
	//AMSG(COLOR_LIGHTRED, "Chemistry[mixerid=%i][WorkType] = %i", mixerid, Chemistry[mixerid][WorkType]);

    switch(Chemistry[mixerid][WorkType])
	{
		case 1:
		{
			format(gString, sizeof(gString), "{FFFFFF}Nha may say kho\n{b5c8b6}(%s)\n{39c622}[ %d phut ]", 
				E_CHEMICAL[Chemistry[mixerid][Extra][2]][CODE], Chemistry[mixerid][NeedTime]
			);
		}
		case 2:
		{
			format(gString, sizeof(gString), "{FFFFFF}May ly tam\n{b5c8b6}(%s+%s+%s)\n{39c622}[ %d phut ]", 
				E_CHEMICAL[Chemistry[mixerid][Extra][0]][CODE], E_CHEMICAL[Chemistry[mixerid][Extra][1]][CODE], E_CHEMICAL[Chemistry[mixerid][Extra][2]][CODE], 
				Chemistry[mixerid][NeedTime]
			);
		}
	}

	switch(Chemistry[mixerid][BuildingType]) {
		case 0: Chemistry[mixerid][osLabel] = CreateDynamic3DTextLabel(gString, 0x008080FF, HFurn[building][furnid][fPosX], HFurn[building][furnid][fPosY]-0.2, HFurn[building][furnid][fPosZ]+0.4, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, HFurn[building][furnid][fVirtualWorld], HFurn[building][furnid][fInterior], -1, 15.0);
		case 1: Chemistry[mixerid][osLabel] = CreateDynamic3DTextLabel(gString, 0x008080FF, BFurn[building][furnid][fPosX], BFurn[building][furnid][fPosY]-0.2, BFurn[building][furnid][fPosZ]+0.4, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, BFurn[building][furnid][fVirtualWorld], BFurn[building][furnid][fInterior], -1, 15.0);
		case 2: Chemistry[mixerid][osLabel] = CreateDynamic3DTextLabel(gString, 0x008080FF, GFurn[building][furnid][fPosX], GFurn[building][furnid][fPosY]-0.2, GFurn[building][furnid][fPosZ]+0.4, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, GFurn[building][furnid][fVirtualWorld], GFurn[building][furnid][fInterior], -1, 15.0);
	}

	Chemistry[mixerid][Timer] = SetTimerEx("mintueMixing", 60000, true, "i", mixerid);
	return 1;
}

stock ReactDrug(i, drugid, Float: amount, Float: quality, extra1, extra2, extra3, type, buildingtype, building, furnid)
{	
	switch(buildingtype) {
		case 0: {
			HFurn[building][furnid][ChemIdx] = i;
			SQL_SetInteger("furnitures", "ChemIdx", i, HFurn[building][furnid][fID]);
		}
		case 1: {
			BFurn[building][furnid][ChemIdx] = i;
			SQL_SetInteger("furnitures", "ChemIdx", i, BFurn[building][furnid][fID]);
		}
		case 2: {
			GFurn[building][furnid][ChemIdx] = i;
			SQL_SetInteger("furnitures", "ChemIdx", i, GFurn[building][furnid][fID]);
		}
	}

	Chemistry[i][temp_ID] = 1;
	Chemistry[i][IsWorking] = true;
	Chemistry[i][WorkType] = GetFurnitureWorkType(furnid, building, buildingtype);
	Chemistry[i][BuildingType] = buildingtype;
	Chemistry[i][BuildingID] = building;
	Chemistry[i][FurnID] = furnid;
	Chemistry[i][Temperature] = 0.0;
	Chemistry[i][Material] = drugid;
	Chemistry[i][Amount] = amount;
	Chemistry[i][Type] = type;
	Chemistry[i][Quality] = quality;
	Chemistry[i][Extra][0] = extra1; 
	Chemistry[i][Extra][1] = extra2;
	Chemistry[i][Extra][2] = extra3;

	format(gString, sizeof(gString), "{ffffff}Lo phan ung\n{b5c8b6}%.1f / gram", amount);
	
	switch(buildingtype) {
		case 0: Chemistry[i][osLabel] = CreateDynamic3DTextLabel(gString, 0x008080FF,HFurn[building][furnid][fPosX],HFurn[building][furnid][fPosY]-0.2, HFurn[building][furnid][fPosZ]+0.4, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, HFurn[building][furnid][fVirtualWorld], HFurn[building][furnid][fInterior], -1, 15.0);
		case 1: Chemistry[i][osLabel] = CreateDynamic3DTextLabel(gString, 0x008080FF,BFurn[building][furnid][fPosX],BFurn[building][furnid][fPosY]-0.2, BFurn[building][furnid][fPosZ]+0.4, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, BFurn[building][furnid][fVirtualWorld], BFurn[building][furnid][fInterior], -1, 15.0);
		case 2: Chemistry[i][osLabel] = CreateDynamic3DTextLabel(gString, 0x008080FF,GFurn[building][furnid][fPosX],GFurn[building][furnid][fPosY]-0.2, GFurn[building][furnid][fPosZ]+0.4, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, GFurn[building][furnid][fVirtualWorld], GFurn[building][furnid][fInterior], -1, 15.0);
	}

	Chemistry[i][Timer] = SetTimerEx("startReacting", 500, true, "i", i);
}

stock SetPlayerHoldingCrate(playerid, type, Float:amount, Float: quality, native_main, native_extra, native_last, material)
{
    SetPVarInt(playerid, "CarryingDrugCrate", 1);
	SetPVarInt(playerid, "tdrug_Type", type);
	SetPVarFloat(playerid, "tdrug_Amount", amount);
	SetPVarFloat(playerid, "tdrug_Quality", quality);
    SetPVarInt(playerid, "BreakingBad_1", native_main);
    SetPVarInt(playerid, "BreakingBad_2", native_extra);
    SetPVarInt(playerid, "BreakingBad_3", native_last);
	SetPVarInt(playerid, "nativeCAS", material);
	return 1;
}

stock ResetDrugCrate(playerid)
{
	DeletePVar(playerid, "CarryingDrugCrate");
	DeletePVar(playerid, "tdrug_Type");
	DeletePVar(playerid, "tdrug_Amount");
	DeletePVar(playerid, "tdrug_Quality");
	DeletePVar(playerid, "nativeCAS");
	DeletePVar(playerid, "BreakingBad_1");
	DeletePVar(playerid, "BreakingBad_2");
	DeletePVar(playerid, "BreakingBad_3");
    RemovePlayerAttachedObject(playerid, 9);
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
    return 1;
}

CreateReactorExplosion(idx, f)
{
	new location[128], where[12], Float:ExpPos[3], building = Chemistry[idx][BuildingID];

	switch(Chemistry[idx][BuildingType]) 
	{
		case 0: {
			CreateExplosionInHouse(building, idx, f);

			if (HouseInfo[building][hApart]) {
				ExpPos[0] = ApartInfo[HouseInfo[building][hApart]][aPosX];
				ExpPos[1] = ApartInfo[HouseInfo[building][hApart]][aPosY];
				ExpPos[2] = ApartInfo[HouseInfo[building][hApart]][aPosZ];

				where = "apartment";
			} else {
				ExpPos[0] = HouseInfo[building][hPosX]; 
				ExpPos[1] = HouseInfo[building][hPosY];
				ExpPos[2] = HouseInfo[building][hPosZ];

				where = "home";
			}
		}
		case 1: {
			CreateExplosionInBiz(building, idx, f);

			ExpPos[0] = BizInfo[building][bizPosX]; 
			ExpPos[1] = BizInfo[building][bizPosY];
			ExpPos[2] = BizInfo[building][bizPosZ];

			where = "business";
		} 
		case 2: {
			CreateExplosionInGarage(building, idx, f);

			ExpPos[0] = GarageInfo[building][garageVeh_Enter][0]; 
			ExpPos[1] = GarageInfo[building][garageVeh_Enter][1];
			ExpPos[2] = GarageInfo[building][garageVeh_Enter][2];

			where = "garage";
		}
	}

	format(location, sizeof(location), "%s", GetLocationZone(ExpPos[0],ExpPos[1],ExpPos[2]));

	for(new i = FACTION_POLICE; i <= FACTION_FIRE; i++)
	{
		SendClientMessageEx(i, COLOR_LIGHTBLUE, "|__________Cuoc goi khan cap__________|");
		SendClientMessageEx(i, COLOR_LIGHTBLUE, "Goi tu: Dien thoai cong cong");
		SendClientMessageEx(i, COLOR_LIGHTBLUE, "Yeu cau: Police, Ambulance / Firefighters");
		SendClientMessageEx(i, COLOR_LIGHTBLUE, "Dia diem: %s %i", location, building);
		SendClientMessageEx(i, COLOR_LIGHTBLUE, "Tinh huong: Co mot vu no o %s!", where);			
	}

	for(new i = 0; i != MAX_CALLS_AND_ARREST; i++)
	{
	    if (CallInfo[i][callExists] != 0) continue;

		CallInfo[i][callPosX] = ExpPos[0];
		CallInfo[i][callPosY] = ExpPos[1];
		CallInfo[i][callPosZ] = ExpPos[2];

        CallInfo[i][callType] = 3;
		CallInfo[i][callPhone] = 0;

		format(CallInfo[i][callText], 128, "Co mot vu no o %s!", where);
		format(CallInfo[i][callName], MAX_PLAYER_NAME, "Dien thoai cong cong");
        format(CallInfo[i][callDate], 32, "%s", GetFullDate());
        format(CallInfo[i][callLocation], MAX_ZONE_NAME, "%s %i", location, building);
        
        CallInfo[i][callDelete] = gettime() + 1200;
        CallInfo[i][callExists] = 1;
        break;
	}

	return 1;
}

ClearFurnitureData(furnid, idx)
{
    KillTimer(Chemistry[idx][Timer]);
    KillTimer(Chemistry[idx][Timer]);
    DestroyDynamic3DTextLabel(Chemistry[idx][osLabel]);

	if (IsValidDynamicObject(Chemistry[idx][reactorSmoke])) DestroyDynamicObject(Chemistry[idx][reactorSmoke]);
	
	switch(Chemistry[idx][BuildingType]) {
		case 0: {
			HFurn[Chemistry[idx][BuildingID]][furnid][ChemIdx] = -1;
			SQL_SetInteger("furnitures", "ChemIdx", -1, HFurn[Chemistry[idx][BuildingID]][furnid][fID]);
		}
		case 1: {
			BFurn[Chemistry[idx][BuildingID]][furnid][ChemIdx] = -1;
			SQL_SetInteger("furnitures", "ChemIdx", -1, BFurn[Chemistry[idx][BuildingID]][furnid][fID]);
		}
		case 2: {
			GFurn[Chemistry[idx][BuildingID]][furnid][ChemIdx] = -1;
			SQL_SetInteger("furnitures", "ChemIdx", -1, GFurn[Chemistry[idx][BuildingID]][furnid][fID]);
		}
	}

	Chemistry[idx][temp_ID] = 0;
    Chemistry[idx][curTemperature] = 0.0;
    Chemistry[idx][Temperature] = 0.0;
	Chemistry[idx][IsWorking] = false;
	Chemistry[idx][WorkType] = -1;
	Chemistry[idx][Temperature] = 0.0;
	Chemistry[idx][Material] = -1;
	Chemistry[idx][BuildingType] = -1;
	Chemistry[idx][BuildingID] = -1;
	Chemistry[idx][FurnID] = -1;
	Chemistry[idx][Amount] = -1;
	Chemistry[idx][Quality] = -1;
	Chemistry[idx][Extra][0] = -1;
	Chemistry[idx][Extra][1] = -1;
	Chemistry[idx][Extra][2] = -1;
	Chemistry[idx][Control] = -1;
	Chemistry[idx][OverPoint] = 0;
	return 1;
}

CheckDrug(main, one, two)
{
	main++;
	if (check_drug[main][onedrug] == one && check_drug[main][twodrug] == two) return 1;
	else if (check_drug[main][twodrug] == two && check_drug[main][onedrug] == one) return 1;

	return 0;
}