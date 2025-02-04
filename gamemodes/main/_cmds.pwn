
 //--------------------------------[ FUNCTIONS ]---------------------------




CMD:traloicauhoi(playerid, params[])
{
    if(PlayerInfo[playerid][pHelper] < 1 && PlayerInfo[playerid][pAdmin] < 1){
        SendClientMessageEx(playerid, COLOR_GREY, "Ban khong phai la Helper.");
	}
	else {

		new Player, string[128];

		if(sscanf(params, "u", Player)) {
			SendUsageMessage(playerid, " /traloicauhoi [ID]");
		}
		else if(Player == playerid) {
		    SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the tra loi cau hoi cua chinh minh.");
		}
		else if(!IsPlayerConnected(Player)) {
			SendClientMessageEx(playerid, COLOR_GREY, "Nguoi choi khong hop le.");
		}
		else if(GetPVarInt(Player, "CAUHOINEWB") == 0) {
			SendClientMessageEx(playerid, COLOR_GREY, "Nguoi do khong co cau hoi nao.");
		}
		else {
            new advert[256];
            GetPVarString(Player, "CAUHOINEWBTEXT", advert, 256);
            ShowPlayerDialog(playerid, TRALOICAUHOI, DIALOG_STYLE_INPUT, "Tra loi cau hoi", advert, "Tra Loi", "Tu choi");
            strcpy(TraLoiCauHoi[playerid], advert, 256);
            SetPVarString(playerid, "TRALOICAUHOITEXT", TraLoiCauHoi[playerid]);
            SetPVarInt(playerid, "CAUHOINEWBID", Player);
		    format(string, sizeof(string), "* %s da chap nhan cau hoi cua %s.",GetPlayerNameEx(playerid), GetPlayerNameEx(Player));
			SendHelperMessage(TEAM_AZTECAS_COLOR, string);
			format(string, sizeof(string), "* Helper %s da chap nhan cau hoi cua ban.",GetPlayerNameEx(playerid));
			SendClientMessageEx(Player, COLOR_LIGHTBLUE, string);
			DeletePVar(Player, "CAUHOINEWB");
			DeletePVar(Player, "CAUHOINEWBTEXT");
			PlayerInfo[playerid][pAdvisorCount]++;
			ReportCount[playerid]++;
			ReportHourCount[playerid]++;
			AddCAReportToken(playerid);
			return 1;

		}
	}
	return 1;
}

CMD:xemcauhoi(playerid, params[])
{
	if(PlayerInfo[playerid][pHelper] >= 1 || PlayerInfo[playerid][pAdmin] >= 1)
	{
		new string[128];
		SendClientMessageEx(playerid, COLOR_GREEN, "____________________ TRO GIUP NEWBIE _____________________");
		foreach(new i: Player)
		{
			if(GetPVarInt(i, "CAUHOINEWB"))
			{
				format(string, sizeof(string), "(%s ID:%i) Dang Cho Mot Cau Hoi Chua Duoc Tra Loi", GetPlayerNameEx(i), i);
				SendClientMessageEx(playerid, COLOR_LIGHTRED, string);
			}
		}
		SendClientMessageEx(playerid, COLOR_GREEN, "_________________________________________________________");
	}
	return 1;
}

CMD:newb(playerid, params[])
{
	if(gPlayerLogged{playerid} == 0) return SendClientMessageEx(playerid, COLOR_GREY, "Ban chua dang nhap.");
	if(PlayerInfo[playerid][pTut] == 0) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the lam dieu nay bay gio.");
	if((nonewbie) && PlayerInfo[playerid][pAdmin] < 2) return SendClientMessageEx(playerid, COLOR_GRAD2, "Kenh hoi dap newbie dang tat!");
	if(PlayerInfo[playerid][pNMute] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "Ban da bi cam noi chuyen tren kenh hoi dap.");
	if(gNewbie[playerid] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "Ban da tat kenh hoi dap, /tognewbie de mo!");

	new string[128];
	if(gettime() < NewbieTimer[playerid])
	{
		format(string, sizeof(string), "Ban phai cho %d giay de tiep tuc hoi dap tren kenh nay.", NewbieTimer[playerid]-gettime());
		SendClientMessageEx(playerid, COLOR_GREY, string);
		return 1;
	}
 	if(PlayerInfo[playerid][pHelper] >= 1 && PlayerInfo[playerid][pAdmin] < 2) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the su dung kenh nay!");
	if(PlayerInfo[playerid][pHelper] < 1 && PlayerInfo[playerid][pAdmin] < 1)
	{
		ShowPlayerDialog(playerid, CAUHOINEWB, DIALOG_STYLE_INPUT, "{3399FF}Nhap cau hoi", "{FFFFFF}Hay nhap cau hoi ma ban can hoi.", "Dong y", "Bo qua");
		return 1;
	}
	if(isnull(params)) return SendUsageMessage(playerid, " (/newb)ie [noi dung]");
	if(PlayerInfo[playerid][pAdmin] >= 2)
	{
	format(string, sizeof(string), "** Administrator %s: %s", GetPlayerNameEx(playerid), params);
	}
	foreach(new n: Player)
	{
		if (gNewbie[n]==0)
		{
			SendClientMessageEx(n, COLOR_NEWBIE, string);
		}
	}
	return 1;
}



// forward DangChatGo(playerid);
// public DangChatGo(playerid)
// {
// 	RemovePlayerAttachedObject(playerid, 0);
// 	DeletePVar(playerid, "IsFrozen");
// 	TogglePlayerControllable(playerid, 1);
// 	SetPlayerCheckpoint(playerid, -450.9864, -48.1142, 59.7089, 3);
// 	PlayerInfo[playerid][pServiceTime] = gettime()+20;
// 	ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 1, 1, 1, 0, 1);
// 	SetPlayerAttachedObject(playerid, 9, 1303, 1, 0.218000, 0.507000, 0.128000, 8.300000, 91.700000, -42.300000, 0.475000, 0.430999, 0.526000, 0, 0);
// 	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
// 	return 1;
// }

CMD:credits(playerid, params[])
{
    new str[2460], name[1280];
    format(str, sizeof(str), "So Credits cua ban la: (%d Credits)",PlayerInfo[playerid][pGcoin]);
    format(name, sizeof(name), "Thong tin %s",GetPlayerNameEx(playerid));
    ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, name, str, "Dong Lai", "");
    return 1;
}


// CMD:g(playerid, params[]) {

// 	new
// 		iGroupID = PlayerInfo[playerid][pMember],
// 		iRank = PlayerInfo[playerid][pRank];

// 	if (0 <= iGroupID < MAX_GROUPS) {
//  		if (iRank >= arrGroupData[iGroupID][g_iRadioAccess]) {
// 			if(GetPVarInt(playerid, "togGroup") == 0) {
// 				if(!isnull(params))
// 				{
// 					new string[128], employer[GROUP_MAX_NAME_LEN], rank[GROUP_MAX_RANK_LEN], division[GROUP_MAX_DIV_LEN];
// 					//format(string, sizeof(string), "(radio) %s", params);
// 					//SetPlayerChatBubble(playerid, string, COLOR_WHITE, 15.0, 5000);
// 					GetPlayerGroupInfo(playerid, rank, division, employer);
// 					format(string, sizeof(string), "(( (%d) %s: %s ))",PlayerInfo[playerid][pRank], GetPlayerNameEx(playerid), params);
// 					foreach(new i: Player)
// 					{
// 						if(GetPVarInt(i, "togGroup") == 0)
// 						{
// 							if(PlayerInfo[i][pMember] == iGroupID && iRank >= arrGroupData[iGroupID][g_iRadioAccess]) {
// 								SendClientMessageEx(i, arrGroupData[iGroupID][g_hRadioColour] * 256 + 255, string);
// 							}
// 							if(GetPVarInt(i, "BigEar") == 4 && GetPVarInt(i, "BigEarGroup") == iGroupID) {
// 								new szBigEar[128];
// 								format(szBigEar, sizeof(szBigEar), "(BE) %s", string);
// 								SendClientMessageEx(i, arrGroupData[iGroupID][g_hRadioColour] * 256 + 255, szBigEar);
// 							}
// 						}
// 					}
// 				}
// 				else return SendUsageMessage(playerid, " (/g)roup [group chat]");
// 			}
// 			else return SendClientMessageEx(playerid, COLOR_GREY, "Kenh group cua ban hien dang tatt, su dung /toggroup de lien lac tro lai.");
// 		}
// 		else return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co quyen truy cap tan so group nay.");
// 	}
// 	else return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong o trong nhom.");
// 	return 1;
// }





CMD:gotosz(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 1338 || PlayerInfo[playerid][pShopTech] == 1)
	{
		new housenum;
		if(sscanf(params, "d", housenum)) return SendClientMessageEx(playerid, COLOR_GREY, "SUDUNG: /gotosz [ID Khu An Toan]");

		SetPlayerPos(playerid,SafeZoneInfo[housenum][szExteriorX],SafeZoneInfo[housenum][szExteriorY],SafeZoneInfo[housenum][szExteriorZ]);
		GameTextForPlayer(playerid, "~w~Teleporting", 5000, 1);
		SetPlayerInterior(playerid, 0);
		PlayerInfo[playerid][pInt] = 0;
	}
	return 1;
}

CMD:szedit(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 99999)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "Lenh nay khong ton tai. Neu ban khong biet lenh hay su dung lenh /help");
		return 1;
	}

	new string[128], choice[32], szid, amount;
	if(sscanf(params, "s[32]dd", choice, szid, amount))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "SUDUNG: /szedit [name] [Khu An Toan ID] [(Optional)amount]");
		SendClientMessageEx(playerid, COLOR_GREY, "Available names: Toado, Khoangcach");
		return 1;
	}
	if(strcmp(choice, "toado", true) == 0)
	{
		GetPlayerPos(playerid, SafeZoneInfo[szid][szExteriorX], SafeZoneInfo[szid][szExteriorY], SafeZoneInfo[szid][szExteriorZ]);
		SendClientMessageEx( playerid, COLOR_WHITE, "Ban da chinh sua toa do Khu An Toan!" );
		DestroyPickup(SafeZoneInfo[szid][szPickupID]);
		SaveSafeZones();

		format(string, sizeof(string), "%s da chinh sua toa do Khu An Toan (ID %d).", GetPlayerNameEx(playerid), szid);
		Log("logs/khuantoan.log", string);

		DestroyPickup(SafeZoneInfo[szid][szPickupID]);
		DestroyDynamic3DTextLabel(SafeZoneInfo[szid][szTextID]);
		format(string, sizeof(string), "{FFFF66}Khu an toan\nID: %d",szid);
		SafeZoneInfo[szid][szTextID] = CreateDynamic3DTextLabel( string, COLOR_WHITE, SafeZoneInfo[szid][szExteriorX], SafeZoneInfo[szid][szExteriorY], SafeZoneInfo[szid][szExteriorZ]+0.5,10.0, .testlos = 1, .streamdistance = 10.0);
		SafeZoneInfo[szid][szPickupID] = CreatePickup(1314, 23, SafeZoneInfo[szid][szExteriorX], SafeZoneInfo[szid][szExteriorY], SafeZoneInfo[szid][szExteriorZ]);
	}
	else if(strcmp(choice, "Khoangcach", true) == 0)
	{
	    SafeZoneInfo[szid][szKhoangcach] = amount;
		SendClientMessageEx( playerid, COLOR_WHITE, "Ban da chinh sua khoang cach Khu An Toan!" );
		SaveSafeZones();

		format(string, sizeof(string), "%s da chinh sua khoang cach Khu An Toan (ID %d).", GetPlayerNameEx(playerid), szid);
		Log("logs/khuantoan.log", string);

		DestroyDynamic3DTextLabel(SafeZoneInfo[szid][szTextID]);
		format(string, sizeof(string), "{FFFF66}Khu an toan\nID: %d",szid);
		SafeZoneInfo[szid][szTextID] = CreateDynamic3DTextLabel( string, COLOR_WHITE, SafeZoneInfo[szid][szExteriorX], SafeZoneInfo[szid][szExteriorY], SafeZoneInfo[szid][szExteriorZ]+0.5,10.0, .testlos = 1, .streamdistance = 10.0);
	}
	SaveSafeZones();
	return 1;
}

CMD:szdelete(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 1338)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong du kha nang de su dung lenh nay`!");
		return 1;
	}
	new h, string[128];
	if(sscanf(params,"d",h)) return SendClientMessage(playerid, COLOR_WHITE,"USAGE: /szdelete [Khu An Toan ID]");
	if(!IsValidDynamicPickup(SafeZoneInfo[h][szPickupID])) return SendClientMessage(playerid, COLOR_WHITE,"Khu An Toan do khong ton tai.");
	SafeZoneInfo[h][szExteriorX] = 0;
	SafeZoneInfo[h][szExteriorY] = 0;
	SafeZoneInfo[h][szExteriorZ] = 0;
	DestroyDynamicPickup(SafeZoneInfo[h][szPickupID]);
	DestroyDynamic3DTextLabel(SafeZoneInfo[h][szTextID]);
	SaveSafeZones();
	format(string, sizeof(string), "Ban da xoa Khu An Toan (ID %d).", h);
	SendClientMessageEx(playerid, COLOR_WHITE, string);
	format(string, sizeof(string), "%s da xoa Khu An Toan (ID %d).", GetPlayerNameEx(playerid), h);
	Log("logs/khuantoan.log", string);
	return 1;
}
CMD:capmaphuhieu(playerid, params[])
{
    if(PlayerInfo[playerid][pLeader] >= 0 || PlayerInfo[playerid][pFactionModerator] >= 1)
    {
 	    new giveplayerid, mahieu;
	    if(sscanf(params, "ud", giveplayerid, mahieu)) return SendUsageMessage(playerid, " /capmaphuhieu [player] [mahieu]");
	    else if(!(1 <= mahieu <= 999)) SendClientMessageEx(playerid, COLOR_GRAD2, "Tu 1 den 999.");
	    else if(!IsPlayerConnected(giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "Nguoi choi khong hop le.");
	    else
	    {
            new string[128];
            PlayerInfo[giveplayerid][pMaHieu1] = 0;
            PlayerInfo[giveplayerid][pMaHieu1] = mahieu;
            format(string, sizeof(string), "{9999FF} %s cap ma hieu cho ban ( Ma hieu: %d )", GetPlayerNameEx(playerid), mahieu);
            SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
            format(string, sizeof(string), "{9999FF} Ban cap ma hieu cho %s ( Ma hieu: %d )", GetPlayerNameEx(giveplayerid), mahieu);
            SendClientMessageEx(playerid, COLOR_GRAD2, string);
     	}
	}
	else SendClientMessageEx(playerid, COLOR_GREY, "Ban khong duoc phep su dung lenh nay.");
	return 1;
}

// CMD:showmahieu(playerid, params[])
// {
//     if(PlayerInfo[playerid][pMaHieu1] >= 1)
//     {
// 	new giveplayerid, nation[24], string[128];
// 	if(sscanf(params, "u", giveplayerid))  return SendUsageMessage(playerid, " /showmahieu [player]");
// 	if(gettime() < ShowTimer[playerid])
// 	{
// 		format(string, sizeof(string), "Ban phai cho %d giay de su dung lenh nay.", ShowTimer[playerid]-gettime());
// 		SendClientMessageEx(playerid, COLOR_GREY, string);
// 		return 1;
// 	}
// 	if(IsPlayerConnected(giveplayerid))
// 	{
// 		new iGroupID = PlayerInfo[playerid][pMember],
// 		rank[GROUP_MAX_RANK_LEN],
// 		division[GROUP_MAX_DIV_LEN],
// 		employer[GROUP_MAX_NAME_LEN];
// 		if(0 <= iGroupID < MAX_GROUPS)
// 		if(ProxDetectorS(8.0, playerid, giveplayerid))
// 		{
//                 switch(PlayerInfo[playerid][pNation])
// 		        {
// 				    case 0: nation = "San Andreas";
// 				    case 1: nation = "Tierra Robada";
// 	         	}
// 				GetPlayerGroupInfo(playerid, rank, division, employer);
// 				format(string, sizeof(string), "{FFFFFF}Ho Ten: %s\nLam viec tai:{%06x} %s{FFFFFF}\nChuc vu: %s (%s)\nMa phu hieu: %d", GetPlayerNameEx(playerid), GetPlayerColor(playerid) >>> 8, employer, rank, division, PlayerInfo[playerid][pMaHieu1]);
// 				ShowPlayerDialog(giveplayerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "The nhan vien", string, "Dong Lai", "");
// 				format(string, sizeof(string), "{FF8000}** {C2A2DA}%s da lay the nhan vien dua cho %s xem.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
// 				ProxDetectorWrap(playerid, string, 92, 30.0, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
// 				format(string, sizeof(string), "* %s da show ma hieu cua minh.", GetPlayerNameEx(playerid));
// 				ProxDetector(20.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
// 				ShowTimer[playerid] = gettime()+5;
// 			}
// 			else SendClientMessageEx(playerid, COLOR_GREY, "Nguoi do khong gan ban.");
// 		}
// 		else SendClientMessageEx(playerid, COLOR_GRAD1, "Nguoi choi khong hop le.");
// 	}
// 	else SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong co Ma Hieu.");
// 	return 1;
// }
CMD:xemtruyduoi(playerid, params[])
{
	new string[128];
	if(PlayerInfo[playerid][pTruyDuoi] < 1)
	{
		SendClientMessageEx(playerid, COLOR_YELLOW, "Ban da het bi truy duoi");
	}
	else
	{
		format(string, sizeof(string), "Ban con %d phut se het bi bi truy duoi boi canh sat!Hay chay tron!", PlayerInfo[playerid][pTruyDuoi]);
		SendClientMessageEx(playerid, COLOR_YELLOW, string);
	}
	return 1;
}
CMD:truyduoi(playerid,params[])
{
    if (IsACop(playerid))
    {
            new iTargetID,strc[128];
            if(sscanf(params, "u", iTargetID)) {
                return SendUsageMessage(playerid, " /truyduoi [player]");
            }
            else if(iTargetID == playerid) {
                return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the su dung lenh nay cho ban.");
            }
            if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessageEx(playerid, COLOR_GREY, "Ban Phai Ngoi o Tren xe moi co the Pursuit");
            else if(IsACop(iTargetID))
            {
                return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the truy duoi nhan vien thi hanh phap luat.");
            }
            else if(!IsPlayerConnected(iTargetID)) {
                return SendClientMessageEx(playerid, COLOR_GREY, "Nguoi choi khong hop le.");
            }
            else if(GetPlayerInterior(iTargetID) != 0) {
                return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the su dung lenh nay trong khi dang o trong mot noi that.");
            }
            else if(PlayerInfo[iTargetID][pAdmin] >= 2 && PlayerInfo[iTargetID][pTogReports] != 1) {
                return SendClientMessageEx(playerid, COLOR_GREY, "You are unable to find this person.");
            }
            else if (GetPVarInt(playerid, "_SwimmingActivity") >= 1) {
                return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong the tim thay nguoi nay trong khi dang boi loi.");
            }
            if(PlayerInfo[iTargetID][pTruyDuoi] >= 1)
            {
                SendClientMessageEx(playerid, COLOR_GRAD2, "  Nguoi nay dang bi canh sat truy duoi");
                return 1;
            }
            if(!ProxDetectorS(200,playerid,iTargetID))
            {
                SendClientMessageEx(playerid, COLOR_GRAD2, "Ban phai gan nguoi nay trong pham vi 200m");
                return 1;
            }
            if (GetPVarInt(playerid, "_SwimmingActivity") >= 1)
            {
                SendClientMessageEx(playerid, COLOR_GRAD2, "  Ban phai dung boi! (/stopswimming)");
                return 1;
            }
            if(gettime()<TimeTruyDuoi[playerid])
            {
                format(strc,sizeof(strc),"Ban phai doi %d giay moi duoc su dung lai!",TimeTruyDuoi[playerid]-gettime());
                SendClientMessageEx(playerid, COLOR_GRAD2,strc);
                return 1;
            }
            else
            {
                new str[128],str2[128];
                TimeTruyDuoi[playerid]=gettime()+200;
                format(str,128,"** Ban dang truy duoi doi tuong %s (ID: %i) (( Co hieu luc trong 7 phut ))",GetPlayerNameExt(iTargetID),playerid);
                SendClientMessageEx(playerid, COLOR_YELLOW,str);
                SendClientMessageEx(iTargetID, COLOR_LIGHTRED, "Ban dang bi truy duoi boi canh sat neu ban /q ban se o tu 20 phut (( Hieu luc 7 phut ))");
                GameTextForPlayer(iTargetID, "~y~Ban dang bi truy duoi", 2500, 3);
                PlayerInfo[iTargetID][pTruyDuoi] = 7;
                timetrd[iTargetID] = SetTimerEx("TruyDuoiC",420000,false,"ii",iTargetID,playerid);
                format(str2,128,"HQ: Si quan %s dang truy duoi doi tuong %s",GetPlayerNameExt(playerid),GetPlayerNameExt(iTargetID));
                SendGroupMessage(1,TEAM_BLUE_COLOR,str2);
            }
    }
    else  SendClientMessageEx(playerid, COLOR_GRAD1, "Ban khong duoc phep su dung lenh nay.");
    return 1;
}
CMD:dungtruyduoi(playerid, params[])
{
	if(IsACop(playerid))
	{
		new string[128], giveplayerid;
		if(sscanf(params, "u", giveplayerid)) return SendUsageMessage(playerid, " /dungtruyduoi [Player]");

		if(IsPlayerConnected(giveplayerid))
		{
			if (ProxDetectorS(1000.0, playerid, giveplayerid))
			{
				if(giveplayerid == playerid) { SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the truy duoi chinh minh"); return 1; }
				if(PlayerInfo[giveplayerid][pTruyDuoi] > 0)
				{
					format(string, sizeof(string), "* Ban da duoc tron thoat do canh sat %s da mat dau cua ban", GetPlayerNameEx(playerid));
					SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
					format(string, sizeof(string), "* Ban da dung truy duoi %s.", GetPlayerNameEx(giveplayerid));
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
					GameTextForPlayer(giveplayerid, "~y~Da dung truy duoi", 2500, 3);
					PlayerInfo[giveplayerid][pTruyDuoi] = 0;
					KillTimer(timetrd[giveplayerid]);
				}
				else SendClientMessageEx(playerid, COLOR_YELLOW, "Nguoi do khong bi truy duoi");
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_GREY, "Nguoi do khong o gan ban.");
				return 1;
			}
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Nguoi choi khong hop le.");
			return 1;
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GREY, "Ban khong phai nhan vien chinh phu");
	}
	return 1;
}

CMD:finegcoin(playerid, params[])
{
	new string[128], giveplayerid, amount, reason[64];
	if(sscanf(params, "uds[64]", giveplayerid, amount, reason)) return SendUsageMessage(playerid, " /finegcoin [player] [amount] [reason]");

	if (PlayerInfo[playerid][pAdmin] >= 3)
	{
		if(IsPlayerConnected(giveplayerid))
		{
			if (amount < 1)
			{
				SendClientMessageEx(playerid, COLOR_GRAD2, "Amount must be greater than 0");
				return 1;
			}
			format(string, sizeof(string), "AdmCmd: %s da tru $%s Gcoin boi %s, ly do: %s", GetPlayerNameEx(giveplayerid), number_format(amount), GetPlayerNameEx(playerid), reason);
			Log("logs/admin.log", string);
			format(string, sizeof(string), "AdmCmd: %s da tru $%s Gcoin boi %s, ly do: %s", GetPlayerNameEx(giveplayerid), number_format(amount), GetPlayerNameEx(playerid), reason);
			SendClientMessageToAllEx(COLOR_LIGHTRED, string);
			PlayerInfo[playerid][pGcoin] -= amount;
			return 1;
		}
		else SendClientMessageEx(playerid, COLOR_GRAD1, "Nguoi choi khong hop le.");
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You're not a level three admin.");
	}
	return 1;
}
CMD:makiemsoat(playerid,params[])
{

    new
	veh = GetPlayerVehicleID(playerid);
	if (0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS)
	{
    if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
    {
    	if(isnull(params)) return SendClientMessage(playerid,COLOR_WHITE,"Su dung: /makiemsoat [noidung]");
        if(!veicolo_callsign_status[veh])
        {

            new string[128];
       	    format(string,sizeof(string), "%s",params);
            veicolo_callsign_testo[veh] = Create3DTextLabel(string, 0xFFFFFFFF, 0.0, 0.0, 0.0, 50.0, 0, 1);
            format(string, sizeof(string), " %s su dung ma kiem soat: %s ", GetPlayerNameEx(playerid), string);
            foreach(new i: Player)
			{
				new iRank = PlayerInfo[playerid][pRank];
				if(PlayerInfo[i][pMember] == PlayerInfo[playerid][pMember] && iRank >= arrGroupData[PlayerInfo[playerid][pMember]][g_iRadioAccess]) {
					SendClientMessageEx(i, arrGroupData[PlayerInfo[playerid][pMember]][g_hRadioColour] * 256 + 255, string);
				}
				if(GetPVarInt(i, "BigEar") == 4 && GetPVarInt(i, "BigEarGroup") == PlayerInfo[playerid][pMember]) {
					new szBigEar[128];
					format(szBigEar, sizeof(szBigEar), "(BE) %s", string);
					SendClientMessageEx(i, arrGroupData[PlayerInfo[playerid][pMember]][g_hRadioColour] * 256 + 255, szBigEar);
				}
			}
            Attach3DTextLabelToVehicle( veicolo_callsign_testo[veh], veh, -0.7, -1.9, -0.3);
            veicolo_callsign_status[veh] = 1;
        }
        else
        {
            Delete3DTextLabel(veicolo_callsign_testo[veh]);
            veicolo_callsign_status[veh] = 0;
            return 1;
        }
    }
    else return SendClientMessageEx(playerid,COLOR_GREY,"Ban khong o tren xe de su dung lenh nay");
    }
    else return SendClientMessageEx(playerid,COLOR_GREY,"Ban khong the su dung lenh nay");
    return 1;
}
CMD:xoamakiemsoat(playerid,params[])
{
    new veh = GetPlayerVehicleID(playerid);
    if (0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS)
	{
    if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
    {
        if(veicolo_callsign_status[veh])
		{
        new string[128];
        format(string, sizeof(string), " %s Da xoa ma kiem soat ", GetPlayerNameEx(playerid));
        foreach(new i: Player)
					{
                            new iRank = PlayerInfo[playerid][pRank];
							if(PlayerInfo[i][pMember] == PlayerInfo[playerid][pMember] && iRank >= arrGroupData[PlayerInfo[playerid][pMember]][g_iRadioAccess]) {
								SendClientMessageEx(i, arrGroupData[PlayerInfo[playerid][pMember]][g_hRadioColour] * 256 + 255, string);
							}
							if(GetPVarInt(i, "BigEar") == 4 && GetPVarInt(i, "BigEarGroup") == PlayerInfo[playerid][pMember]) {
								new szBigEar[128];
								format(szBigEar, sizeof(szBigEar), "(BE) %s", string);
								SendClientMessageEx(i, arrGroupData[PlayerInfo[playerid][pMember]][g_hRadioColour] * 256 + 255, szBigEar);
							}
					}
        Delete3DTextLabel(veicolo_callsign_testo[veh]);
        veicolo_callsign_status[veh] = 0;
        }
        else return SendClientMessageEx(playerid,COLOR_GREY,"Ban khong su dung ma kiem soat nao");
    }
    else return SendClientMessageEx(playerid,COLOR_GREY,"Ban khong co o tren xe");
    }
    else return SendClientMessageEx(playerid,COLOR_GREY,"Ban khong the su dung lenh nay");
    return 1;
}
CMD:gps(playerid, params[])
{
	ShowPlayerGPS(playerid);
    return 1;
}
CMD:dunggps(playerid, params[])
{
	if(PlayerInfo[playerid][pGPS] >= 1)
	{
	 

	    PlayerInfo[playerid][pSudungGPS] = 1;
	}
	else
	{
		SendClientMessage(playerid, COLOR_LIGHTRED, "Ban khong co GPS");
	}
	return 1;
}


CMD:laygps(playerid, params[])
{
	PlayerInfo[playerid][pGPS] += 1;
}

// CMD:toglichsu(playerid, params[])
// {
//     if(InfoMessage[playerid] == false)
//     {
//         SendClientMessageEx(playerid, COLOR_WHITE, "*** Ban da bat lich su chien dau ( /toglichsu lan nua de tat )***");

//         InfoMessage[playerid] = true;
//     }
//     else
//     {
//         SendClientMessageEx(playerid, COLOR_WHITE, "*** Ban da tat lich su chien dau ( /toglichsu lan nua de bat )***");

//         InfoMessage[playerid] = false;
//     }
//     return 1;
// }
stock JoinGame(playerid) {

	    PlayerHasNationSelected[playerid] = 1;
	    TextDrawHideForPlayer(playerid,txtNationSelHelper);
		TextDrawHideForPlayer(playerid,txtNationSelMain);
		TextDrawHideForPlayer(playerid,txtSanAndreas);
		TextDrawHideForPlayer(playerid,txtTierraRobada);
		RegistrationStep[playerid] = 0;
	    PlayerInfo[playerid][pTut] = 1;
		gOoc[playerid] = 0; gNews[playerid] = 0; gFam[playerid] = 0;
		TogglePlayerControllable(playerid, 1);
		SetCamBack(playerid);
		DeletePVar(playerid, "MedicBill");
		SetPlayerColor(playerid,TEAM_HIT_COLOR);
		DeletePVar(playerid,"DangTaoAcc");
		for(new x;x<10000;x++)
		{
			new rand=random(300);
			if(PlayerInfo[playerid][pSex] == 0)
			{
				if(IsValidSkin(rand) && IsFemaleSpawnSkin(rand))
				{
					PlayerInfo[playerid][pModel] = rand;
					SetPlayerSkin(playerid, rand);
					break;
				}
			}
			else
			{
				if(IsValidSkin(rand) && !IsFemaleSkin(rand))
				{
					PlayerInfo[playerid][pModel] = rand;
					SetPlayerSkin(playerid, rand);
					break;
				}
			}
		}
		PlayerInfo[playerid][pTempVIP] = 0;
		PlayerInfo[playerid][pBuddyInvited] = 0;
		PlayerInfo[playerid][pSpeedo] = 1;
		SetCameraBehindPlayer(playerid);
       	PlayerPlaySound(playerid, 1056, 0.0, 0.0, 0.0);
	
        CP[playerid] = 252000;
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerInterior(playerid,0);
		Streamer_UpdateEx(playerid,1773.0314,-1899.6782,13.5517);
		SetPlayerPos(playerid, 1773.0314,-1899.6782,13.5517);
		SetPlayerFacingAngle(playerid,273.6349);
		PlayerInfo[playerid][pVW] = 0;
        SetUPFitness@Reg(playerid,1);
        InsertInventory(playerid);
    
        for(new i = 0 ; i < MAX_SLOT_INVENTORY ; i++) {
            PlayerInventoryItem[playerid][i] = 1;
        }
        SetUPACCommand(playerid);
        SaveInventory(playerid);
        TwoTempCheck(playerid);
}
CMD:vwcuatao(playerid, params[]) {
	printf("vw cua may la %d",GetPlayerVirtualWorld(playerid));
	return 1;
}

forward UpdateTK(playerid);
public UpdateTK(playerid) {
	new namez[24],bank;
	new rows = cache_num_rows();
	if(rows)
    {
        for(new i=0; i<rows; i++)
        {   
    	    cache_get_field_content(i, "UserName", namez, MainPipeline, 24);
    	    bank = cache_get_field_content_int(i, "Bank", MainPipeline);
            bank += GetPVarInt(playerid, "TienGD");
		    new string[129];
		    format(string, sizeof(string), "UPDATE accounts SET `Bank`=%d WHERE `SoTaiKhoan` = %d", bank, GetPVarInt(playerid, "STK"));
		    mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);		
        }
    }
    else 
    {
    	ShowPlayerDialog(playerid, DIALOG_CHUYENTIEN, DIALOG_STYLE_INPUT, "Chuyen tien", "So tai khoan khong ton tai !\nVui long nhap so tai khoan de tiep tuc giao dich", "Tuy chon", "Thoat");	    	
    }
}
forward STK_check(playerid);
public STK_check(playerid) {
	new namez[24],stk;
	new rows = cache_num_rows();
    printf("rows %d ", rows);
    if(rows)
    {
        for(new i=0; i<rows; i++)
        {   
    	    cache_get_field_content(i, "UserName",  namez, MainPipeline, 24);
            printf("name load duoc la :v %s", namez);
    	    stk = cache_get_field_content_int(i, "SoTaiKhoan", MainPipeline);
            SetPVarString(playerid, "_NguoiNhan", namez);
		    SetPVarInt(playerid, "Offline", 1);
		    SetPVarInt(playerid, "STK", stk);
		    new string[129];
		    format(string, sizeof string, "Ten chu the\t\t\t\t%s\nSo tai khoan\t\t\t\t%d\nBan hay nhap so tien muon giao dich o ben duoi", namez,stk);
		    ShowPlayerDialog(playerid, DIALOG_CHUYENTIEN1, DIALOG_STYLE_INPUT, "Chuyen tien", string, "Tuy chon", "Thoat");
        }
    }
    else {
 		ShowPlayerDialog(playerid, DIALOG_CHUYENTIEN, DIALOG_STYLE_INPUT, "Chuyen tien", "So tai khoan khong ton tai !\nVui long nhap so tai khoan de tiep tuc giao dich", "Tuy chon", "Thoat");	    	
    }
}

CMD:bank(playerid, params[]) {
	if(!IsPlayerInRangeOfPoint(playerid, 15.0, 2308.7346, -11.0134, 26.7422))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "Ban khong o trong ngan hang!");
		return 1;
	}
	if(PlayerInfo[playerid][pSoTaiKhoan] < 100) return ShowPlayerDialog(playerid,DANGKYBANK,DIALOG_STYLE_MSGBOX,"Tai khoan ngan hang","Ban chua co tai khoan ngan hang khong the su dung,ban co muon dang ky khong\nPhi dang ky: Mien phi","Dang ky","Huy bo");
	new ti[42],string[230];
	format(ti, sizeof ti, "Tai khoan ngan hang cua %s", GetPlayerNameEx(playerid));
	format(string, sizeof string, "Ten chu the\t\t\t\t{8b3721}%s{ffffff}\nSo tai khoan\t\t\t\t{eae000}%d{ffffff}\nSo du trong vi\t\t\t\t{289c59}$%s{ffffff}\n___________________\nChuyen tien\nGui tien\nRut tien", GetPlayerNameEx(playerid),PlayerInfo[playerid][pSoTaiKhoan],number_format(PlayerInfo[playerid][pAccount]));
	ShowPlayerDialog(playerid, DIALOG_BANK, DIALOG_STYLE_LIST, ti, string, "Tuy chon", "Thoat");
	return 1;
}
stock GetJobFind(z) {
	new jobnamez[32];
	switch(z) {
		case 0:	jobnamez = "Tham tu";
		case 1:	jobnamez = "Luat su";
		case 2:	jobnamez = "Gai diem";
		case 3:	jobnamez = "Ban thuoc phien";
		case 4:	jobnamez = "Ve Si";
		case 5:	jobnamez = "Tho sua xe";
		case 6:	jobnamez = "Ban vu khi";
		case 7:	jobnamez = "Vo Si";
		case 8:	jobnamez = "Tai Xe Taxi";
		case 9:	jobnamez = "Buon thuoc phien";
		case 10: jobnamez = "Tho Thu Cong";
		case 11: jobnamez = "Nguoi pha ruou";
		case 12: jobnamez = "Van Chuyen Banh";
		case 13: jobnamez = "Tai Xe Trucker";
	}
	return jobnamez;
}  
