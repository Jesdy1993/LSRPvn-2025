Apart_OnPlayerEnterDynamicCP(playerid, checkpointid)
{
    if (GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
    {
        for(new i = 0; i != MAX_APART; i++)
		{
			if (ApartInfo[i][aApartOn] == 0 || checkpointid != ApartInfo[i][aCheckPoint]) continue;

            //SendSyntaxMessage(playerid, "�� ������ �� ������ ������ ���������. �����: %s, %i.", GetApartmentZone(i), i+1);
			//SendHelpMessage(playerid, "/enter, /(ds)hout, /ddo.");

            new string[128];
            format(string, sizeof(string),"~h~~p~Can ho [%i]~n~~y~%s", ApartInfo[i][aID], GetApartmentZone(i, 2)); 
            CreateLableText(playerid, string, "~h~Nhan ~y~~h~'F' ~w~ de vao hoac ~n~nhap ~y~~h~/enter~h~~w~ de vao");
			return 1;
		}
    }
    return 1;
}

Apart_OnGameModeInit()
{
    mysql_tquery(dbHandle, "SELECT * FROM `apartment`", "LoadDynamicApartment");
    return 1;
}