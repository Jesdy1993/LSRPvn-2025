#include <YSI\y_hooks>
enum DealerWeaponr {
    dealwp_set[20], // don hang
    dealwp_in_vehicle[20], // cac don hang dc lay, va tai len xe.
    dealwp_obj[20], // 20 object box
    Text3D:dealwp_text[20],
    dealwp_temp,
    dealwp_vehicle,
    dealwp_timer,
    dealtoalprice
}
new DealerWeapon[MAX_FAMILY][DealerWeaponr];
new bool:opendeal = false;
new WeaponDealName[][] = {
    {"Trong"},
    {"{3cad49}Colt-45 new full box{cdc3c3}"},
    {"{3cad49}Silenced 9mm new full box{cdc3c3}"},
    {"{e72525}Desert Eagle new full box{cdc3c3}"},
    {"{e72525}Shotgun new full box{cdc3c3}"},
    {"{e72525}MP5 new full box (20 bullets){cdc3c3}"},
    {"{3cad49}Pistol Ammo Box (20 bullets){cdc3c3}"},
    {"{e72525}Shotgun Ammo Box (20 bullets){cdc3c3}"},
    {"{e72525}MP Ammo Box (20 bullets){cdc3c3}"}
};
new WeaponDealPrice[] = {
    0,
    6000,
    7000,
    15000,
    9000,
    13000,
    1200,
    1400,
    1500
};
new PlayerHandWPBox[MAX_PLAYERS] = -1;
CMD:rsdealeradmin(playerid,params[]) {

    RestartDealer(strval(params));
    return 1;
} 
CMD:opendeal(playerid) {
    if(PlayerInfo[playerid][pAdmin] < 2) return 1;
    if(opendeal == true) {
        opendeal = false;
    }
    else if(opendeal == false) {
        opendeal = true;
    }
    return 1;
}
CMD:thiencuozg(playerid,params) {
    new fDealer = PlayerInfo[playerid][pFMember];
    if(DealerWeapon[fDealer][dealwp_temp] != 0) return SendErrorMessage(playerid, " Ban da daat hang roi.");
    if(opendeal == true) {
        ShowWeaponDeal(playerid);
    }
    else SendErrorMessage(playerid, " Chua the deal weapon vao luc nay.");
    
    return 1;
}
CMD:testbed(playerid,params) {
    new fDealer = PlayerInfo[playerid][pFMember];
    for(new i = 0 ; i < 20; i++) {
        new Float:Pos[3];
        GetDynamicObjectPos(DealerWeapon[fDealer][dealwp_obj][i], Pos[0],Pos[1],Pos[2]);
        printf("%d %d  %d- %f %f %f.",i, DealerWeapon[fDealer][dealwp_set][i],DealerWeapon[fDealer][dealwp_in_vehicle][i], Pos[0],Pos[1],Pos[2]);

    }
    return 1;
}
stock CountDeal(playerid) {
    new fDealer = PlayerInfo[playerid][pFMember];
    new count = 0;
    for(new i = 0 ; i < 20; i++) 
    {
        if(DealerWeapon[fDealer][dealwp_set][i] != 0)
        {
            count++;
        }
    }
    return count;
}
stock CountAmmoItem(playerid) {
    new fDealer = PlayerInfo[playerid][pFMember];
    new count = -1;
    for(new i = 0 ; i < 20; i++) 
    {
        if(DealerWeapon[fDealer][dealwp_set][i] >= 5 && DealerWeapon[fDealer][dealwp_set][i] <= 5)
        {
            count++;
        }
    }
    return count;
}
stock CountGunItem(playerid) {
    new fDealer = PlayerInfo[playerid][pFMember];
    new count = -1;
    for(new i = 0 ; i < 20; i++) 
    {
        if(DealerWeapon[fDealer][dealwp_set][i] >= 1 && DealerWeapon[fDealer][dealwp_set][i] <= 4)
        {
            count++;
        }
    }
    return count;
}
stock ShowWeaponDeal(playerid) 
{
    new fDealer = PlayerInfo[playerid][pFMember];
    new string[3229]; 
    string = "#\t#\t#\n";
    for(new i = 0 ; i < 20; i++) 
    {
        if(DealerWeapon[fDealer][dealwp_set][i] != 0)
        {
            format(string, sizeof string, "{b4b4b4}%s#%s\t#\t$%s\n",string,
                WeaponDealName[DealerWeapon[fDealer][dealwp_set][i]],number_format(WeaponDealPrice[DealerWeapon[fDealer][dealwp_set][i]]) );
        }
    
    }
    DealerWeapon[fDealer][dealtoalprice] = 0;
    for(new i = 0 ; i < CountDeal(playerid); i++) {
        new weapon = DealerWeapon[fDealer][dealwp_set][i];
        DealerWeapon[fDealer][dealtoalprice] += WeaponDealPrice[weapon];
    }
    if(CountDeal(playerid) < 20) format(string, sizeof(string),"%s#\t+\t{3cad49}Them don hang{b4b4b4}\nTotal: $%s\t#>\t{fcf181}BAT DAU DON HANG\n",string,number_format(DealerWeapon[fDealer][dealtoalprice])); 
    else if(CountDeal(playerid) >= 20) format(string, sizeof(string),"%s#\t+\t{e72525}KHONG THE THEM DON HANG (20/20){b4b4b4}\n#Total: $%s\t#>\t{fcf181}BAT DAU DON HANG",string,number_format(DealerWeapon[fDealer][dealtoalprice]));
   
    Dialog_Show(playerid,DIALOG_DEALWP,DIALOG_STYLE_TABLIST_HEADERS, "Weapon Dealer # Called Menu",string, "Xac nhan","Thoat");
}
stock OpenBoxWeapon(playerid,boxid) {
    new fDealer = PlayerInfo[playerid][pFMember];
    new Float:x,Float:y,Float:z;
    GetDynamicObjectPos(DealerWeapon[fDealer][dealwp_obj][boxid],x,y,z);
    if(!IsPlayerInRangeOfPoint(playerid, 5, x,y,z)) return SendErrorMessage(playerid, " Ban khong o gan thung hang do.");

    PlayAnimEx(playerid,"BOMBER","BOM_Plant_Crouch_In", 4.0, 0, 0, 0, 0, 0, 1);
    DestroyDynamicObject(DealerWeapon[fDealer][dealwp_obj][boxid]);
    DestroyDynamic3DTextLabel(DealerWeapon[fDealer][dealwp_text][boxid]);
    DealerWeapon[fDealer][dealwp_obj][boxid] = INVALID_OBJECT_ID;

   
    new itemid,amount;
    switch( DealerWeapon[fDealer][dealwp_set][boxid] ) {
        case 1: {
            itemid = 21;
            amount = 1;

        }
        case 2: {
            itemid = 22;
            amount = 1;

        }
        case 3: {
            itemid = 23;
            amount = 1;
        } 
        case 4: {
            itemid = 24;
            amount = 1;

        } 
        case 5: {
            itemid = 27;
            amount = 1;

        } 
        case 6: {
            itemid = 30;
            amount = 20;

        } 
        case 7: {
            itemid = 31;
            amount = 20;
        } 
    }
    if(CheckInventorySlotEmpty(playerid,9,1) == -1) return SendErrorMessage(playerid," Tui do cua ban da day khong the nhan vat pham.");
    Inventory_@Add(playerid,itemid,amount);
    new string[129];
    format(string,sizeof(string),"[{ebf0a5}WEAPON-DEALER{cdc3c3}] Ban da nhan duoc {ebf0a5}%d %s{cdc3c3} tu thung hang.",amount,ItemInfo[itemid][ItemName]);
    SendClientMessageEx(playerid,COLOR_WHITE2,string);
    return 1;

}
CMD:dlbox(playerid,params[]) {
    new choice[32],boxid;
    if(PlayerInfo[playerid][pFMember] == INVALID_FAMILY_ID) return SendErrorMessage(playerid, " Ban khong phai thanh vien bang dang hoac to chuc.");
    new fDealer = PlayerInfo[playerid][pFMember],string[129];
    new Float:x,Float:y,Float:z;
    if(sscanf(params, "s[32]", choice))
    {
        SendClientMessageEx(playerid, COLOR_CHAT, " /dlbox [tuy chon]");
        SendClientMessageEx(playerid, COLOR_CHAT, "[OPTION] drop, pickup, vcheck, open.");
        return 1;
    }
    if(strcmp(choice,"open",true) == 0) {

        new v = PlayerInfo[playerid][pFMember];
        if(!IsPlayerInRangeOfPoint(playerid, 3.0, FamilyInfo[v][FamilySafe][0], FamilyInfo[v][FamilySafe][1], FamilyInfo[v][FamilySafe][2]) && GetPlayerVirtualWorld(playerid) == FamilyInfo[v][FamilySafeVW] && GetPlayerInterior(playerid) == FamilyInfo[v][FamilySafeInt]) return SendErrorMessage(playerid, " Ban khong o gan ket sat.");
        Dialog_Show(playerid, UNBOX_WP, DIALOG_STYLE_INPUT, "#Unbox select", "Vui long nhap ID thung sung ban muon mo:", "Unbox","Thoat");

    }
    if(strcmp(choice,"drop",true) == 0) {
        if(PlayerHandWPBox[playerid] == -1) return SendErrorMessage(playerid, " Ban khong cam thung hang tren tay.");
        new box_slot ;


        box_slot = PlayerHandWPBox[playerid] ;

        GetPlayerPos(playerid,x,y,z);
        PlayAnimEx(playerid, "CARRY", "putdwn105", 4.1, 0, 0, 0, 0, 0,1);
        SetPlayerSpecialAction(playerid,SPECIAL_ACTION_NONE);
        PlayerHandWPBox[playerid] = -1;
        RemovePlayerAttachedObject(playerid, 9);
        new str[10];
        format(str,sizeof str,"#%d",box_slot);
        DealerWeapon[fDealer][dealwp_text][box_slot] = CreateDynamic3DTextLabel(str, COLOR_WHITE2, x,y,z-0.75, 10);
        DealerWeapon[fDealer][dealwp_obj][box_slot] = CreateDynamicObject(3013, x,y,z-0.75, 0.0,0.0,0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
    }
    else if(strcmp(choice,"pickup",true) == 0) {
        if(PlayerHandWPBox[playerid] != -1) return SendErrorMessage(playerid, " Ban dang cam 1 thung hang, khong the tiep tuc cam them.");

        for(new i =  0 ; i < 20; i++) {
            if(IsValidDynamicObject(DealerWeapon[fDealer][dealwp_obj][i]) &&  DealerWeapon[fDealer][dealwp_set][i] != 100)  {
                GetDynamicObjectPos(DealerWeapon[fDealer][dealwp_obj][i],x,y,z);
                if(IsPlayerInRangeOfPoint(playerid, 3, x,y,z)) {

                    DestroyDynamicObject(DealerWeapon[fDealer][dealwp_obj][i]);
                    DestroyDynamic3DTextLabel(DealerWeapon[fDealer][dealwp_text][i]);
                    DealerWeapon[fDealer][dealwp_obj][i] = INVALID_OBJECT_ID;

                    PlayerHandWPBox[playerid] = i;

    
                    SetPlayerAttachedObject(playerid, 9, 3013, 5, 0.219000, 0.000000, 0.145000, -82.599922, 0.000000, 102.000038, 1.000000, 1.000000, 1.000000);
                    SetPlayerSpecialAction(playerid,SPECIAL_ACTION_CARRY);
                    PlayAnimEx(playerid, "CARRY", "liftup105", 4.1, 0, 0, 0, 0, 0,1);   
    
                    format(string,sizeof(string),"## {ebf0a5}WEAPON BOX{cdc3c3} ## Ban dang cam thung hang {ebf0a5}%s{cdc3c3}, hay dat no len xe.", WeaponDealName[DealerWeapon[fDealer][dealwp_set][i]]);
                    SendClientMessageEx(playerid,COLOR_WHITE2,string);  
                    break ;
                }
       
            }

        }
    }
    else if(strcmp(choice,"vcheck",true) == 0) {
        new str[2229]; 
        str = "#\t#\t#\n";
        for(new i = 0 ; i < 20; i++) 
        {
            if(DealerWeapon[fDealer][dealwp_in_vehicle][i] != 0)
            {

                new DL_WP = DealerWeapon[fDealer][dealwp_set][i];
                format(string, sizeof str, "%s#%s\t#\t$%s\n",str,
                    WeaponDealName[DL_WP],number_format(WeaponDealPrice[DL_WP]) );
                printf("%d, %d %s",fDealer,i,str);
            }
        
        }
        Dialog_Show(playerid,DIALOG_BOXINVEH,DIALOG_STYLE_TABLIST_HEADERS, "Weapon Dealer # Box in Vehicle",str, "Xac nhan","Thoat");
        return 1;

    }
    return 1;
}
       
Dialog:UNBOX_WP(playerid , response, listitem, inputtext[])
{
    if(response) {
        if(isnull(inputtext)) return  Dialog_Show(playerid, UNBOX_WP, DIALOG_STYLE_MSGBOX, "#Unbox select", "Vui long nhap ID thung sung ban muon mo:", "Unbox","Thoat");
        if(strval(inputtext) < 0 || strval(inputtext) > 19) return SendErrorMessage(playerid, " Thung sung phai tu ID 0-19.");
        OpenBoxWeapon(playerid,strval(inputtext));
    }
    return 1;
}
Dialog:DIALOG_DEALWP(playerid , response, listitem, inputtext[])
{
    new fDealer = PlayerInfo[playerid][pFMember];
    new string[629];
    if(response) 
    {
        SetPVarInt(playerid,#DW_Selection,listitem);
        if(listitem <= 19) {
            if(DealerWeapon[fDealer][dealwp_set][listitem] != 0) {
                DealerWeapon[fDealer][dealwp_set][listitem] = 0;
                ShowWeaponDeal(playerid);
                return 1;
            }
        }
        printf("%d ", CountDeal(playerid)+2);
        if(listitem == CountDeal(playerid)) 
        {
            
            string = "#\t#\t#\n";
            for(new i = 1 ; i < sizeof(WeaponDealName); i++) 
            {
                format(string, sizeof string, "%s#%s\t\t$%s\n",string,
                    WeaponDealName[i], number_format( WeaponDealPrice[i] ));
                Dialog_Show(playerid,DIALOG_ADDWP,DIALOG_STYLE_TABLIST_HEADERS, "Weapon Dealer # Add-to cart",string, "Xac nhan","Thoat");
            }
        } 
        if(listitem == CountDeal(playerid)+1) 
        {
            if(PlayerInfo[playerid][pCash] < DealerWeapon[fDealer][dealtoalprice]) {
                format(string,sizeof(string),"# ERROR # Ban khong co du $%s de dat don hang.",number_format(DealerWeapon[fDealer][dealtoalprice]));
                SendClientMessageEx(playerid,COLOR_WHITE2,string);
                return 1;
            }

            format(string,sizeof(string),"## {ebf0a5}WEAPON DEAL{cdc3c3} ## Ban da dat don hang {ebf0a5}#8512-%d{cdc3c3}, hay den diem lay hang.", fDealer);
            SendClientMessageEx(playerid,COLOR_WHITE2,string);
            GivePlayerMoneyEx(playerid,-DealerWeapon[fDealer][dealtoalprice]);
            StartDealer(playerid);
        } 
    }
    return 1;
}
Dialog:DIALOG_ADDWP(playerid , response, listitem, inputtext[])
{
    new fDealer = PlayerInfo[playerid][pFMember];
    if(response)
    {
        if(listitem == 2 || listitem == 3 || listitem == 4 || listitem == 6 || listitem == 7) return SendErrorMessage(playerid, " Ban khong the dat loai vu khi nay.");
        new dw_slot = GetPVarInt(playerid,#DW_Selection);
        if(DealerWeapon[fDealer][dealwp_set][dw_slot] == 0) 
        {

            DealerWeapon[fDealer][dealwp_set][dw_slot] = listitem + 1;
            ShowWeaponDeal(playerid);
        } 
    }
    return 1;
}
stock CheckDealerFine() {
    for(new i = 0 ; i < MAX_FAMILY; i++) {
        if(DealerWeapon[i][dealwp_temp] != 0) {
            DealerWeapon[i][dealwp_timer] --;
            if(DealerWeapon[i][dealwp_timer] <= 0) {
                RestartDealer(i);
            }

        }
    }
}
hook OnPlayerConnect(playerid) {
    PlayerHandWPBox[playerid] = -1;
}
hook OnPlayerUpdate(playerid) {
    if(PlayerInfo[playerid][pFMember] != INVALID_FAMILY_ID && DealerWeapon[PlayerInfo[playerid][pFMember]][dealwp_temp] != 0) {
        new str[129];
        new fDealer = PlayerInfo[playerid][pFMember];
        format(str,sizeof(str),"~r~Dealer Weapon~w~ thoi gian con lai: ~r~%d giay~w~", DealerWeapon[fDealer][dealwp_timer]);
        PlayerTextDrawSetString(playerid, NotifyTextMain[playerid] , str);
        PlayerTextDrawShow(playerid, NotifyTextMain[playerid]);
    }
}
stock RestartDealer(dealerid) {
    new fDealer = dealerid;
    DealerWeapon[fDealer][dealwp_timer] = 0;
    DealerWeapon[fDealer][dealwp_temp] = 0;
    if(IsValidVehicle(DealerWeapon[fDealer][dealwp_vehicle])) DestroyVehicle(DealerWeapon[fDealer][dealwp_vehicle]);
    for(new i = 0; i < 20 ; i++) {
        DealerWeapon[fDealer][dealwp_set][i] = 0;
        DealerWeapon[fDealer][dealwp_in_vehicle][i] = 0;
        if(IsValidDynamic3DTextLabel( DealerWeapon[fDealer][dealwp_text][i]) ) DestroyDynamic3DTextLabel(DealerWeapon[fDealer][dealwp_text][i]);
        if(IsValidDynamicObject( DealerWeapon[fDealer][dealwp_obj][i]) ) DestroyDynamicObject(DealerWeapon[fDealer][dealwp_obj][i]);
        DealerWeapon[fDealer][dealwp_obj][i] = INVALID_OBJECT_ID;
    }
}
stock StartDealer(playerid) 
{
    new fDealer = PlayerInfo[playerid][pFMember];
    DealerWeapon[fDealer][dealwp_timer] = 60 * 30;
    DealerWeapon[fDealer][dealwp_temp] = 1;
    DealerWeapon[fDealer][dealwp_vehicle] = CreateVehicle(422, 2444.5251,-1965.8644,13.6406,90.5345, 1, 1, -1);
    PutPlayerInVehicle(playerid,  DealerWeapon[fDealer][dealwp_vehicle], 0);
    SendClientMessageEx(playerid,COLOR_WHITE2,"[DEALER] Ban da bat dau lay don hang ### {ebf0a5}WEAPON BACKAGE{cdc3c3} ###.");
    SetPlayerCheckpoint(playerid, -2626.2473,208.2346,4.8125,3);
    return 1;
}
hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if(newkeys & KEY_YES) {
        if( PlayerInfo[playerid][pFMember] == INVALID_FAMILY_ID) return 1; 
        new fDealer = PlayerInfo[playerid][pFMember];
        if( DealerWeapon[fDealer][dealwp_temp] == 2) {
            new Float:x,Float:y,Float:z;
            new string[129];

            GetVehicleBoot(DealerWeapon[fDealer][dealwp_vehicle] , x, y, z);
            printf("%f %f %f", x,y,z);
            if(PlayerHandWPBox[playerid] > -1 && IsPlayerInRangeOfPoint(playerid, 2, x,y,z) ) {    
                new engine,lights,alarm,doors,bonnet,boot,objective;
                GetVehicleParamsEx(DealerWeapon[fDealer][dealwp_vehicle],engine,lights,alarm,doors,bonnet,boot,objective);
                if(boot != VEHICLE_PARAMS_ON) return SendErrorMessage(playerid," Thung xe chua duoc mo khong the chat hang, (/v trunk).");
                new box_slot = PlayerHandWPBox[playerid];

                DealerWeapon[fDealer][dealwp_in_vehicle][box_slot] = 1;
                AttachBoxToVehicle(fDealer,DealerWeapon[fDealer][dealwp_vehicle],box_slot);
             

                format(string,sizeof(string),"## {ebf0a5}WEAPON BOX{cdc3c3} ## Ban da dat thung hang {ebf0a5}%s{cdc3c3} len xe.", WeaponDealName[DealerWeapon[fDealer][dealwp_set][box_slot ]]);
                SendClientMessageEx(playerid,COLOR_WHITE2,string);  
                PlayerHandWPBox[playerid] = -1;
                RemovePlayerAttachedObject(playerid, 9);
                SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
                printf("player hand wp: %d",PlayerHandWPBox[playerid]);
                return 1;
            }
            if(PlayerHandWPBox[playerid] == -1 && IsPlayerInRangeOfPoint(playerid, 2, x,y,z) ) { 
                new engine,lights,alarm,doors,bonnet,boot,objective;
                GetVehicleParamsEx(DealerWeapon[fDealer][dealwp_vehicle],engine,lights,alarm,doors,bonnet,boot,objective);
                if(boot != VEHICLE_PARAMS_ON) return SendErrorMessage(playerid," Thung xe chua duoc mo khong the chat hang, (/v trunk).");
                for(new i = 0; i < 20; i++) {
                    if(DealerWeapon[fDealer][dealwp_in_vehicle][i] != 0) {
                        
                        DestroyDynamicObject(DealerWeapon[fDealer][dealwp_obj][i]);
                        DealerWeapon[fDealer][dealwp_obj][i] = INVALID_OBJECT_ID;

                        PlayerHandWPBox[playerid] = i;
                        DealerWeapon[fDealer][dealwp_in_vehicle][i] = 0;

                        SetPlayerAttachedObject(playerid, 9, 3013, 5, 0.219000, 0.000000, 0.145000, -82.599922, 0.000000, 102.000038, 1.000000, 1.000000, 1.000000);
                        SetPlayerSpecialAction(playerid,SPECIAL_ACTION_CARRY);

                        PlayAnimEx(playerid, "CARRY", "liftup105", 4.1, 0, 0, 0, 0, 0,1);   
                        break ;
                    }
                }
                return 1;
            }
            if(PlayerHandWPBox[playerid] == -1) {
                print("step toi day");
                for(new i = 0; i < 20; i++) {
                    if(DealerWeapon[fDealer][dealwp_set][i] != 0) {
                        GetDynamicObjectPos(DealerWeapon[fDealer][dealwp_obj][i],x,y,z);
                        printf("%d %f %f %f",DealerWeapon[fDealer][dealwp_obj][i],x,y,z);
                        if(IsPlayerInRangeOfPoint(playerid, 3, x,y,z) && IsValidDynamicObject(DealerWeapon[fDealer][dealwp_obj][i])) {
        
                            DestroyDynamicObject(DealerWeapon[fDealer][dealwp_obj][i]);
                            DestroyDynamic3DTextLabel(DealerWeapon[fDealer][dealwp_text][i]);
                            DealerWeapon[fDealer][dealwp_obj][i] = INVALID_OBJECT_ID;
    
    
                            PlayerHandWPBox[playerid] = i ;
        
                            SetPlayerAttachedObject(playerid, 9, 3013, 5, 0.219000, 0.000000, 0.145000, -82.599922, 0.000000, 102.000038, 1.000000, 1.000000, 1.000000);
                            SetPlayerSpecialAction(playerid,SPECIAL_ACTION_CARRY);
                            PlayAnimEx(playerid, "CARRY", "liftup105", 4.1, 0, 0, 0, 0, 0,1);   
        
                            format(string,sizeof(string),"## {ebf0a5}WEAPON BOX{cdc3c3} ## Ban dang cam thung hang %s, hay dat no len xe [box id: %d].", WeaponDealName[DealerWeapon[fDealer][dealwp_set][i]],PlayerHandWPBox[playerid]);
                            SendClientMessageEx(playerid,COLOR_WHITE2,string);  
                            break ; 
                        }
                    }     
                    
                }
                return 1;
            }
        }

    }
    return 1;
}
hook OnPlayerEnterCheckpoint(playerid) {
    if(IsPlayerInRangeOfPoint(playerid, 5,-2626.2473,208.2346,4.8125) )
    {
        new fDealer = PlayerInfo[playerid][pFMember];
        SendClientMessageEx(playerid,COLOR_WHITE2, "### {ebf0a5}WEAPON DEAL{cdc3c3} ### hay di vao trong lay hang, chat len xe.");
        DealerWeapon[fDealer][dealwp_temp] = 2;
        for(new i = 0; i < CountDeal(playerid); i++) {
            CreateAmmoBox(fDealer,i);
        }
        DisablePlayerCheckpoint(playerid);
        
    }
}
stock AttachBoxToVehicle(fDealer,vehicleid, i) {
    DealerWeapon[fDealer][dealwp_obj][i] = CreateDynamicObject(3013, 0,0,0, 0.0,0.0,0.0, 0, 0);
    printf("%d %d %d %d",fDealer,vehicleid,i,DealerWeapon[fDealer][dealwp_obj][i]);

    switch(i) {
        case 0:  AttachDynamicObjectToVehicle(DealerWeapon[fDealer][dealwp_obj][i], vehicleid, 0.000000, -0.654999, -0.149999, 0.000000, 0.000000, -7.035000); //Object Model: 3013 | 
        case 1:  AttachDynamicObjectToVehicle(DealerWeapon[fDealer][dealwp_obj][i], vehicleid, -0.394999, -0.654999, -0.149999, 0.000000, 0.000000, 12.060000); //Object Model: 3013 | 
        case 2:  AttachDynamicObjectToVehicle(DealerWeapon[fDealer][dealwp_obj][i], vehicleid, 0.439999, -0.654999, -0.149999, 0.000000, 0.000000, 7.034998); //Object Model: 3013 | 
        case 3:  AttachDynamicObjectToVehicle(DealerWeapon[fDealer][dealwp_obj][i], vehicleid, 0.249999, -0.654999, 0.105000, 0.000000, 0.000000, 7.034998); //Object Model: 3013 | 
        case 4:  AttachDynamicObjectToVehicle(DealerWeapon[fDealer][dealwp_obj][i], vehicleid, -0.164999, -0.654999, 0.105000, 0.000000, 0.000000, -4.020001); //Object Model: 3013 | 
        case 5:  AttachDynamicObjectToVehicle(DealerWeapon[fDealer][dealwp_obj][i], vehicleid, -0.244999, -1.064999, -0.144999, 0.000000, 0.000000, -9.045001); //Object Model: 3013 | 
        case 6:  AttachDynamicObjectToVehicle(DealerWeapon[fDealer][dealwp_obj][i], vehicleid, 0.140000, -1.064999, -0.144999, 0.000000, 0.000000, 6.030000); //Object Model: 3013 | 
        case 7:  AttachDynamicObjectToVehicle(DealerWeapon[fDealer][dealwp_obj][i], vehicleid, -0.035000, -1.064999, 0.110000, 0.000000, 0.000000, 6.030000); //Object Model: 3013 | 
        case 8:  AttachDynamicObjectToVehicle(DealerWeapon[fDealer][dealwp_obj][i], vehicleid, -0.294999, -1.444998, -0.154999, 0.000000, 0.000000, 13.065000); //Object Model: 3013 | 
        case 9:  AttachDynamicObjectToVehicle(DealerWeapon[fDealer][dealwp_obj][i], vehicleid, 0.089999, -1.444998, -0.154999, 0.000000, 0.000000, 1.004999); //Object Model: 3013 | 
        case 10:  AttachDynamicObjectToVehicle(DealerWeapon[fDealer][dealwp_obj][i], vehicleid, -0.080000, -1.444998, 0.100000, 0.000000, 0.000000, 1.004999); //Object Model: 3013 | 
        case 11:  AttachDynamicObjectToVehicle(DealerWeapon[fDealer][dealwp_obj][i], vehicleid, -0.030000, -0.884999, 0.364999, 0.000000, -6.030000, -16.080001); //Object Model: 3013 | 
        case 12:  AttachDynamicObjectToVehicle(DealerWeapon[fDealer][dealwp_obj][i], vehicleid, -0.050000, -1.364998, 0.364999, 0.000000, -6.030000, -60.300018); //Object Model: 3013 | 
        case 13:  AttachDynamicObjectToVehicle(DealerWeapon[fDealer][dealwp_obj][i], vehicleid, -0.035000, -1.084999, 0.589999, 0.000000, -6.030000, -67.335014); //Object Model: 3013 | 
        case 14:  AttachDynamicObjectToVehicle(DealerWeapon[fDealer][dealwp_obj][i], vehicleid, 0.404999, -1.264999, 0.010000, -36.179992, -6.030000, -85.424964); //Object Model: 3013 | 
        case 15:  AttachDynamicObjectToVehicle(DealerWeapon[fDealer][dealwp_obj][i], vehicleid, -0.544999, -0.974999, 0.010000, -36.179992, 16.079999, -241.200393); //Object Model: 3013 | 
        case 16:  AttachDynamicObjectToVehicle(DealerWeapon[fDealer][dealwp_obj][i], vehicleid, -0.564999, -0.594999, 0.010000, -36.179992, 16.079999, -189.945144); //Object Model: 3013 | 
        case 17:  AttachDynamicObjectToVehicle(DealerWeapon[fDealer][dealwp_obj][i], vehicleid, -0.524999, -1.399998, 0.165000, 16.079999, -6.030002, -205.020217); //Object Model: 3013 | 
        case 18:  AttachDynamicObjectToVehicle(DealerWeapon[fDealer][dealwp_obj][i], vehicleid, -0.474999, -1.129999, 0.339999, 16.079999, 19.094997, -266.325500); //Object Model: 3013 | 
        case 19:  AttachDynamicObjectToVehicle(DealerWeapon[fDealer][dealwp_obj][i], vehicleid, 0.614999, -1.129999, 0.249999, 6.030000, -11.055001, -382.906066); //Object Model: 3013 | 
    }
    

}
stock CreateAmmoBox(fDealer,i) {
    switch(i) {

        case 0:DealerWeapon[fDealer][dealwp_obj][0] = CreateDynamicObject(3013, 163.425567, -167.391113, 3000.246093, 0.000000, 0.000000, -26.599996, -1, 5, -1, 300.00, 300.00); 
        case 1:DealerWeapon[fDealer][dealwp_obj][1] = CreateDynamicObject(3013, 164.247116, -169.535186, 3000.215087, 0.000000, 0.000007, -49.499988, -1, 5, -1, 300.00, 300.00); 
        case 2:DealerWeapon[fDealer][dealwp_obj][2] = CreateDynamicObject(3013, 163.874511, -169.853408, 3000.215087, -0.000001, 0.000007, -65.299980, -1, 5, -1, 300.00, 300.00); 
        case 3:DealerWeapon[fDealer][dealwp_obj][3] = CreateDynamicObject(3013, 164.065826, -169.666076, 3000.475341, 0.000003, 0.000006, -22.900001, -1, 5, -1, 300.00, 300.00); 
        case 4:DealerWeapon[fDealer][dealwp_obj][4] = CreateDynamicObject(3013, 164.016510, -167.820053, 3000.215087, 0.000000, 0.000000, 30.500003, -1, 5, -1, 300.00, 300.00); 
        case 5:DealerWeapon[fDealer][dealwp_obj][5] = CreateDynamicObject(3013, 164.016510, -167.820053, 3000.465332, 0.000000, 0.000000, 3.100002, -1, 5, -1, 300.00, 300.00); 
        case 6:DealerWeapon[fDealer][dealwp_obj][6] = CreateDynamicObject(3013, 164.075439, -168.908462, 3000.245117, 0.000000, 0.000000, 3.100002, -1, 5, -1, 300.00, 300.00); 
        case 7:DealerWeapon[fDealer][dealwp_obj][7] = CreateDynamicObject(3013, 164.052703, -168.489059, 3000.245117, 0.000000, 0.000000, 3.100002, -1, 5, -1, 300.00, 300.00); 
        case 8:DealerWeapon[fDealer][dealwp_obj][8] = CreateDynamicObject(3013, 164.069259, -168.937805, 3000.485351, 0.000006, 0.000019, -11.899997, -1, 5, -1, 300.00, 300.00); 
        case 9:DealerWeapon[fDealer][dealwp_obj][9] = CreateDynamicObject(3013, 164.052703, -168.489059, 3000.485351, 0.000006, 0.000019, 33.100002, -1, 5, -1, 300.00, 300.00); 
        case 10:DealerWeapon[fDealer][dealwp_obj][10] = CreateDynamicObject(3013, 164.112594, -168.732360, 3000.725341, 0.000006, 0.000019, 3.100002, -1, 5, -1, 300.00, 300.00); 
        case 11:DealerWeapon[fDealer][dealwp_obj][11] = CreateDynamicObject(3013, 162.655670, -167.391113, 3000.246093, -0.000003, 0.000006, 5.699999, -1, 5, -1, 300.00, 300.00); 
        case 12:DealerWeapon[fDealer][dealwp_obj][12] = CreateDynamicObject(3013, 162.655670, -167.391113, 3000.506347, -0.000000, 0.000007, 25.399995, -1, 5, -1, 300.00, 300.00); 
        case 13:DealerWeapon[fDealer][dealwp_obj][13] = CreateDynamicObject(3013, 162.255676, -168.111160, 3000.246093, -0.000002, 0.000014, -53.500003, -1, 5, -1, 300.00, 300.00);
        case 14:DealerWeapon[fDealer][dealwp_obj][14] = CreateDynamicObject(3013, 163.133010, -168.387496, 3000.245117, 0.000000, 0.000007, 154.399948, -1, 5, -1, 300.00, 300.00); 
        case 15:DealerWeapon[fDealer][dealwp_obj][15] = CreateDynamicObject(3013, 162.951538, -168.766281, 3000.245117, 0.000000, 0.000007, 154.399948, -1, 5, -1, 300.00, 300.00); 
        case 16:DealerWeapon[fDealer][dealwp_obj][16] = CreateDynamicObject(3013, 163.152511, -168.364715, 3000.485351, 0.000004, 0.000027, 139.399948, -1, 5, -1, 300.00, 300.00); 
        case 17:DealerWeapon[fDealer][dealwp_obj][17] = CreateDynamicObject(3013, 162.951538, -168.766281, 3000.485351, 0.000010, 0.000026, -175.600006, -1, 5, -1, 300.00, 300.00);
        case 18:DealerWeapon[fDealer][dealwp_obj][18] = CreateDynamicObject(3013, 162.255676, -168.111160, 3000.506347, 0.000002, 0.000014, -33.800003, -1, 5, -1, 300.00, 300.00); 
        case 19:DealerWeapon[fDealer][dealwp_obj][19] = CreateDynamicObject(3013, 163.425567, -167.391113, 3000.506347, 0.000000, 0.000000, -6.899999, -1, 5, -1, 300.00, 300.00); 
    }
    new str[10];
    format(str,sizeof str,"#%d",i);
    switch(i) {

        case 0:DealerWeapon[fDealer][dealwp_text][0] = CreateDynamic3DTextLabel(str,COLOR_WHITE2, 163.425567, -167.391113, 3000.246093-0.25, 10);
        case 1:DealerWeapon[fDealer][dealwp_text][1] = CreateDynamic3DTextLabel(str,COLOR_WHITE2, 164.247116, -169.535186, 3000.215087-0.25, 10);
        case 2:DealerWeapon[fDealer][dealwp_text][2] = CreateDynamic3DTextLabel(str,COLOR_WHITE2, 163.874511, -169.853408, 3000.215087-0.25, 10);
        case 3:DealerWeapon[fDealer][dealwp_text][3] = CreateDynamic3DTextLabel(str,COLOR_WHITE2, 164.065826, -169.666076, 3000.475341-0.25, 10);
        case 4:DealerWeapon[fDealer][dealwp_text][4] = CreateDynamic3DTextLabel(str,COLOR_WHITE2, 164.016510, -167.820053, 3000.215087-0.25, 10);
        case 5:DealerWeapon[fDealer][dealwp_text][5] = CreateDynamic3DTextLabel(str,COLOR_WHITE2, 164.016510, -167.820053, 3000.465332-0.25, 10);
        case 6:DealerWeapon[fDealer][dealwp_text][6] = CreateDynamic3DTextLabel(str,COLOR_WHITE2, 164.075439, -168.908462, 3000.245117-0.25, 10);
        case 7:DealerWeapon[fDealer][dealwp_text][7] = CreateDynamic3DTextLabel(str,COLOR_WHITE2, 164.052703, -168.489059, 3000.245117-0.25, 10);
        case 8:DealerWeapon[fDealer][dealwp_text][8] = CreateDynamic3DTextLabel(str,COLOR_WHITE2, 164.069259, -168.937805, 3000.485351-0.25, 10);
        case 9:DealerWeapon[fDealer][dealwp_text][9] = CreateDynamic3DTextLabel(str,COLOR_WHITE2, 164.052703, -168.489059, 3000.485351-0.25, 10);
        case 10:DealerWeapon[fDealer][dealwp_text][10] = CreateDynamic3DTextLabel(str,COLOR_WHITE2, 164.112594, -168.732360, 3000.725341-0.25, 10);
        case 11:DealerWeapon[fDealer][dealwp_text][11] = CreateDynamic3DTextLabel(str,COLOR_WHITE2, 162.655670, -167.391113, 3000.246093-0.25, 10);
        case 12:DealerWeapon[fDealer][dealwp_text][12] = CreateDynamic3DTextLabel(str,COLOR_WHITE2, 162.655670, -167.391113, 3000.506347-0.25, 10);
        case 13:DealerWeapon[fDealer][dealwp_text][13] = CreateDynamic3DTextLabel(str,COLOR_WHITE2, 162.255676, -168.111160, 3000.246093-0.25, 10);
        case 14:DealerWeapon[fDealer][dealwp_text][14] = CreateDynamic3DTextLabel(str,COLOR_WHITE2, 163.133010, -168.387496, 3000.245117-0.25, 10);
        case 15:DealerWeapon[fDealer][dealwp_text][15] = CreateDynamic3DTextLabel(str,COLOR_WHITE2, 162.951538, -168.766281, 3000.245117-0.25, 10);
        case 16:DealerWeapon[fDealer][dealwp_text][16] = CreateDynamic3DTextLabel(str,COLOR_WHITE2, 163.152511, -168.364715, 3000.485351-0.25, 10);
        case 17:DealerWeapon[fDealer][dealwp_text][17] = CreateDynamic3DTextLabel(str,COLOR_WHITE2, 162.951538, -168.766281, 3000.485351-0.25, 10);
        case 18:DealerWeapon[fDealer][dealwp_text][18] = CreateDynamic3DTextLabel(str,COLOR_WHITE2, 162.255676, -168.111160, 3000.506347-0.25, 10);
        case 19:DealerWeapon[fDealer][dealwp_text][19] = CreateDynamic3DTextLabel(str,COLOR_WHITE2, 163.425567, -167.391113, 3000.506347-0.25, 10);
    }
}        


hook OnGameModeInit() {
    new tmpobjid, object_world = 5, object_int = 5;
    tmpobjid = CreateDynamicObject(19378, 161.186996, -173.578002, 3000.000000, 0.000000, 90.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14407, "carter_block", "ab_stripped_floor2", 0x00000000);
    tmpobjid = CreateDynamicObject(19377, 165.921005, -183.108001, 2996.138916, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14584, "ab_abbatoir01", "ab_tiles", 0x00000000);
    tmpobjid = CreateDynamicObject(19378, 150.684997, -173.572006, 3000.000000, 0.000000, 90.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14407, "carter_block", "ab_stripped_floor2", 0x00000000);
    tmpobjid = CreateDynamicObject(19378, 150.253997, -174.067001, 3003.523925, 0.000000, 90.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14407, "carter_block", "ab_stripped_floor2", 0x00000000);
    tmpobjid = CreateDynamicObject(19437, 155.401000, -174.453002, 3005.280029, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 4593, "buildblk55", "GB_nastybar03", 0x00000000);
    tmpobjid = CreateDynamicObject(19456, 155.414993, -170.429000, 3002.989990, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 4593, "buildblk55", "GB_nastybar03", 0x00000000);
    tmpobjid = CreateDynamicObject(19456, 150.645996, -178.126998, 3005.280029, 0.000000, 0.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 4593, "buildblk55", "GB_nastybar03", 0x00000000);
    tmpobjid = CreateDynamicObject(19393, 155.369003, -176.526000, 3005.280029, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 4593, "buildblk55", "GB_nastybar03", 0x00000000);
    tmpobjid = CreateDynamicObject(19437, 155.393997, -169.673004, 3005.280029, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 4593, "buildblk55", "GB_nastybar03", 0x00000000);
    tmpobjid = CreateDynamicObject(19456, 155.404006, -170.429000, 3008.108886, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 4593, "buildblk55", "GB_nastybar03", 0x00000000);
    tmpobjid = CreateDynamicObject(19456, 150.496002, -169.203002, 3005.280029, 0.000000, 0.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 4593, "buildblk55", "GB_nastybar03", 0x00000000);
    tmpobjid = CreateDynamicObject(19456, 147.714996, -170.587997, 3005.280029, 0.000000, 0.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 4593, "buildblk55", "GB_nastybar03", 0x00000000);
    tmpobjid = CreateDynamicObject(19377, 165.602005, -180.815002, 3000.459960, -10.000000, 90.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14584, "ab_abbatoir01", "ab_tiles", 0x00000000);
    tmpobjid = CreateDynamicObject(19377, 171.102996, -183.111999, 3001.360107, -0.500000, 90.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14584, "ab_abbatoir01", "ab_tiles", 0x00000000);
    tmpobjid = CreateDynamicObject(19377, 164.041000, -183.169006, 2996.138916, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14584, "ab_abbatoir01", "ab_tiles", 0x00000000);
    tmpobjid = CreateDynamicObject(19377, 158.746994, -183.195007, 3001.360107, -0.500000, 90.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14584, "ab_abbatoir01", "ab_tiles", 0x00000000);
    tmpobjid = CreateDynamicObject(19860, 164.250000, -185.524993, 3002.620117, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "gun_door1", 0x00000000);
    tmpobjid = CreateDynamicObject(19451, 163.339996, -183.141998, 3003.000000, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14584, "ab_abbatoir01", "ab_concFloor", 0x00000000);
    tmpobjid = CreateDynamicObject(19451, 165.085006, -185.638000, 3003.000000, 0.000000, 0.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14584, "ab_abbatoir01", "ab_concFloor", 0x00000000);
    tmpobjid = CreateDynamicObject(19451, 165.548004, -178.235000, 3005.000000, 0.000000, 0.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14584, "ab_abbatoir01", "ab_concFloor", 0x00000000);
    tmpobjid = CreateDynamicObject(19378, 160.981002, -163.985000, 3000.000000, 0.000000, 90.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14407, "carter_block", "ab_stripped_floor2", 0x00000000);
    tmpobjid = CreateDynamicObject(19379, 161.807006, -168.557006, 3008.481933, -20.000000, 90.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 13659, "8bars", "AH_gbarrier", 0x00000000);

    tmpobjid = CreateDynamicObject(1220, 158.822006, -174.399002, 3001.020019, 0.000000, 0.000000, 20.000000, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 9583, "bigshap_sfw", "freight_crate3", 0x00000000);
    tmpobjid = CreateDynamicObject(2684, 165.888000, -177.363998, 3001.802001, 0.000000, 0.000000, -90.000000, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18050, "ammu_2flrprops", "gun_xtra4", 0x00000000);
    tmpobjid = CreateDynamicObject(2684, 165.888000, -177.363998, 3002.261962, 0.000000, 0.000000, -90.000000, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 16093, "a51_ext", "a51_fencsign", 0x00000000);
    tmpobjid = CreateDynamicObject(2684, 165.888000, -177.684005, 3002.422119, 0.000000, 0.000000, -90.000000, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18063, "ab_sfammuitems02", "gun_xtra1", 0x00000000);
    tmpobjid = CreateDynamicObject(2310, 165.604995, -174.309005, 3000.458984, 0.000000, 0.000000, 10.000000, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14794, "ab_vegasgymmain", "bbar_wall3", 0x00000000);
    tmpobjid = CreateDynamicObject(2310, 165.598007, -173.669998, 3000.458984, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14794, "ab_vegasgymmain", "bbar_wall3", 0x00000000);
    tmpobjid = CreateDynamicObject(2048, 161.761993, -178.119003, 3002.398925, 0.000000, 0.000000, 180.000000, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 9494, "chinatownsfe", "chtown_brightcarcafe", 0x00000000);
    tmpobjid = CreateDynamicObject(19398, 164.916000, -178.283004, 3001.780029, 0.000000, 0.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14584, "ab_abbatoir01", "ab_concFloor", 0x00000000);
    tmpobjid = CreateDynamicObject(19451, 166.011001, -183.141006, 3003.000000, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14584, "ab_abbatoir01", "ab_concFloor", 0x00000000);
    tmpobjid = CreateDynamicObject(11737, 164.975997, -178.942993, 3000.215087, -10.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10023, "bigwhitesfe", "bigwhite_6", 0x00000000);
    tmpobjid = CreateDynamicObject(19456, 152.434005, -165.852996, 3005.280029, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 4593, "buildblk55", "GB_nastybar03", 0x00000000);
    tmpobjid = CreateDynamicObject(19456, 151.300994, -173.826004, 3005.280029, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 4593, "buildblk55", "GB_nastybar03", 0x00000000);
    tmpobjid = CreateDynamicObject(19327, 151.402999, -172.585006, 3005.893066, 0.000000, 0.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 13363, "cephotoblockcs_t", "sw_wind23", 0x00000000);
    tmpobjid = CreateDynamicObject(19327, 151.393005, -176.057006, 3005.893066, 0.000000, 0.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 13363, "cephotoblockcs_t", "sw_wind23", 0x00000000);
    tmpobjid = CreateDynamicObject(19617, 153.973999, -169.272003, 3005.861083, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 9494, "chinatownsfe", "chtown_todaydayrestaurant", 0x00000000);
    tmpobjid = CreateDynamicObject(19329, 165.910995, -180.880996, 3003.898925, 0.000000, 0.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 7088, "casinoshops1", "inwindow1shdw64", 0x00000000);
    tmpobjid = CreateDynamicObject(19329, 163.432006, -180.000000, 3003.898925, 0.000000, 0.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 7088, "casinoshops1", "inwindow1shdw64", 0x00000000);
    tmpobjid = CreateDynamicObject(19329, 163.432006, -183.313995, 3003.898925, 0.000000, 0.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 7088, "casinoshops1", "inwindow1shdw64", 0x00000000);
    tmpobjid = CreateDynamicObject(19329, 165.927001, -183.794006, 3003.898925, 0.000000, 0.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 7088, "casinoshops1", "inwindow1shdw64", 0x00000000);
    tmpobjid = CreateDynamicObject(1494, 155.479003, -177.261001, 3003.583984, 0.000000, 0.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14407, "carter_block", "dt_ind_door", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 14407, "carter_block", "dt_ind_door", 0x00000000);
    tmpobjid = CreateDynamicObject(19381, 150.063995, -173.902999, 3006.858886, 0.000000, 90.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 1738, "cjtemp", "CJ_BED_BASE", 0x00000000);
    tmpobjid = CreateDynamicObject(19381, 163.697006, -183.126998, 3004.361083, 0.000000, 90.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 1738, "cjtemp", "CJ_BED_BASE", 0x00000000);
    tmpobjid = CreateDynamicObject(19379, 159.807006, -175.557006, 3008.481933, 20.000000, 90.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 13659, "8bars", "AH_gbarrier", 0x00000000);
    tmpobjid = CreateDynamicObject(19379, 170.294006, -175.557006, 3008.481933, 20.000000, 90.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 13659, "8bars", "AH_gbarrier", 0x00000000);
    tmpobjid = CreateDynamicObject(19379, 151.320007, -168.557006, 3008.481933, -20.000000, 90.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 13659, "8bars", "AH_gbarrier", 0x00000000);
    tmpobjid = CreateDynamicObject(1761, 154.786697, -171.260498, 3003.575927, 0.000000, 0.000000, -86.760002, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 642, "canopy", "wood02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 18901, "matclothes", "hattiger", 0x00000000);
    tmpobjid = CreateDynamicObject(2502, 151.481704, -172.937103, 3003.605224, 0.000000, 0.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 642, "canopy", "wood02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 6000, "con_drivein", "Desrtmetal", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 6000, "con_drivein", "Desrtmetal", 0x00000000);
    tmpobjid = CreateDynamicObject(936, 151.931900, -174.367797, 3004.004882, 0.000000, 0.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3193, "cxref_desert", "drvin_metal", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 642, "canopy", "wood02", 0x00000000);
    tmpobjid = CreateDynamicObject(936, 152.300796, -171.279693, 3004.004882, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3193, "cxref_desert", "drvin_metal", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 642, "canopy", "wood02", 0x00000000);
    tmpobjid = CreateDynamicObject(2660, 151.964599, -170.699707, 3004.965820, 0.000000, 0.000000, -0.059999, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14776, "genintintcarint3", "toolwall1", 0x00000000);
    tmpobjid = CreateDynamicObject(19617, 151.376098, -174.435195, 3005.641113, 0.000000, 0.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 2047, "cj_ammo_posters", "CJ_Coltposter", 0x00000000);
    tmpobjid = CreateDynamicObject(18044, 145.579605, -176.612792, 3005.108642, 0.000000, 0.000000, -0.119998, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 14, 3193, "cxref_desert", "drvin_metal", 0x00000000);
    tmpobjid = CreateDynamicObject(19893, 151.660140, -173.657424, 3004.479003, 0.000000, 0.000000, 62.459968, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 1, 2772, "airp_prop", "cj_TILL2", 0x00000000);
    tmpobjid = CreateDynamicObject(2500, 151.343795, -174.151992, 3004.359130, 0.000000, 0.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "bluemetal", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 16640, "a51", "bluemetal", 0x00000000);
    tmpobjid = CreateDynamicObject(2481, 153.477203, -178.001495, 3004.285156, 0.000000, 90.000000, -180.000000, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10810, "ap_build4e", "airportdanger", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 10810, "ap_build4e", "airportdanger", 0x00000000);
    tmpobjid = CreateDynamicObject(2684, 151.422698, -173.950698, 3005.057861, 0.000000, 0.000000, -270.000000, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 15040, "cuntcuts", "csnewspaper02", 0x00000000);
    tmpobjid = CreateDynamicObject(2684, 151.422698, -173.650695, 3004.958007, 0.000000, 6.000000, -270.000000, object_world, object_int, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 15040, "cuntcuts", "csnewspaper", 0x00000000);
    tmpobjid = CreateDynamicObject(2641, 152.569198, -169.984497, 3005.963867, 0.000000, 95.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00); 

    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    tmpobjid = CreateDynamicObject(19387, 155.457992, -176.524002, 3005.274902, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19430, 155.432998, -174.444000, 3005.280029, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19430, 155.447006, -169.682006, 3005.280029, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19449, 155.417999, -179.677001, 3008.718994, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19449, 172.317001, -166.233993, 3005.280029, 0.000000, 0.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19449, 158.531005, -178.223007, 3005.280029, 0.000000, 0.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19449, 151.531005, -168.888000, 3001.780029, 0.000000, 0.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19449, 161.253005, -164.701004, 3005.280029, 0.000000, 0.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19449, 166.014007, -173.632995, 3005.280029, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19449, 168.134002, -178.223007, 3005.280029, 0.000000, 0.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19449, 151.604003, -168.908996, 3005.280029, 0.000000, 0.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19449, 161.238998, -164.684997, 3001.780029, 0.000000, 0.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19449, 165.979003, -164.125000, 3001.780029, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19449, 158.531005, -178.227996, 3001.780029, 0.000000, 0.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19449, 156.360992, -164.128997, 3001.780029, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19398, 164.916000, -178.223007, 3001.780029, 0.000000, 0.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19449, 155.449005, -170.069000, 3003.000000, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19449, 166.014007, -173.757003, 3001.780029, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19449, 166.016006, -164.018005, 3005.280029, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19449, 155.470001, -173.707992, 3001.780029, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19449, 156.360992, -164.128997, 3005.280029, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19449, 166.033996, -164.037002, 3008.718994, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19449, 166.033996, -173.632995, 3008.718994, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19449, 155.432006, -170.089004, 3008.100097, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(6400, 155.610992, -171.229995, 3002.229980, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(5130, 161.393997, -176.397003, 3000.600097, 0.000000, 0.000000, -45.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19325, 155.490005, -171.684997, 3004.707031, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(14600, 165.182006, -168.901992, 3001.500000, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1220, 158.186004, -168.430999, 3001.020019, 0.000000, 0.000000, 20.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1220, 158.925003, -174.880996, 3000.378906, 0.000000, 0.000000, 20.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1220, 159.447998, -174.106994, 3000.378906, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1220, 158.123001, -174.404998, 3000.378906, 0.000000, 0.000000, 20.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(3632, 165.311004, -169.735000, 3000.548095, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(3632, 164.893997, -170.397003, 3000.548095, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 

    tmpobjid = CreateDynamicObject(914, 163.517974, -164.783996, 3000.772949, 0.000000, 0.000015, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1420, 165.979995, -172.873992, 3005.558105, 90.000000, 0.000000, -90.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(927, 155.548004, -174.311996, 3002.017089, 0.000000, 0.000000, -90.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2649, 163.527969, -165.300994, 3001.600097, 0.000015, -90.000000, 89.999954, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1635, 160.591003, -165.292999, 3004.912109, 0.000000, 0.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2121, 158.576995, -173.641998, 3000.504882, 0.000000, 0.000000, 160.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2653, 165.578002, -166.589004, 3006.278076, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2653, 165.574996, -174.466003, 3006.278076, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2121, 160.143005, -173.554000, 3000.504882, 0.000000, 0.000000, 200.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(3675, 156.078994, -168.401992, 3003.000000, 0.000000, 0.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1409, 164.654998, -171.285003, 3000.124023, 0.000000, 0.000000, 100.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1409, 164.445007, -172.298004, 3000.124023, 0.000000, 0.000000, 70.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1264, 164.138000, -170.576995, 3000.398925, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(933, 159.251007, -171.904006, 2999.593017, -0.039000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19835, 158.940002, -172.154998, 3000.656005, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19835, 159.580001, -172.563003, 3000.656005, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(11743, 158.791000, -171.673004, 3000.575927, 0.000000, 0.000000, 70.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19835, 158.630996, -171.908004, 3000.656005, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19835, 158.630996, -171.908004, 3000.737060, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19835, 158.630996, -171.908004, 3000.815917, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19835, 158.630996, -171.908004, 3000.895996, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19835, 158.630996, -171.908004, 3000.977050, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(11728, 166.026000, -177.725006, 3001.491943, 0.000000, 0.000000, -90.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(11713, 163.692993, -178.111999, 3001.427001, 0.000000, 0.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2686, 165.893005, -177.707992, 3001.982910, 0.000000, 0.000000, -90.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2687, 165.893005, -177.311996, 3001.287109, 0.000000, 0.000000, -90.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2690, 163.703994, -178.037994, 3001.468994, 0.000000, 0.000000, 180.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1808, 165.714004, -174.912002, 3000.080078, 0.000000, 0.000000, -90.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19828, 155.572006, -175.020004, 3001.805908, 0.000000, 0.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19896, 159.360992, -172.552001, 3000.589111, 0.000000, 0.000000, 70.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19914, 159.423004, -173.714996, 3000.780029, 30.000000, 90.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19571, 159.813995, -172.276992, 3000.595947, -90.000000, 0.000000, 70.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19828, 165.923995, -177.100997, 3001.687988, 0.000000, 0.000000, -90.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19622, 165.716995, -175.268005, 3000.780029, 20.000000, 0.000000, 120.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2858, 159.542007, -171.498992, 3000.599121, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(14522, 148.845001, -171.402999, 3001.158935, 0.000000, 0.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(14522, 174.865997, -166.656997, 3001.158935, 0.000000, 0.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(14522, 175.626007, -166.656997, 3001.158935, 0.000000, 0.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(14522, 149.705001, -171.402999, 3001.158935, 0.000000, 0.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19810, 164.895004, -178.388000, 3002.738037, 0.000000, 0.000000, 180.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19825, 165.889007, -174.154998, 3001.917968, 0.000000, 0.000000, -90.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(11727, 164.925994, -178.375000, 3003.270996, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(11711, 165.044006, -185.585006, 3004.103027, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19825, 155.274002, -170.046997, 3005.184082, 0.000000, 0.000000, -90.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1808, 155.156997, -174.893997, 3003.612060, 0.000000, 0.000000, -90.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19996, 155.033004, -175.500000, 3003.592041, 0.000000, 0.000000, -100.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(11737, 154.841995, -176.520004, 3003.604980, 0.000000, 0.000000, 100.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19814, 153.102005, -178.035995, 3004.583984, 0.000000, 0.000000, 180.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2718, 152.559997, -177.977996, 3006.158935, 0.000000, 0.000000, 180.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(927, 152.748992, -178.037002, 3004.720947, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1893, 162.751007, -165.983993, 3007.540039, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1893, 161.675003, -175.787994, 3007.540039, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1893, 158.072006, -176.097000, 3007.540039, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1893, 159.755004, -165.921997, 3007.540039, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(14687, 155.417602, -176.708877, 3005.174316, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2063, 151.681106, -176.705795, 3004.281982, 0.000000, 0.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2040, 151.679595, -171.901504, 3003.705322, 0.000000, 0.000000, -67.800003, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2040, 151.679595, -171.901504, 3003.925292, 0.000000, 0.000000, -100.800018, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2051, 151.853103, -170.711898, 3005.893310, 0.000000, 10.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(346, 151.460601, -172.598693, 3005.484619, 0.000000, 0.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(346, 151.460601, -172.318695, 3005.484619, 0.000000, 0.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(349, 151.406204, -173.329406, 3004.925781, -5.000000, -80.000000, -90.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(349, 151.406204, -173.049392, 3004.925781, -5.000000, -80.000000, -90.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(349, 151.406204, -172.769393, 3004.925781, -5.000000, -80.000000, -90.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(346, 151.460601, -172.598693, 3005.224609, 0.000000, 0.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(346, 151.460601, -172.318695, 3005.224609, 0.000000, 0.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(372, 151.453704, -172.614898, 3005.001708, 0.000000, 0.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2836, 152.956024, -173.211441, 3003.605224, 0.000000, 0.000000, 60.059959, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(935, 154.787841, -177.491363, 3004.174560, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(935, 154.022216, -177.415527, 3004.174560, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(920, 152.578994, -177.753906, 3003.876953, 0.000000, 0.000000, -180.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(18981, 157.569152, -175.313796, 2991.942626, 0.000000, 90.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2074, 151.685699, -174.372406, 3006.541015, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2074, 152.228988, -171.130844, 3006.541015, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2046, 155.169204, -174.166595, 3005.541503, 0.000000, 0.000000, -90.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2102, 151.576995, -171.258697, 3004.467041, 0.000000, 0.000000, 82.980003, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2057, 151.421142, -172.247207, 3004.806640, 0.000000, 0.000000, -18.720020, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(11743, 152.657531, -170.874465, 3004.479492, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1008, 152.247879, -170.947204, 3004.459472, 0.000000, 0.000000, -180.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19624, 151.880615, -175.743942, 3005.167968, -90.000000, 0.000000, -93.239982, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19814, 151.390106, -171.727706, 3004.590576, 0.000000, 0.000000, 90.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19920, 151.609695, -171.101501, 3004.702636, 0.000000, 0.000000, 24.659999, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19627, 152.526290, -171.279174, 3004.499755, 0.000000, 0.000000, -121.740028, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19627, 152.620178, -171.178787, 3004.499755, 0.000000, 0.000000, -83.700057, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19627, 151.964553, -171.575897, 3004.499755, 0.000000, 0.000000, -4.200058, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(18961, 152.983596, -170.887100, 3004.509033, 0.000000, 8.000000, -93.300003, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2036, 152.337005, -171.454498, 3004.499755, 0.000000, 0.000000, -18.299999, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2037, 151.710601, -171.583694, 3004.544677, 0.000000, 0.000000, 64.980003, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19995, 151.871887, -171.706466, 3004.483154, 180.000000, 90.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19995, 152.753997, -171.080505, 3004.523193, 0.000000, 0.000000, -144.600173, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19995, 152.869323, -171.148971, 3004.503173, 90.000000, 0.000000, -144.600204, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(18635, 152.625045, -171.434646, 3004.455810, 90.000000, 0.000000, -290.159790, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19832, 153.109268, -171.252639, 3004.459960, 0.000000, 0.000000, -100.200103, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1654, 152.066406, -170.989898, 3004.707519, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(18644, 152.073822, -171.713363, 3004.500976, 90.000000, 0.000000, -39.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(18644, 152.260360, -171.126068, 3004.500976, 90.000000, 0.000000, 91.800010, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2709, 151.808364, -171.115722, 3004.580810, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2196, 152.161499, -171.520202, 3004.473144, 0.000000, 0.000000, -22.979999, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(365, 152.681625, -171.215744, 3004.624511, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(365, 152.767288, -171.270858, 3004.624511, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(365, 152.682907, -171.300598, 3004.624511, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(346, 152.254043, -171.551681, 3004.462890, 90.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19897, 152.908233, -171.350372, 3004.499511, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(11747, 151.838592, -171.481796, 3004.508544, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(18875, 152.438995, -171.187149, 3004.512207, 0.000000, 0.000000, -18.240110, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19086, 151.690673, -175.044570, 3004.739257, 0.000000, 90.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(18641, 151.606307, -173.964431, 3004.504882, 90.000000, 0.000000, -137.700103, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19835, 153.052200, -171.557098, 3004.543945, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1009, 151.498123, -174.807464, 3004.774658, 0.000000, -20.000000, -275.579895, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2825, 152.018203, -174.971939, 3004.479492, 0.000000, 0.000000, -47.400009, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(18634, 151.782333, -174.434005, 3004.499511, 0.000000, 90.000000, -15.299988, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(18633, 152.213363, -174.777832, 3004.509033, 0.000000, -90.000000, 21.239999, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2044, 152.310943, -174.185958, 3004.514160, 0.000000, 0.000000, -310.199890, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2044, 152.119186, -174.060729, 3004.514160, 0.000000, 0.000000, -306.419830, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(18644, 152.390319, -174.329299, 3004.500976, 90.000000, 0.000000, -212.039993, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19627, 152.318130, -174.621002, 3004.499755, 0.000000, 0.000000, -4.200058, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(18635, 151.860443, -174.291702, 3004.455810, 90.000000, 0.000000, -367.679779, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(365, 151.872985, -174.677078, 3004.624511, 0.000000, 0.000000, -180.719894, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(365, 151.933700, -174.518630, 3004.484619, 90.000000, 0.000000, -377.519805, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2042, 152.179763, -173.688629, 3004.562255, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19995, 152.384674, -173.928802, 3004.483154, 180.000000, 90.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19995, 152.255218, -173.875503, 3004.483154, 180.000000, 90.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1520, 151.998992, -175.166412, 3004.491943, 0.000000, 0.000000, -138.660140, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1666, 152.364715, -174.897277, 3004.526855, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2037, 151.730300, -174.179428, 3004.544677, 0.000000, 0.000000, 64.980003, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19832, 151.642761, -173.160736, 3004.600097, 0.000000, 0.000000, -93.660202, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19832, 151.833877, -172.759902, 3004.600097, 0.000000, 0.000000, -93.660202, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2358, 151.678710, -176.452301, 3005.186523, 0.000000, 0.000000, 91.980003, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2358, 151.727798, -177.333023, 3005.186523, 0.000000, 0.000000, 91.980003, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(3014, 152.287033, -175.667510, 3003.812011, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(18635, 151.822021, -177.677734, 3004.635742, 90.000000, 0.000000, -478.079711, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(18635, 151.858078, -177.468200, 3004.635742, 90.000000, 0.000000, -478.079711, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(18635, 151.894119, -177.258651, 3004.635742, 90.000000, 0.000000, -478.079711, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2040, 151.708129, -175.653350, 3004.305419, 0.000000, 0.000000, -191.639984, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2040, 151.764831, -176.173675, 3004.305419, 0.000000, 0.000000, -130.980026, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2040, 151.778289, -176.683441, 3004.305419, 0.000000, 0.000000, -181.320022, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1778, 152.540802, -177.362197, 3003.612792, 0.000000, 0.000000, -69.959999, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2231, 155.247100, -174.261505, 3003.622802, 0.000000, 0.000000, -69.120002, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1520, 154.901245, -173.936813, 3004.552001, 0.000000, 0.000000, -451.020050, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1520, 154.980300, -174.081542, 3004.552001, 0.000000, 0.000000, -451.020050, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1520, 154.786804, -174.132034, 3004.552001, 0.000000, 0.000000, -451.020050, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2670, 153.413604, -173.878158, 3003.694335, 0.000000, 0.000000, -98.519989, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1748, 151.386703, -172.834197, 3003.711181, 0.000000, 0.000000, 87.959999, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2040, 151.683898, -172.407897, 3003.785400, 0.000000, 0.000000, -185.160003, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2040, 151.683898, -172.407897, 3004.005371, 0.000000, 0.000000, -185.160003, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(11745, 151.665802, -176.769897, 3003.872314, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(11745, 152.426803, -175.676300, 3004.212402, 0.000000, 0.000000, -51.479999, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2958, 152.328292, -174.805130, 3004.559570, 0.000000, -15.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2958, 151.479507, -174.820953, 3004.559570, 0.000000, -15.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1620, 154.479293, -178.034500, 3005.970947, 0.000000, 0.000000, -90.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(18634, 151.768600, -176.784103, 3004.659423, 0.000000, 90.000000, -15.300000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(18634, 151.530014, -176.751327, 3004.659423, 0.000000, 90.000000, -15.300000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(18634, 151.593795, -175.933532, 3004.659423, 0.000000, 90.000000, -15.300000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(18634, 151.773788, -175.990112, 3004.659423, 0.000000, 90.000000, -15.300000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2991, 157.210601, -177.008300, 3000.655273, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2912, 155.929702, -177.690795, 3001.263427, 0.000000, 0.000000, -181.679992, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2912, 156.699005, -177.856887, 3001.623291, -90.000000, 0.000000, -365.580108, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2912, 157.579757, -177.879943, 3001.623291, -90.000000, 0.000000, -354.840026, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2912, 156.458999, -177.856903, 3002.323242, -90.000000, 0.000000, -365.580108, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1421, 158.315994, -175.634704, 3000.769287, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1338, 156.663421, -175.150497, 3000.500000, 0.000000, 0.000000, -23.559999, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1486, 163.786102, -183.837097, 3001.593505, 0.000000, 0.000000, -175.560028, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1486, 163.672225, -183.755584, 3001.593505, 0.000000, 0.000000, -175.560028, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1486, 163.790863, -183.692932, 3001.593505, 0.000000, 0.000000, -175.560028, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1486, 163.693267, -183.623077, 3001.593505, 0.000000, 0.000000, -175.560028, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1486, 163.777206, -183.437194, 3001.473388, 90.000000, 0.000000, -175.559997, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1543, 163.722702, -183.193603, 3001.433593, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1543, 163.546020, -183.104248, 3001.433593, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1543, 163.595932, -183.256271, 3001.433593, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2245, 163.674530, -184.971725, 3001.635498, 0.000000, 0.000000, -67.560012, object_world, object_int, -1, 300.00, 300.00); 

}
