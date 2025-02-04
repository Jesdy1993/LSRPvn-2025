new PlayerAttachItem[MAX_PLAYERS][4];
stock PreviewModelWeaponAttach(playerid) {
	for(new i = 0 ; i < 4 ; i++) {
		PlayerTextDrawSetPreviewModel(playerid, Inventory_Weapon[playerid][i], ItemInfo[PlayerAttachItem[playerid][i]][ItemObject]);
        PlayerTextDrawSetPreviewRot(playerid, Inventory_Weapon[playerid][i], 1.0,1.0,1.0, 1.0);
		if(PlayerAttachItem[playerid][i] == 0) {
        	PlayerTextDrawSetPreviewRot(playerid, Inventory_Weapon[playerid][i], 0,0,0, 100.0);
        }
        PlayerTextDrawShow(playerid, Inventory_Weapon[playerid][i]);
	}
	return 1;
}
stock AddAttachItem(playerid,slot,item) {
    PlayerAttachItem[playerid][slot] = item;
    GivePlayerValidWeapon(playerid,GetWeaponByItemID(PlayerAttachItem[playerid][slot] ),1);
    SetPlayerArmedWeapon(playerid, GetWeaponByItemID(PlayerAttachItem[playerid][slot] ));
    SaveAttachSlot(playerid,slot);
    
    
    new string[128];
    format(string, sizeof(string), "{FF8000}* {C2A2DA}%s cam khau sung %s len tay.", GetPlayerNameEx(playerid),GetWeaponNameEx(GetWeaponByItemID(PlayerAttachItem[playerid][slot] )));
    ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
    ApplyAnimation(playerid, "PYTHON", "python_reload", 4.0, 0, 0, 0, 0, 0, 1);
    ShowNotifyTextMain(playerid,"~g~Trang bi vu khi...",4);

    new string_log[229];
    format(string_log, sizeof(string_log), "[%s] %s(%s) cầm khẩu súng %s trên tay", GetLogTime(),GetPlayerNameEx(playerid),GetDiscordUser(playerid),GetWeaponNameEx(GetWeaponByItemID(PlayerAttachItem[playerid][slot] )));         
    SendLogDiscordMSG(logs_pwp, string_log);   
    return 1;
}
stock RemoveAttachItem(playerid,slot) {
	new weapon,ammo,string[129];
	GetPlayerWeaponData(playerid, GetSlotByItemID(PlayerAttachItem[playerid][slot]), weapon, ammo);
	if(weapon != 0) RemovePlayerWeapon(playerid,weapon);
	Inventory_@Add(playerid,PlayerAttachItem[playerid][slot],1);
	if(ammo > 1 ) Inventory_@Add(playerid,GetItemBySlot(slot),ammo-1);
    PlayerAttachItem[playerid][slot] = 0;
    SaveAttachSlot(playerid,slot);

    format(string,sizeof(string),"[AMMO] Ban da thao vu khi %s xuong, [Invadd + %d %s]",GetWeaponNameEx(weapon),ammo-2,ItemInfo[GetItemBySlot(slot)][ItemName]);
    SendClientMessageEx(playerid,COLOR_BASIC,string);
    ShowNotifyTextMain(playerid,"~r~Da thao vu khi xuong");
    new string_log[229];
    format(string_log, sizeof(string_log), "[%s] %s(%s) đã tháo súng %s", GetLogTime(),GetPlayerNameEx(playerid),GetDiscordUser(playerid),GetWeaponNameEx(weapon));         
    SendLogDiscordMSG(logs_pwp, string_log);   
}

stock ResetAttach(playerid) {
	ResetPlayerWeaponsEx(playerid);
	for(new i = 0 ; i < 4 ; i++) PlayerAttachItem[playerid][i] = 0;
}
stock GetSlotByItemID(itemid) {
	new wp_id;
	switch(itemid) {
		case 21: wp_id = 2;
		case 22: wp_id = 2;
		case 23: wp_id = 2;

		case 24: wp_id = 3;
		case 25: wp_id = 3;

		case 26: wp_id = 4;
		case 27: wp_id = 4;

		case 28: wp_id = 5;
		case 29: wp_id = 5;
	}
	return wp_id;
}
stock GetItemBySlot(itemid){
	new wp_id;
	switch(itemid) {
		case 0: wp_id = 30;
		case 1: wp_id = 31;
		case 2: wp_id = 32;
		case 3: wp_id = 33;
	}
	return wp_id;
}
stock GetWeaponByItemID(itemid){
	new wp_id;
	switch(itemid) {
		case 21: wp_id = 22;
		case 22: wp_id = 23;
		case 23: wp_id = 24;
		case 24: wp_id = 25;
		case 25: wp_id = 27;
		case 26: wp_id = 28;
		case 27: wp_id = 29;
		case 28: wp_id = 30;
		case 29: wp_id = 31;
	}
	return wp_id;
}

/*

    // ammo sung luc
	{30,100,19995,"Dan sung luc","M4"},
	// ammo shotgun
	{31,100,19995,"Dan shotgun","M4"},
	// ammo MP
	{32,100,19995,"Dan tieu lien","M4"},
	// ammo sung truong
	{33,100,19995,"Dan sung truong","M4"}

    list vũ khí hiện tại
    Colt-45 ID: 22 - Model: 346
    Silenced 9mm ID: 23 - Model: 347
    Desert Eagle ID: 24 - Model: 348
    Shotgun ID 25 Model 349
    Combat Shotgun	27 Model 351
    Micro SMG/Uzi 28 model 352
    MP5 ID: 29 Model 353
    AK-47 30 Model 355
    m4 31 model 356          
*/
