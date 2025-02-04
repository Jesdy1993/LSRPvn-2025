new 
	Text:RadarHud[MAX_PLAYERS],
	VehRadarID[MAX_VEHICLES],
	CheckingSpeed[MAX_VEHICLES],
	OldVehID[MAX_PLAYERS]
;

RadarHud_TD(playerid)
{	
    RadarHud[playerid] = TextDrawCreate(497.9165, 153.2230, "~g~MODEL:~w~_N/A~n~~g~TOC DO:~w~_N/A"); // �����
	TextDrawLetterSize(RadarHud[playerid], speedSettings[PlayerInfo[playerid][pHud]][speedLX], speedSettings[PlayerInfo[playerid][pHud]][speedLY]);
	TextDrawTextSize(RadarHud[playerid], 633.0000, 0.0000);
	TextDrawAlignment(RadarHud[playerid], 1);
	TextDrawColor(RadarHud[playerid], -1);
	TextDrawSetOutline(RadarHud[playerid], 1);
	TextDrawBackgroundColor(RadarHud[playerid], 255);
	TextDrawFont(RadarHud[playerid], speedSettings[PlayerInfo[playerid][pHud]][speedFont]);
	TextDrawSetProportional(RadarHud[playerid], 1);

    return 1;
}

RadarHud_OnGameModeInit()
{
	for (new i = 1; i < MAX_VEHICLES; i++)
	{
	    VehRadarID[i] = -1;
	    CheckingSpeed[i] = 0;
	}
 	
	return 1;
}

GetVehicleInfrontID (vehid)
{
    new Float: temp = 7.0;
	new j = 0;
	for (new i = 1; i <= MAX_VEHICLES; i++)
	{
	    new Float: a, Float: x1, Float: y1, Float: z1, Float: x2, Float: y2, Float: z2;
    	GetVehiclePos (vehid, x1, y1, z1);
    	GetVehicleZAngle (vehid, a);
 		if (i != vehid)
 		{
	 		if (GetVehiclePos (i, x2, y2, z2))
			{
				new Float: distance = floatsqroot (floatpower ((x1 - x2), 2) + floatpower ((y1 - y2), 2) + floatpower ((z1 - z2), 2));
				GetVehicleZAngle (vehid, a);

				if (distance < 15.0)
				{
    				x1 = x1 + (distance * floatsin(-a, degrees));
					y1 = y1 + (distance * floatcos(-a, degrees));

					distance = floatsqroot ((floatpower ((x1 - x2), 2)) + (floatpower ((y1 - y2), 2)));

					if (temp > distance)
					{
						temp = distance;
						j = i;
					}
				}
			}
		}
	}
	if (temp < 15.0) return j;
	return -1;
}

UpdateSpeed(playerid, vehid)
{
    new id = GetVehicleInfrontID (vehid);
	if (id < 0 || id == 0)
	{
		TextDrawSetString(Text:RadarHud[playerid],"~g~MODEL:~w~ N/A~n~~g~TOC DO:~w~ N/A");
	}
	else
	{
		new str[128], 
            plates[16], 
            speed = GetVehicleSpeed(id);

        format(plates, sizeof(plates), "%s", VehicleInfo[id][carPlate]);
		
        format (str, sizeof (str), "~g~MODEL:~w~ %s [%s]~n~~g~TOC DO:~w~ %d km/h", VehicleNames[GetVehicleModel (id) - 400], plates, speed);
		TextDrawSetString(Text:RadarHud[playerid], str);
	}

 	if (IsPlayerInVehicle(playerid, vehid))  	TextDrawShowForPlayer(playerid, RadarHud[playerid]);
    else                                    	TextDrawHideForPlayer(playerid, RadarHud[playerid]);

	return 1;
}

CheckValidTextDraws(playerid)
{
	if (IsPlayerConnected (playerid))
	{
	    if (IsPlayerInAnyVehicle (playerid))
		{
		    new vehid = GetPlayerVehicleID (playerid);
		    if (CheckingSpeed[vehid])
		    {
                UpdateSpeed(playerid, vehid);
		        TextDrawShowForPlayer (playerid, RadarHud[playerid]);
		    }
		    else
		    {
		        TextDrawHideForPlayer (playerid, RadarHud[playerid]);
		    }
		}
			
		else
		{
		    TextDrawHideForPlayer (playerid, RadarHud[playerid]);
		    OldVehID[playerid] = 0;
		}
	}
	return 1;
}

Radar_OnPlayerStateChange(playerid, newstate, oldstate)
{
	if ((oldstate == PLAYER_STATE_ONFOOT) && (newstate == PLAYER_STATE_PASSENGER || newstate == PLAYER_STATE_DRIVER))
	{
	    OldVehID [playerid] = GetPlayerVehicleID (playerid);
	}
	return 1;
}

Radar_OnVehicleDeath(vehicleid)
{
    DestroyObject (VehRadarID [vehicleid]);
    VehRadarID [vehicleid] = -1;
  	CheckingSpeed [vehicleid] = 0;

 	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (IsPlayerInVehicle(i, vehicleid))    TextDrawHideForPlayer (i, RadarHud[i]);
	}
}


CMD:radar(playerid, params[])
{	
    new vehid = GetPlayerVehicleID (playerid);

    if (!IsFactionPolice(PlayerInfo[playerid][pFaction])) 	return SendErrorMessage(playerid, "Ban can phai la canh sat!");
    if (!PlayerInfo[playerid][pOnDuty])				 		return SendErrorMessage(playerid, "Dau tien ban can phai trong gio lam viec.");
    if (!IsFactionPolice(VehicleInfo[vehid][carFaction])) 	return SendErrorMessage(playerid, "Ban can phai trong phuong tien canh sat.");
		
    if (!CheckingSpeed[vehid])
    {
		RadarHud_TD(playerid);

        new Float: x, Float: y, Float: z, Float: a;
        GetVehiclePos (vehid, x, y, z);
        GetVehicleZAngle (vehid, a);
        VehRadarID [vehid] = CreateObject (367, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 300.0);
        AttachObjectToVehicle (VehRadarID [vehid], vehid, 0.2, 0.50, 0.3, 0.0, 0.0, 90.0);
        
        CheckingSpeed [vehid] = 1;

        SendWarningMessage(playerid, "Ban da cai dat radar.");
    }   
    else    
    {
		DestroyObject(VehRadarID [vehid]);
		VehRadarID [vehid] = -1;
		CheckingSpeed [vehid] = 0;

		TextDrawSetString(Text:RadarHud[playerid],"~g~MODEL:~w~ N/A~n~~g~TOC DO:~w~ N/A");
        TextDrawDestroy(RadarHud[playerid]);

        SendWarningMessage(playerid, "Ban da loai bo radar.");
	}
	return 1;
}