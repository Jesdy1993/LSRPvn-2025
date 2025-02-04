CMD:aactor(playerid, params[])
{
	if (!CheckAdmin(playerid, HIGH_ADMIN_LEVEL))	return SendNotAdmin(playerid);

	new option[16], secoption[128];
	
	if (sscanf(params, "s[16]S()[128]", option, secoption)) return SendHelpMessage(playerid, "/aactor [create/remove/edit/goto]");

	if (CompareStrings(option, "create"))
	{
        new type;
        if (sscanf(secoption, "i", type))               return SendHelpMessage(playerid, "/aactor create [type]");
        if (type < 0 || type >= sizeof(actors_type))    return SendErrorMessage(playerid, "Type can be (0 - %i)", sizeof(actors_type)-1);

		new id = AddActor(playerid, type, ADMIN_CREATION);
        if (id == -1) return SendErrorMessage(playerid, "Da vuot qua gioi han actors!");

		SendAdmMessageToPlayer(playerid, "Ban da tao mot %s actor [ID: %i].", actors_type[type], id);
		return 1;
	}

	else if (CompareStrings(option, "remove"))
	{
		new id;
		
		if (sscanf(secoption, "i", id))							            return SendHelpMessage(playerid, "/aactor remove [Actor ID]");
		if (id < 0 || id > MAX_DYNAMIC_ACTORS || !ActorsInfo[id][ActorID])	return SendErrorMessage(playerid, "Actor khong hop le.");

        new userid = GetPlayerInGameID(ActorsInfo[id][ActorOwner]);
        if(userid != -1)  {
            SendAdmMessageToPlayer(playerid, "Administrator %s da xoa actor cua ban (%s).", GetAccName(playerid), ActorsInfo[id][ActorName]);
        }

		ConfirmDialog(playerid, "Xac nhan", "{FFFFFF}Ban co chac chan muon xoa Actor nay khong??", "Xoa", id);
		return 1;
	}

	else if (CompareStrings(option, "edit"))
	{
		DisplayActorMenu(playerid, GetNearActor(playerid, 10.0));
	}

	else if (CompareStrings(option, "goto"))
	{
		new id;

		if (sscanf(secoption, "i", id))						                return SendHelpMessage(playerid, "/aactors goto [Actor ID]");
		if (id < 0 || id > MAX_DYNAMIC_ACTORS || !ActorsInfo[id][ActorID])	return SendErrorMessage(playerid, "Actor khong hop le. ");

		SetPlayerPosEx(playerid, ActorsInfo[id][actPosX], ActorsInfo[id][actPosY], ActorsInfo[id][actPosZ]);
		SetWorld(playerid, ActorsInfo[id][ActorVW]);
		SetInterior(playerid, ActorsInfo[id][ActorInt]);
		return 1;
	}
	
	else
	{
		SendHelpMessage(playerid, "/aactor [create/remove/edit/goto]");
	}
	return 1;
}

CMD:act(playerid, params[])
{
	new id = GetNearActor(playerid);
    ToggleActorName(ActorsInfo[id][ActorPed], true);
    return 1;
}

CMD:actor(playerid, params[])
{
	if (!GetPVarInt(playerid, #actor_permission))	return SendNotCanUse(playerid);
    DeletePVar(playerid, #actor_permission);

    new type = GetPVarInt(playerid, #actor_permission) - 1;
    if (type == ACTOR_CREATION+1) return AddActor(playerid, type);

    new id = GetNearActor(playerid), permission = 0;

    if (id == -1) return SendNotNearActor(playerid);

    for (new i; i < MAX_ACTORS_EDITORS; i++) {
        if(PlayerInfo[playerid][pID] != ActorsInfo[id][ActorPermissions][i]) continue;
        permission = 1;
        break;
    }
    if (!permission && ActorsInfo[id][ActorOwner] == PlayerInfo[playerid][pID]) {
        permission = 1;
    }

    if (permission) DisplayActorMenu(playerid, GetNearActor(playerid));
    else            SendNotCanUse(playerid);

	return 1;
}

CMD:actortaxi(playerid, params[])
{
	/*new vehicle = GetPlayerVehicleID(playerid);

	if (PlayerInfo[playerid][pJob] != JOB_TAXI)	return SendErrorMessage(playerid, "Vous n'êtes pas chauffeur de taxi.");
	if (!IsDriver(playerid))	return SendErrorMessage(playerid, "You must be in a Taxi or Cabbie car as a driver.");
	if (!IsATaxi(vehicle))		return SendErrorMessage(playerid, "You must be in a Taxi or Cabbie car. ");

	if (PlayerInfo[playerid][pJob] != JOB_TAXI)

	new id = GetNearActor(playerid, 10.0);
	if (id == -1) return SendNotNearActor(playerid);*/

	return 1;
}