Dialog:FDArmoury(playerid, response, listitem, inputtext[])
{
	if (!response)															return cmd::duty(playerid, "");
    if (!IsPlayerFactionMedic(playerid) || !IsPlayerFactionFire(playerid))	return 1;
    if (!PlayerInfo[playerid][pOnDuty])										return SendErrorMessage(playerid, "Dau tien ban can phai trong gio lam viec.");
    if (!IsPlayerAtUniform(playerid) && !IsPlayerAtSecondUniform(playerid))	return SendErrorMessage(playerid, "Ban khong o trong phong thay do / tren phuong tien to chuc.");
	        
	switch(listitem)
	{
		case 0: GivePlayerWeaponEx(playerid, 9, 1);
		case 1: GivePlayerWeaponEx(playerid, 42, 999);
		case 2: ResetPlayerWeaponsEx(playerid);
	}
	InfoMSG(playerid,    "~r~Tui ddo --", 4);

	switch(listitem)
	{
		case 0: if (GiveInvItem(playerid, INV_RADIO, 1) == -1) return SendErrorMessage(playerid, "Tui do day!"); // •••••
		case 1: if (!GivePlayerWeaponEx(playerid, 9, 1, GetDefaultAmmoType(9), PlayerInfo[playerid][pPlayerSerial])) 	return SendErrorMessage(playerid, "Tui do day!");
		case 2: if (!GivePlayerWeaponEx(playerid, 42, 999, GetDefaultAmmoType(42), PlayerInfo[playerid][pPlayerSerial])) return SendErrorMessage(playerid, "Tui do day!");
		case 3: ResetPlayerWeaponsEx(playerid);
	}
	InfoMSG(playerid,    "~g~Tui do ++", 4);
	
	Dialog_Show(playerid, FDArmoury, DIALOG_STYLE_LIST, "Equipment", "• Bo dam\n• May cua\n• •Binh cuu hoa{FF6347}• Bat tat ca cac thiet bi", "Chon", "Quay lai");
 	return 1;
}