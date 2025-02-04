/**
* Actors system (../gm/actors)
*
* @author  Jewking
* @version 0.1
* @since   2021-06-01 
*
* @link     Log link:     https://github.com/Rams25/VCRP_FR/commits/main
* @link     Todo link:    -
* @return   last edits by Jewking (x/x/2021)
*
*/

//#include    <actor_streamer.inc> 

#define     MAX_DYNAMIC_ACTORS      200     // Actor limit
#define     MAX_PLAYERS_ACTORS      5       // Actors per player
#define     MAX_ACTORS_EDITORS      3       // Co-owners 

#define     ADMIN_CREATION  0
#define     USER_CREATION   1

#define     ACTOR_CREATION  1111

enum ActorsData
{
    ActorID,
    bool:ActorOn,
    ActorType,
    ActorStatus,
    ActorName[MAX_PLAYER_NAME],
    Float:actPosX,
    Float:actPosY,
    Float:actPosZ,
    Float:actPosA,
    ActorVW,
    ActorInt,
    ActorSkin,
    ActorAnimLib,
    ActorAnimN, 
    bool:ActorInvulnerable,
    Float:ActorHealth,

    ActorOwner,
    ActorDate,
    ActorPermissions[MAX_ACTORS_EDITORS],
    ActorEditedBy,
    ActorEditedDate,

    ActorPed,
    Text3D:ActorLabel,
    ActorTimer
};
new ActorsInfo[MAX_DYNAMIC_ACTORS][ActorsData];

enum {
    PED_NONE = 0,
    PED_AIMED = 1,
    PED_DISSENT = 2,
    PED_DEAD = 3,
    PED_INJURED = 4,
    PED_ACTION = 5,
    PED_WAITING = 6,
    PED_PROCESS = 7,
    PED_CANCEL = 8,
    PED_FINISH = 9
};

#define MAX_ACTOR_STATUS_CHAR 16
new ActorStatusName[][16] =
{
    "PED_NONE",// = 0,
    "PED_AIMED",// = 1,
    "PED_DISSENT",// = 2,
    "PED_DEAD",// = 3,
    "PED_INJURED",// = 4,
    "PED_ACTION",// = 5,
    "PED_WAITING",// = 6,
    "PED_PROCESS",// = 7,
    "PED_CANCEL",// = 8
    "PED_FINISH"// = 9
};

enum {
    REGULAR_NPC = 0,
    POLICE_NPC = 1,
    BUYER_NPC = 2,
    CASHIER_NPC = 3,
    TAXI_NPC = 4,
};

#define MAX_ACTOR_TYPE_CHAR 10
new actors_type[][MAX_ACTOR_TYPE_CHAR] = 
{
    "REGULAR",
    "POLICE",
    "BUYER",
    "CASHIER",
    "TAXI"
};

new ActorDialogs[][][128] = 
{
    {   //PLAYER_NPC
        {"Hey!"},
        {"Dung giet toi!"},
        {"Toi goi canh sat ngay lap tuc!!"},
        {""},
        {"Oh.. no.."},
        {""},
        {""},
        {""},
        {""},
        {""}
    },
    {   //POLICE_NPC
        {"Thoi nao, khong co gi de xem o day "},
        {"Dung lam dieu do."},
        {"Toi se goi canh sat ngay bay gio!"},
        {""},
        {"Oh.. no.."},
        {""},
        {""},
        {""},
        {""},
        {""}
    },
    {   //BUYER_NPC
        {"Hello!"},
        {"*screech* LAM ON KHONG!"},
        {"Toi se goi canh sat ngay bay gio!"},
        {""},
        {"Oh.. no.."},
        {""},
        {""},
        {""},
        {""},
        {""}
    },
    {   //CASHIER_NPC
        {"Hi! (( Su dung /buy ))"},
        {"Xin dung giet toi! Toi se lam tat ca nhung gi ban muon!"},
        {"Me may! Tao se goi canh sat ngay bay gio! Cut!"},
        {""},
        {"Oh.. no.."},
        {""},
        {""},
        {""},
        {"Oh.. Shit... Toi can goi canh sat!"},
        {"Toi da lam moi thu nhu ban yeu cau!"}
    },
    {   //TAXI_NPC
        {"Toi dang doi taxi!"},
        {"Taxi?"},
        {"Toi se goi canh sat ngay bay gio!"},
        {""},
        {"Oh.. no.."},
        {"Ngay dep troi .. Toi da goi taxi!"},
        {"Toi dang doi mot tai xe taxi."},
        {"(( TRONG TAXI ))"},
        {"Lai xe tot!"},
        {"Thank you! Bye!"}
    }
};


#define MAX_ACTOR_LIB_CHAR 10
new ActorAnimationLib[][MAX_ACTOR_LIB_CHAR] = 
{
    "DANCING", 
    "BAR",
    "BEACH",
    "BOMBER",
    "BUDDY",
    "CAMERA",
    "ped",
    "MISC"
};

#define MAX_ANIMS_IN_LIB    23
#define MAX_ACTOR_NAME_CHAR 24
new ActorAnimationName[sizeof(ActorAnimationLib)][MAX_ANIMS_IN_LIB][MAX_ACTOR_NAME_CHAR] = 
{
    {   //DANCING
        "bd_clap",
        "bd_clap",
        "dance_loop",
        "DAN_Down_A",
        "DAN_Left_A",
        "DAN_Loop_A",
        "DAN_Right_A",
        "DAN_Up_A",
        "dnce_M_a",
        "dnce_M_b",
        "dnce_M_c",
        "dnce_M_d",
        "dnce_M_e",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-"
    },
    {   //BAR
        "Barcustom_loop", 
        "BARman_idle", 
        "Barserve_bottle", 
        "Barserve_give", 
        "Barserve_glass", 
        "Barserve_loop",
        "dnk_stndF_loop", 
        "dnk_stndM_loop",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-"
    },
    {   //BEACH
        "bather",
        "Lay_Bac_Loop",
        "ParkSit_M_loop",
        "ParkSit_W_loop",
        "SitnWait_loop_W",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-"
    },
    {   //BOMBER
        "BOM_Plant",
        "BOM_Plant_Loop",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-"
    },
    {   //BUDDY
        "buddy_crouchfire",
        "buddy_crouchreload", 
        "buddy_fire",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-"
    },
    {   //CAMERA
        "camcrch_cmon", 
        "camcrch_idleloop", 
        "camcrch_stay",
        "camcrch_to_camstnd",
        "camstnd_cmon",
        "camstnd_idleloop",
        "camstnd_lkabt", 
        "camstnd_to_camcrch",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-"
    },
    {   //MISC
        "Hiker_Pose",
        "Hiker_Pose_L",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-",
        "-"
    },
    {   //ped
        "WALK_armed",
        "WALK_civi", 
        "WALK_csaw",
        "Walk_DoorPartial", 
        "WALK_drunk", 
        "WALK_fat",
        "WALK_fatold",
        "WALK_gang1",
        "WALK_gang2", 
        "WALK_old",
        "WALK_player",
        "WALK_rocket",
        "WALK_shuffle", 
        "WALK_start", 
        "WALK_start_armed",
        "WALK_start_csaw", 
        "WALK_start_rocket", 
        "Walk_Wuzi", 
        "WEAPON_crouch",
        "XPRESSscratch", 
        "sprint_civi",
        "sprint_panic", 
        "Sprint_Wuzi"
    }
};