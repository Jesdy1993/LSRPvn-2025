SmsNumber(playerid, number_str[], text[], forwarded = 0)
{
	new  
		number = strval(number_str)
	;
	if (strlen(number_str) == 0) return SendPhoneMessage(playerid, "Da goi sai so.");

	for(new i = 0; i < GetMaxPlayerContacts(playerid); i++)
	{
		if (strlen(PlayerContacts[playerid][i][contactName]) > 0)
		{
			if (CompareStrings(number_str, PlayerContacts[playerid][i][contactName]))
			{
				number = PlayerContacts[playerid][i][contactNumber];
				break;
			}
		}
	}
	if (PlayerInfo[playerid][pNumber] == number) return SendPhoneMessage(playerid, "Ban da cung cap so dien thoai cua minh.");

   	new targetid = GetNumberOwner(number);

	if (!number || number > 99999999) 
		return SendPhoneMessage(playerid, "Da goi sai so.");

	if (!IsPlayerLogged(targetid))
	{
	    new query[256];
	    mysql_format(dbHandle, query, sizeof(query), "\
	    SELECT number, (SELECT `contact` FROM `player_contacts` WHERE users.id = player_contacts.userid AND player_contacts.number = %i) as contact \
 		FROM `users` WHERE `number` = %i", PlayerInfo[playerid][pNumber], number);
 		mysql_tquery(dbHandle, query, "OfflineSMS", "iisi", playerid, number, text, forwarded);

		return 1;
	}

    new find_phone[2] = {0, 0},
		name_playerid[MAX_PLAYER_NAME],
		name_targetid[MAX_PLAYER_NAME];

    for (new i = 0; i != MAX_PLAYER_CONTACTS; i ++)
	{
		if (PlayerContacts[playerid][i][contactOn] != 0 && PlayerContacts[playerid][i][contactNumber] == number)
		{
 			strmid(name_targetid, PlayerContacts[playerid][i][contactName], 0, strlen(PlayerContacts[playerid][i][contactName]), 32);
 			find_phone[0] = 1;
		}
		if (PlayerContacts[targetid][i][contactOn] != 0 && PlayerContacts[targetid][i][contactNumber] == PlayerInfo[playerid][pNumber])
		{
 			strmid(name_playerid, PlayerContacts[targetid][i][contactName], 0, strlen(PlayerContacts[targetid][i][contactName]), 32);
	        find_phone[1] = 1;
		}
	}

	if (!find_phone[0]) format(name_playerid, 25, "%i", PlayerInfo[playerid][pNumber]);
	if (!find_phone[1]) format(name_targetid, 25, "%i", number);

	new 
		month,
 		day,
 		year,
 		hour,
 		minute
	;

	gettime(hour, minute);
	getdate(year, month, day);

	new query[256 + 128];
    mysql_format(dbHandle, query, sizeof(query), "INSERT INTO `sms` (`to_name`,`from_name`,`to_number`,`from_number`,`text`,`date`,`read`,`archieved`,`forward`) VALUES ('%e','%e',%i,%i,'%e','%s %02i %i, %02i:%02i',%i,0,%i)",
	name_targetid,
	name_playerid,
	PlayerInfo[playerid][pNumber],
	number,
	text,
	month_name[month-1],
	day,
	year,
	hour,
	minute,
    (GetPlayerNetwork(targetid) != 0 && PlayerInfo[targetid][pPhoneAirplane] == 0 && PlayerInfo[targetid][pPhoneOff] == 0)?(0):(-1),
	forwarded);
	mysql_tquery(dbHandle, query);

	if (GetPlayerNetwork(targetid) != 0 && PlayerInfo[targetid][pPhoneAirplane] == 0 && PlayerInfo[targetid][pPhoneOff] == 0)
	{
		if (PlayerInfo[targetid][pPhoneSound] == 0)
		{
		    cmd::my(targetid, "chuong dien thoai trong tui.");
			PlaySound(targetid, 1084);

			if (!IsPlayerAttachedObjectSlotUsed(targetid, ATTACH_HANDS) && !IsPlayerHoldingWeapon(targetid))
			{
				if (!IsPlayerPhoneCreated(targetid)) Phone_Show(targetid);
				NewMessage(targetid);
			}
		}	
	}

	if (!forwarded)
	{
		if (strlen(text) > MAXLEN)
		{
			new pos = MAXLEN;
			if (pos < MAXLEN-1) pos = MAXLEN;
			if (GetPlayerNetwork(targetid) != 0 && PlayerInfo[targetid][pPhoneAirplane] == 0 && PlayerInfo[targetid][pPhoneOff] == 0)
			{
				SendClientMessageEx(targetid, COLOR_YELLOWG, "SMS: %.*s ...", pos, text);
				SendClientMessageEx(targetid, COLOR_YELLOWG, "SMS: ... %s Nguoi gui: %s.", text[pos], name_playerid);
			}
			SendClientMessageEx(playerid, COLOR_YELLOWG, "SMS: %.*s ...", pos, text);
			SendClientMessageEx(playerid, COLOR_YELLOWG, "SMS: ... %s Nguoi gui: %s.", text[pos], name_targetid);
		}
		else
		{
			if (GetPlayerNetwork(targetid) != 0 && PlayerInfo[targetid][pPhoneAirplane] == 0 && PlayerInfo[targetid][pPhoneOff] == 0)
				SendClientMessageEx(targetid, COLOR_YELLOWG, "SMS: %s Nguoi gui: %s.", text, name_playerid);

			SendClientMessageEx(playerid, COLOR_YELLOWG, "SMS: %s Nguoi gui: %s.", text, name_targetid);
		}
	}
	else 
	{
		SendClientMessageEx(targetid, COLOR_YELLOWG, "SMS: %s da gui mot tin nhan cho ban. (Mo dien thoai de xem)", name_playerid);
		SendClientMessageEx(playerid, COLOR_YELLOWG, "SMS: Ban da chuyen tiep mot tin nhan: %s.", name_targetid);
	}
	
	
	if (!IsPlayerPhoneCreated(playerid)) Phone_Show(playerid, PAGE_HOME);
	SendPhoneMSG(playerid, "Da gui tin!", 0);

	NewMessage(playerid, 2);

	SetPlayerChatBubble(playerid, "dang go tin nhan tren dien thoai.", COLOR_PURPLE, 20.0, 4000);
	return 1;
}

CallNumber(playerid, number_str[], payphone = 0)
{
	new 
		number = strval(number_str)
	;
	
	SetPlayerChatBubble(playerid, "quay so dien thoai.", COLOR_PURPLE, 20.0, 4000);
	PlayerPlaySound(playerid, 16001, 0.0, 0.0, 0.0); //3600

	if (!payphone)
	{
		for(new i = 0; i < GetMaxPlayerContacts(playerid); i++)
		{
			if (CompareStrings(number_str, PlayerContacts[playerid][i][contactName]) && strlen(PlayerContacts[playerid][i][contactName]) > 0)
			{
				number = PlayerContacts[playerid][i][contactNumber];
				break;
			}
		}
	}
	else
	{
		if (IsNumberPayphone(number) != -1 && PayphoneInfo[pTemp[playerid][pPayphone]][phNumber] == number)
		{
			new hour, minute, second, str[64];
			gettime(hour, minute, second);

			format(str, sizeof(str), "%02d:%02d", hour, minute);
			PlayerTextDrawSetString(playerid, PP_Btn[playerid][0], str);
	
			return SendPhoneMessage(playerid, "Loi cuoc goi.");
		}
	}

	if (PlayerInfo[playerid][pNumber] == number) 
	{
		if (!payphone)
		{
			if (!IsPlayerPhoneCreated(playerid)) Phone_Show(playerid);
			SendPhoneMSG(playerid, "~r~Loi_cuoc_goi!", 4);
		}
		
		return SendPhoneMessage(playerid, "Ban dang goi so dien thoai cua ban.");
	}

	if (!number || number > 99999999) 
	{
		SendPhoneMessage(playerid, "Da goi sai so.");
		SetPlayerCellphoneAction(playerid, false);
		if (!payphone)
		{
			if (!IsPlayerPhoneCreated(playerid)) Phone_Show(playerid);
			SendPhoneMSG(playerid, "~r~Loi_cuoc_goi!", 4);
		}
		return SendPhoneMessage(playerid, "Loi cuoc goi. ");
	}

	new targetid = GetNumberOwner(number);

	if (targetid == INVALID_PLAYER_ID)
	{
		new pp;

		if ((pp = IsNumberPayphone(number)) != -1)
		{
			number = PayphoneInfo[pp][phNumber];
			PayphoneInfo[pp][phState] = PAYPHONE_STATE_RINGING;
			PayphoneInfo[pp][phCaller] = playerid;

			pTemp[playerid][pCallLine] = PayphoneInfo[pp][phID];
			pTemp[playerid][pCallStatus] = 0;
			pTemp[playerid][pCallTime] = 0;

			format(pTemp[playerid][pCallName], 25, "%s", number_str);

			Update_Payphone(pp);
			PayphoneInfo[pp][phRing] = 0;

			if (!payphone) Phone_Show(playerid, PAGE_OUTCOMING_CALL);
		} else {
			if (number == 544	||
				number == 555	||
				number == 911	||
				number == 1199	||
				number == 991)
			{
				format(pTemp[playerid][pCallName], 25, "%s", number_str);
				if (!payphone) Phone_Show(playerid, PAGE_OUTCOMING_CALL);
				
				SetPVarInt(playerid, #pDelay, 1);
				return SetTimerEx("OnPhoneResponse", 3000, false, "iii", playerid, number, payphone);
			}
			else 
			{
				if (!payphone)
				{
					if (!IsPlayerPhoneCreated(playerid)) Phone_Show(playerid);
					SendPhoneMSG(playerid, "~r~Call_error!", 4);
				}
				else
				{
					new hour, minute, second, str[64];
					gettime(hour, minute, second);
					format(str, sizeof(str), "%02d:%02d", hour, minute);

					PlayerTextDrawSetString(playerid, PP_Btn[playerid][0], str);
					pTemp[playerid][pPayphoneNumStr] = EOS;
				}
				SendPhoneMessage(playerid, "So dien thoai duoc chi dinh (%d) khong kha dung.", number);
			}
		}
	} else {
		if (pTemp[targetid][pCallLine] != INVALID_PLAYER_ID || pTemp[targetid][pEmergency])
		{
			SetPlayerCellphoneAction(playerid, false);
			SendPhoneMessage(playerid, "Nguoi dang ky da noi chuyen dien thoai. ");
			if (!payphone)
			{
				if (!IsPlayerPhoneCreated(playerid)) Phone_Show(playerid);
				SendPhoneMSG(playerid, "Ban!", 4);
			}
			return 1;
		}
		if (PlayerInfo[targetid][pPhoneOff] != 0 || PlayerInfo[targetid][pPhoneAirplane] != 0 || 0 == GetPlayerNetwork(targetid))
		{
			SetPlayerCellphoneAction(playerid, false);
			SendPhoneMessage(playerid, "Thue bao khong nam trong vung phu song cua nha mang.");
			if (!payphone)
			{
				if (!IsPlayerPhoneCreated(playerid)) Phone_Show(playerid);
				SendPhoneMSG(playerid, "~r~Loi_cuoc_goi!", 4);
			}
			return 1;
		}

		new find_phone[2] = {0, 0};

		if (!payphone)
		{
			for (new i = 0; i != MAX_PLAYER_CONTACTS; i ++)
			{
				if (PlayerContacts[playerid][i][contactOn] != 0 && PlayerContacts[playerid][i][contactNumber] == number)
				{
					strmid(pTemp[playerid][pCallName], PlayerContacts[playerid][i][contactName], 0, strlen(PlayerContacts[playerid][i][contactName]), 32);
					find_phone[0] = 1;
				}
				if (PlayerContacts[targetid][i][contactOn] != 0 && PlayerContacts[targetid][i][contactNumber] == PlayerInfo[playerid][pNumber])
				{
					strmid(pTemp[targetid][pCallName], PlayerContacts[targetid][i][contactName], 0, strlen(PlayerContacts[targetid][i][contactName]), 32);
					find_phone[1] = 1;
				}
			}
		}

		if (!find_phone[0] || payphone) format(pTemp[playerid][pCallName], 25, "%i", number);
		if (!find_phone[1]) format(pTemp[targetid][pCallName], 25, "%i", PlayerInfo[playerid][pNumber]);

		/// PLAYERID: OUTCAL: ///
		pTemp[playerid][pCallLine] = targetid;
		pTemp[playerid][pCallStatus] = 0;
		pTemp[playerid][pCallTime] = 0;
		if (!payphone) Phone_Show(playerid, PAGE_OUTCOMING_CALL);
	
		/// TAGRETID: INCALL ///
		if (PhoneInfo[targetid][current_page] == PAGE_NOTIFICATION) 
			for(new j = 0; j < sizeof(PhNote); j++) PlayerTextDrawHide(targetid, PhNote[j][targetid]);

		pTemp[targetid][pCallLine] = playerid;
		pTemp[targetid][pCallStatus] = 1;
		pTemp[targetid][pCallTime] = 0;
		Phone_Show(targetid, PAGE_INCOMING_CALL);

		if (PlayerInfo[targetid][pPhoneSound] == 0)
			PlayerPlaySoundEx(targetid, phone_ringtons[PlayerInfo[targetid][pPhoneRingtone]]);

		cmd::my(targetid, "chuong dien thoai trong tui");

		SendCellMessage(targetid, "Luu y: Lay hoac thao dien thoai /phone. De su dung con tro /pc.");
		SendCellMessage(targetid, "De tra loi cuoc goi, su dung /pickup.");
	}

	if (!payphone)
	{
		SendCellMessage(playerid, "Nhap '/pc' de tra lai con tro, hoac '/phone' cat dien thoai di.");
		//CancelSelectTextDraw(playerid);
	}
	return 1;
}

this::OnPhoneResponse(playerid, number, payphone)
{
	//if (pTemp[playerid][pPayphone] != -1)								return 1;
	//if (!IsPlayerAtPayphone(playerid, pTemp[playerid][pPayphone]))	return 1;
	SetPVarInt(playerid, #pDelay, 0);

	if (PlayerInfo[playerid][pPhoneOff] && !payphone)					return 1;
	if (pTemp[playerid][pCallStatus] || pTemp[playerid][pEmergency])	return 1;

	if (!IsPlayerPhoneCreated(playerid) && !payphone)
		Phone_Show(playerid, PAGE_CALL);
	
    switch (number)
    {
		case 444: 
		{
			SCM(playerid, COLOR_YELLOWG, "Dieu phoi vien (dien thoai): Xin chao, Dich vu Cuu ho Los Santos, chung toi co the giup gi cho ban?");
			pTemp[playerid][pEmergency] = number;
			pTemp[playerid][pCallStatus] = 2;
			pTemp[playerid][pCallTime] = 0;

			if (!payphone) 
			{
				format(pTemp[playerid][pCallName], 25, "%i", number);
				ph_showpage(playerid, PAGE_CALL);
			}
		}
		case 555: 
		{
			SCM(playerid, COLOR_YELLOWG, "Nhan vien dieu phoi (dien thoai): Xin chao, ban da goi dich vu taxi, don ban tu dau?");
			pTemp[playerid][pEmergency] = number;
			pTemp[playerid][pCallStatus] = 2;
			pTemp[playerid][pCallTime] = 0;

			if (!payphone) 
			{
				format(pTemp[playerid][pCallName], 25, "%i", number);
				ph_showpage(playerid, PAGE_CALL);
			}
		}
		case 911: 
		{
			SCM(playerid, COLOR_YELLOWG, "Tong dai 911 (dien thoai): Ban da goi 911. Ban can nhung dich vu nao? Chon ..");
			SCM(playerid, COLOR_YELLOWG, ".. 1 - Canh sat, 2 - Xe cuu thuong, Chua chay, 3 - Ca hai dich vu. (( Nhap vai khung tro chuyen ))");
			pTemp[playerid][pEmergency] = number;
			pTemp[playerid][pCallStatus] = 2;
			pTemp[playerid][pCallTime] = 0;

			if (!payphone) 
			{
				format(pTemp[playerid][pCallName], 25, "%i", number);
				ph_showpage(playerid, PAGE_CALL);
			}
		}	
		case 991: 
		{
			SCM(playerid, COLOR_YELLOWG, "Tong dai 911 (dien thoai): Ban da goi den duong day nong cua canh sat, toi co the giup gi cho ban?");
	    	pTemp[playerid][pEmergency] = number;
			pTemp[playerid][pCallStatus] = 2;
			pTemp[playerid][pCallTime] = 0;

			if (!payphone) 
			{
				format(pTemp[playerid][pCallName], 25, "%i", number);
				ph_showpage(playerid, PAGE_CALL);
			}
		}
		default:
		{
			if (!payphone) 
			{
				PhoneInfo[playerid][current_page] = PAGE_HOME;
		    	SendPhoneMSG(playerid, "~r~Call_error", 4);
			}
			
			HangupCall(playerid);
		}
	}
	return 1;
}	
	
HangupCall(playerid)
{
	SetPlayerCellphoneAction(playerid, false);

	if (pTemp[playerid][pPayphone] == -1)
	{
		if (IsPlayerPhoneCreated(playerid)) Phone_Hide(playerid);

		SetPVarInt(playerid, #loud_speak, 0);
		RemovePlayerAttachedObject(playerid, ATTACH_HANDS);

		if (!pTemp[playerid][pEmergency]) {
			SaveCall(playerid);
		}
	}
    if(callstream[playerid])
    {
        SvDeleteStream(callstream[playerid]);
        callstream[playerid] = SV_NULL;
    }

	new id = -1;
	for(new i = 0; i < MAX_PAYPHONES; i++)
	{
		if (PayphoneInfo[i][phCaller] == playerid)
		{
			id = i;
			break;
		}
	}
	if (id != -1)
	{
		PayphoneInfo[id][phState] = PAYPHONE_STATE_NONE;
		Update_Payphone(id);
	}
				
	pTemp[playerid][pCallLine] = INVALID_PLAYER_ID;
	pTemp[playerid][pCallStatus] = 0;
	pTemp[playerid][pCallIncoming] = 0;
	pTemp[playerid][pCallTime] = 0;
	format(pTemp[playerid][pCallName], 25, "");
	pTemp[playerid][pEmergency] = 0;

	if (pTemp[playerid][pPayphone] != -1) cancelPayphone(playerid);
	return 1;
}

//CancelCall
SaveCall(playerid)
{
	if (pTemp[playerid][pCallLine] == INVALID_PLAYER_ID) return 1;

	new targetid = pTemp[playerid][pCallLine],
		month,
		day,
		year,
		hour,
	 	minute,
		name_1[24],
		name_2[24];

	format(name_1, 25, "%s", pTemp[targetid][pCallName]);
	format(name_2, 25, "%s", pTemp[playerid][pCallName]);

	gettime(hour, minute);
	getdate(year, month, day);

	new query[256];
    mysql_format(dbHandle, query, sizeof(query), "INSERT INTO `history_calls` (`to_number`,`from_number`,`to_name`,`from_name`,`time`,`date_hour`,`date_month`) VALUES (%i,%i,'%s','%s',%i,'%02i:%02i','%s %02i, %i')",
	(pTemp[playerid][pCallIncoming] == 1) ? (PlayerInfo[playerid][pNumber]) : (PlayerInfo[targetid][pNumber]), 
	(pTemp[playerid][pCallIncoming] == 0) ? (PlayerInfo[playerid][pNumber]) : (PlayerInfo[targetid][pNumber]),
    (pTemp[playerid][pCallIncoming] == 1) ? (name_2) : (name_1), 
	(pTemp[playerid][pCallIncoming] == 0) ? (name_2) : (name_1), 
	pTemp[playerid][pCallTime], 
	hour, 
	minute, 
	month_name[month-1], 
	day, 
	year);
	mysql_tquery(dbHandle, query);

	return 1;
}

this::OnPlayerLoadContacts(playerid)
{
	if (!cache_num_rows())
	    return 1;

	for(new i = 0; i < cache_num_rows(); i++)
	{
	    PlayerContacts[playerid][i][contactID] = cache_get_field_content_int(i, "id");
	    cache_get_field_content(i, "contact", PlayerContacts[playerid][i][contactName], dbHandle, 32);
	    PlayerContacts[playerid][i][contactNumber] = cache_get_field_content_int(i, "number");

		PlayerContacts[playerid][i][contactOn] = 1;
	}
	return 1;
}

LoadPlayerContacts(playerid)
{
    new query[128];
	mysql_format(dbHandle, query, sizeof(query), "SELECT * FROM `player_contacts` WHERE `userid` = %i", PlayerInfo[playerid][pID]);
	mysql_tquery(dbHandle, query, "OnPlayerLoadContacts", "i", playerid);
	return 1;
}

PlacePlayerContact(playerid, contactid, contact[], number)
{
    new query[128 + 128];
	mysql_format(dbHandle,query, sizeof(query), "INSERT INTO `player_contacts` (userid, contact, number) VALUES (%i, '%e', %i)", PlayerInfo[playerid][pID], contact, number);
	mysql_tquery(dbHandle, query, "OnContactInsert", "ii", playerid, contactid);
	return 1;
}

this::ShowHistoryInfo(playerid)
{
    if (!cache_num_rows())
    	return 1;
	
	new
		mes[256],
		to_name[MAX_PLAYER_NAME],
		from_name[MAX_PLAYER_NAME],
		to_number,
		from_number,
		date_hour[24],
		date_month[24],
		time
	;

    to_number = cache_get_field_content_int(0, "to_number");
    cache_get_field_content(0, "to_name", to_name);

	from_number = cache_get_field_content_int(0, "from_number");
    cache_get_field_content(0, "from_name", from_name);
    
	cache_get_field_content(0, "date_hour", date_hour);
 	cache_get_field_content(0, "date_month", date_month);
	time = cache_get_field_content_int(0, "time");

	new callstatus[70],
		numberstatus[55];

	if (time == 0)
	{
		if (to_number == PlayerInfo[playerid][pNumber])
		{
			format(callstatus, sizeof(callstatus), "%s\t\t{c12a2a}Cuoc goi nho\t\t{FFFFFF}-", date_hour);
			format(numberstatus, sizeof(numberstatus), "%s", from_name);
			if (from_number != strval(numberstatus))
				format(numberstatus, sizeof(numberstatus), "%s (%i)", numberstatus, from_number);
		}
		else
		{
			format(callstatus, sizeof(callstatus), "%s\t\t{c12a2a}Cuoc goi bi huy\t\t{FFFFFF}-", date_hour);
			format(numberstatus, sizeof(numberstatus), "%s", to_name); 
			if (to_number != strval(numberstatus)) 
				format(numberstatus, sizeof(numberstatus), "%s (%i)", numberstatus, to_number);
		}
	}
	else 
	{
		if (to_number == PlayerInfo[playerid][pNumber])	
		{
			format(callstatus, sizeof(callstatus), "%s\t\t{a9c4e4}Den{FFFFFF}\t\t%s", date_hour, ConvertSecond(time));
			format(numberstatus, sizeof(numberstatus), "%s", from_name);
			if (from_number != strval(numberstatus))
				format(numberstatus, sizeof(numberstatus), "%s (%i)", numberstatus, from_number);
		}
		else
		{					
			format(callstatus, sizeof(callstatus), "%s\t\t{a9c4e4}Di{FFFFFF}\t\t%s", date_hour, ConvertSecond(time));
			format(numberstatus, sizeof(numberstatus), "%s", to_name); 
			if (to_number != strval(numberstatus)) 
				format(numberstatus, sizeof(numberstatus), "%s (%i)", numberstatus, to_number);
		}
	}										

	format(mes, sizeof(mes), "Dien thoai:{FFFFFF} %s\n\n%s\n{FFFFFF}%s", numberstatus, date_month, callstatus);
	Dialog_Show(playerid, None, DIALOG_STYLE_MSGBOX, "Thong tin cuoc goi", mes, "X", "");
	return 1;
}

this::ShowSMS(playerid)
{
	if (!cache_num_rows())
	{
	    cmd::phone(playerid, "");
	    return SendErrorMessage(playerid, "Khong tim thay tin nhan.");
	}

	new 
		from_name[24],
		to_name[24],
	    from_number,
		to_number,
	    date[30],
	    text[256],
	    mes[500]
	;

    from_number = cache_get_field_content_int(0, "from_number");
	cache_get_field_content(0, "from_name", from_name);
	to_number = cache_get_field_content_int(0, "to_number");
	cache_get_field_content(0, "to_name", to_name);
	cache_get_field_content(0, "date", date);
	cache_get_field_content(0, "text", text);

	if (from_number == PlayerInfo[playerid][pNumber])
	{
		if (to_number == strval(to_name))
		{
			format(mes, sizeof(mes), "{a9c4e4}Nguoi nhan:\t\t\t{ffffff}%s\n\
			{a9c4e4}Gui:\t\t\t{ffffff}%s\n\n", to_name, date);
		}
		else 
		{
			format(mes, sizeof(mes), "{a9c4e4}Nguoi nhan:\t\t\t{ffffff}%s (%i)\n\
			{a9c4e4}Gui:\t\t\t{ffffff}%s\n\n", to_name, to_number, date);
		}
	}
	else 
	{
		if (from_number == strval(from_name))
		{
			format(mes, sizeof(mes), "{a9c4e4}Nguoi gui:\t\t{ffffff}%s\n\
			{a9c4e4}Gui:\t\t\t{ffffff}%s\n\n", from_name, date);
		}
		else 
		{
			format(mes, sizeof(mes), "{a9c4e4}Nguoi gui:\t\t{ffffff}%s (%i)\n\
			{a9c4e4}Gui:\t\t\t{ffffff}%s\n\n", from_name, from_number, date); 
		}
	}

	if (cache_get_field_content_int(0, "forward"))	format(mes, sizeof(mes), "%s%s", mes, TextTabQ(TextTab(text)));
	else 											format(mes, sizeof(mes), "%s%s", mes, TextTab(text));

	SetPVarString(playerid, #sms_number, from_name);
	SetPVarInt(playerid, #select_sms, cache_get_field_content_int(0, "id"));

	new query[128];
	mysql_format(dbHandle, query, sizeof(query), "UPDATE `sms` SET `read`='1' WHERE `id`=%i", cache_get_field_content_int(0, "id"));
	mysql_tquery(dbHandle, query);

	Dialog_Show(playerid, SMSMenu, DIALOG_STYLE_MSGBOX, "Tin nhan", mes, "Menu", "Huy bo");
	
	if (0 == cache_get_field_content_int(0, "read"))
		ShowPhoneList(playerid, GetPVarInt(playerid, #phonelist));

	return 1;
}


this::OnContactInsert(playerid, contactid)
{
    PlayerContacts[playerid][contactid][contactID] = cache_insert_id();
	return 1;
}

Update_Phone(playerid)
{
    if (0 == IsPlayerPhoneCreated(playerid) || PlayerInfo[playerid][pPhoneOff] == 1)
		return 1;

	new 
		hours,
		minutes,
		str_time[16],
		month,
		day
	;

	gettime(hours, minutes);
	getdate(_, month, day);

	format(str_time, 6, "%02i:%02i", hours, minutes);
	PlayerTextDrawSetString(playerid, PhTime[playerid], str_time);
	PlayerTextDrawSetString(playerid, PhoneTDdisplay[0][playerid], str_time);

	format(str_time, 16, "%i %s", day, month_name[month-1]);
	PlayerTextDrawSetString(playerid,PhoneTDdisplay[1][playerid], str_time);

	new network[11];
	switch(GetPlayerNetwork(playerid))
	{
	    case 0: network = "~r~X";
	    case 1: network = "o~r~oooo";
	    case 2: network = "oo~r~ooo";
	    case 3: network = "ooo~r~oo";
	    case 4: network = "oooo~r~o";
	    case 5: network = "ooooo";
	}
	PlayerTextDrawSetString(playerid, PhNetwork[playerid], network);	
	
	new query[128];
	mysql_format(dbHandle, query, sizeof(query), "SELECT * FROM `sms` WHERE `to_number` = %i AND `read`=0", PlayerInfo[playerid][pNumber]);
	mysql_tquery(dbHandle, query, "ShowPhoneNewMessages", "i", playerid); 

	return 1;
}

Update_Menu(playerid, page, menulist = 4)
{
	new oldpage = PhoneInfo[playerid][current_page];

	if (oldpage == page) return 1;

	switch(page)
	{
		case PAGE_HOME:
		{
			if (oldpage != PAGE_NONE)
			{
				PlayerTextDrawHide(playerid, PhTime[playerid]);
				for(new i = 0; i < sizeof(PhoneMenuBg); i++) PlayerTextDrawHide(playerid, PhoneMenuBg[i][playerid]);
				for(new j = 0; j < sizeof(PhoneMenu); j++) PlayerTextDrawHide(playerid, PhoneMenu[j][playerid]);
			}	
			for(new d = 0; d < sizeof(PhoneTDdisplay); d++) PlayerTextDrawShow(playerid,  PhoneTDdisplay[d][playerid]);
		}

		case PAGE_MENU_DEFAULT:
		{
			if (oldpage == PAGE_HOME) 
			{
				for(new d = 0; d < sizeof(PhoneTDdisplay); d++) PlayerTextDrawHide(playerid, PhoneTDdisplay[d][playerid]);
				PlayerTextDrawHide(playerid, PhTime[playerid]);
			}
			PlayerTextDrawShow(playerid, PhoneMenu[0][playerid]);
			PlayerTextDrawShow(playerid, PhoneMenu[1][playerid]);
			PlayerTextDrawShow(playerid, PhoneMenu[2][playerid]);
			PlayerTextDrawShow(playerid, PhoneMenu[3][playerid]);
			//for(new j = 0; j < sizeof(PhoneMenu); j++) PlayerTextDrawShow(playerid, PhoneMenu[j][playerid]);
			for(new i = 0; i < sizeof(PhoneMenuBg); i++) PlayerTextDrawShow(playerid,  PhoneMenuBg[i][playerid]);	
		}

		case PAGE_CALL:
		{
			if (oldpage != PAGE_NONE) 
			{
				for(new i = 0; i < sizeof(PhoneMenuBg); i++) PlayerTextDrawHide(playerid, PhoneMenuBg[i][playerid]);
				for(new j = 0; j < sizeof(PhoneMenu); j++) PlayerTextDrawHide(playerid, PhoneMenu[j][playerid]);
			}
			PlayerTextDrawShow(playerid, PhNote[1][playerid]);
		}

		case PAGE_INCOMING_CALL:
		{
			if (oldpage != PAGE_NONE) 
			{
				for(new i = 0; i < sizeof(PhoneMenuBg); i++) PlayerTextDrawHide(playerid, PhoneMenuBg[i][playerid]);
				for(new j = 0; j < sizeof(PhoneMenu); j++) PlayerTextDrawHide(playerid, PhoneMenu[j][playerid]);
			}
			for(new d = 0; d < sizeof(PhoneTDdisplay); d++) PlayerTextDrawHide(playerid, PhoneTDdisplay[d][playerid]);
			
		}
		
		case PAGE_OUTCOMING_CALL:
		{
			if (oldpage != PAGE_NONE) 
			{
				for(new i = 0; i < sizeof(PhoneMenuBg); i++) PlayerTextDrawHide(playerid, PhoneMenuBg[i][playerid]);
				for(new j = 0; j < sizeof(PhoneMenu); j++) PlayerTextDrawHide(playerid, PhoneMenu[j][playerid]);
			}
			
			for(new d = 0; d < sizeof(PhoneTDdisplay); d++) PlayerTextDrawHide(playerid, PhoneTDdisplay[d][playerid]);
		}

		case PAGE_NOTIFICATION:
		{
			for(new i = 0; i < sizeof(PhBtnStr); i++) 		 	PlayerTextDrawHide(playerid, PhBtnStr[i][playerid]);
			for(new j = 0; j < sizeof(PhoneTDdisplay); j++) 	PlayerTextDrawHide(playerid, PhoneTDdisplay[j][playerid]);
			for(new k = 0; k < sizeof(PhoneMenuBg); k++) 	 	PlayerTextDrawHide(playerid, PhoneMenuBg[k][playerid]);
			for(new c = 0; c < sizeof(PhoneMenu); c++) 			PlayerTextDrawHide(playerid, PhoneMenu[c][playerid]);
			return 1;
		}

		default:
		{
			for (new j = 0; j < sizeof(PhoneMenuBg); j++)
			{
				PlayerTextDrawHide(playerid, PhoneMenuBg[j][playerid]);
				PlayerTextDrawColor(playerid,PhoneMenuBg[j][playerid], phone_panel[PlayerInfo[playerid][pPhoneStyle]]);
				PlayerTextDrawBackgroundColor(playerid,PhoneMenuBg[j][playerid], phone_panel[PlayerInfo[playerid][pPhoneStyle]]);
			}

			for (new i = 0; i < menulist; i++) 
			{
				PlayerTextDrawShow(playerid, PhoneMenu[i][playerid]);
				PlayerTextDrawShow(playerid,  PhoneMenuBg[i][playerid]);
				
				if (i == 3) break;
			}

			for (new j = menulist; j < 4; j++)
			{
				PlayerTextDrawHide(playerid, PhoneMenuBg[j][playerid]);
				PlayerTextDrawHide(playerid, PhoneMenu[j][playerid]);
			}
		}
	}

	switch(oldpage)
	{
		case PAGE_NOTIFICATION:
		{
			for(new i = 0; i < sizeof(PhBtnStr); i++)	PlayerTextDrawShow(playerid,  PhBtnStr[i][playerid]);
		}
		case PAGE_HOME:
		{
			for(new i = 0; i < sizeof(PhNewMSGDisplay); i++) PlayerTextDrawHide(playerid, PhNewMSGDisplay[i][playerid]);
			PlayerTextDrawShow(playerid, PhTime[playerid]);
		}
		case PAGE_CALL:
		{
			if (PhoneInfo[playerid][phoneCallBox] == 0)
			{
				PhoneInfo[playerid][phoneCallBox] = 1;
				PlayerTextDrawShow(playerid,  CallBox[playerid]);
				PlayerTextDrawHide(playerid, PhNote[1][playerid]);
			}
		}
		case PAGE_INCOMING_CALL:
		{
			/*for(new i = 0; i < sizeof(PhBtn); i++)
			{
				PlayerTextDrawColor(playerid,PhBtn[i][playerid], phone_btns_color[PlayerInfo[playerid][pPhoneModel]]);
				PlayerTextDrawBackgroundColor(playerid,PhBtn[i][playerid], phone_btns_color[PlayerInfo[playerid][pPhoneModel]]);
				if (IsPlayerPhoneCreated(playerid)) PlayerTextDrawShow(playerid,  PhBtn[i][playerid]);
			}*/
			return 1;
		}
	}
	return 1;
}

Phone_Hide(playerid, selfie = 0)
{
	if (PhoneInfo[playerid][phoneCreated] == 0)
	    return 1;

	if (pTemp[playerid][pCallLine] == INVALID_PLAYER_ID && !GetPVarInt(playerid, #selfie))
        RemovePlayerAttachedObject(playerid, ATTACH_HANDS);
		
	PhoneInfo[playerid][phoneCreated] = 0;
	PhoneInfo[playerid][phoneCallBox] = 0;
	if (selfie) PhoneInfo[playerid][current_page] = PAGE_NONE;

	SetPlayerCellphoneAction(playerid, false);

	for(new a = 0; a < sizeof(PhoneTDbox); a++) 		 PlayerTextDrawDestroy(playerid, PhoneTDbox[a][playerid]);
	for(new b = 0; b < sizeof(PhBtn); b++) 				 PlayerTextDrawDestroy(playerid, PhBtn[b][playerid]);
	for(new c = 0; c < sizeof(PhArrow); c++) 			 PlayerTextDrawDestroy(playerid, PhArrow[c][playerid]);
	for(new d = 0; d < sizeof(PhBtnStr); d++) 			 PlayerTextDrawDestroy(playerid, PhBtnStr[d][playerid]);
	for(new e = 0; e < sizeof(PhoneTDdisplay); e++)		 PlayerTextDrawDestroy(playerid, PhoneTDdisplay[e][playerid]);
	for(new f = 0; f < sizeof(PhoneMenuBg); f++) 		 PlayerTextDrawDestroy(playerid, PhoneMenuBg[f][playerid]);
	for(new i = 0; i < sizeof(PhoneMenu); i++) 			 PlayerTextDrawDestroy(playerid, PhoneMenu[i][playerid]);
	for(new n = 0; n < sizeof(PhoneTDdisplay); n++) 	 PlayerTextDrawDestroy(playerid, PhoneTDdisplay[n][playerid]);
	for(new g = 0; g < sizeof(PhNewMSGDisplay); g++) 	 PlayerTextDrawDestroy(playerid, PhNewMSGDisplay[g][playerid]);

	PlayerTextDrawDestroy(playerid, PhNetwork[playerid]);
	PlayerTextDrawDestroy(playerid, PhTime[playerid]);
	PlayerTextDrawDestroy(playerid, Ph_selfie[playerid]);
	PlayerTextDrawDestroy(playerid, PhDisplay[playerid]);
	PlayerTextDrawDestroy(playerid, PhOFF[playerid]);
	PlayerTextDrawDestroy(playerid, PhNewMSG[playerid]);
	PlayerTextDrawDestroy(playerid, PhNote[0][playerid]);
	PlayerTextDrawDestroy(playerid, PhNote[1][playerid]);
	PlayerTextDrawDestroy(playerid, CallBox[playerid]);
	
	for(new j = 0; j < sizeof(PhoneMenuBg); j++)
	{
		PlayerTextDrawColor(playerid,PhoneMenuBg[j][playerid], phone_panel[PlayerInfo[playerid][pPhoneStyle]]);
		PlayerTextDrawBackgroundColor(playerid,PhoneMenuBg[j][playerid], phone_panel[PlayerInfo[playerid][pPhoneStyle]]);
	}

	//DeletePVar(playerid, );
	//...

	CancelSelectTextDraw(playerid);

	return 1;
}

Phone_Show(playerid, page = PAGE_HOME)
{
	if (IsPlayerUseMDC(playerid))	return 1;

	if (!IsPlayerPhoneCreated(playerid))
	{
		LoadPhoneTextDraw(playerid);
		
		SetPlayerAttachedObject(playerid, ATTACH_HANDS, phone_model[PlayerInfo[playerid][pPhoneModel]], 6, 0.111, -0.000999, 0.0, 77.9, -171.6, -3.40001, 1.0, 1.0, 1.0);
		
		PhoneInfo[playerid][phoneCreated] = 1;
		PhoneInfo[playerid][current_page] = PAGE_NONE;
		
		cmd::server_ame(playerid, "lay dien thoai ra khoi tui cua anh ay.");

 		if (pTemp[playerid][pCallLine] == INVALID_PLAYER_ID) InfoMSG(playerid,"De go bo dien thoai - ~r~~h~/phone~w~.~n~De su dung ~y~con tro~w~ nhan ~y~'Y'~w~ hoac nhap ~y~'/pc'~w~.~n~Nhan phim ~r~~h~ESC~w~ de quay lai che do di bo.", 6);
		else InfoMSG(playerid,"De tra loi dien thoai - ~r~~h~/phone~w~.~n~De su dung ~y~con tro~w~ nhan ~y~'Y'~w~ hoac nhap ~y~'/pc'~w~.~n~Nhan phim ~r~~h~ESC~w~ de quay lai che do di bo.", 6);
		
		PhoneInfo[playerid][phoneCallBox] = 0;

		for(new i = 0; i < sizeof(PhoneTDbox); i++) PlayerTextDrawShow(playerid,  PhoneTDbox[i][playerid]);
		for(new j = 0; j < sizeof(PhBtn); j++)		PlayerTextDrawShow(playerid,  PhBtn[j][playerid]);
		for(new k = 0; k < sizeof(PhArrow); k++) 	PlayerTextDrawShow(playerid,  PhArrow[k][playerid]);
		for(new d = 0; d < sizeof(PhBtnStr); d++)	PlayerTextDrawShow(playerid,  PhBtnStr[d][playerid]);

		PlayerTextDrawShow(playerid, PhOFF[playerid]);
		PlayerTextDrawShow(playerid, PhNewMSG[playerid]);
		PlayerTextDrawShow(playerid, Ph_selfie[playerid]);

		for(new i = 1; i < 4; i++) PlayerTextDrawColor(playerid, PhoneTDbox[i][playerid], phone_model_color[PlayerInfo[playerid][pPhoneModel]]);
		
		if (PlayerInfo[playerid][pPhoneOff] == 0)
		{
			PlayerTextDrawShow(playerid, PhNetwork[playerid]);
			PlayerTextDrawShow(playerid,  PhDisplay[playerid]);
		} else {
			PlayerTextDrawBoxColor(playerid,PhDisplay[playerid], 255);
			PlayerTextDrawShow(playerid,  PhDisplay[playerid]);
			return 1;
		}
	}

	ph_showpage(playerid, page);
	return 1;
}

ph_showpage(playerid, page)
{	
	switch(page)
	{
		case PAGE_HOME:
		{
			Update_Menu(playerid, page);
			PhoneInfo[playerid][current_page] = page;

			PlayerTextDrawSetString(playerid, PhBtnStr[0][playerid], "Menu");
			PlayerTextDrawSetString(playerid, PhBtnStr[1][playerid], "_");
		}
		case PAGE_MENU_DEFAULT:
		{
			Update_Menu(playerid, page);
			PhoneInfo[playerid][current_page] = page;

			PlayerTextDrawSetString(playerid, PhoneMenu[0][playerid], "Contacts");
			PlayerTextDrawSetString(playerid, PhoneMenu[1][playerid], "Calls");
			PlayerTextDrawSetString(playerid, PhoneMenu[2][playerid], "Messages");
			PlayerTextDrawSetString(playerid, PhoneMenu[3][playerid], "Settings");

			PlayerTextDrawSetString(playerid, PhBtnStr[0][playerid], "_");
			PlayerTextDrawSetString(playerid, PhBtnStr[1][playerid], "Return");
		}
		case PAGE_MENU_CONTACTS:
		{
			Update_Menu(playerid, page, 2);
			PhoneInfo[playerid][current_page] = page;

			PlayerTextDrawSetString(playerid, PhoneMenu[0][playerid], "List");
			PlayerTextDrawSetString(playerid, PhoneMenu[1][playerid], "Add");
			PlayerTextDrawSetString(playerid, PhoneMenu[2][playerid], "_");
			PlayerTextDrawSetString(playerid, PhoneMenu[3][playerid], "_");

			PlayerTextDrawSetString(playerid, PhBtnStr[0][playerid], "_");
			PlayerTextDrawSetString(playerid, PhBtnStr[1][playerid], "Return");
		}
		case PAGE_MENU_CALLS:
		{
			Update_Menu(playerid, page, 3);
			PhoneInfo[playerid][current_page] = page;

			PlayerTextDrawSetString(playerid, PhoneMenu[0][playerid], "Call the contact");
			PlayerTextDrawSetString(playerid, PhoneMenu[1][playerid], "Call the number");
			PlayerTextDrawSetString(playerid, PhoneMenu[2][playerid], "Call history");
			PlayerTextDrawSetString(playerid, PhoneMenu[3][playerid], "_");

			PlayerTextDrawSetString(playerid, PhBtnStr[0][playerid], "_");
			PlayerTextDrawSetString(playerid, PhBtnStr[1][playerid], "Return");
		}
		case PAGE_MENU_SMS:
		{
			Update_Menu(playerid, page);
			PhoneInfo[playerid][current_page] = page;

			PlayerTextDrawSetString(playerid, PhoneMenu[0][playerid], "Message to contact ");
			PlayerTextDrawSetString(playerid, PhoneMenu[1][playerid], "Message to number ");
			PlayerTextDrawSetString(playerid, PhoneMenu[2][playerid], "Message history ");
			PlayerTextDrawSetString(playerid, PhoneMenu[3][playerid], "Archive");

			PlayerTextDrawSetString(playerid, PhBtnStr[0][playerid], "_");
			PlayerTextDrawSetString(playerid, PhBtnStr[1][playerid], "Return");
		}
		case PAGE_MENU_SETTINGS:
		{
			Update_Menu(playerid, page);
			PhoneInfo[playerid][current_page] = page;

			if (!PlayerInfo[playerid][pPhoneAirplane]) 
				PlayerTextDrawSetString(playerid, PhoneMenu[0][playerid], "Airplane mode:___~r~TAT");
			else 
				PlayerTextDrawSetString(playerid, PhoneMenu[0][playerid], "Airplane mode:____~g~BAT");

			if (!PlayerInfo[playerid][pPhoneSound]) 
				PlayerTextDrawSetString(playerid, PhoneMenu[1][playerid], "Sound:_______________~r~TAT");
			else 
				PlayerTextDrawSetString(playerid, PhoneMenu[1][playerid], "Sound:________________~g~BAT");

			PlayerTextDrawSetString(playerid, PhoneMenu[2][playerid], "Interface style");
			PlayerTextDrawSetString(playerid, PhoneMenu[3][playerid], "Ringtone");

			PlayerTextDrawSetString(playerid, PhBtnStr[0][playerid], "_");
			PlayerTextDrawSetString(playerid, PhBtnStr[1][playerid], "Return");
		}
		case PAGE_LIST_CONTACTS, PAGE_LIST_CONTACTS_FOR_CALL, PAGE_LIST_CONTACTS_FOR_SMS:
		{
			SetPVarInt(playerid, #phonelist, 0);
			new count = 0;

			for(new i = 0; i < GetMaxPlayerContacts(playerid); i++)
			{
				if (PlayerContacts[playerid][i][contactOn] == 1)
				{
					format(phListMenu[playerid][count][phoneListedStr], 30, "%s", PlayerContacts[playerid][count][contactName]);
					count++;
				}
			}
			
			if (!count) return SendPhoneMSG(playerid, "Empty!", 3);

			SetPVarInt(playerid, #maxphonelist, count);

			PlayerTextDrawSetString(playerid, PhBtnStr[0][playerid], "_");
			PlayerTextDrawSetString(playerid, PhBtnStr[1][playerid], "Return");

			Update_Menu(playerid, page, count);
			PhoneInfo[playerid][current_page] = page;
			ShowPhoneList(playerid);
		}
		case PAGE_CONTACT_INFO:
		{
			new mes[MAX_PHONE_STR];
			format(mes, sizeof(mes), "%s", PlayerContacts[playerid][GetPVarInt(playerid, #select_contact)][contactName]);

			PlayerTextDrawSetString(playerid, PhoneMenu[0][playerid], mes);
			PlayerTextDrawSetString(playerid, PhoneMenu[1][playerid], "Call");
			PlayerTextDrawSetString(playerid, PhoneMenu[2][playerid], "Message");
			PlayerTextDrawSetString(playerid, PhoneMenu[3][playerid], "Remove");

			//PlayerTextDrawBackgroundColor(playerid,PhoneMenuBg[0][playerid], #color#);

			PlayerTextDrawSetString(playerid, PhBtnStr[0][playerid], "_");
			PlayerTextDrawSetString(playerid, PhBtnStr[1][playerid], "Return");

			Update_Menu(playerid, page);
			PhoneInfo[playerid][current_page] = page;
		}
		case PAGE_LIST_CALLS:
		{
			SetPVarInt(playerid, #phonelist, 0);
			
			new query[128];
			mysql_format(dbHandle, query, sizeof(query), "SELECT * FROM `history_calls` WHERE `to_number` = %i OR `from_number` = %i ORDER BY `id` DESC LIMIT 40", PlayerInfo[playerid][pNumber], PlayerInfo[playerid][pNumber]);
			mysql_tquery(dbHandle, query, "GetPhoneCALLSList", "i", playerid);

			PlayerTextDrawSetString(playerid, PhBtnStr[0][playerid], "_");
			PlayerTextDrawSetString(playerid, PhBtnStr[1][playerid], "Return");
		}
		case PAGE_LIST_SMS:
		{
			SetPVarInt(playerid, #phonelist, 0);
			
			new query[128];
			mysql_format(dbHandle, query, sizeof(query), "SELECT * FROM `sms` WHERE (`to_number` = %i OR `from_number` = %i) AND `archieved` = 0 ORDER BY `id` DESC LIMIT 40", PlayerInfo[playerid][pNumber], PlayerInfo[playerid][pNumber]);
			mysql_tquery(dbHandle, query, "GetPhoneSMSList", "i", playerid);

			PlayerTextDrawSetString(playerid, PhBtnStr[0][playerid], "_");
			PlayerTextDrawSetString(playerid, PhBtnStr[1][playerid], "Return");
		}
		case PAGE_LIST_ARCH:
		{
			SetPVarInt(playerid, #phonelist, 0);
			
			new query[128];
			mysql_format(dbHandle, query, sizeof(query), "SELECT * FROM `sms` WHERE (`to_number` = %i OR `from_number` = %i) AND `archieved` = 1 ORDER BY `id` DESC LIMIT 40", PlayerInfo[playerid][pNumber], PlayerInfo[playerid][pNumber]);
			mysql_tquery(dbHandle, query, "GetPhoneArchList", "i", playerid);
		
			PlayerTextDrawSetString(playerid, PhBtnStr[0][playerid], "_");
			PlayerTextDrawSetString(playerid, PhBtnStr[1][playerid], "Return");
		}
		case PAGE_INCOMING_CALL:
		{
			Update_Menu(playerid, page);
			PhoneInfo[playerid][current_page] = page;
			new mes[64];
			
			format(mes, sizeof(mes), "%s~n~incoming call", pTemp[playerid][pCallName]);
			PlayerTextDrawSetString(playerid, PhNote[1][playerid], mes);
			PlayerTextDrawShow(playerid, PhNote[1][playerid]);

			PlayerTextDrawSetString(playerid, PhBtnStr[0][playerid], "~g~Answer");
			PlayerTextDrawSetString(playerid, PhBtnStr[1][playerid], "~r~Hang up");
		}
		case PAGE_OUTCOMING_CALL:
		{
			Update_Menu(playerid, page);
			PhoneInfo[playerid][current_page] = page;
			new mes[64];

			format(mes, sizeof(mes), "%s~n~call", pTemp[playerid][pCallName]);
			PlayerTextDrawSetString(playerid, PhNote[1][playerid], mes);
			PlayerTextDrawShow(playerid, PhNote[1][playerid]);

			PlayerTextDrawSetString(playerid, PhBtnStr[0][playerid], "_");
			PlayerTextDrawSetString(playerid, PhBtnStr[1][playerid], "Hang up");
		}
		case PAGE_CALL:
		{
			Update_Menu(playerid, page);
			PhoneInfo[playerid][current_page] = page;
			new mes[64];

			format(mes, sizeof(mes), "%s~n~%s", pTemp[playerid][pCallName], ConvertSecond(pTemp[playerid][pCallTime]));
			PlayerTextDrawSetString(playerid, PhNote[1][playerid], mes);

			PlayerTextDrawSetString(playerid, PhBtnStr[0][playerid], "Menu");
			PlayerTextDrawSetString(playerid, PhBtnStr[1][playerid], "Hang up");
		}
		case PAGE_NOTIFICATION:
		{
			Update_Menu(playerid, page);
			PhoneInfo[playerid][current_page] = page;

			PlayerTextDrawSetString(playerid, PhBtnStr[0][playerid], "_");
			PlayerTextDrawSetString(playerid, PhBtnStr[1][playerid], "_");
		}
		case PAGE_PHONE_STYLE:
		{
			Update_Menu(playerid, page);
			PhoneInfo[playerid][current_page] = page;

			new mes[32];
			format(mes, sizeof(mes), "~>~ Style -  %i", PlayerInfo[playerid][pPhoneStyle]);
			PlayerTextDrawSetString(playerid, PhoneMenu[PlayerInfo[playerid][pPhoneStyle]][playerid], mes);

			for(new i = 0; i < sizeof(PhoneMenu); i++)
			{
				if (i != PlayerInfo[playerid][pPhoneStyle])
				{
					format(mes, sizeof(mes), "Style -  %i", i);
					PlayerTextDrawSetString(playerid, PhoneMenu[i][playerid], mes);
				}
			}

			PlayerTextDrawSetString(playerid, PhBtnStr[0][playerid], "_");
			PlayerTextDrawSetString(playerid, PhBtnStr[1][playerid], "Return");
		}
		case PAGE_PHONE_MELODY:
		{
			Update_Menu(playerid, page);
			PhoneInfo[playerid][current_page] = page;

			new mes[32];
			format(mes, sizeof(mes), "~>~ Ringtone - %i", PlayerInfo[playerid][pPhoneRingtone]);
			PlayerTextDrawSetString(playerid, PhoneMenu[PlayerInfo[playerid][pPhoneRingtone]][playerid], mes);

			for(new i = 0; i < sizeof(PhoneMenu); i++)
			{
				if (i != PlayerInfo[playerid][pPhoneRingtone])
				{
					format(mes, sizeof(mes), "Ringtone - %i", i);
					PlayerTextDrawSetString(playerid, PhoneMenu[i][playerid], mes);
				}
			}

			PlayerTextDrawSetString(playerid, PhBtnStr[0][playerid], "_");
			PlayerTextDrawSetString(playerid, PhBtnStr[1][playerid], "Return");
		}
		case PAGE_NEW_MESSAGES:
		{
			SetPVarInt(playerid, #phonelist, 0);
			
			new query[150];
			mysql_format(dbHandle, query, sizeof(query), "SELECT * FROM `sms` WHERE (`to_number` = %i OR `from_number` = %i) AND `archieved` = 0 AND `read` = 0 ORDER BY `id` DESC LIMIT 40", PlayerInfo[playerid][pNumber], PlayerInfo[playerid][pNumber]);
			mysql_tquery(dbHandle, query, "GetPhoneNewSMSList", "i", playerid);

			PlayerTextDrawSetString(playerid, PhBtnStr[0][playerid], "_");
			PlayerTextDrawSetString(playerid, PhBtnStr[1][playerid], "Return");
		}
	}
	Update_Phone(playerid);
	return 1;	
}

this::GetPhoneArchList(playerid)
{
	if (cache_num_rows() == 0)
	{
		if (!IsPlayerPhoneCreated(playerid)) Phone_Show(playerid);
		return SendPhoneMSG(playerid, "Empty!", 3);
	}
	
	for(new i = 0; i < MAX_PLAYER_CONTACTS; i++) {
		phListMenu[playerid][i][phoneListed] = 0;
		phListMenu[playerid][i][phoneListedStr] = EOS;
	}

	new name[20];
	for(new i = 0; i < cache_num_rows(); i++)
	{
		if (PlayerInfo[playerid][pNumber] == cache_get_field_content_int(i, "from_number")) //�� ����
		{
			cache_get_field_content(i, "to_name", name); 
			format(phListMenu[playerid][i][phoneListedStr], 30, "~>~ %.26s", name);
		} else {
			cache_get_field_content(i, "from_name", name); 
			format(phListMenu[playerid][i][phoneListedStr], 30, "~<~ %.26s", name);
		}
		phListMenu[playerid][i][phoneListed] = cache_get_field_content_int(i, "id");
	}

	SetPVarInt(playerid, #maxphonelist, cache_num_rows());

	Update_Menu(playerid, PAGE_LIST_ARCH, cache_num_rows());
	PhoneInfo[playerid][current_page] = PAGE_LIST_ARCH;

	ShowPhoneList(playerid);
	return 1;
}

this::GetPhoneSMSList(playerid)
{
	if (cache_num_rows() == 0)
	{
		if (!IsPlayerPhoneCreated(playerid)) Phone_Show(playerid);
		return SendPhoneMSG(playerid, "Empty!", 3);
	}

	for(new i = 0; i < MAX_PLAYER_CONTACTS; i++) {
		phListMenu[playerid][i][phoneListed] = 0;
		phListMenu[playerid][i][phoneListedStr] = EOS;
	}

	new name[24];
	for(new i = 0; i < cache_num_rows(); i++)
	{
		if (PlayerInfo[playerid][pNumber] == cache_get_field_content_int(i, "from_number"))
		{
			cache_get_field_content(i, "to_name", name); 
			format(phListMenu[playerid][i][phoneListedStr], 30, "~>~ %.26s", name);
		} else {
			cache_get_field_content(i, "from_name", name); 
			format(phListMenu[playerid][i][phoneListedStr], 30, "~<~ %.26s", name);
		}
		phListMenu[playerid][i][phoneListed] = cache_get_field_content_int(i, "id");
	}

	SetPVarInt(playerid, #maxphonelist, cache_num_rows());

	Update_Menu(playerid, PAGE_LIST_SMS, cache_num_rows());
	PhoneInfo[playerid][current_page] = PAGE_LIST_SMS;

	ShowPhoneList(playerid);
	return 1;
}

this::GetPhoneNewSMSList(playerid)
{
	if (cache_num_rows() == 0)
	{
		if (!IsPlayerPhoneCreated(playerid)) Phone_Show(playerid);
		return SendPhoneMSG(playerid, "Empty!", 3);
	}

	for(new i = 0; i < MAX_PLAYER_CONTACTS; i++) {
		phListMenu[playerid][i][phoneListed] = 0;
		phListMenu[playerid][i][phoneListedStr] = EOS;
	}

	new name[24];
	for(new i = 0; i < cache_num_rows(); i++)
	{
		if (PlayerInfo[playerid][pNumber] == cache_get_field_content_int(i, "from_number"))
		{
			cache_get_field_content(i, "to_name", name); 
			format(phListMenu[playerid][i][phoneListedStr], 30, "~>~ %.26s", name);
		} else {
			cache_get_field_content(i, "from_name", name); 
			format(phListMenu[playerid][i][phoneListedStr], 30, "~<~ %.26s", name);
		}
		phListMenu[playerid][i][phoneListed] = cache_get_field_content_int(i, "id");
	}

	SetPVarInt(playerid, #maxphonelist, cache_num_rows());

	Update_Menu(playerid, PAGE_NEW_MESSAGES, cache_num_rows());
	PhoneInfo[playerid][current_page] = PAGE_NEW_MESSAGES;

	ShowPhoneList(playerid);
	return 1;
}

this::GetPhoneCALLSList(playerid)
{
	new name[24];

	if (cache_num_rows() == 0)
	{
		if (!IsPlayerPhoneCreated(playerid)) Phone_Show(playerid);
		return SendPhoneMSG(playerid, "Empty!", 3);
	}

	for(new i = 0; i < MAX_PLAYER_CONTACTS; i++) {
		phListMenu[playerid][i][phoneListed] = 0;
		phListMenu[playerid][i][phoneListedStr] = EOS;
	}

	for(new i = 0; i < cache_num_rows(); i++)
	{		
		if (0 == cache_get_field_content_int(i, "time"))
		{
			cache_get_field_content(i, "from_name", name); 
			format(phListMenu[playerid][i][phoneListedStr], 33, "~d~~r~ %.26s", name);
		} else {	
			if (PlayerInfo[playerid][pNumber] == cache_get_field_content_int(i, "from_number"))
			{
				cache_get_field_content(i, "to_name", name); 
				format(phListMenu[playerid][i][phoneListedStr], 30, "~>~ %.26s", name);
			} else {
				cache_get_field_content(i, "from_name", name); 
				format(phListMenu[playerid][i][phoneListedStr], 30, "~<~ %.26s", name);
			}
		}
		phListMenu[playerid][i][phoneListed] = cache_get_field_content_int(i, "id");
	}

	SetPVarInt(playerid, #maxphonelist, cache_num_rows());

	Update_Menu(playerid, PAGE_LIST_CALLS, cache_num_rows());
	PhoneInfo[playerid][current_page] = PAGE_LIST_CALLS;

	ShowPhoneList(playerid);
	return 1;
}

this::ShowPhoneListSMS(playerid, list, count)
{	
	for(new j = 0; j < sizeof(PhoneMenuBg); j++)
	{
		PlayerTextDrawHide(playerid, PhoneMenuBg[j][playerid]);
		PlayerTextDrawColor(playerid,PhoneMenuBg[j][playerid], phone_panel[PlayerInfo[playerid][pPhoneStyle]]);
		PlayerTextDrawBackgroundColor(playerid,PhoneMenuBg[j][playerid], phone_panel[PlayerInfo[playerid][pPhoneStyle]]);
	}

	count--;

	for(new i = 0; i <= count ; i++)
	{
		if (!cache_get_field_content_int(i, "read") && cache_get_field_content_int(i, "to_number") == PlayerInfo[playerid][pNumber])
		{
			new hexcolor[5] =
			{
				0xFFFF00FF, // black
				0xFFFF00FF, // blue
				0xFFFF00FF, // red
				COLOR_LIGHTGREEN, // yellow
				0xFFFF00FF // green (EDIT)
			};

			PlayerTextDrawColor(playerid,PhoneMenuBg[count-i][playerid], hexcolor[PlayerInfo[playerid][pPhoneStyle]]);
			PlayerTextDrawBackgroundColor(playerid,PhoneMenuBg[count-i][playerid], hexcolor[PlayerInfo[playerid][pPhoneStyle]]);
			PlayerTextDrawShow(playerid,  PhoneMenuBg[count-i][playerid]);

			PlayerTextDrawSetString(playerid, PhoneMenu[i][playerid], phListMenu[playerid][i+list][phoneListedStr]);
		}
		else
		{
			PlayerTextDrawShow(playerid,  PhoneMenuBg[count-i][playerid]);
			PlayerTextDrawSetString(playerid, PhoneMenu[i][playerid], phListMenu[playerid][i+list][phoneListedStr]);
		}
	}
}

ShowPhoneList(playerid, list = 0)
{
	if (PhoneInfo[playerid][current_page] != PAGE_LIST_SMS) 
		for(new i = 0; i < sizeof(PhoneMenu); i++)
			PlayerTextDrawSetString(playerid, PhoneMenu[i][playerid], phListMenu[playerid][list+i][phoneListedStr]);

	else {
		new query[128], mes[128], count = 0;

		format(mes, sizeof(mes), "SELECT * FROM `sms` WHERE");
		for(new i = 0; i < 4; i++)
		{
			if (strlen(phListMenu[playerid][list+i][phoneListedStr]) > 0)
			{
				if (count) format(mes, sizeof(mes), "%s OR", mes);
				format(mes, sizeof(mes), "%s `id` = %i", mes, phListMenu[playerid][list+i][phoneListed]);
				count++;
			}
		}
		if (!count) return 1;

		mysql_format(dbHandle, query, sizeof(query), "%s LIMIT %i", mes, count);
		mysql_tquery(dbHandle, query, "ShowPhoneListSMS", "iii", playerid, list, count);
	}
	return 1;
}

this::ShowPhoneNewMessages(playerid)
{
	if (cache_num_rows() == 0)
	{
		PlayerTextDrawColor(playerid,PhNewMSG[playerid], 0xFFFFFFFF);
		PlayerTextDrawBackgroundColor(playerid,PhNewMSG[playerid], 0xFFFFFFFF);
		PlayerTextDrawShow(playerid,  PhNewMSG[playerid]);

		for(new i = 0; i < sizeof(PhNewMSGDisplay); i++) PlayerTextDrawHide(playerid, PhNewMSGDisplay[i][playerid]);
		return 1;
	}

	if (PhoneInfo[playerid][current_page] == PAGE_HOME)
	{
		new mes[20];
		format(mes, sizeof(mes), "%i new messages", (cache_num_rows() >= 40)?(40):(cache_num_rows()));
		PlayerTextDrawSetString(playerid, PhNewMSGDisplay[1][playerid], mes);
		for(new i = 0; i < sizeof(PhNewMSGDisplay); i++) PlayerTextDrawShow(playerid,  PhNewMSGDisplay[i][playerid]);
	}
	PlayerTextDrawColor(playerid,PhNewMSG[playerid], COLOR_LIGHTGREEN);
	PlayerTextDrawBackgroundColor(playerid,PhNewMSG[playerid], COLOR_LIGHTGREEN);
	PlayerTextDrawShow(playerid,  PhNewMSG[playerid]);

	if (cache_num_rows() > 40)
	{
		new query[256];
		mysql_format(dbHandle, query, sizeof(query), "UPDATE `sms` SET `read`=1 WHERE `to_number` = %i AND `read`=0 AND `archieved`=0 LIMIT %i", PlayerInfo[playerid][pNumber], cache_num_rows()-40);
		mysql_tquery(dbHandle, query); 
	}

	return 1;
}

SetPlayerCellphoneAction(playerid, enable)
{
	if (PlayerInfo[playerid][pInjured] != 0 || GetPVarInt(playerid, "Freeze") || pTemp[playerid][pTaserTime] || pTemp[playerid][pCuffed])
		return 0;
	else
	{
		if (VehicleHasDoors(GetPlayerVehicleID(playerid)) && PlayerInfo[playerid][pTalk])
			return 0;

	    if (enable)
	    {
	        if (VehicleHasDoors(GetPlayerVehicleID(playerid)))
	        {
				ApplyAnimation(playerid, "CAR_CHAT", "carfone_in", 4.1, 0, 0, 0, 1, 0, 1);
			}
			else
			{
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
			}
		}
		else
		{
		    if (VehicleHasDoors(GetPlayerVehicleID(playerid)))
	        {
				ApplyAnimation(playerid, "CAR_CHAT", "carfone_out", 4.1, 0, 0, 0, 0, 0, 1);
			}
			else
			{
		    	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
			}
		}
	}
	return 1;
}

GetMaxPlayerContacts(playerid)
{
	switch(PlayerInfo[playerid][pPremium])
	{
	    case 0: return 20;
	    case 1: return 25;
	    case 2: return 35;
	    case 3: return 40;
	}
	return 100;
}

GetNumberOwner(number)
{
	if (number == 0)
		return INVALID_PLAYER_ID;

	foreach (new i : Player)
	{
		if (IsPlayerLogged(i) && PlayerInfo[i][pNumber] == number)
			return i;
	}
	return INVALID_PLAYER_ID;
}

GetPlayerNetwork(playerid)
{
    new
	    Float: fDistance[2] = {99999.0, 0.0},
	    iIndex = -1,
        Float:fX,
	    Float:fY,
		Float:fZ;

	if (GetInterior(playerid) || GetWorld(playerid))
	{
		fX = PlayerInfo[playerid][pLocationPos][0];
		fY = PlayerInfo[playerid][pLocationPos][1];
		fZ = PlayerInfo[playerid][pLocationPos][2];
	}
	else GetPlayerPos(playerid, fX, fY, fZ);

	for (new i = 0; i < MAX_TOWERS; i ++)
	{
	    if (TowerInfo[i][towerOn] == 0)
	        continue;

		fDistance[1] = GetDistanceBetweenPoints(fX, fY, fZ, TowerInfo[i][towerPosX], TowerInfo[i][towerPosY], TowerInfo[i][towerPosZ]);

		if (fDistance[1] < fDistance[0])
		{
		    fDistance[0] = fDistance[1];
		    iIndex = i;
		}
	}

	if (iIndex == -1)
		return 0;

 	switch(floatround(fDistance[0]))
	{
 		case 0..400: return 5;
   		case 401..600: return 4;
     	case 601..800: return 3;
      	case 801..1000: return 2;
		case 1001..1200: return 1;
		default: return 0;
  	}
	return 0;
}

Phone_Switch(playerid)
{
	if (!IsPlayerPhoneCreated(playerid))	return 1;
	
	SetPVarInt(playerid, #pDelay, 1);
	if (PlayerInfo[playerid][pPhoneOff])
	{
	    PlayerTextDrawBoxColor(playerid,PhDisplay[playerid], 255);
		PlayerTextDrawShow(playerid,  PhDisplay[playerid]);

		PlayerTextDrawSetString(playerid, PhNote[1][playerid], "~g~Phone~n~ON");
		PlayerTextDrawHide(playerid, PhNote[1][playerid]);

		PhoneInfo[playerid][current_page] = PAGE_NOTIFICATION;
	} else {
	    PlayerTextDrawBoxColor(playerid,PhDisplay[playerid], 255);
	    PlayerTextDrawShow(playerid,  PhDisplay[playerid]);

	    PlayerTextDrawSetString(playerid, PhNote[1][playerid], "~r~Phone~n~OFF");
		PlayerTextDrawShow(playerid, PhNote[1][playerid]);

		for(new e = 0; e < sizeof(PhoneTDdisplay); e++)		 PlayerTextDrawHide(playerid, PhoneTDdisplay[e][playerid]);
		for(new f = 0; f < sizeof(PhoneMenuBg); f++) 		 PlayerTextDrawHide(playerid, PhoneMenuBg[f][playerid]);
		for(new i = 0; i < sizeof(PhoneMenu); i++) 			PlayerTextDrawHide(playerid, PhoneMenu[i][playerid]);
		for(new j = 0; j < sizeof(PhoneTDdisplay); j++) 	 PlayerTextDrawHide(playerid, PhoneTDdisplay[j][playerid]);
		for(new g = 0; g < sizeof(PhNewMSGDisplay); g++) 	 PlayerTextDrawHide(playerid, PhNewMSGDisplay[g][playerid]);

		PlayerTextDrawHide(playerid, PhNetwork[playerid]);
		PlayerTextDrawHide(playerid, PhTime[playerid]);

		PhoneInfo[playerid][current_page] = PAGE_NOTIFICATION;
	}
	return SetTimerEx("OnPhoneToggle", 2500, false, "i", playerid);
}

this::OnPhoneToggle(playerid)
{
	SetPVarInt(playerid, #pDelay, 0);
	
	if (IsPlayerPhoneCreated(playerid))
	{
		if (PlayerInfo[playerid][pPhoneOff])
		{
			PhoneInfo[playerid][current_page] = PAGE_HOME;

		    PlayerTextDrawHide(playerid, PhDisplay[playerid]);
		    PlayerTextDrawBoxColor(playerid,PhDisplay[playerid], phone_window[PlayerInfo[playerid][pPhoneStyle]]);
		    PlayerTextDrawShow(playerid,  PhDisplay[playerid]);
		    PlayerTextDrawSetString(playerid, PhNote[1][playerid], "_");

			for(new e = 0; e < sizeof(PhoneTDdisplay); e++)	
				PlayerTextDrawShow(playerid,  PhoneTDdisplay[e][playerid]);

			PlayerTextDrawHide(playerid, PhNetwork[playerid]);
			PlayerTextDrawShow(playerid, PhTime[playerid]);

			Update_Phone(playerid);
			
			PlayerInfo[playerid][pPhoneOff] = 0;
		}
		else
		{
			PhoneInfo[playerid][current_page] = PAGE_NONE;

		    PlayerTextDrawHide(playerid, PhDisplay[playerid]);
		    PlayerTextDrawBoxColor(playerid,PhDisplay[playerid], 255);
		    PlayerTextDrawShow(playerid,  PhDisplay[playerid]);
		    PlayerTextDrawSetString(playerid, PhNote[1][playerid], "_");

			PlayerInfo[playerid][pPhoneOff] = 1;
		}
	}
	return 1;
}

Change_Sound(playerid)
{
	PlayerInfo[playerid][pPhoneSound] = (PlayerInfo[playerid][pPhoneSound])?(0):(1);
	PlayerTextDrawSetString(playerid, PhoneMenu[1][playerid], (PlayerInfo[playerid][pPhoneSound] == 0)?("Sound:_______________~r~OFF"):("Sound:________________~g~ON"));
	PlayerPlaySound(playerid, 21000, 0.0, 0.0, 0.0);
	return 1;
}

Change_Airplane(playerid)
{
	PlayerInfo[playerid][pPhoneAirplane] = (PlayerInfo[playerid][pPhoneAirplane])?(0):(1);

	if (PlayerInfo[playerid][pPhoneAirplane] == 1 && (pTemp[playerid][pEmergency] || pTemp[playerid][pCallLine] != INVALID_PLAYER_ID))
		cmd::hangup(playerid, "");

	if (PlayerInfo[playerid][pPhoneAirplane] == 0)
	{
		new query[128];
		mysql_format(dbHandle, query, sizeof(query), "UPDATE `sms` SET `read`='0' WHERE `to_number`=%i AND `read`='-1'", PlayerInfo[playerid][pNumber]);
		mysql_tquery(dbHandle, query);
	}

	PlayerTextDrawSetString(playerid, PhoneMenu[0][playerid], (PlayerInfo[playerid][pPhoneAirplane] == 0)?("Airplane mode:___~r~OFF"):("Airplane mode:____~g~ON"));
	PlayerPlaySound(playerid, 21000, 0.0, 0.0, 0.0);
	return 1;
}

Switch_Style(playerid, i)
{
	PlayerInfo[playerid][pPhoneStyle] = i;
	PlayerPlaySound(playerid, 21000, 0.0, 0.0, 0.0);

	PlayerTextDrawBoxColor(playerid,PhDisplay[playerid], phone_window[PlayerInfo[playerid][pPhoneStyle]]);
	PlayerTextDrawShow(playerid,  PhDisplay[playerid]);

	for(new j = 0; j < sizeof(PhoneMenuBg); j++)
	{
		PlayerTextDrawColor(playerid,PhoneMenuBg[j][playerid], phone_panel[PlayerInfo[playerid][pPhoneStyle]]);
		PlayerTextDrawBackgroundColor(playerid,PhoneMenuBg[j][playerid], phone_panel[PlayerInfo[playerid][pPhoneStyle]]);
		PlayerTextDrawShow(playerid,  PhoneMenuBg[j][playerid]);
	}

	ph_showpage(playerid, PAGE_PHONE_STYLE);
	return 1;
}

Switch_Melody(playerid, i)
{
	PlayerInfo[playerid][pPhoneRingtone] = i;

	PlayerPlaySound(playerid, 0, 0.0, 0.0, 0.0);
	PlayerPlaySound(playerid, phone_ringtons[PlayerInfo[playerid][pPhoneRingtone]], 0.0, 0.0, 0.0);
	
	ph_showpage(playerid, PAGE_PHONE_MELODY);
	return 1;
}

SendPhoneMSG(playerid, text[], type = 0)
{
	SetPVarInt(playerid, #pDelay, 1);

	new oldpage = PhoneInfo[playerid][current_page];
	ph_showpage(playerid, PAGE_NOTIFICATION);

	switch(type)
	{
		case 0:	PlayerTextDrawSetString(playerid, PhNote[0][playerid], "LD_CHAT:thumbup");
		case 1:	PlayerTextDrawSetString(playerid, PhNote[0][playerid], "LD_CHAT:thumbdn");
		case 2:	PlayerTextDrawSetString(playerid, PhNote[0][playerid], "LD_CHAT:goodcha");
		case 3:	PlayerTextDrawSetString(playerid, PhNote[0][playerid], "LD_CHAT:badchat");
		case 4:	PlayerTextDrawSetString(playerid, PhNote[0][playerid], "_");
	}

	PlayerTextDrawSetString(playerid, PhNote[1][playerid], text);

	for(new i = 0; i < sizeof(PhNote); i++) PlayerTextDrawShow(playerid, PhNote[i][playerid]);
	return SetTimerEx("OnPhoneMsg", 2500, false, "ii", playerid, oldpage);
}

this::OnPhoneMsg(playerid, oldpage)
{
	SetPVarInt(playerid, #pDelay, 0);

	for(new i = 0; i < sizeof(PhNote); i++) PlayerTextDrawHide(playerid, PhNote[i][playerid]);
	if (PhoneInfo[playerid][current_page] != PAGE_CALL ||
	   PhoneInfo[playerid][current_page] != PAGE_INCOMING_CALL ||
	   PhoneInfo[playerid][current_page] != PAGE_OUTCOMING_CALL) ph_showpage(playerid, oldpage);
	return 1;
}

this::OfflineSMS(playerid, number, text[], forwarded)
{
	if (!cache_num_rows())
	    return SendPhoneMessage(playerid,"Sorry, the specified number does not exist.");

    new find_phone,
		name_playerid[MAX_PLAYER_NAME],
		name_targetid[MAX_PLAYER_NAME];

    cache_get_field_content(0, "contact", name_playerid);

    for (new i = 0; i != MAX_PLAYER_CONTACTS; i ++)
	{
		if (PlayerContacts[playerid][i][contactOn] != 0 && PlayerContacts[playerid][i][contactNumber] == number)
		{
 			strmid(name_targetid, PlayerContacts[playerid][i][contactName], 0, strlen(PlayerContacts[playerid][i][contactName]), 32);
 			find_phone = 1;
		}
	}

	if (!find_phone) format(name_targetid, 25, "%i", number);
	if (!strlen(name_playerid) || CompareStrings(name_playerid, "NULL")) format(name_playerid, 25, "%i", PlayerInfo[playerid][pNumber]);

	new month,
 		day,
 		year,
 		hour,
 		minute;

	
	gettime(hour, minute);
	getdate(year, month, day);

	new query[256 + 256];
    mysql_format(dbHandle, query, sizeof(query), "INSERT INTO `sms` (`to_name`,`from_name`,`to_number`,`from_number`,`text`,`date`,`read`,`archieved`,`forward`) VALUES ('%e','%e',%i,%i,'%e','%s %02i %i, %02i:%02i',%i,%i,%i)",
	name_targetid,
	name_playerid,
	number,
	PlayerInfo[playerid][pNumber],
	text,
	month_name[month-1],
	day,
	year,
	hour,
	minute,
 	0,
	0,
	forwarded);
	mysql_tquery(dbHandle, query);

	if (!forwarded)
	{
		if (strlen(text) > MAXLEN)
		{
			new pos = MAXLEN;
			if (pos < MAXLEN-1) pos = MAXLEN;
			SendClientMessageEx(playerid, COLOR_YELLOWG, "SMS: %.*s ...", pos, text);
			SendClientMessageEx(playerid, COLOR_YELLOWG, "SMS: ... %s Nguoi gui: %s.", text[pos], name_targetid);
		}
		else
			SendClientMessageEx(playerid, COLOR_YELLOWG, "SMS: %s Nguoi gui: %s.", text, name_targetid);
	}
	else 
	{
		SendClientMessageEx(playerid, COLOR_YELLOWG, "SMS: Ban da nhan duoc tin nhan tu: %s.", name_targetid);
	}

	SetPlayerChatBubble(playerid, "dang go tin nhan tren dien thoai.", COLOR_PURPLE, 20.0, 4000);

	if (!IsPlayerPhoneCreated(playerid)) Phone_Show(playerid, PAGE_HOME);
	SendPhoneMSG(playerid, "Da gui tin nhan!", 0);

	NewMessage(playerid, 2);

	return 1;
}

SendSMStoPlayer(playerid, sendernumber_str[], sender_str[], text[], showsmstxt = 1)
{
    if (PlayerInfo[playerid][pNumber] == 0)
		return 1;


	new sendernumber = strval(sendernumber_str),
		month,
 		day,
 		year,
 		hour,
 		minute
	;

	
	gettime(hour, minute);
	getdate(year, month, day);

	new query[256 + 128];
	
	mysql_format(dbHandle, query, sizeof(query), "INSERT INTO `sms` (`to_name`,`from_name`,`to_number`,`from_number`,`text`,`date`,`read`) VALUES (%i,'%e',%i,%i,'%e','%s %02i %i, %02i:%02i',%i)",
	PlayerInfo[playerid][pNumber],
	sender_str,
	PlayerInfo[playerid][pNumber],
	sendernumber,
	text,
	month_name[month-1],
	day,
	year,
	hour,
	minute,
    (GetPlayerNetwork(playerid) != 0 && PlayerInfo[playerid][pPhoneAirplane] == 0 && PlayerInfo[playerid][pPhoneOff] == 0 && IsPlayerLogged(playerid))?(0):(-1));
	mysql_tquery(dbHandle, query);
	
	if (GetPlayerNetwork(playerid) != 0 && PlayerInfo[playerid][pPhoneAirplane] == 0 && PlayerInfo[playerid][pPhoneOff] == 0)
	{
		if (PlayerInfo[playerid][pPhoneSound] != 0)
		{
		    cmd::my(playerid, "chuong dien thoai trong tui");
			PlaySound(playerid, 1084);
			
			if (!IsPlayerAttachedObjectSlotUsed(playerid, ATTACH_HANDS) && !IsPlayerHoldingWeapon(playerid))
			{
				if (!IsPlayerPhoneCreated(playerid)) Phone_Show(playerid);
				NewMessage(playerid);
			}
		}
	}
	if (showsmstxt) 
	{
		if (strlen(text) > MAXLEN)
		{
			new pos = MAXLEN;
			if (pos < MAXLEN-1) pos = MAXLEN;
			if (GetPlayerNetwork(playerid) != 0 && PlayerInfo[playerid][pPhoneAirplane] == 0 && PlayerInfo[playerid][pPhoneOff] == 0)
			{
				SendClientMessageEx(playerid, COLOR_YELLOWG, "SMS: %.*s ...", pos, text);
				SendClientMessageEx(playerid, COLOR_YELLOWG, "SMS: ... %s Nguoi gui: %s.", text[pos], sender_str);
			}
		}
		else
		{
			if (GetPlayerNetwork(playerid) != 0 && PlayerInfo[playerid][pPhoneAirplane] == 0 && PlayerInfo[playerid][pPhoneOff] == 0)
				SendClientMessageEx(playerid, COLOR_YELLOWG, "SMS: %s Nguoi gui: %s.", text, sender_str);
		}
	}
	return 1;
}

this::SmsToPlayerOff(sendernumber_str[], sender_str[], text[])
{
	new sendernumber = strval(sendernumber_str),
		month,
 		day,
 		year,
 		hour,
 		minute
	;
	
	gettime(hour, minute);
	getdate(year, month, day);

	new query[256 + 128];

	mysql_format(dbHandle, query, sizeof(query), "INSERT INTO `sms` (`to_name`,`from_name`,`to_number`,`from_number`,`text`,`date`,`read`) VALUES (%i,'%e',%i,%i,'%e','%s %02i %i, %02i:%02i',%i)",
	cache_get_field_content_int(0, "number"),
	sender_str,
	cache_get_field_content_int(0, "number"),
	sendernumber,
	text,
	month_name[month-1],
	day,
	year,
	hour,
	minute,
	0);
	mysql_tquery(dbHandle, query);

	return 1;
}

NewMessage(playerid, emj = 0, show = 1)
{	
	if (show) 
	{
		switch(emj)
		{
			case 0:	PlayerTextDrawSetString(playerid, PhNote[0][playerid], "LD_CHAT:goodcha");
			case 1:	PlayerTextDrawSetString(playerid, PhNote[0][playerid], "LD_CHAT:thumbdn");
			case 2:	PlayerTextDrawSetString(playerid, PhNote[0][playerid], "LD_CHAT:thumbup");
			case 3:	PlayerTextDrawSetString(playerid, PhNote[0][playerid], "LD_CHAT:badchat");
		}
		PlayerTextDrawShow(playerid,  NewSMS[playerid]);

		SetPVarInt(playerid, #pDelay, 1);
		
		SetTimerEx("newmessagepublic", 2*1000, false, "ii", playerid);
	}
	else PlayerTextDrawHide(playerid, NewSMS[playerid]);

	return 1;
}

this::newmessagepublic(playerid)
{
	SetPVarInt(playerid, #pDelay, 0);
	NewMessage(playerid, 0, 0);
	return 1;
}

this::PhoneArchAdd(playerid, response)
{
	if (!response)
	{
		new mes[MAX_PHONE_STR],
			count = 0,
			msg[256];
			
		GetPVarString(playerid, #sms_number, mes, MAX_PHONE_STR);
		
		for(new i = 0; i < GetMaxPlayerContacts(playerid); i++)
		{
			if (strlen(PlayerContacts[playerid][i][contactName]) > 0)
			{
				if (CompareStrings(PlayerContacts[playerid][i][contactName], mes)) 
				{
					count = 1;
					break;
				}
			}
		}

		if (!count)
			format(msg, sizeof(msg), "Tra loi\nGoi\nChuyen tiep\nThem danh ba\nLuu tru\nXoa tin nhan\nXoa {ff0303}TAT CA TIN NHAN {FFFFFF}tu so dien thoai nay");
		else
			format(msg, sizeof(msg), "Tra loi\nGoi\nChuyen tiep\nThem danh ba\nLuu tru\nXoa tin nhan\nXoa {ff0303}TAT CA TIN NHAN {FFFFFF}tu so lien he nay");

		Dialog_Show(playerid, SMSMenu2, DIALOG_STYLE_LIST, "Options", msg, "Lua chon", "Huy");
		return 1;
	}
	
	new query[128];

	mysql_format(dbHandle, query, sizeof(query), "UPDATE `sms` SET `archieved` = 1 WHERE `id` = %i LIMIT 1", GetPVarInt(playerid, #select_sms));
	mysql_tquery(dbHandle, query);

	DeletePVar(playerid, #sms_number);
	DeletePVar(playerid, #select_sms);

	ph_showpage(playerid, PAGE_LIST_ARCH);
	return 1;
}

this::DeleteSMS(playerid, response)
{
    if (!response)
	{
		new mes[MAX_PHONE_STR],
			count = 0,
			msg[256];
			
		GetPVarString(playerid, #sms_number, mes, MAX_PHONE_STR);
		
		for(new i = 0; i < GetMaxPlayerContacts(playerid); i++)
		{
			if (strlen(PlayerContacts[playerid][i][contactName]) > 0)
			{
				if (CompareStrings(PlayerContacts[playerid][i][contactName], mes)) 
				{
					count = 1;
					break;
				}
			}
		}

		if (!count)
			format(msg, sizeof(msg), "Tra loi\nGoi\nChuyen tiep\nLuu danh ba\nLuu tru\nXoa tin nhan\nXoa {ff0303}TAT CA TIN NHAN {FFFFFF}tu so lien he nay");
		else
			format(msg, sizeof(msg), "Tra loi\nGoi\nChuyen tiep\nXem danh ba\nLuu tru\nXoa tin nhan\nXoa {ff0303}TAT CA TIN NHAN {FFFFFF}tu so lien he nay");

		Dialog_Show(playerid, SMSMenu2, DIALOG_STYLE_LIST, "Options", msg, "Lua chon", "Huy");
		return 1;
	}

    new query[128];
	mysql_format(dbHandle, query, sizeof(query), "DELETE FROM `sms` WHERE `id` = %i", GetPVarInt(playerid, #select_sms));
	mysql_tquery(dbHandle, query);

	new linkPage = PhoneInfo[playerid][current_page];
	PhoneInfo[playerid][current_page] = PAGE_MENU_SMS;
	ph_showpage(playerid, linkPage);

	DeletePVar(playerid, #sms_number);
	DeletePVar(playerid, #select_sms);
	return 1;
}

this::DeleteAllSMS(playerid, response)
{
    if (!response)
	{
		new mes[MAX_PHONE_STR],
			count = 0,
			msg[256];
			
		GetPVarString(playerid, #sms_number, mes, MAX_PHONE_STR);
		
		for(new i = 0; i < GetMaxPlayerContacts(playerid); i++)
		{
			if (strlen(PlayerContacts[playerid][i][contactName]) > 0)
			{
				if (CompareStrings(PlayerContacts[playerid][i][contactName], mes)) 
				{
					count = 1;
					break;
				}
			}
		}

		if (!count)
			format(msg, sizeof(msg), "Tra loi\nGoi\nChuyen tiep\nLuu danh ba\nLuu tru\nXoa tin nhan\nXoa {ff0303}TAT CA TIN NHAN {FFFFFF}tu so lien he nay");
		else
			format(msg, sizeof(msg), "Tra loi\nGoi\nChuyen tiep\nXem danh ba\nLuu tru\nXoa tin nhan\nXoa {ff0303}TAT CA TIN NHAN {FFFFFF}tu so lien he nay");

		Dialog_Show(playerid, SMSMenu2, DIALOG_STYLE_LIST, "Options", msg, "Lua chon", "Huy");
		return 1;
	}

    new query[128],
		sms_number[25];
			
	GetPVarString(playerid, #sms_number, sms_number, MAX_PHONE_STR);

	mysql_format(dbHandle, query, sizeof(query), "DELETE FROM `sms` WHERE `from_name`='%e' AND `archieved`=0", sms_number);
	mysql_tquery(dbHandle, query);

	new linkPage = PhoneInfo[playerid][current_page];
	PhoneInfo[playerid][current_page] = PAGE_MENU_SMS;
	ph_showpage(playerid, linkPage);

	DeletePVar(playerid, #sms_number);
	DeletePVar(playerid, #select_sms);
	return 1;
}


stock TextTab(text[], minlen = 32, maxlen = 40, cellphone = 1, n = 1)
{
    new string[256],
		temporystring[256]
	;
	
	format(temporystring, sizeof(temporystring), "%s", text);

	if (n) if (strfind(temporystring, "\n", true) != -1)	return temporystring;
	else 
	{
		new pos = strfind(temporystring, "\n", true);
		format(string, sizeof(string), "%.*s", string, pos+1, temporystring);
		strdel(temporystring, 0, pos+1);

	}
	for(new i = 0; i < floatround(strlen(text)/maxlen, floatround_floor); i++) 
	{
		new pos = maxlen;
		while(temporystring[--pos] != ' ') {}
		
		if (pos < minlen) 
		{
			pos = maxlen;
			if (temporystring[pos] == ' ') 
			{
				format(string, sizeof(string), "%s%.*s", string, pos, temporystring);
				format(temporystring, 256, "%s",temporystring[pos+1]);
			} else {
				format(string, sizeof(string), "%s%.*s-", string, pos, temporystring);
				format(temporystring, 256, "%s",temporystring[pos]);
			}
		}
		else 
		{
			format(string, sizeof(string), "%s%.*s", string, pos, temporystring);
			format(temporystring, 256, "%s",temporystring[pos+1]);			
		}
		
		if (i+1 <= floatround(strlen(text)/maxlen, floatround_floor))
		{
			if (cellphone)	format(string, sizeof(string), "%s\n", string);
			else			format(string, sizeof(string), "%s~n~", string);
		}
	}
	
	format(string, sizeof(string), "%s%s", string, temporystring);
	return string;
}

stock TextTabQ(text[])
{
    new string[400],
		temporystring[400],
		pos,
		i = 0
	;
	
	format(temporystring, sizeof(temporystring), "%s", text);

	while((pos = strfind(temporystring, "\n")) != -1)
	{
		if (!i)
		{
			format(string, sizeof(string), "{AFAFAF}| %.*s", pos+1, temporystring);
			strdel(temporystring, 0, pos+1);
		}
		else 
		{
			format(string, sizeof(string), "%s{AFAFAF}|{FFFFFF} %.*s", string, pos+1, temporystring);
			strdel(temporystring, 0, pos+1);
		}
		i++;
	}

	format(string, sizeof(string), "%s{AFAFAF}|{FFFFFF} %s", string, temporystring);
	return string;
}

this::ForwardMessage(playerid, number_str[])
{
	new 
		from_name[24],
		to_name[24],
	    from_number,
		to_number,
	    date[24],
	    text[256],
	    mes[512]
	;
	
	from_number = cache_get_field_content_int(0, "from_number");
	cache_get_field_content(0, "from_name", from_name);
	to_number = cache_get_field_content_int(0, "to_number");
	cache_get_field_content(0, "to_name", to_name);
	cache_get_field_content(0, "date", date);
	cache_get_field_content(0, "text", text);
	
	if (cache_get_field_content_int(0, "forward") == 0)
	{
		if (from_number == PlayerInfo[playerid][pNumber])
		{
			if (to_number == strval(to_name)) 
				format(mes, sizeof(mes), "%s\t(%s)\n%s", to_name, date, text);
			else 
				format(mes, sizeof(mes), "%s (%i)\t(%s)\n%s", to_name, to_number, date, text);
		}
		else 
		{
			if (from_number == strval(from_name))
				format(mes, sizeof(mes), "%s\t(%s)\n%s", from_name, date, text);
			else 
				format(mes, sizeof(mes), "%s (%i)\t(%s)\n%s", from_name, from_number, date, text);
		}
	}
	else format(mes, sizeof(mes), "%s", text);

	SmsNumber(playerid, number_str, mes, 1);
	return 1;
}

stock PlaySoundForPlayersInRange(soundid, Float:range, Float:x, Float:y, Float:z)
{
    for(new i=0; i<MAX_PLAYERS; i++)
    {
        if (IsPlayerConnected(i) && IsPlayerInRangeOfPoint(i,range,x,y,z))
        {
            PlayerPlaySound(i, soundid, x, y, z);
        }
    }
	return 1;
}
