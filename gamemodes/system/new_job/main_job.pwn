new  PlayerVehicleRent[MAX_PLAYERS] = INVALID_VEHICLE_ID;
new  PlayerVehicleLock[MAX_PLAYERS] = 0;

CMD:carjob(playerid, params[])
{
    new choice[32];
    if(sscanf(params, "s[32]", choice))
    {
        SendClientMessageEx(playerid, COLOR_CHAT, " /carjob [tuy chon]");
        SendClientMessageEx(playerid, COLOR_WHITE, "{c7d5d8}OPTION{ffffff}: find | lock | idcar");
        return 1;
    }

    if(strcmp(choice,"find",true) == 0) {
    	new Float:X,Float:Y,Float:Z;
    	GetVehiclePos( PlayerVehicleRent[playerid], X,Y,Z);
    	SendServerMessage(playerid," Da xac dinh vi tri phuong tien cua ban.");
    	SetPlayerCheckpoint(playerid, X,Y,Z, 5);
    }
    else if(strcmp(choice,"lock",true) == 0) {
    	new Float:X,Float:Y,Float:Z;
    	GetVehiclePos( PlayerVehicleRent[playerid], X,Y,Z);
    	if(IsPlayerInRangeOfPoint(playerid, 5, X,Y,Z)) {
    		if(PlayerVehicleLock[playerid] == 0) {
    			LockCarJob(playerid);
    		}
    		else if(PlayerVehicleLock[playerid] == 1) UnLockCarJob(playerid);
    	}
    	else SendErrorMessage(playerid," Ban khong o gan phuong tien [Job] cua ban.");
    }
    else if(strcmp(choice,"idcar",true) == 0) {
    	new string[129];
    	format(string, sizeof string, "Phuong tien cua ban ID la: %d", PlayerVehicleRent[playerid]);
    	SendClientMessage(playerid,COLOR_CHAT,string);
    }
    return 1;
}

stock ShowQuitJob(playerid) {
	if(PlayerInfo[playerid][pJob] != 0 || PlayerInfo[playerid][pJob2] != 0) Dialog_Show(playerid,MJ_QUITJOB, DIALOG_STYLE_MSGBOX,"Cong viec - nghi viec","Ban dang nhan mot cong viec khac ban co muon nghi viec khong?","Chap nhan","huy bo");
	
}
Dialog:MJ_QUITJOB(playerid, response, listitem, inputtext[]) {
	if(response) {
		if(PlayerInfo[playerid][pDonateRank] >= 1) {
			Dialog_Show(playerid,MJ_QUITJOB_SEL, DIALOG_STYLE_MSGBOX,"Cong viec - nghi viec","Vui long lua chon cong viec ban muon nghi?",GetJobName(PlayerInfo[playerid][pJob]),GetJobName(PlayerInfo[playerid][pJob2]) );
		}
		else {
			Dialog_Show(playerid,MJ_QUITJOB_SEL, DIALOG_STYLE_MSGBOX,"Cong viec - nghi viec","Vui long lua chon cong viec ban muon nghi?",GetJobName(PlayerInfo[playerid][pJob]),"Khong ton tai" );
		}
	}
	return 1;
}
Dialog:MJ_QUITJOB_SEL(playerid, response, listitem, inputtext[]) {
	if(response) {
		SendClientMessage(playerid,COLOR_BASIC,"Ban da nghi viec chinh thanh cong, hay tiep tuc xin cong viec moi.");
		PlayerInfo[playerid][pJob] = 0;
	}
	else {
		if(PlayerInfo[playerid][pDonateRank] > 0 ) return 1;
		SendClientMessage(playerid,COLOR_BASIC,"Ban da nghi viec phu thanh cong, hay tiep tuc xin cong viec moi.");
		PlayerInfo[playerid][pJob2] = 0;
	}
	return 1;
}
stock VehicleRentPlayer(vehicleid ) {
	foreach(new i : Player) {
		if(PlayerVehicleRent[i] == vehicleid) return i;
	}
	return 2005;
}
stock LockCarJob(playerid) {
    ShowNotifyTextMain(playerid," Phuong tien job cua ban da duoc ~r~khoa");
    PlayerVehicleLock[playerid] = 1;
	new  engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(PlayerVehicleRent[playerid], engine, lights, alarm, doors, bonnet, boot, objective);
    SetVehicleParamsEx(PlayerVehicleRent[playerid], engine, lights, alarm, 1, bonnet, boot, objective);
}
stock UnLockCarJob(playerid) {
    ShowNotifyTextMain(playerid," Phuong tien job cua ban da duoc ~g~ mo khoa");
    PlayerVehicleLock[playerid] = 0;
    new  engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(PlayerVehicleRent[playerid], engine, lights, alarm, doors, bonnet, boot, objective);
    SetVehicleParamsEx(PlayerVehicleRent[playerid], engine, lights, alarm, 0, bonnet, boot, objective);
}
