#include <YSI\y_hooks>
hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
	if(newkeys & KEY_YES) {
		if(IsPlayerInRangeOfPoint(playerid, 3.0, 2137.0449,-1740.5898,13.5635)) {
			Dialog_Show(playerid, BUY_THE_COFFEE_HOUSE, DIALOG_STYLE_MSGBOX,"PURCHASE - CONFIRM", "Ban co xac nhan mua 1 lon nuoc Ca phe sua - The Coffee House voi gia $50 khong?", "Dong y", "Thoat");
		}
		if(IsPlayerInRangeOfPoint(playerid, 3.0, 2126.4534,-1735.3226,13.6035)) {
			Dialog_Show(playerid, BUY_HIGHLANDS, DIALOG_STYLE_MSGBOX,"PURCHASE - CONFIRM", "Ban co xac nhan mua 1 lon nuoc Ca phe sua - Highlands Coffee voi gia $55 khong?", "Dong y", "Thoat");
		}
	}
}
hook OnGameModeInit() {
	CreateDynamic3DTextLabel("Bam {58a7e3}Y{b4b4b4} de mua nuoc", COLOR_BASIC, 2137.0449,-1740.5898,13.5635-0.5,10.0);
	CreateDynamic3DTextLabel("Bam {58a7e3}Y{b4b4b4} de mua nuoc", COLOR_BASIC, 2126.4534,-1735.3226,13.6035-0.5,10.0);
}
Dialog:BUY_THE_COFFEE_HOUSE(playerid, response, listitem, inputtext[]) {
    if (response) {
    	if(PlayerInfo[playerid][pCash] < 50) return SendErrorMessage(playerid,"Ban khong du tien de mua vat pham.");
    	if(CheckInventorySlotEmpty(playerid,13,1) == -1) return SendErrorMessage(playerid,"Tui do cua ban da day khong the mua vat pham.");
    	Inventory_@Add(playerid,13,1);
    	GivePlayerMoneyEx(playerid,-50);
    	SendClientMessage(playerid,COLOR_BASIC,"[SHOP] Ban da mua thanh cong mot {58a7e3}lon nuoc{b4b4b4} voi gia {55d45e}$50");
    }
    return 1;
}
Dialog:BUY_HIGHLANDS(playerid, response, listitem, inputtext[]) {
    if (response) {
    	if(PlayerInfo[playerid][pCash] < 55) return SendErrorMessage(playerid,"Ban khong du tien de mua vat pham.");
    	if(CheckInventorySlotEmpty(playerid,14,1)== -1 ) return SendErrorMessage(playerid,"Tui do cua ban da day khong the mua vat pham.");
    	Inventory_@Add(playerid,14,1);
    	GivePlayerMoneyEx(playerid,-55);
    	SendClientMessage(playerid,COLOR_BASIC,"[SHOP] Ban da mua thanh cong mot {58a7e3}lon nuoc{b4b4b4} voi gia {55d45e}$55");
    }
    return 1;
}