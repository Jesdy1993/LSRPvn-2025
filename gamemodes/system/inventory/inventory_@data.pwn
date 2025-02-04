stock LoadInventory(playerid)
{
	new string[128];
	format(string, sizeof(string), "SELECT * FROM `Inventory` WHERE `pid`=%d", PlayerInfo[playerid][pId]);
	mysql_function_query(MainPipeline, string, true, "OnLoadInventory", "i", playerid);
}
stock InsertInventory(playerid) {
	printf("insertid %d", playerid);
	new string[529];
	format(string, sizeof(string), "INSERT INTO `Inventory` (`pid`, `Inventory_Slot0`, `Inventory_Slot1`, `Inventory_Slot2`, `Inventory_Slot3`, `Inventory_Slot4`, `Inventory_Slot5`, `Inventory_Slot6`, `Inventory_Slot7`) \
		VALUES ('%d','1', '1','1','1','1','1','1','1')", PlayerInfo[playerid][pId]);
	mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);
}
stock SaveInventory(playerid)
{
	for(new i = 0 ; i < MAX_SLOT_INVENTORY ; i++ ) {
		SaveInventorySlot(playerid,i);
	}
	return 1;
}
stock SaveAttachSlot(playerid,slot)
{
	new strupdate[1024];
	format(strupdate, sizeof strupdate, "UPDATE `Inventory` SET `PlayerAttachItem%d`= '%d' WHERE `pid`=%d", 
	slot , PlayerAttachItem[playerid][slot],PlayerInfo[playerid][pId]);
	mysql_function_query(MainPipeline, strupdate, true, "OnSaveData", "i", playerid);
}
stock SaveInventorySlot(playerid,slot)
{
	new strupdate[1024];
	format(strupdate, sizeof strupdate, "UPDATE `Inventory` SET `Inventory_Slot%d`= '%d' WHERE `pid`=%d", 
	slot , PlayerInventoryItem[playerid][slot],PlayerInfo[playerid][pId]);
	mysql_function_query(MainPipeline, strupdate, true, "OnSaveData", "i", playerid);
    
	format(strupdate, sizeof strupdate, "UPDATE `Inventory` SET `Inventory_Amount%d`= '%d' WHERE `pid`=%d", 
	slot , PlayerInventoryAmount[playerid][slot],PlayerInfo[playerid][pId]);
	mysql_function_query(MainPipeline, strupdate, true, "OnSaveData", "i", playerid);
}
forward OnSaveData(playerid);
public OnSaveData(playerid) {
    
}
forward OnLoadInventory(playerid);
public OnLoadInventory(playerid)
{
	new fields, szResult[64],rows,str[129];
	cache_get_data(rows, fields, MainPipeline);

    new string_log[2229];
    format(string_log, sizeof(string_log), "[%s] %s [LOADED]", GetLogTime(),GetPlayerNameEx(playerid)); 

	for(new row;row < rows;row++)
	{
		for(new j = 0; j < MAX_SLOT_INVENTORY; j++) {
			format(str, sizeof str, "Inventory_Slot%d", j);
			cache_get_field_content(row,  str, szResult, MainPipeline); PlayerInventoryItem[playerid][j] = strval(szResult);

		}
		for(new j = 0; j < MAX_ITEM_INVENTORY; j++) {
			format(str, sizeof str, "Inventory_Amount%d", j);
			cache_get_field_content(row,  str, szResult, MainPipeline); PlayerInventoryAmount[playerid][j] = strval(szResult);
			format(string_log, sizeof(string_log), "%s | Inventory%d = '%s' Amount: ( %d ) |", string_log,
			j,ItemInfo[ PlayerInventoryItem[playerid][j]][ItemName], PlayerInventoryAmount[playerid][j]); 
		}
		cache_get_field_content(row,  "PlayerAttachItem0", szResult, MainPipeline); PlayerAttachItem[playerid][0] = strval(szResult);
		cache_get_field_content(row,  "PlayerAttachItem1", szResult, MainPipeline); PlayerAttachItem[playerid][1] = strval(szResult);
		cache_get_field_content(row,  "PlayerAttachItem2", szResult, MainPipeline); PlayerAttachItem[playerid][2] = strval(szResult);
		cache_get_field_content(row,  "PlayerAttachItem3", szResult, MainPipeline); PlayerAttachItem[playerid][3] = strval(szResult);
		
		break;
	}

	        
    SendLogDiscordMSG(logs_loadinv, string_log);   
}