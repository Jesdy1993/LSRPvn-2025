#include <YSI\y_hooks>



new BV_Carry[MAX_PLAYERS];
new BV_Checkpoint[MAX_PLAYERS];


hook OnGameModeInit()
{
    CreateActor(163, 2075.9358,-2016.8898,13.5469,268.7524);
    CreateDynamic3DTextLabel("< WORKER >\nBam 'Y' de thao tac xin viec",COLOR_BASIC,2075.9358,-2016.8898,13.5469,6.0);
    CreateDynamic3DTextLabel("[BOC VAC]\nAn 'Y' de lay hang",COLOR_BASIC,2093.7747,-2033.4962,13.5469,6.0);
    CreateDynamicPickup(1271, 23, 2093.7747,-2033.4962,13.5469, -1);
}


hook OnPlayerDisconnect(playerid)
{
    BV_Checkpoint[playerid] = 0;
    BV_Carry[playerid] = 0;
    RemovePlayerAttachedObject(playerid, 1);
    ClearAnimations(playerid);
}

hook OnPlayerConnect(playerid)
{
    BV_Checkpoint[playerid] = 0;
    BV_Carry[playerid] = 0;
}

hook OnPlayerEnterCheckpoint(playerid)
{
    if(BV_Checkpoint[playerid] && BV_Carry[playerid] && IsPlayerInRangeOfPoint(playerid, 5.0, 2054.6377,-2083.0051,13.5469))
    {
        DisablePlayerCheckpoint(playerid);
        BV_Checkpoint[playerid] = 0;
        BV_Carry[playerid] = 0;
        new string[158];
        new rdcash = random(20) + 8;
        GivePlayerMoneyEx(playerid, rdcash);
        RemovePlayerAttachedObject(playerid, 1);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        ClearAnimations(playerid);

        PlayerInfo[playerid][pCountWork]++;
        format(string, sizeof(string), "[WORKER-JOB] Ban da nhan duoc $%s cho lan nay.",number_format(rdcash));
        SendClientMessageEx(playerid, -1, string);
        new string_log[229];
        format(string_log, sizeof(string_log), "[%s] %s đã giao hàng thành công và nhận được $%s", GetLogTime(),GetPlayerNameEx(playerid),number_format(rdcash));         
        SendLogDiscordMSG(job_Worker, string_log);
    }
}
Dialog:DIALOG_WORKER(playerid, response, listitem, inputtext[]) {
    if(response) {
        if(listitem == 0) {
            if(PlayerInfo[playerid][pJob] != 0) return SendClientMessage(playerid, COLOR_BASIC, "Ban dang nhan cong viec khac, hay nghi viec de tiep tuc thuc hien.");
            PlayerInfo[playerid][pJob] = 23;
            SendClientMessage(playerid, COLOR_BASIC, "[WORKER-JOB] Ban da nhan viec {46ad58}Worker{b4b4b4}, su dung /trogiup > cong viec > Worker.");
        }
        if(listitem == 1) {
            if(PlayerInfo[playerid][pJob] == 0) return SendClientMessage(playerid, COLOR_BASIC, "Ban khong nhan cong viec nao khong the nghi viec.");
            ShowQuitJob(playerid);
        }
    }
    return 1;
}
hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(newkeys & KEY_YES)
    {
        if(IsPlayerInRangeOfPoint(playerid, 3.0, 2075.9358,-2016.8898,13.5469))
        {
            Dialog_Show(playerid, DIALOG_WORKER, DIALOG_STYLE_TABLIST, "Cong viec Worker", "> Xin viec\t#\nThoat viec\t#", "Tuy chon","Thoat");
        }
        if(IsPlayerInRangeOfPoint(playerid, 3.0, 2093.7747,-2033.4962,13.5469) && !BV_Carry[playerid] && PlayerInfo[playerid][pJob] == 23)
        {
            BV_Carry[playerid] = 1;
            BV_Checkpoint[playerid] = 1;
            ApplyAnimation(playerid, "CARRY", "liftup105", 4.1, 0, 0, 0, 0, 0);
            SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
            SetPlayerAttachedObject(playerid, 1, 1271, 6, 0.077999, 0.043999, -0.170999, -13.799953, 79.70, 0.0);
            SetPlayerCheckpoint(playerid, 2054.6377,-2083.0051,13.5469, 2.5);
            SendClientMessageEx(playerid, -1, "{FFC800}BOC VAC JOB: {FFFFFF}Ban da lay hang thanh cong, hay giao den Checkpoint mau do."); 

        }
    }    
    return 1;
}


