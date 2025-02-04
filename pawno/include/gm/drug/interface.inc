//camera effect credits goes to Mmartin? or LS-RP dev. Edited by Jewking
new cameraSession[MAX_PLAYERS];

this::SetPlayerCameraEffect(playerid, amount_of_shakes)
{
	if (amount_of_shakes < cameraSession[playerid])
		return 0;

	cameraSession[playerid] = amount_of_shakes;
	return shakeEffects(playerid, 10, false);
}

this::shakeEffects(playerid, interval, bool:status)
{
	if (cameraSession[playerid] <= 0)
		return SetPlayerDrunkLevel(playerid, 0);

	cameraSession[playerid] -- ;
	
	new hour, minute;

	GetPlayerTime(playerid, hour, minute);

	if (hour > 18)	SetPlayerTime(playerid, 12, 0);
	else			SetPlayerTime(playerid, hour + 1, 0);
		
    SetPlayerWeather(playerid, 190);

	if (status) 	SetPlayerDrunkLevel(playerid, 3000);
	else 		SetPlayerDrunkLevel(playerid, 50000);

	return SetTimerEx( "shakeEffects", interval, false, "iii", playerid, interval, !status);
}

MulStringHandler(string[]) // text cut off for drugs effect
{
    new mulstr[160];
	strcat(mulstr, string);
	for(new charSet = 0; charSet < strlen(string); charSet += random(5) + 2) {
	   if (mulstr[charSet] != ' ') {
	      strins(mulstr, ".. ", charSet);
	   }
	}
	return mulstr;
}

chanceHandler(var)
{
	if (var <= 0) 	return 0;
	if (var >= 100) 	return 1;

	new try = random(100), drop = (0);
	for(new i = 0;i <= var-1;i++){
		if (try == i){
			drop = (1);
			break;
		}
	}
	if (drop == 1) return 1;
	return 0;
}