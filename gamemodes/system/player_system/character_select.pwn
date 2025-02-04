
#include <YSI\y_hooks>
new PlayerText:Character_Main[MAX_PLAYERS][5];
new PlayerText:Character_Slot[MAX_PLAYERS][3];
new PlayerText:Character_Text[MAX_PLAYERS][3];
stock HideCharacterTextdraw(playerid) {
	for(new i = 0 ; i < 5 ; i++) {
		PlayerTextDrawHide(playerid, Character_Main[playerid][i]);
	}
	for(new i = 0 ; i < 3 ; i++) {
		PlayerTextDrawHide(playerid, Character_Slot[playerid][i]);
		PlayerTextDrawHide(playerid, Character_Text[playerid][i]);
	}
	CancelSelectTextDraw(playerid);
		
}
hook OnPlayerConnect(playerid) {
Character_Main[playerid][0] = CreatePlayerTextDraw(playerid, 169.9999, 148.0000, "Box"); // ïóñòî
PlayerTextDrawLetterSize(playerid, Character_Main[playerid][0], 0.0000, 15.6666);
PlayerTextDrawTextSize(playerid, Character_Main[playerid][0], 271.0000, 0.0000);
PlayerTextDrawAlignment(playerid, Character_Main[playerid][0], 1);
PlayerTextDrawColor(playerid, Character_Main[playerid][0], -1);
PlayerTextDrawUseBox(playerid, Character_Main[playerid][0], 1);
PlayerTextDrawBoxColor(playerid, Character_Main[playerid][0], 191);
PlayerTextDrawBackgroundColor(playerid, Character_Main[playerid][0], 255);
PlayerTextDrawFont(playerid, Character_Main[playerid][0], 1);
PlayerTextDrawSetProportional(playerid, Character_Main[playerid][0], 1);
PlayerTextDrawSetShadow(playerid, Character_Main[playerid][0], 0);

Character_Main[playerid][1] = CreatePlayerTextDraw(playerid, 274.9668, 147.6630, "Box"); // ïóñòî
PlayerTextDrawLetterSize(playerid, Character_Main[playerid][1], 0.0000, 15.6666);
PlayerTextDrawTextSize(playerid, Character_Main[playerid][1], 374.3002, 0.0000);
PlayerTextDrawAlignment(playerid, Character_Main[playerid][1], 1);
PlayerTextDrawColor(playerid, Character_Main[playerid][1], -1);
PlayerTextDrawUseBox(playerid, Character_Main[playerid][1], 1);
PlayerTextDrawBoxColor(playerid, Character_Main[playerid][1], 191);
PlayerTextDrawBackgroundColor(playerid, Character_Main[playerid][1], 255);
PlayerTextDrawFont(playerid, Character_Main[playerid][1], 1);
PlayerTextDrawSetProportional(playerid, Character_Main[playerid][1], 1);
PlayerTextDrawSetShadow(playerid, Character_Main[playerid][1], 0);

Character_Main[playerid][2] = CreatePlayerTextDraw(playerid, 378.0502, 147.4260, "Box"); // ïóñòî
PlayerTextDrawLetterSize(playerid, Character_Main[playerid][2], 0.0000, 15.6666);
PlayerTextDrawTextSize(playerid, Character_Main[playerid][2], 477.0000, 0.0000);
PlayerTextDrawAlignment(playerid, Character_Main[playerid][2], 1);
PlayerTextDrawColor(playerid, Character_Main[playerid][2], -1);
PlayerTextDrawUseBox(playerid, Character_Main[playerid][2], 1);
PlayerTextDrawBoxColor(playerid, Character_Main[playerid][2], 191);
PlayerTextDrawBackgroundColor(playerid, Character_Main[playerid][2], 255);
PlayerTextDrawFont(playerid, Character_Main[playerid][2], 1);
PlayerTextDrawSetProportional(playerid, Character_Main[playerid][2], 1);
PlayerTextDrawSetShadow(playerid, Character_Main[playerid][2], 0);

Character_Main[playerid][3] = CreatePlayerTextDraw(playerid, 272.5000, 99.2592, "LOS_SANTOS"); // ïóñòî
PlayerTextDrawLetterSize(playerid, Character_Main[playerid][3], 0.4770, 2.5022);
PlayerTextDrawAlignment(playerid, Character_Main[playerid][3], 1);
PlayerTextDrawColor(playerid, Character_Main[playerid][3], -1);
PlayerTextDrawSetOutline(playerid, Character_Main[playerid][3], 1);
PlayerTextDrawBackgroundColor(playerid, Character_Main[playerid][3], 255);
PlayerTextDrawFont(playerid, Character_Main[playerid][3], 3);
PlayerTextDrawSetProportional(playerid, Character_Main[playerid][3], 1);
PlayerTextDrawSetShadow(playerid, Character_Main[playerid][3], 0);

Character_Main[playerid][4] = CreatePlayerTextDraw(playerid, 319.5834, 111.1852, "Roleplay"); // ïóñòî
PlayerTextDrawLetterSize(playerid, Character_Main[playerid][4], 0.4641, 2.1288);
PlayerTextDrawTextSize(playerid, Character_Main[playerid][4], -2.0000, 0.0000);
PlayerTextDrawAlignment(playerid, Character_Main[playerid][4], 1);
PlayerTextDrawColor(playerid, Character_Main[playerid][4], -2147483393);
PlayerTextDrawSetOutline(playerid, Character_Main[playerid][4], 1);
PlayerTextDrawBackgroundColor(playerid, Character_Main[playerid][4], 255);
PlayerTextDrawFont(playerid, Character_Main[playerid][4], 0);
PlayerTextDrawSetProportional(playerid, Character_Main[playerid][4], 1);
PlayerTextDrawSetShadow(playerid, Character_Main[playerid][4], 0);



Character_Slot[playerid][0] = CreatePlayerTextDraw(playerid, 175.4165, 157.0740, ""); // ïóñòî
PlayerTextDrawTextSize(playerid, Character_Slot[playerid][0], 90.0000, 103.0000);
PlayerTextDrawAlignment(playerid, Character_Slot[playerid][0], 1);
PlayerTextDrawColor(playerid, Character_Slot[playerid][0], -1);
PlayerTextDrawBackgroundColor(playerid, Character_Slot[playerid][0], 5);
PlayerTextDrawFont(playerid, Character_Slot[playerid][0], 5);
PlayerTextDrawSetProportional(playerid, Character_Slot[playerid][0], 0);
PlayerTextDrawSetShadow(playerid, Character_Slot[playerid][0], 0);
PlayerTextDrawSetPreviewModel(playerid, Character_Slot[playerid][0], 21);
PlayerTextDrawSetPreviewRot(playerid, Character_Slot[playerid][0], 0.0000, 0.0000, 0.0000, 1.0000);
PlayerTextDrawSetSelectable(playerid, Character_Slot[playerid][0], true);

Character_Slot[playerid][1] = CreatePlayerTextDraw(playerid, 283.7499, 158.1110, ""); // ïóñòî
PlayerTextDrawTextSize(playerid, Character_Slot[playerid][1], 90.0000, 103.0000);
PlayerTextDrawAlignment(playerid, Character_Slot[playerid][1], 1);
PlayerTextDrawColor(playerid, Character_Slot[playerid][1], -1);
PlayerTextDrawBackgroundColor(playerid, Character_Slot[playerid][1], 5);
PlayerTextDrawFont(playerid, Character_Slot[playerid][1], 5);
PlayerTextDrawSetProportional(playerid, Character_Slot[playerid][1], 0);
PlayerTextDrawSetShadow(playerid, Character_Slot[playerid][1], 0);
PlayerTextDrawSetPreviewModel(playerid, Character_Slot[playerid][1], 21);
PlayerTextDrawSetPreviewRot(playerid, Character_Slot[playerid][1], 0.0000, 0.0000, 0.0000, 1.0000);
PlayerTextDrawSetSelectable(playerid, Character_Slot[playerid][1], true);


Character_Slot[playerid][2] = CreatePlayerTextDraw(playerid, 384.1665, 156.7924, ""); // ïóñòî
PlayerTextDrawTextSize(playerid, Character_Slot[playerid][2], 90.0000, 103.0000);
PlayerTextDrawAlignment(playerid, Character_Slot[playerid][2], 1);
PlayerTextDrawColor(playerid, Character_Slot[playerid][2], -1);
PlayerTextDrawBackgroundColor(playerid, Character_Slot[playerid][2], 5);
PlayerTextDrawFont(playerid, Character_Slot[playerid][2], 5);
PlayerTextDrawSetProportional(playerid, Character_Slot[playerid][2], 0);
PlayerTextDrawSetShadow(playerid, Character_Slot[playerid][2], 0);
PlayerTextDrawSetPreviewModel(playerid, Character_Slot[playerid][2], 21);
PlayerTextDrawSetPreviewRot(playerid, Character_Slot[playerid][2], 0.0000, 0.0000, 0.0000, 1.0000);
PlayerTextDrawSetSelectable(playerid, Character_Slot[playerid][2], true);

Character_Text[playerid][0] = CreatePlayerTextDraw(playerid, 218.7833, 266.2219, "Cuozg_Nguyen(1)"); // ïóñòî
PlayerTextDrawLetterSize(playerid, Character_Text[playerid][0], 0.1757, 1.2784);
PlayerTextDrawTextSize(playerid, Character_Text[playerid][0], 10.0000, -103.0000);
PlayerTextDrawAlignment(playerid, Character_Text[playerid][0], 2);
PlayerTextDrawColor(playerid, Character_Text[playerid][0], -1);
PlayerTextDrawBackgroundColor(playerid, Character_Text[playerid][0], 255);
PlayerTextDrawFont(playerid, Character_Text[playerid][0], 1);
PlayerTextDrawSetProportional(playerid, Character_Text[playerid][0], 1);
PlayerTextDrawSetShadow(playerid, Character_Text[playerid][0], 0);

Character_Text[playerid][1] = CreatePlayerTextDraw(playerid, 331.4000, 265.7589, "Cuozg_Nguyen(1)"); // ïóñòî
PlayerTextDrawLetterSize(playerid, Character_Text[playerid][1], 0.1757, 1.2784);
PlayerTextDrawTextSize(playerid, Character_Text[playerid][1], 10.0000, -111.0000);
PlayerTextDrawAlignment(playerid, Character_Text[playerid][1], 2);
PlayerTextDrawColor(playerid, Character_Text[playerid][1], -1);
PlayerTextDrawBackgroundColor(playerid, Character_Text[playerid][1], 255);
PlayerTextDrawFont(playerid, Character_Text[playerid][1], 1);
PlayerTextDrawSetProportional(playerid, Character_Text[playerid][1], 1);
PlayerTextDrawSetShadow(playerid, Character_Text[playerid][1], 0);

Character_Text[playerid][2] = CreatePlayerTextDraw(playerid, 430.5667, 263.6184, "Cuozg_Nguyen(1)"); // ïóñòî
PlayerTextDrawLetterSize(playerid, Character_Text[playerid][2], 0.1757, 1.2784);
PlayerTextDrawTextSize(playerid, Character_Text[playerid][2], 10.0000, -98.0000);
PlayerTextDrawAlignment(playerid, Character_Text[playerid][2], 2);
PlayerTextDrawColor(playerid, Character_Text[playerid][2], -1);
PlayerTextDrawBackgroundColor(playerid, Character_Text[playerid][2], 255);
PlayerTextDrawFont(playerid, Character_Text[playerid][2], 1);
PlayerTextDrawSetProportional(playerid, Character_Text[playerid][2], 1);
PlayerTextDrawSetShadow(playerid, Character_Text[playerid][2], 0);



}