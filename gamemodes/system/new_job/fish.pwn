#include <YSI\y_hooks>

new
    Fishing[MAX_PLAYERS],
	FishTimer[MAX_PLAYERS],
	FishTimerr[MAX_PLAYERS];

hook OnPlayerConnect(playerid)
{
   Fishing[playerid] = 0;                 
   FishTimer[playerid] = 0;
   return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
   Fishing[playerid] = 0;                 
   FishTimer[playerid] = 0;
   return 1;
}

forward VaildFishPlace(playerid);
public VaildFishPlace(playerid)
{
	if(IsPlayerConnected(playerid))
	{
	    if(IsPlayerInRangeOfPoint(playerid, 4,403.8266,-2088.7598,7.8359) || IsPlayerInRangeOfPoint(playerid, 4,398.7553,-2088.7490,7.8359))
		{
		    return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid, 4,396.2197,-2088.6692,7.8359) || IsPlayerInRangeOfPoint(playerid, 4,391.1094,-2088.7976,7.8359))
		{
		    return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid, 4,383.4157,-2088.7849,7.8359) || IsPlayerInRangeOfPoint(playerid, 4,374.9598,-2088.7979,7.8359))
		{
		    return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid, 4,369.8107,-2088.7927,7.8359) || IsPlayerInRangeOfPoint(playerid, 4,367.3637,-2088.7925,7.8359))
		{
		    return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid, 4,362.2244,-2088.7981,7.8359) || IsPlayerInRangeOfPoint(playerid, 4,354.5382,-2088.7979,7.8359))
		{
		    return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid, 10,2000.5741,1563.2089,15.3672))
		{
		    return 1;
		}
	}
	return 0;
}

CMD:fish(playerid,params[])
{
	if(IsPlayerInAnyVehicle(playerid)) return SendErrorMessage(playerid, "Ban phai xuong xe de lam dieu nay.");
	if(VaildFishPlace(playerid) && !IsPlayerInAnyVehicle(playerid))
	{
	   // if(cần câu) return SendErrorMessage(playerid,"Ban khong co can cau");
      // if(ham gh cá trên ngươif nếu kh xóa) return SendErrorMessage(playerid,"Hay toi 24/7 de ban ca roi quay lai cau ca tiep.");
		if(Fishing[playerid] == 1) return SendErrorMessage(playerid,"Ban dang cau ca roi.");
		// if(mồi cá == 0) return SendErrorMessage(playerid,"Ban khong co moi cau.");
		// ClearAnimations(playerid);
		SetPlayerAttachedObject(playerid, 4, 18632, 5, 0.217000, 0.089999, -0.139999, -34.000007, 5.899998, -61.399993);
		ApplyAnimation(playerid, "SAMP", "FishingIdle", 4.0, 0, 1, 1, 1, 0, 1);
		Fishing[playerid] = 1;
		
		// mồi câu --
		
		new timer = 20 + random(20);
		FishTimer[playerid] = timer;
		SendClientMessage(playerid, COLOR_BASIC, "[FISHING] Ban dang cau ca, hay doi vai giay.");
		FishTimerr[playerid] = SetTimerEx("Fisher", 1000, 1, "i", playerid);
		GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~w~DANG CAU CA...", 4110, 5);
	}
	else return SendErrorMessage(playerid, "Ban khong trong khu vuc cau ca.");
	return 1;
}

forward Fisher(playerid);
public Fisher(playerid)
{
	FishTimer[playerid]--;
	switch(FishTimer[playerid]) {
		case 1: {
		   new string[128],string2[128];
		   KillTimer(FishTimerr[playerid]);
		   Fishing[playerid] = 0;
		   FishTimer[playerid] = 0;
			ClearAnimations(playerid);
			ApplyAnimation(playerid, "CARRY", "crry_prtial", 2.0, 0, 0, 0, 0, 0);
		   TogglePlayerControllable(playerid, 1);
			RemovePlayerAttachedObject(playerid, 4);
			RandomFish(playerid);
   	}
	   case 7: GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~w~DANG CAU CA...", 4110, 5);
	   case 12: GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~w~DANG CAU CA...", 4110, 5);
	   case 19: GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~w~DANG CAU CA...", 4110, 5);
		case 26: GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~w~DANG CAU CA...", 4110, 5);
		case 33: GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~w~DANG CAU CA...", 4110, 5);
	}
 	return 1;
}

stock RandomFish(playerid)
{
   new rdd = random(100);
   switch(rdd)
   {
		case 0..5:
		{
			// tu add ca'
		}
		case 6..100:
		{
			// tu add ca'
   	}
   }				    			
   return 1;		
}
