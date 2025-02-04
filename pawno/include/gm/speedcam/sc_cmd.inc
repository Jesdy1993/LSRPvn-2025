ALTX:speedcam("/sc");
CMD:speedcam(playerid, params[])
{
    new option[16], secoption[128], faction = PlayerInfo[playerid][pFaction];

    if (!IsFactionPolice(faction))       return SendErrorMessage(playerid, "Ban phai la canh sat.");
    if (!PlayerInfo[playerid][pOnDuty])  return SendErrorMessage(playerid, "Ban phai trong gio lam viec.");

    if (sscanf(params, "s[16]S()[128]", option, secoption)) 
    {
        SendHelpMessage(playerid, "/sc [options]");
        SendHelpMessage(playerid, "create / remove / edit / list");
        return 1;
    }

    if (CompareStrings(option, "create"))
    {
        new id = SC_GetFreeID(), sp_limit, sp_name[32], sp_near = GetNearestSpeed(playerid, 20.0), sp_zone[64];

        if (id == -1)                                        return SendErrorMessage(playerid, "Tat ca cac vi tri danh cho may anh deu bi su dung.");
        if (sp_near != -1)                                   return SendErrorMessage(playerid, "Mot camera ban toc do da hoat dong trong ban kinh nay.");
        if (PlayerInfo[playerid][pRank] < SC_MIN_INSTALL)    return SendErrorMessage(playerid, "Lenh nay co san tu %i rank.", SC_MIN_INSTALL);
        if (sscanf(secoption, "d", sp_limit))                return SendHelpMessage(playerid, "/sc create [speed mode]");
        if (sp_limit <= 0 || sp_limit > SC_MAX_SPEED)        return SendErrorMessage(playerid, "Toc do gioi han chi tu 1 den %d.", SC_MAX_SPEED);

        GetPlayerPos(playerid, speedcam[id][sc_x], speedcam[id][sc_y], speedcam[id][sc_z]);
        GetPlayer2DZone(playerid, sp_zone, sizeof(sp_zone));

        format(speedcam[id][sc_name], 64, "%s %i", sp_zone, id);
        new Float:x, Float:y, Float:z;
		GetPlayerPos(playerid, x, y, z); 

        speedcam[id][sc_speed] = sp_limit;
        speedcam[id][sc_x] = x;
        speedcam[id][sc_y] = y+1;
        speedcam[id][sc_z] = z;
		speedcam[id][sc_rx] = 0;
        speedcam[id][sc_ry] = 0;
        speedcam[id][sc_rz] = 0;
        speedcam[id][sc_int] = GetPlayerInterior(playerid);
        speedcam[id][sc_vw] = GetPlayerVirtualWorld(playerid);
        speedcam[id][sc_object] = CreateDynamicObject(18880, speedcam[id][sc_x], speedcam[id][sc_y], speedcam[id][sc_z], speedcam[id][sc_rx], speedcam[id][sc_ry], speedcam[id][sc_rz], speedcam[id][sc_vw], speedcam[id][sc_int]);

        speedcam[id][sc_areaid] = CreateDynamicSphere(speedcam[id][sc_x], speedcam[id][sc_y], speedcam[id][sc_z], SC_DEF_RADIUS, speedcam[id][sc_vw], speedcam[id][sc_int]);

        AddSpeedcamToFile(id, sp_limit, sp_name, speedcam[id][sc_x], speedcam[id][sc_y], speedcam[id][sc_z], 0.0, 0.0, 0.0, speedcam[id][sc_int], speedcam[id][sc_vw]);
        SM2(playerid, "Ban da tao camera ban toc do [ID: %i] %s | Toc do gioi han: %d.", id, speedcam[id][sc_name], sp_limit);
        SendFactionMessage(FACTION_POLICE, COLOR_POLICECHAT, "(( %s da lap dat camera ban toc do %s | Toc do gioi han: %d. ))", GetName(playerid), speedcam[id][sc_name], sp_limit);
        return 1;
    }

    else if (CompareStrings(option, "remove"))
    {
        new sp_near = GetNearestSpeed(playerid, 20.0);
        
        if (sp_near == -1)                                   return SendErrorMessage(playerid, "Khong co camera ban toc do trong ban kinh nay. ");
        if (PlayerInfo[playerid][pRank] < SC_MIN_INSTALL)    return SendErrorMessage(playerid, "Lenh nay chi co san cho tu cap bac %i.", SC_MIN_INSTALL);

        if (IsValidDynamicObject(speedcam[sp_near][sc_object]))
        {
            DestroyDynamicObject(speedcam[sp_near][sc_object]);
            speedcam[sp_near][sc_object] = INVALID_OBJECT_ID;
        }

        new sql_query[128];

        SendWarningMessage(playerid, "Ban da xoa bo camera ban toc do [ID: %i | %s].", sp_near, speedcam[sp_near][sc_name]);
        SendFactionMessage(FACTION_POLICE, COLOR_POLICECHAT, "(( %s xoa bo camera ban toc do [%s]. ))", GetName(playerid), speedcam[sp_near][sc_name]);

        speedcam[sp_near][sc_name] = EOS;
        
        mysql_format(dbHandle, sql_query, sizeof(sql_query), "DELETE FROM `speedcams` WHERE `id` = %i", sp_near);
        mysql_tquery(dbHandle, sql_query);
        return 1;
    }

    else if (CompareStrings(option, "edit"))
    {
        new sp_near = GetNearestSpeed(playerid, 15.0), thirdoption[64], fouroption[64];

        if (sp_near == -1)                                   return SendErrorMessage(playerid, "Khong co camera ban toc do trong ban kinh nay. ");   
        if (PlayerInfo[playerid][pRank] < SC_MIN_INSTALL)    return SendErrorMessage(playerid, "Lenh nay chi co san cho tu cap bac %i.", SC_MIN_INSTALL);
        
        if (sscanf(secoption, "s[64]S()[64]", thirdoption, fouroption))        
        {
            SendHelpMessage(playerid, "/sc edit [tuy chon]");
            SendHelpMessage(playerid, "gioi han vi tri");
            return 1;
        }

        else if (CompareStrings(thirdoption, "limit"))
        {
            new sp_limit;

            if (sscanf(fouroption, "d", sp_limit))           return SendHelpMessage(playerid, "/sc edit limit [toc do gioi han]");
            if (sp_limit <= 0 || sp_limit > SC_MAX_SPEED)    return SendErrorMessage(playerid, "Toc do gioi han chi tu 1 den %d.", SC_MAX_SPEED);

            speedcam[sp_near][sc_speed] = sp_limit;
            SQL_SetInteger("speedcams", "speed", speedcam[sp_near][sc_speed], speedcam[sp_near][sc_id]);
            SendSyntaxMessage(playerid, "Da thay doi toc do cho camera [ID: %i] %s on %d.", sp_near, speedcam[sp_near][sc_name], sp_limit);
            SendFactionMessage(FACTION_POLICE, COLOR_POLICECHAT, "(( %s da thay doi toc do cho camera [ID: %i] %s on %d. ))", GetName(playerid), sp_near, speedcam[sp_near][sc_name], sp_limit);
            return 1;
        }

        else if (CompareStrings(thirdoption, "pos"))
        {
            SetPVarInt(playerid, "SC:ID", sp_near + 1);
            SetPVarInt(playerid, "SC:Edit", 1);
            EditDynamicObject(playerid, speedcam[sp_near][sc_object]);
            return 1;
        }
    }

    else if (CompareStrings(option, "list"))
    {
		new dialog_header[96] = "{FFFFFF}Camera\t{FFFFFF}ID cameras\t{FFFFFF}Toc do gioi han\n", dialog_body[3072];

		format(dialog_body, sizeof(dialog_body), "%s", dialog_header);

        for(new i; i < MAX_SPEEDCAMS; i++)
		{
			format(dialog_body, sizeof(dialog_body), "%s%s\t%i\t%d\n", dialog_body, speedcam[i][sc_name], i, speedcam[i][sc_speed]);
		}

		Dialog_Show(playerid, None, DIALOG_STYLE_TABLIST_HEADERS, "{FFFFFF}Camera List", dialog_body, "Dong", "");
    }  
    return 1;
}//�