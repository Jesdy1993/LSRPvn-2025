#include <YSI\y_hooks>
enum miner_enum 
{
	MinerID,
	Float:MinerPosX,
	Float:MinerPosY,
	Float:MinerPosZ,
	MinerIsMining,
}
new MinerInfo[][miner_enum] = {
	{0,615.8688,912.4835,-43.6346,0},
	{1,604.8688,912.4835,-43.6346,0},
    {2,599.0956,895.4769,-44.8234,0},
    {3,597.3911,892.1920,-44.7226,0},
    {4,595.0342,887.6500,-44.4139,0},
    {5,591.7537,887.3842,-43.9151,0},
    {6,587.1501,891.9612,-44.5258,0},
    {7,581.6396,889.2723,-43.8129,0},
    {8,582.7945,894.4678,-43.9165,0},
    {9,571.0894,906.4152,-43.1118,0},
    {10,567.4708,909.3448,-42.9609,0},
    {11,563.0715,912.9064,-42.9609,0},
    {12,561.1390,918.3677,-42.9609,0},
    {13,563.0697,918.8301,-42.9609,0},
    {14,565.2639,921.4741,-42.9609,0},
    {15,566.2914,927.6832,-42.9609,0},
    {16,573.2967,929.5395,-42.9609,0}
};
new MinerObject[sizeof(MinerInfo)],
    Text3D:MinerText[sizeof(MinerInfo)],
    MinerInVehicle[MAX_PLAYERS][5],
    MinerTypeVehicle[MAX_PLAYERS][5],
    MinerObjVehicle[MAX_PLAYERS][5],
    PlayerRandomKey[MAX_PLAYERS],
    MinerInHand[MAX_PLAYERS] ;

stock TestRentCar(playerid) {

	PlayerVehicleRent[playerid] = CreateVehicle(422, 569.4735,888.7446,-43.4331,93.7841, random(255), random(255), -1);
	VehicleFuel[PlayerVehicleRent[playerid]] = 100.0;
	PutPlayerInVehicle(playerid, PlayerVehicleRent[playerid], 0);
	return 1;
}
CMD:vutks(playerid,params[]) return DropMiner(playerid);
stock DropMiner(playerid) {
	SendServerMessage(playerid,"Ban da vut bo banh khoang san.");
	RemovePlayerAttachedObject(playerid, 1);
	DeletePVar(playerid,#IsMining);
	SetPlayerSpecialAction(playerid,SPECIAL_ACTION_NONE);
	MinerInHand[playerid] = 0;
    DeletePVar(playerid, #MineType);
    return 1;
}
stock PutMinerInVehicle(playerid) {
	new veh_slot = -1;
	for(new i = 0 ; i < 5;i++) {
		if(MinerInVehicle[playerid][i] == 0) {
            veh_slot = i;
			break ;
		}
	}
	if(veh_slot == -1) return SendErrorMessage(playerid,"Ban khong con cho trong de chat khoang san, vut khoang san bang cach /vutbo miner.");


	MinerInVehicle[playerid][veh_slot] = 1;
    if(CountMinerInVehicle(playerid) >= 5) {
    	SendClientMessageEx(playerid,COLOR_BASIC,"Ban da chat day xe van tai, hay di den noi ban khoang san [GPS > Dia diem ban khoang san]");
    }
	//  player 
	RemovePlayerAttachedObject(playerid, 1);
	DeletePVar(playerid,#IsMining);
	SetPlayerSpecialAction(playerid,SPECIAL_ACTION_NONE);
	MinerInHand[playerid] = 0;
    DeletePVar(playerid, #MineType);
    
	MinerObjVehicle[playerid][veh_slot] = CreateDynamicObject(3931,0,0,0,0,0,0);
	switch(veh_slot) {
        case 0: AttachDynamicObjectToVehicle(MinerObjVehicle[playerid][veh_slot], PlayerVehicleRent[playerid], -0.374999, -1.006999, -0.100000, -51.255008, 0.000000, 0.000000); //Object Model: 3931 | 
        case 1: AttachDynamicObjectToVehicle(MinerObjVehicle[playerid][veh_slot], PlayerVehicleRent[playerid], 0.414999, -0.931999, 0.105000, -171.855056, -159.794998, 0.000000); //Object Model: 3931 | 
        case 2: AttachDynamicObjectToVehicle(MinerObjVehicle[playerid][veh_slot], PlayerVehicleRent[playerid], 0.364999, -1.671999, 0.105000, -171.855056, -229.140335, -41.204998); //Object Model: 3931 | 
        case 3: AttachDynamicObjectToVehicle(MinerObjVehicle[playerid][veh_slot], PlayerVehicleRent[playerid], -0.384999, -1.681999, 0.105000, -171.855056, -299.490661, -41.204998); //Object Model: 3931 | 
        case 4: AttachDynamicObjectToVehicle(MinerObjVehicle[playerid][veh_slot], PlayerVehicleRent[playerid], -0.159999, -1.296999, 0.814999, -333.660827, -293.460632, -54.270011); //Object Model: 3931 | 
	}
	return 1;
}
stock CountMinerInVehicle(playerid) {
	new count = 0;
	for(new i = 0 ; i < 5;i++) {
		if(MinerInVehicle[playerid][i] == 1) count++;
	}
	return count;
}
stock ShowMinerInVehicle(playerid) {
	new str[529];
	str = "#Miner\t#ID\t#Tham dinh\n";
	for(new i = 0 ; i < 5;i++) {
		if(MinerInVehicle[playerid][i] == 1) {
            format(str, sizeof str, "%s#Khoang san\t%d\t#%s\n", str,GetMinerType(MinerTypeVehicle[playerid][i]));
		}
		if(MinerInVehicle[playerid][i] == 0) {
            format(str, sizeof str, "%s#Trong\t#Trong\t#Khong xac dinh\n", str,i);
		}
	}
	Dialog_Show(playerid,VEHICLE_MINER, DIALOG_STYLE_TABLIST_HEADERS,"Miner # Vehicle",str,"Lay","Thoat");
}
Dialog:VEHICLE_MINER(playerid, response, listitem, inputtext[]) {
	if(response) {
		if(MinerInHand[playerid] == 1 || GetPVarInt(playerid, #IsMining) == 2) return SendErrorMessage(playerid,"Ban dang cam khoang san tren tay.");
		if(MinerInVehicle[playerid][listitem] == 0) return SendErrorMessage(playerid,"Khong co khoang san nao trong slot nay.");
		MinerInVehicle[playerid][listitem] = 0;
		SetPVarInt(playerid,#IsMining,2);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
		SetPlayerAttachedObject( playerid, 1, 3931, 1, 0.002953, 0.469660, -0.009797, 269.851104, 88.443557, 0.000000, 0.804894, 1.000000, 0.822361 );   
	    if(IsValidDynamicObject(MinerObjVehicle[playerid][listitem])) DestroyDynamicObject(MinerObjVehicle[playerid][listitem]);

	    MinerInHand[playerid] = 1;
	    SetPVarInt(playerid,#MineType,MinerTypeVehicle[playerid][listitem]); // miner random

	}
	return 1;
}
stock StartMining(playerid,mid) {
	new str[129],key[4];
	switch(PlayerRandomKey[playerid]) {
		case 0: key = "Y";
		case 1: key = "N";
		case 2: key = "Alt";
	}
	format(str, sizeof str, "Bam_phim_'~r~%s~w~_de_tiep_tuc_khai_thac_(Bam_H_de_huy_hanh_dong)", key);
	ShowNotifyTextMain(playerid,str,15);
	SetPVarInt(playerid,#IsMining,1);
	SetPVarInt(playerid,#TaskMining,1);
	format(str, sizeof str, "Press_~r~%s~w~", key);
	ShowProgress(playerid,str,GetPVarInt(playerid,#TaskMining),5);
	ApplyAnimation(playerid, "BASEBALL", "Bat_4", 4.1, 1, 0, 0, 0, 0, 1);
	SetPlayerAttachedObject(playerid, 1, 19631, 6);

	// miner set
	MinerInfo[mid][MinerIsMining] = 1;
	SetPVarInt(playerid, #MineriD, mid);
	format(str, sizeof str, "Miner (%d)\n%s {cd3939}dang khai thac{b4b4b4}...", mid,GetPlayerNameEx(playerid));
	UpdateDynamic3DTextLabelText(MinerText[mid], COLOR_BASIC, str);
}

stock UpdateMining(playerid) {
	new str[129],key[4];
	switch(PlayerRandomKey[playerid]) {
		case 0: key = "Y";
		case 1: key = "N";
		case 2: key = "Alt";
	}

	format(str, sizeof str, "Press:~r~_%s~w~", key);
	GameTextForPlayer(playerid, str, 5000, 3);
	ShowProgress(playerid,str,GetPVarInt(playerid,#TaskMining),10);
	format(str, sizeof str, "Bam_phim_'~r~%s~w~_de_tiep_tuc_khai_thac_(Bam_H_de_huy_hanh_dong)", key);
	ShowNotifyTextMain(playerid,str,15);
	if(GetPVarInt(playerid,#TaskMining) >= 100) {
		
			// data

		SetPVarInt(playerid,#IsMining,2); // miner in hand
	    HideProgress(playerid);
	    ClearAnimations(playerid);
    	DeletePVar(playerid, #TaskMining);

		// interface 
		ShowNotifyTextMain(playerid,"Ban da dao thanh cong mot khoang san tho, hay dat no len xe.",7);

		new string_log[229];
        format(string_log, sizeof(string_log), "[%s] %s đã đào được 1 cục khoáng sản", GetLogTime(),GetPlayerNameEx(playerid));         
        SendLogDiscordMSG(job_Miner, string_log);
  
		SendClientMessage(playerid, COLOR_BASIC, "Ban da dao duoc 1 khoang san, hay di den xe bam 'Y' de dat khoang san len xe.");
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
		SetPlayerAttachedObject( playerid, 1, 3931, 1, 0.002953, 0.469660, -0.009797, 269.851104, 88.443557, 0.000000, 0.804894, 1.000000, 0.822361 );                    
		
    	// miner id
    	new minerid = GetPVarInt(playerid, #MineriD);

    	DestroyDynamicObject(MinerObject[minerid]);
    	DestroyDynamic3DTextLabel(MinerText[minerid]);
    	DeletePVar(playerid, #MineriD);
    	MinerInfo[minerid][MinerIsMining] = 2;
    	defer ResetMiner[60000](minerid);
    	
	}
}

timer ResetMiner[60000](i)
{
	new str[129];
	MinerObject[i] = CreateDynamicObject(3931,  MinerInfo[i][MinerPosX],MinerInfo[i][MinerPosY],MinerInfo[i][MinerPosZ]-1.5, 0,0,0);
	format(str, sizeof str, "Miner (%d)\nBam '{61bf71}Y{b4b4b4}' de thao tac", i);
	MinerText[i] = CreateDynamic3DTextLabel(str, COLOR_BASIC,  MinerInfo[i][MinerPosX],MinerInfo[i][MinerPosY],MinerInfo[i][MinerPosZ]-1.5, 5.0);
    MinerInfo[i][MinerIsMining] = 0;
}
stock GetMinerType(type) {
	new MineName[32];
	switch(type) {
		case 0: MineName = "Sat";
		case 1: MineName = "Dong";
		case 2: MineName = "Vang";
		case 3: MineName = "Bac";
	}
	return MineName;
}
hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys & KEY_YES) {
		print("test");
	    if(IsPlayerInRangeOfPoint(playerid, 2.0, 585.4429,869.6895,-42.4973)) {
	    	Dialog_Show(playerid, DIALOG_MINER, DIALOG_STYLE_TABLIST_HEADERS, "Cong viec Miner", "Tuy chon\t#\t#\nXin viec\t#\t#\nThue xe\t#\t#\nThoat viec\t#\t#", "Tuy chon","Thoat");
	        return 0;
	    }
	}
	if(PlayerInfo[playerid][pJob] == 20 || PlayerInfo[playerid][pJob2] == 20) {

	    if(newkeys & KEY_YES) {
	    
	    	if(IsPlayerInRangeOfPoint(playerid, 2.5, 581.1198,863.1816,-43.2946)) {
		    	if(PlayerVehicleRent[playerid] == INVALID_VEHICLE_ID) return SendErrorMessage(playerid,"Ban khong thue xe khong the hoan tra.");
                if(!IsPlayerInAnyVehicle(playerid)) return SendErrorMessage(playerid,"Ban phai ngoi tren xe Miner ban da thue.");
                if(GetPlayerVehicleID(playerid) != PlayerVehicleRent[playerid] ) return SendErrorMessage(playerid,"Ban phai ngoi tren xe Miner ban da thue.");
                DestroyVehicle(PlayerVehicleRent[playerid] );
                PlayerVehicleRent[playerid] = INVALID_VEHICLE_ID;
                for(new i = 0 ; i < 5; i++) {
                	MinerInVehicle[playerid][i] = 0;
                	MinerTypeVehicle[playerid][i] = 0;
                	if(IsValidDynamicObject(MinerObjVehicle[playerid][i])) DestroyDynamicObject(MinerObjVehicle[playerid][i]);
                }
                return 1;
		    }
	  
	        if(IsPlayerInRangeOfPoint(playerid, 5.0, 301.3658,-173.1053,1.5781) || IsPlayerInRangeOfPoint(playerid, 5.0,312.5071,-173.7401,1.5781)) {
	        	if(MinerInHand[playerid] == 0) return SendErrorMessage(playerid,"Ban khong cam khoang san tren tay khong the ban.");
	        	new str[129],random_money;
	        	random_money = 50 + random(70);
	        	GivePlayerMoneyEx(playerid,random_money);
	            format(str, sizeof str, "Ban da ban thanh cong ~g~khoang san~w~ va nhan duoc ~g~$%s~w~",number_format(random_money));
	            ShowNotifyTextMain(playerid,str,7);

	            format(str, sizeof str, "[MINER-SELL] Ban da ban thanh cong khoang san, ban nhan duoc so tien {459a4f}$%s{b4b4b4}",number_format(random_money));
                SendClientMessage(playerid,COLOR_BASIC,str);
                MinerInHand[playerid] = 0;
 	        	DeletePVar(playerid,#IsMining);
 	        	PlayerInfo[playerid][pCountMiner]++;



 	        	new string_log[229];
                format(string_log, sizeof(string_log), "[%s] %s đã bán 1 khoáng sản và nhận được %s", GetLogTime(),GetPlayerNameEx(playerid),number_format(random_money));         
                SendLogDiscordMSG(job_Miner, string_log);
  
 	        	

	        	RemovePlayerAttachedObject(playerid, 1);
	            SetPlayerSpecialAction(playerid,SPECIAL_ACTION_NONE);
	        
	        	DeletePVar(playerid, #MineType);

	            return 1;
	        }      
	    }
	
	    if(newkeys & KEY_YES) {
	  
	    	new Float:Pos_X,Float:Pos_Y,Float:Pos_Z;
	    	GetVehicleBoot( PlayerVehicleRent[playerid],  Pos_X,Pos_Y,Pos_Z) ;
	    	if(IsPlayerInRangeOfPoint(playerid, 4.0, Pos_X,Pos_Y,Pos_Z)) {
	
	    	    if(GetPVarInt(playerid, #IsMining) == 2) {

	    	    	PutMinerInVehicle(playerid);
	    	    	return 1;
	    	    }
	    	    else if(GetPVarInt(playerid, #IsMining) == 0) {
	    	    	ShowMinerInVehicle(playerid);
	    	    	return 1;
	    	    }
	    	}
	        if(GetPVarInt(playerid, #IsMining) == 0) {
	    	    for(new i = 0 ; i < sizeof(MinerInfo) ; i++) 
	            {
	            	if(IsPlayerInRangeOfPoint(playerid, 1.5, MinerInfo[i][MinerPosX],MinerInfo[i][MinerPosY],MinerInfo[i][MinerPosZ]) && MinerInfo[i][MinerIsMining] == 0)
	            	{
	            		if(PlayerVehicleRent[playerid] == INVALID_VEHICLE_ID) return ShowNotifyTextMain(playerid,"Ban can phai thue xe ~r~Bobcat~w~ moi co the thuc hien",8);
	            		StartMining(playerid,i);
	            		printf("Minerid: %d",i);
	            		return 1;
	            	}
	            }
	           
	    	}
	    }
    
        if(GetPVarInt(playerid, #IsMining) == 1) {
        	if(newkeys & KEY_CTRL_BACK) {

                new str[129];
        		format(str, sizeof str, "Miner (%d)\nBam '{61bf71}Y{b4b4b4}' de thao tac", GetPVarInt(playerid, #MineriD));
         		UpdateDynamic3DTextLabelText( MinerText[GetPVarInt(playerid, #MineriD)], COLOR_BASIC, str);
        		ClearAnimations(playerid);
        		PlayerRandomKey[playerid] = 0;
        		DeletePVar(playerid, #IsMining);
        		DeletePVar(playerid, #TaskMining);
        		HideProgress(playerid);
        		HideTextMain(playerid);
        		RemovePlayerAttachedObject(playerid, 1);
                   
        		SetPVarInt(playerid, #IsMining, 0);
        		MinerInfo[GetPVarInt(playerid, #MineriD)][MinerIsMining] = 0;
                

        		return 1;
        	}
        	if(newkeys & KEY_YES ) {
                if(PlayerRandomKey[playerid] != 0)  {
                	PlayerRandomKey[playerid] = random(2);
        		    ApplyAnimation(playerid, "BASEBALL", "Bat_4", 4.1, 1, 0, 0, 0, 0, 1);
        		    new random_fine = GetPVarInt(playerid,#TaskMining) - random(30);
        		    if(random_fine <= 0) random_fine = 0;
        		    SetPVarInt(playerid,#TaskMining,random_fine);
        		    UpdateMining(playerid);
        		    return 1;
                }
        		PlayerRandomKey[playerid] = random(2);
        		ApplyAnimation(playerid, "BASEBALL", "Bat_4", 4.1, 1, 0, 0, 0, 0, 1);
        		SetPVarInt(playerid,#TaskMining,GetPVarInt(playerid,#TaskMining) + random(10));
        		UpdateMining(playerid);
            }
            if(newkeys & KEY_NO) {
                if(PlayerRandomKey[playerid] != 1) {
                	PlayerRandomKey[playerid] = random(2);
        		    ApplyAnimation(playerid, "BASEBALL", "Bat_4", 4.1, 1, 0, 0, 0, 0, 1);
        		    new random_fine = GetPVarInt(playerid,#TaskMining) - random(30);
        		    if(random_fine <= 0) random_fine = 0;
        		    SetPVarInt(playerid,#TaskMining,random_fine);
        		    UpdateMining(playerid);
        		    return 1;
                }
            	PlayerRandomKey[playerid] = random(2);
            	ApplyAnimation(playerid, "BASEBALL", "Bat_4", 4.1, 1, 0, 0, 0, 0, 1);
        		SetPVarInt(playerid,#TaskMining,GetPVarInt(playerid,#TaskMining) + random(10));
        		UpdateMining(playerid);
    
            }
        }
    }
    return 1;
}
Dialog:DIALOG_MINER(playerid, response, listitem, inputtext[]) {
	if(response) {
		if(listitem == 0) {
			if(PlayerInfo[playerid][pJob] != 0) return SendClientMessage(playerid, COLOR_BASIC, "Ban dang nhan cong viec khac, hay nghi viec de tiep tuc thuc hien.");
			PlayerInfo[playerid][pJob] = 20;
			SendClientMessage(playerid, COLOR_BASIC, "[MINER-JOB] Ban da nhan viec {46ad58}thanh cong{b4b4b4}, su dung /trogiup > cong viec > Miner.");
		
		}
		if(listitem == 1) {
			if(PlayerInfo[playerid][pJob] != 20) return SendClientMessage(playerid, COLOR_BASIC, "Ban khong lam cong viec Miner khong the thue xe.");
			if(PlayerVehicleRent[playerid] != INVALID_VEHICLE_ID) return SendErrorMessage(playerid,"Ban da thue xe roi khong the tiep tuc thue.");
	        TestRentCar(playerid);
	        SendClientMessage(playerid, COLOR_BASIC, "[VEHICLE] Su dung /carjob de quan li phuong tien.");	 
			SendClientMessage(playerid, COLOR_BASIC, "[MINER-JOB] Ban da thue xe {46ad58}thanh cong{b4b4b4}, hay di lam cong viec cua minh.");
		}
		if(listitem == 2) ShowQuitJob(playerid);
	}
	return 1;
}
hook OnPlayerConnect(playerid) {
	if(IsValidVehicle(PlayerVehicleRent[playerid] )) {
		DestroyVehicle(PlayerVehicleRent[playerid] );
     	PlayerVehicleRent[playerid] = INVALID_VEHICLE_ID;
    }
   	for(new i = 0 ; i < 5; i++) {
   		MinerInVehicle[playerid][i] = 0;
   		MinerTypeVehicle[playerid][i] = 0;
   		DestroyDynamicObject(MinerObjVehicle[playerid][i]);

   	}
	if(GetPVarInt(playerid,#IsMining) != 0) {
		RemovePlayerAttachedObject(playerid,1);
	}
}
hook OnPlayerDisconnect(playerid, reason) {

	if(IsValidVehicle(PlayerVehicleRent[playerid] )) {
		DestroyVehicle(PlayerVehicleRent[playerid] );
     	PlayerVehicleRent[playerid] = INVALID_VEHICLE_ID;
    }
   	for(new i = 0 ; i < 5; i++) {
   		MinerInVehicle[playerid][i] = 0;
   		MinerTypeVehicle[playerid][i] = 0;
   		if(IsValidDynamicObject(MinerObjVehicle[playerid][i])) DestroyDynamicObject(MinerObjVehicle[playerid][i]);

   	}
	if(GetPVarInt(playerid,#IsMining) != 0) {
		RemovePlayerAttachedObject(playerid,1);
	}
	return 1;
	
}
stock SetUPMiner() {
	new str[129];
	for(new i = 0 ; i < sizeof(MinerInfo) ; i++) {
		MinerObject[i] = CreateDynamicObject(3931,  MinerInfo[i][MinerPosX],MinerInfo[i][MinerPosY],MinerInfo[i][MinerPosZ]-1.5, 0,0,0);
	    format(str, sizeof str, "Miner (%d)\nBam '{61bf71}Y{b4b4b4}' de thao tac", i);
	    MinerText[i] = CreateDynamic3DTextLabel(str, COLOR_BASIC,  MinerInfo[i][MinerPosX],MinerInfo[i][MinerPosY],MinerInfo[i][MinerPosZ]-1.5, 5.0);
	}
}
hook OnGameModeInit() {
	SetUPMiner();

	CreateActor(262, 585.4429,869.6895,-42.4973,271.7751);
	CreateDynamic3DTextLabel("Miner\nBam 'Y' tuong tac", COLOR_BASIC, 585.4429,869.6895,-42.4973, 20.0);
	CreateDynamic3DTextLabel("Nhan 'Y' de tuong tac", COLOR_BASIC, 601.9241,920.3962,-41.9648, 20.0);
	CreateDynamic3DTextLabel("Nhan 'Y' de tuong tac", COLOR_BASIC, 556.4504,917.8444,-42.7328, 20.0);
	CreateDynamic3DTextLabel("Noi ban khoang san\nBam '{61bf71}Y{b4b4b4}' de thao tac", COLOR_BASIC, 301.3658,-173.1053,1.5781, 20.0);
	CreateDynamic3DTextLabel("Noi ban khoang san\nBam '{61bf71}Y{b4b4b4}' de thao tac", COLOR_BASIC, 312.5071,-173.7401,1.5781, 20.0);
	CreateDynamic3DTextLabel("Miner\nBam 'Y' de tra xe", COLOR_BASIC, 581.1198,863.1816,-43.2946, 20.0);
}

hook OnVehicleDeath(vehicleid) {
	new playerid = VehicleRentPlayer(vehicleid);
	if(playerid == 2005) return 1;
	if(vehicleid == PlayerVehicleRent[playerid] && PlayerInfo[playerid][pJob] == 20) {
		if(IsValidVehicle(PlayerVehicleRent[playerid] )) {
		    DestroyVehicle(PlayerVehicleRent[playerid] );
         	PlayerVehicleRent[playerid] = INVALID_VEHICLE_ID;
        }
        for(new i = 0 ; i < 5; i++) {
        	MinerInVehicle[playerid][i] = 0;
        	MinerTypeVehicle[playerid][i] = 0;
        	if(IsValidDynamicObject(MinerObjVehicle[playerid][i])) DestroyDynamicObject(MinerObjVehicle[playerid][i]);
        }
	}
	return 0;
}


    // AddPlayerClass(8,601.9241,920.3962,-41.9648,83.7055,0,0,0,0,0,0); // 
    // AddPlayerClass(8,556.4504,917.8444,-42.7328,95.4243,0,0,0,0,0,0); // 

    // AttachObjectToVehicle(objectid, vehicleid, -0.374999, -1.006999, -0.100000, -51.255008, 0.000000, 0.000000); //Object Model: 3931 | 
    // AttachObjectToVehicle(objectid, vehicleid, 0.414999, -0.931999, 0.105000, -171.855056, -159.794998, 0.000000); //Object Model: 3931 | 
    // AttachObjectToVehicle(objectid, vehicleid, 0.364999, -1.671999, 0.105000, -171.855056, -229.140335, -41.204998); //Object Model: 3931 | 
    // AttachObjectToVehicle(objectid, vehicleid, -0.384999, -1.681999, 0.105000, -171.855056, -299.490661, -41.204998); //Object Model: 3931 | 
    // AttachObjectToVehicle(objectid, vehicleid, -0.159999, -1.296999, 0.814999, -333.660827, -293.460632, -54.270011); //Object Model: 3931 | 
// AttachObjectToVehicle(objectid, vehicleid, -0.379999, -0.939999, 0.000000, -76.379989, 0.000000, 0.000000); //Object Model: 3931 | 
// AttachObjectToVehicle(objectid, vehicleid, 0.369999, -0.939999, 0.000000, -138.689895, -148.739944, -208.035232); //Object Model: 3931 | 
// AttachObjectToVehicle(objectid, vehicleid, 0.339999, -1.699998, 0.000000, -138.689895, -187.935134, -230.145339); //Object Model: 3931 | 
// AttachObjectToVehicle(objectid, vehicleid, -0.444999, -1.699998, 0.000000, -138.689895, -229.140335, -230.145339); //Object Model: 3931 | 
// AttachObjectToVehicle(objectid, vehicleid, 0.099999, -1.284999, 0.674999, -138.689895, -308.535705, -230.145339); //Object Model: 3931 | 
