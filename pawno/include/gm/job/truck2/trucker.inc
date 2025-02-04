#define DEFAULT_TIME_TRUCKGIA 130
#define DEFAULT_TIME_TRUCKGIA2 200
#define MAX_ITEM_TRUCK 5
#define MAX_TRUCKCAR_SLOT 5 // toi da 5 thung hang
/*#define LIST_TRUCKER 1221
#define TRUCK_LAYHANG 1223
#define TRUCK_BANHANG   1224
#define TRUCK_MAIN 1225*/

new truck_nameitem[MAX_ITEM_TRUCK][32] = 
{
	"Empty",
    "Xang",
	"Nguyen lieu",
	"Thuc pham",
	"Vu khi nhe"
};
new company_name[MAX_ITEM_TRUCK][32] = {
	"Empty",
    "Cay xang Los Santos",
	"Material Factory Los Santos",
	"Food Factory Los Santos",
	"Weapon Factory Los Santos"
};
new Float:Pos_buyitem[MAX_ITEM_TRUCK][3] = {
    {0.0,0.0,0.0}, // post de lay hang xang
    {2657.9153,-2114.8289,13.5469}, // post de lay hang xang
    {2164.9043,-2308.2195,13.5469}, // post de lay nguyen lieu
    {1751.3557,-2056.2791,13.8428}, // post de lay thuc pham
    {2785.4036,-2418.3857,13.6342} // post de lay vu khi
};
new Float:Pos_sellitem[MAX_ITEM_TRUCK][3] = {
    {0.0,0.0,0.0}, // post de lay hang xang
    {2639.5361,1114.9008,10.8203}, // post de ban hang xang
    {-1869.5895,1415.1965,7.1850}, // post de ban nguyen lieu
    {-1460.0431,-628.5864,14.1484}, // post de ban thuc pham
    {2293.8582,2738.7275,10.8203} // post de ban vu khi
};

new truck_pricebuyitem[MAX_ITEM_TRUCK] = {
    0, // item 0
    100, // xang
    200, // nguyen lieu
    200, // thuc pham
    300 // vu khi nhe
};
new truck_pricesellitem[MAX_ITEM_TRUCK] = {
    0, // item 0
    100, // xang
    200, // nguyen lieu
    200, // thuc pham
    300 // vu khi nhe
};
new Text3D:p_pricebuyitem[5];
new Text3D:p_pricesellitem[5];
new ThungHang[MAX_PLAYERS],bool:OpenGiaTruck[MAX_PLAYERS];
new TimerCountSP,TimerSP,TimerCountSPSell;
 // DestroyVehicle(vehid);
CMD:togtruckmarket(playerid,params[]) {
    if(OpenGiaTruck[playerid] == false) {
        SendClientMessage(playerid,COLOR_YELLOW,"Ban da bat thong bao gia thi truong Trucker");
        OpenGiaTruck[playerid] = true;
    }
    else if(OpenGiaTruck[playerid] == true) {
        SendClientMessage(playerid,COLOR_YELLOW,"Ban da tat thong bao gia thi truong Trucker");
        OpenGiaTruck[playerid] = false;
    }
    return 1;
}
CMD:atruck(playerid,params[])
{
	new option[30],pricechange,str[129];

	if (sscanf(params, "s[30]d", option,pricechange))
	{
		SendHelpMessage(playerid, "/atruck [pbxang / pbnguyenlieu / pbthucpham / pbvukhi / psxang / psnguyenlieu / psthucpham / psvukhi]");
		SendHelpMessage(playerid, "note: PB = price buy, PS = price sell");
        return 1;
	}
    if (CompareStrings(option, "pbxang"))
	{
        truck_pricebuyitem[1] = pricechange;
        format(str,sizeof str, "[Admin] ban da thay doi gia mua hang %s thanh $%d",truck_nameitem[1],pricechange);
        SendClientMessage(playerid,COLOR_GREY,str);
    }
    if (CompareStrings(option, "pbnguyenlieu"))
	{
        truck_pricebuyitem[2] = pricechange;
        format(str,sizeof str, "[Admin] ban da thay doi gia mua hang %s thanh $%d",truck_nameitem[2],pricechange);
        SendClientMessage(playerid,COLOR_GREY,str);
    }
    if (CompareStrings(option, "pbthucpham"))
	{
        truck_pricebuyitem[3] = pricechange;
        format(str,sizeof str, "[Admin] ban da thay doi gia mua hang %s thanh $%d",truck_nameitem[3],pricechange);
        SendClientMessage(playerid,COLOR_GREY,str);
    }
    if (CompareStrings(option, "pbvukhi"))
	{
        truck_pricebuyitem[4] = pricechange;
        format(str,sizeof str, "[Admin] ban da thay doi gia mua hang %s thanh $%d",truck_nameitem[4],pricechange);
        SendClientMessage(playerid,COLOR_GREY,str);
    }
    if (CompareStrings(option, "psxang"))
	{
        truck_pricesellitem[1] = pricechange;
        format(str,sizeof str, "[Admin] ban da thay doi gia ban hang %s thanh $%d",truck_nameitem[1],pricechange);
        SendClientMessage(playerid,COLOR_GREY,str);
    }
    if (CompareStrings(option, "psnguyenlieu"))
	{
        truck_pricesellitem[2] = pricechange;
        format(str,sizeof str, "[Admin] ban da thay doi gia ban hang %s thanh $%d",truck_nameitem[2],pricechange);
        SendClientMessage(playerid,COLOR_GREY,str);
    }
    if (CompareStrings(option, "psthucpham"))
	{
        truck_pricesellitem[3] = pricechange;
        format(str,sizeof str, "[Admin] ban da thay doi gia ban hang %s thanh $%d",truck_nameitem[3],pricechange);
        SendClientMessage(playerid,COLOR_GREY,str);
    }
    if (CompareStrings(option, "psvukhi"))
	{
        truck_pricesellitem[4] = pricechange;
        format(str,sizeof str, "[Admin] ban da thay doi gia ban hang %s thanh $%d",truck_nameitem[4],pricechange);
        SendClientMessage(playerid,COLOR_GREY,str);
    }
    return 1;
}
CMD:truck(playerid,params[])
{
    if(LockTruck == true) return SendErrorMessage(playerid,"He thong nay dang bi khoa");
	new option[30];

	if (sscanf(params, "s[30]", option))
	{
		SendHelpMessage(playerid, "/truck [ diadiem / muahang / layhang / chathang / giaohang]");
		return 1;
	}
    if (CompareStrings(option, "diadiem"))
	{
        Dialog_Show(playerid, TRUCK_MAIN ,DIALOG_STYLE_LIST, "Truck | Main", "Dia diem mua hang\nDia diem ban hang", "Chon", "Quay lai");
           
    }
    if (CompareStrings(option, "vutbo"))
	{
        new str[129];
        if(ThungHang[playerid] == 0) return SendClientMessage(playerid,COLOR_GREY,"Ban khong cam thung hang tren tay.");
        if (IsPlayerAttachedObjectSlotUsed(playerid, ATTACH_HANDS))	RemovePlayerAttachedObject(playerid, ATTACH_HANDS);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        format(str,sizeof str, "Ban da vut bo thanh cong thung hang %s",truck_nameitem[ThungHang[playerid]]);
        SendClientMessage(playerid,COLOR_GREY,str);
        ThungHang[playerid] = 0;
    }
    if (CompareStrings(option, "banhang"))
	{
        new str[129];
        if(ThungHang[playerid] == 0) return SendClientMessage(playerid,COLOR_GREY,"Ban khong cam thung hang tren tay.");
        if(!IsPlayerInRangeOfPoint(playerid,5,Pos_sellitem[ThungHang[playerid]][0],Pos_sellitem[ThungHang[playerid]][1],Pos_sellitem[ThungHang[playerid]][2])) {
            format(str,sizeof str, "Ban khong o noi thu mua mat hang %s",truck_nameitem[ThungHang[playerid]]);
            SendClientMessage(playerid,COLOR_GREY,str);
            return 1;
        } 
        if (IsPlayerAttachedObjectSlotUsed(playerid, ATTACH_HANDS))	RemovePlayerAttachedObject(playerid, ATTACH_HANDS);
  		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GiveCash(playerid,truck_pricesellitem[ThungHang[playerid] ]);
        format(str,sizeof str, "Ban da ban thanh cong thung hang %s voi gia la $%d",truck_nameitem[ThungHang[playerid]],truck_pricesellitem[ThungHang[playerid]] );
        SendClientMessage(playerid,COLOR_GREY,str);
        ThungHang[playerid] = 0;
    }
	if (CompareStrings(option, "muahang"))
	{
        if( ThungHang[playerid] != 0) return SendClientMessage(playerid,COLOR_GREY,"Ban dang cam mot thung hang khac tren tay.");
        for(new i = 1; i < MAX_ITEM_TRUCK;i++) {
            if(!IsPlayerInRangeOfPoint(playerid, 5, Pos_buyitem[i][0],Pos_buyitem[i][1],Pos_buyitem[i][2])) return SendClientMessage(playerid,-1,"Ban khong o gan bat ki noi nhap hang nao.");
            if (IsPlayerAttachedObjectSlotUsed(playerid, ATTACH_HANDS) || ThungHang[playerid] != 0 )	return SendErrorMessage(playerid, "Tay cua ban dang cam thu gi do.");
            SetPlayerAttachedObject(playerid, ATTACH_HANDS, 2912, 5, 0.102000, 0.306000, -0.228999, -1.100001, 14.499999, -1.300000, 1.000000, 1.000000, 1.000000);
            SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
            ThungHang[playerid] = i;
            GiveCash(playerid, -truck_pricebuyitem[i]);
            new string[129];
            format(string,sizeof(string),"Ban da lay thung hang %s voi gia %d$",truck_nameitem[i],truck_pricebuyitem[i]);
            SendClientMessage(playerid,COLOR_YELLOW,string);
            break ;
        }
        return 1;
    }
    if (CompareStrings(option, "layhang"))
	{
        new vehicleid;
        if((vehicleid = GetNearBootVehicle(playerid)) == 0) return SendClientMessage(playerid,COLOR_GREY,"Ban khong o gan mot chiec xe nao ca."); 
        if(GetVehicleModel(vehicleid) != 499) return SendClientMessage(playerid,COLOR_GREY,"Phuong tien nay khong phai phuong tien van chuyen.");
        if (VehicleInfo[vehicleid][carOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Ban khong so huu phuong tien nay.");
        if (VehicleInfo[vehicleid][carTrunkLock] == 0)							return SendErrorMessage(playerid, "Thung xe nay dang duoc dong lai."); 
        new stringdialog[320] = "{9ACD32}San pham\t{9ACD32}Gia nhap";
        for(new i = 0; i < MAX_TRUCKCAR_SLOT; i++) {
            format(stringdialog,sizeof(stringdialog),"%s\n%s\t%d",stringdialog,truck_nameitem[VehicleInfo[vehicleid][TruckThungHangCar][i]],truck_pricebuyitem[VehicleInfo[vehicleid][TruckThungHangCar][i]]);
        }
        SetPVarInt(playerid, "NearVehicle", vehicleid);
        Dialog_Show(playerid, LIST_TRUCKER, DIALOG_STYLE_TABLIST_HEADERS, "Hang tren xe", stringdialog, "Lay ra", "Thoat");
    }

    if (CompareStrings(option, "chathang"))
	{
        print("hoat dong");
        new vehicleid;
        if((vehicleid = GetNearBootVehicle(playerid)) == 0) return SendClientMessage(playerid,COLOR_GREY,"Ban khong o gan mot chiec xe nao ca."); 
        if(GetVehicleModel(vehicleid) != 499) return SendClientMessage(playerid,COLOR_GREY,"Phuong tien nay khong phai phuong tien van chuyen.");
        if (VehicleInfo[vehicleid][carOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Ban khong so huu phuong tien nay.");
        if (VehicleInfo[vehicleid][carTrunkLock] == 0)							return SendErrorMessage(playerid, "Thung xe nay dang duoc dong lai."); 
        if(ThungHang[playerid] == 0) return SendClientMessage(playerid,COLOR_GREY,"Tren tay ban khong cam mot thung hang.");
        new taihang = -1;
        for(new i = 0; i < MAX_TRUCKCAR_SLOT; i++) 
        {
            if( VehicleInfo[vehicleid][TruckThungHangCar][i] == 0) 
            {
                taihang = i+1;
                SendClientMessage(playerid,COLOR_GREY,"[TRUCK] Ban da dat thung hang len xe truck thanh cong.");
                VehicleInfo[vehicleid][TruckThungHangCar][i] = ThungHang[playerid];
                ThungHang[playerid] = 0;
                if (IsPlayerAttachedObjectSlotUsed(playerid, ATTACH_HANDS))	RemovePlayerAttachedObject(playerid, ATTACH_HANDS);
  		        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
                return 1;
            }
        }
        if( taihang == -1)  {
            SendClientMessage(playerid,COLOR_GREY,"[TRUCK] Ban khong con cho trong tren xe."); 
        }
        return 1;
    }
    return 1;
}

Dialog:TRUCK_LAYHANG(playerid, response, listitem, inputtext[]) {
    print("hoat dong");
    if (!response)	return 1;
    Waypoint_Set(playerid, Pos_buyitem[listitem+1][0], Pos_buyitem[listitem+1][1], Pos_buyitem[listitem+1][2],3.0);
	PlayerPlaySound(playerid, 21001, 0.0, 0.0, 0.0);
    return 1;
}
Dialog:TRUCK_BANHANG(playerid, response, listitem, inputtext[]) {
    print("hoat dong");
    if (!response)	return 1;
    Waypoint_Set(playerid, Pos_sellitem[listitem+1][0], Pos_sellitem[listitem+1][1], Pos_sellitem[listitem+1][2],3.0);
	PlayerPlaySound(playerid, 21001, 0.0, 0.0, 0.0);
    return 1;
}
Dialog:TRUCK_MAIN(playerid, response, listitem, inputtext[]) 
{
    print("hoat dong");
    if (!response)	return 1;
    if(listitem == 0) 
    {
        new str[300] = "Name\tLoai hang\tGia ban";
        for(new i = 1; i < 5 ; i++) 
        {
            print("hoat dong");
            format(str,sizeof(str),"%s\n%s\t%s\t$%s",str,company_name[i],truck_nameitem[i],FormatNumber(truck_pricebuyitem[i]));
        }
        printf("%s",str);
        Dialog_Show(playerid, TRUCK_LAYHANG, DIALOG_STYLE_TABLIST_HEADERS, "Truck > Dia diem lay hang", str, "Chon", "Quay lai");
    }
    if(listitem == 1) {
        new str[300] = "Name\tLoai hang\tGia thu mua";
        for(new i = 1; i < 5 ; i++) 
        {
            format(str,sizeof(str),"%s\n%s\t%s\t$%s",str,company_name[i],truck_nameitem[i],FormatNumber(truck_pricesellitem[i]));
        }
        printf("%s",str);
        Dialog_Show(playerid, TRUCK_BANHANG, DIALOG_STYLE_TABLIST_HEADERS, "Truck > Dia diem lay hang", str, "Chon", "Quay lai");
    }
    return 1;	
}
Dialog:LIST_TRUCKER(playerid, response, listitem, inputtext[])
{
    new string[129];
    new vehicle = GetPVarInt(playerid, "NearVehicle");
	if (!response)						return 1;
    if (IsPlayerAttachedObjectSlotUsed(playerid, ATTACH_HANDS) || ThungHang[playerid] != 0 )	return SendErrorMessage(playerid, "Tay cua ban dang cam thu gi do.");
    SetPlayerAttachedObject(playerid, ATTACH_HANDS, 2912, 5, 0.102000, 0.306000, -0.228999, -1.100001, 14.499999, -1.300000, 1.000000, 1.000000, 1.000000);
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    format(string,sizeof(string),"(TRUCK) Ban da lay thung hang %s ra khoi xe.",truck_nameitem[VehicleInfo[vehicle][TruckThungHangCar][listitem]]);
    SendClientMessage(playerid,COLOR_YELLOW,string);
    ThungHang[playerid] = VehicleInfo[vehicle][TruckThungHangCar][listitem];
    VehicleInfo[vehicle][TruckThungHangCar][listitem] = 0;
    DeletePVar(playerid, "NearVehicle");
    return 1;
}
stock trucker2_OnGameModeInit() {
    new string[129];
    //  mac dinh gia
    truck_pricebuyitem[1] = 200;
    truck_pricebuyitem[2] = 200;
    truck_pricebuyitem[3] = 200;
    truck_pricebuyitem[4] = 200;
    truck_pricesellitem[1] = 350;
    truck_pricesellitem[2] = 350;
    truck_pricesellitem[3] = 350;
    truck_pricesellitem[4] = 350;
    for(new i = 1; i < 5; i++) {
        format(string,sizeof(string),"Noi phan phoi hang %s | gia ban: $%s",truck_nameitem[i],FormatNumber(truck_pricebuyitem[i]));
        p_pricebuyitem[i] = CreateDynamic3DTextLabel(string, COLOR_WHITE, Pos_buyitem[i][0], Pos_buyitem[i][1],Pos_buyitem[i][2],30);
    }
    for(new i = 1; i < 5; i++) {
        format(string,sizeof(string),"Noi phan nhap hang %s | gia thu mua: $%s",truck_nameitem[i],FormatNumber(truck_pricesellitem[i]));
        p_pricesellitem[i] = CreateDynamic3DTextLabel(string, COLOR_WHITE, Pos_sellitem[i][0], Pos_sellitem[i][1],Pos_sellitem[i][2],30);
    }
    TimerCountSP = DEFAULT_TIME_TRUCKGIA; // 2 30s = 60s
    TimerCountSPSell = DEFAULT_TIME_TRUCKGIA2;
    TimerSP = SetTimerEx("GiaSanPhamThayDoi", 30000, true, "d", 0);

}
 // 30 x 2s 
forward GiaSanPhamThayDoi(ig);
public GiaSanPhamThayDoi(ig) {
    TimerCountSP--;
    TimerCountSPSell--;
    if(TimerCountSP <= 0) {
        new string[129];
        TimerCountSP = DEFAULT_TIME_TRUCKGIA; // 2?
        UpdateNewGia();
        for(new i = 1; i < 5; i++) {
            format(string,sizeof(string),"Noi phan phoi hang %s | gia ban: $%s",truck_nameitem[i],FormatNumber(truck_pricebuyitem[i]));
            UpdateDynamic3DTextLabelText(p_pricebuyitem[i],COLOR_WHITE, string);
        }
        for(new i = 1; i < 5; i++) {
            format(string,sizeof(string),"Noi phan nhap hang %s | gia thu mua: $%s",truck_nameitem[i],FormatNumber(truck_pricesellitem[i]));
            UpdateDynamic3DTextLabelText(p_pricesellitem[i],COLOR_WHITE, string);
        }
    }
    if(TimerCountSPSell <= 0) {
        new string[129];
        TimerCountSPSell = DEFAULT_TIME_TRUCKGIA; // 2?
        UpdateNewGiaSell();
        for(new i = 1; i < 5; i++) {
            format(string,sizeof(string),"Noi phan phoi hang %s | gia ban: $%s",truck_nameitem[i],FormatNumber(truck_pricebuyitem[i]));
            UpdateDynamic3DTextLabelText(p_pricebuyitem[i],COLOR_WHITE, string);
        }
        for(new i = 1; i < 5; i++) {
            format(string,sizeof(string),"Noi phan nhap hang %s | gia thu mua: $%s",truck_nameitem[i],FormatNumber(truck_pricesellitem[i]));
            UpdateDynamic3DTextLabelText(p_pricesellitem[i],COLOR_WHITE, string);
        }
    }
    return true;
}
stock UpdateNewGiaSell() {
    // gia giao 
    new string[129];
    switch(random(10))  {
        case 0..5: { // tang
            if(truck_pricesellitem[1] >= 700 ) {
                truck_pricesellitem[1] -= 2;
                format(string,sizeof(string),"[Market News] gia thu mua xang da giam nhe $%d so voi gia truoc, ( muc gia hien tai: $%d, gia truoc $%d ) ",2
                , truck_pricesellitem[1] , truck_pricesellitem[1] +  2);
                SendClientMessageToAllTogT(string);
                return 1;
            }
            new giatang = 1 + random(20);
            truck_pricesellitem[1] += giatang;
            format(string,sizeof(string),"[Market News] gia thu mua xang da tang $%d so voi gia truoc, ( muc gia hien tai: $%d, gia truoc $%d ) ",giatang
            , truck_pricesellitem[1] , truck_pricesellitem[1] -  giatang);
            SendClientMessageToAllTogT(string);

        }
        case 6..10: { // giam
            if(truck_pricesellitem[1] <= 100 ) {
                truck_pricesellitem[1] += 3;
                format(string,sizeof(string),"[Market News] gia thu mua xang da tang nhe $%d so voi gia truoc, ( muc gia hien tai: $%d, gia truoc $%d ) ",3
                , truck_pricesellitem[1] , truck_pricesellitem[1] -  3);
                SendClientMessageToAllTogT(string);
                return 1;
            }
            new giagiam = 1 + random(20);
            truck_pricesellitem[1] -= giagiam;
            format(string,sizeof(string),"[Market News] gia thu mua xang da giam $%d so voi gia truoc, ( muc gia hien tai: $%d, gia truoc $%d ) ",giagiam
            , truck_pricesellitem[1] , truck_pricesellitem[1] +  giagiam);
            SendClientMessageToAllTogT(string);
        }
    }  
    switch(random(10))  {
        case 0..5: { // tang
            if(truck_pricesellitem[2] >= 700 ) {
                truck_pricesellitem[2] -= 2;
                format(string,sizeof(string),"[Market News] gia thu mua vat lieu da giam nhe $%d so voi gia truoc, ( muc gia hien tai: $%d, gia truoc $%d ) ",2
                , truck_pricesellitem[2] , truck_pricesellitem[2] +  2);
                SendClientMessageToAllTogT(string);
                return 1;
            }
            new giatang = 1 + random(20);
            truck_pricesellitem[2] += giatang;
            format(string,sizeof(string),"[Market News] gia thu mua vat lieu da tang $%d so voi gia truoc, ( muc gia hien tai: $%d, gia truoc $%d ) ",giatang
            , truck_pricesellitem[2] , truck_pricesellitem[2] -  giatang);
            SendClientMessageToAllTogT(string);

        }
        case 6..10: { // giam
            if(truck_pricesellitem[2] <= 100 ) {
                truck_pricesellitem[2] += 3;
                format(string,sizeof(string),"[Market News] gia thu mua vat lieu da tang nhe $%d so voi gia truoc, ( muc gia hien tai: $%d, gia truoc $%d ) ",3
                , truck_pricesellitem[2] , truck_pricesellitem[2] -  3);
                SendClientMessageToAllTogT(string);
                return 1;
            }
            new giagiam = 1 + random(20);
            truck_pricesellitem[2] -= giagiam;
            format(string,sizeof(string),"[Market News] gia thu mua vat lieu da giam $%d so voi gia truoc, ( muc gia hien tai: $%d, gia truoc $%d ) ",giagiam
            , truck_pricesellitem[2] , truck_pricesellitem[2] +  giagiam);
            SendClientMessageToAllTogT(string);
        }
    }  
    switch(random(10))  {
        case 0..5: { // tang
            if(truck_pricesellitem[3] >= 700 ) {
                truck_pricesellitem[3] -= 2;
                format(string,sizeof(string),"[Market News] gia thu mua thuc pham da giam nhe $%d so voi gia truoc, ( muc gia hien tai: $%d, gia truoc $%d ) ",2
                , truck_pricesellitem[3] , truck_pricesellitem[3] +  2);
                SendClientMessageToAllTogT(string);
                return 1;
            }
            new giatang = 1 + random(20);
            truck_pricesellitem[3] += giatang;
            format(string,sizeof(string),"[Market News] gia thu mua thuc pham da tang $%d so voi gia truoc, ( muc gia hien tai: $%d, gia truoc $%d ) ",giatang
            , truck_pricesellitem[3] , truck_pricesellitem[3] -  giatang);
            SendClientMessageToAllTogT(string);

        }
        case 6..10: { // giam
            if(truck_pricesellitem[3] <= 100 ) {
                truck_pricesellitem[3] += 3;
                format(string,sizeof(string),"[Market News] gia thu mua thuc pham da tang nhe $%d so voi gia truoc, ( muc gia hien tai: $%d, gia truoc $%d ) ",3
                , truck_pricesellitem[3] , truck_pricesellitem[3] -  3);
                SendClientMessageToAllTogT(string);
                return 1;
            }
            new giagiam = 1 + random(20);
            truck_pricesellitem[3] -= giagiam;
            format(string,sizeof(string),"[Market News] gia thu mua thuc pham da giam $%d so voi gia truoc, ( muc gia hien tai: $%d, gia truoc $%d ) ",giagiam
            , truck_pricesellitem[3] , truck_pricesellitem[3] +  giagiam);
            SendClientMessageToAllTogT(string);
        }
    }  
    switch(random(10))  {
        case 0..5: { // tang
            if(truck_pricesellitem[4] >= 700 ) {
                truck_pricesellitem[4] -= 2;
                format(string,sizeof(string),"[Market News] gia thu mua vu khi da giam nhe $%d so voi gia truoc, ( muc gia hien tai: $%d, gia truoc $%d ) ",2
                , truck_pricesellitem[4] , truck_pricesellitem[4] +  2);
                SendClientMessageToAllTogT(string);
                return 1;
            }
            new giatang = 1 + random(20);
            truck_pricesellitem[4] += giatang;
            format(string,sizeof(string),"[Market News] gia thu mua vu khi da tang $%d so voi gia truoc, ( muc gia hien tai: $%d, gia truoc $%d ) ",giatang
            , truck_pricesellitem[4] , truck_pricesellitem[4] -  giatang);
            SendClientMessageToAllTogT(string);

        }
        case 6..10: { // giam
            if(truck_pricesellitem[4] <= 100 ) {
                truck_pricesellitem[4] += 3;
                format(string,sizeof(string),"[Market News] gia thu mua vu khi da tang nhe $%d so voi gia truoc, ( muc gia hien tai: $%d, gia truoc $%d ) ",3
                , truck_pricesellitem[4] , truck_pricesellitem[4] -  3);
                SendClientMessageToAllTogT(string);
                return 1;
            }
            new giagiam = 1 + random(20);
            truck_pricesellitem[4] -= giagiam;
            format(string,sizeof(string),"[Market News] gia thu mua vu khi da giam $%d so voi gia truoc, ( muc gia hien tai: $%d, gia truoc $%d ) ",giagiam
            , truck_pricesellitem[4] , truck_pricesellitem[4] +  giagiam);
            SendClientMessageToAllTogT(string);
        }
    }  
    return 1;
}
stock UpdateNewGia() {
    new string[129];
    switch(random(2))  {
        case 0..5: { // tang
            printf("gia xang %d",truck_pricebuyitem[1]);
            if(truck_pricebuyitem[1] >= 700 ) {
                truck_pricebuyitem[1] -= 2;
                format(string,sizeof(string),"[Market News] gia ban xang da giam nhe $%d so voi gia truoc, ( muc gia hien tai: $%d, gia truoc $%d ) ",2
                , truck_pricebuyitem[1] , truck_pricebuyitem[1] +  2);
                SendClientMessageToAllTogT(string);
                printf("%d",truck_pricebuyitem[1]);
                return 1;
                
            }
            new giatang = 1 + random(20);
            truck_pricebuyitem[1] += giatang;
            format(string,sizeof(string),"[Market News] gia ban xang da tang $%d so voi gia truoc, ( muc gia hien tai: $%d, gia truoc $%d ) ",giatang
            , truck_pricebuyitem[1] , truck_pricebuyitem[1] -  giatang);
            SendClientMessageToAllTogT(string);
        }
        case 6..10: { // giam
            printf("gia xang %d",truck_pricebuyitem[1]);
            if(truck_pricebuyitem[1] <= 100 ) {
                truck_pricebuyitem[1] += 3;
                format(string,sizeof(string),"[Market News] gia ban xang da tang nhe $%d so voi gia truoc, ( muc gia hien tai: $%d, gia truoc $%d ) ",3
                , truck_pricebuyitem[1] , truck_pricebuyitem[1] -  3);
                SendClientMessageToAllTogT(string);
                return 1;
            }
            new giagiam = 1 + random(20);
            truck_pricebuyitem[1] -= giagiam;
            format(string,sizeof(string),"[Market News] gia ban xang da giam $%d so voi gia truoc, ( muc gia hien tai: $%d, gia truoc $%d ) ",giagiam
            , truck_pricebuyitem[1] , truck_pricebuyitem[1] +  giagiam);
            SendClientMessageToAllTogT(string);
        }
    }
    switch(random(10))  
    {
        case 0..5: { // tang
            printf("gia tp %d",truck_pricebuyitem[2]);
            if(truck_pricebuyitem[2] >= 700 ) {
                truck_pricebuyitem[2] -= 2;
                format(string,sizeof(string),"[Market News] gia ban vat lieu da giam nhe $%d so voi gia truoc, ( muc gia hien tai: $%d, gia truoc $%d ) ",2
                , truck_pricebuyitem[2] , truck_pricebuyitem[2] +  2);
                SendClientMessageToAllTogT(string);
                return 1;
            }
            new giatang = 1 + random(20);
            truck_pricebuyitem[2] += giatang;
            format(string,sizeof(string),"[Market News] gia ban vat lieu da tang $%d so voi gia truoc, ( muc gia hien tai: $%d, gia truoc $%d ) ",giatang
            , truck_pricebuyitem[2] , truck_pricebuyitem[2] -  giatang);
            SendClientMessageToAllTogT(string);

        }
        case 6..10: { // giam
            printf("gia tp %d",truck_pricebuyitem[2]);
            if(truck_pricebuyitem[2] <= 100 ) {
                truck_pricebuyitem[2] += 3;
                format(string,sizeof(string),"[Market News] gia ban vat lieu da tang nhe $%d so voi gia truoc, ( muc gia hien tai: $%d, gia truoc $%d ) ",3
                , truck_pricebuyitem[2] , truck_pricebuyitem[2] -  3);
                SendClientMessageToAllTogT(string);
                return 1;
            }
            new giagiam = 1 + random(20);
            truck_pricebuyitem[2] -= giagiam;
            format(string,sizeof(string),"[Market News] gia ban vat lieu da giam $%d so voi gia truoc, ( muc gia hien tai: $%d, gia truoc $%d ) ",giagiam
            , truck_pricebuyitem[2] , truck_pricebuyitem[2] +  giagiam);
            SendClientMessageToAllTogT(string);
        }
    }  
    switch(random(10))  {
        case 0..5: { // tang
            if(truck_pricebuyitem[3] >= 700 ) {
                truck_pricebuyitem[3] -= 2;
                format(string,sizeof(string),"[Market News] gia ban thuc pham da giam nhe $%d so voi gia truoc, ( muc gia hien tai: $%d, gia truoc $%d ) ",2
                , truck_pricebuyitem[3] , truck_pricebuyitem[3] +  2);
                SendClientMessageToAllTogT(string);
                return 1;
            }
            new giatang = 1 + random(20);
            truck_pricebuyitem[3] += giatang;
            format(string,sizeof(string),"[Market News] gia ban thuc pham da tang $%d so voi gia truoc, ( muc gia hien tai: $%d, gia truoc $%d ) ",giatang
            , truck_pricebuyitem[3] , truck_pricebuyitem[3] -  giatang);
            SendClientMessageToAllTogT(string);

        }
        case 6..10: { // giam
            if(truck_pricebuyitem[3] <= 100 ) {
                truck_pricebuyitem[3] += 3;
                format(string,sizeof(string),"[Market News] gia ban thuc pham da tang nhe $%d so voi gia truoc, ( muc gia hien tai: $%d, gia truoc $%d ) ",3
                , truck_pricebuyitem[3] , truck_pricebuyitem[3] -  3);
                SendClientMessageToAllTogT(string);
                return 1;
            }
            new giagiam = 1 + random(20);
            truck_pricebuyitem[3] -= giagiam;
            format(string,sizeof(string),"[Market News] gia ban thuc pham da giam $%d so voi gia truoc, ( muc gia hien tai: $%d, gia truoc $%d ) ",giagiam
            , truck_pricebuyitem[3] , truck_pricebuyitem[3] +  giagiam);
            SendClientMessageToAllTogT(string);
        }
    }  
    switch(random(10))  {
        case 0..5: { // tang
            if(truck_pricebuyitem[4] >= 700 ) {
                truck_pricebuyitem[4] -= 2;
                format(string,sizeof(string),"[Market News] gia ban vu khi da giam nhe $%d so voi gia truoc, ( muc gia hien tai: $%d, gia truoc $%d ) ",2
                , truck_pricebuyitem[4] , truck_pricebuyitem[4] +  2);
                SendClientMessageToAllTogT(string);
                return 1;
            }
            new giatang = 1 + random(20);
            truck_pricebuyitem[4] += giatang;
            format(string,sizeof(string),"[Market News] gia ban vu khi da tang $%d so voi gia truoc, ( muc gia hien tai: $%d, gia truoc $%d ) ",giatang
            , truck_pricebuyitem[4] , truck_pricebuyitem[4] -  giatang);
            SendClientMessageToAllTogT(string);

        }
        case 6..10: { // giam
            if(truck_pricebuyitem[4] <= 100 ) {
                truck_pricebuyitem[4] += 3;
                format(string,sizeof(string),"[Market News] gia ban vu khi da tang nhe $%d so voi gia truoc, ( muc gia hien tai: $%d, gia truoc $%d ) ",3
                , truck_pricebuyitem[4] , truck_pricebuyitem[4] -  3);
                SendClientMessageToAllTogT(string);
                return 1;
            }
            new giagiam = 1 + random(20);
            truck_pricebuyitem[4] -= giagiam;
            format(string,sizeof(string),"[Market News] gia ban vu khi da giam $%d so voi gia truoc, ( muc gia hien tai: $%d, gia truoc $%d ) ",giagiam
            , truck_pricebuyitem[4] , truck_pricebuyitem[4] +  giagiam);
            SendClientMessageToAllTogT(string);
        }
    }  

    
    return 1;
}
stock SendClientMessageToAllTogT(string[]) {
    foreach(new i: Player) {
        if(OpenGiaTruck[i] == true) {
            SendClientMessage(i,-1,string);
        }
    }
    return 1;
}
Truck_Onplayerconnect(playerid) {
    OpenGiaTruck[playerid] = false;
    ThungHang[playerid] = 0;
    if (IsPlayerAttachedObjectSlotUsed(playerid, ATTACH_HANDS))	RemovePlayerAttachedObject(playerid, ATTACH_HANDS);
  	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
    
}
// 	499
