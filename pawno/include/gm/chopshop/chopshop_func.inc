ChopShop_OnGameModeInit()
{
	return mysql_tquery(dbHandle, "SELECT * FROM chopshop", "Query_LoadChopshop");
} 

this::OnCSCreated(playerid, faction, Float: offX, Float: offY, Float: offZ, Float: rotX, Float: rotY, Float: rotZ)
{
	new idx = -1;
	for(new i = 0; i < MAX_CHOPSHOP; i++)
	{
		if (chopshop_data[i][chopshop_exist] == true) continue;

		idx = i;
		break;
	}
	
	chopshop_data[idx][chopshop_id] = cache_insert_id();
	chopshop_data[idx][chopshop_pos][0] = offX;
	chopshop_data[idx][chopshop_pos][1] = offY;
	chopshop_data[idx][chopshop_pos][2] = offZ;
	chopshop_data[idx][chopshop_pos][3] = rotX;
	chopshop_data[idx][chopshop_pos][4] = rotY;
	chopshop_data[idx][chopshop_pos][5] = rotZ;
	chopshop_data[idx][chopshop_faction] = faction;
	chopshop_data[idx][chopshop_money] = 0;
	chopshop_data[idx][chopshop_vehs] = 0;
	chopshop_data[idx][chopshop_procent] = 50;
	chopshop_data[idx][chopshop_exist] = true;

    chopshop_data[idx][chopshop_object][0] = CreateDynamicObject(3077, offX, offY, offZ, rotX, rotY, rotZ);

	GetRandomModel(idx);
	SaveChopshop(idx);

	return 1;
}

ShowChopShopInfo(playerid, id)
{
    
    static string[] = "So huu (to chuc): %s [%i]\n\
							May moc thao roi: %i\n\
							Thu nhap: +$%i";
	new msg[sizeof(string) + 64];

	format(msg, sizeof(msg), string, GetInitials(Factions[chopshop_data[id][chopshop_faction]][fName]), chopshop_data[id][chopshop_faction], chopshop_data[id][chopshop_vehs], chopshop_data[id][chopshop_money]);

	Dialog_Show(playerid, ChopShopInfo, DIALOG_STYLE_MSGBOX, "Thong tin Chopshop", msg, "<<", "");
    return 1;
}

this::Query_LoadChopshop()
{
	if (!cache_num_rows()) return printf("[ChopShop] Khong co du lieu nao duoc tim thay.");

	new rows, fields; cache_get_data(rows, fields, dbHandle);
	new count = 0;

	for(new i = 0; i < rows && i < MAX_CHOPSHOP; i++)
	{
		chopshop_data[i][chopshop_id] = cache_get_field_content_int(i, "id", dbHandle);
		chopshop_data[i][chopshop_pos][0] = cache_get_field_content_float(i, "offsetX", dbHandle);
		chopshop_data[i][chopshop_pos][1] = cache_get_field_content_float(i, "offsetY", dbHandle);
		chopshop_data[i][chopshop_pos][2] = cache_get_field_content_float(i, "offsetZ", dbHandle);
		chopshop_data[i][chopshop_pos][3] = cache_get_field_content_float(i, "rotX", dbHandle);
		chopshop_data[i][chopshop_pos][4] = cache_get_field_content_float(i, "rotY", dbHandle);
		chopshop_data[i][chopshop_pos][5] = cache_get_field_content_float(i, "rotZ", dbHandle);
		chopshop_data[i][chopshop_faction] = cache_get_field_content_int(i, "faction", dbHandle);
		chopshop_data[i][chopshop_money] = cache_get_field_content_int(i, "money", dbHandle);
		chopshop_data[i][chopshop_vehs] = cache_get_field_content_int(i, "vehicles", dbHandle);
		chopshop_data[i][chopshop_procent] = cache_get_field_content_int(i, "procent", dbHandle);
		chopshop_data[i][chopshop_exist] = true;
	
    	chopshop_data[i][chopshop_object][0] = CreateDynamicObject(3077, chopshop_data[i][chopshop_pos][0], chopshop_data[i][chopshop_pos][1], chopshop_data[i][chopshop_pos][2], chopshop_data[i][chopshop_pos][3], chopshop_data[i][chopshop_pos][4], chopshop_data[i][chopshop_pos][5]);
		
		GetRandomModel(i);
		count ++;
	}
	printf("[ChopShop] Rows - %i. Load - %i. Time - 0 ms.", cache_num_rows(), count);
	return 1;
}

RemoveChopShop(i)
{
	new query[64];
	mysql_format(dbHandle, query, sizeof(query), "DELETE FROM `chopshop` WHERE id = %d", chopshop_data[i][chopshop_id]);
	mysql_tquery(dbHandle, query);

	chopshop_data[i][chopshop_id] = 0;
	chopshop_data[i][chopshop_pos][0] = 0.0;
	chopshop_data[i][chopshop_pos][1] = 0.0;
	chopshop_data[i][chopshop_pos][2] = 0.0;
	chopshop_data[i][chopshop_pos][3] = 0.0;
	chopshop_data[i][chopshop_pos][4] = 0.0;
	chopshop_data[i][chopshop_pos][5] = 0.0;
	chopshop_data[i][chopshop_faction] = 0;
	chopshop_data[i][chopshop_money] = 0;
	chopshop_data[i][chopshop_vehs] = 0;
	chopshop_data[i][chopshop_procent] = 0;
	chopshop_data[i][chopshop_exist] = false;
	
	DestroyDynamicObject(chopshop_data[i][chopshop_object][0]);
	DestroyDynamicObject(chopshop_data[i][chopshop_object][1]);
	
	return 1;
}

stock SaveChopshop(id)
{
	new query[300];
	
	mysql_format(dbHandle, query, sizeof(query), "UPDATE chopshop SET offsetX = %f, offsetY = %f, offsetZ = %f, rotX = %f, rotY = %f, rotZ = %f, faction = %i, money = %i, vehicles = %i, procent = %i WHERE id = %i",
		chopshop_data[id][chopshop_pos][0],
		chopshop_data[id][chopshop_pos][1],
		chopshop_data[id][chopshop_pos][2],
		chopshop_data[id][chopshop_pos][3],
		chopshop_data[id][chopshop_pos][4],
		chopshop_data[id][chopshop_pos][5],
		chopshop_data[id][chopshop_faction],
		chopshop_data[id][chopshop_money],
		chopshop_data[id][chopshop_vehs],
		chopshop_data[id][chopshop_procent],
		chopshop_data[id][chopshop_id]);
	mysql_tquery(dbHandle, query);
	return 1;
}

stock GetChopshopID(playerid)
{
	for(new i; i < MAX_CHOPSHOP; i ++)
	{
	    if (!chopshop_data[i][chopshop_exist])
			continue;
	    
	    if (IsPlayerInRangeOfPoint(playerid, 5.0, chopshop_data[i][chopshop_pos][0], chopshop_data[i][chopshop_pos][1], chopshop_data[i][chopshop_pos][2]))
	    {
	        return i;
	    }
	}
	return -1;
}

stock IsFactionHasChopShop(faction)
{
	for(new i = 0; i < MAX_CHOPSHOP; i ++)
	{
		if (chopshop_data[i][chopshop_faction] == faction) return 1;
	}
	return 0;
}

stock CheckWantedModel(cs_id, modelid)
{
	if (cs_id == -1)		return 1;
	if (modelid < 400)	return 1;

	for(new i = 0; i < 10; i ++)
	{
		if (chopshop_data[cs_id][chopshop_wanted][i] == modelid)
		{
		    return 1;
		}
	}
	return 0;
}

stock GetRandomModel(id)
{
	if (id == -1) return 1;

	for(new i = 0; i < 10; i ++)
	{
		if (chopshop_data[id][chopshop_exist])
		{
		    chopshop_data[id][chopshop_wanted][i] = vehicles_info[random(sizeof(vehicles_info))][cCarModel]; //47��;//
		}
	}
	
	DestroyDynamicObject(chopshop_data[id][chopshop_object][1]);

	if (chopshop_data[id][chopshop_pos][5] > 0) chopshop_data[id][chopshop_object][1] = CreateDynamicObject(19482, chopshop_data[id][chopshop_pos][0], chopshop_data[id][chopshop_pos][1]+0.1, chopshop_data[id][chopshop_pos][2]+1.9, chopshop_data[id][chopshop_pos][3], chopshop_data[id][chopshop_pos][4], chopshop_data[id][chopshop_pos][5]-90);
	else           							   chopshop_data[id][chopshop_object][1] = CreateDynamicObject(19482, chopshop_data[id][chopshop_pos][0], chopshop_data[id][chopshop_pos][1]+0.1, chopshop_data[id][chopshop_pos][2]+1.9, chopshop_data[id][chopshop_pos][3], chopshop_data[id][chopshop_pos][4], chopshop_data[id][chopshop_pos][5]+90);

	UpdateChopShopText(id);
    
	chopshop_data[id][chopshop_timer] = 0;
	return 0;
}

UpdateChopShopText(id)
{
	new string[512];
	format(string, sizeof(string), "Wanted\n(( /delivercar ))\n%s     %s\n%s     %s\n%s     %s\n%s     %s\n%s     %s",
		VehicleNames[chopshop_data[id][chopshop_wanted][0]-400],
		VehicleNames[chopshop_data[id][chopshop_wanted][1]-400],
		VehicleNames[chopshop_data[id][chopshop_wanted][2]-400],
		VehicleNames[chopshop_data[id][chopshop_wanted][3]-400],
		VehicleNames[chopshop_data[id][chopshop_wanted][4]-400],
		VehicleNames[chopshop_data[id][chopshop_wanted][5]-400],
		VehicleNames[chopshop_data[id][chopshop_wanted][6]-400],
		VehicleNames[chopshop_data[id][chopshop_wanted][7]-400],
		VehicleNames[chopshop_data[id][chopshop_wanted][8]-400],
		VehicleNames[chopshop_data[id][chopshop_wanted][9]-400]
	);

	SetDynamicObjectMaterialText(chopshop_data[id][chopshop_object][1], 0, string, OBJECT_MATERIAL_SIZE_512x256, "Comic Sans MS", 26, 1, -1, 0, 1);
}


stock CJ_MissionReward(vehicleid)
{
	new
		car_price = GetVehiclePrice(GetVehicleModel(vehicleid)),
		count,
		final_money = 1000,
		Float: vehHP
	;
	
	AntiCheatGetVehicleHealth(vehicleid, vehHP);
	final_money += floatround(car_price * 0.1 * vehHP/GetVehicleMaxHealth(vehicleid));

	new component;
	for(new j; j < 14; j++)
	{
	    component = GetVehicleComponentInSlot(vehicleid, j);
	    if (!component) continue;
	    RemoveVehicleComponent(vehicleid, component);
        VehicleInfo[vehicleid][carComponent][GetVehicleComponentType(component)] = 0;
        SaveComponent(vehicleid, j);

		count++;
	}

	final_money += (count * 150);
	return final_money;
}

stock EditChopShop(playerid, id)
{
	if (!chopshop_data[id][chopshop_exist]) return SendErrorMessage(playerid, "Mot xuong nhu vay khong ton tai");

	SetPVarInt(playerid, #EditChopShop, 2);
	return EditDynamicObject(playerid, chopshop_data[id][chopshop_object][0]);
}

ChSh_OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
    if (GetPVarInt(playerid, #EditChopShop) == 1 && (response == EDIT_RESPONSE_FINAL || response == EDIT_RESPONSE_CANCEL))
    {
		if (response == EDIT_RESPONSE_FINAL) {		
			new faction = GetPVarInt(playerid, #ChopShop_Faction);
			new insert[256];

			SendSyntaxMessage(playerid, "Ban da tao thanh cong mot Chopsop moi.");
			if (!CheckAdmin(playerid, ADMIN_LEVEL_2) && !IsAdminDuty(playerid)) GiveCash(playerid, -CHOPSHOP_PRICE);
            
            mysql_format(dbHandle, insert, sizeof(insert), "INSERT INTO chopshop (offsetX, offsetY, offsetZ, rotX, rotY, rotZ) VALUES (%f, %f, %f, %f, %f, %f)", x, y+1, z, 0.0, 0.0, 0.0);
            mysql_tquery(dbHandle, insert, "OnCSCreated", "iiffffff", playerid, faction, x, y+1, z, 0.0, 0.0, 0.0);
		}

		DestroyDynamicObject(objectid);
        DeletePVar(playerid, #EditChopShop);
		DeletePVar(playerid, #ChopShop_Faction);
        return 1;
    }

	if (GetPVarInt(playerid, #EditChopShop) == 2 && (response == EDIT_RESPONSE_FINAL || response == EDIT_RESPONSE_CANCEL))
    {    
		if (response == EDIT_RESPONSE_FINAL) {
			new insert[256];
			mysql_format(dbHandle, insert, sizeof(insert), "INSERT INTO chopshop (offsetX, offsetY, offsetZ, rotX, rotY, rotZ) VALUES (%f, %f, %f, %f, %f, %f)", x, y, z, rx, ry, rz);
			mysql_tquery(dbHandle, insert);
			
			new id = GetChopshopID(playerid);

			SetDynamicObjectPos(objectid, x, y, z);
			SetDynamicObjectRot(objectid, rx, ry, rz);

			GetDynamicObjectPos(objectid, chopshop_data[id][chopshop_pos][0], chopshop_data[id][chopshop_pos][1], chopshop_data[id][chopshop_pos][2]);
            GetDynamicObjectRot(objectid, chopshop_data[id][chopshop_pos][3], chopshop_data[id][chopshop_pos][4], chopshop_data[id][chopshop_pos][5]);

			DestroyDynamicObject(chopshop_data[id][chopshop_object][1]);

			if (chopshop_data[id][chopshop_pos][5] > 0) chopshop_data[id][chopshop_object][1] = CreateDynamicObject(19482, chopshop_data[id][chopshop_pos][0], chopshop_data[id][chopshop_pos][1]+0.1, chopshop_data[id][chopshop_pos][2]+1.9, chopshop_data[id][chopshop_pos][3], chopshop_data[id][chopshop_pos][4], chopshop_data[id][chopshop_pos][5]-90);
			else           							   chopshop_data[id][chopshop_object][1] = CreateDynamicObject(19482, chopshop_data[id][chopshop_pos][0], chopshop_data[id][chopshop_pos][1]+0.1, chopshop_data[id][chopshop_pos][2]+1.9, chopshop_data[id][chopshop_pos][3], chopshop_data[id][chopshop_pos][4], chopshop_data[id][chopshop_pos][5]+90);


			UpdateChopShopText(id);
		}
        
        DeletePVar(playerid, #EditChopShop);
        return 1;
    }
    return 1;
}