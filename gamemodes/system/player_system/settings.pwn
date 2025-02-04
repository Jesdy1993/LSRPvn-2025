
#include <YSI\y_hooks>

CMD:caidat(playerid, params[]) {
    return cmd_setting(playerid, params);
}

CMD:setting(playerid, params[])
{
    MainSettings(playerid);
    return 1;
}

stock MainSettings(playerid)
{
    new string[120];
    
    format(string, sizeof(string), "Setting for [%s]", GetPlayerNameEx(playerid));
    Dialog_Show(playerid, SettingMain, DIALOG_STYLE_LIST,
                    string,
                    "HUD Settings\n\
                     OOC Settings\n\
                     Refresh Environment Mapped",
                     ">", "<");
    return 1;
}

Dialog:SettingMain(playerid, response, listitem, inputtext[]) {
    if(response) {
        switch(listitem)
	    {           
	        case 0: // Hud Settings
	        {
	            HudSettings(playerid);
	        }
	        case 1: // OOC Settings
	        {
	            ChannelSettings(playerid);
	        }	        
	        case 2: // Refresh Environment Map
	        {
	            Dialog_Show(playerid, PressREM, DIALOG_STYLE_INPUT, 
	                                       "Setting > Refresh Environment Map",
	                                       "Vui long nhap thong so ma ban can Refresh.\n\n\
	                                        Goi y: Vui long nhap gia tri tu 100 den 10000. Gia tri cang cao thi pham vi cang xa.",
	                                       "Thiet lap", "<");
	        }
	    }
    }
    return 1;
}

Dialog:PressREM(playerid, response, listitem, inputtext[]) {
    if(response) {
        if(!IsNumeric(inputtext)) return SendClientMessage(playerid, COLOR_LIGHTRED, "Vui long nhap gia tri la so.");
        new giatri = strval(inputtext);
        if(giatri <= 100 || giatri >= 10000)
        {   
            Dialog_Show(playerid, PressREM, DIALOG_STYLE_INPUT, 
	                                       "Setting > Refresh Environment Map",
	                                       "Vui long nhap thong so ma ban can Refresh.\n\n\
	                                        Goi y: Vui long nhap gia tri tu 100 den 10000. Gia tri cang cao thi pham vi cang xa.",
	                                       "Thiet lap", "<");
            SendClientMessage(playerid, COLOR_LIGHTRED, "Gia tri toi thieu la 100 va toi da la 10000.");
            return 1;
        }
        new Float:x, Float:y, Float:z;
        Streamer_SetVisibleItems(STREAMER_TYPE_OBJECT, giatri);
        GetPlayerPos(playerid, x, y, z);
        Streamer_DestroyAllVisibleItems(playerid, STREAMER_TYPE_OBJECT);
        Streamer_UpdateEx(playerid, x, y, z, -1, -1, STREAMER_TYPE_OBJECT);
        SendClientMessageEx(playerid, COLOR_BASIC, "{D0CA8B}[Cai dat]{B4B4B4} Ban da thuc hien thao tac {6084BD}Refresh Environment Map{B4B4B4}.");
        return 1;
    }
    return 1;
}

Dialog:SettingHud(playerid, response, listitem, inputtext[]) {
    if(response) {
        switch(listitem)
        { 
            case 0: // Vehiclehud
            {   
                if(PlayerInfo[playerid][pSpeedo] == 0)
                {
                    PlayerInfo[playerid][pSpeedo] = 1;
                    SendClientMessage(playerid, COLOR_CHAT, "[Cai dat] Ban da tat chuc nang Vehicle HUD.");
                    
                }
                else
                {
                    PlayerInfo[playerid][pSpeedo] = 0;
                    SendClientMessage(playerid, COLOR_BASIC, "[Cai dat] Ban da bat chuc nang Vehicle HUD.");
                    
                }
                HudSettings(playerid);
            }
            case 1: // Hunger
            {   
                if(PlayerInfo[playerid][pHudUI] == 0)
                {

                    PlayerInfo[playerid][pHudUI] = 1;                 
                    for(new i = 0 ; i < 9 ; i++) PlayerTextDrawHide(playerid, Hunger_remake_PTD[playerid][i]);
                    SendClientMessage(playerid, COLOR_BASIC, "[Cai dat] Ban da tat chuc nang Hunger & Thirsty Stats.");
                }
                else
                {
                    PlayerInfo[playerid][pHudUI] = 0;
                    
                    SendClientMessage(playerid, COLOR_BASIC, "[Cai dat] Ban da bat chuc nang Hunger & Thirsty Stats.");
                }
                HudSettings(playerid);
            }
	    }
    }
    return 1;
}

Dialog:SettingChannel(playerid, response, listitem, inputtext[]) {
    if(response) {
        switch(listitem)
        { 
            case 2: // Newb
            {   
                if(!gNewbie[playerid])
                {
                    gNewbie[playerid] = 1;
                    SendClientMessage(playerid, COLOR_CHAT, "[Cai dat] Ban da tat chuc nang Helper Channel.");
                }
                else
                {
                    gNewbie[playerid] = 0;                    
                    SendClientMessage(playerid, COLOR_BASIC, "[Cai dat] Ban da bat chuc nang Helper Channel.");
                }
                ChannelSettings(playerid);
            }          
            case 0: // radio
            {   
		       if (gRadio{playerid} == 0)
			   {
			 		gRadio{playerid} = 1;
			   	    SendClientMessage(playerid, COLOR_CHAT, "[Cai dat] Ban da bat chuc nang Radio Channel.");
			    }
			    else
			    {
			 		gRadio{playerid} = 0;
			 		SendClientMessage(playerid, COLOR_CHAT, "[Cai dat] Ban da tat chuc nang Radio Channel.");
			    }
                ChannelSettings(playerid);
            }          
            case 1: // staff
            {   
		        if (!advisorchat[playerid])
				{
					advisorchat[playerid] = 1;
					SendClientMessage(playerid, COLOR_CHAT, "[Cai dat] Ban da bat chuc nang Staff Channel.");
				}
				else
				{
					advisorchat[playerid] = 0;
					SendClientMessage(playerid, COLOR_CHAT, "[Cai dat] Ban da tat chuc nang Staff Channel.");
				}
                ChannelSettings(playerid);
            }     
            case 3: // staff
            {   
                if (PlayerInfo[playerid][pToggleDamge] == false)
                {
                    PlayerInfo[playerid][pToggleDamge] = true;
                    SendClientMessage(playerid, COLOR_CHAT, "[Cai dat] Ban da tat chuc nang Damages History.");
                }
                else
                {
                    PlayerInfo[playerid][pToggleDamge] = false;
                    SendClientMessage(playerid, COLOR_CHAT, "[Cai dat] Ban da bat chuc nang Damages History.");
                }
                ChannelSettings(playerid);
            }       
	    }
    }
    return 1;
}


stock HudSettings(playerid)
{
    new string[514], SpeedoST[64], HudST[64];
    
    switch(PlayerInfo[playerid][pSpeedo])
    {
        case 0: SpeedoST = "{873A35}Tat{FFFFFF}";
        case 1: SpeedoST = "{448056}Bat{FFFFFF}";
    }
    switch(PlayerInfo[playerid][pHudUI])
    {
        case 0: HudST = "{448056}Bat{FFFFFF}";
        case 1: HudST = "{873A35}Tat{FFFFFF}";
        
    }

    format(string, sizeof(string), "Cai dat\tTrang thai\n\
                                    Vehicle HUD\t%s\n\
                                    Hunger & Thirsty Stats\t%s",
                                    SpeedoST, HudST);
    Dialog_Show(playerid, SettingHud, DIALOG_STYLE_TABLIST_HEADERS, "Setting > HUD", string,
                            ">", "<");
    return 1;
}


stock ChannelSettings(playerid)
{
    new string[514], NewbST[64],RadioST[64], StaffST[64] ;
    switch(gRadio{playerid})
    {
        case 0: RadioST = "{873A35}Tat{FFFFFF}";
        case 1: RadioST = "{448056}Bat{FFFFFF}";       
    }
    switch(advisorchat[playerid])
    {
        case 0: StaffST = "{873A35}Tat{FFFFFF}";
        case 1: StaffST = "{448056}Bat{FFFFFF}";       
    }
    switch(gNewbie[playerid])
    {
        case 0: NewbST = "{448056}Bat{FFFFFF}";
        case 1: NewbST = "{873A35}Tat{FFFFFF}";
    }
    
    format(string, sizeof(string), "Cai dat\tTrang thai\n\
        Radio(PR) Channel\t%s\n\
        Staff Channel\t%s\n\
        Helper Channel\t%s\n\
        Damage History\t%s",RadioST, StaffST, NewbST,(PlayerInfo[playerid][pToggleDamge] == false) ? "{448056}Bat{FFFFFF}" : "{873A35}Tat{FFFFFF}");
    Dialog_Show(playerid, SettingChannel, DIALOG_STYLE_TABLIST_HEADERS, "Setting > Channel", string,
                            ">", "<");
    return 1;
}
