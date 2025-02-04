CMD:rentcar(playerid, params[])
{
	new vehicle = GetPlayerVehicleID(playerid);
	
	if (!IsDriver(playerid))			return 1;
    if (!IsRentCar(vehicle))			return SendErrorMessage(playerid, "Phuong tien nay khong the thue");
	if (VehicleInfo[vehicle][carRent])	return SendErrorMessage(playerid,"Phuong tien nay da duoc thue.");
	if (pTemp[playerid][pRentveh])		return SendErrorMessage(playerid, "Ban da thue mot phuong tien. Nhap /unrentcar de ket thuc thue. ");
	if (GetCash(playerid) < 300)		return SendNotCash(playerid);
	    
	GiveCash(playerid, -300);
	pTemp[playerid][pRentveh] = vehicle;
    VehicleInfo[vehicle][carRent] = PlayerInfo[playerid][pID];
	SendSyntaxMessage(playerid, "Ban da thue %s voi gia $300. Cac lenh co san: /unrentcar, /v lock.", VehicleNames[GetVehicleModel(vehicle)-400]);
	SendSyntaxMessage(playerid, "Luu y! Neu ban khong su dung phuong tien trong 10 phut, no se bien mat. ");
	return 1;
}

CMD:unrentcar(playerid, params[])
{
    if (!pTemp[playerid][pRentveh]) return 1;
		
	new vehicle = pTemp[playerid][pRentveh];

    SendSyntaxMessage(playerid, "Ban da cham dut hop dong thue phuong tien %s.", VehicleNames[GetVehicleModel(vehicle)-400]);
	pTemp[playerid][pRentveh] = 0;
    VehicleInfo[vehicle][carRent] = 0;
    RespawnVehicle(vehicle);
	return 1;
}

CMD:unimpound(playerid, params[])
{
    new vehicle = GetPlayerVehicleID(playerid);

	if (!IsValidVehicle(PlayerInfo[playerid][pCarKey]))					return SendErrorMessage(playerid, "Phuong tien cua ban khong duoc tao ra.");
	if (!vehicle)														return SendNotInVehicle(playerid);
	if (VehicleInfo[vehicle][carOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Ban khong so huu phuong tien nay.");
	if (!VehicleInfo[vehicle][Impounded])								return SendErrorMessage(playerid, "Phuong tien cua ban khong bi tich thu. ");
	if (GetCash(playerid) < IMPOUND_FEE) 								return SendErrorMessage(playerid, "Khong du tien de thuc hien hanh dong nay ($%i).", IMPOUND_FEE);
	
	GiveCash(playerid, -IMPOUND_FEE);
	VehicleInfo[vehicle][Impounded] = 0;
	Save_Car(vehicle);

    SendSyntaxMessage(playerid, "Ban da lay %s cua ban tu bai do xe voi gia $%i.", VehicleNames[GetVehicleModel(vehicle)-400], IMPOUND_FEE);
	SendHelpMessage(playerid, "Dung quen de xe cua ban tu bai dau xe! (/park)");
	return 1;
}

ALTX:vehicle("/v");
CMD:vehicle(playerid, params[])
{
	if (PlayerInfo[playerid][pInjured] != 0 || GetPVarInt(playerid, "Freeze") || pTemp[playerid][pTaserTime] || pTemp[playerid][pCuffed] || PhoneInfo[playerid][current_page] == PAGE_NOTIFICATION || PlayerInfo[playerid][pJailed] != 0)
		return SendErrorMessage(playerid, "Ban khong the su dung chuc nang nay ngay bay gio.");

	new parametrs[13], arg[128], vehicle = GetPlayerVehicleID(playerid), model = GetVehicleModel(vehicle);

	if (sscanf(params, "s[13]S()[128]", parametrs, arg))
	{
		SendHelpMessage(playerid, "/(v)ehicle [tuy chon]");
		SendSyntaxMessage(playerid, "list | get | park | find | lock | hidenum | fakenum");
		SendSyntaxMessage(playerid, "corpse | tow | stats | fines | sell | sellto");
		SendClientMessageEx(playerid, COLOR_GRAD2, "CMD:{FFFFFF} /vmenu /mycars(/myv) /vfa /(en)gine /lights /trunk /hood /setstation(/ss) /(wi)ndow /unimpound");
		return 1;
	}

	else if (!strcmp(parametrs, "hidenum", true))
	{
		vehicle = GetNearVehicle(playerid, 4.0);

		if (!IsValidVehicle(PlayerInfo[playerid][pCarKey]))					return SendErrorMessage(playerid, "Phuong tien cua ban khong duoc tao ra.");
		if (!vehicle)														return SendErrorMessage(playerid, "Ban khong o gan phuong tien.");
		if (VehicleInfo[vehicle][carOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Ban khong so huu phuong tien nay.");
		if (VehicleInfo[vehicle][carFakePlate])								return SendErrorMessage(playerid, "Truoc tien, ban can loai bo bien so gia. ");
		if (!IsPlayerHasItem(playerid, INV_TOOLS)) 							return SendErrorMessage(playerid, "Ban khong co cong cu.");
		if (VehicleInfo[vehicle][carPlate] == '_') 							return SendErrorMessage(playerid, "Xe cua ban khong co bien so.");

		if (VehicleInfo[vehicle][carHidedPlate])
		{
			VehicleInfo[vehicle][carHidedPlate] = 0;
			SQL_SetInteger("cars", "hidednum", VehicleInfo[vehicle][carHidedPlate], VehicleInfo[vehicle][carID]);
			SetVehicleNumberPlate(vehicle, VehicleInfo[vehicle][carPlate]);
			SetVehicleToRespawn(vehicle);
			SendSyntaxMessage(playerid, "Ban da cat dat bien so tren xe. ");
		}
		else 
		{
			VehicleInfo[vehicle][carHidedPlate] = 1;
			SQL_SetInteger("cars", "hidednum", VehicleInfo[vehicle][carHidedPlate], VehicleInfo[vehicle][carID]);
			SetVehicleNumberPlate(vehicle, "_");
			SetVehicleToRespawn(vehicle);
			SendSyntaxMessage(playerid, "Ban da go bo bien so khoi xe. ");
		}
		return 1;
	}

	else if (!strcmp(parametrs, "fakenum", true))
	{
		vehicle = GetNearVehicle(playerid, 4.0);

		if (!IsValidVehicle(PlayerInfo[playerid][pCarKey]))					return SendErrorMessage(playerid, "Phuong tien cua ban khong duoc tao ra.");
		if (!vehicle)														return SendErrorMessage(playerid, "Ban khong o gan phuong tien.");
		if (VehicleInfo[vehicle][carOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Ban khong so huu phuong tien nay.");
		if (!IsPlayerHasItem(playerid, INV_FAKENUM)) 						return SendWarningMessage(playerid, "Ban khong co bien so gia.");
		if (VehicleInfo[vehicle][carHidedPlate])							return SendErrorMessage(playerid, "Bien so cua ban da bi xoa. (/v hidenum)");								
		
		if (VehicleInfo[vehicle][carFakePlate])
		{
			VehicleInfo[vehicle][carFakePlate] = 0;
			SQL_SetInteger("cars", "fakenum", VehicleInfo[vehicle][carFakePlate], VehicleInfo[vehicle][carID]);
			SetVehicleNumberPlate(vehicle, VehicleInfo[vehicle][carPlate]);
			SetVehicleToRespawn(vehicle);
			SendSyntaxMessage(playerid, "Ban da go bo bien so ra khoi xe");
		}
		else 
		{
			VehicleInfo[vehicle][carFakePlate] = 1;
			SQL_SetInteger("cars", "fakenum", VehicleInfo[vehicle][carFakePlate], VehicleInfo[vehicle][carID]);
			
			if (isempty(VehicleInfo[vehicle][carFakePlateS]))
			{
				format(VehicleInfo[vehicle][carFakePlateS], 24, "%s", GetVehicleNumber());
				SQL_SetString("cars", "fakenum_str", VehicleInfo[vehicle][carFakePlateS], VehicleInfo[vehicle][carID]);
			}

			SetVehicleNumberPlate(vehicle, VehicleInfo[vehicle][carFakePlateS]);
			SetVehicleToRespawn(vehicle);
			SendSyntaxMessage(playerid, "Ban da cai dat bien so tren xe. ");
		}
		return 1;
	}

	else if (!strcmp(parametrs, "menu", true)) return cmd::vmenu(playerid, "");
	    
	else if (!strcmp(parametrs, "fines", true))
	{
		cmd::vtickets(playerid, "");
	}

	else if (!strcmp(parametrs, "get", true))
	{
		if (PlayerInfo[playerid][pCarKey])
		{
			return SendErrorMessage(playerid, "Ban da co mot phuong tien xuat hien.");
		}	
		if (CountPlayerVehicles(playerid) == 0)
		{
			return SendErrorMessage(playerid, "Ban khong co bat ky phuong tien nao.");
		}
		if (GetPVarInt(playerid, #spawnveh_id) != 0)
		{
			CancelSelectTextDraw(playerid);
			PlayerTextDrawDestroy(playerid, VehSpawn[playerid][0]);
			PlayerTextDrawDestroy(playerid, VehSpawn[playerid][1]);
			PlayerTextDrawDestroy(playerid, VehSpawn[playerid][2]);
			PlayerTextDrawDestroy(playerid, VehSpawn[playerid][3]);
			PlayerTextDrawDestroy(playerid, VehSpawn[playerid][4]);
			PlayerTextDrawDestroy(playerid, VehSpawn[playerid][5]);
		}
		ShowVehicleList(playerid);
		return 1;
	}

	else if (!strcmp(parametrs, "park", true))
	{
		if (!IsValidVehicle(PlayerInfo[playerid][pCarKey]))					return SendErrorMessage(playerid, "Phuong tien cua ban khong duoc tao ra.");
		if (vehicle == 0)													return SendNotInVehicle(playerid);
		if (VehicleInfo[vehicle][carOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Ban khong so huu phuong tien nay.");
		if (VehicleInfo[vehicle][Impounded])									return SendErrorMessage(playerid, "Khi xe cua ban dang o trong bai dau xe, ban khong the su dung tinh nang nay. (/unimpound)");

		new Float:hp;
		AntiCheatGetVehicleHealth(vehicle, hp);

		if (hp < 250.0)									return SendErrorMessage(playerid, "Ban khong the dau xe nay vi no bi hu hong nang.");
		if (VehicleInfo[vehicle][carAttach3DtextUse])	return SendErrorMessage(playerid, "Cho da, hoat dong da duoc tien hanh.");
        
		GetVehiclePos(vehicle, VehicleInfo[vehicle][carParkX], VehicleInfo[vehicle][carParkY], VehicleInfo[vehicle][carParkZ]);
		GetVehicleZAngle(vehicle, VehicleInfo[vehicle][carParkA]);
		
		SendSyntaxMessage(playerid, "Phuong tien \"%s\" da dau.", VehicleNames[model-400]);
		VehicleInfo[vehicle][carHealth] = hp;
		SQL_SetFloat("cars", "health", VehicleInfo[vehicle][carHealth], VehicleInfo[vehicle][carID]);
		ResetVehicleStuff(vehicle, 1);
		DestroyVehicle(vehicle);
		PlayerInfo[playerid][pCarKey] = 0;
		VehicleInfo[vehicle][carOwnerPlayer] = INVALID_PLAYER_ID;

		return 1;
	}

	else if (!strcmp(parametrs, "sellto", true))
	{
		new userid, price;

		if (!IsValidVehicle(PlayerInfo[playerid][pCarKey]))									return SendErrorMessage(playerid, "Phuong tien cua ban khong duoc tao ra.");
		if (!vehicle)																		return SendNotInVehicle(playerid);
		if (VehicleInfo[vehicle][carOwnerID] != PlayerInfo[playerid][pID])					return SendErrorMessage(playerid, "Ban khong so huu phuong tien nay.");
		if (sscanf(arg, "ui", userid, price))												return SendHelpMessage(playerid, "/v sell [ID/Ten] [gia]");
        if (!IsPlayerLogged(userid))															return SendNotConnected(playerid);
		if (IsADonateModel(GetVehicleModel(vehicle)))										return SendErrorMessage(playerid,"Ban khong the ban xe duoc tang cho nguoi choi.");
        if (PlayerInfo[userid][pPremium] < 2 && VehicleInfo[vehicle][carComponent][5] != 0)	return SendErrorMessage(playerid, "Nguoi choi nay khong co quyen truy cap nitro. ");
		if (userid == playerid)																return 1;
		if (!IsABicycle(vehicle) && !VehicleInfo[vehicle][carRegistered])					return SendErrorMessage(playerid, "Phuong tien khong duoc dang ky.");
		if (!PlayerNearPlayer(3.0, playerid, userid))										return SendNotNearPlayer(playerid);
		if (IsValidVehicle(PlayerInfo[userid][pCarKey]))										return SendErrorMessage(playerid, "Nguoi choi nay da co mot phuong tien xuat hien.");
		if (price < 0 || price > 10000000)													return SendErrorMessage(playerid, "Gia chi tu $0 den $10,000,000.");

		SendSyntaxMessage(userid, "%s muon ban cho ban %s voi gia $%i. (Nhan {33AA33}Y{FFFFFF} de mua.)", GetNameEx(playerid), VehicleNames[GetVehicleModel(vehicle)-400], price);
		if (IsABicycle(vehicle))
		{
			SendSyntaxMessage(userid, "An toan: Khoa[%i]", VehicleInfo[vehicle][carLock]);
			SendSyntaxMessage(userid, "Khac: Mau sac[{%06x}#%i{FFFFFF}], Mau sac[{%06x}#%i{FFFFFF}]", VehicleColoursTableRGBA[VehicleInfo[vehicle][carColor1]] >>> 8, VehicleInfo[vehicle][carColor1], VehicleColoursTableRGBA[VehicleInfo[vehicle][carColor2]] >>> 8, VehicleInfo[vehicle][carColor2]);
		}
		else
		{
			SendSyntaxMessage(userid, "Vehicle status: Dong co[%.2f], Ac quy[%.2f], So dam[%.2f]",VehicleInfo[vehicle][carEngine], VehicleInfo[vehicle][carBattery], VehicleInfo[vehicle][carMilliage]);
			SendSyntaxMessage(userid, "An toan: Khoa[%i], Bao dong[%i], Immobilizer[%i], Bao hiem[%i]", VehicleInfo[vehicle][carLock], VehicleInfo[vehicle][carAlarm], VehicleInfo[vehicle][carImmob], VehicleInfo[vehicle][carInsurance]);
			
			if (VehicleInfo[vehicle][carArmour] > 0.0)	SendSyntaxMessage(userid, "Khac: Mau sac[{%06x}#%i{FFFFFF}], Mau sac[{%06x}#%i{FFFFFF}], Bien so[%s], Giap[%.2f], Dai cassette[%i]", VehicleColoursTableRGBA[VehicleInfo[vehicle][carColor1]] >>> 8, VehicleInfo[vehicle][carColor1], VehicleColoursTableRGBA[VehicleInfo[vehicle][carColor2]] >>> 8, VehicleInfo[vehicle][carColor2], VehicleInfo[vehicle][carPlate], VehicleInfo[vehicle][carArmour], VehicleInfo[vehicle][carRadio]);
			else										SendSyntaxMessage(userid, "Khac: Mau sac[{%06x}#%i{FFFFFF}], Mau sac[{%06x}#%i{FFFFFF}], Bien so[%s], Dai cassette[%i]", VehicleColoursTableRGBA[VehicleInfo[vehicle][carColor1]] >>> 8, VehicleInfo[vehicle][carColor1], VehicleColoursTableRGBA[VehicleInfo[vehicle][carColor2]] >>> 8, VehicleInfo[vehicle][carColor2], VehicleInfo[vehicle][carPlate], VehicleInfo[vehicle][carRadio]);
		}

		SendSyntaxMessage(playerid, "Ban de nghi %s mua \"%s\" cua minh voi gia $%i.", GetNameWithMask(userid), VehicleNames[GetVehicleModel(vehicle)-400], price);

		pTemp[userid][pCarPlayer] = playerid;
		pTemp[userid][pCarPrice] = price;
		SetPVarInt(userid, #accept_time, gettime() + 30);
		return 1;
	}

	else if (!strcmp(parametrs, "lock", true))
	{
	    if (PlayerInfo[playerid][pInjured] != 0 || GetPVarInt(playerid, "Freeze") || pTemp[playerid][pTaserTime] || pTemp[playerid][pCuffed])	return SendErrorMessage(playerid, "Ban khong the su dung chuc nang nay ngay bay gio.");
		
	    vehicle = 0;
		if ((vehicle = GetNearVehicle(playerid, 4.0)) != 0)
		{
		    if ((VehicleInfo[vehicle][carFaction] && VehicleInfo[vehicle][carFaction] == PlayerInfo[playerid][pFaction])
			 || pTemp[playerid][pRentveh] == vehicle
			 || PlayerInfo[playerid][pCarKey] == vehicle
			 || (PlayerInfo[playerid][pSpareKey] == VehicleInfo[vehicle][carID] && PlayerInfo[playerid][pSpareKey] != 0)
			 || IsWindowOpened(vehicle) && !VehicleInfo[vehicle][carFaction])
			{
			    PlaySound(playerid, 1145);
			    
				new mes[128];

			    if (VehicleInfo[vehicle][carLocked])		format(mes, sizeof(mes), "~w~%s ~g~MO", VehicleNames[GetVehicleModel(vehicle)-400]);
				else									format(mes, sizeof(mes), "~w~%s ~r~DONG", VehicleNames[GetVehicleModel(vehicle)-400]);
				GameTextForPlayer(playerid, mes, 2500, 4);

			    if (VehicleInfo[vehicle][carLocked])	format(mes, sizeof(mes), "mo khoa %s.", VehicleNames[GetVehicleModel(vehicle)-400]);
				else								format(mes, sizeof(mes), "dong khoa %s.", VehicleNames[GetVehicleModel(vehicle)-400]);
				SetPlayerChatBubble(playerid, mes, COLOR_PURPLE, 20.0, 4000);

			    ToggleVehicleLock(vehicle, (VehicleInfo[vehicle][carLocked]) ? (false): (true));
				return 1;
			}
			else {
				SendErrorMessage(playerid, "Ban khong co chia khoa xe!");
				SendHelpMessage(playerid, "De mo xe, nhap /vbreaklock (/vbl).");
			}
		}
	    return 1;
	}

	else if (!strcmp(parametrs, "find", true))
	{
		if (!IsValidVehicle(PlayerInfo[playerid][pCarKey]))	return SendErrorMessage(playerid, "Phuong tien cua ban khong duoc tao ra.");

		vehicle = PlayerInfo[playerid][pCarKey];

		if (!VehicleInfo[vehicle][carGps])			return SendErrorMessage(playerid, "Xe cua ban chua duoc cai dat GPS. ");
        if (IsPlayerInVehicle(playerid, vehicle))	return SendErrorMessage(playerid, "Ban dang su dung phuong tien cua minh. ");
		if (!VehicleEmpty(vehicle))					return SendErrorMessage(playerid, "Ai do dang su dung phuong tien cua ban bay gio.");
		if (GetVehicleInteriorEx(vehicle))			return SendErrorMessage(playerid, "Khong the tim thay phuong tien cua ban. (Trong noi that)");

		new Float:x, Float:y, Float:z;
		GetVehiclePos(vehicle, x, y, z);

		SendSyntaxMessage(playerid, "Phuong tien \"%s\" cua ban dang o \"%s\".", VehicleNames[GetVehicleModel(vehicle)-400], GetVehicleZone(vehicle));
		SendSyntaxMessage(playerid, "Vi tri cua chiec xe duoc danh dau tren ban do. (/removecp)");
		Waypoint_Set(playerid, x, y, z);
		return 1;
	}

	else if (!strcmp(parametrs, "tow", true))
	{
		if (!IsValidVehicle(PlayerInfo[playerid][pCarKey]))	return SendErrorMessage(playerid, "Phuong tien cua ban khong duoc tao ra.");

		vehicle = PlayerInfo[playerid][pCarKey];

		if (VehicleInfo[vehicle][carOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Ban khong so huu phuong tien nay.");
		if (VehicleInfo[vehicle][carAttach3DtextUse])						return SendErrorMessage(playerid, "Cho da, hoat dong da duoc tien hanh.");
		if (IsPlayerInVehicle(playerid, vehicle))							return SendErrorMessage(playerid, "Ban dang su dung phuong tien cua minh.");
		if (!VehicleEmpty(vehicle))											return SendErrorMessage(playerid, "Ai do dang su dung phuong tien cua ban bay gio.");
		if (!IsABicycle(vehicle) && !VehicleInfo[vehicle][carRegistered])	return SendErrorMessage(playerid, "Phuong tien nay khong duoc dang ky.");
		if (VehicleInfo[vehicle][Impounded])								return SendErrorMessage(playerid, "Khi xe cua ban dang o trong bai dau xe, ban khong the su dung chuc nang nay. (/unimpound)");
		if (GetCash(playerid) < 200)										return SendNotCash(playerid);

		SendSyntaxMessage(playerid, "Xe cua ban se duoc keo den cho dau xe sau 10 giay.");
        StartVehicleUpgrade(playerid, vehicle, 1, 200);
		UpdateDynamic3DTextLabelText(status_update[vehicle], 0x33AA33FF, "(( ---------- ))\nXE KEO");
		return 1;
	}

	else if (!strcmp(parametrs, "stats", true))
	{
		if (!IsValidVehicle(PlayerInfo[playerid][pCarKey]))	return SendErrorMessage(playerid, "Phuong tien cua ban khong duoc tao ra.");

  		vehicle = PlayerInfo[playerid][pCarKey];
		
		if (VehicleInfo[vehicle][carOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Ban khong so huu phuong tien nay.");

		new title[24], diatxt[512];
		format(title, sizeof(title), "%s", VehicleNames[GetVehicleModel(vehicle)-400]);

		if (IsABicycle(vehicle))
		{
			format(diatxt, sizeof(diatxt), "An toan:\n- Khoa\t[%i]\n", VehicleInfo[vehicle][carLock]);
			format(diatxt, sizeof(diatxt), "%sKhac:\n- Mau sac\t[{%06x}#%i{FFFFFF}]\n- Mau sac\t[{%06x}#%i{FFFFFF}]", diatxt, VehicleColoursTableRGBA[VehicleInfo[vehicle][carColor1]] >>> 8, VehicleInfo[vehicle][carColor1], VehicleColoursTableRGBA[VehicleInfo[vehicle][carColor2]] >>> 8, VehicleInfo[vehicle][carColor2]);
			Dialog_Show(playerid, None, DIALOG_STYLE_MSGBOX, title, diatxt, ">>", "");
			return 1;
		}

		format(diatxt, sizeof(diatxt), "{ecc317}Registration:{FFFFFF}\n");

		if (VehicleInfo[vehicle][carRegistered]) format(diatxt, sizeof(diatxt), "%s{FFFFFF}Bien so - %s\n", diatxt, VehicleInfo[vehicle][carPlate]);
		else 									format(diatxt, sizeof(diatxt), "%s{FF6347}KHONG CO BIEN SO XE{FFFFFF}\n", diatxt, VehicleInfo[vehicle][carPlate]);
		
		if (VehicleInfo[vehicle][carHidedPlate]) format(diatxt, sizeof(diatxt), "%s{FF6347}BIEN SO XE BI XOA{FFFFFF}\n", diatxt, VehicleInfo[vehicle][carPlate]);
		if (VehicleInfo[vehicle][carFakePlate])	format(diatxt, sizeof(diatxt), "%s{FF6347}BIEN SO XE GIA\n\t\t[%s]\n", diatxt, VehicleInfo[vehicle][carFakePlateS]);
																						  	
		format(diatxt, sizeof(diatxt), "%s\n{ecc317}Thong tin chinh:{FFFFFF}\n- Dong co\t\t[%.2f]\n- Ac quy\t\t[%.2f]\n- Nhien lieu\t\t[%.1f / %.0f]\n- So dam\t\t[%.2f]\n\n", diatxt, VehicleInfo[vehicle][carEngine], VehicleInfo[vehicle][carBattery], VehicleInfo[vehicle][carFuel], GetVehicleFuelCapacity(GetVehicleModel(vehicle)), VehicleInfo[vehicle][carMilliage]);
		format(diatxt, sizeof(diatxt), "%s{ecc317}An toan:{FFFFFF}\n- Khoa\t\t\t[%i]\n- Bao dong\t[%i]\n- Immobilizer\t[%i]\n- Bao hiem\t\t[%i]\n", diatxt, VehicleInfo[vehicle][carLock], VehicleInfo[vehicle][carAlarm], VehicleInfo[vehicle][carImmob], VehicleInfo[vehicle][carInsurance]);
		
		if (VehicleInfo[vehicle][carArmour] > 0.0) format(diatxt, sizeof(diatxt), "%sGiap\t[%.2f]\n", diatxt, VehicleInfo[vehicle][carArmour]);
		
		format(diatxt, sizeof(diatxt), "%s\n{ecc317}Khac:{FFFFFF}\n- XM Radio\t\t%s\n- Mau sac 1\t\t\t[{%06x}#%i{FFFFFF}]\n- Mau sac 2\t\t\t[{%06x}#%i{FFFFFF}]", diatxt, (VehicleInfo[vehicle][carRadio])?("{33AA33}Installed{FFFFFF}"):("{FF6347}None{FFFFFF}"), VehicleColoursTableRGBA[VehicleInfo[vehicle][carColor1]] >>> 8, VehicleInfo[vehicle][carColor1], VehicleColoursTableRGBA[VehicleInfo[vehicle][carColor2]] >>> 8, VehicleInfo[vehicle][carColor2]);
		
		Dialog_Show(playerid, None, DIALOG_STYLE_MSGBOX, title, diatxt, ">>", "");
		return 1;
	}

	else if (!strcmp(parametrs, "list", true))
	{
	    new query[128];
	    mysql_format(dbHandle, query, sizeof(query), "SELECT * FROM `cars` WHERE `owner` = %i", PlayerInfo[playerid][pID]);
		mysql_tquery(dbHandle, query, "ShowCarsForPlayer", "ii", playerid, playerid);
	    return 1;
	}
	else if (!strcmp(parametrs, "corpse", true))
	{	
		vehicle = GetNearVehicle(playerid, 4.0);
        if (vehicle == -1)							return SendErrorMessage(playerid, "Ban khong o gan phuong tien.");
 		if (!IsNearTrunk(vehicle, playerid, 2.0)) 	return SendErrorMessage(playerid, "Ban khong o gan cop xe! ");
		if (!VehicleInfo[vehicle][carTrunkLock])	return SendErrorMessage(playerid, "Cop xe phai duoc mo.");
		if (!VehicleInfo[vehicle][vCorp] && !CorpInfo[VehicleInfo[vehicle][vCorp]][cUsed]) return SendErrorMessage(playerid, "Khong co xac chet trong cop xe. ");
        
		new Float:pos[3];
		GetPlayerPos(playerid, pos[0], pos[1], pos[2]);

		DestroyDynamic3DTextLabel(CorpInfo[VehicleInfo[vehicle][vCorp]-1][cText]);
		
	    CorpInfo[VehicleInfo[vehicle][vCorp]-1][cText]=CreateDynamic3DTextLabel("(( XAC CHET ))\nnhan '~k~~GROUP_CONTROL_BWD~'", COLOR_LIGHTRED, pos[0]+0.75, pos[1], pos[2]-0.4, 50.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, 50.0);
		CorpInfo[VehicleInfo[vehicle][vCorp]-1][cX] = pos[0]+0.75;
	    CorpInfo[VehicleInfo[vehicle][vCorp]-1][cY] = pos[1];
	    CorpInfo[VehicleInfo[vehicle][vCorp]-1][cZ] = pos[2];
	    CorpInfo[VehicleInfo[vehicle][vCorp]-1][cVeh] = 0;
		CorpInfo[VehicleInfo[vehicle][vCorp]-1][cTime] = gettime();
		if (CorpInfo[VehicleInfo[vehicle][vCorp]-1][cType] == 0) {
			CorpInfo[VehicleInfo[vehicle][vCorp]-1][cBody]=CreateActor(CorpInfo[VehicleInfo[vehicle][vCorp]-1][cSkin], pos[0]+0.75, pos[1], pos[2], 0.0);
			SetActorInvulnerable(CorpInfo[VehicleInfo[vehicle][vCorp]-1][cBody], true);
			ApplyActorAnimation(CorpInfo[VehicleInfo[vehicle][vCorp]-1][cBody], "PED", "KO_shot_stom", 4.0, 0, 0, 0, 1, 0);
		} else {
			CorpInfo[VehicleInfo[vehicle][vCorp]-1][cBody]=CreateDynamicObject(19944, pos[0]+0.75, pos[1], pos[2]-0.5, 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
		}
		
	    VehicleInfo[vehicle][vCorp]=0;    
		SM2(playerid, "Ban loi mot cai xac ra khoi cop xe.");
		return 1;
	}
	else if (!strcmp(parametrs, "sell", true))
	{
		new veh = PlayerInfo[playerid][pCarKey], lockuse[200], alarmuse[300], immobuse[300], insuranceuse[350], xmradiouse[50], gpsuse[50], string1[1250];

		if (!IsValidVehicle(veh))											return SendErrorMessage(playerid, "Phuong tien cua ban khong duoc tao ra.");
		if (!IsPlayerInAnyVehicle(playerid))								return SendNotInVehicle(playerid);
		if (VehicleInfo[vehicle][carOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Ban khong so huu phuong tien nay.");

		if (VehicleInfo[veh][carLock] == 1) 	 lockuse = "{a9c4e4}Khoa: \t{bab9ba}1 cap do\t{e2bd63}$3.500\n{4af085}+{e2bd63}120 giay pha vo phuong tien.\n\n";
		else if (VehicleInfo[veh][carLock] == 2) lockuse = "{a9c4e4}Khoa: \t{bab9ba}2 cap do{e2bd63}$5.500\n{4af085}+{e2bd63}180 thoi gian cho bao ve chong lai phuong phap toc mach.\n\n";
		else if (VehicleInfo[veh][carLock] == 3) lockuse = "{a9c4e4}Khoa: \t{bab9ba}3 cap do\t{e2bd63}$7.500\n{4af085}+{e2bd63}240 thoi gian cho bao ve chong lai phuong phap toc mach.\n\n";
		else if (VehicleInfo[veh][carLock] == 4) lockuse = "{a9c4e4}Khoa: \t{bab9ba}4 cap do\t{e2bd63}$10.500\n{4af085}+{e2bd63}300 thoi gian cho bao ve chong lai phuong phap toc mach.\n\n";
		else if (VehicleInfo[veh][carLock] == 5) lockuse = "{a9c4e4}Khoa: \t{bab9ba}5 cap do\t{e2bd63}$13.500\n{4af085}+{e2bd63}360 thoi gian cho bao ve chong lai phuong phap toc mach.\n\n";

		if (VehicleInfo[veh][carAlarm] == 1) 		alarmuse = "{a9c4e4}Bao dong: \t{bab9ba}1 cap do\t{e2bd63}$2.600\n{f0634a}+{e2bd63}Bao dong xe lon.\n";
		else if (VehicleInfo[veh][carAlarm] == 2) 	alarmuse = "{a9c4e4}Bao dong: \t{bab9ba}2 cap do\t{e2bd63}$5.500\n{f0634a}+{e2bd63}Bao dong xe lon.\n{f0634a}+{e2bd63}Xe canh bao so canh sat dia phuong ve kha nang vi pham.\n\n";
		else if (VehicleInfo[veh][carAlarm] == 3) 	alarmuse = "{a9c4e4}Bao dong: \t{bab9ba}3 cap do\t{e2bd63}$8.000\n{f0634a}+{e2bd63}Bao dong xe lon.\n{f0634a}+{e2bd63}Xe canh bao so canh sat dia phuong ve kha nang vi pham.\n{f0634a}+{e2bd63}Thong bao SMS\n\n";
		else if (VehicleInfo[veh][carAlarm] == 4) 	alarmuse = "{a9c4e4}Bao dong: \t{bab9ba}4 cap do\t{e2bd63}$10.500\n{f0634a}+{e2bd63}Bao dong xe lon.\n{f0634a}+{e2bd63}Xe canh bao so canh sat dia phuong ve kha nang vi pham.\n{f0634a}+{e2bd63}Thong bao SMS\n{f0634a}+{e2bd63}Phuong tien danh dau tren radar.\n\n";

		if (VehicleInfo[veh][carImmob] == 1) 		immobuse = "{a9c4e4}Immobilizer: \t{bab9ba}1 cap do\t{e2bd63}$5.600\n{feff00}+{e2bd63}25 giay gioi han trong khi hotwiring.\n\n";
		else if (VehicleInfo[veh][carImmob] == 2) 	immobuse = "{a9c4e4}Immobilizer: \t{bab9ba}2 cap do\t{e2bd63}$11.300\n{feff00}+{e2bd63}50 giay gioi han trong khi hotwiring.\n\n";
		else if (VehicleInfo[veh][carImmob] == 3) 	immobuse = "{a9c4e4}Immobilizer: \t{bab9ba}3 cap do\t{e2bd63}$17.000\n{feff00}+{e2bd63}75 giay gioi han trong khi hotwiring.\n\n";
		else if (VehicleInfo[veh][carImmob] == 4) 	immobuse = "{a9c4e4}Immobilizer: \t{bab9ba}4 cap do\t{e2bd63}$22.600\n{feff00}+{e2bd63}100 giay gioi han trong khi hotwiring.\n\n";

		if (VehicleInfo[veh][carInsurance] == 1) 		insuranceuse = "{a9c4e4}Bao hiem: \t{bab9ba}1 cap do\t{e2bd63}$5.600\n{4a90f0}+{e2bd63}Xe se luon duoc tao ra voi luong mau toi da cua no.\n\n";
		else if (VehicleInfo[veh][carInsurance] == 2) 	insuranceuse = "{a9c4e4}Bao hiem: \t{bab9ba}2 cap do\t{e2bd63}$11.300\n{4a90f0}+{e2bd63}Xe se luon duoc tao ra voi luong mau toi da cua no.\n{4a90f0}+{e2bd63}Bao ve chong hu hong xe. Xe se tai sinh tot nhu moi.\n\n";
		else if (VehicleInfo[veh][carInsurance] == 3)	insuranceuse = "{a9c4e4}Bao hiem: \t{bab9ba}3 cap do\t{e2bd63}$17.000\n{4a90f0}+{e2bd63}Xe se luon duoc tao ra voi luong mau toi da cua no.\n{4a90f0}+{e2bd63}Bao ve chong hu hong xe. Xe se tai sinh tot nhu moi.\n{4a90f0}+{e2bd63}Pham vi sua doi phuong tien. Chung toi co bo cuc la mat va cac giai dieu XM cua ban.\n\n";

		if (VehicleInfo[veh][carRadio] == 1) xmradiouse = "{a9c4e4}XM Radio:\t{e2bd63}$7.500\n";
		if (VehicleInfo[veh][carGps] == 1) gpsuse = "{a9c4e4}GPS:\t{e2bd63}$3.500\n";

		new mes[56];

		if (IsABicycle(veh))	format(mes, sizeof(mes), "{33AA33}%s", VehicleNames[VehicleInfo[veh][carModel]-400]);
		else
		{
			if (VehicleInfo[veh][carRegistered])	format(mes, sizeof(mes), "{FFFFFF}%s [%s]", VehicleNames[VehicleInfo[veh][carModel]-400], VehicleInfo[veh][carPlate]);
			else								format(mes, sizeof(mes), "{FFFFFF}%s", VehicleNames[VehicleInfo[veh][carModel]-400]);
		}

		format(string1, sizeof(string1), "{ffffff}Gia ban:\t\t{e2bd63}$%i\n{ffffff}Do ben toi da:\t{e2bd63}%.2f\n\n%s%s%s%s%s%s", GetVehiclePrice(VehicleInfo[veh][carModel])/2, GetVehicleMaxHealth(GetVehicleModel(veh)), lockuse, alarmuse, immobuse, insuranceuse, xmradiouse, gpsuse);
		Dialog_Show(playerid, ScrapSell, DIALOG_STYLE_MSGBOX, mes, string1, "Chap nhan", "Huy bo");
		return 1;
	}
	else
	{
		SendHelpMessage(playerid, "/(v)ehicle [tuy chon]");
		SendSyntaxMessage(playerid, "list | get | park | find | lock | hidenum | fakenum | corpse");
		SendSyntaxMessage(playerid, "tow | stats | fines | sell | sellto | menu");
		SendClientMessageEx(playerid, COLOR_GRAD2, "CMD:{FFFFFF} /(en)gine /lights /trunk /hood /ss /(wi)ndow /unimpound");
	}
	return 1;
}

CMD:register(playerid, params[])
{
    if (!IsValidVehicle(PlayerInfo[playerid][pCarKey]))					return SendErrorMessage(playerid, "Phuong tien cua ban khong duoc tao ra.");

	new vehicle = PlayerInfo[playerid][pCarKey];

	if (VehicleInfo[vehicle][carOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Ban khong so huu phuong tien nay.");
	if (IsABicycle(vehicle))												return SendErrorMessage(playerid, "Ban khong the dang ky xe dap.");
	if (VehicleInfo[vehicle][carEngineOn])								return SendErrorMessage(playerid, "Dung dong co truoc khi sua doi phuong tien cua ban. ");
	if (VehicleInfo[vehicle][carAttach3DtextUse] != 0)					return SendErrorMessage(playerid, "Cho da, hoat dong da duoc tien hanh.");
	if (VehicleInfo[vehicle][carRegistered])								return SendErrorMessage(playerid, "Phuong tien nay da duoc dang ky.");
	if (GetCash(playerid) < 300)											return SendNotCash(playerid);

	if (!IsPlayerInRangeOfPoint(playerid, 5.0,2228.1577,-110.8875,26.6406))	return SendErrorMessage(playerid, "Ban phai o trong tru so canh sat o Palomino.");
    if (!IsVehicleInRangeOfPoint(vehicle, 15.0,697.6670,1624.8490,785.5494))	return SendErrorMessage(playerid, "Xe cua ban nen o gan tru so canh sat o Palomino.");
		
	StartVehicleUpgrade(playerid, vehicle, 7, 300);
	SendSyntaxMessage(playerid, "Qua trinh dang ky bat dau, se mat mot khoang thoi gian.");
	return 1;
}

CMD:unregister(playerid, params[])
{
    if (!IsValidVehicle(PlayerInfo[playerid][pCarKey]))					return SendErrorMessage(playerid, "Phuong tien cua ban khong duoc tao ra.");

	new vehicle = PlayerInfo[playerid][pCarKey];

	if (VehicleInfo[vehicle][carOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Ban khong so huu phuong tien nay.");
	if (IsABicycle(vehicle))												return SendErrorMessage(playerid, "Xe dap khong duoc dang ky. ");
	if (VehicleInfo[vehicle][carEngineOn])								return SendErrorMessage(playerid, "Dung dong co truoc khi sua doi phuong tien cua ban.");
	if (VehicleInfo[vehicle][carAttach3DtextUse] != 0)					return SendErrorMessage(playerid, "Cho da, hoat dong da duoc tien hanh.");
	if (!VehicleInfo[vehicle][carRegistered])							return SendErrorMessage(playerid, "Phuong tien khong duoc dang ky.");
	if (GetCash(playerid) < 300)											return SendNotCash(playerid);

	if (!IsPlayerInRangeOfPoint(playerid, 5.0,2228.1577,-110.8875,26.6406))	return SendErrorMessage(playerid, "Ban phai o trong tru so canh sat o Palomino. ");
    if (!IsVehicleInRangeOfPoint(vehicle, 15.0,697.6670,1624.8490,785.5494))	return SendErrorMessage(playerid, "Xe cua ban nen o gan tru so canh sat o Palomino.");
		
	StartVehicleUpgrade(playerid, vehicle, 8, 300);
	SendSyntaxMessage(playerid, "Qua trinh huy dang ky bat dau, se mat mot khoang thoi gian. ");
	return 1;
}


CMD:lights(playerid, params[])
{
	if (!IsDriver(playerid))	return SendNotInVehicle(playerid);

	new vehicleid = GetPlayerVehicleID(playerid), mes[128];
	new engine,lights,alarm,doors,bonnet,boot,objective;

    GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);

	if (lights)
	{
		format(mes, sizeof(mes), "da tat den pha cua %s.", VehicleNames[GetVehicleModel(vehicleid)-400]);
		SetPlayerChatBubble(playerid, mes, COLOR_PURPLE, 20.0, 4000);

		format(mes, sizeof(mes), "~w~Den pha %s ~r~TAT", VehicleNames[GetVehicleModel(vehicleid)-400]);
		GameTextForPlayer(playerid, mes, 2500, 4);

		VehicleLight(vehicleid, false);
		return 1;
	}

	format(mes, sizeof(mes), "da bat den pha cua %s.", VehicleNames[GetVehicleModel(vehicleid)-400]);
	SetPlayerChatBubble(playerid, mes, COLOR_PURPLE, 20.0, 4000);

	format(mes, sizeof(mes), "~w~Den pha %s ~g~BAT", VehicleNames[GetVehicleModel(vehicleid)-400]);
	GameTextForPlayer(playerid, mes, 2500, 4);

	VehicleLight(vehicleid, true);
	return 1;
}

CMD:alarmoff(playerid, params[])
{
    if (!IsValidVehicle(PlayerInfo[playerid][pCarKey]))						return SendErrorMessage(playerid, "Phuong tien cua ban khong duoc tao ra.");
	if (!GetNearVehicle(playerid, 10.0, PlayerInfo[playerid][pCarKey]))		return SendErrorMessage(playerid, "Ban phai o gan phuong tien cua minh.");

    new engine,lights,alarm,doors,bonnet,boot,objective;
    GetVehicleParamsEx(PlayerInfo[playerid][pCarKey],engine,lights,alarm,doors,bonnet,boot,objective);

	if (alarm == VEHICLE_PARAMS_OFF)	return SendErrorMessage(playerid, "Bao dong khong hoat dong.");

	AlarmOff(PlayerInfo[playerid][pCarKey]);
	SendWarningMessage(playerid, "Ban da tat bao dong. ");
	return 1;
}

ALTX:window("/wi", "/ww");
CMD:window(playerid, params[])
{
    if (!IsPlayerInAnyVehicle(playerid))				return SendNotInVehicle(playerid);

	new vehicle = GetPlayerVehicleID(playerid), seat = AntiCheatGetVehicleSeat(playerid), model = GetVehicleModel(vehicle), wi;

    if (IsADontWindow(vehicle))						return SendErrorMessage(playerid, "Phuong tien nay khong co cua so. ");

	if (sscanf(params, "i", wi))
	{
		SendHelpMessage(playerid, "/(wi)ndow [window]");
		SendSyntaxMessage(playerid, "Window: 1 - Lai xe | 2 - Ghe truoc | 3 - Phia sau ben trai | 4 - Phia sau ben phai ");
		return 1;
	}
	
	new seat_name[4][32] = {"lai xe", "ghe truoc", "phia sau ben trai", "phia sau ben phai"};

	if (wi > 4 || wi < 1)						return SendErrorMessage(playerid, "1 - Lai xe | 2 - Ghe truoc | 3 - Phia sau ben trai | 4 - Phia sau ben phai");
	if (!IsDriver(playerid) && seat+1 != wi)		return SendErrorMessage(playerid, "Ban khong phai la nguoi lai xe va ban chi co the mo / dong cua so %s.", seat_name[seat]);

	if ((model == 401 || model == 402 || model == 403 || model == 406 || model == 408 ||model == 410 || model == 411 || model == 412 || model == 413 || model == 414 ||model == 415 || model == 416 || model == 417 || model == 419 || 
	model == 422 || model == 425 || model == 427 || model == 428 || model == 429 || model == 431 || model == 433 || model == 434 || model == 436 || model == 437 || model == 439 || model == 440 || model == 443 || model == 444 || 
	model == 447 || model == 451 || model == 455 || model == 456 || model == 459 || model == 474 || model == 475 || model == 477 || model == 478 || model == 480 || model == 482 || model == 489 || model == 491 || model == 494 || 
	model == 495 || model == 496 || model == 498 || model == 499 || model == 500 || model == 502 || model == 503 || model == 505 || model == 506 || model == 508 || model == 514 || model == 515 || model == 517 || model == 518 || 
	model == 524 || model == 525 || model == 526 || model == 527 || model == 528 || model == 533 || model == 534 || model == 535 || model == 536 || model == 541 || model == 542 || model == 543 || model == 544 || model == 545 || 
	model == 549 || model == 552 || model == 554 || model == 555 || model == 556 || model == 557 || model == 558 || model == 559 || model == 562 || model == 565 || model == 573 || model == 574 || model == 575 || model == 576 || 
	model == 578 || model == 582 || model == 583 || model == 587 || model == 589 || model == 593 || model == 599 || model == 600 || model == 602) && wi > 2)
		return SendErrorMessage(playerid, "Phuong tien nay khong co cua so phia sau.");

	new wi_state[4], mes[128];

	GetVehicleParamsCarWindows(vehicle, wi_state[0], wi_state[1], wi_state[2], wi_state[3]);
	wi_state[wi-1] = !wi_state[wi-1] ? (1):(0);

    if (wi_state[wi-1] == 0)
	{
		format(mes, sizeof(mes), "mo cua so %s (%s).", seat_name[wi-1], VehicleNames[model-400]);
		SetPlayerChatBubble(playerid, mes, COLOR_PURPLE, 20.0, 4000);

		GameTextForPlayer(playerid, "~w~cua so ~g~mo", 2500, 4);
	}
	else
	{
	    format(mes, sizeof(mes), "dong cua so %s (%s).", seat_name[wi-1], VehicleNames[model-400]);
		SetPlayerChatBubble(playerid, mes, COLOR_PURPLE, 20.0, 4000);

		GameTextForPlayer(playerid, "~w~cua so ~r~dong", 2500, 4);
	}

	SetVehicleParamsCarWindows(vehicle, wi_state[0], wi_state[1], wi_state[2], wi_state[3]);
	return 1;
}

ALTX:mycars("/myvehicles", "/myv", "/myveh", "/myvehs");
CMD:mycars(playerid, params[])
{
	if (PlayerInfo[playerid][pCarKey])	return SendErrorMessage(playerid, "Ban da co mot phuong tien tao ra.");

	if (CountPlayerVehicles(playerid) == 0)
	{
		return SendErrorMessage(playerid, "Ban khong co bat ky phuong tien nao.");
	}
	new query[64];
	mysql_format(dbHandle, query, sizeof(query), "SELECT * FROM `cars` WHERE `owner`=%i", PlayerInfo[playerid][pID]);
	mysql_tquery(dbHandle, query, "ShowListVeh", "i", playerid);

	return 1;
}

ALTX:vfa("/vehiclefastaccess");
CMD:vfa(playerid, params[])
{
	new vehicle;
	if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendErrorMessage(playerid, "Ban phai dang lai mot chiec xe!");
	if (!(vehicle = GetPlayerVehicleID(playerid))) 		 return SendErrorMessage(playerid, "Ban phai dang lai mot chiec xe!");
	
	new engine,lights,alarm,doors,bonnet,boot,objective;
    GetVehicleParamsEx(vehicle,engine,lights,alarm,doors,bonnet,boot,objective);

	static mestxt[] = "{FFFFFF}%s dong co\t{C7C7C7}/(en)gine\n\
					{FFFFFF}%s cua xe\t{C7C7C7}/lock\n\
					{FFFFFF}%s den pha\t{C7C7C7}/lights\n\
					{FFFFFF}%s cop xe\t{C7C7C7}/trunk\n\
					{FFFFFF}%s mui xe\t{C7C7C7}/hood\n\
					{FFFFFF}Cua so lai xe\t{C7C7C7}/(wi)ndow\n\
					{FFFFFF}XM Radio\t{C7C7C7}/setstation(/ss)%s";

	new mes[sizeof(mestxt) + 90];

	format(mes, sizeof(mes), mestxt,
		(!engine)?("Mo"):("Tat"),
		(doors)?("Mo"):("Khoa"),
		(!lights)?("Bat"):("Tat"),
		(!boot)?("Mo"):("Dong"),
		(!bonnet)?("Mo"):("Dong"),
		(PlayerInfo[playerid][pCarKey] == vehicle)?("\n	\n{FF6347}> Quan ly phuong tien <"):("")
	);

	new title[39];
	format(title, sizeof(title), "{FFFFFF}%s", VehicleNames[GetVehicleModel(vehicle)-400]);

	Dialog_Show(playerid, VehFastAccess, DIALOG_STYLE_TABLIST, title, mes, "Chon", "Huy bo");
	return 1;
}

CMD:vmenu(playerid, params[])
{
	if (!IsValidVehicle(PlayerInfo[playerid][pCarKey]))	return SendErrorMessage(playerid,"Phuong tien cua ban khong duoc tao ra.");
	
	new vehicle = PlayerInfo[playerid][pCarKey];
	if (!vehicle) return 1;

	static mestxt[] = "{FFFFFF}Thong ke phuong tien\n\
					Tien phat chua thanh toan\n\
					Dau xe\n\
					Tim xe bang GPS\n\
					Tat bao dong [ %s{FFFFFF} ]\n\
					Keo xe\n\
					Ban xe cho nha nuoc\n\
					Ban xe cho nguoi choi";
	new mes[sizeof(mestxt)+12],engine,lights,alarm,doors,bonnet,boot,objective;
    GetVehicleParamsEx(PlayerInfo[playerid][pCarKey],engine,lights,alarm,doors,bonnet,boot,objective);

	format(mes, sizeof(mes), mestxt, (alarm)?("{00E100}BAT"):("{FF6347}TAT"));	

	new title[39];
	format(title, sizeof(title), "{FFFFFF}%s", VehicleNames[GetVehicleModel(vehicle)-400]);
	Dialog_Show(playerid, VehMenu, DIALOG_STYLE_LIST, title, mes, "Chon", "Huy bo");
	return 1;
}	

CMD:fill(playerid, params[])
{
	new vehicle = GetPlayerVehicleID(playerid);
	
	if (!GetPVarInt(playerid, #UsePump)) 
	{
		new Float: f_price, price = floatround(f_price, floatround_round), bizid, modelid = GetVehicleModel(vehicle), str[40];
		if (!IsDriver(playerid))					return SendNotInVehicle(playerid);
		if ((bizid = AZC_Nearest(playerid)) == -1)	return SendErrorMessage(playerid, "Khong co tram xang nao gan ban. ");
		if (BizInfo[bizid][bizLocked])				return SendErrorMessage(playerid, "Tram xang nay dang dong.");
		if (VehicleInfo[vehicle][carEngineOn]) 		return SendErrorMessage(playerid, "Hay tat dong co truoc.");
		if (GetCash(playerid) < price) 				return SendNotCash(playerid);

		if (GetVehicleModelInfoAsInt(modelid, "TransmissionData_nEngineType") == 'P') 	  f_price = float(BizInfo[bizid][bizEntrance]) * 1.2;
		else if (GetVehicleModelInfoAsInt(modelid, "TransmissionData_nEngineType") == 'E') f_price = float(BizInfo[bizid][bizEntrance]) * 0.8;
		else f_price = float(BizInfo[bizid][bizEntrance]);

		format(str, sizeof(str), "Tiep nhien lieu se ton $%i?, Ban co muon tiep tuc?", price);
		ConfirmDialog(playerid, "Tiep nhien lieu phuong tien", str, "ConfirmFilling");
	} 
	else 
	{
		Fuel_ResetPlayer(playerid);
		ToggleVehicleEngine(vehicle, playerid);
	}
	return 1;
}

ALTX:engine("/en");
CMD:engine(playerid, params[])
{
	if (!IsDriver(playerid)) return 1;

	new vehicle = GetPlayerVehicleID(playerid);

	if (PlayerInfo[playerid][MissionTime])											 return 1;
	if (pTemp[playerid][pCuffed])     												 return SendCuffedMessage(playerid);
	if (IsADMVCar(vehicle) || IsADMVHeli(vehicle) || IsABicycle(vehicle))			 return SendErrorMessage(playerid, "Khong the khoi dong dong co cua phuong tien nay.");
	if (VehicleInfo[vehicle][carFuel] == 0.0)										 return SendErrorMessage(playerid, "Phuong tien da het nhien lieu.");
	if (GetPVarInt(playerid, #UsePump))												 return cmd::fill(playerid, "");
    if (VehicleInfo[vehicle][carOwnerID] && VehicleInfo[vehicle][carEngine] <= 0.0)	 return SendErrorMessage(playerid, "Dong co cua phuong tien nay khong hoat dong.");
    if (VehicleInfo[vehicle][carOwnerID] && VehicleInfo[vehicle][carBattery] <= 0.0) return SendErrorMessage(playerid, "Ac quy phuong tien khong hoat dong.");
	if (IsRentCar(vehicle) && pTemp[playerid][pRentveh] != vehicle) 				 return SendErrorMessage(playerid, "Phuong tien nay phai thue.");
	if (VehicleInfo[vehicle][Impounded])											 return SendErrorMessage(playerid, "Khi xe dang o trong bai dau xe, ban khong the su dung chuc nang nay. (/ Unimpound)");
	
	if (VehicleInfo[vehicle][carFaction] && 
		VehicleInfo[vehicle][carFaction] != PlayerInfo[playerid][pFaction])			return 1;

	if (	VehicleInfo[vehicle][carType] >= RENT_CAR && 
		VehicleInfo[vehicle][carType] <= MINER_CAR && 
		pTemp[playerid][pRentveh] != vehicle)	return SendErrorMessage(playerid, "Dau tien hay nhap /rentcarjob(/rcj).");


	if (VehicleInfo[vehicle][carOwnerID] && (PlayerInfo[playerid][pCarKey] != vehicle && PlayerInfo[playerid][pSpareKey] != VehicleInfo[vehicle][carID]))
	{
		if (!VehicleInfo[vehicle][carEngineOn])
		{
			if (PlayerInfo[playerid][pJob] != JOB_CARJACKER)	return SendErrorMessage(playerid, "Ban khong co chia khoa xe!");
			
			if (!IsPlayerHasItem(playerid, INV_TOOLS)) 	 return SendErrorMessage(playerid, "Ban khong co cong cu de hack dong co.");

			if (!PoliceOnline())						 return SendErrorMessage(playerid, "De bat dau phai co it nhat %i si quan canh sat.", NEED_COPS_TO_CRIME);
			if (VehicleInfo[vehicle][carOwnerID] == 0)   return SendErrorMessage(playerid, "Chi phuong tien ca nhan moi co the hack.");
			if (JackingEngine[playerid] != 0)            return SendErrorMessage(playerid, "Ban dang co gang khoi dong dong co!");

			static const str_size[] = "{"COL_GREY"}Ban co muon pha vo dong co %s?";
			new mes[sizeof(str_size) - 4 + 1 + 31 + 7];
			format(mes, sizeof(mes), str_size, VehicleNames[GetVehicleModel(vehicle)-400]); //(VehicleInfo[vehicle][carImmob]+1) * 20
			Dialog_Show(playerid, StartJackingEngine, DIALOG_STYLE_MSGBOX, "{FFFFFF}Pha vo dong co", mes, ">>>", "Huy bo");
			return 1;
		}		
	}
	
	ToggleVehicleEngine(vehicle, playerid);
	return 1;
}

CMD:dropkey(playerid, params[])
{
	if (!PlayerInfo[playerid][pSpareKey])	return SendErrorMessage(playerid, "Ban khong co chia khoa.");

	PlayerInfo[playerid][pSpareKey] = 0;
	SendSyntaxMessage(playerid, "Ban da nem chia khoa xuong dat");
	return 1;
}

CMD:carsign(playerid,params[])
{
	new vehicle = GetPlayerVehicleID(playerid), string[128];

	if (!IsDriver(playerid))	return SendNotInVehicle(playerid);
	if (isnull(params))			return SendHelpMessage(playerid, "/carsign [van ban]");
	if (IsABicycle(vehicle))	return SendErrorMessage(playerid,"Ban khong the lap bien bao xe tren phuong tien nay!");
	if (strlen(params) > 84)	return SendErrorMessage(playerid, "Ban khong the nhap nhieu hon 84 ky tu.");

	if (strlen(params) > 28)
	{
		new pos = 28, string1[30], string2[30], string3[30];

		if (pos < 28-1) pos = 28;

		if (strlen(params[pos]) > 28)
		{
			format(string1, sizeof(string1), "%.*s", pos, params);
			format(string2, sizeof(string2), "%.*s", pos, params[pos]);
			format(string3, sizeof(string3), "%.*s", pos, params[pos+pos]);
			format(string, sizeof(string), "%s\n%s\n%s", string1, string2, string3);
		}
		else
		{
			format(string1, sizeof(string1), "%.*s", pos, params);
			format(string2, sizeof(string2), "%s", params[pos]);
			format(string, sizeof(string), "%s\n%s", string1, string2);
		}
	}
	else
	{
		format(string, sizeof(string), "%s",params);
	}

	if (PlayerInfo[playerid][pCarKey] == vehicle)
	{
		if (!IsPlayerHasItem(playerid, INV_SIGN))		return SendErrorMessage(playerid, "Ban khong co bien bao xe.");
		if (PlayerInfo[playerid][pCarKey] != vehicle)	return SendErrorMessage(playerid, "Bien bao xe chi co the duoc lap dat tren phuong tien ca nhan cua ban.");

		SendHelpMessage(playerid, "/rcarsign - de loai bo bien bao xe. ");
		if (!IsValidDynamic3DTextLabel(veicolo_callsign_testo[vehicle]))
		{
		    new Float: x, Float: y, Float: z;
        	GetCarsignPosition(vehicle, x, y, z);
			veicolo_callsign_testo[vehicle] = CreateDynamic3DTextLabel(string,0x33AA33FF, -x, y, z, 20.0, INVALID_PLAYER_ID, vehicle, 1, -1, 0);
		}
		else	UpdateDynamic3DTextLabelText(veicolo_callsign_testo[vehicle], 0x33AA33FF, string);

		return 1;
	}

	new faction = PlayerInfo[playerid][pFaction];

	if (!IsFactionLegal(faction))
		return SCM(playerid, COLOR_LIGHTRED, "Ban phai la canh sat / nhan vien y te, hoac dang ngoi trong o to cua ban.");

	if (!PlayerInfo[playerid][pOnDuty])
		return SCM(playerid, COLOR_LIGHTRED, "Ban phai trong gio lam viec (/duty).");

	if (VehicleInfo[vehicle][carFaction] != faction)
	    return SendErrorMessage(playerid, "Phuong tien nay khong thuoc ve to chuc cua ban.");

	SendHelpMessage(playerid, "/rcarsign  - de loai bo bien bao xe. ");
	if (!IsValidDynamic3DTextLabel(veicolo_callsign_testo[vehicle]))
	{
	    new Float: x,
	        Float: y,
	        Float: z;
        GetCarsignPosition(vehicle, x, y, z);
		veicolo_callsign_testo[vehicle] = CreateDynamic3DTextLabel(string,0xFFFFFFFF, -x, y, z, 40.0, INVALID_PLAYER_ID, vehicle, 1, -1, 0);
	}
	else
		UpdateDynamic3DTextLabelText(veicolo_callsign_testo[vehicle], 0xFFFFFFFF, string);
	return 1;
}

CMD:rcarsign(playerid,params[])
{
    if (!IsDriver(playerid))	return SendNotInVehicle(playerid);

	new vehicle = GetPlayerVehicleID(playerid);

    if (IsValidDynamic3DTextLabel(veicolo_callsign_testo[vehicle]))
	{
		DestroyDynamic3DTextLabel(veicolo_callsign_testo[vehicle]);
        veicolo_callsign_testo[vehicle] = Text3D:INVALID_3DTEXT_ID;
	}
	return 1;
}

CMD:stop(playerid, params[])
{
	if (PlayerInfo[playerid][pInjured]) return 1;

	/*if (JackingEngine[playerid] != 0)
	{
		JackingEngine[playerid] = 0;
		UnFreezePlayer(playerid);
		SendSyntaxMessage(playerid, "�� �������or ����� ���������.");
	}
	
	if (JackingLock[playerid] != 0)
	{
		JackingLock[playerid] = 0;
		JackingVehicle[playerid] = 0;
		UnFreezePlayer(playerid);
		SendSyntaxMessage(playerid, "�� �������or ����� ������.");
	}*/
	
	if (pTemp[playerid][pPlantTime] != 0)
	{
		UnFreezePlayer(playerid);
		StopPlayerAnims(playerid);
		pTemp[playerid][pPlantTime] = 0;
		pTemp[playerid][pPlantType] = 0;
		SendSyntaxMessage(playerid, "Ban da dung ha canh. ");
	}

	if (pTemp[playerid][pFireTime] != 0)
	{
		StopCreatingPlayersFire(playerid);
		SendSyntaxMessage(playerid, "Ban da ngung dot lua.");
	}
	return 1;
}

CMD:trunk(playerid, params[])
{
	if (IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
	    new vehicle = GetPlayerVehicleID(playerid);

	    if (IsADontTrunk(vehicle) || IsAPlane(vehicle) || IsABiker(vehicle) || IsAHelicopter(vehicle) || IsABoat(vehicle) || IsABicycle(vehicle))	return SendErrorMessage(playerid, "This vehicle does not have a trunk.");
        if (VehicleInfo[vehicle][carOwnerID] && PlayerInfo[playerid][pCarKey] != vehicle)															return SendErrorMessage(playerid, "Phuong tien nay khong thuoc ve ban. ");
        if (VehicleInfo[vehicle][carFaction] != 0 && PlayerInfo[playerid][pFaction] != VehicleInfo[vehicle][carFaction])							return SendErrorMessage(playerid, "Phuong tien nay thuoc ve to chuc khac.");
		if (VehicleInfo[vehicle][carLocked] || (IsRentCar(vehicle) && !VehicleInfo[vehicle][carRent]))												return SendErrorMessage(playerid, "Khoa xe da dong. ");

		if (VehicleInfo[vehicle][carTrunkLock] == 1)
		{
		    new mes[56];
			format(mes, sizeof(mes), "~w~COP XE %s ~r~DONG", VehicleNames[GetVehicleModel(vehicle)-400]);
			GameTextForPlayer(playerid, mes, 3000, 3);

			VehicleTrunk(vehicle, false);
			SendSyntaxMessage(playerid, "Ban da dong cop cua phuong tien.");
			return 1;
		}
		else
		{
			new mes[56];
	        format(mes, sizeof(mes), "~w~COP XE %s ~g~MO", VehicleNames[GetVehicleModel(vehicle)-400]);
			GameTextForPlayer(playerid, mes, 3000, 3);

			VehicleTrunk(vehicle, true);
			SendSyntaxMessage(playerid, "Ban da mo cop cua phuong tien.");
			SendHelpMessage(playerid, "De tuong tac voi cop xe, hay su dung N.");
		}
		return 1;
	}

	new vehicle = GetNearVehicle(playerid, 4.0);
	if (vehicle == -1)							return SendErrorMessage(playerid, "Ban khong o gan phuong tien.");
    if (!IsNearTrunk(vehicle, playerid, 2.0)) 	return SendErrorMessage(playerid, "Ban khong o gan cop xe! ");

	if (VehicleInfo[vehicle][carOwnerID] && PlayerInfo[playerid][pCarKey] != vehicle)							return SendErrorMessage(playerid, "Phuong tien nay khong thuoc ve ban.");
    if (VehicleInfo[vehicle][carFaction] && PlayerInfo[playerid][pFaction] != VehicleInfo[vehicle][carFaction])	return SendErrorMessage(playerid, "Phuong tien nay thuoc ve to chuc khac.");
    if (VehicleInfo[vehicle][carLocked] || (IsRentCar(vehicle) && VehicleInfo[vehicle][carRent]))				return SendErrorMessage(playerid, "Khoa xe da dong.");

    if (VehicleInfo[vehicle][carTrunkLock] == 1)
	{
	    new mes[56];
		format(mes, sizeof(mes), "~w~COP XE %s ~r~DONG", VehicleNames[GetVehicleModel(vehicle)-400]);
		GameTextForPlayer(playerid, mes, 3000, 3);

		VehicleTrunk(vehicle, false);
		SendSyntaxMessage(playerid, "Ban da dong cop cua phuong tien.");
		return 1;
	}
	else
	{
		new mes[56];
        format(mes, sizeof(mes), "~w~COP XE %s ~g~MO", VehicleNames[GetVehicleModel(vehicle)-400]);
		GameTextForPlayer(playerid, mes, 3000, 3);

		VehicleTrunk(vehicle, true);
		SendSyntaxMessage(playerid, "Ban da mo cop cua phuong tien.");
	}
	return 1;
}

CMD:hood(playerid, params[])
{
	if (IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
	    new vehicle = GetPlayerVehicleID(playerid);
	    
		if (IsAPlane(vehicle) || IsABiker(vehicle) || IsAHelicopter(vehicle) || IsABoat(vehicle) || IsABicycle(vehicle))	return SendErrorMessage(playerid, "Phuong tien nay khong the mo mui.");
		if (VehicleInfo[vehicle][carLocked])																				return SendErrorMessage(playerid, "Khoa xe da dong.");

		if (VehicleInfo[vehicle][carHoodLock] == 1)
		{
		    new mes[56];
			format(mes, sizeof(mes), "~w~mui %s ~r~dong", VehicleNames[GetVehicleModel(vehicle)-400]);
			GameTextForPlayer(playerid, mes, 3000, 3);

			VehicleHood(vehicle, false);
			SendSyntaxMessage(playerid, "Ban da dong mui cua phuong tien.");
			return 1;
		}
		else
		{
			new mes[56];
	        format(mes, sizeof(mes), "~w~mui %s ~g~mo", VehicleNames[GetVehicleModel(vehicle)-400]);
			GameTextForPlayer(playerid, mes, 3000, 3);

			VehicleHood(vehicle, true);
			SendSyntaxMessage(playerid, "Ban da mo mui cua phuong tien.");
		}
		return 1;
	}

	new vehicle = 0;

	for(new i; i < MAX_VEHICLES; i++)
	{
	    if (IsAPlane(i) || IsABiker(i) || IsAHelicopter(i) || IsABoat(i) || IsABicycle(i) || !IsOnHoodVehicle(playerid, i)) continue;

	    vehicle = i;
		break;
	}

	if (!vehicle)							return SendErrorMessage(playerid, "Khong co phuong tien nao co mui gan ban. ");
    if (VehicleInfo[vehicle][carLocked])	return SendErrorMessage(playerid, "Khoa xe da dong.");

    if (VehicleInfo[vehicle][carHoodLock] == 1)
	{
	    new mes[56];
		format(mes, sizeof(mes), "~w~Mui %s ~r~Dong", VehicleNames[GetVehicleModel(vehicle)-400]);
		GameTextForPlayer(playerid, mes, 3000, 3);

		VehicleHood(vehicle, false);
		SendSyntaxMessage(playerid, "Ban da dong mui cua phuong tien. ");
		return 1;
	}
	else
	{
		new mes[56];
        format(mes, sizeof(mes), "~w~Mui %s ~g~Mo", VehicleNames[GetVehicleModel(vehicle)-400]);
		GameTextForPlayer(playerid, mes, 3000, 3);

		VehicleHood(vehicle, true);
		SendSyntaxMessage(playerid, "Ban da mo mui cua phuong tien.");
	}
	return 1;
}

ALTX:vbreaklock("/vbl");
CMD:vbreaklock(playerid, params[])
{
	if (!PoliceOnline())	return SendErrorMessage(playerid, "De bat dau can co %i si quan canh sat.", NEED_COPS_TO_CRIME);

	new vehid = GetNearVehicle(playerid, 3.0);
	if (!vehid)	return SendErrorMessage(playerid, "Khong co phuong tien gan ban.");

	if (VehicleInfo[vehid][carOwnerID] == PlayerInfo[playerid][pID] || PlayerInfo[playerid][pSpareKey] == VehicleInfo[vehid][carOwnerID])
		return SendErrorMessage(playerid, "Ban khong the hack phuong tien cua ban.");
	
	if (VehicleInfo[vehid][carType])			return SendErrorMessage(playerid, "Chi phuong tien ca nhan moi co the bi hack.");
	if (VehicleInfo[vehid][carOwnerID] == 0)    return SendErrorMessage(playerid, "Chi phuong tien ca nhan moi co the bi hack.");
	if (VehicleInfo[vehid][carLocked] == 0)     return SendErrorMessage(playerid, "Cua xe dang mo.");
	if (JackingLock[playerid] != 0)             return SendErrorMessage(playerid, "Ban da pha cua roi.");
	if (!IsPlayerInFrontVDoor(playerid, vehid)) return SendErrorMessage(playerid, "Ban nen o gan cua tai xe.");

	foreach(new i : Player) {
		if (JackingVehicle[i] == vehid) return SendErrorMessage(playerid, "Ai do da pha cua chiec xe nay.");
	}

	new param[10];
	if (sscanf(params, "s[10]", param)) {
		SendHelpMessage(playerid, "/vbl [loai] hoac /vbreaklock [loai]");
		SendSyntaxMessage(playerid, "(q)uite - lang le pha cua xe bang xa beng.");
		SendSyntaxMessage(playerid, "(n)oisy - pha vo cua xe, kich hoat canh bao xe.");
		return 1;
	}	

	if (CompareStrings(param, "q") || CompareStrings(param, "quite"))
	{
		//if (!IsPlayerHasItem(playerid, INV_PICKLOCK)) return SendErrorMessage(playerid, "� ��� ������ ���� �������, ����� ���������� ����� ����������.");
		if (!CheckHanditem(playerid,18634))		 return SendErrorMessage(playerid, "Ban nen co mot chiec xa beng trong tay. (/clothing)");
		if (IsPlayerCrouching(playerid) == false) return SendErrorMessage(playerid, "Ban can phai ngoi xuong.");

		SetPVarInt(playerid, #JackingVehicle, vehid);
		pTemp[playerid][JackingType] = 1;

		static const str_size[] = "{"COL_GREY"}Ban co muon bat dau pha canh cua %s? Ban can %i giay.";
		new mes[sizeof(str_size) - 4 + 1 + 31 + 7];
		format(mes, sizeof(mes), str_size, VehicleNames[GetVehicleModel(vehid)-400], 250+VehicleInfo[vehid][carLock]*250);
        Dialog_Show(playerid, StartJackingLock, DIALOG_STYLE_MSGBOX, "{FFFFFF}Pha cua", mes, ">>>", "Huy bo");
	}
	else if (CompareStrings(param, "n") || CompareStrings(param, "noisy"))
	{
		if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return SendErrorMessage(playerid, "Ban phai dung day.");

		SetPVarInt(playerid, #JackingVehicle, vehid);
		pTemp[playerid][JackingType] = 2;

		static const str_size[] = "{"COL_GREY"}Ban co muon bat dau pha canh cua %s?";
		new mes[sizeof(str_size) - 4 + 1 + 31 + 7];
		format(mes, sizeof(mes), str_size, VehicleNames[GetVehicleModel(vehid)-400]);
        Dialog_Show(playerid, StartJackingLock, DIALOG_STYLE_MSGBOX, "{FFFFFF}Pha cua", mes, ">>>", "Huy bo");
	}
	else {
		SendHelpMessage(playerid, "/vbl [type] or /vbreaklock [type]");
		SendSyntaxMessage(playerid, "(q)uite - lang le pha cua xe bang xa beng.");
		SendSyntaxMessage(playerid, "(n)oisy - pha vo lon cua xe, kich hoat canh bao xe.");
		return 1;
	}

	

	return 1;
}

ALTX:unscramble("/uns");
CMD:unscramble(playerid, params[])
{
	if (!IsPlayerInAnyVehicle(playerid) || !JackingEngine[playerid]) return SendErrorMessage(playerid, "Ban khong the su dung lenh nay ngay bay gio! ");

	new unword[64];
	if (sscanf(params, "s[64]", unword))	return SendHelpMessage(playerid, "/(uns)cramble [tu duoc giai ma]");

	new vehid = GetPlayerVehicleID(playerid);
	if (!isnull(unword) && CompareStrings(unword, UnscrambleInfo[pTemp[playerid][pUnscrambleID]][eUnscrambledWord]))
	{
		pTemp[playerid][pScrambleSuccess]++; 
		PlaySound(playerid, 1052);

		switch(VehicleInfo[vehid][carImmob])
		{
			case 0: if (pTemp[playerid][pScrambleSuccess] < 3) return NewScrambleWord(playerid);
			case 1: if (pTemp[playerid][pScrambleSuccess] < 4) return NewScrambleWord(playerid);
			case 2: if (pTemp[playerid][pScrambleSuccess] < 5) return NewScrambleWord(playerid);
			case 3: if (pTemp[playerid][pScrambleSuccess] < 6) return NewScrambleWord(playerid);
			case 4: if (pTemp[playerid][pScrambleSuccess] < 7) return NewScrambleWord(playerid);
		}

		JackingEngine[playerid] = 0;
		pTemp[playerid][pUnscrambleID] = 0;
		pTemp[playerid][pScrambleFailed] = 0;
		pTemp[playerid][pScrambleSuccess] = 0;

		if (IsValidVehicle(GetPlayerVehicleID(playerid))) {
			ToggleVehicleEngine(GetPlayerVehicleID(playerid), playerid);
			PlaySound(playerid, 1145);
			AlarmOff(vehid);
			InfoMSG(playerid, "PHA ~g~DONG CO ~w~THANH CONG!", 3);
		}
	}
	else {
		pTemp[playerid][pScrambleFailed]++; 
		PlaySound(playerid,1085);
		
		switch(VehicleInfo[vehid][carImmob])
		{
			case 0: if (pTemp[playerid][pScrambleFailed] == 3) return StopJackingEngine(playerid);
			case 1: {
				if (pTemp[playerid][pScrambleFailed] >= 2){
					PlaySound(playerid, 1138);
					AlarmOn(vehid);
				
					if (pTemp[playerid][pScrambleFailed] == 3) return StopJackingEngine(playerid);
				}
			}
			case 2: {
				if (pTemp[playerid][pScrambleFailed] >= 2){
					PlaySound(playerid, 1138);
					AlarmOn(vehid);
					return StopJackingEngine(playerid);
				}
			}
			case 3: {
				PlaySound(playerid, 1138);
				AlarmOn(vehid);

				if (pTemp[playerid][pScrambleFailed] == 2) return StopJackingEngine(playerid);
			}
			case 4: {
				PlaySound(playerid, 1138);
				AlarmOn(vehid);
				return StopJackingEngine(playerid);
			}
		}
		
		NewScrambleWord(playerid);
	}

	return 1;
}

/*
ALTX:jackingvehicle("/jackv");
CMD:jackingvehicle(playerid, params[])
{
	//new vehicle = GetPlayerVehicleID(playerid);

	if (!VehicleInfo[vehicle][carOwnerID]) 									return SendErrorMessage(playerid, "�� �� ������ ������ ��������������� ���������.")
	if (!VehicleInfo[vehicle][carEngineOn]) 									return SendErrorMessage(playerid, "�� �� ������ ������ ����������� ���������.")
	if (PlayerInfo[playerid][pCarKey] == vehicle 
		|| PlayerInfo[playerid][pSpareKey] == VehicleInfo[vehicle][carID])  return SendErrorMessage(playerid, "�� �� ������ ������ ���� ���������, � ����� ���������, �� �������� � ��� ���� �����.")
	
	if (!PoliceOnline())	return SendErrorMessage(playerid, "� ���� ����� ���� ���� �� %i �����������.", NEED_COPS_TO_CRIME);

	new jtime = pTemp[playerid][JackingTime]-gettime();

	if (GetPVarInt(playerid, #JACKING_PROCESS))						  return SendErrorMessage(playerid, "�� ��� �������� ���������.");
	if (pTemp[playerid][JackingTime] == 0) 							  return SendErrorMessage(playerid, "�� �� ������� ������� ���������.");
	if (jtime > 0) 													  return SendErrorMessage(playerid, "�� �� ������ ������ ���� ��������� ��� %i ������.", jtime);
	if (GetPlayerVehicleID(playerid) != pTemp[playerid][JackingVehID]) return SendErrorMessage(playerid, "�� �� ������� ���� ���������.");

	if (IsPoliceNear(playerid)) return SendErrorMessage(playerid, "�� �� ������ ������ ���������, ��� ��� ����� � ���� ���� �����������.");

	pTemp[playerid][JackingTime] = 0;
	SetPVarInt(playerid, #JACKING_PROCESS, 1);
	//pTemp[playerid][JackingVehID] = 0;

	DisableWaypoint(playerid);
	if (IsValidDynamicCP(pTemp[playerid][JackingCP])) DestroyDynamicCP(pTemp[playerid][JackingCP]);
	pTemp[playerid][JackingCP] = 0;

	new randomCP = random(sizeof(Jacking_CP));
	pTemp[playerid][JackingCP] = CreateDynamicCP(Jacking_CP[randomCP][0], Jacking_CP[randomCP][1], Jacking_CP[randomCP][2], 1.5, 0, 0, playerid, 15000.0);
	TogglePlayerDynamicCP(playerid, pTemp[playerid][JackingCP], true);
    Streamer_Update(playerid, STREAMER_TYPE_CP);

	InfoMSG(playerid, "��������� ��������� �� ~r~��������~w~, ����� �������� �� ���� ~g~������~w~~n~���� �� ~y~��������~w~ �� ���� ����� ~y~�����~w~, � ����� ������ ~r~��������~w~~n~����� ~y~������ �٨ ���!", 8);
	return 1;
}*/

ALTX:deletejackvehicles("/delveh");
CMD:deletejackvehicles(playerid, params[])
{
	new query[128];
	mysql_format(dbHandle, query, sizeof(query), "SELECT * FROM cars WHERE owner = %i AND jacking = 1", PlayerInfo[playerid][pID]);
	mysql_tquery(dbHandle, query, "Remove_ShowVehicleList", "i", playerid);

	return 1;
}
