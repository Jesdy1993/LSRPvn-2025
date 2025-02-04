CMD:testerhelp(playerid, params[])
{
	if (PlayerInfo[playerid][pHelper] == 0) return SendNotAdmin(playerid);
	SCM(playerid, COLOR_WHITE, "[TESTER]: {C3C3C3}/tduty /(t)chat /togtchat /freeze /an (/agr)eegraffiti");
	return 1;
}

CMD:tduty(playerid, params[])
{
	if (PlayerInfo[playerid][pHelper] < 1)	return SendNotAdmin(playerid);
    if (IsAdminDuty(playerid))				return SendErrorMessage(playerid, "Ban dang o trong Admin duty.");
        
	if (IsTesterDuty(playerid) == 1)
	{
	    StaffMSG(HELPER_DUTY, "AdmCmd: %s thoat tester-duty.", GetAccName(playerid));
	    pTemp[playerid][pTesterDuty] = 0;
		SetPlayerColor(playerid, TEAM_HIT_COLOR);
	}
	else
	{
		pTemp[playerid][pTesterDuty] = 1;
		StaffMSG(HELPER_DUTY, "AdmCmd: %s lam viec tester-duty.", GetAccName(playerid));
		SetPlayerColor(playerid, HELPER_DUTY);
	}
	return 1;
}


ALTX:tchat("/t");
CMD:tchat(playerid, params[])
{
	if (!IsTester(playerid) && !CheckAdmin(playerid, ADMIN_LEVEL_1))	return SendNotAdmin(playerid);
    if (PlayerInfo[playerid][pSettings] & togTester)					return SendErrorMessage(playerid, "Bat tester caht (/togtchat).");
	if (isnull(params))													return SendHelpMessage(playerid, "/(t)chat [text]");

	new prefix[16] = "TESTER";

	if (PlayerInfo[playerid][pAdmin] > 0) prefix = "ADMIN";

	new mes[128];
	if (strlen(params) > MAXLEN)
	{
		new pos = MAXLEN;

		if (pos < MAXLEN-1) pos = MAXLEN;
		
		format(mes, sizeof(mes), "* [%s] %s(%i): %.*s ...", prefix, GetAccName(playerid), playerid, pos, params);
		SendStaffMessage(COLOR_LIGHTGREEN, mes);
		format(mes, sizeof(mes), "... %s", params[pos]);
		SendStaffMessage(COLOR_LIGHTGREEN, mes);
	}
	else
	{
		format(mes, sizeof(mes), "* [%s] %s(%i): %s", prefix, GetAccName(playerid), playerid, params);
		SendStaffMessage(COLOR_LIGHTGREEN, mes);
	}
	return 1;
}

CMD:togtchat(playerid, params[])
{
	if (!IsTester(playerid) && !CheckAdmin(playerid, ADMIN_LEVEL_1)) return SendNotAdmin(playerid);

    if (PlayerInfo[playerid][pSettings] & togTester)
	{
		PlayerInfo[playerid][pSettings] &= ~togTester;
    	SendSyntaxMessage(playerid, "Ban da bat testers chat.");
	}
	else
	{
		PlayerInfo[playerid][pSettings] |= togTester;
		SendSyntaxMessage(playerid, "Ban da tat the testers chat.");
	}
	return 1;
}

ALTX:agreegraffiti("/agr");
CMD:agreegraffiti(playerid, params[])
{
	new option[16], parameters[128];
	if (!IsTester(playerid) && !CheckAdmin(playerid, ADMIN_LEVEL_1)) return SendNotAdmin(playerid);
	if (sscanf(params, "s[16]S()[127]", option, parameters))
	{
		SendHelpMessage(playerid, "(/agr)eegraffiti [options]");
		if (CheckAdmin(playerid, ADMIN_LEVEL_1))
		{
			return SendSyntaxMessage(playerid, "list / goto / show / accept / decline / info / destroy");
		}
		else
		{
			return SendSyntaxMessage(playerid, "list / goto / show / accept / decline");
		}
	}
	if (CompareStrings(option, "list"))
	{
		return Graffity_GetAcceptList(playerid);
	}
	else if (CompareStrings(option, "goto"))
	{
		new grafid;

		if (sscanf(parameters, "d", grafid)) 															 return SendHelpMessage(playerid, "/agreegraffitigoto [ID graffiti]");
		if (grafid < 0 || grafid >= MAX_GRAFFITIES || !E_GRAFFITY[grafid][gON])							 return SendErrorMessage(playerid, "No graffiti with this ID found.");
		if (IsTester(playerid) && !CheckAdmin(playerid, ADMIN_LEVEL_1) && E_GRAFFITY[grafid][gAccepted]) return SendErrorMessage(playerid, "This graffiti has already been approved. It is impossible to teleport to him.");

		SetPlayerPosEx(playerid, E_GRAFFITY[grafid][gGotoX], E_GRAFFITY[grafid][gGotoY], E_GRAFFITY[grafid][gGotoZ]);
		SetInterior(playerid, E_GRAFFITY[grafid][gInterior]);
		SetWorld(playerid, E_GRAFFITY[grafid][gVW]);
	}
	else if (CompareStrings(option, "show"))
	{
		new g_id = Graffity_Nearest(playerid);

		if (g_id == -1) 										return SendErrorMessage(playerid, "There is no graffiti near you.");
		if (E_GRAFFITY[g_id][gAccepted])						return SendErrorMessage(playerid, "Graffiti needs no consideration.");
		if (E_GRAFFITY[g_id][gEditing])							return SendErrorMessage(playerid, "The graffiti is currently being edited. Please wait a while.");
		if (IsValidDynamicObject(E_GRAFFITY[g_id][gObject])) 	return SendErrorMessage(playerid, "Graffiti already exists.");

		E_GRAFFITY[g_id][gObject] = CreateDynamicObject(GRAFFITY_OBJECT_ID, E_GRAFFITY[g_id][gPosX], E_GRAFFITY[g_id][gPosY], E_GRAFFITY[g_id][gPosZ], E_GRAFFITY[g_id][gRotX], E_GRAFFITY[g_id][gRotY], E_GRAFFITY[g_id][gRotZ], E_GRAFFITY[g_id][gVW], E_GRAFFITY[g_id][gInterior]);
    	SetDynamicObjectMaterial(E_GRAFFITY[g_id][gObject], 0, 0, "none", "none", 0);
    	SetDynamicObjectMaterialText(E_GRAFFITY[g_id][gObject], 0, E_GRAFFITY[g_id][gText], OBJECT_MATERIAL_SIZE_256x32, E_GRAFFITY[g_id][gFont], E_GRAFFITY[g_id][gFontSize], E_GRAFFITY[g_id][gBold], E_GRAFFITY[g_id][gColor], E_GRAFFITY[g_id][gBackColor], 0);
		SetPVarInt(playerid, "Tester:Graffity", g_id+1);
		SetPVarInt(playerid, "Tester:GraffityTime", 10);
		SendSyntaxMessage(playerid, "After 10 seconds, the graffiti will disappear.");
	}
	else if (CompareStrings(option, "accept"))
	{
		new g_id = Graffity_Nearest(playerid);

		if (g_id == -1) 				 return SendErrorMessage(playerid, "There is no graffiti near you.");
		if (E_GRAFFITY[g_id][gAccepted]) return SendErrorMessage(playerid, "The graffiti needs no consideration.");
		if (E_GRAFFITY[g_id][gEditing])	 return SendErrorMessage(playerid, "The graffiti is currently being edited. Please wait a while.");
		
		Graffity_Accept(g_id, playerid);
		return 1;
	}
	else if (CompareStrings(option, "decline"))
	{
		new g_id = Graffity_Nearest(playerid);

		if (g_id == -1)					 return SendErrorMessage(playerid, "There is no graffiti near you.");
		if (E_GRAFFITY[g_id][gAccepted]) return SendErrorMessage(playerid, "The graffiti needs no consideration.");
		if (E_GRAFFITY[g_id][gEditing])	 return SendErrorMessage(playerid, "The graffiti is currently being edited. Please wait a while.");

		Graffity_Decline(g_id, playerid);
		return 1;
	}
	else if (CompareStrings(option, "info"))
	{
		new g_id = Graffity_Nearest(playerid);

		if (IsTester(playerid) && !CheckAdmin(playerid, ADMIN_LEVEL_1)) return SendNotAdmin(playerid);
		if (g_id == -1)												   	return SendErrorMessage(playerid, "There is no graffiti near you.");
		if (E_GRAFFITY[g_id][gEditing])								 	return SendErrorMessage(playerid, "The graffiti is currently being edited. Please wait a while.");

		new msg[1024] = "{FFFFFF}", msgcat[128];
		format(msg, sizeof(msg), "{FFFFFF}ID graffiti\t%d\nCreator\t%s\nCreation date\t%s\nFont\t%s\n", g_id, E_GRAFFITY[g_id][gCreator], E_GRAFFITY[g_id][gCreateDate], E_GRAFFITY[g_id][gFont]);
		if (E_GRAFFITY[g_id][gAccepted])
		{
			format(msgcat, sizeof(msgcat), "	\nApproved\t%s\nDate of approval\t%s\n", E_GRAFFITY[g_id][gAcceptor], E_GRAFFITY[g_id][gAcceptDate]); //�
		}
		strcat(msg, msgcat);

		Dialog_Show(playerid, None, DIALOG_STYLE_TABLIST, "{FFFFFF}Information about graffiti", msg, "Close", "");
	}
	else if (CompareStrings(option, "destroy"))
	{
		new g_id;

		if (IsTester(playerid) && !CheckAdmin(playerid, ADMIN_LEVEL_1))		return SendNotAdmin(playerid);
		if (sscanf(parameters, "d", g_id)) 									return SendErrorMessage(playerid, "/agreegraffitidestroy [ID graffiti]");
		if (g_id < 0 || g_id >= MAX_GRAFFITIES || !E_GRAFFITY[g_id][gON])	return SendErrorMessage(playerid, "No graffiti with this ID found.");
		if (E_GRAFFITY[g_id][gEditing])										return SendErrorMessage(playerid, "The graffiti is currently being edited. Please wait a while.");
		if (!E_GRAFFITY[g_id][gAccepted])									return SendErrorMessage(playerid, "The graffiti is not yet approved. If you want to remove it - use /gr decline.");
		
		Graffity_Destroy(g_id);
		SendSyntaxMessage(playerid, "You removed the graffiti [ID: %i].", g_id);
	}
	else 
	{
		SendHelpMessage(playerid, "/agreegraffiti [options]");
		if (CheckAdmin(playerid, ADMIN_LEVEL_1))
		{
			return SendSyntaxMessage(playerid, "list / goto / show / accept / decline / info / destroy");
		}
		else
		{
			return SendSyntaxMessage(playerid, "list / goto / show / accept / decline");
		}
	}
	return 1;
}