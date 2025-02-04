
#include <YSI\y_hooks>


new BoxInTruck[MAX_PLAYERS][6];

new Timer:TruckerTimer[MAX_PLAYERS],
    truck_pickup[3];

CMD:giaohang(playerid,params[]) {
	SetPlayerCheckpoint(playerid,1236.9541,177.7182,20.3962, 5.0);
	CP[playerid] = 252000;

	SendClientMessage(playerid,COLOR_GREEN,"[TRUCK] Hay di den dia diem den ban thung hang.");
	return 1;
}
CMD:truck(playerid,params[]) {
	ShowBoxInVehicle(playerid);
	return 1;
}
hook OnGameModeInit() {
	CreateActor(163, 2187.5132,-2258.2197,13.4512,217.1583);
	CreateDynamic3DTextLabel("< Trucker >\nBam 'Y' tuong tac", COLOR_BASIC, 2187.5132,-2258.2197,13.4512, 20.0);
	CreateDynamic3DTextLabel("< Trucker >\nKhu vuc hoan tra xe, bam 'Y' de thao tac tra xe", COLOR_BASIC, 2199.1704,-2274.9971,13.5547, 20.0);
	CreateDynamicPickup(11737, 23, 2199.1704,-2274.9971,13.5547); // pick up tra xe
	truck_pickup[0] = CreateDynamicPickup(1271, 23,  2212.9854,-2252.9609,13.5547); // pick up lay hang
	truck_pickup[1] = CreateDynamicPickup(1271, 23,  2205.4924,-2260.6790,13.5547); // pick up lay hang
	truck_pickup[2] = CreateDynamicPickup(1271, 23,  2198.1604,-2267.8938,13.5547); // pick up lay hang	



	CreateDynamic3DTextLabel("< KHU VUC GIAO HANG >\nBam '{e75353}Y'{b4b4b4} de giao hang", COLOR_BASIC, 1236.9541,177.7182,20.3962, 20.0);
	CreateDynamic3DTextLabel("< KHU VUC LAY HANG >\nBam '{e75353}Y'{b4b4b4} de lay hang", COLOR_BASIC, 2205.4924,-2260.6790,13.5547, 20.0);
	CreateDynamic3DTextLabel("< KHU VUC LAY HANG >\nBam '{e75353}Y'{b4b4b4} de lay hang", COLOR_BASIC, 2212.9854,-2252.9609,13.5547, 20.0);
	CreateDynamic3DTextLabel("< KHU VUC LAY HANG >\nBam '{e75353}Y'{b4b4b4} de lay hang", COLOR_BASIC, 2198.1604,-2267.8938,13.5547, 20.0);
}

stock PickUPTruck(playerid,pickupid) {
	for(new i = 0 ; i < 3 ; i++) {
		if(truck_pickup[i] == pickupid) {
			ShowNotifyTextMain(playerid,"Bam phim '~r~Y~w~' de lay hang tu kho",6);
		}
	}
}
stock DropBox(playerid) {
	SendServerMessage(playerid,"Ban da vut bo banh khoang san.");
	RemovePlayerAttachedObject(playerid, 1);
	SetPlayerSpecialAction(playerid,SPECIAL_ACTION_NONE);
	DeletePVar(playerid, #BoxInHand);

	return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {

	if(newkeys & KEY_YES) {
		if(IsPlayerInRangeOfPoint(playerid, 2.0, 2199.1704,-2274.9971,13.5547)) {
			if(PlayerInfo[playerid][pJob] != 21) return SendErrorMessage(playerid,"Ban khong phai Trucker");
			if(PlayerVehicleRent[playerid] == INVALID_VEHICLE_ID) return SendErrorMessage(playerid,"Ban chua thue phuong tien, khong the hoan tra.");
			if(IsValidVehicle(PlayerVehicleRent[playerid])) DestroyVehicle(PlayerVehicleRent[playerid]);
			PlayerVehicleRent[playerid] = INVALID_VEHICLE_ID;
			for(new i = 0 ; i < 6;i++ ) {
	         	if(BoxInTruck[playerid][i] != 0) {
	         		BoxInTruck[playerid][i] = 0;

	         	}
	        } 
			return 1;

		}
		if(IsPlayerInRangeOfPoint(playerid, 2.0, 1236.9541,177.7182,20.3962)) {
			if(PlayerInfo[playerid][pJob] != 21) return SendErrorMessage(playerid,"Ban khong phai Trucker.");
			if(GetPVarInt(playerid, #BoxInHand) != 1) return SendErrorMessage(playerid,"Ban khong cam thung hang tren tay.");
			SellBox(playerid);
		}
	    if(IsPlayerInRangeOfPoint(playerid, 2.0, 2187.5132,-2258.2197,13.4512)) {
	    	Dialog_Show(playerid, DIALOG_TRUCKER, DIALOG_STYLE_TABLIST, "Cong viec Trucker", "Xin viec\t#\t#\nThue xe\t#\t#\nThoat viec\t#\t#", "Tuy chon","Thoat");
	        return 0;
	    }
	    if(PlayerInfo[playerid][pJob] == 21) {
	    	if(IsPlayerInRangeOfPoint(playerid, 4.0, 2212.9854,-2252.9609,13.5547) || IsPlayerInRangeOfPoint(playerid, 4.0,  2205.4924,-2260.6790,13.5547) || IsPlayerInRangeOfPoint(playerid, 4.0,  2198.1604,-2267.8938,13.5547))
	        {
	        	if(GetPVarInt(playerid, #BoxInHand) == 1) return SendErrorMessage(playerid,"Ban dang cam thung hang tren tay khong tiep tuc lay hang.");
	            if(IsPlayerInAnyVehicle(playerid)) return SendErrorMessage(playerid, " Ban khong the lay thung hang khi dang o tren xe");
	            PlayAnimEx(playerid, "CARRY", "liftup105", 4.1, 0, 0, 0, 0, 0,1);
	           
	            GetBoxTrucker(playerid);
	           
	            return 1;
	        } 
	       
	    	new Float:Pos_X,Float:Pos_Y,Float:Pos_Z;
	    	GetVehicleBoot( PlayerVehicleRent[playerid], Pos_X,Pos_Y,Pos_Z);
	    	if(IsPlayerInRangeOfPoint(playerid, 5.0, Pos_X,Pos_Y,Pos_Z)) {
	    		if(GetPVarInt(playerid, #BoxInHand) == 1)  {
	    			if(CountBoxInVehicle(playerid) >= 6) return SendErrorMessage(playerid,"Xe da chat day hang, ban co the su dung /vutbo thunghang de vut.");
	    			PutBoxInVehicle(playerid);
	    			PlayAnimEx(playerid, "CARRY", "liftup105", 4.1, 0, 0, 0, 0, 0,1);
	    		}
	    		else if(GetPVarInt(playerid, #BoxInHand) == 0)  {
	    			ShowBoxInVehicle(playerid);
	    		}
	    		return 1;
	    	}	
	    }
	} 
	return 1;
}

stock ShowBoxInVehicle(playerid) {
	new str[529];
	str = "@\t#ID\t#\n";
	for(new i = 0 ; i < 6;i++) {
		if(BoxInTruck[playerid][i] == 1) {
            format(str, sizeof str, "%s#Thung hang\t%d\t#\n", str,i);
		}
		if(BoxInTruck[playerid][i] == 0) {
            format(str, sizeof str, "%s#Trong\t#\t#\n", str,i);
		}
	}
	Dialog_Show(playerid,DIALOG_TRUCKBOX, DIALOG_STYLE_TABLIST_HEADERS,"Trucker @ Vehicle",str,"Lay","Thoat");
}
stock CountBoxInVehicle(playerid)
{
	new count_box = 0;
	for(new i = 0 ; i < 6;i++ ) 
	{
		if(BoxInTruck[playerid][i] == 1) count_box++;
	}
	return count_box;
}
stock SellBox(playerid) {
	if(GetPVarInt(playerid, #BoxInHand) != 1) return SendErrorMessage(playerid,"Ban khong cam thung hang tren tay.");
	new random_truck = 80 + random(10),str[129];
	GivePlayerMoneyEx(playerid, random_truck );
	PlayerInfo[playerid][pCountTruck]++;

	format(str, sizeof str, "[TRUCKER] Ban da ban thanh cong thung hang va nhan duoc {57b667}%s{b4b4b4}", number_format(random_truck));
	SendClientMessage(playerid,COLOR_BASIC,str);
	format(str, sizeof str, "Ban da ban thanh cong thung hang va nhan duoc ~g~%s~w~", number_format(random_truck));
	ShowNotifyTextMain(playerid,str,5);
	RemovePlayerAttachedObject(playerid, 1);
	SetPlayerSpecialAction(playerid,SPECIAL_ACTION_NONE);
	DeletePVar(playerid, #BoxInHand);

	new string_log[229];
    format(string_log, sizeof(string_log), "[%s] %s đã bán 1 thùng hàng và nhận được %s", GetLogTime(),GetPlayerNameEx(playerid),number_format(random_truck));         
    SendLogDiscordMSG(job_Trucker, string_log);
	return 1;
}
stock PutBoxInVehicle(playerid)
{
    if(CountBoxInVehicle(playerid) >= 6) return SendErrorMessage(playerid,"Xe da chat day hang, ban co the su dung /vutbo thunghang de vut.");
	for(new i = 0 ; i < 6;i++ ) 
	{
		if(BoxInTruck[playerid][i] == 0) {
			BoxInTruck[playerid][i] = 1;
			// remove player
			RemovePlayerAttachedObject(playerid, 1);
			SetPlayerSpecialAction(playerid,SPECIAL_ACTION_NONE);
			DeletePVar(playerid, #BoxInHand);
			if(CountBoxInVehicle(playerid) >= 6) {
				
				SetPlayerCheckpoint(playerid,1236.9541,177.7182,20.3962, 5.0);
	            CP[playerid] = 252000;

				SendClientMessage(playerid,COLOR_GREEN,"[TRUCK] Ban da chat hang day xe, hay di den checkpoint de giao hang.");
			}
			break ;
		} 
	}

	return 1;
}
stock GetBoxTrucker(playerid) {
	SendClientMessage(playerid,COLOR_GREEN,"Ban da lay hang thanh cong, hay chat hang len xe ( lai gan xe bam phim 'Y')");
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
	SetPlayerAttachedObject( playerid, 1, 1271, 1, 0.002953, 0.469660, -0.009797, 269.851104, 88.443557, 0.000000, 0.804894, 1.000000, 0.822361 );  
	SetPVarInt(playerid,#BoxInHand,1);
	new string_log[229];
    format(string_log, sizeof(string_log), "[%s] %s đã lấy 1 thùng hàng", GetLogTime(),GetPlayerNameEx(playerid));         
    SendLogDiscordMSG(job_Trucker, string_log);
}
Dialog:DIALOG_TRUCKBOX(playerid, response, listitem, inputtext[]) {
	if(response) {
	    if(BoxInTruck[playerid][listitem] == 0) return SendErrorMessage(playerid,"Khong co thung hang nao o slot nay.");
	    BoxInTruck[playerid][listitem] = 0;
	    
	    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
	    SetPlayerAttachedObject( playerid, 1, 1271, 1, 0.002953, 0.469660, -0.009797, 269.851104, 88.443557, 0.000000, 0.804894, 1.000000, 0.822361 );  
	    SetPVarInt(playerid,#BoxInHand,1);
	    ShowNotifyTextMain(playerid,"Ban da cam thung hang tren tay thanh cong, ban co the den gan pickup de ban",6);
	}
	return 1;
}
Dialog:DIALOG_TRUCKER(playerid, response, listitem, inputtext[]) {
	if(response) {
		if(listitem == 0) {
			if(PlayerInfo[playerid][pJob] != 0) return SendClientMessage(playerid, COLOR_BASIC, "Ban dang nhan cong viec khac, hay nghi viec de tiep tuc thuc hien.");
			PlayerInfo[playerid][pJob] = 21;
			SendClientMessage(playerid, COLOR_BASIC, "[Trucker-JOB] Ban da nhan viec {46ad58}Trucker{b4b4b4}, su dung /trogiup > cong viec > Trucker.");
		
		}
		if(listitem == 1) {
			if(PlayerInfo[playerid][pJob] != 21) return SendErrorMessage(playerid,"Ban khong phai la Trucker.");
			if(PlayerVehicleRent[playerid] != INVALID_VEHICLE_ID) return SendErrorMessage(playerid,"Ban da thue xe roi khong the tiep tuc thue.");
            
	        PlayerVehicleRent[playerid] = CreateVehicle(414, 2182.5425,-2276.3689,13.5259,318.6937, random(255), random(255), -1);
	        VehicleFuel[PlayerVehicleRent[playerid]] = 100.0;

	        SetPlayerPos(playerid,2182.5425,-2276.3689,13.5259);

	        PutPlayerInVehicle(playerid, PlayerVehicleRent[playerid], 0);
	        SetPlayerCheckpoint(playerid, 2205.4924,-2260.6790,13.5547, 5);

	        SendClientMessage(playerid, COLOR_BASIC, "[VEHICLE] Su dung /carjob de quan li phuong tien.");	     
			SendClientMessage(playerid, COLOR_BASIC, "[Trucker-JOB] Ban da thue xe {46ad58}Trucker{b4b4b4}, hay di den thung container de lay hang.");
		}
		if(listitem == 2) ShowQuitJob(playerid);
	}
	return 1;
}
hook OnPlayerEnterCheckpoint(playerid) {
	if(IsPlayerInRangeOfPoint(playerid, 5, 2205.4924,-2260.6790,13.5547) || IsPlayerInRangeOfPoint(playerid, 5, 1236.9541,177.7182,20.3962)) 
	{
		DisablePlayerCheckpoint(playerid);
	}

}
hook OnPlayerConnect(playerid) {
	for(new i = 0 ; i < 6;i++ ) {
		BoxInTruck[playerid][i] = 0;


	}
}
hook OnPlayerDisconnect(playerid, reason) {
	for(new i = 0 ; i < 6;i++ ) {
		if(BoxInTruck[playerid][i] != 0) {
			BoxInTruck[playerid][i] = 0;

		}
	}
	if(PlayerVehicleRent[playerid] != INVALID_VEHICLE_ID) {
		DestroyVehicle(PlayerVehicleRent[playerid]);
		PlayerVehicleRent[playerid] = INVALID_VEHICLE_ID;
	}
	DeletePVar(playerid, #BoxInHand);
 
  // progress lay / chat hang
	HideProgress(playerid); // hide progress
	ClearAnimations(playerid);
	stop TruckerTimer[playerid];
	DeletePVar(playerid, #TruckProgress);
}
hook OnVehicleDeath(vehicleid, killerid) {
	new playerid = VehicleRentPlayer(vehicleid);
    if(playerid == 2005) return 1;
	if(vehicleid ==PlayerVehicleRent[playerid]  && PlayerInfo[playerid][pJob] == 21) {
		for(new i = 0 ; i < 6;i++ ) {
	    	if(BoxInTruck[playerid][i] != 0) {
			    BoxInTruck[playerid][i] = 0;

		    }
	    }
    	if(PlayerVehicleRent[playerid] != INVALID_VEHICLE_ID) {
	    	DestroyVehicle(PlayerVehicleRent[playerid]);
	    	PlayerVehicleRent[playerid] = INVALID_VEHICLE_ID;
	    }
	}
	return 1;
}