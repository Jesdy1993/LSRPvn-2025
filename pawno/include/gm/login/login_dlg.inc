Dialog:AccountRegister(playerid, response, listitem, inputtext[])
{
	if(!response)	KickEx(playerid);
	ClearChatbox(playerid, 50);

	if(isnull(inputtext) || strlen(inputtext) > 24 || strlen(inputtext) < 5) {
		Dialog_Show(playerid, AccountRegister, DIALOG_STYLE_INPUT, "Dang ky tai khoan", "Nhap ten tai khoan (24 ky tu):\n{C7C7C7}Vi du: {FFFFFF}luuvu\nHay luu y rang ten nay se duoc su dung lam ten nguoi dung cua ban chu khong phai ten trong tro choi cua ban, vi vay dung dat '_' giua ten cua ban.", ">>>", "");
		return SendErrorMessage(playerid, "Do dai cua ten tai khoan phai tu 5 den 24 ky tu!");
	}
	
	if(strfind(inputtext, "/") != -1 || strfind(inputtext, "\\") != -1 ||
		strfind(inputtext, ":") != -1 || strfind(inputtext, "*") != -1 ||
		strfind(inputtext, "?") != -1 || strfind(inputtext, "\"") != -1 ||
		strfind(inputtext, "<") != -1 || strfind(inputtext, ">") != -1 ||
		strfind(inputtext, "|") != -1 || isnull(inputtext) || strfind(inputtext, " ") != -1 || strfind(inputtext, "_") != -1)	{
		
		Dialog_Show(playerid, AccountRegister, DIALOG_STYLE_INPUT, "Dang ky tai khoan", "Nhap ten tai khoan (24 ky tu):\n{C7C7C7}Vi du: {FFFFFF}luuvu", ">>>", "");
		return SendErrorMessage(playerid, "Ky tu khong phu hop trong ten!");
	}

	SetPVarString(playerid, #AccountName, inputtext);
	
	new query[128];
	mysql_format(dbHandle, query, sizeof(query), "SELECT * FROM `accounts` WHERE `login` = '%e'", inputtext);
	mysql_tquery(dbHandle, query, "CheckAccName", "i", playerid);
	return 1;
}

this::CheckAccName(playerid)
{
	if(cache_num_rows()) {
		SendErrorMessage(playerid, "Ten tai khoan da duoc su dung!");
		Dialog_Show(playerid, AccountRegister, DIALOG_STYLE_INPUT, "Dang ky tai khoan", "Nhap ten tai khoan (24 ky tu):\n{C7C7C7}Vi du: {FFFFFF}luuvu", ">>>", "");
		return 1;
	}

	ClearChatbox(playerid, 50);
	SendServerMessage(playerid, "Bay gio ban can nhap mot email phu hop.");
	Dialog_Show(playerid, EmailRegister, DIALOG_STYLE_INPUT, "Dang ky tai khoan", "Nhap email:", ">>>", "");
	return 1;
}

Dialog:EmailRegister(playerid, response, listitem, inputtext[])
{
	if(!response)	KickEx(playerid);
	ClearChatbox(playerid, 50);
	
	SetPVarString(playerid, #EmailName, inputtext);

	SendServerMessage(playerid, "Nhap mot mat khau.");

	Dialog_Show(playerid, PassRegister, DIALOG_STYLE_PASSWORD, "Dang ky tai khoan", "Nhap mat khau cua ban:", ">>>", "");
	return 1;
}

Dialog:PassRegister(playerid, response, listitem, inputtext[])
{
	if(!response)	KickEx(playerid);

    if(strlen(inputtext) < 6 || strlen(inputtext) > 32)
    {
        Dialog_Show(playerid, PassRegister, DIALOG_STYLE_PASSWORD, "{FFFFFF} Mat khau moi", "{FFFFFF} Nhap mat khau:", ">>>", "");
		return SendErrorMessage(playerid, "Mat khau phai co it nhat 6 va khong qua 32 ky tu.");
	}

	for(new i = 0; i < strlen(inputtext); i++)
	{
		switch(inputtext[i])
		{
			case '!', '@', '#', '$','%','^','&','*','(',')','_','+','=','|','[',']','{','}','-','.','`','~','<','>','?',',','/':
			{
			    Dialog_Show(playerid, PassRegister, DIALOG_STYLE_PASSWORD,"Mat khau moi", "Nhap mat khau:", ">>>", "");
				return SendErrorMessage(playerid, "Ban da su dung mot ky tu bi cam.");
			}
			default: continue;
		}
	}

	new query[512], pass[129], ip_reg[8], email[24];
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	GetPlayerIp(playerid, ip_reg, sizeof(ip_reg));
	//GetPVarString(playerid, #AccountName, name, 24);
	GetPVarString(playerid, #EmailName, email, 24);
	
	WP_Hash(pass, sizeof (pass), inputtext);
	mysql_format(dbHandle, query, sizeof(query), "INSERT INTO `accounts` (`login`,`password`,`email`,`reg_ip`,`reg_date`) VALUES ('%s','%e','%e','%s','%e')", name, pass, email, ip_reg, get_date("%dd/%mm/%yyyy, %hh:%ii", gettime()));
	mysql_tquery(dbHandle, query);
	
	ClearChatbox(playerid, 50);
	SendServerMessage(playerid, "Ban da tao tai khoan thanh cong! Vui long cho mot lat...");

	SetPlayerName(playerid, name);

	SetTimerEx("CheckAccount", 2500, false, "i", playerid);
	return 1;
}

Dialog:CreateCharacterAndroid(playerid, response, listitem, inputtext[])
{
	if(!response)	return ShowCharacterMenu(playerid);

	if(strfind(inputtext, "/") != -1 || strfind(inputtext, "\\") != -1 ||
		strfind(inputtext, ":") != -1 || strfind(inputtext, "*") != -1 ||
		strfind(inputtext, "?") != -1 || strfind(inputtext, "\"") != -1 ||
		strfind(inputtext, "<") != -1 || strfind(inputtext, ">") != -1 ||
		strfind(inputtext, "|") != -1 || isnull(inputtext) || strfind(inputtext, " ") != -1)	{
		Dialog_Show(playerid, CreateCharacterAndroid, DIALOG_STYLE_INPUT, "Tao nhan vat", "Nhap ten cua nhan vat:", ">>>", "Quay lai");
		return SendErrorMessage(playerid, "Cac ky tu khong hop le trong ten nhan vat! ");
	}
	
	if(!RPnamecheck(inputtext)) {
		Dialog_Show(playerid, CreateCharacterAndroid, DIALOG_STYLE_INPUT, "Tao nhan vat", "Nhap ten cua nhan vat:", ">>>", "Quay lai");
		return SendErrorMessage(playerid, "Cac ky tu khong hop le trong ten nhan vat! ");
	}

	new underline=0, maxname = strlen(inputtext);

    for(new i=0; i<maxname; i++)
    {
       if(inputtext[i] == '_') underline ++;
    }
    if(underline != 1) return 0;
    inputtext[0] = toupper(inputtext[0]);
    for(new x=1; x<maxname; x++)
    {
        if(inputtext[x] == '_') inputtext[x+1] = toupper(inputtext[x+1]);
        else if(inputtext[x] != '_' && inputtext[x-1] != '_') inputtext[x] = tolower(inputtext[x]);
    }

	SetPVarString(playerid, #CharacterName, inputtext);
    Dialog_Show(playerid, CharAgeAndroid, DIALOG_STYLE_INPUT, "Los Santos Roleplay - Citizen Registration", "Nhap tuoi nhan vat mong muon cua ban\nLuu y: Dieu nay phai cang thuc te cang tot.", ">>>", "");
	return 1;
}

Dialog:CharAgeAndroid(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		if(!IsNumeric(inputtext))
		{
			return Dialog_Show(playerid, CharAgeAndroid, DIALOG_STYLE_INPUT, "Los Santos Roleplay - Citizen Registration", "Nhap tuoi nhan vat mong muon cua ban\nLuu y: Dieu nay phai cang thuc te cang tot.", ">>>", "");
		}
		if(isnull(inputtext))
		{
			return Dialog_Show(playerid, CharAgeAndroid, DIALOG_STYLE_INPUT, "Los Santos Roleplay - Citizen Registration", "Nhap tuoi nhan vat mong muon cua ban\nLuu y: Dieu nay phai cang thuc te cang tot.", ">>>", "");
		}
		SetPVarInt(playerid, #CharacterAge, strval(inputtext));
		Dialog_Show(playerid, CharMonthAndroid, DIALOG_STYLE_LIST, "Los Santos Roleplay - Citizen Registration", "Thang 1\nThang 2\nThang 3\nThang 4\nThang 5\nThang 6\nThang 7\nThang 8\nThang 9\nThang 10\nThang 11\nThang 12", ">>>", "");
	}
	else
	{
		Dialog_Show(playerid, CreateCharacterAndroid, DIALOG_STYLE_INPUT, "Tao nhan vat", "Nhap ten cho nhan vat:", ">>>", "Quay lai");
	}
	return 1;
}

Dialog:CharMonthAndroid(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new string[2048];
		new month = listitem+1;
		SetPVarInt(playerid, "RegisterMonth", month);

		new lastdate;
		if(listitem == 0 || listitem == 2 || listitem == 4 || listitem == 6 || listitem == 7 || listitem == 9 || listitem == 11) lastdate = 32;
		else if(listitem == 3 || listitem == 5 || listitem == 8 || listitem == 10) lastdate = 31;
		else lastdate = 29;
		for(new x = 1; x < lastdate; x++)
		{
			format(string, sizeof(string), "%s%d\n", string, x);
		}
		Dialog_Show(playerid, CharDayAndroid, DIALOG_STYLE_LIST, "Los Santos Roleplay - Citizen Registration", string, "Gui", "");
	}
	else
	{
		Dialog_Show(playerid, CharAgeAndroid, DIALOG_STYLE_INPUT, "Los Santos Roleplay - Citizen Registration", "Nhap tuoi nhan vat mong muon cua ban\nLuu y: Dieu nay phai cang thuc te cang tot.", ">>>", "");
	}
	return 1;
}

Dialog:CharDayAndroid(playerid, response, listitem, inputtext[])
{
	new string[2048];
	if(response)
	{
		new setday = listitem+1;
		SetPVarInt(playerid, "RegisterDay", setday);

		new month, day, year;
		getdate(year,month,day);
		new startyear = year-100;
		for(new x = startyear; x < year; x++)
		{
			format(string, sizeof(string), "%s%d\n", string, x);
		}
		Dialog_Show(playerid, CharYearAndroid, DIALOG_STYLE_LIST, "Los Santos Roleplay - Citizen Registration", string, "Gui", "");
	}
	else
	{
		Dialog_Show(playerid, CharMonthAndroid, DIALOG_STYLE_LIST, "Los Santos Roleplay - Citizen Registration", "Thang 1\nThang 2\nThang 3\nThang 4\nThang 5\nThang 6\nThang 7\nThang 8\nThang 9\nThang 10\nThang 11\nThang 12", ">>>", "");
	}
	return 1;
}

Dialog:CharYearAndroid(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new month, day, year;
		getdate(year,month,day);
		new startyear = year-100;
		new string[168];
		if(response)
		{
			new setyear = listitem+startyear;
			format(string, sizeof(string), "%i/%i/%i", GetPVarInt(playerid, "RegisterDay"), GetPVarInt(playerid, "RegisterMonth"), setyear);
			SetPVarString(playerid, #CharacterBirthDate, string);
			Dialog_Show(playerid, CharGenderAndroid, DIALOG_STYLE_LIST, "Los Santos Roleplay - Citizen Registration", "Nam\nNu", ">>>", "");
		}
		else
		{
			Dialog_Show(playerid, CharMonthAndroid, DIALOG_STYLE_LIST, "Los Santos Roleplay - Citizen Registration", "Thang 1\nThang 2\nThang 3\nThang 4\nThang 5\nThang 6\nThang 7\nThang 8\nThang 9\nThang 10\nThang 11\nThang 12", ">>>", "");
		}
	}
	else
	{
		Dialog_Show(playerid, CharMonthAndroid, DIALOG_STYLE_LIST, "Los Santos Roleplay - Citizen Registration", "Thang 1\nThang 2\nThang 3\nThang 4\nThang 5\nThang 6\nThang 7\nThang 8\nThang 9\nThang 10\nThang 11\nThang 12", ">>>", "");
	}
	return 1;
}

Dialog:CharGenderAndroid(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		if(listitem == 0)
		{
			SetPVarInt(playerid, #CharacterGender, 0);
			Dialog_Show(playerid, CharAppearanceAndroid, DIALOG_STYLE_INPUT, "Los Santos Roleplay - Citizen Registration", "Nhap ngoai hinh nhan vat mong muon cua ban\nVi du: Cao 1m7, Nang 69kg, 20-30 tuoi, co bap bi ran, co mot hinh xam o tay.", ">>>", "");
		}
		else if(listitem == 1)
		{
			SetPVarInt(playerid, #CharacterGender, 1);
			Dialog_Show(playerid, CharAppearanceAndroid, DIALOG_STYLE_INPUT, "Los Santos Roleplay - Citizen Registration", "Nhap ngoai hinh nhan vat mong muon cua ban\nVi du: Cao 1m7, Nang 69kg, 20-30 tuoi, co bap bi ran, co mot hinh xam o tay.", ">>>", "");
		}
	}
	else
	{
		Dialog_Show(playerid, CharMonthAndroid, DIALOG_STYLE_LIST, "Los Santos Roleplay - Citizen Registration", "Thang 1\nThang 2\nThang 3\nThang 4\nThang 5\nThang 6\nThang 7\nThang 8\nThang 9\nThang 10\nThang 11\nThang 12", ">>>", "");
	}
	return 1;
}

Dialog:CharAppearanceAndroid(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		if(isnull(inputtext))
		{
			return Dialog_Show(playerid, CharAppearanceAndroid, DIALOG_STYLE_INPUT, "Los Santos Roleplay - Citizen Registration", "Nhap ngoai hinh nhan vat mong muon cua ban\nVi du: Cao 1m7, Nang 69kg, 20-30 tuoi, co bap bi ran, co mot hinh xam o tay.", ">>>", "");
		}
		SetPVarString(playerid, #CharacterAppearance, inputtext);
		Dialog_Show(playerid, CharSkinSelectAndroid, DIALOG_STYLE_INPUT, "Los Santos Roleplay - Citizen Registration", "Nhap trang phuc ma ban muon\nNote: SKIN ID tu 1-311.", ">>>", "");
	}
	else
	{
		Dialog_Show(playerid, CharGenderAndroid, DIALOG_STYLE_LIST, "Los Santos Roleplay - Citizen Registration", "Nam\nNu", ">>>", "");
	}
	return 1;
}

Dialog:CharSkinSelectAndroid(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		const MAX_SKINS = 311;
		if (strval(inputtext) < 0 || strval(inputtext) > MAX_SKINS)
		{
			SendErrorMessage(playerid, "Id skin khong duoc nho hon 0 va khong qua 311.");
			return Dialog_Show(playerid, CharSkinSelectAndroid, DIALOG_STYLE_INPUT, "Los Santos Roleplay - Citizen Registration", "Nhap trang phuc ma ban muon\nNote: SKIN ID tu 1-311.", ">>>", "");
		}
		if(isnull(inputtext))
		{
			return Dialog_Show(playerid, CharSkinSelectAndroid, DIALOG_STYLE_INPUT, "Los Santos Roleplay - Citizen Registration", "Nhap trang phuc ma ban muon\nNote: SKIN ID tu 1-311.", ">>>", "");
		}
		if(!IsNumeric(inputtext))
		{
			return Dialog_Show(playerid, CharSkinSelectAndroid, DIALOG_STYLE_INPUT, "Los Santos Roleplay - Citizen Registration", "Nhap trang phuc ma ban muon\nNote: SKIN ID tu 1-311.", ">>>", "");
		}

		new name[MAX_PLAYER_NAME], appearance[128], birthdate[128], query[1064];
		GetPVarString(playerid, #CharacterName, name, 24);
		GetPVarString(playerid, #CharacterAppearance, appearance, 128);
		GetPVarString(playerid, #CharacterBirthDate, birthdate, 128);

		mysql_format(dbHandle, query, sizeof(query), "INSERT INTO `users` (`accountid`,`name`,`appearance`,`birthdate`, `age`, `skin`,`sex`,`status`) VALUES (%i,'%e','%e','%e',%i,%i,%i,1)", PlayerInfo[playerid][pAccID], name, appearance, birthdate, GetPVarInt(playerid, #CharacterAge), strval(inputtext), GetPVarInt(playerid, #CharacterGender));
		mysql_tquery(dbHandle, query);
		ShowCharacterMenuAndroid(playerid);
	}
	else
	{
		Dialog_Show(playerid, CharAppearanceAndroid, DIALOG_STYLE_INPUT, "Los Santos Roleplay - Citizen Registration", "Nhap ngoai hinh nhan vat mong muon cua ban\nVi du: Cao 1m7, Nang 69kg, 20-30 tuoi, co bap bi ran, co mot hinh xam o tay.", ">>>", "");
	}
	return 1;
}

Dialog:CreateCharacter(playerid, response, listitem, inputtext[])
{
	if(!response)
	{
		RegisterClicked[playerid] = 0;
	}	

	if(strfind(inputtext, "/") != -1 || strfind(inputtext, "\\") != -1 ||
		strfind(inputtext, ":") != -1 || strfind(inputtext, "*") != -1 ||
		strfind(inputtext, "?") != -1 || strfind(inputtext, "\"") != -1 ||
		strfind(inputtext, "<") != -1 || strfind(inputtext, ">") != -1 ||
		strfind(inputtext, "|") != -1 || isnull(inputtext) || strfind(inputtext, " ") != -1)	{
		Dialog_Show(playerid, CreateCharacter, DIALOG_STYLE_INPUT, "Tao nhan vat", "Nhap ten nhan vat:", ">>>", "Quay lai");
		return SendErrorMessage(playerid, "Cac ky tu khong hop le trong ten nhan vat! ");
	}
	
	if(!RPnamecheck(inputtext)) 
	{
		Dialog_Show(playerid, CreateCharacter, DIALOG_STYLE_INPUT, "Tao nhan vat", "Nhap ten nhan vat:", ">>>", "Quay lai");
		return SendErrorMessage(playerid, "Cac ky tu khong hop le trong ten nhan vat! ");
	}

	new underline=0, maxname = strlen(inputtext);

    for(new i=0; i<maxname; i++)
    {
       if(inputtext[i] == '_') underline ++;
    }
    if(underline != 1) return 0;
    inputtext[0] = toupper(inputtext[0]);
    for(new x=1; x<maxname; x++)
    {
        if(inputtext[x] == '_') inputtext[x+1] = toupper(inputtext[x+1]);
        else if(inputtext[x] != '_' && inputtext[x-1] != '_') inputtext[x] = tolower(inputtext[x]);
    }

	UpdateRegisterText(playerid, 0, inputtext);
	return 1;
}

Dialog:CharSkinSelect(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		const MAX_SKINS = 311;
		if (strval(inputtext) < 0 || strval(inputtext) > MAX_SKINS)
		{
			SendErrorMessage(playerid, "Id skin khong duoc nho hon 0 va khong qua 311.");
			return Dialog_Show(playerid, CharSkinSelect, DIALOG_STYLE_INPUT, "Los Santos Roleplay - Citizen Registration", "Nhap trang phuc ma ban muon\nNote: SKIN ID tu 1-311.", ">>>", "");
		}
		if(isnull(inputtext))
		{
			return Dialog_Show(playerid, CharSkinSelect, DIALOG_STYLE_INPUT, "Los Santos Roleplay - Citizen Registration", "Nhap trang phuc ma ban muon\nNote: SKIN ID tu 1-311.", ">>>", "");
		}
		if(!IsNumeric(inputtext))
		{
			return Dialog_Show(playerid, CharSkinSelect, DIALOG_STYLE_INPUT, "Los Santos Roleplay - Citizen Registration", "Nhap trang phuc ma ban muon\nNote: SKIN ID tu 1-311.", ">>>", "");
		}
		UpdateRegister(playerid, 0, strval(inputtext));
	}
	else
	{
		RegisterClicked[playerid] = 0;
	}
	return 1;
}

Dialog:CharAge(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		if(!IsNumeric(inputtext))
		{
			return Dialog_Show(playerid, CharAge, DIALOG_STYLE_INPUT, "Los Santos Roleplay - Citizen Registration", "Nhap tuoi nhan vat mong muon cua ban\nLuu y: Dieu nay phai cang thuc te cang tot.", ">>>", "");
		}
		if(isnull(inputtext))
		{
			return Dialog_Show(playerid, CharAge, DIALOG_STYLE_INPUT, "Los Santos Roleplay - Citizen Registration", "Nhap tuoi nhan vat mong muon cua ban\nLuu y: Dieu nay phai cang thuc te cang tot.", ">>>", "");
		}
		new input;
		input = strval(inputtext);
		UpdateRegister(playerid, 1, input);
		SetPVarInt(playerid, #CharacterAge, strval(inputtext));
	}
	else
	{
		RegisterClicked[playerid] = 0;
	}
	return 1;
}

Dialog:CharAppearance(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		if(isnull(inputtext))
		{
			return Dialog_Show(playerid, CharAppearance, DIALOG_STYLE_INPUT, "Los Santos Roleplay - Citizen Registration", "Nhap ngoai hinh nhan vat mong muon cua ban\nVi du: Cao 1m7, Nang 69kg, 20-30 tuoi, co bap bi ran, co mot hinh xam o tay.", ">>>", "");
		}
		UpdateRegisterText(playerid, 1, inputtext);
	}
	else
	{
		RegisterClicked[playerid] = 0;
	}
	return 1;
}

Dialog:CharGender(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		if(listitem == 0)
		{
			new input;
			input = listitem + 1;
			UpdateRegister(playerid, 2, input);
		}
		else if(listitem == 1)
		{
			new input;
			input = listitem + 1;
			UpdateRegister(playerid, 2, input);
		}
	}
	else
	{
		RegisterClicked[playerid] = 0;
	}
	return 1;
}

Dialog:CharMonth(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new string[2048];
		new month = listitem+1;
		SetPVarInt(playerid, "RegisterMonth", month);

		new lastdate;
		if(listitem == 0 || listitem == 2 || listitem == 4 || listitem == 6 || listitem == 7 || listitem == 9 || listitem == 11) lastdate = 32;
		else if(listitem == 3 || listitem == 5 || listitem == 8 || listitem == 10) lastdate = 31;
		else lastdate = 29;
		for(new x = 1; x < lastdate; x++)
		{
			format(string, sizeof(string), "%s%d\n", string, x);
		}
		Dialog_Show(playerid, CharDay, DIALOG_STYLE_LIST, "Los Santos Roleplay - Citizen Registration", string, "Gui", "");
	}
	else
	{
		RegisterClicked[playerid] = 0;
	}
	return 1;
}

Dialog:CharDay(playerid, response, listitem, inputtext[])
{
	new string[2048];
	if(response)
	{
		new setday = listitem+1;
		SetPVarInt(playerid, "RegisterDay", setday);

		new month, day, year;
		getdate(year,month,day);
		new startyear = year-100;
		for(new x = startyear; x < year; x++)
		{
			format(string, sizeof(string), "%s%d\n", string, x);
		}
		Dialog_Show(playerid, CharYear, DIALOG_STYLE_LIST, "Los Santos Roleplay - Citizen Registration", string, "Gui", "");
	}
	else
	{
		RegisterClicked[playerid] = 0;
	}
	return 1;
}

Dialog:CharYear(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new month, day, year;
		getdate(year,month,day);
		new startyear = year-100;
		new string[168];
		if(response)
		{
			new Birthdate[168];
			new setyear = listitem+startyear;
			format(string, sizeof(string), "%i/%i/%i", GetPVarInt(playerid, "RegisterDay"), GetPVarInt(playerid, "RegisterMonth"), setyear);
			Birthdate = string;
			UpdateRegisterText(playerid, 2, Birthdate);
			DeletePVar(playerid, "RegisterMonth");
			DeletePVar(playerid, "RegisterDay");
		}
		else
		{
			for(new x = startyear; x < year; x++)
			{
				format(string, sizeof(string), "%s%d\n", string, x);
			}
			Dialog_Show(playerid, CharYear, DIALOG_STYLE_LIST, "Los Santos Roleplay - Citizen Registration", string, "Gui", "");
		}
	}
	else
	{
		RegisterClicked[playerid] = 0;
	}
	return 1;
}

Dialog:CreationCharSkinSel(playerid, response, listitem, inputtext[])
{
	if (!response) ShowCharacterMenu(playerid);

	new name[MAX_PLAYER_NAME], query[78 - 2 - 2 - 2 + 4 + MAX_PLAYER_NAME + 3];
	GetPVarString(playerid, #CharacterName, name, 24);

	mysql_format(dbHandle, query, sizeof(query), "INSERT INTO `users` (`accountid`,`name`,`skin`,`status`) VALUES (%i,'%e',%i,1)", PlayerInfo[playerid][pAccID], name, listitem);
	mysql_tquery(dbHandle, query);
	
	ShowCharacterMenu(playerid);
}

Dialog:FirstSpawn(playerid, response, listitem, inputtext[])
{
	if (!response)
	{
    	Dialog_Show(playerid, FirstSpawn, DIALOG_STYLE_LIST, "{8D8DFF}Chon mot vi tri spawn", "Montgomery\nPalomino\nBlueberry", "Lua chon", "");
		return 1;
	}
	StopAudioStreamForPlayer(playerid);
	ClearChatbox(playerid, 50);
	SendServerMessage(playerid, "Chao mung toi may chu, {ffc46a}%s!", GetNameEx(playerid));
    SendServerMessage(playerid, "Dung quen cac lenh: {ffc46a}/helpme, /help, /mm");
    SendHelpMessage(playerid, "Su dung /togtruckmarket de xem gia thi truong Trucker ('De lam trucker ban phai so huu xe Benson')");
    SendHelpMessage(playerid, "/GPS de tim cong viec, dia diem v.v");
	if(PlayerInfo[playerid][pHours] < 8)
	{
		SendHelpMessage(playerid, "Khi ban dat den cap do 1, ban se nhan duoc $%i truc tiep vao tai khoan ngan hang cua ban.", SERVER_BONUS);
	}
	SetWorld(playerid, 0);
	PlayerInfo[playerid][pSpawnPoint] = listitem + 1;
	SetSpawnInfoEx(playerid, first_spawn[PlayerInfo[playerid][pSpawnPoint]-1][0], first_spawn[PlayerInfo[playerid][pSpawnPoint]-1][1], first_spawn[PlayerInfo[playerid][pSpawnPoint]-1][2]);
	pTemp[playerid][pLogged] = 2;
	
	PlayerInfo[playerid][pSpawnType] = 3;
	SQL_SetInteger("users", "spawntype", PlayerInfo[playerid][pSpawnType], PlayerInfo[playerid][pID]);
	SQL_SetInteger("users", "tutorial", PlayerInfo[playerid][pTutorial], PlayerInfo[playerid][pID]);
	SQL_SetInteger("users", "spawnpoint", PlayerInfo[playerid][pSpawnPoint], PlayerInfo[playerid][pID]);
	for(new i = 0; i<52; i++) EnableAntiCheatForPlayer(playerid, i, 1);
	SpawnPlayer(playerid);
	return 1;
}

Dialog:SelectChar(playerid, response, listitem, inputtext[])
{
	if (!response) 						return KickEx(playerid);
	if (listitem < 0 || listitem > 2)	return KickEx(playerid);

	if (login_char_id[playerid][listitem] == 0)
	{	    
		Dialog_Show(playerid, CreateCharacterAndroid, DIALOG_STYLE_INPUT, "Character Creation", "Nhap ten nhan vat:\n {C7C7C7}Vi du: {FFFFFF}Dequantavious_Dingle", ">>>", "Quay lai");
		return 1;
	}

	SetPVarInt(playerid, #select_char, listitem);

	new mes[128];
	format(mes, sizeof(mes), "{FFFFFF}Ban co muon dang nhap vao nhan vat - {A9C4E4}%s?", login_char_name[playerid][listitem]);

	ConfirmDialog(playerid, "Confirmation", mes, "SelectChar2");
	return 1;
}

this::SelectChar2(playerid, response)
{
	if (!response)	return ShowCharacterMenu(playerid);

	new listitem = GetPVarInt(playerid, #select_char);
	if (listitem < 0 || listitem > 2)
		return printf("Catch"), KickEx(playerid);

	new query[256];
	format(query, sizeof(query), "SELECT users.*, accounts.admin, accounts.admin_code, accounts.donate, accounts.helper, accounts.name_changes, accounts.number_changes FROM users, accounts WHERE users.id = %i AND users.accountid = accounts.id", login_char_id[playerid][listitem]);
    mysql_tquery(dbHandle, query, "LoadCharacter", "i", playerid);
	return 1;
}

Dialog:Login(playerid, response, listitem, inputtext[])
{
	if (!response)	
	{
		SendSyntaxMessage(playerid, "Ban da thoat khoi may chu.");
  		KickEx(playerid);
	    return 1;
	}

	if (isnull(inputtext))
	{	
		static const str_size[] = "Vui long nhap mat khau tai khoan cua ban de tien hanh dang nhap"; //���� �����������
		new mes[sizeof(str_size)+103];
		
		if (pTemp[playerid][pLoggedTry] != 0) format(mes, sizeof(mes), "{FF6347}[ ! ] {FFFFFF}Ban da nhap sai mat khau!\n{FF6347}[ ! ] {FFFFFF}So lan thu con lai: {FF6347}%d\n\n%s", 3-pTemp[playerid][pLoggedTry], str_size);	
		else format(mes, sizeof(mes), str_size);
		
	    
		Dialog_Show(playerid, Login, DIALOG_STYLE_PASSWORD, "Nhap mat khau", mes, "Dang nhap", "Huy bo");
		return 1;
	}

	new query[128 + 129], buf[129];

	WP_Hash(buf, sizeof (buf), inputtext);
	mysql_format(dbHandle, query, sizeof(query), "SELECT * FROM `accounts` WHERE `id` = %i AND `password`='%e'", PlayerInfo[playerid][pAccID], buf);
	mysql_tquery(dbHandle, query, "LoginPlayer", "i", playerid);
	return 1;
}

Dialog:TutorialDialog(playerid, response, listitem, inputtext[])
{
	new gstr[168] = EOS;
	if(PlayerInfo[playerid][pTutorial] == 2)
	{
		PlayerInfo[playerid][pTutorial] = 3;

		TogglePlayerControllable(playerid, 0);
		SetPlayerPos(playerid, -156.0747, 1076.0804, 40.8421);
		SetPlayerCameraPos(playerid, -156.0747, 1076.0804, 34.8421);
		SetPlayerCameraLookAt(playerid, -158.6530, 1085.7030, 33.9706);

		strcat(gstr, "Los Santos Roleplay co he thong nha kha doc dao. May chu cung cap hon 800 ngoi nha trai dai khap Red, Bone va Flint County.\n");
		strcat(gstr, "Ban co the co duoc mot ngoi nha do minh so huu thong qua mot so phuong tien don gian va chung nhu sau.\nBan co the nhan nha tu nguoi choi hoac tao quang cao tai bat ky toa nha/thi tran SAN nao.\n");
		strcat(gstr, "Ban cung co the mua nha bang cach su dung /buyhouse ngay truoc cua nha, gia su no khong thuoc so huu cua bat ky ai.\n");
		strcat(gstr, "Cuoi cung, co mot phe ung ho tren may chu ten la Silver Trading chuyen ban nha va co so kinh doanh tu van phong cua ho o Montgomery.\n");
		strcat(gstr, "Ban co the mua do noi that cho ngoi nha cua minh tu bat ky cua hang do noi that nao xung quanh quan.\nBan co the dat do noi that noi tren o bat cu dau trong nha va ban ");
		strcat(gstr, "cung co the ap dung cac ket cau khac nhau cho do noi that ban co the mua, lam cho moi ngoi nha tro nen doc dao!\n");
		strcat(gstr, "Co nhieu tinh nang khac ma cac ngoi nha tren may chu cung cap cho chu so huu cua chung, ban co the su dung '/help house' de biet lenh them ve nha.");
		Dialog_Show(playerid, TutorialDialog, DIALOG_STYLE_MSGBOX, "Houses", gstr, "Tiep tuc", "");
	}
	else if(PlayerInfo[playerid][pTutorial] == 3)
	{
		PlayerInfo[playerid][pTutorial] = 4;

		TogglePlayerControllable(playerid, 0);
		SetPlayerPos(playerid, 1200.2905, 208.7031, 33.8517);
		SetPlayerCameraPos(playerid, 1200.2905, 208.7031, 28.8517);
		SetPlayerCameraLookAt(playerid, 1209.8973, 209.0386, 26.0953);

		strcat(gstr, "Los Santos Roleplay bao gom mot phan lon ban do cua tro choi. Vi khu vuc nhap vai rat lon, nen phuong tien la dieu can thiet de di chuyen.\n");
		strcat(gstr, "Ban co the mua xe thong qua cac dai ly hien dang trai dai quanh Red County.\nCac xe hoan toan moi thuong la");
		strcat(gstr, "dat hon nhung chiec xe da qua su dung ma ban co the trao doi giua nhung nguoi choi hoac ban co the thu van may cua minh voi mot cuoc dau gia tren dien dan.\n");
		strcat(gstr, "Sau khi ban lay duoc xe, dieu dang noi la no co the bi danh cap bat cu luc nao.\nNeu ban muon ngan xe bi mat cap, ");
		strcat(gstr, "ban phai luon khoa cop xe khi khong su dung.\nBan cung can khoa cop xe cua minh, neu khong ai do rat co the se cuop do trong do.\n");
		strcat(gstr, "Ban co the dat chiec xe cua minh xuat hien o bat cu dau ban muon su dung /savecar, tuy nhien vi tri do cua no phai nam trong luat cua tieu bang, neu khong no se bi keo di.\n\n");
		strcat(gstr, "Thong tin them ve cac phuong tien co the duoc tim thay bang cach su dung: '/help vehicle'");
		Dialog_Show(playerid, TutorialDialog, DIALOG_STYLE_MSGBOX, "Vehicles", gstr, "Tiep tuc", "");
	}
	else if(PlayerInfo[playerid][pTutorial] == 4)
	{
		PlayerInfo[playerid][pTutorial] = 5;

		TogglePlayerControllable(playerid, 0);
		SetPlayerPos(playerid, 2183.0119, -114.5582, 31.2289);
		SetPlayerCameraPos(playerid, 2183.0119, -114.5582, 26.2289);
		SetPlayerCameraLookAt(playerid, 2173.2683, -112.3087, 22.0027);

		strcat(gstr, "Co hon 300 doanh nghiep tren may chu va giong nhu nhung ngoi nha ma ho trai dai tren toan bo khu vuc dong vai.\n");
		strcat(gstr, "Cac doanh nghiep co chuc nang tao moi truong nhap vai tuy thuoc vao loai hinh cua no.\nVi du do la cau lac bo, quan ca phe hay cua hang tong hop ");
		strcat(gstr, "Tat ca chung deu la nhung lua chon kha thi neu ban muon tao ra mot so man nhap vai.\nChung cung cap cho chu so huu phan thuong trong phieu luong cua ho moi ngay.\n");
		strcat(gstr, "Cac khoan thanh toan cho doanh nghiep nay co the dao dong tu $500 den $5.000. Ban cung co the thu nhap tu doanh nghiep cua minh thong qua phi vao cua nho cung nhu\n");
		strcat(gstr, "moi nguoi mua cac mat hang tu doanh nghiep cua ban, gia su do la mot doanh nghiep ma moi nguoi co the mua cac mat hang tu.\n\n");
		strcat(gstr, "Thong tin them cho cac doanh nghiep co the duoc tim thay bang cach su dung: '/help bizz'");
		Dialog_Show(playerid, TutorialDialog, DIALOG_STYLE_MSGBOX, "Businesses", gstr, "Tiep tuc", "");
	}
	else if(PlayerInfo[playerid][pTutorial] == 5)
	{
		PlayerInfo[playerid][pTutorial] = 6;

		TogglePlayerControllable(playerid, 0);
		SetPlayerPos(playerid, 2296.0625, 81.4654, 44.3843);
		SetPlayerCameraPos(playerid, 2296.0625, 81.4654, 39.3843);
		SetPlayerCameraLookAt(playerid, 2294.4018, 72.0476, 36.4606);

		strcat(gstr, "La mot nguoi choi moi, nguon thu nhap chinh cua ban rat co the se la phu. Co 6 sidejobs tren may chu va chung nhu sau\n\n");
		strcat(gstr, "Quet duong pho, giao banh Pizza, lai xe tai, tho khai thac than, thu gom rac va tai xe xe buyt.\nTat ca nhung cong viec phu nay deu co cac cap do khac nhau, va tuy ban ");
		strcat(gstr, "thang cap trong cong viec cua ban, luong cua ban se tang len.\nCung co hai cong viec tinh de ban co duoc khi ban dat den cap do hai. ");
		strcat(gstr, "Mot nguoi la tho sua xe va nguoi kia la nhan vien bao tri.\nBan co the tim them thong tin cu the tai bat ky toa thi chinh nao bang cach su dung /jobinfo.");
		Dialog_Show(playerid, TutorialDialog, DIALOG_STYLE_MSGBOX, "Jobs", gstr, "Tiep tuc", "");
	}
	else if(PlayerInfo[playerid][pTutorial] == 6)
	{
		PlayerInfo[playerid][pTutorial] = 7;

		TogglePlayerControllable(playerid, 0);
		SetPlayerPos(playerid, 674.0645, -609.2480, 39.2767);
		SetPlayerCameraPos(playerid, 674.0645, -609.2480, 34.2767);
		SetPlayerCameraLookAt(playerid, 670.3184, -599.9761, 31.5203);

		strcat(gstr, "Tiep tuc, co mot so FAC de ban lua chon Los Santos Roleplay.\nLuon luon co mot so phe phai den va di, vi vay ");
		strcat(gstr, "chung toi se khong tham gia vao cac phe phai cu the.\nNhu du kien tren bat ky may chu nhap vai nao, co hai phe phai thiet yeu se luon co vi tri vinh vien.\nThe San Andreas State Police ");
		strcat(gstr, "thuc thi luat tren may chu, trong khi San Andreas County Fire Department co san cho tat ca cac van de lien quan den y te va hoa hoan.\nCo rat nhieu dieu bat hop phap ");
		strcat(gstr, "cac fac, ca chinh thuc va khong chinh thuc co san de cung cap vai tro cho bat ky ai thich nhap vai toi pham.\n");
		strcat(gstr, "Ban co the tim hieu them thong tin ve tat ca cac fac cua may chu tren dien dan cua chung toi.");
		Dialog_Show(playerid, TutorialDialog, DIALOG_STYLE_MSGBOX, "Factions", gstr, "Tiep tuc", "");
	}
	else if(PlayerInfo[playerid][pTutorial] == 7)
	{
		PlayerInfo[playerid][pTutorial] = 8;

		TogglePlayerControllable(playerid, 0);
		SetPlayerPos(playerid, 113.4003, -272.2333, 25.2733);
		SetPlayerCameraPos(playerid, 113.4003, -272.2333, 20.2733);
		SetPlayerCameraLookAt(playerid, 121.5919, -266.4975, 18.3652);

		strcat(gstr, "Chung toi sap hoan thanh o day! Hau het cac lenh de giao tiep tren may chu nay la cac lenh tieu chuan ban se tim thay tren bat ky may chu dong vai nao.\n");
		strcat(gstr, "Doi voi giao tiep OOC, ban co the su dung /pm de gui tin nhan ca nhan giua ban va nguoi choi khac. /b duoc su dung cho cuoc tro chuyen OOC cuc bo.\nNeu ban duoc thue vao mot nhom, ban co the su dung /f de giao tiep voi cac thanh vien cua cung mot nhom.\n");
		strcat(gstr, "Doi voi giao tiep vi mach, ban co the su dung /l de noi nho, /w de thi tham voi nguoi choi va /s de het len o dau phoi cua ban. De noi mot cach binh thuong IC, tat ca nhung gi ban can lam la nhap vao cuoc tro chuyen!");
		Dialog_Show(playerid, TutorialDialog, DIALOG_STYLE_MSGBOX, "Communication", gstr, "Tiep tuc", "");
	}
	else if(PlayerInfo[playerid][pTutorial] == 8)
	{
		PlayerInfo[playerid][pTutorial] = 9;

		TogglePlayerControllable(playerid, 0);
		SetPlayerPos(playerid, 274.1940, 96.9045, 28.7815);
		SetPlayerCameraPos(playerid, 274.1940, 96.9045, 23.7815);
		SetPlayerCameraLookAt(playerid, 264.3290, 97.7675, 22.3898);

		strcat(gstr, "Cam on ban da ngoi xem qua huong dan cua chung toi. Chung toi hy vong thong tin cung cap da giai dap duoc phan nao thac mac cua ban, con neu khong thi ban hon Chao mung toi tao su ho tro nho nhan vien phuc vu giup do.\n");
		strcat(gstr, "Hay chac chan kiem tra lenh /help truoc! Hau het cac lenh cua may chu duoc liet ke o do.\n");
		strcat(gstr, "Neu ban phat hien bat ky nguoi choi nao vi pham cac quy tac, hay nho /report ho de nhan vien co the xu ly nguoi choi phu hop.\n");
		strcat(gstr, "Chao mung toi Los Santos Roleplay, we hope you enjoy your stay!");
		Dialog_Show(playerid, TutorialDialog, DIALOG_STYLE_MSGBOX, "Conclusion", gstr, "Tiep tuc", "");
	}
	else if(PlayerInfo[playerid][pTutorial] == 9)
	{
		Dialog_Show(playerid, FirstSpawn, DIALOG_STYLE_LIST, "{8D8DFF}Chon vi tri spawn", "Montgomery\nPalomino\nBlueberry", "Lua chon", "");
	}
	return true;
}