CMD:pm(playerid, params[])
{
	new userid, text[128];

	if (PlayerInfo[playerid][pMutedTime] > 0)								return SendErrorMessage(playerid, "Tro chuyen cuc bo cua ban bi he thong chan.");
	if (sscanf(params, "us[128]", userid, text))							return SendHelpMessage(playerid, "/pm [ID/Ten] [van ban]");
	if (!IsPlayerLogged(userid))											return SendNotConnected(playerid);
    if (userid == playerid)													return SendErrorMessage(playerid, "Ban khong the viet mot tin nhan cho chinh minh.");
	if (PlayerInfo[playerid][pSettings] & togPM)							return SendErrorMessage(playerid, "Vui long bat tinh nang nhan tin rieng tu truoc. ");
	if (!IsAdminDuty(playerid) && (PlayerInfo[userid][pSettings] & togPM))	return SendErrorMessage(playerid, "Nguoi choi da tat tinh nang nhan tin nhan rieng tu.");
	if (people_blocking[userid][playerid] == 1)							 	return SendErrorMessage(playerid, "Nguoi choi da them ban vao danh sach den cua PM.");

	SendPMToPlayer(playerid, userid, text);
	return 1;
}

ALTX:ooc("/o");
CMD:ooc(playerid, params[])
{
	if (PlayerInfo[playerid][pSettings] & togOOC)	return SendErrorMessage(playerid, "Ban phai bat tro chuyen OOC.");
	if (PlayerInfo[playerid][pMutedTime] > 0)		return SendErrorMessage(playerid, "Tro chuyen cuc bo cua ban bi he thong chan.");
	if ((noooc) && !CheckAdmin(playerid, ADMIN_LEVEL_1))			return SendNotAdmin(playerid);
	if (isnull(params))								return SendHelpMessage(playerid, "/ooc [van ban]");

	new mes[128];

	if (strlen(params) > MAXLEN)
	{
		new pos = MAXLEN;

		if (pos < MAXLEN-1) pos = MAXLEN;

		format(mes, sizeof(mes), "[OOC] %s (ID: %i): %.*s ...", GetAccName(playerid), playerid, pos, params);
		OOCMSG(COLOR_OOC,mes);
		format(mes, sizeof(mes), "... %s", params[pos]);
		OOCMSG(COLOR_OOC,mes);
	}
	else
	{
		format(mes, sizeof(mes), "[OOC] %s (ID: %i): %s", GetAccName(playerid), playerid, params);
		OOCMSG(COLOR_OOC, mes);
	}
	return 1;
}

CMD:ame(playerid, params[])
{
	if (PlayerInfo[playerid][pInjured] == 2) return SendErrorMessage(playerid, "Ban khong the thuc hien bat ky hanh dong nao khi chet.");
	if (isnull(params))						 return SendHelpMessage(playerid, "/ame [act]");

	new mes[128];
	format(mes, sizeof(mes), "* %s %s", GetNameWithMask(playerid), params);
	SetPlayerChatBubble(playerid, mes, COLOR_PURPLE, 20.0, 10000);

	if (strlen(params) > MAXLEN)
	{
		new pos = MAXLEN;

		if (pos < MAXLEN-1) pos = MAXLEN;

		SendClientMessageEx(playerid, COLOR_PURPLE, "> %s %.*s ...", GetNameWithMask(playerid), pos, params);
		SendClientMessageEx(playerid, COLOR_PURPLE, "... %s", params[pos]);
	}
	else
	{
  		SendClientMessageEx(playerid, COLOR_PURPLE, "> %s %s", GetNameWithMask(playerid), params);
	}
	return 1;
}

CMD:server_ame(playerid, params[])
{
	new mes[128];
	format(mes, sizeof(mes), "* %s %s", GetNameWithMask(playerid), params);
	SetPlayerChatBubble(playerid, mes, COLOR_PURPLE, 20.0, 10000);

	return 1;
}

CMD:local(playerid, params[])
{
    if (PlayerInfo[playerid][pInjured] == 2)	return SendErrorMessage(playerid, "Ban khong the noi khi da chet.");
	if (isnull(params))							return SendHelpMessage(playerid, "/local [van ban]");
	if (PlayerInfo[playerid][pMutedTime] > 0)	return SendErrorMessage(playerid, "Tro chuyen cuc bo cua ban bi he thong chan.");

	if (strlen(params) > MAXLEN)
	{
		new pos = MAXLEN;

		if (pos < MAXLEN-1) pos = MAXLEN;

		SendLocalMessage(Range_Normal, playerid, COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5, "%s noi: %.*s ...", GetNameWithMask(playerid), pos, params);
		SendLocalMessage(Range_Normal, playerid, COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5, "%s noi: ... %s", GetNameWithMask(playerid), params[pos]);
	}
	else
	{
		SendLocalMessage(Range_Normal, playerid, COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5, "%s noi: %s", GetNameWithMask(playerid), params);
	}
	return 1;
}

CMD:my(playerid, params[])
{
	if (isnull(params))	return SendHelpMessage(playerid, "/my [mieu ta]");

	if (strlen(params) > MAXLEN)
	{
		new pos = MAXLEN;

		if (pos < MAXLEN-3-strlen(GetNameWithMask(playerid))) pos = MAXLEN;

		SendNearbyMessage(Range_Normal, playerid, COLOR_PURPLE, "* %s's %.*s ...", GetNameWithMask(playerid), pos, params);
		SendNearbyMessage(Range_Normal, playerid, COLOR_PURPLE, "* ... %s", GetNameWithMask(playerid), params[pos]);
	}
	else
	{
		SendNearbyMessage(Range_Normal, playerid, COLOR_PURPLE, "* %s's %s", GetNameWithMask(playerid), params);
	}
	return 1;
}

#define MAX_ACTION_LENGTH (144)
CMD:action(playerid, params[])
{
	if (PlayerInfo[playerid][pInjured] == 2)	return SendErrorMessage(playerid, "Ban khong the thuc hien bat ky hanh dong nao khi da chet.");

    if (GetPVarInt(playerid, "3DLabel"))
    {
		SendSyntaxMessage(playerid, "Mo ta moi truong da bi xoa. ");
		DestroyDynamic3DTextLabel(Text3D:GetPVarInt(playerid, "3DLabel"));
		DeletePVar(playerid, "3DLabel");
		return 1;
    }

    if (sscanf(params, "s[MAX_ACTION_LENGTH]", params[0])) 	return SendHelpMessage(playerid, "/action [van ban]");
    if (strlen(params[0]) > MAX_ACTION_LENGTH) 				return SendErrorMessage(playerid, "Co gioi han ve so luong %s ky tu!", MAX_ACTION_LENGTH);

    new Float:p[3];    
	GetPlayerPos(playerid, p[0], p[1], p[2]);
    
	new string[MAX_PLAYER_NAME + MAX_ACTION_LENGTH + (13)];
	format(string, sizeof(string), "%s \n(( %s [ID:%i] ))", params[0], GetNameEx(playerid), playerid);
    SetPVarInt(playerid, "3DLabel", _:CreateDynamic3DTextLabel(string, 0xC2A2DAFF, p[0], p[1], p[2], 100.0));
    
	AMSG(COLOR_LIGHTRED, "AdmCmd: %s [ID:%i] da tao mot mo ta ve moi truong: \"%s\".", GetNameEx(playerid), playerid, params[0]);
    return 1;
}

CMD:me(playerid, params[])
{
	if (PlayerInfo[playerid][pInjured] == 2)	return SendErrorMessage(playerid, "Ban khong the thuc hien bat ky hanh dong nao khi da chet.");
	if (isnull(params))						return SendHelpMessage(playerid, "/me [act]");

	if (strlen(params) > MAXLEN)
	{
		new pos = MAXLEN;

		if (pos < MAXLEN-1) pos = MAXLEN;

		SendNearbyMessage(Range_Normal, playerid, COLOR_PURPLE, "* %s %.*s ...", GetNameWithMask(playerid), pos, params);
		SendNearbyMessage(Range_Normal, playerid, COLOR_PURPLE, "* ... %s", params[pos], GetNameWithMask(playerid));
	}
	else
	{
		SendNearbyMessage(Range_Normal, playerid, COLOR_PURPLE, "* %s %s", GetNameWithMask(playerid), params);
	}
	return 1;
}

CMD:do(playerid, params[])
{
	if (isnull(params))	return SendHelpMessage(playerid, "/do [mieu ta]");

	if (strlen(params) > MAXLEN)
	{
		new pos = MAXLEN;

		if (pos < MAXLEN-1) pos = MAXLEN;

		SendNearbyMessage(Range_Normal, playerid, COLOR_PURPLE, "* %.*s ...", pos, params, GetNameWithMask(playerid));
		SendNearbyMessage(Range_Normal, playerid, COLOR_PURPLE, "* ... %s (( %s ))", params[pos], GetNameWithMask(playerid));
	}
	else
	{
		SendNearbyMessage(Range_Normal, playerid, COLOR_PURPLE, "* %s (( %s ))", params, GetNameWithMask(playerid));
	}
	return 1;
}

CMD:b(playerid,params[])
{
	if (isnull(params)) 						return SendHelpMessage(playerid, "/b [OOC chat]"); //��� ���
	if (PlayerInfo[playerid][pMutedTime] > 0)	return SendErrorMessage(playerid, "Tro chuyen cuc bo cua ban bi he thong chan. ");

	new mes[128];
	if (strlen(params) > MAXLEN)
	{
		new pos = MAXLEN;

		if (pos < MAXLEN-1) pos = MAXLEN;

		if (maskOn{playerid})			format(mes, sizeof(mes), "(( %s: %.*s ... ))", GetNameWithMask(playerid), pos, params);
		else if (IsAdminDuty(playerid)) 	format(mes, sizeof(mes), "(( [%i] {FF9A00}%s{AFAFAF}: %.*s ... ))", playerid, GetAccName(playerid), pos, params);
		else 							format(mes, sizeof(mes), "(( [%i] %s: %.*s ... ))", playerid, GetName(playerid), pos, params);

		ProxDetectorOutOfCharacter(20.0, playerid, mes, COLOR_GREY);

		if (maskOn{playerid}) 			format(mes, sizeof(mes), "(( ... %s ))", params[pos]);
		else if (IsAdminDuty(playerid)) 	format(mes, sizeof(mes), "(( ... %s ))", params[pos]);
		else 							format(mes, sizeof(mes), "(( ... %s ))", params[pos]);

		ProxDetectorOutOfCharacter(20.0, playerid, mes, COLOR_GREY);
	}
	else
	{
		if (maskOn{playerid}) 			format(mes, sizeof(mes), "(( %s: %s ))", GetNameWithMask(playerid), params);
		else if (IsAdminDuty(playerid)) 	format(mes, sizeof(mes), "(( [%i] {FF9A00}%s{AFAFAF}: %s ))", playerid, GetAccName(playerid), params);
		else 							format(mes, sizeof(mes), "(( [%i] %s: %s ))", playerid, GetName(playerid), params);

		ProxDetectorOutOfCharacter(20.0, playerid, mes, COLOR_GREY);
	}
	return 1;
}

ALTX:low("/l");
CMD:low(playerid,params[])
{
    if (PlayerInfo[playerid][pInjured] == 2)	return SendErrorMessage(playerid,"Ban khong the noi khi da chet.");
	if (isnull(params))							return SendHelpMessage(playerid, "/low [van ban]");
	if (PlayerInfo[playerid][pMutedTime] > 0)	return SendErrorMessage(playerid, "Tro chuyen cuc bo cua ban bi he thong chan.");

    if (IsPlayerInAnyVehicle(playerid) && !IsADontWindow(GetPlayerVehicleID(playerid)) && IsWindowsClose(GetPlayerVehicleID(playerid)))	
		return SendErrorMessage(playerid, "Su dung tro chuyen thuong, khong ai se nghe thay ban.");

	if (strlen(params) > MAXLEN)
 	{
  		if (pTemp[playerid][pCallLine] != INVALID_PLAYER_ID && pTemp[playerid][pCallStatus] == 2)
    	{
			SendLocalMessage(Range_Short, playerid, COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5, "%s noi nho (dien thoai): %.*s ...", GetNameWithMask(playerid), MAXLEN, params);
			SendClientMessageEx(pTemp[playerid][pCallLine], COLOR_YELLOWG, "%s noi nho (dien thoai): %.*s ...", GetNameWithMask(playerid), MAXLEN, params);
			SendLocalMessage(Range_Short, playerid, COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5, "... %s", params[MAXLEN]);
			SendClientMessageEx(pTemp[playerid][pCallLine], COLOR_YELLOWG, "... %s", params[MAXLEN]);
   		}
     	else
      	{
			SendLocalMessage(Range_Short, playerid,COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5, "%s noi nho: %.*s ...", GetNameWithMask(playerid), MAXLEN, params);
			SendLocalMessage(Range_Short, playerid,COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5, "... %s", params[MAXLEN]);
		}
	}

	else
	{
	    if (pTemp[playerid][pCallLine] != INVALID_PLAYER_ID && pTemp[playerid][pCallStatus] == 2) 
     	{
			SendLocalMessage(Range_Short, playerid, COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5, "%s noi nho (dien thoai): %s", GetNameWithMask(playerid), params);
            SendClientMessageEx(pTemp[playerid][pCallLine], COLOR_YELLOWG, "%s noi nho (dien thoai): %s", GetNameWithMask(playerid), params);
	   	}
     	else
		{
			SendLocalMessage(Range_Short, playerid, COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5, "%s noi nho: %s", GetNameWithMask(playerid), params);
		}
	}
	return 1;
}

ALTX:whisper("/w");
CMD:whisper(playerid, params[])
{
    if (PlayerInfo[playerid][pInjured] == 2)	return SCM(playerid, COLOR_GREY, "Ban khong the noi khi da chet.");

	new userid, text[128];

	if (sscanf(params,"us[128]", userid, text))		return SendHelpMessage(playerid, "(/w)hisper [ID/Ten] [van ban]");
	if (!IsPlayerLogged(userid))					return SendNotConnected(playerid);
	if (PlayerInfo[playerid][pMutedTime] > 0)		return SendErrorMessage(playerid, "Tro chuyen cuc bo cua ban bi he thong chan.");
    if (!PlayerNearPlayer(3.0, playerid, userid))	return SendNotNearPlayer(playerid);
	if (userid == playerid)							return SendErrorMessage(playerid, "Ban khong the thi tham voi chinh minh.");

	new mes[MAX_PLAYER_NAME + MAX_PLAYER_NAME];

	format(mes, sizeof(mes), "%s thi tham voi %s.", GetNameWithMask(playerid), GetNameWithMask(userid));
	SetPlayerChatBubble(playerid, mes, COLOR_PURPLE, 15.0, 10000);
	
	SendClientMessageEx(userid, COLOR_YELLOW3, "%s thi tham voi ban: %s", GetNameWithMask(playerid), text);
	SendClientMessageEx(playerid,  COLOR_YELLOW3, "Ban thi tham voi %s: %s", GetNameWithMask(userid), text);
	return 1;
}
CMD:cw(playerid, params[])
{
	if (isnull(params))							return SendHelpMessage(playerid, "/cw [van ban]");
	if (!IsPlayerInAnyVehicle(playerid))			return SendNotInVehicle(playerid);
	if (PlayerInfo[playerid][pMutedTime] > 0)	return SendErrorMessage(playerid, "Tro chuyen cuc bo cua ban bi he thong chan.");

	new vehicle = GetPlayerVehicleID(playerid);

	foreach(new i : Player)
	{
	    if (!IsPlayerLogged(i) || !IsPlayerInVehicle(i, vehicle)) continue;

		if (strlen(params) > MAXLEN)
		{
		    new pos = MAXLEN;

			if (pos < MAXLEN-1) pos = MAXLEN;

			SendClientMessageEx(i,  COLOR_YELLOWG, "%s thi tham: %.*s ...", GetNameWithMask(playerid), pos, params);
			SendClientMessageEx(i,  COLOR_YELLOWG, "... %s", params[pos]);
		}
		else 
		{
			SendClientMessageEx(i,  COLOR_YELLOWG, "%s thi tham: %s", GetNameWithMask(playerid), params);
		}
	}
	return 1;
}

ALTX:dshout("/ds");
CMD:dshout(playerid, params[])
{
	if (PlayerInfo[playerid][pInjured] == 2)	return SendErrorMessage(playerid, "Ban khong the la het khi da chet.");

	new text[128];

	if (sscanf(params,"s[128]",text)) 		return SendHelpMessage(playerid, "(/ds)hout [van ban]");

	for(new i = 0; i < MAX_HOUSES; i++)
	{
	    if (HouseInfo[i][hID] == 0) continue;

		if (IsPlayerOutsideHouse(playerid, i, 2.0))
		{
		    SendNearbyMessage(Range_Long, playerid, COLOR_WHITE, "* %s het len (o ngoai): %s", GetNameWithMask(playerid), text);

   			foreach(new p : Player)
			{
				if (!IsPlayerInsideHouse(p, i)) continue;

				SendClientMessageEx(p, COLOR_WHITE, "* %s het len (o ngoai): %s", GetNameWithMask(playerid), text);
			}
			return 1;
		}

		else if (IsPlayerInsideHouse(playerid, i, 3.0))
		{
		    SendNearbyMessage(Range_Long, playerid, COLOR_WHITE, "* %s het len (nha): %s", GetNameWithMask(playerid), text);

			foreach(new p : Player)
			{
				if (!IsPlayerOutsideHouse(p, i, 6.0)) continue;

				SendClientMessageEx(p, COLOR_WHITE, "* %s het len (nha): %s", GetNameWithMask(playerid), text);
			}
			return 1;
		}
	}

	for(new i = 0; i < MAX_APART; i++)
	{
	    if (ApartInfo[i][aApartOn] == 0) continue;

		if (IsPlayerApartmentOutside(playerid, i, 2.0))
		{
			SendNearbyMessage(Range_Long, playerid, COLOR_WHITE, "* %s het len (o ngoai): %s", GetNameWithMask(playerid), text);

   			foreach(new p : Player)
			{
				if (!IsPlayerApartmentInside(p, i)) continue;

				SendClientMessageEx(p, COLOR_WHITE, "* %s het len (o ngoai): %s", GetNameWithMask(playerid), text);
			}
			return 1;
		}

		else if (IsPlayerApartmentInside(playerid, i, 3.0))
		{
			SendNearbyMessage(Range_Long, playerid, COLOR_WHITE, "* %s het len (chung cu): %s", GetNameWithMask(playerid), text);

			foreach(new p : Player)
			{
				if (!IsPlayerApartmentOutside(p, i, 6.0)) continue;

				SendClientMessageEx(p, COLOR_WHITE, "* %s het len (chung cu): %s", GetNameWithMask(playerid), text);
			}
			return 1;
		}
	}

	for(new i = 0; i < MAX_BIZ; i++)
	{
	    if (BizInfo[i][bizID] == 0) continue;

		if (IsPlayerBizOutside(playerid, i, 2.0))
		{
			SendNearbyMessage(Range_Long, playerid, COLOR_WHITE, "* %s het len (o ngoai): %s", GetNameWithMask(playerid), text);

   			foreach(new p : Player)
			{
				if (!IsPlayerBizInside(p, i)) continue;

				SendClientMessageEx(p, COLOR_WHITE, "* %s het len (o ngoai): %s", GetNameWithMask(playerid), text);
			}
			return 1;
		}

		else if (IsPlayerBizInside(playerid, i, 3.0))
		{
			SendNearbyMessage(Range_Long, playerid, COLOR_WHITE, "* %s het len (doanh nghiep): %s", GetNameWithMask(playerid), text);

			foreach(new p : Player)
			{
				if (!IsPlayerBizOutside(p, i, 6.0)) continue;

				SendClientMessageEx(p, COLOR_WHITE, "* %s het len (doanh nghiep): %s", GetNameWithMask(playerid), text);
			}
			return 1;
		}	
	}
	return 1;
}

CMD:ddo(playerid, params[])
{
	new text[128];

	if (sscanf(params,"s[128]",text)) return SendHelpMessage(playerid, "/ddo [van ban]");

	for(new i = 0; i < MAX_HOUSES; i++)
	{
		if (!HouseInfo[i][hID]) continue;

		if (IsPlayerOutsideHouse(playerid, i, 2.0))
		{
		    SendNearbyMessage(Range_Long, playerid, COLOR_PURPLE, "[Door] * %s (( %s ))", text,GetNameWithMask(playerid));
			
			foreach(new p : Player)
			{
				if (!IsPlayerInsideHouse(p, i)) continue;

				SendClientMessageEx(p, COLOR_PURPLE, "[Door] * %s (( %s ))", text,GetNameWithMask(playerid));
			}
			return 1;
		}

		else if (IsPlayerInsideHouse(playerid, i, 3.0))
		{
			SendNearbyMessage(Range_Long, playerid, COLOR_PURPLE, "[Door] * %s (( %s ))", text,GetNameWithMask(playerid));
			foreach(new p : Player)
			{
				if (!IsPlayerOutsideHouse(p, i, 6.0)) continue;

				SendClientMessageEx(p, COLOR_PURPLE, "[Door] * %s (( %s ))", text,GetNameWithMask(playerid));
			}
			return 1;
		}
	}

	for(new i = 0; i < MAX_APART; i++)
	{
		if (!ApartInfo[i][aApartOn]) continue;

		if (IsPlayerApartmentOutside(playerid, i, 2.0))
		{
			SendNearbyMessage(Range_Long, playerid, COLOR_PURPLE, "[Door] * %s (( %s ))", text,GetNameWithMask(playerid));

			foreach(new p : Player)
			{
				if (!IsPlayerApartmentInside(p, i)) continue;

				SendClientMessageEx(p, COLOR_PURPLE, "[Door] * %s (( %s ))", text,GetNameWithMask(playerid));
			}
			return 1;
		}

		else if (IsPlayerApartmentInside(playerid, i, 3.0))
		{
			SendNearbyMessage(Range_Long, playerid, COLOR_PURPLE, "[Door] * %s (( %s ))", text,GetNameWithMask(playerid));

			foreach(new p : Player)
			{
				if (!IsPlayerApartmentOutside(p, i, 6.0)) continue;

				SendClientMessageEx(p, COLOR_PURPLE, "[Door] * %s (( %s ))", text,GetNameWithMask(playerid));
			}
			return 1;
		}
	}

	for(new i = 0; i < MAX_BIZ; i++)
	{
		if (!BizInfo[i][bizID]) continue;

		if (IsPlayerBizOutside(playerid, i, 2.0))
		{
			SendNearbyMessage(Range_Long, playerid, COLOR_PURPLE, "[Door] * %s (( %s ))", text,GetNameWithMask(playerid));

			foreach(new p : Player)
			{
				if (!IsPlayerBizInside(p, i)) continue;

				SendClientMessageEx(p, COLOR_PURPLE, "[Door] * %s (( %s ))", text,GetNameWithMask(playerid));
			}
			return 1;
		}

		else if (IsPlayerBizInside(playerid, i, 3.0))
		{
			SendNearbyMessage(Range_Long, playerid, COLOR_PURPLE, "[Door] * %s (( %s ))", text,GetNameWithMask(playerid));

			foreach(new p : Player)
			{
				if (!IsPlayerBizOutside(p, i, 6.0)) continue;

				SendClientMessageEx(p, COLOR_PURPLE, "[Door] * %s (( %s ))", text,GetNameWithMask(playerid));
			}
			return 1;
		}
	}
	return 1;
}

/*CMD:mypame(playerid, params[])
{
	new text[64], line;

	if (sscanf(params,"iS()[128]",line,text)) return SendHelpMessage(playerid, "/mypame [line (1-2)] [van ban]");

	if (strlen(text) > PAME_MAX_LEN) return SendErrorMessage(playerid, "Character description is too long. (Max %i characters)", PAME_MAX_LEN);
	if (line < 1 || line > 2) 		return SendErrorMessage(playerid, "1 =< Line =< 2.");

	SendHelpMessage(playerid, "/mypame [1/2] - to remove the description line (no text parameter).");
	SendHelpMessage(playerid, "/pame [id] - display a description of another character in the chat. ");
	SendHelpMessage(playerid, "/pame %i - display your description in the chat.", playerid);

	switch(line) 
	{
		case 1: 
		{
			if (!strlen(text)) 
			{
				SM1(playerid, "Line (1) character description removed.");
				format(PlayerInfo[playerid][pDescribe], PAME_MAX_LEN, "NULL");
			} 
			else 
			{
				SM2(playerid, "Character description line (1) changed. ");
				format(PlayerInfo[playerid][pDescribe], PAME_MAX_LEN, "%s", text);
			}
			SQL_SetString("users", "Desc1", PlayerInfo[playerid][pDescribe], PlayerInfo[playerid][pID]);
		}
        case 2: 
		{
			if (!strlen(text)) 
			{
				SM1(playerid, "Character description line (2) removed. ");
				format(PlayerInfo[playerid][pDescribe2], PAME_MAX_LEN, "NULL");
			} 
			else 
			{
				if (CompareStrings(PlayerInfo[playerid][pDescribe], "NULL")) 
				{
					return SendErrorMessage(playerid, "You must first fill in line (1) character description.");
				}

				SM2(playerid, "Line (2) character description changed.");
				format(PlayerInfo[playerid][pDescribe2], PAME_MAX_LEN, "%s", text);
			}
			SQL_SetString("users", "Desc2", PlayerInfo[playerid][pDescribe2], PlayerInfo[playerid][pID]);
		}
	}
	return 1;
}

CMD:pame(playerid, params[])
{
	new userid;

	if (sscanf(params, "u", userid))				  	return SendHelpMessage(playerid, "/pame [ID/Ten]");
	if (!IsPlayerLogged(userid))					  	return SendNotConnected(playerid);
	if (!PlayerNearPlayer(15.0, playerid, userid))		return SendNotNearPlayer(playerid);
	if (CompareStrings(PlayerInfo[userid][pDescribe], "NULL")) return SendErrorMessage(playerid, "The player has no description!");

	if (playerid == userid) {
		SendNearbyMessage(Range_Normal, playerid, COLOR_PURPLE, "*** %s %s", GetNameWithMask(userid), PlayerInfo[userid][pDescribe]);
		if (!CompareStrings(PlayerInfo[userid][pDescribe2], "NULL")) {
			SendNearbyMessage(Range_Normal, playerid, COLOR_PURPLE, ".. %s ***", PlayerInfo[userid][pDescribe2]);
		}
	} else {
		SendClientMessageEx(playerid, COLOR_PURPLE, "*** %s %s", GetNameWithMask(userid), PlayerInfo[userid][pDescribe]);
		if (!CompareStrings(PlayerInfo[userid][pDescribe2], "NULL")) {
			SendClientMessageEx(playerid, COLOR_PURPLE, ".. %s ***", PlayerInfo[userid][pDescribe2]);
		}
	}
	
	return 1;
}*/

ALTX:shout("/s");
CMD:shout(playerid, params[])
{
	if (PlayerInfo[playerid][pInjured] == 2)	return SendErrorMessage(playerid, "Ban khong the la het khi da chet.");
    if (PlayerInfo[playerid][pMutedTime] > 0)	return SendErrorMessage(playerid, "Tro chuyen cuc bo cua ban bi he thong chan.");
	if (isnull(params))							return SendHelpMessage(playerid, "(/s)hout [van ban]");

	if (strlen(params) > MAXLEN)
	{
		new pos = MAXLEN;

		if (pos < MAXLEN-1) pos = MAXLEN;

		SendLocalMessage(Range_Normal, playerid, COLOR_WHITE, COLOR_WHITE, COLOR_WHITE, COLOR_FADE1, COLOR_FADE2, "%s het len: %.*s ...", GetNameWithMask(playerid), pos, params);
		SendLocalMessage(Range_Normal, playerid, COLOR_WHITE, COLOR_WHITE, COLOR_WHITE, COLOR_FADE1, COLOR_FADE2, "... %s", params[pos]);
	}
	else
	{
		SendLocalMessage(Range_Normal, playerid, COLOR_WHITE, COLOR_WHITE, COLOR_WHITE, COLOR_FADE1, COLOR_FADE2, "%s het len: %s", GetNameWithMask(playerid), params);
	}
	return 1;
}

OOCMSG(color,string[])
{
	foreach(new i : Player)
	{
		if (!IsPlayerLogged(i) || (PlayerInfo[i][pSettings] & togOOC)) continue;

		SCM(i, color, string);
	}
	return 1;
}

NewsChat(color,string[])
{
	foreach(new i : Player)
	{
		if (!IsPlayerLogged(i) || (PlayerInfo[i][pSettings] & togNews)) continue;

		SCM(i, color, string);
	}
	return 1;
}

ProxDetectorOutOfCharacter(Float:radi, playerid, string[], color)
{
	foreach(new i : Player)
	{
		if (IsPlayerLogged(i) == 0 || 0 == PlayerNearPlayer(radi, playerid, i)) continue;

		SCM(i,color,string);
	}
	return 1;
}