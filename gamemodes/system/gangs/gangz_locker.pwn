
CMD:ganglocker(playerid, params[])
{
	new string[1229];
	if(PlayerInfo[playerid][pFMember] == INVALID_FAMILY_ID) return SendErrorMessage(playerid," Ban khong o trong mot bang dang hay to chuc nao.");
    new v = PlayerInfo[playerid][pFMember];
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, FamilyInfo[v][FamilySafe][0], FamilyInfo[v][FamilySafe][1], FamilyInfo[v][FamilySafe][2]) && GetPlayerVirtualWorld(playerid) == FamilyInfo[v][FamilySafeVW] && GetPlayerInterior(playerid) == FamilyInfo[v][FamilySafeInt]) return SendErrorMessage(playerid, " Ban khong o gan ket sat.");
    string = "Item\t#\tAmount\n";
    for(new i = 0 ; i < 10 ; i++) {
    	new itemid = FamilyInfo[v][fSlot][i];
    	new amount = FamilyInfo[v][fAmount][i];
    	format(string, sizeof string, "%s#%s\t#\t%d\n", string,ItemInfo[itemid][ItemName] ,amount);
    }
	Dialog_Show(playerid, SAFE_MAIN, DIALOG_STYLE_TABLIST_HEADERS, "Gang # Locker", string, "Them", "Thoat");
	return 1;
}
Dialog:SAFE_MAIN(playerid, response, listitem, inputtext[]) {
    if (response) {
    	new header[86];
    	new v = PlayerInfo[playerid][pFMember];
    	new itemid = FamilyInfo[v][fSlot][listitem];
        new string[1229];
    	SetPVarInt(playerid, #SafeSlot, listitem);
    	printf("trunk slot: %d",listitem);

    	if( FamilyInfo[v][fSlot][listitem] <= 1) {
    		
            format(header, sizeof header, "%s Safe's # %s (%d/%d)", FamilyInfo[v][FamilyName],
            	ItemInfo[itemid][ItemName],FamilyInfo[v][fAmount][listitem],ItemInfo[itemid][ItemMaxAmount]);
            string = "#\tItem\tAmount\n";
            for(new i = 0 ; i < MAX_SLOT_INVENTORY; i++) {

            	new item = PlayerInventoryItem[playerid][i];
            	new amount = PlayerInventoryAmount[playerid][i];
            	format(string, sizeof(string), "%s#%d\t%s\t%d\n", string,i,ItemInfo[item][ItemName],amount);



            }
    		Dialog_Show(playerid, SAFE_ADD_INVENTORY, DIALOG_STYLE_TABLIST_HEADERS, header, string, "Them", "Thoat");
    		
    	}

    	else if (FamilyInfo[v][fSlot][listitem] > 1 && FamilyInfo[v][fAmount][listitem]  < ItemInfo[itemid][ItemMaxAmount]  ) 
    	{

            format(header, sizeof header, "%s Safe's # %s (%d/%d)",  FamilyInfo[v][FamilyName],
            	ItemInfo[itemid][ItemName], FamilyInfo[v][fAmount][listitem] ,ItemInfo[itemid][ItemMaxAmount]);
    		Dialog_Show(playerid, SAFE_SELECT, DIALOG_STYLE_LIST, header, "Lay vat pham\nThem vat pham", "Chon", "Thoat");
    	}
    	else if( FamilyInfo[v][fSlot][listitem] > 1 && FamilyInfo[v][fAmount][listitem]  >= ItemInfo[itemid][ItemMaxAmount]  ) 
    	{

            format(header, sizeof header, "%s Safe's # %s (%d/%d)", FamilyInfo[v][FamilyName],
            	ItemInfo[itemid][ItemName], FamilyInfo[v][fAmount][listitem],ItemInfo[itemid][ItemMaxAmount]);
    		Dialog_Show(playerid, SAFE_SELECT, DIALOG_STYLE_LIST, header, "Lay vat pham", "Chon", "Thoat");
    	}
    }
    return 1;
}

Dialog:SAFE_ADD_INVENTORY(playerid, response, listitem, inputtext[]) {
	if(response) {
		new slot = GetPVarInt(playerid,#SafeSlot);
    	new v = PlayerInfo[playerid][pFMember];

		new itemid = PlayerInventoryItem[playerid][listitem];
		new amount = PlayerInventoryAmount[playerid][listitem];
		if( ItemAllowDrop(itemid) == -1) return SendClientMessage(playerid,COLOR_BASIC, "[TRUNK] Vat pham nay khong the cat.");
		if(itemid > 1) {
			Inventory_@Drop(playerid,listitem, amount);

			FamilyInfo[v][fSlot][slot] = itemid;
        	FamilyInfo[v][fAmount][slot] = amount;
        	
        	new string[129];
        	format(string,sizeof(string), "# GANGS SAFE # da them vat pham %s (%d) vao ket sat gangs.",ItemInfo[itemid][ItemName],amount);
        	SendClientMessageEx(playerid,-1,string);
        	
        	format(string, sizeof(string), "* %s da dat vat pham %s ra vao ket sat gang.", GetPlayerNameEx(playerid),ItemInfo[itemid][ItemName]);  
            ProxDetectorWrap(playerid, string, 92, 10.0, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);

            format(string, sizeof(string), "[%s] [ADD NEW ITEM] %s(%s) thêm %d vật phẩm %s két sắt [SQL: Item %d | Amount: %d].", GetLogTime(),GetPlayerNameEx(playerid),GetDiscordUser(playerid),
            	amount,ItemInfo[itemid][ItemName], FamilyInfo[v][fAmount][fSlot],FamilyInfo[v][fAmount][slot]);         
            SendLogDiscordMSG(log_trunk, string);

            SaveFamily(v);

		}
	}
	return 1;
}
Dialog:DIALOG_TAKEAMOUNT(playerid, response, listitem, inputtext[]) {
    if (response) {
    	new slot = GetPVarInt(playerid,#SafeSlot);
    	new v = PlayerInfo[playerid][pFMember];
    	new itemid = FamilyInfo[v][fSlot][slot];
    	new amount = strval(inputtext);
    	if(strval(inputtext) < 0 || strval(inputtext) > 100) return Dialog_Show(playerid, DIALOG_TAKEAMOUNT,DIALOG_STYLE_INPUT,"Gang $ Locker", "Vui long nhap so luong vat pham ban muon lay.","Lay","Thoat");
    	if(FamilyInfo[v][fAmount][slot] < strval(inputtext)) SendErrorMessage(playerid," Khong con du so luong vat pham ban muon lay.");
        if(CheckInventorySlotEmpty(playerid,itemid,amount) == -1) return SendErrorMessage(playerid, " Ban khong the nhan them vat pham, tui do da day.");
        
        Inventory_@Add(playerid,itemid,amount);

        FamilyInfo[v][fAmount][slot] -= strval(inputtext);
        if(FamilyInfo[v][fAmount][slot] <= 0) {
        	FamilyInfo[v][fSlot][slot]  = 1;
            FamilyInfo[v][fAmount][slot] = 0;

        }
        new string[129];
        format(string,sizeof(string), "## GANG SAFE ## Da lay thanh cong %s (%d) ra khoi locker.",ItemInfo[itemid][ItemName],amount);
        SendClientMessageEx(playerid,COLOR_WHITE2,string);

        format(string, sizeof(string), "* %s da lay vat pham %s ra khoi locker.", GetPlayerNameEx(playerid),ItemInfo[itemid][ItemName]);
        ProxDetectorWrap(playerid, string, 92, 10.0, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);

        format(string, sizeof(string), "[%s] [TAKE ITEM] %s(%s) đã lấy %d vật phẩm %s khỏi locker [SQL: Item %d | Amount: %d].", GetLogTime(),GetPlayerNameEx(playerid),GetDiscordUser(playerid)
        ,amount,ItemInfo[itemid][ItemName],PlayerVehicleInfo[playerid][v][pvSlot][slot],PlayerVehicleInfo[playerid][v][pvAmount][slot]);         
        SendLogDiscordMSG(log_trunk, string);

        SaveFamily(v);
    }
    return 1;
}
Dialog:SAFE_SELECT(playerid, response, listitem, inputtext[]) {
    if (response) {
    	new slot = GetPVarInt(playerid,#SafeSlot);
    	new v = PlayerInfo[playerid][pFMember];

    	new itemid = FamilyInfo[v][fSlot][slot];
    	new amount = FamilyInfo[v][fAmount][slot];
        if(listitem == 0) {
        	if(itemid > 1) {
        		if(amount <= 0) {
        			SendErrorMessage(playerid, " Da co loi xay ra, vui long kiem tra lai.");
                    FamilyInfo[v][fSlot][slot]  = 1;
        		    FamilyInfo[v][fAmount][slot] = 0;
        		    SaveFamily(v);
        			return 1;
        		}
        		Dialog_Show(playerid, DIALOG_TAKEAMOUNT,DIALOG_STYLE_INPUT,"Gang $ Locker", "Vui long nhap so luong vat pham ban muon lay.","Lay","Thoat");



        	}
        	else {
        		SendClientMessageEx(playerid,COLOR_BASIC,"## GANG SAFE ## Khong co vat pham nao trong cop xe.");
        	}
        }
        if(listitem == 1) { // add
        	if(Inventory_@CountAmount(playerid,itemid) < 1 ) return SendErrorMessage(playerid, " Ban khong co vat pham nay trong tui do, khong the them.");
        	if( FamilyInfo[v][fSlot][listitem] != 1  ) 
    	    {
                new header[56];
                format(header, sizeof header, "%s Safe's # %s (%d/%d)", FamilyInfo[v][FamilyName],
                	ItemInfo[itemid][ItemName] , FamilyInfo[v][fAmount][listitem],ItemInfo[itemid][ItemMaxAmount]);
    	    	Dialog_Show(playerid, SAFE_ADDITEM, DIALOG_STYLE_INPUT, header, "Ban muon them bao nhieu vat pham ?\nLuu y: khong duoc vuot qua gioi han so luong cua vat pham.", "Them", "Thoat");
    	    }
        }
    }
    return 1;
}
Dialog:SAFE_ADDITEM(playerid, response, listitem, inputtext[]) {
    if (response) {
    	new slot = GetPVarInt(playerid,#SafeSlot);
    	new v = PlayerInfo[playerid][pFMember];
    	new itemid = FamilyInfo[v][fSlot][slot];
    	new amount = FamilyInfo[v][fAmount][slot] ;
    	new str[129];

    	if(strval(inputtext) < 0 || strval(inputtext) > 100) return SendErrorMessage(playerid, " So luong phai tu 0..100");
    	if(Inventory_@CountAmount(playerid,itemid) < strval(inputtext)) {
    		format(str,sizeof(str),"## GANG SAFE ## Ban khong co du %d %s.",
    			strval(inputtext),ItemInfo[itemid][ItemName]);
    		SendClientMessageEx(playerid,COLOR_BASIC,str);
    		return 1;
    	}
    	if((strval(inputtext) + amount ) > ItemInfo[itemid][ItemMaxAmount]) {
    		format(str,sizeof(str),"## GANG SAFE ## So luong ban muon them %d, so luong hien tai: %d da qua gioi han [%d/%d].",
    			strval(inputtext),amount,strval(inputtext) + amount,ItemInfo[itemid][ItemMaxAmount]);
    		SendClientMessageEx(playerid,COLOR_BASIC,str);
    		return 1;
    	}
    	Inventory_@FineItem(playerid,itemid,strval(inputtext));
    	new old_amount = FamilyInfo[v][fAmount][slot] ;
    	FamilyInfo[v][fAmount][slot] += strval(inputtext);
    	format(str,sizeof(str),"## GANG SAFE ## Ban da them thanh cong %d %s vao cop xe.",
    		strval(inputtext),ItemInfo[itemid][ItemName]);
    	SendClientMessageEx(playerid,COLOR_WHITE,str);
    	format(str, sizeof(str), "* %s da dat vat pham %s vao cop xe.", GetPlayerNameEx(playerid),ItemInfo[itemid][ItemName]);
        ProxDetectorWrap(playerid, str, 92, 10.0, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);

        format(str, sizeof(str), "[%s] [ADD ITEM] %s(%s) đã thêm %d vật phẩm %s vào cóp xe [SQL: Item %d | Amount: %d] Lasted %d amount.", GetLogTime(),GetPlayerNameEx(playerid),GetDiscordUser(playerid),
        strval(inputtext),ItemInfo[itemid][ItemName],FamilyInfo[v][fSlot][slot],FamilyInfo[v][fAmount][slot], 
        old_amount);         
        SendLogDiscordMSG(log_trunk, str);

        SaveFamily(v);


        return 1;
    }
    return 1;
}
