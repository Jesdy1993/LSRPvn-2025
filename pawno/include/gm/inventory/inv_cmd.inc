ALTX:inventory("/inv");
CMD:inventory(playerid, params[])
{
	DeletePVar(playerid, #inventory_house);
    DeletePVar(playerid, #inventory_vehicle);
	
    if (PlayerInfo[playerid][pInjured] != 0 || GetPVarInt(playerid, "Freeze") || pTemp[playerid][pTaserTime] || pTemp[playerid][pCuffed])	return SendErrorMessage(playerid, "Ban khong the su dung tui do ngay bay gio.");
	
	if (GetPVarInt(playerid, #pDelay)) return 1;

	new	
		count,
		diatxt[64] = "Tui do nhan vat"
	;
	
	new houseid;
	if ((houseid = GetNearHouse(playerid)) != -1 && HouseInfo[houseid][hOwnerID] == PlayerInfo[playerid][pID] && PlayerToPoint(1, playerid,HouseInfo[houseid][hCheckPosX], HouseInfo[houseid][hCheckPosY], HouseInfo[houseid][hCheckPosZ]))
	{
		format(diatxt, sizeof(diatxt), "%s\nHome inventory", diatxt);
		count++;
	}

	new vehicle = GetNearVehicle(playerid, 4.0);
	if (vehicle != 0 && (!IsADontTrunk(vehicle) || !IsAPlane(vehicle) || !IsABiker(vehicle) || !IsAHelicopter(vehicle) || !IsABoat(vehicle) || !IsABicycle(vehicle)))
	{
		if ((VehicleInfo[vehicle][carTrunkLock] && !IsPlayerInAnyVehicle(playerid)) || (IsPlayerInAnyVehicle(playerid) && VehicleInfo[vehicle][carFaction] && VehicleInfo[vehicle][carFaction] == PlayerInfo[playerid][pFaction]))
		{
			if (VehicleInfo[vehicle][carFaction] && VehicleInfo[vehicle][carFaction] == PlayerInfo[playerid][pFaction]) format(diatxt, sizeof(diatxt), "%s\nMount inventory", diatxt);
			else 																										format(diatxt, sizeof(diatxt), "%s\nTrunk inventory", diatxt);
			count++;
		}
	}
	
	vehicle = GetPlayerVehicleID(playerid);
	if (IsPlayerInAnyVehicle(playerid) && vehicle != 0 && GetPlayerHasRightDrive(playerid, vehicle))
	{
		format(diatxt, sizeof(diatxt), "%s\nGlove box inventory", diatxt);
		count++;
	}

	if (count)	Dialog_Show(playerid, InventoryMenu, DIALOG_STYLE_LIST, "Inventory selection:", diatxt, "Lua chon", "Huy bo");
	else		PrintInv(playerid);

 	return 1;
}

CMD:put(playerid, params[])
{
	if (!IsPlayerAttachedObjectSlotUsed(playerid, ATTACH_HANDS))	return SendWarningMessage(playerid, "Ban khong co gi trong tay. ");
	if (!GetPVarInt(playerid, #attach_item))						return SendErrorMessage(playerid, "Voi lenh nay, ban chi co the xoa mot so vat pham nhat dinh khoi kho! ");

	RemovePlayerAttachedObject(playerid, ATTACH_HANDS);
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	SetPVarInt(playerid, #attach_item, 0);

	if (GiveInvItem(playerid, pTemp[playerid][tempItem], pTemp[playerid][tempQ], pTemp[playerid][tempEx]) == -1) return SendErrorMessage(playerid, "Tui do da day.");

	pTemp[playerid][tempItem] = 0;
	pTemp[playerid][tempEx] = 0;
	pTemp[playerid][tempQ] = 0;
			
	SendSyntaxMessage(playerid, "Ban da cat mot vat pham khoi tay ban. ");
	return 1;
}

PrintInv(playerid)
{
	new result[(MAX_INV_SLOTS+5) * 128] = "#\tVat pham\tSo luong"; //{ffffff}
	if (GetPVarInt(playerid, #pDelay)) return PrintInv(playerid);

	FixInv(playerid);
    for(new i = 0; i < MAX_INV_SLOTS; i++) {
		switch(Inventory[playerid][i][pInvItem])
		{
			case 0:
			{
				format(result, sizeof(result), "%s\n{ffffff}%i.\t{C3C3C3}Slot trong", result, i+1);
			}
			case 22 .. 34:
			{
				if (Inventory[playerid][i][pInvQ] == 0) format(result, sizeof(result), "%s\n{ffffff}%i.\t%s {C3C3C3}[trong]\t1", result, i+1, inventory_items[Inventory[playerid][i][pInvItem]][itemName]); 
				else 									format(result, sizeof(result), "%s\n{ffffff}%i.\t%s {C3C3C3}[%s / %i round]{FFFFFF}\t1", result, i+1, inventory_items[Inventory[playerid][i][pInvItem]][itemName], inventory_items[Inventory[playerid][i][pInvEx]][itemName], Inventory[playerid][i][pInvQ]); 
			}

			case 78, 79:
			{
				if (Inventory[playerid][i][pInvEx] == 0) format(result, sizeof(result), "%s\n{ffffff}%i.\t%s {C3C3C3}[trong]\t1", result, i+1, inventory_items[Inventory[playerid][i][pInvItem]][itemName]); 
				else 									 format(result, sizeof(result), "%s\n{ffffff}%i.\t%s {C3C3C3}[%s / %f]{FFFFFF}\t1", result, i+1, inventory_items[Inventory[playerid][i][pInvItem]][itemName], inventory_items[Inventory[playerid][i][pInvEx]][itemName], Inventory[playerid][i][pInvQFloat]); 
			}
			
			case INV_GANJA, INV_MED_GANJA, 103 .. 118:
			{
				format(result, sizeof(result), "%s\n{ffffff}%i.\t%s{FFFFFF}\t%.1fg", result, i+1, inventory_items[Inventory[playerid][i][pInvItem]][itemName], Inventory[playerid][i][pInvQFloat]);
			}
			case INV_DRUG:
			{
				format(result, sizeof(result), "%s\n{ffffff}%i.\t%s {C3C3C3}[OAS: %i%%]{FFFFFF}\t%.1fg", result, i+1, Inventory[playerid][i][pInvName], Inventory[playerid][i][pInvEx], Inventory[playerid][i][pInvQFloat]);
			}
			case INV_GASCAN: 
			{
				format(result, sizeof(result), "%s\n{ffffff}%i.\t%s {33FF66}(20L)\t1", result, i+1, inventory_items[Inventory[playerid][i][pInvItem]][itemName]);
			}
			/*case 103 .. 114:
			{
				format(result, sizeof(result), "%s\n{ffffff}%i.\t%s {}[OAS: %i]{FFFFFF}\t%.1fg", result, i+1, inventory_items[Inventory[playerid][i][pInvItem]][itemName], PlayerInfo[playerid][pInvQFloat][i]);
			}*/

			/*case 103 .. 114:
			{
				format(result, sizeof(result), "%s\n{ffffff}%i.\t%s {C3C3C3}Loai: %s]{FFFFFF}\t%.1fg", result, i+1, inventory_items[Inventory[playerid][i][pInvItem]][itemName], PlayerInfo[playerid][pInvQFloat][i]);
			}*/


			/*case FISHING_LOWEST_ID .. FISHING_HIGHEST_ID:
			{
				format(result, sizeof(result), "%s\n{FFFFFF}%s (%dlbs)", result, PrintIName(PlayerInfo[playerid][pInvItem][i]), PlayerInfo[playerid][pInvEx][i]);
			}
			case INV_GASCAN:
			{
				//if (PlayerInfo[playerid][pInvQ][i] > 0) 
				format(result, sizeof(result), "%s\n{ffffff}%i.\t%s {33FF66}(20L)", result, i+1, inventory_items[Inventory[playerid][i][pInvItem]][itemName]);//, PlayerInfo[playerid][pInvEx][i], PlayerInfo[playerid][pInvQ][i]);//FuelName(PlayerInfo[playerid][pInvEx][i]), PlayerInfo[playerid][pInvQ][i]);
				//else 									format(result, sizeof(result), "%s\n{ffffff}%i.\t%s [{C3C3C3}������{FFFFFF}]", result, i+1, inventory_items[Inventory[playerid][i][pInvItem]][itemName]);
			}
			*/
			
			default:
			{
				format(result, sizeof(result), "%s\n{ffffff}%i.\t%s\t%i", result, i+1, inventory_items[Inventory[playerid][i][pInvItem]][itemName], Inventory[playerid][i][pInvQ]);
			}
	    }
	}

	if (PlayerInfo[playerid][pPlayerWeapon] >= 1) 
	{
		format(result, sizeof(result), "%s\n{ffffff}%i.\t{FF6347}> {FFFFFF}CAT VU KHI", result, MAX_INV_SLOTS+1);
		format(result, sizeof(result), "%s\n{ffffff}%i.\t{FF6347}> {FFFFFF}VUT VU KHI", result, MAX_INV_SLOTS+2);
		
		if (PlayerInfo[playerid][pPlayerWeapon] >= 22 && PlayerInfo[playerid][pPlayerWeapon] <= 34)
		{
			if (PlayerInfo[playerid][pPlayerAmmo] > 0) 
				format(result, sizeof(result), "%s\n{ffffff}%i.\t{FF6347}> {FFFFFF}VUT HOP DAN", result, MAX_INV_SLOTS+3);
		}
		if (PlayerInfo[playerid][pPlayerWeapon] == 23)
		{
			format(result, sizeof(result), "%s\n{ffffff}%i.\t{FF6347}> {FFFFFF}VUT NONG GIAM THANH", result, MAX_INV_SLOTS+4);
		}
	}

	if (GetPVarInt(playerid, #attach_item))
	{
		format(result, sizeof(result), "%s\n{ffffff}%i.\t{FF6347}> {FFFFFF}VUT\n{ffffff}%i.\t{FF6347}> {FFFFFF}NEM RA", result, MAX_INV_SLOTS+1, MAX_INV_SLOTS+2);
	}

	Dialog_Show(playerid, Inventory, DIALOG_STYLE_TABLIST_HEADERS, "Inventory", result, "Lua chon", "Huy bo");
	return true;
}

PrintInvEx(playerid, userid)
{
	new result[(MAX_INV_SLOTS+1) * 64] = "#\tVat pham\tSo luong"; //{ffffff}
	if (GetPVarInt(playerid, #pDelay)) return PrintInvEx(playerid, userid);
	
	format(result, sizeof(result), "-\t{33AA33}Tien\t$%i{FFFFFF}\n", PlayerInfo[playerid][pCash]);

    for(new i = 0; i < MAX_INV_SLOTS; i++) 
	{
		switch(Inventory[playerid][i][pInvItem])
		{
			case 0:
			{
				format(result, sizeof(result), "%s\n{ffffff}%i\t{C3C3C3}Slot trong", result, i+1);
			}
			case 22 .. 34:
			{
				if (Inventory[playerid][i][pInvQ] == 0) format(result, sizeof(result), "%s\n{ffffff}%i.\t%s {C3C3C3}[trong]\t1", result, i+1, inventory_items[Inventory[playerid][i][pInvItem]][itemName]); 
				else 									format(result, sizeof(result), "%s\n{ffffff}%i.\t%s {C3C3C3}[%s / %i round]{FFFFFF}\t1", result, i+1, inventory_items[Inventory[playerid][i][pInvItem]][itemName], inventory_items[Inventory[playerid][i][pInvEx]][itemName], Inventory[playerid][i][pInvQ]); 
			}

			case 78, 79:
			{
				if (Inventory[playerid][i][pInvEx] == 0) format(result, sizeof(result), "%s\n{ffffff}%i.\t%s {C3C3C3}[trong]\t1", result, i+1, inventory_items[Inventory[playerid][i][pInvItem]][itemName]); 
				else 									format(result, sizeof(result), "%s\n{ffffff}%i.\t%s {C3C3C3}[%s / %i]{FFFFFF}\t1", result, i+1, inventory_items[Inventory[playerid][i][pInvItem]][itemName], inventory_items[Inventory[playerid][i][pInvEx]][itemName], Inventory[playerid][i][pInvQ]); 
			}
			case INV_GASCAN: 
			{
				format(result, sizeof(result), "%s\n{ffffff}%i.\t%s {33FF66}(20L)\t1", result, i+1, inventory_items[Inventory[playerid][i][pInvItem]][itemName]);
			}
			default:
			{
				format(result, sizeof(result), "%s\n{ffffff}%i.\t%s\t%i", result, i+1, inventory_items[Inventory[playerid][i][pInvItem]][itemName], Inventory[playerid][i][pInvQ]);
			}
	    }
	}
	new title[34];

	if (!IsAdminDuty(userid))
	{
		new mes[64];
		format(mes,sizeof(mes),"searches %s.", GetNameWithMask(playerid));
		cmd::me(playerid, mes);

		title = "Search %s";
	}
	else title = "Inventory %s";

	format(title, sizeof(title), title, GetNameWithMask(playerid));
	Dialog_Show(userid, None, DIALOG_STYLE_TABLIST_HEADERS, title, result, ">>", "");
	return true;
}

PrintVehInv(playerid, vehid, frisk = 0)
{
	new result[(MAX_TRUNK_INVENTORY+1) * 64] = "#\tVat pham\tSo luong"; //{ffffff}
	if (GetPVarInt(playerid, #pDelay)) return PrintVehInv(playerid, vehid, frisk);

    for(new i = 0; i < MAX_TRUNK_INVENTORY; i++)
	{
		switch(TrunkInventory[vehid][i][pInvItem])
		{
			case 0:
			{
				format(result, sizeof(result), "%s\n{ffffff}%i\t{C3C3C3}Slot trong", result, i+1);
			}
			case 22 .. 34:
			{
				if (TrunkInventory[vehid][i][pInvQ] == 0) 	format(result, sizeof(result), "%s\n{ffffff}%i.\t%s {C3C3C3}[trong]\t1", result, i+1, inventory_items[TrunkInventory[vehid][i][pInvItem]][itemName]); 
				else 										format(result, sizeof(result), "%s\n{ffffff}%i.\t%s {C3C3C3}[%s / %i so luong]{FFFFFF}\t1", result, i+1, inventory_items[TrunkInventory[vehid][i][pInvItem]][itemName], inventory_items[TrunkInventory[vehid][i][pInvEx]][itemName], TrunkInventory[vehid][i][pInvQ]); 
			}

			case 78, 79:
			{
				if (TrunkInventory[vehid][i][pInvEx] == 0) 	format(result, sizeof(result), "%s\n{ffffff}%i.\t%s {C3C3C3}[trong]\t1", result, i+1, inventory_items[TrunkInventory[vehid][i][pInvItem]][itemName]); 
				else 										format(result, sizeof(result), "%s\n{ffffff}%i.\t%s {C3C3C3}[%s / %i]{FFFFFF}\t1", result, i+1, inventory_items[TrunkInventory[vehid][i][pInvItem]][itemName], inventory_items[TrunkInventory[vehid][i][pInvEx]][itemName], TrunkInventory[vehid][i][pInvQ]); 
			}
			case INV_GASCAN: 
			{
				format(result, sizeof(result), "%s\n{ffffff}%i.\t%s {33FF66}(20L)\t1", result, i+1, inventory_items[Inventory[playerid][i][pInvItem]][itemName]);
			}
			default: format(result, sizeof(result), "%s\n{ffffff}%i.\t%s\t%i", result, i+1, inventory_items[TrunkInventory[vehid][i][pInvItem]][itemName], TrunkInventory[vehid][i][pInvQ]);
	    }
	}

	new title[64];

	if (!frisk)
	{
		if (VehicleInfo[vehid][carFaction] && VehicleInfo[vehid][carFaction] == PlayerInfo[playerid][pFaction])  title = "Mount %s";
		else																									title = "Trunk %s";

		format(title, sizeof(title), title, VehicleNames[GetVehicleModel(vehid)-400]);
		Dialog_Show(playerid, InventoryOther, DIALOG_STYLE_TABLIST_HEADERS, title, result, "Lua chon", "Huy bo");
	}
	else 
	{
		if (!IsAdminDuty(playerid))
		{
			new mes[64];
			format(mes,sizeof(mes),"searches the trunk %s.", VehicleNames[GetVehicleModel(vehid)-400]);
			cmd::me(playerid, mes);

			title = "Trunk search %s";
			format(title, sizeof(title), title, VehicleNames[GetVehicleModel(vehid)-400]);
		} 
		else 
		{
			title = "Trunk %s | Chu so huu: %s";
			if (VehicleInfo[vehid][carOwnerID]) 	format(title, sizeof(title), title, VehicleNames[GetVehicleModel(vehid)-400], VehicleInfo[vehid][carOwner]);
			else   								format(title, sizeof(title), title, VehicleNames[GetVehicleModel(vehid)-400], GetInitials(Factions[VehicleInfo[vehid][carFaction]][fName])); 
		}
		
		Dialog_Show(playerid, None, DIALOG_STYLE_TABLIST_HEADERS, title, result, ">>", "");
	}

	if (VehicleInfo[vehid][vCorp] > 0 && CorpInfo[VehicleInfo[vehid][vCorp]][cUsed] == 1) SendWarningMessage(playerid,"Co mot cai xac trong xe.");

	return 1;
}

PrintGBInv(playerid, vehid, frisk = 0)
{
	new result[(MAX_CAR_INVENTORY+1) * 64] = "#\tVat pham\tSo luong"; //{ffffff}
	if (GetPVarInt(playerid, #pDelay)) return PrintGBInv(playerid, vehid, frisk);

    for(new i = 0; i < MAX_CAR_INVENTORY; i++)
	{
		switch(CarInventory[vehid][i][pInvItem])
		{
			case 0:
			{
				format(result, sizeof(result), "%s\n{ffffff}%i\t{C3C3C3}Slot trong", result, i+1);
			}
			case 22 .. 34:
			{
				if (CarInventory[vehid][i][pInvQ] == 0) 	format(result, sizeof(result), "%s\n{ffffff}%i.\t%s {C3C3C3}[trong]\t1", result, i+1, inventory_items[CarInventory[vehid][i][pInvItem]][itemName]); 
				else 									format(result, sizeof(result), "%s\n{ffffff}%i.\t%s {C3C3C3}[%s / %i round]{FFFFFF}\t1", result, i+1, inventory_items[CarInventory[vehid][i][pInvItem]][itemName], inventory_items[CarInventory[vehid][i][pInvEx]][itemName], CarInventory[vehid][i][pInvQ]); 
			}

			case 78, 79:
			{
				if (CarInventory[vehid][i][pInvEx] == 0) 	format(result, sizeof(result), "%s\n{ffffff}%i.\t%s {C3C3C3}[trong]\t1", result, i+1, inventory_items[CarInventory[vehid][i][pInvItem]][itemName]); 
				else 										format(result, sizeof(result), "%s\n{ffffff}%i.\t%s {C3C3C3}[%s / %i]{FFFFFF}\t1", result, i+1, inventory_items[CarInventory[vehid][i][pInvItem]][itemName], inventory_items[CarInventory[vehid][i][pInvEx]][itemName], CarInventory[vehid][i][pInvQ]); 
			}
			
			case INV_GASCAN: 
			{
				format(result, sizeof(result), "%s\n{ffffff}%i.\t%s {33FF66}(20L)\t1", result, i+1, inventory_items[Inventory[playerid][i][pInvItem]][itemName]);
			}

			default:
			{
				format(result, sizeof(result), "%s\n{ffffff}%i.\t%s\t%i", result, i+1, inventory_items[CarInventory[vehid][i][pInvItem]][itemName], CarInventory[vehid][i][pInvQ]);
			}
	    }
	}

	new title[64];

	if (!frisk)
	{
		title = "Glovebox %s";
		format(title, sizeof(title), title, VehicleNames[GetVehicleModel(vehid)-400]);
		Dialog_Show(playerid, InventoryOther, DIALOG_STYLE_TABLIST_HEADERS, title, result, "Lua chon", "Huy bo");
	}
	else 
	{
		if (!IsAdminDuty(playerid))
		{
			new mes[64];
			format(mes,sizeof(mes),"searches the glove compartment %s.", VehicleNames[GetVehicleModel(vehid)-400]);
			cmd::me(playerid, mes);

			title = "Searching the glove compartment %s";
			format(title, sizeof(title), title, VehicleNames[GetVehicleModel(vehid)-400]);
		}
		else 
		{
			title = "Glovebox %s | Chu so huu: %s";
			if (VehicleInfo[vehid][carOwnerID]) 	format(title, sizeof(title), title, VehicleNames[GetVehicleModel(vehid)-400], VehicleInfo[vehid][carOwner]);
			else   								format(title, sizeof(title), title, VehicleNames[GetVehicleModel(vehid)-400], GetInitials(Factions[VehicleInfo[vehid][carFaction]][fName])); 
		}

		Dialog_Show(playerid, None, DIALOG_STYLE_TABLIST_HEADERS, title, result, ">>", "");
	}	

	return 1;
}

PrintHouseInv(playerid, houseid, frisk = 0)
{
	new result[(MAX_HOUSE_INVENTORY+1) * 64] = "#\tVat pham\tSo luong"; //{ffffff}
	if (GetPVarInt(playerid, #pDelay)) return PrintHouseInv(playerid, houseid, frisk);

    for(new i = 0; i < MAX_HOUSE_INVENTORY; i++)
	{
		switch(HouseInventory[houseid][i][pInvItem])
		{
			case 0:
			{
				format(result, sizeof(result), "%s\n{ffffff}%i\t{C3C3C3}Slot trong", result, i+1);
			}
			case 22 .. 34:
			{
				if (HouseInventory[houseid][i][pInvQ] == 0) 	format(result, sizeof(result), "%s\n{ffffff}%i.\t%s {C3C3C3}[trong]\t1", result, i+1, inventory_items[HouseInventory[houseid][i][pInvItem]][itemName]); 
				else 										format(result, sizeof(result), "%s\n{ffffff}%i.\t%s {C3C3C3}[%s / %i round]{FFFFFF}\t1", result, i+1, inventory_items[HouseInventory[houseid][i][pInvItem]][itemName], inventory_items[HouseInventory[houseid][i][pInvEx]][itemName], HouseInventory[houseid][i][pInvQ]); 
			}

			case 78, 79:
			{
				if (HouseInventory[houseid][i][pInvEx] == 0) 	format(result, sizeof(result), "%s\n{ffffff}%i.\t%s {C3C3C3}[trong]\t1", result, i+1, inventory_items[HouseInventory[houseid][i][pInvItem]][itemName]); 
				else 											format(result, sizeof(result), "%s\n{ffffff}%i.\t%s {C3C3C3}[%s / %i]{FFFFFF}\t1", result, i+1, inventory_items[HouseInventory[houseid][i][pInvItem]][itemName], inventory_items[HouseInventory[houseid][i][pInvEx]][itemName], HouseInventory[houseid][i][pInvQ]); 
			}
			
			case INV_GASCAN: 
			{
				format(result, sizeof(result), "%s\n{ffffff}%i.\t%s {33FF66}(20L)\t1", result, i+1, inventory_items[Inventory[playerid][i][pInvItem]][itemName]);
			}
			
			default:
			{
				format(result, sizeof(result), "%s\n{ffffff}%i.\t%s\t%i", result, i+1, inventory_items[HouseInventory[houseid][i][pInvItem]][itemName], HouseInventory[houseid][i][pInvQ]);
			}
	    }
	}

	if (!frisk) Dialog_Show(playerid, InventoryOther, DIALOG_STYLE_TABLIST_HEADERS, "Cache", result, "Lua chon", "Huy bo");
	else 
	{	
		new title[42];
		if (!IsAdminDuty(playerid))
		{
			cmd::me(playerid, "searches the house.");
			title = "House search %s";
		}
		else title = "House %s";

		format(title, sizeof(title), title, HouseInfo[houseid][hOwner]);
		Dialog_Show(playerid, None, DIALOG_STYLE_TABLIST_HEADERS, title, result, ">>", "");
	}	

	return 1;
}
