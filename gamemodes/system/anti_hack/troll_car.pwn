#include <YSI_Coding\y_hooks>

new PlayerOnVehicle[MAX_PLAYERS];
new playerTrollCar[MAX_PLAYERS],
	playerVehicleOccupied[MAX_PLAYERS];

hook OnPlayerConnect(playerid)
{
	PlayerOnVehicle[playerid] = 0;
	playerTrollCar[playerid] = 0;
	playerVehicleOccupied[playerid] = 0;
}

hook OnPlayerDisconnect(playerid)
{
	PlayerOnVehicle[playerid] = 0;
	playerTrollCar[playerid] = 0;
	playerVehicleOccupied[playerid] = 0;
}


hook OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	playerTrollCar[playerid] = 0;
	PlayerOnVehicle[playerid] = 0;
	PlayerOnVehicle[playerid] = vehicleid;	
	return 1;
}

hook OnPlayerExitVehicle(playerid, vehicleid)
{
	PlayerOnVehicle[playerid] = 0;
	playerTrollCar[playerid] = 0;
	return 1;
}

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
	new vehicleid = GetPlayerVehicleID(playerid),
		string[128];
	if(PlayerInfo[playerid][pMember] == INVALID_GROUP_ID)
	{
		if(oldstate == PLAYER_STATE_ONFOOT && newstate == PLAYER_STATE_DRIVER && vehicleid != PlayerOnVehicle[playerid] && PlayerInfo[playerid][pAdmin] < 1 && PlayerInfo[playerid][pInjured])
		{
			if(vehicleid == 1 || vehicleid == 2)
			{
				new mess[128];
				format(mess, sizeof(mess), "LSRP-AC: %s (PID: %d) co the dang su dung Troll Car (Code #001).", GetPlayerNameEx(playerid), playerid);
			    foreach(new i: Player)
				{
					if(PlayerInfo[i][pAdmin] > 0 )
					{
						SendClientMessageEx(i, COLOR_LIGHTRED, mess);
					}	
				}
				format(mess, sizeof(mess), "[LSRP-AC] %s (%d) da bi kick khoi may chu [Reason: LSRP-AC Airbeak #2-001].", GetPlayerNameEx(playerid), playerid);
				SendClientMessageToAllEx(COLOR_LIGHTRED, mess);

				SetTimerEx("KickPublic", 1000, 0, "d", playerid);
			}
	 		if(vehicleid != PlayerOnVehicle[playerid])
			{
				new mess[128];
				format(mess, sizeof(mess), "LSRP-AC: %s (PID: %d - ID SQL: %d) dang hack troll-car (S: %d-002).", GetPlayerNameEx(playerid), playerid, GetPlayerSQLId(playerid), playerTrollCar[playerid]);
			    foreach(new i : Player)
				{
					if(PlayerInfo[i][pAdmin] > 0)
					{
						SendClientMessageEx(i, COLOR_LIGHTRED, mess);
					}	
				}
				format(mess, sizeof(mess), "[LSRP-AC] %s (%d) da bi kick khoi may chu [Reason: LSRP-AC Airbeak #2-002].", GetPlayerNameEx(playerid), playerid);
				SendClientMessageToAllEx(COLOR_LIGHTRED, mess);

				SetTimerEx("KickPublic", 1000, 0, "d", playerid);
				playerTrollCar[playerid] ++;
			}
			else if(vehicleid == PlayerOnVehicle[playerid]) return 1;
		}
	}
	/*switch(newstate)
	{
		case PLAYER_STATE_DRIVER:
		{
			new vehicleid = GetPlayerVehicleID(playerid),
				string[128];
			format(string, sizeof(string), "(D) %s da len phuong tien %d", GetPlayerNameEx(playerid), vehicleid);
			SendClientMessageToAllEx(COLOR_LIGHTRED, string);

			if(PlayerInfo[playerid][pAdmin] < 1)
			{
				if(PlayerInfo[playerid][pInjured] == 0)
				{
					if(HandCuff[playerid] == 0)
					{
						if(GetPlayerVehicleID(playerid) != PlayerOnVehicle[playerid] )
						{
							new mess[128];
							format(mess, sizeof(mess), "LSRP-AC 1: %s (PID: %d - ID SQL: %d) dang hack troll-car (S: %d).", GetPlayerNameEx(playerid), playerid, GetPlayerSQLId(playerid), playerTrollCar[playerid]);
						    foreach(new i : Player)
							{
								if(PlayerInfo[i][pAdmin] > 0)
								{
									SendClientMessageEx(i, COLOR_LIGHTRED, mess);
								}	
							}
							if(playerTrollCar[playerid] > 5)
							{
								format(mess, sizeof(mess), "AdmCmd: %s (%d) da bi phat hien dang co y dinh su dung cheat boi LSRP-AC #2.", GetPlayerNameEx(playerid), playerid);
								SendClientMessageToAllEx(COLOR_LIGHTRED, mess);
								Kick(playerid);
							}
							format(string, sizeof(string), "1 %s up #%d", GetPlayerNameEx(playerid), playerTrollCar[playerid]);
							SendClientMessageToAllEx(COLOR_LIGHTRED, string);
							playerTrollCar[playerid] ++;
							SetTimerEx("RemoveCheckAC", 10000, false, "i", playerid);
						}
					}
				}
			}
		}
		
		case PLAYER_STATE_PASSENGER:
		{
			new vehicleid = GetPlayerVehicleID(playerid),
				string[128];
			format(string, sizeof(string), "(P) %s da len phuong tien %d", GetPlayerNameEx(playerid), vehicleid);
			SendClientMessageToAllEx(COLOR_LIGHTRED, string);
			if(PlayerInfo[playerid][pAdmin] < 1)
			{
				if(PlayerInfo[playerid][pInjured] == 0)
				{
					if(HandCuff[playerid] == 0)
					{
						if(GetPlayerVehicleID(playerid) != PlayerOnVehicle[playerid])
						{
							new mess[128];
							format(mess, sizeof(mess), "LSRP-AC 2: %s (PID:%d - ID SQL:%s) dang hack troll-car.", GetPlayerNameEx(playerid), playerid, GetPlayerSQLId(playerid));
						    foreach(new i : Player)
							{
								if(PlayerInfo[i][pAdmin] > 0)
								{
									SendClientMessageEx(i, COLOR_LIGHTRED, mess);
								}	
							}
							if(playerTrollCar[playerid] > 5)
							{
								format(mess, sizeof(mess), "AdmCmd: %s (%d) da bi phat hien dang co y dinh su dung cheat boi LSRP-AC #1.", GetPlayerNameEx(playerid), playerid);
								SendClientMessageToAllEx(COLOR_LIGHTRED, mess);
								Kick(playerid);
							}
							else
							{
								format(string, sizeof(string), "2 %s up #%d", GetPlayerNameEx(playerid), playerTrollCar[playerid]);
								SendClientMessageToAllEx(COLOR_LIGHTRED, string);
								playerTrollCar[playerid] ++;
								SetTimerEx("RemoveCheckAC", 10000, false, "i", playerid);
							}
						}
					}
				}
			}
		}
	}*/
	return 1;
}

hook OnVehicleDeath(vehicleid, killerid)
{
	new string[128], mess[128];
	if(PlayerInfo[killerid][pAdmin] < 1 || PlayerInfo[killerid][pMember] == INVALID_GROUP_ID)
	{
		if(!IsVehicleOccupied(vehicleid))
		{
			new v = GetPlayerVehicle(killerid, vehicleid);
			if(v == -1)
			{
				playerVehicleOccupied[killerid]++;
	    		if(playerVehicleOccupied[killerid] == 0)
	    		{
	    			format(string, sizeof(string), "[LSRP Notice] Phuong tien (ID: %d) dang bi %s (%d) lam no.", vehicleid, GetPlayerNameEx(killerid),killerid);
					foreach(new iz : Player)
					{
						if(PlayerInfo[iz][pAdmin] > 0 )
						{
							SendClientMessage(iz, COLOR_LIGHTRED, string);
						}	
					}
					SetTimerEx("RemovePlayerVehOccupied", 10000, 0, "d", killerid);
	    		}
				else if(playerVehicleOccupied[killerid] > 2)
				{
					format(string, sizeof(string), "[LSRP-AC] Phuong tien (ID: %d) dang bi %s (%d) lam no [Nghi van su dung Cheat Car Boom].", vehicleid, GetPlayerNameEx(killerid),killerid);

					foreach(new iz : Player)
					{
						if(PlayerInfo[iz][pAdmin] > 0 )
						{
							SendClientMessage(iz, COLOR_LIGHTRED, string);
						}	
					}
				}
				else if(playerVehicleOccupied[killerid] > 4)
				{
					format(mess, sizeof(mess), "[LSRP-AC] %s (%d) da bi kick khoi may chu [Reason: LSRP-AC Car Boom].", GetPlayerNameEx(killerid), killerid);
					SendClientMessageToAllEx(COLOR_LIGHTRED, mess);

					SetVehicleToRespawn(vehicleid);
					SetTimerEx("KickPublic", 1000, 0, "d", killerid);
				}
			}	
		}		
	}
	return 1;
}

forward RemovePlayerVehOccupied(playerid);
public RemovePlayerVehOccupied(playerid)
{
	playerVehicleOccupied[playerid] = 0;
	return 1;
}