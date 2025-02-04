#include <YSI\y_hooks>

new ProgressTimerSet[MAX_PLAYERS],PlayerText:Dynamic_Progress[MAX_PLAYERS][3];
hook OnPlayerConnect(playerid) {

    Dynamic_Progress[playerid][0] = CreatePlayerTextDraw(playerid, 254.4665, 435.5079, "Box"); // ïóñòî
    PlayerTextDrawLetterSize(playerid, Dynamic_Progress[playerid][0], 0.0000, 0.2082);
    PlayerTextDrawTextSize(playerid, Dynamic_Progress[playerid][0], 421.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, Dynamic_Progress[playerid][0], 1);
    PlayerTextDrawColor(playerid, Dynamic_Progress[playerid][0], -1);
    PlayerTextDrawUseBox(playerid, Dynamic_Progress[playerid][0], 1);
    PlayerTextDrawBoxColor(playerid, Dynamic_Progress[playerid][0], 640034559);
    PlayerTextDrawBackgroundColor(playerid, Dynamic_Progress[playerid][0], 255);
    PlayerTextDrawFont(playerid, Dynamic_Progress[playerid][0], 0);
    PlayerTextDrawSetProportional(playerid, Dynamic_Progress[playerid][0], 1);
    PlayerTextDrawSetShadow(playerid, Dynamic_Progress[playerid][0], 0);
    
    Dynamic_Progress[playerid][1] = CreatePlayerTextDraw(playerid, 254.0500, 435.5079, "Box"); // ïóñòî
    PlayerTextDrawLetterSize(playerid, Dynamic_Progress[playerid][1], 0.0000, 0.2158);
    PlayerTextDrawTextSize(playerid, Dynamic_Progress[playerid][1], 253.0000, 0.0000); 
    PlayerTextDrawAlignment(playerid, Dynamic_Progress[playerid][1], 1);
    PlayerTextDrawColor(playerid, Dynamic_Progress[playerid][1], -1);
    PlayerTextDrawUseBox(playerid, Dynamic_Progress[playerid][1], 1);
    PlayerTextDrawBoxColor(playerid, Dynamic_Progress[playerid][1], -1368868609);
    PlayerTextDrawBackgroundColor(playerid, Dynamic_Progress[playerid][1], 255);
    PlayerTextDrawFont(playerid, Dynamic_Progress[playerid][1], 0);
    PlayerTextDrawSetProportional(playerid, Dynamic_Progress[playerid][1], 1);
    PlayerTextDrawSetShadow(playerid, Dynamic_Progress[playerid][1], 0);
    
    Dynamic_Progress[playerid][2] = CreatePlayerTextDraw(playerid, 252.5330, 421.9408, "EXP:_100%"); // ïóñòî
    PlayerTextDrawLetterSize(playerid, Dynamic_Progress[playerid][2], 0.1729, 1.1850);
    PlayerTextDrawTextSize(playerid, Dynamic_Progress[playerid][2], 417.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, Dynamic_Progress[playerid][2], 1);
    PlayerTextDrawColor(playerid, Dynamic_Progress[playerid][2], -1);
    PlayerTextDrawBackgroundColor(playerid, Dynamic_Progress[playerid][2], 255);
    PlayerTextDrawFont(playerid, Dynamic_Progress[playerid][2], 1);
    PlayerTextDrawSetProportional(playerid, Dynamic_Progress[playerid][2], 1);
    PlayerTextDrawSetShadow(playerid, Dynamic_Progress[playerid][2], 0);

}

stock ShowProgress(playerid,text[],Float:phantram,time) {
    HideProgress(playerid);
    KillTimer(ProgressTimerSet[playerid] );
    // max 421, min 253 = 1.68
    PlayerTextDrawSetString(playerid, Dynamic_Progress[playerid][2],text);
    PlayerTextDrawTextSize(playerid, Dynamic_Progress[playerid][1], 253.0000 + ( phantram * 1.68 ), 0.0000); 
    PlayerTextDrawShow(playerid, Dynamic_Progress[playerid][0]);
    PlayerTextDrawShow(playerid, Dynamic_Progress[playerid][1]);
    PlayerTextDrawShow(playerid, Dynamic_Progress[playerid][2]);
    ProgressTimerSet[playerid] = SetTimerEx("HideProgress", time * 1000, 0,"d", playerid);
}
forward HideProgress(playerid);
public HideProgress(playerid) {
	KillTimer( ProgressTimerSet[playerid] );
	PlayerTextDrawHide(playerid, Dynamic_Progress[playerid][0]);
    PlayerTextDrawHide(playerid, Dynamic_Progress[playerid][1]);
    PlayerTextDrawHide(playerid, Dynamic_Progress[playerid][2]);
}
hook OnPlayerDisconnect(playerid, reason) {
	PlayerTextDrawDestroy(playerid, Dynamic_Progress[playerid][0]);
    PlayerTextDrawDestroy(playerid, Dynamic_Progress[playerid][1]);
    PlayerTextDrawDestroy(playerid, Dynamic_Progress[playerid][2]);
}