#include <YSI\y_hooks>
new Question_@TutorialQues[MAX_PLAYERS],PlayerText:Question_TD[MAX_PLAYERS][3];
new Question_@TextTD[5][] = {
	"Hay di den cua hang va mua mot GPS~g~Di_theo_diem_Checkpoint_do_tren_ban_do~w~su_dung_/my_>_Question_de_xem_chi_tiet",
	"Hay di den cua hang va mua mot chiec xe~g~Di_theo_diem_Checkpoint_do_tren_ban_do~w~su_dung_/my_>_Question_de_xem_chi_tiet",
	"Hay_di_den_city_hall_va_dang_ki_ID-Card~n~~g~Di_theo_diem_Checkpoint_do_tren_ban_do~w~su_dung_/my_>_Question_de_xem_chi_tiet",
	"Hay di den ngan hang va dang ki the ATM~n~~g~Di_theo_diem_Checkpoint_do_tren_ban_do~w~su_dung_/my_>_Question_de_xem_chi_tiet",
	"Hay di den Pizza Stack nhan viec va lam viec~n~~g~Di_theo_diem_Checkpoint_do_tren_ban_do~w~su_dung_/my_>_Question_de_xem_chi_tiet"
};



stock SetPlayerTutorial(playerid) {
	switch(Question_@TutorialQues[playerid] ) {
		case 0: {
    		ShowNotifyTextMain(playerid,"Tutorial: Nhiem vu dau tien cua ban la ~r~mua mot GPS~w~ tai cua hang 24/7",10);
    		SetPlayerCheckpoint(playerid, 1833.5233,-1843.0210,13.5781, 5.0);
    		PlayerTextDrawSetString(playerid, Question_TD[playerid][1],Question_@TextTD[Question_@TutorialQues[playerid]]);
            PlayerTextDrawShow(playerid,Question_TD[playerid][0]);
            PlayerTextDrawShow(playerid,Question_TD[playerid][1]);
            PlayerTextDrawShow(playerid,Question_TD[playerid][2]);
     	}

    	case 1: {
    		ShowNotifyTextMain(playerid,"Tutorial: Nhiem vu dau tien cua ban la ~r~mua mot phuong tien tai~w~ shop xe gan nhat",10);
    		SetPlayerCheckpoint(playerid, 1832.6133,-1863.9851,13.3828, 5.0);
    		PlayerTextDrawSetString(playerid, Question_TD[playerid][1],Question_@TextTD[Question_@TutorialQues[playerid]]);
            PlayerTextDrawShow(playerid,Question_TD[playerid][0]);
            PlayerTextDrawShow(playerid,Question_TD[playerid][1]);
            PlayerTextDrawShow(playerid,Question_TD[playerid][2]);
     	}
    	case 2: {
    		ShowNotifyTextMain(playerid,"Tutorial: Nhiem vu thu hai cua ban la ~r~Dang ki ID-Card~w~ tai City hall",10);
    		SetPlayerCheckpoint(playerid, 1468.7361,-1772.3065,18.7958, 8.0);
    		PlayerTextDrawSetString(playerid, Question_TD[playerid][1],Question_@TextTD[Question_@TutorialQues[playerid]]);
            PlayerTextDrawShow(playerid,Question_TD[playerid][0]);
            PlayerTextDrawShow(playerid,Question_TD[playerid][1]);
            PlayerTextDrawShow(playerid,Question_TD[playerid][2]);

    	}
    	case 3: {
    		ShowNotifyTextMain(playerid,"Tutorial: Nhiem vu thu ba cua ban la ~r~Dang ki tai khoan ngan hang~w~ tai Los Santos Bank",10);
    		SetPlayerCheckpoint(playerid, 1455.8496,-1011.5436,26.8438, 8.0);
    		PlayerTextDrawSetString(playerid, Question_TD[playerid][1],Question_@TextTD[Question_@TutorialQues[playerid]]);
            PlayerTextDrawShow(playerid,Question_TD[playerid][0]);
            PlayerTextDrawShow(playerid,Question_TD[playerid][1]);
            PlayerTextDrawShow(playerid,Question_TD[playerid][2]);
    	}
    	case 4: {
    		ShowNotifyTextMain(playerid,"Tutorial: Nhiem vu cua ban la ~r~nhan viec Pizza-Boy~w~ tai Idlewood",10);
    		SetPlayerCheckpoint(playerid, 2099.0378,-1801.4995,13.3889, 8.0);
    		PlayerTextDrawSetString(playerid, Question_TD[playerid][1],Question_@TextTD[Question_@TutorialQues[playerid]]);
            PlayerTextDrawShow(playerid,Question_TD[playerid][0]);
            PlayerTextDrawShow(playerid,Question_TD[playerid][1]);
            PlayerTextDrawShow(playerid,Question_TD[playerid][2]);
    	}
    }
    
}
stock CompletePlayerTutorial(playerid) {
	switch(Question_@TutorialQues[playerid]  ) {
		case 0: {
			ShowNotifyTextMain(playerid,"Tutorial: Chuc mung ban da hoan thanh nhiem vu ~r~ GPS~w~ hay tiep tuc xem nhiem vu tiep theo nhe",10);
		    Question_@TutorialQues[playerid] = 1;
		    SetPlayerTutorial(playerid);
		}
		case 1: {
			ShowNotifyTextMain(playerid,"Tutorial: Chuc mung ban da hoan thanh nhiem vu ~r~ SO HUU PHUONG TIEN~w~ hay tiep tuc xem nhiem vu tiep theo nhe",10);
		    Question_@TutorialQues[playerid] = 2;
		    SetPlayerTutorial(playerid);
		}
		case 2: {
			ShowNotifyTextMain(playerid,"Tutorial: Chuc mung ban da hoan thanh nhiem vu ~r~ DANG KI THONG TIN CA NHAN~w~ hay tiep tuc xem nhiem vu tiep theo nhe",10);
		    Question_@TutorialQues[playerid] = 3;
		    SetPlayerTutorial(playerid);
		}
		case 3: {
			ShowNotifyTextMain(playerid,"Tutorial: Chuc mung ban da hoan thanh nhiem vu ~r~ Dang ki tai khoan ngan hang~w~ hay tiep tuc xem nhiem vu tiep theo nhe",10);
		    // Question_@TutorialQues[playerid] = 3;
		    Question_@TutorialQues[playerid] = 4;
		    SetPlayerTutorial(playerid);
		    // SetPlayerTutorial(playerid);
		}
		case 4: {
			ShowNotifyTextMain(playerid,"Tutorial: Chuc mung ban da hoan thanh Tutorial, hay bat dau lam viec nhe.",10);
		    PlayerTextDrawHide(playerid,Question_TD[playerid][0]);
   	        PlayerTextDrawHide(playerid,Question_TD[playerid][1]);
   	        PlayerTextDrawHide(playerid,Question_TD[playerid][2]);
		    // Question_@TutorialQues[playerid] = 3;
		    Question_@TutorialQues[playerid] = 5;
		    SendClientMessage(playerid, COLOR_YELLOW, "Ban da hoan thanh Tutorial, hay bat dau lam cong viec Pizza");
		    // SetPlayerTutorial(playerid);
		}
	}
	return 1;
}

hook OnPlayerEnterCheckpoint(playerid) {
	if(IsPlayerInRangeOfPoint(playerid, 5.0,1833.6573,-1843.1063,13.5781) &&  Question_@TutorialQues[playerid] == 0) {
        ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Tutorial - Question 1", "Hay vao cua hang mua mot GPS\nGPS se dinh vi cac vi tri quan trong.", "Xac nhan", "");
	    DisablePlayerCheckpoint(playerid);
	}
	else if(IsPlayerInRangeOfPoint(playerid, 5.0, 1832.6133,-1863.9851,13.3828) &&  Question_@TutorialQues[playerid] == 1) {
        ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Tutorial - Question 2", "Hay lua chon va mua mot chiec xe ma ban thich, len xe (enter) de tien hanh giao dich\nHuong dan phuong tien: /my veh de xem/lay/cat phuong tien\nPhuong tien da so huu se xuat hien o vi tri ma ban da dau xe (/dauxe)", "Xac nhan", "");
	    DisablePlayerCheckpoint(playerid);
	}
	else if(IsPlayerInRangeOfPoint(playerid, 9.0, 1469.1016,-1771.5710,18.7958) &&  Question_@TutorialQues[playerid] == 2) {
		print("alo");
        ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Tutorial - Question 3", "Hay tien hanh dang ky thong tin ca nhan\nHuong dan ID-Card: /my inv de xem thong tin ve CMND\nID-Card se can thiet tai server ve cac tuong tac IC/ lan cac  he thong cong viec, Faction...", "Xac nhan", "");
	    DisablePlayerCheckpoint(playerid);
	}
	else if(IsPlayerInRangeOfPoint(playerid, 9.0, 1455.8496,-1011.5436,26.8438) &&  Question_@TutorialQues[playerid] == 3) {
        ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Tutorial - Question 4", "Hay tien hanh dang ky tai khoan ngan hang vao ngan hang su dung lenh ( /bank ) de thao tac", "Xac nhan", "");
	    DisablePlayerCheckpoint(playerid);
	}
	else if(IsPlayerInRangeOfPoint(playerid, 9.0, 2099.0378,-1801.4995,13.3889) &&  Question_@TutorialQues[playerid] == 4) {
        ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Tutorial - Question 5", "Hay tien hanh xin viec va bat dau lam viec", "Xac nhan", "");
	    DisablePlayerCheckpoint(playerid);
	}
	return 1;
}
hook OnPlayerConnect(playerid) {


    Question_TD[playerid][0] = CreatePlayerTextDraw(playerid, 6.8498, 244.2445, "Box"); // ïóñòî
    PlayerTextDrawLetterSize(playerid, Question_TD[playerid][0], 0.0000, 6.0416);
    PlayerTextDrawTextSize(playerid, Question_TD[playerid][0], 95.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, Question_TD[playerid][0], 1);
    PlayerTextDrawColor(playerid, Question_TD[playerid][0], -1);
    PlayerTextDrawUseBox(playerid, Question_TD[playerid][0], 1);
    PlayerTextDrawBoxColor(playerid, Question_TD[playerid][0], 163);
    PlayerTextDrawBackgroundColor(playerid, Question_TD[playerid][0], 255);
    PlayerTextDrawFont(playerid, Question_TD[playerid][0], 1);
    PlayerTextDrawSetProportional(playerid, Question_TD[playerid][0], 1);
    PlayerTextDrawSetShadow(playerid, Question_TD[playerid][0], 0);
    
    Question_TD[playerid][1] = CreatePlayerTextDraw(playerid, 9.4666, 251.0297, "Hay_di_den_24/7_va_mua_mot_GPS~n~(_Den_CP_vao_cua_hang_va_su_dung~n~_lenh_/mua),_~r~GPS~w~_se_la_Item_quan_trong_giup_ban_dinh_"); // ïóñòî
    PlayerTextDrawLetterSize(playerid, Question_TD[playerid][1], 0.1279, 1.0659);
    PlayerTextDrawTextSize(playerid, Question_TD[playerid][1], 90.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, Question_TD[playerid][1], 1);
    PlayerTextDrawColor(playerid, Question_TD[playerid][1], -104);
    PlayerTextDrawBackgroundColor(playerid, Question_TD[playerid][1], 110);
    PlayerTextDrawFont(playerid, Question_TD[playerid][1], 1);
    PlayerTextDrawSetProportional(playerid, Question_TD[playerid][1], 1);
    PlayerTextDrawSetShadow(playerid, Question_TD[playerid][1], 0);

    Question_TD[playerid][2] = CreatePlayerTextDraw(playerid, 0.8333, 232.5185, "Tutorial"); // ïóñòî
    PlayerTextDrawLetterSize(playerid, Question_TD[playerid][2], 0.4000, 1.6000);
    PlayerTextDrawAlignment(playerid, Question_TD[playerid][2], 1);
    PlayerTextDrawColor(playerid, Question_TD[playerid][2], -1);
    PlayerTextDrawBackgroundColor(playerid, Question_TD[playerid][2], 255);
    PlayerTextDrawFont(playerid, Question_TD[playerid][2], 0);
    PlayerTextDrawSetProportional(playerid, Question_TD[playerid][2], 1);
    PlayerTextDrawSetShadow(playerid, Question_TD[playerid][2], 0);
    
}