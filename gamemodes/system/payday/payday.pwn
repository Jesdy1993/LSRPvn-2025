CMD:payday(playerid) {
	if(IsNearATM(playerid) == -1) return SendErrorMessage(playerid, " Ban khong o gan ATM.");
	if(ATMisRobbed[IsNearATM(playerid)] != 0) return SendErrorMessage(playerid, " Cay ATM khong hoat dong.");
	
	if(PlayerInfo[playerid][pPayDay] == 0) return SendErrorMessage(playerid,"Ban chua den thoi gian nhan paycheck.");
	if(PlayerInfo[playerid][pConnectSeconds] < 3600) return SendErrorMessage(playerid,"Ban chua den thoi gian nhan paycheck.");
	new string[129];
	format(string, sizeof(string), "Vui long nhap ma code: %d", PlayerInfo[playerid][pPayDayCode]);
	Dialog_Show(playerid, DIALOG_PAYDAY, DIALOG_STYLE_INPUT, "Payday", string, "Nhap", "Thoat");
	return 1;
}
Dialog:DIALOG_PAYDAY(playerid, response, listitem, inputtext[]) {
    if (response) {
    	new string[129];
        if(isnull(inputtext)) {
	        format(string, sizeof(string), "{b4b4b4}Vui long nhap ma code: %d", PlayerInfo[playerid][pPayDayCode]);
	        Dialog_Show(playerid, DIALOG_PAYDAY, DIALOG_STYLE_INPUT, "Payday", string, "Nhap", "Thoat");
        	return 1;
        }
        if(strval(inputtext) != PlayerInfo[playerid][pPayDayCode]) {
	        format(string, sizeof(string), "{e74242}Ban da nhap sai ma code\n{b4b4b4}Vui long nhap ma code: %d", PlayerInfo[playerid][pPayDayCode]);
	        Dialog_Show(playerid, DIALOG_PAYDAY, DIALOG_STYLE_INPUT, "Payday", string, "Nhap", "Thoat");
        	return 1;
        }
        if(strval(inputtext) == PlayerInfo[playerid][pPayDayCode]) {
        	PayDay(playerid);
        }
    }
    return 1;
}
CMD:apayday(playerid) {
	if(PlayerInfo[playerid][pAdmin] < 99999) return 1;
	PlayerInfo[playerid][pConnectSeconds] = 3600;
	return 1;
}