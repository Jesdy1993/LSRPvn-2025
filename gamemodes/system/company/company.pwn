#define MAX_COMPANY 20
// company id 1 => mechanic
enum CompanyInfor {
	CompanyMember,
	CompanyID,
	CompanyName[52],
	CompanyBudget,
	CompanyLeader,
	CompanyLeaderName[32],
	CompanyVehicle[2],
	CompanyItem[5],
	CompanyAmount[5],
	CompanyPrice[5],
	Float:PosX[2],
	Float:PosY[2],
	Float:PosZ[2],
	Float:PosA[2]
}
new Company[MAX_COMPANY][CompanyInfor];


stock GetCompanyName(i) {
	new cpname[32];
	switch(i) {
		case 0: cpname = "Khong co";
		case 1: cpname = "Mechanic";
	}
	return cpname;
}
stock SaveCompany(i)
{
	new strupdate[1024];
	format(strupdate, sizeof strupdate, "UPDATE `company` SET `CompanyName`= '%s',`CompanyBudget`= '%d',`CompanyLeader`= '%d',`CompanyLeaderName`= '%s',`CompanyMember` = '%d', \
		`CompanyItem0`= '%d',`CompanyItem1`= '%d',`CompanyItem2`= '%d',`CompanyItem3`= '%d',`CompanyItem4`= '%d', `CompanyAmount0`= '%d',`CompanyAmount1`= '%d',`CompanyAmount2`= '%d',`CompanyAmount3`= '%d',`CompanyAmount4`= '%d', \
		`CompanyPrice0`= '%d',`CompanyPrice1`= '%d',`CompanyPrice2`= '%d',`CompanyPrice3`= '%d',`CompanyPrice4`= '%d' WHERE `CompanyID`=%d", 
	  Company[i][CompanyName],Company[i][CompanyBudget],Company[i][CompanyLeader],Company[i][CompanyLeaderName],Company[i][CompanyMember],
	  Company[i][CompanyItem][0],Company[i][CompanyItem][1],Company[i][CompanyItem][2],Company[i][CompanyItem][3],Company[i][CompanyItem][4],
	  Company[i][CompanyAmount][0],Company[i][CompanyAmount][1],Company[i][CompanyAmount][2],Company[i][CompanyAmount][3],Company[i][CompanyAmount][4],
	  Company[i][CompanyPrice][0],Company[i][CompanyPrice][1],Company[i][CompanyPrice][2],Company[i][CompanyPrice][3],Company[i][CompanyPrice][4],i);
	mysql_function_query(MainPipeline, strupdate, true, "OnSaveData", "i", i);


	format(strupdate, sizeof strupdate, "UPDATE `company` SET `PosX0`= '%f',`PosY0`= '%f', `PosZ0`= '%f', `PosA0`= '%f', \
		`PosX1`= '%f',`PosY1`= '%f', `PosZ1`= '%f', `PosA1`= '%f' WHERE `CompanyID`=%d", 
	  Company[i][PosX][0],Company[i][PosY][0],Company[i][PosZ][0],Company[i][PosA][0], Company[i][PosX][1],Company[i][PosY][1],Company[i][PosZ][1],Company[i][PosA][1],i);
	mysql_function_query(MainPipeline, strupdate, true, "OnSaveData", "i", i);
}
stock LoadCompany(i)
{
	new string[128];
	format(string, sizeof(string), "SELECT * FROM `company` WHERE `CompanyID`=%d", i);
	mysql_function_query(MainPipeline, string, true, "OnLoadCompany", "i", i);
}
forward OnLoadCompany(i);
public OnLoadCompany(i)
{
	new fields, szResult[64],rows;
	cache_get_data(rows, fields, MainPipeline);
    new str[129];
	for(new row;row < rows;row++)
	{
		cache_get_field_content(row,  "CompanyName",  Company[i][CompanyName], MainPipeline); 
		cache_get_field_content(row,  "CompanyBudget", szResult, MainPipeline); Company[i][CompanyBudget] = strval(szResult);
		cache_get_field_content(row,  "CompanyLeader", szResult, MainPipeline); Company[i][CompanyLeader] = strval(szResult);
		cache_get_field_content(row,  "CompanyLeaderName", Company[i][CompanyLeaderName] , MainPipeline); 

		cache_get_field_content(row,  "PosX0",szResult, MainPipeline);  Company[i][PosX][0] = floatstr(szResult);
		cache_get_field_content(row,  "PosY0",szResult, MainPipeline);  Company[i][PosY][0] = floatstr(szResult);
		cache_get_field_content(row,  "PosZ0",szResult, MainPipeline);  Company[i][PosZ][0] = floatstr(szResult);
		cache_get_field_content(row,  "PosA0",szResult, MainPipeline);  Company[i][PosA][0] = floatstr(szResult);
		cache_get_field_content(row,  "PosX1",szResult, MainPipeline);  Company[i][PosX][1] = floatstr(szResult);
		cache_get_field_content(row,  "PosY1",szResult, MainPipeline);  Company[i][PosY][1] = floatstr(szResult);
		cache_get_field_content(row,  "PosZ1",szResult, MainPipeline);  Company[i][PosZ][1] = floatstr(szResult);
		cache_get_field_content(row,  "PosA1",szResult, MainPipeline);  Company[i][PosA][0] = floatstr(szResult);

		for(new k = 0 ; k < 5 ; k++) {
            format(str,sizeof(str),"CompanyItem%d",k);
			cache_get_field_content(row,  str, szResult, MainPipeline); Company[i][CompanyItem][k] = strval(szResult);
			format(str,sizeof(str),"CompanyAmount%d",k);
			cache_get_field_content(row,  str, szResult, MainPipeline); Company[i][CompanyAmount][k] = strval(szResult);
			format(str,sizeof(str),"CompanyPrice%d",k);
			cache_get_field_content(row,  str, szResult, MainPipeline); Company[i][CompanyPrice][k] = strval(szResult);
		}
		break;
	}


	Company[i][CompanyVehicle][0] = CreateVehicle(525,Company[i][PosX][0], Company[i][PosY][0],Company[i][PosZ][0],Company[i][PosA][0], 1, 1,-1);
    Company[i][CompanyVehicle][1] = CreateVehicle(525,Company[i][PosX][1], Company[i][PosY][1],Company[i][PosZ][1],Company[i][PosA][1], 1, 1,-1);
    printf("%f.%f.%f.%f %f %f %d %d",Company[i][PosX][0], Company[i][PosY][0],Company[i][PosZ][0],Company[i][PosA][0],Company[i][CompanyVehicle][0],Company[i][CompanyVehicle][1]);
}

forward LoadCompanyMember(playerid);
public LoadCompanyMember(playerid)
{
    new rows = cache_num_rows(), total;
	if (rows == 0) return print("[Mechanic] khong co du lieu duoc tim thay.");
    new nhanvien[32],rank,payment;
    new string[1139];
    string = "#Nhan vien\tChuc vu\tTien luong\n";
	for(new i = 0; i < rows; i++)
	{
		cache_get_field_content(i,  "Username", nhanvien, MainPipeline, 128);
		// pid = cache_get_field_content_int(i, "id", MainPipeline);
		rank = cache_get_field_content_int(i, "Rank", MainPipeline);
		payment = cache_get_field_content_int(i, "pPayment", MainPipeline);
        format(string, sizeof(string), "{b4b4b4}%s%s\t%d\t{1fb832}%s\n", string,nhanvien,rank,number_format(payment));
        total++;
	}
	Dialog_Show(playerid, DIALOG_MEMBER_CO, DIALOG_STYLE_TABLIST_HEADERS, "Comapny # Member List", string, "Xac nhan", "Thoat");
	printf("[Ticket Dynamic] Loaded.");
	return 1;
}
stock Company@Budget(playerid,i) {
    new string[129];
    format(string, sizeof string, "{b4b4b4}Ngan sach cua cong ty hien tai la: $%s", number_format(Company[i][CompanyBudget]));
    Dialog_Show(playerid, COMPANY_BUDGET, DIALOG_STYLE_MSGBOX, "#Company", string, "Thoat","");
}
stock Company@WithdrawBudget(playerid,companyid,amount) {
    if(Company[companyid][CompanyBudget] < amount ) return SendErrorMessage(playerid," Ngan sach cong ty da het.");
    Company[companyid][CompanyBudget] -= amount;
    GivePlayerMoneyEx(playerid,amount);
    new str[129];
    format(str, sizeof str, "[COMPANY] %s da rut thanh cong %s ngan sach cua cong ty.", GetPlayerNameEx(playerid),number_format(amount));
    SendClientMessage(playerid, COLOR_BASIC, str);
    SaveCompany(companyid);
    new string_log[229];
    format(string_log, sizeof(string_log), "[%s] %s đã rút khỏi ngân sách @%s.co số tiền $%s", GetLogTime(),
    	GetPlayerNameEx(playerid),GetCompanyName(PlayerInfo[playerid][pCompany]),number_format(amount));         
    SendLogDiscordMSG(co_budget, string_log);
    return 1;
}
stock Company@AddBudget(companyid,amount) {
	Company[companyid][CompanyBudget] += amount;
	SaveCompany(companyid);
	new string_log[229];
    format(string_log, sizeof(string_log), "[%s] Ngân sách company @%s.co được tăng thêm số tiền $%s", GetLogTime(),
    	GetCompanyName(companyid),number_format(amount));         
    SendLogDiscordMSG(co_budget, string_log);
}
stock Company@DepositBudget(playerid,companyid,amount) {
    if(PlayerInfo[playerid][pCash] < amount ) return SendErrorMessage(playerid," Ban khong co du tien.");
    Company[companyid][CompanyBudget] += amount;
    GivePlayerMoneyEx(playerid,-amount);
    new str[129];
    format(str, sizeof str, "[COMPANY] %s da gui thanh cong %s vao ngan sach cua cong ty.", GetPlayerNameEx(playerid),number_format(amount));
    SendClientMessage(playerid, COLOR_BASIC, str);
    SaveCompany(companyid);
    new string_log[229];
    format(string_log, sizeof(string_log), "[%s] %s đã gửi vào ngân sách company @%s.cosố tiền $%s", GetLogTime(),
    	GetPlayerNameEx(playerid),GetCompanyName(PlayerInfo[playerid][pCompany]),number_format(amount));         
    SendLogDiscordMSG(co_budget, string_log);

    return 1;
}

stock ShowPanelCompany(playerid) {
    if(PlayerInfo[playerid][pCompany] == 1) {
    	Dialog_Show(playerid, COMPANY_PANEL, DIALOG_STYLE_LIST, "#Company @ Panel", "Quan li ngan sach\nQuan li nhan vien\nQuan li hoa don", "Chon","");
    }
    if(PlayerInfo[playerid][pCompany] == 2) {
    	Dialog_Show(playerid, COMPANY_PANEL, DIALOG_STYLE_LIST, "#Company @ Panel", "Quan li ngan sach\nQuan li nhan vien", "Chon","");
    }
    if(PlayerInfo[playerid][pCompany] == 3) {
    	Dialog_Show(playerid, COMPANY_PANEL, DIALOG_STYLE_LIST, "#Company @ Panel", "Quan li ngan sach\nQuan li nhan vien", "Chon","");
    }
    return 1;
}

Dialog:DIALOG_MEMBER_CO(playerid, response, listitem, inputtext[]) {
	if(response) {

	}
}
Dialog:COMPANY_BUDGET(playerid, response, listitem, inputtext[]) {
	if(response) {
		if(listitem == 0) {
			
		}
	}
}
Dialog:COMPANY_PANEL(playerid, response, listitem, inputtext[]) {
	if(response) {
		if(listitem == 0) {
		    Dialog_Show(playerid, COMPANY_SEL_PANEL, DIALOG_STYLE_LIST, "#Company @ Panel", "Gui tien vao ngan sach\nRut tien khoi ngan sach\nXem ngan sach", "Chon","Thoat");
		}
		if(listitem == 1) {
			new string[129];
			format(string,sizeof(string), "SELECT Id,Username,Rank,pPayment FROM `accounts` WHERE `pCompany` = %d",PlayerInfo[playerid][pCompany]);
		    mysql_function_query(MainPipeline,string, false, "LoadCompanyMember", "i", playerid);
		}
		if(listitem == 2) {
		    cmd_mechanic(playerid,"");
		}
	}
}

Dialog:COMPANY_DEPOSIT(playerid, response, listitem, inputtext[]) {
	if(response) {
		if(isnull(inputtext)) return Dialog_Show(playerid, COMPANY_DEPOSIT, DIALOG_STYLE_INPUT, "#Company @ Panel", "Vui long nhap so tien ban muon them vao ngan sach cong ty:", "Xac nhan","Thoat");
		if(strval(inputtext) < 10 || strval(inputtext) > 100000) return  Dialog_Show(playerid, COMPANY_DEPOSIT, DIALOG_STYLE_INPUT, "#Company @ Panel", "So tien phai tu $10-$100.000\nVui long nhap so tien ban muon them vao ngan sach cong ty:", "Xac nhan","Thoat");
		new companyid = PlayerInfo[playerid][pCompany];
		Company@DepositBudget(playerid,companyid,strval(inputtext));
	}
	return 1;
}
Dialog:COMPANY_WITHDRAW(playerid, response, listitem, inputtext[]) {
	if(response) {
		if(isnull(inputtext)) return Dialog_Show(playerid, COMPANY_DEPOSIT, DIALOG_STYLE_INPUT, "#Company @ Panel", "Vui long nhap so tien ban muon them vao ngan sach cong ty:", "Xac nhan","Thoat");
		if(strval(inputtext) < 10 || strval(inputtext) > 100000) return Dialog_Show(playerid, COMPANY_WITHDRAW, DIALOG_STYLE_INPUT, "#Company @ Panel", "So tien phai tu $10-$100.000\nVui long nhap so tien ban muon rut khoi ngan sach cong ty:", "Xac nhan","Thoat");
		new companyid = PlayerInfo[playerid][pCompany];
		Company@WithdrawBudget(playerid,companyid,strval(inputtext));
	}
	return 1;
}
Dialog:COMPANY_SEL_PANEL(playerid, response, listitem, inputtext[]) {
	if(response) {
		if(listitem == 0) {
			Dialog_Show(playerid, COMPANY_DEPOSIT, DIALOG_STYLE_INPUT, "#Company @ Deposit", "Vui long nhap so tien ban muon them vao ngan sach cong ty:", "Xac nhan","Thoat");
		}
		if(listitem == 1) {
			Dialog_Show(playerid, COMPANY_WITHDRAW, DIALOG_STYLE_INPUT, "#Company @ Withdraw", "Vui long nhap so tien ban muon rut khoi ngan sach cong ty:", "Xac nhan","Thoat");
		}
		if(listitem == 2) {
			Company@Budget(playerid,PlayerInfo[playerid][pCompany]);
		}
	}
}
CMD:company(playerid,params[]) {
	if(PlayerInfo[playerid][pCompany] == 0) return SendErrorMessage(playerid, " Ban khong phai company.");
	if(PlayerInfo[playerid][pCompany] == 1 && PlayerInfo[playerid][pRank] < 6) return SendErrorMessage(playerid, " Ban khong phai chu so huu.");
	if(PlayerInfo[playerid][pCompany] == 2 && PlayerInfo[playerid][pRank] < 6) return SendErrorMessage(playerid, " Ban khong phai chu so huu.");

	ShowPanelCompany(playerid);
    return 1;
}



CMD:quitcompany(playerid, params[])
{
    if(PlayerInfo[playerid][pCompany] != 0)
	{
		Company[PlayerInfo[playerid][pCompany] ][CompanyMember] --;
		SaveCompany(PlayerInfo[playerid][pCompany]);
		SendClientMessageEx(playerid, COLOR_LIGHTRED, "Ban da nghi viec tai cong ty thanh cong.");	
		PlayerInfo[playerid][pCompany] = 0;
		PlayerInfo[playerid][pRank] = 0;
		PlayerInfo[playerid][pPayment] = 0;
		new strupdate[129];
		format(strupdate, sizeof strupdate, "UPDATE `accounts` SET `pPayment`= '%d',`pCompany`= '%d' WHERE `Id`=%d", 
	    PlayerInfo[playerid][pPayment],PlayerInfo[playerid][pCompany],GetPlayerSQLId(playerid));
	    mysql_function_query(MainPipeline, strupdate, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	}
	else
	{
		SendErrorMessage(playerid,"Ban khong o trong family.");
	}
	return 1;
}
CMD:cokickoff(playerid, params[])
{
	if(PlayerInfo[playerid][pCompany] != 0 || PlayerInfo[playerid][pRank] >= 6)
	{
		new string[128], giveplayerid[32];
		if(sscanf(params, "s[32]", giveplayerid)) return SendUsageMessage(playerid, " /sathai [ten nguoi choi]");

		new strupdate[129];
		format(strupdate, sizeof strupdate, "UPDATE `accounts` SET `pPayment`= '%d',`pCompany`= '%d' WHERE `Username`= '%s'", 
	    giveplayerid);
	    mysql_function_query(MainPipeline, strupdate, false, "OnQueryFinish", "i", SENDDATA_THREAD);
		
		format(string, sizeof(string), "Ban da sa thai thanh cong nhan vien %s.", giveplayerid);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		
	}
	return 1;
}

CMD:cokick(playerid, params[])
{
	if(PlayerInfo[playerid][pCompany] != 0 || PlayerInfo[playerid][pRank] >= 6)
	{
		new string[128], giveplayerid;
		if(sscanf(params, "u", giveplayerid)) return SendUsageMessage(playerid, " /sathai [player]");

		if(IsPlayerConnected(giveplayerid))
		{
			if(PlayerInfo[giveplayerid][pCompany] != 0)
			{
				format(string, sizeof(string), "Ban da bi sa thai khoi company, boi %s.", GetPlayerNameEx( playerid ));
				SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
				SetPVarInt(giveplayerid, "MechanicDuty", 0);
				PlayerInfo[giveplayerid][pRank] = 0;
				PlayerInfo[giveplayerid][pPayment] = 0;
				PlayerInfo[giveplayerid][pCompany] = 0;
				new strupdate[129];
			   	format(strupdate, sizeof strupdate, "UPDATE `accounts` SET `pPayment`= '%d',`pCompany`= '%d' WHERE `Id`=%d", 
	            PlayerInfo[giveplayerid][pPayment],PlayerInfo[giveplayerid][pCompany],GetPlayerSQLId(giveplayerid));
	            mysql_function_query(MainPipeline, strupdate, false, "OnQueryFinish", "i", SENDDATA_THREAD);
			
				format(string, sizeof(string), "Ban da sa thai thanh cong nhan vien %s.", GetPlayerNameEx(giveplayerid));
				SendClientMessageEx(playerid, COLOR_WHITE, string);
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_WHITE, "You can't kick someone from a group if they're not a member.");
			}
		}
		else
		{
			SendErrorMessage(playerid,"Nguoi choi khong hop le.");
		}
	}
	return 1;
}



CMD:copayday(playerid, params[]) {
	if(PlayerInfo[playerid][pCompany] != 0 && PlayerInfo[playerid][pRank] >= 6) {
		new string[128], giveplayerid, rank;
		if(sscanf(params, "ud", giveplayerid, rank)) return SendUsageMessage(playerid, " /copayday [playerid] [amount]");


		if(rank > 10000 || rank < 0) { SendErrorMessage(playerid,"   Khong duoc duoi 0 hoac lon hon $10.000"); return 1; }

		if(IsPlayerConnected(giveplayerid))
		{
		 
			if(PlayerInfo[playerid][pCompany] != PlayerInfo[giveplayerid][pCompany])
			{
				SendErrorMessage(playerid,"   Nguoi choi khong o trong Cong ty cua ban.");
				return 1;
			}

			if(rank > PlayerInfo[giveplayerid][pPayment])
			{
				format(string, sizeof(string), "   Ban da duoc tang luong boi quan li %s.", GetPlayerNameEx(playerid));
			}
			if(rank < PlayerInfo[giveplayerid][pPayment])
			{
				format(string, sizeof(string), "   Ban da bi giam luong boi quan li %s.", GetPlayerNameEx(playerid));
			}
			SendClientMessageEx(playerid,-1,string);

			PlayerInfo[giveplayerid][pPayment] = rank;

			
			new strupdate[129];
			format(strupdate, sizeof strupdate, "UPDATE `accounts` SET `pPayment`= '%d',`pCompany`= '%d' WHERE `Id`=%d", 
	        PlayerInfo[giveplayerid][pPayment],PlayerInfo[giveplayerid][pCompany],GetPlayerSQLId(giveplayerid));
	        mysql_function_query(MainPipeline, strupdate, false, "OnQueryFinish", "i", SENDDATA_THREAD);

	
			return 1;
		}
		else
		{
			SendErrorMessage(playerid,"nguoi choi khong hop le.");
			return 1;
		}
	}
	else SendErrorMessage(playerid,"Ban khong phai giam doc Cong ty.");
	return 1;
}

CMD:cogiverank(playerid, params[]) {
	if(PlayerInfo[playerid][pCompany] != 0 && PlayerInfo[playerid][pRank] >= 9) {
		new string[128], giveplayerid, rank;
		if(sscanf(params, "ud", giveplayerid, rank)) return SendUsageMessage(playerid, " /cogiverank [playerid] [Rank 1-9]");

		if(PlayerInfo[playerid][pRank] == 6)
		{
			if(rank > 9 || rank < 0) { SendErrorMessage(playerid,"   Khong duoc duoi 0, hoac tren 9!"); return 1; }
		}

		if(IsPlayerConnected(giveplayerid))
		{
		 
			if(PlayerInfo[playerid][pCompany] != PlayerInfo[giveplayerid][pCompany])
			{
				SendErrorMessage(playerid,"   Nguoi choi khong o trong Cong ty cua ban.");
				return 1;
			}

			if(rank > PlayerInfo[giveplayerid][pRank])
			{
				format(string, sizeof(string), "   Ban da duoc thap chuc boi %s.", GetPlayerNameEx(playerid));
			}
			if(rank < PlayerInfo[giveplayerid][pRank])
			{
				format(string, sizeof(string), "   Ban da bi giang chuc boi %s.", GetPlayerNameEx(playerid));
			}
			
			format(string, sizeof(string), "[COMPANY] Ban da chinh sua chuc vu cua %s thanh %d.",GetPlayerNameEx(giveplayerid),rank);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
			format(string, sizeof(string), "[COMPANY] Quan li %s da chinh sua chuc vu cua ban thanh %d.",GetPlayerNameEx(playerid),rank);
			SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
			PlayerInfo[giveplayerid][pRank] = rank;
			return 1;
		}
		else
		{
			SendErrorMessage(playerid,"nguoi choi khong hop le.");
			return 1;
		}
	}
	else SendErrorMessage(playerid,"Ban khong phai giam doc Cong ty.");
	return 1;
}
CMD:coinvite(playerid, params[]) {
	if(PlayerInfo[playerid][pCompany] != 0 && PlayerInfo[playerid][pRank] >= 5)
	{
		new
			string[128],
			iTargetID,
			family = PlayerInfo[playerid][pCompany];

		if(sscanf(params, "u", iTargetID)) {
			SendUsageMessage(playerid, " /invite [nguoi choi]");
		}
		else if(IsPlayerConnected(iTargetID))
		{
			if(PlayerInfo[playerid][pCompany] != 0) {
	    		format(string, sizeof(string), "[COMPANY] Ban da de nghi tuyen dung %s tham gia @'%s'.co",GetPlayerNameEx(iTargetID),GetCompanyName(PlayerInfo[playerid][pCompany]));
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
				format(string, sizeof(string), "[COMPANY] %s da dang tuyen dung ban vao @'%s'.co (su dung /chapnhan company)",GetPlayerNameEx(playerid), GetCompanyName(PlayerInfo[playerid][pCompany]));
				SendClientMessageEx(iTargetID, COLOR_LIGHTBLUE, string);
				InviteOffer[iTargetID] = playerid;
				InviteFamily[iTargetID] = family;
			}
			else
			{
				SendErrorMessage(playerid," Nguoi choi do dang lam cho mot company khac.");
			}
			return 1;
		}
		else
		{
			SendErrorMessage(playerid,"nguoi choi khong hop le.");
			return 1;
		}
	}
	else SendErrorMessage(playerid,"Chi co Leader moi co the su dung lenh nay.");
	return 1;
}

CMD:co(playerid, params[])
{


	new string[128];
	if(isnull(params)) return SendUsageMessage(playerid, " (/co)mpany [company chat]");


	if(PlayerInfo[playerid][pCompany] == 1)
	{
	    if(PlayerInfo[playerid][pCompany] == 1) {
	    	if(0 <= PlayerInfo[playerid][pRank] < 5)
	        {
		        format(string, sizeof(string), "** [%i] Nhan vien %s: %s **", PlayerInfo[playerid][pRank], GetPlayerNameEx(playerid), params);
		    	SendMechanicChat( 0xb49c33AA, string);
		    }
		    else
		    {
		        format(string, sizeof(string), "** [%i] Giam doc %s: %s **", PlayerInfo[playerid][pRank], GetPlayerNameEx(playerid), params);
		    	SendMechanicChat(0xb49c33AA, string);
		    }
	    } 
	}
	else
	{
		SendErrorMessage(playerid,"Ban khong o trong Panel!");
	}
	return 1;
}
CMD:companyrespawn(playerid,params[] ) {
	SetVehicleToRespawn(Company[1][CompanyVehicle][0] );
	SetVehicleToRespawn(Company[1][CompanyVehicle][1] );
	return 1;
}
CMD:companycmds(playerid,params[]) {
	SendClientMessageEx(playerid,COLOR_BASIC,"LEADER COMPANY: /co(mpany) , /coinvite,/cogiverank, /company , /quitcompany, /cokick , /copayday");
	if(PlayerInfo[playerid][pCompany] == 1 ) SendClientMessageEx(playerid,COLOR_BASIC,"MECHANIC: /mechduty, /suachuaxe");
	return 1;
}
hook OnPlayerEnterVehicle(playerid, vehicleid, ispassenger) {
    if(vehicleid ==  Company[1][CompanyVehicle][0] || vehicleid ==  Company[1][CompanyVehicle][1])
	{
		if(PlayerInfo[playerid][pCompany] != 1 ) {
			RemovePlayerFromVehicle(playerid);
		    new Float:slx, Float:sly, Float:slz;
		    GetPlayerPos(playerid, slx, sly, slz);
		    SetPlayerPos(playerid, slx, sly, slz);
		    defer NOPCheck(playerid);
		    SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong o trong @Panel khong the lai xe nay.");
		}
	}
}
CMD:copark(playerid) {
	new i  = 1;
	if(PlayerInfo[playerid][pCompany] != 1) return SendErrorMessage(playerid, " Ban khong phai company");
	if(Company[i][CompanyVehicle][0] != GetPlayerVehicleID(playerid) && Company[i][CompanyVehicle][1] != GetPlayerVehicleID(playerid)) return SendErrorMessage(playerid, " Phuong tien nay khong phai cua Company");
    new Float:Pos[4],veh;
    GetPlayerPos(playerid, Pos[0],Pos[1],Pos[2]);
    GetPlayerFacingAngle(playerid, Pos[3]);
    if(GetPlayerVehicleID(playerid) == Company[i][CompanyVehicle][0] ) veh = 0;
    else if(GetPlayerVehicleID(playerid) == Company[i][CompanyVehicle][1] ) veh = 1;
    Company[i][PosX][veh] = Pos[0];
    Company[i][PosY][veh] = Pos[1];
    Company[i][PosZ][veh] = Pos[2];
    Company[i][PosA][veh] = Pos[3];
    DestroyVehicle( Company[i][CompanyVehicle][veh]);
    Company[i][CompanyVehicle][veh] = CreateVehicle(525, Pos[0],Pos[1],Pos[2],Pos[3], 2, 2, -1);
    SendClientMessageEx(playerid, -1," Phuong tien duoc dau thanh cong.");
    return 1;
}