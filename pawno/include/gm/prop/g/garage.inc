Garage_OnPlayerEnterDynamicCP(playerid, checkpointid) //��������
{
    if (GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
    {
        for(new i = 0; i < MAX_GARAGES; i++)
		{
		    if (!GarageInfo[i][garageID] || GarageInfo[i][garageCP] != checkpointid) continue;

		    if (GarageInfo[i][garageOwner])
		    {
				SendSyntaxMessage(playerid, "Nha de xe [%i] thuoc ve %s.", GarageInfo[i][garageID], GarageInfo[i][garageOwnerName]);
				SendHelpMessage(playerid, "/enter exit (/g)arage info");

			}
			else if (!GarageInfo[i][garageOwner] && !GarageInfo[i][garageHouse] && !GarageInfo[i][garageBiz])
			{
				SendSyntaxMessage(playerid, "Nha de xe [%i] ban. Gia: $%i.", GarageInfo[i][garageID], GarageInfo[i][garagePrice]);
				SendHelpMessage(playerid, "/enter (/g)arage info (/g)arage buy");

			} 
			else if (!GarageInfo[i][garageOwner] && GarageInfo[i][garageHouse]) 
			{
			    SendSyntaxMessage(playerid, "Nha de xe [%i] nay duoc ban cung voi ngoi nha.", GarageInfo[i][garageID]);
				SendHelpMessage(playerid, "/enter (/g)arage info");

			}
			else if (!GarageInfo[i][garageOwner] && GarageInfo[i][garageBiz])
			{
				SendSyntaxMessage(playerid, "Nha de xe [%i] nay duoc ban cung voi doanh nghiep.", GarageInfo[i][garageID]);
				SendHelpMessage(playerid, "/enter (/g)arage info");
			}
			return 1;
		}
    }
    return 1;
}

Garage_OnGameModeInit()
{
    return mysql_tquery(dbHandle, "SELECT *, (SELECT name FROM users WHERE id = garage.owner) as ownername FROM `garage`", "LoadDynamicGarage");
}