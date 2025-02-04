#if !defined KEY_AIM
	#define KEY_AIM 128
#endif

HoldingKey(playerid, key)
{
	new keys, ud, lr;

	GetPlayerKeys(playerid, keys, ud, lr);
	return (keys & key == key) ? (1):(0);
}

Keys_OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	/*if (HOLDING(KEY_WALK))
	{
		cmd::walking(playerid, "");
	}*/

	if (VehicleInfo[JackingVehicle[playerid]][ePhysicalAttack] && RELEASED(KEY_FIRE) && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && !VehicleInfo[JackingVehicle[playerid]][vCooldown])
    {
		new weaponid = GetPlayerWeapon(playerid);
		new vehicleid = JackingVehicle[playerid];
		if (IsValidVehicle(vehicleid))
		{
			new Float:ccX, Float:ccY, Float:ccZ;
			new Float:dX, Float:dY, Float:dZ, Float: playerHealth;
			
			AntiCheatGetHealth(playerid, playerHealth);
			GetVehicleModelInfo(VehicleInfo[vehicleid][carModel], VEHICLE_MODEL_INFO_FRONTSEAT, ccX, ccY, ccZ);
			GetVehicleRelativePos(vehicleid, dX, dY, dZ, -ccX - 0.5, ccY, ccZ);
			
			if (GetVehicleDriver(vehicleid) != -1 || VehicleInfo[vehicleid][eDoorHealth] <= 0.0 || !IsPlayerInFrontVDoor(playerid, vehicleid)) return 1;
			
		    switch(VehicleInfo[vehicleid][eDoorEffect])
		    {
		        case LESS_DAMAGE_FIST:
		        {
		            if (weaponid == 0)
		            {
		                VehicleInfo[vehicleid][eDoorHealth] = (VehicleInfo[vehicleid][eDoorHealth] - 1 <= 0) ? 0 : VehicleInfo[vehicleid][eDoorHealth] - 1;
		                if (playerHealth > 15.0)
		                {
		                    SetPlayerHealth(playerid, playerHealth - 10.0);
		                }
		            }
		            if (weaponid >= 1 && weaponid <= 9)
		            {
		                VehicleInfo[vehicleid][eDoorHealth] = (VehicleInfo[vehicleid][eDoorHealth] - 10 <= 0) ? 0 : VehicleInfo[vehicleid][eDoorHealth] - 10;
		            }
		          	if (weaponid >= 22 && weaponid <= 24)
		            {
		                VehicleInfo[vehicleid][eDoorHealth] = (VehicleInfo[vehicleid][eDoorHealth] - 15 <= 0) ? 0 : VehicleInfo[vehicleid][eDoorHealth] - 15;
              		}
		          	if (weaponid >= 25 && weaponid <= 34)
		            {
		                VehicleInfo[vehicleid][eDoorHealth] = (VehicleInfo[vehicleid][eDoorHealth] - 30 <= 0) ? 0 : VehicleInfo[vehicleid][eDoorHealth] - 30;
		            }
		        }
		        case BLOCK_FIST:
		        {
					if (weaponid == 0) if (playerHealth > 15.0) SetPlayerHealth(playerid, playerHealth - 5.0);

		            if (weaponid >= 1 && weaponid <= 9)
		            {
		                VehicleInfo[vehicleid][eDoorHealth] = (VehicleInfo[vehicleid][eDoorHealth] - 10 <= 0) ? 0 : VehicleInfo[vehicleid][eDoorHealth] - 10;
		            }
		          	if (weaponid >= 22 && weaponid <= 24)
		            {
		                VehicleInfo[vehicleid][eDoorHealth] = (VehicleInfo[vehicleid][eDoorHealth] - 15 <= 0) ? 0 : VehicleInfo[vehicleid][eDoorHealth] - 15;
		            }
					if (weaponid >= 25 && weaponid <= 34)
		            {
		                VehicleInfo[vehicleid][eDoorHealth] = (VehicleInfo[vehicleid][eDoorHealth] - 30 <= 0) ? 0 : VehicleInfo[vehicleid][eDoorHealth] - 30;
		            }
		        }
		        case LESS_DAMAGE_MELEE:
		        {
					if (weaponid == 0) if (playerHealth > 15.0) SetPlayerHealth(playerid, playerHealth - 5.0);
		          	if (weaponid >= 22 && weaponid <= 24)
		            {
		                VehicleInfo[vehicleid][eDoorHealth] = (VehicleInfo[vehicleid][eDoorHealth] - 5 <= 0) ? 0 : VehicleInfo[vehicleid][eDoorHealth] - 5;
		            }
		          	if (weaponid >= 25 && weaponid <= 34)
		            {
		                VehicleInfo[vehicleid][eDoorHealth] = (VehicleInfo[vehicleid][eDoorHealth] - 20 <= 0) ? 0 : VehicleInfo[vehicleid][eDoorHealth] - 20;
		            }
		        }
		        case BLOCK_PHYSICAL:
		        {
					if (weaponid == 0) if (playerHealth > 15.0) SetPlayerHealth(playerid, playerHealth - 5.0);
		          	if (weaponid >= 25 && weaponid <= 34)
		            {
		                VehicleInfo[vehicleid][eDoorHealth] = (VehicleInfo[vehicleid][eDoorHealth] - 30 <= 0) ? 0 : VehicleInfo[vehicleid][eDoorHealth] - 30;
		            }
		        }
		        default:
		        {
		            if (weaponid == 0)
		            {
		                VehicleInfo[vehicleid][eDoorHealth] = (VehicleInfo[vehicleid][eDoorHealth] - 2 <= 0) ? 0 : VehicleInfo[vehicleid][eDoorHealth] - 2;
		                if (playerHealth > 15.0)
		                {
		                    SetPlayerHealth(playerid, playerHealth - 5.0);
		                }
		            }
		            if (weaponid >= 1 && weaponid <= 9)
		            {
		                VehicleInfo[vehicleid][eDoorHealth] = (VehicleInfo[vehicleid][eDoorHealth] - 10 <= 0) ? 0 : VehicleInfo[vehicleid][eDoorHealth] - 10;
		            }
		          	if (weaponid >= 22 && weaponid <= 24)
		            {
		                VehicleInfo[vehicleid][eDoorHealth] = (VehicleInfo[vehicleid][eDoorHealth] - 15 <= 0) ? 0 : VehicleInfo[vehicleid][eDoorHealth] - 15;
		            }
		          	if (weaponid >= 25 && weaponid <= 34)
		            {
		                VehicleInfo[vehicleid][eDoorHealth] = (VehicleInfo[vehicleid][eDoorHealth] - 30 <= 0) ? 0 : VehicleInfo[vehicleid][eDoorHealth] - 30;
		            }
				}
			}

			new engine, lights, alarm, doors, bonnet, boot, objective, panels, tires;
			GetVehicleDamageStatus(vehicleid, panels, doors, lights, tires);
			switch(VehicleInfo[vehicleid][eDoorHealth])
			{
			
				case 0: UpdateVehicleDamageStatus(vehicleid, panels, encode_doors(0, 0, 4, 0, 0, 0), lights, tires);
				case 1 .. 20: UpdateVehicleDamageStatus(vehicleid, panels, encode_doors(0, 0, 2, 0, 0, 0), lights, tires);
			}

			new doorhealth[12];
			format(doorhealth, 12, "%d%%", VehicleInfo[vehicleid][eDoorHealth]);
			UpdateDynamic3DTextLabelText(VehicleInfo[vehicleid][eVehicleLabel], COLOR_WHITE, doorhealth);

			VehicleInfo[vehicleid][vCooldown] = true;
			SetTimerEx("OnCoolDown", 1000, false, "i", vehicleid);
			
			AlarmOn(vehicleid);

			if (VehicleInfo[vehicleid][eDoorHealth] <= 0)
			{
			    DestroyDynamic3DTextLabel(VehicleInfo[vehicleid][eVehicleLabel]);
			    VehicleInfo[vehicleid][vCooldown] = false;
			    VehicleInfo[vehicleid][ePhysicalAttack] = false;
			    VehicleInfo[vehicleid][eDoorHealth] = 0;
				JackingVehicle[playerid] = 0;

				GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
				SetVehicleParamsEx(vehicleid, engine, lights, alarm, false, bonnet, boot, objective);
				
				ToggleVehicleLock(JackingVehicle[playerid], false);
				PlaySound(playerid, 1145);
				InfoMSG(playerid, "BAN DA ~g~PHA VO~w~ CUA XE!", 3);
				AlarmOn(JackingVehicle[playerid]);
			}
		}
    }

	if (HOLDING(KEY_FIRE) && IsPlayerAttachedObjectSlotUsed(playerid, ATTACH_HANDS) && GetPVarInt(playerid, #use_food) && GetPVarInt(playerid, #time_food) < gettime())
	{
	    SetPVarInt(playerid, #time_food, gettime()+2);
		SetPVarInt(playerid, #use_food, GetPVarInt(playerid, #use_food)-1);
		
		if (GetPVarInt(playerid, #use_food) == 0)
		{
		    DeletePVar(playerid, #use_food);
			RemovePlayerAttachedObject(playerid, ATTACH_HANDS);
		}

		else
		{
			OnPlayAnim(playerid, "FOOD", "EAT_Burger", 4.1,0,1,1,0,0);
		}
		return 1;
	}

    if (HOLDING(KEY_SECONDARY_ATTACK) && IsPlayerAttachedObjectSlotUsed(playerid, ATTACH_HANDS) && GetPVarInt(playerid, #use_food))
	{
	    DeletePVar(playerid, #use_food);
		RemovePlayerAttachedObject(playerid, ATTACH_HANDS);
		return 1;
	}
	
	if (OnAnim{playerid} && HOLDING(KEY_SECONDARY_ATTACK) && GetPlayerAnimationIndex(playerid) && !PlayerInfo[playerid][pInjured])
	{
		StopPlayerAnims(playerid);
	}

    if (HOLDING(KEY_SECONDARY_ATTACK) && GetPVarInt(playerid, #selfie))
	{
        cmd::selfie(playerid, "");
	}

    if (((PRESSING(newkeys, KEY_SPRINT) || PRESSING(newkeys, KEY_JUMP)) || (HOLDING(KEY_SPRINT) || HOLDING(KEY_JUMP))) && pTemp[playerid][pInjuredLegTime])
	{
		TogglePlayerControllable(playerid,0);
		StopPlayerAnims(playerid);
		TogglePlayerControllable(playerid,1);

		if (PRESSED(KEY_SPRINT) || HOLDING(KEY_SPRINT))	ApplyAnimation(playerid, "PED", "FALL_collapse", 4.1, 0, 1, 1, 0, 0);
		else if (PRESSED(KEY_JUMP)|| HOLDING(KEY_JUMP))	ApplyAnimation(playerid, "PED", "getup_front", 4.0, 0, 0, 0, 0, 0);
	}

	if (HOLDING(KEY_SECONDARY_ATTACK) && pTemp[playerid][p3DMenu] != -1)
	{
    	Destroy3DMenu(pTemp[playerid][p3DMenu]);
		pTemp[playerid][p3DMenu] = -1;
		
		SetTimerEx("ShowEditFurniture", 1000, false, "i", playerid);
		return 1;
	}

	if (PRESSED(KEY_CTRL_BACK))
	{
		if (GetPlayerState(playerid) == PLAYER_STATE_ONFOOT){
			if (pTemp[playerid][pCargoID] != 0)
			{
				if (GetNearBootVehicle(playerid) == 0) 	return cmd::cargo(playerid, "putdown");
				else 									return cmd::cargo(playerid, "place");
			}
			else if (IsPlayerNearCargo(playerid) != -1) 	return cmd::cargo(playerid, "pickup");

			if (ATM_Nearest(playerid) != -1) 		cmd::atm(playerid, "");
			if (Payphone_Nearest(playerid) != -1) 	cmd::payphone(playerid, "");
			if (GetNearestCorpse(playerid) != -1)	cmd::corpse(playerid, "");
			if (BoomboxInfo[playerid][bUsed] != 0)	ShowBoomboxMenu(playerid);

			if (Trash_Nearest(playerid, 1.5) != -1 && PlayerInfo[playerid][pJob] == JOB_TRASHMASTER && pTemp[playerid][pJob]) 
				cmd::pickuptrash(playerid, "");
			
			if (AntiCheatGetSpecialAction(playerid) == SPECIAL_ACTION_DUCK) { 
				if (ItemDrop_Nearest(playerid) != -1) cmd::pickupitem(playerid, "");
				if (MixDrop_Nearest(playerid) != -1) cmd::pickupmix(playerid, "");
			}
			
			if (IsPlayerAroundShell(playerid))	return cmd::shell(playerid, "");
		}
	}

	if (RELEASED(KEY_SECONDARY_ATTACK) && !IsPlayerInAnyVehicle(playerid)) {
		if (!(PlayerInfo[playerid][pSettings] & togEnter))
		{
			cmd::enter(playerid, "");
	    	cmd::exit(playerid, "");
		}
	    if (TruckCargo_Nearest(playerid, 1.5) != -1)
		{
			if (pTemp[playerid][pCargoID] == 0)
				cmd::industry(playerid, "");
			else cmd::cargo(playerid, "sell");
		}
		if(Vending_Nearest(playerid) != -1)
		{
			new id = Vending_Nearest(playerid);
			if(VendingInfo[id][vendingType] == 1)
			{
				if (GetCash(playerid) < 8)						return SendNotCash(playerid);
				if (GiveInvItem(playerid, INV_HOTDOG, 1) == -1)	return SendErrorMessage(playerid, "Tui do da day.");
				GiveCash(playerid, -8);
				VendingInfo[id][vendingVault] += 8;	
				ApplyAnimation(playerid, "VENDING", "VEND_Use", 2.0, 0, 0, 1, 0, 0, 1);
				SQL_SetInteger("vendingmachines", "vault", VendingInfo[id][vendingVault], VendingInfo[id][vendingID]);
			}
			if(VendingInfo[id][vendingType] == 2)
			{
				if (GetCash(playerid) < 5)						return SendNotCash(playerid);
				if (GiveInvItem(playerid, INV_SODA, 1) == -1)	return SendErrorMessage(playerid, "Tui do da day.");
				GiveCash(playerid, -5);
				VendingInfo[id][vendingVault] += 5;	
				ApplyAnimation(playerid, "VENDING", "VEND_Use", 2.0, 0, 0, 1, 0, 0, 1);
				SQL_SetInteger("vendingmachines", "vault", VendingInfo[id][vendingVault], VendingInfo[id][vendingID]);
			}
			
		}
		if (Job_Nearest(playerid) != -1) cmd::takejob(playerid, "");		
	}

	if (HOLDING(KEY_CROUCH) && IsPlayerInAnyVehicle(playerid))
	{
	    cmd::open(playerid, "");

		cmd::enter(playerid, "");
	    cmd::exit(playerid, "");

		if (Toll_Nearest(playerid) != -1) 	cmd::opentoll(playerid, "");
		if (AZC_Nearest(playerid) != -1)	cmd::fill(playerid, "");

	    return 1;
	}

	if (HOLDING(KEY_LOOK_BEHIND) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{	
		cmd::vfa(playerid, "");
		return 1;
	}

	if (HOLDING(KEY_CTRL_BACK) && !IsPlayerInAnyVehicle(playerid) && pTemp[playerid][p3DMenu] != -1)
	{
	    UpdateIntVar(playerid, "chose_texture", 1);
	    
		if (GetPVarInt(playerid, "chose_texture") > 4) SetPVarInt(playerid, "chose_texture", 0);

		new mes[32];
		format(mes, sizeof(mes), "~y~Ban da thay doi ket cau: ~w~%i", GetPVarInt(playerid, "chose_texture")+1);
		InfoMSG(playerid, mes, 4);
		return 1;
	}

	/*if (PRESSED(KEY_CTRL_BACK))
	{
	    
	}*/

	if (HOLDING(KEY_NO))
	{
		if (GetPlayerDeniedAction(playerid) != 0) return 1;
		if (GetPVarInt(playerid, "edit_furniture") != 1) cmd::inventory(playerid, "");
		if (HasTrash[playerid]) Trash_ResetPlayer(playerid);
	}

	if (HOLDING(KEY_YES))
	{
	    GetPlayerAcceptAction(playerid);
		/*if (!IsPlayerUseMDC(playerid))
		{
			cmd::phone(playerid, "");
		}  
		else
		{
			cmd::phonecursor(playerid, "");
		}*/						
	}

	if (pTemp[playerid][pFoodStand] != 0 && (PRESSED(KEY_JUMP) || PRESSED(KEY_FIRE) || PRESSED(KEY_CROUCH)))
	{

		OnPlayAnim(playerid,"PED","IDLE_tired",4.1,0,1,1,0,1);
		RemovePlayerAttachedObject(playerid, ATTACH_HANDS);
		pTemp[playerid][pFoodStand] = 0;
		SetPlayerChatBubble(playerid, "tha mot cai khay voi mot don hang.", COLOR_PURPLE, 20.0, 4000);
	}

	if (PRESSED(KEY_FIRE) && RepairService[playerid] != 0 && RepairOffer[playerid] != INVALID_PLAYER_ID && RepairToVehicle[playerid] != INVALID_VEHICLE_ID)
	{
		if (GetNearVehicle(playerid, 4.2, RepairToVehicle[playerid]) == 0)	ShowJobMessage(playerid, "~h~~p~BAN PHAI DUNG GAN XE.");
		else
		{
			RepairOffer[playerid] = INVALID_PLAYER_ID;
			RepairTime[playerid] = 15;
		}
	}
    return 1;
}