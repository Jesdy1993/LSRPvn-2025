#include <YSI\y_hooks>
new ID_Card_NPC;  

hook OnGameModeInit() {
    CreateDynamic3DTextLabel("< My Link > \nBam phim 'Y' de tuong tac voi My Link\n(DANG KI ID-Card TAI DAY )",COLOR_GREEN,1468.7361,-1772.3065,18.7958+0.5,10.0);// Cong viec Detective (LS)

    ID_Card_NPC = CreateActor(249,1468.7361,-1772.3065,18.7958,359.9619);
}
hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if (newkeys & KEY_YES)
    {
        new Float:PosXACtor, Float:PosYACtor, Float:PosZACtor;
        GetActorPos(ID_Card_NPC, PosXACtor, PosYACtor, PosZACtor);
        if(IsPlayerInRangeOfPoint(playerid, 2.0, PosXACtor, PosYACtor, PosZACtor))
        {
            if(PlayerInfo[playerid][pCMND] >= 100000) return ShowNotifyTextMain(playerid,"~y~My Link:~w~ Anh ban da dang ki ID-Card roi neu co van de gi hay quay lai sau...",6);
            ShowIDCard_Register(playerid) ;
        }
    }
    return 0;
}
stock ShowPlayerToPlayerIDC(playerid) {
    Dialog_Show(playerid, ID_CARD_SHOWING, DIALOG_STYLE_INPUT, "ID-Card @ Showing", "Vui long nhap ID nguoi choi ban muon cho xem ID-Card:", "Xac nhan", "huy bo");
}
stock ShowPlayerIDCard(playerid,giveplayerid)
{
    new gioitinh[5],string[320];
    if(PlayerInfo[playerid][pSex] == 1) gioitinh = "Nam";
    else gioitinh = "Nu";
    format(string, sizeof string, "#\t#\t#\n\
                                   #\tTen dang ki:\t%s\n\
                                   #\tMa so ID-Card:\t%d\n\
                                   #\tQuoc tich:\tSan Andreas\n\
                                   #\tNgay/thang/nam sinh:\t%s\n\
                                   #\tGioi tinh:\t%s\n\
                                   #\tTHONG TIN DA XAC THUC\t#",
    GetPlayerNameEx(playerid),
    PlayerInfo[playerid][pCMND],
    PlayerInfo[playerid][pBirthDate],
    gioitinh);
    Dialog_Show(giveplayerid, ID_CARD_SHOW, DIALOG_STYLE_TABLIST_HEADERS, "ID-Card @ Registration", string, "Xac nhan", "huy bo");
    return 1;
}
stock ShowIDCard_Register(playerid) {
    new string[1229],birthday[32];
    string = "#\t#\t#\n";
    new gioitinh[5];
    if(GetPVarInt(playerid, #IDC_Gender) == 1) gioitinh = "Nam";
    else if(GetPVarInt(playerid, #IDC_Gender) == 2) gioitinh = "Nu";
    GetPVarString(playerid, #IDC_Birthday, birthday, sizeof birthday);
    format(string, sizeof string, "%s#\tTen dang ki:\t%s\n\
                                   #\tQuoc tich:\tSan Andreas\n\
                                   #\tNgay/thang/nam sinh:\t%s\n\
                                   #\tGioi tinh:\t%s\n\
                                   #\tXac nhan dang ky\t#", string,
        GetPlayerNameEx(playerid),
        birthday,
        gioitinh);
    Dialog_Show(playerid, ID_CARD_STEP1, DIALOG_STYLE_TABLIST_HEADERS, "ID-Card @ Registration", string, "Xac nhan", "huy bo");
}
stock AcceptIDCard(playerid) {
   // if(!GetPVarInt(playerid,#IDC_Request)) return SendErrorMessage(playerid,"Ban khong co yeu cau nao.");
    ShowPlayerIDCard(playerid,GetPVarInt(playerid,#IDC_Request));
    return 1;
}
Dialog:ID_CARD_SHOWING(playerid, response, listitem, inputtext[]) {
    if(response) {
        new giveplayerid = strval(inputtext),str[129];
        if(!IsPlayerConnected(giveplayerid)) return SendErrorMessage(playerid,"Nguoi choi khong hop le.");
        if(!PlayerNearPlayer(playerid,giveplayerid,10.0)) return SendErrorMessage(playerid,"Nguoi choi do khong dung gan ban.");
        SetPVarInt(giveplayerid, #IDC_Request, playerid);
        format(str, sizeof str, "[ID-CARD] %s muon cho ban xem ID-Card cua ho, su dung /accept idcard de xem.", GetPlayerNameEx(playerid));
        SendClientMessage(giveplayerid, COLOR_GREEN, str);
        format(str, sizeof str, "[ID-CARD] Ban da yeu cau %s xem ID-Card cua minh, hay doi ho phan hoi.", GetPlayerNameEx(giveplayerid));
        SendClientMessage(playerid, COLOR_GREEN, str);
    }
    return 1;
}
Dialog:ID_CARD_SHOW(playerid, response, listitem, inputtext[]) {
    if(response) {
    
    }
}
Dialog:ID_CARD_SEL(playerid, response, listitem, inputtext[]) {
    if(response) {
        if(listitem == 0) ShowPlayerIDCard(playerid,playerid);
        if(listitem == 1) ShowPlayerToPlayerIDC(playerid); 
    }
}
Dialog:ID_CARD_STEP1(playerid, response, listitem, inputtext[]) {
    if(response) {
        if(listitem == 0) ShowIDCard_Register(playerid);
        if(listitem == 1) ShowIDCard_Register(playerid);
        if(listitem == 2) Dialog_Show(playerid, ID_CARD_EDIT_AGE, DIALOG_STYLE_INPUT, "ID-Card Registration - Age", "Vui long nhap ngay/thang/nam sinh cua nhan vat ban:", "Xac nhan", "huy bo");
        if(listitem == 3) Dialog_Show(playerid, ID_CARD_EDIT_GENDER, DIALOG_STYLE_LIST, "ID-Card Registration - Gender", "Nam\nNu", "Xac nhan", "huy bo");
        if(listitem == 4) Dialog_Show(playerid, ID_CARD_EDIT_CONFIRM, DIALOG_STYLE_MSGBOX, "ID-Card Registration - Confirm", "Ban co xac nhan thong tin dang ki tren khong? Neu xac nhan ban se hoan tat qua trinh dang ky", "Xac nhan", "huy bo");

    }
}

Dialog:ID_CARD_EDIT_CONFIRM(playerid, response, listitem, inputtext[]) {
    if(response) {
        if(CheckInventorySlotEmpty(playerid,8,1) == -1) return SendErrorMessage(playerid,"Tui do cua ban da day, khong the nhan them vat pham ID-Card.");
        Inventory_@Add(playerid, 8, 1);
        new birthday[32];
        PlayerInfo[playerid][pCMND] = 100000 + random(10000000);
        PlayerInfo[playerid][pSex] =  GetPVarInt(playerid, #IDC_Gender);
        GetPVarString(playerid, #IDC_Birthday, birthday, sizeof birthday);
        format(PlayerInfo[playerid][pBirthDate],32, "%s", birthday);
        new str[129];
        format(str, sizeof str, "Qua trinh dang ky ID-Card da hoan tat, ma so ID-Card cua ban la ~g~%d",  PlayerInfo[playerid][pCMND] );
        ShowNotifyTextMain(playerid,str,6);
        format(str, sizeof str, "Ban da dang ky ID-Card thanh cong, su dung /my inv de xem va su dung ID-Card cua minh.",  PlayerInfo[playerid][pCMND] );
        SendClientMessage(playerid, COLOR_GREEN,str);
        if(Question_@TutorialQues[playerid]  == 2) CompletePlayerTutorial(playerid);
    }
    else ShowIDCard_Register(playerid); 
    return 1;
}
Dialog:ID_CARD_EDIT_AGE(playerid, response, listitem, inputtext[]) {
    if(response) {
        if(isnull(inputtext)) return Dialog_Show(playerid, ID_CARD_EDIT_AGE, DIALOG_STYLE_INPUT, "ID-Card Registration - Age", "Vui long nhap ngay/thang/nam sinh cua nhan vat ban:", "Xac nhan", "huy bo");
        SetPVarString(playerid, #IDC_Birthday, inputtext);
        new str[129];
        format(str, sizeof str, "Ban da chinh sua ngay sinh cua minh thanh ~g~%s", inputtext);
        ShowNotifyTextMain(playerid,str,6);
        ShowIDCard_Register(playerid); 
    }
    else {
       ShowIDCard_Register(playerid); 
    }
    return 1;
}
Dialog:ID_CARD_EDIT_GENDER(playerid, response, listitem, inputtext[]) {
    if(response) {
        if(listitem == 0) {
            SetPVarInt(playerid, #IDC_Gender, 1);

        }
        else if(listitem == 1) { 
            SetPVarInt(playerid, #IDC_Gender, 2);
        }
        new gioitinh[5];
        if(GetPVarInt(playerid, #IDC_Gender) == 1) gioitinh = "Nam";
        else if(GetPVarInt(playerid, #IDC_Gender) == 2) gioitinh = "Nu"; 
        new str[129];
        format(str, sizeof str, "Ban da chinh sua ngay sinh cua minh thanh ~g~%s", inputtext);
        ShowNotifyTextMain(playerid,str,6);
        ShowIDCard_Register(playerid); 
        
    }
    else {
       ShowIDCard_Register(playerid); 
    }
    return 1;
}
stock PlayerNearPlayer(playerid,giveplayerid,Float:range) {
    new Float:Pos[3];
    GetPlayerPos(giveplayerid, Pos[0],Pos[1],Pos[2]);
    if(IsPlayerInRangeOfPoint(playerid, range, Pos[0],Pos[1],Pos[2])) return 1;
    return 0;
}