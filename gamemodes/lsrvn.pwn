	// 	pvOwnerName[32], // thgian reg
    // pvOwnerReg[32], // thgian reg
    // pvOwnerGen,
    // pvOwnerNation,
    // pvOwnerBirth[32],
	// pvRegister,		                      
#define SSCANF_NO_NICE_FEATURES                    
#define SERVER_GM_TEXT "LSRvn 0.1"

#pragma disablerecursion



#include <a_samp>

#include <easyDialog>

#include <PawnPlus>
#include <a_mysql>

#include <td-streamer-internal>

#include <streamer>
#include <yom_buttons>
#include <ZCMD>
#include <sscanf2>
#include <foreach>
#include <YSI\y_timers>
#include <YSI\y_utils>
#include <YSI\y_ini>
#include <strlib>

// #include <progress2>

#include <dialogpreviewmodel>
#include <crashdetect>
#include <compat>
#include <discord-connector>
#include <discord-cmd>


#if defined SOCKET_ENABLED

 

#include <socket>
#endif

forward Float:GetDistanceBetweenPlayers(iPlayerOne, iPlayerTwo);
public Float:GetDistanceBetweenPlayers(iPlayerOne, iPlayerTwo)
{
    new
        Float: fPlayerPos[3];

    GetPlayerPos(iPlayerOne, fPlayerPos[0], fPlayerPos[1], fPlayerPos[2]);
    return GetPlayerDistanceFromPoint(iPlayerTwo, fPlayerPos[0], fPlayerPos[1], fPlayerPos[2]);
}

// // addion MAP TEST

#include "./map/add_clubint.pwn"
#include "./map/add_fbi.pwn"
#include "./map/add_gang1.pwn"
#include "./map/add_gangv42.pwn"
#include "./map/trucker.pwn"
#include "./map/roadsign.pwn"
#include "./map/add_mafia.pwn"
// #include "./map/add_mafiaint42.pwn"
#include "./map/add_pdint.pwn"
#include "./map/locker.pwn"
#include "./map/add_glen.pwn"
#include "./map/add_mechanic2.pwn"
// MAP USE
#include "./map/atm_obj.pwn"
#include "./map/miner_map.pwn"
#include "./map/jef_pd.pwn"
#include "./map/cf.pwn"



#include "./main/color_defines.pwn"
#include "./include/dynamic_progress.pwn"
#include "./include/message_item.inc"
#include "./include/messclient.pwn"
#include "./main/dialog_defines.pwn"

#include "./include/textclient.pwn"
#include "./main/defines.pwn"
#include "./main/variables.pwn"
#include "./system/newfaction/handcuff.pwn"


#include "./system/server/bugint.pwn"
#include "./system/animation.pwn"

#include "./system/anti_hack/cbug.pwn"
#include "./system/anti_hack/troll_car.pwn"
#include "./system/discord/main.pwn"

#include "./system/player_system/suc_sinh_jhon.pwn"
#include "./system/player_system/character_select.pwn"
#include "./system/player_system/FoodUseLoading.pwn"
#include "./system/player_system/hunger_system.pwn"
#include "./system/player_system/player_tutorial.pwn"
#include "./system/player_system/id-card.pwn"
#include "./system/player_system/speedo.pwn"
#include "./system/player_system/phone_system.pwn"
#include "./system/player_system/mask.pwn"
#include "./system/player_system/settings.pwn"

#include "./system/achievement/job_stats.pwn"


#include "./system/gangs/purplelean.pwn"
#include "./system/house/furniture.pwn"
#include "./system/house/defualt_int.pwn"
#include "./system/player_system/chat.pwn"
#include "./system/autocommand/ac_main.pwn"
#include "./system/help_system/help.pwn"
#include "./system/gps_system/gps.pwn"
#include "./system/bank/bank.pwn"
#include "./system/bank/rob_atm.pwn"
#include "./system/clothes/clothes.pwn"
#include "./system/clothes/accessory.pwn"
#include "./system/payday/payday.pwn"
#include "./system/faction/medic.pwn"
#include "./system/faction/cctv.pwn"
#include "./system/faction/f_cmd.pwn"
#include "./system/faction/beanbag.pwn"
#include "./system/faction/alpr.pwn"
#include "./system/faction/ticket/ticket_core.pwn"
#include "./system/faction/ticket/ticket_cmd.pwn"
#include "./system/faction/ticket/ticket_txd.pwn"

#include "./system/weapon/ammo.pwn"
#include "./system/weapon/buy_weapon.pwn"
#include "./system/weapon/ammo_faction.pwn"

#include "./system/inventory/inventory_@core.pwn"

#include "./system/gangs/gangz_locker.pwn"
#include "./system/gangs/weapon_dealer.pwn"
#include "./system/gangs/main.pwn"

#include "./system/vehicle/dealer.pwn"
#include "./system/vehicle/speed_limit.pwn"
#include "./system/vehicle/register_veh.pwn"
#include "./system/vehicle/driver_test.pwn"
#include "./system/vehicle/car_trunk.pwn"



#include "./system/new_job/main_job.pwn"
#include "./system/new_job/miner.pwn"
#include "./system/new_job/pizza.pwn"
#include "./system/new_job/trashman.pwn"
#include "./system/new_job/trucker.pwn"
#include "./system/new_job/bocvac.pwn"
#include "./system/new_job/shipment.pwn"
#include "./system/new_job/wood.pwn"
#include "./system/new_job/fish.pwn"
#include "./system/new_job/anti_bug.pwn"
#include "./system/bodydame/dmg.pwn"
#include "./system/bodydame/bodydamage.pwn"
#include "./system/spray_tag/main_spraytag.pwn"
#include "./main/mysql.pwn"





#include "./system/company/company.pwn"
#include "./system/company/casino.pwn"
#include "./system/company/baicao.pwn"
#include "./system/vehicle/mechanic.pwn"
#include "./system/player_system/use_drink.pwn"
#include "./main/functions.pwn"



#include "./main/timers.pwn"
#include "./main/command.pwn"
#include "./main/area.pwn"
#include "./main/_funcs.pwn"
#include "./main/_cmds.pwn"




main() {}

public OnGameModeInit()
{

    ShowNameTags(0);
	print("Chuong trinh may chu dang duoc khoi dong, vui long cho doi....");
	g_mysql_Init();
	return 1;
}

public OnGameModeExit()
{
    g_mysql_Exit();
	return 1;
}
