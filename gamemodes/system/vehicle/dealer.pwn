#include <YSI\y_hooks>

new Speedlimit[MAX_PLAYERS];
new SpeedlimitSet[MAX_PLAYERS];
#define MAX_DEALER_VEH 20

enum DealerOld {
    dl_model,
    dl_color1,
    dl_color2,
    dl_price,
    dl_ownername[32], // chu
    dl_ownerreg[32], // thgian dang ky
    dl_ownerbirthdate[32],
    dl_ownergen, // 
    dl_pvlate[32],
    dl_ownernation,
    dl_speed
}
new DealerInfo[MAX_DEALER_VEH][DealerOld];
new bool:disablefixspeed = false;

CMD:truonghopkhan(playerid,params[]) {
	if(disablefixspeed == false) {
		disablefixspeed = true;
		SendClientMessageToAll(COLOR_YELLOW, "Admin da bat chuc nang gioi han toc do [khan cap loi he thong]");

	}
	else if(disablefixspeed == false) {
		disablefixspeed = true;
		SendClientMessageToAll(COLOR_YELLOW, "Admin da tat chuc nang gioi han toc do [khan cap loi he thong]");
	}
	return 1;
}
CMD:admindealercuozg(playerid,params[]) {
	if(PlayerInfo[playerid][pAdmin] < 99999 ) return 1;
    ShowAdminDealer(playerid);
    return 1;
}
CMD:savealldl(playerid) {
	if(PlayerInfo[playerid][pAdmin] < 2 ) return 1;
	for(new i = 0 ; i < MAX_DEALER_VEH; i++) {
		SaveEveryoneDL(i);
	}
	return 1;
}

stock ShowBuyDealer(playerid) {
	new string[2220];
	// ten pv , 
	string = "#\tPhuong tien\tGia tien\n";
	for(new i = 0 ; i < MAX_DEALER_VEH; i++) {
		if(DealerInfo[i][dl_model] != 0) {
			format(string, sizeof(string), "{b4b4b4}%s%d\t%s\t{46a151}%s\n", string,i,VehicleName[DealerInfo[i][dl_model]  - 400],number_format(DealerInfo[i][dl_price]));
		}
		else if(DealerInfo[i][dl_model] == 0) {
			format(string, sizeof(string), "%s%d\t{fa2626}SOLD OUT{b4b4b4}\t$0.0\n", string,i);
		}
	}
	Dialog_Show(playerid, BUY_DEALER_SEL, DIALOG_STYLE_TABLIST_HEADERS, "Vehicle Dealer > Buy", string, "Tuy chon", "Thoat");
	return 1;
}
stock AddDealerOld(dlid,modelid) {
	DealerInfo[dlid][dl_model] = modelid; // enbble
}
stock ShowAdminDealer(playerid) {
	new string[2220];
	// ten pv , 
	for(new i = 0 ; i < MAX_DEALER_VEH; i++) {
		if(DealerInfo[i][dl_model] != 0) {
			format(string, sizeof(string), "%s%d\t%s\n", string,i,VehicleName[DealerInfo[i][dl_model]  - 400]);
		}
		else if(DealerInfo[i][dl_model] == 0) {
			format(string, sizeof(string), "%s%d\tChua khoi tao\n", string,i);
		}
	}
	Dialog_Show(playerid, ADMIN_DEALER_SEL, DIALOG_STYLE_LIST, "Vehicle Dealer > Selection", string, "Tuy chon", "Thoat");
	return 1;
}
stock LoadCarDealer(dlid)
{
	new string[128];
	format(string, sizeof(string), "SELECT * FROM `car_dealer` WHERE `dl_id`=%d",dlid);
	mysql_function_query(MainPipeline, string, true, "OnLoadCarDealer", "i", dlid);

}
stock InsertCode(dlid)
{
    for(new i = 0 ; i < MAX_DEALER_VEH; i++) {
    	new string[128];
	    format(string, sizeof(string), "INSERT INTO `car_dealer` (`dl_id`) VALUES ('%d')", dlid);
        print(string);
    }
}
stock SaveEveryoneDL(dlid)
{
	new strupdate[2024];
	format(strupdate, sizeof strupdate, "UPDATE `car_dealer` SET `dl_model`= '%d',`dl_color1`= '%d',`dl_color2`= '%d',`dl_price`= '%d',\
	`dl_ownergen`= '%d',`dl_ownernation`= '%d',`dl_ownername`= '%s',`dl_ownerreg`= '%s',`dl_ownerbirthdate`= '%s', `dl_pvlate` = '%s',`dl_speed`= '%d' WHERE `dl_id`= '%d'", 
	DealerInfo[dlid][dl_model] ,
	DealerInfo[dlid][dl_color1] ,
	DealerInfo[dlid][dl_color2] ,
	DealerInfo[dlid][dl_price] ,
	DealerInfo[dlid][dl_ownergen] ,
	DealerInfo[dlid][dl_ownernation] ,
	DealerInfo[dlid][dl_ownername] ,
	DealerInfo[dlid][dl_ownerreg] ,
	DealerInfo[dlid][dl_ownerbirthdate] ,
	DealerInfo[dlid][dl_pvlate],
	DealerInfo[dlid][dl_speed], dlid);
	mysql_function_query(MainPipeline, strupdate, true, "OnSaveDLData", "i", dlid);
}

   

forward OnLoadCarDealer(dlid);
public OnLoadCarDealer(dlid) {

    new fields, szResult[64],rows;
	cache_get_data(rows, fields, MainPipeline);

	for(new row;row < rows;row++)
	{
		cache_get_field_content(row,  "dl_speed", szResult, MainPipeline); DealerInfo[dlid][dl_speed] = strval(szResult);
		cache_get_field_content(row,  "dl_model", szResult, MainPipeline); DealerInfo[dlid][dl_model] = strval(szResult);
		cache_get_field_content(row,  "dl_color1", szResult, MainPipeline); DealerInfo[dlid][dl_color1] = strval(szResult);
		cache_get_field_content(row,  "dl_color2", szResult, MainPipeline); DealerInfo[dlid][dl_color2] = strval(szResult);
		cache_get_field_content(row,  "dl_price", szResult, MainPipeline); DealerInfo[dlid][dl_price] = strval(szResult);
		cache_get_field_content(row,  "dl_ownergen", szResult, MainPipeline); DealerInfo[dlid][dl_ownergen] = strval(szResult);
		cache_get_field_content(row,  "dl_ownernation", szResult, MainPipeline); DealerInfo[dlid][dl_ownernation] = strval(szResult);
		cache_get_field_content(row,  "dl_ownername", DealerInfo[dlid][dl_ownername], MainPipeline); 
        cache_get_field_content(row,  "dl_ownerreg", DealerInfo[dlid][dl_ownerreg], MainPipeline); 
        cache_get_field_content(row,  "dl_ownerbirthdate", DealerInfo[dlid][dl_ownerbirthdate], MainPipeline); 
        cache_get_field_content(row,  "dl_pvlate", DealerInfo[dlid][dl_pvlate], MainPipeline); 

		break;
	}
	return 1;
}
forward OnSaveDLData(dlid);
public OnSaveDLData(dlid) {

}
Dialog:ADMIN_DEALER_SEL(playerid, response, listitem, inputtext[]) {
    if(response) {
    	SetPVarInt(playerid,#DealerIDEdit,listitem);
    	ShowEditDealer(playerid,listitem);
    }
    return 1;
}
stock DeleteDealer(dlid) {
	DealerInfo[dlid][dl_model] = 0;
	DealerInfo[dlid][dl_color1] = 0;
    DealerInfo[dlid][dl_color2] = 0;
    DealerInfo[dlid][dl_price] = 0;
    DealerInfo[dlid][dl_ownergen]= 0;
    DealerInfo[dlid][dl_ownernation] = 0;
    strcpy(DealerInfo[dlid][dl_ownername] , "Chua dang ky", 32);
    strcpy(DealerInfo[dlid][dl_ownerbirthdate] , "Chua dang ky", 32);
    strcpy(DealerInfo[dlid][dl_ownerreg] , "Chua dang ky", 32);
    SaveEveryoneDL(dlid);
    return 1;
}

stock ShowEditDealer(playerid,dlid,buy = 0) {
	new string[2229];
    if(buy == 0) {
    	format(string,sizeof(string), "#\t#\t#\n\
		Phuong tien:\t\t%s(%d)\n\
		Ma mau 1:\t\t%d\n\
		Ma mau 2:\t\t%d\n\
		Gia tien:\t\t%s\n\
		Chu dang ky:\t\t%s\n\
		Gioi tinh:\t\t%s\n\
		Quoc tich:\t\t%s\n\
		Ngay thang/Nam/sinh:\t\t%s\n\
		Thoi gian dang ky:\t\t%s\n\
		Bien so xe:\t\t%s\n\
		Toc do:\t\t%d\n\
		[EDITOR] > Xoa phuong tien\t#\t#",
		(DealerInfo[dlid][dl_model] == 0 ) ? "Chua khoi tao" : VehicleName[DealerInfo[dlid][dl_model] - 400] , DealerInfo[dlid][dl_model],
		DealerInfo[dlid][dl_color1],
		DealerInfo[dlid][dl_color2],
		number_format(DealerInfo[dlid][dl_price]),
		DealerInfo[dlid][dl_ownername],
		(DealerInfo[dlid][dl_ownergen] == 1)  ? "Nam" : "Nu" ,
		(DealerInfo[dlid][dl_ownernation] == 0)  ? "San Andreas" : "Tierra Robada" ,
		DealerInfo[dlid][dl_ownerbirthdate],
		DealerInfo[dlid][dl_ownerreg],
		DealerInfo[dlid][dl_pvlate],
		DealerInfo[dlid][dl_speed]);
	    Dialog_Show(playerid, EDIT_VEHICLE_DEALER, DIALOG_STYLE_TABLIST_HEADERS, "Edit - Vehicle Dealer", string, "Tuy chon", "Thoat");
    }
    else if(buy == 1) {
    	format(string,sizeof(string), "#\t#\t#\n\
		Phuong tien:\t\t%s(%d)\n\
		Ma mau 1:\t\t%d\n\
		Ma mau 2:\t\t%d\n\
		Gia tien:\t\t%s\n\
		Chu dang ky:\t\t%s\n\
		Gioi tinh:\t\t%s\n\
		Quoc tich:\t\t%s\n\
		Ngay thang/Nam/sinh:\t\t%s\n\
		Thoi gian dang ky:\t\t%s\n\
		Bien so xe:\t\t%s\n\
		Toc do:\t\t%d\n\
		Mua phuong tien\t>\t#",
		(DealerInfo[dlid][dl_model] == 0 ) ? "Chua khoi tao" : VehicleName[DealerInfo[dlid][dl_model] - 400] , DealerInfo[dlid][dl_model],
		DealerInfo[dlid][dl_color1],
		DealerInfo[dlid][dl_color2],
		number_format(DealerInfo[dlid][dl_price]),
		DealerInfo[dlid][dl_ownername],
		(DealerInfo[dlid][dl_ownergen] == 1)  ? "Nam" : "Nu" ,
		(DealerInfo[dlid][dl_ownernation] == 0)  ? "San Andreas" : "Tierra Robada" ,
		DealerInfo[dlid][dl_ownerbirthdate],
		DealerInfo[dlid][dl_ownerreg],
		DealerInfo[dlid][dl_pvlate],
		DealerInfo[dlid][dl_speed]);
	    Dialog_Show(playerid, CONFIRM_BUY_DL, DIALOG_STYLE_TABLIST_HEADERS, "Edit - Vehicle Dealer", string, "Tuy chon", "Thoat");
    }
	
	SetPVarInt(playerid,#DealerIDEdit,dlid);
    return 1;
 
}

Dialog:BUY_DEALER_SEL(playerid, response, listitem, inputtext[]) {
    if(response) {
    	if(DealerInfo[listitem][dl_model] == 0) return SendErrorMessage(playerid,"Phuong tien nay da duoc ban vui long doi cua hang nhap hang.");
    	SetPVarInt(playerid,#DealerIDEdit,listitem);
    	ShowEditDealer(playerid,listitem,1);
    }
    return 1;
}
Dialog:EDIT_DEALER_MODEL(playerid, response, listitem, inputtext[]) {
	new dlid = GetPVarInt(playerid,#DealerIDEdit);
    if(response) {
    	if(strval(inputtext) <= 400 && strval(inputtext) >= 611) return SendErrorMessage(playerid,"Phuong tien phai tu ID 400-611.");
    	DealerInfo[dlid][dl_model] = strval(inputtext);
    	ShowNotifyTextMain(playerid,"Da thay doi phuong tien ~g~thanh cong.");
    	ShowEditDealer(playerid,dlid);

        // save database 
        new strupdate[129];
	    format(strupdate, sizeof strupdate, "UPDATE `car_dealer` SET `dl_model`= '%d' WHERE `dl_id`=%d",DealerInfo[dlid][dl_model], dlid);
	    mysql_function_query(MainPipeline, strupdate, true, "OnSaveDLData", "i", dlid);
    }
    else {
    	ShowEditDealer(playerid,dlid);
    }
    return 1;
}
Dialog:EDIT_DEALER_COLOR1(playerid, response, listitem, inputtext[]) {
	new dlid = GetPVarInt(playerid,#DealerIDEdit);
    if(response) {
    	if(strval(inputtext) <= 0 && strval(inputtext) >= 255) return SendErrorMessage(playerid,"Ma mau phuong tien phai tu ID 0-255.");
    	DealerInfo[dlid][dl_color1] = strval(inputtext);
    	ShowNotifyTextMain(playerid,"Da thay doi ma mau #1 phuong tien ~g~thanh cong.");
    	ShowEditDealer(playerid,dlid);
        new strupdate[129];
	    format(strupdate, sizeof strupdate, "UPDATE `car_dealer` SET `dl_color1`= '%d' WHERE `dl_id`=%d",DealerInfo[dlid][dl_color1], dlid);
	    mysql_function_query(MainPipeline, strupdate, true, "OnSaveDLData", "i", dlid);
    }
    else {
    	ShowEditDealer(playerid,dlid);
    }
    return 1;
}
Dialog:EDIT_DEALER_COLOR2(playerid, response, listitem, inputtext[]) {
	new dlid = GetPVarInt(playerid,#DealerIDEdit);
    if(response) {
    	if(strval(inputtext) <= 0 && strval(inputtext) >= 255) return SendErrorMessage(playerid,"Ma mau phuong tien phai tu ID 0-255.");
    	DealerInfo[dlid][dl_color2] = strval(inputtext);
    	ShowNotifyTextMain(playerid,"Da thay doi ma mau #2 phuong tien ~g~thanh cong.");
    	ShowEditDealer(playerid,dlid);
        new strupdate[129];
	    format(strupdate, sizeof strupdate, "UPDATE `car_dealer` SET `dl_color2`= '%d' WHERE `dl_id`=%d",DealerInfo[dlid][dl_color2], dlid);
	    mysql_function_query(MainPipeline, strupdate, true, "OnSaveDLData", "i", dlid);
    }
    else {
    	ShowEditDealer(playerid,dlid);
    }
    return 1;
}
Dialog:EDIT_DEALER_PRICE(playerid, response, listitem, inputtext[]) {
	new dlid = GetPVarInt(playerid,#DealerIDEdit);
    if(response) {
    	if(strval(inputtext) <= 0 && strval(inputtext) >= 10000000) return SendErrorMessage(playerid,"Gia tien phai tu 0-10.000.000.");
    	DealerInfo[dlid][dl_price] = strval(inputtext);
    	ShowNotifyTextMain(playerid,"Da thay doi gia tien phuong tien ~g~thanh cong.");
    	ShowEditDealer(playerid,dlid);
        new strupdate[129];
	    format(strupdate, sizeof strupdate, "UPDATE `car_dealer` SET `dl_price`= '%d' WHERE `dl_id`=%d",DealerInfo[dlid][dl_price], dlid);
	    mysql_function_query(MainPipeline, strupdate, true, "OnSaveDLData", "i", dlid);
    }
    else {
    	ShowEditDealer(playerid,dlid);
    }
    return 1;
}
Dialog:EDIT_DEALER_REGNAME(playerid, response, listitem, inputtext[]) {
	new dlid = GetPVarInt(playerid,#DealerIDEdit);
    if(response) {
    	if(isnull(inputtext)) return Dialog_Show(playerid, EDIT_DEALER_REGNAME, DIALOG_STYLE_INPUT, "Vehicle Dealer Edit > Register Name", "Vui long nhap ten chu so huu phuong tien:", "Xac nhan", "Thoat");
    	if(strlen(inputtext) > 32 ) return Dialog_Show(playerid, EDIT_DEALER_REGNAME, DIALOG_STYLE_INPUT, "Vehicle Dealer Edit > Register Name", "Vui long nhap ten chu so huu phuong tien:", "Xac nhan", "Thoat");
    	strcpy(DealerInfo[dlid][dl_ownername] , inputtext, 128);
    	ShowNotifyTextMain(playerid,"Da thay doi ten chu so huu phuong tien ~g~thanh cong.");
    	ShowEditDealer(playerid,dlid);
        new strupdate[129];
	    format(strupdate, sizeof strupdate, "UPDATE `car_dealer` SET `dl_ownername`= '%s' WHERE `dl_id`=%d",DealerInfo[dlid][dl_ownername], dlid);
	    mysql_function_query(MainPipeline, strupdate, true, "OnSaveDLData", "i", dlid);
    }
    else {
    	ShowEditDealer(playerid,dlid);
    }
    return 1;
}
Dialog:EDIT_DEALER_GENDER(playerid, response, listitem, inputtext[]) {
	new dlid = GetPVarInt(playerid,#DealerIDEdit);
    if(response) {
    	if(listitem == 0) {
    		DealerInfo[dlid][dl_ownergen] = 1;
    		ShowNotifyTextMain(playerid,"Da thay doi gioi tinh chu so huu phuong tien ~g~thanh cong.");
    	}
    	else if(listitem == 1) {
    		DealerInfo[dlid][dl_ownergen] = 0;
    		ShowNotifyTextMain(playerid,"Da thay doi gioi tinh chu so huu phuong tien ~g~thanh cong.");
    	}
    	new strupdate[129];
	    format(strupdate, sizeof strupdate, "UPDATE `car_dealer` SET `dl_ownergen`= '%d' WHERE `dl_id`=%d",DealerInfo[dlid][dl_ownergen], dlid);
	    mysql_function_query(MainPipeline, strupdate, true, "OnSaveDLData", "i", dlid);
    	ShowEditDealer(playerid,dlid);
    }
    else {
    	ShowEditDealer(playerid,dlid);
    }
    return 1;
}

Dialog:EDIT_DEALER_NATION(playerid, response, listitem, inputtext[]) {
	new dlid = GetPVarInt(playerid,#DealerIDEdit);
    if(response) {
    	if(listitem == 0) {
    		DealerInfo[dlid][dl_ownernation] = 0;
    		ShowNotifyTextMain(playerid,"Da thay doi quoc tich chu so huu phuong tien ~g~thanh cong.");
    	}
    	else if(listitem == 1) {
    		DealerInfo[dlid][dl_ownernation] = 1;
    		ShowNotifyTextMain(playerid,"Da thay doi quoc tich chu so huu phuong tien ~g~thanh cong.");
    	}
    	new strupdate[129];
	    format(strupdate, sizeof strupdate, "UPDATE `car_dealer` SET `dl_ownernation`= '%d' WHERE `dl_id`=%d",DealerInfo[dlid][dl_ownernation], dlid);
	    mysql_function_query(MainPipeline, strupdate, true, "OnSaveDLData", "i", dlid);
    	ShowEditDealer(playerid,dlid);
    }
    else {
    	ShowEditDealer(playerid,dlid);
    }
    return 1;
}
Dialog:EDIT_DEALER_BDATE(playerid, response, listitem, inputtext[]) {
	new dlid = GetPVarInt(playerid,#DealerIDEdit);
    if(response) {
    	if(isnull(inputtext)) return Dialog_Show(playerid, EDIT_DEALER_REGNAME, DIALOG_STYLE_INPUT, "Vehicle Dealer Edit > Birth Date Owner", "Vui long nhap ten chu so huu phuong tien:", "Xac nhan", "Thoat");
    	if(strlen(inputtext) > 32 ) return Dialog_Show(playerid, EDIT_DEALER_REGNAME, DIALOG_STYLE_INPUT, "Vehicle Dealer Edit > Birth Date Owner", "Vui long nhap ten chu so huu phuong tien:", "Xac nhan", "Thoat");
    	strcpy(DealerInfo[dlid][dl_ownerbirthdate] , inputtext, 128);
    	ShowNotifyTextMain(playerid,"Da thay doi sinh nhat chu so huu phuong tien ~g~thanh cong.");
    	ShowEditDealer(playerid,dlid);
        new strupdate[129];
	    format(strupdate, sizeof strupdate, "UPDATE `car_dealer` SET `dl_ownerbirthdate`= '%s' WHERE `dl_id`=%d",DealerInfo[dlid][dl_ownerbirthdate], dlid);
	    mysql_function_query(MainPipeline, strupdate, true, "OnSaveDLData", "i", dlid);
    }
    else {
    	ShowEditDealer(playerid,dlid);
    }
    return 1;
}

Dialog:EDIT_DEALER_PVLATE(playerid, response, listitem, inputtext[]) {
	new dlid = GetPVarInt(playerid,#DealerIDEdit);
    if(response) {
    	if(isnull(inputtext)) return  Dialog_Show(playerid, EDIT_DEALER_PVLATE, DIALOG_STYLE_INPUT, "Vehicle Dealer Edit > Register Pvlate", "Vui long nhap bien so xe:", "Xac nhan", "Thoat");
    	if(strlen(inputtext) > 32 ) return  Dialog_Show(playerid, EDIT_DEALER_PVLATE, DIALOG_STYLE_INPUT, "Vehicle Dealer Edit > Register Pvlate", "Vui long nhap bien so xe:", "Xac nhan", "Thoat");
    	strcpy(DealerInfo[dlid][dl_pvlate] , inputtext, 128);
    	ShowNotifyTextMain(playerid,"Da thay doi bien so xe so huu phuong tien ~g~thanh cong.");
    	ShowEditDealer(playerid,dlid);
        new strupdate[129];
	    format(strupdate, sizeof strupdate, "UPDATE `car_dealer` SET `dl_pvlate`= '%s' WHERE `dl_id`=%d",DealerInfo[dlid][dl_pvlate], dlid);
	    mysql_function_query(MainPipeline, strupdate, true, "OnSaveDLData", "i", dlid);
    }
    else {
    	ShowEditDealer(playerid,dlid);
    }
    return 1;
}
Dialog:EDIT_DEALER_REGDATE(playerid, response, listitem, inputtext[]) {
	new dlid = GetPVarInt(playerid,#DealerIDEdit);
    if(response) {
    	if(isnull(inputtext)) return Dialog_Show(playerid, EDIT_DEALER_REGDATE, DIALOG_STYLE_INPUT, "Vehicle Dealer Edit > Register Date", "Vui long nhap thoi gian dang ky giay to cua phuong tien:", "Xac nhan", "Thoat");
    	if(strlen(inputtext) > 32 ) return  Dialog_Show(playerid, EDIT_DEALER_REGDATE, DIALOG_STYLE_INPUT, "Vehicle Dealer Edit > Register Date", "Vui long nhap thoi gian dang ky giay to cua phuong tien:", "Xac nhan", "Thoat");
    	strcpy(DealerInfo[dlid][dl_ownerreg] , inputtext, 128);
    	ShowNotifyTextMain(playerid,"Da thay doi thoi gian dang ky so huu phuong tien ~g~thanh cong.");
    	ShowEditDealer(playerid,dlid);
        new strupdate[129];
	    format(strupdate, sizeof strupdate, "UPDATE `car_dealer` SET `dl_ownerreg`= '%s' WHERE `dl_id`=%d",DealerInfo[dlid][dl_ownerreg], dlid);
	    mysql_function_query(MainPipeline, strupdate, true, "OnSaveDLData", "i", dlid);
    }
    else {
    	ShowEditDealer(playerid,dlid);
    }
    return 1;
}

Dialog:EDIT_DEALER_SPEED(playerid, response, listitem, inputtext[]) {
	new dlid = GetPVarInt(playerid,#DealerIDEdit);
    if(response) {
    	if(isnull(inputtext)) return Dialog_Show(playerid, EDIT_DEALER_REGDATE, DIALOG_STYLE_INPUT, "Vehicle Dealer Edit > Register Date", "Vui long nhap thoi gian dang ky giay to cua phuong tien:", "Xac nhan", "Thoat");
    	if(strlen(inputtext) > 32 ) return  Dialog_Show(playerid, EDIT_DEALER_REGDATE, DIALOG_STYLE_INPUT, "Vehicle Dealer Edit > Register Date", "Vui long nhap thoi gian dang ky giay to cua phuong tien:", "Xac nhan", "Thoat");
    	DealerInfo[dlid][dl_speed] = strval(inputtext);
    	ShowNotifyTextMain(playerid,"Da thay doi toc do gioi han phuong tien ~g~thanh cong.");
    	ShowEditDealer(playerid,dlid);
        new strupdate[129];
	    format(strupdate, sizeof strupdate, "UPDATE `car_dealer` SET `dl_speed`= '%d' WHERE `dl_id`=%d",DealerInfo[dlid][dl_speed], dlid);
	    mysql_function_query(MainPipeline, strupdate, true, "OnSaveDLData", "i", dlid);
    }
    else {
    	ShowEditDealer(playerid,dlid);
    }
    return 1;
}
Dialog:EDIT_VEHICLE_DEALER(playerid, response, listitem, inputtext[]) {
	new dlid = GetPVarInt(playerid,#DealerIDEdit);
    if(response) {
        if(listitem == 0) Dialog_Show(playerid, EDIT_DEALER_MODEL, DIALOG_STYLE_INPUT, "Vehicle Dealer Edit > Vehicle", "Vui long nhap ID Phuong tien ma ban muon thay doi:", "Xac nhan", "Thoat");
        if(listitem == 1) Dialog_Show(playerid, EDIT_DEALER_COLOR1, DIALOG_STYLE_INPUT, "Vehicle Dealer Edit > Color #1", "Vui long nhap ma mau #1 ma ban muon thay doi:", "Xac nhan", "Thoat");
        if(listitem == 2) Dialog_Show(playerid, EDIT_DEALER_COLOR2, DIALOG_STYLE_INPUT, "Vehicle Dealer Edit > Color #2", "Vui long nhap ma mau #2 ma ban muon thay doi:", "Xac nhan", "Thoat");
        if(listitem == 3) Dialog_Show(playerid, EDIT_DEALER_PRICE, DIALOG_STYLE_INPUT, "Vehicle Dealer Edit > Price", "Vui long nhap gia tien ma ban muon thay doi:", "Xac nhan", "Thoat");
        if(listitem == 4) Dialog_Show(playerid, EDIT_DEALER_REGNAME, DIALOG_STYLE_INPUT, "Vehicle Dealer Edit > Register Name", "Vui long nhap ten chu so huu phuong tien:", "Xac nhan", "Thoat");
        if(listitem == 5) Dialog_Show(playerid, EDIT_DEALER_GENDER, DIALOG_STYLE_LIST, "Vehicle Dealer Edit > Gender Owner Register", "Nam\nNu", "Xac nhan", "Thoat");
        if(listitem == 6) Dialog_Show(playerid, EDIT_DEALER_NATION, DIALOG_STYLE_LIST, "Vehicle Dealer Edit > Nation Owner Register", "San Andreas\nTierra Robada", "Xac nhan", "Thoat");
        if(listitem == 7) Dialog_Show(playerid, EDIT_DEALER_BDATE, DIALOG_STYLE_INPUT, "Vehicle Dealer Edit > BirthDate Owner Register", "Vui long nhap ngay sinh cua chu so huu:", "Xac nhan", "Thoat");
        if(listitem == 8) Dialog_Show(playerid, EDIT_DEALER_REGDATE, DIALOG_STYLE_INPUT, "Vehicle Dealer Edit > Register Date", "Vui long nhap thoi gian dang ky giay to cua phuong tien:", "Xac nhan", "Thoat");
        if(listitem == 9) Dialog_Show(playerid, EDIT_DEALER_PVLATE, DIALOG_STYLE_INPUT, "Vehicle Dealer Edit > Register Pvlate", "Vui long nhap bien so xe:", "Xac nhan", "Thoat");
        if(listitem == 10) Dialog_Show(playerid, EDIT_DEALER_SPEED, DIALOG_STYLE_INPUT, "Vehicle Dealer Edit > Max Speed", "Vui long nhap toc do xe gioi han:", "Xac nhan", "Thoat");
        if(listitem == 11) {
        	DeleteDealer(dlid);
        }
    }
    return 1;
}
Dialog:CONFIRM_BUY_DL(playerid, response, listitem, inputtext[]) {
	new dlid = GetPVarInt(playerid,#DealerIDEdit);
    if(response) {
        if(listitem == 0) ShowEditDealer(playerid,dlid,1);
        if(listitem == 1) ShowEditDealer(playerid,dlid,1);
        if(listitem == 2) ShowEditDealer(playerid,dlid,1);
        if(listitem == 3) ShowEditDealer(playerid,dlid,1);
        if(listitem == 4) ShowEditDealer(playerid,dlid,1);
        if(listitem == 5) ShowEditDealer(playerid,dlid,1);
        if(listitem == 6) ShowEditDealer(playerid,dlid,1);
        if(listitem == 7) ShowEditDealer(playerid,dlid,1);
        if(listitem == 8) ShowEditDealer(playerid,dlid,1);
        if(listitem == 9) ShowEditDealer(playerid,dlid,1);
        if(listitem == 10) ShowEditDealer(playerid,dlid,1);
        if(listitem == 11) {
            if(!vehicleCountCheck(playerid)) SendClientMessageEx(playerid, COLOR_GREY, "Ban khong con du slot trong trong kho xe [/my veh].");
            if(!vehicleSpawnCountCheck(playerid)) SendClientMessageEx(playerid, COLOR_GREY, "Ban da spawn ra qua nhieu phuong tien [/my veh de cat].");
            if(!(400 <= DealerInfo[dlid][dl_model] <= 611)) SendClientMessageEx(playerid, COLOR_GRAD2, "Phuong tien ban mua khong hop le...");
        	if(PlayerInfo[playerid][pCash] < DealerInfo[dlid][dl_price]) return SendErrorMessage(playerid," Ban khong co du tien de mua phuong tien");
            GivePlayerMoneyEx(playerid,-DealerInfo[dlid][dl_price]);
            new string[129];
            format(string, sizeof(string), "[CAR-DEALER] Ban da mua thanh cong phuong tien [%s] voi gia $%s", VehicleName[DealerInfo[dlid][dl_model] - 400],number_format(DealerInfo[dlid][dl_price]));
            SendClientMessageEx(playerid,COLOR_BASIC,string);

            new color1 = DealerInfo[dlid][dl_color1];
            new color2 = DealerInfo[dlid][dl_color2];

            new string_log[229];
            format(string_log, sizeof(string_log), "[%s] %s(%s) đã mua phương tiện %s tại car-dealer với giá %s", GetLogTime(),GetPlayerNameEx(playerid),GetDiscordUser(playerid),VehicleName[DealerInfo[dlid][dl_model] - 400],number_format(DealerInfo[dlid][dl_price]));         
            SendLogDiscordMSG(log_buyvehiclesold, string_log);


            DealerBuy(playerid, GetPlayerFreeVehicleId(playerid), DealerInfo[dlid][dl_model], 2460.3726,-1885.4943,13.2524,267.0414, color1, color2,  DealerInfo[dlid][dl_price],0,0,dlid);
            
        }
    }
    return 1;
}

stock SetDealerPlayerBuy(playerid,pvid,dlid) {
	PlayerVehicleInfo[playerid][pvid][pvRegister] = 1;
    PlayerVehicleInfo[playerid][pvid][pvOwnerNation] = DealerInfo[dlid][dl_ownernation]; // 
    PlayerVehicleInfo[playerid][pvid][pvOwnerGen] = DealerInfo[dlid][dl_ownergen]; // gioi tinh
    PlayerVehicleInfo[playerid][pvid][pvMaxSpeed] = DealerInfo[dlid][dl_speed]; // speed

    strcpy(PlayerVehicleInfo[playerid][pvid][pvOwnerName], DealerInfo[dlid][dl_ownername] , 32);
    strcpy(PlayerVehicleInfo[playerid][pvid][pvOwnerBirth], DealerInfo[dlid][dl_ownerbirthdate] , 32);
    strcpy(PlayerVehicleInfo[playerid][pvid][pvOwnerReg], DealerInfo[dlid][dl_ownerreg] , 32);
    strcpy(PlayerVehicleInfo[playerid][pvid][pvPlate], DealerInfo[dlid][dl_pvlate] , 32);

    SetVehicleNumberPlate(PlayerVehicleInfo[playerid][pvid][pvId], PlayerVehicleInfo[playerid][pvid][pvPlate]);
    DeleteDealer(dlid);
    return 1;
}
hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
	if(newkeys & KEY_YES) {
		if(IsPlayerInRangeOfPoint(playerid, 3,2446.0222,-1901.9486,13.5469)) {
			ShowBuyDealer(playerid);
		}
	}
	// if(disablefixspeed == false) {
	//     if(IsPlayerInAnyVehicle(playerid)) {
	//     	print("dayy");
	//         if (PRESSED(KEY_ACTION) || PRESSED(KEY_FIRE)) {
	//         	print("dayy 1");
    //             if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER )
    //             {
    //             	print("dayy 2");
    //                 TogglePlayerControllable(playerid, 0);
    //                 task_await task_ms(3000);
    //                 TogglePlayerControllable(playerid, 1);
    //             }  
	//         }
	//     } 
    // }
	return 1;
}
hook OnGameModeInit() {
	CreateDynamic3DTextLabel("<Car Dealer>\nBam Y de tuong tac", COLOR_BASIC, 2446.0222,-1901.9486,13.5469, 8.0);
	CreateActor(21,2446.0222,-1901.9486,13.5469,359.9724);
}


CMD:tocdo(playerid, params[])
{
    if(IsPlayerConnected(playerid))
    {
        new string[128];
        new speed;
        
        if(sscanf(params, "i", speed)) return SendClientMessage(playerid, COLOR_WHITE, "HIND: /tocdo [MPH Gioi han]");
        if(strlen(params) > 100) return SendClientMessage(playerid, COLOR_GREY, " Toc do gioi han la duoi 100.");
        if(speed < 0) return SendClientMessage(playerid, COLOR_GREY, " Toc do khong hop le.");
        Speedlimit[playerid] = speed;
        if(speed == 0) format(string, sizeof(string), " Ban da dieu chinh toc do binh thuong.", speed);
        else format(string, sizeof(string), " Ban da chinh toc do gioi han phuong tien la %d MPH.", speed);
        SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
    }
    return 1;
}



stock ModifyVehicleSpeed(vehicleid,mph) //Miles Per Hour
{
    new Float:Vx,Float:Vy,Float:Vz,Float:DV,Float:multiple;
    GetVehicleVelocity(vehicleid,Vx,Vy,Vz);
    DV = floatsqroot(Vx*Vx + Vy*Vy + Vz*Vz);
    if(DV > 0) //Directional velocity must be greater than 0 (display strobes if 0)
    {
        multiple = ((mph + DV * 100) / (DV * 100)); //Multiplying DV by 100 calculates speed in MPH
        return SetVehicleVelocity(vehicleid,Vx*multiple,Vy*multiple,Vz*multiple);
    }
    return 0;
}

hook OnPlayerUpdate(playerid) {
	if(disablefixspeed == false) {
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER )
        {
        	new Float:health_v;
            GetVehicleHealth(GetPlayerVehicleID(playerid), health_v);
        	if(SpeedlimitSet[playerid] == 1) {
                if( player_get_speed(playerid) > Speedlimit[playerid] + 6) {
                	TogglePlayerControllable(playerid,0);
                	// task_await task_ms(3000);
                	TogglePlayerControllable(playerid,1);
                	return 1;
                }
        		new a, b, c;
                GetPlayerKeys(playerid, a, b ,c);
                new vehicleid = GetPlayerVehicleID(playerid);
                //new vehicleid = GetPlayerVehicleID(playerid);
                new speed = floatround(GetVehicleSpeed(vehicleid));
                if(a == 8 && speed > Speedlimit[playerid])
                {
                    new newspeed = speed - Speedlimit[playerid];
                    ModifyVehicleSpeed(vehicleid, -newspeed);
                }

        	}
        	else if(health_v < 600) {
                if(  player_get_speed(playerid) > Speedlimit[playerid] + 6) {
                	TogglePlayerControllable(playerid,0);
                	// task_await task_ms(3000);
                	TogglePlayerControllable(playerid,1);
                	return 1;
                }
        	
        		Speedlimit[playerid] = 30;
        		new a, b, c;
                GetPlayerKeys(playerid, a, b ,c);
                new vehicleid = GetPlayerVehicleID(playerid);
                //new vehicleid = GetPlayerVehicleID(playerid);
                new speed = floatround(GetVehicleSpeed(vehicleid));
                if(a == 8 && speed > Speedlimit[playerid])
                {
                    new newspeed = speed - Speedlimit[playerid];
                    ModifyVehicleSpeed(vehicleid, -newspeed);
                }

        	}     
        }  
	}
    return 1;
}
hook OnPlayerExitVehicle(playerid, vehicleid) {
	SpeedlimitSet[playerid] = 0;
	Speedlimit[playerid] = 0;
}
hook OnPlayerConnect(playerid) {
	SpeedlimitSet[playerid] = 0;
	Speedlimit[playerid] = 0;
}
hook OnPlayerDisconnect(playerid, reason) {
	SpeedlimitSet[playerid] = 0;
	Speedlimit[playerid] = 0;
}