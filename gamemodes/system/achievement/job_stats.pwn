stock ShowPlayerJobStats(playerid) {
	new string[1129];
	string = "#Job\t#Stock\t#\n";
	format(string, sizeof string, "Trucker\t%d\t#\n\
		Pizza\t%d\t#\n\
		Miner\t%d\t#\n\
		Trash\t%d\t#\n\
		Electricity\t%d\t#\n\
		Worker\t%d\t#\n\
		Lumberjack\t%d\t#", 
		string,PlayerInfo[playerid][pCountTruck],
	    PlayerInfo[playerid][pCountPizza],
	    PlayerInfo[playerid][pCountMiner],
	    PlayerInfo[playerid][pCountTrash],
	    PlayerInfo[playerid][pCountElec],
	    PlayerInfo[playerid][pCountWork],
	    PlayerInfo[playerid][pCountWood]);
	ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_TABLIST_HEADERS, "Job Stats", string, "Xac nhan", "Thoat");
	return 1;
}