Dialog:VehicleATT(playerid, response, listitem, inputtext[])
{
	if(!response) return 1;
	
	switch(listitem)
	{
		case 0: // Spoilers
		{
			new List:spoilers = list_new(), vehicle = GetPlayerVehicleID(playerid), slots = GetNextVehicleAttSlot(vehicle);
			if (slots == -1)		return SendErrorMessage(playerid, "Tat ca cac vi tri phu kien cua xe da bi chiem dung.");
			SetPVarInt(playerid, #veh_editor, vehicle);
			SetPVarInt(playerid, #veh_slot, slots);
			for(new i = 0; i < sizeof(car_spoilers); i++)
			{
				AddModelMenuItem(spoilers, car_spoilers[i]);
			}
			ShowModelSelectionMenu(playerid, "Spoilers", VEHICLE_SPOILERS, spoilers);		
		}
		case 1: // Rear Bumpers
		{
			new List:rearbumpers = list_new(), vehicle = GetPlayerVehicleID(playerid), slots = GetNextVehicleAttSlot(vehicle);
			if (slots == -1)		return SendErrorMessage(playerid, "Tat ca cac vi tri phu kien cua xe da bi chiem dung.");
			SetPVarInt(playerid, #veh_editor, vehicle);
			SetPVarInt(playerid, #veh_slot, slots);
			for(new i = 0; i < sizeof(car_rearbumper); i++)
			{
				AddModelMenuItem(rearbumpers, car_rearbumper[i]);
			}
			ShowModelSelectionMenu(playerid, "Rear Bumpers", VEHICLE_REARBUMPER, rearbumpers);		
		}
		case 2: // Front Bumpers
		{
			new List:frontbumpers = list_new(), vehicle = GetPlayerVehicleID(playerid), slots = GetNextVehicleAttSlot(vehicle);
			if (slots == -1)		return SendErrorMessage(playerid, "Tat ca cac vi tri phu kien cua xe da bi chiem dung.");
			SetPVarInt(playerid, #veh_editor, vehicle);
			SetPVarInt(playerid, #veh_slot, slots);
			for(new i = 0; i < sizeof(car_frontbumper); i++)
			{
				AddModelMenuItem(frontbumpers, car_frontbumper[i]);
			}
			ShowModelSelectionMenu(playerid, "Front Bumpers", VEHICLE_FRONTBUMPER, frontbumpers);		
		}
		case 3: // Left Side Skirts
		{
			new List:leftsideskirt = list_new(), vehicle = GetPlayerVehicleID(playerid), slots = GetNextVehicleAttSlot(vehicle);
			if (slots == -1)		return SendErrorMessage(playerid, "Tat ca cac vi tri phu kien cua xe da bi chiem dung.");
			SetPVarInt(playerid, #veh_editor, vehicle);
			SetPVarInt(playerid, #veh_slot, slots);
			for(new i = 0; i < sizeof(car_sideskirtsleft); i++)
			{
				AddModelMenuItem(leftsideskirt, car_sideskirtsleft[i]);
			}
			ShowModelSelectionMenu(playerid, "Left Side Skirs", VEHICLE_SIDESKIRTL, leftsideskirt);		
		}
		case 4: // Right Side Skirts
		{
			new List:rightsideskirt = list_new(), vehicle = GetPlayerVehicleID(playerid), slots = GetNextVehicleAttSlot(vehicle);
			if (slots == -1)		return SendErrorMessage(playerid, "Tat ca cac vi tri phu kien cua xe da bi chiem dung.");
			SetPVarInt(playerid, #veh_editor, vehicle);
			SetPVarInt(playerid, #veh_slot, slots);
			for(new i = 0; i < sizeof(car_sideskirtsright); i++)
			{
				AddModelMenuItem(rightsideskirt, car_sideskirtsright[i]);
			}
			ShowModelSelectionMenu(playerid, "Right Side Skirts", VEHICLE_SIDESKIRTR, rightsideskirt);		
		}
	}
	return 1;
}
Dialog:Clothing(playerid, response, listitem, inputtext[])
{
	if (!response) return 1;

	new string[128], count;

	for(new i = 0; i < MAX_PLAYER_ATTACH; i++)
	{
	    if (AttachInfo[playerid][i][aID] == 0) continue;
		if (count == listitem)
		{
		    listitem = i;
		    break;
		}
		count++;
	}

	SetPVarInt(playerid, #edit_slot_attach, listitem);

	format(string, sizeof(string), "%s\nChinh sua\nXoa bo", (AttachInfo[playerid][listitem][aUsed]) ? ("Xoa bo") : ("Dinh kem"));
	Dialog_Show(playerid, Clothing1, DIALOG_STYLE_LIST, AttachInfo[playerid][listitem][aName], string, "Chon", "Dong");
	return 1;
}

Dialog:Clothing1(playerid, response, listitem, inputtext[])
{
	if (!response) return 1;

    new slot = GetPVarInt(playerid, #edit_slot_attach);

	switch(listitem)
	{
		case 0:
		{
			if (IsPlayerAttachedObjectSlotUsed(playerid, slot))
			{
				InfoMSG(playerid, "~w~Ban da ~r~xoa bo~w~ quan ao", 5);
				RemovePlayerAttachedObject(playerid, slot);
				AttachInfo[playerid][slot][aUsed] = 0;

				new query[128];
				mysql_format(dbHandle, query, sizeof(query), "UPDATE `player_attach` SET `used`=0 WHERE `id` = %i", AttachInfo[playerid][slot][aID]);
				mysql_tquery(dbHandle, query);
			}
			else
			{
				InfoMSG(playerid, "~w~Ban da ~g~dat~w~ quan ao", 5);
				AttachInfo[playerid][slot][aUsed] = 1;
				SetPlayerAttachedObject(playerid, slot, AttachInfo[playerid][slot][aModel], AttachInfo[playerid][slot][aBone], AttachInfo[playerid][slot][aOffsetX], AttachInfo[playerid][slot][aOffsetY], AttachInfo[playerid][slot][aOffsetZ], AttachInfo[playerid][slot][aRotX], AttachInfo[playerid][slot][aRotY], AttachInfo[playerid][slot][aRotZ], AttachInfo[playerid][slot][aScaleX], AttachInfo[playerid][slot][aScaleY], AttachInfo[playerid][slot][aScaleZ]);

                new query[128];
				mysql_format(dbHandle, query, sizeof(query), "UPDATE `player_attach` SET `used`=1 WHERE `id` = %i", AttachInfo[playerid][slot][aID]);
				mysql_tquery(dbHandle, query);
			}
			cmd::clothing(playerid, "");
		}
		case 1:
		{
			if (!IsPlayerAttachedObjectSlotUsed(playerid, slot))		return SendErrorMessage(playerid, "Mot doi tuong tu vi tri nay khong duoc cai dat.");
			if (GetPVarInt(playerid, #edit_attach) == 1)				return SendErrorMessage(playerid, "Ban dang chinh sua doi tuong, hay hoan tat chinh sua de bat dau mot doi tuong moi.");

            Dialog_Show(playerid, SelectEditBone, DIALOG_STYLE_LIST, "Bo phan cua co the","- Giu nguyen\n1: Lung\n2: Dau\n3: Vai trai\n4: Vai phai\n5: Tay trai\n6:Tay phai\n7: Dui trai\n8: Dui phai\n9: Chan trai\n10: Chan phai\n11: Bap chan phai\n12: Bap chan trai\n13: Canh tay trai\n14: Canh tay phai\n15: Xuong don trai\n16: Xuong don phai\n17: Co\n18: Ham","Chon","Huy bo");
		}
		case 2:
		{
			InfoMSG(playerid, "~w~Ban da ~r~xoa bo~w~ quan ao", 5);
			RemovePlayerAttachFromSlot(playerid, slot);
		}
	}
	return 1;
}

Dialog:ClothesCategory(playerid, response, listitem, inputtext[])
{
	new str[1024];

	if (!response)	return 1;

	switch(listitem)
	{
		case 0:
		{
			for(new x;x<sizeof(HatsInfo);x++)
			{
				format(str, sizeof(str), "%s%s - $%i\n", str, HatsInfo[x][toyName], HatsInfo[x][toyPrice]);
			}
			Dialog_Show(playerid, HatsDialog, DIALOG_STYLE_LIST, "Chon san pham ban can", str, "Chon", "Dong");
		}
		case 1:
		{
			for(new x;x<sizeof(GlassesInfo);x++)
			{
				format(str, sizeof(str), "%s%s - $%i\n", str, GlassesInfo[x][toyName], GlassesInfo[x][toyPrice]);
			}
			Dialog_Show(playerid, GlassesDialog, DIALOG_STYLE_LIST, "Chon san pham ban can", str, "Chon", "Dong");
		}
		case 2:
		{
			for(new x;x<sizeof(BandanasInfo);x++)
			{
				format(str, sizeof(str), "%s%s - $%i\n", str, BandanasInfo[x][toyName], BandanasInfo[x][toyPrice]);
			}
			Dialog_Show(playerid, BandanasDialog, DIALOG_STYLE_LIST, "Chon san pham ban can", str, "Chon", "Dong");
		}
		case 3:
		{
			printf("sizoef headphone: %d",sizeof(HeadphonesInfo));
			for(new x;x<sizeof(HeadphonesInfo);x++)
			{
				format(str, sizeof(str), "%s%s - $%i\n", str, HeadphonesInfo[x][toyName], HeadphonesInfo[x][toyPrice]);
			}
			Dialog_Show(playerid, HeadphonesDialog, DIALOG_STYLE_LIST, "Chon san pham ban can", str, "Chon", "Dong");
		}
	}
	return 1;
}

Dialog:SelectEditBone(playerid, response, listitem, inputtext[])
{
	if (!response)	return cmd::clothing(playerid, "");

    new slot = GetPVarInt(playerid, #edit_slot_attach);

	if (!IsPlayerAttachedObjectSlotUsed(playerid, slot))	return SendErrorMessage(playerid, "Ban chua cai dat mot doi tuong cho vi tri nay. ");
	if (GetPVarInt(playerid, #edit_attach) == 1)			return SendErrorMessage(playerid, "Ban dang chinh sua doi tuong, hay hoan tat chinh sua de bat dau mot doi tuong moi. ");

	if (listitem != 0)
	{
	    RemovePlayerAttachedObject(playerid, slot);
		SetPlayerAttachedObject(playerid, slot, AttachInfo[playerid][slot][aModel], listitem);
	}

	InfoMSG(playerid, "~w~ Ban dang ~y~ chinh sua ~w~ doi tuong tren nhan vat", 5);
	SetPVarInt(playerid, #edit_attach, 1);
	EditAttachedObject(playerid, slot);
	return 1;
}

Dialog:SelectBone(playerid, response, listitem, inputtext[])
{
	if (!response) return 1;

    new faction = PlayerInfo[playerid][pFaction];

   	if (!IsFactionLegal(faction))	return SendErrorMessage(playerid, "Ban phai la canh sat / nhan vien trai giam. ");

    new i = -1;

	if ((i = GetNextToySlot(playerid)) == -1)	return SendErrorMessage(playerid, "Tat ca vi tri quan ao da duoc su dung.");

    new index = GetPVarInt(playerid, #select_attach);

	if (IsFactionMedic(faction) || IsFactionFire(faction))
	{
	    SetPlayerAttachedObject(playerid, i, attach_fd_model[index], listitem+1);
		EditAttachedObject(playerid, i);
		InsertPlayerAttach(playerid, i, attach_fd_model[index], listitem+1, attach_fd_name[index]);
		SetPVarInt(playerid, #edit_faction, 1);
	}
	else if (IsFactionCity(faction))
	{
	    SetPlayerAttachedObject(playerid, i, attach_city_model[index], listitem+1);
		EditAttachedObject(playerid, i);
		InsertPlayerAttach(playerid, i, attach_city_model[index], listitem+1, attach_city_name[index]);
		SetPVarInt(playerid, #edit_faction, 1);
	}
	else
	{
		SetPlayerAttachedObject(playerid, i, attach_police_model[index], listitem+1);
		EditAttachedObject(playerid, i);
		InsertPlayerAttach(playerid, i, attach_police_model[index], listitem+1, attach_police_name[index]);
		SetPVarInt(playerid, #edit_faction, 1);
	}
	return 1;
}

Dialog:BizAttachDialog(playerid, response, listitem, inputtext[])
{
	if (!response)	return 1;

	new string[1024];

	switch(listitem) {
        case 0: {	// ����������� �����������
            for(new x; x < sizeof(GuitarsInfo); x++)
            {
                format(string, sizeof(string), "%s%s - $%i\n", string, GuitarsInfo[x][toyName], GuitarsInfo[x][toyPrice]);
            }
            Dialog_Show(playerid, GuitarsDialog, DIALOG_STYLE_LIST, "{FFFFFF}Chon mot san pham", string, "Chon", "Dong");
        }
        case 1: {	// ����
            for(new x; x < sizeof(ClockInfo); x++)
            {
                format(string, sizeof(string), "%s%s - $%i\n", string, ClockInfo[x][toyName], ClockInfo[x][toyPrice]);
            }
            Dialog_Show(playerid, ClockDialog, DIALOG_STYLE_LIST, "{FFFFFF}Chon mot san pham", string, "Chon", "Dong");
        }
        case 2: {	// �����������
            for(new x; x < sizeof(HardwareStore); x++)
            {
                format(string, sizeof(string), "%s%s - $%i\n", string, HardwareStore[x][toyName], HardwareStore[x][toyPrice]);
            }
            Dialog_Show(playerid, HardwareStore, DIALOG_STYLE_LIST, "{FFFFFF}Chon mot san pham", string, "Chon", "Dong");
        }
        case 3: {	// ��������������
            for(new x; x < sizeof(SportsInfo); x++)
            {
                format(string, sizeof(string), "%s%s - $%i\n", string, SportsInfo[x][toyName], SportsInfo[x][toyPrice]);
            }
            Dialog_Show(playerid, SportsDialog, DIALOG_STYLE_LIST, "{FFFFFF}Chon mot san pham", string, "Buy", "Dong");
        }
        case 4: {	// ����������
            Dialog_Show(playerid, ClothesCategory, DIALOG_STYLE_LIST, "{FFFFFF}Chon mot danh muc", "Mu non\nKinh\nBandanas\nTai nghe", "Chon", "Dong");
        }
    }
	return 1;
}

Dialog:HatsDialog(playerid, response, listitem, inputtext[])
{
    if (!response)	return 1;

	new i = -1;

	if ((i = GetNextToySlot(playerid)) == -1)				return SendErrorMessage(playerid, "Tat ca vi tri quan ao da duoc chinh sua.");
    if (GetCash(playerid) < HatsInfo[listitem][toyPrice])	return SendNotCash(playerid);

	SetPlayerAttachedObject(playerid, i, HatsInfo[listitem][toyModel], HatsInfo[listitem][toyBone], HatsInfo[listitem][toyOffestX], HatsInfo[listitem][toyOffestY], HatsInfo[listitem][toyOffestZ], HatsInfo[listitem][toyRotX], 
	HatsInfo[listitem][toyRotY], HatsInfo[listitem][toyRotZ], HatsInfo[listitem][toyScaleX], HatsInfo[listitem][toyScaleY], HatsInfo[listitem][toyScaleZ]);
    EditAttachedObject(playerid, i);
	SetPVarInt(playerid, #buy_attach, HatsInfo[listitem][toyPrice]);
	InsertPlayerAttach(playerid, i, HatsInfo[listitem][toyModel], HatsInfo[listitem][toyBone], HatsInfo[listitem][toyName]);
	return 1;
}

Dialog:GlassesDialog(playerid, response, listitem, inputtext[])
{
	if (!response)	return 1;

	new i = -1;

	if ((i = GetNextToySlot(playerid)) == -1)				return SendErrorMessage(playerid, "Tat ca vi tri quan ao da duoc chinh sua.");
    if (GetCash(playerid) < GlassesInfo[listitem][toyPrice])	return SendNotCash(playerid);

	SetPlayerAttachedObject(playerid, i, GlassesInfo[listitem][toyModel], GlassesInfo[listitem][toyBone], GlassesInfo[listitem][toyOffestX], GlassesInfo[listitem][toyOffestY], GlassesInfo[listitem][toyOffestZ],
	GlassesInfo[listitem][toyRotX], GlassesInfo[listitem][toyRotY], GlassesInfo[listitem][toyRotZ], GlassesInfo[listitem][toyScaleX], GlassesInfo[listitem][toyScaleY], GlassesInfo[listitem][toyScaleZ]);
    EditAttachedObject(playerid, i);
	SetPVarInt(playerid, #buy_attach, GlassesInfo[listitem][toyPrice]);
	InsertPlayerAttach(playerid, i, GlassesInfo[listitem][toyModel], GlassesInfo[listitem][toyBone], GlassesInfo[listitem][toyName]);
	return 1;
}

Dialog:BandanasDialog(playerid, response, listitem, inputtext[])
{
	if (!response)	return 1;

	new i = -1;

	if ((i = GetNextToySlot(playerid)) == -1)					return SendErrorMessage(playerid, "Tat ca vi tri quan ao da duoc chinh sua.");
    if (GetCash(playerid) < BandanasInfo[listitem][toyPrice])	return SendNotCash(playerid);

	SetPlayerAttachedObject(playerid, i, BandanasInfo[listitem][toyModel], BandanasInfo[listitem][toyBone], BandanasInfo[listitem][toyOffestX], BandanasInfo[listitem][toyOffestY], BandanasInfo[listitem][toyOffestZ], 
	BandanasInfo[listitem][toyRotX], BandanasInfo[listitem][toyRotY], BandanasInfo[listitem][toyRotZ], BandanasInfo[listitem][toyScaleX], BandanasInfo[listitem][toyScaleY], BandanasInfo[listitem][toyScaleZ]);
    EditAttachedObject(playerid, i);
	SetPVarInt(playerid, #buy_attach, BandanasInfo[listitem][toyPrice]);
	InsertPlayerAttach(playerid, i, BandanasInfo[listitem][toyModel], BandanasInfo[listitem][toyBone], BandanasInfo[listitem][toyName]);
	return 1;
}
Dialog:HeadphonesDialog(playerid, response, listitem, inputtext[])
{
	if (!response) return 1;

	new i = -1;

	if ((i = GetNextToySlot(playerid)) == -1)					return SendErrorMessage(playerid, "Tat ca vi tri quan ao da duoc chinh sua.");
    if (GetCash(playerid) < HeadphonesInfo[listitem][toyPrice])	return SendNotCash(playerid);

	SetPlayerAttachedObject(playerid, i, HeadphonesInfo[listitem][toyModel], HeadphonesInfo[listitem][toyBone], HeadphonesInfo[listitem][toyOffestX], HeadphonesInfo[listitem][toyOffestY], HeadphonesInfo[listitem][toyOffestZ],
	HeadphonesInfo[listitem][toyRotX], HeadphonesInfo[listitem][toyRotY], HeadphonesInfo[listitem][toyRotZ], HeadphonesInfo[listitem][toyScaleX], HeadphonesInfo[listitem][toyScaleY], HeadphonesInfo[listitem][toyScaleZ]);
    EditAttachedObject(playerid, i);
	SetPVarInt(playerid, #buy_attach, HeadphonesInfo[listitem][toyPrice]);
	InsertPlayerAttach(playerid, i, HeadphonesInfo[listitem][toyModel], HeadphonesInfo[listitem][toyBone], HeadphonesInfo[listitem][toyName]);
	return 1;
}

Dialog:SportsDialog(playerid, response, listitem, inputtext[])
{
	if (!response)	return 1;

	new i = -1;

	if ((i = GetNextToySlot(playerid)) == -1)				return SendErrorMessage(playerid, "Tat ca vi tri quan ao da duoc chinh sua.");
    if (GetCash(playerid) < SportsInfo[listitem][toyPrice])	return SendNotCash(playerid);

    if (SportsInfo[listitem][toyModel] == 19878)
	{
	    if (GiveInvItem(playerid, 77, 1) == -1)	return SendErrorMessage(playerid, "Tui do da day.");

		SendSyntaxMessage(playerid, "Van truot da duoc them vao tui do.");
		return 1;
	}
	SetPlayerAttachedObject(playerid, i, SportsInfo[listitem][toyModel], SportsInfo[listitem][toyBone], SportsInfo[listitem][toyOffestX], SportsInfo[listitem][toyOffestY], SportsInfo[listitem][toyOffestZ], SportsInfo[listitem][toyRotX], 
	SportsInfo[listitem][toyRotY], SportsInfo[listitem][toyRotZ], SportsInfo[listitem][toyScaleX], SportsInfo[listitem][toyScaleY], SportsInfo[listitem][toyScaleZ]);
    EditAttachedObject(playerid, i);
	SetPVarInt(playerid, #buy_attach, SportsInfo[listitem][toyPrice]);
	InsertPlayerAttach(playerid, i, SportsInfo[listitem][toyModel], SportsInfo[listitem][toyBone], SportsInfo[listitem][toyName]);
	return 1;
}


Dialog:ClockDialog(playerid, response, listitem, inputtext[])
{
	if (!response)	return 1;

	new i = -1;

	if ((i = GetNextToySlot(playerid)) == -1)				return SendErrorMessage(playerid, "Tat ca vi tri quan ao da duoc chinh sua.");
    if (GetCash(playerid) < ClockInfo[listitem][toyPrice])	return SendNotCash(playerid);

	SetPlayerAttachedObject(playerid, i, ClockInfo[listitem][toyModel], ClockInfo[listitem][toyBone], ClockInfo[listitem][toyOffestX], ClockInfo[listitem][toyOffestY], ClockInfo[listitem][toyOffestZ], ClockInfo[listitem][toyRotX], 
	ClockInfo[listitem][toyRotY], ClockInfo[listitem][toyRotZ], ClockInfo[listitem][toyScaleX], ClockInfo[listitem][toyScaleY], ClockInfo[listitem][toyScaleZ]);
    EditAttachedObject(playerid, i);
	SetPVarInt(playerid, #buy_attach, ClockInfo[listitem][toyPrice]);
	InsertPlayerAttach(playerid, i, ClockInfo[listitem][toyModel], ClockInfo[listitem][toyBone], ClockInfo[listitem][toyName]);
	return 1;
}


Dialog:BarberDialog(playerid, response, listitem, inputtext[])
{
	if (!response)	return 1;

	new i = -1;

	if ((i = GetNextToySlot(playerid)) == -1)				return SendErrorMessage(playerid, "Tat ca vi tri quan ao da duoc chinh sua.");
    if (GetCash(playerid) < BarberShop[listitem][toyPrice])	return SendNotCash(playerid);

	SetPlayerAttachedObject(playerid, i, BarberShop[listitem][toyModel], BarberShop[listitem][toyBone], BarberShop[listitem][toyOffestX], BarberShop[listitem][toyOffestY], BarberShop[listitem][toyOffestZ], BarberShop[listitem][toyRotX], 
	BarberShop[listitem][toyRotY], BarberShop[listitem][toyRotZ], BarberShop[listitem][toyScaleX], BarberShop[listitem][toyScaleY], BarberShop[listitem][toyScaleZ]);
    EditAttachedObject(playerid, i);
	SetPVarInt(playerid, #buy_attach, BarberShop[listitem][toyPrice]);
	InsertPlayerAttach(playerid, i, BarberShop[listitem][toyModel], BarberShop[listitem][toyBone], BarberShop[listitem][toyName]);
	return 1;
}

Dialog:HardwareStore(playerid, response, listitem, inputtext[])
{
	// TO DO = MOVE TO VEHICLES

	if (!response) 												return 1;
    if (GetCash(playerid) < HardwareStore[listitem][toyPrice])	return SendNotCash(playerid);

	if (listitem == 14)
	{
	    if (!IsValidVehicle(PlayerInfo[playerid][pCarKey]))	return SendErrorMessage(playerid, "Phuong tien cua ban khong duoc tao ra.");

		static const str_size[] = "{ffffff}Ban sao cho %s. Nhap {C3C3C3}[ID/Ten] {ffffff}ban muon cap cac kha trung lap:";
		new mes[sizeof(str_size) - 2 + 1 + 32];

		format(mes, sizeof(mes), str_size, VehicleNames[GetVehicleModel(PlayerInfo[playerid][pCarKey])-400]);
	    Dialog_Show(playerid, DuplicateKey, DIALOG_STYLE_INPUT, "Ban sao", mes, "Mua", "Huy bo");
	    return 1;
	}

    new i = -1;

	if ((i = GetNextToySlot(playerid)) == -1)	return SendErrorMessage(playerid, "Tat ca vi tri quan ao da duoc chinh sua.");
 		
	SetPlayerAttachedObject(playerid, i, HardwareStore[listitem][toyModel], HardwareStore[listitem][toyBone], HardwareStore[listitem][toyOffestX], HardwareStore[listitem][toyOffestY], HardwareStore[listitem][toyOffestZ], 
	HardwareStore[listitem][toyRotX], HardwareStore[listitem][toyRotY], HardwareStore[listitem][toyRotZ], HardwareStore[listitem][toyScaleX], HardwareStore[listitem][toyScaleY], HardwareStore[listitem][toyScaleZ]);
    EditAttachedObject(playerid, i);
	SetPVarInt(playerid, #buy_attach, HardwareStore[listitem][toyPrice]);
	InsertPlayerAttach(playerid, i, HardwareStore[listitem][toyModel], HardwareStore[listitem][toyBone], HardwareStore[listitem][toyName]);
	return 1;
}

Dialog:GuitarsDialog(playerid, response, listitem, inputtext[])
{
	if (!response) return 1;

	if (listitem == 3)
	{
		if (GetCash(playerid) < GuitarsInfo[listitem][toyPrice])	return SendNotCash(playerid);
		if (GiveInvItem(playerid, INV_BOOMBOX, 1) == -1)		return SendErrorMessage(playerid, "Tui do da day.");

		GiveCash(playerid, -GuitarsInfo[listitem][toyPrice]);
		SendSyntaxMessage(playerid, "Ban da mua mot cai boombox voi gia $%i.", GuitarsInfo[listitem][toyPrice]);
	}
	else
	{
	    new i = -1;

		if ((i = GetNextToySlot(playerid)) == -1)				return SendErrorMessage(playerid, "Tat ca vi tri quan ao da duoc chinh sua.");
    	if (GetCash(playerid) < GuitarsInfo[listitem][toyPrice])	return SendNotCash(playerid);

		SetPlayerAttachedObject(playerid, i, GuitarsInfo[listitem][toyModel], 1, 0.0, -0.145, 0.0, 14.8, 85.1, -19.2, 1.0, 1.0, 1.0);
        EditAttachedObject(playerid, i);
		SetPVarInt(playerid, #buy_attach, GuitarsInfo[listitem][toyPrice]);
		InsertPlayerAttach(playerid, i, GuitarsInfo[listitem][toyModel], 1, GuitarsInfo[listitem][toyName]);
	}
	return 1;
}