

// NotifyTextMain[playerid] = CreatePlayerTextDraw(playerid, 324.1666, 397.4074, "Bam_phim_Y_de_tien_hanh_khai_thac_khoang_san_nay."); // ïóñòî
// PlayerTextDrawLetterSize(playerid, NotifyTextMain[playerid], 0.1604, 1.0348);
// PlayerTextDrawAlignment(playerid, NotifyTextMain[playerid], 2);
// PlayerTextDrawColor(playerid, NotifyTextMain[playerid], -1);
// PlayerTextDrawSetOutline(playerid, NotifyTextMain[playerid], 1);
// PlayerTextDrawBackgroundColor(playerid, NotifyTextMain[playerid], 255);
// PlayerTextDrawFont(playerid, NotifyTextMain[playerid], 1);
// PlayerTextDrawSetProportional(playerid, NotifyTextMain[playerid], 1);
// PlayerTextDrawSetShadow(playerid, NotifyTextMain[playerid], 0);

// Main_Text_PTD[playerid][4] = CreatePlayerTextDraw(playerid, 72.4999, 318.0739, "Vi_tri:_~y~El'Corona"); // ïóñòî
// PlayerTextDrawLetterSize(playerid, Main_Text_PTD[playerid][4], 0.1662, 0.9362);
// PlayerTextDrawTextSize(playerid, Main_Text_PTD[playerid][4], 0.0000, 86.0000);
// PlayerTextDrawAlignment(playerid, Main_Text_PTD[playerid][4], 2);
// PlayerTextDrawColor(playerid, Main_Text_PTD[playerid][4], -1);
// PlayerTextDrawBackgroundColor(playerid, Main_Text_PTD[playerid][4], 255);
// PlayerTextDrawFont(playerid, Main_Text_PTD[playerid][4], 1);
// PlayerTextDrawSetProportional(playerid, Main_Text_PTD[playerid][4], 1);
// PlayerTextDrawSetShadow(playerid, Main_Text_PTD[playerid][4], 0);
#include <YSI\y_hooks>


#define MAX_ITEM_MESSAGE 15
new PlayerItemMessage[MAX_PLAYERS][MAX_ITEM_MESSAGE],
    PlayerItemMessageTimer[MAX_PLAYERS][MAX_ITEM_MESSAGE],
    PlayerText:MessageText_@Box[MAX_PLAYERS][MAX_ITEM_MESSAGE],
    PlayerText:MessageText_@Model[MAX_PLAYERS][MAX_ITEM_MESSAGE],
    PlayerText:MessageText_@Text[MAX_PLAYERS][MAX_ITEM_MESSAGE];
new TimerMainText[MAX_PLAYERS],PlayerText:NotifyTextMain[MAX_PLAYERS];
CMD:testshowmoney(playerid,params[]) return ShowItemMessage(playerid,1212,"~g~+$1000",strval(params)); 

stock ShowItemMessage(playerid,model,text[],time) {
    new message = -1;
	for(new i = 0 ; i < MAX_ITEM_MESSAGE; i++) {
		if(PlayerItemMessage[playerid][i] == 0) {
		    message = i;
    		break ;
		}
	}
    if(message == -1) {
        message = 0;
    }
    printf("message = %d",message);
    PlayerItemMessage[playerid][message] = 1;
    CreateItemMessage(playerid,message,text,model);
    PlayerTextDrawShow(playerid, MessageText_@Box[playerid][message] );
    PlayerTextDrawShow(playerid, MessageText_@Model[playerid][message] );
    PlayerTextDrawShow(playerid, MessageText_@Text[playerid][message] );
    PlayerItemMessageTimer[playerid][message] = SetTimerEx("HideItemMessage", time * 1000, 0, "dd", playerid,message);
    return 1;
}
forward HideItemMessage(playerid,slot);
public HideItemMessage(playerid,slot) {
	PlayerTextDrawHide(playerid, MessageText_@Box[playerid][slot] );
    PlayerTextDrawHide(playerid, MessageText_@Model[playerid][slot] );
    PlayerTextDrawHide(playerid, MessageText_@Text[playerid][slot] );
    PlayerTextDrawDestroy(playerid, MessageText_@Box[playerid][slot] );
    PlayerTextDrawDestroy(playerid, MessageText_@Model[playerid][slot] );
    PlayerTextDrawDestroy(playerid, MessageText_@Text[playerid][slot] );
    MessageText_@Box[playerid][slot] = PlayerText:INVALID_TEXT_DRAW;
    MessageText_@Model[playerid][slot]= PlayerText:INVALID_TEXT_DRAW;
    MessageText_@Text[playerid][slot] = PlayerText:INVALID_TEXT_DRAW;
    PlayerItemMessage[playerid][slot] = 0;
    KillTimer(PlayerItemMessageTimer[playerid][slot]);
}
hook OnPlayerDisconnect(playerid, reason) {
    KillTimer(TimerMainText[playerid]);
	for(new i = 0 ; i < MAX_ITEM_MESSAGE; i++) {
		if(PlayerItemMessage[playerid][i] != 0) {
			HideItemMessage(playerid,i);
		}
	}
}
stock CreateItemMessage(playerid,slot,text[],model) {
	MessageText_@Box[playerid][slot] = CreatePlayerTextDraw(playerid, 561.6668, 308.2221 -( 16.5 * slot ), "Box"); // ïóñòî 15.6
    PlayerTextDrawLetterSize(playerid, MessageText_@Box[playerid][slot], 0.0000, 1.2500);
    PlayerTextDrawTextSize(playerid, MessageText_@Box[playerid][slot], 634.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, MessageText_@Box[playerid][slot], 1);
    PlayerTextDrawColor(playerid, MessageText_@Box[playerid][slot], -194);
    PlayerTextDrawUseBox(playerid, MessageText_@Box[playerid][slot], 1);
    PlayerTextDrawBoxColor(playerid, MessageText_@Box[playerid][slot], 177);
    PlayerTextDrawBackgroundColor(playerid, MessageText_@Box[playerid][slot], 255);
    PlayerTextDrawFont(playerid, MessageText_@Box[playerid][slot], 1);
    PlayerTextDrawSetProportional(playerid, MessageText_@Box[playerid][slot], 1);
    PlayerTextDrawSetShadow(playerid, MessageText_@Box[playerid][slot], 0);

    MessageText_@Model[playerid][slot] = CreatePlayerTextDraw(playerid, 546.3500, 306.3259 -( 16.6 * slot ), ""); // ïóñòî
    PlayerTextDrawTextSize(playerid, MessageText_@Model[playerid][slot], 13.0000, 14.7499);
    PlayerTextDrawAlignment(playerid, MessageText_@Model[playerid][slot], 1);
    PlayerTextDrawColor(playerid, MessageText_@Model[playerid][slot], -1);
    PlayerTextDrawBackgroundColor(playerid, MessageText_@Model[playerid][slot], 176);
    PlayerTextDrawFont(playerid, MessageText_@Model[playerid][slot], 5);
    PlayerTextDrawSetProportional(playerid, MessageText_@Model[playerid][slot], 0);
    PlayerTextDrawSetShadow(playerid, MessageText_@Model[playerid][slot], 0);
    PlayerTextDrawSetPreviewModel(playerid, MessageText_@Model[playerid][slot], model);
    PlayerTextDrawSetPreviewRot(playerid, MessageText_@Model[playerid][slot], 0.0000, 0.0000, 0.0000, 1.0000);
    PlayerTextDrawSetPreviewVehCol(playerid, MessageText_@Model[playerid][slot], 1, 1);

    MessageText_@Text[playerid][slot] = CreatePlayerTextDraw(playerid, 595.3001, 309.7778 -( 16.6* slot ) , text); // ïóñòî
    PlayerTextDrawLetterSize(playerid, MessageText_@Text[playerid][slot], 0.1408, 0.7911);
    PlayerTextDrawAlignment(playerid, MessageText_@Text[playerid][slot], 2);
    PlayerTextDrawColor(playerid, MessageText_@Text[playerid][slot], -1);
    PlayerTextDrawBackgroundColor(playerid, MessageText_@Text[playerid][slot], 255);
    PlayerTextDrawFont(playerid, MessageText_@Text[playerid][slot], 1);
    PlayerTextDrawSetProportional(playerid, MessageText_@Text[playerid][slot], 1);
    PlayerTextDrawSetShadow(playerid, MessageText_@Text[playerid][slot], 0);
}

stock ShowNotifyTextMain(playerid,text[],time = 5) {
    KillTimer(TimerMainText[playerid] );
    PlayerTextDrawSetString(playerid, NotifyTextMain[playerid],text);
    PlayerTextDrawShow(playerid,NotifyTextMain[playerid]);
    TimerMainText[playerid] = SetTimerEx("HideTextMain", time * 1000,0,"d", playerid);
    return 1;
}
forward HideTextMain(playerid);
public HideTextMain(playerid) {
    KillTimer(TimerMainText[playerid]);
    PlayerTextDrawHide(playerid, NotifyTextMain[playerid] );
}
hook OnPlayerConnect(playerid) {
    NotifyTextMain[playerid] = CreatePlayerTextDraw(playerid, 324.1666, 397.4074, "Bam_phim_Y_de_tien_hanh_khai_thac_khoang_san_nay."); // ïóñòî
    PlayerTextDrawLetterSize(playerid, NotifyTextMain[playerid], 0.1604, 1.0348);
    PlayerTextDrawAlignment(playerid, NotifyTextMain[playerid], 2);
    PlayerTextDrawColor(playerid, NotifyTextMain[playerid], -1);
    PlayerTextDrawSetOutline(playerid, NotifyTextMain[playerid], 1);
    PlayerTextDrawBackgroundColor(playerid, NotifyTextMain[playerid], 255);
    PlayerTextDrawFont(playerid, NotifyTextMain[playerid], 1);
    PlayerTextDrawSetProportional(playerid, NotifyTextMain[playerid], 1);
    PlayerTextDrawSetShadow(playerid, NotifyTextMain[playerid], 0);
}
// Ýêñïîðòèðîâàíî 5 òåêñòäðàâîâ.