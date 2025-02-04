CMD:miner(playerid, params[])
{
	if (PlayerInfo[playerid][pJob] != JOB_MINER)	return SendErrorMessage(playerid, "Ban khong phai la Miner.");
    if (isnull(params)) return SendClientMessage(playerid, 0xE88732FF, "SU DUNG: {FFFFFF}/miner [ores/take]");
    if (!strcmp(params, "ores", true)) 
	{
        new vehicleid = GetNearestVehicleEx(playerid);
        if (!IsValidVehicle(vehicleid)) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Ban khong o gan bat ky phuong tien nao.");
        if (!IsMinerCar(vehicleid)) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Phuong tien khong phai la phuong tien khai thac.");
        new string[196], title[32];
		format(string, sizeof(string), "Ten\tSo luong\tGia tri\n");
        for(new i; i < MAX_ORE_TYPES; i++) format(string, sizeof(string), "%s%s\t%d\t{2ECC71}$%d\n", string, OreData[i][Name], LoadedOres[vehicleid][i], Vehicle_GetOreValueByType(vehicleid, i));
		format(title, sizeof(title), "Loaded Ores {E74C3C}(%d/%d)", Vehicle_LoadedOres(vehicleid), VEHICLE_LIMIT);
		Dialog_Show(playerid, DIALOG_ORE_INFO, DIALOG_STYLE_TABLIST_HEADERS, title, string, "Dong", "");
    }
	else if (!strcmp(params, "take")) 
	{
        if (IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Ban khong the lam dieu nay trong mot chiec xe.");
		if (MiningVein[playerid] != -1) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Ban da khai thac roi.");
		if (CarryingOre[playerid] != -1) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Ban da mang quang.");
		new id = GetNearestVehicleEx(playerid);
		if (!IsValidVehicle(id)) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Ban khong o gan bat ky phuong tien nao.");
        if (!IsMinerCar(id)) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Phuong tien khong phai la phuong tien khai thac.");
		new Float: x, Float: y, Float: z;
		GetVehicleBoot(id, x, y, z);
		if (GetPlayerDistanceFromPoint(playerid, x, y, z) > 3.0) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Ban khong o gan phia sau cua chiec xe.");
        new string[196], title[32];
		format(string, sizeof(string), "Ten\tSo luong\n");
        for(new i; i < MAX_ORE_TYPES; i++) format(string, sizeof(string), "%s%s\t%d\n", string, OreData[i][Name], LoadedOres[id][i]);
		format(title, sizeof(title), "Loaded Ores {E74C3C}(%d/%d)", Vehicle_LoadedOres(id), VEHICLE_LIMIT);
		Dialog_Show(playerid, DIALOG_ORE_TAKE, DIALOG_STYLE_TABLIST_HEADERS, title, string, "Lay", "Dong");
    }

	return 1;
}

CMD:ore(playerid, params[])
{
	if (PlayerInfo[playerid][pJob] != JOB_MINER)	return SendErrorMessage(playerid, "Ban khong phai la Miner.");
    if (isnull(params)) return SendClientMessage(playerid, 0xE88732FF, "SU DUNG: {FFFFFF}/ore [info/mine/take]");
    if (!strcmp(params, "info", true)) {
		new id = Player_GetClosestVein(playerid);
		if (id == -1) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Ban khong o gan tinh mach.");
        new string[128], type = VeinData[id][Type];
        format(string, sizeof(string), "Ten\t{%06x}%s\nGia tri\t{2ECC71}$%d\nGia tri tinh mach\t{2ECC71}$%d\nThoi gian khai thac\t%.2f giay", OreData[type][Color] >>> 8, OreData[type][Name], OreData[type][Value], (OreData[type][Value] * VeinData[id][Amount]), Vein_CalculateTime(id) / 1000);
		Dialog_Show(playerid, DIALOG_ORE_INFO, DIALOG_STYLE_TABLIST, "Ore Information", string, "Dong", "");
    }
	else if (!strcmp(params, "mine"))
	{
		if (MiningVein[playerid] != -1) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Ban da khai thac roi.");
		if (CarryingOre[playerid] != -1) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Ban da mang quang.");
		new id = Player_GetClosestVein(playerid);
		if (id == -1) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Ban khong o gan bat ky tinh mach nao.");
		if (VeinData[id][BeingMined]) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Tinh mach ban muon khai thac dang duoc khai thac boi nguoi khac.");
		if (VeinData[id][Amount] < 1) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Mach mau ban muon khai thac dang trong rong.");
		new Float: x, Float: y, Float: z;
		GetVehicleBoot(GetPVarInt(playerid, "LastVehicleID"), x, y, z);
		if (GetPlayerDistanceFromPoint(playerid, x, y, z) > 60.0) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Phuong tien cuoi cung cua ban con qua xa.");
		MiningVein[playerid] = id;

		MiningTimer[playerid] = SetTimerEx("Player_Mine", UPDATE_RATE, true, "i", playerid);
		SetPlayerProgressBarColour(playerid, MiningBar[playerid], OreData[ VeinData[id][Type] ][Color]);
		SetPlayerProgressBarValue(playerid, MiningBar[playerid], 0.0);
		ShowPlayerProgressBar(playerid, MiningBar[playerid]);
		SetPlayerAttachedObject(playerid, ATTACH_INDEX, 19631, 6, 0.048, 0.029, 0.103, -80.0, 80.0, 0.0);
		TogglePlayerControllable(playerid, 0);
		SetPlayerArmedWeapon(playerid, 0);
		ApplyAnimation(playerid, "BASEBALL", "Bat_1", 4.1, 1, 0, 0, 1, 0, 1);

		new string[64];
		format(string, sizeof(string), "~n~~y~~h~Mining %s...", OreData[ VeinData[id][Type] ][Name]);
	    GameTextForPlayer(playerid, string, floatround(Vein_CalculateTime(id)) + 1000, 3);

		VeinData[id][BeingMined] = true;
		Vein_Update(id);
    }
	else if (!strcmp(params, "take")) 
	{
        if (!IsMinerCar(GetPVarInt(playerid, "LastVehicleID"))) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Phuong tien cuoi cung cua ban khong co san de khai thac.");
		if (MiningVein[playerid] != -1) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Ban da khai thac roi.");
		if (CarryingOre[playerid] != -1) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Ban da mang quang.");
		new id = Player_GetClosestOre(playerid);
		if (id == -1) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Ban khong o gan bat ky quang nao.");
		new Float: x, Float: y, Float: z;
		GetVehicleBoot(GetPVarInt(playerid, "LastVehicleID"), x, y, z);
		if (GetPlayerDistanceFromPoint(playerid, x, y, z) > 60.0) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Phuong tien cuoi cung cua ban con qua xa.");
		Player_GiveOre(playerid, DroppedOres[id][Type]);
		Ore_Destroy(id);
    }
    
	return 1;
}

Dialog:DIALOG_ORE_TAKE(playerid, dialogid, response, listitem, inputtext[])
{

	if (!response) return 1;
	if (MiningVein[playerid] != -1) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Ban da khai thac roi.");
	if (CarryingOre[playerid] != -1) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Ban da mang quang.");
	new id = GetNearestVehicleEx(playerid);
	if (!IsValidVehicle(id)) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Ban khong o gan bat ky phuong tien nao.");
	new Float: x, Float: y, Float: z;
	GetVehicleBoot(id, x, y, z);
	if (GetPlayerDistanceFromPoint(playerid, x, y, z) > 3.0) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Ban khong o gan phia sau cua chiec xe.");
	if (LoadedOres[id][listitem] < 1) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Xe nay khong cho quang do.");
	LoadedOres[id][listitem]--;
	Player_GiveOre(playerid, listitem, 2);
    return 0; 
}