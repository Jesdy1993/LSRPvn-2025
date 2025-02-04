this::CheckAccount(playerid)
{
    if (!IsPlayerConnected(playerid))	return 1;

    SetPlayerColor(playerid, TEAM_HIT_COLOR);
	
	new name[MAX_PLAYER_NAME + 1];
	GetPlayerName(playerid, name, sizeof(name));

	new query[256 - 4 + (MAX_PLAYER_NAME * 2) + 1];
	//mysql_format(dbHandle, query, sizeof(query), "SELECT accounts.login, accounts.id, accounts.last_game_ip, accounts.google_auth FROM `accounts`, `users` WHERE (accounts.login = '%e' OR users.name = '%e') AND accounts.id = users.accountid", name, name);
	//"SELECT id FROM accounts WHERE login = '%s'"
	//"SELECT * FROM users WHERE uid = %i"
	mysql_format(dbHandle, query, sizeof(query),"SELECT * FROM accounts WHERE login = '%e'", name);
	//mysql_format(dbHandle, query, sizeof(query), "SELECT accounts.login AS login, accounts.id AS id, accounts.last_game_ip AS last_game_ip , accounts.google_auth AS google_auth FROM `accounts`, `users` WHERE accounts.login = '%e' OR (users.name = '%e' AND accounts.id = users.accountid) LIMIT 1", name, name);
	mysql_tquery(dbHandle, query, "OnAccountCheck", "d", playerid);
	return 1;
}

this::LoadCharacter(playerid)
{
	if (cache_num_rows())
	{
		TogglePlayerSpectating(playerid, false);
	    new status = cache_get_field_content_int(0, "status");

	    switch(status)
		{
		    case 0:
			{
				SendErrorMessage(playerid, "Nhan vat cua ban dang duoc xem xet. Them chi tiet trong tai khoan cua ban: %s", WeburlName);
				ShowCharacterMenu(playerid);
				return 1;
			}
      		case 2:
			{
				SendErrorMessage(playerid, "Nhan vat cua ban da bi TU CHOI. Them chi tiet trong tai khoan cua ban: "WeburlName"");
				ShowCharacterMenu(playerid);
				return 1;
			}
			case 3:
			{
			    new admin_name[MAX_PLAYER_NAME + 1];
			    cache_get_field_content(0, "block_name", admin_name);
			    
				new reason[65];
			    cache_get_field_content(0, "block_reason", reason);
			    
				static const str_size[] = "Nhan vat cua ban da bi quan tri vien chan %s.\nLy do: %s";
			    new str[sizeof(str_size) - 4 + MAX_PLAYER_NAME + 64];
			    format(str, sizeof(str), str_size, admin_name, reason);
			    Dialog_Show(playerid, None, DIALOG_STYLE_MSGBOX, "Blocking", str, "Close", "");
				return KickEx(playerid);
			}
			case 4: return Kick(playerid);
		}

	    PlayerInfo[playerid][pID] = cache_get_field_content_int(0, "id");
		
	    foreach (new i : Player)
		{
			if (!IsPlayerLogged(i) || PlayerInfo[playerid][pAccID] != PlayerInfo[i][pAccID]) continue;

			SendErrorMessage(playerid, "Tai khoan nay da duoc su dung. [Load Character]");
			KickEx(playerid);
			return 1;
		}

		new name[MAX_PLAYER_NAME+1];

		cache_get_field_content(0, "name", name);

  		if (!CompareStrings(PlayerInfo[playerid][pAccname], name) && SetPlayerName(playerid, name) != 1)
		{
		    SendErrorMessage(playerid,"Tai khoan nay da duoc su dung. [Load Character]");
		    KickEx(playerid);
		    return 1;
		}
	    GetNameForPlayer(playerid);

		SQL_SetInteger("users", "online", 1, PlayerInfo[playerid][pID]);

		//Load database
		PlayerInfo[playerid][pTutorial] = cache_get_field_content_int(0, "tutorial");
		PlayerInfo[playerid][pCash] = cache_get_field_content_int(0, "cash");
		PlayerInfo[playerid][pBank] = cache_get_field_content_int(0, "bank");
		PlayerInfo[playerid][pSkin] = cache_get_field_content_int(0, "skin");
		PlayerInfo[playerid][pSex] = cache_get_field_content_int(0, "sex");
	 	cache_get_field_content(0, "birthdate", PlayerInfo[playerid][pBirthdate], dbHandle, 24);
		PlayerInfo[playerid][pAge] = cache_get_field_content_int(0, "age");
		cache_get_field_content(0, "appearance", PlayerInfo[playerid][pAppearance], dbHandle, 168);
		PlayerInfo[playerid][pLevel] = cache_get_field_content_int(0, "level");
		PlayerInfo[playerid][pHours] = cache_get_field_content_int(0, "hours");
		PlayerInfo[playerid][pAdminHide] = cache_get_field_content_int(0, "admin_hide");
		
		cache_get_field_content(0, "admin_code", PlayerInfo[playerid][pAdminCode], dbHandle, 65);

		PlayerInfo[playerid][pAdmin] = cache_get_field_content_int(0, "admin");
		PlayerInfo[playerid][pHelper] = cache_get_field_content_int(0, "helper");
		PlayerInfo[playerid][pDonate] = cache_get_field_content_int(0, "donate");
        PlayerInfo[playerid][pNameChanges] = cache_get_field_content_int(0, "name_changes");
        PlayerInfo[playerid][pNumberChanges] = cache_get_field_content_int(0, "number_changes");
		
		PlayerInfo[playerid][pInt] = cache_get_field_content_int(0, "int");
		PlayerInfo[playerid][pWorld] = cache_get_field_content_int(0, "world");
		PlayerInfo[playerid][pAJailed] = cache_get_field_content_int(0, "ajailed");
		PlayerInfo[playerid][pAJailTime] = cache_get_field_content_int(0, "ajailtime");
		PlayerInfo[playerid][pJailed] = cache_get_field_content_int(0, "jailed");
		PlayerInfo[playerid][pIsolateTime] = cache_get_field_content_int(0, "isolatetime");
		PlayerInfo[playerid][pPremium] = cache_get_field_content_int(0, "vip");
		PlayerInfo[playerid][pPremiumTime] = cache_get_field_content_int(0, "vip_time");
		PlayerInfo[playerid][pCarLic] = cache_get_field_content_int(0, "carlic");
		PlayerInfo[playerid][pWepLic] = cache_get_field_content_int(0, "weplic");
		PlayerInfo[playerid][pFlyLic] = cache_get_field_content_int(0, "flylic");
		PlayerInfo[playerid][pTaxiLic] = cache_get_field_content_int(0, "taxilic");
		PlayerInfo[playerid][pInjured] = cache_get_field_content_int(0, "injured");
		PlayerInfo[playerid][pDeathReason] = cache_get_field_content_int(0, "deathreason");
		PlayerInfo[playerid][pPayCheckMoney] = cache_get_field_content_int(0, "paycheck");
		PlayerInfo[playerid][pPayDayTime] = cache_get_field_content_int(0, "paydaytime");
		PlayerInfo[playerid][pNumber] = cache_get_field_content_int(0, "number");
		PlayerInfo[playerid][pSavings] = cache_get_field_content_int(0, "savings");
		PlayerInfo[playerid][pMutedTime] = cache_get_field_content_int(0, "mutetime");
		PlayerInfo[playerid][pRentKey] = cache_get_field_content_int(0, "rent_key");
		PlayerInfo[playerid][pRentPrice] = cache_get_field_content_int(0, "rent_price");

		PlayerInfo[playerid][pHideWeap][0] = cache_get_field_content_int(0, "weaphide0");
		PlayerInfo[playerid][pHideWeap][1] = cache_get_field_content_int(0, "weaphide1");
		PlayerInfo[playerid][pHideWeap][2] = cache_get_field_content_int(0, "weaphide2");

		PlayerInfo[playerid][pChannel] = cache_get_field_content_int(0, "channel");
		PlayerInfo[playerid][pOwnedChannel] = cache_get_field_content_int(0, "owned_channel");
		PlayerInfo[playerid][pAuthed] = cache_get_field_content_int(0, "authed");
		PlayerInfo[playerid][pSpareKey] = cache_get_field_content_int(0, "sparekey");
		PlayerInfo[playerid][pWorkOn] = cache_get_field_content_int(0, "workon");
		PlayerInfo[playerid][pWalk] = cache_get_field_content_int(0, "walk");
		PlayerInfo[playerid][pArmour] = cache_get_field_content_float(0, "armour");
		PlayerInfo[playerid][pFaction] = cache_get_field_content_int(0, "faction");
		PlayerInfo[playerid][pRank] = cache_get_field_content_int(0, "rank");
		PlayerInfo[playerid][pBadgeNumber] = cache_get_field_content_int(0, "badgenumber");
		PlayerInfo[playerid][pDriveWarns] = cache_get_field_content_int(0, "drivewarns");
		PlayerInfo[playerid][pWepWarns] = cache_get_field_content_int(0, "wepwarns");
		PlayerInfo[playerid][pWepCount] = cache_get_field_content_int(0, "wep_count");
		PlayerInfo[playerid][pJailTime] = cache_get_field_content_int(0, "jailtime");
		PlayerInfo[playerid][pArrested] = cache_get_field_content_int(0, "arrested");
		PlayerInfo[playerid][pTalk] = cache_get_field_content_int(0, "chat");
		PlayerInfo[playerid][pAuthwep] = cache_get_field_content_int(0, "authwep");
  		PlayerInfo[playerid][pSwat] = cache_get_field_content_int(0, "swat");
		PlayerInfo[playerid][pSwatDuty] = cache_get_field_content_int(0, "swat_duty");
		PlayerInfo[playerid][pFishCount] = cache_get_field_content_int(0, "fishcount");
		PlayerInfo[playerid][pSlot] = cache_get_field_content_int(0, "slot");
		PlayerInfo[playerid][pJob] = cache_get_field_content_int(0, "job");
		PlayerInfo[playerid][pSideJob] = cache_get_field_content_int(0, "sidejob");
		PlayerInfo[playerid][pPrescribe] = cache_get_field_content_int(0, "prescribe");
		PlayerInfo[playerid][pGanjaTime] = cache_get_field_content_int(0, "ganja_time");
		PlayerInfo[playerid][pCareer] = cache_get_field_content_int(0, "career");
		PlayerInfo[playerid][pSpawnType] = cache_get_field_content_int(0, "spawntype");
		PlayerInfo[playerid][pSpawnPoint] = cache_get_field_content_int(0, "spawnpoint");
		PlayerInfo[playerid][pPosX] = cache_get_field_content_float(0, "pos_X");
		PlayerInfo[playerid][pPosY] = cache_get_field_content_float(0, "pos_Y");
		PlayerInfo[playerid][pPosZ] = cache_get_field_content_float(0, "pos_Z");
		PlayerInfo[playerid][pPosA] = cache_get_field_content_float(0, "pos_A");
		PlayerInfo[playerid][pPrisoned] = cache_get_field_content_int(0, "prisoned");
		PlayerInfo[playerid][pOnDuty] = cache_get_field_content_int(0, "duty");
		PlayerInfo[playerid][pChar] = cache_get_field_content_int(0, "char");
		PlayerInfo[playerid][pHud] = cache_get_field_content_int(0, "hud");
		
		PlayerInfo[playerid][pDrugLabAccess] = cache_get_field_content_int(0, "drugaccess");

		PlayerInfo[playerid][pWeaponBone][0] = cache_get_field_content_int(0, "weap_0_bone");
		PlayerInfo[playerid][pWeaponX][0] = cache_get_field_content_float(0, "weap_0_x");
		PlayerInfo[playerid][pWeaponY][0] = cache_get_field_content_float(0, "weap_0_y");
		PlayerInfo[playerid][pWeaponZ][0] = cache_get_field_content_float(0, "weap_0_z");
		PlayerInfo[playerid][pWeaponRX][0] = cache_get_field_content_float(0, "weap_0_rx");
		PlayerInfo[playerid][pWeaponRY][0] = cache_get_field_content_float(0, "weap_0_ry");
		PlayerInfo[playerid][pWeaponRZ][0] = cache_get_field_content_float(0, "weap_0_rz");

		PlayerInfo[playerid][pWeaponBone][1] = cache_get_field_content_int(0, "weap_1_bone");
		PlayerInfo[playerid][pWeaponX][1] = cache_get_field_content_float(0, "weap_1_x");
		PlayerInfo[playerid][pWeaponY][1] = cache_get_field_content_float(0, "weap_1_y");
		PlayerInfo[playerid][pWeaponZ][1] = cache_get_field_content_float(0, "weap_1_z");
		PlayerInfo[playerid][pWeaponRX][1] = cache_get_field_content_float(0, "weap_1_rx");
		PlayerInfo[playerid][pWeaponRY][1] = cache_get_field_content_float(0, "weap_1_ry");
		PlayerInfo[playerid][pWeaponRZ][1] = cache_get_field_content_float(0, "weap_1_rz");

		PlayerInfo[playerid][pWeaponBone][2] = cache_get_field_content_int(0, "weap_2_bone");
		PlayerInfo[playerid][pWeaponX][2] = cache_get_field_content_float(0, "weap_2_x");
		PlayerInfo[playerid][pWeaponY][2] = cache_get_field_content_float(0, "weap_2_y");
		PlayerInfo[playerid][pWeaponZ][2] = cache_get_field_content_float(0, "weap_2_z");
		PlayerInfo[playerid][pWeaponRX][2] = cache_get_field_content_float(0, "weap_2_rx");
		PlayerInfo[playerid][pWeaponRY][2] = cache_get_field_content_float(0, "weap_2_ry");
		PlayerInfo[playerid][pWeaponRZ][2] = cache_get_field_content_float(0, "weap_2_rz");

		PlayerInfo[playerid][pFightStyle] = cache_get_field_content_int(0, "fightstyle");

		PlayerInfo[playerid][pTog][0] = cache_get_field_content_int(0, "tog_0");
		PlayerInfo[playerid][pTog][1] = cache_get_field_content_int(0, "tog_1");
		PlayerInfo[playerid][pTog][2] = cache_get_field_content_int(0, "tog_2");

		PlayerInfo[playerid][pPhoneOff] = cache_get_field_content_int(0, "phone_off");
		PlayerInfo[playerid][pPhoneAirplane] = cache_get_field_content_int(0, "phone_airplane");
		PlayerInfo[playerid][pPhoneSound] = cache_get_field_content_int(0, "phone_sound");
		PlayerInfo[playerid][pPhoneModel] = cache_get_field_content_int(0, "phone_model");
		PlayerInfo[playerid][pPhoneRingtone] = cache_get_field_content_int(0, "phone_ringtone");
        PlayerInfo[playerid][pPhoneStyle] = cache_get_field_content_int(0, "phone_style");
        PlayerInfo[playerid][pSettings] = cache_get_field_content_int(0, "settings");

		PlayerInfo[playerid][pWarns] = cache_get_field_content_int(0, "warns");

		PlayerInfo[playerid][pPlayerWeapon] = cache_get_field_content_int(0, "PlayerWeapon");
		PlayerInfo[playerid][pPlayerAmmo] = cache_get_field_content_int(0, "PlayerAmmo");
		PlayerInfo[playerid][pAmmoType] = cache_get_field_content_int(0, "AmmoType");
		PlayerInfo[playerid][pWepSerial] = cache_get_field_content_int(0, "WepSerial");

		PlayerInfo[playerid][pPlayerSerial] = cache_get_field_content_int(0, "PlayerSerial");
		if (!PlayerInfo[playerid][pPlayerSerial]) PlayerInfo[playerid][pPlayerSerial] = PlayerInfo[playerid][pID]*100 + 99999 + random(99);

		PlayerInfo[playerid][pLastPrim] = cache_get_field_content_int(0, "LastPrim");
		PlayerInfo[playerid][pLastSec] = cache_get_field_content_int(0, "LastSec");
		PlayerInfo[playerid][pLastMelee] = cache_get_field_content_int(0, "LastMelee");

		PlayerInfo[playerid][pForbid] = cache_get_field_content_int(0, "Forbid");

		cache_get_field_content(0, "Desc1", PlayerInfo[playerid][pDescribe], dbHandle, PAME_MAX_LEN);
		cache_get_field_content(0, "Desc2", PlayerInfo[playerid][pDescribe2], dbHandle, PAME_MAX_LEN);

		if (gettime() - cache_get_field_content_int(0, "last_login") < 25*60) {
			SetPVarInt(playerid, #last_login, 1);
			SetPlayerHealth(playerid, cache_get_field_content_float(0, "health"));
		} else {
			SetPlayerHealth(playerid, cache_get_field_content_float(0, "spawnhealth"));
		}

		for(new w = 0; w < MAX_COP_SLOTS; w++)
		{
			new q_str[16];
			
			format(q_str, sizeof(q_str), "CopItem_%i", w+1);
			PlayerInfo[playerid][pCopItem][w] = cache_get_field_content_int(0, q_str);

			format(q_str, sizeof(q_str), "CopAmmo_%i", w+1);
			PlayerInfo[playerid][pCopQ][w] = cache_get_field_content_int(0, q_str);

			format(q_str, sizeof(q_str), "CopEx_%i", w+1);
			PlayerInfo[playerid][pCopEx][w] = cache_get_field_content_int(0, q_str);

			format(q_str, sizeof(q_str), "CopS_%i", w+1);
			PlayerInfo[playerid][pCopS][w] = cache_get_field_content_int(0, q_str);
		}

		pTemp[playerid][pPayphone] = -1;
		pTemp[playerid][pPayphoneNumStr] = EOS;
		
		pTemp[playerid][pCallLine] = INVALID_PLAYER_ID;
		pTemp[playerid][pCallStatus] = 0;
		pTemp[playerid][pCallIncoming] = 0;
		pTemp[playerid][pCallTime] = 0;
		format(pTemp[playerid][pCallName], 25, "");

		for(new i; i<6; i++) pTemp[playerid][editPos][i] = 0.0;
		
		PhoneInfo[playerid][current_page] = PAGE_NONE;

		LoadPlayerAttach(playerid);
		LoadPlayerMusic(playerid);
        LoadPlayerInventory(playerid);
		LoadPlayerNotes(playerid);
		LoadPlayerContacts(playerid);
		LoadPlayerMarks(playerid);
		LoadPlayerGPS(playerid);
		
        PlayerInfo[playerid][pDependence] = cache_get_field_content_int(0, "dependence");
        PlayerInfo[playerid][pDemolition] = cache_get_field_content_int(0, "demolition");
        PlayerInfo[playerid][pFishTime] = cache_get_field_content_int(0, "fish_time");

		pTemp[playerid][pRegisterScreen] = 0;
		pTemp[playerid][pCharacterScreen] = 0;
		pTemp[playerid][pVehicleScreen] = 0;
		pTemp[playerid][pUsingPayphone] = 0;

		for(new i = 0; i < MAX_VEHICLES; i++)
		{
			if (VehicleInfo[i][carRent] == PlayerInfo[playerid][pID])
			{
				if (VehicleInfo[i][carType] > 5 && VehicleInfo[i][carType] < 10) {
					pTemp[playerid][pJob] = 1;
					pTemp[playerid][pJobTime] = gettime();
				}

			    pTemp[playerid][pRentveh] = i;
			    VehicleInfo[i][carTerminate] = 0;
			}
		}
        ClearChatbox(playerid, 50);
		new gametext[48];

		format(gametext, sizeof(gametext), "~w~Welcome back ~n~~h~~y~   %s", GetNameEx(playerid));
		GameTextForPlayer(playerid, gametext, 2500, 1);
		
        new premium_info[4][32] = {"Usual", "{CC6633}Bronze{FFFFFF}", "{C0C0C0}Silver{FFFFFF}", "{FFD700}Gold{FFFFFF}"};
				
		if (PlayerInfo[playerid][pPremium] && PlayerInfo[playerid][pPremiumTime] > gettime())
		{
			new Float:days = float(PlayerInfo[playerid][pPremiumTime] - gettime()) / 86400.0;

		    SendServerMessage(playerid, "Ban co mot tai khoan Premium: %s. Con lai %i ngay.", premium_info[PlayerInfo[playerid][pPremium]], floatround(days));
		}
		else if (PlayerInfo[playerid][pPremium] && PlayerInfo[playerid][pPremiumTime] < gettime())
		{
		    SendServerMessage(playerid, "Tai khoan premium (%s) da duoc gia han.", premium_info[PlayerInfo[playerid][pPremium]]);

            PlayerInfo[playerid][pPremium] = 0;
            PlayerInfo[playerid][pPremiumTime] = 0;
			PlayerInfo[playerid][pHud] = 0;
			PlayerInfo[playerid][pFightStyle] = 4;
			SQL_SetFloat("users", "spawnhealth", 75.0, PlayerInfo[playerid][pID]);
			Save_User(playerid);			
		}
        if (!(PlayerInfo[playerid][pSettings] & togHUD)) ShowHudTextDraw(playerid);

		if (PlayerInfo[playerid][pInjured])
		{
			if (PlayerInfo[playerid][pInjured] == 3) pTemp[playerid][pInjuredTime] = 120;
			else									pTemp[playerid][pInjuredTime] = 60;
		}

		if (PlayerInfo[playerid][pAdmin] > 0)		SendServerMessage(playerid, "SERVER: Ban da dang nhap voi tu cach Admin %i. (/ah)", PlayerInfo[playerid][pAdmin]);
		else if (PlayerInfo[playerid][pHelper] == 1)	SendServerMessage(playerid, "SERVER: Ban da dang nhap voi tu cach la Tester. (/testerhelp)");	
		
		foreach(new i : Player)
		{
			if (!IsPlayerLogged(i) && i != playerid)	SendClientMessageEx(i, COLOR_GRAD2, "* %s da dang nhap vao may chu.", GetNameEx(playerid));
			else {
				if (!(PlayerInfo[i][pSettings] & togJoin))
				{
					if (CheckAdmin(i, ADMIN_LEVEL_1)) 
					{
						SendClientMessageEx(i, COLOR_GRAD2, "*** %s (ID: %i) da dang nhap vao may chu (IP: %s, cash: $%s, bank: $%s)", GetNameEx(playerid),playerid, q_GetPlayerIP(playerid), FormatNumber(PlayerInfo[playerid][pCash]), FormatNumber(PlayerInfo[playerid][pBank]));
					}
				}
			}
		}

	    if (PlayerInfo[playerid][pOnDuty] && PlayerInfo[playerid][pFaction] && IsFactionLegal(PlayerInfo[playerid][pFaction]))
		{
		    SetPlayerColor(playerid, RemoveAlpha(Factions[PlayerInfo[playerid][pFaction]][fColor]));
		    SendClientMessageEx(playerid, COLOR_GRAD2, "{%06x}[%s]{FFFFFF} Ban da tro lai lam nhiem vu. (Status: 10-7 DUTY)", Factions[PlayerInfo[playerid][pFaction]][fColor] >>> 8, Factions[PlayerInfo[playerid][pFaction]][fShortName]);
			if(IsFactionPolice(PlayerInfo[playerid][pFaction])) pTemp[playerid][tempStatus] = 1;
		}

		new count = CountPlayerTickets(playerid);
		if (count)	SendSyntaxMessage(playerid, "Ban co tien phat chua thanh toan - %i.", count);


		SQL_SetInteger("users", "last_login", gettime(), PlayerInfo[playerid][pID]);
		SQL_SetString("users", "last_ip", q_GetPlayerIP(playerid), PlayerInfo[playerid][pID]);
		

		SetCash(playerid, PlayerInfo[playerid][pCash]);

		if(PlayerInfo[playerid][pTutorial] == 0)
		{
		/*	GameTextForPlayer(playerid, "~g~Tutorial", 3000, 1);
			SetWorld(playerid, playerid + 1);
			PlayAudioStreamForPlayer(playerid, "https://media1.vocaroo.com/mp3/18CH8afocCVd");
			PlayerInfo[playerid][pTutorial] = 2;

			TogglePlayerControllable(playerid, 0);
			SetPlayerPosEx(playerid, 1311.0793, 262.0124, 14.2648);
			SetPlayerCameraPos(playerid, 1311.0793, 262.0124, 14.2648);
			SetPlayerCameraLookAt(playerid, 1311.4695, 262.9306, 14.2898);

			SendClientMessage(playerid, COLOR_WHITE, "Huong dan nay se mang lai loi ich cho ban voi tu cach la nguoi choi moi bang cach giai thich cac tinh nang khac nhau ma may chu phai cung cap.");
			SendClientMessage(playerid, COLOR_WHITE, "O New County, ban se phai nhap vai o tieu chuan thuc te.");
			SendClientMessage(playerid, COLOR_WHITE, "Co rat nhieu quy tac cu the duoc neu ra tren dien dan cua chung toi ma ban phai luon tuan thu.");
			SendClientMessage(playerid, COLOR_WHITE, "Ban co the tim thay danh sach cac quy tac tren dien dan cua chung toi tai newcounty-rp.com/forum.");
			SendClientMessage(playerid, COLOR_WHITE, "Trong suot huong dan nay, ban se duoc cung cap thong tin ve cac lenh huu ich.");
			SendClientMessage(playerid, COLOR_WHITE, "Dung quen kiem tra / tro giup sau khi huong dan ket thuc de phong truong hop ban quen bat ky.");
			SendClientMessage(playerid, COLOR_WHITE, "Mot cach khac de nhan tro giup la thong qua he thong Ho tro, ban co the dat cau hoi bang cach su dung /assistance trong do Nguoi tro giup va Quan tri vien se tra loi bang cau tra loi.");
			SendClientMessage(playerid, COLOR_WHITE, "De bat dau, ban se co mot cai nhin tong quan co ban ve cac he thong noi bat nhat tren may chu: he thong nha, he thong doanh nghiep va he thong xe.");
			SetTimerEx("PlayerTutorial", 8000, 0, "d", playerid);*/
			StopAudioStreamForPlayer(playerid);
		    ClearChatbox(playerid, 50);
		    SendServerMessage(playerid, "Chao mung toi may chu, {ffc46a}%s!", GetNameEx(playerid));
		    SendServerMessage(playerid, "Dung quen ve cac lenh: {ffc46a}/helpme, /help, /mm");
		    if(PlayerInfo[playerid][pHours] < 8)
		    {
		    	SendHelpMessage(playerid, "Khi ban dat den cap do 1, ban se nhan duoc $%i truc tiep vao tai khoan ngan hang cua ban.", SERVER_BONUS);
		    }
		    SetWorld(playerid, 0);
		    SetSpawnInfoEx(playerid, 1641.7317,-2334.3979,-2.6797);
		    pTemp[playerid][pLogged] = 2;
		    
		    /*PlayerInfo[playerid][pSpawnType] = 3;
		    SQL_SetInteger("users", "spawntype", PlayerInfo[playerid][pSpawnType], PlayerInfo[playerid][pID]);*/
		    SQL_SetInteger("users", "tutorial", PlayerInfo[playerid][pTutorial], PlayerInfo[playerid][pID]);
		    //SQL_SetInteger("users", "spawnpoint", PlayerInfo[playerid][pSpawnPoint], PlayerInfo[playerid][pID]);
		    for(new i = 0; i<52; i++) EnableAntiCheatForPlayer(playerid, i, 1);
		    SpawnPlayer(playerid);
		    SetSpawnInfoEx(playerid, 1641.7317,-2334.3979,-2.6797);
			//Dialog_Show(playerid, TutorialDialog, DIALOG_STYLE_MSGBOX, "Introduction", gstr, "Tiep tuc", "");
		}
		else 
		{
			SendServerMessage(playerid, "Chao mung toi may chu, {ffc46a}%s!", GetNameEx(playerid));
			SendServerMessage(playerid, "Dung quen cac lenh: {ffc46a}/helpme, /help, /mm");
			SendHelpMessage(playerid, "Su dung /togtruckmarket de xem gia thi truong Trucker ('De lam trucker ban phai so huu xe Benson')");
			SendHelpMessage(playerid, "/GPS de tim cong viec, dia diem v.v");
			if(PlayerInfo[playerid][pHours] < 8)
			{
				SendHelpMessage(playerid, "Khi ban dat den cap do 1, ban se nhan duoc $%i truc tiep vao tai khoan ngan hang cua ban.", SERVER_BONUS);
			}
		    pTemp[playerid][pLogged] = 2;
			SetSpawnInfoEx(playerid, PlayerInfo[playerid][pPosX],PlayerInfo[playerid][pPosY],PlayerInfo[playerid][pPosZ]);
      		TogglePlayerSpectating(playerid, 0);
		    SpawnPlayer(playerid);
		}
		for(new i = 0; i<52; i++) EnableAntiCheatForPlayer(playerid, i, 1); 
	}
	else
	{
	    SendErrorMessage(playerid, "Khong tim thay nhan vat.");
	    KickEx(playerid);
	}
	return 1;
}

this::OnAccountCheck(playerid)
{
    if (IsPlayerNPC(playerid))	return 1;

	if (!cache_num_rows())
	{
		/*
		ClearChatbox(playerid, 50);
		SendServerMessage(playerid,"Chao mung toi may chu {FFC46A}"WeburlName"{FFFFFF}.");
		SendServerMessage(playerid,"Bay gio ban can dang ky mot tai khoan duy nhat, sau do ban co the bat dau tao cac ky tu !.");

		Dialog_Show(playerid, AccountRegister, DIALOG_STYLE_INPUT, "Dang ky tai khoan", "Nhap ten tai khoan (24 ky tu):\n{C7C7C7}Vi du: {FFFFFF}luuvu", ">>>", "");
		*/
		SendServerMessage(playerid, "Welcome to "ProjectName", Nhap dia chi email hop le cua ban.");
		Dialog_Show(playerid, EmailRegister, DIALOG_STYLE_INPUT, "Dang ky tai khoan", "Nhap email hop le:", ">>>", "");
	    return 1;
	}

	new last_ip[24];

	PlayerInfo[playerid][pAccID] = cache_get_field_content_int(0, "id");
	cache_get_field_content(0, "login", PlayerInfo[playerid][pAccname], dbHandle, MAX_PLAYER_NAME+1);
	cache_get_field_content(0, "last_game_ip", last_ip);
	cache_get_field_content(0, "google_auth", PlayerInfo[playerid][pGoogle], dbHandle, 17);

	if (PlayerInfo[playerid][pAccID] < 1)
	{
	    SendErrorMessage(playerid, "Loi tai khoan, vui long dang nhap lai may chu.");
	    KickEx(playerid);
		return 1;
	}
		
	new name[MAX_PLAYER_NAME];

	GetPlayerName(playerid, name, sizeof(name));

	if (!CompareStrings(PlayerInfo[playerid][pAccname], name) && SetPlayerName(playerid, PlayerInfo[playerid][pAccname]) != 1)
	{
	    SendErrorMessage(playerid, "Tai khoan nay da duoc su dung. [OnAccountCheck]");
	    KickEx(playerid);
	    return 1;
	}
	
	new query[170], sub[8];

	GetPlayerIp(playerid, sub, sizeof(sub));

	new pos;

	for(new i; i < 2; i++)
	{
	    pos = strfind(sub, ".", true, pos+1);
	}

	if (pos != -1) strdel(sub, pos, 24);
	

	new pip[24];

    GetPlayerIp(playerid, pip, sizeof(pip));

	mysql_format(dbHandle, query, sizeof(query), "SELECT * FROM `bans` WHERE `accountid` = '%i'", PlayerInfo[playerid][pAccID]);
	mysql_tquery(dbHandle, query, "OnPlayerAttemptLogin", "is", playerid, last_ip);
	return 1;
}

this::LoginPlayer(playerid)
{
	if (cache_num_rows() == 0)
	{
    	if (pTemp[playerid][pLoggedTry]++ > 3) return KickEx(playerid);
		
		static const str_size[] = "Vui long nhap mat khau tai khoan cua ban de tien hanh dang nhap"; //���� �����������
		new mes[sizeof(str_size)+103];

		format(mes, sizeof(mes), "{FF6347}[ ! ] {FFFFFF}Ban da nhap sai mat khau!\n{FF6347}[ ! ] {FFFFFF}Thu con lai: {FF6347}%d\n\n%s", 3-pTemp[playerid][pLoggedTry], str_size);	
		Dialog_Show(playerid, Login, DIALOG_STYLE_PASSWORD, "Nhap mat khau", mes, "Dang nhap", "Huy bo");
		SendWarningMessage(playerid, "Ban da nhap sai mat khau.");
		return 1;
	}

    pTemp[playerid][pLoggedTime] = 0;
	pTemp[playerid][pLoggedScreen] = 1;
	new query[128];

	mysql_format(dbHandle, query, sizeof(query), "UPDATE `accounts` SET `last_game_ip` = '%e', `last_game_login` = '%e' WHERE `id` = %i", q_GetPlayerIP(playerid), GetFullDate(), PlayerInfo[playerid][pAccID]);
	mysql_tquery(dbHandle, query);

	if(!pTemp[playerid][pNotAndroid])
	{
	//	ShowCharacterMenuAndroid(playerid);
		//
		Login_Hide(playerid);
		ShowCharacterMenu(playerid);
		return 1;
	}
	else
	{
		Login_Hide(playerid);
		ShowCharacterMenu(playerid);
	}
	return 1;
}

this::SearchCharactersAndroid(playerid)
{
	new list;
	for(new i = 0; i != MAX_CHARACTERS; i++)
	{
		login_char_id[playerid][i] = 0;
		format(login_char_name[playerid][i], MAX_PLAYER_NAME, "EMPTY");
	}
	list = 3;

	new status[MAX_CHARACTERS], status_names[][] = {"{DABB3E}Dang xu ly", "{33AA33}CHAP THUAN", "{FF6347}TU CHOI", "{FF6347}CAM"}, mes[43 + ((MAX_PLAYER_NAME + 64) * 3)];

	format(mes, sizeof(mes), "Slot\tTen\tLan cuoi dang nhap\tTrang thai");

	for(new i = 0; i < list; i++)
	{	   
		if(cache_get_field_content_int(i, "accountid") == 0) 
		{
			format(mes, sizeof(mes), "%s\n%i\t{C7C7C7}%s", mes, i+1, login_char_name[playerid][i]);
			continue;
		}

	    if (cache_get_field_content_int(i, "accountid") != PlayerInfo[playerid][pAccID])
		{
			SendErrorMessage(playerid, "Loi tai khoan. Vui long dang nhap lai!");
			KickEx(playerid);
			return 1;
		}

		status[i] = cache_get_field_content_int(i, "status");
	    login_char_id[playerid][i] = cache_get_field_content_int(i, "id");
	    cache_get_field_content(i, "name", login_char_name[playerid][i], dbHandle, MAX_PLAYER_NAME+1);
	    strreplace(login_char_name[playerid][i], '_', ' ');
		
		new date[24];
		format(date, sizeof(date), "%s", to_date(cache_get_field_content_int(i, "last_login"), 1));
		
		if (login_char_id[playerid][i])	format(mes, sizeof(mes), "%s\n%i\t%s\t%s\t%s", mes, i+1, login_char_name[playerid][i], date, status_names[status[i]]);
		else							format(mes, sizeof(mes), "%s\n%i\t%s", mes, i+1, login_char_name[playerid][i]);
	}

	Dialog_Show(playerid, SelectChar, DIALOG_STYLE_TABLIST_HEADERS, "Chon mot nhan vat:", mes, "Lua chon", "Huy bo");
	return 1;
}


this::SearchCharacters(playerid)
{
	if(cache_get_row_count())
	{
		LoadCharacterSelect(playerid);
		new string[2048];
		for(new x = 0; x < 3; x++)
		{
			pTemp[playerid][pCharacterScreen] = 1;
			pTemp[playerid][pRegisterScreen] = 1;
			CharSelectSQL[playerid][x] = cache_get_field_content_int(x, "id");
			CharSelectSkin[playerid][x] = cache_get_field_content_int(x, "skin");
			cache_get_field_content(x, "name", login_char_name[playerid][x], dbHandle, MAX_PLAYER_NAME+1);

			if(CharSelectSQL[playerid][x] != 0)
			{
				// For Menu
				for (new j; j < 9; j++)
				{
					PlayerTextDrawShow(playerid, CharacterMenu[playerid][j]);
				}

				PlayerTextDrawSetPreviewModel(playerid, CharacterPreview[playerid][x][0], CharSelectSkin[playerid][x]);

				format(string, sizeof(string), "%s", login_char_name[playerid][x]);
				PlayerTextDrawSetString(playerid, CharacterUsername[playerid][x][0], string);

				PlayerTextDrawShow(playerid, CharacterPreview[playerid][x][0]);
				PlayerTextDrawShow(playerid, CharacterUsername[playerid][x][0]);

				for (new j; j < 3; j++)
				{
					PlayerTextDrawDestroy(playerid, CharacterCreate[playerid][x][0]);
					PlayerTextDrawShow(playerid, CharacterCreate[playerid][j][0]);
				}
			}
		}
		SelectTextDraw(playerid, COLOR_GREY);
	}
	else
	{
		LoadCharacterSelect(playerid);
		pTemp[playerid][pCharacterScreen] = 1;
		pTemp[playerid][pRegisterScreen] = 1;
		for (new j; j < 9; j++)
		{
			PlayerTextDrawShow(playerid, CharacterMenu[playerid][j]);
		}
		for (new j; j < 3; j++)
		{
			PlayerTextDrawShow(playerid, CharacterCreate[playerid][j][0]);
		}
		SelectTextDraw(playerid, COLOR_GREY);
	}
	return 1;
}

this::OnPlayerAttemptLogin(playerid, last_ip[])
{
	if (cache_num_rows() != 0) 
	{
		new reason[64], ip[24], date[24], name[24], admin[MAX_PLAYER_NAME];
		
		cache_get_field_content(0, "reason", reason);
		cache_get_field_content(0, "date", date);
		cache_get_field_content(0, "ip", ip);
		cache_get_field_content(0, "admin", admin);
		cache_get_field_content(0, "name", name);
		
		new time = cache_get_field_content_int(0, "time");

		if (gettime() > time) 
		{
			new mes[512];
			format(mes, sizeof(mes), "{FFFFFF}Tai khoan cua ban da bi quan tri vien khoa {B5B5B5}%s.\n{FFFFFF}Khoa vao: {B5B5B5}%s\n{FFFFFF}Ly do: {B5B5B5}%s\n\nBan co the len dien dan de tranh luan ve lenh cam.\n\
			De thoat, nhan F6 va nhap /q", admin, date, reason);
			Dialog_Show(playerid, None, DIALOG_STYLE_MSGBOX, "Blocking", mes, "/q", "");
			KickEx(playerid);
			return 1;
		} 
		else 
		{
			new query[128];
			mysql_format(dbHandle, query, sizeof(query), "DELETE FROM `bans` WHERE `name` = '%e'", name);
			mysql_tquery(dbHandle, query);
		}
	}

	new ip[24];

	GetPlayerIp(playerid, ip, sizeof(ip));

	pTemp[playerid][pLogged] = 1;
	ClearChatbox(playerid, 50);
	
	if(!pTemp[playerid][pNotAndroid])
	{
/*		static const str_size[] = "{c7c3c3}SERVER:\t{FFFFFF}Ban co 5 phut de nhap\n\
								{c7c3c3}HINT:\t\t{FFFFFF}Ban co the lay lai mat khau\n\
								\t\to website: {c7c3c3}"WeburlName"\n\
								\t\t{FFFFFF}va dang nhap vao quan li tai khoan\n\n\
								Nhap mat khau cua ban:";

		new mes[sizeof(str_size)];

		format(mes, sizeof(mes), str_size);
		Dialog_Show(playerid, Login, DIALOG_STYLE_PASSWORD, "Chao mung toi "ProjectName"", mes, "Login", "Huy bo");*/
		Login_Show(playerid);
	}
	else
	{
		Login_Show(playerid);
	}
	return 1;
}

ShowCharacterMenu(playerid)
{
    new query[128];
	mysql_format(dbHandle, query, sizeof(query), "SELECT * FROM `users` WHERE `accountid` = %i", PlayerInfo[playerid][pAccID]);
	mysql_tquery(dbHandle, query, "SearchCharacters", "i", playerid);
	return 1;
}

ShowCharacterMenuAndroid(playerid)
{
    new query[128];
	mysql_format(dbHandle, query, sizeof(query), "SELECT * FROM `users` WHERE `accountid` = %i", PlayerInfo[playerid][pAccID]);
	mysql_tquery(dbHandle, query, "SearchCharactersAndroid", "i", playerid);
	return 1;
}

SetPlayerSpawn(playerid)
{
	if (IsPlayerNPC(playerid)) return 1;

	if (pTemp[playerid][pSpecPlayer] != INVALID_PLAYER_ID)
	{
	    pTemp[playerid][pSpecPlayer] = INVALID_PLAYER_ID;
		SetInterior(playerid,PlayerInfo[playerid][pInt]);
		SetWorld(playerid, PlayerInfo[playerid][pWorld]);
		SetPlayerPos(playerid,PlayerInfo[playerid][pPosX],PlayerInfo[playerid][pPosY],PlayerInfo[playerid][pPosZ]);
		PlayerTextDrawHide(playerid, spectate_TD[playerid][0]);
		PlayerTextDrawHide(playerid, spectate_TD[playerid][1]);
		return 1;
	}
	else if(PlayerInfo[playerid][pInjured])
	{
		SetInterior(playerid,0);
		SetWorld(playerid, 0);
		SendPlayerToHospital(playerid);
		return 1;
	}
    else if (pTemp[playerid][pCCTV])
	{
	    pTemp[playerid][pCCTV] = 0;
        DeletePVar(playerid, "CCTV:ID");

		SetInterior(playerid,PlayerInfo[playerid][pInt]);
		SetWorld(playerid, PlayerInfo[playerid][pWorld]);
		SetPlayerPos(playerid,PlayerInfo[playerid][pPosX],PlayerInfo[playerid][pPosY],PlayerInfo[playerid][pPosZ]);
	    return 1;
	}

	else if (pTemp[playerid][pInteriorBiz])
	{
	    new bizid = pTemp[playerid][pInteriorBiz]-1;

		SetPlayerPos(playerid,BizInfo[bizid][bizExitX], BizInfo[bizid][bizExitY], BizInfo[bizid][bizExitZ]);
		SetInterior(playerid,BizInfo[bizid][bizExitInt]);
		SetWorld(playerid,BizInfo[bizid][bizExitVW]);

        pTemp[playerid][pInteriorBiz] = 0;
        pTemp[playerid][pInteriorID] = 0;
        pTemp[playerid][pInteriorHouse] = 0;
	    return 1;
	}
	
	else if (pTemp[playerid][pZond])
	{
	    pTemp[playerid][pZond] = 0;
		SetInterior(playerid,PlayerInfo[playerid][pInt]);
		SetWorld(playerid, PlayerInfo[playerid][pWorld]);
		SetPlayerPos(playerid,PlayerInfo[playerid][pPosX],PlayerInfo[playerid][pPosY],PlayerInfo[playerid][pPosZ]);
	    return 1;
	}

	// ���� � ����

	if (PlayerInfo[playerid][pAJailed] != 0)
	{
		SetInterior(playerid, 18);
		SetWorld(playerid, playerid + 100);
		SetPlayerPos(playerid, -219.4580,1410.6747,27.7734);
		SendSyntaxMessage(playerid, "Ban duoc dua tro lai nha tu quan tri. Thoi han: %i phut.", PlayerInfo[playerid][pAJailTime]/60);
		return 1;
	}
	else if (PlayerInfo[playerid][pJailed]) return PutPlayerInPrison(playerid);

	//SPAWN TYPES
	if (PlayerInfo[playerid][pInjured] || GetPVarInt(playerid, #last_login) || PlayerInfo[playerid][pSpawnType] == 3)
	{
	    SetPlayerPos(playerid, PlayerInfo[playerid][pPosX], PlayerInfo[playerid][pPosY], PlayerInfo[playerid][pPosZ]);
		SetPlayerFacingAngle(playerid, PlayerInfo[playerid][pPosA]);
		SetInterior(playerid, PlayerInfo[playerid][pInt]);
		SetWorld(playerid, PlayerInfo[playerid][pWorld]);
		
		DeletePVar(playerid, #last_login);
		return 1;
	}

	else if (PlayerInfo[playerid][pSpawnType] == 1)
	{
	    new houseid = GetHouseIDByMysql(PlayerInfo[playerid][pSpawnPoint]);
	    if (houseid == -1 || (HouseInfo[houseid][hOwnerID] != PlayerInfo[playerid][pID] && PlayerInfo[playerid][pRentKey] != PlayerInfo[playerid][pSpawnPoint]))
		{
			SendSyntaxMessage(playerid, "Ban khong con nha, hoac ban khong thue no. ");
			PlayerInfo[playerid][pSpawnType] = 0;
			PlayerInfo[playerid][pSpawnPoint] = 1;
			SendHelpMessage(playerid, "Vi tri spawn cua ban da duoc tu dong doi lai thanh Montgomery. (/settings)");
		}
		else
		{
			SetPlayerPos(playerid, HouseInfo[houseid][hExitX], HouseInfo[houseid][hExitY],HouseInfo[houseid][hExitZ]);
			SetInterior(playerid,HouseInfo[houseid][hExitInt]);
			SetWorld(playerid,HouseInfo[houseid][hExitVW]);
			pTemp[playerid][pHouseEntered] = houseid;
			return 1;
		}
	}

	else if (PlayerInfo[playerid][pSpawnType] == 2)
	{
		if (PlayerInfo[playerid][pFaction] == 0)
		{
			SendSyntaxMessage(playerid, "Ban khong con tham gia fac nua.");
			PlayerInfo[playerid][pSpawnType] = 0;
			PlayerInfo[playerid][pSpawnPoint] = 1;
			SendHelpMessage(playerid, "Vi tri spawn cua ban da duoc tu dong thay doi tro lai Montgomery. (/settings)");
		}
		else
		{
			SetPlayerPos(playerid,Factions[PlayerInfo[playerid][pFaction]][fPosX],Factions[PlayerInfo[playerid][pFaction]][fPosY],Factions[PlayerInfo[playerid][pFaction]][fPosZ]);
			SetInterior(playerid, Factions[PlayerInfo[playerid][pFaction]][fSpawnInt]);
			SetWorld(playerid, Factions[PlayerInfo[playerid][pFaction]][fSpawnVW]);
			return 1;
		}
	}

	/*else if (PlayerInfo[playerid][pSpawnType] == 0)
	{		        
	   	SetPlayerPos(playerid, first_spawn[PlayerInfo[playerid][pSpawnPoint]-1][0], first_spawn[PlayerInfo[playerid][pSpawnPoint]-1][1], first_spawn[PlayerInfo[playerid][pSpawnPoint]-1][2]);
	    SetPlayerFacingAngle(playerid, first_spawn[PlayerInfo[playerid][pSpawnPoint]-1][3]);
		SetInterior(playerid,0);
		SetWorld(playerid, 0);
		return 1;
	}*/

	return 1;
}

stock RPnamecheck(pname[])
{
	if(strfind(pname,"[",true) != (-1)) return 0;
    else if(strfind(pname,"]",true) != (-1)) return 0;
    else if(strfind(pname,"$",true) != (-1)) return 0;
    else if(strfind(pname,"(",true) != (-1)) return 0;
    else if(strfind(pname,")",true) != (-1)) return 0;
    else if(strfind(pname,"=",true) != (-1)) return 0;
    else if(strfind(pname,"@",true) != (-1)) return 0;
    else if(strfind(pname,"1",true) != (-1)) return 0;
    else if(strfind(pname,"2",true) != (-1)) return 0;
    else if(strfind(pname,"3",true) != (-1)) return 0;
    else if(strfind(pname,"4",true) != (-1)) return 0;
    else if(strfind(pname,"5",true) != (-1)) return 0;
    else if(strfind(pname,"6",true) != (-1)) return 0;
    else if(strfind(pname,"7",true) != (-1)) return 0;
    else if(strfind(pname,"8",true) != (-1)) return 0;
    else if(strfind(pname,"9",true) != (-1)) return 0;
    else if(strfind(pname,"fuck",true) != (-1)) return 0;
    else if(strfind(pname,"FUCK",true) != (-1)) return 0;
    else if(strfind(pname,"Boobies",true) != (-1)) return 0;
    else if(strfind(pname,"Tupac_Shakur",true) != (-1)) return 0;
    else if(strfind(pname,"Pussy",true) != (-1)) return 0;
    else if(strfind(pname,"Rape",true) != (-1)) return 0;
    else if(strfind(pname,"kill",true) != (-1)) return 0;
    else if(strfind(pname,"shit",true) != (-1)) return 0;
    else if(strfind(pname,"ass",true) != (-1)) return 0;
    else if(strfind(pname,"Jack_Black",true) != (-1)) return 0;
    else if(strfind(pname,"Max_Kenton",true) != (-1)) return 0;
    else if(strfind(pname,"Will_Smith",true) != (-1)) return 0;
    else if(strfind(pname,"Jaden_Smith",true) != (-1)) return 0;
    else if(strfind(pname,"Megan_Fox",true) != (-1)) return 0;
    else if(strfind(pname,"Charlie_Kenton",true) != (-1)) return 0;
    else if(strfind(pname,"Hugh_Hefner",true) != (-1)) return 0;
    else if(strfind(pname,"Paris_Hilton",true) != (-1)) return 0;
    else if(strfind(pname,"Marshall_Mathers",true) != (-1)) return 0;
    else if(strfind(pname,"Sheldon_Cooper",true) != (-1)) return 0;
    else if(strfind(pname,"Jet_Lee",true) != (-1)) return 0;
    else if(strfind(pname,"Jackie_Chan",true) != (-1)) return 0;
    else if(strfind(pname,"Chuck_Norris",true) != (-1)) return 0;
    else if(strfind(pname,"Peter_Parker",true) != (-1)) return 0;
    else if(strfind(pname,"Spider_Man",true) != (-1)) return 0;
    else if(strfind(pname,"Bat_Man",true) != (-1)) return 0;
    else if(strfind(pname,"Emma_Stone",true) != (-1)) return 0;
    else if(strfind(pname,"whore",true) != (-1)) return 0;
    else if(strfind(pname,"Hugh_Jackman",true) != (-1)) return 0;
    else if(strfind(pname,"Charles_Kenton",true) != (-1)) return 0;
    else if(strfind(pname,"Harry_Potter",true) != (-1)) return 0;
    else if(strfind(pname,"Chris_Hemsworth",true) != (-1)) return 0;
    else if(strfind(pname,"Penis",true) != (-1)) return 0;
    else if(strfind(pname,"_Dick",true) != (-1)) return 0;
    else if(strfind(pname,"Vagina",true) != (-1)) return 0;
    else if(strfind(pname,"Cock",true) != (-1)) return 0;
    else if(strfind(pname,"Rectum",true) != (-1)) return 0;
    else if(strfind(pname,"Sperm",true) != (-1)) return 0;
    else if(strfind(pname,"Rektum",true) != (-1)) return 0;
    else if(strfind(pname,"Pistol",true) != (-1)) return 0;
    else if(strfind(pname,"AK47",true) != (-1)) return 0;
    else if(strfind(pname,"Shotgun",true) != (-1)) return 0;
    else if(strfind(pname,"Cum",true) != (-1)) return 0;
    else if(strfind(pname,"Hitler",true) != (-1)) return 0;
    else if(strfind(pname,"Jesus",true) != (-1)) return 0;
    else if(strfind(pname,"God",true) != (-1)) return 0;
    else if(strfind(pname,"Shotgun",true) != (-1)) return 0;
    else if(strfind(pname,"Desert_Eagle",true) != (-1)) return 0;
    else if(strfind(pname,"fucker",true) != (-1)) return 0;
    else if(strfind(pname,"Retard",true) != (-1)) return 0;
    else if(strfind(pname,"Tarded",true) != (-1)) return 0;
    else if(strfind(pname,"fanny",true) != (-1)) return 0;
    else if(strfind(pname,"Daniel_Hardy",true) != (-1)) return 0;
    else if(strfind(pname,"abcdefghijklmnopqrstuvwxyz",true) != (-1)) return 0;
   
    return 1;
}

IsNumeric(szInput[]) 
{

	new
		iChar,
		i = 0;

	while ((iChar = szInput[i++])) if (!('0' <= iChar <= '9')) return 0;
	return 1;
}

this::PlayerTutorial(playerid)
{
	if(PlayerInfo[playerid][pTutorial] == 2)
	{
		PlayerInfo[playerid][pTutorial] = 3;

		TogglePlayerControllable(playerid, 0);
		SetPlayerPosEx(playerid, 1341.1246, -66.1431, 46.3822);
		SetPlayerCameraPos(playerid, 1341.1246, -66.1431, 46.3822);
		SetPlayerCameraLookAt(playerid, 1341.4387, -65.1941, 46.2623);
		ClearChatbox(playerid, 26);
		SendClientMessage(playerid, COLOR_WHITE, "Houses");
		SendClientMessage(playerid, COLOR_WHITE, "New County Roleplay co he thong nha kha doc dao. May chu cung cap hon 800 ngoi nha trai dai khap Red, Bone va Flint County.\n");
		SendClientMessage(playerid, COLOR_WHITE, "Ban co the co duoc mot ngoi nha do minh so huu thong qua mot so phuong tien don gian va chung nhu sau.\nBan co the nhan nha tu nguoi choi hoac tao quang cao tai bat ky toa nha/thi tran SAN nao.\n");
		SendClientMessage(playerid, COLOR_WHITE, "Ban cung co the mua nha bang cach su dung /buyhouse ngay truoc cua nha, gia su no khong thuoc so huu cua bat ky ai.\n");
		SendClientMessage(playerid, COLOR_WHITE, "Cuoi cung, co mot phe ung ho tren may chu ten la Silver Trading chuyen ban nha va co so kinh doanh tu van phong cua ho o Montgomery.\n");
		SendClientMessage(playerid, COLOR_WHITE, "Ban co the mua do noi that cho ngoi nha cua minh tu bat ky cua hang do noi that nao xung quanh quan.\nBan co the dat do noi that noi tren o bat cu dau trong nha va ban ");
		SendClientMessage(playerid, COLOR_WHITE, "cung co the ap dung cac ket cau khac nhau cho do noi that ban co the mua, lam cho moi ngoi nha tro nen doc dao!\n");
		SendClientMessage(playerid, COLOR_WHITE, "Co nhieu tinh nang khac ma cac ngoi nha tren may chu cung cap cho chu so huu cua chung, ban co the su dung '/help house' de biet lenh them ve nha.");
		SetTimerEx("PlayerTutorial", 10000, 0, "d", playerid);
		return 1;
	}
	if(PlayerInfo[playerid][pTutorial] == 3)
	{
		PlayerInfo[playerid][pTutorial] = 4;

		TogglePlayerControllable(playerid, 0);
		SetPlayerPosEx(playerid, 41.1034, -203.0147, 4.8207);
		SetPlayerCameraPos(playerid, 41.1034, -203.0147, 4.8207);
		SetPlayerCameraLookAt(playerid, 41.9080, -202.4217, 4.7758);
		ClearChatbox(playerid, 26);
		SendClientMessage(playerid, COLOR_WHITE, "Vehicles");
		SendClientMessage(playerid, COLOR_WHITE, "Ban co the mua xe thong qua cac dai ly hien dang trai dai quanh Red County.\nCac xe hoan toan moi thuong la");
		SendClientMessage(playerid, COLOR_WHITE, "dat hon nhung chiec xe da qua su dung ma ban co the trao doi giua nhung nguoi choi hoac ban co the thu van may cua minh voi mot cuoc dau gia tren dien dan.\n");
		SendClientMessage(playerid, COLOR_WHITE, "Sau khi ban lay duoc xe, dieu dang noi la no co the bi danh cap bat cu luc nao.\nNeu ban muon ngan xe bi mat cap, ");
		SendClientMessage(playerid, COLOR_WHITE, "ban phai luon khoa cop xe khi khong su dung.\nBan cung can khoa cop xe cua minh, neu khong ai do rat co the se cuop do trong do.\n");
		SendClientMessage(playerid, COLOR_WHITE, "Ban co the dat chiec xe cua minh xuat hien o bat cu dau ban muon su dung /savecar, tuy nhien vi tri do cua no phai nam trong luat cua tieu bang, neu khong no se bi keo di.\n\n");
		SendClientMessage(playerid, COLOR_WHITE, "Thong tin them ve cac phuong tien co the duoc tim thay bang cach su dung: '/help vehicle'");
		SetTimerEx("PlayerTutorial", 10000, 0, "d", playerid);
		return 1;
	}
	if(PlayerInfo[playerid][pTutorial] == 4)
	{
		PlayerInfo[playerid][pTutorial] = 5;

		TogglePlayerControllable(playerid, 0);
		SetPlayerPosEx(playerid, 1349.2195, 279.4322, 27.4613);
		SetPlayerCameraPos(playerid, 1349.2195, 279.4322, 27.4613);
		SetPlayerCameraLookAt(playerid, 1349.7913, 278.6134, 27.3714);
		ClearChatbox(playerid, 26);
		SendClientMessage(playerid, COLOR_WHITE, "Businesses");
		SendClientMessage(playerid, COLOR_WHITE, "Co hon 300 doanh nghiep tren may chu va giong nhu nhung ngoi nha ma ho trai dai tren toan bo khu vuc dong vai.\n");
		SendClientMessage(playerid, COLOR_WHITE, "Cac doanh nghiep co chuc nang tao moi truong nhap vai tuy thuoc vao loai hinh cua no.\nVi du do la cau lac bo, quan ca phe hay cua hang tong hop ");
		SendClientMessage(playerid, COLOR_WHITE, "Tat ca chung deu la nhung lua chon kha thi neu ban muon tao ra mot so man nhap vai.\nChung cung cap cho chu so huu phan thuong trong phieu luong cua ho moi ngay.\n");
		SendClientMessage(playerid, COLOR_WHITE, "Cac khoan thanh toan cho doanh nghiep nay co the dao dong tu $500 den $5.000. Ban cung co the thu nhap tu doanh nghiep cua minh thong qua phi vao cua nho cung nhu\n");
		SendClientMessage(playerid, COLOR_WHITE, "moi nguoi mua cac mat hang tu doanh nghiep cua ban, gia su do la mot doanh nghiep ma moi nguoi co the mua cac mat hang tu.\n\n");
		SendClientMessage(playerid, COLOR_WHITE, "Thong tin them cho cac doanh nghiep co the duoc tim thay bang cach su dung: '/help bizz'");
		SetTimerEx("PlayerTutorial", 10000, 0, "d", playerid);
		return 1;
	}
	if(PlayerInfo[playerid][pTutorial] == 5)
	{
		PlayerInfo[playerid][pTutorial] = 6;

		TogglePlayerControllable(playerid, 0);
		SetPlayerPosEx(playerid, 584.3343, 807.1425, -22.4779);
		SetPlayerCameraPos(playerid, 584.3343, 807.1425, -22.4779);
		SetPlayerCameraLookAt(playerid, 584.7542, 808.0494, -22.6329);
		ClearChatbox(playerid, 26);
		SendClientMessage(playerid, COLOR_WHITE, "Jobs");
		SendClientMessage(playerid, COLOR_WHITE, "La mot nguoi choi moi, nguon thu nhap chinh cua ban rat co the se la phu. Co 6 sidejobs tren may chu va chung nhu sau\n\n");
		SendClientMessage(playerid, COLOR_WHITE, "Quet duong pho, giao banh Pizza, lai xe tai, tho khai thac than, thu gom rac va tai xe xe buyt.\nTat ca nhung cong viec phu nay deu co cac cap do khac nhau, va tuy ban ");
		SendClientMessage(playerid, COLOR_WHITE, "thang cap trong cong viec cua ban, luong cua ban se tang len.\nCung co hai cong viec tinh de ban co duoc khi ban dat den cap do hai. ");
		SendClientMessage(playerid, COLOR_WHITE, "Mot nguoi la tho sua xe va nguoi kia la nhan vien bao tri.\nBan co the tim them thong tin cu the tai bat ky toa thi chinh nao bang cach su dung /jobinfo.");
		SetTimerEx("PlayerTutorial", 10000, 0, "d", playerid);
		return 1;
	}
	if(PlayerInfo[playerid][pTutorial] == 6)
	{
		PlayerInfo[playerid][pTutorial] = 7;

		TogglePlayerControllable(playerid, 0);
		SetPlayerPosEx(playerid, 119.7930, -91.6921, 3.6932);
		SetPlayerCameraPos(playerid, 119.7930, -91.6921, 3.6932);
		SetPlayerCameraLookAt(playerid, 118.8413, -91.9966, 3.7532);
		ClearChatbox(playerid, 26);
		SendClientMessage(playerid, COLOR_WHITE, "Factions");
		SendClientMessage(playerid, COLOR_WHITE, "Tiep tuc, co mot so FAC de ban lua chon New County Roleplay.\nLuon luon co mot so phe phai den va di, vi vay ");
		SendClientMessage(playerid, COLOR_WHITE, "chung toi se khong tham gia vao cac phe phai cu the.\nNhu du kien tren bat ky may chu nhap vai nao, co hai phe phai thiet yeu se luon co vi tri vinh vien.\nThe San Andreas State Police ");
		SendClientMessage(playerid, COLOR_WHITE, "thuc thi luat tren may chu, trong khi San Andreas County Fire Department co san cho tat ca cac van de lien quan den y te va hoa hoan.\nCo rat nhieu dieu bat hop phap ");
		SendClientMessage(playerid, COLOR_WHITE, "cac fac, ca chinh thuc va khong chinh thuc co san de cung cap vai tro cho bat ky ai thich nhap vai toi pham.\n");
		SendClientMessage(playerid, COLOR_WHITE, "Ban co the tim hieu them thong tin ve tat ca cac fac cua may chu tren dien dan cua chung toi.");
		SetTimerEx("PlayerTutorial", 10000, 0, "d", playerid);
		return 1;
	}
	if(PlayerInfo[playerid][pTutorial] == 7)
	{
		PlayerInfo[playerid][pTutorial] = 8;

		TogglePlayerControllable(playerid, 0);
		SetPlayerPosEx(playerid, 2257.0034, -92.2860, 29.2412);
		SetPlayerCameraPos(playerid, 2257.0034, -92.2860, 29.2412);
		SetPlayerCameraLookAt(playerid, 2256.5486, -93.1779, 29.2912);
		ClearChatbox(playerid, 26);
		SendClientMessage(playerid, COLOR_WHITE, "Communication");
		SendClientMessage(playerid, COLOR_WHITE, "Chung toi sap hoan thanh o day! Hau het cac lenh de giao tiep tren may chu nay la cac lenh tieu chuan ban se tim thay tren bat ky may chu dong vai nao.\n");
		SendClientMessage(playerid, COLOR_WHITE, "Doi voi giao tiep OOC, ban co the su dung /pm de gui tin nhan ca nhan giua ban va nguoi choi khac. /b duoc su dung cho cuoc tro chuyen OOC cuc bo.\nNeu ban duoc thue vao mot nhom, ban co the su dung /f de giao tiep voi cac thanh vien cua cung mot nhom.\n");
		SendClientMessage(playerid, COLOR_WHITE, "Doi voi giao tiep vi mach, ban co the su dung /l de noi nho, /w de thi tham voi nguoi choi va /s de het len o dau phoi cua ban. De noi mot cach binh thuong IC, tat ca nhung gi ban can lam la nhap vao cuoc tro chuyen!");
		SetTimerEx("PlayerTutorial", 10000, 0, "d", playerid);
		return 1;
	}
	if(PlayerInfo[playerid][pTutorial] == 8)
	{
		PlayerInfo[playerid][pTutorial] = 9;

		TogglePlayerControllable(playerid, 0);
		SetPlayerPosEx(playerid, 744.4871, -559.2281, 10.4614);
		SetPlayerCameraPos(playerid, 744.4871, -559.2281, 10.4614);
		SetPlayerCameraLookAt(playerid, 744.4445, -558.2307, 10.4116);
		ClearChatbox(playerid, 26);
		SendClientMessage(playerid, COLOR_WHITE, "Conclusion");
		SendClientMessage(playerid, COLOR_WHITE, "Cam on ban da ngoi xem qua huong dan cua chung toi. Chung toi hy vong thong tin cung cap da giai dap duoc phan nao thac mac cua ban, con neu khong thi ban hon Chao mung toi tao su ho tro nho nhan vien phuc vu giup do.\n");
		SendClientMessage(playerid, COLOR_WHITE, "Hay chac chan kiem tra lenh /help truoc! Hau het cac lenh cua may chu duoc liet ke o do.\n");
		SendClientMessage(playerid, COLOR_WHITE, "Neu ban phat hien bat ky nguoi choi nao vi pham cac quy tac, hay nho /report ho de nhan vien co the xu ly nguoi choi phu hop.\n");
		SendClientMessage(playerid, COLOR_WHITE, "Chao mung toi Los Santos Roleplay, we hope you enjoy your stay!");
		SetTimerEx("PlayerTutorial", 5000, 0, "d", playerid);
		return 1;
	}
	if(PlayerInfo[playerid][pTutorial] == 9)
	{
		StopAudioStreamForPlayer(playerid);
		ClearChatbox(playerid, 50);
		SendServerMessage(playerid, "Chao mung toi may chu, {ffc46a}%s!", GetNameEx(playerid));
		SendServerMessage(playerid, "Dung quen ve cac lenh: {ffc46a}/helpme, /help, /mm");
		if(PlayerInfo[playerid][pHours] < 8)
		{
			SendHelpMessage(playerid, "Khi ban dat den cap do 1, ban se nhan duoc $%i truc tiep vao tai khoan ngan hang cua ban.", SERVER_BONUS);
		}
		SetWorld(playerid, 0);
		SetSpawnInfoEx(playerid, 1641.7317,-2334.3979,-2.6797);
		pTemp[playerid][pLogged] = 2;
		
		/*PlayerInfo[playerid][pSpawnType] = 3;
		SQL_SetInteger("users", "spawntype", PlayerInfo[playerid][pSpawnType], PlayerInfo[playerid][pID]);*/
		SQL_SetInteger("users", "tutorial", PlayerInfo[playerid][pTutorial], PlayerInfo[playerid][pID]);
		//SQL_SetInteger("users", "spawnpoint", PlayerInfo[playerid][pSpawnPoint], PlayerInfo[playerid][pID]);
		for(new i = 0; i<52; i++) EnableAntiCheatForPlayer(playerid, i, 1);
		SpawnPlayer(playerid);
		SetSpawnInfoEx(playerid, 1641.7317,-2334.3979,-2.6797);
		return 1;
	}
	return 1;
}
