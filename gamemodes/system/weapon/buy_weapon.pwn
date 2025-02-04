CMD:buyweapon(playerid) {
    //

    if(!IsPlayerInRangeOfPoint(playerid, 20, 296.9991,-38.5125,1001.5156)) return SendErrorMessage(playerid, "Ban khong o gan cua hang vu khi");
    WeaponFactory(playerid);
    return 1;
}



stock WeaponFactory(playerid) {
    Dialog_Show(playerid, DIALOG_BUYWEAPON, DIALOG_STYLE_TABLIST_HEADERS, "Weapon Shop", "{b4b4b4}#Weapon\t#Tax\t#Price\n\
        Colt-45\t{bc4241}30%{b4b4b4}\t{41bc4a}$30.000{b4b4b4}\n\
        Silenced 9mm\t{bc4241}30%{b4b4b4}\t{41bc4a}$40.000{b4b4b4}\n\
        Desert Eagle\t{bc4241}30%{b4b4b4}\t{41bc4a}$70.000{b4b4b4}\n\
        Dung sung luc\t{bc4241}10%{b4b4b4}\t{41bc4a}$500/vien{b4b4b4}\n\
        Gay bong chay\t{bc4241}0%{b4b4b4}\t{41bc4a}$4.000{b4b4b4}\n", "Dong y", "Thoat");
    return 1;
}
Dialog:DIALOG_BUYWEAPON(playerid, response, listitem, inputtext[]) {
    if(response) {
        if(listitem == 0) {
        	SetPVarInt(playerid, #SelWeaponBuy, 1);
        	Dialog_Show(playerid, DIALOG_CF_WEAPON, DIALOG_STYLE_MSGBOX, "Weaon Shop - Confirm", "Ban co xac nhan mua vu khi Colt-45 khong?\n\
        		Gia ban: $30.000\n\
        		Thue: 30% (~$9.000)\n\
        		Tong thanh toan: $39.000", "Dong y", "Thoat");
        }
        if(listitem == 1) {
        	SetPVarInt(playerid, #SelWeaponBuy, 2);
        	Dialog_Show(playerid, DIALOG_CF_WEAPON, DIALOG_STYLE_MSGBOX, "Weaon Shop - Confirm", "Ban co xac nhan mua vu khi Silenced 9mm khong?\n\
        		Gia ban: $40.000\n\
        		Thue: 30% (~$12.000)\n\
        		Tong thanh toan: $62.000", "Dong y", "Thoat");
        }
        if(listitem == 2) {
        	SetPVarInt(playerid, #SelWeaponBuy, 3);
        	Dialog_Show(playerid, DIALOG_CF_WEAPON, DIALOG_STYLE_MSGBOX, "Weaon Shop - Confirm", "Ban co xac nhan mua vu khi Colt-45 khong?\n\
        		Gia ban: $70.000\n\
        		Thue: 30% (~$21.000)\n\
        		Tong thanh toan: $91.000", "Dong y", "Thoat");
        }
        if(listitem == 3) {
        	SetPVarInt(playerid, #SelWeaponBuy, 4);
        	Dialog_Show(playerid, DIALOG_BUY_AMMO, DIALOG_STYLE_INPUT, "Weaon Shop - Confirm", "Ban mua muon bao nhieu vien dan sung luc:", "Dong y", "Thoat");
        }
        if(listitem == 4) {
            SetPVarInt(playerid, #SelWeaponBuy, 5);
            Dialog_Show(playerid, DIALOG_CF_WEAPON, DIALOG_STYLE_INPUT, "Weaon Shop - Confirm", "Ban co xac nhan mua vu khi Gay bong chay voi gia $4.000", "Dong y", "Thoat");
        }

    }
    return 1;
}
Dialog:DIALOG_BUY_AMMO(playerid, response, listitem, inputtext[]) {
    if(response) {
    	if(strval(inputtext) > 99 || strval(inputtext) < 0) return Dialog_Show(playerid, DIALOG_BUY_AMMO, DIALOG_STYLE_INPUT, "Weaon Shop - Confirm", "Ban mua muon bao nhieu vien dan sung luc:", "Dong y", "Thoat");
        SetPVarInt(playerid, #SelAmountAmmo, strval(inputtext));
        SetPVarInt(playerid, #SelWeaponBuy, 4);
        new string[129];
        new price_tax = ( strval(inputtext) * 500 ) / 100 * 30;
        format(string,sizeof(string),"Ban co xac nhan mua %d vien dan sung luc khong?\n\
        		Gia ban: $500/stock\n\
        		So luong mua: %d\n\
        		Thue: %s\n\
        		Tong thanh toan: %s",strval(inputtext),strval(inputtext),  number_format(price_tax),number_format((strval(inputtext) * 500)  + price_tax));
        Dialog_Show(playerid, DIALOG_CF_WEAPON, DIALOG_STYLE_MSGBOX, "Weapon Shop - Confirm Ammo", string, "Dong y", "Huy");
    }
    return 1;
}
Dialog:DIALOG_CF_WEAPON(playerid, response, listitem, inputtext[]) {
    if(response) {
        if(GetPVarInt(playerid,#SelWeaponBuy) == 1) {
        	if(PlayerInfo[playerid][pCash] < 39000) return SendErrorMessage(playerid," Ban khong co du $39.000 de mua hang");
        	if( CheckInventorySlotEmpty(playerid,21,1) == -1) return SendErrorMessage(playerid,"Tui do cua ban da day khong the chua vat pham [ 1 Colt-45 ].");
 			Inventory_@Add(playerid, 21, 1);
 			GivePlayerMoneyEx(playerid,-39000);
 			DeletePVar(playerid,#SelWeaponBuy);
 			SendClientMessage(playerid, COLOR_BASIC, "Ban da mua thanh cong vu khi {f22323}Colt-45{b4b4b4} voi gia {4db855}$39.000{b4b4b4}.");
            new string_log[229];
            format(string_log, sizeof(string_log), "[%s] %s(%s) đã mua thành công 1 vũ khí Colt-45", GetLogTime(),GetPlayerNameEx(playerid));         
            SendLogDiscordMSG(logs_buywp, string_log);
        }
        if(GetPVarInt(playerid,#SelWeaponBuy) == 2) {
        	if(PlayerInfo[playerid][pCash] < 62000) return SendErrorMessage(playerid," Ban khong co du $62.000 de mua hang");
        	if( CheckInventorySlotEmpty(playerid,22,1) == -1) return SendErrorMessage(playerid,"Tui do cua ban da day khong the chua vat pham [ 1 Silenced 9mm ].");
 			Inventory_@Add(playerid, 22, 1);
 			GivePlayerMoneyEx(playerid,-62000);
 			DeletePVar(playerid,#SelWeaponBuy);
 			SendClientMessage(playerid, COLOR_BASIC, "Ban da mua thanh cong vu khi {f22323}Silenced 9mm{b4b4b4} voi gia {4db855}$62.0000{b4b4b4}.");
            new string_log[229];
            format(string_log, sizeof(string_log), "[%s] %s(%s) đã mua thành công 1 vũ khí Silenced 9mm", GetLogTime(),GetPlayerNameEx(playerid),GetDiscordUser(playerid));         
            SendLogDiscordMSG(logs_buywp, string_log);
        }
        if(GetPVarInt(playerid,#SelWeaponBuy) == 3) {
        	if(PlayerInfo[playerid][pCash] < 91000) return SendErrorMessage(playerid," Ban khong co du $91.000 de mua hang");
        	if( CheckInventorySlotEmpty(playerid,23,1) == -1) return SendErrorMessage(playerid,"Tui do cua ban da day khong the chua vat pham [ 1 Colt-45 ].");
 			Inventory_@Add(playerid, 23, 1);
 			GivePlayerMoneyEx(playerid,-91000);
 			DeletePVar(playerid,#SelWeaponBuy);
 			SendClientMessage(playerid, COLOR_BASIC, "Ban da mua thanh cong vu khi {f22323}Desert Eagle{b4b4b4} voi gia {4db855}$91.000{b4b4b4}.");
            new string_log[229];
            format(string_log, sizeof(string_log), "[%s] %s(%s) đã mua thành công 1 vũ khí Desert Eagle", GetLogTime(),GetPlayerNameEx(playerid),GetDiscordUser(playerid));         
            SendLogDiscordMSG(logs_buywp, string_log);
        }
        if(GetPVarInt(playerid,#SelWeaponBuy) == 4) {
        	new price_tax = ( GetPVarInt(playerid,#SelAmountAmmo) * 500 ) / 100 * 30;
        	new price = (GetPVarInt(playerid,#SelAmountAmmo) * 500) +price_tax;
        	if(PlayerInfo[playerid][pCash] < price) return SendErrorMessage(playerid," Ban khong co du $91.000 de mua hang");
        	if( CheckInventorySlotEmpty(playerid,23,GetPVarInt(playerid,#SelAmountAmmo)) == -1) return SendErrorMessage(playerid,"Tui do cua ban da day khong the chua vat pham [ 1 Colt-45 ].");
 			Inventory_@Add(playerid, 30, GetPVarInt(playerid,#SelAmountAmmo));
 			GivePlayerMoneyEx(playerid,-price);
 			DeletePVar(playerid,#SelWeaponBuy);
 			new string[129];
 			format(string,sizeof(string),"Ban da mua thanh cong {f22323}%d dan sung luc{b4b4b4} voi gia {4db855}$%s{b4b4b4}.",GetPVarInt(playerid,#SelAmountAmmo),number_format(price));
 			SendClientMessage(playerid, COLOR_BASIC, string);
            new string_log[229];
            format(string_log, sizeof(string_log), "[%s] %s(%s) đã mua thành công %d đạn súng lục", GetLogTime(),GetPlayerNameEx(playerid),strval(inputtext),GetDiscordUser(playerid));         
            SendLogDiscordMSG(logs_buywp, string_log);
        }
        if(GetPVarInt(playerid,#SelWeaponBuy) == 5) {
            new price = 4000;
            if(PlayerInfo[playerid][pCash] < price) return SendErrorMessage(playerid," Ban khong co du $91.000 de mua hang");
            GivePlayerMoneyEx(playerid,-price);
            GivePlayerValidWeapon(playerid,5,60000);
            DeletePVar(playerid,#SelWeaponBuy);
            new string[129];
            format(string,sizeof(string),"Ban da mua thanh cong {f22323} gay bong chay {b4b4b4} voi gia {4db855}$%s{b4b4b4}.",number_format(price));
            SendClientMessage(playerid, COLOR_BASIC, string);
            new string_log[229];
            format(string_log, sizeof(string_log), "[%s] %s(%s) đã mua thành công Gay bong chay", GetLogTime(),GetPlayerNameEx(playerid),GetDiscordUser(playerid),strval(inputtext));         
            SendLogDiscordMSG(logs_buywp, string_log);
        }

    }
    return 1;
}