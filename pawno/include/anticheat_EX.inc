//Adaugati serverTeleported(playerid); in functia SetPlayerPosEx (din gamemode)

DEFINE_HOOK_REPLACEMENT( Unoccupied , Uncp );
#include <YSI_Coding\y_timers>
#include <YSI_Coding\y_hooks>

#define CHEAT_TYPES 7

//#define AC_DEBUG_MODE
#define PRESSED(%0) (((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

enum
{
	CHEAT_FLY_HACK,
	CHEAT_SPEED_HACK,
	CHEAT_INVISIBLE,
	CHEAT_JETPACK,
	CHEAT_TELEPORT,
	CHEAT_TROLL_1,
	CHEAT_FAKE_KILL_1
};

enum AC_Enums
{
	AC_Warnings[CHEAT_TYPES],
	AC_Kicked,
	Float: AC_POS[3],
	AC_Teleported,
	AC_LFWeapon,
	Float: AC_Velocity[3],
	/*AC_EnterVeh,
	AC_EnterVeh_Tick
	AC_VehicleSeat,
	AC_TempOwn*/
};

new 
	AC_VARIABLE[MAX_PLAYERS][AC_Enums];

function cheatDetect(playerid, cheat_id)
{
	switch(cheat_id)
	{
		case CHEAT_FLY_HACK:
		{
			new 
				playerAnim = GetPlayerAnimationIndex(playerid);

			if(playerAnim == 958 || playerAnim == 1231 || playerAnim == 1189 || playerAnim == 1538 || playerAnim == 1539)
			{
				if(getPlayerSpeed(playerid) > 150 && GetPlayerSurfingVehicleID(playerid) == INVALID_VEHICLE_ID)
				{
					if(AC_VARIABLE[playerid][AC_Warnings][CHEAT_FLY_HACK] > 4) 
						return OnCheatDetect(playerid, "fly-hack");

					OnWarningExecute(playerid, CHEAT_FLY_HACK, "fly-hack");
				}
			}
		}
		case CHEAT_SPEED_HACK:
		{
			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER && !IsAPlane(GetPlayerVehicleID(playerid)) && vehicleSpeed(playerid) > 250)
			{
				if(AC_VARIABLE[playerid][AC_Warnings][CHEAT_SPEED_HACK] > 7) 
						return OnCheatDetect(playerid, "speed-hack");

				OnWarningExecute(playerid, CHEAT_SPEED_HACK, "speed-hack");
			}
		}
		case CHEAT_INVISIBLE:
		{
			if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING) 
				return OnCheatDetect(playerid, "invisible or spectate");
		}
		case CHEAT_JETPACK:
		{
			if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USEJETPACK) 
				return OnCheatDetect(playerid, "jetpack");
		}
		case CHEAT_TELEPORT:
		{
			new 
				vehicleSurf = GetPlayerSurfingVehicleID(playerid),
				Float: lastDist = GetPlayerDistanceFromPoint(playerid, AC_VARIABLE[playerid][AC_POS][0], AC_VARIABLE[playerid][AC_POS][1], AC_VARIABLE[playerid][AC_POS][2]);

			#if defined AC_DEBUG_MODE
				va_SendClientMessage(playerid, -1, "dist: %f", lastDist);
			#endif

			if(!IsVehicleStreamedIn(vehicleSurf, playerid) && GetPlayerSurfingObjectID(playerid) == INVALID_OBJECT_ID)
			{
				if(lastDist > 100.0)
				{
					if(gettime() > AC_VARIABLE[playerid][AC_Teleported] && !noAdminDriving(playerid))
					{
						if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
						{
							if(AC_VARIABLE[playerid][AC_Warnings][CHEAT_TELEPORT] > 1)
								return OnCheatDetect(playerid, "teleport-hack #1");

							OnWarningExecute(playerid, CHEAT_TELEPORT, "teleport-hack #1");
						}
						else if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT && vehicleSpeed(playerid) < 150)
						{
							if(AC_VARIABLE[playerid][AC_Warnings][CHEAT_TELEPORT] > 1)
								return OnCheatDetect(playerid, "teleport-hack #2");

							OnWarningExecute(playerid, CHEAT_TELEPORT, "teleport-hack #2");
						}
					}
				}
			}

			if(IsPlayerInAnyVehicle(playerid) && IsPlayerPaused(playerid)) 
				GetVehiclePos(GetPlayerVehicleID(playerid), AC_VARIABLE[playerid][AC_POS][0], AC_VARIABLE[playerid][AC_POS][1], AC_VARIABLE[playerid][AC_POS][2]);
			else GetPlayerPos(playerid, AC_VARIABLE[playerid][AC_POS][0], AC_VARIABLE[playerid][AC_POS][1], AC_VARIABLE[playerid][AC_POS][2]);
		}
		case CHEAT_TROLL_1:
		{
			new 
				Float: velX, Float: velY, Float: velZ,
				Float: X, Float: Y, Float: Z;

			GetPlayerPos(playerid, X, Y, Z);

			if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && !IsPlayerInAnyVehicle(playerid))
			{
				if(Z > 5.0000)
				{
					GetPlayerVelocity(playerid, velX, velY, velZ);

					new 
						Float: velXAmount = velX - AC_VARIABLE[playerid][AC_Velocity][0],
						Float: velYAmount = velY - AC_VARIABLE[playerid][AC_Velocity][1];

					if(velXAmount > 3.0 || velXAmount < -4.0 || velYAmount  > 10.0 || velYAmount < -10.0 || velZ == 0.100000) 
						return OnCheatDetect(playerid, "troll-hack #1");
				}

				GetPlayerVelocity(playerid, AC_VARIABLE[playerid][AC_Velocity][0], AC_VARIABLE[playerid][AC_Velocity][1], AC_VARIABLE[playerid][AC_Velocity][2]);
			}

			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
			{
				GetVehicleVelocity(GetPlayerVehicleID(playerid), velX, velY, velZ);

				if(velY == -90.000000 && velZ == 0.100000) 
					return OnCheatDetect(playerid, "troll-hack #2");
			}
		}
		case CHEAT_FAKE_KILL_1:
		{
			if(AC_VARIABLE[playerid][AC_Warnings][CHEAT_FAKE_KILL_1] > 3) 
				return OnCheatDetect(playerid, "fake-kill #1");

			OnWarningExecute(playerid, CHEAT_SPEED_HACK, "fake-kill #1");
		}
	}

	return true;
}

stock OnWarningExecute(playerid, cheat_id, const cheat_name[])
{
	if(AC_VARIABLE[playerid][AC_Kicked]) 
		return true;

	AC_VARIABLE[playerid][AC_Warnings][cheat_id] ++;

	new 
		String[146];

	format(String, sizeof String, "[ANTICHEAT] %s is suspect for using %s [%d warnings]! (/spec %d)", 
		getName(playerid), cheat_name, AC_VARIABLE[playerid][AC_Warnings][cheat_id], playerid);
	ABroadCast(COLOR_RED, 1, String);

	return true;
}

stock OnCheatDetect(playerid, const cheat_name[])
{
	if(AC_VARIABLE[playerid][AC_Kicked]) 
		return true;

	new 
		String[100];

	format(String, sizeof String, "%s has been kicked by Admbot, reason: %s", getName(playerid), cheat_name);
	SendClientMessageToAll(COLOR_LIGHTRED, String);

	format(String, 70, "You has been kicked by Admbot, reason: %s", cheat_name);
	SendClientMessage(playerid, COLOR_CLIENT, String);

	AC_VARIABLE[playerid][AC_Kicked] = true;
	KickEx(playerid);

	return true;
}

getPlayerSpeed(playerid)
{
	new 
		Float: X, Float: Y, Float: Z;

	GetPlayerVelocity(playerid, X, Y, Z);

	return floatround(200 * floatsqroot(X * X + Y * Y + Z * Z));
}

task onCheatTime[1000]()
{
	foreach(new i : Player)
	{
		if(isPlayerLogged[i] && !AC_VARIABLE[i][AC_Kicked])
		{
			for(new x = 0; x < 5; x ++) cheatDetect(i, x);

			#if defined AC_DEBUG_MODE
				va_SendClientMessage(i, -1, "[OLD] X: %f, Y: %f, Z: %f", AC_VARIABLE[i][AC_POS][0], AC_VARIABLE[i][AC_POS][1], AC_VARIABLE[i][AC_POS][2]);
			#endif

			#if defined AC_DEBUG_MODE
				va_SendClientMessage(i, -1, "[NEW] X: %f, Y: %f, Z: %f", AC_VARIABLE[i][AC_POS][0], AC_VARIABLE[i][AC_POS][1], AC_VARIABLE[i][AC_POS][2]);
				va_SendClientMessage(i, -1, "Anim: %d / Vehicle: %d", GetPlayerAnimationIndex(i), GetPlayerVehicleID(i));
			#endif
		}
	}

	return true;
}

noAdminDriving(playerid)
{
	if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_PASSENGER)
	{
		foreach(new i : Player)
		{
			if(GetPlayerState(i) == PLAYER_STATE_DRIVER && GetPlayerVehicleID(i) == GetPlayerVehicleID(playerid) && playerVariables[i][pAdmin]) 
				return true;
		}
	}
	return false;
}

stock serverTeleported(playerid) return AC_VARIABLE[playerid][AC_Teleported] = gettime() + 6;

stock clearAnimations(playerid)
{
	ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0);
    ClearAnimations(playerid);
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);

	return true;
}

//================== PUBLICS ==================//

hook OnPlayerSpawn(playerid)
{
	AC_VARIABLE[playerid][AC_Teleported] = gettime() + 6;

	return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnPlayerDeath(playerid, killerid, reason)
{
	AC_VARIABLE[playerid][AC_Teleported] = gettime() + 6;

	return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnVehicleMod(playerid, vehicleid, componentid) return AC_VARIABLE[playerid][AC_Teleported] = gettime() + 6;

hook OnPlayerConnect(playerid)
{
	AC_VARIABLE[playerid][AC_Teleported] = gettime() + 6;
	AC_VARIABLE[playerid][AC_Kicked] = false;
	AC_VARIABLE[playerid][AC_LFWeapon] = 0;
	for(new i = 0; i < CHEAT_TYPES; i ++) if(AC_VARIABLE[playerid][AC_Warnings][i] > 0) AC_VARIABLE[playerid][AC_Warnings][i] = 0;
	for(new i = 0; i < 3; i ++) AC_VARIABLE[playerid][AC_Velocity][i] = -1;

	return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
		if(PRESSED(KEY_FIRE))
		{
			if(GetPlayerWeapon(playerid) == WEAPON_DEAGLE) AC_VARIABLE[playerid][AC_LFWeapon] = gettime();
		}
		else if(PRESSED(KEY_CROUCH))
		{
			if(gettime() - AC_VARIABLE[playerid][AC_LFWeapon] < 1)
			{
				clearAnimations(playerid);
				SetPlayerArmedWeapon(playerid, 0);

				GameTextForPlayer(playerid, "~r~~h~C-BUG IS NOT ALLOWED!", 3000, 4);
			}
		}
	}

	return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid, bodypart)
{
	if(damagedid != INVALID_PLAYER_ID && bodypart == 0 && weaponid < 16) cheatDetect(playerid, CHEAT_FAKE_KILL_1);

	return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnUncpVehicleUpdate(vehicleid, playerid, passenger_seat, Float:new_x, Float:new_y, Float:new_z, Float:vel_x, Float:vel_y, Float:vel_z)
{
	if((new_x != new_x || new_y != new_y || new_z != new_z ||
		floatabs(new_x) >= 25000.0 || floatabs(new_y) >= 25000.0 || floatabs(new_z) >= 25000.0)) 
			return OnCheatDetect(playerid, "troll-hack #3");

	new 
		Float: X, Float: Y, Float: Z;

	GetVehiclePos(vehicleid, X, Y, Z);

	if(passenger_seat > 0)
	{
		new 
			Float: difference = new_z - Z;

		if(difference >= -5.0 && (floatabs(new_x - X) >= 12.0 || floatabs(new_y - Y) >= 12.0)) 
			return OnCheatDetect(playerid, "troll-hack #4");
	}

	return Y_HOOKS_CONTINUE_RETURN_1;
}