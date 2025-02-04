CMD:showcontacts(playerid, params[])
{
    if (PlayerInfo[playerid][pNumber] == 0)
		return SendErrorMessage(playerid, "Ban khong co dien thoai.");

    if (PlayerInfo[playerid][pPhoneOff] != 0)
        return SendErrorMessage(playerid, "Dien thoai da tat nguon.");

	new userid;
	if (sscanf(params,"u", userid)) return SendHelpMessage(playerid, "/showcontacts [ID/Ten]");

	if (!IsPlayerLogged(userid))
		return SendNotConnected(playerid);

	if (!PlayerNearPlayer(3.0, playerid, userid))
		return SendNotNearPlayer(playerid);

	new count;
	for(new i = 0; i < MAX_PLAYER_CONTACTS; i++)
	{
		if (PlayerContacts[playerid][i][contactOn] == 0)
		    continue;

		count++;
		break;
	}

	if (count == 0)
	    return SendErrorMessage(playerid, "Ban khong co lien he.");


	SendClientMessageEx(userid, COLOR_HELPS, "%s cho ban xem danh sach cac lien he.", GetNameWithMask(playerid));
   	SendClientMessageEx(playerid, COLOR_HELPS, "Ban da cho %s danh sach lien he cua ban. ", GetNameWithMask(userid));

	count = 0;
	for(new i = 0; i < MAX_PLAYER_CONTACTS; i++)
	{
		if (PlayerContacts[playerid][i][contactOn] == 0)
		    continue;

		count++;
		SendClientMessageEx(userid, COLOR_GRAD2, "%i. %s - so dien thoai: %i", count, PlayerContacts[playerid][i][contactName], PlayerContacts[playerid][i][contactNumber]);
	}

    new mes[128];
	format(mes, sizeof(mes), "%s hien thi danh ba tu dien thoai %s", GetNameWithMask(playerid), GetNameWithMask(userid));
	SetPlayerChatBubble(playerid, mes, COLOR_PURPLE, 15.0, 3000);
	return 1;
}

CMD:showcontact(playerid, params[])
{
    if (PlayerInfo[playerid][pNumber] == 0)
		return SendErrorMessage(playerid, "Ban khong co dien thoai.");

    if (PlayerInfo[playerid][pPhoneOff] != 0)
        return SendErrorMessage(playerid, "Dien thoai da tat nguon.");

    new userid,
        contact[32];

	if (sscanf(params,"us[32]", userid, contact)) return SendHelpMessage(playerid, "/showcontacts [ID/Ten] [lien he]");

	if (!IsPlayerLogged(userid))
		return SendNotConnected(playerid);

	if (!PlayerNearPlayer(3.0, playerid, userid))
		return SendNotNearPlayer(playerid);

	new count = -1;
	for(new i = 0; i < MAX_PLAYER_CONTACTS; i++)
	{
		if (PlayerContacts[playerid][i][contactOn] == 0 || !CompareStrings(contact, PlayerContacts[playerid][i][contactName]))
		    continue;

		count = i;

        SendClientMessageEx(userid, COLOR_HELPS, "%s da cho ban xem lien he %s.", GetNameWithMask(playerid), PlayerContacts[playerid][i][contactName]);
   		SendClientMessageEx(playerid, COLOR_HELPS, "Ban da cho %s mot lien he - %s.", GetNameWithMask(userid), PlayerContacts[playerid][i][contactName]);

		SendClientMessageEx(userid, COLOR_GRAD2, "1. %s - so dien thoai: %i", PlayerContacts[playerid][i][contactName], PlayerContacts[playerid][i][contactNumber]);

        new mes[128];
		format(mes, sizeof(mes), "%s cho thay lien he voi %s", GetNameWithMask(playerid), GetNameWithMask(userid));
		SetPlayerChatBubble(playerid, mes, COLOR_PURPLE, 15.0, 3000);
		break;
	}

	if (count == -1)
	    return SendWarningMessage(playerid, "Lien he nay khong duoc tim thay.");

	return 1;
}

CMD:loudspeaker(playerid, params[])
{
	if (PlayerInfo[playerid][pInjured] != 0 || GetPVarInt(playerid, "Freeze") || pTemp[playerid][pTaserTime] || pTemp[playerid][pCuffed] || PhoneInfo[playerid][current_page] == PAGE_NOTIFICATION || PlayerInfo[playerid][pJailed] != 0)
		return SendErrorMessage(playerid, "Ban khong the su dung tinh nang nay ngay bay gio.");

    if (PlayerInfo[playerid][pNumber] == 0)
		return SendErrorMessage(playerid, "Ban khong co dien thoai.");

	if (pTemp[playerid][pCallLine] == INVALID_PLAYER_ID || pTemp[playerid][pCallStatus] != 2)
	    return SendWarningMessage(playerid, "Ban khong nghe dien thoai.");

	if (GetPVarInt(playerid, #loud_speak) == 0)
	{
		SetPVarInt(playerid, #loud_speak, 1);
		SM2(playerid, "Ban da bat loa ngoai.");
	}
	else
	{
		SetPVarInt(playerid, #loud_speak, 0);
		SM2(playerid, "Ban da tat loa ngoai.");
	}
	return 1;
}

ALTX:phone("/ph");
CMD:phone(playerid, params[])
{
	if (PlayerInfo[playerid][pNumber] == 0)
		return SendErrorMessage(playerid, "Ban khong co dien thoai.");
		
	if (GetPVarInt(playerid, #pDelay))	return 1;
	if (IsPlayerUseMDC(playerid)) 		return SendErrorMessage(playerid, "Dong MDC!");

	if (IsPlayerPhoneCreated(playerid))
	{
		if (pTemp[playerid][pCallLine] != INVALID_PLAYER_ID || pTemp[playerid][pEmergency])
			cmd::hangup(playerid, "");
			
	    return Phone_Hide(playerid);
	}
	
	if (PlayerInfo[playerid][pInjured] != 0 || GetPVarInt(playerid, "Freeze") || pTemp[playerid][pTaserTime] || pTemp[playerid][pCuffed] || PhoneInfo[playerid][current_page] == PAGE_NOTIFICATION || PlayerInfo[playerid][pJailed] != 0)
		return SendErrorMessage(playerid, "Ban khong the su dung tinh nang nay ngay bay gio.");

	if (pTemp[playerid][pPayphone] != -1)
		return SendErrorMessage(playerid, "Ban dang su dung dien thoai tra tien.");
	
	if (IsPlayerAttachedObjectSlotUsed(playerid, ATTACH_HANDS) || IsPlayerHoldingWeapon(playerid))
        return SendWarningMessage(playerid, "Ban tay cua ban dang thuc hien.");

	if (GetPVarInt(playerid, #selfie))
	    cmd::selfie(playerid, "");

	PhoneInfo[playerid][current_page] = PAGE_NONE;
	PhoneInfo[playerid][phoneCreated] = 0;
	Phone_Show(playerid);

	SelectTextDraw(playerid, COLOR_LIGHTRED);
	return 1;
}

ALTX:phonecursor("/pc");
CMD:phonecursor(playerid, params[])
{
	if (IsPlayerPhoneCreated(playerid)) SelectTextDraw(playerid, COLOR_LIGHTRED);
	else SelectTextDraw(playerid, 255);
	return 1;
}

ALTX:sms("/text");
CMD:sms(playerid, params[])
{
    if (PlayerInfo[playerid][pInjured] != 0 || GetPVarInt(playerid, "Freeze") || pTemp[playerid][pTaserTime] || pTemp[playerid][pCuffed] || PhoneInfo[playerid][current_page] == PAGE_NOTIFICATION || PlayerInfo[playerid][pJailed] != 0)
		return SendErrorMessage(playerid, "Ban khong the su dung tinh nang nay ngay bay gio.");
	
	/*if (PlayerInfo[playerid][pJailed] != 0)
		return SCM(playerid, COLOR_WHITE, "������ ������������ ������� � ������.");*/

    if (PlayerInfo[playerid][pNumber] == 0)
		return SendErrorMessage(playerid, "Ban khong co dien thoai.");

    if (PlayerInfo[playerid][pPhoneOff] != 0)
        return SendCellMessage(playerid, "Dien thoai da tat nguon.");

    if (0 == GetPlayerNetwork(playerid))
	    return SendCellMessage(playerid, "Khong co ket noi.");

	if (PlayerInfo[playerid][pPhoneAirplane] == 1)
	    return SendCellMessage(playerid, "Khong the thuc hien cuoc goi va SMS - dien thoai cua ban dang o che do may bay.");

	new number_str[24],
		text[128];

	if (sscanf(params,"s[24]s[128]", number_str, text))
		return SendHelpMessage(playerid, "/sms [so dien thoai / lien he tu danh ba] [van ban]");

	SmsNumber(playerid, number_str, text);
	return 1;
}

CMD:selfie(playerid, params[])
{
	if (PlayerInfo[playerid][pInjured] != 0 || GetPVarInt(playerid, "Freeze") || pTemp[playerid][pTaserTime] || pTemp[playerid][pCuffed] || PhoneInfo[playerid][current_page] == PAGE_NOTIFICATION || PlayerInfo[playerid][pJailed] != 0)
		return SendErrorMessage(playerid, "Ban khong the su dung tinh nang nay ngay bay gio.");

	if (!IsPlayerPhoneCreated(playerid) && !GetPVarInt(playerid, #selfie) && IsPlayerAttachedObjectSlotUsed(playerid, ATTACH_HANDS))
        return SendWarningMessage(playerid, "Ban tay cua ban dang thuc hien.");

    if (!GetPVarInt(playerid, #selfie))
    {
		if (pTemp[playerid][pCallLine] != INVALID_PLAYER_ID || IsPlayerInAnyVehicle(playerid))
		    return SendErrorMessage(playerid, "Ban khong the su dung may anh vao luc nay.");

        new Float: x,
			Float: y,
			Float: z,
			Float: new_x,
			Float: new_y,
			Float: radius = 0.9,
			Float: rot;

        TogglePlayerControllable(playerid, 0);

	    GetPlayerPos(playerid, x, y, z);
	    GetPlayerFacingAngle(playerid, rot);
     	new_x = x + radius * floatcos(rot, degrees);
	    new_y = y + radius * floatsin(rot, degrees);

		RemovePlayerAttachedObject(playerid, ATTACH_HANDS);
	   	SetPlayerAttachedObject(playerid, ATTACH_HANDS, phone_model[PlayerInfo[playerid][pPhoneModel]], 6, 0.06, 0.01, 0.08, 180.0, 90.0, 0.0);

		SetPlayerCameraPos(playerid, new_x, new_y, z + 0.78);
		SetPlayerCameraLookAt(playerid, x, y, z + 0.60);
	    SetPlayerFacingAngle(playerid, rot -90.0);

		SetPVarFloat(playerid, #selfie_z, 0.60);

		ApplyAnimation(playerid, "PED", "gang_gunstand", 4.1, 1, 1, 1, 1, 1, 1);
  		SetPVarInt(playerid, #selfie, 1);

		SetPlayerArmedWeapon(playerid, 0);

        /*SendWarningMessage(playerid, "������� F8 ����� ������� ��������, F7 (������) ����� ������ ���.");
		SendWarningMessage(playerid, "����������� {FF6347}W, A, S � D{FFFFFF}, ����� ��������� �������, {FF6347}ENTER{FFFFFF} ����� ��������� �����.");
		SendSyntaxMessage(playerid, "����������� /headmove, ����� ������� ������ ���������.");*/
		
		InfoMSG(playerid, "Nhan ~y~F8~w~ de chup man hinh, ~y~F7~w~ de an khung chat.~n~Giu ~r~W, A, S~w~ va ~r~D~w~ de dieu khien may anh, ~y~ENTER~w~ de tro lai.~n~Su dung ~r~/headmove~w~ de xoay dau cua nhan vat.", 6);
		CancelSelectTextDraw(playerid);

		Phone_Hide(playerid, 1);
		return 1;
 	}

	TogglePlayerControllable(playerid, 1);
 	SetCameraBehindPlayer(playerid);

	RemovePlayerAttachedObject(playerid, ATTACH_HANDS);

	if (IsPlayerPhoneCreated(playerid))
 		SetPlayerAttachedObject(playerid, ATTACH_HANDS, phone_model[PlayerInfo[playerid][pPhoneModel]], 6, 0.111, -0.000999, 0.0, 77.9, -171.6, -3.40001, 1.0, 1.0, 1.0);

	ApplyAnimation(playerid, "PED", "ATM", 4.1, 0, 1, 1, 0, 1, 1);
 	DeletePVar(playerid, #selfie);
	
	new selfiepage = PAGE_HOME;
	if (PhoneInfo[playerid][current_page] != PAGE_NONE)
	{
		selfiepage = PhoneInfo[playerid][current_page];
		PhoneInfo[playerid][current_page] = PAGE_NONE;
	}

	Phone_Show(playerid, selfiepage);
	return 1;
}

ALTX:pickup("/p");
CMD:pickup(playerid, params[])
{
	if (PlayerInfo[playerid][pInjured] != 0 || GetPVarInt(playerid, "Freeze") || pTemp[playerid][pTaserTime] || pTemp[playerid][pCuffed] || PhoneInfo[playerid][current_page] == PAGE_NOTIFICATION || PlayerInfo[playerid][pJailed] != 0)
		return SendErrorMessage(playerid, "Ban khong the su dung tinh nang nay ngay bay gio.");

    if (PlayerInfo[playerid][pNumber] == 0)
		return SendErrorMessage(playerid, "Ban khong co dien thoai.");

    new targetid = pTemp[playerid][pCallLine];

    if (!IsPlayerPhoneCreated(playerid) && targetid == INVALID_PLAYER_ID && IsPlayerAttachedObjectSlotUsed(playerid, 9))
        return SendWarningMessage(playerid, "Ban tay cua ban dang thuc hien.");

    if (pTemp[playerid][pCallStatus] == 2)
        return SendCellMessage(playerid, "Ban dang noi roi.");

	if (targetid == INVALID_PLAYER_ID || pTemp[playerid][pCallStatus] != 1)
        return SendCellMessage(playerid, "Khong co ai goi cho ban..");

	if (pTemp[targetid][pCallLine] != playerid)
	    return SendErrorMessage(playerid, "404. [F8 > BUG TRACKER]");

	if (pTemp[playerid][pPayphone] != -1)
		return SendErrorMessage(playerid, "Ban dang su dung dien thoai tra tien.");
	//SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);

    pTemp[playerid][pCallIncoming] = 1;
    pTemp[targetid][pCallIncoming] = 0;

    pTemp[playerid][pCallStatus] = 2;
    pTemp[targetid][pCallStatus] = 2;

    pTemp[playerid][pCallTime] = 0;
    pTemp[targetid][pCallTime] = 0;

	if (pTemp[targetid][pPayphone] == -1)
	{
		if (!IsPlayerPhoneCreated(targetid)) Phone_Show(targetid, PAGE_CALL);
		else								ph_showpage(targetid, PAGE_CALL);
	}

    if (!IsPlayerPhoneCreated(playerid)) Phone_Show(playerid, PAGE_CALL);
	else								ph_showpage(playerid, PAGE_CALL);

	callstream[playerid] = SvCreateGStream(0xffff0000, "");
	callstream[targetid] = SvCreateGStream(0xffff0000, "");
	SvAttachListenerToStream(callstream[playerid], targetid);
	SvAttachListenerToStream(callstream[targetid], playerid);
	SM2(playerid,"Ban da tra loi cuoc goi.");
	SM2(targetid,"Nguoi dang ky da tra loi cuoc goi. ");

    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
	return 1;
}

ALTX:togphone("/togph");
CMD:togphone(playerid, params[])
{
	SendErrorMessage(playerid, "Su dung giao dien dien thoai de tat no. ");
	return 1;
}

ALTX:hangup("/hg");
CMD:hangup(playerid, params[])
{
	//if (PlayerInfo[playerid][pInjured] != 0 || GetPVarInt(playerid, "Freeze") || pTemp[playerid][pTaserTime] || pTemp[playerid][pCuffed] || PhoneInfo[playerid][current_page] == PAGE_NOTIFICATION || PlayerInfo[playerid][pJailed] != 0)
	//	return SendErrorMessage(playerid, "Ban khong the su dung tinh nang nay ngay bay gio.");
	
	if (PlayerInfo[playerid][pNumber] == 0 && pTemp[playerid][pPayphone] == -1) 		 return SendErrorMessage(playerid, "Ban khong co dien thoai.");
	if (pTemp[playerid][pCallLine] == INVALID_PLAYER_ID && !pTemp[playerid][pEmergency]) return 1;
	
	if (pTemp[playerid][pPayphone] == -1) {
		PlayerTextDrawHide(playerid, CallBox[playerid]);
		PlayerTextDrawHide(playerid, PhNote[1][playerid]);
		PhoneInfo[playerid][phoneCallBox] = 0;	
	}
	
	if (pTemp[playerid][pEmergency]) SendCellMessage(playerid, "Ban da cup may.");
	
	new targetid = pTemp[playerid][pCallLine];

	if (!pTemp[playerid][pEmergency] && pTemp[playerid][pCallStatus] == 2)
	{
	    SendCellMessage(playerid, "Ban da ket thuc cuoc tro chuyen voi nguoi dang ky %s.", pTemp[playerid][pCallName]);
	    SendCellMessage(targetid, "Co nhung tieng bip ngan.");
		HangupCall(targetid);
 	}

	else if (!pTemp[playerid][pEmergency] && pTemp[playerid][pCallStatus] == 1)
	{
	    SendCellMessage(targetid, "Ban da tu choi mot cuoc goi di.");
	    SendCellMessage(playerid, "Dien thoai da ngung do chuong.");
		HangupCall(targetid);

 	}

	HangupCall(playerid);
	return 1;
}

CMD:call(playerid, params[])
{		
    if (PlayerInfo[playerid][pNumber] == 0)
		return SendErrorMessage(playerid, "Ban khong co dien thoai.");

    if (PlayerInfo[playerid][pPhoneOff] != 0)
        return SendCellMessage(playerid, "Dien thoai da tat nguon.");

	if (0 == GetPlayerNetwork(playerid))
	    return SendCellMessage(playerid, "Khong co ket noi.");

	if (PlayerInfo[playerid][pPhoneAirplane] == 1)
	    return SendCellMessage(playerid, "Khong the thuc hien cuoc goi va SMS - dien thoai cua ban dang o che do may bay.");

    /*if (PlayerInfo[playerid][pJailed] != 0)
		return SCM(playerid, COLOR_WHITE, "������ ������������ ������� � ������.");*/
		
	if (PlayerInfo[playerid][pInjured] != 0 || GetPVarInt(playerid, "Freeze") || pTemp[playerid][pTaserTime] || pTemp[playerid][pCuffed] || PhoneInfo[playerid][current_page] == PAGE_NOTIFICATION || PlayerInfo[playerid][pJailed] != 0)
		return SendErrorMessage(playerid, "Ban khong the su dung tinh nang nay ngay bay gio.");

    if (pTemp[playerid][pCallLine] != INVALID_PLAYER_ID || pTemp[playerid][pEmergency])
	    return SendCellMessage(playerid, "Ban co mot cuoc goi chua hoan thanh. Nhap '/hangup' de treo may.");

    if (!IsPlayerPhoneCreated(playerid) && IsPlayerAttachedObjectSlotUsed(playerid, 9))
        return SendWarningMessage(playerid, "Ban tay cua ban dang thuc hien.");

	if (pTemp[playerid][pPayphone] != -1)
		return SendErrorMessage(playerid, "Ban dang su dung dien thoai tra tien.");

	new number_str[32];

	if (sscanf(params,"s[32]", number_str))
	{
		SendHelpMessage(playerid, "/call [number / contact / list (so dich vi)]");

		if (CompareStrings(number_str, "list"))
		{
			SM2(playerid, "Khan cap: 911");
			SM2(playerid, "Canh sat (doi voi moi cuoc goi chung): 991");
			SM2(playerid, "Taxi: 555");
			SM2(playerid, "Dich vu cuu ho: 444");
		}
		return 1;
	}

	SetPlayerChatBubble(playerid, "rut dien thoai ra khoi tui.", COLOR_PURPLE, 20.0, 4000);
	
	
	SetPlayerAttachedObject(playerid, ATTACH_HANDS, phone_model[PlayerInfo[playerid][pPhoneModel]], 6, 0.111, -0.000999, 0.0, 77.9, -171.6, -3.40001, 1.0, 1.0, 1.0);
	SetPlayerCellphoneAction(playerid, true);

	CallNumber(playerid, number_str);
	return 1;
}

CMD:dropcell(playerid, params[])
{
	if (PlayerInfo[playerid][pInjured] != 0 || GetPVarInt(playerid, "Freeze") || pTemp[playerid][pTaserTime] || pTemp[playerid][pCuffed] || PhoneInfo[playerid][current_page] == PAGE_NOTIFICATION || PlayerInfo[playerid][pJailed] != 0)
		return SendErrorMessage(playerid, "Ban khong the su dung tinh nang nay ngay bay gio.");

 	if (PlayerInfo[playerid][pNumber] == 0)
		return SendErrorMessage(playerid, "Ban khong co dien thoai.");

	if (pTemp[playerid][pCallLine] != INVALID_PLAYER_ID || pTemp[playerid][pEmergency] != 0)
	    return SendErrorMessage(playerid, "Ket thuc cuoc goi - /hangup.");

	if (IsPlayerPhoneCreated(playerid))
		Phone_Hide(playerid);

    new query[128];
   	mysql_format(dbHandle, query, sizeof(query), "DELETE FROM `sms` WHERE `to_number` = %i", PlayerInfo[playerid][pNumber]);
	mysql_tquery(dbHandle, query);

	mysql_format(dbHandle, query, sizeof(query), "DELETE FROM `player_contacts` WHERE `userid` = %i", PlayerInfo[playerid][pID]);
	mysql_tquery(dbHandle, query);

	for(new i; i != MAX_PLAYER_CONTACTS; i++)
	{
	    PlayerContacts[playerid][i][contactNumber] = 0;
		PlayerContacts[playerid][i][contactOn] = 0;
		PlayerContacts[playerid][i][contactID] = 0;
	}

	SendCellMessage(playerid, "Ban da vut bo dien thoai di dong cua minh");
	SendHelpMessage(playerid, "De ban co the su dung lai dien thoai cua minh - hay mua mot the SIM moi.");

	SendNearbyMessage(Range_Normal, playerid, COLOR_PURPLE, "* %s da nem dien thoai cua minh di.", GetNameWithMask(playerid));

	PlayerInfo[playerid][pNumber] = 0;
	PlayerInfo[playerid][pPhoneModel] = 0;
	return 1;
}