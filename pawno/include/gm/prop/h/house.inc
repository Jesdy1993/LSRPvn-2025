House_OnPlayerSelectedMenuRow(playerid, row)
{
    if (GetPlayerMenu(playerid) != buy_interior) return 1;
	
	new houseid = pTemp[playerid][pInteriorHouse]-1;

	switch(row)
	{
	    case 0:
    	{
	        for(new i = pTemp[playerid][pInteriorID]+1; i < MAX_INTERIORS; i++)
	        {
	            if (!AdminTeles[i][telesOn] || HouseInfo[houseid][hClass] != AdminTeles[i][telesType]) continue;
					
                pTemp[playerid][pInteriorID] = i;
				DestroyPlayerObject(playerid, pTemp[playerid][pInteriorObj]);
	            pTemp[playerid][pInteriorObj] = CreatePlayerObject(playerid, 19300, AdminTeles[i][telesPosX], AdminTeles[i][telesPosY], AdminTeles[i][telesPosZ], 0.0, 0.0, 0.0);
				AttachCameraToPlayerObject(playerid, pTemp[playerid][pInteriorObj]);
			    break;
	        }

	        ShowMenuForPlayer(buy_interior, playerid);
		}
		
	    case 1:
		{
		    for(new i = pTemp[playerid][pInteriorID]-1; i != 0; i--)
	        {
	            if (!AdminTeles[i][telesOn] || HouseInfo[houseid][hClass] != AdminTeles[i][telesType]) continue;

                pTemp[playerid][pInteriorID] = i;
				DestroyPlayerObject(playerid, pTemp[playerid][pInteriorObj]);
	            pTemp[playerid][pInteriorObj] = CreatePlayerObject(playerid, 19300, AdminTeles[i][telesPosX], AdminTeles[i][telesPosY], AdminTeles[i][telesPosZ], 0.0, 0.0, 0.0);
				AttachCameraToPlayerObject(playerid, pTemp[playerid][pInteriorObj]);
			    break;
	        }

	        ShowMenuForPlayer(buy_interior, playerid);
		}

		case 2:
		{
		    new id = pTemp[playerid][pInteriorID];
		    if (!AdminTeles[id][telesOn] || HouseInfo[houseid][hClass] != AdminTeles[id][telesType])	return SendErrorMessage(playerid, "Interior error."); //������ ����
				
			Dialog_Show(playerid, BuyInteriorAccept, DIALOG_STYLE_MSGBOX, "{FFFFFF}Noi that", "{ffffff}Ban muon mua noi that trong nha voi gia $750.\nTat ca do dac da mua se duoc ban!", "Mua", "Huy bo");
		}
	    case 3:	SetPlayerBuyInterior(playerid, 0);
	    
	}
    return 1;
}

House_OnPlayerEnterDynamicCP(playerid, checkpointid)
{
    if (GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
		for(new i = 0; i < MAX_HOUSES; i++)
		{
		    if (!HouseInfo[i][hID] || (checkpointid != HouseInfo[i][hCheckPoint] && checkpointid != HouseInfo[i][hExtCheckPoint])) continue;

			if (pTemp[playerid][pPizzaBoy] && pTemp[playerid][pPizzaBoy]-1 == i && IsPlayerAttachedObjectSlotUsed(playerid, ATTACH_HANDS))
			{
			    pTemp[playerid][pPizzaBoy] = 0;
				#define PIZZABOY_COST 100
				new pizzaboysalary = random(PIZZABOY_COST);
			    SendSyntaxMessage(playerid, "Pizza duoc giao, ban da kiem duoc $%i.", pizzaboysalary);
			    GiveCash(playerid, pizzaboysalary);
                RemovePlayerAttachedObject(playerid, ATTACH_HANDS);
			    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
				return 1;
			}
			new
				string[128]
			;

            if (!HouseInfo[i][hOwnerID] && checkpointid == HouseInfo[i][hCheckPoint])
			{
				new door[11];
				switch(HouseInfo[i][hDoor])
				{
					case 0: door = "Thuong";
					case 1: door = "Go";
					case 2: door = "Sat";
				}

				format(string, sizeof(string), "Cap do khoa: %i / Cap do bao dong: %i / Cua: %s", HouseInfo[i][hLock], HouseInfo[i][hAlarm], door);
				InfoMSG(playerid, string, 5);

				//format(string, sizeof(string), "~h~~p~HOUSE FOR SALE! ~w~/ PRICE: ~g~$%i~n~~y~%s", HouseInfo[i][hPrice], (!HouseInfo[i][hApart])?(GetHouseZone(i, 2)):(GetApartmentZone(HouseInfo[i][hApart], 2)));
				
				SendClientMessage(playerid, COLOR_GREEN, "Ban co muon mua cai nay khong?.");
				SendClientMessage(playerid, COLOR_WHITE, "Ban muon thue o day? /rentroom.");
				format(string, sizeof(string), "[%i] GIA: $%i, %sth", HouseInfo[i][hID], HouseInfo[i][hPrice], (!HouseInfo[i][hApart])?(GetHouseZone(i, 1)):(GetApartmentZone(HouseInfo[i][hApart], 1)));
				SendClientMessage(playerid, COLOR_GREEN, string);
				SendClientMessage(playerid, COLOR_WHITE, "Cac lenh co san: /enter /(ds)hout /ddo /knock /checkint /h(ouse) buy");
				//CreateLableText(playerid, string, "~h~Press ~y~~h~'F' ~w~ to buy or~n~type ~y~~h~/h buy~h~~w~ for purchase");
				return 1;
	   		}
			else if (HouseInfo[i][hOwnerID] != 0)
   			{
				if (checkpointid == HouseInfo[i][hCheckPoint]) 
				{
					if(HouseInfo[i][hOwnerID] != PlayerInfo[playerid][pID])
					{
						SendClientMessage(playerid, COLOR_WHITE, "Ban muon thue o day? /rentroom.");
						format(string, sizeof(string), "%sth", (!HouseInfo[i][hApart])?(GetHouseZone(i, 1)):(GetApartmentZone(HouseInfo[i][hApart], 1)));
						SendClientMessage(playerid, COLOR_GREEN, string);
						SendClientMessage(playerid, COLOR_WHITE, "Cac lenh co san: /enter /(ds)hout /ddo /knock.");
					}
					else
					{
						SendClientMessage(playerid, COLOR_GREEN, "Chao mung den ngoi nha!");
						SendClientMessage(playerid, COLOR_WHITE, "Cac lenh co san: /enter /(ds)hout /ddo /house.");
					}

					/*format(string, sizeof(string),"~h~~p~House %s~n~%s", HouseInfo[i][hOwner], (!HouseInfo[i][hApart])?(GetHouseZone(i, 2)):(GetApartmentZone(HouseInfo[i][hApart], 2))); 
					CreateLableText(playerid, string, "~h~Press ~y~~h~'F' ~w~ to enter or~n~type ~y~~h~/enter~h~~w~ to enter");*/
				} 
				else if (checkpointid == HouseInfo[i][hExtCheckPoint]) 
				{
					format(string, sizeof(string), "Ban dang dung truoc cua ~h~~g~ngoi nha~w~ cua %s.~n~~y~/enter /(ds)hout /ddo /knock.", (HouseInfo[i][hOwnerID] != PlayerInfo[playerid][pID])?("ai do"):("ban"));
					InfoMSG(playerid, string, 5);

					format(string, sizeof(string),"~h~~p~Loi vao phia sau~n~%s", (!HouseInfo[i][hApart])?(GetHouseZone(i, 1)):(GetApartmentZone(HouseInfo[i][hApart], 1))); 
					CreateLableText(playerid, string, "~h~Nhan ~y~~h~'F' ~w~ de vao hoac~n~nhap ~y~~h~/enter~h~~w~ de vao");
				}
				

                return 1;
			}
		}
    }
    return 1;
}

House_OnGameModeInit()
{
    return mysql_tquery(dbHandle, "SELECT *, (SELECT name FROM users WHERE id = houses.owner) as ownername, (SELECT last_login FROM users WHERE id = houses.owner) as last_login FROM `houses`", "LoadDynamicHouses");
}

House_PlayerTimer(playerid)
{
	if (GetPVarInt(playerid, #check_int))
	{
	    UpdateIntVar(playerid, #check_int, -1);

	    new hid = -1;

		if (!GetPVarInt(playerid, #check_int) && (hid = GetNearInsideHouse(playerid)) != -1)
		{		        
			SetPlayerPosEx(playerid, HouseInfo[hid][hPosX], HouseInfo[hid][hPosY], HouseInfo[hid][hPosZ]);
			SetInterior(playerid, HouseInfo[hid][hPosInt]);
			SetWorld(playerid, HouseInfo[hid][hPosVW]);
		 	pTemp[playerid][pHouseEntered] = -1;
	      	SendSyntaxMessage(playerid, "Thoi gian xem da het.");
		    DeletePVar(playerid, #check_int);
		}
	}
	return 1;
}