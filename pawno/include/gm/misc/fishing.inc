#define MAX_FISH_ZONES 11

new gz_fish[MAX_FISH_ZONES];

new Float: fish_pos[MAX_FISH_ZONES][4] =
{
	{1920.0, -218.0, 2070.0, -66.0},
	{2070.0, -218.0, 2230.0, -166.0},
	{2070.0, -167.0, 2127.0, -132.0},
	{2070.0, -74.0, 2106.0, -14.0},
	{2070.0, -132.0, 2095.0, -74.0},
	{-315.0, -683.0, -172.0, -454.0},
	{-172.0, -683.0, -117.0, -583.0},
	{-272.0, -744.0, -130.0, -683.0},
	{-172.0, -583.0, -134.0, -510.0},
	{-1303.0, -1990.0, -1230.0, -1913.0},
	{-517.0, 1095.0, -436.0, 1184.0}
};

new fish_names[9][20] =
{
	{"Ca map"},
	{"Tong so"},
	{"Ca chep"},
	{"Ca ngu"},
	{"Ca hong"},
	{"Ca doi"},
	{"Ca ro"},
	{"Con rua"},
	{"Ca hoi"}
};

Fish_Init()
{
	for(new i; i < MAX_FISH_ZONES; i++)
	{
    	gz_fish[i] = GangZoneCreate(fish_pos[i][0], fish_pos[i][1], fish_pos[i][2], fish_pos[i][3]);
    	GangZoneHideForAll(gz_fish[i]);
	}
	return 1;
}

CMD:myfish(playerid, params[])
{
	SendSyntaxMessage(playerid, "Ban da cau duoc %iLBs.", PlayerInfo[playerid][pFishCount]);
	if (PlayerInfo[playerid][pFishCount] >= 300)
	{
		return SendSyntaxMessage(playerid, "Su dung /unloadfish de giao ca. ");
	}
	return 1;
}

CMD:stopfish(playerid, params[])
{
    if (pTemp[playerid][pFishTime] == 0) return SendErrorMessage(playerid, "Ban khong cau ca.");

    pTemp[playerid][pFishTime] = 0;
    StopPlayerAnims(playerid);
	return 1;
}

CMD:unloadfish(playerid, params[])
{
	if (!PlayerToPoint(4,playerid,2478.0762,-2707.8352,3.0000))
	{
		SendFishMessage(playerid, "Ban khong o dia diem giao ca.");
		InfoMSG(playerid, "Da danh dau ~r~(/removecp)", 3);
		Waypoint_Set(playerid, 2478.0762, -2707.8352, 3.0000, 8.0);
		return 1;
	}

	if (PlayerInfo[playerid][pFishTime] > gettime())	return SendErrorMessage(playerid, "Ban co the dua ca trong %s.", ConvertSecond(PlayerInfo[playerid][pFishTime] - gettime()));
	if (PlayerInfo[playerid][pFishCount] < 300)			return SendErrorMessage(playerid, "Ban khong co du ca. So luong toi thieu la 300LBs.");

    new money = floatround(0.7 * float(PlayerInfo[playerid][pFishCount]));

	GiveCash(playerid, money);
	PlayerInfo[playerid][pFishCount] = 0;
	PlayerInfo[playerid][pFishTime] = gettime() + 2400;
	SendSyntaxMessage(playerid, "Ban da giao %iLBs - Ban nhan duoc $%i.", PlayerInfo[playerid][pFishCount], money);
	SendHelpMessage(playerid, "Ban hay cho 40 phut sau de co the tiep tuc cau ca. ");
	return 1;
}
Fishzone_Ongamemodeint() {
	CreateDynamic3DTextLabel("Noi ban can cau\n/muacancau", -1, 2103.0085,-102.9412,2.2724, 100);
}
CMD:muacancau(playerid,params[]) {
	if(!IsPlayerInRangeOfPoint(playerid, 5, 2103.0085,-102.9412,2.2724)) return SendErrorMessage(playerid,"Ban khong o gan noi ban can cau");
	if(PlayerInfo[playerid][pCash] < 75) return SendErrorMessage(playerid,"Ban khong co can cau.");
	new i = -1;

	if ((i = GetNextToySlot(playerid)) == -1)	return SendErrorMessage(playerid, "Tat ca vi tri quan ao da duoc chinh sua.");
 	new listitem = 0;
	SetPlayerAttachedObject(playerid, i, HardwareStore[listitem][toyModel], HardwareStore[listitem][toyBone], HardwareStore[listitem][toyOffestX], HardwareStore[listitem][toyOffestY], HardwareStore[listitem][toyOffestZ], 
	HardwareStore[listitem][toyRotX], HardwareStore[listitem][toyRotY], HardwareStore[listitem][toyRotZ], HardwareStore[listitem][toyScaleX], HardwareStore[listitem][toyScaleY], HardwareStore[listitem][toyScaleZ]);
    EditAttachedObject(playerid, i);
	SetPVarInt(playerid, #buy_attach, HardwareStore[listitem][toyPrice]);
	InsertPlayerAttach(playerid, i, HardwareStore[listitem][toyModel], HardwareStore[listitem][toyBone], HardwareStore[listitem][toyName]);
	return 1;
}
CMD:fishzone(playerid, params[])
{
	if (GetPVarInt(playerid, #show_fish) == 1)
	{
	    DeletePVar(playerid, #show_fish);
		for(new i; i < MAX_FISH_ZONES; i++) GangZoneHideForPlayer(playerid, gz_fish[i]);

	    SendSyntaxMessage(playerid, "Cac diem cau ca bi an.");
	    return 1;
	}

	SetPVarInt(playerid, #show_fish, 1);
	for(new i; i < MAX_FISH_ZONES; i++) GangZoneShowForPlayer(playerid, gz_fish[i], 0xFF0000AA);

	SendSyntaxMessage(playerid, "Cac diem cau ca duoc danh dau tren ban do bang cac vung mau do (ESC> Maps).");
	return 1;
}

CMD:fish(playerid, params[])
{
    if (PlayerInfo[playerid][pFishCount] >= 1000) 			return SendErrorMessage(playerid, "Ban khong the cau ca nua.");
	if (pTemp[playerid][pFishTime] != 0)					return SendErrorMessage(playerid, "Ban da cau ca.");
	if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)	return SendErrorMessage(playerid, "Ban phai o ben ngoai xe.");
	    
	new id = -1;

	for(new i; i != MAX_PLAYER_ATTACH; i++)
	{
	    if (!AttachInfo[playerid][i][aID] || AttachInfo[playerid][i][aModel] != 18632 || !AttachInfo[playerid][i][aUsed]) continue;

		id = i;
		break;
	}

	if (id == -1) return SendErrorMessage(playerid, "Ban phai co mot chiec can cau."); //������

	id = -1;

	for(new i; i != 4; i++)
	{
	    if (!IsPlayerInCube(playerid, fish_pos[i][0], fish_pos[i][1], fish_pos[i][2], fish_pos[i][3])) continue;

		id = i;
		break;
	}

    if (id == -1) return SendErrorMessage(playerid, "Ban phai o mot diem cau ca thich hop (/fishzone).");

	new veh = 0;

	if (id && ((veh = GetNearVehicle(playerid, 5.0)) == 0 || !IsABoat(veh)))	return SendErrorMessage(playerid, "Ban phai o gan thuyen.");
	if (!OnPlayAnim(playerid, "SWORD", "SWORD_BLOCK", 4.1, 0, 0, 0, 1, 0))		return SendErrorMessage(playerid, "Ban khong the cau ca vi dang su dung hanh dong.");

	pTemp[playerid][pFishTime] = 10 + random(10);
	GameTextForPlayer(playerid, "~w~CAU CA...", pTemp[playerid][pFishTime] * 1000, 6);
	return 1;
}

