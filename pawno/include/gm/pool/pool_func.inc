this::LoadPoolTables()
{
	new rows = cache_num_rows(), time = GetTickCount(), total;

	if (!rows) return print("[Pool Table] Khong co du lieu duoc tim thay.");
	    

	for(new i; i < rows; i++)
	{
		PoolInfo[i][bID] = cache_get_field_content_int(i, "id");
		PoolInfo[i][bPosX] = cache_get_field_content_float(i, "posx");
		PoolInfo[i][bPosY] = cache_get_field_content_float(i, "posy");
		PoolInfo[i][bPosZ] = cache_get_field_content_float(i, "posz");
		PoolInfo[i][bInterior] = cache_get_field_content_int(i, "interior");
		PoolInfo[i][bWorld] = cache_get_field_content_int(i, "world");
        PoolInfo[i][bUsed] = 0;
		PoolInfo[i][bPlayer1] = -1;
		PoolInfo[i][bPlayer2] = -1;
		PoolInfo[i][bLastShooter] = -1;
		PoolInfo[i][bCurrentShooter] = -1;

        PoolInfo[i][bBalls][0] = CreateObject(3003, PoolInfo[i][bPosX] + 0.5,  PoolInfo[i][bPosY],         PoolInfo[i][bPosZ] -0.045 , 0, 0, 0);
		PoolInfo[i][bBalls][1] = CreateObject(3002, PoolInfo[i][bPosX] - 0.3,   PoolInfo[i][bPosY],         PoolInfo[i][bPosZ] -0.045 , 0, 0, 0);
		PoolInfo[i][bBalls][2] = CreateObject(3100, PoolInfo[i][bPosX] - 0.525, PoolInfo[i][bPosY] - 0.040, PoolInfo[i][bPosZ] -0.045 , 0, 0, 0);
		PoolInfo[i][bBalls][3] = CreateObject(3101, PoolInfo[i][bPosX] - 0.375, PoolInfo[i][bPosY] + 0.044, PoolInfo[i][bPosZ] -0.045 , 0, 0, 0);
		PoolInfo[i][bBalls][4] = CreateObject(3102, PoolInfo[i][bPosX] - 0.600, PoolInfo[i][bPosY] + 0.079, PoolInfo[i][bPosZ] -0.045 , 0, 0, 0);
		PoolInfo[i][bBalls][5] = CreateObject(3103, PoolInfo[i][bPosX] - 0.525, PoolInfo[i][bPosY] + 0.118, PoolInfo[i][bPosZ] -0.045 , 0, 0, 0);
		PoolInfo[i][bBalls][6] = CreateObject(3104, PoolInfo[i][bPosX] - 0.600, PoolInfo[i][bPosY] - 0.157, PoolInfo[i][bPosZ] -0.045 , 0, 0, 0);
		PoolInfo[i][bBalls][7] = CreateObject(3105, PoolInfo[i][bPosX] - 0.450, PoolInfo[i][bPosY] - 0.079, PoolInfo[i][bPosZ] -0.045 , 0, 0, 0);
		PoolInfo[i][bBalls][8] = CreateObject(3106, PoolInfo[i][bPosX] - 0.450, PoolInfo[i][bPosY],         PoolInfo[i][bPosZ] -0.045 , 0, 0, 0);
		PoolInfo[i][bBalls][9] = CreateObject(2995, PoolInfo[i][bPosX] - 0.375, PoolInfo[i][bPosY] - 0.044, PoolInfo[i][bPosZ] -0.045 , 0, 0, 0);
		PoolInfo[i][bBalls][10] = CreateObject(2996, PoolInfo[i][bPosX] - 0.450, PoolInfo[i][bPosY] + 0.079, PoolInfo[i][bPosZ] -0.045 , 0, 0, 0);
		PoolInfo[i][bBalls][11] = CreateObject(2997, PoolInfo[i][bPosX] - 0.525, PoolInfo[i][bPosY] - 0.118, PoolInfo[i][bPosZ] -0.045 , 0, 0, 0);
		PoolInfo[i][bBalls][12] = CreateObject(2998, PoolInfo[i][bPosX] - 0.600, PoolInfo[i][bPosY] - 0.079, PoolInfo[i][bPosZ] -0.045 , 0, 0, 0);
		PoolInfo[i][bBalls][13] = CreateObject(2999, PoolInfo[i][bPosX] - 0.600, PoolInfo[i][bPosY],         PoolInfo[i][bPosZ] -0.045 , 0, 0, 0);
		PoolInfo[i][bBalls][14] = CreateObject(3000, PoolInfo[i][bPosX] - 0.600, PoolInfo[i][bPosY] + 0.157, PoolInfo[i][bPosZ] -0.045 , 0, 0, 0);
		PoolInfo[i][bBalls][15] = CreateObject(3001, PoolInfo[i][bPosX] - 0.525, PoolInfo[i][bPosY] + 0.040, PoolInfo[i][bPosZ] -0.045 , 0, 0, 0);

        PoolInfo[i][bTable] = CreateDynamicObject(2964, PoolInfo[i][bPosX], PoolInfo[i][bPosY], PoolInfo[i][bPosZ] -1, 0, 0, 0, PoolInfo[i][bWorld], PoolInfo[i][bInterior]);
        PHY_CreateArea(PoolInfo[i][bPosX] - 1.000, PoolInfo[i][bPosY] - 0.500, PoolInfo[i][bPosX] + 1.000, PoolInfo[i][bPosY] + 0.500,0.6, FLOAT_NEG_INFINITY);
		total++;
	}

	printf("[Pool Tables] Rows - %i. Load - %i. Time: %i ms.", rows, total, GetTickCount()-time);
	return 1;
}

public PHY_OnObjectCollideWithPlayer(objectid, playerid)
{
    if(pTemp[playerid][pPlayingPool] != 0)
    {
        for(new i; i < MAX_POOL; i++)
        {
            for(new j; j < 16; j++)
            {
                if(objectid == PoolInfo[i][bBalls][j]) return 0;
            }
        }
    }
    return 1;
}

public PHY_OnObjectUpdate(objectid, playerid)
{
    if(pTemp[playerid][pPlayingPool] != 0)
    {
        new poolid = pTemp[playerid][pPoolTable];
        if( IsInBall(objectid , PoolInfo[poolid][bPosX] + 0.955, PoolInfo[poolid][bPosY] + 0.510, PoolInfo[poolid][bPosZ] -0.045,0.10) ||
            IsInBall(objectid , PoolInfo[poolid][bPosX] + 0.955, PoolInfo[poolid][bPosY] - 0.510, PoolInfo[poolid][bPosZ] -0.045,0.10) ||
            IsInBall(objectid , PoolInfo[poolid][bPosX] + 0.000, PoolInfo[poolid][bPosY] + 0.550, PoolInfo[poolid][bPosZ] -0.045,0.10) ||
            IsInBall(objectid , PoolInfo[poolid][bPosX] + 0.000, PoolInfo[poolid][bPosY] - 0.550, PoolInfo[poolid][bPosZ] -0.045,0.10) ||
            IsInBall(objectid , PoolInfo[poolid][bPosX] - 0.955, PoolInfo[poolid][bPosY] + 0.510, PoolInfo[poolid][bPosZ] -0.045,0.10) ||
            IsInBall(objectid , PoolInfo[poolid][bPosX] - 0.955, PoolInfo[poolid][bPosY] - 0.510, PoolInfo[poolid][bPosZ] -0.045,0.10))
        { 
            if(objectid == PoolInfo[poolid][bBalls][0])
            {
                DestroyObject(PoolInfo[poolid][bBalls][0]);
                PHY_DeleteObject(PoolInfo[poolid][bBalls][0]);
                PoolInfo[poolid][bBalls][0] = CreateObject(3003, PoolInfo[poolid][bPosX] + 0.5,  PoolInfo[poolid][bPosY], PoolInfo[poolid][bPosZ] -0.045 , 0, 0, 0);
                //SetObjectPos(PoolInfo[poolid][bBalls][0], PoolInfo[poolid][bPosX] + 0.5, PoolInfo[poolid][bPosY], PoolInfo[poolid][bPosZ] -0.045);
                PHY_InitObject(PoolInfo[poolid][bBalls][0], 3003, _, _, PHY_MODE_2D); // Notice that I typed modelid 3003 because all the balls are equal.
                PHY_SetObjectFriction(PoolInfo[poolid][bBalls][0], 0.08);
                PHY_RollObject(PoolInfo[poolid][bBalls][0]);
                SendNearbyMessage(4.0, playerid, COLOR_SERVER2, "THONG TIN:{FFFFFF} Ban hong! %s da dat bi cai.", GetNameEx(PoolInfo[poolid][bLastShooter]));
            }
            if(objectid == PoolInfo[poolid][bBalls][1])
            {
                SendNearbyMessage(4.0, playerid, COLOR_SERVER2, "THONG TIN:{FFFFFF} %s da bo qua bong ran 1.", GetNameEx(PoolInfo[poolid][bLastShooter]));
                DestroyObject(PoolInfo[poolid][bBalls][1]);
                PHY_DeleteObject(PoolInfo[poolid][bBalls][1]);
            }
            if(objectid == PoolInfo[poolid][bBalls][2])
            {
                SendNearbyMessage(4.0, playerid, COLOR_SERVER2, "THONG TIN:{FFFFFF} %s da bo qua bong ran 2.", GetNameEx(PoolInfo[poolid][bLastShooter]));
                DestroyObject(PoolInfo[poolid][bBalls][2]);
                PHY_DeleteObject(PoolInfo[poolid][bBalls][2]);
            }
            if(objectid == PoolInfo[poolid][bBalls][3])
            {
                SendNearbyMessage(4.0, playerid, COLOR_SERVER2, "THONG TIN:{FFFFFF} %s da bo qua bong ran 3.", GetNameEx(PoolInfo[poolid][bLastShooter]));
                DestroyObject(PoolInfo[poolid][bBalls][3]);
                PHY_DeleteObject(PoolInfo[poolid][bBalls][3]);
            }
            if(objectid == PoolInfo[poolid][bBalls][4])
            {
                SendNearbyMessage(4.0, playerid, COLOR_SERVER2, "THONG TIN:{FFFFFF} %s da bo qua bong ran 4.", GetNameEx(PoolInfo[poolid][bLastShooter]));
                DestroyObject(PoolInfo[poolid][bBalls][4]);
                PHY_DeleteObject(PoolInfo[poolid][bBalls][4]);
            }
            if(objectid == PoolInfo[poolid][bBalls][5])
            {
                SendNearbyMessage(4.0, playerid, COLOR_SERVER2, "THONG TIN:{FFFFFF} %s da bo qua bong ran 5.", GetNameEx(PoolInfo[poolid][bLastShooter]));
                DestroyObject(PoolInfo[poolid][bBalls][5]);
                PHY_DeleteObject(PoolInfo[poolid][bBalls][5]);
            }
            if(objectid == PoolInfo[poolid][bBalls][6])
            {
                SendNearbyMessage(4.0, playerid, COLOR_SERVER2, "THONG TIN:{FFFFFF} %s da bo qua bong ran 6.", GetNameEx(PoolInfo[poolid][bLastShooter]));
                DestroyObject(PoolInfo[poolid][bBalls][6]);
                PHY_DeleteObject(PoolInfo[poolid][bBalls][6]);
            }
            if(objectid == PoolInfo[poolid][bBalls][7])
            {
                SendNearbyMessage(4.0, playerid, COLOR_SERVER2, "THONG TIN:{FFFFFF} %s da bo qua bong ran 7.", GetNameEx(PoolInfo[poolid][bLastShooter]));
                DestroyObject(PoolInfo[poolid][bBalls][7]);
                PHY_DeleteObject(PoolInfo[poolid][bBalls][7]);
            }
            if(objectid == PoolInfo[poolid][bBalls][8])
            {
                SendNearbyMessage(4.0, playerid, COLOR_SERVER2, "THONG TIN:{FFFFFF} %s da bo qua bong ran 8.", GetNameEx(PoolInfo[poolid][bLastShooter]));
                DestroyObject(PoolInfo[poolid][bBalls][8]);
                PHY_DeleteObject(PoolInfo[poolid][bBalls][8]);
            }
            if(objectid == PoolInfo[poolid][bBalls][9])
            {
                SendNearbyMessage(4.0, playerid, COLOR_SERVER2, "THONG TIN:{FFFFFF} %s da bo qua bong soc 9.", GetNameEx(PoolInfo[poolid][bLastShooter]));
                DestroyObject(PoolInfo[poolid][bBalls][9]);
                PHY_DeleteObject(PoolInfo[poolid][bBalls][9]);
            }
            if(objectid == PoolInfo[poolid][bBalls][10])
            {
                SendNearbyMessage(4.0, playerid, COLOR_SERVER2, "THONG TIN:{FFFFFF} %s da bo qua bong soc 10.", GetNameEx(PoolInfo[poolid][bLastShooter]));
                DestroyObject(PoolInfo[poolid][bBalls][10]);
                PHY_DeleteObject(PoolInfo[poolid][bBalls][10]);
            }
            if(objectid == PoolInfo[poolid][bBalls][11])
            {
                SendNearbyMessage(4.0, playerid, COLOR_SERVER2, "THONG TIN:{FFFFFF} %s da bo qua bong soc 11.", GetNameEx(PoolInfo[poolid][bLastShooter]));
                DestroyObject(PoolInfo[poolid][bBalls][11]);
                PHY_DeleteObject(PoolInfo[poolid][bBalls][11]);
            }
            if(objectid == PoolInfo[poolid][bBalls][12])
            {
                SendNearbyMessage(4.0, playerid, COLOR_SERVER2, "THONG TIN:{FFFFFF} %s da bo qua bong soc 12.", GetNameEx(PoolInfo[poolid][bLastShooter]));
                DestroyObject(PoolInfo[poolid][bBalls][12]);
                PHY_DeleteObject(PoolInfo[poolid][bBalls][12]);
            }
            if(objectid == PoolInfo[poolid][bBalls][13])
            {
                SendNearbyMessage(4.0, playerid, COLOR_SERVER2, "THONG TIN:{FFFFFF} %s da bo qua bong soc 13.", GetNameEx(PoolInfo[poolid][bLastShooter]));
                DestroyObject(PoolInfo[poolid][bBalls][13]);
                PHY_DeleteObject(PoolInfo[poolid][bBalls][13]);
            }
            if(objectid == PoolInfo[poolid][bBalls][14])
            {
                SendNearbyMessage(4.0, playerid, COLOR_SERVER2, "THONG TIN:{FFFFFF} %s da bo qua bong soc 14.", GetNameEx(PoolInfo[poolid][bLastShooter]));
                DestroyObject(PoolInfo[poolid][bBalls][14]);
                PHY_DeleteObject(PoolInfo[poolid][bBalls][14]);
            }
            if(objectid == PoolInfo[poolid][bBalls][15])
            {
                SendNearbyMessage(4.0, playerid, COLOR_SERVER2, "THONG TIN:{FFFFFF} %s da bo qua bong soc 15.", GetNameEx(PoolInfo[poolid][bLastShooter]));
                DestroyObject(PoolInfo[poolid][bBalls][15]);
                PHY_DeleteObject(PoolInfo[poolid][bBalls][15]);
            }                  
        }
        return 1;
    }
    return 1;
}

GetNextPoolTableID()
{
	for(new i; i < MAX_POOL; i++)
	{
	    if (!PoolInfo[i][bID]) return i;
	}
	return -1;
}

GetNearestPoolTable(playerid, Float: radius = 2.0)
{
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
	
    for(new i = 0; i != MAX_POOL; i++)
    {
        if (IsPlayerInRangeOfPoint(playerid, radius, PoolInfo[i][bPosX], PoolInfo[i][bPosY], PoolInfo[i][bPosZ]))
        {
			return i;
        }
    }
    return -1;
}

Float:GetPointDistanceToPoint(Float:x1,Float:y1,Float:x2,Float:y2)
{
    new Float:x, Float:y;
    x = x1-x2;
    y = y1-y2;
    return floatsqroot(x*x+y*y);
}

stock IsInBall(objectid,Float:x,Float:y,Float:z,Float:radius){

    new
        Float:pos[3],
        Float:dis;
        
    GetObjectPos(objectid, pos[0], pos[1], pos[2]);
    
    dis = floatsqroot(floatpower(floatabs(floatsub(x, pos[0] )), 2)+ floatpower(floatabs(floatsub(y, pos[1] )), 2)+ floatpower(floatabs(floatsub(z, pos[2] )), 2));
    
    if(dis < radius) return 1;
    return 0;
}


stock IsKeyJustDown(key, newkeys, oldkeys)
{
    if((newkeys & key) && !(oldkeys & key)) return 1;
    return 0;
}

stock IsKeyJustUp(key, newkeys, oldkeys)
{
    if(!(newkeys & key) && (oldkeys & key)) return 1;
    return 0;
}

stock Is2DPointInRangeOfPoint(Float:x, Float:y, Float:x2, Float:y2, Float:range)
{
    x2 -= x;
    y2 -= y;
    return ((x2 * x2) + (y2 * y2)) < (range * range);
}

stock GetAngleToXY(Float:X, Float:Y, Float:CurrX, Float:CurrY, &Float:angle)
{
    angle = atan2(Y-CurrY, X-CurrX);
    angle = floatsub(angle, 90.0);
    if(angle < 0.0) angle = floatadd(angle, 360.0);
}

stock GetXYInFrontOfPos(Float:xx,Float:yy,Float:a, &Float:x2, &Float:y2, Float:distance)
{
    if(a>360)
	{
        a=a-360;
    }
    xx += (distance * floatsin(-a, degrees));
    yy += (distance * floatcos(-a, degrees));
    x2=xx;
    y2=yy;
}

stock GetXYBehindObjectInAngle(objectid, Float:a, &Float:x2, &Float:y2, Float:distance)
{
    new Float:z;
    GetObjectPos(objectid, x2, y2, z);

    x2 += (distance * floatsin(-a+180, degrees));
    y2 += (distance * floatcos(-a+180, degrees));
}

/*forward PlayPoolSound(soundid);
public PlayPoolSound(soundid)
{
	foreach(new i : Player)
	{
	    if(PlayingPool[i])
	    {
	        PlayerPlaySound(i, soundid, 0, 0, 0);
	    }
	}
	return 1;
}*/

stock AngleInRangeOfAngle(Float:a1, Float:a2, Float:range)
{
	a1 -= a2;
	if((a1 < range) && (a1 > -range)) return true;

	return false;
}

stock RespawnPoolBalls(poolid)
{
    new Float:x, Float:y, Float:z;
    for(new i; i < 16; i++)
	{
        DestroyObject(PoolInfo[poolid][bBalls][i]);
        PHY_DeleteObject(PoolInfo[poolid][bBalls][i]);
    }
    x = PoolInfo[poolid][bPosX];
    y = PoolInfo[poolid][bPosY];
    z = PoolInfo[poolid][bPosZ];
    PoolInfo[poolid][bBalls][0] = CreateObject(3003, x + 0.5,  y,         z -0.045 , 0, 0, 0);
    PoolInfo[poolid][bBalls][1] = CreateObject(3002, x - 0.3,   y,         z -0.045 , 0, 0, 0);
    PoolInfo[poolid][bBalls][2] = CreateObject(3100, x - 0.525, y - 0.040, z -0.045 , 0, 0, 0);
    PoolInfo[poolid][bBalls][3] = CreateObject(3101, x - 0.375, y + 0.044, z -0.045 , 0, 0, 0);
    PoolInfo[poolid][bBalls][4] = CreateObject(3102, x - 0.600, y + 0.079, z -0.045 , 0, 0, 0);
    PoolInfo[poolid][bBalls][5] = CreateObject(3103, x - 0.525, y + 0.118, z -0.045 , 0, 0, 0);
    PoolInfo[poolid][bBalls][6] = CreateObject(3104, x - 0.600, y - 0.157, z -0.045 , 0, 0, 0);
    PoolInfo[poolid][bBalls][7] = CreateObject(3105, x - 0.450, y - 0.079, z -0.045 , 0, 0, 0);
    PoolInfo[poolid][bBalls][8] = CreateObject(3106, x - 0.450, y,         z -0.045 , 0, 0, 0);
    PoolInfo[poolid][bBalls][9] = CreateObject(2995, x - 0.375, y - 0.044, z -0.045 , 0, 0, 0);
    PoolInfo[poolid][bBalls][10] = CreateObject(2996, x - 0.450, y + 0.079, z -0.045 , 0, 0, 0);
    PoolInfo[poolid][bBalls][11] = CreateObject(2997, x - 0.525, y - 0.118, z -0.045 , 0, 0, 0);
    PoolInfo[poolid][bBalls][12] = CreateObject(2998, x - 0.600, y - 0.079, z -0.045 , 0, 0, 0);
    PoolInfo[poolid][bBalls][13] = CreateObject(2999, x - 0.600, y,         z -0.045 , 0, 0, 0);
    PoolInfo[poolid][bBalls][14] = CreateObject(3000, x - 0.600, y + 0.157, z -0.045 , 0, 0, 0);
    PoolInfo[poolid][bBalls][15] = CreateObject(3001, x - 0.525, y + 0.040, z -0.045 , 0, 0, 0);
    return 1;
}


AddPoolTableToFile(poolid, Float:PosX, Float:PosY, Float:PosZ, interior, world)
{
    new query[128 + 128 + 128];
	mysql_format(dbHandle, query, sizeof(query), "INSERT INTO `pooltables` (posx, posy, posz, interior, world) VALUES (%f, %f, %f, %i, %i)",
	PosX, PosY, PosZ, interior, world);
	mysql_tquery(dbHandle, query, "OnPoolTableInsert", "d", poolid);
 	return 1;
}

this::OnPoolTableInsert(poolid)
{
	return PoolInfo[poolid][bID] = cache_insert_id();	
}

stock GetPoolBalls(poolid)
{
	new count;
	for(new i; i < 16; i++)
	{
		if(PoolInfo[poolid][bBalls][i] || i == 0) count++;
	}
	return count;
}