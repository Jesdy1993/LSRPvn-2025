CMD:news(playerid,params[])
{
	if (!IsPlayerFactionNews(playerid))				return SendErrorMessage(playerid, "Ban khong phai la nhan vien SAN.");
	if (PlayerInfo[playerid][pSettings] & togNews)	return SendErrorMessage(playerid, "Ban da tat nguon cap tin tuc. ");
	if (pTemp[playerid][pNews] != 0)				return SendErrorMessage(playerid, "Ban da duoc phat song. Su dung /exitnews de thoat. ");

	pTemp[playerid][pNews] = 1;
	SendSyntaxMessage(playerid,"Ban da bat dau bao cao. Su dung tro chuyen de phat song");
	return 1;
}

CMD:exitnews(playerid,params[])
{
	if (!IsPlayerFactionNews(playerid))	return SendErrorMessage(playerid, "Ban khong phai la nhan vien SAN.");
	if (pTemp[playerid][pNews] == 0)	return SendErrorMessage(playerid, "Ban khong dang tren song. Su dung /news de phat tin tuc. ");

	pTemp[playerid][pNews] = 0;
	SendSyntaxMessage(playerid, "Ban da hoan thanh bao cao.");
	return 1;
}

CMD:interview(playerid, params[])
{
    if (!IsPlayerFactionNews(playerid))	return SendErrorMessage(playerid, "Ban khong phai la nhan vien SAN.");

	new userid;
	
	if (sscanf(params,"u",userid))								return SendHelpMessage(playerid, "/interview [ID/Ten]");
	if (PlayerInfo[playerid][pSettings] & togNews)				return SendErrorMessage(playerid, "Ban da tat nguon cap tin tuc.");
	if (pTemp[playerid][pNews] == 0)							return SendErrorMessage(playerid, "Ban khong dang tren song. Su dung /news de phat truc tiep. ");
	if (userid == playerid)										return SendErrorMessage(playerid, "Ban khong the moi ban than phong van.");
	if (!PlayerNearPlayer(3.0, playerid, userid))				return SendNotNearPlayer(playerid);
	if (pTemp[playerid][pInterviewPlayer] != INVALID_PLAYER_ID)	return SendErrorMessage(playerid, "Ban da duoc moi phong van, vui long doi mot luc hoac chap nhan loi moi.");
	if (pTemp[userid][pInterviewPlayer] != INVALID_PLAYER_ID)	return SendErrorMessage(playerid, "Mot loi moi phong van da duoc gui den nguoi choi.");

    pTemp[userid][pInterviewPlayer] = playerid;
    SetPVarInt(userid, #accept_time, gettime() + 30);

    SendSyntaxMessage(playerid, "%s da nhan duoc loi moi phong van, vui long doi", GetNameWithMask(userid));
	SendSyntaxMessage(userid, "%s da moi ban den phong van.", GetNameWithMask(playerid));
	SendSyntaxMessage(userid, "Nhan Y de chap nhan phong van. ");
	return 1;
}

CMD:exitinterview(playerid, params[])
{
	if (pTemp[playerid][pInterview] != INVALID_PLAYER_ID)
	{
	    SendSyntaxMessage(playerid, "Ban da hoan thanh phong van. ");
	    pTemp[playerid][pInterview] = INVALID_PLAYER_ID;
	    return 1;
	}

    if (!IsPlayerFactionNews(playerid))	return SendErrorMessage(playerid, "Ban khong phai la nhan vien SAN. ");

	new userid;

	if (sscanf(params,"u", userid))						return SendHelpMessage(playerid, "/exitinterview [ID/Ten]");
	if (!IsPlayerLogged(userid))						return SendNotConnected(playerid);
	if (!PlayerNearPlayer(3.0, playerid, userid))		return SendNotNearPlayer(playerid);
	if (pTemp[userid][pInterview] == INVALID_PLAYER_ID)	return SendErrorMessage(playerid, "Ban khong phong van nguoi choi nay ");

    SendSyntaxMessage(playerid, "Ban da hoan thanh cuoc phong van voi %s.", GetNameWithMask(userid));
	SendSyntaxMessage(userid, "%s da hoan thanh cuoc phong van voi ban.", GetNameWithMask(playerid));
	pTemp[userid][pInterview] = INVALID_PLAYER_ID;
	return 1;
}
