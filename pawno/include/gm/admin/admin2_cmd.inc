CMD:up(playerid, params[])
{
	new amount, Float:x, Float:y, Float:z;

	if (!CheckAdmin(playerid, ADMIN_LEVEL_2)) 	return SendNotAdmin(playerid);
	if (sscanf(params,"d", amount)) 			return SendHelpMessage(playerid, "/up [blocks]");
	
	GetPlayerPos(playerid, x, y ,z);
	SetPlayerPosEx(playerid, x, y, z+amount);
	return 1;
}

CMD:down(playerid, params[])
{
	new amount, Float:x, Float:y, Float:z;

	if (!CheckAdmin(playerid, ADMIN_LEVEL_2)) 	return SendNotAdmin(playerid);
	if (sscanf(params,"d", amount)) 			return SendHelpMessage(playerid, "/down [blocks]");

	GetPlayerPos(playerid, x, y ,z);
	SetPlayerPosEx(playerid, x, y, z-amount);
	return 1;
}

CMD:policer(playerid, params[])
{
	if (!CheckAdmin(playerid, ADMIN_LEVEL_2))
		return SendErrorMessage(playerid, "Ban khong co du quyen de su dung lenhBan khong co du quyen de su dung lenh.");

	//SCMALL(COLOR_LIGHTBLUE, "<< THE ADMINISTRATOR PRODUCED RESPAVN OF POLICE TS >>");
	AMSG(COLOR_LIGHTRED, "AdmCmd: %s da spawn phuong tien canh sat.", GetAccName(playerid));

	new vehicle,
	    occupied[MAX_VEHICLES char];
	    
    foreach(new i : Player)
	{
	    if ((vehicle = GetPlayerVehicleID(i)) == 0 || !IsFactionPolice(VehicleInfo[vehicle][carFaction]))
	        continue;
	        
		occupied{vehicle} = 1;
	}
	
	for(new i; i < MAX_VEHICLES; i++)
	{
		if (!IsFactionPolice(VehicleInfo[vehicle][carFaction]) || occupied{i} == 1)
			continue;

		RespawnVehicle(i);
	}
	return 1;
}

CMD:getincar(playerid, params[])
{
	new vehicle;

	if (!CheckAdmin(playerid, ADMIN_LEVEL_2))	return SendNotAdmin(playerid);
	if (sscanf(params,"d",vehicle))				return SendHelpMessage(playerid, "/getincar [Vehicle ID]");
	if (!IsValidVehicle(vehicle))				return SendErrorMessage(playerid, "ID phuong tien khong tim thay.");

	PutPlayerInVehicle(playerid, vehicle, 0);
	SendAdmMessage("%s dich chuyen toi phuong tien [ID: %i].", GetAccName(playerid), vehicle);
	return 1;
}

CMD:afire(playerid,params[])
{
	if (!CheckAdmin(playerid, ADMIN_LEVEL_2))	return SendNotAdmin(playerid);

	new option[16];

	if (sscanf(params, "s[16]", option))
	{
		SendHelpMessage(playerid, "/afire [bat / xoatatca]");
		return 1;
	}

	if (CompareStrings(option, "bat"))
	{
		if (GetPVarInt(playerid, #crt_fire) == 0)
		{
			if (IsPlayerHoldingWeapon(playerid)) return SendErrorMessage(playerid, "Su dung vu khi trong tui do!");

			SetPVarInt(playerid, #crt_fire, 1);

  			GivePlayerWeapon(playerid, 24, 500);

			SendSyntaxMessage(playerid, "Ban dang o trong MODE tao cac dam chay - de tat su dung /afire bat.");
			SendSyntaxMessage(playerid, "Ban vao noi ma ban muon tao dam chay.");
			SendAdmMessage("%s da vao che do tao lua.", GetAccName(playerid));
			return 1;
		}

		SendAdmMessageToPlayer(playerid, "Ban da thoat khoi MODE tao dam chay. De xoa tat ca dam chay su dung /afire xoatatca.");
		SendAdmMessage("%s exited the mode of creating fires.", GetAccName(playerid));
		
		ResetPlayerWeapons(playerid);
		DeletePVar(playerid, #crt_fire);
	 	return 1;
	}

	else if (CompareStrings(option, "xoatatca"))
	{
		for(new i; i != MAX_FIRES; i++)
		{
		    if (FiresInfo[i][fireOn] == 0) continue;

			DeleteFire(i);
		}
		SendAdmMessage("%s da xoa tat ca cac dam chay.", GetAccName(playerid));
	}

	else 
	{
		SendHelpMessage(playerid, "/afire [bat/xoatatca]");
	}
	return 1;
}

CMD:aengine(playerid, params[])
{
	if (!CheckAdmin(playerid, ADMIN_LEVEL_2))	return SendNotAdmin(playerid);
	if (!IsPlayerInAnyVehicle(playerid))			return SendNotInVehicle(playerid);

	new vehicleid = GetPlayerVehicleID(playerid);

	ToggleVehicleEngine(vehicleid, playerid);
	return 1;
}

CMD:fillveh(playerid, params[])
{
	new vehicle;

	if (!CheckAdmin(playerid, ADMIN_LEVEL_2))	return SendNotAdmin(playerid);
	if (sscanf(params,"d",vehicle))				return SendHelpMessage(playerid, "/fillveh [Vehicle ID]");
	if (!IsValidVehicle(vehicle))				return SendErrorMessage(playerid, "ID Phuong tien khong duoc tim thay.");

    VehicleInfo[vehicle][carFuel] = GetVehicleFuelCapacity(GetVehicleModel(vehicle));
	SendAdmMessageToPlayer(playerid, "Ban da nap xang cho phuong tien ID:%i.", vehicle);   
	return 1;
}

CMD:fillallveh(playerid, params[])
{
	if (!CheckAdmin(playerid, ADMIN_LEVEL_2)) return SendNotAdmin(playerid);

	for(new i; i < MAX_VEHICLES; i++)
	{
        VehicleInfo[i][carFuel] = GetVehicleFuelCapacity(GetVehicleModel(i));
	}

	SendAdmMessageToAll("Tat ca cac phuong tien trong may chu da duoc nap day xang boi Admin %s.", GetAccName(playerid));   
	return 1;
}

CMD:rtc(playerid, params[])
{
	new vehicle;

	if (!CheckAdmin(playerid, ADMIN_LEVEL_2))	return SendNotAdmin(playerid);
	if (sscanf(params,"d",vehicle))				return SendHelpMessage(playerid, "/rtc [Vehicle ID]");
    if (!IsValidVehicle(vehicle))				return SendErrorMessage(playerid, "ID Phuong tien khong duoc tim thay.");
	if (!VehicleEmpty(vehicle))					return SendErrorMessage(playerid, "Phuong tien nay dang duoc su dung.");

	if (VehicleInfo[vehicle][carOwnerID] != 0)
	{
	    new userid = GetVehicleOwner(vehicle);

	    if (userid != INVALID_PLAYER_ID)
	    {
	    	SendAdmMessageToPlayer(userid, "Administrator %s da respawn phuong tien %s.", GetAccName(playerid), VehicleNames[GetVehicleModel(vehicle)-400]);
			PlayerInfo[userid][pCarKey] = 0;
			VehicleInfo[vehicle][carOwnerPlayer] = INVALID_PLAYER_ID;
		}
		ResetVehicleStuff(vehicle, 1);
		DestroyVehicle(vehicle);
	}
    else
	{
		SendAdmMessageToPlayer(playerid, "Ban da respawn phuong tien %s [ID: %i].", VehicleNames[GetVehicleModel(vehicle)-400], vehicle);
		RespawnVehicle(vehicle);
	}
	return 1;
}

CMD:rtcall(playerid, params[])
{
	if (!CheckAdmin(playerid, ADMIN_LEVEL_2))	return SendNotAdmin(playerid);

	SendAdmMessage("%s da respawn tat ca cac phuong tien tren may chu.", GetAccName(playerid));

    new vehicle, occupied[MAX_VEHICLES char];

    foreach(new i : Player)
	{
	    if ((vehicle = GetPlayerVehicleID(i)) == 0) continue;

		occupied{vehicle} = 1;
	}

	for(new i = 1; i < MAX_VEHICLES; i++)
	{
		if (!IsValidVehicle(i) || occupied{i} == 1) continue;

		if (VehicleInfo[i][carOwnerID] != 0)
		{
		    new userid = GetVehicleOwner(i);
		    if (userid != INVALID_PLAYER_ID)
		    {
		    	SendSyntaxMessage(userid, "Administrator %s da respawn phuong tien %s.", GetAccName(playerid), VehicleNames[GetVehicleModel(i)-400]);
				PlayerInfo[userid][pCarKey] = 0;
				VehicleInfo[i][carOwnerPlayer] = INVALID_PLAYER_ID;
			}
			ResetVehicleStuff(i, 1);
			DestroyVehicle(i);
		}
	    else RespawnVehicle(i);
	}
	return 1;
}

CMD:amark(playerid, params[])
{
	new option[16], string[145];

	if (!CheckAdmin(playerid, ADMIN_LEVEL_2)) return SendErrorMessage(playerid, "Ban khong the su dung lenh nay.");
	if (sscanf(params, "s[16]S()[144]", option, string))
	{
		SendHelpMessage(playerid, "/amark [xoa/info/goto]");
		return 1;
	}

	if (CompareStrings(option, "xoa"))
	{
		new markid;
		if (sscanf(string, "i", markid))								return SendHelpMessage(playerid, "/amark destroy [ID tags]");
		if (markid < 0 || markid >= MAX_MARKS || !E_MARKS[markid][mON])	return SendErrorMessage(playerid, "ID Mark khong tim thay.");

		DestroyDynamicMark(markid);
		SendSyntaxMessage(playerid, "Ban da xoa mark [ID: %i].", markid);
		return 1;
	}
	else if (CompareStrings(option, "info"))
	{
		new markid = Mark_Nearest(playerid);

		if (markid == -1) return SendErrorMessage(playerid, "ID Tag khong tim thay.");

		new mark_info[512];
		mark_info[0] = EOS;

		format(mark_info, sizeof(mark_info), "ID mark\t%i\nTao boi\t%s\nNgay tao\t%s", markid, E_MARKS[markid][mCreator], E_MARKS[markid][mCreateDate]);
		Dialog_Show(playerid, None, DIALOG_STYLE_TABLIST, "{FFFFFF}Mark information", mark_info, "Dong", "");
		return 1;
	}
	else if (CompareStrings(option, "goto"))
	{
		new markid;
		if (sscanf(string, "i", markid))								return SendHelpMessage(playerid, "/amark goto [ID mark]");
		if (markid < 0 || markid > MAX_MARKS || !E_MARKS[markid][mON])	return SendErrorMessage(playerid, "ID mark khong tim thay.");

		SetPlayerPosEx(playerid, E_MARKS[markid][mPosX], E_MARKS[markid][mPosY], E_MARKS[markid][mPosZ]);
		SetInterior(playerid, E_MARKS[markid][mInt]);
		SetWorld(playerid, E_MARKS[markid][mVW]);
	}
	else
	{
		SendHelpMessage(playerid, "/amark [xoa info goto]");
	}
	return 1;
}

ALTX:sethp("/sethealth");
CMD:sethp(playerid, params[])
{
	new userid, hp;

	if (!CheckAdmin(playerid, ADMIN_LEVEL_2))	return SendNotAdmin(playerid);
	if (sscanf(params,"ud", userid, hp))		return SendHelpMessage(playerid, "/sethp [ID/Ten] [health (1-100)]");
	if (!IsPlayerLogged(userid))				return SendNotConnected(playerid);
    if (PlayerInfo[playerid][pInjured]) 		return SendErrorMessage(playerid, "Nguoi choi dang bi thuong hoac da chet - su dung /aheal");
	if (hp < 0 || hp > 100)						return SendErrorMessage(playerid, "Mau phai tu 0 den 100.");

	SendAdmMessageToPlayer(userid, "Administrator %s da hoi mau cho ban %i HP.", GetAccName(playerid), hp);
	SendAdmMessageToPlayer(playerid, "Ban da hoi mau cho %s %i HP.", GetNameEx(userid), hp);
	SetPlayerHealth(userid, hp);
	return 1;
}

ALTX:setarmour("/setar");
CMD:setarmour(playerid, params[])
{
	new userid, armour;

	if (!CheckAdmin(playerid, ADMIN_LEVEL_2))	return SendNotAdmin(playerid);
	if (sscanf(params,"ud", userid, armour))	return SendHelpMessage(playerid, "/setarmour [ID/Ten] [armor (1-100)]");
	if (armour < 1 || armour > 100)				return SendErrorMessage(playerid, "Armor (1-100)");
	if (!IsPlayerLogged(userid))				return SendNotConnected(playerid);

	SendAdmMessageToPlayer(userid, "Administrator %s da tao giap cho ban %i AR.", GetAccName(playerid), armour);
	SendAdmMessageToPlayer(playerid, "Ban da tao giap %s %i armor.", GetNameEx(userid), armour);
    SetPlayerArmour(userid, armour);
	return 1;
}

CMD:setskin(playerid, params[])
{
	new targetid, skinid;

	if (!CheckAdmin(playerid, ADMIN_LEVEL_2))		return SendNotAdmin(playerid);
	if (sscanf(params,"ui", targetid, skinid))		return SendHelpMessage(playerid, "/setskin [ID/Ten] [ID skin (0 - 311)]");
	if (!IsPlayerLogged(targetid))					return SendNotConnected(playerid);
	//if (skinid < 1 || skinid == 74 || skinid > 311)	return SendErrorMessage(playerid, "ID skin from 1 to 311.");

	SetPlayerSkinEx(targetid, skinid);
	SendAdmMessageToPlayer(targetid, "Administrator %s da thay doi trang phuc cua ban [ID: %i].", GetAccName(playerid), skinid);
	SendAdmMessageToPlayer(playerid, "Ban da thay doi trang phuc cua %s [ID: %i].", GetNameEx(targetid), skinid);
	return 1;
}

CMD:showpm(playerid, params[])
{
	new userid;

	if (!CheckAdmin(playerid, ADMIN_LEVEL_2))	return SendNotAdmin(playerid);
	if (sscanf(params,"u", userid))				return SendHelpMessage(playerid, "/showpm [ID/Ten]");
	if (!IsPlayerLogged(userid))				return SendNotConnected(playerid);

    pTemp[playerid][pPMPlayer] = userid;
	SendSyntaxMessage(playerid, "Ban dang xem PM cua %s. Nhap /showpmoff de tat.", GetNameEx(userid));
	return 1;
}

CMD:showpmoff(playerid, params[])
{
	if (!CheckAdmin(playerid, ADMIN_LEVEL_2))				return SendNotAdmin(playerid);
	if (pTemp[playerid][pPMPlayer] == INVALID_PLAYER_ID)	return SendErrorMessage(playerid, "Ban khong xem PM.");

	SendSyntaxMessage(playerid, "Ban da dung xem PM tren %s.", GetNameEx(pTemp[playerid][pPMPlayer]));
	pTemp[playerid][pPMPlayer] = INVALID_PLAYER_ID;
	return 1;
}

CMD:showpms(playerid, params[]) 
{
	if (!CheckAdmin(playerid, ADMIN_LEVEL_2)) return SendNotAdmin(playerid);

	SCM(playerid, COLOR_WHITE, "Ban dang xem PM cua may chu, \"/nopms\" de dung.");
	SetPVarInt(playerid, #spypm_all, 1);
	return 1;
}

CMD:nopms(playerid, params[])
{
	if (!CheckAdmin(playerid, ADMIN_LEVEL_2))
		return SendNotAdmin(playerid);

	if (GetPVarInt(playerid, #spypm_all) == 0)
		return SCM(playerid, COLOR_LIGHTRED, "Ban khong xem PM");

	SCM(playerid, COLOR_WHITE, "Ban da dung xem PM.");
	DeletePVar(playerid, #spypm_all);
	return 1;
}

CMD:telecmds(playerid, params[])
{
	if (!CheckAdmin(playerid, ADMIN_LEVEL_2)) return SendNotAdmin(playerid);

	SCM(playerid, COLOR_WHITE, "TELE-CMD: {C3C3C3}/atp /maketele /makehouseint /removetele");
	return 1;
}

ALTX:makehouseint("/mhouseint");
CMD:makehouseint(playerid, params[])
{
	if (!CheckAdmin(playerid, ADMIN_LEVEL_2)) return SendNotAdmin(playerid);

	new mapname[32],
		type;

	if (sscanf(params,"is[32]", type, mapname))
		return SendHelpMessage(playerid, "/makehouseint [Loai: 1-nho, 2-vua, 3-to] [Ten int]");

	if (type < 1 || type > 3)
	    return SendErrorMessage(playerid, "Loai: 1-nho, 2-vua, 3-to.");

    if (strlen(mapname) < 1 || strlen(mapname) > 32)
	    return SendErrorMessage(playerid, "Ky tu 1-32.");

	new id = -1;
	for(new i = 0; i < MAX_ADMIN_TELES; i++)
	{
	    if (0 != AdminTeles[i][telesOn])
			continue;

		id = i;
		break;
	}

	if (id == -1)
	    return SendErrorMessage(playerid, "Da dat den gioi han dich chuyen.");

	GetPlayerPos(playerid, AdminTeles[id][telesPosX], AdminTeles[id][telesPosY], AdminTeles[id][telesPosZ]);
	AdminTeles[id][telesInt] = GetInterior(playerid);
	AdminTeles[id][telesType] = type-1;
	format(AdminTeles[id][telesMapName], 32, "%s", mapname);
    AdminTeles[id][telesOn] = 1;
    
	AddTeleToFile(playerid, id, mapname, AdminTeles[id][telesInt], AdminTeles[id][telesPosX], AdminTeles[id][telesPosY], AdminTeles[id][telesPosZ], type-1);
 	SendClientMessageEx(playerid,COLOR_GREEN,"New interior (%s) ID: %i da duoc tao.", AdminTeles[id][telesMapName], id);
	return 1;
}

CMD:delplayertickets(playerid, params[])
{
	new userid;

	if (!CheckAdmin(playerid, ADMIN_LEVEL_2))	return SendNotAdmin(playerid);
	if (sscanf(params,"u", userid))				return SendHelpMessage(playerid, "/delplayertickets [ID/Ten]");
	if (!IsPlayerLogged(userid))				return SendNotConnected(playerid);

	DeletePlayerTickets(userid);

	SendAdmMessageToPlayer(playerid, "Da xoa tat ca cac ve phat cua nguoi choi - %s.", GetNameEx(userid));
	SendAdmMessageToPlayer(userid, "Administrator %s da xoa cac khoan ve phat cua ban.", GetAccName(playerid));
	
	return 1;
}

CMD:delvehtickets(playerid, params[])
{
	new vehid;

	if (!CheckAdmin(playerid, ADMIN_LEVEL_2))	return SendNotAdmin(playerid);
	if (sscanf(params,"i", vehid))				return SendHelpMessage(playerid, "/delvehtickets [Vehicle ID]");
	
	DeleteVehicleTickets(vehid);

	SendAdmMessageToPlayer(playerid, "Ban da xoa tat ca cac ve phat cua phuong tien - %s [ID:%i].", VehicleNames[VehicleInfo[vehid][carModel]-400], vehid);

	return 1;
}

CMD:aunimpound(playerid, params[])
{
	new vehicle;

	if (!CheckAdmin(playerid, ADMIN_LEVEL_2))	return SendNotAdmin(playerid);
	if (sscanf(params,"i", vehicle))			return SendHelpMessage(playerid, "/aunimpound [Vehicle ID]");

	if (!IsValidVehicle(vehicle))			return SendErrorMessage(playerid, "Phuong tien khong duoc tao ra.");
	if (!VehicleInfo[vehicle][Impounded])	return SendErrorMessage(playerid, "Phuong tien chua bi tich thu.");

	VehicleInfo[vehicle][Impounded] = 0;
	Save_Car(vehicle);

	SendAdmMessageToPlayer(playerid, "Vehicle [ID %i], Chu so huu - %s, Khong con bi tich thu.", vehicle, GetNameEx(VehicleInfo[vehicle][carOwnerID]));
	SendAdmMessageToPlayer(VehicleInfo[vehicle][carOwnerID], "Administrator %s da tha phuong tien cua ban %s.", GetAccName(playerid), VehicleNames[VehicleInfo[vehicle][carModel]-400]);
	return 1;
}

ALTX:makebizint("/mbizint");
CMD:makebizint(playerid, params[])
{
	if (!CheckAdmin(playerid, ADMIN_LEVEL_2)) return SendNotAdmin(playerid);

	new mapname[32];

	if (sscanf(params,"s[32]", mapname))
		return SendHelpMessage(playerid, "/makebizint [Name int]");

	if (strlen(mapname) < 1 || strlen(mapname) > 32)
	    return SendErrorMessage(playerid, "Ky tu 1-32.");

	new id = -1;
	for(new i = 0; i < MAX_ADMIN_TELES; i++)
	{
	    if (0 != AdminTeles[i][telesOn])
			continue;

		id = i;
		break;
	}

	if (id == -1)
	    return SendErrorMessage(playerid, "Da dat den gioi han dich chuyen.");

	GetPlayerPos(playerid, AdminTeles[id][telesPosX], AdminTeles[id][telesPosY], AdminTeles[id][telesPosZ]);
	AdminTeles[id][telesInt] = GetInterior(playerid);
	AdminTeles[id][telesType] = BUSSINESS_INT_TYPE;
	format(AdminTeles[id][telesMapName], 32, "%s", mapname);
    AdminTeles[id][telesOn] = 1;

	AddTeleToFile(playerid, id, mapname, AdminTeles[id][telesInt], AdminTeles[id][telesPosX], AdminTeles[id][telesPosY], AdminTeles[id][telesPosZ], 4);
 	SendClientMessageEx(playerid,COLOR_GREEN,"New interior (%s) ID: %i da duoc tao.", AdminTeles[id][telesMapName], id); //����� ���
	return 1;
}

ALTX:maketele("/mtele");
CMD:maketele(playerid, params[])
{
	if (!CheckAdmin(playerid, ADMIN_LEVEL_2))	return SendNotAdmin(playerid);
	new mapname[32];

	if (sscanf(params,"s[32]", mapname))				return SendHelpMessage(playerid, "/maketele [Name int]");
	if (strlen(mapname) < 1 || strlen(mapname) > 32)	return SendErrorMessage(playerid, "Ky tu 1-32.");

	new id = -1;

	for(new i = 0; i < MAX_INTERIORS; i++)
	{
	    if (AdminTeles[i][telesOn]) continue;

		id = i;
		break;
	}

	if (id == -1)	 return SendErrorMessage(playerid, "Da dat den gioi han dich chuyen.");

	format(AdminTeles[id][telesMapName], 32, "%s", mapname);
	GetPlayerPos(playerid, AdminTeles[id][telesPosX], AdminTeles[id][telesPosY], AdminTeles[id][telesPosZ]);
	AdminTeles[id][telesInt] = GetInterior(playerid);
	AdminTeles[id][telesType] = 3;
	AdminTeles[id][telesOn] = 1;

	AddTeleToFile(playerid, id, mapname, AdminTeles[id][telesInt], AdminTeles[id][telesPosX], AdminTeles[id][telesPosY], AdminTeles[id][telesPosZ], 3);
 	SendAdmMessageToPlayer(playerid, "New teleport (%s) ID: %i da duoc tao.", AdminTeles[id][telesMapName], id);
	return 1;
}

ALTX:removetele("/rtele");
CMD:removetele(playerid,params[])
{
	new teleid;
	if (!CheckAdmin(playerid, ADMIN_LEVEL_2)) return SendNotAdmin(playerid);

	if (sscanf(params,"d",teleid))
		return SendHelpMessage(playerid, "/removetele [ID Teleport]");

	if (AdminTeles[teleid][telesOn] == 0)
	    return SendErrorMessage(playerid, "ID Teleport khong tim thay.");

    new query[128];
	mysql_format(dbHandle, query, sizeof(query), "DELETE FROM `ateles` WHERE `id` = %i", AdminTeles[teleid][aID]);
	mysql_tquery(dbHandle, query);

	SendAdmMessageToPlayer(playerid, "Ban da xoa teleport ID %i.", teleid);
	
	AdminTeles[teleid][telesOn] = 0;
	AdminTeles[teleid][telesType] = 0;
	return 1;
}

CMD:aveh(playerid, params[])
{
	if (!CheckAdmin(playerid, ADMIN_LEVEL_2)) return SendNotAdmin(playerid);

	new model, color1, color2, Float:x, Float:y, Float:z, Float:a, Float: distance = 5.0;

	if (sscanf(params, "iI(0)I(0)", model, color1, color2))								return SendHelpMessage(playerid, "/aveh [model] {c7c7c7}[color1] [color2]");
	if (model == 520 || model == 425 || model == 432 || model == 447 || model == 476)	return SendErrorMessage(playerid, "Loai phuong tien nay duoc cam tren may chu.");
	if (model < 400 || model > 611) 													return SendErrorMessage(playerid, "Model tu 400 den 611.");
	if (color1 > 255 || color1 < 0 || color2 > 255 || color2 < 0)						return SendErrorMessage(playerid, "Mau: tu 0 den 255.");

	GetPlayerPos(playerid, x, y ,z);
	GetPlayerFacingAngle(playerid, a);
  	x += (distance * floatsin(-a, degrees));
    y += (distance * floatcos(-a, degrees));
	a += 90.0;

	if (a > 360.0) a -= 360.0;

	
	new vehicle = AddStaticVehicleEx(model, x,y,z,a, color1, color2, -1);

	if (vehicle == INVALID_VEHICLE_ID)	return SendErrorMessage(playerid, "Phuong tien khong duoc tao ra.");

	SetVehicleHealth(vehicle, 1000.0);
	SetVehicleNumberPlate(vehicle, GetVehicleNumber());
	SetVehicleVirtualWorld(vehicle, GetWorld(playerid));
	LinkVehicleToInterior(vehicle, GetInterior(playerid));
	SendAdmMessageToPlayer(playerid, "Ban da tao %s [ID: %i | MODEL: %i].", VehicleNames[model-400], vehicle, model);
	return 1;
}

CMD:makemark(playerid, params[])
{
	new Float:x, Float:y, Float:z, interior, world;

	if (!CheckAdmin(playerid, ADMIN_LEVEL_2)) return SendNotAdmin(playerid);
	
	interior = GetInterior(playerid);
	world = GetWorld(playerid);
	GetPlayerPos(playerid, x, y, z);
	SetPVarInt(playerid, "MarkedSpot", 1);
	SetPVarFloat(playerid, "MarkX", x);
	SetPVarFloat(playerid, "MarkY", y);
	SetPVarFloat(playerid, "MarkZ", z);
	SetPVarInt(playerid, "MarkInterior", interior);
	SetPVarInt(playerid, "MarkWorld", world);
	SendAdmMessageToPlayer(playerid, "Da cai dat diem, \"/gotomark\" de dich chuyen.");
	return 1;
}

CMD:gotomark(playerid, params[])
{
	if (!CheckAdmin(playerid, ADMIN_LEVEL_2)) 		return SendNotAdmin(playerid);
	if (GetPVarInt(playerid, "MarkedSpot") == 0) 	return SendErrorMessage(playerid, "Diem chua duoc dat, su dung \"/mark\".");
	
	SetPlayerPosEx(playerid, GetPVarFloat(playerid, "MarkX"), GetPVarFloat(playerid, "MarkY"), GetPVarFloat(playerid, "MarkZ"));
	SetWorld(playerid, GetPVarInt(playerid, "MarkWorld"));
	SetInterior(playerid, GetPVarInt(playerid, "MarkInterior"));
	SCM(playerid, COLOR_GREY, "* Ban da dich chuyen.");
	return 1;
}

CMD:settime(playerid, params[])
{
	new time;

	if (!CheckAdmin(playerid, ADMIN_LEVEL_2))	return SendNotAdmin(playerid);
	if (sscanf(params, "d", time))				return SendHelpMessage(playerid, "/settime [time (0-23)");
	if (time < 0 || time > 23)					return SendErrorMessage(playerid, "Thoi gian tu 0 den 23.");

	SetWorldTime(time);
	SAMALL("%s da thiet lap thoi gian thanh %i:00.", GetAccName(playerid), time);
	return 1;
}
CMD:weather(playerid, params[])
{
	new weather;

	if (!CheckAdmin(playerid, ADMIN_LEVEL_2))	return SendNotAdmin(playerid);
	if (sscanf(params, "d", weather))			return SendHelpMessage(playerid, "/weather [weather]");
	if (weather < 0 || weather > 45)				return SendErrorMessage(playerid, "Thoi tiet tu 0 den 45.");

	SetPlayerWeather(playerid, weather);
	return 1;
}

CMD:weatherall(playerid, params[])
{
	new weather;

	if (!CheckAdmin(playerid, ADMIN_LEVEL_2)) 	return SendNotAdmin(playerid);
	if (sscanf(params, "d", weather))			return SendHelpMessage(playerid, "/weatherall [weather]");
	if (weather < 0||weather > 45)				return SendErrorMessage(playerid, "hoi tiet tu 0 den 45.");

    server_weather = weather;
	SetWeather(server_weather);

	SAMALL("%s da thiet lap thoi tiet chung thanh [ID %i].", GetAccName(playerid), weather);
	return 1;
}

CMD:govw(playerid, params[])
{
	new vw;
	
	if (!CheckAdmin(playerid, ADMIN_LEVEL_2)) 	return SendNotAdmin(playerid);
	if (sscanf(params, "i", vw))				return SendHelpMessage(playerid, "/govw [virtual world (0-65535)]");
	if (vw < 0 || vw > 65535)					return SendErrorMessage(playerid, "Virtual world tu 0 den 65535.");

	SetWorld(playerid, vw);
	SendSyntaxMessage(playerid, "Ban da thay doi VW cua ban thanh %i VW.", vw);
	return 1;
}

CMD:goint(playerid, params[])
{
	new interior;
	
	if (!CheckAdmin(playerid, ADMIN_LEVEL_2))	return SendNotAdmin(playerid);
	if (sscanf(params, "i", interior)) 			return SendHelpMessage(playerid, "/goint [interior (0-255)]");
	if (interior < 0 || interior > 255)			return SendErrorMessage(playerid, "Interior tu 0 den 255.");

	SetInterior(playerid, interior);
	SendSyntaxMessage(playerid, "Ban da thay doi interior cua ban thanh %i.", interior);
	return 1;
}

CMD:go(playerid, params[])
{
	new Float:x, Float:y, Float:z, interior, vw;
	
	if (!CheckAdmin(playerid, ADMIN_LEVEL_2)) 				 return SendNotAdmin(playerid);
	if (sscanf(params,"fffI(0)I(0)", x, y ,z, interior, vw)) return SendHelpMessage(playerid, "/go [x] [y] [z] {c7c7c7}[interior (0-255)] [vw (0-65535)]");
	if (interior < 0 || interior > 255)						 return SendErrorMessage(playerid, "Interior tu 0 den 255.");
	if (vw < 0 || vw > 65535)								 return SendErrorMessage(playerid, "VW tu 0 den 65535.");

	SetPlayerPosEx(playerid, x, y, z);
	SetInterior(playerid, interior);
 	SetWorld(playerid, vw);
	return 1;
}

CMD:x(playerid, params[])
{
	new Float: coord;

	if (!CheckAdmin(playerid, ADMIN_LEVEL_2))	return SendNotAdmin(playerid);
	if (sscanf(params,"f", coord))				return SendHelpMessage(playerid, "/x [+x coordinate]");

	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	SetPlayerPosEx(playerid, x + coord, y, z);
	return 1;
}

CMD:y(playerid, params[])
{
	new Float: coord;

	if (!CheckAdmin(playerid, ADMIN_LEVEL_2))	return SendNotAdmin(playerid);
	if (sscanf(params,"f", coord))				return SendHelpMessage(playerid, "/y [+y coordinate]");

	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	SetPlayerPosEx(playerid, x, y + coord, z);
	return 1;
}

CMD:z(playerid, params[])
{
	new Float: coord;

	if (!CheckAdmin(playerid, ADMIN_LEVEL_2))	return SendNotAdmin(playerid);
	if (sscanf(params,"f", coord))				return SendHelpMessage(playerid, "/z  [+z coordinate]");

	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	SetPlayerPosEx(playerid, x, y, z + coord);
	return 1;
}

CMD:noooc(playerid, params[])
{
	if (!CheckAdmin(playerid, ADMIN_LEVEL_2)) return SendNotAdmin(playerid);

	noooc = !noooc;
	if (noooc == false) SCMALL(COLOR_GRAD2, "OOC chat da duoc bat boi Admin.");
	else				SCMALL(COLOR_GRAD2, "OOC chat da duoc tat boi Admin.");
	return 1;
}