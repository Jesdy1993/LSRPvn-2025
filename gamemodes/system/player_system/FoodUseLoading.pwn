#include <YSI\y_hooks>
new Use_@FoodTime[MAX_PLAYERS];

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
	if(newkeys & KEY_YES) {
		if(GetPVarInt(playerid,#UseFood) == 1) {
		    KillTimer(Use_@FoodTime[playerid]);
	        DeletePVar(playerid, #UseFood);
	        DeletePVar(playerid, #UseFoodTask);
	        HideProgress(playerid);
	        RemovePlayerAttachedObject(playerid, 1);
	        ClearAnimations(playerid);
	    }
	}
}
forward LoadingUseFood(playerid,use_type);
public LoadingUseFood(playerid,use_type)
{
	if(GetPVarInt(playerid,#UseFoodTask) >= 100) {
		KillTimer(Use_@FoodTime[playerid]);
		DeletePVar(playerid, #UseFood);
		DeletePVar(playerid, #UseFoodTask);
		HideProgress(playerid);
		RemovePlayerAttachedObject(playerid, 1);
		ClearAnimations(playerid);
		switch(use_type) {
	        case 1: {
	        	ShowNotifyTextMain(playerid,"Ban da an xong mot cai ~r~banh mi",9);
	        	SetPlayerHunger(playerid,1,250.0);

	        }
	        case 2: {
	        	ShowNotifyTextMain(playerid,"Ban da an xong mot cai ~r~Hambuger",9);
	        	SetPlayerHunger(playerid,1,350.0);

	        }
	        case 3: {
	        	ShowNotifyTextMain(playerid,"Ban da an xong mot cai ~r~Pizza",9);
	        	SetPlayerHunger(playerid,1,275.0);
	        }
	        case 4: {
	        	ShowNotifyTextMain(playerid,"Ban da uong mot lon nuoc ~r~Ca phe sua - The Coffee House",9);
	        	SetPlayerHunger(playerid,2,275.0);
	        }
	        case 5: {
	        	ShowNotifyTextMain(playerid,"Ban da an xong mot cai ~r~Ca phe sua - Highlands Coffee",9);
	        	SetPlayerHunger(playerid,2,275.0);
	        }
        }
		return 1;
	}
	SetPVarInt(playerid,#UseFoodTask,GetPVarInt(playerid,#UseFoodTask)+2);
    new str[129];
    format(str,sizeof str, "Dang_su_dung_thuc_an:_%d%s", GetPVarInt(playerid,#UseFoodTask),"%");
	ShowProgress(playerid,str,GetPVarInt(playerid,#UseFoodTask),10);
	ApplyAnimation(playerid,"FOOD","EAT_Burger",3.0,1,0,0,0,0,1);
	return 1;
}
hook OnPlayerDisconnect(playerid, reason) {
	if(GetPVarInt(playerid,#UseFood) == 1) {
		KillTimer(Use_@FoodTime[playerid]);
	    DeletePVar(playerid, #UseFood);
	    DeletePVar(playerid, #UseFoodTask);
	    HideProgress(playerid);
	    RemovePlayerAttachedObject(playerid, 1);
	    ClearAnimations(playerid);
	}
	
}