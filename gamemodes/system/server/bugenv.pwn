// Includes được tạo vào 5:30 PM / 18-04-2023 bởi Jonhien //

#include <YSI\y_hooks>

#define BugChecking 	17184
#define SelectTeleport 	17185

new PlayerBugging[MAX_PLAYERS],
    BugTime[MAX_PLAYERS];

hook OnPlayerConnect(playerid)
{
	PlayerBugging[playerid] = 0;
    BugTime[playerid] = 0;
}

hook OnPlayerDisconnect(playerid)
{
	PlayerBugging[playerid] = 0;
    BugTime[playerid] = 0;
}


hook OnPlayerUpdate(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		new Float: x, Float:y, Float: z;
		GetPlayerPos(playerid, x, y, z);
        new anim_index = GetPlayerAnimationIndex(playerid);
		if(PlayerBugging[playerid] == 0 && anim_index == 1130 && z < -20.0)
		{
            CA_FindZ_For2DCoord(x, y, z);
            SetPlayerPos(playerid, x, y, z);
            ShowPlayerDialog(playerid, BugChecking, DIALOG_STYLE_MSGBOX, "[LS:RP] Checking Player Bugging ...", "He thong 'LS:RP Checking' dang phat hien ban gap van de ve Bug Map.\nVui long chon 'Report' de cho su giup do cua Admin.", "Report", "<");
			TogglePlayerControllable(playerid, 0);
            SetPVarInt(playerid, "IsFrozen", 1);
			return 1;
		}
	}
    return 1;
}

stock CA_FindZ_For2DCoordEx(Float:x, Float:y, &Float:z)
{
    if(CA_RayCastLine(x, y, z+3, x, y, z-3, x, y, z)) return 1; 
    return 0;
}
hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == BugChecking)
    {
        if(response) 
        {
        	new string[514];
        	format(string, sizeof(string), "[LS:RP-CPB] Nguoi choi %s (%i) dang gap van de ve Bug Map (/clearcpb %i & dich chuyen ho).", GetPlayerNameEx(playerid), playerid, playerid);
           	ABroadCast(COLOR_LIGHTRED, string, 2);
            PlayerBugging[playerid] = 1;
           	SendClientMessage(playerid, COLOR_GREEN, "Sau 10 giay neu khong co Admin ho tro, ban se co quyen dich chuyen.");
           	BugTime[playerid] = SetTimerEx("SelectionTeleport", 10000, 0, "i", playerid);
        }
    }
    if(dialogid == SelectTeleport)
    {
        if(response) 
        {
        	switch(listitem)
            { 
                case 0: // Rockford Plaza @ Little Mexico
                {
                	new string[514];
                	SetPlayerPos(playerid, 1721.0751, -1724.2994, 13.54);
                	SetPlayerFacingAngle(playerid, 182.4);
                	SendClientMessage(playerid, COLOR_CHAT, "{6084BD}[LS:RP-CPB]{9E9E9E} Ban da duoc he thong dich chuyen ve '{6084BD}Rockford Plaza{9E9E9E} tai {6084BD}Little Mexico{9E9E9E}'.");
                	format(string, sizeof(string), "[LS:RP-CPB] Nguoi choi %s (%i) da duoc he thong ho tro dich chuyen ve Rockford Plaza.", GetPlayerNameEx(playerid), playerid, playerid);
         		  	ABroadCast(COLOR_LIGHTRED, string, 2);
         		  	SetTimerEx("UnfreezePlayer", 1000, 0, "i", playerid);
                }
                case 1:
                {
                	new string[514];
                	SetPlayerPos(playerid, 1480.71, -1739.06, 13.54);
                	SetPlayerFacingAngle(playerid, 1.37);
                	SendClientMessage(playerid, COLOR_CHAT, "{6084BD}[LS:RP-CPB]{9E9E9E} Ban da duoc he thong dich chuyen ve '{6084BD}City Hall{9E9E9E} tai {6084BD}Pershing Square{9E9E9E}'.");
                	format(string, sizeof(string), "[LS:RP-CPB] Nguoi choi %s (%i) da duoc he thong ho tro dich chuyen ve City Hall.", GetPlayerNameEx(playerid), playerid, playerid);
         		  	ABroadCast(COLOR_LIGHTRED, string, 2);
         		  	PlayerBugging[playerid] = 0;
         		  	SetTimerEx("UnfreezePlayer", 1000, 0, "i", playerid);
                }
            }
        }
        else if(!response)
        {
            PlayerBugging[playerid] = 0;
            /*ShowPlayerDialog(playerid, SelectTeleport, DIALOG_STYLE_TABLIST_HEADERS, "[LS:RP - CPB] Lua chon vi tri dich chuyen",
                                "Dia diem\tVi tri\n\
                                Rockford Plaza\tLittle Mexico\n\
                                City Hall\tPershing Square",
                                ">", "");*/
        }
    }
	return 1;
}

forward SelectionTeleport(playerid);
public SelectionTeleport(playerid)
{
	ShowPlayerDialog(playerid, SelectTeleport, DIALOG_STYLE_TABLIST_HEADERS, "[LS:RP - CPB] Lua chon vi tri dich chuyen",
								"Dia diem\tVi tri\n\
								Rockford Plaza\tLittle Mexico\n\
								City Hall\tPershing Square",
								">", "");
	return 1;
}

forward UnfreezePlayer(playerid);
public UnfreezePlayer(playerid)
{
	DeletePVar(playerid, "IsFrozen");
    DeletePVar(playerid, "PlayerCuffed");
    PlayerCuffed[playerid] = 0;
    PlayerTied[playerid] = 0;
    TogglePlayerControllable(playerid, 1);
    PlayerBugging[playerid] = 0;
}

CMD:clearcpb(playerid, params[])
{
    if (PlayerInfo[playerid][pAdmin] >= 2)
    {
        new string[128], giveplayerid;
        if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_CHAT, "{873D37}SU DUNG:{9E9E9E} /clearcpb [playerid]");


        if(IsPlayerConnected(giveplayerid) && PlayerBugging[giveplayerid] == 1)
        {
            DeletePVar(giveplayerid, "IsFrozen");
            DeletePVar(giveplayerid, "PlayerCuffed");
            PlayerCuffed[giveplayerid] = 0;
            PlayerTied[giveplayerid] = 0;
            TogglePlayerControllable(giveplayerid, 1);
            PlayerBugging[giveplayerid] = 0;
            format(string, sizeof(string), "{6084BD}[Clear-CPB]{9E9E9E} Ban da Clear CPB cua %s (%i).",GetPlayerNameEx(giveplayerid), giveplayerid);
            SendClientMessage(playerid, COLOR_CHAT, string);
            KillTimer(BugTime[giveplayerid]);
        }
        else
        {
            SendClientMessageEx(playerid, COLOR_CHAT, "Nguoi choi khong hop le.");
        }

    }
    else
    {
        SendClientMessageEx(playerid, COLOR_LIGHTRED, "Ban khong duoc phep su dung lenh nay.");
    }
    return 1;
}