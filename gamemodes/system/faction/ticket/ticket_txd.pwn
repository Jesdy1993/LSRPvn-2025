#include <YSI_Coding\y_hooks>

new PlayerText:ticket_txd[MAX_PLAYERS][17],
	playerTicketTXD[MAX_PLAYERS];

hook OnPlayerConnect(playerid)
{
	playerTicketTXD[playerid] = 0;

	return 1;
}

hook OnPlayerDisconnect(playerid)
{
	playerTicketTXD[playerid] = 0;

	return 1;
}

CMD:myticket(playerid,params[]) {
	ShowPlayerTicketMenu(playerid);
	return 1;
}


stock UpdatePlayerTicketTXD(playerid)
{
    new  officerid,  reason[129];
    officerid = TicketOffer[playerid];
    GetPVarString(playerid,  #TicketReason, reason, sizeof(reason));
	new string[2024];

	new Float: x, 
	    Float: y, 
	    Float: z,
	    location[MAX_ZONE_NAME];


	GetPlayerPos(playerid, x, y, z);
	GetPlayer3DZone(playerid, location, sizeof(location));

	format(string,sizeof string, "#\t#\t#\n\
		==========\tTICKET\t=========\n\
		Thoi gian vi pham:\t\t%s\n\
		Nguoi ra quyet dinh:\t\t%s (MH: %s)\n\
		Dia diem:\t\t%s, Los Santos\n\
		Nguoi vi pham:\t\t%s\n\
		Ngay sinh:\t\t %s\n\
		Gioi tinh:\t\t%s\n\
		Noi dung vi pham:\t\t%s\n\
		So tien nop phat:\t\t$%s\n\
		==========\tXAC NHAN TICKET\t==========",
		date(gettime()+25200),
		GetPlayerNameEx(officerid),
	    PlayerInfo[officerid][pMPH],
	    location,
	    GetPlayerNameEx(playerid),
	    PlayerInfo[playerid][pBirthDate],
	    (PlayerInfo[playerid][pSex] == 1) ? "Nam" : "Nu",
	    reason,
	    number_format(TicketMoney[playerid]) );

    Dialog_Show(playerid, DIALOG_GTICKET, DIALOG_STYLE_TABLIST_HEADERS, "LOS SANTOS POLICE DEPARTMENT - Ticket", string, "Dong y", "Tu choi");
    return 1;
}
Dialog:DIALOG_GTICKET(playerid, response, listitem, inputtext[]) 
{
	if(listitem == 9) {
		new string[1024];
	    printf("time accept = %d > %d",GetPVarInt(playerid, #TimeAcceptTicket) , gettime());
	    if(GetPVarInt(playerid, #TimeAcceptTicket) > gettime() ) 
	    {
	    	new str[129];
	    	format(str, sizeof str,  " Ban phai cho %d giay moi co the chap nhan ve phat.", GetPVarInt(playerid, #TimeAcceptTicket) - gettime() );
	    	// SendErrorMessage(playerid, str);
	    	SendClientMessageEx(playerid,COLOR_BASIC,str);
	    	return 1;
	    }
        if(response)
        {
        	if(TicketOffer[playerid] == INVALID_PLAYER_ID) return SendErrorMessage(playerid," Da co loi xay ra...");
        	if(IsPlayerConnected(TicketOffer[playerid])) 
            {
                if(ProxDetectorS(5.0, playerid, TicketOffer[playerid])) 
                {
                    format(string, sizeof(string), "* %s da ky vao ve phat cua %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(TicketOffer[playerid]));
                    ProxDetector(15.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

                    format(string, sizeof(string), "* Ban da chap nhan ve phat cua Officer %s, hay den Police Station de nop phat trong vong 3 ngay, ke tu bay gio.", GetPlayerNameEx(TicketOffer[playerid]));
                    SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);

                    format(string, sizeof(string), "* %s da chap nhan ve phat ma ban da viet cho ho.", GetPlayerNameEx(playerid));
                    SendClientMessageEx(TicketOffer[playerid], COLOR_LIGHTBLUE, string);        

                    new reason[64];
                    GetPVarString(playerid, #TicketReason, reason, sizeof(reason));
                    SetPlayerTicketData(playerid, TicketMoney[playerid], reason, TicketOffer[playerid]);
                    
                    TicketOffer[playerid] = INVALID_PLAYER_ID;            
                    TicketMoney[playerid] = 0;
                }
                else
                {
                    format(string, sizeof(string), "~w~Ban khong dung gan ~y~Officer %s", GetPlayerNameEx(TicketOffer[playerid]));
                    return ShowNotifyTextMain(playerid, string);
                }
            }
        }
        else {
        	if(IsPlayerConnected(TicketOffer[playerid])) 
            {
                format(string, sizeof(string), "* %s da tra lai ve phat cho %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(TicketOffer[playerid]));
                ProxDetector(15.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

                format(string, sizeof(string), "* Ban da tu choi ve phat cua Officer %s..", GetPlayerNameEx(TicketOffer[playerid]));
                SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);

                format(string, sizeof(string), "* %s da tu choi ve phat ma ban da ghi.", GetPlayerNameEx(playerid));
                SendClientMessageEx(TicketOffer[playerid], COLOR_LIGHTRED, string);        

                TicketOffer[playerid] = INVALID_PLAYER_ID;            
                TicketMoney[playerid] = 0;
                DeletePVar(playerid, #TicketReason);
            }
        }
	}
	else {
		UpdatePlayerTicketTXD(playerid);
	}
	
    return 1;
}