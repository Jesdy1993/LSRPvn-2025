#include <YSI\y_hooks>
new PlayerText:Hunger_remake_PTD[MAX_PLAYERS][9];
#define SERVER_FOOD_MAX  1000.0
#define SERVER_WATER_MAX  1000.0
#define SERVER_HUNGER_TIME 500 // 3p

enum Fitness_infor {
	Float:pFitness,
	Float:pFitnessMax,
	Float:pFood,
	Float:pWater,
	GymTask
}
new PlayerFitness[MAX_PLAYERS][Fitness_infor];
new Timer:HungerTimer[MAX_PLAYERS];

timer HungerUpdate[SERVER_HUNGER_TIME * 1000](playerid)
{ 
    if(PlayerInfo[playerid][pInjured] == 0 && gPlayerLogged{playerid} != 0  && GetPVarInt( playerid, "EventToken" ) == 0 && PlayerInfo[playerid][pBeingSentenced] == 0 && GetPVarInt(playerid, "Injured") ==  0 && PlayerInfo[playerid][pHospital] == 0 && PlayerInfo[playerid][pJailTime] == 0) 
    {
        if(PlayerFitness[playerid][pWater] <= 100.0 || PlayerFitness[playerid][pFood] <= 100.0 && AcceptDeath[playerid] == 0) {
            ShowNotifyTextMain(playerid," Co the ban dang rat met moi ~r~hay kiem tra~w~ hunger stats",20);
            SetPlayerDrunkLevel(playerid, 40000);
        }
        if(CheckPlayerHunger(playerid) && PlayerInfo[playerid][pInjured] == 0 ) {
            SetPlayerDrunkLevel(playerid, 0);
            SetPlayerInjured(playerid,  0, 24);
        }
        else {
            new random_hunger;
            random_hunger = 10 + random(20);
            SetPlayerHunger(playerid,1,-random_hunger);
            random_hunger = 10 + random(20);
            SetPlayerHunger(playerid,2,-random_hunger);
        }
        if(PlayerFitness[playerid][pFood] < 0) PlayerFitness[playerid][pFood] = 0;
        if(PlayerFitness[playerid][pWater] < 0) PlayerFitness[playerid][pWater] = 0;
       
    }
    return 1;
}
stock SetPlayerFitnessMax(playerid,Float:add) {
    SendClientMessageEx(playerid,COLOR_YELLOW,"[GYM] Ban da tang 5.0 diem the luc nho vao tap gym, hay co gang luyen tap tiep nhe.");
    PlayerFitness[playerid][pFitnessMax] += add;
	return 1;
}
stock GiveGymTask(playerid) {
    new random_gymtask = 2 + random(5);
    PlayerFitness[playerid][GymTask] += random_gymtask;
    if(PlayerFitness[playerid][GymTask] >= 100) {
        PlayerFitness[playerid][GymTask] = 0;
        SetPlayerFitnessMax(playerid,5.0);
    }
    return 1;
}
stock SetUPFitness@Reg(playerid,isnew = 0) {
    if(isnew == 1) {
    	PlayerFitness[playerid][pFitness] = 500.0;
    	PlayerFitness[playerid][pFitnessMax] = 1000.0;
    	PlayerFitness[playerid][pFood] = 800;
    	PlayerFitness[playerid][pWater] = 800;
    }
    else {
    	PlayerFitness[playerid][pFitness] = PlayerFitness[playerid][pFitnessMax] / 2;
    	PlayerFitness[playerid][pFood] = 800;
    	PlayerFitness[playerid][pWater] = 800;
    }
    return 1;
}
stock CheckPlayerHunger(playerid) {
	if(PlayerFitness[playerid][pFitness] < 10 || PlayerFitness[playerid][pFood] < 10 || PlayerFitness[playerid][pWater] < 10) return 1;
	return 0;
}
stock SetPlayerHunger(playerid,type,Float:add) {
	new str[129];
	switch(type) {
		case 0:
		{
            if((PlayerFitness[playerid][pFitness] + add) >= PlayerFitness[playerid][pFitnessMax] ) PlayerFitness[playerid][pFitness] =  PlayerFitness[playerid][pFitnessMax];
		    else  PlayerFitness[playerid][pFitness] += add;
            format(str, sizeof str, "The luc ~r~%.1f", add);
		    ShowItemMessage(playerid,19556,str,4);
		}
		case 1:
		{
            if((PlayerFitness[playerid][pFood] + add) >= SERVER_FOOD_MAX ) PlayerFitness[playerid][pFood] =  SERVER_FOOD_MAX;
		    else  PlayerFitness[playerid][pFood] += add;
		    format(str, sizeof str, "Doi bung ~r~%.1f", add);
		    ShowItemMessage(playerid,19580,str,4);
		}
		case 2:
		{
            if((PlayerFitness[playerid][pWater] + add) >= SERVER_WATER_MAX ) PlayerFitness[playerid][pWater] =  SERVER_WATER_MAX;
		    else  PlayerFitness[playerid][pWater] += add;
		    format(str, sizeof str, "Khat nuoc ~r~%.1f", add);
		    ShowItemMessage(playerid,1486,str,4);
		}
	}

	return 1;
}

stock UpdateProgressHunger(playerid) {
	if(gPlayerLogged{playerid} != 0 && PlayerInfo[playerid][pHudUI] == 0) {
	    new str[129];
        new Float:food_float = ( PlayerFitness[playerid][pFood] / SERVER_FOOD_MAX) * 100;
        new Float:water_float = ( PlayerFitness[playerid][pWater] / SERVER_WATER_MAX) * 100;

        PlayerTextDrawTextSize(playerid, Hunger_remake_PTD[playerid][3], 17.0000 + ( 0.48 * food_float ), 0.0000); // 48
        PlayerTextDrawTextSize(playerid, Hunger_remake_PTD[playerid][7],17.0000 + ( 0.48 * water_float ), 0.0000);  // 48
     
        format(str, sizeof str, "%.1f%", food_float);
        PlayerTextDrawSetString(playerid, Hunger_remake_PTD[playerid][4], str);
        format(str, sizeof str, "%.1f%", water_float);
        PlayerTextDrawSetString(playerid, Hunger_remake_PTD[playerid][8], str);
    
        for(new i = 0 ; i < 9 ; i++) PlayerTextDrawShow(playerid, Hunger_remake_PTD[playerid][i]);
    }
}
// stock UpdateProgressHunger(playerid) {
//     if(gPlayerLogged{playerid} != 0) {
//         new str[129];
     
//         format(str, sizeof str, "Hunger: %.1f/%.1f", PlayerFitness[playerid][pFood], SERVER_FOOD_MAX);
//         PlayerTextDrawSetString(playerid, Hunger_TextDraw[playerid][2], str);
//         format(str, sizeof str, "Thristy: %.1f/%.1f", PlayerFitness[playerid][pWater], SERVER_WATER_MAX);
//         PlayerTextDrawSetString(playerid, Hunger_TextDraw[playerid][3], str);
//         for(new i = 0 ; i < 4 ; i++) PlayerTextDrawShow(playerid, Hunger_TextDraw[playerid][i]);
//     }
// }
hook OnPlayerDisconnect(playerid, reason) {
    stop HungerTimer[playerid];
}

hook OnPlayerConnect(playerid) {
    HungerTimer[playerid] = repeat HungerUpdate(playerid);
    
    // Òåêñòäðàâû äëÿ èãðîêîâ


    Hunger_remake_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 6.6666, 303.0368, "Box"); // ïóñòî
    PlayerTextDrawLetterSize(playerid, Hunger_remake_PTD[playerid][0], 0.0000, 2.2083);
    PlayerTextDrawTextSize(playerid, Hunger_remake_PTD[playerid][0], 67.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, Hunger_remake_PTD[playerid][0], 1);
    PlayerTextDrawColor(playerid, Hunger_remake_PTD[playerid][0], -1);
    PlayerTextDrawUseBox(playerid, Hunger_remake_PTD[playerid][0], 1);
    PlayerTextDrawBoxColor(playerid, Hunger_remake_PTD[playerid][0], 192);
    PlayerTextDrawBackgroundColor(playerid, Hunger_remake_PTD[playerid][0], 255);
    PlayerTextDrawFont(playerid, Hunger_remake_PTD[playerid][0], 1);
    PlayerTextDrawSetProportional(playerid, Hunger_remake_PTD[playerid][0], 1);
    PlayerTextDrawSetShadow(playerid, Hunger_remake_PTD[playerid][0], 0);
    
    Hunger_remake_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 7.9333, 302.2777, "hud:radar_burgerShot"); // ïóñòî
    PlayerTextDrawTextSize(playerid, Hunger_remake_PTD[playerid][1], 8.0000, 10.0000);
    PlayerTextDrawAlignment(playerid, Hunger_remake_PTD[playerid][1], 1);
    PlayerTextDrawColor(playerid, Hunger_remake_PTD[playerid][1], -1);
    PlayerTextDrawBackgroundColor(playerid, Hunger_remake_PTD[playerid][1], 255);
    PlayerTextDrawFont(playerid, Hunger_remake_PTD[playerid][1], 4);
    PlayerTextDrawSetProportional(playerid, Hunger_remake_PTD[playerid][1], 0);
    PlayerTextDrawSetShadow(playerid, Hunger_remake_PTD[playerid][1], 0);
    
    Hunger_remake_PTD[playerid][2] = CreatePlayerTextDraw(playerid, 19.2000, 305.3926, "Box"); // ïóñòî
    PlayerTextDrawLetterSize(playerid, Hunger_remake_PTD[playerid][2], 0.0000, 0.5414);
    PlayerTextDrawTextSize(playerid, Hunger_remake_PTD[playerid][2], 65.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, Hunger_remake_PTD[playerid][2], 1);
    PlayerTextDrawColor(playerid, Hunger_remake_PTD[playerid][2], -1);
    PlayerTextDrawUseBox(playerid, Hunger_remake_PTD[playerid][2], 1);
    PlayerTextDrawBoxColor(playerid, Hunger_remake_PTD[playerid][2], -2139062062);
    PlayerTextDrawBackgroundColor(playerid, Hunger_remake_PTD[playerid][2], 255);
    PlayerTextDrawFont(playerid, Hunger_remake_PTD[playerid][2], 1);
    PlayerTextDrawSetProportional(playerid, Hunger_remake_PTD[playerid][2], 1);
    PlayerTextDrawSetShadow(playerid, Hunger_remake_PTD[playerid][2], 0);
    
    Hunger_remake_PTD[playerid][3] = CreatePlayerTextDraw(playerid, 19.2000, 305.3926, "Box"); // ïóñòî
    PlayerTextDrawLetterSize(playerid, Hunger_remake_PTD[playerid][3], 0.0000, 0.5605);
    PlayerTextDrawTextSize(playerid, Hunger_remake_PTD[playerid][3], 17.0000, 0.0000); // 48
    PlayerTextDrawAlignment(playerid, Hunger_remake_PTD[playerid][3], 1);
    PlayerTextDrawColor(playerid, Hunger_remake_PTD[playerid][3], -1);
    PlayerTextDrawUseBox(playerid, Hunger_remake_PTD[playerid][3], 1);
    PlayerTextDrawBoxColor(playerid, Hunger_remake_PTD[playerid][3], -488532993);
    PlayerTextDrawBackgroundColor(playerid, Hunger_remake_PTD[playerid][3], 255);
    PlayerTextDrawFont(playerid, Hunger_remake_PTD[playerid][3], 1);
    PlayerTextDrawSetProportional(playerid, Hunger_remake_PTD[playerid][3], 1);
    PlayerTextDrawSetShadow(playerid, Hunger_remake_PTD[playerid][3], 0);
    
    Hunger_remake_PTD[playerid][4] = CreatePlayerTextDraw(playerid, 42.0998, 303.6000, "100%"); // ïóñòî
    PlayerTextDrawLetterSize(playerid, Hunger_remake_PTD[playerid][4], 0.1833, 0.9154);
    PlayerTextDrawAlignment(playerid, Hunger_remake_PTD[playerid][4], 2);
    PlayerTextDrawColor(playerid, Hunger_remake_PTD[playerid][4], 255);
    PlayerTextDrawBackgroundColor(playerid, Hunger_remake_PTD[playerid][4], 255);
    PlayerTextDrawFont(playerid, Hunger_remake_PTD[playerid][4], 1);
    PlayerTextDrawSetProportional(playerid, Hunger_remake_PTD[playerid][4], 1);
    PlayerTextDrawSetShadow(playerid, Hunger_remake_PTD[playerid][4], 0);
    
    Hunger_remake_PTD[playerid][5] = CreatePlayerTextDraw(playerid, 8.3332, 312.9783, "hud:radar_dateDrink"); // ïóñòî
    PlayerTextDrawTextSize(playerid, Hunger_remake_PTD[playerid][5], 7.0000, 10.0000);
    PlayerTextDrawAlignment(playerid, Hunger_remake_PTD[playerid][5], 1);
    PlayerTextDrawColor(playerid, Hunger_remake_PTD[playerid][5], -1);
    PlayerTextDrawBackgroundColor(playerid, Hunger_remake_PTD[playerid][5], 255);
    PlayerTextDrawFont(playerid, Hunger_remake_PTD[playerid][5], 4);
    PlayerTextDrawSetProportional(playerid, Hunger_remake_PTD[playerid][5], 0);
    PlayerTextDrawSetShadow(playerid, Hunger_remake_PTD[playerid][5], 0);
    
    Hunger_remake_PTD[playerid][6] = CreatePlayerTextDraw(playerid, 19.2999, 315.5932, "Box"); // ïóñòî
    PlayerTextDrawLetterSize(playerid, Hunger_remake_PTD[playerid][6], 0.0000, 0.4582);
    PlayerTextDrawTextSize(playerid, Hunger_remake_PTD[playerid][6], 65.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, Hunger_remake_PTD[playerid][6], 1);
    PlayerTextDrawColor(playerid, Hunger_remake_PTD[playerid][6], -1);
    PlayerTextDrawUseBox(playerid, Hunger_remake_PTD[playerid][6], 1);
    PlayerTextDrawBoxColor(playerid, Hunger_remake_PTD[playerid][6], -2139062062);
    PlayerTextDrawBackgroundColor(playerid, Hunger_remake_PTD[playerid][6], 255);
    PlayerTextDrawFont(playerid, Hunger_remake_PTD[playerid][6], 1);
    PlayerTextDrawSetProportional(playerid, Hunger_remake_PTD[playerid][6], 1);
    PlayerTextDrawSetShadow(playerid, Hunger_remake_PTD[playerid][6], 0);
    
    Hunger_remake_PTD[playerid][7] = CreatePlayerTextDraw(playerid, 19.2999, 315.5932, "Box"); // ïóñòî
    PlayerTextDrawLetterSize(playerid, Hunger_remake_PTD[playerid][7], 0.0000, 0.3749);
    PlayerTextDrawTextSize(playerid, Hunger_remake_PTD[playerid][7], 17.0000, 0.0000);  // 48
    PlayerTextDrawAlignment(playerid, Hunger_remake_PTD[playerid][7], 1);
    PlayerTextDrawColor(playerid, Hunger_remake_PTD[playerid][7], -1);
    PlayerTextDrawUseBox(playerid, Hunger_remake_PTD[playerid][7], 1);
    PlayerTextDrawBoxColor(playerid, Hunger_remake_PTD[playerid][7], -1780555350);
    PlayerTextDrawBackgroundColor(playerid, Hunger_remake_PTD[playerid][7], 255);
    PlayerTextDrawFont(playerid, Hunger_remake_PTD[playerid][7], 1);
    PlayerTextDrawSetProportional(playerid, Hunger_remake_PTD[playerid][7], 1);
    PlayerTextDrawSetShadow(playerid, Hunger_remake_PTD[playerid][7], 0);
    
    Hunger_remake_PTD[playerid][8] = CreatePlayerTextDraw(playerid, 42.2999, 313.2702, "100%"); // ïóñòî
    PlayerTextDrawLetterSize(playerid, Hunger_remake_PTD[playerid][8], 0.1833, 0.9154);
    PlayerTextDrawTextSize(playerid, Hunger_remake_PTD[playerid][8], 0.0000, 7.0000);
    PlayerTextDrawAlignment(playerid, Hunger_remake_PTD[playerid][8], 2);
    PlayerTextDrawColor(playerid, Hunger_remake_PTD[playerid][8], 255);
    PlayerTextDrawBackgroundColor(playerid, Hunger_remake_PTD[playerid][8], 255);
    PlayerTextDrawFont(playerid, Hunger_remake_PTD[playerid][8], 1);
    PlayerTextDrawSetProportional(playerid, Hunger_remake_PTD[playerid][8], 1);
    PlayerTextDrawSetShadow(playerid, Hunger_remake_PTD[playerid][8], 0);


}
stock CheckReviveHunger(playerid) {
    if(PlayerInfo[playerid][pInjured] == 4 && PlayerFitness[playerid][pWater] >= 100 && PlayerFitness[playerid][pFood]) {
        TogglePlayerControllable(playerid, 1);
        KillEMSQueue(playerid);
        ClearAnimations(playerid);
        SetPlayerHealth(playerid, 26);
//        playerHelpUp[playerid] = 1;
        PlayerInfo[playerid][pInjured] = 0;
    }
    
}