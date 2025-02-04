#include <YSI\y_hooks>
enum Clothes {
	accrategory,
	acname[52],
	acobject,
	acprice
}
new accessory[][Clothes] = {
	{0,"White mask",18919,1200},
	{0,"Black mask",18912,1200},
	{0,"Green mask",18913,1200},
	{0,"Dark mask",18918,1200},
	{0,"G-mask",18911,1200},
	{1,"Gold Watch",19039,1500},
	{1,"WatchType2",19040,1200},
	{1,"WatchType3",19041,1200},
	{1,"Golden, wrist watch",19042,3000},
	{1,"WatchType5k",19043,1200},
	{2,"GlassesType29",19034,500},
	{2,"GlassesType25",19030,500},
	{2,"Glasses pink",19025,500},
	{2,"GlassesType24",19029,500},
	{2,"EyePatch1",19085,1200},
	{3,"CapKnit1",18953,800},
	{3,"CapKnit2",18954,800},
	{3,"Beanie1",19554,800},
	{3,"HoodyHat1",19067,800},
	{3,"Hat moss",19068,800},
	{3,"Black hat",19069,800},
	{3,"Bandana1",18891,600},
	{3,"Bandana2",18892,600},
	{3,"Bandana3",18893,600},
	{3,"Bandana sandy",18894,600},
	{3,"Bandana5",18895,600},
	{3,"Bandana6",18896,600},
	{3,"Bandana7",18897,600},
	{3,"Black bandana",18898,600},
	{3,"Burgundy bandana",18899,600},
	{3,"Bandana11",18901,600},
	{3,"CapBack3",18941,600},
	{3,"CapBack4",18942,600},
	{3,"CapBack5",18943,600},
	{3,"HardHat3",19160,600},
	{3,"SkullyCap1",18964,600},
	{3,"SkullyCap2",18965,600},
	{3,"HardHat1",18638,600},
	{4,"Black helmet",18967,600},
	{4,"Gray Panama",18968,600},
	{4,"SillyHelmet2",19114,600},
	{4,"SillyHelmet3",19115,600},
	{4,"Christmas hat",19064,600},
	{4,"Merry Xmas",19065,600},
	{4,"BlackHat1",18639,600},
	{5,"Balo",19559,1500}
	
};
new accessorycategory[][] = {
	{"Mat na"},
	{"Dong ho"},
	{"Mat Kinh"},
	{"Non #1"},
	{"Non #2"},
	{"Balo"}
};

CMD:buyaccessory(playerid,params[]) 
{
	if(!IsPlayerInRangeOfPoint(playerid, 10.0, 207.0798, -129.1775, 1003.5078))
	{
	    SendErrorMessage(playerid, " Ban khong o gan cua hang quan ao.");
	    return 1;
    }
	new string[229];
	for(new i = 0 ; i < sizeof(accessorycategory); i++) {
		format(string,sizeof string,"%s%s\n",string,accessorycategory[i]);
		
	}
	Dialog_Show(playerid, DIALOG_ACC_CATEGORY, DIALOG_STYLE_LIST, "#Category", string, "Chon","Thoat");

	return 1;

}
stock showacessoryshop(playerid,category) {
	new string[1229];
	for(new i = 0 ; i < sizeof(accessory); i++) {
		if(accessory[i][accrategory] == category) {
			format(string, sizeof string, "%s\n%d\t~g~$%s", string,accessory[i][acobject],number_format(accessory[i][acprice]));
		}
	}

	ShowPlayerDialog(playerid, DIALOG_ACCESSORY, DIALOG_STYLE_PREVIEW_MODEL, "Mua trang phuc", string, "Xac nhan", "Thoat");
	return 1;
} 

stock getacessoryformobj(obj) {
	for(new i = 0 ; i < sizeof(accessory); i++) {
		if(accessory[i][acobject] == obj) {
			return i;
		}
	}
	return -1;
}
hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
	if(dialogid == DIALOG_ACCESSORY) {
		if(response) {
			SetPVarInt(playerid, #BuyAccessory, getacessoryformobj(strval(inputtext)));
			new ac_id = getacessoryformobj(strval(inputtext));
	        if(PlayerInfo[playerid][pCash] < accessory[ac_id][acprice]) return SendErrorMessage(playerid," Ban khong du tien de mua vat pham nay.");
	       
	        new string[129];
	        accessory[ac_id][acobject] = strval(inputtext);
	        format(string, sizeof string, "Ban co xac nhan mua mot %s[%d] voi gia $%s?", accessory[ac_id][acname] ,accessory[ac_id][acobject] ,number_format(accessory[ac_id][acprice]));
	        Dialog_Show(playerid, SELBUYacc, DIALOG_STYLE_MSGBOX, "#Accessory > Buy", string, "Xac nhan", "Thoat");
	    }
	}
	return 1;
}

Dialog:DIALOG_ACC_CATEGORY(playerid, response, listitem, inputtext[]) {
	if(response) {
		showacessoryshop(playerid,listitem);

	}
}
Dialog:SELBUYacc(playerid, response, listitem, inputtext[]) {
	if(response) {
		new selacc = GetPVarInt(playerid,#BuyAccessory);
	    if(PlayerInfo[playerid][pCash] < accessory[selacc][acprice]) return SendErrorMessage(playerid," Ban khong du tien de mua vat pham nay.");
	    if(CountAccessory(playerid) < 1) return SendErrorMessage(playerid, " Ban khong con #slot trong (/my acc).");
	    new icount = GetPlayerToySlots(playerid);
		for(new v = 0; v < icount; v++)
		{
			if(PlayerToyInfo[playerid][v][ptModelID] == 0)
			{
				PlayerToyInfo[playerid][v][ptModelID] = accessory[selacc][acobject];
				PlayerToyInfo[playerid][v][ptBone] = 6;
				PlayerToyInfo[playerid][v][ptPosX] = 0.0;
				PlayerToyInfo[playerid][v][ptPosY] = 0.0;
				PlayerToyInfo[playerid][v][ptPosZ] = 0.0;
				PlayerToyInfo[playerid][v][ptRotX] = 0.0;
				PlayerToyInfo[playerid][v][ptRotY] = 0.0;
				PlayerToyInfo[playerid][v][ptRotZ] = 0.0;
				PlayerToyInfo[playerid][v][ptScaleX] = 1.0;
				PlayerToyInfo[playerid][v][ptScaleY] = 1.0;
				PlayerToyInfo[playerid][v][ptScaleZ] = 1.0;
				PlayerToyInfo[playerid][v][ptTradable] = 1;

				g_mysql_NewToy(playerid, v);

				GivePlayerMoneyEx(playerid,-accessory[selacc][acprice]);
		        new string[129];
		        format(string,sizeof(string), " Ban da mua thanh cong mot phu kien %s voi gia $%s.",accessory[selacc][acname],number_format(accessory[selacc][acprice]));
                SendClientMessageEx(playerid,COLOR_GREEN,string);
				return 1;
			}
		}
		printf("%d, money: %d",selacc,accessory[selacc][acprice]);
		
	}
	return 1;
}
stock CountAccessory(playerid) {
	new count = 0;
	new icount = GetPlayerToySlots(playerid);
	for(new v = 0; v < icount; v++)
	{
	    if(PlayerToyInfo[playerid][v][ptModelID] == 0)
		{
			count++;
		}
	}
	return count;
}