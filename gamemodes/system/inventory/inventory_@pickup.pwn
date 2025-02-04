#include <YSI\y_hooks>

stock CreateItemOnFoot(playerid,itemid,amount) {
	new Float:x,Float:y,Float:z,object_create_id=0,string[129];
	GetPlayerPos(playerid, x,y,z);
	for(new i = 1 ; i < MAX_SPAM_OBJECT; i++) {
		if(ObjectInv[i][@ItemObjectID] == 0) {
			object_create_id = i;
		}
	}
	if(object_create_id == 0) return 1;
	ObjectInv[object_create_id][@ItemObject] = CreateDynamicObject(ItemInfo[itemid][ItemObject],x,y,z-0.7,0,0,0);
    format(string, sizeof string, "%s(%d)\nSo luong: %d\nSu dung 'C' + Y de nhat",  ItemInfo[itemid][ItemName],
    itemid, amount );
    ObjectInv[object_create_id][@ItemText] = CreateDynamic3DTextLabel(string, 0xDFC57BAA, x,y,z-0.7, 10.0);
    ObjectInv[object_create_id][@ItemID] = itemid;
    ObjectInv[object_create_id][@ItemObjectID] = object_create_id;
    ObjectInv[object_create_id][@ItemPostion][0] = x,ObjectInv[object_create_id][@ItemPostion][1] = y,ObjectInv[object_create_id][@ItemPostion][2] = z;
	ObjectInv[object_create_id][@ItemAmount] = amount;
	return 1;
}
stock PickUpItem(playerid) {
	for(new i = 0 ; i < MAX_SPAM_OBJECT; i++) {
		if(ObjectInv[i][@ItemObjectID] != 0 && IsPlayerInRangeOfPoint(playerid, 2.5, ObjectInv[i][@ItemPostion][0] ,ObjectInv[i][@ItemPostion][1] ,ObjectInv[i][@ItemPostion][2] )) 
		{
			Inventory_@Add(playerid, ObjectInv[i][@ItemID] , ObjectInv[i][@ItemAmount] );
			ObjectInv[i][@ItemID] = 0;
			ObjectInv[i][@ItemAmount] = 0;
			ObjectInv[i][@ItemObjectID] = 0;
			DestroyDynamicObject(ObjectInv[i][@ItemObject]);
			DestroyDynamic3DTextLabel(ObjectInv[i][@ItemText]);
			return 1;
		}
	}
	return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {

    if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_DUCK)
    {
    
        if(newkeys & KEY_YES)
        {  
        	print("aloaloalo");
 
	        PickUpItem(playerid);
	    }
	}
}