CMD:pcheck(playerid, params[])
{
	if (IsACop(playerid) || PlayerInfo[playerid][pAdmin] >= 2)
	{
		new string[128], giveplayerid,Float:Pos[3];
		if(sscanf(params, "d", giveplayerid)) return SendUsageMessage(playerid, " /pcheck [playerid]");
		if(!IsPlayerConnected(playerid)) return SendErrorMessage(playerid,"Nguoi choi chua ket noi.");
		if(GetPVarInt(playerid, #Inv@Open) != 0) return  SendErrorMessage(playerid,"Loi khong thuc hien duoc.");
		GetPlayerPos(giveplayerid,Pos[0],Pos[1],Pos[2]);
		if(!IsPlayerInRangeOfPoint(playerid,3,Pos[0],Pos[1],Pos[2])) return SendErrorMessage(playerid,"Ban khong dung gan nguoi choi do.");
	    ShowPlayerInventoryPD(playerid,giveplayerid);
	    format(string, sizeof(string), "* %s dang luc soat tui do cua %s", GetPlayerNameEx(playerid),  GetPlayerNameEx(giveplayerid));
        ProxDetectorWrap(playerid, string, 92, 10.0, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);	
	}
	else
	{
		SendErrorMessage(playerid, "Ban khong the su dung lenh nay");
	}
	return 1;
}
CMD:ptake(playerid,params[] ) {
	if (IsACop(playerid) || PlayerInfo[playerid][pAdmin] >= 2)
	{
		new string[128], giveplayerid,Float:Pos[3];
		if(sscanf(params, "d", giveplayerid)) return SendUsageMessage(playerid, " /ptake [playerid]");
		if(!IsPlayerConnected(playerid)) return SendErrorMessage(playerid,"Nguoi choi chua ket noi.");
		if(GetPVarInt(playerid, #Inv@Open) != 0) return  SendErrorMessage(playerid,"Loi khong thuc hien duoc.");
		GetPlayerPos(giveplayerid,Pos[0],Pos[1],Pos[2]);
		if(!IsPlayerInRangeOfPoint(playerid,3,Pos[0],Pos[1],Pos[2])) return SendErrorMessage(playerid,"Ban khong dung gan nguoi choi do.");
	    ShowPlayerTakePD(playerid,giveplayerid);

	}
	else
	{
		SendErrorMessage(playerid, "Ban khong the su dung lenh nay");
	}
	return 1;
}

stock ShowPlayerTakePD(viewer,playerid) {
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
	SetPVarInt(viewer,#TakedPlayer,playerid);
	Dialog_Show(viewer, DIALOG_TAKE_ITEM, DIALOG_STYLE_TABLIST_HEADERS, "Inventory # Take", string, "Chon", "Thoat");
}
Dialog:DIALOG_TAKE_ITEM(playerid, response, listitem, inputtext[]) {
    if (response) {
    	new givep = GetPVarInt(playerid,#TakedPlayer) ;
    	new item = PlayerInventoryItem[givep][listitem] ;

    	if(ItemAllowDrop(item) == -1) return SendErrorMessage(playerid," Vat pham nay khong the [take].");
       	if(PlayerInventoryItem[givep][listitem] >= 2) {
    		SetPVarInt(playerid, #SelSlotGive, listitem);
    		SetPVarInt(playerid, #SelItemGive, PlayerInventoryItem[givep][listitem]);
    		new string[128];
    		format(string,sizeof(string),"Inventory # Take %s", ItemInfo[PlayerInventoryItem[givep][listitem]][ItemName]);
    		Dialog_Show(playerid, DTAKE_AMOUNT, DIALOG_STYLE_INPUT, string ,"{b4b4b4}Vui long nhap so luong vat pham ban muon take:", "Chon", "Thoat");
    	}

    }
    return 1;
}
Dialog:DTAKE_AMOUNT(playerid, response, listitem, inputtext[]) {
    if (response) {
    	new givep = GetPVarInt(playerid,#TakedPlayer) ;
    	new slot = GetPVarInt(playerid,#SelSlotGive);
        new item = PlayerInventoryItem[givep][slot] ;
        new amount = strval(inputtext);
    	if(PlayerInventoryAmount[givep][slot] < strval(inputtext)) return SendErrorMessage(playerid," Nguoi choi khong du so luong vat pham.");
    	if(strval(inputtext) < 0 || strval(inputtext) > ItemInfo[PlayerInventoryItem[givep][slot]][ItemMaxAmount]) return SendErrorMessage(playerid," So luong vuot qua quy dinh."); 
        new string[128];
        
        format(string, sizeof(string), "* %s lay mot vat pham tu tui do cua %s", GetPlayerNameEx(playerid),  GetPlayerNameEx(givep));
        ProxDetectorWrap(playerid, string, 92, 10.0, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);	

    	format(string, sizeof(string), "[TAKE-ITEM] ban da bi tich thu {e14848}%d{b4b4b4} {e14848}%s{b4b4b4} vat pham {e14848}%s{b4b4b4} boi {e14848}%s",amount,ItemInfo[item][ItemName],
    		GetPlayerNameEx(playerid));
        SendClientMessageEx(givep,COLOR_BASIC,string);
        format(string, sizeof(string), "[TAKE-ITEM] ban da tich thu {e14848}%d{b4b4b4} {e14848}%s{b4b4b4} vat pham {e14848}%s{b4b4b4} cua {e14848}%s",amount,ItemInfo[item][ItemName],
    		GetPlayerNameEx(givep));
        SendClientMessageEx(playerid,COLOR_BASIC,string);
        Inventory_@FineItem(givep,item,strval(inputtext));

    }
    return 1;
}
stock ShowPlayerInventoryPD(viewer,playerid,page = 0) {
	new string[129];
	if(GetPVarInt(playerid, #Inv@SelSlot) != -1) {
		DeletePVar(playerid, #Inv@SelSlot);
	    PlayerTextDrawColor(viewer,  Inventory_@Slot[playerid][GetPVarInt(playerid, #Inv@SelSlot)], -1);
	    PlayerTextDrawShow(viewer,Inventory_@Slot[playerid][GetPVarInt(playerid, #Inv@SelSlot)]);
	}
	for(new i = 0 ; i < 16 ; i++) {
		PlayerTextDrawHide(viewer,  Inventory_@Slot[playerid][i]);
		PlayerTextDrawHide(viewer,  Inventory_@Amount[playerid][i]);
		new inv_slot = i + ( 16 * page),item_id = PlayerInventoryItem[playerid][inv_slot];

		PlayerTextDrawSetPreviewModel(viewer, Inventory_@Slot[playerid][i], ItemInfo[item_id][ItemObject]);
		PlayerTextDrawSetPreviewRot(viewer, Inventory_@Slot[playerid][i], 1.0,1.0,1.0, 1.0);
		if(PlayerInventoryItem[playerid][inv_slot] == 1) {
        	PlayerTextDrawSetPreviewRot(viewer, Inventory_@Slot[playerid][i], 0,0,0, 100.0);
        }
		if(item_id > 1 ) {
			format(string, sizeof string, "%s~n~(~r~%d~w~)",ItemInfo[item_id][ItemName], PlayerInventoryAmount[playerid][inv_slot]);
	        PlayerTextDrawSetString(viewer,  Inventory_@Amount[viewer][i], string);
	        PlayerTextDrawShow(viewer,  Inventory_@Amount[viewer][i]);
		}
		PlayerTextDrawShow(viewer,  Inventory_@Slot[viewer][i]);
		
	}
    new str[48];
    format(str,sizeof str,"%d/%d",page+1,INVENTORY_MAX_PAGE);
    PlayerTextDrawSetString(viewer, 	Inventory_@Main[playerid][4], str);
    format(str,sizeof str,"%s",GetPlayerNameEx(playerid));
    PlayerTextDrawSetString(viewer,  Inventory_@Main[playerid][13], str);


    PDPreviewModelWeaponAttach(viewer,playerid);
	for(new i = 0 ; i < 14 ; i ++) {

		PlayerTextDrawShow(viewer, Inventory_@Main[playerid][i]);
	}
	SelectTextDraw(viewer, COLOR_LIGHTRED);
	SetPVarInt(viewer, #Inv@Page, page);
	SetPVarInt(viewer, #ViewID,playerid);
	SetPVarInt(viewer, #Inv@Open, 2);
	SetPVarInt(viewer, #Inv@SelSlot, -1);
	return 1;
}
stock PDPreviewModelWeaponAttach(viewer,playerid) {
	for(new i = 0 ; i < 4 ; i++) {
		PlayerTextDrawSetPreviewModel(viewer, Inventory_Weapon[playerid][i], ItemInfo[PlayerAttachItem[playerid][i]][ItemObject]);
        PlayerTextDrawSetPreviewRot(viewer, Inventory_Weapon[playerid][i], 1.0,1.0,1.0, 1.0);
		if(PlayerAttachItem[playerid][i] == 0) {
        	PlayerTextDrawSetPreviewRot(viewer, Inventory_Weapon[playerid][i], 0,0,0, 100.0);
        }
        PlayerTextDrawShow(viewer, Inventory_Weapon[playerid][i]);
	}
	return 1;
}