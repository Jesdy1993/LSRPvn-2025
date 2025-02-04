enum TELES_ENUM
{
	aID,
	Float:telesPosX,
	Float:telesPosY,
	Float:telesPosZ,
	telesInt,
	telesMapName[32],
	telesOn,
	telesType
};
new AdminTeles[MAX_INTERIORS][TELES_ENUM];


// TELES TYPES //
#define 		HOUSE_SMALL_INT_TYPE 	0
#define 		HOUSE_MID_INT_TYPE 		1
#define 		HOUSE_BIG_INT_TYPE 		2
#define 		ENTRANCES_INT_TYPE 		3
#define 		BUSSINESS_INT_TYPE 		4