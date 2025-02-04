#include <YSI_Coding\y_hooks>



CMD:accent(playerid, params[])
{
    new noidung[64], string[128];
    if(sscanf(params, "s[64]", noidung))
    {
        SendClientMessageEx(playerid, COLOR_CHAT, " /accent [tuy chon]");
        SendClientMessageEx(playerid, COLOR_CHAT, "{6084BD}Vi du:{9E9E9E} Mexico, Canada, Korea, Vietnam... (Neu xoa hay nhap 'None')");
        return 1;
    }
    if(strlen(noidung) > 64) return ShowNotifyTextMain(playerid, "~w~Ban chi duoc phep nhap duoi ~r~64 ky tu~w~.");
    strmid(PlayerInfo[playerid][pGiongNoi], noidung, 0, strlen(noidung), 64);
    format(string, sizeof(string), "{40703f}> Accent:{9E9E9E} Ban da thay doi giong noi cua ban thanh {40703f}%s{9E9E9E}.", noidung);
    SendClientMessageEx(playerid, COLOR_CHAT, string);
    return 1;
}

CMD:my(playerid, params[])
{
    new choice[32];
    if(sscanf(params, "s[32]", choice))
    {
        SendClientMessageEx(playerid, COLOR_CHAT, " /my [tuy chon]");
        SendClientMessageEx(playerid, COLOR_WHITE, "{c7d5d8}OPTION{ffffff}: veh | inv | infor | idcard | job | question");
        SendClientMessageEx(playerid, COLOR_WHITE, "{c7d5d8}OPTION{ffffff}: gun | acc(essory) | clothes | jobstats");
        SendClientMessageEx(playerid, COLOR_WHITE, "{c7d5d8}OPTION{ffffff}: license");
        return 1;
    }
    if(strcmp(choice,"acc",true) == 0) {
        if(GetPVarInt(playerid, "EventToken" ) == 1) return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong the su dung lenh nay ngay bay gio.");
        ShowPlayerDialog( playerid, TOYS, DIALOG_STYLE_TABLIST, "Accessory - Select", "Deo/thao phu kien\t#\nChinh sua phu kien\t#\nXoa phu kien\t#","Lua chon", "Huy bo" );

    } 
    else if(strcmp(choice,"drugstats",true) == 0) {
        if(PlayerMaxDrugTask[playerid] == 0) return SendErrorMessage(playerid, " Nhan vat ban chua nghien.");
        ShowDrugStats(playerid);
    }
    else if(strcmp(choice,"jobstats",true) == 0) {
        ShowPlayerJobStats(playerid);
    }
    else if(strcmp(choice,"license",true) == 0) {
        new string[128], text1[30], text2[30], text3[30], text4[30];
        if(PlayerInfo[playerid][pCarLic]) { text1 = "{446544}Acquired"; } else { text1 = "{654447}Not acquired"; }
        if(PlayerInfo[playerid][pFlyLic]) { text4 = "{446544}Acquired"; } else { text4 = "{654447}Not acquired"; }
        if(PlayerInfo[playerid][pBoatLic]) { text2 = "{446544}Acquired"; } else { text2 = "{654447}Not acquired"; }
        if(PlayerInfo[playerid][pTaxiLicense]) { text3 = "{446544}Acquired"; } else { text3 = "{654447}Not acquired"; }
        SendClientMessageEx(playerid, COLOR_WHITE, "Your licenses...");
        format(string, sizeof(string), "** Giay phep lai xe: %s.", text1);
        SendClientMessageEx(playerid, COLOR_BASIC, string);
        format(string, sizeof(string), "** Giay phep may bay: %s.", text4);
        SendClientMessageEx(playerid, COLOR_BASIC, string);
        format(string, sizeof(string), "** Giay phep thuyen: %s.", text2);
        SendClientMessageEx(playerid, COLOR_BASIC, string);
        format(string, sizeof(string), "** Giay phep taxi: %s.", text3);
        SendClientMessageEx(playerid, COLOR_BASIC, string);
    }
    else if(strcmp(choice,"clothes",true) == 0) {
        cmd_playerclothes(playerid);
    }
    else if(strcmp(choice,"inv",true) == 0) {
        if( PlayerCuffed[playerid] >= 1 || GetPVarInt(playerid, "Injured") == 1 || (PlayerInfo[playerid][pInjured] != 0 && PlayerInfo[playerid][pInjured] != 4))
        {
            SendErrorMessage(playerid, "Khong the su dung ngay luc nay.");
            return 1;
        }
        cmd_inventory(playerid,"");
    }
    else if(strcmp(choice,"job",true) == 0) {
        new string[129];
        format(string, sizeof(string), "{40703f}> JOB:{9E9E9E} Cong viec cua ban la {40703f}%s{9E9E9E}.", GetJobName(PlayerInfo[playerid][pJob]));
        SendClientMessageEx(playerid, COLOR_CHAT, string);
    }
    else if(strcmp(choice,"veh",true) == 0) {
        cmd_chinhxemyveh(playerid,"");
    }
    else if(strcmp(choice,"guns",true) == 0) {
        cmd_myguns(playerid,"");
    } 
    else if(strcmp(choice,"infor",true) == 0) {
        ShowInformation(playerid);
    }
    else if(strcmp(choice,"idcard",true) == 0) {
        ShowPlayerIDCard(playerid,playerid);
    }
    else if(strcmp(choice,"question",true) == 0) {
        ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "My Question", "Hay chu y bang huong dan ben trai man hinh\nDi den CP va lam theo cac huong dan da chi dinh de hoan thanh Tutorial", "Dong y", "Thoat");
        SetPlayerTutorial(playerid);
    }
    return 1;
}





// // =============================== STOCK =============================== //



stock ShowInformation(playerid) {
    new string[1299],org[129];
    new  employer[GROUP_MAX_NAME_LEN], rank[GROUP_MAX_RANK_LEN], division[GROUP_MAX_DIV_LEN];
    new sext[16];
    if(PlayerInfo[playerid][pSex] == 1) { sext = "Nam"; } else { sext = "Nu"; }
    if(PlayerInfo[playerid][pMember] != INVALID_GROUP_ID)
    {
        
        GetPlayerGroupInfo(playerid, rank, division, employer);
        format(org, sizeof(org), "Faction: %s (%d) | Rank: %s (%d) | Division: %s (%d)\n", employer, PlayerInfo[playerid][pMember], rank, PlayerInfo[playerid][pRank], division, PlayerInfo[playerid][pDivision]);
    }
    else if(PlayerInfo[playerid][pFMember] < INVALID_FAMILY_ID)
    {
        if(0 <= PlayerInfo[playerid][pDivision] < 5) format(division, sizeof(division), "%s", FamilyDivisionInfo[PlayerInfo[playerid][pFMember]][PlayerInfo[playerid][pDivision]]);
        else division = "None";
        format(org, sizeof(org), "Gangs: %s (%d) | Rank: %s (%d) | Division: %s (%d)\n", FamilyInfo[PlayerInfo[playerid][pFMember]][FamilyName], PlayerInfo[playerid][pFMember], FamilyRankInfo[PlayerInfo[playerid][pFMember]][PlayerInfo[playerid][pRank]], PlayerInfo[playerid][pRank], division, PlayerInfo[playerid][pDivision]);
    }
    else format(org, sizeof(org), "");

    format(string, sizeof string, "Character: %s(%d) | Master Account: %s(%d) | Level: %d | Admin Level: %d\n%s\
    Gioi tinh: %s | Sinh nhat: %s | Playing Time: %d | XP: %d\n\
    Cong viec: %s | So tai khoan: %d | ID-Card: %d | So dien thoai: %d\n\
    Company: %s", GetPlayerNameEx(playerid),PlayerInfo[playerid][pId],MasterInfo[playerid][acc_name],MasterInfo[playerid][acc_id],PlayerInfo[playerid][pLevel],PlayerInfo[playerid][pAdmin],org,
    sext,PlayerInfo[playerid][pBirthDate],PlayerInfo[playerid][pConnectHours],PlayerInfo[playerid][pXP],GetJobName(PlayerInfo[playerid][pJob]),PlayerInfo[playerid][pSoTaiKhoan],PlayerInfo[playerid][pCMND],PlayerInfo[playerid][pPnumber],
    GetCompanyName(PlayerInfo[playerid][pCompany]));
    ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Information", string, "Dong", "");
    return 1;
}

CMD:ame(playerid, params[])
{
    if(gPlayerLogged{playerid} == 0) return ShowNotifyTextMain(playerid, "Ban chua dang nhap vao may chu");
    if(PlayerInfo[playerid][pInjured] == 3) return ShowNotifyTextMain(playerid, "~w~Ban khong the thuc hienh lenh nay khi nhan vat ~r~da chet~w~.");
    if(isnull(params))return SendUsageMessage(playerid, " /ame [noi dung]");
    new mes[128], string[128];
    format(mes, sizeof(mes), "* %s %s", GetPlayerNameEx(playerid), params);

    SetPlayerChatBubble(playerid, mes, COLOR_PURPLE, 10.0, 10000);
    format(string, sizeof(string), "> %s", params);
    SendClientMessageEx(playerid, COLOR_CHAT, string);
    return 1;
}

CMD:me(playerid, params[])
{
    if(gPlayerLogged{playerid} == 0) return ShowNotifyTextMain(playerid, "Ban chua dang nhap vao may chu");
    if(PlayerInfo[playerid][pInjured] == 3) return ShowNotifyTextMain(playerid, "~w~Ban khong the thuc hienh lenh nay khi nhan vat ~r~da chet~w~.");
    if(isnull(params)) return SendUsageMessage(playerid, " /me [action]");
    new string[128];

    new name[34];
    if(UseMask[playerid] == 2 ) {
        format(name, sizeof(name), "Stranger(%d)", UseMaskCode[playerid]);
    }
    else {
        format(name, sizeof(name), "%s", GetPlayerNameEx(playerid));
    }

    format(string, sizeof(string), "* %s %s", name, params);
    ProxDetectorWrap(playerid, string, 92, 10.0, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
    return 1;
}

CMD:melow(playerid, params[])
{
    if(gPlayerLogged{playerid} == 0) return ShowNotifyTextMain(playerid, "Ban chua dang nhap vao may chu");
    if(isnull(params)) return SendUsageMessage(playerid, " /melow [action]");
    new string[128];
    new name[34];
    if(UseMask[playerid] == 2 ) {
        format(name, sizeof(name), "Stranger(%d)", UseMaskCode[playerid]);
    }
    else {
        format(name, sizeof(name), "%s", GetPlayerNameEx(playerid));
    }
    format(string, sizeof(string), "* %s %s", name, params);
    ProxDetectorWrap(playerid, string, 92, 5.0, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
    return 1;
}

CMD:do(playerid, params[])
{
    if(gPlayerLogged{playerid} == 0) return ShowNotifyTextMain(playerid, "Ban chua dang nhap vao may chu");
    if(isnull(params)) return SendUsageMessage(playerid, " /do [action]");
    else if(strlen(params) > 120) return ShowNotifyTextMain(playerid, "~w~Ban khong the nhap hon 120 ky tu.");
    new
        iCount,
        iPos,
        iChar;

    while((iChar = params[iPos++])) {
        if(iChar == '@') iCount++;
    }
    if(iCount >= 5) {
        return ShowNotifyTextMain(playerid, "~w~Noi dung ban nhap phai tren 5 ky tu va khong co '@'.");
    }

    new string[150];
    new name[34];
    if(UseMask[playerid] == 2 ) {
        format(name, sizeof(name), "Stranger(%d)", UseMaskCode[playerid]);
    }
    else {
        format(name, sizeof(name), "%s", GetPlayerNameEx(playerid));
    }
    format(string, sizeof(string), "* %s (( %s ))", params, name);
    ProxDetectorWrap(playerid, string, 92, 10.0, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
    return 1;
}

CMD:dolow(playerid, params[])
{
    if(gPlayerLogged{playerid} == 0) return ShowNotifyTextMain(playerid, "Ban chua dang nhap vao may chu");
    if(isnull(params)) return SendUsageMessage(playerid, " /dolow [action]");
    else if(strlen(params) > 120) return ShowNotifyTextMain(playerid, "~w~Ban khong the nhap hon 120 ky tu.");
    new
        iCount,
        iPos,
        iChar;

    while((iChar = params[iPos++])) {
        if(iChar == '@') iCount++;
    }
    if(iCount >= 5) {
        return ShowNotifyTextMain(playerid, "~w~Noi dung ban nhap phai tren 5 ky tu va khong co '@'.");
    }

    new string[150];
    new name[34];
    if(UseMask[playerid] == 2 ) {
        format(name, sizeof(name), "Stranger(%d)", UseMaskCode[playerid]);
    }
    else {
        format(name, sizeof(name), "%s", GetPlayerNameEx(playerid));
    }
    format(string, sizeof(string), "* %s (( %s ))", params, name);
    ProxDetectorWrap(playerid, string, 92, 5.0, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
    return 1;
}

CMD:whisper(playerid, params[]) {
    return cmd_w(playerid, params);
}

CMD:w(playerid, params[])
{
    if(gPlayerLogged{playerid} == 0) return ShowNotifyTextMain(playerid, "Ban chua dang nhap vao may chu");
    if(PlayerInfo[playerid][pInjured] == 3) return ShowNotifyTextMain(playerid, "~w~Ban khong the thuc hienh lenh nay khi nhan vat ~r~da chet~w~.");
    new giveplayerid, whisper[128];

    if(sscanf(params, "us[128]", giveplayerid, whisper))
    {
        SendUsageMessage(playerid, "/w(hisper) [playerid] [noi dung]");
        return 1;
    }
    if (IsPlayerConnected(giveplayerid))
    {
        //f(HidePM[giveplayerid] > 0 && PlayerInfo[playerid][pAdmin] < 2) return SCM(playerid, "~w~Nguoi nay ~r~da tat~w~ Whisper.");
        new giveplayer[128], sendername[128], string[128];
        sendername = GetPlayerNameEx(playerid);
        giveplayer = GetPlayerNameEx(giveplayerid);
        if(giveplayerid == playerid)
        {
            if(PlayerInfo[playerid][pSex] == 1) format(string, sizeof(string), "* %s dang thi tham voi %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
            else format(string, sizeof(string), "* %s dang tro chuyen voi %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
            return ProxDetector(5.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
        }
        if(ProxDetectorS(5.0, playerid, giveplayerid) || PlayerInfo[playerid][pAdmin] >= 2)
        {
            foreach(new i: Player)
            {
                if(GetPVarInt(i, "BigEar") == 6 && (GetPVarInt(i, "BigEarPlayer") == playerid || GetPVarInt(i, "BigEarPlayer")  == giveplayerid))
                {
                    format(string, sizeof(string), "(BE)%s(ID %d) thi tham voi %s(ID %d): %s", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(giveplayerid), giveplayerid, whisper);
                    SendClientMessageWrap(i, COLOR_YELLOW, 92, string);
                }
            }

            format(string, sizeof(string), "%s (%d) thi tham voi ban: %s", GetPlayerNameEx(playerid), playerid, whisper);
            SendClientMessageWrap(giveplayerid, 0xE68A35FF, 92, string);

            format(string, sizeof(string), "Ban thi tham voi %s (%d): %s", GetPlayerNameEx(giveplayerid), giveplayerid, whisper);
            SendClientMessageWrap(playerid, 0xE68A35FF, 92, string);

            
            return 1;
        }
        else
        {
            ShowNotifyTextMain(playerid, "Ban khong dung gan nguoi nay.");
        }
        return 1;
    }
    else
    {
        ShowNotifyTextMain(playerid, "Nguoi nay khong ton tai.");
    }
    return 1;
}

CMD:pm(playerid, params[])
{
    if(gPlayerLogged{playerid} == 0) return ShowNotifyTextMain(playerid, "Ban chua dang nhap vao may chu");
    if(PlayerInfo[playerid][pInjured] == 3) return ShowNotifyTextMain(playerid, "~w~Ban khong the thuc hienh lenh nay khi nhan vat ~r~da chet~w~.");
    new giveplayerid, whisper[128];

    if(sscanf(params, "us[128]", giveplayerid, whisper))
    {
        SendUsageMessage(playerid, " /pm [playerid] [noi dung]");
        return 1;
    }
    if (IsPlayerConnected(giveplayerid))
    {
        if(HidePM[giveplayerid] > 0 && PlayerInfo[playerid][pAdmin] < 2) return ShowNotifyTextMain(playerid, "~w~Nguoi nay ~r~da tat~w~ Whisper.");
        new giveplayer[128], sendername[128], string[128];
        sendername = GetPlayerNameEx(playerid);
        giveplayer = GetPlayerNameEx(giveplayerid);
        // if(giveplayerid == playerid)
        // {
        //     if(PlayerInfo[playerid][pSex] == 1) format(string, sizeof(string), "* %s dang thi tham voi %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
        //     else format(string, sizeof(string), "* %s dang tro chuyen voi %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
        //     return ProxDetector(5.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
        // }
        foreach(new i: Player)
        {
            if(GetPVarInt(i, "BigEar") == 6 && (GetPVarInt(i, "BigEarPlayer") == playerid || GetPVarInt(i, "BigEarPlayer")  == giveplayerid))
            {
                format(string, sizeof(string), "(( %s (ID %d) PM: %s(ID %d): %s ))", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(giveplayerid), giveplayerid, whisper);
                SendClientMessageWrap(i, COLOR_YELLOW, 92, string);
            }
        }
        format(string, sizeof(string), "(( %s (%d) PM: %s ))", GetPlayerNameEx(playerid), playerid, whisper);
        SendClientMessageWrap(giveplayerid, 0xE68A35FF, 92, string);
        format(string, sizeof(string), "(( Ban da gui cho %s (%d) PM: %s ))", GetPlayerNameEx(giveplayerid), giveplayerid, whisper);
        SendClientMessageWrap(playerid, 0xE68A35FF, 92, string);

        return 1;
    }
    else
    {
        ShowNotifyTextMain(playerid, "Nguoi nay khong ton tai.");
    }
    return 1;
}



CMD:shout(playerid, params[]) {
    return cmd_s(playerid, params);
}

CMD:s(playerid, params[])
{
    if(gPlayerLogged{playerid} == 0) return ShowNotifyTextMain(playerid, "Ban chua dang nhap vao may chu");
    if(PlayerInfo[playerid][pInjured] > 1) return ShowNotifyTextMain(playerid, "~w~Ban khong the thuc hienh lenh nay khi nhan vat ~r~dang bi thuong~w~ hoac ~r~da chet~w~.");

    if(isnull(params)) return SendUsageMessage(playerid, " /s(hout) [noi dung]");
    new string[128];
    format(string, sizeof(string), "(het to) %s!", params);
    SetPlayerChatBubble(playerid,string,COLOR_WHITE,60.0,5000);
    new name[34];
    if(UseMask[playerid] == 2 ) {
        format(name, sizeof(name), "Stranger(%d)", UseMaskCode[playerid]);
    }
    else {
        format(name, sizeof(name), "%s", GetPlayerNameEx(playerid));
    }
    if(strcmp(PlayerInfo[playerid][pGiongNoi], "None", false)) format(string, sizeof(string), "%s (%s) het to: %s!", name, PlayerInfo[playerid][pGiongNoi], params);
    else format(string, sizeof(string), "%s het to: %s!",name, params);
    ProxDetector(30.0, playerid, string,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_FADE1,COLOR_FADE2, 1);
    return 1;
}

CMD:low(playerid, params[]) {
    return cmd_l(playerid, params);
}

CMD:l(playerid, params[])
{
    if(gPlayerLogged{playerid} == 0) return ShowNotifyTextMain(playerid, "Ban chua dang nhap vao may chu");
    if(PlayerInfo[playerid][pInjured] == 3) return ShowNotifyTextMain(playerid, "~w~Ban khong the thuc hienh lenh nay khi nhan vat ~r~da chet~w~.");
    if(isnull(params)) return SendUsageMessage(playerid, " (/l)ow [close chat]");

    new string[128];
    new name[34];
    if(UseMask[playerid] == 2 ) {
        format(name, sizeof(name), "Stranger(%d)", UseMaskCode[playerid]);
    }
    else {
        format(name, sizeof(name), "%s", GetPlayerNameEx(playerid));
    }
    format(string, sizeof(string), "%s noi nho: %s", name, params);
    ProxDetector(5.0, playerid, string,COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5, 1);
   
    if(strcmp(PlayerInfo[playerid][pGiongNoi], "None", false)) format(string, sizeof(string), "(noi nho) %s (%s) noi: %s", name, PlayerInfo[playerid][pGiongNoi], params);
    else format(string, sizeof(string), "(noi nho) %s noi: %s", name, params);
    SetPlayerChatBubble(playerid,string,COLOR_WHITE,5.0,5000);
    return 1;
}

CMD:b(playerid, params[])
{
    if(gPlayerLogged{playerid} == 0) return ShowNotifyTextMain(playerid, "Ban chua dang nhap vao may chu");
    if(isnull(params)) return SendUsageMessage(playerid,  " /b [noi dung]");
    new string[128];

    if(PlayerInfo[playerid][pAdmin] >= 1)
    {
        new Float: f_playerPos[3];
        GetPlayerPos(playerid, f_playerPos[0], f_playerPos[1], f_playerPos[2]);
        foreach(new i: Player)
        {
            format(string, sizeof(string), "(( [%d] {E88707}%s{E6E6E6}: %s ))", playerid, GetPlayerNameEx(playerid), params);
        }
        ProxDetector(20.0, playerid, string,COLOR_FADE1,COLOR_FADE1,COLOR_FADE1,COLOR_FADE1,COLOR_FADE1);
        return 1;
    }
    else
    {
        format(string, sizeof(string), "(( [%d] %s: %s ))", playerid, GetPlayerNameEx(playerid), params);
        ProxDetector(20.0, playerid, string,COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5);
    }
    return 1;
}


CMD:dchat(playerid, params[])
{
    if(gPlayerLogged{playerid} == 0) return ShowNotifyTextMain(playerid, "Ban chua dang nhap vao may chu");
    if(PlayerInfo[playerid][pInjured] == 3) return ShowNotifyTextMain(playerid, "~w~Ban khong the thuc hienh lenh nay khi nhan vat ~r~chet~w~.");
	if(isnull(params)) return SendUsageMessage(playerid, "/dchat [noi dung]");
	new string[128], stringz[128];
	for(new i = 0; i < sizeof(DDoorsInfo); i++)
    {
		if(IsPlayerInRangeOfPoint(playerid, 10.0, DDoorsInfo[i][ddExteriorX], DDoorsInfo[i][ddExteriorY], DDoorsInfo[i][ddExteriorZ]))
		{
			format(string, sizeof(string), "%s noi (tu ben ngoai): %s", GetPlayerNameEx(playerid), params);
			printf("%s", string);
	        foreach(new iz : Player)
			{
				if((IsPlayerInRangeOfPoint(iz, 25.0, DDoorsInfo[i][ddInteriorX], DDoorsInfo[i][ddInteriorY], DDoorsInfo[i][ddInteriorZ])) && GetPlayerVirtualWorld(iz) == DDoorsInfo[i][ddInteriorVW]) 
				{
				    SendClientMessageEx(iz, COLOR_WHITE, string);
				}
			}
			LocalChat(playerid, 20.0, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4);
			format(string, sizeof(string), "%s", params);
			SetPlayerChatBubble(playerid,string,COLOR_FADE1,10.0,8000);
			return 1;
		}
		if((IsPlayerInRangeOfPoint(playerid, 25.0, DDoorsInfo[i][ddInteriorX], DDoorsInfo[i][ddInteriorY], DDoorsInfo[i][ddInteriorZ])) && GetPlayerVirtualWorld(playerid) == DDoorsInfo[i][ddInteriorVW]) 
		{
			format(stringz, sizeof(stringz), "%s noi (tu ben trong): %s", GetPlayerNameEx(playerid), params);
	        foreach(new iz : Player)
			{
				if(IsPlayerInRangeOfPoint(iz, 10.0, DDoorsInfo[i][ddExteriorX], DDoorsInfo[i][ddExteriorY], DDoorsInfo[i][ddExteriorZ]))
				{
					SendClientMessageEx(iz, COLOR_WHITE, string);
				}
			}
			LocalChat(playerid, 20.0, stringz, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4);
			format(stringz, sizeof(stringz), "%s", params);
			SetPlayerChatBubble(playerid,stringz,COLOR_FADE1,10.0,8000);
			return 1;
		}
	}
	ShowNotifyTextMain(playerid, "Ban khong dung gan canh cua nao het.");
	return 1;
}


forward LocalChat(playerid, Float:radi, string[], color1, color2, color3, color4);
public LocalChat(playerid, Float:radi, string[], color1, color2, color3, color4)
{
        
    new
        Float:currentPos[3], 
        Float:oldPos[3],
        Float:checkPos[3]
    ;
        
    GetPlayerPos(playerid, oldPos[0], oldPos[1], oldPos[2]); 
    foreach (new i : Player)
    {
        //if (PlayerInfo[playerid][pLoggedin] == false) continue; 
        
        GetPlayerPos(i, currentPos[0], currentPos[1], currentPos[2]); 
        for (new p = 0; p < 3; p++)
        {
            checkPos[p] = (oldPos[p] - currentPos[p]);  
        }
        
        if (GetPlayerVirtualWorld(i) != GetPlayerVirtualWorld(playerid))
            continue;
            
        if (((checkPos[0] < radi/16) && (checkPos[0] > -radi/16)) && ((checkPos[1] < radi/16) && (checkPos[1] > -radi/16)) && ((checkPos[2] < radi/16) && (checkPos[2] > -radi/16)))
        {
            SendClientMessage(i, color1, string);
        }
        else if (((checkPos[0] < radi/8) && (checkPos[0] > -radi/8)) && ((checkPos[1] < radi/8) && (checkPos[1] > -radi/8)) && ((checkPos[2] < radi/8) && (checkPos[2] > -radi/8)))
        {
            SendClientMessage(i, color2, string);
        }
        else if (((checkPos[0] < radi/4) && (checkPos[0] > -radi/4)) && ((checkPos[1] < radi/4) && (checkPos[1] > -radi/4)) && ((checkPos[2] < radi/4) && (checkPos[2] > -radi/4)))
        {
            SendClientMessage(i, color3, string);
        }
        else if (((checkPos[0] < radi/2) && (checkPos[0] > -radi/2)) && ((checkPos[1] < radi/2) && (checkPos[1] > -radi/2)) && ((checkPos[2] < radi/2) && (checkPos[2] > -radi/2)))
        {
            SendClientMessage(i, color4, string);
        }   
    }
    return 1;
}



