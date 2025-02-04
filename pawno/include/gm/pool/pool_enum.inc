enum POOL_ENUM
{
    bID,
    bBalls[16],
    bTable,
    bInterior,
    bWorld,
    bUsed,
    bPlayer1,
    bPlayer2,
    bCurrentShooter,
    bLastShooter,
    Float:bPosX,
    Float:bPosY,
    Float:bPosZ,
};
new PoolInfo[MAX_POOL][POOL_ENUM];

new CueTimer[MAX_PLAYERS] = {-1, ...};