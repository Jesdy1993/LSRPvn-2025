Dialog:BoomBox(playerid, response, listitem, inputtext[])
{
	if (!response)							return 1;
    if (BoomboxInfo[playerid][bUsed] == 0)	return SendErrorMessage(playerid, "Ban chua su dung boombox cua minh.");
	if (Boombox_Nearest(playerid) == 0)		return SendErrorMessage(playerid, "Ban phai o gan boombox cua minh. "); 
	        
	switch(listitem)
	{
	    case 0:	Dialog_Show(playerid, RadioStations, DIALOG_STYLE_LIST, "{FFFFFF} Chon the loai", "Pop/Dance/Dubstep\nJazz/Country/Rock\nHip-hop/RnB/Reggae\nNhac cua toi", "Chon", "Dong");
	    case 1:	ShowMusicList(playerid);
		case 2:
		{
		    if (strlen(BoomboxInfo[playerid][bUrl]) == 0)	return SendErrorMessage(playerid, "Boombox khong hoat dong.");

			SendSyntaxMessage(playerid,"Ban da tat boombox.");
            BoomboxInfo[playerid][bUrl] = EOS;

            foreach(new i : Player)
            {
	    		if (!IsPlayerLogged(i) || pTemp[i][pBoombox] != playerid) continue;

                StopAudioStreamForPlayer(i);
			}
		}
		case 3:
	    {
			Destroy_Boombox(playerid);
			SendSyntaxMessage(playerid,"Ban da xoa boombox.");
	    }
	}
	return 1;
} //bîîmbox

Dialog:RadioURL(playerid, response, listitem, inputtext[])
{
	if (!response) return 1;
	    
	new radio = GetPVarInt(playerid, #select_radio)-1;

	ChangeUrlBoombox(playerid, RADIO_STATIONS[radio][listitem][boomboxUrl]);
	return 1;
}

Dialog:RadioStations(playerid, response, listitem, inputtext[])
{
	if (!response) return 1;

	if (listitem == 4)
	{
	    new vehicle = GetPlayerVehicleID(playerid), id;

	    if (IsDriver(playerid))
		{
			if (VehicleInfo[vehicle][carRadio] == 0)	return SendErrorMessage(playerid, "Khong co radio trong phuong tien nay.");

			if (VehicleInfo[vehicle][carRadioOn] != 0)
			{
				StopCarBoomBox(vehicle);
				SendSyntaxMessage(playerid, "Ban da tat radio.");
			}
			return 1;
		}

		if ((id = GetNearInsideHouse(playerid)) != -1 && HouseInfo[id][hOwnerID] == PlayerInfo[playerid][pID])
		{
		    if (HouseInfo[id][hRadio] == 0)	return SendErrorMessage(playerid, "Khong co radio trong ngoi nha nay.");

			if (HouseInfo[id][hRadioOn] != 0)
			{
				StopHouseBoomBox(id);
	            SendSyntaxMessage(playerid, "Ban da tat radio.");
			}
		    return 1;
		}
		else if ((id = GetNearInsideBiz(playerid)) != -1 && BizInfo[id][bizOwnerID] == PlayerInfo[playerid][pID])
		{
		    if (BizInfo[id][bizRadio] == 0)	return SendErrorMessage(playerid, "Khong co radio trong doanh nghiep nay.");

			if (BizInfo[id][bizRadioOn] != 0)
			{
			    StopBusinessBoomBox(id);
			    SendSyntaxMessage(playerid, "Ban da tat radio.");
			}
		    return 1;
		}
	    return 1;
	}
	
	if (listitem == 3)	return ShowMusicList(playerid);
	    
	new str[15 * 32];

	for(new i; i != 15; i++)
	{
	    format(str, sizeof(str), "%s %s\n", str, RADIO_STATIONS[listitem][i][boomboxName]);
	}
	
	SetPVarInt(playerid, #select_radio, listitem+1);
    Dialog_Show(playerid, RadioURL, DIALOG_STYLE_LIST, "{FFFFFF}Chon dai phat thanh", str, "Chon", "Dong");
	return 1;
}