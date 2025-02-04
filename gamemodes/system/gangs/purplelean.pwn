#include <YSI\y_hooks>
new PlayerDrugTask[MAX_PLAYERS];
new PlayerMaxDrugTask[MAX_PLAYERS];
new Timer:MixingPurple[MAX_PLAYERS];
CMD:purplelean(playerid,params[]) {
	if(GetPVarInt(playerid,#PurpleLeanTask) != 0) return SendErrorMessage(playerid, " Ban dang mixing Purple Lean roi.");
    if( Inventory_@CountAmount(playerid,39) < 2 ) return SendErrorMessage(playerid, " Ban khong co Codein khong the pha che.");
    if( Inventory_@CountAmount(playerid,34) < 1 ) return SendErrorMessage(playerid, " Ban can co 1 lon nuoc Sprite.");

    SetPlayerAttachedObject(playerid, 1, 1579, 5, 0.068999,0.069999,-0.045998,-5.6,68.7,-176.3,0.322999,0.342,0.351999); // codein attaach
    SetPlayerAttachedObject(playerid, 2, 2601,6,0.050999,0.044,0.012999,0,0,0,0.578999,0.668,1.228); // spite	
    
    MixingPurple[playerid] = repeat PurpleLeanMix[1000](playerid);
    SetPVarInt(playerid,#PurpleLeanTask,1);
    TogglePlayerControllable(playerid,0);

    PlayAnimEx(playerid, "BOMBER", "BOM_Plant_Loop", 4.0, 1, 0, 0, 0, 0, 1);
    return 1;
}
hook OnPlayerDisconnect(playerid, reason) {
	PlayerDrugTask[playerid] = 0;
    PlayerMaxDrugTask[playerid] = 0;
	stop MixingPurple[playerid];
    DeletePVar(playerid, #PurpleLeanTask);
}
hook OnPlayerConnect(playerid) {
	PlayerDrugTask[playerid] = 0;
    PlayerMaxDrugTask[playerid] = 0;
	stop MixingPurple[playerid];
    DeletePVar(playerid, #PurpleLeanTask);
}
stock ShowDrugStats(playerid) {
	new string[129];
	format(string, sizeof string, "Tinh trang nghien: %ds can hut mot lan\n\
		                           Ban con %ds nua phai su dung drug ", PlayerMaxDrugTask[playerid],PlayerMaxDrugTask[playerid]-PlayerDrugTask[playerid]);
    ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "#DRUG", string, "Xac nhan", "");
}
stock UseDrug(playerid,drugtype) {
	if(PlayerMaxDrugTask[playerid] <= 1) {
		PlayerMaxDrugTask[playerid] = 3600 * 4; // 4 tiếng
		PlayerDrugTask[playerid] = 0;
	}
	if(drugtype == 1) {
		new Float:armour;
		GetPlayerArmour(playerid, armour);
		
		if(armour + 10 >= 20) SetPlayerArmour(playerid, 20);
		else SetPlayerArmour(playerid, armour+10);
		
		SendClientMessageEx(playerid,COLOR_PURPLE,"[DRUG] Ban da su dung Purple Lean thanh cong, [+10 armour]");
		PlayAnim(playerid, "SMOKING", "M_smk_in", 4.0, 0, 0, 0, 0, 0, 1);

		PlayerDrugTask[playerid] -= 3600 / 2;
		if(PlayerDrugTask[playerid] <= 0) PlayerDrugTask[playerid] = 0;
		if(PlayerMaxDrugTask[playerid] >= 3600 /2 ) PlayerMaxDrugTask[playerid] -= 2;
	}

}
timer PurpleLeanMix[1000](playerid) {
    SetPVarInt(playerid,#PurpleLeanTask,GetPVarInt(playerid,#PurpleLeanTask) + 1);
    PlayAnimEx(playerid, "BOMBER", "BOM_Plant_Loop", 4.0, 1, 0, 0, 0, 0, 1);
    ShowProgress(playerid,"~p~Purple lean mixing...",GetPVarInt(playerid,#PurpleLeanTask),2);
    if(GetPVarInt(playerid,#PurpleLeanTask) >= 100) {
    	stop MixingPurple[playerid];
    	DeletePVar(playerid, #PurpleLeanTask);
    	new random_sucess = RandomEx(1,5);
    	if(random_sucess <= 4) {
    	    if( CheckInventorySlotEmpty(playerid,40,1) == -1) return SendErrorMessage(playerid,"Tui do cua ban da day khong the chua vat pham [ + 1 Purple Lean ].");
    		if( Inventory_@CountAmount(playerid,39) < 2 ) return SendErrorMessage(playerid, " Ban khong co Codein khong the pha" );
            if( Inventory_@CountAmount(playerid,34) < 1 ) return SendErrorMessage(playerid, " Ban can co 1 lon nuoc Sprite.");
    		SendClientMessageEx(playerid,COLOR_PURPLE, "[PURPLE LEAN] Ban da pha che thanh cong 1 Purple lean.");
    		Inventory_@FineItem(playerid,39,2);
    		Inventory_@FineItem(playerid,34,1);
    		Inventory_@Add(playerid,40,1);
    		RemovePlayerAttachedObject(playerid, 1);
    		RemovePlayerAttachedObject(playerid, 2);
    		ClearAnimations(playerid);
    		TogglePlayerControllable(playerid,1);
    		HideProgress(playerid);
    	}
    	else if(random_sucess == 5) { 
    		if( Inventory_@CountAmount(playerid,39) < 2 ) return SendErrorMessage(playerid, " Ban khong co Codein khong the pha" );
            if( Inventory_@CountAmount(playerid,34) < 1 ) return SendErrorMessage(playerid, " Ban can co 1 lon nuoc Sprite.");
    		SendClientMessageEx(playerid,COLOR_PURPLE, "[PURPLE LEAN] Ban da pha che that bai.");
    		Inventory_@FineItem(playerid,39,2);
    		Inventory_@FineItem(playerid,34,1);
    		RemovePlayerAttachedObject(playerid, 1);
    		RemovePlayerAttachedObject(playerid, 2);
    		ClearAnimations(playerid);
    		TogglePlayerControllable(playerid,1);
    		HideProgress(playerid);
    	}
    }
    return 1;
}
