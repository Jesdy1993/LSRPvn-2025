this::OneMinuteTimer()
{
	//=============================================================================
	new tmp_hour;

	gettime(tmp_hour);
	
	if (tmp_hour != server_hour)
	{
	    new string[31];

	    format(string, sizeof(string), "MAY CHU: Bay gio la %i:00.", tmp_hour);
		SCMALL(COLOR_WHITE, string);
		
    	server_hour = tmp_hour;
    	SetWorldTime(server_hour);

		for(new i = 0; i < MAX_BIZ; i++) 
		{
			if (!BizInfo[i][bizID] || BizInfo[i][bizType] != BIZ_GAS_STATION) continue;
			if (!BizInfo[i][bizOwnerID] && BizInfo[i][bizProduct] > 10) BizInfo[i][bizProduct]--;
		}

    	if (server_hour == 5)
		{
			SCMALL(COLOR_LIGHTRED, "Khoi dong lai may chu tu dong bat dau sau 60 giay.");
			restart_time = 60;
		}
	}
	//==========================================================================
	for(new i = 0; i < MAX_CHOPSHOP; i++)
	{
		if (!chopshop_data[i][chopshop_exist]) continue;
		
		if (chopshop_data[i][chopshop_timer] >= 60) 	GetRandomModel(i);
		else 										chopshop_data[i][chopshop_timer]++;
	}

	//==========================================================================
	foreach(new i : Player)
	{
	    if (!IsPlayerLogged(i)) 					continue;

        PlayerInfo[i][pPayDayTime]++;
        if (PlayerInfo[i][pPayDayTime] >= 60) 	PayDay(i);
		
		SetPVarInt(i, #pDelay, 0);
	}
	//==========================================================================
	for(new i = 0; i < MAX_CORPS; i++)
	{
		if (!CorpInfo[i][cUsed]) continue;

		if ((CorpInfo[i][cTime] - gettime()) > 60*30) 	RemoveCorpse(i);
	
		if ((CorpInfo[i][cTime] - gettime()) > 60*1 && CorpInfo[i][cVeh] > 0 && GetVehicleModel(CorpInfo[i][cVeh]) > 0) 
		{
			new Float: x, Float: y, Float: z;
			GetBootPos(CorpInfo[i][cVeh], x, y, z);
			
			CorpInfo[i][cText] = CreateDynamic3DTextLabel("*** Mui hang hac boc ra tu thung xe ***", 0xC2A2DAFF, x, y, z, 20.0, INVALID_PLAYER_ID, CorpInfo[i][cVeh]);
		}
	}
	//==========================================================================
	
	for(new i = 0; i < MAX_PLANTS; i++)
	{
		if (CropsInfo[i][pPlanted] == 0)						continue;
		if ((CropsInfo[i][pGrowTime] - gettime()) < -7200) 	DestroyCrop(i);

		new drugname[16];

		switch(CropsInfo[i][pType])
		{
			case 1: format(drugname, sizeof(drugname), "can sa");
			case 2: format(drugname, sizeof(drugname), "cocaine");
			case 3: format(drugname, sizeof(drugname), "poppy");
		}
		
		if (CropsInfo[i][pGrowTime] - gettime() > CropsInfo[i][pStartTime])
		{
			static const str_size[] = "Cay %s\n{FF6347}Hai";
			new mes[sizeof(str_size) + 16];

			format(mes, sizeof(mes), str_size, drugname);
			UpdateDynamic3DTextLabelText(CropsInfo[i][pLabel], -1, mes);
		}
		else
		{
			static const str_size[] = "Cay %s\n{FF6347}%.0f%%";
			new mes[sizeof(str_size) + 16];

			new time = CropsInfo[i][pGrowTime] - gettime();

			format(mes, sizeof(mes), str_size, drugname, 100.0 - (float(time) / float(CropsInfo[i][pStartTime])) * 100.0);
			UpdateDynamic3DTextLabelText(CropsInfo[i][pLabel], -1, mes);
		}
	}
	
    //==========================================================================
    for(new i; i != MAX_FOOD_DROPS; i++)
	{
	    if (FoodDrop[i][foodDropped] == 0) continue;
	        
		if (FoodDrop[i][foodTime]-- == 0)
		{
        	FoodDrop[i][foodModel] = 0;
        	FoodDrop[i][foodDropped] = 0;

        	if (IsValidDynamicObject(FoodDrop[i][foodObject])) DestroyDynamicObject(FoodDrop[i][foodObject]);
		}
	}
	
	//==========================================================================
	ShellsTimer();
	//==========================================================================
	CheckBillBoard();
	//==========================================================================
	
	SetTimer("OneMinuteTimer", 60000, false);
	return 1;
}

this::OneSecondTimer()
{
	PlayerTimer();
	OtherTimer();
	MeterCheck();
	return 1;
}

forward TalkTimer(playerid);
public TalkTimer(playerid)
{
	return ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0);
}

Timer_OnGameModeInit()
{
	SetTimer("OneSecondTimer", 1000, true);
	SetTimer("OneMinuteTimer", 60000, false);
	SetTimer("PlayerSaver", 300000, false);
    return 1;
}

OtherTimer()
{
	if (time_truck-- == 0)
	{
	    time_truck = 3600;
	    CheckIndustries();
	}
	
    if (ship_depart <= gettime() && ship_docked == 1)
	{
	    new mes[128];
	    for(new i; i != MAX_TRUCK_CARGO; i++)
	    {
	        if (TruckCargo[i][tOn] == 0 || TruckCargo[i][tType] != 2) continue;

            TruckCargo[i][tStorage] = 0;
            format(mes, sizeof(mes), "[{FFFF00}%s{FFFFFF}]\nLuu tru: %i / %i\nGia: $%i /cai.", truckcargo_product[TruckCargo[i][tProductID]], TruckCargo[i][tStorage], TruckCargo[i][tStorageSize], TruckCargo[i][tPrice]);
        	UpdateDynamic3DTextLabelText(TruckCargo[i][tLabel], 0xFFFFFFFF, mes);
        	Streamer_SetIntData(STREAMER_TYPE_3D_TEXT_LABEL, TruckCargo[i][tLabel], E_STREAMER_INTERIOR_ID, 1);
        	Streamer_SetIntData(STREAMER_TYPE_PICKUP, TruckCargo[i][tPickup], E_STREAMER_INTERIOR_ID, 1);
	    }
		mysql_tquery(dbHandle, "UPDATE `truck_cargo` SET `storage`=0 WHERE `type`=2");

	    ship_docked = 2;
	    ship_depart = ship_next + 2400;

	    new Float: ox, Float: oy, Float: oz;
        
		for(new i; i != 11; i++)
	    {
	        if (i < 8)	Streamer_SetIntData(STREAMER_TYPE_OBJECT, obj_lamp[i], E_STREAMER_MODEL_ID, 19124);
	        if (i < 4)
	        {
	            GetDynamicObjectPos(obj_gate[i], ox, oy, oz);
	        	MoveDynamicObject(obj_gate[i], ox - 10.0, oy, oz, 1.5);
	        }

			GetDynamicObjectPos(obj_ship[i], ox, oy, oz);
	        MoveDynamicObject(obj_ship[i], ox, oy - 600.0, oz, 3.0);
		}
	}

	if (ship_next <= gettime() && ship_docked == 0)
	{
	    ship_docked = 3;
        ship_next = ship_depart + 340;

	    new Float: ox, Float: oy, Float: oz;

		for(new i; i != 11; i++)
	    {
			GetDynamicObjectPos(obj_ship[i], ox, oy, oz);
	        MoveDynamicObject(obj_ship[i], ox, oy + 600.0, oz, 3.0);
		}
	}

    if (restart_time)
	{
	    new mes[95];

	    format(mes, sizeof(mes), "~w~CHU Y!~h~~r~ BAN CAN THOAT~w~, DE TRANH MOT DU LIEU~n~KHOI DONG LAI : ~y~%02i", restart_time-1);
        GameTextForAll(mes, 1100, 4);

        restart_time--;
		if (restart_time == 3) SaveAllPlayers();
        else if (restart_time == 1)
		{
		    new year, month, day;

		    getdate(year, month, day);
		    printf("[GMX] Khoi dong lai may chu theo lich trinh. thoi gian: %02i/%02i/%i", day, month, year);
			SendRconCommand("gmx");
		}
	}

	for(new i = 0; i < MAX_CCTV; i++)
	{
		if (CCTVInfo[i][tvObjectOn])
		{
			if (CCTVInfo[i][tvSignal])
			{
				if (CCTVInfo[i][tvSignalTime] > 0)
				{
					CCTVInfo[i][tvSignalTime]--; 
				}
				else
				{
					CCTVInfo[i][tvSignalTime] = 
					CCTVInfo[i][tvSignal] = 0;
				}	
			}	
		}
	}

	for(new i; i < MAX_HOUSES; i++)
	{
		if (HouseInfo[i][hAlarmTime])
	    {
	        HouseInfo[i][hAlarmTime]--;
	        if (HouseInfo[i][hAlarmTime] == 0) HouseAlarm(i, false);
		}
	}
	/*for (new i = 1, j = GetVehiclePoolSize(); i <= j; i ++)
	{
        new Float:health;

		AntiCheatGetVehicleHealth(i, health);

		if (health < 330.0 && IsABicycle(i) == 0)
		{
			if (VehicleInfo[i][carEngineOn])
			{
				VehicleEngine(i, false);
			}											
			if (VehicleInfo[i][carOwnerID] != 0 && VehicleInfo[i][carDeath] != 1)
			{
				ResetVehicleStuff(i);
			}	
	    
		    SetVehicleHealth(i, 330.0);
		}
		
		if (VehicleInfo[i][carTerminate])
		{
		    VehicleInfo[i][carTerminate]--;
			if (VehicleInfo[i][carTerminate] == 1 && VehicleInfo[i][carRent] != 0)
	        {
				VehicleInfo[i][carRent] = 0;
				RespawnVehicle(i);
			}
		}
		
        if (VehicleInfo[i][carAlarmTime])
	    {
			new engine,lights,alarm,doors,bonnet,boot,objective;
			GetVehicleParamsEx(i, engine, lights, alarm, doors, bonnet, boot, objective);
			if (VehicleInfo[i][carAlarmTime] == 0) SetVehicleParamsEx(i, engine, lights, VEHICLE_PARAMS_OFF, doors, bonnet, boot, objective);

	        VehicleInfo[i][carAlarmTime]--;
			if (VehicleInfo[i][carAlarmTime] % 2 == 1) SetVehicleParamsEx(i, engine, VEHICLE_PARAMS_OFF, alarm, doors, bonnet, boot, objective);
			else 									  SetVehicleParamsEx(i, engine, VEHICLE_PARAMS_ON, alarm, doors, bonnet, boot, objective);
		}

	    if (VehicleInfo[i][carObjectiveTime])
	    {
	        VehicleInfo[i][carObjectiveTime]--;
	        if (VehicleInfo[i][carObjectiveTime] == 0)
	        {
	            new engine,lights,alarm,doors,bonnet,boot,objective;

				GetVehicleParamsEx(i, engine, lights, alarm, doors, bonnet, boot, objective);
				SetVehicleParamsEx(i, engine, lights, alarm, doors, bonnet, boot, VEHICLE_PARAMS_OFF);
			}
		}

		if (VehicleInfo[i][carOwnerID] == 0 || IsABicycle(i) || VehicleInfo[i][carEngineOn] == 0) continue;

		new iEngine, iLights, iAlarm,
			iDoors, iBonnet, iBoot,
			iObjective
		;	
		GetVehicleParamsEx(i, iEngine, iLights, iAlarm, iDoors, iBonnet, iBoot, iObjective);
		
		VehicleInfo[i][carFuel] -= (float(GetVehicleSpeed(i))+float(random(5))+1.0)/3600 * GetVehicleFuelUsage(GetVehicleModel(i)) * 0.05;

		if (VehicleInfo[i][carFuel] < 0.0)
		{
			VehicleInfo[i][carFuel] = 0.0;
			VehicleEngine(i, false);
			if (IsPlayerLogged(VehicleInfo[i][carDriver]) && IsPlayerInVehicle(VehicleInfo[i][carDriver], i))
			{
				InfoMSG(VehicleInfo[i][carDriver],  "~y~The vehicle is out of fuel!", 10);
			}
		}

		//SAMALL("%f", VehicleInfo[i][carFuel]);

		if (GetVehicleSpeed(i)) VehicleInfo[i][carEngine] -= 0.004/10;
		if (VehicleInfo[i][carRadioOn])	VehicleInfo[i][carBattery] -= 0.02/10;
		if (iLights == 1)	VehicleInfo[i][carBattery] -= 0.012/10;

		new Float:vehhp;
		GetVehicleHealth(i, vehhp);

		if (vehhp < 400 && GetVehicleSpeed(i) && VehicleInfo[i][carEngine] < 35)
		{
			VehicleInfo[i][carEngine] -= 0.02/10;
			VehicleInfo[i][carBattery] -= 0.012/10;
		}

		if (VehicleInfo[i][carBattery] < 0.0)
		{
			VehicleInfo[i][carBattery] = 0.0;
			if (VehicleInfo[i][carEngineOn]) VehicleEngine(i, false);
		}
		
		if (VehicleInfo[i][carEngine] < 0.0)
		{
			VehicleInfo[i][carEngine] = 0.0;
			if (VehicleInfo[i][carEngineOn]) VehicleEngine(i, false);
		}
	}*/

	for (new i = 1, j = GetVehiclePoolSize(); i <= j; i ++)
	{
        new Float:health;

		AntiCheatGetVehicleHealth(i, health);

		if (health < 330.0 && IsABicycle(i) == 0)
		{
			if (VehicleInfo[i][carEngineOn])											VehicleEngine(i, false);
			if (VehicleInfo[i][carOwnerID] != 0 && VehicleInfo[i][carDeath] != 1)	ResetVehicleStuff(i);
	    
		    SetVehicleHealth(i, 330.0);
		}
		
		if (VehicleInfo[i][carTerminate])
		{
		    VehicleInfo[i][carTerminate]--;
			if (VehicleInfo[i][carTerminate] == 1 && VehicleInfo[i][carRent] != 0)
	        {
				VehicleInfo[i][carRent] = 0;
				RespawnVehicle(i);
			}
		}
		
        if (VehicleInfo[i][carAlarmTime])
	    {
			new engine,lights,alarm,doors,bonnet,boot,objective;
			GetVehicleParamsEx(i, engine, lights, alarm, doors, bonnet, boot, objective);
			if (VehicleInfo[i][carAlarmTime] == 0) SetVehicleParamsEx(i, engine, lights, VEHICLE_PARAMS_OFF, doors, bonnet, boot, objective);

	        VehicleInfo[i][carAlarmTime]--;
			if (VehicleInfo[i][carAlarmTime] % 2 == 1) SetVehicleParamsEx(i, engine, VEHICLE_PARAMS_OFF, alarm, doors, bonnet, boot, objective);
			else 									  SetVehicleParamsEx(i, engine, VEHICLE_PARAMS_ON, alarm, doors, bonnet, boot, objective);
		}

	    if (VehicleInfo[i][carObjectiveTime])
	    {
	        VehicleInfo[i][carObjectiveTime]--;
	        if (VehicleInfo[i][carObjectiveTime] == 0)
	        {
	            new engine,lights,alarm,doors,bonnet,boot,objective;

				GetVehicleParamsEx(i, engine, lights, alarm, doors, bonnet, boot, objective);
				SetVehicleParamsEx(i, engine, lights, alarm, doors, bonnet, boot, VEHICLE_PARAMS_OFF);
			}
		}

		if (VehicleInfo[i][carOwnerID] == 0 || IsABicycle(i) || VehicleInfo[i][carEngineOn] == 0) continue;

		new iEngine, iLights, iAlarm,
			iDoors, iBonnet, iBoot,
			iObjective
		;	
		GetVehicleParamsEx(i, iEngine, iLights, iAlarm, iDoors, iBonnet, iBoot, iObjective);
		
		
		//new Float:fl = (float(GetVehicleSpeed(i))+float(random(5))+1.0)/3600 * GetVehicleFuelUsage(GetVehicleModel(i)) * 0.05;
		//SAMALL("SPEED: %d, ������: %f, -%f", GetVehicleSpeed(i), GetVehicleFuelUsage(GetVehicleModel(i)), fl);

		VehicleInfo[i][carFuel] -= (float(GetVehicleSpeed(i))+float(random(5))+1.0)/3600 * GetVehicleFuelUsage(GetVehicleModel(i)) * 0.05;

		if (VehicleInfo[i][carFuel] < 0.0)
		{
			VehicleInfo[i][carFuel] = 0.0;
			VehicleEngine(i, false);
			if (IsPlayerLogged(VehicleInfo[i][carDriver]) && IsPlayerInVehicle(VehicleInfo[i][carDriver], i))
				GameTextForPlayer(VehicleInfo[i][carDriver], "~y~Phuong tien da het nhien lieu!", 5000, 3);
		}

		//SAMALL("%f", VehicleInfo[i][carFuel]);

		if (GetVehicleSpeed(i)) VehicleInfo[i][carEngine] -= 0.004/10;
		if (VehicleInfo[i][carRadioOn])	VehicleInfo[i][carBattery] -= 0.02/10;
		if (iLights == 1)	VehicleInfo[i][carBattery] -= 0.012/10;

		new Float:vehhp;
		GetVehicleHealth(i, vehhp);

		if (vehhp < 400 && GetVehicleSpeed(i) && VehicleInfo[i][carEngine] < 35)
		{
			VehicleInfo[i][carEngine] -= 0.02/10;
			VehicleInfo[i][carBattery] -= 0.012/10;
		}

		if (VehicleInfo[i][carBattery] < 0.0)
		{
			VehicleInfo[i][carBattery] = 0.0;
			if (VehicleInfo[i][carEngineOn]) VehicleEngine(i, false);
		}
		
		if (VehicleInfo[i][carEngine] < 0.0)
		{
			VehicleInfo[i][carEngine] = 0.0;
			if (VehicleInfo[i][carEngineOn]) VehicleEngine(i, false);
		}
	}

	for(new i = 0; i != MAX_FIRES; i++)
	{
	    if (FiresInfo[i][fireOn] == 0) continue;
	    if (FiresInfo[i][fireTimer]-- < 1) 					DeleteFire(i);
		if (FiresInfo[i][fireTimer] == CROSSFIRE_TIMER*60) 	CrossFire(i);
	}

	for(new i = 0; i != MAX_TOLLS; i++)
	{
		if (aTolls[i][E_tOpenTime] < 1) continue;

		aTolls[i][E_tOpenTime]--;

		if (aTolls[i][E_tOpenTime] == 1)	Toll_CloseToll(i);
	}


	for(new i = 0; i != MAX_CALLS_AND_ARREST; i++)
	{
	    if (CallInfo[i][callExists] != 0 && CallInfo[i][callDelete] < gettime())
		{
        	CallInfo[i][callExists] =
			CallInfo[i][callAccept] =
        	CallInfo[i][callType] = 0;
			CallInfo[i][callAcceptBy] = EOS;
		}

		if (ArrestInfo[i][arrestExists] != 0 && ArrestInfo[i][arrestDelete] < gettime())
		{
			ArrestInfo[i][arrestExists] = 
			ArrestInfo[i][arrestDelete] = 0;
		}
	}


	for(new i = 1; i != MAX_FACTIONS; i++)
	{
	    if (Factions[i][fON] == 0 || 
			(Factions[i][fType] != FACTION_MAFIA && Factions[i][fType] != FACTION_GANG) ||
			Factions[i][fPointTime] > gettime()
		) continue;
		
		if (Factions[i][fType] == FACTION_MAFIA)	Factions[i][fPoint] = 50;
        else										Factions[i][fPoint] = 30;
            
    	Factions[i][fPointTime] = 604800 + gettime();
		SQL_SetInteger("factions", "point", Factions[i][fPoint], Factions[i][fID]);
		SQL_SetInteger("factions", "point_time", Factions[i][fPointTime], Factions[i][fID]);
	}

	for(new i = 0; i < MAX_CORPS; i++)
	{
		if (!CorpInfo[i][cUsed]) continue;
		if (!CorpInfo[i][cVeh])	SetActorPos(CorpInfo[i][cBody], CorpInfo[i][cX], CorpInfo[i][cY], CorpInfo[i][cZ]);
	}

	return 1;
} 