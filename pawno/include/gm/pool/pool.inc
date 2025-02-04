this::Pool_Timer(playerid, poolid)
{
    if(PoolInfo[poolid][bCurrentShooter] == playerid)
    {
        if(pTemp[playerid][pAiming] != 0)
        {
            new keys, ud, lr;
            GetPlayerKeys(playerid, keys, ud, lr);
            if(!(keys & KEY_FIRE))
            {
                if(lr)
                {
                    new
                        Float:X,
                        Float:Y,
                        Float:Z,
                        Float:Xa,
                        Float:Ya,
                        Float:Za,
                        Float:x,
                        Float:y,
                        Float:newrot,
                        Float:dist;
                    GetPlayerPos(playerid, X, Y ,Z);
                    GetObjectPos(PoolInfo[poolid][bBalls][0], Xa, Ya, Za);
                    newrot = CueAimAngle[playerid][0] + (lr > 0 ? 0.9 : -0.9);
                    dist = GetPointDistanceToPoint(X, Y, Xa, Ya);
                    if(AngleInRangeOfAngle(CueAimAngle[playerid][1], newrot, 30.0))
                    {
                        CueAimAngle[playerid][0] = newrot;
                        GetXYBehindObjectInAngle(PoolInfo[poolid][bBalls][0], newrot, x, y, 0.675);
                        SetPlayerCameraPos(playerid, x, y, Za+0.28);
                        SetPlayerCameraLookAt(playerid, Xa, Ya, Za+0.170);
                        GetXYInFrontOfPos(Xa, Ya, newrot+180, x, y, 0.085);
                        SetObjectPos(AimObject[playerid], x, y, Za);
                        SetObjectRot(AimObject[playerid], 7.0, 0, CueAimAngle[playerid][0]+180);
                        GetXYInFrontOfPos(Xa, Ya, newrot+180, X, Y, dist);
                        SetPlayerPos(playerid, X, Y, Z);
                        SetPlayerFacingAngle(playerid, newrot);
                    }
                }
            }
            else
            {
                if(PoolDir[playerid])
                    CuePower[playerid] -= 2.0;
                else
                    CuePower[playerid] += 2.0;
                if(CuePower[playerid] <= 0)
                {
                    PoolDir[playerid] = 0;
                    CuePower[playerid] = 2.0;
                }
                else if(CuePower[playerid] > 100.0)
                {
                    PoolDir[playerid] = 1;
                    CuePower[playerid] = 98.0;
                }
                TextDrawTextSize(PoolTD[2], 501.0 + ((67.0 * CuePower[playerid])/100.0), 0.0);
                TextDrawShowForPlayer(playerid, PoolTD[2]);
            }
        }
    }
    return 1;
}

Pool_OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(pTemp[playerid][pPlayingPool])
	{
        if (IsKeyJustUp(KEY_HANDBRAKE, newkeys, oldkeys))
		{
            if (PlayerInfo[playerid][pPlayerWeapon] != 7)
            {
                return SendErrorMessage(playerid, "Ban khong co cay Co Bi-a trong tay.");
            }
            if(pTemp[playerid][pAiming] != 1)
            {
                new Float:poolrot, Float:X, Float:Y, Float:Z, Float:Xa, Float:Ya, Float:Za, Float:x, Float:y;
                PoolInfo[pTemp[playerid][pPoolTable]][bCurrentShooter] = playerid;
                CueTimer[playerid] = SetTimerEx("Pool_Timer", 21, true, "ii", playerid, pTemp[playerid][pPoolTable]);
                GetPlayerPos(playerid, X, Y, Z);
                GetObjectPos(PoolInfo[pTemp[playerid][pPoolTable]][bBalls][0], Xa, Ya, Za);
                pTemp[playerid][pAiming] = 1;
                if(Is2DPointInRangeOfPoint(X, Y, Xa, Ya, 1.5) && Z < 999.5)
                {
                    TogglePlayerControllable(playerid, 0);
                    GetAngleToXY(Xa, Ya, X, Y, poolrot);
                    SetPlayerFacingAngle(playerid, poolrot);
                    CueAimAngle[playerid][0] = poolrot;
                    CueAimAngle[playerid][1] = poolrot;
                    SetPlayerArmedWeapon(playerid, 0);
                    GetXYInFrontOfPos(Xa, Ya, poolrot+180, x, y, 0.085);
                    AimObject[playerid] = CreateObject(3004, x, y, Za, 7.0, 0, poolrot+180);
                    GetXYBehindObjectInAngle(PoolInfo[pTemp[playerid][pPoolTable]][bBalls][0], poolrot, x, y, 0.675);
                    SetPlayerCameraPos(playerid, x, y, Za+0.28);
                    SetPlayerCameraLookAt(playerid, Xa, Ya, Za+0.170);
                    ApplyAnimation(playerid, "POOL", "POOL_Med_Start",50.0,0,0,0,1,1,1);
                    TextDrawShowForPlayer(playerid, PoolTD[0]);
                    TextDrawShowForPlayer(playerid, PoolTD[1]);
                    TextDrawTextSize(PoolTD[2], 501.0, 0.0);
                    TextDrawShowForPlayer(playerid, PoolTD[2]);
                    TextDrawShowForPlayer(playerid, PoolTD[3]);
                    CuePower[playerid] = 1.0;
                    PoolDir[playerid] = 0;
                }
            }   
            else
            {
                TogglePlayerControllable(playerid, 1);
                ApplyAnimation(playerid, "CARRY", "crry_prtial", 1.0, 0, 0, 0, 0, 0, 1);
                SetCameraBehindPlayer(playerid);
                DestroyObject(AimObject[playerid]);
                TextDrawHideForPlayer(playerid, PoolTD[0]);
                TextDrawHideForPlayer(playerid, PoolTD[1]);
                TextDrawHideForPlayer(playerid, PoolTD[2]);
                TextDrawHideForPlayer(playerid, PoolTD[3]);
                pTemp[playerid][pAiming] = 0;
                PoolInfo[pTemp[playerid][pPoolTable]][bCurrentShooter] = -1;
                KillTimer(CueTimer[playerid]);
            }
		}
        if (IsKeyJustUp(KEY_FIRE, newkeys, oldkeys))
		{
            if (PlayerInfo[playerid][pPlayerWeapon] != 7)
            {
                return SendErrorMessage(playerid, "Ban khong co cay Co Bi-a trong tay.");
            }
            if(pTemp[playerid][pAiming])
            {
                if(pTemp[playerid][pAiming] == 1)
                {
                    pTemp[playerid][pAiming] = 0;
                }
                new Float:speed;
                ApplyAnimation(playerid, "POOL", "POOL_Med_Shot",3.0,0,0,0,0,0,1);
                speed = 0.4 + (CuePower[playerid] * 2.0) / 100.0;
                PHY_SetObjectVelocity(PoolInfo[pTemp[playerid][pPoolTable]][bBalls][0], speed * floatsin(-CueAimAngle[playerid][0], degrees), speed * floatcos(-CueAimAngle[playerid][0], degrees));
                TogglePlayerControllable(playerid, 1);
                PoolInfo[pTemp[playerid][pPoolTable]][bLastShooter] = playerid;
                PoolInfo[pTemp[playerid][pPoolTable]][bCurrentShooter] = -1;
                SetCameraBehindPlayer(playerid);
                ClearAnimations(playerid, 1);
                DestroyObject(AimObject[playerid]);
                TextDrawHideForPlayer(playerid, PoolTD[0]);
                TextDrawHideForPlayer(playerid, PoolTD[1]);
                TextDrawHideForPlayer(playerid, PoolTD[2]);
                TextDrawHideForPlayer(playerid, PoolTD[3]);
                KillTimer(CueTimer[playerid]);
            }
        }
	}
	return 1;
}

Pool_OnGamemodeInit()
{
    mysql_tquery(dbHandle, "SELECT * FROM `pooltables`", "LoadPoolTables");
    
    PoolTD[0] = TextDrawCreate(505.000000, 260.000000, "~n~~n~");
	TextDrawBackgroundColor(PoolTD[0], 255);
	TextDrawFont(PoolTD[0], 1);
	TextDrawLetterSize(PoolTD[0], 0.500000, 0.439999);
	TextDrawColor(PoolTD[0], -1);
	TextDrawSetOutline(PoolTD[0], 0);
	TextDrawSetProportional(PoolTD[0], 1);
	TextDrawSetShadow(PoolTD[0], 1);
	TextDrawUseBox(PoolTD[0], 1);
	TextDrawBoxColor(PoolTD[0], 255);
	TextDrawTextSize(PoolTD[0], 569.000000, -10.000000);

	PoolTD[1] = TextDrawCreate(506.000000, 261.000000, "~n~~n~");
	TextDrawBackgroundColor(PoolTD[1], 255);
	TextDrawFont(PoolTD[1], 1);
	TextDrawLetterSize(PoolTD[1], 0.500000, 0.300000);
	TextDrawColor(PoolTD[1], -1);
	TextDrawSetOutline(PoolTD[1], 0);
	TextDrawSetProportional(PoolTD[1], 1);
	TextDrawSetShadow(PoolTD[1], 1);
	TextDrawUseBox(PoolTD[1], 1);
	TextDrawBoxColor(PoolTD[1], 911303167);
	TextDrawTextSize(PoolTD[1], 568.000000, 0.000000);

	PoolTD[2] = TextDrawCreate(506.000000, 261.000000, "~n~~n~");
	TextDrawBackgroundColor(PoolTD[2], 255);
	TextDrawFont(PoolTD[2], 1);
	TextDrawLetterSize(PoolTD[2], 0.500000, 0.300000);
	TextDrawColor(PoolTD[2], -1);
	TextDrawSetOutline(PoolTD[2], 0);
	TextDrawSetProportional(PoolTD[2], 1);
	TextDrawSetShadow(PoolTD[2], 1);
	TextDrawUseBox(PoolTD[2], 1);
	TextDrawBoxColor(PoolTD[2], -1949699841);
	TextDrawTextSize(PoolTD[2], 501.000000, 0.000000);

	PoolTD[3] = TextDrawCreate(503.000000, 240.000000, "Power");
	TextDrawBackgroundColor(PoolTD[3], 255);
	TextDrawFont(PoolTD[3], 2);
	TextDrawLetterSize(PoolTD[3], 0.280000, 1.699999);
	TextDrawColor(PoolTD[3], -1);
	TextDrawSetOutline(PoolTD[3], 1);
	TextDrawSetProportional(PoolTD[3], 1);
    return 1;
}