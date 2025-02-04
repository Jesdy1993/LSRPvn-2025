this::KickPlayer(playerid)
{
    if (GetPVarInt(playerid,"kicked") != 1)	return 1;
	
    DeletePVar(playerid,"kicked");
	Kick(playerid);
	return 1;
}

this::Float:GetPlayerDistanceFromPlayer(playerid, targetid)
{
	new Float:x, Float:y, Float:z;
	GetPlayerPos(targetid, x, y, z);
	return GetPlayerDistanceFromPoint(playerid, x, y, z);
}

PlayerEnterFreeze(playerid)
{
	FreezePlayer(playerid);
	SetTimerEx("PlayerEnterUnFreeze", 2500, false, "i", playerid);
	return 1;
}

this::PlayerEnterUnFreeze(playerid)
{
	UnFreezePlayer(playerid);
	return 1;
}

UnFreezePlayer(playerid)
{
	DeletePVar(playerid, "Freeze");
	TogglePlayerControllable(playerid, 1);
	return 1;
}

FreezePlayer(playerid)
{
	SetPVarInt(playerid, "Freeze", 1);
	TogglePlayerControllable(playerid, 0);
	return 1;
}

IsPlayerFreeze(playerid)
{
	if (GetPVarInt(playerid, "Freeze")) return 1;

	return 0;
}

SetPlayerSkinEx(playerid, skinid)
{
	PlayerInfo[playerid][pSkin] = skinid;
	SetSpawnInfoEx(playerid, 1642.2006, -2334.4751, -2.6797);
	return SetPlayerSkin(playerid, skinid);
}

Float:GetPlayerHealthEx(playerid)
{
	new Float:hp;
	AntiCheatGetHealth(playerid, hp);
	return hp;
}

SetPlayerSkill(playerid, type = 1)
{
	if (type == 1) { // ��
		SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL, 899);
		SetPlayerSkillLevel(playerid, WEAPONSKILL_MICRO_UZI, 1);
		SetPlayerSkillLevel(playerid, WEAPONSKILL_SPAS12_SHOTGUN, 1);
		SetPlayerSkillLevel(playerid, WEAPONSKILL_SAWNOFF_SHOTGUN, 1);
				
		SetPlayerSkillLevel(playerid, WEAPONSKILL_AK47, 999);
		SetPlayerSkillLevel(playerid, WEAPONSKILL_DESERT_EAGLE, 999);
		SetPlayerSkillLevel(playerid, WEAPONSKILL_SHOTGUN, 999);
		SetPlayerSkillLevel(playerid, WEAPONSKILL_M4, 999);
		SetPlayerSkillLevel(playerid, WEAPONSKILL_MP5, 999);
	} else if (type == 2) { // +-
		SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL, 200);
		SetPlayerSkillLevel(playerid, WEAPONSKILL_MICRO_UZI, 0);
		SetPlayerSkillLevel(playerid, WEAPONSKILL_SPAS12_SHOTGUN, 0);
		SetPlayerSkillLevel(playerid, WEAPONSKILL_SAWNOFF_SHOTGUN, 0);
				
		SetPlayerSkillLevel(playerid, WEAPONSKILL_AK47, 200);
		SetPlayerSkillLevel(playerid, WEAPONSKILL_DESERT_EAGLE, 200);
		SetPlayerSkillLevel(playerid, WEAPONSKILL_SHOTGUN, 200);
		SetPlayerSkillLevel(playerid, WEAPONSKILL_M4, 200);
		SetPlayerSkillLevel(playerid, WEAPONSKILL_MP5, 200);
	} else if (type == 3) { // �����
		SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL, 100);
		SetPlayerSkillLevel(playerid, WEAPONSKILL_MICRO_UZI, 0);
		SetPlayerSkillLevel(playerid, WEAPONSKILL_SPAS12_SHOTGUN, 0);
		SetPlayerSkillLevel(playerid, WEAPONSKILL_SAWNOFF_SHOTGUN, 0);
				
		SetPlayerSkillLevel(playerid, WEAPONSKILL_AK47, 50);
		SetPlayerSkillLevel(playerid, WEAPONSKILL_DESERT_EAGLE, 50);
		SetPlayerSkillLevel(playerid, WEAPONSKILL_SHOTGUN, 100);
		SetPlayerSkillLevel(playerid, WEAPONSKILL_M4, 50);
		SetPlayerSkillLevel(playerid, WEAPONSKILL_MP5, 50);
	}	
	return 1;
}

IsPlayerAFK(playerid)
{
	return (pTemp[playerid][pDarkAFK] > 5)?(1):(0);
}

IsPlayerInCube(playerid, Float:min_x, Float:min_y, Float:max_x, Float:max_y)
{
    new Float: x, Float: y, Float: z;

    GetPlayerPos(playerid, x, y, z);
    return ((x <= max_x && x >= min_x) && (y <= max_y && y >= min_y))?(1):(0);
}

IsValidPlayerName(const str[])
{
	if (!str[0] || str[0] == '\1') return 0;

	for (new i = 0, l = strlen(str); i != l; i ++) {
	    if ((str[i] >= '0' && str[i] <= '9') || (str[i] >= 'a' && str[i] <= 'z') || (str[i] >= 'A' && str[i] <= 'Z'))	continue;
		if (str[i] == '_' || str[i] == '$' || str[i] == '@' || str[i] == '[' || str[i] == ']')	continue;
		else return 0;
	}
	return 1;
}

SendPlayerToPlayer(playerid, targetid)
{
	new Float:x, Float:y, Float:z;
	new vehicleid = GetPlayerVehicleID(playerid);
	GetPlayerPos(targetid, x, y, z);

    if (GetInterior(targetid) || GetWorld(targetid))
	{
   		PlayerInfo[playerid][pLocationPos][0] = PlayerInfo[targetid][pLocationPos][0];
	    PlayerInfo[playerid][pLocationPos][1] = PlayerInfo[targetid][pLocationPos][0];
		PlayerInfo[playerid][pLocationPos][2] = PlayerInfo[targetid][pLocationPos][0];
	}
	
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
	    foreach(new i : Player)
	    {
	        if(IsPlayerInVehicle(i, vehicleid))
	        {
	            SetPlayerInterior(i, GetInterior(targetid));
	            SetPlayerVirtualWorld(i, GetWorld(targetid));
			}
	    }

        SetVehiclePos(vehicleid, x, y, z);
	    SetVehicleVirtualWorld(vehicleid, GetWorld(targetid));
	    LinkVehicleToInterior(vehicleid, GetInterior(targetid));
	}
	ResetPlayerWeaponsEx(playerid);
	SetPlayerPosEx(playerid, x + 1, y, z);
	SetInterior(playerid, GetInterior(targetid));
	SetWorld(playerid, GetWorld(targetid));
	pTemp[playerid][pHouseEntered] = pTemp[targetid][pHouseEntered];
	pTemp[playerid][pApartEntered] = pTemp[targetid][pApartEntered];
	pTemp[playerid][pBizEntered] = pTemp[targetid][pBizEntered];
	return 1;
}

ShowSettings(playerid)
{
	new text[128], string[1024];
	    
	switch(PlayerInfo[playerid][pWalk])//0
	{
	    case 0: format(text, sizeof(text), "Walking style (/walk)\t[Vo hieu hoa]\n");
		default: format(text, sizeof(text), "Walking style (/walk)\t[%i]\n", PlayerInfo[playerid][pWalk]);
	}
	strcat(string, text);
	
	switch(PlayerInfo[playerid][pTalk])//1
	{
	    case 0: format(text, sizeof(text), "Conversation style\t[Vo hieu hoa]\n");
		default: format(text, sizeof(text), "Conversation style\t[%i]\n", PlayerInfo[playerid][pTalk]);
	}
	strcat(string, text);
	
    format(text, sizeof(text), "Combat style\t[%s]\n", GetFightStyleName(playerid));//2
	strcat(string, text);
	
	format(text, sizeof(text), "Speedometer style\t[%i]\n", PlayerInfo[playerid][pHud]);//3
	strcat(string, text);

	switch(PlayerInfo[playerid][pSpawnType])//4
	{
	    case 0: format(text, sizeof(text), "Vi tri xuat hien\t[Tieu chuan]\n");
		case 1: format(text, sizeof(text), "Vi tri xuat hien\t[Ngoi nha #%i]\n", PlayerInfo[playerid][pSpawnPoint]);
		case 2: format(text, sizeof(text), "Vi tri xuat hien\t[To chuc]\n");
		case 3: format(text, sizeof(text), "Vi tri xuat hien\t[Loi ra cuoi cung]\n");
	}
	strcat(string, text);
	
	switch(PlayerInfo[playerid][pSettings] & togOOC)//5
	{
	    case 0: text = "Tro chuyen OOC\t[Hoat dong]\n";
		default: text = "Tro chuyen OOC\t[Vo hieu hoa]\n";
	}
	strcat(string, text);
	
	/*
	switch(PlayerInfo[playerid][pSettings] & togName)//6
	{
	    case 0: text = "Player nicknames\t[Hoat dong]\n";
		default: text = "Player nicknames\t[Vo hieu hoa]\n";
	}
	strcat(string, text); */
    
    switch(PlayerInfo[playerid][pSettings] & togAdv)//7
	{
	    case 0: text = "Quang cao\t[Hoat dong]\n";
		default: text = "Quang cao\t[Vo hieu hoa]\n";
	}
	strcat(string, text);
	
	switch(PlayerInfo[playerid][pSettings] & togJoin)//8
	{
	    case 0: text = "Thong tin dang nhap / dang xuat cua nguoi choi\t[Hoat dong]\n";
		default: text = "Thong tin dang nhap / dang xuat cua nguoi choi\t[Vo hieu hoa]\n";
	}
	strcat(string, text);
	
	switch(PlayerInfo[playerid][pSettings] & togGov)//9
	{
	    case 0: text = "Thong bao tu chinh phu (/gov)\t[Hoat dong]\n";
		default: text = "Thong bao tu chinh phu (/gov)\t[Vo hieu hoa]\n";
	}
	strcat(string, text);
	
	switch(PlayerInfo[playerid][pSettings] & togPM)//10
	{
	    case 0: text = "Tin nhan rieng tu\t[Hoat dong]\n";
		default: text = "Tin nhan rieng tu\t[Vo hieu hoa]\n";
	}
	strcat(string, text);
	
	switch(PlayerInfo[playerid][pSettings] & togAdmCmds)//11
	{
	    case 0: text = "Canh bao danh cho quan tri vien\t[Hoat dong]\n";
		default: text = "Canh bao danh cho quan tri vien\t[Vo hieu hoa]\n";
	}
	strcat(string, text);
	
	switch(PlayerInfo[playerid][pSettings] & togNews)//12
	{
	    case 0: text = "Tin tuc\t[Hoat dong]\n";
		default: text = "Tin tuc\t[Vo hieu hoa]\n";
	}
	strcat(string, text);

    switch(PlayerInfo[playerid][pSettings] & togAFK)//13
	{
	    case 0: text = "Hien thi thoi gian cho AFK\t[Hoat dong]\n";
		default: text = "Hien thi thoi gian cho AFK\t[Vo hieu hoa]\n";
	}
	strcat(string, text);
	
	switch(PlayerInfo[playerid][pSettings] & togHUD)//14
	{
	    case 0: text = "Hien thi HUD\t[Hoat dong]\n";
		default: text = "Hien thi HUD\t[Vo hieu hoa]\n";
	}
	strcat(string, text);

	switch(PlayerInfo[playerid][pSettings] & togFaction)//15
	{
	    case 0: text = "Tro chuyen to chuc\t[Hoat dong]\n";
		default: text = "Tro chuyen to chuc\t[Vo hieu hoa]\n";
	}
	strcat(string, text);
	
	switch(PlayerInfo[playerid][pSettings] & togEnter)//16
	{
	    case 0: text = "Vao / thoat voi phim F\t[Hoat dong]\n";
		default: text = "Vao / thoat voi phim F\t[Vo hieu hoa]\n";
	}
	strcat(string, text);
	
	switch(CompareStrings(PlayerInfo[playerid][pGoogle], "!"))//17
	{
	    case 0: text = "Google Authenticator\t[Hoat dong]\n";
		default: text = "Google Authenticator\t[Vo hieu hoa]\n";
	}
	strcat(string, text);
	
	strcat(string, "Thay doi mat khau");//18
	
	Dialog_Show(playerid, MainSettings, DIALOG_STYLE_TABLIST, "Cai Dat", string, "Chon", "Quay lai");
	return 1;
}

PlayerNearPlayer(Float:radi, playerid, targetid)
{
	new Float:fX, Float:fY, Float:fZ;
	GetPlayerPos(targetid, fX, fY, fZ);
	return (GetInterior(playerid) == GetInterior(targetid) && GetWorld(playerid) == GetWorld(targetid)) && IsPlayerInRangeOfPoint(playerid, radi, fX, fY, fZ);
}

SavePlayerPos(playerid)
{
	GetPlayerPos(playerid, PlayerInfo[playerid][pPosX],PlayerInfo[playerid][pPosY],PlayerInfo[playerid][pPosZ]);
	GetPlayerFacingAngle(playerid, PlayerInfo[playerid][pPosA]);
	PlayerInfo[playerid][pWorld] = GetWorld(playerid);
	PlayerInfo[playerid][pInt] = GetInterior(playerid);
	SetSpawnInfoEx(playerid, PlayerInfo[playerid][pPosX],PlayerInfo[playerid][pPosY],PlayerInfo[playerid][pPosZ]);
	return 1;
}

GiveCash(playerid, cash)
{
 	PlayerInfo[playerid][pCash] += cash;
	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid, PlayerInfo[playerid][pCash]);

	new __cash = cash;

	if (cash < 0)	cash = -cash;

    new mes[19];
	format(mes, sizeof(mes), "%s$%i", (__cash < 0)?("~r~-"):("~g~+"), cash);
	GameTextForPlayer(playerid, mes, 1000, 1);
	return 1;
}

SetCash(playerid, cash)
{
	PlayerInfo[playerid][pCash] = cash;
	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid, cash);
	return 1;
}

GetCash(playerid)
{
	return PlayerInfo[playerid][pCash];
}

SendClientMessageEx(playerid, color, const str[], {Float,_}:...)
{
	static args, start, end, string[144];
	#emit LOAD.S.pri 8
	#emit STOR.pri args

	if (args > 12)
	{
		#emit ADDR.pri str
		#emit STOR.pri start

	    for (end = start + (args - 12); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}
		#emit PUSH.S str
		#emit PUSH.C 144
		#emit PUSH.C string
		#emit PUSH.C args
		#emit SYSREQ.C format

		SendClientMessage(playerid, color, string);

		#emit LCTRL 5
		#emit SCTRL 4
		#emit RETN
	}
	return SendClientMessage(playerid, color, str);
}

stock SendClientMessageToAllEx(color, const str[], {Float,_}:...)
{
	static
	    args,
	    start,
	    end,
	    string[144]
	;
	#emit LOAD.S.pri 8
	#emit STOR.pri args

	if (args > 8)
	{
		#emit ADDR.pri str
		#emit STOR.pri start

	    for (end = start + (args - 8); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}
		#emit PUSH.S str
		#emit PUSH.C 144
		#emit PUSH.C string

		#emit LOAD.pri args
		#emit ADD.C 4
		#emit PUSH.pri
		#emit SYSREQ.C format

        #emit LCTRL 5
		#emit SCTRL 4

		foreach (new i : Player) {
			SendClientMessage(i, color, string);
		}
		return 1;
	}
	return SendClientMessageToAll(color, str);
} 

SendNearbyMessage(Float:radius, playerid, color, const str[], {Float,_}:...)
{
	static args, start, end, string[144];
	#emit LOAD.S.pri 8
	#emit STOR.pri args

	if (args > 16)
	{
		#emit ADDR.pri str
		#emit STOR.pri start

	    for (end = start + (args - 16); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}
		#emit PUSH.S str
		#emit PUSH.C 144
		#emit PUSH.C string

		#emit LOAD.S.pri 8
		#emit CONST.alt 4
		#emit SUB
		#emit PUSH.pri

		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4

        foreach (new i : Player)
		{
		    if (0 == IsPlayerLogged(i) || 0 == PlayerNearPlayer(radius, i, playerid)) continue;
			SendClientMessage(i, color, string);
		}
		return 1;
	}

	foreach (new i : Player)
	{
	    if (0 == IsPlayerLogged(i) || 0 == PlayerNearPlayer(radius, i, playerid)) continue;
		SendClientMessage(i, color, str);
	}
	return 1;
}

SendLocalMessage(Float:radius, playerid, col1, col2, col3, col4, col5, const str[], {Float,_}:...)
{
	static args, start, end, string[144];
	#emit LOAD.S.pri 8
	#emit STOR.pri args

	if (args > 16)
	{
		#emit ADDR.pri str
		#emit STOR.pri start

	    for (end = start + (args - 16); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}
		#emit PUSH.S str
		#emit PUSH.C 144
		#emit PUSH.C string

		#emit LOAD.S.pri 8
		#emit CONST.alt 4
		#emit SUB
		#emit PUSH.pri

		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4

        foreach (new i : Player)
		{
		    if (0 == IsPlayerLogged(i)) 							continue;
			if (PlayerNearPlayer(radius/16, i, playerid))		SendClientMessage(i, col1, string);
            else if (PlayerNearPlayer(radius/8, i, playerid))	SendClientMessage(i, col2, string);
            else if (PlayerNearPlayer(radius/4, i, playerid))	SendClientMessage(i, col3, string);
            else if (PlayerNearPlayer(radius/2, i, playerid))	SendClientMessage(i, col4, string);
            else if (PlayerNearPlayer(radius, i, playerid))		SendClientMessage(i, col5, string);
			//SetPlayerChatBubble(i, string, col5, 5, 5000);
		}
		return 1;
	}

	foreach (new i : Player)
	{
	    if (0 == IsPlayerLogged(i))							continue;
	    if (PlayerNearPlayer(radius/16, i, playerid))		SendClientMessage(i, col1, string);
		else if (PlayerNearPlayer(radius/8, i, playerid))	SendClientMessage(i, col2, string);
		else if (PlayerNearPlayer(radius/4, i, playerid))	SendClientMessage(i, col3, string);
		else if (PlayerNearPlayer(radius/2, i, playerid))	SendClientMessage(i, col4, string);
		else if (PlayerNearPlayer(radius, i, playerid))		SendClientMessage(i, col5, string);
		//SetPlayerChatBubble(i, string, col5, 5, 5000);
	}
	return 1;
}

SendPMToPlayer(playerid, targetid, text[])
{
    new pos = MAXLEN;
	if (pos < MAXLEN-1) pos = MAXLEN;

	if (strlen(text) > MAXLEN)
	{
		if (IsAdminDuty(playerid))	SendClientMessageEx(targetid, COLOR_PMIN, "(( PM tu {FF9A00}%s{FFDB18} (ID: %i): %.*s ... ))", GetName(playerid), playerid, pos, (text));
		else						SendClientMessageEx(targetid, COLOR_PMIN, "(( PM tu %s (ID: %i): %.*s ... ))", GetName(playerid), playerid, pos, (text));
		SendClientMessageEx(targetid, COLOR_PMIN, "(( ... %s ))", (text)[pos]);
		
		if (IsAdminDuty(targetid))	SendClientMessageEx(playerid, COLOR_PMOUT, "(( PM cho {FF9A00}%s{FFDB18} (ID: %i): %.*s ... ))", GetName(targetid), targetid, pos, (text));
		else						SendClientMessageEx(playerid, COLOR_PMOUT, "(( PM cho %s (ID: %i): %.*s ... ))", GetName(targetid), targetid, pos, (text));
		SendClientMessageEx(playerid, COLOR_PMOUT, "(( ... %s ))", (text)[pos]);
	}
	else
	{
	    if (IsAdminDuty(playerid)) 	SendClientMessageEx(targetid, COLOR_PMIN, "(( PM tu {FF9A00}%s{FFDB18} (ID: %i): %s ))", GetName(playerid), playerid, (text));
		else						SendClientMessageEx(targetid, COLOR_PMIN, "(( PM tu %s (ID: %i): %s ))", GetName(playerid), playerid, (text));
		if (IsAdminDuty(targetid))	SendClientMessageEx(playerid, COLOR_PMOUT, "(( PM cho {FF9A00}%s{FFDB18} (ID: %i): %s ))", GetName(targetid), targetid, (text));
		else						SendClientMessageEx(playerid, COLOR_PMOUT, "(( PM cho %s (ID: %i): %s ))", GetName(targetid), targetid, (text));
	}

	foreach(new i : Player)
	{
	    if (!IsPlayerLogged(i) || !IsAdminDuty(i) || (pTemp[i][pPMPlayer] != playerid && GetPVarInt(i, #spypm_all) != 1)) continue;

        if (strlen(text) > MAXLEN)
		{
			SendClientMessageEx(i, COLOR_PMIN, "(( PM spy %s cho %s (ID: %i): %.*s ... ))", GetName(playerid), GetName(targetid), targetid, pos, (text));
			SendClientMessageEx(i, COLOR_PMIN, "(( ... %s ))", (text)[pos]);
		}
		else
		{
			SendClientMessageEx(i, COLOR_PMIN, "(( PM spy %s cho %s (ID: %i): %s ))", GetName(playerid), GetName(targetid), targetid, text);
		}
	}
	return 1;
}

GetPlayer2DZone(playerid, zone[], len)
{
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);

	if (GetWorld(playerid) || GetInterior(playerid))
	{
		x = PlayerInfo[playerid][pLocationPos][0];
		y = PlayerInfo[playerid][pLocationPos][1];
		z = PlayerInfo[playerid][pLocationPos][2];
	}

	for(new i = 0; i != sizeof(gSAZones); i++)
	{
		if (x >= gSAZones[i][SAZONE_AREA][0] && x <= gSAZones[i][SAZONE_AREA][3] && y >= gSAZones[i][SAZONE_AREA][1] && y <= gSAZones[i][SAZONE_AREA][4]) return format(zone, len, gSAZones[i][SAZONE_NAME], 0);
	}
	return 0;
}

GetZone(Float:x, Float:y, zone[], len)
{
	for(new i = 0; i != sizeof(gSAZones); i++)
	{
		if (x >= gSAZones[i][SAZONE_AREA][0] && x <= gSAZones[i][SAZONE_AREA][3] && y >= gSAZones[i][SAZONE_AREA][1] && y <= gSAZones[i][SAZONE_AREA][4]) return format(zone, len, gSAZones[i][SAZONE_NAME], 0);
	}
	return format(zone, len, "Unknown");
}

ResetPlayerVariables(playerid)
{
    ResetDamages(playerid);
	for(new i = 0; i != MAX_CHARACTERS; i++)
	{
	    login_char_id[playerid][i] = 0;
	    format(login_char_name[playerid][i], MAX_PLAYER_NAME, "Trong");
	}

	maskOn{playerid} = false;
	RegisterClicked[playerid] = 0;
	JackingEngine[playerid] = 0;
	JackingLock[playerid] = 0;
	BreakingHouse[playerid] = 0;
	JackingVehicle[playerid] = 0;
	pickup_expire{playerid} = false;
	pTemp[playerid][pRegisterScreen] = 0;
	pTemp[playerid][pCharacterScreen] = 0;
	pTemp[playerid][pVehicleScreen] = 0;
	pTemp[playerid][pUsingPayphone] = 0;
	OnAnim{playerid} = false;

	Job_OnPlayerDisconnect(playerid);

	for(new i; i != MAX_PLAYERS; i++)
		people_blocking[playerid][i] = 0;

	for(new i = 0; i < MAX_PLAYER_CONTACTS; i++)
		PlayerContacts[playerid][i][contactOn] = 0;

	for(new i = 0; i < MAX_PLAYER_NOTES; i++)
		PlayerNotes[playerid][i][noteOn] = 0;

	for(new i; i != 30; i++)
		pTemp[playerid][pWeaponListed][i] = 0;

    for(new i; i != 5; i++)
		pTemp[playerid][pListed][i] = 0;
		
	for(new i = 0; i < MAX_INV_SLOTS; i++)
	{
		Inventory[playerid][i][pInvItem] = 0;
		Inventory[playerid][i][pInvItem] = 0;
		Inventory[playerid][i][pInvEx] = 0;
		Inventory[playerid][i][pInvQFloat] = 0;
		Inventory[playerid][i][pInvQ] = 0;
		Inventory[playerid][i][pInvName] = EOS;
	}

	pTemp[playerid][pChangeNick] = 0;
	pTemp[playerid][pCallName] = 0;
	pTemp[playerid][pGoogle] = EOS;

	pTemp[playerid][pPayphone] = -1;
	
	//pTemp[playerid][JackingVehID] = 
	pTemp[playerid][pUnscrambleID] = 0;
	pTemp[playerid][pScrambleFailed] = 0;
	pTemp[playerid][pScrambleSuccess] = 0;
	//pTemp[playerid][JackingCP] = 
	pTemp[playerid][JackingType] = 0;
	pTemp[playerid][JackingWarnings] = 0;
	pTemp[playerid][pPizzaBoy] = 0;
    pTemp[playerid][pDemolitionTime] = 0;
	pTemp[playerid][pDrugUse] = 0;
	pTemp[playerid][pDrugTime] = 0;
	pTemp[playerid][pDrugChgWeather] = 0;
	pTemp[playerid][tempItem] = 0;
	pTemp[playerid][tempEx] = 0;
	pTemp[playerid][tempQ] = 0;
	pTemp[playerid][pLicenseExam] = 0;
	pTemp[playerid][pTesterDuty] = 0;
    pTemp[playerid][pAdminDuty] = 0;
	pTemp[playerid][pServeType] = 0;
	pTemp[playerid][pGreetType] = 0;
	pTemp[playerid][pFoodStand] = 0;
	pTemp[playerid][pDMLog] = 0;
	pTemp[playerid][pNews] = 0;
	pTemp[playerid][pDarkAFK] = 0;
	pTemp[playerid][pCuffed] = 0;
	pTemp[playerid][pFireTime] = 0;
	pTemp[playerid][pPlantTime] = 0;
	pTemp[playerid][pPlantType] = 0;
    pTemp[playerid][pFishTime] = 0;
	pTemp[playerid][pPatrol] = 0;
    pTemp[playerid][pReportTime] = 0;
	pTemp[playerid][pLogged] = 0;
	pTemp[playerid][pLoggedTime] = 0;
	pTemp[playerid][pLoggedTry] = 0;
	pTemp[playerid][pLoggedScreen] = 0;
	pTemp[playerid][pJob] = 0;
	pTemp[playerid][pJobTime] = 0;
	pTemp[playerid][pRentPrice] = 0;
	pTemp[playerid][pHousePrice] = 0; 
	pTemp[playerid][pCarPrice] = 0;
	pTemp[playerid][pTaser] = 0;
	pTemp[playerid][pTaserTime] = 0;
	pTemp[playerid][pFreezeTime] = 0;
	pTemp[playerid][pEditBort] = 0;
    pTemp[playerid][pCCTV] = 0;
	pTemp[playerid][pZond] = 0;
	pTemp[playerid][pDamagesCount] = 0;
	pTemp[playerid][pInjuredTime] = 0;
	pTemp[playerid][pInjuredLegTime] = 0;
	pTemp[playerid][pHelpUp3dText] = 0;
	pTemp[playerid][pFlashTime] =0;
	pTemp[playerid][pHealTime] = 0;
	pTemp[playerid][pBuildHouse] = 0;
	pTemp[playerid][pRamType] = 0;
    pTemp[playerid][pRamTime] = 0;
	pTemp[playerid][pCallStatus] = 0;
	pTemp[playerid][pCallIncoming] = 0;
	pTemp[playerid][pCallTime] = 0;
	pTemp[playerid][pWepPrice] = 0;
	PlayerInfo[playerid][pGanjaTime] = 0;
	PlayerInfo[playerid][pPrescribe] = 0;
	PlayerInfo[playerid][pDependence] = 0;
	PlayerInfo[playerid][pDemolition] = 0; 
	PlayerInfo[playerid][pID] = 0;
	PlayerInfo[playerid][pAccID] = 0;
	pTemp[playerid][pInteriorHouse] = 0;
	pTemp[playerid][pInteriorBiz] = 0;
	pTemp[playerid][pInteriorID] = 0;
	pTemp[playerid][pCargoID] = 0;
	pTemp[playerid][pCallOn] = 0;
	pTemp[playerid][pEmergency] = 0;
	pTemp[playerid][pPoliceCalls] = 0;
	pTemp[playerid][pPoliceJails] = 0;
	pTemp[playerid][pPoliceFines] = 0;
	pTemp[playerid][UsingBort] = 0;
	pTemp[playerid][UsingCorpse] = 0;
	pTemp[playerid][tempStatus] = 0;
	pTemp[playerid][pTraceStage] = 0;

	pTemp[playerid][pBoombox_house] = -1;
	pTemp[playerid][pBoombox_biz] = -1;
	pTemp[playerid][pBizEntered] = -1;
	pTemp[playerid][pApartEntered] = -1;
	pTemp[playerid][pHouseEntered] = -1;
	pTemp[playerid][pHouseHouse] = -1;
	pTemp[playerid][pFurniture] = -1;
	pTemp[playerid][pFurnitureB] = -1;
	pTemp[playerid][p3DMenu] = -1;
    pTemp[playerid][pRamHouse] = -1;
	pTemp[playerid][pRamVeh] = -1;
    pTemp[playerid][pRamGarage] = -1;
    pTemp[playerid][pRamBiz] = -1;
	pTemp[playerid][pTraceGZ] = -1;

	pTemp[playerid][pBizPrice] = 0;
	pTemp[playerid][pBizID] = INVALID_PLAYER_ID;

	pTemp[playerid][pBoombox] = 0;
	pTemp[playerid][pServePlayer] = INVALID_PLAYER_ID;
	pTemp[playerid][pGreetPlayer] = INVALID_PLAYER_ID;
	pTemp[playerid][pMDCPlayer] = INVALID_PLAYER_ID;
	pTemp[playerid][pWepPlayer] = INVALID_PLAYER_ID;
	pTemp[playerid][pRentPlayer] = INVALID_PLAYER_ID;
	pTemp[playerid][pPMPlayer] = INVALID_PLAYER_ID;
	pTemp[playerid][pHousePlayer] = INVALID_PLAYER_ID;
	pTemp[playerid][pInterview] = INVALID_PLAYER_ID;
	pTemp[playerid][pBizPlayer] = INVALID_PLAYER_ID;
	pTemp[playerid][pInterviewPlayer] = INVALID_PLAYER_ID;
	pTemp[playerid][pHealPlayer] = INVALID_PLAYER_ID;
	pTemp[playerid][pFactionPlayer] = INVALID_PLAYER_ID;
	pTemp[playerid][pFriskPlayer] = INVALID_PLAYER_ID;
	pTemp[playerid][pSpecPlayer] = INVALID_PLAYER_ID;
	pTemp[playerid][pHirePlayer] = INVALID_PLAYER_ID;
	pTemp[playerid][pCarPlayer] = INVALID_PLAYER_ID;
	pTemp[playerid][pCallLine] = INVALID_PLAYER_ID;
	pTemp[playerid][pTracePlayer] = INVALID_PLAYER_ID;

	pTemp[playerid][pDriver] = INVALID_VEHICLE_ID;
	pTemp[playerid][pZondActor] = INVALID_ACTOR_ID;
    pTemp[playerid][pRamObj] = INVALID_OBJECT_ID;

	for(new c = 0; c < 5; c++)
	{
		pTemp[playerid][MyCarSpawn][c] = 0;
		pTemp[playerid][MyCarSpawn][c] = 0;
	}

	for(new i = 0; i < MAX_WEAP-1; i++)	PlayerInfo[playerid][pHideWeap][i] = 0;

	PlayerInfo[playerid][pGoogle] = 0;
	PlayerInfo[playerid][pAccname] = 0;
	PlayerInfo[playerid][pBirthdate] = 0;
	PlayerInfo[playerid][pAdminCode] = EOS;

	PlayerInfo[playerid][pFishTime] = 0;
	PlayerInfo[playerid][pCarKey] = 0;
	PlayerInfo[playerid][pTog][0] = 0;
	PlayerInfo[playerid][pTog][1] = 0; 
	PlayerInfo[playerid][pTog][2] = 0; 
	PlayerInfo[playerid][pSwatDuty] = 0;
	PlayerInfo[playerid][pOnDuty] = 0;
	PlayerInfo[playerid][pCash] = 0;
	PlayerInfo[playerid][pBank] = 0;
	PlayerInfo[playerid][pSkin] = 0;
	PlayerInfo[playerid][pSex] = 0;
	PlayerInfo[playerid][pAge] = 0;
	PlayerInfo[playerid][pLevel] = 0;
	//PlayerInfo[playerid][pExp] = 0;
	PlayerInfo[playerid][pHours] = 0;
	PlayerInfo[playerid][pAdmin] = 0;
	PlayerInfo[playerid][pAdminHide] = 0;
	PlayerInfo[playerid][pHelper] = 0;
	PlayerInfo[playerid][pInt] = 0;
	PlayerInfo[playerid][pWorld] =0;
	PlayerInfo[playerid][pJailed] = 0;
	PlayerInfo[playerid][pIsolateTime] = 0;
	PlayerInfo[playerid][pJailTime] = 0;
	PlayerInfo[playerid][pWarns] = 0;
	PlayerInfo[playerid][pPremium] = 0;
	PlayerInfo[playerid][pPremiumTime] = 0;
	PlayerInfo[playerid][pNameChanges] = 0;
	PlayerInfo[playerid][pNumberChanges] = 0;
	PlayerInfo[playerid][pCarLic] = 0;
	PlayerInfo[playerid][pWepLic] = 0;
	PlayerInfo[playerid][pFlyLic] = 0;
	PlayerInfo[playerid][pTaxiLic] = 0;
	PlayerInfo[playerid][pInjured] = 0;
	PlayerInfo[playerid][pDeathReason] = 0;
	PlayerInfo[playerid][pFightStyle] = 0;
	PlayerInfo[playerid][pPayCheckMoney] = 0;
	PlayerInfo[playerid][pPayDayTime] = 0;
	PlayerInfo[playerid][pNumber] = 0;
	PlayerInfo[playerid][pSavings] = 0;
	PlayerInfo[playerid][pRentKey] = 0;
	PlayerInfo[playerid][pRentPrice] = 0;
	PlayerInfo[playerid][pChannel] = 0;
	PlayerInfo[playerid][pOwnedChannel] = 0;
	PlayerInfo[playerid][pAuthed] = 0;
	PlayerInfo[playerid][pSpareKey] =0;
	PlayerInfo[playerid][pWorkOn] = 0;
	PlayerInfo[playerid][pWalk] = 0;
	PlayerInfo[playerid][pFaction] = 0;
	PlayerInfo[playerid][pJob] = 0;
	PlayerInfo[playerid][pCareer] = 0;
	PlayerInfo[playerid][pRank] = 0;
	PlayerInfo[playerid][pBadgeNumber] = 0;
	PlayerInfo[playerid][pDriveWarns] = 0;
	PlayerInfo[playerid][pWepWarns] = 0;
	PlayerInfo[playerid][pWepCount] = 0;
	PlayerInfo[playerid][pArrested] = 0;
	PlayerInfo[playerid][pTalk] = 0;
	PlayerInfo[playerid][pSwat] = 0;
	PlayerInfo[playerid][pAuthwep] = 0;
	PlayerInfo[playerid][pSpawnType] = 0;
	PlayerInfo[playerid][pSpawnPoint] = 0;
	PlayerInfo[playerid][pPrisoned] = 0;
	PlayerInfo[playerid][pHud] = 0;

	pTemp[playerid][pInvulnerable] = 0;
	PlayerInfo[playerid][pPosX] = 0;
	PlayerInfo[playerid][pPosY] = 0;
	PlayerInfo[playerid][pPosZ] = 0;
	PlayerInfo[playerid][pPosA] = 0;
	PlayerInfo[playerid][pArmour] = 0.0;

    PlayerInfo[playerid][pFishRod] = 0;
	PlayerInfo[playerid][pBait] = 0;
    
	PlayerInfo[playerid][pSlot] = 1;

	pTemp[playerid][pPoolTable] = -1;
	pTemp[playerid][pPlayingPool] = 0;
	pTemp[playerid][pAiming] = 0;

	pTemp[playerid][pInHospitalBed] = 0;
	pTemp[playerid][pHospitalBed] = 0;

	PlayerInfo[playerid][pTutorial] = 0;

	//Tog
	PlayerInfo[playerid][pSettings] &= ~togService;
	PlayerInfo[playerid][pSettings] &= ~togName;
	PlayerInfo[playerid][pSettings] &= ~togOOC;
	PlayerInfo[playerid][pSettings] &= ~togJoin;
	PlayerInfo[playerid][pSettings] &= ~togAdv;
	PlayerInfo[playerid][pSettings] &= ~togGov;
	PlayerInfo[playerid][pSettings] &= ~togPM;
    PlayerInfo[playerid][pSettings] &= ~togAdmCmds;
    PlayerInfo[playerid][pSettings] &= ~togNews;
    PlayerInfo[playerid][pSettings] &= ~togAFK;
    PlayerInfo[playerid][pSettings] &= ~togHUD;
    PlayerInfo[playerid][pSettings] &= ~togFaction;
    PlayerInfo[playerid][pSettings] &= ~togTester;
    PlayerInfo[playerid][pSettings] &= ~togEnter;

	for(new i = 0; i < MAX_PLAYER_MARKS; i++)
	{
		PlayerInfo[playerid][pMark][i] = -1;
	}

	for(new i = 0; i < MAX_CCTV; i++)
	{
		PCamera[playerid][i][pc_used] = 0;
		PCamera[playerid][i][pc_time] = 0;
	}
    
	ResetPlayerWeaponsEx(playerid);
	Fuel_ResetPlayer(playerid);
	LumberJack_OnPlayerConnect(playerid);
	return 1;
}

RemovePlayerMask(playerid)
{
	if (IsValidDynamic3DTextLabel(cNametag[playerid])) DestroyDynamic3DTextLabel(cNametag[playerid]);
	maskOn{playerid} = false;
	//ShowPlayerName(playerid, true);
	format(PlayerInfo[playerid][pMaskname], 32, PlayerInfo[playerid][pUsername_]);
	
	return 1;
}

IsPlayerLogged(playerid)
{
	return (playerid != INVALID_PLAYER_ID && pTemp[playerid][pLogged] == 2 && IsPlayerConnected(playerid)) ? (1) : (0);
}


/*ShowPlayerName(playerid, bool:show) chua su dung
{
	if (show)
	{
		foreach(new i : Player)
		{
			ShowPlayerNameTagForPlayer(i, playerid, 1);
		}
	}
	else
	{
		foreach(new i : Player)
		{
			ShowPlayerNameTagForPlayer(i, playerid, 0);
		}
	}
	return 1;
}
*/
SetPlayerBuyInterior(playerid, step, houseid = 0)
{
	if (!step)
	{
	    if (pTemp[playerid][pInteriorBiz] == 0) return 1;
        
	    TogglePlayerSpectating(playerid, 0);
		DestroyPlayerObject(playerid, pTemp[playerid][pInteriorObj]);
  		HideMenuForPlayer(buy_interior, playerid);
		return 1;
	}

    new bizid = -1;

	if ((bizid = GetNearInsideBiz(playerid)) == -1 || BizInfo[bizid][bizType] != BIZ_BUILD)	return SendErrorMessage(playerid, "Ban phai o trong mot cong ty xay dung.");
	    
	new start = -1;

    for(new i = 0; i < MAX_INTERIORS; i++)
	{
		if (!AdminTeles[i][telesOn] || HouseInfo[houseid][hClass] != AdminTeles[i][telesType]) continue;

		start = i;
		break;
	}
	
	if (start == -1)	 return SendErrorMessage(playerid, "Khong tim thay noi that cho ngoi nha cua ban. ");
	    
	SavePlayerPos(playerid);
    GameTextForPlayer(playerid, "_", 1, 4);
	TogglePlayerSpectating(playerid, 1);
    pTemp[playerid][pInteriorBiz] = bizid+1;
    pTemp[playerid][pInteriorHouse] = houseid+1;
    pTemp[playerid][pInteriorID] = start;
    pTemp[playerid][pInteriorObj] = CreatePlayerObject(playerid, 19300, AdminTeles[start][telesPosX], AdminTeles[start][telesPosY], AdminTeles[start][telesPosZ], 0.0, 0.0, 0.0);
	AttachCameraToPlayerObject(playerid, pTemp[playerid][pInteriorObj]);
	SetInterior(playerid, AdminTeles[start][telesInt]);
	SetWorld(playerid, 5000 + playerid);
	ShowMenuForPlayer(buy_interior, playerid);
	return 1;
}

IsPlayerAtCarfix(playerid)
{
    if (PlayerInfo[playerid][pFaction] == 0) return 0;
    
	new i = PlayerInfo[playerid][pFaction];
	
	if (GetWorld(playerid) != Factions[i][Carfix][fixVW] || GetInterior(playerid) != Factions[i][Carfix][fixInt]) return 0;

	if (PlayerToPoint(15.0, playerid, Factions[i][Carfix][fixX], Factions[i][Carfix][fixY], Factions[i][Carfix][fixZ]) != 0) return 1;
	
	return 0;
}

PlaySound(playerid, soundid)
{
	PlayerPlaySound(playerid, soundid, 0.0, 0.0, 0.0);
}

PlayerPlaySoundEx(playerid, sound)
{
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);

	foreach (new i : Player)
	{
	    if (IsPlayerInRangeOfPoint(i, 10.0, x, y, z))
		{
			PlayerPlaySound(i, sound, 0.0, 0.0, 0.0);
		}
	    
	}
	return 1;
}

q_GetPlayerIP(playerid)
{
	new IP[24];

	GetPlayerIp(playerid, IP, sizeof(IP));
	return IP;
}

Save_User(playerid)
{	
	if (!IsPlayerLogged(playerid))	return 1;

    if (GetPlayerState(playerid) != PLAYER_STATE_SPECTATING)
    {
		SavePlayerPos(playerid);
		AntiCheatGetArmour(playerid, PlayerInfo[playerid][pArmour]);
	}

	new Float:health;
	if (pTemp[playerid][pInvulnerable] != 0.0) 	health = pTemp[playerid][pInvulnerable];
	else										health = GetPlayerHealthEx(playerid);
	
	new query[1024];
	format(query, sizeof(query), "UPDATE `users` SET `armour`=%f,`cash`=%i,`bank`=%i,`skin`=%i,`sex`=%i,`level`=%i,`hours`=%i,`admin_hide`=%i,`int`=%i,`world`=%i,`channel`=%i,`owned_channel`=%i,`authed`=%i,`paydaytime`=%i,`number`=%i WHERE `id`=%i",
		PlayerInfo[playerid][pArmour], PlayerInfo[playerid][pCash], PlayerInfo[playerid][pBank], 
		PlayerInfo[playerid][pSkin], PlayerInfo[playerid][pSex], PlayerInfo[playerid][pLevel],
		PlayerInfo[playerid][pHours], PlayerInfo[playerid][pAdminHide], PlayerInfo[playerid][pInt], 
		PlayerInfo[playerid][pWorld], PlayerInfo[playerid][pChannel], PlayerInfo[playerid][pOwnedChannel], 
		PlayerInfo[playerid][pAuthed], PlayerInfo[playerid][pPayDayTime], PlayerInfo[playerid][pNumber], PlayerInfo[playerid][pID]
	);
	mysql_tquery(dbHandle, query);

	format(query, sizeof(query), "UPDATE `users` SET `ajailed`=%i,`ajailtime`=%i,`jailed`=%i,`isolatetime`=%i,`warns`=%i,`vip`=%i,`carlic`=%i,`weplic`=%i,`flylic`=%i,`savings`=%i,`rent_key`=%i,`rent_price`=%i,`taxilic`=%i,`dependence`=%i,`demolition`=%i WHERE `id`=%i",
		PlayerInfo[playerid][pAJailed], PlayerInfo[playerid][pAJailTime], PlayerInfo[playerid][pJailed], 
		PlayerInfo[playerid][pIsolateTime], PlayerInfo[playerid][pWarns], PlayerInfo[playerid][pPremium], 
		PlayerInfo[playerid][pCarLic], PlayerInfo[playerid][pWepLic], PlayerInfo[playerid][pFlyLic],
		PlayerInfo[playerid][pSavings], PlayerInfo[playerid][pRentKey], PlayerInfo[playerid][pRentPrice],
		PlayerInfo[playerid][pTaxiLic], PlayerInfo[playerid][pDependence], PlayerInfo[playerid][pDemolition],PlayerInfo[playerid][pID]
	);
	mysql_tquery(dbHandle, query);

	format(query, sizeof(query), "UPDATE `users` SET `arrested`=%i,`chat`=%i,`authwep`=%i,`swat`=%i,`swat_duty`=%i,`job`=%i,`career`=%i,`fightstyle`=%i,`hud`=%i,`mutetime`=%i,`phone_off`=%i,`phone_airplane`=%i,`paycheck`=%i,`fishcount`=%i,`fish_time`=%i WHERE `id`=%i",
		PlayerInfo[playerid][pArrested], PlayerInfo[playerid][pTalk], PlayerInfo[playerid][pAuthwep], 
		PlayerInfo[playerid][pSwat], PlayerInfo[playerid][pSwatDuty], PlayerInfo[playerid][pJob], 
		PlayerInfo[playerid][pCareer], PlayerInfo[playerid][pFightStyle], PlayerInfo[playerid][pHud], 
		PlayerInfo[playerid][pMutedTime], PlayerInfo[playerid][pPhoneOff], PlayerInfo[playerid][pPhoneAirplane],
		PlayerInfo[playerid][pPayCheckMoney], PlayerInfo[playerid][pFishCount], PlayerInfo[playerid][pFishTime],PlayerInfo[playerid][pID]
	);
	mysql_tquery(dbHandle, query);

	format(query, sizeof(query), "UPDATE `users` SET `walk`=%i,`faction`=%i,`rank`=%i,`phone_sound`=%i,`phone_model`=%i,`phone_ringtone`=%i,`badgenumber`=%i,`drivewarns`=%i,`wepwarns`=%i,`wep_count`=%i,`jailtime`=%i,`slot`=%i,`injured`=%i,`deathreason`=%i WHERE `id`=%i",
		PlayerInfo[playerid][pWalk], PlayerInfo[playerid][pFaction], PlayerInfo[playerid][pRank],
		PlayerInfo[playerid][pPhoneSound], PlayerInfo[playerid][pPhoneModel], PlayerInfo[playerid][pPhoneRingtone],
		PlayerInfo[playerid][pBadgeNumber], PlayerInfo[playerid][pDriveWarns], PlayerInfo[playerid][pWepWarns], 
		PlayerInfo[playerid][pWepCount],PlayerInfo[playerid][pJailTime],PlayerInfo[playerid][pSlot], 
		PlayerInfo[playerid][pInjured], PlayerInfo[playerid][pDeathReason],PlayerInfo[playerid][pID]
	);
	mysql_tquery(dbHandle, query);

	format(query, sizeof(query), "UPDATE `users` SET `sidejob`=%i,`prescribe`=%i,`ganja_time`=%i,`phone_style`=%i,`sparekey`=%i,`workon`=%i,`spawntype`=%i,`spawnpoint`=%i,`health`=%f,`pos_X`=%f,`pos_Y`=%f,`pos_Z`=%f,`pos_A`=%f,`prisoned`=%i WHERE `id`=%i",
    	PlayerInfo[playerid][pSideJob], PlayerInfo[playerid][pPrescribe], PlayerInfo[playerid][pGanjaTime], 
		PlayerInfo[playerid][pPhoneStyle], PlayerInfo[playerid][pSpareKey], PlayerInfo[playerid][pWorkOn],
		PlayerInfo[playerid][pSpawnType], PlayerInfo[playerid][pSpawnPoint], health,
		PlayerInfo[playerid][pPosX], PlayerInfo[playerid][pPosY],PlayerInfo[playerid][pPosZ], 
		PlayerInfo[playerid][pPosA], PlayerInfo[playerid][pPrisoned],PlayerInfo[playerid][pID]
	);
	mysql_tquery(dbHandle, query);

    format(query, sizeof(query), "UPDATE `users` SET `weaphide0`=%i,`weaphide1`=%i,`weaphide2`=%i,`duty`=%i,`char`=%i,`drugaccess`=%i,`tog_0`=%i,`tog_1`=%i,`tog_2`=%i WHERE `id`=%i",
		PlayerInfo[playerid][pHideWeap][0], PlayerInfo[playerid][pHideWeap][1], PlayerInfo[playerid][pHideWeap][2],
		PlayerInfo[playerid][pOnDuty], PlayerInfo[playerid][pChar], PlayerInfo[playerid][pDrugLabAccess],
		PlayerInfo[playerid][pTog][0], PlayerInfo[playerid][pTog][1], PlayerInfo[playerid][pTog][2], PlayerInfo[playerid][pID]
	);
	mysql_tquery(dbHandle, query);

   	format(query, sizeof(query), "UPDATE `users` SET `PlayerWeapon`=%i,`PlayerAmmo`=%i,`AmmoType`=%i,`WepSerial`=%i,`PlayerSerial`=%i,`LastPrim`=%i,`LastSec`=%i,`LastMelee`=%i,`Forbid`=%i WHERE `id`=%i",
		PlayerInfo[playerid][pPlayerWeapon], PlayerInfo[playerid][pPlayerAmmo], PlayerInfo[playerid][pAmmoType], 
		PlayerInfo[playerid][pWepSerial], PlayerInfo[playerid][pPlayerSerial], PlayerInfo[playerid][pLastPrim], 
		PlayerInfo[playerid][pLastSec], PlayerInfo[playerid][pLastMelee], PlayerInfo[playerid][pForbid], PlayerInfo[playerid][pID]
	);
	mysql_tquery(dbHandle, query);

	//printf(playerid, "%s", query);
	
	for(new i = 0; i < MAX_COP_SLOTS; i++)
	{
		//if (!PlayerInfo[playerid][pCopItem][i])	continue;

		format(query, sizeof(query), "UPDATE `users` SET `CopItem_%i`=%i,`CopAmmo_%i`=%i,`CopEx_%i`=%i,`CopS_%i`=%i WHERE `id`=%i",
			i+1, PlayerInfo[playerid][pCopItem][i], i+1, PlayerInfo[playerid][pCopQ][i],
			i+1, PlayerInfo[playerid][pCopEx][i], i+1, PlayerInfo[playerid][pCopS][i], PlayerInfo[playerid][pID]
		);
		mysql_tquery(dbHandle, query);
	}	
	for(new i = 0; i < MAX_FISH_SLOT; i++)
	{
		format(query, sizeof(query), "UPDATE `users` SET `Fish_%i`=%i", i+1, PlayerInfo[playerid][pFish][i]);
		mysql_tquery(dbHandle, query);
	}	
	SaveUser_Inventory(playerid);
	return 1;
}

SaveUser_Inventory(playerid) 
{
	new query[256];

	for(new i = 0; i < MAX_INV_SLOTS; i++)
	{
		if (strlen(Inventory[playerid][i][pInvName]) < 2) format(Inventory[playerid][i][pInvName], 16, "None");

	    format(query, sizeof(query), "UPDATE `inventory` SET `id_%i`=%i,`a_%i`=%i,`f_%i`=%.1f,`ex_%i`=%i,`s_%i`=%i,`n_%i`='%s' WHERE `userid`=%i",
			i+1, Inventory[playerid][i][pInvItem], i+1, Inventory[playerid][i][pInvQ], 
			i+1, Inventory[playerid][i][pInvQFloat], i+1, Inventory[playerid][i][pInvEx], 
			i+1, Inventory[playerid][i][pInvS], i+1, Inventory[playerid][i][pInvName], PlayerInfo[playerid][pID]
		);
		mysql_tquery(dbHandle, query);
	}
	
	return 1;
}

stock Fuel_ResetPlayer(playerid) 
{
    if (RefuelTimer[playerid] != -1)
    {
        KillTimer(RefuelTimer[playerid]);
        RefuelTimer[playerid] = -1;
        PlayerTextDrawHide(playerid, FuelText[playerid]);
    }
 
    DeletePVar(playerid, #UsePump);
    DeletePVar(playerid, #FuelBought);
    return 1;
}

ResetVariables(playerid)
{
    pTemp[playerid][pPizzaBoy] = 
    pTemp[playerid][pDemolitionTime] =
	pTemp[playerid][pDrugUse] =
	pTemp[playerid][pDrugTime] =
	pTemp[playerid][pDrugChgWeather] =
    pTemp[playerid][pLicenseExam] =
	pTemp[playerid][pWaypoint] = 
    pTemp[playerid][pWaypoint] = 
	pTemp[playerid][pWepPrice] =
	pTemp[playerid][pRentPrice] = 
	pTemp[playerid][pHousePrice] =
    pTemp[playerid][pRentveh] = 
	pTemp[playerid][pServeType] = 
	pTemp[playerid][pGreetType] =
    pTemp[playerid][pNews] = 
	pTemp[playerid][pCallOn] =
	pTemp[playerid][pFishTime] =
    pTemp[playerid][pEditBort] = 
	pTemp[playerid][pCarPrice] = 
	pTemp[playerid][tempItem] = 
	pTemp[playerid][tempEx] = 
	pTemp[playerid][tempQ] = 	
    pTemp[playerid][pHealTime] = 
    pTemp[playerid][pRamType] =
	pTemp[playerid][UsingBort] = 
	pTemp[playerid][UsingCorpse] =
	pTemp[playerid][tempStatus] =
    pTemp[playerid][pRamTime] = 0;

	pTemp[playerid][pHouseHouse] = -1;

	pTemp[playerid][pVendingVending] = -1;
	pTemp[playerid][pVendingPrice] = 
	pTemp[playerid][pVendingPlayer] = 

	pTemp[playerid][pBizPrice] = 0;
	pTemp[playerid][pBizID] = INVALID_PLAYER_ID;

    pTemp[playerid][pInterview] = 
	pTemp[playerid][pInterviewPlayer] =
	pTemp[playerid][pHealPlayer] = 
    pTemp[playerid][pFactionPlayer] = 
	pTemp[playerid][pBizPlayer] = 
    pTemp[playerid][pFriskPlayer] = 
	pTemp[playerid][pSpecPlayer] = 
	pTemp[playerid][pHirePlayer] = 
	pTemp[playerid][pCarPlayer] = 
	pTemp[playerid][pWepPlayer] = 
	pTemp[playerid][pRentPlayer] = 
	pTemp[playerid][pHousePlayer] =
	pTemp[playerid][pServePlayer] = 
	pTemp[playerid][pGreetPlayer] = INVALID_PLAYER_ID;

	for(new c = 0; c < 5; c++)
	{
		pTemp[playerid][MyCarSpawn][c] = 0;
		pTemp[playerid][MyCarSpawn][c] = 0;
	}

	SetPVarInt(playerid, #attach_item, 0);

	if (IsPlayerPhoneCreated(playerid)) 	Phone_Hide(playerid);
	if (IsPlayerUseMDC(playerid))		MDC_Hide(playerid);

    if (IsValidDynamicObject(pTemp[playerid][pRamObj]))
	{
		DestroyDynamicObject(pTemp[playerid][pRamObj]);
		pTemp[playerid][pRamObj] = INVALID_OBJECT_ID;
	}

	PlayerInfo[playerid][pArmour] = 0.0;

	if (pTemp[playerid][pFlashTime]) pTemp[playerid][pFlashTime] = 1;

	if (pTemp[playerid][p3DMenu] != -1)
	{
    	Destroy3DMenu(pTemp[playerid][p3DMenu]);
		pTemp[playerid][p3DMenu] = -1;
	}

	if (IsPlayerPhoneCreated(playerid)) Phone_Hide(playerid);

	if (pTemp[playerid][pCallLine] != INVALID_PLAYER_ID)
	{
	    SendPhoneMessage(pTemp[playerid][pCallLine], "Ket noi voi nguoi dang ky bi cat ...");
	    cmd::hangup(playerid, "");
		
	}
	pTemp[playerid][pEmergency] = 0;

	if (GetPVarInt(playerid, #selfie)) DeletePVar(playerid, #selfie);

    if (pTemp[playerid][pTracePlayer] != INVALID_PLAYER_ID)
	{
	    pTemp[playerid][pTracePlayer] = INVALID_PLAYER_ID;
		pTemp[playerid][pTraceStage] = 0;

		if (pTemp[playerid][pTraceGZ] != -1) GangZoneDestroy(pTemp[playerid][pTraceGZ]);

		pTemp[playerid][pTraceGZ] = -1;
	}

	if (pTemp[playerid][pCargoID]) pTemp[playerid][pCargoID] = 0;
	
	RemovePlayerAttachedObject(playerid, ATTACH_HANDS);
	TogglePlayerAllDynamicRaceCPs(playerid, false);
	TogglePlayerAllDynamicCPs(playerid, false);
	EndJob(playerid);
	Fuel_ResetPlayer(playerid);
	return 1;
}

KickEx(playerid)
{
	if (GetPVarInt(playerid,"kicked")) return 1;

    SetPVarInt(playerid,"kicked", 1);
    SetTimerEx("KickPlayer", 200, false, "d", playerid);
    return 1;
}

ShowStats(playerid, id)
{
	new nums[12], works[32], donate[64], fname[32], rname[32], radio[32], primary[32], secondary[32], rentcar[64], header[200], body[1200];
	new year, month, day, hour, minute, second;

	if (PlayerInfo[id][pNumber] == 0) 	nums = "Khong";
	else								format(nums, sizeof(nums), "%i", PlayerInfo[id][pNumber]);

	if (PlayerInfo[id][pWorkOn] == 0)	works = "N/A";
	else								format(works, sizeof(works), "%i", PlayerInfo[id][pWorkOn]);

	if (PlayerInfo[id][pFaction] == 0)	fname = "Dan thuong";
	else								format(fname, 32, "%s", Factions[PlayerInfo[id][pFaction]][fName]);

	if (PlayerInfo[id][pRank] == 0)		rname = "Khong co cap bac";
	else								format(rname, 32, "%s", GetRankName(id));

	if(IsPlayerHasItem(id, INV_RADIO))
	{
		radio = "Co";
	}	
	else
	{
		radio = "Khong";
	}

	if (PlayerInfo[id][pLastSec] != -1) 
	{
		if (GetWeaponType(Inventory[id][PlayerInfo[id][pLastSec]][pInvItem]) == WEAPON_TYPE_SECONDARY) 
		{
			new prim;
			prim = PlayerInfo[id][pLastSec];
			format(primary, 32, "%s", inventory_items[Inventory[id][prim][pInvItem]][itemName])	;
		} 
		else 
		{
			primary = "Khong";
		}
	}
	if (PlayerInfo[id][pLastPrim] != -1) 
	{
		if (GetWeaponType(Inventory[id][PlayerInfo[id][pLastPrim]][pInvItem]) == WEAPON_TYPE_PRIMARY) 
		{
			new sec;
			sec = PlayerInfo[id][pLastPrim];
			format(secondary, 32, "%s", inventory_items[Inventory[id][sec][pInvItem]][itemName])	;
		} 
		else 
		{
			secondary = "Khong";
		}
	}
	if(pTemp[playerid][pRentveh] != 0)
	{
		format(rentcar, 64, "%s", VehicleNames[GetVehicleModel(pTemp[playerid][pRentveh])-400]);
	}
	else
	{
		rentcar = "Khong";
	}

	switch(PlayerInfo[id][pPremium])
	{
	    case 1: donate = "Bronze User";
	    case 2: donate = "Silver User";
	    case 3: donate = "Gold User";
		default: donate = "Khong";
	}
	new Float:hp;
	AntiCheatGetHealth(playerid, hp);

	getdate(year, month, day);
	gettime(hour, minute, second);

    format(header, sizeof(header), "\t%s [%02d %s %i, %02d:%02d:%02d]", GetNameEx(id), day, GetMonthName(month), year, hour, minute, second);
	format(body, sizeof(body), "{F5CC00}\t__________Nhan vat__________{E2FFFF}\n\
	To chuc: [%i][%s] | Cap bac: [%s]\n\
	Cong viec: [%s]\n\
	Dien thoai: [%s]\n\
	Cap do: [%i] | DonatorLevel: [%s]\n\
	{F5CC00}\t__________Vu khi__________{E2FFFF}\n\
	Vu khi chinh: [%s]\n\
	Vu khi phu: [%s]\n\
	{F5CC00}\t__________Trang thai__________{E2FFFF}\n\
	Suc khoe[%.0f/150.0]\n\
	Suc manh:[%s] \n\
	So gio choi:[%i gio]\n\
	{F5CC00}\t__________Trang thai__________{E2FFFF}\n\
	Tien:[$%i]\n\
    Ngan hang:[$%i]\n\
	Tiet kiem:[$%i]\n\
	Luong:[$%i]", Factions[PlayerInfo[id][pFaction]][fID], fname, 
	rname, GetJobName(PlayerInfo[id][pJob]), nums,
	PlayerInfo[id][pLevel], donate, primary, secondary,
	hp, GetFightStyleName(id), PlayerInfo[id][pHours],
	GetCash(id), PlayerInfo[id][pBank], PlayerInfo[id][pSavings], PlayerInfo[id][pPayCheckMoney]);
	
	Dialog_Show(playerid, DIALOG_STATS, DIALOG_STYLE_MSGBOX, header, body, "", "Dong");
	/*SendClientMessageEx(playerid, COLOR_GREEN,"|____________________%s [%02d %s %i, %02d:%02d:%02d]____________________|", GetNameEx(id), day, GetMonthName(month), year, hour, minute, second);
	SendClientMessageEx(playerid, COLOR_STATS1, "| Nhan Vat | To chuc:[%i][%s] Cap bac:[%s] Cong viec: [%s] Dien thoai:[%s]", Factions[PlayerInfo[id][pFaction]][fID], fname, rname, GetJobName(PlayerInfo[id][pJob]), nums);
	SendClientMessageEx(playerid, COLOR_STATS2, "| Tui Do | Radio:[%s]", radio);
	SendClientMessageEx(playerid, COLOR_STATS2, "| Vu Khi | Vu khi chinh:[%s] | Vu khi phu:[%s]", primary, secondary);
	SendClientMessageEx(playerid, COLOR_STATS2, "| Cap Do | Cap do:[%i] | DonatorLevel:[%s]", PlayerInfo[id][pLevel], donate);
	SendClientMessageEx(playerid, COLOR_STATS2, "| Ky Nang | Suc khoe[%.0f/150.0] Suc manh:[%s] So gio choi:[%i gio]", hp, GetFightStyleName(id), PlayerInfo[id][pHours]);
	SendClientMessageEx(playerid, COLOR_STATS1, "| Tai San | Tien:[$%i] Ngan hang:[$%i], Tiet kiem:[$%i] Luong:[$%i]", GetCash(id), PlayerInfo[id][pBank], PlayerInfo[id][pSavings], PlayerInfo[id][pPayCheckMoney]);*/
	SendClientMessageEx(playerid, COLOR_STATS2, "| Khac | WorkOn:[%s] SideJob:[%s], RentingCar:[%s]", works, GetJobName(PlayerInfo[id][pSideJob]), rentcar);

	if (CheckAdmin(playerid, ADMIN_LEVEL_1))
	{
		if (PlayerInfo[id][pJailed] != 0)		SendClientMessageEx(playerid, COLOR_LIGHTRED, "| Hinh phat IC | Ngoi tu [%i giay nua].", PlayerInfo[id][pJailTime]);
    	if (PlayerInfo[id][pMutedTime] > 0)		SendClientMessageEx(playerid, COLOR_LIGHTRED, "| Hinh phat OOC | Bi tat tieng trong %i phut.", PlayerInfo[id][pMutedTime]);
		if (PlayerInfo[id][pForbid] != 0)		SendClientMessageEx(playerid, COLOR_LIGHTRED, "| Hinh phat OOC | Han che vu khi %i gio.", PlayerInfo[id][pForbid]);
		if (id != playerid)						SendHelpMessage(playerid,"To view inventory {ffc46a}/check %i", id);
	}

	//SendClientMessageEx(playerid, COLOR_GREEN,"|____________________%s [%02d %s %i, %02d:%02d:%02d]____________________|", GetNameEx(id), day, GetMonthName(month), year, hour, minute, second);
	return 1;
}

SetSpawnInfoEx(playerid, Float:x, Float:y, Float:z, Float:Angle = 0.0)
{
    if (PlayerInfo[playerid][pChar] > 0)	SetSpawnInfo(playerid, 0, PlayerInfo[playerid][pChar], x, y, z, Angle, 0, 0, 0, 0, 0, 0);
	else									SetSpawnInfo(playerid, 0, PlayerInfo[playerid][pSkin], x, y, z, Angle, 0, 0, 0, 0, 0, 0);
	return 1;
}

GetNameForPlayer(playerid)
{
    GetPlayerName(playerid, PlayerInfo[playerid][pUsername], MAX_PLAYER_NAME+1);
    GetPlayerName(playerid, PlayerInfo[playerid][pUsername_], MAX_PLAYER_NAME+1);
    strreplace(PlayerInfo[playerid][pUsername_], '_', ' ');
    format(PlayerInfo[playerid][pMaskname], 32, PlayerInfo[playerid][pUsername_]);
    return 1;
}

GetIDByID(databaseid)
{
	foreach(new i : Player)
	{
		if (!IsPlayerLogged(i)) 												continue;
		if (PlayerInfo[i][pID] == databaseid)								return i;
	}
	return INVALID_PLAYER_ID;
}

GetNameFromBD(id)
{
	new query[64], name[MAX_PLAYER_NAME];

	mysql_format(dbHandle, query, sizeof(query), "SELECT `name` FROM `users` WHERE `id` = %i", id);
	new Cache:cache = mysql_query(dbHandle, query);
	
	cache_get_field_content(0, "name", name, dbHandle, 24);
	strreplace(name, '_', ' ');

	cache_delete(cache);

	return name;
}

CheckPMBlockList(playerid)
{
	foreach(new i : Player)
	{
	    if (!IsPlayerLogged(i) || people_blocking[i][playerid] != 1)			continue;

        SendSyntaxMessage(i, "%s da ngat ket noi khoi may chu va bi xoa khoi danh sach den PM cua ban.", GetNameEx(playerid), playerid);
		people_blocking[i][playerid] = 0;
	}
	return 1;
}

stock GetXYInFrontOfPlayer(playerid, &Float:X, &Float:Y, &Float:Z, Float:distance)
{
	new Float:A;
	GetPlayerPos(playerid, X, Y, Z);

	if (GetPlayerVehicleID(playerid))	GetVehicleZAngle(GetPlayerVehicleID(playerid), A);
	else								GetPlayerFacingAngle(playerid, A);

	X += (distance * floatsin(-A, degrees));
	Y += (distance * floatcos(-A, degrees));
}

#define GetVectorSpeed(%0,%1,%2) floatround(VectorSize(%0, %1, %2) * 179.28625)
SetPlayerPosEx(playerid, Float:x, Float:y, Float:z, freeze = 1)
{
	SetPlayerPos(playerid, x, y, z + 0.2);
 	SetCameraBehindPlayer(playerid);
	if (freeze != 0)
	{
 		FreezePlayer(playerid);
 		pTemp[playerid][pFreezeTime] = 2;
	}
	return 1;
}

SetPlayerCurrentTimeAndWeather(playerid)
{
	SetPlayerTime(playerid, server_hour, 0);
	SetPlayerWeather(playerid, server_weather);
	return 1;
}

GetFightStyleName(playerid)
{
	new style[9];
	switch(PlayerInfo[playerid][pFightStyle])
	{
		case FIGHT_STYLE_BOXING: format(style, sizeof(style), "Boxing");
		case FIGHT_STYLE_KUNGFU: format(style, sizeof(style), "Kungfu");
		case FIGHT_STYLE_GRABKICK: format(style, sizeof(style), "Grabkick");
		case FIGHT_STYLE_KNEEHEAD: format(style, sizeof(style), "Kneehead");
		case FIGHT_STYLE_NORMAL: format(style, sizeof(style), "Standard");
	}
	return style;
}

Dialog:MODEL_SEL_BUYCLOTHES(playerid, response, listitem, inputtext[])
{
	if (!response) return 1;

	new modelid;
	if (PlayerInfo[playerid][pSex] == 1)	modelid = male_skins[listitem];
	else								modelid = female_skins[listitem];

	if (modelid < 1 || modelid > 311) return 1;

	if (GetCash(playerid) < 100)	return SendNotCash(playerid);
	if (GetPlayerSkin(playerid) == modelid || PlayerInfo[playerid][pTog][0] == modelid || PlayerInfo[playerid][pTog][1] == modelid || PlayerInfo[playerid][pTog][2] == modelid) 
	{
		return SendErrorMessage(playerid, "Ban da mua trang phuc nay roi.");
	}

	new mes[128];

	for(new i; i != 3; i++)
	{
		if (PlayerInfo[playerid][pTog][i] == 0)	strcat(mes, "\n[Trong]");
		else									format(mes, sizeof(mes), "%s\n[Trang phuc #%i]", mes, PlayerInfo[playerid][pTog][i]);
	}

	Dialog_Show(playerid, BuyClothes, DIALOG_STYLE_LIST, "Chon vi tri ...", mes, "Thay doi", "X");
	SetPVarInt(playerid, "clothes_model", modelid);
	return 1;
}

CreateDynamicExplosion(Float:x,Float:y,Float:z,type,Float:radius,worldid = -1,interiorid = -1,playerid = -1,Float:distance = 200.0){
	if (playerid == -1){
		foreach(new i : Player){
			new Float:px, Float:py, Float:pz;
			if (IsPlayerInAnyVehicle(i)){
				GetVehiclePos(GetPlayerVehicleID(i),px,py,pz);
			} else {
				GetPlayerPos(i,px,py,pz);
			}
			if ((GetPlayerInterior(i) == interiorid || interiorid == -1) && (GetPlayerVirtualWorld(i) == worldid || worldid == -1) && (VectorSize(px-x,py-y,pz-z) <= distance)){
				CreateExplosionForPlayer(i,x,y,z,type,radius);
			}
		}
	} else {
		if (IsPlayerConnected(playerid)){
			new Float:px, Float:py, Float:pz;
			if (IsPlayerInAnyVehicle(playerid)){
				GetVehiclePos(GetPlayerVehicleID(playerid),px,py,pz);
			} else {
				GetPlayerPos(playerid,px,py,pz);
			}
			if ((GetPlayerInterior(playerid) == interiorid || interiorid == -1) && (GetPlayerVirtualWorld(playerid) == worldid || worldid == -1) && (VectorSize(px-x,py-y,pz-z) <= distance)){
				CreateExplosionForPlayer(playerid,x,y,z,type,radius);
			}
		}
	}
} 

GetLocationZone(Float:x, Float:y, Float:z)
{
	new string[128], zone[28];

	GetZone(x, y, zone, sizeof(zone));
	
	if (IsPointInAnyDynamicArea(x, y, z)) {
		new areas[10], street_area[2], j = GetNumberDynamicAreasForPoint(x,y,z);
		GetDynamicAreasForPoint(x, y, z, areas, sizeof(areas));

		if (GetStreet(areas, j, street_area)) {
			if (street_area[1] == -1) format(string, sizeof(string), "%s, %s", zone, street_names[street_area[0]]); 
			else					 format(string, sizeof(string), "%s, o giao lo %s va %s", zone, street_names[street_area[0]],street_names[street_area[1]]);
		}
	}
	format(string, sizeof(string), "%s", zone);

	return string;
}

stock bool:IsPlayerCrouching(playerid)
{
    if (GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK) return false;
	return true;
}

CheckHanditem(playerid, model) {
	new result = 0;
	for(new i = 0; i < MAX_PLAYER_ATTACH; i++)
	{
		if (!AttachInfo[playerid][i][aUsed]) 										   continue;
		if (AttachInfo[playerid][i][aModel] != model)								   continue;
		if (AttachInfo[playerid][i][aBone] != 5 && AttachInfo[playerid][i][aBone] != 6) continue;
		return 1;
	}
	
	return result;
}

stock PlaySoundInArea(soundid,Float:x,Float:y,Float:z,Float:radi)
{
    foreach(new i : Player)
	{
        if (!IsPlayerLogged(i)) continue;
	    if (IsPlayerInRangeOfPoint(i,radi,x,y,z)) PlayerPlaySound(i, soundid, x, y, z);
	}
	return 1;
}

Float:XB_GetDistanceBetweenTPoints(Float:x,Float:y,Float:z,Float:tx,Float:ty,Float:tz)
{
	new Float:temp1, Float:temp2 , Float:temp3;
	temp1 = x-tx;temp2 = y-ty;
	temp3 = z-tz;
	return floatsqroot(temp1*temp1+temp2*temp2+temp3*temp3);
}

CheckNumberAvailable(number)
{
	new
		query[64]
	;

 	mysql_format(dbHandle, query, sizeof(query), "SELECT COUNT(id) as total FROM `users` WHERE `number`=%i", number);
	new Cache:cache = mysql_query(dbHandle, query),
		count = cache_get_field_content_int(0, "total");
	
	cache_delete(cache);
	return count;
}

SetPlayerNumber(playerid) {	
	mysql_tquery(dbHandle, "SELECT FLOOR(RAND()*(999999-100100)+100100) as randNumber \
							FROM `users` \
							HAVING (SELECT COUNT(*) FROM `users` WHERE number = randNumber) < 1 \
							LIMIT 1", 
				"GetPlayerNumber", "i", playerid
	);
	return 1;
}

this::GetPlayerNumber(playerid) {
	if (!cache_num_rows()) return SetPlayerNumber(playerid);

	PlayerInfo[playerid][pNumber] = cache_get_field_content_int(0, "randNumber", dbHandle);
	SQL_SetInteger("users", "number", PlayerInfo[playerid][pNumber], PlayerInfo[playerid][pID]);

	SendSyntaxMessage(playerid, "Ban da duoc chi dinh so dien thoai moi: %i. ((/ph))", PlayerInfo[playerid][pNumber]);
	return 1;
}

CreatePlayersFire(playerid, type, building)
{
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);

	if (GetDistanceBetweenPoints(x,y,z,PlayerInfo[playerid][pPosX],PlayerInfo[playerid][pPosY],PlayerInfo[playerid][pPosZ]) > 1.5 
		&& PlayerInfo[playerid][pWorld] != GetWorld(playerid) 
		&& PlayerInfo[playerid][pInt] != GetInterior(playerid)
	) {
		StopCreatingPlayersFire(playerid);
		return SendErrorMessage(playerid, "Dot lua khong thanh cong, hay thu lai");
	}
	
	new 
		location[128], 
		where[12], 
		Float:ExpPos[3]
	;

	switch(type) {
		case 0: {
			CreateFireInHouse(building);

			if (HouseInfo[building][hApart]) {
				ExpPos[0] = ApartInfo[HouseInfo[building][hApart]][aPosX];
				ExpPos[1] = ApartInfo[HouseInfo[building][hApart]][aPosY];
				ExpPos[2] = ApartInfo[HouseInfo[building][hApart]][aPosZ];

				where = "building";
			} else {
				ExpPos[0] = HouseInfo[building][hPosX]; 
				ExpPos[1] = HouseInfo[building][hPosY];
				ExpPos[2] = HouseInfo[building][hPosZ];

				where = "home";
			}
		}
		case 1: {
			CreateFireInBiz(building);

			ExpPos[0] = BizInfo[building][bizPosX]; 
			ExpPos[1] = BizInfo[building][bizPosY];
			ExpPos[2] = BizInfo[building][bizPosZ];

			where = "business";
		} 
		case 2: {
			CreateFireInGarage(building);

			ExpPos[0] = GarageInfo[building][garageVeh_Enter][0]; 
			ExpPos[1] = GarageInfo[building][garageVeh_Enter][1];
			ExpPos[2] = GarageInfo[building][garageVeh_Enter][2];

			where = "garage";
		}
	}

	format(location, sizeof(location), "%s", GetLocationZone(x,y,z));

	for(new i = FACTION_POLICE; i <= FACTION_FIRE; i++)
	{
		SendClientMessageEx(i, COLOR_LIGHTBLUE, "|__________Cuoc goi khan cap__________|");
		SendClientMessageEx(i, COLOR_LIGHTBLUE, "Goi tu: Payphone");
		SendClientMessageEx(i, COLOR_LIGHTBLUE, "Yeu cau: Canh sat, Xe cuu thuong / Cuu hoa");
		SendClientMessageEx(i, COLOR_LIGHTBLUE, "Vi tri: %s %i", location, building);
		SendClientMessageEx(i, COLOR_LIGHTBLUE, "Tinh huong: Co mot dam chay o %s!", where);			
	}

	for(new i = 0; i != MAX_CALLS_AND_ARREST; i++)
	{
	    if (CallInfo[i][callExists] != 0) continue;

       	CallInfo[i][callPosX] = ExpPos[0];
		CallInfo[i][callPosY] = ExpPos[1];
		CallInfo[i][callPosZ] = ExpPos[2];

        CallInfo[i][callType] = 3;
		CallInfo[i][callPhone] = 0;

		format(CallInfo[i][callText], 128, "Co mot dam chay o %s!", where);
		format(CallInfo[i][callName], MAX_PLAYER_NAME, "Payphone");
        format(CallInfo[i][callDate], 32, "%s", GetFullDate());
        format(CallInfo[i][callLocation], MAX_ZONE_NAME, "%s %i", location, building);
        
        CallInfo[i][callDelete] = gettime() + 1200;
        CallInfo[i][callExists] = 1;
        break;
	}

	return 1;
}

StopCreatingPlayersFire(playerid)
{
	UnFreezePlayer(playerid);
	StopPlayerAnims(playerid);
	pTemp[playerid][pFireTime] = 0;
	DeletePVar(playerid, #firetype);
	DeletePVar(playerid, #firebuildID);
	return 1;
}

/*GetHealthDots(playerid)
{
    new
        dots[64], Float: HP;
 
    AntiCheatGetHealth(playerid, HP);
 
	if (HP >= 100)
        dots = "IIIIIIIIII";
    else if (HP >= 90)
        dots = "IIIIIIIII{660000}I";
    else if (HP >= 80)
        dots = "IIIIIIII{660000}II";
    else if (HP >= 70)
        dots = "IIIIIII{660000}III";
    else if (HP >= 60)
        dots = "IIIIII{660000}IIII";
    else if (HP >= 50)
        dots = "IIIII{660000}IIIII";
    else if (HP >= 40)
        dots = "IIII{660000}IIIIII";
    else if (HP >= 30)
        dots = "III{660000}IIIIIII";
    else if (HP >= 20)
        dots = "II{660000}IIIIIIII";
    else if (HP >= 10)
        dots = "I{660000}IIIIIIIII";
    else if (HP >= 0)
        dots = "{660000}IIIIIIIIII";
 
    return dots;
}
 
GetArmorDots(playerid)
{
    new
        dots[64], Float: AR;
 
    AntiCheatGetArmour(playerid, AR);
	
	if (AR >= 100)
        dots = "IIIIIIIIII";
    else if (AR >= 90)
        dots = "IIIIIIIII{666666}I";
    else if (AR >= 80)
        dots = "IIIIIIII{666666}II";
    else if (AR >= 70)
        dots = "IIIIIII{666666}III";
    else if (AR >= 60)
        dots = "IIIIII{666666}IIII";
    else if (AR >= 50)
        dots = "IIIII{666666}IIIII";
    else if (AR >= 40)
        dots = "IIII{666666}IIIIII";
    else if (AR >= 30)
        dots = "III{666666}IIIIIII";
    else if (AR >= 20)
        dots = "II{666666}IIIIIIII";
    else if (AR >= 10)
        dots = "I{666666}IIIIIIIII";
    else if (AR >= 0)
        dots = "{666666}IIIIIIIIII";

 
    return dots;
}*/

this::Invulnerable(playerid)
{
	if (pTemp[playerid][pInvulnerable] == 0.0) {
		pTemp[playerid][pInvulnerable] = 30.0;
	}

	SetPlayerHealth(playerid, pTemp[playerid][pInvulnerable]);
	pTemp[playerid][pInvulnerable] = 0.0;
	return 1;
}

stock to_date( timestamp, _form=0 )
{
    /*
        ~ convert a Timestamp to a Date.
        ~ 10.07.2009

        date( 1247182451 )  will print >> 09.07.2009-23:34:11
        date( 1247182451, 1) will print >> 09/07/2009, 23:34
        date( 1247182451, 2) will print >> July 09, 2009, 23:34:11
        date( 1247182451, 3) will print >> 9 Jul 2009, 23:34
    */
    new year=1970, day=0, month=0, hour=0, mins=0, sec=0;

    new days_of_month[12] = { 31,28,31,30,31,30,31,31,30,31,30,31 };
    new names_of_month[12][10] = {"T1","T2","T3","T4","T5","T6","T7","T8","T9","T10","T11","T12"};
    new returnstring[32];

    while(timestamp>31622400){
        timestamp -= 31536000;
        if ( ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0) ) timestamp -= 86400;
        year++;
    }

    if ( ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0) )
        days_of_month[1] = 29;
    else
        days_of_month[1] = 28;


    while(timestamp>86400){
        timestamp -= 86400, day++;
        if (day==days_of_month[month]) day=0, month++;
    }

    while(timestamp>60){
        timestamp -= 60, mins++;
        if ( mins == 60) mins=0, hour++;
    }

    sec=timestamp;

    switch( _form ){
        case 1: format(returnstring, 31, "%02d/%02d/%d %02d:%02d", day+1, month+1, year, hour, mins);
        case 2: format(returnstring, 31, "%s %02d, %d, %02d:%02d:%02d", names_of_month[month],day+1,year, hour, mins, sec);
        case 3: format(returnstring, 31, "%d %c%c%c %d, %02d:%02d", day+1,names_of_month[month][0],names_of_month[month][1],names_of_month[month][2], year,hour,mins);

        default: format(returnstring, 31, "%02d.%02d.%d-%02d:%02d:%02d", day+1, month+1, year, hour, mins, sec);
    }

    return returnstring;
}


GetPlayerGPS(playerid)
{
	new location[MAX_ZONE_NAME],
		Float:x, Float:y, Float:z,
		string[240];

	GetPlayerPos(playerid, x, y, z);
	GetZone(x, y, location, MAX_ZONE_NAME);

	if (IsPlayerInAnyDynamicArea(playerid)) 
	{
		new areas[5], street_area[2], j = GetPlayerNumberDynamicAreas(playerid);
		GetPlayerDynamicAreas(playerid, areas, sizeof(areas));

		if (GetStreet(areas, j, street_area)) 
		{
			if (street_area[1] == -1)
			{
				format(string, sizeof(string), "%s~n~%s.", location, street_names[street_area[0]]);
				PlayerTextDrawSetString(playerid, PlayerGPS[playerid][1], string);
				return 1;
			}
				
		}
	}
	format(string, sizeof(string), "%s", location);
	PlayerTextDrawSetString(playerid, PlayerGPS[playerid][1], string);
	return 1;
}

/*stock GetPlayerSpeed(playerid)
{
    new Float:ST[4];
    if(IsPlayerInAnyVehicle(playerid))
    GetVehicleVelocity(GetPlayerVehicleID(playerid),ST[0],ST[1],ST[2]);
    else GetPlayerVelocity(playerid,ST[0],ST[1],ST[2]);
    ST[3] = floatsqroot(floatpower(floatabs(ST[0]), 2.0) + floatpower(floatabs(ST[1]), 2.0) + floatpower(floatabs(ST[2]), 2.0)) * 179.28625;
    return floatround(ST[3]);
}*/

Float:GetPlayerSpeed(playerid)
{
    new Float:vX, Float:vY, Float:vZ;
    GetPlayerVelocity(playerid, vX, vY, vZ);
    return floatsqroot(floatpower(vX, 2) + floatpower(vY, 2) + floatpower(vZ, 2)) * 100;
}
