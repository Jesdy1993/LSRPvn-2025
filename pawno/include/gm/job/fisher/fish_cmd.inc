CMD:cauca(playerid,params[]) {
	if(PlayerInfo[playerid][pFishRod] == 0) return SendErrorMessage(playerid, "Ban khong the cau ca khi khong co can cau.");
	if(PlayerInfo[playerid][pBait] <= 0) return SendErrorMessage(playerid, "Ban khong the cau ca khi khong co moi.");
    for(new i = 0;i < MAX_POINT_FISH;i++)
    {
        if(IsPlayerInRangeOfPoint(playerid, 3, FishingPoint[i][FishX], FishingPoint[i][FishY], FishingPoint[i][FishZ])) 
        {
            SetPVarInt(playerid, "DangCauCa", 1);
            ApplyAnimation(playerid, "SAMP", "FishingIdle", 3.0,1,1,0,0,0);
            TogglePlayerControllable(playerid, true);
            SetPlayerAttachedObject( playerid, 9, 18632, 1, -0.091109, 0.255484, 0.018155, 94.362060, 312.328125, 190.418655, 1.000000, 1.000000, 1.000000 );
            SetTimerEx("FishingProd", 12000, 0, "d", playerid);
            GameTextForPlayer(playerid, "Dang cau ca...", 12000, 1);

        }
    }
    return 1;
}/*
CMD:muacancau(playerid,params[]) {
    if(IsPlayerInRangeOfPoint(playerid, 3, 376.2630,-2068.4519,7.8359)) 
    {
        
    }
}*/
CMD:tuica(playerid,params[]) {
	new string[500];
	string = "STT\tTen ca\tLoai ca\n";
	for(new i = 0; i <10 ; i++) {
		if(PlayerInfo[playerid][pFish][i] != 0) {
			printf("%d", PlayerInfo[playerid][pFish][i]);
			format(string, sizeof(string), "%s%d\t%s\t%s\n", string,i,FishingStr[PlayerInfo[playerid][pFish][i]][fishname],FishingStr[PlayerInfo[playerid][pFish][i]][fishtype]);
		}
	}
	Dialog_Show(playerid, DIALOG_LISTFISH, DIALOG_STYLE_TABLIST_HEADERS, "Tui ca", string, "Xac nhan", "Thoat");
	return 1;
}