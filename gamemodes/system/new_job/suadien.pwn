









#include <YSI\y_timers>
#include <YSI\y_hooks>

forward Float:GetPosInFrontOfPlayer(playerid, &Float:x, &Float:y, Float:distance);

new const Float:electricPost[][4] = {
    {198.6757,-1462.1362,12.9367,30.5521},
    {235.8762,-1463.8397,13.4163,234.9912},
    {271.7019,-1402.8845,13.7907,22.9695},
    {327.3259,-1376.2256,14.2545,47.3913},
    {510.1584,-1290.1937,15.9769,232.9884},
    {413.6050,-1251.1440,51.6221,196.2885},
    {190.7098,-1369.5297,49.5653,61.1778},
    {256.7585,-1336.5773,52.9600,225.0108},
    {421.0874,-1007.2005,92.8985,340.1304},
    {364.0779,-1008.9352,93.0627,30.2224},
    {885.2722,-860.5866,78.4716,210.5345},
    {985.1274,-799.1968,99.0323,26.0866},
    {1520.7205,-782.3992,77.6370,309.5697},
    {1493.9913,-848.6179,64.3389,53.1354},
    {1446.0060,-935.6011,36.2357,339.1463},
    {1070.8158,-1030.3390,32.0861,23.7236},
    {908.4128,-1358.0011,13.3676,52.6758},
    {929.2934,-1415.0756,13.3803,245.6909},
    {788.5483,-1384.3076,13.7244,100.6998},
    {1837.1158,-1270.4182,13.5458,139.5977},
    {1837.5842,-1370.0565,13.5625,74.5700},
    {1876.5839,-1349.9808,13.5472,204.1007},
    {1861.3108,-1251.5157,13.5708,326.1138},
    {2008.2534,-1270.8082,23.9844,193.7606},
    {2056.4434,-1270.0840,23.9844,207.7770},
    {2057.5437,-1176.5653,23.8382,91.7381},
    {2052.6719,-1145.0350,24.0161,180.4331},
    {1946.7863,-1145.0089,25.6548,186.6371},
    {2080.7983,-1109.4036,24.7771,277.6300},
    {2108.9585,-1096.3185,25.2148,45.8473},
    {2183.9158,-1131.3662,24.8033,260.6265},
    {2209.1370,-1110.4751,25.7969,272.1154},
    {2280.6086,-1168.9926,26.3412,302.9060},
    {2280.6973,-1281.3232,23.9977,265.2223},
    {2280.5520,-1338.6416,23.9919,257.6396},
    {2261.8374,-1329.2583,23.9826,97.3185},
    {2261.4690,-1291.4675,23.9815,43.7798},
    {2157.6411,-1291.3696,23.9766,52.2817},
    {2157.6792,-1335.2476,23.9922,87.6678},
    {2187.8962,-1393.4796,23.9844,193.5961},
    {2362.4341,-1346.7839,24.0078,117.3092},
    {2385.2202,-1374.8417,24.0148,331.6287},
    {2399.5249,-1409.6692,24.0000,305.2039},
    {2382.7346,-1444.5957,24.0054,222.9428},
    {2420.2119,-1535.6107,24.0000,341.9037},
    {2787.3440,-1370.7371,22.7263,117.8683},
    {2815.5625,-1396.5242,19.5618,188.1809},
    {2862.2935,-1376.4397,11.0930,59.1098},
    {2723.7666,-2014.6671,13.5472,272.4451},
    {2778.7815,-1939.9031,13.5394,282.8504},
    {2422.8826,-2109.2026,13.5538,274.8082},
    {2404.7192,-2020.3781,13.5469,99.3214},
    {2423.3223,-2000.1929,13.5469,317.3825},
    {2495.0559,-2019.1989,13.5469,206.1689},
    {2422.7075,-1948.2294,13.5469,278.2544},
    {2433.5234,-1923.1920,13.5469,21.8852},
    {2472.0325,-1941.7319,13.5469,246.7745},
    {2403.1482,-1742.4711,13.5469,350.0111},
    {2331.2195,-1741.4590,13.5469,186.4729},
    {2294.2810,-1761.6997,13.5469,36.4266},
    {2295.9551,-1741.2864,13.5469,168.5501},
    {2209.4875,-1723.0153,13.4333,52.5112},
    {2492.4004,-1647.8435,13.5313,112.4837},
    {2469.4089,-1684.9156,13.5078,76.4083},
    {2161.7192,-1622.8204,14.0829,24.0187},
    {2087.3499,-1591.6941,13.4888,82.3828},
    {2072.6565,-1642.6274,13.5469,88.8166},
    {2090.7256,-1677.4569,13.5469,269.6534},
    {2099.0115,-1691.5360,13.5469,80.3146},
    {2091.1233,-1717.0752,13.5476,287.8059},
    {2088.2764,-1741.7594,13.5562,143.2744},
    {2071.7446,-1878.5155,13.5469,196.3537},
    {2138.2195,-1903.9139,13.5469,245.9862},
    {2191.9766,-1885.9457,13.5469,343.1831},
    {2288.9932,-1885.2069,13.5817,44.9939},
    {2290.5085,-1904.5402,13.5469,228.3583},
    {1922.0422,-2061.9038,13.5469,149.8386},
    {1892.9420,-2042.8845,13.5469,303.4962},
    {1873.0692,-2042.7837,13.5469,111.2356},
    {1814.0085,-2046.9546,13.5469,85.9598},
    {1832.1342,-2080.1284,13.5469,275.9877},
    {1693.0526,-2103.4866,13.5469,13.1194},
    {1788.1049,-2122.9971,13.5469,264.8932},
    {1952.7659,-1862.8896,13.5469,88.8817},
    {1844.4825,-1923.1825,13.5469,7.3098},
    {1915.1614,-1923.3505,13.5469,349.6169}
};

enum stairData {
    numberWorked,

    stairId,
    EvehicleId,

    stairObject,
    stairObject2,

    Float: stairX,
    Float: stairY,
    Float: stairZ,

    bool: stairRepair,
    bool: stairLifting,
    bool: stairPutaway,

    numberComplete
};

new stair[MAX_PLAYERS][stairData];

new timerRepair[MAX_PLAYERS];

forward onPlayerStartRepair(playerid);
public onPlayerStartRepair(playerid) {
 

    if (!IsPlayerInAnyVehicle(playerid)) {
        if (!IsPlayerInRangeOfPoint(playerid, 4.0, 1768.8634, -1704.5259, 13.4995))
            return SendErrorMessage(playerid, "Ban khong o gan diem bat dau sua chua hoac khong o tren phuong tien sua chua.");
    } else {
        if (GetPlayerVehicleID(playerid) != stair[playerid][EvehicleId])
            return SendErrorMessage(playerid, "Ban khong o tren phuong tien sua chua cua ban.");
    }    

    if (stair[playerid][numberComplete] >= 5)
        return SendErrorMessage(playerid, "Ban da hoan thanh mot so chuyen sua chua, hay bao cao voi cong ty truoc. (/baocaosuachua)");

    if (!stair[playerid][stairRepair]) {
        PlayerInfo[playerid][pModel] = GetPlayerSkin(playerid);

        SetPlayerSkin(playerid, 8);

        stair[playerid][EvehicleId] = CreateVehicle(552, 1782.4268, -1701.9174, 13.2005, 0, 1, 1, -1);
        PutPlayerInVehicle(playerid, stair[playerid][EvehicleId], 0);

        stair[playerid][stairRepair] = true;
    }

    stair[playerid][stairId] = random(sizeof(electricPost));
    
    new electricId = stair[playerid][stairId];
    
    SetPlayerCheckpoint(playerid, electricPost[electricId][0], electricPost[electricId][1], electricPost[electricId][2], 1.0);
    SendClientMessage(playerid, COLOR_OOC, "Ban da bat dau sua chua, hay di den dia diem duoc danh dau tren ban do.");
    return true;
}

forward onPlayerRepair(playerid);
public onPlayerRepair(playerid) {
    new electricId = stair[playerid][stairId];

    SetPlayerPos(playerid, electricPost[electricId][0], electricPost[electricId][1], electricPost[electricId][2]);
    SetPlayerFacingAngle(playerid, electricPost[electricId][3]);

    TogglePlayerControllable(playerid, false);

    stair[playerid][stairX] = electricPost[electricId][0];
    stair[playerid][stairY] = electricPost[electricId][1];
    stair[playerid][stairZ] = electricPost[electricId][2];

    stair[playerid][stairLifting] = true;
    stair[playerid][stairPutaway] = false;
    stair[playerid][stairObject] = CreateDynamicObject(1437, electricPost[electricId][0], electricPost[electricId][1], electricPost[electricId][2]-5, 10.0, 0.0, electricPost[electricId][3]);
    stair[playerid][stairObject2] = CreateDynamicObject(1437, electricPost[electricId][0], electricPost[electricId][1], electricPost[electricId][2]-5, 10.0, 0.0, electricPost[electricId][3]);

    MoveDynamicObject(stair[playerid][stairObject], electricPost[electricId][0], electricPost[electricId][1], electricPost[electricId][2]+0.1, 2.0, 10.0, 0.0, electricPost[electricId][3]);
    return true;
}

forward onPlayerRepairFinish(playerid);
public onPlayerRepairFinish(playerid) {
    if (stair[playerid][stairLifting]) {
        KillTimer(timerRepair[playerid]);
        timerRepair[playerid] = -1;

        stair[playerid][stairPutaway] = true;

        new electricId = stair[playerid][stairId];
        MoveDynamicObject(stair[playerid][stairObject2], electricPost[electricId][0], electricPost[electricId][1], electricPost[electricId][2]-(6+5), 2.0, 10.0, 0.0, electricPost[electricId][3]);
        
        SetPlayerPos(playerid, electricPost[electricId][0], electricPost[electricId][1], electricPost[electricId][2]);
        TogglePlayerControllable(playerid, true);
        stair[playerid][stairLifting] = false;
        
        if (stair[playerid][numberComplete] < 5) stair[playerid][numberComplete]++;
    }
    return true;
}

new actorElectrical,
    Text3D: textElectrical;

hook OnGameModeInit() {
    actorElectrical = CreateActor(8, 1768.8634, -1704.5259, 13.4995, 353.1965);
    textElectrical = CreateDynamic3DTextLabel("<Cong viec Tho sua dien>\nBam 'Y' de tuong tac", COLOR_BASIC, 1768.8634, -1704.5259, 13.4995, 10.0);
}

hook OnGameModeExit() {
    DestroyActor(actorElectrical);
    DestroyDynamic3DTextLabel(textElectrical);
}

stock E_OnDynamicObjectMoved(objectid) {
    foreach (new playerid : Player) {
        if (objectid == stair[playerid][stairObject]) {
            if (stair[playerid][stairLifting]) {
                new electricId = stair[playerid][stairId];
                MoveDynamicObject(stair[playerid][stairObject2], electricPost[electricId][0], electricPost[electricId][1], electricPost[electricId][2]+6, 2.0, 10.0, 0.0, electricPost[electricId][3]);

                // task_await task_ms(2000);
                ShowNotifyTextMain(playerid,"~r~Dang sua chua...");
                SetPlayerPos(playerid, electricPost[electricId][0], electricPost[electricId][1], electricPost[electricId][2]+8);
                timerRepair[playerid] = SetTimerEx("onPlayerRepairFinish", 10000, false, "i", playerid);
            }
        } else if (objectid == stair[playerid][stairObject2]) {
            if (stair[playerid][stairPutaway]) {
                
                new electricId = stair[playerid][stairId];
                SetPlayerPos(playerid, electricPost[electricId][0], electricPost[electricId][1], electricPost[electricId][2]+1.2);
                MoveDynamicObject(stair[playerid][stairObject], electricPost[electricId][0], electricPost[electricId][1], electricPost[electricId][2]-(0.1+5), 2.0, 10.0, 0.0, electricPost[electricId][3]);

                // task_await task_ms(2000);

                DestroyDynamicObject(stair[playerid][stairObject2]);
                DestroyDynamicObject(stair[playerid][stairObject]);

                stair[playerid][stairPutaway] = false;
                stair[playerid][stairId] = -1;

                stair[playerid][stairX] = 0.0;
                stair[playerid][stairY] = 0.0;
                stair[playerid][stairZ] = 0.0;

                if (stair[playerid][numberComplete] < 5) SendClientMessage(playerid, COLOR_YELLOW, sprintf("Sua chua hoan tat, hay tiep tuc cong viec (/suachua). (So lan da sua chua %d)", stair[playerid][numberComplete]));
                else SendClientMessage(playerid, COLOR_YELLOW, "Ban da hoan tat chuyen sua chua nay, hay quay tro lai tru so de bao cao cong viec va nhan tien. (/baocaosuachua)");
            }
        }
    }
}
stock VehicleRentPlayerSD(vehicleid ) {
    foreach(new i : Player) {
        if(stair[i][EvehicleId] == vehicleid) return i;
    }
    return 2005;
}
hook OnVehicleDeath(vehicleid, killerid) {
    new playerid = VehicleRentPlayerSD(vehicleid);
    if(playerid == 2005) return 1;
    if(vehicleid == stair[playerid][EvehicleId] && PlayerInfo[playerid][pJob] == 25) {
        if (IsValidVehicleID(stair[playerid][EvehicleId])) DestroyVehicle(stair[playerid][EvehicleId]);
        stair[playerid][EvehicleId] = INVALID_VEHICLE_ID;
        stair[playerid][numberComplete] = 0;
    }
    return 1;
}
hook OnPlayerConnect(playerid){
    DestroyVehicle(stair[playerid][EvehicleId]);
    stair[playerid][EvehicleId] = INVALID_VEHICLE_ID;
    stair[playerid][numberComplete] = 0;
     stair[playerid][stairRepair] = false;
}
hook OnPlayerDisconnect(playerid, reason) {
    DestroyVehicle(stair[playerid][EvehicleId]);
    stair[playerid][EvehicleId] = INVALID_VEHICLE_ID;
    stair[playerid][numberComplete] = 0;
     stair[playerid][stairRepair] = false;
}
hook OnPlayerEnterCheckpoint(playerid) {
    if (stair[playerid][stairRepair]) {
        if (IsPlayerInAnyVehicle(playerid))
            return SendErrorMessage(playerid, "Ban khong the bat dau sua chua khi dang o tren phuong tien.");

       
        
        new Float:x, Float:y, Float:z;
        GetPlayerPos(playerid, x, y, z);

        new vehicleid = stair[playerid][EvehicleId];
        new Float:vx, Float:vy, Float:vz;
        GetVehiclePos(vehicleid, vx, vy, vz);
        
        new Float: dist = GetDistanceBetweenPoints(x, y, z, vx, vy, vz);
        if (dist > 15.0) return SendErrorMessage(playerid, "Phuong tien sua chua cua ban khong o gan ban, vi the khong co dung cu de sua chua.");

        onPlayerRepair(playerid);
        DisablePlayerCheckpoint(playerid);
    }
    return 1;
}

CMD:suachua(playerid) {
    if(PlayerInfo[playerid][pJob] != 25) return SendErrorMessage(playerid,"Ban khong phai tho sua dien");
    onPlayerStartRepair(playerid);
    return true;
}

CMD:baocaosuachua(playerid) {
    if (!IsPlayerInRangeOfPoint(playerid, 4.0, 1768.8634, -1704.5259, 13.4995))
        return SendErrorMessage(playerid, "Ban khong o gan diem bat dau sua chua.");

    if (stair[playerid][numberComplete] < 1)
        return SendErrorMessage(playerid, "Ban chua sua chua bat ky diem nao de co the bao cao cong viec.");

    if (IsValidVehicleID(stair[playerid][EvehicleId])) DestroyVehicle(stair[playerid][EvehicleId]);
    SetPlayerSkin(playerid, PlayerInfo[playerid][pModel]);
    stair[playerid][EvehicleId] = INVALID_VEHICLE_ID;
    stair[playerid][stairRepair] = false;
    new total = 0;
    new number = stair[playerid][numberComplete];
    for (new i = 0; i < number; i++) {
        new price = 15 + random(20);
        GivePlayerMoneyEx(playerid, price);
        total += price;
        SendClientMessage(playerid, COLOR_OOC, sprintf("Ban nhan duoc $%d tu chuyen sua chua thu %d.", price, i));
    }
    PlayerInfo[playerid][pCountElec]++;

    new string_log[229];
    format(string_log, sizeof(string_log), "[%s] %s đã báo cáo công việc sửa điện và nhận được %s", GetLogTime(),GetPlayerNameEx(playerid),number_format(total));         
    SendLogDiscordMSG(job_Electricity, string_log);

    stair[playerid][numberComplete] = 0;
    stair[playerid][numberWorked]++;
    // PlayerMySQL_Integer(playerid, "character", "pElectricalTimes", stair[playerid][numberWorked]);
    return true;
}
hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if(newkeys & KEY_YES) {
        if(IsPlayerInRangeOfPoint(playerid, 5,1768.8634, -1704.5259, 13.4995)) {
            Dialog_Show(playerid,JOB_SUADIEN, DIALOG_STYLE_LIST,"Tho dien","Xin viec\nNghi viec (hien tai)\nThue xe & bat dau lam viec\nTra xe & bao cao sua dien","Chon","Thoat");
        }
    }
}
Dialog:JOB_SUADIEN(playerid, response, listitem, inputtext[]) {
    if(response) {
        if(listitem == 0) {
            if(PlayerInfo[playerid][pJob] != 0) return SendErrorMessage(playerid, "Ban dang nhan mot cong viec khac .");
            PlayerInfo[playerid][pJob] = 25;
            SendClientMessage(playerid, COLOR_BASIC, "[SUADIEN-JOB] Ban da nhan viec {46ad58}thanh cong{b4b4b4}, su dung /trogiup > cong viec > Tho sua dien.");
        }
        if(listitem == 1) {
            ShowQuitJob(playerid);
        }
        if(listitem == 2) {
            cmd_suachua(playerid);
        }
        if(listitem == 3) {
            cmd_baocaosuachua(playerid);
        }

    }
    return 1;
}