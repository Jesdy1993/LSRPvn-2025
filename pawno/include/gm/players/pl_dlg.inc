Dialog:SelectSpawn(playerid, response, listitem, inputtext[])
{
	if (!response) return 1;

    SendSyntaxMessage(playerid, "Bay gio ban se xuat hien o noi binh thuong.");
	PlayerInfo[playerid][pSpawnType] = 0;
	PlayerInfo[playerid][pSpawnPoint] = listitem+1;

	SQL_SetInteger("users", "spawntype", PlayerInfo[playerid][pSpawnType], PlayerInfo[playerid][pID]);
	SQL_SetInteger("users", "spawnpoint", PlayerInfo[playerid][pSpawnPoint], PlayerInfo[playerid][pID]);
	return 1;
}

Dialog:ChangeWalk(playerid, response, listitem, inputtext[])
{
	if (!response) return ShowSettings(playerid);
	    
	new str[5];
	format(str, sizeof(str), "1 %i", listitem);
	cmd::setstyle(playerid, str);
	ShowSettings(playerid);
	return 1;
}

Dialog:ChangeTalk(playerid, response, listitem, inputtext[])
{
	if (!response) return ShowSettings(playerid);

	new str[5];
	format(str, sizeof(str), "2 %i", listitem);
	cmd::setstyle(playerid, str);
	ShowSettings(playerid);
	return 1;
}

Dialog:ChangeFightstyle(playerid, response, listitem, inputtext[])
{
	if (!response) return ShowSettings(playerid);

	new str[5];
	format(str, sizeof(str), "3 %i", listitem+1);
	cmd::setstyle(playerid, str);
	ShowSettings(playerid);
	return 1;
}

Dialog:ChangeHud(playerid, response, listitem, inputtext[])
{
	if (!response) return ShowSettings(playerid);

	new str[5];
	format(str, sizeof(str), "4 %i", listitem+1);
	cmd::setstyle(playerid, str);
	ShowSettings(playerid);

	PlayerTextDrawDestroy(playerid, SpeedText[playerid]);
	Speedometr_TDcreate(playerid);
	return 1;
}

Dialog:ChangeSpawn(playerid, response, listitem, inputtext[])
{
	if (!response) return ShowSettings(playerid);

	new str[2];
	format(str, sizeof(str), "%i", listitem);
	cmd::setspawn(playerid, str);

	if (listitem > 1)
		ShowSettings(playerid);

	return 1;
}

Dialog:MainSettings(playerid, response, listitem, inputtext[])
{
	if (!response)					return cmd::mm(playerid, "");
	if (!IsPlayerLogged(playerid))	return 1;
	    
	switch(listitem)
	{
	    case 0: Dialog_Show(playerid, ChangeWalk, DIALOG_STYLE_LIST, "{FFFFFF}Walking style (/walk)", "Disable\n1\n2\n3\n4\n5\n6\n7\n8\n9\n10\n11\n12\n13\n14\n15\n16\n17", "Chon", "Quay lai");
		case 1: Dialog_Show(playerid, ChangeTalk, DIALOG_STYLE_LIST, "{FFFFFF}Conversation style", "Disable\n1\n2\n3\n4\n5\n6\n7\n8\n9", "Chon", "Quay lai");
		case 2: Dialog_Show(playerid, ChangeFightstyle, DIALOG_STYLE_LIST, "{FFFFFF}Combat style", "Usual\nBoxing\nKungfu\nKneehead\nGrabkick", "Chon", "Quay lai");
        case 3: Dialog_Show(playerid, ChangeHud, DIALOG_STYLE_LIST, "{FFFFFF}Speedometer style", "Font 1, from above\nFont 1, from below\nFont 2, from above\nFont 2, from below", "Chon", "Quay lai");
		case 4: Dialog_Show(playerid, ChangeSpawn, DIALOG_STYLE_LIST, "{FFFFFF}Spawn location", "Standard spawn\nHouse\nFaction\nLast exit", "Chon", "Quay lai");
		case 5: cmd::tog(playerid, "ooc");
		//case 6: cmd::tog(playerid, "name");
		case 6: cmd::tog(playerid, "ads");
		case 7: cmd::tog(playerid, "join");
		case 8: cmd::tog(playerid, "gov");
		case 9: cmd::tog(playerid, "pm");
		case 10: cmd::tog(playerid, "adm");
		case 11: cmd::tog(playerid, "news");
		case 12: cmd::tog(playerid, "afk");
		case 13: cmd::tog(playerid, "hud");
		case 14: cmd::tog(playerid, "f");
        case 15: cmd::tog(playerid, "enter");
		case 16:
		{
		    if (!CompareStrings(PlayerInfo[playerid][pGoogle], "!"))
		    {
		        format(PlayerInfo[playerid][pGoogle], 17, "!");

		        new query[128];
		
				mysql_format(dbHandle, query, sizeof(query), "UPDATE `accounts` SET `google_auth`='!' WHERE `id` = %i", PlayerInfo[playerid][pAccID]);
				mysql_tquery(dbHandle, query);
		        SendSyntaxMessage(playerid, "Xac minh 2 buoc cua Google Authenticator bi tat. ");
		    }
		    else
		    {
		        new __letters[32][] = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y","Z","2", "3", "4", "5", "6", "7"};

                pTemp[playerid][pGoogle] = EOS;

                for(new i; i < 17; i++)
				{
					strcat(pTemp[playerid][pGoogle], __letters[random(sizeof(__letters))], 17);
				}
					
				static const str_size[] = "{FFFFFF}Khoa bi mat cua ban: {FF6347}%s. {FFFFFF}Nhap no vao ung dung Google Authenticator va luu.\n{FF6347} Chu y! Khong chia se khoa bi mat voi bat ky ai trong bat ky truong hop nao.\n\n {ffffff} De xac nhan, hay nhap ma tu Google Authenticator vao hop ben duoi:";
				new mes[sizeof(str_size) - 2 + 1 + 17];

				format(mes, sizeof(mes), str_size, pTemp[playerid][pGoogle]);
				Dialog_Show(playerid, AcceptGoogle, DIALOG_STYLE_INPUT, "Xac nhan", mes, "Xac nhan", "Huy bo");
		    }
		}
		case 17: cmd::changepass(playerid, "");
	}
	
	if (listitem >= 5 && listitem <= 16)  ShowSettings(playerid);
	    
	return 1;
}

CMD:changepass(playerid, params[])
{
	Dialog_Show(playerid, ChangePass, DIALOG_STYLE_PASSWORD, "Nhap thong tin da phan loai", "Nhap mat khau hien tai de thay doi:", ">>>", "Huy bo");
	return 1;
}

ALTX:mm("/menu");
CMD:mm(playerid, params[])
{
	Dialog_Show(playerid, MainMenu, DIALOG_STYLE_LIST, "{FFFFFF}Menu", "1. Tui do\n\
	2. Thong ke nhan vat\n\
	3. Nop don khieu nai nguoi choi {ffc46a} (/report) {FFFFFF}\n\
	4. Dat mot cau hoi {ffc46a} (/helpme) {FFFFFF}\n\
	5. Tro giup voi cac lenh may chu\n\
	6. Cai dat\n\
	7. Ung ho (donate) ", "Chon", "Huy bo");
	return 1;
}

CMD:settings(playerid, params[])
{
	ShowSettings(playerid);
	return 1;
}

Dialog:MainMenu(playerid, response, listitem, inputtext[])
{
	if (!response) return 1;
	    
	switch(listitem)
	{
		case 0: cmd::inventory(playerid, "");
		case 1: cmd::stats(playerid, "");
		case 2: Dialog_Show(playerid, MakeReport, DIALOG_STYLE_INPUT, "{FFFFFF}Khieu nai"," {FFFFFF} Nhap ID nguoi choi va noi dung khieu nai vao o ben duoi: ","Nop", "Huy bo");
		case 3: Dialog_Show(playerid, MakeHelp, DIALOG_STYLE_INPUT, "{FFFFFF}Cau hoi "," {FFFFFF} Nhap noi dung cau hoi cua ban vao o ben duoi: "," Hoi ", "Huy bo");
		case 4: cmd::help(playerid, "");
		case 5: ShowSettings(playerid);
		case 6: cmd::donate(playerid, "");
		//case 7: return cmd::mm(playerid, "");
	}
	return 1;
}

Dialog:MakeReport(playerid, response, listitem, inputtext[])
{
	if (!response)			return cmd::mm(playerid, "");
    if (!strlen(inputtext))	return Dialog_Show(playerid, MakeReport, DIALOG_STYLE_INPUT, "{FFFFFF}Khieu nai", "{FFFFFF}Nhap ID nguoi choi va noi dung khieu nai cua ban vao o ben duoi:\n{C3C3C3}Hinh thuc: [ID Nguoi Choi] [Khieu nai]", "Nop", "Huy bo");
        
	cmd::report(playerid, inputtext);
	return 1;
}

Dialog:CmdServer2(playerid, response, listitem, inputtext[])
{
	if (response) cmd::help(playerid, "");
	    
	return 1;
}

Dialog:CmdServer(playerid, response, listitem, inputtext[])
{
	if (!response)
	    return 1;
	    
	switch(listitem)
	{
	    case 0: cmd::techhelp(playerid, "");
	    case 1: cmd::mainhelp(playerid, "");
	    case 2: cmd::chathelp(playerid, "");
	    case 3: cmd::factionhelp(playerid, "");
	    case 4: cmd::househelp(playerid, "");
	    case 5: cmd::bizhelp(playerid, "");
		case 6: cmd::vehiclehelp(playerid, "");
	    case 7: cmd::bankhelp(playerid, "");
	    case 8: cmd::cellhelp(playerid, "");
		case 9: cmd::weaponhelp(playerid, "");
		case 10: cmd::drughelp(playerid, "");
	    case 11: cmd::jobhelp(playerid, "");
		case 12: cmd::fishhelp(playerid, "");
		case 13: cmd::radiohelp(playerid, "");
		case 14: cmd::breakhelp(playerid, "");
	}
	return 1;
}

Dialog:MakeHelp(playerid, response, listitem, inputtext[])
{
	if (!response)			return cmd::mm(playerid, "");
	if (!strlen(inputtext))	return Dialog_Show(playerid, MakeHelp, DIALOG_STYLE_INPUT, "{FFFFFF}Cau hoi", "{FFFFFF}Nhap noi dung cau hoi cua ban vao o ben duoi:"," Hoi", "Huy bo");
	    
	cmd::helpme(playerid, inputtext);
	return 1;
}

Dialog:ChangePass(playerid, response, listitem, inputtext[])
{
	if (!response) 																return 1;
	if (isnull(inputtext) || strlen(inputtext) < 6 || strlen(inputtext) > 64)	return Dialog_Show(playerid, ChangePass, DIALOG_STYLE_PASSWORD, "{FFFFFF}Nhap thong tin da phan loai", "{FFFFFF}Nhap mat khau hien tai de thay doi:", ">>>", "Huy bo");

	new query[128 + 129], buf[129];

	WP_Hash(buf, sizeof (buf), inputtext);
	mysql_format(dbHandle, query, sizeof(query), "SELECT * FROM `accounts` WHERE `id`=%i AND `password`='%e'", PlayerInfo[playerid][pAccID], buf);
	mysql_tquery(dbHandle, query, "OnPlayerChangePass", "i", playerid);
	return 1;
}

Dialog:ChangePass2(playerid, response, listitem, inputtext[])
{
	if (!response) return 1;

    if (strlen(inputtext) < 6 || strlen(inputtext) > 32)
    {
        Dialog_Show(playerid, ChangePass2, DIALOG_STYLE_PASSWORD, "{FFFFFF}Mat khau moi "," {FFFFFF} Nhap Mat khau moi:", "Thay doi", "Huy bo");
		return SendErrorMessage(playerid, "Mat khau phai tu 6 den 32 ky tu. ");
	}

	for(new i = 0; i < strlen(inputtext); i++)
	{
		switch(inputtext[i])
		{
			case '!', '@', '#', '$','%','^','&','*','(',')','_','+','=','|','[',']','{','}','-','.','`','~','<','>','?',',','/':
			{
			    Dialog_Show(playerid, ChangePass2, DIALOG_STYLE_PASSWORD, "Mat khau moi", "Nhap Mat khau moi:", "Thay doi", "Huy bo");
				return SendErrorMessage(playerid, "Ban da su dung ky tu bi cam.");
			}
			default: continue;
		}
	}

	new query[128 + 129], buf[129];

	WP_Hash(buf, sizeof (buf), inputtext);
	mysql_format(dbHandle, query, sizeof(query), "UPDATE `accounts` SET `password`='%e' WHERE `id` = %i", buf, PlayerInfo[playerid][pAccID]);
	mysql_tquery(dbHandle, query);

	SendSyntaxMessage(playerid, "Ban da thay doi mat khau.");
	return 1;
}

Dialog:ConfirmWord(playerid, response, listitem, inputtext[])
{
	if (!response || isnull(inputtext))
	{
		Dialog_Show(playerid, ConfirmWord, DIALOG_STYLE_PASSWORD, "{c7c3c3}Google Authenticator", "{FFFFFF}Ban dang dang nhap tu mot dia chi IP chua duoc xac minh.\nNhap ma tu ung dung Google Authenticator de dam bao he thong la chu so huu cua tai khoan.", ">>>", "");
		return 1;
	}

    if (strval(inputtext) != GoogleAuthenticatorCode(PlayerInfo[playerid][pGoogle], gettime()))
    {
        if (pTemp[playerid][pLoggedTry]++ >= 2)
		{
		    SendErrorMessage(playerid, "Ban da nhap sai ma 3 lan. ");
			KickEx(playerid);
			return 1;
		}

		SendErrorMessage(playerid, "Ban da nhap sai ma.");
		Dialog_Show(playerid, ConfirmWord, DIALOG_STYLE_PASSWORD, "{c7c3c3}Google Authenticator", "{FFFFFF}Ban dang dang nhap tu mot dia chi IP chua duoc xac minh.\nNhap ma tu ung dung Google Authenticator de dam bao rang ban la chu so huu tai khoan.", ">>>", "");
        return 1;
    }
    static const str_size[] = "{c7c3c3}MAY CHU:\t{FFFFFF}Ban co 5 phut de tham gia\n\
							   {c7c3c3}GOI Y:\t\t{FFFFFF}Ban co the khoi phuc mat khau cua minh\n\
							   \t\ttai trang cru: {c7c3c3}"WeburlName"\n\
							   \t\t{FFFFFF}va vao quan ly tai khoan\n\n\
							   Nhap mat khau cua ban:"; //���� �����������
    new mes[sizeof(str_size)];

    format(mes, sizeof(mes), str_size);
	Dialog_Show(playerid, Login, DIALOG_STYLE_PASSWORD, "Chao mung den "ProjectName"", mes, "Dang nhap", "Huy bo");
	pTemp[playerid][pLoggedTime] = 0;
	pTemp[playerid][pLoggedTry] = 0;
	return 1;
}

Dialog:ChangeFight(playerid, response, listitem, inputtext[])
{
	if (!response) return 1;

	SendAdmMessage("%s thay doi %s Combat style on %s.", GetAccName(playerid), GetNameEx(GetPVarInt(playerid, "ChangeFightTo")), fight_name[listitem]);
	SendErrorMessage(GetPVarInt(playerid, "ChangeFightTo"), "Kieu Chien dau cua ban da duoc thay doi thanh %s boi quan tri vien %s.", fight_name[listitem], GetAccName(playerid));
	SetPlayerFightingStyle(GetPVarInt(playerid, "ChangeFightTo"), fight_id[listitem]);
	PlayerInfo[GetPVarInt(playerid, "ChangeFightTo")][pFightStyle] = fight_id[listitem];
	DeletePVar(playerid, "ChangeFightTo");
	return 1;
}

Dialog:AcceptGoogle(playerid, response, listitem, inputtext[])
{
    if (!IsPlayerLogged(playerid))	return 1;
	if (!response)					return ShowSettings(playerid);
	    
    if (strval(inputtext) != GoogleAuthenticatorCode(pTemp[playerid][pGoogle], gettime()))
    {
        SendErrorMessage(playerid, "Ma khong hop le, vui long thu lai.");
        return ShowSettings(playerid);
    }

    format(PlayerInfo[playerid][pGoogle], 17, pTemp[playerid][pGoogle]);

    new query[128];

	mysql_format(dbHandle, query, sizeof(query), "UPDATE `accounts` SET `google_auth`='%s' WHERE `id` = %i", PlayerInfo[playerid][pGoogle], PlayerInfo[playerid][pAccID]);
	mysql_tquery(dbHandle, query);
	SendSyntaxMessage(playerid, "Xac minh hai buoc voi Google Authenticator duoc ket noi thanh cong.");
	return 1;
}

Dialog:SendPM(playerid, response, listitem, inputtext[])
{
	if (!response) return 1;

	new userid = GetPVarInt(playerid, #pm_to), text[128];

	GetPVarString(playerid, #pm_text, text, 128);
	SendPMToPlayer(playerid, userid, text);
	return 1;
}

CMD:greet(playerid, params[])
{
	new userid, type;

	if (sscanf(params,"ud", userid, type))
	{
		SendHelpMessage(playerid, "/greet [ID/Ten] [loai]");
		SendSyntaxMessage(playerid, "[1] Hon [2-9] Bat tay");
		return 1;
	}

	if (!IsPlayerLogged(userid))						return SendNotConnected(playerid);
	if (userid == playerid)							return 1;
	if (type > 9 || type < 1)						return SendErrorMessage(playerid, "Loai chi tu 1 - 9.");
	if (!PlayerNearPlayer(2.0, playerid, userid))	return SendNotNearPlayer(playerid);

    pTemp[userid][pGreetPlayer] = playerid;
	pTemp[userid][pGreetType] = type;
    SetPVarInt(userid, #accept_time, gettime() + 30);

	SendSyntaxMessage(playerid, "Ban da gui mot yeu cau chao mung %s.", GetNameWithMask(userid));
	SendSyntaxMessage(userid, "%s muon chao (%s) ban.", GetNameWithMask(playerid), (type == 1)?("kiss"):("handshake"));

	InfoMSG(playerid, "~h~~g~Y~w~ - dong y\n~h~~r~N~w~ - tu choi", 3);
	return 1;
}

forward OnPlayerChangePass(playerid);
public OnPlayerChangePass(playerid)
{ 
	if (!cache_num_rows())	return Dialog_Show(playerid, ChangePass, DIALOG_STYLE_PASSWORD, "{FFFFFF}Nhap thong tin bi mat "," {FFFFFF} Nhap mat khau hien tai de thay doi:", ">>>", "Huy bo");

	Dialog_Show(playerid, ChangePass2, DIALOG_STYLE_PASSWORD, "Mat khau moi", "Nhap mat khau moi:", "Thay doi", "Huy bo");
	return 1;
}

Dialog:BuyClothes(playerid, response, listitem, inputtext[])
{
    new modelid = GetPVarInt(playerid, "clothes_model");

    if (modelid < 1 || modelid > 311) 	return 1;
	if (GetCash(playerid) < 100)			return SendErrorMessage(playerid, "Ban khong du tien. Ban can $ 100.");
	if (response)						PlayerInfo[playerid][pTog][listitem] = PlayerInfo[playerid][pSkin];
    SendSyntaxMessage(playerid, "Ban da mua quan ao voi gia $ 100. ");
    SetPlayerSkinEx(playerid, modelid);
	GiveCash(playerid, -100);
	return 1;
}

Dialog:EditClothes(playerid, response, listitem, inputtext[])
{
	if (!response) return 1;

    if (PlayerInfo[playerid][pTog][listitem] == 0)
    {
        PlayerInfo[playerid][pTog][listitem] = PlayerInfo[playerid][pSkin];
        cmd::offclothes(playerid, "1");
        PlayerInfo[playerid][pSkin] = 0;
        return 1;
    }
    new title[32];

    format(title, 32,"{FFFFFF}quan ao %i.", PlayerInfo[playerid][pTog][listitem]);
    Dialog_Show(playerid, EditClothes2, DIALOG_STYLE_LIST, title, "- Su dung\n- Vut di", "Chon", "Huy bo");
	SetPVarInt(playerid, "select_tog", listitem);
	return 1;
}

Dialog:EditClothes2(playerid, response, listitem, inputtext[])
{
	if (!response) return 1;

	new slot = GetPVarInt(playerid, "select_tog");

    if (PlayerInfo[playerid][pTog][slot] == 0) return 1;

	if (!listitem)
	{
	    new skin = PlayerInfo[playerid][pSkin];
    	SetPlayerSkinEx(playerid,PlayerInfo[playerid][pTog][slot]);
    	PlayerInfo[playerid][pTog][slot] = skin;
    	return 1;
	}
	
    PlayerInfo[playerid][pTog][slot] = 0;
    return 1;
}