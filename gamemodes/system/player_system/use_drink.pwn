#include <YSI\y_hooks>
hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
	if(newkeys & KEY_FIRE) {
		if(GetPVarInt(playerid,#AttachFoodWater) == 1) {
            if(GetPVarInt(playerid,#UseFood) == 1) return SendErrorMessage(playerid," Ban dang su dung vat pham roi.");
			SetPVarInt(playerid, #UseFood, 1);
			PlayAnimEx(playerid, "SMOKING", "M_smk_drag", 4.0, 1, 0, 0, 0, 0, 1);
			ShowNotifyTextMain(playerid,"~r~Drinking water...");
			// task_await task_ms(4000);
			RemovePlayerAttachedObject(playerid, 0);
			DeletePVar(playerid, #AttachFoodWater);
			DeletePVar(playerid, #UseFood);
			SetPlayerHunger(playerid,2,400);
			ClearAnimations(playerid);
		}
		else if(GetPVarInt(playerid,#AttachFoodWater) == 2) {
            if(GetPVarInt(playerid,#UseFood) == 1) return SendErrorMessage(playerid," Ban dang su dung vat pham roi.");
			SetPVarInt(playerid, #UseFood, 1);
			PlayAnimEx(playerid, "SMOKING", "M_smk_drag", 4.0, 1, 0, 0, 0, 0, 1);
			ShowNotifyTextMain(playerid,"~r~Drinking beer...");

			// task_await task_ms(4000);
			
			SetPlayerHunger(playerid,2,50);
			ClearAnimations(playerid);
			DeletePVar(playerid, #UseFood);
			SetPVarInt(playerid, #StockBeer, GetPVarInt(playerid,#StockBeer) + 1);
			new str[129];
			format(str,sizeof(str), "Ban da su dung bia thanh cong, Beer stock: %d/6", GetPVarInt(playerid,#StockBeer)-1);
			SendClientMessageEx(playerid,COLOR_BASIC,str);

            if( GetPVarInt(playerid,#StockBeer) >= 7) {
            	RemovePlayerAttachedObject(playerid, 0);
            	DeletePVar(playerid, #AttachFoodWater);
            	ClearAnimations(playerid);
			    SetPlayerDrunkLevel(playerid, 50000);
			    ShowNotifyTextMain(playerid,"~r~Ban dang say~w~...",8);
			    PlayAnimEx(playerid, "PED", "WALK_DRUNK", 4.0, 1, 1, 1, 1, 1, 1);
               //  task_await task_ms(45000);
			    ClearAnimations(playerid);
			    SetPlayerDrunkLevel(playerid, 0);
            }		
		}
		else if(GetPVarInt(playerid,#AttachFoodWater) == 3) {
            if(GetPVarInt(playerid,#UseFood) == 1) return SendErrorMessage(playerid," Ban dang su dung vat pham roi.");
			SetPVarInt(playerid, #UseFood, 1);
			PlayAnimEx(playerid, "SMOKING", "M_smk_drag", 4.0, 1, 0, 0, 0, 0, 1);
			ShowNotifyTextMain(playerid,"~r~Drinking water...");
			// task_await task_ms(4000);
			RemovePlayerAttachedObject(playerid, 0);
			DeletePVar(playerid, #AttachFoodWater);
			DeletePVar(playerid, #UseFood);
			SetPlayerHunger(playerid,2,200);
			ClearAnimations(playerid);
		}
	}
	return 1;
}
stock DropChaiBia(playerid) {
	if(GetPVarInt(playerid,#UseFood) == 1) return SendErrorMessage(playerid," Ban dang su dung vat pham roi.");
	RemovePlayerAttachedObject(playerid, 0);
    DeletePVar(playerid, #AttachFoodWater);
    return 1;
}