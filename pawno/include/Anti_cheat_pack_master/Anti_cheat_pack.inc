#include <Anti_cheat_pack_master\rAgc>//Anti gun cheats -Rogue
#include <Anti_cheat_pack_master\FLaggers>//Lag spike\desnyc detector- Rogue
#include <Anti_cheat_pack_master\Opba>//Anti airbreak\teleport - Rogue
#include <Anti_cheat_pack_master\rAct>//Anti car trolls - Rogue
#include <Anti_cheat_pack_master\AntiJC>//Anti jetpack cheats- Rogue
#include <Anti_cheat_pack_master\rEac>//Anti carswing\particlespam - Lorenc_
#include <Anti_cheat_pack_master\rAmc>//Anti money cheats- Rogue
#include <Anti_cheat_pack_master\rAGM>//Anti godmode -Rogue
#include <Anti_cheat_pack_master\rAntiBuggers>//Depresses 5 abusing bugs triggered by cheats. -Rogue
#include <Anti_cheat_pack_master\AFkill> //Anti fake kill -Rogue
#include <Anti_cheat_pack_master\AntiFC>//Anti fake clients - Rogue
#include <Anti_cheat_pack_master\rAsc>//Anti speed cheats- Rogue
#include <Anti_cheat_pack_master\rVM>//Anti illegal car mods -Emmet_
#include <Anti_cheat_pack_master\rAcs>//Anti car spam - Rogue
#include <Anti_cheat_pack_master\AntiSpam>//Anti chat spam- Rogue
#include <Anti_cheat_pack_master\AntiSba>//Anti slide bug abuse- Rogue

#if !defined FILTERSCRIPT 

#if defined RogueAC_OnGameModeInit
	forward RogueAC_OnGameModeInit();
#endif

public OnGameModeInit()
{
	print("	 [[--|| Rogue-AC V7.0 ||--]]	 ");
	print("	 [[--|| Rogue Anti cheat version 7.0 ||--]]	  ");
	print("	 [[--|| Successfully Loaded! ||--]]	  ");
	#if defined RogueAC_OnGameModeInit
		return RogueAC_OnGameModeInit();
	#else
		return 1;
	#endif
}

#if defined _ALS_OnGameModeInit
  #undef OnGameModeInit
#else
	#define _ALS_OnGameModeInit
#endif

#define OnGameModeInit RogueAC_OnGameModeInit

#endif
