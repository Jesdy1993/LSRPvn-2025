
CMD:f(playerid, params[])
{
	if(gFam[playerid] == 1)
	{
		SendClientMessageEx(playerid, TEAM_CYAN_COLOR, "Ban dang vo hieu hoa tro chuyen Family. /togfamily!");
		return 1;
	}

	new string[128];
	if(isnull(params)) return SendUsageMessage(playerid, " (/f)amily [family chat]");

	if(IsAHitman(playerid))
	{
		format(string, sizeof(string), "** (%d) %s %s: %s **", PlayerInfo[playerid][pRank], arrGroupRanks[PlayerInfo[playerid][pMember]][PlayerInfo[playerid][pRank]], GetPlayerNameEx(playerid), params);
		SendFamilyMessage(PlayerInfo[playerid][pMember], TEAM_AZTECAS_COLOR, string);
	}
	else if(PlayerInfo[playerid][pFMember] < INVALID_FAMILY_ID)
	{
	    new fam = PlayerInfo[playerid][pFMember];
	    if(FamilyInfo[fam][FType] == 1) {
	    	if(0 <= PlayerInfo[playerid][pDivision] < 5)
	        {
	            new division[GROUP_MAX_DIV_LEN];
	            format(division, sizeof(division), "%s", FamilyDivisionInfo[PlayerInfo[playerid][pFMember]][PlayerInfo[playerid][pDivision]]);
		        format(string, sizeof(string), "** [%i] %s (%s) %s: %s **", PlayerInfo[playerid][pRank], FamilyRankInfo[fam][PlayerInfo[playerid][pRank]], division, GetPlayerNameEx(playerid), params);
		    	SendNewFamilyMessage(fam, 0xb49c33AA, string);
		    }
		    else
		    {
		        format(string, sizeof(string), "** [%i] Giam doc %s: %s **", PlayerInfo[playerid][pRank], GetPlayerNameEx(playerid), params);
		    	SendNewFamilyMessage(fam, 0xb49c33AA, string);
		    }
	    }
	    else {
	    	if(0 <= PlayerInfo[playerid][pDivision] < 5)
	        {
	            new division[GROUP_MAX_DIV_LEN];
	            format(division, sizeof(division), "%s", FamilyDivisionInfo[PlayerInfo[playerid][pFMember]][PlayerInfo[playerid][pDivision]]);
		        format(string, sizeof(string), "** (%i) %s (%s) %s: %s **", PlayerInfo[playerid][pRank], FamilyRankInfo[fam][PlayerInfo[playerid][pRank]], division, GetPlayerNameEx(playerid), params);
		    	SendNewFamilyMessage(fam, TEAM_AZTECAS_COLOR, string);
		    }
		    else
		    {
		        format(string, sizeof(string), "** (%i) %s %s: %s **", PlayerInfo[playerid][pRank], FamilyRankInfo[fam][PlayerInfo[playerid][pRank]], GetPlayerNameEx(playerid), params);
		    	SendNewFamilyMessage(fam, TEAM_AZTECAS_COLOR, string);
		    }
	    }
	  
	}
	else
	{
		SendErrorMessage(playerid,"Ban khong o trong Family!");
	}
	return 1;
}


CMD:trangphuc(playerid, params[]) {
	return cmd_fclothes(playerid, params);
}

CMD:fclothes(playerid, params[])
{
	new biz = InBusiness(playerid);
	if(PlayerInfo[playerid][pFMember] == INVALID_FAMILY_ID) return SendErrorMessage(playerid,"Ban khong o trong Family/Gang!");
	if (biz != INVALID_BUSINESS_ID && Businesses[biz][bType] == BUSINESS_TYPE_CLOTHING)
	{
		new fSkin[8];
		fSkin[0] = FamilyInfo[PlayerInfo[playerid][pFMember]][FamilySkins][0];
		fSkin[1] = FamilyInfo[PlayerInfo[playerid][pFMember]][FamilySkins][1];
		fSkin[2] = FamilyInfo[PlayerInfo[playerid][pFMember]][FamilySkins][2];
		fSkin[3] = FamilyInfo[PlayerInfo[playerid][pFMember]][FamilySkins][3];
		fSkin[4] = FamilyInfo[PlayerInfo[playerid][pFMember]][FamilySkins][4];
		fSkin[5] = FamilyInfo[PlayerInfo[playerid][pFMember]][FamilySkins][5];
		fSkin[6] = FamilyInfo[PlayerInfo[playerid][pFMember]][FamilySkins][6];
		fSkin[7] = FamilyInfo[PlayerInfo[playerid][pFMember]][FamilySkins][7];
		ShowModelSelectionMenuEx(playerid, fSkin, 8, "Thay trang phuc family cua ban.", DYNAMIC_FAMILY_CLOTHES, 0.0, 0.0, -55.0);
	}
	else {
		return SendErrorMessage(playerid,"Ban khong o mot cua hang quan ao.");
	}
	return 1;
}
CMD:families(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[playerid][pFMember] != INVALID_FAMILY_ID)
	{

		new
			string[128],
			familyid;

		if(sscanf(params, "d", familyid))
		{
			new number = 1;
			for(new i = 1; i < sizeof(FamilyInfo); i++)
			{
 	  			if(FamilyInfo[i][FamilyTurfTokens] < 12)
				{
					format(string, sizeof(string), "%s (%d) | Quan ly: %s | Thanh vien: %d | Claim Tokens: 0", FamilyInfo[i][FamilyName], number, FamilyInfo[i][FamilyLeader], FamilyInfo[i][FamilyMembers]);
				}
				else
				{
					format(string, sizeof(string), "%s (%d) | Quan ly: %s | Thanh vien: %d | Claim Tokens: %d", FamilyInfo[i][FamilyName], number, FamilyInfo[i][FamilyLeader], FamilyInfo[i][FamilyMembers], FamilyInfo[i][FamilyTurfTokens]/12);
				}
				number++;
				SendClientMessageEx(playerid, COLOR_WHITE, string);
			}
			return 1;
		}

		if(familyid < 1 || familyid > MAX_FAMILY)
		{
			format(string, sizeof(string), "Slot family phai o giua 1 va %i.", MAX_FAMILY);
			SendClientMessageEx(playerid, COLOR_GREY, string);
		 	return 1;
 	 	}
		if(FamilyInfo[familyid][FamilyTaken] != 1)
		{
			SendErrorMessage(playerid,"Slot family dang trong.");
			return 1;
		}

		foreach(new i: Player)
		{
		    new division[GROUP_MAX_DIV_LEN];
			if(PlayerInfo[i][pFMember] == familyid && (PlayerInfo[i][pTogReports] == 1 || PlayerInfo[i][pAdmin] < 2))
			{
			    if(0 <= PlayerInfo[i][pDivision] < 5)
				{
			        format(division, sizeof(division), "%s", FamilyDivisionInfo[PlayerInfo[i][pFMember]][PlayerInfo[i][pDivision]]);
			    } else {
       				division = "None";
			    }
   			 	if(PlayerInfo[i][pRank] == 0)
				{
					format(string, sizeof(string), "* %s: %s | Rank: %s (0) | Division: %s.",FamilyInfo[familyid][FamilyName],GetPlayerNameEx(i),FamilyRankInfo[familyid][0], division);
				}
				else if(PlayerInfo[i][pRank] == 1)
				{
					format(string, sizeof(string), "* %s: %s | Rank: %s (1) | Division: %s.",FamilyInfo[familyid][FamilyName],GetPlayerNameEx(i),FamilyRankInfo[familyid][1], division);
				}
				else if(PlayerInfo[i][pRank] == 2)
				{
					format(string, sizeof(string), "* %s: %s | Rank: %s (2) | Division: %s.",FamilyInfo[familyid][FamilyName],GetPlayerNameEx(i),FamilyRankInfo[familyid][2], division);
				}
				else if(PlayerInfo[i][pRank] == 3)
				{
					format(string, sizeof(string), "* %s: %s | Rank: %s (3) | Division: %s.",FamilyInfo[familyid][FamilyName],GetPlayerNameEx(i),FamilyRankInfo[familyid][3], division);
				}
				else if(PlayerInfo[i][pRank] == 4)
				{
					format(string, sizeof(string), "* %s: %s | Rank: %s (4) | Division: %s.",FamilyInfo[familyid][FamilyName],GetPlayerNameEx(i),FamilyRankInfo[familyid][4], division);
				}
				else if(PlayerInfo[i][pRank] == 5)
				{
					format(string, sizeof(string), "* %s: %s | Rank: %s (5) | Division: %s.",FamilyInfo[familyid][FamilyName],GetPlayerNameEx(i),FamilyRankInfo[familyid][5], division);
				}
				else if(PlayerInfo[i][pRank] == 6)
				{
					format(string, sizeof(string), "* %s: %s | Rank: %s (6) | Division: %s.",FamilyInfo[familyid][FamilyName],GetPlayerNameEx(i),FamilyRankInfo[familyid][6], division);
				}
				else
				{
					format(string, sizeof(string), "* %s: %s | Rank: %s | Division: %s.",FamilyInfo[familyid][FamilyName],GetPlayerNameEx(i),FamilyRankInfo[familyid][0], division);
				}
				if(PlayerInfo[playerid][pFMember] == familyid && PlayerInfo[playerid][pRank] >= 5 && playerAFK[i] != 0 && playerAFK[i] > 60)
				{
					format(string, sizeof(string), "%s (AFK: %d phut)", string, playerAFK[i] / 60);
				}
				SendClientMessageEx(playerid, COLOR_GREY, string);
			}
		}
	}
	else
	{
	    new string[128];
    	format(string, sizeof(string), "Chi cho phep thanh vien trong family va admin su dung lenh nay.");
    	SendClientMessageEx(playerid, COLOR_GREY, string);
	}
	return 1;
}

CMD:fbalance(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 15.0, 2308.7346, -11.0134, 26.7422))
	{
		SendErrorMessage(playerid,"Ban khong o ngan hang!");
		return 1;
	}

	new family, string[128];
	if(PlayerInfo[playerid][pFMember] < INVALID_FAMILY_ID)
	{
		family = PlayerInfo[playerid][pFMember];
	}
	else
	{
		SendErrorMessage(playerid,"Ban khong o trong family.");
		return 1;
	}

	format(string, sizeof(string), "Family ban  co $%d trong tai khoan.", FamilyInfo[family][FamilyBank]);
	SendClientMessageEx(playerid, COLOR_YELLOW, string);
	return 1;
}

CMD:fdeposit(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 15.0, 2308.7346, -11.0134, 26.7422))
	{
		SendErrorMessage(playerid,"Ban khong o trong ngan hang!");
		return 1;
	}

	new family;
	if(PlayerInfo[playerid][pFMember] < INVALID_FAMILY_ID)
	{
		family = PlayerInfo[playerid][pFMember];
	}
	else
	{
		SendErrorMessage(playerid,"Ban khong o trong family.");
		return 1;
	}

	new string[128], file[32], month, day, year, amount;
	if(sscanf(params, "d", amount))
	{
		SendUsageMessage(playerid, " /fdeposit [amount]");
		format(string, sizeof(string), "Your family has $%s in their account.", number_format(FamilyInfo[family][FamilyBank]));
		SendClientMessageEx(playerid, COLOR_GRAD3, string);
		return 1;
	}

	if (amount > GetPlayerCash(playerid) || amount < 1)
	{
		SendErrorMessage(playerid,"You don't have that much.");
		return 1;
	}
	GivePlayerMoneyEx(playerid,-amount);
	new curfunds = FamilyInfo[family][FamilyBank];
	FamilyInfo[family][FamilyBank] = amount + FamilyInfo[family][FamilyBank];
	SendClientMessageEx(playerid, COLOR_WHITE, "|___ FAMILY BANK STATEMENT ___|");
	format(string, sizeof(string), "  Old Balance: $%s", number_format(curfunds));
	SendClientMessageEx(playerid, COLOR_GRAD2, string);
	format(string, sizeof(string), "  Deposit: $%s", number_format(amount));
	SendClientMessageEx(playerid, COLOR_GRAD4, string);
	SendClientMessageEx(playerid, COLOR_GRAD6, "|-----------------------------------------|");
	format(string, sizeof(string), "  New Balance: $%s", number_format(FamilyInfo[family][FamilyBank]));
	SendClientMessageEx(playerid, COLOR_WHITE, string);
	format(string,sizeof(string),"%s has deposited $%s into %s's bank account.", GetPlayerNameEx(playerid), number_format(amount), FamilyInfo[PlayerInfo[playerid][pFMember]][FamilyName]);
	getdate(year, month, day);
	format(file, sizeof(file), "family_logs/%d/%d-%02d-%02d.log", family, year, month, day);
	Log(file, string);
	return 1;
}

CMD:fwithdraw(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 15.0, 2308.7346, -11.0134, 26.7422))
	{
		SendErrorMessage(playerid,"Ban khong o trong ngan hang!");
		return 1;
	}
	new family;
	if(PlayerInfo[playerid][pFMember] < INVALID_FAMILY_ID)
	{
		family = PlayerInfo[playerid][pFMember];
	}
	else
	{
		SendErrorMessage(playerid,"Ban khong o trong family.");
		return 1;
	}
	if(PlayerInfo[playerid][pRank] < 5)
	{
		SendErrorMessage(playerid,"Only ranks five and six may use the family bank.");
		return 1;
	}

	new string[128], file[32], month, day, year, amount;
	if(sscanf(params, "d", amount))
	{
		SendUsageMessage(playerid, " /fwithdraw [amount]");
		format(string, sizeof(string), "Your family has $%s in their account.", number_format(FamilyInfo[family][FamilyBank]));
		SendClientMessageEx(playerid, COLOR_GRAD3, string);
		return 1;
	}

	if (amount > FamilyInfo[family][FamilyBank] || amount < 1)
	{
		SendErrorMessage(playerid,"Your family doesn't have that much.");
		return 1;
	}

	GivePlayerMoneyEx(playerid, amount);
	FamilyInfo[family][FamilyBank] = FamilyInfo[family][FamilyBank] - amount;
	format(string, sizeof(string), "  You have withdrawn $%s from your family account. Total: $%s", number_format(amount), number_format(FamilyInfo[family][FamilyBank]));
	SendClientMessageEx(playerid, COLOR_YELLOW, string);
	format(string,sizeof(string),"%s has withdrawn $%s from %s's bank account.", GetPlayerNameEx(playerid), number_format(amount), FamilyInfo[PlayerInfo[playerid][pFMember]][FamilyName]);
	getdate(year, month, day);
	format(file, sizeof(file), "family_logs/%d/%d-%02d-%02d.log", family, year, month, day);
	Log(file, string);
	return 1;
}

CMD:safedeposit(playerid, params[]) // TransferStorage(playerid, storageid, fromplayerid, fromstorageid, itemid, amount, price, special)
{
	new family;

	if(PlayerInfo[playerid][pFMember] < INVALID_FAMILY_ID) family = PlayerInfo[playerid][pFMember];
	else return SendErrorMessage(playerid,"Ban khong o trong family.");

	if(FamilyInfo[family][FamilyUSafe] < 1) return SendErrorMessage(playerid,"Your family has not upgraded their safe.");

	new string[128], itemid, storageid, amount;

	if(sscanf(params, "d", itemid, amount) || itemid < 1 || itemid > 5)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "SU DUNG: /safedeposit [amount]");
		return 1;
	}


	if(amount < 1) return SendClientMessageEx(playerid, COLOR_WHITE, "You can't deposit less than 1.");

	
	itemid = 1;
	if(IsPlayerInRangeOfPoint(playerid, 3.0, FamilyInfo[family][FamilySafe][0], FamilyInfo[family][FamilySafe][1], FamilyInfo[family][FamilySafe][2]) && GetPlayerVirtualWorld(playerid) == FamilyInfo[family][FamilySafeVW] && GetPlayerInterior(playerid) == FamilyInfo[family][FamilySafeInt])
	{
		new file[32], month, day, year;
		getdate(year,month,day);
		switch(itemid)
		{
			case 1: // Cash
			{
				if(storageid == 0) {
					if(PlayerInfo[playerid][pCash] >= amount) PlayerInfo[playerid][pCash] -= amount;
					else return SendClientMessageEx(playerid, COLOR_WHITE, "You do not have enough to deposit!");
				}
				else {
					if(StorageInfo[playerid][storageid-1][sCash] >= amount) StorageInfo[playerid][storageid-1][sCash] -= amount;
					else return SendClientMessageEx(playerid, COLOR_WHITE, "You do not have enough to deposit!");
				}

				FamilyInfo[family][FamilyCash] += amount;
				format(string, sizeof(string), "You have deposited $%s to your family's safe.", number_format(amount));
				SendClientMessageEx(playerid, COLOR_WHITE, string);
				OnPlayerStatsUpdate(playerid);
				format(string, sizeof(string), "%s has deposited $%s into %s's safe", GetPlayerNameEx(playerid), number_format(amount), FamilyInfo[family][FamilyName]);
				format(file, sizeof(file), "family_logs/%d/%d-%02d-%02d.log", family, year, month, day);
				Log(file, string);
			}
			case 2: // Pot
			{
				if(storageid == 0) {
					if(PlayerInfo[playerid][pPot] >= amount) PlayerInfo[playerid][pPot] -= amount;
					else return SendClientMessageEx(playerid, COLOR_WHITE, "You do not have enough to deposit!");
				}
				else {
					if(StorageInfo[playerid][storageid-1][sPot] >= amount) StorageInfo[playerid][storageid-1][sPot] -= amount;
					else return SendClientMessageEx(playerid, COLOR_WHITE, "You do not have enough to deposit!");
				}

				FamilyInfo[family][FamilyPot] += amount;
				format(string, sizeof(string), "You have deposited %s grams of pot to your family's safe.", number_format(amount));
				SendClientMessageEx(playerid, COLOR_WHITE, string);
				OnPlayerStatsUpdate(playerid);
				format(string, sizeof(string), "%s has deposited %s pot into %s's safe", GetPlayerNameEx(playerid), number_format(amount), FamilyInfo[family][FamilyName]);
				format(file, sizeof(file), "family_logs/%d/%d-%02d-%02d.log", family, year, month, day);
				Log(file, string);
			}
			case 3: // Crack
			{
				if(storageid == 0) {
					if(PlayerInfo[playerid][pCrack] >= amount) PlayerInfo[playerid][pCrack] -= amount;
					else return SendClientMessageEx(playerid, COLOR_WHITE, "You do not have enough to deposit!");
				}
				else {
					if(StorageInfo[playerid][storageid-1][sCrack] >= amount) StorageInfo[playerid][storageid-1][sCrack] -= amount;
					else return SendClientMessageEx(playerid, COLOR_WHITE, "You do not have enough to deposit!");
				}

				FamilyInfo[family][FamilyCrack] += amount;
				format(string, sizeof(string), "You have deposited %s grams of crack to your family's safe.", number_format(amount));
				SendClientMessageEx(playerid, COLOR_WHITE, string);
				OnPlayerStatsUpdate(playerid);
				format(string, sizeof(string), "%s has deposited %s crack into %s's safe", GetPlayerNameEx(playerid), number_format(amount), FamilyInfo[family][FamilyName]);
				format(file, sizeof(file), "family_logs/%d/%d-%02d-%02d.log", family, year, month, day);
				Log(file, string);
			}
			case 4: // Materials
			{
				if(storageid == 0) {
					if(PlayerInfo[playerid][pMats] >= amount) PlayerInfo[playerid][pMats] -= amount;
					else return SendClientMessageEx(playerid, COLOR_WHITE, "You do not have enough to deposit!");
				}
				else {
					if(StorageInfo[playerid][storageid-1][sMats] >= amount) StorageInfo[playerid][storageid-1][sMats] -= amount;
					else return SendClientMessageEx(playerid, COLOR_WHITE, "You do not have enough to deposit!");
				}

				FamilyInfo[family][FamilyMats] += amount;
				format(string, sizeof(string), "You have deposited %s materials to your family's safe.", number_format(amount));
				SendClientMessageEx(playerid, COLOR_WHITE, string);
				OnPlayerStatsUpdate(playerid);
				format(string, sizeof(string), "%s has deposited %s materials into %s's safe", GetPlayerNameEx(playerid), number_format(amount), FamilyInfo[family][FamilyName]);
				format(file, sizeof(file), "family_logs/%d/%d-%02d-%02d.log", family, year, month, day);
				Log(file, string);
			}
			case 5: // Heroin
			{
				if(PlayerInfo[playerid][pHeroin] >= amount) PlayerInfo[playerid][pHeroin] -= amount;
				else return SendClientMessageEx(playerid, COLOR_WHITE, "You do not have enough to deposit!");

				FamilyInfo[family][FamilyHeroin] += amount;
				format(string, sizeof(string), "You have deposited %s heroin to your family's safe.", number_format(amount));
				SendClientMessageEx(playerid, COLOR_WHITE, string);
				OnPlayerStatsUpdate(playerid);
				format(string, sizeof(string), "%s has deposited %s heroin into %s's safe", GetPlayerNameEx(playerid), number_format(amount), FamilyInfo[family][FamilyName]);
				format(file, sizeof(file), "family_logs/%d/%d-%02d-%02d.log", family, year, month, day);
				Log(file, string);
			}
		}
	}
	else
	{
		return SendErrorMessage(playerid,"You're not at your family safe.");
	}
	return 1;
}

CMD:safewithdraw(playerid, params[]) // TransferStorage(playerid, storageid, fromplayerid, fromstorageid, itemid, amount, price, special)
{
	new family;

	if(PlayerInfo[playerid][pFMember] < INVALID_FAMILY_ID) family = PlayerInfo[playerid][pFMember];
	else return SendErrorMessage(playerid,"Ban khong o trong family.");

	if(FamilyInfo[family][FamilyUSafe] < 1) return SendErrorMessage(playerid,"Your family has not upgraded their safe.");
	if(PlayerInfo[playerid][pRank] < 5) return SendErrorMessage(playerid,"Only ranks 5 and 6 can withdraw items from the family safe.");

	new itemid, amount, string[128];
	if(sscanf(params, "dd", itemid, amount) || (itemid < 1 || itemid > 5))
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "SU DUNG: /safewithdraw [itemid] [amount]");
		SendErrorMessage(playerid,"ItemIDs: (1) Cash - (2) Pot - (3) Crack - (4) Materials - (5) Heroin");
		return 1;
	}

	if(amount < 1) return SendClientMessageEx(playerid, COLOR_WHITE, "You can't withdraw less than 1.");
	if(IsPlayerInRangeOfPoint(playerid, 3.0, FamilyInfo[family][FamilySafe][0], FamilyInfo[family][FamilySafe][1], FamilyInfo[family][FamilySafe][2]) && GetPlayerVirtualWorld(playerid) == FamilyInfo[family][FamilySafeVW] && GetPlayerInterior(playerid) == FamilyInfo[family][FamilySafeInt])
	{
		switch(itemid)
		{
			case 1: // Cash
			{
				if(FamilyInfo[family][FamilyCash] >= amount)
				{
					SetPVarInt(playerid, "Special_FamilyID", family);
					TransferStorage(playerid, -1, -1, -1, itemid, amount, -1, 5);
				}
				else return SendClientMessageEx(playerid, COLOR_WHITE, "Your family safe does not have enough for you to withdraw!");
			}
			case 2: // Pot
			{
				if(FamilyInfo[family][FamilyPot] >= amount)
				{
					SetPVarInt(playerid, "Special_FamilyID", family);
					TransferStorage(playerid, -1, -1, -1, itemid, amount, -1, 5);
				}
				else return SendClientMessageEx(playerid, COLOR_WHITE, "Your family safe does not have enough for you to withdraw!");
			}
			case 3: // Crack
			{
				if(FamilyInfo[family][FamilyCrack] >= amount)
				{
					SetPVarInt(playerid, "Special_FamilyID", family);
					TransferStorage(playerid, -1, -1, -1, itemid, amount, -1, 5);
				}
				else return SendClientMessageEx(playerid, COLOR_WHITE, "Your family safe does not have enough for you to withdraw!");
			}
			case 4: // Materials
			{
				if(FamilyInfo[family][FamilyMats] >= amount)
				{
					SetPVarInt(playerid, "Special_FamilyID", family);
					TransferStorage(playerid, -1, -1, -1, itemid, amount, -1, 5);
				}
				else return SendClientMessageEx(playerid, COLOR_WHITE, "Your family safe does not have enough for you to withdraw!");
			}
			case 5: // Heroin
			{
				if(FamilyInfo[family][FamilyHeroin] >= amount)
				{
					new file[32], month, day, year;
					getdate(year,month,day);
					FamilyInfo[family][FamilyHeroin] -= amount;
					PlayerInfo[playerid][pHeroin] += amount;
					OnPlayerStatsUpdate(playerid);
					format(string, sizeof(string), "You have withdrawn %s heroin from your family safe.", number_format(amount));
					SendClientMessageEx(playerid, COLOR_WHITE, string);
					format(string, sizeof(string), "%s has withdrawn %s heroin from %s's safe", GetPlayerNameEx(playerid), number_format(amount), FamilyInfo[family][FamilyName]);
					format(file, sizeof(file), "family_logs/%d/%d-%02d-%02d.log", family, year, month, day);
					Log(file, string);
				}
				else return SendClientMessageEx(playerid, COLOR_WHITE, "Your family safe does not have enough for you to withdraw!");
			}
		}
	}
	else
	{
		return SendErrorMessage(playerid,"You're not at your family safe.");
	}
	return 1;
}

CMD:adjust(playerid, params[])
{
	if(PlayerInfo[playerid][pFMember] == INVALID_FAMILY_ID)
	{
		SendErrorMessage(playerid,"You aren't in a family.");
		return 1;
	}
	new family = PlayerInfo[playerid][pFMember];
	new string[128], file[32], month, day, year;
	getdate(year,month,day);
	if(PlayerInfo[playerid][pRank] >= 5)
	{
		new choice[32], opstring[100];
		if(sscanf(params, "s[32]S[100]", choice, opstring))
		{
			SendUsageMessage(playerid, " /adjust [name]");
			SendSelectMessage(playerid, " Name, Safe");
			return 1;
		}

		if(strcmp(choice,"name",true) == 0)
		{
			if(PlayerInfo[playerid][pRank] == 6)
			{
				if(!opstring[0])
				{
					SendUsageMessage(playerid, " /adjust name [family name]");
					return 1;
				}
				if(strfind(opstring, "|", true) != -1)
				{
					SendClientMessageEx(playerid, COLOR_GRAD2,  "You can't use '|' in a family name.");
					return 1;
				}
				if(strlen(opstring) >= 40 )
				{
					SendClientMessageEx( playerid, COLOR_GRAD1, "That family name is too long, please refrain from using more than 40 characters." );
					return 1;
				}
				strmid(FamilyInfo[family][FamilyName], opstring, 0, strlen(opstring), 100);
				SaveFamilies();
				SendClientMessageEx(playerid, COLOR_WHITE, "You've adjusted your family's name.");
				format(string, sizeof(string), "%s adjusted %s's name to %s", GetPlayerNameEx(playerid), FamilyInfo[family][FamilyName], opstring);
				format(file, sizeof(file), "family_logs/%d/%d-%02d-%02d.log", family, year, month, day);
				Log(file, string);
			}
		}
		else if(strcmp(choice,"safe",true) == 0)
		{
			if(PlayerInfo[playerid][pRank] == 6)
			{
				GetPlayerPos(playerid, FamilyInfo[family][FamilySafe][0], FamilyInfo[family][FamilySafe][1], FamilyInfo[family][FamilySafe][2]);
				FamilyInfo[family][FamilySafeVW] = GetPlayerVirtualWorld(playerid);
				FamilyInfo[family][FamilySafeInt] = GetPlayerInterior(playerid);
				FamilyInfo[family][FamilyCash] = 0;
				FamilyInfo[family][FamilyMats] = 0;
				FamilyInfo[family][FamilyPot] = 0;
				FamilyInfo[family][FamilyCrack] = 0;
				if(FamilyInfo[family][FamilyUSafe]) DestroyDynamicPickup(FamilyInfo[family][FamilyPickup]);
				FamilyInfo[family][FamilyUSafe] = 1;
				FamilyInfo[family][FamilyPickup] = CreateDynamicPickup(1239, 23, FamilyInfo[family][FamilySafe][0], FamilyInfo[family][FamilySafe][1], FamilyInfo[family][FamilySafe][2], .worldid = FamilyInfo[family][FamilySafeVW], .interiorid = FamilyInfo[family][FamilySafeInt]);
				SaveFamilies();
				SendClientMessageEx(playerid, COLOR_WHITE, "Ban da dat Locker cua gang tai day..");
				format(string, sizeof(string), "%s adjusted %s's safe", GetPlayerNameEx(playerid), FamilyInfo[family][FamilyName]);
				format(file, sizeof(file), "family_logs/%d/%d-%02d-%02d.log", family, year, month, day);
				Log(file, string);
			}
		}
		else if(strcmp(choice,"confirmzzz",true) == 0)
		{
			if(PlayerInfo[playerid][pRank] == 6)
			{
				if(GetPlayerCash(playerid) < 10000)
				{
					SendErrorMessage(playerid,"You don't have $10,000 to upgrade your family safe.");
					return 1;
				}
				GivePlayerMoneyEx(playerid, -10000);
				GetPlayerPos(playerid, FamilyInfo[family][FamilySafe][0], FamilyInfo[family][FamilySafe][1], FamilyInfo[family][FamilySafe][2]);
				FamilyInfo[family][FamilySafeVW] = GetPlayerVirtualWorld(playerid);
				FamilyInfo[family][FamilySafeInt] = GetPlayerInterior(playerid);
				FamilyInfo[family][FamilyCash] = 0;
				FamilyInfo[family][FamilyMats] = 0;
				FamilyInfo[family][FamilyPot] = 0;
				FamilyInfo[family][FamilyCrack] = 0;
				if(FamilyInfo[family][FamilyUSafe]) DestroyDynamicPickup(FamilyInfo[family][FamilyPickup]);
				FamilyInfo[family][FamilyUSafe] = 1;
				FamilyInfo[family][FamilyPickup] = CreateDynamicPickup(1239, 23, FamilyInfo[family][FamilySafe][0], FamilyInfo[family][FamilySafe][1], FamilyInfo[family][FamilySafe][2], .worldid = FamilyInfo[family][FamilySafeVW], .interiorid = FamilyInfo[family][FamilySafeInt]);
				SaveFamilies();
				SendClientMessageEx(playerid, COLOR_WHITE, "You've adjusted your family's Safe.");
				format(string, sizeof(string), "%s adjusted %s's safe", GetPlayerNameEx(playerid), FamilyInfo[family][FamilyName]);
				format(file, sizeof(file), "family_logs/%d/%d-%02d-%02d.log", family, year, month, day);
				Log(file, string);
			}
		}
	}
	else
	{
		SendErrorMessage(playerid,"   You do not have a high enough rank to use this command!");
		return 1;
	}
	return 1;
}

// REMAKE
CMD:viewmotd(playerid, params[])
{
	new string[128], option[16];
	if(sscanf(params, "s[16]", option))
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "SU DUNG: /viewmotd [option]");
		strcat(string, "Available Options: global");
		if(PlayerInfo[playerid][pDonateRank] >= 1) strcat(string, ", vip");
		if(PlayerInfo[playerid][pFMember] != INVALID_FAMILY_ID) strcat(string, ", family");
		if(PlayerInfo[playerid][pMember] != INVALID_GROUP_ID) strcat(string, ", group");
		if(PlayerInfo[playerid][pHelper] >= 1) strcat(string, ", advisor");
		if(PlayerInfo[playerid][pAdmin] > 1) strcat(string, ", admin");
		return SendClientMessageEx(playerid, COLOR_WHITE, string);
	}
	if(strcmp(option, "global", true) == 0) return SendClientMessageEx(playerid, COLOR_YELLOW, GlobalMOTD);
	if(strcmp(option, "vip", true) == 0 && PlayerInfo[playerid][pDonateRank] >= 1) return SendClientMessageEx(playerid, COLOR_VIP, VIPMOTD);
	if(strcmp(option, "family", true) == 0 && PlayerInfo[playerid][pFMember] != INVALID_FAMILY_ID)
	{
		new fam = PlayerInfo[playerid][pFMember];
		SendClientMessageEx(playerid, COLOR_WHITE, "Family MOTD's:");
		for(new i = 1; i <= 3; i++)
		{
			format(string, sizeof(string), "%d: %s", i, FamilyMOTD[fam][i-1]);
			SendClientMessageEx(playerid, COLOR_YELLOW, string);
		}
	}
	if(strcmp(option, "group", true) == 0 && PlayerInfo[playerid][pMember] != INVALID_GROUP_ID)
		return SendClientMessageEx(playerid, arrGroupData[PlayerInfo[playerid][pMember]][g_hDutyColour] * 256 + 255, arrGroupData[PlayerInfo[playerid][pMember]][g_szGroupMOTD]);
	if(strcmp(option, "advisor", true) == 0 && PlayerInfo[playerid][pHelper] >= 1) return SendClientMessageEx(playerid, TEAM_AZTECAS_COLOR, CAMOTD);
	if(strcmp(option, "admin", true) == 0 && PlayerInfo[playerid][pAdmin] > 1) return SendClientMessageEx(playerid, COLOR_YELLOW, AdminMOTD);
	return 1;
}

CMD:adjustrankname(playerid, params[])
{
	if(PlayerInfo[playerid][pFMember] == INVALID_FAMILY_ID)
	{
		SendErrorMessage(playerid,"You aren't in a family.");
		return 1;
	}
	new family = PlayerInfo[playerid][pFMember];
	new string[128], rank, rankname[30];
	if(sscanf(params, "ds[30]", rank, rankname)) return SendUsageMessage(playerid, " /adjustrankname [rank number 0-6] [rank name]");

	if(PlayerInfo[playerid][pRank] == 6)
	{
		if(rank < 0 || rank > 6)
		{
			SendErrorMessage(playerid,"Rank number must be from 0 to 6.");
			return 1;
		}
		if(strfind(rankname, "|", true) != -1)
		{
			SendClientMessageEx(playerid, COLOR_GRAD2,  "You can't use '|' in a rank name.");
			return 1;
		}
		if(strlen(rankname) >= 19 )
		{
			SendErrorMessage(playerid,"That rank name is too long, please refrain from using more than 19 characters.");
			return 1;
		}

		new file[32], month, day, year ;
		getdate(year,month,day);
		format(FamilyRankInfo[family][rank], 30, "%s", rankname);
		SaveFamily(family);
		format(string, sizeof(string), "* You have changed rank %d to %s.", rank, rankname);
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
		format(string, sizeof(string), "%s adjusted %s's rank %d to %s", GetPlayerNameEx(playerid), FamilyInfo[family][FamilyName], rank, rankname);
		format(file, sizeof(file), "family_logs/%d/%d-%02d-%02d.log", family, year, month, day);
		Log(file, string);
	}
	else return SendErrorMessage(playerid,"   You are not high rank enough to use this command!");
	return 1;
}

CMD:fcreate(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] > 3 || PlayerInfo[playerid][pGangModerator] >= 1)
	{
		new string[128], family, giveplayerid;
		if(sscanf(params, "du", family, giveplayerid)) return SendUsageMessage(playerid, " /fcreate [FamilyNr] [player]");
		if(family < 1 || family > MAX_FAMILY-1) {
			format(string, sizeof(string), "   FamilyNr can't be below 1 or above %i!", MAX_FAMILY-1);
		 	SendClientMessageEx(playerid, COLOR_GREY, string);
	 	    return 1;
	   }

		if(IsPlayerConnected(giveplayerid))
		{
			if(FamilyInfo[family][FamilyTaken] == 1)
			{
				SendErrorMessage(playerid,"   That Family Slot is already taken!" );
				return 1;
			}

			format(string, sizeof(string), "* You've made %s the Leader of Family Slot %d.",GetPlayerNameEx(giveplayerid),family);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
			format(string, sizeof(string), "* Admin %s has made you a Family Leader.", GetPlayerNameEx(playerid));
			SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);

			new sendername[MAX_PLAYER_NAME];
			GetPlayerName(giveplayerid, sendername, sizeof(sendername));
			format(string, sizeof(string), "%s",sendername);
			strmid(FamilyInfo[family][FamilyLeader], string, 0, strlen(string), 24);
			FamilyInfo[family][FamilyMembers] ++;
			FamilyInfo[family][FamilyTaken] = 1;
			PlayerInfo[giveplayerid][pFMember] = family;
			PlayerInfo[giveplayerid][pRank] = 6;
			PlayerInfo[giveplayerid][pDivision] = 0;
			SaveFamily(family);

		}
		else
		{
			SendErrorMessage(playerid,"Nguoi choi khong hop le.");
			return 1;
		}
	}
	return 1;
}

CMD:fdelete(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] > 3 || PlayerInfo[playerid][pGangModerator] >= 1)
	{
		new family, string[128];
		if(sscanf(params, "d", family)) return SendUsageMessage(playerid, " /fdelete [familyid]");

		if(family < 1 || family > MAX_FAMILY-1) {
	 		format(string,sizeof(string), "   Family Slot can't be below 1 or above %i!", MAX_FAMILY-1);
			SendClientMessageEx(playerid, COLOR_GREY, string);
		 	return 1;
	 	}
		if(FamilyInfo[family][FamilyTaken] != 1)
		{
			SendErrorMessage(playerid,"   That Family Slot isn't taken!");
			return 1;
		}
		ClearFamily(family);
		SaveFamily(family);
	}
	return 1;
}


CMD:fmotd(playerid, params[])
{
	if(PlayerInfo[playerid][pFMember] == INVALID_FAMILY_ID) return SendErrorMessage(playerid,"You aren't in a family.");
	if(PlayerInfo[playerid][pRank] < 5) return SendErrorMessage(playerid,"   You do not have a high enough rank to use this command!");
	new string[128], slot, family = PlayerInfo[playerid][pFMember];
	if(sscanf(params, "ds[128]", slot, string)) return SendUsageMessage(playerid, " /fmotd [slot] [family MOTD text]");
	if(strlen(string) > 128) return SendClientMessageEx( playerid, COLOR_GRAD1, "That MOTD is too long, please refrain from using more than 128 characters." );
	if(1 <= slot <= 3)
	{
		new file[32], month, day, year ;
		getdate(year,month,day);
		strmid(FamilyMOTD[family][slot-1], string, 0, strlen(string), 128);
		SaveFamilies();
		format(string, sizeof(string), "%s adjusted %s's MOTD (slot %d) to %s", GetPlayerNameEx(playerid), FamilyInfo[family][FamilyName], slot, string);
		format(file, sizeof(file), "family_logs/%d/%d-%02d-%02d.log", family, year, month, day);
		Log(file, string);
		format(string, sizeof(string),"You've adjusted your family's MOTD in slot %d.", slot);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
	}
	else return SendErrorMessage(playerid,"Slot ID Must be between 1 and 3!");
	return 1;
}
