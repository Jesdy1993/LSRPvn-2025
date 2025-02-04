CMD:trunk(playerid, params[])
{
	if(GetPVarInt(playerid,#IsRepair) == 1) return SendErrorMessage(playerid," Ban dang sua chua xe roi.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "Ban phai xuong xe moi co the sua chua.");

	new string[528],veh=-1,v;
	for(new i = 0 ; i < MAX_VEHICLES ; i++) {
		if(IsValidVehicle(i)) {
			if(IsPlayerInRangeOfVehicle(playerid, i, 2.5)) {
				veh = i;
				break ;
			}
		}
	}
	if(veh == -1) return SendErrorMessage(playerid, " Ban khong o gan bat ki phuong tien nao.");
	v = GetPlayerVehicle(playerid, veh);
    if(v != -1) {
    	SetPVarInt(playerid, #TrunkVehicle, veh);
    	SetPVarInt(playerid, #TrunkVehicleSlot, v);
    	string = "Item\t#\tAmount\n";
    	for(new i = 0 ; i < 5 ; i++) {
    		new itemid = PlayerVehicleInfo[playerid][v][pvSlot][i];
    		new amount = PlayerVehicleInfo[playerid][v][pvAmount][i];
    		format(string, sizeof string, "%s#%s\t#\t%d\n", string,ItemInfo[itemid][ItemName] ,amount);
    	}
	    Dialog_Show(playerid, TRUNK_MAIN, DIALOG_STYLE_TABLIST_HEADERS, "Vehicle # Trunk", string, "Them", "Thoat");
    }
	return 1;
}
Dialog:TRUNK_MAIN(playerid, response, listitem, inputtext[]) {
    if (response) {
    	new header[86];
    	new v = GetPVarInt(playerid, #TrunkVehicleSlot);
    	new itemid = PlayerVehicleInfo[playerid][v][pvSlot][listitem];
        new string[1229];
    	SetPVarInt(playerid, #TrunkSlot, listitem);
    	printf("trunk slot: %d",listitem);

    	if( PlayerVehicleInfo[playerid][v][pvSlot][listitem] <= 1) {
    		
            format(header, sizeof header, "%s Trunk's # %s (%d/%d)", VehicleName[GetVehicleModel(GetPVarInt(playerid,#TrunkVehicle)) - 400],
            	ItemInfo[itemid][ItemName],PlayerVehicleInfo[playerid][v][pvAmount][listitem],ItemInfo[itemid][ItemMaxAmount]);
            string = "#\tItem\tAmount\n";
            for(new i = 0 ; i < MAX_SLOT_INVENTORY; i++) {

            	new item = PlayerInventoryItem[playerid][i];
            	new amount = PlayerInventoryAmount[playerid][i];
            	format(string, sizeof(string), "%s#%d\t%s\t%d\n", string,i,ItemInfo[item][ItemName],amount);



            }
    		Dialog_Show(playerid, TRUNK_ADD_INVENTORY, DIALOG_STYLE_TABLIST_HEADERS, header, string, "Them", "Thoat");
    		
    	}

    	else if ( PlayerVehicleInfo[playerid][v][pvSlot][listitem] > 1 && PlayerVehicleInfo[playerid][v][pvAmount][listitem]  < ItemInfo[itemid][ItemMaxAmount]  ) 
    	{

            format(header, sizeof header, "%s Trunk's # %s (%d/%d)", VehicleName[GetVehicleModel(GetPVarInt(playerid,#TrunkVehicle)) - 400],
            	ItemInfo[itemid][ItemName],PlayerVehicleInfo[playerid][v][pvAmount][listitem],ItemInfo[itemid][ItemMaxAmount]);
    		Dialog_Show(playerid, TRUNK_SELECT, DIALOG_STYLE_LIST, header, "Lay vat pham\nThem vat pham", "Chon", "Thoat");
    	}
    	else if( PlayerVehicleInfo[playerid][v][pvSlot][listitem] > 1 && PlayerVehicleInfo[playerid][v][pvAmount][listitem]  >= ItemInfo[itemid][ItemMaxAmount]  ) 
    	{

            format(header, sizeof header, "%s Trunk's # %s (%d/%d)", VehicleName[GetVehicleModel(GetPVarInt(playerid,#TrunkVehicle)) - 400],
            	ItemInfo[itemid][ItemName],PlayerVehicleInfo[playerid][v][pvAmount][listitem],ItemInfo[itemid][ItemMaxAmount]);
    		Dialog_Show(playerid, TRUNK_SELECT, DIALOG_STYLE_LIST, header, "Lay vat pham", "Chon", "Thoat");
    	}
    }
    return 1;
}

Dialog:TRUNK_ADD_INVENTORY(playerid, response, listitem, inputtext[]) {
	if(response) {
		new slot = GetPVarInt(playerid,#TrunkSlot);
    	new v = GetPVarInt(playerid, #TrunkVehicleSlot);

		new itemid = PlayerInventoryItem[playerid][listitem];
		new amount = PlayerInventoryAmount[playerid][listitem];
		if( ItemAllowDrop(itemid) == -1) return SendClientMessage(playerid,COLOR_BASIC, "[TRUNK] Vat pham nay khong the cat.");
		if(itemid > 1) {
			Inventory_@Drop(playerid,listitem, amount);
			PlayerVehicleInfo[playerid][v][pvSlot][slot] = itemid;
        	PlayerVehicleInfo[playerid][v][pvAmount][slot] = amount;
        	
        	new string[129];
        	format(string,sizeof(string), "[VEHICLE-TRUNK] da them vat pham %s (%d) vao cop xe.",ItemInfo[itemid][ItemName],amount);
        	SendClientMessageEx(playerid,-1,string);
        	
        	format(string, sizeof(string), "* %s da dat vat pham %s ra vao cop xe.", GetPlayerNameEx(playerid),ItemInfo[itemid][ItemName]);  
            ProxDetectorWrap(playerid, string, 92, 10.0, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);

            format(string, sizeof(string), "[%s] [ADD NEW ITEM] %s(%s) thêm %d vật phẩm %s vào cóp xe [SQL: Item %d | Amount: %d].", GetLogTime(),GetPlayerNameEx(playerid),GetDiscordUser(playerid),
            	amount,ItemInfo[itemid][ItemName],PlayerVehicleInfo[playerid][v][pvSlot][slot],PlayerVehicleInfo[playerid][v][pvAmount][slot]);         
            SendLogDiscordMSG(log_trunk, string);
            g_mysql_SaveVehicle(playerid, v);
		}
	}
	return 1;
}
Dialog:TRUNK_SELECT(playerid, response, listitem, inputtext[]) {
    if (response) {
    	new slot = GetPVarInt(playerid,#TrunkSlot);
    	new v = GetPVarInt(playerid, #TrunkVehicleSlot);
    	new itemid = PlayerVehicleInfo[playerid][v][pvSlot][slot];
    	new amount = PlayerVehicleInfo[playerid][v][pvAmount][slot];
        if(listitem == 0) {
        	if(itemid > 1) {
        		if(amount <= 0) {
        			SendErrorMessage(playerid, " Da co loi xay ra, vui long kiem tra lai.");
                    PlayerVehicleInfo[playerid][v][pvSlot][slot] = 1;
        		    PlayerVehicleInfo[playerid][v][pvAmount][slot] = 0;
        			return 1;
        		}
        		if(CheckInventorySlotEmpty(playerid,itemid,amount) == -1) return SendErrorMessage(playerid, " Ban khong the nhan them vat pham, tui do da day.");
        		Inventory_@Add(playerid,itemid,amount);
        		PlayerVehicleInfo[playerid][v][pvSlot][slot] = 1;
        		PlayerVehicleInfo[playerid][v][pvAmount][slot] = 0;
        		new string[129];
        		format(string,sizeof(string), "[VEHICLE-TRUNK] Da lay thanh cong %s (%d) ra khoi cop xe.",ItemInfo[itemid][ItemName],amount);
        		SendClientMessageEx(playerid,-1,string);

        		format(string, sizeof(string), "* %s da lay vat pham %s ra khoi cop xe.", GetPlayerNameEx(playerid),ItemInfo[itemid][ItemName]);
                ProxDetectorWrap(playerid, string, 92, 10.0, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);

                format(string, sizeof(string), "[%s] [TAKE ITEM] %s(%s) đã lấy %d vật phẩm %s khỏi cóp xe [SQL: Item %d | Amount: %d].", GetLogTime(),GetPlayerNameEx(playerid),GetDiscordUser(playerid),
            	amount,ItemInfo[itemid][ItemName],PlayerVehicleInfo[playerid][v][pvSlot][slot],PlayerVehicleInfo[playerid][v][pvAmount][slot]);         
                SendLogDiscordMSG(log_trunk, string);

                g_mysql_SaveVehicle(playerid, v);
        	}
        	else {
        		SendClientMessageEx(playerid,COLOR_BASIC,"[VEHICLE-TRUNK] Khong co vat pham nao trong cop xe.");
        	}
        }
        if(listitem == 1) { // add
        	if(Inventory_@CountAmount(playerid,itemid) < 1 ) return SendErrorMessage(playerid, " Ban khong co vat pham nay trong tui do, khong the them.");
        	if( PlayerVehicleInfo[playerid][v][pvSlot][listitem] != 1  ) 
    	    {
                new header[56];
                format(header, sizeof header, "%s Trunk's # %s (%d/%d)", VehicleName[GetVehicleModel(GetPVarInt(playerid,#TrunkVehicle)) - 400],
                	ItemInfo[itemid][ItemName],PlayerVehicleInfo[playerid][v][pvAmount][listitem],ItemInfo[itemid][ItemMaxAmount]);
    	    	Dialog_Show(playerid, TRUNK_ADDITEM, DIALOG_STYLE_INPUT, header, "Ban muon them bao nhieu vat pham ?\nLuu y: khong duoc vuot qua gioi han so luong cua vat pham.", "Them", "Thoat");
    	    }
        }
    }
    return 1;
}
Dialog:TRUNK_ADDITEM(playerid, response, listitem, inputtext[]) {
    if (response) {
    	new slot = GetPVarInt(playerid,#TrunkSlot);
    	new v = GetPVarInt(playerid, #TrunkVehicleSlot);
    	new itemid = PlayerVehicleInfo[playerid][v][pvSlot][slot];
    	new amount = PlayerVehicleInfo[playerid][v][pvAmount][slot];
    	new str[129];

    	if(strval(inputtext) < 0 || strval(inputtext) > 100) return SendErrorMessage(playerid, " So luong phai tu 0..100");
    	if(Inventory_@CountAmount(playerid,itemid) < strval(inputtext)) {
    		format(str,sizeof(str),"[VEHICLE-TRUNK] Ban khong co du %d %s.",
    			strval(inputtext),ItemInfo[itemid][ItemName]);
    		SendClientMessageEx(playerid,COLOR_BASIC,str);
    		return 1;
    	}
    	if((strval(inputtext) + amount ) > ItemInfo[itemid][ItemMaxAmount]) {
    		format(str,sizeof(str),"[VEHICLE-TRUNK] So luong ban muon them %d, so luong hien tai: %d da qua gioi han [%d/%d].",
    			strval(inputtext),amount,strval(inputtext) + amount,ItemInfo[itemid][ItemMaxAmount]);
    		SendClientMessageEx(playerid,COLOR_BASIC,str);
    		return 1;
    	}
    	Inventory_@FineItem(playerid,itemid,strval(inputtext));
    	new old_amount = PlayerVehicleInfo[playerid][v][pvAmount][slot];
    	PlayerVehicleInfo[playerid][v][pvAmount][slot] += strval(inputtext);
    	format(str,sizeof(str),"[VEHICLE-TRUNK] Ban da them thanh cong %d %s vao cop xe.",
    		strval(inputtext),ItemInfo[itemid][ItemName]);
    	SendClientMessageEx(playerid,COLOR_WHITE,str);
    	format(str, sizeof(str), "* %s da dat vat pham %s vao cop xe.", GetPlayerNameEx(playerid),ItemInfo[itemid][ItemName]);
        ProxDetectorWrap(playerid, str, 92, 10.0, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);

        format(str, sizeof(str), "[%s] [ADD ITEM] %s(%s) đã thêm %d vật phẩm %s vào cóp xe [SQL: Item %d | Amount: %d] Lasted %d amount.", GetLogTime(),GetPlayerNameEx(playerid),GetDiscordUser(playerid),
        strval(inputtext),ItemInfo[itemid][ItemName],PlayerVehicleInfo[playerid][v][pvSlot][slot],PlayerVehicleInfo[playerid][v][pvAmount][slot], 
        old_amount);         
        SendLogDiscordMSG(log_trunk, str);

        g_mysql_SaveVehicle(playerid, v);
        return 1;
    }
    return 1;
}
