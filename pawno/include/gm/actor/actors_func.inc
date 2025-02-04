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

this::LoadDynamicActors()
{
    new rows = cache_num_rows(), time = GetTickCount(), total, perm[6];

    if (!rows) return print("[Actors] No records found.");
    
    for(new i; i < rows; i++)
    {
        ActorsInfo[i][ActorID] = cache_get_field_content_int(i, "id");
        ActorsInfo[i][ActorType] = cache_get_field_content_int(i, "type");
        ActorsInfo[i][actPosX] = cache_get_field_content_float(i, "posX");
        ActorsInfo[i][actPosY] = cache_get_field_content_float(i, "posY");
        ActorsInfo[i][actPosZ] = cache_get_field_content_float(i, "posZ");
        ActorsInfo[i][actPosA] = cache_get_field_content_float(i, "posA");
        ActorsInfo[i][ActorVW] = cache_get_field_content_int(i, "vw");
        ActorsInfo[i][ActorInt] = cache_get_field_content_int(i, "int");
        ActorsInfo[i][ActorSkin] = cache_get_field_content_int(i, "skin");
        ActorsInfo[i][ActorAnimLib] = cache_get_field_content_int(i, "animation_lib");
        ActorsInfo[i][ActorAnimN] = cache_get_field_content_int(i, "animation_name");
        ActorsInfo[i][ActorInvulnerable] = bool:cache_get_field_content_int(i, "invulnerable");
        ActorsInfo[i][ActorHealth] =  cache_get_field_content_int(i, "health");
        cache_get_field_content(i, "name", ActorsInfo[i][ActorName], dbHandle, MAX_PLAYER_NAME);

        ActorsInfo[i][ActorOwner] = cache_get_field_content_int(i, "owner");
        ActorsInfo[i][ActorDate] = cache_get_field_content_int(i, "addTime");
        ActorsInfo[i][ActorEditedBy] = cache_get_field_content_int(i, "editor");
        ActorsInfo[i][ActorEditedDate] = cache_get_field_content_int(i, "editTime");   

        ActorsInfo[i][ActorOn] = true;

        for(new j; j < MAX_ACTORS_EDITORS; j++) {
            format(perm, sizeof(perm), "perm%d", j+1);
            ActorsInfo[i][ActorPermissions][j] = cache_get_field_content_int(j, perm);
        }
        
        total++;
        RefreshActor(i);
    }
        
    
    printf("[Actors] Lines - %i. Load - %i. Time: %i ms.", rows, total, GetTickCount()-time);
    return 1;
}

stock RefreshActor(id)
{
    if (IsValidDynamic3DTextLabel(ActorsInfo[id][ActorLabel])) DestroyDynamic3DTextLabel(ActorsInfo[id][ActorLabel]);
    if (IsValidDynamicActor(ActorsInfo[id][ActorPed]))         DestroyDynamicActor(ActorsInfo[id][ActorPed]);

    ActorsInfo[id][ActorPed] = CreateDynamicActor(ActorsInfo[id][ActorSkin], ActorsInfo[id][actPosX], ActorsInfo[id][actPosY], ActorsInfo[id][actPosZ], ActorsInfo[id][actPosA], ActorsInfo[id][ActorInvulnerable], ActorsInfo[id][ActorHealth], ActorsInfo[id][ActorVW], ActorsInfo[id][ActorInt]);                  
    
    new color = ActorsInfo[id][ActorType] == POLICE_NPC ? RemoveAlpha(COLOR_POLICECHAT) : RemoveAlpha(COLOR_WHITE);
    SetActorName(ActorsInfo[id][ActorPed], ActorsInfo[id][ActorName], false, color, true);
    ToggleActorName(ActorsInfo[id][ActorPed], true);

    PreloadActorAnimations(ActorsInfo[id][ActorPed]);

    CallRemoteFunction("ClearActorSpecialAnim", "i", id);
    return 1;
}

stock AddActor(playerid, type, limit = USER_CREATION)
{
    new id = GetFreeActorIndex();
    if (id == -1) return -1;
    
    GetXYInFrontOfPlayer(playerid, ActorsInfo[id][actPosX], ActorsInfo[id][actPosY], ActorsInfo[id][actPosZ], 1.0);
    GetPlayerFacingAngle(playerid, ActorsInfo[id][actPosA]);

    ActorsInfo[id][actPosA] -= 180.0;

    ActorsInfo[id][ActorOn] = true;
    ActorsInfo[id][ActorSkin] = 250;
    ActorsInfo[id][ActorType] = type;
    ActorsInfo[id][ActorStatus] = 0;
    ActorsInfo[id][ActorAnimLib] = -1;
    ActorsInfo[id][ActorAnimN] = -1;
    
    switch(type) {
        case REGULAR_NPC: {
            format(ActorsInfo[id][ActorName], MAX_PLAYER_NAME, "Actor");
            ActorsInfo[id][ActorOwner] = PlayerInfo[playerid][pID];
        } case POLICE_NPC: {
            format(ActorsInfo[id][ActorName], MAX_PLAYER_NAME, "Police Officer"); 
            ActorsInfo[id][ActorOwner] = PlayerInfo[playerid][pFaction];
        } case BUYER_NPC: {
            format(ActorsInfo[id][ActorName], MAX_PLAYER_NAME, "Buyer");
            ActorsInfo[id][ActorOwner] = GetNearInsideBiz(playerid);
        } case CASHIER_NPC: {
            format(ActorsInfo[id][ActorName], MAX_PLAYER_NAME, "Cashier");
            ActorsInfo[id][ActorOwner] = GetNearInsideBiz(playerid);
        } case TAXI_NPC: {
            format(ActorsInfo[id][ActorName], MAX_PLAYER_NAME, "Taxi NPC");
            ActorsInfo[id][ActorOwner] = 0;
        }
    }

    ActorsInfo[id][ActorVW] = GetPlayerVirtualWorld(playerid);
    ActorsInfo[id][ActorInt] = GetPlayerInterior(playerid);

    ActorsInfo[id][ActorInvulnerable] = true;
    ActorsInfo[id][ActorHealth] = 100.0;
    
    ActorsInfo[id][ActorDate] = gettime();

    for (new i; i < MAX_ACTORS_EDITORS; i++) {
        ActorsInfo[id][ActorPermissions][i] = -1;
    }

    ActorsInfo[id][ActorEditedBy] = 0;
    ActorsInfo[id][ActorEditedDate] = 0;

    RefreshActor(id);

    new query[70];
	mysql_format(dbHandle, query, sizeof(query), "INSERT INTO `actors` (`owner`,`addTime`) VALUES (%i,%i)", ActorsInfo[id][ActorOwner], ActorsInfo[id][ActorDate]);
	mysql_tquery(dbHandle, query, "OnActorCreated", "ddd", id, playerid, limit);

    return id;
}

this::OnActorCreated(id, playerid, limit)
{
	if (id == -1 || !ActorsInfo[id][ActorOn]) return 0;

	ActorsInfo[id][ActorID] = cache_insert_id();

    if (limit == ADMIN_CREATION)
    {
        new ip[24];
	    GetPlayerIp(playerid, ip, sizeof(ip));

        new query[128];
        format(query, sizeof(query), "[/aactor] IP: %s, Administrator %s da tao actor - bdID:%i", ip, GetAccName(playerid), ActorsInfo[id][ActorID]);
        insert_log(query, ADMIN_LOG, 12, PlayerInfo[playerid][pAccID], 0);
    }

	if(SaveActor(id) == -1) return 0;
	return 1;
}

this::DeleteActor(playerid, response, id)
{
    if (IsValidDynamic3DTextLabel(ActorsInfo[id][ActorLabel]))  DestroyDynamic3DTextLabel(ActorsInfo[id][ActorLabel]);
    if (IsValidDynamicActor(ActorsInfo[id][ActorPed]))          DestroyDynamicActor(ActorsInfo[id][ActorPed]);

    new query[40];
	mysql_format(dbHandle, query, sizeof(query), "DELETE FROM `actors` WHERE `id` = '%d'", ActorsInfo[id][ActorID]);
	mysql_tquery(dbHandle, query);

    ActorsInfo[id][ActorOn] = false;
    ActorsInfo[id][ActorID] = 0;

    if (CheckAdmin(playerid, HIGH_ADMIN_LEVEL)) {
        SendAdmMessageToPlayer(playerid, "Ban da xoa Actor[ID: %i].", id);
    } else {
        SendSyntaxMessage(playerid, "Ban da xoa Actor[ID: %i].", id);
    }

	return 1;
}

stock SaveActor(id)
{
    if(id == -1 && !ActorsInfo[id][ActorOn]) return -1;  

	new query[1024];
	format(query, sizeof(query), "UPDATE `actors` SET `type`=%i,`name`='%s',`editor`=%i,`editTime`=%i,`skin`=%i,`posX`=%f,`posY`=%f,`posZ`=%f,`posA`=%f,`vw`=%i,`int`=%i,`invulnerable`=%b,`health`=%f,`animation_lib`=%i,`animation_name`=%i WHERE `id`=%i",
		ActorsInfo[id][ActorType], ActorsInfo[id][ActorName], ActorsInfo[id][ActorEditedBy], ActorsInfo[id][ActorEditedDate],
		ActorsInfo[id][ActorSkin], ActorsInfo[id][actPosX], ActorsInfo[id][actPosY], ActorsInfo[id][actPosZ], ActorsInfo[id][actPosA], 
        ActorsInfo[id][ActorVW], ActorsInfo[id][ActorInt], ActorsInfo[id][ActorInvulnerable], ActorsInfo[id][ActorHealth],
        ActorsInfo[id][ActorAnimLib], ActorsInfo[id][ActorAnimN],
        ActorsInfo[id][ActorID]
	);
	mysql_tquery(dbHandle, query);

    for(new i = 0; i < MAX_ACTORS_EDITORS; i++)
	{
		format(query, sizeof(query), "UPDATE `actors` SET `perm%i`=%i WHERE `id`=%i", i+1, ActorsInfo[id][ActorPermissions][i], ActorsInfo[id][ActorID]);
		mysql_tquery(dbHandle, query);
	}	

    return 1;
}

stock SetActorStatus(id, status)
{
    ActorsInfo[id][ActorStatus] = status;
    return status;
}

stock GetActorStatus(id)
{
    return ActorsInfo[id][ActorStatus];
}

stock SetActorReplica(id, type, status) 
{
    switch(type) {
        case CASHIER_NPC: {
            switch(status) {
                case PED_AIMED: OnActorSpecialAnim(id, PED_AIMED, "ROB_BANK","SHP_HandsUp_Scr");
                case PED_FINISH: OnActorSpecialAnim(id, PED_FINISH, "ped", "cower", 600000);
                case PED_CANCEL: OnActorSpecialAnim(id, PED_CANCEL, "GANGS","prtial_gngtlkA", 600000); //600000
            }
        }
        case BUYER_NPC: {
            switch(status) {
                case PED_AIMED: OnActorSpecialAnim(id, PED_AIMED, "ped", "cower");
            }
        }
        case TAXI_NPC: {
            switch(status) {
                case PED_AIMED: OnActorSpecialAnim(id, PED_AIMED, "ped", "cower");
                case PED_CANCEL: OnActorSpecialAnim(id, PED_CANCEL, "OTB","wtchrace_cmon"); 
                case PED_FINISH: OnActorSpecialAnim(id, PED_FINISH, "PED","endchat_01"); 
            }
        }
        default: OnActorSpecialAnim(id, PED_NONE, "GANGS","prtial_gngtlkA", 3000);
    }

    SetActorChatBubble(ActorsInfo[id][ActorPed], ActorDialogs[type][status], COLOR_FADE1, 15.0, 10000);
    return 1;
}

stock GetActorIndex(actorid)
{
    for (new i; i < MAX_DYNAMIC_ACTORS; i++)
    {
        if (actorid == ActorsInfo[i][ActorPed]) return i;
    }
    
    return -1;
}

/*stock GetNearActor(playerid, Float:actor_range = 2.0)
{
    new id = -1, 
        bool:dyanmic,
        actorid = GetNearestActorForPlayer(playerid, dyanmic);
    
    printf("%i | %b", actorid, dyanmic);

    if (IsPlayerInRangeOfActor(playerid, actorid, actor_range) && dyanmic) id = GetActorIndex(actorid);

    return id;
}*/

stock GetNearActor(playerid, Float:actor_range = 2.0)
{
    if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER) return -1;

    new id = -1;

    for(new i = 0; i < sizeof(ActorsInfo); i++)
    {
        if (!ActorsInfo[i][ActorOn]) continue;

        new Float:dist = GetPlayerDistanceFromPoint(playerid, ActorsInfo[i][actPosX], ActorsInfo[i][actPosY], ActorsInfo[i][actPosZ]);

        if (dist <= actor_range && ActorsInfo[i][ActorInt] == GetInterior(playerid) && ActorsInfo[i][ActorVW] == GetWorld(playerid))
        {
            actor_range = dist; 
            id = i; 
        }
    }
    return id;
}

stock GetFreeActorIndex()
{
    for (new i = 0; i != MAX_DYNAMIC_ACTORS; i ++) {
        if (ActorsInfo[i][ActorOn]) continue;
        return i;
    }
    return -1;
}

this::PreloadActorAnimations(actor)
{
	for (new i; i < sizeof(ActorAnimationLib); i++) {
        ApplyActorAnimation(actor, ActorAnimationLib[i], "null", 0.0, 0, 0, 0, 0, 0);
    }
	return 1;
}

stock DisplayActorMenu(playerid, id)
{
    static const c_caption[] = "Actor menu | {FF6347}Actor ID:%i";
    new caption[sizeof(c_caption)+4-2];
    format(caption, sizeof(caption), c_caption, id);

    SetPVarInt(playerid, #Actor, id);

    Dialog_Show (playerid, ActorMenu, DIALOG_STYLE_LIST, caption, "Information\nSettings\nEdit position\nPermissions\n	\n{FF6347}Xoa", "Lua chon", "Dong");
    return 1;
}

stock DisplayActorSettings(playerid, id)
{
    static const c_caption[] = "Actor menu | {FF6347}Actor ID:%i";
    new caption[sizeof(c_caption)+4-2];
    format(caption, sizeof(caption), c_caption, id);

    new animation[23] = "None";
    if (ActorsInfo[id][ActorAnimLib] != -1 && ActorsInfo[id][ActorAnimN] != -1) {
        format(animation, sizeof(animation), "%s (%s)", ActorAnimationLib[ActorsInfo[id][ActorAnimLib]], ActorAnimationName[ActorsInfo[id][ActorAnimLib]][ActorsInfo[id][ActorAnimN]]);
    }

    static const c_info[] = "{FFFFFF}Thay doi ten\t\t{c7c7c7}%s\n\
                            {FFFFFF}Thay doi skin\t\t{c7c7c7}%i\n\
                            {FFFFFF}Thay doi anim\t{c7c7c7}%s\n\
                            {FFFFFF}nang cap mau\t\t{c7c7c7}%.0f\n\
                            {FFFFFF}Invulnerable\t\t{c7c7c7}%s";

    new info[sizeof(c_info)+MAX_ACTOR_TYPE_CHAR+16+MAX_PLAYER_NAME*3+88];
    format(info, sizeof(info), c_info, ActorsInfo[id][ActorName], ActorsInfo[id][ActorSkin], animation, ActorsInfo[id][ActorHealth], ActorsInfo[id][ActorInvulnerable] ? "Co" : "Khong");

    Dialog_Show (playerid, ActorSettings, DIALOG_STYLE_LIST, caption, info, "Thay doi", "Quay lai");
    return 1;
}

stock DisplayPermissionsMenu(playerid, id)
{
    static const c_caption[] = "Actor persmissions | {FF6347}Actor ID:%i";
    new caption[sizeof(c_caption)+4-2];
    format(caption, sizeof(caption), c_caption, id);

    new info[MAX_ACTORS_EDITORS*(MAX_PLAYER_NAME+2)];

    for (new i; i < MAX_ACTORS_EDITORS; i++) {
        new name[MAX_PLAYER_NAME] = "Add";
        if (ActorsInfo[id][ActorPermissions][i] != -1) {
            format(name, sizeof(name), "%s%s", GetNameFromBD(ActorsInfo[id][ActorPermissions][i]));
        }
        format(info, sizeof(info), "%s%s\n", info, name);
    }

    Dialog_Show (playerid, ActorPermissions, DIALOG_STYLE_LIST, caption, info, "Lua chon", "Quay lai");
    return 1;
}

stock DisplayLibMenu(playerid, id)
{
    static const c_caption[] = "CHANGE ANIMATION | {FF6347}Actor ID:%i";
    new caption[sizeof(c_caption)+4-2];
    format(caption, sizeof(caption), c_caption, id);

    new c_info[sizeof(ActorAnimationLib)*(2+MAX_ACTOR_LIB_CHAR)+17+8-(sizeof(ActorAnimationLib)*2)];
    format(c_info, sizeof(c_info), "%sClear animation", ActorsInfo[id][ActorAnimLib] == -1 ? "{FF6347}" : "");

    for (new i; i < sizeof(ActorAnimationLib); i++) {
        format(c_info, sizeof(c_info), "%s\n%s%s", c_info, ActorsInfo[id][ActorAnimLib] == i ? "{FF6347}" : "", ActorAnimationLib[i]);
    }
    
    Dialog_Show (playerid, ChoosenAnimLib, DIALOG_STYLE_LIST, caption, c_info, "Lua chon", "Quay lai");
    return 1;
}

stock DisplayNameMenu(playerid, id, lib)
{
    static const c_caption[] = "CHANGE ANIMATION | {FF6347}Actor ID:%i";
    new caption[sizeof(c_caption)+4-2];
    format(caption, sizeof(caption), c_caption, id);

    new c_info[sizeof(ActorAnimationLib)*(2+MAX_ACTOR_NAME_CHAR)+8-(sizeof(ActorAnimationLib)*2)]; 

    SetPVarInt(playerid, #ActorLib, lib);

    for (new i; i < MAX_ANIMS_IN_LIB; i++) {
        if (CompareStrings(ActorAnimationName[lib][i], "-")) continue;
        format(c_info, sizeof(c_info), "%s\n%s%s", c_info, ActorsInfo[id][ActorAnimN] == i && ActorsInfo[id][ActorAnimLib] == lib ? "{FF6347}" : "", ActorAnimationName[lib][i]);
    }
    
    Dialog_Show (playerid, ChoosenAnimation, DIALOG_STYLE_LIST, caption, c_info, "Lua chon", "Quay lai");
    return 1;
}

stock ClearActorAnim(playerid, id) 
{    
    ActorsInfo[id][ActorAnimLib] = -1;
    ActorsInfo[id][ActorAnimN] = -1;

    ClearDynamicActorAnimations(ActorsInfo[id][ActorPed]);
    DisplayLibMenu(playerid, id);

    ActorsInfo[id][ActorEditedBy] = PlayerInfo[playerid][pID];
    ActorsInfo[id][ActorEditedDate] = gettime();

    SaveActor(id);
    return 1;
}

stock OnActorSpecialAnim(id, status = PED_NONE, lib[], name[], time = 180000)
{
    /*new a_Name[30], a_Lib[30];
    GetActorAnimationName(ActorsInfo[id][ActorPed], a_Lib, sizeof(a_Lib), a_Name, sizeof(a_Name));
    CompareStrings(a_Lib, ActorsInfo[id][ActorAnimLib]) && CompareStrings(a_Name, ActorsInfo[id][ActorAnimN])*/
        
    if (ActorsInfo[id][ActorTimer] && (GetActorStatus(id) == status || GetActorStatus(id) == PED_CANCEL|| GetActorStatus(id) == PED_FINISH)) {
        return 1;
    } else {
        KillTimer(ActorsInfo[id][ActorTimer]);
        ActorsInfo[id][ActorTimer] = 0;
    }

    SetActorStatus(id, status);
    ApplyDynamicActorAnimation(ActorsInfo[id][ActorPed], lib, name, 4.0, 0, 1, 1, 1, 0);
    ActorsInfo[id][ActorTimer] = SetTimerEx("ClearActorSpecialAnim", time, false, "i", id);
    return 1;
}

this::ClearActorSpecialAnim(id)
{
    ActorsInfo[id][ActorTimer] = 0;
    ClearDynamicActorAnimations(ActorsInfo[id][ActorPed]);
    SetActorStatus(id, PED_NONE);

    if (ActorsInfo[id][ActorAnimLib] == -1 || ActorsInfo[id][ActorAnimN] == -1) return 1;
    ApplyDynamicActorAnimation(ActorsInfo[id][ActorPed], ActorAnimationLib[ActorsInfo[id][ActorAnimLib]], ActorAnimationName[ActorsInfo[id][ActorAnimLib]][ActorsInfo[id][ActorAnimN]], 4.1, 1, 0, 0, 0, 0);
    return 1;
}

this::DeletePermission(playerid, response, id, listitem, name[])
{
    SendSyntaxMessage(playerid, "You removed %s's permissions", name);
    ActorsInfo[id][ActorPermissions][listitem] = -1;
    SaveActor(id);
    return 1;
}