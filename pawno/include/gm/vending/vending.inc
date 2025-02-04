VM_OnGamemodeInit()
{
	mysql_tquery(dbHandle, "SELECT * FROM `vendingmachines`", "LoadVendingMachines");
	return 1;
}

VM_OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
    if (GetPVarInt(playerid, #edit_vm) != 0 && (response == EDIT_RESPONSE_FINAL || response == EDIT_RESPONSE_CANCEL))
	{
		new Float:oldX, Float:oldY, Float:oldZ, Float:oldRotX, Float:oldRotY, Float:oldRotZ, label[128];

		GetDynamicObjectPos(objectid, oldX, oldY, oldZ);
		GetDynamicObjectRot(objectid, oldRotX, oldRotY, oldRotZ);
		
	    new id = GetPVarInt(playerid, #edit_vm)-1;
		DeletePVar(playerid, #edit_vm);
	    
	    if (id < 0 || id >= MAX_VENDINGMACHINE || !VendingInfo[id][vendingID]) 	return SendErrorMessage(playerid, "Khong tim thay may ban hang tu dong.");
	    if (objectid != VendingInfo[id][vendingObject])							return SendErrorMessage(playerid, "Loi khi chinh sua May ban hang tu dong");

		SetDynamicObjectPos(objectid, x, y, z);
		SetDynamicObjectRot(objectid, rx, ry, rz);

        GetDynamicObjectPos(objectid, VendingInfo[id][vendingX], VendingInfo[id][vendingY], VendingInfo[id][vendingZ]);
       	VendingInfo[id][vendingRZ] = rz;

        format(label, sizeof(label), "May %i\nGia: %i", id, VendingInfo[id][vendingPrice]);
		if (IsValidDynamic3DTextLabel(VendingInfo[id][vendingLabel])) DestroyDynamic3DTextLabel(VendingInfo[id][vendingLabel]);
		VendingInfo[id][vendingLabel] =	CreateDynamic3DTextLabel(label, COLOR_GOLD, VendingInfo[id][vendingX], VendingInfo[id][vendingY], VendingInfo[id][vendingZ]+1.3, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, VendingInfo[id][vendingVW], VendingInfo[id][vendingInt], -1, 50.0);//15.0);
        
		Save_VM(id);
		SendAdmMessageToPlayer(playerid, "Vending Machine position [ID: %i] changed.", id);
	}
    return 1;
}