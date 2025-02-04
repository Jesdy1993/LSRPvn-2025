/*GetWeapSlot(weaponid)
{
	switch(weaponid)
	{
		case 2..15: return 0;
		case 22,23,24,28,32: return 1;
		case 25, 26, 27, 29, 30, 31, 33, 34, 35, 36, 38: return 2;
		case 1, 16, 17, 18, 41, 42, 43, 46: return 3;
		default: return -1;
	}
	return -1;
}*/

IsWeaponDontHide(weaponid)
{
    switch(weaponid)
	{
	    case 3, 4, 5, 10, 11, 12, 13, 22, 23, 24, 28, 32: return 0;
	    default: return 1;
	}
	return 1;
}


ValidWeaponForInventory(item)
{
	switch(item)
	{
		case 1..18, 22..34, 41, 42, 43, 46, 82..99: return 1;
	}
	return 0;
}

stock SetPlayerWeapons(playerid)
{
	if (IsPlayerNPC(playerid) || !IsPlayerLogged(playerid) || PlayerInfo[playerid][pAJailed] != 0) return 1;

	ResetPlayerWeapons(playerid);

	if (PlayerInfo[playerid][pPlayerWeapon] > 0)
	{
		if (PlayerInfo[playerid][pPlayerAmmo])
			GivePlayerWeaponEx(playerid, PlayerInfo[playerid][pPlayerWeapon], PlayerInfo[playerid][pPlayerAmmo], PlayerInfo[playerid][pAmmoType], PlayerInfo[playerid][pWepSerial]);
		else 
			SetPlayerAttachedObject(playerid, 9, inventory_items[PlayerInfo[playerid][pPlayerWeapon]][itemModel], 6, 0.0, 0.0, 0.0);
	}

	CallRemoteFunction("LoadHolsters","i",playerid);
	return 1;
}

PlayerHoldingWeapon(playerid, weaponid)
{
	return (PlayerInfo[playerid][pPlayerWeapon] == weaponid) ? (1) : (0);
}

IsPlayerHoldingWeapon(playerid)
{
	return (PlayerInfo[playerid][pPlayerWeapon]) ? (1) : (0);
}

stock GivePlayerWeaponEx(playerid, weaponid, amount, ex = 0, serial = 0)
{
	if (!IsPlayerLogged(playerid))				return 0;
	if (ValidWeaponForInventory(weaponid) == 0)	return 0;

	if (weaponid >= 41 && weaponid <= 46)
	{
		PlayerInfo[playerid][pPlayerWeapon]=weaponid;
		PlayerInfo[playerid][pPlayerAmmo]=999;
		GivePlayerWeapon(playerid, weaponid, 999);
		return 1;
	}
	
	PlayerInfo[playerid][pPlayerWeapon] = weaponid;
	PlayerInfo[playerid][pPlayerAmmo] = amount;
	PlayerInfo[playerid][pAmmoType] = ex;
	PlayerInfo[playerid][pWepSerial] = serial;

	if (weaponid == 23 && amount == 999) return GivePlayerWeapon(playerid, weaponid, amount);

	if (amount >= 1)
	{
		if (weaponid >= 22 && weaponid <= 34)
		{
			new am = CheckAmmo(PlayerInfo[playerid][pAmmoType]);
			if (amount > am) PlayerInfo[playerid][pPlayerAmmo]=am;
		}
	}

	if (IsPlayerAttachedObjectSlotUsed(playerid, 9))	RemovePlayerAttachedObject(playerid, 9);

	if (PlayerInfo[playerid][pPlayerAmmo] > 0) 	GivePlayerWeapon(playerid, weaponid, PlayerInfo[playerid][pPlayerAmmo]);
	else 										SetPlayerAttachedObject(playerid, 9, inventory_items[PlayerInfo[playerid][pPlayerWeapon]][itemModel], 6, 0.0, 0.0, 0.0);

	if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER) 						SetPlayerArmedWeapon(playerid, 0);
	if (GetPlayerState(playerid) == PLAYER_STATE_PASSENGER && weaponid == 24) 	SetPlayerArmedWeapon(playerid, 0);
	
	SetTimerEx("LoadHolsters", 2000, false, "i", playerid);
	return 1;
}

stock ResetPlayerWeaponsEx(playerid, ammo = 1)
{
    ResetPlayerWeapons(playerid);

	if (PlayerInfo[playerid][pPlayerWeapon] != 0) RemovePlayerAttachedObject(playerid, ATTACH_HANDS);

	PlayerInfo[playerid][pPlayerWeapon] = 0;
	PlayerInfo[playerid][pPlayerAmmo] = 0;
	PlayerInfo[playerid][pAmmoType] = 0;
	PlayerInfo[playerid][pWepSerial] = 0;

	for(new i = 0; i < MAX_INV_SLOTS; i++) {
		if (ammo) {
			if (inventory_items[Inventory[playerid][i][pInvItem]][itemType] == ITEM_TYPE_WEAPON || inventory_items[Inventory[playerid][i][pInvItem]][itemType] == ITEM_TYPE_AMMO) {
				RemoveItem(playerid, i);
			}
		} else {
			if (inventory_items[Inventory[playerid][i][pInvItem]][itemType] == ITEM_TYPE_WEAPON) {
				RemoveItem(playerid, i);
			}
		}
	}

	FixInv(playerid);

	if (IsPlayerAttachedObjectSlotUsed(playerid, 5))	RemovePlayerAttachedObject(playerid, 5);
	if (IsPlayerAttachedObjectSlotUsed(playerid, 6))	RemovePlayerAttachedObject(playerid, 6);
    if (IsPlayerAttachedObjectSlotUsed(playerid, 7))	RemovePlayerAttachedObject(playerid, 7);

	return 1;
}

stock CompatAmmo(weaponid, id)
{
	if (inventory_items[id][itemType] != ITEM_TYPE_AMMO)	return 0;

	new result = 0;
	switch(weaponid)
	{
		case 22, 23: 	if (id == 82 || id == 83) 							result++; 
	    case 24:		if (id == 84 || id == 85) 							result++; 
	    case 25, 26: 	if (id >= 86 && id <= 89) 							result++; 
	    case 28, 29: 	if (id == 90 || id == 91) 							result++; 
	    case 30: 		if (id == 92 || id == 94 || id == 97) 				result++; 
	    case 31: 		if (id == 93 || id == 95 || id == 98 || id == 99)	result++; 
	    case 32: 		if (id == 90 || id == 91) 							result++; 
	    case 33, 34: 	if (id == 96) 										result++; 
	}
	
	return result;
}

stock CheckAmmo(AmmoType) {
	new am;

	switch(AmmoType) {
		case 1 .. 15: am=1;
		case 0: am=0;
		case 82: am=7;
		case 83: am=14;
		case 84: am=7;
		case 85: am=14;
		case 86 .. 89: am=6;
		case 90: am=30;
		case 91: am=60;
		case 92 .. 95: am=30;
		case 96: am=4;
		case 97: am=80;
		case 98: am=60;
		case 99: am=30;
	}

	return am;
}

CheckPlayerWeaponEx(playerid) {
	/*new sammo, sweapon;
	
	for (new i = 0; i < 13; i++)
	{
		GetPlayerWeaponData(playerid, i, sweapon, sammo);
		if (sweapon == PlayerInfo[playerid][pPlayerWeapon] && sammo == PlayerInfo[playerid][pPlayerAmmo]) return sweapon;
	}

	return 0;*/
	return PlayerInfo[playerid][pPlayerWeapon];
}

GetDefaultAmmoType(weapon)
{
	new ammotype;

	switch(weapon)
	{
		case 22, 23: 	ammotype = 82;
		case 24:		ammotype = 84;
		case 25, 26: 	ammotype = 86;
		case 28, 29: 	ammotype = 90;
		case 30: 		ammotype = 92;
		case 31: 		ammotype = 93;
		case 32: 		ammotype = 90;
		case 33, 34: 	ammotype = 96;
		default:		ammotype = 0;
	}

	return ammotype;
}