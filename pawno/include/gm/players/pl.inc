Player_OnPlayerUpdate(playerid)
{
    if (IsPlayerNPC(playerid) || !IsPlayerLogged(playerid)) 	return 1;
	
    if (IsPlayerAFK(playerid))
	{
		if (!(PlayerInfo[playerid][pSettings] & togAFK))	SendSyntaxMessage(playerid, "Ban o trang thai AFK (treo may) trong %i giay.", pTemp[playerid][pDarkAFK]-2);
	}

	pTemp[playerid][pDarkAFK] = 0;
    return 1;
}