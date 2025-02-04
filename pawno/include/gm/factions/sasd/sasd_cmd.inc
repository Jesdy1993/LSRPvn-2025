CMD:taser(playerid, params[])
{
	new faction = PlayerInfo[playerid][pFaction];

	if (!IsFactionPolice(faction) && !IsFactionDocs(faction))	return SendErrorMessage(playerid, "Ban phai la nhan vien canh sat / nhan vien nha tu.");
	if (!PlayerInfo[playerid][pOnDuty])							return SendErrorMessage(playerid, "Ban can phai trong gio lam viec (/duty).");

	if (!pTemp[playerid][pTaser])
	{
		if (PlayerInfo[playerid][pPlayerWeapon] != 0) cmd::putgun(playerid, "");
		GivePlayerWeaponEx(playerid, 23, 1, 1, 0);
		pTemp[playerid][pTaser] = 1;
		SetPlayerChatBubble(playerid, "rut sung gay choang tu that lung ra.", COLOR_PURPLE, 20.0, 4000);
		SM1(playerid, "Ban da lay sung gay choang. ");
	    return 1;
	}

	ResetPlayerWeapons(playerid);

	if (PlayerInfo[playerid][pPlayerWeapon] != 0) RemovePlayerAttachedObject(playerid, ATTACH_HANDS);

	PlayerInfo[playerid][pPlayerWeapon] = 0;
	PlayerInfo[playerid][pPlayerAmmo] = 0;
	PlayerInfo[playerid][pAmmoType] = 0;
	PlayerInfo[playerid][pWepSerial] = 0;
	
    pTemp[playerid][pTaser] = 0;
	SetPlayerChatBubble(playerid, "cat sung gay choang vao that lung.", COLOR_PURPLE, 20.0, 4000);
	SM1(playerid, "Ban da cat sung gay choang. ");
	return 1;
}

CMD:trace(playerid, params[])
{
	new faction = PlayerInfo[playerid][pFaction];

	if (!IsFactionPolice(faction))		return SendErrorMessage(playerid, "Ban phai la mot nhan vien canh sat.");
    if (!PlayerInfo[playerid][pOnDuty])	return SendErrorMessage(playerid, "Ban can phai trong gio lam viec (/duty).");

	new vehicle = GetPlayerVehicleID(playerid);

	if (!IsPlayerInAnyVehicle(playerid))				return SendNotInVehicle(playerid);
	if (VehicleInfo[vehicle][carFaction] != faction)	return SendErrorMessage(playerid, "Ban khong o tren phuong tien to chuc.");

	new trace, targetid;

	if (sscanf(params,"d", trace))									return SendHelpMessage(playerid, "/trace [so dien thoai]");
	if (pTemp[playerid][pTracePlayer] != INVALID_PLAYER_ID)			return SendErrorMessage(playerid, "Truoc tien hay tat no (/traceoff).");
	//if (trace == PlayerInfo[playerid][pNumber])						return 1;
    if ((targetid = GetNumberOwner(trace)) == INVALID_PLAYER_ID)	return SendErrorMessage(playerid, "So nay khong duoc tim thay trong du lieu.");
    if (PlayerInfo[targetid][pJailed] != 0)							return SendErrorMessage(playerid, "Nguoi nay dang bi giam giu.");

	SendFactionMessage(FACTION_POLICE, COLOR_POLICECHAT, "** HQ: %s %s da bat dau theo doi so dien thoai %i. **", GetRankName(playerid), GetNameEx(playerid), trace);

	Dialog_Show(playerid, ShowTrace, DIALOG_STYLE_MSGBOX, "He thong theo doi", "{B4B5B7}Theo doi da bat dau . . .", "Dong", "");

	pTemp[playerid][pTracePlayer] = targetid;
	pTemp[playerid][pTraceStage] = 0;

	new Float:x, Float:y, Float:z;
	
	if (GetWorld(targetid) || GetInterior(targetid))
	{
		x = PlayerInfo[targetid][pLocationPos][0];
		y = PlayerInfo[targetid][pLocationPos][1];
		z = PlayerInfo[targetid][pLocationPos][2];
	}
	else GetPlayerPos(targetid, x, y, z);

	pTemp[playerid][pTraceDist][0] = GetDistanceBetweenPoints(x, y, z, 1459.3712, -783.0401, 93.6459);
	pTemp[playerid][pTraceDist][1] = GetDistanceBetweenPoints(x, y, z, 2667.2908, -1957.5245, 13.5469);
	pTemp[playerid][pTraceDist][2] = GetDistanceBetweenPoints(x, y, z, 923.6055, -1893.5146, 1.5319);
	return 1;
}

CMD:traceoff(playerid, params[])
{
	if (pTemp[playerid][pTracePlayer] == INVALID_PLAYER_ID)	return SendErrorMessage(playerid, "Ban khong dang bat he thong theo doi.");

	if (pTemp[playerid][pTraceGZ] != -1) GangZoneDestroy(pTemp[playerid][pTraceGZ]);
    
	pTemp[playerid][pTraceGZ] = -1;
    pTemp[playerid][pTracePlayer] = INVALID_PLAYER_ID;
    pTemp[playerid][pTraceStage] = 0;
    SendSyntaxMessage(playerid, "Ban da tat he thong theo doi.");
	return 1;
}

CMD:fine(playerid, params[])
{
	new amount, reason[64], userid, faction = PlayerInfo[playerid][pFaction];

	if (!IsPlayerLogged(userid))								return SendNotConnected(playerid);
	if (!PlayerNearPlayer(3.0, playerid, userid))				return SendNotNearPlayer(playerid);
	if (!IsFactionPolice(faction))								return SendErrorMessage(playerid, "Ban phai la mot nhan vien canh sat.");
	if (sscanf(params,"uds[64]", userid, amount, reason))		return SendHelpMessage(playerid, "/fine [ID/Ten] [so tien phat ($1-$5.000)] [ly do]");
	if (!PlayerInfo[playerid][pOnDuty])							return SendErrorMessage(playerid, "Ban can phai trong gio lam viec (/duty).");
	if (strlen(reason) < 1 || strlen(reason) > 63)				return SendErrorMessage(playerid, "Ly do khong duoc qua 63 ky tu.");
	if (amount < 1 || amount > 5000)							return SendErrorMessage(playerid, "So tien phat tu $1 den $5000.");
	if (!GivePlayerTicket(playerid, userid, amount, reason))	return SendErrorMessage(playerid,"Nguoi choi da co so tien phat toi da.");

	new mes[128];
	format(mes, sizeof(mes), "viet mot ve phat doi voi %s va tien phat la $%s Ly do: \"%s\".", GetNameWithMask(userid), FormatNumber(amount), reason);
	SetPlayerChatBubble(playerid, mes, COLOR_PURPLE, 20.0, 4000);

	SM1(playerid, "Ban da viet ve phat \"%s\" voi tien phat la $%s %s.", reason, FormatNumber(amount), GetNameWithMask(userid));
	SendSpecialMessage(userid, "%s %s da viet ve phat cho ban voi so tien $%s. Ly do: \"%s\".", GetRankName(playerid), GetNameWithMask(playerid), FormatNumber(amount), reason);
	SendHelpMessage(userid, "De xem danh sach ve phat, su dung \"/tickets\".");

	pTemp[playerid][pPoliceFines]++;
	return 1;
}

ALTX:vehiclefine("/vfine");
CMD:vehiclefine(playerid, params[])
{
	new amount, vehicle, vehiclenum[12], reason[64], faction = PlayerInfo[playerid][pFaction];

	if (!IsFactionPolice(faction))									return SendErrorMessage(playerid, "Ban phai la mot nhan vien canh sat.");
	if (sscanf(params,"s[12]is[64]", vehiclenum, amount, reason))	return SendHelpMessage(playerid, "/vfine [bien so xe (/checkplate)] [so tien phat ($1-$5.000)] [ly do]");
	if ((vehicle = FindVehicleByPlate(vehiclenum)) == -1)			return SendErrorMessage(playerid, "Phuong tien khong duoc tim thay. ");
	if (!PlayerInfo[playerid][pOnDuty])								return SendErrorMessage(playerid, "Ban can phai trong gio lam viec (/duty)."); 
	if (0 == GetNearVehicle(playerid, 5.0, vehicle))				return SendErrorMessage(playerid, "Ban phai o gan phuong tien. ");
	if (VehicleInfo[vehicle][carRegistered] != 1)					return SendErrorMessage(playerid, "Phuong tien chua duoc dang ky. ");
	if (strlen(reason) < 1 || strlen(reason) > 63)					return SendErrorMessage(playerid, "Ly do khong duoc qua 63 ky tu. ");
	if (amount < 1 || amount > 5000)								return SendErrorMessage(playerid, "So tien phat tu $1 den $5000.");
	if (!GiveVehicleTicket(playerid, vehicle, amount, reason))		return SendErrorMessage(playerid, "Phuong tien nay da co so tien phat toi da. ");
	
	new mes[128];
	format(mes, sizeof(mes), "da viet ve phat cho phuong tien %s voi so tien $%s.", VehicleNames[GetVehicleModel(vehicle)-400], FormatNumber(amount));
	SetPlayerChatBubble(playerid, mes, COLOR_PURPLE, 20.0, 4000);

    new userid = GetVehicleOwner(vehicle);

    if (userid != INVALID_PLAYER_ID)
    {
	    SendSpecialMessage(userid, "%s %s da viet ve phat cho phuong tien %s voi so tien $%s. Ly do: \"%s\".", GetRankName(playerid), GetNameEx(playerid), VehicleNames[GetVehicleModel(vehicle)-400], FormatNumber(amount), reason);
		SendHelpMessage(userid, "De xem danh sach ve phat phuong tien, su dung /vtickets.");
	}

	SM1(playerid, "Ban da viet ve phat \"%s\" cho phuong tien %s voi so tien $%s.", reason, VehicleNames[GetVehicleModel(vehicle)-400], FormatNumber(amount));
	
	pTemp[playerid][pPoliceFines]++;
	return 1;
}

CMD:checkfines(playerid, params[])
{
	if (!IsPlayerFactionPolice(playerid))	return SendErrorMessage(playerid, "Ban phai la mot nhan vien canh sat.");
    if (!PlayerInfo[playerid][pOnDuty])		return SendErrorMessage(playerid, "Ban can phai trong gio lam viec (/duty).");
		
    new userid;

	if (sscanf(params,"u",userid))					return SendHelpMessage(playerid, "/checkfines [ID/Ten]");
	if (!IsPlayerLogged(userid))						return SendNotConnected(playerid);
	if (!PlayerNearPlayer(3.0, playerid, userid))	return SendNotNearPlayer(playerid);

	new query[255];
	mysql_format(dbHandle, query, sizeof(query), "SELECT * FROM `tickets` WHERE `userid`=%i AND `paid`=0 LIMIT %i", PlayerInfo[userid][pID], MAX_TICKETS);
	mysql_tquery(dbHandle, query, "ShowPlayersTickets", "ii", playerid, 0);

	SetPVarInt(playerid, #tickets_show, userid);
	SetPVarInt(playerid, #ticketsuse, 1);
	return 1;
}

CMD:checkvfines(playerid, params[])
{
	if (!IsPlayerFactionPolice(playerid))	return SendErrorMessage(playerid, "Ban phai la mot nhan vien canh sat.");
    if (!PlayerInfo[playerid][pOnDuty])		return SendErrorMessage(playerid, "Ban can phai trong gio lam viec (/duty).");

	new vehicle;

    if (isnull(params))								  return SendHelpMessage(playerid, "/checkvfines [bien so xe (/checkplate)]");
	if (strlen(params) > 12)						  return SendErrorMessage(playerid, "So xe nay khong ton tai.");
    if ((vehicle = FindVehicleByPlate(params)) == -1) return SendErrorMessage(playerid, "Phuong tien khong duoc tim thay.");

	new query[255];
	mysql_format(dbHandle, query, sizeof(query), "SELECT * FROM `tickets` WHERE `vehicle`=%i AND `paid`=0 LIMIT %i", VehicleInfo[vehicle][carID], MAX_TICKETS);
	mysql_tquery(dbHandle, query, "ShowCarsTickets", "i", playerid);

	SetPVarInt(playerid, #tickets_show, vehicle);
	SetPVarInt(playerid, #ticketsuse, 1);
	return 1;
}

ALTX:doorram("/dram");
CMD:doorram(playerid,params[])
{
	if (PlayerInfo[playerid][pInjured] != 0 || GetPVarInt(playerid, "Freeze") || pTemp[playerid][pTaserTime] || pTemp[playerid][pCuffed] || PhoneInfo[playerid][current_page] == PAGE_NOTIFICATION || PlayerInfo[playerid][pJailed] != 0)
		return SendErrorMessage(playerid, "Ban khong the su dung tinh nang nay ngay bay gio.");

	new building;
	switch(GetNearBuilding(playerid)) {
		case 0: {
			building = GetNearInsideHouse(playerid);
			if(building == -1)	return 1;

			for(new i = 0; i < MAX_FURNITURE; i++)
			{
				if (!IsPlayerInRangeOfPoint(playerid, 1.5, HFurn[building][i][fPosX], HFurn[building][i][fPosY], HFurn[building][i][fPosZ]) || !HFurn[building][i][fOn] || !isHouseDoor(HFurn[building][i][fModel]))
				{
					continue;
				}
				if (HFurn[building][i][fOpened])	return SendWarningMessage(playerid, "Cua da duoc mo!");

				cmd::server_ame(playerid,"pha canh cua xuong");
				ApplyAnimation(playerid,"FIGHT_E","FightKick_B",4.1,0,1,0,1,1);
				
				SetTimerEx("DoorRamEnd", 1000, false, "iiii", 0, building, i, playerid);
				break;
			}
		}
		case 1: {
			building = GetNearInsideBiz(playerid);
			if(building == -1)	return 1;
			
			for(new i = 0; i < MAX_FURNITURE; i++)
			{
				if (!IsPlayerInRangeOfPoint(playerid, 1.5, BFurn[building][i][fPosX], BFurn[building][i][fPosY], BFurn[building][i][fPosZ]) || !BFurn[building][i][fOn] || !isHouseDoor(BFurn[building][i][fModel]))
				{
					continue;
				}
				if (BFurn[building][i][fOpened])	return SendWarningMessage(playerid, "Cua da duoc mo!");

				cmd::server_ame(playerid, "pha canh cua xuong");
				ApplyAnimation(playerid,"FIGHT_E","FightKick_B",4.1,0,1,0,1,1);

				SetTimerEx("DoorRamEnd", 1000, false, "iiii", 1, building, i, playerid);
				break;
			}
		}
		case 2: {
			building = GetNearInsideGarage(playerid);
			if(building == -1)	return 1;
			
			for(new i = 0; i < MAX_FURNITURE; i++)
			{
				if (!IsPlayerInRangeOfPoint(playerid, 1.5, GFurn[building][i][fPosX], GFurn[building][i][fPosY], GFurn[building][i][fPosZ]) || !GFurn[building][i][fOn] || !isHouseDoor(GFurn[building][i][fModel]))
				{
					continue;
				}
				if (GFurn[building][i][fOpened])	return SendWarningMessage(playerid, "Cua da duoc mo!");

				cmd::server_ame(playerid, "pha canh cua xuong");
				ApplyAnimation(playerid,"FIGHT_E","FightKick_B",4.1,0,1,0,1,1);

				SetTimerEx("DoorRamEnd", 1000, false, "iiii", 2, building, i, playerid);
				break;
			}
		}
	}	    
	return 1;
}

this::DoorRamEnd(type, building, i, playerid)
{
	switch(type)
	{
		case 0: {
			HFurn[building][i][fLocked] = 0;
			HFurn[building][i][fOpened] = 1;
				
			MoveDynamicObject(HFurn[building][i][fObject], HFurn[building][i][fPosX], HFurn[building][i][fPosY], HFurn[building][i][fPosZ], 1.5, HFurn[building][i][fPosRX], HFurn[building][i][fPosRY], HFurn[building][i][fPosRZ]-90.0);
				
		}
		case 1: {
			BFurn[building][i][fLocked] = 0;
			BFurn[building][i][fOpened] = 1;
				
			MoveDynamicObject(BFurn[building][i][fObject], BFurn[building][i][fPosX], BFurn[building][i][fPosY], BFurn[building][i][fPosZ], 1.5, BFurn[building][i][fPosRX], BFurn[building][i][fPosRY], BFurn[building][i][fPosRZ]-90.0);
		}
		case 2: {
			GFurn[building][i][fLocked] = 0;
			GFurn[building][i][fOpened] = 1;
				
			MoveDynamicObject(GFurn[building][i][fObject], GFurn[building][i][fPosX], GFurn[building][i][fPosY], GFurn[building][i][fPosZ], 1.5, GFurn[building][i][fPosRX], GFurn[building][i][fPosRY], GFurn[building][i][fPosRZ]-90.0);
		}
	}

	ClearAnimations(playerid);
	GameTextForPlayer(playerid, "~w~BAN DA ~y~PHA~w~ CUA", 1000, 1);
	return 1;
}

CMD:ram(playerid,params[])
{
	if (!IsPlayerFactionPolice(playerid)) return SendErrorMessage(playerid, "Ban phai la mot nhan vien canh sat.");
	if (!PlayerInfo[playerid][pOnDuty])	  return SendErrorMessage(playerid, "Ban can phai trong gio lam viec (/duty).");
		    
	new slot;
	
	if (sscanf(params,"d", slot))
	{
		SendHelpMessage(playerid, "/ram [tuy chon]");
		SendSyntaxMessage(playerid, "1 - Mo bang khoa chinh | 2 - Knock out | 3 - Su dung voi C4 | 4 - Mo cua xe ");
	}

	if (slot < 1 || slot > 4)						 return 1;
    if (slot < 4 && PlayerInfo[playerid][pRank] < 4) return SendErrorMessage(playerid, "Tinh nang nay co san cho cap bac 4.");
	if (pTemp[playerid][pRamType])					 return SendErrorMessage(playerid, "Ban da pha cua roi. ");

    new location[MAX_ZONE_NAME];
	GetPlayer2DZone(playerid, location, MAX_ZONE_NAME);

	if (slot == 4) {
		new vehicle = GetNearVehicle(playerid, 2.0);
		if (!vehicle)							  return SendErrorMessage(playerid, "Khong co phuong tien nao gan ban,.");

		if (VehicleInfo[vehicle][carLocked] == 0)  return SendErrorMessage(playerid, "Khoa xe dang duoc mo.");
		if (VehicleInfo[vehicle][carOwnerID] == 0) return SendErrorMessage(playerid, "Phuong tien thuoc nha nuoc. ");
		
		cmd::server_ame(playerid, "pha khoa cua bang mot cai gap.");
		ApplyAnimation(playerid,"OTB","betslp_lkabt", 4.0, 1, 0, 0, 0, 0);

		pTemp[playerid][pRamType] = 1;
		pTemp[playerid][pRamTime] = 30;
		pTemp[playerid][pRamHouse] = -1;
		pTemp[playerid][pRamBiz] = -1;
		pTemp[playerid][pRamGarage] = -1;
		pTemp[playerid][pRamVeh] = vehicle;
		return 1;
	}

	new id = -1;
	if ((id = GetNearOutsideHouse(playerid)) != -1)
	{
	    if (!HouseInfo[id][hOwnerID])									return SendErrorMessage(playerid, "Ngoi nha nay thuoc nha nuoc.");
		if (!HouseInfo[id][hLocked] || HouseInfo[id][hDDoor])			return SendErrorMessage(playerid,"Cua da duoc mo.");

		switch(slot)
		{
		    case 1:
		    {
				cmd::server_ame(playerid, "pha khoa cua bang mot cai gap.");
				ApplyAnimation(playerid,"OTB","betslp_lkabt", 4.0, 1, 0, 0, 0, 0);

				pTemp[playerid][pRamType] = slot;
				pTemp[playerid][pRamTime] = 30;
				pTemp[playerid][pRamHouse] = id;
				pTemp[playerid][pRamBiz] = -1;
				pTemp[playerid][pRamGarage] = -1;
				pTemp[playerid][pRamVeh] = -1;
			}
			case 2:
			{
			    cmd::server_ame(playerid, "pha canh cua.");
				ApplyAnimation(playerid,"FIGHT_E","FightKick_B",4.1,0,1,1,1,1);
				HouseInfo[id][hLocked] = 0;
				HouseInfo[id][hDDoor] = 1;
				Save_House(id);
				UpdateHouseDoor(id);
				GameTextForPlayer(playerid, "~w~BA DA ~y~PHA~w~ CUA", 1000, 1);
				InfoMSG(playerid, "NHAN ~y~\"F\"~w~ HOAC NHAP ~y~/ENTER", 2);

				new query[128];
				format(query, sizeof(query), "%s [MYSQL: %i | IP: %s] pha canh cua (/ram) nha [H_MYSQL: %i]", GetName(playerid), PlayerInfo[playerid][pID], q_GetPlayerIP(playerid), HouseInfo[id][hID]);
			    insert_log(query, RAM_LOG, 5, PlayerInfo[playerid][pAccID], 0);
			}
			case 3:
			{
			    cmd::server_ame(playerid, "cai dat C4 tren cua.");
				OnPlayAnim(playerid, "BOMBER","BOM_Plant",4.0,0,0,0,0,0);
                pTemp[playerid][pRamObj] = CreateDynamicObject(1654, HouseInfo[id][hPosX], HouseInfo[id][hPosY], HouseInfo[id][hPosZ]-0.8, 0.0, 0.0, 90.0, HouseInfo[id][hPosInt], HouseInfo[id][hPosVW]);
				pTemp[playerid][pRamType] = slot;
				pTemp[playerid][pRamTime] = 10;
				pTemp[playerid][pRamHouse] = id;
				pTemp[playerid][pRamBiz] = -1;
				pTemp[playerid][pRamGarage] = -1;
				pTemp[playerid][pRamVeh] = -1;
			}
		}
		return 1;
	}
	
	else if ((id = GetNearOutsideBiz(playerid)) != -1)
	{
	    if (BizInfo[id][bizType] == BIZ_GAS_STATION || BizInfo[id][bizType] == BIZ_AUTOSALON || BizInfo[id][bizType] == BIZ_BOATSALON || BizInfo[id][bizType] == BIZ_FLYSALON || BizInfo[id][bizType] == BIZ_TUNING || BizInfo[id][bizType] == BIZ_ADVERT || BizInfo[id][bizType] == BIZ_LICENSE) return 1;
        if (!BizInfo[id][bizOwnerID])							return SendErrorMessage(playerid, "Doanh nghiep nay thuoc nha nuoc.");
		if (!BizInfo[id][bizLocked] || BizInfo[id][bizDDoor])	return SendErrorMessage(playerid, "Cua da duoc mo.");

		switch(slot)
		{
		    case 1:
		    {
				cmd::server_ame(playerid, "pha khoa cua bang mot cai gap.");
				ApplyAnimation(playerid,"OTB","betslp_lkabt", 4.0, 1, 0, 0, 0, 0);
				pTemp[playerid][pRamType] = slot;
				pTemp[playerid][pRamTime] = 30;
				pTemp[playerid][pRamHouse] = -1;
				pTemp[playerid][pRamBiz] = id;
				pTemp[playerid][pRamGarage] = -1;
				pTemp[playerid][pRamVeh] = -1;
			}
			case 2:
			{
			    cmd::server_ame(playerid, "pha canh cua.");
				ApplyAnimation(playerid,"FIGHT_E","FightKick_B",4.1,0,1,1,1,1);
				BizInfo[id][bizLocked] = 0;
				BizInfo[id][bizDDoor] = 1;
				Save_Business(id);
				UpdateBusinessDoor(id);
				GameTextForPlayer(playerid, "~w~BAN DA ~y~PHA~w~ CUA", 1000, 1);
				InfoMSG(playerid, "NHAN ~y~\"F\"~w~ HOAC NHAP ~y~/ENTER", 2);

				new query[128];
				format(query, sizeof(query), "%s [MYSQL: %i | IP: %s] pha canh cua (/ram) doanh nghiep [B_MYSQL: %i]", GetName(playerid), PlayerInfo[playerid][pID], q_GetPlayerIP(playerid), BizInfo[id][bizID]);
			    insert_log(query, RAM_LOG, 6, PlayerInfo[playerid][pAccID], 0);
			}
			case 3:
			{
			    cmd::server_ame(playerid, "cai dat C4 tren canh cua.");
				OnPlayAnim(playerid, "BOMBER","BOM_Plant",4.0,0,0,0,0,0);
                pTemp[playerid][pRamObj] = CreateDynamicObject(1654, BizInfo[id][bizPosX], BizInfo[id][bizPosY], BizInfo[id][bizPosZ]-0.8, 0.0, 0.0, 90.0, BizInfo[id][bizPosVW], BizInfo[id][bizPosInt]);
				pTemp[playerid][pRamType] = slot;
				pTemp[playerid][pRamTime] = 10;
				pTemp[playerid][pRamHouse] = -1;
				pTemp[playerid][pRamBiz] = id;
				pTemp[playerid][pRamGarage] = -1;
				pTemp[playerid][pRamVeh] = -1;
			}
		}
		return 1;
	}

	else if ((id = GetNearOutsideGarage(playerid)) != -1)
	{
        if (!GarageInfo[id][garageOwner])									return SendErrorMessage(playerid, "Nha de xe nay thuoc nha nuoc.");
		if (!GarageInfo[id][garageLocked] || GarageInfo[id][garageDDoor])	return SendErrorMessage(playerid, "Cua da duoc mo.");

		switch(slot)
		{
		    case 1:
		    {
				cmd::server_ame(playerid, "pha khoa cua bang mot cai gap.");
				ApplyAnimation(playerid,"OTB","betslp_lkabt", 4.0, 1, 0, 0, 0, 0);
				pTemp[playerid][pRamType] = slot;
				pTemp[playerid][pRamTime] = 30;
				pTemp[playerid][pRamHouse] = -1;
				pTemp[playerid][pRamBiz] = -1;
				pTemp[playerid][pRamGarage] = id;
				pTemp[playerid][pRamVeh] = -1;
			}
			case 2:
			{
			    cmd::server_ame(playerid, "pha canh cua.");
				ApplyAnimation(playerid,"FIGHT_E","FightKick_B",4.1,0,1,1,1,1);
				GarageInfo[id][garageLocked] = 0;
				GarageInfo[id][garageDDoor] = 1;
				Save_Garage(id);
				UpdateGarageDoor(id);
				GameTextForPlayer(playerid, "~w~BAN DA ~y~PHA~w~ CUA", 1000, 1);
				InfoMSG(playerid, "NHAN ~y~\"F\"~w~ HOAC NHAP ~y~/ENTER", 2);

				new query[128];
				format(query, sizeof(query), "%s [MYSQL: %i | IP: %s] pha canh cua (/ram) garage [B_MYSQL: %i]", GetName(playerid), PlayerInfo[playerid][pID], q_GetPlayerIP(playerid), GarageInfo[id][garageID]);
			    insert_log(query, RAM_LOG, 6, PlayerInfo[playerid][pAccID], 0);
			}
			case 3:
			{
			    cmd::server_ame(playerid, "cai dat C4 tren canh cua.");
				OnPlayAnim(playerid, "BOMBER","BOM_Plant",4.0,0,0,0,0,0);
                pTemp[playerid][pRamObj] = CreateDynamicObject(1654, GarageInfo[id][garagePlayer_Enter][0], GarageInfo[id][garagePlayer_Enter][1], GarageInfo[id][garagePlayer_Enter][2]-0.8, 0.0, 0.0, 90.0, GarageInfo[id][garageEnterVW], GarageInfo[id][garageEnterInt]);
				pTemp[playerid][pRamType] = slot;
				pTemp[playerid][pRamTime] = 10;
				pTemp[playerid][pRamHouse] = -1;
				pTemp[playerid][pRamBiz] = id;
				pTemp[playerid][pRamGarage] = id;
				pTemp[playerid][pRamVeh] = -1;
			}
		}		
		return 1;
	}
	else if (slot == 2) cmd::doorram(playerid, "");
	
	return 1;
}

CMD:frisktrunk(playerid, params[])
{
	if (!IsPlayerFactionPolice(playerid))	return 1;
	if (!PlayerInfo[playerid][pOnDuty]) return SendErrorMessage(playerid, "Ban can phai trong gio lam viec (/duty).");

	new vehicle = GetNearVehicle(playerid, 4.0);
	if (vehicle == 0)																															return SendErrorMessage(playerid, "Khong co phuong tien nao gan ban.");
	if (IsADontTrunk(vehicle) || IsAPlane(vehicle) || IsABiker(vehicle) || IsAHelicopter(vehicle) || IsABoat(vehicle) || IsABicycle(vehicle))	return SendErrorMessage(playerid, "Phuong tien nay khong co thung xe. ");
    if (!IsPlayerInAnyVehicle(playerid) && VehicleInfo[vehicle][carTrunkLock] == 0)																return SendErrorMessage(playerid, "Thung xe phuong tien nay da dong.");
	if (VehicleInfo[vehicle][carFaction] && VehicleInfo[vehicle][carFaction] != PlayerInfo[playerid][pFaction]) 								return SendErrorMessage(playerid, "Ban khong the tim kiem phuong tien nay.");
	
	if (!IsNearTrunk(vehicle, playerid, 2.0)) 	return SendErrorMessage(playerid, "Ban khong o gan cop xe! ");

	PrintVehInv(playerid, vehicle, 1);
	return 1;
}

CMD:friskgb(playerid, params[])
{
	if (!IsPlayerFactionPolice(playerid)) return 1;
	if (!PlayerInfo[playerid][pOnDuty])	 return SendErrorMessage(playerid, "Ban can phai trong gio lam viec (/duty).");
	
	new vehicle = GetPlayerVehicleID(playerid);
	if (!vehicle && !IsPlayerInAnyVehicle(playerid))																									 return SendErrorMessage(playerid,"Ban can phai o trong xe.");
	if (VehicleInfo[vehicle][carFaction] && VehicleInfo[vehicle][carFaction] != PlayerInfo[playerid][pFaction] && VehicleInfo[vehicle][carOwnerID] != 0) return SendErrorMessage(playerid, "Ban khong the tim kiem phuong tien nay.");

	PrintGBInv(playerid, vehicle, 1);
	return 1;
}

CMD:friskprop(playerid, params[])
{
	if (!IsPlayerFactionPolice(playerid)) return 1;
	if (!PlayerInfo[playerid][pOnDuty])	 return SendErrorMessage(playerid, "Ban can phai trong gio lam viec (/duty).");

	new houseid;

	if ((houseid = GetNearHouse(playerid)) == -1)					return SendErrorMessage(playerid, "Ban khong o gan nha.");
	if (HouseInfo[houseid][hOwnerID] == PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Ngoi nha nay thuoc so huu cua ban.");
	if (!IsPlayerInsideHouse(playerid, houseid))					return SendErrorMessage(playerid, "Ban can phai trong ngoi nha.");

	PrintHouseInv(playerid, houseid, 1);
	return 1;
}

CMD:frisk(playerid, params[])
{
	if (PlayerInfo[playerid][pInjured] != 0 || GetPVarInt(playerid, "Freeze") || pTemp[playerid][pTaserTime] || pTemp[playerid][pCuffed] || PhoneInfo[playerid][current_page] == PAGE_NOTIFICATION || PlayerInfo[playerid][pJailed] != 0)
		return SendErrorMessage(playerid, "Ban khong the su dung tinh nang nay ngay bay gio.");

	new userid;

	if (sscanf(params,"u", userid))										 return SendHelpMessage(playerid, "/frisk [ID/Ten]");
	if (!IsPlayerLogged(userid))										 return SendNotConnected(playerid);
	if (userid == playerid)												 return 1;
	if (!PlayerNearPlayer(3.0, playerid, userid))						 return SendNotNearPlayer(playerid);
	if (pTemp[userid][pFriskPlayer] == playerid)						 return SendErrorMessage(playerid, "Ban da de nghi luc soat nguoi choi.");
	if (IsPlayerFactionPolice(playerid) && PlayerInfo[playerid][pOnDuty]) return PrintInvEx(playerid, userid);

    SendWarningMessage(playerid,"Cho cho den khi nguoi choi do chap nhan hoac tu choi loi de nghi.");
	SendSyntaxMessage(userid, "%s muon luc soat nguoi ban.",GetNameEx(playerid));
	SendHelpMessage(userid, "Nhap {ffc46a}/friskapprove{FFFFFF} de chap nhan hoac {ffc46a}/cancelfrisk{FFFFFF} de tu choi.");
	
	pTemp[userid][pFriskPlayer] = playerid;
    SetPVarInt(userid, #accept_time, gettime() + 30);
	return 1;
}

CMD:friskapprove(playerid, params[])
{
	if (pTemp[playerid][pFriskPlayer] == INVALID_PLAYER_ID)	return SendErrorMessage(playerid, "Khong ai de nghi ban tien hanh luc soat.");

	new userid = pTemp[playerid][pFriskPlayer];

	pTemp[playerid][pFriskPlayer] = INVALID_PLAYER_ID;

	if (!PlayerNearPlayer(3.0, playerid, userid))	return SendNotNearPlayer(playerid);

	SendSyntaxMessage(playerid, "Ban da de %s tien hanh luc soat.",GetNameEx(userid));

	PrintInvEx(playerid, userid);
	return 1;
}

CMD:cancelfrisk(playerid, params[])
{
	if (pTemp[playerid][pFriskPlayer] == INVALID_PLAYER_ID)	return SendErrorMessage(playerid, "Khong ai de nghi ban tien hanh luc soat.");

	new userid = pTemp[playerid][pFriskPlayer];
	
	pTemp[playerid][pFriskPlayer] = INVALID_PLAYER_ID;
	SendSyntaxMessage(playerid, "Ban da tu choi loi de nghi luc soat cua %s.",GetNameWithMask(userid));
	SendSyntaxMessage(userid, "%s da tu choi loi de nghi luc soat cua ban.",GetNameWithMask(playerid));
	return 1;
}

CMD:setplate(playerid, params[])
{
	if (!IsPlayerFactionPolice(playerid))	return SendErrorMessage(playerid, "Ban phai la mot nhan vien canh sat.");

    new vehicleid = GetPlayerVehicleID(playerid);

    if (!vehicleid || VehicleInfo[vehicleid][carFaction] != PlayerInfo[playerid][pFaction])	
		return SendErrorMessage(playerid, "Ban khong o trong phuong tien cua to chuc.");

    new plate[24];

    format(plate, sizeof(plate), "%s", GetVehicleNumber());

	new query[128];
	mysql_format(dbHandle, query, sizeof(query), "SELECT `plate` FROM `cars` WHERE `plate` = '%e'", plate);
	mysql_tquery(dbHandle, query, "PoliceSetPlate", "iis", playerid, vehicleid, plate);
	return 1;
}

CMD:zond(playerid, params[])
{
	if (pTemp[playerid][pZond] != 0)		return SetPlayerZond(playerid, 0);
    if (!IsPlayerFactionPolice(playerid))	return SendErrorMessage(playerid,"Ban phai la nhan vien canh sat / nhan vien nha tu.");
    if (!PlayerInfo[playerid][pSwatDuty])	return SendErrorMessage(playerid, "Chuc nang nay co san cho S.W.A.T.");

	SetPlayerZond(playerid, 1);
	return 1;
}

CMD:flashbang(playerid, params[])
{
    if (!IsPlayerFactionPolice(playerid))	return SendErrorMessage(playerid, "Ban phai la nhan vien canh sat / nhan vien nha tu.");
    if (!PlayerInfo[playerid][pSwatDuty])	return SendErrorMessage(playerid, "Chuc nang nay co san cho S.W.A.T.");

    new id = -1;

	if ((id = GetNearOutsideBiz(playerid)) != -1 && (BizInfo[id][bizType] != BIZ_AUTOSALON && BizInfo[id][bizType] != BIZ_ADVERT && BizInfo[id][bizType] != BIZ_TUNING && BizInfo[id][bizType] != BIZ_LICENSE && BizInfo[id][bizType] != BIZ_BOATSALON && BizInfo[id][bizType] != BIZ_FLYSALON))
	{
	    if (BizInfo[id][bizLocked])	return GameTextForPlayer(playerid, "~r~DONG!", 2500, 1);

		SendFactionMessage(FACTION_POLICE, COLOR_POLICECHAT, "* %s %s da su dung luu dan gay choang.", GetRankName(playerid), GetNameEx(playerid));
		cmd::me(playerid, "coi bo khoi that lung cua minh, nem mot qua luu dan gay choang. ");
		
		foreach(new i : Player)
		{
		    if (!IsPlayerLogged(i) || !IsPlayerBizInside(i, id)) continue;
		    
			SendSyntaxMessage(i, "Ban da bi choang boi luu dan.");
			GameTextForPlayer(i, "~r~!!! BAN DA BI CHOANG !!!~n~~n~~n~!!! BAN DA BI CHOANG !!!~n~~n~~n~!!! BAN DA BI CHOANG !!!", 12000, 3);
            SetPlayerWeather(i, 36);
			SetPlayerTime(i, 22, 0);
			StopPlayerAnims(i);
			FreezePlayer(i);
			SetPlayerDrunkLevel(i, 50000);
			pTemp[i][pFlashTime] = 15;
		}
		return 1;
	}
	if ((id = GetNearOutsideHouse(playerid)) != -1)
	{
	    if (HouseInfo[id][hLocked])	return GameTextForPlayer(playerid, "~r~DONG!", 2500, 1);

        SendFactionMessage(FACTION_POLICE, COLOR_POLICECHAT, "* %s %s da su dung luu dan gay choang.", GetRankName(playerid), GetNameEx(playerid));
		cmd::me(playerid, "coi bo khoi that lung cua minh, nem mot qua luu dan gay choang. ");
		foreach(new i : Player)
		{
		    if (!IsPlayerLogged(i) || !IsPlayerInsideHouse(i, id)) continue;
		    
			SendSyntaxMessage(i, "Ban da bi choang boi luu dan.");
			GameTextForPlayer(i, "~r~!!! BAN DA BI CHOANG !!!~n~~n~~n~!!! BAN DA BI CHOANG !!!~n~~n~~n~!!! BAN DA BI CHOANG !!!", 12000, 3);
            SetPlayerWeather(i, 36);
			SetPlayerTime(i, 22, 0);
			StopPlayerAnims(i);
			FreezePlayer(i);
			SetPlayerDrunkLevel(i, 50000);
			pTemp[i][pFlashTime] = 15;
		}
		return 1;
	}

	SendErrorMessage(playerid, "Su dung loi vao nha / doanh nghiep");
	return 1;
}

CMD:callsign(playerid, params[])
{
    new faction = PlayerInfo[playerid][pFaction];
	
	if (!IsFactionPolice(faction))	return SendErrorMessage(playerid, "Ban phai la mot nhan vien canh sat.");

	if (pTemp[playerid][pPatrol])
	{
	    new id = pTemp[playerid][pPatrol]-1;

	    pTemp[playerid][pPatrol] = 0;

	    if (id < 0 || id >= MAX_PATROL || !PatrolInfo[GetPatrolID(playerid)][id][patrulExists])	return 1;

        if (PatrolInfo[GetPatrolID(playerid)][id][patrulOfficer][0] == playerid) 																							PatrolInfo[GetPatrolID(playerid)][id][patrulOfficer][0] = INVALID_PLAYER_ID;
        if (PatrolInfo[GetPatrolID(playerid)][id][patrulOfficer][1] == playerid) 																							PatrolInfo[GetPatrolID(playerid)][id][patrulOfficer][1] = INVALID_PLAYER_ID;
		if (PatrolInfo[GetPatrolID(playerid)][id][patrulOfficer][0] == INVALID_PLAYER_ID && PatrolInfo[GetPatrolID(playerid)][id][patrulOfficer][0] == INVALID_PLAYER_ID)	PatrolInfo[GetPatrolID(playerid)][id][patrulExists] = 0;

	    SendFactionMessage(FACTION_POLICE, COLOR_POLICECHAT, "[DISP] %s %s tu bo cuoc tuan tra %s", GetRankName(playerid), GetNameEx(playerid), PatrolInfo[GetPatrolID(playerid)][id][patrulName]);
		return 1;
	}

    if (!PlayerInfo[playerid][pOnDuty])	return SendErrorMessage(playerid, "Ban can phai trong gio lam viec (/duty).");
	if (isnull(params))					return SendHelpMessage(playerid, "/callsign [marking]");

	for(new i; i != MAX_PATROL; i++)
	{
	    if (!PatrolInfo[GetPatrolID(playerid)][i][patrulExists] || !CompareStrings(params, PatrolInfo[GetPatrolID(playerid)][i][patrulName]))	 continue;

		if (PatrolInfo[GetPatrolID(playerid)][i][patrulOfficer][0] != INVALID_PLAYER_ID && PatrolInfo[GetPatrolID(playerid)][i][patrulOfficer][1] != INVALID_PLAYER_ID)	
			return SendErrorMessage(playerid, "Tuan tra nay da hoan thanh.");

        if (PatrolInfo[GetPatrolID(playerid)][i][patrulOfficer][0] == INVALID_PLAYER_ID) PatrolInfo[GetPatrolID(playerid)][i][patrulOfficer][0] = playerid;
        else 																			PatrolInfo[GetPatrolID(playerid)][i][patrulOfficer][1] = playerid;

		pTemp[playerid][pPatrol] = i+1;
		SendFactionMessage(FACTION_POLICE, COLOR_POLICECHAT, "[DISP] %s %s da tham gia cuoc tuan tra %s", GetRankName(playerid), GetNameEx(playerid), PatrolInfo[GetPatrolID(playerid)][i][patrulName]);
		return 1;
	}

	new id = -1;
	for(new i; i != MAX_PATROL; i++)
	{
	    if (PatrolInfo[GetPatrolID(playerid)][i][patrulExists]) continue;

		id = i;
		break;
	}

	if (id == -1)	return SendErrorMessage(playerid, "So lan tuan tra da dat duoc.");

    pTemp[playerid][pPatrol] = id+1;
    PatrolInfo[GetPatrolID(playerid)][id][patrulExists] = 1;
    format(PatrolInfo[GetPatrolID(playerid)][id][patrulName], 32, "%s", params);
    PatrolInfo[GetPatrolID(playerid)][id][patrulOfficer][0] = playerid;
    PatrolInfo[GetPatrolID(playerid)][id][patrulOfficer][1] = INVALID_PLAYER_ID;
    SendFactionMessage(FACTION_POLICE, COLOR_POLICECHAT, "[DISP] %s %s da di tuan tra duoi %s", GetRankName(playerid), GetNameEx(playerid), PatrolInfo[GetPatrolID(playerid)][id][patrulName]);
	return 1;
}

CMD:meg(playerid, params[])
{
    new vehicle = GetPlayerVehicleID(playerid);

	if (!IsPlayerFactionPolice(playerid))									return SendErrorMessage(playerid, "Ban phai la mot nhan vien canh sat.");
	if (VehicleInfo[vehicle][carFaction] != PlayerInfo[playerid][pFaction])	return SendErrorMessage(playerid, "Chi co o phuong tien LSPD/SASD.");


	new type;
	if (sscanf(params,"i",type))
	{
	    new _mes[447] = "1. Day la Los Santos Police Department; Dung yen tai vi tri!\n2. Day la Buzzard 1, chung toi dang tiep dat!\n3. Bon chiec xe dap 4 canh mau xanh duong nguoc vao South Central.\n";
	   
		strcat(_mes, "4. Mayday, mayday! Buzzard 1 sap gap su co!\n5. Day la LSPD khong, HEY! CAI GI? QUA THAP, BAN SE GIET TAT CA CHUNG TOI!\n6. LSPD, dung lai ngay ... Ban co mat tri khong? Ban se giet tat ca chung toi!\n7. Day la So Canh sat Los Santos; Tat ca dung yen!");
	    Dialog_Show(playerid, MPCarVoice, DIALOG_STYLE_LIST, "{8D8DFF}Megaphone", _mes, "Chon", "Huy bo");
	    return SendHelpMessage(playerid, "/meg [Sound ID (1-7)]");
	}
	MegaphoneSoundVoice(playerid, type);
	return 1;
}

CMD:revoke(playerid, params[])
{
	new userid, type[24], faction = PlayerInfo[playerid][pFaction];

	if (!IsFactionPolice(faction))					return SendErrorMessage(playerid, "Ban phai la mot nhan vien canh sat.");
    if (!PlayerInfo[playerid][pOnDuty])				return SendErrorMessage(playerid, "Ban can phai trong gio lam viec (/duty).");
	if (sscanf(params,"us[24]", userid, type))		return SendHelpMessage(playerid, "/revoke [ID/Ten] [carlic | flylic | weapons]");
	if (userid == playerid)							return 1;
	if (!IsPlayerLogged(userid))						return SendNotConnected(playerid);
	if (!PlayerNearPlayer(4.0, playerid, userid))	return SendNotNearPlayer(playerid);

	if (CompareStrings(type, "carlic"))
	{
	    if (!PlayerInfo[userid][pCarLic])	return SendErrorMessage(playerid, "Nguoi choi khong co giay phep lai xe.");

		new mes[128];
		format(mes, sizeof(mes), "tuoc giay phep lai xe cua %s.", GetNameWithMask(userid));
		cmd::me(playerid, mes);

		SendSyntaxMessage(userid, "Giay phep lai xe cua ban da bi tuoc mat boi %s.", GetNameWithMask(playerid));
		PlayerInfo[userid][pCarLic] = 0;
		SQL_SetInteger("users", "carlic", 0, PlayerInfo[userid][pID]);
		return 1;
	}

	else if (CompareStrings(type, "flylic"))
	{
	    if (!PlayerInfo[userid][pFlyLic])	return SendErrorMessage(playerid, "Nguoi choi khong co giay phep lai may bay.");

	    new mes[128];
		format(mes, sizeof(mes), "tuoc giay phep lai may bay cua %s.", GetNameWithMask(userid));
		cmd::me(playerid, mes);

		SendSyntaxMessage(userid, "Giay phep lai may bay cua ban da bi tuoc boi %s.", GetNameWithMask(playerid));
		PlayerInfo[userid][pFlyLic] = 0;
		SQL_SetInteger("users", "flylic", 0, PlayerInfo[userid][pID]);
		return 1;
	}

	else if (CompareStrings(type, "weapons"))
	{
		new count = -1;
		for(new i = 0; i < MAX_INV_SLOTS; i++)
		{
			if (inventory_items[Inventory[playerid][i][pInvItem]][itemType] == ITEM_TYPE_WEAPON)
			{
				count = i;
				break;
			}
		}
		if (count == -1 && !PlayerInfo[playerid][pPlayerWeapon])	return SendErrorMessage(playerid, "Nguoi choi khong co vu khi");

	    new mes[128];
		format(mes, sizeof(mes), "tuoc vu khi cua %s.", GetNameWithMask(userid));
		cmd::me(playerid, mes);

		SendWarningMessage(userid, "Tat ca vu khi cua ban da bi tuoc mat boi %s.", GetNameWithMask(playerid));
		ResetPlayerWeaponsEx(userid, 0);
		return 1;
	}
	else 
	{
		SendHelpMessage(playerid, "/revoke [ID/Ten] [carlic | flylic | weapons]");
	}
	return 1;
}

CMD:detain(playerid, params[])
{
	new userid, faction = PlayerInfo[playerid][pFaction];

	if (!IsFactionPolice(faction) && !IsFactionDocs(faction))																	return SendErrorMessage(playerid, "Ban phai la nhan vien canh sat / nhan vien nha tu.");
	if (sscanf(params,"u", userid))																								return SendHelpMessage(playerid, "/detain [ID/Ten]");
	if (userid == playerid)																										return 1;
	if (!PlayerInfo[playerid][pOnDuty])																							return SendErrorMessage(playerid, "Ban can phai trong gio lam viec (/duty).");
	if (!IsPlayerInAnyVehicle(playerid))																						return SendNotInVehicle(playerid);
	if (!IsPlayerLogged(userid))																								return SendNotConnected(playerid);
	if (!PlayerNearPlayer(10.0, playerid, userid))																				return SendNotNearPlayer(playerid);
	if (!IsPlayerInAnyVehicle(userid) || VehicleInfo[GetPlayerVehicleID(userid)][carFaction] != PlayerInfo[playerid][pFaction])	return SendErrorMessage(playerid, "Nguoi choi khong o trong mot chiec xe dac biet.");

	new mes[128];

	if (!IsPlayerFreeze(userid))
	{
		format(mes, sizeof(mes), "khoa tat ca cac cua %s.", GetNameWithMask(userid));
		FreezePlayer(userid);
	}
	else
	{
		format(mes, sizeof(mes), "%s mo khoa tat ca cac cua.", GetNameWithMask(userid));
		UnFreezePlayer(userid);
	}
	cmd::me(playerid, mes);
	return 1;
}

CMD:arrest(playerid, params[])
{
	new userid, time, info[128], faction = PlayerInfo[playerid][pFaction];

	if (!IsFactionPolice(faction))						return SendErrorMessage(playerid, "Ban phai la mot nhan vien canh sat.");
	if (sscanf(params,"uds[128]", userid, time, info))	return SendHelpMessage(playerid, "/arrest [ID/Ten] [time (minutes)] [ly do]");
	if (!PlayerInfo[playerid][pOnDuty])					return SendErrorMessage(playerid, "Ban can phai trong gio lam viec.");

	new arrestid = 0;

	if ((arrestid = GetArrestID(playerid)) == 0)	return SendErrorMessage(playerid, "Ban phai o truoc may quay!");
	if (!IsPlayerLogged(userid))					return SendNotConnected(playerid);
	if (!PlayerNearPlayer(3.0, playerid, userid))	return SendNotNearPlayer(playerid);
    if (userid == playerid)							return SendErrorMessage(playerid, "Ban khong the su dung hanh dong nay cho chinh minh.");
    if (PlayerInfo[userid][pJailed])				return SendErrorMessage(playerid, "Nguoi choi da bi bat.");
	if (time < 1 || time > 60)						return SendErrorMessage(playerid, "Thoi gian bat giu chi tu 1 den 60 phut.");

    Add_Arrest(playerid, userid, time);
	PlayerInfo[userid][pJailed] = arrestid;
	PlayerInfo[userid][pJailTime] = time * 60;
	PlayerInfo[userid][pArrested]++;
	SQL_SetInteger("users", "arrested", PlayerInfo[userid][pArrested], PlayerInfo[userid][pID]);
	AddCriminalRecord(userid, info, PlayerInfo[playerid][pUsername], PlayerInfo[playerid][pFaction], 1);

	PutPlayerInPrison(userid);
	SendErrorMessage(userid, "Ban da bi bat giu. Thoi gian: %s phut.", FormatNumber(time));
	pTemp[playerid][pPoliceJails]++;
	return 1;
}

CMD:prison(playerid, params[])
{
	return SendErrorMessage(playerid, "Nha tu van bi bao tri!");
	/*new userid, time, info[128], faction = PlayerInfo[playerid][pFaction];

	if (!IsFactionPolice(faction) || !IsFactionDocs(faction))		return SendErrorMessage(playerid, "Ban phai la nhan vien canh sat / nhan vien nha tu.");
	if (sscanf(params,"uds[128]", userid, time, info))				return SendHelpMessage(playerid, "/prison [ID/Ten] [�����(������)] [ly do]");
	if (!PlayerInfo[playerid][pOnDuty])								return SendErrorMessage(playerid, "�� ������ ��������� �� ���������.");
	if (!PlayerToPoint(5.0, playerid, 241.6535,-315.2582,947.9460))	return SendErrorMessage(playerid, "�� �� � ������.");
	if (!IsPlayerLogged(userid))									return SendNotConnected(playerid);
	if (!PlayerNearPlayer(3.0, playerid, userid))					return SendNotNearPlayer(playerid);
	if (time < 1 || time > 1000)									return SendErrorMessage(playerid, "����� �� 1 �� 1000 �����.");
	if (userid == playerid)											return 1;

	PlayerInfo[userid][pPrisoned] = random(sizeof(prison_sadoc));
	PlayerInfo[userid][pJailed] = PRISON_JAIL;
	PlayerInfo[userid][pJailTime] = time * 60;
	PlayerInfo[userid][pIsolateTime] = 0;
	SendSyntaxMessage(userid, "�� ���� �������� � ������. �����: %s �����.", FormatNumber(time));
	SendSyntaxMessage(userid, "��� ����� ������������ - A%i(/myprisonnumber).", PlayerInfo[userid][pPrisoned]+100);
	return 1;*/
}

CMD:checkplate(playerid, params[])
{
	new faction = PlayerInfo[playerid][pFaction];
	if (!IsFactionPolice(faction))						return SendErrorMessage(playerid, "Ban phai la mot nhan vien canh sat.");
	if (!PlayerInfo[playerid][pOnDuty])					return SendErrorMessage(playerid, "Ban can phai trong gio lam viec (/duty).");
	if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)	return SendErrorMessage(playerid, "Ban phai o gan phuong tien.");

	new vehicle;

	if ((vehicle = GetNearVehicle(playerid, 2.5)) == 0)	return SendErrorMessage(playerid, "Khong co phuong tien nao gan ban.");

	if (VehicleInfo[vehicle][carRegistered] == 0)	SendSyntaxMessage(playerid, "Bien so xe cua phuong tien %s chua duoc dang ky.", VehicleNames[GetVehicleModel(vehicle)-400]);
	else											SendSyntaxMessage(playerid, "Bien so xe cua phuong tien %s la %s.", VehicleNames[GetVehicleModel(vehicle)-400], VehicleInfo[vehicle][carPlate]);
	
	return 1;
}

CMD:cuff(playerid, params[])
{
	new userid, faction = PlayerInfo[playerid][pFaction];

	if (!IsFactionPolice(faction))					return SendErrorMessage(playerid, "Ban phai la nhan vien canh sat / nhan vien nha tu.");
	if (sscanf(params,"u",userid))					return SendHelpMessage(playerid, "/cuff [ID/Ten]");
	if (!PlayerInfo[playerid][pOnDuty])				return SendErrorMessage(playerid, "Ban can phai trong gio lam viec (/duty).");
	if (!IsPlayerLogged(userid))						return SendNotConnected(playerid);
	if (!PlayerNearPlayer(3.0, playerid, userid))	return SendNotNearPlayer(playerid);
	if (userid == playerid)							return 1;
	if (pTemp[userid][pCuffed])						return SendErrorMessage(playerid, "Nguoi choi da bi cong tay.");
	//if (pTemp[userid][pTaserTime])					return SendErrorMessage(playerid, "The player is stunned or unconscious. ");

	GameTextForPlayer(userid, "~r~Cong tay", 2500, 3);
	pTemp[userid][pCuffed] = 1;
	SendSyntaxMessage(userid, "%s da cong tay cua ban.", GetNameWithMask(playerid));
	SendSyntaxMessage(playerid, "Ban da cong tay cua %s.", GetNameWithMask(userid));
	SetPlayerAttachedObject(userid, ATTACH_HANDS, 19418,6,0.003999,0.028000,-0.018000,-12.900005,0.000000,-65.100006,0.878000,1.890999,1.652001);
	SetPlayerSpecialAction(userid, SPECIAL_ACTION_CUFFED);
	return 1;
}

CMD:uncuff(playerid, params[])
{
	new userid, faction = PlayerInfo[playerid][pFaction];

	if (!IsFactionPolice(faction))					return SendErrorMessage(playerid, "Ban phai la nhan vien canh sat / nhan vien nha tu.");
	if (sscanf(params,"u", userid))					return SendHelpMessage(playerid, "/uncuff [ID/Ten]");
	if (!PlayerInfo[playerid][pOnDuty])				return SendErrorMessage(playerid, "Ban can phai trong gio lam viec (/duty).");
	if (!IsPlayerLogged(userid))					return SendNotConnected(playerid);
	if (!PlayerNearPlayer(3.0, playerid, userid))	return SendNotNearPlayer(playerid);
	if (userid == playerid)							return 1;
	if (!pTemp[userid][pCuffed])					return SendErrorMessage(playerid,"Nguoi choi khong bi cong tay.");

	pTemp[userid][pCuffed] = 0;
	SendSyntaxMessage(userid, "%s da go cong tay cho ban.", GetNameWithMask(playerid));
	SendSyntaxMessage(playerid, "Ban da go cong tay cho %s.", GetNameWithMask(userid));
	RemovePlayerAttachedObject(userid, ATTACH_HANDS);
	SetPlayerSpecialAction(userid, SPECIAL_ACTION_NONE);
	return 1;
}

ALTX:chase("/clist", "/sitleader");
CMD:chase(playerid, params[])
{
	new faction = PlayerInfo[playerid][pFaction];
	if (!IsFactionPolice(faction))		return SendErrorMessage(playerid, "Ban phai la mot nhan vien canh sat.");
	if (!PlayerInfo[playerid][pOnDuty])	return SendErrorMessage(playerid, "Ban can phai trong gio lam viec (/duty).");
	
	new userid;
	if (sscanf(params,"u", userid))					return SendHelpMessage(playerid, "/chase [ID/Ten]");
	if (!IsPlayerLogged(userid))						return SendNotConnected(playerid);
	if (userid == playerid)							return 1;
	if (GetPVarInt(playerid, #Chase_Time) > 1)		return SendErrorMessage(playerid, "Doi voi %s [ID:%i] viec theo duoi da duoc tien hanh.", GetNameWithMask(userid), userid);
	if (!PlayerNearPlayer(15.0, playerid, userid))	return SendNotNearPlayer(playerid);

	SendFactionMessage(FACTION_POLICE, COLOR_POLICECHAT, "(( HQ: %s %s da bat dau theo duoi %s [ID:%i]. ))", GetRankName(playerid), GetNameEx(playerid), GetNameWithMask(userid), userid);

	StartChase(userid);	
	return 1;
}

CMD:siren(playerid, params[])
{
    new faction = PlayerInfo[playerid][pFaction], vehicle = GetPlayerVehicleID(playerid), model = GetVehicleModel(vehicle), siren_id;

	if (!IsFactionLegal(faction))											return SendErrorMessage(playerid, "Ban phai la nhan vien canh sat / nhan vien nha tu / paramedic / government.");
    if (VehicleInfo[vehicle][carFaction] != PlayerInfo[playerid][pFaction])	return SendErrorMessage(playerid, "Ban phai o trong phuong tien to chuc.");
	if (sscanf(params, "i", siren_id))										return SendHelpMessage(playerid, "/siren [1-3]");
	if (siren_id < 1 || siren_id > 3)										return SendErrorMessage(playerid, "ID khong hop le: 1-3.");

	if (siren_id == 1)
	{
		if (IsValidDynamicObject(VehicleInfo[vehicle][carSiren][0]))
		{
		    SendSyntaxMessage(playerid, "Coi bao dong da tat [SIREN OFF]");
			DestroyDynamicObject(VehicleInfo[vehicle][carSiren][0]);
			VehicleInfo[vehicle][carSiren][0] = INVALID_OBJECT_ID;
		    return 1;
		}

		if (model != 560 && model != 541 && model != 525 && model != 426 && model != 579 && model != 415 && model != 554 && model != 546 && model != 566 && model != 561 && model != 547 && model != 482)
		{
			return SendErrorMessage(playerid, "Coi bao dong chi co the duoc dat tren Sultan/Bullet/Towtruck/Premier/Huntley/Cheetah/Yosemite/Intruder/Tahoma/Stratum/Primo/Burrito.");
		}

	    VehicleInfo[vehicle][carSiren][0] = CreateDynamicObject((model != 525)?(18646):(19419), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -1, -1, -1, 300.0);
		switch(model)
	    {
	        case 560: AttachDynamicObjectToVehicle(VehicleInfo[vehicle][carSiren][0], vehicle, 0.571924, 0.068632, 0.860007, 0.000000, 0.000000, -181.148086);
	        case 541: AttachDynamicObjectToVehicle(VehicleInfo[vehicle][carSiren][0], vehicle, 0.442310, -0.091429, 0.670001, 0.000000, -2.299999, -178.874786);
	        case 426: AttachDynamicObjectToVehicle(VehicleInfo[vehicle][carSiren][0], vehicle, 0.570416, -0.012622, 0.890005, 0.000000, 0.000000, -91.267646);
	        case 525: AttachDynamicObjectToVehicle(VehicleInfo[vehicle][carSiren][0], vehicle, 0.0, -0.485, 1.36, 0.000000, 0.000000, 180.0);
	        case 579: AttachDynamicObjectToVehicle(VehicleInfo[vehicle][carSiren][0], vehicle, 0.640568, -0.021741, 1.260003, 0.000000, 0.000000, -90.153976);
	        case 415: AttachDynamicObjectToVehicle(VehicleInfo[vehicle][carSiren][0], vehicle, 0.424245, -0.241412, 0.640021, 3.000001, -3.499999, -181.499969);
	        case 554: AttachDynamicObjectToVehicle(VehicleInfo[vehicle][carSiren][0], vehicle, 0.734659, 0.117240, 1.059349, -4.199999, 0.000000, -87.859664);
	        case 546: AttachDynamicObjectToVehicle(VehicleInfo[vehicle][carSiren][0], vehicle, 0.591740, -0.153342, 0.870005, 0.000000, 0.000000, -269.351074);
	        case 566: AttachDynamicObjectToVehicle(VehicleInfo[vehicle][carSiren][0], vehicle, 0.660138, 0.024635, 0.869999, 0.000000, 0.000000, -88.731002);
	        case 561: AttachDynamicObjectToVehicle(VehicleInfo[vehicle][carSiren][0], vehicle, 0.428671, 0.080074, 0.850004, -2.799999, 0.000000, -88.665367);
	        case 547: AttachDynamicObjectToVehicle(VehicleInfo[vehicle][carSiren][0], vehicle, 0.530513, 0.002143, 0.916606, -3.899999, 0.000000, -89.768531);
	        case 482: AttachDynamicObjectToVehicle(VehicleInfo[vehicle][carSiren][0], vehicle, 0.515804, 0.702674, 0.950006, 0.000000, 0.000000, -92.038864);
	    }

	    Streamer_Update(playerid, STREAMER_TYPE_OBJECT);
	    return SendSyntaxMessage(playerid, "Coi bao dong da duoc cai dat [SIREN ON]");
	}

	else if (siren_id == 2)
	{
	    if (IsValidDynamicObject(VehicleInfo[vehicle][carSiren][1]))
		{
		    SendSyntaxMessage(playerid, "Coi bao dong da tat [SIREN OFF]");
			DestroyDynamicObject(VehicleInfo[vehicle][carSiren][1]);
			VehicleInfo[vehicle][carSiren][1] = INVALID_OBJECT_ID;
		    return 1;
		}

	    if (model != 560 && model != 426 && model != 579 && model != 566 && model != 561 && model != 547 && model != 546)
		{
			return SendErrorMessage(playerid, "Coi bao dong chi duoc dat tren Sultan/Premier/Huntley/Tahoma/Stratum/Primo/Intruder.");
		}

        VehicleInfo[vehicle][carSiren][1] = CreateDynamicObject(19419, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -1, -1, -1, 300.0);
        switch(model)
	    {
	        case 560: AttachDynamicObjectToVehicle(VehicleInfo[vehicle][carSiren][1], vehicle, 0.000000, -1.289999, 0.394999, 0.000000, 0.000000, 0.000000);
	        case 426: AttachDynamicObjectToVehicle(VehicleInfo[vehicle][carSiren][1], vehicle, 0.000000, -1.669998, 0.349999, 0.000000, 0.000000, 0.000000);
	        case 579: AttachDynamicObjectToVehicle(VehicleInfo[vehicle][carSiren][1], vehicle, 0.005192, -2.445963, 0.521951, 0.000000, 0.000000, -359.884796);
	        case 566: AttachDynamicObjectToVehicle(VehicleInfo[vehicle][carSiren][1], vehicle, 0.009878, -1.681756, 0.400007, 0.000000, 0.000000, -0.010757);
	        case 561: AttachDynamicObjectToVehicle(VehicleInfo[vehicle][carSiren][1], vehicle, -0.004864, -2.317730, 0.249995, 0.000000, 0.000000, -0.192703);
	        case 547: AttachDynamicObjectToVehicle(VehicleInfo[vehicle][carSiren][1], vehicle, -0.001344, -1.571307, 0.400003, 0.000000, 0.000000, -0.468620);
	        case 546: AttachDynamicObjectToVehicle(VehicleInfo[vehicle][carSiren][1], vehicle, 0.014445, -1.771190, 0.340004, 0.000000, 0.000000, -359.851013);
	    }
	    Streamer_Update(playerid, STREAMER_TYPE_OBJECT);
		return SendSyntaxMessage(playerid,"Coi bao dong da duoc cai dat [SIREN ON]");
	}

	else if (siren_id == 3)
	{
	    if (IsValidDynamicObject(VehicleInfo[vehicle][carSiren][2]))
		{
		    SendSyntaxMessage(playerid, "Coi bao dong da tat [SIREN OFF]");
			DestroyDynamicObject(VehicleInfo[vehicle][carSiren][2]);
			VehicleInfo[vehicle][carSiren][2] = INVALID_OBJECT_ID;
			DestroyDynamicObject(VehicleInfo[vehicle][carSiren][3]);
			VehicleInfo[vehicle][carSiren][3] = INVALID_OBJECT_ID;
			DestroyDynamicObject(VehicleInfo[vehicle][carSiren][4]);
			VehicleInfo[vehicle][carSiren][4] = INVALID_OBJECT_ID;
		    return 1;
		}

	    if (model != 541 && model != 415 && model != 560)	return SendErrorMessage(playerid, "Coi bao dong chi duoc dat tren Bullet/Cheetah/Sultan.");

        if (model == 541)
		{
			VehicleInfo[vehicle][carSiren][2] = CreateDynamicObject(19620, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -1, -1, -1, 300.0);
			AttachDynamicObjectToVehicle(VehicleInfo[vehicle][carSiren][2], vehicle, 0.000000, 0.000000, 0.659999, 0.000000, 0.000000, -359.823394);
			VehicleInfo[vehicle][carSiren][3] = CreateDynamicObject(19797, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -1, -1, -1, 300.0);
			AttachDynamicObjectToVehicle(VehicleInfo[vehicle][carSiren][3], vehicle, 0.006984, -2.280384, -0.190001, 0.000000, 0.000000, -359.824523);
			VehicleInfo[vehicle][carSiren][4] = CreateDynamicObject(19797, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -1, -1, -1, 300.0);
			AttachDynamicObjectToVehicle(VehicleInfo[vehicle][carSiren][4], vehicle, -0.007443, 2.430286, -0.070001, 0.000000, 0.000000, -180.024566);
		}
		if (model == 415)
		{
			VehicleInfo[vehicle][carSiren][2] = CreateDynamicObject(19620, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -1, -1, -1, 300.0);
			AttachDynamicObjectToVehicle(VehicleInfo[vehicle][carSiren][2], vehicle, 0.000475, -0.270263, 0.630008, 0.000000, 0.000000, -359.899139);
			VehicleInfo[vehicle][carSiren][3] = CreateDynamicObject(19797, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -1, -1, -1, 300.0);
			AttachDynamicObjectToVehicle(VehicleInfo[vehicle][carSiren][3], vehicle, -0.005538, 2.660761, -0.210004, 0.000000, 0.000000, -180.099121);
			VehicleInfo[vehicle][carSiren][4] = CreateDynamicObject(19797, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -1, -1, -1, 300.0);
			AttachDynamicObjectToVehicle(VehicleInfo[vehicle][carSiren][4], vehicle, 0.003255, -2.460503, -0.140003, 0.000000, 0.000000, 0.266403);
		}
		if (model == 560)
		{
			VehicleInfo[vehicle][carSiren][2] = CreateDynamicObject(19620, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -1, -1, -1, 300.0);
			AttachDynamicObjectToVehicle(VehicleInfo[vehicle][carSiren][2], vehicle, -0.000927, 0.110103, 0.870014, 0.000000, 0.000000, -359.517333);
			VehicleInfo[vehicle][carSiren][3] = CreateDynamicObject(19797, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -1, -1, -1, 300.0);
			AttachDynamicObjectToVehicle(VehicleInfo[vehicle][carSiren][3], vehicle, 0.004800, -2.370894, 0.105430, 0.000000, 0.000000, -359.912292);
			VehicleInfo[vehicle][carSiren][4] = CreateDynamicObject(19797, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -1, -1, -1, 300.0);
			AttachDynamicObjectToVehicle(VehicleInfo[vehicle][carSiren][4], vehicle, -0.003252, 2.561954, 0.050001, 0.000000, 0.000000, -179.912200);
		}

		Streamer_Update(playerid, STREAMER_TYPE_OBJECT);
		return SendSyntaxMessage(playerid,"Coi bao dong da duoc cai dat [SIREN ON]");
	}
	return 1;
}

CMD:licenseweapon(playerid, params[])
{
    new userid, price;
		
	if (sscanf(params,"ui",userid, price))			return SendHelpMessage(playerid, "/licenseweapon [ID/Ten] [gia]");
	if (!IsPlayerFactionPolice(playerid))			return SendErrorMessage(playerid, "Ban phai la nhan vien cua LSPD.");
	if (PlayerInfo[playerid][pAuthwep] != 1)		return SendErrorMessage(playerid, "Ban khong co tham quyen cap giay phep.");
	if (price < 1 || price > 10000)					return SendErrorMessage(playerid, "Gia chi tu $ 1 den $ 10,000.");
	if (!IsPlayerLogged(userid))					return SendNotConnected(playerid);
	if (!PlayerNearPlayer(3.0, playerid, userid))	return SendNotNearPlayer(playerid);
    if (PlayerInfo[userid][pWepLic] != 0)			return SendErrorMessage(playerid, "Nguoi choi da co giay phep vu khi.");
	if (pTemp[userid][pWepPlayer] == playerid)		return SendErrorMessage(playerid, "Ban da de nghi nguoi choi mua giay phep.");
	    
	pTemp[userid][pWepPlayer] = playerid;
	pTemp[userid][pWepPrice] = price;
	SetPVarInt(userid, #accept_time, gettime() + 30);
	SendSyntaxMessage(userid, "%s %s da de nghi ban muon giay phep vu khi voi gia $%i. (Nhan Y de mua giay phep)", GetRankName(playerid), GetNameEx(playerid), price);
	SendSyntaxMessage(playerid, "Ban da de nghi %s mua giay phep vu khi voi gia $%i.", GetNameEx(userid), price);
	return 1;
}

CMD:authweapon(playerid, params[])
{
    new userid;

	if (sscanf(params,"u",userid))			return SendHelpMessage(playerid, "/authweapon [ID/Ten]");
	if (!IsPlayerFactionPolice(playerid))	return SendErrorMessage(playerid, "Ban phai la nhan vien cua LSPD.");
	if (!isLeader(playerid))				return SendErrorMessage(playerid, "Ban khong phai la lanh dao cua to chuc.");
	if (!IsPlayerLogged(userid))			return SendNotConnected(playerid);
	if (!PlayerNearPlayer(3.0, playerid, userid))						return SendNotNearPlayer(playerid);
    if (PlayerInfo[userid][pFaction] != PlayerInfo[playerid][pFaction])	return SendErrorMessage(playerid, "Nguoi choi khong phai la thanh vien cua to chuc cua ban.");

	if (PlayerInfo[userid][pAuthwep] == 0)
	{
		PlayerInfo[userid][pAuthwep] = 1;
		SendSyntaxMessage(userid, "%s %s da trao cho ban quyen cap giay phep vu khi", GetRankName(playerid), GetNameEx(playerid));
		SendSyntaxMessage(playerid, "Ban da trao quyen cap giay phep vu khi cho %s.", GetNameEx(userid));
		return 1;
	}

	PlayerInfo[userid][pAuthwep] = 0;
	SendSyntaxMessage(userid, "%s %s da tuoc quyen cap giay phep vu khi cua ban", GetRankName(playerid), GetNameEx(playerid));
	SendSyntaxMessage(playerid, "Ban da tuoc quyen cap giay phep vu khi cua %s.", GetNameEx(userid));
	return 1;
}

CMD:authswat(playerid, params[])
{
	new userid;

	if (sscanf(params,"u",userid))			return SendHelpMessage(playerid, "/authswat [ID/Ten]");
	if (!IsPlayerFactionPolice(playerid))	return SendErrorMessage(playerid, "Ban phai la mot nhan vien canh sat.");
    if (!isLeader(playerid))				return SendErrorMessage(playerid, "Ban khong phai la lanh dao cua to chuc.");
	if (!IsPlayerLogged(userid))			return SendNotConnected(playerid);
	if (!PlayerNearPlayer(3.0, playerid, userid))						return SendNotNearPlayer(playerid);
    if (PlayerInfo[userid][pFaction] != PlayerInfo[playerid][pFaction])	return SendErrorMessage(playerid, "Nguoi choi khong phai la thanh vien cua to chuc cua ban.");

	if (PlayerInfo[userid][pSwat] == 0)
	{
		PlayerInfo[userid][pSwat] = 1;
		SendSyntaxMessage(userid, "%s %s da ban hanh quyen han nhan vien cua nhom S.W.A.T", GetRankName(playerid), GetNameEx(playerid));
		SendSyntaxMessage(playerid, "Ban da ban hanh quyen han S.W.A.T cho %s.", GetNameEx(userid));
		return 1;
	}

	PlayerInfo[userid][pSwat] = 0;
	SendSyntaxMessage(userid, "%s %s da tuoc quyen han nhan vien cua nhom S.W.A.T", GetRankName(playerid), GetNameEx(playerid));
	SendSyntaxMessage(playerid, "Ban da tuoc quyen han nhan vien S.W.AT cua %s.", GetNameEx(userid));
	return 1;
}

// IMPOUND COORDINATES (CHANGE HERE)
#define IMPOUNDX (-1209.9501)
#define IMPOUNDY (-1064.3761)
#define IMPOUNDZ (128.2656)

CMD:impound(playerid, params[])
{
    new faction = PlayerInfo[playerid][pFaction], vehicle = GetPlayerVehicleID(playerid);

	if (!IsFactionPolice(faction))				return SendErrorMessage(playerid, "Ban phai la mot nhan vien canh sat.");
	if (!PlayerInfo[playerid][pOnDuty])			return SendErrorMessage(playerid, "Ban can phai trong gio lam viec (/duty).");
	if (!IsATowTruck(vehicle))					return SendErrorMessage(playerid, "Ban phai o trong mot chiec xe keo. ");
    if (!IsTrailerAttachedToVehicle(vehicle))	return SendErrorMessage(playerid, "Chua keo mot chiec xe nao.");
	
	new trailer = GetVehicleTrailer(vehicle);

	if (!VehicleInfo[trailer][carOwnerID])								return SendErrorMessage(playerid, "Chi co phuong tien ca nhan moi duoc bat giu.");
	if (!PlayerToPoint(10.0, playerid, IMPOUNDX, IMPOUNDY, IMPOUNDZ))	return SendErrorMessage(playerid, "Ban dang o qua xa bai giam giu xe.");

	DetachTrailerFromVehicle(vehicle);
	GetVehiclePos(trailer, VehicleInfo[trailer][carParkX], VehicleInfo[trailer][carParkY], VehicleInfo[trailer][carParkZ]);
    GetVehicleZAngle(trailer, VehicleInfo[trailer][carParkA]);

	SendSyntaxMessage(playerid, "%s duoc gui den noi giam giu.", VehicleNames[GetVehicleModel(trailer)-400]);
	VehicleEngine(trailer, false);
	
	VehicleInfo[trailer][Impounded] = 1;

	Save_Car(trailer);
	
	foreach(new i : Player)
	{
	    if (!IsPlayerLogged(i) || PlayerInfo[i][pCarKey] != trailer) continue;

		SendSyntaxMessage(i, "%s cua ban da duoc gui den noi giam giu boi %s %s.", VehicleNames[GetVehicleModel(trailer)-400], GetRankName(playerid), GetNameEx(playerid));
		break;
	}
	return 1;
}

ALTX:rope("/br");
CMD:rope(playerid, params[])
{
	new faction = PlayerInfo[playerid][pFaction], vehicle = GetPlayerVehicleID(playerid);

	if (!IsFactionPolice(faction))			return SendErrorMessage(playerid, "Ban phai la mot nhan vien canh sat.");
	if (!PlayerInfo[playerid][pOnDuty])		return SendErrorMessage(playerid, "Ban can phai trong gio lam viec (/duty).");
	if (!PlayerInfo[playerid][pSwatDuty])	return SendErrorMessage(playerid, "Chuc nang nay co san cho S.W.A.T.");
	if (GetPVarInt(playerid, #SWATROPE))	return 1;
	if (IsPlayerInAnyVehicle(playerid))		return SendErrorMessage(playerid,"Ban phai o trong mot chiec may bay.");
	if (IsAHelicopter(vehicle))				return SendErrorMessage(playerid,"Ban phai o trong mot chiec may bay.");
	if (!GetPlayerVehicleSeat(playerid))	return SendErrorMessage(playerid, "Ban phai ngoi tren ghe khach.");

	OnPlayerCallRappelling(playerid);
	return 1;
}

CMD:tow(playerid, params[])
{
	new faction = PlayerInfo[playerid][pFaction], vehicle = GetPlayerVehicleID(playerid);

	if (!IsFactionPolice(faction))			return SendErrorMessage(playerid, "Ban phai la mot nhan vien canh sat.");
	if (!PlayerInfo[playerid][pOnDuty])		return SendErrorMessage(playerid, "Ban can phai trong gio lam viec (/duty).");
	if (!IsATowTruck(vehicle))				return SendErrorMessage(playerid, "Ban phai o trong xe keo.");
    if (IsTrailerAttachedToVehicle(vehicle))
	{
		DetachTrailerFromVehicle(vehicle);
		return SendErrorMessage(playerid, "Phuong tien bi cau truoc do da bi cat day.");
	}

	new vehid;

    if (sscanf(params,"i", vehid))														return SendHelpMessage(playerid, "/tow [vehicleID]");
	if (vehid < 1 || vehid >= MAX_VEHICLES)												return 1;
    if (GetNearVehicle(playerid, 14.0, vehid) == 0)										return SendErrorMessage(playerid, "Phuong tien nay phai o gan phuong tien cua ban.");
    if (IsABoat(vehid) || IsAPlane(vehid) || IsAHelicopter(vehid) || IsABiker(vehid))	return SendErrorMessage(playerid, "Phuong tien nay khong the bi keo.");
		
    AttachTrailerToVehicle(vehid, vehicle);
	SendSyntaxMessage(playerid, "Ban da keo %s. Su /tow - de bo keo.", VehicleNames[GetVehicleModel(vehid)-400]);
	return 1;
}

CMD:apb(playerid, params[])
{
	new action[24], secoption[153], tmp[2][128], faction = PlayerInfo[playerid][pFaction];

	if (!IsFactionPolice(faction))		return SendErrorMessage(playerid, "Ban phai la mot nhan vien canh sat.");
    if (!PlayerInfo[playerid][pOnDuty])	return SendErrorMessage(playerid, "Ban can phai trong gio lam viec (/duty).");

    if (sscanf(params, "s[24]S()[153]", action, secoption))
	{
		SendHelpMessage(playerid, "/apb [tuy chon]");
		SendSyntaxMessage(playerid, "create / clear / show / edit / list");
		return 1;
	}

	if (CompareStrings(action, "list"))
	{
	    new count;
	   
		for(new i = 0; i != MAX_APBS; i++)
	    {
	        if (ApbInfo[i][apbOn] == 0) continue;

	        if (strlen(ApbInfo[i][apbCharge]) > 64)	SendClientMessageEx(playerid, COLOR_LIGHTRED, "APB %i:{FFFFFF} %.64s ... (%s)", i, ApbInfo[i][apbCharge], ApbInfo[i][apbSuspect]);
	        else									SendClientMessageEx(playerid, COLOR_LIGHTRED, "APB %i:{FFFFFF} %s (%s)", i, ApbInfo[i][apbCharge], ApbInfo[i][apbSuspect]);

			count++;
	    }

	    if (!count)	return SendErrorMessage(playerid,"Khong tim thay ghi chu APB.");

		return 1;
	}
	else if (CompareStrings(action, "show"))
	{
		new number;

		if (sscanf(secoption,"i", number))	return SendHelpMessage(playerid, "/apb show [so APB]");
		if (!ApbInfo[number][apbOn])			return SendErrorMessage(playerid, "Khong tim thay ghi chu APB.");

		SCM(playerid, -1, "____________________________________");
		SendClientMessageEx(playerid, COLOR_LIGHTRED, "Nghi pham:{FFFFFF} %s", ApbInfo[number][apbSuspect]);
		
		if (strlen(ApbInfo[number][apbCharge]) > 64)
		{
		    SendClientMessageEx(playerid, COLOR_LIGHTRED, "Mieu ta:{FFFFFF} %.64s ...", ApbInfo[number][apbCharge]);
		    SendClientMessageEx(playerid, -1, "... %s", ApbInfo[number][apbCharge][64]);
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_LIGHTRED, "Mieu ta:{FFFFFF} %s", ApbInfo[number][apbCharge]);
		}

        SendClientMessageEx(playerid, COLOR_LIGHTRED, "Them boi:{FFFFFF} %s, %s.", ApbInfo[number][apbOfficer], Factions[ApbInfo[number][apbFaction]][fShortName]);
		SCM(playerid, -1, "____________________________________");
	}
	else if (CompareStrings(action, "clear"))
	{
		new number;

		if (sscanf(secoption,"i", number))	return SendHelpMessage(playerid, "/apb clear [so APB]");
		if (!ApbInfo[number][apbOn])		return SendErrorMessage(playerid, "Khong tim thay ghi chu APB.");

		SendSyntaxMessage(playerid, "Ban da xoa ghi chu cua APB so %i.", number);
		SendFactionMessage(FACTION_POLICE, COLOR_POLICECHAT, "* HQ: %s %s da xoa ghi cua APB so %i.", GetRankName(playerid), GetNameEx(playerid), number);

		new query[128];
		mysql_format(dbHandle, query, sizeof(query), "DELETE FROM `apbs` WHERE `id` = %i", ApbInfo[number][apbID]);
		mysql_tquery(dbHandle, query);

		ApbInfo[number][apbOn] =
		ApbInfo[number][apbID] = 0;
	}
	else if (CompareStrings(action, "edit"))
	{
		new number, info[153];

		if (sscanf(secoption,"is[153]", number, info))	return SendHelpMessage(playerid, "/apb edit [so APB] [suspect / description]");
		if (!ApbInfo[number][apbOn])					return SendErrorMessage(playerid, "Khong tim thay ghi chu APB.");
        if (strfind(info, "/", true) == -1)				return SendErrorMessage(playerid, "Khong tim thay ky hieu \"/\".");
		
		SendSyntaxMessage(playerid, "Ban da thay doi ghi chu APB [SO: %i].", number);
		strexplode(tmp, info, "/");
		format(ApbInfo[number][apbSuspect], MAX_PLAYER_NAME, "%s", tmp[0]);
		format(ApbInfo[number][apbCharge], 128, "%s", tmp[1]);
		ApbInfo[number][apbFaction] = faction;

		SendFactionMessage(FACTION_POLICE, COLOR_POLICECHAT, "* HQ: %s %s da thay doi APB so %i.", GetRankName(playerid), GetNameEx(playerid), number);
		
		new query[128 + 128];
		mysql_format(dbHandle,query, sizeof(query), "UPDATE `apbs` SET `charge` = '%s', `suspect` = '%e' WHERE `id` = %i", tmp[1], tmp[0], ApbInfo[number][apbID]);
		mysql_tquery(dbHandle, query);
		return 1;
	}
	else if (CompareStrings(action, "create"))
	{
		new info[153];

		if (sscanf(secoption,"s[153]", info))	return SendHelpMessage(playerid, "/apb create [suspect / description]");
        if (strfind(info, "/", true) == -1)		return SendErrorMessage(playerid, "Khong tim thay ky hieu \"/\".");

		new apb = -1;

		for(new i = 0; i != MAX_APBS; i++)
		{
			if (ApbInfo[i][apbOn] != 0) continue;

			apb = i;
			break;
		}

		if (apb == -1)	return SendErrorMessage(playerid, "Khong co cho cho ghi chu APB moi.");

		SendSyntaxMessage(playerid, "Ban da tao mot ghi chu APB moi [SO: %i].", apb);
		strexplode(tmp, info, "/");
		format(ApbInfo[apb][apbOfficer], MAX_PLAYER_NAME, "%s", GetNameEx(playerid));
		format(ApbInfo[apb][apbSuspect], MAX_PLAYER_NAME, "%s", tmp[0]);
		format(ApbInfo[apb][apbCharge], 128, "%s", tmp[1]);
		format(ApbInfo[apb][apbDate], 32, "%s", GetFullDate());

		ApbInfo[apb][apbFaction] = faction;

		SendFactionMessage(FACTION_POLICE, COLOR_POLICECHAT, "* HQ: %s %s them mot ghi chu APB moi, so %i.", GetRankName(playerid), GetNameEx(playerid), apb);
		
        new query[128 + 128];
		mysql_format(dbHandle,query, sizeof(query), "INSERT INTO `apbs` (faction, charge, suspect, officer, date) VALUES (%i, '%s', '%s', '%s', '%s')", faction, tmp[1], tmp[0], GetNameEx(playerid), GetFullDate());
		mysql_tquery(dbHandle, query, "ApbCreate", "i", apb);
		return 1;
	}
	return 1;
}

CMD:toll(playerid, params[])
{
	if (!IsPlayerFactionPolice(playerid))	return SendErrorMessage(playerid, "Ban phai la mot nhan vien canh sat.");
    if (!PlayerInfo[playerid][pOnDuty])		return SendErrorMessage(playerid, "Ban can phai trong gio lam viec (/duty).");
		
	if (isnull(params))
	{
	    SendHelpMessage(playerid, "/toll [options]");
	    SCM(playerid, COLOR_GRAD2, "close/open -Dong / Mo tat ca cac rao can. ");
	    //SCM(playerid, COLOR_GRAD2, "0 - ���������/��������� ��������� � ������� Richman.");
	    //SCM(playerid, COLOR_GRAD2, "0 - ���������/��������� ��������� Flint County.");
		SCM(playerid, COLOR_GRAD2, "0 - Mo / dong rao chan duong cao toc o Las Venturas. ");
		SCM(playerid, COLOR_GRAD2, "1 - Blueberry (cau ben phai) - mo / dong cac rao can tren cau ben phai trong Blueberry. ");
		SCM(playerid, COLOR_GRAD2, "2 - Blueberry (cau trai) - mo / dong cac rao can tren cau trai trong Blueberry. ");
		return 1;
	}
	
	if (L_a_RequestAllowedCop > gettime())	return SendErrorMessage(playerid, "Ban phai doi %i giay nua.", L_a_RequestAllowedCop - gettime());
	    
    if (CompareStrings(params, "open"))
	{
	    //if (PlayerInfo[playerid][pRank] < 10)	return SendErrorMessage(playerid, "Chuc nang nay co san cho cap bac 10.");
		
	    for(new i; i != MAX_TOLLS; i++)
		{
			aTolls[i][E_tLocked] = 0;
		}
		
        SendFactionMessage(FACTION_POLICE, COLOR_POLICECHAT, "** HQ: %s %s da mo moi rao can cho viec ra vao. **", GetRankName(playerid), GetNameEx(playerid));
		L_a_RequestAllowedCop = gettime() + TOLL_DELAY_COP;
		return 1;
	}
	else if (CompareStrings(params, "close"))
	{
	    if (PlayerInfo[playerid][pRank] < 10)	return SendErrorMessage(playerid, "Chuc nang nay co san cho cap bac 10. ");
			
		for(new i; i != MAX_TOLLS; i++)
		{
		    aTolls[i][E_tLocked] = 1;
		    Toll_CloseToll(i);
		}
		
		SendFactionMessage(FACTION_POLICE, COLOR_POLICECHAT, "** HQ: %s %s dong tat ca cac rao can cho viec ra vao. **", GetRankName(playerid), GetNameEx(playerid));
        L_a_RequestAllowedCop = gettime() + TOLL_DELAY_COP;
		return 1;
	}
	
	new id = strval(params);
	
	if (id < 0 || id > 4)				return SendHelpMessage(playerid, "/toll [so rao can]");
    if (PlayerInfo[playerid][pRank] < 4)	return SendErrorMessage(playerid, "Chuc nang nay co san cho cap bac 2.");
		
    if (!IsPlayerInRangeOfPoint(playerid, TOLL_OPEN_DISTANCE, toll_gate_pos[id][0], toll_gate_pos[id][1], toll_gate_pos[id][2]) && !IsPlayerInRangeOfPoint(playerid, TOLL_OPEN_DISTANCE, toll_gate_pos[id+1][0], toll_gate_pos[id+1][1], toll_gate_pos[id+1][2]))
	{
		return SendErrorMessage(playerid, "Ban nen o gan nhung rao can nay.");
	}
	        
	new toll_name[3][35] = /*{"������� Richman", "Flint County", */{"Xa lo Las Venturas", "tren cay cau Blueberry ben phai", "tren cay cau Blueberry ben trai"};

	if (aTolls[id][E_tLocked] == 0)
	{
		aTolls[id][E_tLocked] = 1;
		Toll_CloseToll(id);
		aTolls[id+1][E_tLocked] = 1;
		Toll_CloseToll(id+1);
		SendFactionMessage(FACTION_POLICE, COLOR_POLICECHAT, "** HQ: %s %s da dong rao can loi vao ra cua %s. **", GetRankName(playerid), GetNameEx(playerid), toll_name[id]);
	}
	else
	{
		aTolls[id][E_tLocked] = 0;
		aTolls[id+1][E_tLocked] = 0;
		SendFactionMessage(FACTION_POLICE, COLOR_POLICECHAT, "** HQ: %s %s da dong rao can loi vao ra cua %s. **", GetRankName(playerid), GetNameEx(playerid), toll_name[id]);
	}

	L_a_RequestAllowedCop = gettime() + TOLL_DELAY_COP;
	return 1;
}

ALTX:government("/gov");
CMD:government(playerid, params[])
{
    if (PlayerInfo[playerid][pMutedTime] > 0)	return SendErrorMessage(playerid, "Tro chuyen cuc bo cua ban da bi han che.");
	if (isnull(params))							return SendHelpMessage(playerid, "(/gov)ernment [van ban]");

	new faction = PlayerInfo[playerid][pFaction], rank = PlayerInfo[playerid][pRank];

    if (!IsFactionLegal(faction))						return SendErrorMessage(playerid, "Ban khong phai la thanh vien cua co cau quyen luc.");
	if (!isLeader(playerid) && rank != Factions[faction][fRanks]-1)	return SendErrorMessage(playerid, "Chi co san cho lanh dao.");
	if (PlayerInfo[playerid][pSettings] & togGov)					return SendErrorMessage(playerid, "Bat dau hien thi tin tuc chinh phi truoc. ");

	foreach(new i : Player)
	{
		if (!IsPlayerLogged(i) || (PlayerInfo[i][pSettings] & togGov))	continue;

		if (strlen(params) > MAXLEN)
		{
			new pos = MAXLEN;

			if (pos < MAXLEN-1) pos = MAXLEN;

			SendClientMessageEx(i, COLOR_LSPD, "[Thong bao cua Chinh phu] %.*s ...", pos, params);
			SendClientMessageEx(i, COLOR_LSPD, "[Thong bao cua Chinh phu] ... %s", params[pos]);
		}
		else
		{
			SendClientMessageEx(i, COLOR_LSPD, "[Thong bao cua Chinh phu] %s", params);
		}
	}
	return 1;
}

CMD:duty(playerid, params[])
{
	new faction = PlayerInfo[playerid][pFaction];

	if (!faction || !IsFactionLegal(faction))								return 1;
    if (!IsPlayerAtUniform(playerid) && !IsPlayerAtSecondUniform(playerid))	return SendErrorMessage(playerid, "You are not in the locker room / in the official vehicle.");

    Dialog_Show(playerid, DutyMenu, DIALOG_STYLE_LIST, "{FFFFFF}Nhiem vu", "- Bat dau\n- Trang phuc\n- Trang bi\n- Lay giap\n- Cung cap suc khoe", "Chon", "Huy bo");
	return 1;
}

CMD:color(playerid, params[])
{
	new faction = PlayerInfo[playerid][pFaction];

	if (!IsPlayerFactionPolice(playerid))	return SendErrorMessage(playerid, "Ban phai la mot nhan vien canh sat.");
    if (!PlayerInfo[playerid][pOnDuty])		return SendErrorMessage(playerid, "Ban can phai trong gio lam viec (/duty).");
	if (PlayerInfo[playerid][pRank] < 5)	return SendErrorMessage(playerid, "Chuc nang nay khong co san cho ban.");

    if (GetPlayerColor(playerid) != RemoveAlpha(Factions[faction][fColor]))
	{
		SetPlayerColor(playerid, RemoveAlpha(Factions[faction][fColor]));
        SendSyntaxMessage(playerid, "Ban da thay doi mau sac cua ten minh. ");
	}
	else
	{
		SetPlayerColor(playerid, TEAM_HIT_COLOR);
        SendSyntaxMessage(playerid, "Ban da thay doi mau sac cua ten minh.");
	}
	return 1;
}

/*
CMD:lift(playerid, params[])
{
	if (!IsPlayerInRangeOfPoint(playerid, 2.0, 2268.0640,2448.2449,3.5313) && !IsPlayerInRangeOfPoint(playerid, 2.0, 2781.0559,-1056.2823,1028.4969) && !IsPlayerInRangeOfPoint(playerid, 2.0, 2874.6665,-940.6707,1035.9259) && !IsPlayerInRangeOfPoint(playerid, 2.0, 2872.8813,-1072.9934,1037.1782)) return 1;

	Dialog_Show(playerid, LSPDElevator, DIALOG_STYLE_LIST, "{FFFFFF}Elevator", "[0] Garage\n[1] ������ ����\n[2] ������ ����\n[3] ���������� ���", "Chon", "Huy bo");
	return 1;
}*/

CMD:ane(playerid, params[])
{
    new
		vehicle = GetPlayerVehicleID(playerid), 
		userid
	;

	if (!IsPlayerFactionPolice(playerid))												
		return SendErrorMessage(playerid, "Ban phai la mot nhan vien canh sat.");
	
	new id = PlayerInfo[playerid][pFaction];

	if (VehicleInfo[vehicle][carFaction] != PlayerInfo[playerid][pFaction] && !PlayerToPoint(30.0, playerid, Factions[id][fPosX], Factions[id][fPosY], Factions[id][fPosZ]))	
		return SendErrorMessage(playerid, "Chi co o tru so canh sat hoac phuong tien LSPD / SASD.");
	if (sscanf(params, "i", userid))																										
		return SendHelpMessage(playerid, "/ane [so cuoc goi]");
	if (!IsPlayerLogged(userid) || pTemp[userid][pCallOn] != 1)																											
		return SendErrorMessage(playerid, "Khong tim thay cuoc goi voi so nay. ");

	if (pTemp[playerid][pPatrol])	SendFactionMessage(FACTION_POLICE, COLOR_LSPD, "* %s %s [%s] da nhan cuoc goi vao duong day nong. #%i.", GetRankName(playerid), GetNameEx(playerid), PatrolInfo[GetPatrolID(playerid)][pTemp[playerid][pPatrol]-1][patrulName], userid);
	else							SendFactionMessage(FACTION_POLICE, COLOR_LSPD, "* %s %s da nhan cuoc goi vao duong day nong. #%i.", GetRankName(playerid), GetNameEx(playerid), userid);	

	Waypoint_Set(playerid, pTemp[userid][pCallPosX], pTemp[userid][pCallPosY], pTemp[userid][pCallPosZ], 3.0);
	pTemp[userid][pCallOn] = 0;

	pTemp[playerid][pPoliceCalls]++;
	return 1;
}

ALTX:spike("/sp");
CMD:spike(playerid, params[])
{
	if (!IsPlayerFactionPolice(playerid))	return SendErrorMessage(playerid, "Ban phai la mot nhan vien canh sat.");
	if (!PlayerInfo[playerid][pOnDuty])		return SendErrorMessage(playerid, "Ban can phai trong gio lam viec (/duty).");
	
	new option[16], secoption[128];

	if (sscanf(params, "s[16]S()[128]", option, secoption))
	{
		SendHelpMessage(playerid, "/spike [create / remove / remall]");
		return 1;
	}

	if (CompareStrings(option, "create"))
	{
		if (GetWorld(playerid) != 0 || GetInterior(playerid) != 0)	return SendErrorMessage(playerid, "Ban phai o ngoai.");
		if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)		return SendErrorMessage(playerid, "Ban khong duoc o trong xe. ");

		new Float:x, Float:y, Float:z, Float:a, location[MAX_ZONE_NAME];

		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, a);

		if (CreateStrip(x, y, z, a) == -1)	return SendErrorMessage(playerid, "So luong rai dinh da dat toi da.");

		GetPlayer2DZone(playerid, location, MAX_ZONE_NAME);

		SendFactionMessage(FACTION_POLICE, COLOR_LSPD, "* HQ: %s %s da rai dinh tai %s.", GetRankName(playerid), GetNameEx(playerid), location);
		return 1;
	}

	if (CompareStrings(option, "remove"))
	{
		if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)	return SendErrorMessage(playerid, "Ban khong duoc o trong xe. ");

		for(new i = 0; i < MAX_SPIKE; i++)
		{
			if (!SpikeInfo[i][sCreated] || IsPlayerInRangeOfPoint(playerid, 4.0, SpikeInfo[i][sX], SpikeInfo[i][sY], SpikeInfo[i][sZ])) continue;

			SpikeInfo[i][sCreated] = 0;
			SpikeInfo[i][sX] = 
			SpikeInfo[i][sY] = 
			SpikeInfo[i][sZ] = 0.0;
			
			if (IsValidDynamicObject(SpikeInfo[i][sObject]))
			{
				DestroyDynamicObject(SpikeInfo[i][sObject]);
				SpikeInfo[i][sObject] = INVALID_OBJECT_ID;	
			}

			SendSyntaxMessage(playerid, "Da loai bo rai dinh [ID: %i].", i);
			break;
		}
		return 1;
	}

	else if (CompareStrings(option, "remall"))
	{
		for(new i = 0; i < MAX_SPIKE; i++)
		{
			if (!SpikeInfo[i][sCreated]) continue;

			SpikeInfo[i][sCreated] = 0;
			SpikeInfo[i][sX] = 
			SpikeInfo[i][sY] = 
			SpikeInfo[i][sZ] = 0.0;

			if (IsValidDynamicObject(SpikeInfo[i][sObject]))
			{
				DestroyDynamicObject(SpikeInfo[i][sObject]);
				SpikeInfo[i][sObject] = INVALID_OBJECT_ID;
			}
		}

		SendFactionMessage(FACTION_POLICE, COLOR_LSPD, "* HQ: %s %s da loai bo tat ca dinh tren cac con duong.", GetRankName(playerid), GetNameEx(playerid));
		return 1;
	}

	else 
	{
		SendHelpMessage(playerid, "/spike [create / remove / remall]");
	}
	return 1;
}

CMD:prisonlist(playerid, params[])
{
	new faction = PlayerInfo[playerid][pFaction];

	if (!IsFactionPolice(faction) || !IsFactionDocs(faction))	return SendErrorMessage(playerid,"Ban phai la nhan vien canh sat / nhan vien nha tu.");
	
	/*if (faction == DOCS)
	{
		SendClientMessage(playerid, COLOR_GREEN, "������ ����������� � ������:");
		foreach(new i : Player)
		{
			if (!IsPlayerLogged(i) || PlayerInfo[i][pJailed] != PRISON_JAIL) continue;

			SendClientMessageEx(playerid, COLOR_GRAD2, "%s%i %s | ����� ����������: %s ���.", (PlayerInfo[i][pIsolateTime] != 0)?("B"):("A"),PlayerInfo[i][pPrisoned]+100, GetNameEx(i), FormatNumber(PlayerInfo[i][pJailTime]));
		}
		return 1;
	}*/
	
	if (IsFactionPolice(faction))
	{
		SendClientMessage(playerid, COLOR_GREEN, "Danh sach tu nhan trong khu:");

		foreach(new i : Player)
		{		//(PlayerInfo[i][pJailed] != LSPD_JAIL && PlayerInfo[i][pJailed] != PALOMINO_JAIL)
			if (!IsPlayerLogged(i) || PlayerInfo[i][pJailed] != PALOMINO_JAIL) continue; 

			SendClientMessageEx(playerid, COLOR_GRAD2, "%s | Thoi gian giam giu: %s giay.", GetNameEx(i), FormatNumber(PlayerInfo[i][pJailTime]));
		}
		return 1;
	}
	
	/*else if (faction == SASD)
	{
		SendClientMessage(playerid, COLOR_GREEN, "������ ����������� � ������� San Andreas Sheriff's Department:");
		foreach(new i : Player)
		{
			if (!IsPlayerLogged(i) || PlayerInfo[i][pJailed] != SASD_JAIL) continue;

			SendClientMessageEx(playerid, COLOR_GRAD2, "%s | ����� ����������: %s ���.", GetNameEx(i), FormatNumber(PlayerInfo[i][pJailTime]));
		}
		return 1;
	}*/
	return 1;
}

ALTX:repaircam("/rcam");
CMD:repaircam(playerid)
{
	new faction = PlayerInfo[playerid][pFaction]; 

	if (!IsFactionPolice(faction)) 				return SendErrorMessage(playerid, "Ban phai la mot nhan vien canh sat."); 
	if (!IsPlayerHasItem(playerid, INV_TOOLS)) 	return SendErrorMessage(playerid, "Ban khong co cong cu.");

	new camid = GetNearestCamera(playerid, 10.0); 

	if (camid == -1) 				return SendErrorMessage(playerid, "Ban phai o gan Camera quan sat.");
	if (!CCTVInfo[camid][tvBreak]) 	return SendErrorMessage(playerid, "Camera nay khong can sua chua.");

	SetCameraBreakState(camid, 0); 
	SendSyntaxMessage(playerid, "Ban da sua chua Camera quan sat [ID: %i | %s].", camid, CCTVInfo[camid][tvName]);
	return 1; 
}

/*
CMD:rgun(playerid)
{
	if (IsPlayerFactionPolice(playerid))		return SendErrorMessage(playerid, "Ban phai la mot nhan vien canh sat."); 
	
	if (PlayerInfo[playerid][pInjured] != 0 || GetPVarInt(playerid, "Freeze") || pTemp[playerid][pTaserTime] || pTemp[playerid][pCuffed]) return SendErrorMessage(playerid, "Ban khong the su dung tinh nang nay ngay bay gio.");
	
	new dropid = -1;
	if ((dropid = ItemDrop_Nearest(playerid)) == -1) return SendErrorMessage(playerid, "�� ���� ����� ��� ��� ������.");
	if (ItemDrop[dropid][dropID] == 0) 				return SendErrorMessage(playerid, "�� ���� ����� ��� ��� ������.");
	
	if (inventory_items[ItemDrop[dropid][dropID]][itemType] == ITEM_TYPE_WEAPON)	
		return SendErrorMessage(playerid, "�� ���� ����� ��� ��� ������.");

	ItemDrop_Delete(dropid);
	return 1;
}*/


/*
#define MAX_HELP_LIST (50)

enum HELP_LIST_ENUM
{
	bool:hlExist,
    Float:hlX,
    Float:hlY,
    Float:hlZ,
	hlOfficer[MAX_PLAYER_NAME*2],
	hlTime,
	hlResponded //������� ��� ������������
};
new HelpList[MAX_HELP_LIST][HELP_LIST_ENUM];

GetFreeHelpListSlot() {

	return 1;
}

Dialog:HelpList(playerid, response, listitem, inputtext[])
{
	if (!response) return 1;

	new string[MAX_PLAYER_NAME*2 + ] = "";

	for (new i; i < MAX_HELP_LIST; i++) {
		new location[MAX_ZONE_NAME];
		GetZone(HelpList[i][hlX], HelpList[i][hlY], location, MAX_ZONE_NAME);

		format(string, sizeof(string), "������ �� %s ~%i ������ ����� � ������ %s", );
	}
	Show_Dialog(playerid, "����������� ������:", string, "Accept", "Close")
	return 1;
}


ALTX:panicbutton("/pb");
CMD:panicbutton(playerid)
{
	if (PlayerInfo[playerid][pInjured] != 0 || GetPVarInt(playerid, "Freeze") || pTemp[playerid][pTaserTime] || pTemp[playerid][pCuffed]) return SendErrorMessage(playerid, "Ban khong the su dung tinh nang nay ngay bay gio.");

	if (IsPlayerFactionPolice(playerid)) 	return SendErrorMessage(playerid, "Ban phai la mot nhan vien canh sat."); 
	if (!PlayerInfo[playerid][pOnDuty])		return SendErrorMessage(playerid, "Ban can phai trong gio lam viec (/duty).");
	
	new id = GetFreeHelpListSlot();

	if () { // in da interior
		
	}
	else GetPlayerPos(playerid, HelpList[id][hlX], HelpList[id][hlY], HelpList[id][hlZ]);

	HelpList[id][hlExist] = true;
	HelpList[id][hlResponded] = 0;
	HelpList[id][hlTime] = gettime(); 
	

	format(HelpList[id][hlOfficer], MAX_PLAYER_NAME*2, "%s %s", GetRankName(playerid), GetOfficerName(playerid));

	Waypoint_Set(playerid, HelpList[id][hlX], HelpList[id][hlY], HelpList[id][hlZ], 3.0);

	new location[MAX_ZONE_NAME];
	GetZone(HelpList[id][hlX], HelpList[id][hlY], location, MAX_ZONE_NAME);

	SendFactionMessage(FACTION_POLICE, COLOR_POLICECHAT, "** HQ: %s ����������� ������ � ������ %s.", HelpList[id][hlOfficer], location);
	return 1;
}

ALTX:pblist("/helplist");
CMD:pblist(playerid)
{
	if (PlayerInfo[playerid][pInjured] != 0 || GetPVarInt(playerid, "Freeze") || pTemp[playerid][pTaserTime] || pTemp[playerid][pCuffed]) return SendErrorMessage(playerid, "Ban khong the su dung tinh nang nay ngay bay gio.");

	if (IsPlayerFactionPolice(playerid)) 	return SendErrorMessage(playerid, "Ban phai la mot nhan vien canh sat."); 
	if (!PlayerInfo[playerid][pOnDuty])		return SendErrorMessage(playerid, "Ban can phai trong gio lam viec (/duty).");
	
	
	return 1;
}*/