new bronze_str[] = {"{9ACD32} Premium: {FFFFFF} BRONZE\n\n {9ACD32} Huong loi:\n {FFFFFF} Ten co mau Bronze tren dien dan;\nMau va nhom tren dien dan;\nDung luong cua mang LAN tren dien dan la 150;\nThay doi ten duoc 2 lan;\n /blockpm (chan tin nhan PM tu mot nguoi choi cu the);\nLuong mau toi da o bao hiem y te;\nTat he thong Anti AFK;\nDanh ba dien thoai duoc nang len - 25;\nSo luong nha toi da de mua - 2;\nKha nang thay doi bien so xe cua ban - 3 lan "},
	bronze_str_2[] = {"Xe co san de mua: Bf Injection, Bandito;\n /setstyle (Co the thay doi HUD, co san de lua chon 4);\n /setstyle (Thay doi cach danh - co 4 loai);\nNang toi da phu kien co the duoc dat trong nha - 150 objects;\n\n {9ACD32} Gia: {FFFFFF} 150K VND."};


new silver_str[] = {"{9ACD32} Premium: {FFFFFF} SILVER\n\n {9ACD32} Huong loi:\n {FFFFFF} Silver title on the forum;\nColor and group on the forum;\nThe capacity of the LAN on the forum is 200;\nThay doi ten duoc 3 lan ;\n /blockpm (chan tin nhan PM tu mot nguoi choi cu the);\nLuong mau toi da khi nhap canh;\nTat he thong Anti AFK;\nDanh ba dien thoai duoc nang len - 35"},
    silver_str_2[] = {"Thoat khoi cong viec cua ban ngay lap tuc va khong sau 2 gio;\nLuu mat na sau khi thoat khoi tro choi;\nSo luong nha de mua toi da - 4;\nSo luong doanh nghiep toi da de mua - 2;\nSo luong xe toi da de mua - 5;\nKha nang dat tren xe nitro (2x, 5x, 10x);\nCo the thay doi bien so tren xe cua ban - 5 lan;\nCo san xe de mua: Bf Injection, Bandito, Sandking, Bullet, Cheetah"},
    silver_str_3[] = {"Giam thoi gian quang cao /ad /cad (60 giay cho tai khoan thong thuong, 30 giay cho tai khoan Silver);\n/setstyle (Thay doi kieu HUD, co san o lua chon 4);\n/setstyle (Thay doi kieu chien dau, co san lua chon 4 );\n Gioi han phu kien co san trong nha - 250 objects;\n\n {9ACD32} Gia: {FFFFFF} 250K VND."};


new gold_str[] = {"{9ACD32} Premium: {FFFFFF} GOLD\n\n {9ACD32} Huong loi:\n {FFFFFF} Gold title on the forum;\nColor and group on the forum;\nThe capacity of the LAN on the forum is 200;\nThay doi ten duoc 5 lan ;\n /blockpm (chan tin nhan PM tu mot nguoi choi cu the);\nLuong mau toi da khi vao;\nTat he thong Anti AFK"},
    gold_str_2[] = {"Gioi han so lien lac trong danh ba la 40;\nKhoi hanh ngay lap tuc, khong phai sau 2 gio;\nSu dung mat na sau khi roi tro choi;\nSo luong nha toi da can mua - 5;\nSo luong doanh nghiep toi da de mua - 3 ;\nSo luong xe toi da de mua - 7;\nCo the lap nitro (2x, 5x, 10x) tren xe;\nCo the thay doi bien so xe cua ban - 7 lan"},
    gold_str_3[] = {"Xe co san de mua: Infernus, Bullet, Cheetah, NRG-500, FBI Rancher, Sandking, Bf Injection, Bandito;\nGiam thoi gian quang cao /ad /cad time (Doi voi tai khoan thong thuong, nap 60 giay, doi voi GOLD la 30 giay);\n/setstyle (Thay doi kieu HUD, co san o lua chon 4);\n/setstyle (Thay doi phong cach trong chien dau, co san o lua chon 4);\nGioi han phan cung kha dung trong nha - 400 objects;\n\n {9ACD32} Gia: {FFFFFF} 450K VND."};
		
Donate_OnGameModeInit()
{
	new query[128];
	format(query, sizeof(query), "DELETE FROM `donate` WHERE `status`='0' AND `dateDelete` > %i", gettime());
	mysql_tquery(dbHandle, query);

	bronze_str[sizeof(bronze_str)-1] = '\n';
	bronze_str_2[sizeof(bronze_str_2)-1] = '\0';
	
    silver_str[sizeof(silver_str)-1] = '\n';
	silver_str_2[sizeof(silver_str_2)-1] = '\n';
	silver_str_3[sizeof(silver_str_3)-1] = '\0';

    gold_str[sizeof(gold_str)-1] = '\n';
	gold_str_2[sizeof(gold_str_2)-1] = '\n';
	gold_str_3[sizeof(gold_str_3)-1] = '\0';
}


CMD:donate(playerid, params[])
{
    Dialog_Show(playerid, DonateMenu, DIALOG_STYLE_LIST, "Privileges", "1. Mua\n\
	2. Thong tin\n\
	{6EA3FF}"WeburlName"", "Lua chon", "Huy");
	return 1;
}

Dialog:DonateMenu(playerid, response, listitem, inputtext[])
{
	if (!response)
	    return 1;

	switch(listitem)
	{
	    case 0:
	    {
			new title[32];
			format(title, sizeof(title), "Tai khoan ban co: {9ACD32}%i VND.", PlayerInfo[playerid][pDonate]);
	    
	        Dialog_Show(playerid, DonateBuy, DIALOG_STYLE_TABLIST, title, "Premium \"BRONZE\"\t{9ACD32}[250K VND]\n\
	        Premium \"SILVER\"\t{9ACD32}[350k VND]\n\
	        Premium \"GOLD\"\t{9ACD32}[450K VND]\n\
	        Thay doi ten\t{9ACD32}[50K VND]\n\
	        Thay doi so dien thoai\t{9ACD32}[20K VND]\n\
	        Thay doi bien so xe\t{9ACD32}[70K VND]", "Lua chon", "Quay lai");
	    }
	    case 1:
	    {
	        new mes[256];
	        format(mes, sizeof(mes), "{ffffff}Trong tai khoan cua ban hien co {9ACD32}%iK {FFFFFF}VND.\nSo lan de thay doi ten: %i lan. (/changenick)\nSo lan de thay doi bsx: %i lan. (/changeplate)", PlayerInfo[playerid][pDonate], PlayerInfo[playerid][pNameChanges], PlayerInfo[playerid][pNumberChanges]);
	        
	        new premium_info[4][8] =
				{"Usual", "BRONZE", "SILVER", "GOLD"};

			if (PlayerInfo[playerid][pPremium])
			{
				new Float:days = float(PlayerInfo[playerid][pPremiumTime] - gettime()) /86400.0;
			    format(mes, sizeof(mes), "%s\nBan co tai khoan Premium {9ACD32}%s{FFFFFF}. Con lai {9ACD32}%i{FFFFFF} ngay de su dung.",mes, premium_info[PlayerInfo[playerid][pPremium]], floatround(days));
			}
			Dialog_Show(playerid, DonateCancel, DIALOG_STYLE_MSGBOX, "Information", mes, "Return", "");
	    }
		case 2: return cmd::donate(playerid, "");
		
	}
	return 1;
}

Dialog:DonateBuy(playerid, response, listitem, inputtext[])
{
	if (!response)
		return cmd::donate(playerid, "");

	switch(listitem)
	{
		case 0: Dialog_Show(playerid, BuyPremium, DIALOG_STYLE_MSGBOX, "Premium", bronze_str, "Mua", "Quay lai");
		case 1: Dialog_Show(playerid, BuyPremium, DIALOG_STYLE_MSGBOX, "Premium", silver_str, "Mua", "Quay lai");
		case 2: Dialog_Show(playerid, BuyPremium, DIALOG_STYLE_MSGBOX, "Premium", gold_str, "Mua", "Quay lai");
		case 3: Dialog_Show(playerid, BuyName, DIALOG_STYLE_MSGBOX, "Thay doi ten", "{FFFFFF}Ban co muon thay doi ten? Gia: 50K VND.", "Mua", "Quay lai");
        case 4: Dialog_Show(playerid, BuyNumber, DIALOG_STYLE_INPUT, "Thay doi so dien thoai", "{FFFFFF}Nhap so moi cua ban. Ky tu toi da la 4. Gia: 20K VNDD.", "Mua", "Quay lai");
        case 5: Dialog_Show(playerid, BuyNumberplate, DIALOG_STYLE_MSGBOX, "Thay doi bsx", "{FFFFFF} Ban muon thay doi so xe? Gia: 70K VND.", "Mua", "Quay lai");
	}
	SetPVarInt(playerid, #premium_buy, listitem+1);
	return 1;
}

Dialog:BuyName(playerid, response, listitem, inputtext[])
{
	if (!response) return cmd::donate(playerid, "");

	#define PRICE_CHANGE_NAME (80)
	
	if (PlayerInfo[playerid][pDonate] < PRICE_CHANGE_NAME) return SendErrorMessage(playerid, "Khong co du tien donate trong tai khoan cua ban.");

	SendSyntaxMessage(playerid, "Ban da co co hoi thay doi ten cua minh voi gia %iK VND.", PRICE_CHANGE_NAME);

	PlayerInfo[playerid][pDonate] -= PRICE_CHANGE_NAME;
	PlayerInfo[playerid][pNameChanges]++;

	new query[128];
	mysql_format(dbHandle, query, sizeof(query), "UPDATE `accounts` SET `donate`=%i,`name_changes`=%i WHERE `id` = %i", PlayerInfo[playerid][pDonate], PlayerInfo[playerid][pNameChanges], PlayerInfo[playerid][pAccID]);
	mysql_tquery(dbHandle, query);

	format(query, sizeof(query), "%s [MYSQL: %i | IP: %s] bought a nickname change",
	GetName(playerid), PlayerInfo[playerid][pID], q_GetPlayerIP(playerid));
 	insert_log(query, DONATE_LOG, 1, PlayerInfo[playerid][pAccID]);
	return 1;
}

Dialog:BuyNumberplate(playerid, response, listitem, inputtext[])
{
	if (!response) return cmd::donate(playerid, "");

	#define PRICE_CHANGE_NUMBERPLATE (70)

	if (PlayerInfo[playerid][pDonate] < PRICE_CHANGE_NUMBERPLATE) return SendErrorMessage(playerid, "Khong co du tien donate trong tai khoan cua ban.");

	SendSyntaxMessage(playerid, "Ban da co co hoi thay doi bien so xe voi gia %iK VND.", PRICE_CHANGE_NUMBERPLATE);

	PlayerInfo[playerid][pDonate] -= PRICE_CHANGE_NUMBERPLATE;
	PlayerInfo[playerid][pNumberChanges]++;

	new query[128];
	mysql_format(dbHandle, query, sizeof(query), "UPDATE `accounts` SET `donate`=%i,`number_changes`=%i WHERE `id` = %i", PlayerInfo[playerid][pDonate], PlayerInfo[playerid][pNumberChanges], PlayerInfo[playerid][pAccID]);
	mysql_tquery(dbHandle, query);

	format(query, sizeof(query), "%s [MYSQL: %i | IP: %s] bought a change of license plate",
	GetName(playerid), PlayerInfo[playerid][pID], q_GetPlayerIP(playerid));
 	insert_log(query, DONATE_LOG, 3, PlayerInfo[playerid][pAccID]);
	return 1;
}

Dialog:BuyNumber(playerid, response, listitem, inputtext[])
{
	if (!response) return cmd::donate(playerid, "");

	if (strlen(inputtext) < 4 || strval(inputtext) < 1000)
	{
	    return Dialog_Show(playerid, BuyNumber, DIALOG_STYLE_MSGBOX, "{FFFFFF}Thay doi so dien thoai", "{FFFFFF}Nhap so moi cua ban, ky tu toi da la - 4. Gia: 20K VND.", "Mua", "Quay lai");
	}

	new query[128];
	mysql_format(dbHandle, query, sizeof(query), "SELECT `number` FROM `users` WHERE `number` = %i", strval(inputtext));
	mysql_tquery(dbHandle, query, "OnPlayerBuyDonateNumber", "ii", playerid, strval(inputtext));
	return 1;
}

forward OnPlayerBuyDonateNumber(playerid, number);
public OnPlayerBuyDonateNumber(playerid, number)
{
	if (cache_num_rows())
	{
	    Dialog_Show(playerid, BuyNumber, DIALOG_STYLE_MSGBOX, "Change phone number", "Nhap so moi cua ban, ky tu toi da la - 4. Gia: 20K VND.", "Mua", "Quay lai");
	    return SendErrorMessage(playerid, "So nay da duoc su dung.");
	}
	
	#define PRICE_CHANGE_NUMBER (100)

	if (PlayerInfo[playerid][pDonate] < PRICE_CHANGE_NUMBER) return SendErrorMessage(playerid, "Khong co du tien donate trong tai khoan cua ban.");
	if (!CheckNumberAvailable(number))						 return SendErrorMessage(playerid, "So dien thoai nay da duoc su dung! ");

	SendSyntaxMessage(playerid, "Ban da mua [%i] voi gia %iK VND.", number, PRICE_CHANGE_NUMBER);
	PlayerInfo[playerid][pDonate] -= PRICE_CHANGE_NUMBERPLATE;
	PlayerInfo[playerid][pNumber] = number;

	new query[128];

	mysql_format(dbHandle, query, sizeof(query), "UPDATE `accounts` SET `donate`=%i WHERE `id` = %i", PlayerInfo[playerid][pDonate], PlayerInfo[playerid][pAccID]);
	mysql_tquery(dbHandle, query);
    mysql_format(dbHandle, query, sizeof(query), "UPDATE `users` SET `number`=%i WHERE `id` = %i", number, PlayerInfo[playerid][pID]);
	mysql_tquery(dbHandle, query);

	format(query, sizeof(query), "%s [MYSQL: %i | IP: %s] bought a phone number- %i", GetName(playerid), PlayerInfo[playerid][pID], q_GetPlayerIP(playerid), number);
 	insert_log(query, DONATE_LOG, 4, PlayerInfo[playerid][pAccID]);
	return 1;
}

Dialog:BuyPremium(playerid, response, listitem, inputtext[])
{
	if (!response) 						return cmd::donate(playerid, "");
	if (PlayerInfo[playerid][pPremium])	return SendErrorMessage(playerid, "De mua Premium, ban phai doi cho den khi no ket thuc.");
	        
	listitem = GetPVarInt(playerid, #premium_buy)-1;
	
	if (listitem < 0 || listitem > 2) return 1;
	    
	new price_premium[3] = {150, 250, 350}, premium_name_changes[3] = {2, 3, 5}, premium_number_changes[3] = {3, 5, 7};
	new premium_info[3][8] = {"BRONZE", "SILVER", "GOLD"};
			
	if (PlayerInfo[playerid][pDonate] < price_premium[listitem]) return SendErrorMessage(playerid, "Khong co du tien donate trong tai khoan cua ban.");

	SendSyntaxMessage(playerid, "Ban da mua Premium %s cho 30 ngay voi gia %i.", premium_info[listitem], price_premium[listitem]);

	PlayerInfo[playerid][pDonate] -= price_premium[listitem];
	PlayerInfo[playerid][pNameChanges] += premium_name_changes[listitem];
	PlayerInfo[playerid][pNumberChanges] += premium_number_changes[listitem];
	PlayerInfo[playerid][pPremium] = listitem + 1;
    PlayerInfo[playerid][pPremiumTime] = gettime() + 30 * 86400;
	
	new query[128];
	
	mysql_format(dbHandle, query, sizeof(query), "UPDATE `accounts` SET `donate`=%i,`name_changes`=%i,`number_changes`=%i WHERE `id` = %i", PlayerInfo[playerid][pDonate], PlayerInfo[playerid][pNameChanges], PlayerInfo[playerid][pNumberChanges], PlayerInfo[playerid][pAccID]);
	mysql_tquery(dbHandle, query);
	mysql_format(dbHandle, query, sizeof(query), "UPDATE `users` SET `vip`=%i,`vip_time`=%i,`spawnhealth`=100.0 WHERE `id` = %i", PlayerInfo[playerid][pPremium], PlayerInfo[playerid][pPremiumTime], PlayerInfo[playerid][pID]);
	mysql_tquery(dbHandle, query);
    
	format(query, sizeof(query), "%s [MYSQL: %i | IP: %s] bought a premium %s", GetName(playerid), PlayerInfo[playerid][pID], q_GetPlayerIP(playerid), premium_info[listitem]);
 	insert_log(query, DONATE_LOG, 2, PlayerInfo[playerid][pAccID]);
	return 1;
}

Dialog:DonateCancel(playerid, response, listitem, inputtext[])
{
	cmd::donate(playerid, "");
	return 1;
}

CMD:changeplate(playerid, params[])
{
	if (PlayerInfo[playerid][pNumberChanges] < 1)		return SendErrorMessage(playerid, "De thay doi bien so, ban phai mua dac quyen nay. (/donate)");

	new vehicleid = GetPlayerVehicleID(playerid);

	if (!IsValidVehicle(PlayerInfo[playerid][pCarKey]))						return SendErrorMessage(playerid, "Phuong tien cua ban khong duoc tao ra.");
	if (vehicleid == 0)														return SendNotInVehicle(playerid);
	if (VehicleInfo[vehicleid][carOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Ban khong phai la chu so huu cua chiec xe nay.");

	Dialog_Show(playerid, ChangeNumberplate, DIALOG_STYLE_INPUT, "{FFFFFF}Nhap bsx moi ", "{FFFFFF}Nhap bsx moi:", "Thay doi", "Huy");
	return 1;
}


Dialog:ChangeNumberplate(playerid, response, listitem, inputtext[])
{
	if (!response)										return 1;
	if (strlen(inputtext) < 3 || strlen(inputtext) > 11)	return SendErrorMessage(playerid,"so ky tu trong bien so xe la tu 3 den 11.");

    new query[128];
	mysql_format(dbHandle, query, sizeof(query), "SELECT `plate` FROM `cars` WHERE `plate` = '%e'", inputtext);
	mysql_tquery(dbHandle, query, "DonateSetPlate", "is", playerid, inputtext);
    return 1;
}

this::DonateSetPlate(playerid, plate[])
{
	if (cache_num_rows())							return SendErrorMessage(playerid, "Bien so xe khac da duoc su dung.");
    if (PlayerInfo[playerid][pNumberChanges] < 1)	return SendErrorMessage(playerid, "De thay doi bien so, ban phai mua dac quyen nay. (/donate)");

	new vehicleid = GetPlayerVehicleID(playerid);

	if (!IsValidVehicle(PlayerInfo[playerid][pCarKey]))					return SendErrorMessage(playerid, "Phuong tien cua ban khong duoc tao ra.");
	if (vehicleid == 0)													return SendNotInVehicle(playerid);
	if (VehicleInfo[vehicleid][carOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Ban khong phai la chu so huu cua chiec xe nay.");

	PlayerInfo[playerid][pNumberChanges]--;
    DeleteVehicleTickets(vehicleid);
    format(VehicleInfo[vehicleid][carPlate], 24, "%s", plate);
	SetVehicleNumberPlate(vehicleid, VehicleInfo[vehicleid][carPlate]);
	RespawnVehicle(vehicleid, 1);
	Save_Car(vehicleid);
	SendSyntaxMessage(playerid, "Ban da thay doi bien so xe cua minh %s. BSX moi: %s", VehicleNames[GetVehicleModel(vehicleid)-400], plate);
	SendSyntaxMessage(playerid, "Tien phat phuong tien da duoc thanh toan.");

    new query[128];

	mysql_format(dbHandle, query, sizeof(query), "UPDATE `accounts` SET `number_changes`=%i WHERE `id` = %i", PlayerInfo[playerid][pNumberChanges], PlayerInfo[playerid][pAccID]);
	mysql_tquery(dbHandle, query);
	return 1;
}

CMD:changenick(playerid, params[])
{
	if (PlayerInfo[playerid][pNameChanges] < 1) return SendErrorMessage(playerid, "De dang ky thay doi ten, ban phai mua dac quyen nay. (/donate)");

	if (strlen(pTemp[playerid][pChangeNick]))
	{
	    pTemp[playerid][pChangeNick] = EOS;
	    return SendErrorMessage(playerid, "Ban da huy don dang ky thay doi ten cua minh. ");
	}

	Dialog_Show(playerid, ChangeNick, DIALOG_STYLE_INPUT, "{FFFFFF}Nhap ten moi", "{FFFFFF}Nhap ten moi (Ho_Ten):", ">>>", "Huy");
	return 1;
}

Dialog:ChangeNick(playerid, response, listitem, inputtext[])
{
	if (!response) 										return 1;
    if (!IsValidPlayerName(inputtext))					return SendErrorMessage(playerid, "Dinh dang ten khong hop le. ");
	if (strlen(inputtext) < 4 || strlen(inputtext) > 24)	return SendErrorMessage(playerid, "Cac ky tu tu 4 den 24.");

	format(pTemp[playerid][pChangeNick], MAX_PLAYER_NAME, inputtext);
	SendSyntaxMessage(playerid, "Ban da dang ky thay doi biet hieu - %s", inputtext);
	SendAdmMessage("%s (ID: %i) applied for a nickname change - %s. (/acceptname - to confirm)", GetNameEx(playerid), playerid, inputtext);
	return 1;
}

Dialog:NRNNAME(playerid, response, listitem, inputtext[])
{
	if (!response) 										return 1;
    if (!IsValidPlayerName(inputtext))					return SendErrorMessage(playerid, "Dinh dang ten khong hop le. ");
	if (strlen(inputtext) < 4 || strlen(inputtext) > 24)	return SendErrorMessage(playerid, "Cac ky tu tu 4 den 24.");

	format(pTemp[playerid][pChangeNick], MAX_PLAYER_NAME, inputtext);
	SendSyntaxMessage(playerid, "Ban da dang ky thay doi biet hieu - %s", inputtext);
	SendAdmMessage("%s (ID: %i) applied for a nickname change - %s. (/acceptnrn - to confirm)", GetNameEx(playerid), playerid, inputtext);
	return 1;
}
