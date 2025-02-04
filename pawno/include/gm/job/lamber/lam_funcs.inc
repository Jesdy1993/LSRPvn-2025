SetPlayerLookAt(playerid, Float:x, Float:y)
{
	// somewhere on samp forums, couldn't find the source
	new Float:Px, Float:Py, Float: Pa;
	GetPlayerPos(playerid, Px, Py, Pa);
	Pa = floatabs(atan((y-Py)/(x-Px)));
	if (x <= Px && y >= Py) Pa = floatsub(180, Pa);
	else if (x < Px && y < Py) Pa = floatadd(Pa, 180);
	else if (x >= Px && y <= Py) Pa = floatsub(360.0, Pa);
	Pa = floatsub(Pa, 90.0);
	if (Pa >= 360.0) Pa = floatsub(Pa, 360.0);
	SetPlayerFacingAngle(playerid, Pa);
}

ConvertToMinutes(time)
{
    // http://forum.sa-mp.com/showpost.php?p=3223897&postcount=11
    new string[15];//-2000000000:00 could happen, so make the string 15 chars to avoid any errors
    format(string, sizeof(string), "%02d:%02d", time / 60, time % 60);
    return string;
}

GetClosestLog(playerid, Float: range = 2.0)
{
	new id = -1, Float: dist = range, Float: tempdist, Float: pos[3];
	foreach(new i : TreeLogs)
	{
		GetDynamicObjectPos(LogData[i][logObjID], pos[0], pos[1], pos[2]);
	    tempdist = GetPlayerDistanceFromPoint(playerid, pos[0], pos[1], pos[2]);

	    if (tempdist > range) continue;
		if (tempdist <= dist)
		{
			dist = tempdist;
			id = i;
		}
	}

	return id;
}

Player_Init(playerid)
{
    CuttingTreeID[playerid] = -1;
    CuttingTimer[playerid] = -1;
	CarryingLog[playerid] = false;
    EditingTreeID[playerid] = -1;
    
    CuttingBar[playerid] = CreatePlayerProgressBar(playerid, 498.0, 104.0, 113.0, 6.2, 0x61381BFF, CUTTING_TIME, 0);
	return 1;
}

Player_ResetCutting(playerid)
{
	if (!IsPlayerConnected(playerid) || CuttingTreeID[playerid] == -1) return 0;
	new id = CuttingTreeID[playerid];
	TreeData[id][treeGettingCut] = false;
	if (TreeData[id][treeSeconds] < 1) Streamer_SetIntData(STREAMER_TYPE_3D_TEXT_LABEL, TreeData[id][treeLabel], E_STREAMER_COLOR, 0x2ECC71FF);
	
	ClearAnimations(playerid);
    TogglePlayerControllable(playerid, 1);
    CuttingTreeID[playerid] = -1;
    
    if (CuttingTimer[playerid] != -1)
	{
	    KillTimer(CuttingTimer[playerid]);
		CuttingTimer[playerid] = -1;
	}
	
	SetPlayerProgressBarValue(playerid, CuttingBar[playerid], 0.0);
	HidePlayerProgressBar(playerid, CuttingBar[playerid]);
	return 1;
}

Player_GiveLog(playerid)
{
    if (!IsPlayerConnected(playerid)) return 0;
	CarryingLog[playerid] = true;
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
	SetPlayerAttachedObject(playerid, ATTACH_HANDS, 19793, 6, 0.077999, 0.043999, -0.170999, -13.799953, 79.70, 0.0);
	
	SendSyntaxMessage(playerid, "Ban co the nhan {F1C40F}Chuot Trai {FFFFFF}de vut khuc go.");
	return 1;
}

Player_DropLog(playerid, death_drop = 0)
{
    if (!IsPlayerConnected(playerid) || !CarryingLog[playerid]) return 0;
    new id = Iter_Free(TreeLogs);
    if (id != -1)
    {
        new Float: x, Float: y, Float: z, Float: a, label[128];
        GetPlayerPos(playerid, x, y, z);
        GetPlayerFacingAngle(playerid, a);
        GetPlayerName(playerid, LogData[id][logDroppedBy], MAX_PLAYER_NAME);

		if (!death_drop)
		{
		    x += (1.0 * floatsin(-a, degrees));
			y += (1.0 * floatcos(-a, degrees));
			
			ApplyAnimation(playerid, "CARRY", "putdwn05", 4.1, 0, 1, 1, 0, 0, 1);
		}

		LogData[id][logSeconds] = LOG_LIFETIME;
		LogData[id][logObjID] = CreateDynamicObject(19793, x, y, z - 0.9, 0.0, 0.0, a);
		
		format(label, sizeof(label), "Khuc Go (%d)\n\n{FFFFFF}Vut boi {F1C40F}%s\n{FFFFFF}%s\nSu dung {F1C40F}/lumber take {FFFFFF}de lay.", id, LogData[id][logDroppedBy], ConvertToMinutes(LOG_LIFETIME));
		LogData[id][logLabel] = CreateDynamic3DTextLabel(label, 0xF1C40FFF, x, y, z - 0.7, 5.0, .testlos = 1);
		
		LogData[id][logTimer] = SetTimerEx("RemoveLog", 1000, true, "i", id);
		Iter_Add(TreeLogs, id);
    }
    
    Player_RemoveLog(playerid);
	return 1;
}

Player_RemoveLog(playerid)
{
	if (!IsPlayerConnected(playerid) || !CarryingLog[playerid]) return 0;
	RemovePlayerAttachedObject(playerid, ATTACH_HANDS);
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	CarryingLog[playerid] = false;
	return 1;
}

Vehicle_LogCount(vehicleid)
{
	if (GetVehicleModel(vehicleid) == 0) return 0;
	new count;
	for(new i; i < LOG_LIMIT; i++) if (IsValidDynamicObject(LogObjects[vehicleid][i])) count++;
	return count;
}

Vehicle_RemoveLogs(vehicleid)
{
    if (GetVehicleModel(vehicleid) == 0) return 0;
    for(new i; i < LOG_LIMIT; i++)
	{
	    if (IsValidDynamicObject(LogObjects[vehicleid][i]))
	    {
	        DestroyDynamicObject(LogObjects[vehicleid][i]);
	        LogObjects[vehicleid][i] = -1;
	    }
	}
	
	return 1;
}

Tree_BeingEdited(id)
{
	if (!Iter_Contains(Trees, id)) return 0;
	foreach(new i : Player) if (EditingTreeID[i] == id) return 1;
	return 0;
}

Tree_UpdateLogLabel(id)
{
    if (!Iter_Contains(Trees, id)) return 0;
    new label[96];
    
    if (TreeData[id][treeLogs] > 0) {
	    format(label, sizeof(label), "Cay (%d)\n\n{FFFFFF}Khuc go: {F1C40F}%d\n{FFFFFF}Su dung {F1C40F}/lumber tree {FFFFFF}de cua.", id, TreeData[id][treeLogs]);
		UpdateDynamic3DTextLabelText(TreeData[id][treeLabel], 0xE74C3CFF, label);
	}else{
	    TreeData[id][treeTimer] = SetTimerEx("RespawnTree", 1000, true, "i", id);
	    
	    format(label, sizeof(label), "Cay (%d)\n\n{FFFFFF}%s", id, ConvertToMinutes(TreeData[id][treeSeconds]));
		UpdateDynamic3DTextLabelText(TreeData[id][treeLabel], 0xE74C3CFF, label);
	}
	
	return 1;
}

GetNearTree(playerid)
{
    for(new i; i != MAX_TREES; i++)
	{
		if (IsPlayerInRangeOfPoint(playerid, 5.0, TreeData[i][treeX], TreeData[i][treeY], TreeData[i][treeZ])) return i;
	}
	return -1;
}

GetNearBuyer(playerid)
{
    for(new i; i != MAX_BUYERS; i++)
	{
		if (IsPlayerInRangeOfPoint(playerid, 5.0, BuyerData[i][buyerX], BuyerData[i][buyerY], BuyerData[i][buyerZ])) return i;
	}
	return -1;
}

GetNextTreeID()
{
	for(new i; i != MAX_TREES; i++)
	{
	    if (TreeData[i][treeID] == 0) return i;
	}
	return -1;
}

GetNextBuyerID()
{
	for(new i; i != MAX_BUYERS; i++)
	{
	    if (BuyerData[i][buyerID] == 0) return i;
	}
	return -1;
}

this::OnInsertTrees(id)
{
	return TreeData[id][treeID] = cache_insert_id();
}

this::OnInsertBuyers(id)
{
	return BuyerData[id][buyerID] = cache_insert_id();
}

this::LoadTrees()
{
    new rows = cache_num_rows(), time = GetTickCount(), total, label[64];

	if (!rows)	return print("[LamberJack Trees] No records found.");

	for(new i; i < rows; i++)
	{
		TreeData[i][treeID] = cache_get_field_content_int(i, "ID", dbHandle);
		TreeData[i][treeX] = cache_get_field_content_float(i, "PosX", dbHandle);
		TreeData[i][treeY] = cache_get_field_content_float(i, "PosY", dbHandle);
		TreeData[i][treeZ] = cache_get_field_content_float(i, "PosZ", dbHandle);
		TreeData[i][treeRX] = cache_get_field_content_float(i, "RotX", dbHandle);
		TreeData[i][treeRY] = cache_get_field_content_float(i, "RotY", dbHandle);
		TreeData[i][treeRZ] = cache_get_field_content_float(i, "RotZ", dbHandle);

		TreeData[i][treeObjID] = CreateDynamicObject(657, TreeData[i][treeX], TreeData[i][treeY], TreeData[i][treeZ], TreeData[i][treeRX], TreeData[i][treeRY], TreeData[i][treeRZ]);
		
		format(label, sizeof(label), "Cay (%d)\n\n{FFFFFF}Nhan {F1C40F}Chuot trai {FFFFFF}de cua.", i);
		TreeData[i][treeLabel] = CreateDynamic3DTextLabel(label, 0x2ECC71FF, TreeData[i][treeX], TreeData[i][treeY], TreeData[i][treeZ] + 1.5, 5.0);

		Iter_Add(Trees, i);
		total++;
	}
	printf("[LamberJack Trees] Rows - %i. Load - %i. Time: %i ms.", rows, total, GetTickCount()-time);
	return 1;
}

this::LoadBuyers()
{
    new rows = cache_num_rows(), time = GetTickCount(), total, label[250];

	if (!rows)	return print("[LamberJack Buyers] No records found.");

	for(new i; i < rows; i++)
	{
		BuyerData[i][buyerID] = cache_get_field_content_int(i, "ID", dbHandle);
		BuyerData[i][buyerSkin] = cache_get_field_content_int(i, "Skin", dbHandle);
		BuyerData[i][buyerX] = cache_get_field_content_float(i, "PosX", dbHandle);
		BuyerData[i][buyerY] = cache_get_field_content_float(i, "PosY", dbHandle);
		BuyerData[i][buyerZ] = cache_get_field_content_float(i, "PosZ", dbHandle);
		BuyerData[i][buyerA] = cache_get_field_content_float(i, "PosA", dbHandle);

		BuyerData[i][buyerActorID] = CreateActor(BuyerData[i][buyerSkin], BuyerData[i][buyerX], BuyerData[i][buyerY], BuyerData[i][buyerZ], BuyerData[i][buyerA]);
		SetActorInvulnerable(BuyerData[i][buyerActorID], 1);

		format(label, sizeof(label), "Log Buyer (%d)\n\n{FFFFFF}Su dung {F1C40F}/chainsaw {FFFFFF}de mua may cua voi gia {2ECC71}$%d.\n{FFFFFF}Su dung {F1C40F}/lumber sell {FFFFFF}de ban khuc go voi gia {2ECC71}$%d.", i, CSAW_PRICE, LOG_PRICE);
		BuyerData[i][buyerLabel] = CreateDynamic3DTextLabel(label, 0xF1C40FFF, BuyerData[i][buyerX], BuyerData[i][buyerY], BuyerData[i][buyerZ] + 0.25, 5.0, .testlos = 1);

		Iter_Add(Buyers, i);
		total++;
	}
	printf("[LamberJack Buyers] Rows - %i. Load - %i. Time: %i ms.", rows, total, GetTickCount()-time);
	return 1;
}

forward CutTree(playerid);
public CutTree(playerid)
{
    if (CuttingTreeID[playerid] != -1)
	{
	    new id = CuttingTreeID[playerid], Float: value = GetPlayerProgressBarValue(playerid, CuttingBar[playerid]) + 1.0;
	    
		if (value >= CUTTING_TIME) {
		    Player_ResetCutting(playerid);
			MoveDynamicObject(TreeData[id][treeObjID], TreeData[id][treeX], TreeData[id][treeY], TreeData[id][treeZ] + 0.03, 0.025, TreeData[id][treeRX], TreeData[id][treeRY] - 80.0, TreeData[id][treeRZ]);

			TreeData[id][treeLogs] = 5;
			TreeData[id][treeSeconds] = TREE_RESPAWN;
			Tree_UpdateLogLabel(id);
		}
		else
		{
		    SetPlayerProgressBarValue(playerid, CuttingBar[playerid], value);
		}
	}

	return 1;
}

forward RespawnTree(id);
public RespawnTree(id)
{
	new label[96];
	if (TreeData[id][treeSeconds] > 1) {
	    TreeData[id][treeSeconds]--;
	    
	    format(label, sizeof(label), "Cay (%d)\n\n{FFFFFF}%s", id, ConvertToMinutes(TreeData[id][treeSeconds]));
		UpdateDynamic3DTextLabelText(TreeData[id][treeLabel], 0xE74C3CFF, label);
	}else if (TreeData[id][treeSeconds] == 1) {
	    KillTimer(TreeData[id][treeTimer]);

	    TreeData[id][treeLogs] = 0;
	    TreeData[id][treeSeconds] = 0;
	    TreeData[id][treeTimer] = -1;
	    
	    SetDynamicObjectPos(TreeData[id][treeObjID], TreeData[id][treeX], TreeData[id][treeY], TreeData[id][treeZ]);
     	SetDynamicObjectRot(TreeData[id][treeObjID], TreeData[id][treeRX], TreeData[id][treeRY], TreeData[id][treeRZ]);
     	
     	format(label, sizeof(label), "Cay (%d)\n\n{FFFFFF}Nhan {F1C40F}Chuot trai {FFFFFF}de cua.", id);
     	UpdateDynamic3DTextLabelText(TreeData[id][treeLabel], 0x2ECC71FF, label);
	}
	
	return 1;
}

forward RemoveLog(id);
public RemoveLog(id)
{	
	if (LogData[id][logSeconds] > 1) 
	{
	    LogData[id][logSeconds]--;

        new label[128];
	    format(label, sizeof(label), "Khuc go (%d)\n\n{FFFFFF}Vut boi {F1C40F}%s\n{FFFFFF}%s\nSu dung {F1C40F}/lumber take {FFFFFF}de lay.", id, LogData[id][logDroppedBy], ConvertToMinutes(LogData[id][logSeconds]));
		UpdateDynamic3DTextLabelText(LogData[id][logLabel], 0xF1C40FFF, label);
	}
	else if (LogData[id][logSeconds] == 1) {
	    KillTimer(LogData[id][logTimer]);
	    DestroyDynamicObject(LogData[id][logObjID]);
		DestroyDynamic3DTextLabel(LogData[id][logLabel]);
		
	    LogData[id][logTimer] = -1;
        LogData[id][logObjID] = -1;
        LogData[id][logLabel] = Text3D: -1;

		Iter_Remove(TreeLogs, id);
	}
	
	return 1;
}