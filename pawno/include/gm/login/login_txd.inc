stock SetPlayerCameraMoving(playerid)
{
	InterpolateCameraPos(playerid, 1518.241333, -1296.887695, 173.856552, 1092.373291, -1931.155639, 188.103378, 11111, CAMERA_MOVE);
	InterpolateCameraLookAt(playerid, 1513.351928, -1296.080200, 173.191772, 1095.859130, -1927.751098, 186.981414, 7777, CAMERA_MOVE);
	return 1;
}

LoadCharacterSelect(playerid)
{
	CharacterMenu[playerid][0] = CreatePlayerTextDraw(playerid, 317.000000, -2.000000, "_");
	PlayerTextDrawFont(playerid, CharacterMenu[playerid][0], 1);
	PlayerTextDrawLetterSize(playerid, CharacterMenu[playerid][0], 0.600000, 51.800003);
	PlayerTextDrawTextSize(playerid, CharacterMenu[playerid][0], 298.500000, 660.000000);
	PlayerTextDrawSetOutline(playerid, CharacterMenu[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, CharacterMenu[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, CharacterMenu[playerid][0], 2);
	PlayerTextDrawColor(playerid, CharacterMenu[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, CharacterMenu[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, CharacterMenu[playerid][0], -1061109505);
	PlayerTextDrawUseBox(playerid, CharacterMenu[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, CharacterMenu[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, CharacterMenu[playerid][0], 0);

	CharacterMenu[playerid][1] = CreatePlayerTextDraw(playerid, 319.000000, 157.000000, "_");
	PlayerTextDrawFont(playerid, CharacterMenu[playerid][1], 1);
	PlayerTextDrawLetterSize(playerid, CharacterMenu[playerid][1], 0.600000, 16.250003);
	PlayerTextDrawTextSize(playerid, CharacterMenu[playerid][1], 298.500000, 240.000000);
	PlayerTextDrawSetOutline(playerid, CharacterMenu[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, CharacterMenu[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, CharacterMenu[playerid][1], 2);
	PlayerTextDrawColor(playerid, CharacterMenu[playerid][1], 255);
	PlayerTextDrawBackgroundColor(playerid, CharacterMenu[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, CharacterMenu[playerid][1], 255);
	PlayerTextDrawUseBox(playerid, CharacterMenu[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, CharacterMenu[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, CharacterMenu[playerid][1], 0);

	CharacterMenu[playerid][2] = CreatePlayerTextDraw(playerid, 319.000000, 159.000000, "_");
	PlayerTextDrawFont(playerid, CharacterMenu[playerid][2], 1);
	PlayerTextDrawLetterSize(playerid, CharacterMenu[playerid][2], 0.600000, 15.800005);
	PlayerTextDrawTextSize(playerid, CharacterMenu[playerid][2], 298.500000, 237.500000);
	PlayerTextDrawSetOutline(playerid, CharacterMenu[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, CharacterMenu[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, CharacterMenu[playerid][2], 2);
	PlayerTextDrawColor(playerid, CharacterMenu[playerid][2], 255);
	PlayerTextDrawBackgroundColor(playerid, CharacterMenu[playerid][2], 255);
	PlayerTextDrawBoxColor(playerid, CharacterMenu[playerid][2], -62);
	PlayerTextDrawUseBox(playerid, CharacterMenu[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, CharacterMenu[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, CharacterMenu[playerid][2], 0);

	CharacterMenu[playerid][3] = CreatePlayerTextDraw(playerid, 240.000000, 166.000000, "_");
	PlayerTextDrawFont(playerid, CharacterMenu[playerid][3], 1);
	PlayerTextDrawLetterSize(playerid, CharacterMenu[playerid][3], 0.600000, 13.300003);
	PlayerTextDrawTextSize(playerid, CharacterMenu[playerid][3], 298.500000, 61.500000);
	PlayerTextDrawSetOutline(playerid, CharacterMenu[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, CharacterMenu[playerid][3], 0);
	PlayerTextDrawAlignment(playerid, CharacterMenu[playerid][3], 2);
	PlayerTextDrawColor(playerid, CharacterMenu[playerid][3], -1);
	PlayerTextDrawBackgroundColor(playerid, CharacterMenu[playerid][3], 255);
	PlayerTextDrawBoxColor(playerid, CharacterMenu[playerid][3], 135);
	PlayerTextDrawUseBox(playerid, CharacterMenu[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, CharacterMenu[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, CharacterMenu[playerid][3], 0);

	CharacterMenu[playerid][4] = CreatePlayerTextDraw(playerid, 321.000000, 166.000000, "_");
	PlayerTextDrawFont(playerid, CharacterMenu[playerid][4], 1);
	PlayerTextDrawLetterSize(playerid, CharacterMenu[playerid][4], 0.600000, 13.300003);
	PlayerTextDrawTextSize(playerid, CharacterMenu[playerid][4], 298.500000, 61.500000);
	PlayerTextDrawSetOutline(playerid, CharacterMenu[playerid][4], 1);
	PlayerTextDrawSetShadow(playerid, CharacterMenu[playerid][4], 0);
	PlayerTextDrawAlignment(playerid, CharacterMenu[playerid][4], 2);
	PlayerTextDrawColor(playerid, CharacterMenu[playerid][4], -1);
	PlayerTextDrawBackgroundColor(playerid, CharacterMenu[playerid][4], 255);
	PlayerTextDrawBoxColor(playerid, CharacterMenu[playerid][4], 135);
	PlayerTextDrawUseBox(playerid, CharacterMenu[playerid][4], 1);
	PlayerTextDrawSetProportional(playerid, CharacterMenu[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid, CharacterMenu[playerid][4], 0);

	CharacterMenu[playerid][5] = CreatePlayerTextDraw(playerid, 400.000000, 166.000000, "_");
	PlayerTextDrawFont(playerid, CharacterMenu[playerid][5], 1);
	PlayerTextDrawLetterSize(playerid, CharacterMenu[playerid][5], 0.600000, 13.300003);
	PlayerTextDrawTextSize(playerid, CharacterMenu[playerid][5], 298.500000, 61.500000);
	PlayerTextDrawSetOutline(playerid, CharacterMenu[playerid][5], 1);
	PlayerTextDrawSetShadow(playerid, CharacterMenu[playerid][5], 0);
	PlayerTextDrawAlignment(playerid, CharacterMenu[playerid][5], 2);
	PlayerTextDrawColor(playerid, CharacterMenu[playerid][5], -1);
	PlayerTextDrawBackgroundColor(playerid, CharacterMenu[playerid][5], 255);
	PlayerTextDrawBoxColor(playerid, CharacterMenu[playerid][5], 135);
	PlayerTextDrawUseBox(playerid, CharacterMenu[playerid][5], 1);
	PlayerTextDrawSetProportional(playerid, CharacterMenu[playerid][5], 1);
	PlayerTextDrawSetSelectable(playerid, CharacterMenu[playerid][5], 0);

	CharacterMenu[playerid][6] = CreatePlayerTextDraw(playerid, 324.000000, 81.000000, "Los Santos");
	PlayerTextDrawFont(playerid, CharacterMenu[playerid][6], 3);
	PlayerTextDrawLetterSize(playerid, CharacterMenu[playerid][6], 0.625000, 2.249999);
	PlayerTextDrawTextSize(playerid, CharacterMenu[playerid][6], 400.000000, 207.000000);
	PlayerTextDrawSetOutline(playerid, CharacterMenu[playerid][6], 1);
	PlayerTextDrawSetShadow(playerid, CharacterMenu[playerid][6], 0);
	PlayerTextDrawAlignment(playerid, CharacterMenu[playerid][6], 2);
	PlayerTextDrawColor(playerid, CharacterMenu[playerid][6], -1);
	PlayerTextDrawBackgroundColor(playerid, CharacterMenu[playerid][6], 255);
	PlayerTextDrawBoxColor(playerid, CharacterMenu[playerid][6], 50);
	PlayerTextDrawUseBox(playerid, CharacterMenu[playerid][6], 0);
	PlayerTextDrawSetProportional(playerid, CharacterMenu[playerid][6], 1);
	PlayerTextDrawSetSelectable(playerid, CharacterMenu[playerid][6], 0);

	CharacterMenu[playerid][7] = CreatePlayerTextDraw(playerid, 325.000000, 91.000000, "Roleplay");
	PlayerTextDrawFont(playerid, CharacterMenu[playerid][7], 0);
	PlayerTextDrawLetterSize(playerid, CharacterMenu[playerid][7], 0.737500, 2.299999);
	PlayerTextDrawTextSize(playerid, CharacterMenu[playerid][7], 400.000000, 207.000000);
	PlayerTextDrawSetOutline(playerid, CharacterMenu[playerid][7], 1);
	PlayerTextDrawSetShadow(playerid, CharacterMenu[playerid][7], 0);
	PlayerTextDrawAlignment(playerid, CharacterMenu[playerid][7], 2);
	PlayerTextDrawColor(playerid, CharacterMenu[playerid][7], -1);
	PlayerTextDrawBackgroundColor(playerid, CharacterMenu[playerid][7], 255);
	PlayerTextDrawBoxColor(playerid, CharacterMenu[playerid][7], 50);
	PlayerTextDrawUseBox(playerid, CharacterMenu[playerid][7], 0);
	PlayerTextDrawSetProportional(playerid, CharacterMenu[playerid][7], 1);
	PlayerTextDrawSetSelectable(playerid, CharacterMenu[playerid][7], 0);

    CharacterMenu[playerid][8] = CreatePlayerTextDraw(playerid, 322.000000, 121.000000, "Chon nhan vat");
	PlayerTextDrawFont(playerid, CharacterMenu[playerid][8], 2);
	PlayerTextDrawLetterSize(playerid, CharacterMenu[playerid][8], 0.174999, 1.150001);
	PlayerTextDrawTextSize(playerid, CharacterMenu[playerid][8], 400.000000, 207.000000);
	PlayerTextDrawSetOutline(playerid, CharacterMenu[playerid][8], 1);
	PlayerTextDrawSetShadow(playerid, CharacterMenu[playerid][8], 0);
	PlayerTextDrawAlignment(playerid, CharacterMenu[playerid][8], 2);
	PlayerTextDrawColor(playerid, CharacterMenu[playerid][8], -1);
	PlayerTextDrawBackgroundColor(playerid, CharacterMenu[playerid][8], 255);
	PlayerTextDrawBoxColor(playerid, CharacterMenu[playerid][8], 50);
	PlayerTextDrawUseBox(playerid, CharacterMenu[playerid][8], 0);
	PlayerTextDrawSetProportional(playerid, CharacterMenu[playerid][8], 1);
	PlayerTextDrawSetSelectable(playerid, CharacterMenu[playerid][8], 0);

	CharacterPreview[playerid][0][0] = CreatePlayerTextDraw(playerid, 194.000000, 175.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, CharacterPreview[playerid][0][0], 5);
	PlayerTextDrawLetterSize(playerid, CharacterPreview[playerid][0][0], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, CharacterPreview[playerid][0][0], 87.000000, 97.500000);
	PlayerTextDrawSetOutline(playerid, CharacterPreview[playerid][0][0], 0);
	PlayerTextDrawSetShadow(playerid, CharacterPreview[playerid][0][0], 0);
	PlayerTextDrawAlignment(playerid, CharacterPreview[playerid][0][0], 1);
	PlayerTextDrawColor(playerid, CharacterPreview[playerid][0][0], -1);
	PlayerTextDrawBackgroundColor(playerid, CharacterPreview[playerid][0][0], 0);
	PlayerTextDrawBoxColor(playerid, CharacterPreview[playerid][0][0], 255);
	PlayerTextDrawUseBox(playerid, CharacterPreview[playerid][0][0], 0);
	PlayerTextDrawSetProportional(playerid, CharacterPreview[playerid][0][0], 1);
	PlayerTextDrawSetSelectable(playerid, CharacterPreview[playerid][0][0], 1);
	PlayerTextDrawSetPreviewModel(playerid, CharacterPreview[playerid][0][0], 20);
	PlayerTextDrawSetPreviewRot(playerid, CharacterPreview[playerid][0][0], 0.000000, 0.000000, 1.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, CharacterPreview[playerid][0][0], 1, 1);

	CharacterPreview[playerid][1][0] = CreatePlayerTextDraw(playerid, 277.000000, 175.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, CharacterPreview[playerid][1][0], 5);
	PlayerTextDrawLetterSize(playerid, CharacterPreview[playerid][1][0], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, CharacterPreview[playerid][1][0], 87.000000, 97.500000);
	PlayerTextDrawSetOutline(playerid, CharacterPreview[playerid][1][0], 0);
	PlayerTextDrawSetShadow(playerid, CharacterPreview[playerid][1][0], 0);
	PlayerTextDrawAlignment(playerid, CharacterPreview[playerid][1][0], 1);
	PlayerTextDrawColor(playerid, CharacterPreview[playerid][1][0], -1);
	PlayerTextDrawBackgroundColor(playerid, CharacterPreview[playerid][1][0], 0);
	PlayerTextDrawBoxColor(playerid, CharacterPreview[playerid][1][0], 255);
	PlayerTextDrawUseBox(playerid, CharacterPreview[playerid][1][0], 0);
	PlayerTextDrawSetProportional(playerid, CharacterPreview[playerid][1][0], 1);
	PlayerTextDrawSetSelectable(playerid, CharacterPreview[playerid][1][0], 1);
	PlayerTextDrawSetPreviewModel(playerid, CharacterPreview[playerid][1][0], 20);
	PlayerTextDrawSetPreviewRot(playerid, CharacterPreview[playerid][1][0], 0.000000, 0.000000, 1.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, CharacterPreview[playerid][1][0], 1, 1);

	CharacterPreview[playerid][2][0] = CreatePlayerTextDraw(playerid, 358.000000, 175.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, CharacterPreview[playerid][2][0], 5);
	PlayerTextDrawLetterSize(playerid, CharacterPreview[playerid][2][0], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, CharacterPreview[playerid][2][0], 87.000000, 97.500000);
	PlayerTextDrawSetOutline(playerid, CharacterPreview[playerid][2][0], 0);
	PlayerTextDrawSetShadow(playerid, CharacterPreview[playerid][2][0], 0);
	PlayerTextDrawAlignment(playerid, CharacterPreview[playerid][2][0], 1);
	PlayerTextDrawColor(playerid, CharacterPreview[playerid][2][0], -1);
	PlayerTextDrawBackgroundColor(playerid, CharacterPreview[playerid][2][0], 0);
	PlayerTextDrawBoxColor(playerid, CharacterPreview[playerid][2][0], 255);
	PlayerTextDrawUseBox(playerid, CharacterPreview[playerid][2][0], 0);
	PlayerTextDrawSetProportional(playerid, CharacterPreview[playerid][2][0], 1);
	PlayerTextDrawSetSelectable(playerid, CharacterPreview[playerid][2][0], 1);
	PlayerTextDrawSetPreviewModel(playerid, CharacterPreview[playerid][2][0], 20);
	PlayerTextDrawSetPreviewRot(playerid, CharacterPreview[playerid][2][0], 0.000000, 0.000000, 1.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, CharacterPreview[playerid][2][0], 1, 1);

    CharacterCreate[playerid][0][0] = CreatePlayerTextDraw(playerid, 240.000000, 214.000000, "Tao nhan vat");
	PlayerTextDrawFont(playerid, CharacterCreate[playerid][0][0], 1);
	PlayerTextDrawLetterSize(playerid, CharacterCreate[playerid][0][0], 0.141666, 1.100000);
	PlayerTextDrawTextSize(playerid, CharacterCreate[playerid][0][0], 16.500000, 55.500000);
	PlayerTextDrawSetOutline(playerid, CharacterCreate[playerid][0][0], 0);
	PlayerTextDrawSetShadow(playerid, CharacterCreate[playerid][0][0], 0);
	PlayerTextDrawAlignment(playerid, CharacterCreate[playerid][0][0], 2);
	PlayerTextDrawColor(playerid, CharacterCreate[playerid][0][0], 255);
	PlayerTextDrawBackgroundColor(playerid, CharacterCreate[playerid][0][0], 255);
	PlayerTextDrawBoxColor(playerid, CharacterCreate[playerid][0][0], 80);
	PlayerTextDrawUseBox(playerid, CharacterCreate[playerid][0][0], 1);
	PlayerTextDrawSetProportional(playerid, CharacterCreate[playerid][0][0], 1);
	PlayerTextDrawSetSelectable(playerid, CharacterCreate[playerid][0][0], 1);

	CharacterCreate[playerid][1][0] = CreatePlayerTextDraw(playerid, 321.000000, 214.000000, "Tao nhan vat");
	PlayerTextDrawFont(playerid, CharacterCreate[playerid][1][0], 1);
	PlayerTextDrawLetterSize(playerid, CharacterCreate[playerid][1][0], 0.141666, 1.100000);
	PlayerTextDrawTextSize(playerid, CharacterCreate[playerid][1][0], 16.500000, 55.500000);
	PlayerTextDrawSetOutline(playerid, CharacterCreate[playerid][1][0], 0);
	PlayerTextDrawSetShadow(playerid, CharacterCreate[playerid][1][0], 0);
	PlayerTextDrawAlignment(playerid, CharacterCreate[playerid][1][0], 2);
	PlayerTextDrawColor(playerid, CharacterCreate[playerid][1][0], 255);
	PlayerTextDrawBackgroundColor(playerid, CharacterCreate[playerid][1][0], 255);
	PlayerTextDrawBoxColor(playerid, CharacterCreate[playerid][1][0], 80);
	PlayerTextDrawUseBox(playerid, CharacterCreate[playerid][1][0], 1);
	PlayerTextDrawSetProportional(playerid, CharacterCreate[playerid][1][0], 1);
	PlayerTextDrawSetSelectable(playerid, CharacterCreate[playerid][1][0], 1);

	CharacterCreate[playerid][2][0] = CreatePlayerTextDraw(playerid, 400.000000, 214.000000, "Tao nhan vat");
	PlayerTextDrawFont(playerid, CharacterCreate[playerid][2][0], 1);
	PlayerTextDrawLetterSize(playerid, CharacterCreate[playerid][2][0], 0.141666, 1.100000);
	PlayerTextDrawTextSize(playerid, CharacterCreate[playerid][2][0], 16.500000, 55.500000);
	PlayerTextDrawSetOutline(playerid, CharacterCreate[playerid][2][0], 0);
	PlayerTextDrawSetShadow(playerid, CharacterCreate[playerid][2][0], 0);
	PlayerTextDrawAlignment(playerid, CharacterCreate[playerid][2][0], 2);
	PlayerTextDrawColor(playerid, CharacterCreate[playerid][2][0], 255);
	PlayerTextDrawBackgroundColor(playerid, CharacterCreate[playerid][2][0], 255);
	PlayerTextDrawBoxColor(playerid, CharacterCreate[playerid][2][0], 80);
	PlayerTextDrawUseBox(playerid, CharacterCreate[playerid][2][0], 1);
	PlayerTextDrawSetProportional(playerid, CharacterCreate[playerid][2][0], 1);
	PlayerTextDrawSetSelectable(playerid, CharacterCreate[playerid][2][0], 1);

	CharacterUsername[playerid][0][0] = CreatePlayerTextDraw(playerid, 239.000000, 289.000000, "Luu_Vu");
	PlayerTextDrawFont(playerid, CharacterUsername[playerid][0][0], 1);
	PlayerTextDrawLetterSize(playerid, CharacterUsername[playerid][0][0], 0.137500, 0.850000);
	PlayerTextDrawTextSize(playerid, CharacterUsername[playerid][0][0], 400.000000, 207.000000);
	PlayerTextDrawSetOutline(playerid, CharacterUsername[playerid][0][0], 0);
	PlayerTextDrawSetShadow(playerid, CharacterUsername[playerid][0][0], 0);
	PlayerTextDrawAlignment(playerid, CharacterUsername[playerid][0][0], 2);
	PlayerTextDrawColor(playerid, CharacterUsername[playerid][0][0], 255);
	PlayerTextDrawBackgroundColor(playerid, CharacterUsername[playerid][0][0], 255);
	PlayerTextDrawBoxColor(playerid, CharacterUsername[playerid][0][0], 50);
	PlayerTextDrawUseBox(playerid, CharacterUsername[playerid][0][0], 0);
	PlayerTextDrawSetProportional(playerid, CharacterUsername[playerid][0][0], 1);
	PlayerTextDrawSetSelectable(playerid, CharacterUsername[playerid][0][0], 0);

	CharacterUsername[playerid][1][0] = CreatePlayerTextDraw(playerid, 324.000000, 289.000000, "Luu_Vu");
	PlayerTextDrawFont(playerid, CharacterUsername[playerid][1][0], 1);
	PlayerTextDrawLetterSize(playerid, CharacterUsername[playerid][1][0], 0.137500, 0.850000);
	PlayerTextDrawTextSize(playerid, CharacterUsername[playerid][1][0], 400.000000, 207.000000);
	PlayerTextDrawSetOutline(playerid, CharacterUsername[playerid][1][0], 0);
	PlayerTextDrawSetShadow(playerid, CharacterUsername[playerid][1][0], 0);
	PlayerTextDrawAlignment(playerid, CharacterUsername[playerid][1][0], 2);
	PlayerTextDrawColor(playerid, CharacterUsername[playerid][1][0], 255);
	PlayerTextDrawBackgroundColor(playerid, CharacterUsername[playerid][1][0], 255);
	PlayerTextDrawBoxColor(playerid, CharacterUsername[playerid][1][0], 50);
	PlayerTextDrawUseBox(playerid, CharacterUsername[playerid][1][0], 0);
	PlayerTextDrawSetProportional(playerid, CharacterUsername[playerid][1][0], 1);
	PlayerTextDrawSetSelectable(playerid, CharacterUsername[playerid][1][0], 0);

	CharacterUsername[playerid][2][0] = CreatePlayerTextDraw(playerid, 401.000000, 289.000000, "Luu_Vu");
	PlayerTextDrawFont(playerid, CharacterUsername[playerid][2][0], 1);
	PlayerTextDrawLetterSize(playerid, CharacterUsername[playerid][2][0], 0.137500, 0.850000);
	PlayerTextDrawTextSize(playerid, CharacterUsername[playerid][2][0], 400.000000, 207.000000);
	PlayerTextDrawSetOutline(playerid, CharacterUsername[playerid][2][0], 0);
	PlayerTextDrawSetShadow(playerid, CharacterUsername[playerid][2][0], 0);
	PlayerTextDrawAlignment(playerid, CharacterUsername[playerid][2][0], 2);
	PlayerTextDrawColor(playerid, CharacterUsername[playerid][2][0], 255);
	PlayerTextDrawBackgroundColor(playerid, CharacterUsername[playerid][2][0], 255);
	PlayerTextDrawBoxColor(playerid, CharacterUsername[playerid][2][0], 50);
	PlayerTextDrawUseBox(playerid, CharacterUsername[playerid][2][0], 0);
	PlayerTextDrawSetProportional(playerid, CharacterUsername[playerid][2][0], 1);
	PlayerTextDrawSetSelectable(playerid, CharacterUsername[playerid][2][0], 0);

	CharacterStats[playerid][0] = CreatePlayerTextDraw(playerid, 319.000000, 309.000000, "_");
	PlayerTextDrawFont(playerid, CharacterStats[playerid][0], 1);
	PlayerTextDrawLetterSize(playerid, CharacterStats[playerid][0], 0.600000, 7.100004);
	PlayerTextDrawTextSize(playerid, CharacterStats[playerid][0], 298.500000, 240.000000);
	PlayerTextDrawSetOutline(playerid, CharacterStats[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, CharacterStats[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, CharacterStats[playerid][0], 2);
	PlayerTextDrawColor(playerid, CharacterStats[playerid][0], 255);
	PlayerTextDrawBackgroundColor(playerid, CharacterStats[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, CharacterStats[playerid][0], 255);
	PlayerTextDrawUseBox(playerid, CharacterStats[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, CharacterStats[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, CharacterStats[playerid][0], 0);

	CharacterStats[playerid][1] = CreatePlayerTextDraw(playerid, 319.000000, 310.000000, "_");
	PlayerTextDrawFont(playerid, CharacterStats[playerid][1], 1);
	PlayerTextDrawLetterSize(playerid, CharacterStats[playerid][1], 0.600000, 6.800004);
	PlayerTextDrawTextSize(playerid, CharacterStats[playerid][1], 298.500000, 237.500000);
	PlayerTextDrawSetOutline(playerid, CharacterStats[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, CharacterStats[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, CharacterStats[playerid][1], 2);
	PlayerTextDrawColor(playerid, CharacterStats[playerid][1], 255);
	PlayerTextDrawBackgroundColor(playerid, CharacterStats[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, CharacterStats[playerid][1], -62);
	PlayerTextDrawUseBox(playerid, CharacterStats[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, CharacterStats[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, CharacterStats[playerid][1], 0);

	CharacterStats[playerid][2] = CreatePlayerTextDraw(playerid, 202.000000, 312.000000, "Luu Vu~n~Nam~n~33 Tuoi~n~Nhan dang: Chim be");
	PlayerTextDrawFont(playerid, CharacterStats[playerid][2], 1);
	PlayerTextDrawLetterSize(playerid, CharacterStats[playerid][2], 0.137500, 0.850000);
	PlayerTextDrawTextSize(playerid, CharacterStats[playerid][2], 430.000000, 207.000000);
	PlayerTextDrawSetOutline(playerid, CharacterStats[playerid][2], 0);
	PlayerTextDrawSetShadow(playerid, CharacterStats[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, CharacterStats[playerid][2], 1);
	PlayerTextDrawColor(playerid, CharacterStats[playerid][2], 255);
	PlayerTextDrawBackgroundColor(playerid, CharacterStats[playerid][2], 255);
	PlayerTextDrawBoxColor(playerid, CharacterStats[playerid][2], 50);
	PlayerTextDrawUseBox(playerid, CharacterStats[playerid][2], 0);
	PlayerTextDrawSetProportional(playerid, CharacterStats[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, CharacterStats[playerid][2], 0);

	CharacterStats[playerid][3] = CreatePlayerTextDraw(playerid, 321.000000, 356.000000, "Bat dau choi");
	PlayerTextDrawFont(playerid, CharacterStats[playerid][3], 1);
	PlayerTextDrawLetterSize(playerid, CharacterStats[playerid][3], 0.141665, 1.100000);
	PlayerTextDrawTextSize(playerid, CharacterStats[playerid][3], 16.500000, 55.500000);
	PlayerTextDrawSetOutline(playerid, CharacterStats[playerid][3], 0);
	PlayerTextDrawSetShadow(playerid, CharacterStats[playerid][3], 0);
	PlayerTextDrawAlignment(playerid, CharacterStats[playerid][3], 2);
	PlayerTextDrawColor(playerid, CharacterStats[playerid][3], 255);
	PlayerTextDrawBackgroundColor(playerid, CharacterStats[playerid][3], 255);
	PlayerTextDrawBoxColor(playerid, CharacterStats[playerid][3], 80);
	PlayerTextDrawUseBox(playerid, CharacterStats[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, CharacterStats[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, CharacterStats[playerid][3], 1);

    return 1;
}

Login_OnplayerDisconnect(playerid)
{
	RemoveCharacterCreation(playerid);
	Login_Hide(playerid);
	Register_Hide(playerid);
	PlayerTextDrawDestroy(playerid, PlayerGPS[playerid][0]);
	PlayerTextDrawDestroy(playerid, PlayerGPS[playerid][1]);
	return 1;
}

RemoveCharacterCreation(playerid)
{
	for( new i = 0; i < 9; i ++)
	{
		PlayerTextDrawDestroy(playerid, CharacterMenu[playerid][i]);
	}
	for( new i = 0; i < 3; i ++)
	{
		PlayerTextDrawDestroy(playerid, CharacterPreview[playerid][i][0]);
	}
	for( new i = 0; i < 3; i ++)
	{
		PlayerTextDrawDestroy(playerid, CharacterCreate[playerid][i][0]);
	}
	for( new i = 0; i < 3; i ++)
	{
		PlayerTextDrawDestroy(playerid, CharacterUsername[playerid][i][0]);
	}
	for( new i = 0; i < 4; i ++)
	{
		PlayerTextDrawDestroy(playerid, CharacterStats[playerid][i]);
	}
	return 1;
}

LoadLoginTextDraws()
{
    Login_TD[0] = TextDrawCreate(-11.3903, -27.4165, "mdl-2901:bgblack"); // ïóñòî
	TextDrawTextSize(Login_TD[0], 701.0000, 516.0000);
	TextDrawAlignment(Login_TD[0], 1);
	TextDrawColor(Login_TD[0], -1);
	TextDrawBackgroundColor(Login_TD[0], 255);
	TextDrawFont(Login_TD[0], 4);
	TextDrawSetProportional(Login_TD[0], 0);
	TextDrawSetShadow(Login_TD[0], 0);

	Login_TD[1] = TextDrawCreate(201.7496, 152.7333, "mdl-2901:panel"); // ïóñòî
	TextDrawTextSize(Login_TD[1], 234.0000, 130.0000);
	TextDrawAlignment(Login_TD[1], 1);
	TextDrawColor(Login_TD[1], -1);
	TextDrawBackgroundColor(Login_TD[1], 255);
	TextDrawFont(Login_TD[1], 4);
	TextDrawSetProportional(Login_TD[1], 0);
	TextDrawSetShadow(Login_TD[1], 0);

	Login_TD[2] = TextDrawCreate(213.4996, 62.4165, "mdl-2901:logo"); // ïóñòî
	TextDrawTextSize(Login_TD[2], 209.0000, 75.0000);
	TextDrawAlignment(Login_TD[2], 1);
	TextDrawColor(Login_TD[2], -1);
	TextDrawBackgroundColor(Login_TD[2], 255);
	TextDrawFont(Login_TD[2], 4);
	TextDrawSetProportional(Login_TD[2], 0);
	TextDrawSetShadow(Login_TD[2], 0);

	Login_TD[3] = TextDrawCreate(417.1901, 253.3829, "mdl-2901:hint"); // ïóñòî
	TextDrawTextSize(Login_TD[3], 8.0000, 8.0000);
	TextDrawAlignment(Login_TD[3], 1);
	TextDrawColor(Login_TD[3], -1);
	TextDrawBackgroundColor(Login_TD[3], 255);
	TextDrawFont(Login_TD[3], 4);
	TextDrawSetProportional(Login_TD[3], 0);
	TextDrawSetShadow(Login_TD[3], 0);
	TextDrawSetSelectable(Login_TD[3], 1);
    return 1;
}

Login_Show(playerid)
{
	LoginGUIPTD[playerid][0] = CreatePlayerTextDraw(playerid, 225.3440, 236.7191, "Nhap_mat_khau"); // ïóñòî
	PlayerTextDrawLetterSize(playerid, LoginGUIPTD[playerid][0], 0.2321, 1.2091);
	PlayerTextDrawTextSize(playerid, LoginGUIPTD[playerid][0], 316.0000, 3.0000);
	PlayerTextDrawAlignment(playerid, LoginGUIPTD[playerid][0], 1);
	PlayerTextDrawColor(playerid, LoginGUIPTD[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, LoginGUIPTD[playerid][0], 255);
	PlayerTextDrawFont(playerid, LoginGUIPTD[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, LoginGUIPTD[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, LoginGUIPTD[playerid][0], 0);
	PlayerTextDrawSetSelectable(playerid, LoginGUIPTD[playerid][0], 1);

	LoginGUIPTD[playerid][1] = CreatePlayerTextDraw(playerid, 224.8755, 193.8166, "Simon_Nguyen"); // ïóñòî
	PlayerTextDrawLetterSize(playerid, LoginGUIPTD[playerid][1], 0.2321, 1.2091);
	PlayerTextDrawTextSize(playerid, LoginGUIPTD[playerid][1], 316.0000, 0.0000);
	PlayerTextDrawAlignment(playerid, LoginGUIPTD[playerid][1], 1);
	PlayerTextDrawColor(playerid, LoginGUIPTD[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, LoginGUIPTD[playerid][1], 255);
	PlayerTextDrawFont(playerid, LoginGUIPTD[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, LoginGUIPTD[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, LoginGUIPTD[playerid][1], 0);

    new name[MAX_PLAYER_NAME];
	format(name, sizeof(name), "%s", GetAccName(playerid));
	PlayerTextDrawSetString(playerid, LoginGUIPTD[playerid][1], name);
	for( new i = 0; i < 4; i ++) 
	{
		TextDrawShowForPlayer(playerid, Login_TD[i]);
		PlayerTextDrawShow(playerid, LoginGUIPTD[playerid][0]);
		PlayerTextDrawShow(playerid, LoginGUIPTD[playerid][1]);
        SelectTextDraw(playerid, 0x0C0C0CAA);
	}
	SetPlayerCameraMoving(playerid);
    return 1;
}

Login_Hide(playerid)
{
    for( new i = 0; i < 4; i ++) 
	{
		TextDrawHideForPlayer(playerid, Login_TD[i]);
		CancelSelectTextDraw(playerid);
		PlayerTextDrawHide(playerid, LoginGUIPTD[playerid][0]);
		PlayerTextDrawHide(playerid, LoginGUIPTD[playerid][1]);
		PlayerTextDrawDestroy(playerid, LoginGUIPTD[playerid][0]);
		PlayerTextDrawDestroy(playerid, LoginGUIPTD[playerid][1]);
	}
	for( new i = 0; i < 4; i ++)
	{
		PlayerTextDrawHide(playerid, CharacterStats[playerid][i]);
		PlayerTextDrawDestroy(playerid, CharacterStats[playerid][i]);
	}
    return 1;
}

LoadRegisterTextdraws(playerid)
{
	RegistrationGUI[playerid][0] = CreatePlayerTextDraw(playerid, 551.000000, 20.000000, "_");
	PlayerTextDrawFont(playerid, RegistrationGUI[playerid][0], 1);
	PlayerTextDrawLetterSize(playerid, RegistrationGUI[playerid][0], 0.600000, 40.649997);
	PlayerTextDrawTextSize(playerid, RegistrationGUI[playerid][0], 308.500000, 129.000000);
	PlayerTextDrawSetOutline(playerid, RegistrationGUI[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, RegistrationGUI[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, RegistrationGUI[playerid][0], 2);
	PlayerTextDrawColor(playerid, RegistrationGUI[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, RegistrationGUI[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, RegistrationGUI[playerid][0], 255);
	PlayerTextDrawUseBox(playerid, RegistrationGUI[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, RegistrationGUI[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, RegistrationGUI[playerid][0], 0);

	RegistrationGUI[playerid][1] = CreatePlayerTextDraw(playerid, 551.000000, 22.000000, "_");
	PlayerTextDrawFont(playerid, RegistrationGUI[playerid][1], 1);
	PlayerTextDrawLetterSize(playerid, RegistrationGUI[playerid][1], 0.600000, 40.150005);
	PlayerTextDrawTextSize(playerid, RegistrationGUI[playerid][1], 308.500000, 126.000000);
	PlayerTextDrawSetOutline(playerid, RegistrationGUI[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, RegistrationGUI[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, RegistrationGUI[playerid][1], 2);
	PlayerTextDrawColor(playerid, RegistrationGUI[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, RegistrationGUI[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, RegistrationGUI[playerid][1], -741092353);
	PlayerTextDrawUseBox(playerid, RegistrationGUI[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, RegistrationGUI[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, RegistrationGUI[playerid][1], 0);

	RegistrationGUI[playerid][2] = CreatePlayerTextDraw(playerid, 461.000000, 39.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, RegistrationGUI[playerid][2], 5);
	PlayerTextDrawLetterSize(playerid, RegistrationGUI[playerid][2], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, RegistrationGUI[playerid][2], 178.500000, 181.000000);
	PlayerTextDrawSetOutline(playerid, RegistrationGUI[playerid][2], 0);
	PlayerTextDrawSetShadow(playerid, RegistrationGUI[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, RegistrationGUI[playerid][2], 1);
	PlayerTextDrawColor(playerid, RegistrationGUI[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, RegistrationGUI[playerid][2], 0);
	PlayerTextDrawBoxColor(playerid, RegistrationGUI[playerid][2], 0);
	PlayerTextDrawUseBox(playerid, RegistrationGUI[playerid][2], 0);
	PlayerTextDrawSetProportional(playerid, RegistrationGUI[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, RegistrationGUI[playerid][2], 0);
	PlayerTextDrawSetPreviewModel(playerid, RegistrationGUI[playerid][2], 0);
	PlayerTextDrawSetPreviewRot(playerid, RegistrationGUI[playerid][2], -10.000000, 0.000000, -3.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, RegistrationGUI[playerid][2], 1, 1);

	RegistrationGUI[playerid][3] = CreatePlayerTextDraw(playerid, 551.000000, 100.000000, "_");
	PlayerTextDrawFont(playerid, RegistrationGUI[playerid][3], 1);
	PlayerTextDrawLetterSize(playerid, RegistrationGUI[playerid][3], 0.600000, 31.200027);
	PlayerTextDrawTextSize(playerid, RegistrationGUI[playerid][3], 308.500000, 126.000000);
	PlayerTextDrawSetOutline(playerid, RegistrationGUI[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, RegistrationGUI[playerid][3], 0);
	PlayerTextDrawAlignment(playerid, RegistrationGUI[playerid][3], 2);
	PlayerTextDrawColor(playerid, RegistrationGUI[playerid][3], -1);
	PlayerTextDrawBackgroundColor(playerid, RegistrationGUI[playerid][3], 255);
	PlayerTextDrawBoxColor(playerid, RegistrationGUI[playerid][3], -741092353);
	PlayerTextDrawUseBox(playerid, RegistrationGUI[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, RegistrationGUI[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, RegistrationGUI[playerid][3], 0);

	RegistrationGUI[playerid][4] = CreatePlayerTextDraw(playerid, 551.000000, 21.000000, "TAO NHAN VAT");
	PlayerTextDrawFont(playerid, RegistrationGUI[playerid][4], 1);
	PlayerTextDrawLetterSize(playerid, RegistrationGUI[playerid][4], 0.183332, 1.199998);
	PlayerTextDrawTextSize(playerid, RegistrationGUI[playerid][4], 460.000000, 126.000000);
	PlayerTextDrawSetOutline(playerid, RegistrationGUI[playerid][4], 0);
	PlayerTextDrawSetShadow(playerid, RegistrationGUI[playerid][4], 0);
	PlayerTextDrawAlignment(playerid, RegistrationGUI[playerid][4], 2);
	PlayerTextDrawColor(playerid, RegistrationGUI[playerid][4], 255);
	PlayerTextDrawBackgroundColor(playerid, RegistrationGUI[playerid][4], 255);
	PlayerTextDrawBoxColor(playerid, RegistrationGUI[playerid][4], 50);
	PlayerTextDrawUseBox(playerid, RegistrationGUI[playerid][4], 1);
	PlayerTextDrawSetProportional(playerid, RegistrationGUI[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid, RegistrationGUI[playerid][4], 0);

	RegistrationGUI[playerid][5] = CreatePlayerTextDraw(playerid, 552.000000, 102.000000, "Nhan dang");
	PlayerTextDrawFont(playerid, RegistrationGUI[playerid][5], 2);
	PlayerTextDrawLetterSize(playerid, RegistrationGUI[playerid][5], 0.154165, 1.000000);
	PlayerTextDrawTextSize(playerid, RegistrationGUI[playerid][5], 16.500000, 90.500000);
	PlayerTextDrawSetOutline(playerid, RegistrationGUI[playerid][5], 0);
	PlayerTextDrawSetShadow(playerid, RegistrationGUI[playerid][5], 0);
	PlayerTextDrawAlignment(playerid, RegistrationGUI[playerid][5], 2);
	PlayerTextDrawColor(playerid, RegistrationGUI[playerid][5], 255);
	PlayerTextDrawBackgroundColor(playerid, RegistrationGUI[playerid][5], 255);
	PlayerTextDrawBoxColor(playerid, RegistrationGUI[playerid][5], 200);
	PlayerTextDrawUseBox(playerid, RegistrationGUI[playerid][5], 0);
	PlayerTextDrawSetProportional(playerid, RegistrationGUI[playerid][5], 1);
	PlayerTextDrawSetSelectable(playerid, RegistrationGUI[playerid][5], 1);

	RegistrationGUI[playerid][6] = CreatePlayerTextDraw(playerid, 489.000000, 137.000000, "Ten nhan vat:");
	PlayerTextDrawFont(playerid, RegistrationGUI[playerid][6], 2);
	PlayerTextDrawLetterSize(playerid, RegistrationGUI[playerid][6], 0.116666, 1.050000);
	PlayerTextDrawTextSize(playerid, RegistrationGUI[playerid][6], 614.500000, 17.000000);
	PlayerTextDrawSetOutline(playerid, RegistrationGUI[playerid][6], 0);
	PlayerTextDrawSetShadow(playerid, RegistrationGUI[playerid][6], 0);
	PlayerTextDrawAlignment(playerid, RegistrationGUI[playerid][6], 1);
	PlayerTextDrawColor(playerid, RegistrationGUI[playerid][6], 255);
	PlayerTextDrawBackgroundColor(playerid, RegistrationGUI[playerid][6], 255);
	PlayerTextDrawBoxColor(playerid, RegistrationGUI[playerid][6], 50);
	PlayerTextDrawUseBox(playerid, RegistrationGUI[playerid][6], 1);
	PlayerTextDrawSetProportional(playerid, RegistrationGUI[playerid][6], 1);
	PlayerTextDrawSetSelectable(playerid, RegistrationGUI[playerid][6], 1);

	RegistrationGUI[playerid][7] = CreatePlayerTextDraw(playerid, 489.000000, 168.000000, "Tuoi:");
	PlayerTextDrawFont(playerid, RegistrationGUI[playerid][7], 2);
	PlayerTextDrawLetterSize(playerid, RegistrationGUI[playerid][7], 0.116666, 1.050000);
	PlayerTextDrawTextSize(playerid, RegistrationGUI[playerid][7], 614.500000, 17.000000);
	PlayerTextDrawSetOutline(playerid, RegistrationGUI[playerid][7], 0);
	PlayerTextDrawSetShadow(playerid, RegistrationGUI[playerid][7], 0);
	PlayerTextDrawAlignment(playerid, RegistrationGUI[playerid][7], 1);
	PlayerTextDrawColor(playerid, RegistrationGUI[playerid][7], 255);
	PlayerTextDrawBackgroundColor(playerid, RegistrationGUI[playerid][7], 255);
	PlayerTextDrawBoxColor(playerid, RegistrationGUI[playerid][7], 50);
	PlayerTextDrawUseBox(playerid, RegistrationGUI[playerid][7], 1);
	PlayerTextDrawSetProportional(playerid, RegistrationGUI[playerid][7], 1);
	PlayerTextDrawSetSelectable(playerid, RegistrationGUI[playerid][7], 1);

	RegistrationGUI[playerid][8] = CreatePlayerTextDraw(playerid, 489.000000, 199.000000, "Ngay sinh:");
	PlayerTextDrawFont(playerid, RegistrationGUI[playerid][8], 2);
	PlayerTextDrawLetterSize(playerid, RegistrationGUI[playerid][8], 0.116666, 1.050000);
	PlayerTextDrawTextSize(playerid, RegistrationGUI[playerid][8], 614.500000, 17.000000);
	PlayerTextDrawSetOutline(playerid, RegistrationGUI[playerid][8], 0);
	PlayerTextDrawSetShadow(playerid, RegistrationGUI[playerid][8], 0);
	PlayerTextDrawAlignment(playerid, RegistrationGUI[playerid][8], 1);
	PlayerTextDrawColor(playerid, RegistrationGUI[playerid][8], 255);
	PlayerTextDrawBackgroundColor(playerid, RegistrationGUI[playerid][8], 255);
	PlayerTextDrawBoxColor(playerid, RegistrationGUI[playerid][8], 50);
	PlayerTextDrawUseBox(playerid, RegistrationGUI[playerid][8], 1);
	PlayerTextDrawSetProportional(playerid, RegistrationGUI[playerid][8], 1);
	PlayerTextDrawSetSelectable(playerid, RegistrationGUI[playerid][8], 1);

	RegistrationGUI[playerid][9] = CreatePlayerTextDraw(playerid, 489.000000, 230.000000, "Gioi tinh:");
	PlayerTextDrawFont(playerid, RegistrationGUI[playerid][9], 2);
	PlayerTextDrawLetterSize(playerid, RegistrationGUI[playerid][9], 0.116666, 1.050000);
	PlayerTextDrawTextSize(playerid, RegistrationGUI[playerid][9], 614.500000, 17.000000);
	PlayerTextDrawSetOutline(playerid, RegistrationGUI[playerid][9], 0);
	PlayerTextDrawSetShadow(playerid, RegistrationGUI[playerid][9], 0);
	PlayerTextDrawAlignment(playerid, RegistrationGUI[playerid][9], 1);
	PlayerTextDrawColor(playerid, RegistrationGUI[playerid][9], 255);
	PlayerTextDrawBackgroundColor(playerid, RegistrationGUI[playerid][9], 255);
	PlayerTextDrawBoxColor(playerid, RegistrationGUI[playerid][9], 50);
	PlayerTextDrawUseBox(playerid, RegistrationGUI[playerid][9], 1);
	PlayerTextDrawSetProportional(playerid, RegistrationGUI[playerid][9], 1);
	PlayerTextDrawSetSelectable(playerid, RegistrationGUI[playerid][9], 1);

	RegistrationGUI[playerid][10] = CreatePlayerTextDraw(playerid, 489.000000, 263.000000, "Mo ta:");
	PlayerTextDrawFont(playerid, RegistrationGUI[playerid][10], 2);
	PlayerTextDrawLetterSize(playerid, RegistrationGUI[playerid][10], 0.116666, 1.050000);
	PlayerTextDrawTextSize(playerid, RegistrationGUI[playerid][10], 614.500000, 17.000000);
	PlayerTextDrawSetOutline(playerid, RegistrationGUI[playerid][10], 0);
	PlayerTextDrawSetShadow(playerid, RegistrationGUI[playerid][10], 0);
	PlayerTextDrawAlignment(playerid, RegistrationGUI[playerid][10], 1);
	PlayerTextDrawColor(playerid, RegistrationGUI[playerid][10], 255);
	PlayerTextDrawBackgroundColor(playerid, RegistrationGUI[playerid][10], 255);
	PlayerTextDrawBoxColor(playerid, RegistrationGUI[playerid][10], 50);
	PlayerTextDrawUseBox(playerid, RegistrationGUI[playerid][10], 1);
	PlayerTextDrawSetProportional(playerid, RegistrationGUI[playerid][10], 1);
	PlayerTextDrawSetSelectable(playerid, RegistrationGUI[playerid][10], 1);

	RegistrationGUI[playerid][11] = CreatePlayerTextDraw(playerid, 552.000000, 337.000000, "Tao");
	PlayerTextDrawFont(playerid, RegistrationGUI[playerid][11], 2);
	PlayerTextDrawLetterSize(playerid, RegistrationGUI[playerid][11], 0.154165, 1.000000);
	PlayerTextDrawTextSize(playerid, RegistrationGUI[playerid][11], 16.500000, 90.500000);
	PlayerTextDrawSetOutline(playerid, RegistrationGUI[playerid][11], 0);
	PlayerTextDrawSetShadow(playerid, RegistrationGUI[playerid][11], 0);
	PlayerTextDrawAlignment(playerid, RegistrationGUI[playerid][11], 2);
	PlayerTextDrawColor(playerid, RegistrationGUI[playerid][11], 255);
	PlayerTextDrawBackgroundColor(playerid, RegistrationGUI[playerid][11], 255);
	PlayerTextDrawBoxColor(playerid, RegistrationGUI[playerid][11], 200);
	PlayerTextDrawUseBox(playerid, RegistrationGUI[playerid][11], 0);
	PlayerTextDrawSetProportional(playerid, RegistrationGUI[playerid][11], 1);
	PlayerTextDrawSetSelectable(playerid, RegistrationGUI[playerid][11], 1);

	RegistrationGUI[playerid][12] = CreatePlayerTextDraw(playerid, 551.000000, 153.000000, "");
	PlayerTextDrawFont(playerid, RegistrationGUI[playerid][12], 1);
	PlayerTextDrawLetterSize(playerid, RegistrationGUI[playerid][12], 0.141666, 0.899999);
	PlayerTextDrawTextSize(playerid, RegistrationGUI[playerid][12], 460.000000, 126.000000);
	PlayerTextDrawSetOutline(playerid, RegistrationGUI[playerid][12], 0);
	PlayerTextDrawSetShadow(playerid, RegistrationGUI[playerid][12], 0);
	PlayerTextDrawAlignment(playerid, RegistrationGUI[playerid][12], 2);
	PlayerTextDrawColor(playerid, RegistrationGUI[playerid][12], 255);
	PlayerTextDrawBackgroundColor(playerid, RegistrationGUI[playerid][12], 255);
	PlayerTextDrawBoxColor(playerid, RegistrationGUI[playerid][12], 50);
	PlayerTextDrawUseBox(playerid, RegistrationGUI[playerid][12], 1);
	PlayerTextDrawSetProportional(playerid, RegistrationGUI[playerid][12], 1);
	PlayerTextDrawSetSelectable(playerid, RegistrationGUI[playerid][12], 0);

	RegistrationGUI[playerid][13] = CreatePlayerTextDraw(playerid, 551.000000, 184.000000, "");
	PlayerTextDrawFont(playerid, RegistrationGUI[playerid][13], 1);
	PlayerTextDrawLetterSize(playerid, RegistrationGUI[playerid][13], 0.141666, 0.899999);
	PlayerTextDrawTextSize(playerid, RegistrationGUI[playerid][13], 460.000000, 126.000000);
	PlayerTextDrawSetOutline(playerid, RegistrationGUI[playerid][13], 0);
	PlayerTextDrawSetShadow(playerid, RegistrationGUI[playerid][13], 0);
	PlayerTextDrawAlignment(playerid, RegistrationGUI[playerid][13], 2);
	PlayerTextDrawColor(playerid, RegistrationGUI[playerid][13], 255);
	PlayerTextDrawBackgroundColor(playerid, RegistrationGUI[playerid][13], 255);
	PlayerTextDrawBoxColor(playerid, RegistrationGUI[playerid][13], 50);
	PlayerTextDrawUseBox(playerid, RegistrationGUI[playerid][13], 1);
	PlayerTextDrawSetProportional(playerid, RegistrationGUI[playerid][13], 1);
	PlayerTextDrawSetSelectable(playerid, RegistrationGUI[playerid][13], 0);

	RegistrationGUI[playerid][14] = CreatePlayerTextDraw(playerid, 551.000000, 215.000000, "");
	PlayerTextDrawFont(playerid, RegistrationGUI[playerid][14], 1);
	PlayerTextDrawLetterSize(playerid, RegistrationGUI[playerid][14], 0.141666, 0.899999);
	PlayerTextDrawTextSize(playerid, RegistrationGUI[playerid][14], 460.000000, 126.000000);
	PlayerTextDrawSetOutline(playerid, RegistrationGUI[playerid][14], 0);
	PlayerTextDrawSetShadow(playerid, RegistrationGUI[playerid][14], 0);
	PlayerTextDrawAlignment(playerid, RegistrationGUI[playerid][14], 2);
	PlayerTextDrawColor(playerid, RegistrationGUI[playerid][14], 255);
	PlayerTextDrawBackgroundColor(playerid, RegistrationGUI[playerid][14], 255);
	PlayerTextDrawBoxColor(playerid, RegistrationGUI[playerid][14], 50);
	PlayerTextDrawUseBox(playerid, RegistrationGUI[playerid][14], 1);
	PlayerTextDrawSetProportional(playerid, RegistrationGUI[playerid][14], 1);
	PlayerTextDrawSetSelectable(playerid, RegistrationGUI[playerid][14], 0);

	RegistrationGUI[playerid][15] = CreatePlayerTextDraw(playerid, 551.000000, 246.000000, "");
	PlayerTextDrawFont(playerid, RegistrationGUI[playerid][15], 1);
	PlayerTextDrawLetterSize(playerid, RegistrationGUI[playerid][15], 0.141666, 0.899999);
	PlayerTextDrawTextSize(playerid, RegistrationGUI[playerid][15], 460.000000, 126.000000);
	PlayerTextDrawSetOutline(playerid, RegistrationGUI[playerid][15], 0);
	PlayerTextDrawSetShadow(playerid, RegistrationGUI[playerid][15], 0);
	PlayerTextDrawAlignment(playerid, RegistrationGUI[playerid][15], 2);
	PlayerTextDrawColor(playerid, RegistrationGUI[playerid][15], 255);
	PlayerTextDrawBackgroundColor(playerid, RegistrationGUI[playerid][15], 255);
	PlayerTextDrawBoxColor(playerid, RegistrationGUI[playerid][15], 50);
	PlayerTextDrawUseBox(playerid, RegistrationGUI[playerid][15], 1);
	PlayerTextDrawSetProportional(playerid, RegistrationGUI[playerid][15], 1);
	PlayerTextDrawSetSelectable(playerid, RegistrationGUI[playerid][15], 0);

	RegistrationGUI[playerid][16] = CreatePlayerTextDraw(playerid, 551.000000, 279.000000, "");
	PlayerTextDrawFont(playerid, RegistrationGUI[playerid][16], 1);
	PlayerTextDrawLetterSize(playerid, RegistrationGUI[playerid][16], 0.141666, 0.899999);
	PlayerTextDrawTextSize(playerid, RegistrationGUI[playerid][16], 460.000000, 126.000000);
	PlayerTextDrawSetOutline(playerid, RegistrationGUI[playerid][16], 0);
	PlayerTextDrawSetShadow(playerid, RegistrationGUI[playerid][16], 0);
	PlayerTextDrawAlignment(playerid, RegistrationGUI[playerid][16], 2);
	PlayerTextDrawColor(playerid, RegistrationGUI[playerid][16], 255);
	PlayerTextDrawBackgroundColor(playerid, RegistrationGUI[playerid][16], 255);
	PlayerTextDrawBoxColor(playerid, RegistrationGUI[playerid][16], 50);
	PlayerTextDrawUseBox(playerid, RegistrationGUI[playerid][16], 1);
	PlayerTextDrawSetProportional(playerid, RegistrationGUI[playerid][16], 1);
	PlayerTextDrawSetSelectable(playerid, RegistrationGUI[playerid][16], 0);
	return 1;
}

LoadPlayerGPS(playerid)
{
	PlayerGPS[playerid][0] = CreatePlayerTextDraw(playerid, 95.000000, 405.000000, "NW l");
	PlayerTextDrawFont(playerid, PlayerGPS[playerid][0], 1);
	PlayerTextDrawLetterSize(playerid, PlayerGPS[playerid][0], 0.329165, 1.999999);
	PlayerTextDrawTextSize(playerid, PlayerGPS[playerid][0], 196.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PlayerGPS[playerid][0], 0);
	PlayerTextDrawSetShadow(playerid, PlayerGPS[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, PlayerGPS[playerid][0], 1);
	PlayerTextDrawColor(playerid, PlayerGPS[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerGPS[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, PlayerGPS[playerid][0], 50);
	PlayerTextDrawUseBox(playerid, PlayerGPS[playerid][0], 0);
	PlayerTextDrawSetProportional(playerid, PlayerGPS[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerGPS[playerid][0], 0);

	PlayerGPS[playerid][1] = CreatePlayerTextDraw(playerid, 129.000000, 407.000000, "Red County~n~Test");
	PlayerTextDrawFont(playerid, PlayerGPS[playerid][1], 1);
	PlayerTextDrawLetterSize(playerid, PlayerGPS[playerid][1], 0.162498, 0.799997);
	PlayerTextDrawTextSize(playerid, PlayerGPS[playerid][1], 231.000000, 82.000000);
	PlayerTextDrawSetOutline(playerid, PlayerGPS[playerid][1], 0);
	PlayerTextDrawSetShadow(playerid, PlayerGPS[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, PlayerGPS[playerid][1], 1);
	PlayerTextDrawColor(playerid, PlayerGPS[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerGPS[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, PlayerGPS[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, PlayerGPS[playerid][1], 0);
	PlayerTextDrawSetProportional(playerid, PlayerGPS[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerGPS[playerid][1], 0);

	PlayerTextDrawShow(playerid, PlayerGPS[playerid][0]);
	PlayerTextDrawShow(playerid, PlayerGPS[playerid][1]);
	return 1;
}

Register_Show(playerid)
{
	for(new i = 0; i<52; i++) EnableAntiCheatForPlayer(playerid, i, 0);
	pTemp[playerid][pRegisterScreen] = 1;
	TogglePlayerSpectating(playerid, false);
    LoadRegisterTextdraws(playerid);
	SetPlayerPosEx(playerid, 946.6671,924.0620,1001.0100);
	SetPlayerFacingAngle(playerid, 270.0);
	SetPlayerCameraPos(playerid, 948.8796, 923.9160, 1001.5840);
	SetPlayerCameraLookAt(playerid, 947.8801, 923.9253, 1001.5513);
	SetInterior(playerid, -1);
	SetWorld(playerid, playerid + 10);
	FreezePlayer(playerid);
	for( new i = 0; i < 17; i ++) 
	{
		PlayerTextDrawShow(playerid, RegistrationGUI[playerid][i]);
        SelectTextDraw(playerid, 0x0C0C0CAA);
	}
	RemoveCharacterCreation(playerid);
    return 1;
}

Register_Hide(playerid)
{
    for( new i = 0; i < 17; i ++) 
	{
		PlayerTextDrawHide(playerid, RegistrationGUI[playerid][i]);
		PlayerTextDrawDestroy(playerid, RegistrationGUI[playerid][i]);
	}
    return 1;
}

UpdateRegister(playerid, type = 0, input)
{
	new string[2048];
	if(type == 0) // Skin ID
	{
		PlayerTextDrawSetPreviewModel(playerid, RegistrationGUI[playerid][2], input);
		PlayerTextDrawShow(playerid, RegistrationGUI[playerid][2]);
		SetPVarInt(playerid, #CharSkin, input);
		RegisterClicked[playerid] = 0;
		SetPlayerSkin(playerid, input);
	}
	if(type == 1) // Character Age
	{
		format(string, sizeof(string), "%i tuoi", input);
		PlayerTextDrawSetString(playerid, RegistrationGUI[playerid][13], string);
		RegisterClicked[playerid] = 0;
	}
	if(type == 2) // Character Gender
	{
		format(string, sizeof(string), "%s", (input==1)?("Nam"):("Nu"));
		PlayerTextDrawSetString(playerid, RegistrationGUI[playerid][15], string);
		SetPVarInt(playerid, #CharGender, input);
		RegisterClicked[playerid] = 0;
	}
	return 1;
}

UpdateRegisterText(playerid, type, const text[])
{
	new string[2048];
	if(type == 0) // Character Name
	{
		format(string, sizeof(string), "%s", text);
		PlayerTextDrawSetString(playerid, RegistrationGUI[playerid][12], string);
		SetPVarString(playerid, #CharName, text);
		RegisterClicked[playerid] = 0;
	}
	if(type == 1) // Character Attributes
	{
		format(string, sizeof(string), "%s", text);
		PlayerTextDrawSetString(playerid, RegistrationGUI[playerid][16], string);
		SetPVarString(playerid, #CharAppearance, text);
		RegisterClicked[playerid] = 0;
	}
	if(type == 2) // Character Date of Birth
	{
		format(string, sizeof(string), "%s", text);
		PlayerTextDrawSetString(playerid, RegistrationGUI[playerid][14], string);
		SetPVarString(playerid, #CharBirth, text);
		RegisterClicked[playerid] = 0;
	}
	return 1;
}

this::Reg_OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
	if(pTemp[playerid][pRegisterScreen])
	{
		if(playertextid == CharacterCreate[playerid][0][0])
		{
			return Register_Show(playerid);
		}
		if(playertextid == CharacterCreate[playerid][1][0])
		{
			return Register_Show(playerid);
		}
		if(playertextid == CharacterCreate[playerid][2][0])
		{
			return Register_Show(playerid);
		}
		if(playertextid == RegistrationGUI[playerid][5]) // Character Skin
		{
			if(RegisterClicked[playerid] == 0)
			{
				RegisterClicked[playerid] = 1;
				return Dialog_Show(playerid, CharSkinSelect, DIALOG_STYLE_INPUT, "Los Santos Roleplay - Citizen Registration", "Nhap ID Skin mong muon cua ban\nLuu y: ID Skin khong duoc nho hon 0 va khong duoc lon hon 311.", ">>>", "");
			}
		}
		if(playertextid == RegistrationGUI[playerid][6]) // Character Name
		{
			if(RegisterClicked[playerid] == 0)
			{
				RegisterClicked[playerid] = 1;
				return Dialog_Show(playerid, CreateCharacter, DIALOG_STYLE_INPUT, "Los Santos Roleplay - Citizen Registration", "Nhap ten cua nhan vat:", ">>>", "Quay lai");
			}

		}
		if(playertextid == RegistrationGUI[playerid][7]) // Character Age
		{
			if(RegisterClicked[playerid] == 0)
			{
				RegisterClicked[playerid] = 1;
				return Dialog_Show(playerid, CharAge, DIALOG_STYLE_INPUT, "Los Santos Roleplay - Citizen Registration", "Nhap Tuoi nhan vat mong muon cua ban\nLuu y: Dieu nay phai cang thuc te cang tot.", ">>>", "");
			}

		}
		if(playertextid == RegistrationGUI[playerid][8]) // Character Birthdate
		{
			if(RegisterClicked[playerid] == 0)
			{
				RegisterClicked[playerid] = 1;
				return Dialog_Show(playerid, CharMonth, DIALOG_STYLE_LIST, "Los Santos Roleplay - Citizen Registration", "Thang 1\nThang 2\nThang 3\nThang 4\nThang 5\nThang 6\nThang 7\nThang 8\nThang 9\nThang 10\nThang 11\nThang 12", ">>>", "");
			}

		}
		if(playertextid == RegistrationGUI[playerid][9]) // Character Gender
		{
			if(RegisterClicked[playerid] == 0)
			{
				RegisterClicked[playerid] = 1;
				return Dialog_Show(playerid, CharGender, DIALOG_STYLE_LIST, "Los Santos Roleplay - Citizen Registration", "Nam\nNu", ">>>", "");
			}

		}
		if(playertextid == RegistrationGUI[playerid][10]) // Character Appearance
		{
			if(RegisterClicked[playerid] == 0)
			{
				RegisterClicked[playerid] = 1;
				return Dialog_Show(playerid, CharAppearance, DIALOG_STYLE_INPUT, "Los Santos Roleplay - Citizen Registration", "Nhap ngoai hinh nhan vat mong muon cua ban\nVi du: Cao 1m7, Nang 69kg, 20-30 tuoi, co bap bi ran, co mot hinh xam o tay.", ">>>", "");
			}

		}
		if(playertextid == RegistrationGUI[playerid][11])
		{
			new name[MAX_PLAYER_NAME], appearance[128], birthdate[128], query[1064];
			
			if(GetPVarString(playerid, #CharName, name, 24) == 0)
			{
				RegisterClicked[playerid] = 1;
				return Dialog_Show(playerid, CreateCharacter, DIALOG_STYLE_INPUT, "Los Santos Roleplay - Citizen Registration", "Nhap ten cua nhan vat:", ">>>", "Quay lai");
			}
			if(GetPVarString(playerid, #CharAppearance, appearance, 128) == 0)
			{
				RegisterClicked[playerid] = 1;
				return Dialog_Show(playerid, CharAppearance, DIALOG_STYLE_INPUT, "Los Santos Roleplay - Citizen Registration", "Nhap ngoai hinh nhan vat mong muon cua ban\nVi du: Cao 1m7, Nang 69kg, 20-30 tuoi, co bap bi ran, co mot hinh xam o tay.", ">>>", "");
			}
			if(GetPVarString(playerid, #CharBirth, birthdate, 128) == 0)
			{
				RegisterClicked[playerid] = 1;
				return Dialog_Show(playerid, CharMonth, DIALOG_STYLE_LIST, "Los Santos Roleplay - Citizen Registration", "Thang 1\nThang 2\nThang 3\nThang 4\nThang 5\nThang 6\nThang 7\nThang 8\nThang 9\nThang 10\nThang 11\nThang 12", ">>>", "");
			}
			if(GetPVarInt(playerid, #CharSkin) == 0)
			{
				RegisterClicked[playerid] = 1;
				return Dialog_Show(playerid, CharSkinSelect, DIALOG_STYLE_INPUT, "Los Santos Roleplay - Citizen Registration", "Nhap ID Skin mong muon cua ban\nLuu y: ID Skin khong duoc nho hon 0 va khong duoc lon hon 311.", ">>>", "");
			}
			if(GetPVarInt(playerid, #CharGender) == 0)
			{
				RegisterClicked[playerid] = 1;
				return Dialog_Show(playerid, CharGender, DIALOG_STYLE_LIST, "Los Santos Roleplay - Citizen Registration", "Nam\nNu", ">>>", "");
			}
			if(RegisterClicked[playerid] == 0)
			{
				GetPVarString(playerid, #CharName, name, 24);
				GetPVarString(playerid, #CharAppearance, appearance, 128);
				GetPVarString(playerid, #CharBirth, birthdate, 128);

				mysql_format(dbHandle, query, sizeof(query), "INSERT INTO `users` (`accountid`,`name`,`appearance`,`birthdate`, `age`, `skin`,`sex`,`status`) VALUES (%i,'%e','%e','%e',%i,%i,%i,1)", PlayerInfo[playerid][pAccID], name, appearance, birthdate, GetPVarInt(playerid, #CharacterAge), GetPVarInt(playerid, #CharSkin), GetPVarInt(playerid, #CharGender));
				mysql_tquery(dbHandle, query);

				Register_Hide(playerid);
				DeletePVar(playerid, #CharName);
				DeletePVar(playerid, #CharAppearance);
				DeletePVar(playerid, #CharBirth);
				DeletePVar(playerid, #CharSkin);
				DeletePVar(playerid, #CharGender);
				ShowCharacterMenu(playerid);
				return 1;
			}

		}
	}
	return 1;
}


CS_OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
	if(pTemp[playerid][pCharacterScreen])
	{
		if(playertextid == CharacterPreview[playerid][0][0])
		{
			new sql, query[1064];
			sql = CharSelectSQL[playerid][0];
			SetPVarInt(playerid, #CharSelect, sql);
			for( new i = 0; i < 4; i ++) 
			{
				PlayerTextDrawShow(playerid, CharacterStats[playerid][i]);
				mysql_format(dbHandle, query, sizeof(query), "SELECT * FROM `users` WHERE `id` = %i", sql);
				mysql_tquery(dbHandle, query, "UpdateCharacterStats", "i", playerid);
			}
		}
		if(playertextid == CharacterPreview[playerid][1][0])
		{
			new sql, query[1064];
			sql = CharSelectSQL[playerid][1];
			SetPVarInt(playerid, #CharSelect, sql);
			for( new i = 0; i < 4; i ++) 
			{
				PlayerTextDrawShow(playerid, CharacterStats[playerid][i]);
				mysql_format(dbHandle, query, sizeof(query), "SELECT * FROM `users` WHERE `id` = %i", sql);
				mysql_tquery(dbHandle, query, "UpdateCharacterStats", "i", playerid);
			}
		}
		if(playertextid == CharacterPreview[playerid][2][0])
		{
			new sql, query[1064];
			sql = CharSelectSQL[playerid][2];
			SetPVarInt(playerid, #CharSelect, sql);
			for( new i = 0; i < 4; i ++) 
			{
				PlayerTextDrawShow(playerid, CharacterStats[playerid][i]);
				mysql_format(dbHandle, query, sizeof(query), "SELECT * FROM `users` WHERE `id` = %i", sql);
				mysql_tquery(dbHandle, query, "UpdateCharacterStats", "i", playerid);
			}
		}
		if(playertextid == CharacterStats[playerid][3])
		{
			new query[256];
			format(query, sizeof(query), "SELECT users.*, accounts.admin, accounts.admin_code, accounts.donate, accounts.helper, accounts.name_changes, accounts.number_changes FROM users, accounts WHERE users.id = %i AND users.accountid = accounts.id", GetPVarInt(playerid, #CharSelect));
			mysql_tquery(dbHandle, query, "LoadCharacter", "i", playerid);

			CancelSelectTextDraw(playerid);
			RemoveCharacterCreation(playerid);
		}
	}
	return 1;
}

LL_OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
	if(pTemp[playerid][pLoggedScreen] == 0)
	{
		if(playertextid == LoginGUIPTD[playerid][0]) // Input Password
		{
			static const str_size[] = "Vui long nhap mat khau tai khoan cua ban de tien hanh dang nhap"; //���� �����������

			new mes[sizeof(str_size)];

			format(mes, sizeof(mes), str_size);
			Dialog_Show(playerid, Login, DIALOG_STYLE_PASSWORD, "Nhap mat khau", mes, "Dang nhap", "Huy bo");
			pTemp[playerid][pLoggedScreen] = 1;
		}
	}
	return 1;
}

HT_OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	if(clickedid == Login_TD[3])
	{
		if(pTemp[playerid][pLoggedScreen] == 0)
		{
			SendClientMessage(playerid, -1, "debug = 1");
			new string[1000];
			format(string, sizeof(string), "\n\
			Founder of Server [3]\n\
			\tcuozg7 - Head of Developer\n\
			\tJett - Game Designer\n\
			\tMaanx - Game Designer\n\
			\n\
			Script Developer [3]\n\
			\tcuozg7 - Head of Developer\n\
			\tjonhien - Junior Developer\n\
			\tKhoi - Website Developer\n\
			\n\
			Leadership of Game [1]\n\
			\tSimon - Head of Game Designer\n\
			\n\
			Administration [3]\n\
			\tTinhz - Game Supporter\n\
			\tAngle - Mapper\n\
			\n\
			Thanks for everyone!");
			ShowPlayerDialog(playerid, 1000, DIALOG_STYLE_MSGBOX, "Los Santos Roleplay - Roster", string, "Umm.. Okay!", "");
			pTemp[playerid][pLoggedScreen] = 1;
		}
	}
	return 1;
}

this::UpdateCharacterStats(playerid)
{
	new string[1024], name[MAX_PLAYER_NAME], gender, birthdate[168], appearance[168];
	cache_get_field_content(0, "name", name);
	gender = cache_get_field_content_int(0, "sex");
	cache_get_field_content(0, "birthdate", birthdate);
	cache_get_field_content(0, "appearance", appearance);
	format(string, sizeof(string), "%s~n~%s~n~Ngay sinh: %s~n~Mo ta: %s", name, (gender==1)?("Nam"):("Nu"), birthdate, appearance);
	PlayerTextDrawSetString(playerid, CharacterStats[playerid][2], string);
	return 1;
}

