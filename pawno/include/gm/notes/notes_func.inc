forward OnNoteInsert(playerid, noteid);
forward OnPlayerLoadNotes(playerid);

public OnPlayerLoadNotes(playerid)
{
	new rows = cache_num_rows();

	if (!rows) return 1;

	for(new i; i < rows; i++)
	{
	    if (i >= MAX_PLAYER_NOTES) break;

		PlayerNotes[playerid][i][noteID] = cache_get_field_content_int(i, "id");
		cache_get_field_content(i, "text", PlayerNotes[playerid][i][noteText], dbHandle, 128);
		PlayerNotes[playerid][i][noteOn] = 1;
	}
	return 1;
}

public OnNoteInsert(playerid, noteid)
{
	return PlayerNotes[playerid][noteid][noteID] = cache_insert_id();
}

LoadPlayerNotes(playerid)
{
    new query[128];
	mysql_format(dbHandle, query, sizeof(query), "SELECT * FROM `player_notes` WHERE `userid` = %i", PlayerInfo[playerid][pID]);
	mysql_tquery(dbHandle, query, "OnPlayerLoadNotes", "i", playerid);
	return 1;
}