#include <YSI\y_hooks>

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
	if(newkeys & KEY_YES) {
		if(IsPlayerInRangeOfPoint(playerid,5,2309.8376,-11.0095,26.7422)) {
			cmd_bank(playerid,"");
		}
	}
}
hook OnGameModeInit() {
	CreateDynamic3DTextLabel("< BANK >\nBam 'Y' de tuong tac", COLOR_BASIC, 2309.8376,-11.0095,26.7422, 5.0);
}