#define MAX_ITEM_TRUCK 5
#define MAX_TRUCKCAR_SLOT 5 // toi da 5 thung hang
#define LIST_TRUCKER 15021
new truck_nameitem[MAX_ITEM_TRUCK][32] = {
	"Empty",
    "Xang",
	"Nguyen lieu",
	"Thuc pham",
	"Vu khi nhe"
};
new Float:Pos_buyitem[MAX_ITEM_TRUCK][3] = {
    {0,0,0}, // post de lay hang xang
    {2657.9153,-2114.8289,13.5469}, // post de lay hang xang
    {2164.9043,-2308.2195,13.5469}, // post de lay nguyen lieu
    {1751.3557,-2056.2791,13.8428}, // post de lay thuc pham
    {2785.4036,-2418.3857,13.6342} // post de lay vu khi
};
new Float:Pos_buyitem[MAX_ITEM_TRUCK][3] = {
    {0,0,0}, // post de lay hang xang
    {2639.5361,1114.9008,10.8203}, // post de lay hang xang
    {-1869.5895,1415.1965,7.1850}, // post de lay nguyen lieu
    {-1460.0431,-628.5864,14.1484}, // post de lay thuc pham
    {2293.8582,2738.7275,10.8203} // post de lay vu khi
};
new Float:PostSpamXeTruck[4] = { 0,0,0,0};
new truck_priceitem[MAX_ITEM_TRUCK] = {
    0, // item 0
    100, // xang
    200, // nguyen lieu
    200, // thuc pham
    300 // vu khi nhe
};
new ThungHang[MAX_PLAYERS],
    TruckCarRent[MAX_PLAYERS];
 // DestroyVehicle(vehid);
CMD:truck(playerid,params[])
{

	new option[30];

	if (sscanf(params, "s[30]", option))
	{
		SendHelpMessage(playerid, "/truck [thuexe / traxe / muahang / layhang / chathang / giaohang]");
		return 1;
	}
  /*  if (CompareStrings(option, "traxe"))
	{
        if(TruckCarRent[playerid] != INVALID_VEHICLE_ID ) return SendClientMessage(playerid, COLOR_GREY,"Ban da thue xe roi khong the thue tiep.");
        if (!pTemp[playerid][pRentveh]) return 1;
        new vehicle = pTemp[playerid][pRentveh];
        SendSyntaxMessage(playerid, "Ban da cham dut hop dong thue phuong tien %s.", VehicleNames[GetVehicleModel(vehicle)-400]);
	    pTemp[playerid][pRentveh] = 0;
        TruckCarRent[playerid] = 0;
        VehicleInfo[vehicle][carRent] = 0;
        DestroyVehicle(vehicle);
    }
    if (CompareStrings(option, "thuexe"))
	{
        if(TruckCarRent[playerid] != INVALID_VEHICLE_ID) return SendClientMessage(playerid, COLOR_GREY,"Ban da thue xe roi khong the thue tiep.");
        if (pTemp[playerid][pRentveh])		return SendErrorMessage(playerid, "Ban da thue mot phuong tien. Nhap /unrentcar de ket thuc thue. ");
        new Float:x,Float:y,Float:z,Float:a;
        x = PostSpamXeTruck[0],y = PostSpamXeTruck[1],z = PostSpamXeTruck[2],a = PostSpamXeTruck[3];
        new vehicle =  CreateVehicle(499, x, y, z, a, 1, 1, -1);;
        SetVehicleHealth(vehicle, 1000.0);
        new str[12];
        format(str,sizeof(str),"TR-%d",playerid);
	    SetVehicleNumberPlate(vehicle, str);
 	    SetVehicleVirtualWorldEx(vehicle, 0);
	    SetVehicleInteriorEx(vehicle, 0);
    
	    VehicleInfo[vehicle][carModel] = 499;
	    VehicleInfo[vehicle][carParkX] = x;
	    VehicleInfo[vehicle][carParkY] = y;
	    VehicleInfo[vehicle][carParkZ] = z;
	    VehicleInfo[vehicle][carParkA] = a;
	    VehicleInfo[vehicle][carColor1] = 1;
	    VehicleInfo[vehicle][carColor2] = 1;
	    VehicleInfo[vehicle][carVW] = 0;
	    VehicleInfo[vehicle][carInt] = 0;
        VehicleInfo[vehicle][carFuel] = 1000;
        VehicleInfo[vehicle][carDriver] = INVALID_PLAYER_ID;
	    VehicleInfo[vehicle][carOwnerID] = 0;

        TruckCarRent[playerid] = vehicle;
        pTemp[playerid][pRentveh] = vehicle;
	    VehicleInfo[vehicle][carRent] = PlayerInfo[playerid][pID];

    }*/
	if (CompareStrings(option, "muahang"))
	{
        if( ThungHang[playerid] != 0) return SendClientMessage(playerid,"Ban dang cam mot thung hang khac tren tay.");
        for(new i = 1; i < MAX_ITEM_TRUCK;i++) {
            if(!IsPlayerInRangeOfPoint(playerid, 5, Pos_buyitem[i][0],Pos_buyitem[i][1],Pos_buyitem[i][2])) return SendClientMessage(playerid,-1,"Ban khong o gan bat ki noi nhap hang nao.");
            if (IsPlayerAttachedObjectSlotUsed(playerid, ATTACH_HANDS) || ThungHang[playerid] != 0 )	return SendErrorMessage(playerid, "Tay cua ban dang cam thu gi do.");
            SetPlayerAttachedObject(playerid, ATTACH_HANDS, 2912, 5, 0.102000, 0.306000, -0.228999, -1.100001, 14.499999, -1.300000, 1.000000, 1.000000, 1.000000);
            SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
            ThungHang[playerid] = i;
            GiveCash(playerid, truck_priceitem[i]);
            new string[129];
            format(string,sizeof(string),"Ban da lay thung hang %s voi gia %d$",truck_nameitem[i],truck_priceitem[i]);
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
        if (VehicleInfo[vehicle][carOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Ban khong so huu phuong tien nay.");
        new stringdialog[320] = "{9ACD32}San pham\t{9ACD32}Gia nhap";
        for(new i = 0; i < MAX_TRUCKCAR_SLOT; i++) {
            format(string,sizeof(stringdialog),"%s\n%s\t%d",stringdialog,truck_nameitem[VehicleInfo[vehicle][TruckThungHangCar][i]],truck_priceitem[VehicleInfo[vehicle][TruckThungHangCar][i]]);
        }
        SetPVarInt(playerid, "NearVehicle", vehicleid);
        Dialog_Show(playerid, LIST_TRUCKER, DIALOG_STYLE_TABLIST_HEADERS, "Hang tren xe", stringdialog, "Lay ra", "Thoat");
    }
    if (CompareStrings(option, "chathang"))
	{
        new vehicleid;
        if((vehicleid = GetNearBootVehicle(playerid)) == 0) return SendClientMessage(playerid,COLOR_GREY,"Ban khong o gan mot chiec xe nao ca."); 
        if(GetVehicleModel(vehicleid) != 499) return SendClientMessage(playerid,COLOR_GREY,"Phuong tien nay khong phai phuong tien van chuyen.");
        if (VehicleInfo[vehicle][carOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "Ban khong so huu phuong tien nay.");
        if(ThungHang[playerid] == 0) return return SendClientMessage(playerid,COLOR_GREY,"Tren tay ban khong cam mot thung hang.");
        new taihang = -1;
        for(new i = 0; i < MAX_TRUCKCAR_SLOT; i++) {
            if( VehicleInfo[vehicle][TruckThungHangCar][i] == 0) {
                taihang = i;
                SendClientMessage(playerid,COLOR_GREY,"[TRUCK] Ban da dat thung hang len xe truck thanh cong.");
                VehicleInfo[vehicle][TruckThungHangCar][i] = ThungHang[playerid];
                ThungHang[playerid] = 0;
                if (IsPlayerAttachedObjectSlotUsed(playerid, ATTACH_HANDS))	RemovePlayerAttachedObject(playerid, ATTACH_HANDS);
  		        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
                break;
            }
            else if( taihang == -1) return {
                SendClientMessage(playerid,COLOR_GREY,"[TRUCK] Ban khong con cho trong tren xe."); 
                break;
            }
        }
        return 1;
    }
    return 1;
}
Dialog:CargoList(playerid, response, listitem, inputtext[])
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
hook OnGameModeInit() {
    CreateDynamic3DTextLabel("const text[]", color, Float:x, Float:y, Float:z, Float:drawdistance, attachedplayer = INVALID_PLAYER_ID, attachedvehicle = INVALID_VEHICLE_ID, testlos = 0, worldid = -1, interiorid = -1, playerid = -1, Float:streamdistance = STREAMER_3D_TEXT_LABEL_SD, STREAMER_TAG_AREA areaid = STREAMER_TAG_AREA -1, priority = 0)
    TimerCountSP = 2; // 2 30s = 60s
    TimerSP = SetTimerEx("GiaSanPhamThayDoi", 30000, true, "d", 0);
}
forward GiaSanPhamThayDoi(ig);
public GiaSanPhamThayDoi(ig) {
    TimerCountSP--;
    if(TimerCountSP <= 0) {
        TimerCountSP = 2; // 2?
        
    }
}
// 	499
