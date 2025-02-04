this::PlayerTimer()
{
    new string[164], cont;
	foreach(new i : Player)
	{
	    cont = Login_PlayerTimer(i);
		if (!cont) continue;

    	/*if (pTemp[i][pPayphone] && 0 == IsPlayerAtPayphone(i, pTemp[i][pPayphone]))
		{
			PayphoneInfo[pTemp[i][pPayphone]][phUsed] = INVALID_PLAYER_ID;
			pTemp[i][pPayphone] = -1;
        }*/
		Admin_PlayerTimer(i);
		Death_PlayerTimer(i);
		Graffity_PlayerTimer(i);
        House_PlayerTimer(i);
		CheckValidTextDraws(i);

		if (!IsPlayerAFK(i)) Fire_Check(i);
		new nametag[246];
		if(IsPlayerAFK(i))
		{
			format(nametag, sizeof(nametag), "{f53636}[P] {ffffff}%s [%i]", GetNameEx(i), i);
			if (IsAdminDuty(i))
			{
				format(nametag, sizeof(nametag), "{f53636}[P] {ffffff}%s", GetAccName(i));
			}
			if(maskOn{i})
			{
				format(nametag, sizeof(nametag), "{f53636}[P] {ffffff}%s", PlayerInfo[i][pMaskname]);
			}
		}
		
		else if(!IsPlayerAFK(i))
		{
			format(nametag, sizeof(nametag), "%s [%i]", GetNameEx(i), i);
			if (IsAdminDuty(i))
			{
				format(nametag, sizeof(nametag), "%s", GetAccName(i));
			}
			if(maskOn{i}) 
			{
				format(nametag, sizeof(nametag), "%s", PlayerInfo[i][pMaskname]);
			}
		}
		UpdateDynamic3DTextLabelText(CustomNametag[i], COLOR_WHITE, nametag);

		if (GetPVarInt(i, #LableText) > 0)
		{
			SetPVarInt(i, #LableText, GetPVarInt(i, #LableText)-1);
			
			if (GetPVarInt(i, #LableText) == 0)
			{
				TextDrawDestroy(LableDraw[i]);
				TextDrawDestroy(UsedDraw[i]);
				TextDrawDestroy(TDEditor_TD[i]);
				DeletePVar(i, #LableText);
			}
		}

		Drugs_PlayerTimer(i);

		//
        if (pTemp[i][pBoombox_house] != -1 && IsPlayerInsideHouse(i, pTemp[i][pBoombox_house], 50.0) == 0)
        {
            pTemp[i][pBoombox_house] = -1;
            StopAudioStreamForPlayer(i);
        }
        
        if (pTemp[i][pBoombox_biz] != -1 && IsPlayerBizInside(i, pTemp[i][pBoombox_biz], 50.0) == 0)
        {
            pTemp[i][pBoombox_biz] = -1;
            StopAudioStreamForPlayer(i);
        }

        if (GetPVarInt(i, #try_engine))
		{
		    if (HoldingKey(i, KEY_SPRINT) == 0)
		    {
		        SetPVarInt(i, #try_engine, GetPVarInt(i, #try_engine)-1);
		        if (GetPVarInt(i, #try_engine) == 0)
		        {
		        	DeletePVar(i, #try_engine);
					SendWarningMessage(i, "Xe cua ban khong the no may, dong co bi hu hong.");
				}
			}
		    else
		    {
		        PlaySound(i, 11200);
		        SetPVarInt(i, #try_engine, GetPVarInt(i, #try_engine)+1);
		        if (GetPVarInt(i, #try_engine) == 12)
		        {
		            DeletePVar(i, #try_engine);
		            VehicleEngine(GetPlayerVehicleID(i), true);
		            GameTextForPlayer(i, "~w~DONG CO ~g~BAT", 2500, 4);
		        }
		    }
		}

        if (pTemp[i][pFishTime])
		{
		    OnPlayAnim(i, "SWORD", "SWORD_IDLE", 4.1, 1, 0, 0, 1, 0);
		    pTemp[i][pFishTime]--;
		    if (pTemp[i][pFishTime] == 0)
		    {
		        StopPlayerAnims(i);
		        if (random(2) == 0)
				{
				    new randlb = randomEx(15, 30),
						rand = random(sizeof(fish_names));

					SM2(i, "Ban da cau duoc %s - Trong luong: %iLBs.", fish_names[rand], randlb);
					if (PlayerInfo[i][pFishCount] + randlb <= 1000)
						PlayerInfo[i][pFishCount] += randlb;
					else
					    PlayerInfo[i][pFishCount] = 1000;
				}
				else
					SM1(i, "Ban chua bat duoc gi. ");
		    }
		}

		Job_SecondTimer(i);

		if (pTemp[i][pTracePlayer] != INVALID_PLAYER_ID)	TracePlayer(i);

	
		for(new pp = 0; pp < MAX_PAYPHONES; pp++)
		{
			if (PayphoneInfo[pp][phState] == PAYPHONE_STATE_RINGING && PayphoneInfo[pp][phRing] < 59 && IsPlayerLogged(PayphoneInfo[pp][phCaller]))	
			{
				PayphoneInfo[pp][phRing]++;
				if (PayphoneInfo[pp][phRing] % 5 == 0) Update_Payphone(pp);
			}
			else if (PayphoneInfo[pp][phState] == PAYPHONE_STATE_RINGING)
			{
				PayphoneInfo[pp][phState] = PAYPHONE_STATE_NONE;
				PayphoneInfo[pp][phRing] = 0;
				
				Update_Payphone(pp);
				
				PayphoneInfo[pp][phUsed] = INVALID_PLAYER_ID;
				PayphoneInfo[pp][phCaller] = INVALID_PLAYER_ID;
				PayphoneInfo[pp][phState] = PAYPHONE_STATE_NONE;
				
				if (IsPlayerLogged(PayphoneInfo[pp][phCaller]))
				{
					SendPhoneMessage(PayphoneInfo[pp][phCaller], "Nguoi dang ky khong tra loi.");
					HangupCall(PayphoneInfo[pp][phCaller]);
				}
			}
		}

		if (pTemp[i][pPayphone] != -1)
		{
			if (0 == IsPlayerAtPayphone(i, pTemp[i][pPayphone]))
			{
				SendWarningMessage(i, "Ban da di qua xa so voi dien thoai tra tien.");
				cancelPayphone(i);
			}
        }
		
		if (IsPlayerPhoneCreated(i))	Update_Phone(i);

		if (pTemp[i][pCallStatus] == 2 && (pTemp[i][pCallLine] != INVALID_PLAYER_ID || pTemp[i][pEmergency]))
		{
			if (!GetPlayerNetwork(i) || PlayerInfo[i][pInjured] != 0)
			{
   				SendPhoneMessage(pTemp[i][pCallLine], "Ket noi voi nguoi dang ky da bi cat ...");
   				SendPhoneMessage(i, "Ket noi voi nguoi dang ky da bi cat ...");
		    	
				HangupCall(i);
				HangupCall(pTemp[i][pCallLine]);

				return 1;
			}
			if (Payphone_Nearest(i) == -1 && pTemp[i][pPayphone] != -1)
			{
				SendWarningMessage(i, "Ban da di qua xa so voi dien thoai tra tien.");
				
				SendPhoneMessage(pTemp[i][pCallLine], "Ket noi voi nguoi dang ky da bi cat ...");
   				SendPhoneMessage(i, "Ket noi voi nguoi dang ky da bi cat ...");

				HangupCall(i);
				HangupCall(pTemp[i][pCallLine]);

				return 1;
			}

		    pTemp[i][pCallTime]++;
			new mes[52];

            if (IsPlayerPhoneCreated(i)) {
				if (PhoneInfo[i][current_page] == PAGE_CALL) {
					format(mes, sizeof(mes), "%s~n~%s", pTemp[i][pCallName], ConvertSecond(pTemp[i][pCallTime]));
					PlayerTextDrawSetString(i, PhNote[1][i], mes);
				} else {
					format(mes, sizeof(mes), "%s", ConvertSecond(pTemp[i][pCallTime]));
					PlayerTextDrawSetString(i, CallBox[i], mes);
				}
			}
			if (pTemp[i][pPayphone] != -1)
			{
				format(mes, sizeof(mes), "%s", ConvertSecond(pTemp[i][pCallTime]));
				PlayerTextDrawSetString(i, PP_Btn[i][0], mes);
			}
		}

		if (GetPVarInt(i, #vehicle_info))
		{
		    SetPVarInt(i, #vehicle_info, GetPVarInt(i, #vehicle_info) - 1);
		    if (GetPVarInt(i, #vehicle_info) == 0)
		    {
        		TextDrawHideForPlayer(i, TD_vehicle_info[0]);
	    		TextDrawHideForPlayer(i, TD_vehicle_info[1]);
				PlayerTextDrawHide(i, TD_vehicle_name[i]);
				DeletePVar(i, #vehicle_info);
			}
		}

		if (pTemp[i][pFlashTime])
		{
		    pTemp[i][pFlashTime]--;
		    if (pTemp[i][pFlashTime] == 0)
		    {
		    	SetPlayerCurrentTimeAndWeather(i);
				StopPlayerAnims(i);
				UnFreezePlayer(i);
				SetPlayerDrunkLevel(i, 1999);
			}
		}

		if (pTemp[i][pFreezeTime])
		{
		    pTemp[i][pFreezeTime]--;
		    if (pTemp[i][pFreezeTime] == 0) UnFreezePlayer(i);
		}

		if (pTemp[i][pInjuredLegTime]) pTemp[i][pInjuredLegTime]--;

		if (pTemp[i][pTaserTime])
		{
		    if (!PlayerToPoint(1.5, i, PlayerInfo[i][pPosX], PlayerInfo[i][pPosY], PlayerInfo[i][pPosZ]))
		        SetPlayerPosEx(i, PlayerInfo[i][pPosX], PlayerInfo[i][pPosY], PlayerInfo[i][pPosZ]);

		    ApplyAnimation(i, "SWEET", "Sweet_injuredloop", 4.0, 1, 0, 0, 1, 0);

		    pTemp[i][pTaserTime]--;
		    if (0 == pTemp[i][pTaserTime]) SendSpecialMessage(i, "Ban khong con choang vang nua."), StopPlayerAnims(i);
		}

		if (pTemp[i][pRamType] != 0 && pTemp[i][pRamTime] > 1)
		{
		    if (pTemp[i][pRamType] == 1 
				&& ((pTemp[i][pRamHouse] != -1 && 0 == IsPlayerOutsideHouse(i, pTemp[i][pRamHouse], 1.5)) 
				|| (pTemp[i][pRamBiz] != -1 && 0 == IsPlayerBizOutside(i, pTemp[i][pRamBiz], 1.5))
				|| (pTemp[i][pRamGarage] != -1 && GetNearOutsideGarage(i, 5.0) != pTemp[i][pRamGarage])
				|| (pTemp[i][pRamVeh] != -1 && GetNearVehicle(i, 3.0) != pTemp[i][pRamVeh]))) {

		        SendErrorMessage(i, "Ban da di chuyen qua xa khoi cua.");
		        pTemp[i][pRamType] = 0;
            	pTemp[i][pRamTime] = 0;
            	StopPlayerAnims(i);
		    }
		    else
	    	{
            	pTemp[i][pRamTime]--;
				format(string, sizeof(string), "PHA ~r~KHOA~n~~w~CON ~g~%i ~w~GIAY", pTemp[i][pRamTime]);
				InfoMSG(i, string, 1);
			}
		}
		else if (pTemp[i][pRamType] == 1 && pTemp[i][pRamTime] == 1)
		{
		    pTemp[i][pRamType] = 0;
            pTemp[i][pRamTime] = 0;

            new location[MAX_ZONE_NAME];
			GetPlayer2DZone(i, location, MAX_ZONE_NAME);
			
			if (pTemp[i][pRamHouse] != -1 && IsPlayerOutsideHouse(i, pTemp[i][pRamHouse]))
            {
                new houseid = pTemp[i][pRamHouse];
                HouseInfo[houseid][hLocked] = 0;
				GameTextForPlayer(i, "~w~Cua ~g~da mo", 5000, 6);
				PlaySound(i, 1145);
				StopPlayerAnims(i);

				new query[256];
				format(query, sizeof(query), "%s [MYSQL: %i | IP: %s] da mo cua (/ram) nha [H_MYSQL: %i]",
				GetName(i), PlayerInfo[i][pID], q_GetPlayerIP(i), HouseInfo[houseid][hID]);
			    insert_log(query, RAM_LOG, 1, PlayerInfo[i][pAccID]);
            }
            else if (pTemp[i][pRamBiz] != -1 && IsPlayerBizOutside(i, pTemp[i][pRamBiz]))
            {
                new bizid = pTemp[i][pRamBiz];
            	BizInfo[bizid][bizLocked] = 0;
				GameTextForPlayer(i, "~w~Cua ~g~da mo", 5000, 6);
				PlaySound(i, 1145);
				StopPlayerAnims(i);

				new query[256];
				format(query, sizeof(query), "%s [MYSQL: %i | IP: %s] da mo cua (/ram) doanh nghiep [B_MYSQL: %i]",
				GetName(i), PlayerInfo[i][pID], q_GetPlayerIP(i), BizInfo[bizid][bizID]);
			    insert_log(query, RAM_LOG, 2, PlayerInfo[i][pAccID]);
            }
			else if (pTemp[i][pRamGarage] != -1 && GetNearOutsideGarage(i, 5.0) == pTemp[i][pRamGarage])
            {
                new garageid = pTemp[i][pRamGarage];
            	GarageInfo[garageid][garageLocked] = 0;
				GameTextForPlayer(i, "~w~Cua ~g~da mo", 5000, 6);
				PlaySound(i, 1145);
				StopPlayerAnims(i);

				new query[256];
				format(query, sizeof(query), "%s [MYSQL: %i | IP: %s] da mo cua (/ram) garage [B_MYSQL: %i]",
				GetName(i), PlayerInfo[i][pID], q_GetPlayerIP(i), GarageInfo[garageid][garageID]);
			    insert_log(query, RAM_LOG, 3, PlayerInfo[i][pAccID]);
            }
			else if (pTemp[i][pRamVeh] != -1 && GetNearVehicle(i, 2.0) == pTemp[i][pRamVeh])
            {
                ToggleVehicleLock(pTemp[i][pRamVeh], true);
				GameTextForPlayer(i, "~w~Cua ~g~da mo", 5000, 6);
				PlaySound(i, 1145);
				StopPlayerAnims(i);

				new query[256];
				format(query, sizeof(query), "%s [MYSQL: %i | IP: %s] da mo cua (/ram) phuong tien [B_MYSQL: %i]",
				GetName(i), PlayerInfo[i][pID], q_GetPlayerIP(i), VehicleInfo[pTemp[i][pRamVeh]][carID]);
			    insert_log(query, RAM_LOG, 3, PlayerInfo[i][pAccID]);
            }
		}
		else if (pTemp[i][pRamType] == 3 && pTemp[i][pRamTime] == 1)
		{
		    pTemp[i][pRamType] = 0;
            pTemp[i][pRamTime] = 0;

            new location[MAX_ZONE_NAME];
			GetPlayer2DZone(i, location, MAX_ZONE_NAME);
			if (pTemp[i][pRamHouse] != -1)
            {
                new houseid = pTemp[i][pRamHouse];
                CreateDynamicExplosion(HouseInfo[houseid][hPosX], HouseInfo[houseid][hPosY], HouseInfo[houseid][hPosZ], 12, 5.0, HouseInfo[houseid][hPosVW], HouseInfo[houseid][hPosInt]);
				if (IsValidDynamicObject(pTemp[i][pRamObj]))
				{
					DestroyDynamicObject(pTemp[i][pRamObj]);
					pTemp[i][pRamObj] = INVALID_OBJECT_ID;
				}
				HouseInfo[houseid][hLocked] = 0;
				HouseInfo[houseid][hDDoor] = 2;
				Save_House(houseid);
				UpdateHouseDoor(houseid);

				new query[128];
				format(query, sizeof(query), "%s [MYSQL: %i | IP: %s] lam no tung canh cua (/ram) nha [H_MYSQL: %i]",
				GetName(i), PlayerInfo[i][pID], q_GetPlayerIP(i), HouseInfo[houseid][hID]);
			    insert_log(query, RAM_LOG, 3, PlayerInfo[i][pAccID]);
            }
            else if (pTemp[i][pRamBiz] != -1)
            {
                new bizid = pTemp[i][pRamBiz];
            	CreateDynamicExplosion(BizInfo[bizid][bizPosX], BizInfo[bizid][bizPosY], BizInfo[bizid][bizPosZ], 12, 5.0, BizInfo[bizid][bizPosVW], BizInfo[bizid][bizPosInt]);
                if (IsValidDynamicObject(pTemp[i][pRamObj]))
				{
					DestroyDynamicObject(pTemp[i][pRamObj]);
					pTemp[i][pRamObj] = INVALID_OBJECT_ID;
				}
				BizInfo[bizid][bizLocked] = 0;
				BizInfo[bizid][bizDDoor] = 2;
				Save_Business(bizid);
				UpdateBusinessDoor(bizid);

                new query[256];
				format(query, sizeof(query), "%s [MYSQL: %i | IP: %s] lam no tung canh cua (/ram) doanh nghiep [B_MYSQL: %i]",
				GetName(i), PlayerInfo[i][pID], q_GetPlayerIP(i), BizInfo[bizid][bizID]);
			    insert_log(query, RAM_LOG, 4, PlayerInfo[i][pAccID]);
            }
			else if (pTemp[i][pRamGarage] != -1)
            {
                new garageid = pTemp[i][pRamGarage];

            	CreateDynamicExplosion(GarageInfo[garageid][garagePlayer_Enter][0], GarageInfo[garageid][garagePlayer_Enter][1], GarageInfo[garageid][garagePlayer_Enter][2], 12, 5.0, GarageInfo[garageid][garageEnterVW], GarageInfo[garageid][garageEnterInt]);

                if (IsValidDynamicObject(pTemp[i][pRamObj]))
				{
					DestroyDynamicObject(pTemp[i][pRamObj]);
					pTemp[i][pRamObj] = INVALID_OBJECT_ID;
				}
				
				GarageInfo[garageid][garageLocked] = 0;
				GarageInfo[garageid][garageDDoor] = 2;

				Save_Garage(garageid);
				UpdateGarageDoor(garageid);

                new query[128];
				format(query, sizeof(query), "%s [MYSQL: %i | IP: %s] lam no tung canh cua (/ram) garage [B_MYSQL: %i]",
				GetName(i), PlayerInfo[i][pID], q_GetPlayerIP(i), GarageInfo[garageid][garageID]);
			    insert_log(query, RAM_LOG, 5, PlayerInfo[i][pAccID]);
            }
		}
		//
		new vehicle = GetPlayerVehicleID(i), Float:health;
        AntiCheatGetVehicleHealth(vehicle, health);
		//Vehicle Milliage
		if (GetPlayerState(i) == PLAYER_STATE_DRIVER && VehicleInfo[vehicle][carOwnerID] != 0 && !IsPlayerAFK(i) && GetVehicleSpeed(vehicle) > 0)
		    VehicleInfo[vehicle][carMilliage] += GetVehicleSpeed(vehicle)/1.6/1609.344;
  		//Vehicle Milliage
		//Engine off
		if (GetPlayerState(i) == PLAYER_STATE_DRIVER && IsABicycle(vehicle) == 0 && VehicleInfo[vehicle][carEngineOn] && health < 390.0 && random(20) == 0)
		{
			GameTextForPlayer(i, "~w~DONG CO ~r~TAT", 2500, 4);
			SendNearbyMessage(Range_Normal, i, COLOR_PURPLE, "* Dong co bi chet may. (( %s [%s] ))", VehicleNames[GetVehicleModel(vehicle)-400], VehicleInfo[vehicle][carPlate]);

			VehicleEngine(vehicle, false);
		}

		//Plant picking
		if (pTemp[i][pPlantTime] > 0)
		{
			if (pTemp[i][pPlantTime] == 1)
			{
				GameTextForPlayer(i, "~w~Ban da trong ~g~cay~w~!", 1000, 4);
			    pTemp[i][pPlantTime] = 0;
				CreateCrop(i, pTemp[i][pPlantType]);
			}
			else
			{
				pTemp[i][pPlantTime]--;

				new mes[32];
				format(mes, sizeof(mes), "~y~Trong cay... %i", pTemp[i][pPlantTime]);
				GameTextForPlayer(i, mes, 1000, 4);
			}
		}

		//Fire
		if (pTemp[i][pFireTime] > 0)
		{
			if (pTemp[i][pFireTime] == 1)
			{
				GameTextForPlayer(i, "~w~Ban dang ~r~dot lua~w~!", 1000, 4);
				CreatePlayersFire(i, GetPVarInt(i, #firetype), GetPVarInt(i, #firebuildID));
				StopCreatingPlayersFire(i);
			}
			else if (GetPlayerAnimationIndex(i) == 168)
			{
				pTemp[i][pFireTime]--;

				new mes[32];
				format(mes, sizeof(mes), "~y~Dot lua ... %i", pTemp[i][pFireTime]);
				GameTextForPlayer(i, mes, 1000, 4);
				ApplyAnimation(i,"BOMBER","BOM_Plant_Loop", 4.0, 1, 0, 0, 0, 0, 1);
			}
			else
			{
				StopCreatingPlayersFire(i);
				SendErrorMessage(i, "Dot lua khong thanh cong, hay thu lai ");
			}
		}
		
		Mechanic_SecondTimer(i);

		//AFK Timer
        if (pTemp[i][pDarkAFK]++ >= 600 && !CheckAdmin(i, ADMIN_LEVEL_1) && !PlayerInfo[i][pPremium])
  		{
    		SendServerMessage(i, "Ban da bi kick vi AFK tren may chu. ");
		    KickEx(i);
  		}
		//AFK Timer

		//Driving license exam
		if (pTemp[i][pLicenseExam]) {
			if (GetPVarInt(i, #exam_second) > 0 && IsPlayerInAnyVehicle(i))
			{
				UpdateIntVar(i, #exam_second, -1);
				format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~w~thoi gian con lai: ~y~%i ~w~giay", GetPVarInt(i, #exam_second));
				GameTextForPlayer(i, string, 1200, 3);
			} else {
				new vehicleid = GetPlayerVehicleID(i);
				SendSyntaxMessage(i, "Ban da truot ky thi. ");
				pTemp[i][pLicenseExam] = 0;
				DeletePVar(i, #exam_second);
				TogglePlayerAllDynamicRaceCPs(i, false);
				RemovePlayerFromVehicle(i);
				RespawnVehicle(vehicleid);
			}
		}
		//Driving license exam
		//Gas Station Refueling
		/*if (GetPVarInt(i, "RefuelTime") != 0)
		{
			if (GetPVarInt(i, "RefuelTime") == 1) 
			{
				new toFill = 100 - VehicleInfo[vehicle][carFuel];
				UnFreezePlayer(i);
				new toFill = 100 - VehicleInfo[vehicle][carFuel];
				VehicleInfo[vehicle][carFuel] += toFill;
				SM2(i,"���� ������������ �������� ���� ���������� �� $%i.", GetPVarInt(i, "RefuelCost"));
				GiveCash(i, - GetPVarInt(i, "RefuelCost"));
				DeletePVar(i, "RefuelCost");
				DeletePVar(i, "RefuelTime");
			}
			else
			{
				UpdateIntVar(i, "RefuelTime", -1);
				format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~w~Refueling ~b~%i", GetPVarInt(i, "RefuelTime"));
				GameTextForPlayer(i, string, 1050, 3);
			}
		}*/
		//ERROR Message refresher
		/*for(new a = 0; a < 3; a ++)
		{
			if (ErrorInfo[i][a][eExpire] > 1)
			{
				ErrorInfo[i][a][eExpire]--;
				if (ErrorInfo[i][a][eExpire] == 1)
				{
					ErrorInfo[i][a][eExpire] = 0;
					RefreshErrorMsg(i);
				}
			}
		}*/
		//ERROR Message refresher
		//------------------------------------------------------------------
		//Checking jail time
		if (PlayerInfo[i][pMutedTime] > 0)
		{
			PlayerInfo[i][pMutedTime]--;
			if (!PlayerInfo[i][pMutedTime]) SCM(i, COLOR_LIGHTRED, "Tro chuyen lai co san cho ban.");
		}

		if (PlayerInfo[i][pAJailTime] > 1 && PlayerInfo[i][pAJailed] == 1)
		{
			PlayerInfo[i][pAJailTime]--;
			new mes[56];
			format(mes,sizeof(mes),"~p~thoi gian con lai: ~w~%i giay",PlayerInfo[i][pAJailTime]);
			GameTextForPlayer(i, mes, 1200, 4);
		}

		else if (PlayerInfo[i][pAJailTime] == 1 && PlayerInfo[i][pAJailed] == 1)
		{
			PlayerInfo[i][pAJailTime] = 0;
			PlayerInfo[i][pAJailed] = 0;
			SpawnPlayer(i);
			GameTextForPlayer(i,"~w~Ban ~g~duoc tu do~w~!",5000,1);
			SetPlayerPosEx(i, 71.7442,-99.9331,1.6342);
			SetWorld(i, 0);
			SetInterior(i, 0);
		}


		//Checking isolate time
		if (PlayerInfo[i][pIsolateTime] > 1) PlayerInfo[i][pIsolateTime]--;
		else if (PlayerInfo[i][pIsolateTime] == 1)
		{
		    PlayerInfo[i][pIsolateTime] = 0;
		    PutPlayerInPrison(i);
		}
		//Checking jail time
		if (PlayerInfo[i][pJailTime] > 1 && 0 == PlayerInfo[i][pIsolateTime] && 0 == PlayerInfo[i][pAJailTime]) PlayerInfo[i][pJailTime]--;
		else if (PlayerInfo[i][pJailTime] == 1)
		{
		  	SetPlayerPosEx(i, 71.7442,-99.9331,1.6342);
			SetWorld(i, 0);
			SetInterior(i, 0);
			
			PlayerInfo[i][pIsolateTime] = 0;
			PlayerInfo[i][pJailTime] = 0;
			PlayerInfo[i][pJailed] = 0;
			if (IsValidDynamic3DTextLabel(PrisonLabel[i]))
			{
				DestroyDynamic3DTextLabel(PrisonLabel[i]);
		        PrisonLabel[i] = Text3D:INVALID_3DTEXT_ID;
			}
			GameTextForPlayer(i,"~g~Su tu do~n~~w~Co gang tro thanh cong dan tot",5000,1);
		}
		//Checking jail time
		if (PlayerInfo[i][pAJailTime] > 1 && PlayerInfo[i][pAJailed] == 1)
		{
			PlayerInfo[i][pAJailTime]--;
			new mes[56];
			format(mes,sizeof(mes),"~p~thoi gian con lai: ~w~%i giay",PlayerInfo[i][pAJailTime]);
			GameTextForPlayer(i, mes, 1200, 4);
		}
		if (pTemp[i][pInjuredTime])
		{
			pTemp[i][pInjuredTime]--;
			if (PlayerInfo[i][pInjured] == 2)
			{
				new mes[56];
				format(mes,sizeof(mes),"~p~thoi gian con lai: ~w~%i giay", pTemp[i][pInjuredTime]);
				GameTextForPlayer(i, mes, 1200, 4);
			}
			if (0 == pTemp[i][pInjuredTime])
			{
				if (PlayerInfo[i][pInjured] == 1)
				{
					SendHelpMessage(i, "Su dung \"/acceptdeath\" de chap nhan cai chet cho nhan vat.");
				} 
				if (PlayerInfo[i][pInjured] == 2)
				{
					SM2(i, "Ban da nhap vien.");
		
					new 
						bill,
						tax,
						year,
						month,
						day
					;
					
					getdate(year, month, day);
					
					bill = 100, tax = 15;

					SendClientMessageEx(i,0xFF8282AA,"**********************************************");
					SendClientMessageEx(i,0xFF8282AA,"             	HOA DON BENH VIEN:");
					SendClientMessageEx(i,0xFF8282AA,"TEN: %s - NGAY SINH: %d-%d-%d.", GetNameEx(i), day, month, year);
					SendClientMessageEx(i,0xFF8282AA,"DICH VU: $%d - THUE: $%d.", bill, tax);
					bill+=tax;
					SendClientMessageEx(i,0xFF8282AA,"TONG CONG: $%d.", bill);
					SendClientMessageEx(i,0xFF8282AA,"**********************************************");
					pTemp[i][pInHospitalBed] = 0;
					PlayerInfo[i][pDeathReason] = 0;
					SQL_SetInteger("users", "deathreason", 0, PlayerInfo[i][pID]);
					BedOccupied[pTemp[i][pHospitalBed]] = false;
					if (!PlayerInfo[i][pPremium]) SetPlayerHealth(i, 50.0);
					else							  	SetPlayerHealth(i, 100.0);

					ResetDamages(i);
					StopPlayerAnims(i);
					UnFreezePlayer(i);

					SetPlayerSkill(i);
				} 
				if (PlayerInfo[i][pInjured] == 3) 
				{
					PlayerInfo[i][pInjured] = 0;
					StopPlayerAnims(i);
					UnFreezePlayer(i);
					SM1(i, "Ban khong con bi danh guc nua. Co gang boi bo suc khoe.");
				}
			}
		}
		
		//Info TextDraw Exire
		if (infotxt_expire{i} > 0)
		{
			infotxt_expire{i}--;
			if (infotxt_expire{i} == 1)
			{
				TextDrawHideForPlayer(i, infotxt[i]);
				infotxt_expire{i} = 0;
			}
		}
		if (pickup_expire{i} > 0)
		{
			pickup_expire{i}--;
			if (pickup_expire{i} == 1)
			{
				pickup_expire{i} = 0;
			}
		}
		//Info TextDraw Exire

		if (!IsPlayerInAnyVehicle(i)) {
			if (IsPlayerAroundShell(i) && !infotxt_expire{i} && !IsPlayerInAnyVehicle(i)) {
			InfoMSG(i, "Nhan ~y~'~k~~GROUP_CONTROL_BWD~'~w~ hoac nhap ~y~/SHELL~w~ nang cap vo.", 2);
			}
			else if (ATM_Nearest(i) != -1) {
				InfoMSG(i, "Nhan ~y~'~k~~GROUP_CONTROL_BWD~'~w~ hoac nhap ~y~/atm~w~ de su dung ATM.", 2);
			}
			else if (Payphone_Nearest(i) != -1) {
				InfoMSG(i, "Nhan ~y~'~k~~GROUP_CONTROL_BWD~'~w~ hoac nhap ~y~/pp~w~ de su dung dien thoai tra tien.", 2);
			}
			else if (Trash_Nearest(i, 2.0) != -1 && PlayerInfo[i][pJob] == JOB_TRASHMASTER && pTemp[i][pJob] && !HasTrash[i]) {
				InfoMSG(i, "Nhan ~y~'~k~~GROUP_CONTROL_BWD~'~w~ hoac nhap ~y~/ptrash~w~ de lay mot cai tui.", 2);
			}
		} else if (IsPlayerInAnyVehicle(i)) {
			if (Toll_Nearest(i) != -1) {
				InfoMSG(i, "Nhan ~y~'~k~~GROUP_CONTROL_BWD~'~w~ hoac nhap ~y~/opentoll~w~ de tra tien du lich.", 2);
			}	
			else if (GetNearGarage(i) != -1) {
				InfoMSG(i, "Nhan ~y~'~k~~GROUP_CONTROL_BWD~'~w~ hoac nhap ~y~/enter~w~ de vao nha de xe.", 2);
			} 
			else if (ModShop_Nearest(i) != -1 || PAS_Nearest(i) != -1) {
				InfoMSG(i, "Nhan ~y~'~k~~GROUP_CONTROL_BWD~'~w~ hoac nhap ~y~/enter~w~ de mo menu.", 2);
			}
			else if (AZC_Nearest(i) != -1) {
				if (!GetPVarInt(i, #UsePump)) InfoMSG(i, "Nhan ~y~'~k~~GROUP_CONTROL_BWD~'~w~ hoac nhap ~y~/fill~w~ de ~g~bat dau~w~ tiep nhien lieu.", 2);
				else InfoMSG(i, "Nhan ~y~'~k~~GROUP_CONTROL_BWD~'~w~ hoac nhap ~y~/fill~w~ de ~r~hoan thanh~w~ tiep nhien lieu.", 1);
			}
		}

		
		
		//����� ���������
		if (JackingEngine[i] > 1)
		{
		    if (!IsPlayerInAnyVehicle(i) || VehicleInfo[GetPlayerVehicleID(i)][carEngineOn]) StopJackingEngine(i);
		    else
		    {
				JackingEngine[i]--;
				format(string, sizeof(string), "~y~/(UNS)CRAMBLE~w~ <DECRYPTED WORD>~n~~r~ENCRYPTED~w~ WORD: ~r~'~w~%s~r~'~n~~w~BAN DA BO LO ~y~%i~w~ GIAY", UnscrambleInfo[pTemp[i][pUnscrambleID]][eScrambledWord], JackingEngine[i]);
				InfoMSG(i, string, 2);
			}
		}
		else if (JackingEngine[i] == 1) cmd::unscramble(i, "");
		//����� ���������

		//����� ������ ����
		if (JackingLock[i] > 1) 
		{
			if (pTemp[i][JackingType] == 1) {

				if (pTemp[i][JackingWarnings] >= 5)	return StopJackingLock(i);
				if (!CheckHanditem(i,18634))			return StopJackingLock(i);
			
				if (!IsPlayerInFrontVDoor(i, JackingVehicle[i])) {
					InfoMSG(i, "BAN QUA ~r~XA~w~, HAY TRO LAI!", 3);
					return pTemp[i][JackingWarnings]++;
				}
			} else if (pTemp[i][JackingType] == 3 || pTemp[i][JackingType] == 4) {
				if (pTemp[i][JackingWarnings] >= 5)				 		  return StopBreakingLock(i);
				if (pTemp[i][JackingType] == 4 && !CheckHanditem(i,18634)) return StopBreakingLock(i);

				if (!IsPlayerOutsideHouse(i, BreakingHouse[i], 1.5)) {
					InfoMSG(i, "BAN QUA ~r~XA~w~, HAY TRO LAI!", 3);
					return pTemp[i][JackingWarnings]++;
				}
			}
			else return 1;

			if (IsPlayerCrouching(i) == false){
				InfoMSG(i, "BAN PHAI ~r~NGOI~w~!", 2);
				return pTemp[i][JackingWarnings]++;
			}

		    if (!IsPlayerAFK(i))
		    {
				pTemp[i][JackingWarnings] = 0;
				JackingLock[i]--;

				if (pTemp[i][JackingType] == 2 || pTemp[i][JackingType])		   format(string, sizeof(string), "BAN DANG ~y~PHA~w~ CUA XE ~n~TRONG ~y~%i~w~ GIAY", JackingLock[i]);
				else if (pTemp[i][JackingType] == 3 || pTemp[i][JackingType] == 4) format(string, sizeof(string), "BAN DANG ~y~PHA~w~ CUA NHA ~n~TRONG ~y~%i~w~ GIAY", JackingLock[i]);
				InfoMSG(i, string, 2);
			}
		}
		else if (JackingLock[i] == 1)
		{
			if (pTemp[i][JackingType] == 2 || pTemp[i][JackingType] == 1)
			{
				if (IsValidVehicle(JackingVehicle[i])) {
					ToggleVehicleLock(JackingVehicle[i], false);
					PlaySound(i, 1145);
					InfoMSG(i, "BAN ~g~PHA~w~ CUA XE!", 3);
					AlarmOn(JackingVehicle[i]);

					StopJackingLock(i, 0);
				}
			} else {
				HouseInfo[BreakingHouse[i]][hLocked] = 0;
				PlaySound(i, 1145);
				InfoMSG(i, "BAN ~g~PHA~w~ CUA NHA!", 3);
				HouseAlarm(BreakingHouse[i], true);

				JackingLock[i] = 0;
				BreakingHouse[i] = 0;
				pTemp[i][JackingType] = 0;
				pTemp[i][JackingWarnings] = 0;
			}
		}

		if (VehicleInfo[JackingVehicle[i]][ePhysicalAttack] && GetPlayerState(i) == PLAYER_STATE_ONFOOT)
	    {
			if (!IsValidVehicle(JackingVehicle[i]))				 	return StopJackingLock(i);
			if (VehicleInfo[JackingVehicle[i]][carLocked] == 0)  	return StopJackingLock(i);
			if (IsPlayerInAnyVehicle(i))							return StopJackingLock(i);

			if (IsValidVehicle(JackingVehicle[i]))
			{
				new Float:ccX, Float:ccY, Float:ccZ;
				GetVehiclePos(JackingVehicle[i], ccX, ccY, ccZ);
				
				if (GetVehicleDriver(JackingVehicle[i]) != -1 || !IsPlayerInRangeOfPoint(i, 2.5, ccX, ccY, ccZ))
				{
					InfoMSG(i, "BAN QUA ~r~XA~w~, HAY TRO LAI!", 3);
					pTemp[i][JackingWarnings]++;

					if (pTemp[i][JackingWarnings] >= 5) return StopJackingLock(i);
				} else pTemp[i][JackingWarnings] = 0;
			}
			else return StopJackingLock(i);
		}
		//����� ������ ����

		if (PlayerInfo[i][MissionTarget][0] != INVALID_VEHICLE_ID && PlayerInfo[i][InMission] == CARJACKER_DELIVER)
		{
			if (!IsValidVehicle(PlayerInfo[i][MissionTarget][0]))	return StopJackingLock(i);
		    PlayerInfo[i][MissionTime] --;

		    new time[64];
			format(time, sizeof(time), "~r~CUOP XE~n~~w~CON ~y~%d~w~ GIAY", PlayerInfo[i][MissionTime]);
			InfoMSG(i, time, 2);

			new lights, doors, panels, tires;

			GetVehicleDamageStatus(PlayerInfo[i][MissionTarget][0], panels, doors, lights, tires);
			if (PlayerInfo[i][MissionTime] <= 0)
			{
			    PlayerInfo[i][MissionReward] = CJ_MissionReward(PlayerInfo[i][MissionTarget][0]); // temp reward
			    UpdateVehicleDamageStatus(PlayerInfo[i][MissionTarget][0], 53674035, 33686020, 5, 15);
			    PlayerInfo[i][InMission] = CARJACKER_DROPOFF;
				PlayerInfo[i][MissionTime] = 0;

				new idx = PlayerInfo[i][MissionTarget][1], 
					Float:persent = float(chopshop_data[idx][chopshop_procent])*float(PlayerInfo[i][MissionReward])/100.0;
				
				PlayerInfo[i][MissionReward] -= floatround(persent);

				chopshop_data[idx][chopshop_money] += floatround(persent);
				chopshop_data[idx][chopshop_vehs]++;

				SQL_SetInteger("chopshop", "money", chopshop_data[idx][chopshop_money], chopshop_data[idx][chopshop_id]);
				SQL_SetInteger("chopshop", "vehicles", chopshop_data[idx][chopshop_vehs], chopshop_data[idx][chopshop_id]);				

			    InfoMSG(i, "BAY GIO ~y~THOAT KHOI ~w~PHUONG TIEN.~n~VUI LONG NOTE VA GIAU NO THAT ~y~XA~w~, SAU DO NHAP ~y~/DROPOFF ~w~~n~~y~/LEAVEMISSION ~w~- THAM GIA NHIEM VU, ~r~BAN SE KHONG DUOC TIEN", 15);
				
				new engine,alarm,bonnet,boot,objective;
				GetVehicleParamsEx(GetPlayerVehicleID(i), engine, lights, alarm, doors, bonnet, boot, objective);
				SetVehicleParamsEx(GetPlayerVehicleID(i), VEHICLE_PARAMS_ON, lights, alarm, doors, bonnet, boot, objective);

				SendHelpMessage(i, "Viec thao do phuong tien da ket thuc. Ra khoi xe - /dropoff. Thoat nhiem vu - /leavemission");
			}
		}

		//WEAPONS NEW SYS
		if (PlayerInfo[i][pPlayerWeapon] > 0)
        {
		    if (PlayerInfo[i][pPlayerAmmo] <= 0)
		    {
		        if (!IsPlayerAttachedObjectSlotUsed(i, 9))
		        {
					new printid;
					if ((printid = PrintIid(PlayerInfo[i][pPlayerWeapon])) != -1) SetPlayerAttachedObject(i, 9, printid, 6, 0.0, 0.0, 0.0);
		        }
		    }
		    else
		    {
		        if (PlayerInfo[i][pForbid] > 0) SetPlayerArmedWeapon(i, 0);
				else 
				{
					if (GetPlayerWeapon(i) != PlayerInfo[i][pPlayerWeapon] && !IsPlayerInAnyVehicle(i))
					{
						SetPlayerArmedWeapon(i, PlayerInfo[i][pPlayerWeapon]);

						if (IsPlayerAttachedObjectSlotUsed(i, 9))
						{
							RemovePlayerAttachedObject(i, 9);
						}
					}
				}
		    }
        }
		if(pTemp[i][pSpamTime] > 0)
		{
			pTemp[i][pSpamTime]--;
		}
		new Float:rz;
		if(IsPlayerInAnyVehicle(i)) 
		{
			GetVehicleZAngle(GetPlayerVehicleID(i), rz);
		}
		else 
		{
			GetPlayerFacingAngle(i, rz);
		}
		if(rz >= 348.75 || rz < 11.25) PlayerTextDrawSetString(i, PlayerGPS[i][0], "N l");
		else if(rz >= 326.25 && rz < 348.75) PlayerTextDrawSetString(i, PlayerGPS[i][0], "NE l");
		else if(rz >= 303.75 && rz < 326.25) PlayerTextDrawSetString(i, PlayerGPS[i][0], "NE l");
		else if(rz >= 281.25 && rz < 303.75) PlayerTextDrawSetString(i, PlayerGPS[i][0], "NE l");
		else if(rz >= 258.75 && rz < 281.25) PlayerTextDrawSetString(i, PlayerGPS[i][0], "E l");
		else if(rz >= 236.25 && rz < 258.75) PlayerTextDrawSetString(i, PlayerGPS[i][0], "SE l");
		else if(rz >= 213.75 && rz < 236.25) PlayerTextDrawSetString(i, PlayerGPS[i][0], "SE l");
		else if(rz >= 191.25 && rz < 213.75) PlayerTextDrawSetString(i, PlayerGPS[i][0], "SE l");
		else if(rz >= 168.75 && rz < 191.25) PlayerTextDrawSetString(i, PlayerGPS[i][0], "S l");
		else if(rz >= 146.25 && rz < 168.75) PlayerTextDrawSetString(i, PlayerGPS[i][0], "SW l");
		else if(rz >= 123.25 && rz < 146.25) PlayerTextDrawSetString(i, PlayerGPS[i][0], "SW l");
		else if(rz >= 101.25 && rz < 123.25) PlayerTextDrawSetString(i, PlayerGPS[i][0], "SW l");
		else if(rz >= 78.75 && rz < 101.25) PlayerTextDrawSetString(i, PlayerGPS[i][0], "W l");
		else if(rz >= 56.25 && rz < 78.75) PlayerTextDrawSetString(i, PlayerGPS[i][0], "NW l");
		else if(rz >= 33.75 && rz < 56.25) PlayerTextDrawSetString(i, PlayerGPS[i][0], "NW l");
		else if(rz >= 11.5 && rz < 33.75) PlayerTextDrawSetString(i, PlayerGPS[i][0], "NW l");
		GetPlayerGPS(i);
	}
	return 1;
}

this::PlayerSaver()
{
	foreach(new i : Player)
	{
		Save_User(i);
	}
	SetTimer("PlayerSaver", 300000, false);
	return 1;
}
