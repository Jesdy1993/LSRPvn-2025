#include <gm/mapping/bl/azc_blocks.inc>
#include <gm/mapping/bl/blocks.inc>
#include <gm/mapping/bl/DrivingSchool.inc>
#include <gm/mapping/bl/fd_blocks.inc>
#include <gm/mapping/bl/taxi.inc>
#include <gm/mapping/bl/training.inc>

#include <gm/mapping/bl/fc.inc>

BL_OnGameModeInit()
{   
    AZC_OnGameModeInit();
    Blocks_OnGameModeInit();
    DS_OnGameModeInit();
    FD_OnGameModeInit();
    TaxiExt_OnGameModeInit();
    Train_OnGameModeInit();
    
    FC_OnGameModeInit();
    return 1;
}

BL_OnPlayerConnect(playerid)
{   
    AZC_OnPlayerConnect(playerid);
    Blocks_OnPlayerConnect(playerid);
    DS_OnPlayerConnect();
    FD_OnPlayerConnect(playerid);
    TaxiExt_OnPlayerConnect();
    Train_OnPlayerConnect(playerid);
    
    FC_OnPlayerConnect(playerid);
    return 1;
}