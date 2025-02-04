Fire_OnPlayerWeaponShot(playerid)
{
    if (GetPVarInt(playerid, #crt_fire) == 1)
	{
	    new Float:fOriginX, Float:fOriginY, Float:fOriginZ, Float:fHitPosX, Float:fHitPosY, Float:fHitPosZ;
		GetPlayerLastShotVectors(playerid, fOriginX, fOriginY, fOriginZ, fHitPosX, fHitPosY, fHitPosZ);

		new fireid = -1;
		for(new i; i != MAX_FIRES; i++)
		{
		    if (FiresInfo[i][fireOn] != 0) continue;

			fireid = i;
			break;
		}

		if (fireid == -1)	return SendErrorMessage(playerid,"So luong dam chay toi da da dat duoc");

		FiresInfo[fireid][fireOn] = 1;
		FiresInfo[fireid][fireObj] = CreateDynamicObject(18691, fHitPosX, fHitPosY, fHitPosZ-2.0, 0.0, 0.0, 0.0, GetWorld(playerid), GetInterior(playerid));
		FiresInfo[fireid][firePos][0] = fHitPosX;
		FiresInfo[fireid][firePos][1] = fHitPosY;
		FiresInfo[fireid][firePos][2] = fHitPosZ;
		FiresInfo[fireid][fireVW] = GetWorld(playerid);
		FiresInfo[fireid][fireInt] = GetInterior(playerid);
		FiresInfo[fireid][fireHealth] = 100;
		FiresInfo[fireid][fireTimer] = 1800;

		SendSyntaxMessage(playerid, "Dam chay [ID: %i] da duoc thanh lap.", fireid);
		FiresInfo[fireid][fireLabel] = CreateDynamic3DTextLabel("100 %", 0xCC0500FFF, fHitPosX, fHitPosY, fHitPosZ+2.3, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, GetWorld(playerid), GetInterior(playerid), -1, 100.0);
	    
		return 0;
	}
    return 1;
}