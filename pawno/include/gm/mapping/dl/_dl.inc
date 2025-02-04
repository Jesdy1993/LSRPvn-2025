#include <gm/mapping/dl/river.inc>
//#include <gm/mapping/dl/school.inc>


DL_OnGameModeInit()
{   
    River_OnGameModeInit();
    //School_OnGameModeInit();
    
    return 1;
}

DL_OnPlayerConnect(playerid)
{   
    River_OnPlayerConnect(playerid);
    //School_OnPlayerConnect(playerid);
    
    return 1;
}