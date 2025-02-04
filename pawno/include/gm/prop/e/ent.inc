Enterance_OnGameModeInit()
{
	return mysql_tquery(dbHandle, "SELECT * FROM `entrance`", "LoadDynamicEntrance");
}

Ent_OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
	for(new i; i != MAX_ENTRANCE; i++)
	{
		if(!pickup_expire{playerid})
		{
			if (!EntranceInfo[i][entranceOn] || EntranceInfo[i][eEnterPickup] != pickupid) 	continue;
			if (strlen(EntranceInfo[i][eText]) > 1) 
			{
				new string[128];
				format(string, sizeof(string), "%s, %s", EntranceInfo[i][eText], GetEntranceZone(i, 2));
				SendClientMessage(playerid, COLOR_GREEN, string);
				SendClientMessage(playerid, COLOR_WHITE, "Lenh co san: /enter.");
				pickup_expire{playerid} = 5;
			}
		}
		return 1;
	}

	if (PlayerInfo[playerid][pFaction] != 0 && pickupid == Factions[PlayerInfo[playerid][pFaction]][fPickUp])
	{
	    new mes[128];
		/*
		format(mes, sizeof(mes), "_~g~%s", Factions[PlayerInfo[playerid][pFaction]][fName]);
		InfoMSG2(playerid, mes, "~y~/duty ~w~- de mo menu", 5000);*/
		format(mes, sizeof(mes), "~g~%s,~n~~y~/duty ~w~- de mo menu", Factions[PlayerInfo[playerid][pFaction]][fName]);
		InfoMSG(playerid, mes, 5);
	}

	for(new i; i != MAX_JOBS; i++) {
		if (JobsInfo[i][jobOn] != 1) continue;
		if (JobsInfo[i][jobPickUp] == pickupid) {
			new mes[128];
			format(mes, sizeof(mes), "~g~%s,~n~~w~Nhan ~y~ENTER~w~ de mo menu",GetJobName(JobsInfo[i][jobType]));
			InfoMSG(playerid, mes, 5);
			/*
			format(mes, sizeof(mes), "_~r~%s", GetJobName(JobsInfo[i][jobType]));
			InfoMSG2(playerid, mes, "~w~Press ~y~ENTER~w~ de mo menu", 5000);*/
			break;
		}
	}
	
	return 1;
}