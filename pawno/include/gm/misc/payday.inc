PayDay(i)
{
	if (!IsPlayerLogged(i)) return 1;

	new oldbank = PlayerInfo[i][pBank], savings, checks, tax_house, rent_house, debt;
	if(PlayerInfo[i][pLevel] >= 4)
	{
		checks = 1250;
	}
	else if(PlayerInfo[i][pLevel] < 4)
	{
		checks = 3000;
	}
	if (IsPlayerFactionPolice(i) || IsPlayerFactionDocs(i) || IsPlayerFactionNews(i)) checks += (PlayerInfo[i][pRank] * 30);  
	if (IsPlayerFactionMedic(i) || IsPlayerFactionFire(i) || IsPlayerFactionMedic(i)) checks += (PlayerInfo[i][pRank] * 35);
	if (IsPlayerFactionMech(i)) checks += (PlayerInfo[i][pRank] * 35);
	
	if (PlayerInfo[i][pJob] == JOB_TAXI) 	checks += 50;
	
	if (PlayerInfo[i][pSavings] > 35000 && PlayerInfo[i][pSavings] < 100000) savings = (PlayerInfo[i][pSavings]) / 100;
    PlayerInfo[i][pBank] += savings;

	if (PlayerInfo[i][pBank] < 0)
	{
	    debt = floatround(float(checks) * 0.8);
	    PlayerInfo[i][pBank] += debt,
		checks -= debt;
	}

	new houses_tax[3] = {20, 50, 100};

	for(new h; h != MAX_HOUSES; h++)
	{
	    if (HouseInfo[h][hID] == 0 || HouseInfo[h][hOwnerID] != PlayerInfo[i][pID])	continue;
		
		tax_house += houses_tax[HouseInfo[h][hClass]];
	}

	new houseid = -1;
    if (PlayerInfo[i][pRentPrice] != 0 && PlayerInfo[i][pRentKey] != 0 && (houseid = GetHouseIDByMysql(PlayerInfo[i][pRentKey])) != -1)
	{
	    rent_house += PlayerInfo[i][pRentPrice];
		HouseInfo[houseid][hCash] += PlayerInfo[i][pRentPrice];
	}
	PlayerInfo[i][pBank] -= tax_house + rent_house;
	
	new msg[256];
    format(msg, sizeof(msg), "~r~Ngan Hang Nha Nuoc~w~~n~So du: $%i~n~Luong: $%i~n~", oldbank, checks);
	if (savings) 	format(msg, sizeof(msg), "%sTai khoan tiet kiem: $%i, Quan tam: 1~n~", msg, savings);
    if (rent_house)	format(msg, sizeof(msg), "%sTien nha thue: $%i~n~", msg, rent_house);
    if (tax_house)	format(msg, sizeof(msg), "%sThue thuc te: $%i~n~", msg, tax_house);
	format(msg, sizeof(msg), "%sSo du moi: $%i", msg, oldbank + checks);
	InfoMSG(i, msg, 8);
    //SendSMStoPlayer(i, "1313", "Red County Bank", msg, 0);
	////////////////////

	SendSyntaxMessage(i, "PayDay! PayDay! Luong da duoc chuyen vao tai khoan cua ban.");
	if (debt) SendSyntaxMessage(i, "Ban dang no mot tai khoan ngan hang. Ngan hang giu lai mot phan luong cua anh ta de tra no. ");

	PlayerInfo[i][pPayDayTime] = 0;
	//PlayerInfo[i][pPayCheckMoney] += checks;
	PlayerInfo[i][pBank] += checks;
	PlayerInfo[i][pHours]++;
	PlayerInfo[i][pCareer]++;

	if (PlayerInfo[i][pWepLic] && PlayerInfo[i][pWepCount] > 0) {
		PlayerInfo[i][pWepCount]--;
		if (!PlayerInfo[i][pWepCount]) SendHelpMessage(i, "Ban co the mua lai vu khi bang dan duoc! (/gps)");
	}
	
	//PlayerInfo[i][pExp]++;
	//new expamount = (PlayerInfo[i][pLevel]+1) * LEVEL_EXP;
	new expamount = (PlayerInfo[i][pLevel]+1) * 8;
	if(PlayerInfo[i][pHours] >= expamount)
	{
		if (PlayerInfo[i][pLevel] == 0)
		{
			PlayerInfo[i][pLevel]++;
			PlaySound(i, 1052);
			
			format(msg, sizeof(msg), "~y~LEVEL UP~n~~w~Ban dang o cap %i", PlayerInfo[i][pLevel]);
			GameTextForPlayer(i, msg, 5000, 1);
			
			SendServerMessage(i, "Ban khong con la 'Thanh vien moi' nua, tat ca cac chuc nang cua du an hien co san cho ban. ");
			SendServerMessage(i, "Ngoai ra, so du cua ban da nhan duoc $%i, ban co the nhan chung cung voi tien luong tai ngan hang.", SERVER_BONUS);

			PlayerInfo[i][pBank] += SERVER_BONUS;

			SetPlayerScore(i, PlayerInfo[i][pLevel]);
		}
		else
		{
			PlayerInfo[i][pLevel]++;
			PlaySound(i, 1052);
			
			format(msg, sizeof(msg), "~y~LEVEL UP~n~~w~Ban dang o cap %i", PlayerInfo[i][pLevel]);
			GameTextForPlayer(i, msg, 5000, 1);
			SetPlayerScore(i, PlayerInfo[i][pLevel]);
		}	
	}

	/*if (PlayerInfo[i][pHours] >= 8 && PlayerInfo[i][pLevel] == 0)
	{
	    PlayerInfo[i][pLevel]++;
		PlaySound(i, 1052);
		
		format(msg, sizeof(msg), "~y~LEVEL UP~n~~w~Ban dang o cap %i", PlayerInfo[i][pLevel]);
		GameTextForPlayer(i, msg, 5000, 1);
		
			SendServerMessage(i, "Ban khong con la 'Thanh vien moi' nua, tat ca cac chuc nang cua du an hien co san cho ban. ");
			SendServerMessage(i, "Ngoai ra, so du cua ban da nhan duoc $%i, ban co the nhan chung cung voi tien luong tai ngan hang.", SERVER_BONUS);

		PlayerInfo[i][pBank] += SERVER_BONUS;

		SetPlayerScore(i, PlayerInfo[i][pLevel]);
	}*/

	if (PlayerInfo[i][pForbid] > 0) 
	{
		PlayerInfo[i][pForbid]--;
		SQL_SetInteger("users", "Forbid", PlayerInfo[i][pForbid], PlayerInfo[i][pID]);

		if (PlayerInfo[i][pForbid] == 0)
			SendClientMessage(i, COLOR_ORANGE, "[ ! ] {FFFFFF}Lenh cam su dung vu khi da het, bay gio ban co the su dung tro lai.");

		Save_User(i);
	}
	return 1;
}