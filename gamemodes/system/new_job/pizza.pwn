#include <YSI\y_hooks>



new Pizza_Quantity[MAX_PLAYERS];
new Pizza_Holding[MAX_PLAYERS];
new Pizza_Checkpoint[MAX_PLAYERS];



hook OnGameModeInit()
{
	CreateActor(155, 2099.0378,-1801.4995,13.3889,88.5935); // Pizza Boy Job
	CreateDynamic3DTextLabel("Pizza Job\nNhan '{c74a4a}Y{b4b4b4}' de tuong tac.", COLOR_BASIC, 2099.0378,-1801.4995,13.3889+0.5, 5.0);// Pizza Boy Job
}

hook OnPlayerDisconnect(playerid, reason)
{
    if(PlayerVehicleRent[playerid])
	{
   	    Pizza_Quantity[playerid] = 0;
	    DestroyVehicle(PlayerVehicleRent[playerid]);	
        PlayerVehicleRent[playerid] = INVALID_VEHICLE_ID;
	}
	Pizza_Holding[playerid] = 0;
	Pizza_Checkpoint[playerid] = 0;
}
hook OnVehicleDeath(vehicleid, killerid) {
	new playerid = VehicleRentPlayer(vehicleid);
    if(playerid == 2005) return 1;
	if(vehicleid == PlayerVehicleRent[playerid] && PlayerInfo[playerid][pJob] == 24) 
	{

		Pizza_Quantity[playerid] = 0;
	    if(IsValidVehicle(PlayerVehicleRent[playerid])) DestroyVehicle(PlayerVehicleRent[playerid]);

        PlayerVehicleRent[playerid] = INVALID_VEHICLE_ID;

	}
	return 1;
}
hook OnPlayerEnterCheckpoint(playerid)
{
	if(Pizza_Checkpoint[playerid] == 1)
	{
		if(Pizza_Holding[playerid] == 1)
		{
			new houseid = GetPVarInt(playerid,#randhousepizza);
			if(!IsPlayerInRangeOfPoint(playerid, 5, HouseInfo[houseid][hExteriorX], HouseInfo[houseid][hExteriorY], HouseInfo[houseid][hExteriorZ])) return SendErrorMessage(playerid," Ban khong o gan vi tri giao banh");
			Pizza_Holding[playerid] = 0;
			Pizza_Checkpoint[playerid] = 0;
			DeletePVar(playerid, #randhousepizza);
			DisablePlayerCheckpoint(playerid);
			RemovePlayerAttachedObject(playerid,9);
	//		ClearAnimations(playerid);
			SetPlayerSpecialAction(playerid,SPECIAL_ACTION_NONE);
			new str[1080];		    
		    new randomm = 50 + random(70);
		    GivePlayerMoneyEx(playerid, randomm);
		    format(str, sizeof str,"[PIZZA JOB] Ban da giao thanh cong va nhan duoc {51c565}%d$", randomm);
		    SendClientMessage(playerid, COLOR_BASIC, str);
            PlayerInfo[playerid][pCountPizza]++;

		    new string_log[229];
            format(string_log, sizeof(string_log), "[%s] %s đã giao bánh Pizza và nhân được %s", GetLogTime(),GetPlayerNameEx(playerid),number_format(randomm));         
            SendLogDiscordMSG(job_Pizza, string_log);

		    if(Pizza_Quantity[playerid] == 0)
			{
				SendClientMessage(playerid,COLOR_BASIC,"[PIZZA JOB] {b4b4b4}Hay ve cua hang lay them, xe cua ban da het banh.");
			}
			else
			{
				cmd_giaobanh(playerid,"");
			}
		}
		else SendClientMessage(playerid,COLOR_BASIC,"[PIZZA JOB] {b4b4b4}Ban khong cam banh tren tay.");
		return 0;
	}
	return 1;
}


hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	
    if(newkeys & KEY_YES)
    {
        if(IsPlayerInRangeOfPoint(playerid, 5, 2099.0378,-1801.4995,13.3889) && Pizza_Holding[playerid] == 0)
        {
            Dialog_Show(playerid, JOB_PIZZA, DIALOG_STYLE_TABLIST, "Pizza Job - NPC", "Nhan viec\t#\nThue xe\t$100\nTra xe\t#\nLay banh\t#\nNghi viec\t#", "> Tuy chon","Thoat");
        }
    }
    if(PlayerInfo[playerid][pJob] == 24) {
	    if(newkeys & KEY_YES)
        {
        	print("alo alo");
        	
            if(Pizza_Holding[playerid] == 1)
	    	{
	    		new Float:Pos[3];
                GetVehiclePos(PlayerVehicleRent[playerid],Pos[0],Pos[1],Pos[2]);
	    		if(IsPlayerInRangeOfPoint(playerid, 3.0,Pos[0],Pos[1],Pos[2]))
	    		{
	    			if(!IsPlayerInAnyVehicle(playerid))
	    			{
	    				if(Pizza_Quantity[playerid] <= 5)
	    				{
	    				    new str[230], strr[230];
	    					Pizza_Quantity[playerid] ++;					
	    					Pizza_Holding[playerid] = 0;
	    					
	    					ClearAnimations(playerid);
	    					RemovePlayerAttachedObject(playerid,9);
	    					SetPlayerSpecialAction(playerid,SPECIAL_ACTION_NONE);
	    					
	    			        format(str,sizeof(str),"Ban da bo banh vao cop xe so banh hien tai tren xe cua ban la: %d/5 (Bam 'Y' de lay banh khoi xe).",Pizza_Quantity[playerid]);
	    				    ShowNotifyTextMain(playerid,str,10);
	    				    if(Pizza_Quantity[playerid] >= 5) {
	    				    	SendClientMessage(playerid, -1,"{dad067}PIZZA NOTE: {b4b4b4}Ban co the /giaobanh de xac dinh diem giao banh (Checkpoint) Pizza.");
	    				        ShowNotifyTextMain(playerid,"Su dung /giaobanh de bat dau di giao banh.",10);
	    				    }
	    				    
	    				}
	    			}
	    		}
	    		return 1;
	    	}

	    	if(Pizza_Holding[playerid] == 0)
	        {
	    		new Float:Pos[3];
                GetVehiclePos(PlayerVehicleRent[playerid],Pos[0],Pos[1],Pos[2]);
	    		if(IsPlayerInRangeOfPoint(playerid, 1.7,Pos[0],Pos[1],Pos[2])) //return SendClientMessage(playerid,-1,"Ban can o gan phuong tien cua ban");
	    		{
	    			if(Pizza_Quantity[playerid])
	    			{
	    			      
	    			    if(IsPlayerInAnyVehicle(playerid)) return 1;
	    				Pizza_Holding[playerid] = 1;
	      				SetPlayerAttachedObject(playerid, 9, 1582, 5, 0.219000, 0.000000, 0.145000, -82.599922, 0.000000, 102.000038, 1.000000, 1.000000, 1.000000);
	    				//ApplyAnimation(playerid,"CARRY","crry_prtial",4.1,1,0,0,1,1);
	    				SetPlayerSpecialAction(playerid,SPECIAL_ACTION_CARRY);
	    				
	    			
	    				//vehicle
                        new string[1240], strr[1240];								
	    				Pizza_Quantity[playerid] --;											
            		
            			format(string, sizeof(string), "[PIZZA JOB] {b4b4b4}Ban da lay banh tu trong xe ra ({dad067}%d/5{b4b4b4}), di vao CP de giao banh", Pizza_Quantity[playerid]);
	    				ShowNotifyTextMain(playerid,"Hay di vao CP de hoan tat ~y~giao banh",6);
	    				SendClientMessageEx(playerid, -1, string);   		
	    					
	    			}
	    			else ShowNotifyTextMain(playerid,"Xe cua ban ~r~khong con banh~w~ nao de lay, hay quay ve cua hang de lay banh them.",6);
	    		}
	    	}
        }
    }
	return 1;
}


GetRandomHouse(playerid) // check
{
	new index, houseIDs[MAX_HOUSES] = {-1, ...};

	for(new i = 0; i < MAX_HOUSES; i ++)
	{
	    if(HouseInfo[i][hExteriorX] != 0.0)
	    {
	        if(250 <= GetPlayerDistanceFromPoint(playerid, HouseInfo[i][hExteriorX], HouseInfo[i][hExteriorY], HouseInfo[i][hExteriorZ]) <= 1500.0)
	        {
	        	houseIDs[index++] = i;
			}
		}
	}

	if(index == 0)
	{
	    return -1;
	}

	return houseIDs[random(index)];
}


Dialog:JOB_PIZZA(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		switch(listitem)
        {
        	case 0: {
        		if(PlayerInfo[playerid][pJob] != 0) return SendClientMessage(playerid, COLOR_BASIC, "Ban dang nhan cong viec khac, hay nghi viec de tiep tuc thuc hien.");
			    PlayerInfo[playerid][pJob] = 24;
			   


			    SendClientMessage(playerid, COLOR_BASIC, "[PIZZA-JOB] Ban da nhan viec {46ad58}thanh cong{b4b4b4}, su dung /trogiup > cong viec > Pizza Boy.");
 			    if(Question_@TutorialQues[playerid]  == 4) CompletePlayerTutorial(playerid);
        	}
			case 1:
			{
				if(PlayerInfo[playerid][pJob] != 24) return SendClientMessage(playerid, COLOR_BASIC, "Ban khong lam cong viec Pizza Boy khong the thuc hien thao tac.");
				if( PlayerVehicleRent[playerid] != INVALID_VEHICLE_ID) return SendClientMessageEx(playerid, COLOR_BASIC, "[PIZZA JOB] {b4b4b4}Ban da thue xe roi.");
				if(PlayerInfo[playerid][pCash] < 100) return SendErrorMessage(playerid,"Ban khong du tien de thue xe");
				SetPlayerPos(playerid, 2112.9497, -1771.9745, 12.9538);

				PlayerVehicleRent[playerid] = CreateVehicle(448, 2112.9497, -1771.9745, 12.9538, 0 , 3, 3, -1);
				VehicleFuel[PlayerVehicleRent[playerid]] = 100.0;
				PutPlayerInVehicle(playerid, PlayerVehicleRent[playerid] ,0);
			    PlayerInfo[playerid][pModel] = GetPlayerSkin(playerid);
			    SetPlayerSkin(playerid, 155); 
			    GivePlayerMoneyEx(playerid,-100);
				SendClientMessageEx(playerid, -1, "[PIZZA JOB] {b4b4b4}/giaobanh de bat dau, /carjob de thao tac mo khoa/khoa, tim xe .v.v.");			
			    ShowNotifyTextMain(playerid,"Ban da thue xe thanh cong, hay den ~r~NPC lay banh~w~ va chat len xe",6);
			}
			case 2:
			{
				if(PlayerInfo[playerid][pJob] != 24) return SendClientMessage(playerid, COLOR_BASIC, "Ban khong lam cong viec Pizza Boy khong the thuc hien thao tac.");
				if(PlayerVehicleRent[playerid] == INVALID_VEHICLE_ID) return SendClientMessage(playerid, COLOR_BASIC, "Ban chua thue xe khong the thuc hien thao tac.");
				if(PlayerVehicleRent[playerid] != INVALID_VEHICLE_ID)
	        	{
	        	    Pizza_Quantity[playerid] = 0;
				    DestroyVehicle(PlayerVehicleRent[playerid]);		
				    PlayerVehicleRent[playerid] = INVALID_VEHICLE_ID;
	        	}
	        	Pizza_Holding[playerid] = 0;
	        	Pizza_Checkpoint[playerid] = 0;
	            DisablePlayerCheckpoint(playerid);
	            GivePlayerMoneyEx(playerid,90);
	        	new str[1280];
	        	format(str,sizeof(str),"[PIZZA JOB] {b4b4b4}Ban da tra xe cho cua hang, ban duoc hoan tra $90.");
				SendClientMessage(playerid, -1, str);		
				SetPlayerSkin(playerid, PlayerInfo[playerid][pModel]);
			}
			case 3:
			{
				if(PlayerInfo[playerid][pJob] != 24) return SendClientMessage(playerid, COLOR_BASIC, "Ban khong lam cong viec Pizza Boy khong the thuc hien thao tac.");
				if(PlayerVehicleRent[playerid] == INVALID_VEHICLE_ID) return SendClientMessageEx(playerid, COLOR_BASIC,"[PIZZA JOB] {b4b4b4}Ban hay lay xe truoc.");
			    if(Pizza_Holding[playerid] == 1) return SendClientMessageEx(playerid, COLOR_BASIC,"[PIZZA JOB] {b4b4b4}Ban dang mot chiec banh khong the lay them duoc nua.");
				if(IsPlayerInAnyVehicle(playerid)) return SendErrorMessage(playerid, " Ban khong the lay banh khi dang o tren xe");
				SetPlayerAttachedObject(playerid, 9, 1582, 5, 0.219000, 0.000000, 0.145000, -82.599922, 0.000000, 102.000038, 1.000000, 1.000000, 1.000000);
				ApplyAnimation(playerid,"CARRY","crry_prtial",4.1,1,0,0,1,1);
				SetPlayerSpecialAction(playerid,SPECIAL_ACTION_CARRY);
			    Pizza_Holding[playerid] = 1;
			    ShowNotifyTextMain(playerid,"Ban da lay banh thanh cong, hay den gan phuong tien va bam '~r~Y~w~' de bo banh len xe",6);
			}
			case 4: ShowQuitJob(playerid);
		}
	}
	return 1;
}


CMD:giaobanh(playerid, params[])
{
    new houseid;
    
    if(Pizza_Checkpoint[playerid]) return 1;
    if(!Pizza_Quantity[playerid]) return SendClientMessageEx(playerid,COLOR_BASIC, "[PIZZA JOB] {b4b4b4}Xe da het banh hay di lay them.");
    if((houseid = GetRandomHouse(playerid)) == -1)
	{
	    return SendClientMessageEx(playerid, COLOR_BASIC, "Khong co ngoi nha nao yeu cau ban giao banh Pizza. ((Khong co house thoa man dieu kien))");
	}
    new str[120];
	format(str, sizeof str, "[PIZZA JOB] {b4b4b4}Hay giao pizza den nha cua {dad067}%s{b4b4b4}", HouseInfo[houseid][hOwnerName]);
    Pizza_Checkpoint[playerid] = 1;
    SendClientMessage(playerid,COLOR_BASIC, str);
    SetPVarInt(playerid, #randhousepizza, houseid);
    SetPlayerCheckpoint(playerid, HouseInfo[houseid][hExteriorX], HouseInfo[houseid][hExteriorY], HouseInfo[houseid][hExteriorZ], 3);
    return 1;
}


stock DropPizza(playerid) {
	SendServerMessage(playerid,"Ban da vut bo banh Pizza.");
	Pizza_Holding[playerid] = 0;  					
	ClearAnimations(playerid);
	RemovePlayerAttachedObject(playerid,9);
	SetPlayerSpecialAction(playerid,SPECIAL_ACTION_NONE);
	return 1;
}