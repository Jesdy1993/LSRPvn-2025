
Dialog:DialogFish(playerid, response, listitem, inputtext[])
{
    if(response) {
        switch(listitem) {
            case 0: {
                if(PlayerInfo[playerid][pFishRod] != 0) return SendErrorMessage(playerid,"Ban da co can cau roi");
                if(PlayerInfo[playerid][pCash] < 500) return SendErrorMessage(playerid,"Ban khong du $500");
                PlayerInfo[playerid][pFishRod] = 1;
                PlayerInfo[playerid][pCash] -= 500;
                SendSyntaxMessage(playerid,"Ban da mua thanh cong can cau voi gia $500");
            }
            case 1: {
                if(PlayerInfo[playerid][pCash] < 100) return SendErrorMessage(playerid, "Ban khong du $100");
                PlayerInfo[playerid][pBait] += 1;
                PlayerInfo[playerid][pCash] -= 100;
                SendSyntaxMessage(playerid,"Ban da mua thanh cong moi cau voi gia $100");
            }
    
            case 2: {
                new str[220];
                str = "";
                for(new i = 0; i < 10 ; i++) {
                    if(PlayerInfo[playerid][pFish][i] != 0) {
                        format(str,sizeof str,"%s%d\t%s\t%d\n",str,i,FishingStr[PlayerInfo[playerid][pFish][i]][fishname],FishingStr[PlayerInfo[playerid][pFish][i]][fishprice]);
                    } 
                }
                if(isnull(str)) return SendErrorMessage(playerid, "Ban khong co ca nao.");
                Dialog_Show(playerid, DialogBanCa, DIALOG_STYLE_TABLIST,"Ban ca",str,"Ban","Thoat");
            }
        }
    }
    return 1;
}

Dialog:DialogBanCa(playerid, response, listitem, inputtext[])
{
    if(response ) {
        printf("%s",inputtext);
        new str[129];
        format(str,sizeof str,"Ban da ban con ca %s voi gia %d", FishingStr[PlayerInfo[playerid][pFish][strval(inputtext)]][fishname], FishingStr[PlayerInfo[playerid][pFish][strval(inputtext)]][fishprice]);
        PlayerInfo[playerid][pCash] += FishingStr[PlayerInfo[playerid][pFish][strval(inputtext)]][fishprice];
        PlayerInfo[playerid][pFish][strval(inputtext)] = 0;
        SendClientMessageEx(playerid,-1,str);
    }
    return 1;
}