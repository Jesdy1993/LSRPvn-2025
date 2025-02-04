CMD:isolate(playerid, params[])
{
	new userid, time;

	if (!IsPlayerFactionDocs(playerid))									return SendErrorMessage(playerid,"Ban phai la nhan vien nha tu.");
	if (sscanf(params,"uI(0)", userid, time))							return SendHelpMessage(playerid, "/isolate [ID/Ten] [thoi gian (phut)]");
	if (!PlayerInfo[playerid][pOnDuty])									return SendErrorMessage(playerid, "Ban can trong gio lam viec. ");
	if (!PlayerToPoint(50.0, playerid, -1774.4573,-488.8803,621.1163))	return SendErrorMessage(playerid, "Ban phai o trong khu cach ly.");
	if (!IsPlayerLogged(userid))											return SendNotConnected(playerid);
	if (!PlayerNearPlayer(3.0, playerid, userid))						return SendNotNearPlayer(playerid);
	if (userid == playerid)												return 1;

	if (PlayerInfo[userid][pIsolateTime])
	{
	    SendSyntaxMessage(playerid, "Ban da tha %s khoi khu cach ly.", GetNameEx(userid));
		SendSyntaxMessage(userid, "Ban da duoc tha khoi khu cach ly.");
		PlayerInfo[userid][pPrisoned] = random(sizeof(prison_sadoc));

		new mes[5];

		format(mes, sizeof(mes), "A%i", PlayerInfo[userid][pPrisoned]+100);
        UpdateDynamic3DTextLabelText(PrisonLabel[userid], 0x00FF00FF, mes);
		SendSyntaxMessage(userid, "So tu nhan cua ban - A%i(/myprisonnumber).", PlayerInfo[userid][pPrisoned]+100);
        PlayerInfo[userid][pIsolateTime] = 0;
		
		foreach(new i : Player)
		{
			if (!IsPlayerLogged(i) || PlayerInfo[i][pJailed] != PRISON_JAIL) continue;

			SendSyntaxMessage(i, "%s %s da tha %s khoi khu cach ly.", GetRankName(playerid), GetNameEx(playerid), GetNameEx(userid));
		}
	    return 1;
	}

	if (time < 1 || time > 360) return SendErrorMessage(playerid, "Thoi gian chi tu 1 phut den 360 phut.");

    SendSyntaxMessage(playerid, "Ban da dua %s vao khu cach ly.", GetNameEx(userid));
	SendSyntaxMessage(userid, "Ban da duoc dua vao khu cach ly.");
	PlayerInfo[userid][pPrisoned] = random(sizeof(prison_sadoc));
	SendSyntaxMessage(userid, "So tu nhan cua ban - B%i(/myprisonnumber).", PlayerInfo[userid][pPrisoned]+100);
	PlayerInfo[userid][pIsolateTime] = 60 * time;
	PutPlayerInPrison(userid);

	foreach(new i : Player)
	{
		if (!IsPlayerLogged(i) || PlayerInfo[i][pJailed] != PRISON_JAIL) continue;

		SendSyntaxMessage(i, "%s %s da cach ly %s.", GetRankName(playerid), GetNameEx(playerid), GetNameEx(userid));
	}
	return 1;
}

CMD:free(playerid, params[])
{
	new userid;

	if (!IsPlayerFactionDocs(playerid))								return SendErrorMessage(playerid, "Ban phai la nhan vien nha tu.");
	if (sscanf(params,"u", userid))                                  return SendHelpMessage(playerid, "/free [ID/Ten]");
	if (!PlayerInfo[playerid][pOnDuty])                              return SendErrorMessage(playerid, "Ban can trong gio lam viec. ");
	if (!PlayerToPoint(30.0, playerid, 555.5505,-474.4340,915.6733)) return SendErrorMessage(playerid, "Ban khong o trong nha tu. ");
	if (!IsPlayerLogged(userid))                                     return SendNotConnected(playerid);
	if (!PlayerNearPlayer(3.0, playerid, userid))                    return SendNotNearPlayer(playerid);
	if (userid == playerid)                                          return 1;
	if (PlayerInfo[userid][pJailed] != PRISON_JAIL)                  return SendErrorMessage(playerid, "Nguoi choi khong o trong nha tu.");
	if (PlayerInfo[playerid][pRank] < 6)                             return SendErrorMessage(playerid, "Ban khong the tha tu nhan ra khoi nha tu. ");

	SetPlayerPosEx(userid, 135.2682,1947.4398,19.3663);
	SetInterior(userid, 0);
	SetWorld(userid, 0);
	PlayerInfo[userid][pIsolateTime] = 0;
	PlayerInfo[userid][pJailTime] = 0;
	PlayerInfo[userid][pJailed] = 0;

	if (IsValidDynamic3DTextLabel(PrisonLabel[userid]))
	{
		DestroyDynamic3DTextLabel(PrisonLabel[userid]);
  		PrisonLabel[userid] = Text3D:INVALID_3DTEXT_ID;
	}

	InfoMSG(userid,   "~g~BAN DA DUOC THA~n~~w~HAY LA MOT CONG DAN TOT", 6);
	SendSyntaxMessage(userid, "Ban da duoc an xa tu %s %s.", GetRankName(playerid), GetNameEx(playerid));
	return 1;
}