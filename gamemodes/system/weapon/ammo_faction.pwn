
Dialog:WEAPON_AMMO(playerid, response, listitem, inputtext[]) {
    if(response) {
        if(listitem == 0) {
        	SetPVarInt(playerid, #SelAmmoBuy, 1);
            Dialog_Show(playerid, DIALOG_ADD_AMMO, DIALOG_STYLE_INPUT, "Weaon - #Confirm", "Ban muon lay bao nhieu dan Sung luc:", "Dong y", "Thoat");
        }
        if(listitem == 1) {
        	SetPVarInt(playerid, #SelAmmoBuy, 2);
            Dialog_Show(playerid, DIALOG_ADD_AMMO, DIALOG_STYLE_INPUT, "Weaon - #Confirm", "Ban mua muon bao nhieu vien dan Shotgun:", "Dong y", "Thoat");
        }
        if(listitem == 2) {
        	SetPVarInt(playerid, #SelAmmoBuy, 3);
            Dialog_Show(playerid, DIALOG_ADD_AMMO, DIALOG_STYLE_INPUT, "Weaon - #Confirm", "Ban mua muon bao nhieu vien dan Sung tieu lien:", "Dong y", "Thoat");
        }
        if(listitem == 3) {
        	SetPVarInt(playerid, #SelAmmoBuy, 4);
            Dialog_Show(playerid, DIALOG_ADD_AMMO, DIALOG_STYLE_INPUT, "Weaon - #Confirm", "Ban mua muon bao nhieu vien dan Dan sung truong:", "Dong y", "Thoat");
        }

    }
    return 1;
}
Dialog:DIALOG_ADD_AMMO(playerid, response, listitem, inputtext[]) {
    if(response) {
        new ammo_item,ammo_name[32];
        switch(GetPVarInt(playerid,#SelAmmoBuy)) {
            case 1: ammo_item = 30;
            case 2: ammo_item = 31;
            case 3: ammo_item = 32;
            case 4: ammo_item = 33;
        }
        switch(GetPVarInt(playerid,#SelAmmoBuy)) {
            case 1: ammo_name = "Dan sung luc";
            case 2: ammo_name = "Dan sung Shotgun";
            case 3: ammo_name = "Dan sung Tieu lien";
            case 4: ammo_name = "Dan sung Sung truong";
        }
        if(CheckItemAmount(playerid,ammo_item) >= 200) return SendErrorMessage(playerid,"Ban chi duoc phep lay toi da 200 vien dan.");
        new checkz = CheckItemAmount(playerid,ammo_item) + strval(inputtext) ;
        if(checkz >= 200) return SendErrorMessage(playerid,"Ban chi duoc phep lay toi da 200 vien dan trong tui do.");
        if( CheckInventorySlotEmpty(playerid,ammo_item,strval(inputtext)) == -1) return SendErrorMessage(playerid,"Tui do cua ban da day khong the chua vat pham [ 1 Colt-45 ].");
        Inventory_@Add(playerid, ammo_item, strval(inputtext));
        new string[129];
        format(string,sizeof(string),"Ban da lay thanh cong {f22323}%d vien dan %s{b4b4b4}.",strval(inputtext),ammo_name);
        SendClientMessage(playerid, COLOR_BASIC, string);

        new string_log[229];
        format(string_log, sizeof(string_log), "[%s] %s đã lấy %d viên đạn %s.", GetLogTime(),GetPlayerNameEx(playerid),strval(inputtext),ammo_name);         
        SendLogDiscordMSG(faction_weapons, string_log);
    }
    return 1;
}
            