enum CARFIX_ENUM
{
	Float: fixX,
	Float: fixY,
	Float: fixZ,
	fixVW,
	fixInt,
	fixPickUp
}

enum FACTION_ENUM
{
	fID,
	fPickUp,
	fName[32],
	fShortName[8],
	Float:fPosX,
	Float:fPosY,
	Float:fPosZ,
	fSpawnInt,
	fSpawnVW,
	fJoinRank,
	fType,
	fRanks,
	fChatON,
	fColor,
	Float:fUniformX,
	Float:fUniformY,
	Float:fUniformZ,
	fUniformInt,
	fUniformVW,
	Carfix[CARFIX_ENUM],
	
	fPoint,
	fPointTime,
	fON
};
new Factions[MAX_FACTIONS][FACTION_ENUM];
new FactionRanks[MAX_FACTIONS][20][32];

enum RANK_ENUM
{
	rInvite,
	rUninvite,
	rRank,
	r_eRank,
	rSpawn,
	rChat,
	rTow,
	rBodyCam,
	r_eRights,
};
new FRank[MAX_FACTIONS][20][RANK_ENUM];

enum RANK_SETTINGS_DATA
{
	right_id,
	right_name[64],
	right_cmd[32]
};

new RS[9][RANK_SETTINGS_DATA] = {
	{0, "{FFFFFF}Ket nap to chuc", "/invite"},
	{1, "{FFFFFF}Loai tru khoi to chuc", "/uninvite"},
	{2, "{FFFFFF}Thay doi cap bac", "/giverank"},
	{3, "{FFFFFF}Thay doi ten cap bac", "/editrankname"},
	{4, "{FFFFFF}Thay doi diem spawn", "/editspawn"},
	{5, "{FFFFFF}Quan ly tro chuyen", "/fchat"},
	{6, "{FFFFFF}Gui phuong tien den noi tao ra", "/towcars"},
	{7, "{FFFFFF}Staff Chest Camera View", "/mdc"},
	{8, "{FFFFFF}Thay doi quyen cap bac", "/editrights"}
};

enum BORT_ENUM
{
    bortOn,
	bortName[32],
	bortObject,
	bortUsing
}
new BortInfo[MAX_PLAYERS][MAX_BORTES][BORT_ENUM];