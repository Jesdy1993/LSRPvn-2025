ShowProperty(playerid, id)
{
	new count, year, month, day, hour, minute, second;
	
	getdate(year, month, day);
	gettime(hour, minute, second);
	
    SendClientMessageEx(playerid, COLOR_GREEN,"|____________________Tai san %s [%02d %s %i, %02d:%02d:%02d]____________________|", GetName(id), day, GetMonthName(month), year, hour, minute, second); //���������
    
	for(new i; i != MAX_HOUSES; i++)
	{
	    if (HouseInfo[i][hID] == 0 || HouseInfo[i][hOwnerID] != PlayerInfo[id][pID])				continue;

        if (HouseInfo[i][hPosInt] == 0)												SendClientMessageEx(playerid, COLOR_STATS1, "| Ngoi Nha [ID: %i] | Dia chi: %s", i, (!HouseInfo[i][hApart])?(GetHouseZone(i)):(GetApartmentZone(HouseInfo[i][hApart])));
		else																		SendClientMessageEx(playerid, COLOR_STATS1, "| Ngoi Nha [ID: %i]", i);
        
		count++;
	}
	
	for(new i; i != MAX_BIZ; i++)
	{
	    if (BizInfo[i][bizID] == 0 || BizInfo[i][bizOwnerID] != PlayerInfo[id][pID])				continue;

        SendClientMessageEx(playerid, COLOR_STATS1, "| Doanh Nghiep [ID: %i]", i);

        count++;
	}
	
	for(new i; i != MAX_GARAGES; i++)
	{
	    if (GarageInfo[i][garageID] == 0 || GarageInfo[i][garageOwner] != PlayerInfo[id][pID])	continue;

        SendClientMessageEx(playerid, COLOR_STATS1, "| Nha de xe [ID: %i]", i);

        count++;
	}
	
	if (count == 0 && playerid == id)	SendErrorMessage(playerid, "Ban khong so huu bat cu thu gi.");
    if (count == 0 && playerid != id)	SendSyntaxMessage(playerid, "Nguoi choi khong so huu gi.");
    	
	return 1;
}

stock CreateLableText(playerid,lable[],text[])
{
    //if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return 1;
	if (GetPVarInt(playerid, #LableText) > 0)
	{
		TextDrawSetString(LableDraw[playerid], lable);
		TextDrawSetString(UsedDraw[playerid], text);
		return 1;
	}

	//PlayerPlaySound(playerid,1054, 0.0, 0.0, 0.0);

	LableDraw[playerid] = TextDrawCreate(317.916839, 356.962829, "~h~~p~NHA BAN!~n~~w~GIA: ~g~$21000");
	TextDrawLetterSize(LableDraw[playerid], 0.202913, 0.982963);
	TextDrawTextSize(LableDraw[playerid], 0.000000, 109.000000);
	TextDrawAlignment(LableDraw[playerid], 2);
	TextDrawColor(LableDraw[playerid], -1);
	TextDrawUseBox(LableDraw[playerid], 1);
	TextDrawBoxColor(LableDraw[playerid], 119);
	TextDrawBackgroundColor(LableDraw[playerid], 255);
	TextDrawFont(LableDraw[playerid], 1);
	TextDrawSetProportional(LableDraw[playerid], 1);
	TextDrawSetString(Text:LableDraw[playerid],lable);

	UsedDraw[playerid] = TextDrawCreate(317.950744, 378.350830, "");
	TextDrawLetterSize(UsedDraw[playerid], 0.161247, 0.879257);
	TextDrawTextSize(UsedDraw[playerid], 0.000000, 109.000000);
	TextDrawAlignment(UsedDraw[playerid], 2);
	TextDrawColor(UsedDraw[playerid], -1);
	TextDrawUseBox(UsedDraw[playerid], 1);
	TextDrawBoxColor(UsedDraw[playerid], 119);
	TextDrawBackgroundColor(UsedDraw[playerid], 255);
	TextDrawFont(UsedDraw[playerid], 1);
	TextDrawSetProportional(UsedDraw[playerid], 1);
	TextDrawSetString(Text:UsedDraw[playerid],text);

	TDEditor_TD[playerid] = TextDrawCreate(271.899353, 375.999542, "LD_CHAT:badchat");
	TextDrawLetterSize(TDEditor_TD[playerid], 0.000000, 0.000000);
	TextDrawTextSize(TDEditor_TD[playerid], -12.000000, 13.000000);
	TextDrawAlignment(TDEditor_TD[playerid], 1);
	TextDrawColor(TDEditor_TD[playerid], -1);
	TextDrawBackgroundColor(TDEditor_TD[playerid], 255);
	TextDrawFont(TDEditor_TD[playerid], 4);

	TextDrawSetString(LableDraw[playerid], lable);
	TextDrawSetString(UsedDraw[playerid], text);

	TextDrawShowForPlayer(playerid,UsedDraw[playerid]);
    TextDrawShowForPlayer(playerid,LableDraw[playerid]);
	TextDrawShowForPlayer(playerid,TDEditor_TD[playerid]);

	SetPVarInt(playerid, #LableText, 4);
    return 1;
}
