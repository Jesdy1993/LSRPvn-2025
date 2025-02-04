ALTX:taikhoan("/balance");
CMD:balance(playerid, params[])
{
	if (!Bank_Nearest(playerid)) return SendErrorMessage (playerid, "Ban khong o trong ngan hang.");

	SendClientMessageEx(playerid, COLOR_FADE1, "[Bank]: Tai khoan cua ban co $%i.", PlayerInfo[playerid][pBank]);
    SendClientMessageEx(playerid, COLOR_FADE1, "[Bank]: Tai khoan tiet kiem: $%i. Luong: $%i", PlayerInfo[playerid][pSavings], PlayerInfo[playerid][pPayCheckMoney]);
	return 1;
}
ALTX:chuyentien("/transfer");
CMD:transfer(playerid, params[])
{
	new userid, amount;

	if (!Bank_Nearest(playerid)) return SendErrorMessage(playerid, "Ban khong o trong ngan hang.");
	if (sscanf(params, "ud", userid, amount))
	{
		SendHelpMessage(playerid, "/transfer [ID/Part Of Name] [money]");
		SendSyntaxMessage(playerid,"[Bank]: Ban co $%i trong tai khoan ngan hang.", PlayerInfo[playerid][pBank]);
		return 1;
	}

	if (userid == playerid)								return SendErrorMessage (playerid, "Ban khong the chuyen tien cho chinh minh.");
	if (!IsPlayerLogged(userid))						return SendNotConnected(playerid);
	if (GetBankCash(playerid) < amount || amount < 1)	return SendErrorMessage (playerid, "Ban khong co du so tien nhu vay trong tai khoan.");

	BankTransfer(playerid, userid, amount);
	return 1;
}
ALTX:guitien("/deposit");
CMD:deposit(playerid, params[])
{
	new amount;

	if (!Bank_Nearest(playerid)) return SendErrorMessage (playerid, "Ban khong o trong ngan hang.");

	if (sscanf(params, "d", amount))
	{
		SendHelpMessage(playerid, "/deposit [money]");
		SendSyntaxMessage(playerid, "[Bank]: Ban co $%i trong tai khoan ngan hang.", PlayerInfo[playerid][pBank]);
		return 1;
	}

    if (amount > GetCash(playerid) || amount < 1) return SendErrorMessage(playerid, "Ban khong co so tien nhu vay trong nguoi.");
		
	BankDeposit(playerid, amount);
	return 1;
}
ALTX:ruttien("/withdraw");
CMD:withdraw(playerid, params[])
{
	new amount;

	if (!Bank_Nearest(playerid)) return SendErrorMessage(playerid, "Ban khong o trong ngan hang.");

	if (sscanf(params, "d", amount))
	{
		SendHelpMessage(playerid, "/withdraw [money]");
		SendClientMessageEx(playerid, COLOR_FADE1, "[Bank]: Ban co $%i trong tai khoan ngan hang.", PlayerInfo[playerid][pBank]);
		return 1;
	}

    if (amount > GetBankCash(playerid) || amount < 1)	return SendErrorMessage(playerid,"Ban khong co du so tien nhu vay trong tai khoan.");
    
	BankWithdraw(playerid, amount);
	return 1;
}

CMD:savings(playerid, params[])
{
	new amount;
	if (!Bank_Nearest(playerid)) return SendErrorMessage(playerid, "Ban khong o trong ngan hang.");

	if (PlayerInfo[playerid][pSavings] == 0)
	{
		if (sscanf(params, "d", amount))		return SendHelpMessage(playerid, "/savings [so luong]");
		if (amount < 35000 || amount > 100000)	return SendErrorMessage(playerid, "So tien gui tu 35000 den 100000.");
		if (GetCash(playerid) < amount) 		return SendNotCash(playerid);

		SendSyntaxMessage(playerid, "Ban da gui $%d vao tai khoan tiet kiem duoi 1%%.");
		GiveCash(playerid, -amount);
		PlayerInfo[playerid][pSavings] = amount;
		return 1;
	}
	else
	{
		SendSyntaxMessage(playerid, "Ban da rut $%i tien tiet kiem cua minh.", PlayerInfo[playerid][pSavings]);
		GiveCash(playerid, PlayerInfo[playerid][pSavings]);
		PlayerInfo[playerid][pSavings] = 0;
	}
	return 1;
}

CMD:paycheck(playerid, params[])
{
	if (!Bank_Nearest(playerid))					return SendErrorMessage(playerid, "Ban khong o trong ngan hang.");
	if (PlayerInfo[playerid][pPayCheckMoney] < 1)	return SendErrorMessage(playerid, "Khong co tien de rut ra.");

	SendSyntaxMessage(playerid, "Ban da rut $%i tu tien luong cua ban.", PlayerInfo[playerid][pPayCheckMoney]);
	GiveCash(playerid, PlayerInfo[playerid][pPayCheckMoney]);
	PlayerInfo[playerid][pPayCheckMoney] = 0;
	return 1;
}

CMD:atm(playerid, params[])
{
    if (ATM_Nearest(playerid) == -1) return 1;
	if(LockBank == true) return SendErrorMessage(playerid,"He thong nay dang bi khoa");
	Dialog_Show(playerid, ATMMenu, DIALOG_STYLE_LIST, "{FFFFFF}Danh sach", "- Tai khoan\n- Rut tien\n- Gui tien\n- Chuyen tien", "Chon", "Huy bo");
	return 1;
}