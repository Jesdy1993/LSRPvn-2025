#define MAX_SELLER_CREATE 200
enum shipment_bitem {
	item_category,
	item_name[32]
}
new sb_info[][shipment_bitem] = {
	{0,"Trong"},
	{1,"Thit"},
	{1,"Thit bo"},
	{1,"Thit heo"},
	{1,"Thit de"},
	{1,"Lua mach"},
	{1,"Bap ngo"},
	{1,"Dua leo"},
	{1,"Bap cai"},
	{2,"Nhien lieu"},
	{2,"Vo xe"},
	{2,"Linh kien oto"},
	{2,"Banh xe"},
	{2,"Dong co xe"},
	{2,"Sat vun"},
	{2,"Phe lieu xe oto"},
	{3,"Giay to"},
	{3,"Thiet bi gia dung"},
	{4,"Do an nhanh"},
	{4,"Do an dong hop"},
	{4,"Nuoc dong hop"},
	{4,"Nuoc ep dong hop"},
	{5,"Quan ao"},
	{5,"Giay dep"},
	{5,"Quan ao 2 hand"}
};
new sb_category[][] = {
	{"Trong"},
    {"Nong san"},
    {"Linh kien oto"},
    {"Nhu yeu pham"},
    {"Thuc pham"},
    {"Quan ao"}
};

new companybuyname[][] = {
	{"Empty"},
	{"Meat Restaurant"},
	{"B Restaurant"},
	{"PI. Restaurant"},
	{"ST. Restaurant"},
	{"A. Store"},
	{"A. Store"},
	{"A. Store"},
	{"A. Store"},
	{"Gas station"},
	{"Workshop"},
	{"Repair Shop"},
	{"Repair Shop"},
	{"Repair Shop"},
	{"Store"},
	{"Store"},
	{"Store"},
	{"Store"},
	{"Restaurant"},
	{"Restaurant"},
	{"Restaurant"},
	{"Restaurant"},
	{"Clothing store"},
	{"Clothing store"},
	{"Clothing store"}
};
new companysellname[][] = {
	{"Empty"},
	{"Meat Factory"},
	{"Beef Factory"},
	{"pig Factory"},
	{"Goat Factory"},
	{"Paddy Farm"},
	{"Corn Farm"},
	{"Farm"},
	{"Farm"},
	{"Fuel Station"},
	{"components Company"},
	{"Garage"},
	{"Garage"},
	{"Garage"},
	{"components .co"},
	{"components .co"},
	{"Paper .co"},
	{"components . co"},
	{"Food"},
	{"Food"},
	{"Food & Water"},
	{"Food & Water"},
	{"Clothes"},
	{"Shoes"},
	{"2hand Clothes"}
};
enum shipment_buyitem {
	item_company_name[52],
	item_sell_id,
	item_sell_price,
	item_sell_set,
	Float:is_posX,
	Float:is_posY,
	Float:is_posZ,
	itemsell_pickup,
	Text3D:itemsell_text
}
new buy_item_postion[MAX_SELLER_CREATE][shipment_buyitem];

enum shipment_sellitem {
	item_s_id,
	item_s_price,
	item_s_set,
	Float:s_posX,
	Float:s_posY,
	Float:s_posZ,
	items_pickup,
	Text3D:items_text
}
new sell_item_postion[MAX_SELLER_CREATE][shipment_sellitem];

new PlayerShipment[MAX_PLAYERS];

CMD:createbship(playerid,params[]) {
    new string[399];
    for(new i = 0; i < sizeof(sb_info) ; i++) {
    	format(string, sizeof string, "%s\n%s",string, sb_info[i][item_name]);
    }
    Dialog_Show(playerid,DIALOG_CREATEBSHIP,DIALOG_STYLE_LIST,"Create BSHIP",string, "Tao","Thoat");
    return 1;
}
    
CMD:createaship(playerid,params[]) {
	new choice;
    if(sscanf(params, "d", choice))
    {
        SendClientMessageEx(playerid, COLOR_CHAT, " {c7d5d8}USE{ffffff}: /shipment [tuy chon]");
        SendClientMessageEx(playerid, COLOR_WHITE, "{c7d5d8}OPTION{ffffff}: 0-24");
        return 1;
    }
    for(new i = 0 ; i < MAX_SELLER_CREATE; i++) {
    	if(buy_item_postion[i][item_sell_set] == 0) {
    		buy_item_postion[i][item_sell_set] = 1;
    		new Float:x,Float:y,Float:z,zone[32],string[529];
    		GetPlayerPos(playerid, x,y,z);
    		buy_item_postion[i][is_posX] = x;
    		buy_item_postion[i][is_posY] = y;
    		buy_item_postion[i][is_posZ] = z;
    		buy_item_postion[i][item_sell_id] = choice;
    		buy_item_postion[i][item_sell_price] = 100;
    		Get3DZone(x,y,z,zone,32);
    		format(string, sizeof string, "%s %s\nMat hang: {e1e354}%s{cdc3c3} gia tien: {4dbc55}$%s{cdc3c3}\n/shiptment buy de mua", zone,companysellname[buy_item_postion[i][item_sell_id]],sb_info[buy_item_postion[i][item_sell_id]][item_name],number_format(buy_item_postion[i][item_sell_price]));
    		buy_item_postion[i][itemsell_text] = CreateDynamic3DTextLabel(string, COLOR_WHITE2,  x,y,z, 20.0);
    		buy_item_postion[i][itemsell_pickup] = CreateDynamicPickup(1271, 23, x,y,z);

	        format(string, sizeof(string), "INSERT INTO `ashipment` (`ship_id`,`item_sell_set` ,`is_posX`, `is_posY`, `is_posZ`, `item_sell_id`, `item_sell_price`) \
	        	VALUES ('%d','%d','%f', '%f','%f','%d','%d')",i,buy_item_postion[i][item_sell_set],buy_item_postion[i][is_posX],buy_item_postion[i][is_posY],buy_item_postion[i][is_posZ],buy_item_postion[i][item_sell_id],buy_item_postion[i][item_sell_price]);
	        mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);
    		break ;

    	}
    }
    return 1;
}
stock Loadshipemnt()
{
    mysql_function_query(MainPipeline, "SELECT * FROM bshipment", true, "OnLoadBShipment", "");
	mysql_function_query(MainPipeline, "SELECT * FROM ashipment", true, "OnLoadShipment", "");

}

forward OnLoadBShipment(i);
public OnLoadBShipment(i)
{
	new fields, szResult[64],rows,str[129];
	cache_get_data(rows, fields, MainPipeline);

    new string_log[2229];
    format(string_log, sizeof(string_log), "[%s] %d", GetLogTime()); 

    new fid;
	for(new row;row < rows;row++)
	{
		
		cache_get_field_content(row,  "s_id", szResult, MainPipeline); fid = strval(szResult);
		cache_get_field_content(row,  "item_s_set", szResult, MainPipeline); sell_item_postion[fid][item_s_set] = strval(szResult);
		cache_get_field_content(row,  "s_posX", szResult, MainPipeline); sell_item_postion[fid][s_posX] = floatstr(szResult);
		cache_get_field_content(row,  "s_posY", szResult, MainPipeline); sell_item_postion[fid][s_posY]  = floatstr(szResult);
		cache_get_field_content(row,  "s_posZ", szResult, MainPipeline); sell_item_postion[fid][s_posZ]  = floatstr(szResult);
		cache_get_field_content(row,  "item_s_id", szResult, MainPipeline); sell_item_postion[fid][item_s_id]  = strval(szResult);
		cache_get_field_content(row,  "item_s_price", szResult, MainPipeline); sell_item_postion[fid][item_s_price]  = strval(szResult);
		printf(" shipid: %d,%d ",fid ,sell_item_postion[fid][item_s_id]);
        if(sell_item_postion[fid][item_s_set] != 0) {
        	new zone[32],string[129];
            Get3DZone(sell_item_postion[fid][s_posX],sell_item_postion[fid][s_posY],sell_item_postion[fid][s_posZ],zone,32);
    		format(string, sizeof string, "%s %s\nDang thu mua mat hang: {e1e354}%s{cdc3c3} Gia mua: {4dbc55}$%s{cdc3c3}\n/shiptment sell de ban", zone,companysellname[sell_item_postion[fid][item_s_id]],sb_info[sell_item_postion[fid][item_s_id]][item_name],number_format(sell_item_postion[fid][item_s_price]));
    		sell_item_postion[fid][items_text] = CreateDynamic3DTextLabel(string, COLOR_WHITE2,  sell_item_postion[fid][s_posX],sell_item_postion[fid][s_posY],sell_item_postion[fid][s_posZ], 20.0);
    		sell_item_postion[fid][items_pickup] = CreateDynamicPickup(1271, 23,  sell_item_postion[fid][s_posX],sell_item_postion[fid][s_posY],sell_item_postion[fid][s_posZ]);
        }
 
	}        

}
forward OnLoadShipment(i);
public OnLoadShipment(i)
{
	new fields, szResult[64],rows,str[129];
	cache_get_data(rows, fields, MainPipeline);

    new string_log[2229];
    format(string_log, sizeof(string_log), "[%s] %d", GetLogTime()); 

    new fid;
	for(new row;row < rows;row++)
	{
		
		cache_get_field_content(row,  "ship_id", szResult, MainPipeline); fid = strval(szResult);
		cache_get_field_content(row,  "item_sell_set", szResult, MainPipeline); buy_item_postion[fid][item_sell_set] = strval(szResult);
		cache_get_field_content(row,  "is_posX", szResult, MainPipeline); buy_item_postion[fid][is_posX] = floatstr(szResult);
		cache_get_field_content(row,  "is_posY", szResult, MainPipeline); buy_item_postion[fid][is_posY]  = floatstr(szResult);
		cache_get_field_content(row,  "is_posZ", szResult, MainPipeline); buy_item_postion[fid][is_posZ]  = floatstr(szResult);
		cache_get_field_content(row,  "item_sell_id", szResult, MainPipeline); buy_item_postion[fid][item_sell_id]  = strval(szResult);
		cache_get_field_content(row,  "item_sell_price", szResult, MainPipeline); buy_item_postion[fid][item_sell_price]  = strval(szResult);
		printf(" shipid: %d,%d ",fid ,buy_item_postion[fid][item_sell_id]);
        if(buy_item_postion[fid][item_sell_set] != 0) {
        	new zone[32],string[129];
            Get3DZone(buy_item_postion[fid][is_posX],buy_item_postion[fid][is_posY],buy_item_postion[fid][is_posZ],zone,32);
    		format(string, sizeof string, "%s %s\nMat hang: {e1e354}%s{cdc3c3} gia tien: {4dbc55}$%s{cdc3c3}\n/shiptment buy de mua", zone,companysellname[buy_item_postion[fid][item_sell_id]],sb_info[buy_item_postion[fid][item_sell_id]][item_name],number_format(buy_item_postion[fid][item_sell_price]));
    		buy_item_postion[fid][itemsell_text] = CreateDynamic3DTextLabel(string, COLOR_WHITE2,  buy_item_postion[fid][is_posX],buy_item_postion[fid][is_posY],buy_item_postion[fid][is_posZ], 20.0);
    		buy_item_postion[fid][itemsell_pickup] = CreateDynamicPickup(1271, 23,  buy_item_postion[fid][is_posX],buy_item_postion[fid][is_posY],buy_item_postion[fid][is_posZ]);
        }
 
	}        
}
CMD:shipment(playerid, params[])
{
    new choice[32];
    if(sscanf(params, "s[32]", choice))
    {
        SendClientMessageEx(playerid, COLOR_CHAT, " {c7d5d8}USE{ffffff}: /shipment [tuy chon]");
        SendClientMessageEx(playerid, COLOR_WHITE, "{c7d5d8}OPTION{ffffff}: load , buy , listsell, listbuy");
        return 1;
    }
    if(strcmp(choice,"listsell",true) == 0) {
    	new string[8000],zone[32];
    	string = "Cong ty\tMat hang\tGia ban\n";
    	for(new i = 0 ; i < MAX_SELLER_CREATE; i++) {
    		if(sell_item_postion[i][item_s_set] != 0) {
    			new item = sell_item_postion[i][item_s_id];
    			Get3DZone(sell_item_postion[i][s_posX],sell_item_postion[i][s_posY],sell_item_postion[i][s_posZ],zone,32);
    			format(string,sizeof(string),"%s%s %s\t%s\t$%s\n",string,zone,companysellname[item],sb_info[item][item_name],number_format( sell_item_postion[i][item_s_price] ));

    		}
    	}
    	Dialog_Show(playerid, DIALOG_SHIPMENTS_FIND, DIALOG_STYLE_TABLIST_HEADERS, "Shipment #BuyList", string, "Dinh vi", "Thoat");
    }
    if(strcmp(choice,"listbuy",true) == 0) {
    	new string[8000],zone[32];
    	string = "Cong ty\tMat hang\tGia ban\n";
    	for(new i = 0 ; i < MAX_SELLER_CREATE; i++) {
    		if(buy_item_postion[i][item_sell_set] != 0) {
    			new item = buy_item_postion[i][item_sell_id];
    			Get3DZone(buy_item_postion[i][is_posX],buy_item_postion[i][is_posY],buy_item_postion[i][is_posZ],zone,32);
    			format(string,sizeof(string),"%s%s %s\t%s\t$%s\n",string,zone,companysellname[item],sb_info[item][item_name],number_format( buy_item_postion[i][item_sell_price] ));

    		}
    	}
    	Dialog_Show(playerid, DIALOG_SHIPMENT_FIND, DIALOG_STYLE_TABLIST_HEADERS, "Shipment #BuyList", string, "Dinh vi", "Thoat");
    }
    if(strcmp(choice,"buy",true) == 0) {
        if(PlayerShipment[playerid] != 0) return SendErrorMessage(playerid, " Ban dang cam thung hang khac tren tay roi.");
	    for(new i = 0 ; i < MAX_SELLER_CREATE; i++) {
	    	if(buy_item_postion[i][item_sell_set] != 0 && IsPlayerInRangeOfPoint(playerid, 5, buy_item_postion[i][is_posX],buy_item_postion[i][is_posY],buy_item_postion[i][is_posZ])) {
	    		if(PlayerInfo[playerid][pCash] < buy_item_postion[i][item_sell_price]) return SendErrorMessage(playerid, " Ban khong du tien de mua mat hang nay.");
	    		PlayerInfo[playerid][pCash] -= buy_item_postion[i][item_sell_price];
	    		new string[129];
	    		new item = buy_item_postion[i][item_sell_id];
    
	    		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
	            SetPlayerAttachedObject( playerid, 1, 1271, 1, 0.002953, 0.469660, -0.009797, 269.851104, 88.443557, 0.000000, 0.804894, 1.000000, 0.822361 );  
    
    
	    		PlayerShipment[playerid] = item;
    
	    		new zone[32];
	    		Get3DZone(buy_item_postion[i][is_posX],buy_item_postion[i][is_posY],buy_item_postion[i][is_posZ],zone,32);
	    		format(string, sizeof string, "[SHIPMENT] Ban da mua mat hang %s tai %s %s.", sb_info[item][item_name],zone,companysellname[item]);
	    		SendClientMessage(playerid,COLOR_WHITE2,string);
	    		return 1;
	    	}
	    }
	}
    if(strcmp(choice,"load",true) == 0) {
        if(IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "Ban khong o gan phuong tien.");


	    new string[528],veh=-1,v;
	    for(new i = 0 ; i < MAX_VEHICLES ; i++) {
	    	if(IsValidVehicle(i)) {
	    		if(IsPlayerInRangeOfVehicle(playerid, i, 2.5)) {
	    			veh = i;
	    			break ;
	    		}
	    	}
	    }
	    if(veh == -1) return SendErrorMessage(playerid, " Ban khong o gan bat ki phuong tien nao.");
	    v = GetPlayerVehicle(playerid, veh);
	    if(GetVehicleModel(veh) != 414) return SendErrorMessage(playerid, " Phuong tien nay khong the chua hang.");
        if(v != -1) {
        	SetPVarInt(playerid, #TrunkVehicle, veh);
        	SetPVarInt(playerid, #TrunkVehicleSlot, v);
        	string = "Mat hang\t#\tPhan loai\n";
        	for(new i = 0 ; i < 10 ; i++) {
        		new itemid = PlayerVehicleInfo[playerid][v][pvBox][i];
        		new category = sb_info[itemid][item_category];
        		format(string, sizeof string, "%s#%s\t#\t%s\n", string,sb_info[itemid][item_name],sb_category[category]);
        	}
	        Dialog_Show(playerid, DIALOG_SHIPMENT, DIALOG_STYLE_TABLIST_HEADERS, "Vehicle # Shipment", string, "Them", "Thoat");
        }
    }
    return 1;
} 

Dialog:DIALOG_CREATEBSHIP(playerid, response, listitem, inputtext[])
{
	if(response) {
		new choice = listitem;
	   	for(new i = 0 ; i < MAX_SELLER_CREATE; i++) {
          	if(sell_item_postion[i][item_s_set] == 0) {
          		sell_item_postion[i][item_s_set] = 1;
          		new Float:x,Float:y,Float:z,zone[32],string[529];
          		GetPlayerPos(playerid, x,y,z);
          		sell_item_postion[i][s_posX] = x;
          		sell_item_postion[i][s_posY] = y;
          		sell_item_postion[i][s_posZ] = z;
          		sell_item_postion[i][item_s_id] = choice;
          		sell_item_postion[i][item_s_price] = 100;
          		Get3DZone(x,y,z,zone,32);
          		format(string, sizeof string, "%s %s\nDang thu mua mat hang: {e1e354}%s{cdc3c3} Gia mua: {4dbc55}$%s{cdc3c3}\n/shiptment sell de ban", zone,companybuyname[sell_item_postion[i][item_s_id]],sb_info[sell_item_postion[i][item_s_id]][item_name],number_format(sell_item_postion[i][item_s_price]));
          		sell_item_postion[i][items_text] = CreateDynamic3DTextLabel(string, COLOR_WHITE2,  x,y,z, 20.0);
          		sell_item_postion[i][items_pickup] = CreateDynamicPickup(1271, 23, x,y,z);
      
   	           format(string, sizeof(string), "INSERT INTO `bshipment` (`s_id`,`item_s_set` ,`s_posX`, `s_posY`, `s_posZ`, `item_s_id`, `item_s_price`) \
   	           	VALUES ('%d','%d','%f', '%f','%f','%d','%d')",i,sell_item_postion[i][item_s_set],sell_item_postion[i][s_posX],sell_item_postion[i][s_posY],sell_item_postion[i][s_posZ],sell_item_postion[i][item_s_id],sell_item_postion[i][item_s_price]);
   	           mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);
          		break ;
      
          	}
        }
	}
}
Dialog:DIALOG_SHIPMENTS_FIND(playerid, response, listitem, inputtext[])
{
	if(response) {
		new i =listitem;
		new item = sell_item_postion[i][item_s_id];
		new string[129];
		new zone[32];
		CP[playerid] = 252000;
	    Get3DZone(sell_item_postion[i][s_posX],sell_item_postion[i][s_posY],sell_item_postion[i][s_posZ],zone,32);
		format(string,sizeof(string),"#SHIPMENT# Ban da dinh vi vi tri cua %s %s (mat hang: %s).",zone,sb_info[item][item_name]);
		SendClientMessageEx(playerid,COLOR_WHITE2,string);
		SetPlayerCheckpoint(playerid,sell_item_postion[i][s_posX],sell_item_postion[i][s_posY],sell_item_postion[i][s_posZ],10);
	}
}
Dialog:DIALOG_SHIPMENT_FIND(playerid, response, listitem, inputtext[])
{
	if(response) {
		new i =listitem;
		new item = buy_item_postion[i][item_sell_id];
		new string[129];
		new zone[32];
		CP[playerid] = 252000;
	    Get3DZone(buy_item_postion[i][is_posX],buy_item_postion[i][is_posY],buy_item_postion[i][is_posZ],zone,32);
		format(string,sizeof(string),"#SHIPMENT# Ban da dinh vi vi tri cua %s %s (mat hang: %s).",zone,sb_info[item][item_name]);
		SendClientMessageEx(playerid,COLOR_WHITE2,string);
		SetPlayerCheckpoint(playerid,buy_item_postion[i][is_posX],buy_item_postion[i][is_posY],buy_item_postion[i][is_posZ],10);
	}
}
Dialog:DIALOG_SHIPMENT(playerid, response, listitem, inputtext[])
{
	new v = GetPVarInt(playerid,#TrunkVehicleSlot);
	if(response) {
		if(PlayerVehicleInfo[playerid][v][pvBox][listitem] == 0) {
			if(PlayerShipment[playerid] != 0) {
				PlayerVehicleInfo[playerid][v][pvBox][listitem]  = PlayerShipment[playerid];
				PlayerShipment[playerid] = 0;
				new string[129];
				new itemid = PlayerVehicleInfo[playerid][v][pvBox][listitem];
        		new category = sb_info[itemid][item_category];
				format(string, sizeof string, "Ban da dat mat hang %s(%s) len phuong tien [%d].", string,sb_info[itemid][item_name],sb_category[category]);
				SendClientMessageEx(playerid,COLOR_WHITE2,string);
			}
			else SendErrorMessage(playerid, " Ban khong cam thung hang tren tay.");
		}
		else if(PlayerVehicleInfo[playerid][v][pvBox][listitem] != 0) {
			if(PlayerShipment[playerid] == 0) {
				PlayerShipment[playerid] = PlayerVehicleInfo[playerid][v][pvBox][listitem];
				PlayerVehicleInfo[playerid][v][pvBox][listitem] = 0;
				new string[129];
				new itemid = PlayerShipment[playerid];
        		new category = sb_info[itemid][item_category];
        		RemovePlayerAttachedObject(playerid, 1);
        		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
				format(string, sizeof string, "Ban da lay mat hang %s(%s) xuong tu [%d].", string,sb_info[itemid][item_name],sb_category[category]);
				SendClientMessageEx(playerid,COLOR_WHITE2,string);
			}
			else SendErrorMessage(playerid, " Ban damg cam mot thung hang tren tay.");
		}
	}
	return 1;
}