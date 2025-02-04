#include <a_samp>
#include <YSI\y_hooks>

new SendClientText[MAX_PLAYERS];

new Text:payday_TD;
hook OnGameModeInit()
{


    payday_TD = TextDrawCreate(502.0833, 99.7778, "Ban_da_co_the_~p~/payday~w~_de_nhan_luong."); // ïóñòî
    TextDrawLetterSize(payday_TD, 0.1875, 1.3562);
    TextDrawTextSize(payday_TD, 656.0000, 0.0000);
    TextDrawAlignment(payday_TD, 1);
    TextDrawColor(payday_TD, -1);
    TextDrawSetOutline(payday_TD, 1);
    TextDrawBackgroundColor(payday_TD, 255);
    TextDrawFont(payday_TD, 1);
    TextDrawSetProportional(payday_TD, 1);
    TextDrawSetShadow(payday_TD, 0);



}

stock SendClientTextDraw(playerid) // send payday
{
    if(GetPVarInt(playerid, "IsShowText") == 1) KillTimer(SendClientText[playerid]);
    TextDrawSetString(payday_TD, "Ban_da_co_the_~p~/payday~w~_de_nhan_luong.");
    TextDrawShowForPlayer(playerid, payday_TD);
    SendClientText[playerid] = SetTimerEx("ClosedClientText", 3000, 0, "d", playerid);
    SetPVarInt(playerid, "IsShowText", 1);
    return 1;
}
forward ClosedClientText(playerid);
public ClosedClientText(playerid)
{
    TextDrawHideForPlayer(playerid, payday_TD);
    DeletePVar(playerid, "IsShowText");
    return 1;
}

