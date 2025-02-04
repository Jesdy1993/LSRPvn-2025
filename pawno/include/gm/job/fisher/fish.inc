Fish_OnGamemodeInit()
{
    ActorFish = CreateActor(23,376.2630,-2068.4519,7.8359,273.2589);
    Create3DTextLabel("Cau ca\n Bam Y de tuong tac", -1, 376.2630,-2068.4519,7.8359,100, 0,0);
    return 1;
}

Fish_OnPlayerKeyStateChange(playerid, newkeys) {
    if(newkeys & KEY_YES) {
    	if(IsPlayerInRangeOfActor(playerid, ActorFish))
	    {
		    Dialog_Show(playerid, DialogFish, DIALOG_STYLE_LIST, "Ngu dan", "Mua can cau\nMua moi cau\nBan ca", "Dong y", "Thoat");
	    }
    }
    return 1;
}