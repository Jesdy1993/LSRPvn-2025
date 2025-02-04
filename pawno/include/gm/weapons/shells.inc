enum SHELL_ENUM
{
	sUsed,
    Text3D:sText,
	Float:sX,
	Float:sY,
	Float:sZ,
	sTime,
	sSerial
};
new Shells[MAX_OBJECTS][SHELL_ENUM];

this::CreateShell(playerid, Float:X, Float:Y, Float:Z, worldid, ammotype, intid, serialid)
{
	new found = 0, foundid = 0, found2 = 0, str[128];
    for(new i = 0; i < MAX_OBJECTS; i++)
    {
        if (Shells[i][sUsed] == 0 && found == 0)
        {
            found++;
            foundid=i;
			break;
        }
    }
    for(new i2 = 0; i2 < MAX_OBJECTS; i2++)
    {
        if (Shells[i2][sUsed] && Shells[i2][sX] == X && Shells[i2][sY] == Y && Shells[i2][sZ] == Z)
        {
            found2++;
			break;
        }
    }
    if (found == 0) return true;
	if (found2 != 0) return true;

    Shells[foundid][sUsed] = PlayerInfo[playerid][pID];
    format(str, 128, "(( SHELLS ))\n%s", inventory_items[ammotype][itemName]);
    Shells[foundid][sText]=CreateDynamic3DTextLabel(str, COLOR_LIGHTRED, X, Y, Z-0.8, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, worldid, intid, -1, 50.0);
    Shells[foundid][sX]=X, Shells[foundid][sY]=Y, Shells[foundid][sZ]=Z;
    Shells[foundid][sTime]=10;
	Shells[foundid][sSerial] = serialid;
	return true;
}

Shell_Limit(playerid)
{
    new count = 0;
    for(new i2 = 0; i2 < MAX_OBJECTS; i2++)
    {
        if (Shells[i2][sUsed] == PlayerInfo[playerid][pID]) count++;
    }

    if (count >= 5)  return true;
    else            return false;
}

IsAroundShell(playerid)
{
    for(new i2 = 0; i2 < MAX_OBJECTS; i2++)
    {
        if (Shells[i2][sUsed])
		{
            if (IsPlayerInRangeOfPoint(playerid, 10.0, Shells[i2][sX], Shells[i2][sY], Shells[i2][sZ]) && Shells[i2][sSerial] == PlayerInfo[playerid][pWepSerial]) return i2+1;
		    else if (IsPlayerInRangeOfPoint(playerid, 5.0, Shells[i2][sX], Shells[i2][sY], Shells[i2][sZ]))  return i2+1;
        }
    }
	return false;
}

IsPlayerAroundShell(playerid)
{
    for(new i2 = 0; i2 < MAX_OBJECTS; i2++)
    {
        if (Shells[i2][sUsed])
		{
		    if (IsPlayerInRangeOfPoint(playerid, 1.5, Shells[i2][sX], Shells[i2][sY], Shells[i2][sZ]))  return i2+1;
        }
    }
	return false;
}

ShellsTimer() //every minute
{
    for(new o = 0; o < MAX_OBJECTS; o++)
	{
	    if (Shells[o][sUsed])
	    {
	        if (Shells[o][sTime] >= 1) { Shells[o][sTime]--; }
	        else
	        {
	            Shells[o][sTime]=0;
	            Shells[o][sUsed]=0;
                Shells[o][sSerial]=0;
	            Shells[o][sX]=0.0;
	            Shells[o][sY]=0.0;
	            Shells[o][sZ]=0.0;

	            DestroyDynamic3DTextLabel(Shells[o][sText]);
	        }
	    }
	}
    return 1;
}

Shells_OnPlayerWeaponShot(playerid)//, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
    new cammo = CompatAmmo(PlayerInfo[playerid][pPlayerWeapon], PlayerInfo[playerid][pAmmoType]), 
        Float:fOPos[3]
    ;

    if (!cammo)                                                                                                              return 1;
    if (pTemp[playerid][pTaser])	                                                                                            return 1;
    if (IsPlayerFactionPolice(playerid) && PlayerInfo[playerid][pOnDuty]) return 1;
    if (PlayerInfo[playerid][pAmmoType] == 89 || PlayerInfo[playerid][pAmmoType] == 99)                                      return 1;

    GetPlayerPos(playerid, fOPos[0], fOPos[1], fOPos[2]);

    if (!IsAroundShell(playerid) && !Shell_Limit(playerid))
        CallRemoteFunction("CreateShell","ifffiiii", playerid, fOPos[0], fOPos[1], fOPos[2], GetPlayerVirtualWorld(playerid), PlayerInfo[playerid][pAmmoType], GetPlayerInterior(playerid), PlayerInfo[playerid][pWepSerial]);
	    
    return 1;
}

CheckSerial(playerid, serial)
{    
    new query[128];
	mysql_format(dbHandle, query, sizeof(query), "SELECT name FROM `users` WHERE `PlayerSerial`=%i LIMIT 1", serial);
	mysql_tquery(dbHandle, query, "CheckSerial2", "i", playerid);

    return 1;
}

this::CheckSerial2(playerid)
{
    if (!cache_num_rows()) return SM1(playerid, "Ban da nhat vo dan. So seri - {ffc46a}UNKNOWN{FFFFFF}");
    
    new name[MAX_PLAYER_NAME + 1];
    cache_get_field_content(0, "name", name);
    
    return SM1(playerid, "Ban nhat vo dan. So seri - {ffc46a}%d{FFFFFF}. (( %s ))", cache_get_field_content_int(0, "PlayerSerial"), name);
}

CMD:shell(playerid, params[])
{
    if (PlayerInfo[playerid][pInjured] != 0 || GetPVarInt(playerid, "Freeze") || pTemp[playerid][pTaserTime] || pTemp[playerid][pCuffed] || PhoneInfo[playerid][current_page] == PAGE_NOTIFICATION || PlayerInfo[playerid][pJailed] != 0)
		return SendErrorMessage(playerid, "Ban khong the su dung tinh nang nay ngay bay gio.");

    new i = IsPlayerAroundShell(playerid);
    if (!i)  return SendErrorMessage(playerid, "Khong co vo dan nao o gan ban.");
    
    i -= 1;
    if (!Shells[i][sUsed])      return SendErrorMessage(playerid, "Khong co vo dan nao o gan ban.");
    if (Shells[i][sTime] > 9)   return SendWarningMessage(playerid, "Vo vien dan qua nong. Cho mot chut khi nhat!");
		
    Shells[i][sTime]=0;
    Shells[i][sUsed]=0;
    Shells[i][sSerial]=0;
    Shells[i][sX]=0.0;
    Shells[i][sY]=0.0;
    Shells[i][sZ]=0.0;
    DestroyDynamic3DTextLabel(Shells[i][sText]);
    ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0);

    if (IsPlayerFactionPolice(playerid) && PlayerInfo[playerid][pOnDuty] && Shells[i][sSerial])
        return CheckSerial(playerid, Shells[i][sSerial]);

    if (Shells[i][sSerial] == 0) 
        SM1(playerid, "Ban da nhat vo dan. So seri - {ffc46a}UNKNOWN{FFFFFF}.");
	else 
		SM1(playerid, "Ban da nhat vo dan. So seri - {ffc46a}%d{FFFFFF}.", Shells[i][sSerial]);

    return 1;
}//�