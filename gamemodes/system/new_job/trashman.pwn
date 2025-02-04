#include <YSI\y_hooks>

#define     ATTACHMENT_INDEX    (4) 
#define     MAX_TRASHBAG     9

enum TrashNum {
	trash_id,
	trash_pos[6],
	trash_object,
	Text3D:trash_text
}

new TrashInfo[MAX_TRASHBAG][TrashNum];
new Trash_Checkpoint[MAX_PLAYERS];
new Trash_CheckpointVeh[MAX_PLAYERS];
new Trash_CheckpointZ[MAX_PLAYERS];
new PickupTrash[MAX_PLAYERS];


new Float:TrashPos[MAX_TRASHBAG][6] = {
	{-1.1,-1.1,1.8}, // bỏ qua thay từ dưới}
	{2144.643554, -1761.804199, 13.359849, 0.000000, -0.000014, 179.999801},
    {2465.372314, -1944.454101, 13.476873, 0.000000, -0.000014, 179.999801},
    {1952.427368, -1908.581298, 13.332811, 0.000022, 0.000007, 89.999900},
    {2704.786132, -1963.870849, 13.329740, 0.000022, 0.000007, 89.999900},
    {2418.824951, -1703.195312, 13.622518, -0.000022, 0.000007, -89.999900},
    {1809.225097, -1722.860473, 13.360607, 0.000000, 0.000029, 0.000000},
    {2305.715332, -1629.067993, 14.285618, -0.000003, 0.000037, -10.000000 },
    {2203.073486, -1422.692382, 23.784370, 0.000015, 0.000007, 89.999923}
};

hook OnGameModeInit()
{
	CreateActor(260, 2200.3394,-1973.6333,13.5578,167.1843); // TrashMan Job
	CreateDynamic3DTextLabel("[JOB] TRASH MAN\nNhan 'Y' de tuong tac.", -1, 2200.3394,-1973.6333,13.5578+0.5, 5.0);// Trash Man Job
	for(new i = 1; i < MAX_TRASHBAG ; i++) 
	{
    	TrashInfo[i][trash_id] = i;
		TrashInfo[i][trash_object] = CreateObject(1334, TrashPos[i][0], TrashPos[i][1], TrashPos[i][2], TrashPos[i][3], TrashPos[i][4], TrashPos[i][5], 300.0);
	    new szResult[158];
    	format(szResult, sizeof szResult, "Trashcan (#%d)");
		TrashInfo[i][trash_text] = CreateDynamic3DTextLabel(szResult, -1, TrashPos[i][0], TrashPos[i][1], TrashPos[i][2], 10.0, .testlos = 1, .streamdistance = 5.0);
    }
}

hook OnPlayerConnect(playerid)
{
	PickupTrash[playerid] = 0;
	DeletePVar(playerid, #TrashPostion);
	Trash_Checkpoint[playerid] = 0;
	Trash_CheckpointZ[playerid] = 0;
	Trash_CheckpointVeh[playerid] = 0;
    
    if(IsValidVehicle(PlayerVehicleRent[playerid])) {
    	DestroyVehicle(PlayerVehicleRent[playerid]);
    	PlayerVehicleRent[playerid] = INVALID_VEHICLE_ID;
    } 
}

hook OnPlayerDisconnect(playerid)
{	
	if(IsValidVehicle(PlayerVehicleRent[playerid]))
	{   
	    DestroyVehicle(PlayerVehicleRent[playerid]);
	    PlayerVehicleRent[playerid] = INVALID_VEHICLE_ID;		
		
	}

 
    RemovePlayerAttachedObject(playerid, ATTACHMENT_INDEX);
	PickupTrash[playerid] = 0;
	Trash_Checkpoint[playerid] = 0;
	Trash_CheckpointZ[playerid] = 0;
	Trash_CheckpointVeh[playerid] = 0;
	DeletePVar(playerid, #TrashPostion);
}

hook OnPlayerEnterCheckpoint(playerid)
{
	if(Trash_Checkpoint[playerid] && IsPlayerInRangeOfPoint(playerid, 5, TrashPos[GetPVarInt(playerid,#TrashPostion)][0],TrashPos[GetPVarInt(playerid,#TrashPostion)][1],TrashPos[GetPVarInt(playerid,#TrashPostion)][2]))
	{
    	Trash_Checkpoint[playerid] = 0;
        DisablePlayerCheckpoint(playerid);
        SendClientMessageEx(playerid, COLOR_BASIC, "{229A00}TRASHMAN JOB: {FFFFFF}An nut 'Y' de lay bich rac.");			
	}
	if(Trash_CheckpointVeh[playerid] && PickupTrash[playerid])
	{
	    ApplyAnimation(playerid, "GRENADE", "WEAPON_throwu", 4.1, 0, 0, 0, 0, 0);
        RemovePlayerAttachedObject(playerid, ATTACHMENT_INDEX);
    	Trash_CheckpointVeh[playerid] = 0;
        PickupTrash[playerid] = 0;
        DisablePlayerCheckpoint(playerid);
        EnterTrashCP(playerid);
	}
	if(Trash_CheckpointZ[playerid] && GetPVarInt(playerid,#TrashPostion) >= 6)
	{
		if(IsPlayerInRangeOfPoint(playerid, 5.0, 2169.8293,-1985.0325,14.0992)) {
			Trash_CheckpointZ[playerid] = 0;
            DisablePlayerCheckpoint(playerid);
            DeletePVar(playerid, #TrashPostion);
            new string[128];
            new trash_money = 180 + random(200);
            format(string,sizeof string,"[TRASHMAN] Ban da hoan thanh cong viec don rac va nhan duoc $%s tien thuong.",number_format(trash_money));
    	    SendClientMessageEx(playerid, -1, string);

    	    PlayerInfo[playerid][pCountTrash]++;

    	    GivePlayerMoneyEx(playerid,trash_money);
    	    if(IsValidVehicle(PlayerVehicleRent[playerid])) DestroyVehicle(PlayerVehicleRent[playerid]);		
			PlayerVehicleRent[playerid] = INVALID_VEHICLE_ID;
			PickupTrash[playerid] = 0;
			Trash_Checkpoint[playerid] = 0;
			Trash_CheckpointVeh[playerid] = 0,
			Trash_CheckpointZ[playerid] = 0;
		    DisablePlayerCheckpoint(playerid);
		    new str[1280];
		    DeletePVar(playerid, #TrashPostion);
		}
        			
	}
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys & KEY_YES)
    {
    	if(IsPlayerInRangeOfPoint(playerid, 5, 2200.3394,-1973.6333,13.5578))
        {
            return Dialog_Show(playerid, JOB_TRASH, DIALOG_STYLE_LIST, "Trashman Job - NPC", "> Xin viec\n> Lay xe\n> Tra xe\n>Nghi viec", "> Tuy chon","Thoat");
        }
        if(PlayerInfo[playerid][pJob] == 22) {
        	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
		    {
		        if(PlayerVehicleRent[playerid] == INVALID_VEHICLE_ID) return 1;
	        	if(IsPlayerInRangeOfPoint(playerid, 4.5, TrashPos[GetPVarInt(playerid,#TrashPostion)][0],TrashPos[GetPVarInt(playerid,#TrashPostion)][1],TrashPos[GetPVarInt(playerid,#TrashPostion)][2])) 
	        	{	               		   
	   		        ApplyAnimation(playerid, "CARRY", "liftup105", 4.1, 0, 0, 0, 0, 0);
					SetPlayerAttachedObject(playerid, ATTACHMENT_INDEX, 1264, 6, 0.222, 0.024, 0.128, 1.90, -90.0, 0.0, 0.5,0.5, 0.5);
					PickupTrash[playerid] = 1;
					new vehicleid = PlayerVehicleRent[playerid];
					
					new Float: x, Float: y, Float: z;
					GetVehicleBoot(vehicleid, x, y, z);
					SetPlayerCheckpoint(playerid, x,y,z, 2.5);
					Trash_CheckpointVeh[playerid] = 1;
					SendClientMessageEx(playerid, COLOR_BASIC, "{229A00}TRASHMAN JOB: {FFFFFF}Hay den sau xe rac de bo bich rac len xe.");			
	        	}		        
		    }
        }     
    }    
	return 1;
}

Dialog:JOB_TRASH(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		switch(listitem)
        {
        	case 0:
			{
				if(PlayerInfo[playerid][pJob] != 0) return SendClientMessage(playerid, COLOR_BASIC, "Ban dang nhan cong viec khac, hay nghi viec de tiep tuc thuc hien.");
			    PlayerInfo[playerid][pJob] = 22;
			    SendClientMessage(playerid, COLOR_BASIC, "[TRASHMAN-JOB] Ban da nhan viec {46ad58}thanh cong{b4b4b4}, su dung /trogiup > Cong viec > Trashman.");
		

			}
			case 1:
			{
				if(PlayerInfo[playerid][pJob] != 22) return SendClientMessage(playerid, COLOR_BASIC, "Ban khong lam cong viec don rac, khong the thue xe.");
				if(PlayerVehicleRent[playerid] == INVALID_VEHICLE_ID)
				{
					SetPlayerPos(playerid, 2169.8293,-1985.0325,14.0992);
					PlayerVehicleRent[playerid] = CreateVehicle(408, 2169.8293,-1985.0325,14.0992,291.137 , 1, 1, -1);
					VehicleFuel[PlayerVehicleRent[playerid]] = 100.0;
					PutPlayerInVehicle(playerid, PlayerVehicleRent[playerid] ,0);
				    SendClientMessage(playerid, COLOR_BASIC, "[VEHICLE] Su dung /carjob de quan li phuong tien.");	 
				    StartTrashClear(playerid);
				//	SendClientMessageEx(playerid, -1, "{229A00}TRASHMAN JOB: {FFFFFF}Ban da lay xe rac, su dung 'layrac' de nhan Checkpoint.");			
			    }
			}
			case 2:
			{
				if(PlayerInfo[playerid][pJob] != 22) return SendClientMessage(playerid, COLOR_BASIC, "Ban khong lam cong viec don rac, khong the tra xe.");
				if(PlayerVehicleRent[playerid] != INVALID_VEHICLE_ID)
	        	{
	        		
				    DestroyVehicle(PlayerVehicleRent[playerid]);		
				    PlayerVehicleRent[playerid] = INVALID_VEHICLE_ID;
				    PickupTrash[playerid] = 0;
					Trash_Checkpoint[playerid] = 0;
					Trash_CheckpointVeh[playerid] = 0,
					Trash_CheckpointZ[playerid] = 0;
		            DisablePlayerCheckpoint(playerid);
		        	new str[1280];
		            DeletePVar(playerid, #TrashPostion);
		        	format(str,sizeof(str),"{229A00}TRASHMAN JOB: {FFFFFF}Ban da tra xe rac thanh cong.");
					SendClientMessage(playerid, -1, str);		
	        	}	        	
			}
			case 3: 
			{
                ShowQuitJob(playerid);
                PickupTrash[playerid] = 0;
				Trash_Checkpoint[playerid] = 0;
				Trash_CheckpointVeh[playerid] = 0,
				Trash_CheckpointZ[playerid] = 0;
	            DisablePlayerCheckpoint(playerid);
            }
		}
	}
	return 1;
}

stock StartTrashClear(playerid) {
	SetPVarInt(playerid, #TrashPostion, 1);
	SetPlayerCheckpoint(playerid, TrashPos[GetPVarInt(playerid,#TrashPostion)][0],TrashPos[GetPVarInt(playerid,#TrashPostion)][1],TrashPos[GetPVarInt(playerid,#TrashPostion)][2],4.5);
	SendClientMessageEx(playerid,COLOR_BASIC,"[TRASHMAN] Di den dia diem checkpoint de don rac (1/7 )");
	Trash_Checkpoint[playerid] = 1;
}

stock EnterTrashCP(playerid) {
	
	SetPVarInt(playerid, #TrashPostion, GetPVarInt(playerid,#TrashPostion)+1);
	if(GetPVarInt(playerid,#TrashPostion) >= 8) {
		SendClientMessage(playerid, COLOR_BASIC, "[TRASHMAN] Hay quay ve tra xe va nhan tien thuong.");
		SetPlayerCheckpoint(playerid, 2169.8293,-1985.0325,14.0992, 5);
	    Trash_CheckpointZ[playerid] = 1;
	}
	else {
		new string[129];
		format(string,sizeof string,"[TRASHMAN] Di den dia diem checkpoint de don rac (%d/7)",GetPVarInt(playerid,#TrashPostion));
		SendClientMessageEx(playerid,COLOR_BASIC,string);
	    SetPlayerCheckpoint(playerid, TrashPos[GetPVarInt(playerid,#TrashPostion)][0],TrashPos[GetPVarInt(playerid,#TrashPostion)][1],TrashPos[GetPVarInt(playerid,#TrashPostion)][2],4.5);
    	Trash_Checkpoint[playerid] = 1;
	}
	return 1;
}


CMD:layrac(playerid, params[])
{
    if(PlayerVehicleRent[playerid] == INVALID_VEHICLE_ID) return 1;
    StartTrashClear(playerid);
    return 1;
}


hook OnVehicleDeath(vehicleid, killerid) {
	new playerid = VehicleRentPlayer(vehicleid);
    if(playerid == 2005) return 1;
	if(vehicleid == PlayerVehicleRent[playerid] && PlayerInfo[playerid][pJob] == 22) {
		DestroyVehicle(PlayerVehicleRent[playerid]);		
		PlayerVehicleRent[playerid] = INVALID_VEHICLE_ID;
		PickupTrash[playerid] = 0;
		Trash_Checkpoint[playerid] = 0;
		Trash_CheckpointVeh[playerid] = 0,
		Trash_CheckpointZ[playerid] = 0;
		DisablePlayerCheckpoint(playerid);
	}
	return 1;
}
