Dialog:CITYGUN(playerid, response, listitem, inputtext[])
{
	if (!response)															return cmd::duty(playerid, "");
    if (!IsPlayerFactionCity(playerid))										return 1;
    if (!PlayerInfo[playerid][pOnDuty])										return SendErrorMessage(playerid, "Dau tien ban can phai trong gio lam viec.");
	if (!IsPlayerAtUniform(playerid) && !IsPlayerAtSecondUniform(playerid))	return SendErrorMessage(playerid, "Ban khong o trong phong thay do.");
		
	GameTextForPlayer(playerid, "~r~-", 1500, 4);

	switch(listitem)
	{
		case 0: if (GiveInvItem(playerid, INV_RADIO, 1) == -1) return SendErrorMessage(playerid, "Tui do day!"); // рация
		case 1: if (!GivePlayerWeaponEx(playerid, 24, 85, GetDefaultAmmoType(24), PlayerInfo[playerid][pPlayerSerial])) 	return SendErrorMessage(playerid, "Tui do day!");
		case 2: if (GiveInvItem(playerid, 85, CheckAmmo(85)) == -1) return SendErrorMessage(playerid, "Tui do day!");// desert eagle patrons 85
		case 3: if (!GivePlayerWeaponEx(playerid, 29, 91, GetDefaultAmmoType(29), PlayerInfo[playerid][pPlayerSerial])) 	return SendErrorMessage(playerid, "Tui do day!");
		case 4: if (GiveInvItem(playerid, 91, CheckAmmo(91)) == -1) return SendErrorMessage(playerid, "Tui do day!");// MP5 patrons 91
		case 5: if (!GivePlayerWeaponEx(playerid, 31, 98, GetDefaultAmmoType(31), PlayerInfo[playerid][pPlayerSerial])) 	return SendErrorMessage(playerid, "Tui do day!");
		case 6: if (GiveInvItem(playerid, 98, CheckAmmo(98)) == -1) return SendErrorMessage(playerid, "Tui do day!");// M4 patrons 98
		case 7: if (GiveInvItem(playerid, 99, CheckAmmo(99)) == -1) return SendErrorMessage(playerid, "Tui do day!");// M4 neletalnoe patrons 99
		case 8: ResetPlayerWeaponsEx(playerid);
	}

	GameTextForPlayer(playerid, "~g~+", 1500, 4);

	Dialog_Show(playerid, CITYGUN, DIALOG_STYLE_LIST, "Vu khi", "- Bo dam\n- Desert Eagle ( .50AE .ext )\n\t{ffc46a}- Take extra magazines (.50AE .ext)\n{FFFFFF} - MP5 (9x19mm .ext)\n\t{ffc46a} - Get extra magazines (9x19mm .ext)\n{FFFFFF} - M4 (5.56x45mm (drum))\n\t{ffc46a} - Get extra ammo (5.56x45mm (drum))\n\t{ffc46a} - Take non-lethal ammo (5.56x45mm (rubber))\n{FF6347} - Surrender all weapons", "Select", "Close");
 	return 1;
}