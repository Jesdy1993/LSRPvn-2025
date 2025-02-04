ALTX:dropmoney("/dmoney");
CMD:dropmoney(playerid, params[])
{
    if (PlayerInfo[playerid][pInjured] != 0 || GetPVarInt(playerid, "Freeze") || pTemp[playerid][pTaserTime] || pTemp[playerid][pCuffed])   
		return SendErrorMessage(playerid, "Ban khong the su dung tinh nang nay ngay bay gio.");
	if (CheckAdmin(playerid, ADMIN_LEVEL_1))                                                         return SendErrorMessage(playerid, "Dau tien can phai thoat admin-duty.");
    if (IsPlayerInAnyVehicle(playerid))                                                              return SendErrorMessage(playerid, "Ban khong duoc o trong xe.");
    if (PlayerInfo[playerid][pHours] < 2)                                                            return SendErrorMessage(playerid, "Ban da choi duoi 2 gio tren may chu. Chuc nang nay khong kha dung.");

    new amount;

    if (sscanf(params, "i", amount))                                                                 return SendHelpMessage(playerid, "/dropmoney [amount]");
	if (amount < 1 || amount > 3000)                                                                 return SendErrorMessage(playerid, "Ban da nhap sai so tien ($1 - $3000).");
	if (amount > GetCash(playerid))                                                                  return SendNotCash(playerid);
	if (ItemDrop_Drop(playerid, 9999, amount) == -1)                                                 return SendErrorMessage(playerid, "Da dat den so luong vat pham bi roi toi da.");
    SendAdmMessage("%s [ID: %i] threw away $%i to the ground.", GetNameEx(playerid), playerid, amount);
	GiveCash(playerid, -amount);

    SendSyntaxMessage(playerid, "Ban da lam roi $%i. Nhan {ffc46a}/pitem{FFFFFF} hoac ngoi xuong va nhan {ffc46a}H{FFFFFF} de nhat.", amount);
	return 1;
}

CMD:drop(playerid, params[])
{
    if (!GetPVarInt(playerid, #attach_item))  return 1;
    if (ItemDrop_Drop(playerid, pTemp[playerid][tempItem], pTemp[playerid][tempQ], pTemp[playerid][tempEx]) == -1)
	return SendErrorMessage(playerid, "Da dat den so luong vat pham bi roi toi da.");

    SendSyntaxMessage(playerid, "Ban da lam roi %s. Nhan {ffc46a}/pitem{FFFFFF} hoac ngoi xuong va nhan {ffc46a}H{FFFFFF} de nhat.", inventory_items[pTemp[playerid][tempItem]][itemName], pTemp[playerid][tempQ]);			
    		
    RemovePlayerAttachedObject(playerid, ATTACH_HANDS);
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
    SetPVarInt(playerid, #attach_item, 0);

    pTemp[playerid][tempItem] = 0;
    pTemp[playerid][tempEx] = 0;
    pTemp[playerid][tempQ] = 0;
    return 1;
}

ALTX:dropgun("/dgun");
CMD:dropgun(playerid, params[])
{
    if (PlayerInfo[playerid][pPlayerWeapon] == 0) 														
		return SendErrorMessage(playerid, "Ban khong co vu khi trong tay.");
	if (PlayerInfo[playerid][pInjured] != 0 || GetPVarInt(playerid, "Freeze") || pTemp[playerid][pTaserTime] || pTemp[playerid][pCuffed] || PlayerInfo[playerid][pJailed] || PlayerInfo[playerid][pAJailed])  
		return SendErrorMessage(playerid, "Ban khong the su dung tinh nang nay ngay bay gio.");
	if (CheckAdmin(playerid, ADMIN_LEVEL_1) || IsTester(playerid))	return SendErrorMessage(playerid, "Dau tien can phai thoat admin-duty.");
	if (PlayerInfo[playerid][pOnDuty])								return SendErrorMessage(playerid, "Chuc nang nay khong kha dung khi lam viec.");
	if (IsPlayerInAnyVehicle(playerid))								return SendErrorMessage(playerid, "Ban khong duoc o trong xe.");

	new wep = CheckPlayerWeaponEx(playerid);
	if (!wep) return SendAdmMessage("Player %s[ID:%i] suspected of using cheats on weapons!", GetNameEx(playerid), playerid);
	
	if (wep >= 22 && wep <= 34) {
		new am = CheckAmmo(PlayerInfo[playerid][pAmmoType]);
		if (PlayerInfo[playerid][pPlayerAmmo] > am) PlayerInfo[playerid][pPlayerAmmo]=am;
	} 

	if (ItemDrop_Drop(playerid, PlayerInfo[playerid][pPlayerWeapon], PlayerInfo[playerid][pPlayerAmmo], PlayerInfo[playerid][pAmmoType], PlayerInfo[playerid][pWepSerial]) == -1)
		return SendErrorMessage(playerid, "Da dat den so luong vat pham bi roi toi da.");
		

	if (PlayerInfo[playerid][pPlayerAmmo]) 	SM2(playerid, "Ban da lam roi %s [%s / %i round(s)]. Nhan {ffc46a}/pitem{FFFFFF} hoac ngoi xuong va nhan {ffc46a}H{FFFFFF} de nhat.", inventory_items[PlayerInfo[playerid][pPlayerWeapon]][itemName], inventory_items[PlayerInfo[playerid][pAmmoType]][itemName], PlayerInfo[playerid][pPlayerAmmo]);
	else									SM2(playerid, "Ban da lam roi %s. Nhan {ffc46a}/pitem{FFFFFF} hoac ngoi xuong va nhan {ffc46a}H{FFFFFF} de nhat.", inventory_items[PlayerInfo[playerid][pPlayerWeapon]][itemName]);
		
	if (PlayerInfo[playerid][pPlayerAmmo])	ResetPlayerWeapons(playerid);
	else 									RemovePlayerAttachedObject(playerid, 9);

	PlayerInfo[playerid][pPlayerWeapon] = 0;
	PlayerInfo[playerid][pPlayerAmmo] = 0;
	PlayerInfo[playerid][pAmmoType] = 0;
	PlayerInfo[playerid][pWepSerial] = 0;
		
    return 1;
}

ALTX:pickupitem("/pitem");
CMD:pickupitem(playerid, params[])
{
    if (PlayerInfo[playerid][pInjured] != 0 || GetPVarInt(playerid, "Freeze") || pTemp[playerid][pTaserTime] || pTemp[playerid][pCuffed]) 
		return SendErrorMessage(playerid, "Ban khong the su dung tinh nang nay ngay bay gio.");
	new dropid = -1;
	if ((dropid = ItemDrop_Nearest(playerid)) == -1) return 1;

	if (IsPlayerCrouching(playerid)) ItemDrop_Pickup(playerid, dropid);
	else 							InfoMSG(playerid, "Ban can phai ~y~ngoi xuong ~w~de nhat ~w~vat pham~y~", 3);
	
	return 1;
}