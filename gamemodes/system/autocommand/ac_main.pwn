#include <YSI\y_hooks>


#define MAX_ACTION 10
enum Action_enum {
    Action_command[80],
    Action_Set,
}
new ActionInfo[MAX_PLAYERS][MAX_ACTION][Action_enum];

enum AC1_enum {
    AC1_command[80],
    AC1_Set,
}
new AC1Info[MAX_PLAYERS][MAX_ACTION][AC1_enum];

enum AC2_enum {
    AC2_command[80],
    AC2_Set,
}
new AC2Info[MAX_PLAYERS][MAX_ACTION][AC2_enum];

#include "./system/autocommand/ac_data.pwn"


stock ShowMainAutoCommand(playerid) {
    Dialog_Show(playerid, DL_ACM_MAIN, DIALOG_STYLE_LIST, "Automatic Command - Use", "Auto Server Command\nAC-1\nAC-2\nChinh sua AC", "Tuy chon", "Thoat");
}
stock ShowUseAC(playerid,type) {
    if(type == 0) {
        new str[3229];
        str = "Id\t@Command set\t#\n";
        for(new i = 0 ; i < MAX_ACTION; i++) {
            if(ActionInfo[playerid][i][Action_Set] == 1) {
                format(str, sizeof str, "%s%d\t%s\t#\n", str,i,ActionInfo[playerid][i][Action_command]);
            }
        }
        Dialog_Show(playerid, DIALOG_USE_AC0, DIALOG_STYLE_TABLIST_HEADERS, "Automatic Command - Option", str, "Tuy chon", "Thoat");
    }
    if(type == 1) {
        new str[3229];
        str = "Id\t@Command set\t#\n";
        for(new i = 0 ; i < MAX_ACTION; i++) {
            if(AC1Info[playerid][i][AC1_Set] == 1) {
                format(str, sizeof str, "%s%d\t%s\t#\n", str,i,AC1Info[playerid][i][AC1_command]);
            }
        }
        Dialog_Show(playerid, DIALOG_USE_AC1, DIALOG_STYLE_TABLIST_HEADERS, "Automatic Command - Option", str, "Tuy chon", "Thoat");
    }
    if(type == 2) {
        new str[3229];
        str = "Id\t@Command set\t#\n";
        for(new i = 0 ; i < MAX_ACTION; i++) {
            if(AC2Info[playerid][i][AC2_Set] == 1) {
                format(str, sizeof str, "%s%d\t%s\t#\n", str,i,AC2Info[playerid][i][AC2_command]);
            }
        }
        Dialog_Show(playerid, DIALOG_USE_AC2, DIALOG_STYLE_TABLIST_HEADERS, "Automatic Command - Option", str, "Tuy chon", "Thoat");
    }
    return 1;
}
Dialog:DIALOG_USE_AC2(playerid, response, listitem, inputtext[]) {
    if(response) {
       
        if(AC2Info[playerid][listitem][AC2_Set] == 1 ) {
            Dynamic_ActionCommand(playerid, AC2Info[playerid][listitem][AC2_command] );
            return 1;
        }
    }
    return 1;
}
Dialog:DIALOG_USE_AC1(playerid, response, listitem, inputtext[]) {
    if(response) {
       
        if(AC1Info[playerid][listitem][AC1_Set] == 1 ) {
            Dynamic_ActionCommand(playerid, AC1Info[playerid][listitem][AC1_command] );
            return 1;
        }
    }
    return 1;
}
Dialog:DIALOG_USE_AC0(playerid, response, listitem, inputtext[]) {
    if(response) {
        if(listitem == 0) {
            Dialog_Show(playerid, DIALOG_AC0_USE_ME, DIALOG_STYLE_INPUT, "Automatic Command - /me", "Vui long nhap noi dung ban muon dung trong lenh '/me':", "Tuy chon", "Thoat");
            return 1;
        }
        if(listitem == 1) {
            Dialog_Show(playerid, DIALOG_AC0_USE_DO, DIALOG_STYLE_INPUT, "Automatic Command - /do", "Vui long nhap noi dung ban muon dung trong lenh '/do':", "Tuy chon", "Thoat");
            return 1;
        }
        if(ActionInfo[playerid][listitem][Action_Set] == 1 ) {
            Dynamic_ActionCommand(playerid, ActionInfo[playerid][listitem][Action_command] );
            return 1;
        }
    }
    return 1;
}
Dialog:DIALOG_AC0_USE_ME(playerid, response, listitem, inputtext[]) {
    if(response) {
        if(isnull(inputtext)) return Dialog_Show(playerid, DIALOG_AC0_USE_ME, DIALOG_STYLE_INPUT, "Automatic Command - /me", "Vui long nhap noi dung ban muon dung trong lenh '/me':", "Tuy chon", "Thoat");
        cmd_me(playerid,inputtext);
    }
    return 1;
}
Dialog:DIALOG_AC0_USE_DO(playerid, response, listitem, inputtext[]) {
    if(response) {
        if(isnull(inputtext)) return Dialog_Show(playerid, DIALOG_AC0_USE_DO, DIALOG_STYLE_INPUT, "Automatic Command - /do", "Vui long nhap noi dung ban muon dung trong lenh '/do':", "Tuy chon", "Thoat");
        cmd_do(playerid,inputtext);
    }
    return 1;
}
Dialog:DL_ACM_MAIN(playerid, response, listitem, inputtext[]) {
    if(response) {
        if(listitem == 0) {
            ShowUseAC(playerid,0);

        }
        if(listitem == 1) {
            ShowUseAC(playerid,1);
        }
        if(listitem == 2) {
            ShowUseAC(playerid,2);
        }
        if(listitem == 3) {
            Dialog_Show(playerid, DL_ACM_EDIT, DIALOG_STYLE_LIST, "Automatic Command - Edit", "Auto Server Command\nAC-1\nAC-2\nQuay lai", "Tuy chon", "Thoat");

        }
    }
    return 1;
}
Dialog:DL_ACM_EDIT(playerid, response, listitem, inputtext[]) {
    if(response) {
        if(listitem == 0) {
            ShowEditAction(playerid,0);

        }
        if(listitem == 1) {
            ShowEditAction(playerid,1);
        }
        if(listitem == 2) {
            ShowEditAction(playerid,2);
        }
        if(listitem == 3) {
            ShowMainAutoCommand(playerid);
        }
    }
    return 1;
}

stock ShowEditAction(playerid,type) {
    if(type == 0) {
        new str[3229];
        str = "Id\t@Command set\t#\n";
        for(new i = 0 ; i < MAX_ACTION; i++) {
            if(ActionInfo[playerid][i][Action_Set] == 1) {
                format(str, sizeof str, "%s%d\t%s\t#\n", str,i,ActionInfo[playerid][i][Action_command]);
            }
            else if(ActionInfo[playerid][i][Action_Set] == 0) {
                format(str, sizeof str, "%sThem tuy chon\t+\t>\n", str,i,ActionInfo[playerid][i][Action_command]);
            }
        }
        Dialog_Show(playerid, DIALOG_EDIT_AC0, DIALOG_STYLE_TABLIST_HEADERS, "Automatic Command - Editor", str, "Tuy chon", "Thoat");
    }
    if(type == 1) {
        new str[3229];
        str = "Id\t@Command set\t#\n";
        for(new i = 0 ; i < MAX_ACTION; i++) {
            if(AC1Info[playerid][i][AC1_Set] == 1) {
                format(str, sizeof str, "%s%d\t%s\t#\n", str,i,AC1Info[playerid][i][AC1_command]);
            }
            else if(AC1Info[playerid][i][AC1_Set] == 0) {
                format(str, sizeof str, "%sThem tuy chon\t+\t>\n", str,i,AC1Info[playerid][i][AC1_command]);
            }
        }
        Dialog_Show(playerid, DIALOG_EDIT_AC1, DIALOG_STYLE_TABLIST_HEADERS, "Automatic Command - Editor", str, "Tuy chon", "Thoat");
    }
    if(type == 2) {
        new str[3229];
        str = "Id\t@Command set\t#\n";
        for(new i = 0 ; i < MAX_ACTION; i++) {
            if(AC2Info[playerid][i][AC2_Set] == 1) {
                format(str, sizeof str, "%s%d\t%s\t#\n", str,i,AC2Info[playerid][i][AC2_command]);
            }
            else if(AC2Info[playerid][i][AC2_Set] == 0) {
                format(str, sizeof str, "%sThem tuy chon\t+\t>\n", str,i,AC2Info[playerid][i][AC2_command]);
            }
        }
        Dialog_Show(playerid, DIALOG_EDIT_AC2, DIALOG_STYLE_TABLIST_HEADERS, "Automatic Command - Editor", str, "Tuy chon", "Thoat");
    }
    
    
    return 1;
}
stock SetUPACCommand(playerid) {
    format(ActionInfo[playerid][0][Action_command] , 329, "%s", "/me");
    ActionInfo[playerid][0][Action_Set] = 1; 
    format(ActionInfo[playerid][1][Action_command] , 329, "%s", "/do");
    ActionInfo[playerid][1][Action_Set] = 1; 
    Insert_AC(playerid);

}

Dialog:DIALOG_EDIT_AC2(playerid, response, listitem, inputtext[]) {
    if(response) {
        if(AC2Info[playerid][listitem][AC2_Set] == 0 ) {
            SetPVarInt(playerid,#ActionSel, listitem);
            Dialog_Show(playerid, DIALOG_ADD_AC2, DIALOG_STYLE_INPUT, "Automatic Command - Add", "Vui long nhap lenh ban muon them vao 'Automatic Command':", "Tuy chon", "Thoat");
            return 1;
        }
        if(AC2Info[playerid][listitem][AC2_Set] == 1 ) {
            SetPVarInt(playerid,#ActionSel, listitem);
            Dialog_Show(playerid, DIALOG_EDITSEL_AC2, DIALOG_STYLE_LIST, "Automatic Command - Edit", "Chinh sua AC\nXoa AC", "Tuy chon", "Thoat");
            return 1;
        }

     //   Dynamic_ActionCommand(playerid, ActionInfo[playerid][listitem][Action_command] );

    }
    return 1;
}
Dialog:DIALOG_EDITSEL_AC2(playerid, response, listitem, inputtext[]) {
    if(response) {
        if(listitem == 0)
        { 
            if(AC2Info[playerid][listitem][AC2_Set] == 0 ) 
            {
                Dialog_Show(playerid, DIALOG_ADD_AC2, DIALOG_STYLE_INPUT, "Automatic Command - Add", "Vui long nhap lenh ban muon them vao 'Automatic Command':", "Tuy chon", "Thoat");
                return 1;
            }
        }
        if(listitem == 1)
        { 
            if(AC2Info[playerid][listitem][AC2_Set] == 1 )
            {
                new str[129];
                format(str, sizeof str, "[AC-SYTEEM] Ban da xoa tuy chinh Automatic-Command %d.",GetPVarInt(playerid,#ActionSel));
                SendClientMessageEx(playerid,COLOR_LIGHTBLUE,str);
                AC2Info[playerid][GetPVarInt(playerid,#ActionSel)][AC2_Set] = 0; 
                format(AC2Info[playerid][GetPVarInt(playerid,#ActionSel)][AC2_command] , 329, "%s", "Null");
                SaveACSlot(playerid,GetPVarInt(playerid,#ActionSel),2 );
                return 1;
            }
        }
       
    }
    return 1;
}
Dialog:DIALOG_ADD_AC2(playerid, response, listitem, inputtext[]) {
    if(response) {
        if(isnull(inputtext)) return Dialog_Show(playerid, DIALOG_ADD_AC2, DIALOG_STYLE_INPUT, "Automatic Command - Add", "Vui long nhap lenh ban muon them vao 'Automatic Command':", "Tuy chon", "Thoat");
        format(AC2Info[playerid][GetPVarInt(playerid,#ActionSel)][AC2_command] , 329, "%s", inputtext);
        AC2Info[playerid][GetPVarInt(playerid,#ActionSel)][AC2_Set] = 1; 
        new str[129];
        format(str, sizeof str, "[AC-SYTEEM] Ban da tuy chinh lenh %s vao Auto Slot %d.",AC2Info[playerid][GetPVarInt(playerid,#ActionSel)][AC2_command],GetPVarInt(playerid,#ActionSel));
        SendClientMessageEx(playerid,COLOR_LIGHTBLUE,str);
        SaveACSlot(playerid,GetPVarInt(playerid,#ActionSel),2 );
    }
    return 1;
}
//
Dialog:DIALOG_EDIT_AC1(playerid, response, listitem, inputtext[]) {
    if(response) {
        if(AC1Info[playerid][listitem][AC1_Set] == 0 ) {
            SetPVarInt(playerid,#ActionSel, listitem);
            Dialog_Show(playerid, DIALOG_ADD_AC1, DIALOG_STYLE_INPUT, "Automatic Command - Add", "Vui long nhap lenh ban muon them vao 'Automatic Command':", "Tuy chon", "Thoat");
            return 1;
        }
        if(AC1Info[playerid][listitem][AC1_Set] == 1 ) {
            SetPVarInt(playerid,#ActionSel, listitem);
            Dialog_Show(playerid, DIALOG_EDITSEL_AC1, DIALOG_STYLE_LIST, "Automatic Command - Edit", "Chinh sua AC\nXoa AC", "Tuy chon", "Thoat");
            return 1;
        }

     //   Dynamic_ActionCommand(playerid, ActionInfo[playerid][listitem][Action_command] );

    }
    return 1;
}
Dialog:DIALOG_EDITSEL_AC1(playerid, response, listitem, inputtext[]) {
    if(response) {
        if(listitem == 0)
        {
            if(AC1Info[playerid][listitem][AC1_Set] == 1 ) {
                Dialog_Show(playerid, DIALOG_ADD_AC1, DIALOG_STYLE_INPUT, "Automatic Command - Add", "Vui long nhap lenh ban muon them vao 'Automatic Command':", "Tuy chon", "Thoat");
                return 1;
            }
        }
        if(listitem == 1)
        {  
            if(AC1Info[playerid][listitem][AC1_Set] == 0 ) 
            {
                new str[129];
                format(str, sizeof str, "[AC-SYTEEM] Ban da xoa tuy chinh Automatic-Command %d.",GetPVarInt(playerid,#ActionSel));
                SendClientMessageEx(playerid,COLOR_LIGHTBLUE,str);
                AC1Info[playerid][GetPVarInt(playerid,#ActionSel)][AC1_Set] = 0; 
                format(AC1Info[playerid][GetPVarInt(playerid,#ActionSel)][AC1_command] , 329, "%s", "Null");
                SaveACSlot(playerid,GetPVarInt(playerid,#ActionSel),1 );
                return 1;
            }
        }
            
    }
    return 1;
}
Dialog:DIALOG_ADD_AC1(playerid, response, listitem, inputtext[]) {
    if(response) {
        if(isnull(inputtext)) return Dialog_Show(playerid, DIALOG_ADD_AC1, DIALOG_STYLE_INPUT, "Automatic Command - Add", "Vui long nhap lenh ban muon them vao 'Automatic Command':", "Tuy chon", "Thoat");
        format(AC1Info[playerid][GetPVarInt(playerid,#ActionSel)][AC1_command] , 329, "%s", inputtext);
        AC1Info[playerid][GetPVarInt(playerid,#ActionSel)][AC1_Set] = 1; 
        new str[129];
        format(str, sizeof str, "[AC-SYTEEM] Ban da tuy chinh lenh %s vao Auto Slot %d.",AC1Info[playerid][GetPVarInt(playerid,#ActionSel)][AC1_command],GetPVarInt(playerid,#ActionSel));
        SendClientMessageEx(playerid,COLOR_LIGHTBLUE,str);
        SaveACSlot(playerid,GetPVarInt(playerid,#ActionSel),1 );
    }
    return 1;
}
// ac-command main editor
Dialog:DIALOG_EDIT_AC0(playerid, response, listitem, inputtext[]) {
    if(response) {
        if(ActionInfo[playerid][listitem][Action_Set] == 0 ) {
            SetPVarInt(playerid,#ActionSel, listitem);
            Dialog_Show(playerid, DIALOG_ADD_AC0, DIALOG_STYLE_INPUT, "Automatic Command - Add", "Vui long nhap lenh ban muon them vao 'Automatic Command':", "Tuy chon", "Thoat");
            return 1;
        }
        if(ActionInfo[playerid][listitem][Action_Set] == 1 ) {
            SetPVarInt(playerid,#ActionSel, listitem);
            Dialog_Show(playerid, DIALOG_EDITSEL_AC0, DIALOG_STYLE_LIST, "Automatic Command - Edit", "Chinh sua AC\nXoa AC", "Tuy chon", "Thoat");
            return 1;
        }

     //   Dynamic_ActionCommand(playerid, ActionInfo[playerid][listitem][Action_command] );

    }
    return 1;
}
Dialog:DIALOG_EDITSEL_AC0(playerid, response, listitem, inputtext[]) {
    if(response) {
        if(listitem == 0)
        {
            if(ActionInfo[playerid][listitem][Action_Set] == 1 ) {
                Dialog_Show(playerid, DIALOG_ADD_AC0, DIALOG_STYLE_INPUT, "Automatic Command - Add", "Vui long nhap lenh ban muon them vao 'Automatic Command':", "Tuy chon", "Thoat");
                return 1;
            }
        }
        if(listitem == 1)
        {
            if(ActionInfo[playerid][listitem][Action_Set] == 0 )
             {
                new str[129];
                format(str, sizeof str, "[AC-SYTEEM] Ban da xoa tuy chinh Automatic-Command %d.",GetPVarInt(playerid,#ActionSel));
                SendClientMessageEx(playerid,COLOR_LIGHTBLUE,str);
                ActionInfo[playerid][GetPVarInt(playerid,#ActionSel)][Action_Set] = 0; 
                format(ActionInfo[playerid][GetPVarInt(playerid,#ActionSel)][Action_command] , 329, "%s", "Null");
                SaveACSlot(playerid,GetPVarInt(playerid,#ActionSel),0 );
                return 1;
            }
        }
       
    }
    return 1;
}
Dialog:DIALOG_ADD_AC0(playerid, response, listitem, inputtext[]) {
    if(response) {
        if(isnull(inputtext)) return Dialog_Show(playerid, DIALOG_ADD_AC0, DIALOG_STYLE_INPUT, "Automatic Command - Add", "Vui long nhap lenh ban muon them vao 'Automatic Command':", "Tuy chon", "Thoat");
        format(ActionInfo[playerid][GetPVarInt(playerid,#ActionSel)][Action_command] , 329, "%s", inputtext);
        ActionInfo[playerid][GetPVarInt(playerid,#ActionSel)][Action_Set] = 1; 
        new str[129];
        format(str, sizeof str, "[AC-SYTEEM] Ban da tuy chinh lenh %s vao Auto Slot %d.",ActionInfo[playerid][GetPVarInt(playerid,#ActionSel)][Action_command],GetPVarInt(playerid,#ActionSel));
        SendClientMessageEx(playerid,COLOR_LIGHTBLUE,str);
        SaveACSlot(playerid,GetPVarInt(playerid,#ActionSel),0 );
    }
    return 1;
}
hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if(newkeys & KEY_CTRL_BACK) {
        if(IsPlayerInAnyVehicle(playerid)) return 1;
        ShowMainAutoCommand(playerid);
        
    }
    return 1;
}

stock Dynamic_ActionCommand(playerid, cmdtext[])
{
    static bool:zcmd_g_HasOPCE = false;
  
    new
        pos,
        funcname[MAX_FUNC_NAME];
    while (cmdtext[++pos] > ' ') 
    {
        if(pos > MAX_FUNC_NAME) 
                break;
            else
                    funcname[pos-1] = tolower(cmdtext[pos]); 
    }
    format(funcname, sizeof(funcname), "cmd_%s", funcname);
    while (cmdtext[pos] == ' ') pos++;
    if (!cmdtext[pos])
    {
        if (zcmd_g_HasOPCE)
        {
            return CallLocalFunction("OnPlayerCommandPerformed", "isi", playerid, cmdtext, CallLocalFunction(funcname, "is", playerid, "\1"));
        }
        return CallLocalFunction(funcname, "is", playerid, "\1");   
    }
    if (zcmd_g_HasOPCE)
    {
        return CallLocalFunction("OnPlayerCommandPerformed", "isi", playerid, cmdtext, CallLocalFunction(funcname, "is", playerid, cmdtext[pos]));
    }
    return CallLocalFunction(funcname, "is", playerid, cmdtext[pos]);
}