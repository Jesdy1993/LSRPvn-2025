#include <gm/mapping/a_ints/ints.inc>
#include <gm/mapping/a_ints/FD_INT.inc>
#include <gm/mapping/a_ints/garages.inc>
#include <gm/mapping/a_ints/hospital.inc>
#include <gm/mapping/a_ints/sheriffoffice.inc>
#include <gm/mapping/a_ints/library.inc>
#include <gm/mapping/a_ints/prachka.inc>
#include <gm/mapping/a_ints/prison.inc>
#include <gm/mapping/a_ints/pharmacy.inc>
#include <gm/mapping/a_ints/office.inc>
#include <gm/mapping/a_ints/small24-7.inc>

Ints_OnGameModeInit() 
{
    Others_OnGameModeInit();
    FDint_OnGameModeInit();
    Garages_OnGameModeInit();
    Hospital_OnGameModeInit();
    SO_OnGameModeInit();
    Lib_OnGameModeInit();
    Phrachka_OnGameModeInit();
    Prison_OnGameModeInit();
    Pharmacy_OnGameModeInit();
    Office_OnGameModeInit();
    SmallShop_OnGameModeInit();
    return 1;
}

/*Ints_OnPlayerConnect(playerid)
{
    return 1;
}*/
