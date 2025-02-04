
CMD:pdcmds(playerid,params[]) {
    SendServerMessage(playerid, "CHAT: /dept /g /r /r1 /r2");
    SendServerMessage(playerid, "GENERAL: /thubanglai /ticket /fset /tazer /cuff /uncuff /detain /drag /g");
    SendServerMessage(playerid, "GENERAL: /handcuff1 /handcuff2 /tackle /beanbag");
    SendServerMessage(playerid, "CCTV: /createcctv /deletecctv /movecctv /createcctvtable /deletecctvtable /cctv");
    return true;
}

CMD:r1(playerid, params[]) {

    new iGroupID = PlayerInfo[playerid][pMember], 
    iRank = PlayerInfo[playerid][pRank],
    Float:posx, 
    Float:posy, 
    Float:posz;

    if (0 <= iGroupID < MAX_GROUPS) {
        if (iRank >= arrGroupData[iGroupID][g_iRadioAccess]) {

            if(!isnull(params))
            {
                new string[128], employer[GROUP_MAX_NAME_LEN], rank[GROUP_MAX_RANK_LEN], division[GROUP_MAX_DIV_LEN];
                format(string, sizeof(string), "(radio) %s noi: %s", GetPlayerNameEx(playerid), params);
                foreach(new i: Player)
                {
                    if(i == playerid)
                       continue;
            
                    else if(IsPlayerInRangeOfPoint(i, 10.0, posx,posy,posz))
                    {
                        SendClientMessageEx(i, COLOR_GREY, string);
                    }
                }
                GetPlayerGroupInfo(playerid, rank, division, employer);
                if(IsACop(playerid))
                {


                    format(string, sizeof(string), "** [CH: L-TAC1, S: 2] %s: %s", GetPlayerNameEx(playerid), params);
                }
                else if(IsAMedic(playerid))
                {
                    format(string, sizeof(string), "** [CH :%s, S: 2] %s: %s", division, GetPlayerNameEx(playerid), params);
                }
                
                foreach(new i : Player)
                {
                    if(IsACop(playerid))
                    {
                        if(PlayerInfo[i][pMember] == iGroupID && iRank >= arrGroupData[iGroupID][g_iRadioAccess])
                        {
                            SendClientMessageEx(i, 0x93864BFF, string);
                        }
                    }
                
                    else if(IsAMedic(playerid))
                    {

                        if(PlayerInfo[i][pMember] == iGroupID && PlayerInfo[i][pDivision] == PlayerInfo[playerid][pDivision]) {
                            SendClientMessageEx(i, 0x93864BFF, string);
                        }
                    }
                }
            }
            else return SendUsageMessage(playerid,"  /r2low [noi dung]");       
        }
        //else return SendErrorMessage(playerid,"  Ban khong co quyen truy cap tan so radio nay.");
    }
//  else return SendErrorMessage(playerid,"  Ban khong o trong nhom.");
    return 1;
}
CMD:r2(playerid, params[])
{
    if(IsACop(playerid))
    {
        new iGroupID = PlayerInfo[playerid][pMember], 
        iRank = PlayerInfo[playerid][pRank],
        Float:posx, 
        Float:posy, 
        Float:posz;

        GetPlayerPos(playerid, posx,posy,posz);

        if (0 <= iGroupID < MAX_GROUPS)
        {
            if (iRank >= arrGroupData[iGroupID][g_iRadioAccess])
            {
                if(GetPVarInt(playerid, "togRadio") == 0)
                {
                    if(!isnull(params))
                    {
                        new string[128], employer[GROUP_MAX_NAME_LEN], rank[GROUP_MAX_RANK_LEN], division[GROUP_MAX_DIV_LEN];
                        format(string, sizeof(string), "(Radio) %s noi: %s", GetPlayerNameEx(playerid), params);
                        foreach(new i: Player)
                        {
                            if(i == playerid)
                               continue;
                    
                            else if(IsPlayerInRangeOfPoint(i, 10.0, posx,posy,posz))
                            {
                                SendClientMessageEx(i, COLOR_WHITE, string);
                            }
                        }
                        GetPlayerGroupInfo(playerid, rank, division, employer);

                        if(IsACop(playerid))
                        {
                   

                            format(string, sizeof(string), "** [CH: L-TAC2, S: 3] %s: %s", GetPlayerNameEx(playerid), params);
                        }
                      
                        foreach(new i: Player)
                        {
                            if(GetPVarInt(i, "togRadio") == 0)
                            {
                                if(PlayerInfo[i][pMember] == iGroupID && iRank >= arrGroupData[iGroupID][g_iRadioAccess])
                                {
                                    SendClientMessageEx(i, 0x93864BFF, string);
                                }
                                if(GetPVarInt(i, "BigEar") == 4 && GetPVarInt(i, "BigEarGroup") == iGroupID)
                                {
                                    new szBigEar[128];
                                    format(szBigEar, sizeof(szBigEar), "(BE) %s", string);
                                    SendClientMessageEx(i, COLOR_RADIOFAC, szBigEar);
                                }
                            }
                        }

                    }
                    else return SendUsageMessage(playerid,"(/r)adio [radio chat]");
                }
                else return SendErrorMessage(playerid, " Kenh radio cua ban hien dang tatt, su dung /togradio de lien lac tro lai.");
            }
            else return SendErrorMessage(playerid,"  Ban khong co quyen truy cap tan so radio nay.");
        }
    }
    else return SendErrorMessage(playerid,"  Ban khong o trong faction LEO.");
    return 1;
}
CMD:r(playerid, params[])
{
    new iGroupID = PlayerInfo[playerid][pMember], 
    iRank = PlayerInfo[playerid][pRank],
    Float:posx, 
    Float:posy, 
    Float:posz;

    GetPlayerPos(playerid, posx,posy,posz);

    if (0 <= iGroupID < MAX_GROUPS)
    {
        if (iRank >= arrGroupData[iGroupID][g_iRadioAccess])
        {
            if(GetPVarInt(playerid, "togRadio") == 0)
            {
                if(!isnull(params))
                {
                    if(IsACop(playerid))
                    {
                        new string[128], employer[GROUP_MAX_NAME_LEN], rank[GROUP_MAX_RANK_LEN], division[GROUP_MAX_DIV_LEN];
                        format(string, sizeof(string), "(Radio) %s noi: %s", GetPlayerNameEx(playerid), params);
                        foreach(new i: Player)
                        {
                            if(i == playerid)
                               continue;
                    
                            else if(IsPlayerInRangeOfPoint(i, 10.0, posx,posy,posz))
                            {
                            SendClientMessageEx(i, COLOR_GRAD3, string);
                            }
                        }
                        GetPlayerGroupInfo(playerid, rank, division, employer);

                        // new wflog[1024];
                        // format(wflog, sizeof(wflog), "[%s] [/r] **%s**: **%s**", date(gettime()+25200), GetPlayerNameEx(playerid), params);
                        // DCC_SendChannelMessage(PD_RadioLogs, wflog);

                        format(string, sizeof(string), "** [CH: R-BASE, S: 1] %s: %s", GetPlayerNameEx(playerid), params);
                        foreach(new i: Player)
                        {
                            if(GetPVarInt(i, "togRadio") == 0)
                            {
                                if(PlayerInfo[i][pMember] == iGroupID && iRank >= arrGroupData[iGroupID][g_iRadioAccess])
                                {
                                    SendClientMessageEx(i, COLOR_RADIOFAC, string);
                                }
                                if(GetPVarInt(i, "BigEar") == 4 && GetPVarInt(i, "BigEarGroup") == iGroupID)
                                {
                                    new szBigEar[128];
                                    format(szBigEar, sizeof(szBigEar), "(BE) %s", string);
                                    SendClientMessageEx(i, COLOR_RADIOFAC, szBigEar);
                                }
                            }
                        }
                    }
                    else if(IsAMedic(playerid))
                    {
                        new string[128], employer[GROUP_MAX_NAME_LEN], rank[GROUP_MAX_RANK_LEN], division[GROUP_MAX_DIV_LEN];
                        format(string, sizeof(string), "(Radio) %s noi: %s", GetPlayerNameEx(playerid), params);
                        foreach(new i: Player)
                        {
                            if(i == playerid)
                               continue;
                    
                            else if(IsPlayerInRangeOfPoint(i, 10.0, posx,posy,posz))
                            {
                                SendClientMessageEx(i, COLOR_WHITE, string);
                            }
                        }
                        GetPlayerGroupInfo(playerid, rank, division, employer);
                        format(string, sizeof(string), "** [CH: MEDIC-911, S: 1] %s: %s",GetPlayerNameEx(playerid), params);
                        foreach(new i: Player)
                        {
                            if(GetPVarInt(i, "togRadio") == 0)
                            {
                                if(PlayerInfo[i][pMember] == iGroupID && iRank >= arrGroupData[iGroupID][g_iRadioAccess])
                                {
                                    SendClientMessageEx(i, COLOR_RADIOFAC, string);
                                }
                                if(GetPVarInt(i, "BigEar") == 4 && GetPVarInt(i, "BigEarGroup") == iGroupID)
                                {
                                    new szBigEar[128];
                                    format(szBigEar, sizeof(szBigEar), "(BE) %s", string);
                                    SendClientMessageEx(i, COLOR_RADIOFAC, szBigEar);
                                }
                            }
                        }
                    }
                   
                    else if(IsATaxiDriver(playerid))
                    {
                        new string[128], employer[GROUP_MAX_NAME_LEN], rank[GROUP_MAX_RANK_LEN], division[GROUP_MAX_DIV_LEN];
                        format(string, sizeof(string), "(Radio) %s noi: %s", GetPlayerNameEx(playerid), params);
                        foreach(new i: Player)
                        {
                            if(i == playerid)
                               continue;
                    
                            else if(IsPlayerInRangeOfPoint(i, 10.0, posx,posy,posz))
                            {
                                SendClientMessageEx(i, COLOR_WHITE, string);
                            }
                        }
                        GetPlayerGroupInfo(playerid, rank, division, employer);
                        format(string, sizeof(string), "** [CH: TAXI254, S: 1] %s: %s",GetPlayerNameEx(playerid), params);
                        foreach(new i: Player)
                        {
                            if(GetPVarInt(i, "togRadio") == 0)
                            {
                                if(PlayerInfo[i][pMember] == iGroupID && iRank >= arrGroupData[iGroupID][g_iRadioAccess])
                                {
                                    SendClientMessageEx(i, COLOR_RADIOFAC, string);
                                }
                                if(GetPVarInt(i, "BigEar") == 4 && GetPVarInt(i, "BigEarGroup") == iGroupID)
                                {
                                    new szBigEar[128];
                                    format(szBigEar, sizeof(szBigEar), "(BE) %s", string);
                                    SendClientMessageEx(i, COLOR_RADIOFAC, szBigEar);
                                }
                            }
                        }
                    }
                }
                else return SendUsageMessage(playerid,"  (/r)adio [radio chat]");
            }
            else return SendErrorMessage(playerid,"  Kenh radio cua ban hien dang tatt, su dung /togradio de lien lac tro lai.");
        }
        else return SendErrorMessage(playerid,"  Ban khong co quyen truy cap tan so radio nay.");
    }
    else return SendErrorMessage(playerid,"  Ban khong o trong nhom.");
    return 1;
}
CMD:thubanglai(playerid, params[]) {
    return cmd_revokelicense(playerid, params);
}

CMD:revokelicense(playerid, params[])
{
    if(IsACop(playerid) || (IsAMedic(playerid) && arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance] == 2))
    {
        new string[128], giveplayerid, type, reason[64], sz_FacInfo[3][64];
        if(sscanf(params, "us[64]", giveplayerid, reason))
        {
            SendUsageMessage(playerid, " /tichthubanglai [playerid] [reason]");
            return 1;
        }
        type = 1;
        if (playerid == giveplayerid) return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong the thu hoi giay phep cua ban!");

        if((IsPlayerConnected(giveplayerid)) && giveplayerid != INVALID_PLAYER_ID)
        {
            if(GetPVarInt(playerid, "Injured") != 0) return SendClientMessageEx (playerid, COLOR_GRAD2, "Ban khong the lam dieu nay vao luc nay.");
            if(!ProxDetectorS(8.0, playerid, giveplayerid)) return SendClientMessageEx (playerid, COLOR_GRAD2, "Ban khong o gan nguoi do!");
            switch(type)
            {
                case 1:
                {
                    if(PlayerInfo[giveplayerid][pCarLic] == 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "Nguoi nay khong co giay phep lai xe de thu hoi.");

                    GetPlayerGroupInfo(playerid, sz_FacInfo[0], sz_FacInfo[1], sz_FacInfo[2]);
                    format(string,sizeof(string),"%s da thu hoi giay phep lai xe cua ban, ly do: %s.", sz_FacInfo[2], reason);
                    SendClientMessageEx(giveplayerid,COLOR_LIGHTBLUE,string);
                    format(string,sizeof(string),"HQ: %s %s %s da thu hoi %s' giay phep lai xe, ly do: %s.", sz_FacInfo[2], sz_FacInfo[0], GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), reason);
                    SendGroupMessage(1,TEAM_BLUE_COLOR,string);
                    format(string,sizeof(string),"Ban da thu hoi %s' giay phep lai xe.",GetPlayerNameEx(giveplayerid));
                    SendClientMessageEx(playerid,COLOR_WHITE,string);
                    format(string, sizeof(string), "%s mat %s' giay phep lai xe. ly do: %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), reason);
                    Log("logs/licenses.log", string);
                    PlayerInfo[giveplayerid][pCarLic] = 0;
                    return 1;
                }
                case 2:
                {
                    if(PlayerInfo[giveplayerid][pBoatLic] == 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "Nguoi nay khong co giay phep lai xe de thu hoi.");

                    GetPlayerGroupInfo(playerid, sz_FacInfo[0], sz_FacInfo[1], sz_FacInfo[2]);
                    format(string,sizeof(string),"Nhan vien %s da thu hoi giay phep lai thuyen cua ban, ly do: %s.", sz_FacInfo[2], reason);
                    SendClientMessageEx(giveplayerid,COLOR_LIGHTBLUE,string);
                    format(string,sizeof(string),"HQ: %s %s %s da thu hoi %s' giay phep lai thuyen, ly do: %s.", sz_FacInfo[2], sz_FacInfo[0], GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), reason);
                    SendGroupMessage(1,TEAM_BLUE_COLOR,string);
                    format(string,sizeof(string),"Ban da thu hoi %s' giay phep lai thuyen.",GetPlayerNameEx(giveplayerid));
                    SendClientMessageEx(playerid,COLOR_WHITE,string);
                    format(string, sizeof(string), "%s mat %s' giay phep lai thuyen. ly do: %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), reason);
                    Log("logs/licenses.log", string);
                    PlayerInfo[giveplayerid][pBoatLic] = 0;
                    return 1;
                }
                case 3:
                {
                    if(PlayerInfo[giveplayerid][pFlyLic] == 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "Nguoi nay khong co giay phep lai xe de thu hoi.");

                    GetPlayerGroupInfo(playerid, sz_FacInfo[0], sz_FacInfo[1], sz_FacInfo[2]);
                    format(string,sizeof(string),"Nhan vien %s da thu hoi giay phep lai may bay cua ban, ly do: %s.", sz_FacInfo[2], reason);
                    SendClientMessageEx(giveplayerid,COLOR_LIGHTBLUE,string);
                    format(string,sizeof(string),"HQ: %s %s %s da thu hoi %s' giay phep lai may bay, ly do: %s.", sz_FacInfo[2], sz_FacInfo[0], GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), reason);
                    SendGroupMessage(1,TEAM_BLUE_COLOR,string);
                    format(string,sizeof(string),"Ban da thu hoi %s' giay phep lai may bay.",GetPlayerNameEx(giveplayerid));
                    SendClientMessageEx(playerid,COLOR_WHITE,string);
                    format(string, sizeof(string), "%s mat %s' giay phep lai may bay. ly do: %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), reason);
                    Log("logs/licenses.log", string);
                    PlayerInfo[giveplayerid][pFlyLic] = 0;
                    return 1;
                }
            }
        }
        SendClientMessageEx(playerid, COLOR_GRAD2, "nguoi choi khong hop le.");
        return 1;
    }
    SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong duoc phep lam dieu nay.");
    return 1;
}
CMD:fset(playerid, params[])
{
    if(IsACop(playerid) || IsAGovernment(playerid))
    {
        if (0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS)
        {
            new giveplayerid, luachon[100], noidung[100], string[128];
            if(sscanf(params, "us[100]s[100]", giveplayerid, luachon, noidung))
            {
                SendUsageMessage(playerid,"  /fset [player] [lua chon] [noi dung]");
                if(0 <= PlayerInfo[playerid][pLeader] < MAX_GROUPS) 
                {
                    SendClientMessageEx(playerid, COLOR_CHAT, "{58a7a4}HINT:{9E9E9E} badge | update... ");
                }
                return 1;
            }
            if(IsPlayerConnected(giveplayerid))
            {
                if(strcmp(luachon, "badge", true) == 0)
                {
                    if(0 <= PlayerInfo[playerid][pLeader] < MAX_GROUPS) 
                    {   
                        if(2 <= strlen(noidung) < 7)
                        {
                            strmid(PlayerInfo[giveplayerid][pMPH], noidung, 0, strlen(noidung), 7);
                            format(string, sizeof(string), "{58a7a4}[FACTION]{9E9E9E} %s da dieu chinh badge number cho ban thanh '%s'.", GetPlayerNameEx(playerid), noidung);
                            SendClientMessageEx(giveplayerid, COLOR_CHAT, string);
                            format(string, sizeof(string), "{58a7a4}[FACTION]{9E9E9E} Ban da dieu chinh badge number cho %s thanh '%s'.", GetPlayerNameEx(playerid), noidung);
                            SendClientMessageEx(playerid, COLOR_CHAT, string);
                            format(string, sizeof(string), "[FACTION] %s da set MPH %s cho %s ", GetPlayerNameEx(playerid), noidung, GetPlayerNameExt(giveplayerid));
                            Log("logs/fset.log", string);
                        }
                        else SendErrorMessage(playerid,"  Khong the nhap it hon 3 ky tu va nhieu hon 6 ky tu.");
                    }  
                }
            }
        }
    }
    else SendErrorMessage(playerid,"  Ban can phai o trong faction LEO.");
    return 1;
}

CMD:g(playerid, params[]) {

    // if(ToggleFactionOOC == false && PlayerInfo[playerid][pRank] < 8) return SCM(playerid, "Hien tai kenh nay dang bi khoa, chi co ~y~sergeant~w~ tro len moi co the su dung.");
    new
        iGroupID = PlayerInfo[playerid][pMember],
        iRank = PlayerInfo[playerid][pRank];
    if (0 <= iGroupID < MAX_GROUPS)
    {
        if (iRank >= arrGroupData[iGroupID][g_iRadioAccess])
         {
            if(PlayerInfo[playerid][pTogFactionChat] == 0)
            {
                if(!isnull(params))
                {
                    new string[128], employer[GROUP_MAX_NAME_LEN], rank[GROUP_MAX_RANK_LEN], division[GROUP_MAX_DIV_LEN];
                    GetPlayerGroupInfo(playerid, rank, division, employer);
        

                    if(strcmp(PlayerInfo[playerid][pMPH], "NULL", true) != 0) format(string, sizeof(string), "**(( [%s] (#%s) %s (%s) %s: %s ))**", employer, PlayerInfo[playerid][pMPH], arrGroupRanks[iGroupID][iRank], division, GetPlayerNameEx(playerid), params);
                    else format(string, sizeof(string), "**(( [%s] %s (%s) %s: %s ))**", employer, arrGroupRanks[iGroupID][iRank], division, GetPlayerNameEx(playerid), params);
                    foreach(new i: Player)
                    {
                        if(GetPVarInt(i, "togGroup") == 0)
                        {
                            if(PlayerInfo[i][pMember] == iGroupID && iRank >= arrGroupData[iGroupID][g_iRadioAccess])
                            {
                                SendClientMessageEx(i, arrGroupData[iGroupID][g_hRadioColour] * 256 + 255, string);
                            }
                        }
                    }
                }
                else return SendUsageMessage(playerid,"  (/g)roup [group chat]");
            }
            else return SendClientMessageEx(playerid, COLOR_GRAD2, "{873A35}[Error]{9E9E9E}Kenh chat OOC group da bi tat!");
        }
        else return SendErrorMessage(playerid,"  Ban khong co quyen truy cap tan so group nay.");
    }
    else return SendErrorMessage(playerid,"  Ban khong o trong nhom.");
    return 1;
}
CMD:congtay(playerid, params[]) {
    return cmd_cuff(playerid, params);
}
CMD:cuff(playerid, params[])
{
    if(IsACop(playerid))
    {
        if(GetPVarInt(playerid, "Injured") == 1 || PlayerCuffed[ playerid ] >= 1 || PlayerInfo[ playerid ][ pJailTime ] > 0 || PlayerInfo[playerid][pHospital] > 0)
        {
            SendErrorMessage(playerid,"  Ban khong the lam dieu nay bay gio.");
            return 1;
        }

        if(PlayerInfo[playerid][pHasCuff] < 1)
        {
            SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong co chiec cong tay nao!");
            return 1;
        }

        new string[128], giveplayerid, Float:health, Float:armor;
        if(sscanf(params, "u", giveplayerid)) return SendUsageMessage(playerid,"  /cuff [Player]");
        if(IsPlayerConnected(giveplayerid))
        {
            if (ProxDetectorS(8.0, playerid, giveplayerid))
            {
                if(giveplayerid == playerid) { SendErrorMessage(playerid,"  Ban khong the tu cong tay minh!"); return 1; }
                if(PlayerCuffed[giveplayerid] == 1)
                {
                    format(string, sizeof(string), "* Ban da bi cong tay boi %s.", GetPlayerNameEx(playerid));
                    SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
                    format(string, sizeof(string), "* Ban da cong tay %s, su dung /uncuff de thao cong.", GetPlayerNameEx(giveplayerid));
                    SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
                    format(string, sizeof(string), "* %s da cong tay %s lai.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
                    ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
                    GameTextForPlayer(giveplayerid, "~r~Cong tay", 2500, 3);
                    GetPlayerHealth(giveplayerid, health);
                    GetPlayerArmour(giveplayerid, armor);
                    SetPVarFloat(giveplayerid, "cuffhealth",health);
                    SetPVarFloat(giveplayerid, "cuffarmor",armor);
                    SetPlayerSpecialAction(giveplayerid, SPECIAL_ACTION_CUFFED);
                    SetPlayerAttachedObject(giveplayerid, 7, 19418, 6, -0.011, 0.028, -0.022, -15.600012, -33.699977, -81.700035, 1.0, 1.0, 1.0);
//                  ApplyAnimation(giveplayerid,"ped","cower",1,1,0,0,0,0,1);
                    PlayerCuffed[giveplayerid] = 2;
                    SetPVarInt(giveplayerid, "PlayerCuffed", 2);
                    SetPVarInt(giveplayerid, "IsFrozen", 1);
                    //Frozen[giveplayerid] = 1;
                    PlayerCuffedTime[giveplayerid] = 300;
                }
                else if(GetPVarType(giveplayerid, "IsTackled"))
                {
                    format(string, sizeof(string), "* %s da lay chiec cong tu trong nguoi ra va cong tay %s lai.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
                    ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
                    SetTimerEx("CuffTackled", 4000, 0, "ii", playerid, giveplayerid);
                }
            }
            else
            {
                SendErrorMessage(playerid,"  Nguoi do khong o gan ban.");
                return 1;
            }
        }
        else
        {
            SendErrorMessage(playerid,"  nguoi choi khong hop le.");
            return 1;
        }
    }
    else
    {
        SendErrorMessage(playerid,"  Ban khong phai nhan vien chinh phu");
    }
    return 1;
}

CMD:thaocong(playerid, params[]) {
    return cmd_uncuff(playerid, params);
}
CMD:uncuff(playerid, params[])
{
    if(IsACop(playerid))
    {
        new string[128], giveplayerid;
        if(sscanf(params, "u", giveplayerid)) return SendUsageMessage(playerid,"  /uncuff [Player]");

        if(IsPlayerConnected(giveplayerid))
        {
            if (ProxDetectorS(8.0, playerid, giveplayerid))
            {
                if(PlayerInfo[giveplayerid][pJailTime] >= 1)
                {
                    SendClientMessageEx(playerid, COLOR_WHITE, "You can't uncuff a jailed player.");
                    return 1;
                } 
                if(giveplayerid == playerid) { SendErrorMessage(playerid,"  Ban khong the thao cong tay cho chinh minh."); return 1; }
                if(PlayerCuffed[giveplayerid]>1)
                {
                    DeletePVar(giveplayerid, "IsFrozen");
                    format(string, sizeof(string), "* Ban da duoc thao cong tay boi %s.", GetPlayerNameEx(playerid));
                    SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
                    format(string, sizeof(string), "* Ban da thao cong tay %s.", GetPlayerNameEx(giveplayerid));
                    SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
                    format(string, sizeof(string), "* %s da thao cong tay %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
                    ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
                    GameTextForPlayer(giveplayerid, "~g~Thao cong", 2500, 3);
                    TogglePlayerControllable(giveplayerid, 1);
                    ClearAnimations(giveplayerid);
                    SetPlayerSpecialAction(giveplayerid, SPECIAL_ACTION_NONE);
                    PlayerCuffed[giveplayerid] = 0;
                    PlayerCuffedTime[giveplayerid] = 0;
                    SetPlayerHealth(giveplayerid, GetPVarFloat(giveplayerid, "cuffhealth"));
                    SetPlayerArmor(giveplayerid, GetPVarFloat(giveplayerid, "cuffarmor"));
                    DeletePVar(giveplayerid, "cuffhealth");
                    DeletePVar(giveplayerid, "PlayerCuffed");
                }
                else
                {
                    SendErrorMessage(playerid,"  Nguoi do khong bi cong tay.");
                    return 1;
                }
            }
            else
            {
                SendErrorMessage(playerid,"  Nguoi do khong o gan ban.");
                return 1;
            }
        }
        else
        {
            SendErrorMessage(playerid,"  nguoi choi khong hop le.");
            return 1;
        }
    }
    else
    {
        SendErrorMessage(playerid,"  Ban khong phai nhan vien chinh phu");
    }
    return 1;
}

CMD:dualenxe(playerid, params[]) {
    return cmd_detain(playerid, params);
}

CMD:detain(playerid, params[])
{
    if(IsACop(playerid))
    {
        if(IsPlayerInAnyVehicle(playerid))
        {
            SendErrorMessage(playerid,"  Ban khong the lam dieu nay, ban dang trong xe.");
            return 1;
        }

        new string[128], giveplayerid, seat;
        if(sscanf(params, "ud", giveplayerid, seat)) return SendUsageMessage(playerid,"  /dualenxe [Player] [cho ngoi 1-3]");

        if(IsPlayerConnected(giveplayerid))
        {
            if(seat < 1 || seat > 3)
            {
                SendClientMessageEx(playerid, COLOR_GRAD1, "ID cho ngoi tren xe phai tu 1 den 3.");
                return 1;
            }
            if(IsACop(giveplayerid))
            {
                SendErrorMessage(playerid,"  Ban khong the dua canh sat khac len xe.");
                return 1;
            }
            if(IsPlayerInAnyVehicle(giveplayerid))
            {
                SendErrorMessage(playerid,"  Nguoi do dang o trong mot chiec xe, hay dua nguoi do ra khoi xe de tiep tuc.");
                return 1;
            }
            if (ProxDetectorS(8.0, playerid, giveplayerid))
            {
                if(giveplayerid == playerid) { SendErrorMessage(playerid,"  Ban khong the moi chinh minh len xe!"); return 1; }
                if(PlayerCuffed[giveplayerid] == 2)
                {
                    new carid = gLastCar[playerid];
                    if(IsSeatAvailable(carid, seat))
                    {
                        new Float:pos[6];
                        GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
                        GetPlayerPos(giveplayerid, pos[3], pos[4], pos[5]);
                        GetVehiclePos( carid, pos[0], pos[1], pos[2]);
                        if (floatcmp(floatabs(floatsub(pos[0], pos[3])), 10.0) != -1 &&
                                floatcmp(floatabs(floatsub(pos[1], pos[4])), 10.0) != -1 &&
                                floatcmp(floatabs(floatsub(pos[2], pos[5])), 10.0) != -1) return false;
                        format(string, sizeof(string), "* Ban da bi dua len xe boi %s .", GetPlayerNameEx(playerid));
                        SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
                        format(string, sizeof(string), "* Ban da dua %s len xe.", GetPlayerNameEx(giveplayerid));
                        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
                        format(string, sizeof(string), "* %s da dua %s len xe cua ho.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
                        ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
                        GameTextForPlayer(giveplayerid, "~r~Giam giu", 2500, 3);
                        ClearAnimations(giveplayerid);
                        TogglePlayerControllable(giveplayerid, false);
                        IsPlayerEntering{giveplayerid} = true;
                        PutPlayerInVehicle(giveplayerid, carid, seat);
                    }
                    else
                    {
                        SendErrorMessage(playerid,"  Cho ngoi khong ton tai!");
                        return 1;
                    }
                }
                else
                {
                    SendErrorMessage(playerid,"  Nguoi do khong bi cong.");
                    return 1;
                }
            }
            else
            {
                SendErrorMessage(playerid,"   Ban khong o gan nguoi do hoac chiec xe cua ban!");
                return 1;
            }
        }
        else
        {
            SendErrorMessage(playerid,"  nguoi choi khong hop le.");
            return 1;
        }
    }
    else
    {
        SendClientMessageEx(playerid, COLOR_GRAD2, "   Ban khong phai la nhan vien chinh phu!");
    }
    return 1;
}

CMD:dandi(playerid, params[]) {
    return cmd_drag(playerid, params);
}
CMD:drag(playerid, params[])
{
    if(IsACop(playerid))
    {
        if(PlayerInfo[playerid][pDuty] == 1)
        {
            new string[128], giveplayerid;
            if(sscanf(params, "u", giveplayerid)) return SendUsageMessage(playerid,"  /dandi [playerid]");

            if(IsPlayerConnected(giveplayerid))
            {
                if(GetPVarInt(giveplayerid, "PlayerCuffed") == 2)
                {
                    if(IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_WHITE, " Ban phai ra khoi xe moi co the su dung lenh nay.");
                    if(GetPVarInt(giveplayerid, "BeingDragged") == 1)
                    {
                        SendClientMessageEx(playerid, COLOR_WHITE, " Nguoi do da duoc dan theo. ");
                        return 1;
                    }
                    new Float:dX, Float:dY, Float:dZ;
                    GetPlayerPos(giveplayerid, dX, dY, dZ);
                    if(!IsPlayerInRangeOfPoint(playerid, 5.0, dX, dY, dZ))
                    {
                        SendClientMessageEx(playerid, COLOR_GRAD2, " Nguoi do o gan ban.");
                        return 1;
                    }
                    format(string, sizeof(string), "* %s hien dan dan ban di.", GetPlayerNameEx(playerid));
                    SendClientMessageEx(giveplayerid, COLOR_WHITE, string);
                    format(string, sizeof(string), "* Ban bi dan di %s, ban the di chuyen chung ngay bay gio.", GetPlayerNameEx(giveplayerid));
                    SendClientMessageEx(playerid, COLOR_WHITE, string);
                    format(string, sizeof(string), "* %s grabs ahold of %s and begins to move them.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
                    ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
                    SendClientMessageEx(playerid, COLOR_WHITE, "Ban dang dan mot nguoi tinh nghi, Nhan '{AA3333}FIRE{FFFFFF}' nut de dung lai.");
                    SetPVarInt(giveplayerid, "BeingDragged", 1);
                    SetPVarInt(playerid, "DraggingPlayer", giveplayerid);
                    SetTimerEx("DragPlayer", 1000, 0, "ii", playerid, giveplayerid);
                }
                else
                {
                    SendClientMessageEx(playerid, COLOR_WHITE, " Nguoi chi dinh khong bi cong!");
                }
            }
        }
        else
        {
            SendClientMessageEx(playerid, COLOR_CHAT, "{873D37}[Error]{9E9E9E} Ban chua onduty");
        }
    }
    else
    {
        SendErrorMessage(playerid,"   Ban khong phai la nhan vien chinh phu!");
        return 1;
    }
    return 1;
}
