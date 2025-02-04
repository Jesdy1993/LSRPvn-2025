Interior_OnGameModeInit()
{
	buy_interior = CreateMenu("_", 1, 20.0, 160.0, 80.0);
	AddMenuItem(buy_interior, 0, "> TIEP");
	AddMenuItem(buy_interior, 0, "> SAU");
	AddMenuItem(buy_interior, 0, "> CHON");
	AddMenuItem(buy_interior, 0, "> THOAT");
	return 1;
}