/**
* Actors system (../gm/actors)
*
* @author  Jewking
* @version 0.1
* @since   2021-06-01 
*
* @link     Log link:     https://github.com/Rams25/VCRP_FR/commits/main
* @link     Todo link:    -
* @return   last edits by Jewking (x/x/2021)
*
*/

Dialog:ActorMenu(playerid, response, listitem, inputtext[])
{
    if (!response) {
        DeletePVar(playerid, #Actor);
        return 1;
    }
    
    new id = GetPVarInt(playerid, #Actor);
    //DeletePVar(playerid, #Actor);

    switch(listitem) {
        case 0: {
            static const c_caption[] = "Actor menu | {FF6347}Actor ID:%i";
            new caption[sizeof(c_caption)+4-2];
            format(caption, sizeof(caption), c_caption, id);

            new animation[23] = "None";
            if (ActorsInfo[id][ActorAnimLib] != -1 && ActorsInfo[id][ActorAnimN] != -1) {
                format(animation, sizeof(animation), "%s (%s)", ActorAnimationLib[ActorsInfo[id][ActorAnimLib]], ActorAnimationName[ActorsInfo[id][ActorAnimLib]][ActorsInfo[id][ActorAnimN]]);
            }

            new edits[MAX_PLAYER_NAME+51+16] = "";
            if (ActorsInfo[id][ActorEditedDate]) {
                format(edits, sizeof(edits), "\n\n{FFFFFF}lan edit cuoi cung boi {C7C7C7}%s (%s)", GetNameFromBD(ActorsInfo[id][ActorEditedBy]), to_date(ActorsInfo[id][ActorEditedDate], 3));
            }

            new owner[MAX_PLAYER_NAME];
            switch(ActorsInfo[id][ActorType]) {
                case REGULAR_NPC:   format(owner, MAX_PLAYER_NAME, "%s", GetNameFromBD(ActorsInfo[id][ActorOwner]));
                case POLICE_NPC:    format(owner, MAX_PLAYER_NAME, "%s", Factions[ActorsInfo[id][ActorOwner]][fName]); 
                case BUYER_NPC:     format(owner, MAX_PLAYER_NAME, "%s", BizInfo[ActorsInfo[id][ActorOwner]][bizName]);
                case CASHIER_NPC:   format(owner, MAX_PLAYER_NAME, "%s", BizInfo[ActorsInfo[id][ActorOwner]][bizName]);
                case TAXI_NPC:      format(owner, MAX_PLAYER_NAME, "SERVER");
            }

            static const c_info[] = "{FFFFFF}dbID:{C7C7C7}\t\t%i\n\
                                    {FFFFFF}Loai:{C7C7C7}\t\t%s\n\
                                    {FFFFFF}Trang thai:{C7C7C7}\t\t%s (id %i)\n\n\
                                    {FFFFFF}Ten:{C7C7C7}\t\t%s\n\
                                    {FFFFFF}Skin:{C7C7C7}\t\t%i\n\
                                    {FFFFFF}Animation:{C7C7C7}\t%s\n\
                                    {FFFFFF}Mau:{C7C7C7}\t\t%.0f\n\
                                    {FFFFFF}Invulnerable:{C7C7C7}\t%s\n\n\
                                    {FFFFFF}Chu so huu:{C7C7C7}\t\t%s\n\
                                    {FFFFFF}Tao:{C7C7C7}\t%s%s";
            new info[160+sizeof(c_info)+sizeof(animation)+sizeof(edits)+MAX_ACTOR_TYPE_CHAR+2+MAX_ACTOR_STATUS_CHAR+MAX_PLAYER_NAME*2+41];
            format(info, sizeof(info), c_info, ActorsInfo[id][ActorID], 
                                                actors_type[ActorsInfo[id][ActorType]], 
                                                ActorStatusName[ActorsInfo[id][ActorStatus]], ActorsInfo[id][ActorStatus], 
                                                ActorsInfo[id][ActorName], 
                                                ActorsInfo[id][ActorSkin], 
                                                animation, 
                                                ActorsInfo[id][ActorHealth], 
                                                ActorsInfo[id][ActorInvulnerable] ? "Co" : "Khong", 
                                                owner, 
                                                to_date(ActorsInfo[id][ActorDate]), 
                                                edits
            );

            Dialog_Show (playerid, ActorStats, DIALOG_STYLE_MSGBOX, caption, info, "Quay lai", "");
        }
        case 1: {
            return DisplayActorSettings(playerid, id);
        }
        case 2: {
            static const c_caption[] = "Actor menu | {FF6347}Actor ID:%i";
            new caption[sizeof(c_caption)+4-2];
            format(caption, sizeof(caption), c_caption, id);

            return Dialog_Show (playerid, ActorEditPosition, DIALOG_STYLE_LIST, caption, "Dich chuyen actor truoc mat ban\nActor ve phia ban", "Lua chon", "Quay lai");
        }
        case 3: {
            if (ActorsInfo[id][ActorOwner] != PlayerInfo[playerid][pID] && !CheckAdmin(playerid, HIGH_ADMIN_LEVEL)) {
                DisplayActorMenu(playerid, id);
                SendNotCanUse(playerid);
                return 1;
            }
            return DisplayPermissionsMenu(playerid, id);
        }
        case 4: {
            return DisplayActorMenu(playerid, id);
        }
        case 5: {
            if (ActorsInfo[id][ActorOwner] != PlayerInfo[playerid][pID] && !CheckAdmin(playerid, HIGH_ADMIN_LEVEL)) {
                DisplayActorMenu(playerid, id);
                SendNotCanUse(playerid);
                return 1;
            }
            return ConfirmDialog(playerid, "Confirmation", "{FFFFFF}Ban co chac la muon xoa Actor?", "DeleteActor", id);
        } 
    }

    return 1;
}

Dialog:ActorEditPosition(playerid, response, listitem, inputtext[])
{
    if (!response) {
        DisplayActorMenu(playerid, GetPVarInt(playerid, #Actor));
        
        return 1;
    }

    new id = GetPVarInt(playerid, #Actor);

    switch(listitem)
    {
        case 0: {
            GetXYInFrontOfPlayer(playerid, ActorsInfo[id][actPosX], ActorsInfo[id][actPosY], ActorsInfo[id][actPosZ], 1.0);
            GetPlayerFacingAngle(playerid, ActorsInfo[id][actPosA]);
            
            ActorsInfo[id][ActorVW] = GetPlayerVirtualWorld(playerid);
            ActorsInfo[id][ActorInt] = GetPlayerInterior(playerid);
            ActorsInfo[id][actPosA] -= 180.0;

            RefreshActor(id);
            SendSyntaxMessage(playerid, "Ban da dich chuyen thanh cong Actor.");

            ActorsInfo[id][ActorEditedBy] = PlayerInfo[playerid][pID];
            ActorsInfo[id][ActorEditedDate] = gettime();

            SaveActor(id);
        }
        case 1: {
            GetPlayerFacingAngle(playerid, ActorsInfo[id][actPosA]);
            ActorsInfo[id][actPosA] -= 180.0;

            RefreshActor(id);
            SendSyntaxMessage(playerid, "Ban da dich chuyen thanh cong Actor.");

            ActorsInfo[id][ActorEditedBy] = PlayerInfo[playerid][pID];
            ActorsInfo[id][ActorEditedDate] = gettime();

            SaveActor(id);
        }
    }
    return 1;
}

Dialog:ActorStats(playerid, response, listitem, inputtext[])
{
    DisplayActorMenu(playerid, GetPVarInt(playerid, #Actor));
    
    return 1;
}

Dialog:ActorSettings(playerid, response, listitem, inputtext[])
{
    if (!response) {
        DisplayActorMenu(playerid, GetPVarInt(playerid, #Actor));
        
        return 1;
    }

    new id = GetPVarInt(playerid, #Actor);

    switch(listitem) {
        case 0: {
            if (ActorsInfo[id][ActorType] == POLICE_NPC) {
                SendSyntaxMessage(playerid, "Ban khong the thay doi ten!");
                return DisplayActorMenu(playerid, GetPVarInt(playerid, #Actor));
            }

            static const c_caption[] = "Change Name | {FF6347}Actor ID:%i";
            new caption[sizeof(c_caption)+4-2];
            format(caption, sizeof(caption), c_caption, id);

            Dialog_Show (playerid, ActorNewName, DIALOG_STYLE_INPUT, caption, " Dat ten moi - Khong qua 24 ky tu:", "Thay doi", "Quay lai");
        }
        case 1: {
            static const c_caption[] = "Change Skin | {FF6347}Actor ID:%i";
            new caption[sizeof(c_caption)+4-2];
            format(caption, sizeof(caption), c_caption, id);

            Dialog_Show (playerid, ActorNewSkin, DIALOG_STYLE_INPUT, caption, " Nhap ID cho skin:", "Thay doi", "Quay lai");
        }
        case 2: {
            DisplayLibMenu(playerid, id);
        }
        case 3: {
            ActorsInfo[id][ActorHealth] = 100.0;
            DisplayActorSettings(playerid, id);
            SetDynamicActorHealth(ActorsInfo[id][ActorPed], ActorsInfo[id][ActorHealth]);

            ActorsInfo[id][ActorEditedBy] = PlayerInfo[playerid][pID];
            ActorsInfo[id][ActorEditedDate] = gettime();

            SaveActor(id);
            RefreshActor(id);
        }
        case 4: {
            ActorsInfo[id][ActorInvulnerable] = ActorsInfo[id][ActorInvulnerable] ? false : true;
            DisplayActorSettings(playerid, id);
            SetDynamicActorInvulnerable(ActorsInfo[id][ActorPed], ActorsInfo[id][ActorInvulnerable]);
            
            ActorsInfo[id][ActorEditedBy] = PlayerInfo[playerid][pID];
            ActorsInfo[id][ActorEditedDate] = gettime();

            SaveActor(id);
            RefreshActor(id);
        }
    }

    return 1;
}

Dialog:ActorNewSkin(playerid, response, listitem, inputtext[])
{
    if (!response) {
        DisplayActorMenu(playerid, GetPVarInt(playerid, #Actor));
        
        return 1;
    }

    new id = GetPVarInt(playerid, #Actor);

    if(isnull(inputtext) || strval(inputtext) >= 300 || strval(inputtext) <= 0) {
        static const c_caption[] = "Change Skin | {FF6347}Actor ID:%i";
        new caption[sizeof(c_caption)+4-2];
        format(caption, sizeof(caption), c_caption, id);

        Dialog_Show (playerid, ActorNewSkin, DIALOG_STYLE_INPUT, caption, " Nhap ID Skin:", "Thay doi", "Quay lai");
        return 1;
    }

    ActorsInfo[id][ActorSkin] = strval(inputtext);
    DisplayActorSettings(playerid, id);
    SetActorSkin(ActorsInfo[id][ActorPed], ActorsInfo[id][ActorSkin]);

    ActorsInfo[id][ActorEditedBy] = PlayerInfo[playerid][pID];
    ActorsInfo[id][ActorEditedDate] = gettime();

    SaveActor(id);
    return 1;
}

Dialog:ActorNewName(playerid, response, listitem, inputtext[])
{
    if (!response) {
        DisplayActorMenu(playerid, GetPVarInt(playerid, #Actor));
        
        return 1;
    }

    new id = GetPVarInt(playerid, #Actor);

    if(isnull(inputtext) || strlen(inputtext) >= MAX_PLAYER_NAME) {
        static const c_caption[] = "Change Name | {FF6347}Actor ID:%i";
        new caption[sizeof(c_caption)+4-2];
        format(caption, sizeof(caption), c_caption, id);

        Dialog_Show (playerid, ActorNewName, DIALOG_STYLE_INPUT, caption, " Ten moi - khong qua 24 ky tu:", "Thay doi", "Quay lai");
        return 1;
    }

    format(ActorsInfo[id][ActorName], MAX_PLAYER_NAME, "%s", inputtext);
    SetActorName(ActorsInfo[id][ActorPed], ActorsInfo[id][ActorName], false, COLOR_WHITE, true);
    ToggleActorName(ActorsInfo[id][ActorPed], true);

    DisplayActorSettings(playerid, id);

    ActorsInfo[id][ActorEditedBy] = PlayerInfo[playerid][pID];
    ActorsInfo[id][ActorEditedDate] = gettime();

    SaveActor(id);
    return 1;
}

Dialog:ChoosenAnimLib(playerid, response, listitem, inputtext[])
{
    if (!response) {
        DisplayActorMenu(playerid, GetPVarInt(playerid, #Actor));
        return 1;
    }

    new id = GetPVarInt(playerid, #Actor);
    
    switch(listitem)
    {
        case 0: ClearActorAnim(playerid, id);
        default: DisplayNameMenu(playerid, id, listitem-1);
    }
    return 1;
}

Dialog:ChoosenAnimation(playerid, response, listitem, inputtext[])
{
    if (!response) {
        DisplayLibMenu(playerid, GetPVarInt(playerid, #Actor));
        return 1;
    }

    new id = GetPVarInt(playerid, #Actor),
        lib = GetPVarInt(playerid, #ActorLib);
    
    ActorsInfo[id][ActorAnimLib] = lib;
    ActorsInfo[id][ActorAnimN] = listitem;
    
    ApplyDynamicActorAnimation(ActorsInfo[id][ActorPed], ActorAnimationLib[lib], ActorAnimationName[lib][listitem], 4.1, 1, 0, 0, 0, 0);
    DisplayNameMenu(playerid, id, lib);

    ActorsInfo[id][ActorEditedBy] = PlayerInfo[playerid][pID];
    ActorsInfo[id][ActorEditedDate] = gettime();

    SaveActor(id);
    return 1;
}

Dialog:ActorPermissions(playerid, response, listitem, inputtext[])
{
    if (!response) {
        DisplayActorMenu(playerid, GetPVarInt(playerid, #Actor));
        
        return 1;
    }

    new id = GetPVarInt(playerid, #Actor);

    if (ActorsInfo[id][ActorPermissions][listitem] != -1) {
        DeletePVar(playerid, #Actor);

        new info[MAX_PLAYER_NAME+57], name[MAX_PLAYER_NAME];
        format(name, sizeof(name), "%s", GetNameFromBD(ActorsInfo[id][ActorPermissions][listitem]));
        format(info, sizeof(info), "{FFFFFF}Are you sure you want to remove %s's permissions?", name);

        ConfirmDialog(playerid, "Confirmation", info, "DeletePermission", id, listitem, name);
    } else {
        static const c_caption[] = "Actor persmissions | {FF6347}Actor ID:%i";
        new caption[sizeof(c_caption)+4-2];
        format(caption, sizeof(caption), c_caption, id);
        
        SetPVarInt(playerid, #Actor_PermSel, listitem);
        Dialog_Show (playerid, ActorPermissionsAdd, DIALOG_STYLE_INPUT, caption, " Nhap ten ID Nguoi choi ma ban muon them:", "Them", "Quay lai");        
    }

    return 1;
}

Dialog:ActorPermissionsAdd(playerid, response, listitem, inputtext[])
{
    if (!response) {
        DisplayPermissionsMenu(playerid, GetPVarInt(playerid, #Actor));
        return 1;
    }
    
    new id = GetPVarInt(playerid, #Actor), userid;

	if (sscanf(inputtext, "u", userid)) {
        DisplayPermissionsMenu(playerid, id);
        return SendNotConnected(playerid);
    }
    if (!IsPlayerLogged(userid)) {
        DisplayPermissionsMenu(playerid, id);
        return SendNotConnected(playerid);
    }

    if (playerid == userid) {
        DisplayPermissionsMenu(playerid, id);
        return SendErrorMessage(playerid, "Ban khong the cai dat cho chinh minh.");
    }

    new count;
    for (new i; i < MAX_ACTORS_EDITORS; i++) {
        if (ActorsInfo[id][ActorPermissions][i] == PlayerInfo[userid][pID]) count++;
    }
    if (count) return SendErrorMessage(playerid, "Nguoi choi da co dac quyen nay roi.");

    new i = GetPVarInt(playerid, #Actor_PermSel);

    ActorsInfo[id][ActorPermissions][i] = PlayerInfo[userid][pID];

    ActorsInfo[id][ActorEditedBy] = PlayerInfo[playerid][pID];
    ActorsInfo[id][ActorEditedDate] = gettime();

    SaveActor(id);

    SendSyntaxMessage(playerid, "Ban da thanh cong cai dat dac quyen len %s.", GetNameEx(userid));

    DeletePVar(playerid, #Actor);
    DeletePVar(playerid, #Actor_PermSel);
    return 1;
}