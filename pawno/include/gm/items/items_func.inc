this::OnPlayerUseItem(playerid, slotid) //�������������
{
    if (PlayerInfo[playerid][pInjured] != 0 || GetPVarInt(playerid, "Freeze") || pTemp[playerid][pTaserTime] || pTemp[playerid][pCuffed]) 
        return SendErrorMessage(playerid, "Ban khong the su dung tui do ngay bay gio.");
    if (slotid < 0 || slotid > MAX_INV_SLOTS-1) return 1; 
    
    new itemid = Inventory[playerid][slotid][pInvItem];
	
    switch(itemid)
    {
        case INV_SIGN: cmd::carsign(playerid, "");
        case INV_HEAL:
        {
            if (!PlayerInfo[playerid][pInjured])                return SendErrorMessage(playerid, "Khong co trong giai doan vet thuong / tu vong.");
            if (GetPVarInt(playerid, #heal_time) > gettime())   return SendErrorMessage(playerid, "Co the su dung moi phut mot lan.");

            new Float:health;
            AntiCheatGetHealth(playerid, health);

            if (health >= 100.0) return SendErrorMessage(playerid, "Ban co day du suc khoe.");
            
            if (health + 15.0 > 100.0)   SetPlayerHealth(playerid, 100.0);
            else                        SetPlayerHealth(playerid, health + 100.0);
            
            
            SetPVarInt(playerid, #heal_time, gettime() + 60);
            Inventory[playerid][slotid][pInvQ]--;
            if (!Inventory[playerid][slotid][pInvQ]) Inventory[playerid][slotid][pInvItem] = 0;
        }

        case INV_GANJA, INV_MED_GANJA, INV_DRUG: {
            if (pTemp[playerid][pDrugTime]) return SendErrorMessage(playerid, "Ban da su dung ma tuy gan day.");
            UseDrug(playerid, itemid, slotid);
        }

        case INV_BOOMBOX:   PlaceBoombox(playerid);
        case INV_RADIO:
        {
            new mes[550] = "/r - noi chuyen vao radio.\n";
            strcat (mes, "/rr - talk on the radio into the slot.\n");
            strcat (mes, "/(rl) ow - speak into the radio in a half-whisper.\n");
            strcat (mes, "/(rrl) ow - speak into the radio in a half-whisper into the slot.\n");
            strcat (mes, "/auth - log in to the radio wave channel.\n");
            strcat (mes, "/(ch) annel set - change the radio channel.\n");
            strcat (mes, "/(ch) annel rent - change the radio channel.\n");
            strcat (mes, "/setslot - change radio slot.\n");
            strcat (mes, "/(ch) annel leave - leave the radio wave.\n");
            strcat (mes, "/(ch) annel sell - sell the radio wave. (50% will be returned)\n");
            strcat (mes, "/newauth - change channel password.\n");
            strcat (mes, "/kickoffradio - kick from the channel.\n");
            strcat (mes, "/radiomembers - members of the radio wave.");
            Dialog_Show(playerid, None, DIALOG_STYLE_MSGBOX, "Radio Help", mes, "X", "");
        }
        case INV_MASK:      cmd::mask(playerid, "");
        case INV_LIGHTER:   SendHelpMessage(playerid, "Su dung thuoc la trong tui do.");
        case INV_CIGAR:
        {
            if (!IsPlayerHasItem(playerid, INV_LIGHTER))                 return SendErrorMessage(playerid, "Ban khong co bat lua.");
            if (IsPlayerAttachedObjectSlotUsed(playerid, ATTACH_HANDS))  return SendWarningMessage(playerid, "Tay ban dang cam mot vat pham ( Bam N ( inventory ) sau do cat vat pham ).");
            
            Inventory[playerid][slotid][pInvQ]--;
            
            if (Inventory[playerid][slotid][pInvQ] == 0) Inventory[playerid][slotid][pInvItem] = 0;
            
            cmd::server_ame(playerid, "lay mot dieu thuoc ra khoi bao thuoc, va cham no vao bat lua.");
            SetPlayerSpecialAction(playerid, SPECIAL_ACTION_SMOKE_CIGGY);
            SM2(playerid, "Ban dang dot mot dieu thuoc.");

            InfoMSG(playerid, "NHAN \" ~g~LKM ~w~\" de ~y~su dung ~w~object~n~NHAN\" ~r~ENTER ~w~\" de ~y~xoa ~w~object.", 5);

        }
        case INV_DICE:      SendNearbyMessage(Range_Normal, playerid, COLOR_WHITE, "* %s tung xuc xac va roi ra %i.", GetNameWithMask(playerid), random(6)+1);
        case INV_PEN:       cmd::note(playerid, "");
        case INV_SILENCER:  cmd::silencer(playerid, "");
        case INV_OPTICS:    cmd::optics(playerid, "");
        case INV_GASCAN:
        {
            if (IsPlayerInAnyVehicle(playerid)) return SendErrorMessage(playerid,"Ban phai ra khoi xe.");
            
            new vehicle;

            if ((vehicle = GetNearVehicle(playerid, 2.5)) == 0) return SendErrorMessage(playerid, "Khong co phuong tien nao gan ban.");
            if (VehicleInfo[vehicle][carFuel] + 20.0 > GetVehicleFuelCapacity(GetVehicleModel(vehicle))) return SendErrorMessage(playerid, "Xang phuong tien da day.");

            VehicleInfo[vehicle][carFuel] += 20.0;
            SM2(playerid, "Phuong tien cua ban dang nap xang tu thung xang.");
            cmd::me(playerid, "nap xang tu chiec thung xang.");
            Inventory[playerid][slotid][pInvQ]--;
            if (Inventory[playerid][slotid][pInvQ] == 0) Inventory[playerid][slotid][pInvItem] = 0;
        }
        case INV_BURGER:
        {
            if (IsPlayerAttachedObjectSlotUsed(playerid, ATTACH_HANDS)) return SendWarningMessage(playerid, "Tay ban dang cam mot vat pham ( Bam N ( inventory ) sau do cat vat pham ).");
            InfoMSG(playerid, "NHAN \" ~g~LKM ~w~\" de ~y~su dung ~w~object~n~NHAN\" ~r~ENTER ~w~\" de ~y~xoa ~w~object.", 5);
            
            new Float:health;
            AntiCheatGetHealth(playerid, health);

            if (health + 10 > 100.0) SetPlayerHealth(playerid, 100.0);
            else                    SetPlayerHealth(playerid, health + 10.0);
            
            SetPVarInt(playerid, #use_food, 5);
            SetPVarInt(playerid, #time_food, gettime());
            SetPlayerAttachedObject(playerid, ATTACH_HANDS, 2703, 6, 0.055999, 0.028000, 0.008000, 2.599998, 0.000000, 16.599998, 0.844000, 0.871000, 0.870000);
            RemovePlayerItem(playerid, INV_BURGER, 1);
            cmd::server_ame(playerid, "eating a burger.");
        }
        case INV_PIZZA:
        {
            if (IsPlayerAttachedObjectSlotUsed(playerid, ATTACH_HANDS)) return SendWarningMessage(playerid, "Tay ban dang cam mot vat pham ( Bam N ( inventory ) sau do cat vat pham ).");
            InfoMSG(playerid, "NHAN \" ~g~LKM ~w~\" de ~y~su dung ~w~object~n~NHAN\" ~r~ENTER ~w~\" de ~y~xoa ~w~object.", 5);
            
            new Float:health;
            AntiCheatGetHealth(playerid, health);

            if (health + 15.0 > 100.0) SetPlayerHealth(playerid, 100.0);
            else                       SetPlayerHealth(playerid, health + 15.0);

            SetPVarInt(playerid, #use_food, 5);
            SetPVarInt(playerid, #time_food, gettime());
            SetPlayerAttachedObject(playerid, ATTACH_HANDS, 2703, 6, 0.055999, 0.028000, 0.008000, 2.599998, 0.000000, 16.599998, 0.844000, 0.871000, 0.870000);
            RemovePlayerItem(playerid, INV_PIZZA, 1);
            cmd::server_ame(playerid, "an pizza.");
        }
        case INV_CHICKEN:
        {
            if (IsPlayerAttachedObjectSlotUsed(playerid, ATTACH_HANDS)) return SendWarningMessage(playerid, "Tay ban dang cam mot vat pham ( Bam N ( inventory ) sau do cat vat pham ).");

            InfoMSG(playerid, "NHAN \" ~g~LKM ~w~\" de ~y~su dung ~w~object~n~NHAN\" ~r~ENTER ~w~\" de ~y~xoa ~w~object.", 5);
            
            new Float:health;
            AntiCheatGetHealth(playerid, health);

            if (health + 7.0 > 100.0) SetPlayerHealth(playerid, 100.0);
            else                      SetPlayerHealth(playerid, health + 7.0);
            

            SetPVarInt(playerid, #use_food, 5);
            SetPVarInt(playerid, #time_food, gettime());
            SetPlayerAttachedObject(playerid, ATTACH_HANDS, 2703, 6, 0.055999, 0.028000, 0.008000, 2.599998, 0.000000, 16.599998, 0.844000, 0.871000, 0.870000);
            RemovePlayerItem(playerid, INV_CHICKEN, 1);
            cmd::server_ame(playerid, "an ga.");
        }
        case INV_HOTDOG:
        {
            if (IsPlayerAttachedObjectSlotUsed(playerid, ATTACH_HANDS)) return SendWarningMessage(playerid, "Tay ban dang cam mot vat pham ( Bam N ( inventory ) sau do cat vat pham ).");

            InfoMSG(playerid, "NHAN \" ~g~LKM ~w~\" de ~y~su dung ~w~object~n~NHAN\" ~r~ENTER ~w~\" de ~y~xoa ~w~object.", 5);
            
            new Float:health;
            AntiCheatGetHealth(playerid, health);

            if (health + 5.0 > 100.0)    SetPlayerHealth(playerid, 100.0);
            else                        SetPlayerHealth(playerid, health + 5.0);
            

            SetPVarInt(playerid, #use_food, 5);
		    SetPVarInt(playerid, #time_food, gettime());
		    SetPlayerAttachedObject(playerid, ATTACH_HANDS, 2703, 6, 0.055999, 0.028000, 0.008000, 2.599998, 0.000000, 16.599998, 0.844000, 0.871000, 0.870000);
            RemovePlayerItem(playerid, INV_HOTDOG, 1);
            cmd::server_ame(playerid, "an hot-dog.");
        }
        case INV_WATER, INV_SODA, INV_COLA:
        {
            if (IsPlayerAttachedObjectSlotUsed(playerid, ATTACH_HANDS)) return SendWarningMessage(playerid, "Tay ban dang cam mot vat pham ( Bam N ( inventory ) sau do cat vat pham ).");

            InfoMSG(playerid, "NHAN \" ~g~LKM ~w~\" de ~y~su dung ~w~object~n~NHAN\" ~r~ENTER ~w~\" de ~y~xoa ~w~object.", 5);
            SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_SPRUNK);
            RemovePlayerItem(playerid, itemid, 1);

            if (itemid == INV_WATER)     cmd::server_ame(playerid, "uong.");
            else if (itemid == INV_SODA) cmd::server_ame(playerid, "uong soda.");
            else if (itemid == INV_COLA) cmd::server_ame(playerid, "uong cola.");
        }
        case INV_BEER:
        {
            if (IsPlayerAttachedObjectSlotUsed(playerid, ATTACH_HANDS)) return SendWarningMessage(playerid, "Tay ban dang cam mot vat pham ( Bam N ( inventory ) sau do cat vat pham ).");

            InfoMSG(playerid, "NHAN \" ~g~LKM ~w~\" de ~y~su dung ~w~object~n~NHAN\" ~r~ENTER ~w~\" de ~y~xoa ~w~object.", 5);
            SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_BEER);
            RemovePlayerItem(playerid, itemid, 1);
            cmd::server_ame(playerid, "drinking beer.");
        }
        case INV_VODKA, INV_WHISKEY, INV_BRANDY, INV_WINE:
        {
            if (IsPlayerAttachedObjectSlotUsed(playerid, ATTACH_HANDS)) return SendWarningMessage(playerid, "Tay ban dang cam mot vat pham ( Bam N ( inventory ) sau do cat vat pham ).");

            InfoMSG(playerid, "NHAN \" ~g~LKM ~w~\" de ~y~su dung ~w~object~n~NHAN\" ~r~ENTER ~w~\" de ~y~xoa ~w~object.", 5);
            SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_WINE);
            RemovePlayerItem(playerid, itemid, 1);

            if (itemid == INV_VODKA)         cmd::server_ame(playerid, "uong vodka.");
            else if (itemid == INV_WHISKEY)  cmd::server_ame(playerid, "uong whiskey.");
            else if (itemid == INV_BRANDY)   cmd::server_ame(playerid, "uong brandy.");
            else                             cmd::server_ame(playerid, "uong ruou.");
        }
        case INV_PICKLOCK: cmd::hbreaklock(playerid, "");
        case INV_CARSOUND:
        {
            new vehicle = GetPlayerVehicleID(playerid);

            if (vehicle == 0) return SendSyntaxMessage(playerid, "Ban co the lap may ghi am trong xe hoac ban o tiem cam do (( /sell ))");
            if (VehicleInfo[vehicle][carOwnerID] == 0)    return SendErrorMessage(playerid, "May ghi am vo tuyen chi co the duoc lap dat trong xe ca nhan.");
            if (VehicleInfo[vehicle][carRadio] == 1)      return SendErrorMessage(playerid, "Mot may ghi am vo tuyen da duoc lap trong chiec xe nay.");
            if (!IsPlayerHasItem(playerid, INV_CARSOUND)) return SendErrorMessage(playerid, "Ban khong co may ghi am radio.");

            new mes[128];
            format(mes, sizeof(mes), "cai dat radio vao %s.", VehicleNames[GetVehicleModel(vehicle)-400]);
            cmd::me(playerid, mes);
            RemovePlayerItem(playerid, itemid, 1);
            VehicleInfo[vehicle][carRadio] = 1;
        }
        case INV_SKATE: cmd::skate(playerid, "");

        case 1 .. 18, 22 .. 34, 41 .. 43, 46: // WEAPONS
        {
            if (PlayerInfo[playerid][pPlayerWeapon] != 0)                        cmd::putgun(playerid, "");
            if (IsPlayerAttachedObjectSlotUsed(playerid, ATTACH_HANDS))	         return SendWarningMessage(playerid, "Tay ban dang cam mot vat pham ( Bam N ( inventory ) sau do cat vat pham ).");
            if (PlayerInfo[playerid][pJailed] || PlayerInfo[playerid][pAJailed]) return SendErrorMessage(playerid, "Ban khong the su dung tinh nang nay ngay bay gio.");

            PlayerInfo[playerid][pPlayerWeapon] = Inventory[playerid][slotid][pInvItem];
            PlayerInfo[playerid][pPlayerAmmo]   = Inventory[playerid][slotid][pInvQ];
            PlayerInfo[playerid][pAmmoType]     = Inventory[playerid][slotid][pInvEx];
            PlayerInfo[playerid][pWepSerial]    = Inventory[playerid][slotid][pInvS];

            GivePlayerWeaponEx(playerid, Inventory[playerid][slotid][pInvItem], Inventory[playerid][slotid][pInvQ], Inventory[playerid][slotid][pInvEx], Inventory[playerid][slotid][pInvS]);
            
            SM2(playerid, "Ban da lay %s tu tui do.", inventory_items[Inventory[playerid][slotid][pInvItem]][itemName]);

            new mes[64];
            if (PlayerInfo[playerid][pPlayerWeapon] >= 22 && PlayerInfo[playerid][pPlayerWeapon] <= 34)  format(mes, sizeof(mes), "* %s rut vu khi ra.", GetNameEx(playerid), inventory_items[Inventory[playerid][slotid][pInvItem]][itemName]);
            else                                                                                        format(mes, sizeof(mes), "* %s lay %s.", GetNameEx(playerid), inventory_items[Inventory[playerid][slotid][pInvItem]][itemName]);
            SetPlayerChatBubble(playerid, mes, COLOR_PURPLE, 20.0, 4000);
            
            RemoveInvItem(playerid, Inventory[playerid][slotid][pInvItem], 0, slotid);
        }
        case 82 .. 99:
        {
            if (PlayerInfo[playerid][pPlayerWeapon] != 0 && PlayerInfo[playerid][pPlayerAmmo] != 0)
            {
                SendErrorMessage(playerid, "Vu khi cua ban da duoc nap dan.");
                return PrintInv(playerid);
            }
            if (PlayerInfo[playerid][pPlayerWeapon] == 0)
            {
                SendErrorMessage(playerid, "Ban khong co vu khi trong tay. ");
                return PrintInv(playerid);
            }
            if (CompatAmmo(PlayerInfo[playerid][pPlayerWeapon], itemid) == 0)
            {
                SendErrorMessage(playerid, "Nhung hop dan nay khong phu hop voi vu khi cua ban. ");
                return PrintInv(playerid);
            }

            PlayerInfo[playerid][pAmmoType] = itemid;
            PlayerInfo[playerid][pPlayerAmmo] = Inventory[playerid][slotid][pInvQ];

            GivePlayerWeaponEx(playerid, PlayerInfo[playerid][pPlayerWeapon], PlayerInfo[playerid][pPlayerAmmo], PlayerInfo[playerid][pAmmoType], PlayerInfo[playerid][pWepSerial]);
            
            SM1(playerid, "Ban da nap dan %s - %s (%i round).", inventory_items[PlayerInfo[playerid][pPlayerWeapon]][itemName], inventory_items[PlayerInfo[playerid][pAmmoType]][itemName], PlayerInfo[playerid][pPlayerAmmo]);

            new mes[64];
            format(mes, sizeof(mes), "* %s nap dan %s", GetNameEx(playerid), inventory_items[PlayerInfo[playerid][pPlayerWeapon]][itemName]);
            SetPlayerChatBubble(playerid, mes, COLOR_PURPLE, 30.0, 10000);
            
            RemoveInvItem(playerid, itemid, 0, slotid);
            
            ApplyAnimation(playerid, "SILENCED", "Silence_reload", 3.0, 0, 0, 0, 0, 0);
        }
	}
	return 1;
}

IsPlayerHasItem(playerid, itemid, amount = 0)
{
	if (!IsPlayerLogged(playerid) || !itemid) return 0;
    
    new result = -1;
	for(new i = 0; i != MAX_INV_SLOTS; i++)
	{
	    if (amount > 0 && Inventory[playerid][i][pInvItem] == itemid && Inventory[playerid][i][pInvQ] >= amount) 
        { 
            result = i;
            break; 
        }  
	    else if (amount < 1 && Inventory[playerid][i][pInvItem] == itemid) 
        {
            result = i;
            break; 
        }
	}

    if (result == -1) return 0;
    else return 1;
}

RemovePlayerItem(playerid, itemid, amount = -1)
{
    for(new i; i != MAX_INV_SLOTS; i++)
	{
	    if (Inventory[playerid][i][pInvItem] != itemid) continue;

	    if (amount == -1)
	    {
	        Inventory[playerid][i][pInvItem] = 0;
	        Inventory[playerid][i][pInvQ] = 0;
			return 1;
		}

	    Inventory[playerid][i][pInvQ] -= amount;

		if (Inventory[playerid][i][pInvQ] < 1)
		{
		    Inventory[playerid][i][pInvItem] = 0;
	        Inventory[playerid][i][pInvQ] = 0;
  		}
		return 1;
	}
	return 0;
}

this::LoadHolsters(playerid)
{
	/*if (GetPVarInt(playerid, "Backpack") == 1) 
    {
		if (IsPlayerAttachedObjectSlotUsed(playerid, 7)) RemovePlayerAttachedObject(playerid, 6);
		SetPlayerAttachedObject(playerid, 6, 371, 1, 0.0, -0.14, 0.0, 0.0, 90, 359.5022, 1, 1, 1);
		return 1;
	}*/

    new count;
    for(new w = 0; w < MAX_WEAP-1; w++)
    {
        count = -1;
        for(new p = count+1; p < MAX_INV_SLOTS-1; p++)
        {
            if (inventory_items[Inventory[playerid][p][pInvItem]][itemType] == ITEM_TYPE_WEAPON)
            {
                if (GetWeaponType(Inventory[playerid][p][pInvItem]) == w)
                {
                    count = p;
                    break;
                }
            }
        }
        if (count != -1)
        {
            if (IsPlayerAttachedObjectSlotUsed(playerid, w + 5))
                RemovePlayerAttachedObject(playerid, w + 5);

            if (0 == PlayerInfo[playerid][pHideWeap][w] && !IsPlayerAttachedObjectSlotUsed(playerid, w + 5))
            {
                SetPlayerAttachedObject(playerid, w + 5, 
                    inventory_items[Inventory[playerid][count][pInvItem]][itemModel], 
                    PlayerInfo[playerid][pWeaponBone][w], 
                    PlayerInfo[playerid][pWeaponX][w], 
                    PlayerInfo[playerid][pWeaponY][w], 
                    PlayerInfo[playerid][pWeaponZ][w], 
                    PlayerInfo[playerid][pWeaponRX][w], 
                    PlayerInfo[playerid][pWeaponRY][w], 
                    PlayerInfo[playerid][pWeaponRZ][w], 
                    1.0, 1.0, 1.0);
                //SM1(playerid, "[slot: %i]: %s [item id: %i]", w, inventory_items[PlayerInfo[playerid][pInvItem][count]][itemName], count+1);
            }
        }
        else 
        {
            if (IsPlayerAttachedObjectSlotUsed(playerid, w + 5)) RemovePlayerAttachedObject(playerid, w + 5);
        }
    }

	return 1;
}

GetWeaponType(weaponid)
{
    switch(weaponid)
    {
        case 2,3,5,6,7,8,15:    return 0; //WEAPON_TYPE_HAND
        case 22,23,24,28,29,32: return 1; //WEAPON_TYPE_SEC
        case 25,26,30,31,33,34: return 2; //WEAPON_TYPE_PRIM
    }
    return -1;
}
    
