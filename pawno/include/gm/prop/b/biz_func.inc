this::LoadDynamicBiz()
{
    new rows = cache_num_rows(), time = GetTickCount(), total, query[128];

	if (!rows) return print("[Biz] Khong co du lieu duoc tim thay.");

	for(new i; i < rows; i++)
	{
	    BizInfo[i][bizID] = cache_get_field_content_int(i, "id");
		BizInfo[i][bizPosX] = cache_get_field_content_float(i, "posx");
		BizInfo[i][bizPosY] = cache_get_field_content_float(i, "posy");
		BizInfo[i][bizPosZ] = cache_get_field_content_float(i, "posz");
		BizInfo[i][bizExitX] = cache_get_field_content_float(i, "exitx");
		BizInfo[i][bizExitY] = cache_get_field_content_float(i, "exity");
		BizInfo[i][bizExitZ] = cache_get_field_content_float(i, "exitz");
		cache_get_field_content(i, "name", BizInfo[i][bizName], dbHandle, 32);
		cache_get_field_content(i, "entermsg", BizInfo[i][bizMes], dbHandle, 128);
		BizInfo[i][bizOwnerID] = cache_get_field_content_int(i, "owner");
		BizInfo[i][bizLocked] = cache_get_field_content_int(i, "locked");
		BizInfo[i][bizPrice] = cache_get_field_content_int(i, "price");
		BizInfo[i][bizFreeze] = cache_get_field_content_int(i, "freeze");
		BizInfo[i][bizLevelbuy] = cache_get_field_content_int(i, "levelbuy");
		BizInfo[i][bizExitInt] = cache_get_field_content_int(i, "exitint");
		BizInfo[i][bizExitVW] = cache_get_field_content_int(i, "exitvw");
		BizInfo[i][bizCash] = cache_get_field_content_int(i, "cash");
		BizInfo[i][bizType] = cache_get_field_content_int(i, "type"),
		BizInfo[i][bizEntrance] = cache_get_field_content_int(i, "entrance");
		BizInfo[i][bizRadio] = cache_get_field_content_int(i, "radio");
		BizInfo[i][bizDDoor] = cache_get_field_content_int(i, "ddoor");
		BizInfo[i][bizPosInt] = cache_get_field_content_int(i, "posint");
		BizInfo[i][bizPosVW] = cache_get_field_content_int(i, "posvw");
		BizInfo[i][bizSpawn][0] = cache_get_field_content_int(i, "spawnX");
		BizInfo[i][bizSpawn][1] = cache_get_field_content_int(i, "spawnY");
		BizInfo[i][bizSpawn][2] = cache_get_field_content_int(i, "spawnZ");
		BizInfo[i][bizSpawn][3] = cache_get_field_content_int(i, "spawnR");
		BizInfo[i][bizSpawnInt] = cache_get_field_content_int(i, "spawnInt");
		BizInfo[i][bizSpawnVW] = cache_get_field_content_int(i, "spawnVW");
		BizInfo[i][bizProduct] = cache_get_field_content_int(i, "product");
		BizInfo[i][bizBuyPrice] = cache_get_field_content_int(i, "buy_price");
		BizInfo[i][bizLabelDDoor] = Text3D:INVALID_3DTEXT_ID;
		BizInfo[i][bFireTimer] = 0;

		new
			prprice[16]
		;
		
		new type;
		switch(BizInfo[i][bizType])
		{
			case BIZ_PIZZA:		type = 0;
			case BIZ_CLUCKIN:	type = 1;
			case BIZ_BURGER:	type = 2;
			case BIZ_DONUT:		type = 3;
			case BIZ_STORE:		type = 4;
			case BIZ_BAR:		type = 5;
			case BIZ_PHARMACY:	type = 6;
		}

		for(new j = 0; j < max_product[type]; j++)
		{
			format(prprice, sizeof(prprice), "productprice%i", j);
			BizInfo[i][bizProductPrice][j] = cache_get_field_content_int(i, prprice);
			if (BizInfo[i][bizProductPrice][j] < biz_prices[type][j]) BizInfo[i][bizProductPrice][j] = biz_prices[type][j];
		}
		
		cache_get_field_content(i, "ownername", BizInfo[i][bizOwner], dbHandle, MAX_PLAYER_NAME);
		strreplace(BizInfo[i][bizOwner], '_', ' ');

	    BizInfo[i][bizPickUp] = CreateDynamicPickup(1239, 1, BizInfo[i][bizPosX], BizInfo[i][bizPosY], BizInfo[i][bizPosZ], BizInfo[i][bizPosVW], BizInfo[i][bizPosInt], -1, 100.0);
	    UpdateBusinessDoor(i);

		format(query, sizeof(query), "SELECT * FROM `furnitures` WHERE `building`=%i AND `bType`=1", BizInfo[i][bizID]);
		mysql_tquery(dbHandle, query, "OnBFurnsLoad", "i", i);

		mysql_format(dbHandle, query, sizeof(query), "SELECT `id`, `name`, `position` FROM `users` WHERE `workon`=%i LIMIT 10", BizInfo[i][bizID]);
		mysql_tquery(dbHandle, query, "LoadBusinessWorkers", "i", i);
		
		if (BizInfo[i][bizOwnerID] != 0) {
			mysql_format(dbHandle, query, sizeof(query), "SELECT accountid,cash,last_login FROM `users` WHERE id=%i LIMIT 1", BizInfo[i][bizOwnerID]);
			mysql_tquery(dbHandle, query, "BizCheckOwner", "ii", i, BizInfo[i][bizID]);
		}

        total++;
	}
	printf("[Biz] Rows - %i. Load - %i. Time: %i ms.", rows, total, GetTickCount()-time);
	return 1;
}

this::BizCheckOwner(bizid, dbid)
{
	if (!cache_num_rows()) return printf("[SQL ERROR] Doanh nghiep [db ID:%i] khong tim thay chu so huu trong du lieu!", dbid);

	new accountid = cache_get_field_content_int(0, "accountid", dbHandle),
		money = cache_get_field_content_int(0, "cash", dbHandle),
		last_login = cache_get_field_content_int(0, "last_login"),
		query[128];

	if (last_login < gettime()-1209600) {
		mysql_format(dbHandle, query, sizeof(query), "UPDATE `users` SET `cash`=%i WHERE id=%i LIMIT 1", money+floatround(BizInfo[bizid][bizPrice]/2)/*+GetFurniturePrice(1, i)*/+BizInfo[bizid][bizCash], BizInfo[bizid][bizOwnerID]);		
		mysql_query(dbHandle, query);

		format(query, sizeof(query), "Business sold out automatically [B_MYSQL: %i] player %s [MYSQL: %i]", BizInfo[bizid][bizID], BizInfo[bizid][bizOwner], BizInfo[bizid][bizOwnerID]);
		insert_log(query, PROPERTY_LOG, 8, accountid);
		Sell_Business(bizid);
	}
	return 1;
}

this::LoadBusinessWorkers(bizid)
{
	if (!cache_num_rows())	return 1;

	for(new i; i < cache_num_rows(); i++)
	{
		BizWorkers[bizid][i][bizJobOn] = cache_get_field_content_int(i, "id");
		cache_get_field_content(i, "position", BizWorkers[bizid][i][bizPosition], dbHandle, 24);
		cache_get_field_content(i, "name", BizWorkers[bizid][i][bizWorker], dbHandle, 24);
	}

	return 1;
}

this::OnBFurnsLoad(bizid)
{
	if (!cache_num_rows())	return 1;

	new tid;

	for(new i; i < cache_num_rows(); i++)
	{
		BFurn[bizid][i][fID] = cache_get_row_int(i, 0);
		BFurn[bizid][i][fModel] = cache_get_row_int(i, 1);
		cache_get_row(i, 2, BFurn[bizid][i][fName], dbHandle, 64);
		//BFurn[bizid][i][fBuildingID] = bizid;
		BFurn[bizid][i][fInterior] = cache_get_row_int(i, 5);
		BFurn[bizid][i][fVirtualWorld] = cache_get_row_int(i, 6);
		BFurn[bizid][i][fMarketPrice] = cache_get_row_int(i, 7);
		BFurn[bizid][i][fPosX] = cache_get_row_float(i, 8);
		BFurn[bizid][i][fPosY] = cache_get_row_float(i, 9);
		BFurn[bizid][i][fPosZ] = cache_get_row_float(i, 10);
		BFurn[bizid][i][fPosRX] = cache_get_row_float(i, 11);
		BFurn[bizid][i][fPosRY] = cache_get_row_float(i, 12);
		BFurn[bizid][i][fPosRZ] = cache_get_row_float(i, 13);
		BFurn[bizid][i][fTexture][0] = cache_get_row_int(i, 14);
		BFurn[bizid][i][fTexture][1] = cache_get_row_int(i, 15);
		BFurn[bizid][i][fTexture][2] = cache_get_row_int(i, 16);
		BFurn[bizid][i][fTexture][3] = cache_get_row_int(i, 17);
		BFurn[bizid][i][fTexture][4] = cache_get_row_int(i, 18);
		BFurn[bizid][i][fCategory] = cache_get_row_int(i, 19);
		BFurn[bizid][i][ChemIdx] = cache_get_row_int(i, 20);

		BFurn[bizid][i][fOn] = 1;
		BFurn[bizid][i][fObject] = CreateDynamicObject(BFurn[bizid][i][fModel], BFurn[bizid][i][fPosX], BFurn[bizid][i][fPosY], BFurn[bizid][i][fPosZ], BFurn[bizid][i][fPosRX], BFurn[bizid][i][fPosRY], BFurn[bizid][i][fPosRZ], BFurn[bizid][i][fVirtualWorld], BFurn[bizid][i][fInterior]);

		for(new a; a != 5; a++)
		{
		    if (BFurn[bizid][i][fTexture][a] == -1) continue;

			tid = BFurn[bizid][i][fTexture][a];
			SetDynamicObjectMaterial(BFurn[bizid][i][fObject], a, ObjectTextures[tid][TModel], ObjectTextures[tid][TXDName], ObjectTextures[tid][TextureName], ObjectTextures[tid][MaterialColor]);
		}

		if (isHouseDoor(BFurn[bizid][i][fModel]))
		{
			BFurn[bizid][i][fLocked] = 1;
			BFurn[bizid][i][fOpened] = 0;
		}
		
		BizInfo[bizid][bFurniture]++;
		
		if (BFurn[bizid][i][fVirtualWorld] != BizInfo[bizid][bizExitVW]) BizInfo[bizid][bOutsideFurniture]++;
		
	}
	return 1;
}

this::OnBizInsert(businessID)
{
	return BizInfo[businessID][bizID] = cache_insert_id();	
}

this::GivePlayerBizMoney(cash, ownerid)
{
	if (!cache_num_rows())	return 1;

	new player_cash = cache_get_field_content_int(0, "cash") + cash;

    new query[128];
    mysql_format(dbHandle, query, sizeof(query), "UPDATE `users` SET `cash` = %i WHERE `id` = %i", player_cash, ownerid);
	mysql_tquery(dbHandle, query);
	return 1;
}


AddBizToFile(bizid, level, price, freeze, type, name[], entermsg[], Float:x, Float:y, Float:z, Float:ex, Float:ey, Float:ez, posint, posvw, exitint, exitvw)
{
    new query[128 + 128 + 128];
	mysql_format(dbHandle, query, sizeof(query), "INSERT INTO `business` (posx, posy, posz, exitx, exity, exitz, name, entermsg, price, freeze, levelbuy, type, posint, posvw, exitint, exitvw) VALUES (%f, %f, %f, %f, %f, %f, '%s', '%s', %i,%i,%i,%i,%i,%i,%i,%i)",
	x, y, z, ex, ey, ez, name, entermsg, price, freeze, level, type, posint, posvw, exitint, exitvw);
	mysql_tquery(dbHandle, query, "OnBizInsert", "d", bizid);
 	return 1;
}

SetBizInterior(playerid, bizid, id)
{
    BizInfo[bizid][bizExitX] = AdminTeles[id][telesPosX];
	BizInfo[bizid][bizExitY] = AdminTeles[id][telesPosY];
	BizInfo[bizid][bizExitZ] = AdminTeles[id][telesPosZ];
	BizInfo[bizid][bizExitInt] = AdminTeles[id][telesInt];
	SendSyntaxMessage(playerid, "Doanh nghiep [ID: %i | Noi that: %s", bizid, AdminTeles[id][telesMapName]);
	Save_Business(bizid);
	return 1;
}

Sell_Business(bizid)
{
    BizInfo[bizid][bizOwnerID] = 
	BizInfo[bizid][bizLocked] =
	BizInfo[bizid][bizRadio] =
	BizInfo[bizid][bizRadioOn] =
	BizInfo[bizid][bizDDoor] =
	BizInfo[bizid][bizCash] = 
	BizInfo[bizid][bizEntrance] = 0;
	strmid(BizInfo[bizid][bizOwner], "Nha Nuoc", 0, strlen("Nha Nuoc"), MAX_PLAYER_NAME);
	UpdateBusinessDoor(bizid);
	StopBusinessBoomBox(bizid);

	for(new i = 0; i != MAX_GARAGES; i++)
	{
	    if (!GarageInfo[i][garageID] || GarageInfo[i][garageBiz] != BizInfo[bizid][bizID]) continue;

        GarageInfo[i][garageOwner] = 0;

        new query[128];
		mysql_format(dbHandle, query, sizeof(query), "UPDATE `garage` SET `owner`='' WHERE `id`=%i", GarageInfo[i][garageID]);
		mysql_tquery(dbHandle, query);
	}

	Save_Business(bizid);
	return 1;
}

Save_Business(bizid)
{
    new query[1024];
    
	mysql_format(dbHandle, query, sizeof(query), "UPDATE `business` SET `locked`=%i,`price`=%i,`freeze`=%i,`levelbuy`=%i,`exitint`=%i,`exitvw`=%i,`cash`=%i,`type`=%i,`entrance`=%i", BizInfo[bizid][bizLocked],
	BizInfo[bizid][bizPrice], BizInfo[bizid][bizFreeze], BizInfo[bizid][bizLevelbuy], BizInfo[bizid][bizExitInt], BizInfo[bizid][bizExitVW], BizInfo[bizid][bizCash], BizInfo[bizid][bizType], BizInfo[bizid][bizEntrance]);

	mysql_format(dbHandle,query, sizeof(query), "%s,`owner`=%i,`name`='%e',`entermsg`='%e',`posint`=%i,`posvw`=%i", query, BizInfo[bizid][bizOwnerID], BizInfo[bizid][bizName], BizInfo[bizid][bizMes], BizInfo[bizid][bizPosInt],
	BizInfo[bizid][bizPosVW]);

	mysql_format(dbHandle, query, sizeof(query), "%s,`posx`=%f,`posy`=%f,`posz`=%f,`exitx`=%f,`exity`=%f,`exitz`=%f,`radio`=%i", query, BizInfo[bizid][bizPosX], BizInfo[bizid][bizPosY], BizInfo[bizid][bizPosZ], 
	BizInfo[bizid][bizExitX], BizInfo[bizid][bizExitY], BizInfo[bizid][bizExitZ], BizInfo[bizid][bizRadio]);

	mysql_format(dbHandle, query, sizeof(query), "%s,`ddoor`=%i,`product`=%i,`buy_price`=%i", query, BizInfo[bizid][bizDDoor], BizInfo[bizid][bizProduct], BizInfo[bizid][bizBuyPrice]);

	for(new i = 0; i < 12; i++)
	{
		mysql_format(dbHandle, query, sizeof(query), "%s,`productprice%i`=%i", query, i, BizInfo[bizid][bizProductPrice][i]);
	}

	mysql_format(dbHandle, query, sizeof(query), "%s WHERE `id`=%i", query, BizInfo[bizid][bizID]);
	mysql_tquery(dbHandle, query);
	return 1;
}

UpdateBusinessDoor(bizid)
{
	if (IsValidDynamic3DTextLabel(BizInfo[bizid][bizLabelDDoor]))
	{
	    DestroyDynamic3DTextLabel(BizInfo[bizid][bizLabelDDoor]);
        BizInfo[bizid][bizLabelDDoor] = Text3D:INVALID_3DTEXT_ID;
	}
	if (!BizInfo[bizid][bizDDoor])	return 1;

    new door_str[][] =	{"DOOR KNOWN", "DOOR BREAKED"};
		
	BizInfo[bizid][bizLabelDDoor] = CreateDynamic3DTextLabel(door_str[BizInfo[bizid][bizDDoor]-1], COLOR_LIGHTRED, BizInfo[bizid][bizPosX], BizInfo[bizid][bizPosY], BizInfo[bizid][bizPosZ], 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, BizInfo[bizid][bizPosVW], BizInfo[bizid][bizPosInt], -1, 100.0);
	return 1;
}

GetNextBizID()
{
	for(new i; i != MAX_BIZ; i++)
	{
	    if (BizInfo[i][bizID] == 0) return i;
	}
	return -1;
}

GetPlayerBizes(playerid)
{
	new total;

    for(new i; i != MAX_BIZ; i++)
	{
	    if (BizInfo[i][bizID] == 0 || BizInfo[i][bizOwnerID] != PlayerInfo[playerid][pID]) continue;

		total++;
	}
	return total;
}

GetMaxPlayerBiz(playerid)
{
	switch(PlayerInfo[playerid][pPremium])
	{
	    case 0: return 1;
	    case 1: return 1;
	    case 2: return 2;
	    case 3: return 3;
	}
	return 1;
}

GiveBizCash(bizid, cash)
{
	if (bizid < 0 || bizid > MAX_BIZ-1 || BizInfo[bizid][bizID] == 0 || BizInfo[bizid][bizOwnerID] == 0)	return 0;

	BizInfo[bizid][bizCash] += cash;

	new query[128];
	mysql_format(dbHandle, query, sizeof(query), "UPDATE `business` SET `cash` = %i, `product` = %i WHERE `id` = %i", BizInfo[bizid][bizCash], BizInfo[bizid][bizProduct], BizInfo[bizid][bizID]);
	mysql_tquery(dbHandle, query);
	return 1;
}

GiveBizCashWithdraw(bizid, cash)
{
	if (bizid < 0 || bizid > MAX_BIZ-1 || BizInfo[bizid][bizID] == 0 || BizInfo[bizid][bizOwnerID] == 0)	return 0;

	BizInfo[bizid][bizCash] -= cash;

	new query[128];
	mysql_format(dbHandle, query, sizeof(query), "UPDATE `business` SET `cash` = %i, `product` = %i WHERE `id` = %i", BizInfo[bizid][bizCash], BizInfo[bizid][bizProduct], BizInfo[bizid][bizID]);
	mysql_tquery(dbHandle, query);
	return 1;
}

BuyGunMenu(playerid)
{
    if (PlayerInfo[playerid][pOnDuty])		return SendErrorMessage(playerid, "Ban khong the mua vu khi khi dang onduty.");
    if (PlayerInfo[playerid][pWepLic] != 1)	return SendErrorMessage(playerid, "Ban khong co giay phep su dung vu khi.");
			
    Dialog_Show(playerid, BuyGunMenu, DIALOG_STYLE_LIST, "Mua Vu Khi", "{FFFFFF}Vu khi\nDan duoc\nBo sung\n	\n{c7c7c7}Su dung /ammohelp", ">>>", "Huy bo");
	return 1;
}

GetNearOutsideBiz(playerid, Float: radius = 3.0)
{
    for(new i; i != MAX_BIZ; i++)
	{
	    if (BizInfo[i][bizID] == 0) continue;
	    if (IsPlayerInRangeOfPoint(playerid, radius, BizInfo[i][bizPosX], BizInfo[i][bizPosY], BizInfo[i][bizPosZ]) && GetWorld(playerid) == BizInfo[i][bizPosVW] && GetInterior(playerid) == BizInfo[i][bizPosInt]) return i;
	}
	return -1;
}

stock GetClosestTypeBiz(playerid, type, &Float:radius)
{
	new cl_ID = -1, Float:cl_Dist;
	radius = 9999.0;
	
	for(new i = 0; i < MAX_BIZ; i++)
	{
	    if ( BizInfo[i][bizID] == 0 || BizInfo[i][bizType] != type ) continue;
		if ( (cl_Dist = GetPlayerDistanceToPointEx(playerid, BizInfo[i][bizPosX], BizInfo[i][bizPosY], BizInfo[i][bizPosZ])) < radius )
		{
		    cl_ID = i;
		    radius = cl_Dist;
		}
	}
	return cl_ID;
}

GetNearInsideBiz(playerid, Float: radius = 25.0)
{
	if (pTemp[playerid][pBizEntered] != -1 && IsPlayerBizInside(playerid, pTemp[playerid][pBizEntered], radius))	return pTemp[playerid][pBizEntered];

    for(new i; i != MAX_BIZ; i++)
	{
	    if (BizInfo[i][bizID] == 0) continue;
	    if (IsPlayerInRangeOfPoint(playerid, radius, BizInfo[i][bizExitX], BizInfo[i][bizExitY], BizInfo[i][bizExitZ]) && GetWorld(playerid) == BizInfo[i][bizExitVW] && GetInterior(playerid) == BizInfo[i][bizExitInt])
		{
		    pTemp[playerid][pBizEntered] = i;
			return i;
		}
	}
	return -1;
}

GetNearBiz(playerid, Float: radius_inside = 30.0, Float: radius_outside = 5.0)
{
    new bizid = GetNearInsideBiz(playerid, radius_inside);

	if (bizid == -1)		bizid = GetNearOutsideBiz(playerid, radius_outside);
	if (bizid != -1)		return bizid;

	return -1;
}

IsPlayerBizOutside(playerid, i, Float: radius = 5.0)
{
    return (BizInfo[i][bizID] != 0 && IsPlayerInRangeOfPoint(playerid, radius, BizInfo[i][bizPosX], BizInfo[i][bizPosY], BizInfo[i][bizPosZ]) && GetWorld(playerid) == BizInfo[i][bizPosVW] && GetInterior(playerid) == BizInfo[i][bizPosInt]) ? (1) : (0);
}

IsPlayerBizInside(playerid, i, Float: radius = 15.0)
{
    return (BizInfo[i][bizID] != 0 && IsPlayerInRangeOfPoint(playerid, radius, BizInfo[i][bizExitX], BizInfo[i][bizExitY], BizInfo[i][bizExitZ]) && GetWorld(playerid) == BizInfo[i][bizExitVW] && GetInterior(playerid) == BizInfo[i][bizExitInt]) ? (1) : (0);
}

AZC_Nearest(playerid)
{
	new 
		bizid = -1, 
		vehicle = GetPlayerVehicleID(playerid),
		Float: radius = (IsABoat(vehicle))?(20.0):(10.0)
	;
        
    for(new i; i != MAX_BIZ; i++)
	{
	    if (!BizInfo[i][bizID] || BizInfo[i][bizType] != BIZ_GAS_STATION) continue;

	    if (IsPlayerInRangeOfPoint(playerid, radius, BizInfo[i][bizPosX], BizInfo[i][bizPosY], BizInfo[i][bizPosZ]) && GetWorld(playerid) == BizInfo[i][bizPosVW] && GetInterior(playerid) == BizInfo[i][bizPosInt])
		{
		    bizid = i;
			return bizid;
		}
	} 
	return bizid;
}

PAS_Nearest(playerid)
{
	new 
		bizid = -1, 
		vehicle = GetPlayerVehicleID(playerid),
		Float: radius = (IsABoat(vehicle))?(20.0):(10.0)
	;
        
    for(new i; i != MAX_BIZ; i++)
	{
	    if (!BizInfo[i][bizID] || BizInfo[i][bizType] != BIZ_PAYNSPRAY) continue;

	    if (IsPlayerInRangeOfPoint(playerid, radius, BizInfo[i][bizPosX], BizInfo[i][bizPosY], BizInfo[i][bizPosZ]) && GetWorld(playerid) == BizInfo[i][bizPosVW] && GetInterior(playerid) == BizInfo[i][bizPosInt])
		{
		    bizid = i;
			return bizid;
		}
	} 
	return bizid;
}

WorkSpace(bizid)
{
	for(new i = 0; i < MAX_WORK_SPACE; i++)
	{
		if (!BizWorkers[bizid][i][bizJobOn]) return i;
	}

	return -1;
}

RemoveAllWorkers(bizid)
{
	for(new listitem = 0; listitem < MAX_WORK_SPACE; listitem++)
	{
		SQL_SetString("users", "position", BizWorkers[bizid][listitem][bizPosition], BizWorkers[bizid][listitem][bizJobOn]);
		SQL_SetInteger("users", "workon", 0, BizWorkers[bizid][listitem][bizJobOn]);
		
		for(new i; i < GetPlayerPoolSize(); i++)
		{
			if (PlayerInfo[i][pID] == BizWorkers[bizid][listitem][bizJobOn])
			{
				SendSyntaxMessage(i, "Ban da bi sa thai khoi %s (doanh nghiep).", BizInfo[bizid][bizName]);
				PlayerInfo[i][pWorkOn] = 0;
				break;
			}
		}

		BizWorkers[bizid][listitem][bizWorker] = EOS;
		BizWorkers[bizid][listitem][bizPosition] = EOS;
		BizWorkers[bizid][listitem][bizJobOn] = 0;
	}
	return 1;
}

BizFurn(playerid)
{
	new bizid = GetNearBiz(playerid);
	if (BizInfo[bizid][bizOwnerID] != PlayerInfo[playerid][pID] && BizInfo[bizid][bizID] != pTemp[playerid][pBuildHouse])
		return SendErrorMessage(playerid, "Ban khong co quyen quan ly cac phu kien cua doanh nghiep nay.");
	
	new title[32 + 33];
	format(title, sizeof(title), "{FFFFFF}Noi that doanh nghiep %s [ID:%i]", BizInfo[bizid][bizName], BizInfo[bizid][bizID]);

	pTemp[playerid][pFurniture] = bizid;
	pTemp[playerid][pFurnitureB] = 1;

	Dialog_Show(playerid, FurnitureDialog, DIALOG_STYLE_LIST, title, "Mua noi that\nChinh sua noi that\nBan tat ca noi that", "Chon", "Huy bo");
	return 1;
}

BizFurnCopy(playerid, building, slot)
{
	if (GetCash(playerid) < BFurn[building][slot][fMarketPrice]) 
		return SendNotCash(playerid);

    if (BFurn[building][slot][fCategory] == 28 && BizInfo[building][bOutsideFurniture] > 9) 
		return SendErrorMessage(playerid, "Chi co the dat 10 do vat ben ngoai ngoi nha.");
    
	new i = -1;
	for(new a; a < MAX_FURNITURE; a++)
	{
	    if (BFurn[building][a][fOn] != 0) continue;

   		i = a;
		break;
	}

	if (i == -1) return 1;

	//BFurn[building][i][fObject] = CreateDynamicObject(BFurn[building][slot][fModel], BFurn[building][slot][fPosX], BFurn[building][slot][fPosY], BFurn[building][slot][fPosZ], BFurn[building][slot][fPosRX], BFurn[building][slot][fPosRY], BFurn[building][slot][fPosRZ], BFurn[building][slot][fVirtualWorld], BFurn[building][slot][fInterior]);

	new tid[5];
    for(new b; b != 5; b++)
	{
		tid[b] = -1;
 		if (BFurn[building][slot][fTexture][b] != -1) tid[b] = BFurn[building][slot][fTexture][b];
	}

	new f_index = GetFurnitureIndex(BFurn[building][slot][fCategory], BFurn[building][slot][fModel]);
	SetPVarInt(playerid, "buy_furniture", 2);
	OnPlayerCallBuyFurniture(playerid, building, 1, i, BFurn[building][slot][fModel], BFurn[building][slot][fCategory], f_index, BFurn[building][slot][fPosX], BFurn[building][slot][fPosY], BFurn[building][slot][fPosZ], BFurn[building][slot][fPosRX], BFurn[building][slot][fPosRY], BFurn[building][slot][fPosRZ], tid[0], tid[1], tid[2], tid[3], tid[4]);
	return 1;
}

BizHandleSellFurn(playerid, building)
{
	new paycheck;

	for(new i; i < MAX_FURNITURE; i++)
	{
	    if (!BFurn[building][i][fID] || !BFurn[building][i][fOn]) continue;

	    paycheck += (BFurn[building][i][fMarketPrice] - (BFurn[building][i][fMarketPrice] & 2))  / 2;
	    BFurn[building][i][fID] =
	    BFurn[building][i][fOn] = 0;
	    DestroyDynamicObject(BFurn[building][i][fObject]);
	}

    BizInfo[building][bFurniture] =
    BizInfo[building][bOutsideFurniture] = 0;
    
   	new query[128];
	mysql_format(dbHandle, query, sizeof(query), "DELETE FROM `furnitures` WHERE `building` = %i AND `bType` = 1", BizInfo[building][bizID]);
	mysql_tquery(dbHandle, query);

	SendSyntaxMessage(playerid, "Ban da ban tat ca do dac trong doanh nghiep va nhan duoc 50 %% chi phi, ${FFFF00}%i{FFFFFF}.", paycheck);
	GiveCash(playerid, paycheck);
	return 1;
}

CreateExplosionInBiz(building, idx, f)
{
	new count = 0;

	for(new i; i < MAX_FURNITURE; i++)
	{
		if (count > 5) break;

	    if (!BFurn[building][i][fOn] || !IsValidDynamicObject(BFurn[building][i][fObject])) continue;
		if (BFurn[building][i][fInterior] != BizInfo[building][bizExitInt] && BFurn[building][i][fVirtualWorld] != BizInfo[building][bizExitVW])	continue;
		if (GetDistanceBetweenPoints(BFurn[building][f][fPosX],BFurn[building][f][fPosY],BFurn[building][f][fPosZ],BFurn[building][i][fPosX],BFurn[building][i][fPosY],BFurn[building][i][fPosZ]) > 10.0) continue;
		if (!IsFurnitureFirable(BFurn[building][i][fCategory])) continue;

		new Float:fHitPosX = BFurn[building][i][fPosX],
			Float:fHitPosY = BFurn[building][i][fPosY],
			Float:fHitPosZ = BFurn[building][i][fPosZ],
			furnint = BFurn[building][i][fInterior],
			furnvw = BFurn[building][i][fVirtualWorld]
		;

		if (GetNearFire(fHitPosX,fHitPosY,fHitPosZ,furnint,furnvw) != -1) continue;
		if (floatround(randomEx(0,100)) > 80) OnPlayerSellFurniture(0, building, i);
		count ++;

		new fireid = -1;
		for(new j; j != MAX_FIRES; j++)
		{
		    if (FiresInfo[j][fireOn] != 0) continue;

			fireid = j;
			break;
		}
		if (fireid == -1)	continue;

		FiresInfo[fireid][fireOn] = 1;
		FiresInfo[fireid][fireObj] = CreateDynamicObject(18691, fHitPosX, fHitPosY, fHitPosZ-2.0, 0.0, 0.0, 0.0, furnvw, furnint);
		FiresInfo[fireid][firePos][0] = fHitPosX;
		FiresInfo[fireid][firePos][1] = fHitPosY;
		FiresInfo[fireid][firePos][2] = fHitPosZ;
		FiresInfo[fireid][fireVW] = furnvw;
		FiresInfo[fireid][fireInt] = furnint;
		FiresInfo[fireid][fireHealth] = 100;
		FiresInfo[fireid][fireTimer] = 1800;

		FiresInfo[fireid][fireLabel] = CreateDynamic3DTextLabel("100 %", 0xCC0500FFF, fHitPosX, fHitPosY, fHitPosZ+2.3, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, furnvw, furnint, -1, 100.0);
	}

	CreateDynamicExplosion(BFurn[building][f][fPosX],BFurn[building][f][fPosY],BFurn[building][f][fPosZ], 11, 10.0, BFurn[building][f][fVirtualWorld], BFurn[building][f][fInterior]);
	ClearFurnitureData(f, idx);

	new Float:fHitPosX = BizInfo[building][bizPosX], 
		Float:fHitPosY = BizInfo[building][bizPosY],
		Float:fHitPosZ = BizInfo[building][bizPosZ],
		furnint = BizInfo[building][bizPosInt],
		furnvw = BizInfo[building][bizPosVW]
	;

	new fireid = -1;
	for(new j; j != MAX_FIRES; j++)
	{
		if (FiresInfo[j][fireOn] != 0) continue;

		fireid = j;
		break;
	}
	if (fireid == -1)	return 1;

	FiresInfo[fireid][fireOn] = 1;
	FiresInfo[fireid][fireObj] = CreateDynamicObject(18691, fHitPosX, fHitPosY, fHitPosZ-2.0, 0.0, 0.0, 0.0, furnvw, furnint);
	FiresInfo[fireid][firePos][0] = fHitPosX;
	FiresInfo[fireid][firePos][1] = fHitPosY;
	FiresInfo[fireid][firePos][2] = fHitPosZ;
	FiresInfo[fireid][fireVW] = furnvw;
	FiresInfo[fireid][fireInt] = furnint;
	FiresInfo[fireid][fireHealth] = 100;
	FiresInfo[fireid][fireTimer] = 1800;

	FiresInfo[fireid][fireLabel] = CreateDynamic3DTextLabel("100 %", 0xCC0500FFF, fHitPosX, fHitPosY, fHitPosZ+2.3, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, furnvw, furnint, -1, 100.0);

	return 1;
}

CreateFireInBiz(building)
{
	new count = 0;

	new Float:fHitPosX = BizInfo[building][bizPosX], 
		Float:fHitPosY = BizInfo[building][bizPosY],
		Float:fHitPosZ = BizInfo[building][bizPosZ],
		furnint = BizInfo[building][bizPosInt],
		furnvw = BizInfo[building][bizPosVW]
	;

	new fireid = -1;
	for(new j; j != MAX_FIRES; j++)
	{
		if (FiresInfo[j][fireOn] != 0) continue;

		fireid = j;
		break;
	}
	if (fireid == -1)	return 1;

	FiresInfo[fireid][fireOn] = 1;
	FiresInfo[fireid][fireObj] = CreateDynamicObject(18691, fHitPosX, fHitPosY, fHitPosZ-2.0, 0.0, 0.0, 0.0, furnvw, furnint);
	FiresInfo[fireid][firePos][0] = fHitPosX;
	FiresInfo[fireid][firePos][1] = fHitPosY;
	FiresInfo[fireid][firePos][2] = fHitPosZ;
	FiresInfo[fireid][fireVW] = furnvw;
	FiresInfo[fireid][fireInt] = furnint;
	FiresInfo[fireid][fireHealth] = 100;
	FiresInfo[fireid][fireTimer] = 1800;

	FiresInfo[fireid][fireLabel] = CreateDynamic3DTextLabel("100 %", 0xCC0500FFF, fHitPosX, fHitPosY, fHitPosZ+2.3, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, furnvw, furnint, -1, 100.0);

	fHitPosX = BizInfo[building][bizExitX];
	fHitPosY = BizInfo[building][bizExitY];
	fHitPosZ = BizInfo[building][bizExitZ];

	BizInfo[building][bFireTimer] = gettime()+3600;

	for(new i; i < MAX_FURNITURE; i++)
	{
		if (count > 5) break;

	    if (!BFurn[building][i][fOn] || !IsValidDynamicObject(BFurn[building][i][fObject])) continue;
		if (BFurn[building][i][fInterior] != BizInfo[building][bizExitInt] && BFurn[building][i][fVirtualWorld] != BizInfo[building][bizExitVW])	continue;
		if (GetDistanceBetweenPoints(fHitPosX,fHitPosY,fHitPosZ,BFurn[building][i][fPosX],BFurn[building][i][fPosY],BFurn[building][i][fPosZ]) > 10.0) continue;
		if (!IsFurnitureFirable(BFurn[building][i][fCategory])) continue;

		fHitPosX = BFurn[building][i][fPosX]; 
		fHitPosY = BFurn[building][i][fPosY];	
		fHitPosZ = BFurn[building][i][fPosZ];
		furnint = BFurn[building][i][fInterior];
		furnvw = BFurn[building][i][fVirtualWorld];

		if ( GetNearFire(fHitPosX,fHitPosY,fHitPosZ,furnint,furnvw) != -1 ) continue;
		count++;

		for(new j; j != MAX_FIRES; j++)
		{
		    if (FiresInfo[j][fireOn] != 0) continue;

			fireid = j;
			break;
		}
		if (fireid == -1)	continue;

		FiresInfo[fireid][fireOn] = 1;
		FiresInfo[fireid][fireObj] = CreateDynamicObject(18691, fHitPosX, fHitPosY, fHitPosZ-2.0, 0.0, 0.0, 0.0, furnvw, furnint);
		FiresInfo[fireid][firePos][0] = fHitPosX;
		FiresInfo[fireid][firePos][1] = fHitPosY;
		FiresInfo[fireid][firePos][2] = fHitPosZ;
		FiresInfo[fireid][fireVW] = furnvw;
		FiresInfo[fireid][fireInt] = furnint;
		FiresInfo[fireid][fireHealth] = 100;
		FiresInfo[fireid][fireTimer] = 1800;

		FiresInfo[fireid][fireLabel] = CreateDynamic3DTextLabel("100 %", 0xCC0500FFF, fHitPosX, fHitPosY, fHitPosZ+2.3, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, furnvw, furnint, -1, 100.0);
	}
	return 1;
}

DisplayBizList(playerid)
{
	new maxpages = floatround(MAX_BIZ/MAX_DIALOG_LIST,floatround_ceil);
	if (pTemp[playerid][pDialogList] < 0 || (maxpages < pTemp[playerid][pDialogList]+1)) return 1;
	
	new 
		start_itter = MAX_DIALOG_LIST * pTemp[playerid][pDialogList],
		end_itter = (maxpages == pTemp[playerid][pDialogList]+1) ? (MAX_BIZ) : (start_itter+MAX_DIALOG_LIST+1),
		count, 
		str[54+(64+2+2+2+2+2)*MAX_DIALOG_LIST+(35+26)] = "{FFFFFF}ID\t{FFFFFF}Doanh nghiep\t{FFFFFF}So huu{FFFFFF}\n"
	;

	if (pTemp[playerid][pDialogList]) format(str, sizeof(str), "%s{bccd32}Trang truoc{FFFFFF}\n", str);

	for(new i = start_itter; i < end_itter; i++)
	{
	    if (!BizInfo[i][bizID]) continue;

		if (count == MAX_DIALOG_LIST) 
		{
			strcat(str, "{bccd32}Next page");
		} 
		else 
		{
			format(str, sizeof(str), "%s%i\t%s\t%s\n", str, BizInfo[i][bizID], BizInfo[i][bizName], i, BizInfo[i][bizOwner]);
			count++;
		}
	}

	if (!count) return Dialog_Show(playerid, None, DIALOG_STYLE_LIST, "{FFFFFF}Danh sach doanh nghiep", "Khong co doanh nghiep nao tren may chu ...", ">>>", "");

    Dialog_Show(playerid, DisplayBizDialog, DIALOG_STYLE_TABLIST_HEADERS, "{FFFFFF}Danh sach doanh nghiep", str, ">>>", "");
	return 1;
}

Dialog:DisplayBizDialog(playerid, response, listitem, inputtext[])
{
	if (!response) return 1;

	if (pTemp[playerid][pDialogList]) {		//if not first page
		if (listitem == 0) {
			pTemp[playerid][pDialogList]--;
			return DisplayBizList(playerid);
		} else if (listitem == MAX_DIALOG_LIST+1) {
			pTemp[playerid][pDialogList]++;
			return DisplayBizList(playerid);
		} else {
			new bizid = pTemp[playerid][pDialogList]*MAX_DIALOG_LIST+listitem;
			SetPlayerPosEx(playerid, BizInfo[bizid][bizPosX], BizInfo[bizid][bizPosY], BizInfo[bizid][bizPosZ]);
			SetInterior(playerid, BizInfo[bizid][bizPosInt]);
			SetWorld(playerid, BizInfo[bizid][bizPosVW]);
			SendSpecialMessage(playerid, "Ban da dich chuyen de doanh nghiep [ID: %i].", bizid);
			return DisplayBizList(playerid);
		}
	} else { 								//if it's a first page
		if (listitem == MAX_DIALOG_LIST) {
			pTemp[playerid][pDialogList]++;
			return DisplayBizList(playerid);
		} else {
			new bizid = pTemp[playerid][pDialogList]*MAX_DIALOG_LIST+listitem;
			SetPlayerPosEx(playerid, BizInfo[bizid][bizPosX], BizInfo[bizid][bizPosY], BizInfo[bizid][bizPosZ]);
			SetInterior(playerid, BizInfo[bizid][bizPosInt]);
			SetWorld(playerid, BizInfo[bizid][bizPosVW]);
			SendSpecialMessage(playerid, "Ban da dich chuyen de doanh nghiep [ID: %i].", bizid);
			return DisplayBizList(playerid);
		}
	}

	//return 1;
}

GetBusinessZone(bizid, type = 0)
{
	new string[70], zone[28];

	GetZone(BizInfo[bizid][bizPosX], BizInfo[bizid][bizPosY], zone, sizeof(zone));
	
	if (IsPointInAnyDynamicArea(BizInfo[bizid][bizPosX], BizInfo[bizid][bizPosY], BizInfo[bizid][bizPosZ])) 
	{
		new areas[5], street_area[1], j = GetNumberDynamicAreasForPoint(BizInfo[bizid][bizPosX],BizInfo[bizid][bizPosY],BizInfo[bizid][bizPosZ]);
		GetDynamicAreasForPoint(BizInfo[bizid][bizPosX], BizInfo[bizid][bizPosY], BizInfo[bizid][bizPosZ], areas, sizeof(areas));

		if (GetStreet(areas, j, street_area)) 
		{
			if (type == 0) 		format(string, sizeof(string), "%s, %s %i", zone, street_names[street_area[0]], bizid); 
			else if (type == 1) 	format(string, sizeof(string), "%03d %s, %s", bizid, street_names[street_area[0]], zone);
			else if (type == 2) 	format(string, sizeof(string), "%s %i", street_names[street_area[0]], bizid); 

			return string;
		}
	}

	format(string, sizeof(string), "%s %i", zone, 35+bizid);
	return string;
}