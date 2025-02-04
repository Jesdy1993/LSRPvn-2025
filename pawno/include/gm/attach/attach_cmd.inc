CMD:attmenu(playerid, params[])
{
	new option[24], secoption, thirdoption, fourthoption;

	if (sscanf(params, "s[24]D(-1)D(-1)D(-1)", option, secoption, thirdoption, fourthoption))
	{
		SendHelpMessage(playerid, "/attmenu [tuy chon]");
		SendSyntaxMessage(playerid, "list / buy / sell / edit");
		return 1;
	}

    new vehicle = GetPlayerVehicleID(playerid);
    if (!vehicle || GetPlayerState(playerid) != PLAYER_STATE_PASSENGER)								return SendErrorMessage(playerid, "Ban can phai ngoi ghe sau cua ghe lai.");
    //if (VehicleInfo[vehicle][carOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "You are not the owner of this vehicle.");
			
	if (CompareStrings(option, "buy"))
	{
		Dialog_Show(playerid, VehicleATT, DIALOG_STYLE_LIST, "Danh sach phu tung xe", "Spoilers\nRear Bumper\nFront Bumper\nLeft Side Skirts\nRight Side Skirts", "Chon", "Dong");		
		return 1;
	}

	else if (CompareStrings(option, "sell"))
	{
		new slot;

		if (sscanf(params, "{s[7]}d", slot))							return SendHelpMessage(playerid, "/attmenu sell [ID vi tri]");
        if (VehicleInfo[vehicle][carAttach][slot] == INVALID_OBJECT_ID)	return SendErrorMessage(playerid, "Vi tri nay dang trong.");
            
        VehicleInfo[vehicle][carAttachObj][slot] = 0;
		VehicleInfo[vehicle][carAttachPosX][slot] = 0.0;
		VehicleInfo[vehicle][carAttachPosY][slot] = 0.0;
		VehicleInfo[vehicle][carAttachPosZ][slot] = 0.0;
		VehicleInfo[vehicle][carAttachRotX][slot] = 0.0;
		VehicleInfo[vehicle][carAttachRotY][slot] = 0.0;
		VehicleInfo[vehicle][carAttachRotZ][slot] = 0.0;
        DestroyDynamicObject(VehicleInfo[vehicle][carAttach][slot]);
		VehicleInfo[vehicle][carAttach][slot] = INVALID_OBJECT_ID;
        SendSyntaxMessage(playerid, "Ban da xoa bo vat pham thanh cong.");
		Save_CarAttach(vehicle, slot);
		return 1;
	}

	else if (CompareStrings(option, "edit"))
	{
		new slot;

		if (sscanf(params, "{s[7]}d", slot))							return SendHelpMessage(playerid, "/attmenu edit [ID vi tri]");
        if (VehicleInfo[vehicle][carAttach][slot] == INVALID_OBJECT_ID)	return SendErrorMessage(playerid, "Vi tri nay dang trong.");

		new Float:x, Float:y, Float:z;
		AntiCheatGetVehiclePos(vehicle, x, y, z);

		SetPVarInt(playerid, #veh_editor, vehicle);
		SetPVarInt(playerid, #veh_slot, slot);
		SetPVarInt(playerid, #veh_obj, VehicleInfo[vehicle][carAttachObj][slot]);
		SetPVarInt(playerid, "Vehicle:AttEdit", 1);
		
		DestroyDynamicObject(VehicleInfo[vehicle][carAttach][slot]);
		VehicleInfo[vehicle][carAttach][slot] = INVALID_OBJECT_ID;
		VehicleInfo[vehicle][carAttach][slot] = CreateDynamicObject(VehicleInfo[vehicle][carAttachObj][slot], x, y, z + 2.0, 0.0, 0.0, 0.0);
		EditDynamicObject(playerid, VehicleInfo[vehicle][carAttach][slot]);
		return 1;
	}

	else if (CompareStrings(option, "list"))
	{
		new message[1024] = "{FFFFFF}Vi tri\t{FFFFFF}Object ID";

		for(new i = 0; i < MAX_TRUNK_INVENTORY; i++)
		{
			if (VehicleInfo[vehicle][carAttach][i] == INVALID_OBJECT_ID)
			{
				format(message, sizeof(message), "%s\n%i\tKhong", message, i);
			}
			else
			{
				format(message, sizeof(message), "%s\n%i\t%d", message, i, VehicleInfo[vehicle][carAttachObj][i]);
			}
		}
		Dialog_Show(playerid, None, DIALOG_STYLE_TABLIST_HEADERS, "{FFFFFF}Danh sach vat pham", message, "Dong", "");
	}

	else
	{
		SendHelpMessage(playerid, "/attmenu [tuy chon]");
		SendSyntaxMessage(playerid, "list / buy / sell / edit");
	}
	return 1;
}

ALTX:clothing("/acc");
CMD:clothing(playerid, params[])
{
    if (GetPVarInt(playerid, #edit_attach) == 1 || GetPVarInt(playerid, #buy_attach) != 0)	return SendErrorMessage(playerid, "Finish shopping / editing clothes.");

	new count, string[750];

	for(new i; i < MAX_PLAYER_ATTACH; i++)
	{
	    if (AttachInfo[playerid][i][aID] == 0) continue;
	    
		format(string, sizeof(string), "%s\n{FFFFFF}%i: %s %s", string, i+1, AttachInfo[playerid][i][aName], (AttachInfo[playerid][i][aUsed]) ? ("{30A90F}[Dang su dung]") : ("{AFAFAF}[Khong su dung]"));
	    count++;
	}

	if (!count)	return SendErrorMessage(playerid, "Ban khong co thu gi.");

    Dialog_Show(playerid, Clothing, DIALOG_STYLE_LIST, "{FF8000}Lua chon vi tri", string, "Chon", "Dong");
	return 1;
}

CMD:coh(playerid, params[])
{
    if (GetPVarInt(playerid, #money_hand) && (
		IsPlayerAttachedObjectSlotUsed(playerid, ATTACH_HANDS) ||
		IsPlayerAttachedObjectSlotUsed(playerid, 8)
	))
    {
        SetPVarInt(playerid, #money_hand, 0);
		
 		RemovePlayerAttachedObject(playerid, ATTACH_HANDS);
		RemovePlayerAttachedObject(playerid, 8);
 		return 1;
    }

	if (GetCash(playerid) < 300)								return SendNotCash(playerid);
    if (IsPlayerAttachedObjectSlotUsed(playerid, ATTACH_HANDS))	return SendWarningMessage(playerid,"Tay cua ban dang thuc hien.");

	new type;
	if (sscanf(params, "d", type)) return SendHelpMessage(playerid, "/coh [1 - tay phai | 2 - tay trai]");

	if (type == 1)		SetPlayerAttachedObject(playerid, ATTACH_HANDS, 1212, 6, 0.062999, 0.004999, 0.013000, -106.300003, -3.699995, -84.700004, 0.766000, 1.000000, 0.773000);
	else if (type == 2)	SetPlayerAttachedObject(playerid, 8, 1212, 5, 0.083999, -0.005000, -0.015000, -106.300003, -3.699995, -84.700004, 0.766000, 1.000000, 0.829999);
	else 				return SendHelpMessage(playerid, "/coh [1 - tay phai | 2 - tay trai]"); //����� ����
	
    SetPVarInt(playerid, #money_hand, 1);
	return 1;
}