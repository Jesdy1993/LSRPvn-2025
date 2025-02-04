

PinLogin(playerid)
{
    new string[128];
    format(string, sizeof(string), "SELECT `Pin` FROM `accounts` WHERE `id` = %d", GetPlayerSQLId(playerid));
	mysql_function_query(MainPipeline, string, true, "OnPinCheck", "i", playerid);
}

Group_DisbandGroup(iGroupID) {

	new
		i = 0,
		szQuery[128];

	arrGroupData[iGroupID][g_iAllegiance] = 0;
	arrGroupData[iGroupID][g_iBugAccess] = INVALID_RANK;
	arrGroupData[iGroupID][g_iRadioAccess] = INVALID_RANK;
	arrGroupData[iGroupID][g_iDeptRadioAccess] = INVALID_RANK;
	arrGroupData[iGroupID][g_iIntRadioAccess] = INVALID_RANK;
	arrGroupData[iGroupID][g_iGovAccess] = INVALID_RANK;
	arrGroupData[iGroupID][g_iFreeNameChange] = INVALID_RANK;
	arrGroupData[iGroupID][g_iSpikeStrips] = INVALID_RANK;
	arrGroupData[iGroupID][g_iBarricades] = INVALID_RANK;
	arrGroupData[iGroupID][g_iCones] = INVALID_RANK;
	arrGroupData[iGroupID][g_iFlares] = INVALID_RANK;
	arrGroupData[iGroupID][g_iBarrels] = INVALID_RANK;
	arrGroupData[iGroupID][g_iBudget] = 0;
	arrGroupData[iGroupID][g_iBudgetPayment] = 0;
	arrGroupData[iGroupID][g_fCratePos][0] = 0;
	arrGroupData[iGroupID][g_fCratePos][1] = 0;
	arrGroupData[iGroupID][g_fCratePos][2] = 0;
	arrGroupData[iGroupID][g_szGroupName][0] = 0;
	arrGroupData[iGroupID][g_szGroupMOTD][0] = 0;

	arrGroupData[iGroupID][g_hDutyColour] = 0xFFFFFF;
	arrGroupData[iGroupID][g_hRadioColour] = 0xFFFFFF;

	DestroyDynamic3DTextLabel(arrGroupData[iGroupID][g_tCrate3DLabel]);

	while(i < MAX_GROUP_DIVS) {
		arrGroupDivisions[iGroupID][i++][0] = 0;
	}
	i = 0;

	while(i < MAX_GROUP_RANKS) {
		arrGroupRanks[iGroupID][i][0] = 0;
		arrGroupData[iGroupID][g_iPaycheck][i++] = 0;
	}
	i = 0;

	while(i < MAX_GROUP_WEAPONS) {
		arrGroupData[iGroupID][g_iLockerGuns][i] = 0;
		arrGroupData[iGroupID][g_iLockerCost][i++] = 0;
	}

	i = 0;
	while(i < MAX_GROUP_LOCKERS) {
		DestroyDynamic3DTextLabel(arrGroupLockers[iGroupID][i][g_tLocker3DLabel]);
		arrGroupLockers[iGroupID][i][g_fLockerPos][0] = 0.0;
		arrGroupLockers[iGroupID][i][g_fLockerPos][1] = 0.0;
		arrGroupLockers[iGroupID][i][g_fLockerPos][2] = 0.0;
		arrGroupData[iGroupID][g_iLockerGuns][i] = 0;
		arrGroupData[iGroupID][g_iLockerCost][i++] = 0;
	}
	SaveGroup(iGroupID);

	foreach(new x: Player)
	{
		if(PlayerInfo[x][pMember] == iGroupID || PlayerInfo[x][pLeader] == iGroupID) {
			SendClientMessageEx(x, COLOR_WHITE, "Nhom cua ban da bi xoa boi Admin, tat ca cac thanh vien se tu dong bi duoi ra khoi nhom.");
			PlayerInfo[x][pLeader] = INVALID_GROUP_ID;
			PlayerInfo[x][pMember] = INVALID_GROUP_ID;
			PlayerInfo[x][pRank] = INVALID_RANK;
			PlayerInfo[x][pDivision] = INVALID_DIVISION;
		}
		if (PlayerInfo[x][pBugged] == iGroupID) PlayerInfo[x][pBugged] = INVALID_GROUP_ID;
	}


	format(szQuery, sizeof szQuery, "DELETE FROM `groupbans` WHERE `GroupBan` = %i", iGroupID);
	mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "ii", SENDDATA_THREAD, iGroupID+1);

	format(szQuery, sizeof szQuery, "UPDATE `accounts` SET `Member` = "#INVALID_GROUP_ID", `Leader` = "#INVALID_GROUP_ID", `Division` = "#INVALID_DIVISION", `Rank` = "#INVALID_RANK" WHERE `Member` = %i OR `Leader` = %i", iGroupID, iGroupID);
	return mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "ii", SENDDATA_THREAD, iGroupID);
}

SaveGroup(iGroupID) {

	/*
		Internally, every group array/subarray starts from zero (divisions, group ids etc)
		When displaying to the clients or saving to the db, we add 1 to them!
		The only exception is ranks which already start from zero.
	*/

	if(!(0 <= iGroupID < MAX_GROUPS)) // Array bounds check. Use it.
		return 0;

	new
		szQuery[2048],
		i = 0;

	format(szQuery, sizeof szQuery, "UPDATE `groups` SET \
		`Type` = %i, `Name` = '%s', `MOTD` = '%s', `Allegiance` = %i, `Bug` = %i, \
		`Radio` = %i, `DeptRadio` = %i, `IntRadio` = %i, `GovAnnouncement` = %i, `FreeNameChange` = %i, `DutyColour` = %i, `RadioColour` = %i, ",
		arrGroupData[iGroupID][g_iGroupType], g_mysql_ReturnEscaped(arrGroupData[iGroupID][g_szGroupName], MainPipeline), arrGroupData[iGroupID][g_szGroupMOTD], arrGroupData[iGroupID][g_iAllegiance], arrGroupData[iGroupID][g_iBugAccess],
		arrGroupData[iGroupID][g_iRadioAccess], arrGroupData[iGroupID][g_iDeptRadioAccess], arrGroupData[iGroupID][g_iIntRadioAccess], arrGroupData[iGroupID][g_iGovAccess], arrGroupData[iGroupID][g_iFreeNameChange], arrGroupData[iGroupID][g_hDutyColour], arrGroupData[iGroupID][g_hRadioColour]
	);
	format(szQuery, sizeof szQuery, "%s\
		`Stock` = %i, `CrateX` = '%.2f', `CrateY` = '%.2f', `CrateZ` = '%.2f', \
		`SpikeStrips` = %i, `Barricades` = %i, `Cones` = %i, `Flares` = %i, `Barrels` = %i, \
		`Budget` = %i, `BudgetPayment` = %i, LockerCostType = %i, `CratesOrder` = '%d', `CrateIsland` = '%d', \
		`GarageX` = '%.2f', `GarageY` = '%.2f', `GarageZ` = '%.2f'",
		szQuery,
		arrGroupData[iGroupID][g_iLockerStock], arrGroupData[iGroupID][g_fCratePos][0], arrGroupData[iGroupID][g_fCratePos][1], arrGroupData[iGroupID][g_fCratePos][2],
		arrGroupData[iGroupID][g_iSpikeStrips], arrGroupData[iGroupID][g_iBarricades], arrGroupData[iGroupID][g_iCones], arrGroupData[iGroupID][g_iFlares], arrGroupData[iGroupID][g_iBarrels],
		arrGroupData[iGroupID][g_iBudget], arrGroupData[iGroupID][g_iBudgetPayment], arrGroupData[iGroupID][g_iLockerCostType], arrGroupData[iGroupID][g_iCratesOrder], arrGroupData[iGroupID][g_iCrateIsland],
		arrGroupData[iGroupID][g_fGaragePos][0], arrGroupData[iGroupID][g_fGaragePos][1], arrGroupData[iGroupID][g_fGaragePos][2]);

	for(i = 0; i != MAX_GROUP_RANKS; ++i) format(szQuery, sizeof szQuery, "%s, `Rank%i` = '%s'", szQuery, i, arrGroupRanks[iGroupID][i]);
	for(i = 0; i != MAX_GROUP_RANKS; ++i) format(szQuery, sizeof szQuery, "%s, `Rank%iPay` = %i", szQuery, i, arrGroupData[iGroupID][g_iPaycheck][i]);
	for(i = 0; i != MAX_GROUP_DIVS; ++i) format(szQuery, sizeof szQuery, "%s, `Div%i` = '%s'", szQuery, i+1, arrGroupDivisions[iGroupID][i]);
	for(i = 0; i != MAX_GROUP_WEAPONS; ++i) format(szQuery, sizeof szQuery, "%s, `Gun%i` = %i, `Cost%i` = %i", szQuery, i+1, arrGroupData[iGroupID][g_iLockerGuns][i], i+1, arrGroupData[iGroupID][g_iLockerCost][i]);
	format(szQuery, sizeof szQuery, "%s WHERE `id` = %i", szQuery, iGroupID+1);
	mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "ii", SENDDATA_THREAD, INVALID_PLAYER_ID);

	for (i = 0; i < MAX_GROUP_LOCKERS; i++)	{
		format(szQuery, sizeof(szQuery), "UPDATE `lockers` SET `LockerX` = '%.2f', `LockerY` = '%.2f', `LockerZ` = '%.2f', `LockerVW` = %d, `LockerShare` = %d WHERE `Id` = %d", arrGroupLockers[iGroupID][i][g_fLockerPos][0], arrGroupLockers[iGroupID][i][g_fLockerPos][1], arrGroupLockers[iGroupID][i][g_fLockerPos][2], arrGroupLockers[iGroupID][i][g_iLockerVW], arrGroupLockers[iGroupID][i][g_iLockerShare], arrGroupLockers[iGroupID][i][g_iLockerSQLId]);
		mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "ii", SENDDATA_THREAD, INVALID_PLAYER_ID);
	}
	return 1;
}

DynVeh_Save(iDvSlotID) {
	if((iDvSlotID > MAX_DYNAMIC_VEHICLES)) // Array bounds check. Use it.
		return 0;

	new
		szQuery[2248],
		i = 0;

	format(szQuery, sizeof szQuery,
		"UPDATE `groupvehs` SET `SpawnedID`= '%d',`gID`= '%d',`gDivID`= '%d', `fID`='%d', `rID`='%d', `vModel`= '%d', \
		`vPlate` = '%s',`vMaxHealth`= '%.2f',`vType`= '%d',`vLoadMax`= '%d',`vCol1`= '%d',`vCol2`= '%d', \
		`vX`= '%.2f',`vY`= '%.2f',`vZ`= '%.2f',`vRotZ`= '%.2f', `vUpkeep` = '%d', `vVW` = '%d', `vDisabled` = '%d', \
		`vInt` = '%d', `vFuel` = '%.5f'"
		, DynVehicleInfo[iDvSlotID][gv_iSpawnedID], DynVehicleInfo[iDvSlotID][gv_igID], DynVehicleInfo[iDvSlotID][gv_igDivID], DynVehicleInfo[iDvSlotID][gv_ifID], DynVehicleInfo[iDvSlotID][gv_irID], DynVehicleInfo[iDvSlotID][gv_iModel],
		g_mysql_ReturnEscaped(DynVehicleInfo[iDvSlotID][gv_iPlate], MainPipeline), DynVehicleInfo[iDvSlotID][gv_fMaxHealth], DynVehicleInfo[iDvSlotID][gv_iType], DynVehicleInfo[iDvSlotID][gv_iLoadMax], DynVehicleInfo[iDvSlotID][gv_iCol1], DynVehicleInfo[iDvSlotID][gv_iCol2],
		DynVehicleInfo[iDvSlotID][gv_fX], DynVehicleInfo[iDvSlotID][gv_fY], DynVehicleInfo[iDvSlotID][gv_fZ], DynVehicleInfo[iDvSlotID][gv_fRotZ], DynVehicleInfo[iDvSlotID][gv_iUpkeep], DynVehicleInfo[iDvSlotID][gv_iVW], DynVehicleInfo[iDvSlotID][gv_iDisabled],
		DynVehicleInfo[iDvSlotID][gv_iInt], DynVehicleInfo[iDvSlotID][gv_fFuel]);

	for(i = 0; i != MAX_DV_OBJECTS; ++i) {
		format(szQuery, sizeof szQuery, "%s, `vAttachedObjectModel%i` = '%d'", szQuery, i+1, DynVehicleInfo[iDvSlotID][gv_iAttachedObjectModel][i]);
		format(szQuery, sizeof szQuery, "%s, `vObjectX%i` = '%.2f'", szQuery, i+1, DynVehicleInfo[iDvSlotID][gv_fObjectX][i]);
		format(szQuery, sizeof szQuery, "%s, `vObjectY%i` = '%.2f'", szQuery, i+1, DynVehicleInfo[iDvSlotID][gv_fObjectY][i]);
		format(szQuery, sizeof szQuery, "%s, `vObjectZ%i` = '%.2f'", szQuery, i+1, DynVehicleInfo[iDvSlotID][gv_fObjectZ][i]);
		format(szQuery, sizeof szQuery, "%s, `vObjectRX%i` = '%.2f'", szQuery, i+1, DynVehicleInfo[iDvSlotID][gv_fObjectRX][i]);
		format(szQuery, sizeof szQuery, "%s, `vObjectRY%i` = '%.2f'", szQuery, i+1, DynVehicleInfo[iDvSlotID][gv_fObjectRY][i]);
		format(szQuery, sizeof szQuery, "%s, `vObjectRZ%i` = '%.2f'", szQuery, i+1, DynVehicleInfo[iDvSlotID][gv_fObjectRZ][i]);
	}

	for(i = 0; i != MAX_DV_MODS; ++i) format(szQuery, sizeof szQuery, "%s, `vMod%d` = %i", szQuery, i, DynVehicleInfo[iDvSlotID][gv_iMod][i]);

	format(szQuery, sizeof szQuery, "%s WHERE `id` = %i", szQuery, iDvSlotID);
	return mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "ii", SENDDATA_THREAD, INVALID_PLAYER_ID);
}

//--------------------------------[ INITIATE/EXIT ]---------------------------

// g_mysql_Init()
// Description: Called with Gamemode Init.
stock g_mysql_Init()
{
	new SQL_HOST[64], SQL_DB[64], SQL_USER[32], SQL_PASS[128], SQL_DEBUG, SQL_DEBUGLOG;
	new SQL_SHOST[64], SQL_SDB[64], SQL_SUSER[32], SQL_SPASS[128];
	new fileString[128], File: fileHandle = fopen("mysql.cfg", io_read);

	while(fread(fileHandle, fileString, sizeof(fileString))) {
		if(ini_GetValue(fileString, "HOST", SQL_HOST, sizeof(SQL_HOST))) continue;
		if(ini_GetValue(fileString, "DB", SQL_DB, sizeof(SQL_DB))) continue;
		if(ini_GetValue(fileString, "USER", SQL_USER, sizeof(SQL_USER))) continue;
		if(ini_GetValue(fileString, "PASS", SQL_PASS, sizeof(SQL_PASS))) continue;
		if(ini_GetInt(fileString, "SHOPAUTOMATED", ShopToggle)) continue;
		if(ini_GetValue(fileString, "SHOST", SQL_SHOST, sizeof(SQL_SHOST))) continue;
		if(ini_GetValue(fileString, "SDB", SQL_SDB, sizeof(SQL_SDB))) continue;
		if(ini_GetValue(fileString, "SUSER", SQL_SUSER, sizeof(SQL_SUSER))) continue;
		if(ini_GetValue(fileString, "SPASS", SQL_SPASS, sizeof(SQL_SPASS))) continue;
		if(ini_GetInt(fileString, "SERVER", servernumber)) continue;
		if(ini_GetInt(fileString, "DEBUG", SQL_DEBUG)) continue;
		if(ini_GetInt(fileString, "DEBUGLOG", SQL_DEBUGLOG)) continue;
	}
	fclose(fileHandle);

	mysql_log(SQL_DEBUG, SQL_DEBUGLOG);
	MainPipeline = mysql_connect(SQL_HOST, SQL_USER, SQL_DB, SQL_PASS);

	printf("[MySQL] (Main Pipelines) Connecting to %s...", SQL_HOST);
	if(mysql_errno(MainPipeline) != 0)
	{
		printf("[MySQL] (MainPipeline) Fatal Error! Could not connect to MySQL: Host %s - DB: %s - User: %s", SQL_HOST, SQL_DB, SQL_USER);
		print("[MySQL] Note: Make sure that you have provided the correct connection credentials.");
		printf("[MySQL] Error number: %d", mysql_errno(MainPipeline));
		SendRconCommand("exit");
	}
	else print("[MySQL] (MainPipeline) Connection successful toward MySQL Database Server!");

	if(ShopToggle == 1)
	{
		ShopPipeline = mysql_connect(SQL_SHOST, SQL_SUSER, SQL_SDB, SQL_SPASS);

		printf("[MySQL] (Shop Pipelines) Connecting to %s...", SQL_SHOST);
		if(mysql_errno(ShopPipeline) != 0)
		{
			printf("[MySQL] (ShopPipeline) Fatal Error! Could not connect to MySQL: Host %s - DB: %s - User: %s", SQL_SHOST, SQL_SDB, SQL_SUSER);
			print("[MySQL] Note: Make sure that you have provided the correct connection credentials.");
			printf("[MySQL] Error number: %d", mysql_errno(ShopPipeline));
			//SendRconCommand("exit");
		}
		else print("[MySQL] (ShopPipeline) Connection successful toward MySQL Database Server!");
	}

	InitiateGamemode(); // Start the server

	return 1;
}

// g_mysql_Exit()
// Description: Called with Gamemode Exit.
stock g_mysql_Exit()
{
	mysql_close(MainPipeline);
	if(ShopToggle == 1) mysql_close(ShopPipeline);
	return 1;
}

//--------------------------------[ CALLBACKS ]--------------------------------

forward OnQueryFinish(resultid, extraid, handleid);
public OnQueryFinish(resultid, extraid, handleid)
{
    new rows, fields;
	if(resultid != SENDDATA_THREAD) {
		if(extraid != INVALID_PLAYER_ID) {
			if(g_arrQueryHandle{extraid} != -1 && g_arrQueryHandle{extraid} != handleid) return 0;
		}
		cache_get_data(rows, fields, MainPipeline);
	}
	switch(resultid)
	{
	    case LOADSALEDATA_THREAD:
	    {
	        if(rows > 0)
			{
                for(new i;i < rows;i++)
				{
			    	new szResult[32], szField[15];
			    	for(new z = 0; z < MAX_ITEMS; z++)
					{
						format(szField, sizeof(szField), "TotalSold%d", z);
						cache_get_field_content(i,  szField, szResult, MainPipeline);
                        AmountSold[z] = strval(szResult);
						//ShopItems[z][sSold] = strval(szResult);


						format(szField, sizeof(szField), "AmountMade%d", z);
						cache_get_field_content(i,  szField, szResult, MainPipeline);
						AmountMade[z] = strval(szResult);
						//ShopItems[z][sMade] = strval(szResult);
						printf("TotalSold%d: %d | AmountMade%d: %d", z, AmountSold[z], z, AmountMade[z]);
					}
					break;
				}
			}
			else
			{
				mysql_function_query(MainPipeline, "INSERT INTO `sales` (`Month`) VALUES (NOW())", false, "OnQueryFinish", "i", SENDDATA_THREAD);
				mysql_function_query(MainPipeline, "SELECT * FROM `sales` WHERE `Month` > NOW() - INTERVAL 1 MONTH", true, "OnQueryFinish", "iii", LOADSALEDATA_THREAD, INVALID_PLAYER_ID, -1);
				print("[LOADSALEDATA] Inserted new row into `sales`");
			}
	    }
	    case LOADSHOPDATA_THREAD:
	    {
	        for(new i;i < rows;i++)
			{
	        	new szResult[32], szField[14];
	        	for(new z = 0; z < MAX_ITEMS; z++)
				{
					format(szField, sizeof(szField), "Price%d", z);
					cache_get_field_content(i,  szField, szResult, MainPipeline);
					ShopItems[z][sItemPrice] = strval(szResult);
					Price[z] = strval(szResult);
					if(ShopItems[z][sItemPrice] == 0) ShopItems[z][sItemPrice] = 99999999;
					printf("Price%d: %d", z, ShopItems[z][sItemPrice]);
				}
                //printf("[LOADSHOPDATA] Price0: %d, Price1: %d, Price2: %d, Price3: %d, Price4: %d, Price5: %d, Price6: %d, Price7: %d, Pricr8: %d, Price9: %d, Price10: %d", Price[0], Price[1], Price[2], Price[3], Price[4], Price[5], Price[6], Price[7], Price[8], Price[9], Price[10]);
				break;
			}
	    }
		case LOADMOTDDATA_THREAD:
		{
   			for(new i;i < rows;i++)
			{
			    new szResult[32];
   				cache_get_field_content(i, "gMOTD", GlobalMOTD, MainPipeline, 128);
				cache_get_field_content(i, "aMOTD", AdminMOTD, MainPipeline, 128);
				cache_get_field_content(i, "vMOTD", VIPMOTD, MainPipeline, 128);
				cache_get_field_content(i, "cMOTD", CAMOTD, MainPipeline, 128);
				cache_get_field_content(i, "pMOTD", pMOTD, MainPipeline, 128);
				cache_get_field_content(i, "ShopTechPay", szResult, MainPipeline); ShopTechPay = floatstr(szResult);
                cache_get_field_content(i, "GiftCode", GiftCode, MainPipeline, 32);
                cache_get_field_content(i, "GiftCodeBypass", szResult, MainPipeline); GiftCodeBypass = strval(szResult);
                cache_get_field_content(i, "SecurityCode", SecurityCode, MainPipeline, 32);
                cache_get_field_content(i, "ShopClosed", szResult, MainPipeline); ShopClosed = strval(szResult);
                cache_get_field_content(i, "RimMod", szResult, MainPipeline); RimMod = strval(szResult);
                cache_get_field_content(i, "CarVoucher", szResult, MainPipeline); CarVoucher = strval(szResult);
				cache_get_field_content(i, "PVIPVoucher", szResult, MainPipeline); PVIPVoucher = strval(szResult);
				cache_get_field_content(i, "GarageVW", szResult, MainPipeline); GarageVW = strval(szResult);
				cache_get_field_content(i, "PumpkinStock", szResult, MainPipeline); PumpkinStock = strval(szResult);
				cache_get_field_content(i, "HalloweenShop", szResult, MainPipeline); HalloweenShop = strval(szResult);
				break;
			}
		}
		case LOADUSERDATA_THREAD:
		{
			if(IsPlayerConnected(extraid))
			{
   				new szField[MAX_PLAYER_NAME], szResult[64];

				for(new row;row < rows;row++)
				{
					cache_get_field_content(row, "Username", szField, MainPipeline, MAX_PLAYER_NAME);
                    SetPlayerName(extraid, szField);
					if(strcmp(szField, GetPlayerNameExt(extraid), true) != 0)
					{
						return 1;
					}
					cache_get_field_content(row,  "id", szResult, MainPipeline); PlayerInfo[extraid][pId] = strval(szResult);
					cache_get_field_content(row,  "Online", szResult, MainPipeline); PlayerInfo[extraid][pOnline] = strval(szResult);
					cache_get_field_content(row,  "Email", PlayerInfo[extraid][pEmail], MainPipeline, 128);
					cache_get_field_content(row,  "IP", PlayerInfo[extraid][pIP], MainPipeline, 16);
					cache_get_field_content(row,  "SecureIP", PlayerInfo[extraid][pSecureIP], MainPipeline, 16);
					cache_get_field_content(row,  "ConnectedTime", szResult, MainPipeline); PlayerInfo[extraid][pConnectHours] = strval(szResult);
					cache_get_field_content(row,  "Sex", szResult, MainPipeline); PlayerInfo[extraid][pSex] = strval(szResult);
					cache_get_field_content(row,  "Band", szResult, MainPipeline); PlayerInfo[extraid][pBanned] = strval(szResult);
					cache_get_field_content(row,  "PermBand", szResult, MainPipeline); PlayerInfo[extraid][pPermaBanned] = strval(szResult);
					cache_get_field_content(row,  "Registered", szResult, MainPipeline); PlayerInfo[extraid][pReg] = strval(szResult);
					cache_get_field_content(row,  "Warnings", szResult, MainPipeline); PlayerInfo[extraid][pWarns] = strval(szResult);
					cache_get_field_content(row,  "Disabled", szResult, MainPipeline); PlayerInfo[extraid][pDisabled] = strval(szResult);
					cache_get_field_content(row,  "Level", szResult, MainPipeline); PlayerInfo[extraid][pLevel] = strval(szResult);
					cache_get_field_content(row,  "SoTaiKhoan", szResult, MainPipeline); PlayerInfo[extraid][pSoTaiKhoan] = strval(szResult);
					cache_get_field_content(row,  "pGiftDollar", szResult, MainPipeline); PlayerInfo[extraid][pGiftDollar] = strval(szResult);

					cache_get_field_content(row,  "pCasinoCrash", szResult, MainPipeline); PlayerInfo[extraid][pCasinoCrash] = strval(szResult);
					cache_get_field_content(row,  "PlayerDrugTask", szResult, MainPipeline); PlayerDrugTask[extraid] = strval(szResult);
					cache_get_field_content(row,  "PlayerMaxDrugTask", szResult, MainPipeline); PlayerMaxDrugTask[extraid] = strval(szResult);
					
                   
                    cache_get_field_content(row,  "pSettingTwo", szResult, MainPipeline); PlayerInfo[extraid][pSettingTwo] = strval(szResult);
                    cache_get_field_content(row,  "pTimeAcceptDeath", szResult, MainPipeline); PlayerInfo[extraid][pTimeAcceptDeath] = strval(szResult);
                    cache_get_field_content(row,  "pSettingTwoPass", PlayerInfo[extraid][pSettingTwoPass], MainPipeline); 
                    cache_get_field_content(row,  "AdminLevel", szResult, MainPipeline); PlayerInfo[extraid][pAdmin] = strval(szResult);
					cache_get_field_content(row,  "pPayment", szResult, MainPipeline); PlayerInfo[extraid][pPayment] = strval(szResult);
					cache_get_field_content(row,  "ReportCount", szResult, MainPipeline); PlayerInfo[extraid][pAdvisorCount] = strval(szResult);
					

					cache_get_field_content(row,  "pCompany", szResult, MainPipeline); PlayerInfo[extraid][pCompany] = strval(szResult);
					
					cache_get_field_content(row,  "MPH", PlayerInfo[extraid][pMPH], MainPipeline, 128);
					cache_get_field_content(row,  "GiongNoi", PlayerInfo[extraid][pGiongNoi], MainPipeline, 64);
					cache_get_field_content(row,  "playerTutorial", szResult, MainPipeline); Question_@TutorialQues[extraid] = strval(szResult);

					cache_get_field_content(row,  "NumberContact0", szResult, MainPipeline); NumberContact[extraid][0] = strval(szResult);
					cache_get_field_content(row,  "NumberContact1", szResult, MainPipeline); NumberContact[extraid][1] = strval(szResult);
					cache_get_field_content(row,  "NumberContact2", szResult, MainPipeline); NumberContact[extraid][2] = strval(szResult);
					cache_get_field_content(row,  "NumberContact3", szResult, MainPipeline); NumberContact[extraid][3] = strval(szResult);
					cache_get_field_content(row,  "NumberContact4", szResult, MainPipeline); NumberContact[extraid][4] = strval(szResult);
					cache_get_field_content(row,  "NumberContact5", szResult, MainPipeline); NumberContact[extraid][5] = strval(szResult);
					cache_get_field_content(row,  "NumberContact6", szResult, MainPipeline); NumberContact[extraid][6] = strval(szResult);
					cache_get_field_content(row,  "NumberContact7", szResult, MainPipeline); NumberContact[extraid][7] = strval(szResult);
					cache_get_field_content(row,  "NumberContact8", szResult, MainPipeline); NumberContact[extraid][8] = strval(szResult);
					cache_get_field_content(row,  "NumberContact9", szResult, MainPipeline); NumberContact[extraid][9] = strval(szResult);

					cache_get_field_content(row,  "NameContact0",  NameContact[extraid][0], MainPipeline, 128);
					cache_get_field_content(row,  "NameContact1",  NameContact[extraid][1], MainPipeline, 128);
					cache_get_field_content(row,  "NameContact2",  NameContact[extraid][2], MainPipeline, 128);
					cache_get_field_content(row,  "NameContact3",  NameContact[extraid][3], MainPipeline, 128);
					cache_get_field_content(row,  "NameContact4",  NameContact[extraid][4], MainPipeline, 128);
					cache_get_field_content(row,  "NameContact5",  NameContact[extraid][5], MainPipeline, 128);
					cache_get_field_content(row,  "NameContact6",  NameContact[extraid][6], MainPipeline, 128);
					cache_get_field_content(row,  "NameContact7",  NameContact[extraid][7], MainPipeline, 128);
					cache_get_field_content(row,  "NameContact8",  NameContact[extraid][8], MainPipeline, 128);
					cache_get_field_content(row,  "NameContact9",  NameContact[extraid][9], MainPipeline, 128);
				



					for(new i = 0; i < 9; i++)
                    {
                        format(szField, sizeof(szField), "Ammo%d", i);
                        cache_get_field_content(row,  szField, szResult, MainPipeline);
                        PlayerInfo[extraid][pAmmo][i] = strval(szResult);
                    }
                    for(new i = 0; i < 12; i++)
                    {
                        format(szField, sizeof(szField), "BangDan%d", i);
                        cache_get_field_content(row,  szField, szResult, MainPipeline);
                        PlayerInfo[extraid][pBangDan][i] = strval(szResult);
                    }

					// job count
					cache_get_field_content(row,  "pCountTruck", szResult, MainPipeline); PlayerInfo[extraid][pCountTruck] = strval(szResult);
					cache_get_field_content(row,  "pCountPizza", szResult, MainPipeline); PlayerInfo[extraid][pCountPizza] = strval(szResult);
					cache_get_field_content(row,  "pCountMiner", szResult, MainPipeline); PlayerInfo[extraid][pCountMiner] = strval(szResult);
					cache_get_field_content(row,  "pCountTrash", szResult, MainPipeline); PlayerInfo[extraid][pCountTrash] = strval(szResult);
					cache_get_field_content(row,  "pCountElec", szResult, MainPipeline); PlayerInfo[extraid][pCountElec] = strval(szResult);
					cache_get_field_content(row,  "pCountWork", szResult, MainPipeline); PlayerInfo[extraid][pCountWork] = strval(szResult);
					cache_get_field_content(row,  "pCountWood", szResult, MainPipeline); PlayerInfo[extraid][pCountWood] = strval(szResult);



					cache_get_field_content(row,  "Clothes0", szResult, MainPipeline); PlayerInfo[extraid][pTrangPhuc][0] = strval(szResult);
					cache_get_field_content(row,  "Clothes1", szResult, MainPipeline); PlayerInfo[extraid][pTrangPhuc][1] = strval(szResult);
					cache_get_field_content(row,  "Clothes2", szResult, MainPipeline); PlayerInfo[extraid][pTrangPhuc][2] = strval(szResult);
					cache_get_field_content(row,  "Clothes3", szResult, MainPipeline); PlayerInfo[extraid][pTrangPhuc][3] = strval(szResult);
					cache_get_field_content(row,  "Clothes4", szResult, MainPipeline); PlayerInfo[extraid][pTrangPhuc][4] = strval(szResult);
					cache_get_field_content(row,  "Clothes5", szResult, MainPipeline); PlayerInfo[extraid][pTrangPhuc][5] = strval(szResult);
					cache_get_field_content(row,  "Clothes6", szResult, MainPipeline); PlayerInfo[extraid][pTrangPhuc][6] = strval(szResult);
					cache_get_field_content(row,  "Clothes7", szResult, MainPipeline); PlayerInfo[extraid][pTrangPhuc][7] = strval(szResult);
					cache_get_field_content(row,  "Clothes8", szResult, MainPipeline); PlayerInfo[extraid][pTrangPhuc][8] = strval(szResult);
					cache_get_field_content(row,  "Clothes9", szResult, MainPipeline); PlayerInfo[extraid][pTrangPhuc][9] = strval(szResult);

					cache_get_field_content(row,  "FireLeg", szResult, MainPipeline); PlayerInfo[extraid][pFireLeg] = strval(szResult);
                    cache_get_field_content(row,  "FireHead", szResult, MainPipeline); PlayerInfo[extraid][pFireHead] = strval(szResult);
                    cache_get_field_content(row,  "FireTorso", szResult, MainPipeline); PlayerInfo[extraid][pFireTorso] = strval(szResult);
                    cache_get_field_content(row,  "Injured", szResult, MainPipeline); PlayerInfo[extraid][pInjured] = strval(szResult);

					cache_get_field_content(row,  "CMND", szResult, MainPipeline); PlayerInfo[extraid][pCMND] = strval(szResult);
					cache_get_field_content(row,  "BirthDatez", PlayerInfo[extraid][pBirthDate], MainPipeline);

					cache_get_field_content(row,  "SeniorModerator", szResult, MainPipeline); PlayerInfo[extraid][pSMod] = strval(szResult);
					cache_get_field_content(row,  "DonateRank", szResult, MainPipeline); PlayerInfo[extraid][pDonateRank] = strval(szResult);
					cache_get_field_content(row,  "Respect", szResult, MainPipeline); PlayerInfo[extraid][pExp] = strval(szResult);
					cache_get_field_content(row,  "XP", szResult, MainPipeline); PlayerInfo[extraid][pXP] = strval(szResult);
					cache_get_field_content(row,  "TruyDuoi", szResult, MainPipeline); PlayerInfo[extraid][pTruyDuoi] = strval(szResult);
                    cache_get_field_content(row,  "BanTime", szResult, MainPipeline); PlayerInfo[extraid][pBanTime] = strval(szResult);
					cache_get_field_content(row,  "TimeBanned", szResult, MainPipeline); PlayerInfo[extraid][pTimeBanned] = strval(szResult);
					cache_get_field_content(row,  "BannedBy", PlayerInfo[extraid][pBannedBy], MainPipeline, 128);
					cache_get_field_content(row,  "ReasonBanned", PlayerInfo[extraid][pReasonBanned], MainPipeline, 128);
					cache_get_field_content(row,  "Flag", PlayerInfo[extraid][pFlag]);
					cache_get_field_content(row,  "Money", szResult, MainPipeline); PlayerInfo[extraid][pCash] = strval(szResult);
					cache_get_field_content(row,  "Bank", szResult, MainPipeline); PlayerInfo[extraid][pAccount] = strval(szResult);
					cache_get_field_content(row,  "pHealth", szResult, MainPipeline); PlayerInfo[extraid][pHealth] = floatstr(szResult);
					cache_get_field_content(row,  "pArmor", szResult, MainPipeline); PlayerInfo[extraid][pArmor] = floatstr(szResult);
					cache_get_field_content(row,  "pSHealth", szResult, MainPipeline); PlayerInfo[extraid][pSHealth] = floatstr(szResult);
					cache_get_field_content(row,  "Int", szResult, MainPipeline); PlayerInfo[extraid][pInt] = strval(szResult);
					cache_get_field_content(row,  "VirtualWorld", szResult, MainPipeline); PlayerInfo[extraid][pVW] = strval(szResult);
					cache_get_field_content(row,  "Model", szResult, MainPipeline); PlayerInfo[extraid][pModel] = strval(szResult);

					// fitness system

	                cache_get_field_content(row,  "pFitness", szResult, MainPipeline); PlayerFitness[extraid][pFitness] = floatstr(szResult);
	                cache_get_field_content(row,  "pFitnessMax", szResult, MainPipeline); PlayerFitness[extraid][pFitnessMax] = floatstr(szResult);
	                cache_get_field_content(row,  "pFood", szResult, MainPipeline); PlayerFitness[extraid][pFood] = floatstr(szResult);
	                cache_get_field_content(row,  "pWater", szResult, MainPipeline); PlayerFitness[extraid][pWater] = floatstr(szResult);

					cache_get_field_content(row,  "SPos_x", szResult, MainPipeline); PlayerInfo[extraid][pPos_x] = floatstr(szResult);
					cache_get_field_content(row,  "SPos_y", szResult, MainPipeline); PlayerInfo[extraid][pPos_y] = floatstr(szResult);
					cache_get_field_content(row,  "SPos_z", szResult, MainPipeline); PlayerInfo[extraid][pPos_z] = floatstr(szResult);
					cache_get_field_content(row,  "SPos_r", szResult, MainPipeline); PlayerInfo[extraid][pPos_r] = floatstr(szResult);
					cache_get_field_content(row,  "BanAppealer", szResult, MainPipeline); PlayerInfo[extraid][pBanAppealer] = strval(szResult);
					cache_get_field_content(row,  "PR", szResult, MainPipeline); PlayerInfo[extraid][pPR] = strval(szResult);
					cache_get_field_content(row,  "HR", szResult, MainPipeline); PlayerInfo[extraid][pHR] = strval(szResult);
					cache_get_field_content(row,  "AP", szResult, MainPipeline); PlayerInfo[extraid][pAP] = strval(szResult);
					cache_get_field_content(row,  "Security", szResult, MainPipeline); PlayerInfo[extraid][pSecurity] = strval(szResult);
					cache_get_field_content(row,  "ShopTech", szResult, MainPipeline); PlayerInfo[extraid][pShopTech] = strval(szResult);
					cache_get_field_content(row,  "FactionModerator", szResult, MainPipeline); PlayerInfo[extraid][pFactionModerator] = strval(szResult);
					cache_get_field_content(row,  "GangModerator", szResult, MainPipeline); PlayerInfo[extraid][pGangModerator] = strval(szResult);
					cache_get_field_content(row,  "Undercover", szResult, MainPipeline); PlayerInfo[extraid][pUndercover] = strval(szResult);
					cache_get_field_content(row,  "TogReports", szResult, MainPipeline); PlayerInfo[extraid][pTogReports] = strval(szResult);
					cache_get_field_content(row,  "Radio", szResult, MainPipeline); PlayerInfo[extraid][pRadio] = strval(szResult);
					cache_get_field_content(row,  "RadioFreq", szResult, MainPipeline); PlayerInfo[extraid][pRadioFreq] = strval(szResult);
					cache_get_field_content(row,  "UpgradePoints", szResult, MainPipeline); PlayerInfo[extraid][gPupgrade] = strval(szResult);
					cache_get_field_content(row,  "Origin", szResult, MainPipeline); PlayerInfo[extraid][pOrigin] = strval(szResult);
					cache_get_field_content(row,  "Muted", szResult, MainPipeline); PlayerInfo[extraid][pMuted] = strval(szResult);
					cache_get_field_content(row,  "Crimes", szResult, MainPipeline); PlayerInfo[extraid][pCrimes] = strval(szResult);
					cache_get_field_content(row,  "Accent", szResult, MainPipeline); PlayerInfo[extraid][pAccent] = strval(szResult);
					cache_get_field_content(row,  "CHits", szResult, MainPipeline); PlayerInfo[extraid][pCHits] = strval(szResult);
					cache_get_field_content(row,  "FHits", szResult, MainPipeline); PlayerInfo[extraid][pFHits] = strval(szResult);
					cache_get_field_content(row,  "Arrested", szResult, MainPipeline); PlayerInfo[extraid][pArrested] = strval(szResult);
					cache_get_field_content(row,  "Phonebook", szResult, MainPipeline); PlayerInfo[extraid][pPhoneBook] = strval(szResult);
					cache_get_field_content(row,  "LottoNr", szResult, MainPipeline); PlayerInfo[extraid][pLottoNr] = strval(szResult);
					cache_get_field_content(row,  "Fishes", szResult, MainPipeline); PlayerInfo[extraid][pFishes] = strval(szResult);
					cache_get_field_content(row,  "Gcoin", szResult, MainPipeline); PlayerInfo[extraid][pGcoin] = strval(szResult);
				

					cache_get_field_content(row,  "SoTaiKhoan", szResult, MainPipeline); PlayerInfo[extraid][pSoTaiKhoan] = strval(szResult);
				
				
					cache_get_field_content(row,  "BiggestFish", szResult, MainPipeline); PlayerInfo[extraid][pBiggestFish] = strval(szResult);
					cache_get_field_content(row,  "Job", szResult, MainPipeline); PlayerInfo[extraid][pJob] = strval(szResult);
					cache_get_field_content(row,  "Job2", szResult, MainPipeline); PlayerInfo[extraid][pJob2] = strval(szResult);
					cache_get_field_content(row,  "Paycheck", szResult, MainPipeline); PlayerInfo[extraid][pPayCheck] = strval(szResult);
					cache_get_field_content(row,  "HeadValue", szResult, MainPipeline); PlayerInfo[extraid][pHeadValue] = strval(szResult);
					cache_get_field_content(row,  "JailTime", szResult, MainPipeline); PlayerInfo[extraid][pJailTime] = strval(szResult);
					cache_get_field_content(row,  "WRestricted", szResult, MainPipeline); PlayerInfo[extraid][pWRestricted] = strval(szResult);
					cache_get_field_content(row,  "Materials", szResult, MainPipeline); PlayerInfo[extraid][pMats] = strval(szResult);
					cache_get_field_content(row,  "Crates", szResult, MainPipeline); PlayerInfo[extraid][pCrates] = strval(szResult);
					cache_get_field_content(row,  "Pot", szResult, MainPipeline); PlayerInfo[extraid][pPot] = strval(szResult);
					cache_get_field_content(row,  "Crack", szResult, MainPipeline); PlayerInfo[extraid][pCrack] = strval(szResult);
					cache_get_field_content(row,  "Nation", szResult, MainPipeline); PlayerInfo[extraid][pNation] = strval(szResult);
					cache_get_field_content(row,  "Leader", szResult, MainPipeline); PlayerInfo[extraid][pLeader] = strval(szResult);
					cache_get_field_content(row,  "Member", szResult, MainPipeline); PlayerInfo[extraid][pMember] = strval(szResult);
					cache_get_field_content(row,  "Division", szResult, MainPipeline); PlayerInfo[extraid][pDivision] = strval(szResult);
					cache_get_field_content(row,  "FMember", szResult, MainPipeline); PlayerInfo[extraid][pFMember] = strval(szResult);
					cache_get_field_content(row,  "Rank", szResult, MainPipeline); PlayerInfo[extraid][pRank] = strval(szResult);
					cache_get_field_content(row,  "DetSkill", szResult, MainPipeline); PlayerInfo[extraid][pDetSkill] = strval(szResult);
					cache_get_field_content(row,  "SexSkill", szResult, MainPipeline); PlayerInfo[extraid][pSexSkill] = strval(szResult);
					cache_get_field_content(row,  "BoxSkill", szResult, MainPipeline); PlayerInfo[extraid][pBoxSkill] = strval(szResult);
					cache_get_field_content(row,  "LawSkill", szResult, MainPipeline); PlayerInfo[extraid][pLawSkill] = strval(szResult);
					cache_get_field_content(row,  "MechSkill", szResult, MainPipeline); PlayerInfo[extraid][pMechSkill] = strval(szResult);
					cache_get_field_content(row,  "TruckSkill", szResult, MainPipeline); PlayerInfo[extraid][pTruckSkill] = strval(szResult);
					cache_get_field_content(row,  "DrugsSkill", szResult, MainPipeline); PlayerInfo[extraid][pDrugsSkill] = strval(szResult);
					cache_get_field_content(row,  "ArmsSkill", szResult, MainPipeline); PlayerInfo[extraid][pArmsSkill] = strval(szResult);
					cache_get_field_content(row,  "SmugglerSkill", szResult, MainPipeline); PlayerInfo[extraid][pSmugSkill] = strval(szResult);
					cache_get_field_content(row,  "FishSkill", szResult, MainPipeline); PlayerInfo[extraid][pFishSkill] = strval(szResult);
					cache_get_field_content(row,  "FightingStyle", szResult, MainPipeline); PlayerInfo[extraid][pFightStyle] = strval(szResult);
					cache_get_field_content(row,  "PhoneNr", szResult, MainPipeline); PlayerInfo[extraid][pPnumber] = strval(szResult);
					cache_get_field_content(row,  "Apartment", szResult, MainPipeline); PlayerInfo[extraid][pPhousekey] = strval(szResult);
					cache_get_field_content(row,  "Apartment2", szResult, MainPipeline); PlayerInfo[extraid][pPhousekey2] = strval(szResult);
					cache_get_field_content(row,  "Renting", szResult, MainPipeline); PlayerInfo[extraid][pRenting] = strval(szResult);
					cache_get_field_content(row,  "CarLic", szResult, MainPipeline); PlayerInfo[extraid][pCarLic] = strval(szResult);
					cache_get_field_content(row,  "FlyLic", szResult, MainPipeline); PlayerInfo[extraid][pFlyLic] = strval(szResult);
					cache_get_field_content(row,  "BoatLic", szResult, MainPipeline); PlayerInfo[extraid][pBoatLic] = strval(szResult);
					cache_get_field_content(row,  "FishLic", szResult, MainPipeline); PlayerInfo[extraid][pFishLic] = strval(szResult);
					cache_get_field_content(row,  "CheckCash", szResult, MainPipeline); PlayerInfo[extraid][pCheckCash] = strval(szResult);
					cache_get_field_content(row,  "Checks", szResult, MainPipeline); PlayerInfo[extraid][pChecks] = strval(szResult);
					cache_get_field_content(row,  "GunLic", szResult, MainPipeline); PlayerInfo[extraid][pGunLic] = strval(szResult);
                   		
					for(new i = 0; i < 12; i++)
					{
						format(szField, sizeof(szField), "Gun%d", i);
						cache_get_field_content(row,  szField, szResult, MainPipeline);
						PlayerInfo[extraid][pGuns][i] = strval(szResult);
					}				
					cache_get_field_content(row,  "DrugsTime", szResult, MainPipeline); PlayerInfo[extraid][pDrugsTime] = strval(szResult);
					cache_get_field_content(row,  "LawyerTime", szResult, MainPipeline); PlayerInfo[extraid][pLawyerTime] = strval(szResult);
					cache_get_field_content(row,  "LawyerFreeTime", szResult, MainPipeline); PlayerInfo[extraid][pLawyerFreeTime] = strval(szResult);
					cache_get_field_content(row,  "MechTime", szResult, MainPipeline); PlayerInfo[extraid][pMechTime] = strval(szResult);
					cache_get_field_content(row,  "SexTime", szResult, MainPipeline); PlayerInfo[extraid][pSexTime] = strval(szResult);
					cache_get_field_content(row,  "PayDay", szResult, MainPipeline); PlayerInfo[extraid][pConnectSeconds] = strval(szResult);
					cache_get_field_content(row,  "PayDayHad", szResult, MainPipeline); PlayerInfo[extraid][pPayDayHad] = strval(szResult);
					cache_get_field_content(row,  "CDPlayer", szResult, MainPipeline); PlayerInfo[extraid][pCDPlayer] = strval(szResult);
					cache_get_field_content(row,  "Dice", szResult, MainPipeline); PlayerInfo[extraid][pDice] = strval(szResult);
					cache_get_field_content(row,  "Spraycan", szResult, MainPipeline); PlayerInfo[extraid][pSpraycan] = strval(szResult);
					cache_get_field_content(row,  "Rope", szResult, MainPipeline); PlayerInfo[extraid][pRope] = strval(szResult);
					cache_get_field_content(row,  "Cigars", szResult, MainPipeline); PlayerInfo[extraid][pCigar] = strval(szResult);
					cache_get_field_content(row,  "Sprunk", szResult, MainPipeline); PlayerInfo[extraid][pSprunk] = strval(szResult);
					cache_get_field_content(row,  "Bombs", szResult, MainPipeline); PlayerInfo[extraid][pBombs] = strval(szResult);
					cache_get_field_content(row,  "Wins", szResult, MainPipeline); PlayerInfo[extraid][pWins] = strval(szResult);
					cache_get_field_content(row,  "Loses", szResult, MainPipeline); PlayerInfo[extraid][pLoses] = strval(szResult);
					cache_get_field_content(row,  "Tutorial", szResult, MainPipeline); PlayerInfo[extraid][pTut] = strval(szResult);
					cache_get_field_content(row,  "OnDuty", szResult, MainPipeline); PlayerInfo[extraid][pDuty] = strval(szResult);
					cache_get_field_content(row,  "Hospital", szResult, MainPipeline); PlayerInfo[extraid][pHospital] = strval(szResult);
					cache_get_field_content(row,  "MarriedID", szResult, MainPipeline); PlayerInfo[extraid][pMarriedID] = strval(szResult);
					cache_get_field_content(row,  "ContractBy", PlayerInfo[extraid][pContractBy], MainPipeline, MAX_PLAYER_NAME);
					cache_get_field_content(row,  "ContractDetail", PlayerInfo[extraid][pContractDetail], MainPipeline, 64);
					cache_get_field_content(row,  "WantedLevel", szResult, MainPipeline); PlayerInfo[extraid][pWantedLevel] = strval(szResult);
					cache_get_field_content(row,  "Insurance", szResult, MainPipeline); PlayerInfo[extraid][pInsurance] = strval(szResult);
					cache_get_field_content(row,  "911Muted", szResult, MainPipeline); PlayerInfo[extraid][p911Muted] = strval(szResult);
					cache_get_field_content(row,  "NewMuted", szResult, MainPipeline); PlayerInfo[extraid][pNMute] = strval(szResult);
					cache_get_field_content(row,  "NewMutedTotal", szResult, MainPipeline); PlayerInfo[extraid][pNMuteTotal] = strval(szResult);
					cache_get_field_content(row,  "AdMuted", szResult, MainPipeline); PlayerInfo[extraid][pADMute] = strval(szResult);
					cache_get_field_content(row,  "AdMutedTotal", szResult, MainPipeline); PlayerInfo[extraid][pADMuteTotal] = strval(szResult);
					cache_get_field_content(row,  "HelpMute", szResult, MainPipeline); PlayerInfo[extraid][pHelpMute] = strval(szResult);
					cache_get_field_content(row,  "Helper", szResult, MainPipeline); PlayerInfo[extraid][pHelper] = strval(szResult);
					cache_get_field_content(row,  "ReportMuted", szResult, MainPipeline); PlayerInfo[extraid][pRMuted] = strval(szResult);
					cache_get_field_content(row,  "ReportMutedTotal", szResult, MainPipeline); PlayerInfo[extraid][pRMutedTotal] = strval(szResult);
					cache_get_field_content(row,  "ReportMutedTime", szResult, MainPipeline); PlayerInfo[extraid][pRMutedTime] = strval(szResult);
					cache_get_field_content(row,  "DMRMuted", szResult, MainPipeline); PlayerInfo[extraid][pDMRMuted] = strval(szResult);
					cache_get_field_content(row,  "VIPMuted", szResult, MainPipeline); PlayerInfo[extraid][pVMuted] = strval(szResult);
					cache_get_field_content(row,  "VIPMutedTime", szResult, MainPipeline); PlayerInfo[extraid][pVMutedTime] = strval(szResult);
					cache_get_field_content(row,  "GiftTime", szResult, MainPipeline); PlayerInfo[extraid][pGiftTime] = strval(szResult);
					cache_get_field_content(row,  "AdvisorDutyHours", szResult, MainPipeline); PlayerInfo[extraid][pDutyHours] = strval(szResult);
					cache_get_field_content(row,  "AcceptedHelp", szResult, MainPipeline); PlayerInfo[extraid][pAcceptedHelp] = strval(szResult);
					cache_get_field_content(row,  "AcceptReport", szResult, MainPipeline); PlayerInfo[extraid][pAcceptReport] = strval(szResult);
					cache_get_field_content(row,  "ShopTechOrders", szResult, MainPipeline); PlayerInfo[extraid][pShopTechOrders] = strval(szResult);
					cache_get_field_content(row,  "TrashReport", szResult, MainPipeline); PlayerInfo[extraid][pTrashReport] = strval(szResult);
					cache_get_field_content(row,  "GangWarn", szResult, MainPipeline); PlayerInfo[extraid][pGangWarn] = strval(szResult);
					cache_get_field_content(row,  "CSFBanned", szResult, MainPipeline); PlayerInfo[extraid][pCSFBanned] = strval(szResult);
					cache_get_field_content(row,  "VIPInviteDay", szResult, MainPipeline); PlayerInfo[extraid][pVIPInviteDay] = strval(szResult);
					cache_get_field_content(row,  "TempVIP", szResult, MainPipeline); PlayerInfo[extraid][pTempVIP] = strval(szResult);
					cache_get_field_content(row,  "BuddyInvite", szResult, MainPipeline); PlayerInfo[extraid][pBuddyInvited] = strval(szResult);
					cache_get_field_content(row,  "Tokens", szResult, MainPipeline); PlayerInfo[extraid][pTokens] = strval(szResult);
					cache_get_field_content(row,  "PTokens", szResult, MainPipeline); PlayerInfo[extraid][pPaintTokens] = strval(szResult);
					cache_get_field_content(row,  "TriageTime", szResult, MainPipeline); PlayerInfo[extraid][pTriageTime] = strval(szResult);
					cache_get_field_content(row,  "PrisonedBy", PlayerInfo[extraid][pPrisonedBy], MainPipeline, MAX_PLAYER_NAME);
					cache_get_field_content(row,  "PrisonReason", PlayerInfo[extraid][pPrisonReason], MainPipeline, 128);
					cache_get_field_content(row,  "TaxiLicense", szResult, MainPipeline); PlayerInfo[extraid][pTaxiLicense] = strval(szResult);
					cache_get_field_content(row,  "TicketTime", szResult, MainPipeline); PlayerInfo[extraid][pTicketTime] = strval(szResult);
					cache_get_field_content(row,  "Screwdriver", szResult, MainPipeline); PlayerInfo[extraid][pScrewdriver] = strval(szResult);
					cache_get_field_content(row,  "Smslog", szResult, MainPipeline); PlayerInfo[extraid][pSmslog] = strval(szResult);
					cache_get_field_content(row,  "Wristwatch", szResult, MainPipeline); PlayerInfo[extraid][pWristwatch] = strval(szResult);
					cache_get_field_content(row,  "Surveillance", szResult, MainPipeline); PlayerInfo[extraid][pSurveillance] = strval(szResult);
					cache_get_field_content(row,  "Tire", szResult, MainPipeline); PlayerInfo[extraid][pTire] = strval(szResult);
					cache_get_field_content(row,  "Firstaid", szResult, MainPipeline); PlayerInfo[extraid][pFirstaid] = strval(szResult);
					cache_get_field_content(row,  "Rccam", szResult, MainPipeline); PlayerInfo[extraid][pRccam] = strval(szResult);
					cache_get_field_content(row,  "Receiver", szResult, MainPipeline); PlayerInfo[extraid][pReceiver] = strval(szResult);
					cache_get_field_content(row,  "GPS", szResult, MainPipeline); PlayerInfo[extraid][pGPS] = strval(szResult);
					cache_get_field_content(row,  "Sweep", szResult, MainPipeline); PlayerInfo[extraid][pSweep] = strval(szResult);
					cache_get_field_content(row,  "SweepLeft", szResult, MainPipeline); PlayerInfo[extraid][pSweepLeft] = strval(szResult);
					cache_get_field_content(row,  "Bugged", szResult, MainPipeline); PlayerInfo[extraid][pBugged] = strval(szResult);
					cache_get_field_content(row,  "pWExists", szResult, MainPipeline); PlayerInfo[extraid][pWeedObject] = strval(szResult);
					cache_get_field_content(row,  "pWSeeds", szResult, MainPipeline); PlayerInfo[extraid][pWSeeds] = strval(szResult);
					cache_get_field_content(row,  "Warrants", PlayerInfo[extraid][pWarrant], MainPipeline, 128);
					cache_get_field_content(row,  "JudgeJailTime", szResult, MainPipeline); PlayerInfo[extraid][pJudgeJailTime] = strval(szResult);
					cache_get_field_content(row,  "JudgeJailType", szResult, MainPipeline); PlayerInfo[extraid][pJudgeJailType] = strval(szResult);
					cache_get_field_content(row,  "ProbationTime", szResult, MainPipeline); PlayerInfo[extraid][pProbationTime] = strval(szResult);
					cache_get_field_content(row,  "DMKills", szResult, MainPipeline); PlayerInfo[extraid][pDMKills] = strval(szResult);
					cache_get_field_content(row,  "Order", szResult, MainPipeline); PlayerInfo[extraid][pOrder] = strval(szResult);
					cache_get_field_content(row,  "OrderConfirmed", szResult, MainPipeline); PlayerInfo[extraid][pOrderConfirmed] = strval(szResult);
					cache_get_field_content(row,  "CallsAccepted", szResult, MainPipeline); PlayerInfo[extraid][pCallsAccepted] = strval(szResult);
					cache_get_field_content(row,  "PatientsDelivered", szResult, MainPipeline); PlayerInfo[extraid][pPatientsDelivered] = strval(szResult);
					cache_get_field_content(row,  "LiveBanned", szResult, MainPipeline); PlayerInfo[extraid][pLiveBanned] = strval(szResult);
					cache_get_field_content(row,  "FreezeBank", szResult, MainPipeline); PlayerInfo[extraid][pFreezeBank] = strval(szResult);
					cache_get_field_content(row,  "FreezeHouse", szResult, MainPipeline); PlayerInfo[extraid][pFreezeHouse] = strval(szResult);
					cache_get_field_content(row,  "FreezeCar", szResult, MainPipeline); PlayerInfo[extraid][pFreezeCar] = strval(szResult);
					cache_get_field_content(row,  "Firework", szResult, MainPipeline); PlayerInfo[extraid][pFirework] = strval(szResult);
					cache_get_field_content(row,  "Boombox", szResult, MainPipeline); PlayerInfo[extraid][pBoombox] = strval(szResult);
					cache_get_field_content(row,  "Hydration", szResult, MainPipeline); PlayerInfo[extraid][pHydration] = strval(szResult);
					cache_get_field_content(row,  "Speedo", szResult, MainPipeline); PlayerInfo[extraid][pSpeedo] = strval(szResult);
					cache_get_field_content(row,  "DoubleEXP", szResult, MainPipeline); PlayerInfo[extraid][pDoubleEXP] = strval(szResult);
					cache_get_field_content(row,  "EXPToken", szResult, MainPipeline); PlayerInfo[extraid][pEXPToken] = strval(szResult);
					cache_get_field_content(row,  "RacePlayerLaps", szResult, MainPipeline); PlayerInfo[extraid][pRacePlayerLaps] = strval(szResult);
					cache_get_field_content(row,  "Ringtone", szResult, MainPipeline); PlayerInfo[extraid][pRingtone] = strval(szResult);
					cache_get_field_content(row,  "VIPM", szResult, MainPipeline); PlayerInfo[extraid][pVIPM] = strval(szResult);
					cache_get_field_content(row,  "VIPMO", szResult, MainPipeline); PlayerInfo[extraid][pVIPMO] = strval(szResult);
					cache_get_field_content(row,  "VIPExpire", szResult, MainPipeline); PlayerInfo[extraid][pVIPExpire] = strval(szResult);
					cache_get_field_content(row,  "GVip", szResult, MainPipeline); PlayerInfo[extraid][pGVip] = strval(szResult);
					cache_get_field_content(row,  "Watchdog", szResult, MainPipeline); PlayerInfo[extraid][pWatchdog] = strval(szResult);
					cache_get_field_content(row,  "VIPSold", szResult, MainPipeline); PlayerInfo[extraid][pVIPSold] = strval(szResult);
					cache_get_field_content(row,  "GoldBoxTokens", szResult, MainPipeline); PlayerInfo[extraid][pGoldBoxTokens] = strval(szResult);
					cache_get_field_content(row,  "DrawChance", szResult, MainPipeline); PlayerInfo[extraid][pRewardDrawChance] = strval(szResult);
					cache_get_field_content(row,  "RewardHours", szResult, MainPipeline); PlayerInfo[extraid][pRewardHours] = floatstr(szResult);
					cache_get_field_content(row,  "CarsRestricted", szResult, MainPipeline); PlayerInfo[extraid][pRVehRestricted] = strval(szResult);
					cache_get_field_content(row,  "LastCarWarning", szResult, MainPipeline); PlayerInfo[extraid][pLastRVehWarn] = strval(szResult);
					cache_get_field_content(row,  "CarWarns", szResult, MainPipeline); PlayerInfo[extraid][pRVehWarns] = strval(szResult);
					cache_get_field_content(row,  "Flagged", szResult, MainPipeline); PlayerInfo[extraid][pFlagged] = strval(szResult);
					cache_get_field_content(row,  "Paper", szResult, MainPipeline); PlayerInfo[extraid][pPaper] = strval(szResult);
					cache_get_field_content(row,  "MailEnabled", szResult, MainPipeline); PlayerInfo[extraid][pMailEnabled] = strval(szResult);
					cache_get_field_content(row,  "Mailbox", szResult, MainPipeline); PlayerInfo[extraid][pMailbox] = strval(szResult);
					cache_get_field_content(row,  "Business", szResult, MainPipeline); PlayerInfo[extraid][pBusiness] = strval(szResult);
					cache_get_field_content(row,  "BusinessRank", szResult, MainPipeline); PlayerInfo[extraid][pBusinessRank] = strval(szResult);
					cache_get_field_content(row,  "TreasureSkill", szResult, MainPipeline); PlayerInfo[extraid][pTreasureSkill] = strval(szResult);
					cache_get_field_content(row,  "MetalDetector", szResult, MainPipeline); PlayerInfo[extraid][pMetalDetector] = strval(szResult);
					cache_get_field_content(row,  "HelpedBefore", szResult, MainPipeline); PlayerInfo[extraid][pHelpedBefore] = strval(szResult);
					cache_get_field_content(row,  "Trickortreat", szResult, MainPipeline); PlayerInfo[extraid][pTrickortreat] = strval(szResult);
					cache_get_field_content(row,  "LastCharmReceived", szResult, MainPipeline); PlayerInfo[extraid][pLastCharmReceived] = strval(szResult);
					cache_get_field_content(row,  "RHMutes", szResult, MainPipeline); PlayerInfo[extraid][pRHMutes] = strval(szResult);
					cache_get_field_content(row,  "RHMuteTime", szResult, MainPipeline); PlayerInfo[extraid][pRHMuteTime] = strval(szResult);
					cache_get_field_content(row,  "GiftCode", szResult, MainPipeline); PlayerInfo[extraid][pGiftCode] = strval(szResult);
					cache_get_field_content(row,  "OpiumSeeds", szResult, MainPipeline); PlayerInfo[extraid][pOpiumSeeds] = strval(szResult);
					cache_get_field_content(row,  "RawOpium", szResult, MainPipeline); PlayerInfo[extraid][pRawOpium] = strval(szResult);
					cache_get_field_content(row,  "Heroin", szResult, MainPipeline); PlayerInfo[extraid][pHeroin] = strval(szResult);
					cache_get_field_content(row,  "Syringe", szResult, MainPipeline); PlayerInfo[extraid][pSyringes] = strval(szResult);
					cache_get_field_content(row,  "Skins", szResult, MainPipeline); PlayerInfo[extraid][pSkins] = strval(szResult);
					cache_get_field_content(row,  "ForcePasswordChange", szResult, MainPipeline); PlayerInfo[extraid][pForcePasswordChange] = strval(szResult);
					cache_get_field_content(row,  "Credits", szResult, MainPipeline); PlayerInfo[extraid][pCredits] = strval(szResult);
					cache_get_field_content(row,  "HealthCare", szResult, MainPipeline); PlayerInfo[extraid][pHealthCare] = strval(szResult);
					cache_get_field_content(row,  "TotalCredits", szResult, MainPipeline); PlayerInfo[extraid][pTotalCredits] = strval(szResult);
					cache_get_field_content(row,  "ReceivedCredits", szResult, MainPipeline); PlayerInfo[extraid][pReceivedCredits] = strval(szResult);
					cache_get_field_content(row,  "RimMod", szResult, MainPipeline); PlayerInfo[extraid][pRimMod] = strval(szResult);
					cache_get_field_content(row,  "Tazer", szResult, MainPipeline); PlayerInfo[extraid][pHasTazer] = strval(szResult);
					cache_get_field_content(row,  "Cuff", szResult, MainPipeline); PlayerInfo[extraid][pHasCuff] = strval(szResult);
					cache_get_field_content(row,  "CarVoucher", szResult, MainPipeline); PlayerInfo[extraid][pCarVoucher] = strval(szResult);
					cache_get_field_content(row,  "ReferredBy", PlayerInfo[extraid][pReferredBy], MainPipeline, MAX_PLAYER_NAME);
					cache_get_field_content(row,  "PendingRefReward", szResult, MainPipeline); PlayerInfo[extraid][pPendingRefReward] = strval(szResult);
					cache_get_field_content(row,  "Refers", szResult, MainPipeline); PlayerInfo[extraid][pRefers] = strval(szResult);
					cache_get_field_content(row,  "Famed", szResult, MainPipeline); PlayerInfo[extraid][pFamed] = strval(szResult);
					cache_get_field_content(row,  "FamedMuted", szResult, MainPipeline); PlayerInfo[extraid][pFMuted] = strval(szResult);
					cache_get_field_content(row,  "DefendTime", szResult, MainPipeline); PlayerInfo[extraid][pDefendTime] = strval(szResult);
					cache_get_field_content(row,  "VehicleSlot", szResult, MainPipeline); PlayerInfo[extraid][pVehicleSlot] = strval(szResult);
					cache_get_field_content(row,  "PVIPVoucher", szResult, MainPipeline); PlayerInfo[extraid][pPVIPVoucher] = strval(szResult);
					cache_get_field_content(row,  "ToySlot", szResult, MainPipeline); PlayerInfo[extraid][pToySlot] = strval(szResult);
					cache_get_field_content(row,  "VehVoucher", szResult, MainPipeline); PlayerInfo[extraid][pVehVoucher] = strval(szResult);
					cache_get_field_content(row,  "SVIPVoucher", szResult, MainPipeline); PlayerInfo[extraid][pSVIPVoucher] = strval(szResult);
					cache_get_field_content(row,  "GVIPVoucher", szResult, MainPipeline); PlayerInfo[extraid][pGVIPVoucher] = strval(szResult);
					cache_get_field_content(row,  "GiftVoucher", szResult, MainPipeline); PlayerInfo[extraid][pGiftVoucher] = strval(szResult);
					cache_get_field_content(row,  "FallIntoFun", szResult, MainPipeline); PlayerInfo[extraid][pFallIntoFun] = strval(szResult);
					cache_get_field_content(row,  "HungerVoucher", szResult, MainPipeline); PlayerInfo[extraid][pHungerVoucher] = strval(szResult);
					cache_get_field_content(row,  "BoughtCure", szResult, MainPipeline); PlayerInfo[extraid][pBoughtCure] = strval(szResult);
					cache_get_field_content(row,  "Vials", szResult, MainPipeline); PlayerInfo[extraid][pVials] = strval(szResult);
					cache_get_field_content(row,  "AdvertVoucher", szResult, MainPipeline); PlayerInfo[extraid][pAdvertVoucher] = strval(szResult);
					cache_get_field_content(row,  "ShopCounter", szResult, MainPipeline); PlayerInfo[extraid][pShopCounter] = strval(szResult);
					cache_get_field_content(row,  "ShopNotice", szResult, MainPipeline); PlayerInfo[extraid][pShopNotice] = strval(szResult);
					cache_get_field_content(row,  "SVIPExVoucher", szResult, MainPipeline); PlayerInfo[extraid][pSVIPExVoucher] = strval(szResult);
					cache_get_field_content(row,  "GVIPExVoucher", szResult, MainPipeline); PlayerInfo[extraid][pGVIPExVoucher] = strval(szResult);
					cache_get_field_content(row,  "VIPSellable", szResult, MainPipeline); PlayerInfo[extraid][pVIPSellable] = strval(szResult);
					cache_get_field_content(row,  "ReceivedPrize", szResult, MainPipeline); PlayerInfo[extraid][pReceivedPrize] = strval(szResult);

					GetPartnerName(extraid);
					IsEmailPending(extraid, PlayerInfo[extraid][pId], PlayerInfo[extraid][pEmail]);

					if(PlayerInfo[extraid][pCredits] > 0)
					{
						new szLog[128];
						format(szLog, sizeof(szLog), "(LOGIN) [User: %s(%i)] [IP: %s] [Credits: %s]", GetPlayerNameEx(extraid), PlayerInfo[extraid][pId], GetPlayerIpEx(extraid), number_format(PlayerInfo[extraid][pCredits]));
						Log("logs/logincredits.log", szLog), print(szLog);
					}

					g_mysql_LoadPVehicles(extraid);
					g_mysql_LoadPlayerToys(extraid);

					SetPVarInt(extraid, "pSQLID", PlayerInfo[extraid][pId]);
       
					//g_mysql_LoadPVehiclePositions(extraid);
					OnPlayerLoad(extraid);
                	break;
				}
			}
			return 1;
		}
 	case SENDDATA_THREAD:
		{
			if(GetPVarType(extraid, "RestartKick"))
			{
				gPlayerLogged{extraid} = 0;
				GameTextForPlayer(extraid, "Bao Tri May Chu...", 5000, 5);
				SendClientMessage(extraid, COLOR_LIGHTBLUE, "* The server will be going down for Bao Tri May Chu. A brief period of downtime will follow.");
				SendClientMessage(extraid, COLOR_GRAD2, "We will be going down to do some maintenance on the server/script, we will be back online shortly.");
				SetTimerEx("KickEx", 1000, 0, "i", extraid);

				foreach(extraid: Player) if(gPlayerLogged{extraid})
				{
					SetPVarInt(extraid, "RestartKick", 1);
					return OnPlayerStatsUpdate(extraid);
				}
				ABroadCast(COLOR_YELLOW, "{AA3333}He thong{FFFF00}: Tai khoan da duoc luu lai thanh cong!", 1);
				print("[Bao Tri] Da luu lai thong tin tai khoan thanh cong.");
				//g_mysql_DumpAccounts();

				SetTimer("FinishMaintenance", 1500, false);
			}
			if(GetPVarType(extraid, "AccountSaving") == 1 && (GetPVarInt(extraid, "AccountSaved") == 0))
			{
				SetPVarInt(extraid, "AccountSaved", 1);
				foreach(extraid: Player)
				{
					if(gPlayerLogged{extraid} > 0 && (GetPVarInt(extraid, "AccountSaved") == 0))
					{
						SetPVarInt(extraid, "AccountSaving", 1);
						SetPVarInt(extraid, "AccountSaved", 0);
						return OnPlayerStatsUpdate(extraid);
					}
				}
				//ABroadCast(COLOR_YELLOW, "{AA3333}He thong{FFFF00}: Tai khoan da duoc luu lai thanh cong!", 1);
				print("[He Thong] Da luu lai thong tin tai khoan thanh cong.");
				foreach(new i: Player)
				{
				    SetPVarInt(i, "AccountSaving", 0);
					SetPVarInt(i, "AccountSaved", 0);
				}
				//g_mysql_DumpAccounts();
			}
			return 1;
		}
		case AUTH_THREAD:
		{
			new name[24];
			for(new i;i < rows;i++)
			{
				cache_get_field_content(i, "Username", name, MainPipeline, MAX_PLAYER_NAME);
				cache_get_field_content(i,  "LastLogin", PlayerInfo[extraid][LastLogin], MainPipeline, 24);
				cache_get_field_content(i,  "RegiDate", PlayerInfo[extraid][RegiDate], MainPipeline, 24);
				if(strcmp(name, GetPlayerNameExt(extraid), true) == 0)
				{
//					HideNoticeGUIFrame(extraid);
			//		SafeLogin(extraid, 1);
					return 1;
				}
				else
				{
					return 1;
				}
			}

			//SafeLogin(extraid, 2);
			return 1;
		}
		case LOGIN_THREAD:
		{
			for(new i;i < rows;i++)
			{
				new
					szPass[129],
					szResult[129],
					szBuffer[129],
					szEmail[256];

				cache_get_field_content(i, "Username", szResult, MainPipeline);
				if(strcmp(szResult, GetPlayerNameExt(extraid), true) != 0)
				{
					//g_mysql_AccountAuthCheck(extraid);

					return 1;
				}

				cache_get_field_content(i, "Email", szEmail, MainPipeline);
				cache_get_field_content(i, "Key", szResult, MainPipeline);
				GetPVarString(extraid, "PassAuth", szBuffer, sizeof(szBuffer));
				WP_Hash(szPass, sizeof(szPass), szBuffer);

				if(isnull(szEmail)) SetPVarInt(extraid, "NullEmail", 1);

				if((isnull(szPass)) || (isnull(szResult)) || (strcmp(szPass, szResult) != 0))
				{
					// Invalid Password - Try Again!
					ShowMainMenuDialog(extraid, 3);
					// HideNoticeGUIFrame(extraid);
					if(++gPlayerLogTries[extraid] == 3)
					{
						SendClientMessage(extraid, COLOR_RED, "(SERVER) Sai mat khau, ban tu dong bi kich ra khoi may chu.");
						Kick(extraid);
					}
					return 1;
				}
				DeletePVar(extraid, "PassAuth");
				break;
			}
			// HideNoticeGUIFrame(extraid);
			g_mysql_LoadAccount(extraid);
			return 1;
		}
		case REGISTER_THREAD:
		{
			if(IsPlayerConnected(extraid))
			{
			    ShowPlayerCharacter(extraid);
			}
		}
		case LOADPTOYS_THREAD:
		{
			if(IsPlayerConnected(extraid))
			{
				new i = 0;
				while( i < rows)
				{
					if(i >= MAX_PLAYERTOYS)
						break;

					new szResult[32];

					cache_get_field_content(i, "id", szResult, MainPipeline);
					PlayerToyInfo[extraid][i][ptID] = strval(szResult);

					cache_get_field_content(i, "modelid", szResult, MainPipeline);
					PlayerToyInfo[extraid][i][ptModelID] = strval(szResult);

					if(PlayerToyInfo[extraid][i][ptModelID] != 0)
					{
						cache_get_field_content(i, "bone", szResult, MainPipeline);
						PlayerToyInfo[extraid][i][ptBone] = strval(szResult);

						if(PlayerToyInfo[extraid][i][ptBone] > 18 || PlayerToyInfo[extraid][i][ptBone] < 1) PlayerToyInfo[extraid][i][ptBone] = 1;

						cache_get_field_content(i, "tradable", szResult, MainPipeline);
						PlayerToyInfo[extraid][i][ptTradable] = strval(szResult);

						cache_get_field_content(i, "posx", szResult, MainPipeline);
						PlayerToyInfo[extraid][i][ptPosX] = floatstr(szResult);

						cache_get_field_content(i, "posy", szResult, MainPipeline);
						PlayerToyInfo[extraid][i][ptPosY] = floatstr(szResult);

						cache_get_field_content(i, "posz", szResult, MainPipeline);
						PlayerToyInfo[extraid][i][ptPosZ] = floatstr(szResult);

						cache_get_field_content(i, "rotx", szResult, MainPipeline);
						PlayerToyInfo[extraid][i][ptRotX] = floatstr(szResult);

						cache_get_field_content(i, "roty", szResult, MainPipeline);
						PlayerToyInfo[extraid][i][ptRotY] = floatstr(szResult);

						cache_get_field_content(i, "rotz", szResult, MainPipeline);
						PlayerToyInfo[extraid][i][ptRotZ] = floatstr(szResult);

						cache_get_field_content(i, "scalex", szResult, MainPipeline);
						PlayerToyInfo[extraid][i][ptScaleX] = floatstr(szResult);

						cache_get_field_content(i, "scaley", szResult, MainPipeline);
						PlayerToyInfo[extraid][i][ptScaleY] = floatstr(szResult);

						cache_get_field_content(i, "scalez", szResult, MainPipeline);
						PlayerToyInfo[extraid][i][ptScaleZ] = floatstr(szResult);

						cache_get_field_content(i, "special", szResult, MainPipeline);
						PlayerToyInfo[extraid][i][ptSpecial] = strval(szResult);

						new szLog[128];
						format(szLog, sizeof(szLog), "[TOYSLOAD] [User: %s(%i)] [Toy Model ID: %d] [Toy ID]", GetPlayerNameEx(extraid), PlayerInfo[extraid][pId], PlayerToyInfo[extraid][i][ptModelID], PlayerToyInfo[extraid][i][ptID]);
						Log("logs/toydebug.log", szLog);
					}
					else
					{
						new szQuery[128];
						format(szQuery, sizeof(szQuery), "DELETE FROM `toys` WHERE `id` = '%d'", PlayerToyInfo[extraid][i][ptID]);
						mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "i", SENDDATA_THREAD);
						printf("Deleting Toy ID %d for Player %s (%i)", PlayerToyInfo[extraid][i][ptID], GetPlayerNameEx(extraid), GetPlayerSQLId(extraid));
					}
					i++;
				}
			}
		}
		case LOADPVEHICLE_THREAD:
		{
			if(IsPlayerConnected(extraid))
			{
			    new i = 0;
				while(i < rows)
				{
				    if(i >= MAX_PLAYERVEHICLES)
						break;

				    new szResult[32];

					cache_get_field_content(i,  "pvModelId", szResult, MainPipeline);
					PlayerVehicleInfo[extraid][i][pvModelId] = strval(szResult);

					cache_get_field_content(i, "id", szResult, MainPipeline);
	    			PlayerVehicleInfo[extraid][i][pvSlotId] = strval(szResult);


					if(PlayerVehicleInfo[extraid][i][pvModelId] != 0)
					{
	
                        cache_get_field_content(i,  "pvOwnerName", PlayerVehicleInfo[extraid][i][pvOwnerName], MainPipeline);
                        cache_get_field_content(i,  "pvOwnerReg", PlayerVehicleInfo[extraid][i][pvOwnerReg], MainPipeline);
                        cache_get_field_content(i,  "pvOwnerBirth", PlayerVehicleInfo[extraid][i][pvOwnerBirth], MainPipeline);
                        
                        cache_get_field_content(i,  "pvOwnerGen", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvOwnerGen] = strval(szResult);
						
						cache_get_field_content(i,  "pvOldBuy", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvOldBuy] = strval(szResult);

						cache_get_field_content(i,  "pvSlot0", szResult, MainPipeline);		
						PlayerVehicleInfo[extraid][i][pvSlot][0] = strval(szResult);

						cache_get_field_content(i,  "pvSlot1", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvSlot][1] = strval(szResult);

						cache_get_field_content(i,  "pvSlot2", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvSlot][2] = strval(szResult);

						cache_get_field_content(i,  "pvSlot3", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvSlot][3] = strval(szResult);

						cache_get_field_content(i,  "pvSlot4", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvSlot][4] = strval(szResult);

						cache_get_field_content(i,  "pvAmount0", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvAmount][0] = strval(szResult);

						cache_get_field_content(i,  "pvAmount1", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvAmount][1] = strval(szResult);

						cache_get_field_content(i,  "pvAmount2", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvAmount][2] = strval(szResult);

						cache_get_field_content(i,  "pvAmount3", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvAmount][3] = strval(szResult);

						cache_get_field_content(i,  "pvAmount4", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvAmount][4] = strval(szResult);



						cache_get_field_content(i,  "pvMaxSpeed", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvMaxSpeed] = strval(szResult);

						cache_get_field_content(i,  "pvRegister", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvRegister] = strval(szResult);
						cache_get_field_content(i,  "pvOwnerNation", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvOwnerNation] = strval(szResult);

						cache_get_field_content(i,  "pvPosX", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvPosX] = floatstr(szResult);

						cache_get_field_content(i,  "pvPosY", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvPosY] = floatstr(szResult);

						cache_get_field_content(i,  "pvPosZ", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvPosZ] = floatstr(szResult);

						cache_get_field_content(i,  "pvPosAngle", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvPosAngle] = floatstr(szResult);

                        cache_get_field_content(i,  "lockxeshop", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvLockTrade] = strval(szResult);

						cache_get_field_content(i,  "pvLock", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvLock] = strval(szResult);

						cache_get_field_content(i,  "pvLocked", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvLocked] = strval(szResult);

						cache_get_field_content(i,  "pvPaintJob", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvPaintJob] = strval(szResult);

						cache_get_field_content(i,  "pvColor1", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvColor1] = strval(szResult);

						cache_get_field_content(i,  "pvColor2", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvColor2] = strval(szResult);

						cache_get_field_content(i,  "pvPrice", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvPrice] = strval(szResult);

						cache_get_field_content(i,  "pvTicket", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvTicket] = strval(szResult);

						cache_get_field_content(i,  "pvRestricted", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvRestricted] = strval(szResult);

						cache_get_field_content(i,  "pvWeapon0", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvWeapons][0] = strval(szResult);

						cache_get_field_content(i,  "pvWeapon1", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvWeapons][1] = strval(szResult);

						cache_get_field_content(i,  "pvWeapon2", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvWeapons][2] = strval(szResult);

						cache_get_field_content(i,  "pvWepUpgrade", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvWepUpgrade] = strval(szResult);

						cache_get_field_content(i,  "pvFuel", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvFuel] = floatstr(szResult);

						cache_get_field_content(i,  "pvHealth", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvHealth] = floatstr(szResult);
						


						cache_get_field_content(i,  "pvImpound", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvImpounded] = strval(szResult);

						cache_get_field_content(i,  "pvPlate", szResult, MainPipeline, 32);
						format(PlayerVehicleInfo[extraid][i][pvPlate], 32, "%s", szResult, MainPipeline);

						cache_get_field_content(i,  "pvVW", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvVW] = strval(szResult);

						cache_get_field_content(i,  "pvInt", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvInt] = strval(szResult);

						for(new m = 0; m < MAX_MODS; m++)
						{
		    				new szField[15];
							format(szField, sizeof(szField), "pvMod%d", m);
							cache_get_field_content(i,  szField, szResult, MainPipeline);
							PlayerVehicleInfo[extraid][i][pvMods][m] = strval(szResult);
						}

						cache_get_field_content(i,  "pvCrashFlag", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvCrashFlag] = strval(szResult);

						cache_get_field_content(i, "pvCrashVW", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvCrashVW] = strval(szResult);

						cache_get_field_content(i,  "pvCrashX", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvCrashX] = floatstr(szResult);

						cache_get_field_content(i,  "pvCrashY", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvCrashY] = floatstr(szResult);

						cache_get_field_content(i,  "pvCrashZ", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvCrashZ] = floatstr(szResult);

						cache_get_field_content(i,  "pvCrashAngle", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvCrashAngle] = floatstr(szResult);
						
                        cache_get_field_content(i,  "pvAmmos0", szResult, MainPipeline);
                        PlayerVehicleInfo[extraid][i][pvAmmos][0] = strval(szResult);

                        cache_get_field_content(i,  "pvAmmos1", szResult, MainPipeline);
                        PlayerVehicleInfo[extraid][i][pvAmmos][1] = strval(szResult);

                        cache_get_field_content(i,  "pvAmmos2", szResult, MainPipeline);
                        PlayerVehicleInfo[extraid][i][pvAmmos][2] = strval(szResult);

						new szLog[128];
						format(szLog, sizeof(szLog), "[VEHICLELOAD] [User: %s(%i)] [Model: %d] [Vehicle ID: %d]", GetPlayerNameEx(extraid), PlayerInfo[extraid][pId], PlayerVehicleInfo[extraid][i][pvModelId], PlayerVehicleInfo[extraid][i][pvSlotId]);
						Log("logs/vehicledebug.log", szLog);
					}
					else
					{
						new query[128];
						format(query, sizeof(query), "DELETE FROM `vehicles` WHERE `id` = '%d'", PlayerVehicleInfo[extraid][i][pvSlotId]);
						mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "ii", SENDDATA_THREAD, extraid);
					}
					i++;
				}
			}
		}
		case LOADPVEHPOS_THREAD:
		{
			if(IsPlayerConnected(extraid))
			{
				new bool:bVehRestore;
				for(new i;i < rows;i++)
				{
					bVehRestore = true;
					for(new v; v < MAX_PLAYERVEHICLES; v++)
					{
						new szResult[32], szPrefix[32], tmpVehModelId, Float:tmpVehArray[4];

						format(szPrefix, sizeof(szPrefix), "pv%dModelId", v);
						cache_get_field_content(i, szPrefix, szResult, MainPipeline); tmpVehModelId = strval(szResult);
						format(szPrefix, sizeof(szPrefix), "pv%dPosX", v);
						cache_get_field_content(i, szPrefix, szResult, MainPipeline); tmpVehArray[0] = floatstr(szResult);
						format(szPrefix, sizeof(szPrefix), "pv%dPosY", v);
						cache_get_field_content(i, szPrefix, szResult, MainPipeline); tmpVehArray[1] = floatstr(szResult);
						format(szPrefix, sizeof(szPrefix), "pv%dPosZ", v);
						cache_get_field_content(i, szPrefix, szResult, MainPipeline); tmpVehArray[2] = floatstr(szResult);
						format(szPrefix, sizeof(szPrefix), "pv%dPosAngle", v);
						cache_get_field_content(i, szPrefix, szResult, MainPipeline); tmpVehArray[3] = floatstr(szResult);

						if(tmpVehModelId >= 400)
						{
							printf("Stored %d Vehicle Slot", v);

							format(szPrefix, sizeof(szPrefix), "tmpVeh%dModelId", v);
							SetPVarInt(extraid, szPrefix, tmpVehModelId);

							format(szPrefix, sizeof(szPrefix), "tmpVeh%dPosX", v);
							SetPVarFloat(extraid, szPrefix, tmpVehArray[0]);

							format(szPrefix, sizeof(szPrefix), "tmpVeh%dPosY", v);
							SetPVarFloat(extraid, szPrefix, tmpVehArray[1]);

							format(szPrefix, sizeof(szPrefix), "tmpVeh%dPosZ", v);
							SetPVarFloat(extraid, szPrefix, tmpVehArray[2]);

							format(szPrefix, sizeof(szPrefix), "tmpVeh%dAngle", v);
							SetPVarFloat(extraid, szPrefix, tmpVehArray[3]);
						}
					}
					break;
				}

				if(bVehRestore == true) {
					// person Vehicle Position Restore Granted, Now Purge them from the Table.
					new query[128];
					format(query, sizeof(query), "DELETE FROM `pvehpositions` WHERE `id`='%d'", PlayerInfo[extraid][pId]);
					mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "ii", SENDDATA_THREAD, extraid);
				}

				OnPlayerLoad(extraid);
			}
		}
		case IPBAN_THREAD:
		{
		    if(rows > 0)
			{
				SendClientMessage(extraid, COLOR_RED, "IP cua ban bi cam truy cap, de mo khoa vui long truy cap dien dan: FORUM.SV.EL-RP.COM");
				SetTimerEx("KickEx", 1000, 0, "i", extraid);
			}
			else
			{
			    //g_mysql_AccountAuthCheck(extraid);
			}
		}
		case LOADCRATE_THREAD:
		{
		    for(new i; i < rows; i++)
		    {
				new crateid, szResult[32], string[128];
				cache_get_field_content(i, "id", szResult, MainPipeline); crateid = strval(szResult);
				if(crateid < MAX_CRATES)
		        {
					cache_get_field_content(i, "Active", szResult, MainPipeline); CrateInfo[crateid][crActive] = strval(szResult);
					cache_get_field_content(i, "CrateX", szResult, MainPipeline); CrateInfo[crateid][crX] = floatstr(szResult);
					cache_get_field_content(i, "CrateY", szResult, MainPipeline); CrateInfo[crateid][crY] = floatstr(szResult);
					cache_get_field_content(i, "CrateZ", szResult, MainPipeline); CrateInfo[crateid][crZ] = floatstr(szResult);
					cache_get_field_content(i, "Int", szResult, MainPipeline); CrateInfo[crateid][crInt] = strval(szResult);
					cache_get_field_content(i, "VW", szResult, MainPipeline); CrateInfo[crateid][crVW] = strval(szResult);
					cache_get_field_content(i, "PlacedBy", szResult, MainPipeline); format(CrateInfo[crateid][crPlacedBy], MAX_PLAYER_NAME, szResult);
					cache_get_field_content(i, "GunQuantity", szResult, MainPipeline); CrateInfo[crateid][GunQuantity] = strval(szResult);
					cache_get_field_content(i, "InVehicle", szResult, MainPipeline); CrateInfo[crateid][InVehicle] = strval(szResult);
					if(CrateInfo[crateid][InVehicle] != INVALID_VEHICLE_ID)
					{
					    CrateInfo[crateid][crActive] = 0;
					    CrateInfo[crateid][InVehicle] = INVALID_VEHICLE_ID;
					}
					if(CrateInfo[crateid][crActive])
					{
						CrateInfo[crateid][InVehicle] = INVALID_VEHICLE_ID;
					    CrateInfo[crateid][crObject] = CreateDynamicObject(964,CrateInfo[crateid][crX],CrateInfo[crateid][crY],CrateInfo[crateid][crZ],0.00000000,0.00000000,0.00000000,CrateInfo[i][crVW], CrateInfo[i][crInt]);
					    format(string, sizeof(string), "Serial Number: #%d\n High Grade Materials: %d/50\n (( Dropped by: %s ))", i, CrateInfo[crateid][GunQuantity], CrateInfo[crateid][crPlacedBy]);
						CrateInfo[crateid][crLabel] = CreateDynamic3DTextLabel(string, COLOR_ORANGE, CrateInfo[crateid][crX],CrateInfo[crateid][crY],CrateInfo[crateid][crZ]+1, 10.0, _, _, 1, CrateInfo[crateid][crVW], CrateInfo[crateid][crInt], _, 20.0);

					}
				}
		    }
		    print("[LoadCrates] Loading Crates Finished");
		}
		case MAIN_REFERRAL_THREAD:
		{
		    new newrows, newfields, szString[128], szQuery[128];
		    cache_get_data(newrows, newfields, MainPipeline);

		    if(newrows == 0)
		    {
		        format(szString, sizeof(szString), "Nobody");
				strmid(PlayerInfo[extraid][pReferredBy], szString, 0, strlen(szString), MAX_PLAYER_NAME);
		        ShowPlayerDialog(extraid, REGISTERREF, DIALOG_STYLE_INPUT, "{FF0000}Loi - Nguoi choi khong hop le", "Khong co nguoi choi dang ky tai may chu GvC voi ten nhu vay.\nVui long nhap ten day du nguoi choi da gioi thieu ban.\nVi du: Beo_cu, Long_Trieu", "Dong y", "Huy bo");
			}
			else {
			    format(szQuery, sizeof(szQuery), "SELECT `IP` FROM `accounts` WHERE `Username` = '%s'", PlayerInfo[extraid][pReferredBy]);
				mysql_function_query(MainPipeline, szQuery, true, "ReferralSecurity", "i", extraid);
			}
		}
		case REWARD_REFERRAL_THREAD:
		{
			new newrows, newfields;
			cache_get_data(newrows, newfields, MainPipeline);

			if(newrows != 0)
			{
			    SendClientMessageEx(extraid, COLOR_YELLOW, "Nguoi choi da gioi thieu ban tham gia khong ton tai tren he thong GvC, vi vay ho se khong nhan duoc credits gioi thieu");
			}
		}
		case OFFLINE_FAMED_THREAD:
		{
		    new newrows, newfields, szQuery[128], string[128], szName[MAX_PLAYER_NAME];
		    cache_get_data(newrows, newfields, MainPipeline);

		    if(newrows == 0)
		    {
		        SendClientMessageEx(extraid, COLOR_RED, "Error - Tai khoan khong ton tai.");
		    }
		    else {
		        new
					ilevel = GetPVarInt(extraid, "Offline_Famed");

				GetPVarString(extraid, "Offline_Name", szName, MAX_PLAYER_NAME);

		        format(szQuery, sizeof(szQuery), "UPDATE `accounts` SET `Famed` = %d WHERE `Username` = '%s'", ilevel, szName);
				mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "i", SENDDATA_THREAD);

				format(string, sizeof(string), "AdmCmd: %s has offline set %s to a level %d famed", GetPlayerNameEx(extraid), szName, ilevel);
				SendFamedMessage(COLOR_LIGHTRED, string);
				ABroadCast(COLOR_LIGHTRED, string, 2);
				Log("logs/setfamed.log", string);
				DeletePVar(extraid, "Offline_Famed");
				DeletePVar(extraid, "Offline_Name");
			}
		}
		case BUG_LIST_THREAD:
		{
			if(rows == 0) return 1;
			new szResult[MAX_PLAYER_NAME];
			for(new i; i < rows; i++)
		    {
				cache_get_field_content(i, "Username", szResult, MainPipeline); SendClientMessageEx(extraid, COLOR_GRAD2, szResult);
			}
		}
		case LOADGIFTBOX_THREAD:
		{
			for(new i; i < rows; i++)
			{
				new szResult[32], arraystring[128];
				for(new array = 0; array < 4; array++)
				{
					format(arraystring, sizeof(arraystring), "dgMoney%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgMoney[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgRimKit%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgRimKit[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgFirework%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgFirework[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgGVIP%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgGVIP[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgSVIP%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgSVIP[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgGVIPEx%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgGVIPEx[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgSVIPEx%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgSVIPEx[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgCarSlot%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgCarSlot[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgToySlot%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgToySlot[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgArmor%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgArmor[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgFirstaid%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgFirstaid[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgDDFlag%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgDDFlag[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgGateFlage%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgGateFlag[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgCredits%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgCredits[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgPriorityAd%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgPriorityAd[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgHealthNArmor%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgHealthNArmor[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgGiftReset%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgGiftReset[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgMaterial%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgMaterial[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgWarning%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgWarning[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgPot%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgPot[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgCrack%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgCrack[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgPaintballToken%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgPaintballToken[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgVIPToken%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgVIPToken[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgRespectPoint%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgRespectPoint[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgCarVoucher%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgCarVoucher[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgBuddyInvite%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgBuddyInvite[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgLaser%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgLaser[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgCustomToy%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgCustomToy[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgAdmuteReset%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgAdmuteReset[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgNewbieMuteReset%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgNewbieMuteReset[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgRestrictedCarVoucher%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgRestrictedCarVoucher[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgPlatinumVIPVoucher%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgPlatinumVIPVoucher[array] = strval(szResult);
				}
				break;
			}
			print("[Dynamic Giftbox] da tai thanh cong Dynamic giftbox.");
		}
		case LOADCP_STORE:
		{
			if(IsPlayerConnected(extraid))
			{
				new szResult[32];
				for(new i; i < rows; i++)
				{
					cache_get_field_content(i, "User_Id", szResult, MainPipeline);

					if(rows > 0)
					{
						cache_get_field_content(i, "id", szResult, MainPipeline); CpStore[extraid][cId] = strval(szResult);
						cache_get_field_content(i, "XP", szResult, MainPipeline); CpStore[extraid][cXP] = strval(szResult);
						// now lets process the data below to give to the player.
						ClaimShopItems(extraid);
					}
				}
				if(rows == 0)
				{
					SendClientMessageEx(extraid, COLOR_RED, "You have no items pending from the user control panel.");
				}
			}
			return 1;
		}
	}
	return 1;
}

public OnQueryError(errorid, error[], callback[], query[], connectionHandle)
{
	printf("[MySQL] Query Error - (ErrorID: %d) (Handle: %d)",  errorid, connectionHandle);
	print("[MySQL] Check mysql_log.txt to review the query that threw the error.");
	SQL_Log(query, error);

	if(errorid == 2013 || errorid == 2014 || errorid == 2006 || errorid == 2027 || errorid == 2055)
	{
		print("[MySQL] Connection Error Detected in Threaded Query");
		//(query, resultid, extraid, MainPipeline);
	}
}

//--------------------------------[ CUSTOM STOCK FUNCTIONS ]---------------------------

// g_mysql_Check_Store(playerid)
// Description: Checks if the player has any pending items from the ucp.
stock g_mysql_Check_Store(playerid)
{
	new string[128];
	format(string, sizeof(string), "SELECT * FROM `cp_store` WHERE `User_Id` = %d", GetPlayerSQLId(playerid));
 	mysql_function_query(MainPipeline, string, true, "OnQueryFinish", "iii", LOADCP_STORE, playerid, g_arrQueryHandle{playerid});
	return 1;
}

// g_mysql_ReturnEscaped(string unEscapedString)
// Description: Takes a unescaped string and returns an escaped one.
stock g_mysql_ReturnEscaped(unEscapedString[], connectionHandle)
{
	new EscapedString[256];
	mysql_real_escape_string(unEscapedString, EscapedString, connectionHandle);
	return EscapedString;
}

// g_mysql_AccountLoginCheck(playerid)
stock g_mysql_AccountLoginCheckzz(playerid)
{
	new string[128];
	format(string, sizeof(string), "SELECT * from masterdb WHERE acc_name = '%s'", GetPlayerNameExt(playerid));
	//mysql_function_query(MainPipeline, string, true, "OnQueryFinish", "iii", LOGIN_THREAD, playerid, g_arrQueryHandle{playerid});
	mysql_tquery(MainPipeline, string, "LOGIN_TH", "d", playerid);

	return 1;
}

forward OnCreateCharacter(playerid);
public OnCreateCharacter(playerid)
{
    if(cache_affected_rows()) {
    //	SetPlayerCameraPos(playerid, 1527.1915, -1388.5413, 405.3455);
	//	SetPlayerCameraLookAt(playerid, 1527.1210, -1389.5367, 403.4106);
	//	SetPlayerPos(playerid, 1535.3447,-1357.3451,329.4568);
  //  	ShowPlayerDialog(playerid, NOTHINGB, DIALOG_STYLE_MSGBOX, "Dang ky", "Dang ky thanh cong hay dang nhap de tiep tuc", "Tiep tuc", "");
    	SendClientMessage(playerid, COLOR_GREEN, "[REGISTER] Ban da dang ky thanh cong, hay chon nhan vat.");          

	    g_mysql_AccountLoginCheckzz(playerid);   
    } else {
        SendClientMessage(playerid, -1, "Co loi xay ra trong qua trinh tao nhan vat, vui long quay lai sau.");
        SetTimerEx("KickEx", 1000, 0, "d", playerid);
    }
}
forward LOGIN_TH(playerid);
public LOGIN_TH(playerid) {
	        new rows = cache_num_rows();
	        for(new i;i < rows;i++)
			{
				new
					szResult[129],
					szBuffer[129],
					szEmail[256];

				cache_get_field_content(i, "acc_name", szResult, MainPipeline);

				cache_get_field_content(i, "acc_name", MasterInfo[playerid][acc_name] , MainPipeline);
				if(strcmp(szResult, GetPlayerNameExt(playerid), true) != 0)
				{
					//g_mysql_AccountAuthCheck(extraid);

					return 1;
				}

                MasterInfo[playerid][acc_id] = cache_get_field_content_int(i, "acc_id", MainPipeline);
                MasterInfo[playerid][accdiscord_verify] = cache_get_field_content_int(i, "discord_verify", MainPipeline);


                cache_get_field_content(i, "discord_userid", MasterInfo[playerid][discord_userid] , MainPipeline);
                MasterInfo[playerid][accdiscord_verifyid] = cache_get_field_content_int(i, "discord_verify_id", MainPipeline);

				cache_get_field_content(i, "acc_email", szEmail, MainPipeline);
				cache_get_field_content(i, "acc_pass", szResult, MainPipeline);
				GetPVarString(playerid, "PassAuth", szBuffer, sizeof(szBuffer));

				if(isnull(szEmail)) SetPVarInt(playerid, "NullEmail", 1);

				if(strcmp(szBuffer, szResult) != 0)
				{
					// Invalid Password - Try Again!
					new string[229],ip[32];
					GetPlayerIp(playerid, ip, 32);
					format(string,sizeof (string),"{c53535}Dang nhap that bai: %d/3\n{b4b4b4}Last login: %s(%s)\nTai khoan ban da dang ky hay nhap mat khau de dang nhap:",gPlayerLogTries[playerid]+1,MasterInfo[playerid][acc_lastlogin],ip);
					ShowPlayerDialog(playerid,DANGNHAP,DIALOG_STYLE_PASSWORD,"Login",string,"Dang nhap","Thoat");
					SetPlayerCameraPos(playerid, 1527.1915, -1388.5413, 405.3455);
					SetPlayerCameraLookAt(playerid, 1527.1210, -1389.5367, 403.4106);
					SetPlayerPos(playerid, 1535.3447,-1357.3451,329.4568);					
//					HideNoticeGUIFrame(playerid);

					if(++gPlayerLogTries[playerid] == 4)
					{
						SendClientMessage(playerid, COLOR_RED, "(SERVER) Sai mat khau, ban tu dong bi kich ra khoi may chu.");
						Kick(playerid);
					}
					return 1;
				}
				DeletePVar(playerid, "PassAuth");
				break;
			}

			LoadTempCharacters(playerid);
			new years,month,day,hourz,minz,sec,time[50];
			getdate(years,month,day);
			gettime(hourz,minz,sec);
			format(time, sizeof time , "%d/%d/%d %d:%d:%d",day,month,years,hourz,minz,sec);
			if(sec < 10) {
				format(time, sizeof time , "%d/%d/%d %d:%d:0%d",day,month,years,hourz,minz,sec);
			}
			new query[300];
			format(query, sizeof(query), "UPDATE `masterdb` SET `acc_lastlogin` = '%s' WHERE `acc_id` = '%d'", time, MasterInfo[playerid][acc_id]);
	        mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
			return 1;
}

LoadTempCharacters(playerid)
{
    new query[128]; // SPos_x , SPos_y, SPos_z,
    mysql_format(MainPipeline,query, sizeof query, "select id, SPos_x , SPos_y, SPos_z, `LastLogin`,`Regidate`, `UserName`, `Model`, `Level` from accounts where master_id=%d ", MasterInfo[playerid][acc_id]);
    mysql_tquery(MainPipeline, query, "OnLoadTempCharacters", "d", playerid);

  //  new str[129];
//	mysql_format(MainPipeline, str, sizeof(str), "UPDATE masterdb SET Online = 1 WHERE acc_id = %i", MasterInfo[playerid][acc_id]);
//	mysql_pquery(MainPipeline, str);

    return 1;
}
forward OnLoadTempCharacters(playerid);
public OnLoadTempCharacters(playerid) {
	new rows = cache_num_rows();
    printf("rows %d ", rows);
    if(rows)
    {
        for(new i=0; i<rows; i++)
        {      
            if(TempCharacter[playerid][i][SqlID] != cache_get_field_content_int(i, "id", MainPipeline))
            {
            	cache_get_field_content(i, "UserName",  TempCharacter[playerid][i][Name], MainPipeline, 24);
            	printf("name load duoc la :v %s", TempCharacter[playerid][i][Name]);
            	TempCharacter[playerid][i][SPos_x] = cache_get_field_content_float(i, "SPos_x", MainPipeline);
            	TempCharacter[playerid][i][SPos_y] = cache_get_field_content_float(i, "SPos_y", MainPipeline);
            	TempCharacter[playerid][i][SPos_z] = cache_get_field_content_float(i, "SPos_z", MainPipeline);
                TempCharacter[playerid][i][SqlID] = cache_get_field_content_int(i, "id", MainPipeline);
                TempCharacter[playerid][i][Lv] = cache_get_field_content_int(i, "Level", MainPipeline);
                TempCharacter[playerid][i][Skin] = cache_get_field_content_int(i, "Model", MainPipeline);
				cache_get_field_content(i, "LastLogin",  TempCharacter[playerid][i][pLastOnline], MainPipeline, 34);
				cache_get_field_content(i, "Regidate",  TempCharacter[playerid][i][pRegidate], MainPipeline, 34);
                TempCharacter[playerid][i][IsCreated] = true;
            }
            ShowPlayerCharacter(playerid);
        }
    }
    else
    {
    	ShowPlayerCharacter(playerid);
    	print("Khong tai duoc tai khoan chinh cua ban");

    }
}
// stock ShowPlayerCharacter(playerid) {
// 	new string[300];
// 	for(new i = 0 ; i < 4 ; i++) {
// 		if(TempCharacter[playerid][i][IsCreated])
//     	{
//     		format(string, sizeof(string), "%s\n[Character %d] %s", string,i,TempCharacter[playerid][i][Name]);
//     	}
//     	else if(!TempCharacter[playerid][i][IsCreated]) {
//     		new sgb[32];
//     		format(sgb, sizeof(sgb), "\n[Character %d] Chua khoi tao",i);
//     		strcat(string, sgb);
//     	}
// 	}
// 	SetPlayerCameraPos(playerid, 2301.3403, -1301.3948, 52.4688);
// 	SetPlayerCameraLookAt(playerid, 2300.3408, -1301.4949, 52.1188);
// 	SetPlayerPos(playerid, 2234.2881,-1329.2982,24.5313);
// 	ShowPlayerDialog(playerid, DIALOG_NHANVAT, DIALOG_STYLE_LIST, "Hay chon nhan vat cua ban", string, "Tuy chon", "Huy bo");
// }
stock ShowPlayerCharacter(playerid) {
	new string[129];
	DeletePVar(playerid, "IsSelected");
	for(new i = 0 ; i < 3 ; i++) {
		if(TempCharacter[playerid][i][IsCreated])
    	{
    		PlayerTextDrawSetPreviewModel(playerid, Character_Slot[playerid][i], TempCharacter[playerid][i][Skin]);
    		PlayerTextDrawSetPreviewRot(playerid, Character_Slot[playerid][i], 0.0000, 0.0000, 0.0000, 1.0000);

    		format(string, sizeof(string), "%s",TempCharacter[playerid][i][Name]);
    		PlayerTextDrawSetString(playerid,Character_Text[playerid][i], string);
    		PlayerTextDrawShow(playerid, Character_Slot[playerid][i]);
    		PlayerTextDrawShow(playerid, Character_Text[playerid][i]);
    	}
    	else if(!TempCharacter[playerid][i][IsCreated]) {
    		PlayerTextDrawSetPreviewModel(playerid, Character_Slot[playerid][i], 0);
    		PlayerTextDrawSetPreviewRot(playerid, Character_Slot[playerid][i], 0.0000, 0.0000, 0.0000, 100.0000);
    		string = "Chua_khoi_tao";
    		PlayerTextDrawSetString(playerid,Character_Text[playerid][i], string);
    		PlayerTextDrawShow(playerid, Character_Slot[playerid][i]);
    		PlayerTextDrawShow(playerid, Character_Text[playerid][i]);
    	}
	}
	

	SetPlayerCameraPos(playerid, 2048.162841, -1750.577026, 32.237125);
	SetPlayerCameraLookAt(playerid, 2053.019531, -1750.214965, 31.105102);
	SetPlayerPos(playerid, 2053.019531, -1750.214965, 4.105102);
	SetPlayerVirtualWorld(playerid, playerid+2);
	for(new i = 0; i < 5 ; i++) PlayerTextDrawShow(playerid, Character_Main[playerid][i]);
	SelectTextDraw(playerid, COLOR_LIGHTRED);
    return 1;
}

// g_mysql_AccountAuthCheck(playerid)
g_mysql_AccountAuthCheck(playerid)
{
	new string[128];
	format(string, sizeof(string), "SELECT * FROM masterdb WHERE acc_name = '%s'", GetPlayerNameExt(playerid));
//	mysql_function_query(MainPipeline, string, true, "OnQueryFinish", "iii", AUTH_THREAD, playerid, g_arrQueryHandle{playerid});
	mysql_tquery(MainPipeline, string, "AUTH_TH", "d", playerid);
	ClearChatbox(playerid);
	SetPlayerVirtualWorld(playerid, 0);
	return 1;
}
forward AUTH_TH(playerid);
public AUTH_TH(playerid) {
	new name[24];
	new rows = cache_num_rows();
	for(new i;i < rows;i++)
	{
		cache_get_field_content(i, "acc_name", name, MainPipeline, MAX_PLAYER_NAME);
		cache_get_field_content(i, "acc_name", MasterInfo[playerid][acc_name], MainPipeline, MAX_PLAYER_NAME);
		cache_get_field_content(i,  "acc_pass", MasterInfo[playerid][acc_id], MainPipeline, 24);
		cache_get_field_content(i,  "acc_lastlogin", MasterInfo[playerid][acc_lastlogin], MainPipeline, 24);
		cache_get_field_content(i,  "acc_regidate", MasterInfo[playerid][acc_regidate], MainPipeline, 24);
		printf("name %s,%s",name, MasterInfo[playerid][acc_lastlogin]);
		if(strcmp(name, GetPlayerNameExt(playerid), true) == 0)
		{
			// HideNoticeGUIFrame(playerid);
			SafeLogin(playerid, 1);
			return 1;
		}
		else
		{
			return 1;
		}
	}
	// HideNoticeGUIFrame(playerid);
	SafeLogin(playerid, 2);
	return 1;
}
// g_mysql_AccountOnline(int playerid, int stateid)
stock g_mysql_AccountOnline(playerid, stateid)
{
	new string[128];
	format(string, sizeof(string), "UPDATE `accounts` SET `Online`=%d, `LastLogin` = NOW() WHERE `id` = %d", stateid, GetPlayerSQLId(playerid));
	mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
	return 1;
}

stock g_mysql_AccountOnlineReset()
{
	new string[128];
	format(string, sizeof(string), "UPDATE `accounts` SET `Online` = 0 WHERE `Online` = %d", servernumber);
	mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	return 1;
}

// g_mysql_CreateAccount(int playerid, string accountPassword[])
// Description: Creates a new account in the database.
stock g_mysql_CreateAccountzz(playerid, name[])
{
	new string[256];
	new passbuffer[129];
    passbuffer = "lsrvn";
	format(string, sizeof(string), "INSERT INTO `accounts` (`master_id`,`RegiDate`, `LastLogin`, `Username`, `Key`) VALUES ('%d', NOW(), NOW(), '%s','%s')",MasterInfo[playerid][acc_id],name, passbuffer);
	mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "iii", REGISTER_THREAD, playerid, g_arrQueryHandle{playerid});
	return 1;
}
stock g_mysql_CreateAccount(playerid, accountPassword[])
{
	new string[256];
	new passbuffer[129];
	WP_Hash(passbuffer, sizeof(passbuffer), accountPassword);

	format(string, sizeof(string), "INSERT INTO `accounts` (`RegiDate`, `LastLogin`, `Username`, `Key`) VALUES (NOW(), NOW(), '%s','%s')", GetPlayerNameExt(playerid), passbuffer);
	mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "iii", REGISTER_THREAD, playerid, g_arrQueryHandle{playerid});
	new ip[32], vuadangky[240];
	GetPlayerIp(playerid, ip, sizeof(ip));
	format(vuadangky, sizeof(vuadangky), "Luu Y: %s (ID: %d, IP: %s) vua dang ky tham gia game", GetPlayerNameEx(playerid), playerid, ip);
	foreach(new i: Player)
	{
 		if(PlayerInfo[i][pAdmin] >= 2)
   		{
     		SendClientMessage(i, COLOR_YELLOW, vuadangky);
	    }
	}
	return 1;
}

stock g_mysql_LoadPVehicles(playerid)
{
    new string[128];
	format(string, sizeof(string), "SELECT * FROM `vehicles` WHERE `sqlID` = %d", PlayerInfo[playerid][pId]);
	mysql_function_query(MainPipeline, string, true, "OnQueryFinish", "iii", LOADPVEHICLE_THREAD, playerid, g_arrQueryHandle{playerid});
	return 1;
}

// g_mysql_LoadPVehiclePositions(playerid)
// Description: Loads vehicle positions if person has timed out.
stock g_mysql_LoadPVehiclePositions(playerid)
{
	new string[128];

	format(string, sizeof(string), "SELECT * FROM `pvehpositions` WHERE `id` = %d", PlayerInfo[playerid][pId]);
	mysql_function_query(MainPipeline, string, true, "OnQueryFinish", "iii", LOADPVEHPOS_THREAD, playerid, g_arrQueryHandle{playerid});
	return 1;
}

// g_mysql_LoadPlayerToys(playerid)
// Description: Load the player toys
stock g_mysql_LoadPlayerToys(playerid)
{
	new szQuery[128];
	format(szQuery, sizeof(szQuery), "SELECT * FROM `toys` WHERE `player` = %d", PlayerInfo[playerid][pId]);
	mysql_function_query(MainPipeline, szQuery, true, "OnQueryFinish", "iii", LOADPTOYS_THREAD, playerid, g_arrQueryHandle{playerid});
	return 1;
}

// g_mysql_LoadAccount(playerid)
// Description: Loads an account from database into memory.
stock g_mysql_LoadAccount(playerid)
{


	new string[164];
	format(string, sizeof(string), "SELECT * FROM `accounts` WHERE `Username` = '%s'", GetPlayerNameExt(playerid));
 	mysql_function_query(MainPipeline, string, true, "OnQueryFinish", "iii", LOADUSERDATA_THREAD, playerid, g_arrQueryHandle{playerid});
	return 1;
}

// g_mysql_RemoveDumpFile(sqlid)
// Description: Removes a account's dump file. Helpful upon logoff.
stock g_mysql_RemoveDumpFile(sqlid)
{
	new pwnfile[128];
	format(pwnfile, sizeof(pwnfile), "/accdump/%d.dump", sqlid);

	if(fexist(pwnfile))
	{
		fremove(pwnfile);
		return 1;
	}
	return 0;
}

GivePlayerCredits(Player, Amount, Shop)
{
	new szQuery[128];
	PlayerInfo[Player][pGcoin] += Amount;

	format(szQuery, sizeof(szQuery), "UPDATE `accounts` SET ``=%d WHERE `id` = %d", PlayerInfo[Player][pGcoin], GetPlayerSQLId(Player));
	mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "ii", SENDDATA_THREAD, Player);
	print(szQuery);

	if(Shop == 1)
	{
    	if(Amount < 0) Amount = Amount*-1;
	}

	format(szQuery, sizeof(szQuery), "UPDATE `accounts` SET `TotalCredits`=%d WHERE `id` = %d", PlayerInfo[Player][pTotalCredits], GetPlayerSQLId(Player));
	mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "ii", SENDDATA_THREAD, Player);
	print(szQuery);
}

// g_mysql_SaveVehicle(int playerid, int slotid)
// Description: Saves a account's specified vehicle slot.pvAmount8
stock g_mysql_SaveVehicle(playerid, slotid)
{
	new query[3548];
	printf("%s (%i) saving their %d (slot %i) (Model %i)...", GetPlayerNameEx(playerid), playerid, PlayerVehicleInfo[playerid][slotid][pvModelId], slotid, PlayerVehicleInfo[playerid][slotid][pvModelId]);
	


	format(query, sizeof(query), "UPDATE `vehicles` SET");
	format(query, sizeof(query), "%s `pvOwnerName` = '%s',", query, PlayerVehicleInfo[playerid][slotid][pvOwnerName]);
	format(query, sizeof(query), "%s `pvOwnerReg` = '%s',", query, PlayerVehicleInfo[playerid][slotid][pvOwnerReg]);
	format(query, sizeof(query), "%s `pvOwnerBirth` = '%s',", query, PlayerVehicleInfo[playerid][slotid][pvOwnerBirth]);
	format(query, sizeof(query), "%s `pvOwnerGen` = '%d',", query, PlayerVehicleInfo[playerid][slotid][pvOwnerGen]);
	format(query, sizeof(query), "%s `pvOwnerNation` = '%d',", query, PlayerVehicleInfo[playerid][slotid][pvOwnerNation]);
	format(query, sizeof(query), "%s `pvRegister` = '%d',", query, PlayerVehicleInfo[playerid][slotid][pvRegister]);
	format(query, sizeof(query), "%s `pvOldBuy` = '%d',", query, PlayerVehicleInfo[playerid][slotid][pvOldBuy]);
	format(query, sizeof(query), "%s `pvMaxSpeed` = '%d',", query, PlayerVehicleInfo[playerid][slotid][pvMaxSpeed]);

	format(query, sizeof(query), "%s `pvSlot0` = '%d',", query, PlayerVehicleInfo[playerid][slotid][pvSlot][0]);
	format(query, sizeof(query), "%s `pvSlot1` = '%d',", query, PlayerVehicleInfo[playerid][slotid][pvSlot][1]);
	format(query, sizeof(query), "%s `pvSlot2` = '%d',", query, PlayerVehicleInfo[playerid][slotid][pvSlot][2]);
	format(query, sizeof(query), "%s `pvSlot3` = '%d',", query, PlayerVehicleInfo[playerid][slotid][pvSlot][3]);
	format(query, sizeof(query), "%s `pvSlot4` = '%d',", query, PlayerVehicleInfo[playerid][slotid][pvSlot][4]);

	format(query, sizeof(query), "%s `pvAmount0` = '%d',", query, PlayerVehicleInfo[playerid][slotid][pvAmount][0]);
	format(query, sizeof(query), "%s `pvAmount1` = '%d',", query, PlayerVehicleInfo[playerid][slotid][pvAmount][1]);
	format(query, sizeof(query), "%s `pvAmount2` = '%d',", query, PlayerVehicleInfo[playerid][slotid][pvAmount][2]);
	format(query, sizeof(query), "%s `pvAmount3` = '%d',", query, PlayerVehicleInfo[playerid][slotid][pvAmount][3]);
	format(query, sizeof(query), "%s `pvAmount4` = '%d',", query, PlayerVehicleInfo[playerid][slotid][pvAmount][4]);


	format(query, sizeof(query), "%s `pvHealth` = %0.5f,", query, PlayerVehicleInfo[playerid][slotid][pvHealth]);

	format(query, sizeof(query), "%s `pvPosX` = %0.5f,", query, PlayerVehicleInfo[playerid][slotid][pvPosX]);
	format(query, sizeof(query), "%s `pvPosY` = %0.5f,", query, PlayerVehicleInfo[playerid][slotid][pvPosY]);
	format(query, sizeof(query), "%s `pvPosZ` = %0.5f,", query, PlayerVehicleInfo[playerid][slotid][pvPosZ]);
	format(query, sizeof(query), "%s `pvPosAngle` = %0.5f,", query, PlayerVehicleInfo[playerid][slotid][pvPosAngle]);
	format(query, sizeof(query), "%s `pvLock` = %d,", query, PlayerVehicleInfo[playerid][slotid][pvLock]);
	format(query, sizeof(query), "%s `pvLocked` = %d,", query, PlayerVehicleInfo[playerid][slotid][pvLocked]);
	format(query, sizeof(query), "%s `pvPaintJob` = %d,", query, PlayerVehicleInfo[playerid][slotid][pvPaintJob]);
	format(query, sizeof(query), "%s `pvColor1` = %d,", query, PlayerVehicleInfo[playerid][slotid][pvColor1]);
	format(query, sizeof(query), "%s `pvColor2` = %d,", query, PlayerVehicleInfo[playerid][slotid][pvColor2]);
	format(query, sizeof(query), "%s `pvPrice` = %d,", query, PlayerVehicleInfo[playerid][slotid][pvPrice]);
	format(query, sizeof(query), "%s `pvWeapon0` = %d,", query, PlayerVehicleInfo[playerid][slotid][pvWeapons][0]);
	format(query, sizeof(query), "%s `pvWeapon1` = %d,", query, PlayerVehicleInfo[playerid][slotid][pvWeapons][1]);
	format(query, sizeof(query), "%s `pvWeapon2` = %d,", query, PlayerVehicleInfo[playerid][slotid][pvWeapons][2]);
	format(query, sizeof(query), "%s `pvAmmos0` = %d,", query, PlayerVehicleInfo[playerid][slotid][pvAmmos][0]);
    format(query, sizeof(query), "%s `pvAmmos1` = %d,", query, PlayerVehicleInfo[playerid][slotid][pvAmmos][1]);
    format(query, sizeof(query), "%s `pvAmmos2` = %d,", query, PlayerVehicleInfo[playerid][slotid][pvAmmos][2]);
	format(query, sizeof(query), "%s `pvWeapon0` = %d,", query, PlayerVehicleInfo[playerid][slotid][pvWeapons][0]);
	format(query, sizeof(query), "%s `pvWeapon1` = %d,", query, PlayerVehicleInfo[playerid][slotid][pvWeapons][1]);
	format(query, sizeof(query), "%s `pvWeapon2` = %d,", query, PlayerVehicleInfo[playerid][slotid][pvWeapons][2]);
	format(query, sizeof(query), "%s `pvLock` = %d,", query, PlayerVehicleInfo[playerid][slotid][pvLock]);
	format(query, sizeof(query), "%s `pvWepUpgrade` = %d,", query, PlayerVehicleInfo[playerid][slotid][pvWepUpgrade]);
	format(query, sizeof(query), "%s `pvFuel` = %0.5f,", query, PlayerVehicleInfo[playerid][slotid][pvFuel]);
	format(query, sizeof(query), "%s `pvImpound` = %d,", query, PlayerVehicleInfo[playerid][slotid][pvImpounded]);
	format(query, sizeof(query), "%s `pvDisabled` = %d,", query, PlayerVehicleInfo[playerid][slotid][pvDisabled]);
	format(query, sizeof(query), "%s `pvPlate` = '%s',", query, g_mysql_ReturnEscaped(PlayerVehicleInfo[playerid][slotid][pvPlate], MainPipeline));
	format(query, sizeof(query), "%s `pvTicket` = %d,", query, PlayerVehicleInfo[playerid][slotid][pvTicket]);
	format(query, sizeof(query), "%s `pvRestricted` = %d,", query, PlayerVehicleInfo[playerid][slotid][pvRestricted]);
	format(query, sizeof(query), "%s `pvVW` = %d,", query, PlayerVehicleInfo[playerid][slotid][pvVW]);
	format(query, sizeof(query), "%s `pvInt` = %d,", query, PlayerVehicleInfo[playerid][slotid][pvInt]);
	format(query, sizeof(query), "%s `pvCrashFlag` = %d,", query, PlayerVehicleInfo[playerid][slotid][pvCrashFlag]);
	format(query, sizeof(query), "%s `pvCrashVW` = %d,", query, PlayerVehicleInfo[playerid][slotid][pvCrashVW]);
	format(query, sizeof(query), "%s `pvCrashX` = %0.5f,", query, PlayerVehicleInfo[playerid][slotid][pvCrashX]);
	format(query, sizeof(query), "%s `pvCrashY` = %0.5f,", query, PlayerVehicleInfo[playerid][slotid][pvCrashY]);
	format(query, sizeof(query), "%s `pvCrashZ` = %0.5f,", query, PlayerVehicleInfo[playerid][slotid][pvCrashZ]);
	format(query, sizeof(query), "%s `pvCrashAngle` = %0.5f,", query, PlayerVehicleInfo[playerid][slotid][pvCrashAngle]);

	for(new m = 0; m < MAX_MODS; m++)
	{
		if(m == MAX_MODS-1)
		{
			format(query, sizeof(query), "%s `pvMod%d` = %d WHERE `id` = '%d'", query, m, PlayerVehicleInfo[playerid][slotid][pvMods][m], PlayerVehicleInfo[playerid][slotid][pvSlotId]);
		}
		else
		{
			format(query, sizeof(query), "%s `pvMod%d` = %d,", query, m, PlayerVehicleInfo[playerid][slotid][pvMods][m]);
		}
	}
    //print(query);

	new szLog[128];
	format(szLog, sizeof(szLog), "[VEHICLESAVE] [User: %s(%i)] [Model: %d] [Vehicle ID: %d]", GetPlayerNameEx(playerid), PlayerInfo[playerid][pId], PlayerVehicleInfo[playerid][slotid][pvModelId], PlayerVehicleInfo[playerid][slotid][pvSlotId]);
	Log("logs/vehicledebug.log", szLog);

	mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
}

// native g_mysql_SaveToys(int playerid, int slotid)
stock g_mysql_SaveToys(playerid, slotid)
{
	new szQuery[2048];

	if(PlayerToyInfo[playerid][slotid][ptID] >= 1) // Making sure the player actually has a toy so we won't save a empty row
	{
		//printf("%s (%i) saving toy %i...", GetPlayerNameEx(playerid), playerid, slotid);

		format(szQuery, sizeof(szQuery), "UPDATE `toys` SET `modelid` = '%d', `bone` = '%d', `posx` = '%f', `posy` = '%f', `posz` = '%f', `rotx` = '%f', `roty` = '%f', `rotz` = '%f', `scalex` = '%f', `scaley` = '%f', `scalez` = '%f', `tradable` = '%d' WHERE `id` = '%d'",
		PlayerToyInfo[playerid][slotid][ptModelID],
		PlayerToyInfo[playerid][slotid][ptBone],
		PlayerToyInfo[playerid][slotid][ptPosX],
		PlayerToyInfo[playerid][slotid][ptPosY],
		PlayerToyInfo[playerid][slotid][ptPosZ],
		PlayerToyInfo[playerid][slotid][ptRotX],
		PlayerToyInfo[playerid][slotid][ptRotY],
		PlayerToyInfo[playerid][slotid][ptRotZ],
		PlayerToyInfo[playerid][slotid][ptScaleX],
		PlayerToyInfo[playerid][slotid][ptScaleY],
		PlayerToyInfo[playerid][slotid][ptScaleZ],
		PlayerToyInfo[playerid][slotid][ptTradable],
		PlayerToyInfo[playerid][slotid][ptID]);

		mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
	}
}

// native g_mysql_NewToy(int playerid, int slotid)
stock g_mysql_NewToy(playerid, slotid)
{
	new szQuery[2048];
	if(PlayerToyInfo[playerid][slotid][ptSpecial] != 1) { PlayerToyInfo[playerid][slotid][ptSpecial] = 0; }

	format(szQuery, sizeof(szQuery), "INSERT INTO `toys` (player, modelid, bone, posx, posy, posz, rotx, roty, rotz, scalex, scaley, scalez, tradable, special) VALUES ('%d', '%d', '%d', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%d', '%d')",
	PlayerInfo[playerid][pId],
	PlayerToyInfo[playerid][slotid][ptModelID],
	PlayerToyInfo[playerid][slotid][ptBone],
	PlayerToyInfo[playerid][slotid][ptPosX],
	PlayerToyInfo[playerid][slotid][ptPosY],
	PlayerToyInfo[playerid][slotid][ptPosZ],
	PlayerToyInfo[playerid][slotid][ptRotX],
	PlayerToyInfo[playerid][slotid][ptRotY],
	PlayerToyInfo[playerid][slotid][ptRotZ],
	PlayerToyInfo[playerid][slotid][ptScaleX],
	PlayerToyInfo[playerid][slotid][ptScaleY],
	PlayerToyInfo[playerid][slotid][ptScaleZ],
	PlayerToyInfo[playerid][slotid][ptTradable],
	PlayerToyInfo[playerid][slotid][ptSpecial]);

	mysql_function_query(MainPipeline, szQuery, true, "OnQueryCreateToy", "ii", playerid, slotid);
}

// g_mysql_LoadMOTD()
// Description: Loads the MOTDs from the MySQL Database.
stock g_mysql_LoadMOTD()
{
	mysql_function_query(MainPipeline, "SELECT `gMOTD`,`aMOTD`,`vMOTD`,`cMOTD`,`pMOTD`,`ShopTechPay`,`GiftCode`,`GiftCodeBypass`,`TotalCitizens`,`TRCitizens`,`SecurityCode`,`ShopClosed`,`RimMod`,`CarVoucher`,`PVIPVoucher`, `GarageVW`, `PumpkinStock`, `HalloweenShop` FROM `misc`", true, "OnQueryFinish", "iii", LOADMOTDDATA_THREAD, INVALID_PLAYER_ID, -1);
}

stock g_mysql_LoadSales()
{
	mysql_function_query(MainPipeline, "SELECT * FROM `sales` WHERE `Month` > NOW() - INTERVAL 1 MONTH", true, "OnQueryFinish", "iii", LOADSALEDATA_THREAD, INVALID_PLAYER_ID, -1);
	//mysql_function_query(MainPipeline, "SELECT `TotalToySales`,`TotalCarSales`,`GoldVIPSales`,`SilverVIPSales`,`BronzeVIPSales` FROM `sales` WHERE `Month` > NOW() - INTERVAL 1 MONTH", true, "OnQueryFinish", "iii", LOADSALEDATA_THREAD, INVALID_PLAYER_ID, -1);
}

stock g_mysql_LoadPrices()
{
    mysql_function_query(MainPipeline, "SELECT * FROM `shopprices`", true, "OnQueryFinish", "iii", LOADSHOPDATA_THREAD, INVALID_PLAYER_ID, -1);
}

g_mysql_SavePrices()
{
	new query[2000];
	format(query, sizeof(query), "UPDATE `shopprices` SET `Price0` = '%d', `Price1` = '%d', `Price2` = '%d', `Price3` = '%d', `Price4` = '%d', `Price5` = '%d', `Price6` = '%d', `Price7` = '%d', `Price8` = '%d', `Price9` = '%d', `Price10` = '%d', \
	`Price11` = '%d', `Price12` = '%d', `Price13` = '%d', `Price14` = '%d', `Price15` = '%d', `Price16` = '%d', `Price17` = '%d',", ShopItems[0][sItemPrice], ShopItems[1][sItemPrice], ShopItems[2][sItemPrice], ShopItems[3][sItemPrice], ShopItems[4][sItemPrice],
	 ShopItems[5][sItemPrice], ShopItems[6][sItemPrice], ShopItems[7][sItemPrice], ShopItems[8][sItemPrice], ShopItems[9][sItemPrice], ShopItems[10][sItemPrice], ShopItems[11][sItemPrice], ShopItems[12][sItemPrice], ShopItems[13][sItemPrice], ShopItems[14][sItemPrice], ShopItems[15][sItemPrice],
  	ShopItems[16][sItemPrice], ShopItems[17][sItemPrice]);
	format(query, sizeof(query), "%s `Price18` = '%d', `Price19` = '%d', `Price20` = '%d', `Price21` = '%d', `Price22` = '%d', `Price23` = '%d', `Price24` = '%d', `Price25` = '%d', `Price26` = '%d', `Price27` = '%d', `Price28` = '%d'", query, ShopItems[18][sItemPrice], ShopItems[19][sItemPrice], ShopItems[20][sItemPrice], ShopItems[21][sItemPrice],
	ShopItems[22][sItemPrice], ShopItems[23][sItemPrice], ShopItems[24][sItemPrice], ShopItems[25][sItemPrice], ShopItems[26][sItemPrice], ShopItems[27][sItemPrice], ShopItems[28][sItemPrice]);
    mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
}

stock g_mysql_SaveMOTD()
{
	new query[1024];

	format(query, sizeof(query), "UPDATE `misc` SET ");

	format(query, sizeof(query), "%s `gMOTD` = '%s',", query, g_mysql_ReturnEscaped(GlobalMOTD, MainPipeline));
	format(query, sizeof(query), "%s `aMOTD` = '%s',", query, g_mysql_ReturnEscaped(AdminMOTD, MainPipeline));
	format(query, sizeof(query), "%s `vMOTD` = '%s',", query, g_mysql_ReturnEscaped(VIPMOTD, MainPipeline));
	format(query, sizeof(query), "%s `cMOTD` = '%s',", query, g_mysql_ReturnEscaped(CAMOTD, MainPipeline));
	format(query, sizeof(query), "%s `pMOTD` = '%s',", query, g_mysql_ReturnEscaped(pMOTD, MainPipeline));
	format(query, sizeof(query), "%s `ShopTechPay` = '%.2f',", query, ShopTechPay);
	format(query, sizeof(query), "%s `GiftCode` = '%s',", query, g_mysql_ReturnEscaped(GiftCode, MainPipeline));
	format(query, sizeof(query), "%s `GiftCodeBypass` = '%d',", query, GiftCodeBypass);
	format(query, sizeof(query), "%s `TotalCitizens` = '%d',", query, TotalCitizens);
	format(query, sizeof(query), "%s `TRCitizens` = '%d',", query, TRCitizens);
	format(query, sizeof(query), "%s `ShopClosed` = '%d',", query, ShopClosed);
	format(query, sizeof(query), "%s `RimMod` = '%d',", query, RimMod);
	format(query, sizeof(query), "%s `CarVoucher` = '%d',", query, CarVoucher);
	format(query, sizeof(query), "%s `PVIPVoucher` = '%d',", query, PVIPVoucher);
	format(query, sizeof(query), "%s `GarageVW` = '%d',", query, GarageVW);
	format(query, sizeof(query), "%s `PumpkinStock` = '%d',", query, PumpkinStock);
	format(query, sizeof(query), "%s `HalloweenShop` = '%d'", query, HalloweenShop);

	mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
}

// g_mysql_LoadMOTD()
// Description: Loads the Crates from the MySQL Database.
stock mysql_LoadCrates()
{
	mysql_function_query(MainPipeline, "SELECT * FROM `crates`", true, "OnQueryFinish", "iii", LOADCRATE_THREAD, INVALID_PLAYER_ID, -1);
    print("[LoadCrates] Load Query Sent");
}

stock mysql_SaveCrates()
{
	new query[1024];
	for(new i; i < MAX_CRATES; i++)
	{
		printf("Saving Crate %d", i);
		format(query, sizeof(query), "UPDATE `crates` SET ");

		format(query, sizeof(query), "%s `Active` = '%d',", query, CrateInfo[i][crActive]);
		format(query, sizeof(query), "%s `CrateX` = '%.2f',", query, CrateInfo[i][crX]);
		format(query, sizeof(query), "%s `CrateY` = '%.2f',", query, CrateInfo[i][crY]);
		format(query, sizeof(query), "%s `CrateZ` = '%.2f',", query, CrateInfo[i][crZ]);
		format(query, sizeof(query), "%s `GunQuantity` = '%d',", query, CrateInfo[i][GunQuantity]);
		format(query, sizeof(query), "%s `InVehicle` = '%d',", query, CrateInfo[i][InVehicle]);
		format(query, sizeof(query), "%s `Int` = '%d',", query, CrateInfo[i][crInt]);
		format(query, sizeof(query), "%s `VW` = '%d',", query, CrateInfo[i][crVW]);
		format(query, sizeof(query), "%s `PlacedBy` = '%s'", query, CrateInfo[i][crPlacedBy]);
		format(query, sizeof(query), "%s WHERE id = %d", query, i);

		mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	}
}

stock RemoveBan(Player, Ip[])
{
	new string[128];
	SetPVarString(Player, "UnbanIP", Ip);
	format(string, sizeof(string), "SELECT `ip` FROM `ip_bans` WHERE `ip` = '%s'", Ip);
	mysql_function_query(MainPipeline, string, true, "AddingBan", "ii", Player, 2);
	return 1;
}

stock CheckBanEx(playerid)
{
	new string[60];
	format(string, sizeof(string), "SELECT `ip` FROM `ip_bans` WHERE `ip` = '%s'", GetPlayerIpEx(playerid));
	mysql_function_query(MainPipeline, string, true, "OnQueryFinish", "iii", IPBAN_THREAD, playerid, g_arrQueryHandle{playerid});
	return 1;
}

stock AddBan(Admin, Player, Reason[])
{
    new string[128];
	SetPVarInt(Admin, "BanningPlayer", Player);
	SetPVarString(Admin, "BanningReason", Reason);
	format(string, sizeof(string), "SELECT `ip` FROM `ip_bans` WHERE `ip` = '%s'", GetPlayerIpEx(Player));
	mysql_function_query(MainPipeline, string, true, "AddingBan", "ii", Admin, 1);
	return 1;
}


stock SystemBan(Player, Reason[])
{
	new string[150];
    format(string, sizeof(string), "INSERT INTO `ip_bans` (`ip`, `date`, `reason`, `admin`) VALUES ('%s', NOW(), '%s', 'System')", GetPlayerIpEx(Player), Reason);
	mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	return 1;
}


stock MySQLBan(userid,ip[],reason[],status,admin[])
{
	new string[200];
    format(string, sizeof(string), "INSERT INTO `bans` (`user_id`, `ip_address`, `reason`, `date_added`, `status`, `admin`) VALUES ('%d','%s','%s', NOW(), '%d','%s')", userid,ip,reason,status,admin);
	mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	return 1;
}

stock AddCrime(cop, suspect, crime[])
{
	new query[256];
	format(query, sizeof(query), "INSERT INTO `mdc` (`id` ,`time` ,`issuer` ,`crime`) VALUES ('%d',NOW(),'%s','%s')", GetPlayerSQLId(suspect), g_mysql_ReturnEscaped(GetPlayerNameEx(cop), MainPipeline), g_mysql_ReturnEscaped(crime, MainPipeline));
	mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	format(query, sizeof(query), "MDC: %s added crime %s to %s.", GetPlayerNameEx(cop), crime, GetPlayerNameEx(suspect));
	Log("logs/crime.log", query);
	return 1;
}

stock ClearCrimes(playerid)
{
	new query[80];
	format(query, sizeof(query), "UPDATE `mdc` SET `active`=0 WHERE `id` = %i AND `active` = 1", GetPlayerSQLId(playerid));
	mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	return 1;
}

stock DisplayCrimes(playerid, suspectid)
{
    new query[128];
    format(query, sizeof(query), "SELECT issuer, crime, active FROM `mdc` WHERE id=%d ORDER BY `time` AND `active` DESC LIMIT 12", GetPlayerSQLId(suspectid));
    mysql_function_query(MainPipeline, query, true, "MDCQueryFinish", "ii", playerid, suspectid);
	return 1;
}

stock DisplayReports(playerid, suspectid)
{
    new query[812];
    format(query, sizeof(query), "SELECT arrestreports.id, copid, shortreport, datetime, accounts.id, accounts.Username FROM `arrestreports` LEFT JOIN `accounts` ON	arrestreports.copid=accounts.id WHERE arrestreports.suspectid=%d ORDER BY arrestreports.datetime DESC LIMIT 12", GetPlayerSQLId(suspectid));
    mysql_function_query(MainPipeline, query, true, "MDCReportsQueryFinish", "ii", playerid, suspectid);
	return 1;
}

stock DisplayReport(playerid, reportid)
{
    new query[812];
    format(query, sizeof(query), "SELECT arrestreports.id, copid, shortreport, datetime, accounts.id, accounts.Username FROM `arrestreports` LEFT JOIN `accounts` ON	arrestreports.copid=accounts.id WHERE arrestreports.id=%d ORDER BY arrestreports.datetime DESC LIMIT 12", reportid);
    mysql_function_query(MainPipeline, query, true, "MDCReportQueryFinish", "ii", playerid, reportid);
	return 1;
}

stock SetUnreadMailsNotification(playerid)
{
    new query[128];
    format(query, sizeof(query), "SELECT COUNT(*) AS Unread_Count FROM letters WHERE Receiver_ID = %d AND `Read` = 0", GetPlayerSQLId(playerid));
    mysql_function_query(MainPipeline, query, true, "UnreadMailsNotificationQueryFin", "i", playerid);
	return 1;
}

stock DisplayMails(playerid)
{
    new query[150];
    format(query, sizeof(query), "SELECT `Id`, `Message`, `Read` FROM `letters` WHERE `Receiver_Id` = %d AND `Delivery_Min` = 0 ORDER BY `Id` DESC LIMIT 50", GetPlayerSQLId(playerid));
    mysql_function_query(MainPipeline, query, true, "MailsQueryFinish", "i", playerid);
}

stock DisplayMailDetails(playerid, letterid)
{
    new query[256];
    format(query, sizeof(query), "SELECT `Id`, `Date`, `Sender_Id`, `Read`, `Notify`, `Message`, (SELECT `Username` FROM `accounts` WHERE `id` = letters.Sender_Id) AS `SenderUser` FROM `letters` WHERE id = %d", letterid);
    mysql_function_query(MainPipeline, query, true, "MailDetailsQueryFinish", "i", playerid);
}

stock CountFlags(playerid)
{
	new query[80];
	format(query, sizeof(query), "SELECT * FROM `flags` WHERE id=%d", GetPlayerSQLId(playerid));
	mysql_function_query(MainPipeline, query, true, "FlagQueryFinish", "iii", playerid, INVALID_PLAYER_ID, Flag_Query_Count);
	return 1;
}

stock AddFlag(playerid, adminid, flag[])
{
	new query[300];
	new admin[24];
	if(adminid != INVALID_PLAYER_ID) {
		format(admin, sizeof(admin), "%s", GetPlayerNameEx(adminid));
	}
	else {
		format(admin, sizeof(admin), "Gifted/Script Added");
	}
	PlayerInfo[playerid][pFlagged]++;
	format(query, sizeof(query), "INSERT INTO `flags` (`id` ,`time` ,`issuer` ,`flag`) VALUES ('%d',NOW(),'%s','%s')", GetPlayerSQLId(playerid), g_mysql_ReturnEscaped(admin, MainPipeline), g_mysql_ReturnEscaped(flag, MainPipeline));
	mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	format(query, sizeof(query), "FLAG: %s added flag %s to %s.", admin, flag, GetPlayerNameEx(playerid));
	Log("logs/flags.log", query);
	return 1;
}

stock AddOFlag(sqlid, adminid, flag[]) // offline add
{
	new query[300];
	new admin[24], name[24];
	if(adminid != INVALID_PLAYER_ID) {
		format(admin, sizeof(admin), "%s", GetPlayerNameEx(adminid));
	}
	else {
		format(admin, sizeof(admin), "Gifted/Script Added");
	}
	GetPVarString(adminid, "OnAddFlag", name, sizeof(name));
	format(query, sizeof(query), "INSERT INTO `flags` (`id` ,`time` ,`issuer` ,`flag`) VALUES ('%d',NOW(),'%s','%s')", sqlid, g_mysql_ReturnEscaped(admin, MainPipeline), g_mysql_ReturnEscaped(flag, MainPipeline));
	mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	format(query, sizeof(query), "FLAG: %s added flag %s to %s.", admin, flag, name);
	Log("logs/flags.log", query);
	DeletePVar(adminid, "OnAddFlag");
	return 1;
}

stock DeleteFlag(flagid, adminid)
{
	new query[80];
	format(query, sizeof(query), "FLAG: Flag %d was deleted by %s.", flagid, GetPlayerNameEx(adminid));
	Log("logs/flags.log", query);
	format(query, sizeof(query), "DELETE FROM `flags` WHERE `fid` = %i", flagid);
	mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	return 1;
}

stock DisplayFlags(playerid, targetid)
{
    new query[128];
	CountFlags(targetid);
    format(query, sizeof(query), "SELECT fid, issuer, flag, time FROM `flags` WHERE id=%d ORDER BY `time` LIMIT 15", GetPlayerSQLId(targetid));
    mysql_function_query(MainPipeline, query, true, "FlagQueryFinish", "iii", playerid, targetid, Flag_Query_Display);
	return 1;
}

stock CountSkins(playerid)
{
	new query[80];
	format(query, sizeof(query), "SELECT NULL FROM `house_closet` WHERE playerid = %d", GetPlayerSQLId(playerid));
	mysql_function_query(MainPipeline, query, true, "SkinQueryFinish", "ii", playerid, Skin_Query_Count);
	return 1;
}

stock AddSkin(playerid, skinid)
{
	new query[300];
	PlayerInfo[playerid][pSkins]++;
	format(query, sizeof(query), "INSERT INTO `house_closet` (`id`, `playerid`, `skinid`) VALUES (NULL, '%d', '%d')", GetPlayerSQLId(playerid), skinid);
	mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	return 1;
}

stock DeleteSkin(skinid)
{
	new query[80];
	format(query, sizeof(query), "DELETE FROM `house_closet` WHERE `id` = %i", skinid);
	mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	return 1;
}

stock DisplaySkins(playerid)
{
    new query[128];
	CountSkins(playerid);
    format(query, sizeof(query), "SELECT `skinid` FROM `house_closet` WHERE playerid = %d ORDER BY `skinid` ASC", GetPlayerSQLId(playerid));
    mysql_function_query(MainPipeline, query, true, "SkinQueryFinish", "ii", playerid, Skin_Query_Display);
	return 1;
}

stock CountCitizens()
{
	mysql_function_query(MainPipeline, "SELECT NULL FROM `accounts` WHERE `Nation` = 1 && `UpdateDate` > NOW() - INTERVAL 1 WEEK",  true, "CitizenQueryFinish", "i", TR_Citizen_Count);
	mysql_function_query(MainPipeline, "SELECT NULL FROM `accounts` WHERE `UpdateDate` > NOW() - INTERVAL 1 WEEK",  true, "CitizenQueryFinish", "i", Total_Count);
	return 1;
}

stock CheckNationQueue(playerid, nation)
{
	new query[300];
	format(query, sizeof(query), "SELECT NULL FROM `nation_queue` WHERE `playerid` = %d AND `status` = 1", GetPlayerSQLId(playerid));
	mysql_function_query(MainPipeline, query, true, "NationQueueQueryFinish", "iii", playerid, nation, CheckQueue);
}

stock AddNationQueue(playerid, nation, status)
{
	new query[300];
	if(nation == 0)
	{
		format(query, sizeof(query), "INSERT INTO `nation_queue` (`id`, `playerid`, `name`, `date`, `nation`, `status`) VALUES (NULL, %d, '%s', NOW(), 0, %d)", GetPlayerSQLId(playerid), GetPlayerNameExt(playerid), status);
		mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	}
	if(nation == 1)
	{
		if(status == 1)
		{
			format(query, sizeof(query), "SELECT NULL FROM `nation_queue` WHERE `playerid` = %d AND `nation` = 1", GetPlayerSQLId(playerid));
			mysql_function_query(MainPipeline, query, true, "NationQueueQueryFinish", "iii", playerid, nation, AddQueue);
		}
		else if(status == 2)
		{
			format(query, sizeof(query), "INSERT INTO `nation_queue` (`id`, `playerid`, `name`, `date`, `nation`, `status`) VALUES (NULL, %d, '%s', NOW(), 1, %d)", GetPlayerSQLId(playerid), GetPlayerNameExt(playerid), status);
			mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
			PlayerInfo[playerid][pNation] = 1;
		}
	}
	return 1;
}

stock UpdateCitizenApp(playerid, nation)
{
	new query[300];
	format(query, sizeof(query), "SELECT NULL FROM `nation_queue` WHERE `playerid` = %d AND `status` = 1", GetPlayerSQLId(playerid));
	mysql_function_query(MainPipeline, query, true, "NationQueueQueryFinish", "iii", playerid, nation, UpdateQueue);
}

stock AddTicket(playerid, number)
{
	new query[80];
	PlayerInfo[playerid][pLottoNr]++;
	format(query, sizeof(query), "INSERT INTO `lotto` (`id` ,`number`) VALUES ('%d', '%d')", GetPlayerSQLId(playerid), number);
	mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	return 1;
}

stock DeleteTickets(playerid)
{
	new query[80];
	format(query, sizeof(query), "DELETE FROM `lotto` WHERE `id` = %i", GetPlayerSQLId(playerid));
	mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	return 1;
}

stock LoadTickets(playerid)
{
    new query[128];
    format(query, sizeof(query), "SELECT `tid`, `number` FROM `lotto` WHERE `id` = %d LIMIT 5", GetPlayerSQLId(playerid));
    mysql_function_query(MainPipeline, query, true, "LoadTicket", "i", playerid);
	return 1;
}

stock CountTickets(playerid)
{
	new query[80];
	format(query, sizeof(query), "SELECT * FROM `lotto` WHERE `id` = %i", GetPlayerSQLId(playerid));
	mysql_function_query(MainPipeline, query, true, "CountAmount", "i", playerid);
	return 1;
}

stock LoadTreasureInventory(playerid)
{
	new query[175];
	format(query, sizeof(query), "SELECT `junkmetal`, `newcoin`, `oldcoin`, `brokenwatch`, `oldkey`, `treasure`, `goldwatch`, `silvernugget`, `goldnugget` FROM `jobstuff` WHERE `pId` = %d", GetPlayerSQLId(playerid));
    mysql_function_query(MainPipeline, query, true, "LoadTreasureInvent", "i", playerid);
	return 1;
}

stock SaveTreasureInventory(playerid)
{
    new string[220];
	format(string, sizeof(string), "UPDATE `jobstuff` SET `junkmetal` = %d, `newcoin` = %d, `oldcoin` = %d, `brokenwatch` = %d, `oldkey` = %d, \
 	`treasure` = %d, `goldwatch` = %d, `silvernugget` = %d, `goldnugget` =%d  WHERE `pId` = %d", GetPVarInt(playerid, "junkmetal"), GetPVarInt(playerid, "newcoin"), GetPVarInt(playerid, "oldcoin"),
 	GetPVarInt(playerid, "brokenwatch"), GetPVarInt(playerid, "oldkey"), GetPVarInt(playerid, "treasure"), GetPVarInt(playerid, "goldwatch"), GetPVarInt(playerid, "silvernugget"), GetPVarInt(playerid, "goldnugget"), GetPlayerSQLId(playerid));
	mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	return 1;
}

stock SQL_Log(szQuery[], szDesc[] = "none", iExtraID = 0) {
	new i_dateTime[2][3];
	gettime(i_dateTime[0][0], i_dateTime[0][1], i_dateTime[0][2]);
	getdate(i_dateTime[1][0], i_dateTime[1][1], i_dateTime[1][2]);

	printf("Dumping query from %i/%i/%i (%i:%i:%i)\r\nDescription: %s (index %i). Query:\r\n", i_dateTime[1][0], i_dateTime[1][1], i_dateTime[1][2], i_dateTime[0][0], i_dateTime[0][1], i_dateTime[0][2], szDesc, iExtraID);
	if(strlen(szQuery) > 1023)
	{
	    new sz_print[1024];
	    new Float:maxfloat = strlen(szQuery)/1023;
		for(new x;x<=floatround(maxfloat, floatround_ceil);x++)
		{
		    strmid(sz_print, szQuery, 0+(x*1023), 1023+(x*1023));
		    print(sz_print);
		}
	}
	else
	{
		print(szQuery);
	}
	return 1;
}

stock LoadFamilies()
{
	printf("[LoadFamilies] Dang tai du lieu tu database...");
	mysql_function_query(MainPipeline, "SELECT * FROM `families`", true, "OnLoadFamilies", "");
}

stock FamilyMemberCount(famid)
{
	new query[56];
	format(query, sizeof(query), "SELECT NULL FROM `accounts` WHERE `FMember` = '%d'", famid);
	mysql_function_query(MainPipeline, query, true, "OnFamilyMemberCount", "i", famid);
	return 1;
}

stock SaveFamily(id) {

	new string[2048];

	format(string, sizeof(string), "UPDATE `families` SET \
		`FType`=%d, \
		`Taken`=%d, \
		`Name`='%s', \
		`Leader`='%s', \
		`Bank`=%d, \
		`Cash`=%d, \
		`FamilyUSafe`=%d, \
		`FamilySafeX`=%f, \
		`FamilySafeY`=%f, \
		`FamilySafeZ`=%f, \
		`FamilySafeVW`=%d, \
		`FamilySafeInt`=%d, \
		`Pot`=%d, \
		`Crack`=%d, \
		`fSlot0`=%d, \
		`fSlot1`=%d, \
		`fSlot2`=%d, \
		`fSlot3`=%d, \
		`fSlot4`=%d, \
		`fSlot5`=%d, \
		`fSlot6`=%d, \
		`fSlot7`=%d, \
		`fSlot8`=%d, \
		`fSlot9`=%d, \
		`fAmount0`=%d, \
		`fAmount1`=%d, \
		`fAmount2`=%d, \
		`fAmount3`=%d, \
		`fAmount4`=%d, \
		`fAmount5`=%d, \
		`fAmount6`=%d, \
		`fAmount7`=%d, \
		`fAmount8`=%d, \
		`fAmount9`=%d, \
		`Crack`=%d, \
		`Mats`=%d, \
		`Heroin`=%d, \
		`Rank0`='%s', \
		`Rank1`='%s', \
		`Rank2`='%s', \
		`Rank3`='%s', \
		`Rank4`='%s', \
		`Rank5`='%s', \
		`Rank6`='%s', \
		`Division0`='%s', \
		`Division1`='%s', \
		`Division2`='%s', \
		`Division3`='%s', \
		`Division4`='%s', ",
		FamilyInfo[id][FType],
		FamilyInfo[id][FamilyTaken],
		g_mysql_ReturnEscaped(FamilyInfo[id][FamilyName], MainPipeline),
		FamilyInfo[id][FamilyLeader],
		FamilyInfo[id][FamilyBank],
		FamilyInfo[id][FamilyCash],
		FamilyInfo[id][FamilyUSafe],
		FamilyInfo[id][FamilySafe][0],
		FamilyInfo[id][FamilySafe][1],
		FamilyInfo[id][FamilySafe][2],
		FamilyInfo[id][FamilySafeVW],
		FamilyInfo[id][FamilySafeInt],
		FamilyInfo[id][FamilyPot],
		FamilyInfo[id][FamilyCrack],
		FamilyInfo[id][fSlot][0],
		FamilyInfo[id][fSlot][1],
		FamilyInfo[id][fSlot][2],
		FamilyInfo[id][fSlot][3],
		FamilyInfo[id][fSlot][4],
		FamilyInfo[id][fSlot][5],
		FamilyInfo[id][fSlot][6],
		FamilyInfo[id][fSlot][7],
		FamilyInfo[id][fSlot][8],
		FamilyInfo[id][fSlot][9],
		FamilyInfo[id][fAmount][0],
		FamilyInfo[id][fAmount][1],
		FamilyInfo[id][fAmount][2],
		FamilyInfo[id][fAmount][3],
		FamilyInfo[id][fAmount][4],
		FamilyInfo[id][fAmount][5],
		FamilyInfo[id][fAmount][6],
		FamilyInfo[id][fAmount][7],
		FamilyInfo[id][fAmount][8],
		FamilyInfo[id][fAmount][9],
		FamilyInfo[id][FamilyMats],
		FamilyInfo[id][FamilyHeroin],
		g_mysql_ReturnEscaped(FamilyRankInfo[id][0], MainPipeline),
		g_mysql_ReturnEscaped(FamilyRankInfo[id][1], MainPipeline),
		g_mysql_ReturnEscaped(FamilyRankInfo[id][2], MainPipeline),
		g_mysql_ReturnEscaped(FamilyRankInfo[id][3], MainPipeline),
		g_mysql_ReturnEscaped(FamilyRankInfo[id][4], MainPipeline),
		g_mysql_ReturnEscaped(FamilyRankInfo[id][5], MainPipeline),
		g_mysql_ReturnEscaped(FamilyRankInfo[id][6], MainPipeline),
		g_mysql_ReturnEscaped(FamilyDivisionInfo[id][0], MainPipeline),
		g_mysql_ReturnEscaped(FamilyDivisionInfo[id][1], MainPipeline),
		g_mysql_ReturnEscaped(FamilyDivisionInfo[id][2], MainPipeline),
		g_mysql_ReturnEscaped(FamilyDivisionInfo[id][3], MainPipeline),
		g_mysql_ReturnEscaped(FamilyDivisionInfo[id][4], MainPipeline)
	);

	format(string, sizeof(string), "%s\
		`fontface`='%s', \
		`fontsize`=%d, \
		`bold`=%d, \
		`fontcolor`=%d, \
		`gtUsed`=%d, \
		`text`='%s', ",
		string,
		FamilyInfo[id][gt_FontFace],
		FamilyInfo[id][gt_FontSize],
		FamilyInfo[id][gt_Bold],
		FamilyInfo[id][gt_FontColor],
		FamilyInfo[id][gt_SPUsed],
		g_mysql_ReturnEscaped(FamilyInfo[id][gt_Text], MainPipeline)
	);

	format(string, sizeof(string), "%s \
        `MaxSkins`=%d, \
		`Skin1`=%d, \
		`Skin2`=%d, \
		`Skin3`=%d, \
		`Skin4`=%d, \
		`Skin5`=%d, \
		`Skin6`=%d, \
		`Skin7`=%d, \
		`Skin8`=%d, \
		`Color`=%d, \
		`TurfTokens`=%d, \
		`Gun1`=%d, \
		`Gun2`=%d, \
		`Gun3`=%d, \
		`Gun4`=%d, \
		`Gun5`=%d, \
		`Gun6`=%d, \
		`Gun7`=%d, \
		`Gun8`=%d, \
		`Gun9`=%d, \
		`Gun10`=%d, \
		`GtObject`=%d, \
		`MOTD1`='%s', \
		`MOTD2`='%s', \
		`MOTD3`='%s' \
		WHERE `ID` = %d",
		string,
		FamilyInfo[id][FamilyMaxSkins],
		FamilyInfo[id][FamilySkins][0],
		FamilyInfo[id][FamilySkins][1],
		FamilyInfo[id][FamilySkins][2],
		FamilyInfo[id][FamilySkins][3],
		FamilyInfo[id][FamilySkins][4],
		FamilyInfo[id][FamilySkins][5],
		FamilyInfo[id][FamilySkins][6],
		FamilyInfo[id][FamilySkins][7],
		FamilyInfo[id][FamilyColor],
		FamilyInfo[id][FamilyTurfTokens],
		FamilyInfo[id][FamilyGuns][0],
		FamilyInfo[id][FamilyGuns][1],
		FamilyInfo[id][FamilyGuns][2],
		FamilyInfo[id][FamilyGuns][3],
		FamilyInfo[id][FamilyGuns][4],
		FamilyInfo[id][FamilyGuns][5],
		FamilyInfo[id][FamilyGuns][6],
		FamilyInfo[id][FamilyGuns][7],
		FamilyInfo[id][FamilyGuns][8],
		FamilyInfo[id][FamilyGuns][9],
		FamilyInfo[id][gtObject],
		g_mysql_ReturnEscaped(FamilyMOTD[id][0], MainPipeline),
		g_mysql_ReturnEscaped(FamilyMOTD[id][1], MainPipeline),
		g_mysql_ReturnEscaped(FamilyMOTD[id][2], MainPipeline),
		id
	);

	mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);

	return 1;
}

stock SaveFamiliesHQ(id)
{
	if(!( 1 <= id < MAX_FAMILY))
		return 0;

	new query[300];
	format(query, sizeof(query), "UPDATE `families` SET `ExteriorX` = %f, `ExteriorY` = %f, `ExteriorZ` = %f, `ExteriorA` = %f, `InteriorX` = %f, `InteriorY` = %f, `InteriorZ` = %f, `InteriorA` = %f, \
	`INT` = %d, `VW` = %d, `CustomInterior` = %d WHERE ID = %d", FamilyInfo[id][FamilyEntrance][0], FamilyInfo[id][FamilyEntrance][1], FamilyInfo[id][FamilyEntrance][2], FamilyInfo[id][FamilyEntrance][3],
	FamilyInfo[id][FamilyExit][0], FamilyInfo[id][FamilyExit][1], FamilyInfo[id][FamilyExit][2], FamilyInfo[id][FamilyExit][3], FamilyInfo[id][FamilyInterior], FamilyInfo[id][FamilyVirtualWorld],
	FamilyInfo[id][FamilyCustomMap], id);
	mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "ii", SENDDATA_THREAD, INVALID_PLAYER_ID);
	return 1;
}

stock LoadGates()
{
	printf("[LoadGates] Loading data from database...");
	mysql_function_query(MainPipeline, "SELECT * FROM `gates`", true, "OnLoadGates", "");
}

stock SaveDynamicMapIcon(mapiconid)
{
	new string[512];

	format(string, sizeof(string), "UPDATE `dmapicons` SET \
		`MarkerType`=%d, \
		`Color`=%d, \
		`VW`=%d, \
		`Int`=%d, \
		`PosX`=%f, \
		`PosY`=%f, \
		`PosZ`=%f WHERE `id`=%d",
		DMPInfo[mapiconid][dmpMarkerType],
		DMPInfo[mapiconid][dmpColor],
		DMPInfo[mapiconid][dmpVW],
		DMPInfo[mapiconid][dmpInt],
		DMPInfo[mapiconid][dmpPosX],
		DMPInfo[mapiconid][dmpPosY],
		DMPInfo[mapiconid][dmpPosZ],
		mapiconid
	); // Array starts from zero, MySQL starts at 1 (this is why we are adding one).

	mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);
}

stock LoadDynamicMapIcon(mapiconid)
{
	new string[128];
	format(string, sizeof(string), "SELECT * FROM `dmapicons` WHERE `id`=%d", mapiconid);
	mysql_function_query(MainPipeline, string, true, "OnLoadDynamicMapIcon", "i", mapiconid);
}

stock LoadDynamicMapIcons()
{
	printf("[LoadDynamicMapIcons] Loading data from database...");
	mysql_function_query(MainPipeline, "SELECT * FROM `dmapicons`", true, "OnLoadDynamicMapIcons", "");
}

stock SaveDynamicDoor(doorid)
{
	new string[1024];
	format(string, sizeof(string), "UPDATE `ddoors` SET \
		`Description`='%s', \
		`Owner`=%d, \
		`OwnerName`='%s', \
		`CustomInterior`=%d, \
		`ExteriorVW`=%d, \
		`ExteriorInt`=%d, \
		`InteriorVW`=%d, \
		`InteriorInt`=%d, \
		`ExteriorX`=%f, \
		`ExteriorY`=%f, \
		`ExteriorZ`=%f, \
		`ExteriorA`=%f, \
		`InteriorX`=%f, \
		`InteriorY`=%f, \
		`InteriorZ`=%f, \
		`InteriorA`=%f,",
		g_mysql_ReturnEscaped(DDoorsInfo[doorid][ddDescription], MainPipeline),
		DDoorsInfo[doorid][ddOwner],
		g_mysql_ReturnEscaped(DDoorsInfo[doorid][ddOwnerName], MainPipeline),
		DDoorsInfo[doorid][ddCustomInterior],
		DDoorsInfo[doorid][ddExteriorVW],
		DDoorsInfo[doorid][ddExteriorInt],
		DDoorsInfo[doorid][ddInteriorVW],
		DDoorsInfo[doorid][ddInteriorInt],
		DDoorsInfo[doorid][ddExteriorX],
		DDoorsInfo[doorid][ddExteriorY],
		DDoorsInfo[doorid][ddExteriorZ],
		DDoorsInfo[doorid][ddExteriorA],
		DDoorsInfo[doorid][ddInteriorX],
		DDoorsInfo[doorid][ddInteriorY],
		DDoorsInfo[doorid][ddInteriorZ],
		DDoorsInfo[doorid][ddInteriorA]
	);

	format(string, sizeof(string), "%s \
		`CustomExterior`=%d, \
		`Type`=%d, \
		`Rank`=%d, \
		`VIP`=%d, \
		`Famed`=%d, \
		`DPC`=%d, \
		`Allegiance`=%d, \
		`GroupType`=%d, \
		`Family`=%d, \
		`Faction`=%d, \
		`Admin`=%d, \
		`Wanted`=%d, \
		`VehicleAble`=%d, \
		`Color`=%d, \
		`PickupModel`=%d, \
		`Pass`='%s', \
		`Locked`=%d WHERE `id`=%d",
		string,
		DDoorsInfo[doorid][ddCustomExterior],
		DDoorsInfo[doorid][ddType],
		DDoorsInfo[doorid][ddRank],
		DDoorsInfo[doorid][ddVIP],
		DDoorsInfo[doorid][ddFamed],
		DDoorsInfo[doorid][ddDPC],
		DDoorsInfo[doorid][ddAllegiance],
		DDoorsInfo[doorid][ddGroupType],
		DDoorsInfo[doorid][ddFamily],
		DDoorsInfo[doorid][ddFaction],
		DDoorsInfo[doorid][ddAdmin],
		DDoorsInfo[doorid][ddWanted],
		DDoorsInfo[doorid][ddVehicleAble],
		DDoorsInfo[doorid][ddColor],
		DDoorsInfo[doorid][ddPickupModel],
		g_mysql_ReturnEscaped(DDoorsInfo[doorid][ddPass], MainPipeline),
		DDoorsInfo[doorid][ddLocked],
		doorid+1
	); // Array starts from zero, MySQL starts at 1 (this is why we are adding one).

	mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);
}

stock LoadDynamicDoor(doorid)
{
	new string[128];
	format(string, sizeof(string), "SELECT * FROM `ddoors` WHERE `id`=%d", doorid+1); // Array starts at zero, MySQL starts at 1.
	mysql_function_query(MainPipeline, string, true, "OnLoadDynamicDoor", "i", doorid);
}

stock LoadDynamicDoors()
{
	printf("[LoadDynamicDoors] Loading data from database...");
	mysql_function_query(MainPipeline, "SELECT * FROM `ddoors`", true, "OnLoadDynamicDoors", "");
}

stock SaveHouse(houseid)
{
	new string[2048];
	printf("Saving House ID %d", houseid);
	format(string, sizeof(string), "UPDATE `houses` SET \
		`Owned`=%d, \
		`Level`=%d, \
		`Description`='%s', \
		`OwnerID`=%d, \
		`ExteriorX`=%f, \
		`ExteriorY`=%f, \
		`ExteriorZ`=%f, \
		`ExteriorR`=%f, \
		`InteriorX`=%f, \
		`InteriorY`=%f, \
		`InteriorZ`=%f, \
		`InteriorR`=%f, \
		`TrasX`=%f, \
		`TrasY`=%f, \
		`TrasZ`=%f, \
		`TrasA`=%f, \
		`ExtIW`=%d, \
		`ExtVW`=%d, \
		`IntIW`=%d, \
		`IntVW`=%d,",
		HouseInfo[houseid][hOwned],
		HouseInfo[houseid][hLevel],
		g_mysql_ReturnEscaped(HouseInfo[houseid][hDescription], MainPipeline),
		HouseInfo[houseid][hOwnerID],
		HouseInfo[houseid][hExteriorX],
		HouseInfo[houseid][hExteriorY],
		HouseInfo[houseid][hExteriorZ],
		HouseInfo[houseid][hExteriorR],
		HouseInfo[houseid][hInteriorX],
		HouseInfo[houseid][hInteriorY],
		HouseInfo[houseid][hInteriorZ],
		HouseInfo[houseid][hInteriorR],
		HouseInfo[houseid][hTrasX],
		HouseInfo[houseid][hTrasY],
		HouseInfo[houseid][hTrasZ],
		HouseInfo[houseid][hTrasA],
		HouseInfo[houseid][hExtIW],
		HouseInfo[houseid][hExtVW],
		HouseInfo[houseid][hIntIW],
		HouseInfo[houseid][hIntVW]
	);

	format(string, sizeof(string), "%s \
		`Lock`=%d, \
		`Rentable`=%d, \
		`RentFee`=%d, \
		`Value`=%d, \
		`SafeMoney`=%d, \
		`Pot`=%d, \
		`Crack`=%d, \
		`Materials`=%d, \
		`Heroin`=%d, \
		`Weapons0`=%d, \
		`Weapons1`=%d, \
		`Weapons2`=%d, \
		`Weapons3`=%d, \
		`Weapons4`=%d, \
		`GLUpgrade`=%d, \
		`CustomInterior`=%d, \
		`CustomExterior`=%d, \
		`ExteriorA`=%f, \
		`InteriorA`=%f, \
		`MailX`=%f, \
		`MailY`=%f, \
		`MailZ`=%f, \
		`MailA`=%f, \
		`MailType`=%d, \
		`ClosetX`=%f, \
		`ClosetY`=%f, \
		`ClosetZ`=%d WHERE `id`=%d",
		string,
		HouseInfo[houseid][hLock],
		HouseInfo[houseid][hRentable],
		HouseInfo[houseid][hRentFee],
		HouseInfo[houseid][hValue],
   		HouseInfo[houseid][hSafeMoney],
		HouseInfo[houseid][hPot],
		HouseInfo[houseid][hCrack],
		HouseInfo[houseid][hMaterials],
		HouseInfo[houseid][hHeroin],
		HouseInfo[houseid][hWeapons][0],
		HouseInfo[houseid][hWeapons][1],
		HouseInfo[houseid][hWeapons][2],
		HouseInfo[houseid][hWeapons][3],
		HouseInfo[houseid][hWeapons][4],
		HouseInfo[houseid][hGLUpgrade],
		HouseInfo[houseid][hCustomInterior],
		HouseInfo[houseid][hCustomExterior],
		HouseInfo[houseid][hExteriorA],
		HouseInfo[houseid][hInteriorA],
		HouseInfo[houseid][hMailX],
		HouseInfo[houseid][hMailY],
		HouseInfo[houseid][hMailZ],
		HouseInfo[houseid][hMailA],
		HouseInfo[houseid][hMailType],
		HouseInfo[houseid][hClosetX],
		HouseInfo[houseid][hClosetY],
		HouseInfo[houseid][hClosetZ],
		houseid+1
	); // Array starts from zero, MySQL starts at 1 (this is why we are adding one).
	mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);
}

stock LoadHouse(houseid)
{
	new string[128];
	printf("[LoadHouse] Loading HouseID %d's data from database...", houseid);
	format(string, sizeof(string), "SELECT OwnerName.Username, h.* FROM houses h LEFT JOIN accounts OwnerName ON h.OwnerID = OwnerName.id WHERE `id` = %d", houseid+1); // Array starts at zero, MySQL starts at one.
	mysql_function_query(MainPipeline, string, true, "OnLoadHouse", "i", houseid);
}

stock LoadHouses()
{
	printf("[LoadHouses] Loading data from database...");
	mysql_function_query(MainPipeline, "SELECT OwnerName.Username, h.* FROM houses h LEFT JOIN accounts OwnerName ON h.OwnerID = OwnerName.id", true, "OnLoadHouses", "");
}


stock LoadMailboxes()
{
	printf("[LoadMailboxes] Loading data from database...");
	mysql_function_query(MainPipeline, "SELECT * FROM `mailboxes`", true, "OnLoadMailboxes", "");
}

stock LoadPoints()
{
	printf("[LoadFamilyPoints] Loading Family Points from the database, please wait...");
	mysql_function_query(MainPipeline, "SELECT * FROM `points`", true, "OnLoadPoints", "");
}

stock LoadHGBackpacks()
{
	printf("[Loading Hunger Games] Loading Hunger Games Backpacks from the database, please wait...");
	mysql_function_query(MainPipeline,  "SELECT * FROM `hgbackpacks`", true, "OnLoadHGBackpacks", "");
}

stock SaveMailbox(id)
{
	new string[512];

	format(string, sizeof(string), "UPDATE `mailboxes` SET \
		`VW`=%d, \
		`Int`=%d, \
		`Model`=%d, \
		`PosX`=%f, \
		`PosY`=%f, \
		`PosZ`=%f, \
		`Angle`=%f WHERE `id`=%d",
		MailBoxes[id][mbVW],
		MailBoxes[id][mbInt],
		MailBoxes[id][mbModel],
		MailBoxes[id][mbPosX],
		MailBoxes[id][mbPosY],
		MailBoxes[id][mbPosZ],
		MailBoxes[id][mbAngle],
		id+1
	); // Array starts from zero, MySQL starts at 1 (this is why we are adding one).

	mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);
}

stock SaveSpeedCamera(i)
{
	if (SpeedCameras[i][_scActive] != true)
		return;

	new query[1024];
	format(query, sizeof(query), "UPDATE speed_cameras SET pos_x=%f, pos_y=%f, pos_z=%f, rotation=%f, `range`=%f, speed_limit=%f WHERE id=%i",
		SpeedCameras[i][_scPosX], SpeedCameras[i][_scPosY], SpeedCameras[i][_scPosZ], SpeedCameras[i][_scRotation], SpeedCameras[i][_scRange], SpeedCameras[i][_scLimit],
		SpeedCameras[i][_scDatabase]);

	mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
}

stock LoadSpeedCameras()
{
	printf("[SpeedCameras] Loading data from database...");
	mysql_function_query(MainPipeline, "SELECT * FROM speed_cameras", true, "OnLoadSpeedCameras", "");

	return 1;
}

stock StoreNewSpeedCameraInMySQL(index)
{
	new string[512];
	format(string, sizeof(string), "INSERT INTO speed_cameras (pos_x, pos_y, pos_z, rotation, `range`, speed_limit) VALUES (%f, %f, %f, %f, %f, %f)",
		SpeedCameras[index][_scPosX], SpeedCameras[index][_scPosY], SpeedCameras[index][_scPosZ], SpeedCameras[index][_scRotation], SpeedCameras[index][_scRange], SpeedCameras[index][_scLimit]);

	mysql_function_query(MainPipeline, string, true, "OnNewSpeedCamera", "i", index);
	return 1;
}



stock SavePayNSpray(id)
{
	new string[1024];
	format(string, sizeof(string), "UPDATE `paynsprays` SET \
		`Status`=%d, \
		`PosX`=%f, \
		`PosY`=%f, \
		`PosZ`=%f, \
		`VW`=%d, \
		`Int`=%d, \
		`GroupCost`=%d, \
		`RegCost`=%d WHERE `id`=%d",
		PayNSprays[id][pnsStatus],
		PayNSprays[id][pnsPosX],
		PayNSprays[id][pnsPosY],
		PayNSprays[id][pnsPosZ],
		PayNSprays[id][pnsVW],
		PayNSprays[id][pnsInt],
		PayNSprays[id][pnsGroupCost],
		PayNSprays[id][pnsRegCost],
		id
	);

	mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);
}

stock SavePayNSprays()
{
	for(new i = 0; i < MAX_PAYNSPRAYS; i++)
	{
		SavePayNSpray(i);
	}
	return 1;
}

stock RehashPayNSpray(id)
{
	DestroyDynamicPickup(PayNSprays[id][pnsPickupID]);
	DestroyDynamic3DTextLabel(PayNSprays[id][pnsTextID]);
	DestroyDynamicMapIcon(PayNSprays[id][pnsMapIconID]);
	PayNSprays[id][pnsSQLId] = -1;
	PayNSprays[id][pnsStatus] = 0;
	PayNSprays[id][pnsPosX] = 0.0;
	PayNSprays[id][pnsPosY] = 0.0;
	PayNSprays[id][pnsPosZ] = 0.0;
	PayNSprays[id][pnsVW] = 0;
	PayNSprays[id][pnsInt] = 0;
	PayNSprays[id][pnsGroupCost] = 0;
	PayNSprays[id][pnsRegCost] = 0;
	LoadPayNSpray(id);
}

stock RehashPayNSprays()
{
	printf("[RehashPayNSprays] Deleting Pay N' Sprays from server...");
	for(new i = 0; i < MAX_PAYNSPRAYS; i++)
	{
		RehashPayNSpray(i);
	}
	LoadPayNSprays();
}

stock LoadPayNSpray(id)
{
	new string[128];
	format(string, sizeof(string), "SELECT * FROM `paynsprays` WHERE `id`=%d", id);
	mysql_function_query(MainPipeline, string, true, "OnLoadPayNSprays", "i", id);
}

stock IsAdminSpawnedVehicle(vehicleid)
{
	for(new i = 0; i < sizeof(CreatedCars); ++i) {
		if(CreatedCars[i] == vehicleid) return 1;
	}
	return 0;
}

forward OnLoadPayNSpray(index);
public OnLoadPayNSpray(index)
{
	new rows, fields, tmp[128], string[128];
	cache_get_data(rows, fields, MainPipeline);

	for(new row; row < rows; row++)
	{
		cache_get_field_content(row, "id", tmp, MainPipeline);  PayNSprays[index][pnsSQLId] = strval(tmp);
		cache_get_field_content(row, "Status", tmp, MainPipeline); PayNSprays[index][pnsStatus] = strval(tmp);
		cache_get_field_content(row, "PosX", tmp, MainPipeline); PayNSprays[index][pnsPosX] = floatstr(tmp);
		cache_get_field_content(row, "PosY", tmp, MainPipeline); PayNSprays[index][pnsPosY] = floatstr(tmp);
		cache_get_field_content(row, "PosZ", tmp, MainPipeline); PayNSprays[index][pnsPosZ] = floatstr(tmp);
		cache_get_field_content(row, "VW", tmp, MainPipeline); PayNSprays[index][pnsVW] = strval(tmp);
		cache_get_field_content(row, "Int", tmp, MainPipeline); PayNSprays[index][pnsInt] = strval(tmp);
		cache_get_field_content(row, "GroupCost", tmp, MainPipeline); PayNSprays[index][pnsGroupCost] = strval(tmp);
		cache_get_field_content(row, "RegCost", tmp, MainPipeline); PayNSprays[index][pnsRegCost] = strval(tmp);
		if(PayNSprays[index][pnsStatus] > 0)
		{
			format(string, sizeof(string), "/suachuaxe\nPhi sua chua -- Khong uu tien: $%s | Uu tien ('Faction'): $%s\nID: %d", number_format(PayNSprays[index][pnsRegCost]), number_format(PayNSprays[index][pnsGroupCost]), index);
			PayNSprays[index][pnsTextID] = CreateDynamic3DTextLabel(string, COLOR_YELLOW, PayNSprays[index][pnsPosX], PayNSprays[index][pnsPosY], PayNSprays[index][pnsPosZ]+0.5,10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, PayNSprays[index][pnsVW], PayNSprays[index][pnsInt], -1);
			PayNSprays[index][pnsPickupID] = CreateDynamicPickup(1239, 23, PayNSprays[index][pnsPosX], PayNSprays[index][pnsPosY], PayNSprays[index][pnsPosZ], PayNSprays[index][pnsVW]);
			PayNSprays[index][pnsMapIconID] = CreateDynamicMapIcon(PayNSprays[index][pnsPosX], PayNSprays[index][pnsPosY], PayNSprays[index][pnsPosZ], 63, 0, PayNSprays[index][pnsVW], PayNSprays[index][pnsInt], -1, 500.0);
		}
	}
	return 1;
}

stock LoadPayNSprays()
{
	printf("[LoadPayNSprays] Loading data from database...");
	mysql_function_query(MainPipeline, "SELECT * FROM `paynsprays`", true, "OnLoadPayNSprays", "");
}

stock SaveArrestPoint(id)
{
	new string[1024];
	format(string, sizeof(string), "UPDATE `arrestpoints` SET \
		`PosX`=%f, \
		`PosY`=%f, \
		`PosZ`=%f, \
		`VW`=%d, \
		`Int`=%d, \
		`Type`=%d WHERE `id`=%d",
		ArrestPoints[id][arrestPosX],
		ArrestPoints[id][arrestPosY],
		ArrestPoints[id][arrestPosZ],
		ArrestPoints[id][arrestVW],
		ArrestPoints[id][arrestInt],
		ArrestPoints[id][arrestType],
		id
	);

	mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);
}

stock SaveArrestPoints()
{
	for(new i = 0; i < MAX_ARRESTPOINTS; i++)
	{
		SaveArrestPoint(i);
	}
	return 1;
}

stock RehashArrestPoint(id)
{
	DestroyDynamic3DTextLabel(ArrestPoints[id][arrestTextID]);
	DestroyDynamicPickup(ArrestPoints[id][arrestPickupID]);
	ArrestPoints[id][arrestSQLId] = -1;
	ArrestPoints[id][arrestPosX] = 0.0;
	ArrestPoints[id][arrestPosY] = 0.0;
	ArrestPoints[id][arrestPosZ] = 0.0;
	ArrestPoints[id][arrestVW] = 0;
	ArrestPoints[id][arrestInt] = 0;
	ArrestPoints[id][arrestType] = 0;
	LoadArrestPoint(id);
}

stock RehashArrestPoints()
{
	printf("[RehashArrestPoints] Deleting Arrest Points from server...");
	for(new i = 0; i < MAX_ARRESTPOINTS; i++)
	{
		RehashArrestPoint(i);
	}
	LoadArrestPoints();
}

stock LoadArrestPoint(id)
{
	new string[128];
	format(string, sizeof(string), "SELECT * FROM `arrestpoints` WHERE `id`=%d", id);
	mysql_function_query(MainPipeline, string, true, "OnLoadArrestPoints", "i", id);
}

stock LoadArrestPoints()
{
	printf("[LoadArrestPoints] Loading data from database...");
	mysql_function_query(MainPipeline, "SELECT * FROM `arrestpoints`", true, "OnLoadArrestPoints", "");
}

stock SaveImpoundPoint(id)
{
	new string[1024];
	format(string, sizeof(string), "UPDATE `impoundpoints` SET \
		`PosX`=%f, \
		`PosY`=%f, \
		`PosZ`=%f, \
		`VW`=%d, \
		`Int`=%d WHERE `id`=%d",
		ImpoundPoints[id][impoundPosX],
		ImpoundPoints[id][impoundPosY],
		ImpoundPoints[id][impoundPosZ],
		ImpoundPoints[id][impoundVW],
		ImpoundPoints[id][impoundInt],
		id
	);

	mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);
}

stock SaveImpoundPoints()
{
	for(new i = 0; i < MAX_ImpoundPoints; i++)
	{
		SaveImpoundPoint(i);
	}
	return 1;
}

stock RehashImpoundPoint(id)
{
	DestroyDynamic3DTextLabel(ImpoundPoints[id][impoundTextID]);
	ImpoundPoints[id][impoundSQLId] = -1;
	ImpoundPoints[id][impoundPosX] = 0.0;
	ImpoundPoints[id][impoundPosY] = 0.0;
	ImpoundPoints[id][impoundPosZ] = 0.0;
	ImpoundPoints[id][impoundVW] = 0;
	ImpoundPoints[id][impoundInt] = 0;
	LoadImpoundPoint(id);
}

stock RehashImpoundPoints()
{
	printf("[RehashImpoundPoints] Deleting impound Points from server...");
	for(new i = 0; i < MAX_ImpoundPoints; i++)
	{
		RehashImpoundPoint(i);
	}
	LoadImpoundPoints();
}

stock LoadImpoundPoint(id)
{
	new string[128];
	format(string, sizeof(string), "SELECT * FROM `impoundpoints` WHERE `id`=%d", id);
	mysql_function_query(MainPipeline, string, true, "OnLoadImpoundPoints", "i", id);
}

stock LoadImpoundPoints()
{
	printf("[LoadImpoundPoints] Loading data from database...");
	mysql_function_query(MainPipeline, "SELECT * FROM `impoundpoints`", true, "OnLoadImpoundPoints", "");
}

// credits to Luk0r
stock MySQLUpdateBuild(query[], sqlplayerid)
{
	new querylen = strlen(query);
	if (!query[0]) {
		format(query, 2048, "UPDATE `accounts` SET ");
	}
	else if (2048-querylen < 200)
	{
		new whereclause[32];
		format(whereclause, sizeof(whereclause), " WHERE `id`=%d", sqlplayerid);
		strcat(query, whereclause, 2048);
		mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
		format(query, 2048, "UPDATE `accounts` SET ");
	}
	else if (strfind(query, "=", true) != -1) strcat(query, ",", 2048);
	return 1;
}

stock MySQLUpdateFinish(query[], sqlplayerid)
{
	if (strcmp(query, "WHERE id=", false) == 0) mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	else
	{
		new whereclause[32];
		format(whereclause, sizeof(whereclause), " WHERE id=%d", sqlplayerid);
		strcat(query, whereclause, 2048);
		mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
		format(query, 2048, "UPDATE `accounts` SET ");
	}
	return 1;
}

stock SavePlayerInteger(query[], sqlid, Value[], Integer)
{
	MySQLUpdateBuild(query, sqlid);
	new updval[64];
	format(updval, sizeof(updval), "`%s`=%d", Value, Integer);
	strcat(query, updval, 2048);
	return 1;
}


stock SavePlayerString(query[], sqlid, Value[], String[])
{
	MySQLUpdateBuild(query, sqlid);
	new escapedstring[160], string[160];
	mysql_real_escape_string(String, escapedstring);
	format(string, sizeof(string), "`%s`='%s'", Value, escapedstring);
	strcat(query, string, 2048);
	return 1;
}

stock SavePlayerFloat(query[], sqlid, Value[], Float:Number)
{
	new flotostr[32];
	format(flotostr, sizeof(flotostr), "%0.2f", Number);
	SavePlayerString(query, sqlid, Value, flotostr);
	return 1;
}

stock g_mysql_SaveAccount(playerid)
{
    new query[2048];

	format(query, 2048, "UPDATE `accounts` SET `SPos_x` = '%0.2f', `SPos_y` = '%0.2f', `SPos_z` = '%0.2f', `SPos_r` = '%0.2f' WHERE id = '%d'",PlayerInfo[playerid][pPos_x], PlayerInfo[playerid][pPos_y], PlayerInfo[playerid][pPos_z], PlayerInfo[playerid][pPos_r], GetPlayerSQLId(playerid));
	mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);

    format(query, 2048, "UPDATE `accounts` SET ");
    SavePlayerString(query, GetPlayerSQLId(playerid), "IP", PlayerInfo[playerid][pIP]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Registered", PlayerInfo[playerid][pReg]);

    SavePlayerInteger(query, GetPlayerSQLId(playerid), "CMND", PlayerInfo[playerid][pCMND]);
    
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "FireLeg", PlayerInfo[playerid][pFireLeg]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "FireHead", PlayerInfo[playerid][pFireHead]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "FireTorso", PlayerInfo[playerid][pFireTorso]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Injured", PlayerInfo[playerid][pInjured]);

    SavePlayerInteger(query, GetPlayerSQLId(playerid), "ConnectedTime", PlayerInfo[playerid][pConnectHours]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Sex", PlayerInfo[playerid][pSex]);
    SavePlayerString(query, GetPlayerSQLId(playerid), "BirthDatez", PlayerInfo[playerid][pBirthDate]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Band", PlayerInfo[playerid][pBanned]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "PermBand", PlayerInfo[playerid][pPermaBanned]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Warnings", PlayerInfo[playerid][pWarns]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Disabled", PlayerInfo[playerid][pDisabled]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Level", PlayerInfo[playerid][pLevel]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "AdminLevel", PlayerInfo[playerid][pAdmin]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "pTimeAcceptDeath", PlayerInfo[playerid][pTimeAcceptDeath]);
    
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "pSettingTwo", PlayerInfo[playerid][pSettingTwo]);
    SavePlayerString(query, GetPlayerSQLId(playerid), "pSettingTwoPass",PlayerInfo[playerid][pSettingTwoPass]);
    

    SavePlayerInteger(query, GetPlayerSQLId(playerid), "pGiftDollar", PlayerInfo[playerid][pGiftDollar]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "pCasinoCrash", PlayerInfo[playerid][pCasinoCrash]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "pPayment", PlayerInfo[playerid][pPayment]);

    SavePlayerInteger(query, GetPlayerSQLId(playerid), "PlayerDrugTask", PlayerDrugTask[playerid]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "PlayerMaxDrugTask", PlayerMaxDrugTask[playerid]);

   
 
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "pCompany", PlayerInfo[playerid][pCompany]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "ReportCount", PlayerInfo[playerid][pAdvisorCount]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "ReportHourCount", ReportHourCount[playerid]);

    SavePlayerString(query, GetPlayerSQLId(playerid), "NameContact0",NameContact[playerid][0]);
    SavePlayerString(query, GetPlayerSQLId(playerid), "MPH", PlayerInfo[playerid][pMPH]);
    SavePlayerString(query, GetPlayerSQLId(playerid), "NameContact1",NameContact[playerid][1]);
    SavePlayerString(query, GetPlayerSQLId(playerid), "NameContact2",NameContact[playerid][2]);
    SavePlayerString(query, GetPlayerSQLId(playerid), "NameContact3",NameContact[playerid][3]);
    SavePlayerString(query, GetPlayerSQLId(playerid), "NameContact4",NameContact[playerid][4]);
    SavePlayerString(query, GetPlayerSQLId(playerid), "NameContact5",NameContact[playerid][5]);
    SavePlayerString(query, GetPlayerSQLId(playerid), "NameContact6",NameContact[playerid][6]);
    SavePlayerString(query, GetPlayerSQLId(playerid), "NameContact7",NameContact[playerid][7]);
    SavePlayerString(query, GetPlayerSQLId(playerid), "NameContact8",NameContact[playerid][8]);
    SavePlayerString(query, GetPlayerSQLId(playerid), "NameContact9",NameContact[playerid][9]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "NumberContact0",NumberContact[playerid][0]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "NumberContact1",NumberContact[playerid][1]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "NumberContact2",NumberContact[playerid][2]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "NumberContact3",NumberContact[playerid][3]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "NumberContact4",NumberContact[playerid][4]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "NumberContact5",NumberContact[playerid][5]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "NumberContact6",NumberContact[playerid][6]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "NumberContact7",NumberContact[playerid][7]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "NumberContact8",NumberContact[playerid][8]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "NumberContact9",NumberContact[playerid][9]);


    SavePlayerInteger(query, GetPlayerSQLId(playerid), "BangDan1", PlayerInfo[playerid][pBangDan][1]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "BangDan2", PlayerInfo[playerid][pBangDan][2]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "BangDan3", PlayerInfo[playerid][pBangDan][3]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "BangDan4", PlayerInfo[playerid][pBangDan][4]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "BangDan5", PlayerInfo[playerid][pBangDan][5]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "BangDan6", PlayerInfo[playerid][pBangDan][6]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "BangDan7", PlayerInfo[playerid][pBangDan][7]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "BangDan8", PlayerInfo[playerid][pBangDan][8]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "BangDan9", PlayerInfo[playerid][pBangDan][9]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "BangDan10", PlayerInfo[playerid][pBangDan][10]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "BangDan11", PlayerInfo[playerid][pBangDan][11]);
    
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Ammo1", PlayerInfo[playerid][pAmmo][1]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Ammo2", PlayerInfo[playerid][pAmmo][2]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Ammo3", PlayerInfo[playerid][pAmmo][3]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Ammo4", PlayerInfo[playerid][pAmmo][4]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Ammo5", PlayerInfo[playerid][pAmmo][5]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Ammo6", PlayerInfo[playerid][pAmmo][6]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Ammo7", PlayerInfo[playerid][pAmmo][7]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Ammo8", PlayerInfo[playerid][pAmmo][8]);

    SavePlayerInteger(query, GetPlayerSQLId(playerid), "pCountTruck", PlayerInfo[playerid][pCountTruck]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "pCountPizza", PlayerInfo[playerid][pCountPizza]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "pCountMiner", PlayerInfo[playerid][pCountMiner]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "pCountTrash", PlayerInfo[playerid][pCountTrash]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "pCountElec", PlayerInfo[playerid][pCountElec]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "pCountWork", PlayerInfo[playerid][pCountWork]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "pCountWood", PlayerInfo[playerid][pCountWood]);


    SavePlayerString(query, GetPlayerSQLId(playerid), "GiongNoi", PlayerInfo[playerid][pGiongNoi]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "playerTutorial",  Question_@TutorialQues[playerid]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "SeniorModerator", PlayerInfo[playerid][pSMod]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Helper", PlayerInfo[playerid][pHelper]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "DonateRank", PlayerInfo[playerid][pDonateRank]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Respect", PlayerInfo[playerid][pExp]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "XP", PlayerInfo[playerid][pXP]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Money", GetPlayerCash(playerid));
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "TruyDuoi", PlayerInfo[playerid][pTruyDuoi]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "BanTime", PlayerInfo[playerid][pBanTime]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "TimeBanned", PlayerInfo[playerid][pTimeBanned]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Flag", PlayerInfo[playerid][pFlag]);
	SavePlayerString(query, GetPlayerSQLId(playerid), "BannedBy", PlayerInfo[playerid][pBannedBy]);
	SavePlayerString(query, GetPlayerSQLId(playerid), "ReasonBanned", PlayerInfo[playerid][pReasonBanned]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Flag", PlayerInfo[playerid][pFlag]);

    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Bank", PlayerInfo[playerid][pAccount]);
    					
	// clothes
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Clothes0", PlayerInfo[playerid][pTrangPhuc][0]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Clothes1", PlayerInfo[playerid][pTrangPhuc][1]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Clothes2", PlayerInfo[playerid][pTrangPhuc][2]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Clothes3", PlayerInfo[playerid][pTrangPhuc][3]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Clothes4", PlayerInfo[playerid][pTrangPhuc][4]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Clothes5", PlayerInfo[playerid][pTrangPhuc][5]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Clothes6", PlayerInfo[playerid][pTrangPhuc][6]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Clothes7", PlayerInfo[playerid][pTrangPhuc][7]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Clothes8", PlayerInfo[playerid][pTrangPhuc][8]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Clothes9", PlayerInfo[playerid][pTrangPhuc][9]);
	// fitness system
    SavePlayerFloat(query, GetPlayerSQLId(playerid), "pFitness", PlayerFitness[playerid][pFitness]);
    SavePlayerFloat(query, GetPlayerSQLId(playerid), "pFitnessMax", PlayerFitness[playerid][pFitnessMax]);
    SavePlayerFloat(query, GetPlayerSQLId(playerid), "pFood", PlayerFitness[playerid][pFood]);
    SavePlayerFloat(query, GetPlayerSQLId(playerid), "pWater", PlayerFitness[playerid][pWater]);


    SavePlayerFloat(query, GetPlayerSQLId(playerid), "pHealth", PlayerInfo[playerid][pHealth]);
    SavePlayerFloat(query, GetPlayerSQLId(playerid), "pArmor", PlayerInfo[playerid][pArmor]);
    SavePlayerFloat(query, GetPlayerSQLId(playerid), "pSHealth", PlayerInfo[playerid][pSHealth]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Int", PlayerInfo[playerid][pInt]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "VirtualWorld", PlayerInfo[playerid][pVW]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Model", PlayerInfo[playerid][pModel]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "BanAppealer", PlayerInfo[playerid][pBanAppealer]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "PR", PlayerInfo[playerid][pPR]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "HR", PlayerInfo[playerid][pHR]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "AP", PlayerInfo[playerid][pAP]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Security", PlayerInfo[playerid][pSecurity]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "ShopTech", PlayerInfo[playerid][pShopTech]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "FactionModerator", PlayerInfo[playerid][pFactionModerator]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "GangModerator", PlayerInfo[playerid][pGangModerator]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Undercover", PlayerInfo[playerid][pUndercover]);

    SavePlayerInteger(query, GetPlayerSQLId(playerid), "TogReports", PlayerInfo[playerid][pTogReports]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Radio", PlayerInfo[playerid][pRadio]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "RadioFreq", PlayerInfo[playerid][pRadioFreq]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "UpgradePoints", PlayerInfo[playerid][gPupgrade]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Origin", PlayerInfo[playerid][pOrigin]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Muted", PlayerInfo[playerid][pMuted]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Crimes", PlayerInfo[playerid][pCrimes]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Accent", PlayerInfo[playerid][pAccent]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "CHits", PlayerInfo[playerid][pCHits]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "FHits", PlayerInfo[playerid][pFHits]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Arrested", PlayerInfo[playerid][pArrested]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Phonebook", PlayerInfo[playerid][pPhoneBook]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "LottoNr", PlayerInfo[playerid][pLottoNr]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Fishes", PlayerInfo[playerid][pFishes]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Gcoin", PlayerInfo[playerid][pGcoin]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "BiggestFish", PlayerInfo[playerid][pBiggestFish]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Job", PlayerInfo[playerid][pJob]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "SoTaiKhoan", PlayerInfo[playerid][pSoTaiKhoan]);



    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Job2", PlayerInfo[playerid][pJob2]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Paycheck", PlayerInfo[playerid][pPayCheck]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "HeadValue", PlayerInfo[playerid][pHeadValue]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "JailTime", PlayerInfo[playerid][pJailTime]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "WRestricted", PlayerInfo[playerid][pWRestricted]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Materials", PlayerInfo[playerid][pMats]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Crates", PlayerInfo[playerid][pCrates]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Pot", PlayerInfo[playerid][pPot]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Crack", PlayerInfo[playerid][pCrack]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Nation", PlayerInfo[playerid][pNation]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Leader", PlayerInfo[playerid][pLeader]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Member", PlayerInfo[playerid][pMember]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Division", PlayerInfo[playerid][pDivision]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "FMember", PlayerInfo[playerid][pFMember]);

    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Rank", PlayerInfo[playerid][pRank]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "DetSkill", PlayerInfo[playerid][pDetSkill]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "SexSkill", PlayerInfo[playerid][pSexSkill]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "BoxSkill", PlayerInfo[playerid][pBoxSkill]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "LawSkill", PlayerInfo[playerid][pLawSkill]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "MechSkill", PlayerInfo[playerid][pMechSkill]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "TruckSkill", PlayerInfo[playerid][pTruckSkill]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "DrugsSkill", PlayerInfo[playerid][pDrugsSkill]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "ArmsSkill", PlayerInfo[playerid][pArmsSkill]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "SmugglerSkill", PlayerInfo[playerid][pSmugSkill]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "FishSkill", PlayerInfo[playerid][pFishSkill]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "CheckCash", PlayerInfo[playerid][pCheckCash]);

    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Checks", PlayerInfo[playerid][pChecks]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "BoatLic", PlayerInfo[playerid][pBoatLic]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "FlyLic", PlayerInfo[playerid][pFlyLic]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "GunLic", PlayerInfo[playerid][pGunLic]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "FishLic", PlayerInfo[playerid][pFishLic]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "FishSkill", PlayerInfo[playerid][pFishSkill]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "FightingStyle", PlayerInfo[playerid][pFightStyle]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "PhoneNr", PlayerInfo[playerid][pPnumber]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Apartment", PlayerInfo[playerid][pPhousekey]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Apartment2", PlayerInfo[playerid][pPhousekey2]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Renting", PlayerInfo[playerid][pRenting]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "CarLic", PlayerInfo[playerid][pCarLic]);

    SavePlayerInteger(query, GetPlayerSQLId(playerid), "DrugsTime", PlayerInfo[playerid][pDrugsTime]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "LawyerTime", PlayerInfo[playerid][pLawyerTime]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "LawyerFreeTime", PlayerInfo[playerid][pLawyerFreeTime]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "MechTime", PlayerInfo[playerid][pMechTime]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "SexTime", PlayerInfo[playerid][pSexTime]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "PayDay", PlayerInfo[playerid][pConnectSeconds]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "PayDayHad", PlayerInfo[playerid][pPayDayHad]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "CDPlayer", PlayerInfo[playerid][pCDPlayer]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Dice", PlayerInfo[playerid][pDice]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Spraycan", PlayerInfo[playerid][pSpraycan]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Rope", PlayerInfo[playerid][pRope]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Cigars", PlayerInfo[playerid][pCigar]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Sprunk", PlayerInfo[playerid][pSprunk]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Bombs", PlayerInfo[playerid][pBombs]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Wins", PlayerInfo[playerid][pWins]);

    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Gun0", PlayerInfo[playerid][pGuns][0]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Gun1", PlayerInfo[playerid][pGuns][1]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Gun2", PlayerInfo[playerid][pGuns][2]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Gun3", PlayerInfo[playerid][pGuns][3]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Gun4", PlayerInfo[playerid][pGuns][4]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Gun5", PlayerInfo[playerid][pGuns][5]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Gun6", PlayerInfo[playerid][pGuns][6]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Gun7", PlayerInfo[playerid][pGuns][7]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Gun8", PlayerInfo[playerid][pGuns][8]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Gun9", PlayerInfo[playerid][pGuns][9]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Gun10", PlayerInfo[playerid][pGuns][10]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Gun11", PlayerInfo[playerid][pGuns][11]);




    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Loses", PlayerInfo[playerid][pLoses]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Tutorial", PlayerInfo[playerid][pTut]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "OnDuty", PlayerInfo[playerid][pDuty]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Hospital", PlayerInfo[playerid][pHospital]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "MarriedID", PlayerInfo[playerid][pMarriedID]);
    SavePlayerString(query, GetPlayerSQLId(playerid), "ContractBy", PlayerInfo[playerid][pContractBy]);
    SavePlayerString(query, GetPlayerSQLId(playerid), "ContractDetail", PlayerInfo[playerid][pContractDetail]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "WantedLevel", PlayerInfo[playerid][pWantedLevel]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Insurance", PlayerInfo[playerid][pInsurance]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "911Muted", PlayerInfo[playerid][p911Muted]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "NewMuted", PlayerInfo[playerid][pNMute]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "NewMutedTotal", PlayerInfo[playerid][pNMuteTotal]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "AdMuted", PlayerInfo[playerid][pADMute]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "AdMutedTotal", PlayerInfo[playerid][pADMuteTotal]);

    SavePlayerInteger(query, GetPlayerSQLId(playerid), "HelpMute", PlayerInfo[playerid][pHelpMute]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "ReportMuted", PlayerInfo[playerid][pRMuted]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "ReportMutedTotal", PlayerInfo[playerid][pRMutedTotal]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "ReportMutedTime", PlayerInfo[playerid][pRMutedTime]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "DMRMuted", PlayerInfo[playerid][pDMRMuted]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "VIPMuted", PlayerInfo[playerid][pVMuted]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "VIPMutedTime", PlayerInfo[playerid][pVMutedTime]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "GiftTime", PlayerInfo[playerid][pGiftTime]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "AdvisorDutyHours", PlayerInfo[playerid][pDutyHours]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "AcceptedHelp", PlayerInfo[playerid][pAcceptedHelp]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "AcceptReport", PlayerInfo[playerid][pAcceptReport]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "TrashReport", PlayerInfo[playerid][pTrashReport]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "GangWarn", PlayerInfo[playerid][pGangWarn]);

    SavePlayerInteger(query, GetPlayerSQLId(playerid), "CSFBanned", PlayerInfo[playerid][pCSFBanned]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "VIPInviteDay", PlayerInfo[playerid][pVIPInviteDay]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "TempVIP", PlayerInfo[playerid][pTempVIP]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "BuddyInvite", PlayerInfo[playerid][pBuddyInvited]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Tokens", PlayerInfo[playerid][pTokens]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "PTokens", PlayerInfo[playerid][pPaintTokens]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "TriageTime", PlayerInfo[playerid][pTriageTime]);
    SavePlayerString(query, GetPlayerSQLId(playerid), "PrisonedBy", PlayerInfo[playerid][pPrisonedBy]);
    SavePlayerString(query, GetPlayerSQLId(playerid), "PrisonReason", PlayerInfo[playerid][pPrisonReason]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "TaxiLicense", PlayerInfo[playerid][pTaxiLicense]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "TicketTime", PlayerInfo[playerid][pTicketTime]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Screwdriver", PlayerInfo[playerid][pScrewdriver]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Smslog", PlayerInfo[playerid][pSmslog]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Speedo", PlayerInfo[playerid][pSpeedo]);

    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Wristwatch", PlayerInfo[playerid][pWristwatch]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Surveillance", PlayerInfo[playerid][pSurveillance]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Tire", PlayerInfo[playerid][pTire]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Firstaid", PlayerInfo[playerid][pFirstaid]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Rccam", PlayerInfo[playerid][pRccam]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Receiver", PlayerInfo[playerid][pReceiver]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "GPS", PlayerInfo[playerid][pGPS]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Sweep", PlayerInfo[playerid][pSweep]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "SweepLeft", PlayerInfo[playerid][pSweepLeft]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Bugged", PlayerInfo[playerid][pBugged]);

    SavePlayerInteger(query, GetPlayerSQLId(playerid), "pWExists", PlayerInfo[playerid][pWeedObject]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "pWSeeds", PlayerInfo[playerid][pWSeeds]);
    SavePlayerString(query, GetPlayerSQLId(playerid), "Warrants", PlayerInfo[playerid][pWarrant]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "JudgeJailTime", PlayerInfo[playerid][pJudgeJailTime]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "JudgeJailType", PlayerInfo[playerid][pJudgeJailType]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "BeingSentenced", PlayerInfo[playerid][pBeingSentenced]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "ProbationTime", PlayerInfo[playerid][pProbationTime]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "DMKills", PlayerInfo[playerid][pDMKills]);

	SavePlayerInteger(query, GetPlayerSQLId(playerid), "OrderConfirmed", PlayerInfo[playerid][pOrderConfirmed]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "FreezeHouse", PlayerInfo[playerid][pFreezeHouse]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "FreezeCar", PlayerInfo[playerid][pFreezeCar]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Firework", PlayerInfo[playerid][pFirework]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Boombox", PlayerInfo[playerid][pBoombox]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Hydration", PlayerInfo[playerid][pHydration]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "DoubleEXP", PlayerInfo[playerid][pDoubleEXP]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "EXPToken", PlayerInfo[playerid][pEXPToken]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "RacePlayerLaps", PlayerInfo[playerid][pRacePlayerLaps]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Ringtone", PlayerInfo[playerid][pRingtone]);

	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Order", PlayerInfo[playerid][pOrder]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "CallsAccepted", PlayerInfo[playerid][pCallsAccepted]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "PatientsDelivered", PlayerInfo[playerid][pPatientsDelivered]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "LiveBanned", PlayerInfo[playerid][pLiveBanned]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "FreezeBank", PlayerInfo[playerid][pFreezeBank]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "VIPM", PlayerInfo[playerid][pVIPM]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "VIPMO", PlayerInfo[playerid][pVIPMO]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "VIPExpire", PlayerInfo[playerid][pVIPExpire]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "GVip", PlayerInfo[playerid][pGVip]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Watchdog", PlayerInfo[playerid][pWatchdog]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "VIPSold", PlayerInfo[playerid][pVIPSold]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "GoldBoxTokens", PlayerInfo[playerid][pGoldBoxTokens]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "DrawChance", PlayerInfo[playerid][pRewardDrawChance]);
	SavePlayerFloat(query, GetPlayerSQLId(playerid), "RewardHours", PlayerInfo[playerid][pRewardHours]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "CarsRestricted", PlayerInfo[playerid][pRVehRestricted]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "LastCarWarning", PlayerInfo[playerid][pLastRVehWarn]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "CarWarns", PlayerInfo[playerid][pRVehWarns]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Flagged", PlayerInfo[playerid][pFlagged]);

	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Paper", PlayerInfo[playerid][pPaper]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "MailEnabled", PlayerInfo[playerid][pMailEnabled]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Mailbox", PlayerInfo[playerid][pMailbox]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Business", PlayerInfo[playerid][pBusiness]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "BusinessRank", PlayerInfo[playerid][pBusinessRank]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "TreasureSkill", PlayerInfo[playerid][pTreasureSkill]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "MetalDetector", PlayerInfo[playerid][pMetalDetector]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "HelpedBefore", PlayerInfo[playerid][pHelpedBefore]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Trickortreat", PlayerInfo[playerid][pTrickortreat]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "LastCharmReceived", PlayerInfo[playerid][pLastCharmReceived]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "RHMutes", PlayerInfo[playerid][pRHMutes]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "RHMuteTime", PlayerInfo[playerid][pRHMuteTime]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "GiftCode", PlayerInfo[playerid][pGiftCode]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "OpiumSeeds", PlayerInfo[playerid][pOpiumSeeds]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "RawOpium", PlayerInfo[playerid][pRawOpium]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Heroin", PlayerInfo[playerid][pHeroin]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Syringe", PlayerInfo[playerid][pSyringes]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Skins", PlayerInfo[playerid][pSkins]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "HealthCare", PlayerInfo[playerid][pHealthCare]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "ReceivedCredits", PlayerInfo[playerid][pReceivedCredits]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "RimMod", PlayerInfo[playerid][pRimMod]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Tazer", PlayerInfo[playerid][pHasTazer]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Cuff", PlayerInfo[playerid][pHasCuff]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "CarVoucher", PlayerInfo[playerid][pCarVoucher]);
	SavePlayerString(query, GetPlayerSQLId(playerid), "ReferredBy", PlayerInfo[playerid][pReferredBy]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "PendingRefReward", PlayerInfo[playerid][pPendingRefReward]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Refers", PlayerInfo[playerid][pRefers]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Famed", PlayerInfo[playerid][pFamed]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "FamedMuted", PlayerInfo[playerid][pFMuted]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "DefendTime", PlayerInfo[playerid][pDefendTime]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "PVIPVoucher", PlayerInfo[playerid][pPVIPVoucher]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "VehicleSlot", PlayerInfo[playerid][pVehicleSlot]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "ToySlot", PlayerInfo[playerid][pToySlot]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "VehVoucher", PlayerInfo[playerid][pVehVoucher]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "SVIPVoucher", PlayerInfo[playerid][pSVIPVoucher]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "GVIPVoucher", PlayerInfo[playerid][pGVIPVoucher]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "GiftVoucher", PlayerInfo[playerid][pGiftVoucher]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "FallIntoFun", PlayerInfo[playerid][pFallIntoFun]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "HungerVoucher", PlayerInfo[playerid][pHungerVoucher]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "BoughtCure", PlayerInfo[playerid][pBoughtCure]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Vials", PlayerInfo[playerid][pVials]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "AdvertVoucher", PlayerInfo[playerid][pAdvertVoucher]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "ShopCounter", PlayerInfo[playerid][pShopCounter]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "ShopNotice", PlayerInfo[playerid][pShopNotice]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "SVIPExVoucher", PlayerInfo[playerid][pSVIPExVoucher]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "GVIPExVoucher", PlayerInfo[playerid][pGVIPExVoucher]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "VIPSellable", PlayerInfo[playerid][pVIPSellable]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "ReceivedPrize", PlayerInfo[playerid][pReceivedPrize]);

	MySQLUpdateFinish(query, GetPlayerSQLId(playerid));
	return 1;
}

stock SaveGate(id) {
	new string[512];
	format(string, sizeof(string), "UPDATE `gates` SET \
		`HID`=%d, \
		`Speed`=%f, \
		`Range`=%f, \
		`Model`=%d, \
		`VW`=%d, \
		`Int`=%d, \
		`Pass`='%s', \
		`PosX`=%f, \
		`PosY`=%f, \
		`PosZ`=%f, \
		`RotX`=%f, \
		`RotY`=%f, \
		`RotZ`=%f, \
		`PosXM`=%f, \
		`PosYM`=%f, \
		`PosZM`=%f, \
		`RotXM`=%f, \
		`RotYM`=%f, \
		`RotZM`=%f, \
		`Allegiance`=%d, \
		`GroupType`=%d, \
		`GroupID`=%d, \
		`FamilyID`=%d, \
		`RenderHQ`=%d, \
		`Timer`=%d, \
		`Automate`=%d, \
		`Locked`=%d \
		WHERE `ID` = %d",
		GateInfo[id][gHID],
		GateInfo[id][gSpeed],
		GateInfo[id][gRange],
		GateInfo[id][gModel],
		GateInfo[id][gVW],
		GateInfo[id][gInt],
		g_mysql_ReturnEscaped(GateInfo[id][gPass], MainPipeline),
		GateInfo[id][gPosX],
		GateInfo[id][gPosY],
		GateInfo[id][gPosZ],
		GateInfo[id][gRotX],
		GateInfo[id][gRotY],
		GateInfo[id][gRotZ],
		GateInfo[id][gPosXM],
		GateInfo[id][gPosYM],
		GateInfo[id][gPosZM],
		GateInfo[id][gRotXM],
		GateInfo[id][gRotYM],
		GateInfo[id][gRotZM],
		GateInfo[id][gAllegiance],
		GateInfo[id][gGroupType],
		GateInfo[id][gGroupID],
		GateInfo[id][gFamilyID],
		GateInfo[id][gRenderHQ],
		GateInfo[id][gTimer],
		GateInfo[id][gAutomate],
		GateInfo[id][gLocked],
		id+1
	);
	mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	return 0;
}

stock SaveAuction(auction) {
	new query[200];
	format(query, sizeof(query), "UPDATE `auctions` SET");
	format(query, sizeof(query), "%s `BiddingFor` = '%s', `InProgress` = %d, `Bid` = %d, `Bidder` = %d, `Expires` = %d, `Wining` = '%s', `Increment` = %d", query, g_mysql_ReturnEscaped(Auctions[auction][BiddingFor], MainPipeline), Auctions[auction][InProgress], Auctions[auction][Bid], Auctions[auction][Bidder], Auctions[auction][Expires], g_mysql_ReturnEscaped(Auctions[auction][Wining], MainPipeline), Auctions[auction][Increment]);
    format(query, sizeof(query), "%s WHERE `id` = %d", query, auction+1);
    mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "ii", SENDDATA_THREAD, INVALID_PLAYER_ID);
}

stock SaveDealershipSpawn(businessid) {
	new query[200];
	format(query, sizeof(query), "UPDATE `businesses` SET");
	format(query, sizeof(query), "%s `PurchaseX` = %0.5f, `PurchaseY` = %0.5f, `PurchaseZ` = %0.5f, `PurchaseAngle` = %0.5f", query, Businesses[businessid][bPurchaseX], Businesses[businessid][bPurchaseY], Businesses[businessid][bPurchaseZ], Businesses[businessid][bPurchaseAngle]);
    format(query, sizeof(query), "%s WHERE `Id` = %d", query, businessid+1);
    mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "ii", SENDDATA_THREAD, INVALID_PLAYER_ID);
}

stock SaveDealershipVehicle(businessid, slotid)
{
	new query[256];
	//slotid++;
	format(query, sizeof(query), "UPDATE `businesses` SET");
	format(query, sizeof(query), "%s `Car%dPosX` = %0.5f,", query, slotid, Businesses[businessid][bParkPosX][slotid]);
	format(query, sizeof(query), "%s `Car%dPosY` = %0.5f,", query, slotid, Businesses[businessid][bParkPosY][slotid]);
	format(query, sizeof(query), "%s `Car%dPosZ` = %0.5f,", query, slotid, Businesses[businessid][bParkPosZ][slotid]);
	format(query, sizeof(query), "%s `Car%dPosAngle` = %0.5f,", query, slotid, Businesses[businessid][bParkAngle][slotid]);
	format(query, sizeof(query), "%s `Car%dModelId` = %d,", query, slotid, Businesses[businessid][bModel][slotid]);
	format(query, sizeof(query), "%s `Car%dPrice` = %d", query, slotid, Businesses[businessid][bPrice][slotid]);
	format(query, sizeof(query), "%s WHERE `Id` = %d", query, businessid+1);
	mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "ii", SENDDATA_THREAD, INVALID_PLAYER_ID);
}

stock GetLatestKills(playerid, giveplayerid)
{
	new query[256];
	format(query, sizeof(query), "SELECT Killer.Username, Killed.Username, k.* FROM kills k LEFT JOIN accounts Killed ON k.killedid = Killed.id LEFT JOIN accounts Killer ON Killer.id = k.killerid WHERE k.killerid = %d OR k.killedid = %d ORDER BY `date` DESC LIMIT 10", GetPlayerSQLId(giveplayerid), GetPlayerSQLId(giveplayerid));
	mysql_function_query(MainPipeline, query, true, "OnGetLatestKills", "ii", playerid, giveplayerid);
}

stock GetSMSLog(playerid)
{
	new query[256];
	format(query, sizeof(query), "SELECT `sender`, `sendernumber`, `message`, `date` FROM `sms` WHERE `receiverid` = %d ORDER BY `date` DESC LIMIT 10", GetPlayerSQLId(playerid));
	mysql_function_query(MainPipeline, query, true, "OnGetSMSLog", "i", playerid);
}

stock LoadBusinessSales() {

	print("[LoadBusinessSales] Loading data from database...");
	mysql_function_query(MainPipeline, "SELECT * FROM `businesssales`", true, "LoadBusinessesSaless", "");
}

stock LoadBusinesses() {
	printf("[LoadBusinesses] Loading data from database...");
	mysql_function_query(MainPipeline, "SELECT OwnerName.Username, b.* FROM businesses b LEFT JOIN accounts OwnerName ON b.OwnerID = OwnerName.id", true, "BusinessesLoadQueryFinish", "");
}

stock LoadAuctions() {
	printf("[LoadAuctions] Loading data from database...");
	mysql_function_query(MainPipeline, "SELECT * FROM `auctions`", true, "AuctionLoadQuery", "");
}

stock LoadPlants() {
	printf("[LoadPlants] Loading data from database...");
	mysql_function_query(MainPipeline, "SELECT * FROM `plants`", true, "PlantsLoadQuery", "");
}

stock SaveBusinessSale(id)
{
	new query[200];
	format(query, 200, "UPDATE `businesssales` SET `BusinessID` = '%d', `Text` = '%s', `Price` = '%d', `Available` = '%d', `Purchased` = '%d', `Type` = '%d' WHERE `bID` = '%d'", BusinessSales[id][bBusinessID], BusinessSales[id][bText],
	BusinessSales[id][bPrice], BusinessSales[id][bAvailable], BusinessSales[id][bPurchased], BusinessSales[id][bType], BusinessSales[id][bID]);
	mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	printf("[BusinessSale] saved %i", id);
	return 1;
}

stock SavePlant(plant)
{
	new query[300];
	format(query, sizeof(query), "UPDATE `plants` SET `Owner` = %d, `Object` = %d, `PlantType` = %d, `PositionX` = %f, `PositionY` = %f, `PositionZ` = %f, `Virtual` = %d, \
	`Interior` = %d, `Growth` = %d, `Expires` = %d, `DrugsSkill` = %d WHERE `PlantID` = %d",Plants[plant][pOwner], Plants[plant][pObject], Plants[plant][pPlantType], Plants[plant][pPos][0], Plants[plant][pPos][1], Plants[plant][pPos][2],
	Plants[plant][pVirtual], Plants[plant][pInterior], Plants[plant][pGrowth], Plants[plant][pExpires], Plants[plant][pDrugsSkill], plant+1);
	mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	return 1;
}

stock SaveBusiness(id)
{
	new query[4019];

	format(query, sizeof(query), "UPDATE `businesses` SET ");

	format(query, sizeof(query), "%s \
	`Name` = '%s', `Type` = %d, `Value` = %d, `OwnerID` = %d, `Months` = %d, `SafeBalance` = %d, `Inventory` = %d, `InventoryCapacity` = %d, `Status` = %d, `Level` = %d, \
	`LevelProgress` = %d, `AutoSale` = %d, `OrderDate` = '%s', `OrderAmount` = %d, `OrderBy` = '%s', `OrderState` = %d, `TotalSales` = %d, ",
	query,
	g_mysql_ReturnEscaped(Businesses[id][bName], MainPipeline), Businesses[id][bType], Businesses[id][bValue], Businesses[id][bOwner], Businesses[id][bMonths], Businesses[id][bSafeBalance], Businesses[id][bInventory], Businesses[id][bInventoryCapacity], Businesses[id][bStatus], Businesses[id][bLevel],
	Businesses[id][bLevelProgress], Businesses[id][bAutoSale], Businesses[id][bOrderDate], Businesses[id][bOrderAmount], g_mysql_ReturnEscaped(Businesses[id][bOrderBy], MainPipeline), Businesses[id][bOrderState], Businesses[id][bTotalSales]);

	format(query, sizeof(query), "%s \
	`ExteriorX` = %f, `ExteriorY` = %f, `ExteriorZ` = %f, `ExteriorA` = %f, \
	`InteriorX` = %f, `InteriorY` = %f, `InteriorZ` = %f, `InteriorA` = %f, \
	`Interior` = %d, `CustomExterior` = %d, `CustomInterior` = %d, `Grade` = %d, `CustomVW` = %d, `SupplyPointX` = %f, `SupplyPointY` = %f, `SupplyPointZ` = %f,`NoThue` = %d, ",
	query,
	Businesses[id][bExtPos][0],	Businesses[id][bExtPos][1],	Businesses[id][bExtPos][2],	Businesses[id][bExtPos][3],
	Businesses[id][bIntPos][0],	Businesses[id][bIntPos][1], Businesses[id][bIntPos][2], Businesses[id][bIntPos][3],
	Businesses[id][bInt], Businesses[id][bCustomExterior], Businesses[id][bCustomInterior], Businesses[id][bGrade], Businesses[id][bVW], Businesses[id][bSupplyPos][0],Businesses[id][bSupplyPos][1], Businesses[id][bSupplyPos][2], Businesses[id][bNoThue]);

	for (new i; i < 17; i++) format(query, sizeof(query), "%s`Item%dPrice` = %d, ", query, i+1, Businesses[id][bItemPrices][i]);
	for (new i; i < 5; i++)	format(query, sizeof(query), "%s`Rank%dPay` = %d, ", query, i, Businesses[id][bRankPay][i], id);
	for (new i; i < MAX_BUSINESS_GAS_PUMPS; i++) format(query, sizeof(query), "%s `GasPump%dPosX` = %f, `GasPump%dPosY` = %f, `GasPump%dPosZ` = %f, `GasPump%dAngle` = %f, `GasPump%dModel` = %d, `GasPump%dCapacity` = %f, `GasPump%dGas` = %f, ", query, i+1, Businesses[id][GasPumpPosX][i],	i+1, Businesses[id][GasPumpPosY][i], i+1, Businesses[id][GasPumpPosZ][i], i+1, Businesses[id][GasPumpAngle][i], i+1, 1646,i+1, Businesses[id][GasPumpCapacity],	i+1, Businesses[id][GasPumpGallons]);

	format(query, sizeof(query), "%s \
	`Pay` = %d, `GasPrice` = %f, `MinInviteRank` = %d, `MinSupplyRank` = %d, `MinGiveRankRank` = %d, `MinSafeRank` = %d, `GymEntryFee` = %d, `GymType` = %d, `TotalProfits` = %d WHERE `Id` = %d",
	query,
	Businesses[id][bAutoPay], Businesses[id][bGasPrice], Businesses[id][bMinInviteRank], Businesses[id][bMinSupplyRank], Businesses[id][bMinGiveRankRank], Businesses[id][bMinSafeRank], Businesses[id][bGymEntryFee], Businesses[id][bGymType], Businesses[id][bTotalProfits], id+1);

	mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);

 	//printf("Len :%d", strlen(query));
	printf("[business] saved %i", id);

	return 1;
}

//--------------------------------[ CUSTOM PUBLIC FUNCTIONS ]---------------------------

forward OnPhoneNumberCheck(index, extraid);
public OnPhoneNumberCheck(index, extraid)
{
	if(IsPlayerConnected(index))
	{
		new string[128];
		new rows, fields;
		cache_get_data(rows, fields, MainPipeline);

		switch(extraid)
		{
			case 1: {
				if(rows)
				{
					SendClientMessageEx(index, COLOR_WHITE, "So dien thoat da duoc lay");
					DeletePVar(index, "PhChangerId");
					DeletePVar(index, "WantedPh");
					DeletePVar(index, "PhChangeCost");
					DeletePVar(index, "CurrentPh");
				}
				else
				{
					format(string,sizeof(string),"Cac so dien thoai yeu cau, %d, se co gia tong cong $%s.\n\nDe xac nhan, bam Dong y.", GetPVarInt(index, "WantedPh"), number_format(GetPVarInt(index, "PhChangeCost")));
					ShowPlayerDialog(index, VIPNUMMENU2, DIALOG_STYLE_MSGBOX, "Xac nhan", string, "Dong y", "Huy bo");
				}
			}
			case 2: {
				if(rows)
				{
					SendClientMessageEx(index, COLOR_WHITE, "Do la so dien thoai da duoc lay.");
				}
				else
				{
					PlayerInfo[index][pPnumber] = GetPVarInt(index, "WantedPh");
					GivePlayerMoneyEx(index, -GetPVarInt(index, "PhChangeCost"));
					format(string, sizeof(string), "UPDATE `accounts` SET `PhoneNr` = %d WHERE `id` = '%d'", PlayerInfo[index][pPnumber], GetPlayerSQLId(index));
					mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "ii", SENDDATA_THREAD, index);
					DeletePVar(index, "PhChangerId");
					DeletePVar(index, "WantedPh");
					DeletePVar(index, "PhChangeCost");
					DeletePVar(index, "CurrentPh");
				}
			}
			case 3: {
				if(rows && GetPVarInt(index, "WantedPh") != 0)
				{
					SendClientMessageEx(index, COLOR_WHITE, "Do la so dien thoai da duoc lay.");
				}
				else
				{
					PlayerInfo[index][pPnumber] = GetPVarInt(index, "WantedPh");
					format(string, sizeof(string), "   %s's So dien thoai da duoc thiet lap thanh %d.", GetPlayerNameEx(index), GetPVarInt(index, "WantedPh"));

					format(string, sizeof(string), "%s boi %s", string, GetPlayerNameEx(index));
					Log("logs/undercover.log", string);
					SendClientMessageEx(index, COLOR_GRAD1, string);
					format(string, sizeof(string), "UPDATE `accounts` SET `PhoneNr` = %d WHERE `id` = '%d'", PlayerInfo[index][pPnumber], GetPlayerSQLId(index));
					mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "ii", SENDDATA_THREAD, index);
					DeletePVar(index, "PhChangerId");
					DeletePVar(index, "WantedPh");
					DeletePVar(index, "PhChangeCost");
					DeletePVar(index, "CurrentPh");
				}
			}
			case 4: {
				if(IsPlayerConnected(GetPVarInt(index, "PhChangerId")))
				{
					if(rows)
					{
						SendClientMessageEx(GetPVarInt(index, "PhChangerId"), COLOR_WHITE, "Do la so dien thoai da duoc lay.");
					}
					else
					{
						PlayerInfo[index][pPnumber] = GetPVarInt(index, "WantedPh");
						format(string, sizeof(string), "   %s's So dien thoai da duoc thiet lap thanh %d.", GetPlayerNameEx(index), GetPVarInt(index, "WantedPh"));

						format(string, sizeof(string), "%s boi %s", string, GetPlayerNameEx(GetPVarInt(index, "PhChangerId")));
						Log("logs/stats.log", string);
						SendClientMessageEx(GetPVarInt(index, "PhChangerId"), COLOR_GRAD1, string);
						format(string, sizeof(string), "UPDATE `accounts` SET `PhoneNr` = %d WHERE `id` = '%d'", PlayerInfo[index][pPnumber], GetPlayerSQLId(index));
						mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "ii", SENDDATA_THREAD, index);
						DeletePVar(index, "PhChangerId");
						DeletePVar(index, "WantedPh");
						DeletePVar(index, "PhChangeCost");
						DeletePVar(index, "CurrentPh");
					}
				}
			}
		}
	}
	return 1;
}

forward AddingBan(index, type);
public AddingBan(index, type)
{
    if(IsPlayerConnected(index))
	{
	    if(type == 1) // Add Ban
	    {
    		new rows, fields;
    		cache_get_data(rows, fields, MainPipeline);
    		if(rows)
    		{
    		    DeletePVar(index, "BanningPlayer");
    		    DeletePVar(index, "BanningReason");
    		    SendClientMessageEx(index, COLOR_GREY, "Nguoi choi da bi cam.");
    		}
    		else
    		{
    		    if(IsPlayerConnected(GetPVarInt(index, "BanningPlayer")))
    		    {
    		    	new string[150], reason[64];
    		    	GetPVarString(index, "BanningReason", reason, sizeof(reason));

		    	    format(string, sizeof(string), "INSERT INTO `ip_bans` (`ip`, `date`, `reason`, `admin`) VALUES ('%s', NOW(), '%s', '%s')", GetPlayerIpEx(GetPVarInt(index, "BanningPlayer")), reason, GetPlayerNameEx(index));
					mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);

					DeletePVar(index, "BanningPlayer");
		    	    DeletePVar(index, "BanningReason");
				}
	    	}
		}
		else if(type == 2) // Unban IP
		{
		    new rows, fields;
		    cache_get_data(rows, fields, MainPipeline);
		    if(rows)
		    {
		        new string[128], ip[32];
		        GetPVarString(index, "UnbanIP", ip, sizeof(ip));

		        format(string, sizeof(string), "DELETE FROM `ip_bans` WHERE `ip` = '%s'", ip);
				mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);

				DeletePVar(index, "UnbanIP");
		    }
		    else
		    {
		        SendClientMessageEx(index, COLOR_GREY, "Dia chi IP khong duoc tim thay trong co so du lieu cua ban.");
				DeletePVar(index, "UnbanIP");
			}
		}
		else if(type == 3) // Ban IP
		{
		    new rows, fields;
		    cache_get_data(rows, fields, MainPipeline);
		    if(rows)
		    {
		        SendClientMessageEx(index, COLOR_GREY, "Dia chi IP bi cam.");
				DeletePVar(index, "BanIP");
		    }
		    else
		    {
		        new string[128], ip[32];
		        GetPVarString(index, "BanIP", ip, sizeof(ip));
		        format(string, sizeof(string), "INSERT INTO `ip_bans` (`ip`, `date`, `reason`, `admin`) VALUES ('%s', NOW(), '%s', '%s')", ip, "/banip", GetPlayerNameEx(index));
				mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);

		        SendClientMessageEx(index, COLOR_WHITE, "Dia chi IP da bi cam thanh cong.");
				DeletePVar(index, "BanIP");
			}
		}
	}
	return 1;
}

forward MailsQueryFinish(playerid);
public MailsQueryFinish(playerid)
{

    new rows, fields;
	cache_get_data(rows, fields, MainPipeline);

	if (rows == 0) {
		ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, " ", "Hop thu cua ban trong.", "Dong y", "");
		return 1;
	}

    new id, string[2000], message[129], tmp[128], read;
	for(new i; i < rows;i++)
	{
    	cache_get_field_content(i, "Id", tmp, MainPipeline);  	id = strval(tmp);
    	cache_get_field_content(i, "Read", tmp, MainPipeline); read= strval(tmp);
    	cache_get_field_content(i, "Message", message, MainPipeline, 129);
		strmid(message,message,0,30);
		if (strlen(message) > 30) strcat(message,"...");
		strcat(string, (read) ? ("{BBBBBB}") : ("{FFFFFF}"));
		strcat(string, message);
		if (i != rows - 1) strcat(string, "\n");
		ListItemTrackId[playerid][i] = id;
	}

    ShowPlayerDialog(playerid, DIALOG_POMAILS, DIALOG_STYLE_LIST, "Mail cua ban", string, "Doc", "Dong");

	return 1;
}

forward MailDetailsQueryFinish(playerid);
public MailDetailsQueryFinish(playerid)
{
	new string[256];
    new rows, fields;
	cache_get_data(rows, fields, MainPipeline);

	new senderid, sender[MAX_PLAYER_NAME], message[131], notify, szTmp[128], Date[32], read, id;
	cache_get_field_content(0, "Id", szTmp, MainPipeline);	    	id = strval(szTmp);
	cache_get_field_content(0, "Notify", szTmp, MainPipeline);	    notify = strval(szTmp);
	cache_get_field_content(0, "Sender_Id", szTmp, MainPipeline);	senderid = strval(szTmp);
	cache_get_field_content(0, "Read", szTmp, MainPipeline);		read = strval(szTmp);
	cache_get_field_content(0, "Message", message, MainPipeline, 131);
	cache_get_field_content(0, "SenderUser", sender, MainPipeline, MAX_PLAYER_NAME);
	cache_get_field_content(0, "Date", Date, MainPipeline, 32);

	if (strlen(message) > 80) strins(message, "\n", 70);

	format(string, sizeof(string), "{EEEEEE}%s\n\n{BBBBBB}Nguoi gui: {FFFFFF}%s\n{BBBBBB}Ngay: {EEEEEE}%s", message, sender,Date);
	ShowPlayerDialog(playerid, DIALOG_PODETAIL, DIALOG_STYLE_MSGBOX, "Mail Content", string, "Quay lai", "Thu rac");

	if (notify && !read) {
		foreach(new i: Player)
		{
			if (GetPlayerSQLId(i) == senderid)	{
			    format(string, sizeof(string), "Tin nhan cua ban vua duoc doc boi %s!", GetPlayerNameEx(playerid));
			    SendClientMessageEx(i, COLOR_YELLOW, string);
			    break;
			}
		}
	}

	format(string, sizeof(string), "UPDATE `letters` SET `Read` = 1 WHERE `id` = %d", id);
	mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);

	return 1;
}


forward MailDeliveryQueryFinish();
public MailDeliveryQueryFinish()
{

    new rows, fields, id, tmp[128], i;
	cache_get_data(rows, fields, MainPipeline);

	for(; i < rows;i++)
	{
    	cache_get_field_content(i, "Receiver_Id", tmp, MainPipeline);
    	id = strval(tmp);
		foreach(new j: Player)
		{
			if (GetPlayerSQLId(j) == id) {
				if (PlayerInfo[j][pDonateRank] >= 4 && HasMailbox(j))	{
					SendClientMessageEx(j, COLOR_YELLOW, "Mot tin nhan vua duoc gui den hop mail cua ban.");
					SetPVarInt(j, "UnreadMails", 1);
					break;
				}

			}
		}
 	}

	return 1;

}


forward MDCQueryFinish(playerid, suspectid);
public MDCQueryFinish(playerid, suspectid)
{
    new rows, fields;
	cache_get_data(rows, fields, MainPipeline);
    new resultline[1424];
    new crimes = PlayerInfo[suspectid][pCrimes];
	new arrests = PlayerInfo[suspectid][pArrested];
	format(resultline, sizeof(resultline), "{FF6347}Ten:{BFC0C2} %s\t{FF6347}So dien thoai:{BFC0C2} %d\n{FF6347}Tong so toi ac: {BFC0C2}%d\t {FF6347}Tong lan bat giu: {BFC0C2}%d \n{FF6347}Crime Key: {FF7D7D}Truy na hien tai/{BFC0C2}Toi ac qua khu\n\n", GetPlayerNameEx(suspectid),PlayerInfo[suspectid][pPnumber], crimes, arrests);

	for(new i; i < rows; i++)
	{
	    cache_get_field_content(i, "issuer", MDCInfo[i][mdcIssuer], MainPipeline, MAX_PLAYER_NAME);
	    cache_get_field_content(i, "crime", MDCInfo[i][mdcCrime], MainPipeline, 64);
	    cache_get_field_content(i, "active", MDCInfo[i][mdcActive], MainPipeline, 2);
	    if(strval(MDCInfo[i][mdcActive]) == 1)
	    {
	        format(resultline, sizeof(resultline),"%s{FF6347}Crime: {FF7D7D}%s \t{FF6347}Charged by:{BFC0C2} %s\n",resultline, MDCInfo[i][mdcCrime], MDCInfo[i][mdcIssuer]);
		} else {
			format(resultline, sizeof(resultline),"%s{FF6347}Crime: {BFC0C2}%s \t{FF6347}Charged by:{BFC0C2} %s\n",resultline, MDCInfo[i][mdcCrime], MDCInfo[i][mdcIssuer]);
		}
	}
	ShowPlayerDialog(playerid, MDC_SHOWCRIMES, DIALOG_STYLE_MSGBOX, "SA-MDC - Criminal History", resultline, "Quay lai", "");
	return 1;
}

forward MDCReportsQueryFinish(playerid, suspectid);
public MDCReportsQueryFinish(playerid, suspectid)
{
    new rows, fields;
	cache_get_data(rows, fields, MainPipeline);
    new resultline[1424], str[12];
    new copname[MAX_PLAYER_NAME], datetime[64], reportsid;
	for(new i; i < rows; i++)
	{
		cache_get_field_content(i, "id", str, MainPipeline, 12); reportsid = strval(str);
	    cache_get_field_content(i, "Username", copname, MainPipeline, MAX_PLAYER_NAME);
	    cache_get_field_content(i, "datetime", datetime, MainPipeline, 64);
	    format(resultline, sizeof(resultline),"%s{FF6347}Bao cao (%d) {FF7D7D}Arrested by: %s on %s\n",resultline, reportsid, copname,datetime);
	}
	ShowPlayerDialog(playerid, MDC_SHOWREPORTS, DIALOG_STYLE_LIST, "SA-MDC - Criminal History", resultline, "Quay lai", "");
	return 1;
}

forward MDCReportQueryFinish(playerid, reportid);
public MDCReportQueryFinish(playerid, reportid)
{
    new rows, fields;
	cache_get_data(rows, fields, MainPipeline);
    new resultline[1424];
    new copname[MAX_PLAYER_NAME], datetime[64], shortreport[200];
	for(new i; i < rows; i++)
	{
	    cache_get_field_content(i, "Username", copname, MainPipeline, MAX_PLAYER_NAME);
	    cache_get_field_content(i, "datetime", datetime, MainPipeline, 64);
	    cache_get_field_content(i, "shortreport", shortreport, MainPipeline, 200);
	    format(resultline, sizeof(resultline),"{FF6347}Bao cao #%d\n{FF7D7D}Arrested by: %s on %s\n{FF6347}Bao cao:{BFC0C2} %s\n",reportid, copname,datetime, shortreport);
	}
	ShowPlayerDialog(playerid, MDC_SHOWCRIMES, DIALOG_STYLE_MSGBOX, "SA-MDC - Arrest Report", resultline, "Quay lai", "");
	return 1;
}

forward FlagQueryFinish(playerid, suspectid, queryid);
public FlagQueryFinish(playerid, suspectid, queryid)
{
    new rows, fields;
	cache_get_data(rows, fields, MainPipeline);
    new resultline[2000];
    new header[64], sResult[64];
    new FlagID, FlagIssuer[MAX_PLAYER_NAME], FlagText[64], FlagDate[24];
	switch(queryid)
	{
	    case Flag_Query_Display:
	    {
			format(header, sizeof(header), "{FF6347}Flag History for{BFC0C2} %s", GetPlayerNameEx(suspectid));

			for(new i; i < rows; i++)
			{
			    cache_get_field_content(i, "fid", sResult, MainPipeline); FlagID = strval(sResult);
			    cache_get_field_content(i, "issuer", FlagIssuer, MainPipeline, MAX_PLAYER_NAME);
			    cache_get_field_content(i, "flag", FlagText, MainPipeline, 64);
			    cache_get_field_content(i, "time", FlagDate, MainPipeline, 24);
				format(resultline, sizeof(resultline),"%s{FF6347}Flag (ID: %d): {BFC0C2} %s \t{FF6347}Issued by:{BFC0C2} %s \t{FF6347}Date: {BFC0C2}%s\n",resultline, FlagID, FlagText, FlagIssuer, FlagDate);
			}
			if(rows == 0)
			{
				format(resultline, sizeof(resultline),"{FF6347}No Flags on this account");
			}
			ShowPlayerDialog(playerid, FLAG_LIST, DIALOG_STYLE_MSGBOX, header, resultline, "Delete Flag", "Dong");
		}
		case Flag_Query_Offline:
		{
			new string[128], name[24], reason[64], psqlid[12];
			GetPVarString(playerid, "OnAddFlag", name, 24);
			GetPVarString(playerid, "OnAddFlagReason", reason, 64);
			SendClientMessage(playerid, COLOR_YELLOW, string);
			if(rows > 0) {
				format(string, sizeof(string), "You have appended %s's flag.", name);
				SendClientMessageEx(playerid, COLOR_WHITE, string);

				format(string, sizeof(string), "AdmCmd: %s was offline flagged by %s, reason: %s.", name, GetPlayerNameEx(playerid), reason);
				ABroadCast(COLOR_LIGHTRED, string, 2);

				format(string, sizeof(string), "%s was offline flagged by %s (%s).", name, GetPlayerNameEx(playerid), reason);
				Log("logs/flags.log", string);

				cache_get_field_content(0, "id", psqlid, MainPipeline);

				AddOFlag(strval(psqlid), playerid, reason);
			}
			else {
				format(string, sizeof(string), "There was a problem with appending %s's flag.", name);
				SendClientMessageEx(playerid, COLOR_WHITE, string);
			}
			DeletePVar(playerid, "OnAddFlagReason");
		}
		case Flag_Query_Count:
		{
		    PlayerInfo[playerid][pFlagged] = rows;
		}
	}
	return 1;
}

forward SkinQueryFinish(playerid, queryid);
public SkinQueryFinish(playerid, queryid)
{
    new rows, fields;
	cache_get_data(rows, fields, MainPipeline);
    new resultline[2000], header[32], sResult[64], skinid;
	switch(queryid)
	{
	    case Skin_Query_Display:
	    {
			if(PlayerInfo[playerid][pDonateRank] <= 0) format(header, sizeof(header), "Closet -- Space: %d/10", PlayerInfo[playerid][pSkins]);
			else if(PlayerInfo[playerid][pDonateRank] > 0) format(header, sizeof(header), "Closet -- Space: %d/25", PlayerInfo[playerid][pSkins]);

			if(rows == 0) return SendClientMessageEx(playerid, COLOR_GREY, "There are no clothes in this closet!");
			for(new i; i < rows; i++)
			{
			    cache_get_field_content(i, "skinid", sResult, MainPipeline); skinid = strval(sResult);
				format(resultline, sizeof(resultline),"%sSkin ID: %d\n",resultline, skinid);
			}
			ShowPlayerDialog(playerid, SKIN_LIST, DIALOG_STYLE_LIST, header, resultline, "Select", "Cancel");
		}
		case Skin_Query_Count:
		{
		    PlayerInfo[playerid][pSkins] = rows;
		}
		case Skin_Query_ID:
		{
		    for(new i; i < rows; i++)
			{
			    cache_get_field_content(i, "skinid", sResult, MainPipeline); skinid = strval(sResult);
				if(i == GetPVarInt(playerid, "closetchoiceid"))
				{
					SetPVarInt(playerid, "closetskinid", skinid);
					SetPlayerSkin(playerid, skinid);
					ShowPlayerDialog(playerid, SKIN_CONFIRM, DIALOG_STYLE_MSGBOX, "Tu quan ao", "Ban muon thay doi quan ao?", "Dong y", "Quay lai");
				}
			}
		}
		case Skin_Query_Delete:
	    {
			if(PlayerInfo[playerid][pDonateRank] <= 0) format(header, sizeof(header), "Closet -- Space: %d/10", PlayerInfo[playerid][pSkins]);
			else if(PlayerInfo[playerid][pDonateRank] > 0) format(header, sizeof(header), "Closet -- Space: %d/25", PlayerInfo[playerid][pSkins]);

			if(rows == 0) return SendClientMessageEx(playerid, COLOR_GREY, "Khong co quan ao trong tu!");
			for(new i; i < rows; i++)
			{
			    cache_get_field_content(i, "skinid", sResult, MainPipeline); skinid = strval(sResult);
				format(resultline, sizeof(resultline),"%sSkin ID: %d\n",resultline, skinid);
			}
			ShowPlayerDialog(playerid, SKIN_DELETE, DIALOG_STYLE_LIST, header, resultline, "Chon", "Huy bo");
		}
		case Skin_Query_Delete_ID:
		{
		    for(new i; i < rows; i++)
			{
			    cache_get_field_content(i, "id", sResult, MainPipeline); skinid = strval(sResult);
				if(i == GetPVarInt(playerid, "closetchoiceid"))
				{
					SetPVarInt(playerid, "closetskinid", skinid);
					ShowPlayerDialog(playerid, SKIN_DELETE2, DIALOG_STYLE_MSGBOX, "Closet", "Ban co chac chan muon loai bo quan ao nay?", "Dong y", "Huy bo");
				}
			}
		}
	}
	return 1;
}


forward CitizenQueryFinish(playerid, queryid);
public CitizenQueryFinish(playerid, queryid)
{
    new rows, fields;
	cache_get_data(rows, fields, MainPipeline);
	switch(queryid)
	{
	    case TR_Citizen_Count:
	    {
			TRCitizens = rows;
		}
		case Total_Count:
		{
		    TotalCitizens = rows;
		}
	}
	return 1;
}

forward NationQueueQueryFinish(playerid, nation, queryid);
public NationQueueQueryFinish(playerid, nation, queryid)
{
    new query[300], resultline[2000], sResult[64], rows, fields;
	cache_get_data(rows, fields, MainPipeline);
	switch(queryid)
	{
		case CheckQueue:
	    {
			if(rows == 0)
			{
				format(query, sizeof(query), "INSERT INTO `nation_queue` (`id`, `playerid`, `name`, `date`, `nation`, `status`) VALUES (NULL, %d, '%s', NOW(), %d, 1)", GetPlayerSQLId(playerid), GetPlayerNameEx(playerid), nation);
				mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
				SendClientMessageEx(playerid, COLOR_GREY, "Ban da duoc them vao danh sach yeu cau vao quoc gia. Bay gio lanh dao cua quoc gia co the chon chap nhan hoac tu choi yeu cau cua ban.");
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_GREY, "Ban da co trong hang doi de tham gia vao mot quoc gia.");
			}
		}
		case UpdateQueue:
	    {
			if(rows > 0)
			{
				format(query, sizeof(query), "UPDATE `nation_queue` SET `name` = '%s' WHERE `playerid` = %d", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid));
				mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
			}
		}
		case AppQueue:
	    {
			new sDate[32];
			if(rows == 0) return SendClientMessageEx(playerid, COLOR_GREY, "Hien tai khong co yeu cau dang cho giai quyet.");
			for(new i; i < rows; i++)
			{
				cache_get_field_content(i, "name", sResult, MainPipeline, MAX_PLAYER_NAME);
				cache_get_field_content(i, "date", sDate, MainPipeline, 32);
				format(resultline, sizeof(resultline), "%s%s -- Date Submitted: %s\n", resultline, sResult, sDate);
			}
			ShowPlayerDialog(playerid, NATION_APP_LIST, DIALOG_STYLE_LIST, "Yeu cau vao quoc gia", resultline, "Chon", "Huy bo");
		}
	    case AddQueue:
	    {
			if(rows == 0)
			{
				format(query, sizeof(query), "INSERT INTO `nation_queue` (`id`, `playerid`, `name`, `date`, `nation`, `status`) VALUES (NULL, %d, '%s', NOW(), %d, 2)", GetPlayerSQLId(playerid), GetPlayerNameEx(playerid), nation);
				mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
				PlayerInfo[playerid][pNation] = 1;
			}
			else
			{
				format(query, sizeof(query), "INSERT INTO `nation_queue` (`id`, `playerid`, `name`, `date`, `nation`, `status`) VALUES (NULL, %d, NOW(), %d, 1)", GetPlayerSQLId(playerid), GetPlayerNameEx(playerid), nation);
				mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
			}
		}
	}
	return 1;
}

forward NationAppFinish(playerid, queryid);
public NationAppFinish(playerid, queryid)
{
    new query[300], string[128], sResult[64], rows, fields;
	cache_get_data(rows, fields, MainPipeline);
	switch(queryid)
	{
		case AcceptApp:
	    {
			for(new i; i < rows; i++)
			{
				cache_get_field_content(i, "id", sResult, MainPipeline); new AppID = strval(sResult);
				cache_get_field_content(i, "playerid", sResult, MainPipeline); new UserID = strval(sResult);
				cache_get_field_content(i, "name", sResult, MainPipeline, MAX_PLAYER_NAME);
				if(GetPVarInt(playerid, "Nation_App_ID") == i)
				{
					format(query, sizeof(query), "UPDATE `nation_queue` SET `status` = 2 WHERE `id` = %d", AppID);
					mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);

					new giveplayerid = ReturnUser(sResult);
					switch(arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance])
					{
						case 1:
						{
							if(IsPlayerConnected(giveplayerid))
							{
								PlayerInfo[giveplayerid][pNation] = 0;
								SendClientMessageEx(giveplayerid, COLOR_WHITE, "Yeu cau cua ban vao cong dan San Andreas da duoc phe duyet!");
							}
							else
							{
								format(query, sizeof(query), "UPDATE `accounts` SET `Nation` = 0 WHERE `id` = %d", UserID);
								mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
							}
							format(string, sizeof(string), "%s da phe duyet %s's yeu cau la cong dan San Andreas", GetPlayerNameEx(playerid), sResult);
						}
						case 2:
						{
							if(IsPlayerConnected(giveplayerid))
							{
								PlayerInfo[giveplayerid][pNation] = 1;
								SendClientMessageEx(giveplayerid, COLOR_WHITE, "Yeu cau cua ban la cong dan Tierra Robada da duoc phe duyet!");
							}
							else
							{
								format(query, sizeof(query), "UPDATE `accounts` SET `Nation` = 1 WHERE `id` = %d", UserID);
								mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
							}
							format(string, sizeof(string), "%s da phe duyet %s's yeu cau la cong dan Tierra Robada", GetPlayerNameEx(playerid), sResult);
						}
					}
					Log("logs/gov.log", string);
					format(string, sizeof(string), "Ban da phe duyet thanh cong yeu cau cua %s's.", sResult);
					SendClientMessageEx(playerid, COLOR_WHITE, string);
					DeletePVar(playerid, "Nation_App_ID");
				}
			}
		}
	    case DenyApp:
	    {
			for(new i; i < rows; i++)
			{
				cache_get_field_content(i, "id", sResult, MainPipeline, 32); new AppID = strval(sResult);
				cache_get_field_content(i, "name", sResult, MainPipeline, MAX_PLAYER_NAME);
				if(GetPVarInt(playerid, "Nation_App_ID") == i)
				{
					format(query, sizeof(query), "UPDATE `nation_queue` SET `status` = 3 WHERE `id` = %d", AppID);
					mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
					new giveplayerid = ReturnUser(sResult);
					switch(arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance])
					{
						case 1:
						{
							if(IsPlayerConnected(giveplayerid)) SendClientMessageEx(giveplayerid, COLOR_GREY, "Yeu cau la cong dan San Andreas bi tu choi.");
							format(string, sizeof(string), "%s has denied %s's application for San Andreas citizenship", GetPlayerNameEx(playerid), sResult);
						}
						case 2:
						{
							if(IsPlayerConnected(giveplayerid)) SendClientMessageEx(giveplayerid, COLOR_GREY, "Yeu cau la cong San Andreas cua ban bi tu choi.");
							format(string, sizeof(string), "%s has denied %s's application for Tierra Robada citizenship", GetPlayerNameEx(playerid), sResult);
						}
					}
					Log("logs/gov.log", string);
					format(string, sizeof(string), "Ban da tu choi thanh cong yeu cau %s's.", sResult);
					SendClientMessageEx(playerid, COLOR_WHITE, string);
					DeletePVar(playerid, "Nation_App_ID");
				}
			}
		}
	}
	return 1;
}

forward CountAmount(playerid);
public CountAmount(playerid)
{
    new rows, fields;
	cache_get_data(rows, fields, MainPipeline);
	PlayerInfo[playerid][pLottoNr] = rows;
	return 1;
}

forward UnreadMailsNotificationQueryFin(playerid);
public UnreadMailsNotificationQueryFin(playerid)
{
	new szResult[8];
	cache_get_field_content(0, "Unread_Count", szResult, MainPipeline);
	if (strval(szResult) > 0) {
		SetPVarInt(playerid, "UnreadMails", 1);
		SendClientMessageEx(playerid, COLOR_YELLOW, "Ban co cac thu chua doc trong hop thu cua minh.");
	}
	return 1;
}


forward RecipientLookupFinish(playerid);
public RecipientLookupFinish(playerid)
{
	new rows,fields,szResult[16], admin, undercover, id;
	cache_get_data(rows, fields, MainPipeline);

	if (!rows) return ShowPlayerDialog(playerid, DIALOG_PORECEIVER, DIALOG_STYLE_INPUT, "Nguoi nhan", "{FF3333}Error: {FFFFFF}Nguoi nhan khong hop le - Tai khoan khong ton tai!\n\nVui long nhap ten nguoi nhan (online hoac offline)", "Trang Tiep", "Huy bo");

	cache_get_field_content(0, "AdminLevel", szResult, MainPipeline); admin = strval(szResult);
	cache_get_field_content(0, "TogReports", szResult, MainPipeline); undercover = strval(szResult);
	cache_get_field_content(0, "id", szResult, MainPipeline); id = strval(szResult);

	if (admin >= 2 && undercover == 0) return ShowPlayerDialog(playerid, DIALOG_PORECEIVER, DIALOG_STYLE_INPUT, "Nguoi nhan", "{FF3333}Loi: {FFFFFF}Ban khong the gui thu cho Admin!\n\nVui long nhap ten nguoi nhan (online hoac offline)", "Trang Tiep", "Huy bo");

	SetPVarInt(playerid, "LetterRecipient", id);
	ShowPlayerDialog(playerid, DIALOG_POMESSAGE, DIALOG_STYLE_INPUT, "Gui thu", "{FFFFFF}Vui long nhap noi dung tin nhan.", "Gui Thu", "Huy bo");

	return 1;

}

forward CheckSales(index);
public CheckSales(index)
{
	if(IsPlayerConnected(index))
	{
	    new rows, fields, szDialog[128];
		cache_get_data(rows, fields, MainPipeline);
	    if(rows > 0)
		{
  			for(new i;i < rows;i++)
			{
			    new szResult[32], id;
			    cache_get_field_content(i, "id", szResult, MainPipeline); id = strval(szResult);
   				cache_get_field_content(i, "Month", szResult, MainPipeline, 25);
   				format(szDialog, sizeof(szDialog), "%s\n%s ", szDialog, szResult);
   				Selected[index][i] = id;
			}
			ShowPlayerDialog(index, DIALOG_VIEWSALE, DIALOG_STYLE_LIST, "Chon mot khung thoi gian", szDialog, "Xem", "Huy bo");
		}
		else
		{
		    SendClientMessageEx(index, COLOR_WHITE, "Co loi say ra.");
		}
	}
}

forward CheckSales2(index);
public CheckSales2(index)
{
	if(IsPlayerConnected(index))
	{
        new rows, fields, szDialog[2500];
		cache_get_data(rows, fields, MainPipeline);
	    if(rows)
		{
		    new szResult[32], szField[15], Solds[MAX_ITEMS], Amount[MAX_ITEMS];
		    for(new z = 0; z < MAX_ITEMS; z++)
			{
				format(szField, sizeof(szField), "TotalSold%d", z);
				cache_get_field_content(0,  szField, szResult, MainPipeline);
				Solds[z] = strval(szResult);

				format(szField, sizeof(szField), "AmountMade%d", z);
				cache_get_field_content(0,  szField, szResult, MainPipeline);
				Amount[z] = strval(szResult);
			}

     	    format(szDialog, sizeof(szDialog),"\
		 	Gold VIP Sold: %d | Tong Credits: %s\n\
		 	Gold VIP Renew Sold: %d | Tong Credits: %s\n\
		 	Silver VIP Sold: %d | Tong Credits: %s\n\
		 	Bronze VIP Sold: %d | Tong Credits: %s\n\
		 	Toys Sold: %d | Tong Credits: %s\n\
		 	Cars Sold: %d | Tong Credits: %s\n", Solds[0], number_format(Amount[0]), Solds[1], number_format(Amount[1]), Solds[2], number_format(Amount[2]), Solds[3], number_format(Amount[3]), Solds[4], number_format(Amount[4]),
			 Solds[5], number_format(Amount[5]));

		 	format(szDialog, sizeof(szDialog), "%s\
		 	Boomboxes Sold: %d | Tong Credits: %s\n\
		 	Paintball Tokens Sold: %d | Tong Credits: %s\n\
		 	EXP Tokens Sold: %d | Tong Credits: %s\n\
		 	Fireworks Sold: %d | Tong Credits: %s\n", szDialog, Solds[6], number_format(Amount[6]), Solds[7], number_format(Amount[7]), Solds[8], number_format(Amount[8]), Solds[9], number_format(Amount[9]), Solds[10], number_format(Amount[10]));

			format(szDialog, sizeof(szDialog), "%sBusiness Renew Regular Sold: %d | Tong Credits: %s\n\
		 	Business Renew Standard Sold: %d | Tong Credits: %s\n\
		 	Business Renew Premium Sold: %d | Tong Credits: %s\n\
		 	Houses Sold: %d | Tong Credits: %s\n", szDialog, Solds[11], number_format(Amount[11]), Solds[12], number_format(Amount[12]), Solds[13], number_format(Amount[13]), Solds[14], number_format(Amount[14]));

		 	format(szDialog, sizeof(szDialog), "%sHouse Moves Sold: %d | Tong Credits: %s\n\
		 	House Interiors Sold: %d | Tong Credits: %s\n\
			Reset Gift Timer Sold: %d | Tong Credits: %s\n\
			Advanced Health Care Sold: %d | Tong Credits: %s\n",szDialog, Solds[15], number_format(Amount[15]), Solds[16], number_format(Amount[16]), Solds[17], number_format(Amount[17]), Solds[18], number_format(Amount[18]));

			format(szDialog, sizeof(szDialog), "%sSuper Health Car Sold: %d | Tong Credits: %s\n\
			Rented Cars Sold: %d | Tong Credits: %s\n\
			Custom License Sold: %d | Tong Credits: %s\n\
			Additional Vehicle Slot Sold: %d | Total Credits: %s\n",szDialog, Solds[19], number_format(Amount[19]), Solds[20], number_format(Amount[20]),Solds[22], number_format(Amount[22]), Solds[23], number_format(Amount[23]));

			format(szDialog, sizeof(szDialog), "%sGarage - Small Sold: %d | Tong Credits: %s\n\
			Garage - Medium Sold: %d | Tong Credits: %s\n\
			Garage - Large Sold: %d | Tong Credits: %s\n\
			Garage - Extra Large Sold: %d | Total Credits: %s\n", szDialog, Solds[24], number_format(Amount[24]), Solds[25], number_format(Amount[25]), Solds[26], number_format(Amount[26]), Solds[27], number_format(Amount[27]));

			format(szDialog, sizeof(szDialog), "%sAdditional Toy Slot Sold: %d | Tong Credits: %s\n\
			Hunger Voucher: %d | Tong Credits: %s\n\
			Credits Transactions: %d | Tong Credits %s\n", szDialog, Solds[28], number_format(Amount[28]), Solds[29], number_format(Amount[29]), Solds[21], number_format(Amount[21]));

            format(szDialog, sizeof(szDialog), "%sTotal Amount of Credits spent: %s", szDialog,
			number_format(Amount[0]+Amount[1]+Amount[2]+Amount[3]+Amount[4]+Amount[5]+Amount[6]+Amount[7]+Amount[8]+Amount[9]+Amount[10]+Amount[11]+Amount[12]+Amount[13]+Amount[14]+Amount[15]+Amount[16]+Amount[17]+Amount[18]+Amount[19]+Amount[20]+Amount[21]+Amount[22]+Amount[23]
			+Amount[24]+Amount[25]+Amount[26]+Amount[27]+Amount[28]+Amount[29]));
		 	ShowPlayerDialog(index, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Shop Statistics", szDialog, "Thoat", "");
		}
		else
		{
		    SendClientMessageEx(index, COLOR_GREY, "Co van de trong  viec kiem tra ban.");
		}
	}
}

forward LoadRentedCar(index);
public LoadRentedCar(index)
{
	if(IsPlayerConnected(index))
	{
	    new rows, fields;
	    cache_get_data(rows, fields, MainPipeline);
		if(rows)
		{
		    //`sqlid`, `modelid`, `posx`, `posy`, `posz`, `posa`, `spawned`, `hours`

            new szResult[32], Info[2], Float: pos[4], string[128];
 	    	cache_get_field_content(0, "modelid", szResult, MainPipeline); Info[0] = strval(szResult);
  	    	cache_get_field_content(0, "posx", szResult, MainPipeline); pos[0] = strval(szResult);
   	    	cache_get_field_content(0, "posy", szResult, MainPipeline); pos[1] = strval(szResult);
    	    cache_get_field_content(0, "posz", szResult, MainPipeline); pos[2] = strval(szResult);
    	    cache_get_field_content(0, "posa", szResult, MainPipeline); pos[3] = strval(szResult);
    	    cache_get_field_content(0, "hours", szResult, MainPipeline); Info[1] = strval(szResult);

			SetPVarInt(index, "RentedHours", Info[1]);
			SetPVarInt(index, "RentedVehicle", CreateVehicle(Info[0],pos[0],pos[1], pos[2], pos[3], random(128), random(128), 2000000));

			format(string, sizeof(string), "Xe thue cua ban da duoc sinh ra, ban co %d phut truoc khi het gio thue.", Info[1]);
			SendClientMessageEx(index, COLOR_CYAN, string);
		}
	}
}

forward LoadTicket(playerid);
public LoadTicket(playerid) {
 	new rows, fields;
	cache_get_data(rows, fields, MainPipeline);

	if (rows == 0) {
		return 1;
	}

    new number, result[10];
	for(new i; i < rows; i++)
	{
    	cache_get_field_content(i, "number", result, MainPipeline);
    	number = strval(result);
		LottoNumbers[playerid][i] = number;
	}
	return 1;
}

forward LoadTreasureInvent(playerid);
public LoadTreasureInvent(playerid)
{
    new rows, fields, szResult[10];
	cache_get_data(rows, fields, MainPipeline);

    if(IsPlayerConnected(playerid))
    {
        if(!rows)
        {
            new query[60];
            format(query, sizeof(query), "INSERT INTO `jobstuff` (`pId`) VALUES ('%d')", GetPlayerSQLId(playerid));
			mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
        }
        else
        {
    		for(new row;row < rows;row++)
			{
				cache_get_field_content(row, "junkmetal", szResult, MainPipeline); SetPVarInt(playerid, "JunkMetal", strval(szResult));
				cache_get_field_content(row, "newcoin", szResult, MainPipeline); SetPVarInt(playerid, "newcoin", strval(szResult));
				cache_get_field_content(row, "oldcoin", szResult, MainPipeline); SetPVarInt(playerid, "oldcoin", strval(szResult));
				cache_get_field_content(row, "brokenwatch", szResult, MainPipeline); SetPVarInt(playerid, "brokenwatch", strval(szResult));
				cache_get_field_content(row, "oldkey", szResult, MainPipeline); SetPVarInt(playerid, "oldkey", strval(szResult));
				cache_get_field_content(row, "treasure", szResult, MainPipeline); SetPVarInt(playerid, "treasure", strval(szResult));
				cache_get_field_content(row, "goldwatch", szResult, MainPipeline); SetPVarInt(playerid, "goldwatch", strval(szResult));
				cache_get_field_content(row, "silvernugget", szResult, MainPipeline); SetPVarInt(playerid, "silvernugget", strval(szResult));
				cache_get_field_content(row, "goldnugget", szResult, MainPipeline); SetPVarInt(playerid, "goldnugget", strval(szResult));
			}
		}
	}
	return 1;
}

forward GetHomeCount(playerid);
public GetHomeCount(playerid)
{
	new string[128];
	format(string, sizeof(string), "SELECT NULL FROM `houses` WHERE `OwnerID` = %d", PlayerInfo[playerid][pId]);
	print(string);
	return mysql_function_query(MainPipeline, string, true, "QueryGetCountFinish", "ii", playerid, 2);
}

forward AddReportToken(playerid);
public AddReportToken(playerid)
{
	new
		sz_playerName[MAX_PLAYER_NAME],
		i_timestamp[3],
		tdate[11],
		thour[9],
		query[128];

	GetPlayerName(playerid, sz_playerName, MAX_PLAYER_NAME);
	getdate(i_timestamp[0], i_timestamp[1], i_timestamp[2]);
	format(tdate, sizeof(tdate), "%d-%02d-%02d", i_timestamp[0], i_timestamp[1], i_timestamp[2]);
	format(thour, sizeof(thour), "%02d:00:00", hour);

	format(query, sizeof(query), "SELECT NULL FROM `tokens_report` WHERE `playerid` = %d AND `date` = '%s' AND `hour` = '%s'", GetPlayerSQLId(playerid), tdate, thour);
	mysql_function_query(MainPipeline, query, true, "QueryTokenFinish", "ii", playerid, 1);
	return 1;
}

forward AddCAReportToken(playerid);
public AddCAReportToken(playerid)
{
	new
		sz_playerName[MAX_PLAYER_NAME],
		i_timestamp[3],
		tdate[11],
		thour[9],
		query[128];

	GetPlayerName(playerid, sz_playerName, MAX_PLAYER_NAME);
	getdate(i_timestamp[0], i_timestamp[1], i_timestamp[2]);
	format(tdate, sizeof(tdate), "%d-%02d-%02d", i_timestamp[0], i_timestamp[1], i_timestamp[2]);
	format(thour, sizeof(thour), "%02d:00:00", hour);

	format(query, sizeof(query), "SELECT NULL FROM `tokens_request` WHERE `playerid` = %d AND `date` = '%s' AND `hour` = '%s'", GetPlayerSQLId(playerid), tdate, thour);
	mysql_function_query(MainPipeline, query, true, "QueryTokenFinish", "ii", playerid, 2);
	return 1;
}

forward AddCallToken(playerid);
public AddCallToken(playerid)
{
	new
		sz_playerName[MAX_PLAYER_NAME],
		i_timestamp[3],
		tdate[11],
		query[128];

	GetPlayerName(playerid, sz_playerName, MAX_PLAYER_NAME);
	getdate(i_timestamp[0], i_timestamp[1], i_timestamp[2]);
	format(tdate, sizeof(tdate), "%d-%02d-%02d", i_timestamp[0], i_timestamp[1], i_timestamp[2]);

	format(query, sizeof(query), "SELECT NULL FROM `tokens_call` WHERE `playerid` = %d AND `date` = '%s' AND `hour` = %d", GetPlayerSQLId(playerid), tdate, hour);
	mysql_function_query(MainPipeline, query, true, "QueryTokenFinish", "ii", playerid, 3);
	return 1;
}

forward QueryTokenFinish(playerid, type);
public QueryTokenFinish(playerid, type)
{
    new rows, fields, string[128], i_timestamp[3], tdate[11], thour[9];
	cache_get_data(rows, fields, MainPipeline);
	getdate(i_timestamp[0], i_timestamp[1], i_timestamp[2]);
	format(tdate, sizeof(tdate), "%d-%02d-%02d", i_timestamp[0], i_timestamp[1], i_timestamp[2]);
	format(thour, sizeof(thour), "%02d:00:00", hour);

	switch(type)
	{
		case 1:
		{
			if(rows == 0)
			{
				format(string, sizeof(string), "INSERT INTO `tokens_report` (`id`, `playerid`, `date`, `hour`, `count`) VALUES (NULL, %d, '%s', '%s', 1)", GetPlayerSQLId(playerid), tdate, thour);
				mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);
			}
			else
			{
				format(string, sizeof(string), "UPDATE `tokens_report` SET `count` = count+1 WHERE `playerid` = %d AND `date` = '%s' AND `hour` = '%s'", GetPlayerSQLId(playerid), tdate, thour);
				mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);
			}
		}
		case 2:
		{
			if(rows == 0)
			{
				format(string, sizeof(string), "INSERT INTO `tokens_request` (`id`, `playerid`, `date`, `hour`, `count`) VALUES (NULL, %d, '%s', '%s', 1)", GetPlayerSQLId(playerid), tdate, thour);
				mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);
			}
			else
			{
				format(string, sizeof(string), "UPDATE `tokens_request` SET `count` = count+1 WHERE `playerid` = %d AND `date` = '%s' AND `hour` = '%s'", GetPlayerSQLId(playerid), tdate, thour);
				mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);
			}
		}
		case 3:
		{
			if(rows == 0)
			{
				format(string, sizeof(string), "INSERT INTO `tokens_call` (`id`, `playerid`, `date`, `hour`, `count`) VALUES (NULL, %d, '%s', %d, 1)", GetPlayerSQLId(playerid), tdate, hour);
				mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);
			}
			else
			{
				format(string, sizeof(string), "UPDATE `tokens_call` SET `count` = count+1 WHERE `playerid` = %d AND `date` = '%s' AND `hour` = %d", GetPlayerSQLId(playerid), tdate, hour);
				mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);
			}
		}
	}
	return 1;
}

forward GetReportCount(userid, tdate[]);
public GetReportCount(userid, tdate[])
{
	new string[128];
	format(string, sizeof(string), "SELECT SUM(count) FROM `tokens_report` WHERE `playerid` = %d AND `date` = '%s'", GetPlayerSQLId(userid), tdate);
	return mysql_function_query(MainPipeline, string, true, "QueryGetCountFinish", "ii", userid, 0);
}

forward GetHourReportCount(userid, thour[], tdate[]);
public GetHourReportCount(userid, thour[], tdate[])
{
	new string[128];
	format(string, sizeof(string), "SELECT `count` FROM `tokens_report` WHERE `playerid` = %d AND `date` = '%s' AND `hour` = '%s'", GetPlayerSQLId(userid), tdate, thour);
	return mysql_function_query(MainPipeline, string, true, "QueryGetCountFinish", "ii", userid, 1);
}

forward GetRequestCount(userid, tdate[]);
public GetRequestCount(userid, tdate[])
{
	new string[128];
	format(string, sizeof(string), "SELECT SUM(count) FROM `tokens_request` WHERE `playerid` = %d AND `date` = '%s'", GetPlayerSQLId(userid), tdate);
	return mysql_function_query(MainPipeline, string, true, "QueryGetCountFinish", "ii", userid, 0);
}

forward GetHourRequestCount(userid, thour[], tdate[]);
public GetHourRequestCount(userid, thour[], tdate[])
{
	new string[128];
	format(string, sizeof(string), "SELECT `count` FROM `tokens_request` WHERE `playerid` = %d AND `date` = '%s' AND `hour` = '%s'", GetPlayerSQLId(userid), tdate, thour);
	return mysql_function_query(MainPipeline, string, true, "QueryGetCountFinish", "ii", userid, 1);
}

forward QueryGetCountFinish(userid, type);
public QueryGetCountFinish(userid, type)
{
    new rows, fields, sResult[24];
	cache_get_data(rows, fields, MainPipeline);

	switch(type)
	{
		case 0:
		{
			if(rows > 0)
			{
				cache_get_field_content(0, "SUM(count)", sResult, MainPipeline);
				ReportCount[userid] = strval(sResult);
			}
			else ReportCount[userid] = 0;
		}
		case 1:
		{
			if(rows > 0)
			{
				cache_get_field_content(0, "count", sResult, MainPipeline);
				ReportHourCount[userid] = strval(sResult);
			}
			else ReportHourCount[userid] = 0;
		}
		case 2:
		{
			Homes[userid] = rows;
			printf("%d,house %d",userid,rows);
		}
	}
	return 1;
}

forward OnLoadFamilies();
public OnLoadFamilies()
{
	new i, rows, fields, tmp[128], famid;
	cache_get_data(rows, fields, MainPipeline);

	new column[32];
	while(i < rows)
	{
	    FamilyMemberCount(i);
	    cache_get_field_content(i, "ID", tmp, MainPipeline); famid = strval(tmp);
	    cache_get_field_content(i, "FType", tmp, MainPipeline); FamilyInfo[famid][FType] = strval(tmp);
		cache_get_field_content(i, "Taken", tmp, MainPipeline); FamilyInfo[famid][FamilyTaken] = strval(tmp);
		cache_get_field_content(i, "Name", FamilyInfo[famid][FamilyName], MainPipeline, 42);
		cache_get_field_content(i, "Leader", FamilyInfo[famid][FamilyLeader], MainPipeline, MAX_PLAYER_NAME);
		cache_get_field_content(i, "Bank", tmp, MainPipeline); FamilyInfo[famid][FamilyBank] = strval(tmp);
		cache_get_field_content(i, "Cash", tmp, MainPipeline); FamilyInfo[famid][FamilyCash] = strval(tmp);
		cache_get_field_content(i, "FamilyUSafe", tmp, MainPipeline); FamilyInfo[famid][FamilyUSafe] = strval(tmp);
		cache_get_field_content(i, "FamilySafeX", tmp, MainPipeline); FamilyInfo[famid][FamilySafe][0] = floatstr(tmp);
		cache_get_field_content(i, "FamilySafeY", tmp, MainPipeline); FamilyInfo[famid][FamilySafe][1] = floatstr(tmp);
		cache_get_field_content(i, "FamilySafeZ", tmp, MainPipeline); FamilyInfo[famid][FamilySafe][2] = floatstr(tmp);
		cache_get_field_content(i, "FamilySafeVW", tmp, MainPipeline); FamilyInfo[famid][FamilySafeVW] = strval(tmp);
		cache_get_field_content(i, "FamilySafeInt", tmp, MainPipeline); FamilyInfo[famid][FamilySafeInt] = strval(tmp);
		cache_get_field_content(i, "Pot", tmp, MainPipeline); FamilyInfo[famid][FamilyPot] = strval(tmp);

		// load inventory ffamily
		cache_get_field_content(i, "fSlot0", tmp, MainPipeline); FamilyInfo[famid][fSlot][0] = strval(tmp);
		cache_get_field_content(i, "fSlot1", tmp, MainPipeline); FamilyInfo[famid][fSlot][1] = strval(tmp);
		cache_get_field_content(i, "fSlot2", tmp, MainPipeline); FamilyInfo[famid][fSlot][2] = strval(tmp);
		cache_get_field_content(i, "fSlot3", tmp, MainPipeline); FamilyInfo[famid][fSlot][3] = strval(tmp);
		cache_get_field_content(i, "fSlot4", tmp, MainPipeline); FamilyInfo[famid][fSlot][4] = strval(tmp);
		cache_get_field_content(i, "fSlot5", tmp, MainPipeline); FamilyInfo[famid][fSlot][5] = strval(tmp);
		cache_get_field_content(i, "fSlot6", tmp, MainPipeline); FamilyInfo[famid][fSlot][6] = strval(tmp);
		cache_get_field_content(i, "fSlot7", tmp, MainPipeline); FamilyInfo[famid][fSlot][7] = strval(tmp);
		cache_get_field_content(i, "fSlot8", tmp, MainPipeline); FamilyInfo[famid][fSlot][8] = strval(tmp);
		cache_get_field_content(i, "fSlot9", tmp, MainPipeline); FamilyInfo[famid][fSlot][9] = strval(tmp);

		cache_get_field_content(i, "fAmount0", tmp, MainPipeline); FamilyInfo[famid][fAmount][0] = strval(tmp);
		cache_get_field_content(i, "fAmount1", tmp, MainPipeline); FamilyInfo[famid][fAmount][1] = strval(tmp);
		cache_get_field_content(i, "fAmount2", tmp, MainPipeline); FamilyInfo[famid][fAmount][2] = strval(tmp);
		cache_get_field_content(i, "fAmount3", tmp, MainPipeline); FamilyInfo[famid][fAmount][3] = strval(tmp);
		cache_get_field_content(i, "fAmount4", tmp, MainPipeline); FamilyInfo[famid][fAmount][4] = strval(tmp);
		cache_get_field_content(i, "fAmount5", tmp, MainPipeline); FamilyInfo[famid][fAmount][5] = strval(tmp);
		cache_get_field_content(i, "fAmount6", tmp, MainPipeline); FamilyInfo[famid][fAmount][6] = strval(tmp);
		cache_get_field_content(i, "fAmount7", tmp, MainPipeline); FamilyInfo[famid][fAmount][7] = strval(tmp);
		cache_get_field_content(i, "fAmount8", tmp, MainPipeline); FamilyInfo[famid][fAmount][8] = strval(tmp);
		cache_get_field_content(i, "fAmount9", tmp, MainPipeline); FamilyInfo[famid][fAmount][9] = strval(tmp);

		cache_get_field_content(i, "Crack", tmp, MainPipeline); FamilyInfo[famid][FamilyCrack] = strval(tmp);
		cache_get_field_content(i, "Mats", tmp, MainPipeline); FamilyInfo[famid][FamilyMats] = strval(tmp);
		cache_get_field_content(i, "Heroin", tmp, MainPipeline); FamilyInfo[famid][FamilyHeroin] = strval(tmp);
		cache_get_field_content(i, "MaxSkins", tmp, MainPipeline); FamilyInfo[famid][FamilyMaxSkins] = strval(tmp);
		cache_get_field_content(i, "Color", tmp, MainPipeline); FamilyInfo[famid][FamilyColor] = strval(tmp);
		cache_get_field_content(i, "TurfTokens", tmp, MainPipeline); FamilyInfo[famid][FamilyTurfTokens] = strval(tmp);
		cache_get_field_content(i, "ExteriorX", tmp, MainPipeline); FamilyInfo[famid][FamilyEntrance][0] = floatstr(tmp);
		cache_get_field_content(i, "ExteriorY", tmp, MainPipeline); FamilyInfo[famid][FamilyEntrance][1] = floatstr(tmp);
		cache_get_field_content(i, "ExteriorZ", tmp, MainPipeline); FamilyInfo[famid][FamilyEntrance][2] = floatstr(tmp);
		cache_get_field_content(i, "ExteriorA", tmp, MainPipeline); FamilyInfo[famid][FamilyEntrance][3] = floatstr(tmp);
		cache_get_field_content(i, "InteriorX", tmp, MainPipeline); FamilyInfo[famid][FamilyExit][0] = floatstr(tmp);
		cache_get_field_content(i, "InteriorY", tmp, MainPipeline); FamilyInfo[famid][FamilyExit][1] = floatstr(tmp);
		cache_get_field_content(i, "InteriorZ", tmp, MainPipeline); FamilyInfo[famid][FamilyExit][2] = floatstr(tmp);
		cache_get_field_content(i, "InteriorA", tmp, MainPipeline); FamilyInfo[famid][FamilyExit][3] = floatstr(tmp);
		cache_get_field_content(i, "INT", tmp, MainPipeline); FamilyInfo[famid][FamilyInterior] = strval(tmp);
		cache_get_field_content(i, "VW", tmp, MainPipeline); FamilyInfo[famid][FamilyVirtualWorld] = strval(tmp);
		cache_get_field_content(i, "CustomInterior", tmp, MainPipeline); FamilyInfo[famid][FamilyCustomMap] = strval(tmp);
		cache_get_field_content(i, "GtObject", tmp, MainPipeline); FamilyInfo[famid][gtObject] = strval(tmp);
		cache_get_field_content(i, "MOTD1", FamilyMOTD[famid][0], MainPipeline, 128);
		cache_get_field_content(i, "MOTD2", FamilyMOTD[famid][1], MainPipeline, 128);
		cache_get_field_content(i, "MOTD3", FamilyMOTD[famid][2], MainPipeline, 128);
		cache_get_field_content(i, "fontface", tmp, MainPipeline); format(FamilyInfo[famid][gt_FontFace], 32, "%s", tmp);
		cache_get_field_content(i, "fontsize", tmp, MainPipeline); FamilyInfo[famid][gt_FontSize] = strval(tmp);
		cache_get_field_content(i, "bold", tmp, MainPipeline); FamilyInfo[famid][gt_Bold] = strval(tmp);
		cache_get_field_content(i, "fontcolor", tmp, MainPipeline); FamilyInfo[famid][gt_FontColor] = strval(tmp);
		cache_get_field_content(i, "text", FamilyInfo[famid][gt_Text], MainPipeline, 32);
		cache_get_field_content(i, "gtUsed", tmp, MainPipeline); FamilyInfo[famid][gt_SPUsed] = strval(tmp);
		if(strcmp(FamilyInfo[famid][gt_Text], "Preview", true) == 0)
		{
			FamilyInfo[famid][gtObject] = 1490;
			FamilyInfo[famid][gt_SPUsed] = 1;
		}
	    for (new j; j <= 6; j++) {
	        format(column,sizeof(column), "Rank%d", j);
	        cache_get_field_content(i, column, tmp, MainPipeline); format(FamilyRankInfo[famid][j], 20, "%s", tmp);
	    }

		for (new j = 0; j < 5 ;j++) {
	        format(column, sizeof(column), "Division%d", j);
	        cache_get_field_content(i, column, tmp, MainPipeline); format(FamilyDivisionInfo[famid][j], 20, "%s", tmp);
	    }
	    for (new j; j < 8; j++) {
	        format(column,sizeof(column), "Skin%d", j+1);
	        cache_get_field_content(i, column, tmp, MainPipeline); FamilyInfo[famid][FamilySkins][j] = strval(tmp);
	    }
	    for (new j; j < 10; j++) {
	        format(column,sizeof(column), "Gun%d", j+1);
	        cache_get_field_content(i, column, tmp, MainPipeline); FamilyInfo[famid][FamilyGuns][j] = strval(tmp);
	    }
		if(FamilyInfo[famid][FamilyUSafe] > 0)
		{
			FamilyInfo[famid][FamilyPickup] = CreateDynamicPickup(1239, 23, FamilyInfo[famid][FamilySafe][0], FamilyInfo[famid][FamilySafe][1], FamilyInfo[famid][FamilySafe][2], .worldid = FamilyInfo[famid][FamilySafeVW], .interiorid = FamilyInfo[famid][FamilySafeInt]);
		}
		if(FamilyInfo[famid][FamilyEntrance][0] != 0.0 && FamilyInfo[famid][FamilyEntrance][1] != 0.0)
		{
		    new string[42];
		    FamilyInfo[famid][FamilyEntrancePickup] = CreateDynamicPickup(1318, 23, FamilyInfo[famid][FamilyEntrance][0], FamilyInfo[famid][FamilyEntrance][1], FamilyInfo[famid][FamilyEntrance][2]);
			format(string, sizeof(string), "%s", FamilyInfo[famid][FamilyName]);
			FamilyInfo[famid][FamilyEntranceText] = CreateDynamic3DTextLabel(string,COLOR_YELLOW,FamilyInfo[famid][FamilyEntrance][0], FamilyInfo[famid][FamilyEntrance][1], FamilyInfo[famid][FamilyEntrance][2]+0.6,4.0);
		}
		i++;
	}
}

forward OnFamilyMemberCount(famid);
public OnFamilyMemberCount(famid)
{
	new rows, fields;
	cache_get_data(rows, fields, MainPipeline);
	FamilyInfo[famid][FamilyMembers] = rows;
}

forward MailDeliveryTimer();
public MailDeliveryTimer()
{
	mysql_function_query(MainPipeline, "UPDATE `letters` SET `Delivery_Min` = `Delivery_Min` - 1 WHERE `Delivery_Min` > 0", false, "OnQueryFinish", "i", SENDDATA_THREAD);
	mysql_function_query(MainPipeline, "SELECT `Receiver_Id` FROM `letters` WHERE `Delivery_Min` = 1", true, "MailDeliveryQueryFinish", "");
	return 1;
}

forward OnLoadGates();
public OnLoadGates()
{
	new i, rows, fields, tmp[128];
	cache_get_data(rows, fields, MainPipeline);

	while(i < rows)
	{
		cache_get_field_content(i, "HID", tmp, MainPipeline);  GateInfo[i][gHID] = strval(tmp);
		cache_get_field_content(i, "Speed", tmp, MainPipeline); GateInfo[i][gSpeed] = floatstr(tmp);
		cache_get_field_content(i, "Range", tmp, MainPipeline); GateInfo[i][gRange] = floatstr(tmp);
		cache_get_field_content(i, "Model", tmp, MainPipeline); GateInfo[i][gModel] = strval(tmp);
		cache_get_field_content(i, "VW", tmp, MainPipeline); GateInfo[i][gVW] = strval(tmp);
		cache_get_field_content(i, "Int", tmp, MainPipeline); GateInfo[i][gInt] = strval(tmp);
		cache_get_field_content(i, "Pass", GateInfo[i][gPass], MainPipeline, 24);
		cache_get_field_content(i, "PosX", tmp, MainPipeline); GateInfo[i][gPosX] = floatstr(tmp);
		cache_get_field_content(i, "PosY", tmp, MainPipeline); GateInfo[i][gPosY] = floatstr(tmp);
		cache_get_field_content(i, "PosZ", tmp, MainPipeline); GateInfo[i][gPosZ] = floatstr(tmp);
		cache_get_field_content(i, "RotX", tmp, MainPipeline); GateInfo[i][gRotX] = floatstr(tmp);
		cache_get_field_content(i, "RotY", tmp, MainPipeline); GateInfo[i][gRotY] = floatstr(tmp);
		cache_get_field_content(i, "RotZ", tmp, MainPipeline); GateInfo[i][gRotZ] = floatstr(tmp);
		cache_get_field_content(i, "PosXM", tmp, MainPipeline); GateInfo[i][gPosXM] = floatstr(tmp);
		cache_get_field_content(i, "PosYM", tmp, MainPipeline); GateInfo[i][gPosYM] = floatstr(tmp);
		cache_get_field_content(i, "PosZM", tmp, MainPipeline); GateInfo[i][gPosZM] = floatstr(tmp);
		cache_get_field_content(i, "RotXM", tmp, MainPipeline); GateInfo[i][gRotXM] = floatstr(tmp);
		cache_get_field_content(i, "RotYM", tmp, MainPipeline); GateInfo[i][gRotYM] = floatstr(tmp);
		cache_get_field_content(i, "RotZM", tmp, MainPipeline); GateInfo[i][gRotZM] = floatstr(tmp);
		cache_get_field_content(i, "Allegiance", tmp, MainPipeline); GateInfo[i][gAllegiance] = strval(tmp);
		cache_get_field_content(i, "GroupType", tmp, MainPipeline); GateInfo[i][gGroupType] = strval(tmp);
		cache_get_field_content(i, "GroupID", tmp, MainPipeline); GateInfo[i][gGroupID] = strval(tmp);
		cache_get_field_content(i, "FamilyID", tmp, MainPipeline); GateInfo[i][gFamilyID] = strval(tmp);
		cache_get_field_content(i, "RenderHQ", tmp, MainPipeline); GateInfo[i][gRenderHQ] = strval(tmp);
		cache_get_field_content(i, "Timer", tmp, MainPipeline); GateInfo[i][gTimer] = strval(tmp);
		cache_get_field_content(i, "Automate", tmp, MainPipeline); GateInfo[i][gAutomate] = strval(tmp);
		cache_get_field_content(i, "Locked", tmp, MainPipeline); GateInfo[i][gLocked] = strval(tmp);
		CreateGate(i);
		i++;
	}
}

forward OnLoadDynamicMapIcon(index);
public OnLoadDynamicMapIcon(index)
{
	new rows, fields, tmp[128];
	cache_get_data(rows, fields, MainPipeline);

	for(new row; row < rows; row++)
	{
		cache_get_field_content(row, "id", tmp, MainPipeline);  DMPInfo[index][dmpSQLId] = strval(tmp);
		cache_get_field_content(row, "MarkerType", tmp, MainPipeline); DMPInfo[index][dmpMarkerType] = strval(tmp);
		cache_get_field_content(row, "Color", tmp, MainPipeline); DMPInfo[index][dmpColor] = strval(tmp);
		cache_get_field_content(row, "VW", tmp, MainPipeline); DMPInfo[index][dmpVW] = strval(tmp);
		cache_get_field_content(row, "Int", tmp, MainPipeline); DMPInfo[index][dmpInt] = strval(tmp);
		cache_get_field_content(row, "PosX", tmp, MainPipeline); DMPInfo[index][dmpPosX] = floatstr(tmp);
		cache_get_field_content(row, "PosY", tmp, MainPipeline); DMPInfo[index][dmpPosY] = floatstr(tmp);
		cache_get_field_content(row, "PosZ", tmp, MainPipeline); DMPInfo[index][dmpPosZ] = floatstr(tmp);
		if(DMPInfo[index][dmpMarkerType] != 0) DMPInfo[index][dmpMapIconID] = CreateDynamicMapIcon(DMPInfo[index][dmpPosX], DMPInfo[index][dmpPosY], DMPInfo[index][dmpPosZ], DMPInfo[index][dmpMarkerType], DMPInfo[index][dmpColor], DMPInfo[index][dmpVW], DMPInfo[index][dmpInt], -1, 500.0);
	}
	return 1;
}

forward OnLoadDynamicMapIcons();
public OnLoadDynamicMapIcons()
{
	new i, rows, fields, tmp[128];
	cache_get_data(rows, fields, MainPipeline);

	while(i < rows)
	{
		cache_get_field_content(i, "id", tmp, MainPipeline);  DMPInfo[i][dmpSQLId] = strval(tmp);
		cache_get_field_content(i, "MarkerType", tmp, MainPipeline); DMPInfo[i][dmpMarkerType] = strval(tmp);
		cache_get_field_content(i, "Color", tmp, MainPipeline); DMPInfo[i][dmpColor] = strval(tmp);
		cache_get_field_content(i, "VW", tmp, MainPipeline); DMPInfo[i][dmpVW] = strval(tmp);
		cache_get_field_content(i, "Int", tmp, MainPipeline); DMPInfo[i][dmpInt] = strval(tmp);
		cache_get_field_content(i, "PosX", tmp, MainPipeline); DMPInfo[i][dmpPosX] = floatstr(tmp);
		cache_get_field_content(i, "PosY", tmp, MainPipeline); DMPInfo[i][dmpPosY] = floatstr(tmp);
		cache_get_field_content(i, "PosZ", tmp, MainPipeline); DMPInfo[i][dmpPosZ] = floatstr(tmp);
		if(DMPInfo[i][dmpMarkerType] != 0) DMPInfo[i][dmpMapIconID] = CreateDynamicMapIcon(DMPInfo[i][dmpPosX], DMPInfo[i][dmpPosY], DMPInfo[i][dmpPosZ], DMPInfo[i][dmpMarkerType], DMPInfo[i][dmpColor], DMPInfo[i][dmpVW], DMPInfo[i][dmpInt], -1, 500.0);
		i++;
	}
	if(i > 0) printf("[LoadDynamicMapIcons] %d icons map duoc tai.", i);
	else printf("[LoadDynamicMapIcons] Khong the tai icons map.");
	return 1;
}

forward OnLoadDynamicDoor(index);
public OnLoadDynamicDoor(index)
{
	new rows, fields, tmp[128];
	cache_get_data(rows, fields, MainPipeline);

	for(new row; row < rows; row++)
	{
		cache_get_field_content(rows, "id", tmp, MainPipeline);  DDoorsInfo[index][ddSQLId] = strval(tmp);
		cache_get_field_content(rows, "Description", DDoorsInfo[index][ddDescription], MainPipeline, 128);
		cache_get_field_content(rows, "Owner", tmp, MainPipeline); DDoorsInfo[index][ddOwner] = strval(tmp);
		cache_get_field_content(rows, "OwnerName", DDoorsInfo[index][ddOwnerName], MainPipeline, 42);
		cache_get_field_content(rows, "CustomExterior", tmp, MainPipeline); DDoorsInfo[index][ddCustomExterior] = strval(tmp);
		cache_get_field_content(rows, "CustomInterior", tmp, MainPipeline); DDoorsInfo[index][ddCustomInterior] = strval(tmp);
		cache_get_field_content(rows, "ExteriorVW", tmp, MainPipeline); DDoorsInfo[index][ddExteriorVW] = strval(tmp);
		cache_get_field_content(rows, "ExteriorInt", tmp, MainPipeline); DDoorsInfo[index][ddExteriorInt] = strval(tmp);
		cache_get_field_content(rows, "InteriorVW", tmp, MainPipeline); DDoorsInfo[index][ddInteriorVW] = strval(tmp);
		cache_get_field_content(rows, "InteriorInt", tmp, MainPipeline); DDoorsInfo[index][ddInteriorInt] = strval(tmp);
		cache_get_field_content(rows, "ExteriorX", tmp, MainPipeline); DDoorsInfo[index][ddExteriorX] = floatstr(tmp);
		cache_get_field_content(rows, "ExteriorY", tmp, MainPipeline); DDoorsInfo[index][ddExteriorY] = floatstr(tmp);
		cache_get_field_content(rows, "ExteriorZ", tmp, MainPipeline); DDoorsInfo[index][ddExteriorZ] = floatstr(tmp);
		cache_get_field_content(rows, "ExteriorA", tmp, MainPipeline); DDoorsInfo[index][ddExteriorA] = floatstr(tmp);
		cache_get_field_content(rows, "InteriorX", tmp, MainPipeline); DDoorsInfo[index][ddInteriorX] = floatstr(tmp);
		cache_get_field_content(rows, "InteriorY", tmp, MainPipeline); DDoorsInfo[index][ddInteriorY] = floatstr(tmp);
		cache_get_field_content(rows, "InteriorZ", tmp, MainPipeline); DDoorsInfo[index][ddInteriorZ] = floatstr(tmp);
		cache_get_field_content(rows, "InteriorA", tmp, MainPipeline); DDoorsInfo[index][ddInteriorA] = floatstr(tmp);
		cache_get_field_content(rows, "Type", tmp, MainPipeline); DDoorsInfo[index][ddType] = strval(tmp);
		cache_get_field_content(rows, "Rank", tmp, MainPipeline); DDoorsInfo[index][ddRank] = strval(tmp);
		cache_get_field_content(rows, "VIP", tmp, MainPipeline); DDoorsInfo[index][ddVIP] = strval(tmp);
		cache_get_field_content(rows, "Famed", tmp, MainPipeline); DDoorsInfo[index][ddFamed] = strval(tmp);
		cache_get_field_content(rows, "DPC", tmp, MainPipeline); DDoorsInfo[index][ddDPC] = strval(tmp);
		cache_get_field_content(rows, "Allegiance", tmp, MainPipeline); DDoorsInfo[index][ddAllegiance] = strval(tmp);
		cache_get_field_content(rows, "GroupType", tmp, MainPipeline); DDoorsInfo[index][ddGroupType] = strval(tmp);
		cache_get_field_content(rows, "Family", tmp, MainPipeline); DDoorsInfo[index][ddFamily] = strval(tmp);
		cache_get_field_content(rows, "Faction", tmp, MainPipeline); DDoorsInfo[index][ddFaction] = strval(tmp);
		cache_get_field_content(rows, "Admin", tmp, MainPipeline); DDoorsInfo[index][ddAdmin] = strval(tmp);
		cache_get_field_content(rows, "Wanted", tmp, MainPipeline); DDoorsInfo[index][ddWanted] = strval(tmp);
		cache_get_field_content(rows, "VehicleAble", tmp, MainPipeline); DDoorsInfo[index][ddVehicleAble] = strval(tmp);
		cache_get_field_content(rows, "Color", tmp, MainPipeline); DDoorsInfo[index][ddColor] = strval(tmp);
		cache_get_field_content(rows, "PickupModel", tmp, MainPipeline); DDoorsInfo[index][ddPickupModel] = strval(tmp);
		cache_get_field_content(rows, "Pass", DDoorsInfo[index][ddPass], MainPipeline, 24);
		cache_get_field_content(rows, "Locked", tmp, MainPipeline); DDoorsInfo[index][ddLocked] = strval(tmp);
		if(strcmp(DDoorsInfo[index][ddDescription], "None", true) != 0) CreateDynamicDoor(index);
	}
	return 1;
}


forward OnLoadDynamicDoors();
public OnLoadDynamicDoors()
{
	new i, rows, fields, tmp[128];
	cache_get_data(rows, fields, MainPipeline);

	while(i < rows)
	{
		cache_get_field_content(i, "id", tmp, MainPipeline);  DDoorsInfo[i][ddSQLId] = strval(tmp);
		cache_get_field_content(i, "Description", DDoorsInfo[i][ddDescription], MainPipeline, 128);
		cache_get_field_content(i, "Owner", tmp, MainPipeline); DDoorsInfo[i][ddOwner] = strval(tmp);
		cache_get_field_content(i, "OwnerName", DDoorsInfo[i][ddOwnerName], MainPipeline, 42);
		cache_get_field_content(i, "CustomExterior", tmp, MainPipeline); DDoorsInfo[i][ddCustomExterior] = strval(tmp);
		cache_get_field_content(i, "CustomInterior", tmp, MainPipeline); DDoorsInfo[i][ddCustomInterior] = strval(tmp);
		cache_get_field_content(i, "ExteriorVW", tmp, MainPipeline); DDoorsInfo[i][ddExteriorVW] = strval(tmp);
		cache_get_field_content(i, "ExteriorInt", tmp, MainPipeline); DDoorsInfo[i][ddExteriorInt] = strval(tmp);
		cache_get_field_content(i, "InteriorVW", tmp, MainPipeline); DDoorsInfo[i][ddInteriorVW] = strval(tmp);
		cache_get_field_content(i, "InteriorInt", tmp, MainPipeline); DDoorsInfo[i][ddInteriorInt] = strval(tmp);
		cache_get_field_content(i, "ExteriorX", tmp, MainPipeline); DDoorsInfo[i][ddExteriorX] = floatstr(tmp);
		cache_get_field_content(i, "ExteriorY", tmp, MainPipeline); DDoorsInfo[i][ddExteriorY] = floatstr(tmp);
		cache_get_field_content(i, "ExteriorZ", tmp, MainPipeline); DDoorsInfo[i][ddExteriorZ] = floatstr(tmp);
		cache_get_field_content(i, "ExteriorA", tmp, MainPipeline); DDoorsInfo[i][ddExteriorA] = floatstr(tmp);
		cache_get_field_content(i, "InteriorX", tmp, MainPipeline); DDoorsInfo[i][ddInteriorX] = floatstr(tmp);
		cache_get_field_content(i, "InteriorY", tmp, MainPipeline); DDoorsInfo[i][ddInteriorY] = floatstr(tmp);
		cache_get_field_content(i, "InteriorZ", tmp, MainPipeline); DDoorsInfo[i][ddInteriorZ] = floatstr(tmp);
		cache_get_field_content(i, "InteriorA", tmp, MainPipeline); DDoorsInfo[i][ddInteriorA] = floatstr(tmp);
		cache_get_field_content(i, "Type", tmp, MainPipeline); DDoorsInfo[i][ddType] = strval(tmp);
		cache_get_field_content(i, "Rank", tmp, MainPipeline); DDoorsInfo[i][ddRank] = strval(tmp);
		cache_get_field_content(i, "VIP", tmp, MainPipeline); DDoorsInfo[i][ddVIP] = strval(tmp);
		cache_get_field_content(i, "Famed", tmp, MainPipeline); DDoorsInfo[i][ddFamed] = strval(tmp);
		cache_get_field_content(i, "DPC", tmp, MainPipeline); DDoorsInfo[i][ddDPC] = strval(tmp);
		cache_get_field_content(i, "Allegiance", tmp, MainPipeline); DDoorsInfo[i][ddAllegiance] = strval(tmp);
		cache_get_field_content(i, "GroupType", tmp, MainPipeline); DDoorsInfo[i][ddGroupType] = strval(tmp);
		cache_get_field_content(i, "Family", tmp, MainPipeline); DDoorsInfo[i][ddFamily] = strval(tmp);
		cache_get_field_content(i, "Faction", tmp, MainPipeline); DDoorsInfo[i][ddFaction] = strval(tmp);
		cache_get_field_content(i, "Admin", tmp, MainPipeline); DDoorsInfo[i][ddAdmin] = strval(tmp);
		cache_get_field_content(i, "Wanted", tmp, MainPipeline); DDoorsInfo[i][ddWanted] = strval(tmp);
		cache_get_field_content(i, "VehicleAble", tmp, MainPipeline); DDoorsInfo[i][ddVehicleAble] = strval(tmp);
		cache_get_field_content(i, "Color", tmp, MainPipeline); DDoorsInfo[i][ddColor] = strval(tmp);
		cache_get_field_content(i, "PickupModel", tmp, MainPipeline); DDoorsInfo[i][ddPickupModel] = strval(tmp);
		cache_get_field_content(i, "Pass", DDoorsInfo[i][ddPass], MainPipeline, 24);
		cache_get_field_content(i, "Locked", tmp, MainPipeline); DDoorsInfo[i][ddLocked] = strval(tmp);
		if(strcmp(DDoorsInfo[i][ddDescription], "None", true) != 0) CreateDynamicDoor(i);
		i++;
	}
	if(i > 0) printf("[LoadDynamicDoors] %d door duoc tai.", i);
	else printf("[LoadDynamicDoors] Khong the tai door.");
	return 1;
}

forward OnLoadHouse(index);
public OnLoadHouse(index)
{
	new rows, fields, szField[24], tmp[128];
	cache_get_data(rows, fields, MainPipeline);

	for(new row; row < rows; row++)
	{
		cache_get_field_content(row, "id", tmp, MainPipeline); HouseInfo[index][hSQLId] = strval(tmp);
		cache_get_field_content(row, "Owned", tmp, MainPipeline); HouseInfo[index][hOwned] = strval(tmp);
		cache_get_field_content(row, "Level", tmp, MainPipeline); HouseInfo[index][hLevel] = strval(tmp);
		cache_get_field_content(row, "Description", HouseInfo[index][hDescription], MainPipeline, 16);
		cache_get_field_content(row, "OwnerID", tmp, MainPipeline); HouseInfo[index][hOwnerID] = strval(tmp);
		cache_get_field_content(row, "Username", HouseInfo[index][hOwnerName], MainPipeline, MAX_PLAYER_NAME);
		cache_get_field_content(row, "ExteriorX", tmp, MainPipeline); HouseInfo[index][hExteriorX] = floatstr(tmp);
		cache_get_field_content(row, "ExteriorY", tmp, MainPipeline); HouseInfo[index][hExteriorY] = floatstr(tmp);
		cache_get_field_content(row, "ExteriorZ", tmp, MainPipeline); HouseInfo[index][hExteriorZ] = floatstr(tmp);
		cache_get_field_content(row, "ExteriorR", tmp, MainPipeline); HouseInfo[index][hExteriorR] = floatstr(tmp);
		cache_get_field_content(row, "ExteriorA", tmp, MainPipeline); HouseInfo[index][hExteriorA] = floatstr(tmp);
		cache_get_field_content(row, "CustomExterior", tmp, MainPipeline); HouseInfo[index][hCustomExterior] = strval(tmp);
		cache_get_field_content(row, "InteriorX", tmp, MainPipeline); HouseInfo[index][hInteriorX] = floatstr(tmp);
		cache_get_field_content(row, "InteriorY", tmp, MainPipeline); HouseInfo[index][hInteriorY] = floatstr(tmp);
		cache_get_field_content(row, "InteriorZ", tmp, MainPipeline); HouseInfo[index][hInteriorZ] = floatstr(tmp);
		cache_get_field_content(row, "InteriorR", tmp, MainPipeline); HouseInfo[index][hInteriorR] = floatstr(tmp);
		cache_get_field_content(row, "InteriorA", tmp, MainPipeline); HouseInfo[index][hInteriorA] = floatstr(tmp);
		cache_get_field_content(row, "CustomInterior", tmp, MainPipeline); HouseInfo[index][hCustomInterior] = strval(tmp);
		cache_get_field_content(row, "ExtIW", tmp, MainPipeline); HouseInfo[index][hExtIW] = strval(tmp);
		cache_get_field_content(row, "ExtVW", tmp, MainPipeline); HouseInfo[index][hExtVW] = strval(tmp);
		cache_get_field_content(row, "IntIW", tmp, MainPipeline); HouseInfo[index][hIntIW] = strval(tmp);
		cache_get_field_content(row, "IntVW", tmp, MainPipeline); HouseInfo[index][hIntVW] = strval(tmp);
		cache_get_field_content(row, "Lock", tmp, MainPipeline); HouseInfo[index][hLock] = strval(tmp);
		cache_get_field_content(row, "Rentable", tmp, MainPipeline); HouseInfo[index][hRentable] = strval(tmp);
		cache_get_field_content(row, "RentFee", tmp, MainPipeline); HouseInfo[index][hRentFee] = strval(tmp);
		cache_get_field_content(row, "Value", tmp, MainPipeline); HouseInfo[index][hValue] = strval(tmp);
		cache_get_field_content(row, "SafeMoney", tmp, MainPipeline); HouseInfo[index][hSafeMoney] = strval(tmp);
		cache_get_field_content(row, "Pot", tmp, MainPipeline); HouseInfo[index][hPot] = strval(tmp);
		cache_get_field_content(row, "Crack", tmp, MainPipeline); HouseInfo[index][hCrack] = strval(tmp);
		cache_get_field_content(row, "Materials", tmp, MainPipeline); HouseInfo[index][hMaterials] = strval(tmp);
		cache_get_field_content(row, "Heroin", tmp, MainPipeline); HouseInfo[index][hHeroin] = strval(tmp);
		for(new i; i < 5; i++)
		{
			format(szField, sizeof(szField), "Weapons%d", i);
			cache_get_field_content(row, szField, tmp, MainPipeline);
			HouseInfo[index][hWeapons][i] = strval(tmp);
		}
		cache_get_field_content(row, "GLUpgrade", tmp, MainPipeline); HouseInfo[index][hGLUpgrade] = strval(tmp);
		cache_get_field_content(row, "PickupID", tmp, MainPipeline); HouseInfo[index][hPickupID] = strval(tmp);
		cache_get_field_content(row, "MailX", tmp, MainPipeline); HouseInfo[index][hMailX] = floatstr(tmp);
		cache_get_field_content(row, "MailY", tmp, MainPipeline); HouseInfo[index][hMailY] = floatstr(tmp);
		cache_get_field_content(row, "MailZ", tmp, MainPipeline); HouseInfo[index][hMailZ] = floatstr(tmp);
		cache_get_field_content(row, "MailA", tmp, MainPipeline); HouseInfo[index][hMailA] = floatstr(tmp);
		cache_get_field_content(row, "MailType", tmp, MainPipeline); HouseInfo[index][hMailType] = strval(tmp);
		cache_get_field_content(row, "ClosetX", tmp, MainPipeline); HouseInfo[index][hClosetX] = floatstr(tmp);
		cache_get_field_content(row, "ClosetY", tmp, MainPipeline); HouseInfo[index][hClosetY] = floatstr(tmp);
		cache_get_field_content(row, "ClosetZ", tmp, MainPipeline); HouseInfo[index][hClosetZ] = floatstr(tmp);

        cache_get_field_content(row, "TrasX", tmp, MainPipeline); HouseInfo[index][hTrasX] = floatstr(tmp);
        cache_get_field_content(row, "TrasY", tmp, MainPipeline); HouseInfo[index][hTrasY] = floatstr(tmp);
        cache_get_field_content(row, "TrasZ", tmp, MainPipeline); HouseInfo[index][hTrasZ] = floatstr(tmp);
        cache_get_field_content(row, "TrasA", tmp, MainPipeline); HouseInfo[index][hTrasA] = floatstr(tmp);

		ReloadHousePickup(index);
		if(HouseInfo[index][hClosetX] != 0.0) HouseInfo[index][hClosetTextID] = CreateDynamic3DTextLabel("Tu quan ao\n/Tu de su dung", 0xFFFFFF88, HouseInfo[index][hClosetX], HouseInfo[index][hClosetY], HouseInfo[index][hClosetZ]+0.5,10.0, .testlos = 1, .worldid = HouseInfo[index][hIntVW], .interiorid = HouseInfo[index][hIntIW], .streamdistance = 10.0);
		if(HouseInfo[index][hMailX] != 0.0) RenderHouseMailbox(index);
	}
	return 1;
}

forward OnLoadHouses();
public OnLoadHouses()
{
	new i, rows, fields, szField[24], tmp[128];
	cache_get_data(rows, fields, MainPipeline);

	while(i < rows)
	{
		cache_get_field_content(i, "id", tmp, MainPipeline); HouseInfo[i][hSQLId] = strval(tmp);
		cache_get_field_content(i, "Owned", tmp, MainPipeline); HouseInfo[i][hOwned] = strval(tmp);
		cache_get_field_content(i, "Level", tmp, MainPipeline); HouseInfo[i][hLevel] = strval(tmp);
		cache_get_field_content(i, "Description", HouseInfo[i][hDescription], MainPipeline, 16);
		cache_get_field_content(i, "OwnerID", tmp, MainPipeline); HouseInfo[i][hOwnerID] = strval(tmp);
		cache_get_field_content(i, "Username", HouseInfo[i][hOwnerName], MainPipeline, MAX_PLAYER_NAME);
		cache_get_field_content(i, "ExteriorX", tmp, MainPipeline); HouseInfo[i][hExteriorX] = floatstr(tmp);
		cache_get_field_content(i, "ExteriorY", tmp, MainPipeline); HouseInfo[i][hExteriorY] = floatstr(tmp);
		cache_get_field_content(i, "ExteriorZ", tmp, MainPipeline); HouseInfo[i][hExteriorZ] = floatstr(tmp);
		cache_get_field_content(i, "ExteriorR", tmp, MainPipeline); HouseInfo[i][hExteriorR] = floatstr(tmp);
		cache_get_field_content(i, "ExteriorA", tmp, MainPipeline); HouseInfo[i][hExteriorA] = floatstr(tmp);
		cache_get_field_content(i, "CustomExterior", tmp, MainPipeline); HouseInfo[i][hCustomExterior] = strval(tmp);
		cache_get_field_content(i, "InteriorX", tmp, MainPipeline); HouseInfo[i][hInteriorX] = floatstr(tmp);
		cache_get_field_content(i, "InteriorY", tmp, MainPipeline); HouseInfo[i][hInteriorY] = floatstr(tmp);
		cache_get_field_content(i, "InteriorZ", tmp, MainPipeline); HouseInfo[i][hInteriorZ] = floatstr(tmp);
		cache_get_field_content(i, "InteriorR", tmp, MainPipeline); HouseInfo[i][hInteriorR] = floatstr(tmp);
		cache_get_field_content(i, "InteriorA", tmp, MainPipeline); HouseInfo[i][hInteriorA] = floatstr(tmp);
		cache_get_field_content(i, "CustomInterior", tmp, MainPipeline); HouseInfo[i][hCustomInterior] = strval(tmp);
		cache_get_field_content(i, "ExtIW", tmp, MainPipeline); HouseInfo[i][hExtIW] = strval(tmp);
		cache_get_field_content(i, "ExtVW", tmp, MainPipeline); HouseInfo[i][hExtVW] = strval(tmp);
		cache_get_field_content(i, "IntIW", tmp, MainPipeline); HouseInfo[i][hIntIW] = strval(tmp);
		cache_get_field_content(i, "IntVW", tmp, MainPipeline); HouseInfo[i][hIntVW] = strval(tmp);
		cache_get_field_content(i, "Lock", tmp, MainPipeline); HouseInfo[i][hLock] = strval(tmp);
		cache_get_field_content(i, "Rentable", tmp, MainPipeline); HouseInfo[i][hRentable] = strval(tmp);
		cache_get_field_content(i, "RentFee", tmp, MainPipeline); HouseInfo[i][hRentFee] = strval(tmp);
		cache_get_field_content(i, "Value", tmp, MainPipeline); HouseInfo[i][hValue] = strval(tmp);
		cache_get_field_content(i, "SafeMoney", tmp, MainPipeline); HouseInfo[i][hSafeMoney] = strval(tmp);
		cache_get_field_content(i, "Pot", tmp, MainPipeline); HouseInfo[i][hPot] = strval(tmp);
		cache_get_field_content(i, "Crack", tmp, MainPipeline); HouseInfo[i][hCrack] = strval(tmp);
		cache_get_field_content(i, "Materials", tmp, MainPipeline); HouseInfo[i][hMaterials] = strval(tmp);
		cache_get_field_content(i, "Heroin", tmp, MainPipeline); HouseInfo[i][hHeroin] = strval(tmp);
		for(new j; j < 5; j++)
		{
			format(szField, sizeof(szField), "Weapons%d", j);
			cache_get_field_content(i, szField, tmp, MainPipeline);
			HouseInfo[i][hWeapons][j] = strval(tmp);
		}
		cache_get_field_content(i, "GLUpgrade", tmp, MainPipeline); HouseInfo[i][hGLUpgrade] = strval(tmp);
		cache_get_field_content(i, "PickupID", tmp, MainPipeline); HouseInfo[i][hPickupID] = strval(tmp);
		cache_get_field_content(i, "MailX", tmp, MainPipeline); HouseInfo[i][hMailX] = floatstr(tmp);
		cache_get_field_content(i, "MailY", tmp, MainPipeline); HouseInfo[i][hMailY] = floatstr(tmp);
		cache_get_field_content(i, "MailZ", tmp, MainPipeline); HouseInfo[i][hMailZ] = floatstr(tmp);
		cache_get_field_content(i, "MailA", tmp, MainPipeline); HouseInfo[i][hMailA] = floatstr(tmp);
		cache_get_field_content(i, "MailType", tmp, MainPipeline); HouseInfo[i][hMailType] = strval(tmp);
		cache_get_field_content(i, "ClosetX", tmp, MainPipeline); HouseInfo[i][hClosetX] = floatstr(tmp);
		cache_get_field_content(i, "ClosetY", tmp, MainPipeline); HouseInfo[i][hClosetY] = floatstr(tmp);
		cache_get_field_content(i, "ClosetZ", tmp, MainPipeline); HouseInfo[i][hClosetZ] = floatstr(tmp);

        cache_get_field_content(i, "TrasX", tmp, MainPipeline); HouseInfo[i][hTrasX] = floatstr(tmp);
        cache_get_field_content(i, "TrasY", tmp, MainPipeline); HouseInfo[i][hTrasY] = floatstr(tmp);
        cache_get_field_content(i, "TrasZ", tmp, MainPipeline); HouseInfo[i][hTrasZ] = floatstr(tmp);
        cache_get_field_content(i, "TrasA", tmp, MainPipeline); HouseInfo[i][hTrasA] = floatstr(tmp);

		ReloadHousePickup(i);
		if(HouseInfo[i][hClosetX] != 0.0) HouseInfo[i][hClosetTextID] = CreateDynamic3DTextLabel("Tu quan ao\n/tu de su dung", 0xFFFFFF88, HouseInfo[i][hClosetX], HouseInfo[i][hClosetY], HouseInfo[i][hClosetZ]+0.5,10.0, .testlos = 1, .worldid = HouseInfo[i][hIntVW], .interiorid = HouseInfo[i][hIntIW], .streamdistance = 10.0);
		if(HouseInfo[i][hMailX] != 0.0) RenderHouseMailbox(i);
		i++;
	}
	if(i > 0) printf("[LoadHouses] %d ngoi nha duoc tai.", i);
	else printf("[LoadHouses] Khong the tai vi tri ngoi nha.");
}
forward OnLoadMailboxes();
public OnLoadMailboxes()
{
	new string[512], i;
	new rows, fields;
	cache_get_data(rows, fields, MainPipeline);
	while(i<rows)
	{
	    for(new field;field<fields;field++)
	    {
 		    cache_get_row(i, field, string, MainPipeline);
			switch(field)
			{
			    case 1: MailBoxes[i][mbVW] = strval(string);
				case 2: MailBoxes[i][mbInt] = strval(string);
				case 3: MailBoxes[i][mbModel] = strval(string);
				case 4: MailBoxes[i][mbPosX] = floatstr(string);
				case 5: MailBoxes[i][mbPosY] = floatstr(string);
				case 6: MailBoxes[i][mbPosZ] = floatstr(string);
				case 7: MailBoxes[i][mbAngle] = floatstr(string);
			}
		}
		RenderStreetMailbox(i);
  		i++;
 	}
	if(i > 0) printf("[LoadMailboxes] %d mailboxes duoc tai.", i);
	else printf("[LoadMailboxes] Khong the tai mailboxes.");
	return 1;
}

forward OnLoadSpeedCameras();
public OnLoadSpeedCameras()
{
	new fields, rows, index, result[128];
	cache_get_data(rows, fields, MainPipeline);

	while ((index < rows))
	{
		cache_get_field_content(index, "id", result, MainPipeline); SpeedCameras[index][_scDatabase] = strval(result);
		cache_get_field_content(index, "pos_x", result, MainPipeline); SpeedCameras[index][_scPosX] = floatstr(result);
		cache_get_field_content(index, "pos_y", result, MainPipeline); SpeedCameras[index][_scPosY] = floatstr(result);
		cache_get_field_content(index, "pos_z", result, MainPipeline); SpeedCameras[index][_scPosZ] = floatstr(result);
		cache_get_field_content(index, "rotation", result, MainPipeline); SpeedCameras[index][_scRotation] = floatstr(result);
		cache_get_field_content(index, "range", result, MainPipeline); SpeedCameras[index][_scRange] = floatstr(result);
		cache_get_field_content(index, "speed_limit", result, MainPipeline); SpeedCameras[index][_scLimit] = floatstr(result);

		SpeedCameras[index][_scActive] = true;
		SpeedCameras[index][_scObjectId] = -1;
		SpawnSpeedCamera(index);

		index++;
	}

	if (index == 0)
		printf("[SpeedCameras] Khong the tai cac may ban toc do.");
	else
		printf("[SpeedCameras] Tai %i May ban toc do.", index);

	return 1;
}

forward OnNewSpeedCamera(index);
public OnNewSpeedCamera(index)
{
	new db = mysql_insert_id(MainPipeline);
	SpeedCameras[index][_scDatabase] = db;
}

// @returns
//  ID of new speed cam on success, or -1 on failure


forward OnLoadPayNSprays();
public OnLoadPayNSprays()
{
	new i, rows, fields, tmp[128], string[128];
	cache_get_data(rows, fields, MainPipeline);

	while(i < rows)
	{
		cache_get_field_content(i, "id", tmp, MainPipeline);  PayNSprays[i][pnsSQLId] = strval(tmp);
		cache_get_field_content(i, "Status", tmp, MainPipeline); PayNSprays[i][pnsStatus] = strval(tmp);
		cache_get_field_content(i, "PosX", tmp, MainPipeline); PayNSprays[i][pnsPosX] = floatstr(tmp);
		cache_get_field_content(i, "PosY", tmp, MainPipeline); PayNSprays[i][pnsPosY] = floatstr(tmp);
		cache_get_field_content(i, "PosZ", tmp, MainPipeline); PayNSprays[i][pnsPosZ] = floatstr(tmp);
		cache_get_field_content(i, "VW", tmp, MainPipeline); PayNSprays[i][pnsVW] = strval(tmp);
		cache_get_field_content(i, "Int", tmp, MainPipeline); PayNSprays[i][pnsInt] = strval(tmp);
		cache_get_field_content(i, "GroupCost", tmp, MainPipeline); PayNSprays[i][pnsGroupCost] = strval(tmp);
		cache_get_field_content(i, "RegCost", tmp, MainPipeline); PayNSprays[i][pnsRegCost] = strval(tmp);
		if(PayNSprays[i][pnsStatus] > 0)
		{
			format(string, sizeof(string), "/suachuaxe\nPhi sua chua -- Khong uu tien: $%s | Uu tien ('Faction'): $%s\nID: %d", number_format(PayNSprays[i][pnsRegCost]), number_format(PayNSprays[i][pnsGroupCost]), i);
			PayNSprays[i][pnsTextID] = CreateDynamic3DTextLabel(string, COLOR_YELLOW, PayNSprays[i][pnsPosX], PayNSprays[i][pnsPosY], PayNSprays[i][pnsPosZ]+0.5,10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, PayNSprays[i][pnsVW], PayNSprays[i][pnsInt], -1);
			PayNSprays[i][pnsPickupID] = CreateDynamicPickup(1239, 23, PayNSprays[i][pnsPosX], PayNSprays[i][pnsPosY], PayNSprays[i][pnsPosZ], PayNSprays[i][pnsVW]);
			PayNSprays[i][pnsMapIconID] = CreateDynamicMapIcon(PayNSprays[i][pnsPosX], PayNSprays[i][pnsPosY], PayNSprays[i][pnsPosZ], 63, 0, PayNSprays[i][pnsVW], PayNSprays[i][pnsInt], -1, 500.0);
		}
		i++;
	}
}

forward OnLoadArrestPoint(index);
public OnLoadArrestPoint(index)
{
	new rows, fields, tmp[128], string[128];
	cache_get_data(rows, fields, MainPipeline);

	for(new row; row < rows; row++)
	{
		cache_get_field_content(row, "id", tmp, MainPipeline);  ArrestPoints[index][arrestSQLId] = strval(tmp);
		cache_get_field_content(row, "PosX", tmp, MainPipeline); ArrestPoints[index][arrestPosX] = floatstr(tmp);
		cache_get_field_content(row, "PosY", tmp, MainPipeline); ArrestPoints[index][arrestPosY] = floatstr(tmp);
		cache_get_field_content(row, "PosZ", tmp, MainPipeline); ArrestPoints[index][arrestPosZ] = floatstr(tmp);
		cache_get_field_content(row, "VW", tmp, MainPipeline); ArrestPoints[index][arrestVW] = strval(tmp);
		cache_get_field_content(row, "Int", tmp, MainPipeline); ArrestPoints[index][arrestInt] = strval(tmp);
		cache_get_field_content(row, "Type", tmp, MainPipeline); ArrestPoints[index][arrestType] = strval(tmp);
		if(ArrestPoints[index][arrestPosX] != 0)
		{
			switch(ArrestPoints[index][arrestType])
			{
				case 0:
				{
					format(string, sizeof(string), "<Arrest #%d>\n{e51b1b}/batgiam{b4b4b4} de thao tac", index);
					ArrestPoints[index][arrestTextID] = CreateDynamic3DTextLabel(string, COLOR_BASIC, ArrestPoints[index][arrestPosX], ArrestPoints[index][arrestPosY], ArrestPoints[index][arrestPosZ]+0.6, 4.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, ArrestPoints[index][arrestVW], ArrestPoints[index][arrestInt], -1);
					ArrestPoints[index][arrestPickupID] = CreateDynamicPickup(1247, 23, ArrestPoints[index][arrestPosX], ArrestPoints[index][arrestPosY], ArrestPoints[index][arrestPosZ], ArrestPoints[index][arrestVW]);
				}
				case 2:
				{
					format(string, sizeof(string), "<Arrest #%d>\n{e51b1b}/batgiam{b4b4b4} de thao tac", index);
					ArrestPoints[index][arrestTextID] = CreateDynamic3DTextLabel(string, COLOR_BASIC, ArrestPoints[index][arrestPosX], ArrestPoints[index][arrestPosY], ArrestPoints[index][arrestPosZ]+0.6, 4.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, ArrestPoints[index][arrestVW], ArrestPoints[index][arrestInt], -1);
					ArrestPoints[index][arrestPickupID] = CreateDynamicPickup(1247, 23, ArrestPoints[index][arrestPosX], ArrestPoints[index][arrestPosY], ArrestPoints[index][arrestPosZ], ArrestPoints[index][arrestVW]);
				}
				case 3:
				{
					format(string, sizeof(string), "<Arrest #%d>\n{e51b1b}/warrantarrest{b4b4b4} de thao tac", index);
					ArrestPoints[index][arrestTextID] = CreateDynamic3DTextLabel(string, COLOR_BASIC, ArrestPoints[index][arrestPosX], ArrestPoints[index][arrestPosY], ArrestPoints[index][arrestPosZ]+0.6, 4.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, ArrestPoints[index][arrestVW], ArrestPoints[index][arrestInt], -1);
					ArrestPoints[index][arrestPickupID] = CreateDynamicPickup(1247, 23, ArrestPoints[index][arrestPosX], ArrestPoints[index][arrestPosY], ArrestPoints[index][arrestPosZ], ArrestPoints[index][arrestVW]);
				}
				case 4:
				{
					format(string, sizeof(string), "<Arrest #%d>\n{e51b1b}/jarrest{b4b4b4} de thao tac", index);
					ArrestPoints[index][arrestTextID] = CreateDynamic3DTextLabel(string, COLOR_BASIC, ArrestPoints[index][arrestPosX], ArrestPoints[index][arrestPosY], ArrestPoints[index][arrestPosZ]+0.6, 4.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, ArrestPoints[index][arrestVW], ArrestPoints[index][arrestInt], -1);
					ArrestPoints[index][arrestPickupID] = CreateDynamicPickup(1247, 23, ArrestPoints[index][arrestPosX], ArrestPoints[index][arrestPosY], ArrestPoints[index][arrestPosZ], ArrestPoints[index][arrestVW]);
				}
			}
		}
	}
	return 1;
}

forward OnLoadArrestPoints();
public OnLoadArrestPoints()
{
	new i, rows, fields, tmp[128], string[128];
	cache_get_data(rows, fields, MainPipeline);

	while(i < rows)
	{
		cache_get_field_content(i, "id", tmp, MainPipeline);  ArrestPoints[i][arrestSQLId] = strval(tmp);
		cache_get_field_content(i, "PosX", tmp, MainPipeline); ArrestPoints[i][arrestPosX] = floatstr(tmp);
		cache_get_field_content(i, "PosY", tmp, MainPipeline); ArrestPoints[i][arrestPosY] = floatstr(tmp);
		cache_get_field_content(i, "PosZ", tmp, MainPipeline); ArrestPoints[i][arrestPosZ] = floatstr(tmp);
		cache_get_field_content(i, "VW", tmp, MainPipeline); ArrestPoints[i][arrestVW] = strval(tmp);
		cache_get_field_content(i, "Int", tmp, MainPipeline); ArrestPoints[i][arrestInt] = strval(tmp);
		cache_get_field_content(i, "Type", tmp, MainPipeline); ArrestPoints[i][arrestType] = strval(tmp);
		if(ArrestPoints[i][arrestPosX] != 0)
		{
			switch(ArrestPoints[i][arrestType])
			{
				case 0:
				{
					format(string, sizeof(string), "/arrest\nArrest Point #%d", i);
					ArrestPoints[i][arrestTextID] = CreateDynamic3DTextLabel(string, COLOR_DBLUE, ArrestPoints[i][arrestPosX], ArrestPoints[i][arrestPosY], ArrestPoints[i][arrestPosZ]+0.6, 4.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, ArrestPoints[i][arrestVW], ArrestPoints[i][arrestInt], -1);
					ArrestPoints[i][arrestPickupID] = CreateDynamicPickup(1247, 23, ArrestPoints[i][arrestPosX], ArrestPoints[i][arrestPosY], ArrestPoints[i][arrestPosZ], ArrestPoints[i][arrestVW]);
				}
				case 2:
				{
					format(string, sizeof(string), "/batgiam\nArrest Point #%d", i);
					ArrestPoints[i][arrestTextID] = CreateDynamic3DTextLabel(string, COLOR_DBLUE, ArrestPoints[i][arrestPosX], ArrestPoints[i][arrestPosY], ArrestPoints[i][arrestPosZ]+0.6, 4.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, ArrestPoints[i][arrestVW], ArrestPoints[i][arrestInt], -1);
					ArrestPoints[i][arrestPickupID] = CreateDynamicPickup(1247, 23, ArrestPoints[i][arrestPosX], ArrestPoints[i][arrestPosY], ArrestPoints[i][arrestPosZ], ArrestPoints[i][arrestVW]);
				}
				case 3:
				{
					format(string, sizeof(string), "/warrantarrest\nArrest Point #%d", i);
					ArrestPoints[i][arrestTextID] = CreateDynamic3DTextLabel(string, COLOR_DBLUE, ArrestPoints[i][arrestPosX], ArrestPoints[i][arrestPosY], ArrestPoints[i][arrestPosZ]+0.6, 4.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, ArrestPoints[i][arrestVW], ArrestPoints[i][arrestInt], -1);
					ArrestPoints[i][arrestPickupID] = CreateDynamicPickup(1247, 23, ArrestPoints[i][arrestPosX], ArrestPoints[i][arrestPosY], ArrestPoints[i][arrestPosZ], ArrestPoints[i][arrestVW]);
				}
				case 4:
				{
					format(string, sizeof(string), "/jarrest\nArrest Point #%d", i);
					ArrestPoints[i][arrestTextID] = CreateDynamic3DTextLabel(string, COLOR_DBLUE, ArrestPoints[i][arrestPosX], ArrestPoints[i][arrestPosY], ArrestPoints[i][arrestPosZ]+0.6, 4.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, ArrestPoints[i][arrestVW], ArrestPoints[i][arrestInt], -1);
					ArrestPoints[i][arrestPickupID] = CreateDynamicPickup(1247, 23, ArrestPoints[i][arrestPosX], ArrestPoints[i][arrestPosY], ArrestPoints[i][arrestPosZ], ArrestPoints[i][arrestVW]);
				}
			}
		}
		i++;
	}
}

forward OnLoadImpoundPoint(index);
public OnLoadImpoundPoint(index)
{
	new rows, fields, tmp[128], string[128];
	cache_get_data(rows, fields, MainPipeline);

	for(new row; row < rows; row++)
	{
		cache_get_field_content(row, "id", tmp, MainPipeline);  ImpoundPoints[index][impoundSQLId] = strval(tmp);
		cache_get_field_content(row, "PosX", tmp, MainPipeline); ImpoundPoints[index][impoundPosX] = floatstr(tmp);
		cache_get_field_content(row, "PosY", tmp, MainPipeline); ImpoundPoints[index][impoundPosY] = floatstr(tmp);
		cache_get_field_content(row, "PosZ", tmp, MainPipeline); ImpoundPoints[index][impoundPosZ] = floatstr(tmp);
		cache_get_field_content(row, "VW", tmp, MainPipeline); ImpoundPoints[index][impoundVW] = strval(tmp);
		cache_get_field_content(row, "Int", tmp, MainPipeline); ImpoundPoints[index][impoundInt] = strval(tmp);
		if(ImpoundPoints[index][impoundPosX] != 0)
		{
			format(string, sizeof(string), "Impound Yard #%d\nType /impound to impound a vehicle", index);
			ImpoundPoints[index][impoundTextID] = CreateDynamic3DTextLabel(string, COLOR_YELLOW, ImpoundPoints[index][impoundPosX], ImpoundPoints[index][impoundPosY], ImpoundPoints[index][impoundPosZ]+0.6, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, ImpoundPoints[index][impoundVW], ImpoundPoints[index][impoundInt], -1);
		}
	}
	return 1;
}

forward OnLoadImpoundPoints();
public OnLoadImpoundPoints()
{
	new i, rows, fields, tmp[128], string[128];
	cache_get_data(rows, fields, MainPipeline);

	while(i < rows)
	{
		cache_get_field_content(i, "id", tmp, MainPipeline);  ImpoundPoints[i][impoundSQLId] = strval(tmp);
		cache_get_field_content(i, "PosX", tmp, MainPipeline); ImpoundPoints[i][impoundPosX] = floatstr(tmp);
		cache_get_field_content(i, "PosY", tmp, MainPipeline); ImpoundPoints[i][impoundPosY] = floatstr(tmp);
		cache_get_field_content(i, "PosZ", tmp, MainPipeline); ImpoundPoints[i][impoundPosZ] = floatstr(tmp);
		cache_get_field_content(i, "VW", tmp, MainPipeline); ImpoundPoints[i][impoundVW] = strval(tmp);
		cache_get_field_content(i, "Int", tmp, MainPipeline); ImpoundPoints[i][impoundInt] = strval(tmp);
		if(ImpoundPoints[i][impoundPosX] != 0)
		{
			format(string, sizeof(string), "Impound Yard #%d\nType /impound to impound a vehicle", i);
			ImpoundPoints[i][impoundTextID] = CreateDynamic3DTextLabel(string, COLOR_YELLOW, ImpoundPoints[i][impoundPosX], ImpoundPoints[i][impoundPosY], ImpoundPoints[i][impoundPosZ]+0.6, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, ImpoundPoints[i][impoundVW], ImpoundPoints[i][impoundInt], -1);
		}
		i++;
	}
}

forward LoadDynamicGroups();
public LoadDynamicGroups()
{
    mysql_function_query(MainPipeline, "SELECT * FROM `groups`", true, "Group_QueryFinish", "ii", GROUP_QUERY_LOAD, 0);
	mysql_function_query(MainPipeline, "SELECT * FROM `lockers`", true, "Group_QueryFinish", "ii", GROUP_QUERY_LOCKERS, 0);
	mysql_function_query(MainPipeline, "SELECT * FROM `jurisdictions`", true, "Group_QueryFinish", "ii", GROUP_QUERY_JURISDICTIONS, 0);
	return ;
}

forward LoadDynamicGroupVehicles();
public LoadDynamicGroupVehicles()
{
    mysql_function_query(MainPipeline, "SELECT * FROM `groupvehs`", true, "DynVeh_QueryFinish", "ii", GV_QUERY_LOAD, 0);
    return 1;
}

forward ParkRentedVehicle(playerid, vehicleid, modelid, Float:X, Float:Y, Float:Z);
public ParkRentedVehicle(playerid, vehicleid, modelid, Float:X, Float:Y, Float:Z)
{
	if(IsPlayerInRangeOfPoint(playerid, 1.0, X, Y, Z))
	{
	    new Float:x, Float:y, Float:z, Float:angle, Float:health, string[180], Float: oldfuel, arrDamage[4];
	    GetVehicleHealth(vehicleid, health);
     	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessageEx(playerid, COLOR_GREY, "Ban phai o ghe lai xe.");
     	if(health < 800) return SendClientMessageEx(playerid, COLOR_GREY, " Khong the dau xe khi xe cua ban hu hong qua nang.");

		GetVehiclePos(vehicleid, x, y, z);
		GetVehicleZAngle(vehicleid, angle);
		SurfingCheck(vehicleid);
		oldfuel = VehicleFuel[vehicleid];

		GetVehicleDamageStatus(vehicleid, arrDamage[0], arrDamage[1], arrDamage[2], arrDamage[3]);
		DestroyVehicle(GetPVarInt(playerid, "RentedVehicle"));
        SetPVarInt(playerid, "RentedVehicle", CreateVehicle(modelid, x, y, z, angle, random(128), random(128), 2000000));
		Vehicle_ResetData(GetPVarInt(playerid, "RentedVehicle"));
		VehicleFuel[GetPVarInt(playerid, "RentedVehicle")] = oldfuel;
		SetVehicleHealth(GetPVarInt(playerid, "RentedVehicle"), health);
		UpdateVehicleDamageStatus(vehicleid, arrDamage[0], arrDamage[1], arrDamage[2], arrDamage[3]);

		format(string, sizeof(string), "UPDATE `rentedcars` SET `posx` = '%f', `posy` = '%f', `posz` = '%f', `posa` = '%f' WHERE `sqlid` = '%d'", x, y, z, angle, GetPlayerSQLId(playerid));
        mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);

		IsPlayerEntering{playerid} = true;
		PutPlayerInVehicle(playerid, vehicleid, 0);
		SetPlayerArmedWeapon(playerid, 0);
		format(string, sizeof(string), "* %s has parked their vehicle.", GetPlayerNameEx(playerid));
		ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

	}
	else
	{
	    SendClientMessage(playerid, COLOR_WHITE, "Xe khong the dau khi ban di chuyen xe!");
	}
	return 1;
}

forward OnPlayerChangePass(index);
public OnPlayerChangePass(index)
{
	if(mysql_affected_rows(MainPipeline)) {

		new
			szBuffer[129],
			szMessage[103];

		GetPVarString(index, "PassChange", szBuffer, sizeof(szBuffer));
		format(szMessage, sizeof(szMessage), "Ban da thay doi mat khau cua ban thanh '%s'.", szBuffer);
		SendClientMessageEx(index, COLOR_YELLOW, szMessage);

		format(szMessage, sizeof(szMessage), "%s (IP: %s) da thay doi mat khau cua ho.", GetPlayerNameEx(index), PlayerInfo[index][pIP]);
		Log("logs/password.log", szMessage);
		DeletePVar(index, "PassChange");

		if(PlayerInfo[index][pForcePasswordChange] == 1)
		{
		    PlayerInfo[index][pForcePasswordChange] = 0;
		    format(szMessage, sizeof(szMessage), "UPDATE `accounts` SET `ForcePasswordChange` = '0' WHERE `id` = '%i'", PlayerInfo[index][pId]);
			mysql_function_query(MainPipeline, szMessage, false, "OnQueryFinish", "ii", SENDDATA_THREAD, index);
		}
	}
	else SendClientMessageEx(index, COLOR_RED, "Co mot loi su ly say ra, mat khau cua ban van duoc giu nguyen.");
	return 1;
}

forward OnChangeUserPassword(index);
public OnChangeUserPassword(index)
{
	if(GetPVarType(index, "ChangePin"))
	{
	    new string[128], name[24];
		GetPVarString(index, "OnChangeUserPassword", name, 24);

		if(mysql_affected_rows(MainPipeline)) {
			format(string, sizeof(string), "Ban da thay doi thanh cong ma PIN %s's.", name);
			SendClientMessageEx(index, COLOR_WHITE, string);
		}
		else {
			format(string, sizeof(string), "Da co van de say ra cho viec thay doi PIN %s's.", name);
			SendClientMessageEx(index, COLOR_WHITE, string);
		}
		DeletePVar(index, "ChangePin");
		DeletePVar(index, "OnChangeUserPassword");
	}
	else
	{
		new string[128], name[24];
		GetPVarString(index, "OnChangeUserPassword", name, 24);

		if(mysql_affected_rows(MainPipeline)) {
			format(string, sizeof(string), "Ban da thay doi thanh cong mat khau %s's.", name);
			SendClientMessageEx(index, COLOR_WHITE, string);
		}
		else {
			format(string, sizeof(string), "Da co van de say ra cho viec thay doi mat khau %s's.", name);
			SendClientMessageEx(index, COLOR_WHITE, string);
		}
		DeletePVar(index, "OnChangeUserPassword");
	}
	return 1;
}

forward QueryCheckCountFinish(playerid, giveplayername[], tdate[], type);
public QueryCheckCountFinish(playerid, giveplayername[], tdate[], type)
{
    new string[128], rows, fields, sResult[24], tcount, hhour[9], chour;
	cache_get_data(rows, fields, MainPipeline);

	switch(type)
	{
		case 0:
		{
			cache_get_field_content(0, "SUM(count)", sResult, MainPipeline); tcount = strval(sResult);
			if(tcount > 0)
			{
				format(string, sizeof(string), "%s duoc chap nhan {%06x}%d {%06x}bao cao ve %s.", giveplayername, COLOR_GREEN >>> 8, tcount, COLOR_WHITE >>> 8, tdate);
				SendClientMessageEx(playerid, COLOR_WHITE, string);
			}
			else
			{
				format(string, sizeof(string), "%s khong chap nhan bao cao %s.", giveplayername, tdate);
				return SendClientMessageEx(playerid, COLOR_GRAD1, string);
			}
		}
		case 1:
		{
			if(rows > 0)
			{
				SendClientMessageEx(playerid, COLOR_GRAD1, "By hour:");
				for(new i; i < rows; i++)
				{
					cache_get_field_content(i, "count", sResult, MainPipeline); new hcount = strval(sResult);
					cache_get_field_content(i, "hour", hhour, MainPipeline, sizeof(hhour));
					format(hhour, sizeof(hhour), "%s", str_replacez(":00:00", "", hhour));
					chour = strval(hhour);
					format(string, sizeof(string), "%s: {%06x}%d", ConvertToTwelveHour(chour), COLOR_GREEN >>> 8, hcount);
					SendClientMessageEx(playerid, COLOR_WHITE, string);
				}
			}
		}
		case 2:
		{
			cache_get_field_content(0, "SUM(count)", sResult, MainPipeline); tcount = strval(sResult);
			if(tcount > 0)
			{
				format(string, sizeof(string), "%s chap nhan {%06x}%d {%06x}yeu cau giup do %s.", giveplayername, COLOR_GREEN >>> 8, tcount, COLOR_WHITE >>> 8, tdate);
				SendClientMessageEx(playerid, COLOR_WHITE, string);
			}
			else
			{
				format(string, sizeof(string), "%s khong chap nhan yeu cau giup do %s.", giveplayername, tdate);
				return SendClientMessageEx(playerid, COLOR_GRAD1, string);
			}
		}
		case 3:
		{
			if(rows > 0)
			{
				SendClientMessageEx(playerid, COLOR_GRAD1, "By hour:");
				for(new i; i < rows; i++)
				{
					cache_get_field_content(i, "count", sResult, MainPipeline); new hcount = strval(sResult);
					cache_get_field_content(i, "hour", hhour, MainPipeline, sizeof(hhour));
					format(hhour, sizeof(hhour), "%s", str_replacez(":00:00", "", hhour));
					chour = strval(hhour);
					format(string, sizeof(string), "%s: {%06x}%d", ConvertToTwelveHour(chour), COLOR_GREEN >>> 8, hcount);
					SendClientMessageEx(playerid, COLOR_WHITE, string);
				}
			}
		}
	}
	return 1;
}

forward QueryUsernameCheck(playerid, tdate[], type);
public QueryUsernameCheck(playerid, tdate[], type)
{
    new string[128], rows, fields, giveplayerid, sResult[MAX_PLAYER_NAME];
	cache_get_data(rows, fields, MainPipeline);

	if(rows > 0)
	{
		switch(type)
		{
			case 0:
			{
				cache_get_field_content(0, "id", sResult, MainPipeline); giveplayerid = strval(sResult);
				cache_get_field_content(0, "Username", sResult, MainPipeline, sizeof(sResult));
				format(string, sizeof(string), "SELECT SUM(count) FROM `tokens_report` WHERE `playerid` = %d AND `date` = '%s'", giveplayerid, tdate);
				mysql_function_query(MainPipeline, string, true, "QueryCheckCountFinish", "issi", playerid, sResult, tdate, 0);
				format(string, sizeof(string), "SELECT `count`, `hour` FROM `tokens_report` WHERE `playerid` = %d AND `date` = '%s' ORDER BY `hour` ASC", giveplayerid, tdate);
				mysql_function_query(MainPipeline, string, true, "QueryCheckCountFinish", "issi", playerid, sResult, tdate, 1);
			}
			case 1:
			{
				cache_get_field_content(0, "id", sResult, MainPipeline); giveplayerid = strval(sResult);
				cache_get_field_content(0, "Username", sResult, MainPipeline, sizeof(sResult));
				format(string, sizeof(string), "SELECT SUM(count) FROM `tokens_request` WHERE `playerid` = %d AND `date` = '%s'", giveplayerid, tdate);
				mysql_function_query(MainPipeline, string, true, "QueryCheckCountFinish", "issi", playerid, sResult, tdate, 2);
				format(string, sizeof(string), "SELECT `count`, `hour` FROM `tokens_request` WHERE `playerid` = %d AND `date` = '%s' ORDER BY `hour` ASC", giveplayerid, tdate);
				mysql_function_query(MainPipeline, string, true, "QueryCheckCountFinish", "issi", playerid, sResult, tdate, 3);
			}
		}
	}
	else return SendClientMessageEx(playerid, COLOR_GRAD1, "That account doesn't exist!");
	return 1;
}

forward OnBanPlayer(index);
public OnBanPlayer(index)
{
	new string[128], name[24], reason[64];
	GetPVarString(index, "OnBanPlayer", name, 24);
	GetPVarString(index, "OnBanPlayerReason", reason, 64);

	if(IsPlayerConnected(index))
	{
		if(mysql_affected_rows(MainPipeline)) {
			format(string, sizeof(string), "Ban da cam tai khoan %s's .", name);
			SendClientMessageEx(index, COLOR_WHITE, string);

			format(string, sizeof(string), "AdmCmd: %s da cam tai khoan %s offline, ly do: %s", name, GetPlayerNameEx(index), reason);
			Log("logs/ban.log", string);
			format(string, 128, "AdmCmd: %s da cam tai khoan %s offline, ly do: %s", name, GetPlayerNameEx(index), reason);
			ABroadCast(COLOR_LIGHTRED,string,2);
			print(string);
		}
		else {
			format(string, sizeof(string), "Da co van de say ra voi cam tai khoan %s's.", name);
			SendClientMessageEx(index, COLOR_WHITE, string);
		}
  		DeletePVar(index, "OnBanPlayer");
		DeletePVar(index, "OnBanPlayerReason");
	}
	return 1;
}

forward OnBanIP(index);
public OnBanIP(index)
{
	if(IsPlayerConnected(index))
	{
	    new rows, fields;
	    new string[128], ip[32], sqlid[5], id;
    	cache_get_data(rows, fields, MainPipeline);

    	if(rows)
    	{
			cache_get_field_content(0, "id", sqlid, MainPipeline); id = strval(sqlid);
			cache_get_field_content(0, "IP", ip, MainPipeline, 16);

			MySQLBan(id, ip, "Offline Banned (/banaccount)", 1, GetPlayerNameEx(index));

			format(string, sizeof(string), "INSERT INTO `ip_bans` (`ip`, `date`, `reason`, `admin`) VALUES ('%s', NOW(), '%s', '%s')", ip, "Offline Banned", GetPlayerNameEx(index));
			mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);
		}
	}
	return 1;
}

forward OnUnbanPlayer(index);
public OnUnbanPlayer(index)
{
	new string[128], name[24];
	GetPVarString(index, "OnUnbanPlayer", name, 24);

	if(mysql_affected_rows(MainPipeline)) {
		format(string, sizeof(string), "Da bo cam tai khoan %s's thanh cong.", name);
		SendClientMessageEx(index, COLOR_WHITE, string);

		format(string, 128, "AdmCmd: %s da duoc bo cam boi %s.", name, GetPlayerNameEx(index));
		ABroadCast(COLOR_LIGHTRED,string,2);
		format(string, sizeof(string), "AdmCmd: %s da duoc bo cam boi %s.", name, GetPlayerNameEx(index));
		Log("logs/ban.log", string);
		print(string);
	}
	else {
		format(string, sizeof(string), "Da co van de say ra trong qua trinh bo cam tai khoan %s's .", name);
		SendClientMessageEx(index, COLOR_WHITE, string);
	}
	DeletePVar(index, "OnUnbanPlayer");

	return 1;
}

forward OnUnbanIP(index);
public OnUnbanIP(index)
{
	if(IsPlayerConnected(index))
	{
	    new string[128], ip[16];
        new rows, fields;
		cache_get_data(rows, fields, MainPipeline);
		if(rows) {
			cache_get_field_content(0, "IP", ip, MainPipeline, 16);
			RemoveBan(index, ip);

			format(string, sizeof(string), "UPDATE `bans` SET `status` = 4, `date_unban` = NOW() WHERE `ip_address` = '%s'", ip);
			mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);
		}
	}
	return 1;
}

// Use this for generic "You have successfully altered X's account" messages... no need for 578947 public functions!
forward Query_OnExecution(iTargetID);
public Query_OnExecution(iTargetID) {

	new
		szName[MAX_PLAYER_NAME],
		szMessage[64];

	GetPVarString(iTargetID, "QueryEx_Name", szName, sizeof szName);
	if(mysql_affected_rows(MainPipeline)) {
		format(szMessage, sizeof szMessage, "The query on %s's account was successful.", szName);
		SendClientMessageEx(iTargetID, COLOR_WHITE, szMessage);
	}
	else {
		format(szMessage, sizeof szMessage, "The query on %s's account was unsuccessful.", szName);
		SendClientMessageEx(iTargetID, COLOR_WHITE, szMessage);
	}
	return DeletePVar(iTargetID, "QueryEx_Name");
}

forward OnSetSuspended(index, value);
public OnSetSuspended(index, value)
{
	new string[128], name[24];
	GetPVarString(index, "OnSetSuspended", name, 24);

	if(mysql_affected_rows(MainPipeline)) {
		format(string, sizeof(string), "You have successfully %s %s's account.", ((value) ? ("suspended") : ("unsuspended")), name);
		SendClientMessageEx(index, COLOR_WHITE, string);

		format(string, sizeof(string), "AdmCmd: %s was offline %s boi %s.", name, ((value) ? ("suspended") : ("unsuspended")), GetPlayerNameEx(index));
		Log("logs/admin.log", string);
	}
	else {
		format(string, sizeof(string), "Co mot van de say ra voi tai khoan %s %s's .", ((value) ? ("suspending") : ("unsuspending")), name);
		SendClientMessageEx(index, COLOR_WHITE, string);
	}
	DeletePVar(index, "OnSetSuspended");

	return 1;
}
/*#if defined SHOPAUTOMATED
forward OnShopOrder(index);
public OnShopOrder(index)
{
	if(IsPlayerConnected(index))
	{
	    HideNoticeGUIFrame(index);
		new rows, fields;
		cache_get_data(rows, fields, ShopPipeline);
		if(rows > 0)
		{
		    new string[512];
		    new ipsql[16], ip[16];
	    	GetPlayerIp(index, ip, sizeof(ip));
		    mysql_fetch_field_row(ipsql, "ip", MainPipeline);
		    cache_get_field_content(0, "ip", ipsql, ShopPipeline);
		    if(!isnull(ipsql) && strcmp(ipsql, ip, true) == 0)
			{
			    new status[2], name[64], quantity[8], delivered[8], product_id[8];
			    for(new i;i<rows;i++)
			    {
	   				cache_get_field_content(i, "order_status_id", status, ShopPipeline);
			    	if(strval(status) == 2)
				    {
	    			 	cache_get_field_content(i, "name", name, ShopPipeline);
			  			cache_get_field_content(i, "quantity", quantity, ShopPipeline);
			  		    cache_get_field_content(i, "delivered", delivered, ShopPipeline);
			  			cache_get_field_content(i, "order_product_id", product_id, ShopPipeline);
				    	if(strval(quantity)-strval(delivered) <= 0)
					    {
	        				if(i<rows) format(string, sizeof(string), "%s%s (Delivered)\n", string, name);
					        else format(string, sizeof(string), "%s%s (Delivered)", string, name);
						}
						else
						{
		    				if(i<rows) format(string, sizeof(string), "%s%s (%d)\n", string, name, strval(quantity)-strval(delivered));
					    	else format(string, sizeof(string), "%s%s (%d)", string, name, strval(quantity)-strval(delivered));
						}
					}
					else
					{
					    new reason[27];
						switch(strval(status))
						{
						    case 0: format(reason, sizeof(reason), "{FF0000}No Payment");
						    case 1: format(reason, sizeof(reason), "{FF0000}Pending");
						    case 3: format(reason, sizeof(reason), "{00FF00}Shipped");
						    case 5:
							{
								ShowPlayerDialog(index, 0, DIALOG_STYLE_MSGBOX, "Shop Order Error", "This order has already been delivered", "OK", "");
								return 1;
							}
			    			case 7: format(reason, sizeof(reason), "{FF0000}Cancelled");
					    	case 8: format(reason, sizeof(reason), "{FF0000}Denied");
				   			case 9: format(reason, sizeof(reason), "{FF0000}Cancelled Reversal");
					    	case 10: format(reason, sizeof(reason), "{FF0000}Failed");
						    case 11: format(reason, sizeof(reason), "{00FF00}Refundend");
						    case 12: format(reason, sizeof(reason), "{FF0000}Reversed");
						    case 13: format(reason, sizeof(reason), "{FF0000}Chargeback");
				   			default: format(reason, sizeof(reason), "{FF0000}Unknown");
						}
						format(string, sizeof(string), "We are unable to process that order at this time,\nbecause the payment is currently marked as: %s", reason);
						ShowPlayerDialog(index, 0, DIALOG_STYLE_MSGBOX, "Shop Order Error", string, "OK", "");
	  					return 1;
					}
				}
			}
			else
			{
			    new email[256];
			    cache_get_field_content(0, "email", email, ShopPipeline);
			    SetPVarString(index, "ShopEmailVerify", email);
			    ShowPlayerDialog(index, DIALOG_SHOPORDEREMAIL, DIALOG_STYLE_INPUT, "Shop Order Error", "We were unable to link your order to your IP,\nfor further verification of your identity please input your shop e-mail address:", "Submit", "Cancel");
			    return 1;
			}
			ShowPlayerDialog(index, DIALOG_SHOPORDER2, DIALOG_STYLE_LIST, "Shop Order List", string, "Select", "Cancel");
		}
		else
		{
		    ShowPlayerDialog(index, 0, DIALOG_STYLE_MSGBOX, "Shop Order Error", "Error: No orders were found by that Order ID\nIf you are sure that is the correct Order ID, please try again or input '1' for your order ID.", "OK", "");
		}
	}
	return 1;
}

forward OnShopOrderEmailVer(index);
public OnShopOrderEmailVer(index)
{
	if(IsPlayerConnected(index))
	{
	    HideNoticeGUIFrame(index);
		new rows, fields;
		cache_get_data(rows, fields, ShopPipeline);
		if(rows > 0)
		{
		    new string[512];
		   	new status[2], name[64], quantity[8], delivered[8], product_id[8];
		    for(new i;i<rows;i++)
		    {
			    cache_get_field_content(i, "order_status_id", status, ShopPipeline);
				if(strval(status) == 2)
	   			{
					cache_get_field_content(i, "name", name, ShopPipeline);
	 				cache_get_field_content(i, "quantity", quantity, ShopPipeline);
		    		cache_get_field_content(i, "delivered", delivered, ShopPipeline);
	  				cache_get_field_content(i, "order_product_id", product_id, ShopPipeline);
		   			if(strval(quantity)-strval(delivered) <= 0)
				    {
	   					if(i<rows) format(string, sizeof(string), "%s%s (Delivered)\n", string, name);
	       				else format(string, sizeof(string), "%s%s (Delivered)", string, name);
					}
					else
					{
					    if(i<rows) format(string, sizeof(string), "%s%s (%d)\n", string, name, strval(quantity)-strval(delivered));
					    else format(string, sizeof(string), "%s%s (%d)", string, name, strval(quantity)-strval(delivered));
					}
				}
				else
				{
	    			new reason[27];
					switch(strval(status))
					{
	    				case 0: format(reason, sizeof(reason), "{FF0000}No Payment");
		   				case 1: format(reason, sizeof(reason), "{FF0000}Pending");
					    case 3: format(reason, sizeof(reason), "{00FF00}Shipped");
					    case 5:
						{
							ShowPlayerDialog(index, 0, DIALOG_STYLE_MSGBOX, "Shop Order Error", "This order has already been delivered", "OK", "");
							return 1;
						}
			   			case 7: format(reason, sizeof(reason), "{FF0000}Cancelled");
					    case 8: format(reason, sizeof(reason), "{FF0000}Denied");
					    case 9: format(reason, sizeof(reason), "{FF0000}Cancelled Reversal");
					    case 10: format(reason, sizeof(reason), "{FF0000}Failed");
			   			case 11: format(reason, sizeof(reason), "{00FF00}Refundend");
					    case 12: format(reason, sizeof(reason), "{FF0000}Reversed");
					    case 13: format(reason, sizeof(reason), "{FF0000}Chargeback");
					    default: format(reason, sizeof(reason), "{FF0000}Unknown");
					}
					format(string, sizeof(string), "We are unable to process that order at this time,\nbecause the payment is currently marked as: %s", reason);
					ShowPlayerDialog(index, 0, DIALOG_STYLE_MSGBOX, "Shop Order Error", string, "OK", "");
	 				return 1;
				}
			}
			ShowPlayerDialog(index, DIALOG_SHOPORDER2, DIALOG_STYLE_LIST, "Shop Order List", string, "Select", "Cancel");
		}
		else
		{
		    ShowPlayerDialog(index, 0, DIALOG_STYLE_MSGBOX, "Shop Order Error", "Error: No orders were found by that Order ID\nIf you are sure that is the correct Order ID, please try again or input '1' for your order ID.", "OK", "");
		}
	}
	return 1;
}

forward OnShopOrder2(index, extraid);
public OnShopOrder2(index, extraid)
{
	if(IsPlayerConnected(index))
	{
	    HideNoticeGUIFrame(index);
		new string[256];
		new rows, fields;
		cache_get_data(rows, fields, ShopPipeline);
		if(rows > 0)
		{
		    for(new i;i<rows;i++)
		    {
	  			if(i == extraid)
		    	{
	      			new status[2];
		        	cache_get_field_content(i, "status", status, ShopPipeline);
			        if(strval(status) == 2)
		        	{
			    		new order_id[8], order_product_id[8], product_id[8], name[64], price[8], user[32], quantity[8], delivered[8];
				    	cache_get_field_content(i, "order_id", order_id, ShopPipeline);
						cache_get_field_content(i, "order_product_id", order_product_id, ShopPipeline);
						cache_get_field_content(i, "product_id", product_id, ShopPipeline);
						cache_get_field_content(i, "name", name, ShopPipeline);
		  				cache_get_field_content(i, "price", price, ShopPipeline);
			  			cache_get_field_content(i, "deliveruser", user, ShopPipeline);
			  			cache_get_field_content(i, "quantity", quantity, ShopPipeline);
			  			cache_get_field_content(i, "delivered", delivered, ShopPipeline);

						format(string, sizeof(string), "Order ID: %d\nProduct ID: %d\nProduct: %s\nPrice: %s\nName: %s\nQuantity: %d", \
						strval(order_id), strval(order_product_id), name, price, user, strval(quantity)-strval(delivered));

						SetPVarInt(index, "DShop_order_id", strval(order_id));
						SetPVarInt(index, "DShop_product_id", strval(product_id));
						SetPVarString(index, "DShop_name", name);
						SetPVarInt(index, "DShop_quantity", strval(quantity)-strval(delivered));

						ShowPlayerDialog(index, DIALOG_SHOPDELIVER, DIALOG_STYLE_LIST, "Shop Order Info", string, "Deliver", "Cancel");
						return 1;
					}
					else
					{
						new reason[27];
						switch(strval(status))
						{
						    case 0: format(reason, sizeof(reason), "{FF0000}No Payment");
						    case 1: format(reason, sizeof(reason), "{FF0000}Pending");
						    case 3: format(reason, sizeof(reason), "{00FF00}Shipped");
						    case 5:
							{
								ShowPlayerDialog(index, 0, DIALOG_STYLE_MSGBOX, "Shop Order Error", "This order has already been delivered", "OK", "");
								return 1;
							}
				   			case 7: format(reason, sizeof(reason), "{FF0000}Cancelled");
						    case 8: format(reason, sizeof(reason), "{FF0000}Denied");
						    case 9: format(reason, sizeof(reason), "{FF0000}Cancelled Reversal");
						    case 10: format(reason, sizeof(reason), "{FF0000}Failed");
						    case 11: format(reason, sizeof(reason), "{00FF00}Refundend");
						    case 12: format(reason, sizeof(reason), "{FF0000}Reversed");
						    case 13: format(reason, sizeof(reason), "{FF0000}Chargeback");
						    default: format(reason, sizeof(reason), "{FF0000}Unknown");
						}
						format(string, sizeof(string), "We are unable to process that order at this time,\nbecause the payment is currently marked as: %s", reason);
						ShowPlayerDialog(index, 0, DIALOG_STYLE_MSGBOX, "Shop Order Error", string, "OK", "");
	  					return 1;
					}
				}
			}
		}
		else
		{
		    ShowPlayerDialog(index, 0, DIALOG_STYLE_MSGBOX, "Shop Order Error", "Error: No orders were found by that Order ID\nIf you are sure that is the correct Order ID, please try again or input '1' for your order ID.", "OK", "");
		}
	}
	return 1;
}
#endif*/

forward OnSetMyName(index);
public OnSetMyName(index)
{
	if(IsPlayerConnected(index))
	{
		new rows, fields;
		cache_get_data(rows, fields, MainPipeline);
		if(!rows)
		{
			new string[128], tmpName[24];
			GetPVarString(index, "OnSetMyName", tmpName, 24);

			new name[MAX_PLAYER_NAME];
			GetPlayerName(index, name, sizeof(name));
			SetPVarString(index, "TempNameName", name);
			if(strlen(tmpName) > 0)
			{
				SetPlayerName(index, tmpName);
				format(string, sizeof(string), "%s da thay doi ten cua ho thanh %s.", name, tmpName);
				Log("logs/undercover.log", string);
				DeletePVar(index, "OnSetMyName");

				format(string, sizeof(string), "Ban tam thoi doi ten cua ban thanh %s.", tmpName);
				SendClientMessageEx(index, COLOR_YELLOW, string);
				SendClientMessageEx(index, COLOR_GRAD2, "NOTE: None of your stats will save until you type this command again.");
				SetPVarInt(index, "TempName", 1);
			}
		}
		else
		{
			SendClientMessageEx(index, COLOR_WHITE, "Ten nay da duoc dang ky.");
		}
	}
	else
	{
		DeletePVar(index, "OnSetMyName");
	}
	return 1;
}

forward OnSetName(index, extraid);
public OnSetName(index, extraid)
{
	if(IsPlayerConnected(index))
	{
		if(IsPlayerConnected(extraid))
		{
		    new rows, fields;
			cache_get_data(rows, fields, MainPipeline);
			if(rows < 1)
			{
				new string[128], tmpName[24], playername[24];
				GetPVarString(index, "OnSetName", tmpName, 24);

				GetPlayerName(extraid, playername, sizeof(playername));

				UpdateCitizenApp(extraid, PlayerInfo[extraid][pNation]);

				if(PlayerInfo[extraid][pMarriedID] != -1)
				{
					foreach(new i: Player)
					{
						if(PlayerInfo[extraid][pMarriedID] == GetPlayerSQLId(i)) format(PlayerInfo[i][pMarriedName], MAX_PLAYER_NAME, "%s", tmpName);
					}
				}

				for(new i; i < MAX_DDOORS; i++)
				{
					if(DDoorsInfo[i][ddType] == 1 && DDoorsInfo[i][ddOwner] == GetPlayerSQLId(extraid))
					{
						strcat((DDoorsInfo[i][ddOwnerName][0] = 0, DDoorsInfo[i][ddOwnerName]), tmpName, 42);
						DestroyDynamicPickup(DDoorsInfo[i][ddPickupID]);
						if(IsValidDynamic3DTextLabel(DDoorsInfo[i][ddTextID])) DestroyDynamic3DTextLabel(DDoorsInfo[i][ddTextID]);
						CreateDynamicDoor(i);
						SaveDynamicDoor(i);
					}
				}

				if(Homes[extraid] > 0)
				{
					for(new i; i < MAX_HOUSES; i++)
					{
						if(GetPlayerSQLId(extraid) == HouseInfo[i][hOwnerID])
						{
							format(HouseInfo[i][hOwnerName], MAX_PLAYER_NAME, "%s", tmpName);
							SaveHouse(i);
							ReloadHouseText(i);
						}
					}
				}

				if(PlayerInfo[extraid][pDonateRank] >= 1)
				{
					new string2[128];
					format(string2, sizeof(string2), "[VIP NAMECHANGES] %s da thay doi ten cua ho thanh %s.", GetPlayerNameEx(extraid), tmpName);
					Log("logs/vipnamechanges.log", string2);
				}

				if(strlen(tmpName) > 0)
				{
				    new admindoiten[200];
					format(string, sizeof(string), " Ten cua ban da duoc thay doi tu %s thanh %s.", GetPlayerNameEx(extraid), tmpName);
					SendClientMessageEx(extraid,COLOR_YELLOW,string);
					format(string, sizeof(string), " Ban da thay doi ten %s's thanh %s.", GetPlayerNameEx(extraid), tmpName);
					SendClientMessageEx(index,COLOR_YELLOW,string);
					format(admindoiten, sizeof(admindoiten), "{AA3333}AdmWarnings{FFFF00}: %s Vua Doi Ten %s Thanh %s", GetPlayerNameEx(index), GetPlayerNameEx(extraid), tmpName);
					ABroadCast(COLOR_YELLOW, admindoiten, 2);
					format(string, sizeof(string), "%s changed %s's name to %s",GetPlayerNameEx(index),GetPlayerNameExt(extraid),tmpName);
					Log("logs/stats.log", string);
					if(SetPlayerName(extraid, tmpName) == 1)
					{
    					format(string, sizeof(string), "UPDATE `accounts` SET `Username`='%s' WHERE `Username`='%s'", tmpName, playername);
						mysql_function_query(MainPipeline, string, true, "OnSetNameTwo", "ii", index, extraid);
					}
					else
					{
					    SendClientMessage(extraid, COLOR_REALRED, "Da co loi say ra cho viec doi ten cua ban.");
					    format(string, sizeof(string), "%s's Thay doi ten that bai do ten khong hop le.", GetPlayerNameExt(extraid));
					    SendClientMessage(extraid, COLOR_REALRED, string);
					    format(string, sizeof(string), "Loi thay doi ten %s's thanh %s", GetPlayerNameExt(extraid), tmpName);
					    Log("logs/stats.log", string);
					    return 1;
					}
					OnPlayerStatsUpdate(extraid);
				}
			}
		}
	}
	DeletePVar(index, "OnSetName");
	return 1;
}

forward OnSetNameTwo(index, extraid);
public OnSetNameTwo(index, extraid)
{
	return 1;
}

forward OnApproveName(index, extraid);
public OnApproveName(index, extraid)
{
	if(IsPlayerConnected(extraid))
	{
		new string[128];
		new rows, fields;
		cache_get_data(rows, fields, MainPipeline);
		if(rows < 1)
		{
			new newname[24], oldname[24];
			GetPVarString(extraid, "NewNameRequest", newname, 24);
			GetPlayerName(extraid, oldname, sizeof(oldname));

			UpdateCitizenApp(extraid, PlayerInfo[extraid][pNation]);

			if(PlayerInfo[extraid][pMarriedID] != -1)
			{
				foreach(new i: Player)
				{
					if(PlayerInfo[extraid][pMarriedID] == GetPlayerSQLId(i)) format(PlayerInfo[i][pMarriedName], MAX_PLAYER_NAME, "%s", newname);
				}
			}

			for(new i; i < MAX_DDOORS; i++)
			{
				if(DDoorsInfo[i][ddType] == 1 && DDoorsInfo[i][ddOwner] == GetPlayerSQLId(extraid))
				{
					strcat((DDoorsInfo[i][ddOwnerName][0] = 0, DDoorsInfo[i][ddOwnerName]), newname, 42);
					DestroyDynamicPickup(DDoorsInfo[i][ddPickupID]);
					if(IsValidDynamic3DTextLabel(DDoorsInfo[i][ddTextID])) DestroyDynamic3DTextLabel(DDoorsInfo[i][ddTextID]);
					CreateDynamicDoor(i);
					SaveDynamicDoor(i);
				}
			}

			if(Homes[extraid] > 0)
			{
				for(new i; i < MAX_HOUSES; i++)
				{
					if(GetPlayerSQLId(extraid) == HouseInfo[i][hOwnerID])
					{
						format(HouseInfo[i][hOwnerName], MAX_PLAYER_NAME, "%s", newname);
						SaveHouse(i);
						ReloadHouseText(i);
					}
				}
			}

			if(PlayerInfo[extraid][pBusiness] != INVALID_BUSINESS_ID && Businesses[PlayerInfo[extraid][pBusiness]][bOwner] == GetPlayerSQLId(extraid))
			{
			    strcpy(Businesses[PlayerInfo[extraid][pBusiness]][bOwnerName], newname, MAX_PLAYER_NAME);
			    SaveBusiness(PlayerInfo[extraid][pBusiness]);
				RefreshBusinessPickup(PlayerInfo[extraid][pBusiness]);
			}

			if(PlayerInfo[extraid][pDonateRank] >= 1)
			{
				format(string, sizeof(string), "[VIP NAMECHANGES] %s da thay doi ten cua ho thanh %s.", GetPlayerNameEx(extraid), newname);
				Log("logs/vipnamechanges.log", string);
			}

			if((0 <= PlayerInfo[extraid][pMember] < MAX_GROUPS) && PlayerInfo[extraid][pRank] >= arrGroupData[PlayerInfo[extraid][pMember]][g_iFreeNameChange])
			{
				if(strlen(newname) > 0)
				{
					format(string, sizeof(string), " Ten cua ban da duoc thay doi tu %s thanh %s for free.", GetPlayerNameEx(extraid), newname);
					SendClientMessageEx(extraid,COLOR_YELLOW,string);
					format(string, sizeof(string), " Ban da thay doi ten %s's thanh %s at no cost.", GetPlayerNameEx(extraid), newname);
					SendClientMessageEx(index,COLOR_YELLOW,string);
					format(string, sizeof(string), "%s thay doi ten \"%s\"s thanh \"%s\" (id: %i)  for free.",GetPlayerNameEx(index),GetPlayerNameEx(extraid),newname, GetPlayerSQLId(extraid));
					Log("logs/stats.log", string);
					format(string, sizeof(string), "%s da chap nhan thay doi ten %s's thanh %s at no cost.",GetPlayerNameEx(index),GetPlayerNameEx(extraid), newname);
					ABroadCast(COLOR_YELLOW, string, 3);


					if(SetPlayerName(extraid, newname) == 1)
					{
    					format(string, sizeof(string), "UPDATE `accounts` SET `Username`='%s' WHERE `Username`='%s'", newname, oldname);
						mysql_function_query(MainPipeline, string, true, "OnApproveSetName", "ii", index, extraid);
					}
					else
					{
					    SendClientMessage(extraid, COLOR_REALRED, "Da co loi say ra cho viec doi ten cua ban.");
					    format(string, sizeof(string), "%s's Thay doi ten that bai do ten khong hop le.", GetPlayerNameExt(extraid));
					    SendClientMessage(index, COLOR_REALRED, string);
					    format(string, sizeof(string), "Loi thay doi ten %s's thanh %s", GetPlayerNameExt(extraid), newname);
					    Log("logs/stats.log", string);
					    return 1;
					}
					DeletePVar(extraid, "RequestingNameChange");
				}
			}

			else if(PlayerInfo[extraid][pAdmin] == 1 && PlayerInfo[extraid][pSMod] > 0)
			{
				if(strlen(newname) > 0)
				{
					format(string, sizeof(string), " Ten cua ban da duoc thay doi tu %s thanh %s mien phi (Senior Mod).", GetPlayerNameEx(extraid), newname);
					SendClientMessageEx(extraid,COLOR_YELLOW,string);
					format(string, sizeof(string), " Ban da thay doi ten %s's thanh %s mien phi.", GetPlayerNameEx(extraid), newname);
					SendClientMessageEx(index,COLOR_YELLOW,string);
					format(string, sizeof(string), "%s thay doi ten \"%s\"s thanh \"%s\" (id: %i) mien phi (Senior Mod).",GetPlayerNameEx(index),GetPlayerNameEx(extraid),newname, GetPlayerSQLId(extraid));
					Log("logs/stats.log", string);
					format(string, sizeof(string), "%s da chap nhan thay doi ten %s's thanh %s mien phi (Senior Mod).",GetPlayerNameEx(index),GetPlayerNameEx(extraid), newname);
					ABroadCast(COLOR_YELLOW, string, 3);

					if(SetPlayerName(extraid, newname) == 1)
					{
    					format(string, sizeof(string), "UPDATE `accounts` SET `Username`='%s' WHERE `Username`='%s'", newname, oldname);
						mysql_function_query(MainPipeline, string, true, "OnApproveSetName", "ii", index, extraid);
					}
					else
					{
					    SendClientMessage(extraid, COLOR_REALRED, "Da co loi say ra cho viec doi ten cua ban.");
					    format(string, sizeof(string), "%s's Thay doi ten that bai do ten khong hop le.", GetPlayerNameExt(extraid));
					    SendClientMessage(index, COLOR_REALRED, string);
					    format(string, sizeof(string), "Loi thay doi ten %s's thanh %s", GetPlayerNameExt(extraid), newname);
					    Log("logs/stats.log", string);
					    return 1;
					}
					DeletePVar(extraid, "RequestingNameChange");
				}
			}

			else
			{
				if(GetPVarInt(extraid, "NameChangeCost") == 0)
				{
					if(strlen(newname) > 0)
					{
						format(string, sizeof(string), " Ten cua ban da duoc thay doi tu %s thanh %s mien phi (non-RP name).", GetPlayerNameEx(extraid), newname);
						SendClientMessageEx(extraid,COLOR_YELLOW,string);
						format(string, sizeof(string), " Ban da thay doi ten %s's thanh %s mien phi (non-RP name).", GetPlayerNameEx(extraid), newname);
						SendClientMessageEx(index,COLOR_YELLOW,string);
						format(string, sizeof(string), "%s thay doi ten \"%s\"s thanh \"%s\" (id: %i) mien phi (non-RP name).",GetPlayerNameEx(index),GetPlayerNameEx(extraid),newname, GetPlayerSQLId(extraid));
						Log("logs/stats.log", string);
						format(string, sizeof(string), "%s da phe duyet doi ten %s's thanh %s mien phi (non-RP name).",GetPlayerNameEx(index),GetPlayerNameEx(extraid), newname);
						ABroadCast(COLOR_YELLOW, string, 3);

						if(SetPlayerName(extraid, newname) == 1)
						{
	    					format(string, sizeof(string), "UPDATE `accounts` SET `Username`='%s' WHERE `Username`='%s'", newname, oldname);
							mysql_function_query(MainPipeline, string, true, "OnApproveSetName", "ii", index, extraid);
						}
						else
						{
						    SendClientMessage(extraid, COLOR_REALRED, "Da co loi say ra cho viec doi ten cua ban.");
						    format(string, sizeof(string), "%s's thay doi ten that bai do ten khong hop le.", GetPlayerNameExt(extraid));
						    SendClientMessage(index, COLOR_REALRED, string);
						    format(string, sizeof(string), "Loi thay doi ten %s'sthanh %s", GetPlayerNameExt(extraid), newname);
						    Log("logs/stats.log", string);
						    return 1;
						}
						DeletePVar(extraid, "RequestingNameChange");
					}
				}
				else
				{
					if(strlen(newname) > 0)
					{
						GivePlayerMoneyEx(extraid, -GetPVarInt(extraid, "NameChangeCost"));
						format(string, sizeof(string), " Ten cua ban da duoc thay doi %s thanh %s voi gia $%d.", GetPlayerNameEx(extraid), newname, GetPVarInt(extraid, "NameChangeCost"));
						SendClientMessageEx(extraid,COLOR_YELLOW,string);
						format(string, sizeof(string), " Ban da thay doi ten %s's thanh %s voi gia $%d.", GetPlayerNameEx(extraid), newname, GetPVarInt(extraid, "NameChangeCost"));
						SendClientMessageEx(index,COLOR_YELLOW,string);
						format(string, sizeof(string), "%s thay doi ten \"%s\"s thanh \"%s\" (id: %i) voi gia $%d",GetPlayerNameEx(index),GetPlayerNameEx(extraid),newname, GetPlayerSQLId(extraid), GetPVarInt(extraid, "NameChangeCost"));
						Log("logs/stats.log", string);
						format(string, sizeof(string), "%s da phe duyet doi ten %s's thanh %s voi gia $%d",GetPlayerNameEx(index),GetPlayerNameEx(extraid), newname, GetPVarInt(extraid, "NameChangeCost"));
						ABroadCast(COLOR_YELLOW, string, 3);

						if(SetPlayerName(extraid, newname) == 1)
						{
	    					format(string, sizeof(string), "UPDATE `accounts` SET `Username`='%s' WHERE `Username`='%s'", newname, oldname);
							mysql_function_query(MainPipeline, string, true, "OnApproveSetName", "ii", index, extraid);
						}
						else
						{
						    SendClientMessage(extraid, COLOR_REALRED, "Da co loi say ra cho viec doi ten cua ban.");
						    format(string, sizeof(string), "%s's thay doi ten that bai do ten khong hop le.", GetPlayerNameExt(extraid));
						    SendClientMessage(index, COLOR_REALRED, string);
						    format(string, sizeof(string), "Loi thay doi ten %s's thanh %s", GetPlayerNameExt(extraid), newname);
						    Log("logs/stats.log", string);
						    return 1;
						}

						DeletePVar(extraid, "RequestingNameChange");
					}
				}
			}
		}
		else
		{
			SendClientMessageEx(extraid, COLOR_GRAD2, "Ten do da ton tai, vui long dat ten khac.");
			SendClientMessageEx(index, COLOR_GRAD2, "Ten do da ton tai.");
			DeletePVar(extraid, "RequestingNameChange");
			return 1;
		}
	}
	return 1;
}

forward OnIPWhitelist(index);
public OnIPWhitelist(index)
{
	new string[128], name[24];
	GetPVarString(index, "OnIPWhitelist", name, 24);

	if(mysql_affected_rows(MainPipeline)) {
		format(string, sizeof(string), "You have successfully whitelisted %s's account.", name);
		SendClientMessageEx(index, COLOR_WHITE, string);
		format(string, sizeof(string), "%s has IP Whitelisted %s", GetPlayerNameEx(index), name);
		Log("logs/whitelist.log", string);
	}
	else {
		format(string, sizeof(string), "There was a issue with whitelisting %s's account.", name);
		SendClientMessageEx(index, COLOR_WHITE, string);
	}
	DeletePVar(index, "OnIPWhitelist");

	return 1;
}

forward OnIPCheck(index);
public OnIPCheck(index)
{
	if(IsPlayerConnected(index))
	{
		new string[128], ip[16], name[24];
		new rows, fields;
		cache_get_data(rows, fields, MainPipeline);
		if(rows)
		{
   			cache_get_field_content(0, "IP", ip, MainPipeline, 16);
   			cache_get_field_content(0, "Username", name, MainPipeline, MAX_PLAYER_NAME);
			format(string, sizeof(string), "%s's IP: %s", name, ip);
			SendClientMessageEx(index, COLOR_WHITE, string);
			format(string, sizeof(string), "%s has IP Checked %s", GetPlayerNameEx(index), name);
			Log("logs/ipcheck.log", string);
		}
		else
		{
			SendClientMessageEx(index, COLOR_WHITE, "There was an issue with checking the account's IP.");
		}
	}
	return 1;
}

forward OnProcessOrderCheck(index, extraid);
public OnProcessOrderCheck(index, extraid)
{
	if(IsPlayerConnected(index))
	{
		new string[164],playerip[32], giveplayerip[32];
		GetPlayerIp(index, playerip, sizeof(playerip));
		GetPlayerIp(extraid, giveplayerip, sizeof(giveplayerip));

		new rows, fields;
		cache_get_data(rows, fields, MainPipeline);
		if(rows)
		{
			SendClientMessageEx(index, COLOR_WHITE, "This order has previously been processed, therefore it did not count toward your pay.");
			format(string, sizeof(string), "%s(IP: %s) has processed shop order ID %d from %s(IP: %s).", GetPlayerNameEx(index), playerip, GetPVarInt(index, "processorder"), GetPlayerNameEx(extraid), giveplayerip);
			Log("logs/shoporders.log", string);
		}
		else
		{
			format(string, sizeof(string), "%s(IP: %s) has processed shop order ID %d from %s(IP: %s).", GetPlayerNameEx(index), playerip, GetPVarInt(index, "processorder"), GetPlayerNameEx(extraid), giveplayerip);
			Log("logs/shopconfirmedorders.log", string);
			PlayerInfo[index][pShopTechOrders]++;

			format(string, sizeof(string), "INSERT INTO shoptech (id,total,dtotal) VALUES (%d,1,%f) ON DUPLICATE KEY UPDATE total = total + 1, dtotal = dtotal + %f", GetPlayerSQLId(index), ShopTechPay, ShopTechPay);
			mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "ii", SENDDATA_THREAD, index);

			format(string, sizeof(string), "INSERT INTO `orders` (`id`) VALUES ('%d')", GetPVarInt(index, "processorder"));
			mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "ii", SENDDATA_THREAD, index);
		}
		DeletePVar(index, "processorder");
	}
	return 1;
}

forward OnFine(index);
public OnFine(index)
{
	new string[128], name[24], amount, reason[64];
	GetPVarString(index, "OnFine", name, 24);
	amount = GetPVarInt(index, "OnFineAmount");
	GetPVarString(index, "OnFineReason", reason, 64);

	if(mysql_affected_rows(MainPipeline)) {
		format(string, sizeof(string), "You have successfully fined %s's account.", name);
		SendClientMessageEx(index, COLOR_WHITE, string);

		format(string, sizeof(string), "AdmCmd: %s was offline fined $%d by %s, reason: %s", name, amount, GetPlayerNameEx(index), reason);
		Log("logs/admin.log", string);
	}
	else {
		format(string, sizeof(string), "There was an issue with fining %s's account.", name);
		SendClientMessageEx(index, COLOR_WHITE, string);
	}
	DeletePVar(index, "OnFine");
	DeletePVar(index, "OnFineAmount");
	DeletePVar(index, "OnFineReason");

	return 1;
}

forward OnSetDDOwner(playerid, doorid);
public OnSetDDOwner(playerid, doorid)
{
	if(IsPlayerConnected(playerid))
	{
	    new rows, fields;
	    new string[128], sqlid[5], playername[MAX_PLAYER_NAME], id;
    	cache_get_data(rows, fields, MainPipeline);

    	if(rows)
    	{
			cache_get_field_content(0, "id", sqlid, MainPipeline); id = strval(sqlid);
			cache_get_field_content(0, "Username", playername, MainPipeline, MAX_PLAYER_NAME);
			strcat((DDoorsInfo[doorid][ddOwnerName][0] = 0, DDoorsInfo[doorid][ddOwnerName]), playername, MAX_PLAYER_NAME);
			DDoorsInfo[doorid][ddOwner] = id;

			format(string, sizeof(string), "Successfully set the owner to %s.", playername);
			SendClientMessageEx(playerid, COLOR_WHITE, string);

			DestroyDynamicPickup(DDoorsInfo[doorid][ddPickupID]);
			if(IsValidDynamic3DTextLabel(DDoorsInfo[doorid][ddTextID])) DestroyDynamic3DTextLabel(DDoorsInfo[doorid][ddTextID]);
			CreateDynamicDoor(doorid);
			SaveDynamicDoor(doorid);
			format(string, sizeof(string), "%s da chinh sua door ID %d's owner to %s (SQL ID: %d).", GetPlayerNameEx(playerid), doorid, playername, id);
			Log("logs/ddedit.log", string);
		}
		else SendClientMessageEx(playerid, COLOR_GREY, "Tai khoan do khong ton tai.");
	}
	return 1;
}

forward OnPrisonAccount(index);
public OnPrisonAccount(index)
{
	new string[128], name[24], reason[64];
	GetPVarString(index, "OnPrisonAccount", name, 24);
	GetPVarString(index, "OnPrisonAccountReason", reason, 64);

	if(mysql_affected_rows(MainPipeline)) {
		format(string, sizeof(string), "You have successfully prisoned %s's account.", name);
		SendClientMessageEx(index, COLOR_WHITE, string);

		format(string, sizeof(string), "AdmCmd: %s da bi giam giu offline boi %s, ly do: %s ", name, GetPlayerNameEx(index), reason);
		Log("logs/admin.log", string);
	}
	else {
		format(string, sizeof(string), "Da co mot van de say ra voi bo tu %s's.");
		SendClientMessageEx(index, COLOR_WHITE, string);
	}
	DeletePVar(index, "OnPrisonAccount");
	DeletePVar(index, "OnPrisonAccountReason");

	return 1;
}

forward OnJailAccount(index);
public OnJailAccount(index)
{
	new string[128], name[24], reason[64];
	GetPVarString(index, "OnJailAccount", name, 24);
	GetPVarString(index, "OnJailAccountReason", reason, 64);

	if(mysql_affected_rows(MainPipeline)) {
		format(string, sizeof(string), "Ban da bo tu thanh cong nguoi choi %s's .", name);
		SendClientMessageEx(index, COLOR_WHITE, string);

		format(string, sizeof(string), "AdmCmd: %s da bi bo tu offline boi %s, ly do: %s", name, GetPlayerNameEx(index), reason);
		Log("logs/admin.log", string);
	}
	else {
		format(string, sizeof(string), "Da co mot van de say ra khi bo tu %s's.", name);
		SendClientMessageEx(index, COLOR_WHITE, string);
	}

	DeletePVar(index, "OnJailAccount");
	DeletePVar(index, "OnJailAccountReason");

	return 1;
}

forward OnGetLatestKills(playerid, giveplayerid);
public OnGetLatestKills(playerid, giveplayerid)
{
    new string[128], killername[MAX_PLAYER_NAME], killedname[MAX_PLAYER_NAME], kDate[20], weapon[56], rows, fields;
	cache_get_data(rows, fields, MainPipeline);
	if(rows)
	{
		for(new i; i < rows; i++)
		{
			cache_get_row(i, 0, killername, MainPipeline, MAX_PLAYER_NAME);
			cache_get_row(i, 1, killedname, MainPipeline, MAX_PLAYER_NAME);
			cache_get_field_content(i, "killerid", string, MainPipeline); new killer = strval(string);
			cache_get_field_content(i, "killedid", string, MainPipeline); new killed = strval(string);
			cache_get_field_content(i, "date", kDate, MainPipeline, sizeof(kDate));
			cache_get_field_content(i, "weapon", weapon, MainPipeline, sizeof(weapon));
			if(GetPlayerSQLId(giveplayerid) == killer && GetPlayerSQLId(giveplayerid) == killed) format(string, sizeof(string), "[%s] %s killed themselves (%s)", kDate, StripUnderscore(killedname), weapon);
			else if(GetPlayerSQLId(giveplayerid) == killer && GetPlayerSQLId(giveplayerid) != killed) format(string, sizeof(string), "[%s] %s killed %s with %s", kDate, StripUnderscore(killername), StripUnderscore(killedname), weapon);
			else if(GetPlayerSQLId(giveplayerid) != killer && GetPlayerSQLId(giveplayerid) == killed) format(string, sizeof(string), "[%s] %s was killed by %s with %s", kDate, StripUnderscore(killedname), StripUnderscore(killername), weapon);
			SendClientMessageEx(playerid, COLOR_YELLOW, string);
		}
	}
	else SendClientMessageEx(playerid, COLOR_YELLOW, "No kills recorded on this player.");
	return 1;
}

forward OnGetOKills(playerid);
public OnGetOKills(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		new string[256], giveplayername[MAX_PLAYER_NAME], giveplayerid;

		new rows, fields;
		cache_get_data(rows, fields, MainPipeline);

		if(rows)
		{
			cache_get_field_content(0, "id", string, MainPipeline); giveplayerid = strval(string);
			cache_get_field_content(0, "Username", giveplayername, MainPipeline, MAX_PLAYER_NAME);
			format(string, sizeof(string), "SELECT Killer.Username, Killed.Username, k.* FROM Kills k LEFT JOIN accounts Killed ON k.killedid = Killed.id LEFT JOIN accounts Killer ON Killer.id = k.killerid WHERE k.killerid = %d OR k.killedid = %d ORDER BY `date` DESC LIMIT 10", giveplayerid, giveplayerid);
			mysql_function_query(MainPipeline, string, true, "OnGetLatestOKills", "iis", playerid, giveplayerid, giveplayername);
		}
		else return SendClientMessageEx(playerid, COLOR_GREY, "This account does not exist.");
	}
	return 1;
}

forward OnGetLatestOKills(playerid, giveplayerid, giveplayername[]);
public OnGetLatestOKills(playerid, giveplayerid, giveplayername[])
{
    new string[128], killername[MAX_PLAYER_NAME], killedname[MAX_PLAYER_NAME], kDate[20], weapon[56], rows, fields;
	cache_get_data(rows, fields, MainPipeline);
	if(rows)
	{
		SendClientMessageEx(playerid, COLOR_GREEN, "________________________________________________");
		format(string, sizeof(string), "<< Last 10 Kills/Deaths of %s >>", StripUnderscore(giveplayername));
		SendClientMessageEx(playerid, COLOR_YELLOW, string);
		for(new i; i < rows; i++)
		{
			cache_get_row(i, 0, killername, MainPipeline, MAX_PLAYER_NAME);
			cache_get_row(i, 1, killedname, MainPipeline, MAX_PLAYER_NAME);
			cache_get_field_content(i, "killerid", string, MainPipeline); new killer = strval(string);
			cache_get_field_content(i, "killedid", string, MainPipeline); new killed = strval(string);
			cache_get_field_content(i, "date", kDate, MainPipeline, sizeof(kDate));
			cache_get_field_content(i, "weapon", weapon, MainPipeline, sizeof(weapon));
			if(giveplayerid == killer && giveplayerid == killed) format(string, sizeof(string), "[%s] %s killed themselves (%s)", kDate, StripUnderscore(killedname), weapon);
			else if(giveplayerid == killer && giveplayerid != killed) format(string, sizeof(string), "[%s] %s killed %s with %s", kDate, StripUnderscore(killername), StripUnderscore(killedname), weapon);
			else if(giveplayerid != killer && giveplayerid == killed) format(string, sizeof(string), "[%s] %s was killed by %s with %s", kDate, StripUnderscore(killedname), StripUnderscore(killername), weapon);
			SendClientMessageEx(playerid, COLOR_YELLOW, string);
		}
	}
	else return SendClientMessageEx(playerid, COLOR_YELLOW, "No kills recorded on this player.");
	return 1;
}

forward OnDMStrikeReset(playerid, giveplayerid);
public OnDMStrikeReset(playerid, giveplayerid)
{
	new string[128];
	format(string, sizeof(string), "Deleted %d strikes against %s", mysql_affected_rows(MainPipeline), GetPlayerNameEx(giveplayerid));
	SendClientMessage(playerid, COLOR_WHITE, string);
	return 1;
}

forward OnDMRLookup(playerid, giveplayerid);
public OnDMRLookup(playerid, giveplayerid)
{
	new string[128], rows, fields;
	cache_get_data(rows, fields, MainPipeline);
	format(string, sizeof(string), "Hien thi cuoi cung %d /dmreports boi %s", rows, GetPlayerNameEx(giveplayerid));
	SendClientMessage(playerid, COLOR_WHITE, string);
	SendClientMessage(playerid, COLOR_WHITE, "| Reported | Time |");
	for(new i;i < rows;i++)
	{
 		new szResult[32], name[MAX_PLAYER_NAME], timestamp;
		cache_get_row(i, 0, szResult, MainPipeline); timestamp = strval(szResult);
		cache_get_row(i, 1, name, MainPipeline, MAX_PLAYER_NAME);
		format(string, sizeof(string), "%s - %s", name, date(timestamp, 1));
		SendClientMessage(playerid, COLOR_WHITE, string);
	}
	return 1;
}

forward OnDMTokenLookup(playerid, giveplayerid);
public OnDMTokenLookup(playerid, giveplayerid)
{
	new string[128], rows, fields;
	cache_get_data(rows, fields, MainPipeline);
	format(string, sizeof(string), "Hien thi %d hoat dong /dmreports tren %s", rows, GetPlayerNameEx(giveplayerid));
	SendClientMessage(playerid, COLOR_WHITE, string);
	SendClientMessage(playerid, COLOR_WHITE, "| Reporter | Time |");
	for(new i;i < rows;i++)
	{
 		new szResult[32], name[MAX_PLAYER_NAME], timestamp;
		cache_get_row(i, 0, szResult, MainPipeline); timestamp = strval(szResult);
		cache_get_row(i, 1, name, MainPipeline);
		format(string, sizeof(string), "%s - %s", name, date(timestamp, 1));
		SendClientMessage(playerid, COLOR_WHITE, string);
	}
	return 1;
}

forward OnDMWatchListLookup(playerid);
public OnDMWatchListLookup(playerid)
{
	new string[128], rows, fields;
	cache_get_data(rows, fields, MainPipeline);
	format(string, sizeof(string), "Hien thi %d nguoi hoat dong de xem", rows);
	SendClientMessage(playerid, COLOR_WHITE, string);
	for(new i;i < rows;i++)
	{
 		new name[MAX_PLAYER_NAME], watchid;
		cache_get_row(i, 0, name, MainPipeline);
		sscanf(name, "u", watchid);
		format(string, sizeof(string), "(ID: %d) %s", watchid, name);
		SendClientMessage(playerid, COLOR_WHITE, string);
	}
	return 1;
}

forward OnDMWatch(playerid);
public OnDMWatch(playerid)
{
	new rows, fields;
    cache_get_data(rows, fields, MainPipeline);
    if(rows)
    {
		new string[128], namesql[MAX_PLAYER_NAME], name[MAX_PLAYER_NAME];
		cache_get_row(0, 0, namesql, MainPipeline);
		foreach(new i: Player)
		{
			if(!PlayerInfo[i][pJailTime])
			{
			    GetPlayerName(i, name, sizeof(name));
				if(strcmp(name, namesql, true) == 0)
				{
				    foreach(new x: Player)
				    {
				        if(GetPVarInt(x, "pWatchdogWatching") == i)
				        {
				            return SendClientMessage(playerid, COLOR_WHITE, "Nguoi ngau nhien do ban chon da bi theo doi, vui long thu lai!");
				        }
				    }
				    format(string, sizeof(string), "Bay gio ban co the /spec %s (ID: %i). Su dung /dmalert neu nguoi nay deathmatches.", name, i);
				    SendClientMessage(playerid, COLOR_WHITE, string);
				    return SetPVarInt(playerid, "pWatchdogWatching", i);
				}
			}
		}
	}
	return SendClientMessageEx(playerid, COLOR_WHITE, "There is no one online to DM Watch!");
}

forward OnWarnPlayer(index);
public OnWarnPlayer(index)
{
	new string[128], name[24], reason[64];
	GetPVarString(index, "OnWarnPlayer", name, 24);
	GetPVarString(index, "OnWarnPlayerReason", reason, 64);

	if(mysql_affected_rows(MainPipeline)) {
		format(string, sizeof(string), "You have successfully warned %s's account.", name);
		SendClientMessageEx(index, COLOR_WHITE, string);

		format(string, sizeof(string), "AdmCmd: %s was offline warned by %s, reason: %s", name, GetPlayerNameEx(index), reason);
		Log("logs/admin.log", string);
	}
	else {
		format(string, sizeof(string), "There was an issue with warning %s's account.", name);
		SendClientMessageEx(index, COLOR_WHITE, string);
	}
	DeletePVar(index, "OnWarnPlayer");
	DeletePVar(index, "OnWarnPlayerReason");

	return 1;
}

forward OnPinCheck2(index);
public OnPinCheck2(index)
{
	if(IsPlayerConnected(index))
	{
		new rows, fields;
		cache_get_data(rows, fields, MainPipeline);
		if(rows)
		{
		    new Pin[256];
   			cache_get_field_content(0, "Pin", Pin, MainPipeline, 256);
   			if(isnull(Pin)) {
   			    ShowPlayerDialog(index, DIALOG_CREATEPIN, DIALOG_STYLE_INPUT, "Mat khau cap 2", "Tao mat khau cap 2 de bao ve Credits cua ban.", "Khoi tao", "Thoat");
   			}
   			else
   			{
   			    new passbuffer[256], passbuffer2[64];
            	GetPVarString(index, "PinNumber", passbuffer2, sizeof(passbuffer2));
				WP_Hash(passbuffer, sizeof(passbuffer), passbuffer2);
				if (strcmp(passbuffer, Pin) == 0)
				{
				    SetPVarInt(index, "PinConfirmed", 1);
					SendClientMessageEx(index, COLOR_CYAN, "Mat khau cap 2 xac nhan, bay gio ban co the su dung Credits.");
					switch(GetPVarInt(index, "OpenShop"))
					{
	    				case 1:
						{
							new szDialog[512];
						 	format(szDialog, sizeof(szDialog), "Poker Table (Credits: {FFD700}%s{A9C4E4})\nBoombox (Credits: {FFD700}%s{A9C4E4})\n100 Paintball Tokens (Credits: {FFD700}%s{A9C4E4})\nEXP Token (Credits: {FFD700}%s{A9C4E4})\nFireworks x5 (Credits: {FFD700}%s{A9C4E4})\nBien so xe (Credits: {FFD700}%s{A9C4E4})" \
							"\nHunger Games Voucher(Credits: {FFD700}%s{A9C4E4})",
							number_format(ShopItems[6][sItemPrice]), number_format(ShopItems[7][sItemPrice]), number_format(ShopItems[8][sItemPrice]), number_format(ShopItems[9][sItemPrice]),
							number_format(ShopItems[10][sItemPrice]), number_format(ShopItems[22][sItemPrice]), number_format(ShopItems[29][sItemPrice]));
							ShowPlayerDialog(index, DIALOG_MISCSHOP, DIALOG_STYLE_LIST, "Misc Shop", szDialog, "Select", "Cancel");
						}
						case 3: ShowModelSelectionMenu(index, CarList2, "Car Shop");
						case 4: ShowPlayerDialog( index, DIALOG_HOUSESHOP, DIALOG_STYLE_LIST, "House Shop", "Mua nha\nThay doi noi that\nDi chuyen nha\nGarage - Nho\nGarage - Trung binh\nGarage - To\nGarage - Cuc to","Lua chon", "Thoat" );
						case 5: ShowPlayerDialog( index, DIALOG_VIPSHOP, DIALOG_STYLE_LIST, "VIP Shop", "Mua VIP\nGia han Gold VIP","Tiep tuc", "Thoat" );
						case 6: ShowPlayerDialog(index, DIALOG_SHOPBUSINESS, DIALOG_STYLE_LIST, "Businesses Shop", "Mua cua hang\nGian han cua hang", "Lua chon", "Thoat");
					}
					DeletePVar(index, "OpenShop");
				}
				else
				{
    				ShowPlayerDialog(index, DIALOG_ENTERPIN, DIALOG_STYLE_INPUT, "Mat khau cap 2", "(INVALID PIN)\n\nNhap mat khau cap 2 cua ban de vao cua hang Credits.", "Xac nhan", "Huy bo");
				}
				DeletePVar(index, "PinNumber");
  			}
		}
		else
		{
			SendClientMessageEx(index, COLOR_WHITE, "Co mot van de say ra, vui long thu lai.");
		}
	}
	return 1;
}

forward OnPinCheck(index);
public OnPinCheck(index)
{
	if(IsPlayerConnected(index))
	{
		new rows, fields;
		cache_get_data(rows, fields, MainPipeline);
		if(rows)
		{
		    new Pin[128];
   			cache_get_field_content(0, "Pin", Pin, MainPipeline, 128);
   			if(isnull(Pin)) {
   			    ShowPlayerDialog(index, DIALOG_CREATEPIN, DIALOG_STYLE_INPUT, "Mat khau cap 2", "Tao mat khau cap 2 de bao ve Credits cua ban.", "Khoi tao", "Huy bo");
   			}
   			else
   			{
   			    ShowPlayerDialog(index, DIALOG_ENTERPIN, DIALOG_STYLE_INPUT, "Mat khau cap 2", "Nhap mat khau cap 2 cua ban de vao cua hang Credits.", "Xac nhan", "Huy bo");
   			}
		}
		else
		{
			SendClientMessageEx(index, COLOR_WHITE, "Co mot van de say ra, vui long thu lai.");
		}
	}
	return 1;
}

forward OnGetSMSLog(playerid);
public OnGetSMSLog(playerid)
{
    new string[128], sender[MAX_PLAYER_NAME], message[256], sDate[20], rows, fields;
	cache_get_data(rows, fields, MainPipeline);
	if(rows)
	{
		SendClientMessageEx(playerid, COLOR_GREEN, "________________________________________________");
		SendClientMessageEx(playerid, COLOR_YELLOW, "<< 10 tin nhan SMS da nhan >>");
		for(new i; i < rows; i++)
		{
			cache_get_field_content(i, "sender", sender, MainPipeline, MAX_PLAYER_NAME);
			cache_get_field_content(i, "sendernumber", string, MainPipeline); new sendernumber = strval(string);
			cache_get_field_content(i, "message", message, MainPipeline, sizeof(message));
			cache_get_field_content(i, "date", sDate, MainPipeline, sizeof(sDate));
			if(sendernumber != 0) format(string, sizeof(string), "[%s] SMS: %s, Nguoi gui: %s (%d)", sDate, message, StripUnderscore(sender), sendernumber);
			else format(string, sizeof(string), "[%s] SMS: %s, Nguoi gui: Khong biet", sDate, message);
			SendClientMessageEx(playerid, COLOR_YELLOW, string);
		}
	}
	else SendClientMessageEx(playerid, COLOR_GREY, "Ban chua nhan bat ki tin nhan SMS nao.");
	return 1;
}

forward Group_QueryFinish(iType, iExtraID);
public Group_QueryFinish(iType, iExtraID) {

	/*
		Internally, every group array/subarray starts from zero (divisions, group ids etc)
		When displaying to the clients or saving to the db, we add 1 to them!
		The only exception is ranks which already start from zero.
	*/

	new
		iFields,
		iRows,
		iIndex,
		i = 0,
		szResult[128];

	cache_get_data(iRows, iFields, MainPipeline);

	switch(iType) {
		case GROUP_QUERY_JURISDICTIONS:
  		{
  		    for(new iG = 0; iG < MAX_GROUPS; iG++)
  		    {
  		        arrGroupData[iG][g_iJCount] = 0;
  		    }
			while(iIndex < iRows) {

				cache_get_field_content(iIndex, "GroupID", szResult, MainPipeline, 24);
				new iGroup = strval(szResult);

				if(arrGroupData[iGroup][g_iJCount] > MAX_GROUP_JURISDICTIONS) arrGroupData[iGroup][g_iJCount] = MAX_GROUP_JURISDICTIONS;
				if (!(0 <= iGroup < MAX_GROUPS)) break;
				cache_get_field_content(iIndex, "id", szResult, MainPipeline, 24);
				arrGroupJurisdictions[iGroup][arrGroupData[iGroup][g_iJCount]][g_iJurisdictionSQLId] = strval(szResult);
				cache_get_field_content(iIndex, "AreaName", arrGroupJurisdictions[iGroup][arrGroupData[iGroup][g_iJCount]][g_iAreaName], MainPipeline, 64);
				arrGroupData[iGroup][g_iJCount]++;
				iIndex++;
			}
		}
		case GROUP_QUERY_LOCKERS: while(iIndex < iRows) {

			cache_get_field_content(iIndex, "Group_ID", szResult, MainPipeline);
			new iGroup = strval(szResult)-1;

			cache_get_field_content(iIndex, "Locker_ID", szResult, MainPipeline);
			new iLocker = strval(szResult)-1;

			if (!(0 <= iGroup < MAX_GROUPS)) break;
			if (!(0 <= iLocker < MAX_GROUP_LOCKERS)) break;

			cache_get_field_content(iIndex, "Id", szResult, MainPipeline);
			arrGroupLockers[iGroup][iLocker][g_iLockerSQLId] = strval(szResult);

			cache_get_field_content(iIndex, "LockerX", szResult, MainPipeline);
			arrGroupLockers[iGroup][iLocker][g_fLockerPos][0] = floatstr(szResult);

			cache_get_field_content(iIndex, "LockerY", szResult, MainPipeline);
			arrGroupLockers[iGroup][iLocker][g_fLockerPos][1] = floatstr(szResult);

			cache_get_field_content(iIndex, "LockerZ", szResult, MainPipeline);
			arrGroupLockers[iGroup][iLocker][g_fLockerPos][2] = floatstr(szResult);

			cache_get_field_content(iIndex, "LockerVW", szResult, MainPipeline);
			arrGroupLockers[iGroup][iLocker][g_iLockerVW] = strval(szResult);

			cache_get_field_content(iIndex, "LockerShare", szResult, MainPipeline);
			arrGroupLockers[iGroup][iLocker][g_iLockerShare] = strval(szResult);

			if(arrGroupLockers[iGroup][iLocker][g_fLockerPos][0] != 0.0 && arrGroupLockers[iGroup][iLocker][g_fLockerPos][1] != 0.0) {
				format(szResult, sizeof szResult, "Tu do %s\n{d84a4a}/locker{b4b4b4} de su dung\n ID: %i", arrGroupData[iGroup][g_szGroupName], arrGroupLockers[iGroup][iLocker]);
			    arrGroupLockers[iGroup][iLocker][g_tLocker3DLabel] = CreateDynamic3DTextLabel(szResult, COLOR_BASIC, arrGroupLockers[iGroup][iLocker][g_fLockerPos][0], arrGroupLockers[iGroup][iLocker][g_fLockerPos][1], arrGroupLockers[iGroup][iLocker][g_fLockerPos][2], 15.0, .testlos = 1, .worldid = arrGroupLockers[iGroup][iLocker][g_iLockerVW]);

			}

			iIndex++;

		}
		case GROUP_QUERY_LOAD: while(iIndex < iRows) {
			cache_get_field_content(iIndex, "Name", arrGroupData[iIndex][g_szGroupName], MainPipeline, GROUP_MAX_NAME_LEN);

			cache_get_field_content(iIndex, "MOTD", arrGroupData[iIndex][g_szGroupMOTD], MainPipeline, GROUP_MAX_MOTD_LEN);

			cache_get_field_content(iIndex, "Type", szResult, MainPipeline);
			arrGroupData[iIndex][g_iGroupType] = strval(szResult);

			cache_get_field_content(iIndex, "Allegiance", szResult, MainPipeline);
			arrGroupData[iIndex][g_iAllegiance] = strval(szResult);

			cache_get_field_content(iIndex, "Bug", szResult, MainPipeline);
			arrGroupData[iIndex][g_iBugAccess] = strval(szResult);

			cache_get_field_content(iIndex, "RadioColour", szResult, MainPipeline);
			arrGroupData[iIndex][g_hRadioColour] = strval(szResult);

			cache_get_field_content(iIndex, "Radio", szResult, MainPipeline);
			arrGroupData[iIndex][g_iRadioAccess] = strval(szResult);

			cache_get_field_content(iIndex, "DeptRadio", szResult, MainPipeline);
			arrGroupData[iIndex][g_iDeptRadioAccess] = strval(szResult);

			cache_get_field_content(iIndex, "IntRadio", szResult, MainPipeline);
			arrGroupData[iIndex][g_iIntRadioAccess] = strval(szResult);

			cache_get_field_content(iIndex, "GovAnnouncement", szResult, MainPipeline);
			arrGroupData[iIndex][g_iGovAccess] = strval(szResult);

			cache_get_field_content(iIndex, "FreeNameChange", szResult, MainPipeline);
			arrGroupData[iIndex][g_iFreeNameChange] = strval(szResult);

			cache_get_field_content(iIndex, "Budget", szResult, MainPipeline);
			arrGroupData[iIndex][g_iBudget] = strval(szResult);

			cache_get_field_content(iIndex, "BudgetPayment", szResult, MainPipeline);
			arrGroupData[iIndex][g_iBudgetPayment] = strval(szResult);

			cache_get_field_content(iIndex, "SpikeStrips", szResult, MainPipeline);
			arrGroupData[iIndex][g_iSpikeStrips] = strval(szResult);

			cache_get_field_content(iIndex, "Barricades", szResult, MainPipeline);
			arrGroupData[iIndex][g_iBarricades] = strval(szResult);

			cache_get_field_content(iIndex, "Cones", szResult, MainPipeline);
			arrGroupData[iIndex][g_iCones] = strval(szResult);

			cache_get_field_content(iIndex, "Flares", szResult, MainPipeline);
			arrGroupData[iIndex][g_iFlares] = strval(szResult);

			cache_get_field_content(iIndex, "Barrels", szResult, MainPipeline);
			arrGroupData[iIndex][g_iBarrels] = strval(szResult);

			cache_get_field_content(iIndex, "DutyColour", szResult, MainPipeline);
			arrGroupData[iIndex][g_hDutyColour] = strval(szResult);

			cache_get_field_content(iIndex, "Stock", szResult, MainPipeline);
			arrGroupData[iIndex][g_iLockerStock] = strval(szResult);

			cache_get_field_content(iIndex, "CrateX", szResult, MainPipeline);
			arrGroupData[iIndex][g_fCratePos][0] = floatstr(szResult);

			cache_get_field_content(iIndex, "CrateY", szResult, MainPipeline);
			arrGroupData[iIndex][g_fCratePos][1] = floatstr(szResult);

			cache_get_field_content(iIndex, "CrateZ", szResult, MainPipeline);
			arrGroupData[iIndex][g_fCratePos][2] = floatstr(szResult);

			cache_get_field_content(iIndex, "LockerCostType", szResult, MainPipeline);
			arrGroupData[iIndex][g_iLockerCostType] = strval(szResult);

			cache_get_field_content(iIndex, "CratesOrder", szResult, MainPipeline);
			arrGroupData[iIndex][g_iCratesOrder] = strval(szResult);

			cache_get_field_content(iIndex, "CrateIsland", szResult, MainPipeline);
			arrGroupData[iIndex][g_iCrateIsland] = strval(szResult);

			cache_get_field_content(iIndex, "GarageX", szResult, MainPipeline);
			arrGroupData[iIndex][g_fGaragePos][0] = floatstr(szResult);

			cache_get_field_content(iIndex, "GarageY", szResult, MainPipeline);
			arrGroupData[iIndex][g_fGaragePos][1] = floatstr(szResult);

			cache_get_field_content(iIndex, "GarageZ", szResult, MainPipeline);
			arrGroupData[iIndex][g_fGaragePos][2] = floatstr(szResult);

			while(i < MAX_GROUP_RANKS) {
				format(szResult, sizeof szResult, "Rank%i", i);
				cache_get_field_content(iIndex, szResult, arrGroupRanks[iIndex][i], MainPipeline, GROUP_MAX_RANK_LEN);
				format(szResult, sizeof szResult, "Rank%iPay", i);
				cache_get_field_content(iIndex, szResult, szResult, MainPipeline);
				arrGroupData[iIndex][g_iPaycheck][i] = strval(szResult);
				i++;
			}
			i = 0;

			while(i < MAX_GROUP_DIVS) {
				format(szResult, sizeof szResult, "Div%i", i + 1);
				cache_get_field_content(iIndex, szResult, arrGroupDivisions[iIndex][i], MainPipeline, GROUP_MAX_DIV_LEN);
				i++;
			}
			i = 0;

			while(i < MAX_GROUP_WEAPONS) {
				format(szResult, sizeof szResult, "Gun%i", i + 1);
				cache_get_field_content(iIndex, szResult, szResult, MainPipeline);
				arrGroupData[iIndex][g_iLockerGuns][i] = strval(szResult);
				format(szResult, sizeof szResult, "Cost%i", i + 1);
				cache_get_field_content(iIndex, szResult, szResult, MainPipeline);
				arrGroupData[iIndex][g_iLockerCost][i] = strval(szResult);
				i++;
			}
			i = 0;

			if (arrGroupData[iIndex][g_szGroupName][0] && arrGroupData[iIndex][g_fCratePos][0] != 0.0)
			{
				format(szResult, sizeof szResult, "%s Crate Delivery Point\n{1FBDFF}/delivercrate", arrGroupData[iIndex][g_szGroupName]);
				arrGroupData[iIndex][g_tCrate3DLabel] = CreateDynamic3DTextLabel(szResult, arrGroupData[iIndex][g_hDutyColour] * 256 + 0xFF, arrGroupData[iIndex][g_fCratePos][0], arrGroupData[iIndex][g_fCratePos][1], arrGroupData[iIndex][g_fCratePos][2], 10.0, .testlos = 1, .streamdistance = 20.0);
			}
			iIndex++;
		}

		case GROUP_QUERY_INVITE: if(GetPVarType(iExtraID, "Group_Invited")) {
			if(!iRows) {

				i = GetPVarInt(iExtraID, "Group_Invited");
				iIndex = PlayerInfo[iExtraID][pMember];

				format(szResult, sizeof szResult, "%s %s da yeu cau mot loi moi tham gia nhom %s (su dung /chapnhan group de tham gia).", arrGroupRanks[iIndex][PlayerInfo[iExtraID][pRank]], GetPlayerNameEx(iExtraID), arrGroupData[iIndex][g_szGroupName]);
				SendClientMessageEx(i, COLOR_LIGHTBLUE, szResult);

				format(szResult, sizeof szResult, "Ban da yeu cau %s tham gia %s.", GetPlayerNameEx(i), arrGroupData[iIndex][g_szGroupName]);
				SendClientMessageEx(iExtraID, COLOR_LIGHTBLUE, szResult);
				SetPVarInt(i, "Group_Inviter", iExtraID);
			}
			else {
				SendClientMessage(iExtraID, COLOR_GREY, "Nguoi nay bi cam tham gia nhom.");
				DeletePVar(iExtraID, "Group_Invited");
			}
		}
		case GROUP_QUERY_ADDBAN: {
		    new string[128];
		    new otherplayer = GetPVarInt(iExtraID, "GroupBanningPlayer");
		    new group = GetPVarInt(iExtraID, "GroupBanningGroup");
			format(string, sizeof(string), "Ban da group-banned %s tu nhom %d.", GetPlayerNameEx(otherplayer), group);
			SendClientMessageEx(iExtraID, COLOR_WHITE, string);
			format(string, sizeof(string), "Ban da group-banned, boi %s.", GetPlayerNameEx(iExtraID));
			SendClientMessageEx(otherplayer, COLOR_LIGHTBLUE, string);
			format(string, sizeof(string), "Administrator %s da group-banned %s tu %s (%d)", GetPlayerNameEx(iExtraID), GetPlayerNameEx(otherplayer), arrGroupData[PlayerInfo[otherplayer][pMember]][g_szGroupName], PlayerInfo[otherplayer][pMember]);
			Log("logs/group.log", string);
			PlayerInfo[otherplayer][pMember] = INVALID_GROUP_ID;
			PlayerInfo[otherplayer][pLeader] = INVALID_GROUP_ID;
			PlayerInfo[otherplayer][pRank] = INVALID_RANK;
			PlayerInfo[otherplayer][pDuty] = 0;
			PlayerInfo[otherplayer][pDivision] = INVALID_DIVISION;
			new rand = random(sizeof(CIV));
			PlayerInfo[otherplayer][pModel] = CIV[rand];
			SetPlayerToTeamColor(otherplayer);
			SetPlayerSkin(otherplayer, CIV[rand]);
			OnPlayerStatsUpdate(otherplayer);
			DeletePVar(iExtraID, "GroupBanningPlayer");
			DeletePVar(iExtraID, "GroupBanningGroup");
		}

		case GROUP_QUERY_UNBAN: {
			new string[128];
			new otherplayer = GetPVarInt(iExtraID, "GroupUnBanningPlayer");
			new group = GetPVarInt(iExtraID, "GroupUnBanningGroup");
			if(mysql_affected_rows(MainPipeline))
			{
				format(string, sizeof(string), "Ban da group-unbanned %s tu nhom %s (%d).", GetPlayerNameEx(otherplayer), arrGroupData[group][g_szGroupName], group);
				SendClientMessageEx(iExtraID, COLOR_WHITE, string);
				format(string, sizeof(string), "Ban da group-unbanned %s, boi %s.", arrGroupData[group][g_szGroupName], GetPlayerNameEx(iExtraID));
				SendClientMessageEx(otherplayer, COLOR_LIGHTBLUE, string);
				format(string, sizeof(string), "Administrator %s da group-unbanned %s tu %s (%d)", GetPlayerNameEx(iExtraID), GetPlayerNameEx(otherplayer), arrGroupData[group][g_szGroupName], group);
				Log("logs/group.log", string);
			}
			else
			{
				format(string, sizeof(string), "da co van de say ra voi group-unbanning %s tu %s (%d)", GetPlayerNameEx(otherplayer), arrGroupData[group][g_szGroupName], group);
				SendClientMessageEx(iExtraID, COLOR_WHITE, string);
			}
			DeletePVar(iExtraID, "GroupUnBanningPlayer");
			DeletePVar(iExtraID, "GroupUnBanningGroup");
		}
		case GROUP_QUERY_UNCHECK: if(GetPVarType(iExtraID, "Group_Uninv")) {
			if(iRows) {
				cache_get_field_content(0, "Member", szResult, MainPipeline, MAX_PLAYER_NAME);
				if(strval(szResult) == PlayerInfo[iExtraID][pMember]) {
					cache_get_field_content(0, "Rank", szResult, MainPipeline);
					if(PlayerInfo[iExtraID][pRank] > strval(szResult) || PlayerInfo[iExtraID][pRank] >= Group_GetMaxRank(PlayerInfo[iExtraID][pMember])) {
						cache_get_field_content(0, "ID", szResult, MainPipeline);
						format(szResult, sizeof szResult, "UPDATE `accounts` SET `Model` = "#NOOB_SKIN", `Member` = "#INVALID_GROUP_ID", `Rank` = "#INVALID_RANK", `Leader` = "#INVALID_GROUP_ID", `Division` = -1 WHERE `id` = %i", strval(szResult));
						mysql_function_query(MainPipeline, szResult, true, "Group_QueryFinish", "ii", GROUP_QUERY_UNINVITE, iExtraID);
					}
					else SendClientMessage(iExtraID, COLOR_GREY, "Ban khong the lam dieu nay voi nguoi co cap bac cao hon hoac tuong duong.");
				}
				else SendClientMessage(iExtraID, COLOR_GREY, "Nguoi do khong trong nhom cua ban.");

			}
			else {
				SendClientMessage(iExtraID, COLOR_GREY, "Tai khoan khong ton tai.");
				DeletePVar(iExtraID, "Group_Uninv");
			}
		}
		case GROUP_QUERY_UNINVITE: if(GetPVarType(iExtraID, "Group_Uninv")) {

			new
				szName[MAX_PLAYER_NAME],
				iGroupID = PlayerInfo[iExtraID][pMember];

			GetPVarString(iExtraID, "Group_Uninv", szName, sizeof szName);
			if(mysql_affected_rows(MainPipeline)) {

				i = PlayerInfo[iExtraID][pRank];
				format(szResult, sizeof szResult, "Ban da loai bo thanh cong %s ra khoi nhom cua ban", szName);
				SendClientMessage(iExtraID, COLOR_GREY, szResult);

				format(szResult, sizeof szResult, "%s %s (rank %i) da huy moi offline %s tu %s (%i).", arrGroupRanks[iGroupID][i], GetPlayerNameEx(iExtraID), i + 1, szName, arrGroupData[iGroupID][g_szGroupName], iGroupID + 1);
				Log("logs/group.log", szResult);
			}
			else {
				format(szResult, sizeof szResult, "Co mot loi da say ra khi co gang loai bo %s ra khoi nhom cua ban.", szName);
				SendClientMessage(iExtraID, COLOR_GREY, szResult);
			}
			DeletePVar(iExtraID, "Group_Uninv");
		}
	}
}

forward Jurisdiction_RehashFinish(iGroup);
public Jurisdiction_RehashFinish(iGroup) {

	new
		iFields,
		iRows,
		iIndex,
		szResult[128];

	cache_get_data(iRows, iFields, MainPipeline);

	while(iIndex < iRows)
	{
	    new iGroupID;
		arrGroupData[iGroup][g_iJCount] = iRows;
		if(arrGroupData[iGroup][g_iJCount] > MAX_GROUP_JURISDICTIONS) {
			arrGroupData[iGroup][g_iJCount] = MAX_GROUP_JURISDICTIONS;
		}
		cache_get_field_content(iIndex, "GroupID", szResult, MainPipeline, 24);
		iGroupID = strval(szResult);
		if(iGroupID == iGroup)
		{
			cache_get_field_content(iIndex, "id", szResult, MainPipeline, 64);
			arrGroupJurisdictions[iGroup][iIndex][g_iJurisdictionSQLId] = strval(szResult);
			cache_get_field_content(iIndex, "AreaName", arrGroupJurisdictions[iGroup][iIndex][g_iAreaName], MainPipeline, 64);
		}
		iIndex++;
	}
}

forward DynVeh_QueryFinish(iType, iExtraID);
public DynVeh_QueryFinish(iType, iExtraID) {

	new
		iFields,
		iRows,
		iIndex,
		i = 0,
		sqlid,
		szResult[128];

	cache_get_data(iRows, iFields, MainPipeline);
	switch(iType) {
		case GV_QUERY_LOAD:
		{
		    format(szResult, sizeof(szResult), "UPDATE `groupvehs` SET `SpawnedID` = %d", INVALID_VEHICLE_ID);
			mysql_function_query(MainPipeline, szResult, false, "OnQueryFinish", "i", SENDDATA_THREAD);
			while((iIndex < iRows) && (iIndex < MAX_DYNAMIC_VEHICLES)) {
			    cache_get_field_content(iIndex, "id", szResult, MainPipeline); sqlid = strval(szResult);
				if((sqlid >= MAX_DYNAMIC_VEHICLES)) {// Array bounds check. Use it.
					format(szResult, sizeof(szResult), "DELETE FROM `groupvehs` WHERE `id` = %d", sqlid);
					mysql_function_query(MainPipeline, szResult, false, "OnQueryFinish", "i", SENDDATA_THREAD);
					return printf("SQL ID %d exceeds Max Dynamic Vehicles", sqlid);
				}
				cache_get_field_content(iIndex, "gID", szResult, MainPipeline); DynVehicleInfo[sqlid][gv_igID] = strval(szResult);
				cache_get_field_content(iIndex, "gDivID", szResult, MainPipeline); DynVehicleInfo[sqlid][gv_igDivID] = strval(szResult);
				cache_get_field_content(iIndex, "fID", szResult, MainPipeline); DynVehicleInfo[sqlid][gv_ifID] = strval(szResult);
				cache_get_field_content(iIndex, "rID", szResult, MainPipeline); DynVehicleInfo[sqlid][gv_irID] = strval(szResult);
				cache_get_field_content(iIndex, "vModel", szResult, MainPipeline); DynVehicleInfo[sqlid][gv_iModel] = strval(szResult);
                switch(DynVehicleInfo[sqlid][gv_iModel]) {
					case 538, 537, 449, 590, 569, 570: {
					    DynVehicleInfo[sqlid][gv_iModel] = 0;
					}
				}
				cache_get_field_content(iIndex, "vPlate", DynVehicleInfo[sqlid][gv_iPlate], MainPipeline, 32);
				cache_get_field_content(iIndex, "vMaxHealth", szResult, MainPipeline); DynVehicleInfo[sqlid][gv_fMaxHealth] = floatstr(szResult);
				cache_get_field_content(iIndex, "vType", szResult, MainPipeline); DynVehicleInfo[sqlid][gv_iType] = strval(szResult);
				cache_get_field_content(iIndex, "vLoadMax", szResult, MainPipeline); DynVehicleInfo[sqlid][gv_iLoadMax] = strval(szResult);
				if(DynVehicleInfo[sqlid][gv_iLoadMax] > 6) {
                    DynVehicleInfo[sqlid][gv_iLoadMax] = 6;
				}
				cache_get_field_content(iIndex, "vCol1", szResult, MainPipeline); DynVehicleInfo[sqlid][gv_iCol1] = strval(szResult);
				cache_get_field_content(iIndex, "vCol2", szResult, MainPipeline); DynVehicleInfo[sqlid][gv_iCol2] = strval(szResult);
				cache_get_field_content(iIndex, "vX", szResult, MainPipeline); DynVehicleInfo[sqlid][gv_fX] = floatstr(szResult);
				cache_get_field_content(iIndex, "vY", szResult, MainPipeline); DynVehicleInfo[sqlid][gv_fY] = floatstr(szResult);
				cache_get_field_content(iIndex, "vZ", szResult, MainPipeline); DynVehicleInfo[sqlid][gv_fZ] = floatstr(szResult);
				cache_get_field_content(iIndex, "vVW", szResult, MainPipeline); DynVehicleInfo[sqlid][gv_iVW] = strval(szResult);
				cache_get_field_content(iIndex, "vInt", szResult, MainPipeline); DynVehicleInfo[sqlid][gv_iInt] = strval(szResult);
				cache_get_field_content(iIndex, "vDisabled", szResult, MainPipeline); DynVehicleInfo[sqlid][gv_iDisabled] = strval(szResult);
				cache_get_field_content(iIndex, "vRotZ", szResult, MainPipeline); DynVehicleInfo[sqlid][gv_fRotZ] = floatstr(szResult);
				cache_get_field_content(iIndex, "vUpkeep", szResult, MainPipeline); DynVehicleInfo[sqlid][gv_iUpkeep] = strval(szResult);
				i = 1;
				while(i <= MAX_DV_OBJECTS) {
					format(szResult, sizeof szResult, "vAttachedObjectModel%i", i);
					cache_get_field_content(iIndex, szResult, szResult, MainPipeline); DynVehicleInfo[sqlid][gv_iAttachedObjectModel][i-1] = strval(szResult);
					format(szResult, sizeof szResult, "vObjectX%i", i);
					cache_get_field_content(iIndex, szResult, szResult, MainPipeline); DynVehicleInfo[sqlid][gv_fObjectX][i-1] = floatstr(szResult);
					format(szResult, sizeof szResult, "vObjectY%i", i);
					cache_get_field_content(iIndex, szResult, szResult, MainPipeline); DynVehicleInfo[sqlid][gv_fObjectY][i-1] = floatstr(szResult);
					format(szResult, sizeof szResult, "vObjectZ%i", i);
					cache_get_field_content(iIndex, szResult, szResult, MainPipeline); DynVehicleInfo[sqlid][gv_fObjectZ][i-1] = floatstr(szResult);
					format(szResult, sizeof szResult, "vObjectRX%i", i);
					cache_get_field_content(iIndex, szResult, szResult, MainPipeline); DynVehicleInfo[sqlid][gv_fObjectRX][i-1] = floatstr(szResult);
					format(szResult, sizeof szResult, "vObjectRY%i", i);
					cache_get_field_content(iIndex, szResult, szResult, MainPipeline); DynVehicleInfo[sqlid][gv_fObjectRY][i-1] = floatstr(szResult);
					format(szResult, sizeof szResult, "vObjectRZ%i", i);
					cache_get_field_content(iIndex, szResult, szResult, MainPipeline); DynVehicleInfo[sqlid][gv_fObjectRZ][i-1] = floatstr(szResult);
					i++;
				}
				i = 0;
				while(i < MAX_DV_MODS) {
					format(szResult, sizeof szResult, "vMod%i", i);
					cache_get_field_content(iIndex, szResult, szResult, MainPipeline); DynVehicleInfo[sqlid][gv_iMod][i++] = strval(szResult);
				}

				if(400 < DynVehicleInfo[sqlid][gv_iModel] < 612) {
					if(!IsWeaponizedVehicle(DynVehicleInfo[sqlid][gv_iModel])) {
						DynVeh_Spawn(iIndex);
						//printf("[DynVeh] Loaded Dynamic Vehicle %i.", iIndex);
						for(i = 0; i != MAX_DV_OBJECTS; i++)
						{
							if(DynVehicleInfo[sqlid][gv_iAttachedObjectModel][i] == 0 || DynVehicleInfo[sqlid][gv_iAttachedObjectModel][i] == INVALID_OBJECT_ID) {
								DynVehicleInfo[sqlid][gv_iAttachedObjectID][i] = INVALID_OBJECT_ID;
								DynVehicleInfo[sqlid][gv_iAttachedObjectModel][i] = INVALID_OBJECT_ID;
							}
						}
					} else {
						DynVehicleInfo[sqlid][gv_iSpawnedID] = INVALID_VEHICLE_ID;
					}
				}
				iIndex++;
			}
		}
	}
	return 1;
}

forward LoadBusinessesSaless();
public LoadBusinessesSaless() {

	new
		iFields,
		iRows,
		iIndex,
		szResult[128];

	cache_get_data(iRows, iFields, MainPipeline);

	while((iIndex < iRows)) {
		cache_get_field_content(iIndex, "bID", szResult, MainPipeline); BusinessSales[iIndex][bID] = strval(szResult);
		cache_get_field_content(iIndex, "BusinessID", szResult, MainPipeline); BusinessSales[iIndex][bBusinessID] = strval(szResult);
		cache_get_field_content(iIndex, "Text", BusinessSales[iIndex][bText], MainPipeline, 128);
		cache_get_field_content(iIndex, "Price", szResult, MainPipeline); BusinessSales[iIndex][bPrice] = strval(szResult);
		cache_get_field_content(iIndex, "Available", szResult, MainPipeline); BusinessSales[iIndex][bAvailable] = strval(szResult);
		cache_get_field_content(iIndex, "Purchased", szResult, MainPipeline); BusinessSales[iIndex][bPurchased] = strval(szResult);
		cache_get_field_content(iIndex, "Type", szResult, MainPipeline); BusinessSales[iIndex][bType] = strval(szResult);
		iIndex++;
	}
	return 1;
}

forward AuctionLoadQuery();
public AuctionLoadQuery() {

	new
		iFields,
		iRows,
		iIndex,
		szResult[128];

	cache_get_data(iRows, iFields, MainPipeline);

	while((iIndex < iRows)) {
		cache_get_field_content(iIndex, "BiddingFor", Auctions[iIndex][BiddingFor], MainPipeline, 64);
		cache_get_field_content(iIndex, "InProgress", szResult, MainPipeline); Auctions[iIndex][InProgress] = strval(szResult);
		cache_get_field_content(iIndex, "Bid", szResult, MainPipeline); Auctions[iIndex][Bid] = strval(szResult);
		cache_get_field_content(iIndex, "Bidder", szResult, MainPipeline); Auctions[iIndex][Bidder] = strval(szResult);
		cache_get_field_content(iIndex, "Expires", szResult, MainPipeline); Auctions[iIndex][Expires] = strval(szResult);
		cache_get_field_content(iIndex, "Wining", Auctions[iIndex][Wining], MainPipeline, MAX_PLAYER_NAME);
		cache_get_field_content(iIndex, "Increment", szResult, MainPipeline); Auctions[iIndex][Increment] = strval(szResult);
		if(Auctions[iIndex][InProgress] == 1 && Auctions[iIndex][Expires] != 0)
		{
		    Auctions[iIndex][Timer] = SetTimerEx("EndAuction", 60000, true, "i", iIndex);
		    printf("[auction - %i - started] %s, %d, %d, %d, %d, %s, %d",iIndex, Auctions[iIndex][BiddingFor],Auctions[iIndex][InProgress],Auctions[iIndex][Bid],Auctions[iIndex][Bidder],Auctions[iIndex][Expires],Auctions[iIndex][Wining],Auctions[iIndex][Increment]);
		}
		iIndex++;
	}
	return 1;
}

forward PlantsLoadQuery();
public PlantsLoadQuery() {

	new
		iFields,
		iRows,
		iIndex,
		szResult[128];

	cache_get_data(iRows, iFields, MainPipeline);

	while((iIndex < iRows)) {
		cache_get_field_content(iIndex, "Owner", szResult, MainPipeline); Plants[iIndex][pOwner] = strval(szResult);
		cache_get_field_content(iIndex, "Object", szResult, MainPipeline); Plants[iIndex][pObject] = strval(szResult);
		cache_get_field_content(iIndex, "PlantType", szResult, MainPipeline); Plants[iIndex][pPlantType] = strval(szResult);
		cache_get_field_content(iIndex, "PositionX", szResult, MainPipeline); Plants[iIndex][pPos][0] = floatstr(szResult);
		cache_get_field_content(iIndex, "PositionY", szResult, MainPipeline); Plants[iIndex][pPos][1] = floatstr(szResult);
		cache_get_field_content(iIndex, "PositionZ", szResult, MainPipeline); Plants[iIndex][pPos][2] = floatstr(szResult);
		cache_get_field_content(iIndex, "Virtual", szResult, MainPipeline); Plants[iIndex][pVirtual] = strval(szResult);
		cache_get_field_content(iIndex, "Interior", szResult, MainPipeline); Plants[iIndex][pInterior] = strval(szResult);
		cache_get_field_content(iIndex, "Growth", szResult, MainPipeline); Plants[iIndex][pGrowth] = strval(szResult);
		cache_get_field_content(iIndex, "Expires", szResult, MainPipeline); Plants[iIndex][pExpires] = strval(szResult);
		cache_get_field_content(iIndex, "DrugsSkill", szResult, MainPipeline); Plants[iIndex][pDrugsSkill] = strval(szResult);

		if(Plants[iIndex][pOwner] != 0) {
		    Plants[iIndex][pObjectSpawned] = CreateDynamicObject(Plants[iIndex][pObject], Plants[iIndex][pPos][0], Plants[iIndex][pPos][1], Plants[iIndex][pPos][2], 0.0, 0.0, 0.0, Plants[iIndex][pVirtual], Plants[iIndex][pInterior]);
		}
		iIndex++;
	}
	if(iIndex > 0) printf("[LoadPlants] Successfully loaded %d plants", iIndex);
	else printf("[LoadPlants] Error: Failed to load any plants!");
	return 1;
}

forward BusinessesLoadQueryFinish();
public BusinessesLoadQueryFinish()
{
	new i, rows, fields, tmp[128];
	cache_get_data(rows, fields, MainPipeline);
	while(i < rows)
	{
		cache_get_field_content(i, "Name", Businesses[i][bName], MainPipeline, MAX_BUSINESS_NAME);
		cache_get_field_content(i, "OwnerID", tmp, MainPipeline); Businesses[i][bOwner] = strval(tmp);
		cache_get_field_content(i, "Username", Businesses[i][bOwnerName], MainPipeline, MAX_PLAYER_NAME);
		cache_get_field_content(i, "Type", tmp, MainPipeline); Businesses[i][bType] = strval(tmp);
		cache_get_field_content(i, "Value", tmp, MainPipeline); Businesses[i][bValue] = strval(tmp);
		cache_get_field_content(i, "Status", tmp, MainPipeline); Businesses[i][bStatus] = strval(tmp);
		cache_get_field_content(i, "Level", tmp, MainPipeline); Businesses[i][bLevel] = strval(tmp);
		cache_get_field_content(i, "LevelProgress", tmp, MainPipeline); Businesses[i][bLevelProgress] = strval(tmp);
		cache_get_field_content(i, "SafeBalance", tmp, MainPipeline); Businesses[i][bSafeBalance] = strval(tmp);
		cache_get_field_content(i, "NoThue", tmp, MainPipeline); Businesses[i][bNoThue] = strval(tmp);
		cache_get_field_content(i, "Inventory", tmp, MainPipeline); Businesses[i][bInventory] = strval(tmp);
		cache_get_field_content(i, "InventoryCapacity", tmp, MainPipeline); Businesses[i][bInventoryCapacity] = strval(tmp);
		cache_get_field_content(i, "AutoSale", tmp, MainPipeline); Businesses[i][bAutoSale] = strval(tmp);
		cache_get_field_content(i, "TotalSales", tmp, MainPipeline); Businesses[i][bTotalSales] = strval(tmp);
		cache_get_field_content(i, "ExteriorX", tmp, MainPipeline); Businesses[i][bExtPos][0] = floatstr(tmp);
		cache_get_field_content(i, "ExteriorY", tmp, MainPipeline); Businesses[i][bExtPos][1] = floatstr(tmp);
		cache_get_field_content(i, "ExteriorZ", tmp, MainPipeline); Businesses[i][bExtPos][2] = floatstr(tmp);
		cache_get_field_content(i, "ExteriorA", tmp, MainPipeline); Businesses[i][bExtPos][3] = floatstr(tmp);
		cache_get_field_content(i, "InteriorX", tmp, MainPipeline); Businesses[i][bIntPos][0] = floatstr(tmp);
		cache_get_field_content(i, "InteriorY", tmp, MainPipeline); Businesses[i][bIntPos][1] = floatstr(tmp);
		cache_get_field_content(i, "InteriorZ", tmp, MainPipeline); Businesses[i][bIntPos][2] = floatstr(tmp);
		cache_get_field_content(i, "InteriorA", tmp, MainPipeline); Businesses[i][bIntPos][3] = floatstr(tmp);
		cache_get_field_content(i, "Interior", tmp, MainPipeline); Businesses[i][bInt] = strval(tmp);
		cache_get_field_content(i, "SupplyPointX", tmp, MainPipeline); Businesses[i][bSupplyPos][0] = floatstr(tmp);
		cache_get_field_content(i, "SupplyPointY", tmp, MainPipeline); Businesses[i][bSupplyPos][1] = floatstr(tmp);
		cache_get_field_content(i, "SupplyPointZ", tmp, MainPipeline); Businesses[i][bSupplyPos][2] = floatstr(tmp);
		cache_get_field_content(i, "GasPrice", tmp, MainPipeline); Businesses[i][bGasPrice] = floatstr(tmp);
		cache_get_field_content(i, "OrderBy", Businesses[i][bOrderBy], MainPipeline, MAX_PLAYER_NAME);
		cache_get_field_content(i, "OrderState", tmp, MainPipeline); Businesses[i][bOrderState] = strval(tmp);
		cache_get_field_content(i, "OrderAmount", tmp, MainPipeline); Businesses[i][bOrderAmount] = strval(tmp);
		cache_get_field_content(i, "OrderDate", Businesses[i][bOrderDate], MainPipeline, 30);
		cache_get_field_content(i, "CustomExterior", tmp, MainPipeline); Businesses[i][bCustomExterior] = strval(tmp);
		cache_get_field_content(i, "CustomInterior", tmp, MainPipeline); Businesses[i][bCustomInterior] = strval(tmp);
		cache_get_field_content(i, "Grade", tmp, MainPipeline); Businesses[i][bGrade] = strval(tmp);
		cache_get_field_content(i, "CustomVW", tmp, MainPipeline); Businesses[i][bVW] = strval(tmp);
		cache_get_field_content(i, "Pay", tmp, MainPipeline); Businesses[i][bAutoPay] = strval(tmp);
		cache_get_field_content(i, "MinInviteRank", tmp, MainPipeline); Businesses[i][bMinInviteRank] = strval(tmp);
		cache_get_field_content(i, "MinSupplyRank", tmp, MainPipeline); Businesses[i][bMinSupplyRank] = strval(tmp);
		cache_get_field_content(i, "MinGiveRankRank", tmp, MainPipeline); Businesses[i][bMinGiveRankRank] = strval(tmp);
		cache_get_field_content(i, "MinSafeRank", tmp, MainPipeline); Businesses[i][bMinSafeRank] = strval(tmp);
		cache_get_field_content(i, "Months", tmp, MainPipeline); Businesses[i][bMonths] = strval(tmp);
		cache_get_field_content(i, "GymEntryFee", tmp, MainPipeline); Businesses[i][bGymEntryFee] = strval(tmp);
		cache_get_field_content(i, "GymType", tmp, MainPipeline); Businesses[i][bGymType] = strval(tmp);

		if (Businesses[i][bOrderState] == 2) {
		    Businesses[i][bOrderState] = 1;
		}

		RefreshBusinessPickup(i);

		for (new j; j <= 5; j++)
		{
		    new col[9];
			format(col, sizeof(col), "Rank%dPay", j);
			cache_get_field_content(i, col, tmp, MainPipeline);
			Businesses[i][bRankPay][j] = strval(tmp);
		}

		if (Businesses[i][bType] == BUSINESS_TYPE_GASSTATION)
		{
			for (new j, column[17]; j < MAX_BUSINESS_GAS_PUMPS; j++)
			{
			    format(column, sizeof(column), "GasPump%dPosX", j + 1);
				cache_get_field_content(i, column, tmp, MainPipeline); Businesses[i][GasPumpPosX][j] = floatstr(tmp);
			    format(column, sizeof(column), "GasPump%dPosY", j + 1);
				cache_get_field_content(i, column, tmp, MainPipeline); Businesses[i][GasPumpPosY][j] = floatstr(tmp);
			    format(column, sizeof(column), "GasPump%dPosZ", j + 1);
				cache_get_field_content(i, column, tmp, MainPipeline); Businesses[i][GasPumpPosZ][j] = floatstr(tmp);
			    format(column, sizeof(column), "GasPump%dAngle", j + 1);
				cache_get_field_content(i, column, tmp, MainPipeline); Businesses[i][GasPumpAngle][j] = floatstr(tmp);
			    format(column, sizeof(column), "GasPump%dCapacity", j + 1);
				cache_get_field_content(i, column, tmp, MainPipeline); Businesses[i][GasPumpCapacity][j] = floatstr(tmp);
			    format(column, sizeof(column), "GasPump%dGas", j + 1);
				cache_get_field_content(i, column, tmp, MainPipeline); Businesses[i][GasPumpGallons][j] = floatstr(tmp);
				CreateDynamicGasPump(_, i, j);

				for (new z; z <= 17; z++)
				{
			    	new col[12];
					format(col, sizeof(col), "Item%dPrice", z + 1);
					cache_get_field_content(i, col, tmp, MainPipeline);
					Businesses[i][bItemPrices][z] = strval(tmp);
				}
			}
		}
		else if (Businesses[i][bType] == BUSINESS_TYPE_NEWCARDEALERSHIP || Businesses[i][bType] == BUSINESS_TYPE_OLDCARDEALERSHIP)
		{
			for (new j, column[16], label[50]; j < MAX_BUSINESS_DEALERSHIP_VEHICLES; j++)
			{

			    format(column, sizeof(column), "Car%dModelId", j);
				cache_get_field_content(i, column, tmp, MainPipeline); Businesses[i][bModel][j] = strval(tmp);
			    format(column, sizeof(column), "Car%dPosX", j);
				cache_get_field_content(i, column, tmp, MainPipeline); Businesses[i][bParkPosX][j] = floatstr(tmp);
			    format(column, sizeof(column), "Car%dPosY", j);
				cache_get_field_content(i, column, tmp, MainPipeline); Businesses[i][bParkPosY][j] = floatstr(tmp);
			    format(column, sizeof(column), "Car%dPosZ", j);
				cache_get_field_content(i, column, tmp, MainPipeline); Businesses[i][bParkPosZ][j] = floatstr(tmp);
			    format(column, sizeof(column), "Car%dPosAngle", j);
				cache_get_field_content(i, column, tmp, MainPipeline); Businesses[i][bParkAngle][j] = floatstr(tmp);
			    format(column, sizeof(column), "Car%dPrice", j);
				cache_get_field_content(i, column, tmp, MainPipeline); Businesses[i][bPrice][j] = strval(tmp);

				cache_get_field_content(i, "PurchaseX", tmp, MainPipeline); Businesses[i][bPurchaseX][j] = strval(tmp);
				cache_get_field_content(i, "PurchaseY", tmp, MainPipeline); Businesses[i][bPurchaseY][j] = strval(tmp);
				cache_get_field_content(i, "PurchaseZ", tmp, MainPipeline); Businesses[i][bPurchaseZ][j] = strval(tmp);
				cache_get_field_content(i, "PurchaseAngle", tmp, MainPipeline); Businesses[i][bPurchaseAngle][j] = strval(tmp);

                if(400 < Businesses[i][bModel][j] < 612) {
			 		Businesses[i][bVehID][j] = CreateVehicle(Businesses[i][bModel][j], Businesses[i][bParkPosX][j], Businesses[i][bParkPosY][j], Businesses[i][bParkPosZ][j], Businesses[i][bParkAngle][j], Businesses[i][bColor1][j], Businesses[i][bColor2][j], 10);
     				format(label, sizeof(label), "Phuong tien %s dang duoc ban voi gia: $%s\nVui long len xe de thuc hien giao dich", GetVehicleName(Businesses[i][bVehID][j]), number_format(Businesses[i][bPrice][j]));
					Businesses[i][bVehicleLabel][j] = CreateDynamic3DTextLabel(label,COLOR_LIGHTGREEN,Businesses[i][bParkPosX][j], Businesses[i][bParkPosY][j], Businesses[i][bParkPosZ][j],8.0,INVALID_PLAYER_ID, Businesses[i][bVehID][j]);
				}
			}
		}
		else
		{
			for (new j; j <= 17; j++)
			{
			    new col[12];
				format(col, sizeof(col), "Item%dPrice", j + 1);
				cache_get_field_content(i, col, tmp, MainPipeline);
				Businesses[i][bItemPrices][j] = strval(tmp);
			}
		}

		Businesses[i][bGymBoxingArena1][0] = INVALID_PLAYER_ID;
		Businesses[i][bGymBoxingArena1][1] = INVALID_PLAYER_ID;
		Businesses[i][bGymBoxingArena2][0] = INVALID_PLAYER_ID;
		Businesses[i][bGymBoxingArena2][1] = INVALID_PLAYER_ID;

		for (new it = 0; it < 10; ++it)
		{
			Businesses[i][bGymBikePlayers][it] = INVALID_PLAYER_ID;
			Businesses[i][bGymBikeVehicles][it] = INVALID_VEHICLE_ID;
		}

		i++;
	}
	if(i > 0) printf("[LoadBusinesses] %d businesses rehashed/loaded.", i);
	else printf("[LoadBusinesses] Failed to load any businesses.");
}

forward ReturnMoney(index);
public ReturnMoney(index)
{
	if(IsPlayerConnected(index))
	{
	    new
    		AuctionItem = GetPVarInt(index, "AuctionItem");

		new money[15], money2, string[128];
		new rows, fields;
		cache_get_data(rows, fields, MainPipeline);
		if(rows)
		{
   			cache_get_field_content(0, "Money", money, MainPipeline); money2 = strval(money);

   			format(string, sizeof(string), "UPDATE `accounts` SET `Money` = %d WHERE `id` = '%d'", money2+Auctions[AuctionItem][Bid], Auctions[AuctionItem][Bidder]);
			mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);

			format(string, sizeof(string), "So tien $%d (Truoc: %i | Sau: %i) da duoc tra lai (id: %i) de duoc tra gia cao hon", Auctions[AuctionItem][Bid], money2,Auctions[AuctionItem][Bid]+money2,  Auctions[AuctionItem][Bidder]);
			Log("logs/auction.log", string);

            GivePlayerMoneyEx(index, -GetPVarInt(index, "BidPlaced"));
			Auctions[AuctionItem][Bid] = GetPVarInt(index, "BidPlaced");
			Auctions[AuctionItem][Bidder] = GetPlayerSQLId(index);
			strcpy(Auctions[AuctionItem][Wining], GetPlayerNameExt(index), MAX_PLAYER_NAME);

			format(string, sizeof(string), "Ban da dat mot gia thau %i tren %s.", GetPVarInt(index, "BidPlaced"), Auctions[AuctionItem][BiddingFor]);
			SendClientMessageEx(index, COLOR_WHITE, string);

			format(string, sizeof(string), "%s (IP:%s) da dat mot gia thau %i tren %s(%i)", GetPlayerNameEx(index), GetPlayerIpEx(index), GetPVarInt(index, "BidPlaced"), Auctions[AuctionItem][BiddingFor], AuctionItem);
			Log("logs/auction.log", string);

			SaveAuction(AuctionItem);

			DeletePVar(index, "BidPlaced");
			DeletePVar(index, "AuctionItem");
		}
		else
		{
			printf("[AuctionError] id: %i | money %i", Auctions[AuctionItem][Bidder],  Auctions[AuctionItem][Bid]);
		}
	}
	return 1;
}

forward OnQueryCreateVehicle(playerid, playervehicleid);
public OnQueryCreateVehicle(playerid, playervehicleid)
{
	PlayerVehicleInfo[playerid][playervehicleid][pvSlotId] = mysql_insert_id(MainPipeline);
	printf("VNumber: %d", PlayerVehicleInfo[playerid][playervehicleid][pvSlotId]);

	new string[128];
    format(string, sizeof(string), "UPDATE `vehicles` SET `pvModelId` = %d WHERE `id` = %d", PlayerVehicleInfo[playerid][playervehicleid][pvModelId], PlayerVehicleInfo[playerid][playervehicleid][pvSlotId]);
	mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);

	g_mysql_SaveVehicle(playerid, playervehicleid);
}

forward CheckAccounts(playerid);
public CheckAccounts(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		new szString[128];
		new rows, fields;
		cache_get_data(rows, fields, MainPipeline);
		if(rows)
		{
		    format(szString, sizeof(szString), "{AA3333}AdmWarning{FFFF00}: Moderator %s da dang nhap vao may chu khi su dung tool hack s0beit.", GetPlayerNameEx(playerid));
   			ABroadCast(COLOR_YELLOW, szString, 2);

    		format(szString, sizeof(szString), "Admin %s (IP: %s) da dang nhap vao may chu khi su dung tool hack s0beit.", GetPlayerNameEx(playerid), GetPlayerIpEx(playerid));
     		Log("logs/sobeit.log", szString);
       		sobeitCheckvar[playerid] = 1;
     		sobeitCheckIsDone[playerid] = 1;
     		IsPlayerFrozen[playerid] = 0;
		}
		else
		{
		    format(szString, sizeof(szString), "INSERT INTO `sobeitkicks` (sqlID, Kicks) VALUES (%d, 1) ON DUPLICATE KEY UPDATE Kicks = Kicks + 1", GetPlayerSQLId(playerid));
			mysql_function_query(MainPipeline, szString, false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);

		    SendClientMessageEx(playerid, COLOR_RED, "Tool hack 's0beit' khong duoc phep su  dung, vui long go bo no ra khoi game");
   			format(szString, sizeof(szString), "%s (IP: %s) da dang nhap vao may chu khi su dung tool hack s0beit.", GetPlayerNameEx(playerid), GetPlayerIpEx(playerid));
   			Log("logs/sobeit.log", szString);
            sobeitCheckvar[playerid] = 1;
     		sobeitCheckIsDone[playerid] = 1;
     		IsPlayerFrozen[playerid] = 0;
    		SetTimerEx("KickEx", 1000, 0, "i", playerid);
		}
	}
	return 1;
}

forward ReferralSecurity(playerid);
public ReferralSecurity(playerid)
{
    new newrows, newfields, newresult[16], currentIP[16], szString[128];
	GetPlayerIp(playerid, currentIP, sizeof(currentIP));
	cache_get_data(newrows, newfields, MainPipeline);

	if(newrows > 0)
	{
 		cache_get_field_content(0, "IP", newresult, MainPipeline);

   		if(!strcmp(newresult, currentIP, true))
	    {
	        format(szString, sizeof(szString), "Nobody");
			strmid(PlayerInfo[playerid][pReferredBy], szString, 0, strlen(szString), MAX_PLAYER_NAME);
            ShowPlayerDialog(playerid, REGISTERREF, DIALOG_STYLE_INPUT, "{FF0000}Error", "This person has the same IP as you.\nPlease choose another player that is not on your network.\n\nIf you haven't been referred, press 'Skip'.\n\nExample: FirstName_LastName (20 Characters Max)", "Enter", "Skip");
    	}
    	else
		{
    	    format(szString, sizeof(szString), "[Referral] (New Account: %s (IP:%s)) da duoc gioi thieu boi (Nguoi choi: %s (IP:%s))", GetPlayerNameEx(playerid), currentIP, PlayerInfo[playerid][pReferredBy], newresult);
    	    Log("logs/referral.log", szString);
            mysql_free_result(MainPipeline);
			RegistrationStep[playerid] = 3;
			SetPlayerVirtualWorld(playerid, 0);
			ClearChatbox(playerid);
			TutStep[playerid] = 24;
			
			PlayerNationSelection[playerid] = -1;
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			Streamer_UpdateEx(playerid,1716.1129,-1880.0715,22.0264);
			SetPlayerPos(playerid,1716.1129,-1880.0715,-10.0);
			SetPlayerCameraPos(playerid,1755.0413,-1824.8710,20.2100);
			SetPlayerCameraLookAt(playerid,1716.1129,-1880.0715,22.0264);
		}
	}
	return 1;
}


forward OnQueryCreateToy(playerid, toyslot);
public OnQueryCreateToy(playerid, toyslot)
{
	PlayerToyInfo[playerid][toyslot][ptID] = mysql_insert_id(MainPipeline);
	printf("Toy ID: %d", PlayerToyInfo[playerid][toyslot][ptID]);

	new szQuery[128];
	format(szQuery, sizeof(szQuery), "UPDATE `toys` SET `modelid` = '%d' WHERE `id` = '%d'", PlayerToyInfo[playerid][toyslot][ptID], PlayerToyInfo[playerid][toyslot][ptModelID]);
	mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "i", SENDDATA_THREAD);

	g_mysql_SaveToys(playerid, toyslot);
}

forward OnStaffAccountCheck(playerid);
public OnStaffAccountCheck(playerid)
{
	new string[156], rows, fields;
	cache_get_data(rows, fields, MainPipeline);
	if(rows > 0)
	{
		format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s (ID: %d) was punished and has a staff account associated with their IP address.", GetPlayerNameEx(playerid), playerid);
		ABroadCast(COLOR_YELLOW, string, 2);
	}
	return 1;
}

stock SavePoint(pid)
{
	new szQuery[2048];

	format(szQuery, sizeof(szQuery), "UPDATE `points` SET \
		`posx` = '%f', \
		`posy` = '%f', \
 		`posz` = '%f', \
		`vw` = '%d', \
		`type` = '%d', \
		`vulnerable` = '%d', \
		`matpoint` = '%d', \
		`owner` = '%s', \
		`cappername` = '%s', \
		`name` = '%s' WHERE `id` = %d",
		Points[pid][Pointx],
		Points[pid][Pointy],
		Points[pid][Pointz],
		Points[pid][pointVW],
		Points[pid][Type],
		Points[pid][Vulnerable],
		Points[pid][MatPoint],
		g_mysql_ReturnEscaped(Points[pid][Owner], MainPipeline),
		g_mysql_ReturnEscaped(Points[pid][CapperName], MainPipeline),
		g_mysql_ReturnEscaped(Points[pid][Name], MainPipeline),
		pid+1
	);

	mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "i", SENDDATA_THREAD);
}

forward OnLoadPoints();
public OnLoadPoints()
{
	new fields, rows, index, result[128];
	cache_get_data(rows, fields, MainPipeline);

	while((index < rows))
	{
		cache_get_field_content(index, "id", result, MainPipeline); Points[index][pointID] = strval(result);
		cache_get_field_content(index, "posx", result, MainPipeline); Points[index][Pointx] = floatstr(result);
		cache_get_field_content(index, "posy", result, MainPipeline); Points[index][Pointy] = floatstr(result);
		cache_get_field_content(index, "posz", result, MainPipeline); Points[index][Pointz] = floatstr(result);
		cache_get_field_content(index, "vw", result, MainPipeline); Points[index][pointVW] = strval(result);
		cache_get_field_content(index, "type", result, MainPipeline); Points[index][Type] = strval(result);
		cache_get_field_content(index, "vulnerable", result, MainPipeline); Points[index][Vulnerable] = strval(result);
		cache_get_field_content(index, "matpoint", result, MainPipeline); Points[index][MatPoint] = strval(result);
		cache_get_field_content(index, "owner", Points[index][Owner], MainPipeline, 128);
		cache_get_field_content(index, "cappername", Points[index][CapperName], MainPipeline, MAX_PLAYER_NAME);
		cache_get_field_content(index, "name", Points[index][Name], MainPipeline, 128);
		cache_get_field_content(index, "captime", result, MainPipeline); Points[index][CapTime] = strval(result);
		cache_get_field_content(index, "capfam", result, MainPipeline); Points[index][CapFam] = strval(result);
		cache_get_field_content(index, "capname", Points[index][CapName], MainPipeline, MAX_PLAYER_NAME);

		Points[index][CaptureTimerEx2] = -1;
		Points[index][ClaimerId] = INVALID_PLAYER_ID;
		Points[index][PointPickupID] = CreateDynamicPickup(1239, 23, Points[index][Pointx], Points[index][Pointy], Points[index][Pointz], Points[index][pointVW]);

		if(Points[index][CapFam] != INVALID_FAMILY_ID)
		{
			Points[index][CapCrash] = 1;
			Points[index][TakeOverTimerStarted] = 1;
			Points[index][ClaimerTeam] = Points[index][CapFam];
			Points[index][TakeOverTimer] = Points[index][CapTime];
			format(Points[index][PlayerNameCapping], MAX_PLAYER_NAME, "%s", Points[index][CapName]);
			ReadyToCapture(index);
			Points[index][CaptureTimerEx2] = SetTimerEx("CaptureTimerEx", 60000, 1, "d", index);
		}

		index++;
	}
	if(index == 0) print("[Family Points] No family points has been loaded.");
	if(index != 0) printf("[Family Points] %d family points has been loaded.", index);
	return 1;
}

stock GetPartnerName(playerid)
{
	if(PlayerInfo[playerid][pMarriedID] == -1) format(PlayerInfo[playerid][pMarriedName], MAX_PLAYER_NAME, "Nobody");
	else
	{
		new query[128];
		format(query, sizeof(query), "SELECT `Username` FROM `accounts` WHERE `id` = %d", PlayerInfo[playerid][pMarriedID]);
		mysql_function_query(MainPipeline, query, true, "OnGetPartnerName", "i", playerid);
	}
}

forward OnGetPartnerName(playerid);
public OnGetPartnerName(playerid)
{
	new fields, rows, index;
	cache_get_data(rows, fields, MainPipeline);

	cache_get_field_content(index, "Username", PlayerInfo[playerid][pMarriedName], MainPipeline, MAX_PLAYER_NAME);
	return 1;
}

forward OnStaffPrize(playerid);
public OnStaffPrize(playerid)
{
	if(mysql_affected_rows(MainPipeline))
	{
		new type[32], name[MAX_PLAYER_NAME], amount, string[128];
		GetPVarString(playerid, "OnSPrizeType", type, 16);
		GetPVarString(playerid, "OnSPrizeName", name, 24);
		amount = GetPVarInt(playerid, "OnSPrizeAmount");
		format(string, sizeof(string), "AdmCmd: %s has offline-given %s %d free %s.", GetPlayerNameEx(playerid), name, amount, type);
		ABroadCast(COLOR_LIGHTRED, string, 2);
		format(string, sizeof(string), "You have given %s %d %s.", name, amount, type);
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
		format(string, sizeof(string), "[Admin] %s(IP:%s) has offline-given %s %d free %s.", GetPlayerNameEx(playerid), GetPlayerIpEx(playerid), name, amount, type);
		Log("logs/adminrewards.log", string);
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_RED, "Failed to give the prize..");
	}
	DeletePVar(playerid, "OnSPrizeType");
	DeletePVar(playerid, "OnSPrizeName");
	DeletePVar(playerid, "OnSPrizeAmount");
	return 1;
}

forward ExecuteShopQueue(playerid, id);
public ExecuteShopQueue(playerid, id)
{
	new rows, fields, index, result[128], string[128], query[128], tmp[8];
	switch(id)
	{
		case 0:
		{
			cache_get_data(rows, fields, MainPipeline);
			if(IsPlayerConnected(playerid))
			{
				while(index < rows)
				{
					cache_get_field_content(index, "id", result, MainPipeline); tmp[0] = strval(result);
					cache_get_field_content(index, "GiftVoucher", result, MainPipeline); tmp[1] = strval(result);
					cache_get_field_content(index, "CarVoucher", result, MainPipeline); tmp[2] = strval(result);
					cache_get_field_content(index, "VehVoucher", result, MainPipeline); tmp[3] = strval(result);
					cache_get_field_content(index, "SVIPVoucher", result, MainPipeline); tmp[4] = strval(result);
					cache_get_field_content(index, "GVIPVoucher", result, MainPipeline); tmp[5] = strval(result);
					cache_get_field_content(index, "PVIPVoucher", result, MainPipeline); tmp[6] = strval(result);
					cache_get_field_content(index, "credits_spent", result, MainPipeline); tmp[7] = strval(result);

					if(tmp[1] > 0)
					{
						PlayerInfo[playerid][pGiftVoucher] += tmp[1];
						format(string, sizeof(string), "Ban da tu dong duoc cap %d gift reset voucher(s).", tmp[1]);
						SendClientMessageEx(playerid, COLOR_WHITE, string);
						format(string, sizeof(string), "[ID: %d] %s da tu dong duoc cap %d gift reset voucher(s)", tmp[0], GetPlayerNameEx(playerid), tmp[1]);
						Log("logs/shoplog.log", string);
					}
					if(tmp[2] > 0)
					{
						PlayerInfo[playerid][pCarVoucher] += tmp[2];
						format(string, sizeof(string), "Ban da tu dong duoc cap %d restricted car voucher(s).", tmp[2]);
						SendClientMessageEx(playerid, COLOR_WHITE, string);
						format(string, sizeof(string), "[ID: %d] %s da tu dong duoc cap %d restricted car voucher(s)", tmp[0], GetPlayerNameEx(playerid), tmp[2]);
						Log("logs/shoplog.log", string);
					}
					if(tmp[3] > 0)
					{
						PlayerInfo[playerid][pVehVoucher] += tmp[3];
						format(string, sizeof(string), "Ban da tu dong duoc cap %d car voucher(s).", tmp[3]);
						SendClientMessageEx(playerid, COLOR_WHITE, string);
						format(string, sizeof(string), "[ID: %d] %s da tu dong duoc cap %d car voucher(s)", tmp[0], GetPlayerNameEx(playerid), tmp[3]);
						Log("logs/shoplog.log", string);
					}
					if(tmp[4] > 0)
					{
						PlayerInfo[playerid][pSVIPVoucher] += tmp[4];
						format(string, sizeof(string), "Ban da tu dong duoc cap %d Silver VIP voucher(s).", tmp[4]);
						SendClientMessageEx(playerid, COLOR_WHITE, string);
						format(string, sizeof(string), "[ID: %d] %s da tu dong duoc cap %d Silver VIP voucher(s)", tmp[0], GetPlayerNameEx(playerid), tmp[4]);
						Log("logs/shoplog.log", string);
					}
					if(tmp[5] > 0)
					{
						PlayerInfo[playerid][pGVIPVoucher] += tmp[5];
						format(string, sizeof(string), "Ban da tu dong duoc cap %d Gold VIP voucher(s).", tmp[5]);
						SendClientMessageEx(playerid, COLOR_WHITE, string);
						format(string, sizeof(string), "[ID: %d] %s da tu dong duoc cap %d Gold VIP voucher(s)", tmp[0], GetPlayerNameEx(playerid), tmp[5]);
						Log("logs/shoplog.log", string);
					}
					if(tmp[6] > 0)
					{
						PlayerInfo[playerid][pPVIPVoucher] += tmp[6];
						format(string, sizeof(string), "Ban da tu dong duoc cap %d Platinum VIP voucher(s).", tmp[6]);
						SendClientMessageEx(playerid, COLOR_WHITE, string);
						format(string, sizeof(string), "[ID: %d] %s da tu dong duoc cap %d Platinum VIP voucher(s)", tmp[0], GetPlayerNameEx(playerid), tmp[6]);
						Log("logs/shoplog.log", string);
					}

					PlayerInfo[playerid][pCredits] -= tmp[7];
					format(query, sizeof(query), "UPDATE `shop_orders` SET `status` = 1 WHERE `id` = %d", tmp[0]);
					mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
					OnPlayerStatsUpdate(playerid);
					return SendClientMessageEx(playerid, COLOR_CYAN, "* Su dung /myvouchers de kiem tra va su dung vouchers cua ban bat cu luc nap!");
				}
			}
		}
		case 1:
		{
			cache_get_data(rows, fields, ShopPipeline);
			if(IsPlayerConnected(playerid))
			{
				while(index < rows)
				{
					cache_get_field_content(index, "order_id", result, ShopPipeline); tmp[0] = strval(result);
					cache_get_field_content(index, "credit_amount", result, ShopPipeline); tmp[1] = strval(result);

					PlayerInfo[playerid][pCredits] += tmp[1];
					format(string, sizeof(string), "Ban da tu dong duoc cap %s credit(s).", number_format(tmp[1]));
					SendClientMessageEx(playerid, COLOR_WHITE, string);
					format(string, sizeof(string), "[ID: %d] %s da duoc tu dong cap %s credit(s)", tmp[0], GetPlayerNameEx(playerid), number_format(tmp[1]));
					Log("logs/shoplog.log", string);
					format(query, sizeof(query), "UPDATE `order_delivery_status` SET `status` = 1 WHERE `order_id` = %d", tmp[0]);
					mysql_function_query(ShopPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
					OnPlayerStatsUpdate(playerid);
					return 1;
				}
			}
		}
	}
	return 1;
}

stock CheckAdminWhitelist(playerid)
{
	new string[128];
	format(string, sizeof(string), "SELECT `AdminLevel`, `SecureIP` FROM `accounts` WHERE `Username` = '%s'", GetPlayerNameExt(playerid));
	mysql_function_query(MainPipeline, string, true, "OnQueryFinish", "iii", ADMINWHITELIST_THREAD, playerid, g_arrQueryHandle{playerid});
	return true;
}
stock GivePlayerMoneyEx(playerid, amount)
{
	new string[50];
	if(amount > 0) {
		format(string, sizeof string, "~g~$+%s", number_format(amount));
	}
	else if(amount <= 0) {
		format(string, sizeof string, "~r~$%s", number_format(amount));
	}
	
	PlayerInfo[playerid][pCash] += amount;
	ShowItemMessage(playerid,1212,string,10);
    return 1;
}
stock GivePlayerCashEx(playerid, type, amount)
{
	if(IsPlayerConnected(playerid) && gPlayerLogged{playerid})
	{
		new szQuery[128];
		switch(type)
		{
			case TYPE_BANK:
			{
				PlayerInfo[playerid][pAccount] += amount;
				format(szQuery, sizeof(szQuery), "UPDATE `accounts` SET `Bank`=%d WHERE `id` = %d", PlayerInfo[playerid][pAccount], GetPlayerSQLId(playerid));
				mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
			}
			case TYPE_ONHAND:
			{
				PlayerInfo[playerid][pCash] += amount;
				format(szQuery, sizeof(szQuery), "UPDATE `accounts` SET `Money`=%d WHERE `id` = %d", PlayerInfo[playerid][pCash], GetPlayerSQLId(playerid));
				mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
			}
		}
	}
	return 1;
}

stock PointCrashProtection(point)
{
	new query[128], temp;
	temp = Points[point][ClaimerTeam];
	if(temp == INVALID_PLAYER_ID)
	{
		temp = INVALID_FAMILY_ID;
	}
	format(query, sizeof(query), "UPDATE `points` SET `captime` = %d, `capfam` = %d, `capname` = '%s' WHERE `id` = %d",Points[point][TakeOverTimer], temp, Points[point][PlayerNameCapping], Points[point][pointID]);
	mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	return 1;
}

// g_mysql_LoadGiftBox()
// Description: Loads the data of the dynamic giftbox from the SQL Database.
stock g_mysql_LoadGiftBox()
{
	print("[Dynamic Giftbox] Loading the Dynamic Giftbox...");
	mysql_function_query(MainPipeline, "SELECT * FROM `giftbox`", true, "OnQueryFinish", "iii", LOADGIFTBOX_THREAD, INVALID_PLAYER_ID, -1);
}

stock SaveDynamicGiftBox()
{
	new query[4096];
	for(new i = 0; i < 4; i++)
	{
		if(i == 0)
			format(query, sizeof(query), "UPDATE `giftbox` SET `dgMoney%d` = '%d',", i, dgMoney[i]);
		else
			format(query, sizeof(query), "%s `dgMoney%d` = '%d',", query, i, dgMoney[i]);

		format(query, sizeof(query), "%s `dgRimKit%d` = '%d',", query, i, dgRimKit[i]);
		format(query, sizeof(query), "%s `dgFirework%d` = '%d',", query, i, dgFirework[i]);
		format(query, sizeof(query), "%s `dgGVIP%d` = '%d',", query, i, dgGVIP[i]);
		format(query, sizeof(query), "%s `dgSVIP%d` = '%d',", query, i, dgSVIP[i]);
		format(query, sizeof(query), "%s `dgGVIPEx%d` = '%d',", query, i, dgGVIPEx[i]);
		format(query, sizeof(query), "%s `dgSVIPEx%d` = '%d',", query, i, dgSVIPEx[i]);
		format(query, sizeof(query), "%s `dgCarSlot%d` = '%d',", query, i, dgCarSlot[i]);
		format(query, sizeof(query), "%s `dgToySlot%d` = '%d',", query, i, dgToySlot[i]);
		format(query, sizeof(query), "%s `dgArmor%d` = '%d',", query, i, dgArmor[i]);
		format(query, sizeof(query), "%s `dgFirstaid%d` = '%d',", query, i, dgFirstaid[i]);
		format(query, sizeof(query), "%s `dgDDFlag%d` = '%d',", query, i, dgDDFlag[i]);
		format(query, sizeof(query), "%s `dgGateFlag%d` = '%d',", query, i, dgGateFlag[i]);
		format(query, sizeof(query), "%s `dgCredits%d` = '%d',", query, i, dgCredits[i]);
		format(query, sizeof(query), "%s `dgPriorityAd%d` = '%d',", query, i, dgPriorityAd[i]);
		format(query, sizeof(query), "%s `dgHealthNArmor%d` = '%d',", query, i, dgHealthNArmor[i]);
		format(query, sizeof(query), "%s `dgGiftReset%d` = '%d',", query, i, dgGiftReset[i]);
		format(query, sizeof(query), "%s `dgMaterial%d` = '%d',", query, i, dgMaterial[i]);
		format(query, sizeof(query), "%s `dgWarning%d` = '%d',", query, i, dgWarning[i]);
		format(query, sizeof(query), "%s `dgPot%d` = '%d',", query, i, dgPot[i]);
		format(query, sizeof(query), "%s `dgCrack%d` = '%d',", query, i, dgCrack[i]);
		format(query, sizeof(query), "%s `dgPaintballToken%d` = '%d',", query, i, dgPaintballToken[i]);
		format(query, sizeof(query), "%s `dgVIPToken%d` = '%d',", query, i, dgVIPToken[i]);
		format(query, sizeof(query), "%s `dgRespectPoint%d` = '%d',", query, i, dgRespectPoint[i]);
		format(query, sizeof(query), "%s `dgCarVoucher%d` = '%d',", query, i, dgCarVoucher[i]);
		format(query, sizeof(query), "%s `dgBuddyInvite%d` = '%d',", query, i, dgBuddyInvite[i]);
		format(query, sizeof(query), "%s `dgLaser%d` = '%d',", query, i, dgLaser[i]);
		format(query, sizeof(query), "%s `dgCustomToy%d` = '%d',", query, i, dgCustomToy[i]);
		format(query, sizeof(query), "%s `dgAdmuteReset%d` = '%d',", query, i, dgAdmuteReset[i]);
		format(query, sizeof(query), "%s `dgNewbieMuteReset%d` = '%d',", query, i, dgNewbieMuteReset[i]);

		if(i == 3)
			format(query, sizeof(query), "%s `dgRestrictedCarVoucher%d` = '%d'", query, i, dgRestrictedCarVoucher[i]);
		else
			format(query, sizeof(query), "%s `dgPlatinumVIPVoucher%d` = '%d',", query, i, dgPlatinumVIPVoucher[i]);
	}

	mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
}
forward OnPlayerLoad(playerid);
public OnPlayerLoad(playerid)
{
	new string[128];
//	AddBasicItem(playerid);
	if(PlayerInfo[playerid][pOnline] != 0)
	{
	    if(PlayerInfo[playerid][pOnline] != servernumber)
	    {
		    SendClientMessageEx(playerid, COLOR_WHITE, "(SERVER) Tai khoan nay dang truc tuyen!");
			SetTimerEx("KickEx", 1000, 0, "i", playerid);
			return 1;
		}
	}
	if(PlayerInfo[playerid][pBanTime] > 1 && PlayerInfo[playerid][pBanned] == 1 && (PlayerInfo[playerid][pBanTime] > gettime()) )
	{
			new datestring[32], str[2460], str1[1280], name[1280];
	        datestring = date(PlayerInfo[playerid][pBanTime], 1);
			format(str1, sizeof(str), "{FF1818}Tai khoan da bi khoa !\n{4ED7FF}Ten: {FFFFFF}%s\n{4ED7FF}IP: {FFFFFF}%s\n{4ED7FF}Ly do: {FFFFFF}%s\n{4ED7FF}Bi banned boi: {FFFFFF}%s\n{4ED7FF}Thoi gian Banned: {FF1818}%s \n\
			{4ED7FF}Thoi gian mo khoa: {0EA31B}%s{FFFFFF}\nHe thong se tu Unban khi het thoi gian Banned.", GetPlayerNameEx(playerid),GetPlayerIpEx(playerid), PlayerInfo[playerid][pReasonBanned], PlayerInfo[playerid][pBannedBy], date(PlayerInfo[playerid][pTimeBanned], 1), datestring);
		    format(str, sizeof(str), "%s", str1);
		    format(name, sizeof(name), "Banned");
			ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, name, str, "OK", "");
		    SetTimerEx("KickEx", 1000, 0, "i", playerid);
	        return 1;
	}
	GetPlayerIp(playerid, PlayerInfo[playerid][pIP], 16);
	if( PlayerInfo[playerid][pPermaBanned] == 3)
	{
		format(string, sizeof(string), "CANH BAO: %s (IP:%s) dang co gang dang nhap tai khoan bi permaban!.", GetPlayerNameEx( playerid ), PlayerInfo[playerid][pIP] );
		ABroadCast(COLOR_YELLOW, string, 2);
		SendClientMessageEx(playerid, COLOR_RED, "Tai khoan cua ban bi permaban! Khang cao tren forum.");
		SystemBan(playerid, "[System] (Da co rang dang nhap trong khi dang bi cam)");
		Log("logs/ban.log", string);
		SetTimerEx("KickEx", 1000, 0, "i", playerid);
		return 1;
	}

	if(PlayerInfo[playerid][pDisabled] != 0)
	{
		if( PlayerInfo[playerid][pBanAppealer] > 1) PlayerInfo[playerid][pBanAppealer] = 0;
		if( PlayerInfo[playerid][pShopTech] > 1) PlayerInfo[playerid][pShopTech] = 0;
		if( PlayerInfo[playerid][pUndercover] > 1) PlayerInfo[playerid][pUndercover] = 0;
		if( PlayerInfo[playerid][pFactionModerator] > 1) PlayerInfo[playerid][pFactionModerator] = 0;
		if( PlayerInfo[playerid][pGangModerator] > 1) PlayerInfo[playerid][pGangModerator] = 0;
		if( PlayerInfo[playerid][pPR] > 1) PlayerInfo[playerid][pPR] = 0;
		SendClientMessageEx(playerid, COLOR_WHITE, "(SERVER) Tai khoan bi vo hieu hoa!");
		SetTimerEx("KickEx", 1000, 0, "i", playerid);
		return 1;
	}

	if((PlayerInfo[playerid][pMember] != INVALID_GROUP_ID && arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance] == 2) && PlayerInfo[playerid][pNation] == 0)
	{
		PlayerInfo[playerid][pNation] = 1;
	}
	TotalLogin++;

	SetPlayerScore(playerid, PlayerInfo[playerid][pLevel]);
	if(PlayerInfo[playerid][pReg] == 0)
	{
		for(new v = 0; v < MAX_PLAYERVEHICLES; v++)
		{
			PlayerVehicleInfo[playerid][v][pvModelId] = 0;
			PlayerVehicleInfo[playerid][v][pvPosX] = 0.0;
			PlayerVehicleInfo[playerid][v][pvPosY] = 0.0;
			PlayerVehicleInfo[playerid][v][pvPosZ] = 0.0;
			PlayerVehicleInfo[playerid][v][pvPosAngle] = 0.0;
			PlayerVehicleInfo[playerid][v][pvLock] = 0;
			PlayerVehicleInfo[playerid][v][pvLocked] = 0;
			PlayerVehicleInfo[playerid][v][pvPaintJob] = -1;
			PlayerVehicleInfo[playerid][v][pvColor1] = 0;
			PlayerVehicleInfo[playerid][v][pvImpounded] = 0;
			PlayerVehicleInfo[playerid][v][pvSpawned] = 0;
			PlayerVehicleInfo[playerid][v][pvColor2] = 0;
			PlayerVehicleInfo[playerid][v][pvPrice] = 0;
			PlayerVehicleInfo[playerid][v][pvTicket] = 0;
			PlayerVehicleInfo[playerid][v][pvWeapons][0] = 0;
			PlayerVehicleInfo[playerid][v][pvWeapons][1] = 0;
			PlayerVehicleInfo[playerid][v][pvWeapons][2] = 0;
            PlayerVehicleInfo[playerid][v][pvAmmos][0] = 0;
			PlayerVehicleInfo[playerid][v][pvAmmos][1] = 0;
			PlayerVehicleInfo[playerid][v][pvAmmos][2] = 0;
			PlayerVehicleInfo[playerid][v][pvWepUpgrade] = 0;
			PlayerVehicleInfo[playerid][v][pvFuel] = 0.0;
			PlayerVehicleInfo[playerid][v][pvAllowedPlayerId] = INVALID_PLAYER_ID;
			PlayerVehicleInfo[playerid][v][pvPark] = 0;
			ListItemReleaseId[playerid][v] = -1;
			PlayerVehicleInfo[playerid][v][pvDisabled] = 0;
			PlayerVehicleInfo[playerid][v][pvPlate] = 0;
			PlayerVehicleInfo[playerid][v][pvVW] = 0;
			PlayerVehicleInfo[playerid][v][pvInt] = 0;
			ListItemTrackId[playerid][v] = -1;
			for(new m = 0; m < MAX_MODS; m++)
			{
				PlayerVehicleInfo[playerid][v][pvMods][m] = 0;
			}
		}
		for(new v = 0; v < MAX_PLAYERTOYS; v++)
		{
			PlayerToyInfo[playerid][v][ptModelID] = 0;
			PlayerToyInfo[playerid][v][ptBone] = 0;
			PlayerToyInfo[playerid][v][ptTradable] = 0;
			PlayerToyInfo[playerid][v][ptPosX] = 0.0;
			PlayerToyInfo[playerid][v][ptPosY] = 0.0;
			PlayerToyInfo[playerid][v][ptPosZ] = 0.0;
			PlayerToyInfo[playerid][v][ptRotX] = 0.0;
			PlayerToyInfo[playerid][v][ptRotY] = 0.0;
			PlayerToyInfo[playerid][v][ptRotZ] = 0.0;
			PlayerToyInfo[playerid][v][ptScaleX] = 1.0;
			PlayerToyInfo[playerid][v][ptScaleY] = 1.0;
			PlayerToyInfo[playerid][v][ptScaleZ] = 1.0;
			PlayerToyInfo[playerid][v][ptSpecial] = 0;
		}

		PlayerInfo[playerid][pTokens] = 0;
		PlayerInfo[playerid][pSecureIP][0] = 0;
		PlayerInfo[playerid][pCrates] = 0;
		PlayerInfo[playerid][pOrder] = 0;
		PlayerInfo[playerid][pOrderConfirmed] = 0;
		PlayerInfo[playerid][pRacePlayerLaps] = 0;
		PlayerInfo[playerid][pSprunk] = 0;
		PlayerInfo[playerid][pSpraycan] = 0;
		PlayerInfo[playerid][pCigar] = 0;
		PlayerInfo[playerid][pConnectSeconds] = 0;
		PlayerInfo[playerid][pPayDayHad] = 0;
		PlayerInfo[playerid][pCDPlayer] = 0;
		PlayerInfo[playerid][pWins] = 0;
		PlayerInfo[playerid][pLoses] = 0;
		PlayerInfo[playerid][pTut] = 0;
		PlayerInfo[playerid][pWarns] = 0;
		PlayerInfo[playerid][pRope] = 0;
		PlayerInfo[playerid][pDice] = 0;
		PlayerInfo[playerid][pScrewdriver] = 0;
		PlayerInfo[playerid][pWantedLevel] = 0;
		PlayerInfo[playerid][pInsurance] = 1;
		PlayerInfo[playerid][pDutyHours] = 0;
		PlayerInfo[playerid][pAcceptedHelp] = 0;
		PlayerInfo[playerid][pAcceptReport] = 0;
		PlayerInfo[playerid][pShopTechOrders] = 0;
		PlayerInfo[playerid][pTrashReport] = 0;
		PlayerInfo[playerid][pGiftTime] = 0;
		PlayerInfo[playerid][pTicketTime] = 0;
		PlayerInfo[playerid][pServiceTime] = 0;
		PlayerInfo[playerid][pFirework] = 0;
		PlayerInfo[playerid][pBoombox] = 0;
		PlayerInfo[playerid][pCash] = 1000;
		PlayerInfo[playerid][pLevel] = 1;
		PlayerInfo[playerid][pTruyDuoi] = 0;
		PlayerInfo[playerid][pAdmin] = 0;
		PlayerInfo[playerid][pHelper] = 0;
		PlayerInfo[playerid][pSMod] = 0;
		PlayerInfo[playerid][pWatchdog] = 0;
		PlayerInfo[playerid][pBanned] = 0;
		PlayerInfo[playerid][pDisabled] = 0;
		PlayerInfo[playerid][pMuted] = 0;
		PlayerInfo[playerid][pRMuted] = 0;
		PlayerInfo[playerid][pRMutedTotal] = 0;
		PlayerInfo[playerid][pRMutedTime] = 0;
		PlayerInfo[playerid][pDMRMuted] = 0;
		PlayerInfo[playerid][pNMute] = 0;
		PlayerInfo[playerid][pNMuteTotal] = 0;
		PlayerInfo[playerid][pADMute] = 0;
		PlayerInfo[playerid][pADMuteTotal] = 0;
		PlayerInfo[playerid][pHelpMute] = 0;
		PlayerInfo[playerid][pVMutedTime] = 0;
		PlayerInfo[playerid][pVMuted] = 0;
		PlayerInfo[playerid][pRadio] = 0;
		PlayerInfo[playerid][pRadioFreq] = 0;
		PlayerInfo[playerid][pPermaBanned] = 0;
		PlayerInfo[playerid][pDonateRank] = 0;
		PlayerInfo[playerid][gPupgrade] = 0;
		PlayerInfo[playerid][pConnectHours] = 0;
		PlayerInfo[playerid][pReg] = 0;
		PlayerInfo[playerid][pSex] = 0;
		strcpy(PlayerInfo[playerid][pBirthDate], "0000-00-00", 64);
		PlayerInfo[playerid][pRingtone] = 0;
		PlayerInfo[playerid][pVIPM] = 0;
		PlayerInfo[playerid][pVIPMO] = 0;
		PlayerInfo[playerid][pVIPExpire] = 0;
		PlayerInfo[playerid][pBanTime] = 0;
		PlayerInfo[playerid][pGVip] = 0;
		PlayerInfo[playerid][pHydration] = 100;
		PlayerInfo[playerid][pDoubleEXP] = 0;
		PlayerInfo[playerid][pEXPToken] = 0;
		PlayerInfo[playerid][pExp] = 0;
		PlayerInfo[playerid][pAccount] = 0;
		PlayerInfo[playerid][pCrimes] = 0;
		PlayerInfo[playerid][pDeaths] = 0;
		PlayerInfo[playerid][pArrested] = 0;
		PlayerInfo[playerid][pPhoneBook] = 0;
		PlayerInfo[playerid][pLottoNr] = 0;
		PlayerInfo[playerid][pFishes] = 0;
		PlayerInfo[playerid][pGcoin] = 0;
		PlayerInfo[playerid][pBiggestFish] = 0;
		PlayerInfo[playerid][pJob] = 0;
		PlayerInfo[playerid][pJob2] = 0;
		PlayerInfo[playerid][pPayCheck] = 0;
		PlayerInfo[playerid][pHeadValue] = 0;
		PlayerInfo[playerid][pJailTime] = 0;
		PlayerInfo[playerid][pWRestricted] = 0;
		PlayerInfo[playerid][pMats] = 0;
		PlayerInfo[playerid][pNation] = -1;
		PlayerInfo[playerid][pLeader] = INVALID_GROUP_ID;
		PlayerInfo[playerid][pMember] = INVALID_GROUP_ID;
		PlayerInfo[playerid][pBusiness] = INVALID_BUSINESS_ID;
		PlayerInfo[playerid][pDivision] = INVALID_DIVISION;
		PlayerInfo[playerid][pFMember] = INVALID_FAMILY_ID;
		PlayerInfo[playerid][pRank] = INVALID_RANK;
		PlayerInfo[playerid][pRenting] = INVALID_HOUSE_ID;
		PlayerInfo[playerid][pDetSkill] = 0;
		PlayerInfo[playerid][pSexSkill] = 0;
		PlayerInfo[playerid][pBoxSkill] = 0;
		PlayerInfo[playerid][pLawSkill] = 0;
		PlayerInfo[playerid][pMechSkill] = 0;
		PlayerInfo[playerid][pTruckSkill] = 0;
		PlayerInfo[playerid][pDrugsSkill] = 0;
		PlayerInfo[playerid][pArmsSkill] = 0;
		PlayerInfo[playerid][pSmugSkill] = 0;
		PlayerInfo[playerid][pFishSkill] = 0;
		PlayerInfo[playerid][pSHealth] = 0.0;
		PlayerInfo[playerid][pHealth] = 50.0;
		PlayerInfo[playerid][pCheckCash] = 0;
		PlayerInfo[playerid][pChecks] = 0;
		PlayerInfo[playerid][pWeedObject] = 0;
		PlayerInfo[playerid][pWSeeds] = 0;
		PlayerInfo[playerid][pWarrant][0] = 0;
		PlayerInfo[playerid][pContractBy][0] = 0;
		PlayerInfo[playerid][pContractDetail] = 0;
		PlayerInfo[playerid][pJudgeJailTime] = 0;
		PlayerInfo[playerid][pJudgeJailType] = 0;
		PlayerInfo[playerid][pBeingSentenced] = 0;
		PlayerInfo[playerid][pProbationTime] = 0;
		PlayerInfo[playerid][pModel] = 311;
		PlayerInfo[playerid][pPnumber] = 0;
		PlayerInfo[playerid][pPhousekey] = INVALID_HOUSE_ID;
		PlayerInfo[playerid][pPhousekey2] = INVALID_HOUSE_ID;
		PlayerInfo[playerid][pCarLic] = 0;
		PlayerInfo[playerid][pFlyLic] = 0;
		PlayerInfo[playerid][pBoatLic] = 0;
		PlayerInfo[playerid][pFishLic] = 0;
		PlayerInfo[playerid][pGunLic] = 0;
		PlayerInfo[playerid][pTaxiLicense] = 0;
		PlayerInfo[playerid][pBugged] = INVALID_GROUP_ID;
		PlayerInfo[playerid][pCallsAccepted] = 0;
		PlayerInfo[playerid][pPatientsDelivered] = 0;
		PlayerInfo[playerid][pLiveBanned] = 0;
		PlayerInfo[playerid][pFreezeBank] = 0;
		PlayerInfo[playerid][pFreezeHouse] = 0;
		PlayerInfo[playerid][pFreezeCar] = 0;
		strcpy(PlayerInfo[playerid][pAutoTextReply], "Nothing", 64);
        PlayerInfo[playerid][pLevel] = 1;
		PlayerInfo[playerid][pSHealth] = 0.0;
		PlayerInfo[playerid][pPnumber] = 0;
		PlayerInfo[playerid][pPhousekey] = INVALID_HOUSE_ID;
		PlayerInfo[playerid][pPhousekey2] = INVALID_HOUSE_ID;
		PlayerInfo[playerid][pAccount] = 0;
		PlayerInfo[playerid][pGangWarn] = 0;
		PlayerInfo[playerid][pPaintTokens] = 0;
		PlayerInfo[playerid][pTogReports] = 0;
		PlayerInfo[playerid][pCHits] = 0;
		PlayerInfo[playerid][pFHits] = 0;
		PlayerInfo[playerid][pAccent] = 1;
		PlayerInfo[playerid][pCSFBanned] = 0;
		PlayerInfo[playerid][pWristwatch] = 0;
		PlayerInfo[playerid][pSurveillance] = 0;
		PlayerInfo[playerid][pTire] = 0;
		PlayerInfo[playerid][pFirstaid] = 0;
		PlayerInfo[playerid][pRccam] = 0;
		PlayerInfo[playerid][pReceiver] = 0;
		PlayerInfo[playerid][pGPS] = 0;
		PlayerInfo[playerid][pSweep] = 0;
		PlayerInfo[playerid][pSweepLeft] = 0;
		PlayerInfo[playerid][pTreasureSkill] = 0;
		PlayerInfo[playerid][pMetalDetector] = 0;
		PlayerInfo[playerid][pHelpedBefore] = 0;
		PlayerInfo[playerid][pTrickortreat] = 0;
		PlayerInfo[playerid][pRHMutes] = 0;
		PlayerInfo[playerid][pRHMuteTime] = 0;
		PlayerInfo[playerid][pCredits] = 0;
        PlayerInfo[playerid][pReceivedCredits] = 0;
		PlayerInfo[playerid][pTotalCredits] = 0;
		PlayerInfo[playerid][pHasTazer] = 0;
		PlayerInfo[playerid][pHasCuff] = 0;
		PlayerInfo[playerid][pCarVoucher] = 0;
		strcpy(PlayerInfo[playerid][pGiongNoi], "None", 50);
		strcpy(PlayerInfo[playerid][pReferredBy], "Nobody", MAX_PLAYER_NAME);
		PlayerInfo[playerid][pPendingRefReward] = 0;
		PlayerInfo[playerid][pRefers] = 0;
		PlayerInfo[playerid][pFamed] = 0;
		PlayerInfo[playerid][pFMuted] = 0;
		PlayerInfo[playerid][pDefendTime] = 0;
		PlayerInfo[playerid][pVehicleSlot] = 0;
		PlayerInfo[playerid][pToySlot] = 0;
		PlayerInfo[playerid][pVehVoucher] = 0;
		PlayerInfo[playerid][pSVIPVoucher] = 0;
		PlayerInfo[playerid][pGVIPVoucher] = 0;
		PlayerInfo[playerid][pFallIntoFun] = 0;
		PlayerInfo[playerid][pHungerVoucher] = 0;
		PlayerInfo[playerid][pAdvertVoucher] = 0;
		PlayerInfo[playerid][pShopCounter] = 0;
		PlayerInfo[playerid][pShopNotice] = 0;
		PlayerInfo[playerid][pSVIPExVoucher] = 0;
		PlayerInfo[playerid][pGVIPExVoucher] = 0;
		PlayerInfo[playerid][pVIPSellable] = 0;
		PlayerInfo[playerid][pReceivedPrize] = 0;
		PlayerInfo[playerid][pReg] = 1;
	}

	if(PlayerInfo[playerid][pHospital] == 1)
    {
        PlayerInfo[playerid][pHospital] = 0;
        AcceptDeath[playerid] = 1;
        //SetPVarInt(playerid, "MedicBill", 1);
    }

	if(PlayerInfo[playerid][pBanAppealer] >= 1 && PlayerInfo[playerid][pAdmin] < 2) PlayerInfo[playerid][pBanAppealer] = 0;
	if(PlayerInfo[playerid][pPR] >= 1 && PlayerInfo[playerid][pAdmin] < 2) PlayerInfo[playerid][pPR] = 0;
	if(PlayerInfo[playerid][pShopTech] >= 1 && PlayerInfo[playerid][pAdmin] < 2) PlayerInfo[playerid][pShopTech] = 0;
	if(PlayerInfo[playerid][pUndercover] >= 1 && PlayerInfo[playerid][pAdmin] < 2) PlayerInfo[playerid][pUndercover] = 0;
	if(PlayerInfo[playerid][pFactionModerator] >= 1 && PlayerInfo[playerid][pAdmin] < 2) PlayerInfo[playerid][pFactionModerator] = 0;
	if(PlayerInfo[playerid][pGangModerator] >= 1 && PlayerInfo[playerid][pAdmin] < 2) PlayerInfo[playerid][pGangModerator] = 0;
	if(PlayerInfo[playerid][pHelper] == 1 && PlayerInfo[playerid][pAdmin] >= 1) PlayerInfo[playerid][pHelper] = 0;
	if(gettime() >= PlayerInfo[playerid][pMechTime]) PlayerInfo[playerid][pMechTime] = 0;
	if(gettime() >= PlayerInfo[playerid][pLawyerTime]) PlayerInfo[playerid][pLawyerTime] = 0;
	if(gettime() >= PlayerInfo[playerid][pDrugsTime]) PlayerInfo[playerid][pDrugsTime] = 0;
	if(gettime() >= PlayerInfo[playerid][pSexTime]) PlayerInfo[playerid][pSexTime] = 0;

    HideMainMenuGUI(playerid);
//	HideNoticeGUIFrame(playerid);

	if(PlayerInfo[playerid][pVIPExpire] > 0 && (1 <= PlayerInfo[playerid][pDonateRank] <= 3) && (PlayerInfo[playerid][pVIPExpire] < gettime()))
	{
	    PlayerInfo[playerid][pVIPSellable] = 0;
	    format(string, sizeof(string), "[DEBUG] %s (%s) VIP het han (Thoi gian su dung VIP: %d | Level: %d)", GetPlayerNameEx(playerid), GetPlayerIpEx(playerid), PlayerInfo[playerid][pVIPExpire], PlayerInfo[playerid][pDonateRank]);
	    Log("logs/vipremove.log", string);
	    format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: Kiem tra VIP cua %s vi da het han.", GetPlayerNameEx(playerid));
		ABroadCast(COLOR_YELLOW, string, 4);
	    PlayerInfo[playerid][pDonateRank] = 0;
	    SendClientMessageEx(playerid, COLOR_YELLOW, "VIP cua ban da het han.");
	}
	SetTimerEx("CheckDiemDanh", 850*1, false, "i", playerid);
    if(PlayerInfo[playerid][pBanTime] > 1 && PlayerInfo[playerid][pBanned] == 1 && (PlayerInfo[playerid][pBanTime] < gettime()) )
	{
	    format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}:Tai khoan %s da het thoi gian banned", GetPlayerNameEx(playerid));
		ABroadCast(COLOR_YELLOW, string, 4);
  		PlayerInfo[playerid][pBanned] = 0;
  		PlayerInfo[playerid][pBanTime] = 0;
  		PlayerInfo[playerid][pTimeBanned] = 0;
	    SendClientMessageEx(playerid, COLOR_YELLOW, "Tai khoan cua ban da duoc mo khoa.");
	}
	if(PlayerInfo[playerid][pDoubleEXP] > 0 && DoubleXP)
	{
		format(string, sizeof(string), "Ban dang co nhan doi kinh nghiem %d gio cho den khi thoi gian nhan doi kinh nghiem ket thuc.", PlayerInfo[playerid][pDoubleEXP]);
		SendClientMessageEx(playerid, COLOR_RED, string);
	}

	if(PlayerInfo[playerid][pPendingRefReward] >= 1)
	{
	    new szQuery[128], szString[128];
	    if(PlayerInfo[playerid][pRefers] < 5 && PlayerInfo[playerid][pRefers] > 0)
	    {
		    PlayerInfo[playerid][pCredits] += CREDITS_AMOUNT_REFERRAL*PlayerInfo[playerid][pPendingRefReward];
			PlayerInfo[playerid][pPendingRefReward] = 0;
			PlayerInfo[playerid][pRefers]++;
			format(szQuery, sizeof(szQuery), "UPDATE `accounts` SET `Credits`=%d WHERE `Username` = '%s'", PlayerInfo[playerid][pCredits], GetPlayerNameExt(playerid));
			mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
			format(szString, sizeof(szString), "%s da nhan duoc %d credits cho viec gioi thieu nguoi choi (Nguoi choi dat level 3)", GetPlayerNameEx(playerid), CREDITS_AMOUNT_REFERRAL*PlayerInfo[playerid][pPendingRefReward]);
			Log("logs/referral.log", szString);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Nguoi ban gioi thieu da dat den level 3, ban nhan duoc 100 credits tu viec gioi thieu nguoi choi moi.");
		}
	    else if(PlayerInfo[playerid][pRefers] == 5)
	    {
		    PlayerInfo[playerid][pCredits] += CREDITS_AMOUNT_REFERRAL*5*PlayerInfo[playerid][pPendingRefReward];
			PlayerInfo[playerid][pPendingRefReward] = 0;
			PlayerInfo[playerid][pRefers]++;
			format(szQuery, sizeof(szQuery), "UPDATE `accounts` SET `Credits`=%d WHERE `Username` = '%s'", PlayerInfo[playerid][pCredits], GetPlayerNameExt(playerid));
			mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
			format(szString, sizeof(szString), "%s da nhan duoc %d credits cho viec gioi thieu nguoi choi (Nguoi choi dat level 3)", GetPlayerNameEx(playerid), CREDITS_AMOUNT_REFERRAL*5*PlayerInfo[playerid][pPendingRefReward]);
			Log("logs/referral.log", szString);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Nguoi ban gioi thieu da dat den level  3, ban nhan duoc 500 credits tu viec gioi thieu nguoi choi moi.");
		}
		else if(PlayerInfo[playerid][pRefers] < 10 && PlayerInfo[playerid][pRefers] > 5)
	    {
		    PlayerInfo[playerid][pCredits] += CREDITS_AMOUNT_REFERRAL*PlayerInfo[playerid][pPendingRefReward];
			PlayerInfo[playerid][pPendingRefReward] = 0;
			PlayerInfo[playerid][pRefers]++;
			format(szQuery, sizeof(szQuery), "UPDATE `accounts` SET `Credits`=%d WHERE `Username` = '%s'", PlayerInfo[playerid][pCredits], GetPlayerNameExt(playerid));
			mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
			format(szString, sizeof(szString), "%s da nhan duoc %d credits cho viec gioi thieu nguoi choi (Nguoi choi dat level 3)", GetPlayerNameEx(playerid), CREDITS_AMOUNT_REFERRAL*PlayerInfo[playerid][pPendingRefReward]);
			Log("logs/referral.log", szString);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Nguoi ban gioi thieu da dat den level 3, ban nhan duoc 100 credits tu viec gioi thieu nguoi choi moi");
		}
		else if(PlayerInfo[playerid][pRefers] == 10)
	    {
		    PlayerInfo[playerid][pCredits] += CREDITS_AMOUNT_REFERRAL*10*PlayerInfo[playerid][pPendingRefReward];
			PlayerInfo[playerid][pPendingRefReward] = 0;
			PlayerInfo[playerid][pRefers]++;
			format(szQuery, sizeof(szQuery), "UPDATE `accounts` SET `Credits`=%d WHERE `Username` = '%s'", PlayerInfo[playerid][pCredits], GetPlayerNameExt(playerid));
			mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
			format(szString, sizeof(szString), "%s da nhan duoc %d credits cho viec gioi thieu nguoi choi (Nguoi choi dat level 3)", GetPlayerNameEx(playerid), CREDITS_AMOUNT_REFERRAL*10*PlayerInfo[playerid][pPendingRefReward]);
			Log("logs/referral.log", szString);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Nguoi ban gioi thieu da dat den level 3, ban nhan duoc 1000 credits tu viec gioi thieu nguoi choi moi.");
		}
		else if(PlayerInfo[playerid][pRefers] < 15 && PlayerInfo[playerid][pRefers] > 10)
	    {
		    PlayerInfo[playerid][pCredits] += CREDITS_AMOUNT_REFERRAL*PlayerInfo[playerid][pPendingRefReward];
			PlayerInfo[playerid][pPendingRefReward] = 0;
			PlayerInfo[playerid][pRefers]++;
			format(szQuery, sizeof(szQuery), "UPDATE `accounts` SET `Credits`=%d WHERE `Username` = '%s'", PlayerInfo[playerid][pCredits], GetPlayerNameExt(playerid));
			mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
			format(szString, sizeof(szString), "%s da nhan duoc %d credits cho viec gioi thieu nguoi choi (Nguoi choi dat level 3)", GetPlayerNameEx(playerid), CREDITS_AMOUNT_REFERRAL*PlayerInfo[playerid][pPendingRefReward]);
			Log("logs/referral.log", szString);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Nguoi ban gioi thieu da dat den level 3, ban nhan duoc 100 credits.");
		}
		else if(PlayerInfo[playerid][pRefers] == 15)
	    {
		    PlayerInfo[playerid][pCredits] += CREDITS_AMOUNT_REFERRAL*15*PlayerInfo[playerid][pPendingRefReward];
			PlayerInfo[playerid][pPendingRefReward] = 0;
			PlayerInfo[playerid][pRefers]++;
			format(szQuery, sizeof(szQuery), "UPDATE `accounts` SET `Credits`=%d WHERE `Username` = '%s'", PlayerInfo[playerid][pCredits], GetPlayerNameExt(playerid));
			mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
			format(szString, sizeof(szString), "%s da nhan duoc %d credits cho viec gioi thieu nguoi choi (Nguoi choi dat level 3)", GetPlayerNameEx(playerid), CREDITS_AMOUNT_REFERRAL*15*PlayerInfo[playerid][pPendingRefReward]);
			Log("logs/referral.log", szString);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Nguoi ban gioi thieu da dat den level 3, ban nhan duoc 1500 credits.");
		}
		else if(PlayerInfo[playerid][pRefers] < 20 && PlayerInfo[playerid][pRefers] > 15)
	    {
		    PlayerInfo[playerid][pCredits] += CREDITS_AMOUNT_REFERRAL*PlayerInfo[playerid][pPendingRefReward];
			PlayerInfo[playerid][pPendingRefReward] = 0;
			PlayerInfo[playerid][pRefers]++;
			format(szQuery, sizeof(szQuery), "UPDATE `accounts` SET `Credits`=%d WHERE `Username` = '%s'", PlayerInfo[playerid][pCredits], GetPlayerNameExt(playerid));
			mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
			format(szString, sizeof(szString), "%s da nhan duoc %d credits cho viec gioi thieu nguoi choi (Nguoi choi dat level 3)", GetPlayerNameEx(playerid), CREDITS_AMOUNT_REFERRAL*PlayerInfo[playerid][pPendingRefReward]);
			Log("logs/referral.log", szString);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Nguoi ban gioi thieu da dat den level 3, ban nhan duoc 100 credits.");
		}
		else if(PlayerInfo[playerid][pRefers] == 20)
	    {
		    PlayerInfo[playerid][pCredits] += CREDITS_AMOUNT_REFERRAL*20*PlayerInfo[playerid][pPendingRefReward];
			PlayerInfo[playerid][pPendingRefReward] = 0;
			PlayerInfo[playerid][pRefers]++;
			format(szQuery, sizeof(szQuery), "UPDATE `accounts` SET `Credits`=%d WHERE `Username` = '%s'", PlayerInfo[playerid][pCredits], GetPlayerNameExt(playerid));
			mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
			format(szString, sizeof(szString), "%s da nhan duoc %d credits cho viec gioi thieu nguoi choi (Nguoi choi dat level 3)", GetPlayerNameEx(playerid), CREDITS_AMOUNT_REFERRAL*20*PlayerInfo[playerid][pPendingRefReward]);
			Log("logs/referral.log", szString);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Nguoi ban gioi thieu da dat den level 3, ban nhan duoc 2000 credits.");
		}
        else if(PlayerInfo[playerid][pRefers] < 25 && PlayerInfo[playerid][pRefers] > 20)
	    {
		    PlayerInfo[playerid][pCredits] += CREDITS_AMOUNT_REFERRAL*PlayerInfo[playerid][pPendingRefReward];
			PlayerInfo[playerid][pPendingRefReward] = 0;
			PlayerInfo[playerid][pRefers]++;
			format(szQuery, sizeof(szQuery), "UPDATE `accounts` SET `Credits`=%d WHERE `Username` = '%s'", PlayerInfo[playerid][pCredits], GetPlayerNameExt(playerid));
			mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
			format(szString, sizeof(szString), "%s da nhan duoc %d credits cho viec gioi thieu nguoi choi (Nguoi choi dat level 3)", GetPlayerNameEx(playerid), CREDITS_AMOUNT_REFERRAL*PlayerInfo[playerid][pPendingRefReward]);
			Log("logs/referral.log", szString);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Nguoi ban gioi thieu da dat den level 3, ban nhan duoc 100 credits.");
		}
		else if(PlayerInfo[playerid][pRefers] >= 25)
	    {
		    PlayerInfo[playerid][pCredits] += CREDITS_AMOUNT_REFERRAL*25*PlayerInfo[playerid][pPendingRefReward];
			PlayerInfo[playerid][pPendingRefReward] = 0;
			PlayerInfo[playerid][pRefers]++;
			format(szQuery, sizeof(szQuery), "UPDATE `accounts` SET `Credits`=%d WHERE `Username` = '%s'", PlayerInfo[playerid][pCredits], GetPlayerNameExt(playerid));
			mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
			format(szString, sizeof(szString), "%s da nhan duoc %d credits cho viec gioi thieu nguoi choi (Nguoi choi dat level 3)", GetPlayerNameEx(playerid), CREDITS_AMOUNT_REFERRAL*25*PlayerInfo[playerid][pPendingRefReward]);
			Log("logs/referral.log", szString);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Nguoi ban gioi thieu da dat den level 3, ban nhan duoc 2500 credits.");
		}
	}
	gPlayerLogged{playerid} = 1;
	if(PlayerInfo[playerid][pBusiness] >= 0 && Businesses[PlayerInfo[playerid][pBusiness]][bMonths] != 0)
	{
	    if(Businesses[PlayerInfo[playerid][pBusiness]][bMonths] < gettime())
	    {
	        new
				Business = PlayerInfo[playerid][pBusiness];

	        foreach(new j: Player) {
				if(PlayerInfo[j][pBusiness] == Business) {
					PlayerInfo[j][pBusiness] = INVALID_BUSINESS_ID;
					PlayerInfo[j][pBusinessRank] = 0;
					SendClientMessageEx(playerid, COLOR_WHITE, "Chu so huu da ban cua hang nay, doanh so cua hang cua ban se duoc thiet lap lai.");
				}
			}

			Businesses[Business][bOwner] = -1;
			Businesses[Business][bMonths] = 0;
			Businesses[Business][bValue] = 0;
			SaveBusiness(Business);
			RefreshBusinessPickup(Business);

			format(string, sizeof(string), "UPDATE `accounts` SET `Business` = " #INVALID_BUSINESS_ID ", `BusinessRank` = 0 WHERE `Business` = '%d'", Business);
			mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);

	        SendClientMessageEx(playerid, COLOR_RED, "Cua hang cua ban da het han so huu.");
	        format(string, sizeof(string), "[CUA HANG HET HAN] %s cua hang id %i da xoa bo hop dong su dung cua ban.", GetPlayerNameEx(playerid), Business);
			Log("logs/shoplog.log", string);

	    }
	    else if(Businesses[PlayerInfo[playerid][pBusiness]][bMonths] - 259200 < gettime())
	    {
	        SendClientMessageEx(playerid, COLOR_RED, "Cua hang cua ban da het han qua 3 ngay.");
	    }
	}
	if(PlayerInfo[playerid][pInjured] == 1)
    {
        format(string, sizeof(string), "(( Nguoi nay da bi thuong nhe, su dung '/helpup %i' de keo ho day ))", playerid);
   
        //TextDrawShowForPlayer(playerid, playerdeath[playerid]);
    }
    else if(PlayerInfo[playerid][pInjured] == 2)
    {
        format(string, sizeof(string), "(( Nguoi nay dang bi thuong nang, su dung '/damages %i' de xem them tinh trang ))", playerid);

        //TextDrawShowForPlayer(playerid, playerdeath[playerid]);
        DeathCooldown[playerid] = 200;
    }
    else if(PlayerInfo[playerid][pInjured] == 3)
    {
        format(string, sizeof(string), "(( THIS PLAYER IS DEAD ))", playerid);
        //TextDrawShowForPlayer(playerid, playerdeath[playerid]);
        DeathCooldown[playerid] = 300;
    }
	if(PlayerInfo[playerid][pJob2] >= 1 && (PlayerInfo[playerid][pDonateRank] < 1 && PlayerInfo[playerid][pFamed] < 1))
	{
		PlayerInfo[playerid][pJob2] = 0;
		SendClientMessageEx(playerid, COLOR_YELLOW, "Ban da bi mat cong viec phu do VIP/Famed da het han su dung.");
	}
	if(PlayerInfo[playerid][pDonateRank] >= 4 && PlayerInfo[playerid][pArmsSkill] < 400)
	{
		PlayerInfo[playerid][pArmsSkill] = 401;
		SendClientMessageEx(playerid, COLOR_YELLOW, "VIP Bach kim: Ban da duoc cho Level 5 dai ly buon ban.");
	}
	if (PlayerInfo[playerid][pLevel] < 6 || PlayerInfo[playerid][pHelper] > 0)
	{
		gNewbie[playerid] = 0;
	}
	if (PlayerInfo[playerid][pHelper] >= 1)
	{
		gHelp[playerid] = 0;
	}
	if (PlayerInfo[playerid][pAdmin] > 0)
	{
		if(PlayerInfo[playerid][pAdmin] == 1)
		{
			if(PlayerInfo[playerid][pSMod] == 1)
			{
				SendClientMessageEx(playerid, COLOR_WHITE,"(SERVER) Tai khoan dang dang nhap la {33AA33}Senior Moderator.");
				format( string, sizeof( string ), "(SERVER) %s da dang nhap Senior Moderator.", GetPlayerNameEx(playerid));
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_WHITE,"(SERVER) Tai khoan dang dang nhap la {33AA33}Moderator.");
				format(string, sizeof(string), "(SERVER) %s da dang nhap Moderator.", GetPlayerNameEx(playerid));
			}
		}
		else
		{
			format(string, sizeof(string), "[ADMIN] Admin %s(%d) da truy cap toi may chu.", GetPlayerNameEx(playerid), playerid);
		}

		foreach(new i: Player)
		{
			if(PlayerInfo[i][pAdmin] >= 1337 && PlayerInfo[i][pAdmin] >= PlayerInfo[playerid][pAdmin]) SendClientMessageEx(i, COLOR_WHITE, string);
		}
	}

	for(new i = 0; i < sizeof(GateInfo); i++)
	{
		if(GateInfo[i][gAutomate] == 1)
		{
			if(GateInfo[i][gFamilyID] != -1 && PlayerInfo[playerid][pFMember] == GateInfo[i][gFamilyID]) SetTimerEx("AutomaticGateTimer", 1000, false, "ii", playerid, i);
			else if(GateInfo[i][gGroupID] != -1 && (0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS) && PlayerInfo[playerid][pMember] == GateInfo[i][gGroupID]) SetTimerEx("AutomaticGateTimer", 1000, false, "ii", playerid, i);
			else if(GateInfo[i][gAllegiance] != 0 && GateInfo[i][gGroupType] != 0 && (0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS) && arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance] == GateInfo[i][gAllegiance] && arrGroupData[PlayerInfo[playerid][pMember]][g_iGroupType] == GateInfo[i][gGroupType]) SetTimerEx("AutomaticGateTimer", 1000, false, "ii", playerid, i);
			else if(GateInfo[i][gAllegiance] != 0 && GateInfo[i][gGroupType] == 0 && (0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS) && arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance] == GateInfo[i][gAllegiance]) SetTimerEx("AutomaticGateTimer", 1000, false, "ii", playerid, i);
			else if(GateInfo[i][gAllegiance] == 0 && GateInfo[i][gGroupType] != 0 && (0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS) && arrGroupData[PlayerInfo[playerid][pMember]][g_iGroupType] == GateInfo[i][gGroupType]) SetTimerEx("AutomaticGateTimer", 1000, false, "ii", playerid, i);
			else if(GateInfo[i][gAllegiance] == 0 && GateInfo[i][gGroupType] == 0 && GateInfo[i][gGroupID] == -1 && GateInfo[i][gFamilyID] == -1) SetTimerEx("AutomaticGateTimer", 1000, false, "ii", playerid, i);
		}
	}

	// Create the player necessary textdraws
	CreatePlayerTextDraws(playerid);
	printf("%s has logged in.", GetPlayerNameEx(playerid));
	//format(string, sizeof(string), "(SERVER) Chao mung, %s.", GetPlayerNameEx(playerid));
	SendClientMessageEx(playerid, COLOR_WHITE, string);
	SetPlayerVirtualWorld(playerid, PlayerInfo[playerid][pVW]);
	SetSpawnInfo(playerid, 0, PlayerInfo[playerid][pModel], PlayerInfo[playerid][pPos_x], PlayerInfo[playerid][pPos_y], PlayerInfo[playerid][pPos_z], 1.0, -1, -1, -1, -1, -1, -1);
	SpawnPlayer(playerid);
	defer SkinDelay(playerid);
	g_mysql_AccountOnline(playerid, servernumber);
	
	new ip[32];
	GetPlayerIp(playerid, ip, sizeof(ip));
	format(string, sizeof(string), "%s (ID: %d | SQL ID: %d | Level: %d | IP: %s) has logged in.", GetPlayerNameExt(playerid), playerid, GetPlayerSQLId(playerid), PlayerInfo[playerid][pLevel], ip);
	Log("logs/login.log", string);

	if(PlayerInfo[playerid][pAdmin] >= 2)
	{
		new tdate[11], thour[9], i_timestamp[3];
		getdate(i_timestamp[0], i_timestamp[1], i_timestamp[2]);
		format(tdate, sizeof(tdate), "%d-%02d-%02d", i_timestamp[0], i_timestamp[1], i_timestamp[2]);
		format(thour, sizeof(thour), "%02d:00:00", hour);
		GetReportCount(playerid, tdate);
		GetHourReportCount(playerid, thour, tdate);
	}

	if(PlayerInfo[playerid][pHelper] > 0)
	{
		new tdate[11], thour[9], i_timestamp[3];
		getdate(i_timestamp[0], i_timestamp[1], i_timestamp[2]);
		format(tdate, sizeof(tdate), "%d-%02d-%02d", i_timestamp[0], i_timestamp[1], i_timestamp[2]);
		format(thour, sizeof(thour), "%02d:00:00", hour);
		GetRequestCount(playerid, tdate);
		GetHourRequestCount(playerid, thour, tdate);
	}

	if(PlayerInfo[playerid][pWarns] >= 3)
	{
  		format(string, sizeof(string), "AdmCmd: %s (IP: %s) da bi cam dang nhap (3 canh bao)", GetPlayerNameEx(playerid), GetPlayerIpEx(playerid));
		Log("logs/ban.log", string);
		format(string, sizeof(string), "AdmCmd: %s da bi cam dang nhap (3 canh bao)", GetPlayerNameEx(playerid));
		SendClientMessageToAllEx(COLOR_LIGHTRED, string);
		PlayerInfo[playerid][pBanned] = 1;
		SystemBan(playerid, "[HE THONG] (Da co 3 canh bao)");
		MySQLBan(GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), "Canh bao thu Ba", 1, "He thong");
		SetTimerEx("KickEx", 1000, 0, "i", playerid);
		return 1;
	}
	TogglePlayerSpectating(playerid, 0);
	format(string, sizeof(string), "~r~LSRvn~w~, chao mung ban da tro lai voi may chu. Chuc ban co mot ngay tot lanh %s.", GetPlayerNameEx(playerid));
	ShowNotifyTextMain(playerid,string,6);
	SendClientMessageEx(playerid, COLOR_YELLOW, GlobalMOTD);
	PlayerTextDrawShow(playerid,Server@Logo[playerid][0]);
    PlayerTextDrawShow(playerid,Server@Logo[playerid][1]);
    SetPlayerTutorial(playerid);
	if(PlayerInfo[playerid][pAdmin] > 0) {
		if(PlayerInfo[playerid][pAdmin] >= 2) SendClientMessageEx(playerid, COLOR_YELLOW, AdminMOTD);
		SendClientMessageEx(playerid, TEAM_AZTECAS_COLOR, CAMOTD);
	}

	if(PlayerInfo[playerid][pDonateRank] >= 1)
	SendClientMessageEx(playerid, COLOR_VIP, VIPMOTD);

	if(PlayerInfo[playerid][pHelper] >= 1) {
		SendClientMessageEx(playerid, TEAM_AZTECAS_COLOR, CAMOTD);
		if(PlayerInfo[playerid][pHelper] >= 2) {
			SetPVarInt(playerid, "AdvisorDuty", 1);
			++Advisors;
		}
	}

	if(PlayerInfo[playerid][pInt] > 0 || PlayerInfo[playerid][pVW] > 0)
	{
	    TogglePlayerControllable(playerid, 1);
	}

	SetPlayerFightingStyle(playerid, PlayerInfo[playerid][pFightStyle]);

	LoadPlayerDisabledVehicles(playerid);

	SetPlayerToTeamColor(playerid);
	if(PlayerInfo[playerid][pLottoNr] > 0)
	{
	    CountTickets(playerid);
	    LoadTickets(playerid);
	}
	format(string, sizeof(string), "SELECT * FROM `rentedcars` WHERE `sqlid` = '%d'", GetPlayerSQLId(playerid));
	mysql_function_query(MainPipeline, string, true, "LoadRentedCar", "i", playerid);

	if(PlayerInfo[playerid][pFMember] == -1) { PlayerInfo[playerid][pFMember] = INVALID_FAMILY_ID; }
	if(PlayerInfo[playerid][pFMember] >= 0 && PlayerInfo[playerid][pFMember] < INVALID_FAMILY_ID)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "Family MOTD's:");
		for(new i = 1; i <= 3; i++)
		{
			format(string, sizeof(string), "%d: %s", i, FamilyMOTD[PlayerInfo[playerid][pFMember]][i-1]);
			SendClientMessageEx(playerid, COLOR_YELLOW, string);
		}
		for(new i = 0; i < MAX_POINTS; i++)
		{
			if(Points[i][CapCrash] == 1)
			{
				SendClientMessageEx(playerid, COLOR_YELLOW, "Point Crash Protection:");
				format(string, sizeof(string), "%s da co gang kiem soat %s cho gia dinh %s, no se la cua ho trong %d phut nua.", Points[i][PlayerNameCapping], Points[i][Name], FamilyInfo[Points[i][ClaimerTeam]][FamilyName], Points[i][TakeOverTimer]);
				SendClientMessageEx(playerid, COLOR_YELLOW, string);
			}
		}
	}
	if(0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS && arrGroupData[PlayerInfo[playerid][pMember]][g_szGroupMOTD][0])
	{
		format(string, sizeof(string), "MOTD: %s", arrGroupData[PlayerInfo[playerid][pMember]][g_szGroupMOTD]);
		SendClientMessageEx(playerid, arrGroupData[PlayerInfo[playerid][pMember]][g_hDutyColour] * 256 + 255, string);
	}
	CountFlags(playerid);
	if(PlayerInfo[playerid][pFlagged] > 5)
	{
		format(string, sizeof(string), "(SERVER) %s has %d outstanding flags.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pFlagged]);
		ABroadCast(COLOR_WHITE, string, 2);
	}
	LoadTreasureInventory(playerid);
	if(PlayerInfo[playerid][pOrder] > 0)
	{
		if(PlayerInfo[playerid][pOrderConfirmed] == 1)
		{
			format(string, sizeof(string), "(SERVER) %s has an outstanding shop (Confirmed) order.", GetPlayerNameEx(playerid));
			ShopTechBroadCast(COLOR_WHITE, string);
		}
		else
		{
			format(string, sizeof(string), "(SERVER) %s has an outstanding shop (Invalid) order.", GetPlayerNameEx(playerid));
			ShopTechBroadCast(COLOR_WHITE, string);
		}
	}

	new
	iCheckOne = INVALID_HOUSE_ID,
	iCheckTwo = INVALID_HOUSE_ID,
	szPlayerName[MAX_PLAYER_NAME];

	GetPlayerName(playerid, szPlayerName, sizeof(szPlayerName));

	for(new i = 0; i < MAX_HOUSES; ++i)
	{
		if(HouseInfo[i][hOwnerID] == PlayerInfo[playerid][pId])
		{
			if(iCheckOne != INVALID_HOUSE_ID) iCheckTwo = i;
			else if(iCheckTwo == INVALID_HOUSE_ID) iCheckOne = i;
			else break;
		}
	}
	if(iCheckOne != INVALID_HOUSE_ID) PlayerInfo[playerid][pPhousekey] = iCheckOne;
	else PlayerInfo[playerid][pPhousekey] = INVALID_HOUSE_ID;

	if(iCheckTwo != INVALID_HOUSE_ID) PlayerInfo[playerid][pPhousekey2] = iCheckTwo;
	else PlayerInfo[playerid][pPhousekey2] = INVALID_HOUSE_ID;
	printf("House Key player: %d, %d",PlayerInfo[playerid][pPhousekey],PlayerInfo[playerid][pPhousekey2] );

	if(PlayerInfo[playerid][pRenting] != INVALID_HOUSE_ID && (PlayerInfo[playerid][pPhousekey] != INVALID_HOUSE_ID || PlayerInfo[playerid][pPhousekey2] != INVALID_HOUSE_ID)) {
		PlayerInfo[playerid][pRenting] = INVALID_HOUSE_ID;
	}
	if(1 <= PlayerInfo[playerid][pDonateRank] <= 3  && PlayerInfo[playerid][pVIPExpire] > 0 && (PlayerInfo[playerid][pVIPExpire] - 259200 < gettime()))
    {
		SendClientMessageEx(playerid, COLOR_RED, "The VIP cua ban sap het han - mua them o shop credits! Go /vipdate de biet them thoi gian con lai.");
    }
	if(PlayerInfo[playerid][pRVehWarns] != 0 && PlayerInfo[playerid][pLastRVehWarn] + 2592000 < gettime()) {
		SendClientMessageEx(playerid, COLOR_WHITE, "Canh bao han che xe cua ban da het hieu luc!");
		PlayerInfo[playerid][pLastRVehWarn] = 0;
		PlayerInfo[playerid][pRVehWarns] = 0;
	}
	if(pMOTD[0]) { ShowPlayerDialog(playerid, PMOTDNOTICE, DIALOG_STYLE_MSGBOX, "Dong y", pMOTD, "Tu choi", ""); }
	else if(GetPVarInt(playerid, "NullEmail")) {
	ShowPlayerDialog(playerid, NULLEMAIL, DIALOG_STYLE_INPUT, "{3399FF}Dang ky E-Mail", "{FFFFFF}Xin vui long nhap dia chi E-mail hop le de lien ket voi tai khoan.\n\nLuu y: Cung cap mot dia chi email khong hop le tai khoan se bi cham dut tai khoan.", "Xac nhan", "Bo qua");
	}
    SetUnreadMailsNotification(playerid);
    #if defined zombiemode
   	if(zombieevent == 1)
	{
		format(string, sizeof(string), "SELECT `id` FROM `zombie` WHERE `id` = '%d'", GetPlayerSQLId(playerid));
		mysql_function_query(MainPipeline, string, true, "OnZombieCheck", "i", playerid);
	}
	#endif

	if(PlayerInfo[playerid][pWeedObject] != 0)
	{
	    for(new i; i < MAX_PLANTS; i++)
	    {
	        if(Plants[i][pOwner] == GetPlayerSQLId(playerid))
	        {
				return 1;
	        }
	    }
		PlayerInfo[playerid][pWeedObject] = 0;
 	}
 	ClearChatbox(playerid);
 

 	LoadInventory(playerid);
 	
    RegisterDiscord(playerid);
    Load_AC(playerid);
    TwoTempCheck(playerid);
 	SendClientMessageEx(playerid, 0xc9c4c4ff, "[WELCOME] Chao mung ban tro lai voi {ab5858}LSR{c9c4c4} - Los Santos Roleplay.");
    new string_log[229];
    format(string_log, sizeof(string_log), "[%s] %s đã đăng nhập vào máy chủ với nhân vật: %s. ", GetLogTime(),
    	GetDiscordUser(playerid),GetPlayerNameEx(playerid));         
    SendLogDiscordMSG(logs_login, string_log);
    GetHomeCount(playerid);
	return 1;
}

 //=======================[ VN-RP ROLEPLAY BY ARES CALLBACKS]============================
public Float:SetPlayerToFacePos(playerid, Float:X, Float:Y)
{
	new
		Float:pX1,
		Float:pY1,
		Float:pZ1,
		Float:ang;

	if(!IsPlayerConnected(playerid)) return 0.0;

	GetPlayerPos(playerid, pX1, pY1, pZ1);

	if( Y > pY1 ) ang = (-acos((X - pX1) / floatsqroot((X - pX1)*(X - pX1) + (Y - pY1)*(Y - pY1))) - 90.0);
	else if( Y < pY1 && X < pX1 ) ang = (acos((X - pX1) / floatsqroot((X - pX1)*(X - pX1) + (Y - pY1)*(Y - pY1))) - 450.0);
	else if( Y < pY1 ) ang = (acos((X - pX1) / floatsqroot((X - pX1)*(X - pX1) + (Y - pY1)*(Y - pY1))) - 90.0);

	if(X > pX1) ang = (floatabs(floatabs(ang) + 180.0));
	else ang = (floatabs(ang) - 180.0);

	ang += 180.0;

	SetPlayerFacingAngle(playerid, ang);

 	return ang;
}

public AdminFly(playerid)
{
	if(!IsPlayerConnected(playerid))
		return flying[playerid] = false;

	if(flying[playerid])
	{
	    if(!IsPlayerInAnyVehicle(playerid))
	    {
			new
			    keys,
				ud,
				lr,
				Float:x[2],
				Float:y[2],
				Float:z;

			GetPlayerKeys(playerid, keys, ud, lr);
			GetPlayerVelocity(playerid, x[0], y[0], z);
			if(ud == KEY_UP)
			{
				GetPlayerCameraPos(playerid, x[0], y[0], z);
				GetPlayerCameraFrontVector(playerid, x[1], y[1], z);
    			ApplyAnimation(playerid, "PED", "FALL_skyDive", 4.1, 0, 0, 0, 0, 0);
				SetPlayerToFacePos(playerid, x[0] + x[1], y[0] + y[1]);
				SetPlayerVelocity(playerid, x[1], y[1], z);
			}
			else
			SetPlayerVelocity(playerid, 0.0, 0.0, 0.01);
		}
		SetTimerEx("AdminFly", 100, 0, "d", playerid);
	}
	return 0;
}
public OnVehicleSpawn(vehicleid) {

	if(DynVeh[vehicleid] != -1)
	{
	    DynVeh_Spawn(DynVeh[vehicleid]);
	}
    TruckContents{vehicleid} = 0;
	Vehicle_ResetData(vehicleid);
	new
		v;


	foreach(new i: Player)
	{
		if((v = GetPlayerVehicle(i, vehicleid)) != -1) {
			DestroyVehicle(vehicleid);

			new
				iVehicleID = CreateVehicle(PlayerVehicleInfo[i][v][pvModelId], PlayerVehicleInfo[i][v][pvPosX], PlayerVehicleInfo[i][v][pvPosY], PlayerVehicleInfo[i][v][pvPosZ], PlayerVehicleInfo[i][v][pvPosAngle],PlayerVehicleInfo[i][v][pvColor1], PlayerVehicleInfo[i][v][pvColor2], -1);

            SetVehicleVirtualWorld(iVehicleID, PlayerVehicleInfo[i][v][pvVW]);
            LinkVehicleToInterior(iVehicleID, PlayerVehicleInfo[i][v][pvInt]);

			PlayerVehicleInfo[i][v][pvId] = iVehicleID;

			Vehicle_ResetData(iVehicleID);
			if(!isnull(PlayerVehicleInfo[i][v][pvPlate])) {
				SetVehicleNumberPlate(iVehicleID, PlayerVehicleInfo[i][v][pvPlate]);
			}
			if(PlayerVehicleInfo[i][v][pvLocked] == 1) LockPlayerVehicle(i, iVehicleID, PlayerVehicleInfo[i][v][pvLock]);
			ChangeVehiclePaintjob(iVehicleID, PlayerVehicleInfo[i][v][pvPaintJob]);
			ChangeVehicleColor(iVehicleID, PlayerVehicleInfo[i][v][pvColor1], PlayerVehicleInfo[i][v][pvColor2]);
			for(new m = 0; m < MAX_MODS; m++)
			{
				if (PlayerVehicleInfo[i][v][pvMods][m] >= 1000 && PlayerVehicleInfo[i][v][pvMods][m] <= 1193)
				{
					if (InvalidModCheck(PlayerVehicleInfo[i][v][pvModelId], PlayerVehicleInfo[i][v][pvMods][m]))
					{
						AddVehicleComponent(iVehicleID, PlayerVehicleInfo[i][v][pvMods][m]);
					}
					else
					{
						PlayerVehicleInfo[i][v][pvMods][m] = 0;
					}
				}
			}
			new string[128];
			format(string, sizeof(string), " %s cua ban da duoc gui den cac vi tri tai nhung noi ma ban chua su dung.", GetVehicleName(iVehicleID));
			SendClientMessageEx(i, COLOR_GRAD1, string);
		}
		if(IsValidDynamicObject(CrateVehicleLoad[vehicleid][vForkObject]))
	    {
	    	DestroyDynamicObject(CrateVehicleLoad[vehicleid][vForkObject]);
		}
	}
    CrateVehicleLoad[vehicleid][vForkLoaded] = 0;
	for(new i = 0; i < sizeof(CrateInfo); i++)
    {
		if(CrateInfo[i][InVehicle] == vehicleid)
		{
	    	CrateInfo[i][crActive] = 0;
		    CrateInfo[i][InVehicle] = INVALID_VEHICLE_ID;
		    CrateInfo[i][crObject] = 0;
		    CrateInfo[i][crX] = 0;
		    CrateInfo[i][crY] = 0;
		    CrateInfo[i][crZ] = 0;
		    break;
		}
    }
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	new string[128];
    for(new i = 0; i < sizeof(IsRim); i++)
	{
		if(IsRim[i] == componentid)
		{
		    if(!legalRims(playerid, componentid, vehicleid))
		    {
				if(HackingMods[playerid] < 3)
				{
					new szMessage[128];
					format(szMessage, sizeof(szMessage), "{AA3333}AdmWarning{FFFF00}: %s (ID: %d) co the dang hack mods xe (%s (%d) %s to a %s (ID: %d))", GetPlayerNameEx(playerid), playerid, partName(componentid), componentid, partType(GetVehicleComponentType(componentid)), GetVehicleName(vehicleid), GetPlayerVehicleID(playerid));
					ABroadCast(COLOR_YELLOW, szMessage, 2);
					format(szMessage, sizeof(szMessage), "%s co the hack mods xe (%s (%d) %s to a %s (ID: %d))", GetPlayerNameEx(playerid), partName(componentid), componentid, partType(GetVehicleComponentType(componentid)), GetVehicleName(vehicleid), GetPlayerVehicleID(playerid));
					Log("logs/hack.log", szMessage);
					HackingMods[playerid]++;
					return 0;
				}
				else if(HackingMods[playerid] == 3)
				{
					format(string, sizeof(string), "AdmCmd: %s da bi hap' diem(khoa tai khoan~), lý do: Hack mods xe.", GetPlayerNameEx(playerid));
					ABroadCast(COLOR_LIGHTRED, string, 2);
					SendClientMessageEx(playerid, COLOR_LIGHTRED, string);
					PlayerInfo[playerid][pBanned] = 3;
					new playerip[32];
					GetPlayerIp(playerid, playerip, sizeof(playerip));
					format(string, sizeof(string), "AdmCmd: %s (IP:%s) da bi hap' diem(khoa tai khoan~), ly do: hack mods xe.", GetPlayerNameEx(playerid), playerip);
					PlayerInfo[playerid][pBanned] = 3;
					Log("logs/ban.log", string);
					new ip[32];
					GetPlayerIp(playerid, ip, sizeof(ip));
					SystemBan(playerid, "[System] (Hacking Vehicle Modifications)");
					MySQLBan(GetPlayerSQLId(playerid), playerip, "Hacking Vehicle Modifications", 1, "System");
					HackingMods[playerid] = 0;
					Kick(playerid);
					TotalAutoBan++;
					return 0;
				}
		    }
		}
	}
	if(!(1 <= GetPlayerInterior(playerid) <= 3) && !GetPVarType(playerid, "unMod")) {
		new
			szMessage[128];

		if(HackingMods[playerid] < 3)
		{
			format(szMessage, sizeof(szMessage), "{AA3333}AdmWarning{FFFF00}: %s (ID: %d) co the dang hack mods xe (%s (%d) %s to a %s (ID: %d))", GetPlayerNameEx(playerid), playerid, partName(componentid), componentid, partType(GetVehicleComponentType(componentid)), GetVehicleName(vehicleid), GetPlayerVehicleID(playerid));
			ABroadCast(COLOR_YELLOW, szMessage, 2);
			format(szMessage, sizeof(szMessage), "%s co the hack mods xe (%s (%d) %s to a %s (ID: %d))", GetPlayerNameEx(playerid), partName(componentid), componentid, partType(GetVehicleComponentType(componentid)), GetVehicleName(vehicleid), GetPlayerVehicleID(playerid));
			Log("logs/hack.log", szMessage);
			HackingMods[playerid]++;
			return 0;
		}
		else if(HackingMods[playerid] == 3)
		{
			format(string, sizeof(string), "AdmCmd: %s da bi háp diêm(khóa tài khoãn), lý do: Hacking Vehicle Modifications.", GetPlayerNameEx(playerid));
			ABroadCast(COLOR_LIGHTRED, string, 2);
			SendClientMessageEx(playerid, COLOR_LIGHTRED, string);
			PlayerInfo[playerid][pBanned] = 3;
			new playerip[32];
			GetPlayerIp(playerid, playerip, sizeof(playerip));
			format(string, sizeof(string), "AdmCmd: %s (IP:%s) da bi khoa tai khoan, lý do: Hacking Vehicle Modifications.", GetPlayerNameEx(playerid), playerip);
			PlayerInfo[playerid][pBanned] = 3;
			Log("logs/ban.log", string);
			new ip[32];
			GetPlayerIp(playerid, ip, sizeof(ip));
			SystemBan(playerid, "[System] (Hacking Vehicle Modifications)");
			MySQLBan(GetPlayerSQLId(playerid), playerip, "Hacking Vehicle Modifications", 1, "System");
			HackingMods[playerid] = 0;
			Kick(playerid);
			TotalAutoBan++;
			return 0;
		}
	}
	if(GetPVarType(playerid, "unMod")) DeletePVar(playerid, "unMod");
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}
public OnObjectMoved(objectid)
{
    if(objectid != gFerrisWheel) return 0;

    SetTimer("RotateWheel",3*1000,0);
    return 1;
}

public OnDynamicObjectMoved(objectid)
{
	if(objectid == CarrierS[5])
	{
	    canmove = 0;
	}

	new Float:x, Float:y, Float:z;
	for(new i; i < sizeof(Obj_FloorDoors); i ++)
	{
		if(objectid == Obj_FloorDoors[i][0])
		{
		    GetDynamicObjectPos(Obj_FloorDoors[i][0], x, y, z);

		    if(x < X_DOOR_L_OPENED - 0.5)   // Some floor doors have shut, move the elevator to next floor in queue:
		    {
				Elevator_MoveToFloor(ElevatorQueue[0]);
				RemoveFirstQueueFloor();
			}
		}
	}

	if(objectid == Obj_Elevator)   // The elevator reached the specified floor.
	{
	    KillTimer(ElevatorBoostTimer);  // Kills the timer, in case the elevator reached the floor before boost.

	    FloorRequestedBy[ElevatorFloor] = INVALID_PLAYER_ID;

	    Elevator_OpenDoors();
	    Floor_OpenDoors(ElevatorFloor);

	    GetDynamicObjectPos(Obj_Elevator, x, y, z);
	    Label_Elevator	= CreateDynamic3DTextLabel("nhán '~k~~GROUP_CONTROL_BWD~' de su dung thang may", COLOR_YELLOW, 1784.9822, -1302.0426, z - 0.9, 4.0);

	    ElevatorState 	= ELEVATOR_STATE_WAITING;
	    SetTimer("Elevator_TurnToIdle", ELEVATOR_WAIT_TIME, 0);
	}

	if (objectid == BikeParkourObjects[0]) // container
	{
		switch (BikeParkourObjectStage[0])
		{
			case 0:
			{
				MoveDynamicObject(BikeParkourObjects[0], 2847.5302734, -2231.2675781, 99.0883789, 0.5, 0.0, 0.0, 179.7253418); // to end
				++BikeParkourObjectStage[0];
			}

			case 1:
			{
				MoveDynamicObject(BikeParkourObjects[0], 2848.1015625, -2238.1552734, 99.0883789, 0.5, 0.0000000, 0.0000000, 90.0000000); // to middle
				BikeParkourObjectStage[0] = 2;
			}

			case 2:
			{
				MoveDynamicObject(BikeParkourObjects[0], 2848.1015625, -2243.1552734, 99.0883789, 0.5, 0.0, 0.0, 90.0000000); // to beginning
				BikeParkourObjectStage[0] = 3;
			}

			case 3:
			{
				MoveDynamicObject(BikeParkourObjects[0], 2848.1015625, -2238.1552734, 99.0883789, 0.5, 0.0, 0.0, 90.0000000); // to middle
				BikeParkourObjectStage[0] = 0;
			}
		}
	}
}