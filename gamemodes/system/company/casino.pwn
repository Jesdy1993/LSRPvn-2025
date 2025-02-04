#include <YSI\y_hooks>
#define MAX_CASINO 2
#define COLOR_CASINO 0x4a84b0FF

enum caInfo {
	Casino_Start,
	Casino_Obj,
	Casino_Actor,
	Casino_Actor2,
	Casino_BetCash[3],
	Casino_ketqua,
	Casino_lastketqua,
	Casino_teps,
	Casino_stacks,
	Text3D:Actor_text,
	Text3D:Actor_Statstext,
	Timer:Casino_Timer
};
new Casino_Info[MAX_CASINO][caInfo];

enum statics 
{
	stats_tai,
	stats_xiu,
	stats_ketqua,
	stats_final
};
new CasinoStatics[100][statics];

CMD:editcasino(playerid,params[]) {
	EditDynamicObject(playerid, Casino_Info[0][Casino_Obj]);
	SetPVarInt(playerid, "CasinoEdit", 0);
	return 1;
}

CMD:casino(playerid,params[]) {
	if(IsPlayerInRangeOfPoint(playerid, 5, 1127.299438, -2.090329, 1000.46978)) {
		Dialog_Show(playerid, DIALOG_CASINO, DIALOG_STYLE_LIST, "Casino # Main", "Dat cuoc\nThong ke phien nay\nThong ke tat ca", "Chon", "Thoat");
	}
	else SendErrorMessage(playerid, " Ban khong o gan Casino");
	return 1;
}
stock ResetCasinoStatic() {
	for(new i = 0 ; i < 100 ;i ++) {
		CasinoStatics[i][stats_tai] = 0;
        CasinoStatics[i][stats_xiu] =  0; // 
        CasinoStatics[i][stats_ketqua] = 0;// 
        CasinoStatics[i][stats_final] =  0; // doanh thu cua casino
	}
}

stock AddCasinoStatic(stask) {
    CasinoStatics[stask][stats_tai] = Casino_Info[0][Casino_BetCash][1];
    CasinoStatics[stask][stats_xiu] =   Casino_Info[0][Casino_BetCash][2]; // 
    CasinoStatics[stask][stats_ketqua] = Casino_Info[0][Casino_ketqua];// 
    new final;
    if(Casino_Info[0][Casino_ketqua] == 1) {
    	new thue = Casino_Info[0][Casino_BetCash][1] / 10;
    	new loinhuan = Casino_Info[0][Casino_BetCash][1] - thue;
    	final = Casino_Info[0][Casino_BetCash][2] - loinhuan;
    }
    else  if(Casino_Info[0][Casino_ketqua] == 2) { 
    	new thue = Casino_Info[0][Casino_BetCash][2] / 10;
    	new loinhuan = Casino_Info[0][Casino_BetCash][2] - thue;
    	final = Casino_Info[0][Casino_BetCash][1] - loinhuan;
    }
    CasinoStatics[stask][stats_final] =  final; // doanh thu cua casino
}
stock BetCasino(playerid) {
	new string[129];
	if(!IsPlayerInRangeOfPoint(playerid, 5, 1127.299438, -2.090329, 1000.469787)) return SendErrorMessage(playerid, " Ban khong o gan Casino");
	if(Casino_Info[0][Casino_teps] != 2) return SendErrorMessage(playerid, " Hien tai chua nhan dat cuoc.");
	format(string, sizeof string, "{b4b4b4}Tai:\t{a73b3b}%s{b4b4b4}\nXiu:\t{3d8d42}%s", number_format(PlayerInfo[playerid][pCasinoBet][1]), number_format(PlayerInfo[playerid][pCasinoBet][2]) );
	Dialog_Show(playerid, DIALOG_SEL_BET, DIALOG_STYLE_TABLIST, "Tai xiu @ Select", string, "Dat cuoc", "Thoat");
	return 1;
}
stock ShowStaticsCasino(playerid,i) {
	new string[129];
	format(string, sizeof(string), "Phien thu: %d\nSo tien dat Tai: $%s\nSo tien dat xiu: $%s\nKet qua: %s\nLoi nhuan nha cai: $%s",i,
		number_format(CasinoStatics[i][stats_tai]),number_format(CasinoStatics[i][stats_xiu]),(CasinoStatics[i][stats_ketqua] == 1) ? "Tai" : "Xiu",
		number_format(CasinoStatics[i][stats_final]));
	ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Casino # Thong ke", string, "Dong", "");
}
stock ShowListCasino(playerid) {
	new str[2229];
	str = "#Nguoi choi\t#Cuoc\t#So tien\n";
	foreach(new i : Player) {
		if(PlayerInfo[i][pIsCasinoBet] != 0) {
			format(str, sizeof(str), "%s\t%s\t%s\t$%s\n", str,GetPlayerNameEx(i),(PlayerInfo[i][pIsCasinoBet] == 1) ? "Tai" : "Xiu", number_format(PlayerInfo[i][pCasinoBet][PlayerInfo[i][pIsCasinoBet]]));
		}
	}
	if(isnull(str) ) return SendErrorMessage(playerid, " Khong co ai dat cuoc.");
	ShowPlayerDialog(playerid,DIALOG_NOTHING,DIALOG_STYLE_TABLIST_HEADERS,"Casino # Stats",str,"Xac nhan","");
	return 1;
}
stock ShowDialogRefill(playerid,listitem) {
	if(Company[2][CompanyItem][listitem] == 1) { // add-on
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
	    SetPVarInt(playerid,#TakedPlayer,playerid);
	    Dialog_Show(playerid, DIALOG_REFILL_ITEM, DIALOG_STYLE_TABLIST_HEADERS, "Inventory # Refill Casino Shop", string, "Chon", "Thoat");
	}
	else if(Company[2][CompanyItem][listitem] != 1 && Company[2][CompanyAmount][listitem] > 0) {
		Dialog_Show(playerid, DIALOG_REFILL_SEL, DIALOG_STYLE_LIST, "Inventory # Refill Casino Shop", "Them vat pham\nChinh sua gia\nXoa vat pham", "Chon", "Thoat");

		// remove // add edit // price edit
	}
}
stock ItemAllowCasino(i) {
	switch(i) {
		case 10,11,12,13,14,34,35: return 1;
	}
	return -1;
}

Dialog:DIALOG_CASINO_BAR(playerid,  response, listitem, inputtext[]) {
	if(response) {
		if(listitem < 5)
		{
		    
			if(PlayerInfo[playerid][pCompany] == 2)
			{
				SetPVarInt(playerid,#SlotBar,listitem);
				ShowDialogRefill(playerid,listitem);
				return 1;
			}
			if( Company[2][CompanyItem][listitem] <= 0 ) return SendErrorMessage(playerid," Mac hang khong ton tai.");
			if(PlayerInfo[playerid][pCash] < Company[2][CompanyPrice][listitem]) return SendErrorMessage(playerid, " Ban khong du tien mua vat pham.");
            if(CheckInventorySlotEmpty(playerid,Company[2][CompanyItem][listitem],1) == -1) return SendErrorMessage(playerid,"Tui do cua ban da day khong the mua vat pham.");
     		if( Company[2][CompanyAmount][listitem] <= 0 ) return SendErrorMessage(playerid," Cua hang da het hang de ban.");
     		Inventory_@Add(playerid,Company[2][CompanyItem][listitem],1);
			GivePlayerMoneyEx(playerid,-Company[2][CompanyPrice][listitem] );
			Company@AddBudget(2,Company[2][CompanyPrice][listitem]);
			
			new string[128];
            format(string, sizeof(string), "[BUY-ITEM] Ban da mua thanh cong 1{e14848}%s{b4b4b4}voi gia $%s",ItemInfo[Company[2][CompanyItem][listitem]][ItemName],
            	number_format(Company[2][CompanyPrice][listitem]));
            SendClientMessageEx(playerid,COLOR_BASIC,string);
            Company[2][CompanyAmount][listitem] -= 1;
            if(Company[2][CompanyItem][listitem] <= 0) {
            	Company[2][CompanyItem][listitem] = 1;
            	Company[2][CompanyAmount][listitem] = 0;
            	Company[2][CompanyPrice][listitem]  = 0;
            }
            SaveCompany(2);
		}
	}
	return 1;
}

Dialog:DIALOG_REFILL_PRICE(playerid, response, listitem, inputtext[]) {
    if (response) {
    	if(isnull(inputtext)) return  Dialog_Show(playerid, DIALOG_REFILL_PRICE, DIALOG_STYLE_INPUT, "Inventory # Refill Casino Shop", "Vui long nhap gia ban muon ban:", "Chon", "Thoat");
        if(strval(inputtext) < 0 || strval(inputtext) > 1000) return Dialog_Show(playerid, DIALOG_REFILL_PRICE, DIALOG_STYLE_INPUT, "Inventory # Refill Casino Shop", "Gia phai tu 1-1000\nVui long nhap gia ban muon ban:", "Chon", "Thoat");
    	new slot_bar = GetPVarInt(playerid, #SlotBar);
    	new itemid = Company[2][CompanyItem][slot_bar] ;
    	if(itemid > 1) {
    		Company[2][CompanyPrice][slot_bar] = strval(inputtext);
    	    new string[128];
            format(string, sizeof(string), "[EDITPRICE-ITEM] Ban da chinh sua gia{e14848}%s{b4b4b4} thanh $%s",ItemInfo[itemid][ItemName],
            	number_format(strval(inputtext)));
            SendClientMessageEx(playerid,COLOR_BASIC,string);
            SaveCompany(2);
            new strlog[129];
		    format(strlog, sizeof(strlog), "[%s] %s(%s) đã chỉnh sửa giá tiền %s thành $%s.", GetLogTime(),GetPlayerNameEx(playerid),GetDiscordUser(playerid),ItemInfo[itemid][ItemName],number_format(strval(inputtext)));         
            SendLogDiscordMSG(logs_casinoshop, strlog);

    	}
    }
    return 1;
}
Dialog:DIALOG_REFILL_SEL(playerid, response, listitem, inputtext[]) {
    if (response) {
    	if(listitem == 0) {
    		new slot_bar = GetPVarInt(playerid, #SlotBar);
    		new itemid = Company[2][CompanyItem][slot_bar] ;
            if(Inventory_@CheckSlot(playerid,itemid) == -1) return SendErrorMessage(playerid, " Ban khong co vat pham nay de them vao.");
            new string[128];
            format(string, sizeof(string), "[REFILL-ITEM] Ban da them thanh cong {e14848}1{b4b4b4} {e14848}%s{b4b4b4} cho {e14848}Casino Bar Shop{b4b4b4}.",ItemInfo[itemid][ItemName]);
            SendClientMessageEx(playerid,COLOR_BASIC,string);
            Inventory_@FineItem(playerid,itemid,1);
            Company[2][CompanyAmount][slot_bar] += 1;
            SaveCompany(2);
            new strlog[129];
		    format(strlog, sizeof(strlog), "[%s] %s(%s) đã thêm thành công 1 %s vào shop casino.", GetLogTime(),GetPlayerNameEx(playerid),GetDiscordUser(playerid),ItemInfo[itemid][ItemName]);         
            SendLogDiscordMSG(logs_casinoshop, strlog);
    	}
    	if(listitem == 1) {

    	    Dialog_Show(playerid, DIALOG_REFILL_PRICE, DIALOG_STYLE_INPUT, "Inventory # Refill Casino Shop", "Vui long nhap gia ban muon ban:", "Chon", "Thoat");
    	}
    	if(listitem == 2) {
    	    new slot_bar = GetPVarInt(playerid, #SlotBar);
    	    new item = Company[2][CompanyItem][slot_bar] ;
    	    new amount = Company[2][CompanyAmount][slot_bar];
    	    new string[128];
            format(string, sizeof(string), "[REFILL-ITEM] Ban da lay {e14848}%d{b4b4b4} {e14848}%s{b4b4b4} cho {e14848}Casino Bar Shop{b4b4b4} [/my inv]",amount,ItemInfo[item][ItemName]);
            SendClientMessageEx(playerid,COLOR_BASIC,string);
            Inventory_@Add(playerid,item,amount);
        	Company[2][CompanyItem][slot_bar] = 1;
        	Company[2][CompanyAmount][slot_bar] = 0;
        	Company[2][CompanyPrice][slot_bar] = 0;
        	new strlog[129];
		    format(strlog, sizeof(strlog), "[%s] %s(%s) đã lấy thành công %d %s khỏi shop casino.", GetLogTime(),GetPlayerNameEx(playerid),GetDiscordUser(playerid),amount,ItemInfo[item][ItemName]);         
            SendLogDiscordMSG(logs_casinoshop, strlog);
            SaveCompany(2);

    	}
    }
    return 1;
}
Dialog:DIALOG_REFILL_ITEM(playerid, response, listitem, inputtext[]) {
    if (response) {
    	new givep = GetPVarInt(playerid,#TakedPlayer) ;
    	new item = PlayerInventoryItem[playerid][listitem] ;

    	if(ItemAllowCasino(item) == -1) return SendErrorMessage(playerid," Vat pham nay khong the them vao shop.");
       	if(PlayerInventoryItem[playerid][listitem] >= 2) {
    		SetPVarInt(playerid, #SelSlotGive, listitem);
    		SetPVarInt(playerid, #SelItemGive, PlayerInventoryItem[playerid][listitem]);
    		new string[128];
    		format(string,sizeof(string),"Inventory # Refill %s", ItemInfo[PlayerInventoryItem[playerid][listitem]][ItemName]);
    		Dialog_Show(playerid, DREFILL_AMOUNT, DIALOG_STYLE_INPUT, string ,"{b4b4b4}Vui long nhap so luong vat pham ban muon ban:", "Chon", "Thoat");
    	}
    }
    return 1;
}
Dialog:DREFILL_AMOUNT(playerid, response, listitem, inputtext[]) {
    if (response) {
    	new slot_bar = GetPVarInt(playerid, #SlotBar);
    	new slot = GetPVarInt(playerid,#SelSlotGive);
        new item = PlayerInventoryItem[playerid][slot] ;
        new amount = strval(inputtext);
    	if(PlayerInventoryAmount[playerid][slot] < strval(inputtext)) return SendErrorMessage(playerid," Nguoi choi khong du so luong vat pham.");
        new string[128];
        format(string, sizeof(string), "[REFILL-ITEM] Ban da them vao {e14848}%d{b4b4b4} {e14848}%s{b4b4b4} cho {e14848}Casino Bar Shop{b4b4b4} ",amount,ItemInfo[item][ItemName]);
        SendClientMessageEx(playerid,COLOR_BASIC,string);
        Inventory_@FineItem(playerid,item,amount);
        if(Company[2][CompanyItem][slot_bar] == 1) {
        	Company[2][CompanyItem][slot_bar] = item;
        	Company[2][CompanyAmount][slot_bar] = amount;
        }
        SaveCompany(2);
        new strlog[129];
		format(strlog, sizeof(strlog), "[%s] %s(%s) đã thêm vào %d %s vào shop casino.", GetLogTime(),GetPlayerNameEx(playerid),GetDiscordUser(playerid),amount,ItemInfo[item][ItemName]);         
        SendLogDiscordMSG(logs_casinoshop, strlog);
    }
    return 1;
}
Dialog:DIALOG_CASINO(playerid,  response, listitem, inputtext[]) {
	if(response) {
		if(listitem == 0) {
			BetCasino(playerid);
		}
		if(listitem == 1) {

			ShowListCasino(playerid);

		}
		if(listitem == 2) {
			new string[2229];
			string = "Phien\tKet qua\tDoanh thu\n";
			for(new i = 1 ; i <= Casino_Info[0][Casino_stacks]; i++) {

				format(string, sizeof (string), "%s%d\t%s\t$%s\n", string,i,(CasinoStatics[i][stats_ketqua] == 1 ) ? "Tai" : "Xiu",
					number_format(CasinoStatics[i][stats_final]));
			} 
			print(string);
			Dialog_Show(playerid,DIALOG_STATICS_CASINO,DIALOG_STYLE_TABLIST_HEADERS,"Thong ke toan phien # Casino",string,"Dong y","Thoat");
		}
	}
}
Dialog:DIALOG_STATICS_CASINO(playerid,  response, listitem, inputtext[]) {
	if(response) {
		new i = listitem + 1;
		if(i >= 100) return 1;
		ShowStaticsCasino(playerid,i);

	}
	return 1;
}
Dialog:DIALOG_SEL_BET(playerid,  response, listitem, inputtext[]) {
	if(response) {
		if(listitem == 0) {
			if(PlayerInfo[playerid][pIsCasinoBet] == 1) return SendErrorMessage(playerid," Chi duoc dat cuoc 1 lan duy nhat.");
			Dialog_Show(playerid, BET_TAI, DIALOG_STYLE_INPUT, "Casino @ Bet > Tai", "Vui long nhap so tien ban muon dat cuoc vao Tai:", "Nhap", "Thoat");
		}
		if(listitem == 1) {
			if(PlayerInfo[playerid][pIsCasinoBet] == 1) return SendErrorMessage(playerid," Chi duoc dat cuoc 1 lan duy nhat.");
			Dialog_Show(playerid, BET_XIU, DIALOG_STYLE_INPUT, "Casino @ Bet > Xiu", "Vui long nhap so tien ban muon dat cuoc vao Xiu:", "Nhap", "Thoat");
		}
	}
	return 1;
}
Dialog:BET_TAI(playerid,  response, listitem, inputtext[]) {
	if(response) {
		if(isnull(inputtext)) return Dialog_Show(playerid, BET_TAI, DIALOG_STYLE_INPUT, "Casino @ Bet > Tai", "Vui long nhap so tien ban muon dat cuoc vao Tai:", "Nhap", "Thoat");
		if(strval(inputtext) < 200 || strval(inputtext) > 5000) return Dialog_Show(playerid, BET_TAI, DIALOG_STYLE_INPUT, "Casino @ Bet > Tai", "Vui long nhap so tien ban muon dat cuoc vao Tai:", "Nhap", "Thoat");
	    if(PlayerInfo[playerid][pCash] < strval(inputtext))  return Dialog_Show(playerid, BET_TAI, DIALOG_STYLE_INPUT, "Casino @ Bet > Tai", "Bank khong co du tien de dat cuoc\nVui long nhap so tien ban muon dat cuoc vao Tai:", "Nhap", "Thoat");
	    Casino_@BetA(playerid,0,1,strval(inputtext));
	}
	return 1;
}
Dialog:BET_XIU(playerid,  response, listitem, inputtext[]) {
	if(response) {
		if(isnull(inputtext)) return Dialog_Show(playerid, BET_XIU, DIALOG_STYLE_INPUT, "Casino @ Bet > Xiu", "Vui long nhap so tien ban muon dat cuoc vao Tai:", "Nhap", "Thoat");
		if(strval(inputtext) < 200 || strval(inputtext) > 5000) return Dialog_Show(playerid, BET_XIU, DIALOG_STYLE_INPUT, "Casino @ Bet > Xiu", "Vui long nhap so tien ban muon dat cuoc vao Tai:", "Nhap", "Thoat");
	    if(PlayerInfo[playerid][pCash] < strval(inputtext))  return Dialog_Show(playerid, BET_XIU, DIALOG_STYLE_INPUT, "Casino @ Bet > Xiu", "Bank khong co du tien de dat cuoc\nVui long nhap so tien ban muon dat cuoc vao Tai:", "Nhap", "Thoat");
	    Casino_@BetA(playerid,0,2,strval(inputtext));
	}
	return 1;
}
Dialog:DIALOG_OWNER_CASINO(playerid,  response, listitem, inputtext[]) {
	if(response) {
	    if(listitem == 0) {
	    	if(Casino_Info[0][Casino_Start] == 1) return SendErrorMessage(playerid," Casino dang duoc hoat dong roi.");
            Casino_Info[0][Casino_Timer] = defer CasinoTimer[5000](0); 
            Casino_Info[0][Casino_Start] = 1;
            SendClientMessageEx(playerid,COLOR_LIGHTBLUE," Ban da bat dau hoat dong casino.");
	    }
	    if(listitem == 1) {
	    	if(Casino_Info[0][Casino_Start] == 0) return SendErrorMessage(playerid," Casino chua duoc hoat dong.");
            if(Casino_Info[0][Casino_teps] != 0) return SendErrorMessage(playerid," Casino khong the dung hoat dong ngay luc nay.");
            stop Casino_Info[0][Casino_Timer];
            Casino_Info[0][Casino_Start] = 0;
            SendClientMessageEx(playerid,COLOR_LIGHTRED," Ban da dung hoat dong casino.");
            UpdateDynamic3DTextLabelText(	Casino_Info[0][Actor_Statstext] , COLOR_BASIC, "<{eb2d2c}CASINO STOPPED...{b4b4b4}>");

	    }
	    if(listitem == 2) {
	    	new string[2229];
			string = "Phien\tKet qua\tDoanh thu\n";
			for(new i = 1 ; i <= Casino_Info[0][Casino_stacks]; i++) {

				format(string, sizeof (string), "%s%d\t%s\t$%s\n", string,i,(CasinoStatics[i][stats_ketqua] == 1 ) ? "Tai" : "Xiu",
					number_format(CasinoStatics[i][stats_final]));
			} 
			print(string);
			Dialog_Show(playerid,DIALOG_STATICS_CASINO,DIALOG_STYLE_TABLIST_HEADERS,"Thong ke toan phien # Casino",string,"Dong y","Thoat");
	    }
	}
	return 1;
}
CMD:makecasino(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] >= 99999)
	{
		new string[128], giveplayerid;
		if(sscanf(params, "u", giveplayerid )) return SendUsageMessage(playerid, " /makemech [player] ");
		if(IsPlayerConnected(giveplayerid))
		{
			PlayerInfo[giveplayerid][pCompany] = 2;
			PlayerInfo[giveplayerid][pRank] = 6;
			format(string, sizeof(string), "[CASINO] Ban da set Company Casino cho %s.",GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			format(string, sizeof(string), "[CASINO] Ban da duoc set Company Casino boi %s.", GetPlayerNameEx(playerid));
		}
	}
	else
	{
		SendErrorMessage(playerid, "Ban khong the su dung lenh nay");
	}
	return 1;
}
timer CasinoTimer[1000](i)
{
    if( Casino_Info[i][Casino_Start] == 0) return 1;
	if(Casino_Info[i][Casino_teps] == 0) {
		print("ab 1");
		Casino_Info[i][Casino_teps] = 1;
		stop Casino_Info[i][Casino_Timer];
		Casino_Info[i][Casino_Timer] = defer CasinoTimer[60*1000](i);
		new string[129];
		format(string, sizeof string, "Nguyen Thi No: Casino phien thu %d, se bat dau nhan tien cuoc trong vong 1 phut nua",Casino_Info[i][Casino_stacks] );
		ProDetectorCasino(30.0, i, string,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_FADE1,COLOR_FADE2, 1);
        format(string, sizeof string, "Casino phien thu %d, se bat dau nhan tien cuoc trong vong 1 phut nua",Casino_Info[i][Casino_stacks] );
		SetActorChatBubble(Casino_Info[i][Casino_Actor], string,COLOR_FADE1, 10);

		UpdateDynamic3DTextLabelText(	Casino_Info[i][Actor_Statstext] , COLOR_BASIC, "<{b5d055}CASINO START...{3ea946}>");
	}
	else if(Casino_Info[i][Casino_teps] == 1) {
		print("ab 2");
		Casino_Info[i][Casino_teps] = 2;
		stop Casino_Info[i][Casino_Timer];
		Casino_Info[i][Casino_Timer] = defer CasinoTimer[3*30000](i);
        ProDetectorCasino(30.0, i, "Nguyen Thi No: Nhan tien cuoc, moi nguoi tranh thu dat cuoc di nao, sau 1p30s em khong nhan nua dau!.",COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_FADE1,COLOR_FADE2, 1);
	    SetActorChatBubble(Casino_Info[i][Casino_Actor], "Nhan tien cuoc, moi nguoi tranh thu dat cuoc di nao, sau 1p30s em khong nhan nua dau",COLOR_FADE1, 10); 
	    UpdateDynamic3DTextLabelText(	Casino_Info[i][Actor_Statstext] , COLOR_BASIC, "<{55d0cd}CASINO BETTING...{b4b4b4}>");
	} 
	else if(Casino_Info[i][Casino_teps] == 2) {
		print("ab 3");
		Casino_Info[i][Casino_teps] = 3;
		stop Casino_Info[i][Casino_Timer];
		Casino_Info[i][Casino_Timer] = defer CasinoTimer[1 * 30000](i);

        ProDetectorCasino(30.0, i, "Nguyen Thi No: Dem nguoc 30s em lac xi ngau nhaa!.",COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_FADE1,COLOR_FADE2, 1);
        SetActorChatBubble(Casino_Info[i][Casino_Actor], "Dem nguoc 30s em lac xi ngau nhaa!",COLOR_FADE1, 10); 
	    UpdateDynamic3DTextLabelText(	Casino_Info[i][Actor_Statstext] , COLOR_BASIC, "<{3ea946}CASINO ROLLING...{b4b4b4}>");
	
	}
	else if(Casino_Info[i][Casino_teps] == 3) {
		new ketqua;
		ketqua = RandomEx(1, 2);
		if( Casino_Info[i][Casino_lastketqua] == 1) {
			switch(RandomEx(0,15)) {
				case 0: ketqua = RandomEx(1, 2);
				case 1: ketqua = 1;
				case 2: ketqua = 2;
				case 3: ketqua = 1;
				case 4: ketqua = 2;
				case 5: ketqua = 1;
				case 6: ketqua = 2;
				case 7: ketqua = 1;
				case 8: ketqua = 2;
				case 9: ketqua = 2;
				case 10: ketqua = 2;
				case 11..15: ketqua = RandomEx(1, 2);
			}
		} 
		else if( Casino_Info[i][Casino_lastketqua] == 2) {
			switch(RandomEx(0,15)) {
				case 0: ketqua = RandomEx(1, 2);
				case 1: ketqua = 1;
				case 2: ketqua = 2;
				case 3: ketqua = 1;
				case 4: ketqua = 2;
				case 5: ketqua = 1;
				case 6: ketqua = 2;
				case 7: ketqua = 1;
				case 8: ketqua = 2;
				case 9: ketqua = 1;
				case 10: ketqua = 1;
				case 11..15: ketqua = RandomEx(1, 2);
			}
		}

		

		Casino_Info[i][Casino_ketqua] = ketqua;
		Casino_Info[i][Casino_lastketqua] = Casino_Info[i][Casino_ketqua];
		// printf("ket qua %d,ket qua %d",ketqua,Casino_Info[i][Casino_ketqua]);
		new string[129];
		format(string, sizeof string, "{FF8000}** {C2A2DA} Nguyen Thi No da tung xuc xac ra %s",(Casino_Info[i][Casino_ketqua] == 1) ? "tai" : "xiu");	
        ProDetectorCasino(10,0 ,string,  COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);


		stop Casino_Info[i][Casino_Timer];
		Casino_Info[i][Casino_Timer] = repeat CasinoTimer[8000](i);
		Casino_Info[i][Casino_teps] = 0;
		UpdateDynamic3DTextLabelText(	Casino_Info[i][Actor_Statstext] , COLOR_BASIC, "<{31a751}CASINO RESTARTING...{b4b4b4}>");
		foreach(new p : Player) {
			if( PlayerInfo[p][pCasinoBet][ketqua] > 0) {
			    if(Company[2][CompanyBudget] >= PlayerInfo[p][pCasinoBet][ketqua] *2) {

                    new winner = PlayerInfo[p][pCasinoBet][ketqua] / 10;
                    new tienthuong = PlayerInfo[p][pCasinoBet][ketqua] * 2;

			    	format(string,129, "[CASINO] Ban nhan duoc $%s vi thang cuoc, ket qua phien: %s.",number_format(tienthuong - winner),
                    	(ketqua == 1) ? "Tai" : "Xiu");
                    SendClientMessage(p,COLOR_CASINO,string);

			    	Company[2][CompanyBudget] -= tienthuong - winner;
			    	SaveCompany(2);
			    	GivePlayerMoneyEx(p, tienthuong - winner);		     
			    }
			    else {
			    	if(Company[2][CompanyBudget] >= PlayerInfo[i][pCasinoBet][ketqua] ) {
			    	    format(string,129, "[CASINO] Ban khong nhan duoc $%s vi nha cai khong con tien, ban duoc hoan tra $%s.",number_format(PlayerInfo[p][pCasinoBet][ketqua] * 2),
                    	(ketqua == 1) ? "Tai" : "Xiu",number_format(PlayerInfo[p][pCasinoBet][ketqua] ));
                        SendClientMessage(p,COLOR_CASINO,string);
			    		GivePlayerMoneyEx(p, PlayerInfo[i][pCasinoBet][ketqua]);
			    		
			    	}
			    	else {
			    		SendClientMessage(p,COLOR_CASINO," Ban khong nhan lai duoc gi vi nha cai khong co tien tra thuong.");
			    	}
			    }
			}
			PlayerInfo[p][pCasinoBet][1] = 0;
			PlayerInfo[p][pCasinoBet][2] = 0;
			PlayerInfo[p][pIsCasinoBet] = 0;
			
		}
		new loinhuan;
		if(ketqua == 1) {
			loinhuan = Casino_Info[i][Casino_BetCash][2] - Casino_Info[i][Casino_BetCash][1];  
		}
		if(ketqua == 2) {
			loinhuan = Casino_Info[i][Casino_BetCash][1] - Casino_Info[i][Casino_BetCash][2];  
		}
		new strlog[129];
		format(strlog, sizeof(strlog), "[%s] TÀI XỈU Phiên %d kết quả %s , lợi nhuận nhà cái: $%s [Tổng tài: $%s, Tổng xỉu: $%s]", GetLogTime(),Casino_Info[i][Casino_stacks],
		( Casino_Info[i][Casino_ketqua] == 1) ? "Tai" : "Xiu",number_format(loinhuan),number_format(Casino_Info[i][Casino_BetCash][1]),number_format(Casino_Info[i][Casino_BetCash][2]));         
        SendLogDiscordMSG(logs_casino, strlog);
        
		if(Casino_Info[i][Casino_stacks] >= 98) {
			Casino_Info[i][Casino_stacks]  = 1;
			ResetCasinoStatic();
		}
		AddCasinoStatic(Casino_Info[i][Casino_stacks]+1);
		Casino_Info[i][Casino_BetCash][1] = 0;
		Casino_Info[i][Casino_BetCash][2] = 0;
		Casino_Info[i][Casino_ketqua] = 0;
		
        
		Casino_Info[i][Casino_stacks]++;


        ProDetectorCasino(30.0, i, "Nguyen Thi No: Moi nguoi binh tinh de em chung tien nee!!.",COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_FADE1,COLOR_FADE2, 1);
	   
	}
	return 1;
}
 
stock Casino_@BetA(playerid,i,bet_sel,bet_price) {
	if(PlayerInfo[playerid][pIsCasinoBet] != 0) return SendErrorMessage(playerid, " Ban da dat cuoc roi khong the dat tiep.");
	new defend;
	if(bet_sel == 2) {
		new budget_price = Company[2][CompanyBudget] + Casino_Info[i][Casino_BetCash][1];
		if(budget_price  < bet_price) {
			defend = 1;
		}
	}
	else if(bet_sel == 1) {
		new budget_price = Company[2][CompanyBudget] + Casino_Info[i][Casino_BetCash][2];
		if(budget_price  < bet_price) {
			defend = 1;
		}
	}
	if(defend == 1) return SendErrorMessage(playerid, " Casino khong du tien chi tra cho tong tien cuoc, khong nhan dat cuoc them.");
	
    PlayerInfo[playerid][pCasinoBet][bet_sel] = bet_price;
    PlayerInfo[playerid][pIsCasinoBet] = bet_sel;
    PlayerInfo[playerid][pCash] -= bet_price;

    PlayerInfo[playerid][pCasinoCrash] = bet_price;


    new string[129];
    format(string, sizeof(string), "[CASINO] Ban da dat cuoc vao %s voi so tien $%s.", (bet_sel == 1) ? "Tai" : "Xiu",number_format(bet_price)) ;
    SendClientMessage(playerid, COLOR_CASINO, string);
    Casino_Info[i][Casino_BetCash][bet_sel] += bet_price;
    Company[2][CompanyBudget] += bet_price;

    format(string, sizeof(string), "[%s] %s đã đặt cược ở phiên %d số tiền $%s vào %s", GetLogTime(),GetPlayerNameEx(playerid), Casino_Info[0][Casino_stacks],
    	number_format(bet_price) , ( bet_sel == 1) ? "Tai" : "Xiu");         
    SendLogDiscordMSG(logs_casino, string);
    SaveCompany(2);


    return 1;

}
stock SetActorChatBubble(actorid, string[],color, time) {
    new Float:Pos[3];
    GetDynamicActorPos(actorid, Pos[0],Pos[1],Pos[2]);
    UpdateDynamic3DTextLabelText( Casino_Info[0][Actor_text],color,string);


    SetTimerEx("DestroyActorText", time* 1000, 0, "0", 0);
}
forward DestroyActorText();
public DestroyActorText( ) {
	UpdateDynamic3DTextLabelText( Casino_Info[0][Actor_text],-1,"");
}
CMD:saveaaa(playerid,params[]) {
   SaveCompany(2);
   return 1;
} 
ProDetectorCasino(Float: f_Radius, casinoid, string[],col1,col2,col3,col4,col5,chat=0)
{
	new
		Float: f_playerPos[3];

	f_playerPos[0] =   1126.6766;
	f_playerPos[1] =   -2.0203;
	f_playerPos[2] =   1000.6797;
	new str[128];
	foreach(new i: Player)
	{

		if(IsPlayerInRangeOfPoint(i, f_Radius / 16, f_playerPos[0], f_playerPos[1], f_playerPos[2])) {

			SendClientMessageEx(i, col1, string);
			
		}
		else if(IsPlayerInRangeOfPoint(i, f_Radius / 8, f_playerPos[0], f_playerPos[1], f_playerPos[2])) {

			SendClientMessageEx(i, col2, string);
		

		}
		else if(IsPlayerInRangeOfPoint(i, f_Radius / 4, f_playerPos[0], f_playerPos[1], f_playerPos[2])) {

			SendClientMessageEx(i, col3, string);
		

		}
		else if(IsPlayerInRangeOfPoint(i, f_Radius / 2, f_playerPos[0], f_playerPos[1], f_playerPos[2])) {

			SendClientMessageEx(i, col4, string);
		


		}
		if(GetPVarInt(i, "BigEar") == 1 || GetPVarInt(i, "BigEar") == 6) {
			new string2[128] = "(BE) ";
			strcat(string2,string, sizeof(string2));
			SendClientMessageEx(i, col1,string);
		}
	}
	return 1;
}
hook OnGameModeInit() {
	new i = 0;
	Casino_Info[i][Casino_Timer] = defer CasinoTimer[5000](i); 
    Casino_Info[i][Actor_text] = CreateDynamic3DTextLabel(" ", -1,  1126.6766,-2.0203,1000.6797,265.3413,20 ,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,-1,-1);
	Casino_Info[i][Actor_Statstext] = CreateDynamic3DTextLabel("<CASINO>", -1, 1127.299438, -2.090329, 1000.469787+1,20, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, -1, -1, -1);
	Casino_Info[i][Casino_teps] = 0;
	Casino_Info[i][Casino_stacks] = 1;
	Casino_Info[i][Casino_Obj] = CreateDynamicObject(2188, 1127.299438, -2.090329, 1000.469787, 0.000000, 0.000000, 87.399986);

	
	Casino_Info[i][Casino_Actor2] = CreateDynamicActor(12,1141.1632,-6.8228,1000.6719,84.1538);

	Casino_Info[i][Casino_Actor] = CreateDynamicActor(12,1126.6766,-2.0203,1000.6797,265.3413);
	SetDynamicActorVirtualWorld(Casino_Info[i][Casino_Actor] , 11);
	SetDynamicActorVirtualWorld(Casino_Info[i][Casino_Actor2] , 11);
	ApplyDynamicActorAnimation(Casino_Info[i][Casino_Actor] , "STRIP", "PLY_CASH", 4.0, 1, 0, 0, 0, 0);

	//
	new tmpobjid;
    tmpobjid = CreateDynamicObject(2062, 1143.563842, -6.449186, 1000.036926, 89.999992, 6.774096, -96.773956, 11, 12, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 6351, "rodeo02_law2", "woodboards1", 0x00000000);
    tmpobjid = CreateDynamicObject(2074, 1140.478637, -8.833272, 1002.189880, 0.000000, 0.000014, 90.000000, 11, 12, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 4, 14629, "ab_chande", "ab_goldpipe", 0x00000000);
    tmpobjid = CreateDynamicObject(2074, 1140.478637, -7.833272, 1002.189880, 0.000000, 0.000014, 90.000000, 11, 12, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 4, 14629, "ab_chande", "ab_goldpipe", 0x00000000);
    tmpobjid = CreateDynamicObject(2074, 1140.478637, -6.833272, 1002.189880, 0.000000, 0.000014, 90.000000, 11, 12, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 4, 14629, "ab_chande", "ab_goldpipe", 0x00000000);
    tmpobjid = CreateDynamicObject(2074, 1140.478637, -5.833272, 1002.189880, 0.000000, 0.000014, 90.000000, 11, 12, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 4, 14629, "ab_chande", "ab_goldpipe", 0x00000000);
    tmpobjid = CreateDynamicObject(2074, 1140.478637, -4.833272, 1002.189880, 0.000000, 0.000014, 90.000000, 11, 12, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 4, 14629, "ab_chande", "ab_goldpipe", 0x00000000);
    tmpobjid = CreateDynamicObject(2074, 1140.478637, -3.833272, 1002.189880, 0.000000, 0.000014, 90.000000, 11, 12, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 4, 14629, "ab_chande", "ab_goldpipe", 0x00000000);
    tmpobjid = CreateDynamicObject(2074, 1140.478637, -2.833272, 1002.189880, 0.000000, 0.000014, 90.000000, 11, 12, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 4, 14629, "ab_chande", "ab_goldpipe", 0x00000000);
    tmpobjid = CreateDynamicObject(2074, 1140.478637, -1.833273, 1002.189880, 0.000000, 0.000014, 90.000000, 11, 12, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 4, 14629, "ab_chande", "ab_goldpipe", 0x00000000);
    tmpobjid = CreateDynamicObject(2074, 1140.478637, -0.833272, 1002.189880, 0.000000, 0.000014, 90.000000, 11, 12, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 4, 14629, "ab_chande", "ab_goldpipe", 0x00000000);
    tmpobjid = CreateDynamicObject(2074, 1140.478637, 0.166725, 1002.189880, 0.000000, 0.000014, 90.000000, 11, 12, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 4, 14629, "ab_chande", "ab_goldpipe", 0x00000000);
    tmpobjid = CreateDynamicObject(2074, 1140.478637, 1.166725, 1002.189880, 0.000000, 0.000014, 90.000000, 11, 12, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 4, 14629, "ab_chande", "ab_goldpipe", 0x00000000);
    tmpobjid = CreateDynamicObject(2074, 1140.478637, 2.166726, 1002.189880, 0.000000, 0.000014, 90.000000, 11, 12, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 4, 14629, "ab_chande", "ab_goldpipe", 0x00000000);
    tmpobjid = CreateDynamicObject(2062, 1143.563842, -1.739179, 1000.036926, 89.999992, 13.368558, -103.368438, 11, 12, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 6351, "rodeo02_law2", "woodboards1", 0x00000000);
    tmpobjid = CreateDynamicObject(2358, 1143.215087, -2.563765, 999.776550, -0.000022, 0.000022, -89.999900, 11, 12, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14786, "ab_sfgymbeams", "knot_wood128", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 14786, "ab_sfgymbeams", "knot_wood128", 0x00000000);
    tmpobjid = CreateDynamicObject(2074, 1140.478637, 3.166726, 1002.189880, 0.000000, 0.000014, 90.000000, 11, 12, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 4, 14629, "ab_chande", "ab_goldpipe", 0x00000000);
    tmpobjid = CreateDynamicObject(18644, 1131.067626, -11.091370, 1001.509277, 44.999996, 0.000056, 89.999916, 11, 12, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 1560, "7_11_door", "CJ_CHROME2", 0x00000000);
    tmpobjid = CreateDynamicObject(18644, 1130.627685, -11.091370, 1001.509277, 44.999980, -0.000029, -90.000137, 11, 12, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 1560, "7_11_door", "CJ_CHROME2", 0x00000000);
    tmpobjid = CreateDynamicObject(18644, 1130.847656, -10.871399, 1001.509277, 45.000011, 0.000012, 179.999816, 11, 12, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 1560, "7_11_door", "CJ_CHROME2", 0x00000000);
    tmpobjid = CreateDynamicObject(18644, 1130.847656, -11.311342, 1001.509277, 44.999954, 0.000012, -0.000014, 11, 12, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 1560, "7_11_door", "CJ_CHROME2", 0x00000000);
    tmpobjid = CreateDynamicObject(18644, 1131.003173, -10.935853, 1001.209289, 44.999996, 0.000048, 134.999893, 11, 12, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 1560, "7_11_door", "CJ_CHROME2", 0x00000000);
    tmpobjid = CreateDynamicObject(18644, 1130.692138, -11.246889, 1001.209289, 44.999958, -0.000018, -45.000015, 11, 12, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 1560, "7_11_door", "CJ_CHROME2", 0x00000000);
    tmpobjid = CreateDynamicObject(18644, 1130.692138, -10.935853, 1001.209289, 44.999992, -0.000012, -135.000015, 11, 12, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 1560, "7_11_door", "CJ_CHROME2", 0x00000000);
    tmpobjid = CreateDynamicObject(18644, 1131.003173, -11.246889, 1001.209289, 44.999958, 0.000041, 44.999904, 11, 12, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 1560, "7_11_door", "CJ_CHROME2", 0x00000000);
    tmpobjid = CreateDynamicObject(2289, 1143.739379, -7.792502, 1001.786499, -0.000007, -0.000007, -89.999961, 11, 12, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 11631, "mp_ranchcut", "CJ_PAINTING20", 0x00000000);
    tmpobjid = CreateDynamicObject(2714, 1143.775756, -7.795920, 1002.711303, 0.000014, 360.000000, 89.999946, 11, 12, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 19063, "xmasorbs", "sphere", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19962, "samproadsigns", "materialtext1", 0x00000000);
    tmpobjid = CreateDynamicObject(19797, 1143.722534, -7.785789, 1002.709716, 0.000000, 180.000000, -90.000038, 11, 12, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 9278, "gazsfnlite", "sfxref_lite2c", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 1259, "billbrd", "spotlight_64", 0x00000000);
    tmpobjid = CreateDynamicObject(2714, 1143.775756, -9.026634, 1001.670898, 0.000014, 360.000000, 89.999946, 11, 12, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 19063, "xmasorbs", "sphere", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19962, "samproadsigns", "materialtext1", 0x00000000);
    tmpobjid = CreateDynamicObject(2074, 1140.478637, -9.833272, 1002.189880, 0.000000, 0.000014, 90.000000, 11, 12, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 4, 14629, "ab_chande", "ab_goldpipe", 0x00000000);
    tmpobjid = CreateDynamicObject(2534, 1143.276123, -10.143852, 999.982299, 0.000000, -0.000007, -90.000053, 11, 12, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14650, "ab_trukstpc", "sa_wood08_128", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 14650, "ab_trukstpc", "sa_wood08_128", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 14537, "pdomebar", "club_bottles1_SFW", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 14650, "ab_trukstpc", "sa_wood08_128", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 4, 14650, "ab_trukstpc", "sa_wood08_128", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 5, 19480, "signsurf", "sign", 0x00000000);
    tmpobjid = CreateDynamicObject(19797, 1143.722534, -9.016502, 1001.669311, 0.000000, 180.000000, -90.000083, 11, 12, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 9278, "gazsfnlite", "sfxref_lite2c", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 1259, "billbrd", "spotlight_64", 0x00000000);
    tmpobjid = CreateDynamicObject(19131, 1143.746337, -0.261236, 1002.506958, -0.000007, 0.000029, 0.000029, 11, 12, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 1654, "dynamite", "clock64", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 1560, "7_11_door", "CJ_CHROME2", 0x00000000);
    tmpobjid = CreateDynamicObject(2730, 1143.771972, -0.256597, 1002.474487, 0.000029, 0.000007, 89.999877, 11, 12, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 19063, "xmasorbs", "sphere", 0x60000000);
    tmpobjid = CreateDynamicObject(2286, 1143.721557, -4.989713, 1002.617797, -0.000007, -0.000007, -90.000068, 11, 12, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14420, "dr_gsbits", "mp_apt1_pic5", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 14420, "dr_gsbits", "mp_apt1_frame1", 0x00000000);
    tmpobjid = CreateDynamicObject(2534, 1143.276123, -11.133860, 999.982299, 0.000000, -0.000007, -90.000053, 11, 12, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14650, "ab_trukstpc", "sa_wood08_128", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 14650, "ab_trukstpc", "sa_wood08_128", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 14537, "pdomebar", "club_bottles1_SFW", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 14650, "ab_trukstpc", "sa_wood08_128", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 4, 14650, "ab_trukstpc", "sa_wood08_128", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 5, 19480, "signsurf", "sign", 0x00000000);
    tmpobjid = CreateDynamicObject(19940, 1142.960815, -10.657571, 999.982055, 0.000000, 90.000000, 0.000000, 11, 12, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14650, "ab_trukstpc", "sa_wood08_128", 0xFFFFFFFF);
    tmpobjid = CreateDynamicObject(19940, 1142.960815, -10.657571, 999.551818, 0.000000, 90.000000, 0.000000, 11, 12, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14650, "ab_trukstpc", "sa_wood08_128", 0xFFFFFFFF);
    tmpobjid = CreateDynamicObject(2162, 1143.776733, -2.158997, 1000.716857, -0.000022, 0.000029, -89.999900, 11, 12, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 13007, "sw_bankint", "woodfloor1", 0x00000000);
    tmpobjid = CreateDynamicObject(2062, 1143.563842, -7.169188, 1000.036926, 89.999992, 3.398912, -93.398750, 11, 12, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14739, "whorebits", "AH_beercabinet2", 0x00000000);
    tmpobjid = CreateDynamicObject(2714, 1143.740722, -4.492641, 1001.527282, 0.000007, 270.000000, 90.000038, 11, 12, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 19063, "xmasorbs", "sphere", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19962, "samproadsigns", "materialtext1", 0x00000000);
    tmpobjid = CreateDynamicObject(19797, 1143.687377, -4.491055, 1001.537353, -0.000007, 270.000000, -90.000099, 11, 12, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 9278, "gazsfnlite", "sfxref_lite2c", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 1259, "billbrd", "spotlight_64", 0x00000000);
    tmpobjid = CreateDynamicObject(2271, 1143.252441, -6.423673, 1002.508544, -0.000007, -0.000007, -90.000068, 11, 12, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 1, 14420, "dr_gsbits", "mp_apt1_pic6", 0x00000000);
    tmpobjid = CreateDynamicObject(2714, 1143.740722, -6.903531, 1001.527282, 0.000007, 270.000000, 90.000076, 11, 12, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 19063, "xmasorbs", "sphere", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19962, "samproadsigns", "materialtext1", 0x00000000);
    tmpobjid = CreateDynamicObject(19797, 1143.687377, -6.901944, 1001.537353, -0.000007, 270.000000, -90.000099, 11, 12, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 9278, "gazsfnlite", "sfxref_lite2c", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 1259, "billbrd", "spotlight_64", 0x00000000);
    tmpobjid = CreateDynamicObject(2641, 1143.727661, -10.477219, 1002.478515, -0.000014, 270.000000, -89.999923, 11, 12, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 19962, "samproadsigns", "materialtext1", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 14654, "ab_trukstpe", "bbar_plates2", 0x00000000);
    tmpobjid = CreateDynamicObject(19483, 1143.766357, -2.818507, 1002.566894, -0.000007, -0.000014, -179.999862, 11, 12, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14654, "ab_trukstpe", "bbar_sports1", 0x00000000);
    tmpobjid = CreateDynamicObject(2714, 1137.950561, -11.636199, 1001.772338, 0.000000, 270.000000, 0.000091, 11, 12, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 19063, "xmasorbs", "sphere", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19962, "samproadsigns", "materialtext1", 0x00000000);
    tmpobjid = CreateDynamicObject(19797, 1137.952148, -11.582864, 1001.782409, 0.000000, 270.000000, 179.999771, 11, 12, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 9278, "gazsfnlite", "sfxref_lite2c", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 1259, "billbrd", "spotlight_64", 0x00000000);
    tmpobjid = CreateDynamicObject(2289, 1135.724975, -11.590413, 1001.311035, 0.000000, -0.000007, 179.999801, 11, 12, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14420, "dr_gsbits", "mp_apt1_pic2", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 14420, "dr_gsbits", "mp_apt1_frame2", 0x00000000);
    tmpobjid = CreateDynamicObject(2714, 1135.675903, -11.636199, 1002.297119, -0.000004, 180.000000, 0.000075, 11, 12, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 19063, "xmasorbs", "sphere", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19962, "samproadsigns", "materialtext1", 0x00000000);
    tmpobjid = CreateDynamicObject(19797, 1135.625366, -11.582864, 1002.298706, -0.000004, 360.000000, 179.999801, 11, 12, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 9278, "gazsfnlite", "sfxref_lite2c", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 1259, "billbrd", "spotlight_64", 0x00000000);
    tmpobjid = CreateDynamicObject(2272, 1139.136718, -11.137537, 1000.913330, 0.000000, -0.000007, 179.999801, 11, 12, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 1, 14420, "dr_gsbits", "mp_apt1_pic4", 0x00000000);
    tmpobjid = CreateDynamicObject(2714, 1139.616821, -11.636199, 1002.247131, -0.000004, 180.000000, 0.000120, 11, 12, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 19063, "xmasorbs", "sphere", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19962, "samproadsigns", "materialtext1", 0x00000000);
    tmpobjid = CreateDynamicObject(19797, 1139.606689, -11.582864, 1002.248718, -0.000004, 360.000000, 179.999801, 11, 12, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 9278, "gazsfnlite", "sfxref_lite2c", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 1259, "billbrd", "spotlight_64", 0x00000000);
    tmpobjid = CreateDynamicObject(948, 1143.443237, 3.076633, 999.689208, 0.000000, 0.000000, 0.000000, 11, 12, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 2, 802, "gta_proc_bushland", "veg_bush3red", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 18028, "cj_bar2", "GB_nastybar05", 0x00000000);
    tmpobjid = CreateDynamicObject(19786, 1142.215332, 3.471828, 1002.001037, 2.900027, 0.000029, -0.000061, 11, 12, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 15040, "cuntcuts", "GB_phone02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 14802, "lee_bdupsflat", "Bdup_Poster", 0x00000000);
    tmpobjid = CreateDynamicObject(19477, 1142.165039, 3.441798, 1001.878845, 0.000051, -0.000007, 89.999832, 11, 12, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 17588, "lae2coast_alpha", "LAShad1", 0x00000000);
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    tmpobjid = CreateDynamicObject(18633, 1143.332397, -1.734174, 1000.266662, 0.000022, -0.000022, 89.999824, 11, 12, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19820, 1143.267456, -2.424971, 999.786926, -0.000022, 0.000022, -89.999900, 11, 12, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19820, 1143.257446, -2.805341, 999.786926, -0.000022, 0.000022, -89.999900, 11, 12, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19820, 1143.177368, -2.595136, 999.786926, -0.000022, 0.000022, -89.999900, 11, 12, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1548, 1140.497558, -6.795263, 1000.782043, 0.000000, 0.000000, 90.000000, 11, 12, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1548, 1140.497558, -2.455262, 1000.782043, 0.000000, 0.000000, 90.000000, 11, 12, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19611, 1130.848510, -11.091370, 999.690002, 0.000007, 0.000044, 89.999946, 11, 12, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(18962, 1130.843750, -10.845643, 1001.469543, -79.999984, 270.000030, 0.000049, 11, 12, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19098, 1130.672241, -11.260315, 1001.175231, 84.999969, 269.999877, -44.999855, 11, 12, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2287, 1143.309448, -9.023703, 1002.316528, -0.000007, -0.000007, -89.999961, 11, 12, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1670, 1140.396240, -9.437504, 1000.799987, 0.000000, 0.000000, 90.000000, 11, 12, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1670, 1140.396240, -5.357503, 1000.799987, 0.000000, 0.000000, 90.000000, 11, 12, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(11743, 1143.390991, -9.246867, 1000.731750, 3.599998, 0.999998, -91.299995, 11, 12, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1670, 1140.396240, -1.127503, 1000.799987, 0.000000, 0.000000, 90.000000, 11, 12, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1666, 1140.351440, -0.653625, 1000.869750, 0.000000, 0.000000, 0.000000, 11, 12, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(18102, 1123.484252, 15.500204, 1002.526611, 90.000000, 0.000000, -180.000000, 11, 12, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1520, 1143.524902, -2.023132, 1001.266784, 89.999992, 13.368575, -103.368438, 11, 12, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1520, 1143.524902, -1.903015, 1001.266784, 89.999992, 13.368575, -103.368438, 11, 12, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1520, 1143.524902, -1.782897, 1001.266784, 89.999992, 13.368575, -103.368438, 11, 12, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1520, 1143.524902, -1.842957, 1001.346801, 89.999992, 13.368575, -103.368438, 11, 12, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1520, 1143.524902, -1.973083, 1001.346801, 89.999992, 13.368575, -103.368438, 11, 12, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1520, 1143.524902, -1.913025, 1001.426757, 89.999992, 13.368575, -103.368438, 11, 12, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19820, 1143.780883, -2.620421, 1001.247131, 89.999992, 13.368575, -103.368438, 11, 12, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19820, 1143.780883, -2.770569, 1001.247131, 89.999992, 13.368575, -103.368438, 11, 12, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19820, 1143.780883, -2.900696, 1001.247131, 89.999992, 13.368575, -103.368438, 11, 12, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19820, 1143.780883, -2.840636, 1001.367126, 89.999992, 13.368575, -103.368438, 11, 12, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19820, 1143.780883, -2.690490, 1001.367126, 89.999992, 13.368575, -103.368438, 11, 12, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2232, 1117.363159, 12.690093, 1004.858459, 21.600006, 0.000000, 45.000000, 11, 12, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(18633, 1143.332397, -6.444181, 1000.266662, 0.000029, -0.000022, 89.999801, 11, 12, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(18633, 1143.332397, -7.164183, 1000.266662, 0.000037, -0.000022, 89.999778, 11, 12, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19822, 1143.760375, -2.205017, 1000.816589, 89.999992, 13.368575, -103.368438, 11, 12, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19822, 1143.760375, -2.325134, 1000.816589, 89.999992, 13.368575, -103.368438, 11, 12, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19822, 1143.760375, -2.445250, 1000.816589, 89.999992, 13.368575, -103.368438, 11, 12, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19822, 1143.760375, -2.385193, 1000.906616, 89.999992, 13.368575, -103.368438, 11, 12, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19822, 1143.760375, -2.255065, 1000.906616, 89.999992, 13.368575, -103.368438, 11, 12, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19822, 1143.760375, -2.325134, 1000.986633, 89.999992, 13.368575, -103.368438, 11, 12, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19819, 1143.543945, -2.667175, 1000.846862, -0.000022, 0.000029, -89.999900, 11, 12, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19819, 1143.543945, -2.867371, 1000.846862, -0.000022, 0.000029, -89.999900, 11, 12, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19818, 1143.679199, -3.344420, 1000.846618, -0.000022, 0.000029, -89.999900, 11, 12, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19818, 1143.679199, -3.214293, 1000.846618, -0.000022, 0.000029, -89.999900, 11, 12, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19818, 1143.679199, -3.084167, 1000.846618, -0.000022, 0.000029, -89.999900, 11, 12, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19818, 1143.439086, -3.344420, 1000.846618, -0.000022, 0.000037, -89.999900, 11, 12, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19818, 1143.439086, -3.214293, 1000.846618, -0.000022, 0.000037, -89.999900, 11, 12, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19818, 1143.439086, -3.084167, 1000.846618, -0.000022, 0.000037, -89.999900, 11, 12, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1551, 1143.495117, -2.179260, 1001.266662, 89.999992, 13.368575, -103.368438, 11, 12, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1551, 1143.495117, -2.309386, 1001.266662, 89.999992, 13.368575, -103.368438, 11, 12, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1551, 1143.495117, -2.439513, 1001.266662, 89.999992, 13.368575, -103.368438, 11, 12, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1551, 1143.495117, -2.389465, 1001.356689, 89.999992, 13.368575, -103.368438, 11, 12, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1551, 1143.495117, -2.219299, 1001.356689, 89.999992, 13.368575, -103.368438, 11, 12, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2283, 1143.711547, -5.700161, 1001.556823, -0.000007, -0.000007, -90.000068, 11, 12, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2288, 1137.053222, -11.127075, 1000.802001, 0.000000, -0.000007, 179.999801, 11, 12, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2272, 1136.914550, -11.110130, 1002.132629, 0.000000, -0.000007, 179.999801, 11, 12, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2278, 1138.642456, -11.150143, 1002.082214, 0.000000, -0.000007, 179.999801, 11, 12, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2232, 1128.826171, 12.723268, 1004.913513, 21.599990, -0.000005, -44.999984, 11, 12, -1, 300.00, 300.00); 

}
hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
	if(newkeys & KEY_YES) {
		if(IsPlayerInRangeOfPoint(playerid, 3, 1126.6766,-2.0203,1000.6797)) {
			if(PlayerInfo[playerid][pCompany] == 2 && PlayerInfo[playerid][pRank] >= 6) {
				Dialog_Show(playerid, DIALOG_OWNER_CASINO, DIALOG_STYLE_LIST, "Casino", "Bat casino\nTat Casino\nQuan li doanh thu", "Dong y", "Thoat");
			}
		}
		if(IsPlayerInRangeOfPoint(playerid,3, 1141.1632,-6.8228,1000.6719)) {
			new str[329];
			str = "Vat pham\t#Con lai\t#Gia tien\n";
			for(new i = 0 ; i < 5 ; i++) {

				if(Company[2][CompanyItem][i] >= 1) {
					format(str, sizeof(str), "%s\t%s\t%d\t$%s\n", str,ItemInfo[Company[2][CompanyItem][i]][ItemName],Company[2][CompanyAmount][i],number_format(Company[2][CompanyPrice][i]));
				}
			}
			Dialog_Show(playerid, DIALOG_CASINO_BAR, DIALOG_STYLE_TABLIST_HEADERS, "Casino", str, "Dong y", "Thoat");
		}
	}
}
hook OnPlayerConnect(playerid) {
	PlayerInfo[playerid][pCasinoBet][1] = 0;
	PlayerInfo[playerid][pCasinoBet][2] = 0;
    PlayerInfo[playerid][pIsCasinoBet] = 0;
    RemoveBuildingForPlayer(playerid, 2188, 1125.140, -3.414, 1000.580, 0.250);
    RemoveBuildingForPlayer(playerid, 2188, 1127.079, -1.679, 1000.580, 0.250);
    RemoveBuildingForPlayer(playerid, 2188, 1125.150, -0.031, 1000.580, 0.250);
    RemoveBuildingForPlayer(playerid, 2964, 1119.270, 7.617, 1001.070, 0.250);
    RemoveBuildingForPlayer(playerid, 2964, 1123.150, 7.617, 1001.070, 0.250);
    RemoveBuildingForPlayer(playerid, 2964, 1127.020, 7.617, 1001.070, 0.250);
}