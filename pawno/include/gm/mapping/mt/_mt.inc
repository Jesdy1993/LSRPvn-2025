#include <gm/mapping/mt/domikiroad.inc>
#include <gm/mapping/mt/hall-adm.inc>


MT_OnGameModeInit()
{   
    Domiki_OnGameModeInit();
    Hall_OnGameModeInit();
    
    return 1;
}

MT_OnPlayerConnect(playerid)
{   
    Domiki_OnPlayerConnect(playerid);
    Hall_OnPlayerConnect(playerid);
    
    return 1;
}