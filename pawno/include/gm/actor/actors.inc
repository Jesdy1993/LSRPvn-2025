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

Actors_OnGameModeInit()
{
    return mysql_tquery(dbHandle, "SELECT * FROM `actors`", "LoadDynamicActors");
}

Actors_OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if (PRESSED( KEY_CTRL_BACK | KEY_AIM ))
    {
        if (CheckAdmin(playerid, HIGH_ADMIN_LEVEL)) cmd::aactor(playerid, "edit");
        else if (TaxiDuty[playerid]) cmd::actortaxi(playerid, "");
        else if (IsFactionIllegal(PlayerInfo[playerid][pFaction]) && IsAGun(GetPlayerWeapon(playerid))) ConfirmRobbing(playerid);//ConfirmDialog(playerid, "Robbing cashier", "Are you sure you want to rob cashier?", "ConfirmRobbing");
        else if (GetNearActor(playerid, 5.0) != -1 && ActorsInfo[GetNearActor(playerid, 5.0)][ActorType] == CASHIER_NPC) cmd::buy(playerid, ""); 
        else cmd::actor(playerid, "");
    }

    return 1;
}

public OnPlayerShotActor(playerid, actorid, weaponid, bool:IsDynamicActor)
{
    return 1;
}

public OnPlayerTargetActor(playerid, actorid, weaponid)
{
    new id = GetActorIndex(actorid);
    
    if (!infotxt_expire{playerid}) {
        if (ActorsInfo[id][ActorOwner] == PlayerInfo[playerid][pID] || CheckAdmin(playerid, HIGH_ADMIN_LEVEL)) {
            InfoMSG(playerid, "Nhan ~y~CHUOT-PHAI~w~ hoac ~y~H~w~ de ~y~bat ~w~menu quan ly NPC.", 5);
        }

        for (new i; i < MAX_ACTORS_EDITORS; i++) {
            if(PlayerInfo[playerid][pID] != ActorsInfo[id][ActorPermissions][i]) continue;
            InfoMSG(playerid, "Nhan ~y~CHUOT-PHAI~w~ hoac ~y~H~w~ de ~y~bat ~w~menu quan ly NPC.", 5);
            break;
        }
    }
    
    //if (GetPVarInt(playerid, #Robbing) continue;
    if (ActorsInfo[id][ActorType] == CASHIER_NPC) {
        if (IsAGun(weaponid) && ActorsInfo[id][ActorStatus] != PED_CANCEL && ActorsInfo[id][ActorStatus] != PED_FINISH) { 
            if (IsFactionIllegal(PlayerInfo[playerid][pFaction])) {
                if (!infotxt_expire{playerid}) InfoMSG(playerid, "Nhan ~y~Chuot-PHai~w~ hoac ~y~H~w~ de ~y~cuop ~w~Seller.", 5);
                return SetActorReplica(id, ActorsInfo[id][ActorType], PED_AIMED);
            } else {
                return SetActorReplica(id, ActorsInfo[id][ActorType], PED_DISSENT);
            }
        }
    } else if (ActorsInfo[id][ActorType] == BUYER_NPC) {
        if (IsAGun(weaponid)) { 
            if (IsFactionIllegal(PlayerInfo[playerid][pFaction])) {
                return SetActorReplica(id, ActorsInfo[id][ActorType], PED_AIMED);
            } else {
                return SetActorReplica(id, ActorsInfo[id][ActorType], PED_DISSENT);
            }
        }
    } else if (ActorsInfo[id][ActorType] == TAXI_NPC) {
        if (TaxiDuty[playerid] && GetActorStatus(id) == PED_WAITING) {
            return SetActorReplica(id, ActorsInfo[id][ActorType], PED_WAITING);
        }
    }


    SetActorReplica(id, ActorsInfo[id][ActorType], PED_NONE);
    return 1;
}

public OnPlayerStopTargetActor(playerid, actorid, weaponid)
{
    return 1;
}

public OnPlayerMakeDamageToActor(playerid, damaged_actorid, Float:amount, weaponid, bodypart, bool:death, bool:IsDynamicActor)
{
    return 1;
}

public OnActorDeath(actorid, killerid, reason, bool:IsDynamicActor)
{
    return 1;
}

public OnActorSpawn(actorid, bool:IsDynamicActor)
{
    return 1;
}

/*public OnPlayerTextNearActor(playerid, actorid, text[], bool:IsDynamicActor)
{
    return 1;
}*/


/*public OnPlayerStreamForActor(forplayerid, actorid, actor_flags, bool:IsDynamicActor) // Pawn RakNet dependency
{
    return 1;
}*/

public OnActorVirtualWorldChange(actorid, oldvw, newvw, bool:IsDynamicActor)
{
    return 1;
}

public OnDynamicActorInteriorChange(actorid, oldinterior, newinteriorid)
{
    return 1;
}


/*Actor_OnPlayerGiveDamageDynamicActor(playerid, actorid, Float:amount, weaponid, bodypart)
{
    new string[128], attacker[MAX_PLAYER_NAME];
    new weaponname[24];
    GetPlayerName(playerid, attacker, sizeof (attacker))
    GetWeaponName(weaponid, weaponname, sizeof (weaponname))

    format(string, sizeof(string), "%s has made %.0f damage to actor id %d, weapon: %s", attacker, amount, damaged_actorid, weaponname)
    SendClientMessageToAll(0xFFFFFFFF, string)
    return 1;
}

Actor_OnPlayerUpdate(playerid)
{
    new
        targetActorId = GetPlayerTargetActor(playerid),
        string[32];

    format(string, sizeof(string), "You are aiming at actor id %d", targetActorId)
    SendClientMessage(playerid, -1, string)

     // Find out what actor (if any) the player is LOOKING at
    new playerTargetActor = GetPlayerCameraTargetActor(playerid)

    // If they ARE looking at ANY actor
    if (playerTargetActor != INVALID_ACTOR_ID)
    {
        // Store the player's weapon so we can check if they are armed
        new playerWeapon = GetPlayerWeapon(playerid)

        // Get the player's keys so we can check if they are aiming
        new keys, updown, leftright;
        GetPlayerKeys(playerid, keys, updown, leftright)

        // If the actor hasn't put its hands up yet, AND the player is ARMED
        if (!ActorHandsup[playerTargetActor] && playerWeapon >= 22 && playerWeapon <= 42 && keys & KEY_AIM)
        {
            // Apply 'hands up' animation
            ApplyActorAnimation(playerTargetActor, "SHOP", "SHP_HandsUp_Scr",4.1,0,0,0,1,0)

            // Set 'ActorHandsup' to true, so the animation won't keep being reapplied
            ActorHandsup[playerTargetActor] = true;
        }
    }
    return 1;
}*/