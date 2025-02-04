Dialog:Inventory(playerid, response, listitem, inputtext[])
{
	if (!response)										return 1;
	if (GetPVarInt(playerid, "pDelay"))					return cmd::inventory(playerid, "");

	new title[56], mes[256];

	if (listitem == MAX_INV_SLOTS) // STORE WEAPON SECTION !
	{
		if (GetPVarInt(playerid, #attach_item)) 	return cmd::put(playerid, "");
	    else 									return cmd::putgun(playerid, "");
	}
	else if (listitem == MAX_INV_SLOTS + 1) // DROP WEAPON SECTION !
	{
		if (GetPVarInt(playerid, #attach_item))	return cmd::drop(playerid, "");
	    else 									return cmd::dropgun(playerid, "");
	}
	else if (listitem == MAX_INV_SLOTS + 2) // STORE AMMO SECTION !
	{
		if (PlayerInfo[playerid][pPlayerAmmo] < 1) return cmd::silencer(playerid, "");
		
	    if (!CheckInv(playerid))					return SendErrorMessage(playerid, "Tui do cua ban da day.");
		if (!PlayerInfo[playerid][pPlayerAmmo])	return SendErrorMessage(playerid, "Khong co bang dan trong khau sung nay. ");

		new wep = CheckPlayerWeaponEx(playerid);
		if (!wep) return SendAdmMessage("%s[ID:%i] nghi ngho dang su dung hack vu khi!", GetNameEx(playerid), playerid);

		if (wep >= 22 && wep <= 34) {
			new am = CheckAmmo(PlayerInfo[playerid][pAmmoType]);
			if (PlayerInfo[playerid][pPlayerAmmo] > am) PlayerInfo[playerid][pPlayerAmmo]=am;
		} 

		if (GiveInvItem(playerid, PlayerInfo[playerid][pAmmoType], PlayerInfo[playerid][pPlayerAmmo]) == -1)
			return SendErrorMessage(playerid, "Tui do da day.");
			
		
		SendWarningMessage(playerid, "Ban da giu %s - %s, %i round.", inventory_items[PlayerInfo[playerid][pPlayerWeapon]][itemName], inventory_items[PlayerInfo[playerid][pAmmoType]][itemName], PlayerInfo[playerid][pPlayerAmmo]);

		new msg[64];
		format(msg, sizeof(msg), "* %s keo bang dan ra khoi vu khi.", GetNameWithMask(playerid));
		SetPlayerChatBubble(playerid, msg, COLOR_PURPLE, 20.0, 4000);

		PlayerInfo[playerid][pPlayerAmmo]=0;
		PlayerInfo[playerid][pAmmoType]=0;
		
		ResetPlayerWeapons(playerid);	
		
		return true;
	}

	else if (listitem == MAX_INV_SLOTS + 3) // ���������
	{
		return cmd::silencer(playerid, "");
	}

	if (Inventory[playerid][listitem][pInvItem] == 0)	return cmd::inventory(playerid, "");

	if (inventory_items[Inventory[playerid][listitem][pInvItem]][itemSplit])
		if ((inventory_items[Inventory[playerid][listitem][pInvItem]][itemType] == ITEM_TYPE_DRUGS || inventory_items[Inventory[playerid][listitem][pInvItem]][itemType] == ITEM_TYPE_SEEDS) && (IsPlayerHasItem(playerid, 78) || IsPlayerHasItem(playerid, 79)))
			mes = "Su dung vat pham\nChuyen vat pham\nVut bo vat pham\nTieu huy vat pham\nTach ra\nKet hop\nCho vao tui / hop";
		else
			mes = "Su dung vat pham\nChuyen vat pham\nVut bo vat pham\nTieu huy vat pham\nTach ra\nKet hop";
	else
	{
		if (inventory_items[Inventory[playerid][listitem][pInvItem]][itemType] == ITEM_TYPE_INSIDEABLE_OBJECT)
		{
			if (Inventory[playerid][listitem][pInvEx]) 
				format(mes, sizeof(mes), "Reach %s(%f)\nChuyen vat pham\nNem vat pham\nTieu huy vat pham", inventory_items[Inventory[playerid][listitem][pInvEx]][itemName], Inventory[playerid][listitem][pInvQFloat]);
			else mes = "Dat vat pham\nChuyen vat pham\nNem vat pham\nTieu huy vat pham";

			if (!GetPVarInt(playerid, #attach_item)) format(mes, sizeof(mes), "%s\nNhat", mes);
		}
		else
			mes = "Su dung vat pham\nChuyen vat pham\nVut bo vat pham\nTieu huy vat pham\nTach ra\nKet hop";
	}

    new houseid = -1;
	if ((houseid = GetNearInsideHouse(playerid)) != -1 && houseid >= 0 && houseid < MAX_HOUSES && PlayerToPoint(1, playerid,HouseInfo[houseid][hCheckPosX], HouseInfo[houseid][hCheckPosY], HouseInfo[houseid][hCheckPosZ]))
	{
	    SetPVarInt(playerid, #inventory_house, houseid+1);
 		format(mes, sizeof(mes), "%s\n{ffff00}Dat vao trong nha (ID: %i)", mes, houseid);
	}

	new vehicle = GetNearVehicle(playerid, 4.0);
	if (vehicle != 0 && (!IsADontTrunk(vehicle) || !IsAPlane(vehicle) || !IsABiker(vehicle) || !IsAHelicopter(vehicle) || !IsABoat(vehicle) || !IsABicycle(vehicle)))
	{
		if ((VehicleInfo[vehicle][carTrunkLock] && !IsPlayerInAnyVehicle(playerid)) || (IsPlayerInAnyVehicle(playerid) && VehicleInfo[vehicle][carFaction] && VehicleInfo[vehicle][carFaction] == PlayerInfo[playerid][pFaction]))
		{
			SetPVarInt(playerid, #inventory_vehicle, vehicle);
			format(mes, sizeof(mes), "%s\n{ffff00}Dat vao %s (ID: %i)", mes, VehicleNames[GetVehicleModel(vehicle)-400], vehicle);
		}
	}

	if (GetPVarInt(playerid, #inventory_vehicle) == 0 && inventory_items[Inventory[playerid][listitem][pInvItem]][itemSize] == ITEM_SIZE_SMALL)
	{
		vehicle = GetPlayerVehicleID(playerid);
		if (IsPlayerInAnyVehicle(playerid) && vehicle != 0 && VehicleInfo[vehicle][carOwnerID] == PlayerInfo[playerid][pID])
		{
			format(mes, sizeof(mes), "%s\n{ffff00}Dat vao glove compartment %s (ID: %i)", mes, VehicleNames[GetVehicleModel(vehicle)-400], vehicle);	
		}
	}

	SetPVarInt(playerid, #inventory_choose, listitem);
	format(title, sizeof(title), "{FFFFFF}Tui do > %s", inventory_items[Inventory[playerid][listitem][pInvItem]][itemName]);
    Dialog_Show(playerid, InventoryChoose, DIALOG_STYLE_LIST, title, mes, "Lua chon", "Quay lai");
	return 1;
}

Dialog:InventoryChoose(playerid, response, listitem, inputtext[])
{
	if (!response)	return cmd::inventory(playerid, "");

	new slot = GetPVarInt(playerid, #inventory_choose);

	if (slot < 0 || slot > MAX_INV_SLOTS-1 || Inventory[playerid][slot][pInvItem] == 0)	return cmd::inventory(playerid, "");
	
	if (listitem > 3 || (listitem == 0 && inventory_items[Inventory[playerid][slot][pInvItem]][itemType] == ITEM_TYPE_INSIDEABLE_OBJECT))
	{
		new listadd;
		if (inventory_items[Inventory[playerid][slot][pInvItem]][itemSplit])
			if ((inventory_items[Inventory[playerid][slot][pInvItem]][itemType] == ITEM_TYPE_DRUGS || inventory_items[Inventory[playerid][slot][pInvItem]][itemType] == ITEM_TYPE_SEEDS) && (IsPlayerHasItem(playerid, 78) || IsPlayerHasItem(playerid, 79)))
				listadd = 3;
			else
				listadd = 2;
		else 
		{
			if (inventory_items[Inventory[playerid][slot][pInvItem]][itemType] == ITEM_TYPE_INSIDEABLE_OBJECT)
			{
				if (listitem == 4)
				{
					if (!GetPVarInt(playerid, #attach_item))	listadd = 6; //����� � ����								
				}
				else
				{
					if (Inventory[playerid][slot][pInvEx]) 	listadd = 4; // �������
					else 									listadd = 5; // ��������
				}											
			}
			else listadd = 0;
		}

		switch(listitem)
		{
			case 0:
			{
				switch(listadd)
				{
					case 4: listitem = 8; // �������
					case 5: listitem = 9; // ��������
				}
			}
			case 4:
			{
				switch(listadd)
				{
					case 0: listitem = 4; // ��������
					case 2: listitem = 5; // ���������
					case 3: listitem = 5; // ���������
					case 6: listitem = 10; // ����� � ����
				}
			}
			case 5:
			{
				switch(listadd)
				{
					case 2: listitem = 6; // ����������
					case 3: listitem = 6; // ����������
				}
			}
			case 6:
			{
				switch(listadd)
				{
					case 2: listitem = 4; //��������
					case 3: listitem = 7; // �������� �
				}
			}
			case 7:
			{
				listitem = 4;// ��������
			}
		}
	}

	switch(listitem)
	{
	    case 0: CallLocalFunction("OnPlayerUseItem", "ii", playerid, slot);
		case 1: Dialog_Show(playerid, GiveItem, DIALOG_STYLE_INPUT, "{FFFFFF}Chuyen vat pham", "{ffffff}Nhap ten hoac ID nguoi choi ma ban muon chuyen vat pham:", ">>>", "Quay lai");
		case 2:
		{
			if (inventory_items[Inventory[playerid][slot][pInvItem]][itemType] == ITEM_TYPE_AMMO || inventory_items[Inventory[playerid][slot][pInvItem]][itemType] == ITEM_TYPE_WEAPON)
			{
				if (CheckAdmin(playerid, ADMIN_LEVEL_1) || IsTester(playerid))	return SendErrorMessage(playerid, "Dau tien thoat admin-duty.");
				if (PlayerInfo[playerid][pOnDuty])								return SendErrorMessage(playerid, "Function nay khong hoat dong khi admin-duty.");
			}

			if (Inventory[playerid][slot][pInvQ])	
			{
				if (inventory_items[Inventory[playerid][slot][pInvItem]][itemType] == ITEM_TYPE_WEAPON)
				{
					if (ItemDrop_Drop(playerid, Inventory[playerid][slot][pInvItem], Inventory[playerid][slot][pInvQ], Inventory[playerid][slot][pInvQFloat], Inventory[playerid][slot][pInvEx], Inventory[playerid][slot][pInvS]) == -1)	return SendErrorMessage(playerid, "The maximum number of dropped items has been reached.");
					switch(inventory_items[Inventory[playerid][slot][pInvItem]][itemType]) {
						case 22..34: SendSyntaxMessage(playerid, "Ban da vut %s [%s / %i round]. Nhap {ffc46a}/pitem{FFFFFF} hoac ngoi xuong nhan {ffc46a}H{FFFFFF} de nhat.", inventory_items[Inventory[playerid][slot][pInvItem]][itemName], inventory_items[Inventory[playerid][slot][pInvEx]][itemName], inventory_items[Inventory[playerid][slot][pInvQ]][itemName]);
						default: 	 SendSyntaxMessage(playerid, "Ban da vut %s. Nhap{ffc46a}/pitem{FFFFFF} hoac ngoi xuong nhan {ffc46a}H{FFFFFF} de nhat.", inventory_items[Inventory[playerid][slot][pInvItem]][itemName]);
					}
				}
				else if (inventory_items[Inventory[playerid][slot][pInvItem]][itemType] == ITEM_TYPE_DRUGS || inventory_items[Inventory[playerid][slot][pInvItem]][itemType] == ITEM_TYPE_REACT)
				{
					
				}
				else 
				{
					if (ItemDrop_Drop(playerid, Inventory[playerid][slot][pInvItem], Inventory[playerid][slot][pInvQ], Inventory[playerid][slot][pInvQFloat], Inventory[playerid][slot][pInvEx], Inventory[playerid][slot][pInvS]) == -1)	return SendErrorMessage(playerid, "The maximum number of dropped items has been reached.");
					SendSyntaxMessage(playerid, "Ban da vut %s [%i ��]. Nhap {ffc46a}/pitem{FFFFFF} hoac ngoi xuong nhan {ffc46a}H{FFFFFF} de nhat.", inventory_items[Inventory[playerid][slot][pInvItem]][itemName], Inventory[playerid][slot][pInvQ]);
				}
			}
			else
			{
				if (ItemDrop_Drop(playerid, Inventory[playerid][slot][pInvItem], Inventory[playerid][slot][pInvQ], Inventory[playerid][slot][pInvQFloat], Inventory[playerid][slot][pInvEx], Inventory[playerid][slot][pInvS]) == -1)	return SendErrorMessage(playerid, "The maximum number of dropped items has been reached.");
				SendSyntaxMessage(playerid, "Ban da vut %s. Nhap {ffc46a}/pitem{FFFFFF} hoac ngoi xuong nhan {ffc46a}H{FFFFFF} de nhat.", inventory_items[Inventory[playerid][slot][pInvItem]][itemName], Inventory[playerid][slot][pInvQ]);			
			}
			RemoveInvItem(playerid, Inventory[playerid][slot][pInvItem], 0, slot);
		}
		case 3:
		{
			new mes[128];
			format(mes, sizeof(mes), "{ffffff}Ban co chac chan muon tieu huy vat pham - %s?", inventory_items[Inventory[playerid][slot][pInvItem]][itemName]);
   			Dialog_Show(playerid, DeleteItem, DIALOG_STYLE_MSGBOX, "{FFFFFF}Tieu huy vat pham", mes, "Co", "Huy");
		}
		case 4:
		{
		    new mes[128];

		    if (GetPVarInt(playerid, #inventory_house) != 0)
			{
				if (Inventory[playerid][slot][pInvQ] > 1 && inventory_items[Inventory[playerid][slot][pInvItem]][itemSplit]) 
				{
					format(mes, sizeof(mes), "{ffffff}Vat pham: %s (So luong: %i)\n\nNhap so tien ban muon gui vao kho o nha: ",
					inventory_items[Inventory[playerid][slot][pInvItem]][itemName], Inventory[playerid][slot][pInvQ]);
				}
				else
				{
					new 
						houseid = -1,
						i = GetNextHouseTrunkSlot(houseid),
						item = Inventory[playerid][slot][pInvItem]
					;

					if ((houseid = GetNearInsideHouse(playerid)) != -1 && houseid >= 0 && houseid < MAX_HOUSES && PlayerToPoint(1, playerid,HouseInfo[houseid][hCheckPosX], HouseInfo[houseid][hCheckPosY], HouseInfo[houseid][hCheckPosZ]))
					{
						if (ValidWeaponForInventory(item) && PlayerInfo[playerid][pOnDuty]) return SendErrorMessage(playerid, "Ban khong the dat vu khi trong bo nho cache khi dang lam nhiem vu.");

						if (i == -1)		return SendErrorMessage(playerid, "Khong co phong trong nha.");
						if (item == 0) 		return cmd::inventory(playerid, "");
						
						SM2(playerid, "Ban dat %s vao nha bi mat.", inventory_items[item][itemName]);

						HouseInventory[houseid][i][pInvItem] 	= Inventory[playerid][slot][pInvItem];
						HouseInventory[houseid][i][pInvQ]		= Inventory[playerid][slot][pInvQ];
						HouseInventory[houseid][i][pInvEx]		= Inventory[playerid][slot][pInvEx];
						HouseInventory[houseid][i][pInvS]		= Inventory[playerid][slot][pInvS];
						HouseInventory[houseid][i][pInvQFloat]	= Inventory[playerid][slot][pInvQFloat];
						format(HouseInventory[houseid][i][pInvName],16, "%s", Inventory[playerid][slot][pInvName]);
						
						RemoveInvItem(playerid, Inventory[playerid][slot][pInvItem], 0, slot);
						
						format(mes, sizeof(mes), "dat %s vao nha bi mat.", inventory_items[item][itemName]);
						SetPlayerChatBubble(playerid, mes, COLOR_PURPLE, 20.0, 4000);

						Save_HouseInventory(houseid);
						return cmd::inventory(playerid, "");
					}
				}
			}
			else if (GetPVarInt(playerid, #inventory_vehicle) != 0)
			{
				if (Inventory[playerid][slot][pInvQ] > 1 && inventory_items[Inventory[playerid][slot][pInvItem]][itemSplit]) 
				{
   			    	format(mes, sizeof(mes), "{ffffff}Vat pham: %s (So luong: %i)\n\nNhap so luong ban muon bo vao thung xe: ",
					inventory_items[Inventory[playerid][slot][pInvItem]][itemName], Inventory[playerid][slot][pInvQ]);
				}
				else 
				{
					new vehicle = GetPVarInt(playerid, #inventory_vehicle);

					new item = Inventory[playerid][slot][pInvItem];
					if (item == 0) return cmd::inventory(playerid, "");

					if (vehicle > 0 && GetNearVehicle(playerid, 5.0, vehicle) != 0)
					{
						if (IsADontTrunk(vehicle) || IsAPlane(vehicle) || IsABiker(vehicle) || IsAHelicopter(vehicle) || IsABoat(vehicle) || IsABicycle(vehicle))		return SendErrorMessage(playerid, "Phuong tien nay khong co thung xe.");
						if (VehicleInfo[vehicle][carFaction] && VehicleInfo[vehicle][carFaction] != PlayerInfo[playerid][pFaction])										return SendErrorMessage(playerid, "Ban khong the truy cap vao thung xe chinh thuc cua minh.");
						if (ValidWeaponForInventory(item) && PlayerInfo[playerid][pOnDuty] && VehicleInfo[vehicle][carOwnerID] != 0) 									return SendErrorMessage(playerid,"Ban khong the de vu khi trong xe ca nhan cua minh khi lam nhiem vu.");
						if (IsPlayerInAnyVehicle(playerid) && VehicleInfo[vehicle][carFaction] && VehicleInfo[vehicle][carFaction] != PlayerInfo[playerid][pFaction]) 	return SendErrorMessage(playerid, "Ban nen o trong thung.");
						if (!IsPlayerInAnyVehicle(playerid) && !VehicleInfo[vehicle][carTrunkLock]) 																	return SendErrorMessage(playerid, "Thung xe nay da duoc dong lai.");

						new i = GetNextVehicleTrunkSlot(vehicle);
						if (i == -1)	return SendErrorMessage(playerid, "Khong co cho trong xe. ");

						TrunkInventory[vehicle][i][pInvItem] 	= Inventory[playerid][slot][pInvItem];
						TrunkInventory[vehicle][i][pInvQ] 		= Inventory[playerid][slot][pInvQ];
						TrunkInventory[vehicle][i][pInvEx]		= Inventory[playerid][slot][pInvEx];
						TrunkInventory[vehicle][i][pInvS] 		= Inventory[playerid][slot][pInvS];
						TrunkInventory[vehicle][i][pInvQFloat]	= Inventory[playerid][slot][pInvQFloat];
						format(TrunkInventory[vehicle][i][pInvName],16, "%s", Inventory[playerid][slot][pInvName]);
						
						RemoveInvItem(playerid, Inventory[playerid][slot][pInvItem], 0, slot);
						
						SM2(playerid, "Ban dat %s vao %s.", inventory_items[item][itemName], VehicleNames[GetVehicleModel(vehicle)-400]);

						format(mes, sizeof(mes), "dat %s vao %s %s.", inventory_items[item][itemName], (VehicleInfo[vehicle][carFaction])?("fastening"):("trunk"), VehicleNames[GetVehicleModel(vehicle)-400]);
						SetPlayerChatBubble(playerid, mes, COLOR_PURPLE, 20.0, 4000);

						Save_CarInventory(vehicle);
						return cmd::inventory(playerid, "");
					}
				}
			}
			else if (GetPVarInt(playerid, #inventory_vehicle) == 0 && IsPlayerInAnyVehicle(playerid))
			{
				new vehicle = GetPlayerVehicleID(playerid);
				if (VehicleInfo[vehicle][carOwnerID] != PlayerInfo[playerid][pID] && vehicle == 0) return cmd::inventory(playerid, "");

				if (Inventory[playerid][slot][pInvQ] > 1 && inventory_items[Inventory[playerid][slot][pInvItem]][itemSplit]) 
				{
   			    	format(mes, sizeof(mes), "{ffffff}Vat pham: %s (So luong: %i)\n\nNhap so tien ban muon bo vao thung xe:", 
					inventory_items[Inventory[playerid][slot][pInvItem]][itemName], Inventory[playerid][slot][pInvQ]);
				}
				else 
				{
					new 
						i = GetNextVehicleGBSlot(vehicle),
						item = Inventory[playerid][slot][pInvItem]
					;

					if (vehicle == 0) 	return cmd::inventory(playerid, "");
					if (item == 0) 		return cmd::inventory(playerid, "");
					if (i == -1)		return SendErrorMessage(playerid, "Khong co cho trong xe. ");

					if (VehicleInfo[vehicle][carOwnerID] != PlayerInfo[playerid][pID])		  									
						return SendErrorMessage(playerid, "Ngan dung gang tay cua phuong tien nay khong co san cho ban.");
					if (ValidWeaponForInventory(item) && PlayerInfo[playerid][pOnDuty] && VehicleInfo[vehicle][carOwnerID] != 0)
						return SendErrorMessage(playerid, "Ban khong the de vu khi trong xe ca nhan cua minh khi lam nhiem vu. ");
					
					CarInventory[vehicle][i][pInvItem]		= Inventory[playerid][slot][pInvItem];
					CarInventory[vehicle][i][pInvQ]			= Inventory[playerid][slot][pInvQ];
					CarInventory[vehicle][i][pInvEx] 		= Inventory[playerid][slot][pInvEx];
					CarInventory[vehicle][i][pInvS]			= Inventory[playerid][slot][pInvS];
					CarInventory[vehicle][i][pInvQFloat]	= Inventory[playerid][slot][pInvQFloat];
					format(CarInventory[vehicle][i][pInvName],16, "%s", Inventory[playerid][slot][pInvName]);
						
					RemoveInvItem(playerid, Inventory[playerid][slot][pInvItem], 0, slot);
						
					SM2(playerid, "Ban dat %s vao trong glove compartment %s.", inventory_items[item][itemName], VehicleNames[GetVehicleModel(vehicle)-400]);

					format(mes, sizeof(mes), "dat glove compartment vao %s %s.", inventory_items[item][itemName], VehicleNames[GetVehicleModel(vehicle)-400]);
					SetPlayerChatBubble(playerid, mes, COLOR_PURPLE, 20.0, 4000);

					Save_CarInventory(vehicle);
					return cmd::inventory(playerid, "");
				}
			}
			else return SendErrorMessage(playerid, "Da xay ra loi!");
			
			Dialog_Show(playerid, PutItemInProperty, DIALOG_STYLE_INPUT, "{FFFFFF}Dat vat pham", mes, "Dat", "Huy");
			return 1;
		}
		case 5: // ��������� 
		{
			if (!inventory_items[Inventory[playerid][slot][pInvItem]][itemFloat]) {
				if (Inventory[playerid][slot][pInvQ] < 2)	
					return SendErrorMessage(playerid, "Doi voi phep chia, so muc phai lon hon 1.");
						
				new divide_string[128];
				format(divide_string, sizeof(divide_string), "{FFFFFF}Ban muon tach biet bao nhieu %s {ffc46a}(%i){FFFFFF}?", inventory_items[Inventory[playerid][slot][pInvItem]][itemName], Inventory[playerid][slot][pInvQ]);
				Dialog_Show(playerid, DivideInvInt, DIALOG_STYLE_INPUT, "Tach vat pham", divide_string, ">>>","Quay lai");
			} else {
				if (Inventory[playerid][slot][pInvQFloat] < 0.2)	
					return SendErrorMessage(playerid, "De tach, so luong muc phai lon hon (0,2).");
						
				new divide_string[128];
				format(divide_string, sizeof(divide_string), "{FFFFFF}Ban muon tach gram tu bao nhieu %s {ffc46a}(%.1fg){FFFFFF}?", inventory_items[Inventory[playerid][slot][pInvItem]][itemName], Inventory[playerid][slot][pInvQFloat]);
				Dialog_Show(playerid, DivideInvFloat, DIALOG_STYLE_INPUT, "Tach vat pham", divide_string, ">>>","Quay lai");
			}
			
			return 1;
		}
		case 6: // ����������
		{
			FixInv(playerid);

			SendHelpMessage(playerid, "Chon doi tuong ma ban muon ket hop %s (%i).", inventory_items[Inventory[playerid][slot][pInvItem]][itemName], Inventory[playerid][slot][pInvQ]);

			new dlgstr[20 * 128] = "#\tVat pham\tSo luong";

			new ccount;
			for(new i = 0; i < MAX_INV_SLOTS; i++) 
			{
				switch(Inventory[playerid][i][pInvItem])
				{
					case 0:	format(dlgstr, sizeof(dlgstr), "%s\n{ffffff}%i\t{C3C3C3}Slot trong", dlgstr, i+1);
					case 22 .. 34:
					{
						if (Inventory[playerid][i][pInvQ] == 0) 	format(dlgstr, sizeof(dlgstr), "%s\n{ffffff}%i.\t%s {C3C3C3}[trong]\t1", dlgstr, i+1, inventory_items[Inventory[playerid][i][pInvItem]][itemName]); 
						else 									format(dlgstr, sizeof(dlgstr), "%s\n{ffffff}%i.\t%s {C3C3C3}[%s / %i round]{FFFFFF}\t1", dlgstr, i+1, inventory_items[Inventory[playerid][i][pInvItem]][itemName], inventory_items[Inventory[playerid][i][pInvEx]][itemName], Inventory[playerid][i][pInvQ]); 
					}
					case INV_GANJA, INV_MED_GANJA, 103 .. 118:
					{
						format(dlgstr, sizeof(dlgstr), "%s\n{ffffff}%i.\t%s{FFFFFF}\t%.1fg", dlgstr, i+1, inventory_items[Inventory[playerid][i][pInvItem]][itemName], Inventory[playerid][i][pInvQFloat]);
					}
					case INV_DRUG:
					{
						format(dlgstr, sizeof(dlgstr), "%s\n{ffffff}%i.\t%s {C3C3C3}[OAS: %i%%]{FFFFFF}\t%.1fg", dlgstr, i+1, Inventory[playerid][i][pInvName], Inventory[playerid][i][pInvEx], Inventory[playerid][i][pInvQFloat]);
					}
					default: format(dlgstr, sizeof(dlgstr), "%s\n{ffffff}%i.\t%s\t%i", dlgstr, i+1, inventory_items[Inventory[playerid][i][pInvItem]][itemName], Inventory[playerid][i][pInvQ]);	
				}
				ccount++;
			}
			if (!ccount) return SendErrorMessage(playerid, "Khong co doi tuong phu hop!");

			Dialog_Show(playerid, CombInv, DIALOG_STYLE_TABLIST_HEADERS, "Inventory> Union", dlgstr, "Lua chon", "Huy");
			return 1;
		}
		case 7: //�������� �
		{
			new dlgstr[32*MAX_INV_SLOTS];

			format(dlgstr, sizeof(dlgstr), "Chon noi ma ban muon dat '%s':{FFFFFF}\n", inventory_items[Inventory[playerid][slot][pInvItem]][itemName]);

			new ccount;
			for(new i = 0; i < MAX_INV_SLOTS; i++) 
			{
				if (inventory_items[Inventory[playerid][i][pInvItem]][itemType] == ITEM_TYPE_INSIDEABLE_OBJECT)
				{
					if (!Inventory[playerid][i][pInvEx])
					{
						ccount++;
						format(dlgstr, sizeof(dlgstr), "%s%i. %s\n", dlgstr, i+1, inventory_items[Inventory[playerid][i][pInvItem]][itemName]);
					}
				}
			}
			if (!ccount) return SendErrorMessage(playerid, "Khong co doi tuong phu hop!");

			Dialog_Show(playerid, InventoryPut, DIALOG_STYLE_TABLIST_HEADERS, "Inventory", dlgstr, "Lua chon", "Huy");
			return 1;
		}
		case 8: // �������
		{
			if (!Inventory[playerid][slot][pInvEx])	return 1;

			if (!CheckInv(playerid))					
			{
				cmd::inventory(playerid, "");
				return SendErrorMessage(playerid, "Tui do da day.");
			}

			if (GiveInvItem(playerid, Inventory[playerid][slot][pInvEx], Inventory[playerid][slot][pInvQ]) == -1) return SendErrorMessage(playerid, "Tui do da day.");
			SendSyntaxMessage(playerid, "Ban da duoc %s (%i) cua %s.", inventory_items[Inventory[playerid][slot][pInvEx]][itemName], Inventory[playerid][slot][pInvQ], inventory_items[Inventory[playerid][slot][pInvItem]][itemName]);

			Inventory[playerid][slot][pInvEx] = 0;
			Inventory[playerid][slot][pInvQ] = 1;

			return 1;	
		}
		case 9: // ��������
		{
			new dlgstr[32*MAX_INV_SLOTS];

			format(dlgstr, sizeof(dlgstr), "Chon vat pham ban muon xoa '%s':{FFFFFF}\n", inventory_items[Inventory[playerid][slot][pInvItem]][itemName]);

			new ccount;
			for(new i = 0; i < MAX_INV_SLOTS; i++) 
			{
				if (inventory_items[Inventory[playerid][i][pInvItem]][itemType] == ITEM_TYPE_DRUGS || inventory_items[Inventory[playerid][i][pInvItem]][itemType] == ITEM_TYPE_SEEDS)
				{
					ccount++;
					if (inventory_items[Inventory[playerid][i][pInvItem]][itemType] == ITEM_TYPE_DRUGS){
						format(dlgstr, sizeof(dlgstr), "%s%i. %s\n", dlgstr, i+1, Inventory[playerid][i][pInvName]);
					} else {
						format(dlgstr, sizeof(dlgstr), "%s%i. %s\n", dlgstr, i+1, inventory_items[Inventory[playerid][i][pInvItem]][itemName]);
					}
					
				}
			}

			if (!ccount) return SendErrorMessage(playerid, "Khong co doi tuong phu hop!");

			Dialog_Show(playerid, InventoryPut2, DIALOG_STYLE_TABLIST_HEADERS, "Inventory", dlgstr, "Lua chon", "Huy");
			return 1;
		}
		case 10:
		{
			if (PlayerInfo[playerid][pInjured] != 0 || GetPVarInt(playerid, "Freeze") || pTemp[playerid][pTaserTime] || pTemp[playerid][pCuffed] || PhoneInfo[playerid][current_page] == PAGE_NOTIFICATION || PlayerInfo[playerid][pJailed] != 0)
				return SendErrorMessage(playerid, "Ban khong the su dung tinh nang nay ngay bay gio.");

			if (IsPlayerAttachedObjectSlotUsed(playerid, ATTACH_HANDS))	return SendWarningMessage(playerid, "Tay cua ban dang cam mot vat pham roi.");
			if (GetPlayerVehicleID(playerid) != 0)						return SendErrorMessage(playerid, "Ban phai o ben ngoai phuong tien.");
			
			if (Inventory[playerid][slot][pInvItem] == 78)
			{
    			SetPlayerAttachedObject(playerid, ATTACH_HANDS, 19571, 6, -0.157999, -0.002000, -0.169000, -21.999990, 87.000022, 0.000000, 1.186000, 1.000000, 1.170000);
  				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
			}
			else if (Inventory[playerid][slot][pInvItem] == 79)
			{
				SetPlayerAttachedObject(playerid, ATTACH_HANDS, inventory_items[Inventory[playerid][slot][pInvItem]][itemModel], 6, 0.204, 0.012, 0.026, 0.0, -101.3, -10.5, 0.838, 0.5, 0.597);
			}

			SetPVarInt(playerid, #attach_item, 1);

			pTemp[playerid][tempItem]	= Inventory[playerid][slot][pInvItem];
			pTemp[playerid][tempEx] 	= Inventory[playerid][slot][pInvEx];
			pTemp[playerid][tempQ] 		= Inventory[playerid][slot][pInvQ];

			InfoMSG(playerid, "Ban co the go bo hoac loai bo vat pham nay khoi tay minh~n~~y~Trong tui do~w~ su dung lenh ~y~/PUT~w~ hoac ~y~/DROP~w~", 5);
			SendSyntaxMessage(playerid, "Ban da nhat %s.", inventory_items[Inventory[playerid][slot][pInvItem]][itemName]);

			RemoveInvItem(playerid, Inventory[playerid][slot][pInvItem], 0, slot);
			return 1;
		}
	}
	return 1;
}

Dialog:InventoryPut2(playerid, response, listitem, inputtext[])
{
	if (!response) return cmd::inventory(playerid, "");

	new count,
		slot = GetPVarInt(playerid, #inventory_choose);

	for(new i = 0; i < MAX_INV_SLOTS; i++) 
	{
		if (inventory_items[Inventory[playerid][i][pInvItem]][itemType] == ITEM_TYPE_DRUGS || inventory_items[Inventory[playerid][i][pInvItem]][itemType] == ITEM_TYPE_SEEDS)
		{
			if (listitem == count)	
			{
				count = i;
				break;
			}
			else count++;
		}
	}

	Inventory[playerid][slot][pInvEx] = Inventory[playerid][count][pInvItem];
	Inventory[playerid][slot][pInvQ] = Inventory[playerid][count][pInvQ];

	SendSyntaxMessage(playerid, "Ban da xoa thanh cong %s (%i) trong %s.", inventory_items[Inventory[playerid][slot][pInvEx]][itemName], Inventory[playerid][slot][pInvQ], inventory_items[Inventory[playerid][slot][pInvItem]][itemName]);

	RemoveInvItem(playerid, Inventory[playerid][count][pInvItem], 0, count);
	return 1;
}


Dialog:InventoryPut(playerid, response, listitem, inputtext[])
{
	if (!response) return cmd::inventory(playerid, "");

	new count,
		slot = GetPVarInt(playerid, #inventory_choose);

	for(new i = 0; i < MAX_INV_SLOTS; i++) 
	{
		if (inventory_items[Inventory[playerid][i][pInvItem]][itemType] == ITEM_TYPE_INSIDEABLE_OBJECT)
		{
			if (!Inventory[playerid][i][pInvEx])
			{
				if (listitem == count)	
				{
					count = i;
					break;
				}
				else count++;
			}
		}
	}

	Inventory[playerid][count][pInvEx] = Inventory[playerid][slot][pInvItem];
	Inventory[playerid][count][pInvQ] = Inventory[playerid][slot][pInvQ];

	SendSyntaxMessage(playerid, "Ban da xoa thanh cong %s (%i) trong %s.", inventory_items[Inventory[playerid][count][pInvEx]][itemName], Inventory[playerid][count][pInvQ], inventory_items[Inventory[playerid][count][pInvItem]][itemName]);

	RemoveInvItem(playerid, Inventory[playerid][slot][pInvItem], 0, slot);
	return 1;
}

Dialog:CombInv(playerid, response, listitem, inputtext[])
{
	if (!response) return cmd::inventory(playerid, "");

	new slot1 = GetPVarInt(playerid, #inventory_choose),
		slot2 = listitem;

	if (Inventory[playerid][slot1][pInvItem] != Inventory[playerid][slot2][pInvItem])
	{
		SendErrorMessage(playerid, "Ban chi co the ket hop cac vat pham giong nhau.");
		return cmd::inventory(playerid, "");
	}

	if (slot1 == slot2)
	{
		SendErrorMessage(playerid, "Ban khong the ket hop mot mon do voi chinh minh. ");
		return cmd::inventory(playerid, "");
	}
	
	switch(Inventory[playerid][slot1][pInvItem])
	{
		case INV_GANJA, INV_MED_GANJA, 103 .. 118:
		{
			if (Inventory[playerid][slot1][pInvQFloat] + Inventory[playerid][slot2][pInvQFloat] > 999.0) {
				SendErrorMessage(playerid, "Trong luong cua so luong ca hai vat pham khi ket hop khong duoc vuot qua - 999g. ");
				return cmd::inventory(playerid, "");
			}

			Inventory[playerid][slot2][pInvQFloat] += Inventory[playerid][slot1][pInvQFloat];
			SendSyntaxMessage(playerid, "Ban da hop nhat thanh cong %s (%.1fg).", inventory_items[Inventory[playerid][slot2][pInvItem]][itemName], Inventory[playerid][slot2][pInvQFloat]);

			RemoveFloatInvItem(playerid, Inventory[playerid][slot1][pInvItem], 0.0, slot1);
		}
		case INV_DRUG:
		{
			if (!CompareStrings(Inventory[playerid][slot2][pInvName], Inventory[playerid][slot2][pInvName])) {
				SendErrorMessage(playerid, "Ban khong the ket hop hai loai thuoc khac nhau. (Khac ten!) ");
				return cmd::inventory(playerid, "");
			}
			if (Inventory[playerid][slot1][pInvEx] != Inventory[playerid][slot2][pInvEx]) {
				SendErrorMessage(playerid, "Ban khong the ket hop hai loai thuoc khac nhau. (Do tinh khiet khac nhau!) ");
				return cmd::inventory(playerid, "");
			}
			if (Inventory[playerid][slot1][pInvQFloat] + Inventory[playerid][slot2][pInvQFloat] > 999.0) {
				SendErrorMessage(playerid, "Trong luong cua so luong ca hai vat pham khi ket hop khong duoc vuot qua - 999g. ");
				return cmd::inventory(playerid, "");
			}

			Inventory[playerid][slot2][pInvQFloat] += Inventory[playerid][slot1][pInvQFloat];
			SendSyntaxMessage(playerid, "Ban da hop nhat thanh cong %s {C3C3C3}[OAS: %i%%]{FFFFFF} (%.1fg).", Inventory[playerid][slot2][pInvName], Inventory[playerid][slot2][pInvEx], Inventory[playerid][slot2][pInvQFloat]);

			RemoveFloatInvItem(playerid, Inventory[playerid][slot1][pInvItem], 0.0, slot1);
		}
		default: {
			if ((Inventory[playerid][slot1][pInvQ] + Inventory[playerid][slot2][pInvQ] > 100) && (inventory_items[Inventory[playerid][slot1][pInvQ]][itemType] == ITEM_TYPE_SEEDS || inventory_items[Inventory[playerid][slot1][pInvQ]][itemType] == ITEM_TYPE_DRUGS))
			{
				SendErrorMessage(playerid, "Tong so cua ca hai vat pham khi ket hop khong duoc vuot qua - 100. ");
				return cmd::inventory(playerid, "");
			} 
			else if (Inventory[playerid][slot1][pInvQ] + Inventory[playerid][slot2][pInvQ] > 10)
			{
				SendErrorMessage(playerid, "Tong so cua ca hai vat pham khi ket hop khong duoc vuot qua - 10. ");
				return cmd::inventory(playerid, "");
			}

			Inventory[playerid][slot2][pInvQ] += Inventory[playerid][slot1][pInvQ];
			SendSyntaxMessage(playerid, "Ban da hop nhat thanh cong %s (%i).", inventory_items[Inventory[playerid][slot2][pInvItem]][itemName], Inventory[playerid][slot2][pInvQ]);

			RemoveInvItem(playerid, Inventory[playerid][slot1][pInvItem], 0, slot1);
		}
	}

	return 1;
}

Dialog:DivideInvInt(playerid, response, listitem, inputtext[])
{
	if (!response) return cmd::inventory(playerid, "");

	new slot1 = GetPVarInt(playerid, #inventory_choose);
	
	if (CheckInv(playerid) == 0) 
		return SendErrorMessage(playerid, "Tui do da day.");
	if (strval(inputtext) <= 0 || strval(inputtext) >= Inventory[playerid][slot1][pInvQ]) 
		return SendErrorMessage(playerid, "Gia tri khong chinh xac.");

	SendSyntaxMessage(playerid, "Ban da chia thanh cong {ffc46a}%s{ffffff} tren %i va %i.", inventory_items[Inventory[playerid][slot1][pInvItem]][itemName], strval(inputtext), Inventory[playerid][slot1][pInvQ]-strval(inputtext));
	
	Inventory[playerid][slot1][pInvQ] -= strval(inputtext);

	new str[1] = EOS;
	GiveInvItem(playerid, Inventory[playerid][slot1][pInvItem], strval(inputtext), 0, 0, str, 1);
	return 1;
}

Dialog:DivideInvFloat(playerid, response, listitem, inputtext[])
{
	if (!response) return cmd::inventory(playerid, "");

	new slot1 = GetPVarInt(playerid, #inventory_choose);
	
	if (CheckInv(playerid) == 0)	return SendErrorMessage(playerid, "Tui do da day.");

	if (floatstr(inputtext) < 0.1 || floatstr(inputtext) >= Inventory[playerid][slot1][pInvQFloat])  
		return SendErrorMessage(playerid, "Gia tri khong chinh xac.");

	SendSyntaxMessage(playerid, "Ban da chia thanh cong {ffc46a}%s{ffffff} tren %.1fg va %.1fg.", inventory_items[Inventory[playerid][slot1][pInvItem]][itemName], floatstr(inputtext), Inventory[playerid][slot1][pInvQFloat]-floatstr(inputtext));
	
	Inventory[playerid][slot1][pInvQFloat] -= floatstr(inputtext);
	
	new str[1] = EOS;
	GiveFloatInvItem(playerid, Inventory[playerid][slot1][pInvItem], floatstr(inputtext), 0, 0, str, 1);
	return 1;
}

Dialog:PutItemInProperty(playerid, response, listitem, inputtext[])
{
	if (!response)	return cmd::inventory(playerid, "");

    new 
		slot = GetPVarInt(playerid, #inventory_choose), 
		houseid = GetPVarInt(playerid, #inventory_house)-1, 
		vehicle = GetPVarInt(playerid, #inventory_vehicle),
		item = Inventory[playerid][slot][pInvItem]
	;

	if (slot < 0 || slot > MAX_INV_SLOTS-1 || item == 0)	
		return cmd::inventory(playerid, "");
    if (strval(inputtext) < 1 || Inventory[playerid][slot][pInvQ] < strval(inputtext))	
		return SendErrorMessage(playerid, "Ban khong co nhieu. ");

	if (GetPVarInt(playerid, #inventory_vehicle) != 0)
	{
		if (vehicle > 0 && GetNearVehicle(playerid, 5.0, vehicle) != 0)
		{
			if (IsADontTrunk(vehicle) || IsAPlane(vehicle) || IsABiker(vehicle) || IsAHelicopter(vehicle) || IsABoat(vehicle) || IsABicycle(vehicle))		return SendErrorMessage(playerid, "Phuong tien nay khong co thung xe.");
			if (VehicleInfo[vehicle][carFaction] && VehicleInfo[vehicle][carFaction] != PlayerInfo[playerid][pFaction])										return SendErrorMessage(playerid, "Cop xe nay khong co cho ban. ");
			if (ValidWeaponForInventory(item) && PlayerInfo[playerid][pOnDuty] && VehicleInfo[vehicle][carOwnerID] != 0) 									return SendErrorMessage(playerid, "Ban khong the de vu khi trong xe ca nhan cua minh khi lam nhiem vu. ");
			if (IsPlayerInAnyVehicle(playerid) && VehicleInfo[vehicle][carFaction] && VehicleInfo[vehicle][carFaction] != PlayerInfo[playerid][pFaction]) 	return SendErrorMessage(playerid, "Ban phai dung ben thung xe. ");
			if (!IsPlayerInAnyVehicle(playerid) && !VehicleInfo[vehicle][carTrunkLock]) 																	return SendErrorMessage(playerid, "Thung xe nay da duoc dong lai. ");
			
			new i = GetNextVehicleTrunkSlot(vehicle);
			if (i == -1)	return SendErrorMessage(playerid, "Khong co cho trong xe.");

			TrunkInventory[vehicle][i][pInvItem] 	= Inventory[playerid][slot][pInvItem];
			TrunkInventory[vehicle][i][pInvQ] 		= Inventory[playerid][slot][pInvQ];
			TrunkInventory[vehicle][i][pInvEx] 		= Inventory[playerid][slot][pInvEx];
			TrunkInventory[vehicle][i][pInvS] 		= Inventory[playerid][slot][pInvS];
			TrunkInventory[vehicle][i][pInvQFloat]	= Inventory[playerid][slot][pInvQFloat];
			format(TrunkInventory[vehicle][i][pInvName],16, "%s", Inventory[playerid][slot][pInvName]);
						
			Inventory[playerid][slot][pInvQ] -= strval(inputtext);
						
			SM2(playerid, "Ban dat %s  trong %s.", inventory_items[item][itemName], VehicleNames[GetVehicleModel(vehicle)-400]);

			new mes[128];
			format(mes, sizeof(mes), "dat %s (%i) trong %s %s.", inventory_items[item][itemName], strval(inputtext), (VehicleInfo[vehicle][carFaction])?("fastening"):("trunk"), VehicleNames[GetVehicleModel(vehicle)-400]);
			SetPlayerChatBubble(playerid, mes, COLOR_PURPLE, 20.0, 4000);

			Save_CarInventory(vehicle);
			return cmd::inventory(playerid, "");
		}
	}

    else if (GetPVarInt(playerid, #inventory_vehicle) == 0 && IsPlayerInAnyVehicle(playerid))
	{
	    vehicle = GetPlayerVehicleID(playerid);
		if (VehicleInfo[vehicle][carOwnerID] != PlayerInfo[playerid][pID] && vehicle == 0) return cmd::inventory(playerid, "");
			
		if (ValidWeaponForInventory(item) && PlayerInfo[playerid][pOnDuty] && VehicleInfo[vehicle][carOwnerID] != 0) return SendErrorMessage(playerid, "Ban khong the de vu khi trong xe ca nhan cua minh khi lam nhiem vu.");

		new i = GetNextVehicleGBSlot(vehicle);
		if (i == -1)	return SendErrorMessage(playerid, "Khong co cho trong xe.");

		CarInventory[vehicle][i][pInvItem]		= Inventory[playerid][slot][pInvItem];
		CarInventory[vehicle][i][pInvQ]			= Inventory[playerid][slot][pInvQ];
		CarInventory[vehicle][i][pInvEx] 		= Inventory[playerid][slot][pInvEx];
		CarInventory[vehicle][i][pInvS]			= Inventory[playerid][slot][pInvS];
		CarInventory[vehicle][i][pInvQFloat]	= Inventory[playerid][slot][pInvQFloat];
		format(CarInventory[vehicle][i][pInvName],16, "%s", Inventory[playerid][slot][pInvName]);
						
		Inventory[playerid][slot][pInvQ] -= strval(inputtext);
						
		SM2(playerid, "Ban dat %s (%i) trong glove compartment %s.", inventory_items[item][itemName], strval(inputtext), VehicleNames[GetVehicleModel(vehicle)-400]);
		
		new mes[128];
		format(mes, sizeof(mes), "dat glove compartment trong %s %s.", inventory_items[item][itemName], VehicleNames[GetVehicleModel(vehicle)-400]);
		SetPlayerChatBubble(playerid, mes, COLOR_PURPLE, 20.0, 4000);

		Save_CarInventory(vehicle);
		return cmd::inventory(playerid, "");
	}

	else if (GetPVarInt(playerid, #inventory_house) != 0)
	{
		new i = GetNextHouseTrunkSlot(houseid);

		if ((houseid = GetNearInsideHouse(playerid)) != -1 && houseid >= 0 && houseid < MAX_HOUSES && PlayerToPoint(1, playerid,HouseInfo[houseid][hCheckPosX], HouseInfo[houseid][hCheckPosY], HouseInfo[houseid][hCheckPosZ]))
		{
			if (ValidWeaponForInventory(item) && PlayerInfo[playerid][pOnDuty]) return SendErrorMessage(playerid, "Ban khong the dat vu khi trong bo nho cache khi dang lam nhiem vu. ");

			if (i == -1)	return SendErrorMessage(playerid,"Khong co phong trong nha.");
			SM2(playerid, "Ban dat %s den secret house.", inventory_items[item][itemName]);

			HouseInventory[houseid][i][pInvItem] 	= Inventory[playerid][slot][pInvItem];
			HouseInventory[houseid][i][pInvQ]		= Inventory[playerid][slot][pInvQ];
			HouseInventory[houseid][i][pInvEx]		= Inventory[playerid][slot][pInvEx];
			HouseInventory[houseid][i][pInvS]		= Inventory[playerid][slot][pInvS];
			HouseInventory[houseid][i][pInvQFloat]	= Inventory[playerid][slot][pInvQFloat];
			format(HouseInventory[houseid][i][pInvName],16, "%s", Inventory[playerid][slot][pInvName]);
						
			Inventory[playerid][slot][pInvQ] -= strval(inputtext);
						
			new mes[128];
			format(mes, sizeof(mes), "dat %s (%i) den secret house.", inventory_items[item][itemName], strval(inputtext));
			SetPlayerChatBubble(playerid, mes, COLOR_PURPLE, 20.0, 4000);

			Save_HouseInventory(houseid);
			return cmd::inventory(playerid, "");
		}
	}

	else 
	{
		SendErrorMessage(playerid, "Rat tiec .. Da xay ra loi. Thu lai thao tac.");
		return cmd::inventory(playerid, "");
	}
	
	return 1;
}

Dialog:InventoryOther(playerid, response, listitem, inputtext[])
{
	if (!response)	return 1;

	new houseid = -1;

	if ((houseid = GetNearInsideHouse(playerid)) != -1 && houseid >= 0 && houseid < MAX_HOUSES && PlayerToPoint(1, playerid,HouseInfo[houseid][hCheckPosX], HouseInfo[houseid][hCheckPosY], HouseInfo[houseid][hCheckPosZ]))
	{
        if (!HouseInventory[houseid][listitem][pInvItem]) return 1;

        new item = HouseInventory[houseid][listitem][pInvItem];
		if (ValidWeaponForInventory(item) && PlayerInfo[playerid][pOnDuty])	
			return SendErrorMessage(playerid, "Ban khong the mang vu khi trong nha khi lam nhiem vu. ");
		if (GivePlayerInvItem(playerid, item, HouseInventory[houseid][listitem][pInvQ], HouseInventory[houseid][listitem][pInvQFloat], HouseInventory[houseid][listitem][pInvEx], HouseInventory[houseid][listitem][pInvS], HouseInventory[houseid][listitem][pInvName]) == -1) 
			return SendErrorMessage(playerid, "Tui do da day.");

        SendSyntaxMessage(playerid, "Ban lay %s tu kho nha.", inventory_items[item][itemName]);
		
		HouseInventory[houseid][listitem][pInvName] = EOS;
		HouseInventory[houseid][listitem][pInvQFloat] = 0.0;
        HouseInventory[houseid][listitem][pInvItem] = 
		HouseInventory[houseid][listitem][pInvQ] =
		HouseInventory[houseid][listitem][pInvEx] =
		HouseInventory[houseid][listitem][pInvS] = 0;

		Save_HouseInventory(houseid);

		new mes[128];
		format(mes, sizeof(mes), "lay %s tu kho nha.", inventory_items[item][itemName]);
		SetPlayerChatBubble(playerid, mes, COLOR_PURPLE, 20.0, 4000);
		return 1;
	}
	
	new vehicle = GetPlayerVehicleID(playerid);

	if (IsPlayerInAnyVehicle(playerid) && VehicleInfo[vehicle][carOwnerID] == PlayerInfo[playerid][pID])
	{
	    if (VehicleInfo[vehicle][carFaction] && VehicleInfo[vehicle][carFaction] != PlayerInfo[playerid][pFaction])	
			return SendErrorMessage(playerid, "Ngan dung gang tay cua phuong tien nay khong co san cho ban.");
        if (!CarInventory[vehicle][listitem][pInvItem])																
			return 1;

	    new item = CarInventory[vehicle][listitem][pInvItem];

		if (ValidWeaponForInventory(item) && PlayerInfo[playerid][pFaction] && VehicleInfo[vehicle][carFaction] != PlayerInfo[playerid][pFaction] && PlayerInfo[playerid][pOnDuty]) 	
			return SendErrorMessage(playerid, "Ban khong the lay vu khi tu xe khong thuoc phe dang lam nhiem vu.");
		if (GivePlayerInvItem(playerid, item, CarInventory[vehicle][listitem][pInvQ], CarInventory[vehicle][listitem][pInvQFloat], CarInventory[vehicle][listitem][pInvEx], CarInventory[vehicle][listitem][pInvS], CarInventory[vehicle][listitem][pInvName]) == -1) 
			return SendErrorMessage(playerid, "Tui do da day.");
		//if (IsValidDynamicObject(VehicleInfo[vehicle][carAttach][listitem])) DestroyDynamicObject(VehicleInfo[vehicle][carAttach][listitem]);

		CarInventory[vehicle][listitem][pInvName] = EOS;
		CarInventory[vehicle][listitem][pInvQFloat] = 0.0;
        CarInventory[vehicle][listitem][pInvItem] =
		CarInventory[vehicle][listitem][pInvS] =
		CarInventory[vehicle][listitem][pInvEx] =
		CarInventory[vehicle][listitem][pInvQ] = 0;
		
		Save_CarInventory(vehicle);

		new mes[128];
		format(mes, sizeof(mes), "keo ngan dung gang tay ra %s %s.", inventory_items[item][itemName], VehicleNames[GetVehicleModel(vehicle)-400]);
		SetPlayerChatBubble(playerid, mes, COLOR_PURPLE, 20.0, 4000);
	    return 1;
	}

	if ((vehicle = GetNearVehicle(playerid, 5.0)) != 0)
	{
		new item = TrunkInventory[vehicle][listitem][pInvItem];

	    if (IsADontTrunk(vehicle) || IsAPlane(vehicle) || IsABiker(vehicle) || IsAHelicopter(vehicle) || IsABoat(vehicle) || IsABicycle(vehicle))									return SendErrorMessage(playerid,"Phuong tien nay khong co thung xe.");
		if (VehicleInfo[vehicle][carFaction] && VehicleInfo[vehicle][carFaction] != PlayerInfo[playerid][pFaction])																	return SendErrorMessage(playerid, "Cop xe nay khong co cho ban.");
		if (ValidWeaponForInventory(item) && PlayerInfo[playerid][pOnDuty] && VehicleInfo[vehicle][carOwnerID] != 0) 																return SendErrorMessage(playerid, "Ban khong the de vu khi trong xe ca nhan cua minh khi lam nhiem vu. ");
		if (IsPlayerInAnyVehicle(playerid) && VehicleInfo[vehicle][carFaction] && VehicleInfo[vehicle][carFaction] != PlayerInfo[playerid][pFaction]) 								return SendErrorMessage(playerid, "Ban phai dung ben thung xe. ");
		if (!IsPlayerInAnyVehicle(playerid) && !VehicleInfo[vehicle][carTrunkLock]) 																									return SendErrorMessage(playerid, "Thung xe nay da duoc dong lai.");
        if (!TrunkInventory[vehicle][listitem][pInvItem])																																return cmd::inventory(playerid, "");
		if (ValidWeaponForInventory(item) && PlayerInfo[playerid][pFaction] && VehicleInfo[vehicle][carFaction] != PlayerInfo[playerid][pFaction] && PlayerInfo[playerid][pOnDuty]) 	return SendErrorMessage(playerid, "Ban khong the lay vu khi tu cac phuong tien khong thuoc phe dang lam nhiem vu. ");
		
		if (GivePlayerInvItem(playerid, item, TrunkInventory[vehicle][listitem][pInvQ], TrunkInventory[vehicle][listitem][pInvQFloat], TrunkInventory[vehicle][listitem][pInvEx], TrunkInventory[vehicle][listitem][pInvS], TrunkInventory[vehicle][listitem][pInvName]) == -1) 
			return SendErrorMessage(playerid, "Tui do da day.");
		if (IsValidDynamicObject(VehicleInfo[vehicle][carAttach][listitem])) 													
			DestroyDynamicObject(VehicleInfo[vehicle][carAttach][listitem]);

		TrunkInventory[vehicle][listitem][pInvName] = EOS;
		TrunkInventory[vehicle][listitem][pInvQFloat] = 0.0;
        TrunkInventory[vehicle][listitem][pInvItem] =
		TrunkInventory[vehicle][listitem][pInvS] =
		TrunkInventory[vehicle][listitem][pInvEx] =
		TrunkInventory[vehicle][listitem][pInvQ] = 0;

		Save_CarInventory(vehicle);

		new mes[128];
		format(mes, sizeof(mes), "keo %s khoi %s %s.", inventory_items[item][itemName], (VehicleInfo[vehicle][carFaction])?("fastenings"):("trunk"), VehicleNames[GetVehicleModel(vehicle)-400]);
		SetPlayerChatBubble(playerid, mes, COLOR_PURPLE, 20.0, 4000);
	    return 1;
	}
	
	cmd::inventory(playerid, "");
	return 1;
}

Dialog:DeleteItem(playerid, response, listitem, inputtext[])
{
	if (!response)	return cmd::inventory(playerid, "");

    new slot = GetPVarInt(playerid, #inventory_choose);

	if (slot < 0 || slot > MAX_INV_SLOTS-1 || Inventory[playerid][slot][pInvItem] == 0)	return cmd::inventory(playerid, "");
	if (Inventory[playerid][slot][pInvItem] == 21 && maskOn{playerid}) cmd::mask(playerid, ""); 

	SendLocalMessage(Range_Normal, playerid, COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5, "** (( %s xoa vat pham %s khoi tui do. ))", GetNameWithMask(playerid), inventory_items[Inventory[playerid][slot][pInvItem]][itemName]);

	RemoveInvItem(playerid, Inventory[playerid][slot][pInvItem], 0, slot);
	return 1;
}

Dialog:GiveItem(playerid, response, listitem, inputtext[])
{
	if (!response)	return cmd::inventory(playerid, "");

    new slot = GetPVarInt(playerid, #inventory_choose);

	if (slot < 0 || slot > MAX_INV_SLOTS-1 || Inventory[playerid][slot][pInvItem] == 0)	return cmd::inventory(playerid, "");

	new userid;

    if (sscanf(inputtext, "u", userid))	return Dialog_Show(playerid, GiveItem, DIALOG_STYLE_INPUT, "{FFFFFF}Chuyen vat pham", "{ffffff}Nhap ten hoac ID cua nguoi choi ban muon chuyen Vat pham:", ">>>", "Quay lai");

    if (!IsPlayerLogged(userid))						return SendNotConnected(playerid);
	if (!PlayerNearPlayer(3.0, playerid, userid))	return SendNotNearPlayer(playerid);
	if (playerid == userid)							return SendErrorMessage(playerid, "Ban khong the chuyen muc cho chinh minh.");

	if (inventory_items[Inventory[playerid][slot][pInvItem]][itemSplit] == 0 || Inventory[playerid][slot][pInvQFloat] == 0.1)
	{
		switch(Inventory[playerid][slot][pInvItem])
		{
			case 22..34: // WEAPON
			{
				if (PlayerInfo[playerid][pOnDuty])				return SendErrorMessage(playerid, "Chuc nang nay khong kha dung khi lam viec.");
				if (GiveInvItem(userid, Inventory[playerid][slot][pInvItem], Inventory[playerid][slot][pInvQ], Inventory[playerid][slot][pInvEx], Inventory[playerid][slot][pInvS]) == -1)
					return SendErrorMessage(playerid, "Tui do da day.");

				new str[128];
				format(str, sizeof(str), "lay %s va dua cho %s.", inventory_items[Inventory[playerid][slot][pInvItem]][itemName], GetNameWithMask(userid));
				SetPlayerChatBubble(playerid, str, COLOR_PURPLE, 20.0, 4000);

				SM1(userid, "%s da dua cho ban  %s.", GetNameWithMask(playerid), inventory_items[Inventory[playerid][slot][pInvItem]][itemName]);
				SM1(playerid, "Ban da dua %s %s.", GetNameWithMask(userid), inventory_items[Inventory[playerid][slot][pInvItem]][itemName]);
					
				RemoveInvItem(playerid, Inventory[playerid][slot][pInvItem], 0, slot);
			}
			case INV_GANJA, INV_MED_GANJA, 103 .. 118: // �������� � �����
			{
				if (GiveFloatInvItem(userid, Inventory[playerid][slot][pInvItem], Inventory[playerid][slot][pInvQFloat]) == -1)	return SendErrorMessage(playerid, "Tui do da day!");

				new str[128];
				format(str, sizeof(str), "lay ra %s va dua cho %s.", inventory_items[Inventory[playerid][slot][pInvItem]][itemName], GetNameWithMask(userid));
				SetPlayerChatBubble(playerid, str, COLOR_PURPLE, 20.0, 4000);

				SM1(userid, "%s da dua cho ban %s (%.1fg).", GetNameWithMask(playerid), inventory_items[Inventory[playerid][slot][pInvItem]][itemName], Inventory[playerid][slot][pInvQFloat]);
				SM1(playerid, "Ban da dua %s %s (%.1fg).", GetNameWithMask(userid), inventory_items[Inventory[playerid][slot][pInvItem]][itemName], Inventory[playerid][slot][pInvQFloat]);
				
				RemoveFloatInvItem(playerid, Inventory[playerid][slot][pInvItem], 0, slot);
			}
			case INV_DRUG: // ���������
			{
				if (GiveDrugInvItem(userid, Inventory[playerid][slot][pInvName], Inventory[playerid][slot][pInvQFloat], Inventory[playerid][slot][pInvEx], Inventory[playerid][slot][pInvS]) == -1)	return SendErrorMessage(playerid, "Tui do da day!");

				new str[128];
				format(str, sizeof(str), "lay ra %s va dua cho %s.", Inventory[playerid][slot][pInvName], GetNameWithMask(userid));
				SetPlayerChatBubble(playerid, str, COLOR_PURPLE, 20.0, 4000);

				SM1(userid, "%s dua cho ban %s (%.1fg).", GetNameWithMask(playerid), Inventory[playerid][slot][pInvName], Inventory[playerid][slot][pInvQFloat]);
				SM1(playerid, "Ban da dua %s %s (%.1fg).", GetNameWithMask(userid), Inventory[playerid][slot][pInvName], Inventory[playerid][slot][pInvQFloat]);
				
				RemoveFloatInvItem(playerid, Inventory[playerid][slot][pInvItem], 0, slot);
			}
			default:
			{
				if (GiveInvItem(userid, Inventory[playerid][slot][pInvItem], Inventory[playerid][slot][pInvQ]) == -1)	return SendErrorMessage(playerid, "Tui do da day!");
				RemoveInvItem(playerid, Inventory[playerid][slot][pInvItem], 0, slot);

				new str[128];
				format(str, sizeof(str), "lay ra %s va dua cho %s.", inventory_items[Inventory[playerid][slot][pInvItem]][itemName], GetNameWithMask(userid));
				SetPlayerChatBubble(playerid, str, COLOR_PURPLE, 20.0, 4000);

				SM1(userid, "%s da dua cho ban %s.", GetNameWithMask(playerid), inventory_items[Inventory[playerid][slot][pInvItem]][itemName]);
				SM1(playerid, "Ban da dua %s %s.", GetNameWithMask(userid), inventory_items[Inventory[playerid][slot][pInvItem]][itemName]);
					
				
			}
		}
	
	    return 1;
	}

	SetPVarInt(playerid, #give_item, userid);

	new mes[256];
	format(mes, sizeof(mes), "{ffffff}Vat pham: %s (So luong: %i)\n\nNhap so luong ban muon chuyen cho nguoi choi %s:", inventory_items[Inventory[playerid][slot][pInvItem]][itemName], Inventory[playerid][slot][pInvQ], GetNameWithMask(userid));
	Dialog_Show(playerid, GiveQuantity, DIALOG_STYLE_INPUT, "Release item", mes, "Release", "Huy");
	return 1;
}

Dialog:GiveQuantity(playerid, response, listitem, inputtext[])
{
	if (!response)									return cmd::inventory(playerid, "");

	new slot = GetPVarInt(playerid, #inventory_choose),	userid = GetPVarInt(playerid, #give_item);
	
	if (!IsPlayerLogged(userid))						return SendNotConnected(playerid);
	if (!PlayerNearPlayer(3.0, playerid, userid))	return SendNotNearPlayer(playerid);
    if (playerid == userid)							return SendErrorMessage(playerid, "Ban khong the chuyen muc cho chinh minh.");

	if (slot < 0 || slot > MAX_INV_SLOTS-1 || Inventory[playerid][slot][pInvItem] == 0)	return cmd::inventory(playerid, "");

	switch(Inventory[playerid][slot][pInvItem])
	{
		case 22..34: // WEAPON
		{
			return 1;
		}
		case INV_GANJA, INV_MED_GANJA, 103 .. 118: // �������� � �����
		{
			format(inputtext, 5, "%.1f", floatstr(inputtext));
			new Float:amount = floatstr(inputtext);
	
			if (amount < 0.1 || Inventory[playerid][slot][pInvQFloat] < amount)
			{
				SendErrorMessage(playerid, "Ban khong co nhieu. ");

				new mes[256];
				format(mes, sizeof(mes), "{ffffff}Vat pham: %s (So luong: %i)\n\nNhap so luong ban muon chuyen cho nguoi choi %s:", inventory_items[Inventory[playerid][slot][pInvItem]][itemName], Inventory[playerid][slot][pInvQ], GetNameWithMask(userid));
				Dialog_Show(playerid, GiveQuantity, DIALOG_STYLE_INPUT, "Release item", mes, "Release", "Huy");
				return 1;
			}

			if (GiveFloatInvItem(userid, Inventory[playerid][slot][pInvItem], amount) == -1)	return SendErrorMessage(playerid, "Tui do da day!");

			new str[128];
			format(str, sizeof(str), "lay ra %s va dua cho %s.", inventory_items[Inventory[playerid][slot][pInvItem]][itemName], GetNameWithMask(userid));
			SetPlayerChatBubble(playerid, str, COLOR_PURPLE, 20.0, 4000);

			SM1(userid, "%s da dua cho ban %s (%.1fg).", GetNameWithMask(playerid), inventory_items[Inventory[playerid][slot][pInvItem]][itemName], amount);
			SM1(playerid, "Ban da dua %s %s (%.1fg).", GetNameWithMask(userid), inventory_items[Inventory[playerid][slot][pInvItem]][itemName], amount);
			
			new query[256];
			format(query, sizeof(query), "%s [MYSQL: %i | IP: %s] conveyed %s (So luong: %i) player %s [MYSQL: %i | IP: %s]",
				GetNameEx(playerid), PlayerInfo[playerid][pID], q_GetPlayerIP(playerid), inventory_items[Inventory[playerid][slot][pInvItem]][itemName], amount, GetNameEx(userid), PlayerInfo[userid][pID], q_GetPlayerIP(userid));
			insert_log(query, ITEM_LOG, 3, PlayerInfo[playerid][pAccID], PlayerInfo[userid][pAccID]);

			RemoveFloatInvItem(playerid, Inventory[playerid][slot][pInvItem], amount, slot);
		}
		case INV_DRUG: // ���������
		{
			format(inputtext, 5, "%.1f", floatstr(inputtext));
			new Float:amount = floatstr(inputtext);

			if (amount < 0.1 || Inventory[playerid][slot][pInvQFloat] < amount)
			{
				SendErrorMessage(playerid, "Ban khong co nhieu. ");

				new mes[256];
				format(mes, sizeof(mes), "{ffffff}Vat pham: %s (So luong: %i)\n\nNhap so luong ban muon chuyen cho nguoi choi %s:", inventory_items[Inventory[playerid][slot][pInvItem]][itemName], Inventory[playerid][slot][pInvQ], GetNameWithMask(userid));
				Dialog_Show(playerid, GiveQuantity, DIALOG_STYLE_INPUT, " item", mes, "Release", "Huy");
				return 1;
			}
			
			if (GiveDrugInvItem(userid, Inventory[playerid][slot][pInvName], amount, Inventory[playerid][slot][pInvEx], Inventory[playerid][slot][pInvS]) == -1)	return SendErrorMessage(playerid, "Tui do da day!");

			new str[128];
			format(str, sizeof(str), "lay ra %s va dua cho %s.", Inventory[playerid][slot][pInvName], GetNameWithMask(userid));
			SetPlayerChatBubble(playerid, str, COLOR_PURPLE, 20.0, 4000);

			SM1(userid, "%s da dua cho ban %s (%.1fg).", GetNameWithMask(playerid), Inventory[playerid][slot][pInvName], amount);
			SM1(playerid, "Ban da dua %s %s (%.1fg).", GetNameWithMask(userid), Inventory[playerid][slot][pInvName], amount);
			
			new query[256];
			format(query, sizeof(query), "%s [MYSQL: %i | IP: %s] conveyed %s [drug] (So luong: %i / OAS: %i%%) player %s [MYSQL: %i | IP: %s]",
				GetNameEx(playerid), PlayerInfo[playerid][pID], q_GetPlayerIP(playerid), Inventory[playerid][slot][pInvName], amount, Inventory[playerid][slot][pInvEx], GetNameEx(userid), PlayerInfo[userid][pID], q_GetPlayerIP(userid));
			insert_log(query, ITEM_LOG, 3, PlayerInfo[playerid][pAccID], PlayerInfo[userid][pAccID]);

			RemoveFloatInvItem(playerid, Inventory[playerid][slot][pInvItem], amount, slot);
		}
		default: // 
		{
			if (strval(inputtext) < 1 || Inventory[playerid][slot][pInvQ] < strval(inputtext))
			{
				SendErrorMessage(playerid, "Ban khong co nhieu. ");

				new mes[256];
				format(mes, sizeof(mes), "{ffffff}Vat pham: %s (So luong: %i)\n\nNhap so luong ban muon chuyen cho nguoi choi %s:", inventory_items[Inventory[playerid][slot][pInvItem]][itemName], Inventory[playerid][slot][pInvQ], GetNameWithMask(userid));
				Dialog_Show(playerid, GiveQuantity, DIALOG_STYLE_INPUT, "Release item", mes, "Release", "Huy");
				return 1;
			}
		
			if (GiveInvItem(userid, Inventory[playerid][slot][pInvItem], strval(inputtext)) == -1)	return SendErrorMessage(playerid, "Tui do da day!");
			new str[128];
			format(str, sizeof(str), "lay ra %s va dua %s.", inventory_items[Inventory[playerid][slot][pInvItem]][itemName], GetNameWithMask(userid));
			SetPlayerChatBubble(playerid, str, COLOR_PURPLE, 20.0, 4000);

			SM1(userid, "%s da dua cho ban %s [quantity: %i].", GetNameWithMask(playerid), inventory_items[Inventory[playerid][slot][pInvItem]][itemName], strval(inputtext));
			SM1(playerid, "Ban da dua %s %s [quantity: %i].", GetNameWithMask(userid), inventory_items[Inventory[playerid][slot][pInvItem]][itemName], strval(inputtext));
			
			new query[128];
			format(query, sizeof(query), "%s [MYSQL: %i | IP: %s] conveyed %s (So luong: %i) player %s [MYSQL: %i | IP: %s]",
				GetNameEx(playerid), PlayerInfo[playerid][pID], q_GetPlayerIP(playerid), inventory_items[Inventory[playerid][slot][pInvItem]][itemName], strval(inputtext), GetNameEx(userid), PlayerInfo[userid][pID], q_GetPlayerIP(userid));
			insert_log(query, ITEM_LOG, 3, PlayerInfo[playerid][pAccID], PlayerInfo[userid][pAccID]);

			RemoveInvItem(playerid, Inventory[playerid][slot][pInvItem], strval(inputtext), slot);
		}
	}

	return 1;
}

Dialog:InventoryMenu(playerid, response, listitem, inputtext[])
{
	if (!response)	return 1;
	
	switch(listitem)
	{
		case 0: return PrintInv(playerid);
		case 1:
		{
			new houseid;
			if ((houseid = GetNearHouse(playerid)) != -1 && HouseInfo[houseid][hOwnerID] == PlayerInfo[playerid][pID] && PlayerToPoint(1, playerid,HouseInfo[houseid][hCheckPosX], HouseInfo[houseid][hCheckPosY], HouseInfo[houseid][hCheckPosZ]))
			{
				return PrintHouseInv(playerid, houseid);
			}

			new vehicle = GetNearVehicle(playerid, 4.0);
			if (vehicle != 0 && (!IsADontTrunk(vehicle) || !IsAPlane(vehicle) || !IsABiker(vehicle) || !IsAHelicopter(vehicle) || !IsABoat(vehicle) || !IsABicycle(vehicle)))
			{
				if ((VehicleInfo[vehicle][carTrunkLock] && !IsPlayerInAnyVehicle(playerid)) || (IsPlayerInAnyVehicle(playerid) && VehicleInfo[vehicle][carFaction] && VehicleInfo[vehicle][carFaction] == PlayerInfo[playerid][pFaction]))
				{
					return PrintVehInv(playerid, vehicle);
				}
			}
			
			vehicle = GetPlayerVehicleID(playerid);
			if (IsPlayerInAnyVehicle(playerid) && vehicle != 0 && VehicleInfo[vehicle][carOwnerID] == PlayerInfo[playerid][pID])
			{
				return PrintGBInv(playerid, vehicle);
			}
		}
	}

	SendErrorMessage(playerid, "Rat tiec .. Da xay ra loi. Thu lai thao tac.");
	return 1;
}