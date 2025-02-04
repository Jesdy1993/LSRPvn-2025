Item_OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	new Float:oldX, Float:oldY, Float:oldZ, Float:oldRotX, Float:oldRotY, Float:oldRotZ;
	
	GetDynamicObjectPos(objectid, oldX, oldY, oldZ);
	GetDynamicObjectRot(objectid, oldRotX, oldRotY, oldRotZ);

	if (GetPVarInt(playerid, #edit_item) != 0 && (response == EDIT_RESPONSE_FINAL || response == EDIT_RESPONSE_CANCEL))
	{
	    new id = GetPVarInt(playerid, #edit_item)-1;
	    DeletePVar(playerid, #edit_item);

	    if (GetDistanceBetweenPoints(x, y, z, ItemDrop[id][dropPosX], ItemDrop[id][dropPosY], ItemDrop[id][dropPosZ]) > 10.0)
	    {
     		SetDynamicObjectPos(objectid, ItemDrop[id][dropPosX], ItemDrop[id][dropPosY], ItemDrop[id][dropPosZ]);
        	SetDynamicObjectRot(objectid, ItemDrop[id][dropPosRX], ItemDrop[id][dropPosRY], ItemDrop[id][dropPosRZ]);
	        return SendErrorMessage(playerid, "Object nay qua xa de chinh sua. "); //ошибка
	    }

	    if (objectid != ItemDrop[id][dropObject]) return SendErrorMessage(playerid, "Error editing item.");

		SetDynamicObjectPos(objectid, x, y, z);
		SetDynamicObjectRot(objectid, rx, ry, rz);

        GetDynamicObjectPos(objectid, ItemDrop[id][dropPosX], ItemDrop[id][dropPosY], ItemDrop[id][dropPosZ]);
        GetDynamicObjectRot(objectid, ItemDrop[id][dropPosRX], ItemDrop[id][dropPosRY], ItemDrop[id][dropPosRZ]);

		ItemDrop_Update(id);
	}
	return 1;
}