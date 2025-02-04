forward FishingProd(playerid);
public FishingProd(playerid) {
    RemovePlayerAttachedObject(playerid, 9);
    ClearAnimations(playerid);
    DeletePVar(playerid, "DangCauCa");
    new type = -1;
    PlayerInfo[playerid][pBait] --;
    switch(random(10)) {
    	case 0: {
    		type = 1;
    	}
    	case 1: {
    		type = 2;
    	}
    	case 3: {
    		type = 3;
    	}
    	case 4: {
    		type = 4;
    	}
    	case 5: {
    		type = 5;
    	}
    	case 6: {
    		type = 6;
    	}
    	case 7: {
    		type = 1;
    	}
    	case 8: {
    		type = 1;
    	}
    	case 9: {
    		type = 1;
    	}
    	case 10: {
    		type = 1;
    	}

    }
    SendSyntaxMessage(playerid, "Ban da cau thanh cong 1 con ca %s", FishingStr[type][fishname]);
    AddTuiCa(playerid, type);
}

stock CheckEmptyTuiCa(playerid) {
	new check = 0;
	for(new i = 0; i < 10 ; i++ ) {
		if(PlayerInfo[playerid][pFish][i] == 0) {
			check = 1; 
			break;
		}
	}
	return check;
}
stock AddTuiCa(playerid, caid) {
	if(CheckEmptyTuiCa(playerid) == 0) return SendClientMessage(playerid,-1,"Tui ca da day");
	for(new i = 0; i < 10 ; i++ ) {
		if(PlayerInfo[playerid][pFish][i] == 0) {
			PlayerInfo[playerid][pFish][i] = caid;
			break ;
		}
	}
	return 1;
}


stock IsPlayerInRangeOfActor(playerid, actorid, Float:radius = 5.0)
{
    new Float:pos[3];
    if (GetActorPos(actorid, pos[0], pos[1], pos[2])) return IsPlayerInRangeOfPoint(playerid, radius, pos[0], pos[1], pos[2]) && GetPlayerVirtualWorld(playerid) == GetActorVirtualWorld(actorid);
    return 0;
}