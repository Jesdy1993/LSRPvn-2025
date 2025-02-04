
#include <YSI_Coding\y_hooks>

hook OnPlayerConnect(playerid)
{
    TicketOffer[playerid] = INVALID_PLAYER_ID;            
    TicketMoney[playerid] = 0;
    DeletePVar(playerid, #TicketReason);
    DeletePVar(playerid, "getTicketID");
}

hook OnPlayerDisconnect(playerid)
{
    TicketOffer[playerid] = INVALID_PLAYER_ID;            
    TicketMoney[playerid] = 0;
    DeletePVar(playerid, #TicketReason);
    DeletePVar(playerid, "getTicketID");
}

CMD:ticket(playerid, params[])
{
    if(IsACop(playerid))
    {
        
        new string[1024], giveplayerid, price, reason[128];
        if(sscanf(params, "uds[128]", giveplayerid, price, reason)) return SendUsageMessage(playerid, "  /ticket [playerid] [price] [reason]");

        if(giveplayerid == playerid) return ShowNotifyTextMain(playerid, "~w~Ban khong the thuc hienh lenh nay voi chinh minh.");
        if(price < 1 || price > 10000) return ShowNotifyTextMain(playerid, "~w~Toi da muc phat toi thieu ~r~$1~w~ va toi da ~r~$10,000~w~.");
        if(IsPlayerConnected(giveplayerid))
        {
            if(giveplayerid != INVALID_PLAYER_ID)
            {
                if(ProxDetectorS(8.0, playerid, giveplayerid))
                {
               		format(string, sizeof(string), "* %s da viet mot ve phat va dua cho %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
                    ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

                    format(string, sizeof(string), "* Ban da dua cho %s mot ve phat co muc phat la $%s, ly do: %s", GetPlayerNameEx(giveplayerid), number_format(price), reason);
                    SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);

                    format(string, sizeof(string), "* Officer %s da dua cho ban mot ve phat voi muc phat la $%s, ly do: %s", GetPlayerNameEx(playerid), number_format(price), reason);
                    SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
                    
                    TicketOffer[giveplayerid] = playerid;            
                    
                    TicketMoney[giveplayerid] = price;

                   	SetPVarString(giveplayerid, #TicketReason, reason);

                    SetPVarInt(playerid, #TimeAcceptTicket, 10 + gettime());
                    // SetPVarInt(playerid, #TicketOfficer, officerid);

                    // SetPVarString(playerid, #TicketPrice, price);
                    // SetPVarString(playerid, #TicketReason, reason);

                    UpdatePlayerTicketTXD(giveplayerid);
                }
                else
                {
                    format(string, sizeof(string), "~w~Ban khong dung gan ~y~%s~w~ de thuc hien lenh nay.", GetPlayerNameEx(giveplayerid));
                    return ShowNotifyTextMain(playerid, string);
                }
            }
        }
        else
        {
            SendErrorMessage(playerid, "  nguoi choi khong hop le.");
            return 1;
        }
    }
    return 1;
}


task playerTicket[1000]()
{
    new string[514];
    foreach(new i: Player)
    {
        if(TicketOffer[i] != INVALID_PLAYER_ID && TicketMoney[i] != 0)
        {
            if(!ProxDetectorS(15.0, i, TicketOffer[i])) 
            {
                format(string, sizeof(string), "* %s da vut lai ve phat cho %s.", GetPlayerNameEx(i), GetPlayerNameEx(TicketOffer[i]));
                ProxDetector(15.0, i, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

                format(string, sizeof(string), "* Ban da tu choi ve phat cua Officer %s.", GetPlayerNameEx(TicketOffer[i]));
                SendClientMessageEx(i, COLOR_LIGHTBLUE, string);

                format(string, sizeof(string), "* %s da tu choi ve phat ma ban da ghi. (Nguoi do da di qua xa)", GetPlayerNameEx(i));
                SendClientMessageEx(TicketOffer[i], COLOR_LIGHTRED, string);        

                TicketOffer[i] = INVALID_PLAYER_ID;            
                TicketMoney[i] = 0;
                DeletePVar(i, #TicketReason);
            }
        }
    }
    return 1;
}

/*
CMD:test2(playerid, params[])
{
	new i;
	if(sscanf(params, "d", i)) return SendUsageMessage(playerid, "  /test2 [id]");

	RemovePlayerTicketData(playerid, i);
	return 1;
}
*/

CMD:tickets(playerid, params[])
{
    if(!IsACop(playerid)) return ShowNotifyTextMain(playerid, "~w~Ban khong phai la ~y~Police~w~.");
    ShowNotifyTextMain(playerid, "Chuc nang dang duoc cap nhat.");
    return 1;
}