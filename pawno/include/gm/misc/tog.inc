CMD:tog(playerid, params[])
{
	new option[16];
	if (sscanf(params, "s[16]", option))
	{
		SendHelpMessage(playerid, "/tog [options]");
		SendSyntaxMessage(playerid, "hud ooc join ads gov");
		SendSyntaxMessage(playerid, "pm adm f news afk enter animchat");
		return 1;
	}

	if (CompareStrings(option, "name"))
	{
		if (PlayerInfo[playerid][pSettings] & togName)
		{
			PlayerInfo[playerid][pSettings] &= ~togName;
			SQL_SetInteger("users", "settings", PlayerInfo[playerid][pSettings], PlayerInfo[playerid][pID]);
			foreach(new i : Player)
			{
				ShowPlayerNameTagForPlayer(playerid, i, 1);
			}
			SendSyntaxMessage(playerid, "Ban da bat hien thi biet hieu cua nguoi choi.");
		}
		else
		{
			PlayerInfo[playerid][pSettings] |= togName;
			SQL_SetInteger("users", "settings", PlayerInfo[playerid][pSettings], PlayerInfo[playerid][pID]);
			foreach(new i : Player)
			{
				ShowPlayerNameTagForPlayer(playerid, i, 0);
			}
			SendSyntaxMessage(playerid, "Ban da tat hien thi biet hieu cua nguoi choi.");
		}
	}

	else if (CompareStrings(option, "hud"))
	{
		if (PlayerInfo[playerid][pSettings] & togHUD)
		{
			PlayerInfo[playerid][pSettings] &= ~togHUD;
			SQL_SetInteger("users", "settings", PlayerInfo[playerid][pSettings], PlayerInfo[playerid][pID]);
			ShowHudTextDraw(playerid);
			SendSyntaxMessage(playerid, "Ban da bat HUD.");
		}
		else
		{
			PlayerInfo[playerid][pSettings] |= togHUD;
			SQL_SetInteger("users", "settings", PlayerInfo[playerid][pSettings], PlayerInfo[playerid][pID]);
			HideHudTextDraw(playerid);
			SendSyntaxMessage(playerid, "Ban da tat HUD. ");
		}
	}

	else if (CompareStrings(option, "ooc"))
	{
		if (PlayerInfo[playerid][pSettings] & togOOC)
		{
			PlayerInfo[playerid][pSettings] &= ~togOOC;
			SQL_SetInteger("users", "settings", PlayerInfo[playerid][pSettings], PlayerInfo[playerid][pID]);
			SendSyntaxMessage(playerid, "Ban da bat OOC chat.");
		}
		else 
		{
			PlayerInfo[playerid][pSettings] |= togOOC;
			SQL_SetInteger("users", "settings", PlayerInfo[playerid][pSettings], PlayerInfo[playerid][pID]);
			SendSyntaxMessage(playerid, "Ban da tat OOC chat.");
		}
	}

	else if (CompareStrings(option, "join"))
	{
		if (PlayerInfo[playerid][pSettings] & togJoin)
		{
			PlayerInfo[playerid][pSettings] &= ~togJoin;
			SQL_SetInteger("users", "settings", PlayerInfo[playerid][pSettings], PlayerInfo[playerid][pID]);
			SendSyntaxMessage(playerid, "Ban da bat hien thi thong tin ve viec vao / ra cua nhung nguoi choi gan ban.");
		}
		else 
		{
			PlayerInfo[playerid][pSettings] |= togJoin;
			SQL_SetInteger("users", "settings", PlayerInfo[playerid][pSettings], PlayerInfo[playerid][pID]);
			SendSyntaxMessage(playerid, "Ban da tat hien thi thong tin ve viec vao / ra cua nhung nguoi choi gan ban. ");
		}
	}

	else if (CompareStrings(option, "ads"))
	{
		if (PlayerInfo[playerid][pSettings] & togAdv)
		{
			PlayerInfo[playerid][pSettings] &= ~togAdv;
			SQL_SetInteger("users", "settings", PlayerInfo[playerid][pSettings], PlayerInfo[playerid][pID]);
			SendSyntaxMessage(playerid, "Ban da bat hien thi quang cao. ");
		}
		else
		{
			PlayerInfo[playerid][pSettings] |= togAdv;
			SQL_SetInteger("users", "settings", PlayerInfo[playerid][pSettings], PlayerInfo[playerid][pID]);
			SendSyntaxMessage(playerid, "Ban da tat hien thi quang cao.");
		}
	}

	else if (CompareStrings(option, "gov"))
	{
		if (PlayerInfo[playerid][pSettings] & togGov)
		{
			PlayerInfo[playerid][pSettings] &= ~togGov;
			SQL_SetInteger("users", "settings", PlayerInfo[playerid][pSettings], PlayerInfo[playerid][pID]);
			SendSyntaxMessage(playerid, "Ban da bat the hien thi tin tuc chinh phu. ");
		}
		else
		{
			PlayerInfo[playerid][pSettings] |= togGov;
			SQL_SetInteger("users", "settings", PlayerInfo[playerid][pSettings], PlayerInfo[playerid][pID]);
			SendSyntaxMessage(playerid, "Ban da tat hien thi tin tuc chinh phu.");
		}
	}

	else if (CompareStrings(option, "pm"))
	{
		if (PlayerInfo[playerid][pSettings] & togPM)
		{
			PlayerInfo[playerid][pSettings] &= ~togPM;
			SQL_SetInteger("users", "settings", PlayerInfo[playerid][pSettings], PlayerInfo[playerid][pID]);
			SendSyntaxMessage(playerid, "Ban da bat the nhan tin nhan rieng tu.");
		}
		else 
		{
			PlayerInfo[playerid][pSettings] |= togPM;
			SQL_SetInteger("users", "settings", PlayerInfo[playerid][pSettings], PlayerInfo[playerid][pID]);
			SendSyntaxMessage(playerid,"Ban da tat nhan tin nhan rieng tu.");
		}
	}

	else if (CompareStrings(option, "adm"))
	{
		if (PlayerInfo[playerid][pSettings] & togAdmCmds)
		{
			PlayerInfo[playerid][pSettings] &= ~togAdmCmds;
			SQL_SetInteger("users", "settings", PlayerInfo[playerid][pSettings], PlayerInfo[playerid][pID]);
			SendSyntaxMessage(playerid, "Ban da bat su hien thi cua quan tri vien. thong bao. ");
		}
		else
		{
			PlayerInfo[playerid][pSettings] |= togAdmCmds;
			SQL_SetInteger("users", "settings", PlayerInfo[playerid][pSettings], PlayerInfo[playerid][pID]);
			SendSyntaxMessage(playerid, "Ban da tat su hien thi cua quan tri vien. thong bao. ");
		}
	}

	else if (CompareStrings(option, "f"))
	{
		if (PlayerInfo[playerid][pSettings] & togFaction)
		{
			PlayerInfo[playerid][pSettings] &= ~togFaction;
			SQL_SetInteger("users", "settings", PlayerInfo[playerid][pSettings], PlayerInfo[playerid][pID]);
			SendSyntaxMessage(playerid, "Ban da bat hien thi cac thong bao cua phe phai. ");
		}
		else 
		{
			PlayerInfo[playerid][pSettings] |= togFaction;
			SQL_SetInteger("users", "settings", PlayerInfo[playerid][pSettings], PlayerInfo[playerid][pID]);
			SendSyntaxMessage(playerid, "Ban da tat hien thi cac thong bao cua phe phai.");
		}
	}

	else if (CompareStrings(option, "news"))
	{
		if (PlayerInfo[playerid][pSettings] & togNews)
		{
			PlayerInfo[playerid][pSettings] &= ~togNews;
			SQL_SetInteger("users", "settings", PlayerInfo[playerid][pSettings], PlayerInfo[playerid][pID]);
			SendSyntaxMessage(playerid, "Ban da bat hien thi tin tuc tu SAN.");
		}
		else 
		{
			PlayerInfo[playerid][pSettings] |= togNews;
			SQL_SetInteger("users", "settings", PlayerInfo[playerid][pSettings], PlayerInfo[playerid][pID]);
			SendSyntaxMessage(playerid, "Ban da tat hien thi tin tuc tu SAN. ");
		}
	}

	else if (CompareStrings(option, "afk"))
	{
		if (PlayerInfo[playerid][pSettings] & togAFK)
		{
			PlayerInfo[playerid][pSettings] &= ~togAFK;
			SQL_SetInteger("users", "settings", PlayerInfo[playerid][pSettings], PlayerInfo[playerid][pID]);
			SendSyntaxMessage(playerid, "Ban da bat thoi gian o AFK. ");
		}
		else 
		{
			PlayerInfo[playerid][pSettings] |= togAFK;
			SQL_SetInteger("users", "settings", PlayerInfo[playerid][pSettings], PlayerInfo[playerid][pID]);
			SendSyntaxMessage(playerid, "Ban da tat thoi gian o AFK.");
		}
	}

	else if (CompareStrings(option, "enter"))
	{
		if (PlayerInfo[playerid][pSettings] & togEnter)
		{
			PlayerInfo[playerid][pSettings] &= ~togEnter;
			SQL_SetInteger("users", "settings", PlayerInfo[playerid][pSettings], PlayerInfo[playerid][pID]);
			SendSyntaxMessage(playerid, "Ban da bat I / O voi nut 'F'. ");
		}
		else 
		{
			PlayerInfo[playerid][pSettings] |= togEnter;
			SQL_SetInteger("users", "settings", PlayerInfo[playerid][pSettings], PlayerInfo[playerid][pID]);
			SendSyntaxMessage(playerid, "Ban da tat I / O voi nut 'F'. ");
		}
	}

	else if (CompareStrings(option, "service"))
	{
		if (PlayerInfo[playerid][pSettings] & togService)
		{
			PlayerInfo[playerid][pSettings] &= ~togService;
			SQL_SetInteger("users", "settings", PlayerInfo[playerid][pSettings], PlayerInfo[playerid][pID]);
			SendSyntaxMessage(playerid, "Ban da bat su hien thi cua cac dich vu [REPORT | HELP | REQUEST]. ");
		}
		else 
		{
			PlayerInfo[playerid][pSettings] |= togService;
			SQL_SetInteger("users", "settings", PlayerInfo[playerid][pSettings], PlayerInfo[playerid][pID]);
			SendSyntaxMessage(playerid, "Ban da tat su hien thi cua cac dich vu [REPORT | HELP | REQUEST]. ");
		}
	}
	else 
	{
		SendHelpMessage(playerid, "/tog [options]");
		SendSyntaxMessage(playerid, "name hud ooc join ads gov");
		SendSyntaxMessage(playerid, "pm adm f news afk enter");
	}
	return 1;
}

HUD_OnPlayerStateChange(playerid, newstate, oldstate)
{
	if (newstate == PLAYER_STATE_DRIVER)
	{
		if (!(PlayerInfo[playerid][pSettings] & togHUD))
		{
			PlayerTextDrawShow(playerid, SpeedText[playerid]);
		}
	}
	
	if (oldstate == PLAYER_STATE_DRIVER)
	{
		PlayerTextDrawHide(playerid, SpeedText[playerid]);
	}
	return 1;
}