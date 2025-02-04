Dialog:DOCSGUN(playerid, response, listitem, inputtext[])
{
	if (!response)															return cmd::duty(playerid, "");
    if (!IsPlayerFactionDocs(playerid))										return 1;
	if (!PlayerInfo[playerid][pOnDuty])										return SendErrorMessage(playerid, "Dau tien ban can trong gio lam viec.");
    if (!IsPlayerAtUniform(playerid) && !IsPlayerAtSecondUniform(playerid))	return SendErrorMessage(playerid, "Ban phai o trong phong thay do.");
	    	
	InfoMSG(playerid,    "~r~Tui do --", 4);

	switch(listitem)
	{
		case 0: if (GiveInvItem(playerid, INV_RADIO, 1) == -1) return SendErrorMessage(playerid, "Tui do day!"); // �����
		case 1: if (!GivePlayerWeaponEx(playerid, 3, 1, GetDefaultAmmoType(3), PlayerInfo[playerid][pPlayerSerial])) 	return SendErrorMessage(playerid, "Tui do day!");
		case 2: if (!GivePlayerWeaponEx(playerid, 41, 999, GetDefaultAmmoType(41), PlayerInfo[playerid][pPlayerSerial])) return SendErrorMessage(playerid, "Tui do day!");
		case 3: if (!GivePlayerWeaponEx(playerid, 24, 85, GetDefaultAmmoType(24), PlayerInfo[playerid][pPlayerSerial])) 	return SendErrorMessage(playerid, "Tui do day!");
		case 4: if (GiveInvItem(playerid, 85, CheckAmmo(85)) == -1) return SendErrorMessage(playerid, "Tui do day!");// desert eagle patrons 85
		case 5: if (!GivePlayerWeaponEx(playerid, 29, 91, GetDefaultAmmoType(29), PlayerInfo[playerid][pPlayerSerial])) 	return SendErrorMessage(playerid, "Tui do day!");
		case 6: if (GiveInvItem(playerid, 91, CheckAmmo(91)) == -1) return SendErrorMessage(playerid, "Tui do day!");// MP5 patrons 91
		case 7: if (!GivePlayerWeaponEx(playerid, 25, 89, GetDefaultAmmoType(25), PlayerInfo[playerid][pPlayerSerial])) 	return SendErrorMessage(playerid, "Tui do day!");
		case 8: if (GiveInvItem(playerid, 86, CheckAmmo(86)) == -1) return SendErrorMessage(playerid, "Tui do day!");// Shotgun patrons 86
		case 9: if (GiveInvItem(playerid, 89, CheckAmmo(89)) == -1) return SendErrorMessage(playerid, "Tui do day!");// Shotgun neletalnoe patrons 89
		case 10: if (!GivePlayerWeaponEx(playerid, 31, 98, GetDefaultAmmoType(31), PlayerInfo[playerid][pPlayerSerial])) 	return SendErrorMessage(playerid, "Tui do day!");
		case 11: if (GiveInvItem(playerid, 98, CheckAmmo(98)) == -1) return SendErrorMessage(playerid, "Tui do day!");// M4 patrons 98
		case 12: if (GiveInvItem(playerid, 99, CheckAmmo(99)) == -1) return SendErrorMessage(playerid, "Tui do day!");// M4 neletalnoe patrons 99
		case 13: if (!GivePlayerWeaponEx(playerid, 34, 96, GetDefaultAmmoType(34), PlayerInfo[playerid][pPlayerSerial])) return SendErrorMessage(playerid, "Tui do day!");
		case 14: if (GiveInvItem(playerid, 96, CheckAmmo(96)) == -1) return SendErrorMessage(playerid, "Tui do day!");// Sniper Rifle patrons 96
		case 15: if (!GivePlayerWeaponEx(playerid, 17, 1, GetDefaultAmmoType(17), PlayerInfo[playerid][pPlayerSerial])) 	return SendErrorMessage(playerid, "Tui do day!");
		case 16: if (!GivePlayerWeaponEx(playerid, 43, 50, GetDefaultAmmoType(43), PlayerInfo[playerid][pPlayerSerial])) return SendErrorMessage(playerid, "Tui do day!");
		case 17: ResetPlayerWeaponsEx(playerid);
	}
	InfoMSG(playerid,    "~g~Tui do ++", 4);

	Dialog_Show(playerid, DOCSGUN, DIALOG_STYLE_LIST, "Vu khi "," {FFFFFF} - Baton\n- Pepper Spray\n- Desert Eagle (.50AE .ext)\n\t{ffc46a} - Get extra magazines (.50AE .ext)\n{FFFFFF} - MP5 (9x19mm .ext)\n\t{ffc46a} - Get extra magazines (9x19mm .ext)\n{FFFFFF} - Shotgun (12-G BIRDSHOT)\n\t{ffc46a} - Get extra magazines (12-G BIRDSHOT)\n\t{ffc46a} - Take non-lethal magazines (12-G BEANBAG)\n{FFFFFF} - M4 (5.56x45mm (drum))\n\t{ffc46a} - Take extra magazines (5.56x45mm (drum))\n\t{ffc46a} - Take non-lethal magazines (5.56x45mm (rubber))\n{FFFFFF} - Sniper Rifle (7.62x51mm)\n\t{ffc46a} - Take extra magazines (7.62x51mm)\n{FFFFFF} - Gas grenade\n- Camera\n{FF6347} - Surrender all weapons "," Select "," Close ");
	return 1;
}