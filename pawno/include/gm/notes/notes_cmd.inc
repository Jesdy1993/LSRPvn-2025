CMD:note(playerid, params[])
{
	new option[7], secoption[128];
	if (sscanf(params, "s[7]S(NULL)[128]", option, secoption)) return SendHelpMessage(playerid, "/note [show / create / remove / edit / give]");

	if (CompareStrings(option, "show"))
	{
		new count = 0;

		for(new i = 0; i < MAX_PLAYER_NOTES; i++)
		{
			if (PlayerNotes[playerid][i][noteOn] != 1) continue;

			SendClientMessageEx(playerid, COLOR_HELPS, "[So tay] Ghi chu [ID: %d]: %s", i+1, PlayerNotes[playerid][i][noteText]);

			count++;
		}

		if (count == 0) return SendErrorMessage(playerid, "Ban khong co ghi chu.");

		cmd::server_ame(playerid, "lay mot cuon so tu trong tui ra va nhin vao no.");
		return 1;
	}
	else if (CompareStrings(option, "edit"))
	{
		new slot, text[128];

		if (sscanf(params, "{s[7]}ds[128]", slot, text)) return SendHelpMessage(playerid, "/note edit [slot] [van ban moi]");
		if (!IsPlayerHasItem(playerid, INV_PEN)) 	return SendErrorMessage(playerid, "Ban khong co but.");
		if (slot < 1 || slot > MAX_PLAYER_NOTES) 		return SendErrorMessage(playerid, "Vi tri tu 1 den 10.");
		if (strlen(text) < 1 || strlen(text) > 127)		return SendErrorMessage(playerid, "Do dai cua van ban chi tu 1 den 127 ky tu. ");

		slot = slot - 1;

		if (PlayerNotes[playerid][slot][noteOn] != 1) 	return SendSyntaxMessage(playerid, "Ban khong co ghi chu nao trong vi tri nay.");
	
		format(PlayerNotes[playerid][slot][noteText], 128, "%s", text);
		SQL_SetString("player_notes", "text", text, PlayerNotes[playerid][slot][noteID]);
		cmd::server_ame(playerid, "lay mot cuon so tu trong tui ra va viet mot cai gi vao trong do ");
		SendSyntaxMessage(playerid, "Ban da thay doi ghi chu [ID: %i] thanh: %s", slot+1, text);
		return 1;
	}
	else if (CompareStrings(option, "create"))
	{
		new text[128];

		if (sscanf(params, "{s[7]}s[128]", text)) 		return SendHelpMessage(playerid, "/note create [van ban]");
		if (!IsPlayerHasItem(playerid, INV_PEN)) 		return SendErrorMessage(playerid,"Ban khong co but.");
		if (strlen(text) < 1 || strlen(text) > 127)		return SendErrorMessage(playerid, "Do dai van ban chi tu 1 den 127.");
    
		new noteid = -1;

		for(new i = 0; i < MAX_PLAYER_NOTES; i++)
		{
			if (PlayerNotes[playerid][i][noteOn] == 1) continue;

			noteid = i;
			break;
		}

		if (noteid == -1) return SendErrorMessage(playerid, "Khong co khong gian de viet vao so tay.");

		format(PlayerNotes[playerid][noteid][noteText], 128, "%s", text);
        PlayerNotes[playerid][noteid][noteOn] = 1;

		new query[128 + 128];
		mysql_format(dbHandle, query, sizeof(query), "INSERT INTO `player_notes` (userid, text) VALUES (%i, '%e')", PlayerInfo[playerid][pID], text);
		mysql_tquery(dbHandle, query, "OnNoteInsert", "ii", playerid, noteid);
		
        cmd::server_ame(playerid, "lay mot cuon so tu trong tui va viet mot cai gi do vao do. ");
		SendSyntaxMessage(playerid, "Ghi chu [ID: %i] da duoc tao thanh cong.", noteid+1);

		return 1;
	}
	else if (CompareStrings(option, "remove"))
	{
		new slot;

		if (sscanf(params, "{s[7]}d", slot)) 			return SendHelpMessage(playerid, "/note remove [slot]");
		if (slot < 1 || slot > MAX_PLAYER_NOTES)			return SendErrorMessage(playerid, "Vi tri khong chinh xac 1 - %i.", MAX_PLAYER_NOTES);

		slot = slot - 1;

		if (PlayerNotes[playerid][slot][noteOn] != 1)	return SendSyntaxMessage(playerid, "Ban khong co ghi chu nao trong vi tri nay.");
		PlayerNotes[playerid][slot][noteOn] = 0;
		PlayerNotes[playerid][slot][noteID] = 0;
		format(PlayerNotes[playerid][slot][noteText], 128, "");

		new query[128];
		mysql_format(dbHandle, query, sizeof(query), "DELETE FROM `player_notes` WHERE `id` = %i", PlayerNotes[playerid][slot][noteID]);
		mysql_tquery(dbHandle, query);

		cmd::server_ame(playerid, "lay mot cuon so tu trong tui ra, sau do xe mot trang ra va nem xuong dat. ");
		SendSyntaxMessage(playerid, "Ghi chu [ID: %i] da duoc xoa thanh cong.", slot+1);
		return 1;
	}
	else if (CompareStrings(option, "give"))
	{
		new targetid, slot;

		if (sscanf(params, "{s[7]}du", slot, targetid)) 	return SendHelpMessage(playerid, "/note give [slot] [ID/Ten]");
		if (slot < 1 || slot > MAX_PLAYER_NOTES)			return SendErrorMessage(playerid, "Vi tri tu 1 den 10.", MAX_PLAYER_NOTES);

		slot = slot - 1;

		if (PlayerNotes[playerid][slot][noteOn] != 1) 	return SendSyntaxMessage(playerid, "Khong co ghi chu nao trong vi tri nay.");
		if (targetid == playerid) 						return SendErrorMessage(playerid, "Ban khong the dua ghi chu cho chinh minh. ");
		if (!IsPlayerLogged(targetid)) 					return SendNotConnected(playerid);
		if (!PlayerNearPlayer(3.0, playerid, targetid))	return SendNotNearPlayer(playerid);

        new noteid = -1;

		for(new i = 0; i < MAX_PLAYER_NOTES; i++)
		{
			if (PlayerNotes[targetid][i][noteOn] == 1) continue;

			noteid = i;
			break;
		}

		if (noteid == -1) 								return SendErrorMessage(playerid, "Khong co cho trong trong so ghi chep cua nguoi choi de viet.");

		PlayerNotes[targetid][noteid][noteID] = PlayerNotes[playerid][slot][noteID];
		format(PlayerNotes[targetid][noteid][noteText], 128, "%s", PlayerNotes[playerid][slot][noteText]);
		PlayerNotes[targetid][noteid][noteOn] = 1;
		PlayerNotes[playerid][slot][noteID] = 0;
		PlayerNotes[playerid][slot][noteOn] = 0;

		SQL_SetInteger("player_notes", "userid", PlayerInfo[targetid][pID], PlayerNotes[playerid][slot][noteID]);
		SendSyntaxMessage(playerid, "Ban da dua ghi chu [ID: %i] cho nguoi choi %s [ID: %i].", slot+1, GetNameWithMask(targetid), targetid);
		SendSyntaxMessage(targetid, "Ban nhan duoc ghi chu [ID: %i] tu nguoi choi %s [ID: %i].", noteid+1, GetNameWithMask(playerid), playerid);
		
		new mes[128];
		format(mes, sizeof(mes), "lay trong tui mot cuon so, sau do xe trang va dua no cho %s.", GetNameWithMask(targetid));
		SetPlayerChatBubble(playerid, mes, COLOR_PURPLE, 20.0, 4000);
		return 1;
	}
	SendHelpMessage(playerid, "/note [show / create / remove / edit / give]");
	return 1;
}