Dialog:DutyMenu(playerid, response, listitem, inputtext[])
{
	if (!response) return 1;
	    
    new faction = PlayerInfo[playerid][pFaction];
    
	if (faction == 0 || !IsFactionLegal(faction)) return 1;
        
	switch(listitem)
	{
	    case 0://duty
	    {
			if (CheckAdmin(playerid, ADMIN_LEVEL_1))	return SendErrorMessage(playerid, "Truoc tien, ban can ngoai gio lam viec quan tri vien.");
		    if (pTemp[playerid][pTaser])				return SendErrorMessage(playerid, "Truoc tien, ban can phai thao taser.");
		    if (pTemp[playerid][pPatrol])				return SendErrorMessage(playerid, "Truoc tien, ban can phai dung cuoc tuan tra (/callsign).");
            if (!IsPlayerAtUniform(playerid))			return SendErrorMessage(playerid, "Ban khong o trong phong thay do.");
    	
	        if (!PlayerInfo[playerid][pOnDuty])
			{
				if (PlayerInfo[playerid][pPlayerWeapon]) 
				{
					if (CheckInv(playerid))	cmd::putgun(playerid, "");
					else return SendErrorMessage(playerid, "Dau tien hay dua vu khi vao tui do. ");
				}
				
				SetPVarInt(playerid, #pDelay, 1);

				new count;
			    for(new i; i < MAX_INV_SLOTS; i++)
				{
					if (inventory_items[Inventory[playerid][i][pInvItem]][itemType] != ITEM_TYPE_WEAPON && 
						inventory_items[Inventory[playerid][i][pInvItem]][itemType] != ITEM_TYPE_AMMO) continue;

					if (count >= MAX_COP_SLOTS)
					{
						for(new j; j < MAX_INV_SLOTS; j++)
						{
							PlayerInfo[playerid][pCopItem][j] = 0;
							PlayerInfo[playerid][pCopQ][j] = 0;
							PlayerInfo[playerid][pCopEx][j] = 0;
							PlayerInfo[playerid][pCopS][j] = 0;
						}

						SetPVarInt(playerid, #pDelay, 0);
						SendAdmMessage("%s co mot so luong lon vu khi trong tui do cua minh. [CANH BAO]", GetNameEx(playerid));
						return SendErrorMessage(playerid, "Ban co qua nhieu vu khi / dan duoc! (Ban chi co the vao hop: 5 vat pham)");
					}

				    PlayerInfo[playerid][pCopItem][count] = Inventory[playerid][i][pInvItem];
				    PlayerInfo[playerid][pCopQ][count] = Inventory[playerid][i][pInvQ];
					PlayerInfo[playerid][pCopEx][count] = Inventory[playerid][i][pInvEx];
					PlayerInfo[playerid][pCopS][count] = Inventory[playerid][i][pInvItem];

					count++;
				}

				ResetPlayerWeaponsEx(playerid);

				if (IsFactionPolice(faction))
				{
					SendNearbyMessage(Range_Normal, playerid, COLOR_PURPLE, "%s %s da lay mot the nganh trong tu do cua minh.", GetRankName(playerid), GetNameWithMask(playerid));
				}

				PlayerInfo[playerid][pOnDuty] = 1;
				pTemp[playerid][tempStatus] = 1;
		 		SetPlayerColor(playerid, RemoveAlpha(Factions[faction][fColor]));
		        SendFactionMessage(faction, COLOR_POLICECHAT, "** HQ: %s %s da bat dau nhiem vu. **", GetRankName(playerid), GetNameEx(playerid));
				InfoMSG(playerid,   "~g~ON DUTY", 6);
				
				cmd::duty(playerid, "");
				Save_User(playerid);

				SetPVarInt(playerid, #pDelay, 0);
				return 1;
			}

			ResetPlayerWeaponsEx(playerid);
			
			if (IsPlayerAttachedObjectSlotUsed(playerid, 5))	RemovePlayerAttachedObject(playerid, 5);
			if (IsPlayerAttachedObjectSlotUsed(playerid, 6))	RemovePlayerAttachedObject(playerid, 6);
    		if (IsPlayerAttachedObjectSlotUsed(playerid, 7))	RemovePlayerAttachedObject(playerid, 7);

			new copsitems = 0, playersitems = 0;
			for(new i = 0; i < MAX_INV_SLOTS; i++)
			{
				if (i < MAX_COP_SLOTS) if (PlayerInfo[playerid][pCopItem][i]) copsitems++;
				if (!Inventory[playerid][i][pInvItem]) playersitems++;
			}

			if (playersitems - copsitems >= 0)
			{
				for(new i = 0; i < MAX_COP_SLOTS; i++)
				{					
					if (PlayerInfo[playerid][pCopItem][i])
					{
						new slotid = GetInvNextSlot(playerid);
						if (slotid == -1)	continue;

						Inventory[playerid][slotid][pInvItem] = PlayerInfo[playerid][pCopItem][i];
						Inventory[playerid][slotid][pInvQ] = PlayerInfo[playerid][pCopQ][i];
						Inventory[playerid][slotid][pInvEx] = PlayerInfo[playerid][pCopEx][i];
						Inventory[playerid][slotid][pInvS] = PlayerInfo[playerid][pCopS][i];
					}
					
					PlayerInfo[playerid][pCopItem][i] = 0;
					PlayerInfo[playerid][pCopQ][i] = 0;
					PlayerInfo[playerid][pCopEx][i] = 0;
					PlayerInfo[playerid][pCopS][i] = 0;				
				}
			}
			else return SendErrorMessage(playerid, "Ban khong the lay cac mat hang tu thung cua ban. Tui do cua ban da day.");

			if (IsFactionPolice(faction))
			{
				SendNearbyMessage(Range_Normal, playerid, COLOR_PURPLE, "%s %s dat the nganh trong tu do cua anh ay.", GetRankName(playerid), GetNameWithMask(playerid));
			}

			SendFactionMessage(faction, IsFactionPolice(faction) ? COLOR_LIGHTBLUE : LSFD_DUTY, "** HQ: %s %s da hoan thanh nhiem vu. **", GetRankName(playerid), GetNameEx(playerid));
			InfoMSG(playerid,   "~r~OFF DUTY", 6);
			
			DestroyAllBort(playerid);
		    PlayerInfo[playerid][pChar] = 
			PlayerInfo[playerid][pSwatDuty] = 
			PlayerInfo[playerid][pOnDuty] = 
			pTemp[playerid][tempStatus] = 0;
			foreach(new p : Player) { if(pTemp[p][pSpecPlayer] == playerid) TogglePlayerSpectating(p, 0); }

			CallRemoteFunction("LoadHolsters","i",playerid);
			SetPlayerColor(playerid, TEAM_HIT_COLOR);
			SetPlayerArmour(playerid, 0);
			SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
			cmd::duty(playerid, "");

			return Save_User(playerid);
	    }
	    case 1:
		{
		    if (!PlayerInfo[playerid][pOnDuty])		return SendErrorMessage(playerid,"Dau tien ban can trong gio lam viec.");
            if (!IsPlayerAtUniform(playerid))		return SendErrorMessage(playerid, "Ban khong o trong phong thay do.");
            if (PlayerInfo[playerid][pSwatDuty])	return SendErrorMessage(playerid, "Dat S.W.A.T xuong. thiet bi truoc khi thay dong phuc cua ban.");
                
			if (IsFactionPolice(faction))
			{
				new submes[16],
					mes[sizeof(police_skins)*sizeof(submes)];
				
				for(new i = 0; i < sizeof(police_skins); i++)
				{
					format(submes, sizeof(submes), "%i\tID: %i\n", police_skins[i], i);
					strcat(mes, submes);
				}
				Dialog_Show(playerid, MODEL_SELECTION_UNIFORM, DIALOG_STYLE_PREVIEW_MODEL, "Lua chon hinh thuc dich vu", mes, "Chon", "Dong");		
			}
			else if (IsFactionMedic(faction) || IsFactionFire(faction))
		    {
				new submes[16], mes[sizeof(fd_skins)*sizeof(submes)];

				for(new i = 0; i < sizeof(fd_skins); i++)
				{
					format(submes, sizeof(submes), "%i\tID: %i\n", fd_skins[i], i);
					strcat(mes, submes);
				}
				Dialog_Show(playerid, MODEL_SELECTION_UNIFORM, DIALOG_STYLE_PREVIEW_MODEL, "Lua chon hinh thuc dich vu", mes, "Chon", "Dong");
			}
			else if (IsFactionDocs(faction))
		    {
				new mes[sizeof(docs_skins)*128];
				for(new i = 0; i < sizeof(docs_skins); i++)
				{
					format(mes, sizeof(mes), "%s%i\tID: %i\n", mes, docs_skins[i], docs_skins[i]); 
				}
				Dialog_Show(playerid, MODEL_SELECTION_UNIFORM, DIALOG_STYLE_PREVIEW_MODEL, "Lua chon hinh thuc dich vu", mes, "Chon", "Dong");
			}
			else if (IsFactionCity(faction))
			{
				new submes[128], mes[sizeof(city_skins)*sizeof(submes)];

				for(new i = 0; i < sizeof(city_skins); i++)
				{
					format(submes, sizeof(submes), "%i\tID: %i\n", city_skins[i], i);
					strcat(mes, submes);
				}
				Dialog_Show(playerid, MODEL_SELECTION_UNIFORM, DIALOG_STYLE_PREVIEW_MODEL, "Lua chon hinh thuc dich vu", mes, "Chon", "Dong");
			}

			else SendErrorMessage(playerid, "Chuc nang nay khong kha dung cho to chuc cua ban.");
		}
		case 2:
	    {
	        if (!PlayerInfo[playerid][pOnDuty])										return SendErrorMessage(playerid, "Dau tien ban can trong gio lam viec.");
            if (!IsPlayerAtUniform(playerid) && !IsPlayerAtSecondUniform(playerid))	return SendErrorMessage(playerid, "Ban khong o trong phong thay do.");
    			
			if (IsFactionPolice(faction))
			{
				return Dialog_Show(playerid, LSPDArmoury, DIALOG_STYLE_LIST, "Thiet bi & Vu khi", "- Bo dam\n- Vu khi\n- Thiet bi S.W.A.T", "Chon", "Quay lai");
			}
			else if (IsFactionDocs(faction))
			{	
				return Dialog_Show(playerid, DOCSGUN, DIALOG_STYLE_LIST, "Vu khi", "- Bo dam\n- Cudgel\n- Pepper Spray\n- Desert Eagle (.50AE .ext)\n\t{ffc46a} - Get extra magazines (.50AE .ext)\n{FFFFFF} - MP5 (9x19mm .ext)\n\t{ffc46a} - Get extra magazines (9x19mm .ext)\n{FFFFFF} - Shotgun (12-G BIRDSHOT)\n\t{ffc46a} - Get extra magazines (12-G BIRDSHOT)\n\t{ffc46a} - Take non-lethal magazines (12-G BEANBAG)\n{FFFFFF} - M4 (5.56x45mm (drum))\n\t{ffc46a} - Take extra magazines (5.56x45mm (drum))\n\t{ffc46a} - Take non-lethal magazines (5.56x45mm (rubber))\n{FFFFFF} - Sniper Rifle (7.62x51mm)\n\t{ffc46a} - Take extra magazines (7.62x51mm)\n{FFFFFF} - Gas grenade\n- Camera\n{FF6347} - Dau hang tat ca vu khi", "Chon", "Dong");
			}
			else if (IsFactionCity(faction))
			{
			    return Dialog_Show(playerid, CITYGUN, DIALOG_STYLE_LIST, "Vu khi", "- Bo dam\n- Desert Eagle ( .50AE .ext )\n\t{ffc46a} - Get extra magazines (.50AE .ext)\n{FFFFFF} - MP5 (9x19mm .ext)\n\t{ffc46a} - Get extra magazines (9x19mm .ext)\n{FFFFFF} - M4 (5.56x45mm (drum))\n\t{ffc46a} - Get extra ammo (5.56x45mm (drum))\n\t{ffc46a} - Take non-lethal ammo (5.56x45mm (rubber))\n{FF6347} - Surrender all weapons", "Chon", "Dong");
			}
			else if (IsFactionFire(faction) || IsFactionMedic(faction))
			{
		        return Dialog_Show(playerid, FDArmoury, DIALOG_STYLE_LIST, "Thiet bi", "- Bo dam\n- May cua\n- Binh cuu hoa\n{FF6347}- Bat tat ca cac thiet bi", "Chon", "Quay lai");
			}
	    }
	    case 3:
	    {
	        if (!PlayerInfo[playerid][pOnDuty])										return SendErrorMessage(playerid, "Dau tien ban can trong gio lam viec.");
	        if (!IsFactionLegal(faction))											return SendErrorMessage(playerid, "Ban phai la canh sat / nhan vien y te.");
            if (!IsPlayerAtUniform(playerid) && !IsPlayerAtSecondUniform(playerid))	return SendErrorMessage(playerid, "Ban khong o trong phong thay do.");
    			
		    if (IsFactionMedic(faction) || IsFactionFire(faction)) SetPlayerArmour(playerid, 50.0);
			else				SetPlayerArmour(playerid, 100.0);

			SendSyntaxMessage(playerid, "Ban dang mac ao trong dan. ");
            cmd::duty(playerid, "");
	    }
	    case 4:
	    {
	        if (!PlayerInfo[playerid][pOnDuty])	return SendErrorMessage(playerid, "Ban can phai trong gio lam viec (/duty).");
            if (!IsPlayerAtUniform(playerid))	return SendErrorMessage(playerid, "Ban khong o trong phong thay do.");

		    SetPlayerHealth(playerid, 100.0);
		    
			SendSyntaxMessage(playerid, "Ban da bo sung cho suc khoe cua minh. ");
		    cmd::duty(playerid, "");
	    }
	}
	return 1;
}

Dialog:ScrapVehicleFaction(playerid, response, listitem, inputtext[])
{
	if (!response)											return 1;
    if (PlayerInfo[playerid][pFaction] == 0)				return SendErrorMessage(playerid, "Ban khong phai la thanh vien cua mot to chuc.");
	if (!IsFactionLegal(PlayerInfo[playerid][pFaction]))	return SendErrorMessage(playerid, "Ban khong thuoc to chuc chinh phu. ");

	new veh = PlayerInfo[playerid][pCarKey];

	if (!IsValidVehicle(veh))					return SendErrorMessage(playerid, "Phuong tien cua ban chua duoc tao ra.");
	if (!IsPlayerInVehicle(playerid, veh))		return SendErrorMessage(playerid, "Ban khong phai la chu so huu cua phuong tien nay.");
	if (IsADonateModel(GetVehicleModel(veh)))	return SendErrorMessage(playerid, "Ban khong the chuyen chiec xe nay.");
	if (VehicleInfo[veh][carComponent][5] != 0)	return SendErrorMessage(playerid, "Ban khong the chuyen chiec xe nay khi no co nitro tren do.");
	    
    VehicleInfo[veh][carOwnerID] = 0;
    VehicleInfo[veh][carFaction] = PlayerInfo[playerid][pFaction];
    StopCarBoomBox(veh);
    
	new query[128];
    mysql_format(dbHandle, query, sizeof(query), "UPDATE `cars` SET `owner_id`=0, `faction`=%i WHERE `id`=%i", PlayerInfo[playerid][pFaction], VehicleInfo[veh][carID]);
	mysql_tquery(dbHandle, query);
    PlayerInfo[playerid][pCarKey] = 0;
    VehicleInfo[veh][carOwnerPlayer] = INVALID_PLAYER_ID;
    DeleteVehicleTickets(veh);
	SendSyntaxMessage(playerid, "Ban da chuyen phuong tien %s cua minh sang to chuc %s.", VehicleNames[VehicleInfo[veh][carModel]-400], Factions[PlayerInfo[playerid][pFaction]][fName]);
	return 1;
}

Dialog:BortListChoose(playerid, response, listitem, inputtext[])
{
	if (!response)	return cmd::bortlist(playerid, "");

    new bort = GetPVarInt(playerid, #select_bort)-1;

    DeletePVar(playerid, #select_bort);
	if (bort < 0)	return SendErrorMessage(playerid, "Khong tim thay doi tuong. ");

	if (BortInfo[playerid][bort][bortUsing]) return SendErrorMessage(playerid, "Doi tuong hien dang duoc su dung! ");

	if (listitem == 0)
	{
	    if (BortInfo[playerid][bort][bortOn] == 0)	return SendErrorMessage(playerid, "Khong tim thay doi tuong. ");

		new Float: x, Float: y, Float: z;
		GetDynamicObjectPos(BortInfo[playerid][bort][bortObject], x, y, z);


		if (GetPlayerDistanceFromPoint(playerid, x, y, z) > 10.0)	return SendErrorMessage(playerid, "Doi tuong o qua xa ban.");
		if (IsPlayerInAnyVehicle(playerid))							return SendErrorMessage(playerid, "Ban khong duoc o trong xe.");
    	if (!PlayerInfo[playerid][pOnDuty])							return SendErrorMessage(playerid, "Dau tien ban can trong gio lam viec. ");

		EditDynamicObject(playerid, BortInfo[playerid][bort][bortObject]);
		pTemp[playerid][pEditBort] = bort+1;
	    return 1;
	}

    if (!BortInfo[playerid][bort][bortOn]) 	return SendErrorMessage(playerid, "Khong tim thay doi tuong. ");

	BortInfo[playerid][bort][bortOn] = 0;
	BortInfo[playerid][bort][bortUsing] = 0;

	if (IsValidDynamicObject(BortInfo[playerid][bort][bortObject]))
	{
		DestroyDynamicObject(BortInfo[playerid][bort][bortObject]);
 		BortInfo[playerid][bort][bortObject] = INVALID_OBJECT_ID;
	}

	SendSyntaxMessage(playerid, "Doi tuong '%s' da duoc xoa.", BortInfo[playerid][bort][bortName]);

	for (new i = 0; i != MAX_BORTES; i ++)
	{
		if (BortInfo[playerid][i][bortOn] == 0) continue;
		cmd::bortlist(playerid, "");
		break;
	}

	return 1;
}

Dialog:BortList(playerid, response, listitem, inputtext[])
{
	if (!response) return 1;

	if (listitem == 0)
	{
		SendSyntaxMessage(playerid, "Tat ca doi tuong da duoc xoa.");
	    DestroyAllBort(playerid);
	    return 1;
	}
	
	new count;

	for (new i = 0; i != MAX_BORTES; i ++)
	{
		if (BortInfo[playerid][i][bortOn] == 0) continue;
		
  		if (count == listitem-1)
      	{
       		Dialog_Show(playerid, BortListChoose, DIALOG_STYLE_LIST, BortInfo[playerid][i][bortName], "Chinh sua doi tuong\nXoa doi tuong", "Chon", "Quay lai");
         	SetPVarInt(playerid, #select_bort, i+1);
			return 1;
   		}
    	count++;
	}
	SendErrorMessage(playerid, "Khong tim thay doi tuong. ");
	return 1;
}

Dialog:FactionSettings(playerid, response, listitem, inputtext[])
{
	if (!response) return 1;
	return ShowRightsForRank(playerid, listitem);
}

Dialog:FactionSettings_Set(playerid, response, listitem, inputtext[])
{
	if (!response) return 1;

	new faction = PlayerInfo[playerid][pFaction], rank = GetPVarInt(playerid, "Faction:RankEdit")-1;

	switch(listitem)
	{
		case 0:	FRank[faction][rank][rInvite] = !FRank[faction][rank][rInvite];
		case 1: FRank[faction][rank][rUninvite] = !FRank[faction][rank][rUninvite];
		case 2: FRank[faction][rank][rRank] = !FRank[faction][rank][rRank];
		case 3: FRank[faction][rank][r_eRank] = !FRank[faction][rank][r_eRank];
		case 4: FRank[faction][rank][rSpawn] = !FRank[faction][rank][rSpawn];
		case 5: FRank[faction][rank][rChat] = !FRank[faction][rank][rChat];
		case 6: FRank[faction][rank][rTow] = !FRank[faction][rank][rTow];
		case 7: FRank[faction][rank][rBodyCam] = !FRank[faction][rank][rBodyCam];
		case 8: FRank[faction][rank][r_eRights] = !FRank[faction][rank][r_eRights];
	}

	UpdateFactionRank(faction, rank+1);
	ShowRightsForRank(playerid, rank);
	DeletePVar(playerid, "Faction:EditRank");
	return 1;
}