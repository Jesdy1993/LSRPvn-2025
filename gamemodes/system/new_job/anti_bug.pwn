stock AntiTask(playerid, vehicleid) {
	if(BV_Carry[playerid]) {
		new Float:posx,Float:posy,Float:posz;
		GetPlayerPos(playerid, posx, posy, posz);
		SetPlayerPos(playerid, posx, posy, posz+5);
		PlayerPlaySound(playerid, 1130, posx, posy, posz+5);

		DisablePlayerCheckpoint(playerid);
        BV_Checkpoint[playerid] = 0;
        BV_Carry[playerid] = 0;
        RemovePlayerAttachedObject(playerid, 1);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        ClearAnimations(playerid);
        
	}  
	else if( GetPVarInt(playerid,#BoxInHand) == 1){
		new Float:posx,Float:posy,Float:posz;
		GetPlayerPos(playerid, posx, posy, posz);
		SetPlayerPos(playerid, posx, posy, posz+5);
		PlayerPlaySound(playerid, 1130, posx, posy, posz+5);

		RemovePlayerAttachedObject(playerid, 1);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		DropBox(playerid);

	}
	else if(MinerInHand[playerid] == 1 || GetPVarInt(playerid, #IsMining) == 2){
		new Float:posx,Float:posy,Float:posz;
		GetPlayerPos(playerid, posx, posy, posz);
		SetPlayerPos(playerid, posx, posy, posz+5);
		PlayerPlaySound(playerid, 1130, posx, posy, posz+5);

		RemovePlayerAttachedObject(playerid, 1);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		DropMiner(playerid);
	}
}
task UpdateBugLabel[1000]()
{
	foreach( new i : Player) {
        if(GetPlayerSurfingVehicleID(i) != INVALID_VEHICLE_ID) {
        	AntiTask(i, GetPlayerSurfingVehicleID(i));
        }
		if(IsPlayerInAnyVehicle(i)) {
	        if(BV_Carry[i]) {
	        	new Float:posx,Float:posy,Float:posz;
	        	GetPlayerPos(i, posx, posy, posz);
	        	SetPlayerPos(i, posx, posy, posz+5);
	        	PlayerPlaySound(i, 1130, posx, posy, posz+5);
        
	        	DisablePlayerCheckpoint(i);
                BV_Checkpoint[i] = 0;
                BV_Carry[i] = 0;
                RemovePlayerAttachedObject(i, 1);
                SetPlayerSpecialAction(i, SPECIAL_ACTION_NONE);
                ClearAnimations(i);
                
	        }  
	        else if( GetPVarInt(i,#BoxInHand) == 1){
	        	new Float:posx,Float:posy,Float:posz;
	        	GetPlayerPos(i, posx, posy, posz);
	        	SetPlayerPos(i, posx, posy, posz+5);
	        	PlayerPlaySound(i, 1130, posx, posy, posz+5);
        
	        	RemovePlayerAttachedObject(i, 1);
                SetPlayerSpecialAction(i, SPECIAL_ACTION_NONE);
	        	DropBox(i);
        
	        }
	        else if(MinerInHand[i] == 1 || GetPVarInt(i, #IsMining) == 2){
	        	new Float:posx,Float:posy,Float:posz;
	        	GetPlayerPos(i, posx, posy, posz);
	        	SetPlayerPos(i, posx, posy, posz+5);
	        	PlayerPlaySound(i, 1130, posx, posy, posz+5);
	        	
	        	RemovePlayerAttachedObject(i, 1);
                SetPlayerSpecialAction(i, SPECIAL_ACTION_NONE);
	        	DropMiner(i);
	        }
		}
	}
	return 1;
}