#include <YSI\y_hooks>

// DC SV LOG
new DCC_Channel:log_Login; // log


new DCC_Channel:job_Pizza; // log
new DCC_Channel:job_Trucker; // log
new DCC_Channel:job_Worker; // log
new DCC_Channel:job_Miner; // log
new DCC_Channel:job_Trashman; // log
new DCC_Channel:job_Electricity; // log
new DCC_Channel:job_Lumberjack; // log

new DCC_Channel:log_astats; // log
new DCC_Channel:log_amoney; // log
new DCC_Channel:log_avehicle; // log
new DCC_Channel:log_avip; // log
new DCC_Channel:FixBugCMD;
new DCC_Guild:LOGSDiscord; // sv discord logs
new DCC_Channel:ddpayment;
// MECH
new DCC_Channel:co_payment; // log
new DCC_Channel:co_budget; // log
new DCC_Channel:co_invite; // log



new DCC_Channel:log_buyvehicles; // log
new DCC_Channel:log_buyvehiclesold; // log
new DCC_Channel:logs_bank; // log
new DCC_Channel:logs_mech; // log
new DCC_Channel:faction_weapons; // log
new DCC_Channel:logs_giveitem; // log
new DCC_Channel:logs_loadinv; // log
new DCC_Channel:logs_buywp; // log
new DCC_Channel:logs_mechtrade; // log 1268867897879564381
new DCC_Channel:logs_pwp; // log 1268867897879564381
new DCC_Channel:logs_login;
new DCC_Channel:log_mask;
// DC SERVER MAIN


new DCC_Channel:VerifyChannel;
new DCC_Guild:GDiscord;

new DCC_Channel:logs_casino;
new DCC_Channel:logs_casinoshop;
new DCC_Channel:log_trunk;
new DCC_Role:RVerify;
new DCC_Role:FMember;
new DCC_Role:Member;
hook OnGameModeInit()
{

    

    log_trunk =  DCC_FindChannelById("1271029799577583698"); 
    log_mask =  DCC_FindChannelById("1271844552570961950"); 
    logs_casino =  DCC_FindChannelById("1269940047239708694");
    logs_casinoshop =  DCC_FindChannelById("1269945760561106975");
    logs_loadinv = DCC_FindChannelById("1269925543382614026");
    logs_pwp = DCC_FindChannelById("1269924150219378718");
    logs_buywp = DCC_FindChannelById("1269917171346047027");
    ddpayment = DCC_FindChannelById("1269263529500999762");
    co_payment = DCC_FindChannelById("1269239185689149480");
    co_budget = DCC_FindChannelById("1269239205473812551");
    co_invite = DCC_FindChannelById("1269239220279443541");
    logs_giveitem = DCC_FindChannelById("1268780837512548435");
    logs_mechtrade = DCC_FindChannelById("1268867897879564381");
    
    faction_weapons = DCC_FindChannelById("1268478972765929486");
    log_buyvehicles = DCC_FindChannelById("1268145954054475880");
    log_buyvehiclesold = DCC_FindChannelById("1268145993824735306");
    logs_bank = DCC_FindChannelById("1268146108778156074");
    logs_mech = DCC_FindChannelById("1268847605102673951");
    
    log_astats = DCC_FindChannelById("1266995569688051733");
    FixBugCMD = DCC_FindChannelById("1266995569688051733");
    log_amoney = DCC_FindChannelById("1266203705385160825");
    log_avehicle = DCC_FindChannelById("1266203768962416650");
    log_avip = DCC_FindChannelById("1266203901812805765");
    // logs
  
    // job logs
    job_Pizza = DCC_FindChannelById("1265946792118456322");
    job_Trucker = DCC_FindChannelById("1265946841082757184");
    job_Worker = DCC_FindChannelById("1265946912754892812");
    job_Miner = DCC_FindChannelById("1265946864424063010");
    job_Trashman = DCC_FindChannelById("1265947096608014337");
    job_Electricity = DCC_FindChannelById("1265946980803281058");
    job_Lumberjack = DCC_FindChannelById("1265946932912717897");
    // job logs
  
    //
    logs_login = DCC_FindChannelById("1271821512852377712");

    RVerify = DCC_FindRoleById("1271438851554148463");
    FMember = DCC_FindRoleById("1271828491649814579");
    Member = DCC_FindRoleById("1271828275488096418");
    
    GDiscord =  DCC_FindGuildById("1271428127431856178");
    LOGSDiscord =  DCC_FindGuildById("1265929533761257555");
    VerifyChannel = DCC_FindChannelById("1271803636401438720");
    // SendSuccDiscordMSG(log_Login, "Máy chủ đã mở tham gia ngay - sv.lsrp.vn @everyone");
    return 1;
}
stock GetDiscordUser(playerid) {
    new user[50];
    format(user,sizeof(user),"<@%s>",MasterInfo[playerid][discord_userid]);
    return user;

}
stock GetLogTime() {
    new timestr[32],day,month,year,hours,minz,sec;
    getdate(year,month,day);
    gettime(hours,minz,sec);
    format(timestr, sizeof timestr, "%d:%d:%d - %d/%d/%d", hours,minz,sec,day,month,year);
    return timestr;
}
stock SendLogDiscordMSG(DCC_Channel:f_msg_channel, const discord_msg[])
{
    new DCC_Embed:embed = DCC_CreateEmbed("[LOGS]", discord_msg);
    DCC_SetEmbedColor(embed, 0xdbe780);

    return DCC_SendChannelEmbedMessage(f_msg_channel, embed);
}
stock SendErrorDiscordMSG(DCC_Channel:f_msg_channel, const discord_msg[])
{
    new DCC_Embed:embed = DCC_CreateEmbed("[USE]", discord_msg);
    DCC_SetEmbedColor(embed, 0x973131);

    return DCC_SendChannelEmbedMessage(f_msg_channel, embed);
}
stock SendSuccDiscordMSG(DCC_Channel:f_msg_channel, const discord_msg[])
{
    new DCC_Embed:embed = DCC_CreateEmbed("[DISCORD]", discord_msg);
    DCC_SetEmbedColor(embed, 0x973131);

    return DCC_SendChannelEmbedMessage(f_msg_channel, embed);
}
#include "./system/discord/verify.pwn"