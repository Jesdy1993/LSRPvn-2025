

#include <YSI\y_hooks>




new bool:pCBugging[MAX_PLAYERS];


new ptmCBugFreezeOver[MAX_PLAYERS];



new ptsLastFiredWeapon[MAX_PLAYERS];



hook OnPlayerDisconnect(playerid, reason)
{
	ResetPlayerVariables(playerid);
	return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(!pCBugging[playerid] && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
		if(PRESSED(KEY_FIRE))
		{
			switch(GetPlayerWeapon(playerid))
			{
				case WEAPON_DEAGLE, WEAPON_SHOTGUN, WEAPON_SNIPER:
				{
					ptsLastFiredWeapon[playerid] = gettime();
				}
			}
		}
		else if(PRESSED(KEY_CROUCH))
		{
			if((gettime() - ptsLastFiredWeapon[playerid]) < 1)
			{
				TogglePlayerControllable(playerid, false);

				pCBugging[playerid] = true;

				GameTextForPlayer(playerid, "~r~~h~DON'T C-BUG!", 3000, 4);

				KillTimer(ptmCBugFreezeOver[playerid]);
				ptmCBugFreezeOver[playerid] = SetTimerEx("CBugFreezeOver", 1500, false, "i", playerid);
			}
		}
	}
	return 1;
}

// ** LOAD PLAYER COMPONENTS

stock ResetPlayerVariables(playerid)
{
	// ** GENERAL

	pCBugging[playerid] = false;

	// ** TIMERS

	KillTimer(ptmCBugFreezeOver[playerid]);

	// ** TIMESTAMPS

	ptsLastFiredWeapon[playerid] = 0;
	return 1;
}

// ** FUNCTIONS

forward CBugFreezeOver(playerid);
public CBugFreezeOver(playerid)
{
	TogglePlayerControllable(playerid, true);

	pCBugging[playerid] = false;
	return 1;
}