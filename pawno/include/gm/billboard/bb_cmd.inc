ALTX:rentbillboard("/rentbb");
CMD:rentbillboard(playerid , params[]) 
{
	if (PlayerInfo[playerid][pInjured] != 0 || GetPVarInt(playerid, "Freeze") || pTemp[playerid][pTaserTime] || pTemp[playerid][pCuffed]) return 1;
	if (!PlayerInfo[playerid][pNumber])				return SendErrorMessage(playerid, "De gui quang cao, ban can co dien thoai.");

    new bizid = -1;
    if ((bizid = Advertisement_Nearest(playerid)) == -1)					return SendErrorMessage(playerid, "Ban khong o mot cong ty quang cao.");
	if (BizInfo[bizid][bizLocked] == 1)									return GameTextForPlayer(playerid, "~r~DONG!", 2500, 1);

	
	new str[128], mes[2048] = "Vi tri\tTen\tTrang thai\n";

	new count;
	for(new i; i < MAX_BILLBOARDS; i++)
	{
		if (BillboardInfo[i][bbRentBy] == PlayerInfo[playerid][pID])
		{
			count++;
		}
	}  
	if (count >= 3)
	{
		return SendErrorMessage(playerid, "Ban da thue so luong bien quang cao toi da! /mybb - de quan ly.");
	} 

	new location[MAX_ZONE_NAME];
	count = 0;

	for(new i; i < MAX_BILLBOARDS; i++) 
	{
		if (!BillboardInfo[i][bbActive]) continue;
		GetZone(BillboardInfo[i][bbPosX],BillboardInfo[i][bbPosY], location, MAX_ZONE_NAME);

		if (!BillboardInfo[i][bbRentDate])
		{
			format(str, sizeof(str), "%s\tBien quang cao #%i\t{16b819}Mien phi{FFFFFF}", location, i+1);
		} 	
		else
		{
			format(str, sizeof(str), "%s\tBien quang cao #%i\t{FF6347}Thue boi %s den %s{FFFFFF}", location, i+1, GetNameFromBD(BillboardInfo[i][bbRentBy]), get_date("%dd.%mm.%yy", BillboardInfo[i][bbRentDate]));
		}								
		format(mes, sizeof(mes), "%s\n%s", mes, str);
		count++;
	}

	if (!count) return SendErrorMessage(playerid, "Khong co bien quang cao tren may chu!");

	Dialog_Show(playerid, BillboardList, DIALOG_STYLE_TABLIST_HEADERS, "Thue bien quang cao", mes, "Thue", "Huy bo");
	return 1;
}

ALTX:mybillboards("/mybb");
CMD:mybillboards(playerid , params[]) 
{
	if (PlayerInfo[playerid][pInjured] != 0 || GetPVarInt(playerid, "Freeze") || pTemp[playerid][pTaserTime] || pTemp[playerid][pCuffed]) return 1;
	if (!PlayerInfo[playerid][pNumber])				return SendErrorMessage(playerid, "Ban can so dien thoai de gui quang cai.");

    new bizid = -1;
    if ((bizid = Advertisement_Nearest(playerid)) == -1)	return SendErrorMessage(playerid, "Ban khong o mot cong ty quang cao.");
	if (BizInfo[bizid][bizLocked] == 1)						return GameTextForPlayer(playerid, "~r~DONG!", 2500, 1);

	new count, str[90], mes[(60+MAX_ZONE_NAME+13)*3+27] = "Vi tri\tTen\tTrang thai\n", location[MAX_ZONE_NAME];
	
	for(new i; i < MAX_BILLBOARDS; i++) {
		if (BillboardInfo[i][bbRentBy] == PlayerInfo[playerid][pID]) 
		{
			GetZone(BillboardInfo[i][bbPosX],BillboardInfo[i][bbPosY], location, MAX_ZONE_NAME);
			format(str, sizeof(str), "%s\tBien quang cao #%i\tThue boi %s{FFFFFF}", location, i+1, get_date("%dd.%mm.%yy", BillboardInfo[i][bbRentDate]));

			format(mes, sizeof(mes), "%s\n%s", mes, str);
			count++;

			if (count == 3) break;
		}
	}

	if (!count) return SendErrorMessage(playerid, "Ban khong thue bien quang cao!");
	
	Dialog_Show(playerid, MyBillboards, DIALOG_STYLE_TABLIST_HEADERS, "Bien quang cao cua ban", mes, "Xoa bo", "Huy bo");
	return 1;
}//�

