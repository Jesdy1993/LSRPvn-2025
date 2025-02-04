#include <YSI\y_hooks>
new Timer:MechanicTimer[MAX_PLAYERS];
new Timer:RepairPlayer[MAX_PLAYERS];
new Timer:PaintPlayer[MAX_PLAYERS];
CMD:ftypetest(playerid) {
    if(PlayerInfo[playerid][pAdmin] < 99999) return SendErrorMessage(playerid, " Ban khong phai Admin.");    
    PlayerInfo[playerid][pCompany] = 1;
    SendClientMessageEx(playerid,-1," Ban da tro thanh Mechanic.");
    return 1;
}
// CMD:suaxe(playerid,params[]) {
// 	new Float:Pos[3],
// 	foreach( i : Vehicle) {
//         Pos
// 	} 
// }

CMD:makemech(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] >= 99999)
	{
		new string[128], giveplayerid;
		if(sscanf(params, "u", giveplayerid )) return SendUsageMessage(playerid, " /makemech [player] ");
		if(IsPlayerConnected(giveplayerid))
		{
			PlayerInfo[giveplayerid][pCompany] = 1;
			PlayerInfo[giveplayerid][pRank] = 9;
			format(string, sizeof(string), "[MECHANIC] Ban da set Company Mechanic cho %s.",GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			format(string, sizeof(string), "[MECHANIC] Ban da duoc set Company Mechanic boi %s.", GetPlayerNameEx(playerid));
		}
	}
	else
	{
		SendErrorMessage(playerid, "Ban khong the su dung lenh nay");
	}
	return 1;
}
CMD:sonxe(playerid, params[])
{
	if(GetPVarInt(playerid,#IsRepair) == 1) return SendErrorMessage(playerid," Ban dang sua chua xe roi.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "Ban phai xuong xe moi co the sua chua.");
	if(PlayerInfo[playerid][pCompany] != 1 ) return SendErrorMessage(playerid," Ban khong phai nhan vien MECHANIC.");

	new string[128],repari_veh=-1;
	for(new i = 0 ; i < MAX_VEHICLES ; i++) {
		if(IsValidVehicle(i)) {
			if(IsPlayerInRangeOfVehicle(playerid, i, 2.5)) {
				repari_veh = i;
				break ;
			}
		}
	}
	if(repari_veh == -1) return SendErrorMessage(playerid, " Ban khong o gan bat ki phuong tien nao.");
	SetPVarInt(playerid, #RepairVehicle, repari_veh);
	format(string, sizeof(string), "Ban co xac nhan muon son lai phuong tien: %s [%d]\nVui long kiem tra ki de tranh Wrong-ID.", VehicleName[GetVehicleModel(repari_veh) - 400],repari_veh);
	Dialog_Show(playerid, REPAIR_CONFIRM_PAINT, DIALOG_STYLE_MSGBOX, "#Repair Vehicle", string, "Sua chua", "Thoat");
	
	return 1;
}
CMD:bomxang(playerid, params[])
{
	if(GetPVarInt(playerid,#IsRepair) == 1) return SendErrorMessage(playerid," Ban dang sua chua xe roi.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "Ban phai xuong xe moi co the do xang.");

	new string[128],repari_veh=-1;
	for(new i = 0 ; i < MAX_VEHICLES ; i++) {
		if(IsValidVehicle(i)) {
			if(IsPlayerInRangeOfVehicle(playerid, i, 2.5)) {
				repari_veh = i;
				break ;
			}
		}
	}
	if(repari_veh == -1) return SendErrorMessage(playerid, " Ban khong o gan bat ki phuong tien nao.");
	SetPVarInt(playerid, #RepairVehicle, repari_veh);
	format(string, sizeof(string), "Ban co xac nhan muon son lai phuong tien: %s [%d]\nVui long kiem tra ki de tranh Wrong-ID.", VehicleName[GetVehicleModel(repari_veh) - 400],repari_veh);
	Dialog_Show(playerid, REFILL_CONFIRM, DIALOG_STYLE_MSGBOX, "#REFILL Vehicle", string, "Boom xang", "Thoat");
	
	return 1;
}

CMD:suaxe(playerid, params[])
{
	if(GetPVarInt(playerid,#IsRepair) == 1) return SendErrorMessage(playerid," Ban dang sua chua xe roi.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "Ban phai xuong xe moi co the sua chua.");
	if(Inventory_@CountAmount(playerid,36) < 1) return SendUsageMessage(playerid, " Ban khong co dung cu sua chua");

	new string[128],repari_veh=-1;
	for(new i = 0 ; i < MAX_VEHICLES ; i++) {
		if(IsValidVehicle(i)) {
			if(IsPlayerInRangeOfVehicle(playerid, i, 2.5)) {
				repari_veh = i;
				break ;
			}
		}
	}
	if(repari_veh == -1) return SendErrorMessage(playerid, " Ban khong o gan bat ki phuong tien nao.");
	SetPVarInt(playerid, #RepairVehicle, repari_veh);
	format(string, sizeof(string), "Ban co xac nhan muon sua chua phuong tien: %s [%d]\nVui long kiem tra ki de tranh Wrong-ID.", VehicleName[GetVehicleModel(repari_veh) - 400],repari_veh);
	Dialog_Show(playerid, REPAIR_CONFIRM, DIALOG_STYLE_MSGBOX, "#Repair Vehicle", string, "Sua chua", "Thoat");
	return 1;
}
stock IsPointMechanic(playerid) {
	if(IsPlayerInRangeOfPoint(playerid, 5, 1835.9268,-1791.3195,13.5567) ||IsPlayerInRangeOfPoint(playerid, 5, 1844.3837,-1791.0076,13.5567) ) {
		return 1;
	}
	return 0;
	    
}
CMD:suachuaxe(playerid, params[])
{
//	if(PlayerInfo[playerid][pLevel] < 5) return SendErrorMessage(playerid," Khong du level 5.");
	if(GetPVarInt(playerid,#IsRepair) == 1) return SendErrorMessage(playerid," Ban dang sua chua xe roi.");
	if(PlayerInfo[playerid][pCompany] != 1) return SendErrorMessage(playerid," Ban khong phai la thanh vien cua cong ty Mechanic.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "Ban phai xuong xe moi co the sua chua.");
    if(IsPointMechanic(playerid)) {
	    new string[128],repari_veh=-1;
	    for(new i = 0 ; i < MAX_VEHICLES ; i++) {
	    	if(IsValidVehicle(i)) {
	    		if(IsPlayerInRangeOfVehicle(playerid, i, 2.5)) {
	    			repari_veh = i;
	    			break ;
	    		}
	    	}
	    }
	    if(repari_veh == -1) return SendErrorMessage(playerid, " Ban khong o gan bat ki phuong tien nao.");
	    SetPVarInt(playerid, #RepairVehicle, repari_veh);
	    format(string, sizeof(string), "Ban co xac nhan muon sua chua phuong tien: %s [%d]\nVui long kiem tra ki de tranh Wrong-ID.", VehicleName[GetVehicleModel(repari_veh) - 400],repari_veh);
	    Dialog_Show(playerid, REPAIR_CONFIRM, DIALOG_STYLE_MSGBOX, "#Repair Vehicle", string, "Sua chua", "Thoat");
    }
    else {
       	new string[128];

       	new giveplayerid, money;
       	if(sscanf(params, "ud", giveplayerid, money)) return SendUsageMessage(playerid, " /suaxe [nguoi choi] [gia tien]");
        if(Inventory_@CountAmount(playerid,36) < 1) return SendUsageMessage(playerid, " Ban khong co dung cu sua chua");

       	if(money < 1 || money > 10000) { SendClientMessageEx(playerid, COLOR_GREY, "   Gia khong thap hon $1 hoac cao hon $10.000!"); return 1; }
       	if(IsPlayerConnected(giveplayerid))
       	{
		    if(giveplayerid != INVALID_PLAYER_ID)
		    {
		        new closestcar = GetClosestCar(playerid);
       	  		if(IsPlayerInRangeOfVehicle(playerid, closestcar, 8.0))
       	  		{
		            if(ProxDetectorS(8.0, playerid, giveplayerid)&& IsPlayerInAnyVehicle(giveplayerid))
		            {
		            	if(giveplayerid == playerid) { SendClientMessageEx(playerid, COLOR_GREY, "   Khong the lam dieu do!"); return 1; }
       	                if(!IsABike(closestcar) && !IsAPlane(closestcar))
		            	{
		            		new engine,lights,alarm,doors,bonnet,boot,objective;
		            		GetVehicleParamsEx(closestcar,engine,lights,alarm,doors,bonnet,boot,objective);
		            		if(bonnet == VEHICLE_PARAMS_OFF || bonnet == VEHICLE_PARAMS_UNSET)
		            		{
		            			SendClientMessageEx(playerid, COLOR_GRAD1, "Hay mo cua xe ra truoc.");
		            			return 1;
		            		}
		            	}
		            	format(string, sizeof(string), "[MECHANIC] Ban da gui yeu cau sua chua den %s voi gia tien $%s, vui long cho xac nhan.",GetPlayerNameEx(giveplayerid),number_format(money));
		            	SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
		            	format(string, sizeof(string), "[MECHANIC] Nhan vien cty %s muon sua chua xe cho ban voi gia $%s, dong y de xac nhan dich vu.",GetPlayerNameEx(playerid),number_format(money));
		            	SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
		            	PlayerInfo[playerid][pMechTime] = gettime()+60;
		            	RepairOffer[giveplayerid] = playerid;
		            	RepairPrice[giveplayerid] = money;

		            	ShowPlayerMechanic(playerid,giveplayerid,0, money);
		            }
		            else
		            {
		            	SendClientMessageEx(playerid, COLOR_GREY, "   Nguoi choi do khong gan ban / khong o trong mot chiec xe.");
		            }
			   }
			   else
			   {
			        SendClientMessageEx(playerid, COLOR_GREY, "   Ban khong o gan bat ky chiec xe nao.");
			   }
		    }
       	}
       	else
       	{
		SendClientMessageEx(playerid, COLOR_GREY, "   Nguoi do dang offline.");
       	}
    }
	return 1;
}




CMD:mfind(playerid, params[])
{
	if ( PlayerInfo[playerid][pCompany] == 1)
	{
	    if(GetPVarType(playerid, "hFind"))
		{
	   		SendErrorMessage(playerid," Da dung dinh vi muc tieu.");
	        DeletePVar(playerid, "hFind");
	        DisablePlayerCheckpoint(playerid);
		}
		else
		{
			new	iTargetID;

			if(sscanf(params, "u", iTargetID)) {
				return SendUsageMessage(playerid, " /mfind [player]");
			}
			else if(iTargetID == playerid) {
				return SendErrorMessage(playerid,"Ban khong the su dung lenh nay cho ban.");
			}

			else if(!IsPlayerConnected(iTargetID)) {
				return SendErrorMessage(playerid,"Nguoi choi khong hop le.");
			}
			else if(GetPlayerInterior(iTargetID) != 0) {
				return SendErrorMessage(playerid,"Ban khong the su dung lenh nay trong khi dang o trong mot noi that.");
			}
			else if(PlayerInfo[iTargetID][pAdmin] >= 99999)
			{
				return SendErrorMessage(playerid,"Ban khong the tim kiem nhan vat nay");
			}
			else if (GetPVarInt(playerid, "_SwimmingActivity") >= 1)
			{
				return SendErrorMessage(playerid,"Ban khong the tim thay nguoi nay trong khi dang boi loi.");
			}
			if (GetPVarInt(playerid, "_SwimmingActivity") >= 1)
			{
			SendErrorMessage(playerid,"  Ban phai dung boi! (/stopswimming)");
			return 1;
			}
			new
				szZone[MAX_ZONE_NAME],
				szMessage[108];

			new Float:X, Float:Y, Float:Z;
			GetPlayerPos(iTargetID, X, Y, Z);
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid, X, Y, Z, 4.0);
			GetPlayer3DZone(iTargetID, szZone, sizeof(szZone));
			format(szMessage, sizeof(szMessage), "Theo doi tren %s, nhin thay o %s.", GetPlayerNameEx(iTargetID), szZone);
			SendClientMessageEx(playerid, COLOR_GRAD2, szMessage);
			SetPVarInt(playerid, "hFind", iTargetID);
		}
	}
	else SendErrorMessage(playerid, "Ban khong the su dung lenh nay");
	return 1;
}

CMD:mechduty(playerid, params[])
{
	new string[129];
	if( PlayerInfo[playerid][pCompany] != 1) return SendErrorMessage(playerid," Ban khong phai la thanh vien cua cong ty Mechanic.");
    if(GetPVarInt(playerid, "MechanicDuty") == 1)
	{
		format(string, sizeof string, "[MECHANIC-DUTY] %s da dung lam viec", GetPlayerNameEx(playerid));
		SendMechanicMSG(string);
        SendClientMessageEx(playerid, COLOR_BASIC, "[MECHANIC] Ban da dung lam viec Mechanic.");
		SetPVarInt(playerid, "MechanicDuty", 0);
        Mechanics -= 1;
    }
    else if(GetPVarInt(playerid, "MechanicDuty") == 0)
	{
		format(string, sizeof string, "[MECHANIC-DUTY] %s da bat dau lam viec", GetPlayerNameEx(playerid));
		SendMechanicMSG(string);
        SendClientMessageEx(playerid, COLOR_BASIC, "[MECHANIC] Ban da bat dau lam viec, hay chu y dien thoai cua cong ty.");
		SetPVarInt(playerid, "MechanicDuty", 1);
        ++Mechanics;
    }
    return 1;
}
CMD:mechanic(playerid,params[]) {
	if( PlayerInfo[playerid][pCompany] != 1) return SendErrorMessage(playerid," Ban khong phai la thanh vien cua cong ty Mechanic.");
	if(PlayerInfo[playerid][pRank] < 6) return SendErrorMessage(playerid," Ban khong phai la giam doc cong ty.");
	mysql_function_query(MainPipeline, "SELECT * FROM `mechanic_bill`", false, "LoadMechanicBill", "i", playerid);
	return 1;
}
CMD:viethoadon(playerid, params[])
{
	if(PlayerInfo[playerid][pCompany] != 0)
	{
		new string[128], giveplayerid;
		if(sscanf(params, "d", giveplayerid)) return SendUsageMessage(playerid, " /sathai [ten nguoi choi]");

		if(!IsPlayerConnected(giveplayerid)) return SendErrorMessage(playerid, " Nguoi choi do khong ket noi.");
		if(playerid == giveplayerid) return SendErrorMessage(playerid, " Ban khong the gui cho chinh minh");
		new Float:Pos[3];
		GetPlayerPos(playerid, Pos[0],Pos[1],Pos[2]);
		if(!IsPlayerInRangeOfPoint(playerid, 3, Pos[0],Pos[1],Pos[2])) return SendErrorMessage(playerid, " Ban khong o gan nguoi choi do.");
		SetPVarInt(giveplayerid,#BillOfer,playerid);
		SetPVarInt(playerid,#SentBillOfer,giveplayerid);

		Dialog_Show(playerid, DIALOG_BILL_PRICE, DIALOG_STYLE_INPUT , "Mechanic #>","Vui long nhap so tien cho hoa don.","> Tiep tuc","Huy bo");
	}
	else 
	{
		SendErrorMessage(playerid, " Ban khong phai Company Mechanic.");
	}
	return 1;
}

Dialog:DIALOG_BILL_PRICE(playerid, response, listitem, inputtext[])
{
	if(response) {
		new giveplayerid = GetPVarInt(playerid,#SentBillOfer);
		if(strval(inputtext) < 0 || strval(inputtext) > 10000) return SendErrorMessage(playerid, " Hoa don phai tu $0-$10.000.");
		if(!IsPlayerConnected(giveplayerid)) return 1;
		SetPVarInt(giveplayerid,#BillPrice,strval(inputtext));
		Dialog_Show(playerid, DIALOG_BILL_NOTE, DIALOG_STYLE_INPUT , "Mechanic #>","Vui long nhap chi tiet ghi chi cho bill (vd: Bill sua xe , bill thay linh kien v.v).","> Tiep tuc","Huy bo");
	}
	return 1;
}
Dialog:DIALOG_BILL_NOTE(playerid, response, listitem, inputtext[])
{
	if(response) {
		new giveplayerid = GetPVarInt(playerid,#SentBillOfer);
		if(isnull(inputtext)) return Dialog_Show(playerid, DIALOG_BILL_NOTE, DIALOG_STYLE_INPUT , "Mechanic #>","Vui long nhap chi tiet ghi chi cho bill (vd: Bill sua xe , bill thay linh kien v.v).","> Tiep tuc","Huy bo");
		if(!IsPlayerConnected(giveplayerid)) return 1;
		SetPVarString(giveplayerid,#BillNote,inputtext);
		new str[129];
		format(str, sizeof str, "Da gui hoa don nguoi choi %s, vui long doi ho xac nhan.", GetPlayerNameEx(giveplayerid));
		SendClientMessageEx(playerid,COLOR_LIGHTGREEN,str);
		ShowCompanyBill(giveplayerid);
	}
	return 1;
}
Dialog:DIALOG_CFR_BILL(playerid, response, listitem, inputtext[])
{
	if(response) {
		if(listitem != 3) {
			ShowCompanyBill(playerid);

		}
		else if(listitem == 3) {
			if(PlayerInfo[playerid][pCash] < GetPVarInt(playerid,#BillPrice)) return SendErrorMessage(playerid, " Ban khong du tien chi tra hoa don.");
			new query[1229];
			new giveplayerid = GetPVarInt(playerid,#BillOfer);
			new str[129];
			PlayerInfo[playerid][pCash] -= GetPVarInt(playerid,#BillPrice);
			Company@AddBudget(PlayerInfo[giveplayerid][pCompany],GetPVarInt(playerid,#BillPrice));
			printf("bill price %d",GetPVarInt(playerid,#BillPrice));

			format(str,sizeof(str), "[COMPANY-BILL] %s da chap nhan hoa don $%s cua ban, so tien duoc chuyen vao Company.",GetPlayerNameEx(playerid),number_format(GetPVarInt(playerid,#BillPrice)));
			SendClientMessageEx(giveplayerid,COLOR_LIGHTGREEN,str);
			format(str,sizeof(str), "[COMPANY-BILL] Ban da chap nhan hoa don $%s cua %s.",GetPlayerNameEx(giveplayerid),number_format(GetPVarInt(playerid,#BillPrice)) ) ;
			SendClientMessageEx(playerid,COLOR_LIGHTGREEN,str);
            format(query, sizeof(query), "INSERT INTO `mechanic_bill` (`nhanvien`, `trinhdo`, `khachhang`, `giatien`)\
             VALUES ('%s','%d','%s','%s')",GetPlayerNameEx(giveplayerid),PlayerInfo[giveplayerid][pRank],GetPlayerNameEx(playerid),number_format( GetPVarInt(playerid,#BillPrice)));
            mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
		}
	}
	return 1;
}
stock ShowCompanyBill(playerid) {
	new string[2220],note[129],offerid;
	offerid = GetPVarInt(playerid,#BillOfer);
	GetPVarString(playerid, #BillNote, note, sizeof(note));
	format(string, sizeof(string), "#\t#\t#\nNguoi viet hoa don: %s(%d)\n\
		                            So tien can chi tra: $%s\n\
		                            Ghi chu: %s\n\
		                            XAC NHAN THANH TOAN\t<\t<", GetPlayerNameEx(offerid),offerid,
		                            number_format(GetPVarInt(playerid,#BillPrice)),
		                            note);
	Dialog_Show(playerid, DIALOG_CFR_BILL, DIALOG_STYLE_TABLIST_HEADERS, "Company @ Bill", string, "Xac nhan", "Huy");
	return 1;
}

stock SendMechanicMSG(params[]) {
    foreach( new i : Player) {
    	if( PlayerInfo[i][pCompany] == 1 && GetPVarInt(i, "MechanicDuty") == 1) {
    		SendClientMessageEx(i,0xf29655FF,params);
    	}
    }
}
forward LoadMechanicBill(playerid);
public LoadMechanicBill(playerid)
{
    new rows = cache_num_rows(), total;
	if (rows == 0) return print("[Mechanic] khong co du lieu duoc tim thay.");
    new nhanvien[32],khachhang[32],phuongtien[32],giatien;
    new string[3339];
    string = "#Nhan vien\tKhach hang\tGia tien\n";
	for(new i = 0; i < rows; i++)
	{
		cache_get_field_content(i,  "nhanvien", nhanvien, MainPipeline, 128);
		cache_get_field_content(i,  "khachhang", khachhang, MainPipeline, 128);
        cache_get_field_content(i,  "phuongtien", phuongtien, MainPipeline, 32);

//        trinhdo = cache_get_field_content_int(i, "trinhdo", MainPipeline);
        giatien = cache_get_field_content_int(i, "giatien", MainPipeline);
   //     bill_uid = cache_get_field_content_int(i, "bill_id", MainPipeline);
        format(string, sizeof(string), "{b4b4b4}%s%s\t%s\t{1fb832}%s\n", string,nhanvien,khachhang,number_format(giatien));
        total++;
	}
	Dialog_Show(playerid, DIALOG_BILL_MECH, DIALOG_STYLE_TABLIST_HEADERS, "Mechanic # Bill List", string, "Xac nhan", "Thoat");
	printf("[Ticket Dynamic] Loaded.");
	return 1;
}

stock ShowPlayerMechanic(playerid,giveplayerid,type,amount) {
	switch(type) {
		case 0: {
			new string[259];
			format(string ,sizeof(string), "{b4b4b4}#\t#\t#\n\
				Nhan vien sua chua:\t\t{e95a5a}%s{b4b4b4}\n\
				Trinh do:\t\t%d\n\
				Khach hang:\t\t{e95a5a}%s{b4b4b4}\n\
				Phuong tien can sua chua:\t\t{b4b4b4}%s{b4b4b4}\n\
				Phi sua chua:\t\t{47c150}$%s{b4b4b4}\n\
				>\tXAC NHAN SUA CHUA\t<",
				GetPlayerNameEx(playerid),
				PlayerInfo[playerid][pRank],
				GetPlayerNameEx(giveplayerid),
				VehicleName[GetVehicleModel(GetPlayerVehicleID(giveplayerid)) - 400],
				number_format(amount));
			Dialog_Show(giveplayerid, DIALOG_MECHANIC0, DIALOG_STYLE_TABLIST_HEADERS, "Mechanic # Bill Request", string, "Xac nhan", "Tu choi");
		}
	}
}
Dialog:REPAIR_CONFIRM_PAINT(playerid, response, listitem, inputtext[]) {
	if(response) {
		new vehicleid = GetPVarInt(playerid,#RepairVehicle);
		if(!IsPlayerInRangeOfVehicle(playerid,vehicleid,3)) return SendErrorMessage(playerid, " Phuong tien khong hop le.");
	    Dialog_Show(playerid, DIALOG_PAINTCOL1, DIALOG_STYLE_INPUT, "#Paint car", "Vui long chon #color 1", "Xac nhan", "Thoat");
		
	}
	return 1;
}
Dialog:DIALOG_PAINTCOL1(playerid, response, listitem, inputtext[]) {
	if(response) {
		if(isnull(inputtext)) return  Dialog_Show(playerid, DIALOG_PAINTCOL1, DIALOG_STYLE_INPUT, "#Paint car", "Vui long chon #color 1", "Xac nhan", "Thoat");
		if(strval(inputtext) < 0 || strval(inputtext) > 255) return Dialog_Show(playerid, DIALOG_PAINTCOL1, DIALOG_STYLE_INPUT, "#Paint car", "Vui long chon #color 1", "Xac nhan", "Thoat");
        SetPVarInt(playerid, #PaintCol1, strval(inputtext));	
        Dialog_Show(playerid, DIALOG_PAINTCOL2, DIALOG_STYLE_INPUT, "#Paint car", "Vui long chon #color 2", "Xac nhan", "Thoat");	
	}
	return 1;
}
Dialog:DIALOG_PAINTCOL2(playerid, response, listitem, inputtext[]) {
	if(response) {
		if(isnull(inputtext)) return  Dialog_Show(playerid, DIALOG_PAINTCOL2, DIALOG_STYLE_INPUT, "#Paint car", "Vui long chon #color 1", "Xac nhan", "Thoat");
		if(strval(inputtext) < 0 || strval(inputtext) > 255) return Dialog_Show(playerid, DIALOG_PAINTCOL2, DIALOG_STYLE_INPUT, "#Paint car", "Vui long chon #color 1", "Xac nhan", "Thoat");
        SetPVarInt(playerid, #PaintCol2, strval(inputtext));	
        Dialog_Show(playerid, DIALOG_PAINTCOL3, DIALOG_STYLE_MSGBOX, "#Paint car", "Bam 'Xac nhan' de bat dau son xe", "Xac nhan", "Thoat");	
	}
	return 1;
}
Dialog:DIALOG_PAINTCOL3(playerid, response, listitem, inputtext[]) {
	if(response) {
        if(GetPVarInt(playerid,#IsRepair) == 1 ) return SendErrorMessage(playerid, " Ban dang sua chua phuong tien roi");
        if(!IsPlayerInRangeOfVehicle(playerid,GetPVarInt(playerid,#RepairVehicle),5)) return SendErrorMessage(playerid, " Ban khong o gan phuong tien");
        PaintPlayer[playerid] = repeat Mechanic_Paint[1000](playerid);
        GivePlayerValidWeapon(playerid, 41, 1000);

	}

	return 1;
}
Dialog:REPAIR_CONFIRM(playerid, response, listitem, inputtext[]) {
	if(response) {
		if(IsPointMechanic(playerid) && PlayerInfo[playerid][pCompany] == 1) {
			PlayAnimEx(playerid, "BD_FIRE", "wash_up", 4.0, 1, 0, 0, 0, 0, 1);
		    RepairPlayer[playerid] = repeat PlayerRepair[1000](playerid);
		    ShowNotifyTextMain(playerid,"~g~Dang bat dau sua chua...");
		}
		else {
			new vehicleid = GetPVarInt(playerid,#RepairVehicle);
		    if(!IsPlayerInRangeOfVehicle(playerid,vehicleid,3)) return SendErrorMessage(playerid, " Phuong tien khong hop le.");
		    if(Inventory_@CountAmount(playerid,36) < 1) return SendUsageMessage(playerid, " Ban khong co dung cu sua chua");
		    PlayAnimEx(playerid, "BD_FIRE", "wash_up", 4.0, 1, 0, 0, 0, 0, 1);
		    RepairPlayer[playerid] = repeat PlayerRepair[1000](playerid);
		    ShowNotifyTextMain(playerid,"~g~Dang bat dau sua chua...");
		}
		
	}
	return 1;
}
Dialog:REFILL_CONFIRM(playerid, response, listitem, inputtext[]) {
	if(response) {
		new vehicleid = GetPVarInt(playerid,#RepairVehicle);
		if(Inventory_@CountAmount(playerid,38) < 1) return SendErrorMessage(playerid, " Ban khong co binh xang nao");
		if(!IsPlayerInRangeOfVehicle(playerid,vehicleid,3)) return SendErrorMessage(playerid, " Phuong tien khong hop le.");
		PlayAnimEx(playerid, "BD_FIRE", "wash_up", 4.0, 1, 0, 0, 0, 0, 1);
		RepairPlayer[playerid] = repeat PlayerRefill[1000](playerid);
		ShowNotifyTextMain(playerid,"~g~Dang bat dau bom xang...");
		
	}
	return 1;
}
Dialog:DIALOG_BILL_MECH(playerid, response, listitem, inputtext[]) {
}
Dialog:DIALOG_MECHANIC0(playerid, response, listitem, inputtext[]) {
	if(response) {
		if(listitem == 5) {
			if(RepairOffer[playerid] != INVALID_PLAYER_ID) {
                StartMechanic(playerid);
            }
            else {
                SendErrorMessage(playerid,"   Loi de nghi khong hop le.");
                return 1;
            }
		}
		else {
			ShowPlayerMechanic(RepairOffer[playerid],playerid,0,RepairPrice[playerid]);
		}
        
	}
	return 1;
}
stock StartMechanic(playerid) {
    new szMessage[129];
	if(GetPlayerCash(playerid) > RepairPrice[playerid]) {
        if(IsPlayerInAnyVehicle(playerid)) {
            if(IsPlayerConnected(RepairOffer[playerid])) {             
                format(szMessage, sizeof(szMessage), "* %s dang sua chua phuong tien cho %s.", GetPlayerNameEx(RepairOffer[playerid]), GetPlayerNameEx(playerid));
                ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
                format(szMessage, sizeof(szMessage), "Ban da bat dau sua chua xe cho %s voi gia $%s.",GetPlayerNameEx(RepairOffer[playerid]),number_format(RepairPrice[playerid]));
                SendClientMessageEx(playerid, COLOR_LIGHTGREEN, szMessage);

                
                format(szMessage, sizeof(szMessage), "* Ban dang bat dau sua chua phuong tien cho %s, ban se nhan duoc $%s neu hoan thanh cong viec.",GetPlayerNameEx(playerid),number_format(RepairPrice[playerid]));
                SendClientMessageEx(RepairOffer[playerid], COLOR_LIGHTGREEN, szMessage);
                
                new repairer = RepairOffer[playerid];
                SetPVarInt(repairer,#IsRepair,1);
                SetPVarInt(repairer, #MechanicTask, 1);
                

                MechanicTimer[repairer] = repeat Mechanic_FixCar[1000](playerid,repairer);
                TogglePlayerControllable(repairer, 0);           
                return 1;
            }
            return 1;
        }
        return 1;
    }
    else SendErrorMessage(playerid, " Ban khong co du tien de chi tra.");
    return 0;
}

timer Mechanic_Paint[1000](playerid)
{
	new Float:Pos[3];
	new vehicleid = GetPVarInt(playerid,#RepairVehicle);
	new color1 = GetPVarInt(playerid,#PaintCol1);
	new color2 = GetPVarInt(playerid,#PaintCol2);
	GetVehiclePos(vehicleid, Pos[0],Pos[1],Pos[2]);
	new count = GetPVarInt(playerid,#PaintCount) + 1;
	SetPVarInt(playerid,#PaintCount,count);
	ShowNotifyTextMain(playerid, " Dang xit son phuong tien...");
	if(GetPVarInt(playerid,#PaintCount) > 10) {
        ShowNotifyTextMain(playerid, " Da son phuong tien thanh cong...");
        DeletePVar(playerid,#IsRepair);
        DeletePVar(playerid,#PaintCount);
        
        ChangeVehicleColor(vehicleid, color1, color2);
        foreach(new i: Player)
		{
	   		new v = GetPlayerVehicle(i, vehicleid);
            if(v != -1) {
                PlayerVehicleInfo[vehicleid][v][pvColor1] = color1 ;
                PlayerVehicleInfo[vehicleid][v][pvColor2] = color2 ;
                g_mysql_SaveVehicle(playerid, v);	
            }
        }
        stop PaintPlayer[playerid];
        RemovePlayerWeapon(playerid, 41);
	}
	return 1;

}
timer PlayerRefill[1000](playerid)
{
	SetPVarInt(playerid, #MechanicTask, GetPVarInt(playerid, #MechanicTask) + 5);
	if(!IsPlayerConnected(playerid)) {
		stop RepairPlayer[playerid];
		DeletePVar(playerid,#IsRepair);
	}
    PlayAnimEx(playerid, "BD_FIRE", "wash_up", 4.0, 1, 0, 0, 0, 0, 1);
	ShowProgress(playerid,"Refiling...",GetPVarInt(playerid, #MechanicTask),3);
	if( GetPVarInt(playerid, #MechanicTask)  >= 100) {
        new vehicleid = GetPVarInt(playerid,#RepairVehicle);
        if(Inventory_@CountAmount(playerid,38) < 1) {
            SendErrorMessage(playerid, " Qua trinh sua chua da that bai - bug item.");
            stop RepairPlayer[playerid];
            DeletePVar(playerid,#IsRepair);
            return 1;
        } 
        if(Inventory_@CountAmount(playerid,38) < 1) {
        	SendErrorMessage(playerid, " Qua trinh sua chua da that bai - bug vehicle.");
        	stop RepairPlayer[playerid];
        	DeletePVar(playerid,#IsRepair);
        }
        if(!IsValidVehicle(vehicleid)) {
        	SendErrorMessage(playerid, " Qua trinh sua chua da that bai - bug vehicle.");
        	stop RepairPlayer[playerid];
        	DeletePVar(playerid,#IsRepair);
            return 1;
        }
        SendClientMessageEx(playerid,COLOR_BASIC, "[VEHICLE] Da bom xang cho phuong tien thanh cong.");
        VehicleFuel[vehicleid] += 50;
        if(VehicleFuel[vehicleid] > 100) VehicleFuel[vehicleid] = 100;

        stop RepairPlayer[playerid];

        if(IsPointMechanic(playerid) && PlayerInfo[playerid][pCompany] == 1) {
        	DeletePVar(playerid,#RepairVehicle);
        	DeletePVar(playerid,#IsRepair);
		    DeletePVar(playerid, #MechanicTask);
		    ClearAnimations(playerid);
		    HideProgress(RepairOffer[playerid]);
        }
        else {
        	Inventory_@FineItem(playerid,36,1);
            DeletePVar(playerid,#RepairVehicle);
            DeletePVar(playerid,#IsRepair);
		    DeletePVar(playerid, #MechanicTask);
		    ClearAnimations(playerid);
		    HideProgress(RepairOffer[playerid]);
        }

        

	}
	return 1;
}

timer PlayerRepair[1000](playerid)
{
	SetPVarInt(playerid, #MechanicTask, GetPVarInt(playerid, #MechanicTask) + 5);
	if(!IsPlayerConnected(playerid)) {
		stop RepairPlayer[playerid];
		DeletePVar(playerid,#IsRepair);
	}
    PlayAnimEx(playerid, "BD_FIRE", "wash_up", 4.0, 1, 0, 0, 0, 0, 1);
	ShowProgress(playerid,"Dang sua chua...",GetPVarInt(playerid, #MechanicTask),3);
	if( GetPVarInt(playerid, #MechanicTask)  >= 100) {
        new vehicleid = GetPVarInt(playerid,#RepairVehicle);
        if(Inventory_@CountAmount(playerid,36) < 1 && !IsPointMechanic(playerid) && PlayerInfo[playerid][pCompany] == 1) {
            SendErrorMessage(playerid, " Qua trinh sua chua da that bai - bug item.");
            stop RepairPlayer[playerid];
            DeletePVar(playerid,#IsRepair);
            return 1;
        } 
        if(Inventory_@CountAmount(playerid,36) < 1) {
        	SendErrorMessage(playerid, " Qua trinh sua chua da that bai - bug vehicle.");
        	stop RepairPlayer[playerid];
        	DeletePVar(playerid,#IsRepair);
        }
        if(!IsValidVehicle(vehicleid)) {
        	SendErrorMessage(playerid, " Qua trinh sua chua da that bai - bug vehicle.");
        	stop RepairPlayer[playerid];
        	DeletePVar(playerid,#IsRepair);
            return 1;
        }
        SendClientMessageEx(playerid,COLOR_BASIC, "[VEHICLE] Da sua chua thanh cong phuong tien.");
        RepairVehicle(vehicleid);
        Vehicle_Armor(vehicleid);

        stop RepairPlayer[playerid];

        if(IsPointMechanic(playerid) && PlayerInfo[playerid][pCompany] == 1) {
        	DeletePVar(playerid,#RepairVehicle);
        	DeletePVar(playerid,#IsRepair);
		    DeletePVar(playerid, #MechanicTask);
		    ClearAnimations(playerid);
		    HideProgress(RepairOffer[playerid]);
        }
        else {
        	Inventory_@FineItem(playerid,36,1);
            DeletePVar(playerid,#RepairVehicle);
            DeletePVar(playerid,#IsRepair);
		    DeletePVar(playerid, #MechanicTask);
		    ClearAnimations(playerid);
		    HideProgress(RepairOffer[playerid]);
        }

        

	}
	return 1;
}
timer Mechanic_FixCar[1000](playerid,repairer)
{

    SetPVarInt(repairer, #MechanicTask, GetPVarInt(repairer, #MechanicTask) + 5);
    PlayAnimEx(repairer, "BD_FIRE", "wash_up", 4.0, 1, 0, 0, 0, 0, 1);
    ShowNotifyTextMain(repairer,"~r~Dang sua chua...",20);
    ShowProgress(repairer,"Dang sua chua",GetPVarInt(repairer, #MechanicTask),3);
    printf("%d", GetPVarInt(repairer, #MechanicTask));

    if(!IsPlayerConnected(playerid) || !IsPlayerConnected(playerid)) {
        stop MechanicTimer[playerid];
        RepairOffer[playerid] = INVALID_PLAYER_ID;
        RepairPrice[playerid] = 0;
        DeletePVar(repairer,#IsRepair);

        SendErrorMessage(playerid, " Qua trinh sua chua da that bai.");

        TogglePlayerControllable(repairer, 1);
        stop MechanicTimer[repairer];
        TogglePlayerControllable(playerid, 1);
        return 1;
    }
    if(GetPVarInt(repairer,#MechanicTask) >= 100) {


        TogglePlayerControllable(repairer, 1);
        ClearAnimations(repairer);
        if(PlayerInfo[playerid][pCash] <  RepairPrice[playerid]) {
        	SendUsageMessage(playerid, " Qua trinh sua chua da that bai.");
        	stop RepairPlayer[playerid];
        	DeletePVar(repairer,#IsRepair);
            return 1;
        }
        if(Inventory_@CountAmount(repairer,36) < 1) {
            SendUsageMessage(repairer, " Qua trinh sua chua da that bai.");
            stop RepairPlayer[playerid];
            DeletePVar(repairer,#IsRepair);
            return 1;
        } 
        new szMessage[129];

        format(szMessage, sizeof(szMessage), "[MECHANIC] Cong viec hoan tat, so tien $%s da duoc chuyen vao tai khoan @Mechanic.co.",number_format(RepairPrice[playerid]));
        SendClientMessageEx(repairer, COLOR_LIGHTGREEN, szMessage);
    
        format(szMessage, sizeof(szMessage), "[MECHANIC] Ban da chi tra cho %s so tien $%s cho @Mechanic.co.",GetPlayerNameEx(RepairOffer[playerid]),number_format(RepairPrice[playerid]));
        SendClientMessageEx(playerid, COLOR_LIGHTGREEN, szMessage);

        format(szMessage, sizeof(szMessage), "[%s] %s(%s) sữa chữa phương tiện cho %s(%s) với giá $%s.", GetLogTime(),GetPlayerNameEx(RepairOffer[playerid]),GetDiscordUser(RepairOffer[playerid]),GetPlayerNameEx(playerid),GetDiscordUser(playerid),number_format(RepairPrice[playerid]));         
        SendLogDiscordMSG(logs_mech, szMessage);


	    
	    new query[1229];	
        format(query, sizeof(query), "INSERT INTO `mechanic_bill` (`nhanvien`, `trinhdo`, `khachhang`, `phuongtien`, `giatien`)\
         VALUES ('%s','%d','%s','%s','%d')",GetPlayerNameEx(repairer),PlayerInfo[repairer][pRank],GetPlayerNameEx(playerid),VehicleName[GetVehicleModel(GetPlayerVehicleID(playerid)) - 400],RepairPrice[playerid]);
        mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);

        Company@AddBudget(PlayerInfo[repairer][pCompany],RepairPrice[playerid]);
        GivePlayerMoneyEx(playerid, -RepairPrice[playerid]);
        HideProgress(RepairOffer[playerid]);
        
        RepairOffer[playerid] = INVALID_PLAYER_ID;
        DeletePVar(repairer,#MechanicTask);
        DeletePVar(repairer,#IsRepair);
        TogglePlayerControllable(playerid, 1);
        RepairPrice[playerid] = 0;
        RepairCar[playerid] = GetPlayerVehicleID(playerid);
        RepairVehicle(RepairCar[playerid]);
        Vehicle_Armor(RepairCar[playerid]);
        Inventory_@FineItem(repairer,36,1);
        stop MechanicTimer[repairer];
    }
  
    return 1;
}
stock SendMechanicChat(color, string[])
{
	foreach(new i: Player)
	{
		if(PlayerInfo[i][pCompany] == 1) {
			SendClientMessageEx(i, color, string);
		}	
	}
}              
hook OnPlayerConnect(playerid) {
    stop PaintPlayer[playerid];
	DeletePVar(playerid,#IsRepair);
	stop RepairPlayer[playerid];
    DeletePVar(playerid,#RepairVehicle);
    DeletePVar(playerid, #MechanicTask);
    stop MechanicTimer[playerid];
    HideProgress(playerid);
    RemoveBuildingForPlayer(playerid, 955, 1928.729, -1772.449, 12.945, 0.250);
    RemoveBuildingForPlayer(playerid, 955, 2325.979, -1645.130, 14.210, 0.250);
    RemoveBuildingForPlayer(playerid, 956, 2480.860, -1959.270, 12.960, 0.250);
    RemoveBuildingForPlayer(playerid, 955, 2060.120, -1897.640, 12.929, 0.250);
    RemoveBuildingForPlayer(playerid, 955, 2352.179, -1357.160, 23.773, 0.250);
    RemoveBuildingForPlayer(playerid, 956, 2139.520, -1161.479, 23.359, 0.250);
    RemoveBuildingForPlayer(playerid, 956, 1634.109, -2237.530, 12.890, 0.250);
    RemoveBuildingForPlayer(playerid, 956, 2153.229, -1016.150, 62.234, 0.250);
    RemoveBuildingForPlayer(playerid, 956, -1350.119, 493.859, 10.585, 0.250);
    RemoveBuildingForPlayer(playerid, 955, -1350.119, 492.289, 10.585, 0.250);
    RemoveBuildingForPlayer(playerid, 956, -2229.189, 286.414, 34.703, 0.250);
    RemoveBuildingForPlayer(playerid, 956, 1659.459, 1722.859, 10.218, 0.250);
    RemoveBuildingForPlayer(playerid, 956, 2647.699, 1129.660, 10.218, 0.250);
    RemoveBuildingForPlayer(playerid, 956, 2845.729, 1295.050, 10.789, 0.250);
    RemoveBuildingForPlayer(playerid, 956, 1398.839, 2222.610, 10.421, 0.250);
    RemoveBuildingForPlayer(playerid, 956, -1455.119, 2591.659, 55.234, 0.250);
    RemoveBuildingForPlayer(playerid, 956, -76.031, 1227.989, 19.125, 0.250);
    RemoveBuildingForPlayer(playerid, 956, 662.429, -552.164, 15.710, 0.250);
    RemoveBuildingForPlayer(playerid, 956, -253.742, 2599.760, 62.242, 0.250);
    RemoveBuildingForPlayer(playerid, 956, 2271.729, -76.460, 25.960, 0.250);
    RemoveBuildingForPlayer(playerid, 955, 1789.209, -1369.270, 15.164, 0.250);
    RemoveBuildingForPlayer(playerid, 955, 1729.790, -1943.050, 12.945, 0.250);
    RemoveBuildingForPlayer(playerid, 955, 1154.729, -1460.890, 15.156, 0.250);
    RemoveBuildingForPlayer(playerid, 955, -2118.969, -423.648, 34.726, 0.250);
    RemoveBuildingForPlayer(playerid, 955, -2118.620, -422.414, 34.726, 0.250);
    RemoveBuildingForPlayer(playerid, 955, -2097.270, -398.335, 34.726, 0.250);
    RemoveBuildingForPlayer(playerid, 955, -2092.090, -490.054, 34.726, 0.250);
    RemoveBuildingForPlayer(playerid, 955, -2063.270, -490.054, 34.726, 0.250);
    RemoveBuildingForPlayer(playerid, 955, -2005.650, -490.054, 34.726, 0.250);
    RemoveBuildingForPlayer(playerid, 955, -2034.459, -490.054, 34.726, 0.250);
    RemoveBuildingForPlayer(playerid, 955, -2068.560, -398.335, 34.726, 0.250);
    RemoveBuildingForPlayer(playerid, 955, -2039.849, -398.335, 34.726, 0.250);
    RemoveBuildingForPlayer(playerid, 955, -2011.140, -398.335, 34.726, 0.250);
    RemoveBuildingForPlayer(playerid, 955, -1980.790, 142.664, 27.070, 0.250);
    RemoveBuildingForPlayer(playerid, 955, 2319.989, 2532.850, 10.218, 0.250);
    RemoveBuildingForPlayer(playerid, 955, 1520.150, 1055.270, 10.000, 0.250);
    RemoveBuildingForPlayer(playerid, 955, 2503.139, 1243.699, 10.218, 0.250);
    RemoveBuildingForPlayer(playerid, 955, 2085.770, 2071.360, 10.453, 0.250);
    RemoveBuildingForPlayer(playerid, 955, -862.828, 1536.609, 21.984, 0.250);
    RemoveBuildingForPlayer(playerid, 955, -14.703, 1175.359, 18.953, 0.250);
    RemoveBuildingForPlayer(playerid, 955, -253.742, 2597.949, 62.242, 0.250);
    RemoveBuildingForPlayer(playerid, 955, 201.016, -107.616, 0.898, 0.250);
    RemoveBuildingForPlayer(playerid, 955, 1277.839, 372.515, 18.953, 0.250);
}
hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
	if(newkeys & KEY_YES) {
		if(IsPlayerInRangeOfPoint(playerid, 5,1853.3239,-1771.0874,13.6800)) {
	        if(PlayerInfo[playerid][pCompany] == 1) {
	        	Dialog_Show(playerid, DIALOG_SEL_MECH, DIALOG_STYLE_LIST, "Mechanic # ", "Mua dung cu\nMua binh xang\nThay dong phuc", "Xac nhan", "Huy bo");
    		   
	        }
	        else {
	        	Dialog_Show(playerid, DIALOG_SEL_MECH, DIALOG_STYLE_LIST, "Mechanic # ", "Mua dung cu\nMua binh xang", "Xac nhan", "Huy bo");
	        }       
		}
	}
}

Dialog:DIALOG_SEL_MECH(playerid, response, listitem, inputtext[]) {
	if(response) {
		if(listitem == 0) {
			if(PlayerInfo[playerid][pCompany] == 1) {
    		    Dialog_Show(playerid, DIALOG_MECHKIT, DIALOG_STYLE_INPUT, "Mechanic # Buy", "So luong phai tu 1-10.\n[Mechanic Co] Ban muon mua bao nhieu Mechkit:\nGia tien: $500/1 dung cu.", "Xac nhan", "Huy bo");
	        }
	        else {
	        	Dialog_Show(playerid, DIALOG_MECHKIT, DIALOG_STYLE_INPUT, "Mechanic # Buy", "So luong phai tu 1-10.[Mechanic Co] Ban muon mua bao nhieu Mechkit:\nGia tien: $2000/1 dung cu", "Xac nhan", "Huy bo");
	        }
		} 
		if(listitem == 1) {
			if(PlayerInfo[playerid][pCompany] == 1) {
    		    Dialog_Show(playerid, DIALOG_REFILLKIT, DIALOG_STYLE_INPUT, "Mechanic # Buy", "So luong phai tu 1-10.\n[Mechanic Co] Ban muon mua bao nhieu Binh xang:\nGia tien: $500/1 dung cu.", "Xac nhan", "Huy bo");
	        }
	        else {
	        	Dialog_Show(playerid, DIALOG_REFILLKIT, DIALOG_STYLE_INPUT, "Mechanic # Buy", "So luong phai tu 1-10.[Mechanic Co] Ban muon mua bao nhieu Binh xang:\nGia tien: $2000/1 dung cu", "Xac nhan", "Huy bo");
	        }
		}  
		if(listitem == 2)   SetPlayerSkin(playerid, 8  );
	}
}
Dialog:DIALOG_REFILLKIT(playerid, response, listitem, inputtext[]) {
	if(response) {
		new price;
		if(isnull(inputtext)) { 
	        if(PlayerInfo[playerid][pCompany] == 1) {
    		    Dialog_Show(playerid, DIALOG_REFILLKIT, DIALOG_STYLE_INPUT, "Mechanic # Buy", "[Mechanic Co] Ban muon mua bao nhieu Binh xang:\nGia tien: $500/1 dung cu.", "Xac nhan", "Huy bo");
	        }
	        else {
	        	Dialog_Show(playerid, DIALOG_REFILLKIT, DIALOG_STYLE_INPUT, "Mechanic # Buy", "[Mechanic Co] Ban muon mua bao nhieu Binh xang:\nGia tien: $2000/1 dung cu", "Xac nhan", "Huy bo");
	        }
	        return 1;	
	    } 
	    if(strval(inputtext) < 0 || strval(inputtext) > 10) {
            if(PlayerInfo[playerid][pCompany] == 1) {
    		    Dialog_Show(playerid, DIALOG_REFILLKIT, DIALOG_STYLE_INPUT, "Mechanic # Buy", "So luong phai tu 1-10.\n[Mechanic Co] Ban muon mua bao nhieu Binh xang:\nGia tien: $500/1 dung cu.", "Xac nhan", "Huy bo");
	        }
	        else {
	        	Dialog_Show(playerid, DIALOG_REFILLKIT, DIALOG_STYLE_INPUT, "Mechanic # Buy", "So luong phai tu 1-10.[Mechanic Co] Ban muon mua bao nhieu Binh xang:\nGia tien: $2000/1 dung cu", "Xac nhan", "Huy bo");
	        }
	        return 1;	
	    }
	    if(PlayerInfo[playerid][pCompany] == 1) {
	    	price =  500 * strval(inputtext);
	    }
	    else {
	    	price =  2000 * strval(inputtext);
	    }
	    if(CheckInventorySlotEmpty(playerid,38,strval(inputtext)) == -1) return SendErrorMessage(playerid,"Tui do cua ban da day khong the mua vat pham.");
	    if(PlayerInfo[playerid][pCash] < price) return SendErrorMessage(playerid," Ban khong co du tien de mua.");
        GivePlayerMoneyEx(playerid,-price);
        Inventory_@Add(playerid,38,strval(inputtext));

        new string[129];
        format(string, sizeof string, "[MECHANIC] Ban da mua thanh cong %d binh xang voi gia {f29655}$%s.", strval(inputtext),number_format(price));
	    SendClientMessageEx(playerid,COLOR_BASIC,string);

	    new string_log[229];
        format(string_log, sizeof(string_log), "[%s] %s đã mua thành công %d binh xang với giá $%s.", GetLogTime(),GetPlayerNameEx(playerid),strval(inputtext),number_format(price));         
        SendLogDiscordMSG(logs_mech, string_log);
	}
	return 1;
}
Dialog:DIALOG_MECHKIT(playerid, response, listitem, inputtext[]) {
	if(response) {
		new price;
		if(isnull(inputtext)) { 
	        if(PlayerInfo[playerid][pCompany] == 1) {
    		    Dialog_Show(playerid, DIALOG_MECHKIT, DIALOG_STYLE_INPUT, "Mechanic # Buy", "[Mechanic Co] Ban muon mua bao nhieu dung cu sua xe:\nGia tien: $500/1 dung cu.", "Xac nhan", "Huy bo");
	        }
	        else {
	        	Dialog_Show(playerid, DIALOG_MECHKIT, DIALOG_STYLE_INPUT, "Mechanic # Buy", "[Mechanic Co] Ban muon mua bao nhieu dung cu sua xe:\nGia tien: $2000/1 dung cu", "Xac nhan", "Huy bo");
	        }
	        return 1;	
	    } 
	    if(strval(inputtext) < 0 || strval(inputtext) > 10) {
            if(PlayerInfo[playerid][pCompany] == 1) {
    		    Dialog_Show(playerid, DIALOG_MECHKIT, DIALOG_STYLE_INPUT, "Mechanic # Buy", "So luong phai tu 1-10.\n[Mechanic Co] Ban muon mua bao nhieu dung cu sua xe:\nGia tien: $500/1 dung cu.", "Xac nhan", "Huy bo");
	        }
	        else {
	        	Dialog_Show(playerid, DIALOG_MECHKIT, DIALOG_STYLE_INPUT, "Mechanic # Buy", "So luong phai tu 1-10.[Mechanic Co] Ban muon mua bao nhieu dung cu sua xe:\nGia tien: $2000/1 dung cu", "Xac nhan", "Huy bo");
	        }
	        return 1;	
	    }
	    if(PlayerInfo[playerid][pCompany] == 1) {
	    	price =  500 * strval(inputtext);
	    }
	    else {
	    	price =  2000 * strval(inputtext);
	    }
	    if(CheckInventorySlotEmpty(playerid,36,strval(inputtext)) == -1) return SendErrorMessage(playerid,"Tui do cua ban da day khong the mua vat pham.");
	    if(PlayerInfo[playerid][pCash] < price) return SendErrorMessage(playerid," Ban khong co du tien de mua.");
        GivePlayerMoneyEx(playerid,-price);
        Inventory_@Add(playerid,36,strval(inputtext));

        new string[129];
        format(string, sizeof string, "[MECHANIC] Ban da mua thanh cong %d dung cu sua chua voi gia {f29655}$%s.", strval(inputtext),number_format(price));
	    SendClientMessageEx(playerid,COLOR_BASIC,string);

	    new string_log[229];
        format(string_log, sizeof(string_log), "[%s] %s đã mua thành công %d dụng cụ sửa chữa với giá $%s.", GetLogTime(),GetPlayerNameEx(playerid),strval(inputtext),number_format(price));         
        SendLogDiscordMSG(logs_mech, string_log);
	}
	return 1;
}

hook OnGameModeInit() {

    CreateDynamic3DTextLabel("< Mechanic >\nSu dung /suachuaxe de sua chua", COLOR_BASIC,1835.9268,-1791.3195,13.5567,5);
    CreateDynamic3DTextLabel("< Mechanic >\nSu dung /suachuaxe de sua chua", COLOR_BASIC,1844.3837,-1791.0076,13.5567,5);
    CreateDynamicPickup(1239, 23, 1926.1772,-1770.6112,13.5469);
	CreateActor(133, 1853.3239,-1771.0874,13.6800,14.7977);
	CreateDynamic3DTextLabel("< Mechanic dealer >\nBam 'Y' de mua dung cu sua chua", COLOR_BASIC,1853.3239,-1771.0874,13.6800,5);

    // new tmpobjid, object_world = -1, object_int = -1;
    CreateDynamicObject(3055, 2071.529296, -1831.409301, 13.696887, 0.000000, 0.000000, 90.000000, -1, -1, -1, 80,80); 
    CreateDynamicObject(3055, 1024.984619, -1029.423339, 32.145629, 0.000000, 0.000000, 0.000000, -1, -1, -1, 80,80); 
    CreateDynamicObject(3055, 2644.821289, -2039.129760, 13.122817, 0.000000, 0.000000, 0.000000, -1, -1, -1, 80,80); 
    CreateDynamicObject(3055, 1041.880493, -1025.931152, 31.730268, 0.000000, 0.000000, 0.000000, -1, -1, -1, 80,80); 
    CreateDynamicObject(3055, 719.878417, -462.518188, 16.560127, 0.000000, 0.000000, 0.000000, -1, -1, -1, 80,80); 
    CreateDynamicObject(3055, -2716.019287, 217.477020, 5.064446, 0.000000, 0.000000, 90.000000, -1, -1, -1, 80,80); 
    CreateDynamicObject(3055, -2425.706542, 1028.315063, 52.375057, 0.000000, 0.000000, 0.000000, -1, -1, -1, 80,80); 
    CreateDynamicObject(3055, -2425.706542, 1028.317016, 47.465038, 0.000000, 0.000000, 0.000000, -1, -1, -1, 80,80); 
    CreateDynamicObject(3055, 1968.512939, 2162.472656, 11.940009, 0.000000, 0.000000, 90.000000, -1, -1, -1, 80,80); 
    CreateDynamicObject(3055, 2006.024902, 2303.390625, 11.344020, 0.000000, 0.000000, 0.000000, -1, -1, -1, 80,80); 
    CreateDynamicObject(3055, 2006.024902, 2317.900634, 11.344020, 0.000000, 0.000000, 180.000000, -1, -1, -1, 80,80); 
    CreateDynamicObject(3055, -99.874908, 1111.541748, 21.727565, 0.000000, 0.000000, 0.000000, -1, -1, -1, 80,80); 
    CreateDynamicObject(3055, -99.874908, 1111.541748, 16.767568, 0.000000, 0.000000, 0.000000, -1, -1, -1, 80,80); 
    CreateDynamicObject(3055, -1420.502441, 2591.209716, 57.625896, 0.000000, 0.000007, 0.000000, -1, -1, -1, 80,80); 
    CreateDynamicObject(3055, -1420.502441, 2591.209716, 52.575881, 0.000000, 0.000007, 0.000000, -1, -1, -1, 80,80); 
    CreateDynamicObject(3055, 1843.237792, -1855.776367, 13.087626, 0.000000, 0.000000, 90.000000, -1, -1, -1, 80,80); 
    CreateDynamicObject(3055, -1935.757568, 239.204269, 34.754638, 0.000000, 0.000000, 0.000000, -1, -1, -1, 80,80); 
    CreateDynamicObject(3055, -1904.433593, 277.685058, 43.030796, 0.000000, 0.000000, 0.000000, -1, -1, -1, 80,80); 
    CreateDynamicObject(3055, -1904.433593, 277.685058, 38.050777, 0.000000, 0.000000, 0.000000, -1, -1, -1, 80,80); 
    CreateDynamicObject(3055, -1787.358520, 1209.346801, 24.676115, 0.000000, 0.000000, 0.000000, -1, -1, -1, 80,80); 
    CreateDynamicObject(3055, 1798.573364, -2146.666015, 13.543898, 0.000000, 0.000000, 90.000000, -1, -1, -1, 80,80); 
    CreateDynamicObject(3055, 488.123992, -1735.221191, 12.149552, 0.000000, 0.000000, -8.000000, -1, -1, -1, 80,80); 
    CreateDynamicObject(3055, 2393.816406, 1483.344726, 12.853613, 0.000000, 0.000000, 0.000000, -1, -1, -1, 80,80); 
    CreateDynamicObject(3055, 2393.816406, 1483.344726, 7.833617, 0.000000, 0.000000, 0.000000, -1, -1, -1, 80,80); 
    CreateDynamicObject(3055, 2386.708251, 1043.333129, 10.563805, 0.000000, 0.000000, 0.000000, -1, -1, -1, 80,80);
}