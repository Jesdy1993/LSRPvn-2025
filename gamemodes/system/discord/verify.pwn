DCMD:verify(user, channel, params[])
{
    if(channel != VerifyChannel) return 1;
    new verify_dc_id[32];
    if(sscanf(params, "d", verify_dc_id)) return SendErrorDiscordMSG(VerifyChannel, " !verify [Verify Code]");


    new string[228];
    new UserID[DCC_ID_SIZE];
    print("alo");
    DCC_GetUserId(user, UserID, DCC_ID_SIZE);
//    DCC_GetUserName(DCC_User:user, username,sizeof(username));
    printf("%s",UserID);
    format(string, sizeof(string), "SELECT * FROM `masterdb` WHERE `discord_verify_id`= '%d'",verify_dc_id );
    mysql_function_query(MainPipeline, string, true, "onVerifyLoad", "is", verify_dc_id,UserID);
    return 1;
}
DCMD:fixbug(user, channel, params[])
{
    if(channel != FixBugCMD) return 1;
    new Username[32];
    if(sscanf(params, "s[32]", Username)) return SendErrorDiscordMSG(FixBugCMD, " !fixbug [Username]");


    new string[228];
    new UserID[DCC_ID_SIZE];
    print("alo");

    DCC_GetUserId(user, UserID, DCC_ID_SIZE);
    printf("%s",UserID);
    format(string, sizeof(string), "SELECT discord_userid,Username FROM `accounts` WHERE `Username`= '%s'",Username );
    mysql_function_query(MainPipeline, string, true, "OnFixCrash", "ss", Username,UserID);
    return 1;
}
stock SetUPRoles(playerid) {
    new DCC_User:get_user;
    new bool:has_role;
    get_user = DCC_FindUserById(MasterInfo[playerid][discord_userid]);

    if(PlayerInfo[playerid][pAdmin] > 2 && PlayerInfo[playerid][pAdmin] < 99999) {
        new DCC_Role:lsrp_admin;
        
        lsrp_admin =  DCC_FindRoleById("1271436856931778641");
        DCC_HasGuildMemberRole(GDiscord, get_user,lsrp_admin, has_role);
        if(has_role == false) {
            SendClientMessage(playerid,COLOR_WHITE2,"### DISCORD ### Ban da duoc cap role Administrator.");
            DCC_AddGuildMemberRole(GDiscord, get_user, lsrp_admin);
        }
    }
    if(PlayerInfo[playerid][pAdmin] >= 99999) {
        new DCC_Role:lsrp_admin;
        lsrp_admin =  DCC_FindRoleById("1271430411691626566");
        DCC_HasGuildMemberRole(GDiscord, get_user,lsrp_admin, has_role);
        if(has_role == false) {
            SendClientMessage(playerid,COLOR_WHITE2,"### DISCORD ### Ban da duoc cap role Founder.");
            DCC_AddGuildMemberRole(GDiscord, get_user, lsrp_admin);
        }
    }
    if (IsACop(playerid))
    {
        new DCC_Role:lsrp_admin;
        lsrp_admin =  DCC_FindRoleById("1271802742771548191");    
        if(has_role == false) {
            SendClientMessage(playerid,COLOR_WHITE2,"### DISCORD ### Ban da duoc cap role Police.");
            DCC_AddGuildMemberRole(GDiscord, get_user, lsrp_admin);
        }
    }
    if (IsAMedic(playerid))
    {
        new DCC_Role:lsrp_admin;
        lsrp_admin =  DCC_FindRoleById("1271823055915581540");
        if(has_role == false) {
            SendClientMessage(playerid,COLOR_WHITE2,"### DISCORD ### Ban da duoc cap role Medic.");
            DCC_AddGuildMemberRole(GDiscord, get_user, lsrp_admin);
        }
    }
    if (PlayerInfo[playerid][pFMember] != 0)
    {
        new DCC_Role:lsrp_admin;
        lsrp_admin =  DCC_FindRoleById("1271802624584450069");
        DCC_AddGuildMemberRole(GDiscord, get_user, lsrp_admin);
        if(has_role == false) {
            SendClientMessage(playerid,COLOR_WHITE2,"### DISCORD ### Ban da duoc cap role Gangs.");
            DCC_AddGuildMemberRole(GDiscord, get_user, lsrp_admin);
        }
    }
    if (PlayerInfo[playerid][pHelper] > 0)
    {
        new DCC_Role:lsrp_admin;
        lsrp_admin =  DCC_FindRoleById("1271467018494808084");
        DCC_AddGuildMemberRole(GDiscord, get_user, lsrp_admin);
        if(has_role == false) {
            SendClientMessage(playerid,COLOR_WHITE2,"### DISCORD ### Ban da duoc cap role STAFF.");
            DCC_AddGuildMemberRole(GDiscord, get_user, lsrp_admin);
        }
    }
    new DCC_Role:lsrp_admin;
    lsrp_admin =  DCC_FindRoleById("1271828275488096418");
    DCC_AddGuildMemberRole(GDiscord, get_user, lsrp_admin);
    if(has_role == false) {
        SendClientMessage(playerid,COLOR_WHITE2,"### DISCORD ### Ban da duoc cap role Connected.");
        DCC_AddGuildMemberRole(GDiscord, get_user, lsrp_admin);
    }
}

forward OnFixCrash(Usernameload[],userid[]);
public OnFixCrash(Usernameload[],userid[])
{
    // new DCC_User:get_user;
    // get_user = DCC_FindUserById(userid);
    new fields,row,fix_discord_userid[50];
    cache_get_data(row, fields, MainPipeline);
    if(row == 0) return SendErrorDiscordMSG(FixBugCMD, "Tên nhân vật không tồn tại.");
    for(new rows ; rows < row ; rows ++) {
       
        cache_get_field_content(rows,  "discord_userid", fix_discord_userid, MainPipeline); 
        printf("%s %s,%s",fix_discord_userid,userid,Usernameload);
    }
    printf("%s %s",fix_discord_userid,userid);
    if(strcmp(fix_discord_userid,userid,true) == 0)
    { 
        new string[229];
        format(string, sizeof(string), "UPDATE `accounts` SET `SPos_x` = '1811.0605',`SPos_y` = '-1897.3394',`SPos_z` = '13.5785' WHERE `Username`= '%s'",Usernameload );
        mysql_function_query(MainPipeline, string, true, "onUpdateLoad", "0", 0);
        format(string, sizeof string, "Đã fix vị trí cho %s thành công.", Usernameload);
        SendSuccDiscordMSG(FixBugCMD,string);

    }
    else SendSuccDiscordMSG(FixBugCMD,"Nhân vật không được liên kết với tài khoản discord này.");


    return 1;
}




forward onVerifyLoad(verify_id,userid[]);
public onVerifyLoad(verify_id,userid[])
{
    print("alo");
    new fields, szResult[64],row,discord_verify,discord_verify_id,username[32],uacc_id,f_member;
    cache_get_data(row, fields, MainPipeline);
    if(row == 0) return SendErrorDiscordMSG(VerifyChannel, "ID-Discord không tồn tại.");
    for(new rows ; rows < row ; rows ++) {
        cache_get_field_content(rows,  "discord_verify", szResult, MainPipeline); discord_verify = strval(szResult);
        cache_get_field_content(rows,  "discord_verify_id", szResult, MainPipeline); discord_verify_id = strval(szResult);
        cache_get_field_content(rows,  "acc_id", szResult, MainPipeline); uacc_id = strval(szResult);
        cache_get_field_content(rows,  "founding_member", szResult, MainPipeline); f_member = strval(szResult);
        cache_get_field_content(rows,  "acc_name", username, MainPipeline); 
    }
    printf("%d != %d, %s, %d ",verify_id,discord_verify_id,username,uacc_id);
    if(discord_verify_id != verify_id) return SendErrorDiscordMSG(VerifyChannel, "Key Discord bạn vừa nhập không trùng khớp với key discord Account IG.");
    if(discord_verify > 0) return SendErrorDiscordMSG(VerifyChannel, "Tài khoản bạn vừa nhập đã liên kết discord rồi.");
    new string[229];
    format(string, sizeof(string), "UPDATE `masterdb` SET `discord_verify` = '100',`discord_userid` = '%s' WHERE `acc_id`= '%d'",userid,uacc_id );
    mysql_function_query(MainPipeline, string, true, "onUpdateLoad", "0", 0);


    format(string, sizeof(string), "UPDATE `accounts` SET `discord_userid` = '%s' WHERE `master_id`= '%d'", userid,uacc_id );
    mysql_function_query(MainPipeline, string, true, "onUpdateLoad", "0", 0);


    format(string, sizeof string, "<@%s> đã xác nhận thành công tài khoản <%s>, vui lòng vào game, tải dữ liệu nhân vật để hệ thống tải dữ liệu cập nhật #Role.", userid,username);
    SendSuccDiscordMSG(VerifyChannel,string);
    new DCC_User:get_user;
    get_user = DCC_FindUserById(userid);
    DCC_AddGuildMemberRole(GDiscord, get_user, RVerify);
    DCC_AddGuildMemberRole(GDiscord, get_user, Member);
    if(f_member == 1) {
        DCC_AddGuildMemberRole(GDiscord, get_user, FMember);
        format(string, sizeof string, "Cảm ơn <@%s> đã tham gia đăng ký sớm, bạn nhận được role Founding Member.", userid);
        SendSuccDiscordMSG(VerifyChannel,string);
    } 
    DCC_SetGuildMemberNickname(GDiscord, get_user, username);


    return 1;
}

forward onUpdateLoad(playerid,random_code);
public onUpdateLoad(playerid,random_code)
{
    new string[329];
    MasterInfo[playerid][accdiscord_verifyid] = random_code;
    format(string, sizeof(string), "Ma xac nhan discord cua ban la: %d, su dung !verify [verify code].",random_code);
    SendClientMessage(playerid, COLOR_YELLOW, string);
}
stock RegisterDiscord(playerid) {
    new string[328];
    printf("cc%d",MasterInfo[playerid][accdiscord_verifyid]);
    if(MasterInfo[playerid][accdiscord_verify] != 0 )
    {
        SetUPRoles(playerid);
    }
    else if(MasterInfo[playerid][accdiscord_verifyid] > 100 && MasterInfo[playerid][accdiscord_verify] == 0 ) {
        new random_code = MasterInfo[playerid][accdiscord_verifyid];
        printf("teststestests %d",random_code);
        format(string, sizeof(string), "{bf3232}Vui long xac nhan discord de tham gia may chu{b4b4b4}\n\
                                        Ma xac nhan discord cua ban la: {bf3232}%d{b4b4b4}, su dung {bf3232}!verify %d{b4b4b4} tai #verify-account de xac nhan.\n\
                                        Sau khi xac nhan bam vao nut 'xac nhan' de bat dau tham gia.",random_code,random_code);
        SendClientMessage(playerid, COLOR_YELLOW, string);
        // Dialog_Show(playerid, DIALOG_VERIFY_DISCORD, DIALOG_STYLE_MSGBOX, "#VERIFY ACCOUNT", string, "Xac nhan", "");
    }
    else if(MasterInfo[playerid][accdiscord_verifyid] < 100 && MasterInfo[playerid][accdiscord_verify] == 0 ) {
        SetRandomCode(playerid,MasterInfo[playerid][acc_id]);
    }
   
    
    return 1;
}

Dialog:DIALOG_VERIFY_DISCORD(playerid, response, listitem, inputtext[])
{
    if(response) {
        new string[228];
        format(string, sizeof(string), "SELECT `discord_verify` FROM `masterdb` WHERE `acc_id` = %d", MasterInfo[playerid][acc_id] );
        mysql_function_query(MainPipeline, string, true, "OnCheckLoadGame", "i", playerid);
    }
    else {
        RegisterDiscord(playerid);
    }
}
forward OnCheckLoadGame(playerid);
public OnCheckLoadGame(playerid) {
    new fields, szResult[64],row;
    cache_get_data(row, fields, MainPipeline);
    if(row == 0) return SendErrorMessage(playerid, "Khong tai duoc du lieu nhan vat.");
    for(new rows ; rows < row ; rows ++) {
        cache_get_field_content(rows,  "discord_verify", szResult, MainPipeline); MasterInfo[playerid][accdiscord_verify] = strval(szResult);
    }
    if(MasterInfo[playerid][accdiscord_verify] != 0) {
        SendClientMessage(playerid,COLOR_WHITE2, "# DISCORD VERIFY # Ban da xac nhan thanh cong tai khoan.");
        RegisterDiscord(playerid);
    }
    else {
        SendClientMessage(playerid,COLOR_WHITE2, "# DISCORD VERIFY ERROR # Co so du lieu chua nhan duoc thong tin ket noi.");
        RegisterDiscord(playerid);

    }
    return 1;

}
stock SetRandomCode(playerid,acc_idz) {
    new random_code = 100000 + random(999999),string[129];
    format(string, sizeof(string), "UPDATE `masterdb` SET `discord_verify` = '0',`discord_verify_id` = '%d'  WHERE `acc_id`= '%d'",random_code,acc_idz);
    printf("alo %s",string);
    mysql_function_query(MainPipeline, string, true, "onUpdateLoad", "ii", playerid,random_code);

    return 1;
}
