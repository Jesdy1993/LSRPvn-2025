enum CARGO_OBJECT_ENUM
{
	oOn,
	oObj,
	Text3D:oLabel,
	Float:oX,
	Float:oY,
	Float:oZ,
	oInt,
	oVW,
	oProduct
}

new CargoObject[MAX_CARGO_OBJ][CARGO_OBJECT_ENUM];

enum TRUCK_CARGO_ENUM
{
	tID,
	tType,
	tName[64],
	tStorage,
	tStorageSize,
	tPrice,
	tProductID,
	tProductAmount,
	tPack,
	tGps,
	tLocked,
	Float: tPosX,
	Float: tPosY,
	Float: tPosZ,
	Text3D:tLabel,
	tPickup,
	tOn,
	tResult
}

new TruckCargo[MAX_TRUCK_CARGO][TRUCK_CARGO_ENUM];