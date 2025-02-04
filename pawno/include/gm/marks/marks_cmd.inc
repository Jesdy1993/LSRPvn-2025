CMD:mark(playerid, params[]) //метка
{
    if (!CheckAdmin(playerid, ADMIN_LEVEL_2))	return SendNotAdmin(playerid);
    
    new option[16], string[145];
    if (sscanf(params, "s[16]S()[144]", option, string))
    {
        SendHelpMessage(playerid, "/mark [options]");
        SendSyntaxMessage(playerid, "list / create / destroy / edit");
        return 1;
    }

    if (CompareStrings(option, "list"))
    {
        new list[512] = "{FFFFFF}Slot\t{FFFFFF}ID tags\n";
        for(new i = 0; i < MAX_PLAYER_MARKS; i++)
        {
            new markid = PlayerInfo[playerid][pMark][i];
            if (PlayerInfo[playerid][pMark][i] != -1)
            {
                format(list, sizeof(list), "%s%i\t%i\n", list, i + 1, markid);
            }
            else
            {
                format(list, sizeof(list), "%s%i\t%s\n", list, i + 1, RIGHT_NO);
            }
        }
        Dialog_Show(playerid, None, DIALOG_STYLE_TABLIST_HEADERS, "{FFFFFF}List of tags", list, "Close", "");
        return 1;
    }
    else if (CompareStrings(option, "create"))
    {
        new m_mes[129];
        if (sscanf(string, "s[128]",  m_mes))                    return SendHelpMessage(playerid, "/mark create [text]");
        if (strlen(m_mes) > 128)                                 return SendErrorMessage(playerid, "Label text up to 128 characters. ");

        new markid = Mark_GetPlayerFreeSlot(playerid);

        if (markid == -1)                                        return SendErrorMessage(playerid, "You can't create more %i tags.", MAX_PLAYER_MARKS);
        if (Mark_GetFreeID() == -1)                              return SendErrorMessage(playerid, "Label limit exceeded. Try to create a new label after a while. ");
        if (Mark_Nearest(playerid) != -1)                        return SendErrorMessage(playerid, "There is already a mark next to you. ");

        new mark = Mark_GetFreeID();

        PlayerInfo[playerid][pMark][markid] = mark;
        CreateDynamicMark(playerid, mark, m_mes);
        SendSyntaxMessage(playerid, "Label [ID: %i | SLOT: %i] was successfully created.", mark, markid + 1);
        return 1;
    }
    else if (CompareStrings(option, "destroy"))
    {
        new markid = Mark_Nearest(playerid);
        
        if (markid == -1)                                                    return SendErrorMessage(playerid, "There are no markers near you.");
        if (!CompareStrings(E_MARKS[markid][mCreator], GetNameEx(playerid)))  return SendErrorMessage(playerid, "This label does not belong to you.");

        DestroyDynamicMark(markid);
        SendSyntaxMessage(playerid, "You have removed your label [ID: %i].", markid);
        return 1;
    }
    else if (CompareStrings(option, "edit"))
    {
        new m_mes[129];
        if (sscanf(string, "s[128]", m_mes))         return SendHelpMessage(playerid, "/mark edit [new text]");
        if (strlen(m_mes) > 128)                     return SendErrorMessage(playerid, "Label text up to 128 characters.");

        new markid = Mark_Nearest(playerid);

        if (markid == -1)                                                                    return SendErrorMessage(playerid, "There are no markers near you.");
        if (!CompareStrings(E_MARKS[markid][mCreator], GetNameEx(playerid)))                 return SendErrorMessage(playerid,"This label does not belong to you.");

        format(E_MARKS[markid][mText], 128, "%s\n(( %s ))", m_mes, GetNameEx(playerid));
        SQL_SetString("marks", "text", E_MARKS[markid][mText], markid);
        UpdateDynamic3DTextLabelText(E_MARKS[markid][mLabel], 0xFFFFFFFF, E_MARKS[markid][mText]);
        SendSyntaxMessage(playerid, "You have set new text for your label [ID: %i].", markid);
    }
    else 
    {
        SendHelpMessage(playerid, "/mark [options]");
        SendSyntaxMessage(playerid, "list create destroy edit");
    }
    return 1;
}