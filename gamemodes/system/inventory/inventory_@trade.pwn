new disable_trade = 0;
CMD:duavatpham(playerid,params[]) {
    if(PlayerInfo[playerid][pInjured] != 0) return SendErrorMessage(playerid," Ban khong the su dung lenh nay.");
    if(disable_trade == 1) return 1;
    ShowPlayerGiveItem(playerid);
    return 1;
}
CMD:disabletrade(playerid) {
    if(disable_trade == 0) {
        disable_trade = 1;
        SendClientMessageToAll(COLOR_YELLOW, "[SERVER] Da tat tinh nang /duavatpham.");
    }
    else if(disable_trade == 1) {
        disable_trade = 0;
        SendClientMessageToAll(COLOR_YELLOW, "[SERVER] Da bat tinh nang /duavatpham.");
    }
    return 1;
}
stock ShowPlayerGiveItem(playerid) {
	new string[1299];
	string = "#\tItem\tAmount\n";
	for(new i = 0 ; i < MAX_SLOT_INVENTORY ; i++) {
		if(PlayerInventoryItem[playerid][i] != 0) {
			format(string, sizeof(string), "%s%d\t%s\t%d\n",string,i, ItemInfo[PlayerInventoryItem[playerid][i]][ItemName] , PlayerInventoryAmount[playerid][i]);
		}
		else {
			format(string, sizeof(string), "%s%d\tEmpty\t#\n",string,i, ItemInfo[PlayerInventoryItem[playerid][i]][ItemName] , PlayerInventoryAmount[playerid][i]);
		}
	}
	Dialog_Show(playerid, DIALOG_SEL_GIVEITEM, DIALOG_STYLE_TABLIST_HEADERS, "Inventory # Give", string, "Chon", "Thoat");
	return 1;
}
Dialog:DIALOG_SEL_GIVEITEM(playerid, response, listitem, inputtext[]) {
    if (response) {
    	new item = PlayerInventoryItem[playerid][listitem] ;
    	if(ItemAllowDrop(item) == -1) return SendErrorMessage(playerid," Vat pham nay khong the [GIVE].");
    	if(IsACop(playerid) && isAWeaponItem(item) == 1) return SendErrorMessage(playerid," Ban la canh sat nen vat pham nay khong the [GIVE].");
    	if(PlayerInventoryItem[playerid][listitem] >= 2) {
    		SetPVarInt(playerid, #SelSlotGive, listitem);
    		SetPVarInt(playerid, #SelItemGive, PlayerInventoryItem[playerid][listitem]);
    		new string[128];
    		format(string,sizeof(string),"Inventory # Give %s", ItemInfo[PlayerInventoryItem[playerid][listitem]][ItemName]);
    		Dialog_Show(playerid, DGIVE_AMOUNT, DIALOG_STYLE_INPUT, string ,"{b4b4b4}Vui long nhap so luong vat pham ban muon dua:", "Chon", "Thoat");
    	}

    }
    return 1;
}
Dialog:DGIVE_AMOUNT(playerid, response, listitem, inputtext[]) {
    if (response) {
    	new slot = GetPVarInt(playerid,#SelSlotGive);
    	if(PlayerInventoryAmount[playerid][slot] < strval(inputtext)) return SendErrorMessage(playerid," Ban khong du so luong vat pham.");
    	if(strval(inputtext) < 0 || strval(inputtext) > ItemInfo[PlayerInventoryItem[playerid][slot]][ItemMaxAmount]) return SendErrorMessage(playerid," So luong vuot qua quy dinh."); 
        new string[128], str[129];
    	format(string,sizeof(string),"Inventory # Give %s > %d", ItemInfo[PlayerInventoryItem[playerid][slot]][ItemName],strval(inputtext) );
    	SetPVarInt(playerid,#SelAmountGive,strval(inputtext));
    	format(str,sizeof(str),"{b4b4b4}Give: %s Amount: %d\nVui long nhap ID nguoi choi ban muon dua vat pham:",ItemInfo[PlayerInventoryItem[playerid][slot]][ItemName],strval(inputtext));
    	Dialog_Show(playerid, DGIVE_PLAYER, DIALOG_STYLE_INPUT, string ,str, "Chon", "Thoat");

    }
    return 1;
}
Dialog:DGIVE_PLAYER(playerid, response, listitem, inputtext[]) {
    if (response) {
    	new string[128], str[129];
    	new giveplayerid = strval(inputtext);
        new slot = GetPVarInt(playerid,#SelSlotGive);
        new amount = GetPVarInt(playerid,#SelAmountGive);
        new item = PlayerInventoryItem[playerid][GetPVarInt(playerid,#SelSlotGive)] ;
        if(!IsPlayerConnected(giveplayerid)) {
    	    format(string,sizeof(string),"Inventory # Give %s > %s", ItemInfo[item][ItemName],amount );
    	    SetPVarInt(playerid,#SelAmountGive,strval(inputtext));
    	    format(str,sizeof(str),"{e14848}Nguoi choi chua ket noi toi may chu\n{b4b4b4}Give: %s Amount: %d\nVui long nhap ID nguoi choi ban muon dua vat pham:",ItemInfo[item][ItemName],amount);
    	    Dialog_Show(playerid, DGIVE_PLAYER, DIALOG_STYLE_INPUT, string ,str, "Chon", "Thoat");
        	return 1;
        }
        new Float:X,Float:Y,Float:Z;
        GetPlayerPos(giveplayerid, X,Y,Z);
        if(!IsPlayerInRangeOfPoint(playerid, 5,X,Y,Z)) return  SendErrorMessage(playerid," Ban khong o gan nguoi choi do.");
    	if(PlayerInventoryAmount[playerid][slot] < amount) return SendErrorMessage(playerid," Ban khong du so luong vat pham.");
    	if(GetPVarInt(playerid,#SelItemGive) != item) return SendErrorMessage(playerid," Da co loi xay ra.");
    	if(CheckInventorySlotEmpty(giveplayerid,item,amount) == -1) return SendErrorMessage(playerid,"Tui do cua nguoi choi kia da day khong the nhan vat pham.");
        if(ItemAllowDrop(item) == -1) return SendErrorMessage(playerid," Vat pham nay khong the [GIVE].");
       
        format(string, sizeof(string), "[GIVE-ITEM] ban da dua cho {e14848}%s{b4b4b4} {e14848}%d{b4b4b4} vat pham {e14848}%s",GetPlayerNameEx(giveplayerid), amount,ItemInfo[item][ItemName]);
        SendClientMessageEx(playerid,COLOR_BASIC,string);

        format(string, sizeof(string), "[GIVE-ITEM] {e14848}%s{b4b4b4} da dua cho ban {e14848}%d{b4b4b4} vat pham {e14848}%s.",GetPlayerNameEx(playerid), amount,ItemInfo[item][ItemName]);
        SendClientMessageEx(giveplayerid,COLOR_BASIC,string);

        new string_log[229];
        format(string_log, sizeof(string_log), "[%s] %s(%s) đã đưa cho %s(%s) %d vật phẩm %s", GetLogTime(),GetPlayerNameEx(playerid),GetDiscordUser(playerid),GetPlayerNameEx(giveplayerid),GetDiscordUser(giveplayerid),amount,ItemInfo[item][ItemName]);         
        SendLogDiscordMSG(logs_giveitem, string_log);
    	
    	Inventory_@Add(giveplayerid,item,amount);
    	Inventory_@FineItem(playerid,item,amount);

    	DeletePVar(playerid,#SelSlotGive);
    	DeletePVar(playerid,#SelAmountGive);
    	DeletePVar(playerid,#SelItemGive);

    }
    return 1;
}