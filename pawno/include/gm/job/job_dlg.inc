Dialog:BuyDrugs(playerid, response, listitem, inputtext[])
{
	if (!response) return 1;

	new drug_list_name[][] = {"Hat giong Marijuanna "," LSD "," Heroin "," Cocaine "," Ephedrine"}, drug_list_price[] = {50, 150, 100, 200, 50};
	
	static const str_size[] = "{FFFFFF}Ban muon mua %s$ %i cho 1 gram.\nSo luong co san de mua: 1 - 1000:";
	new mes[sizeof(str_size) - 4 + 7 + 3 + 1];

	format(mes, sizeof(mes), str_size, drug_list_name[listitem], drug_list_price[listitem]);
    Dialog_Show(playerid, BuyDrugsAccept, DIALOG_STYLE_INPUT, "{FFFFFF}Mua thuoc", mes, "Lua chon", "Huy bo");
    SetPVarInt(playerid, #select_law, listitem);
	return 1;
}

Dialog:BuyDrugsAccept(playerid, response, listitem, inputtext[])
{
	if (!response)	return cmd::buydrugs(playerid, "");

	new amount = strval(inputtext);

	listitem = GetPVarInt(playerid, #select_law);

	if (amount < 0 || amount > 1000)	return SendErrorMessage(playerid, "Wrong amount of drugs: 1 - 1000.");
	
    new faction = PlayerInfo[playerid][pFaction];

	if (!PlayerInfo[playerid][pFaction])														return SendErrorMessage(playerid, "Ban khong phai la thanh vien cua phe chinh thuc. ");
	if (PlayerInfo[playerid][pSideJob] != JOB_DRUGDEALER)										return SendErrorMessage(playerid, "Ban khong co quyen mua thuoc.");
	if (Factions[faction][fType] != FACTION_GANG && Factions[faction][fType] != FACTION_MAFIA)	return 1;
    if (!PlayerToPoint(2.0, playerid, BLACKMARKET_X, BLACKMARKET_Y, BLACKMARKET_Z))
	{
	    Waypoint_Set(playerid, BLACKMARKET_X, BLACKMARKET_Y, BLACKMARKET_Z);
	    return SendErrorMessage(playerid, "Ban phai o ben cang (Docks). ");
	}

	new drug_list[] = {INV_SEED_GANJA, INV_LSD, INV_HEROIN, INV_COCAINE, INV_EPHEDRINE}, drug_price[] = {50, 150, 100, 200, 50};

	if (GetCash(playerid) < drug_price[listitem] * amount)			return SendNotCash(playerid);
	if (GiveInvItem(playerid, drug_list[listitem], amount) == -1)	return SendErrorMessage(playerid, "Tui do da day.");

	SendSyntaxMessage(playerid, "Ban da mua %i gram %s cho $%i.", amount, inventory_items[drug_list[listitem]][itemName], drug_price[listitem] * amount);
	GiveCash(playerid, -drug_price[listitem] * amount);
	return 1;
}

Dialog:BuyAmmoLaw(playerid, response, listitem, inputtext[])
{
	if (!response)	return cmd::buygun(playerid, "");

    new faction = PlayerInfo[playerid][pFaction], ammo = 1;

	new gun_list[][20] = {"M1911","M1911","Desert Eagle","Desert Eagle","Shotgun","Shotgun","Shotgun","Tec-9 / MP5 / Uzi", "Tec-9 / MP5 / Uzi","Country Rifle"},
		ammo_list[] = {82, 83, 84, 85, 86, 87, 88, 90, 91, 96},
		ammo_pr[] = {35, 80, 60, 130, 300, 200, 100, 200, 450, 400};

	if (!PlayerInfo[playerid][pFaction])															return SendErrorMessage(playerid, "Ban khong phai la thanh vien cua phe chinh thuc. ");
	if (PlayerInfo[playerid][pSideJob] != JOB_GUNDEALER)											return SendErrorMessage(playerid, "Ban khong co quyen truy cap de mua vu khi. ");
	if (Factions[faction][fType] != FACTION_GANG && Factions[faction][fType] != FACTION_MAFIA)		return 1;
    if (!PlayerToPoint(2.0, playerid, BLACKMARKET_X, BLACKMARKET_Y, BLACKMARKET_Z))
	{
	    Waypoint_Set(playerid, BLACKMARKET_X, BLACKMARKET_Y, BLACKMARKET_Z);
	    return SendErrorMessage(playerid, "Ban phai o ben cang (Docks).");
	}

	if (!CheckInv(playerid)) 					return SendErrorMessage(playerid, "Khong du slot trong tui do cua ban. ");
	if (GetCash(playerid) < ammo_pr[listitem])	return SendNotCash(playerid);
	if (Factions[faction][fPoint]- ammo < 0)	return SendErrorMessage(playerid, "Phe cua ban khong co du diem de mua. ");
    
	GiveCash(playerid, -ammo_pr[listitem]);
	GiveInvItem(playerid, ammo_list[listitem], CheckAmmo(ammo_list[listitem])); 

	Factions[faction][fPoint] -= 1;
	SQL_SetInteger("factions", "point", Factions[faction][fPoint], Factions[faction][fID]);

	SendBlackMarketMessage(playerid, "Ban da mua mot cua hang %s [%i round] cho %s voi gia $%i va 1 diem kinh nghiem.", inventory_items[ammo_list[listitem]][itemName], CheckAmmo(ammo_list[listitem]), gun_list[listitem], ammo_pr[listitem]);
	return 1;
}

Dialog:BuyGunLaw(playerid, response, listitem, inputtext[])
{
	if (!response)	return cmd::buygun(playerid, "");

    new faction = PlayerInfo[playerid][pFaction];

	if (!PlayerInfo[playerid][pFaction])														return SendErrorMessage(playerid, "Ban khong phai la thanh vien cua phe chinh thuc.");
	if (PlayerInfo[playerid][pSideJob] != JOB_GUNDEALER)										return SendErrorMessage(playerid, "Ban khong co quyen truy cap de mua vu khi.");
	if (Factions[faction][fType] != FACTION_GANG && Factions[faction][fType] != FACTION_MAFIA)	return 1;

	if (Factions[faction][fType] == FACTION_MAFIA)
	{
		new gun_list[] = {24, 22, 23, 25, 26, 27, 28, 32, 29, 30, 31, 33, 16, 18, INV_OPTICS, INV_SILENCER, INV_TOOLS}, 
			gun_point[] = {3, 3, 3, 4, 4, 4, 5, 5, 5, 7, 7, 10, 10, 4, 2, 2, 1}, 
			gun_price[] = {1800, 1000, 1500, 2400, 2100, 4000, 2000, 2500, 2800, 3500, 4300, 3800, 1000, 300, 1700, 500, 300}, 
			gun_ammo[] = {50, 50, 50, 30, 30, 30, 120, 120, 120, 150, 150, 15, 1, 1, 1, 1, 1};

        if (Factions[faction][fPoint]-gun_point[listitem] < 0)																	return SendErrorMessage(playerid, "Phe cua ban khong co du diem de mua.");
        //if (ValidWeaponForInventory(gun_list[listitem]) && PlayerInfo[playerid][pWeap][GetWeapSlot(gun_list[listitem])] != 0)	return SendErrorMessage(playerid, "� ��� ��� ���� ������ � ������ �����.");
		    
		new mes[256];
		if (ValidWeaponForInventory(gun_list[listitem]))
		{
			format(mes, sizeof(mes), "{FFFFFF}Ban co chac chan muon mua %s va %i dan voi gia %i exp va $%i khong?\nPhe cua ban se co %i exp.",
			inventory_items[gun_list[listitem]][itemName], gun_ammo[listitem], gun_point[listitem], gun_price[listitem], Factions[faction][fPoint]-gun_point[listitem]);
		}
		else
		{
			format(mes, sizeof(mes), "{FFFFFF}Ban co chac chan muon mua %s voi gia %i exp va $%i?\nPhe cua ban se co %i exp.",
			inventory_items[gun_list[listitem]][itemName], gun_point[listitem], gun_price[listitem], Factions[faction][fPoint]-gun_point[listitem]);
		}
    	Dialog_Show(playerid, BuyGunAccept, DIALOG_STYLE_MSGBOX, "{FFFFFF}Mua vu khi", mes, "Mua", "Quay lai");
	}

	else if (Factions[faction][fType] == FACTION_GANG)
	{
		new gun_list[] = {24, 22, 25, 26, 28, 32, 18, INV_TOOLS}, gun_point[] = {3, 3, 4, 4, 5, 5, 4, 1}, gun_price[] = {1800, 1000, 2400, 2100, 2000, 2500, 300, 300}, gun_ammo[] = {50, 50, 30, 30, 120, 120, 1, 1};

        if (Factions[faction][fPoint]-gun_point[listitem] < 0)																	return SendErrorMessage(playerid, "Phe cua ban khong co du diem de mua.");
        //if (ValidWeaponForInventory(gun_list[listitem]) && PlayerInfo[playerid][pWeap][GetWeapSlot(gun_list[listitem])] != 0)	return SendErrorMessage(playerid, "� ��� ��� ���� ������ � ������ �����.");
		    
		new mes[256];

		if (ValidWeaponForInventory(gun_list[listitem]))
		{
			format(mes, sizeof(mes), "{FFFFFF}Ban co chac chan muon mua %s va %i rounds voi gia %i exp va $%i?\nPhe cua ban se co %i exp.",
			inventory_items[gun_list[listitem]][itemName], gun_ammo[listitem], gun_point[listitem], gun_price[listitem], Factions[faction][fPoint]-gun_point[listitem]);
		}
		else
		{
			format(mes, sizeof(mes), "{FFFFFF}Ban co chac chan muon mua %s voi gia %i exp va $%i?\nPhe cua ban se co %i exp.",
			inventory_items[gun_list[listitem]][itemName], gun_point[listitem], gun_price[listitem], Factions[faction][fPoint]-gun_point[listitem]);
		}
    	Dialog_Show(playerid, BuyGunAccept, DIALOG_STYLE_MSGBOX, "Mua vu khi", mes, "Mua", "Quay lai");
	}
	SetPVarInt(playerid, #select_law, listitem);
	return 1;
}

Dialog:BuyGunAccept(playerid, response, listitem, inputtext[])
{
	if (!response)	return cmd::buygun(playerid, "");

	listitem = GetPVarInt(playerid, #select_law);

    new faction = PlayerInfo[playerid][pFaction];

	if (!PlayerInfo[playerid][pFaction])															return SendErrorMessage(playerid, "Ban khong phai la thanh vien cua phe chinh thuc.");
	if (PlayerInfo[playerid][pSideJob] != JOB_GUNDEALER)											return SendErrorMessage(playerid, "Ban khong co quyen truy cap de mua vu khi.");
	if (Factions[faction][fType] != FACTION_GANG && Factions[faction][fType] != FACTION_MAFIA)	return 1;
    if (!PlayerToPoint(2.0, playerid, BLACKMARKET_X, BLACKMARKET_Y, BLACKMARKET_Z))
	{
	    Waypoint_Set(playerid, BLACKMARKET_X, BLACKMARKET_Y, BLACKMARKET_Z);
	    return SendErrorMessage(playerid, "Ban phai o ben cang (Docks).");
	}

	if (Factions[faction][fType] == FACTION_MAFIA)
	{
		new gun_list[] = {24, 22, 23, 25, 26, 27, 28, 32, 29, 30, 31, 33, 16, 18, INV_OPTICS, INV_SILENCER, INV_TOOLS}, gun_point[] = {3, 3, 3, 4, 4, 4, 5, 5, 5, 7, 7, 10, 10, 4, 2, 2, 1},
	    	gun_price[] = {1800, 1000, 1500, 2400, 2100, 4000, 2000, 2500, 2800, 3500, 4300, 3800, 1000, 300, 1700, 500, 300}, gun_ammo[] = {50, 50, 50, 30, 30, 30, 120, 120, 120, 150, 150, 15, 1, 1, 1, 1, 1};

		if (Factions[faction][fPoint]-gun_point[listitem] < 0)																	return SendErrorMessage(playerid, "Phe cua ban khong co du diem de mua.");
		if (GetCash(playerid) < gun_price[listitem])																				return SendNotCash(playerid);
        //if (ValidWeaponForInventory(gun_list[listitem]) && PlayerInfo[playerid][pWeap][GetWeapSlot(gun_list[listitem])] != 0)	return SendErrorMessage(playerid, "� ��� ��� ���� ������ � ������ �����.");
		    
		if (ValidWeaponForInventory(gun_list[listitem]))
		{
		    GivePlayerWeaponEx(playerid, gun_list[listitem], gun_ammo[listitem]);
		    SendSyntaxMessage(playerid, "Ban da mua %s va %i round.", inventory_items[gun_list[listitem]][itemName], gun_ammo[listitem]);
		}
		else
		{
        	if (GiveInvItem(playerid, gun_list[listitem], gun_ammo[listitem]) == -1)	return SendErrorMessage(playerid, "Tui do da day.");
				
			SendSyntaxMessage(playerid, "Ban da mua %s.", inventory_items[gun_list[listitem]][itemName], gun_ammo[listitem]);
		}
		
        Factions[faction][fPoint] -= gun_point[listitem];
        SQL_SetInteger("factions", "point", Factions[faction][fPoint], Factions[faction][fID]);
		GiveCash(playerid, -gun_price[listitem]);
	}

	else if (Factions[faction][fType] == FACTION_GANG)
	{
  		new gun_list[] = {24, 22, 25, 26, 28, 32, 18, INV_TOOLS}, gun_point[] = {3, 3, 4, 4, 5, 5, 4, 1}, gun_price[] = {1800, 1000, 2400, 2100, 2000, 2500, 300, 300}, gun_ammo[] = {50, 50, 30, 30, 120, 120, 1, 1};

		if (Factions[faction][fPoint]-gun_point[listitem] < 0)	return SendErrorMessage(playerid, "Phe cua ban khong co du diem de mua.");
		if (GetCash(playerid) < gun_price[listitem])	return SendNotCash(playerid);
        //if (ValidWeaponForInventory(gun_list[listitem]) && PlayerInfo[playerid][pWeap][GetWeapSlot(gun_list[listitem])] != 0)	return SendErrorMessage(playerid, "� ��� ��� ���� ������ � ������ �����.");

		if (ValidWeaponForInventory(gun_list[listitem]))
		{
		    GivePlayerWeaponEx(playerid, gun_list[listitem], gun_ammo[listitem]);
		    SendSyntaxMessage(playerid, "Ban da mua %s va %i round.", inventory_items[gun_list[listitem]][itemName], gun_ammo[listitem]);
		}
		else
		{
        	if (GiveInvItem(playerid, gun_list[listitem], gun_ammo[listitem]) == -1)	return SendErrorMessage(playerid, "Tui do da day.");

			SendSyntaxMessage(playerid, "Ban da mua %s.", inventory_items[gun_list[listitem]][itemName], gun_ammo[listitem]);
		}

        Factions[faction][fPoint] -= gun_point[listitem];
		SQL_SetInteger("factions", "point", Factions[faction][fPoint], Factions[faction][fID]);
		GiveCash(playerid, -gun_price[listitem]);
	}
	return 1;
}

Dialog:BuyGunMain(playerid, response, listitem, inputtext[])
{
	if (!response)	return 1;

    new faction = PlayerInfo[playerid][pFaction];

	if (!PlayerInfo[playerid][pFaction])	return SendErrorMessage(playerid, "Ban khong phai la thanh vien cua phe chinh thuc.");
	if (PlayerInfo[playerid][pSideJob] != JOB_GUNDEALER)	return SendErrorMessage(playerid, "Ban khong co quyen truy cap de mua vu khi.");
	if (Factions[faction][fType] != FACTION_GANG && Factions[faction][fType] != FACTION_MAFIA)	return 1;

    new title[56];

	format(title, sizeof(title), "{FFFFFF}Tren tai khoan cua phe cua ban - %i exp.", Factions[faction][fPoint]);

	if (listitem == 0)
	{
	    if (Factions[faction][fType] == FACTION_MAFIA)
		{
			new mes[1024] = "Desert Eagle\t-3 exp\t$1.800\n\
							COLT45\t-3 exp\t$1.000\n\
							COLT45(silencer)\t-3 exp\t$1.500\n\
							Shotgun\t-4 exp\t$2.400\n\
							Sawn-off Shotgun\t-4 exp\t$2.100\n\
							Combat Shotgun\t-4 exp\t$4.000\n\
							UZI\t-5 exp\t$2.000\n\
							Tec-9\t-5 exp\t$2.500\n\
							MP5\t-5 exp\t$2.800\n\
							M4\t-7 exp\t$4.300\n\
							Rifle\t-10 exp\t$3.800\n\
							Grenade\t-10 exp\t$1000\n\
							Molotov cocktail\t-4 exp\t$300\n\
							Optical sight\t-2 exp\t$1700\n\
							Silencer\t-2 exp\t$500\n\
							Lock pick\t-1 exp\t$300";
			
			Dialog_Show(playerid, BuyGunLaw, DIALOG_STYLE_TABLIST, title, mes, "Mua", "Huy bo");
		}
		else
		{
		    Dialog_Show(playerid, BuyGunLaw, DIALOG_STYLE_TABLIST, title, "Desert Eagle\t-3 exp\t$1.800\n\
																			COLT45\t-3 exp\t$1.000\n\
																			Shotgun\t-4 exp\t$2.400\n\
																			Sawn-off Shotgun\t-4 exp\t$2.100\n\
																			UZI\t-5 exp\t$2.000\n\
																			Tec-9\t-5 exp\t$2.500\n\
																			Molotov cocktail\t-4 exp\t$300\n\
																			Lock pick\t-1 exp\t$300", "Mua", "Huy bo");
		}
	}

	else if (listitem == 1)
	{
	    Dialog_Show(playerid, BuyAmmoLaw, DIALOG_STYLE_TABLIST, title, "100 units.\t-1 exp\t$400\n200 units.\t-2 exp\t$800\n300 units.\t-3 exp\t$1.200\n400 units.\t-4 exp\t$1.600\n500 units.\t-5 exp\t$2.000\n600 units.\t-6 exp\t$2.400", "Mua", "Huy bo");
	}
	return 1;
}

Dialog:TakeJobMenu(playerid, response, listitem, inputtext[])
{
	if (!response) return 1;

	switch(listitem) {
		case 0: {
			new i = Job_Nearest(playerid);
			if (i == -1) return 1;

			if (JobsInfo[i][jobType] == JOB_PIZZA || JobsInfo[i][jobType] == JOB_GUNDEALER || JobsInfo[i][jobType] == JOB_DRUGDEALER)
			{
				if (PlayerInfo[playerid][pSideJob] != JOBLESS) return SendSyntaxMessage(playerid, "Ban da co mot cong viec thu hai. Nhap /quitsidejob de thoat.");
				
				PlayerInfo[playerid][pSideJob] = JobsInfo[i][jobType];
				SQL_SetInteger("users", "sidejob", JobsInfo[i][jobType], PlayerInfo[playerid][pID]);
				
				if (JobsInfo[i][jobType] == JOB_PIZZA) SendSyntaxMessage(playerid, "Ban da nhan cong viec Pizza Deliver. Delivering pizza - /pizzajob");
				if (JobsInfo[i][jobType] == JOB_GUNDEALER) SendSyntaxMessage(playerid, "Ban da nhan cong viec Gun Dealer. Mua vu khi - /buygun ");
				if (JobsInfo[i][jobType] == JOB_DRUGDEALER) SendSyntaxMessage(playerid, "Ban da nhan cong viec Drug Dealer. Mua thuoc - /buydrug");
				return 1;
			}
				
			if (PlayerInfo[playerid][pJob] != JOBLESS)									return SendErrorMessage(playerid, "Ban da co mot cong viec. Nhap /quitjob de thoat khoi cong viec. ");
			if (JobsInfo[i][jobType] == JOB_TAXI && !PlayerInfo[playerid][pTaxiLic])	return SendErrorMessage(playerid, "Ban khong co bang lai xe taxi. De co duoc no, hay lien he voi mot truong day lai xe. ");

			PlayerInfo[playerid][pJob] = JobsInfo[i][jobType];
			PlayerInfo[playerid][pCareer] = 0;

			SQL_SetInteger("users", "job", JobsInfo[i][jobType], PlayerInfo[playerid][pID]);

			SendSyntaxMessage(playerid, "Ban co mot cong viec voi '%s'. Tim hieu ve cong viec - /jobhelp", jobs_names[JobsInfo[i][jobType]]);
			return 1;
		}
		case 1: {
			new i = Job_Nearest(playerid);
			if (i == -1) return 1;

			new mes[512];
			format(mes, sizeof(mes), "/rentcarjob(/rcj) - thue mot phuong tien cong viec\n/unrentcarjob(/unrcj) - huy thue phuong tien\n");
			if (JobsInfo[i][jobType] == 8) {
				format(mes, sizeof(mes), "/chainsaw - de mua mot may cua sau do \nBam N 'Inventory' de su dung\n");
				format(mes, sizeof(mes), "Chat cay va sau do /lumber tree de lay khuc go\n/lumber sell de ban khuc go\n");
			}
			if (JobsInfo[i][jobType] == JOB_PIZZA) {
				format(mes, sizeof(mes), "%s/pizzajob - giao pizza\n\
											/takepizza - lay pizza\n\
											/quitsidejob - thoat", mes);
			} else if (JobsInfo[i][jobType] == JOB_CARJACKER) {
				format(mes, sizeof(mes), "/delivercar - thao do cac bo phan co gia tri cua xe\n\
										/dropoff - thoat khoi phuong tien\n\
										/leavemission - lam lai nhiem vu\n\n\
										/vb(reak)l(ock) (n)oisy - cuop xe 1 cach manh me\n\
										/vb(reak)l(ock) (q)uite - cuop xe 1 cach im lang");
			} else if (JobsInfo[i][jobType] == JOB_TAXI) {
				format(mes, sizeof(mes), "%s/taxi duty - bat dau /stop work\n\
											/taxi fare - thay doi gia\n\
											/taxi accept - chap nhan cuoc goi", mes);
			} else if (JobsInfo[i][jobType] == JOB_TRUCKER) {
				format(mes, sizeof(mes), "%s/tpda - trucker menu\n\
											/industry - thong tin ve cong ty - bussiness\n\
											/cargo - lam viec\n\
											/trailer - dieu khien xe keo\n", mes);
				switch(PlayerInfo[playerid][pCareer]) {
					case 0..11: strcat(mes, "Phuong tien kha dung: Picador, Sadler, Bobcat, Walton, Yosemite.");
					case 12..23: strcat(mes, "Phuong tien kha dung: Picador, Sadler, Bobcat, Walton, Yosemite,\n Pony, Berkley's RC Van, Burrito.");
					case 24..31: strcat(mes, "Phuong tien kha dung: Picador, Sadler, Bobcat, Walton, Yosemite,\n Pony, Berkley's RC Van, Burrito, Rumpo, Boxville.");
					case 32..47:
					{
						strcat(mes, "Phuong tien kha dung: Picador, Sadler, Bobcat, Walton, Yosemite,\n Pony, Berkley's RC Van, Burrito, Rumpo, Boxville.\n");
						strcat(mes, "Benson, Mule, DFT-30, Tanker, Securicar.");
					}
					case 48..58:
					{
						strcat(mes, "Phuong tien kha dung: Picador, Sadler, Bobcat, Walton, Yosemite,\n Pony, Berkley's RC Van, Burrito, Rumpo, Boxville.\n");
						strcat(mes, "Benson, Mule, DFT-30, Tanker, Securicar, Yankee, Flatbed.");
					}
					default:
					{
						strcat(mes, "Phuong tien kha dung: Picador, Sadler, Bobcat, Walton, Yosemite,\n Pony, Berkley's RC Van, Burrito, Rumpo, Boxville.\n");
						strcat(mes, "Benson, Mule, DFT-30, Tanker, Securicar, Yankee, Flatbed, ��������.");
					}
				}
			} else if (JobsInfo[i][jobType] == JOB_TRASHMASTER) {
				format(mes, sizeof(mes), "%s\nBan can thu gom rac tu cac thung chua va dua chung den bai rac!", mes);
			} else return cmd::jobhelp(playerid, "");

			Dialog_Show(playerid, None, DIALOG_STYLE_MSGBOX, "{FFFFFF}Lenh cong viec", mes, "Quay lai", "Dong");
			return 1;
		}
		case 2: cmd::takejob(playerid, "");
		case 3: cmd::quitjob(playerid, "");
	}

	return 1;
}
