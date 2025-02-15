enum APART_ENUM
{
	aID,
	Float:aPosX,
	Float:aPosY,
	Float:aPosZ,
	Float:aExitX,
	Float:aExitY,
	Float:aExitZ,
	aExitInt,
	aExitVW,
	aPosInt,
	aPosVW,
	aApartOn,
	aCheckPoint,
	aApartName[168]
};
new ApartInfo[MAX_APART][APART_ENUM];

enum APART_INTERIORS_ENUM
{
	aID,
	aName[32],
	Float:aPosX,
	Float:aPosY,
	Float:aPosZ,
	aInt
};
new E_APARTINT[18][APART_INTERIORS_ENUM] = {
	
	{0, "", 						0.0, 		0.0, 		0.0, 		0},
	{1, "Ghetto Hotel", 			162.9840, 	-24.6746,	996.4470,  	1},
	{2, "Ghetto Hotel 2", 			2099.8064, 	-1180.0836,	1029.6458, 	1},
	{3, "Hotel",					313.3590,	53.9657,	1072.7437,  1},
	{4, "Hotel 2",					787.8120, 	-896.5082, 	482.8069, 	1},
	{5, "Civil Complex 1", 			1528.69995, -26.70, 	1002.5,		1},
	{6, "Ghetto Complex 1", 		665.6864, 	-673.1936, 	787.2360, 	1},
	{7, "Ghetto Complex 2", 		1469.9661, 	-190.8232, 	1031.9879, 	1},
	{8, "China District Complex",	1632.6002, 	744.2397, 	900.9210, 	1},
	{9, "Civil Complex 2",			1256.0890, 	-1848.6511, 612.0620, 	1},
	{10, "Poor Complex",			2795.1311, 	-1215.3330, 984.7050, 	1},
	{11, "Hotel Complex 1", 		-152.8758,	37.3332, 	1001.0859, 	1},
	{12, "Hotel Complex 2", 		-528.3482, 	-361.4522, 	1001.0859, 	1},
	{13, "Ghetto Complex 3", 		-2055.2624, 1013.7964, 	1464.8419, 	1},
	{14, "Elite Complex",			619.0,		-1397.0,	1000.0,		1},
	{15, "Entrance", 				1301.7100,	-1467.8789, 3001.0859, 16},
	{16, "Motel",					1767.8296, 	-1541.9338,	1187.3810, 14},
	{17, "Motel 2",					2168.4255,	-1720.0083,	1730.8040, 15}
}; //2393.54980469 -35.14160156 2521.51098633