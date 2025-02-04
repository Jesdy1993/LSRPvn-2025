CMD:corpse(playerid, params[])
{
    new i;

    if (PlayerInfo[playerid][pInjured] != 0 || GetPVarInt(playerid, "Freeze") || pTemp[playerid][pTaserTime] || pTemp[playerid][pCuffed] || PhoneInfo[playerid][current_page] == PAGE_NOTIFICATION || PlayerInfo[playerid][pJailed] != 0)
		return SendErrorMessage(playerid, "Ban khong the su dung tinh nang nay ngay bay gio.");
    if (!IsPlayerLogged(playerid))                   return SendNotConnected(playerid);
    if ((i = GetNearestCorpse(playerid)) == -1)      return SendErrorMessage(playerid, "Khong co xac chet nao gan ban");
  
    Dialog_Show(playerid, CorpseInfo, DIALOG_STYLE_MSGBOX, "Thong tin ve mot thi the khong xac dinh", CorpInfo[i][cNote], "Tuy chon", "Dong");
    return 1;
}