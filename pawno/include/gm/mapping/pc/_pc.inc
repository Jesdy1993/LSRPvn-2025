#include <gm/mapping/pc/main.inc>
#include <gm/mapping/pc/sto.inc>

PC_OnGameModeInit()
{   
    Main_OnGameModeInit();
    Sto_OnGameModeInit();
    
    return 1;
}

PC_OnPlayerConnect(playerid)
{   
    Main_OnPlayerConnect(playerid);
    Sto_OnPlayerConnect();
    
    return 1;
}