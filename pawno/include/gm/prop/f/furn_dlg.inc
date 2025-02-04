Dialog:FurnitureDialog(playerid, response, listitem, inputtext[])
{
	if (!response)	return pTemp[playerid][pFurniture] = -1;
	 
	switch(listitem)
	{
	    case 0: return ShowFurnitureCategories(playerid);
	    case 1: return Dialog_Show(playerid, CategoryEditFurniture, DIALOG_STYLE_LIST, "{FFFFFF}Chinh sua noi that", "Chinh sua bang chuot\nDanh sach do dac", "Chon", "Quay lai");
		case 2:
		{
            if (!GetFurnitures(playerid)) return SendErrorMessage(playerid, "Khong co do dac mua.");
			Dialog_Show(playerid, HandleSellFurnitures, DIALOG_STYLE_MSGBOX, "{FFFFFF}Ban tat ca noi that", "{ffffff}Ban co chac chan muon ban tat ca do dac khong?", "Ban", "Huy bo");
		}
	}
	return 1;
}

Dialog:FurnitureCategories(playerid, response, listitem, inputtext[])
{
	if (!response)	return cmd::furniture(playerid, "");
	if (listitem == 28 && GetNearOutBuilding(playerid, pTemp[playerid][pFurnitureB]) == -1)		return SendErrorMessage(playerid, "Ban phai o ben ngoai de mua do noi that nay. ");
    else if (listitem != 28 && GetNearInBuilding(playerid, pTemp[playerid][pFurnitureB]) == -1)	return SendErrorMessage(playerid, "Ban phai o ben trong de mua do noi that nay. ");
	    
	FurnBuingDialog(playerid, listitem);
 	return 1;
}


Dialog:CategoryEditFurniture(playerid, response, listitem, inputtext[])
{
	if (!response)   return cmd::furniture(playerid, "");
    if (pTemp[playerid][pFurniture] == -1 || (GetNearOutBuilding(playerid, pTemp[playerid][pFurnitureB]) != -1 && GetNearInBuilding(playerid, pTemp[playerid][pFurnitureB]) != -1))	return 1;

	new furnitures = GetFurnitures(playerid);

	if (!furnitures) return SendErrorMessage(playerid, "Ban khong co do dac");

	if (!listitem)
	{
	    SelectObject(playerid);
     	SendErrorMessage(playerid, "Chon mot trong cac doi tuong do noi that bang cach nhap vao chuot.");
	    return 1;
	}

    ShowFurnitureList(playerid);
	return 1;
}

Dialog:FurnitureList(playerid, response, listitem, inputtext[])
{
	if (!response)	return cmd::furniture(playerid, "");
    if (pTemp[playerid][pFurniture] == -1 || (GetNearOutBuilding(playerid, pTemp[playerid][pFurnitureB]) != -1 && GetNearInBuilding(playerid, pTemp[playerid][pFurnitureB]) != -1))	return 1;

	new building = pTemp[playerid][pFurniture],
	    count,
		FName[64],
	    list = pTemp[playerid][pDialogList];

	if (!listitem && list)																		 return ShowFurnitureList(playerid, list-1);
	if ((listitem == MAX_FURNITURE_LIST && !list) || (listitem == MAX_FURNITURE_LIST+1 && list)) return ShowFurnitureList(playerid, list+1);
	if (list)																					 listitem -= 1;
	
	new start_itter = MAX_FURNITURE_LIST * list;
	
	switch(pTemp[playerid][pFurnitureB])
	{
		case 0: {
			for(new i; i < MAX_FURNITURE; i++)
			{
				if (!HFurn[building][i][fOn] || !IsValidDynamicObject(HFurn[building][i][fObject])) continue;
					
				if (count == listitem + start_itter)
				{
					count = i;
					break;
				}
				count++;
			}

			if (HFurn[building][count][fVirtualWorld] != GetWorld(playerid) || HFurn[building][count][fInterior] != GetInterior(playerid)) 
			{
				return SendErrorMessage(playerid, "Doi tuong nay o ngoai duong, ra khoi nha de chinh sua.");
			}

			SetPVarInt(playerid, "chose_slot", count);
			format(FName, sizeof(FName), "%s", HFurn[building][count][fName]);
		} case 1: {
			for(new i; i < MAX_FURNITURE; i++)
			{
				if (!BFurn[building][i][fOn] || !IsValidDynamicObject(BFurn[building][i][fObject])) continue;
					
				if (count == listitem + start_itter)
				{
					count = i;
					break;
				}
				count++;
			}

			if (BFurn[building][count][fVirtualWorld] != GetWorld(playerid) || BFurn[building][count][fInterior] != GetInterior(playerid)) 
			{
				return SendErrorMessage(playerid, "Doi tuong nay o ngoai duong, ra khoi nha de chinh sua.");
			}

			SetPVarInt(playerid, "chose_slot", count);
			format(FName, sizeof(FName), "%s", BFurn[building][count][fName]);
		} case 2: {
			for(new i; i < MAX_FURNITURE; i++)
			{
				if (!GFurn[building][i][fOn] || !IsValidDynamicObject(GFurn[building][i][fObject])) continue;
					
				if (count == listitem + start_itter)
				{
					count = i;
					break;
				}
				count++;
			}

			if (GFurn[building][count][fVirtualWorld] != GetWorld(playerid) || GFurn[building][count][fInterior] != GetInterior(playerid)) 
			{
				return SendErrorMessage(playerid, "Doi tuong nay o ngoai duong, ra khoi nha de chinh sua.");
			}

			SetPVarInt(playerid, "chose_slot", count);
			format(FName, sizeof(FName), "%s", GFurn[building][count][fName]);
		}
	}

 	Dialog_Show(playerid, EditFurniture, DIALOG_STYLE_LIST, FName, "Thong tin\nThay doi vi tri\nChinh sua ket cau\nBan\nThay doi ten\nTao ban sao", "Chon", "Quay lai");
	return 1;
}

Dialog:HandleEditTexture(playerid, response, listitem, inputtext[])
{
	if (!response) return CallRemoteFunction("ShowEditFurniture", "i", playerid);

    if (pTemp[playerid][pFurniture] == -1 || (GetNearOutBuilding(playerid, pTemp[playerid][pFurnitureB]) != -1 && GetNearInBuilding(playerid, pTemp[playerid][pFurnitureB]) != -1))	return 1;

	new building = pTemp[playerid][pFurniture], slot = GetPVarInt(playerid, "chose_slot");

	if (listitem < 5)
	{
		new title[32];

		format(title, 32, "Texture (%i)", listitem+1);
 		Dialog_Show(playerid, HandleEditTexture2, DIALOG_STYLE_LIST, title, "Thay doi ket cau\nXoa bo ket cau", "Chon", "Quay lai");
        SetPVarInt(playerid, "chose_texture", listitem);
		return 1;
	}

	new name[64], furnid;

	switch(pTemp[playerid][pFurnitureB])
	{
		case 0: {
			format(name, sizeof(name), "%s", HFurn[building][GetPVarInt(playerid, "chose_slot")][fName]);
			furnid = HFurn[building][slot][fID];
			for(new i; i < 5; i++)
			{
				HFurn[building][slot][fTexture][i] = -1;
				SetDynamicObjectMaterial(HFurn[building][slot][fObject], i, -1, "none", "none", 0);
			}
		} case 1: { 
			format(name, sizeof(name), "%s", BFurn[building][GetPVarInt(playerid, "chose_slot")][fName]);
			furnid = BFurn[building][slot][fID];
			for(new i; i < 5; i++)
			{
				BFurn[building][slot][fTexture][i] = -1;
				SetDynamicObjectMaterial(BFurn[building][slot][fObject], i, -1, "none", "none", 0);
			}
		} case 2: {
			format(name, sizeof(name), "%s", GFurn[building][GetPVarInt(playerid, "chose_slot")][fName]);
			furnid = GFurn[building][slot][fID];

			for(new i; i < 5; i++)
			{
				GFurn[building][slot][fTexture][i] = -1;
				SetDynamicObjectMaterial(GFurn[building][slot][fObject], i, -1, "none", "none", 0);
			}
		}
	}

 	SendSyntaxMessage(playerid, "All %s's textures removed.", name);

	new query[128];

	mysql_format(dbHandle, query, sizeof(query), "UPDATE `furnitures` SET `texture_0`=-1,`texture_1`=-1,`texture_2`=-1,`texture_3`=-1,`texture_4`=-1 WHERE `id`=%i",furnid);
	mysql_tquery(dbHandle, query);

	return 1;
}

Dialog:HandleEditTexture2(playerid, response, listitem, inputtext[])
{
	if (!response)	return CallRemoteFunction("ShowEditFurniture", "i", playerid);

    if (pTemp[playerid][pFurniture] == -1 || (GetNearOutBuilding(playerid, pTemp[playerid][pFurnitureB]) != -1 && GetNearInBuilding(playerid, pTemp[playerid][pFurnitureB]) != -1)) return 1;

	new building = pTemp[playerid][pFurniture], slot = GetPVarInt(playerid, "chose_slot"), texture = GetPVarInt(playerid, "chose_texture");

	switch(listitem)
	{
	    case 0:
		{
		    new Float:x, Float:y, Float:z, Float:facing, Float:distance = 3.0;

		    GetPlayerPos(playerid, x, y, z);
		    GetPlayerFacingAngle(playerid, facing);

		  	x += (distance * floatsin(-facing, degrees));
		    y += (distance * floatcos(-facing, degrees));
            InfoMSG(playerid, "~r~Nhan ~w~\" ~y~Y ~w~\" va \" ~y~N ~w~\" de su dung menu ket cau~n~\" ~y~H ~w~\" - thay doi vi tri vat lieu~n~\" ~y~SPACE~w~ \" - ap dung ket cau~n~\" ~y~ENTER ~w~\" de thoat", 20);
			pTemp[playerid][p3DMenu] = Create3DMenu(playerid, x, y, z, facing, 16);
		    Select3DMenu(playerid, pTemp[playerid][p3DMenu]);
			return 1;
		}
		case 1:
	    {
			switch(pTemp[playerid][pFurnitureB])
			{
				case 0: {
					if (HFurn[building][slot][fTexture][texture] == -1)	return SendErrorMessage(playerid,"Ket cau nay khong duoc su dung.");
					SendSyntaxMessage(playerid, "Ket cau [ID: %i] cua doi tuong %s da duoc xoa.", texture+1, HFurn[building][slot][fName]);

					new query[128];
					mysql_format(dbHandle, query, sizeof(query), "UPDATE `furnitures` SET `texture_%i` = -1 WHERE `id` = %i", texture, HFurn[building][slot][fID]);
					mysql_tquery(dbHandle, query);

					HFurn[building][slot][fTexture][texture] = -1;
					SetDynamicObjectMaterial(HFurn[building][slot][fObject], texture, -1, "none", "none", 0);
				} case 1: {
					if (BFurn[building][slot][fTexture][texture] == -1)	return SendErrorMessage(playerid, "Ket cau nay khong duoc su dung.");
					SendSyntaxMessage(playerid, "Ket cau [ID: %i] cua doi tuong %s da duoc xoa.", texture+1, BFurn[building][slot][fName]);

					new query[128];
					mysql_format(dbHandle, query, sizeof(query), "UPDATE `furnitures` SET `texture_%i` = -1 WHERE `id` = %i", texture, BFurn[building][slot][fID]);
					mysql_tquery(dbHandle, query);

					BFurn[building][slot][fTexture][texture] = -1;
					SetDynamicObjectMaterial(BFurn[building][slot][fObject], texture, -1, "none", "none", 0);
				} case 2: {
					if (GFurn[building][slot][fTexture][texture] == -1)	return SendErrorMessage(playerid, "Ket cau nay khong duoc su dung.");
					SendSyntaxMessage(playerid, "Ket cau [ID: %i] cua doi tuong %s da duoc xoa.", texture+1, GFurn[building][slot][fName]);

					new query[128];
					mysql_format(dbHandle, query, sizeof(query), "UPDATE `furnitures` SET `texture_%i` = -1 WHERE `id` = %i", texture, GFurn[building][slot][fID]);
					mysql_tquery(dbHandle, query);

					GFurn[building][slot][fTexture][texture] = -1;
					SetDynamicObjectMaterial(GFurn[building][slot][fObject], texture, -1, "none", "none", 0);
				}
			}
	        return 1;
	    }
	}
	return 1;
}

Dialog:InformationFurniture(playerid, response, listitem, inputtext[])
{
    return CallRemoteFunction("ShowEditFurniture", "i", playerid);
}

Dialog:EditFurniture(playerid, response, listitem, inputtext[])
{
	if (!response)   return cmd::furniture(playerid, "");
    if (pTemp[playerid][pFurniture] == -1 || (GetNearOutBuilding(playerid, pTemp[playerid][pFurnitureB]) != -1 && GetNearInBuilding(playerid, pTemp[playerid][pFurnitureB]) != -1))	return 1;

	new building = pTemp[playerid][pFurniture], 
        slot = GetPVarInt(playerid, "chose_slot");

	new FCat, name[64], f_price, f_obj, f_vw, f_int;

	switch(pTemp[playerid][pFurnitureB])
	{
		case 0: {
			format(name, sizeof(name), "%s", HFurn[building][slot][fName]);
			FCat = HFurn[building][slot][fCategory];
			f_price = HFurn[building][slot][fMarketPrice]; 
			f_obj = HFurn[building][slot][fObject];
			f_vw = HFurn[building][slot][fVirtualWorld];
			f_int = HFurn[building][slot][fInterior];
		} case 1: { 
			format(name, sizeof(name), "%s", BFurn[building][slot][fName]);
			FCat = BFurn[building][slot][fCategory];
			f_price = BFurn[building][slot][fMarketPrice]; 
			f_obj = BFurn[building][slot][fObject];
			f_vw = BFurn[building][slot][fVirtualWorld];
			f_int = BFurn[building][slot][fInterior];
		} case 2: { 
			format(name, sizeof(name), "%s", GFurn[building][slot][fName]);
			FCat = GFurn[building][slot][fCategory];
			f_price = GFurn[building][slot][fMarketPrice]; 
			f_obj = GFurn[building][slot][fObject];
			f_vw = GFurn[building][slot][fVirtualWorld];
			f_int = GFurn[building][slot][fInterior];
		}
	}

    if (f_vw != GetWorld(playerid) || f_int != GetInterior(playerid)) return SendErrorMessage(playerid, "Doi tuong nay o ngoai duong, ra khoi nha de chinh sua.");
	    		
	switch(listitem)
	{
	    case 0:
	    {
	        new mes[228];

			format(mes, sizeof(mes), "{C3C3C3}Loai:\t{ffffff}%s\n{C3C3C3}Ten:\t{ffffff}%s\n{C3C3C3}Gia:\t{ffffff}$%s", furniture_title[FCat], name, FormatNumber(f_price));
			Dialog_Show(playerid, InformationFurniture, DIALOG_STYLE_MSGBOX, "{FFFFFF}Thong tin", mes, "Quay lai", "");
	        return 1;
	    }
	    case 1:
	    {
            InfoMSG(playerid, "Giu \" ~y~SPACE ~w~\" va nhan \" ~y~MMB ~w~\" de di chuyen doi tuong gan ban hon~n~Nhan \" ~r~ESC ~w~\" de hoan tac hanh dong", 5);
	        SetPVarInt(playerid, "edit_furniture", 1);
			EditDynamicObject(playerid, f_obj);
	        return 1;
	    }
	    case 2:
	    {
	        new str_tex[256], tex_name[5][32] = {"Trong", "Trong", "Trong", "Trong", "Trong"}; //Пусто

			switch(pTemp[playerid][pFurnitureB])
			{
				case 0: for(new i; i != 5; i++) if (HFurn[building][slot][fTexture][i] != -1) format(tex_name[i], 32, "%s", GetTextureName(HFurn[building][slot][fTexture][i]));
				case 1: for(new i; i != 5; i++) if (BFurn[building][slot][fTexture][i] != -1) format(tex_name[i], 32, "%s", GetTextureName(BFurn[building][slot][fTexture][i]));
				case 2: for(new i; i != 5; i++) if (GFurn[building][slot][fTexture][i] != -1) format(tex_name[i], 32, "%s", GetTextureName(GFurn[building][slot][fTexture][i]));
			}			

			format(str_tex, sizeof(str_tex), "{FFFFFF}Ket cau 1: {C3C3C3}%s\n{FFFFFF}Ket cau  2: {C3C3C3}%s\n{FFFFFF}Ket cau  3: {C3C3C3}%s\n{FFFFFF}Ket cau  4: {C3C3C3}%s\n{FFFFFF}Ket cau  5: {C3C3C3}%s\n{FF6347}> Xoa bo ket cau", tex_name[0], tex_name[1], tex_name[2], tex_name[3], tex_name[4]);
	        Dialog_Show(playerid, HandleEditTexture, DIALOG_STYLE_LIST, "{FFFFFF}Thay the ket cau", str_tex, "Chon", "Quay lai");
			return 1;
	    }
	    case 3:
	    {
            new mes[268], sellprice = (f_price - (f_price & 2))  / 2;

			format(mes, sizeof(mes), "{C3C3C3}Loai:\t{ffffff}%s\n{C3C3C3}Ten:\t{ffffff}%s\n{C3C3C3}Gia:\t{ffffff}$%s\n\n{FF6347}Ban se nhan duoc khi ban la: $%s", furniture_title[FCat], name, FormatNumber(f_price), FormatNumber(sellprice));
			Dialog_Show(playerid, HandleSellFurniture, DIALOG_STYLE_MSGBOX, "{FFFFFF}Ban", mes, "Ban", "Quay lai");
	        return 1;
	    }
		case 4:
		{
		    Dialog_Show(playerid, FurnitureRename, DIALOG_STYLE_INPUT, name, "\t{ffffff}Nhap ten moi cho do noi that nay:\t\n\t- Toi thieu 1 ky tu.\t\n\t- Toi da 32 ky tu.\t", "Chinh sua", "Quay lai");
			return 1;
		}
		case 5:
		{
		    new mes[228];
			format(mes, sizeof(mes), "{C3C3C3}Loai:\t{ffffff}%s\n{C3C3C3}Ten:\t{ffffff}%s\n{C3C3C3}Gia:\t{ffffff}$%s\n{ffffff}", furniture_title[FCat], name, FormatNumber(f_price));
		    Dialog_Show(playerid, CopyFurniture, DIALOG_STYLE_MSGBOX, "{FFFFFF}Tao ban sao", mes, "Mua", "Quay lai");
		}
	}
	return 1;
}

Dialog:FurnitureRename(playerid, response, listitem, inputtext[])
{
	if (!response)																																												return 1;
    if (pTemp[playerid][pFurniture] == -1 || (GetNearOutBuilding(playerid, pTemp[playerid][pFurnitureB]) != -1 && GetNearInBuilding(playerid, pTemp[playerid][pFurnitureB]) != -1))	return 1;

	new building = pTemp[playerid][pFurniture], slot = GetPVarInt(playerid, "chose_slot"), f_id, name[64];

	switch(pTemp[playerid][pFurnitureB])
	{
		case 0: {
			format(name, sizeof(name), "%s", HFurn[building][slot][fName]);
			f_id = HFurn[building][slot][fCategory];
		} case 1: { 
			format(name, sizeof(name), "%s", BFurn[building][slot][fName]);
			f_id = BFurn[building][slot][fCategory];
		} case 2: { 
			format(name, sizeof(name), "%s", GFurn[building][slot][fName]);
			f_id = GFurn[building][slot][fCategory];
		}
	}

	if (strlen(inputtext) < 1 || strlen(inputtext) > 32)
	{
	    Dialog_Show(playerid, FurnitureRename, DIALOG_STYLE_INPUT, name, "\t\t{ffffff}Nhap ten moi cho do noi that:\t\t\n\t\t\t - Toi thieu 1 ky tu.\t\t\n\t\t\t - Toi da 32 ky tu.\t\t", "Chinh sua", "Quay lai");
		return SendErrorMessage(playerid, "Ten chi tu 1 den 32 ky tu.");
	}

	SendSyntaxMessage(playerid, "Ban da thay doi ten cua vat pham: %s{ffffff} thanh %s.", name, inputtext);
    format(name, 32, "%s", inputtext);
    
	new query[128];
	mysql_format(dbHandle, query, sizeof(query), "UPDATE `furnitures` SET `name` = '%e' WHERE `id` = %i", name, f_id);
	mysql_tquery(dbHandle, query);
	return 1;
}
	
Dialog:BuyFurniture(playerid, response, listitem, inputtext[])
{
	if (!response)
	{
        FurnBuingDialog(playerid, GetPVarInt(playerid, "category_furniture"));
	    return 1;
	}

    if (pTemp[playerid][pFurniture] == -1) return 1;

    new building = pTemp[playerid][pFurniture], 
        index = GetPVarInt(playerid, "furniture_index");

    listitem = GetPVarInt(playerid, "category_furniture");

    if (GetCash(playerid) < furniture_list[listitem][index][frPrice]) 								  return SendNotCash(playerid);
    if (listitem == 28 && GetNearOutBuilding(playerid, pTemp[playerid][pFurnitureB]) == -1)	     	  return SendErrorMessage(playerid, "Ban phai o ben ngoai de mua do noi that nay.");
    else if (listitem != 28 && GetNearInBuilding(playerid, pTemp[playerid][pFurnitureB]) == -1)		  return SendErrorMessage(playerid, "Ban phai o ben trong de mua do noi that nay.");
    if (GetFurnitures(playerid) >= GetMaxPlayerFurniture(playerid))   								  return SendErrorMessage(playerid, "Ban da mua toi da cac noi that.");
    if (listitem == 28 && GetOutsideFurnitures(playerid) >= 9 && GetOutsideFurnitures(playerid) <= 0) return SendErrorMessage(playerid, "Chi co 10 doi tuong co the duoc dat ben ngoai.");
		
    new i = -1;

	switch(pTemp[playerid][pFurnitureB]) {
		case 0: {
			for(new a; a < MAX_FURNITURE; a++)
			{
				if (HFurn[building][a][fOn]) continue;
				
				i = a;
				break;
			}
		} case 1: {
			for(new a; a < MAX_FURNITURE; a++)
			{
				if (BFurn[building][a][fOn]) continue;
				
				i = a;
				break;
			}
		} case 2: {
			for(new a; a < MAX_FURNITURE; a++)
			{
				if (GFurn[building][a][fOn]) continue;
				
				i = a;
				break;
			}
		}
	}

	if (i == -1) return 1;

	SetPVarInt(playerid, "buy_furniture", 1);

	new Float:x, Float:y, Float:z;
    GetXYInFrontOfPlayer(playerid, x, y, z, 3.0);
	
	switch(pTemp[playerid][pFurnitureB]) {
		case 0: OnPlayerCallBuyFurniture(playerid, building, 0, i, furniture_list[listitem][index][frModel], listitem, index, x, y, z-1.0);
		case 1: OnPlayerCallBuyFurniture(playerid, building, 1, i, furniture_list[listitem][index][frModel], listitem, index, x, y, z-1.0);
		case 2: OnPlayerCallBuyFurniture(playerid, building, 2, i, furniture_list[listitem][index][frModel], listitem, index, x, y, z-1.0);
	}
	return 1;
}

Dialog:CopyFurniture(playerid, response, listitem, inputtext[])
{
	if (!response)
		return CallRemoteFunction("ShowEditFurniture", "i", playerid);

    if (pTemp[playerid][pFurniture] == -1 || (GetNearOutBuilding(playerid, pTemp[playerid][pFurnitureB]) != -1 && GetNearInBuilding(playerid, pTemp[playerid][pFurnitureB]) != -1))
		return 1;

	if (GetFurnitures(playerid) >= GetMaxPlayerFurniture(playerid))
		return SendErrorMessage(playerid, "Ban da mua toi da cac noi that.");

    new building = pTemp[playerid][pFurniture], slot = GetPVarInt(playerid, "chose_slot");

	switch(pTemp[playerid][pFurnitureB])
	{
		case 0: HouseFurnCopy(playerid, building, slot);
		case 1: BizFurnCopy(playerid, building, slot);
		case 2: GarageFurnCopy(playerid, building, slot);
	}	
	
	return 1;
}

Dialog:HandleSellFurnitures(playerid, response, listitem, inputtext[])
{
	if (!response)																																												return cmd::furniture(playerid, "");
    if (pTemp[playerid][pFurniture] == -1 || (GetNearOutBuilding(playerid, pTemp[playerid][pFurnitureB]) != -1 && GetNearInBuilding(playerid, pTemp[playerid][pFurnitureB]) != -1))	return 1;
    	
	new building = pTemp[playerid][pFurniture];

	if (HouseInfo[building][hOwnerID] != PlayerInfo[playerid][pID] && pTemp[playerid][pBuildHouse] != HouseInfo[building][hID])	return SendErrorMessage (playerid, "Ban khong the kiem soat cac noi that trong ngoi nha nay.");
    if (GetPVarInt(playerid, "buy_furniture"))																					return SendErrorMessage (playerid, "Hanh dong da duoc tien hanh.");
        
	switch(pTemp[playerid][pFurnitureB]) {
		case 0: HouseHandleSellFurn(playerid, building);
		case 1: BizHandleSellFurn(playerid, building);
		case 2: GarageHandleSellFurn(playerid, building);
	}	
	return 1;
}

Dialog:HandleSellFurniture(playerid, response, listitem, inputtext[])
{
    if (!response)	return CallRemoteFunction("ShowEditFurniture", "i", playerid);
    if (pTemp[playerid][pFurniture] == -1 || (GetNearOutBuilding(playerid, pTemp[playerid][pFurnitureB]) != -1 && GetNearInBuilding(playerid, pTemp[playerid][pFurnitureB]) != -1))	return 1;
    	
	new building = pTemp[playerid][pFurniture], name[64], f_price, slot = GetPVarInt(playerid, "chose_slot");

	switch(pTemp[playerid][pFurnitureB])
	{
		case 0: {
			if (!HFurn[building][slot][fOn])	return SendErrorMessage(playerid, "Khong co noi that da mua nao trong vi tri nay.");
			if (HouseInfo[building][hOwnerID] != PlayerInfo[playerid][pID] && pTemp[playerid][pBuildHouse] != HouseInfo[building][hID])	return SendErrorMessage(playerid, "Ban khong the van hanh cac noi that trong ngoi nha nay.");
			
			f_price = HFurn[building][slot][fMarketPrice];
			format(name, sizeof(name), "%s", HFurn[building][slot][fName]);
		} case 1: {
			if (!BFurn[building][slot][fOn])	return SendErrorMessage(playerid, "Khong co noi that da mua nao trong vi tri nay.");
			if (BizInfo[building][bizOwnerID] != PlayerInfo[playerid][pID] && pTemp[playerid][pBuildHouse] != BizInfo[building][bizID])	return SendErrorMessage(playerid, "Ban khong the van hanh cac noi that trong doanh nghiep nay.");

			f_price = BFurn[building][slot][fMarketPrice];
			format(name, sizeof(name), "%s", BFurn[building][slot][fName]);
		} case 2: {
			if (!GFurn[building][slot][fOn])	return SendErrorMessage(playerid, "Khong co noi that da mua nao trong vi tri nay.");
			if (GarageInfo[building][garageOwner] != PlayerInfo[playerid][pID] && pTemp[playerid][pBuildHouse] != GarageInfo[building][garageID])	return SendErrorMessage(playerid, "Ban khong the van hanh cac noi that trong ga ra nay.");

			f_price = GFurn[building][slot][fMarketPrice];
			format(name, sizeof(name), "%s", GFurn[building][slot][fName]);
		}
	}
        
	new sellprice = (f_price - (f_price & 2)) / 2;
	SendSyntaxMessage(playerid, "Ban da ban %s, nhan duoc 50 phan tram tu toan bo chi phi, voi $%s.", name, FormatNumber(sellprice));

    if (!GetPVarInt(playerid, "buy_furniture")) GiveCash(playerid, sellprice);
		
	OnPlayerSellFurniture(pTemp[playerid][pFurnitureB], building, slot);
	return 1;
}


Dialog:MODEL_SEL_FURNITURE(playerid, response, listitem, inputtext[])
{
	if (!response)
	{
	    if (pTemp[playerid][pFurniture] == -1 || (GetNearOutBuilding(playerid, pTemp[playerid][pFurnitureB]) != -1 && GetNearInBuilding(playerid, pTemp[playerid][pFurnitureB]) != -1)) return 1;
    	
	    ShowFurnitureCategories(playerid);
	    return 1;
	}

	if (pTemp[playerid][pFurniture] == -1 || (GetNearOutBuilding(playerid, pTemp[playerid][pFurnitureB]) != -1 && GetNearInBuilding(playerid, pTemp[playerid][pFurnitureB]) != -1)) return 1;
    	
	new building = pTemp[playerid][pFurniture], 
        list = GetPVarInt(playerid, "category_furniture");

	if (GetFurnitures(playerid) >= GetMaxPlayerFurniture(playerid))	return SendErrorMessage(playerid, "Ban da mua toi da cac noi that.");
	if (list == 28 && GetOutsideFurnitures(playerid) >= 9 && GetOutsideFurnitures(playerid) <= 0) return SendErrorMessage(playerid, "Chi co the dat 10 do vat ben ngoai ngoi nha.");
	
	new model = furniture_list[list][listitem][frModel];
	if (list == 29 && (model == REACTOR_OBJECT || model == DRYER_OBJECT || model == MIXER_OBJECT)) {
		if (GetClosestFurniture(playerid, 30.0, model, DRUG_LAB) != -1) return SendErrorMessage(playerid, "Ban da co '%s'.", furniture_list[list][listitem][frName]);
	}

	new i = -1;

	switch(pTemp[playerid][pFurnitureB])
	{
		case 0: {
			for(new a; a < MAX_FURNITURE; a++)
			{
				if (!HFurn[building][a][fOn])
				{
					i = a;
					break;
				}		        
			}
			if (i == -1) return 1;
		} case 1: {
			for(new a; a < MAX_FURNITURE; a++)
			{
				if (!BFurn[building][a][fOn])
				{
					i = a;
					break;
				}		        
			}
			if (i == -1) return 1;
		} case 2: {
			for(new a; a < MAX_FURNITURE; a++)
			{
				if (!GFurn[building][a][fOn])
				{
					i = a;
					break;
				}		        
			}
			if (i == -1) return 1;
		}
	}	

	static const str_size[] = "{C3C3C3}Loai:\t{ffffff}%s\n{C3C3C3}Ten:\t{ffffff}%s\n{C3C3C3}Gia:\t{ffffff}$%s\n{ffffff}";
	new mes[sizeof(str_size) - 6 + 11 + 32 + 64];

	format(mes, sizeof(mes), str_size, furniture_title[list], furniture_list[list][listitem][frName], FormatNumber(furniture_list[list][listitem][frPrice]));
	SetPVarInt(playerid, "furniture_index", listitem);

	Dialog_Show(playerid, BuyFurniture, DIALOG_STYLE_MSGBOX, "Mua noi that", mes, "Mua", "Quay lai");
	return 1;
}

FurnBuingDialog(playerid, listitem)
{
    SetPVarInt(playerid, "category_furniture", listitem);
    
    new objects = furniture_objects[listitem], object_names[153], object_amounts[153];

	for(new i; i < objects; i++)
	{
		object_names[i] = furniture_list[listitem][i][frModel];
	    object_amounts[i] = furniture_list[listitem][i][frPrice];
	}

	new mes[sizeof(object_names)*16];
	for(new i = 0; i < sizeof(object_names); i++)
	{
		if (object_names[i]) format(mes, sizeof(mes), "%s%i\t~g~$%i\n", mes, object_names[i], object_amounts[i]); 
	}
	
	new title[64];
	format(title, sizeof(title), "MUA NOI THAT > %s", furniture_title[listitem]);
	Dialog_Show(playerid, MODEL_SEL_FURNITURE, DIALOG_STYLE_PREVIEW_MODEL, title, mes, "Chon", "Dong");
}