
public OnPlayerEnterDynamicArea(playerid, areaid)
{
	foreach(new i: Player)
	{
		if(GetPVarType(i, "pBoomBoxArea"))
		{
			if(areaid == GetPVarInt(i, "pBoomBoxArea"))
			{
				new station[256];
				GetPVarString(i, "pBoomBoxStation", station, sizeof(station));
				if(!isnull(station))
				{
					PlayAudioStreamForPlayerEx(playerid, station, GetPVarFloat(i, "pBoomBoxX"), GetPVarFloat(i, "pBoomBoxY"), GetPVarFloat(i, "pBoomBoxZ"), 30.0, 1);
				}
				return 1;
			}
		}
	}
	if(areaid == audiourlid)
	{
	    PlayAudioStreamForPlayerEx(playerid, audiourlurl, audiourlparams[0], audiourlparams[1], audiourlparams[2], audiourlparams[3], 1);
	}
	return 1;
}

public OnPlayerLeaveDynamicArea(playerid, areaid)
{
	foreach(new i: Player)
	{
		if(GetPVarType(i, "pBoomBoxArea"))
		{
			if(areaid == GetPVarInt(i, "pBoomBoxArea"))
			{
				StopAudioStreamForPlayerEx(playerid);
				return 1;
			}
		}
	}
	if(areaid == audiourlid)
	{
		StopAudioStreamForPlayerEx(playerid);
	}
	return 1;
}