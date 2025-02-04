enum MUSIC_ENUM
{
	mID,
	mName[64],
	mUrl[128]
}
new PlayerMusic[MAX_PLAYERS][MAX_PLAYER_MUSIC][MUSIC_ENUM];

forward OnMusicInsert(playerid, slot);
forward OnPlayerLoadMusic(playerid);

public OnMusicInsert(playerid, slot)
{
	PlayerMusic[playerid][slot][mID] = cache_insert_id();
	return 1;
}

public OnPlayerLoadMusic(playerid)
{
    for(new i; i != MAX_PLAYER_MUSIC; i++)
   	{
    	PlayerMusic[playerid][i][mID] = 0;
    	PlayerMusic[playerid][i][mUrl] =
    	PlayerMusic[playerid][i][mName] = EOS;
    }
    
    if (!cache_num_rows()) return 1;

    for(new i = 0; i < cache_num_rows(); i++)
	{
     	if (i > MAX_PLAYER_MUSIC) break;
	        
        PlayerMusic[playerid][i][mID] = cache_get_field_content_int(i, "id");
	    cache_get_field_content(i, "name", PlayerMusic[playerid][i][mName], dbHandle, 64);
	    cache_get_field_content(i, "url", PlayerMusic[playerid][i][mUrl], dbHandle, 156);
	}
	return 1;
}

ShowMusicList(playerid)
{
	new string[641];

    for(new i; i != MAX_PLAYER_MUSIC; i++)
   	{
    	if (PlayerMusic[playerid][i][mID] == 0)	format(string, sizeof(string), "%s\n{C3C3C3}Them mot ghi chu...", string);
		else									format(string, sizeof(string), "%s\n%s", string, PlayerMusic[playerid][i][mName]);
    }

	Dialog_Show(playerid, MusicList, DIALOG_STYLE_LIST, "Ban ghi am", string, "Chon", "Quay lai");
	return 1;
}

LoadPlayerMusic(playerid)
{
    new query[128];

	mysql_format(dbHandle, query, sizeof(query), "SELECT * FROM `player_music` WHERE `userid` = %i", PlayerInfo[playerid][pID]);
	mysql_tquery(dbHandle, query, "OnPlayerLoadMusic", "i", playerid);
	return 1;
}

OnPlayerAddMusic(playerid, slot, name[], url[])
{
    new query[128 + 56 + 156];

	mysql_format(dbHandle, query, sizeof(query), "INSERT INTO `player_music` (userid, name, url) VALUES (%i, '%e', '%e')", PlayerInfo[playerid][pID], name, url);
	mysql_tquery(dbHandle, query, "OnMusicInsert", "ii", playerid, slot);
	return 1;
}  



Dialog:MusicList(playerid, response, listitem, inputtext[])
{
	if (!response) return 1;

    SetPVarInt(playerid, #edit_music, listitem);
    
    if (PlayerMusic[playerid][listitem][mID] == 0)
	{
		Dialog_Show(playerid, AddMusic, DIALOG_STYLE_INPUT, "Them ban ghi am", "{FFFFFF}Nhap tieu de cho ban ghi am.\n\nDanh sach cac ky tu duoc phep: A-Я, A-Z, 0-9, \"-\", \"[\", \"]\", \"(\", \")\". Toi da ky tu 64.", ">>>", "Quay lai");
	}
	else
	{
		Dialog_Show(playerid, MyMusic, DIALOG_STYLE_LIST, PlayerMusic[playerid][listitem][mName], "Bat ghi am\nXoa muc nhap", "Chon", "Quay lai");
	}
	return 1;
}

Dialog:MyMusic(playerid, response, listitem, inputtext[])
{
	if (!response) return ShowBoomboxMenu(playerid);
	    
	new music = GetPVarInt(playerid, #edit_music);

	if (listitem == 0)
	{
	    SendSyntaxMessage(playerid, "Ban da bat dau ghi am %s.", PlayerMusic[playerid][music][mName]);
	    ChangeUrlBoombox(playerid, PlayerMusic[playerid][music][mUrl]);
	    return 1;
	}
	
	SendSyntaxMessage(playerid, "Ban ghi am %s da duoc xoa.", PlayerMusic[playerid][music][mName]);
	
	new query[128];
	mysql_format(dbHandle, query, sizeof(query), "DELETE FROM `player_music` WHERE `id` = %i", PlayerMusic[playerid][music][mID]);
	mysql_tquery(dbHandle, query);

	PlayerMusic[playerid][music][mID] = 0;
	PlayerMusic[playerid][music][mName] = EOS;
	PlayerMusic[playerid][music][mUrl] = EOS;
	ShowMusicList(playerid);
	return 1;
}

Dialog:AddMusic(playerid, response, listitem, inputtext[])
{
	if (!response) return ShowMusicList(playerid);

	if (isnull(inputtext) || strlen(inputtext) >= 64)
	{
		return Dialog_Show(playerid, AddMusic, DIALOG_STYLE_INPUT, "Them ban ghi am", "{FFFFFF}Nhap tieu de cho ban ghi am.\n\nDanh sach cac ky tu duoc phep: A-Я, A-Z, 0-9, \"-\", \"[\", \"]\", \"(\", \")\". Toi da ky tu 64.", ">>>", "Huy bo");
	}

	for(new i = 0; i < strlen(inputtext); i++)
	{
		switch(inputtext[i])
		{
			case '!', '@', '#', '$','%','^','&','*','_','+','=','|','{','}','.','`','~','<','>','?',',','/':
			{
				Dialog_Show(playerid, AddMusic, DIALOG_STYLE_INPUT, "Them ban ghi am", "{FFFFFF}Nhap tieu de cho ban ghi am.\n\nDanh sach cac ky tu duoc phep: A-Я, A-Z, 0-9, \"-\", \"[\", \"]\", \"(\", \")\". Toi da ky tu 64.", ">>>", "Quay lai");
				return 1;
			}
			default: continue;
		}
	}
	
	SetPVarString(playerid, #music_add, inputtext);
	Dialog_Show(playerid, AddMusic1, DIALOG_STYLE_INPUT, "Them ban ghi am", "{FFFFFF}Nhap lien ket den ban ghi am.\nHuong dan ve cach them ban ghi am cua ban co the duoc tim thay tren dien dan.", "Them", "Quay lai");
	return 1;
}

Dialog:AddMusic1(playerid, response, listitem, inputtext[])
{
	if (!response) return ShowMusicList(playerid);
		
	if (isnull(inputtext) || strlen(inputtext) >= 128)
	{
		Dialog_Show(playerid, AddMusic1, DIALOG_STYLE_INPUT, "Them ban ghi am", "Enter the link to the audio recording.\nHuong dan ve cach them ban ghi am cua ban co the duoc tim thay tren dien dan.", "Them", "Quay lai");
		return 1;
	}
	//музыка
	new music = GetPVarInt(playerid, #edit_music);
	
	if (music < 0 || music >= MAX_PLAYER_MUSIC || PlayerMusic[playerid][music][mID] != 0) return SendErrorMessage(playerid, "Loi ghi am.");

	GetPVarString(playerid, #music_add, PlayerMusic[playerid][music][mName], 64);
	DeletePVar(playerid, #music_add);
	format(PlayerMusic[playerid][music][mUrl], 128, inputtext);
	OnPlayerAddMusic(playerid, music, PlayerMusic[playerid][music][mName], PlayerMusic[playerid][music][mUrl]);
	ShowMusicList(playerid);

	return 1;
}