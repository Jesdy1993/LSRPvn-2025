#define 	MAX_VENDINGMACHINE     	100 
#define		TYPE_FOOD			(1)			// type of trash
#define 	TYPE_SPRUNK			(2)			// type of trash

enum Vending_Enum
{
	vendingID,
	Float: vendingX,
	Float: vendingY,
	Float: vendingZ,
	Float: vendingRX,
	Float: vendingRY,
	Float: vendingRZ,
	vendingOwner[MAX_PLAYER_NAME],
	vendingOwnerID,
	vendingType,
    vendingPrice,
	vendingLock,
	vendingAlarm,
    vendingObject,
    vendingVault,
	vendingInt,
	vendingVW,
    Text3D:vendingLabel
	
}
new VendingInfo[MAX_VENDINGMACHINE][Vending_Enum];