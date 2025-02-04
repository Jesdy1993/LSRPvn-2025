#define GameModeText "LS:RP "GameModeVersion"" 
#define WeburlName "http://forum.lsrp.vn/" 
#define ProjectName "[0.3DL] Los Santos Roleplay"
#define ServerName ""ProjectName"" 
#define MAP_NAME "San Andreas"

Server_OnGameModeInit()
{
    SendRconCommand("mapname "MAP_NAME"");
	SendRconCommand("hostname "ServerName"");
    
    DisableInteriorEnterExits();
	ManualVehicleEngineAndLights();
	AllowInteriorWeapons(1);
	EnableStuntBonusForAll(0);
 	DisableNameTagLOS();
	ShowPlayerMarkers(1);
	LimitPlayerMarkerRadius(15.0);
	SetNameTagDrawDistance(15.0);
	SetGameModeText(GameModeText);
	
	//Streamer_SetVisibleItems(STREAMER_TYPE_OBJECT, 800);
	
	AddPlayerClass(0, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
    return 1;
}