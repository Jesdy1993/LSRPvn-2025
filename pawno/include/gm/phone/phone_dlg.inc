Dialog:SMSMenu(playerid, response, listitem, inputtext[])
{
	if (!response)
	{
		DeletePVar(playerid, #sms_number);
		DeletePVar(playerid, #select_sms);
	    return 1;
	}
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
		format(msg, sizeof(msg), "Tra loi\nGoi\nChuyen tiep\nLuu so\nThem vao luu tru\nXoa tin nhan\nXoa {ff0303}TAT CA TIN NHAN {FFFFFF}tu so");
	else
		format(msg, sizeof(msg), "Tra loi\nGoi\nChuyen tiep\nXem lien he\nThem vao luu tru\nXoa tin nhan\nXoa {ff0303}TAT CA TIN NHAN {FFFFFF}tu lien he");
		
	Dialog_Show(playerid, SMSMenu2, DIALOG_STYLE_LIST, "Tuy chon", msg, "Chon", "Huy bo");
	return 1;
}

Dialog:SMSMenu2(playerid, response, listitem, inputtext[])
{
	if (!response)
	    return 1;
	
	switch(listitem)
	{
		case 0: //�������
		{
			new mes[MAX_PHONE_STR+62];
			GetPVarString(playerid, #sms_number, mes, MAX_PHONE_STR);

			format(mes, sizeof(mes), "Tin nhan >>> {33AA33}%s{a9c4e4}\n\n\tNhap tin nhan cua ban:", mes);
			Dialog_Show(playerid, SendSMS2, DIALOG_STYLE_INPUT, "Gui tin", mes, "Gui", "Huy bo");
			
			DeletePVar(playerid, #select_sms);
			return 1;
		}
		case 1: //���������
		{
			new mes[MAX_PHONE_STR];
			GetPVarString(playerid, #sms_number, mes, MAX_PHONE_STR);

			format(mes, sizeof(mes), "%s", mes);
			cmd::call(playerid, mes);

			DeletePVar(playerid, #sms_number);
			DeletePVar(playerid, #select_sms);
			return 1;
		}
		case 2: //���������
		{
			Dialog_Show(playerid, ForwardSMS, DIALOG_STYLE_INPUT, "Chuyen tiep tin nhan", "Nhap so / ten lien he:","Gui", "Huy bo");
			return 1;
		}
		case 3: //��������� ����� || ���������� �������
		{
			new msg[MAX_PHONE_STR], count = 0;
			GetPVarString(playerid, #sms_number, msg, MAX_PHONE_STR);
			
			for(new i = 0; i < GetMaxPlayerContacts(playerid); i++)
			{
				if (strlen(PlayerContacts[playerid][i][contactName]) > 0)
				{
					if (CompareStrings(PlayerContacts[playerid][i][contactName], msg)) 
					{
						count = 1;
						break;
					}
				}
			}

			if (CompareStrings(msg, "One County Bank"))	return SendCellMessage(playerid,"Khong the luu so nay!");
			else if (CompareStrings(msg, "Sheriff's Departament")) return SendCellMessage(playerid, "Khong the luu so nay! ");
			//else if (CompareStrings(msg, "")) 

			if (!count)
			{
				SetPVarInt(playerid, #contact_number, strval(msg));
				
				new mes[128];
				format(mes, sizeof(mes), "Dien thoai: {33AA33}%i{a9c4e4}\n\n\tNhap ten lien he:", GetPVarInt(playerid, #contact_number));
				Dialog_Show(playerid, AddContact2, DIALOG_STYLE_INPUT, "Them lien he", mes, ">>>", "Huy bo");

				DeletePVar(playerid, #sms_number);
				DeletePVar(playerid, #select_sms);
			}
			else 
			{
				ph_showpage(playerid, PAGE_CONTACT_INFO);
				DeletePVar(playerid, #sms_number);
			}
			return 1;
		}
		case 4: ConfirmDialog(playerid, "Xac nhan", "Ban khong chac chan muon luu tru tin nhan nay khong?", "PhoneArchAdd");
		case 5: ConfirmDialog(playerid, "Xac nhan", "Ban co chac chan muon xoa tin nhan nay khong?", "DeleteSMS");
		case 6: ConfirmDialog(playerid, "Xac nhan", "{ffffff}Ban co chac chan muon xoa {ff0303}TAT CA TIN NHAN {ffffff} tu lien he / so dien thoai?", "DeleteAllSMS");
	}
	return 1;
}

Dialog:ForwardSMS(playerid, response, listitem, inputtext[])
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
			format(msg, sizeof(msg), "Tra loi\nGoi\nChuyen tiep\nLuu so\nThem vao luu tru\nXoa tin nhan\nXoa {ff0303}TAT CA TIN NHAN {FFFFFF}tu so");
		else
			format(msg, sizeof(msg), "Tra loi\nGoi\nChuyen tiep\nXem lien he\nThem vao luu tru\nXoa tin nhan\nXoa {ff0303}TAT CA TIN NHAN {FFFFFF}tu lien he");
			
		Dialog_Show(playerid, SMSMenu2, DIALOG_STYLE_LIST, "Tuy chon", msg, "Chon", "Huy bo");
		return 1;
	}

	if (strlen(inputtext) < 1 || strlen(inputtext) > 24)
 		return Dialog_Show(playerid, ForwardSMS, DIALOG_STYLE_INPUT, "Chuyen tiep tin nhan", "Nhap so / ten cua lien he:","Gui", "Huy bo");

	new number = strval(inputtext);
	if (!number)
	{
		for(new i = 0; i < GetMaxPlayerContacts(playerid); i++)
		{
			if (strlen(PlayerContacts[playerid][i][contactName]) > 0)
			{
				if (CompareStrings(PlayerContacts[playerid][i][contactName], inputtext)) 
				{
					number = PlayerContacts[playerid][i][contactNumber];
				}
			}
		}
	}
	
	new query[128], string[16];
	valstr(string, number);

	mysql_format(dbHandle, query, sizeof(query), "SELECT * FROM `sms` WHERE `id`=%i", GetPVarInt(playerid, #select_sms));
	mysql_tquery(dbHandle, query, "ForwardMessage", "is", playerid, string);

	DeletePVar(playerid, #sms_number);
	DeletePVar(playerid, #select_sms);

	return 1;
}

Dialog:SendSMS(playerid, response, listitem, inputtext[])
{
	if (!response)
	    return 1;

	if (strlen(inputtext) < 1 || strlen(inputtext) > 24)
 		return Dialog_Show(playerid, SendSMS, DIALOG_STYLE_INPUT, "Gui tin", "Tin nhan moi\n\n\tNhap so / ten cua lien he:", ">>>", "Huy bo");

    SetPVarString(playerid, #sms_number, inputtext);
    new mes[62+23];
	format(mes, sizeof(mes), "Tin nhan >>> {33AA33}%s{a9c4e4}\n\n\tNhap tin nhan cua ban:", inputtext);
	Dialog_Show(playerid, SendSMS2, DIALOG_STYLE_INPUT, "Gui tin", mes, "Gui", "Huy bo");
	return 1;
}

Dialog:SendSMS2(playerid, response, listitem, inputtext[])
{
	if (!response)
	    return 1;

	if (strlen(inputtext) < 1 || strlen(inputtext) > 127)
	{
	    new mes[32];
	    GetPVarString(playerid, #sms_number, mes, 32);
	    Dialog_Show(playerid, SendSMS2, DIALOG_STYLE_INPUT, mes, "Nhap tin nhan cua ban:", "Gui", "Huy bo");
	    return 1;
	}

	new mes[128 + 32],
	    name[32];

    GetPVarString(playerid, #sms_number, name, 32);

	format(mes, sizeof(mes), "%s %s", name, inputtext);
	cmd::sms(playerid, mes);
	return 1;
}

Dialog:SendSMS3(playerid, response, listitem, inputtext[])
{
	if (!response)
	    return 1;

	new contact = GetPVarInt(playerid, #select_contact);

	if (contact < 0 || contact >= MAX_PLAYER_CONTACTS || PlayerContacts[playerid][contact][contactOn] == 0)
	    return 1;

	if (strlen(inputtext) < 1 || strlen(inputtext) > 127)
	{
	    new mes[62+MAX_PHONE_STR];
	    format(mes, sizeof(mes), "Tin nhan >>> {33AA33}%s{a9c4e4}\n\n\tNhap tin nhan cua ban:", PlayerContacts[playerid][contact][contactName]);
	    Dialog_Show(playerid, SendSMS3, DIALOG_STYLE_INPUT, "Gui tin", mes, "Gui", "Huy bo");
	    return 1;
	}

	new mes[128 + 12];
	format(mes, sizeof(mes), "%i %s", PlayerContacts[playerid][contact][contactNumber], inputtext);
	cmd::sms(playerid, mes);
	return 1;
}

Dialog:DeleteContact(playerid, response, listitem, inputtext[])
{
	if (!response)
	    return 1;

	new contact = GetPVarInt(playerid, #select_contact);

	if (contact < 0 || contact >= MAX_PLAYER_CONTACTS || PlayerContacts[playerid][contact][contactOn] == 0)
	    return 1;

	new query[128];
	mysql_format(dbHandle, query, sizeof(query), "DELETE FROM `player_contacts` WHERE `id` = %i", PlayerContacts[playerid][contact][contactID]);
	mysql_tquery(dbHandle, query);

	mysql_format(dbHandle, query, sizeof(query), "UPDATE `sms` SET `from_name` = `from_number` WHERE `to_number` = %i AND `from_number`=%i", PlayerInfo[playerid][pNumber], PlayerContacts[playerid][contact][contactNumber]);
	mysql_tquery(dbHandle, query);

    mysql_format(dbHandle, query, sizeof(query), "UPDATE `history_calls` SET `from_name` = `from_number` WHERE `to_number` = %i AND `from_number`=%i", PlayerInfo[playerid][pNumber], PlayerContacts[playerid][contact][contactNumber]);
	mysql_tquery(dbHandle, query);

	SM2(playerid, "Lien he {33AA33}%s (%i){FFFFFF} da xoa thanh cong.", PlayerContacts[playerid][contact][contactName], PlayerContacts[playerid][contact][contactNumber]);
	
	PlayerContacts[playerid][contact][contactName] = EOS;
	PlayerContacts[playerid][contact][contactNumber] = 0;
	PlayerContacts[playerid][contact][contactOn] = 0;
	PlayerContacts[playerid][contact][contactID] = 0;

	PhoneInfo[playerid][current_page] = PAGE_MENU_CONTACTS;
	ph_showpage(playerid, PAGE_LIST_CONTACTS);

	DeletePVar(playerid, #select_contact);
	return 1;
}

Dialog:AddContact(playerid, response, listitem, inputtext[])
{
	if (!response)
	    return 1;

	new
		number = strval(inputtext);

	if (number < 1 || number > 99999999)
	    return SendErrorMessage(playerid, "Ky tu toi da 1-8.");

	for(new i = 0; i < GetMaxPlayerContacts(playerid); i++)
		{
			if (PlayerContacts[playerid][i][contactNumber] == number)
			{
				Dialog_Show(playerid, AddContact, DIALOG_STYLE_INPUT, "Them lien he", "Lien he moi\n\n\tNhap so dien thoai cua lien he:", ">>>", "Huy bo");
				return SendErrorMessage(playerid, "Mot lien he voi so nay da ton tai: {33AA33}%s{FFFFFF}!", PlayerContacts[playerid][i][contactName]);
			}
		}

	SetPVarInt(playerid, #contact_number, number);

	new mes[128];
	format(mes, sizeof(mes), "Dien thoai: {33AA33}%i{a9c4e4}\n\n\tNhap ten lien he:", number);
	Dialog_Show(playerid, AddContact2, DIALOG_STYLE_INPUT, "Them lien he", mes, ">>>", "Huy bo");
	return 1;
}

Dialog:AddContact2(playerid, response, listitem, inputtext[])
{
	if (!response)
	    return 1;

	if (strlen(inputtext) < 1 || strlen(inputtext) > 16 || isnull(inputtext))
	{
	    new mes[128];
		format(mes, sizeof(mes), "Dien thoai: {33AA33}%i{a9c4e4}\n\n\tNhap ten lien he:", GetPVarInt(playerid, #contact_number));
		Dialog_Show(playerid, AddContact2, DIALOG_STYLE_INPUT, "Them lien he", mes, ">>>", "Huy bo");
		return SendErrorMessage(playerid, "So ky tu toi da (1-16) trong ten lien he, dong thoi ten phai chua it nhat mot chu cai.");
	}

	new contact = -1,
	    count;
	    
	for(new i = 0; i < GetMaxPlayerContacts(playerid); i++)
    {
		if (strlen(PlayerContacts[playerid][i][contactName]) > 0)
		{
			if (CompareStrings(PlayerContacts[playerid][i][contactName], inputtext)) 
			{
				new mes[128];
				format(mes, sizeof(mes), "Dien thoai: {33AA33}%i{a9c4e4}\n\n\tNhap ten lien he:", GetPVarInt(playerid, #contact_number));
				Dialog_Show(playerid, AddContact2, DIALOG_STYLE_INPUT, "Them lien he", mes, ">>>", "Huy bo");
				return SendErrorMessage(playerid, "Dia chi lien he co cung ten da ton tai: {33AA33}%s (%d){FFFFFF}!", inputtext, PlayerContacts[playerid][i][contactNumber]);
			}
		}

		if (PlayerContacts[playerid][i][contactOn] == 0)
		{
			contact = i;
			break;
		}
		else count++;            
    }

	if (count == GetMaxPlayerContacts(playerid)-1 || contact == -1)
	    return SendErrorMessage(playerid, "Dien thoai da het bo nho. ");

	PlayerContacts[playerid][contact][contactNumber] = GetPVarInt(playerid, #contact_number);
	format(PlayerContacts[playerid][contact][contactName], 32, "%s", inputtext);
	PlayerContacts[playerid][contact][contactOn] = 1;

	new query[128];
	mysql_format(dbHandle, query, sizeof(query), "UPDATE `sms` SET `from_name` = '%e' WHERE `to_number` = %i AND `from_number`=%i", inputtext, PlayerInfo[playerid][pNumber], PlayerContacts[playerid][contact][contactNumber]);
	mysql_tquery(dbHandle, query);

	mysql_format(dbHandle, query, sizeof(query), "UPDATE `sms` SET `to_name` = '%e' WHERE `to_number` = %i AND `from_number`=%i", inputtext, PlayerInfo[playerid][pNumber], PlayerContacts[playerid][contact][contactNumber]);
	mysql_tquery(dbHandle, query);

    mysql_format(dbHandle, query, sizeof(query), "UPDATE `history_calls` SET `from_name` = '%e' WHERE `to_number` = %i AND `from_number`=%i", inputtext, PlayerInfo[playerid][pNumber], PlayerContacts[playerid][contact][contactNumber]);
	mysql_tquery(dbHandle, query);
	
	mysql_format(dbHandle, query, sizeof(query), "UPDATE `history_calls` SET `to_name` = '%e' WHERE `to_number` = %i AND `from_number`=%i", inputtext, PlayerInfo[playerid][pNumber], PlayerContacts[playerid][contact][contactNumber]);
	mysql_tquery(dbHandle, query);

	PlacePlayerContact(playerid, contact, inputtext, GetPVarInt(playerid, #contact_number));

	ph_showpage(playerid, PAGE_LIST_CONTACTS);
	return 1;
}

Dialog:DialogCall(playerid, response, listitem, inputtext[])
{
	if (!response)
	    return 1;

	cmd::call(playerid, inputtext);
	return 1;
}