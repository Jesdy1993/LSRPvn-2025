/********************************************************
 *                                                      *
 *   @Author:                   21st Century        *
 *   @Year started:             2020                    *
 *   @Main scripter:            Arashi                  *
 *   @Supporte scripter :         duydang.              *
 *                              Ares                    *
 *                              zOn                     *
 *                              SAMP Community [VN]     *
 *   @Mapper:                   Nekko                   *
 *   @Other:                    update                  *
 *                                                      *
 *********************************************************/

#include <YSI\y_hooks>

#define MAX_CUTTER 30
#define INVALID_TREE_ID -1
#define checkpointBuyCutter 100
enum E_DATA_CUTTER {
    cutterTreeObject[MAX_CUTTER],
    bool:cutterSawing[MAX_CUTTER],
    cutterRespawn[MAX_CUTTER],
    bool:cutterInRespawn[MAX_CUTTER],
    cutterStepRespawn[MAX_CUTTER],
    Text3D:cutterTreeLabel[MAX_CUTTER],
    Float:cutterPercent[MAX_CUTTER],
    cutterStorage,
    bool:cutterHandling,
    cutterPickup,
    Text3D:cutterWarehouseLabel,
    cutterMachineObject,
    cutterWarehouseTimer,
    cutterHandlingStep,
    cutterSellPickup,
    Text3D:cutterSellLabel
}

new Cutter[E_DATA_CUTTER];

new bool:playerCutStatus[MAX_PLAYERS],
    bool:playerCutCarry[MAX_PLAYERS],
    playerCutTimer[MAX_PLAYERS];

static const Float:cutterPosition[][] = {
    {-1424.1082, -1556.2420, 100.9158},
    {-1426.6881, -1550.9818, 100.9158},
    {-1419.7480, -1550.9818, 100.9158},
    {-1421.6179, -1545.9117, 100.9158},
    {-1429.0678, -1545.9117, 100.9158},
    {-1430.9879, -1549.6021, 100.9158},
    {-1437.3377, -1549.6021, 100.9158},
    {-1442.7680, -1551.9320, 100.9158},
    {-1442.7680, -1544.1417, 100.9158},
    {-1447.4984, -1545.8017, 100.9158},
    {-1450.9484, -1549.9724, 100.9158},
    {-1454.9683, -1544.1123, 100.9158},
    {-1456.7586, -1547.5723, 100.9158},
    {-1456.7586, -1547.5723, 100.9158},
    {-1456.7586, -1552.4128, 100.9158},
    {-1450.5184, -1555.1330, 100.9158},
    {-1461.5186, -1555.1330, 100.9158},
    {-1461.5186, -1550.4132, 100.9158},
    {-1461.5186, -1546.1721, 100.9158},
    {-1439.9888, -1535.8792, 100.9158},
    {-1444.2989, -1535.8792, 100.9158},
    {-1450.4888, -1536.0091, 100.9158},
    {-1456.4388, -1538.6691, 100.9158},
    {-1456.4388, -1538.6691, 100.9158},
    {-1460.8494, -1535.5090, 100.9158},
    {-1447.1590, -1539.9194, 100.9158},
    {-1437.8786, -1539.9194, 100.9158},
    {-1433.8084, -1542.1491, 100.9158},
    {-1430.8076, -1536.1491, 100.9158},
    {-1425.7375, -1536.1491, 100.9158}
};

stock IsPlayerRangeTree(playerid) {
    for(new i = 0; i < MAX_CUTTER; i++) {
        if (IsPlayerInRangeOfPoint(playerid, 1.5, cutterPosition[i][0], cutterPosition[i][1], cutterPosition[i][2])) {
            return true;
        }
    }
    return false;
}

stock GetTreeIDRangePlayer(playerid, &treeid = -1) {
    for(new i = 0; i < MAX_CUTTER; i++) {
        if (IsPlayerInRangeOfPoint(playerid, 1.5, cutterPosition[i][0], cutterPosition[i][1], cutterPosition[i][2])) {
            treeid = i;
            break;
        }
    }
    return true;
}

hook OnGameModeInit() {
    for (new i = 0; i < MAX_CUTTER; i++) {
        Cutter[cutterTreeObject][i] = CreateDynamicObject(657, cutterPosition[i][0], cutterPosition[i][1], cutterPosition[i][2], 0.0, 0.0, 0.0);
        Cutter[cutterTreeLabel][i] = CreateDynamic3DTextLabel("Nhan N de chat cay.", COLOR_WHITE, cutterPosition[i][0], cutterPosition[i][1], cutterPosition[i][2]+1.5, 10.0);
        Cutter[cutterSawing][i] = false;
        Cutter[cutterStepRespawn][i] = -1;
        Cutter[cutterInRespawn][i] = false;
        Cutter[cutterStepRespawn][i] = 0;
    }
    
    Cutter[cutterStorage] = 0;
    Cutter[cutterHandling] = false;
    Cutter[cutterWarehouseLabel] = CreateDynamic3DTextLabel("< KHO GO >\nNhan 'Y' de dua go vao kho.", COLOR_YELLOW, -1437.2875, -1561.9709, 101.7578, 15.0);
    Cutter[cutterPickup] = CreateDynamicPickup(1239, 1, -1437.2875, -1561.9709, 101.7578);

    Cutter[cutterSellLabel] = CreateDynamic3DTextLabel("< BUY CUTTER >\n\nBam 'Y' de ban go.", COLOR_YELLOW, 1866.3325, -1792.2802, 13.5469, 15.0);
    Cutter[cutterSellPickup] = CreateDynamicPickup(1239, 1, 1866.3325, -1792.2802, 13.5469);

    new CutterMap[10];
    CutterMap[1] = CreateDynamicObject(8063, -1441.8149, -1575.8730, 104.4351, 0.0000, 0.0000, 0.0000); //vgswrehse16
    CutterMap[2] = CreateDynamicObject(3287, -1415.1953, -1567.4282, 105.3988, 0.0000, 0.0000, 0.0000); //cxrf_oiltank
    CutterMap[3] = CreateDynamicObject(3722, -1442.8786, -1591.1842, 105.7816, 0.0000, 0.0000, -90.0000); //laxrf_scrapbox
    CutterMap[4] = CreateDynamicObject(3287, -1415.1953, -1577.0982, 105.3988, 0.0000, 0.0000, 0.0000); //cxrf_oiltank
    CutterMap[5] = CreateDynamicObject(1617, -1417.4150, -1564.8748, 107.3057, 0.0000, 0.0000, 180.0000); //nt_aircon1_01
    CutterMap[6] = CreateDynamicObject(1617, -1417.4150, -1564.8748, 107.3057, 0.0000, 0.0000, 180.0000); //nt_aircon1_01
    CutterMap[7] = CreateDynamicObject(1617, -1417.4150, -1573.8656, 107.3057, 0.0000, 0.0000, 180.0000); //nt_aircon1_01
    CutterMap[8] = CreateDynamicObject(1617, -1417.4150, -1587.0659, 107.3057, 0.0000, 0.0000, 180.0000); //nt_aircon1_01
    CutterMap[9] = CreateDynamicObject(3722, -1442.8786, -1598.0659, 105.7816, 0.0000, 0.0000, -90.0000); //laxrf_scrapbox
}

hook OnPlayerConnect(playerid) {
    playerCutStatus[playerid] = false;
    playerCutCarry[playerid] = false;
    playerCutTimer[playerid] = -1;
    RemoveBuildingForPlayer(playerid, 3276, -1427.8499, -1600.0899, 101.4840, 0.10); // cxreffencesld
    RemoveBuildingForPlayer(playerid, 3276, -1439.2700, -1600.3399, 101.4840, 0.10); // cxreffencesld
    RemoveBuildingForPlayer(playerid, 3276, -1451.0999, -1599.5999, 101.5550, 0.10); // cxreffencesld
    RemoveBuildingForPlayer(playerid, 3276, -1420.6600, -1594.0300, 101.4840, 0.10); // cxreffencesld
    RemoveBuildingForPlayer(playerid, 3276, -1417.8000, -1583.0300, 101.4840, 0.10); // cxreffencesld
    RemoveBuildingForPlayer(playerid, 3276, -1469.2399, -1569.8100, 101.4840, 0.10); // cxreffencesld
    RemoveBuildingForPlayer(playerid, 17056, -1462.0200, -1532.5300, 101.9059, 0.10); // cw_corrug01
    RemoveBuildingForPlayer(playerid, 17057, -1451.5300, -1569.6099, 100.7419, 0.10); // cw_haypile03
    RemoveBuildingForPlayer(playerid, 17058, -1447.7199, -1576.7299, 100.7419, 0.10); // cw_tempbarn01
    RemoveBuildingForPlayer(playerid, 17356, -1447.7199, -1576.7299, 100.7419, 0.10); // LOD Model of cw_tempbarn01
    RemoveBuildingForPlayer(playerid, 17335, -1432.5500, -1545.8699, 108.5309, 0.10); // farmhouse02
    RemoveBuildingForPlayer(playerid, 17351, -1432.5500, -1545.8699, 108.5309, 0.10); // LOD Model of farmhouse02
    RemoveBuildingForPlayer(playerid, 1501, -1437.8900, -1545.2299, 101.2809, 0.10); // Gen_doorEXT04
    RemoveBuildingForPlayer(playerid, 17050, -1411.2199, -1530.5500, 100.7500, 0.10); // cw_Silo02
    RemoveBuildingForPlayer(playerid, 3276, -1411.1600, -1561.0999, 101.4840, 0.10); // cxreffencesld
    RemoveBuildingForPlayer(playerid, 3276, -1414.5999, -1572.0899, 101.4840, 0.10); // cxreffencesld
    RemoveBuildingForPlayer(playerid, 3276, -1403.1700, -1528.8399, 101.4840, 0.10); // cxreffencesld
    RemoveBuildingForPlayer(playerid, 3276, -1402.6700, -1540.1999, 101.4840, 0.10); // cxreffencesld
    RemoveBuildingForPlayer(playerid, 3276, -1406.4200, -1550.8399, 101.4840, 0.10); // cxreffencesld
    RemoveBuildingForPlayer(playerid, 17049, -1412.8399, -1520.4000, 100.7500, 0.10); // cw_Silo01
    return true;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if (newkeys & KEY_NO) {
        if (IsPlayerRangeTree(playerid)) {
            if (!playerCutStatus[playerid]) {

                if (Inventory_@CountAmount(playerid,20) > 100)
                    return SendErrorMessage(playerid, "Ban khong con suc chua go nua, hay ban no truoc.");

                if (playerCutCarry[playerid])
                    return SendErrorMessage(playerid, "Ban khong the don cay o thoi diem nay.");

                if (playerCutStatus[playerid])
                    return SendErrorMessage(playerid, "Ban khong the don cay o thoi diem nay.");

                new treeid;
                GetTreeIDRangePlayer(playerid, treeid);
                if (treeid == INVALID_TREE_ID) 
                    return true;
                
                if (Cutter[cutterInRespawn][treeid]) 
                    return SendErrorMessage(playerid, "Cay nay hien khong the don.");

                if (Cutter[cutterSawing][treeid])
                    return SendErrorMessage(playerid, "Cay nay hien dang bi don boi mot nguoi choi khac.");

                playerCutStatus[playerid] = true;
                
                Cutter[cutterSawing][treeid] = true;
                if (IsValidDynamic3DTextLabel(Cutter[cutterTreeLabel][treeid])) DestroyDynamic3DTextLabel(Cutter[cutterTreeLabel][treeid]);
                Cutter[cutterTreeLabel][treeid] = CreateDynamic3DTextLabel("Dang don\n0%%", COLOR_GREY, cutterPosition[treeid][0], cutterPosition[treeid][1], cutterPosition[treeid][2]+1.5, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), playerid);
                RemovePlayerAttachedObject(playerid, 9);
				SetPlayerAttachedObject(playerid, 9, 341, 6);

                SetCameraBehindPlayer(playerid);
                ApplyAnimation(playerid, "CHAINSAW", "WEAPON_csaw", 4.1, true, false, false, true, 0, true);
                TogglePlayerControllable(playerid, false);

                Cutter[cutterPercent][treeid] = 0.0;
                KillTimer(playerCutTimer[playerid]);
                playerCutTimer[playerid] = -1;
                playerCutTimer[playerid] = SetTimerEx("TreeChopdown", 2000, true, "ii", playerid, treeid);

            }
        }
    }
    if (newkeys & KEY_YES) {
        if (IsPlayerInRangeOfPoint(playerid, 3.0, -1437.2875, -1561.9709, 101.7578)) {
            if (playerCutCarry[playerid]) {
                if (!Cutter[cutterHandling]) {
                    if (Cutter[cutterStorage] < 300) {
                        ClearAnimations(playerid);
                        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
                        ApplyAnimation(playerid, "CARRY", "putdwn05", 4.1, 0, 1, 1, 0, 0);
                        playerCutCarry[playerid] = false;
                        RemovePlayerAttachedObject(playerid, 9);
                        new rand = RandomEx(3, 6);
                        Inventory_@Add(playerid,20,rand);
                        new string[129];
                        format(string,sizeof string,"* Ban nhan duoc %d go tu cong viec, su dung lenh \"/my inv\" de xem so go hien tai.", rand);
                        // PlayerMySQL_Integer(playerid, "character", "playerWood", character[playerid][playerWood]);
                        SendClientMessage(playerid, COLOR_CHAT, string);

                        new string_log[229];
                        format(string_log, sizeof(string_log), "[%s] %s đã bỏ gỗ vào kho và nhận được %d gỗ", GetLogTime(),GetPlayerNameEx(playerid),rand);         
                        SendLogDiscordMSG(job_Lumberjack, string_log);
                  
                         
                        Cutter[cutterStorage] += rand;
                        new text[64];
                        format(text, sizeof text, "< WAREHOUSE >\n\n-SAN SANG-\n%d/300\n\nNhan\"Y\" de dua go vao kho.", Cutter[cutterStorage]);
                        UpdateDynamic3DTextLabelText(Cutter[cutterWarehouseLabel], COLOR_YELLOW, text);
                        if (Cutter[cutterStorage] >= 300) {
                            Cutter[cutterHandling] = true;
                            UpdateDynamic3DTextLabelText(Cutter[cutterWarehouseLabel], COLOR_YELLOW, "< WAREHOUSE >\n\n-DANG XU LY-\n0%%/100%%");
                            Cutter[cutterWarehouseTimer] = SetTimer("WoodHandling", 1000, true);
                            return true;
                        }
                    }
                }
            }
        }
        else if (IsPlayerInRangeOfPoint(playerid, 3.0, 1866.3325, -1792.2802, 13.5469)) {
            if (Inventory_@CountAmount(playerid,20) <= 0) 
                return SendErrorMessage(playerid, "Ban khong co go de co the ban.");
            
            GivePlayerMoneyEx(playerid, Inventory_@CountAmount(playerid,20)*9);
            new string[129];
            format(string,sizeof string,"* Ban nhan duoc $%d tien tu viec ban %d go.", Inventory_@CountAmount(playerid,20)*9, Inventory_@CountAmount(playerid,20));
            SendClientMessage(playerid, COLOR_YELLOW, string);
            PlayerInfo[playerid][pCountWood]++;



         
            format(string, sizeof(string), "%s da nhan duoc $%d tu cong viec don go.", GetPlayerNameEx(playerid),  Inventory_@CountAmount(playerid,20) * 15);
            Log("Logs/Lumberjack.log", string);


            new count = Inventory_@CountAmount(playerid,20);
            new string_log[229];
            format(string_log, sizeof(string_log), "[%s] %s đã bán %d gỗ và nhận được $%s", GetLogTime(),GetPlayerNameEx(playerid),count,number_format(Inventory_@CountAmount(playerid,20)*15));         
            SendLogDiscordMSG(job_Lumberjack, string_log);

          


            Inventory_@FineItem(playerid,20,count);
        }
    }
    return true;
}

forward WoodHandling();
public WoodHandling() {
    if (Cutter[cutterHandlingStep] < 100) {
        Cutter[cutterHandlingStep] += RandomEx(1, 3);
        new text[64];
        format(text, sizeof text, "< WAREHOUSE >\n\n-DANG XU LY-\n%d%%/100%%", Cutter[cutterHandlingStep]);
        UpdateDynamic3DTextLabelText(Cutter[cutterWarehouseLabel], COLOR_YELLOW, text);
        if (Cutter[cutterHandlingStep] > 100) Cutter[cutterHandlingStep] = 100;
        return true;
    }

    KillTimer(Cutter[cutterWarehouseTimer]);
    Cutter[cutterWarehouseTimer] = -1;
    Cutter[cutterHandlingStep] = 0;
    Cutter[cutterHandling] = false;
    Cutter[cutterStorage] = 0;
    UpdateDynamic3DTextLabelText(Cutter[cutterWarehouseLabel], COLOR_YELLOW, "< WAREHOUSE >\n\n-SAN SANG-\n0/300\n\nNhan \"Y\" de dua go vao kho.");
    return true;
}
forward Float:frandom(Float: max, Float:min, dp);
stock Float:frandom(Float:max, Float:min, dp)
{
    new
        Float:mul = floatpower(10.0, dp),
        imin = floatround(min * mul),
        imax = floatround(max * mul);
    return float(random(imax - imin) + imin) / mul;
}

forward TreeChopdown(playerid, treeid);
public TreeChopdown(playerid, treeid) {
    if (Cutter[cutterPercent][treeid] < 100.0) {
        Cutter[cutterPercent][treeid] += frandom(12.0, 8.0, 2);
        if (Cutter[cutterPercent][treeid] > 100.0) Cutter[cutterPercent][treeid] = 100.0;
        ApplyAnimation(playerid, "CHAINSAW", "WEAPON_csaw", 4.1, true, false, false, false, 0, 1);
        
        new text[64];
        format(text, sizeof text, "Dang don\n%.1f%%", Cutter[cutterPercent][treeid]);
        UpdateDynamic3DTextLabelText(Cutter[cutterTreeLabel][treeid], COLOR_GREY, text);
        return true;
    }
   
    playerCutStatus[playerid] = false;
    SetCameraBehindPlayer(playerid);
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	TogglePlayerControllable(playerid, true);
    RemovePlayerAttachedObject(playerid, 9);
    ApplyAnimation(playerid, "CARRY", "liftup05", 4.1, 0, 1, 1, 0, 0);
    KillTimer(playerCutTimer[playerid]);
    playerCutTimer[playerid] = -1;
    DestroyDynamicObject(Cutter[cutterTreeObject][treeid]);
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
	SetPlayerAttachedObject(playerid, 9, 1463, 1, 0.20, 0.36, 0.0, 0.0, 90.0, 0.0, 0.4, 0.3, 0.6);
    playerCutCarry[playerid] = true;
    SendClientMessage(playerid, COLOR_YELLOW, "# Hay dem go den kho de gui go.");
    Cutter[cutterTreeObject][treeid] = CreateDynamicObject(841, cutterPosition[treeid][0], cutterPosition[treeid][1], cutterPosition[treeid][2], 0.0, 0.0, 0.0);
    Cutter[cutterSawing][treeid] = false;
    Cutter[cutterPercent][treeid] = 0.0;
    KillTimer(Cutter[cutterRespawn][treeid]);
    Cutter[cutterRespawn][treeid] = -1;
    Cutter[cutterRespawn][treeid] = SetTimerEx("TreeGrowup", 1000, true, "i", treeid);
    Cutter[cutterInRespawn][treeid] = true;
    Cutter[cutterStepRespawn][treeid] = 0;

    if (IsValidDynamic3DTextLabel(Cutter[cutterTreeLabel][treeid])) DestroyDynamic3DTextLabel(Cutter[cutterTreeLabel][treeid]);
    Cutter[cutterTreeLabel][treeid] = CreateDynamic3DTextLabel("Phuc hoi\n80s", COLOR_GREY, cutterPosition[treeid][0], cutterPosition[treeid][1], cutterPosition[treeid][2], 10.0);
    return true;
}
 
forward TreeGrowup(treeid);
public TreeGrowup(treeid) {
    if (Cutter[cutterStepRespawn][treeid] < 80) {
        Cutter[cutterStepRespawn][treeid]++;
        new text[64];
        format(text, sizeof text, "Phuc hoi\n%ds", 80-Cutter[cutterStepRespawn][treeid]);
        UpdateDynamic3DTextLabelText(Cutter[cutterTreeLabel][treeid], COLOR_GREY, text);
        if (Cutter[cutterStepRespawn][treeid] > 80) Cutter[cutterStepRespawn][treeid] = 80;
        return true;
    }

    Cutter[cutterStepRespawn] = 0;
    Cutter[cutterInRespawn][treeid] = false;
    KillTimer(Cutter[cutterRespawn][treeid]);
    Cutter[cutterRespawn][treeid] = -1;
    DestroyDynamicObject(Cutter[cutterTreeObject][treeid]);
    Cutter[cutterTreeObject][treeid] = CreateDynamicObject(657, cutterPosition[treeid][0], cutterPosition[treeid][1], cutterPosition[treeid][2], 0.0, 0.0, 0.0);
    DestroyDynamic3DTextLabel(Cutter[cutterTreeLabel][treeid]);
    Cutter[cutterTreeLabel][treeid] = CreateDynamic3DTextLabel("Nhan N de chat cay.", COLOR_WHITE, cutterPosition[treeid][0], cutterPosition[treeid][1], cutterPosition[treeid][2], 10.0);
    return true;
}

// CMD:bango(playerid) {
//     if (!IsPlayerInRangeOfPoint(playerid, 4.0, 1866.3325, -1792.2802, 13.5469))
//     {
//         SendServerMessage(playerid, "Vui long di den vi tri ban go [CP tren ban do].");
//         SetPlayerCheckpoint(playerid, 1866.3325, -1792.2802, 13.5469, 4.0);
//         CP[playerid] = checkpointBuyCutter;
//         return true;
//     }

//     if (Inventory_@CountAmount(playerid,20) <= 0) 
//         return SendErrorMessage(playerid, "Ban khong co go de co the ban.");
    
//     GivePlayerMoneyEx(playerid, Inventory_@CountAmount(playerid,20)*3);
//     new string[129];
//     format(string,sizeof string,"* Ban nhan duoc $%d tien tu viec ban %d go.", Inventory_@CountAmount(playerid,20)*3, Inventory_@CountAmount(playerid,20));
//     SendClientMessage(playerid, COLOR_YELLOW, string);

 
//     format(string, sizeof(string), "%s da nhan duoc $%d tu cong viec don go.", GetPlayerNameEx(playerid),  Inventory_@CountAmount(playerid,20) * 3);
//     Log("Logs/Lumberjack.log", string);

//     Inventory_@Drop(playerid,20,Inventory_@CountAmount(playerid,20));
//     return true;
// }

// CMD:xemgo(playerid) {
//     return SendServerMessage(playerid, sprintf("Go hien co: %d (/bango)", character[playerid][playerWood]));
// }

hook OnPlayerEnterCheckpoint(playerid) {
    if (CP[playerid] == checkpointBuyCutter) {
        if (IsPlayerInRangeOfPoint(playerid, 4.0, 1866.3325, -1792.2802, 13.5469)) {
            DisablePlayerCheckpoint(playerid);
            CP[playerid] = 0;
        }
    }
}