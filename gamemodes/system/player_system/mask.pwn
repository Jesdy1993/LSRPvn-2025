#include <YSI\y_hooks>
new UseMask[MAX_PLAYERS];
new UseMaskCode[MAX_PLAYERS];
new MaskTimer[MAX_PLAYERS];
CMD:mask(playerid,params[]) {
	if(UseMask[playerid] == 0 ) return SendErrorMessage(playerid, " Ban chua su dung Mat na."); 
    OnPlayerUseMask(playerid);
    return 1;
}
stock OnPlayerUseMask(playerid) {
	if(UseMask[playerid] == 1 ) {
	    new string[128];
        format(string, sizeof(string), "* %s dang deo mat na len.", GetPlayerNameEx(playerid));
        ProxDetectorWrap(playerid, string, 92, 10.0, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
        UseMask[playerid] = 2;
	    UseMaskCode[playerid] = 10000 + random(99999);
	    SendClientMessageEx(playerid, COLOR_LIGHTGREEN, "[MASK-ON] Ban da su dung mat na thanh cong, /mask de thao xuong.");

	    new string_log[229];
        format(string_log, sizeof(string_log), "[%s] %s(%s) đang sử dụng mask với mã code là ***Stranger%d***", GetLogTime(),GetPlayerNameEx(playerid),GetDiscordUser(playerid), UseMaskCode[playerid]);         
        SendLogDiscordMSG(log_mask, string_log);


	    SetPlayerAttachedObject(playerid, 1, 18911, 2, 0.089999,0.012, 	0.002999, -89.5	,7.7,-95.1001,1.054	,1,	1.138); // deo
	    PlayAnimEx(playerid, "KISSING", "GF_StreetArgue_01", 4.0, 1, 1, 1, 1, 1, 1);
	}
	else if(UseMask[playerid] == 2 ) {

	    new string[128];
        format(string, sizeof(string), "* %s dang thao mat na xuong.", GetPlayerNameEx(playerid));
        ProxDetectorWrap(playerid, string, 92, 10.0, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
        UseMask[playerid] = 1;
	    SendClientMessageEx(playerid, COLOR_LIGHTGREEN, "[MASK-OFF] Ban da thao mat na xuong thanh cong, /mask de deo len.");
	    SetPlayerAttachedObject(playerid, 1, 18911, 2, -0.009,0.012,0.002999,-89.5,7.7,-95.1001,1.054,1,1.138); // thao
	    PlayAnimEx(playerid, "KISSING", "GF_StreetArgue_01", 4.0, 1, 1, 1, 1, 1, 1);

	}
	return 1;
}
stock OnUseItemMask(playerid) {
	UseMask[playerid] = 1;
	MaskTimer[playerid] = gettime() +  ( 60 * 15); // 15p
	SendClientMessageEx(playerid, COLOR_LIGHTGREEN, "[MASK-USE] Ban da su dung mat na, su dung /mask de deo len.");
	SetPlayerAttachedObject(playerid, 1, 18911, 2, -0.009,0.012,0.002999,-89.5,7.7,-95.1001,1.054,1,1.138); // thao
	PlayAnimEx(playerid, "KISSING", "GF_StreetArgue_01", 4.0, 1, 1, 1, 1, 1, 1);
}
hook OnPlayerConnect(playerid) {
	UseMask[playerid] = 0;
    UseMaskCode[playerid] = 0;
    MaskTimer[playerid] = 0;
}
hook OnPlayerDisconnect(playerid, reason) {
	UseMask[playerid] = 0;
    UseMaskCode[playerid] = 0;
    MaskTimer[playerid] = 0;
}   // mat
// ITEM MASK USE ( 30p cho 1 mask  , out sẽ mất )
//
/*
SetPlayerAttachedObject(playerid, 1, 18911, 2, 0.089999,0.012, 	0.002999, -89.5	,7.7,-95.1001,1.054	,1,	1.138); // deo
SetPlayerAttachedObject(playerid, 1, 18911, 2, -0.009,0.012,0.002999,-89.5,7.7,-95.1001,1.054,1,1.138); // thao
*/
