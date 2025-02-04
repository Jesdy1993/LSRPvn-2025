#include <YSI\y_hooks>
new IsVerifyLog[MAX_PLAYERS];
stock TwoTempCheck(playerid) {
	if(PlayerInfo[playerid][pSettingTwo] == 0) {
		Dialog_Show(playerid, DIALOG_SETTING_TWO, DIALOG_STYLE_INPUT, "Two-step identification step", "{cdc3c3}Vui long khoi tao mat khau cap 2 {cdc3c3}( {e54141}Bao mat khong duoc trung khop voi mat khau tai khoan {cdc3c3} ):","Khoi tao mat khau","Thoat");
	}
	else {
		Dialog_Show(playerid, DIALOG_LOGIN_TWO, DIALOG_STYLE_INPUT, "#Twostep Login", "{cdc3c3}Vui long nhap mat khau cap 2 cua ban {cdc3c3}:","Nhap","Thoat");
	} 
	return 1;
}
Dialog:DIALOG_LOGIN_TWO(playerid, response, listitem, inputtext[]) {
	if(response) {
        if(strcmp(PlayerInfo[playerid][pSettingTwoPass], inputtext) != 0)
		{
			if(GetPVarInt(playerid,#JhonSucSinh) == 1) return Kick(playerid);
			SendClientMessage(playerid,COLOR_WHITE2,"[SERVER] Neu nhap sai mat khau lan nua ban se bi kick.");
			SetPVarInt(playerid,#JhonSucSinh,1);

            Dialog_Show(playerid, DIALOG_LOGIN_TWO, DIALOG_STYLE_INPUT, "#Twostep Login", "{cdc3c3}Vui long nhap mat khau cap 2 cua ban {cdc3c3}:","Nhap","Thoat");
            return 1;
        }
        IsVerifyLog[playerid] = 1;
        SendClientMessage(playerid, COLOR_WHITE2, "#LS:RP# Ban da xac minh thanh cong.");
        RegisterDiscord(playerid);
        return 1;
	}
	else {
		Dialog_Show(playerid, DIALOG_SETTING_TWO, DIALOG_STYLE_INPUT, "Two-step identification step", "{cdc3c3}Vui long nhap mat khau cap 2 cua ban {cdc3c3}( {e54141}bao mat tranh trung khop voi mat khau game  !!! {cdc3c3} ):","Nhap","Thoat");
	}
	return 1;
}
Dialog:DIALOG_SETTING_TWO(playerid, response, listitem, inputtext[]) {
	if(response) {
		if(strlen(inputtext) < 6 || strlen(inputtext) > 32) return Dialog_Show(playerid, DIALOG_SETTING_TWO, DIALOG_STYLE_INPUT, "Two-step identification step", "Mat khau phai tu > 6 ky tu tro len {cdc3c3}Vui long nhap mat khau cap 2 cua ban {cdc3c3}( {e54141}bao mat tranh trung khop voi mat khau game  !!! {cdc3c3} ):","Khoi tao mat khau","Thoat");
        strcpy(PlayerInfo[playerid][pSettingTwoPass], inputtext, 32);
        PlayerInfo[playerid][pSettingTwo] = 1;
        SendClientMessage(playerid,COLOR_WHITE2,"[SERVER] Ban da khoi tao thanh cong mat khau cap 2, neu quen mat khau hay lien he Admin.");
        RegisterDiscord(playerid);
	}
	else {
		Dialog_Show(playerid, DIALOG_SETTING_TWO, DIALOG_STYLE_INPUT, "Two-step identification step", "{cdc3c3}Vui long nhap mat khau cap 2 cua ban {cdc3c3}( {e54141}bao mat tranh trung khop voi mat khau game  !!! {cdc3c3} ):","Nhap","Thoat");
	}
	return 1;
}
hook OnPlayerConnect(playerid) {
	IsVerifyLog[playerid] = 0;
	DeletePVar(playerid, #JhonSucSinh);
}