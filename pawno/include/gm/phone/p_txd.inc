/* Phone */
new 
    PlayerText:PhNote[2][MAX_PLAYERS],
    PlayerText:PhNetwork[MAX_PLAYERS],
    PlayerText:PhTime[MAX_PLAYERS],
	PlayerText:PhNewMSG[MAX_PLAYERS],
	PlayerText:PhBtn[2][MAX_PLAYERS],
    PlayerText:PhBtnStr[2][MAX_PLAYERS],
	PlayerText:PhArrow[4][MAX_PLAYERS],
	PlayerText:PhOFF[MAX_PLAYERS],
	PlayerText:PhoneTDdisplay[2][MAX_PLAYERS],
    PlayerText:PhNewMSGDisplay[2][MAX_PLAYERS],
    PlayerText:PhoneTDbox[5][MAX_PLAYERS],
	PlayerText:Ph_selfie[MAX_PLAYERS],
	PlayerText:NewSMS[MAX_PLAYERS],
	PlayerText:PhDisplay[MAX_PLAYERS],
	PlayerText:CallBox[MAX_PLAYERS],
	PlayerText:PhoneMenu[4][MAX_PLAYERS],
	PlayerText:PhoneMenuBg[4][MAX_PLAYERS]
;	


LoadPhoneTextDraw(playerid)
{
    // ================TEXTDRAWS================//

	PhoneTDbox[0][playerid] = CreatePlayerTextDraw(playerid,445.666656, 283.333221, "background");
	PlayerTextDrawLetterSize(playerid, PhoneTDbox[0][playerid], 0.000000, 21.124006);
	PlayerTextDrawTextSize(playerid, PhoneTDbox[0][playerid], 546.000244, 0.000000);
	PlayerTextDrawAlignment(playerid, PhoneTDbox[0][playerid], 1);
	PlayerTextDrawColor(playerid, PhoneTDbox[0][playerid], -1);
	PlayerTextDrawUseBox(playerid, PhoneTDbox[0][playerid], 1);
	PlayerTextDrawBoxColor(playerid, PhoneTDbox[0][playerid], phone_display_color[PlayerInfo[playerid][pPhoneModel]]);
	PlayerTextDrawSetShadow(playerid, PhoneTDbox[0][playerid], 0);
	PlayerTextDrawSetOutline(playerid, PhoneTDbox[0][playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, PhoneTDbox[0][playerid], 255);
	PlayerTextDrawFont(playerid, PhoneTDbox[0][playerid], 1);
	PlayerTextDrawSetProportional(playerid, PhoneTDbox[0][playerid], 1);
	PlayerTextDrawSetShadow(playerid, PhoneTDbox[0][playerid], 0);

	PhoneTDbox[1][playerid] = CreatePlayerTextDraw(playerid,442.916961, 274.777862, "LD_DRV:tvcorn");
	PlayerTextDrawLetterSize(playerid, PhoneTDbox[1][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, PhoneTDbox[1][playerid], 54.000000, 176.000000);
	PlayerTextDrawAlignment(playerid, PhoneTDbox[1][playerid], 1);
	PlayerTextDrawColor(playerid, PhoneTDbox[1][playerid], phone_model_color[PlayerInfo[playerid][pPhoneModel]]);
	PlayerTextDrawSetShadow(playerid, PhoneTDbox[1][playerid], 0);
	PlayerTextDrawSetOutline(playerid, PhoneTDbox[1][playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, PhoneTDbox[1][playerid], phone_model_color[PlayerInfo[playerid][pPhoneModel]]);
	PlayerTextDrawFont(playerid, PhoneTDbox[1][playerid], 4);
	PlayerTextDrawSetProportional(playerid, PhoneTDbox[1][playerid], 0);
	PlayerTextDrawSetShadow(playerid, PhoneTDbox[1][playerid], 0);

	PhoneTDbox[2][playerid] = CreatePlayerTextDraw(playerid,548.632690, 274.777893, "LD_DRV:tvcorn");
	PlayerTextDrawLetterSize(playerid, PhoneTDbox[2][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, PhoneTDbox[2][playerid], -54.000000, 176.000000);
	PlayerTextDrawAlignment(playerid, PhoneTDbox[2][playerid], 1);
	PlayerTextDrawColor(playerid, PhoneTDbox[2][playerid], phone_model_color[PlayerInfo[playerid][pPhoneModel]]);
	PlayerTextDrawSetShadow(playerid, PhoneTDbox[2][playerid], 0);
	PlayerTextDrawSetOutline(playerid, PhoneTDbox[2][playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, PhoneTDbox[2][playerid], phone_model_color[PlayerInfo[playerid][pPhoneModel]]);
	PlayerTextDrawFont(playerid, PhoneTDbox[2][playerid], 4);
	PlayerTextDrawSetProportional(playerid, PhoneTDbox[2][playerid], 0);
	PlayerTextDrawSetShadow(playerid, PhoneTDbox[2][playerid], 0);

	PhoneTDbox[3][playerid] = CreatePlayerTextDraw(playerid,467.366607, 308.844573, "LD_DRV:tvbase");
	PlayerTextDrawLetterSize(playerid, PhoneTDbox[3][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, PhoneTDbox[3][playerid], 54.000000, -2.000000);
	PlayerTextDrawAlignment(playerid, PhoneTDbox[3][playerid], 1);
	PlayerTextDrawColor(playerid, PhoneTDbox[3][playerid], phone_model_color[PlayerInfo[playerid][pPhoneModel]]);
	PlayerTextDrawSetShadow(playerid, PhoneTDbox[3][playerid], 0);
	PlayerTextDrawSetOutline(playerid, PhoneTDbox[3][playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, PhoneTDbox[3][playerid], phone_model_color[PlayerInfo[playerid][pPhoneModel]]);
	PlayerTextDrawFont(playerid, PhoneTDbox[3][playerid], 4);
	PlayerTextDrawSetProportional(playerid, PhoneTDbox[3][playerid], 0);
	PlayerTextDrawSetShadow(playerid, PhoneTDbox[3][playerid], 0);

	PhoneTDbox[4][playerid] = CreatePlayerTextDraw(playerid,476.666717, 294.048461, "PHONE");
	PlayerTextDrawLetterSize(playerid, PhoneTDbox[4][playerid], 0.274166, 1.071112);
	PlayerTextDrawAlignment(playerid, PhoneTDbox[4][playerid], 1);
	PlayerTextDrawColor(playerid, PhoneTDbox[4][playerid], -1);
	PlayerTextDrawSetShadow(playerid, PhoneTDbox[4][playerid], 0);
	PlayerTextDrawSetOutline(playerid, PhoneTDbox[4][playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, PhoneTDbox[4][playerid], 255);
	PlayerTextDrawFont(playerid, PhoneTDbox[4][playerid], 2);
	PlayerTextDrawSetProportional(playerid, PhoneTDbox[4][playerid], 1);
	PlayerTextDrawSetShadow(playerid, PhoneTDbox[4][playerid], 0);

	PhNewMSG[playerid] = CreatePlayerTextDraw(playerid,518.350402, 291.061187, "LD_BEAT:chit");
	PlayerTextDrawLetterSize(playerid, PhNewMSG[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, PhNewMSG[playerid], 7.000000, 9.000000);
	PlayerTextDrawAlignment(playerid, PhNewMSG[playerid], 1);
	PlayerTextDrawColor(playerid, PhNewMSG[playerid], 0xFFFFFFFF); //new msg - 0x007F14FF
	PlayerTextDrawSetShadow(playerid, PhNewMSG[playerid], 0);
	PlayerTextDrawSetOutline(playerid, PhNewMSG[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, PhNewMSG[playerid], 0xFFFFFFFF);
	PlayerTextDrawFont(playerid, PhNewMSG[playerid], 4);
	PlayerTextDrawSetProportional(playerid, PhNewMSG[playerid], 0);
	PlayerTextDrawSetShadow(playerid, PhNewMSG[playerid], 0);
	PlayerTextDrawSetSelectable(playerid, PhNewMSG[playerid], true);
	
	PhOFF[playerid] = CreatePlayerTextDraw(playerid,524.599914, 287.431396, "LD_BEAT:circle");
	PlayerTextDrawLetterSize(playerid, PhOFF[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, PhOFF[playerid], 10.000000, 10.000000);
	PlayerTextDrawAlignment(playerid, PhOFF[playerid], 1);
	PlayerTextDrawColor(playerid, PhOFF[playerid], -1);
	PlayerTextDrawSetShadow(playerid, PhOFF[playerid], 0);
	PlayerTextDrawSetOutline(playerid, PhOFF[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, PhOFF[playerid], 255);
	PlayerTextDrawFont(playerid, PhOFF[playerid], 4);
	PlayerTextDrawSetProportional(playerid, PhOFF[playerid], 0);
	PlayerTextDrawSetShadow(playerid, PhOFF[playerid], 0);
	PlayerTextDrawSetSelectable(playerid, PhOFF[playerid], true);

	Ph_selfie[playerid] = CreatePlayerTextDraw(playerid,543.550964, 340.610107, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, Ph_selfie[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, Ph_selfie[playerid],5.000000, 22.000000);
	PlayerTextDrawAlignment(playerid, Ph_selfie[playerid], 1);
	PlayerTextDrawColor(playerid, Ph_selfie[playerid], -2139062017);
	PlayerTextDrawSetShadow(playerid, Ph_selfie[playerid], 0);
	PlayerTextDrawSetOutline(playerid, Ph_selfie[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, Ph_selfie[playerid], 255);
	PlayerTextDrawFont(playerid, Ph_selfie[playerid], 4);
	PlayerTextDrawSetProportional(playerid, Ph_selfie[playerid], 0);
	PlayerTextDrawSetShadow(playerid, Ph_selfie[playerid], 0);
	PlayerTextDrawSetSelectable(playerid, Ph_selfie[playerid], true);

	NewSMS[playerid] = CreatePlayerTextDraw(playerid,440.416595, 249.370346, "LD_CHAT:goodcha");
	PlayerTextDrawLetterSize(playerid, NewSMS[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, NewSMS[playerid], -19.000000, 24.000000);
	PlayerTextDrawAlignment(playerid, NewSMS[playerid], 1);
	PlayerTextDrawColor(playerid, NewSMS[playerid], -1);
	PlayerTextDrawSetShadow(playerid, NewSMS[playerid], 0);
	PlayerTextDrawSetOutline(playerid, NewSMS[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, NewSMS[playerid], 255);
	PlayerTextDrawFont(playerid, NewSMS[playerid], 4);
	PlayerTextDrawSetProportional(playerid, NewSMS[playerid], 0);
	PlayerTextDrawSetShadow(playerid, NewSMS[playerid], 0);
	
	PhNetwork[playerid] = CreatePlayerTextDraw(playerid,536.083435, 320.148101, "|~r~||||"); // ����� (���)
	PlayerTextDrawLetterSize(playerid, PhNetwork[playerid], 0.197916, 0.868888);
	PlayerTextDrawAlignment(playerid, PhNetwork[playerid], 3);
	PlayerTextDrawColor(playerid, PhNetwork[playerid], 255);
	PlayerTextDrawSetShadow(playerid, PhNetwork[playerid], 0);
	PlayerTextDrawSetOutline(playerid, PhNetwork[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, PhNetwork[playerid], 255);
	PlayerTextDrawFont(playerid, PhNetwork[playerid], 1);
	PlayerTextDrawSetProportional(playerid, PhNetwork[playerid], 1);
	PlayerTextDrawSetShadow(playerid, PhNetwork[playerid], 0);

	PhTime[playerid] = CreatePlayerTextDraw(playerid,455.683410, 320.148101, "16:01");
	PlayerTextDrawLetterSize(playerid, PhTime[playerid], 0.197916, 0.868888);
	PlayerTextDrawAlignment(playerid, PhTime[playerid], 1);
	PlayerTextDrawColor(playerid, PhTime[playerid], 255);
	PlayerTextDrawBackgroundColor(playerid, PhTime[playerid], 255);
	PlayerTextDrawFont(playerid, PhTime[playerid], 1);
	PlayerTextDrawSetProportional(playerid, PhTime[playerid], 1);
	PlayerTextDrawSetShadow(playerid, PhTime[playerid], 0);
	PlayerTextDrawSetOutline(playerid, PhTime[playerid], 0);

	PhArrow[0][playerid] = CreatePlayerTextDraw(playerid,479.633392, 413.795959, "LD_BEAT:left");
	PlayerTextDrawLetterSize(playerid, PhArrow[0][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, PhArrow[0][playerid], 15.000000, 15.000000);
	PlayerTextDrawAlignment(playerid, PhArrow[0][playerid], 1);
	PlayerTextDrawColor(playerid, PhArrow[0][playerid], -1);
	PlayerTextDrawSetShadow(playerid, PhArrow[0][playerid], 0);
	PlayerTextDrawSetOutline(playerid, PhArrow[0][playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, PhArrow[0][playerid], 255);
	PlayerTextDrawFont(playerid, PhArrow[0][playerid], 4);
	PlayerTextDrawSetProportional(playerid, PhArrow[0][playerid], 0);
	PlayerTextDrawSetShadow(playerid, PhArrow[0][playerid], 0);
	PlayerTextDrawSetSelectable(playerid, PhArrow[0][playerid], true);

	PhArrow[1][playerid] = CreatePlayerTextDraw(playerid,498.800018, 413.795959, "LD_BEAT:right");
	PlayerTextDrawLetterSize(playerid, PhArrow[1][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, PhArrow[1][playerid], 15.000000, 15.000000);
	PlayerTextDrawAlignment(playerid, PhArrow[1][playerid], 1);
	PlayerTextDrawColor(playerid, PhArrow[1][playerid], -1);
	PlayerTextDrawSetShadow(playerid, PhArrow[1][playerid], 0);
	PlayerTextDrawSetOutline(playerid, PhArrow[1][playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, PhArrow[1][playerid], 255);
	PlayerTextDrawFont(playerid, PhArrow[1][playerid], 4);
	PlayerTextDrawSetProportional(playerid, PhArrow[1][playerid], 0);
	PlayerTextDrawSetShadow(playerid, PhArrow[1][playerid], 0);
	PlayerTextDrawSetSelectable(playerid, PhArrow[1][playerid], true);

	PhArrow[2][playerid] = CreatePlayerTextDraw(playerid,489.316772, 399.551422, "LD_BEAT:up");
	PlayerTextDrawLetterSize(playerid, PhArrow[2][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, PhArrow[2][playerid], 15.000000, 15.000000);
	PlayerTextDrawAlignment(playerid, PhArrow[2][playerid], 1);
	PlayerTextDrawColor(playerid, PhArrow[2][playerid], -1);
	PlayerTextDrawSetShadow(playerid, PhArrow[2][playerid], 0);
	PlayerTextDrawSetOutline(playerid, PhArrow[2][playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, PhArrow[2][playerid], 255);
	PlayerTextDrawFont(playerid, PhArrow[2][playerid], 4);
	PlayerTextDrawSetProportional(playerid, PhArrow[2][playerid], 0);
	PlayerTextDrawSetShadow(playerid, PhArrow[2][playerid], 0);
	PlayerTextDrawSetSelectable(playerid, PhArrow[2][playerid], true);

	PhArrow[3][playerid] = CreatePlayerTextDraw(playerid,489.333404, 427.514404, "LD_BEAT:down");
	PlayerTextDrawLetterSize(playerid, PhArrow[3][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, PhArrow[3][playerid], 15.000000, 15.000000);
	PlayerTextDrawAlignment(playerid, PhArrow[3][playerid], 1);
	PlayerTextDrawColor(playerid, PhArrow[3][playerid], -1);
	PlayerTextDrawSetShadow(playerid, PhArrow[3][playerid], 0);
	PlayerTextDrawSetOutline(playerid, PhArrow[3][playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, PhArrow[3][playerid], 255);
	PlayerTextDrawFont(playerid, PhArrow[3][playerid], 4);
	PlayerTextDrawSetProportional(playerid, PhArrow[3][playerid], 0);
	PlayerTextDrawSetShadow(playerid, PhArrow[3][playerid], 0);
	PlayerTextDrawSetSelectable(playerid, PhArrow[3][playerid], true);

	PhBtnStr[0][playerid] = CreatePlayerTextDraw(playerid,455.251892, 381.733459, "��");  
	PlayerTextDrawLetterSize(playerid, PhBtnStr[0][playerid], 0.209166, 0.988148);
	PlayerTextDrawAlignment(playerid, PhBtnStr[0][playerid], 1);
	PlayerTextDrawColor(playerid, PhBtnStr[0][playerid], 255);
	PlayerTextDrawSetShadow(playerid, PhBtnStr[0][playerid], 0);
	PlayerTextDrawSetOutline(playerid, PhBtnStr[0][playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, PhBtnStr[0][playerid], 255);
	PlayerTextDrawFont(playerid, PhBtnStr[0][playerid], 1);
	PlayerTextDrawSetProportional(playerid, PhBtnStr[0][playerid], 1);
	PlayerTextDrawSetShadow(playerid, PhBtnStr[0][playerid], 0);

	PhBtnStr[1][playerid] = CreatePlayerTextDraw(playerid,534.566833, 381.733459, "QUAY LAI");
	PlayerTextDrawLetterSize(playerid, PhBtnStr[1][playerid], 0.209166, 0.988148);
	PlayerTextDrawAlignment(playerid, PhBtnStr[1][playerid], 3);
	PlayerTextDrawColor(playerid, PhBtnStr[1][playerid], 255);
	PlayerTextDrawSetShadow(playerid, PhBtnStr[1][playerid], 0);
	PlayerTextDrawSetOutline(playerid, PhBtnStr[1][playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, PhBtnStr[1][playerid], 255);
	PlayerTextDrawFont(playerid, PhBtnStr[1][playerid], 1);
	PlayerTextDrawSetProportional(playerid, PhBtnStr[1][playerid], 1);
	PlayerTextDrawSetShadow(playerid, PhBtnStr[1][playerid], 0);

	PhBtn[0][playerid] = CreatePlayerTextDraw(playerid,454.999450, 397.526245, "box"); //MENU BUTTON
	PlayerTextDrawLetterSize(playerid, PhBtn[0][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, PhBtn[0][playerid], 19.000000, 10.000000);
	PlayerTextDrawAlignment(playerid, PhBtn[0][playerid], 1);
	PlayerTextDrawColor(playerid, PhBtn[0][playerid], phone_btns_color[PlayerInfo[playerid][pPhoneModel]]);
	PlayerTextDrawSetOutline(playerid, PhBtn[0][playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, PhBtn[0][playerid], phone_btns_color[PlayerInfo[playerid][pPhoneModel]]);
	PlayerTextDrawFont(playerid, PhBtn[0][playerid], 5);
	PlayerTextDrawSetProportional(playerid, PhBtn[0][playerid], 0);
	PlayerTextDrawSetSelectable(playerid, PhBtn[0][playerid], true);
	PlayerTextDrawSetPreviewModel(playerid, PhBtn[0][playerid], 0);
	PlayerTextDrawSetPreviewRot(playerid, PhBtn[0][playerid], 0.000000, 0.000000, 0.000000, -1.000000);

	PhBtn[1][playerid] = CreatePlayerTextDraw(playerid,515.984130, 397.525848, "box"); //BACK BUTTON
	PlayerTextDrawLetterSize(playerid, PhBtn[1][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, PhBtn[1][playerid], 19.000000, 10.000000);
	PlayerTextDrawAlignment(playerid, PhBtn[1][playerid], 1);
	PlayerTextDrawColor(playerid, PhBtn[1][playerid], phone_btns_color[PlayerInfo[playerid][pPhoneModel]]);
	PlayerTextDrawSetOutline(playerid, PhBtn[1][playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, PhBtn[1][playerid], phone_btns_color[PlayerInfo[playerid][pPhoneModel]]);
	PlayerTextDrawFont(playerid, PhBtn[1][playerid], 5);
	PlayerTextDrawSetProportional(playerid, PhBtn[1][playerid], 0);
	PlayerTextDrawSetSelectable(playerid, PhBtn[1][playerid], true);
	PlayerTextDrawSetPreviewModel(playerid, PhBtn[1][playerid], 0);
	PlayerTextDrawSetPreviewRot(playerid, PhBtn[1][playerid], 0.000000, 0.000000, 0.000000, -1.000000);
	
	PhNote[0][playerid] = CreatePlayerTextDraw(playerid,470.000030, 348.007324, "LD_CHAT:thumbup"); //Emoji
	PlayerTextDrawLetterSize(playerid, PhNote[0][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, PhNote[0][playerid], -10.000000, 13.000000);
	PlayerTextDrawAlignment(playerid, PhNote[0][playerid], 1);
	PlayerTextDrawColor(playerid, PhNote[0][playerid], -1);
	PlayerTextDrawSetShadow(playerid, PhNote[0][playerid], 0);
	PlayerTextDrawSetOutline(playerid, PhNote[0][playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, PhNote[0][playerid], 255);
	PlayerTextDrawFont(playerid, PhNote[0][playerid], 4);
	PlayerTextDrawSetProportional(playerid, PhNote[0][playerid], 0);
	PlayerTextDrawSetShadow(playerid, PhNote[0][playerid], 0);

	PhNote[1][playerid] = CreatePlayerTextDraw(playerid,495.333129, 350.217681, "Da gui tin nhan!"); //Text  or  "Goi dien...~n~5552255")
	PlayerTextDrawLetterSize(playerid, PhNote[1][playerid], 0.197916, 0.868888);
	PlayerTextDrawAlignment(playerid, PhNote[1][playerid], 2);
	PlayerTextDrawColor(playerid, PhNote[1][playerid], 255);
	PlayerTextDrawSetShadow(playerid, PhNote[1][playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, PhNote[1][playerid], -1378294017);
	PlayerTextDrawFont(playerid, PhNote[1][playerid], 1);
	PlayerTextDrawSetProportional(playerid, PhNote[1][playerid], 1);
	PlayerTextDrawSetOutline(playerid, PhNote[1][playerid], 0);
	
	// ����� � �������� �� ����� ������
	/*CallBox[0][playerid] = CreatePlayerTextDraw(playerid,454.999908, 320.148101, "CallBox"); // CallBox
	TextDrawLetterSize(CallBox[0][playerid], 0.000000, 0.791667);
	TextDrawTextSize(CallBox[0][playerid], 536.000000, 0.000000);
	TextDrawAlignment(CallBox[0][playerid], 1);
	TextDrawColor(CallBox[0][playerid], -1);
	
	TextDrawSetShadow(CallBox[0][playerid], 0);
	TextDrawSetOutline(CallBox[0][playerid], 0);
	TextDrawBackgroundColor(CallBox[0][playerid], 255);
	TextDrawFont(CallBox[0][playerid], 1);
	TextDrawSetProportional(CallBox[0][playerid], 1);
	TextDrawSetShadow(CallBox[0][playerid], 0);
	
	CallBox[playerid] = CreatePlayerTextDraw(playerid,487.083129, 320.148101, "00:00"); // CALL TIME
	TextDrawLetterSize(CallBox[playerid], 0.197916, 0.868888);// 0.196666, 0.946667);
	TextDrawAlignment(CallBox[playerid], 1);
	TextDrawColor(CallBox[playerid], 255);
	TextDrawUseBox(CallBox[playerid], 1);
	TextDrawBoxColor(CallBox[playerid], COLOR_GRAD2);
	TextDrawSetShadow(CallBox[playerid], 0);
	TextDrawSetOutline(CallBox[playerid], 0);
	TextDrawBackgroundColor(CallBox[playerid], 255);
	TextDrawFont(CallBox[playerid], 1);
	TextDrawSetProportional(CallBox[playerid], 1);
	TextDrawSetShadow(CallBox[playerid], 0);

	CallBox[playerid] = CreatePlayerTextDraw(playerid,495.366668, 315.963104, "01:02");
	TextDrawLetterSize(CallBox[playerid], 0.197916, 0.868888); // 0.182500, 0.899999);
	TextDrawTextSize(CallBox[playerid], 0.000000, 77.930198);
	TextDrawAlignment(CallBox[playerid], 2);
	TextDrawColor(CallBox[playerid], -1);
	TextDrawUseBox(CallBox[playerid], 1);
	TextDrawBoxColor(CallBox[playerid], 0xFF6347AA);
	TextDrawSetShadow(CallBox[playerid], 0);
	TextDrawSetOutline(CallBox[playerid], 0);
	TextDrawBackgroundColor(CallBox[playerid], 255);
	TextDrawFont(CallBox[playerid], 1);
	TextDrawSetProportional(CallBox[playerid], 1);
	TextDrawSetShadow(CallBox[playerid], 0);
	
	CallBox[playerid] = CreatePlayerTextDraw(playerid,495.416656, 319.948181, "01:10");
	TextDrawLetterSize(CallBox[playerid], 0.197916, 0.868888);
	TextDrawTextSize(CallBox[playerid], 81.000000, 81.000000);
	TextDrawAlignment(CallBox[playerid], 2);
	TextDrawColor(CallBox[playerid], -1);
	TextDrawUseBox(CallBox[playerid], 1);
	TextDrawBoxColor(CallBox[playerid], 0xFF6347AA);//-2147483393);
	TextDrawSetShadow(CallBox[playerid], 0);
	TextDrawSetOutline(CallBox[playerid], 0);
	TextDrawBackgroundColor(CallBox[playerid], 255);
	TextDrawFont(CallBox[playerid], 1);
	TextDrawSetProportional(CallBox[playerid], 1);
	TextDrawSetShadow(CallBox[playerid], 0);
	TextDrawSetSelectable(CallBox[playerid], true);*/
		
	// ������� ��������
	PhoneTDdisplay[0][playerid] = CreatePlayerTextDraw(playerid,478.116699, 328.599792, "22:22"); //TIME
	PlayerTextDrawLetterSize(playerid, PhoneTDdisplay[0][playerid], 0.415416, 2.885926);
	PlayerTextDrawAlignment(playerid, PhoneTDdisplay[0][playerid], 1);
	PlayerTextDrawColor(playerid, PhoneTDdisplay[0][playerid], 255);
	PlayerTextDrawSetShadow(playerid, PhoneTDdisplay[0][playerid], 0);
	PlayerTextDrawSetOutline(playerid, PhoneTDdisplay[0][playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, PhoneTDdisplay[0][playerid], 255);
	PlayerTextDrawFont(playerid, PhoneTDdisplay[0][playerid], 1);
	PlayerTextDrawSetProportional(playerid, PhoneTDdisplay[0][playerid], 1);
	PlayerTextDrawSetShadow(playerid, PhoneTDdisplay[0][playerid], 0);

	PhoneTDdisplay[1][playerid] = CreatePlayerTextDraw(playerid,495.233459, 348.848205, "1"); // DATE
	PlayerTextDrawLetterSize(playerid, PhoneTDdisplay[1][playerid], 0.221250, 1.428888);
	PlayerTextDrawAlignment(playerid, PhoneTDdisplay[1][playerid], 2);
	PlayerTextDrawColor(playerid, PhoneTDdisplay[1][playerid], 255);
	PlayerTextDrawSetShadow(playerid, PhoneTDdisplay[1][playerid], 0);
	PlayerTextDrawSetOutline(playerid, PhoneTDdisplay[1][playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, PhoneTDdisplay[1][playerid], 255);
	PlayerTextDrawFont(playerid, PhoneTDdisplay[1][playerid], 1);
	PlayerTextDrawSetProportional(playerid, PhoneTDdisplay[1][playerid], 1);
	PlayerTextDrawSetShadow(playerid, PhoneTDdisplay[1][playerid], 0);

    
	PhNewMSGDisplay[0][playerid] = CreatePlayerTextDraw(playerid,477.649810, 365.562957, "LD_CHAT:badchat");
	PlayerTextDrawLetterSize(playerid, PhNewMSGDisplay[0][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, PhNewMSGDisplay[0][playerid], -8.000000, 9.000000);
	PlayerTextDrawAlignment(playerid, PhNewMSGDisplay[0][playerid], 1);
	PlayerTextDrawColor(playerid, PhNewMSGDisplay[0][playerid], -1);
	PlayerTextDrawSetShadow(playerid, PhNewMSGDisplay[0][playerid], 0);
	PlayerTextDrawSetOutline(playerid, PhNewMSGDisplay[0][playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, PhNewMSGDisplay[0][playerid], 255);
	PlayerTextDrawFont(playerid, PhNewMSGDisplay[0][playerid], 4);
	PlayerTextDrawSetProportional(playerid, PhNewMSGDisplay[0][playerid], 0);
	PlayerTextDrawSetShadow(playerid, PhNewMSGDisplay[0][playerid], 0);

	PhNewMSGDisplay[1][playerid] = CreatePlayerTextDraw(playerid,472.649810, 365.562957, "- tin nhan moi"); //479.317626, 365.303802,
	PlayerTextDrawLetterSize(playerid, PhNewMSGDisplay[1][playerid], 0.144166, 1.019258);
	PlayerTextDrawAlignment(playerid, PhNewMSGDisplay[1][playerid], 1);
	PlayerTextDrawColor(playerid, PhNewMSGDisplay[1][playerid], -1523963137);
	PlayerTextDrawSetShadow(playerid, PhNewMSGDisplay[1][playerid], 0);
	PlayerTextDrawSetOutline(playerid, PhNewMSGDisplay[1][playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, PhNewMSGDisplay[1][playerid], 255);
	PlayerTextDrawFont(playerid, PhNewMSGDisplay[1][playerid], 1);
	PlayerTextDrawSetProportional(playerid, PhNewMSGDisplay[1][playerid], 1);
	PlayerTextDrawSetShadow(playerid, PhNewMSGDisplay[1][playerid], 0);

	PhDisplay[playerid] = CreatePlayerTextDraw(playerid,454.999816, 320.148162, "display");
	PlayerTextDrawLetterSize(playerid, PhDisplay[playerid], 0.000000, 7.791664);
	PlayerTextDrawTextSize(playerid, PhDisplay[playerid], 536.000000, 0.000000);
	PlayerTextDrawAlignment(playerid, PhDisplay[playerid], 1);
	PlayerTextDrawColor(playerid, PhDisplay[playerid], -1);
	PlayerTextDrawUseBox(playerid, PhDisplay[playerid], 1);
	PlayerTextDrawBoxColor(playerid, PhDisplay[playerid], phone_window[PlayerInfo[playerid][pPhoneStyle]]);
	PlayerTextDrawSetShadow(playerid, PhDisplay[playerid], 0);
	PlayerTextDrawSetOutline(playerid, PhDisplay[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, PhDisplay[playerid], phone_window[PlayerInfo[playerid][pPhoneStyle]]);
	PlayerTextDrawFont(playerid, PhDisplay[playerid], 1);
	PlayerTextDrawSetProportional(playerid, PhDisplay[playerid], 1);
	PlayerTextDrawSetShadow(playerid, PhDisplay[playerid], 0);

	PhoneMenuBg[0][playerid] = CreatePlayerTextDraw(playerid,454.683410, 329.736022, "Danh ba");//���
	PlayerTextDrawLetterSize(playerid, PhoneMenuBg[0][playerid], 0.197916, 0.868889);
	PlayerTextDrawTextSize(playerid, PhoneMenuBg[0][playerid], 81.000000, 12.000000);
	PlayerTextDrawAlignment(playerid, PhoneMenuBg[0][playerid], 1);
	PlayerTextDrawColor(playerid, PhoneMenuBg[0][playerid], phone_panel[PlayerInfo[playerid][pPhoneStyle]]);	
	PlayerTextDrawSetShadow(playerid, PhoneMenuBg[0][playerid], 0);
	PlayerTextDrawSetOutline(playerid, PhoneMenuBg[0][playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, PhoneMenuBg[0][playerid], phone_panel[PlayerInfo[playerid][pPhoneStyle]]);
	PlayerTextDrawFont(playerid, PhoneMenuBg[0][playerid], 5);
	PlayerTextDrawSetProportional(playerid, PhoneMenuBg[0][playerid], 0);
	PlayerTextDrawSetShadow(playerid, PhoneMenuBg[0][playerid], 0);
	PlayerTextDrawSetSelectable(playerid, PhoneMenuBg[0][playerid], true);
	PlayerTextDrawSetPreviewModel(playerid, PhoneMenuBg[0][playerid], 0);
	PlayerTextDrawSetPreviewRot(playerid, PhoneMenuBg[0][playerid], 0.000000, 0.000000, 0.000000, -1.000000);

	PhoneMenuBg[1][playerid] = CreatePlayerTextDraw(playerid,454.683410, 342.132995, "Goi dien"); //���
	PlayerTextDrawLetterSize(playerid, PhoneMenuBg[1][playerid], 0.197916, 0.868889);
	PlayerTextDrawTextSize(playerid, PhoneMenuBg[1][playerid], 81.000000, 12.000000);
	PlayerTextDrawAlignment(playerid, PhoneMenuBg[1][playerid], 1);
	PlayerTextDrawColor(playerid, PhoneMenuBg[1][playerid], phone_panel[PlayerInfo[playerid][pPhoneStyle]]);
	PlayerTextDrawSetShadow(playerid, PhoneMenuBg[1][playerid], 0);
	PlayerTextDrawSetOutline(playerid, PhoneMenuBg[1][playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, PhoneMenuBg[1][playerid], phone_panel[PlayerInfo[playerid][pPhoneStyle]]);
	PlayerTextDrawFont(playerid, PhoneMenuBg[1][playerid], 5);
	PlayerTextDrawSetProportional(playerid, PhoneMenuBg[1][playerid], 0);
	PlayerTextDrawSetShadow(playerid, PhoneMenuBg[1][playerid], 0);
	PlayerTextDrawSetSelectable(playerid, PhoneMenuBg[1][playerid], true);
	PlayerTextDrawSetPreviewModel(playerid, PhoneMenuBg[1][playerid], 0);
	PlayerTextDrawSetPreviewRot(playerid, PhoneMenuBg[1][playerid], 0.000000, 0.000000, 0.000000, -1.000000);
	
	PhoneMenuBg[2][playerid] = CreatePlayerTextDraw(playerid,454.683410, 354.629943, "SMS"); //���
	PlayerTextDrawLetterSize(playerid, PhoneMenuBg[2][playerid], 0.197916, 0.868889);
	PlayerTextDrawTextSize(playerid, PhoneMenuBg[2][playerid], 81.000000, 12.000000);
	PlayerTextDrawAlignment(playerid, PhoneMenuBg[2][playerid], 1);
	PlayerTextDrawColor(playerid, PhoneMenuBg[2][playerid], phone_panel[PlayerInfo[playerid][pPhoneStyle]]);
	PlayerTextDrawSetShadow(playerid, PhoneMenuBg[2][playerid], 0);
	PlayerTextDrawSetOutline(playerid, PhoneMenuBg[2][playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, PhoneMenuBg[2][playerid], phone_panel[PlayerInfo[playerid][pPhoneStyle]]);
	PlayerTextDrawFont(playerid, PhoneMenuBg[2][playerid], 5);
	PlayerTextDrawSetProportional(playerid, PhoneMenuBg[2][playerid], 0);
	PlayerTextDrawSetShadow(playerid, PhoneMenuBg[2][playerid], 0);
	PlayerTextDrawSetSelectable(playerid, PhoneMenuBg[2][playerid], true);
	PlayerTextDrawSetPreviewModel(playerid, PhoneMenuBg[2][playerid], 0);
	PlayerTextDrawSetPreviewRot(playerid, PhoneMenuBg[2][playerid], 0.000000, 0.000000, 0.000000, -1.000000);

	PhoneMenuBg[3][playerid] = CreatePlayerTextDraw(playerid,454.683410, 366.976928, "Cai dat"); //���
	PlayerTextDrawLetterSize(playerid, PhoneMenuBg[3][playerid], 0.197916, 0.868889);
	PlayerTextDrawTextSize(playerid, PhoneMenuBg[3][playerid], 81.000000, 12.000000);
	PlayerTextDrawAlignment(playerid, PhoneMenuBg[3][playerid], 1);
	PlayerTextDrawColor(playerid, PhoneMenuBg[3][playerid], phone_panel[PlayerInfo[playerid][pPhoneStyle]]);
	PlayerTextDrawSetShadow(playerid, PhoneMenuBg[3][playerid], 0);
	PlayerTextDrawSetOutline(playerid, PhoneMenuBg[3][playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, PhoneMenuBg[3][playerid], phone_panel[PlayerInfo[playerid][pPhoneStyle]]);
	PlayerTextDrawFont(playerid, PhoneMenuBg[3][playerid], 5);
	PlayerTextDrawSetProportional(playerid, PhoneMenuBg[3][playerid], 0);
	PlayerTextDrawSetShadow(playerid, PhoneMenuBg[3][playerid], 0);
	PlayerTextDrawSetSelectable(playerid, PhoneMenuBg[3][playerid], true);
	PlayerTextDrawSetPreviewModel(playerid, PhoneMenuBg[3][playerid], 0);
	PlayerTextDrawSetPreviewRot(playerid, PhoneMenuBg[3][playerid], 0.000000, 0.000000, 0.000000, -1.000000);

	PhoneMenu[0][playerid] = CreatePlayerTextDraw(playerid, 455.683410, 331.736022, "Danh ba");
	PlayerTextDrawLetterSize(playerid, PhoneMenu[0][playerid], 0.197916, 0.868889);
	PlayerTextDrawTextSize(playerid, PhoneMenu[0][playerid], 534.850036, 0.000000);
	PlayerTextDrawAlignment(playerid, PhoneMenu[0][playerid], 1);
	PlayerTextDrawColor(playerid, PhoneMenu[0][playerid], 255);
	PlayerTextDrawSetShadow(playerid, PhoneMenu[0][playerid], 0);
	PlayerTextDrawSetOutline(playerid, PhoneMenu[0][playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, PhoneMenu[0][playerid], -1378294017);
	PlayerTextDrawFont(playerid, PhoneMenu[0][playerid], 1);
	PlayerTextDrawSetProportional(playerid, PhoneMenu[0][playerid], 1);

	PhoneMenu[1][playerid] = CreatePlayerTextDraw(playerid, 455.683410, 344.132995, "Goi dien");
	PlayerTextDrawLetterSize(playerid, PhoneMenu[1][playerid], 0.197916, 0.868889);
	PlayerTextDrawTextSize(playerid, PhoneMenu[1][playerid], 534.850036, 0.000000);
	PlayerTextDrawAlignment(playerid, PhoneMenu[1][playerid], 1);
	PlayerTextDrawColor(playerid, PhoneMenu[1][playerid], 255);
	PlayerTextDrawSetShadow(playerid, PhoneMenu[1][playerid], 0);
	PlayerTextDrawSetOutline(playerid, PhoneMenu[1][playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, PhoneMenu[1][playerid], -1378294017);
	PlayerTextDrawFont(playerid, PhoneMenu[1][playerid], 1);
	PlayerTextDrawSetProportional(playerid, PhoneMenu[1][playerid], 1);

	PhoneMenu[2][playerid] = CreatePlayerTextDraw(playerid, 455.683410, 356.629943, "Tin nhan	");
	PlayerTextDrawLetterSize(playerid, PhoneMenu[2][playerid], 0.197916, 0.868889);
	PlayerTextDrawTextSize(playerid, PhoneMenu[2][playerid], 534.850036, 0.000000);
	PlayerTextDrawAlignment(playerid, PhoneMenu[2][playerid], 1);
	PlayerTextDrawColor(playerid, PhoneMenu[2][playerid], 255);
	PlayerTextDrawSetShadow(playerid, PhoneMenu[2][playerid], 0);
	PlayerTextDrawSetOutline(playerid, PhoneMenu[2][playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, PhoneMenu[2][playerid], -1378294017);
	PlayerTextDrawFont(playerid, PhoneMenu[2][playerid], 1);
	PlayerTextDrawSetProportional(playerid, PhoneMenu[2][playerid], 1);
	PlayerTextDrawSetShadow(playerid, PhoneMenu[2][playerid], 0);

	PhoneMenu[3][playerid] = CreatePlayerTextDraw(playerid, 455.683410, 368.976928, "Cai dat");
	PlayerTextDrawLetterSize(playerid, PhoneMenu[3][playerid], 0.197916, 0.868889);
	PlayerTextDrawTextSize(playerid, PhoneMenu[3][playerid], 534.850036, 0.000000);
	PlayerTextDrawAlignment(playerid, PhoneMenu[3][playerid], 1);
	PlayerTextDrawColor(playerid, PhoneMenu[3][playerid], 255);
	PlayerTextDrawSetShadow(playerid, PhoneMenu[3][playerid], 0);
	PlayerTextDrawSetOutline(playerid, PhoneMenu[3][playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, PhoneMenu[3][playerid], -1378294017);
	PlayerTextDrawFont(playerid, PhoneMenu[3][playerid], 1);
	PlayerTextDrawSetProportional(playerid, PhoneMenu[3][playerid], 1);
	PlayerTextDrawSetShadow(playerid, PhoneMenu[3][playerid], 0);

	CallBox[playerid] = CreatePlayerTextDraw(playerid,495.416778, 320.147979, "00:30");
	PlayerTextDrawLetterSize(playerid, CallBox[playerid], 0.154166, 0.713333);
	PlayerTextDrawTextSize(playerid, CallBox[playerid], 10.000000, 81.000000);
	PlayerTextDrawAlignment(playerid, CallBox[playerid], 2);
	PlayerTextDrawColor(playerid, CallBox[playerid], 255);
	PlayerTextDrawUseBox(playerid, CallBox[playerid], 1);
	PlayerTextDrawBoxColor(playerid, CallBox[playerid], COLOR_LIGHTRED);
	PlayerTextDrawSetShadow(playerid, CallBox[playerid], 0);
	PlayerTextDrawSetOutline(playerid, CallBox[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, CallBox[playerid], 255);
	PlayerTextDrawFont(playerid, CallBox[playerid], 1);
	PlayerTextDrawSetProportional(playerid, CallBox[playerid], 1);
	PlayerTextDrawSetShadow(playerid, CallBox[playerid], 0);
	PlayerTextDrawSetSelectable(playerid, CallBox[playerid], true);

    return 1;
}