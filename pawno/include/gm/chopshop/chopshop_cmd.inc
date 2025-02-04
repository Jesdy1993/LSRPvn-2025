CMD:chopshop(playerid, params[])
{
    if (!IsAdminDuty(playerid) && !CheckAdmin(playerid, ADMIN_LEVEL_3) && !isLeader(playerid))
        return SendErrorMessage(playerid, "Ban khong the su dung lenh nay.");
    if (!IsAdminDuty(playerid) && !CheckAdmin(playerid, ADMIN_LEVEL_3) && Factions[PlayerInfo[playerid][pFaction]][fType] != FACTION_GANG && Factions[PlayerInfo[playerid][pFaction]][fType] != FACTION_MAFIA)
        return SendErrorMessage(playerid, "Ban khong the su dung lenh nay.");

    if (GetChopshopID(playerid) != -1)
    {
        Dialog_Show(playerid, DIALOG_CHOPSHOP, DIALOG_STYLE_LIST, "Chopshop", "Xoa Chopshop\nCap nhat danh sach phuong tien\nThong ke Chopshop\nThay doi ty le phan tram\nChinh sua vi tri Chopshop", "Chon", "<<");
    }
    else if (IsAdminDuty(playerid) && CheckAdmin(playerid, ADMIN_LEVEL_2) || !IsFactionHasChopShop(PlayerInfo[playerid][pFaction])) {
            Dialog_Show(playerid, DIALOG_CHOPSHOP, DIALOG_STYLE_LIST, "Chopshop", "Tao Chopshop", "Chon", "<<");
    }
           
    return 1;
} //î