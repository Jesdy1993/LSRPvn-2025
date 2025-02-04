#include <YSI\y_hooks>
// CMD:pd(playerid,params[]) {
//     if(!IsACop(playerid)) return SendErrorMessage(playerid, " Ban khong phai canh sat.");
//     new choice[32],giveplayerid,strcmd[32];
//     if(sscanf(params, "s[32]", choice))
//     {
//         SendClientMessageEx(playerid, COLOR_CHAT, " /pd [Tuy chon]");
//         SendClientMessageEx(playerid, COLOR_WHITE, "{c7d5d8}BASIC{ffffff}: cuff | uncuff | tazer | drag | detain | radargun");
//         return 1;
//     }
//     if(strcmp(choice,"cuff",true) == 0) {
//         if(sscanf(params, "s[32]d", choice,giveplayerid)) return SendClientMessageEx(playerid, COLOR_CHAT, " /pd [cuff] [playerid]");
//         format(strcmd, 32, "%d",giveplayerid);
//         cmd_cuff(playerid, strcmd);
//     }
//     else if(strcmp(choice,"uncuff",true) == 0) {
//         if(sscanf(params, "s[32]d", choice,giveplayerid)) return SendClientMessageEx(playerid, COLOR_CHAT, " /pd [uncuff] [playerid]");
//         format(strcmd, 32, "%d",giveplayerid);
//         cmd_uncuff(playerid, strcmd);
//     }
//     else if(strcmp(choice,"tazer",true) == 0) {
//         cmd_tazer(playerid,params);
//     }
//     else if(strcmp(choice,"drag",true) == 0) {
//         if(sscanf(params, "s[32]d", choice,giveplayerid)) return SendClientMessageEx(playerid, COLOR_CHAT, " /pd [drag] [playerid]");
//         format(strcmd, 32, "%d",giveplayerid);
//         cmd_drag(playerid, strcmd);
//     }
//     else if(strcmp(choice,"detain",true) == 0) {
//         new slot;
//         if(sscanf(params, "s[32]dd", choice,giveplayerid,slot)) return SendClientMessageEx(playerid, COLOR_CHAT, " /pd [detain] [playerid] [slot 1-3] ");
//         format(strcmd, 32, "%d",giveplayerid,slot);
//         cmd_drag(playerid, strcmd);
//     }
//     else if(strcmp(choice,"radargun",true) == 0) {
//         cmd_radargun(playerid,params);
//     }
//     return 1;
// }

stock ShowMenuRegisterVeh(playerid) {
    if(PlayerInfo[playerid][pFreezeCar] == 0)
	{
		new vstring[4096], icount = GetPlayerVehicleSlots(playerid);
		for(new i, iModelID; i < icount; i++)
		{
			if((iModelID = PlayerVehicleInfo[playerid][i][pvModelId] - 400) >= 0)
			{
				if(PlayerVehicleInfo[playerid][i][pvImpounded]) {
					format(vstring, sizeof(vstring), "%s\n{b4b4b4}%s\t{ed3030}Bi tich thu{b4b4b4}\t%s", vstring,VehicleName[iModelID],
                        (PlayerVehicleInfo[playerid][i][pvRegister] == 1) ? "Da dang ky" : "{ed3030}Chua dang ky");
				}
				else if(PlayerVehicleInfo[playerid][i][pvDisabled]) {
					format(vstring, sizeof(vstring), "%s\n{b4b4b4}%s\t{ed3030}Khong the su dung{b4b4b4}\t%s", vstring,VehicleName[iModelID],
                        (PlayerVehicleInfo[playerid][i][pvRegister] == 1) ? "Da dang ky" : "{ed3030}Chua dang ky");
				}
				else if(!PlayerVehicleInfo[playerid][i][pvSpawned]) {
					format(vstring, sizeof(vstring), "%s\n{b4b4b4}%s\t{ed3030}Trong kho{b4b4b4}\t%s", vstring,VehicleName[iModelID],
                        (PlayerVehicleInfo[playerid][i][pvRegister] == 1) ? "Da dang ky" : "{ed3030}Chua dang ky");
					// format(vstring, sizeof(vstring), "%s\n%s (Trong kho)", vstring, VehicleName[iModelID]);
				}
				else format(vstring, sizeof(vstring), "%s\n{b4b4b4}%s\t{43ad60}Dang su dung{b4b4b4}\t%s", vstring,VehicleName[iModelID],
                    (PlayerVehicleInfo[playerid][i][pvRegister] == 1) ? "{43ad60}Da dang ky" : "{ed3030}Chua dang ky");
					// format(vstring, sizeof(vstring), "%s\n%s (Dang su dung)", vstring, VehicleName[iModelID]);
			}
			else strcat(vstring, "\nEmpty");
		}
        print(vstring);
		Dialog_Show(playerid, DIALOG_REGISTER_VEH, DIALOG_STYLE_LIST, "Vehicle - Register", vstring, "Chon", "Thoat");
	}
	return 1;
}
stock ShowViewRegisterVeh(playerid) {
    new vstring[4096], icount = GetPlayerVehicleSlots(playerid);
    for(new i, iModelID; i < icount; i++)
    {
        if((iModelID = PlayerVehicleInfo[playerid][i][pvModelId] - 400) >= 0)
        {
            if(PlayerVehicleInfo[playerid][i][pvImpounded]) {
                format(vstring, sizeof(vstring), "%s\n{b4b4b4}%s\t{ed3030}Bi tich thu{b4b4b4}\t%s", vstring,VehicleName[iModelID],
                    (PlayerVehicleInfo[playerid][i][pvRegister] == 1) ? "Da dang ky" : "{ed3030}Chua dang ky");
            }
            else if(PlayerVehicleInfo[playerid][i][pvDisabled]) {
                format(vstring, sizeof(vstring), "%s\n{b4b4b4}%s\t{ed3030}Khong the su dung{b4b4b4}\t%s", vstring,VehicleName[iModelID],
                    (PlayerVehicleInfo[playerid][i][pvRegister] == 1) ? "Da dang ky" : "{ed3030}Chua dang ky");
            }
            else if(!PlayerVehicleInfo[playerid][i][pvSpawned]) {
                format(vstring, sizeof(vstring), "%s\n{b4b4b4}%s\t{ed3030}Trong kho{b4b4b4}\t%s", vstring,VehicleName[iModelID],
                    (PlayerVehicleInfo[playerid][i][pvRegister] == 1) ? "Da dang ky" : "{ed3030}Chua dang ky");
                // format(vstring, sizeof(vstring), "%s\n%s (Trong kho)", vstring, VehicleName[iModelID]);
            }
            else format(vstring, sizeof(vstring), "%s\n{b4b4b4}%s\t{43ad60}Dang su dung{b4b4b4}\t%s", vstring,VehicleName[iModelID],
                (PlayerVehicleInfo[playerid][i][pvRegister] == 1) ? "{43ad60}Da dang ky" : "{ed3030}Chua dang ky");
                // format(vstring, sizeof(vstring), "%s\n%s (Dang su dung)", vstring, VehicleName[iModelID]);
        }
        else strcat(vstring, "\nEmpty");
    }
    print(vstring);
    Dialog_Show(playerid, VIEW_REG_VEH, DIALOG_STYLE_LIST, "Vehicle - View Register", vstring, "> Xem", "Thoat");
    return 1;
}
CMD:testzz(playerid){
	ShowMenuRegisterVeh(playerid);
	return 1;
}
CMD:showtestz(playerid,params[]) {
	ShowVehicleInformation(playerid,playerid,strval(params));
	return 1;
}
stock ShowVehicleInformation(playerid,giveplayerid,pvslot) {
	new string[1229];
    string = "#\t#\t#\n";
    format(string, sizeof( string), "%s\n\
    #>\tChu so huu:\t%s\n\
    #>\tGioi tinh:\t%s\n\
    #>\tNam sinh:\t%s\n\
    #>\tQuoc tich:\t%s\n\
    #>\tPhuong tien:\t%s\n\
    #>\tSo hieu mau:\t%d-%d\n\
    #>\tNgay dang kiem:\t%s\n\
    #>\tBien so xe:\t%s", string,
    PlayerVehicleInfo[playerid][pvslot][pvOwnerName],
    (PlayerVehicleInfo[playerid][pvslot][pvOwnerGen] == 1) ? "Nam" : "Nu",
    PlayerVehicleInfo[playerid][pvslot][pvOwnerBirth],
    (PlayerVehicleInfo[playerid][pvslot][pvOwnerNation] == 1) ? "Tierra Robada" : "San Andreas",
    VehicleName[PlayerVehicleInfo[playerid][pvslot][pvModelId] - 400],
    PlayerVehicleInfo[playerid][pvslot][pvColor1],PlayerVehicleInfo[playerid][pvslot][pvColor2],
    PlayerVehicleInfo[playerid][pvslot][pvOwnerReg],
    PlayerVehicleInfo[playerid][pvslot][pvPlate]);
	Dialog_Show(giveplayerid, DIALOG_SHOW_VEHI, DIALOG_STYLE_TABLIST_HEADERS, "Vehicle - Register Information", string, "Dang ky", "Thoat");
    return 1;
}
Dialog:DIALOG_SHOW_VEHI(playerid, response, listitem, inputtext[]) {
    if (response) {
   	}
    return 1;
}
Dialog:VIEW_REG_VEH(playerid, response, listitem, inputtext[]) {
    if (response) {
        if(PlayerVehicleInfo[playerid][listitem][pvRegister] == 0) return SendErrorMessage(playerid," Phuong tien chua dang ky giay to."); 
        ShowVehicleInformation(playerid,playerid,listitem);
    }
    return 1;
}
Dialog:DIALOG_REGISTER_VEH(playerid, response, listitem, inputtext[]) {
    if (response) {
        if(!PlayerVehicleInfo[playerid][listitem][pvSpawned]) return SendErrorMessage(playerid," Phuong tien cua ban chua duoc su dung (/my veh > chinh xe ).");
	    if(PlayerVehicleInfo[playerid][listitem][pvRegister] != 0) return SendErrorMessage(playerid," Phuong tien da duoc dang ky giay to xe roi."); 
        SetPVarInt(playerid, #RegisterVehSlot, listitem);
        new string[1229];
        string = "#\t#\t#\n";
        format(string, sizeof string, "%s\n\
            #>\tChu so huu:\t%s\n\
            #>\tGioi tinh:\t%s\n\
            #>\tNam sinh:\t%s\n\
            #>\tQuoc tich:\t%s\n\
            #>\tPhuong tien:\t%s\n\
            #>\tSo hieu mau:\t%d-%d\n\
            #>\tPhi dang ky:\t$5.000n\
            =>\t>>XAC NHAN DANG KY<<\t#", string,
            GetPlayerNameEx(playerid),
            (PlayerInfo[playerid][pSex] == 1) ? "Nam" : "Nu",
            PlayerInfo[playerid][pBirthDate],
            (PlayerInfo[playerid][pNation] == 1) ? "Tierra Robada" : "San Andreas",
            VehicleName[PlayerVehicleInfo[playerid][listitem][pvModelId] - 400],
            PlayerVehicleInfo[playerid][listitem][pvColor1],PlayerVehicleInfo[playerid][listitem][pvColor2]);
	    Dialog_Show(playerid, DIALOG_REGVEH_STEP1, DIALOG_STYLE_TABLIST_HEADERS, "Vehicle - Register Information", string, "Dang ky", "Thoat");
	}
    return 1;
}
// pvOwnerName[32], // thgian reg
// pvOwnerReg[32], // thgian reg
// pvOwnerGen,
// pvOwnerNation,
// pvOwnerBirth[32],


Dialog:DIALOG_REGVEH_STEP1(playerid, response, listitem, inputtext[]) {
    if (response) {
        new pvid = GetPVarInt(playerid, #RegisterVehSlot);

        if(listitem != 7) {
            new string[1229];
            string = "#\t#\t#\n";
            format(string, sizeof string, "%s\n\
                #>\tChu so huu:\t%s\n\
                #>\tGioi tinh:\t%s\n\
                #>\tNam sinh:\t%s\n\
                #>\tQuoc tich:\t%s\n\
                #>\tPhuong tien:\t%s\n\
                #>\tSo hieu mau:\t%d-%d\n\
                #>\tPhi dang ky:\t$5.000n\
                =>\t>>XAC NHAN DANG KY<<\t#", string,
                GetPlayerNameEx(playerid),
                (PlayerInfo[playerid][pSex] == 1) ? "Nam" : "Nu",
                PlayerInfo[playerid][pBirthDate],
                (PlayerInfo[playerid][pNation] == 1) ? "Tierra Robada" : "San Andreas",
                VehicleName[PlayerVehicleInfo[playerid][pvid][pvModelId] - 400],
                PlayerVehicleInfo[playerid][pvid][pvColor1],PlayerVehicleInfo[playerid][pvid][pvColor2]);
            Dialog_Show(playerid, DIALOG_REGVEH_STEP1, DIALOG_STYLE_TABLIST_HEADERS, "Vehicle - Register Information", string, "Dang ky", "Thoat");

        }
        else if(listitem == 7) {
    	    if(PlayerInfo[playerid][pCash] < 5000) return SendErrorMessage(playerid, "Ban khong co du $5.000 de dang ky.");
    	    if(PlayerVehicleInfo[playerid][pvid][pvRegister] != 0) return SendErrorMessage(playerid," Phuong tien da duoc dang ky giay to xe roi."); 
           
            PlayerVehicleInfo[playerid][pvid][pvRegister] = 1;
            PlayerVehicleInfo[playerid][pvid][pvOwnerNation] = PlayerInfo[playerid][pNation]; // 
            PlayerVehicleInfo[playerid][pvid][pvOwnerGen] = PlayerInfo[playerid][pSex]; // gioi tinh

            format( PlayerVehicleInfo[playerid][pvid][pvOwnerName], 32, "%s", GetPlayerNameEx(playerid));
            format( PlayerVehicleInfo[playerid][pvid][pvOwnerBirth], 32, "%s", PlayerInfo[playerid][pBirthDate]);
            format( PlayerVehicleInfo[playerid][pvid][pvOwnerReg], 32, "%s", GetLogTime());
 
            new random_bsx; 
            random_bsx = 10000 + random(99999);
            format( PlayerVehicleInfo[playerid][pvid][pvPlate], 32, "LS-%d",random_bsx);
            GivePlayerMoneyEx(playerid,-5000);

            SetVehicleNumberPlate(PlayerVehicleInfo[playerid][pvid][pvId], PlayerVehicleInfo[playerid][pvid][pvPlate]);
            new string[129];
            format(string, sizeof string, "[Vehicle Registration] Ban da dang ky giay to xe thanh cong, bien so xe cua ban la: {f45656}%s", PlayerVehicleInfo[playerid][pvid][pvPlate]);
            SendClientMessage(playerid, COLOR_BASIC,string);
            g_mysql_SaveVehicle(playerid, pvid);
        }
    }
    return 1;
}
new Text3D:label_regveh,actor_regveh;
hook OnGameModeInit(){
    actor_regveh = CreateDynamicActor(150,  356.2964,178.8874,1008.3762,270.1087);
    SetDynamicActorVirtualWorld(actor_regveh, 1);
    label_regveh = CreateDynamic3DTextLabel("< VEHICLE REGISTER >\nBam 'Y' de tuong tac", COLOR_BASIC, 356.2964,178.8874,1008.3762,10.0);   
}
hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if(newkeys & KEY_YES) {
        if(IsPlayerInRangeOfPoint(playerid, 5.0, 356.2964,178.8874,1008.3762)) {
            ShowMenuRegisterVeh(playerid);
        }
    }
    return 1;
}