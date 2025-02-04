ALTX:gr("/graffity"); //דנאפפטעט
CMD:gr(playerid, params[])
{
    new option[16], parameters[145];
    if (sscanf(params, "s[16]S()[144]", option, parameters))
    {
        SendHelpMessage(playerid, "(/gr)affity [create / stop]");
        return 1;
    }
    if (CompareStrings(option, "create"))
    {
        new g_text[33];
        if (sscanf(parameters, "s[32]", g_text))                                         return SendHelpMessage(playerid, "/gr create [van ban]");
        if (strlen(g_text) > MAX_GRAFFITY_TEXT || strlen(g_text) < MIN_GRAFFITY_TEXT)    return SendErrorMessage(playerid, "Toi thieu: %i ky tu, Toi da: %i ky tu.", MIN_GRAFFITY_TEXT, MAX_GRAFFITY_TEXT);
        if (Graffity_GetFreeID() == -1)                                                  return SendErrorMessage(playerid, "Da vuot qua gioi han graffiti. Hay thu tao graffiti sau.");
        if (AntiCheatGetWeapon(playerid) != 41)                                          return SendErrorMessage(playerid, "Ban nen co mot lon xit trong tay cua ban.");
        if (Graffity_GetAccepts(playerid) != -1) 
        {
            SendErrorMessage(playerid, "Ban da tao graffiti va no dang duoc xem xet.");
            SendSyntaxMessage(playerid, "Cho cho den khi buc ve graffiti bi tu choi hoac duoc chap thuan truoc khi son mot buc tranh moi.");
            return 1;
        }
        if (Graffity_Nearest(playerid) != -1)        return SendErrorMessage(playerid, "Da co graffiti ben canh ban. ");
        if (Graffity_GetPlayerEdit(playerid) != -1)  return SendErrorMessage(playerid, "Ban dang chinh sua graffiti.");
        if (IsPlayerInAnyVehicle(playerid))          return SendErrorMessage(playerid, "Ban khong duoc o trong xe. ");
        if (PlayerInfo[playerid][pInjured])          return SendErrorMessage(playerid, "Ban khong the ve graffiti khi bi thuong / chet. ");
        
        Graffity_CreateTemporary(playerid, g_text);
        return 1;
    }
    else if (CompareStrings(option, "stop"))
    {
        if (Graffity_GetPlayerEdit(playerid) == -1)      return SendErrorMessage(playerid, "Ban khong chinh sua graffiti. ");
        if (!GetPVarInt(playerid, "Graffity:Spraying"))   return SendErrorMessage(playerid, "Ban khong ve graffiti.");
        
        SendSyntaxMessage(playerid, "Tao graffiti da bi huy.");
        Graffity_DestroyTemporary(Graffity_GetPlayerEdit(playerid), 1);
        Graffity_ResetPlayer(playerid);
        UnFreezePlayer(playerid);
        cmd::stopanim(playerid, "");
        return 1;
    }
    else
    {
        SendHelpMessage(playerid, "(/gr)affity [create / stop]");
    }
    return 1;
}