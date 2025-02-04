CMD:repair(playerid, params[])
{
	new userid, type, vehid = GetPlayerVehicleID(playerid);

	if (!IsPlayerFactionMech(playerid))					return SendErrorMessage(playerid, "Ban khong phai la tho sua xe.");
	if (!IsDriver(playerid) || !IsATowTruck(vehid))		return SendErrorMessage(playerid, "Ban phai o trong xe keo voi tu cach la nguoi lai xe.");

	if (sscanf(params,"ui",userid, type))
	{
		SendHelpMessage(playerid, "/repair [ID/Part Of Name] [type]");
		SendSyntaxMessage(playerid, "Type 1: Engine Repair (Full Repair) ");
		SendSyntaxMessage(playerid, "type 2: Body repair ((Visual work)) ");
		SendSyntaxMessage(playerid, "type 3: Transport recovery ((Failed engine)) ");
		return 1;
	}

	if (type < 1 || type > 3)
	{
	    SendSyntaxMessage(playerid, "type 1: Kha nang phuc vu cua dong co ((Replenish HP)) ");
		SendSyntaxMessage(playerid, "type 2: Body repair ((Visual work)) ");
		SendSyntaxMessage(playerid, "type 3: Transport recovery ((Failed engine)) ");
	    return 1;
	}

	if (userid == playerid)							return SendErrorMessage(playerid, "Ban khong the tu minh thuc hien nhung hanh dong nay. ");
	if (!IsPlayerLogged(userid))						return SendNotConnected(playerid);
	if (!PlayerNearPlayer(6.0, playerid, userid))	return SendNotNearPlayer(playerid);
	if (!IsDriver(userid))							return SendErrorMessage(playerid, "Nguoi choi phai o trong xe.");

	new vehicle = GetPlayerVehicleID(userid);

	if (VehicleInfo[vehicle][carFaction] != 0 && type != 1 && type != 2)												return SendErrorMessage(playerid, "Phuong tien giao thong nay thuoc cau truc nha nuoc.");
    if (pTemp[userid][pServePlayer] == playerid && (pTemp[userid][pServeType] > 0 && pTemp[userid][pServeType] < 4))	return SendErrorMessage(playerid, "Ban da cung cap dich vu cua minh cho %s.", GetNameEx(userid));
	    
	if (type == 1)
	{
		if (VehicleInfo[vehid][carComps] < 75)	return SendErrorMessage(playerid, "Ban can toi thieu 75 thanh phan de sua chua dong co cua minh.");

		new mes[128];
    	format(mes, sizeof(mes), " %s yeu cau sua chua dong co%s.", GetNameWithMask(userid), VehicleNames[GetVehicleModel(vehicle)-400]);
		cmd::me(playerid, mes);
		SendSyntaxMessage(userid, "%s yeu cau ban sua chua dong co. (Nhan Y de chap nhan yeu cau)", GetNameWithMask(playerid));
	}
	else if (type == 2)
	{
	    if (VehicleInfo[vehid][carComps] < 75)	return SendErrorMessage(playerid, "Ban can toi thieu 75 thanh phan de sua chua dong co cua minh.");

		new mes[128];
    	format(mes, sizeof(mes), "yeu cau %s bodywork %s.", GetNameWithMask(userid), VehicleNames[GetVehicleModel(vehicle)-400]);
		cmd::me(playerid, mes);
		SendSyntaxMessage(userid, "%s yeu cau ban body work. (Nhan Y de chap nhan yeu cau)", GetNameWithMask(playerid));
	}
	else if (type == 3)
	{
		if (VehicleInfo[vehid][carComps] < 75)		return SendErrorMessage(playerid, "Ban can toi thieu 75 thanh phan de sua mot dong co khong hoat dong.");
		if (VehicleInfo[vehicle][carEngine] >= 20.0)	return SendErrorMessage(playerid, "Dong co cua xe nay khong can sua chua ( > 20%%).");

        new mes[128];
    	format(mes, sizeof(mes), " %s yeu cau sua chua dong co%s.", GetNameWithMask(userid), VehicleNames[GetVehicleModel(vehicle)-400]);
		cmd::me(playerid, mes);
		SendSyntaxMessage(userid, "%s cung cap cho ban sua chua mot dong co bi hu hong. (Nhan Y de chap nhan yeu cau)", GetNameWithMask(playerid));
	}
	
	pTemp[userid][pServePlayer] = playerid;
	pTemp[userid][pServeType] = type;
	SetPVarInt(userid, #accept_time, gettime() + 30);
	return 1;
}

CMD:buycomp(playerid, params[]) //����
{
	new amount;
	
	if (!IsPlayerFactionMech(playerid))						return SendErrorMessage(playerid, "Ban khong phai la tho sua xe.");
	if (!IsDriver(playerid))								return SendErrorMessage(playerid, "Ban phai o trong xe keo voi tu cach la nguoi lai xe.");
	if (!IsATowTruck(GetPlayerVehicleID(playerid)))	return SendErrorMessage(playerid, "Ban phai o trong xe keo voi tu cach la nguoi lai xe.");
	if (!PlayerToPoint(6.0, playerid, 2430.4412,-2454.9304,13.6250))
	{
		Waypoint_Set(playerid, 2430.4412,-2454.9304,13.6250, 8.0);
		return SendSyntaxMessage(playerid, "Vi tri mua cac thanh phan duoc danh dau tren ban do. (/removecp)");
	}

	if (sscanf(params,"d",amount))
	{
		SendHelpMessage(playerid, "/buycomp [amount]");
		return 1;
	}

	if (amount < 1 || amount > 300)											return SendErrorMessage(playerid, "So luong thanh phan tu 1 den 300.");
    if (VehicleInfo[GetPlayerVehicleID(playerid)][carComps] >= 300)			return SendErrorMessage(playerid, "Phuong tien giao thong co so luong thanh phan toi da. ");
	if (VehicleInfo[GetPlayerVehicleID(playerid)][carComps] + amount > 300)	return SendErrorMessage(playerid, "Ban chi co the mua %i thanh phan.", 300 - VehicleInfo[GetPlayerVehicleID(playerid)][carComps]);
	if (GetCash(playerid) < amount)											return SendErrorMessage(playerid, "Ban can $%i de mua.", amount);

	GiveCash(playerid, -amount);
	SendSyntaxMessage(playerid, "Ban da mua %i thanh phan voi gia $%i.", amount, amount);
	JobMessage(playerid, "~w~BAN HAY THAM KHAO MOT SO SAN PHAM CHO XE TAI CUA BAN.", 6);
	VehicleInfo[GetPlayerVehicleID(playerid)][carComps] += amount;
	return 1;
}

CMD:mycomp(playerid, params[])
{
	if (!IsPlayerFactionMech(playerid))					return SendErrorMessage(playerid, "Ban khong phai la tho sua xe.");
	if (!IsDriver(playerid))							return SendErrorMessage(playerid, "Ban phai o trong xe keo voi tu cach la nguoi lai xe.");
	if (!IsATowTruck(GetPlayerVehicleID(playerid)))		return SendErrorMessage(playerid, "Ban phai o trong xe keo voi tu cach la nguoi lai xe.");

    SendSyntaxMessage(playerid, "Tow Truck co %i thanh phan.", VehicleInfo[GetPlayerVehicleID(playerid)][carComps]);
	return 1;
}

CMD:refill(playerid, params[])
{
	new userid, price;

	if (!IsPlayerFactionMech(playerid))					return SendErrorMessage(playerid, "Ban khong phai la tho sua xe.");
	if (!IsDriver(playerid))								return SendErrorMessage(playerid, "Ban phai o trong xe keo voi tu cach la nguoi lai xe.");
	if (!IsATowTruck(GetPlayerVehicleID(playerid)))		return SendErrorMessage(playerid, "Ban phai o trong xe keo voi tu cach la nguoi lai xe.");
	if (sscanf(params,"ud",userid,price))				return SendHelpMessage(playerid, "/refill [ID/Part Of Name] [price]");
	if (userid == playerid)								return SendErrorMessage(playerid, "Ban khong the tu minh thuc hien nhung hanh dong nay.");
	if (!IsPlayerLogged(userid))							return SendNotConnected(playerid);
	if (!PlayerNearPlayer(6.0, playerid, userid))		return SendNotNearPlayer(playerid);
	if (!IsDriver(userid))								return SendErrorMessage(playerid, "Nguoi choi phai o trong xe.");

    new vehicle = GetPlayerVehicleID(userid);

    if (VehicleInfo[vehicle][carFuel] >= GetVehicleFuelCapacity(GetVehicleModel(vehicle)))	
		return SendErrorMessage(playerid, "Be chua da day.");
	if (price < 1 || price > 500)															
		return SendErrorMessage(playerid, "Gia de do la tu  $1 - $500.");

    new mes[128];
    format(mes, sizeof(mes), "de nghi tiep nhien lieu cho xe %s voi gia $%i.", GetNameWithMask(userid), price);
	cmd::me(playerid, mes);

	SendClientMessageEx(userid, COLOR_INFO, "%s moi ban tiep nhien lieu cho xe voi gia $%i. (Nhan Y de chap nhan yeu cau)", GetNameWithMask(playerid), price);
	RefillPrice[userid] = price;
	RefillOffer[userid] = playerid;
	return 1;
}

CMD:paintcar(playerid, params[])
{
	new userid, color1, color2;

	if (!IsPlayerFactionMech(playerid))					return SendErrorMessage(playerid, "Ban khong phai la tho sua xe.");
	if (!IsDriver(playerid))											return SendErrorMessage(playerid, "Ban phai o trong xe keo voi tu cach la nguoi lai xe.");
	if (!IsATowTruck(GetPlayerVehicleID(playerid)))				return SendErrorMessage(playerid, "Ban phai o trong xe keo voi tu cach la nguoi lai xe.");
	if (sscanf(params,"udd", userid, color1, color2))				return SendHelpMessage(playerid, "/paintcar [ID/Part Of Name] [Colour 1] [Colour 2](/colorlist)");
	if (color1 > 255 || color2 > 255 || color1 < 0 || color2 < 0)	return SendErrorMessage(playerid, "ID mau chi tu 0 den 255.");
	if (userid == playerid)											return SendErrorMessage(playerid, "Ban khong the tu minh thuc hien nhung hanh dong nay.");
	if (!IsPlayerLogged(userid))										return SendNotConnected(playerid);
	if (!PlayerNearPlayer(6.0, playerid, userid))					return SendNotNearPlayer(playerid);
	if (!IsDriver(userid))											return SendErrorMessage(playerid, "Nguoi choi phai o trong xe.");

	new vehicle = GetPlayerVehicleID(userid);

	if (VehicleInfo[vehicle][carFaction] != 0)										return SendErrorMessage(playerid, "Phuong tien giao thong nay thuoc cau truc nha nuoc. ");
	if (VehicleInfo[GetPlayerVehicleID(playerid)][carComps] < 45)					return SendErrorMessage(playerid, "Ban can toi thieu 45 thanh phan de son lai. ");
    if (pTemp[userid][pServePlayer] == playerid && pTemp[userid][pServeType] == 4)	return SendErrorMessage(playerid, "Ban da cung cap dich vu cua minh cho %s.", GetNameEx(userid));

	new mes[128];
    format(mes, sizeof(mes), "de nghi %s son %s.", GetNameWithMask(userid), VehicleNames[GetVehicleModel(vehicle)-400]);
	cmd::me(playerid, mes);

	SendClientMessageEx(userid, COLOR_INFO, "%s de nghi ban son. (Nhan Y de chap nhan yeu cau)", GetNameWithMask(playerid));

	SetPVarInt(playerid, "color1", color1);
	SetPVarInt(playerid, "color2", color2);
	pTemp[userid][pServePlayer] = playerid;
 	pTemp[userid][pServeType] = 4;
 	SetPVarInt(userid, #accept_time, gettime() + 30);
	return 1;
}

CMD:attach(playerid, params[])
{
	new veh = GetPlayerVehicleID(playerid);
    if (!IsPlayerFactionMech(playerid))					return SendErrorMessage(playerid, "Ban khong phai la tho sua xe.");
	if (!IsDriver(playerid) || !IsATowTruck(veh))	return SendErrorMessage(playerid, "Ban phai o trong xe keo voi tu cach la nguoi lai xe.");
    new Float:vX, Float:vY, Float:vZ;
    new Found = 0;
    new vid = 0;
    while ((vid<MAX_VEHICLES) && (!Found)) 
	{
        vid++;
        GetVehiclePos(vid, vX, vY, vZ);
        if ((GetNearVehicle(playerid, 14.0, vid)) && (vid != GetPlayerVehicleID(playerid))) 
		{
            Found = 1;
            if (IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid))) 
			{
                DetachTrailerFromVehicle(GetPlayerVehicleID(playerid));
            }
            AttachTrailerToVehicle(vid, GetPlayerVehicleID(playerid));
			new mes[128];
			format(mes, sizeof(mes), "nhan mot nut tren bang dieu khien cua ho, keo %s.", VehicleNames[GetVehicleModel(vid)-400]);
			cmd::me(playerid, mes);
        }
    }
    if (!Found) 
	{
        SendErrorMessage(playerid, "Khong co phuong tien nao trong pham vi ma ban co the keo.");
    }
    return 1;
}

/*CMD:attach(playerid, params[])
{
	new userid, vehicle = GetPlayerVehicleID(playerid);

	if (!IsPlayerFactionMech(playerid))					return SendErrorMessage(playerid, "Ban khong phai la tho sua xe.");
	if (!IsDriver(playerid) || !IsATowTruck(vehicle))	return SendErrorMessage(playerid, "Ban phai o trong xe keo voi tu cach la nguoi lai xe.");
	if (IsTrailerAttachedToVehicle(vehicle))
	{
		DetachTrailerFromVehicle(vehicle);
		return SendErrorMessage(playerid, "The previously hitched vehicle was cordoned off.");
	}

	if (sscanf(params,"u", userid))					return SendHelpMessage(playerid, "/attach [ID/Part Of Name]");
	if (userid == playerid)							return SendErrorMessage(playerid, "Ban khong the tu minh thuc hien nhung hanh dong nay.");
	if (!IsPlayerLogged(userid))						return SendNotConnected(playerid);
	if (!PlayerNearPlayer(8.0, playerid, userid))	return SendNotNearPlayer(playerid);
	if (!IsPlayerInAnyVehicle(userid))				return SendErrorMessage(playerid, "Nguoi choi phai o trong xe.");

	if (pTemp[userid][pServePlayer] == playerid && pTemp[userid][pServeType] == 5) 	return SendErrorMessage(playerid, "Ban da cung cap dich vu cua minh cho %s.", GetNameEx(userid));

	new vehid = GetPlayerVehicleID(userid);

    if (IsABoat(vehid) || IsAPlane(vehid) || IsAHelicopter(vehid) || IsABiker(vehid))	return SCM(playerid, COLOR_GREY,"This transport cannot be hooked.");

    new mes[128];
    format(mes, sizeof(mes), "yeu cau %s keo %s.", GetNameWithMask(userid), VehicleNames[GetVehicleModel(vehid)-400]);
	cmd::me(playerid, mes);

	SendClientMessageEx(userid, COLOR_INFO, "* %s yeu cau ban keo phuong tien. (Ra khoi xe va nhan phim Y de chap nhan yeu cau)", GetNameWithMask(playerid));
	SetPVarInt(userid, #tow_car, vehid);
	pTemp[userid][pServePlayer] = playerid;
	pTemp[userid][pServeType] = 5;
	SetPVarInt(userid, #accept_time, gettime() + 30);
	return 1;
}*/

