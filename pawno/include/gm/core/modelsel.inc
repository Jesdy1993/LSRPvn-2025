public OnModelSelectionResponse(playerid, extraid, index, modelid, response)
{
	if (extraid == MODEL_SELECTION_COLOR && response == MODEL_RESPONSE_SELECT)
	{
	    if (GetPVarInt(playerid, #veh_color_type) == 1)
	    {
		    new vehicle = GetPlayerVehicleID(playerid);

			if (!IsPlayerInAnyVehicle(playerid) || !VehicleInfo[vehicle][carOwnerID]) return 1;

		    if (GetPVarInt(playerid, #veh_color1) == -1)
		    {
		        SetPVarInt(playerid, #veh_color1, index);

		        new vehiclescolor[256], List:colors = list_new();
				for(new i; i < 256; i++)
				{
					vehiclescolor[i] = i;
					AddModelMenuItem(colors, 400, "", true, -87.00, 0.0, 270.0, 0.190, vehiclescolor[i], vehiclescolor[i]);
				}
				wait_ms(100);
				ShowModelSelectionMenu(playerid, "Colors", MODEL_SELECTION_COLOR, colors);
		    	//ShowColorSelectionMenu(playerid, MODEL_SELECTION_COLOR, colors, sizeof(colors));
				return 1;
			}
		    StartVehicleUpgrade(playerid, vehicle, 10, 100, GetPVarInt(playerid, #veh_color1), index);
		}

		if (GetPVarInt(playerid, #veh_color_type) == 2)
	    {
		    new vehicle = GetPlayerVehicleID(playerid);

			if (!IsPlayerInAnyVehicle(playerid) || !VehicleInfo[vehicle][carOwnerID]) return 1;

		    if (GetPVarInt(playerid, #veh_color1) == -1)
		    {
		        SetPVarInt(playerid, #veh_color1, index);

		       	new vehiclescolor[256], List:colors = list_new();
				for(new i; i < 256; i++)
				{
					vehiclescolor[i] = i;
					AddModelMenuItem(colors, 400, "", true, -87.00, 0.0, 270.0, 0.190, vehiclescolor[i], vehiclescolor[i]);
				}
				wait_ms(100);
				ShowModelSelectionMenu(playerid, "Colors", MODEL_SELECTION_COLOR, colors);
				return 1;
			}
		    StartVehicleUpgrade(playerid, vehicle, 10, 500, GetPVarInt(playerid, #veh_color1), index);
		}
	    return 1;
	}
	if (extraid == MODEL_BUING_COLOR && response == MODEL_RESPONSE_SELECT)
	{
		SetPVarInt(playerid, #veh_color_type, 0);
		SetPVarInt(playerid, #veh_color1, index);

		new vehiclescolor[256], List:colors = list_new();
		for(new i; i < 256; i++)
		{
			vehiclescolor[i] = i;
			AddModelMenuItem(colors, 400, "", true, -87.00, 0.0, 270.0, 0.190, vehiclescolor[i], vehiclescolor[i]);
		}
		SendSyntaxMessage(playerid, "Vui long chon mau {ffc46a}thu hai{FFFFFF}."); 
		wait_ms(100);
		ShowModelSelectionMenu(playerid, "Colors", MODEL_BUING_COLOR2, colors);
	    return 1;
	}
	if (extraid == MODEL_BUING_COLOR2 && response == MODEL_RESPONSE_SELECT)
	{
		SendSyntaxMessage(playerid, "Vui long chon mau {ffc46a}thu hai{FFFFFF}."); 
		SetPVarInt(playerid, #veh_color2, index);
		ShowBuyingVehicleDetails(playerid);
	    return 1;
	}
	if (extraid == MODEL_SELECTION_BB && response == MODEL_RESPONSE_SELECT) 
	{
		if (response)
        {
            if (GetUnusedBillBoard() == -1) return SendErrorMessage(playerid, "Da vuot qua gioi han.");
	         
			new Float:X, Float:Y, Float:Z;
	        GetPlayerPos(playerid, X, Y, Z);

	        CreateBillBoard(playerid, X, Y, Z, 0.0, 0.0, 0.0, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid), modelid, GetPVarInt(playerid, #BB_COST));
			DeletePVar(playerid, #BB_COST);
		}
		else DeletePVar(playerid, #BB_COST);

		return 1;
	}
	if(extraid == VEHICLE_SPOILERS && response == MODEL_RESPONSE_SELECT) 
	{
		new 
		vehicle = GetPVarInt(playerid, #veh_editor), 
		carslot = GetPVarInt(playerid, #veh_slot), 
		attobj = car_spoilers[index],

		Float:x, 
		Float:y, 
		Float:z
		;

		GetVehiclePos(vehicle, x, y, z);
		VehicleInfo[vehicle][carAttach][carslot] = CreateDynamicObject(attobj, x, y, z+2, 0.0, 0.0, 0.0);
		
		SetPVarInt(playerid, #veh_obj, attobj);
		SetPVarInt(playerid, "Vehicle:AttEdit", 0);

		EditDynamicObject(playerid, VehicleInfo[vehicle][carAttach][carslot]);
			
		if (IsPlayerInAnyVehicle(playerid))
		{
			InfoMSG(playerid, "ban co the su dung \"~y~W~w~\"~n~de di chuyen camera xung quanh", 5);
		}	
		else
		{
			InfoMSG(playerid, "ban co the su dung \"~y~SPACE~w~\",~n~de di chuyen camera xung quanh", 5);
		}								
	}
	if(extraid == VEHICLE_REARBUMPER && response == MODEL_RESPONSE_SELECT) 
	{
		new 
		vehicle = GetPVarInt(playerid, #veh_editor), 
		carslot = GetPVarInt(playerid, #veh_slot), 
		attobj = car_rearbumper[index],

		Float:x, 
		Float:y, 
		Float:z
		;

		GetVehiclePos(vehicle, x, y, z);
		VehicleInfo[vehicle][carAttach][carslot] = CreateDynamicObject(attobj, x, y, z+2, 0.0, 0.0, 0.0);
		
		SetPVarInt(playerid, #veh_obj, attobj);
		SetPVarInt(playerid, "Vehicle:AttEdit", 0);

		EditDynamicObject(playerid, VehicleInfo[vehicle][carAttach][carslot]);
			
		if (IsPlayerInAnyVehicle(playerid))
		{
			InfoMSG(playerid, "ban co the su dung \"~y~W~w~\"~n~de di chuyen camera xung quanh", 5);
		}	
		else
		{
			InfoMSG(playerid, "ban co the su dung \"~y~SPACE~w~\",~n~de di chuyen camera xung quanh", 5);
		}								
	}
	if(extraid == VEHICLE_FRONTBUMPER && response == MODEL_RESPONSE_SELECT) 
	{
		new 
		vehicle = GetPVarInt(playerid, #veh_editor), 
		carslot = GetPVarInt(playerid, #veh_slot), 
		attobj = car_frontbumper[index],

		Float:x, 
		Float:y, 
		Float:z
		;

		GetVehiclePos(vehicle, x, y, z);
		VehicleInfo[vehicle][carAttach][carslot] = CreateDynamicObject(attobj, x, y, z+2, 0.0, 0.0, 0.0);
		
		SetPVarInt(playerid, #veh_obj, attobj);
		SetPVarInt(playerid, "Vehicle:AttEdit", 0);

		EditDynamicObject(playerid, VehicleInfo[vehicle][carAttach][carslot]);
			
		if (IsPlayerInAnyVehicle(playerid))
		{
			InfoMSG(playerid, "ban co the su dung \"~y~W~w~\"~n~de di chuyen camera xung quanh", 5);
		}	
		else
		{
			InfoMSG(playerid, "ban co the su dung \"~y~SPACE~w~\",~n~de di chuyen camera xung quanh", 5);
		}								
	}
	if(extraid == VEHICLE_SIDESKIRTR && response == MODEL_RESPONSE_SELECT) 
	{
		new 
		vehicle = GetPVarInt(playerid, #veh_editor), 
		carslot = GetPVarInt(playerid, #veh_slot), 
		attobj = car_frontbumper[index],

		Float:x, 
		Float:y, 
		Float:z
		;

		GetVehiclePos(vehicle, x, y, z);
		VehicleInfo[vehicle][carAttach][carslot] = CreateDynamicObject(attobj, x, y, z+2, 0.0, 0.0, 0.0);
		
		SetPVarInt(playerid, #veh_obj, attobj);
		SetPVarInt(playerid, "Vehicle:AttEdit", 0);

		EditDynamicObject(playerid, VehicleInfo[vehicle][carAttach][carslot]);
			
		if (IsPlayerInAnyVehicle(playerid))
		{
			InfoMSG(playerid, "ban co the su dung \"~y~W~w~\"~n~de di chuyen camera xung quanh", 5);
		}	
		else
		{
			InfoMSG(playerid, "ban co the su dung \"~y~SPACE~w~\",~n~de di chuyen camera xung quanh", 5);
		}								
	}
	if(extraid == VEHICLE_SIDESKIRTL && response == MODEL_RESPONSE_SELECT) 
	{
		new 
		vehicle = GetPVarInt(playerid, #veh_editor), 
		carslot = GetPVarInt(playerid, #veh_slot), 
		attobj = car_frontbumper[index],

		Float:x, 
		Float:y, 
		Float:z
		;

		GetVehiclePos(vehicle, x, y, z);
		VehicleInfo[vehicle][carAttach][carslot] = CreateDynamicObject(attobj, x, y, z+2, 0.0, 0.0, 0.0);
		
		SetPVarInt(playerid, #veh_obj, attobj);
		SetPVarInt(playerid, "Vehicle:AttEdit", 0);

		EditDynamicObject(playerid, VehicleInfo[vehicle][carAttach][carslot]);
			
		if (IsPlayerInAnyVehicle(playerid))
		{
			InfoMSG(playerid, "ban co the su dung \"~y~W~w~\"~n~de di chuyen camera xung quanh", 5);
		}	
		else
		{
			InfoMSG(playerid, "ban co the su dung \"~y~SPACE~w~\",~n~de di chuyen camera xung quanh", 5);
		}								
	}
	if(extraid == SKIN_MALES && response == MODEL_RESPONSE_SELECT)
	{
		new selected;
		if (PlayerInfo[playerid][pSex] == 1)	selected = male_skins[index];
		else								selected = female_skins[index];

		if (selected < 1 || selected > 311) return 1;

		if (GetCash(playerid) < 100)	return SendNotCash(playerid);
		if (GetPlayerSkin(playerid) == selected || PlayerInfo[playerid][pTog][0] == selected || PlayerInfo[playerid][pTog][1] == selected || PlayerInfo[playerid][pTog][2] == selected) 
		{
			return SendErrorMessage(playerid, "Ban da mau trang phuc nay roi.");
		}

		new mes[128];

		for(new i; i != 3; i++)
		{
			if (PlayerInfo[playerid][pTog][i] == 0)	strcat(mes, "\n[Trong]");
			else									format(mes, sizeof(mes), "%s\n[Trang phuc #%i]", mes, PlayerInfo[playerid][pTog][i]);
		}

		Dialog_Show(playerid, BuyClothes, DIALOG_STYLE_LIST, "Chon mot vi tri ...", mes, "Thay doi", "X");
		SetPVarInt(playerid, "clothes_model", selected);
	}
	if(extraid == SKIN_FEMALES && response == MODEL_RESPONSE_SELECT)
	{
		new selected;
		if (PlayerInfo[playerid][pSex] == 1)	selected = male_skins[index];
		else								selected = female_skins[index];

		if (selected < 1 || selected > 311) return 1;

		if (GetCash(playerid) < 100)	return SendNotCash(playerid);
		if (GetPlayerSkin(playerid) == selected || PlayerInfo[playerid][pTog][0] == selected || PlayerInfo[playerid][pTog][1] == selected || PlayerInfo[playerid][pTog][2] == selected) 
		{
			return SendErrorMessage(playerid, "Ban da mau trang phuc nay roi.");
		}

		new mes[128];

		for(new i; i != 3; i++)
		{
			if (PlayerInfo[playerid][pTog][i] == 0)	strcat(mes, "\n[Trong]");
			else									format(mes, sizeof(mes), "%s\n[Trang phuc #%i]", mes, PlayerInfo[playerid][pTog][i]);
		}

		Dialog_Show(playerid, BuyClothes, DIALOG_STYLE_LIST, "Chon mot vi tri ...", mes, "Thay doi", "X");
		SetPVarInt(playerid, "clothes_model", selected);
	}
	if(extraid == MODEL_BUY_VEHICLE && response == MODEL_RESPONSE_SELECT)
	{
		new price, selected;

		switch(GetPVarInt(playerid, #Selection))
		{
			case 0: selected = b_class_model[index];
			case 1: selected = lowride_class_model[index];
			case 2: selected = a_class_model[index];
			case 3: selected = sport_model[index];
			case 4: selected = pickups_class_model[index];
			case 5: selected = offroad_model[index];
			case 6: selected = industrial_model[index];
			case 7: selected = motobike_model[index];
			case 8: selected = other_model[index];
			case 9: selected = donate_model[index];
			case 10: selected = boat_model[index];
			case 11: selected = fly_model[index];
			case 12: selected = dealership_model[index];
		}
		
		DeletePVar(playerid, #Selection);

		if ((price = GetVehiclePrice(selected)) == 0)	return SendErrorMessage(playerid, "Phuong tien nay khong co san.");
				
		if (!PlayerInfo[playerid][pPremium] && IsDonateVehicle(selected))	return SendErrorMessage(playerid, "Chi nguoi choi co tai khoan Premium moi co the mua chiec xe nay..");
		if (PlayerInfo[playerid][pPremium] < 1 && IsBronzeVehicle(selected))	return SendErrorMessage(playerid, "De mua phuong tien nay, tai khoan cua ban phai co Bronze Premium hoac tro len.");
		if (PlayerInfo[playerid][pPremium] < 2 && IsSilverVehicle(selected))	return SendErrorMessage(playerid, "De mua phuong tien nay, tai khoan cua ban phai co Silver Premium hoac tro len.");
		if (PlayerInfo[playerid][pPremium] < 3 && IsGoldVehicle(selected))	return SendErrorMessage(playerid, "De mua phuong tien nay, tai khoan cua ban phai co Gold Premium hoac tro len.");

		DeletePVar(playerid, "BuyingVehicleModel");
		SetPVarInt(playerid, "BuyingVehicleRegister", 0);
		SetPVarInt(playerid, "BuyingVehicleAlarm", 0);
		SetPVarInt(playerid, "BuyingVehicleLock", 0);
		SetPVarInt(playerid, "BuyingVehicleImmob", 0);
		SetPVarInt(playerid, "BuyingVehicleInsurance", 0);
		SetPVarInt(playerid, "BuyingVehicleRadio", 0);
		SetPVarInt(playerid, "BuyingVehicleGps", 0);
		SetPVarInt(playerid, "BuyingVehicleModel", selected);

		new mes[56];

		format(mes, sizeof(mes), "{ffffff}%s - {35B835}$%s", VehicleNames[selected-400], FormatNumber(price));

		if (selected == 481 || selected == 509 || selected == 510)
		{
			Dialog_Show(playerid, BuyingVehicleDone, DIALOG_STYLE_MSGBOX, mes, "Ban co chac chan muon mua chiec xe nay khong?", "Co", "Huy bo");
		}
		else
		{
			SetPVarInt(playerid, #veh_color1, random(255));
			SetPVarInt(playerid, #veh_color2, random(255));

			new vehFuel[15], vehDrive[20];

			new Float:vehMass = GetVehicleModelInfoAsFloat(selected, "fMass"); 
							
			if (GetVehicleModelInfoAsInt(selected, "TransmissionData_nDriveType") == 'F')
				vehDrive = "Front-wheel drive";
			else if (GetVehicleModelInfoAsInt(selected, "TransmissionData_nDriveType") == 'R')
				vehDrive = "Rear drive";
			else if (GetVehicleModelInfoAsInt(selected, "TransmissionData_nDriveType") == '4')
				vehDrive = "Four-wheel drive";
												
			if (GetVehicleModelInfoAsInt(selected, "TransmissionData_nEngineType") == 'P')
				vehFuel = "Gasoline";
			else if (GetVehicleModelInfoAsInt(selected, "TransmissionData_nEngineType") == 'D')
				vehFuel = "Diesel";
			else if (GetVehicleModelInfoAsInt(selected, "TransmissionData_nEngineType") == 'E')
				vehFuel = "Electricity";
						
			static const str_size[] = "{ecc317}Gia: \t\t			{ffffff}$%s\n\
										{ecc317}Toc do toi da: \t		{ffffff}%.1f km/h\n\
										{ecc317}Trang thai toi da: \t		{ffffff}%.1f\n\
										{ecc317}Trong luong: \t\t		{ffffff}%.1f kf\n\n\
										{ecc317}Drive unit: \t		{ffffff}%s\n\
										{ecc317}Xang \t\t			{ffffff}%s\n\
										{ecc317}Su tieu thu: \t		{ffffff}%.1f l/100 km\n\
										{ecc317}Dung tich: \t	{ffffff}%.1f l\n\n";
										
			new string[sizeof(str_size) + 15 + 20 + 6 + 128*2 + 128],
				registerveh = price_reg[GetPVarInt(playerid, "BuyingVehicleRegister")];
			
			format(string, sizeof(string), str_size,
				FormatNumber(GetVehiclePrice(selected)), 
				GetVehicleMaxSpeed[selected-400], 
				GetVehicleMaxHealth(selected), 
				vehMass, 
				vehDrive, 
				vehFuel,
				GetVehicleFuelUsage(selected),
				GetVehicleFuelCapacity(selected)
			);

			format(string, sizeof(string), "%s{ecc317}Mau 1{ffffff} - [{%06x}#%i{ffffff}]\n{ecc317}Mau 2{ffffff} - [{%06x}#%i{ffffff}]\n\n", string, VehicleColoursTableRGBA[GetPVarInt(playerid, #veh_color1)] >>> 8, GetPVarInt(playerid, #veh_color1), VehicleColoursTableRGBA[GetPVarInt(playerid, #veh_color2)] >>> 8, GetPVarInt(playerid, #veh_color2));
			
			SetPVarInt(playerid, "BuyingVehicleRegister", 1);
			format(string, sizeof(string), "%s{ffffff}Dang ky: \t{ecc317}$%i\n{ecc317}+ {ffffff}Bien dang ky xe.\n\n", string, registerveh);

			format(string, sizeof(string), "%s{ffffff}Nhan vao '{ecc317}Xac nhan{ffffff}' de mua phuong tien.", string);

			Dialog_Show(playerid, BuyingVehicleList, DIALOG_STYLE_MSGBOX, mes, string, "Chinh sua", "Xac nhan");
		}
	}
	return 1;
}