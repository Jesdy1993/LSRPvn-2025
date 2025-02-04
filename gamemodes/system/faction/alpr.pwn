

#include <YSI\y_hooks>


new player_alpr[MAX_PLAYERS];
new player_alprlitmit[MAX_PLAYERS];
new Timer:ALPR_update[MAX_PLAYERS];
new Timer:ALPR_notice[MAX_PLAYERS];
new PlayerText:aplr_PTD[MAX_PLAYERS][10];
hook OnPlayerConnect(playerid)
{
	stop ALPR_notice[playerid];
	LoadALPRTD(playerid);
	stop ALPR_update[playerid];
	player_alpr[playerid] = 0;
	return 1;
}

hook OnPlayerDisconnect(playerid)
{
	stop ALPR_notice[playerid];
	stop ALPR_update[playerid];
	player_alpr[playerid] = 0;
	return 1;
}
CMD:alprset(playerid, params[])
{
	if(!IsACop(playerid)) return SendErrorMessage(playerid, " Ban khong phai PD");
	if(player_alpr[playerid] == 0) return SendErrorMessage(playerid, " Vui long bat ALPR len [/alpr]");
    new string[128], value;
    if(sscanf(params, "d", value)) return SendUsageMessage(playerid," /alprset [speed limit]");
    player_alprlitmit[playerid] = value;
    format(string, sizeof(string), "Da chinh sua toc do gioi han thanh: %d", value);
    SendClientMessageEx(playerid, COLOR_BASIC, string);
    return 1;
}
CMD:alpr(playerid, params[])
{
	if(!IsACop(playerid)) return SendErrorMessage(playerid, " Ban khong phai PD");
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER || GetPlayerState(playerid) == PLAYER_STATE_PASSENGER)
	{
		if(player_alpr[playerid] == 0)
		{
			LoadALPRTD(playerid);
			ALPR_update[playerid] = repeat ALPRUpdate[1000](playerid); 
			player_alpr[playerid] = 1;
			ShowPlayerALPR(playerid);
			PlayerTextDrawHide(playerid, aplr_PTD[playerid][9]);
	        DeletePVar(playerid,#ALPR_Show);
		}
		else
		{
			stop ALPR_update[playerid];
			HidePlayerALPR(playerid);
			player_alpr[playerid] = 0;

		}
	}
	else
	{
		SendErrorMessage(playerid, " Ban khong o tren mot phuong tien");
	}
	return 1;
}
timer ALPRHide[3000](playerid)
{
	PlayerTextDrawHide(playerid, aplr_PTD[playerid][9]);
	DeletePVar(playerid,#ALPR_Show);
}
timer ALPRUpdate[1000](playerid)
{
	new target = -1;

	foreach(new p : Player)
    {
        new Float:tempDist = 40.0;
        new Float:distance = GetDistanceBetweenPlayers(playerid, p);
        new str[129],zone[32],plate[32];
        format(str, sizeof str, "LIMIT:_~G~%d", player_alprlitmit[playerid]);
        PlayerTextDrawSetString(playerid, aplr_PTD[playerid][7], str);
        ShowPlayerALPR(playerid);
        if (!IsPlayerInAnyVehicle(playerid)) {
        stop ALPR_update[playerid];
			HidePlayerALPR(playerid);
			player_alpr[playerid] = 0;
        	return 1;
        }
    
        if (distance < tempDist && p != playerid && GetPlayerState(p) == PLAYER_STATE_DRIVER)
        {
            target = p;
            tempDist = distance;
        }
        
        if(target == -1) {
        	PlayerTextDrawSetString(playerid, aplr_PTD[playerid][2], "Vi_tri:_~y~N/A");
        	PlayerTextDrawSetString(playerid, aplr_PTD[playerid][3], "Doi_tuong:_~r~N/A");
        	PlayerTextDrawSetString(playerid, aplr_PTD[playerid][4], "Phuong_tien:_~y'~N/A");
        	PlayerTextDrawSetString(playerid, aplr_PTD[playerid][5], "Bien_kiem_soat:_~g~N/A");
        	PlayerTextDrawSetString(playerid, aplr_PTD[playerid][6], "Toc_do_hien_tai:_~b~N/A");
        	format(str, sizeof str, "LIMIT:_~G~%d", player_alprlitmit[playerid]);
        	PlayerTextDrawSetString(playerid, aplr_PTD[playerid][7], str);
        	PlayerTextDrawSetString(playerid, aplr_PTD[playerid][8], "TARGET:_~r~N/A");
        }
        else if(target != -1) {
        	
        	GetPlayer3DZone(playerid,zone,sizeof(zone));
        	format(str, sizeof str, "Vi_tri:_~y~%s", zone);
        	PlayerTextDrawSetString(playerid, aplr_PTD[playerid][2], str);
        	format(str, sizeof str, "Doi_tuong:_~r~%s", GetPlayerNameEx(target));
        	PlayerTextDrawSetString(playerid, aplr_PTD[playerid][3], str);
        	format(str, sizeof str, "Phuong_tien:_~y'~%s", VehicleName[GetVehicleModel(GetPlayerVehicleID(target)) - 400]);
        	PlayerTextDrawSetString(playerid, aplr_PTD[playerid][4], str);
            plate = "Khong xac dinh";
        	format(str, sizeof str, "Bien_kiem_soat:_~g~", plate);
        	PlayerTextDrawSetString(playerid, aplr_PTD[playerid][5], str);     
        	format(str, sizeof str, "Khoang cach:_~b~%.1f met", distance);
        	PlayerTextDrawSetString(playerid, aplr_PTD[playerid][6], str);
        	format(str, sizeof str, "LIMIT:_~G~%d", player_alprlitmit[playerid]);
        	PlayerTextDrawSetString(playerid, aplr_PTD[playerid][7], str);
        	format(str, sizeof str, "TARGET:_~R~%d", GetVehicleSpeed(GetPlayerVehicleID(target)));
        	PlayerTextDrawSetString(playerid, aplr_PTD[playerid][8], str);
        }
        if(GetVehicleSpeed(GetPlayerVehicleID(target)) > player_alprlitmit[playerid] && GetPVarInt(playerid,#ALPR_Show) != 1) {
        	stop ALPR_notice[playerid];
        	PlayerTextDrawHide(playerid,aplr_PTD[playerid][9]);
        	format(str, sizeof str, "~r~%s~w~_chay_qua_toc_do_(~r~%d_km/h~w~/~g~%dkm/h~w~)", GetPlayerNameEx(target),GetVehicleSpeed(GetPlayerVehicleID(target)),player_alprlitmit[playerid]);
        	PlayerTextDrawSetString(playerid, aplr_PTD[playerid][9], str);     
        	PlayerTextDrawShow(playerid, aplr_PTD[playerid][9]);
        	ALPR_notice[playerid] = defer ALPRHide[5000](playerid); 
        	SetPVarInt(playerid,#ALPR_Show,1);
        }
        ShowPlayerALPR(playerid);
    }
	return 1;
}
stock ShowPlayerALPR(playerid)
{
	for(new i = 0; i < 10; i ++) PlayerTextDrawShow(playerid, aplr_PTD[playerid][i]);
	return 1;
}
stock HidePlayerALPR(playerid)
{
	for(new i = 0; i < 10; i ++) PlayerTextDrawHide(playerid, aplr_PTD[playerid][i]);

	return 1;
}
stock LoadALPRTD(playerid) {

aplr_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 541.5164, 347.8294, "Box"); // ïóñòî
PlayerTextDrawLetterSize(playerid, aplr_PTD[playerid][0], 0.0000, 7.0416);
PlayerTextDrawTextSize(playerid, aplr_PTD[playerid][0], 635.0000, 0.0000);
PlayerTextDrawAlignment(playerid, aplr_PTD[playerid][0], 1);
PlayerTextDrawColor(playerid, aplr_PTD[playerid][0], -1);
PlayerTextDrawUseBox(playerid, aplr_PTD[playerid][0], 1);
PlayerTextDrawBoxColor(playerid, aplr_PTD[playerid][0], 160);
PlayerTextDrawBackgroundColor(playerid, aplr_PTD[playerid][0], 255);
PlayerTextDrawFont(playerid, aplr_PTD[playerid][0], 1);
PlayerTextDrawSetProportional(playerid, aplr_PTD[playerid][0], 1);
PlayerTextDrawSetShadow(playerid, aplr_PTD[playerid][0], 0);

aplr_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 537.9167, 337.2854, "Aplr"); // ïóñòî
PlayerTextDrawLetterSize(playerid, aplr_PTD[playerid][1], 0.3791, 1.7970);
PlayerTextDrawAlignment(playerid, aplr_PTD[playerid][1], 1);
PlayerTextDrawColor(playerid, aplr_PTD[playerid][1], -1061109249);
PlayerTextDrawBackgroundColor(playerid, aplr_PTD[playerid][1], 255);
PlayerTextDrawFont(playerid, aplr_PTD[playerid][1], 3);
PlayerTextDrawSetProportional(playerid, aplr_PTD[playerid][1], 1);
PlayerTextDrawSetShadow(playerid, aplr_PTD[playerid][1], 0);

aplr_PTD[playerid][2] = CreatePlayerTextDraw(playerid, 541.7002, 353.6560, "Vi_tri:_~y~N/A"); // ïóñòî
PlayerTextDrawLetterSize(playerid, aplr_PTD[playerid][2], 0.1787, 1.3199);
PlayerTextDrawTextSize(playerid, aplr_PTD[playerid][2], 636.0000, 0.0000);
PlayerTextDrawAlignment(playerid, aplr_PTD[playerid][2], 1);
PlayerTextDrawColor(playerid, aplr_PTD[playerid][2], -1061109505);
PlayerTextDrawBackgroundColor(playerid, aplr_PTD[playerid][2], 255);
PlayerTextDrawFont(playerid, aplr_PTD[playerid][2], 1);
PlayerTextDrawSetProportional(playerid, aplr_PTD[playerid][2], 1);
PlayerTextDrawSetShadow(playerid, aplr_PTD[playerid][2], 0);

aplr_PTD[playerid][3] = CreatePlayerTextDraw(playerid, 541.9666, 364.3045, "Doi_tuong:_~r~N/A"); // ïóñòî
PlayerTextDrawLetterSize(playerid, aplr_PTD[playerid][3], 0.1787, 1.3199);
PlayerTextDrawTextSize(playerid, aplr_PTD[playerid][3], 631.0000, 0.0000);
PlayerTextDrawAlignment(playerid, aplr_PTD[playerid][3], 1);
PlayerTextDrawColor(playerid, aplr_PTD[playerid][3], -1061109505);
PlayerTextDrawBackgroundColor(playerid, aplr_PTD[playerid][3], 255);
PlayerTextDrawFont(playerid, aplr_PTD[playerid][3], 1);
PlayerTextDrawSetProportional(playerid, aplr_PTD[playerid][3], 1);
PlayerTextDrawSetShadow(playerid, aplr_PTD[playerid][3], 0);

aplr_PTD[playerid][4] = CreatePlayerTextDraw(playerid, 541.7833, 375.6758, "Phuong_tien:_~y'~N/A"); // ïóñòî
PlayerTextDrawLetterSize(playerid, aplr_PTD[playerid][4], 0.1787, 1.3199);
PlayerTextDrawTextSize(playerid, aplr_PTD[playerid][4], 631.0000, 0.0000);
PlayerTextDrawAlignment(playerid, aplr_PTD[playerid][4], 1);
PlayerTextDrawColor(playerid, aplr_PTD[playerid][4], -1061109505);
PlayerTextDrawBackgroundColor(playerid, aplr_PTD[playerid][4], 255);
PlayerTextDrawFont(playerid, aplr_PTD[playerid][4], 1);
PlayerTextDrawSetProportional(playerid, aplr_PTD[playerid][4], 1);
PlayerTextDrawSetShadow(playerid, aplr_PTD[playerid][4], 0);

aplr_PTD[playerid][5] = CreatePlayerTextDraw(playerid, 541.7664, 387.1026, "Bien_kiem_soat:_~g~N/A"); // ïóñòî
PlayerTextDrawLetterSize(playerid, aplr_PTD[playerid][5], 0.1787, 1.3199);
PlayerTextDrawTextSize(playerid, aplr_PTD[playerid][5], 631.0000, 0.0000);
PlayerTextDrawAlignment(playerid, aplr_PTD[playerid][5], 1);
PlayerTextDrawColor(playerid, aplr_PTD[playerid][5], -1061109505);
PlayerTextDrawBackgroundColor(playerid, aplr_PTD[playerid][5], 255);
PlayerTextDrawFont(playerid, aplr_PTD[playerid][5], 1);
PlayerTextDrawSetProportional(playerid, aplr_PTD[playerid][5], 1);
PlayerTextDrawSetShadow(playerid, aplr_PTD[playerid][5], 0);

aplr_PTD[playerid][6] = CreatePlayerTextDraw(playerid, 541.7664, 398.6033, "Toc_do_hien_tai:_~b~N/A"); // ïóñòî
PlayerTextDrawLetterSize(playerid, aplr_PTD[playerid][6], 0.1787, 1.3199);
PlayerTextDrawTextSize(playerid, aplr_PTD[playerid][6], 631.0000, 0.0000);
PlayerTextDrawAlignment(playerid, aplr_PTD[playerid][6], 1);
PlayerTextDrawColor(playerid, aplr_PTD[playerid][6], -1061109505);
PlayerTextDrawBackgroundColor(playerid, aplr_PTD[playerid][6], 255);
PlayerTextDrawFont(playerid, aplr_PTD[playerid][6], 1);
PlayerTextDrawSetProportional(playerid, aplr_PTD[playerid][6], 1);
PlayerTextDrawSetShadow(playerid, aplr_PTD[playerid][6], 0);

aplr_PTD[playerid][7] = CreatePlayerTextDraw(playerid, 487.0832, 354.3703, "LIMIT:_~G~N/A"); // ïóñòî
PlayerTextDrawLetterSize(playerid, aplr_PTD[playerid][7], 0.4000, 1.6000);
PlayerTextDrawTextSize(playerid, aplr_PTD[playerid][7], 0.0000, 101.0000);
PlayerTextDrawAlignment(playerid, aplr_PTD[playerid][7], 2);
PlayerTextDrawColor(playerid, aplr_PTD[playerid][7], -1);
PlayerTextDrawUseBox(playerid, aplr_PTD[playerid][7], 1);
PlayerTextDrawBoxColor(playerid, aplr_PTD[playerid][7], 153);
PlayerTextDrawBackgroundColor(playerid, aplr_PTD[playerid][7], 255);
PlayerTextDrawFont(playerid, aplr_PTD[playerid][7], 3);
PlayerTextDrawSetProportional(playerid, aplr_PTD[playerid][7], 1);
PlayerTextDrawSetShadow(playerid, aplr_PTD[playerid][7], 0);

aplr_PTD[playerid][8] = CreatePlayerTextDraw(playerid, 487.0832, 372.7715, "TARGET:_~r~N/A"); // ïóñòî
PlayerTextDrawLetterSize(playerid, aplr_PTD[playerid][8], 0.4000, 1.6000);
PlayerTextDrawTextSize(playerid, aplr_PTD[playerid][8], 0.0000, 101.0000);
PlayerTextDrawAlignment(playerid, aplr_PTD[playerid][8], 2);
PlayerTextDrawColor(playerid, aplr_PTD[playerid][8], -1);
PlayerTextDrawUseBox(playerid, aplr_PTD[playerid][8], 1);
PlayerTextDrawBoxColor(playerid, aplr_PTD[playerid][8], 153);
PlayerTextDrawBackgroundColor(playerid, aplr_PTD[playerid][8], 255);
PlayerTextDrawFont(playerid, aplr_PTD[playerid][8], 3);
PlayerTextDrawSetProportional(playerid, aplr_PTD[playerid][8], 1);
PlayerTextDrawSetShadow(playerid, aplr_PTD[playerid][8], 0);

aplr_PTD[playerid][9] = CreatePlayerTextDraw(playerid, 529.5830, 324.8150, "~r~Cuozg~w~_chay_qua_toc_do_(120_km/h_~r~/~w~_60km/h)"); // ïóñòî
PlayerTextDrawLetterSize(playerid, aplr_PTD[playerid][9], 0.1791, 1.1955);
PlayerTextDrawTextSize(playerid, aplr_PTD[playerid][9], 0.0000, 207.0000);
PlayerTextDrawAlignment(playerid, aplr_PTD[playerid][9], 2);
PlayerTextDrawColor(playerid, aplr_PTD[playerid][9], -1);
PlayerTextDrawUseBox(playerid, aplr_PTD[playerid][9], 1);
PlayerTextDrawBoxColor(playerid, aplr_PTD[playerid][9], 191);
PlayerTextDrawBackgroundColor(playerid, aplr_PTD[playerid][9], 255);
PlayerTextDrawFont(playerid, aplr_PTD[playerid][9], 1);
PlayerTextDrawSetProportional(playerid, aplr_PTD[playerid][9], 1);
PlayerTextDrawSetShadow(playerid, aplr_PTD[playerid][9], 0);


// Ýêñïîðòèðîâàíî 18 òåêñòäðàâîâ	
}