// Includes được tạo vào 6:30 PM / 18-04-2023 bởi Jonhien //

#include <YSI\y_hooks>

#define    DIALOG_BUGDOOR   19184
#define    DIALOG_BUGHOUSE  19185
new PlayerBugging[MAX_PLAYERS];
new SavePickupID[MAX_PLAYERS];

hook OnPlayerConnect(playerid)
{
    SavePickupID[playerid] = 0;
}

hook OnPlayerDisconnect(playerid)
{
    SavePickupID[playerid] = 0;
}

hook OnPlayerUpdate(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		new Float: x, Float:y, Float: z;
		GetPlayerPos(playerid, x, y, z);
        new vw = GetPlayerVirtualWorld(playerid);
        new anim_index = GetPlayerAnimationIndex(playerid);
        if(vw > 6000)
        {
            for(new i; i < MAX_HOUSES; i++)
            {
                if(PlayerBugging[playerid] == 0 && anim_index == 1130 && IsPlayerInRangeOfPoint(playerid, 10, HouseInfo[i][hInteriorX], HouseInfo[i][hInteriorY], HouseInfo[i][hInteriorZ]) && HouseInfo[i][hIntVW] == PlayerInfo[playerid][pVW])
                {
                    SetTimerEx("BugIntHouse", 2000, 0, "i", playerid);
                    PlayerBugging[playerid] = 1;
                    SavePickupID[playerid] = i;
                    //new string[514];
                    //format(string, sizeof(string), "House: %d", SavePickupID[playerid]);
                    //SendClientMessage(playerid, COLOR_CHAT, string);
                    return 1;
                }
            }
            return 1;
        }
        for(new i; i < MAX_DDOORS; i++)
        {
    		if(PlayerBugging[playerid] == 0 && anim_index == 1130 && IsPlayerInRangeOfPoint(playerid, 10, DDoorsInfo[i][ddInteriorX], DDoorsInfo[i][ddInteriorY], DDoorsInfo[i][ddInteriorZ]) && DDoorsInfo[i][ddInteriorVW] == PlayerInfo[playerid][pVW])
    		{
    			SetTimerEx("BugIntDoor", 2000, 0, "i", playerid);
                PlayerBugging[playerid] = 1;
                SavePickupID[playerid] = i;
                //new string[514];
                //format(string, sizeof(string), "Door: %d", SavePickupID[playerid]);
                //SendClientMessage(playerid, COLOR_CHAT, string);
    			return 1;
    		}
	    }
    }
    return 1;
}

forward BugIntHouse(playerid);
public BugIntHouse(playerid)
{
    new string[514];
    format(string, sizeof(string), "{9E9E9E}He thong '{6084BD}LS:RP - Checking Player Buging{9E9E9E}' da phat hien ban dang bi {873D37}Bug House (%d){9E9E9E}.\n\
                                    Vui long chon {6084BD}Interior{9E9E9E} hoac {6084BD}Exterior{9E9E9E} de dich chuyen.", SavePickupID[playerid]);
    ShowPlayerDialog(playerid, DIALOG_BUGHOUSE, DIALOG_STYLE_MSGBOX, "[LS:RP] Checking Player Bugging ...", string, "Interior", "Exterior");
    TogglePlayerControllable(playerid, 0);
    SetPVarInt(playerid, "IsFrozen", 1);
    return 1;
}

forward BugIntDoor(playerid);
public BugIntDoor(playerid)
{
    new string[514];
    format(string, sizeof(string), "{9E9E9E}He thong '{6084BD}LS:RP - Checking Player Buging{9E9E9E}' da phat hien ban dang bi {873D37}Bug Door (%d){9E9E9E}.\n\
                                    Vui long chon {6084BD}Interior{9E9E9E} hoac {6084BD}Exterior{9E9E9E} de dich chuyen.", SavePickupID[playerid]);
    ShowPlayerDialog(playerid, DIALOG_BUGDOOR, DIALOG_STYLE_MSGBOX, "[LS:RP] Checking Player Bugging ...", string, "Interior", "Exterior");
    TogglePlayerControllable(playerid, 0);
    SetPVarInt(playerid, "IsFrozen", 1);
    return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_BUGDOOR)
    {
        if(response) 
        {
            new teledoor = SavePickupID[playerid];
            SetPlayerInterior(playerid,DDoorsInfo[teledoor][ddInteriorInt]);
            SetPlayerPos(playerid,DDoorsInfo[teledoor][ddInteriorX],DDoorsInfo[teledoor][ddInteriorY],DDoorsInfo[teledoor][ddInteriorZ]);
            SetPlayerFacingAngle(playerid,DDoorsInfo[teledoor][ddInteriorA]);
            PlayerInfo[playerid][pInt] = DDoorsInfo[teledoor][ddInteriorInt];
            PlayerInfo[playerid][pVW] = DDoorsInfo[teledoor][ddInteriorVW];
            SetPlayerVirtualWorld(playerid, DDoorsInfo[teledoor][ddInteriorVW]);
            if(DDoorsInfo[teledoor][ddCustomInterior]) Player_StreamPrep(playerid, DDoorsInfo[teledoor][ddInteriorX],DDoorsInfo[teledoor][ddInteriorY],DDoorsInfo[teledoor][ddInteriorZ], FREEZE_TIME);
            SetTimerEx("UnfreezeBugInt", 3000, 0, "i", playerid);
        }
        if(!response) 
        {
            new teledoor = SavePickupID[playerid];
            SetPlayerInterior(playerid,DDoorsInfo[teledoor][ddExteriorInt]);
            SetPlayerPos(playerid, DDoorsInfo[teledoor][ddExteriorX],DDoorsInfo[teledoor][ddExteriorY],DDoorsInfo[teledoor][ddExteriorZ]);
            SetPlayerFacingAngle(playerid,DDoorsInfo[teledoor][ddExteriorA]);
            PlayerInfo[playerid][pInt] = DDoorsInfo[teledoor][ddExteriorInt];
            SetPlayerVirtualWorld(playerid, DDoorsInfo[teledoor][ddExteriorVW]);
            PlayerInfo[playerid][pVW] = DDoorsInfo[teledoor][ddExteriorVW];
            if(DDoorsInfo[teledoor][ddCustomExterior]) Player_StreamPrep(playerid, DDoorsInfo[teledoor][ddExteriorX],DDoorsInfo[teledoor][ddExteriorY],DDoorsInfo[teledoor][ddExteriorZ], FREEZE_TIME);
            SetTimerEx("UnfreezeBugInt", 3000, 0, "i", playerid);
        }
    }
    else if(dialogid == DIALOG_BUGHOUSE)
    {
        if(response) 
        {
            new teledoor = SavePickupID[playerid];
            SetPlayerInterior(playerid,HouseInfo[teledoor][hIntIW]);
            SetPlayerPos(playerid, HouseInfo[teledoor][hInteriorX], HouseInfo[teledoor][hInteriorY], HouseInfo[teledoor][hInteriorZ]);
            PlayerInfo[playerid][pInt] = HouseInfo[teledoor][hIntIW];
            PlayerInfo[playerid][pVW] = HouseInfo[teledoor][hIntVW];
            SetPlayerVirtualWorld(playerid,HouseInfo[teledoor][hIntVW]);
            if(HouseInfo[teledoor][hCustomInterior] == 1) Player_StreamPrep(playerid, HouseInfo[teledoor][hInteriorX],HouseInfo[teledoor][hInteriorY],HouseInfo[teledoor][hInteriorZ], FREEZE_TIME);
            SetTimerEx("UnfreezeBugInt", 3000, 0, "i", playerid);
        }
        if(!response) 
        {
            new teledoor = SavePickupID[playerid];
            SetPlayerPos(playerid, HouseInfo[teledoor][hExteriorX], HouseInfo[teledoor][hExteriorY], HouseInfo[teledoor][hExteriorZ]);
            SetPlayerInterior(playerid,HouseInfo[teledoor][hExtIW]);
            PlayerInfo[playerid][pInt] = HouseInfo[teledoor][hExtIW];
            PlayerInfo[playerid][pVW] = HouseInfo[teledoor][hExtVW];
            SetPlayerVirtualWorld(playerid,HouseInfo[teledoor][hExtVW]);
            SetTimerEx("UnfreezeBugInt", 3000, 0, "i", playerid);
        }
    }
    return 1;
}

forward UnfreezeBugInt(playerid);
public UnfreezeBugInt(playerid)
{
    DeletePVar(playerid, "IsFrozen");
    DeletePVar(playerid, "PlayerCuffed");
    PlayerCuffed[playerid] = 0;
    PlayerTied[playerid] = 0;
    TogglePlayerControllable(playerid, 1);
    PlayerBugging[playerid] = 0;
    SavePickupID[playerid] = 0;
    PlayerInfo[playerid][pInjured] = 0;
}