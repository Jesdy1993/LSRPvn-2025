new login_char_id[MAX_PLAYERS][MAX_CHARACTERS];
new	login_char_name[MAX_PLAYERS][MAX_CHARACTERS][MAX_PLAYER_NAME+1];


#define MAX_SPAWN_POINT 3
new Float: first_spawn[MAX_SPAWN_POINT][4] =
{
    {1370.9784,406.9358,19.7578,65.2299}, // Montgomery
    {2270.2939,-80.9561,26.5435,179.9794}, //  Palomino
	{207.8945,-63.7689,1.5781,185.5103} // Blueberry
};

new Text:Login_TD[5];
new PlayerText:LoginGUIPTD[MAX_PLAYERS][2];
new PlayerText:RegistrationGUI[MAX_PLAYERS][17];
new PlayerText:CharacterPreview[MAX_PLAYERS][3][3];
new PlayerText:CharacterCreate[MAX_PLAYERS][3][3];
new PlayerText:CharacterUsername[MAX_PLAYERS][3][3];
new PlayerText:CharacterMenu[MAX_PLAYERS][9];
new PlayerText:CharacterStats[MAX_PLAYERS][4];
new PlayerText:PlayerGPS[MAX_PLAYERS][2];
new CharSelectSQL[MAX_PLAYERS][3];
new CharSelectSkin[MAX_PLAYERS][3];
new RegisterClicked[MAX_PLAYERS];