enum GPS_Job {
	GPS_Name[32],
	Float:GPS_PosX,
    Float:GPS_PosY,
    Float:GPS_PosZ
}
new GPSJobInfo[][GPS_Job] = {
	{"Pizza boy",2103.9622,-1808.7523,13.5547},
	{"Miner # Khai thac",585.4429,869.6895,-42.4973},
	{"Miner # Ban khoang san",301.3658,-173.1053,1.5781},
	{"Trucker",2187.5132,-2258.2197,13.4512},
	{"Don rac",2200.3394,-1973.6333,13.5578},
	{"Boc vac",2075.9358,-2016.8898,13.5469},
	{"Khu vuc chat go", -1437.2875, -1561.9709, 101.7578},
	{"Khu vuc ban go",1866.3325, -1792.2802, 13.5469}
	 
	
};
enum GPS_Way {
	WGPS_Name[32],
	Float:WGPS_PosX,
    Float:WGPS_PosY,
    Float:WGPS_PosZ,
}

new GPSWay_[][GPS_Way] = {
	{"Tru so canh sat Los Santos",1553.8690,-1675.4728,16.1953},
    {"City hall",1480.6931,-1771.9524,18.7958},
    {"Ngan hang",1456.9381,-1011.5815,26.8438},
    {"Market Mall",1133.7100,-1464.5200,15.7739},
    {"Benh vien",1173.5852,-1323.5542,15.1953},
    {"Los Santos DMV", 1113.01, -1835.96, 16.60},
    {"Cua hang xe cu", 2446.0222,-1901.9486,13.5469},
    {"Cua hang vu khi", 1366.9032,-1276.9332,13.5469}
    
};
stock ShowPlayerGPS(playerid) {
	Dialog_Show(playerid, GPS_SYSTEM,DIALOG_STYLE_TABLIST_HEADERS, "GPS:System - Main", "Tuy chon\t#\t#>\n\
		Cong viec\t#\t#>\n\
		Dia diem\t#\t#>", "> Tuy chon", "Thoat");
	return 1;
}
Dialog:GPS_SYSTEM(playerid, response, listitem, inputtext[])
{
	if(response) {
		if(listitem == 0) {
			new str[529],Float:distance, zone[MAX_ZONE_NAME];
			str = "Cong viec\tKhoang cach\tVi tri\n";
			for(new i = 0; i < sizeof(GPSJobInfo) ; i++ ) {
				distance = GetPlayerDistanceFromPoint(playerid, GPSJobInfo[i][GPS_PosX], GPSJobInfo[i][GPS_PosY], GPSJobInfo[i][GPS_PosZ]);
                Get3DZone( GPSJobInfo[i][GPS_PosX], GPSJobInfo[i][GPS_PosY], GPSJobInfo[i][GPS_PosZ], zone, sizeof(zone));
				format(str, sizeof str, "%s%s\t%.1fm\t%s\n", str, GPSJobInfo[i][GPS_Name],distance,zone);
			}
			Dialog_Show(playerid, GPS_SYSTEM_JOB, DIALOG_STYLE_TABLIST_HEADERS, "GPS:System - Job", str, "Tuy chon", "Thoat");
		}
		if(listitem == 1) {
			new str[529],Float:distance, zone[MAX_ZONE_NAME];
			str = "Dia diem\tKhoang cach\tVi tri\n";
			for(new i = 0; i < sizeof(GPSWay_) ; i++ ) {
				distance = GetPlayerDistanceFromPoint(playerid,  GPSWay_[i][WGPS_PosX], GPSWay_[i][WGPS_PosY], GPSWay_[i][WGPS_PosZ]);
                Get3DZone( GPSWay_[i][WGPS_PosX], GPSWay_[i][WGPS_PosY], GPSWay_[i][WGPS_PosZ], zone, sizeof(zone));
				format(str, sizeof str, "%s%s\t%.1fm\t%s\n", str, GPSWay_[i][WGPS_Name],distance,zone);
			}
			Dialog_Show(playerid, GPS_SYSTEM_WAY, DIALOG_STYLE_TABLIST_HEADERS, "GPS:System - Dia diem", str, "Tuy chon", "Thoat");
		}
	}
	return 1;
}
Dialog:GPS_SYSTEM_JOB(playerid, response, listitem, inputtext[])
{
	if(response) {
		CP[playerid] = 252000;
		SetPlayerCheckpoint(playerid,GPSJobInfo[listitem][GPS_PosX], GPSJobInfo[listitem][GPS_PosY], GPSJobInfo[listitem][GPS_PosZ], 5.0);
		ShowNotifyTextMain(playerid,"Da xac dinh dia diem tren ban do (~r~checkpoint~w~)",6);
	}
	return 1;
}
Dialog:GPS_SYSTEM_WAY(playerid, response, listitem, inputtext[])
{
	if(response) {
		CP[playerid] = 252000;
		SetPlayerCheckpoint(playerid,GPSWay_[listitem][WGPS_PosX], GPSWay_[listitem][WGPS_PosY], GPSWay_[listitem][WGPS_PosZ], 5.0);
		ShowNotifyTextMain(playerid,"Da xac dinh dia diem tren ban do (~r~checkpoint~w~)",6);
	}
	return 1;
}

CMD:xoaneardoor(playerid, params[]) {
	if(PlayerInfo[playerid][pAdmin] == 99999) {
		new nearGate;
		new count = 0;
		
		if(sscanf(params, "d", nearGate)) return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /xoaneardoor [khoang cach]");
		for(new gateid; gateid < MAX_DDOORS; gateid++)
		{				
			count += 1;
			DeleteAllDoor(gateid);
		}

		new string[1280];
		format(string, sizeof(string), "> Ban da xoa thanh cong (%d DOOR) trong khoang cach %d thanh cong.", count, nearGate);
		SendClientMessageEx(playerid, COLOR_LIGHTRED, string);
		return 1;
    }
    else SendClientMessageEx(playerid, COLOR_LIGHTRED, "> Ban khong the su dung lenh nay.");
	return 1;
}
stock DeleteAllDoor(doorid) {
	DestroyDynamicPickup(DDoorsInfo[doorid][ddPickupID]);

	DDoorsInfo[doorid][ddDescription] = 0;
	DDoorsInfo[doorid][ddCustomInterior] = 0;
	DDoorsInfo[doorid][ddExteriorVW] = 0;
	DDoorsInfo[doorid][ddExteriorInt] = 0;
	DDoorsInfo[doorid][ddInteriorVW] = 0;
	DDoorsInfo[doorid][ddInteriorInt] = 0;
	DDoorsInfo[doorid][ddExteriorX] = 0;
	DDoorsInfo[doorid][ddExteriorY] = 0;
	DDoorsInfo[doorid][ddExteriorZ] = 0;
	DDoorsInfo[doorid][ddExteriorA] = 0;
	DDoorsInfo[doorid][ddInteriorX] = 0;
	DDoorsInfo[doorid][ddInteriorY] = 0;
	DDoorsInfo[doorid][ddInteriorZ] = 0;
	DDoorsInfo[doorid][ddInteriorA] = 0;
	DDoorsInfo[doorid][ddCustomExterior] = 0;
	DDoorsInfo[doorid][ddVIP] = 0;
	DDoorsInfo[doorid][ddDPC] = 0;
	DDoorsInfo[doorid][ddFamily] = 0;
	DDoorsInfo[doorid][ddFaction] = 0;
	DDoorsInfo[doorid][ddAdmin] = 0;
	DDoorsInfo[doorid][ddWanted] = 0;
	DDoorsInfo[doorid][ddVehicleAble] = 0;
	DDoorsInfo[doorid][ddColor] = 0;
	DDoorsInfo[doorid][ddPass] = 0;
	DDoorsInfo[doorid][ddLocked] = 0;
	SaveDynamicDoor(doorid);

	return 1;
}
///
CMD:xoaneargate(playerid, params[]) {
	if(PlayerInfo[playerid][pAdmin] == 99999) {
		new nearGate;
		new count = 0;
		
		if(sscanf(params, "d", nearGate)) return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /delgatenear [khoang cach]");
		for(new gateid; gateid < MAX_GATES; gateid++)
		{				
			count += 1;
			DeleteAllGates(gateid, 0);
		}

		new string[1280];
		format(string, sizeof(string), "> Ban da xoa thanh cong (%d gate) trong khoang cach %d thanh cong.", count, nearGate);
		SendClientMessageEx(playerid, COLOR_LIGHTRED, string);
		return 1;
    }
    else SendClientMessageEx(playerid, COLOR_LIGHTRED, "> Ban khong the su dung lenh nay.");
	return 1;
}

stock DeleteAllGates(gateid, value) {
	if(value == 0)
    {
        GateInfo[gateid][gPosX] = 50000.0;
        GateInfo[gateid][gPosY] = 50000.0;
        GateInfo[gateid][gPosZ] = 50000.0;
        GateInfo[gateid][gRotX] = 0.0;
        GateInfo[gateid][gRotY] = 0.0;
		GateInfo[gateid][gRotZ] = 0.0;
		GateInfo[gateid][gPosXM] = 0.0;
		GateInfo[gateid][gPosYM] = 0.0;
		GateInfo[gateid][gPosZM] = 0.0;
		GateInfo[gateid][gRotXM] = 0.0;
		GateInfo[gateid][gRotYM] = 0.0;
		GateInfo[gateid][gRotZM] = 0.0;
		GateInfo[gateid][gVW] = 0;
		GateInfo[gateid][gInt] = 0;
		GateInfo[gateid][gAllegiance] = 0;
		GateInfo[gateid][gGroupType] = 0;
		GateInfo[gateid][gGroupID] = -1;
		GateInfo[gateid][gFamilyID] = -1;
	}

    GateInfo[gateid][gModel] = value;
    if(IsValidDynamicObject(GateInfo[gateid][gGATE])) DestroyDynamicObject(GateInfo[gateid][gGATE]);
    CreateGate(gateid);
    SaveGate(gateid);
	return 1;
}
// task UpdateBugLabel[30000]()
// {
// 	for(new i = 0 ; i < MAX_HOUSES; i++) {
// 		if(HouseInfo[i][hExteriorX] == 0.0 && HouseInfo[i][hExteriorY] == 0.0) {
// 			if(IsValidDynamicPickup(HouseInfo[i][hPickupID])) DestroyDynamicPickup(HouseInfo[i][hPickupID]);
// 	        if(IsValidDynamic3DTextLabel(HouseInfo[i][hTextID])) DestroyDynamic3DTextLabel(HouseInfo[i][hTextID]);
// 		}	
// 	}
// 	for(new i = 0 ; i < MAX_BUSINESSES; i++) {
// 		if(Businesses[i][bExtPos][0] == 0.0 && HBusinesses[i][bExtPos][1] == 0.0) {
// 			if(IsValidDynamicPickup(Businesses[i][bPickup])) DestroyDynamicPickup(Businesses[i][bPickup]);
// 		}	
// 	}
// 	for(new i = 0 ; i < MAX_DDOORS; i++) {
// 		if(DDoorsInfo[i][ddExteriorX] == 0.0 && DDoorsInfo[i][ddExteriorY] == 0.0) {
// 			if(IsValidDynamicPickup(DDoorsInfo[i][ddPickupID]))  DestroyDynamicPickup(DDoorsInfo[i][ddPickupID]]);

// 		}	
// 	}
// 	return 1;
// }