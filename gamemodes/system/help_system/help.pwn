stock MainHelp(playerid) {
    Dialog_Show(playerid, DIALOG_MAIN_HELP, DIALOG_STYLE_TABLIST, "Tro giup", "Lenh co ban\t#\n#\tCong viec\n#\tHe thong", "Dong y", "Thoat");
}
Dialog:DIALOG_MAIN_HELP(playerid, response, listitem, inputtext[]) {
    if (response) {
    	if(listitem == 0) {
    		cmd_cmds(playerid,"");
    	}
    	if(listitem == 1) {
    		Dialog_Show(playerid, DIALOG_HELPJOB_SEL, DIALOG_STYLE_TABLIST, "Tro giup @ Cong viec", "#\tPizza Boy\n\
    		#\tMiner\n\
    		#\tTrucker\n\
    		#\tDon rac\n\
    	    #\tBoc vac\n\
    		#\tTho sua dien", "Dong y", "Thoat");
    	}
    	if(listitem == 2) {
    		Dialog_Show(playerid, DIALOG_HELPSYSTEM_SEL, DIALOG_STYLE_TABLIST, "Tro giup @ He thong", "\
    		#\tInventory\n\
    		#\tNgan hang & ATM\n\
    		#\tGPS\n\
    	    #\tDien thoai\n\
    		#\tPhuong tien", "Dong y", "Thoat");
    	}
    }
}

CMD:cmds(playerid,params[]) {
	SendServerMessage(playerid, "CHAT: /me(low) /do(low) /ame /l(ow) /s(hout) /b /w(hisper) /id /newb");
	SendServerMessage(playerid, "BASIC: /helpup /my (inv,veh .v.v) /baocao /bank /ads /phone  /my acc(essory)");
	SendServerMessage(playerid, "BASIC: /chapnhan /vutbo /enter /exit /gps /giongnoi");
	SendServerMessage(playerid, "BASIC: /clothes /buyclothes /setting /thibanglai /gps ");
	SendServerMessage(playerid, "RENT: /rent (/thuenha) /cancelrent (/huythuenha) /myrent (/nhathue) /lockrent");
	SendServerMessage(playerid, "HOUSE(update...): /myhouse /buyf(urniture) /selectf(urniture) /tudo");
	SendServerMessage(playerid, "BUSINESS: /mua, /muacuahang");
	SendServerMessage(playerid, "VEHICLES: /veh status, engine, light, trunk, hood, fuel, window, pvlock, park.");
	
	SendServerMessage(playerid, "HINT: menu 'H' co the tuy chinh cac command tu dong de dang thao tac.");
	return true;
}
Dialog:DIALOG_HELPJOB_SEL(playerid, response, listitem, inputtext[]) {
	new str[1024];
    if (response) {
    	if(listitem == 0) {
	        format(str, sizeof(str), "\
	        	\\cDe bat dau lam viec can xin viec tai NPC (Y) de tuong tac va xin viec sau do thue xe\n\
	        	\\cTiep tuc den NPC de lay banh va bo banh len xe ( Phim Y ), sau khi da chat day banh su dung /giaobanh\n\
	        	\\cSau khi giao het banh co the ve cua hang lay banh va tiep tuc cong viec hoac dung lam viec bang cach tra xe \n\
	        	\\cTra xe se duoc hoan tien $90 (-$10).\
	        ");
	        ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "\\cTro giup @ Pizzaboy", str, "OK", "Cancel");
    	}
    	if(listitem == 1) {
    		format(str, sizeof(str), "\
	        	\\cDe bat dau cong viec Miner truoc het ban can nhan viec tai NPC (Y) > nhan viec, su dung GPS neu khong biet duong\n\
	        	\\cSau khi nhan viec ban can thue phuong tien Bobcat.\n\
	        	\\cDen cac vi tri khoang san sau do bam Y de bat dau khai thac, trong qua trinh cac phim se la Y hoac N ban can bam chuan xac \n\
	        	\\cSau khi khai thac thanh cong, ban lai gan phuong tien cua minh va bam phim 'Y' de dat da len xe.\n\
	        	\\cSau khi da day 5/5 khoang san ban can di den cho ban khoang san (su dung GPS > Cong viec neu khong biet duong).\n\
	        ");
	        ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "\\cTro giup @ Miner", str, "OK", "Cancel");
    	}
    	if(listitem == 2) {
    		format(str, sizeof(str), "\
	        	\\cDe bat dau cong viec Trucker truoc het ban can xin viec tai NPC ( GPS > Cong viec > Trucker )\n\
	        	\\cSau khi xin viec va thue xe di den diem Checkpoint de lay hang.\n\
	        	\\cBam 'Y' tai cac diem lay hang va sau do lai gan phuong tien bam 'Y' de chat hang len xe \n\
	        	\\cSau khi da du so hang quy dinh, ban quay ve diem checkpoint tren ban do de ban thung hang\n\
	        	\\cBam 'Y' de lay thung hang tu xe va ban.");
	        ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "\\cTro giup @ Trucker", str, "OK", "Cancel");
    	}
    	if(listitem == 3) {
    		format(str, sizeof(str), "\
	        	\\cDe bat dau cong viec Trashman truoc het ban can xin viec tai NPC ( GPS > Cong viec > Trashman )\n\
	        	\\cSau khi thue xe ban di xung quanh LS, de nhat cac bao rac tai ca nha dan, khu cong cong.\n\
	        	\\cSau khi da don du so rac 10/10 quay ve Checkpoint de nhan luong \n\
	        ");
	        ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "\\cTro giup @ Trashman", str, "OK", "Cancel");
    	}
    	if(listitem == 4) {
    		format(str, sizeof(str), "\
	        	\\cDe bat dau cong viec Worker truoc het ban can xin viec tai NPC ( GPS > Cong viec > Boc vac )\n\
	        	\\cSau khi xin viec lai gan thung hang bam 'Y' de lay hang\n\
	        	\\cDi den diem checkpoint de nhan tien thuong \n\
	        ");
	        ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "\\cTro giup @ Worker", str, "OK", "Cancel");
    	}
    	if(listitem == 5) {
    		format(str, sizeof(str), "\
	        	Bam 'Y' thue xe va bat dau lam viec\n\
	        	Toi CP xuong xe vao vao CP\n\
	        	Sau khi lam xong quay ve bao cao cong viec de nhan tien \n\
	        ");
	        ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "\\cTro giup @ Electrical", str, "OK", "Cancel");
    	}
    	if(listitem == 6) {
    		format(str, sizeof(str), "\
	        	Dung GPS tim dia diem chat go, bam 'N' de chat go\n\
	        	Bo go vao kho se nhan lai mot so go tuong ung\n\
	        	Sau khi lam dung GPS > tim vi tri ban go de ban \n\
	        ");
	        ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "\\cTro giup @ Lumberjack", str, "OK", "Cancel");
    	}
    }

}

Dialog:DIALOG_HELPSYSTEM_SEL(playerid, response, listitem, inputtext[]) {
	new str[1024];
    if (response) {
    	if(listitem == 0) {
	        format(str, sizeof(str), "\
	        	\\cBam phim H > inventory de mo tui do hoac su dung lenh /my inv \n\
	        	\\cTui do se chua tat ca cac vat pham cua ban, click chuot vao > thong tin de xem chi tiet vat pham\n\
	        	\\cMot so vat pham quan trong khong the vut bo");
	        ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "\\cTro giup @ Inventory", str, "OK", "Cancel");
    	}
    	if(listitem == 1) {
    		format(str, sizeof(str), "\
	        	\\cKhi bat dau ban can dang ki tai khoan ngan hang, ban se nhan duoc 1 the ATM khi dang ki (xem trong tui do)\n\
	        	\\cBan co the bam phim 'Y' tai cac tru so ATM hoac mo tui do va su dung the ATM de bat hien thi thao tac.\n\
	        	\\cThao tac chuyen tien can so tai khoan, ban can nhap so tai khoan cua nguoi muon chuyen \n\
	        	\\cMoi nguoi choi se co mot so tai khoan rieng khi dang ki tai khoan ngan hang\n\
	        	\\cKhach hang VIP cua ngan hang se duoc tang so tai khoan dep ( 1111 , 2222 .v.v)");
	        ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "\\cTro giup @ Banking", str, "OK", "Cancel");
    	}
    	if(listitem == 2) {
    		format(str, sizeof(str), "\
	        	\\cMua GPS tai cua hang tien loi 24/7\n\
	        	\\cSau khi mua GPS ban co the su dung lenh /gps hoac dung GPS trong tui do.\n\
	        	\\cGPS se chi duong ban di den cac dia diem quan trong cua thanh pho");
	        ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "\\cTro giup @ GPS", str, "OK", "Cancel");
    	}
    	if(listitem == 3) {
    		format(str, sizeof(str), "\
	        	\\cMua Dien thoai tai cua hang tien loi 24/7\n\
	        	\\cSau khi mua GPS ban co the su dung lenh /phone hoac dung Dien thoai trong tui do.\n\
	        	\\cDien thoai dung de lien lac, gui tin nhan .v.v");
	        ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "\\cTro giup @ GPS", str, "OK", "Cancel");
    	}
    	if(listitem == 4) {
    		format(str, sizeof(str), "\
	        	\\cCac phuong tien nguoi choi so huu se Spawn o vi tri ma nguoi choi da dau xe (/dauxe)\n\
	        	\\cSu dung lenh /my veh hoac H > chinh xe de xem Menu phuong tien va lay phuong tien.\n\
	        	\\cNguoi choi co the giao dich cac phuong tien bang lenh /sellmycar");
	        ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "\\cTro giup @ Vehicles", str, "OK", "Cancel");
    	}
    }
}
