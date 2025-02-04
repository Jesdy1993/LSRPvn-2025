Dialog:ATMMenu(playerid, response, listitem, inputtext[])
{
	if (!response)	return 1;
	    
	switch(listitem)
	{
	    case 0:
		{
		    static const str_size[] = "Tai khoan ngan hang: {"COL_GREEN"}$%i.\nTai khoan tiet kiem: {"COL_GREEN"}$%i\nLuong: {"COL_GREEN"}$%i";
		    new mes[sizeof(str_size) - 4 + 24];
		    
			format(mes, sizeof(mes), str_size, PlayerInfo[playerid][pBank], PlayerInfo[playerid][pSavings], PlayerInfo[playerid][pPayCheckMoney]);
			Dialog_Show(playerid, ATMBack, DIALOG_STYLE_LIST, "{FFFFFF}Tai khoan", mes, "Quay lai", "");
		}
		case 1: Dialog_Show(playerid, ATMWithdraw, DIALOG_STYLE_INPUT, "{FFFFFF} Rut tien", "{FFFFFF} Nhap so luong ban muon rut:", "Rut", "Quay lai");
		case 2: Dialog_Show(playerid, ATMDeposit, DIALOG_STYLE_INPUT, "{FFFFFF} Gui tien", "{FFFFFF} Nhap so luong ban muon gui:", "Gui", "Quay lai");
		case 3: Dialog_Show(playerid, ATMTransfer, DIALOG_STYLE_INPUT, "{FFFFFF} Chuyen tien", "{FFFFFF} Nhap Ten / ID nguoi ban muon chuyen tien:", ">>>", "Quay lai");
	}
	return 1;
}//î

Dialog:ATMBack(playerid, response, listitem, inputtext[])
{
	if (response)	cmd::atm(playerid, "");
	
	return 1;
}

Dialog:ATMTransfer(playerid, response, listitem, inputtext[])
{
	if (!response)	return cmd::atm(playerid, "");

	new userid;

	sscanf(inputtext, "u", userid);

	if (!IsPlayerLogged(userid) || userid == playerid)
	{
	    Dialog_Show(playerid, ATMTransfer, DIALOG_STYLE_INPUT, "{FFFFFF}Chuyen tien", "{FFFFFF}Nhap Ten / ID cua nguoi ban can chuyen duoi day:", ">>>", "Quay lai");
	    return SendErrorMessage(playerid, "Nguoi nhan khong tim thay.");
	}

	static const str_size[] = "{FFFFFF}Chuyen tien - {FFFF00}%s";
	new mes[sizeof(str_size) - 2 + MAX_PLAYER_NAME + 1];

	format(mes, sizeof(mes), str_size, GetNameEx(userid));
	SetPVarInt(playerid, #transfer_player, userid);
	Dialog_Show(playerid, ATMTransfer2, DIALOG_STYLE_INPUT, mes, "{FFFFFF}Nhap so tien ban muon chuyen:", "Chuyen", "Huy bo");
	return 1;
}

Dialog:ATMTransfer2(playerid, response, listitem, inputtext[])
{
	if (!response) return cmd::atm(playerid, "");

	new userid = GetPVarInt(playerid, #transfer_player), amount = strval(inputtext);

	DeletePVar(playerid, #transfer_player);

	if (!IsPlayerLogged(userid) || userid == playerid)
	{
	    Dialog_Show(playerid, ATMTransfer, DIALOG_STYLE_INPUT, "{FFFFFF}Chuyen tien", "{FFFFFF}Nhap Ten / ID cua nguoi ban can chuyen duoi day:", ">>>", "Quay lai");
	    return SendErrorMessage(playerid, "Nguoi nhan khong tim thay.");
	}
	if (GetBankCash(playerid) < amount || amount < 1)
	{
	    static const str_size[] = "{FFFFFF}Chuyen tien - {FFFF00}%s";
		new mes[sizeof(str_size) - 2 + MAX_PLAYER_NAME + 1];

		format(mes, sizeof(mes), str_size, GetNameEx(userid));
		SetPVarInt(playerid, #transfer_player, userid);
		Dialog_Show(playerid, ATMTransfer2, DIALOG_STYLE_INPUT, mes, "{FFFFFF}Nhap so tien ban muon chuyen:", "Chuyen", "Huy bo");
 		return SendErrorMessage(playerid, "Ban khong co du tien trong tai khoan");
	}
	
	BankTransfer(playerid, userid, amount);
	cmd::atm(playerid, "");
	return 1;
}

Dialog:ATMWithdraw(playerid, response, listitem, inputtext[])
{
	if (!response) return cmd::atm(playerid, "");
	    
	new amount = strval(inputtext);

    if (amount > GetBankCash(playerid) || amount < 1)
	{
        Dialog_Show(playerid, ATMWithdraw, DIALOG_STYLE_INPUT, "{FFFFFF}Rut tien", "{FFFFFF}Nhap so tien ban muon rut:", "Rut", "Quay lai");
		return SendErrorMessage(playerid, "Ban khong co du tien de rut.");
	}
	
	BankWithdraw(playerid, amount);
	cmd::atm(playerid, "");
	return 1;
}

Dialog:ATMDeposit(playerid, response, listitem, inputtext[])
{
	if (!response) return cmd::atm(playerid, "");

	new amount = strval(inputtext);

    if (amount > GetCash(playerid) || amount < 1)
	{
        Dialog_Show(playerid, ATMDeposit, DIALOG_STYLE_INPUT, "{FFFFFFF}Gui tien", "{FFFFFF}Nhap so tien ban muon gui:", "Gui", "Quay lai");
		return SendErrorMessage(playerid, "Ban khong co du tien trong nguoi.");
	}

	BankDeposit(playerid, amount);
	cmd::atm(playerid, "");
	return 1;
}//î