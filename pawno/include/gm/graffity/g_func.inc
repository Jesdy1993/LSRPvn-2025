forward LoadDynamicGraffities();

public LoadDynamicGraffities()
{
    new rows = cache_num_rows(), time = GetTickCount(), total;

    if (!rows)   return print("[Graffities] Khong co du lieu nao duoc tim thay.");

    for(new i = 0; i < rows; i++)
    {
        if (i >= MAX_GRAFFITIES) break;
        E_GRAFFITY[i][gID] = cache_get_field_content_int(i, "id");
        cache_get_field_content(i, "text", E_GRAFFITY[i][gText], dbHandle, MAX_GRAFFITY_TEXT);
        E_GRAFFITY[i][gColor] = cache_get_field_content_int(i, "color");
        E_GRAFFITY[i][gBackColor] = cache_get_field_content_int(i, "back_color");
        cache_get_field_content(i, "font", E_GRAFFITY[i][gFont], dbHandle, 16);
        E_GRAFFITY[i][gFontSize] = cache_get_field_content_int(i, "font_size");
        E_GRAFFITY[i][gBold] = cache_get_field_content_int(i, "bold");
        cache_get_field_content(i, "creator", E_GRAFFITY[i][gCreator], dbHandle, 32);
        cache_get_field_content(i, "c_date", E_GRAFFITY[i][gCreateDate], dbHandle, 64);
        E_GRAFFITY[i][gPosX] = cache_get_field_content_float(i, "posx");
        E_GRAFFITY[i][gPosY] = cache_get_field_content_float(i, "posy");
        E_GRAFFITY[i][gPosZ] = cache_get_field_content_float(i, "posz");
        E_GRAFFITY[i][gRotX] = cache_get_field_content_float(i, "rotx");
        E_GRAFFITY[i][gRotY] = cache_get_field_content_float(i, "roty");
        E_GRAFFITY[i][gRotZ] = cache_get_field_content_float(i, "rotz");
        E_GRAFFITY[i][gGotoX] = cache_get_field_content_float(i, "gotox");
        E_GRAFFITY[i][gGotoY] = cache_get_field_content_float(i, "gotoy");
        E_GRAFFITY[i][gGotoZ] = cache_get_field_content_float(i, "gotoz");
        E_GRAFFITY[i][gInterior] = cache_get_field_content_int(i, "interior");
        E_GRAFFITY[i][gVW] = cache_get_field_content_int(i, "world");
        E_GRAFFITY[i][gAccepted] = cache_get_field_content_int(i, "accepted");
        cache_get_field_content(i, "acceptor", E_GRAFFITY[i][gAcceptor], dbHandle, 32);
        cache_get_field_content(i, "a_date", E_GRAFFITY[i][gAcceptDate], dbHandle, 64);

        E_GRAFFITY[i][gON] = 1;
        E_GRAFFITY[i][gEditing] = 0;
        if (E_GRAFFITY[i][gAccepted])
        {
            E_GRAFFITY[i][gObject] = CreateDynamicObject(GRAFFITY_OBJECT_ID, E_GRAFFITY[i][gPosX], E_GRAFFITY[i][gPosY], E_GRAFFITY[i][gPosZ], E_GRAFFITY[i][gRotX], E_GRAFFITY[i][gRotY], E_GRAFFITY[i][gRotZ], E_GRAFFITY[i][gVW], E_GRAFFITY[i][gInterior]);
            SetDynamicObjectMaterial(E_GRAFFITY[i][gObject], 0, 0, "none", "none", 0);
            SetDynamicObjectMaterialText(E_GRAFFITY[i][gObject], 0, E_GRAFFITY[i][gText], OBJECT_MATERIAL_SIZE_256x32, E_GRAFFITY[i][gFont], E_GRAFFITY[i][gFontSize], E_GRAFFITY[i][gBold], E_GRAFFITY[i][gColor], E_GRAFFITY[i][gBackColor], 0);
        }

        total++;
    }
    printf("[Graffities] Rows - %i. Load - %i. Time: %i ms", rows, total, GetTickCount()-time);
    return 1;
}

Graffity_Nearest(playerid)
{
    for(new i = 0; i < MAX_GRAFFITIES; i++)
    {
        if (E_GRAFFITY[i][gON])
        {
            if (IsPlayerInRangeOfPoint(playerid, 10.0, E_GRAFFITY[i][gPosX], E_GRAFFITY[i][gPosY], E_GRAFFITY[i][gPosZ]) && GetInterior(playerid) == E_GRAFFITY[i][gInterior] && GetWorld(playerid) == E_GRAFFITY[i][gVW])
            {
                return i;
            }
        }
    }
    return -1;
}

Graffity_GetFreeID()
{
    for(new i = 0; i < MAX_GRAFFITIES; i++)
    {
        if (!E_GRAFFITY[i][gON]) return i;
    }
    return -1;
}

Graffity_SetText(g_id, g_text[])
{
    if (!E_GRAFFITY[g_id][gON]) return -1;
    format(E_GRAFFITY[g_id][gText], 32, "%s", g_text);
    SetDynamicObjectMaterialText(E_GRAFFITY[g_id][gObject], 0, E_GRAFFITY[g_id][gText], OBJECT_MATERIAL_SIZE_256x32, E_GRAFFITY[g_id][gFont], E_GRAFFITY[g_id][gFontSize], E_GRAFFITY[g_id][gBold], E_GRAFFITY[g_id][gColor], E_GRAFFITY[g_id][gBackColor], 0);
    return 1;
}

Graffity_SetColor(g_id, g_color)
{
    if (!E_GRAFFITY[g_id][gON]) return -1;
    E_GRAFFITY[g_id][gColor] = g_color;  
    SetDynamicObjectMaterialText(E_GRAFFITY[g_id][gObject], 0, E_GRAFFITY[g_id][gText], OBJECT_MATERIAL_SIZE_256x32, E_GRAFFITY[g_id][gFont], E_GRAFFITY[g_id][gFontSize], E_GRAFFITY[g_id][gBold], E_GRAFFITY[g_id][gColor], E_GRAFFITY[g_id][gBackColor], 0);
    return 1;
}

Graffity_SetBackColor(g_id, g_color)
{
    if (!E_GRAFFITY[g_id][gON]) return -1;
    E_GRAFFITY[g_id][gBackColor] = g_color;
    SetDynamicObjectMaterialText(E_GRAFFITY[g_id][gObject], 0, E_GRAFFITY[g_id][gText], OBJECT_MATERIAL_SIZE_256x32, E_GRAFFITY[g_id][gFont], E_GRAFFITY[g_id][gFontSize], E_GRAFFITY[g_id][gBold], E_GRAFFITY[g_id][gColor], E_GRAFFITY[g_id][gBackColor], 0);
    return 1;
}

Graffity_SetFont(g_id, g_font[])
{
    if (!E_GRAFFITY[g_id][gON])  return -1;
    format(E_GRAFFITY[g_id][gFont], 16, "%s", g_font);
    SetDynamicObjectMaterialText(E_GRAFFITY[g_id][gObject], 0, E_GRAFFITY[g_id][gText], OBJECT_MATERIAL_SIZE_256x32, E_GRAFFITY[g_id][gFont], E_GRAFFITY[g_id][gFontSize], E_GRAFFITY[g_id][gBold], E_GRAFFITY[g_id][gColor], E_GRAFFITY[g_id][gBackColor], 0);
    return 1;
}

Graffity_SetFontSize(g_id, g_fontsize)
{
    if (!E_GRAFFITY[g_id][gON]) return -1;
    E_GRAFFITY[g_id][gFontSize] = g_fontsize;
    SetDynamicObjectMaterialText(E_GRAFFITY[g_id][gObject], 0, E_GRAFFITY[g_id][gText], OBJECT_MATERIAL_SIZE_256x32, E_GRAFFITY[g_id][gFont], E_GRAFFITY[g_id][gFontSize], E_GRAFFITY[g_id][gBold], E_GRAFFITY[g_id][gColor], E_GRAFFITY[g_id][gBackColor], 0);
    return 1;
}

Graffity_SetBold(g_id, g_bold)
{
    if (!E_GRAFFITY[g_id][gON]) return -1;
    E_GRAFFITY[g_id][gBold] = g_bold;
    SetDynamicObjectMaterialText(E_GRAFFITY[g_id][gObject], 0, E_GRAFFITY[g_id][gText], OBJECT_MATERIAL_SIZE_256x32, E_GRAFFITY[g_id][gFont], E_GRAFFITY[g_id][gFontSize], E_GRAFFITY[g_id][gBold], E_GRAFFITY[g_id][gColor], E_GRAFFITY[g_id][gBackColor], 0);
    return 1;
}

Graffity_ResetVariables(g_id)
{
    E_GRAFFITY[g_id][gID] = -1;
    E_GRAFFITY[g_id][gText][0] = 
    E_GRAFFITY[g_id][gFont][0] = 
    E_GRAFFITY[g_id][gCreator][0] =
    E_GRAFFITY[g_id][gCreateDate][0] =
    E_GRAFFITY[g_id][gAcceptor][0] = 
    E_GRAFFITY[g_id][gAcceptDate][0] = EOS;
    E_GRAFFITY[g_id][gColor] = 
    E_GRAFFITY[g_id][gBackColor] =
    E_GRAFFITY[g_id][gFontSize] =
    E_GRAFFITY[g_id][gBold] = 
    E_GRAFFITY[g_id][gInterior] = 
    E_GRAFFITY[g_id][gVW] = 
    E_GRAFFITY[g_id][gAccepted] = 0;
    E_GRAFFITY[g_id][gPosX] = 
    E_GRAFFITY[g_id][gPosY] = 
    E_GRAFFITY[g_id][gPosZ] = 
    E_GRAFFITY[g_id][gRotX] = 
    E_GRAFFITY[g_id][gRotY] = 
    E_GRAFFITY[g_id][gRotZ] = 
    E_GRAFFITY[g_id][gGotoX] = 
    E_GRAFFITY[g_id][gGotoY] = 
    E_GRAFFITY[g_id][gGotoZ] =
    E_GRAFFITY[g_id][gON] = 0;
    E_GRAFFITY[g_id][gObject] = INVALID_OBJECT_ID;
    return 1;
}

Graffity_Accept(g_id, playerid)
{
    if (!E_GRAFFITY[g_id][gON]) return -1;
    if (E_GRAFFITY[g_id][gAccepted]) return -2;

    E_GRAFFITY[g_id][gAccepted] = 1;
    format(E_GRAFFITY[g_id][gAcceptor], 32, "%s", GetNameEx(playerid));
    format(E_GRAFFITY[g_id][gAcceptDate], 64, "%s", GetFullDate());
    SQL_SetInteger("graffities", "accepted", E_GRAFFITY[g_id][gAccepted], g_id);
    SQL_SetString("graffities", "acceptor", E_GRAFFITY[g_id][gAcceptor], g_id);
    SQL_SetString("graffities", "a_date", E_GRAFFITY[g_id][gAcceptDate], g_id);

    if (!IsValidDynamicObject(E_GRAFFITY[g_id][gObject]))
    {
        E_GRAFFITY[g_id][gObject] = CreateDynamicObject(GRAFFITY_OBJECT_ID, E_GRAFFITY[g_id][gPosX], E_GRAFFITY[g_id][gPosY], E_GRAFFITY[g_id][gPosZ], E_GRAFFITY[g_id][gRotX], E_GRAFFITY[g_id][gRotY], E_GRAFFITY[g_id][gRotZ]);
        SetDynamicObjectMaterial(E_GRAFFITY[g_id][gObject], 0, 0, "none", "none", 0);
        SetDynamicObjectMaterialText(E_GRAFFITY[g_id][gObject], 0, E_GRAFFITY[g_id][gText], OBJECT_MATERIAL_SIZE_256x32, E_GRAFFITY[g_id][gFont], E_GRAFFITY[g_id][gFontSize], E_GRAFFITY[g_id][gBold], E_GRAFFITY[g_id][gColor], E_GRAFFITY[g_id][gBackColor], 0);
    }

    if (GetPVarInt(playerid, "Tester:Graffity"))     DeletePVar(playerid, "Tester:Graffity");
    if (GetPVarInt(playerid, "Tester:GraffityTime")) DeletePVar(playerid, "Tester:GraffityTime");
    SendSyntaxMessage(playerid, "You approved graffiti [ID: %i].", g_id);
    Graffity_Refresh(g_id);
    return 1;
}

Graffity_Decline(g_id, playerid)
{
    if (!E_GRAFFITY[g_id][gON])  return -1;
    if (E_GRAFFITY[g_id][gAccepted]) return -2;

    Graffity_ResetVariables(g_id);

    new query[128];
    mysql_format(dbHandle, query, sizeof(query), "DELETE FROM `graffities` WHERE `id` = %i", g_id);
    mysql_tquery(dbHandle, query);

    SendSyntaxMessage(playerid, "Ban da tu choi graffiti [ID: %i].", g_id);
    return 1;
}

Graffity_GetAccepts(playerid)
{
    new acceptid = -1;

    for(new i = 0; i < MAX_GRAFFITIES; i++)
    {
        if (E_GRAFFITY[i][gON])
        {
            if (CompareStrings(E_GRAFFITY[i][gCreator], GetNameEx(playerid)))
            {
                if (!E_GRAFFITY[i][gAccepted]) return acceptid;
            }
        }
    }
    return acceptid;
}

Graffity_GetPlayerEdit(playerid)
{
    if (!GetPVarInt(playerid, "Graffity:Edit")) return -1;
    return GetPVarInt(playerid, "Graffity:ID") - 1;
}

Graffity_GetColor(playerid)
{
    if (!GetPVarInt(playerid, "Graffity:Edit")) return -1;
    return GetPVarInt(playerid, "Graffity:Color") - 1;
}

Graffity_GetBackColor(playerid)
{
    if (!GetPVarInt(playerid, "Graffity:Edit")) return -1;
    return GetPVarInt(playerid, "Graffity:Back") - 1;
}

Graffity_GetFont(playerid)
{
    if (!GetPVarInt(playerid, "Graffity:Edit")) return -1;
    return GetPVarInt(playerid, "Graffity:Font")-1;
}

Graffity_CreateTemporary(playerid, g_text[])
{
    new g_id = Graffity_GetFreeID(), Float:gx, Float:gy, Float:gz, Float:x, Float:y, Float:z;

    GetXYInFrontOfPlayer(playerid, gx, gy, gz, 1.0);
    GetPlayerPos(playerid, x, y, z);

    
    E_GRAFFITY[g_id][gID] = g_id;
    format(E_GRAFFITY[g_id][gText], 32, "%s", g_text);
    E_GRAFFITY[g_id][gColor] = GRAFFITY_COLOR[0][color_data];
    E_GRAFFITY[g_id][gBackColor] = GRAFFITY_BACK[0][color_data];
    format(E_GRAFFITY[g_id][gFont], 16, "%s", GRAFFITY_FONT[0][font_name]);
    E_GRAFFITY[g_id][gFontSize] = 16;
    E_GRAFFITY[g_id][gBold] = 0;
    format(E_GRAFFITY[g_id][gCreator], 32, "%s", GetNameEx(playerid));
    format(E_GRAFFITY[g_id][gCreateDate], 64, "%s", GetFullDate());
    E_GRAFFITY[g_id][gPosX] = gx;
    E_GRAFFITY[g_id][gPosY] = gy;
    E_GRAFFITY[g_id][gPosZ] = gz;
    E_GRAFFITY[g_id][gRotX] = 0.0;
    E_GRAFFITY[g_id][gRotY] = 0.0;
    E_GRAFFITY[g_id][gRotZ] = 90.0;
    E_GRAFFITY[g_id][gGotoX] = x;
    E_GRAFFITY[g_id][gGotoY] = y;
    E_GRAFFITY[g_id][gGotoZ] = z;
    E_GRAFFITY[g_id][gInterior] = GetInterior(playerid);
    E_GRAFFITY[g_id][gVW] = GetWorld(playerid);
    E_GRAFFITY[g_id][gAccepted] = 0;
    E_GRAFFITY[g_id][gAcceptor] = EOS;
    E_GRAFFITY[g_id][gAcceptDate] = EOS;
    E_GRAFFITY[g_id][gON] = 1;
    E_GRAFFITY[g_id][gEditing] = 1;

    SetPVarInt(playerid, "Graffity:Edit", 1);
    SetPVarInt(playerid, "Graffity:ID", g_id + 1);
    SetPVarInt(playerid, "Graffity:Color", 1);
    SetPVarInt(playerid, "Graffity:Back", 1);
    SetPVarInt(playerid, "Graffity:Font", 1);

    Graffity_ShowPlayerEditDialog(playerid);

    E_GRAFFITY[g_id][gObject] = CreateDynamicObject(GRAFFITY_OBJECT_ID, gx, gy, gz, 0.0, 0.0, 90.0, GetWorld(playerid), GetInterior(playerid));
    SetDynamicObjectMaterial(E_GRAFFITY[g_id][gObject], 0, 0, "none", "none", 0);
    SetDynamicObjectMaterialText(E_GRAFFITY[g_id][gObject], 0, g_text, OBJECT_MATERIAL_SIZE_256x32, GRAFFITY_FONT[0][font_name], 16, 0, GRAFFITY_COLOR[0][color_data], GRAFFITY_BACK[0][color_data], 0);

}

Graffity_ShowPlayerEditDialog(playerid)
{
    new msg[1024] = "{FFFFFF}Thong so\t{FFFFFF}Gia tri\n", catmsg[128], bold_state[16], title[32];

    new gcol = Graffity_GetColor(playerid), gback = Graffity_GetBackColor(playerid), gfont = Graffity_GetFont(playerid), g_id = Graffity_GetPlayerEdit(playerid);

    strcat(msg, "Xem truoc\n");
    strcat(msg, "Hoan tat chinh sua\n");
    strcat(msg, "Thay doi vi tri cua graffiti\n");
    strcat(msg, "Thay doi van ban graffiti\n");
    strcat(msg, "   \n");
    format(catmsg, sizeof(catmsg), "Mua sac Graffiti\t%s%s\n", GRAFFITY_COLOR[gcol][color_dlg], GRAFFITY_COLOR[gcol][color_name]);
    strcat(msg, catmsg);
    format(catmsg, sizeof(catmsg), "{FFFFFF}Anh nen\t%s%s\n", GRAFFITY_BACK[gback][color_dlg], GRAFFITY_BACK[gback][color_name]);
    strcat(msg, catmsg);
    format(catmsg, sizeof(catmsg), "{FFFFFF}Phong chu\t%s\n", GRAFFITY_FONT[gfont][font_name]);
    strcat(msg, catmsg);
    format(catmsg, sizeof(catmsg), "Kich co phong\t%i\n", E_GRAFFITY[g_id][gFontSize]);
    strcat(msg, catmsg);
    
    if (E_GRAFFITY[g_id][gBold]) format(bold_state, sizeof(bold_state), "%s", RIGHT_YES);
    else                        format(bold_state, sizeof(bold_state), "%s", RIGHT_NO);

    format(catmsg, sizeof(catmsg), "Danh dau in dam\t%s", bold_state);
    strcat(msg, catmsg);

    format(title, sizeof(title), "{FFFFFF}Graffiti [ID: %i]", Graffity_GetPlayerEdit(playerid));
    Dialog_Show(playerid, Graffity_CE, DIALOG_STYLE_TABLIST_HEADERS, title, msg, "Chon", "Thoat");
    return 1;
}

Graffity_DestroyTemporary(g_id, clear_var = 0)
{
    if (!E_GRAFFITY[g_id][gON]) return -1;

    if (IsValidDynamicObject(E_GRAFFITY[g_id][gObject]))     DestroyDynamicObject(E_GRAFFITY[g_id][gObject]);

    if (clear_var) Graffity_ResetVariables(g_id);

    return 1;
}

Graffity_Destroy(g_id)
{
    if (!E_GRAFFITY[g_id][gON])          return -1;

    if (IsValidDynamicObject(E_GRAFFITY[g_id][gObject]))     DestroyDynamicObject(E_GRAFFITY[g_id][gObject]);
    Graffity_ResetVariables(g_id);

    new query[128];
    mysql_format(dbHandle, query, sizeof(query), "DELETE FROM `graffities` WHERE `id` = %i", g_id);
    mysql_tquery(dbHandle, query);
    return 1;
}

Graffity_Insert(g_id)
{
    new query[1024];
    mysql_format(dbHandle, query, sizeof(query), "INSERT INTO `graffities` (`id`, `text`, `color`, `back_color`, `font`, `font_size`, `bold`, `creator`, `c_date`, `posx`, `posy`, `posz`, `rotx`, `roty`, `rotz`, `gotox`, `gotoy`, `gotoz`, `interior`, `world`, `accepted`, `acceptor`, `a_date`) VALUES (%i, '%s', %d, %d, '%s', %i, %i, '%s', '%s', %f, %f, %f, %f, %f, %f, %f, %f, %f, %i, %i, 0, '', '')",
    g_id, E_GRAFFITY[g_id][gText], E_GRAFFITY[g_id][gColor], E_GRAFFITY[g_id][gBackColor], E_GRAFFITY[g_id][gFont], E_GRAFFITY[g_id][gFontSize], E_GRAFFITY[g_id][gBold], E_GRAFFITY[g_id][gCreator], E_GRAFFITY[g_id][gCreateDate], E_GRAFFITY[g_id][gPosX], E_GRAFFITY[g_id][gPosY], E_GRAFFITY[g_id][gPosZ],
    E_GRAFFITY[g_id][gRotX], E_GRAFFITY[g_id][gRotY], E_GRAFFITY[g_id][gRotZ], E_GRAFFITY[g_id][gGotoX], E_GRAFFITY[g_id][gGotoY], E_GRAFFITY[g_id][gGotoZ], E_GRAFFITY[g_id][gInterior], E_GRAFFITY[g_id][gVW]);
    mysql_tquery(dbHandle, query);
    return 1;
}

Graffity_ResetPlayer(playerid)
{
    DeletePVar(playerid, "Graffity:Edit");
    DeletePVar(playerid, "Graffity:ID");
    DeletePVar(playerid, "Graffity:Color");
    DeletePVar(playerid, "Graffity:Back");
    DeletePVar(playerid, "Graffity:Font");
    DeletePVar(playerid, "Graffity:Show");
    DeletePVar(playerid, "Graffity:Showing");
    DeletePVar(playerid, "Graffity:BackState");
    DeletePVar(playerid, "Graffity:BackTime");
    DeletePVar(playerid, "Graffity:EditPos");
    DeletePVar(playerid, "Graffity:Spraying");
    DeletePVar(playerid, "Graffity:SprayingTime");
    return 1;
}

Graffity_GetAcceptList(playerid)
{
    new msg[1024] = "{FFFFFF}ID graffiti\t{FFFFFF}Nguoi tao\t{FFFFFF}thoi gian tao\n";

    new count = 0;

    for(new i = 0; i < MAX_GRAFFITIES; i++)
    {
        if (count == 10) break;
        if (!E_GRAFFITY[i][gAccepted] && E_GRAFFITY[i][gON] && !E_GRAFFITY[i][gEditing])
        {
            format(msg, sizeof(msg), "%s%i\t%s\t%s\n", msg, i, E_GRAFFITY[i][gCreator], E_GRAFFITY[i][gCreateDate]);
            count++;
        }
    }
    if (count > 0)
    {
        Dialog_Show(playerid, GraffityList, DIALOG_STYLE_TABLIST_HEADERS, "{FFFFFF}Graffiti dang cho xu ly", msg, "Dong", "");
    }
    else
    {
        SendSyntaxMessage(playerid, "Hien tai khong co hinh ve graffiti nao de xem xet.");
    }
    return 1;
}

Graffity_Refresh(id)
{
	if (id != -1 && E_GRAFFITY[id][gON])
	{

		if(IsValidDynamicObject(E_GRAFFITY[id][gObject]))
		{
			DestroyDynamicObject(E_GRAFFITY[id][gObject]);
		}

        //GraffitiData[id][graffitiIcon] = CreateDynamicMapIcon(GraffitiData[id][graffitiPos][0], GraffitiData[id][graffitiPos][1], GraffitiData[id][graffitiPos][2], 23, 0, -1, -1, -1, 100.0, MAPICON_GLOBAL);
		E_GRAFFITY[id][gObject] = CreateDynamicObject(GRAFFITY_OBJECT_ID, E_GRAFFITY[id][gPosX], E_GRAFFITY[id][gPosY], E_GRAFFITY[id][gPosZ], 0.0, 0.0, E_GRAFFITY[id][gRotZ], E_GRAFFITY[id][gVW], E_GRAFFITY[id][gInterior]);

		SetDynamicObjectMaterial(E_GRAFFITY[id][gObject], 0, 0, "none", "none", 0);
        SetDynamicObjectMaterialText(E_GRAFFITY[id][gObject], 0, E_GRAFFITY[id][gText], OBJECT_MATERIAL_SIZE_256x32, E_GRAFFITY[id][gFont], E_GRAFFITY[id][gFontSize], E_GRAFFITY[id][gBold], E_GRAFFITY[id][gColor], E_GRAFFITY[id][gBackColor], 0);
	}
	return 1;
}