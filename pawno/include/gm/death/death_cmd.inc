ALTX:damages("/dmg");
CMD:damages(playerid, params[])
{
	new userid;

	if (!IsPlayerLogged(playerid))												return SendNotConnected(playerid);
	if (sscanf(params, "u", userid))												return SendHelpMessage(playerid,"/damages(/dmg) [ID/Ten]");
	if (!IsPlayerConnected(userid))                 								return SendErrorMessage(playerid, "Nguoi choi nay ngoai tuyen.");
	if (!PlayerNearPlayer(3.0, playerid, userid) && !CheckAdmin(playerid, ADMIN_LEVEL_1))	return SendNotNearPlayer(playerid);

	pTemp[playerid][pDialogList] = 0;

	DisplayDamages(playerid, userid);
	return 1;
}

CMD:helpup(playerid, params[])
{
	new userid;

	if (!IsPlayerLogged(playerid))				 return SendNotConnected(playerid);
	if (sscanf(params, "u", userid))			 return SendHelpMessage(playerid,"/helpup [ID/Ten]");
	if (userid == playerid)						 return 1;
	if (!IsPlayerConnected(userid))            	 return SendErrorMessage(playerid, "Nguoi choi nay ngoai tuyen."); //מפכאים
	if (!PlayerNearPlayer(2.0, playerid, userid)) return SendNotNearPlayer(playerid);
	if (pTemp[userid][pInjuredTime]-40 > 0)		 return SendErrorMessage(playerid, "Ban phai doi %i giay nua!", pTemp[userid][pInjuredTime]-40); 
	
	StartProgress(userid, playerid, 1, 839);
	return 1;
}

CMD:acceptdeath(playerid, params[])
{
    if (PlayerInfo[playerid][pInjured] == 0) return SendErrorMessage(playerid, "Ban khong bi thuong.");

	new count = 0;
	foreach(new i : Player)
	{
		if (i == playerid) continue;
		if (GetPlayerDistanceFromPlayer(playerid, i) < 11.0) count++;
	}

	if (pTemp[playerid][pInjuredTime])
	{
		if (count) {
			SendWarningMessage(playerid, "Ban khong the chap nhan cai chet ngay lap tuc neu co nguoi choi ben canh. Ban can doi them mot thoi gian nua. %i giay.", pTemp[playerid][pInjuredTime]);
			return 1;
		}
	}

	SendSpecialMessage(playerid, "Nhan vat cua ban da chet, nhung ban phai doi 60 giay de hoi sinh \"/respawn\"."); 
	PlayerInfo[playerid][pInjured] = 2;
	pTemp[playerid][pInjuredTime] = 60;
	return 1;
}

CMD:respawn(playerid, params[])
{
	if (PlayerInfo[playerid][pInjured] != 2) return SendErrorMessage(playerid, "Ban khong chet.");
	if (pTemp[playerid][pInjuredTime]) 		return SendSpecialMessage(playerid, "Ban chi doi %i giay. Ban phai doi it nhat 60 giay de su dung /respawn.", 60 - pTemp[playerid][pInjuredTime]);

    if (PlayerInfo[playerid][pAJailed] != 0)
	{
		SetInterior(playerid, 18);
		SetWorld(playerid, playerid + 100);
		SetPlayerPos(playerid, -219.4580,1410.6747,27.7734);
		SendClientMessageEx(playerid, COLOR_WHITE,"Ban da duoc dua tro lai nha tu quan tri vien. Ky han: %i phut.", PlayerInfo[playerid][pAJailTime]/60);
	}
	else if (PlayerInfo[playerid][pJailed])
	{
	    PutPlayerInPrison(playerid);
	}
	else
	{
		CreateCorpse(playerid, PlayerInfo[playerid][pDeathReason]);

    	SetPlayerPos(playerid, 1242.1882, 328.0487, 19.7555);
		SetPlayerFacingAngle(playerid, 270.0);
		SetInterior(playerid, 0);
		SetWorld(playerid, 0);
		
		SM2(playerid, "Ban da nhap vien.");
		
		new 
			bill,
			tax,
			year,
			month,
			day
		;
		
	    getdate(year, month, day);
	    
	    bill = 100, tax = 15;

		SendClientMessageEx(playerid,0xFF8282AA,"**********************************************");
        SendClientMessageEx(playerid,0xFF8282AA,"             	HOA DON VIEN PHI:");
        SendClientMessageEx(playerid,0xFF8282AA,"TEN: %s - THOI GIAN: %d-%d-%d.", GetNameEx(playerid), day, month, year);
        SendClientMessageEx(playerid,0xFF8282AA,"DICH VU: $%d - THUE: $%d.", bill, tax);
		bill+=tax;
        SendClientMessageEx(playerid,0xFF8282AA,"TONG CONG: $%d.", bill);
        SendClientMessageEx(playerid,0xFF8282AA,"**********************************************");
	}
	
	PlayerInfo[playerid][pDeathReason] = 0;
	SQL_SetInteger("users", "deathreason", 0, PlayerInfo[playerid][pID]);
	
	if (!PlayerInfo[playerid][pPremium]) SetPlayerHealth(playerid, 50.0);
	else							  	SetPlayerHealth(playerid, 100.0);

	ResetDamages(playerid);
	StopPlayerAnims(playerid);
	UnFreezePlayer(playerid);

	SetPlayerSkill(playerid);
	return 1;
}
