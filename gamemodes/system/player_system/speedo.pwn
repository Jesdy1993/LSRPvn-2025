// Òåêñòäðàâû äëÿ èãðîêîâ
#include <YSI\y_hooks>
new PlayerText:Speedo_@TD[MAX_PLAYERS][7],PlayerText:Server@Logo[MAX_PLAYERS][2];






CMD:speedo(playerid, params[])
{
	if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER && GetPlayerState(playerid) != PLAYER_STATE_PASSENGER )
	{
		SendClientMessageEx(playerid, COLOR_GREY, "Ban khong o tren xe.");
	}
	else if (!PlayerInfo[playerid][pSpeedo])
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "Ban da tat dong ho toc do.");
		PlayerInfo[playerid][pSpeedo] = 1;
		UpdateSpeedo(playerid);
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "Ban da bat hoa dong ho toc do.");
		PlayerInfo[playerid][pSpeedo] = 0;
		HideSpeedo(playerid);
	}
	return 1;
}
hook OnPlayerUpdate(playerid) {
	if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		if(PlayerInfo[playerid][pSpeedo] == 0 )
		{
		    UpdateSpeedo(playerid);
		}
	}
	else {

		HideSpeedo(playerid);
	}
}

stock UpdateSpeedo(playerid) {
	// max 623.0000
    // min 540.6376  (y < 10) ? 30 : 40;
    
    new Float:Speedo_metter,str[20];
    format(str, sizeof str, "%d KM/H", GetVehicleSpeed(GetPlayerVehicleID(playerid)));
    PlayerTextDrawSetString(playerid, Speedo_@TD[playerid][2] , str);
    Speedo_metter = ( player_get_speed(playerid) / 90 ) * 100;
	PlayerTextDrawTextSize(playerid, Speedo_@TD[playerid][1], 540.6376 + ( 0.83 * Speedo_metter), 0.0000); // min 540.6376
    
    new Float:Fuel_str,Light_str[50],fuel_text[30];
    Fuel_str = VehicleFuel[GetPlayerVehicleID(playerid)] ;
    if(Fuel_str >= 100) Fuel_str = 100.0;
    PlayerTextDrawTextSize(playerid,  Speedo_@TD[playerid][4], 541.0000 + ( 0.46 * Fuel_str), 0.0000); // min 540.6376
    new engine, lights, alarm, doors, bonnet, boot, objective;
    if(IsPlayerInAnyVehicle(playerid)) GetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet, boot, objective);
    format(Light_str, sizeof Light_str, "Light:%s", (lights == 1) ? "~g~ ON" : " ~r~ OFF");
    format(fuel_text, sizeof fuel_text, "Fuel:%.1f", VehicleFuel[GetPlayerVehicleID(playerid)]);
    PlayerTextDrawSetString(playerid,Speedo_@TD[playerid][6],Light_str);
    PlayerTextDrawSetString(playerid,Speedo_@TD[playerid][5],fuel_text);
    PlayerTextDrawShow(playerid, Speedo_@TD[playerid][0]);
    PlayerTextDrawShow(playerid, Speedo_@TD[playerid][1]);
    PlayerTextDrawShow(playerid, Speedo_@TD[playerid][2]);
    PlayerTextDrawShow(playerid, Speedo_@TD[playerid][3]);
    PlayerTextDrawShow(playerid, Speedo_@TD[playerid][4]);
    PlayerTextDrawShow(playerid, Speedo_@TD[playerid][5]);
    PlayerTextDrawShow(playerid, Speedo_@TD[playerid][6]);
}
stock HideSpeedo(playerid) {
	PlayerTextDrawHide(playerid, Speedo_@TD[playerid][0]);
    PlayerTextDrawHide(playerid, Speedo_@TD[playerid][1]);
    PlayerTextDrawHide(playerid, Speedo_@TD[playerid][2]);
    PlayerTextDrawHide(playerid, Speedo_@TD[playerid][3]);
    PlayerTextDrawHide(playerid, Speedo_@TD[playerid][4]);
    PlayerTextDrawHide(playerid, Speedo_@TD[playerid][5]);
    PlayerTextDrawHide(playerid, Speedo_@TD[playerid][6]);
}
hook OnPlayerConnect(playerid) {

	Speedo_@TD[playerid][0] = CreatePlayerTextDraw(playerid, 542.7998, 433.9667, "Box"); // ïóñòî
    PlayerTextDrawLetterSize(playerid, Speedo_@TD[playerid][0], 0.0000, 0.8748);
    PlayerTextDrawTextSize(playerid, Speedo_@TD[playerid][0], 623.0000, 0.0000); // max 623.0000
    PlayerTextDrawAlignment(playerid, Speedo_@TD[playerid][0], 1);
    PlayerTextDrawColor(playerid, Speedo_@TD[playerid][0], -16776961);
    PlayerTextDrawUseBox(playerid, Speedo_@TD[playerid][0], 1);
    PlayerTextDrawBoxColor(playerid, Speedo_@TD[playerid][0], 640034559);
    PlayerTextDrawBackgroundColor(playerid, Speedo_@TD[playerid][0], 255);
    PlayerTextDrawFont(playerid, Speedo_@TD[playerid][0], 1);
    PlayerTextDrawSetProportional(playerid, Speedo_@TD[playerid][0], 1);
    PlayerTextDrawSetShadow(playerid, Speedo_@TD[playerid][0], 0);


    Speedo_@TD[playerid][1] = CreatePlayerTextDraw(playerid, 542.7998, 433.9667, "Box"); // ïóñòî
    PlayerTextDrawLetterSize(playerid, Speedo_@TD[playerid][1], 0.0000, 0.8708);
    PlayerTextDrawTextSize(playerid, Speedo_@TD[playerid][1], 540.6376, 0.0000); // min 540.6376
    PlayerTextDrawAlignment(playerid, Speedo_@TD[playerid][1], 1);
    PlayerTextDrawColor(playerid, Speedo_@TD[playerid][1], -1);
    PlayerTextDrawUseBox(playerid, Speedo_@TD[playerid][1], 1);
    PlayerTextDrawBoxColor(playerid, Speedo_@TD[playerid][1], 87653119);
    PlayerTextDrawBackgroundColor(playerid, Speedo_@TD[playerid][1], 255);
    PlayerTextDrawFont(playerid, Speedo_@TD[playerid][1], 1);
    PlayerTextDrawSetProportional(playerid, Speedo_@TD[playerid][1], 1);
    PlayerTextDrawSetShadow(playerid, Speedo_@TD[playerid][1], 0);
    
    Speedo_@TD[playerid][2] = CreatePlayerTextDraw(playerid, 581.6182, 434.2851, "200KM/H"); // ïóñòî
    PlayerTextDrawLetterSize(playerid, Speedo_@TD[playerid][2], 0.1350, 0.7651);
    PlayerTextDrawAlignment(playerid, Speedo_@TD[playerid][2], 2);
    PlayerTextDrawColor(playerid, Speedo_@TD[playerid][2], -1);
    PlayerTextDrawBackgroundColor(playerid, Speedo_@TD[playerid][2], 255);
    PlayerTextDrawFont(playerid, Speedo_@TD[playerid][2], 1);
    PlayerTextDrawSetProportional(playerid, Speedo_@TD[playerid][2], 1);
    PlayerTextDrawSetShadow(playerid, Speedo_@TD[playerid][2], 0);
    PlayerTextDrawSetSelectable(playerid, Speedo_@TD[playerid][2], true);


    Speedo_@TD[playerid][3] = CreatePlayerTextDraw(playerid, 542.8999, 421.7659, "Box"); // ïóñòî
    PlayerTextDrawLetterSize(playerid, Speedo_@TD[playerid][3], 0.0000, 0.8331);
    PlayerTextDrawTextSize(playerid, Speedo_@TD[playerid][3], 587.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, Speedo_@TD[playerid][3], 1);
    PlayerTextDrawColor(playerid, Speedo_@TD[playerid][3], -16776961);
    PlayerTextDrawUseBox(playerid, Speedo_@TD[playerid][3], 1);
    PlayerTextDrawBoxColor(playerid, Speedo_@TD[playerid][3], 353703679);
    PlayerTextDrawBackgroundColor(playerid, Speedo_@TD[playerid][3], 255);
    PlayerTextDrawFont(playerid, Speedo_@TD[playerid][3], 1);
    PlayerTextDrawSetProportional(playerid, Speedo_@TD[playerid][3], 1);
    PlayerTextDrawSetShadow(playerid, Speedo_@TD[playerid][3], 0);
    
    Speedo_@TD[playerid][4] = CreatePlayerTextDraw(playerid, 542.8999, 421.7659, "Box"); // ïóñòî
    PlayerTextDrawLetterSize(playerid, Speedo_@TD[playerid][4], 0.0000, 0.8331);
    PlayerTextDrawTextSize(playerid, Speedo_@TD[playerid][4], 541.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, Speedo_@TD[playerid][4], 1);
    PlayerTextDrawColor(playerid, Speedo_@TD[playerid][4], -16776961);
    PlayerTextDrawUseBox(playerid, Speedo_@TD[playerid][4], 1);
    PlayerTextDrawBoxColor(playerid, Speedo_@TD[playerid][4], -5963521);
    PlayerTextDrawBackgroundColor(playerid, Speedo_@TD[playerid][4], 255);
    PlayerTextDrawFont(playerid, Speedo_@TD[playerid][4], 1);
    PlayerTextDrawSetProportional(playerid, Speedo_@TD[playerid][4], 1);
    PlayerTextDrawSetShadow(playerid, Speedo_@TD[playerid][4], 0);
    
    Speedo_@TD[playerid][5] = CreatePlayerTextDraw(playerid, 563.7015, 421.3221, "Fuel:100"); // ïóñòî
    PlayerTextDrawLetterSize(playerid, Speedo_@TD[playerid][5], 0.1574, 0.8169);
    PlayerTextDrawAlignment(playerid, Speedo_@TD[playerid][5], 2);
    PlayerTextDrawColor(playerid, Speedo_@TD[playerid][5], -1);
    PlayerTextDrawBackgroundColor(playerid, Speedo_@TD[playerid][5], 255);
    PlayerTextDrawFont(playerid, Speedo_@TD[playerid][5], 1);
    PlayerTextDrawSetProportional(playerid, Speedo_@TD[playerid][5], 1);
    PlayerTextDrawSetShadow(playerid, Speedo_@TD[playerid][5], 0);
    PlayerTextDrawSetSelectable(playerid, Speedo_@TD[playerid][5], true);
    
    Speedo_@TD[playerid][6] = CreatePlayerTextDraw(playerid, 607.2015, 421.6592, "Light:_~r~On"); // ïóñòî
    PlayerTextDrawLetterSize(playerid, Speedo_@TD[playerid][6], 0.1574, 0.8895);
    PlayerTextDrawTextSize(playerid, Speedo_@TD[playerid][6], 0.0000, 30.0000);
    PlayerTextDrawAlignment(playerid, Speedo_@TD[playerid][6], 2);
    PlayerTextDrawColor(playerid, Speedo_@TD[playerid][6], -1);
    PlayerTextDrawUseBox(playerid, Speedo_@TD[playerid][6], 1);
    PlayerTextDrawBoxColor(playerid, Speedo_@TD[playerid][6], 353703679);
    PlayerTextDrawBackgroundColor(playerid, Speedo_@TD[playerid][6], 255);
    PlayerTextDrawFont(playerid, Speedo_@TD[playerid][6], 1);
    PlayerTextDrawSetProportional(playerid, Speedo_@TD[playerid][6], 1);
    PlayerTextDrawSetShadow(playerid, Speedo_@TD[playerid][6], 0);
    PlayerTextDrawSetSelectable(playerid, Speedo_@TD[playerid][6], true);

    Server@Logo[playerid][0] = CreatePlayerTextDraw(playerid, 39.9499, 421.9808, "LOS_SANTOS"); // ïóñòî
    PlayerTextDrawLetterSize(playerid, Server@Logo[playerid][0], 0.2890, 1.4081);
    PlayerTextDrawAlignment(playerid, Server@Logo[playerid][0], 1);
    PlayerTextDrawColor(playerid, Server@Logo[playerid][0], -1);
    PlayerTextDrawSetOutline(playerid, Server@Logo[playerid][0], 1);
    PlayerTextDrawBackgroundColor(playerid, Server@Logo[playerid][0], 255);
    PlayerTextDrawFont(playerid, Server@Logo[playerid][0], 3);
    PlayerTextDrawSetProportional(playerid, Server@Logo[playerid][0], 1);
    PlayerTextDrawSetShadow(playerid, Server@Logo[playerid][0], 0);
    
    Server@Logo[playerid][1] = CreatePlayerTextDraw(playerid, 67.0830, 430.2966, "Roleplay"); // ïóñòî
    PlayerTextDrawLetterSize(playerid, Server@Logo[playerid][1], 0.2919, 1.0710);
    PlayerTextDrawAlignment(playerid, Server@Logo[playerid][1], 1);
    PlayerTextDrawColor(playerid, Server@Logo[playerid][1], -1523963137);
    PlayerTextDrawSetOutline(playerid, Server@Logo[playerid][1], 1);
    PlayerTextDrawBackgroundColor(playerid, Server@Logo[playerid][1], 255);
    PlayerTextDrawFont(playerid, Server@Logo[playerid][1], 0);
    PlayerTextDrawSetProportional(playerid, Server@Logo[playerid][1], 1);
    PlayerTextDrawSetShadow(playerid, Server@Logo[playerid][1], 0);


}
hook OnPlayerDisconnect(playerid, reason) {
	PlayerTextDrawHide(playerid,Server@Logo[playerid][0]);
    PlayerTextDrawHide(playerid,Server@Logo[playerid][1]);
}