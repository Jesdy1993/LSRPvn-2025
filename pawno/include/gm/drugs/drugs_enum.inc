
#define Part_Mixing   9990
#define Extra_Mixing  9991
#define Final_Mixing  9992

#define DRYER_OBJECT 		1208
#define CENTRIFUGE_OBJECT 	19830
#define MIXER_OBJECT 		19585
#define REACTOR_OBJECT 		920  
                            //2360 - reactor
#define DEHYDRATER_OBJECT 	2002
#define PUMP_OBJECT 		1244

enum PLANTS_ENUM
{
	pID,
	pType,
	pPlanter[52],
	pGrowTime,
	pStartTime,
	Float:pX,
	Float:pY,
	Float:pZ,
	pInt,
	pVW,
	pObject,
	Text3D:pLabel,
	pPlanted,
	pPlantDate[64]
}
new CropsInfo[MAX_PLANTS][PLANTS_ENUM];

//#define     MAX_CHEMICAL        (10)
//#define     MAX_DRUGS           (30)
#define     MAX_CHEMISTRY       (150)
#define     MAX_CHEM_DROPS      (60)

enum DRUG_DATA
{
	UID,
    MAIN,
	NAME[32],
	TYPE, // 1 health, 2 armour 3 decreas incoming damage 4 invisible for a couple seconds or run fast (play anmation when they run)
	CODE[32],
	CONTROL, // 1 heating 2 cooling
    POINT, // Need x melting / cooling point to finish
    STATUS // 0 labile / 1 stable
};

enum CHECK_DRUG_DATE
{
	onedrug,
    twodrug
};


enum P_CHEMICALDATA
{
    pSlot,
	bool:Selected
};
new P_CHEMICAL[MAX_PLAYERS][MAX_INV_SLOTS][P_CHEMICALDATA];

enum BreakingBadData
{                       // IN DATABASE by Jewking
    temp_ID,            //id
	bool:IsWorking,     //isworking
    WorkType,           //worktype
    BuildingID,         //building
    BuildingType,       //buildingtype
    FurnID,             //FurnID
    NeedTime,           //time
    Material,           //material
    Float: Amount,      //amount
    Float: Quality,     //quality
    Extra[3],           //extra1 extra2 extra2
    Type,               //type
    Float: Temperature, //temperature
    Float: curTemperature,  //curTemperature
    Timer,                   
    OverPoint,
    Float: Degree,      //Degree
    Control,            //Control
    BeingCrystal,       //ready
    Text3D:osLabel,
    reactorSmoke,

    Float:dropPosX,
	Float:dropPosY,
	Float:dropPosZ,
	Float:dropPosRX,
	Float:dropPosRY,
	Float:dropPosRZ,
    dropInt,
    dropVW,
    dropTime,
    dropObject
}
new Chemistry[MAX_CHEMISTRY][BreakingBadData];
new DropChemistry[MAX_CHEM_DROPS][BreakingBadData];


/*
If it's a labile chemical, when they made a wrong step, black smoke will be actived, and if they don't have gas mask they will be faded away.
*/

new E_CHEMICAL[][DRUG_DATA] =
{
    //ID----MAIN----NAME------------TYPE---CODE--CONTROL-POINT-STATUS//
    {0,     0,  "Red phosphorus",        1, "2P2O5",        1, 200,     0},
    {1,     0,  "Methylbenzyl ketone",     1, "C9H10O",       1, 216,     0},
    {2,     1,  "Methylamine",             1, "CH3NH2",       1, 172,     0}, //MDMA
    {3,     0,  "Heliotropin",           1, "C8H6O3",       2, -120,    1},
    {4,     1,  "Ephedrine",               2, "C10H15NO",     1, 137,      1}, //Мет
    {5,     0,  "Mineral chameleon",  3, "KMnO4",        1, 240,     1},
    {6,     0,  "Chloroform",             3, "CHCl3",        1, 161,      1},
    {7,     0,  "Ether",                  3, "C4H10O",       1, 160,     0}, // if this chemical's point over 160 > 3 seconds and amount > 3mg it will explode
    {8,     0,  "Hydrogen chloride",          1, "HCL",          1, -144,    1}, // ядовит
    {9,     1,  "Methanol",               1, "CH3OH",        1, 97,      0}, // Амфетамин 
    {10,    1,  "Lyserginic acid",  2, "C8H8O2",       1, 265,     0}, //LSD
    {11,    0,  "Ecgonin",               1, "C9H15NO3",     1, -199,    1}, //
    {12,    1,  "Coca leaves",           3, "coca",  1, 15,      0}, // Кокаин (254)
    {13,    1,  "Poppy",                   2, "poppy",          1, 202,     0},  // Героин
    {14,    1,  "Dried coca leaves",  3, "coca",  1, 194,     0}, // Кокаин 
    {15,    1,  "Dried poppy",          2, "poppy",          1, 152,     0}  // Героин
};

new check_drug[][CHECK_DRUG_DATE] =
{
    {-1, -1},
    {-1, -1},
    {1, 10},  //MDMA
    {-1, -1},
    {6, 7},  //Мет
    {-1, -1},
    {5, 9},  //LSD
    {-1, -1},
    {-1, -1},
    {-1, -1},
    {-1, -1},
    {-1, -1},
    {11, 3}, // Амфетамин 
    {9, 10}, // Кокаин
    {6, 8}, // Героин
    {9, 10}, // Кокаин
    {6, 8}  // Героин
};

new gString[256];