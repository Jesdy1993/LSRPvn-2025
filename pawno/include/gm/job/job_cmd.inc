CMD:takejob(playerid, params[])
{
	if (PlayerInfo[playerid][pInjured] != 0 || GetPVarInt(playerid, "Freeze") || pTemp[playerid][pTaserTime] || pTemp[playerid][pCuffed]) 
		return 1;
	
	new i = Job_Nearest(playerid);
	if (i == -1) return 1;

	new title[32+22];
	format(title, sizeof(title), "%s", GetJobName(JobsInfo[i][jobType]));

	static const strdlg[] = "%s\nNhan cong viec\nLenh tro giup\n\n {FFC46A} Thoat cong viec ";
	new mes[sizeof(strdlg) + 36];

	if (JobsInfo[i][jobType] == JOB_PIZZA) {
		format(mes, sizeof(mes), strdlg, "Co the ket hop voi cac cong viec khac");
		format(title, sizeof(title), "%s - Secondary work", title);
	} else {
		format(mes, sizeof(mes), strdlg, "Khong the ket hop voi cong viec khac");
		format(title, sizeof(title), "%s - Main job", title);
	}
	
	Dialog_Show(playerid, TakeJobMenu, DIALOG_STYLE_TABLIST_HEADERS, title, mes, "Lua chon", "Huy bo");
	return 1;
}

CMD:quitjob(playerid, params[])
{
	new job = PlayerInfo[playerid][pJob];

	if (job == JOBLESS)															return SendErrorMessage(playerid, "Ban dang that nghiep.");
//	if (PlayerInfo[playerid][pPremium] < 2 && PlayerInfo[playerid][pCareer] < 2)	return SendErrorMessage(playerid, "Ban chi co the nghi viec hai gio sau khi ban nhan duoc viec lam.");
	if (pTemp[playerid][pJob])													return SendErrorMessage(playerid, "Ket thuc cong viec truoc, ban giao phuong tien lam viec. (/unrcj)");

	PlayerInfo[playerid][pJob] = 0;
	PlayerInfo[playerid][pCareer] = 0;

	pTemp[playerid][pJob] = 0;
	pTemp[playerid][pJobTime] = 0;

	SQL_SetInteger("users", "job", 0, PlayerInfo[playerid][pID]);
	SQL_SetInteger("users", "career", 0, PlayerInfo[playerid][pID]);
	
	SendSyntaxMessage(playerid, "Ban da thoat cong viec %s%s", GetJobName(job), (job == JOB_TRUCKER)?(". Rank cua ban da duoc lam lai."):("."));
	return 1;
}

CMD:quitsidejob(playerid, params[])
{
	new job = PlayerInfo[playerid][pSideJob];

	if (job == JOBLESS)	return SendErrorMessage(playerid, "Ban khong co cong viec thu 2. ");

	SendSyntaxMessage(playerid, "Ban da thoat cong viec %s.", GetJobName(job));
	PlayerInfo[playerid][pSideJob] = 0;
	return 1;
}

CMD:jobhelp(playerid, params[])
{
	if (PlayerInfo[playerid][pJob] == JOBLESS)	return SendErrorMessage(playerid, "Ban dang that nghiep.");

	new mes[512];
	SendSyntaxMessage(playerid, "[VEHICLE] Thue mot phuong tien cong viec - /rentcarjob(/rcj), return - /unrentcarjob(/unrcj).");

	if (PlayerInfo[playerid][pSideJob] == JOB_PIZZA) SendSyntaxMessage(playerid, "[PIZZA JOB] Giao pizza - /pizzajob. Nhap /quitsidejob de thoat.");

	if (PlayerInfo[playerid][pJob] == JOB_CARJACKER)
	{
		static const str_size[] = "{ffffff}Ban dang lam viec Car Jacker (trom xe). Gio mo cua: %i.\n\n/delivercar - thao do cac bo phan co gia tri cua xe dot than.\n /dropoff - thoat khoi phuong tien.\n /leavemission - dat lai nhiem vu.\n\n /vbl (n) oisy - cuop xe 1 cach manh.\n /vbl (q) uite - cuop xe 1 cach im lang\n\n (/en) gine - khoi dong dong co\n (/uns) cramble - de giai ma tu (khi be khoa dong co) ";
		format(mes, sizeof(mes), str_size, PlayerInfo[playerid][pCareer]);
	}

	else if (PlayerInfo[playerid][pJob] == JOB_TAXI)
	{
	    static const str_size[] = "{ffffff}Ban dang lam viec tai xe Taxi. Gio mo cua: %i.\n\n/taxi duty - bat dau /stop work.\n /taxi fare - thay doi gia.\n /taxi accept - chap nhat cuoc goi.\n /address - danh dau vi tri\n /street - tim duong ma ban dang di tren. ";

		format(mes, sizeof(mes), str_size, PlayerInfo[playerid][pCareer]);
	}

	else if (PlayerInfo[playerid][pJob] == JOB_TRUCKER)
	{
		format(mes, sizeof(mes), "{ffffff}Ban dang lam viec Trucker. Gio mo cua: %i.\n\n/cargo - lam viec voi hang hoa.\n /trailer - dieu khien xe keo.\n /tpda - Trucker Menu.\n /industry - thong tin ve cong ty - bussiness.\n\n", PlayerInfo[playerid][pCareer]);
        switch(PlayerInfo[playerid][pCareer])
		{
		    case 0..11: strcat(mes, "Xe kha dung: Picador, Sadler, Bobcat, Walton, Yosemite.");
			case 12..23: strcat(mes, "Xe kha dung: Picador, Sadler, Bobcat, Walton, Yosemite, Pony, Berkley's RC Van, Burrito.");
		    case 24..31: strcat(mes, "Xe kha dung: Picador, Sadler, Bobcat, Walton, Yosemite, Pony, Berkley's RC Van, Burrito, Rumpo, Boxville.");
		    case 32..47:
			{
				strcat(mes, "Xe kha dung: Picador, Sadler, Bobcat, Walton, Yosemite, Pony, Berkley's RC Van, Burrito, Rumpo, Boxville.\n");
                strcat(mes, "Benson, Mule, DFT-30, Tanker, Securicar.");
			}
			case 48..58:
			{
				strcat(mes, "Xe kha dung: Picador, Sadler, Bobcat, Walton, Yosemite, Pony, Berkley's RC Van, Burrito, Rumpo, Boxville.\n");
                strcat(mes, "Benson, Mule, DFT-30, Tanker, Securicar, Yankee, Flatbed.");
			}
			default:
			{
				strcat(mes, "Xe kha dung: Picador, Sadler, Bobcat, Walton, Yosemite, Pony, Berkley's RC Van, Burrito, Rumpo, Boxville.\n");
                strcat(mes, "Benson, Mule, DFT-30, Tanker, Securicar, Yankee, Flatbed, ��������.");
			}
		}
	}

	Dialog_Show(playerid, None, DIALOG_STYLE_MSGBOX, "{FFFFFF}Lenh cong viec", mes, "Return", "Close");

	return 1;
}

ALTX:rentcarjob("/rcj");
CMD:rentcarjob(playerid, params[])
{
	if (PlayerInfo[playerid][pInjured] != 0 || GetPVarInt(playerid, "Freeze") || pTemp[playerid][pTaserTime] || pTemp[playerid][pCuffed]) return 1;
	
	if (pTemp[playerid][pJob])					return SendErrorMessage(playerid, "Ban da lay mot chiec xe dang lam viec! Nhap /unrentcarjob(/unrcj) de huy thue. ");
	if (!IsPlayerInAnyVehicle(playerid))			return SendErrorMessage(playerid, "Ban phai o trong mot chiec xe lam viec! ");
	
	new vehicle = GetPlayerVehicleID(playerid);

	if (!IsPizzaCar(vehicle) && PlayerInfo[playerid][pJob] == JOBLESS) return SendErrorMessage(playerid,"Ban dang that nghiep.");
	if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)		  		  return SendErrorMessage(playerid, "Ban phai dang lai mot chiec xe.");

	if (VehicleInfo[vehicle][carRent])			return SendErrorMessage(playerid, "Phuong tien nay da bi ai do chiem giu.");
	if (pTemp[playerid][pRentveh])				return SendErrorMessage(playerid, "Ban can phai huy thue xe/unrentcarjob(/unrcj) !");
	if (GetCash(playerid) < 150)				return SendNotCash(playerid);

	if (IsTruckCar(vehicle) && PlayerInfo[playerid][pJob] == JOB_TRUCKER && GetAvailableTruck(playerid, GetVehicleModel(vehicle)))
	{
		pTemp[playerid][pJob] = 1;
		pTemp[playerid][pJobTime] = gettime();
	}
	else if (IsTaxiCar(vehicle) && PlayerInfo[playerid][pJob] == JOB_TAXI) {
		pTemp[playerid][pJob] = 1;
		pTemp[playerid][pJobTime] = gettime();
	}
	else if (IsLamberJackCar(vehicle) && PlayerInfo[playerid][pJob] == JOB_LAMBERJACKER) {
		pTemp[playerid][pJob] = 1;
	}
	else if (IsTrashMasterCar(vehicle) && PlayerInfo[playerid][pJob] == JOB_TRASHMASTER) {
		pTemp[playerid][pJob] = 1;
		Trash_InitPlayer(playerid);
	}
	else if (IsPizzaCar(vehicle) && PlayerInfo[playerid][pSideJob] == JOB_PIZZA) {
		pTemp[playerid][pJob] = 1;
	}
	else if (IsMinerCar(vehicle) && PlayerInfo[playerid][pJob] == JOB_MINER) {
		pTemp[playerid][pJob] = 1;
	}
	else 
	{
		SendErrorMessage(playerid, "Loai xe sai!");
		if (PlayerInfo[playerid][pJob] == JOB_TRUCKER) SendSyntaxMessage(playerid, "Ban co the tim ra phuong tien co san cho ban su dung /jobhelp !");
		return 1;
	}
	    
	GiveCash(playerid, -150);

	pTemp[playerid][pRentveh] = vehicle;
	VehicleInfo[vehicle][carRent] = PlayerInfo[playerid][pID];

	SendHelpMessage(playerid, "Nhap /jobhelp de biet danh sach cac lenh co san. ");
	SendSyntaxMessage(playerid, "Ban da di xe lam viec %s. Lenh kha dung: /unrentcarjob(/unrcj), /lock.", VehicleNames[GetVehicleModel(vehicle)-400]);
	SendSyntaxMessage(playerid, "Chu y! Neu ban khong su dung xe trong 10 phut, no se bien mat. ");

	return 1;
}

ALTX:unrentcarjob("/unrcj");
CMD:unrentcarjob(playerid, params[])
{
	if (!pTemp[playerid][pRentveh]) return 1;

    SendSyntaxMessage(playerid, "Ban da tra lai mot chiec xe dang hoat dong.");
	EndJob(playerid);
	return 1;
}

EndJob(playerid) {
	//������� ���, ����� �� �������� � ������ ���� ������� ���������
	new vehicle = pTemp[playerid][pRentveh];
	
	if (PlayerInfo[playerid][pJob] == JOB_TRASHMASTER && pTemp[playerid][pJob])
	{
		Trash_ResetPlayer(playerid, 1);
		EndTrashJob(playerid);
	}
	
	pTemp[playerid][pRentveh] = 0;
    VehicleInfo[vehicle][carRent] = 0;

	pTemp[playerid][pJob] = 0;
	pTemp[playerid][pJobTime] = 0;

    RespawnVehicle(vehicle);
	return 1;
}

CMD:buydrugs(playerid, params[])
{
	new faction = PlayerInfo[playerid][pFaction];
	
	if (!PlayerInfo[playerid][pFaction])	return SendErrorMessage(playerid, "Ban khong phai la thanh vien cua phe chinh thuc.");
	//if (PlayerInfo[playerid][pSideJob] != JOB_DRUGDEALER)	return SendErrorMessage(playerid, "Ban khong co quyen mua thuoc.");
	if (Factions[faction][fType] != FACTION_GANG && Factions[faction][fType] != FACTION_MAFIA)	return 1;

	if (!PlayerToPoint(2.0, playerid, BLACKMARKET_X, BLACKMARKET_Y, BLACKMARKET_Z))
	{
	    Waypoint_Set(playerid, BLACKMARKET_X, BLACKMARKET_Y, BLACKMARKET_Z);
	    return SendErrorMessage(playerid, "Ban phai o ben cang (Docks).");
	}

    Dialog_Show(playerid, BuyDrugs, DIALOG_STYLE_TABLIST, "Mua thuoc", "Hat giong Marijuanna\t50$/1 manh.\nLSD\t150$/1 gram.\nHeroin\t100$/1 gram.\nCocaine\t200$/1 gram.\nEphedrine\t50$/1 manh.", "Mua", "Huy bo");
	return 1;
}

CMD:buygun(playerid, params[])
{
    new bizid = -1;

	if ((bizid = GetNearInsideBiz(playerid)) != -1 && BizInfo[bizid][bizType] == BIZ_AMMO) return BuyGunMenu(playerid);

	new faction = PlayerInfo[playerid][pFaction];

	if (!PlayerInfo[playerid][pFaction])	 													return SendErrorMessage(playerid, "Ban khong phai la thanh vien cua phe chinh thuc. ");
	//if (PlayerInfo[playerid][pSideJob] != JOB_GUNDEALER)										return SendErrorMessage(playerid, "Ban khong co quyen truy cap de mua vu khi. ");
	if (Factions[faction][fType] != FACTION_GANG && Factions[faction][fType] != FACTION_MAFIA)	return 1;

	if (!PlayerToPoint(2.0, playerid, BLACKMARKET_X, BLACKMARKET_Y, BLACKMARKET_Z))
	{
	    Waypoint_Set(playerid, BLACKMARKET_X, BLACKMARKET_Y, BLACKMARKET_Z);
	    return SendErrorMessage(playerid, "Ban phai o ben cang (Docks).");
	}

	new title[56];
	format(title, sizeof(title), "Tren tai khoan cua phe cua ban - %i kinh nghiem.", Factions[faction][fPoint]);
	Dialog_Show(playerid, BuyGunMain, DIALOG_STYLE_LIST, title, "- Vu khi\n- Dan", "Lua chon", "Huy bo");
	return 1;
}

CMD:stealradio(playerid, params[])
{
	new vehicle = GetPlayerVehicleID(playerid);

    if (!vehicle || !IsDriver(playerid))				return SendErrorMessage(playerid, "Ban phai ngoi sau ghe lai xe.");
	if (!VehicleInfo[vehicle][carOwnerID])				return SendErrorMessage(playerid, "May ghi am vo tuyen chi co the bi danh cap tu xe ca nhan. ");
    if (!VehicleInfo[vehicle][carRadio])				return SendErrorMessage(playerid, "Khong co radio trong phuong tien nay. ");
    if (IsPlayerHasItem(playerid, INV_CARSOUND))		return SendErrorMessage(playerid, "Ban da co mot dai phat thanh trong kho cua minh. ");
    if (GiveInvItem(playerid, INV_CARSOUND, 1) == -1)	return SendErrorMessage(playerid, "Tui do da day.");
    
	VehicleInfo[vehicle][carRadio] = 0;
	
	new mes[128];
	format(mes, sizeof(mes), "lay mot radio tu %s.", VehicleNames[GetVehicleModel(vehicle)-400]);
	cmd::me(playerid, mes);
	return 1;
}

CMD:factionjob(playerid, params[])
{
	if (!PlayerInfo[playerid][pFaction])																										return SendErrorMessage(playerid, "Ban phai la thanh vien cua bang dang / phe mafia chinh thuc.");
	if (Factions[PlayerInfo[playerid][pFaction]][fType] != FACTION_GANG && Factions[PlayerInfo[playerid][pFaction]][fType] != FACTION_MAFIA)	return SendErrorMessage(playerid, "Ban phai thuoc nhom bang dang / mafia chinh thuc.");
    if (!isLeader(playerid))																													return SendErrorMessage(playerid, "Doi chi danh cho thu linh cua bang dang hoac mafia chinh thuc.");

	new userid, level;

	if (sscanf(params, "ud", userid, level)) return SendHelpMessage(playerid, "/factionjob [ID/Ten] [0 - close access | 1 - tiep can de mua thuoc | 2 - quyen truy cap de mua vu khi] ");

	if (!IsPlayerLogged(userid))											return SendNotConnected(playerid);
	if (PlayerInfo[userid][pFaction] != PlayerInfo[playerid][pFaction])	return SendErrorMessage(playerid, "Nguoi choi khong phai la thanh vien cua to chuc cua ban.");
    if (level > 2 || level < 0)											return SendErrorMessage(playerid, "Tham so phai tu 1 den 2. ");
		
	if (!level)
	{
	    if (PlayerInfo[userid][pSideJob] == 0)	return SendErrorMessage(playerid, "Nguoi choi khong co quyen truy cap vao bat ky quyen nao. ");

		SendSyntaxMessage(userid, "Lanh dao phe phai %s da lay di quyen lam viec cua ban %s.", GetNameEx(playerid), GetJobName(PlayerInfo[userid][pSideJob]));
		SendSyntaxMessage(playerid, "Ban da lay di quyen lam viec tu %s %s.", GetNameEx(userid), GetJobName(PlayerInfo[userid][pSideJob]));
        PlayerInfo[userid][pSideJob] = 0;
		return 1;
	}
	
    PlayerInfo[userid][pSideJob] = level + 3;
	SendSyntaxMessage(userid, "Nguoi lanh dao cua phe %s da cap cho ban quyen truy cap vao cong viec %s.", GetNameEx(playerid), GetJobName(PlayerInfo[userid][pSideJob]));
	SendSyntaxMessage(playerid, "Ban da cap cho %s quyen truy cap cong viec%s.", GetNameEx(userid), GetJobName(PlayerInfo[userid][pSideJob]));
	return 1;
}