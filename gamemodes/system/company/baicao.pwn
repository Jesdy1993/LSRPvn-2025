#include <YSI\y_hooks>
#define MAX_PLAYERS_BC 8
enum Poker_Taber {
	bplayer[MAX_PLAYERS_BC] = INVALID_PLAYER_ID,
	bplayer_point0[MAX_PLAYERS_BC],
	bplayer_point1[MAX_PLAYERS_BC],
	bplayer_bet[MAX_PLAYERS_BC],
	bplayer_card[MAX_PLAYERS_BC],
	bplayer_total[MAX_PLAYERS_BC],
	bc_timer,
	bc_second,
	bc_step,
	bc_keypoint0,
	bc_keypoint1
}
new BC_Info[Poker_Taber];

new Text:BCCard0[MAX_PLAYERS_BC],
    Text:BCCard1[MAX_PLAYERS_BC],
    Text:BCPlayerText[MAX_PLAYERS_BC],
    Text:BCPointText[MAX_PLAYERS_BC],
    Text:BCKeyCard0,
    Text:BCKeyCard1,
    Text:BCKeyText,
    Text:BCKeyPointText,
    Text:BCBet,
    Text:BCText;

stock StartBC() {
	for(new i = 0 ; i <MAX_PLAYERS_BC ; i++) {
		BC_Info[bplayer][i] = INVALID_PLAYER_ID;
	}
	BC_Info[bc_step] = 1;
	BC_Info[bc_second] = 30;

	BC_Info[bc_timer] = SetTimer("UpdateBaiCao", 1000, true);
}
new PlayerJoinBC[MAX_PLAYERS] = -1;
enum card_info {
	bc_str[52],
	bc_point
}
new BCString[][card_info] = {
	{"ld_card:cd1s",1},
	{"ld_card:cd1c",1},
	{"ld_card:cd1d",1},
	{"ld_card:cd1h",1},
	{"ld_card:cd2s",2},
	{"ld_card:cd2c",2},
	{"ld_card:cd2d",2},
	{"ld_card:cd2h",2},
	{"ld_card:cd3s",3},
	{"ld_card:cd3c",3},
	{"ld_card:cd3d",3},
	{"ld_card:cd3h",3},
	{"ld_card:cd4s",4},
	{"ld_card:cd4c",4},
	{"ld_card:cd4d",4},
	{"ld_card:cd4h",4},
	{"ld_card:cd5s",5},
	{"ld_card:cd5c",5},
	{"ld_card:cd5d",5},
	{"ld_card:cd5h",5},
	{"ld_card:cd6s",6},
	{"ld_card:cd6c",6},
	{"ld_card:cd6d",6},
	{"ld_card:cd6h",6},
	{"ld_card:cd7s",7},
	{"ld_card:cd7c",7},
	{"ld_card:cd7d",7},
	{"ld_card:cd7h",7},
	{"ld_card:cd8s",8},
	{"ld_card:cd8c",8},
	{"ld_card:cd8d",8},
	{"ld_card:cd8h",8},
	{"ld_card:cd9s",9},
	{"ld_card:cd9c",9},
	{"ld_card:cd9d",9},
	{"ld_card:cd9h",9},
	{"ld_card:cd10s",10},
	{"ld_card:cd10c",10},
	{"ld_card:cd10d",10},
	{"ld_card:cd10h",10},
	{"ld_card:cd11s",10},
	{"ld_card:cd11c",10},
	{"ld_card:cd11d",10},
	{"ld_card:cd11h",10},
	{"ld_card:cd12s",10},
	{"ld_card:cd12c",10},
	{"ld_card:cd12d",10},
	{"ld_card:cd12h",10},
	{"ld_card:cd13s",10},
	{"ld_card:cd13c",10},
	{"ld_card:cd13d",10},
	{"ld_card:cd13h",10}

};

stock DisconnectPlayer(playerid) {

}
forward UpdateBaiCao();
public UpdateBaiCao() {
	if(GetBCPlayers() > 0) {
		new string[129];
    	BC_Info[bc_second] --;
    	UpdateTDBC();
    	for(new i = 0 ; i < MAX_PLAYERS_BC; i++) {
            if(BC_Info[bplayer][i] != INVALID_PLAYER_ID) {
            	if(PlayerInfo[BC_Info[bplayer][i]][pCash] <= 0) {
            		SendClientMessage(BC_Info[bplayer][i],COLOR_LIGHTRED, " Ban da bi duoi khoi ban bai cao vi het tien.");
            		for(new h = 0 ; h < MAX_PLAYERS_BC; h++) {
	                	TextDrawHideForPlayer(BC_Info[bplayer][i], BCCard0[h]);
                        TextDrawHideForPlayer(BC_Info[bplayer][i], BCCard1[h]);
                        TextDrawHideForPlayer(BC_Info[bplayer][i], BCPlayerText[h]);
                        TextDrawHideForPlayer(BC_Info[bplayer][i], BCPointText[h]); 
	                }
	                TextDrawHideForPlayer(BC_Info[bplayer][i], BCKeyCard0); 
	                TextDrawHideForPlayer(BC_Info[bplayer][i], BCKeyCard1); 
	                TextDrawHideForPlayer(BC_Info[bplayer][i], BCKeyText); 
	                TextDrawHideForPlayer(BC_Info[bplayer][i], BCKeyPointText); 
	                TextDrawHideForPlayer(BC_Info[bplayer][i], BCBet); 
	                TextDrawHideForPlayer(BC_Info[bplayer][i], BCText); 
	                CancelSelectTextDraw(BC_Info[bplayer][i]);
            		ExitBC(BC_Info[bplayer][i]);
            	}
            }
        }
    	if(BC_Info[bc_step] == 1) {
    		format(string, sizeof string, "Bai cao dat cuoc con: %d giay...", BC_Info[bc_second]);
            TextDrawSetString(BCText, string);
            ShowUpdateBCforAll();
            for(new i = 0 ; i < MAX_PLAYERS_BC; i++) {
                if(BC_Info[bplayer][i] != INVALID_PLAYER_ID) {
                	TextDrawHideForPlayer(BC_Info[bplayer][i],BCKeyCard0);
                	TextDrawHideForPlayer(BC_Info[bplayer][i],BCKeyCard1);
                	TextDrawHideForPlayer(BC_Info[bplayer][i],BCKeyPointText);
                	for(new j = 0 ; j < MAX_PLAYERS_BC; j++) {
                		
            		    TextDrawHideForPlayer(BC_Info[bplayer][i],BCCard0[j]);
                        TextDrawHideForPlayer(BC_Info[bplayer][i],BCCard1[j]);
                        TextDrawHideForPlayer(BC_Info[bplayer][i], BCPointText[j]);
            		}
                	
                }
            }
    
    
            for(new i = 0 ; i < MAX_PLAYERS_BC; i++ ) BC_Info[bplayer_card][i] = 0;
            
            if(BC_Info[bc_second] <= 0 ) {
            	BC_Info[bc_second] = 30;
            	BC_Info[bc_step] = 2;
            	return 1;
            }
    	}
    	else if(BC_Info[bc_step] == 2) {	
    		format(string, sizeof string, "Da chia bai, tat ca khui bai trong: %d giay...", BC_Info[bc_second]);
            TextDrawSetString(BCText, string);
            for(new i = 0 ; i < MAX_PLAYERS_BC; i++) {
            	TextDrawSetString(BCCard0[i], "ld_card:cdback");
            	TextDrawSetString(BCCard1[i], "ld_card:cdback");
            	TextDrawSetString(BCKeyCard0, "ld_card:cdback");
            	TextDrawSetString(BCKeyCard1, "ld_card:cdback");
            	if(BC_Info[bplayer][i] != INVALID_PLAYER_ID) {
            		BC_Info[bplayer_point0][i] = 0 + random(sizeof(BCString) );
            		BC_Info[bplayer_point1][i] = 0 + random(sizeof(BCString) );
            		BC_Info[bc_keypoint0] = 0 + random(sizeof(BCString) );
            		BC_Info[bc_keypoint1] = 0 + random(sizeof(BCString) );
    
            		GivePlayerMoneyEx(BC_Info[bplayer][i],-BC_Info[bplayer_bet][i]);
            		Company@AddBudget(3,BC_Info[bplayer_bet][i]);
    
            		BC_Info[bc_second] = 60;
            		BC_Info[bc_step] = 3;
            		BC_Info[bplayer_card][i] = 1;
            		for(new j = 0; j < MAX_PLAYERS_BC; j++) {
                        if(BC_Info[bplayer][j] != INVALID_PLAYER_ID) {
                        	printf("%d - %d",i,j);
            			    TextDrawShowForPlayer(BC_Info[bplayer][i],BCCard0[j]);
                            TextDrawShowForPlayer(BC_Info[bplayer][i],BCCard1[j]);
                        }
            		}
            		TextDrawShowForPlayer(BC_Info[bplayer][i],BCKeyCard0);
            		TextDrawShowForPlayer(BC_Info[bplayer][i],BCKeyCard1);
            		
            	}
            }
    	}
    	else if(BC_Info[bc_step] == 3) {	
    		format(string, sizeof string, "Hay mo bay hoac doi cong bo ket qua: %d giay...", BC_Info[bc_second]);
            TextDrawSetString(BCText, string);
    
            if(BC_Info[bc_second] <= 0) {
            	for(new i = 0 ; i < MAX_PLAYERS_BC; i++) {
            		if(BC_Info[bplayer_card][i] == 1) {
            			TextDrawSetString( BCCard0[i], BCString[BC_Info[bplayer_point0][i]][bc_str]);
            		    TextDrawSetString( BCCard1[i], BCString[BC_Info[bplayer_point1][i]][bc_str]);
    
            		    TextDrawSetString( BCKeyCard0, BCString[BC_Info[bc_keypoint0]][bc_str]);
            		    TextDrawSetString( BCKeyCard1, BCString[BC_Info[bc_keypoint1]][bc_str]);
    
            		    new bc_owner_total;
            		    bc_owner_total = BCString[BC_Info[bc_keypoint0]][bc_point] +  BCString[BC_Info[bc_keypoint1]][bc_point];
            		    BC_Info[bplayer_total][i] = BCString[BC_Info[bplayer_point0][i]][bc_point] +  BCString[BC_Info[bplayer_point1][i]][bc_point];
            		    if( BC_Info[bplayer_total][i] >= 10 ) {
            		    	BC_Info[bplayer_total][i] -= 10;
            		    }
            		    else if(BC_Info[bplayer_total][i] >= 20 ) {
            		    	BC_Info[bplayer_total][i] -= 20;
            		    }

            		    if(bc_owner_total >= 10 ) {
            		    	bc_owner_total -= 10;
            		    }
            		    else if(bc_owner_total >= 20 ) {
            		    	bc_owner_total -= 20;
            		    }

            		    new str[20];
    
            		    format(str, sizeof str, "%d", BC_Info[bplayer_total][i]);
            		    TextDrawSetString( BCPointText[i], str);
    
            		    for(new j = 0 ; j < MAX_PLAYERS_BC; j++) {
            		        if(BC_Info[bplayer_card][j] == 1) {
            		        	TextDrawShowForPlayer(BC_Info[bplayer][i], BCPointText[j]);
            		        }
            		    }
    
            		    BC_Info[bplayer_card][i] = 0;
    
            		    
            		   
            		    if( BC_Info[bplayer_total][i]  < bc_owner_total) {
            		    	SendClientMessage(BC_Info[bplayer][i], COLOR_WHITE2, "[BC] Ban thap diem hon nha cai vi vay ban thua.");
            		    }
            		    else if( BC_Info[bplayer_total][i]  > bc_owner_total) {
            		    	Company@AddBudget(3,- ( BC_Info[bplayer_bet][i] *2) );
            		    	GivePlayerMoneyEx(BC_Info[bplayer][i],(BC_Info[bplayer_bet][i] * 2));
            		    	format(string, sizeof string, "[BC] Ban da thang va nhan duoc so tien $%s",number_format(BC_Info[bplayer_bet][i] * 2));
            		    	SendClientMessage(BC_Info[bplayer][i], COLOR_WHITE2, string);
            		    }
            		    else if( BC_Info[bplayer_total][i]  == bc_owner_total) {
            		    	Company@AddBudget(3,-BC_Info[bplayer_bet][i] );
            		    	GivePlayerMoneyEx(BC_Info[bplayer][i],BC_Info[bplayer_bet][i]);
            		    	format(string, sizeof string, "[BC] Ban da hoa voi nha cai va nhan lai so tien $%s",number_format(BC_Info[bplayer_bet][i]) );
            		    	SendClientMessage(BC_Info[bplayer][i], COLOR_WHITE2, string);
            		    }
    
            		}
            		
    
    
            	}
            	BC_Info[bc_second] = 30;
            	BC_Info[bc_step] = 4;
            	return 1;
            }
    	}
        else if(BC_Info[bc_step] == 4) {	
    		format(string, sizeof string, "Da cong bo ket qua va trao tien tuong, Restart: %d...", BC_Info[bc_second]);
            TextDrawSetString(BCText, string);
    
            if(BC_Info[bc_second] <= 0) {
            	BC_Info[bc_second] = 30;
            	BC_Info[bc_step] = 5;
            }
    	}
    	else if(BC_Info[bc_step] == 5) {
    	    format(string, sizeof string, "Phien moi bat dau trong: %d...", BC_Info[bc_second]);
            TextDrawSetString(BCText, string);	
    		if(BC_Info[bc_second] <= 0) {
    			BC_Info[bc_keypoint0] = 0;
                BC_Info[bc_keypoint1] = 0;
    			for(new i = 0; i < MAX_PLAYERS_BC; i++) {
    				BC_Info[bplayer_point0][i] = 0;
                    BC_Info[bplayer_point1][i] = 0;
                    BC_Info[bplayer_total][i] = 0;
                    BC_Info[bplayer_card][i] = 0;
    			}
    			BC_Info[bc_second] = 60;
    			BC_Info[bc_step] = 1;
    			
    		}
    	}
	}

	return 1;
}
stock ShowUpdateBCforAll() {
	for(new i = 0 ; i < MAX_PLAYERS_BC; i++) {
		new player = BC_Info[bplayer][i];
		if(player != INVALID_PLAYER_ID) {
			TextDrawShowForPlayer(player, BCPlayerText[i]);
			TextDrawShowForPlayer(player, BCPointText[i]);
            TextDrawShowForPlayer(player, BCKeyCard0);
            TextDrawShowForPlayer(player, BCKeyCard1);
            TextDrawShowForPlayer(player, BCKeyText);
            TextDrawShowForPlayer(player, BCKeyPointText);
            TextDrawShowForPlayer(player, BCBet);
            TextDrawShowForPlayer(player, BCText);

		}
	}
}
stock BC_ClickTextDraw(playerid, Text:clickedid) {
	if(PlayerJoinBC[playerid] != -1 ) {
		new player_slot = PlayerJoinBC[playerid];
		if(clickedid == BCBet) {
			if(BC_Info[bc_step] != 1) return SendErrorMessage(playerid, " Thoi gian nay khong the dat cuoc.");
			Dialog_Show(playerid,DIALOG_BETBC,DIALOG_STYLE_INPUT,"Bai cao - Cuoc","Vui long nhap so tien ban muon dat cuoc o van nay:","Tiep tuc","Thoat");
		}

		if(clickedid == BCCard0[player_slot] && BC_Info[bc_step] == 3) {
			new point = BC_Info[bplayer_point0][player_slot];
			TextDrawSetString(BCCard0[player_slot], BCString[point][bc_str] );
		    for(new i = 0 ; i < MAX_PLAYERS_BC; i++ ) {
    	        if(BC_Info[bplayer][i] != INVALID_PLAYER_ID) {
    	        	TextDrawShowForPlayer(BC_Info[bplayer][i], BCCard0[player_slot]);
    	        }
    	    }
		}
		if(clickedid == BCCard1[player_slot] && BC_Info[bc_step] == 3) {
			new point = BC_Info[bplayer_point1][player_slot];
			TextDrawSetString(BCCard1[player_slot],  BCString[point][bc_str]);
			for(new i = 0 ; i < MAX_PLAYERS_BC; i++ ) {
    	        if(BC_Info[bplayer][i] != INVALID_PLAYER_ID) {
    	        	TextDrawShowForPlayer(BC_Info[bplayer][i], BCCard1[player_slot]);
    	        }
    	    }
		}
	}
	return 1;
}
stock ExitBC(playerid) {
	for(new i = 0 ; i < MAX_PLAYERS_BC; i++) {
		if(BC_Info[bplayer][i] != INVALID_PLAYER_ID && PlayerJoinBC[playerid] == i && BC_Info[bplayer][i ] == playerid ) {
			PlayerJoinBC[playerid] = -1;
			for(new j = 0 ; j < MAX_PLAYERS_BC ; j++) {
				if(BC_Info[bplayer][j] != INVALID_PLAYER_ID) {
					TextDrawHideForPlayer(BC_Info[bplayer][j], BCCard0[i]);
				    TextDrawHideForPlayer(BC_Info[bplayer][j], BCCard1[i]);
				}
				
			}
			
			BC_Info[bplayer_point0][i] = 0;
            BC_Info[bplayer_point1][i] = 0;
            BC_Info[bplayer_total][i] = 0;
            BC_Info[bplayer_card][i] = 0;
            BC_Info[bplayer][i] = INVALID_PLAYER_ID;
			
		}
	}
	return 1;
    
}
stock JoinBC(playerid) {
    for(new i = 0 ; i < MAX_PLAYERS_BC; i++ ) {
    	if(BC_Info[bplayer][i] == INVALID_PLAYER_ID) {
    		BC_Info[bplayer][i] = playerid;
    		PlayerJoinBC[playerid] = i;
    		BC_Info[bplayer_bet][i] = 200;

    		TextDrawShowForPlayer(playerid, BCKeyText);
    		TextDrawShowForPlayer(playerid, BCBet);
    		TextDrawShowForPlayer(playerid, BCText);
    		SelectTextDraw(playerid, COLOR_LIGHTRED);
    		break ;

    	}
    }
}
stock GetBCPlayers() {
	new player = 0;
	for(new i = 0 ; i < MAX_PLAYERS_BC; i++ ) {
		printf("%d,%d",BC_Info[bplayer][i],INVALID_PLAYER_ID);
    	if(BC_Info[bplayer][i] != INVALID_PLAYER_ID) {
    		player++;
    	}
    }
    return player;
}
stock UpdateTDBC(update = 0) {
	for(new i = 0 ; i < MAX_PLAYERS_BC; i++ ) {
		TextDrawSetString(BCPlayerText[i], "~r~Chua tham gia");
    	if(BC_Info[bplayer][i] != INVALID_PLAYER_ID) {
    		TextDrawShowForPlayer(BC_Info[bplayer][i],BCKeyText);
    		TextDrawShowForPlayer(BC_Info[bplayer][i],BCBet);
    		TextDrawShowForPlayer(BC_Info[bplayer][i],BCText);

    		new string[129];
    		format(string, sizeof string, "%s~n~Tien cuoc: $%s~n~Tien con lai: $%s", GetPlayerNameEx(BC_Info[bplayer][i]),number_format(BC_Info[bplayer_bet][i]),number_format(PlayerInfo[BC_Info[bplayer][i]][pCash]));
    		TextDrawSetString(BCPlayerText[i], string);

    		SelectTextDraw(BC_Info[bplayer][i], COLOR_LIGHTRED);
           
    		for(new j = 0 ; j < MAX_PLAYERS_BC; j++) {
               TextDrawShowForPlayer(BC_Info[bplayer][i],BCPlayerText[j]);
                if(BC_Info[bplayer_card][j] != 0) {
            	    if(update == 1) {
            			new point = BC_Info[bplayer_point0][j];
                       	TextDrawSetString(BCCard0[j], BCString[point][bc_str] );
                        new point1 = BC_Info[bplayer_point1][j];
                       	TextDrawSetString(BCCard1[j],  BCString[point1][bc_str]);
            		}
            		TextDrawShowForPlayer(BC_Info[bplayer][i],BCCard0[j]);
            		TextDrawShowForPlayer(BC_Info[bplayer][i],BCCard1[j]);
            	}
            } 
    	}
    }

}
CMD:thoatbaicao(playerid) {
	if( PlayerJoinBC[playerid] == -1) return SendErrorMessage(playerid," Ban khong tham gia ban bai cao nao.");
	ExitBC(playerid);
	for(new i = 0 ; i < MAX_PLAYERS_BC; i++) {
		TextDrawHideForPlayer(playerid, BCCard0[i]);
        TextDrawHideForPlayer(playerid, BCCard1[i]);
        TextDrawHideForPlayer(playerid, BCPlayerText[i]);
        TextDrawHideForPlayer(playerid, BCPointText[i]); 
	}
	TextDrawHideForPlayer(playerid, BCKeyCard0); 
	TextDrawHideForPlayer(playerid, BCKeyCard1); 
	TextDrawHideForPlayer(playerid, BCKeyText); 
	TextDrawHideForPlayer(playerid, BCKeyPointText); 
	TextDrawHideForPlayer(playerid, BCBet); 
	TextDrawHideForPlayer(playerid, BCText); 
	CancelSelectTextDraw(playerid);

	return 1;
}
CMD:makebaicao(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] >= 99999)
	{
		new string[128], giveplayerid;
		if(sscanf(params, "u", giveplayerid )) return SendUsageMessage(playerid, " /makemech [player] ");
		if(IsPlayerConnected(giveplayerid))
		{
			PlayerInfo[giveplayerid][pCompany] = 3;
			PlayerInfo[giveplayerid][pRank] = 6;
			format(string, sizeof(string), "[CASINO] Ban da set Company Casino cho %s.",GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			format(string, sizeof(string), "[CASINO] Ban da duoc set Company Casino boi %s.", GetPlayerNameEx(playerid));
		}
	}
	else
	{
		SendErrorMessage(playerid, "Ban khong the su dung lenh nay");
	}
	return 1;
}
CMD:choibaicao(playerid) {
	if(PlayerJoinBC[playerid] != -1) return SendErrorMessage(playerid, " Ban da tham gia bai cao.");
	if(IsPlayerInRangeOfPoint(playerid, 5, -225.742004, 1396.239990, 27.703796)) {
		if(PlayerInfo[playerid][pCash] < 200) return SendErrorMessage(playerid," Ban khong du tien de tham gia.");
		new string[129];
	    format(string, sizeof string, "Bai cao: %d/%d nguoi dang tham gia.!", GetBCPlayers(),MAX_PLAYERS_BC);
	    Dialog_Show(playerid, DIALOG_BAICAO, DIALOG_STYLE_MSGBOX, "#Bai cao", string, "Tham gia", "Thoat");
	}
	return 1;
}

CMD:thiencuozgstart(playerid) {
	StartBC();
	return 1;
}
hook OnPlayerDisconnect(playerid, reason) {
	ExitBC(playerid);
}
hook OnPlayerConnect(playerid) {
	PlayerJoinBC[playerid] = -1;
	RemoveBuildingForPlayer(playerid, 2964, -225.742, 1396.239, 27.343, 0.250);
	CreateDynamic3DTextLabel("<CASINO> /choibaicao de tham gia & /thoatbaicao de thoat", COLOR_WHITE2, -225.742, 1396.239, 27.343,30);
}
Dialog:DIALOG_BETBC(playerid, response, listitem, inputtext[]) {
	if(response) {
		new player_slot = PlayerJoinBC[playerid];
		if(strval(inputtext) < 0 || strval(inputtext) > 10000) return SendErrorMessage(playerid, " So tien cuoc phai tu $0-$10.000");
		if(PlayerInfo[playerid][pCash] < strval(inputtext)) return SendErrorMessage(playerid, " Ban khong du so tien de dat cuoc.");
		BC_Info[bplayer_bet][player_slot] = strval(inputtext);
	}
	  
	return 1;
}
Dialog:DIALOG_BAICAO(playerid, response, listitem, inputtext[]) {
	if(response) {
		printf("%d/%d",GetBCPlayers(),MAX_PLAYERS_BC);
		if(GetBCPlayers() < MAX_PLAYERS_BC) {
	    	JoinBC(playerid);
	    } 
	    else SendErrorMessage(playerid, " So nguoi tham gia da dat den gioi han.");
	}
	  
	return 1;
}
// Ãëîáàëüíûå òåêñòäðàâû
hook OnGameModeInit() {
StartBC();
CreateDynamicObject(19474, -225.742004, 1396.239990, 27.703796, 0.000000, 0.000000, 89.999984, -1, -1, -1, 300.00, 300.00);
BCCard0[0] = TextDrawCreate(107.9166, 273.7406, "ld_card:cdback"); // ïóñòî
TextDrawTextSize(BCCard0[0], 38.0000, 56.0000);
TextDrawAlignment(BCCard0[0], 1);
TextDrawColor(BCCard0[0], -1);
TextDrawBackgroundColor(BCCard0[0], 255);
TextDrawFont(BCCard0[0], 4);
TextDrawSetProportional(BCCard0[0], 0);
TextDrawSetShadow(BCCard0[0], 0);
TextDrawSetSelectable(BCCard0[0], true);

BCCard1[0] = TextDrawCreate(146.6499, 273.7406, "ld_card:cdback"); // ïóñòî
TextDrawTextSize(BCCard1[0], 38.0000, 56.0000);
TextDrawAlignment(BCCard1[0], 1);
TextDrawColor(BCCard1[0], -1);
TextDrawBackgroundColor(BCCard1[0], 255);
TextDrawFont(BCCard1[0], 4);
TextDrawSetProportional(BCCard1[0], 0);
TextDrawSetShadow(BCCard1[0], 0);
TextDrawSetSelectable(BCCard1[0], true);

BCPlayerText[0] = TextDrawCreate(146.0832, 333.5111, "Player_1~n~~g~$10,000"); // ïóñòî
TextDrawLetterSize(BCPlayerText[0], 0.2158, 1.2733);
TextDrawTextSize(BCPlayerText[0], 0.0000, 74.0000);
TextDrawAlignment(BCPlayerText[0], 2);
TextDrawColor(BCPlayerText[0], -1);
TextDrawUseBox(BCPlayerText[0], 1);
TextDrawBoxColor(BCPlayerText[0], 151587324);
TextDrawBackgroundColor(BCPlayerText[0], 255);
TextDrawFont(BCPlayerText[0], 1);
TextDrawSetProportional(BCPlayerText[0], 1);
TextDrawSetShadow(BCPlayerText[0], 0);

BCPointText[0] = TextDrawCreate(134.1667, 285.9259, "~r~18"); // ïóñòî
TextDrawLetterSize(BCPointText[0], 0.6607, 3.1710);
TextDrawAlignment(BCPointText[0], 1);
TextDrawColor(BCPointText[0], -1);
TextDrawBackgroundColor(BCPointText[0], 255);
TextDrawFont(BCPointText[0], 3);
TextDrawSetProportional(BCPointText[0], 1);
TextDrawSetShadow(BCPointText[0], 1);

BCCard0[1] = TextDrawCreate(208.0007, 273.5405, "ld_card:cdback"); // ïóñòî
TextDrawTextSize(BCCard0[1], 38.0000, 56.0000);
TextDrawAlignment(BCCard0[1], 1);
TextDrawColor(BCCard0[1], -1);
TextDrawBackgroundColor(BCCard0[1], 255);
TextDrawFont(BCCard0[1], 4);
TextDrawSetProportional(BCCard0[1], 0);
TextDrawSetShadow(BCCard0[1], 0);
TextDrawSetSelectable(BCCard0[1], true);

BCCard1[1] = TextDrawCreate(246.6840, 273.5591, "ld_card:cdback"); // ïóñòî
TextDrawTextSize(BCCard1[1], 38.0000, 56.0000);
TextDrawAlignment(BCCard1[1], 1);
TextDrawColor(BCCard1[1], -1);
TextDrawBackgroundColor(BCCard1[1], 255);
TextDrawFont(BCCard1[1], 4);
TextDrawSetProportional(BCCard1[1], 0);
TextDrawSetShadow(BCCard1[1], 0);
TextDrawSetSelectable(BCCard1[1], true);

BCPlayerText[1] = TextDrawCreate(246.3000, 333.3110, "Player_1~n~~g~$10,000"); // ïóñòî
TextDrawLetterSize(BCPlayerText[1], 0.2158, 1.2733);
TextDrawTextSize(BCPlayerText[1], 0.0000, 74.0000);
TextDrawAlignment(BCPlayerText[1], 2);
TextDrawColor(BCPlayerText[1], -1);
TextDrawUseBox(BCPlayerText[1], 1);
TextDrawBoxColor(BCPlayerText[1], 151587324);
TextDrawBackgroundColor(BCPlayerText[1], 255);
TextDrawFont(BCPlayerText[1], 1);
TextDrawSetProportional(BCPlayerText[1], 1);
TextDrawSetShadow(BCPlayerText[1], 0);

BCPointText[1] = TextDrawCreate(232.0834, 282.8147, "~r~18"); // ïóñòî
TextDrawLetterSize(BCPointText[1], 0.6607, 3.1710);
TextDrawAlignment(BCPointText[1], 1);
TextDrawColor(BCPointText[1], -1);
TextDrawBackgroundColor(BCPointText[1], 255);
TextDrawFont(BCPointText[1], 3);
TextDrawSetProportional(BCPointText[1], 1);
TextDrawSetShadow(BCPointText[1], 1);

BCCard0[2] = TextDrawCreate(307.1672, 273.5220, "ld_card:cdback"); // ïóñòî
TextDrawTextSize(BCCard0[2], 38.0000, 56.0000);
TextDrawAlignment(BCCard0[2], 1);
TextDrawColor(BCCard0[2], -1);
TextDrawBackgroundColor(BCCard0[2], 255);
TextDrawFont(BCCard0[2], 4);
TextDrawSetProportional(BCCard0[2], 0);
TextDrawSetShadow(BCCard0[2], 0);
TextDrawSetSelectable(BCCard0[2], true);

BCCard1[2] = TextDrawCreate(346.0339, 273.7406, "ld_card:cdback"); // ïóñòî
TextDrawTextSize(BCCard1[2], 38.0000, 56.0000);
TextDrawAlignment(BCCard1[2], 1);
TextDrawColor(BCCard1[2], -1);
TextDrawBackgroundColor(BCCard1[2], 255);
TextDrawFont(BCCard1[2], 4);
TextDrawSetProportional(BCCard1[2], 0);
TextDrawSetShadow(BCCard1[2], 0);
TextDrawSetSelectable(BCCard1[2], true);

BCPlayerText[2] = TextDrawCreate(345.5667, 332.5553, "Player_1~n~~g~$10,000"); // ïóñòî
TextDrawLetterSize(BCPlayerText[2], 0.2158, 1.2733);
TextDrawTextSize(BCPlayerText[2], 0.0000, 74.0000);
TextDrawAlignment(BCPlayerText[2], 2);
TextDrawColor(BCPlayerText[2], -1);
TextDrawUseBox(BCPlayerText[2], 1);
TextDrawBoxColor(BCPlayerText[2], 151587324);
TextDrawBackgroundColor(BCPlayerText[2], 255);
TextDrawFont(BCPlayerText[2], 1);
TextDrawSetProportional(BCPlayerText[2], 1);
TextDrawSetShadow(BCPlayerText[2], 0);

BCPointText[2] = TextDrawCreate(332.7999, 281.9961, "~r~18"); // ïóñòî
TextDrawLetterSize(BCPointText[2], 0.6607, 3.1710);
TextDrawAlignment(BCPointText[2], 1);
TextDrawColor(BCPointText[2], -1);
TextDrawBackgroundColor(BCPointText[2], 255);
TextDrawFont(BCPointText[2], 3);
TextDrawSetProportional(BCPointText[2], 1);
TextDrawSetShadow(BCPointText[2], 1);

BCCard0[3] = TextDrawCreate(406.2503, 273.9591, "ld_card:cdback"); // ïóñòî
TextDrawTextSize(BCCard0[3], 38.0000, 56.0000);
TextDrawAlignment(BCCard0[3], 1);
TextDrawColor(BCCard0[3], -1);
TextDrawBackgroundColor(BCCard0[3], 255);
TextDrawFont(BCCard0[3], 4);
TextDrawSetProportional(BCCard0[3], 0);
TextDrawSetShadow(BCCard0[3], 0);
TextDrawSetSelectable(BCCard0[3], true);

BCCard1[3] = TextDrawCreate(445.8836, 273.9591, "ld_card:cdback"); // ïóñòî
TextDrawTextSize(BCCard1[3], 38.0000, 56.0000);
TextDrawAlignment(BCCard1[3], 1);
TextDrawColor(BCCard1[3], -1);
TextDrawBackgroundColor(BCCard1[3], 255);
TextDrawFont(BCCard1[3], 4);
TextDrawSetProportional(BCCard1[3], 0);
TextDrawSetShadow(BCCard1[3], 0);
TextDrawSetSelectable(BCCard1[3], true);

BCPlayerText[3] = TextDrawCreate(444.9833, 332.6849, "Player_1~n~~g~$10,000"); // ïóñòî
TextDrawLetterSize(BCPlayerText[3], 0.2158, 1.2733);
TextDrawTextSize(BCPlayerText[3], 0.0000, 74.0000);
TextDrawAlignment(BCPlayerText[3], 2);
TextDrawColor(BCPlayerText[3], -1);
TextDrawUseBox(BCPlayerText[3], 1);
TextDrawBoxColor(BCPlayerText[3], 151587324);
TextDrawBackgroundColor(BCPlayerText[3], 255);
TextDrawFont(BCPlayerText[3], 1);
TextDrawSetProportional(BCPlayerText[3], 1);
TextDrawSetShadow(BCPlayerText[3], 0);

BCPointText[3] = TextDrawCreate(433.1000, 280.7962, "~r~18"); // ïóñòî
TextDrawLetterSize(BCPointText[3], 0.6607, 3.1710);
TextDrawAlignment(BCPointText[3], 1);
TextDrawColor(BCPointText[3], -1);
TextDrawBackgroundColor(BCPointText[3], 255);
TextDrawFont(BCPointText[3], 3);
TextDrawSetProportional(BCPointText[3], 1);
TextDrawSetShadow(BCPointText[3], 1);

BCCard0[4] = TextDrawCreate(506.2503, 192.5516, "ld_card:cdback"); // ïóñòî
TextDrawTextSize(BCCard0[4], 38.0000, 56.0000);
TextDrawAlignment(BCCard0[4], 1);
TextDrawColor(BCCard0[4], -1);
TextDrawBackgroundColor(BCCard0[4], 255);
TextDrawFont(BCCard0[4], 4);
TextDrawSetProportional(BCCard0[4], 0);
TextDrawSetShadow(BCCard0[4], 0);
TextDrawSetSelectable(BCCard0[4], true);

BCCard1[4] = TextDrawCreate(544.7171, 192.6963, "ld_card:cdback"); // ïóñòî
TextDrawTextSize(BCCard1[4], 38.0000, 56.0000);
TextDrawAlignment(BCCard1[4], 1);
TextDrawColor(BCCard1[4], -1);
TextDrawBackgroundColor(BCCard1[4], 255);
TextDrawFont(BCCard1[4], 4);
TextDrawSetProportional(BCCard1[4], 0);
TextDrawSetShadow(BCCard1[4], 0);
TextDrawSetSelectable(BCCard1[4], true);

BCPlayerText[4] = TextDrawCreate(544.9832, 252.0514, "Player_1~n~~g~$10,000"); // ïóñòî
TextDrawLetterSize(BCPlayerText[4], 0.2158, 1.2733);
TextDrawTextSize(BCPlayerText[4], 0.0000, 74.0000);
TextDrawAlignment(BCPlayerText[4], 2);
TextDrawColor(BCPlayerText[4], -1);
TextDrawUseBox(BCPlayerText[4], 1);
TextDrawBoxColor(BCPlayerText[4], 151587324);
TextDrawBackgroundColor(BCPlayerText[4], 255);
TextDrawFont(BCPlayerText[4], 1);
TextDrawSetProportional(BCPlayerText[4], 1);
TextDrawSetShadow(BCPlayerText[4], 0);

BCPointText[4] = TextDrawCreate(535.2000, 199.3887, "~r~18"); // ïóñòî
TextDrawLetterSize(BCPointText[4], 0.6607, 3.1710);
TextDrawAlignment(BCPointText[4], 1);
TextDrawColor(BCPointText[4], -1);
TextDrawBackgroundColor(BCPointText[4], 255);
TextDrawFont(BCPointText[4], 3);
TextDrawSetProportional(BCPointText[4], 1);
TextDrawSetShadow(BCPointText[4], 1);

BCCard0[5] = TextDrawCreate(460.8337, 91.6849, "ld_card:cdback"); // ïóñòî
TextDrawTextSize(BCCard0[5], 38.0000, 56.0000);
TextDrawAlignment(BCCard0[5], 1);
TextDrawColor(BCCard0[5], -1);
TextDrawBackgroundColor(BCCard0[5], 255);
TextDrawFont(BCCard0[5], 4);
TextDrawSetProportional(BCCard0[5], 0);
TextDrawSetShadow(BCCard0[5], 0);
TextDrawSetSelectable(BCCard0[5], true);

BCCard1[5] = TextDrawCreate(499.1669, 91.8072, "ld_card:cdback"); // ïóñòî
TextDrawTextSize(BCCard1[5], 38.0000, 56.0000);
TextDrawAlignment(BCCard1[5], 1);
TextDrawColor(BCCard1[5], -1);
TextDrawBackgroundColor(BCCard1[5], 255);
TextDrawFont(BCCard1[5], 4);
TextDrawSetProportional(BCCard1[5], 0);
TextDrawSetShadow(BCCard1[5], 0);
TextDrawSetSelectable(BCCard1[5], true);


BCPlayerText[5] = TextDrawCreate(499.1834, 151.0957, "Player_1~n~~g~$10,000"); // ïóñòî
TextDrawLetterSize(BCPlayerText[5], 0.2158, 1.2733);
TextDrawTextSize(BCPlayerText[5], 0.0000, 74.0000);
TextDrawAlignment(BCPlayerText[5], 2);
TextDrawColor(BCPlayerText[5], -1);
TextDrawUseBox(BCPlayerText[5], 1);
TextDrawBoxColor(BCPlayerText[5], 151587324);
TextDrawBackgroundColor(BCPlayerText[5], 255);
TextDrawFont(BCPlayerText[5], 1);
TextDrawSetProportional(BCPlayerText[5], 1);
TextDrawSetShadow(BCPlayerText[5], 0);

BCPointText[5] = TextDrawCreate(487.2835, 98.7960, "~r~18"); // ïóñòî
TextDrawLetterSize(BCPointText[5], 0.6607, 3.1710);
TextDrawAlignment(BCPointText[5], 1);
TextDrawColor(BCPointText[5], -1);
TextDrawBackgroundColor(BCPointText[5], 255);
TextDrawFont(BCPointText[5], 3);
TextDrawSetProportional(BCPointText[5], 1);
TextDrawSetShadow(BCPointText[5], 1);

BCCard0[6] = TextDrawCreate(23.7504, 197.9813, "ld_card:cdback"); // ïóñòî
TextDrawTextSize(BCCard0[6], 38.0000, 56.0000);
TextDrawAlignment(BCCard0[6], 1);
TextDrawColor(BCCard0[6], -1);
TextDrawBackgroundColor(BCCard0[6], 255);
TextDrawFont(BCCard0[6], 4);
TextDrawSetProportional(BCCard0[6], 0);
TextDrawSetShadow(BCCard0[6], 0);
TextDrawSetSelectable(BCCard0[6], true);

BCCard1[6] = TextDrawCreate(62.8336, 197.9813, "ld_card:cdback"); // ïóñòî
TextDrawTextSize(BCCard1[6], 38.0000, 56.0000);
TextDrawAlignment(BCCard1[6], 1);
TextDrawColor(BCCard1[6], -1);
TextDrawBackgroundColor(BCCard1[6], 255);
TextDrawFont(BCCard1[6], 4);
TextDrawSetProportional(BCCard1[6], 0);
TextDrawSetShadow(BCCard1[6], 0);
TextDrawSetSelectable(BCCard1[6], true);

BCPlayerText[6] = TextDrawCreate(62.3666, 257.3103, "Player_1~n~~g~$10,000"); // ïóñòî
TextDrawLetterSize(BCPlayerText[6], 0.2158, 1.2733);
TextDrawTextSize(BCPlayerText[6], 0.0000, 74.0000);
TextDrawAlignment(BCPlayerText[6], 2);
TextDrawColor(BCPlayerText[6], -1);
TextDrawUseBox(BCPlayerText[6], 1);
TextDrawBoxColor(BCPlayerText[6], 151587324);
TextDrawBackgroundColor(BCPlayerText[6], 255);
TextDrawFont(BCPlayerText[6], 1);
TextDrawSetProportional(BCPlayerText[6], 1);
TextDrawSetShadow(BCPlayerText[6], 0);

BCPointText[6] = TextDrawCreate(49.3670, 208.2035, "~r~18"); // ïóñòî
TextDrawLetterSize(BCPointText[6], 0.6607, 3.1710);
TextDrawAlignment(BCPointText[6], 1);
TextDrawColor(BCPointText[6], -1);
TextDrawBackgroundColor(BCPointText[6], 255);
TextDrawFont(BCPointText[6], 3);
TextDrawSetProportional(BCPointText[6], 1);
TextDrawSetShadow(BCPointText[6], 1);

BCCard0[7] = TextDrawCreate(85.0503, 93.7592, "ld_card:cdback"); // ïóñòî
TextDrawTextSize(BCCard0[7], 38.0000, 56.0000);
TextDrawAlignment(BCCard0[7], 1);
TextDrawColor(BCCard0[7], -1);
TextDrawBackgroundColor(BCCard0[7], 255);
TextDrawFont(BCCard0[7], 4);
TextDrawSetProportional(BCCard0[7], 0);
TextDrawSetShadow(BCCard0[7], 0);
TextDrawSetSelectable(BCCard0[7], true);

BCCard1[7] = TextDrawCreate(123.5170, 93.7220, "ld_card:cdback"); // ïóñòî
TextDrawTextSize(BCCard1[7], 38.0000, 56.0000);
TextDrawAlignment(BCCard1[7], 1);
TextDrawColor(BCCard1[7], -1);
TextDrawBackgroundColor(BCCard1[7], 255);
TextDrawFont(BCCard1[7], 4);
TextDrawSetProportional(BCCard1[7], 0);
TextDrawSetShadow(BCCard1[7], 0);
TextDrawSetSelectable(BCCard1[7], true);

BCPlayerText[7] = TextDrawCreate(123.3499, 153.1437, "Player_1~n~~g~$10,000"); // ïóñòî
TextDrawLetterSize(BCPlayerText[7], 0.2158, 1.2733);
TextDrawTextSize(BCPlayerText[7], 0.0000, 74.0000);
TextDrawAlignment(BCPlayerText[7], 2);
TextDrawColor(BCPlayerText[7], -1);
TextDrawUseBox(BCPlayerText[7], 1);
TextDrawBoxColor(BCPlayerText[7], 151587324);
TextDrawBackgroundColor(BCPlayerText[7], 255);
TextDrawFont(BCPlayerText[7], 1);
TextDrawSetProportional(BCPlayerText[7], 1);
TextDrawSetShadow(BCPlayerText[7], 0);

BCPointText[7] = TextDrawCreate(108.5335, 106.5739, "~r~18"); // ïóñòî
TextDrawLetterSize(BCPointText[7], 0.6607, 3.1710);
TextDrawAlignment(BCPointText[7], 1);
TextDrawColor(BCPointText[7], -1);
TextDrawBackgroundColor(BCPointText[7], 255);
TextDrawFont(BCPointText[7], 3);
TextDrawSetProportional(BCPointText[7], 1);
TextDrawSetShadow(BCPointText[7], 1);

BCKeyCard0 = TextDrawCreate(271.4838, 128.2812, "ld_card:cdback"); // ïóñòî
TextDrawTextSize(BCKeyCard0, 38.0000, 56.0000);
TextDrawAlignment(BCKeyCard0, 1);
TextDrawColor(BCKeyCard0, -1);
TextDrawBackgroundColor(BCKeyCard0, 255);
TextDrawFont(BCKeyCard0, 4);
TextDrawSetProportional(BCKeyCard0, 0);
TextDrawSetShadow(BCKeyCard0, 0);
TextDrawSetSelectable(BCKeyCard0, true);

BCKeyCard1 = TextDrawCreate(310.0505, 128.4998, "ld_card:cdback"); // ïóñòî
TextDrawTextSize(BCKeyCard1, 38.0000, 56.0000);
TextDrawAlignment(BCKeyCard1, 1);
TextDrawColor(BCKeyCard1, -1);
TextDrawBackgroundColor(BCKeyCard1, 255);
TextDrawFont(BCKeyCard1, 4);
TextDrawSetProportional(BCKeyCard1, 0);
TextDrawSetShadow(BCKeyCard1, 0);
TextDrawSetSelectable(BCKeyCard1, true);

BCKeyText = TextDrawCreate(309.5166, 187.7953, "Nha_cai"); // ïóñòî
TextDrawLetterSize(BCKeyText, 0.2158, 1.2733);
TextDrawTextSize(BCKeyText, 0.0000, 74.0000);
TextDrawAlignment(BCKeyText, 2);
TextDrawColor(BCKeyText, -1);
TextDrawUseBox(BCKeyText, 1);
TextDrawBoxColor(BCKeyText, 151587324);
TextDrawBackgroundColor(BCKeyText, 255);
TextDrawFont(BCKeyText, 1);
TextDrawSetProportional(BCKeyText, 1);
TextDrawSetShadow(BCKeyText, 0);

BCKeyPointText = TextDrawCreate(298.1169, 138.2035, "~g~18"); // ïóñòî
TextDrawLetterSize(BCKeyPointText, 0.6607, 3.1710);
TextDrawAlignment(BCKeyPointText, 1);
TextDrawColor(BCKeyPointText, -1);
TextDrawBackgroundColor(BCKeyPointText, 255);
TextDrawFont(BCKeyPointText, 3);
TextDrawSetProportional(BCKeyPointText, 1);
TextDrawSetShadow(BCKeyPointText, 1);

BCBet = TextDrawCreate(309.1000, 203.5509, "~r~Dat_cuoc"); // ïóñòî
TextDrawLetterSize(BCBet, 0.2158, 1.2733);
TextDrawTextSize(BCBet, 20.0000, 74.0000);
TextDrawAlignment(BCBet, 2);
TextDrawColor(BCBet, -1);
TextDrawUseBox(BCBet, 1);
TextDrawBoxColor(BCBet, 151587324);
TextDrawBackgroundColor(BCBet, 255);
TextDrawFont(BCBet, 1);
TextDrawSetProportional(BCBet, 1);
TextDrawSetShadow(BCBet, 0);
TextDrawSetSelectable(BCBet,1);

BCText = TextDrawCreate(310.0000, 232.5184, "Dang_chia_bai...."); // ïóñòî
TextDrawLetterSize(BCText, 0.2278, 1.1176);
TextDrawTextSize(BCText, 0.0000, 56.0000);
TextDrawAlignment(BCText, 2);
TextDrawColor(BCText, -1);
TextDrawSetOutline(BCText, 1);
TextDrawBackgroundColor(BCText, 255);
TextDrawFont(BCText, 1);
TextDrawSetProportional(BCText, 1);
TextDrawSetShadow(BCText, 0);

}