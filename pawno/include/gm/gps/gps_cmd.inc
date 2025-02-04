CMD:gps(playerid, params[])
{
	Dialog_Show(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "GPS > Trang chu", "1. Dia diem chinh\n2. Doanh nghiep\n3. Cong viec\n4. Can ho", "Chon", "Thoat");
	return 1;
}

ALTX:removecp("/rcp");
CMD:removecp(playerid, params[])
{
	SendSyntaxMessage(playerid, "Tat ca cac diem danh dau da duoc xoa khoi ban do.");
	DisableWaypoint(playerid);
	return 1;
}