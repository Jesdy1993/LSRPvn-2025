PlaceBoombox(playerid)
{
	if (BoomboxInfo[playerid][bUsed] != 0)				return SendErrorMessage(playerid, "Ban khong the dat nhieu hon mot boombox.");
	if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)	return SendErrorMessage(playerid, "Boombox khong the duoc dat o day.");

	foreach(new i : Player)
	{
		if (!IsPlayerLogged(i) || !BoomboxInfo[i][bUsed]) 	continue;
		if (IsValidDynamicArea(BoomboxInfo[i][bArea]))		return SendErrorMessage(playerid, "Ai do da dat boombox cua ho o gan do.");
	}

	new id = -1;
	if ((id = GetNearInsideHouse(playerid)) != -1 && HouseInfo[id][hRadioOn])	return SendErrorMessage(playerid, "Radio da phat trong nha.");
	else if ((id = GetNearInsideBiz(playerid)) != -1 && BizInfo[id][bizRadioOn])	return SendErrorMessage(playerid, "Radio da phat trong doanh nghiep.");
	if (!RemovePlayerItem(playerid, INV_BOOMBOX, 1))								return SendErrorMessage(playerid, "Ban khong co mot boombox.");

	SendSyntaxMessage(playerid, "Ban da dat mot boombox, hay su dung phim H de dieu khien.");

	GetXYInFrontOfPlayer(playerid, BoomboxInfo[playerid][bPosX], BoomboxInfo[playerid][bPosY], BoomboxInfo[playerid][bPosZ], 1.0);
 	BoomboxInfo[playerid][bInt] = GetInterior(playerid);
  	BoomboxInfo[playerid][bVW] = GetWorld(playerid);
   	BoomboxInfo[playerid][bUsed] = 1;
   	BoomboxInfo[playerid][bUrl] = EOS;
	BoomboxInfo[playerid][bObject] = CreateDynamicObject(2226, BoomboxInfo[playerid][bPosX], BoomboxInfo[playerid][bPosY], BoomboxInfo[playerid][bPosZ]-1.0, 0.0, 0.0, 0.0, BoomboxInfo[playerid][bVW], BoomboxInfo[playerid][bInt], -1, 300.0);
	BoomboxInfo[playerid][bArea] = CreateDynamicSphere(BoomboxInfo[playerid][bPosX], BoomboxInfo[playerid][bPosY], BoomboxInfo[playerid][bPosZ], 50.0, BoomboxInfo[playerid][bVW], BoomboxInfo[playerid][bInt]);
	pTemp[playerid][pBoombox] = playerid;
	StopAudioStreamForPlayer(playerid);
	Iter_Add(boomboxIter, playerid);
	return 1;
}

ShowBoomboxMenu(playerid)
{
	if (BoomboxInfo[playerid][bUsed] == 0 || Boombox_Nearest(playerid) == 0)	return 1;

	Dialog_Show(playerid, BoomBox, DIALOG_STYLE_LIST, "{FFFFFF}Boombox", "Chon dai phat thanh\nNhac cua toi\nTat boombox\nNang boombox", "Chon", "Huy bo");
	return 1;
}

ChangeUrlBoombox(playerid, url[])
{
    if (BoomboxInfo[playerid][bUsed] != 0 && Boombox_Nearest(playerid) != 0)
	{
		format(BoomboxInfo[playerid][bUrl], 156, url);

		foreach (new i : Player)
		{
	    	if (!IsPlayerLogged(i) || pTemp[i][pBoombox] != playerid) continue;
	        
        	StopAudioStreamForPlayer(i);
			PlayAudioStreamForPlayer(i, BoomboxInfo[playerid][bUrl], BoomboxInfo[playerid][bPosX], BoomboxInfo[playerid][bPosY], BoomboxInfo[playerid][bPosZ], 50.0, 1);
		}
		return 1;
	}
	
	new vehicle = GetPlayerVehicleID(playerid), id;

    if (IsDriver(playerid))
	{
		if (!VehicleInfo[vehicle][carRadio])	return SendErrorMessage(playerid, "Khong co radio trong phuong tien nay.");

		VehicleInfo[vehicle][carRadioOn] = 1;
	    format(VehicleInfo[vehicle][carRadioURL], 156, url);
		SetPlayerChatBubble(playerid, "thay doi dai phat thanh.", COLOR_PURPLE, 20.0, 4000);
	    foreach(new i : Player)
		{
			if (!IsPlayerLogged(i) || GetPlayerVehicleID(i) != vehicle) continue;

			StopAudioStreamForPlayer(i);
			PlayAudioStreamForPlayer(i, url);
		}
		return 1;
	}

	if ((id = GetNearInsideHouse(playerid)) != -1 && HouseInfo[id][hOwnerID] == PlayerInfo[playerid][pID])
	{
	    if (!HouseInfo[id][hRadio])	return SendErrorMessage(playerid, "Khong co radio trong nha cua ban.");

		HouseInfo[id][hRadioOn] = 1;
		format(HouseInfo[id][hRadioURL], 156, url);
        SetPlayerChatBubble(playerid, "thay doi dai phat thanh.", COLOR_PURPLE, 20.0, 4000);
	 	foreach(new i : Player)
		{
			if (!IsPlayerLogged(i) || !IsPlayerInsideHouse(i, id)) continue;

            StopAudioStreamForPlayer(i);
			PlayAudioStreamForPlayer(i, url);
			pTemp[i][pBoombox_house] = id;
		}
	    return 1;
	}
	else if ((id = GetNearInsideBiz(playerid)) != -1 && BizInfo[id][bizOwnerID] == PlayerInfo[playerid][pID])
	{
	    if (BizInfo[id][bizRadio] == 0)	return SendErrorMessage(playerid, "Khong co radio trong doanh nghiep cua ban.");

		BizInfo[id][bizRadioOn] = 1;
		format(BizInfo[id][bizRadioURL], 156, url);
        SetPlayerChatBubble(playerid, "thay doi dai phat thanh.", COLOR_PURPLE, 20.0, 4000);
	 	foreach(new i : Player)
		{
			if (!IsPlayerLogged(i) || !IsPlayerBizInside(i, id))	continue;

            StopAudioStreamForPlayer(i);
			PlayAudioStreamForPlayer(i, url);
			pTemp[i][pBoombox_biz] = id;
		}
	    return 1;
	}
	return 1;
}

Destroy_Boombox(playerid)
{
    if (BoomboxInfo[playerid][bUsed] == 0) 			return 1;
    if (GiveInvItem(playerid, INV_BOOMBOX, 1) == -1) return SendErrorMessage(playerid, "Tui do da day.");
	
    BoomboxInfo[playerid][bUsed] = 0;
    
    foreach(new i : Player)
	{
		if (!IsPlayerLogged(i) || pTemp[i][pBoombox] != playerid) continue;

		StopAudioStreamForPlayer(i);
	}
    
	if (IsValidDynamicArea(BoomboxInfo[playerid][bArea]))		DestroyDynamicArea(BoomboxInfo[playerid][bArea]);
    if (IsValidDynamicObject(BoomboxInfo[playerid][bObject]))	DestroyDynamicObject(BoomboxInfo[playerid][bObject]);

	Iter_Remove(boomboxIter, playerid);
        
	return 1;
}

Boombox_Nearest(playerid)
{
	return (BoomboxInfo[playerid][bUsed] == 0 || !IsPlayerInRangeOfPoint(playerid, 2.0, BoomboxInfo[playerid][bPosX], BoomboxInfo[playerid][bPosY], BoomboxInfo[playerid][bPosZ]) || GetWorld(playerid) != BoomboxInfo[playerid][bVW] || GetInterior(playerid) != BoomboxInfo[playerid][bInt])?(0):(1);
}

ShowBoomBoxStations(playerid) // choose g�ngre
{
	return Dialog_Show(playerid, RadioStations, DIALOG_STYLE_LIST, "Chon the loai", "Pop/Dance/Dubstep\nJazz/Country/Rock\nHip-hop/RnB/Reggae\nNhac cua toi\nTat radio", "Chon", "Dong");
}

StopCarBoomBox(vehicle)
{
	if (VehicleInfo[vehicle][carRadioOn] != 1)	return 1;

    VehicleInfo[vehicle][carRadioOn] = 0;

	foreach(new i : Player)
	{
		if (!IsPlayerLogged(i) || GetPlayerVehicleID(i) != vehicle)	continue;

		StopAudioStreamForPlayer(i);
	}
	return 1;
}

StopHouseBoomBox(houseid)
{
	if (HouseInfo[houseid][hRadioOn] != 1)	return 1;

	HouseInfo[houseid][hRadioOn] = 0;
	foreach(new i : Player)
	{
		if (!IsPlayerLogged(i) || pTemp[i][pBoombox_house] != houseid) continue;

	 	StopAudioStreamForPlayer(i);
		pTemp[i][pBoombox_house] = -1;
	}
	return 1;
}

StopBusinessBoomBox(biz)
{
	if (BizInfo[biz][bizRadioOn] != 1)	return 1;

	BizInfo[biz][bizRadioOn] = 0;

	foreach(new i : Player)
	{
		if (!IsPlayerLogged(i) || pTemp[i][pBoombox_biz] != biz)	continue;

		StopAudioStreamForPlayer(i);
		pTemp[i][pBoombox_biz] = -1;
	}
	return 1;
}