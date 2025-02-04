/********************************************************
 *                                                      *
 *   @Author:                   21st Century        *
 *   @Year started:             2020                    *
 *   @Main scripter:            Arashi                  *
 *   @Supporte scripter :       duydang.                *
 *                              Ares                    *
 *                              zOn                     *
 *                              livjavier26             *
 *                              SAMP Community [VN]     *
 *   @Mapper:                   Nekko                   *
 *   @Other:                    update                  *
 *                                                      *
 *********************************************************/
#include <YSI\y_hooks>
#define MAX_SPRAY_TAG 100

enum E_SPRAY_TAG
{
    Float:spPosX,
    Float:spPosY,
    Float:spPosZ,
    Float:spRotRX,
    Float:spRotRY,
    Float:spRotRZ,
    spVW,
    spInt,
    spObject,
    spCreator[MAX_PLAYER_NAME+1],
    spContent[64]
};
new InfoSpraytag[MAX_SPRAY_TAG][E_SPRAY_TAG],
    Iterator:Spraytag<MAX_SPRAY_TAG>,
    TimerSpraying[MAX_PLAYERS];

resetSpraytag(spid)
{
    InfoSpraytag[spid][spPosX] = InfoSpraytag[spid][spPosY] = InfoSpraytag[spid][spPosZ] = 
    InfoSpraytag[spid][spRotRX] = InfoSpraytag[spid][spRotRY] = InfoSpraytag[spid][spRotRZ] = 0.0;
    InfoSpraytag[spid][spVW] = InfoSpraytag[spid][spInt] = 0;
    InfoSpraytag[spid][spContent] = InfoSpraytag[spid][spCreator] = EOS;   
    return true;
}
// 
forward OnSpraytagRetrieved();
public OnSpraytagRetrieved()
{
    new 
        row = cache_num_rows();
    if (row > 0)
    {   
        new
            szResult[129], 
            spid,
            font[64],
            font_size;
        for(new i = 0; i < row; i++)
        {
            cache_get_field_content(row,  "id", szResult, MainPipeline); spid = strval(szResult);
            cache_get_field_content(row,  "spPosX", szResult, MainPipeline); InfoSpraytag[spid][spPosX] = floatstr(szResult);
            cache_get_field_content(row,  "spPosY", szResult, MainPipeline); InfoSpraytag[spid][spPosY] = floatstr(szResult);
            cache_get_field_content(row,  "spPosZ", szResult, MainPipeline); InfoSpraytag[spid][spPosZ] = floatstr(szResult);
            
            cache_get_field_content(row,  "spRotRX", szResult, MainPipeline); InfoSpraytag[spid][spRotRX] = floatstr(szResult);
            cache_get_field_content(row,  "spRotRY", szResult, MainPipeline); InfoSpraytag[spid][spRotRY] = floatstr(szResult);
            cache_get_field_content(row,  "spRotRZ", szResult, MainPipeline); InfoSpraytag[spid][spRotRZ] = floatstr(szResult);
           
            cache_get_field_content(row,  "spVW", szResult, MainPipeline); InfoSpraytag[spid][spVW] = strval(szResult);
            cache_get_field_content(row,  "spInt", szResult, MainPipeline); InfoSpraytag[spid][spInt] = strval(szResult);

            cache_get_field_content(row,  "spFont", font, MainPipeline);
            cache_get_field_content(row,  "spFontSize", szResult, MainPipeline); font_size = strval(szResult);


            cache_get_field_content(row,  "spCreator", InfoSpraytag[spid][spCreator], MainPipeline);
            cache_get_field_content(row,  "spContent", InfoSpraytag[spid][spContent], MainPipeline);


            if (strlen(InfoSpraytag[spid][spContent]))
            {   
                print("Worked zzz");
                InfoSpraytag[spid][spObject] =  CreateDynamicObject(19482, InfoSpraytag[spid][spPosX], InfoSpraytag[spid][spPosY], InfoSpraytag[spid][spPosZ], InfoSpraytag[spid][spRotRX], InfoSpraytag[spid][spRotRY], InfoSpraytag[spid][spRotRZ], InfoSpraytag[spid][spVW], InfoSpraytag[spid][spInt]);

                SetDynamicObjectMaterialText(InfoSpraytag[spid][spObject], 0, InfoSpraytag[spid][spContent], OBJECT_MATERIAL_SIZE_512x256, font, font_size, 1, 0xFFFFFFFF, 0, 1);
            }
            else 
            {
                InfoSpraytag[spid][spObject] = CreateDynamicObject(18664, InfoSpraytag[spid][spPosX], InfoSpraytag[spid][spPosY], InfoSpraytag[spid][spPosZ], InfoSpraytag[spid][spRotRX], InfoSpraytag[spid][spRotRY], InfoSpraytag[spid][spRotRZ], InfoSpraytag[spid][spVW], InfoSpraytag[spid][spInt]);
            }
            Iter_Add(Spraytag, spid);
        }
        printf("Loaded %d spraytag. (%dmcs)", Iter_Count(Spraytag));
    }
    return true;
}

forward UpdateSpraytag(playerid, spid);
public UpdateSpraytag(playerid, spid)
{
    new content[64],
    step = GetPVarInt(playerid, "Spraytag:Step");
    GetPVarString(playerid, "Spraytag:Content", content);
    if (!IsPlayerInRangeOfPoint(playerid, 3.0, InfoSpraytag[spid][spPosX], InfoSpraytag[spid][spPosY], InfoSpraytag[spid][spPosZ]))
    {
        SendErrorMessage(playerid, "Ban khong o gan vi tri diem son, vi the da huy qua trinh son.");
        DeletePVar(playerid, "Spraytag:Step");
        DeletePVar(playerid, "Spraytag:Content");
        DeletePVar(playerid, "Spraytag:Font");
        DeletePVar(playerid, "Spraytag:Bold");
        KillTimer(TimerSpraying[playerid]);
        TimerSpraying[playerid] = -1;
        return true;
    }
    
    if (!strlen(content))
    {
        SendErrorMessage(playerid, "Ban chua co noi dung de thay doi.");
        DeletePVar(playerid, "Spraytag:Step");
        DeletePVar(playerid, "Spraytag:Content");
        DeletePVar(playerid, "Spraytag:Font");
        DeletePVar(playerid, "Spraytag:Bold");
        KillTimer(TimerSpraying[playerid]);
        TimerSpraying[playerid] = -1;
        return true;
    }

    step++;
    SetPVarInt(playerid, "Spraytag:Step", step);

    ShowNotifyTextMain(playerid,"Don son tuong vui long doi...");

    if (step >= 15)
    {
        new font = GetPVarInt(playerid, "Spraytag:Font"),
            bold = GetPVarInt(playerid, "Spraytag:Bold"),
            font_text[64],
            font_size;

        switch(font)
        {
            case 0: font_text = "Comic Sans ms", font_size = 28;
            case 1: font_text = "Diploma", font_size = 30;
            case 2: font_text = "Arial", font_size = 32;
            case 3: font_text = "Levibrush", font_size = 32;
            case 4: font_text = "Street Soul", font_size = 40;
            case 5: font_text = "a dripping marker", font_size = 35;
        }

        alm(InfoSpraytag[spid][spContent], content);
        strreplace(content, "(n)", "\n");
		strreplace(content, "(b)", "{003cff}"); //Blue
        strreplace(content, "(w)", "{ffffff}"); //White
        strreplace(content, "(y)", "{ffbf00}"); //Yellow
        strreplace(content, "(g)", "{30911f}"); //Green
        strreplace(content, "(bl)", "{000000}"); //Black
        strreplace(content, "(or)", "{fa8900}"); //Orange
        strreplace(content, "(r)", "{ff0000}"); //Red
        strreplace(content, "(lb)", "{00c8ff}"); //Light blue
        strreplace(content, "(p)", "{aa00ff}"); //Purple
        strreplace(content, "(pi)", "{ff0084}"); //Pink
        strreplace(content, "(br)", "{694f3a}"); //Brown
        strreplace(content, "(gr)", "{b0b0b0}"); //Grey


        DestroyDynamicObject(InfoSpraytag[spid][spObject]);

        new query[512];
        mysql_format(MainPipeline, query, sizeof(query), "UPDATE `spraytag` SET `spFont` = '%e' WHERE `id` = %d LIMIT 1", font_text, spid);
        mysql_tquery(MainPipeline, query, "FinishSCP", "d", spid);

        mysql_format(MainPipeline, query, sizeof(query), "UPDATE `spraytag` SET `spFontSize` = '%f' WHERE `id` = %d LIMIT 1", font_size, spid);
        mysql_tquery(MainPipeline, query, "FinishSCP", "d", spid);

        mysql_format(MainPipeline, query, sizeof(query), "UPDATE `spraytag` SET `spContent` = '%e' WHERE `id` = %d LIMIT 1", content, spid);
        mysql_tquery(MainPipeline, query, "FinishSCP", "d", spid);


        InfoSpraytag[spid][spObject] =  CreateDynamicObject(19482, InfoSpraytag[spid][spPosX], InfoSpraytag[spid][spPosY], InfoSpraytag[spid][spPosZ], InfoSpraytag[spid][spRotRX], InfoSpraytag[spid][spRotRY], InfoSpraytag[spid][spRotRZ], InfoSpraytag[spid][spVW], InfoSpraytag[spid][spInt]);

        SetDynamicObjectMaterialText(InfoSpraytag[spid][spObject], 0, content, OBJECT_MATERIAL_SIZE_512x256, font_text, font_size, bold, 0xFFFFFFFF, 0, 1);

        KillTimer(TimerSpraying[playerid]);
        TimerSpraying[playerid] = -1;

        DeletePVar(playerid, "Spraytag:Step");
        DeletePVar(playerid, "Spraytag:Content");
        DeletePVar(playerid, "Spraytag:Font");
        DeletePVar(playerid, "Spraytag:Bold");
    }
    return true;
}

stock Pray_OnPlayerEditDynObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
    if(GetPVarInt(playerid,#EditSpraytag)) {
        if (response == EDIT_RESPONSE_FINAL)
        {
            foreach(new spid: Spraytag)
            {
                if (InfoSpraytag[spid][spObject] == objectid)
                {
                    InfoSpraytag[spid][spPosX] = x;
                    InfoSpraytag[spid][spPosY] = y;
                    InfoSpraytag[spid][spPosZ] = z;
                    InfoSpraytag[spid][spRotRX] = rx;
                    InfoSpraytag[spid][spRotRY] = ry;
                    InfoSpraytag[spid][spRotRZ] = rz;
                    InfoSpraytag[spid][spVW] = GetPlayerVirtualWorld(playerid);
                    InfoSpraytag[spid][spInt] = GetPlayerInterior(playerid);
                    alm(InfoSpraytag[spid][spCreator], GetPlayerNameEx(playerid));

                    new query[256];
                    mysql_format(MainPipeline, query, sizeof(query), "UPDATE `spraytag` SET `spPosX` = %.5f, `spPosY` = %.5f, `spPosZ` = %.5f, `spRotRX` = %.5f, `spRotRY` = %.5f, `spRotRZ` = %.5f,\
                    `spVW` = %d, `spInt` = %d, `spCreator` = '%e' WHERE `id` = %d LIMIT 1",
                    x, y, z, rx, ry, rz, InfoSpraytag[spid][spVW], InfoSpraytag[spid][spInt], InfoSpraytag[spid][spCreator], spid);
                    // mysql_tquery(MainPipeline, query, "FinishSCP", "d", spid);
                    mysql_tquery(MainPipeline, query, "FinishSCP", "d", spid);

                    SetDynamicObjectPos(objectid, x, y, z);
                    SetDynamicObjectRot(objectid, rx, ry, rz);
                    SendServerMessage(playerid, "* Ban da tao diem spray-tag moi.");
                    DeletePVar(playerid,#EditSpraytag);
                    RemovePlayerWeapon(playerid, 41);
                    return true;
                }
            }
        }
        else if (response == EDIT_RESPONSE_CANCEL)
        {
            foreach(new spid: Spraytag)
            {
                if (InfoSpraytag[spid][spObject] == objectid)
                {
                    DestroyDynamicObject(InfoSpraytag[spid][spObject]);

                    new query[128];
                    mysql_format(MainPipeline, query, sizeof(query), "DELETE FROM `spraytag` WHERE `id` = %d LIMIT 1", spid);
                    // mysql_tquery(MainPipeline, query, "FinishSCP", "d", spid);
                    mysql_tquery(MainPipeline, query, "FinishSCP", "d", spid);

                    Iter_Remove(Spraytag, spid);
                    SendServerMessage(playerid, "* Ban da huy bo tao diem spray-tag moi.");
                    DeletePVar(playerid,#EditSpraytag);
                    return true;
                }   
            }
        }
    }
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if (PRESSED(KEY_FIRE) && GetPlayerWeapon(playerid) == WEAPON_SPRAYCAN && GetPVarInt(playerid, "Spraytag:Spraying"))
    {
        new spid = GetPVarInt(playerid, "Spraytag:ID");
        if (IsPlayerInRangeOfPoint(playerid, 3.0, InfoSpraytag[spid][spPosX], InfoSpraytag[spid][spPosY], InfoSpraytag[spid][spPosZ]))
            TimerSpraying[playerid] = SetTimerEx("UpdateSpraytag", 1000, true, "ii", playerid, spid);
    }
    else if (RELEASED(KEY_FIRE) && GetPlayerWeapon(playerid) == WEAPON_SPRAYCAN && GetPVarInt(playerid, "Spraytag:Spraying"))
    {
        KillTimer(TimerSpraying[playerid]);
        TimerSpraying[playerid] = -1;
    }
    return true;
}

CMD:spray(playerid, params[])
{
    if (PlayerInfo[playerid][pFMember] == INVALID_FAMILY_ID || PlayerInfo[playerid][pRank] < 5)
    {
        SendErrorMessage(playerid, "Ban khong phai Leader cua mot Gangs.");
        return 1;
    }
    if(Inventory_@CheckSlot(playerid,19) == -1 ) return SendErrorMessage(playerid,"Ban phai co 1 binh son moi co the su dung lenh nay.");
    new choice[32];
    if(sscanf(params, "s[32]", choice))
    {
        SendClientMessageEx(playerid, COLOR_CHAT, " /spray [tuy chon]");
        SendClientMessageEx(playerid, COLOR_WHITE, "{c7d5d8}OPTION{ffffff}: tao | danhsach | thietlap");
        return 1;
    }
    if(strcmp(choice,"tao",true) == 0) {
        cmd_createspraytag(playerid,"");
    }
    if(strcmp(choice,"danhsach",true) == 0) {
        cmd_spraytags(playerid,"");
    }
    if(strcmp(choice,"thietlap",true) == 0) {
        cmd_graffiti(playerid,"");
    }
    return 1;
}
CMD:createspraytag(playerid,params[])
{  
    if (PlayerInfo[playerid][pFMember] == INVALID_FAMILY_ID || PlayerInfo[playerid][pRank] < 5)
    {
        SendErrorMessage(playerid, "Ban khong phai Leader cua mot Gangs.");
        return 1;
    }

    // if (character[playerid][member] == INVALID_FACTION_ID)
    //     return SendErrorMessage(playerid, "Ban khong co quyen han de su dung lenh nay.");

    // new factionid = character[playerid][member];
    // if (!Faction[factionid][fType])
    //     return SendErrorMessage(playerid, "To chuc cua ban khong co quyen han de su dung lenh nay.");

    // if (character[playerid][rank] < Faction[factionid][totalRanks]-1)
    //     return SendErrorMessage(playerid, "Cap bac cua ban trong to chuc khong du quyen han de su dung lenh nay.");

    new count = 0;
    for(new spid = 0; spid < MAX_SPRAY_TAG; spid++)
    {
        if (!InfoSpraytag[spid][spPosX])
        {
            new Float:X, Float:Y, Float:Z, Float:RZ;
            GetPlayerPos(playerid, X, Y, Z);
            GetPlayerFacingAngle(playerid, RZ);
            InfoSpraytag[spid][spObject] = CreateDynamicObject(18664, X, Y, Z, 0.0, 0.0, RZ, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));

            new query[64];
            mysql_format(MainPipeline, query, sizeof(query), "INSERT INTO `spraytag` (`id`) VALUES (%d)", spid);
            mysql_tquery(MainPipeline, query, "FinishSCP", "d", spid);
            
            Iter_Add(Spraytag, spid);
            EditDynamicObject(playerid,  InfoSpraytag[spid][spObject]);
            SetPVarInt(playerid,#EditSpraytag,1);
            count = 1;
            break;
        }
    }
    if (!count) return SendErrorMessage(playerid, "Dat gioi han spraytag, khong the tao them.");
    return true;
}

CMD:spraytags(playerid,params[])
{

    new str[2048] = "#\tNguoi tao";
    foreach(new spid: Spraytag)
    {
        if (InfoSpraytag[spid][spPosX])
            format(str, sizeof(str), "%s\n%d\t%s", str, spid, InfoSpraytag[spid][spCreator]);
    }
    Dialog_Show(playerid, dialogListSpraytag, DIALOG_STYLE_TABLIST_HEADERS, "Spraytag", str, "Chinh sua", "Dong");
    return true;
}

Dialog:dialogListSpraytag(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        Dialog_Show(playerid, dialogEditSpraytag, DIALOG_STYLE_LIST, "Spraytag", "Dich chuyen den\nThay doi vi tri\n{a33333}Xoa", "Lua chon", "Huy bo");
        SetPVarInt(playerid, "Spraytag:EditID", strval(inputtext));
    }
    return true;
}

Dialog:dialogEditSpraytag(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        new spid = GetPVarInt(playerid, "Spraytag:EditID");
        switch(listitem)
        {
            case 0:
            {
                if(PlayerInfo[playerid][pAdmin] < 2) return SendErrorMessage(playerid," Da co loi xay ra.");
                SetPlayerPos(playerid, InfoSpraytag[spid][spPosX], InfoSpraytag[spid][spPosY]+2, InfoSpraytag[spid][spPosZ]);
                SetPlayerVirtualWorld(playerid, InfoSpraytag[spid][spVW]);
                SetPlayerInterior(playerid, InfoSpraytag[spid][spInt]);
                SendServerMessage(playerid, "Da dich chuyen den vi tri.");
                return true;
            }
            case 1:
            {
                if (!IsPlayerInRangeOfPoint(playerid, 3.0, InfoSpraytag[spid][spPosX], InfoSpraytag[spid][spPosY], InfoSpraytag[spid][spPosZ])) return SendErrorMessage(playerid, "Ban khong o gan vi tri spray-tag.");

                EditDynamicObject(playerid, InfoSpraytag[spid][spObject]);
                SetPVarInt(playerid,#EditSpraytag,1); ///SỬ DỤNG LẠI BIẾN CREATE
            }
            case 2:
            {
                resetSpraytag(spid);
                Iter_Remove(Spraytag, spid);

                new query[128];
                mysql_format(MainPipeline, query, sizeof(query), "DELETE FROM `spraytag` WHERE `id` = %d LIMIT 1", spid);
                mysql_tquery(MainPipeline, query, "FinishSCP", "d", spid);

                SendErrorMessage(playerid, "Da xoa spray-tag.");
            }
        }
    }
    return true;
}

CMD:graffiti(playerid,params[])
{
    if (PlayerInfo[playerid][pFMember] == INVALID_FAMILY_ID || PlayerInfo[playerid][pRank] < 5)
    {
        SendErrorMessage(playerid, "Ban khong phai Leader cua mot Gangs.");
        return 1;
    }
    new spid = IsPlayerRangeSpraytag(3.0, playerid);
    if (spid == -1) return true;
    // if (character[playerid][right_hand] != 71 && character[playerid][right_hand] != 36) return SendErrorMessage(playerid, "Ban khong co binh xit."); 

    Dialog_Show(playerid, dialogSprayingtag, DIALOG_STYLE_LIST, "Spraytag", "Noi dung\nPhong chu\nVien ngoai", "Lua chon", "Dong");
    return true;
}
forward IsPlayerRangeSpraytag(Float:range, playerid);
public IsPlayerRangeSpraytag(Float:range, playerid)
{
    foreach(new spid: Spraytag)
    {
        if (IsPlayerInRangeOfPoint(playerid, range, InfoSpraytag[spid][spPosX], InfoSpraytag[spid][spPosY], InfoSpraytag[spid][spPosZ])) return spid;
    }
    return -1;
}
Dialog:dialogSprayingtag(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        switch(listitem)
        {
            case 0:
            {
                new DialogStatus[1024];
                strcat(DialogStatus, "{ffffff}(n) de tao dong moi.\n");
                strcat(DialogStatus, "{003cff}(b){ffffff}: xanh nuoc, {ffffff}(w){ffffff}: trang, {ffbf00}(y){ffffff}: vang, {30911f}(g){ffffff}: xanh la\n");
                strcat(DialogStatus, "{282a2e}(bl){ffffff}: den, {fa8900}(or){ffffff}: cam, {ff0000}(r){ffffff}: do, {00c8ff}(lb){ffffff}: xanh nuoc nhat\n");
                strcat(DialogStatus, "{aa00ff}(p){ffffff}: tim, {ff0084}(pi){ffffff}: hong, {694f3a}(br){ffffff}: nau, {b0b0b0}(gr){ffffff}: xam\n");
                strcat(DialogStatus, "Vi du: (g){469c3e}Xanh la {ffffff}(r){ff0000}Do\n\n");
                strcat(DialogStatus, "{ffffff}* Hay co gang rut gon ngan van ban nhat. (Toi da 64 ki tu)\n");
                Dialog_Show(playerid, dialogSpraytagContent, DIALOG_STYLE_INPUT, "{D6E1EB}Graffiti", DialogStatus, "Tiep tuc", "Quay lai");
            }
            case 1:
            {   
                Dialog_Show(playerid, dialogSpraytagFont, DIALOG_STYLE_LIST, "Spraytag", "Comic Sans\nDiploma\nArial\nLevi Brush\nStreet Soul\nDripping", "Lua chon", "Quay lai");
            }
            case 2:
            {
                SetPVarInt(playerid, "Spraytag:Bold", (!GetPVarInt(playerid, "Spraytag:Bold")) ? 1 : 0);
                new status = GetPVarInt(playerid, "Spraytag:Bold");
                new str[256];
                format(str, sizeof str, "Noi dung\nPhong chu\nVien ngoai (%s)", (status) ? "Co" : "Khong");
                Dialog_Show(playerid, dialogSprayingtag, DIALOG_STYLE_LIST, "Spraytag", str, "Lua chon", "Dong");
            }
        }
    }
    return true;
}

Dialog:dialogSpraytagContent(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        if (strlen(inputtext) < 0 || strlen(inputtext) > 80) 
        {
            new DialogStatus[500];
            strcat(DialogStatus, "(n) de tao dong moi.\n");
            strcat(DialogStatus, "(b): xanh nuoc, (w): trang, (y): vang, (g): xanh la\n");
            strcat(DialogStatus, "(b): den, (or): cam, (r): do, (lb): xanh nuoc nhat\n");
            strcat(DialogStatus, "(p): tim, (pi): hong, (br): nau, (gr): xam\n");
            strcat(DialogStatus, "Vi du: (g){469c3e}Xanh la {ffffff}(r){ff0000}Do\n");
            strcat(DialogStatus, "Hay co gang rut gon ngan van ban nhat. (Toi da 64 ki tu)\n");
            Dialog_Show(playerid, dialogSpraytagContent, DIALOG_STYLE_INPUT, "{D6E1EB}Graffiti", DialogStatus, "Tiep tuc", "Quay lai");
            SendErrorMessage(playerid, "Do dai khong hop le.");
        }

        SetPVarString(playerid, "Spraytag:Content", inputtext);
        SetPVarInt(playerid, "Spraytag:Spraying", 1);
        GivePlayerValidWeapon(playerid, 41, 60000);
        Inventory_@FineItem(playerid, 19, 1);
        SetPVarInt(playerid, "Spraytag:Step", 0);
        SetPVarInt(playerid, "Spraytag:ID", IsPlayerRangeSpraytag(3.0, playerid));
        Dialog_Show(playerid, dialogSprayingtag, DIALOG_STYLE_LIST, "Spraytag", "Noi dung\nPhong chu\nVien ngoai", "Lua chon", "Dong");
    }
    return true;
}

Dialog:dialogSpraytagFont(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        SetPVarInt(playerid, "Spraytag:Font", listitem);
        Dialog_Show(playerid, dialogSprayingtag, DIALOG_STYLE_LIST, "Spraytag", "Noi dung\nPhong chu\nVien ngoai", "Lua chon", "Dong");
    }
    return true;
}
stock alm( string[],  string2[])
{
    strmid(string, string2, 0, strlen(string2), strlen(string2) + 1);

    return true;
}
