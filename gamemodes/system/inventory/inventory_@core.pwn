#include <YSI\y_hooks>
#include "./system/inventory/inventory_@variables.pwn"
#include "./system/inventory/inventory_@textdraw.pwn"
#include "./system/inventory/inventory_@attach.pwn"
#include "./system/inventory/inventory_@data.pwn"
#include "./system/inventory/inventory_@pickup.pwn"
#include "./system/inventory/inventory_@trade.pwn"
#include "./system/inventory/inventory_@pd.pwn"
hook OnPlayerConnect(playerid) {
	for(new i = 0 ; i < MAX_SLOT_INVENTORY ; i++) {
	    PlayerInventoryItem[playerid][i] = 1;
        PlayerInventoryAmount[playerid][i] = 0;
	}
	for(new i = 0 ; i < 4 ; i++) PlayerAttachItem[playerid][i] = 0;

	CreateInventoryTD(playerid);
}
CMD:inventory_test(playerid,params[]) return ShowPlayerInventory(playerid);

CMD:dropitem(playerid,params[]) return Inventory_@FineItem(playerid,2,strval(params));
CMD:itemlist(playerid,params[]) {
	new string[2299];
	string = "Item\tID\t#\n";
	for(new i = 2 ; i < sizeof(ItemInfo); i++) {

		format(string, sizeof string, "%s\n%s\t%d\t#",  string,ItemInfo[i][ItemName], ItemInfo[i][ItemID]  );

	}

	ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_TABLIST_HEADERS, "Item @ List", string, "Xac nhan", "Dong");
	return 1;
}
CMD:additem(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] >= 99999)
	{
		new string[128], itemid, money;
		if(sscanf(params, "dd", itemid, money)) return SendUsageMessage(playerid, " /additem [itemid] [so luong]");
        if(itemid < 0 || itemid > 50) return SendErrorMessage(playerid,"Loi khong thuc hien duoc.");
		if(money < 1) return SendClientMessageEx(playerid, COLOR_GRAD1, "So luong khong duoc nho hon 1");
		Inventory_@Add(playerid,itemid,money);

		format(string, sizeof(string), "[ADD-ITEM]Ban da nhan duoc %d Item %s.",money,ItemInfo[itemid][ItemName]);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
	}
	else
	{
		SendErrorMessage(playerid, "Ban khong the su dung lenh nay");
	}
	return 1;
}

CMD:addfuel(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] >= 99999)
	{
		new vehicleid, xang;
		if(sscanf(params, "dd", vehicleid, xang)) return SendUsageMessage(playerid, " /additem [itemid] [so luong]");
        SendServerMessage(playerid, "Fixed vehicles");
		VehicleFuel[vehicleid] = xang;
	}
	else
	{
		SendErrorMessage(playerid, "Ban khong the su dung lenh nay");
	}
	return 1;
}

stock ShowPlayerInventory(playerid,page = 0) {
	new string[129];
	if(GetPVarInt(playerid, #Inv@SelSlot) != -1) {
		DeletePVar(playerid, #Inv@SelSlot);
	    PlayerTextDrawColor(playerid,  Inventory_@Slot[playerid][GetPVarInt(playerid, #Inv@SelSlot)], -1);
	    PlayerTextDrawShow(playerid,Inventory_@Slot[playerid][GetPVarInt(playerid, #Inv@SelSlot)]);
	}
	for(new i = 0 ; i < 16 ; i++) {
		PlayerTextDrawHide(playerid,  Inventory_@Slot[playerid][i]);
		PlayerTextDrawHide(playerid,  Inventory_@Amount[playerid][i]);
		new inv_slot = i + ( 16 * page),item_id = PlayerInventoryItem[playerid][inv_slot];

		PlayerTextDrawSetPreviewModel(playerid, Inventory_@Slot[playerid][i], ItemInfo[item_id][ItemObject]);
		PlayerTextDrawSetPreviewRot(playerid, Inventory_@Slot[playerid][i], 1.0,1.0,1.0, 1.0);
		if(PlayerInventoryItem[playerid][inv_slot] == 1) {
        	PlayerTextDrawSetPreviewRot(playerid, Inventory_@Slot[playerid][i], 0,0,0, 100.0);
        }
		if(item_id > 1 ) {
			format(string, sizeof string, "%s~n~(~r~%d~w~)",ItemInfo[item_id][ItemName], PlayerInventoryAmount[playerid][inv_slot]);
	        PlayerTextDrawSetString(playerid,  Inventory_@Amount[playerid][i], string);
	        PlayerTextDrawShow(playerid,  Inventory_@Amount[playerid][i]);
		}
		PlayerTextDrawShow(playerid,  Inventory_@Slot[playerid][i]);
		
	}
    new str[48];
    format(str,sizeof str,"%d/%d",page+1,INVENTORY_MAX_PAGE);
    PlayerTextDrawSetString(playerid, 	Inventory_@Main[playerid][4], str);
    format(str,sizeof str,"%s",GetPlayerNameEx(playerid));
    PlayerTextDrawSetString(playerid,  Inventory_@Main[playerid][13], str);


    PreviewModelWeaponAttach(playerid);
	for(new i = 0 ; i < 14 ; i ++) {

		PlayerTextDrawShow(playerid, Inventory_@Main[playerid][i]);
	}
	SelectTextDraw(playerid, COLOR_LIGHTRED);
	SetPVarInt(playerid, #Inv@Page, page);
	SetPVarInt(playerid, #Inv@Open, 1);
	SetPVarInt(playerid, #Inv@SelSlot, -1);
	return 1;
}
stock UpdateInventory(playerid,slot) {
	new page = slot / 16,string[129];
	new inventory_update_slot = slot - ( 16 * page );
    if(GetPVarInt(playerid, #Inv@Open) != 1) return 1;
    if(page == GetPVarInt(playerid, #Inv@Page) ) {

    	PlayerTextDrawSetPreviewModel(playerid, Inventory_@Slot[playerid][inventory_update_slot], ItemInfo[PlayerInventoryItem[playerid][slot]][ItemObject]);
        PlayerTextDrawSetPreviewRot(playerid, Inventory_@Slot[playerid][inventory_update_slot], 1.0,1.0,1.0, 1.0);
        if(PlayerInventoryItem[playerid][slot] == 1) {
        	PlayerTextDrawSetPreviewRot(playerid, Inventory_@Slot[playerid][inventory_update_slot], 0,0,0, 100.0);
        }
        format(string, sizeof string, "%s~n~(~r~%d~w~)",ItemInfo[PlayerInventoryItem[playerid][slot]][ItemName], PlayerInventoryAmount[playerid][slot]);
	    PlayerTextDrawSetString(playerid,  Inventory_@Amount[playerid][inventory_update_slot], string);
	    PlayerTextDrawShow(playerid,  Inventory_@Amount[playerid][inventory_update_slot]);

	    if(PlayerInventoryAmount[playerid][slot] > 1) PlayerTextDrawShow(playerid,  Inventory_@Amount[playerid][inventory_update_slot]);
	    if(PlayerInventoryAmount[playerid][slot] <= 0) PlayerTextDrawHide(playerid, Inventory_@Amount[playerid][inventory_update_slot]);

        PlayerTextDrawShow(playerid, Inventory_@Slot[playerid][inventory_update_slot]);
        SaveInventory(playerid);
    }
    return 1;
}

stock HideInventory(playerid) {
	if(GetPVarInt(playerid, #Inv@SelSlot) != -1 )PlayerTextDrawColor(playerid,  Inventory_@Slot[playerid][GetPVarInt(playerid, #Inv@SelSlot)], -1); 		
	for(new i = 0 ; i < 16 ; i++) {
		PlayerTextDrawHide(playerid,  Inventory_@Amount[playerid][i]);
		PlayerTextDrawHide(playerid,  Inventory_@Slot[playerid][i]);
	}
	for(new i = 0 ; i < 14 ; i ++) {
		PlayerTextDrawHide(playerid, Inventory_@Main[playerid][i]);
	}
	for(new i = 0 ; i < 4 ; i ++) {
		PlayerTextDrawHide(playerid, Inventory_Weapon[playerid][i]);
	}
	DeletePVar(playerid, #Inv@Page);
	DeletePVar(playerid, #Inv@Open);
	SetPVarInt(playerid, #Inv@SelSlot, -1);
	CancelSelectTextDraw(playerid);
}
stock ItemAllowDrop(itemid) {
	new allowdrop = -1;
	switch(itemid) {
		case 4,10,11,12,13,14,21,22,23,24,25,26,27,28,29: allowdrop = 1;
		case 30,31,32,33,34,35: allowdrop = 1;
		case 36,37,38,39,40,41: allowdrop = 1;
	}
	return allowdrop;
}

stock CheckItemAmount(playerid,item_add) {
	new amount = 0;
	for(new i = 0; i < MAX_SLOT_INVENTORY; i++) {
		if(PlayerInventoryItem[playerid][i] == item_add ) {
            amount += PlayerInventoryAmount[playerid][i]; 
        }
	}
	if(amount == 0) return -1;
    return 1;
}

stock CheckInventorySlotEmpty(playerid,item_add,amount_add) {
	new slot_empty = 0;
	for(new i = 0; i < MAX_SLOT_INVENTORY; i++) {
		if(PlayerInventoryItem[playerid][i] == item_add && PlayerInventoryAmount[playerid][i] < ItemInfo[item_add][ItemMaxAmount] ) {
            slot_empty += ItemInfo[item_add][ItemMaxAmount] - PlayerInventoryAmount[playerid][i]; 
        }
        else if(PlayerInventoryItem[playerid][i] == 1) {
        	slot_empty += ItemInfo[item_add][ItemMaxAmount]; 
        }
	}
	if(slot_empty < amount_add) return -1;
    return 1;
}

stock Inventory_@Add(playerid, itemid, amount)
{
    if(amount > ItemInfo[itemid][ItemMaxAmount] * 5) return 1; // Maximun x2 max slot
    if(amount == 0) return 1;
    new slot_add = -1,soduamount;
    for(new i = 0; i < MAX_SLOT_INVENTORY; i++) {
        if(PlayerInventoryItem[playerid][i] == itemid && PlayerInventoryAmount[playerid][i] < ItemInfo[itemid][ItemMaxAmount] ) {
            slot_add = i;

            break ;
        }
    }
   
    if(slot_add == -1) {
        for(new i = 0; i < MAX_SLOT_INVENTORY; i++) {
            if(PlayerInventoryItem[playerid][i] == 1) {
                slot_add = i;
                
                if( amount > ItemInfo[itemid][ItemMaxAmount]) {
                    PlayerInventoryItem[playerid][slot_add] = itemid;
                    PlayerInventoryAmount[playerid][slot_add] = ItemInfo[itemid][ItemMaxAmount]; 
                    Inventory_@Add(playerid, itemid,amount - ItemInfo[itemid][ItemMaxAmount] );
                    SaveInventory(playerid);
                    UpdateInventory(playerid,slot_add);
                }
                else {
                    PlayerInventoryItem[playerid][slot_add] = itemid;
                    PlayerInventoryAmount[playerid][slot_add] = amount;
                    SaveInventory(playerid);
                    UpdateInventory(playerid,slot_add);
                }
                break;
            }
        }
        return 1;
    }

    if( (PlayerInventoryAmount[playerid][slot_add] + amount) > ItemInfo[itemid][ItemMaxAmount]) {
        soduamount = amount - (ItemInfo[itemid][ItemMaxAmount] - PlayerInventoryAmount[playerid][slot_add]);
        PlayerInventoryAmount[playerid][slot_add] += ItemInfo[itemid][ItemMaxAmount] - PlayerInventoryAmount[playerid][slot_add];
        Inventory_@Add(playerid, itemid,soduamount);
    }
    else {
        PlayerInventoryAmount[playerid][slot_add] += amount;
    }
    new str[129];
    format(str, sizeof str, "~g~+%d %s", amount,ItemInfo[itemid][ItemName]);
    ShowItemMessage(playerid,ItemInfo[itemid][ItemObject],str,10);
    SaveInventory(playerid);
    UpdateInventory(playerid,slot_add);
    return 1;
   
}
stock Inventory_@Drop(playerid,slot, amount) 
{
    if(PlayerInventoryAmount[playerid][slot] <= 0) return 1;
    if((PlayerInventoryAmount[playerid][slot] - amount ) <= 0 ) 
    {

        PlayerInventoryItem[playerid][slot] = 1;
        PlayerInventoryAmount[playerid][slot] = 0;
    }
    else 
    {
        PlayerInventoryAmount[playerid][slot] -= amount;
    }
   
    SaveInventory(playerid);
    UpdateInventory(playerid,slot);
    return 1;
}
stock Inventory_@CheckSlot(playerid,itemid) {

	for(new i = 0; i < MAX_SLOT_INVENTORY; i++ ) {
        if(PlayerInventoryItem[playerid][i] == itemid && PlayerInventoryAmount[playerid][i] > 0) {
        	return i;
        }
    }
    return -1;
}
stock isAWeaponItem(i) {
	switch(i) {
		case 21..33: return 1;
	}
	return 0;
}
stock Inventory_@ResetWeapon(playerid) {
    for(new i = 0 ; i < MAX_SLOT_INVENTORY ; i++) {
    	if(isAWeaponItem(PlayerInventoryItem[playerid][i]) == 1 ) {
    		Inventory_@Drop(playerid,i,PlayerInventoryAmount[playerid][i]);
    	}
    }
	return 1;
}
forward Inventory_@FineItem(playerid, itemid, amount);
public Inventory_@FineItem(playerid, itemid, amount)
{
	if(amount <= 0) return 1;
	if(Inventory_@CheckSlot(playerid,itemid) != -1) {
		if(amount > 0) {
			new i = Inventory_@CheckSlot(playerid,itemid);
			printf("check slot = %d",i);
			new amount_fined = amount - PlayerInventoryAmount[playerid][i];
			Inventory_@Drop(playerid,i, amount);
			if(amount_fined >= 1) {
                Inventory_@FineItem(playerid,itemid, amount_fined);
			}
            UpdateInventory(playerid,i);
            return 1;
		}	
		new str[129];
        format(str, sizeof str, "~r~-%d %s", amount,ItemInfo[itemid][ItemName]);
        ShowItemMessage(playerid,ItemInfo[itemid][ItemObject],str,10);
        SaveInventory(playerid);
	}
    return 1;
}
stock Inventory_@CountSlot(playerid) {
	new count ;
	for(new i = 0; i < MAX_SLOT_INVENTORY;i++ ) {
        if(PlayerInventoryAmount[playerid][i] != 0) {
    		count++;
    	}
	}
	return count;
}
stock Inventory_@ItemCheck(playerid,itemid) {
	new slot = -1;
    for(new i = 0; i < MAX_SLOT_INVENTORY;i++ ) {
    	if(PlayerInventoryAmount[playerid][i] == itemid) {
    		slot = i;
    		break ;
    	}
    }
    return slot;
}

stock Inventory_@InforShow(playerid, itemid) {
	new str[329];
	format(str, sizeof str, "%s", ItemInfo[itemid][ItemInfor] );
	ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_LIST, "Thong tin vat pham", str, "Dong", "");
}
stock Inventory_@CountAmount(playerid,itemid) {
	new amount = 0;
	for(new i = 0 ; i < MAX_SLOT_INVENTORY ; i++) {
		if(PlayerInventoryItem[playerid][i] == itemid && PlayerInventoryAmount[playerid][i] > 0 ) {
			amount += PlayerInventoryAmount[playerid][i];
		}
	}
	return amount;
}
stock Inventory_@Use(playerid,itemid,slot = -1) {
    switch(itemid) {
    	case 2: {
            HideInventory(playerid);
	        cmd_phone(playerid,"");
    	}
    	case 3: {
            HideInventory(playerid);
            ShowPlayerGPS(playerid);
	   	}
	
        case 34: {
            HideInventory(playerid);
            if(PlayerInfo[playerid][pInjured] == 4) {
            	ShowNotifyTextMain(playerid,"~r~Drinking...");
			//     task_await task_ms(4000);
			    ShowNotifyTextMain(playerid,"~g~Ban da uong nuoc...");
			    Inventory_@FineItem(playerid,34,1);
			    SetPlayerHunger(playerid,2,200);
			    CheckReviveHunger(playerid);
			    return 1;
            }
	        if( PlayerCuffed[playerid] >= 1 || GetPVarInt(playerid, "Injured") == 1)
		    {
		      	SendErrorMessage(playerid, "Khong the su dung ngay luc nay.");
		      	return 1;
		    }
		    if(IsPlayerAttachedObjectSlotUsed(playerid, 0) || GetPlayerWeapon(playerid) != 0) return SendErrorMessage(playerid," Ban dang cam tren tay mot vat khac.");
		    if(PlayerInfo[playerid][pInjured] != 0) return SendErrorMessage(playerid, " Ban khong the su dung hanh dong nay.");
		    SetPlayerAttachedObject(playerid, 0, 2601,6,0.050999,0.044,0.012999,0,0,0,0.578999,0.668,1.228); // spite		 
		    Inventory_@FineItem(playerid,34,1);
		    SetPVarInt(playerid, #AttachFoodWater, 1);
		    ShowNotifyTextMain(playerid,"Ban dang ~r~Lon nuoc~w~ tren tay, bam ~r~Chuot trai~w~ de su dung");
    	}
    	case 35: {
            HideInventory(playerid);
            if(PlayerInfo[playerid][pInjured] == 4) {
            	ShowNotifyTextMain(playerid,"~r~Drinking...");
			//     task_await task_ms(4000);
			    ShowNotifyTextMain(playerid,"~g~Ban da uong nuoc...");
			    Inventory_@FineItem(playerid,35,1);
			    SetPlayerHunger(playerid,2,200);
			    CheckReviveHunger(playerid);

			    return 1;
            }
	        if( PlayerCuffed[playerid] >= 1 || GetPVarInt(playerid, "Injured") == 1 )
		    {
		      	SendErrorMessage(playerid, "Khong the su dung ngay luc nay.");
		      	return 1;
		    }
		    if(IsPlayerAttachedObjectSlotUsed(playerid, 0) || GetPlayerWeapon(playerid) != 0) return SendErrorMessage(playerid," Ban dang cam tren tay mot vat khac.");
		    if(PlayerInfo[playerid][pInjured] != 0) return SendErrorMessage(playerid, " Ban khong the su dung hanh dong nay.");
		    SetPlayerAttachedObject(playerid, 0, 19822,6,0.037,0.054999,-0.145999,0.099999,3.7,-36.9,0.562999,0.57,0.664); // bia
		    Inventory_@FineItem(playerid,35,1);
		    SetPVarInt(playerid, #AttachFoodWater, 2);
		    SetPVarInt(playerid, #StockBeer, 1);
		    ShowNotifyTextMain(playerid,"Ban dang ~r~Chai bia~w~ tren tay, bam ~r~Chuot trai~w~ de su dung");
    	}
        case 4: {
            HideInventory(playerid);
	        if( PlayerCuffed[playerid] >= 1 || GetPVarInt(playerid, "Injured") == 1 )
		    {
		      	SendErrorMessage(playerid, "Ban khong the su dung lenh nay.");
		      	return 1;
		    }
		    new string[128];
		    SetPlayerSpecialAction(playerid,SPECIAL_ACTION_SMOKE_CIGGY);
		    format(string, sizeof(string), "* %s da lay mot dieu thuoc ra va cham lua.", GetPlayerNameEx(playerid));
		    ProxDetector(15.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		    Inventory_@FineItem(playerid,4,1);
    	}
    	case 5: {
            HideInventory(playerid);
	        if(GetPlayerVehicleCount(playerid) != 0)
			{
				SetPVarInt(playerid, "lockmenu", 1);
			    for(new i=0; i<MAX_PLAYERVEHICLES; i++)
                {
				     if(PlayerVehicleInfo[playerid][i][pvId] != INVALID_PLAYER_VEHICLE_ID)
				     {
				     	new string[129];
	                    format(string, sizeof(string), "Phuong tien %d | Ten phuong tien: %s.",i+1,GetVehicleName(PlayerVehicleInfo[playerid][i][pvId]));
	                    SendClientMessageEx(playerid, COLOR_WHITE, string);
				     }
			    }
			    ShowPlayerDialog(playerid, DIALOG_CDLOCKMENU, DIALOG_STYLE_INPUT, "Khoa xe"," Vui long chon mot chiec xe ma ban muon khoa:", "Lua chon", "Huy bo");
			}
			else return SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong co chiec xe nao - Ban muon cai dat no len dau?");
    	}
    	case 6: {
            HideInventory(playerid);
	        if(GetPlayerVehicleCount(playerid) != 0)
			{
				SetPVarInt(playerid, "lockmenu", 2);
			    for(new i=0; i<MAX_PLAYERVEHICLES; i++)
                {
				     if(PlayerVehicleInfo[playerid][i][pvId] != INVALID_PLAYER_VEHICLE_ID)
				     {
				     	new string[129];
	                    format(string, sizeof(string), "Phuong tien %d | Ten phuong tien: %s.",i+1,GetVehicleName(PlayerVehicleInfo[playerid][i][pvId]));
	                    SendClientMessageEx(playerid, COLOR_WHITE, string);
				     }
			    }
			    ShowPlayerDialog(playerid, DIALOG_CDLOCKMENU, DIALOG_STYLE_INPUT, "Khoa xe"," Vui long chon mot chiec xe ma ban muon khoa:", "Lua chon", "Huy bo");
			}
			else return SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong co chiec xe nao - Ban muon cai dat no len dau?");
    	}
    	case 8: {
            HideInventory(playerid);
            Dialog_Show(playerid, ID_CARD_SEL, DIALOG_STYLE_LIST, "ID-Card @ Select", "ID-Card\nShow ID-Card:", "Xac nhan", "huy bo");

	   	}
    	case 9: {
     		if(IsAtATM(playerid) || IsPlayerInRangeOfPoint(playerid, 15.0, 2308.7346, -11.0134, 26.7422))
	        {
                new ti[42],string[230];
	            format(ti, sizeof ti, "Tai khoan ngan hang cua %s", GetPlayerNameEx(playerid));
	            format(string, sizeof string, "Ten chu the\t\t\t\t{8b3721}%s{ffffff}\nSo tai khoan\t\t\t\t{eae000}%d{ffffff}\nSo du trong vi\t\t\t\t{289c59}$%s{ffffff}\n___________________\nChuyen tien\nGui tien\nRut tien", GetPlayerNameEx(playerid),PlayerInfo[playerid][pSoTaiKhoan],number_format(PlayerInfo[playerid][pAccount]));
	            ShowPlayerDialog(playerid, DIALOG_BANK, DIALOG_STYLE_LIST, ti, string, "Tuy chon", "Thoat");
            }
            else {
            	new str[129];
        	    format(str, sizeof str, "So tai khoan cua ban la: %d\nHay den ngan hang hoac ATM de su dung", PlayerInfo[playerid][pSoTaiKhoan]);
        	    ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX,"Phone", str, "Dong y", "Thoat");
            }
    		
    	}
    	case 10: {
    		if(GetPVarInt(playerid,#UseFood) == 1) return SendErrorMessage(playerid,"Ban dang su dung thuc an vui long doi.");
    		if(PlayerFitness[playerid][pFood] >= SERVER_FOOD_MAX) return SendErrorMessage(playerid,"Ban da qua no roi khong the tiep tuc su dung.");
    		if(PlayerInfo[playerid][pInjured] == 4) {
            	ShowNotifyTextMain(playerid,"~r~Eating...");
			//     task_await task_ms(4000);
			    ShowNotifyTextMain(playerid,"~g~Ban da an banh xong...");
			    Inventory_@FineItem(playerid,10,1);
			    SetPlayerHunger(playerid,1,200);
			    CheckReviveHunger(playerid);
			    return 1;
            }
            if(PlayerInfo[playerid][pInjured] != 0) return SendErrorMessage(playerid,"Ban dang bi thuong.");

    		SetPlayerAttachedObject(playerid,1, 19579, 6);//left hand
    		SetPVarInt(playerid, #UseFood, 1); // count down 20s
    		ApplyAnimation(playerid,"FOOD","EAT_Burger",3.0,1,0,0,0,0,1);
    		Inventory_@FineItem(playerid,10,1);
    		SetPVarInt(playerid,#UseFoodTask,0);
    		ShowNotifyTextMain(playerid,"Bam ~r~'Y'~w~ de huy hanh dong.",9);
    		Use_@FoodTime[playerid] = SetTimerEx("LoadingUseFood", 100, true, "dd", playerid,1);
    		HideInventory(playerid);
    	}
    	case 11: {
    		if(GetPVarInt(playerid,#UseFood) == 1) return SendErrorMessage(playerid,"Ban dang su dung thuc an vui long doi.");
    		if(PlayerFitness[playerid][pFood] >= SERVER_FOOD_MAX) return SendErrorMessage(playerid,"Ban da qua no roi khong the tiep tuc su dung.");
    		if(PlayerInfo[playerid][pInjured] == 4) {
            	ShowNotifyTextMain(playerid,"~r~Eating...");
			//     task_await task_ms(4000);
			    ShowNotifyTextMain(playerid,"~g~Ban da an banh xong...");
			    Inventory_@FineItem(playerid,11,1);
			    SetPlayerHunger(playerid,1,200);
			    CheckReviveHunger(playerid);
			    return 1;
            }
            if(PlayerInfo[playerid][pInjured] != 0) return SendErrorMessage(playerid,"Ban dang bi thuong.");
    		SetPlayerAttachedObject(playerid,1, 2703, 6);//left hand
    		SetPVarInt(playerid, #UseFood, 1); // count down 20s
    		ApplyAnimation(playerid,"FOOD","EAT_Burger",3.0,1,0,0,0,0,1);
    		Inventory_@FineItem(playerid,11,1);
    		SetPVarInt(playerid,#UseFoodTask,0);
    		ShowNotifyTextMain(playerid,"Bam ~r~'Y'~w~ de huy hanh dong.",9);
    		Use_@FoodTime[playerid] = SetTimerEx("LoadingUseFood", 100, true, "dd", playerid,2);
    		HideInventory(playerid);
    	}
    	case 12: {
    		if(GetPVarInt(playerid,#UseFood) == 1) return SendErrorMessage(playerid,"Ban dang su dung thuc an vui long doi.");
    		if(PlayerFitness[playerid][pFood] >= SERVER_FOOD_MAX) return SendErrorMessage(playerid,"Ban da qua no roi khong the tiep tuc su dung.");
    		if(PlayerInfo[playerid][pInjured] == 4) {
            	ShowNotifyTextMain(playerid,"~r~Eating...");
			//     task_await task_ms(4000);
			    ShowNotifyTextMain(playerid,"~g~Ban da an banh xong...");
			    Inventory_@FineItem(playerid,12,1);
			    SetPlayerHunger(playerid,1,200);
			    CheckReviveHunger(playerid);
			    return 1;
            }
            if(PlayerInfo[playerid][pInjured] != 0) return SendErrorMessage(playerid,"Ban dang bi thuong.");
    		SetPlayerAttachedObject(playerid,1, 19580, 6);//left hand
    		ApplyAnimation(playerid,"FOOD","EAT_Burger",3.0,1,0,0,0,0,1);
    		SetPVarInt(playerid, #UseFood, 1);  // count down 20s
    		Inventory_@FineItem(playerid,12,1);
    		SetPVarInt(playerid,#UseFoodTask,0);
    		ShowNotifyTextMain(playerid,"Bam ~r~'Y'~w~ de huy hanh dong.",9);
    		Use_@FoodTime[playerid] = SetTimerEx("LoadingUseFood", 100, true, "dd", playerid,3);
    		HideInventory(playerid);
    	}
    	case 13: {
    		HideInventory(playerid);
	        if( PlayerCuffed[playerid] >= 1 || GetPVarInt(playerid, "Injured") == 1 )
		    {
		      	SendErrorMessage(playerid, "Khong the su dung ngay luc nay.");
		      	return 1;
		    }
		    if(IsPlayerAttachedObjectSlotUsed(playerid, 0) || GetPlayerWeapon(playerid) != 0) return SendErrorMessage(playerid," Ban dang cam tren tay mot vat khac.");
		    if(PlayerInfo[playerid][pInjured] == 4) {
            	ShowNotifyTextMain(playerid,"~r~Drinking...");
			//     task_await task_ms(4000);
			    ShowNotifyTextMain(playerid,"~g~Ban da uong nuoc...");
			    Inventory_@FineItem(playerid,35,1);
			    SetPlayerHunger(playerid,2,200);
			    CheckReviveHunger(playerid);
			    return 1;
            }
            if(PlayerInfo[playerid][pInjured] != 0) return SendErrorMessage(playerid,"Ban dang bi thuong.");
		    SetPlayerAttachedObject(playerid, 0, 19822,6,0.037,0.054999,-0.145999,0.099999,3.7,-36.9,0.562999,0.57,0.664); // bia
		    Inventory_@FineItem(playerid,13,1);
		    SetPVarInt(playerid, #AttachFoodWater, 3);
		    ShowNotifyTextMain(playerid,"Ban dang ~r~Chai nuoc~w~ tren tay, bam ~r~Chuot trai~w~ de su dung");
    	}
    	case 14: {
    		HideInventory(playerid);
	        if( PlayerCuffed[playerid] >= 1 || GetPVarInt(playerid, "Injured") == 1  || PlayerInfo[playerid][pInjured] != 0)
		    {
		      	SendErrorMessage(playerid, "Khong the su dung ngay luc nay.");
		      	return 1;
		    }
		    if(IsPlayerAttachedObjectSlotUsed(playerid, 0) || GetPlayerWeapon(playerid) != 0) return SendErrorMessage(playerid," Ban dang cam tren tay mot vat khac.");
		    SetPlayerAttachedObject(playerid, 0, 19822,6,0.037,0.054999,-0.145999,0.099999,3.7,-36.9,0.562999,0.57,0.664); // bia
		    Inventory_@FineItem(playerid,14,1);
		    SetPVarInt(playerid, #AttachFoodWater, 3);
		    ShowNotifyTextMain(playerid,"Ban dang ~r~Chai nuoc~w~ tren tay, bam ~r~Chuot trai~w~ de su dung");
    	}
    	case 19: {
    		if(GetPVarInt(playerid,"Spraytag:Spraying") == 1) return SendErrorMessage(playerid,"Ban dang su dung binh son roi.");
    		if (PlayerInfo[playerid][pFMember] == INVALID_FAMILY_ID || PlayerInfo[playerid][pRank] < 5)
	        {
	        	SendErrorMessage(playerid, "Ban khong phai Leader cua mot Gangs.");
	        	return 1;
	        }
	        new spid = IsPlayerRangeSpraytag(3.0, playerid);
            if (spid == -1) return SendErrorMessage(playerid,"Vui long khoi tao 1 Spraytag (/spray > khoitao ).");
            HideInventory(playerid);
            cmd_graffiti(playerid,"");
 
    	}

    	case 21,22,23: { // sung luc slot 0
    		if( PlayerAttachItem[playerid][0] != 0) return SendErrorMessage(playerid," Ban dang cam vu khi o #slot-Sung luc roi.");
            AddAttachItem(playerid,0,itemid);
            Inventory_@Drop(playerid,slot,1);
            PreviewModelWeaponAttach(playerid);
    	}
        case 24,25: { // shotgun slot 1
    		if( PlayerAttachItem[playerid][1] != 0) return SendErrorMessage(playerid," Ban dang cam vu khi o #slot-Shotgun roi.");
            AddAttachItem(playerid,1,itemid);
            Inventory_@Drop(playerid,slot,1);
            PreviewModelWeaponAttach(playerid);
    	}
    	case 26,27: { // shotgun slot 1
    		if( PlayerAttachItem[playerid][2] != 0) return SendErrorMessage(playerid," Ban dang cam vu khi o #slot-Tieu lien roi.");
            AddAttachItem(playerid,2,itemid);
            Inventory_@Drop(playerid,slot,1);
            PreviewModelWeaponAttach(playerid);
    	}
    	case 28,29: { // shotgun slot 1
    		if( PlayerAttachItem[playerid][3] != 0) return SendErrorMessage(playerid," Ban dang cam vu khi o #slot-Truong roi.");
            AddAttachItem(playerid,3,itemid);

            Inventory_@Drop(playerid,slot,1);
            PreviewModelWeaponAttach(playerid);
    	}

    	case 30: { // luc slot 1
    		if( PlayerAttachItem[playerid][0] == 0) return SendErrorMessage(playerid," Ban chua trang bi vu khi sung luc nao.");
    		new string[129],weaponname[32];
    		new weaponid = GetWeaponByItemID(PlayerAttachItem[playerid][0]);
    		GetWeaponName(weaponid, weaponname, sizeof(weaponname));
    		format(string, sizeof(string), "{b4b4b4}Vui long nhap so dan ban muon them cho vu khi: {df3838}%s", weaponname);
            Dialog_Show(playerid, ADD_AMMO0, DIALOG_STYLE_INPUT,"Weapon @ Add Ammo",string , "Dong y", "Thoat");
            SetPVarInt(playerid, #SlotAmmo, slot);
    	}
    	case 31: { // shotgun slot 1
    		if( PlayerAttachItem[playerid][1] == 0) return SendErrorMessage(playerid," Ban chua trang bi vu khi sung Shotgun nao.");
    		new string[129],weaponname[32];
    		new weaponid = GetWeaponByItemID(PlayerAttachItem[playerid][1]);
    		GetWeaponName(weaponid, weaponname, sizeof(weaponname));
    		format(string, sizeof(string), "{b4b4b4}Vui long nhap so dan ban muon them cho vu khi: {df3838}%s", weaponname);
            Dialog_Show(playerid, ADD_AMMO1, DIALOG_STYLE_INPUT,"Weapon @ Add Ammo",string , "Dong y", "Thoat");
            SetPVarInt(playerid, #SlotAmmo, slot);
    	}
    	case 32: { // mp slot 1
    		if( PlayerAttachItem[playerid][2] == 0) return SendErrorMessage(playerid," Ban chua trang bi vu khi sung Tieu lien nao.");
    		new string[129],weaponname[32];
    		new weaponid = GetWeaponByItemID(PlayerAttachItem[playerid][2]);
    		GetWeaponName(weaponid, weaponname, sizeof(weaponname));
    		format(string, sizeof(string), "{b4b4b4}Vui long nhap so dan ban muon them cho vu khi: {df3838}%s", weaponname);
            Dialog_Show(playerid, ADD_AMMO2, DIALOG_STYLE_INPUT,"Weapon @ Add Ammo",string, "Dong y", "Thoat");
            SetPVarInt(playerid, #SlotAmmo, slot);
    	}
    	case 33: { // truong slot 1
    		if( PlayerAttachItem[playerid][3] == 0) return SendErrorMessage(playerid," Ban chua trang bi vu khi sung Truong tu dong nao.");
    		new string[129],weaponname[32];
    		new weaponid = GetWeaponByItemID(PlayerAttachItem[playerid][3]);
    		GetWeaponName(weaponid, weaponname, sizeof(weaponname));
    		format(string, sizeof(string), "{b4b4b4}Vui long nhap so dan ban muon them cho vu khi: {df3838}%s", weaponname);
            Dialog_Show(playerid, ADD_AMMO3, DIALOG_STYLE_INPUT,"Weapon @ Add Ammo",string , "Dong y", "Thoat");
            SetPVarInt(playerid, #SlotAmmo, slot);
    	}
    	case 37: {
    		OnUseItemMask(playerid) ;
    		Inventory_@Drop(playerid,slot,1);
    	}
    	case 40: {
    		new Float:armour;
    		GetPlayerArmour(playerid, armour);
    		if(armour >= 20) return SendErrorMessage(playerid, " Ban khong the su dung Purple Lean luc nay.");
    		UseDrug(playerid,1);
    		Inventory_@Drop(playerid,slot,1);
    	}
    }
    return 1;
	
}

stock Inventory@ESC(playerid, Text:clickedid) {
	if(GetPVarInt(playerid,#Inv@Open) != 0) {
	    if(clickedid == Text:INVALID_TEXT_DRAW) {
	    	HideInventory(playerid);
	    }
	}
}
stock Inventory@Click_TD(playerid, PlayerText:playertextid) {
	if(GetPVarInt(playerid,#Inv@Open) == 2) {
		if(playertextid == Inventory_@Main[playerid][2]) {
			if(GetPVarInt(playerid, #Inv@Page) >= INVENTORY_MAX_PAGE-1) return 1;
			if(GetPVarInt(playerid, #Inv@SelSlot) != -1) PlayerTextDrawColor(playerid,  Inventory_@Slot[playerid][GetPVarInt(playerid, #Inv@SelSlot)], -1);
			ShowPlayerInventoryPD(playerid,GetPVarInt(playerid,#ViewID),GetPVarInt(playerid, #Inv@Page) + 1);
		}
		if(playertextid == Inventory_@Main[playerid][3]) {
			if(GetPVarInt(playerid, #Inv@Page) <= 0) return 1;
			if(GetPVarInt(playerid, #Inv@SelSlot) != -1) PlayerTextDrawColor(playerid,  Inventory_@Slot[playerid][GetPVarInt(playerid, #Inv@SelSlot)], -1);
			ShowPlayerInventoryPD(playerid,GetPVarInt(playerid,#ViewID),GetPVarInt(playerid, #Inv@Page) - 1);
		}
		if(playertextid == Inventory_@Main[playerid][12]) {

			HideInventory(playerid);
		}
	}
	if(GetPVarInt(playerid,#Inv@Open) == 1) {
		for(new i = 0 ; i < 4 ; i++) {
			if(playertextid == Inventory_Weapon[playerid][i]) { 
				if(PlayerAttachItem[playerid][i] != 0) {
					RemoveAttachItem(playerid,i);
					PreviewModelWeaponAttach(playerid);
				}
			}
		}
		if(playertextid == Inventory_@Main[playerid][2]) {
			if(GetPVarInt(playerid, #Inv@Page) >= INVENTORY_MAX_PAGE-1) return 1;
			if(GetPVarInt(playerid, #Inv@SelSlot) != -1) PlayerTextDrawColor(playerid,  Inventory_@Slot[playerid][GetPVarInt(playerid, #Inv@SelSlot)], -1);
			ShowPlayerInventory(playerid,GetPVarInt(playerid, #Inv@Page) + 1);
		}
		if(playertextid == Inventory_@Main[playerid][3]) {
			if(GetPVarInt(playerid, #Inv@Page) <= 0) return 1;
			if(GetPVarInt(playerid, #Inv@SelSlot) != -1) PlayerTextDrawColor(playerid,  Inventory_@Slot[playerid][GetPVarInt(playerid, #Inv@SelSlot)], -1);
			ShowPlayerInventory(playerid,GetPVarInt(playerid, #Inv@Page) - 1);
		}
		if(playertextid == Inventory_@Main[playerid][12]) {

			HideInventory(playerid);
		}
		if(playertextid ==  Inventory_@Main[playerid][8] ) {
			new slot = (  GetPVarInt(playerid, #Inv@Page) * 16 ) + GetPVarInt(playerid,#Inv@SelSlot);
			if(PlayerInventoryItem[playerid][slot] <= 1) return 1;
			Inventory_@Use(playerid,PlayerInventoryItem[playerid][slot],slot);
		}
		if(playertextid ==  Inventory_@Main[playerid][9]) {
			new slot = (  GetPVarInt(playerid, #Inv@Page) * 16 ) + GetPVarInt(playerid,#Inv@SelSlot);
			if(PlayerInventoryItem[playerid][slot] <= 1) return 1;
			if( ItemAllowDrop(PlayerInventoryItem[playerid][slot]) == -1) return SendErrorMessage(playerid,"Vat pham nay khong the vut bo.");
			new str[78];
			format(str, sizeof str, "Vut bo - %s",  ItemInfo[PlayerInventoryItem[playerid][slot]][ItemName]);
			Dialog_Show(playerid, Inventory_Drop, DIALOG_STYLE_INPUT,str, "Vui long nhap so luong vat pham ban muon vut bo", "Dong y", "Thoat");
			SetPVarInt(playerid, #Inv_@SelDrop, slot);
		}
		if(playertextid == Inventory_@Main[playerid][10] ) {
			new slot = (  GetPVarInt(playerid, #Inv@Page) * 16 ) + GetPVarInt(playerid,#Inv@SelSlot);
			Inventory_@InforShow(playerid,PlayerInventoryItem[playerid][slot]);
		}
		if(playertextid ==  Inventory_@Main[playerid][11]) {
			new slot = (  GetPVarInt(playerid, #Inv@Page) * 16 ) + GetPVarInt(playerid,#Inv@SelSlot);
    		if(PlayerInventoryItem[playerid][slot] <= 1) return 1;
			SetPVarInt(playerid, #MoveInv, 1);
			SetPVarInt(playerid, #MoveInvSlot, slot);
		}
		for(new i = 0 ; i < 16 ; i++) {
	    	if(playertextid == Inventory_@Slot[playerid][i]) {
	    		new page = GetPVarInt(playerid, #Inv@Page);
	    		if(PlayerInventoryItem[playerid][( page * 16 ) + i] == 1 && GetPVarInt(playerid,#MoveInv) == 1) {
	    			new last_slot = GetPVarInt(playerid,#MoveInvSlot);
	    			PlayerInventoryItem[playerid][( page * 16 ) + i] = PlayerInventoryItem[playerid][last_slot];
	    			PlayerInventoryAmount[playerid][( page * 16 ) + i] = PlayerInventoryAmount[playerid][last_slot];
	    			PlayerInventoryItem[playerid][last_slot] = 1;
	    			PlayerInventoryAmount[playerid][last_slot] = 0;
	    			DeletePVar(playerid,#MoveInv);
	    			UpdateInventory(playerid,last_slot);
	    			UpdateInventory(playerid,( page * 16 ) + i);
	    		}
	    	    if(PlayerInventoryItem[playerid][( page * 16 ) + i] > 0) {
	    	    	if(GetPVarInt(playerid,#MoveInv) == 1) DeletePVar(playerid,#MoveInv);

	    	    	// 
	    	    	if(GetPVarInt(playerid, #Inv@SelSlot) != -1) {
	    	    		PlayerTextDrawColor(playerid,  Inventory_@Slot[playerid][GetPVarInt(playerid, #Inv@SelSlot)], -1);
	    	    		PlayerTextDrawShow(playerid, Inventory_@Slot[playerid][GetPVarInt(playerid, #Inv@SelSlot)]);
	    	    	}
	    	    	if(GetPVarInt(playerid, #Inv@SelSlot) == i) {
	    	    		PlayerTextDrawColor(playerid,  Inventory_@Slot[playerid][GetPVarInt(playerid, #Inv@SelSlot)], -1);
	    	    		PlayerTextDrawShow(playerid, Inventory_@Slot[playerid][GetPVarInt(playerid, #Inv@SelSlot)]);
	    	    		SetPVarInt(playerid,#Inv@SelSlot,-1);
	    	    		return 1;
	    	    	}
	    	    	PlayerTextDrawColor(playerid,  Inventory_@Slot[playerid][i], -16776961);
	    	    	SetPVarInt(playerid, #Inv@SelSlot, i);
	    	    	PlayerTextDrawShow(playerid, Inventory_@Slot[playerid][i]);
	    	    }
	    	    else if(PlayerInventoryItem[playerid][( page * 16 ) + i] == 0) {

	    	    	if(GetPVarInt(playerid, #Inv@SelSlot) != -1) {
	    	    		PlayerTextDrawColor(playerid,  Inventory_@Slot[playerid][GetPVarInt(playerid, #Inv@SelSlot)], -1);
	    	    		PlayerTextDrawShow(playerid, Inventory_@Slot[playerid][GetPVarInt(playerid, #Inv@SelSlot)]);
	    	    	}
	    	    	SetPVarInt(playerid, #Inv@SelSlot, i);
	    	    	Dialog_Show(playerid, Inventory_UnlockNotify, DIALOG_STYLE_MSGBOX, "Unlock Inventory Slot", "Slot dang bi khoa vui long mo khoa tai Inventory Workshop Market", "Dong y", "");
	    	    }
	    	}
	    	   
	    }
	}
	return 1;
	    
}
Dialog:Inventory_Unlock(playerid, response, listitem, inputtext[]) {
    if (response) {

        new inv_slot =  (GetPVarInt(playerid,#Inv@Page) * 16) + GetPVarInt(playerid,#Inv@SelSlot) ;
        printf("inv unl= %d page = %d , slot = %d",inv_slot,GetPVarInt(playerid,#Inv@SelSlot),GetPVarInt(playerid,#Inv@Page) * 16);
        if(PlayerInventoryAmount[playerid][inv_slot] != 0) return SendErrorMessage(playerid,"Da co loi xay ra vui long thu lai...");
        PlayerInventoryAmount[playerid][inv_slot] = 1;
        UpdateInventory(playerid,inv_slot);
      //  ShowPlayerInventory(playerid,GetPVarInt(playerid,#Inv@Page));
    }
    return 1;
}
Dialog:Inventory_Drop(playerid, response, listitem, inputtext[]) {
    if (response) {
    	new slot = GetPVarInt(playerid, #Inv_@SelDrop);
    	if(strval(inputtext) < 0 || strval(inputtext) > 99) {
    		new str[78];
			format(str, sizeof str, "Vut bo - %s",  ItemInfo[PlayerInventoryAmount[playerid][slot]][ItemName]);
			Dialog_Show(playerid, Inventory_Drop, DIALOG_STYLE_INPUT, "Vut bo - %s", "So luong khong duoc lon hon 99 va nho hon 0\nVui long nhap so luong vat pham ban muon vut bo", "Dong y", "Thoat");
            return 1;
    	} 
    	if(PlayerInventoryAmount[playerid][slot] < strval(inputtext)) return SendErrorMessage(playerid,"Ban khong co du so vat pham de vut.");
      //  CreateItemOnFoot(playerid,PlayerInventoryItem[playerid][slot],strval(inputtext));
        Inventory_@Drop(playerid,slot,strval(inputtext));
        UpdateInventory(playerid,slot);
      //  ShowPlayerInventory(playerid,GetPVarInt(playerid,#Inv@Page));
    }
    return 1;
}
Dialog:ADD_AMMO0(playerid, response, listitem, inputtext[]) {
    if (response) {
    	new slot = GetPVarInt(playerid, #SlotAmmo);
    	if(strval(inputtext) < 0 || strval(inputtext) > 99) return SendErrorMessage(playerid, " So luong dan them phai tu 1-99.");
    	if(PlayerInventoryAmount[playerid][slot] < strval(inputtext)) return SendErrorMessage(playerid,"Ban khong co du so dan de them.");
        Inventory_@Drop(playerid,slot,strval(inputtext));
        UpdateInventory(playerid,slot);
        new weaponid = GetWeaponByItemID(PlayerAttachItem[playerid][0]);
        new weaponname[32],string[128];
    	GetWeaponName(weaponid, weaponname, sizeof(weaponname));
        GivePlayerAmmoEx(playerid, weaponid, strval(inputtext));

        format(string, sizeof string, "[AMMO] Ban da them thanh cong {5585eb}%d{b4b4b4} vien da vao vu khi {5585eb}%s", strval(inputtext),weaponname);
        SendClientMessageEx(playerid,COLOR_BASIC,string);

        format(string, sizeof(string), "{FF8000}* {C2A2DA}%s dang lap bang dan vao khau sung %s.", GetPlayerNameEx(playerid),GetWeaponNameEx(weaponid));
        ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
        ApplyAnimation(playerid, "PYTHON", "python_reload", 4.0, 0, 0, 0, 0, 0, 1);
        ShowNotifyTextMain(playerid,"~g~Dang nap dan cho vu khi...",4);
      //  ShowPlayerInventory(playerid,GetPVarInt(playerid,#Inv@Page));
    }
    return 1;
}
Dialog:ADD_AMMO1(playerid, response, listitem, inputtext[]) {
    if (response) {
    	new slot = GetPVarInt(playerid, #SlotAmmo);
    	if(strval(inputtext) < 0 || strval(inputtext) > 99) return SendErrorMessage(playerid, " So luong dan them phai tu 1-99.");
    	if(PlayerInventoryAmount[playerid][slot] < strval(inputtext)) return SendErrorMessage(playerid,"Ban khong co du so dan de them.");
        Inventory_@Drop(playerid,slot,strval(inputtext));
        UpdateInventory(playerid,slot);
        new weaponid = GetWeaponByItemID(PlayerAttachItem[playerid][1]);
        new weaponname[32],string[128];
    	GetWeaponName(weaponid, weaponname, sizeof(weaponname));
        GivePlayerAmmoEx(playerid, weaponid, strval(inputtext));

        format(string, sizeof string, "[AMMO] Ban da them thanh cong {5585eb}%d{b4b4b4} vien da vao vu khi {5585eb}%s", strval(inputtext),weaponname);
        SendClientMessageEx(playerid,COLOR_BASIC,string);

        format(string, sizeof(string), "{FF8000}* {C2A2DA}%s dang lap bang dan vao khau sung %s.", GetPlayerNameEx(playerid),GetWeaponNameEx(weaponid));
        ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
        ApplyAnimation(playerid, "PYTHON", "python_reload", 4.0, 0, 0, 0, 0, 0, 1);
        ShowNotifyTextMain(playerid,"~g~Dang nap dan cho vu khi...",4);
      //  ShowPlayerInventory(playerid,GetPVarInt(playerid,#Inv@Page));
    }
    return 1;
}
Dialog:ADD_AMMO2(playerid, response, listitem, inputtext[]) {
    if (response) {
    	new slot = GetPVarInt(playerid, #SlotAmmo);
    	if(strval(inputtext) < 0 || strval(inputtext) > 99) return SendErrorMessage(playerid, " So luong dan them phai tu 1-99.");
    	if(PlayerInventoryAmount[playerid][slot] < strval(inputtext)) return SendErrorMessage(playerid,"Ban khong co du so dan de them.");
        Inventory_@Drop(playerid,slot,strval(inputtext));
        UpdateInventory(playerid,slot);
        new weaponid = GetWeaponByItemID(PlayerAttachItem[playerid][2]);
        new weaponname[32],string[128];
    	GetWeaponName(weaponid, weaponname, sizeof(weaponname));
        GivePlayerAmmoEx(playerid, weaponid, strval(inputtext));

        format(string, sizeof string, "[AMMO] Ban da them thanh cong {5585eb}%d{b4b4b4} vien da vao vu khi {5585eb}%s", strval(inputtext),weaponname);
        SendClientMessageEx(playerid,COLOR_BASIC,string);

        format(string, sizeof(string), "{FF8000}* {C2A2DA}%s dang lap bang dan vao khau sung %s.", GetPlayerNameEx(playerid),GetWeaponNameEx(weaponid));
        ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
        ApplyAnimation(playerid, "PYTHON", "python_reload", 4.0, 0, 0, 0, 0, 0, 1);
        ShowNotifyTextMain(playerid,"~g~Dang nap dan cho vu khi...",4);
      //  ShowPlayerInventory(playerid,GetPVarInt(playerid,#Inv@Page));
    }
    return 1;
}
Dialog:ADD_AMMO3(playerid, response, listitem, inputtext[]) {
    if (response) {
    	new slot = GetPVarInt(playerid, #SlotAmmo);
    	if(strval(inputtext) < 0 || strval(inputtext) > 99) return SendErrorMessage(playerid, " So luong dan them phai tu 1-99.");
    	if(PlayerInventoryAmount[playerid][slot] < strval(inputtext)) return SendErrorMessage(playerid,"Ban khong co du so dan de them.");
        Inventory_@Drop(playerid,slot,strval(inputtext));
        UpdateInventory(playerid,slot);
        new weaponid = GetWeaponByItemID(PlayerAttachItem[playerid][3]);
        new weaponname[32],string[128];
    	GetWeaponName(weaponid, weaponname, sizeof(weaponname));
        GivePlayerAmmoEx(playerid, weaponid, strval(inputtext));

        format(string, sizeof string, "[AMMO] Ban da them thanh cong {5585eb}%d{b4b4b4} vien da vao vu khi {5585eb}%s", strval(inputtext),weaponname);
        SendClientMessageEx(playerid,COLOR_BASIC,string);

        format(string, sizeof(string), "{FF8000}* {C2A2DA}%s dang lap bang dan vao khau sung %s.", GetPlayerNameEx(playerid),GetWeaponNameEx(weaponid));
        ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
        ApplyAnimation(playerid, "PYTHON", "python_reload", 4.0, 0, 0, 0, 0, 0, 1);
        ShowNotifyTextMain(playerid,"~g~Dang nap dan cho vu khi...",4);
      //  ShowPlayerInventory(playerid,GetPVarInt(playerid,#Inv@Page));
    }
    return 1;
}
