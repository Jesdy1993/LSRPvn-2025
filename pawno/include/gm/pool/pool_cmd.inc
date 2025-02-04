CMD:apool(playerid, params[])
{
	new Float:x, Float:y, Float:z, option[16], secoption[128], poolid = -1;

	if (!CheckAdmin(playerid, ADMIN_LEVEL_3))				return SendNotAdmin(playerid);
	if (sscanf(params, "s[16]S()[128]", option, secoption)) return SendHelpMessage(playerid, "/apool [create / remove / goto]");

	if (CompareStrings(option, "create"))
	{
	    if ((poolid = GetNextPoolTableID()) == -1) return SendErrorMessage(playerid, "Dat den so luong ban choi chung toi da.");

		GetXYInFrontOfPlayer(playerid, x, y, z, 1.5);
		//PoolInfo[poolid][bID] = poolid + 1;
		PoolInfo[poolid][bPosX] = x;
		PoolInfo[poolid][bPosY] = y;
		PoolInfo[poolid][bPosZ] = z;
		PoolInfo[poolid][bUsed] = 0;
		PoolInfo[poolid][bPlayer1] = -1;
		PoolInfo[poolid][bPlayer2] = -1;
		PoolInfo[poolid][bLastShooter] = -1;
		PoolInfo[poolid][bCurrentShooter] = -1;
		PoolInfo[poolid][bInterior] = GetInterior(playerid);
		PoolInfo[poolid][bWorld] = GetWorld(playerid);
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

		// table object
		PoolInfo[poolid][bTable] = CreateDynamicObject(2964, x, y, z -1 , 0, 0, 0, PoolInfo[poolid][bWorld], PoolInfo[poolid][bInterior]);

		PHY_CreateArea(x - 1.000, y - 0.500, x + 1.000, y + 0.500,0.6, FLOAT_NEG_INFINITY);
		AddPoolTableToFile(poolid, x, y, z, PoolInfo[poolid][bInterior], PoolInfo[poolid][bWorld]);
		
		SendAdmMessageToPlayer(playerid, "Ban da tao mot ban bi-a [ID: %i].", poolid);
	}
	if (CompareStrings(option, "remove"))
	{
		new query[128];
		if ((poolid = GetNearestPoolTable(playerid)) == -1)
		{
			return SendErrorMessage(playerid, "Khong co ban Bi-a gan ban.");
		}
		
		if(PoolInfo[poolid][bUsed])
		{
			if(PoolInfo[poolid][bPlayer1] != -1)
			{
				pTemp[PoolInfo[poolid][bPlayer1]][pPoolTable] = -1;
				pTemp[PoolInfo[poolid][bPlayer1]][pPlayingPool] = 0;
				SendNoteMessage(PoolInfo[poolid][bPlayer1], "Quan tri vien xoa ban bi-a ma ban dang choi.");
			}
			if(PoolInfo[poolid][bPlayer2] != -1)
			{
				pTemp[PoolInfo[poolid][bPlayer2]][pPoolTable] = -1;
				pTemp[PoolInfo[poolid][bPlayer2]][pPlayingPool] = 0;
				SendNoteMessage(PoolInfo[poolid][bPlayer2], "Quan tri vien xoa ban bi-a ma ban dang choi.");
			}
		}
		for (new i = 0; i < 16; i++) 
		{
            DestroyObject(PoolInfo[poolid][bBalls][i]);
			DestroyDynamicObject(PoolInfo[poolid][bTable]);
        }

		mysql_format(dbHandle, query, sizeof(query), "DELETE FROM `pooltables` WHERE `id` = %i", PoolInfo[poolid][bID]);
		mysql_tquery(dbHandle, query);

		PoolInfo[poolid][bID] = 
		SendSyntaxMessage(playerid, "Ban da xoa ban bi-a [ID: %i].", poolid);
	}
	if(CompareStrings(option, "goto"))
	{
		new id;

		if (sscanf(secoption, "i", id))								return SendHelpMessage(playerid, "/apool goto [Pool Table ID]");
		if (id < 0 || id > MAX_POOL)								return SendErrorMessage(playerid, "Khong tim thay Ban Bi-a.");

		SetPlayerPosEx(playerid, PoolInfo[id][bPosX], PoolInfo[id][bPosY], PoolInfo[id][bPosZ]);
		SetWorld(playerid, PoolInfo[id][bWorld]);
		SetInterior(playerid, PoolInfo[id][bInterior]);
	}
	return 1;
}

CMD:leavepooltable(playerid, params[])
{
	new poolid = pTemp[playerid][pPoolTable];
	if (pTemp[playerid][pPlayingPool] == 0)
	{
		return SendErrorMessage(playerid, "Ban khong co choi Bi-a.");
	}
	if(PoolInfo[poolid][bPlayer1] == playerid)
	{
		PoolInfo[poolid][bPlayer1] = -1;
		pTemp[playerid][pPoolTable] = -1;
		pTemp[playerid][pPlayingPool] = 0;
		PoolInfo[poolid][bUsed] = 0;
		SendNoteMessage(playerid, "Ban da roi khoi tro choi Bi-a");
		SetPlayerArmedWeapon(playerid, 0);
		RespawnPoolBalls(poolid);
	}
	if(PoolInfo[poolid][bPlayer2] == playerid)
	{
		PoolInfo[poolid][bPlayer2] = -1;
		pTemp[playerid][pPoolTable] = -1;
		pTemp[playerid][pPlayingPool] = 0;
		PoolInfo[poolid][bUsed] = 0;
		SendNoteMessage(playerid, "Ban da roi khoi tro choi Bi-a");
		SetPlayerArmedWeapon(playerid, 0);
		RespawnPoolBalls(poolid);
	}
	return 1;
}

CMD:playpool(playerid, params[])
{
	new poolid, option[128], secoption[128];
	if (sscanf(params, "s[16]S()[128]", option, secoption))
	{
		return SendHelpMessage(playerid, "/playpool [solo / multiplayer]");
	}
	if (CompareStrings(option, "solo"))
	{
		if ((poolid = GetNearestPoolTable(playerid)) == -1)
		{
			return SendErrorMessage(playerid, "Khong co ban bi-a gan ban.");
		}
		if (pTemp[playerid][pPlayingPool] != 0)
		{
			return SendErrorMessage(playerid, "Ban dang choi tren ban bi-a nay hoac tren ban bi-a khac.");
		}
		if(PoolInfo[poolid][bUsed] == 1)
		{
			return SendErrorMessage(playerid, "Ban bi-a nay duoc ai do su dung.");
		} 
		if (PlayerInfo[playerid][pPlayerWeapon] != 7)
		{
			return SendErrorMessage(playerid, "Ban khong co cay Co Bi-a trong tay.");
		}


		pTemp[playerid][pPoolTable] = poolid;
		pTemp[playerid][pPlayingPool] = 1;
		PoolInfo[poolid][bPlayer1] = playerid;
		PoolInfo[poolid][bUsed] = 1;
		PlayerPlaySound(playerid, 1085, 0.0, 0.0, 0.0);

		for(new i; i < 16; i++)
		{
			PHY_InitObject(PoolInfo[poolid][bBalls][i], 3003, _, _, PHY_MODE_2D);
			PHY_SetObjectFriction(PoolInfo[poolid][bBalls][i], 0.08);
			PHY_RollObject(PoolInfo[poolid][bBalls][i]);
		}
		return 1;
	}
	if (CompareStrings(option, "multiplayer"))
	{
		new userid;
		if (sscanf(secoption, "i", userid))
		{
			return SendHelpMessage(playerid, "/playpool multiplayer [ID Nguoi choi 2]");
		}
		if ((poolid = GetNearestPoolTable(playerid)) == -1)
		{
			return SendErrorMessage(playerid, "Khong co ban bi-a gan ban.");
		}
		if (pTemp[playerid][pPlayingPool] != 0)
		{
			return SendErrorMessage(playerid, "Ban dang choi tren ban bi-a nay hoac tren ban bi-a khac.");
		}
		if (pTemp[playerid][pPlayingPool] != 0)
		{
			return SendErrorMessage(playerid, "Ban dang choi tren ban bi-a nay hoac tren ban bi-a khac.");
		}
		if (!IsPlayerConnected(userid)) 
		{
			return SendErrorMessage(playerid, "Nguoi choi da ngoai tuyen."); 
		}           	 
		if (!PlayerNearPlayer(2.0, playerid, userid))
		{
			return SendNotNearPlayer(playerid);
		}
		if(PoolInfo[poolid][bUsed] == 1)
		{
			return SendErrorMessage(playerid, "Ban bi-a nay duoc ai do su dung.");
		}
		if (PlayerInfo[playerid][pPlayerWeapon] != 7)
		{
			return SendErrorMessage(playerid, "Ban khong co cay Co Bi-a trong tay.");
		}
		if (PlayerInfo[userid][pPlayerWeapon] != 7)
		{
			return SendErrorMessage(playerid, "Nguoi choi do khong co cay Co Bi-a trong tay.");
		}

		PoolInfo[poolid][bPlayer1] = playerid;
		PoolInfo[poolid][bPlayer2] = userid;

		pTemp[playerid][pPoolTable] = poolid;
		pTemp[playerid][pPlayingPool] = 1;

		pTemp[userid][pPoolTable] = poolid;
		pTemp[userid][pPlayingPool] = 1;

		PlayerPlaySound(playerid, 1085, 0.0, 0.0, 0.0);

		PlayerPlaySound(userid, 1085, 0.0, 0.0, 0.0);

		SendNoteMessage(playerid, "Ban da moi %s tham gia Ban Bi-a voi ban.", GetNameEx(userid));
		SendNoteMessage(userid, "Ban da duoc %s moi tham gia Ban Bi-a voi ho.", GetNameEx(playerid));

		for(new i; i < 16; i++)
		{
			PHY_InitObject(PoolInfo[poolid][bBalls][i], 3003, _, _, PHY_MODE_2D); // Notice that I typed modelid 3003 because all the balls are equal.
			PHY_SetObjectFriction(PoolInfo[poolid][bBalls][i], 0.08);
			PHY_RollObject(PoolInfo[poolid][bBalls][i]);
		}
		return 1;
	}
	return 1;
}