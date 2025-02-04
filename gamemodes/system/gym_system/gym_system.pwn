#include <YSI\y_hooks>

enum gyminfo
{
	gyused,
	gytype,
	gyplayerid,
	gyobject[2],
	Text3D:gytext,
	Float:gypos[6],
	Float:gyfitness,
}
new GymInfo[100][gyminfo];
new GymStack[MAX_PLAYERS];
// key
hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if(newkeys & KEY_YES)
	{   
		new gymid = GetGymNearest(playerid);
		if(IsPlayerInRangeOfPoint(playerid, 2, GymInfo[gymid][gypos][0],GymInfo[gymid][gypos][1],GymInfo[gymid][gypos][2])) // Tạ đứng san Fierro
		{
            
			if(GymInfo[gymid][gyplayerid] == INVALID_PLAYER_ID)
			{
				if(CheckPlayerHunger(playerid) == -1) {
					SendClientMessage(playerid, COLOR_BASIC, "Ban dang o trang thai met moi, khong the tiep tuc cac cong viec ({b84d4d}kiem tra Fitness Information{b4b4b4}).");
					ShowNotifyTextMain(playerid,"Ban dang o trang thai ~r~met moi~w~hay nghi ngoi va an uong (Kiem tra Fitness Information).",6);
					return 1;
				}
				if(GymInfo[gymid][gytype] == 1) // ------------------------------------------------------ Tạ đứng (2  tay) || || || || || || || || || ||
				{
					if(!GetPVarInt(playerid, "GymStep"))
					{
						ShowNotifyTextMain(playerid,"Ban dang bat dau ~r~tap luyen~w~...",6);
						SetPVarInt(playerid, "GymStep", 1);
						SetPVarInt(playerid, "GymID", gymid);
						SetPlayerPos(playerid, GymInfo[gymid][gypos][0] + (0.5138 + 0.5), GymInfo[gymid][gypos][1] - 0.2217, GymInfo[gymid][gypos][2] + 0.9688);
						SetPlayerFacingAngle(playerid, 86.2183);
						TogglePlayerControllable(playerid, 0);
						DestroyDynamic3DTextLabel(GymInfo[gymid][gytext]);
						GymInfo[gymid][gyplayerid] = playerid;
						ApplyAnimation(playerid, "Freeweights", "gym_free_pickup", 1, 0, 0, 0, 1, 0, 1);
						SetTimerEx("SettingGymType", 2100, false, "iii", playerid, gymid, GymInfo[gymid][gytype]);
					}
					else return SendClientMessageEx(playerid, COLOR_BASIC ,"[GYM SYSTEM] Ban dang tap gym.");
				}
				else if(GymInfo[gymid][gytype] == 2) // ------------------------------------------------------ Tạ nằm || || || || || || || || || ||
				{
					if(!GetPVarInt(playerid, "GymStep"))
					{
						ShowNotifyTextMain(playerid,"Ban dang bat dau ~r~tap luyen~w~...",6);
						SetPVarInt(playerid, "GymStep", 1);
						SetPVarInt(playerid, "GymID", gymid);
						SetPlayerPos(playerid, GymInfo[gymid][gypos][0] + 0.0255, GymInfo[gymid][gypos][1] - 0.8833, GymInfo[gymid][gypos][2] + 0.9688);
						SetPlayerFacingAngle(playerid, 358.1942);
						TogglePlayerControllable(playerid, 0);
						DestroyDynamic3DTextLabel(GymInfo[gymid][gytext]);
						GymInfo[gymid][gyplayerid] = playerid;
						ApplyAnimation(playerid, "benchpress", "gym_bp_geton", 1, 0, 0, 0, 1, 0, 1);
						SetTimerEx("SettingGymType", 3850, false, "iii", playerid, gymid, GymInfo[gymid][gytype]);
					}
					else return SendClientMessageEx(playerid, COLOR_BASIC ,"[GYM SYSTEM] Ban dang tap gym.");
				}
				else if(GymInfo[gymid][gytype] == 3) // ------------------------------------------------------ Xe đạp || || || || || || || || || ||
				{
					if(!GetPVarInt(playerid, "GymStep"))
					{
						ShowNotifyTextMain(playerid,"Ban dang bat dau ~r~tap luyen~w~...",6);
						SetPVarInt(playerid, "GymStep", 1);
						SetPVarInt(playerid, "GymID", gymid);
						SetPlayerPos(playerid, GymInfo[gymid][gypos][0] + 0.3545, GymInfo[gymid][gypos][1] - 0.3675, GymInfo[gymid][gypos][2] + 0.9688);
						SetPlayerFacingAngle(playerid, 85.0000);
						TogglePlayerControllable(playerid, 0);
						DestroyDynamic3DTextLabel(GymInfo[gymid][gytext]);
						GymInfo[gymid][gyplayerid] = playerid;
						ApplyAnimation(playerid, "GYMNASIUM", "gym_bike_geton", 1, 0, 0, 0, 1, 0, 1);
						SetTimerEx("SettingGymType", 2000, false, "iii", playerid, gymid, GymInfo[gymid][gytype]);
					}
					else return SendClientMessageEx(playerid, COLOR_BASIC ,"[GYM SYSTEM] Ban dang tap gym.");
				}
				else if(GymInfo[gymid][gytype] == 4) // ------------------------------------------------------ Máy chạy || || || || || || || || || ||
				{
					if(!GetPVarInt(playerid, "GymStep"))
					{
						ShowNotifyTextMain(playerid,"Ban dang bat dau ~r~tap luyen~w~...",6);
						SetPVarInt(playerid, "GymStep", 1);
						SetPVarInt(playerid, "GymID", gymid);
						SetPlayerPos(playerid, GymInfo[gymid][gypos][0] + 0.0156, GymInfo[gymid][gypos][1] - 1.4000, GymInfo[gymid][gypos][2] + 0.9688);
						SetPlayerFacingAngle(playerid, 0.3876);
						TogglePlayerControllable(playerid, 0);
						DestroyDynamic3DTextLabel(GymInfo[gymid][gytext]);
						GymInfo[gymid][gyplayerid] = playerid;
						ApplyAnimation(playerid, "GYMNASIUM", "gym_tread_geton", 1, 0, 0, 0, 1, 0, 1);
						SetTimerEx("SettingGymType", 2000, false, "iii", playerid, gymid, GymInfo[gymid][gytype]);
					}
					else return SendClientMessageEx(playerid, COLOR_BASIC ,"[GYM SYSTEM] Ban dang tap gym.");
				}
				else return SendClientMessageEx(playerid, COLOR_BASIC ,"[GYM SYSTEM] Loi khong xac dinh loai may.");
			}
			else return SendClientMessageEx(playerid, COLOR_BASIC ,"[GYM SYSTEM] Dang co nguoi su dung may Gym nay.");
		}

	}
	else if(newkeys & KEY_NO)
	{
		new gymid = GetPVarInt(playerid, "GymID");

	
		if(IsPlayerInRangeOfPoint(playerid, 2, GymInfo[gymid][gypos][0],GymInfo[gymid][gypos][1],GymInfo[gymid][gypos][2])) // Tạ đứng san Fierro
		{
			if(GymInfo[gymid][gyplayerid] == playerid)
			{
				if(GymInfo[gymid][gytype] == 1) // ------------------------------------------------------ Tạ đứng (2  tay) || || || || || || || || || ||
				{
					if(GetPVarInt(playerid, "GymStep") == 1)
					{
						SetPVarInt(playerid, "GymStep",2);
						switch(random(2))
						{
							case 0: ApplyAnimation(playerid, "freeweights", "gym_free_A", 1, 0, 0, 0, 1, 0, 1);
				  			case 1: ApplyAnimation(playerid, "freeweights", "gym_free_B", 1, 0, 0, 0, 1, 0, 1);
						}
						ShowNotifyTextMain(playerid,"~g~Bat dau tap luyen~w~ vui long doi...'",6);
						SetTimerEx("StopGymAnimation",2000, false, "ii", playerid, GymInfo[gymid][gytype]);
					}
				}
				else if(GymInfo[gymid][gytype] == 2) // ------------------------------------------------------ Tạ nằm || || || || || || || || || ||
				{
					if(GetPVarInt(playerid, "GymStep") == 1)
					{
						SetPVarInt(playerid, "GymStep",2);
						switch(random(2))
						{
							case 0: ApplyAnimation(playerid, "benchpress", "gym_bp_up_A", 1, 0, 0, 0, 1, 0, 1);
							case 1: ApplyAnimation(playerid, "benchpress", "gym_bp_up_B", 1, 0, 0, 0, 1, 0, 1);
						}
						ShowNotifyTextMain(playerid,"~g~Bat dau tap luyen~w~ vui long doi...'",6);
						SetTimerEx("StopGymAnimation",2000, false, "ii", playerid, GymInfo[gymid][gytype]);
					}
				}
				else if(GymInfo[gymid][gytype] == 3) // ------------------------------------------------------ Xe đạp || || || || || || || || || ||
				{
					if(GetPVarInt(playerid, "GymStep") == 1)
					{
						if(GymStack[playerid] >= 0 && GymStack[playerid] <= 15)
						{
							ApplyAnimation(playerid, "GYMNASIUM", "gym_bike_still", 1, 1, 0, 0, 1, 0, 1);
							GymStack[playerid]++;
						}
						else if(GymStack[playerid] >= 16 && GymStack[playerid] <= 30)
						{
							ApplyAnimation(playerid, "GYMNASIUM", "gym_bike_slow", 1, 1, 0, 0, 1, 0, 1);
							GymStack[playerid]++;
						}
						else if(GymStack[playerid] >= 31 && GymStack[playerid] <= 45)
						{
							ApplyAnimation(playerid, "GYMNASIUM", "gym_bike_pedal", 1, 1, 0, 0, 1, 0, 1);
							GymStack[playerid]++;
						}
						else if(GymStack[playerid] >= 46 && GymStack[playerid] <= 55)
						{
							ApplyAnimation(playerid, "GYMNASIUM", "gym_bike_fast", 1, 1, 0, 0, 1, 0, 1);
							GymStack[playerid]++;
						}
						else if(GymStack[playerid] >= 56 && GymStack[playerid] <= 70)
						{
							ApplyAnimation(playerid, "GYMNASIUM", "gym_bike_faster", 1, 1, 0, 0, 1, 0, 1);
							GymStack[playerid]++;
						}
						else if(GymStack[playerid] > 70)
						{
							ShowNotifyTextMain(playerid,"~g~Bat dau tap luyen~w~ vui long doi...'",6);
							ApplyAnimation(playerid, "GYMNASIUM", "gym_bike_celebrate", 4.1, 0, 0, 0, 1, 0, 1);
							SetPVarInt(playerid, "GymStep", 2);
							SetTimerEx("ResetGymVariable", 1000, false, "i",playerid);
						}
					}
				}
				else if(GymInfo[gymid][gytype] == 4) // ------------------------------------------------------ Máy chạy || || || || || || || || || ||
				{
					if(GetPVarInt(playerid, "GymStep") == 1)
					{
						if(GymStack[playerid] >= 0 && GymStack[playerid] <= 15)
						{
							ApplyAnimation(playerid, "GYMNASIUM", "gym_tread_jog", 1, 1, 0, 0, 1, 0, 1);
							GymStack[playerid]++;
						}
						else if(GymStack[playerid] >= 16 && GymStack[playerid] <= 30)
						{
							ApplyAnimation(playerid, "GYMNASIUM", "gym_tread_sprint", 1, 1, 0, 0, 1, 0, 1);
							GymStack[playerid]++;
						}
						else if(GymStack[playerid] >= 31 && GymStack[playerid] <= 45)
						{
							ApplyAnimation(playerid, "GYMNASIUM", "gym_tread_tired", 4.1, 0, 0, 0, 1, 0, 1);
							GymStack[playerid]++;
						}
						else if(GymStack[playerid] > 45 && GymStack[playerid] <= 55)
						{
							ShowNotifyTextMain(playerid,"~g~Bat dau tap luyen~w~ vui long doi...'",6);
							ApplyAnimation(playerid, "GYMNASIUM", "gym_tread_falloff", 4.1, 0, 0, 0, 1, 0, 1);
							GymStack[playerid]++;
							SetPVarInt(playerid, "GymStep", 2);
							SetTimerEx("ResetGymVariable", 2000, false, "i",playerid);
						}
					}
				}
			}
		}
	}
	else if(newkeys == KEY_SPRINT)
	{
		if(GetPVarInt(playerid, "GymStep") == 1)
		{
			if(GymInfo[GetPVarInt(playerid, "GymID")][gytype] == 1)
			{
				ApplyAnimation(playerid, "freeweights", "gym_free_putdown", 1, 0, 0, 0, 1, 0, 1);
				SetTimerEx("StopGym",800, false, "iii", playerid, GetPVarInt(playerid, "GymID"), GymInfo[GetPVarInt(playerid, "GymID")][gytype]);
				SetPVarInt(playerid, "GymStep", 3);
			}
			else if(GymInfo[GetPVarInt(playerid, "GymID")][gytype] == 2)
			{	
				ApplyAnimation(playerid, "benchpress", "gym_bp_getoff", 1, 0, 0, 0, 1, 0, 1);
				SetTimerEx("StopGym",3200, false, "iii", playerid, GetPVarInt(playerid, "GymID"), GymInfo[GetPVarInt(playerid, "GymID")][gytype]);
				SetPVarInt(playerid, "GymStep", 3);
			}
			else if(GymInfo[GetPVarInt(playerid, "GymID")][gytype] == 3)
			{	
				ApplyAnimation(playerid, "GYMNASIUM", "gym_bike_getoff", 1, 0, 0, 0, 1, 0, 1);
				SetTimerEx("StopGym",1100, false, "iii", playerid, GetPVarInt(playerid, "GymID"), GymInfo[GetPVarInt(playerid, "GymID")][gytype]);
				SetPVarInt(playerid, "GymStep", 3);
			}
			else if(GymInfo[GetPVarInt(playerid, "GymID")][gytype] == 4)
			{	
				ApplyAnimation(playerid, "GYMNASIUM", "gym_tread_getoff", 1, 0, 0, 0, 1, 0, 1);
				SetTimerEx("StopGym",1100, false, "iii", playerid, GetPVarInt(playerid, "GymID"), GymInfo[GetPVarInt(playerid, "GymID")][gytype]);
				SetPVarInt(playerid, "GymStep", 3);
			}
		}
	}
	return 0;
}
stock GettingGymObject(gymid, type)
{
	switch(type)
	{
		case 1:
		{
			
			if(IsValidDynamicObject(GymInfo[gymid][gyobject][0])) { DestroyDynamicObject(GymInfo[gymid][gyobject][0]); }
			if(IsValidDynamicObject(GymInfo[gymid][gyobject][1])) { DestroyDynamicObject(GymInfo[gymid][gyobject][1]); }

			GymInfo[gymid][gyobject][0] = CreateDynamicObject(3071, GymInfo[gymid][gypos][0] + 0.00000, GymInfo[gymid][gypos][1] + 0.10200, GymInfo[gymid][gypos][2] + 0.00000,   0.00000, -90.00000, 90.00000);
			GymInfo[gymid][gyobject][1] = CreateDynamicObject(3072, GymInfo[gymid][gypos][3] + 0.00600, GymInfo[gymid][gypos][4] - 0.36000, GymInfo[gymid][gypos][5] + 0.00000,   0.00000, -90.00000, 90.00000);



			GymInfo[gymid][gytext] = CreateDynamic3DTextLabel("Bam'{b84d4d}Y{b4b4b4}' de thao tac", COLOR_BASIC,  GymInfo[gymid][gypos][0] + 0.5138, GymInfo[gymid][gypos][1] - 0.2217, GymInfo[gymid][gypos][2] - 0.2688, 15);
		}
		case 2:
		{

			if(IsValidDynamicObject(GymInfo[gymid][gyobject][0])) { DestroyDynamicObject(GymInfo[gymid][gyobject][0]); }
			if(IsValidDynamicObject(GymInfo[gymid][gyobject][1])) { DestroyDynamicObject(GymInfo[gymid][gyobject][1]); }

			GymInfo[gymid][gyobject][0] = CreateDynamicObject(2629, GymInfo[gymid][gypos][0] + 0.04800, GymInfo[gymid][gypos][1] + 0.14400, GymInfo[gymid][gypos][2] - 0.06600,   0.00000, 0.00000, -1.22000);
			GymInfo[gymid][gyobject][1] = CreateDynamicObject(2913, GymInfo[gymid][gypos][3] - 0.38400, GymInfo[gymid][gypos][4] + 0.69420, GymInfo[gymid][gypos][5] + 0.91800,   0.00000, 90.00000, -1.22000);

		
			GymInfo[gymid][gytext] = CreateDynamic3DTextLabel("Bam'{b84d4d}Y{b4b4b4}' de thao tac", COLOR_BASIC,  GymInfo[gymid][gypos][0] + 0.0255, GymInfo[gymid][gypos][1] - 0.8833, GymInfo[gymid][gypos][2] - 0.2688, 15);
		}
		case 3:
		{

			if(IsValidDynamicObject(GymInfo[gymid][gyobject][0])) { DestroyDynamicObject(GymInfo[gymid][gyobject][0]); }
			if(IsValidDynamicObject(GymInfo[gymid][gyobject][1])) { DestroyDynamicObject(GymInfo[gymid][gyobject][1]); }

			GymInfo[gymid][gyobject][0] = CreateDynamicObject(2630, GymInfo[gymid][gypos][0] - 0.05555, GymInfo[gymid][gypos][1] + 0.16666, GymInfo[gymid][gypos][2] + 0.00000,   0.00000, 0.00000, -95.00000);

		
			GymInfo[gymid][gytext] = CreateDynamic3DTextLabel("Bam'{b84d4d}Y{b4b4b4}' de thao tac", COLOR_BASIC,  GymInfo[gymid][gypos][0] + 0.5236, GymInfo[gymid][gypos][1] + 0.2316, GymInfo[gymid][gypos][2] - 0.2688, 15);
		}
		case 4:
		{

			if(IsValidDynamicObject(GymInfo[gymid][gyobject][0])) { DestroyDynamicObject(GymInfo[gymid][gyobject][0]); }
			if(IsValidDynamicObject(GymInfo[gymid][gyobject][1])) { DestroyDynamicObject(GymInfo[gymid][gyobject][1]); }

			GymInfo[gymid][gyobject][0] = CreateDynamicObject(2627, GymInfo[gymid][gypos][0] + 0.00000, GymInfo[gymid][gypos][1] + 0.00000, GymInfo[gymid][gypos][2] + 0.00000,   0.00000, 0.00000, 0.00000);

		
			GymInfo[gymid][gytext] = CreateDynamic3DTextLabel("Bam'{b84d4d}Y{b4b4b4}' de thao tac", COLOR_BASIC,  GymInfo[gymid][gypos][0] + 0.0475, GymInfo[gymid][gypos][1] - 1.1576, GymInfo[gymid][gypos][2] - 0.2688, 15);
		}
	}
}
stock DestroyGym(gymid)
{
	if(IsValidDynamicObject(GymInfo[gymid][gyobject][0])) { DestroyDynamicObject(GymInfo[gymid][gyobject][0]); }
	if(IsValidDynamicObject(GymInfo[gymid][gyobject][1])) { DestroyDynamicObject(GymInfo[gymid][gyobject][1]); }

	DestroyDynamic3DTextLabel(GymInfo[gymid][gytext]);
	GymInfo[gymid][gyplayerid] = INVALID_PLAYER_ID;
	GymInfo[gymid][gytype] = 0;
	GymInfo[gymid][gyused] = 0;
}

forward SettingGymType(playerid, gymid, type);
public SettingGymType(playerid, gymid, type)
{
	switch(type)
	{
		case 1:
		{
			SetPlayerAttachedObject(playerid,1, 3072, 5);//left hand
			SetPlayerAttachedObject(playerid,2, 3071, 6);//right hand
			DestroyDynamicObject(GymInfo[gymid][gyobject][0]);
			DestroyDynamicObject(GymInfo[gymid][gyobject][1]);
		}
		case 2:
		{
			DestroyDynamicObject(GymInfo[gymid][gyobject][1]);
			DestroyDynamic3DTextLabel(GymInfo[gymid][gytext]);
			SetPlayerAttachedObject(playerid, 0, 2913, 6, 0.029000, 0.011999, -0.098000, 1.800000, -0.899999, 0.000000, 1.000000, 1.000000, 1.000000, 0, 0);
		}
		case 3:
		{
			ApplyAnimation(playerid, "GYMNASIUM", "bike_start", 1, 1, 0, 0, 1, 0, 1);
			GymStack[playerid] = 0;
		}
		case 4:
		{
			ApplyAnimation(playerid, "GYMNASIUM", "gym_tread_walk", 1, 1, 0, 0, 1, 0, 1);
			GymStack[playerid] = 0;
		}
	}
}

forward StopGym(playerid, gymid, step);
public StopGym(playerid, gymid, step)
{
	switch(step)
	{
		case 1:
		{
			GettingGymObject(gymid, GymInfo[gymid][gytype]);
			RemovePlayerAttachedObject(playerid,1);
	    	RemovePlayerAttachedObject(playerid,2);
	    	GymInfo[gymid][gyplayerid] = INVALID_PLAYER_ID;
	    	SetTimerEx("EnablePlayerControl", 2000, false, "i", playerid);
		}
		case 2:
		{
			GettingGymObject(gymid, GymInfo[gymid][gytype]);
			RemovePlayerAttachedObject(playerid,0);
			GymInfo[gymid][gyplayerid] = INVALID_PLAYER_ID;
			SetTimerEx("EnablePlayerControl", 5000, false, "i", playerid);
		}
		case 3..4:
		{
			GettingGymObject(gymid, GymInfo[gymid][gytype]);
			GymInfo[gymid][gyplayerid] = INVALID_PLAYER_ID;
			SetTimerEx("EnablePlayerControl", 500, false, "i", playerid);
		}
	}
}

forward StopGymAnimation(playerid, step);
public StopGymAnimation(playerid, step)
{
	switch(step)
	{
		case 1:
		{
		
			ApplyAnimation(playerid, "freeweights", "gym_free_down", 1, 0, 0, 0, 1, 0, 1);
		}
		case 2:
		{
		
			ApplyAnimation(playerid, "benchpress", "gym_bp_down", 1, 0, 0, 0, 1, 0, 1);
		}
	}
	SetTimerEx("ResetGymVariable", 1000, false, "i",playerid);
}


forward ResetGymVariable(playerid);
public ResetGymVariable(playerid)
{
	SetPVarInt(playerid, "GymStep",1);
	ShowNotifyTextMain(playerid,"Tiep tuc tap luyen bang cach bam '~r~N~w~' dung tap luyen bang cach bam '~r~Y~w~'",6);
    GiveGymTask(playerid);
	new str[20];
	format(str, sizeof str, "Tap_luyen_the_luc:_%d%", PlayerFitness[playerid][GymTask]);
	ShowProgress(playerid,str,PlayerFitness[playerid][GymTask] ,10) ;
	SetPlayerHunger(playerid,0,-2);
	SetPlayerHunger(playerid,1,-3);
	SetPlayerHunger(playerid,2,-7);
	if(GymInfo[GetPVarInt(playerid, "GymID")][gytype] == 3)
	{
	    ShowNotifyTextMain(playerid,"Tiep tuc tap luyen bang cach bam '~r~N~w~' dung tap luyen bang cach bam '~r~Y~w~'",6);
		GymStack[playerid] = 16;
		ApplyAnimation(playerid, "GYMNASIUM", "gym_bike_slow", 1, 1, 0, 0, 1, 0, 1);
	}
	else if(GymInfo[GetPVarInt(playerid, "GymID")][gytype] == 4)
	{
	    ShowNotifyTextMain(playerid,"Tiep tuc tap luyen bang cach bam '~r~N~w~' dung tap luyen bang cach bam '~r~Y~w~'",6);
		ApplyAnimation(playerid, "GYMNASIUM", "gym_tread_geton", 4.1, 0, 0, 0, 1, 0, 1);
		SetTimerEx("SettingGymType", 2000, false, "iii", playerid, GetPVarInt(playerid,"GymID"), GymInfo[GetPVarInt(playerid,"GymID")][gytype]);
	}
}

forward EnablePlayerControl(playerid);
public EnablePlayerControl(playerid)
{
	TogglePlayerControllable(playerid, 1);
	DeletePVar(playerid, "GymStep");
	DeletePVar(playerid, "GymID");
}

stock GetGymNearest(playerid)
{
	for(new i = 0; i < 5000; i++)
	{
		if(IsPlayerInRangeOfPoint(playerid, 3, GymInfo[i][gypos][0], GymInfo[i][gypos][1], GymInfo[i][gypos][2]))
		{
			return i;
		}
	}
	return -1;
}
stock LoadGyms()
{
	
	for( new i = 0 ; i < 100; i++) {
		GymInfo[i][gyplayerid] = INVALID_PLAYER_ID;
	}
	print("[Dynamic Job] Tien hanh tai Dynamic Gym.");
    mysql_function_query(MainPipeline, "SELECT * FROM `gym`", true, "OnLoadGym", "");
}
forward OnLoadGym();
public OnLoadGym()
{
	new i, rows, fields, tmp[128];
	cache_get_data(rows, fields, MainPipeline);

	while(i < rows)
	{
		cache_get_field_content(i, "Type", tmp, MainPipeline); GymInfo[i][gytype] = strval(tmp);
		cache_get_field_content(i, "Used", tmp, MainPipeline); GymInfo[i][gyused] = strval(tmp);

		cache_get_field_content(i, "PosX", tmp, MainPipeline); GymInfo[i][gypos][0] = floatstr(tmp);
		cache_get_field_content(i, "PosY", tmp, MainPipeline); GymInfo[i][gypos][1] = floatstr(tmp);
		cache_get_field_content(i, "PosZ", tmp, MainPipeline); GymInfo[i][gypos][2] = floatstr(tmp);

		cache_get_field_content(i, "2PosX", tmp, MainPipeline); GymInfo[i][gypos][3] = floatstr(tmp);
		cache_get_field_content(i, "2PosY", tmp, MainPipeline); GymInfo[i][gypos][4] = floatstr(tmp);
		cache_get_field_content(i, "2PosZ", tmp, MainPipeline); GymInfo[i][gypos][5] = floatstr(tmp);

		if(GymInfo[i][gyused] == 1)
		{
			GettingGymObject(i, GymInfo[i][gytype]);
			GymInfo[i][gyplayerid] = INVALID_PLAYER_ID;
		}

		i++;
	}
	if(i > 0) printf("[Dynamic Gym] %d may tap gym da duoc tai thanh cong.", i);
	else printf("[Dynamic Gym] Khong the tai may tap gym.");
	return 1;
}

stock SaveGym(gymid)
{
	new string[512];
    printf("Luu thong tin may tap gym ID: %d", gymid);
	format(string, sizeof(string), "UPDATE `gym` SET \
	    `Type`=%d,\
	    `Used`=%d,\
		`PosX`=%f, \
		`PosY` =%f, \
		`PosZ`=%f, \
		`2PosX`=%f, \
		`2PosY` =%f, \
		`2PosZ`=%f WHERE `ID`=%d",
		GymInfo[gymid][gytype],
		GymInfo[gymid][gyused],
		GymInfo[gymid][gypos][0],
		GymInfo[gymid][gypos][1],
		GymInfo[gymid][gypos][2],
		GymInfo[gymid][gypos][3],
		GymInfo[gymid][gypos][4],
		GymInfo[gymid][gypos][5],
  		gymid
	); // Array starts from zero, MySQL starts at 1 (this is why we are adding one).

	mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);
}


CMD:gymedit(playerid,params[])
{
    new choice[32], gymid, Amount;
    if(PlayerInfo[playerid][pAdmin] >= 1338)
    {
		if(sscanf(params, "s[32]ii", choice, gymid, Amount))
		{
			SendClientMessage(playerid, COLOR_BASIC, "SU DUNG: /gymedit [tuy chon] [gymid] [amount]");
			SendClientMessage(playerid, COLOR_BASIC, "OPTION : khoitao, xoa, loaimay, skin.");
			SendClientMessage(playerid, COLOR_BASIC, "OPTION: 1 = DumpBells | 2 = Bench | 3 = Bike | 4 = Tread.");
			return 1;
		}
		if(gymid < 1 && gymid >= 1000)
		{
		
			SendErrorMessage(playerid,"ID phai tu 1-1000.");
			return 1;
		}
		if(Amount < 1 || Amount > 5)
		{
			SendErrorMessage(playerid,"Lua chon tu 1 > 4.");
			return 1;
		}
		if(strcmp(choice, "khoitao", true) == 0)
		{
			if(GymInfo[gymid][gyused] == 0)
			{
				new Float:Pos[3];
				GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);

				GymInfo[gymid][gypos][0] = Pos[0];
				GymInfo[gymid][gypos][1] = Pos[1];
				GymInfo[gymid][gypos][2] = Pos[2] - 0.9688;
				GymInfo[gymid][gypos][3] = Pos[0];
				GymInfo[gymid][gypos][4] = Pos[1];
				GymInfo[gymid][gypos][5] = Pos[2] - 0.9688;

				GymInfo[gymid][gyplayerid] = INVALID_PLAYER_ID;
				GymInfo[gymid][gytype] = Amount;
				GymInfo[gymid][gyused] = 1;

				GettingGymObject(gymid, Amount);
				SendClientMessageEx(playerid, COLOR_BASIC, "[GYM SYSTEM] Da khoi tao thanh cong may tap Gym ID .");
				SaveGym(gymid);
			}
			else return SendClientMessage(playerid, COLOR_BASIC, "[GYM SYSTEM] ID Gym nay da duoc khoi tao, can phai xoa no truoc khi khoi tao tiep.");
		}
		else if(strcmp(choice, "loaimay", true) == 0)
		{
			if(GymInfo[gymid][gyused] == 1)
			{
				GymInfo[gymid][gytype] = Amount;
				GettingGymObject(gymid, Amount);
				SaveGym(gymid);
				SendClientMessage(playerid, COLOR_BASIC, "[GYM SYSTEM] Da chinh sua loai may tap Gym.");
				return 1;
			}
			else return SendClientMessage(playerid, COLOR_BASIC, "[GYM SYSTEM] ID Gym nay chua duoc khoi tao, khong the chinh loai may.");
		}
		else if(strcmp(choice, "xoa", true) == 0)
		{
			if(GymInfo[gymid][gyused] == 1)
			{
				GymInfo[gymid][gypos][0] = 5000.00000;
				GymInfo[gymid][gypos][1] = 5000.00000;
				GymInfo[gymid][gypos][2] = 5000.00000;
				GymInfo[gymid][gypos][3] = 5000.00000;
				GymInfo[gymid][gypos][4] = 5000.00000;
				GymInfo[gymid][gypos][5] = 5000.00000;

				GymInfo[gymid][gyused] = 0;
				DestroyGym(gymid);
				SaveGym(gymid);
				SendClientMessage(playerid, COLOR_BASIC, "[GYM SYSTEM] Da xoa may tap Gym.");
			}
			else return SendClientMessage(playerid, COLOR_BASIC, "[GYM SYSTEM] ID Gym nay chua duoc khoi tao, khong the xoa bo.");
		}
		else
		{
			SendClientMessage(playerid, COLOR_BASIC, "[GYM SYSTEM] Sai lua chon.");
		}
	}
	else return SendClientMessageEx(playerid, COLOR_BASIC, "[GYM SYSTEM] Ban khong co du quyen de thuc hien cau lenh nay.");
	return 1;
}