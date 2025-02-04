new NumberContact[MAX_PLAYERS][10];
new NameContact[MAX_PLAYERS][10][32];
stock show_ContactList(playerid) {
    new string[1129];
    string = "Contact\t#Number\t#\n";
    for(new i = 0 ; i < 10 ; i++) {
        if( NumberContact[playerid][i] == 0) {
            format(string,sizeof string,"%sEmpty\t#\t#\n",string);
        }
        if( NumberContact[playerid][i] != 0) {
            format(string,sizeof string,"%s%s\t%d\t#\n",string,NameContact[playerid][i],NumberContact[playerid][i]);
        }
    }
    Dialog_Show(playerid, DIALOG_CONTACT, DIALOG_STYLE_TABLIST_HEADERS, "Phone # Contact List", string, "Chon", "Huy bo");
    return 1;   
}
Dialog:DIALOG_CONTACT(playerid, response, listitem, inputtext[]) {
    if(response) {
        if(NumberContact[playerid][listitem] == 0) {
            Dialog_Show(playerid, DIALOG_ADD_SDT, DIALOG_STYLE_INPUT, "Phone # Add Contact", "Vui long nhap so dien thoai ban muon them", "Them danh ba", "Huy bo");
        } 
        else if(NumberContact[playerid][listitem] != 0) {
            SetPVarInt(playerid,#ListSel,listitem);
            Dialog_Show(playerid, DIALOG_CONTACT_SEL, DIALOG_STYLE_LIST, "Phone # Contact List >", "Goi dien\nNhan tin\nXoa danh ba", "Chon", "Huy bo");
        } 
    }
    return 1;
}
Dialog:DIALOG_ADD_NAME(playerid, response, listitem, inputtext[]) {
    if(response) {
        if(isnull(inputtext)) return Dialog_Show(playerid, DIALOG_ADD_NAME, DIALOG_STYLE_INPUT, "Phone # Add Contact", "Vui long nhap ten danh ba ban muon luu", "Them danh ba", "Huy bo");
        new sdt_add =  GetPVarInt(playerid,#AddContactN);
        new contact_sl = GetPVarInt(playerid,#ListSel);
        NumberContact[playerid][contact_sl] = sdt_add;
        format(NameContact[playerid][contact_sl],  32, "%s", inputtext);
        
        new string[129];
        format(string, sizeof string, "Ban da them lien he: {40e154}%s{b4b4b4} ({40e154}%d{b4b4b4}) vao danh ba cua ban.", NameContact[playerid][contact_sl],NumberContact[playerid][contact_sl] );
        SendClientMessageEx(playerid,COLOR_BASIC,string);
    }
    return 1;
}
Dialog:DIALOG_ADD_SDT(playerid, response, listitem, inputtext[]) {
    if(response) {
        if(isnull(inputtext)) return Dialog_Show(playerid, DIALOG_ADD_SDT, DIALOG_STYLE_INPUT, "Phone # Add Contact", "Vui long nhap so dien thoai ban muon them", "Them danh ba", "Huy bo");
        SetPVarInt(playerid, #AddContactN, strval(inputtext));
        Dialog_Show(playerid, DIALOG_ADD_NAME, DIALOG_STYLE_INPUT, "Phone # Add Contact", "Vui long nhap ten danh ba ban muon luu", "Them danh ba", "Huy bo");
    }
    return 1;
}
Dialog:DIALOG_CONTACT_SEL(playerid, response, listitem, inputtext[]) {
    if(response) {
        new contact_sl = GetPVarInt(playerid,#ListSel);
        if(listitem == 0) {
            new str[20];
            format(str, sizeof str, "%d", NumberContact[playerid][contact_sl]);
            cmd_call(playerid,str);
        }
        if(listitem == 1) {
            SetPVarInt(playerid, "guitinnhan_SDT", NumberContact[playerid][contact_sl]);
            Dialog_Show(playerid, DIALOG_SMS_SUC, DIALOG_STYLE_INPUT, "Phone - Gui tin nhan", "Vui long nhap noi dung tin nhan", "Gui tin nhan", "Huy bo");
        }
        if(listitem == 2) {
            new string[129];
            format(string, sizeof string, "Ban da xoa lien he: {e14040}%s{b4b4b4} ({e14040}%d{b4b4b4}) khoi danh ba cua ban.", NameContact[playerid][contact_sl],NumberContact[playerid][contact_sl] );
            SendClientMessageEx(playerid,COLOR_BASIC,string);
            NumberContact[playerid][contact_sl] = 0;
            format(NameContact[playerid][contact_sl],  32, "Empty", NumberContact[playerid][contact_sl]);
           
        }
    }
    return 1;
}
CMD:phone(playerid,params[])  {
    Dialog_Show(playerid, DIALOG_PHONE, DIALOG_STYLE_LIST, "Phone # Main", "Thong tin dien thoai\nGoi dien\nNhan tin\nDanh ba", "Chon", "Huy bo");
	return 1;
} 
Dialog:DIALOG_PHONE(playerid, response, listitem, inputtext[]) {
    if(response) {
        	switch(listitem) {
        	case 0: {
        		new str[129];
        		format(str, sizeof str, "So dien thoai cua ban la: %d", PlayerInfo[playerid][pPnumber]);
        		ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX,"Phone", str, "Dong y", "Thoat");
        	}
        	case 1: {
        		Dialog_Show(playerid, DIALOG_CALL, DIALOG_STYLE_INPUT, "Phone # Call", "Vui long nhap so dien thoai ban muon goi", "Goi dien", "Thoat");
        	}
        	case 2: {
        		Dialog_Show(playerid, DIALOG_SMS, DIALOG_STYLE_INPUT, "Phone # SMS", "Vui long nhap SDT ban can gui tin nhan", "Tiep tuc", "Huy bo");
            }
            case 3: {

                show_ContactList(playerid);
            }
        }
    }
    return 1;
}
Dialog:DIALOG_CALL(playerid, response, listitem, inputtext[]) {
    if(response) {
        if(!strval(inputtext)) return Dialog_Show(playerid, DIALOG_CALL, DIALOG_STYLE_INPUT, "Phone # Call", "Vui long nhap so dien thoai ban muon goi", "Goi dien", "Thoat");
        cmd_call(playerid,inputtext);
    }
    return 1;
}
Dialog:DIALOG_SMS(playerid, response, listitem, inputtext[]) 
{
    if(response) 
    {
        SetPVarInt(playerid, "guitinnhan_SDT", strval(inputtext));
        Dialog_Show(playerid, DIALOG_SMS_SUC, DIALOG_STYLE_INPUT, "Phone - Gui tin nhan", "Vui long nhap noi dung tin nhan", "Gui tin nhan", "Huy bo");
    }
    else 
    {
    	Dialog_Show(playerid, DIALOG_PHONE, DIALOG_STYLE_LIST, "Phone # Main", "Thong tin dien thoai\nGoi dien\nNhan tin\nDanh ba", "Chon", "Huy bo");
    }
    return 1;
}
Dialog:DIALOG_SMS_SUC(playerid, response, listitem, inputtext[]) {
    new string[129];
    if(response) {
        format(string, sizeof string, "%d %s", GetPVarInt(playerid,"guitinnhan_SDT"),inputtext);
        cmd_sms(playerid,string);
    }
    return 1;
}
	