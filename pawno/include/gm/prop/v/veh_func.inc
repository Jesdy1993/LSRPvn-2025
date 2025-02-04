this::LoadDynamicCars()
{
	new rows = cache_num_rows(), time = GetTickCount(), total;

    new sqlid, model, color1, color2, faction, Float:x, Float:y, Float:z, Float:a, type, plate[24], vw, interior;

	if (!rows)
	{
	    print("[Cars] Khong co du lieu duoc tim thay.");
	    return 1;
	}

	for(new i; i < rows; i++)
	{
		sqlid = cache_get_field_content_int(i, "id", dbHandle);
		model = cache_get_field_content_int(i, "model", dbHandle);
		x = cache_get_field_content_float(i, "x", dbHandle);
		y = cache_get_field_content_float(i, "y", dbHandle);
		z = cache_get_field_content_float(i, "z", dbHandle);
		a = cache_get_field_content_float(i, "fa", dbHandle);
		color1 = cache_get_field_content_int(i, "color1", dbHandle);
		color2 = cache_get_field_content_int(i, "color2", dbHandle);
		type = cache_get_field_content_int(i, "type", dbHandle);
		faction = cache_get_field_content_int(i, "faction", dbHandle);
		cache_get_field_content(i, "plate", plate, dbHandle, 24);
		interior = cache_get_field_content_int(i, "int", dbHandle);
		vw = cache_get_field_content_int(i, "vw", dbHandle);

		CreateFactionVehicle(false, model, x, y, z, a, color1, color2, type, faction, plate, vw, interior, sqlid);

		SetVehicleVirtualWorldEx(i, vw);
		SetVehicleInteriorEx(i, interior);

		total++;
	}
    printf("[Cars] Rows - %i. Load - %i. Time: %i ms.", rows, total, GetTickCount()-time);
	return 1;
}

this::OnVehicleInsert(vehicleid)
{
    VehicleInfo[vehicleid][carID]= cache_insert_id();
	return 1;
}

this::BuyVehicleForPlayer(playerid)
{
    new Float:x, Float:y, Float:z, Float:fa, model = GetPVarInt(playerid, "BuyingVehicleModel"), plate[24], dealer = -1;

	if (IsABoatModel(model) && (dealer = DealerShip_Nearest(playerid, BIZ_BOATSALON)) == -1)							return SendErrorMessage(playerid, "Ban nen o gan phong trung bay thuyen. ");
    if (IsAPlaneModel(model) && (dealer = DealerShip_Nearest(playerid, BIZ_FLYSALON)) == -1)							return SendErrorMessage(playerid, "Ban phai o gan mot dai ly may bay. ");
	if (!IsABoatModel(model) && !IsAPlaneModel(model) && (dealer = DealerShip_Nearest(playerid, BIZ_AUTOSALON)) == -1)	return SendErrorMessage(playerid, "Ban nen o gan dai ly o to.");
	if (cache_num_rows() >= GetMaxPlayerCars(playerid))																	return SendErrorMessage(playerid,"Ban da mua so luong xe toi da.");

    new registerveh = price_reg[GetPVarInt(playerid, "BuyingVehicleRegister")], 
		alarmveh = price_alarm[GetPVarInt(playerid, "BuyingVehicleAlarm")], 
		lockveh = price_lock[GetPVarInt(playerid, "BuyingVehicleLock")],
		immobveh = price_immob[GetPVarInt(playerid, "BuyingVehicleImmob")], 
		insuranceveh = GetInsurancePrice(GetPVarInt(playerid, "BuyingVehicleModel")) * GetPVarInt(playerid, "BuyingVehicleInsurance"),
		xmradioveh = price_radio[GetPVarInt(playerid, "BuyingVehicleRadio")], 
		gpsveh = price_gps[GetPVarInt(playerid, "BuyingVehicleGps")], 
		color1 = GetPVarInt(playerid, #veh_color1),
		color2 = GetPVarInt(playerid, #veh_color2);

	if (!PlayerInfo[playerid][pPremium] && IsDonateVehicle(model))		 return SendErrorMessage(playerid, "Chi nguoi choi co tai khoan tra phi moi co the mua chiec xe nay. ");
	if (PlayerInfo[playerid][pPremium] < 1 && IsBronzeVehicle(model))	 return SendErrorMessage(playerid, "De mua phuong tien nay, tai khoan cua ban phai dat Bronze Premium tro len. ");
	if (PlayerInfo[playerid][pPremium] < 2 && IsSilverVehicle(model))	 return SendErrorMessage(playerid, "De mua phuong tien nay, tai khoan cua ban phai dat Sliver Premium tro len. ");
	if (PlayerInfo[playerid][pPremium] < 3 && IsGoldVehicle(model))		 return SendErrorMessage(playerid, "De mua phuong tien nay, tai khoan cua ban phai dat Gold Premium. ");
	if (BizInfo[dealer][bizOwnerID] != 0 && !BizInfo[dealer][bizProduct]) return SendErrorMessage(playerid, "Khong co xe ban trong doanh nghiep. ");
	    
	new price = GetVehiclePrice(model)+registerveh+alarmveh+lockveh+immobveh+insuranceveh+xmradioveh+gpsveh;

	if (GetCash(playerid) < price)	return SendNotCash(playerid);

	SendSyntaxMessage(playerid, "Ban da mua %s voi gia $%i.", VehicleNames[model-400], price);
	SendHelpMessage(playerid, "Su dung /(v)ehicle de quan ly phuong tien cua ban. ");

	new money = PlayerInfo[playerid][pCash];
	
	GiveCash(playerid, -price);
	
	if (BizInfo[dealer][bizOwnerID] != 0)
	{
	    BizInfo[dealer][bizProduct]--;
		GiveBizCash(dealer, price);
	}
	
    new query[256];
	format(query, sizeof(query), "%s [MYSQL: %i | IP: %s | Money(WAS): %i | Money(BECOME): %i] mua phuong tien %s (Model: %i) voi gia -- $%i", GetName(playerid), PlayerInfo[playerid][pID], q_GetPlayerIP(playerid), money, GetCash(playerid), 
	VehicleNames[model-400], model, price);
    insert_log(query, VEHICLE_LOG, 1, PlayerInfo[playerid][pAccID]);

	if (IsABoatModel(model)) 
	{
		if (!BizInfo[dealer][bizSpawn][0] && !BizInfo[dealer][bizSpawn][1] && !BizInfo[dealer][bizSpawn][2]) 
		{
			x = 114.9191;
			y = -1902.8209;
			z = -0.6980;
			fa = 0.0;
		}
		else 
		{
			x = BizInfo[dealer][bizSpawn][0];
			y = BizInfo[dealer][bizSpawn][1]; 
			z = BizInfo[dealer][bizSpawn][2]; 
			fa = BizInfo[dealer][bizSpawn][3];
		}
	} 
	else if (IsAPlaneModel(model)) 
	{
		if (!BizInfo[dealer][bizSpawn][0] && !BizInfo[dealer][bizSpawn][1] && !BizInfo[dealer][bizSpawn][2]) 
		{
			x = 1943.5498;
			y = -2397.6553;
			z = 14.70;
			fa = 0.0;
		} 
		else {
			x = BizInfo[dealer][bizSpawn][0];
			y = BizInfo[dealer][bizSpawn][1]; 
			z = BizInfo[dealer][bizSpawn][3];
		}
	} else {
		if (!BizInfo[dealer][bizSpawn][0] && !BizInfo[dealer][bizSpawn][1] && !BizInfo[dealer][bizSpawn][2]) {
			x = 2062.0862;
			y = -1920.4977;
			z = 13.5469;
			fa = 180.6192;
		} else {
			x = BizInfo[dealer][bizSpawn][0];
			y = BizInfo[dealer][bizSpawn][1]; 
			z = BizInfo[dealer][bizSpawn][2]; 
			fa = BizInfo[dealer][bizSpawn][3];
		}
	}							
	

	if (!GetPVarInt(playerid, "BuyingVehicleRegister"))	format(plate, 24, "_");
	else												format(plate, 24, "%s", GetVehicleNumber());

	mysql_format(dbHandle, query, sizeof(query), "INSERT INTO `cars` (date,model,color1,color2,x,y,z,fa,plate,owner,registered,alarm,locks,immob,insurances,radio,gps,health,fuel) VALUES ('%s',%i,%i,%i,%.1f,%.1f,%.1f,%.1f,'%s',%i,%i,%i,%i,%i,%i,%i,%i,%.1f,%.1f)",
	GetFullDate(), model, color1, color2, x, y, z, fa, plate, PlayerInfo[playerid][pID], GetPVarInt(playerid, "BuyingVehicleRegister"), GetPVarInt(playerid, "BuyingVehicleAlarm"), GetPVarInt(playerid, "BuyingVehicleLock"),
	GetPVarInt(playerid, "BuyingVehicleImmob"), GetPVarInt(playerid, "BuyingVehicleInsurance"), GetPVarInt(playerid, "BuyingVehicleRadio"), GetPVarInt(playerid, "BuyingVehicleGps"), GetVehicleMaxHealth(model), GetVehicleFuelCapacity(model)/2);
	mysql_tquery(dbHandle, query);
	return 1;
}

this::BuyVehicleAtPlayer(playerid)
{
	if (pTemp[playerid][pCarPlayer] == INVALID_PLAYER_ID)	return 1;

	new userid = pTemp[playerid][pCarPlayer], price = pTemp[playerid][pCarPrice], vehicle = PlayerInfo[userid][pCarKey];

    pTemp[playerid][pCarPlayer] = INVALID_PLAYER_ID;
    pTemp[playerid][pCarPrice] = 0;

    if (cache_num_rows() >= GetMaxPlayerCars(playerid))									return SendErrorMessage(playerid, "Ban da mua so luong xe toi da. ");
    if (!IsPlayerLogged(userid))														return SendNotConnected(playerid);
	if (!IsValidVehicle(vehicle))														return SendErrorMessage(playerid, "Xe cua nguoi ban khong duoc tao ra. ");
	if (!IsPlayerInVehicle(userid, vehicle))											return SendNotInVehicle(userid);
	if (IsADonateModel(GetVehicleModel(vehicle)))										return SendErrorMessage(userid, "Ban khong the ban xe duoc tang cho nguoi choi. ");
    if (PlayerInfo[userid][pPremium] < 2 && VehicleInfo[vehicle][carComponent][5] != 0)	return SendErrorMessage(playerid, "Nguoi choi khong co quyen truy cap nitro.");
	if (userid == playerid)																return 1;
	if (!IsABicycle(vehicle) && !VehicleInfo[vehicle][carRegistered])					return SendErrorMessage(playerid, "Phuong tien khong duoc dang ky. ");
	if (!PlayerNearPlayer(3.0, playerid, userid))										return SendNotNearPlayer(playerid);
	if (IsValidVehicle(PlayerInfo[playerid][pCarKey]))									return SendErrorMessage(playerid, "Ban da tao ra chiec xe cua minh. ");

    if (GetCash(playerid) < price)
    {
        SendErrorMessage(playerid, "Ban khong co du tien de mua chiec xe nay. ");
		SendErrorMessage(userid, "Ban khong the ban xe cua minh cho nguoi choi nay vi anh ta khong co du tien.");
		return 1;
    }

	new money1 = PlayerInfo[userid][pCash], money2 = PlayerInfo[playerid][pCash];

	SendSyntaxMessage(playerid, "Ban da mua %s tu %s voi gia $%i.", VehicleNames[GetVehicleModel(vehicle)-400],  GetNameWithMask(userid), price);
	SendSyntaxMessage(userid, "Ban da ban %s cho %s voi gia $%i.", VehicleNames[GetVehicleModel(vehicle)-400], GetNameWithMask(playerid), price);

	GiveCash(userid, price);
	GiveCash(playerid, -price);
	VehicleInfo[vehicle][carOwnerID] = PlayerInfo[playerid][pID];
	VehicleInfo[vehicle][carOwnerPlayer] = playerid;
	PlayerInfo[playerid][pCarKey] = vehicle;
	PlayerInfo[userid][pCarKey] = 0;
	format(VehicleInfo[vehicle][carOwner], 24, GetNameEx(playerid));

	new query[256];
	format(query, sizeof(query), "%s [MYSQL: %i | IP: %s | Money(WAS): %i | Money(BECOME): %i] mua %s(Model: %i) tu nguoi choi %s [MYSQL: %i | IP: %s | Money(WAS): %i | Money(BECOME): %i] voi gia -- $%i",
	GetName(playerid), PlayerInfo[playerid][pID], q_GetPlayerIP(playerid), money1, GetCash(playerid), VehicleNames[GetVehicleModel(vehicle)-400], GetVehicleModel(vehicle), GetName(userid), PlayerInfo[userid][pID], q_GetPlayerIP(userid), 
	money2, GetCash(userid), price);
    insert_log(query, VEHICLE_LOG, 2, PlayerInfo[playerid][pAccID]);

	format(query, sizeof(query), "%s [MYSQL: %i | IP: %s | Money(WAS): %i | Money(BECOME): %i] ban %s(Model: %i) cho nguoi choi %s [MYSQL: %i | IP: %s | Money(WAS): %i | Money(BECOME): %i] voi gia -- $%i",
	GetName(userid), PlayerInfo[userid][pID], q_GetPlayerIP(userid), money2, GetCash(userid), VehicleNames[GetVehicleModel(vehicle)-400], GetVehicleModel(vehicle), GetName(playerid), PlayerInfo[playerid][pID], q_GetPlayerIP(playerid),
	money1, GetCash(playerid), price);
 	insert_log(query, VEHICLE_LOG, 4, PlayerInfo[playerid][pAccID]);

	mysql_format(dbHandle,query, sizeof(query), "UPDATE `cars` SET `owner` = %i WHERE `id` = %i", VehicleInfo[vehicle][carOwnerID], VehicleInfo[vehicle][carID]);
	mysql_tquery(dbHandle, query);
	return 1;
}

this::ShowListVeh(playerid)
{
	if (!cache_num_rows())	return SendErrorMessage(playerid, "Ban khong so huu phuong tien.");
	
	new 
		dlgmes[6*128] = "#\tBien so\tPhuong tien\tTrang thai\n",
		model,
		impound,
		jacking,
		id,
		plate[24],
		status[64]
	;
	
	for(new i; i < cache_num_rows(); i++)
	{
		model = cache_get_field_content_int(i, "model", dbHandle);
		impound = cache_get_field_content_int(i, "impound", dbHandle);
		jacking = cache_get_field_content_int(i, "jacking", dbHandle);
		id = cache_get_field_content_int(i, "id", dbHandle);

		cache_get_field_content(i, "plate", plate, dbHandle, 24);
		if (isempty(plate))	format(plate, sizeof(plate), "-");

		if (impound == 1) format(status, sizeof(status), ""EMBED_RED"Tai mot bai dau xe phat{FFFFFF}");
		else {
			if (jacking == 1) format(status, sizeof(status), ""EMBED_RED"Bi xam nhap (Nhap de doi qua){FFFFFF}");
			else {
				if (IsValidVehicle(PlayerInfo[playerid][pCarKey]) && VehicleInfo[PlayerInfo[playerid][pCarKey]][carID] == id) {
					pTemp[playerid][MyCarSpawn][i] = 1;
					format(status, sizeof(status), "{FFFF00}Da tao ra{FFFFFF}");
				} else {
					pTemp[playerid][MyCarSpawn][i] = 0;
					format(status, sizeof(status), "Chua tao ra");
				}		
			}
		}

		pTemp[playerid][MyCars][i] = id;
		
		format(dlgmes, sizeof(dlgmes), "%s{FFFFFF}%i\t%s\t%s\t%s\n", dlgmes, i+1, plate, VehicleNames[model-400], status);
	}

	Dialog_Show(playerid, MyCars, DIALOG_STYLE_TABLIST_HEADERS, "Phuong tien cua toi", dlgmes, "Chon", "Huy bo");
	return 1;
}

this::ShowCarsForPlayer(playerid, targetid)
{
	if (!cache_num_rows())	return SendErrorMessage(playerid, "Ban khong so huu phuong tien.");

	new hour, minute, second, model, _alarm, lock, immob, insurance, destroyed, plate[24], vehicle = PlayerInfo[targetid][pCarKey];
	
	gettime(hour, minute, second);

	SendClientMessageEx(playerid, COLOR_GREEN, "____________________[Danh sach phuong tien cua %s, %02d:%02d:%02d]____________________", GetNameEx(targetid), hour, minute, second);

	new count = 0;

	for(new i; i < cache_num_rows(); i++)
	{
	    model = cache_get_field_content_int(i, "model");
		_alarm = cache_get_field_content_int(i, "alarm");
	    lock = cache_get_field_content_int(i, "locks");
	    immob = cache_get_field_content_int(i, "immob");
	    insurance = cache_get_field_content_int(i, "insurances");
	    destroyed = cache_get_field_content_int(i, "destroys");

		cache_get_field_content(0, "plate", plate, dbHandle, 24);

		if (strfind(plate, "_") != -1)	format(plate, sizeof(plate), "[%s]", plate);
		else			 				format(plate, sizeof(plate), "[KHONG BIEN SO]");

	    if (VehicleInfo[vehicle][carID] == cache_get_field_content_int(i, "id"))
	    {
			if (destroyed)	SendClientMessageEx(playerid, COLOR_GREEN, "Vi tri %i: %s%s[ID: %i], Bao dong[%i], Khoa[%i], Immobilizer[%i], Bao hiem[%i], Bi pha huy[%i / 5]", i+1, VehicleNames[model-400], plate, vehicle, VehicleInfo[vehicle][carAlarm], VehicleInfo[vehicle][carLock], VehicleInfo[vehicle][carImmob], VehicleInfo[vehicle][carInsurance], VehicleInfo[vehicle][carDestroyed]);
			else			SendClientMessageEx(playerid, COLOR_GREEN, "Vi tri %i: %s%s[ID: %i], Bao dong[%i], Khoa[%i], Immobilizer[%i], Bao hiem[%i]", i+1, VehicleNames[model-400], plate, vehicle, VehicleInfo[vehicle][carAlarm], VehicleInfo[vehicle][carLock], VehicleInfo[vehicle][carImmob], VehicleInfo[vehicle][carInsurance]);
		}
		else
		{
		    if (destroyed)	SendClientMessageEx(playerid, COLOR_WHITE, "Vi tri %i: %s%s, Bao dong[%i], Khoa[%i], Immobilizer[%i], Bao hiem[%i], Bi pha huy[%i / 5]", i+1, VehicleNames[model-400], plate, _alarm, lock, immob, insurance, destroyed);
			else			SendClientMessageEx(playerid, COLOR_WHITE, "Vi tri %i: %s%s, Bao dong[%i], Khoa[%i], Immobilizer[%i], Bao hiem[%i]", i+1, VehicleNames[model-400], plate, _alarm, lock, immob, insurance);
		}
		count++;
	}

	if (count > 3) SendClientMessageEx(playerid, COLOR_GREEN, "____________________[Danh sach phuong tien cua %s, %02d:%02d:%02d]____________________", GetNameEx(targetid), hour, minute, second);
	
	return 1;
}

this::OnPlayerSpawnVehicle(playerid)
{
	if(!cache_get_row_count(dbHandle))
	{
	    SendWarningMessage(playerid, "Vi tri duoc chi dinh khong chua phuong tien hop le nao ma ban co the tao ra.");
	}
	else
	{
	    if(cache_get_field_content_int(0, "impound"))
		{
			return SendWarningMessage(playerid, "Xe cua ban da bi tich thu va dang bi tam giu. (/unimpound)");
		}
		if (cache_get_field_content_int(0, "jacking")) 
		{
			new mes[300];
			SetPVarInt(playerid, #RansomVehID, cache_get_field_content_int(0, "id"));
			SetPVarInt(playerid, #RansomVehModel, cache_get_field_content_int(0, "model"));

			format(mes, sizeof(mes), "Ban co thuc su muon doi %s cua minh\nvoi 50%% so voi gia goc khong?\n\nBan phai tra $%i\n\nNhan 'Tiep tuc' de chon: loai bo xe hoac doi\n{FF6347}TRONG TRUONG HOP NAY, PHUONG TIEN SE MAT MAI MAI!", VehicleNames[cache_get_field_content_int(0, "model")-400], floatround(GetVehiclePrice(cache_get_field_content_int(0, "model"))*0.5));
			return Dialog_Show(playerid, RansomVehicle, DIALOG_STYLE_MSGBOX, "Mua xe", mes, "Tiep tuc", "Huy bo");
		}

	    new
			modelid = cache_get_field_content_int(0, "model"),
			Float:x = cache_get_field_content_float(0, "x"),
			Float:y = cache_get_field_content_float(0, "y"),
			Float:z = cache_get_field_content_float(0, "z"),
			Float:a = cache_get_field_content_float(0, "fa"),
			color1 = cache_get_field_content_int(0, "color1"),
			color2 = cache_get_field_content_int(0, "color2"),
			vehicle,
			panels,
			doorss,
			lightss,
			tires;

		vehicle = CreateVehicle(modelid, x, y, z, a, color1, color2, -1);
		if(vehicle != INVALID_VEHICLE_ID)
		{
		    ResetVehicle(vehicle);

		    cache_get_field_content(0, "plate", VehicleInfo[vehicle][carPlate], dbHandle, 24);

		    VehicleInfo[vehicle][carID] 	= cache_get_field_content_int(0, "id");
			VehicleInfo[vehicle][carModel]	= cache_get_field_content_int(0, "model");	
			VehicleInfo[vehicle][carColor1] = cache_get_field_content_int(0, "color1");
			VehicleInfo[vehicle][carColor2]	= cache_get_field_content_int(0, "color2");
			VehicleInfo[vehicle][carParkX]	= cache_get_field_content_float(0, "x");
			VehicleInfo[vehicle][carParkY] 	= cache_get_field_content_float(0, "y");
			VehicleInfo[vehicle][carParkZ]	= cache_get_field_content_float(0, "z");
			VehicleInfo[vehicle][carParkA]	= cache_get_field_content_float(0, "fa");
			
			cache_get_field_content(0, "plate", VehicleInfo[vehicle][carPlate], dbHandle, 24);

			VehicleInfo[vehicle][carWanted]	= cache_get_field_content_int(0, "wanted");

			VehicleInfo[vehicle][carOwnerID] 		= cache_get_field_content_int(0, "owner");
			VehicleInfo[vehicle][carArmour]			= cache_get_field_content_int(0, "armour");
			VehicleInfo[vehicle][carAlarm]			= cache_get_field_content_int(0, "alarm");
			VehicleInfo[vehicle][carLock]			= cache_get_field_content_int(0, "locks");
			VehicleInfo[vehicle][carImmob]			= cache_get_field_content_int(0, "immob");
			VehicleInfo[vehicle][carInsurance]		= cache_get_field_content_int(0, "insurances");
			VehicleInfo[vehicle][carDestroyed]		= cache_get_field_content_int(0, "destroys");
			VehicleInfo[vehicle][Impounded]			= cache_get_field_content_int(0, "impound");
			VehicleInfo[vehicle][carGps]			= cache_get_field_content_int(0, "gps");
			VehicleInfo[vehicle][carFuel]			= cache_get_field_content_float(0, "fuel");
			VehicleInfo[vehicle][carRegistered]		= cache_get_field_content_int(0, "registered");
			VehicleInfo[vehicle][carBattery]		= cache_get_field_content_float(0, "battery");
			VehicleInfo[vehicle][carEngine]			= cache_get_field_content_float(0, "engine");
			VehicleInfo[vehicle][carType]			= 0;

			for(new i = 0; i < 14; i++)
			{
				new field_name[16];

				format(field_name, sizeof(field_name), "comp%i", i);
				VehicleInfo[vehicle][carComponent][i] = cache_get_field_content_int(0, field_name);	
				
			}
			for(new i = 0; i < MAX_TRUNK_INVENTORY; i++)
			{
				new field_name[16];
				format(field_name, sizeof(field_name), "attach%i_pos0", i);
				VehicleInfo[vehicle][carAttachPosX][i] = cache_get_field_content_float(0, field_name);
				format(field_name, sizeof(field_name), "attach%i_pos1", i);
				VehicleInfo[vehicle][carAttachPosY][i] = cache_get_field_content_float(0, field_name);
				format(field_name, sizeof(field_name), "attach%i_pos2", i);
				VehicleInfo[vehicle][carAttachPosZ][i] = cache_get_field_content_float(0, field_name);
				format(field_name, sizeof(field_name), "attach%i_rot0", i);
				VehicleInfo[vehicle][carAttachRotX][i] = cache_get_field_content_float(0, field_name);
				format(field_name, sizeof(field_name), "attach%i_rot1", i);
				VehicleInfo[vehicle][carAttachRotY][i] = cache_get_field_content_float(0, field_name);
				format(field_name, sizeof(field_name), "attach%i_rot2", i);
				VehicleInfo[vehicle][carAttachRotZ][i] = cache_get_field_content_float(0, field_name);
				format(field_name, sizeof(field_name), "arg_%i", i);
				VehicleInfo[vehicle][carAttachObj][i] = cache_get_field_content_int(0, field_name);
			}

			VehicleInfo[vehicle][carPaintJob] 			= cache_get_field_content_int(0, "paintjob");
			VehicleInfo[vehicle][carRadio]				= cache_get_field_content_int(0, "radio");
			VehicleInfo[vehicle][carComps]				= cache_get_field_content_int(0, "comps");
			VehicleInfo[vehicle][carHealth]				= cache_get_field_content_float(0, "health");
			panels 										= cache_get_field_content_int(0, "panels");
			doorss										= cache_get_field_content_int(0, "doors");
			lightss										= cache_get_field_content_int(0, "lights");
			tires 										= cache_get_field_content_int(0, "tires");
			VehicleInfo[vehicle][carMilliage]			= cache_get_field_content_float(0, "milliage");
			VehicleInfo[vehicle][carHidedPlate]			= cache_get_field_content_int(0, "hidednum");
			VehicleInfo[vehicle][carFakePlate]			= cache_get_field_content_int(0, "fakenum");

			cache_get_field_content(0, "fakenum_str", VehicleInfo[vehicle][carFakePlateS], dbHandle, 24);

			VehicleInfo[vehicle][carAttach3DtextUse] 	= 0;
			VehicleInfo[vehicle][carDriver] 			= INVALID_PLAYER_ID;
			format(VehicleInfo[vehicle][carOwner], 24, GetNameEx(playerid));
			format(VehicleInfo[vehicle][carPlate], 24, "%s", VehicleInfo[vehicle][carPlate]);


			new query[128];

			mysql_format(dbHandle, query, sizeof(query), "SELECT * FROM `inventory` WHERE `carid`=%i", VehicleInfo[vehicle][carID]);
			mysql_tquery(dbHandle, query, "C_LoadInventory", "i", vehicle);

			mysql_format(dbHandle, query, sizeof(query), "SELECT * FROM `inventory` WHERE `trunkid`=%i", VehicleInfo[vehicle][carID]);
			mysql_tquery(dbHandle, query, "T_LoadInventory", "i", vehicle);


			pTemp[playerid][pVehicleScreen] = 0;
			PlayerInfo[playerid][pCarKey] = vehicle;
			VehicleInfo[vehicle][carOwnerPlayer] = playerid;
			
			if (VehicleInfo[vehicle][carFakePlate])
			{
				SetVehicleNumberPlate(vehicle, VehicleInfo[vehicle][carFakePlateS]);
			}
			else
			{
				SetVehicleNumberPlate(vehicle, VehicleInfo[vehicle][carPlate]);
			}

			LoadComp(vehicle);

			if (VehicleInfo[vehicle][carInsurance] > 1)
			{
				UpdateVehicleDamageStatus(vehicle, 0, 0, 0, 0);
			}	
			else
			{
				UpdateVehicleDamageStatus(vehicle, panels, doorss, lightss, tires);
			}										

			if (VehicleInfo[vehicle][carInsurance] != 0)
			{
				SetVehicleHealth(vehicle, GetVehicleMaxHealth(GetVehicleModel(vehicle)) + VehicleInfo[vehicle][carArmour]);
			}	
			else
			{
				SetVehicleHealth(vehicle, VehicleInfo[vehicle][carHealth]);
			}
			
			ToggleVehicleLock(vehicle, true);
			SendClientMessageEx(playerid, COLOR_DARKGREEN, "> Ban da tao ra %s cua minh tai noi dau xe cuoi cung.", VehicleNames[cache_get_field_content_int(0, "model")-400]);
			
			SendClientMessageEx(playerid, COLOR_YELLOWG, "PHUONG TIEN:{FFFFFF} Dong co[%.2f], Ac quy[%.2f], Hoan toan bi pha huy[%d lan]", 
				VehicleInfo[vehicle][carEngine], 
				VehicleInfo[vehicle][carBattery], 
				VehicleInfo[vehicle][carDestroyed]);

			new count = CountVehicleTickets(vehicle);
			if (count)
			{
				SendWarningMessage(playerid, "Phuong tien cua ban co %i khoan tien phat chua nop.", count);
			}	

			if(!IsPlayerInRangeOfPoint(playerid, 5.0, VehicleInfo[vehicle][carParkX], VehicleInfo[vehicle][carParkY], VehicleInfo[vehicle][carParkZ]))
			{
				SendClientMessageEx(playerid, COLOR_LIGHTRED, "GOI Y:{FFFFFF} Di theo diem danh dau radar mau do de lay xe.");
				Waypoint_Set(playerid, VehicleInfo[vehicle][carParkX],VehicleInfo[vehicle][carParkY],VehicleInfo[vehicle][carParkZ]);
			}
			
			for(new i = 0; i < MAX_TRUNK_INVENTORY; i++)
			{
				if (VehicleInfo[vehicle][carAttachObj][i])
				{
					VehicleInfo[vehicle][carAttach][i] = CreateDynamicObject(VehicleInfo[vehicle][carAttachObj][i], VehicleInfo[vehicle][carAttachPosX][i],VehicleInfo[vehicle][carAttachPosY][i],VehicleInfo[vehicle][carAttachPosZ][i],VehicleInfo[vehicle][carAttachRotX][i],VehicleInfo[vehicle][carAttachRotY][i],VehicleInfo[vehicle][carAttachRotZ][i]);
					AttachDynamicObjectToVehicle(VehicleInfo[vehicle][carAttach][i], vehicle, VehicleInfo[vehicle][carAttachPosX][i],VehicleInfo[vehicle][carAttachPosY][i],VehicleInfo[vehicle][carAttachPosZ][i],VehicleInfo[vehicle][carAttachRotX][i],VehicleInfo[vehicle][carAttachRotY][i],VehicleInfo[vehicle][carAttachRotZ][i]);
				}
				else 
				{
					VehicleInfo[vehicle][carAttach][i] = INVALID_OBJECT_ID;
				}
			}

			status_update[vehicle] = CreateDynamic3DTextLabel("(( ---------- ))",0x33AA3300, 0.0, 0.0, 0.0, 20.0, INVALID_PLAYER_ID, vehicle, 0, -1, 0);
			
			CancelSelectTextDraw(playerid);
			DeletePVar(playerid, #spawnveh_id);

			PlayerTextDrawDestroy(playerid, VehSpawn[playerid][0]);
			PlayerTextDrawDestroy(playerid, VehSpawn[playerid][1]);
			PlayerTextDrawDestroy(playerid, VehSpawn[playerid][2]);
			PlayerTextDrawDestroy(playerid, VehSpawn[playerid][3]);
			PlayerTextDrawDestroy(playerid, VehSpawn[playerid][4]);
			PlayerTextDrawDestroy(playerid, VehSpawn[playerid][5]);
	    }
	}

	return 1;
}

this::C_LoadInventory(vehicle)
{
	if (!cache_num_rows())
	{
	    new query[128];
        mysql_format(dbHandle, query, sizeof(query), "INSERT INTO `inventory` (`carid`) VALUES (%i)", VehicleInfo[vehicle][carID]);
	    mysql_tquery(dbHandle, query);
	    return 1;
	}

	new str_inv[24];

	for(new a = 0; a < MAX_CAR_INVENTORY; a++)
	{
		format(str_inv, sizeof(str_inv), "id_%i", a+1);
		CarInventory[vehicle][a][pInvItem] = cache_get_field_content_int(0, str_inv);
		format(str_inv, sizeof(str_inv), "a_%i", a+1);
		CarInventory[vehicle][a][pInvQ] = cache_get_field_content_int(0, str_inv);
		format(str_inv, sizeof(str_inv), "ex_%i", a+1);
		CarInventory[vehicle][a][pInvEx] = cache_get_field_content_int(0, str_inv);
		format(str_inv, sizeof(str_inv), "s_%i", a+1);
		CarInventory[vehicle][a][pInvS] = cache_get_field_content_int(0, str_inv);
		format(str_inv, sizeof(str_inv), "f_%i", a+1);
		CarInventory[vehicle][a][pInvQFloat] = cache_get_field_content_float(0, str_inv);

		new name[16];
		format(str_inv, sizeof(str_inv), "n_%i", a+1);
		cache_get_field_content(0, str_inv, name);	
		
		format(CarInventory[vehicle][a][pInvName], 16, "%s", name);
	}
	return 1;
}

this::T_LoadInventory(vehicle)
{
	if (!cache_num_rows())
	{
	    new query[128];
        mysql_format(dbHandle, query, sizeof(query), "INSERT INTO `inventory` (`trunkid`) VALUES (%i)", VehicleInfo[vehicle][carID]);
	    mysql_tquery(dbHandle, query);
	    return 1;
	}

	new str_inv[24];

	for(new a = 0; a < MAX_TRUNK_INVENTORY; a++)
	{
		format(str_inv, sizeof(str_inv), "id_%i", a+1);
		TrunkInventory[vehicle][a][pInvItem] = cache_get_field_content_int(0, str_inv);
		format(str_inv, sizeof(str_inv), "a_%i", a+1);
		TrunkInventory[vehicle][a][pInvQ] = cache_get_field_content_int(0, str_inv);
		format(str_inv, sizeof(str_inv), "ex_%i", a+1);
		TrunkInventory[vehicle][a][pInvEx] = cache_get_field_content_int(0, str_inv);
		format(str_inv, sizeof(str_inv), "s_%i", a+1);
		TrunkInventory[vehicle][a][pInvS] = cache_get_field_content_int(0, str_inv);
		format(str_inv, sizeof(str_inv), "f_%i", a+1);
		TrunkInventory[vehicle][a][pInvQFloat] = cache_get_field_content_float(0, str_inv);

		new name[16];
		format(str_inv, sizeof(str_inv), "n_%i", a+1);
		cache_get_field_content(0, str_inv, name);	
		
		format(TrunkInventory[vehicle][a][pInvName], 16, "%s", name);
	}
	return 1;
}

ResetVehicle(vehicleid)
{
	new panels, doors, lights, tires;

	//if (IsABicycle(vehicleid))	return 1;
	    
	GetVehicleDamageStatus(vehicleid, panels, doors, lights, tires);
		
	foreach(new i : Player) {
		if (JackingVehicle[i] == vehicleid)
		{
			if (IsValidVehicle(JackingVehicle[i]))
			{
				new Float:ccX, Float:ccY, Float:ccZ;
				GetVehiclePos(JackingVehicle[i], ccX, ccY, ccZ);

				VehicleInfo[JackingVehicle[i]][ePhysicalAttack] = false;
				DestroyDynamic3DTextLabel(VehicleInfo[JackingVehicle[i]][eVehicleLabel]);
				VehicleInfo[JackingVehicle[i]][vCooldown] = false;
				JackingVehicle[i] = 0;
			}
		}
	}
	
	if (!VehicleInfo[vehicleid][carInsurance])
	{
		for(new i = 0; i < MAX_TRUNK_INVENTORY; i++)
		{
			TrunkInventory[vehicleid][i][pInvName] = EOS;
			TrunkInventory[vehicleid][i][pInvQFloat] = 0.0;
			TrunkInventory[vehicleid][i][pInvItem] =
			TrunkInventory[vehicleid][i][pInvQ] =
			TrunkInventory[vehicleid][i][pInvEx] =
			TrunkInventory[vehicleid][i][pInvS] = 
			VehicleInfo[vehicleid][carAttachObj][i] = 0;
		}

		for(new i = 0; i < MAX_CAR_INVENTORY; i++)
		{
			CarInventory[vehicleid][i][pInvName] = EOS;
			CarInventory[vehicleid][i][pInvQFloat] = 0.0;
			CarInventory[vehicleid][i][pInvItem] =
			CarInventory[vehicleid][i][pInvQ] =
			CarInventory[vehicleid][i][pInvEx] =
			CarInventory[vehicleid][i][pInvS] = 0;
		}

		VehicleInfo[vehicleid][carPaintJob] = 3;
		VehicleInfo[vehicleid][carRadio] =
		VehicleInfo[vehicleid][carComps] = 0;
		UpdateVehicleDamageStatus(vehicleid, 17895697, 16843009, 15, tires);
		
		for(new i = 0; i < 14; i++)
		{
		    if (VehicleInfo[vehicleid][carComponent][i] != 0)		RemoveVehicleComponent(vehicleid, VehicleInfo[vehicleid][carComponent][i]);
		        
            VehicleInfo[vehicleid][carComponent][i] = 0;
		}
	}
	else
	{
		if (VehicleInfo[vehicleid][carInsurance] != 3)
		{
			for(new i = 0; i < 14; i++)
			{
			    if (VehicleInfo[vehicleid][carComponent][i] != 0)	RemoveVehicleComponent(vehicleid, VehicleInfo[vehicleid][carComponent][i]);

	            VehicleInfo[vehicleid][carComponent][i] = 0;
			}

            VehicleInfo[vehicleid][carPaintJob] = 3;
			VehicleInfo[vehicleid][carRadio] =
			VehicleInfo[vehicleid][carComps] = 0;

			if (VehicleInfo[vehicleid][carInsurance] < 2)			UpdateVehicleDamageStatus(vehicleid, 17895697, 16843009, 15, tires);
		}
		
		if (VehicleInfo[vehicleid][carDestroyed]++ >= 4)
		{
		    VehicleInfo[vehicleid][carDestroyed] = 
		    VehicleInfo[vehicleid][carInsurance] = 0;
		}
	}

	if (VehicleInfo[vehicleid][carEngine] > 0.0)
	{
		VehicleInfo[vehicleid][carEngine] -= 5.0 + random(6);

		if (VehicleInfo[vehicleid][carEngine] <= 0.0)	VehicleInfo[vehicleid][carEngine] = 0.0;
	}

	if (VehicleInfo[vehicleid][carBattery] > 0.0)
	{
		VehicleInfo[vehicleid][carBattery] -= 10.0;

		if (VehicleInfo[vehicleid][carBattery] <= 0.0)	VehicleInfo[vehicleid][carBattery] = 0.0;
	}

	new userid = GetVehicleOwner(vehicleid);

	if (userid != INVALID_PLAYER_ID)
	{
	    VehicleInfo[vehicleid][carOwnerPlayer] = INVALID_PLAYER_ID;
        //SendWarningMessage(userid, "��� %s ������ ���������.", VehicleNames[GetVehicleModel(vehicleid)-400]);
        SendClientMessageEx(userid, COLOR_WHITE, "{FF6347}PHUONG TIEN:{FFFFFF} Tinh trang dong co xau di den {FF6347}%.2f{FFFFFF}.", VehicleInfo[vehicleid][carEngine]);
		SendClientMessageEx(userid, COLOR_WHITE, "{FF6347}PHUONG TIEN:{FFFFFF} Tinh trang ac quy da giam xuong con {FF6347}%.2f{FFFFFF}.", VehicleInfo[vehicleid][carBattery]);
	}

    VehicleInfo[vehicleid][carDeath] = 1;
	return 1;
}

ResetVehicleStuff(vehicleid, x = 0)
{
	new panels, doors, lights, tires;

	//if (IsABicycle(vehicleid))	return 1;
	    
	GetVehicleDamageStatus(vehicleid, panels, doors, lights, tires);
		
	foreach(new i : Player) {
		if (JackingVehicle[i] == vehicleid)
		{
			if (IsValidVehicle(JackingVehicle[i]))
			{
				new Float:ccX, Float:ccY, Float:ccZ;
				GetVehiclePos(JackingVehicle[i], ccX, ccY, ccZ);

				VehicleInfo[JackingVehicle[i]][ePhysicalAttack] = false;
				DestroyDynamic3DTextLabel(VehicleInfo[JackingVehicle[i]][eVehicleLabel]);
				VehicleInfo[JackingVehicle[i]][vCooldown] = false;
				JackingVehicle[i] = 0;
			}
		}
	}

	if (x)	return Save_Car(vehicleid);
	
	if (!VehicleInfo[vehicleid][carInsurance])
	{
		for(new i = 0; i < MAX_TRUNK_INVENTORY; i++)
		{
			TrunkInventory[vehicleid][i][pInvName] = EOS;
			TrunkInventory[vehicleid][i][pInvQFloat] = 0.0;
			TrunkInventory[vehicleid][i][pInvItem] =
			TrunkInventory[vehicleid][i][pInvQ] =
			TrunkInventory[vehicleid][i][pInvEx] =
			TrunkInventory[vehicleid][i][pInvS] = 
			VehicleInfo[vehicleid][carAttachObj][i] = 0;
		}

		for(new i = 0; i < MAX_CAR_INVENTORY; i++)
		{
			CarInventory[vehicleid][i][pInvName] = EOS;
			CarInventory[vehicleid][i][pInvQFloat] = 0.0;
			CarInventory[vehicleid][i][pInvItem] =
			CarInventory[vehicleid][i][pInvQ] =
			CarInventory[vehicleid][i][pInvEx] =
			CarInventory[vehicleid][i][pInvS] = 0;
		}

		VehicleInfo[vehicleid][carPaintJob] = 3;
		VehicleInfo[vehicleid][carRadio] =
		VehicleInfo[vehicleid][carComps] = 0;
		UpdateVehicleDamageStatus(vehicleid, 17895697, 16843009, 15, tires);
		
		for(new i = 0; i < 14; i++)
		{
		    if (VehicleInfo[vehicleid][carComponent][i] != 0)		RemoveVehicleComponent(vehicleid, VehicleInfo[vehicleid][carComponent][i]);
		        
            VehicleInfo[vehicleid][carComponent][i] = 0;
		}
	}
	else
	{
		if (VehicleInfo[vehicleid][carInsurance] != 3)
		{
			for(new i = 0; i < 14; i++)
			{
			    if (VehicleInfo[vehicleid][carComponent][i] != 0)	RemoveVehicleComponent(vehicleid, VehicleInfo[vehicleid][carComponent][i]);

	            VehicleInfo[vehicleid][carComponent][i] = 0;
			}

            VehicleInfo[vehicleid][carPaintJob] = 3;
			VehicleInfo[vehicleid][carRadio] =
			VehicleInfo[vehicleid][carComps] = 0;

			if (VehicleInfo[vehicleid][carInsurance] < 2)			UpdateVehicleDamageStatus(vehicleid, 17895697, 16843009, 15, tires);
		}
		
		if (VehicleInfo[vehicleid][carDestroyed]++ >= 4)
		{
		    VehicleInfo[vehicleid][carDestroyed] = 
		    VehicleInfo[vehicleid][carInsurance] = 0;
		}
	}

	if (VehicleInfo[vehicleid][carEngine] > 0.0)
	{
		VehicleInfo[vehicleid][carEngine] -= 5.0 + random(6);

		if (VehicleInfo[vehicleid][carEngine] <= 0.0)	VehicleInfo[vehicleid][carEngine] = 0.0;
	}

	if (VehicleInfo[vehicleid][carBattery] > 0.0)
	{
		VehicleInfo[vehicleid][carBattery] -= 10.0;

		if (VehicleInfo[vehicleid][carBattery] <= 0.0)	VehicleInfo[vehicleid][carBattery] = 0.0;
	}

	new userid = GetVehicleOwner(vehicleid);

	if (userid != INVALID_PLAYER_ID)
	{
	    VehicleInfo[vehicleid][carOwnerPlayer] = INVALID_PLAYER_ID;
        //SendWarningMessage(userid, "��� %s ������ ���������.", VehicleNames[GetVehicleModel(vehicleid)-400]);
        SendClientMessageEx(userid, COLOR_WHITE, "{FF6347}PHUONG TIEN:{FFFFFF} Tinh trang dong co xau di den {FF6347}%.2f{FFFFFF}.", VehicleInfo[vehicleid][carEngine]);
		SendClientMessageEx(userid, COLOR_WHITE, "{FF6347}PHUONG TIEN:{FFFFFF} Tinh trang ac quy da giam xuong con {FF6347}%.2f{FFFFFF}.", VehicleInfo[vehicleid][carBattery]);
	}

	Save_Car(vehicleid);
    VehicleInfo[vehicleid][carDeath] = 1;
	return 1;
}

HasComponent(vehicleid, compid)
{
	for(new i = 0; i < 14; i++)
	{
		if (VehicleInfo[vehicleid][carComponent][i] == compid) return 1;
	}
	return 0;
}

SetVehicleComponent(vehicleid, component, slot)
{
	VehicleInfo[vehicleid][carComponent][slot] = component;
	AddVehicleComponent(vehicleid, component);
	Save_Car(vehicleid);
	return 1;
}

SaveComponent(vehicleid, slot)
{
    if (!IsValidVehicle(vehicleid))	return 1;

	new component_str[6];
	format(component_str, sizeof(component_str), "comp%i", slot);

	SQL_SetInteger("vehicle", component_str, VehicleInfo[vehicleid][carComponent][slot], VehicleInfo[vehicleid][carID]);
	return 1;
}


ShowBuyingVehicleDetails(playerid)
{
	if (GetPVarInt(playerid, "BuyingVehicleModel") < 400 || GetPVarInt(playerid, "BuyingVehicleModel") > 611) return 1;

	new registerveh = price_reg[GetPVarInt(playerid, "BuyingVehicleRegister")], 
		alarmveh = price_alarm[GetPVarInt(playerid, "BuyingVehicleAlarm")], 
		lockveh = price_lock[GetPVarInt(playerid, "BuyingVehicleLock")], 
		immobveh = price_immob[GetPVarInt(playerid, "BuyingVehicleImmob")], 
		insuranceveh = GetInsurancePrice(GetPVarInt(playerid, "BuyingVehicleModel")) * GetPVarInt(playerid, "BuyingVehicleInsurance"),
		xmradioveh = price_radio[GetPVarInt(playerid, "BuyingVehicleRadio")], gpsveh = price_gps[GetPVarInt(playerid, "BuyingVehicleGps")];

    new mes[56];
	format(mes, sizeof(mes), "{bab9ba}%s - {35B835}$%i", VehicleNames[GetPVarInt(playerid, "BuyingVehicleModel")-400], GetVehiclePrice(GetPVarInt(playerid, "BuyingVehicleModel"))+registerveh+alarmveh+lockveh+immobveh+insuranceveh+xmradioveh+gpsveh);
	Dialog_Show(playerid, BuyingVehicleDetails, DIALOG_STYLE_LIST, mes, "Dang ky\nBao dong\nKhoa\nImmobilizer\nBao hiem\nMay ghi\nGPS\nMau sac", "Chon", "<<");
	return 1;
}

Save_CarInventory(vehicleid)
{
    if (!VehicleInfo[vehicleid][carOwnerID]) return 1;

	new query[526];
	for(new i = 0; i < MAX_TRUNK_INVENTORY; i++)
	{
		//if (!TrunkInventory[vehicleid][i][pInvItem]) continue;

	    format(query, sizeof(query), "UPDATE `inventory` SET `id_%i`=%i,`a_%i`=%i,`f_%i`=%.1f,`ex_%i`=%i,`s_%i`=%i,`n_%i`='%e' WHERE `carid`=%i", 
		i+1, TrunkInventory[vehicleid][i][pInvItem], 
		i+1, TrunkInventory[vehicleid][i][pInvQ], 
		i+1, TrunkInventory[vehicleid][i][pInvQFloat], 
		i+1, TrunkInventory[vehicleid][i][pInvEx], 
		i+1, TrunkInventory[vehicleid][i][pInvS], 
		i+1, TrunkInventory[vehicleid][i][pInvName],
		VehicleInfo[vehicleid][carID]);
		mysql_tquery(dbHandle, query);
	}
	
	for(new i = 0; i < MAX_CAR_INVENTORY; i++)
	{
		//if (!CarInventory[vehicleid][i][pInvItem]) continue;

	    format(query, sizeof(query), "UPDATE `inventory` SET `id_%i`=%i,`a_%i`=%i,`f_%i`=%.1f,`ex_%i`=%i,`s_%i`=%i,`n_%i`='%e' WHERE `trunkid`=%i", 
		i+1, CarInventory[vehicleid][i][pInvItem], 
		i+1, CarInventory[vehicleid][i][pInvQ], 
		i+1, CarInventory[vehicleid][i][pInvQFloat], 
		i+1, CarInventory[vehicleid][i][pInvEx], 
		i+1, CarInventory[vehicleid][i][pInvItem], 
		i+1, CarInventory[vehicleid][i][pInvName],
		VehicleInfo[vehicleid][carID]);
		mysql_tquery(dbHandle, query);
	}

	return 1;
}

Save_Car(vehicleid)
{
	if (!VehicleInfo[vehicleid][carOwnerID]) return 1;
	
	new panels, doorss, lightss, tires;

	GetVehicleDamageStatus(vehicleid, panels, doorss, lightss, tires);
	
	new query[1024];

	
	format(query, sizeof(query), "UPDATE `cars` SET `color1`=%i,`color2`=%i,`x`=%.1f,`y`=%.1f,`z`=%.1f,`fa`=%.1f,`engine`=%.2f,`milliage`=%.1f",
		VehicleInfo[vehicleid][carColor1],
		VehicleInfo[vehicleid][carColor2],
		VehicleInfo[vehicleid][carParkX],
		VehicleInfo[vehicleid][carParkY],
		VehicleInfo[vehicleid][carParkZ],
		VehicleInfo[vehicleid][carParkA],
		VehicleInfo[vehicleid][carEngine],
		VehicleInfo[vehicleid][carMilliage]
	);
	
	format(query, sizeof(query), "%s,`plate`='%s',`owner`=%i,`battery`=%.2f,`health`=%.1f,`armour`=%.1f,`vw`=%i,`int`=%i",
        query,
		VehicleInfo[vehicleid][carPlate],
		VehicleInfo[vehicleid][carOwnerID],
		VehicleInfo[vehicleid][carBattery],
		VehicleInfo[vehicleid][carHealth],
		VehicleInfo[vehicleid][carArmour],
		VehicleInfo[vehicleid][carVW],
		VehicleInfo[vehicleid][carInt]
	);
	
	format(query, sizeof(query), "%s,`alarm`=%i,`locks`=%i,`immob`=%i,`insurances`=%i,`destroys`=%i,`impound`=%i,`gps`=%i,`fuel`=%.1f,`registered`=%i",
		query,
		VehicleInfo[vehicleid][carAlarm],
		VehicleInfo[vehicleid][carLock],
		VehicleInfo[vehicleid][carImmob],
		VehicleInfo[vehicleid][carInsurance],
		VehicleInfo[vehicleid][carDestroyed],
		VehicleInfo[vehicleid][Impounded],
		VehicleInfo[vehicleid][carGps],
		VehicleInfo[vehicleid][carFuel],
		VehicleInfo[vehicleid][carRegistered]
	);
	
	format(query, sizeof(query), "%s,`comp0`=%i,`comp1`=%i,`comp2`=%i,`comp3`=%i,`comp4`=%i,`comp5`=%i,`comp6`=%i",
        query,
		VehicleInfo[vehicleid][carComponent][0],
		VehicleInfo[vehicleid][carComponent][1],
		VehicleInfo[vehicleid][carComponent][2],
		VehicleInfo[vehicleid][carComponent][3],
		VehicleInfo[vehicleid][carComponent][4],
		VehicleInfo[vehicleid][carComponent][5],
		VehicleInfo[vehicleid][carComponent][6]
	);
	
	format(query, sizeof(query), "%s,`comp7`=%i,`comp8`=%i,`comp9`=%i,`comp10`=%i,`comp11`=%i,`comp12`=%i,`comp13`=%i,`paintjob`=%i",
        query,
		VehicleInfo[vehicleid][carComponent][7],
		VehicleInfo[vehicleid][carComponent][8],
		VehicleInfo[vehicleid][carComponent][9],
		VehicleInfo[vehicleid][carComponent][10],
		VehicleInfo[vehicleid][carComponent][11],
		VehicleInfo[vehicleid][carComponent][12],
		VehicleInfo[vehicleid][carComponent][13],
		VehicleInfo[vehicleid][carPaintJob]
	);
	
	mysql_format(dbHandle, query, sizeof(query), "%s,`radio`=%i,`comps`=%i,`panels`=%i,`doors`=%i,`lights`=%i,`tires`=%i WHERE `id`=%i LIMIT 1",
        query,
		VehicleInfo[vehicleid][carRadio],
		VehicleInfo[vehicleid][carComps],
		panels,
		doorss,
		lightss,
		tires,
		VehicleInfo[vehicleid][carID]
	);
	mysql_tquery(dbHandle, query);

	Save_CarInventory(vehicleid);

	for(new i = 0; i < MAX_TRUNK_INVENTORY; i++)
	{
		if (VehicleInfo[vehicleid][carAttachObj][i] != 0)
		{
			DestroyDynamicObject(VehicleInfo[vehicleid][carAttach][i]);
			VehicleInfo[vehicleid][carAttach][i] = INVALID_OBJECT_ID;
		}
	}
	
	return 1;	
}


Save_CarAttach(vehicleid, i)
{
    new query[2500];
	format(query, sizeof(query), "UPDATE `cars` SET `attach%i_pos0`=%.1f,`attach%i_pos1`=%.1f,`attach%i_pos2`=%.1f,`attach%i_rot0`=%.1f,`attach%i_rot1`=%.1f,`attach%i_rot2`=%.1f, `arg_%i`=%i WHERE `id`=%i",
	i,VehicleInfo[vehicleid][carAttachPosX][i], i,VehicleInfo[vehicleid][carAttachPosY][i], i,VehicleInfo[vehicleid][carAttachPosZ][i], i,VehicleInfo[vehicleid][carAttachRotX][i], i,VehicleInfo[vehicleid][carAttachRotY][i],
	i,VehicleInfo[vehicleid][carAttachRotZ][i], i,VehicleInfo[vehicleid][carAttachObj][i], VehicleInfo[vehicleid][carID]);
	mysql_tquery(dbHandle, query);
	return 1;
}

GetMaxPlayerCars(playerid)
{
	switch(PlayerInfo[playerid][pPremium])
	{
	    case 0, 1: return 3;
	    case 2: return 5;
	    case 3: return 7;
	}
	return 100;
}

ShowAclass(playerid)
{
	new mes[sizeof(a_class_model)*128], List:bclass = list_new();
	SetPVarInt(playerid, #Selection, 2);
	for(new i = 0; i < sizeof(a_class_model); i++)
	{
		format(mes, sizeof(mes), "~w~%s~n~~g~~h~$%s", VehicleNames[a_class_model[i]-400], FormatNumber(GetVehiclePrice(a_class_model[i]))); 
		AddModelMenuItem(bclass, a_class_model[i], mes, true, -10.0, 0.0, -40.0);
	}
	ShowModelSelectionMenu(playerid, "Xe sang", MODEL_BUY_VEHICLE, bclass);
	return 1;
}

ShowBclass(playerid)
{
	new mes[sizeof(b_class_model)*128], List:bclass = list_new();
	SetPVarInt(playerid, #Selection, 0);
	for(new i = 0; i < sizeof(b_class_model); i++)
	{
		format(mes, sizeof(mes), "~w~%s~n~~g~~h~$%s", VehicleNames[b_class_model[i]-400], FormatNumber(GetVehiclePrice(b_class_model[i]))); 
		AddModelMenuItem(bclass, b_class_model[i], mes, true, -10.0, 0.0, -40.0);
	}
	ShowModelSelectionMenu(playerid, "Xe 2 cua va nho gon", MODEL_BUY_VEHICLE, bclass);		
	return 1;
}

ShowLowriders(playerid)
{
	new mes[sizeof(lowride_class_model)*128], List:lclass = list_new();
	SetPVarInt(playerid, #Selection, 1);
	for(new i = 0; i < sizeof(lowride_class_model); i++)
	{
		format(mes, sizeof(mes), "~w~%s~n~~g~~h~$%s", VehicleNames[lowride_class_model[i]-400], FormatNumber(GetVehiclePrice(lowride_class_model[i]))); 
		AddModelMenuItem(lclass, lowride_class_model[i], mes, true, -10.0, 0.0, -40.0);
	}
	ShowModelSelectionMenu(playerid, "Lowriders", MODEL_BUY_VEHICLE, lclass);		
	return 1;
}

ShowPickups(playerid)
{
	new mes[sizeof(pickups_class_model)*128], List:class = list_new();
	SetPVarInt(playerid, #Selection, 4);
	for(new i = 0; i < sizeof(pickups_class_model); i++)
	{
		format(mes, sizeof(mes), "~w~%s~n~~g~~h~$%s", VehicleNames[pickups_class_model[i]-400], FormatNumber(GetVehiclePrice(pickups_class_model[i]))); 
		AddModelMenuItem(class, pickups_class_model[i], mes, true, -10.0, 0.0, -40.0);
	}
	ShowModelSelectionMenu(playerid, "Pick-ups va Vans", MODEL_BUY_VEHICLE, class);		
	return 1;
}

ShowDealership(playerid)
{
	new mes[sizeof(dealership_model)*128], List:class = list_new();
	SetPVarInt(playerid, #Selection, 12);
	for(new i = 0; i < sizeof(dealership_model); i++)
	{
		format(mes, sizeof(mes), "~w~%s~n~~g~~h~$%s", VehicleNames[dealership_model[i]-400], FormatNumber(GetVehiclePrice(dealership_model[i]))); 
		AddModelMenuItem(class, dealership_model[i], mes, true, -10.0, 0.0, -40.0);
	}
	ShowModelSelectionMenu(playerid, "Cac loai phuong tien dang duoc ban", MODEL_BUY_VEHICLE, class);		
	return 1;
}

ShowSport(playerid)
{
	new mes[sizeof(sport_model)*128], List:class = list_new();
	SetPVarInt(playerid, #Selection, 3);
	for(new i = 0; i < sizeof(sport_model); i++)
	{
		format(mes, sizeof(mes), "~w~%s~n~~g~~h~$%s", VehicleNames[sport_model[i]-400], FormatNumber(GetVehiclePrice(sport_model[i]))); 
		AddModelMenuItem(class, sport_model[i], mes, true, -10.0, 0.0, -40.0);
	}
	ShowModelSelectionMenu(playerid, "Xe the thao", MODEL_BUY_VEHICLE, class);		
	return 1;
}

ShowOffRoad(playerid)
{
	new mes[sizeof(offroad_model)*128], List:class = list_new();
	SetPVarInt(playerid, #Selection, 5);
	for(new i = 0; i < sizeof(offroad_model); i++)
	{
		format(mes, sizeof(mes), "~w~%s~n~~g~~h~$%s", VehicleNames[offroad_model[i]-400], FormatNumber(GetVehiclePrice(offroad_model[i]))); 
		AddModelMenuItem(class, offroad_model[i], mes, true, -10.0, 0.0, -40.0);
	}
	ShowModelSelectionMenu(playerid, "SUVs va Station Wagons", MODEL_BUY_VEHICLE, class);	
	return 1;
}

ShowMotoBike(playerid)
{
	new mes[sizeof(motobike_model)*128], List:class = list_new();
	SetPVarInt(playerid, #Selection, 7);
	for(new i = 0; i < sizeof(motobike_model); i++)
	{
		format(mes, sizeof(mes), "~w~%s~n~~g~~h~$%s", VehicleNames[motobike_model[i]-400], FormatNumber(GetVehiclePrice(motobike_model[i]))); 
		AddModelMenuItem(class, motobike_model[i], mes, true, -10.0, 0.0, -40.0);
	}
	ShowModelSelectionMenu(playerid, "Mo to / Xe dap", MODEL_BUY_VEHICLE, class);	
	return 1;
}

ShowIndustrial(playerid)
{
	new mes[sizeof(industrial_model)*128], List:class = list_new();
	SetPVarInt(playerid, #Selection, 6);
	for(new i = 0; i < sizeof(industrial_model); i++)
	{
		format(mes, sizeof(mes), "~w~%s~n~~g~~h~$%s", VehicleNames[industrial_model[i]-400], FormatNumber(GetVehiclePrice(industrial_model[i]))); 
		AddModelMenuItem(class, industrial_model[i], mes, true, -10.0, 0.0, -40.0);
	}
	ShowModelSelectionMenu(playerid, "Xe tai va xe cong nhan", MODEL_BUY_VEHICLE, class);	
	return 1;
}

ShowOther(playerid)
{
	new mes[sizeof(other_model)*128], List:class = list_new();
	SetPVarInt(playerid, #Selection, 8);
	for(new i = 0; i < sizeof(other_model); i++)
	{
		format(mes, sizeof(mes), "~w~%s~n~~g~~h~$%s", VehicleNames[other_model[i]-400], FormatNumber(GetVehiclePrice(other_model[i]))); 
		AddModelMenuItem(class, other_model[i], mes, true, -10.0, 0.0, -40.0);
	}
	ShowModelSelectionMenu(playerid, "Khac", MODEL_BUY_VEHICLE, class);	
	return 1;
}

ShowBoats(playerid)
{
	new mes[sizeof(boat_model)*128], List:class = list_new();
	SetPVarInt(playerid, #Selection, 10);
	for(new i = 0; i < sizeof(boat_model); i++)
	{
		format(mes, sizeof(mes), "~w~%s~n~~g~~h~$%s", VehicleNames[boat_model[i]-400], FormatNumber(GetVehiclePrice(boat_model[i]))); 
		AddModelMenuItem(class, boat_model[i], mes, true, -10.0, 0.0, -40.0);
	}
	ShowModelSelectionMenu(playerid, "Thuyen", MODEL_BUY_VEHICLE, class);
	
	return 1;
}

ShowFly(playerid)
{
	new mes[sizeof(fly_model)*128], List:class = list_new();
	SetPVarInt(playerid, #Selection, 11);
	for(new i = 0; i < sizeof(fly_model); i++)
	{
		format(mes, sizeof(mes), "~w~%s~n~~g~~h~$%s", VehicleNames[fly_model[i]-400], FormatNumber(GetVehiclePrice(fly_model[i]))); 
		AddModelMenuItem(class, fly_model[i], mes, true, -10.0, 0.0, -40.0);
	}
	ShowModelSelectionMenu(playerid, "May bay", MODEL_BUY_VEHICLE, class);
	return 1;
}

ShowDonate(playerid)
{
	new mes[sizeof(donate_model)*128], List:class = list_new();
	SetPVarInt(playerid, #Selection, 9);
	for(new i = 0; i < sizeof(donate_model); i++)
	{
		format(mes, sizeof(mes), "~w~%s~n~~g~~h~$%s", VehicleNames[donate_model[i]-400], FormatNumber(GetVehiclePrice(donate_model[i]))); 
		AddModelMenuItem(class, donate_model[i], mes, true, -10.0, 0.0, -40.0);
	}
	ShowModelSelectionMenu(playerid, "Xe Donator", MODEL_BUY_VEHICLE, class);

	SetPVarInt(playerid, #Selection, 9);	
	return 1;
}


Dialog:MODEL_SELECTION_BUYCAR(playerid, response, listitem, inputtext[])
{
	if (!response) return Dialog_Show(playerid, SelectClass, DIALOG_STYLE_LIST, "Chon doanh muc", "Xe 2 cua va xe nho gon\n\
																									Lowriders\n\
																									Xe 4 cua va xe sang\n\
																									The thao\n\
																									Pick-ups va Vans\n\
																									SUVs va Station Wagons\n\
																									Xe tai va xe cong nhan\n\
																									Mo to / Xe dap\n\
																									Khac\n\
																									Phuong tien Premium", "Chon", "Dong");
	
	new price, modelid;

	switch(GetPVarInt(playerid, #Selection))
	{
		case 0: modelid = b_class_model[listitem];
		case 1: modelid = lowride_class_model[listitem];
		case 2: modelid = a_class_model[listitem];
		case 3: modelid = sport_model[listitem];
		case 4: modelid = pickups_class_model[listitem];
		case 5: modelid = offroad_model[listitem];
		case 6: modelid = industrial_model[listitem];
		case 7: modelid = motobike_model[listitem];
		case 8: modelid = other_model[listitem];
		case 9: modelid = donate_model[listitem];
		case 10: modelid = boat_model[listitem];
		case 11: modelid = fly_model[listitem];
	}
	
	DeletePVar(playerid, #Selection);

	if ((price = GetVehiclePrice(modelid)) == 0)	return SendErrorMessage(playerid, "This vehicle is not available.");
	        
	if (!PlayerInfo[playerid][pPremium] && IsDonateVehicle(modelid))	return SendErrorMessage(playerid, "Only a player with a premium account can purchase this vehicle.");
	if (PlayerInfo[playerid][pPremium] < 1 && IsBronzeVehicle(modelid))	return SendErrorMessage(playerid, "De mua phuong tien nay, tai khoan cua ban phai dat Bronze Premium tro len.");
	if (PlayerInfo[playerid][pPremium] < 2 && IsSilverVehicle(modelid))	 return SendErrorMessage(playerid, "De mua phuong tien nay, tai khoan cua ban phai dat Sliver Premium tro len. ");
	if (PlayerInfo[playerid][pPremium] < 3 && IsGoldVehicle(modelid))		 return SendErrorMessage(playerid, "De mua phuong tien nay, tai khoan cua ban phai dat Gold Premium. ");

	DeletePVar(playerid, "BuyingVehicleModel");
	SetPVarInt(playerid, "BuyingVehicleRegister", 0);
	SetPVarInt(playerid, "BuyingVehicleAlarm", 0);
	SetPVarInt(playerid, "BuyingVehicleLock", 0);
	SetPVarInt(playerid, "BuyingVehicleImmob", 0);
	SetPVarInt(playerid, "BuyingVehicleInsurance", 0);
	SetPVarInt(playerid, "BuyingVehicleRadio", 0);
	SetPVarInt(playerid, "BuyingVehicleGps", 0);
	SetPVarInt(playerid, "BuyingVehicleModel", modelid);

	new mes[56];

	format(mes, sizeof(mes), "{ffffff}%s - {35B835}$%s", VehicleNames[modelid-400], FormatNumber(price));

	if (modelid == 481 || modelid == 509 || modelid == 510)
	{
		Dialog_Show(playerid, BuyingVehicleDone, DIALOG_STYLE_MSGBOX, mes, "Ban co chac chan muon mua phuong tien nay?", "Co", "Huy bo");
	}
	else
	{
		SetPVarInt(playerid, #veh_color1, random(255));
		SetPVarInt(playerid, #veh_color2, random(255));

		new vehFuel[15], vehDrive[20];

		new Float:vehMass = GetVehicleModelInfoAsFloat(modelid, "fMass"); 
						
	    if (GetVehicleModelInfoAsInt(modelid, "TransmissionData_nDriveType") == 'F')
	    	vehDrive = "Phia truoc";
	    else if (GetVehicleModelInfoAsInt(modelid, "TransmissionData_nDriveType") == 'R')
	    	vehDrive = "Phia sau";
	    else if (GetVehicleModelInfoAsInt(modelid, "TransmissionData_nDriveType") == '4')
	    	vehDrive = "Xe 4 banh";
											
	    if (GetVehicleModelInfoAsInt(modelid, "TransmissionData_nEngineType") == 'P')
	    	vehFuel = "Xang";
	    else if (GetVehicleModelInfoAsInt(modelid, "TransmissionData_nEngineType") == 'D')
	    	vehFuel = "Dau diesel";
	    else if (GetVehicleModelInfoAsInt(modelid, "TransmissionData_nEngineType") == 'E')
	   		vehFuel = "Dien";
					
	    static const str_size[] = "{ecc317}Gia: \t\t			{ffffff}$%s\n\
                                    {ecc317}Toc do toi da: \t		{ffffff}%.1f km/h\n\
                                    {ecc317}Do ben toi da: \t		{ffffff}%.1f\n\
                                    {ecc317}Trong luong: \t\t		{ffffff}%.1f kf\n\n\
                                    {ecc317}Don vi truyen dong: \t		{ffffff}%s\n\
                                    {ecc317}Nhien lieu \t\t			{ffffff}%s\n\
                                    {ecc317}Tieu thu: \t		{ffffff}%.1f l/100 km\n\
                                    {ecc317}Dung tich bon: \t	{ffffff}%.1f l\n\n";
									
        new string[sizeof(str_size) + 15 + 20 + 6 + 128*2 + 128],
			registerveh = price_reg[GetPVarInt(playerid, "BuyingVehicleRegister")];
		
        format(string, sizeof(string), str_size,
			FormatNumber(GetVehiclePrice(modelid)), 
			GetVehicleMaxSpeed[modelid-400], 
			GetVehicleMaxHealth(modelid), 
			vehMass, 
			vehDrive, 
			vehFuel,
			GetVehicleFuelUsage(modelid),
			GetVehicleFuelCapacity(modelid)
		);

		format(string, sizeof(string), "%s{ecc317}Mau sac 1{ffffff} - [{%06x}#%i{ffffff}]\n{ecc317}Mau sac 2{ffffff} - [{%06x}#%i{ffffff}]\n\n", string, VehicleColoursTableRGBA[GetPVarInt(playerid, #veh_color1)] >>> 8, GetPVarInt(playerid, #veh_color1), VehicleColoursTableRGBA[GetPVarInt(playerid, #veh_color2)] >>> 8, GetPVarInt(playerid, #veh_color2));
		
		SetPVarInt(playerid, "BuyingVehicleRegister", 1);
		format(string, sizeof(string), "%s{ffffff}Dang ky: \t{ecc317}$%i\n{ecc317}+ {ffffff}Dang ky bien so xe.\n\n", string, registerveh);

		format(string, sizeof(string), "%s{ffffff}Nhan '{ecc317}Thanh toan{ffffff}' de mua phuong tien.", string);

		Dialog_Show(playerid, BuyingVehicleList, DIALOG_STYLE_MSGBOX, mes, string, "Chinh sua", "Thanh toan");
	}
	return 1;
}

LoadComp(vehicle)
{
	if (VehicleInfo[vehicle][carPaintJob] != 3) ChangeVehiclePaintjob(vehicle, VehicleInfo[vehicle][carPaintJob]);

	for(new i = 0; i < 14; i++)
	{
		if (VehicleInfo[vehicle][carComponent][i] == 0) continue;

		AddVehicleComponent(vehicle, VehicleInfo[vehicle][carComponent][i]);
	}
	return 1;
}

SendVehicleMessage(vehicleid,color,string[]) 
{
	foreach(new i : Player) 
	{
	    if (!IsPlayerLogged(i) || !IsPlayerInVehicle(i, vehicleid)) continue;

        SendClientMessage(i,color,string);
	}
	return 1;
}

GetVehicleNumber()
{
	new str[24], allowedchars[][2] = {"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"};
	
	format(str, 24, "%i%s%s%s%i%i%i", random(9), allowedchars[random(sizeof(allowedchars))], allowedchars[random(sizeof(allowedchars))], allowedchars[random(sizeof(allowedchars))], random(9), random(9), random(9));
	return str;
}

RepairVehicleBody(vehicle)
{
	return UpdateVehicleDamageStatus(vehicle, 0, 0, 0, 0);
}

DealerShip_Nearest(playerid, type)
{
	if (!IsPlayerLogged(playerid)) return -1;

	for(new i = 0; i < MAX_BIZ; i++)
	{
	    if (!BizInfo[i][bizID]) continue;
		if (PlayerToPoint(35.0,playerid,BizInfo[i][bizPosX], BizInfo[i][bizPosY], BizInfo[i][bizPosZ]) && GetWorld(playerid) == BizInfo[i][bizPosVW] && GetInterior(playerid) == BizInfo[i][bizPosInt] && BizInfo[i][bizType] == type) 
		{
			return i;
		}
	}
	return -1;
}

GetInsurancePrice(modelid)
{
	for(new i = 0; i < sizeof(InsurancesPrice); i++)
	{
		if (modelid == InsurancesPrice[i][insuranceModel]) return InsurancesPrice[i][insurancePrice];
	}
	return 350;
}

FindVehicleByPlate(plate[])
{
	for (new i = 1, j = GetVehiclePoolSize(); i <= j; i ++)
	{
		if (isnull(VehicleInfo[i][carPlate])) continue;
		if (CompareStrings(plate, VehicleInfo[i][carPlate])) return i;
	}
	return -1;
}

Vehicle_OnVehicleSpawn(vehicleid)
{
	for(new i; i != MAX_TRUCK_PRODUCT; i++)
	{
	    if (i < 6 && IsValidDynamicObject(VehicleInfo[vehicleid][carCargoObj][i]))
		{
			DestroyDynamicObject(VehicleInfo[vehicleid][carCargoObj][i]);
            VehicleInfo[vehicleid][carCargoObj][i] = INVALID_OBJECT_ID;
		}

		if (i < 5 && IsValidDynamicObject(VehicleInfo[vehicleid][carSiren][i]))
		{
		    DestroyDynamicObject(VehicleInfo[vehicleid][carSiren][i]);
		    VehicleInfo[vehicleid][carSiren][i] = INVALID_OBJECT_ID;
		}

	    VehicleInfo[vehicleid][carCargoAmount][i] = 0;
	}

	SetVehicleParamsEx(vehicleid, 0, 0, 0, 0, 0, 0, 0);
 	VehicleInfo[vehicleid][carLocked] =
 	VehicleInfo[vehicleid][carTrunkLock] =
 	VehicleInfo[vehicleid][carEngineOn] = 0;

    if (VehicleInfo[vehicleid][carOwnerID] == 0)
    {
		FixVehicle(vehicleid);
		VehicleInfo[vehicleid][carFuel] = GetVehicleFuelCapacity(GetVehicleModel(vehicleid));
	}

    if (VehicleInfo[vehicleid][carFaction] || VehicleInfo[vehicleid][carOwnerID])
	{
		ToggleVehicleLock(vehicleid, true);
	}	

	if (IsRentCar(vehicleid))
	{
	    for(new i = 0; i < MAX_TRUNK_INVENTORY; i++)
		{
			TrunkInventory[vehicleid][i][pInvName] = EOS;
			TrunkInventory[vehicleid][i][pInvQFloat] = 0.0;
			TrunkInventory[vehicleid][i][pInvItem] =
			TrunkInventory[vehicleid][i][pInvQ] =
			TrunkInventory[vehicleid][i][pInvEx] =
			TrunkInventory[vehicleid][i][pInvS] = 
			VehicleInfo[vehicleid][carAttachObj][i] = 0;
		}

		for(new i = 0; i < MAX_TRUNK_INVENTORY; i++)
		{
			CarInventory[vehicleid][i][pInvName] = EOS;
			CarInventory[vehicleid][i][pInvQFloat] = 0.0;
			CarInventory[vehicleid][i][pInvItem] =
			CarInventory[vehicleid][i][pInvQ] =
			CarInventory[vehicleid][i][pInvEx] =
			CarInventory[vehicleid][i][pInvS] = 0;
		}
	}

	VehicleInfo[vehicleid][carDeath] = 0;
	LoadedTrash[vehicleid] = 0;
}

Vehicle_OnVehicleDeath(vehicleid, killerid)
{
	if (IsValidDynamic3DTextLabel(VehicleInfo[vehicleid][eVehicleLabel])) DestroyDynamic3DTextLabel(VehicleInfo[vehicleid][eVehicleLabel]);

	if (killerid == GetVehicleOwner(vehicleid) && !VehicleInfo[vehicleid][carDeath]) ResetVehicleStuff(vehicleid);

	if (VehicleInfo[vehicleid][carOwnerID])
	{
	    new userid = GetVehicleOwner(vehicleid);

		if (IsPlayerLogged(userid)) PlayerInfo[userid][pCarKey] = 0;
	
		DestroyVehicle(vehicleid);
	}
	
	if (VehicleInfo[vehicleid][carRent] != 0)
	{
	    new userid = GetIDByID(VehicleInfo[vehicleid][carRent]);
	    if (IsPlayerLogged(userid))
	    {
	        pTemp[userid][pRentveh] = 0;

			if (pTemp[userid][pJob] ) {
				EndJob(userid);
				SendErrorMessage(userid, "Xe lao dong bi pha huy.");
			} else {
				SendErrorMessage(userid, "Phuong tien thue da bi pha huy, hop dong thue da bi cham dut. ");
			}
	    }
	    VehicleInfo[vehicleid][carRent] = 0;
	}

	if (VehicleInfo[vehicleid][vCorp]) RemoveCorpse(VehicleInfo[vehicleid][vCorp]-1);
}

Vehicle_OnPlayerUpdate(playerid)
{
	new vehicleid = GetPlayerVehicleID(playerid);
    if (vehicleid)
	{
		if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
	    	for(new i; i != MAX_SPIKE; i++)
			{
			    if (SpikeInfo[i][sCreated] == 0 || !IsPlayerInRangeOfPoint(playerid, 3.5, SpikeInfo[i][sX], SpikeInfo[i][sY], SpikeInfo[i][sZ]))
			        continue;

				new panels, doorsd, lightsf, tires;
				GetVehicleDamageStatus(vehicleid, panels, doorsd, lightsf, tires);
				UpdateVehicleDamageStatus(vehicleid, panels, doorsd, lightsf, 15);
				break;
			}
		}
		
		if (IsABicycle(vehicleid)) return 1;
		
		new string[128], 
			kmh = GetVehicleSpeed(vehicleid),
			vfuel = floatround(VehicleInfo[vehicleid][carFuel]/GetVehicleFuelCapacity(GetVehicleModel(vehicleid)) * 100);

		switch(vfuel)
		{
			case 90 .. 100:	string="~b~XANG_________~l~I~w~IIIIIIIIII~r~I~l~I";
			case 80 .. 89: 	string="~b~XANG_________~l~I~w~IIIIIIIII~r~I~w~I~l~I";
			case 70 .. 79: 	string="~b~XANG_________~l~I~w~IIIIIIII~r~I~w~II~l~I";
			case 60 .. 69: 	string="~b~XANG_________~l~I~w~IIIIIII~r~I~w~III~l~I";
			case 50 .. 59: 	string="~b~XANG_________~l~I~w~IIIIII~r~I~w~IIII~l~I"; 
			case 40 .. 49: 	string="~b~XANG_________~l~I~w~IIIII~r~I~w~IIIII~l~I";
			case 30 .. 39: 	string="~b~XANG_________~l~I~w~IIII~r~I~w~IIIIII~l~I";
			case 20 .. 29: 	string="~b~XANG_________~l~I~w~III~r~I~w~IIIIIII~l~I";
			case 10 .. 19: 	string="~b~XANG_________~l~I~w~II~r~I~w~IIIIIIII~l~I";
			case 1 .. 9:	string="~b~XANG_________~l~I~w~I~r~I~w~IIIIIIIII~l~I";
			case 0:			string="~b~XANG_________~l~I~r~I~w~IIIIIIIIII ~l~I"; 
		}

		switch(kmh) {
			case 100 .. 5000: format(string, sizeof(string), "%s~n~~b~TOC DO______~r~%d_km/h", string, kmh);
			case 91 .. 99:    format(string, sizeof(string), "%s~n~~b~TOC DO______~y~%d__km/h", string, kmh);
			case 10 .. 90:    format(string, sizeof(string), "%s~n~~b~TOC DO______~w~%d___km/h", string, kmh);
			case 0 .. 9:      format(string, sizeof(string), "%s~n~~b~TOC DO______~w~%d____km/h", string, kmh);
		} 
		
		format(string, sizeof(string), "%s~n~~b~SO DAM__~w~%0.2f_km", string, VehicleInfo[vehicleid][carMilliage]);
		PlayerTextDrawSetString(playerid, SpeedText[playerid], string);
	}
	return 1;
} 

GetNextVehicleTrunkSlot(vehicleid)
{
	for(new i; i != MAX_TRUNK_INVENTORY; i++)
	{
	    if (TrunkInventory[vehicleid][i][pInvItem] == 0) return i;
	}
	return -1;
}

GetNextVehicleGBSlot(vehicleid)
{
	for(new i; i != MAX_TRUNK_INVENTORY; i++)
	{
	    if (CarInventory[vehicleid][i][pInvItem] == 0) return i;
	}
	return -1;
}

VehicleTrunk(vehicle, bool:toggle)
{
    new engine,lights,alarm,doors,bonnet,boot,objective;

	GetVehicleParamsEx(vehicle,engine,lights,alarm,doors,bonnet,boot,objective);
	if (toggle)
	{
		SetVehicleParamsEx(vehicle,engine,lights,alarm,doors,bonnet, 1,objective);
		VehicleInfo[vehicle][carTrunkLock] = 1;
	}
	else
	{
		SetVehicleParamsEx(vehicle,engine,lights,alarm,doors,bonnet, 0, objective);
		VehicleInfo[vehicle][carTrunkLock] = 0;
	}
	return 1;
}

VehicleHood(vehicle, bool:toggle)
{
    new engine,lights,alarm,doors,bonnet,boot,objective;

	GetVehicleParamsEx(vehicle,engine,lights,alarm,doors,bonnet,boot,objective);
	if (toggle)
	{
		SetVehicleParamsEx(vehicle,engine,lights,alarm,doors,1,boot,objective);
		VehicleInfo[vehicle][carHoodLock] = 1;
	}
	else
	{
		SetVehicleParamsEx(vehicle,engine,lights,alarm,doors,0,boot,objective);
		VehicleInfo[vehicle][carHoodLock] = 0;
	}
	return 1;
}

IsDriver(playerid)
{
	return IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER ? 1 : 0;
}

VehicleEmpty(vehicleid)
{
	foreach(new i : Player)
	{
		if (IsPlayerInVehicle(i, vehicleid)) return 0;
	}
	return 1;
}

GetVehicleZone(vehicleid)
{
	new Float:x, Float:y, Float:z;
	GetVehiclePos(vehicleid, x, y, z);

	new string[128], zone[28];

	if (IsValidVehicle(vehicleid)) GetZone(x, y, zone, sizeof(zone));
	
	if (IsPointInAnyDynamicArea(x, y, z)) {
		new areas[10], street_area[2], j = GetNumberDynamicAreasForPoint(x,y,z);
		GetDynamicAreasForPoint(x, y, z, areas, sizeof(areas));

		if (GetStreet(areas, j, street_area)) {
			if (street_area[1] == -1) format(string, sizeof(string), "%s, %s", zone, street_names[street_area[0]]); 
			else					 format(string, sizeof(string), "%s, o giao lo %s va %s", zone, street_names[street_area[0]],street_names[street_area[1]]);
			
			return string;
		}
	}

	format(string, sizeof(string), "%s", zone);
	return string;
}

FixVehicle(vehicleid)
{
    VehicleInfo[vehicleid][carDeath] = 0;
	RepairVehicle(vehicleid);

    if (VehicleInfo[vehicleid][carOwnerID] != 0)	
		SetVehicleHealth(vehicleid, GetVehicleMaxHealth(GetVehicleModel(vehicleid)) + VehicleInfo[vehicleid][carArmour]);
	
	else
	{
	    if (GetVehicleModel(vehicleid) == 601 || GetVehicleModel(vehicleid) == 528 || GetVehicleModel(vehicleid) == 427)	\
				SetVehicleHealth(vehicleid, 10000.0);
	    else	SetVehicleHealth(vehicleid, 1000.0);
	}
	return 1;
}

GetMaxPassengers(model)
{
    model -= 400;
    if (0 <= model <= 211)
    {
        static seekBlock_vSeats[27] = {0x10331113, 0x11311131, 0x11331313, 0x80133301, 0x1381F110, 0x10311103, 0x10001F10, 0x11113311, 0x13113311, 0x31101100, 0x30001301, 0x11031311, 0x11111331, 0x10013111, 0x01131100, 0x11111110, 
		0x11100031, 0x11130221, 0x33113311, 0x11111101, 0x33101133, 0x101001F0, 0x03133111, 0xFF11113F, 0x13330111, 0xFF131111, 0x0000FF3F};

        return ((seekBlock_vSeats[model >>> 3] >>> ((model & 7) << 2)) & 15);
    }
    return 15;
}

this::MyCarsSpawn(playerid, response)
{
	if (!response)	return 1;
	
	new query[128];

	mysql_format(dbHandle, query, sizeof(query), "SELECT * FROM `cars` WHERE `owner` = %i AND `id` = %i LIMIT 1", PlayerInfo[playerid][pID], pTemp[playerid][MyCars][pTemp[playerid][MyCarSpawn][0]]);
	mysql_tquery(dbHandle, query, "OnPlayerSpawnVehicle", "i", playerid);
	return 1;
}

GetVehName(id)
{
	new 
		query[80],
		name[24],
		model
	;

 	mysql_format(dbHandle, query, sizeof(query), "SELECT `model` FROM `cars` WHERE `id` = %i LIMIT 1", id);
	new Cache:cache = mysql_query(dbHandle, query);
	
	model = cache_get_field_content_int(0, "model", dbHandle);
	cache_delete(cache);

	format(name, sizeof(name), "%s", VehicleNames[model-400]);
	return name;
}


GetCarsignPosition(vehicle, &Float:x, &Float:y, &Float:z)
{
    new modelid = GetVehicleModel(vehicle);

	for(new i = 0; i < sizeof(CarSignPosition); i++)
	{
	    if (modelid != CarSignPosition[i][Model]) continue;
	        
        x = CarSignPosition[i][positionX];
		y = CarSignPosition[i][positionY];
		z = CarSignPosition[i][positionZ];
		break;
	}
	return 1;
}

GetNearBootVehicle(playerid)
{
	for (new i = 1, j = GetVehiclePoolSize(); i <= j; i ++)
	{
	    if (IsVehicleStreamedIn(i, playerid) && IsOnBootVehicle(playerid, i)) return i;
	}
	return 0;
}

GetBootPos(vehicleid, &Float:x, &Float:y, &Float:z)
{
	new Float:angle, Float:distance, model = GetVehicleModel(vehicleid);

	GetVehicleModelInfo(model, 1, x, distance, z);
    distance = distance/2 + 0.1;
    GetVehiclePos(vehicleid, x, y, z);
    GetVehicleZAngle(vehicleid, angle);
    x += (distance * floatsin(-angle+180, degrees));
    y += (distance * floatcos(-angle+180, degrees));
	return 1;
}

IsOnBootVehicle(playerid, vehicleid)
{
    new Float: x, Float: y, Float: z, model = GetVehicleModel(vehicleid);
	GetBootPos(vehicleid, x, y, z);
    
    if (model == 435 || model == 450 || model == 584 || model == 591)	return IsPlayerInRangeOfPoint(playerid, 2.0, x, y, z);
        
    return IsPlayerInRangeOfPoint(playerid, 2.0, x, y, z);
}

IsOnHoodVehicle(playerid, vehicleid)
{
    new Float:angle,Float:distance, Float: x, Float: y, Float: z;

    GetVehicleModelInfo(GetVehicleModel(vehicleid), 1, x, distance, z);
    distance = distance/2 + 0.1;
    GetVehiclePos(vehicleid, x, y, z);
    GetVehicleZAngle(vehicleid, angle);
    x -= (distance * floatsin(-angle+180, degrees));
    y -= (distance * floatcos(-angle+180, degrees));
    return IsPlayerInRangeOfPoint(playerid, 2.0, x, y, z);
}

IsWindowsClose(vehicle)
{
    new wi_state[4];
	GetVehicleParamsCarWindows(vehicle, wi_state[0], wi_state[1], wi_state[2], wi_state[3]);
	return (wi_state[0] != 0 && wi_state[1] != 0 && wi_state[2] != 0 && wi_state[3] != 0) ? (1):(0);
}

GetVehicleSpeed(vehicleid)
{
	new Float: vel_x, Float: vel_y, Float: vel_z;	
	AntiCheatGetVehicleVelocity(vehicleid, vel_x, vel_y, vel_z);
	return floatround(VectorSize(vel_x, vel_y, vel_z) * 139.28625);//179.28625);
}

stock GetNearVehicle(playerid, Float:radius = 3.0, vehicleid = 0) 
{
	new 
		Float:px, 
		Float:py, 
		Float:pz;

	if (vehicleid != 0)
	{
		if (GetVehiclePos(vehicleid, px, py, pz) && IsPlayerInRangeOfPoint(playerid, radius, px, py, pz) && GetWorld(playerid) == GetVehicleVirtualWorldEx(vehicleid)) return 1;
		return 0;
	}

	new closet = 0;

	GetPlayerPos(playerid, px, py, pz);
	for (new i = 1, j = GetVehiclePoolSize(); i <= j; i++)
	{
		if (i != INVALID_VEHICLE_ID)
		{
			if (GetVehicleDistanceFromPoint(i, px, py, pz) <= radius && GetWorld(playerid) == GetVehicleVirtualWorldEx(i))
			{
				GetVehiclePos(i, px, py, pz);
				closet = i;
			}
		}
	}
	return closet;
}

stock RespawnVehicle(vehicleid, spawned = 0)
{
	new Float: health,
		Float: x,
		Float: y,
		Float: z,
		Float: fa,
		world = veh_vw[vehicleid],
		interior = veh_int[vehicleid];

	GetVehiclePos(vehicleid, x, y, z);
	GetVehicleZAngle(vehicleid, fa);
	
	AntiCheatGetVehicleHealth(vehicleid, health);

    new
		panels,
		doorss,
		lightss,
		tires;

	GetVehicleDamageStatus(vehicleid, panels, doorss, lightss, tires);
	
	SetVehicleToRespawn(vehicleid);

	if (spawned == 1)
	{
	    SetVehicleVirtualWorld(vehicleid, world);
		LinkVehicleToInterior(vehicleid, interior);
	    SetVehiclePos(vehicleid, x, y, z);
	    SetVehicleZAngle(vehicleid, fa);
	}
	else
	{
		SetVehicleVirtualWorld(vehicleid, VehicleInfo[vehicleid][carVW]);
		LinkVehicleToInterior(vehicleid, VehicleInfo[vehicleid][carInt]);
	}

	/*if (VehicleInfo[vehicleid][carOwnerID] == 0)
	    return 1;*/
	    
	UpdateVehicleDamageStatus(vehicleid, panels, doorss, lightss, tires);
	LoadComp(vehicleid);
	SetVehicleHealth(vehicleid, GetVehicleMaxHealth(GetVehicleModel(vehicleid)) + VehicleInfo[vehicleid][carArmour]);

	if (IsValidDynamic3DTextLabel(VehicleInfo[vehicleid][eVehicleLabel])) DestroyDynamic3DTextLabel(VehicleInfo[vehicleid][eVehicleLabel]);
	return 1;
}

ToggleVehicleLock(vehicleid, bool:toggle)
{
    new engine,lights,alarm,doors,bonnet,boot,objective;

    GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);

    if (toggle == true)
	{
		SetVehicleParamsEx(vehicleid, engine, lights, alarm, VEHICLE_PARAMS_ON, bonnet, boot, objective);
		VehicleInfo[vehicleid][carLocked] = 1;
	}
	else
	{
 	   SetVehicleParamsEx(vehicleid, engine, lights, alarm, VEHICLE_PARAMS_OFF, bonnet, boot, objective);
 	   VehicleInfo[vehicleid][carLocked] = 0;
 	}
	return 1;
}

VehicleLight(vehicleid, bool:toggle)
{
    new engine,lights,alarm,doors,bonnet,boot,objective;

	GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);

	if (toggle == true)	SetVehicleParamsEx(vehicleid, engine, VEHICLE_PARAMS_ON, alarm, doors, bonnet, boot, objective);
	else				SetVehicleParamsEx(vehicleid, engine, VEHICLE_PARAMS_OFF, alarm, doors, bonnet, boot, objective);

	return 1;
}

VehicleEngine(vehicleid, bool:toggle)
{
    new engine,lights,alarm,doors,bonnet,boot,objective;

	GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);

	if (toggle == true)
	{
		SetVehicleParamsEx(vehicleid, VEHICLE_PARAMS_ON, lights, alarm, doors, bonnet, boot, objective);
 		VehicleInfo[vehicleid][carEngineOn] = 1;
 	}
	else
	{
		SetVehicleParamsEx(vehicleid, VEHICLE_PARAMS_OFF, lights, alarm, doors, bonnet, boot, objective);
  		VehicleInfo[vehicleid][carEngineOn] = 0;
 	}
	return 1;
}

ToggleVehicleEngine(vehicleid, playerid)
{
    new engine,lights,alarm,doors,bonnet,boot,objective;
	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

	if (VehicleInfo[vehicleid][carEngineOn])
	{
		SetVehicleParamsEx(vehicleid, VEHICLE_PARAMS_OFF, lights, alarm, doors, bonnet, boot, objective);

		new mes[128];
		format(mes, sizeof(mes), "tat dong co cua %s.", VehicleNames[GetVehicleModel(vehicleid)-400]);
		SetPlayerChatBubble(playerid, mes, COLOR_PURPLE, 20.0, 4000);

		format(mes, sizeof(mes), "T~w~DONG CO %s ~r~TAT",VehicleNames[GetVehicleModel(vehicleid)-400]);
		GameTextForPlayer(playerid, mes, 2500, 4);

		VehicleInfo[vehicleid][carEngineOn] = false;
		return 1;
	}

	if (VehicleInfo[vehicleid][carOwnerID] && VehicleInfo[vehicleid][carEngine] <= 0.0)		return GameTextForPlayer(playerid, "~r~DONG CO SE KHONG HOAT DONG~n~BAN CAN THAY DOI DONG CO!", 3000, 4);
    if (VehicleInfo[vehicleid][carOwnerID] && VehicleInfo[vehicleid][carBattery] <= 0.0)	return GameTextForPlayer(playerid, "~r~DONG CO SE KHONG HOAT DONG~n~BAN CAN THAY DOI AC QUY!", 3000, 4);

	new Float: health;
	AntiCheatGetVehicleHealth(vehicleid, health);

	if (health <= 330.0)
	{
		return SendWarningMessage(playerid, "Xe cua ban khong the no may, dong co bi hu hong nang.");
	}
	   
	else if (health < 390.0 && health > 330.0)
	{
	    SendSyntaxMessage(playerid, "Dong co cua o to khong hoat dong.");
	    SendSyntaxMessage(playerid, "Giu phim {FFFF00}W{ffffff} trong {FFFF00}10 giay{ffffff} va doi dong co khoi dong.");
        SendWarningMessage(playerid, "Xe cua ban khong the no may, dong co bi hu hong nang.");
		SetPVarInt(playerid, #try_engine, 2);
		return 1;
	}
	else if (health < 600.0 && health > 390.0 && random(2) == 0)
	{
		SendWarningMessage(playerid, "Xe cua ban khong the no may. Co gang lien he voi tho sua xe de kiem tra van de.");
	} 

	SetVehicleParamsEx(vehicleid, VEHICLE_PARAMS_ON, lights, alarm, doors, bonnet, boot, objective);

	new mes[128];
	format(mes, sizeof(mes), "khoi dong dong co %s.", VehicleNames[GetVehicleModel(vehicleid)-400]);
	SetPlayerChatBubble(playerid, mes, COLOR_PURPLE, 20.0, 4000);

	format(mes, sizeof(mes), "~w~DONG CO %s ~g~BAT",VehicleNames[GetVehicleModel(vehicleid)-400]);
	GameTextForPlayer(playerid, mes, 2500, 4);

	VehicleInfo[vehicleid][carEngineOn] = true;

	return 1;
}

AlarmOn(vehicle)
{
    if (VehicleInfo[vehicle][carAlarm] < 1) 		return 1;
	if (VehicleInfo[vehicle][carObjectiveTime])	return 1;

    new engine,lights,alarm,doors,bonnet,boot,objective;

    GetVehicleParamsEx(vehicle,engine,lights,alarm,doors,bonnet,boot,objective);
    SetVehicleParamsEx(vehicle,engine,lights,VEHICLE_PARAMS_ON,doors,bonnet,boot,objective);

    if (VehicleInfo[vehicle][carAlarm] < 2) return 1;

	GetVehicleParamsEx(vehicle,engine,lights,alarm,doors,bonnet,boot,objective);
	
	SendFactionMessage(FACTION_POLICE, COLOR_YELLOWG, "[Bao Dong] %s[%s] bao dong da vang len tai %s.", VehicleNames[GetVehicleModel(vehicle)-400], VehicleInfo[vehicle][carPlate], GetVehicleZone(vehicle));

	if (VehicleAlertNote[vehicle] - gettime() < 0) {
		new str_vehalarm[256]; 
		format(str_vehalarm, sizeof(str_vehalarm), "Bao dong duoc kich hoat tai %s.", GetVehicleZone(vehicle));

		VehicleAlertNote[vehicle] = gettime() + 1800;
		CarWanted(vehicle, str_vehalarm);
	}
	
	VehicleInfo[vehicle][carObjectiveTime] = 150;
    VehicleInfo[vehicle][carAlarmTime] = 60;
	SetVehicleParamsEx(vehicle,engine,lights,VEHICLE_PARAMS_ON,doors,bonnet,boot,VEHICLE_PARAMS_ON);

    if (VehicleInfo[vehicle][carAlarm] < 3) return 1;

	new mes[256];
	if (VehicleInfo[vehicle][carAlarm] == 4)	format(mes, sizeof(mes), "Bao dong phuong tien cua ban da duoc kich hoat.");
	else format(mes, sizeof(mes), "Bao dong %s cua ban da duoc kich hoat, vi tri: %s.", VehicleNames[GetVehicleModel(vehicle)-400], GetVehicleZone(vehicle));
			
	foreach(new i : Player)
	{
		if (IsPlayerLogged(i) && PlayerInfo[i][pCarKey] == vehicle) return SendSMStoPlayer(i, "9199", "AlarmService", mes);
	}

	new query[256];
	mysql_format(dbHandle, query, sizeof(query), "SELECT * FROM `users` WHERE `id` = %i", VehicleInfo[vehicle][carOwnerID]);
	mysql_tquery(dbHandle, query, "SmsToPlayerOff", "sss", "9199", "AlarmService", mes); 
	
	return 1;
}

AlarmOff(vehicleid)
{
    VehicleInfo[vehicleid][carObjectiveTime] = 0;
    VehicleInfo[vehicleid][carAlarmTime] = 30;

    new engine,lights,alarm,doors,bonnet,boot,objective;

	GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
	SetVehicleParamsEx(vehicleid,engine,lights,VEHICLE_PARAMS_OFF,doors,bonnet,boot,VEHICLE_PARAMS_OFF);
	return 1;
}

CarWanted(vehicleid, text[])
{
	VehicleInfo[vehicleid][carWanted] = 1;
	SQL_SetInteger("cars", "wanted", 1, VehicleInfo[vehicleid][carID]);

	new query[128];
	mysql_format(dbHandle, query, sizeof(query), "SELECT `Note1`,`Note2`,`Note3`,`Note4`,`Note5` FROM `cars` WHERE `id` = %i", VehicleInfo[vehicleid][carID]);
	mysql_tquery(dbHandle, query); 

	if (!cache_num_rows()) return SQL_SetString("cars", "Note1", text, VehicleInfo[vehicleid][carID]);
	else {
		new notesadd[5];
		for(new i = 0; i < 5; i++) {
			new notei[6];
			format(notei, sizeof(notei), "Note%i", i+1);
			cache_get_field_content(0, notei, notesadd[i]);

			if (CompareStrings(notesadd[i], "None"))
			{
				SQL_SetString("cars", notei, text, VehicleInfo[vehicleid][carID]);
				break;
			}
		}
	}
	return 1;
}

IsPizzaCar(vehicle)
{
	return VehicleInfo[vehicle][carType] == PIZZA_CAR ? 1 : 0;
}

IsTaxiCar(vehicle)
{
	return VehicleInfo[vehicle][carType] == TAXI_CAR ? 1 : 0;
}

IsTrashMasterCar(vehicle)
{
	return VehicleInfo[vehicle][carType] == TRASHMASTER_CAR ? 1 : 0;
}

IsMinerCar(vehicle)
{
	return VehicleInfo[vehicle][carType] == MINER_CAR ? 1 : 0;
}

IsLamberJackCar(vehicle)
{
	return VehicleInfo[vehicle][carType] == LAMBERJACK_CAR ? 1 : 0;
}

IsTruckCar(vehicle)
{
	return VehicleInfo[vehicle][carType] == TRUCK_CAR ? 1 : 0;
}

IsADMVCar(vehicle)
{
	return VehicleInfo[vehicle][carType] == DMV_VEHICLE ? 1 : 0;
}

IsADMVTaxi(vehicle)
{
	return VehicleInfo[vehicle][carType] == DMV_TAXI ? 1 : 0;
}

IsADMVHeli(vehicle)
{
	return VehicleInfo[vehicle][carType] == DMV_HELICOPTER ? 1 : 0;
}

IsRentCar(vehicle)
{
    return VehicleInfo[vehicle][carType] == RENT_CAR ? 1 : 0;
}

IsABicycle(vehicle)
{
	new model = GetVehicleModel(vehicle);
	return (model == 481 || model == 509 || model == 510)?(1):(0);
}

IsATowTruck(vehicle)
{
	new model = GetVehicleModel(vehicle);
	return (model == 525)?(1):(0);
}

IsAPlane(vehicle)
{
	new model = GetVehicleModel(vehicle);
	return (model == 592 || model == 577 || model == 511 || model == 512 || model == 593 || model == 520 || model == 553 || model == 476 || model == 519 || model == 460 || model == 513 || model == 548 || model == 417 || model == 487 ||
	model == 488 || model == 497 || model == 563 || model == 447 || model == 469 )?(1):(0);
}

IsADontTrunk(vehicle)
{
	new model = GetVehicleModel(vehicle);
	return (model == 457 || model == 424 || model == 568 || model == 525 || model == 531 || model == 530 || model == 572)?(1):(0);
}

IsAHelicopter(vehicle)
{
	new model = GetVehicleModel(vehicle);
	return (model == 548 || model == 425 || model == 417 || model == 487 || model == 488 || model == 497 || model == 563 || model == 447 || model == 469)?(1):(0);
}

IsATaxi(vehicle)
{
	return (GetVehicleModel(vehicle) == 420 || GetVehicleModel(vehicle) == 438)?(1):(0);
}

IsATrashTruck(vehicle)
{
	return (GetVehicleModel(vehicle) == 408)?(1):(0);
}

IsADontWindow(vehicle)
{
	new model = GetVehicleModel(vehicle);
	return (model == 586 || model == 424 || model == 448 || model == 457 || model == 461 || model == 462 || model == 463 || model == 468 || model == 471 || model == 481 || model == 509 || model == 572 || model == 510 || model == 521 || 
	model == 522 || model == 523 || model == 530 || model == 531 || model == 532 || model == 539 || model == 568 || model == 571 ||model == 581 || model == 582 || model == 430 || model == 446 || model == 452 || model == 453 || 
	model == 454 || model == 472 || model == 473 || model == 484 || model == 493 || model == 595)?(1):(0);
}

IsABiker(vehicleid)
{
	new model = GetVehicleModel(vehicleid);
	return (model == 522 || model == 521 || model == 461 || model == 463 || model == 581 || model == 448 || model == 586 || model == 523 || model == 468 || model == 471 || model == 462)?(1):(0);
}

IsABoat(vehicleid)
{
	new model = GetVehicleModel(vehicleid);
	return (model == 472 || model == 473 || model == 493 || model == 595 || model == 484 || model == 430 || model == 453 || model == 452 || model == 446 || model == 454)?(1):(0);
}

IsDonateVehicle(model)
{
    switch(model)
	{
	    case 424, 568, 495, 541, 411, 490, 522: return 1;
	}
	return 0;
}

IsBronzeVehicle(model)
{
	switch(model)
	{
	    case 424, 568: return 1;
	}
	return 0;
}

IsSilverVehicle(model)
{
	switch(model)
	{
	    case 495, 541: return 1;
	}
	return 0;
}

IsGoldVehicle(model)
{
    switch(model)
	{
	    case 411, 490, 522: return 1;
	}
	return 0;
}

IsABoatModel(model)
{
	return (model == 472 || model == 473 || model == 493 || model == 595 || model == 484 || model == 430 || model == 453 || model == 452 || model == 446 || model == 454)?(1):(0);
}

IsAPlaneModel(model)
{
	return (model == 592 || model == 577 || model == 511 || model == 512 || model == 593 || model == 520 || model == 553 || model == 476 || model == 519 || model == 460 || model == 513 || model == 548 || model == 417 || model == 487 ||
	model == 488 || model == 497 || model == 563 || model == 447 || model == 469 ) ? (1) : (0);
}

/*
IsTruckCar(vehicle)
{
	switch(GetVehicleModel(vehicle))
	{
	    case 403, 514, 515: return 1;
	}
	return 0;
}*/

GetPlayerHasRightDrive(playerid, vehicleid)
{
	if (!VehicleInfo[vehicleid][carOwnerID]) {
		if (VehicleInfo[vehicleid][carFaction] != 0 && VehicleInfo[vehicleid][carFaction] != PlayerInfo[playerid][pFaction])
		{
			SendErrorMessage(playerid, "Ban khong co chia khoa cua chiec xe nay.");
			RemovePlayerFromVehicle(playerid);
			return 0;
		}

		if ((VehicleInfo[vehicleid][carType] > 5 && VehicleInfo[vehicleid][carType] < 10 && VehicleInfo[vehicleid][carRent] && GetIDByID(VehicleInfo[vehicleid][carRent]) != playerid) || IsPizzaCar(vehicleid) && PlayerInfo[playerid][pSideJob] != JOB_PIZZA || IsTaxiCar(vehicleid) && PlayerInfo[playerid][pJob] != JOB_TAXI || IsTruckCar(vehicleid) && PlayerInfo[playerid][pJob] != JOB_TRUCKER && GetAvailableTruck(playerid, GetVehicleModel(vehicleid))) {
			SendErrorMessage(playerid, "Ban khong co chia khoa cua chiec xe nay.");
			RemovePlayerFromVehicle(playerid);
			return 0;
		}
	}	

	if ((IsAPlane(vehicleid) || IsAHelicopter(vehicleid)) && !IsADMVHeli(vehicleid) && PlayerInfo[playerid][pFlyLic] == 0)
	{
		SendErrorMessage(playerid, "Ban khong co giay phep de van hanh phuong tien nay.");
        RemovePlayerFromVehicle(playerid);
		return 0;
	}

  	if (IsADMVCar(vehicleid) && PlayerInfo[playerid][pCarLic])
	{
		SendErrorMessage(playerid, "Ban da co giay phep lai xe o to.");
		RemovePlayerFromVehicle(playerid);
		return 0;
	}
	else if (IsADMVHeli(vehicleid) && PlayerInfo[playerid][pFlyLic] == 1)
	{
		SendErrorMessage(playerid, "Ban da co giay phep lai may bay.");
		RemovePlayerFromVehicle(playerid);
		return 0;
	}
	else if (IsADMVTaxi(vehicleid) && PlayerInfo[playerid][pTaxiLic] == 1)
	{
		SendErrorMessage(playerid, "Ban da co bang lai xe Taxi.");
		RemovePlayerFromVehicle(playerid);
		return 0;
	}
	else if (IsADMVTaxi(vehicleid) && PlayerInfo[playerid][pCarLic] == 0)
	{
		SendErrorMessage(playerid, "De co bang lai xe taxi, ban phai co bang lai xe.");
		RemovePlayerFromVehicle(playerid);
		return 0;
	}
	return 1;
}

ModShop_Nearest(playerid)
{
	if (!IsPlayerLogged(playerid)) return -1;

	for(new i = 0; i < MAX_BIZ; i++)
	{
	    if (BizInfo[i][bizID] == 0 || BizInfo[i][bizType] != BIZ_TUNING) continue;

	    if (PlayerToPoint(15.0,playerid,BizInfo[i][bizPosX], BizInfo[i][bizPosY], BizInfo[i][bizPosZ]) && GetWorld(playerid) == BizInfo[i][bizPosVW] && GetInterior(playerid) == BizInfo[i][bizPosInt]) return i;
	}
	return -1;
}

ShowComponentMenu(playerid, vehicle, listitem)
{
	new count, mes[512], str[56];

	for(new i; i != max_vehicle_components[listitem]; i++)
	{
		if (vehicle_component[listitem][i][compID] == 0 || IsVehicleUpgradeCompatible(GetVehicleModel(vehicle), vehicle_component[listitem][i][compID]) != 1) continue;
		
		format(str, sizeof(str), "%s\t$%i\n", GetComponentName(vehicle_component[listitem][i][compID]), vehicle_component[listitem][i][compPrice]);
		strcat(mes, str);
		count++;
   	}

	if (!count)
	{
	    ShowModMenu(playerid);
		return SendErrorMessage(playerid, "Khong co bo phan phu hop cho xe cua ban.");
	}

	SetPVarInt(playerid, #component_type, listitem);
   	Dialog_Show(playerid, SelectModDialog, DIALOG_STYLE_TABLIST, "{33AA33}Dieu chinh phuong tien", mes, "Chon", "Quay lai");
   	return 1;
}

ShowModMenu(playerid)
{
	new vehicle = GetPlayerVehicleID(playerid);

    if (!vehicle || !IsDriver(playerid))								return SendErrorMessage(playerid, "Ban phai ngoi tren xe voi tu cach la nguoi lai xe.");
    if (IsABicycle(vehicle))											return Dialog_Show(playerid, ModDialogBike, DIALOG_STYLE_LIST, "{33AA33}Dieu chinh xe dap", "Son xe dap [$100]", "Chon", "Dong");
	if (!IsABicycle(vehicle) && !VehicleInfo[vehicle][carRegistered])	return SendErrorMessage(playerid,"Phuong tien nay khong duoc dang ky.");
	if (!IsABicycle(vehicle) && VehicleInfo[vehicle][carEngineOn])		return SendErrorMessage(playerid, "Dung dong co truoc khi sua doi phuong tien cua ban. ");

    new cost = GetVehiclePrice(GetVehicleModel(vehicle));
	static const str_size[] = "Nitro\nPainting works\nPainting [$500]\nHydraulics [$8.000]\nXM Radio [$400]\nGPS [$1500]\nThay doi dong co [$%i]\nThay doi ac quy [$%i]\nNang cap khoa [$300]\nCai tien\nXoa dieu chinh";
	new mes[sizeof(str_size) - 4 + 1 + 24];
	
	format(mes, sizeof(mes), str_size, cost / 100 * 10, cost / 100 * 5);
	Dialog_Show(playerid, ModDialog, DIALOG_STYLE_LIST, "{33AA33}Dieu chinh phuong tien", mes, "Chon", "Dong");
	return 1;
}

SetVehicleInteriorEx(vehicleid, interior)
{
    veh_int[vehicleid] = interior;
	return LinkVehicleToInterior(vehicleid, interior);
}

GetVehicleInteriorEx(vehicleid)
{
	if (!IsValidVehicle(vehicleid)) return INVALID_VEHICLE_ID;
	return veh_int[vehicleid];
}

SetVehicleVirtualWorldEx(vehicleid, world)
{
    veh_vw[vehicleid] = world;
	return SetVehicleVirtualWorld(vehicleid, world);
}

GetVehicleVirtualWorldEx(vehicleid)
{
	if (!IsValidVehicle(vehicleid)) return INVALID_VEHICLE_ID;
	return veh_vw[vehicleid];
}

GetVehicleOwner(vehicleid)
{
	new playerid = VehicleInfo[vehicleid][carOwnerPlayer];
	return (IsPlayerLogged(playerid) && PlayerInfo[playerid][pID] == VehicleInfo[vehicleid][carOwnerID]) ? (playerid):(INVALID_PLAYER_ID);
}

IsVehicleInRangeOfPoint(vehicleid, Float: radius, Float: x, Float: y, Float: z)
{
	return (GetVehicleDistanceFromPoint(vehicleid, x, y, z) <= radius)?(1):(0);
}

IsNearTrunk(vehicle, playerid, Float: dist = 4.0)
{
	if (IsADontTrunk(vehicle) || IsAPlane(vehicle) || IsABiker(vehicle) || IsAHelicopter(vehicle) || IsABoat(vehicle) || IsABicycle(vehicle))
		return 0;
	
	new Float: x, Float: y, Float: z;
    GetVehicleBoot(vehicle, x, y, z);

    if (GetPlayerDistanceFromPoint(playerid, x, y, z) > dist) return 0;
	
	return 1;
}

VehicleHasDoors(vehicleid)
{
	switch (GetVehicleModel(vehicleid))
	{
		case 400..424, 426..429, 431..440, 442..445, 451, 455, 456, 458, 459, 466, 467, 470, 474, 475, 477..480, 482, 483, 486, 489, 490..492, 494..496, 498..500, 502..508, 514..518, 524..529, 533..536, 540..547, 549..552, 554..562, 565..568, 573, 575, 576, 578..580, 582, 585, 587..589, 596..605, 609:
			return 1;
	}
	return 0;
}

CountPlayerVehicles(playerid)
{
	new 
		query[128]
	;

 	mysql_format(dbHandle, query, sizeof(query), "SELECT COUNT(id) AS total FROM `cars` WHERE `owner` = %i", PlayerInfo[playerid][pID]);
	new Cache:cache = mysql_query(dbHandle, query),
		count = cache_get_field_content_int(0, "total");

	cache_delete(cache);
	return count;
}

Vh_OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
	new query[256];
	if(pTemp[playerid][pVehicleScreen])
	{
		if (playertextid == VehSpawn[playerid][2]) //right
		{
			mysql_format(dbHandle, query, sizeof(query), "SELECT * FROM cars WHERE owner = %i AND impound = 0 AND jacking = 0 AND id > %i LIMIT 1", PlayerInfo[playerid][pID], GetPVarInt(playerid, #spawnveh_id));
			mysql_tquery(dbHandle, query, "Query_ShowVehicleList", "i", playerid);
			return 1;
		}
		else if (playertextid == VehSpawn[playerid][3]) //left
		{
			mysql_format(dbHandle, query, sizeof(query), "SELECT * FROM cars WHERE owner = %i AND impound = 0 AND jacking = 0 AND id < %i ORDER BY `id` DESC LIMIT 1", PlayerInfo[playerid][pID], GetPVarInt(playerid, #spawnveh_id));
			mysql_tquery(dbHandle, query, "Query_ShowVehicleList", "i", playerid);
			return 1;
		}
		else if (playertextid == VehSpawn[playerid][1]) //spawn
		{
			mysql_format(dbHandle, query, sizeof(query), "SELECT * FROM `cars` WHERE `owner` = %i AND impound = 0 AND jacking = 0 AND `id` = %i LIMIT 1", PlayerInfo[playerid][pID], GetPVarInt(playerid, #spawnveh_id));
			mysql_tquery(dbHandle, query, "OnPlayerSpawnVehicle", "i", playerid);
			return 1;
		}
	}
	return 1;
}

ShowVehicleList(playerid)
{
	CreateVehicleMenu(playerid);
	pTemp[playerid][pVehicleScreen] = 1;
	PlayerTextDrawShow(playerid, VehSpawn[playerid][0]);
	PlayerTextDrawShow(playerid, VehSpawn[playerid][1]);
	PlayerTextDrawShow(playerid, VehSpawn[playerid][2]);
	PlayerTextDrawShow(playerid, VehSpawn[playerid][3]);
	PlayerTextDrawShow(playerid, VehSpawn[playerid][4]);
	PlayerTextDrawShow(playerid, VehSpawn[playerid][5]);
	SelectTextDraw(playerid, 0xFF0000FF);

	new query[128];
	mysql_format(dbHandle, query, sizeof(query), "SELECT id, model, color1, color2, x, y, z FROM cars WHERE owner = %i", PlayerInfo[playerid][pID]);
	mysql_tquery(dbHandle, query, "Query_ShowVehicleList", "ii", playerid, CountPlayerVehicles(playerid));

	return 1;
}

//#define COLOR_TEST 0xEC9F0EFF

this::Query_ShowVehicleList(playerid, idx)
{
	if (!cache_num_rows()) return 1;

	new 
		vehicleModel,
		vehicleColor1,
		vehicleColor2
	;
	
	SetPVarInt(playerid, #spawnveh_id, cache_get_field_content_int(0, "id"));

	vehicleModel = cache_get_field_content_int(0, "model");
	vehicleColor1 = cache_get_field_content_int(0, "color1");
	vehicleColor2 = cache_get_field_content_int(0, "color2");
	
	new str[64];
    format(str, sizeof(str), "%s", VehicleNames[vehicleModel-400]);
    PlayerTextDrawSetString(playerid, VehSpawn[playerid][5], str);
    
    PlayerTextDrawSetPreviewModel(playerid, VehSpawn[playerid][1], vehicleModel);
    PlayerTextDrawSetPreviewVehCol(playerid, VehSpawn[playerid][1], vehicleColor1, vehicleColor2);

	PlayerTextDrawShow(playerid, VehSpawn[playerid][1]);

	return 1;
}

NewScrambleWord(playerid)
{
	new vehid = GetPlayerVehicleID(playerid);
	pTemp[playerid][pUnscrambleID] = random(sizeof(UnscrambleInfo));
		
	switch(VehicleInfo[vehid][carImmob])
	{
		case 0: JackingEngine[playerid] = 125;
		case 1: JackingEngine[playerid] = 100;
		case 2: JackingEngine[playerid] = 75;
		case 3: JackingEngine[playerid] = 50;
		case 4: JackingEngine[playerid] = 25;
	}

	return 1;
}

StopJackingEngine(playerid) 
{
	RemovePlayerFromVehicle(playerid);
	JackingEngine[playerid] = 0;
	pTemp[playerid][pUnscrambleID] = 0;
	pTemp[playerid][pScrambleFailed] = 0;
	pTemp[playerid][pScrambleSuccess] = 0;

	InfoMSG(playerid, "BAN ~r~KHONG THE ~w~HACK DONG CO!", 3);

	return 1;
}


LeaveMission(playerid)
{
	InfoMSG(playerid, "~r~NHIEM VU BI HUY BO!", 3);

	PlayerInfo[playerid][InMission] = MISSION_NONE;
	PlayerInfo[playerid][MissionTime] = 0;
	PlayerInfo[playerid][MissionTarget][0] = 0;
	PlayerInfo[playerid][MissionTarget][1] = 0;
	
	return 1;
}

StopJackingLock(playerid, x = 1) 
{
	VehicleInfo[JackingVehicle[playerid]][ePhysicalAttack] = false;
	DestroyDynamic3DTextLabel(VehicleInfo[JackingVehicle[playerid]][eVehicleLabel]);
	VehicleInfo[JackingVehicle[playerid]][vCooldown] = false;
	
	JackingVehicle[playerid] = 0;
	pTemp[playerid][JackingType] = 0;
	JackingLock[playerid] = 0;
	pTemp[playerid][JackingWarnings] = 0;
						
	if (x) InfoMSG(playerid, "BAN ~r~KHONG THE ~w~ PHA CUA XE!", 3);

	return 1;
}

this::DELETE_VEHICLE(playerid, response)
{
	new model = GetPVarInt(playerid, #RansomVehModel),
		vehid = GetPVarInt(playerid, #RansomVehID);
		
	DeletePVar(playerid, #RansomVehModel);
	DeletePVar(playerid, #RansomVehID);

	if (!response) return 1;
	
	new query[128];

	format(query, sizeof(query), "%s [IP: %s] da chiec xe %s", GetName(playerid), PlayerInfo[playerid][pID], VehicleNames[model-400]);
	insert_log(query, VEHICLE_LOG, 4, PlayerInfo[playerid][pAccID]);

	mysql_format(dbHandle, query, sizeof(query), "DELETE FROM `tickers` WHERE `vehicle` = %i", vehid);
	mysql_tquery(dbHandle, query);

	mysql_format(dbHandle, query, sizeof(query), "DELETE FROM `cars` WHERE `id` = %i", vehid);
	mysql_tquery(dbHandle, query);

	SendSyntaxMessage(playerid, "%s cua ban da duoc xoa thanh cong!", VehicleNames[model-400]);
	return 1;
}

IsPlayerInFrontVDoor(playerid, vehid) {
	new Float:ccX, Float:ccY, Float:ccZ;
	new Float:dX, Float:dY, Float:dZ;

	GetVehicleModelInfo(VehicleInfo[vehid][carModel], VEHICLE_MODEL_INFO_FRONTSEAT, ccX, ccY, ccZ);
	GetVehicleRelativePos(vehid, dX, dY, dZ, -ccX - 0.5, ccY, ccZ);
	if (!IsPlayerInRangeOfPoint(playerid, 1.2, dX, dY, dZ)) 	return 0;
	else 													return 1;
}

GetVehicleRelativePos(vehicleid, &Float:x, &Float:y, &Float:z, Float:xoff= 0.0, Float:yoff= 0.0, Float:zoff= 0.0)
{
    new Float:rot;
    GetVehicleZAngle(vehicleid, rot);
    rot = 360 - rot;
    GetVehiclePos(vehicleid, x, y, z);
    x = floatsin(rot, degrees) * yoff + floatcos(rot, degrees) * xoff + x;
    y = floatcos(rot, degrees) * yoff - floatsin(rot, degrees) * xoff + y;
    z = zoff + z;

    return 1;
}

this::OnCoolDown(vehicleid)
{
    VehicleInfo[vehicleid][vCooldown] = false;
}

IsWindowOpened(vehicleid)
{
    new wi_state[4];

	GetVehicleParamsCarWindows(vehicleid, wi_state[0], wi_state[1], wi_state[2], wi_state[3]);
	if (!wi_state[0]) return true;
	else 			 return false;
}

//Panels
decode_panels(panels, &front_left_panel, &front_right_panel, &rear_left_panel, &rear_right_panel, &windshield, &front_bumper, &rear_bumper)
{
    front_left_panel = panels & 15;
    front_right_panel = panels >> 4 & 15;
    rear_left_panel = panels >> 8 & 15;
    rear_right_panel = panels >> 12 & 15;
    windshield = panels >> 16 & 15;
    front_bumper = panels >> 20 & 15;
    rear_bumper = panels >> 24 & 15;
}
/*encode_panels(front_left_panel, front_right_panel, rear_left_panel, rear_right_panel, windshield, front_bumper, rear_bumper)
{
    return front_left_panel | (front_right_panel << 4) | (rear_left_panel << 8) | (rear_right_panel << 12) | (windshield << 16) | (front_bumper << 20) | (rear_bumper << 24);
}*/
 
//Doors
decode_doors(doors, &bonnet, &boot, &driver_door, &passenger_door, &behind_driver_door, &behind_passenger_door)
{
    bonnet = doors & 7;
    boot = doors >> 8 & 7;
    driver_door = doors >> 16 & 7;
    passenger_door = doors >> 24 & 7;
	behind_driver_door = doors >> 32 & 7;
	behind_passenger_door = doors >> 40 & 7;
}
/*encode_doors(bonnet, boot, driver_door, passenger_door)
{
    return bonnet | (boot << 8) | (driver_door << 16) | (passenger_door << 24);
}*/

encode_doors(bonnet, boot, driver_door, passenger_door, behind_driver_door, behind_passenger_door)
{
   // #pragma unused behind_driver_door
   // #pragma unused behind_passenger_door

    return bonnet | (boot << 8) | (driver_door << 16) | (passenger_door << 24) | (behind_driver_door << 32) | (behind_passenger_door << 40);
}

 
//Lights
decode_lights(lights, &front_left_light, &front_right_light, &back_lights)
{
    front_left_light = lights & 1;
    front_right_light = lights >> 2 & 1;
    back_lights = lights >> 6 & 1;
}
/*encode_lights(front_left_light, front_right_light, back_lights)
{
    return front_left_light | (front_right_light << 2) | (back_lights << 6);
}*/
 
//Tires
decode_tires(tires, &rear_right_tire, &front_right_tire, &rear_left_tire, &front_left_tire)
{
    rear_right_tire = tires & 1;
    front_right_tire = tires >> 1 & 1;
    rear_left_tire = tires >> 2 & 1;
    front_left_tire = tires >> 3 & 1;
}
/*encode_tires(rear_right_tire, front_right_tire, rear_left_tire, front_left_tire)
{
	return rear_right_tire | (front_right_tire << 1) | (rear_left_tire << 2) | (front_left_tire << 3);
}*/

GetVehicleStatus(playerid, &dmg_panel, &dmg_door, &dmg_light, &dmg_tire)
{
	new vehicle = GetPlayerVehicleID(playerid);
	if (!vehicle) 	return 1;

	new panels, doors, lights, tires,
		panel[7], door[6], light[3], tire[4];

	GetVehicleDamageStatus(vehicle, panels, doors, lights, tires);
			
	decode_panels(panels, panel[0], panel[1], panel[2], panel[3], panel[4], panel[5], panel[6]);
	decode_doors(doors, door[0], door[1], door[2], door[3], door[4], door[5]);
	decode_lights(lights, light[0], light[1], light[2]);
	decode_tires(tires, tire[0], tire[1], tire[2], tire[3]);

	for(new i; i < sizeof(panels); i++) if (panel[i]) 	dmg_panel++; 
	for(new i; i < sizeof(door); i++) 	if (door[i]) 	dmg_door++; 
	for(new i; i < sizeof(light); i++) 	if (light[i]) 	dmg_light++; 
	for(new i; i < sizeof(tire); i++)	if (tire[i]) 	dmg_tire++; 

	dmg_panel = 	floatround(dmg_panel*100/sizeof(panel), floatround_round);
	dmg_door =		floatround(dmg_door*100/sizeof(door), floatround_round);
	dmg_light =		floatround(dmg_light*100/sizeof(light), floatround_round);
	dmg_tire = 		floatround(dmg_tire*100/sizeof(tire), floatround_round);

	return 1;
}

this::RepairAll(playerid, response)
{
    if (!response)    return 1;
	if (!IsDriver(playerid))	return SendNotInVehicle(playerid);
	
	new
		vehicle = GetPlayerVehicleID(playerid),
		bizid = PAS_Nearest(playerid)
	;

	if (bizid == -1)												return SendErrorMessage(playerid, "Khong co dich vu xe o to gan ban.");
	if (VehicleInfo[vehicle][carEngineOn])							return SendErrorMessage(playerid, "Dung dong co truoc khi bat dau sua chua.");
	if (BizInfo[bizid][bizLocked])									return GameTextForPlayer(playerid, "~r~DONG!", 2500, 1);
    if (BizInfo[bizid][bizOwnerID] && !BizInfo[bizid][bizProduct])	return SendErrorMessage(playerid, "Khong co du cac bo phan trong dich vu xe o to.");
	
	new Float: health;
	AntiCheatGetVehicleHealth(GetPlayerVehicleID(playerid), health);

	new panels, doors, lights, tires;
	GetVehicleStatus(playerid, panels, doors, lights, tires);

	new
		model = GetVehicleModel(vehicle),
		hp_cost = floatround(((health/GetVehicleMaxHealth(model))) * (GetVehiclePrice(model)/1000), floatround_round),
		cost = floatround(GetVehiclePrice(model) / 4, floatround_round),
		common_cost = hp_cost +  floatround((cost * 0.5 * panels/100) + (cost * 0.25 * doors/100) + (cost * 0.1 * lights/100) + (cost * 0.15 * tires/100), floatround_round)
	;

	if (GetCash(playerid) < common_cost)	return SendErrorMessage(playerid, "De sua chua, ban can $%i. ", common_cost);

	StartVehicleUpgrade(playerid, vehicle, 13, common_cost);
	UpdateDynamic3DTextLabelText(status_update[vehicle], 0x33AA33FF, "(( ---------- ))\nSUA CHUA PHUONG TIEN");
	return 1;
}

this::RepairList(playerid, response)
{
    if (!response)    return 1;
	if (!IsDriver(playerid))	return SendNotInVehicle(playerid);
	
	new
		vehicle = GetPlayerVehicleID(playerid),
		bizid = PAS_Nearest(playerid)
	;

	if (bizid == -1)												return SendErrorMessage(playerid, "Khong co dich vu xe o to gan ban.");
	if (VehicleInfo[vehicle][carEngineOn])							return SendErrorMessage(playerid, "Dung dong co truoc khi bat dau sua chua.");
	if (BizInfo[bizid][bizLocked])									return GameTextForPlayer(playerid, "~r~DONG!", 2500, 1);
    if (BizInfo[bizid][bizOwnerID] && !BizInfo[bizid][bizProduct])	return SendErrorMessage(playerid, "Khong co du cac bo phan trong dich vu xe o to.");

	new panels, doors, lights, tires;
	GetVehicleStatus(playerid, panels, doors, lights, tires);

	new cost = GetPVarInt(playerid, #auto_cost);

	if (GetCash(playerid) < cost)	return SendErrorMessage(playerid, "De sua chua, ban can $%i. ", cost);

	StartVehicleUpgrade(playerid, vehicle, 13, cost);
	UpdateDynamic3DTextLabelText(status_update[vehicle], 0x33AA33FF, "(( ---------- ))\nSUA CHUA PHUONG TIEN");
	return 1;
}

this::RepairHP(playerid, response)
{
    if (!response)    return 1;
	if (!IsDriver(playerid))	return SendNotInVehicle(playerid);
	
	new
		vehicle = GetPlayerVehicleID(playerid),
		bizid = PAS_Nearest(playerid)
	;

	if (bizid == -1)												return SendErrorMessage(playerid, "Khong co dich vu xe o to gan ban.");
	if (VehicleInfo[vehicle][carEngineOn])							return SendErrorMessage(playerid, "Dung dong co truoc khi bat dau sua chua.");
	if (BizInfo[bizid][bizLocked])									return GameTextForPlayer(playerid, "~r~DONG!", 2500, 1);
    if (BizInfo[bizid][bizOwnerID] && !BizInfo[bizid][bizProduct])	return SendErrorMessage(playerid, "Khong co du cac bo phan trong dich vu xe o to.");
	
	new Float: health;
	AntiCheatGetVehicleHealth(GetPlayerVehicleID(playerid), health);

	new panels, doors, lights, tires;
	GetVehicleStatus(playerid, panels, doors, lights, tires);

	new
		model = GetVehicleModel(vehicle),
		hp_cost = floatround(((health/GetVehicleMaxHealth(model))) * (GetVehiclePrice(model)/1000), floatround_round)
	;

	if (GetCash(playerid) < hp_cost)	return SendErrorMessage(playerid, "De sua chua, ban can $%i.", hp_cost);

	StartVehicleUpgrade(playerid, vehicle, 15, hp_cost);
	UpdateDynamic3DTextLabelText(status_update[vehicle], 0x33AA33FF, "(( ---------- ))\nSUA CHUA PHUONG TIEN");
	return 1;
}

this::ChangeBattery(playerid, response)
{
    if (!response)    return 1;
	
	new
		vehicle = GetPlayerVehicleID(playerid),
		bizid = PAS_Nearest(playerid)
	;

	if (bizid == -1)												return SendErrorMessage(playerid, "Khong co dich vu xe o to gan ban.");
	if (VehicleInfo[vehicle][carEngineOn])							return SendErrorMessage(playerid, "Dung dong co truoc khi bat dau sua chua.");
	if (BizInfo[bizid][bizLocked])									return GameTextForPlayer(playerid, "~r~DONG!", 2500, 1);
    if (BizInfo[bizid][bizOwnerID] && !BizInfo[bizid][bizProduct])	return SendErrorMessage(playerid, "Khong co du cac bo phan trong dich vu xe o to.");

	new cost = GetVehiclePrice(GetVehicleModel(vehicle)) / 100 * 5;

	if (cost < 1)					return 1;
	if (GetCash(playerid) < cost)	return SendErrorMessage(playerid, "Chi phi thay doi ac quy la $%i.", cost);

	if (GetCash(playerid) < cost)	return SendErrorMessage(playerid, "De sua chua, ban can $%i. ", cost);

	StartVehicleUpgrade(playerid, vehicle, 11, cost);
	return 1;
}

this::ChangeEngine(playerid, response)
{
    if (!response)    return 1;
	
	new
		vehicle = GetPlayerVehicleID(playerid),
		bizid = PAS_Nearest(playerid)
	;

	if (bizid == -1)												return SendErrorMessage(playerid, "Khong co dich vu xe o to gan ban.");
	if (VehicleInfo[vehicle][carEngineOn])							return SendErrorMessage(playerid, "Dung dong co truoc khi bat dau sua chua.");
	if (BizInfo[bizid][bizLocked])									return GameTextForPlayer(playerid, "~r~DONG!", 2500, 1);
    if (BizInfo[bizid][bizOwnerID] && !BizInfo[bizid][bizProduct])	return SendErrorMessage(playerid, "Khong co du cac bo phan trong dich vu xe o to.");

	new cost = GetVehiclePrice(GetVehicleModel(vehicle)) / 100 * 10;

	if (cost < 1) 					return 1;
	if (GetCash(playerid) < cost)	return SendErrorMessage(playerid, "Chi phi thay doi dong co la $%i.", cost);

	if (GetCash(playerid) < cost)	return SendErrorMessage(playerid, "De sua chua, ban can $%i. ", cost);

	StartVehicleUpgrade(playerid, vehicle, 9, cost);
	return 1;
}

this::ConfirmFilling(playerid, response)
{
    if (!response)    return 1;

	new vehicle = GetPlayerVehicleID(playerid), bizid;

	if (!IsDriver(playerid))					return SendNotInVehicle(playerid);
	if ((bizid = AZC_Nearest(playerid)) == -1)	return SendErrorMessage(playerid, "Khong co tram xang nao gan ban.");
	if (VehicleInfo[vehicle][carEngineOn])		return SendErrorMessage(playerid, "Dung dong co truoc khi tiep nhien lieu.");
	if (BizInfo[bizid][bizLocked])				return GameTextForPlayer(playerid, "~r~DONG!", 2500, 1);
	
    if (BizInfo[bizid][bizOwnerID] && !BizInfo[bizid][bizProduct])	return SendErrorMessage(playerid, "Khong co du nhien lieu tai tram xang.");
	
	SendSyntaxMessage(playerid, "De hoan tat tiep nhien lieu, hay nhap /dien.");

	SetPVarInt(playerid, #UsePump, bizid+1);
	RefuelTimer[playerid] = SetTimerEx("Refuel", 350, true, "iii", playerid, vehicle, bizid);
	return 1;

	//fuelneed = GetVehicleFuelCapacity(modelid) - VehicleInfo[vehicle][carFuel]
	//SetPVarInt(playerid, #bizid, bizid);
	//StartVehicleUpgrade(playerid, vehicle, 12, BizInfo[bizid][bizEntrance]*fuelpay);
	//UpdateDynamic3DTextLabelText(status_update[vehicle], 0x33AA33FF, "(( ---------- ))\n�������� ����������");
}

this::Refuel(playerid, vehicleid, bizid)
{
    new price, Float: f_price,  modelid = GetVehicleModel(vehicleid);
	
	if (GetVehicleModelInfoAsInt(modelid, "TransmissionData_nEngineType") == 'P') 	  f_price = float(BizInfo[bizid][bizEntrance]) * 1.2 * 0.5;
	else if (GetVehicleModelInfoAsInt(modelid, "TransmissionData_nEngineType") == 'E') f_price = float(BizInfo[bizid][bizEntrance]) * 0.8 * 0.5;
	else f_price = float(BizInfo[bizid][bizEntrance]) * 0.5;
	
	price = floatround(f_price, floatround_round);
    if (GetPlayerMoney(playerid) < price)
    {
        Fuel_ResetPlayer(playerid);
        ToggleVehicleEngine(vehicleid, playerid);
        return SendNotCash(playerid);
    }
 
    SetPVarFloat(playerid, #FuelBought, GetPVarFloat(playerid, #FuelBought) + 0.5);
    VehicleInfo[vehicleid][carFuel] += 0.5;
	GiveCash(playerid, -price);
	GiveBizCash(bizid, price);
 
    new string[75];
    format(string, sizeof(string), "~b~~h~Tiep nhien lieu phuong tien...~n~~n~~w~Gia: ~g~~h~$%d ~y~~h~(%.2fL)", floatround(GetPVarFloat(playerid, #FuelBought) * float(price)), GetPVarFloat(playerid, #FuelBought));
    PlayerTextDrawSetString(playerid, FuelText[playerid], string);
	PlayerTextDrawShow(playerid, FuelText[playerid]);
 
    if (VehicleInfo[vehicleid][carFuel] > GetVehicleFuelCapacity(modelid))
    {
        VehicleInfo[vehicleid][carFuel] = GetVehicleFuelCapacity(modelid);
        Fuel_ResetPlayer(playerid);
        ToggleVehicleEngine(vehicleid, playerid);
    }
 
    return 1;
}