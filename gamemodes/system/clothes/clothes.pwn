#include <YSI\y_hooks>

#define BUY_CLOTHES 10001
#define DIALOG_KICK_REG 10002
#define DIALOG_ACCESSORY 10003

stock get_skin_price(i) {
	switch(i) {
	    case 1..264: {
	    	return 200;
	    }
	}
	return 100;
}
stock ShowBuyClothesDialog(playerid) {
	Dialog_Show(playerid, BUY_CLOTHES_INPUT, DIALOG_STYLE_INPUT, "Mua trang phuc", "Vui long nhap ID trang phuc ban muon mua:", "Xac nhan", "Thoat");
}
stock ShowBuyClothes(playerid){
	new vstring[264 * 30];
	for(new i = 1 ; i < 264 ; i++) {

		format(vstring, sizeof(vstring), "%s\n%d\t~g~$%s", vstring, i,number_format(get_skin_price(i)));

	}
	ShowPlayerDialog(playerid, BUY_CLOTHES, DIALOG_STYLE_PREVIEW_MODEL, "Mua trang phuc", vstring, "Xac nhan", "Thoat");
}
hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(dialogid == BUY_CLOTHES) {
		if(response) {
	        if(PlayerInfo[playerid][pCash] < get_skin_price(listitem+1)) return SendErrorMessage(playerid," Ban khong du tien de mua trang phuc nay.");
	        SetPVarInt(playerid,#SelBuyClo,listitem+1);
	        new string[2229],skinid[38];
	        for(new i = 0 ; i < 10 ; i++) {
	        	if(PlayerInfo[playerid][pTrangPhuc][i] == 0) skinid = "{c7302f}Empty";
	        	if(PlayerInfo[playerid][pTrangPhuc][i] >= 1) format(skinid, sizeof(skinid), "{37ad57}%d", PlayerInfo[playerid][pTrangPhuc][i]);
	        	format(string, sizeof(string), "%s\n{b4b4b4}#Clothes {c7302f}%d{b4b4b4}\t#Skin ID: %s", string, i,skinid);
	        	
	        }
	        print(string);
	        Dialog_Show(playerid, SEL_SLOTBUY, DIALOG_STYLE_LIST, "Buy Clothes > Select Slot", string, "Xac nhan", "Thoat");
	    }
	}
	return 1;
}


Dialog:BUY_CLOTHES_INPUT(playerid, response, listitem, inputtext[]) {
	if (response) {
		if(IsValidSkin(strval(inputtext)))
		{
			SetPVarInt(playerid,#SelBuyClo,strval(inputtext));
	        new string[2229],skinid[38];
	        for(new i = 0 ; i < 10 ; i++) {
	        	if(PlayerInfo[playerid][pTrangPhuc][i] == 0) skinid = "{c7302f}Empty";
	        	if(PlayerInfo[playerid][pTrangPhuc][i] >= 1) format(skinid, sizeof(skinid), "{37ad57}%d", PlayerInfo[playerid][pTrangPhuc][i]);
	        	format(string, sizeof(string), "%s\n{b4b4b4}#Clothes {c7302f}%d{b4b4b4}\t#Skin ID: %s", string, i,skinid);
	        	
	        }
	        print(string);
	        Dialog_Show(playerid, SEL_SLOTBUY, DIALOG_STYLE_LIST, "Buy Clothes > Select Slot", string, "Xac nhan", "Thoat");
		}
	}
	return 1;
}
Dialog:SEL_SLOTBUY(playerid, response, listitem, inputtext[]) {
	if (response) {
		if(PlayerInfo[playerid][pTrangPhuc][listitem] != 0) return SendErrorMessage(playerid,"Slot nay khong con trong hay xoa di truoc khi mua them trang phuc.");
	    if(PlayerInfo[playerid][pCash] < get_skin_price(GetPVarInt(playerid, #SelBuyClo))) return SendErrorMessage(playerid," Ban khong du tien de mua trang phuc nay.");
        GivePlayerMoneyEx(playerid,-get_skin_price(GetPVarInt(playerid, #SelBuyClo)));
	    PlayerInfo[playerid][pTrangPhuc][listitem] = GetPVarInt(playerid, #SelBuyClo);
	    new strings[129];
	    format(strings, sizeof(strings),"[CLOTHES] Ban da mua thanh cong trang phuc %d voi gia %s ({c7302f}Slot #%d{b4b4b4}).",GetPVarInt(playerid, #SelBuyClo),number_format(get_skin_price(GetPVarInt(playerid, #SelBuyClo))),listitem);
		SendClientMessageEx(playerid, COLOR_BASIC,strings);

	}
	return 1;
}
Dialog:SELECT_OPTIONCL(playerid, response, listitem, inputtext[]) {
    if (response) {
    	new clothes = GetPVarInt(playerid,#ClotheSlot);
    	new strings[129];
    	if(listitem == 0) 
    	{
		    if(PlayerInfo[playerid][pTrangPhuc][clothes] == 0) return SendClientMessageEx(playerid, COLOR_LIGHTRED, "[ ! ]{FFFFFF} Slot nay chua co trang phuc.");		
		    SetPlayerSkin(playerid, PlayerInfo[playerid][pTrangPhuc][clothes]);
		    PlayerInfo[playerid][pModel] = PlayerInfo[playerid][pTrangPhuc][clothes];
		    format(strings, sizeof(strings),"[CLOTHES] Ban da chon thay trang phuc thanh ({c7302f}Slot #%d{b4b4b4}).",clothes);
		    SendClientMessageEx(playerid, COLOR_BASIC,strings);
    	}
    	if(listitem == 1) {
    		PlayerInfo[playerid][pTrangPhuc][clothes] = 0;
    		format(strings, sizeof(strings),"[CLOTHES] Ban da xoa trang phuc clothes ({c7302f}Slot #%d{b4b4b4}).",clothes);
		    SendClientMessageEx(playerid, COLOR_BASIC,strings);
    	}
    }
    return 1;
}
Dialog:SELECT_CLOTHES(playerid, response, listitem, inputtext[]) {
    if (response) {
    	if(PlayerInfo[playerid][pTrangPhuc][listitem] != 0) {
    		Dialog_Show(playerid, SELECT_OPTIONCL, DIALOG_STYLE_LIST, "My Clothes # Option", "Thay trang phuc\nXoa trang phuc", "Xac nhan", "Thoat");
    	    SetPVarInt(playerid,#ClotheSlot, listitem);
    	}
    	else {
    		SendErrorMessage(playerid," Khong co trang phuc nao o #Slot nay.");
    	}
    }
    return 1;
}

CMD:dbuyclothes(playerid) {
	if(!IsPlayerInRangeOfPoint(playerid, 10.0, 207.0798, -129.1775, 1003.5078))
	{
	    SendErrorMessage(playerid, " Ban khong o gan cua hang quan ao.");
	    return 1;
    }
    ShowBuyClothesDialog(playerid);
	return 1;
}
CMD:buyclothes(playerid) {
	if(!IsPlayerInRangeOfPoint(playerid, 10.0, 207.0798, -129.1775, 1003.5078))
	{
	    SendErrorMessage(playerid, " Ban khong o gan cua hang quan ao.");
	    return 1;
    }
    ShowBuyClothes(playerid);
	return 1;
}
CMD:playerclothes(playerid) {

    new string[1229],skinid[47];
	for(new i = 0 ; i < 10 ; i++) {
		if(PlayerInfo[playerid][pTrangPhuc][i] == 0) {
			skinid = "{c7302f}Empty{b4b4b4}";
		}
		if(PlayerInfo[playerid][pTrangPhuc][i] >= 1) {
			format(skinid, sizeof(skinid), "{37ad57}%d{b4b4b4}", PlayerInfo[playerid][pTrangPhuc][i]);
		} 
		format(string, sizeof(string), "%s\n#Clothes {c7302f}%d{b4b4b4}\t#Skin ID: %s", string, i,skinid);
	}
	print(string);
	Dialog_Show(playerid, SELECT_CLOTHES, DIALOG_STYLE_LIST, "My Clothes", string, "Xac nhan", "Thoat");
	return 1;
}