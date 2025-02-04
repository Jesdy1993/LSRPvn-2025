TDraw_OnGameModeInit()
{
    //���� ������
	zond_cam[0] = TextDrawCreate(200.600006, 183.000000, "box");
	TextDrawLetterSize(zond_cam[0], 0.000000, -0.354317);
	TextDrawTextSize(zond_cam[0], 0.000000, 37.000000);
	TextDrawAlignment(zond_cam[0], 2);
	TextDrawColor(zond_cam[0], -1);
	TextDrawUseBox(zond_cam[0], 1);
	TextDrawBoxColor(zond_cam[0], -1);
	TextDrawSetShadow(zond_cam[0], 0);
	TextDrawSetOutline(zond_cam[0], 0);
	TextDrawBackgroundColor(zond_cam[0], 255);
	TextDrawFont(zond_cam[0], 1);
	TextDrawSetProportional(zond_cam[0], 1);
	TextDrawSetShadow(zond_cam[0], 0);

	zond_cam[1] = TextDrawCreate(200.100006, 320.000000, "box");
	TextDrawLetterSize(zond_cam[1], 0.000000, -0.354317);
	TextDrawTextSize(zond_cam[1], 0.000000, 37.000000);
	TextDrawAlignment(zond_cam[1], 2);
	TextDrawColor(zond_cam[1], -1);
	TextDrawUseBox(zond_cam[1], 1);
	TextDrawBoxColor(zond_cam[1], -1);
	TextDrawSetShadow(zond_cam[1], 0);
	TextDrawSetOutline(zond_cam[1], 0);
	TextDrawBackgroundColor(zond_cam[1], 255);
	TextDrawFont(zond_cam[1], 1);
	TextDrawSetProportional(zond_cam[1], 1);
	TextDrawSetShadow(zond_cam[1], 0);

	zond_cam[2] = TextDrawCreate(460.000000, 320.000000, "box");
	TextDrawLetterSize(zond_cam[2], 0.000000, -0.354317);
	TextDrawTextSize(zond_cam[2], 0.000000, 37.000000);
	TextDrawAlignment(zond_cam[2], 2);
	TextDrawColor(zond_cam[2], -1);
	TextDrawUseBox(zond_cam[2], 1);
	TextDrawBoxColor(zond_cam[2], -1);
	TextDrawSetShadow(zond_cam[2], 0);
	TextDrawSetOutline(zond_cam[2], 0);
	TextDrawBackgroundColor(zond_cam[2], 255);
	TextDrawFont(zond_cam[2], 1);
	TextDrawSetProportional(zond_cam[2], 1);
	TextDrawSetShadow(zond_cam[2], 0);

	zond_cam[3] = TextDrawCreate(460.000000, 183.000000, "box");
	TextDrawLetterSize(zond_cam[3], 0.000000, -0.354317);
	TextDrawTextSize(zond_cam[3], 0.000000, 37.000000);
	TextDrawAlignment(zond_cam[3], 2);
	TextDrawColor(zond_cam[3], -1);
	TextDrawUseBox(zond_cam[3], 1);
	TextDrawBoxColor(zond_cam[3], -1);
	TextDrawSetShadow(zond_cam[3], 0);
	TextDrawSetOutline(zond_cam[3], 0);
	TextDrawBackgroundColor(zond_cam[3], 255);
	TextDrawFont(zond_cam[3], 1);
	TextDrawSetProportional(zond_cam[3], 1);
	TextDrawSetShadow(zond_cam[3], 0);

	zond_cam[4] = TextDrawCreate(180.365997, 183.000015, "box");
	TextDrawLetterSize(zond_cam[4], 0.000000, 3.206443);
	TextDrawTextSize(zond_cam[4], 0.000000, -5.000000);
	TextDrawAlignment(zond_cam[4], 2);
	TextDrawColor(zond_cam[4], -1);
	TextDrawUseBox(zond_cam[4], 1);
	TextDrawBoxColor(zond_cam[4], -1);
	TextDrawSetShadow(zond_cam[4], 0);
	TextDrawSetOutline(zond_cam[4], 0);
	TextDrawBackgroundColor(zond_cam[4], 255);
	TextDrawFont(zond_cam[4], 1);
	TextDrawSetProportional(zond_cam[4], 1);
	TextDrawSetShadow(zond_cam[4], 0);

	zond_cam[5] = TextDrawCreate(180.365997, 286.833435, "box");
	TextDrawLetterSize(zond_cam[5], 0.000000, 3.206443);
	TextDrawTextSize(zond_cam[5], 0.000000, -5.000000);
	TextDrawAlignment(zond_cam[5], 2);
	TextDrawColor(zond_cam[5], -1);
	TextDrawUseBox(zond_cam[5], 1);
	TextDrawBoxColor(zond_cam[5], -1);
	TextDrawSetShadow(zond_cam[5], 0);
	TextDrawSetOutline(zond_cam[5], 0);
	TextDrawBackgroundColor(zond_cam[5], 255);
	TextDrawFont(zond_cam[5], 1);
	TextDrawSetProportional(zond_cam[5], 1);
	TextDrawSetShadow(zond_cam[5], 0);

	zond_cam[6] = TextDrawCreate(480.219818, 288.000122, "box");
	TextDrawLetterSize(zond_cam[6], 0.000000, 3.206443);
	TextDrawTextSize(zond_cam[6], 0.000000, -5.000000);
	TextDrawAlignment(zond_cam[6], 2);
	TextDrawColor(zond_cam[6], -1);
	TextDrawUseBox(zond_cam[6], 1);
	TextDrawBoxColor(zond_cam[6], -1);
	TextDrawSetShadow(zond_cam[6], 0);
	TextDrawSetOutline(zond_cam[6], 0);
	TextDrawBackgroundColor(zond_cam[6], 255);
	TextDrawFont(zond_cam[6], 1);
	TextDrawSetProportional(zond_cam[6], 1);
	TextDrawSetShadow(zond_cam[6], 0);

	zond_cam[7] = TextDrawCreate(479.751220, 183.000106, "box");
	TextDrawLetterSize(zond_cam[7], 0.000000, 3.206443);
	TextDrawTextSize(zond_cam[7], 0.000000, -5.000000);
	TextDrawAlignment(zond_cam[7], 2);
	TextDrawColor(zond_cam[7], -1);
	TextDrawUseBox(zond_cam[7], 1);
	TextDrawBoxColor(zond_cam[7], -1);
	TextDrawSetShadow(zond_cam[7], 0);
	TextDrawSetOutline(zond_cam[7], 0);
	TextDrawBackgroundColor(zond_cam[7], 255);
	TextDrawFont(zond_cam[7], 1);
	TextDrawSetProportional(zond_cam[7], 1);
	TextDrawSetShadow(zond_cam[7], 0);

	zond_cam[8] = TextDrawCreate(468.506805, 164.333358, "box");
	TextDrawLetterSize(zond_cam[8], 0.000000, 0.442169);
	TextDrawTextSize(zond_cam[8], 0.000000, 18.000000);
	TextDrawAlignment(zond_cam[8], 2);
	TextDrawColor(zond_cam[8], -1);
	TextDrawUseBox(zond_cam[8], 1);
	TextDrawBoxColor(zond_cam[8], -176);
	TextDrawSetShadow(zond_cam[8], 0);
	TextDrawSetOutline(zond_cam[8], 0);
	TextDrawBackgroundColor(zond_cam[8], 255);
	TextDrawFont(zond_cam[8], 1);
	TextDrawSetProportional(zond_cam[8], 1);
	TextDrawSetShadow(zond_cam[8], 0);

	zond_cam[9] = TextDrawCreate(481.656890, 164.133316, "box");
	TextDrawLetterSize(zond_cam[9], 0.000000, 0.489021);
	TextDrawTextSize(zond_cam[9], 469.500030, 0.000000);
	TextDrawAlignment(zond_cam[9], 1);
	TextDrawColor(zond_cam[9], -1);
	TextDrawUseBox(zond_cam[9], 1);
	TextDrawBoxColor(zond_cam[9], -1523963137);
	TextDrawSetShadow(zond_cam[9], 0);
	TextDrawSetOutline(zond_cam[9], 0);
	TextDrawBackgroundColor(zond_cam[9], 255);
	TextDrawFont(zond_cam[9], 1);
	TextDrawSetProportional(zond_cam[9], 1);
	TextDrawSetShadow(zond_cam[9], 0);

	zond_cam[10] = TextDrawCreate(456.593719, 167.250015, "box");
	TextDrawLetterSize(zond_cam[10], 0.000000, -0.166905);
	TextDrawTextSize(zond_cam[10], 0.000000, -2.000000);
	TextDrawAlignment(zond_cam[10], 2);
	TextDrawColor(zond_cam[10], -1);
	TextDrawUseBox(zond_cam[10], 1);
	TextDrawBoxColor(zond_cam[10], -176);
	TextDrawSetShadow(zond_cam[10], 0);
	TextDrawSetOutline(zond_cam[10], 0);
	TextDrawBackgroundColor(zond_cam[10], 255);
	TextDrawFont(zond_cam[10], 1);
	TextDrawSetProportional(zond_cam[10], 1);
	TextDrawSetShadow(zond_cam[10], 0);

    TD_vehicle_info[0] = TextDrawCreate(429.000000, 409.000000, ".");
	TextDrawBackgroundColor(TD_vehicle_info[0], 255);
	TextDrawFont(TD_vehicle_info[0], 2);
	TextDrawLetterSize(TD_vehicle_info[0], 36.150016, -0.500000);
	TextDrawColor(TD_vehicle_info[0], -1);
	TextDrawSetOutline(TD_vehicle_info[0], 0);
	TextDrawSetProportional(TD_vehicle_info[0], 1);
	TextDrawSetShadow(TD_vehicle_info[0], 1);
	TextDrawSetSelectable(TD_vehicle_info[0], 0);

	TD_vehicle_info[1] = TextDrawCreate(485.000000, 395.000000, "vehicle");
	TextDrawBackgroundColor(TD_vehicle_info[1], 255);
	TextDrawFont(TD_vehicle_info[1], 3);
	TextDrawLetterSize(TD_vehicle_info[1], 0.400000, 0.899999);
	TextDrawColor(TD_vehicle_info[1], -1);
	TextDrawSetOutline(TD_vehicle_info[1], 0);
	TextDrawSetProportional(TD_vehicle_info[1], 1);
	TextDrawSetShadow(TD_vehicle_info[1], 1);
	TextDrawSetSelectable(TD_vehicle_info[1], 0);

	//���������
	TD_restaurant[0] = TextDrawCreate(487.599975, 139.384429, "usebox");
	TextDrawLetterSize(TD_restaurant[0], 0.000000, 20.258150);
	TextDrawTextSize(TD_restaurant[0], 133.600006, 0.000000);
	TextDrawAlignment(TD_restaurant[0], 1);
	TextDrawColor(TD_restaurant[0], 0);
	TextDrawUseBox(TD_restaurant[0], true);
	TextDrawBoxColor(TD_restaurant[0], 255);
	TextDrawSetShadow(TD_restaurant[0], 0);
	TextDrawSetOutline(TD_restaurant[0], 0);
	TextDrawFont(TD_restaurant[0], 0);
	TextDrawSetProportional(TD_restaurant[0], 1);

	TD_restaurant[1] = TextDrawCreate(148.600006, 165.884429, "Nha hang nay cung cap thuc an.");
	TextDrawLetterSize(TD_restaurant[1], 0.209995, 1.086665);
	TextDrawTextSize(TD_restaurant[1], 1010.000000, -9.333333);
	TextDrawAlignment(TD_restaurant[1], 1);
	TextDrawColor(TD_restaurant[1], -1);
	TextDrawUseBox(TD_restaurant[1], true);
	TextDrawBoxColor(TD_restaurant[1], 0);
	TextDrawSetShadow(TD_restaurant[1], 0);
	TextDrawSetOutline(TD_restaurant[1], 1);
	TextDrawBackgroundColor(TD_restaurant[1], 51);
	TextDrawFont(TD_restaurant[1], 1);
	TextDrawSetProportional(TD_restaurant[1], 1);

	TD_restaurant[2] = TextDrawCreate(148.600006, 176.217773, "Chon bang cach nhap vao hinh anh.");
	TextDrawLetterSize(TD_restaurant[2], 0.209995, 1.086665);
	TextDrawTextSize(TD_restaurant[2], 1010.000000, -9.333333);
	TextDrawAlignment(TD_restaurant[2], 1);
	TextDrawColor(TD_restaurant[2], -1);
	TextDrawUseBox(TD_restaurant[2], true);
	TextDrawBoxColor(TD_restaurant[2], 0);
	TextDrawSetShadow(TD_restaurant[2], 0);
	TextDrawSetOutline(TD_restaurant[2], 1);
	TextDrawBackgroundColor(TD_restaurant[2], 51);
	TextDrawFont(TD_restaurant[2], 1);
	TextDrawSetProportional(TD_restaurant[2], 1);

	TD_restaurant[3] = TextDrawCreate(468.000000, 146.222290, "X");
	TextDrawLetterSize(TD_restaurant[3], 0.449598, 1.241600);
	TextDrawTextSize(TD_restaurant[3], 482.000000, 9.955554);
	TextDrawAlignment(TD_restaurant[3], 1);
	TextDrawColor(TD_restaurant[3], -1061109505);
	TextDrawSetShadow(TD_restaurant[3], 0);
	TextDrawSetOutline(TD_restaurant[3], 1);
	TextDrawBackgroundColor(TD_restaurant[3], 51);
	TextDrawFont(TD_restaurant[3], 1);
	TextDrawSetProportional(TD_restaurant[3], 1);
	TextDrawSetSelectable(TD_restaurant[3], true);
}

Speedometr_TDcreate(playerid)
{
	SpeedText[playerid] = CreatePlayerTextDraw(playerid, speedSettings[PlayerInfo[playerid][pHud]][speedX], speedSettings[PlayerInfo[playerid][pHud]][speedY], "~b~FUEL_________~l~I~w~IIIIIIIIII~w~I~l~I~n~~b~SPEED______~w~0___km/h~n~~b~MILEAGE__~w~0.00_km~n~");
	PlayerTextDrawLetterSize(playerid, SpeedText[playerid], speedSettings[PlayerInfo[playerid][pHud]][speedLX], speedSettings[PlayerInfo[playerid][pHud]][speedLY]);
	PlayerTextDrawTextSize(playerid, SpeedText[playerid], 629.0000, 0.0000);
	PlayerTextDrawAlignment(playerid, SpeedText[playerid], 1);
	PlayerTextDrawColor(playerid, SpeedText[playerid], -1);
	PlayerTextDrawSetOutline(playerid, SpeedText[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, SpeedText[playerid], 255);
	PlayerTextDrawFont(playerid, SpeedText[playerid], speedSettings[PlayerInfo[playerid][pHud]][speedFont]);
	PlayerTextDrawSetProportional(playerid, SpeedText[playerid], 1);

	ShowHudTextDraw(playerid);
	return 1;
}

TDraw_OnPlayerConnect(playerid)
{
	/*
	infotxt[playerid] = TextDrawCreate(50.416675, 279.703735, "~r~Info Message");
	TextDrawLetterSize(infotxt[playerid], 0.273750, 1.366667);
	TextDrawAlignment(infotxt[playerid], 1);
	TextDrawColor(infotxt[playerid], -1);
	TextDrawSetOutline(infotxt[playerid], 0);
	TextDrawBackgroundColor(infotxt[playerid], 255);
	TextDrawFont(infotxt[playerid], 1);
	TextDrawSetProportional(infotxt[playerid], 1);
	TextDrawSetShadow(infotxt[playerid], 1);*/
	
	infotxt[playerid] = TextDrawCreate(87.000000, 304.000000, "Test");
	TextDrawFont(infotxt[playerid], 1);
	TextDrawLetterSize(infotxt[playerid], 0.208333, 0.850000);
	TextDrawTextSize(infotxt[playerid], 400.000000, 137.000000);
	TextDrawSetOutline(infotxt[playerid], 0);
	TextDrawSetShadow(infotxt[playerid], 0);
	TextDrawAlignment(infotxt[playerid], 2);
	TextDrawColor(infotxt[playerid], -1);
	TextDrawBackgroundColor(infotxt[playerid], 255);
	TextDrawBoxColor(infotxt[playerid], 50);
	TextDrawUseBox(infotxt[playerid], 0);
	TextDrawSetProportional(infotxt[playerid], 1);
	TextDrawSetSelectable(infotxt[playerid], 0);

    TD_vehicle_name[playerid] = CreatePlayerTextDraw(playerid, 553.000000, 407.000000, "info");
	PlayerTextDrawBackgroundColor(playerid, TD_vehicle_name[playerid], 255);
	PlayerTextDrawFont(playerid, TD_vehicle_name[playerid], 2);
	PlayerTextDrawLetterSize(playerid, TD_vehicle_name[playerid], 0.200000, 0.699998);
	PlayerTextDrawColor(playerid, TD_vehicle_name[playerid], -1);
	PlayerTextDrawSetOutline(playerid, TD_vehicle_name[playerid], 0);
	PlayerTextDrawSetProportional(playerid, TD_vehicle_name[playerid], 1);
	PlayerTextDrawSetShadow(playerid, TD_vehicle_name[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, TD_vehicle_name[playerid], 0);
	PlayerTextDrawHide(playerid, TD_vehicle_name[playerid]);

	/*drug_effect[playerid] = CreatePlayerTextDraw(playerid, 320.000000, 0.000000, "_");
	PlayerTextDrawAlignment(playerid, drug_effect[playerid], 2);
	PlayerTextDrawBackgroundColor(playerid, drug_effect[playerid], 255);
	PlayerTextDrawFont(playerid, drug_effect[playerid], 1);
	PlayerTextDrawLetterSize(playerid, drug_effect[playerid], 0.500000, 53.000000);
	PlayerTextDrawColor(playerid, drug_effect[playerid], -1);
	PlayerTextDrawSetOutline(playerid, drug_effect[playerid], 0);
	PlayerTextDrawSetProportional(playerid, drug_effect[playerid], 1);
	PlayerTextDrawSetShadow(playerid, drug_effect[playerid], 1);
	PlayerTextDrawUseBox(playerid, drug_effect[playerid], 1);
	PlayerTextDrawBoxColor(playerid, drug_effect[playerid], -14837680);
	PlayerTextDrawTextSize(playerid, drug_effect[playerid], 0.000000, 1215.000000);
	PlayerTextDrawSetSelectable(playerid, drug_effect[playerid], 0);*/

	spectate_TD[playerid][0] = CreatePlayerTextDraw(playerid, 1.000000, 1.000000, "Dang tai ...");
	PlayerTextDrawBackgroundColor(playerid, spectate_TD[playerid][0], 255);
	PlayerTextDrawFont(playerid, spectate_TD[playerid][0], 1);
	PlayerTextDrawLetterSize(playerid, spectate_TD[playerid][0], 0.230000, 0.899999);
	PlayerTextDrawColor(playerid, spectate_TD[playerid][0], -1);
	PlayerTextDrawSetOutline(playerid, spectate_TD[playerid][0], 0);
	PlayerTextDrawSetProportional(playerid, spectate_TD[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, spectate_TD[playerid][0], 1);
	PlayerTextDrawUseBox(playerid, spectate_TD[playerid][0], 1);
	PlayerTextDrawBoxColor(playerid, spectate_TD[playerid][0], 255);
	PlayerTextDrawTextSize(playerid, spectate_TD[playerid][0], 638.000000, 0.000000);

	spectate_TD[playerid][1] = CreatePlayerTextDraw(playerid, 1.000000, 437.000000, "Dang tai ...");
	PlayerTextDrawBackgroundColor(playerid, spectate_TD[playerid][1], 255);
	PlayerTextDrawFont(playerid, spectate_TD[playerid][1], 1);
	PlayerTextDrawLetterSize(playerid, spectate_TD[playerid][1], 0.230000, 0.899999);
	PlayerTextDrawColor(playerid, spectate_TD[playerid][1], -1);
	PlayerTextDrawSetOutline(playerid, spectate_TD[playerid][1], 0);
	PlayerTextDrawSetProportional(playerid, spectate_TD[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, spectate_TD[playerid][1], 1);
	PlayerTextDrawUseBox(playerid, spectate_TD[playerid][1], 1);
	PlayerTextDrawBoxColor(playerid, spectate_TD[playerid][1], 255);
	PlayerTextDrawTextSize(playerid, spectate_TD[playerid][1], 638.000000, 0.000000);

	//��������
	TD_restaurant_prod[playerid][0] = CreatePlayerTextDraw(playerid, 157.000000, 277.200042, "San pham 1");
	PlayerTextDrawLetterSize(playerid, TD_restaurant_prod[playerid][0], 0.267998, 0.993332);
	PlayerTextDrawAlignment(playerid, TD_restaurant_prod[playerid][0], 1);
	PlayerTextDrawColor(playerid, TD_restaurant_prod[playerid][0], -1);
	PlayerTextDrawSetShadow(playerid, TD_restaurant_prod[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, TD_restaurant_prod[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, TD_restaurant_prod[playerid][0], 51);
	PlayerTextDrawFont(playerid, TD_restaurant_prod[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, TD_restaurant_prod[playerid][0], 1);

	TD_restaurant_prod[playerid][1] = CreatePlayerTextDraw(playerid, 239.000000, 277.200042, "San pham 2");
	PlayerTextDrawLetterSize(playerid, TD_restaurant_prod[playerid][1], 0.267998, 0.993332);
	PlayerTextDrawAlignment(playerid, TD_restaurant_prod[playerid][1], 1);
	PlayerTextDrawColor(playerid, TD_restaurant_prod[playerid][1], -1);
	PlayerTextDrawSetShadow(playerid, TD_restaurant_prod[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, TD_restaurant_prod[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, TD_restaurant_prod[playerid][1], 51);
	PlayerTextDrawFont(playerid, TD_restaurant_prod[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, TD_restaurant_prod[playerid][1], 1);

	TD_restaurant_prod[playerid][2] = CreatePlayerTextDraw(playerid, 321.000000, 277.200042, "San pham 3");
	PlayerTextDrawLetterSize(playerid, TD_restaurant_prod[playerid][2], 0.267998, 0.993332);
	PlayerTextDrawAlignment(playerid, TD_restaurant_prod[playerid][2], 1);
	PlayerTextDrawColor(playerid, TD_restaurant_prod[playerid][2], -1);
	PlayerTextDrawSetShadow(playerid, TD_restaurant_prod[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, TD_restaurant_prod[playerid][2], 0);
	PlayerTextDrawBackgroundColor(playerid, TD_restaurant_prod[playerid][2], 51);
	PlayerTextDrawFont(playerid, TD_restaurant_prod[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, TD_restaurant_prod[playerid][2], 1);

	TD_restaurant_prod[playerid][3] = CreatePlayerTextDraw(playerid, 403.000000, 277.200042, "San pham 4");
	PlayerTextDrawLetterSize(playerid, TD_restaurant_prod[playerid][3], 0.267998, 0.993332);
	PlayerTextDrawAlignment(playerid, TD_restaurant_prod[playerid][3], 1);
	PlayerTextDrawColor(playerid, TD_restaurant_prod[playerid][3], -1);
	PlayerTextDrawSetShadow(playerid, TD_restaurant_prod[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, TD_restaurant_prod[playerid][3], 0);
	PlayerTextDrawBackgroundColor(playerid, TD_restaurant_prod[playerid][3], 51);
	PlayerTextDrawFont(playerid, TD_restaurant_prod[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, TD_restaurant_prod[playerid][3], 1);

	TD_restaurant_prod[playerid][4] = CreatePlayerTextDraw(playerid, 152.799987, 188.657760, "2218");
	PlayerTextDrawLetterSize(playerid, TD_restaurant_prod[playerid][4], 0.495200, 1.196799);
	PlayerTextDrawTextSize(playerid, TD_restaurant_prod[playerid][4], 59.999931, 68.195480);
	PlayerTextDrawAlignment(playerid, TD_restaurant_prod[playerid][4], 2);
	PlayerTextDrawColor(playerid, TD_restaurant_prod[playerid][4], -1);
	PlayerTextDrawUseBox(playerid, TD_restaurant_prod[playerid][4], true);
	PlayerTextDrawBoxColor(playerid, TD_restaurant_prod[playerid][4], 255);
	PlayerTextDrawSetShadow(playerid, TD_restaurant_prod[playerid][4], 0);
	PlayerTextDrawSetOutline(playerid, TD_restaurant_prod[playerid][4], 0);
	PlayerTextDrawBackgroundColor(playerid, TD_restaurant_prod[playerid][4], 51);
	PlayerTextDrawFont(playerid, TD_restaurant_prod[playerid][4], 5);
	PlayerTextDrawSetProportional(playerid, TD_restaurant_prod[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid, TD_restaurant_prod[playerid][4], true);
	PlayerTextDrawSetPreviewModel(playerid, TD_restaurant_prod[playerid][4], 2218);
	PlayerTextDrawSetPreviewRot(playerid, TD_restaurant_prod[playerid][4], -220.000000, -200.000000, 200.000000, 1.000000);

	TD_restaurant_prod[playerid][5] = CreatePlayerTextDraw(playerid, 234.799987, 188.657760, "2219");
	PlayerTextDrawLetterSize(playerid, TD_restaurant_prod[playerid][5], 0.495200, 1.196799);
	PlayerTextDrawTextSize(playerid, TD_restaurant_prod[playerid][5], 59.999931, 68.195480);
	PlayerTextDrawAlignment(playerid, TD_restaurant_prod[playerid][5], 2);
	PlayerTextDrawColor(playerid, TD_restaurant_prod[playerid][5], -1);
	PlayerTextDrawUseBox(playerid, TD_restaurant_prod[playerid][5], true);
	PlayerTextDrawBoxColor(playerid, TD_restaurant_prod[playerid][5], 255);
	PlayerTextDrawSetShadow(playerid, TD_restaurant_prod[playerid][5], 0);
	PlayerTextDrawSetOutline(playerid, TD_restaurant_prod[playerid][5], 0);
	PlayerTextDrawBackgroundColor(playerid, TD_restaurant_prod[playerid][5], 51);
	PlayerTextDrawFont(playerid, TD_restaurant_prod[playerid][5], 5);
	PlayerTextDrawSetProportional(playerid, TD_restaurant_prod[playerid][5], 1);
	PlayerTextDrawSetSelectable(playerid, TD_restaurant_prod[playerid][5], true);
	PlayerTextDrawSetPreviewModel(playerid, TD_restaurant_prod[playerid][5], 2219);
	PlayerTextDrawSetPreviewRot(playerid, TD_restaurant_prod[playerid][5], -220.000000, -200.000000, 200.000000, 1.000000);

	TD_restaurant_prod[playerid][6] = CreatePlayerTextDraw(playerid, 316.799987, 188.657760, "2220");
	PlayerTextDrawLetterSize(playerid, TD_restaurant_prod[playerid][6], 0.495200, 1.196799);
	PlayerTextDrawTextSize(playerid, TD_restaurant_prod[playerid][6], 59.999931, 68.195480);
	PlayerTextDrawAlignment(playerid, TD_restaurant_prod[playerid][6], 2);
	PlayerTextDrawColor(playerid, TD_restaurant_prod[playerid][6], -1);
	PlayerTextDrawUseBox(playerid, TD_restaurant_prod[playerid][6], true);
	PlayerTextDrawBoxColor(playerid, TD_restaurant_prod[playerid][6], 255);
	PlayerTextDrawSetShadow(playerid, TD_restaurant_prod[playerid][6], 0);
	PlayerTextDrawSetOutline(playerid, TD_restaurant_prod[playerid][6], 0);
	PlayerTextDrawBackgroundColor(playerid, TD_restaurant_prod[playerid][6], 51);
	PlayerTextDrawFont(playerid, TD_restaurant_prod[playerid][6], 5);
	PlayerTextDrawSetProportional(playerid, TD_restaurant_prod[playerid][6], 1);
	PlayerTextDrawSetSelectable(playerid, TD_restaurant_prod[playerid][6], true);
	PlayerTextDrawSetPreviewModel(playerid, TD_restaurant_prod[playerid][6], 2220);
	PlayerTextDrawSetPreviewRot(playerid, TD_restaurant_prod[playerid][6], -220.000000, -200.000000, 200.000000, 1.000000);

	TD_restaurant_prod[playerid][7] = CreatePlayerTextDraw(playerid, 398.799987, 188.657760, "2355");
	PlayerTextDrawLetterSize(playerid, TD_restaurant_prod[playerid][7], 0.495200, 1.196799);
	PlayerTextDrawTextSize(playerid, TD_restaurant_prod[playerid][7], 59.999931, 68.195480);
	PlayerTextDrawAlignment(playerid, TD_restaurant_prod[playerid][7], 2);
	PlayerTextDrawColor(playerid, TD_restaurant_prod[playerid][7], -1);
	PlayerTextDrawUseBox(playerid, TD_restaurant_prod[playerid][7], true);
	PlayerTextDrawBoxColor(playerid, TD_restaurant_prod[playerid][7], 255);
	PlayerTextDrawSetShadow(playerid, TD_restaurant_prod[playerid][7], 0);
	PlayerTextDrawSetOutline(playerid, TD_restaurant_prod[playerid][7], 0);
	PlayerTextDrawBackgroundColor(playerid, TD_restaurant_prod[playerid][7], 51);
	PlayerTextDrawFont(playerid, TD_restaurant_prod[playerid][7], 5);
	PlayerTextDrawSetProportional(playerid, TD_restaurant_prod[playerid][7], 1);
	PlayerTextDrawSetSelectable(playerid, TD_restaurant_prod[playerid][7], true);
	PlayerTextDrawSetPreviewModel(playerid, TD_restaurant_prod[playerid][7], 2355);
	PlayerTextDrawSetPreviewRot(playerid, TD_restaurant_prod[playerid][7], -220.000000, -200.000000, 200.000000, 1.000000);

	FuelText[playerid] = CreatePlayerTextDraw(playerid, 40.000000, 305.000000, "~b~~h~Tiep nhien lieu...~n~~n~~w~Gia: ~g~~h~$0 ~y~~h~(0.00L)");
    PlayerTextDrawBackgroundColor(playerid, FuelText[playerid], 255);
    PlayerTextDrawFont(playerid, FuelText[playerid], 1);
    PlayerTextDrawLetterSize(playerid, FuelText[playerid], 0.240000, 1.100000);
    PlayerTextDrawColor(playerid, FuelText[playerid], -1);
    PlayerTextDrawSetOutline(playerid, FuelText[playerid], 1);
    PlayerTextDrawSetProportional(playerid, FuelText[playerid], 1);
    PlayerTextDrawSetSelectable(playerid, FuelText[playerid], 0);

	for(new i = 0; i < 4; i++)
	{
		TextDrawHideForPlayer(playerid, TD_restaurant[i]);
	}

    for(new i; i < 11; i++)
	{
	    TextDrawHideForPlayer(playerid, zond_cam[i]);
	}

	Speedometr_TDcreate(playerid);
}


ShowHudTextDraw(playerid)
{
	if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER) PlayerTextDrawShow(playerid, SpeedText[playerid]);
	return 1;
}

HideHudTextDraw(playerid)
{
	PlayerTextDrawHide(playerid, SpeedText[playerid]);
	return 1;
}

InfoMSG(playerid, message[], delay)
{
	TextDrawSetString(infotxt[playerid], message);
	TextDrawShowForPlayer(playerid, infotxt[playerid]);
	infotxt_expire{playerid} = delay;
	return 1;
}
/*
InfoMSG2(playerid, header[], message[], delay)
{
	TD_SendMessage(playerid, message, header, delay, 12840, 10.0000, 100.000000, 300.000000, strlen(message));
	return 1;
}*/

/*RefreshErrorMsg(playerid)
{
	new sendstr[256],
		tmp[80],
		display = false;

	if (ErrorInfo[playerid][0][eExpire] || ErrorInfo[playerid][1][eExpire] || ErrorInfo[playerid][2][eExpire])
	    display = true;

	format(sendstr,sizeof(sendstr),"~r~");

	if (ErrorInfo[playerid][2][eExpire])
	{
		format(tmp,sizeof(tmp),"~n~%s",ErrorInfo[playerid][2][eMsg]);
		strins(sendstr,tmp,strlen(sendstr));
	}

	TextDrawSetString(errormsg[playerid],sendstr);

	if (display) TextDrawShowForPlayer(playerid,errormsg[playerid]);
	else TextDrawHideForPlayer(playerid,errormsg[playerid]);
}*/

RestaurantMenuHide(playerid)
{
    CancelSelectTextDraw(playerid);
	for(new i; i != 8; i++)
	{
 		if (i < 4)
		 	TextDrawHideForPlayer(playerid, TD_restaurant[i]);

		PlayerTextDrawHide(playerid, TD_restaurant_prod[playerid][i]);
	}
	DeletePVar(playerid, #restaurant);
	return 1;
}

/*
new PlayerText: Store_Business[MAX_PLAYERS];
new PlayerText: Store_Mask[MAX_PLAYERS];
new PlayerText: Store_Cart[MAX_PLAYERS];
new Text: Store_UI[10];
new Text: Store_Frame[30];

PlayerStoreTD(playerid)
{
	Store_Business[playerid] = CreatePlayerTextDraw(playerid, 123.675003, 67.499977, "Business_Name");
	PlayerTextDrawLetterSize(playerid, Store_Business[playerid], 0.699853, 2.620834);
	PlayerTextDrawAlignment(playerid, Store_Business[playerid], 1);
	PlayerTextDrawColor(playerid, Store_Business[playerid], -1);
	PlayerTextDrawSetShadow(playerid, Store_Business[playerid], 0);
	PlayerTextDrawSetOutline(playerid, Store_Business[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, Store_Business[playerid], 255);
	PlayerTextDrawFont(playerid, Store_Business[playerid], 0);
	PlayerTextDrawSetProportional(playerid, Store_Business[playerid], 1);
	PlayerTextDrawSetShadow(playerid, Store_Business[playerid], 0);

	Store_Mask[playerid] = CreatePlayerTextDraw(playerid, 179.897491, 294.999969, "Mask~n~[246212_42]");
	PlayerTextDrawLetterSize(playerid, Store_Mask[playerid], 0.254289, 1.045832);
	PlayerTextDrawAlignment(playerid, Store_Mask[playerid], 2);
	PlayerTextDrawColor(playerid, Store_Mask[playerid], 255);
	PlayerTextDrawSetShadow(playerid, Store_Mask[playerid], 0);
	PlayerTextDrawSetOutline(playerid, Store_Mask[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, Store_Mask[playerid], 255);
	PlayerTextDrawFont(playerid, Store_Mask[playerid], 1);
	PlayerTextDrawSetProportional(playerid, Store_Mask[playerid], 1);
	PlayerTextDrawSetShadow(playerid, Store_Mask[playerid], 0);

	Store_Cart[playerid] = CreatePlayerTextDraw(playerid, 326.544403, 168.416671, "~g~EMPTY");
	PlayerTextDrawLetterSize(playerid, Store_Cart[playerid], 0.190102, 1.197499);
	PlayerTextDrawAlignment(playerid, Store_Cart[playerid], 1);
	PlayerTextDrawColor(playerid, Store_Cart[playerid], -1);
	PlayerTextDrawSetShadow(playerid, Store_Cart[playerid], 0);
	PlayerTextDrawSetOutline(playerid, Store_Cart[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, Store_Cart[playerid], 255);
	PlayerTextDrawFont(playerid, Store_Cart[playerid], 1);
	PlayerTextDrawSetProportional(playerid, Store_Cart[playerid], 1);
	PlayerTextDrawSetShadow(playerid, Store_Cart[playerid], 0);
}

StoreTD()
{
	Store_UI[0] = TextDrawCreate(139.904861, 100.166664, "");
	TextDrawLetterSize(Store_UI[0], 0.000000, 0.000000);
	TextDrawTextSize(Store_UI[0], 78.000000, 78.000000);
	TextDrawAlignment(Store_UI[0], 1);
	TextDrawColor(Store_UI[0], -1);
	TextDrawSetShadow(Store_UI[0], 0);
	TextDrawSetOutline(Store_UI[0], 0);
	TextDrawBackgroundColor(Store_UI[0], -572662273);
	TextDrawFont(Store_UI[0], 5);
	TextDrawSetProportional(Store_UI[0], 0);
	TextDrawSetShadow(Store_UI[0], 0);
	TextDrawSetSelectable(Store_UI[0], true);
	TextDrawSetPreviewModel(Store_UI[0], 1650);
	TextDrawSetPreviewRot(Store_UI[0], 0.000000, 0.000000, 35.000000, 0.899999);

	Store_UI[1] = TextDrawCreate(223.770141, 100.166671, "");
	TextDrawLetterSize(Store_UI[1], 0.000000, 0.000000);
	TextDrawTextSize(Store_UI[1], 78.000000, 78.000000);
	TextDrawAlignment(Store_UI[1], 1);
	TextDrawColor(Store_UI[1], -1);
	TextDrawSetShadow(Store_UI[1], 0);
	TextDrawSetOutline(Store_UI[1], 0);
	TextDrawBackgroundColor(Store_UI[1], -572662273);
	TextDrawFont(Store_UI[1], 5);
	TextDrawSetProportional(Store_UI[1], 0);
	TextDrawSetShadow(Store_UI[1], 0);
	TextDrawSetSelectable(Store_UI[1], true);
	TextDrawSetPreviewModel(Store_UI[1], 2226);
	TextDrawSetPreviewRot(Store_UI[1], 0.000000, 0.000000, 180.000000, 0.899999);

	Store_UI[2] = TextDrawCreate(140.373382, 184.749969, "");
	TextDrawLetterSize(Store_UI[2], 0.000000, 0.000000);
	TextDrawTextSize(Store_UI[2], 78.000000, 78.000000);
	TextDrawAlignment(Store_UI[2], 1);
	TextDrawColor(Store_UI[2], -1);
	TextDrawSetShadow(Store_UI[2], 0);
	TextDrawSetOutline(Store_UI[2], 0);
	TextDrawBackgroundColor(Store_UI[2], -572662273);
	TextDrawFont(Store_UI[2], 5);
	TextDrawSetProportional(Store_UI[2], 0);
	TextDrawSetShadow(Store_UI[2], 0);
	TextDrawSetSelectable(Store_UI[2], true);
	TextDrawSetPreviewModel(Store_UI[2], 336);
	TextDrawSetPreviewRot(Store_UI[2], 50.000000, 91.000000, 298.000000, 2.099999);

	Store_UI[3] = TextDrawCreate(224.238662, 184.166625, "");
	TextDrawLetterSize(Store_UI[3], 0.000000, 0.000000);
	TextDrawTextSize(Store_UI[3], 78.000000, 78.000000);
	TextDrawAlignment(Store_UI[3], 1);
	TextDrawColor(Store_UI[3], -1);
	TextDrawSetShadow(Store_UI[3], 0);
	TextDrawSetOutline(Store_UI[3], 0);
	TextDrawBackgroundColor(Store_UI[3], -572662273);
	TextDrawFont(Store_UI[3], 5);
	TextDrawSetProportional(Store_UI[3], 0);
	TextDrawSetShadow(Store_UI[3], 0);
	TextDrawSetSelectable(Store_UI[3], true);
	TextDrawSetPreviewModel(Store_UI[3], 325);
	TextDrawSetPreviewRot(Store_UI[3], 50.000000, 91.000000, 298.000000, 2.099999);

	Store_UI[4] = TextDrawCreate(308.104156, 184.166625, "");
	TextDrawLetterSize(Store_UI[4], 0.000000, 0.000000);
	TextDrawTextSize(Store_UI[4], 78.000000, 78.000000);
	TextDrawAlignment(Store_UI[4], 1);
	TextDrawColor(Store_UI[4], -1);
	TextDrawSetShadow(Store_UI[4], 0);
	TextDrawSetOutline(Store_UI[4], 0);
	TextDrawBackgroundColor(Store_UI[4], -572662273);
	TextDrawFont(Store_UI[4], 5);
	TextDrawSetProportional(Store_UI[4], 0);
	TextDrawSetShadow(Store_UI[4], 0);
	TextDrawSetSelectable(Store_UI[4], true);
	TextDrawSetPreviewModel(Store_UI[4], 326);
	TextDrawSetPreviewRot(Store_UI[4], 50.000000, 91.000000, 298.000000, 1.000000);

	Store_UI[5] = TextDrawCreate(392.437927, 183.583297, "");
	TextDrawLetterSize(Store_UI[5], 0.000000, 0.000000);
	TextDrawTextSize(Store_UI[5], 78.000000, 78.000000);
	TextDrawAlignment(Store_UI[5], 1);
	TextDrawColor(Store_UI[5], -1);
	TextDrawSetShadow(Store_UI[5], 0);
	TextDrawSetOutline(Store_UI[5], 0);
	TextDrawBackgroundColor(Store_UI[5], -572662273);
	TextDrawFont(Store_UI[5], 5);
	TextDrawSetProportional(Store_UI[5], 0);
	TextDrawSetShadow(Store_UI[5], 0);
	TextDrawSetSelectable(Store_UI[5], true);
	TextDrawSetPreviewModel(Store_UI[5], 367);
	TextDrawSetPreviewRot(Store_UI[5], 52.000000, 231.000000, 102.000000, 1.000000);

	Store_UI[6] = TextDrawCreate(139.904861, 269.333221, "");
	TextDrawLetterSize(Store_UI[6], 0.000000, 0.000000);
	TextDrawTextSize(Store_UI[6], 78.000000, 78.000000);
	TextDrawAlignment(Store_UI[6], 1);
	TextDrawColor(Store_UI[6], -1);
	TextDrawSetShadow(Store_UI[6], 0);
	TextDrawSetOutline(Store_UI[6], 0);
	TextDrawBackgroundColor(Store_UI[6], -572662273);
	TextDrawFont(Store_UI[6], 5);
	TextDrawSetProportional(Store_UI[6], 0);
	TextDrawSetShadow(Store_UI[6], 0);
	TextDrawSetSelectable(Store_UI[6], true);
	TextDrawSetPreviewModel(Store_UI[6], 325);
	TextDrawSetPreviewRot(Store_UI[6], 50.000000, 91.000000, 298.000000, -1.000000);

	Store_UI[7] = TextDrawCreate(224.238769, 269.333251, "");
	TextDrawLetterSize(Store_UI[7], 0.000000, 0.000000);
	TextDrawTextSize(Store_UI[7], 78.000000, 78.000000);
	TextDrawAlignment(Store_UI[7], 1);
	TextDrawColor(Store_UI[7], -1);
	TextDrawSetShadow(Store_UI[7], 0);
	TextDrawSetOutline(Store_UI[7], 0);
	TextDrawBackgroundColor(Store_UI[7], -572662273);
	TextDrawFont(Store_UI[7], 5);
	TextDrawSetProportional(Store_UI[7], 0);
	TextDrawSetShadow(Store_UI[7], 0);
	TextDrawSetSelectable(Store_UI[7], true);
	TextDrawSetPreviewModel(Store_UI[7], 19823);
	TextDrawSetPreviewRot(Store_UI[7], 0.000000, 0.000000, 0.000000, 1.000000);

	Store_UI[8] = TextDrawCreate(308.572631, 269.333282, "");
	TextDrawLetterSize(Store_UI[8], 0.000000, 0.000000);
	TextDrawTextSize(Store_UI[8], 78.000000, 78.000000);
	TextDrawAlignment(Store_UI[8], 1);
	TextDrawColor(Store_UI[8], -1);
	TextDrawSetShadow(Store_UI[8], 0);
	TextDrawSetOutline(Store_UI[8], 0);
	TextDrawBackgroundColor(Store_UI[8], -572662273);
	TextDrawFont(Store_UI[8], 5);
	TextDrawSetProportional(Store_UI[8], 0);
	TextDrawSetShadow(Store_UI[8], 0);
	TextDrawSetSelectable(Store_UI[8], true);
	TextDrawSetPreviewModel(Store_UI[8], 19896);
	TextDrawSetPreviewRot(Store_UI[8], 90.000000, 180.000000, 0.000000, 0.699999);

	Store_UI[9] = TextDrawCreate(392.906677, 269.333251, "");
	TextDrawLetterSize(Store_UI[9], 0.000000, 0.000000);
	TextDrawTextSize(Store_UI[9], 78.000000, 78.000000);
	TextDrawAlignment(Store_UI[9], 1);
	TextDrawColor(Store_UI[9], -1);
	TextDrawSetShadow(Store_UI[9], 0);
	TextDrawSetOutline(Store_UI[9], 0);
	TextDrawBackgroundColor(Store_UI[9], -572662273);
	TextDrawFont(Store_UI[9], 5);
	TextDrawSetProportional(Store_UI[9], 0);
	TextDrawSetShadow(Store_UI[9], 0);
	TextDrawSetSelectable(Store_UI[9], true);
	TextDrawSetPreviewModel(Store_UI[9], 19942);
	TextDrawSetPreviewRot(Store_UI[9], 0.000000, 0.000000, 180.000000, 0.899999);

	Store_Frame[0] = TextDrawCreate(136.325042, 83.833259, "box");
	TextDrawLetterSize(Store_Frame[0], 0.000000, 30.005851);
	TextDrawTextSize(Store_Frame[0], 477.000000, 0.000000);
	TextDrawAlignment(Store_Frame[0], 1);
	TextDrawColor(Store_Frame[0], -1);
	TextDrawUseBox(Store_Frame[0], 1);
	TextDrawBoxColor(Store_Frame[0], 120);
	TextDrawSetShadow(Store_Frame[0], 0);
	TextDrawSetOutline(Store_Frame[0], 0);
	TextDrawBackgroundColor(Store_Frame[0], 255);
	TextDrawFont(Store_Frame[0], 1);
	TextDrawSetProportional(Store_Frame[0], 1);
	TextDrawSetShadow(Store_Frame[0], 0);

	Store_Frame[1] = TextDrawCreate(143.352828, 99.583358, "Gas_can");
	TextDrawLetterSize(Store_Frame[1], 0.256163, 1.407499);
	TextDrawAlignment(Store_Frame[1], 1);
	TextDrawColor(Store_Frame[1], -1);
	TextDrawSetShadow(Store_Frame[1], 0);
	TextDrawSetOutline(Store_Frame[1], 1);
	TextDrawBackgroundColor(Store_Frame[1], 255);
	TextDrawFont(Store_Frame[1], 1);
	TextDrawSetProportional(Store_Frame[1], 1);
	TextDrawSetShadow(Store_Frame[1], 0);

	Store_Frame[2] = TextDrawCreate(198.638351, 167.249984, "$500");
	TextDrawLetterSize(Store_Frame[2], 0.192269, 1.074999);
	TextDrawAlignment(Store_Frame[2], 1);
	TextDrawColor(Store_Frame[2], 1249264383);
	TextDrawSetShadow(Store_Frame[2], 0);
	TextDrawSetOutline(Store_Frame[2], 0);
	TextDrawBackgroundColor(Store_Frame[2], 255);
	TextDrawFont(Store_Frame[2], 1);
	TextDrawSetProportional(Store_Frame[2], 1);
	TextDrawSetShadow(Store_Frame[2], 0);

	Store_Frame[3] = TextDrawCreate(229.092193, 101.333396, "Boombox");
	TextDrawLetterSize(Store_Frame[3], 0.256163, 1.407499);
	TextDrawAlignment(Store_Frame[3], 1);
	TextDrawColor(Store_Frame[3], -1);
	TextDrawSetShadow(Store_Frame[3], 0);
	TextDrawSetOutline(Store_Frame[3], 1);
	TextDrawBackgroundColor(Store_Frame[3], 255);
	TextDrawFont(Store_Frame[3], 1);
	TextDrawSetProportional(Store_Frame[3], 1);
	TextDrawSetShadow(Store_Frame[3], 0);

	Store_Frame[4] = TextDrawCreate(273.133300, 167.249984, "$10,000");
	TextDrawLetterSize(Store_Frame[4], 0.192269, 1.074999);
	TextDrawAlignment(Store_Frame[4], 1);
	TextDrawColor(Store_Frame[4], 1249264383);
	TextDrawSetShadow(Store_Frame[4], 0);
	TextDrawSetOutline(Store_Frame[4], 0);
	TextDrawBackgroundColor(Store_Frame[4], 255);
	TextDrawFont(Store_Frame[4], 1);
	TextDrawSetProportional(Store_Frame[4], 1);
	TextDrawSetShadow(Store_Frame[4], 0);


	Store_Frame[5] = TextDrawCreate(144.289871, 187.083374, "Baseball_bat");
	TextDrawLetterSize(Store_Frame[5], 0.256163, 1.407499);
	TextDrawAlignment(Store_Frame[5], 1);
	TextDrawColor(Store_Frame[5], -1);
	TextDrawSetShadow(Store_Frame[5], 0);
	TextDrawSetOutline(Store_Frame[5], 1);
	TextDrawBackgroundColor(Store_Frame[5], 255);
	TextDrawFont(Store_Frame[5], 1);
	TextDrawSetProportional(Store_Frame[5], 1);
	TextDrawSetShadow(Store_Frame[5], 0);

	Store_Frame[6] = TextDrawCreate(192.547576, 250.083267, "$1,500");
	TextDrawLetterSize(Store_Frame[6], 0.192269, 1.074999);
	TextDrawAlignment(Store_Frame[6], 1);
	TextDrawColor(Store_Frame[6], 1249264383);
	TextDrawSetShadow(Store_Frame[6], 0);
	TextDrawSetOutline(Store_Frame[6], 0);
	TextDrawBackgroundColor(Store_Frame[6], 255);
	TextDrawFont(Store_Frame[6], 1);
	TextDrawSetProportional(Store_Frame[6], 1);
	TextDrawSetShadow(Store_Frame[6], 0);

	Store_Frame[7] = TextDrawCreate(144.758392, 272.250091, "OOC_Mask");
	TextDrawLetterSize(Store_Frame[7], 0.256163, 1.407499);
	TextDrawAlignment(Store_Frame[7], 1);
	TextDrawColor(Store_Frame[7], -1);
	TextDrawSetShadow(Store_Frame[7], 0);
	TextDrawSetOutline(Store_Frame[7], 1);
	TextDrawBackgroundColor(Store_Frame[7], 255);
	TextDrawFont(Store_Frame[7], 1);
	TextDrawSetProportional(Store_Frame[7], 1);
	TextDrawSetShadow(Store_Frame[7], 0);

	Store_Frame[8] = TextDrawCreate(230.966308, 271.666687, "Drink");
	TextDrawLetterSize(Store_Frame[8], 0.256163, 1.407499);
	TextDrawAlignment(Store_Frame[8], 1);
	TextDrawColor(Store_Frame[8], -1);
	TextDrawSetShadow(Store_Frame[8], 0);
	TextDrawSetOutline(Store_Frame[8], 1);
	TextDrawBackgroundColor(Store_Frame[8], 255);
	TextDrawFont(Store_Frame[8], 1);
	TextDrawSetProportional(Store_Frame[8], 1);
	TextDrawSetShadow(Store_Frame[8], 0);

	Store_Frame[9] = TextDrawCreate(312.489044, 271.666656, "Cigarettes");
	TextDrawLetterSize(Store_Frame[9], 0.256163, 1.407499);
	TextDrawAlignment(Store_Frame[9], 1);
	TextDrawColor(Store_Frame[9], -1);
	TextDrawSetShadow(Store_Frame[9], 0);
	TextDrawSetOutline(Store_Frame[9], 1);
	TextDrawBackgroundColor(Store_Frame[9], 255);
	TextDrawFont(Store_Frame[9], 1);
	TextDrawSetProportional(Store_Frame[9], 1);
	TextDrawSetShadow(Store_Frame[9], 0);

	Store_Frame[10] = TextDrawCreate(398.697143, 272.250000, "Radio");
	TextDrawLetterSize(Store_Frame[10], 0.256163, 1.407499);
	TextDrawAlignment(Store_Frame[10], 1);
	TextDrawColor(Store_Frame[10], -1);
	TextDrawSetShadow(Store_Frame[10], 0);
	TextDrawSetOutline(Store_Frame[10], 1);
	TextDrawBackgroundColor(Store_Frame[10], 255);
	TextDrawFont(Store_Frame[10], 1);
	TextDrawSetProportional(Store_Frame[10], 1);
	TextDrawSetShadow(Store_Frame[10], 0);

	Store_Frame[11] = TextDrawCreate(281.098175, 250.083251, "$500");
	TextDrawLetterSize(Store_Frame[11], 0.192269, 1.074999);
	TextDrawAlignment(Store_Frame[11], 1);
	TextDrawColor(Store_Frame[11], 1249264383);
	TextDrawSetShadow(Store_Frame[11], 0);
	TextDrawSetOutline(Store_Frame[11], 0);
	TextDrawBackgroundColor(Store_Frame[11], 255);
	TextDrawFont(Store_Frame[11], 1);
	TextDrawSetProportional(Store_Frame[11], 1);
	TextDrawSetShadow(Store_Frame[11], 0);

	Store_Frame[12] = TextDrawCreate(449.766387, 249.499938, "$500");
	TextDrawLetterSize(Store_Frame[12], 0.192269, 1.074999);
	TextDrawAlignment(Store_Frame[12], 1);
	TextDrawColor(Store_Frame[12], 1249264383);
	TextDrawSetShadow(Store_Frame[12], 0);
	TextDrawSetOutline(Store_Frame[12], 0);
	TextDrawBackgroundColor(Store_Frame[12], 255);
	TextDrawFont(Store_Frame[12], 1);
	TextDrawSetProportional(Store_Frame[12], 1);
	TextDrawSetShadow(Store_Frame[12], 0);

	Store_Frame[13] = TextDrawCreate(365.432525, 250.083267, "$200");
	TextDrawLetterSize(Store_Frame[13], 0.192269, 1.074999);
	TextDrawAlignment(Store_Frame[13], 1);
	TextDrawColor(Store_Frame[13], 1249264383);
	TextDrawSetShadow(Store_Frame[13], 0);
	TextDrawSetOutline(Store_Frame[13], 0);
	TextDrawBackgroundColor(Store_Frame[13], 255);
	TextDrawFont(Store_Frame[13], 1);
	TextDrawSetProportional(Store_Frame[13], 1);
	TextDrawSetShadow(Store_Frame[13], 0);

	Store_Frame[14] = TextDrawCreate(190.205520, 334.666656, "$5,000");
	TextDrawLetterSize(Store_Frame[14], 0.192269, 1.074999);
	TextDrawAlignment(Store_Frame[14], 1);
	TextDrawColor(Store_Frame[14], 1249264383);
	TextDrawSetShadow(Store_Frame[14], 0);
	TextDrawSetOutline(Store_Frame[14], 0);
	TextDrawBackgroundColor(Store_Frame[14], 255);
	TextDrawFont(Store_Frame[14], 1);
	TextDrawSetProportional(Store_Frame[14], 1);
	TextDrawSetShadow(Store_Frame[14], 0);

	Store_Frame[15] = TextDrawCreate(281.098663, 335.250061, "$200");
	TextDrawLetterSize(Store_Frame[15], 0.192269, 1.074999);
	TextDrawAlignment(Store_Frame[15], 1);
	TextDrawColor(Store_Frame[15], 1249264383);
	TextDrawSetShadow(Store_Frame[15], 0);
	TextDrawSetOutline(Store_Frame[15], 0);
	TextDrawBackgroundColor(Store_Frame[15], 255);
	TextDrawFont(Store_Frame[15], 1);
	TextDrawSetProportional(Store_Frame[15], 1);
	TextDrawSetShadow(Store_Frame[15], 0);

	Store_Frame[16] = TextDrawCreate(365.901275, 334.666748, "$500");
	TextDrawLetterSize(Store_Frame[16], 0.192269, 1.074999);
	TextDrawAlignment(Store_Frame[16], 1);
	TextDrawColor(Store_Frame[16], 1249264383);
	TextDrawSetShadow(Store_Frame[16], 0);
	TextDrawSetOutline(Store_Frame[16], 0);
	TextDrawBackgroundColor(Store_Frame[16], 255);
	TextDrawFont(Store_Frame[16], 1);
	TextDrawSetProportional(Store_Frame[16], 1);
	TextDrawSetShadow(Store_Frame[16], 0);

	Store_Frame[17] = TextDrawCreate(434.305236, 335.833496, "prices_vary");
	TextDrawLetterSize(Store_Frame[17], 0.192269, 1.074999);
	TextDrawAlignment(Store_Frame[17], 1);
	TextDrawColor(Store_Frame[17], 1249264383);
	TextDrawSetShadow(Store_Frame[17], 0);
	TextDrawSetOutline(Store_Frame[17], 0);
	TextDrawBackgroundColor(Store_Frame[17], 255);
	TextDrawFont(Store_Frame[17], 1);
	TextDrawSetProportional(Store_Frame[17], 1);
	TextDrawSetShadow(Store_Frame[17], 0);

	Store_Frame[18] = TextDrawCreate(0, 0, "_");
	TextDrawLetterSize(Store_Frame[18], 0, 0);
	TextDrawAlignment(Store_Frame[18], 1);
	TextDrawColor(Store_Frame[18], -1);
	TextDrawSetShadow(Store_Frame[18], 0);
	TextDrawSetOutline(Store_Frame[18], 1);
	TextDrawBackgroundColor(Store_Frame[18], 255);
	TextDrawFont(Store_Frame[18], 0);
	TextDrawSetProportional(Store_Frame[18], 1);
	TextDrawSetShadow(Store_Frame[18], 0);

	Store_Frame[19] = TextDrawCreate(374.333770, 169.583358, "PURCHASE");
	TextDrawLetterSize(Store_Frame[19], 0.238360, 1.069166);
	TextDrawAlignment(Store_Frame[19], 1);
	TextDrawColor(Store_Frame[19], 8388863);
	TextDrawSetShadow(Store_Frame[19], 0);
	TextDrawSetOutline(Store_Frame[19], 1);
	TextDrawBackgroundColor(Store_Frame[19], 255);
	TextDrawFont(Store_Frame[19], 1);
	TextDrawSetProportional(Store_Frame[19], 1);
	TextDrawSetShadow(Store_Frame[19], 0);
	TextDrawSetSelectable(Store_Frame[19], true);

	Store_Frame[20] = TextDrawCreate(420.248870, 169.583343, "EMPTY_CART");
	TextDrawLetterSize(Store_Frame[20], 0.238360, 1.069166);
	TextDrawAlignment(Store_Frame[20], 1);
	TextDrawColor(Store_Frame[20], -16776961);
	TextDrawSetShadow(Store_Frame[20], 0);
	TextDrawSetOutline(Store_Frame[20], 1);
	TextDrawBackgroundColor(Store_Frame[20], 255);
	TextDrawFont(Store_Frame[20], 1);
	TextDrawSetProportional(Store_Frame[20], 1);
	TextDrawSetShadow(Store_Frame[20], 0);
	//TextDrawSetSelectable(Store_Frame[20], true);

	Store_Frame[21] = TextDrawCreate(307.803710, 168.416671, "Cart:");
	TextDrawLetterSize(Store_Frame[21], 0.190102, 1.197499);
	TextDrawAlignment(Store_Frame[21], 1);
	TextDrawColor(Store_Frame[21], -1);
	TextDrawSetShadow(Store_Frame[21], 0);
	TextDrawSetOutline(Store_Frame[21], 1);
	TextDrawBackgroundColor(Store_Frame[21], 255);
	TextDrawFont(Store_Frame[21], 1);
	TextDrawSetProportional(Store_Frame[21], 1);
	TextDrawSetShadow(Store_Frame[21], 0);

	Store_Frame[22] = TextDrawCreate(310.146270, 96.666633, "Welcome!");
	TextDrawLetterSize(Store_Frame[22], 0.419209, 1.769166);
	TextDrawAlignment(Store_Frame[22], 1);
	TextDrawColor(Store_Frame[22], -1);
	TextDrawSetShadow(Store_Frame[22], 0);
	TextDrawSetOutline(Store_Frame[22], 1);
	TextDrawBackgroundColor(Store_Frame[22], 255);
	TextDrawFont(Store_Frame[22], 1);
	TextDrawSetProportional(Store_Frame[22], 1);
	TextDrawSetShadow(Store_Frame[22], 0);

	Store_Frame[23] = TextDrawCreate(310.146331, 114.166656, "Click_on_any_of_the_items_to_add_them_to~n~your_cart.~n~~n~Press_ESC_to_exit.");
	TextDrawLetterSize(Store_Frame[23], 0.189634, 1.133334);
	TextDrawAlignment(Store_Frame[23], 1);
	TextDrawColor(Store_Frame[23], -1);
	TextDrawSetShadow(Store_Frame[23], 0);
	TextDrawSetOutline(Store_Frame[23], 1);
	TextDrawBackgroundColor(Store_Frame[23], 255);
	TextDrawFont(Store_Frame[23], 1);
	TextDrawSetProportional(Store_Frame[23], 1);
	TextDrawSetShadow(Store_Frame[23], 0);

	Store_Frame[24] = TextDrawCreate(455.856719, 75.666625, "EXIT");
	TextDrawLetterSize(Store_Frame[24], 0.316603, 1.495000);
	TextDrawAlignment(Store_Frame[24], 1);
	TextDrawColor(Store_Frame[24], -1);
	TextDrawSetShadow(Store_Frame[24], 0);
	TextDrawSetOutline(Store_Frame[24], 1);
	TextDrawBackgroundColor(Store_Frame[24], 255);
	TextDrawFont(Store_Frame[24], 1);
	TextDrawSetProportional(Store_Frame[24], 1);
	TextDrawSetShadow(Store_Frame[24], 0);
	TextDrawSetSelectable(Store_Frame[24], true);

	Store_Frame[25] = TextDrawCreate(0, 0, "");
	TextDrawLetterSize(Store_Frame[25], 0.000000, 0.000000);
	TextDrawTextSize(Store_Frame[25], -46.000000, 10.000000);
	TextDrawAlignment(Store_Frame[25], 1);
	TextDrawColor(Store_Frame[25], -1);
	TextDrawSetShadow(Store_Frame[25], 0);
	TextDrawSetOutline(Store_Frame[25], 0);
	TextDrawBackgroundColor(Store_Frame[25], 0);
	TextDrawFont(Store_Frame[25], 5);
	TextDrawSetProportional(Store_Frame[25], 0);
	TextDrawSetShadow(Store_Frame[25], 0);
	//TextDrawSetSelectable(Store_Frame[25], true);
	TextDrawSetPreviewModel(Store_Frame[25], 0);
	TextDrawSetPreviewRot(Store_Frame[25], 0.000000, 0.000000, 0.000000, -1.000000);

	Store_Frame[26] = TextDrawCreate(420.248870, 169.583343, "");
	TextDrawLetterSize(Store_Frame[26], 0.000000, 0.000000);
	TextDrawTextSize(Store_Frame[26], -46.000000, 10.000000);
	TextDrawAlignment(Store_Frame[26], 1);
	TextDrawColor(Store_Frame[26], -1);
	TextDrawSetShadow(Store_Frame[26], 0);
	TextDrawSetOutline(Store_Frame[26], 0);
	TextDrawBackgroundColor(Store_Frame[26], 0);
	TextDrawFont(Store_Frame[26], 5);
	TextDrawSetProportional(Store_Frame[26], 0);
	TextDrawSetShadow(Store_Frame[26], 0);
	TextDrawSetSelectable(Store_Frame[26], true);
	TextDrawSetPreviewModel(Store_Frame[26], 0);
	TextDrawSetPreviewRot(Store_Frame[26], 0.000000, 0.000000, 0.000000, -1.000000);

	Store_Frame[27] = TextDrawCreate(229.092193, 185.916687, "Flowers");
	TextDrawLetterSize(Store_Frame[27], 0.256163, 1.407499);
	TextDrawAlignment(Store_Frame[27], 1);
	TextDrawColor(Store_Frame[27], -1);
	TextDrawSetShadow(Store_Frame[27], 0);
	TextDrawSetOutline(Store_Frame[27], 1);
	TextDrawBackgroundColor(Store_Frame[27], 255);
	TextDrawFont(Store_Frame[27], 1);
	TextDrawSetProportional(Store_Frame[27], 1);
	TextDrawSetShadow(Store_Frame[27], 0);

	Store_Frame[28] = TextDrawCreate(313.426177, 185.333358, "Cane");
	TextDrawLetterSize(Store_Frame[28], 0.256163, 1.407499);
	TextDrawAlignment(Store_Frame[28], 1);
	TextDrawColor(Store_Frame[28], -1);
	TextDrawSetShadow(Store_Frame[28], 0);
	TextDrawSetOutline(Store_Frame[28], 1);
	TextDrawBackgroundColor(Store_Frame[28], 255);
	TextDrawFont(Store_Frame[28], 1);
	TextDrawSetProportional(Store_Frame[28], 1);
	TextDrawSetShadow(Store_Frame[28], 0);

	Store_Frame[29] = TextDrawCreate(396.823181, 184.750015, "Camera");
	TextDrawLetterSize(Store_Frame[29], 0.256163, 1.407499);
	TextDrawAlignment(Store_Frame[29], 1);
	TextDrawColor(Store_Frame[29], -1);
	TextDrawSetShadow(Store_Frame[29], 0);
	TextDrawSetOutline(Store_Frame[29], 1);
	TextDrawBackgroundColor(Store_Frame[29], 255);
	TextDrawFont(Store_Frame[29], 1);
	TextDrawSetProportional(Store_Frame[29], 1);
	TextDrawSetShadow(Store_Frame[29], 0);
}

stock ShowShopList(playerid, bool:toggle)
{
	new
		//id = IsPlayerInBusiness(playerid),
		str[90]
	;

	if (toggle)
	{
	    SelectTextDraw(playerid, COLOR_GREY);
	    for(new x; x < 10; x ++) TextDrawShowForPlayer(playerid, Store_UI[x]);
	    //PlayerInfo[playerid][ItemCache][x] = -1;

	    for(new i; i < 30; i ++) TextDrawShowForPlayer(playerid, Store_Frame[i]);
	    
	    new maskid[24];
	    format(maskid, 24, "Mask~n~[51_926121]");//, PlayerInfo[playerid][pMaskID][0], PlayerInfo[playerid][pMaskID][1]);
	    PlayerTextDrawSetString(playerid, Store_Mask[playerid], maskid);

		format(str, sizeof(str), "�������� � ����");//, BusinessInfo[id][eBusinessName]);
		PlayerTextDrawSetString(playerid, Store_Business[playerid], str);

	    PlayerTextDrawShow(playerid, Store_Mask[playerid]);
	    PlayerTextDrawShow(playerid, Store_Cart[playerid]);
	    PlayerTextDrawShow(playerid, Store_Business[playerid]);

	    SetPVarInt(playerid, "PriceCount", 0);
	    SetPVarInt(playerid, "UI_Purchase", 1);
	}
	else
	{
	    for(new x; x < 10; x ++)
	    {
	        TextDrawHideForPlayer(playerid, Store_UI[x]);
	    }
	    for(new i; i < 30; i ++)
	    {
			TextDrawHideForPlayer(playerid, Store_Frame[i]);
	    }
	    PlayerTextDrawHide(playerid, Store_Mask[playerid]);
	    PlayerTextDrawHide(playerid, Store_Cart[playerid]);
	    PlayerTextDrawHide(playerid, Store_Business[playerid]);
	    SetPVarInt(playerid, "UI_Purchase", 0);
	}
	return 1;
}

CMD:testshop(playerid, params[])
{
	if (GetPVarInt(playerid, "UI_Purchase")) ShowShopList(playerid, false);
	else 									ShowShopList(playerid, true);
	
	return 1;
}*/