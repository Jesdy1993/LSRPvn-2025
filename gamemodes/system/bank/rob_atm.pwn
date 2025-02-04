#include <YSI\y_hooks>
new Float:ATMPostion[][6] = {
	{2228.378173, -1707.652709, 13.258893,0.000000, 0.000000, -90.000000},
    {1497.795288, -1749.862915, 15.077092, 0.000000, 0.000000, 180.000000},
    {1482.774169, -1010.197448, 26.455493,0.000000, 0.000000, 0.000000 },
    {1155.593139, -1464.864257, 15.442094,0.000000, 0.000000, -70.000000},
    {2093.656250, -1359.508422, 23.606088,0.000000, 0.000000, 0.000000 },
    {2139.411132, -1164.068115, 23.615186,0.000000, 0.000000, 90.000000 }
};
new ATMisRobbed[sizeof(ATMPostion)];
new ATMSmokeObj[sizeof(ATMPostion)]; //  
new ATMObject[sizeof(ATMPostion)];
new ATM_Count[sizeof(ATMPostion)];
new ATM_Money[sizeof(ATMPostion)];
new Text3D:ATMText[sizeof(ATMPostion)];
new Timer:ATM_Restore[sizeof(ATMPostion)];

new StartRob[MAX_PLAYERS];
new Timer:RobberToan[MAX_PLAYERS];

enum atm_Break {
	Debai[162],
	LoigiaiA[62],
	LoigiaiB[62],
	LoigiaiC[62],
	LoigiaiD[62],
	dapan
};
new atm_question[][atm_Break] = {
	{"{ff5a4f}0","A. 0","B. 0","C. 0","D. 0",0},
	{"{ff5a4f}1+1= ?","A. 2","B. 6","C. 12","D. 100",0},
	{"{ff5a4f}2+126= ?","A. 12","B. 26","C. 132","D. 128",3},
	{"{ff5a4f}So tu nhien 9 chia het cho ?","A. 3","B. 4","C. 5","D. 7",0},
	{"{ff5a4f}Dien tich khoi lang tru co the tich V , chieu cao h","A. V/h","B. h/V","C. 2v/H","D. 2h/V",0},
	{"{ff5a4f}So giao diem cua x2+2x va truc hoanh la?","A. 3","B. 1","C. 0","D. 2",3},
	{"{ff5a4f}100-74 = ?","A. 26","B. 36","C. 34","D. 24",0},
	{"{ff5a4f}1-74 = ?","A. -75","B. -73","C. -72","D. 75",1},
	{"{ff5a4f}8+2+3+4+5+6+7+8 = ?","A. 40 ","B. 41","C. 42","D. 43",3},
	{"{ff5a4f}1+2+3+4+5+6+7+8+9-1 = ?","A. 42 ","B. 43","C. 44","D. 45",2},
	{"{ff5a4f}10 - 2 x 3= ?","A. 4 ","B. 24","C. 8","D. 26",0},
	{"{ff5a4f}9x9 -1?","A. 76 ","B. 79","C. 80","D. 82",2},
	{"{ff5a4f}0x100-1","A. 99 ","B. -99","C. -1","D. 0",2}
};

stock IsNearATM(playerid) {
	for(new i = 0 ; i < sizeof(ATMPostion); i++) {
		if(IsPlayerInRangeOfPoint(playerid, 5, ATMPostion[i][0],ATMPostion[i][1],ATMPostion[i][2])) return i;
	}
	return -1;
}
CMD:cuopatm(playerid,params[]) return SendErrorMessage(playerid, " He thong cuop ATM & rua tien se bat dau hoat dau o ban cap nhat Light 1.2.");

CMD:atm(playerid, params[]) {
	if(IsNearATM(playerid) == -1) return SendErrorMessage(playerid, " Ban khong o gan ATM.");
	if(ATMisRobbed[IsNearATM(playerid)] != 0) return SendErrorMessage(playerid, " Cay ATM khong hoat dong.");
	if(PlayerInfo[playerid][pSoTaiKhoan] < 100) return ShowPlayerDialog(playerid,DIALOG_NOTHING,DIALOG_STYLE_MSGBOX,"Tai khoan ngan hang","Ban chua co tai khoan ngan hang khong the su dung,ban co muon dang ky khong hay den ngan hang de dang ky","Dong y","Huy bo");
	new ti[42],string[230];
	format(ti, sizeof ti, "Tai khoan ngan hang cua %s", GetPlayerNameEx(playerid));
	format(string, sizeof string, "Ten chu the\t\t\t\t{8b3721}%s{ffffff}\nSo tai khoan\t\t\t\t{eae000}%d{ffffff}\nSo du trong vi\t\t\t\t{289c59}$%s{ffffff}\n___________________\nChuyen tien\nGui tien\nRut tien", GetPlayerNameEx(playerid),PlayerInfo[playerid][pSoTaiKhoan],number_format(PlayerInfo[playerid][pAccount]));
	ShowPlayerDialog(playerid, DIALOG_BANK, DIALOG_STYLE_LIST, ti, string, "Tuy chon", "Thoat");
	return 1;
}
CMD:pickmoney(playerid,params[]) {

	//if(CopsOnline() < 2 ) return SendErrorMessage(playerid, " Khong co du 2 canh sat online");
	if(StartRob[playerid] == 1) return SendErrorMessage(playerid, " Ban da bat dau cuop ATM roi.");
	if(IsNearATM(playerid) == -1) return SendErrorMessage(playerid, " Ban khong o gan ATM.");
	new i = IsNearATM(playerid); 
	if(ATMisRobbed[i] != 3) return SendErrorMessage(playerid, " ATM chua the lay tien.");
	if(ATM_Money[i] <= 0) return SendErrorMessage(playerid, " ATM da bi lay het tien.");
    PlayAudioStreamForPlayer(playerid, "https://drive.usercontent.google.com/u/0/uc?id=16Q5BkGR5sIFitVan6cRrPzysfpr3xEcf&export=download", ATMPostion[GetPVarInt(playerid,#ATM_RobID)][0],ATMPostion[GetPVarInt(playerid,#ATM_RobID)][1],ATMPostion[GetPVarInt(playerid,#ATM_RobID)][2], 50, 1);
	

	SetPVarInt(playerid, #ATM_RobID, IsNearATM(playerid));

   
	PlayAnimEx(playerid, "BOMBER", "BOM_Plant_Loop", 4.0, 1, 0, 0, 0, 0, 1);

	StartRob[playerid] = 2;

	RobberToan[playerid] = repeat Pick_Money[1000](playerid);
  
    return 1;
}
CMD:robatm(playerid,params[]) {
	SendErrorMessage(playerid, " Bao tri.");

	// if(CopsOnline() < 2 ) return SendErrorMessage(playerid, " Khong co du 2 canh sat online");
	// if(StartRob[playerid] == 2) return SendErrorMessage(playerid, " Ban da bat dau cuop ATM roi.");
	// if(IsNearATM(playerid) == -1) return SendErrorMessage(playerid, " Ban khong o gan ATM.");
	// if(ATMisRobbed[IsNearATM(playerid)] != 0) return SendErrorMessage(playerid, " Cay ATM dang bi cuop roi.");

	// SetPVarInt(playerid, #ATM_RobID, IsNearATM(playerid));
	// SetPVarInt(playerid, #ATMRobProgress, 1);

    // PlayAudioStreamForPlayer(playerid, "https://drive.usercontent.google.com/u/0/uc?id=16Q5BkGR5sIFitVan6cRrPzysfpr3xEcf&export=download", ATMPostion[GetPVarInt(playerid,#ATM_RobID)][0],ATMPostion[GetPVarInt(playerid,#ATM_RobID)][1],ATMPostion[GetPVarInt(playerid,#ATM_RobID)][2], 50, 1);

    // StartRob[playerid] = 1;

    // ATMisRobbed[IsNearATM(playerid)] = 1;

	// PlayAnimEx(playerid, "BOMBER", "BOM_Plant_Loop", 4.0, 1, 0, 0, 0, 0, 1);

	
	// RobberToan[playerid] = repeat RobATM_Progress[1000](playerid);
    // ShowQuestionATM(playerid) ;


    // // cops
    // new str[129],zone[32];
    // foreach(new i : Player) {
    // 	if(IsACop(i)) {
    // 		Get3DZone( ATMPostion[IsNearATM(playerid)][0] ,ATMPostion[IsNearATM(playerid)][1], ATMPostion[IsNearATM(playerid)][2], zone, 32);
    //         format(str,sizeof(str),"*Loa* Canh bao ATM tai khu vuc {b83535}%s{cdc3c3} dang bi tan cong.",zone);
    // 		SendClientMessage(i,COLOR_WHITE2,str);
    // 		PlayAudioStreamForPlayer(i, "https://drive.usercontent.google.com/u/0/uc?id=16Q5BkGR5sIFitVan6cRrPzysfpr3xEcf&export=download");
    // 	}
    // }
    return 1;
}
stock CancelRobATM(playerid) {
	if(StartRob[playerid] == 1) ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Rob ATM","Qua trinh cuop ATM da that bai.","Dong","");
	PlayerTextDrawHide(playerid, NotifyTextMain[playerid]);
	ClearAnimations(playerid);
	stop RobberToan[playerid];
	ATMisRobbed[GetPVarInt(playerid,#ATM_RobID)] = 0;
	DeletePVar(playerid, #ATM_RobID);
	DeletePVar(playerid, #RobATM_Progress);
	StartRob[playerid] = 0;
}
stock ShowQuestionATM(playerid) {
	new str[129];
	format(str, 129, "%s\n%s\n%s\n%s", atm_question[ StartRob[playerid] ][LoigiaiA],
		atm_question[ StartRob[playerid] ][LoigiaiB],
		atm_question[ StartRob[playerid] ][LoigiaiC],
		atm_question[ StartRob[playerid] ][LoigiaiD]);
	Dialog_Show(playerid, DIALOG_Q_ATM,DIALOG_STYLE_LIST, atm_question[ StartRob[playerid] ][Debai],str,"Tra loi","Thoat");
	return 1;
}
Dialog:DIALOG_Q_ATM(playerid, response, listitem, inputtext[])
{
    if(response) {
    	if(listitem != atm_question[ StartRob[playerid] ][dapan]) {
    		StartRob[playerid] = 1;
            ShowQuestionATM(playerid); 
            return 1;
    	} 
    	StartRob[playerid] ++;
    	if(StartRob[playerid] >= sizeof(atm_question)) {
    		StartRob[playerid] = 100;
    		UpdateDynamic3DTextLabelText(ATMText[GetPVarInt(playerid,#ATM_RobID)] , COLOR_BASIC, "< ATM >\n{da3737}Cay ATM vua bi cuop.");
    		ATMisRobbed[GetPVarInt(playerid,#ATM_RobID)] = 2;
    		PlayerTextDrawHide(playerid, NotifyTextMain[playerid]);
            ClearAnimations(playerid);
            stop RobberToan[playerid];
            DeletePVar(playerid, #ATM_RobID);
            StartRob[playerid] = 0;
            DeletePVar(playerid, #RobATM_Progress);
       		SendClientMessage(playerid, -1, "# ATM # da giai ma xong mat khau ATM, hay dung sung ban vao ATM de huy o khoat.");
    	}
    	else {
    		ShowQuestionATM(playerid); 
    	}
    	
    }
    else {
    	CancelRobATM(playerid);
    }
    return 1;
}
timer Pick_Money[1000](playerid) 
{
	new i = GetPVarInt(playerid, #ATM_RobID);

	PlayAnimEx(playerid, "BOMBER", "BOM_Plant_Loop", 4.0, 1, 0, 0, 0, 0, 1);
    new rand = 10+random(30);
    ATM_Money[i] -= rand;
    GivePlayerMoneyEx(playerid, rand);

	new str[80];
    format(str,sizeof(str),"Pickup Money...~g~$%s~w~ (~r~BAM Y de dung hanh dong~w~)",number_format(rand));
    PlayerTextDrawSetString(playerid, NotifyTextMain[playerid] , str);
    PlayerTextDrawShow(playerid, NotifyTextMain[playerid]);

 	if(ATM_Money[i] <= 0) {
		CancelRobATM(playerid);
		ATMisRobbed[GetPVarInt(playerid,#ATM_RobID)] = 3;
	} 
 	return 1;
}
timer RobATM_Progress[1000](playerid) 
{
	PlayAnimEx(playerid, "BOMBER", "BOM_Plant_Loop", 4.0, 1, 0, 0, 0, 0, 1);
	SetPVarInt(playerid, #ATMRobProgress, GetPVarInt(playerid, #ATMRobProgress)+1);
	new str[80];
    format(str,sizeof(str),"~r~Rob ATM~w~ thoi gian con lai: ~r~%d giay~w~", 100 - GetPVarInt(playerid, #ATMRobProgress));
    PlayerTextDrawSetString(playerid, NotifyTextMain[playerid] , str);
    PlayerTextDrawShow(playerid, NotifyTextMain[playerid]);
	if(GetPVarInt(playerid, #ATMRobProgress) >= 100) {
		CancelRobATM(playerid);
	} 
 	return 1;
}
hook OnPlayerDisconnect(playerid, reason) {
	CancelRobATM(playerid);
}
hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
	if(newkeys & KEY_YES) {
		if(StartRob[playerid] != 0) {
			new i = GetPVarInt(playerid, #ATM_RobID);
			if(StartRob[playerid] == 2) {
				CancelRobATM(playerid);
				ATMisRobbed[i] = 3;
			}
			else {
				CancelRobATM(playerid);
			}
			
		}
	}
}
public OnPlayerShootDynamicObject(playerid, weaponid, objectid, Float:x, Float:y, Float:z) 
{

    for(new i = 0 ; i < sizeof(ATMPostion);i++) {
		if(objectid == ATMObject[i] && ATMisRobbed[i] == 2) {
			ATMisRobbed[i] = 3;
			ATM_Count[i] = 0;
			ATM_Money[i] = 1000 + random(3000);
			new str[129];
			format(str,sizeof(str),"< ATM >\n{45c57b}$%s /pickmoney de lay tien...",number_format(ATM_Money[i]),number_format(ATM_Money[i]));
			UpdateDynamic3DTextLabelText(ATMText[i] , COLOR_BASIC, str);
			ATM_Restore[i] = repeat ATM_Restored[1000](i);
			DestroyDynamicObject(ATMObject[i]); 
			ATMObject[i] = CreateDynamicObject(2943, ATMPostion[i][0] ,ATMPostion[i][1] ,ATMPostion[i][2] ,ATMPostion[i][3] ,ATMPostion[i][4] ,ATMPostion[i][5] , -1, -1, -1, 200.00, 200.00);
		}

	}
    return 1;
}
hook OnPlayerConnect(playerid ) {
	CancelRobATM(playerid);
}
timer ATM_Restored[100](i) 
{
	ATM_Count[i] += 1;
	new str[129];
	format(str, sizeof str, "< ATM >\n{45c57b}$%s /pickmoney de lay tien...\n{b4b4b4}ATM Restore: %d giay nua.",number_format(ATM_Money[i]),3600 * 2-ATM_Count[i]);
	UpdateDynamic3DTextLabelText(ATMText[i] , COLOR_BASIC, str);
	if(ATM_Count[i] > 3600 * 2) {
		ATM_Count[i] = 0;
		ATMisRobbed[i] = 0;
		DestroyDynamicObject(ATMObject[i]);
		ATMObject[i] = CreateDynamicObject(19324, ATMPostion[i][0] ,ATMPostion[i][1] ,ATMPostion[i][2] ,ATMPostion[i][3] ,ATMPostion[i][4] ,ATMPostion[i][5] , -1, -1, -1, 300.00, 300.00);
		stop ATM_Restore[i];
		UpdateDynamic3DTextLabelText(ATMText[i] , COLOR_BASIC, "< ATM >\n{45c57b}Active{b4b4b4} /ATM & /robatm.");
	}
}
stock CopsOnline() {
	new online;
	foreach( new i : Player) {
		if(IsACop(i) && PlayerInfo[i][pDuty] == 1) {
			online++;
	    } 
	}
	return online;
}
hook OnGameModeInit( ) {
	new object_world = -1, object_int = -1;
    for(new i = 0 ; i < sizeof(ATMPostion);i++) {
    	ATMText[i] = CreateDynamic3DTextLabel("< ATM >\n{45c57b}Active{b4b4b4} /ATM & /robatm", COLOR_BASIC, ATMPostion[i][0] ,ATMPostion[i][1] ,ATMPostion[i][2], 20);
    	ATMObject[i] = CreateDynamicObject(19324, ATMPostion[i][0] ,ATMPostion[i][1] ,ATMPostion[i][2] ,ATMPostion[i][3] ,ATMPostion[i][4] ,ATMPostion[i][5] , object_world, object_int, -1, 300.00, 300.00);
    }
}