stock Insert_AC(playerid) {
	printf("insertid ac %d", playerid);
	new string[529];
	format(string, sizeof(string), "INSERT INTO `AutoCMD` (`pid`, `AC1_CMD1`, `AC1_CMD2`, `AC1_SET1`, `AC1_SET2`) \
		VALUES ('%d','%s', '%s','%d','%d')", PlayerInfo[playerid][pId], ActionInfo[playerid][0][Action_command], 
		ActionInfo[playerid][1][Action_command], ActionInfo[playerid][0][Action_Set],ActionInfo[playerid][1][Action_Set]);
	mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);
}
stock Load_AC(playerid)
{
	new string[128];
	format(string, sizeof(string), "SELECT * FROM `AutoCMD` WHERE `pid`=%d", PlayerInfo[playerid][pId]);
	mysql_function_query(MainPipeline, string, true, "OnLoadAC", "i", playerid);
}
stock SaveACSlot(playerid,slot,type )
{
	if(type == 0 ) {
		new strupdate[324];
	    format(strupdate, sizeof strupdate, "UPDATE `AutoCMD` SET `AC1_CMD%d`= '%s',`AC1_SET%d`= '%d' WHERE `pid`=%d", 
	    slot,ActionInfo[playerid][slot][Action_command] ,slot,ActionInfo[playerid][slot][Action_Set],PlayerInfo[playerid][pId]);
	    mysql_function_query(MainPipeline, strupdate, true, "OnSaveData", "i", playerid);
	}
	if(type == 1 ) {
        new strupdate[324];
	    format(strupdate, sizeof strupdate, "UPDATE `AutoCMD` SET `AC2_CMD%d`= '%s',`AC2_SET%d`= '%d' WHERE `pid`=%d", 
	    slot,AC1Info[playerid][slot][AC1_command] ,slot,AC1Info[playerid][slot][AC1_Set],PlayerInfo[playerid][pId]);
	    mysql_function_query(MainPipeline, strupdate, true, "OnSaveData", "i", playerid);
	}
	if(type == 2 ) {
        new strupdate[324];
	    format(strupdate, sizeof strupdate, "UPDATE `AutoCMD` SET `AC3_CMD%d`= '%s',`AC3_SET%d`= '%d' WHERE `pid`=%d", 
	   slot, AC2Info[playerid][slot][AC2_command] ,slot,AC2Info[playerid][slot][AC2_Set],PlayerInfo[playerid][pId]);
	    mysql_function_query(MainPipeline, strupdate, true, "OnSaveData", "i", playerid);
	}
   
}
forward OnLoadAC(playerid);
public OnLoadAC(playerid)
{
	new fields, szResult[64],rows,str[129];
	cache_get_data(rows, fields, MainPipeline);

	for(new row;row < rows;row++)
	{
		for(new j = 0; j < MAX_ACTION; j++) {
			format(str, sizeof str, "AC1_CMD%d", j);
			cache_get_field_content(row,  str,  ActionInfo[playerid][j][Action_command], MainPipeline);
			format(str, sizeof str, "AC1_SET%d", j);
			cache_get_field_content(row,  str,  szResult, MainPipeline); ActionInfo[playerid][j][Action_Set] = strval(szResult);
			format(str, sizeof str, "AC2_CMD%d", j);
			cache_get_field_content(row,  str,  AC1Info[playerid][j][AC1_command], MainPipeline);
			format(str, sizeof str, "AC2_SET%d", j);
			cache_get_field_content(row,  str,  szResult, MainPipeline); AC1Info[playerid][j][AC1_Set] = strval(szResult);
			format(str, sizeof str, "AC3_CMD%d", j);
			cache_get_field_content(row,  str,  AC2Info[playerid][j][AC2_command], MainPipeline);
			format(str, sizeof str, "AC3_SET%d", j);
			cache_get_field_content(row,  str,  szResult, MainPipeline); AC2Info[playerid][j][AC2_Set] = strval(szResult);
		}
		break;
	}
}