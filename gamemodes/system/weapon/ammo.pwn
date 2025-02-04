

forward ThayDan(playerid);
public ThayDan(playerid)
{
    if(GetPVarInt(playerid, "IsInArena") >= 0) return 1;
    new weapon, ammosd, string[128];
    GetPlayerWeaponData(playerid, 2, weapon, ammosd);
    if(weapon == 24 && PlayerInfo[playerid][pAmmo][ 1 ] == 1)
    {
        if(PlayerInfo[playerid][pBangDan][ 6 ] >= 1)
        {
            RemovePlayerWeapon(playerid, 24);
            GivePlayerValidWeapon(playerid, weapon, 1);
            PlayerInfo[playerid][pBangDan][ 6 ]  -= 1;
            GivePlayerAmmoEx(playerid, weapon, 7);
            format(string, sizeof(string), "{FF8000}* {C2A2DA}%s dang thay dan..", GetPlayerNameEx(playerid));
            ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
            ApplyAnimation(playerid, "PYTHON", "python_reload", 4.0, 0, 0, 0, 0, 0, 1);
            SetPlayerArmedWeapon(playerid, weapon);
            GameTextForPlayer(playerid, "~y~Dang thay dan", 5000, 3);
        }
    }
    GetPlayerWeaponData(playerid, 3, weapon, ammosd);
    if(weapon == 25 && PlayerInfo[playerid][pAmmo][ 2 ] == 1)
    {
        if(PlayerInfo[playerid][pBangDan][ 2 ]  >= 1)
        {
            RemovePlayerWeapon(playerid, weapon);
            GivePlayerValidWeapon(playerid, weapon, 1);
            PlayerInfo[playerid][pBangDan][ 2 ]  -= 1;
            GivePlayerAmmoEx(playerid, weapon, 11);
            format(string, sizeof(string), "{FF8000}* {C2A2DA}%s dang thay dan..", GetPlayerNameEx(playerid));
            ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
            ApplyAnimation(playerid, "BUDDY", "buddy_reload", 4.0, 0, 0, 0, 0, 0, 1);
            SetPlayerArmedWeapon(playerid, weapon);
            GameTextForPlayer(playerid, "~y~Dang thay dan", 5000, 3);
        }
    }
    GetPlayerWeaponData(playerid, 3, weapon, ammosd);
    if(weapon == 27 && PlayerInfo[playerid][pAmmo][ 2 ] == 1)
    {
        if(PlayerInfo[playerid][pBangDan][ 10 ]  >= 1)
        {
            RemovePlayerWeapon(playerid, weapon);
            GivePlayerValidWeapon(playerid, weapon, 1);
            PlayerInfo[playerid][pBangDan][ 10 ]  -= 1;
            GivePlayerAmmoEx(playerid, weapon, 7);
            format(string, sizeof(string), "{FF8000}* {C2A2DA}%s dang thay dan..", GetPlayerNameEx(playerid));
            ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
            ApplyAnimation(playerid, "PYTHON", "python_reload", 4.0, 0, 0, 0, 0, 0, 1);
            SetPlayerArmedWeapon(playerid, weapon);
            GameTextForPlayer(playerid, "~y~Dang thay dan", 5000, 3);
        }
    }
    GetPlayerWeaponData(playerid, 5, weapon, ammosd);
    if(weapon == 31 && PlayerInfo[playerid][pAmmo][ 4 ] == 1)
    {
        if(PlayerInfo[playerid][pBangDan][ 9 ]  >= 1)
        {
            RemovePlayerWeapon(playerid, weapon);
            GivePlayerValidWeapon(playerid, weapon, 1);
            PlayerInfo[playerid][pBangDan][ 9 ]  -= 1;
            GivePlayerAmmoEx(playerid, weapon, 50);
            format(string, sizeof(string), "{FF8000}* {C2A2DA}%s dang thay dan..", GetPlayerNameEx(playerid));
            ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
            ApplyAnimation(playerid, "PYTHON", "python_reload", 4.0, 0, 0, 0, 0, 0, 1);
            SetPlayerArmedWeapon(playerid, weapon);
            GameTextForPlayer(playerid, "~y~Dang thay dan", 5000, 3);
        }
    }
    GetPlayerWeaponData(playerid, 5, weapon, ammosd);
    if(weapon == 30 && PlayerInfo[playerid][pAmmo][ 4 ] == 1)
    {
        if(PlayerInfo[playerid][pBangDan][ 8 ]  >= 1)
        {
            PlayerInfo[playerid][pBangDan][ 8 ]  -= 1;
            RemovePlayerWeapon(playerid, weapon);
            GivePlayerValidWeapon(playerid, weapon, 1);
            GivePlayerAmmoEx(playerid, weapon, 30);
            format(string, sizeof(string), "{FF8000}* {C2A2DA}%s dang thay dan..", GetPlayerNameEx(playerid));
            ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
            ApplyAnimation(playerid, "PYTHON", "python_reload", 4.0, 0, 0, 0, 0, 0, 1);
            SetPlayerArmedWeapon(playerid, weapon);
            GameTextForPlayer(playerid, "~y~Dang thay dan", 5000, 3);
        }
    }
    GetPlayerWeaponData(playerid, 4, weapon, ammosd);
    if(weapon == 29 && PlayerInfo[playerid][pAmmo][ 3 ] == 1)
    {
        if(PlayerInfo[playerid][pBangDan][ 5 ]  >= 1)
        {
            PlayerInfo[playerid][pBangDan][ 5 ]  -= 1;
            RemovePlayerWeapon(playerid, weapon);
            GivePlayerValidWeapon(playerid, weapon, 1);
            GivePlayerAmmoEx(playerid, weapon, 30);
            format(string, sizeof(string), "{FF8000}* {C2A2DA}%s dang thay dan..", GetPlayerNameEx(playerid));
            ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
            ApplyAnimation(playerid, "PYTHON", "python_reload", 4.0, 0, 0, 0, 0, 0, 1);
            SetPlayerArmedWeapon(playerid, weapon);
            GameTextForPlayer(playerid, "~y~Dang thay dan", 5000, 3);
        }
    }
    GetPlayerWeaponData(playerid, 4, weapon, ammosd);
    if(weapon == 28 && PlayerInfo[playerid][pAmmo][ 3 ] == 1)
    {
        if(PlayerInfo[playerid][pBangDan][ 3 ]  >= 1)
        {
            PlayerInfo[playerid][pBangDan][ 3 ] -= 1;
            RemovePlayerWeapon(playerid, weapon);
            GivePlayerValidWeapon(playerid, weapon, 1);
            GivePlayerAmmoEx(playerid, weapon, 30);
            format(string, sizeof(string), "{FF8000}* {C2A2DA}%s dang thay dan..", GetPlayerNameEx(playerid));
            ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
            ApplyAnimation(playerid, "PYTHON", "python_reload", 4.0, 0, 0, 0, 0, 0, 1);
            SetPlayerArmedWeapon(playerid, weapon);
            GameTextForPlayer(playerid, "~y~Dang thay dan", 5000, 3);
        }
    }
    GetPlayerWeaponData(playerid, 4, weapon, ammosd);
    if(weapon == 32 && PlayerInfo[playerid][pAmmo][ 3 ] == 1)
    {
        if(PlayerInfo[playerid][pBangDan][ 4 ]  >= 1)
        {
            PlayerInfo[playerid][pBangDan][ 4 ]  -= 1;
            RemovePlayerWeapon(playerid, weapon);
            GivePlayerValidWeapon(playerid, weapon, 1);
            GivePlayerAmmoEx(playerid, weapon, 30);
            format(string, sizeof(string), "{FF8000}* {C2A2DA}%s dang thay dan..", GetPlayerNameEx(playerid));
            ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
            ApplyAnimation(playerid, "PYTHON", "python_reload", 4.0, 0, 0, 0, 0, 0, 1);
            SetPlayerArmedWeapon(playerid, weapon);
            GameTextForPlayer(playerid, "~y~Dang thay dan", 5000, 3);
        }
    }
    GetPlayerWeaponData(playerid, 6, weapon, ammosd);
    if(weapon == 33 && PlayerInfo[playerid][pAmmo][ 5 ] == 1)
    {
        if(PlayerInfo[playerid][pBangDan][ 7 ]  >= 1)
        {
            PlayerInfo[playerid][pBangDan][ 7 ]  -= 1;
            RemovePlayerWeapon(playerid, 33);
            GivePlayerValidWeapon(playerid, 33, 0);
            GivePlayerAmmoEx(playerid, 33, 12);
            format(string, sizeof(string), "{FF8000}* {C2A2DA}%s dang thay dan..", GetPlayerNameEx(playerid));
            ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
            ApplyAnimation(playerid, "PYTHON", "python_reload", 4.0, 0, 0, 0, 0, 0, 1);
            SetPlayerArmedWeapon(playerid, weapon);
            GameTextForPlayer(playerid, "~y~Dang thay dan", 5000, 3);
        }
    }
    GetPlayerWeaponData(playerid, 6, weapon, ammosd);
    if(weapon == 34 && PlayerInfo[playerid][pAmmo][ 5 ] == 1)
    {
        if(PlayerInfo[playerid][pBangDan][ 11 ]  >= 1)
        {
            PlayerInfo[playerid][pBangDan][ 11 ]  -= 1;
            RemovePlayerWeapon(playerid, 34);
            GivePlayerValidWeapon(playerid, 34, 0);
            GivePlayerAmmoEx(playerid, 34, 12);
            format(string, sizeof(string), "{FF8000}* {C2A2DA}%s dang thay dan..", GetPlayerNameEx(playerid));
            ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
            ApplyAnimation(playerid, "PYTHON", "python_reload", 4.0, 0, 0, 0, 0, 0, 1);
            SetPlayerArmedWeapon(playerid, weapon);
            GameTextForPlayer(playerid, "~y~Dang thay dan", 5000, 3);
        }
    }
    GetPlayerWeaponData(playerid, 2, weapon, ammosd);
    if(weapon == 22 && PlayerInfo[playerid][pAmmo][ 1 ] == 1)
    {
        if(PlayerInfo[playerid][pBangDan][ 1 ]  >= 1)
        {
            PlayerInfo[playerid][pBangDan][ 1 ]  -= 1;
            RemovePlayerWeapon(playerid, 22);
            GivePlayerValidWeapon(playerid, 22, 0);
            GivePlayerAmmoEx(playerid, 22, 18);
            format(string, sizeof(string), "{FF8000}* {C2A2DA}%s dang thay dan..", GetPlayerNameEx(playerid));
            ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
            ApplyAnimation(playerid, "PYTHON", "python_reload", 4.0, 0, 0, 0, 0, 0, 1);
            SetPlayerArmedWeapon(playerid, weapon);
            GameTextForPlayer(playerid, "~y~Dang thay dan", 5000, 3);
        }
    }
    GetPlayerWeaponData(playerid, 2, weapon, ammosd);
    if(weapon == 23 && PlayerInfo[playerid][pAmmo][ 1 ] == 1)
    {
        if(PlayerInfo[playerid][pBangDan][ 1 ]  >= 1)
        {
            PlayerInfo[playerid][pBangDan][ 1 ]  -= 1;
            RemovePlayerWeapon(playerid, 23);
            GivePlayerValidWeapon(playerid, 23, 0);
            GivePlayerAmmoEx(playerid, 23, 18);
            format(string, sizeof(string), "{FF8000}* {C2A2DA}%s dang thay dan..", GetPlayerNameEx(playerid));
            ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
            ApplyAnimation(playerid, "PYTHON", "python_reload", 4.0, 0, 0, 0, 0, 0, 1);
            SetPlayerArmedWeapon(playerid, weapon);
            GameTextForPlayer(playerid, "~y~Dang thay dan", 5000, 3);
        }
    }
    return 1;
}