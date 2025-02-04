#define                     INVALID_CCTV_ID                  (-1)
#define                     MAX_CCTV_FACTION                 (20)
#define                     MAX_CCTV_TABLE_FACTION           (10)

#define                     MAX_SPEED_Rotation               (0.05)

enum E_CCTV_FACTION
{
    Float:ccTVPosX,
    Float:ccTVPosY,
    Float:ccTVPosZ,
    Float:ccTVRotationX,
    Float:ccTVRotationY,
    Float:ccTVRotationZ,
    ccTV_VW,
    ccTVInt,

    objectIndex,
    playerIDEdit = INVALID_PLAYER_ID,
    playerIDWatch = INVALID_PLAYER_ID,

    ccTV_fCode[10]
}

enum E_CCTV_TABLE_FACTION
{
    tableIndex,
    PlayerEdit_CCTVTable,
    Float:ccTVTablePosX,
    Float:ccTVTablePosY,
    Float:ccTVTablePosZ,
    Float:ccTVTableRotationX,
    Float:ccTVTableRotationY,
    Float:ccTVTableRotationZ,
    ccTVTableModelid,
    ccTVTable_VW,
    ccTVTableInt,
    Text3D:ccTVTextLabel,
    pWatchedTelevision
}

enum
{
    DIALOG_MENU_CCTV
}

new
    ccTV_DATA_FACTION[MAX_CCTV_FACTION][E_CCTV_FACTION],
    Iterator:ccTV_Iterator<MAX_CCTV_FACTION>;

new 
    ccTV_TABLE_DATA_FACTION[MAX_CCTV_TABLE_FACTION][E_CCTV_TABLE_FACTION],
    Iterator:ccTV_Table_Iterator<MAX_CCTV_TABLE_FACTION>;

new 
    bool:playerWatchedCCTV[MAX_PLAYERS], playerWatchCCTV[MAX_PLAYERS], playerWatchVW[MAX_PLAYERS], playerWatchInt[MAX_PLAYERS],
    Float:playerWatchPosX[MAX_PLAYERS], Float:playerWatchPosY[MAX_PLAYERS], Float:playerWatchPosZ[MAX_PLAYERS];

new listTableID[] = {2165, 2008};

Dialog:DIALOG_MENU_CCTV(playerid, response, listitem, const inputtext[])
{
    new 
        sizeofCCTV = Iter_Count(ccTV_Iterator),
        ccTV_Temp_Array[MAX_CCTV_FACTION];

    if (response)
    {
        foreach(new index : ccTV_Iterator)
        {
            for(new temp_index = 0; temp_index < sizeofCCTV; ++temp_index)
            {
                ccTV_Temp_Array[temp_index] = index;
            }
        }

        for(new index = 0; index < sizeof(ccTV_Temp_Array); ++index)
        {
            if (index == listitem)
            {
                foreach(new temp_index : ccTV_Iterator)
                {
                    if (ccTV_Temp_Array[index] == temp_index)
                    {
                        PlayerViewCCTV(playerid, temp_index);
                        break;
                    }
                }
            }
        }
    }
    return 1;
}

ShowPlayerMenuCCTV(playerid)
{
    new string[1048] = "Code\tStatus of Closed Circuit Television";
    foreach(new index : ccTV_Iterator)
    {
        format(string, sizeof(string), "%s\n%s\tOn dinh", string, ccTV_DATA_FACTION[index][ccTV_fCode]);
        Dialog_Show(playerid, DIALOG_MENU_CCTV, DIALOG_STYLE_TABLIST_HEADERS, "Closed Circuit Television Index", string, "Select", "Cancel");
    }
    return 1;
}

PlayerViewCCTV(playerid, index)
{
    GetPlayerPos(playerid, playerWatchPosX[playerid], playerWatchPosY[playerid], playerWatchPosZ[playerid]);
    playerWatchInt[playerid] = GetPlayerVirtualWorld(playerid);
    playerWatchVW[playerid] = GetPlayerInterior(playerid);

    TogglePlayerControllable(playerid, 0);

    SetPlayerPos(playerid, ccTV_DATA_FACTION[index][ccTVPosX], ccTV_DATA_FACTION[index][ccTVPosY], ccTV_DATA_FACTION[index][ccTVPosZ] - 15.0);
    SetPlayerVirtualWorld(playerid, ccTV_DATA_FACTION[index][ccTV_VW]);
    SetPlayerInterior(playerid, ccTV_DATA_FACTION[index][ccTVInt]);

    AttachCameraToDynamicObject(playerid, ccTV_DATA_FACTION[index][objectIndex]);
    
    SetPVarInt(playerid, "pWatchCCTV", 1);
    ccTV_DATA_FACTION[index][playerIDWatch] = playerid;
    playerWatchCCTV[playerid] = index;
    playerWatchedCCTV[playerid] = true;
}

PlayerUnViewCCTV(playerid, index)
{
    SetPlayerPos(playerid, playerWatchPosX[playerid], playerWatchPosY[playerid], playerWatchPosZ[playerid]);
    SetPlayerVirtualWorld(playerid, playerWatchVW[playerid]);
    SetPlayerInterior(playerid, playerWatchVW[playerid]);
    SetCameraBehindPlayer(playerid);
    TogglePlayerControllable(playerid, 1);
    CCTVTable_SetPlayerWatched(index, INVALID_PLAYER_ID);
    ccTV_DATA_FACTION[index][playerIDWatch] = INVALID_PLAYER_ID;
    playerWatchCCTV[playerid] = INVALID_CCTV_ID;
    playerWatchCCTV[playerid] = false;
    DeletePVar(playerid, "pWatchCCTV");
}

stock CCTV_Create(index, &Float:x, &Float:y, &Float:z, worldid, interiorid)
{
    Iter_Add(ccTV_Iterator, index);
    CCTV_SetPosition(index, x, y, z, 0.0, 0.0, 90.0, worldid, interiorid);
    CCTV_CreateObject(index, x, y, z, ccTV_DATA_FACTION[index][ccTVRotationX], ccTV_DATA_FACTION[index][ccTVRotationY], ccTV_DATA_FACTION[index][ccTVRotationZ], worldid, interiorid);
    return 1;   
}

stock CCTV_CreateObject(index, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, worldid, interiorid, Float:streamdistance = STREAMER_OBJECT_SD, Float:drawdistance = STREAMER_OBJECT_DD)
{
    if (Iter_Contains(ccTV_Iterator, index))
    {
        ccTV_DATA_FACTION[index][objectIndex] = CreateDynamicObject(1886, x, y, z, rx, ry, rz, worldid, interiorid, _, streamdistance, drawdistance);
    }
    return 1;
}

stock CCTV_SetPosition(index, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, worldid, interiorid)
{
    if (Iter_Contains(ccTV_Iterator, index))
    {
        ccTV_DATA_FACTION[index][ccTVPosX] = x;
        ccTV_DATA_FACTION[index][ccTVPosY] = y;
        ccTV_DATA_FACTION[index][ccTVPosZ] = z;

        ccTV_DATA_FACTION[index][ccTVRotationX] = rx;
        ccTV_DATA_FACTION[index][ccTVRotationY] = ry;
        ccTV_DATA_FACTION[index][ccTVRotationZ] = rz;

        ccTV_DATA_FACTION[index][ccTV_VW] = worldid;
        ccTV_DATA_FACTION[index][ccTVInt] = interiorid;
    }
    return 1;
}

stock CCTV_DeleteObject(index)
{
    if (Iter_Contains(ccTV_Iterator, index))
    {
        if (IsValidDynamicObject(ccTV_DATA_FACTION[index][objectIndex]))
        {
            CCTV_Delete(index, INVALID_PLAYER_ID);
        }
    }
    return 1;
}

stock CCTV_Delete(index, playerid = INVALID_PLAYER_ID)
{
    if (Iter_Contains(ccTV_Iterator, index))
    {
        CCTV_SetPosition(index, 0.0, 0.0, 0.0, 0.0, 0.0, 90.0, -1, -1);
        CCTV_SetPlayerEdit(index, playerid);
        DestroyDynamicObject(ccTV_DATA_FACTION[index][objectIndex]);
        Iter_Remove(ccTV_Iterator, index);
    }
    return 1;
}

stock CCTV_SetPlayerEdit(index, playerid)
{
    if (Iter_Contains(ccTV_Iterator, index))
    {
        ccTV_DATA_FACTION[index][playerIDEdit] = playerid;
    }
    return 1;
}

stock CCTV_SetFormatCode(index)
{
    if (Iter_Contains(ccTV_Iterator, index))
    {
        switch(index)
        {
            case 0 .. 10:
            {
                format(ccTV_DATA_FACTION[index][ccTV_fCode], 10, "##%d", index);
            }
            default: format(ccTV_DATA_FACTION[index][ccTV_fCode], 10, "#%d", index);
        }
    }
    return 1;
}

stock CCTV_GetPlayerEdit(index)
{
    if (Iter_Contains(ccTV_Iterator, index))
    {
        foreach(new playerid : Player)
        {
            if (ccTV_DATA_FACTION[index][playerIDEdit] == playerid)
            {
                return playerid;
            }
        }
    }
    return INVALID_PLAYER_ID;
}

stock CCTV_GetIndexDistance(playerid)
{
    new Float:x, Float:y, Float:z;
    if (IsPlayerConnected(playerid))
    {
        foreach(new index : ccTV_Iterator)
        {
            GetDynamicObjectPos(ccTV_DATA_FACTION[index][objectIndex], x, y, z);
            if (IsPlayerInRangeOfPoint(playerid, 3.0, x, y, z - 1.0))
            {
                return index;
            }
        }
    }
    return (-1);
}

stock CCTV_GetPlayerEditted(index)
{
    if (Iter_Contains(ccTV_Iterator, index))
    {
        if (CCTV_GetPlayerEdit(index) >= 0 && CCTV_GetPlayerEdit(index) != INVALID_PLAYER_ID)
        {
            return 1;
        }
    }
    return 0;
}

stock CCTV_GetPlayerWatchCCTV(playerid)
{
    foreach(new index : ccTV_Iterator)
    {
        if (ccTV_DATA_FACTION[index][playerIDWatch] == playerid)
        {
            return index;
        }
    }
    return INVALID_CCTV_ID;
}

stock IsPlayerWatchCCTV(playerid)
{
    if (playerWatchedCCTV[playerid] == true) return 1;
    return 0;
}

stock CCTVTable_Create(index, modelid, Float:x, Float:y, Float:z, worldid, interiorid)
{
    Iter_Add(ccTV_Table_Iterator, index);
    SetClosedCircuitTVPosTable(index, modelid, x, y, z, 0.0, 0.0, 90.0, worldid, interiorid);
    CCTVTable_CreateObject(index, modelid, x, y, z, 0.0, 0.0, 90.0, worldid, interiorid);
    ccTV_TABLE_DATA_FACTION[index][ccTVTextLabel] = CreateDynamic3DTextLabel("/cctv", COLOR_OOC, x, y, z, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, worldid, interiorid);
    return 1;
}

stock CCTVTable_CreateObject(index, modelid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, worldid, interiorid)
{
    if (Iter_Contains(ccTV_Table_Iterator, index))
    {
        if (!IsValidDynamicObject(ccTV_TABLE_DATA_FACTION[index][tableIndex])) 
            ccTV_TABLE_DATA_FACTION[index][tableIndex] = CreateDynamicObject(modelid, x, y, z, rx, ry, rz, worldid, interiorid);
    }
    return 1;
}

stock DeleteObjectTable(index)
{
    if (Iter_Contains(ccTV_Table_Iterator, index))
    {
        if (IsValidDynamicObject(ccTV_TABLE_DATA_FACTION[index][tableIndex]))
        {
            DestroyDynamicObject(ccTV_TABLE_DATA_FACTION[index][tableIndex]);
        }
    }
    return 1;
}

stock CCTVTable_Delete(index)
{
    if (Iter_Contains(ccTV_Table_Iterator, index))
    {
        DeleteObjectTable(index);
        SetClosedCircuitTVPosTable(index, -1, 0.0, 0.0, 0.0, 0.0, 0.0, 90.0, -1, -1);
        CCTVTable_SetPlayerEdit(index, INVALID_PLAYER_ID);
        DestroyDynamic3DTextLabel(ccTV_TABLE_DATA_FACTION[index][ccTVTextLabel]);
        Iter_Remove(ccTV_Table_Iterator, index);
    }
    return 1;
}

stock SetClosedCircuitTVPosTable(index, modelid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, worldid, interiorid)
{
    if (Iter_Contains(ccTV_Table_Iterator, index))
    {
        ccTV_TABLE_DATA_FACTION[index][ccTVTablePosX] = x;
        ccTV_TABLE_DATA_FACTION[index][ccTVTablePosY] = y;
        ccTV_TABLE_DATA_FACTION[index][ccTVTablePosZ] = z;

        ccTV_TABLE_DATA_FACTION[index][ccTVTableRotationX] = rx;
        ccTV_TABLE_DATA_FACTION[index][ccTVTableRotationY] = ry;
        ccTV_TABLE_DATA_FACTION[index][ccTVTableRotationZ] = rz;

        ccTV_TABLE_DATA_FACTION[index][ccTVTableModelid] = modelid;
        ccTV_TABLE_DATA_FACTION[index][ccTVTable_VW] = worldid;
        ccTV_TABLE_DATA_FACTION[index][ccTVTableInt] = interiorid;

    }
    return 1;
}

stock CCTVTable_SetPlayerEdit(index, playerid)
{
    if (Iter_Contains(ccTV_Table_Iterator, index))
    {
        ccTV_TABLE_DATA_FACTION[index][PlayerEdit_CCTVTable] = playerid;
    }
    return 1;
}

stock CCTVTable_SetPlayerWatch(playerid, index)
{
    if (Iter_Contains(ccTV_Table_Iterator, index))
    {
        CCTVTable_SetPlayerWatched(index, playerid);
        ShowPlayerMenuCCTV(playerid);
    }
    return 1;
}

stock CCTVTable_SetPlayerStopWatching(playerid, index)
{
    if (Iter_Contains(ccTV_Table_Iterator, index))
    {
        PlayerUnViewCCTV(playerid, playerWatchCCTV[playerid]);
    }
    return 1;
}

stock CCTVTable_SetPlayerWatched(index, playerid)
{
    if (Iter_Contains(ccTV_Table_Iterator, index))
    {
        ccTV_TABLE_DATA_FACTION[index][pWatchedTelevision] = playerid;
    }
    return 1;
}

stock CCTVTable_GetIndexPlayerWatched(playerid)
{
    foreach(new index : ccTV_Table_Iterator)
    {
        if (ccTV_TABLE_DATA_FACTION[index][pWatchedTelevision] == playerid)
        {
            return index;
        }
    }
    return INVALID_CCTV_ID;
}

stock GetTableIndex_PlayerDistance(playerid)
{
    foreach(new index : ccTV_Table_Iterator)
    {
        GetDynamicObjectPos(ccTV_TABLE_DATA_FACTION[index][tableIndex], ccTV_TABLE_DATA_FACTION[index][ccTVTablePosX], ccTV_TABLE_DATA_FACTION[index][ccTVTablePosY], ccTV_TABLE_DATA_FACTION[index][ccTVTablePosZ]);
        if (IsPlayerInRangeOfPoint(playerid, 2.0, ccTV_TABLE_DATA_FACTION[index][ccTVTablePosX], ccTV_TABLE_DATA_FACTION[index][ccTVTablePosY], ccTV_TABLE_DATA_FACTION[index][ccTVTablePosZ]))
        {
            return index;
        }
    }
    return (-1);
}

stock CCTVTable_GetPlayerEdit(index)
{
    if (Iter_Contains(ccTV_Table_Iterator, index))
    {
        foreach(new playerid : Player)
        {
            if (ccTV_TABLE_DATA_FACTION[index][PlayerEdit_CCTVTable] == playerid)
            {
                return playerid;
            }
        }
    }
    return INVALID_PLAYER_ID;
}

stock bool:IsValidTableModelid(modelid)
{
    for(new index = 0; index < sizeof(listTableID); ++index)
    {
        if (modelid == listTableID[index])
        {
            return true;
        }
    }
    return false;
}

stock IsPlayerEditTable(index)
{
    if (Iter_Contains(ccTV_Table_Iterator, index))
    {
        if (ccTV_TABLE_DATA_FACTION[index][PlayerEdit_CCTVTable] >= 0 && ccTV_TABLE_DATA_FACTION[index][PlayerEdit_CCTVTable] != INVALID_PLAYER_ID)
        {
            return 1;
        }
    }
    return 0;
}

stock CCTVTable_IsPlayerWatched(index)
{
    if (Iter_Contains(ccTV_Table_Iterator, index))
    {
        if (ccTV_TABLE_DATA_FACTION[index][pWatchedTelevision] == 1) return 1;
    }
    return 0;
}

CMD:createcctv(playerid)
{
    if (IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_LIGHTRED, "Ban khong the su dung khi dang o tren phuong tien.");

    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    new index = Iter_Free(ccTV_Iterator);
    if (index == -1) return SendClientMessage(playerid, COLOR_LIGHTRED, "CCTV da dat gioi han.");

    if (GetPVarType(playerid, "pEditCCTV") != PLAYER_VARTYPE_INT) SetPVarInt(playerid, "pEditCCTV", 1);
    else return SendClientMessage(playerid, COLOR_LIGHTRED, "Ban hien dang chinh sua CCTV, khong hoan tat no truoc.");

    CCTV_Create(index, x, y, z, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
    EditDynamicObject(playerid, ccTV_DATA_FACTION[index][objectIndex]);
    CCTV_SetPlayerEdit(index, playerid);
    CCTV_SetFormatCode(index);

    SendClientMessage(playerid, -1, "Ban da tao thanh cong CCTV");
    return 1;
}

CMD:deletecctv(playerid, params[])
{
    new index = CCTV_GetIndexDistance(playerid);
    if (index == -1) return SendClientMessage(playerid, COLOR_LIGHTRED, "Ban khong o gan mot CCTV.");

    if (CCTV_GetPlayerEditted(index) == 1) return SendClientMessage(playerid, COLOR_LIGHTRED, "CCTV nay hien dang ban.");
    
    CCTV_DeleteObject(index);
    SendClientMessage(playerid, COLOR_FADE1, "Ban da cat thanh cong CCTV!");
    return 1;
}

CMD:movecctv(playerid)
{
    new index = CCTV_GetIndexDistance(playerid);
    if (index == -1) return SendClientMessage(playerid, COLOR_LIGHTRED, "Khong co may CCTV nao de cat di!");

    if (CCTV_GetPlayerEditted(index) == 1) return SendClientMessage(playerid, COLOR_LIGHTRED, "CCTV nay hien dang bam.");

    if (GetPVarType(playerid, "pEditCCTV") != PLAYER_VARTYPE_INT) SetPVarInt(playerid, "pMoveCCTV", 1);
    else return SendClientMessage(playerid, COLOR_LIGHTRED, "Ban dang trong qua trinh chinh sua vat the!");

    CCTV_SetPlayerEdit(index, playerid);
    EditDynamicObject(playerid, ccTV_DATA_FACTION[index][objectIndex]);
    return 1;
}

hook OnPlayerEditDynObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
    if (GetPVarInt(playerid, "pEditCCTV") == 1 || GetPVarInt(playerid, "pMoveCCTV") == 1)
    {
        new index = INVALID_CCTV_ID;
        foreach(new temp_index : ccTV_Iterator)
        {
            if (CCTV_GetPlayerEdit(temp_index) == playerid)
            {
                index = temp_index;
                break;
            }
        }

        switch(response)
        {
            case EDIT_RESPONSE_CANCEL:
            {
                if (GetPVarInt(playerid, "pEditCCTV") == 1)                
                {
                    CCTV_DeleteObject(index);
                }
                if (GetPVarInt(playerid, "pMoveCCTV") == 1) 
                {
                    SetDynamicObjectPos(ccTV_DATA_FACTION[index][objectIndex], x, y, z);
                    SetDynamicObjectRot(ccTV_DATA_FACTION[index][objectIndex], rx, ry, rz);
                }
                SendClientMessage(playerid, COLOR_LIGHTRED, "Ban da huy bo qua trinh dieu chinh CCTV.");
                DeletePVar(playerid, "pEditCCTV");
                DeletePVar(playerid, "pMoveCCTV");
                return 1;
            }
            case EDIT_RESPONSE_FINAL:
            {
                CCTV_SetPosition(index, x, y, z, rx, ry, rz, GetPlayerVirtualWorld(playerid), GetPlayerInterior(index));
                CCTV_SetPlayerEdit(index, INVALID_PLAYER_ID);

                SetDynamicObjectPos(ccTV_DATA_FACTION[index][objectIndex], ccTV_DATA_FACTION[index][ccTVPosX], ccTV_DATA_FACTION[index][ccTVPosY], ccTV_DATA_FACTION[index][ccTVPosZ]);
                SetDynamicObjectRot(ccTV_DATA_FACTION[index][objectIndex], ccTV_DATA_FACTION[index][ccTVRotationX], ccTV_DATA_FACTION[index][ccTVRotationY], ccTV_DATA_FACTION[index][ccTVRotationZ]);
               
                SendClientMessage(playerid, COLOR_LIGHTRED, "Ban da dieu chinh CCTV den vi tri dieu chinh.");
               
                DeletePVar(playerid, "pEditCCTV");
                DeletePVar(playerid, "pMoveCCTV");
                return 1;
            }
        }
    }
    return 1;
}

CMD:createcctvtable(playerid, params[])
{
    new modelid;
    if (sscanf(params, "d", modelid))
    {
        SendClientMessage(playerid, COLOR_FADE1, "SU DUNG: /createcctvtable [modelid]");
        SendClientMessage(playerid, COLOR_FADE1, "Modelid: 2165, 2008");
        return 1;
    }

    if (IsValidTableModelid(modelid) == false) return SendClientMessage(playerid, COLOR_LIGHTRED, "ModelID khong hop le."); 

    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    new index = Iter_Free(ccTV_Table_Iterator);
    if (index == -1) return SendClientMessage(playerid, COLOR_LIGHTRED, "CCTV Table da dat gioi han.");

    CCTVTable_Create(index, modelid, x, y, z-1, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
    SetPlayerPos(playerid, x, y, z+2);
    CCTVTable_SetPlayerEdit(index, playerid);
    EditDynamicObject(playerid, ccTV_TABLE_DATA_FACTION[index][tableIndex]);
    SetPVarInt(playerid, "pEditCCTV_Table", 1);
    SendClientMessage(playerid, COLOR_OOC, "* Ban da tao CCTV Table.");
    return 1;
}

CMD:deletecctvtable(playerid)
{
    new index = GetTableIndex_PlayerDistance(playerid);
    if (index == -1) return SendClientMessage(playerid, COLOR_LIGHTRED, "Ban khong o gan mot CCTV Table.");

    if (IsPlayerEditTable(index) == 1) return SendClientMessage(playerid, COLOR_LIGHTRED, "CCTV Table nay hien khong the su dung vao thoi diem nay.");

    CCTVTable_Delete(index);
    return 1;
}

CMD:cctv(playerid)
{
    if (GetPVarInt(playerid, "pWatchCCTV") != 1)
    {
        new index = GetTableIndex_PlayerDistance(playerid);
        if (index == -1) return SendClientMessage(playerid, COLOR_LIGHTRED, "Ban khong o gan mot CCTV Table.");

        if (CCTVTable_IsPlayerWatched(index) == 1) return SendClientMessage(playerid, COLOR_LIGHTRED, "CCTV Table nay hien dang ban.");

        CCTVTable_SetPlayerWatch(playerid, index);
    }
    else
    {
        new index = CCTVTable_GetIndexPlayerWatched(playerid);
        CCTVTable_SetPlayerStopWatching(playerid, index);
    }
    return 1;
}

stock CCTV_OnPlayerEditDynObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
    if (GetPVarInt(playerid, "pEditCCTV_Table") == 1)
    {
        new index = INVALID_CCTV_ID;
        foreach(new temp_index : ccTV_Table_Iterator)
        {
            if (CCTVTable_GetPlayerEdit(temp_index) == playerid)
            {
                index = temp_index;
                break;
            }
        }

        if (objectid == ccTV_TABLE_DATA_FACTION[index][tableIndex])
        {
            switch(response)
            {
                case EDIT_RESPONSE_CANCEL:
                {
                    CCTVTable_Delete(index);
                    CCTVTable_SetPlayerEdit(index, INVALID_PLAYER_ID);
                    DeletePVar(playerid, "pEditCCTV_Table");
                }
                case EDIT_RESPONSE_FINAL:
                {
                    SetClosedCircuitTVPosTable(index, GetObjectModel(objectid), x, y, z, rx, ry, rz, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
                    SetDynamicObjectPos(ccTV_TABLE_DATA_FACTION[index][tableIndex], x, y, z);
                    SetDynamicObjectRot(ccTV_TABLE_DATA_FACTION[index][tableIndex], rx, ry, rz);
                    CCTVTable_SetPlayerEdit(index, INVALID_PLAYER_ID);
                    DeletePVar(playerid, "pEditCCTV_Table");
                }

            }
        }
    }
    return 1;
}