#include <a_samp>

#define WEAPON_UNARMED  ( 0 )
#define KEY_AIM         ( 128 )

enum ePlayerInfo
{
    bool:isCrouched,
    bool:isFiring,
         iCrouchTime,
         iLastFire,
         iLastFiring,
         iLastStrafeFire
};

new
    PlayerInfo[ MAX_PLAYERS ][ ePlayerInfo ]
;

public OnFilterScriptInit( )
{
    new
        iTick = GetTickCount( )
    ;

    for ( new i = 0; i < MAX_PLAYERS; i++ )
    {
        PlayerInfo[ i ][ isCrouched      ] = false;
        PlayerInfo[ i ][ iLastFire       ] = iTick;
        PlayerInfo[ i ][ iLastStrafeFire ] = iTick;
    }

    return 1;
}

public OnPlayerConnect( playerid )
{
    new
        iTick = GetTickCount( )
    ;

    PlayerInfo[ playerid ][ isCrouched      ] = false;
    PlayerInfo[ playerid ][ isFiring        ] = false;
    PlayerInfo[ playerid ][ iLastFire       ] = iTick;
    PlayerInfo[ playerid ][ iLastFiring     ] = iTick;
    PlayerInfo[ playerid ][ iLastStrafeFire ] = iTick;

    return 1;
}

public OnPlayerUpdate( playerid )
{
    new
             iTick = GetTickCount( ),
             iAnimationIndex = GetPlayerAnimationIndex( playerid ),
             iWeapon = GetPlayerWeapon( playerid ),
             iKeys,
             iKeysUD,
             iKeysLR
    ;

    GetPlayerKeys( playerid, iKeys, iKeysUD, iKeysLR );

    if ( ( iKeys & KEY_FIRE ) || ( ( iKeys & KEY_ACTION ) && ( iKeys & KEY_AIM ) ) )
    {
        PlayerInfo[ playerid ][ iLastFire ] = iTick;

        if ( !PlayerInfo[ playerid ][ isFiring ] )
        {
            PlayerInfo[ playerid ][ isFiring ] = true;

            PlayerInfo[ playerid ][ iLastFiring ] = iTick;
        }
    }
    else if ( PlayerInfo[ playerid ][ isFiring ] )
        PlayerInfo[ playerid ][ isFiring ] = false;

    switch ( iAnimationIndex )
    {
        case 1274: // WEAPON_CROUCH
        {
            if ( !PlayerInfo[ playerid ][ isCrouched ] )
            {
                PlayerInfo[ playerid ][ isCrouched ] = true;

                PlayerInfo[ playerid ][ iCrouchTime ] = iTick;
            }

            if ( iWeapon && ( iKeys & KEY_FIRE ) && iTick - PlayerInfo[ playerid ][ iCrouchTime ] > 300 )
                ClearAnimations( playerid );
        }

        case 1160 .. 1163, 1167: // GUNMOVE_L/R/FWD/BWD, GUN_STAND
        {
            if ( ( iKeys & KEY_FIRE ) )
            {
                switch ( iWeapon )
                {
                    case
                        WEAPON_SILENCED,
                        WEAPON_DEAGLE,
                        WEAPON_SHOTGUN,
                        WEAPON_SHOTGSPA,
                        WEAPON_MP5,
                        WEAPON_M4,
                        WEAPON_AK47,
                        WEAPON_RIFLE,
                        WEAPON_SNIPER:
                    {
                        PlayerInfo[ playerid ][ iLastStrafeFire ] = iTick;
                    }
                }
            }
        }

        case
            1231, // RUN_PLAYER
            1223, // RUN_ARMED
            1141, // FIGHTA_M
            478,  // FIGHTB_M
            489,  // FIGHTC_M
            500,  // FIGHTD_M
            759,  // KNIFE_PART
            27,   // BAT_PART
            1554  // SWORD_PART
            :
        {
            switch ( GetWeaponSlot( iWeapon ) )
            {
                case 0, 1, 8, 9, 10, 11, 12:
                {

                }
                default:
                {
                    if ( ( iKeys & KEY_AIM ) && ( iKeys & KEY_ACTION ) )
                        ClearAnimations( playerid );
                    else if ( PlayerInfo[ playerid ][ isFiring ] && iTick - PlayerInfo[ playerid ][ iLastFiring ] > 150 )
                        ClearAnimations( playerid );
                }
            }
        }
    }

    if ( ( iKeys & KEY_CROUCH ) && iTick - PlayerInfo[ playerid ][ iLastStrafeFire ] < 500 )
    {
        ClearAnimations( playerid );
        ApplyAnimation(playerid, "PED", "getup_front", 4.0, 0, 0, 0, 0, 0, 0);
      //  ApplyAnimation(playerid, "PED", "getup_front", 4.0, 0, 0, 0, 0, 500 - ( iTick - PlayerInfo[ playerid ][ iLastStrafeFire ] ), 1 );
    }

    if ( PlayerInfo[ playerid ][ isCrouched ] && iAnimationIndex != 1274 ) // WEAPON_CROUCH
        PlayerInfo[ playerid ][ isCrouched ] = false;

    return 1;
}

stock GetWeaponSlot( iWeapon )
{
    switch ( iWeapon )
    {
        case  0,      1: return  0; // Unarmed
        case  2  ..   9: return  1; // Melee
        case 22  ..  24: return  2; // Pistol
        case 25  ..  27: return  3; // Shotgun
        case 28, 29, 32: return  4; // SMG
        case 30,     31: return  5; // Machinegun
        case 33,     34: return  6; // Rifle
        case 35  ..  38: return  7; // Heavy
        case 16, 18, 39: return  8; // Projectile
        case 42,     43: return  9; // Special
        case 14        : return 10; // Gifts
        case 44  ..  46: return 11; // Special
        case 40        : return 12; // Detonator
    }

    return 0;
}
