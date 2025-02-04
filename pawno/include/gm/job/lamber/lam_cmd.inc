// Player Commands
CMD:markbuyer(playerid, params[])
{
	new i, buyersid = random(MAX_BUYERS);
	while(i == 0)
	{
	    if (!BuyerData[buyersid][buyerID])
		{
			buyersid = random(MAX_BUYERS);
		}
		else
		{
		    i = 1;
			Waypoint_Set(playerid, BuyerData[buyersid][buyerX], BuyerData[buyersid][buyerY], BuyerData[buyersid][buyerZ]);
			SendSyntaxMessage(playerid, "Waypoint da duoc dat thanh nguoi mua nhat ky ngau nhien.");
		}
	}
	return 1;
}

CMD:chainsaw(playerid, params[])
{
	new id = GetNearBuyer(playerid);
    if (IsPlayerInAnyVehicle(playerid))
	{
		return SendErrorMessage(playerid, "Ban khong the su dung lenh nay tren xe.");
	} 
    if (id == - 1)
	{
		return SendErrorMessage(playerid, "Ban khong o gan Log Buyer.");
	} 
	if (GetCash(playerid) < CSAW_PRICE)
	{
		return SendNotCash(playerid);
	}	

	GiveInvItem(playerid, 9, 1);
    GiveCash(playerid, -CSAW_PRICE);
    
   	SendSyntaxMessage(playerid, "Mua may cua voi gia {2ECC71}$%d.", CSAW_PRICE);  
	SendSyntaxMessage(playerid, "Cua da duoc them vao tui do cua ban.");  
	return 1;
}

CMD:lumber(playerid, params[])
{
	new parametrs[248], arg[4];
	if (PlayerInfo[playerid][pJob] != JOB_LAMBERJACKER)	return SendErrorMessage(playerid, "Ban khong duoc lam viec trong Lumberjack.");
	if (sscanf(params, "s[8]S()[4]", parametrs, arg))
	{
		SendHelpMessage(playerid, "/lumber [load | take | car | tree | sell]");
		return 1;
	}
	if (IsPlayerInAnyVehicle(playerid)) return SendErrorMessage(playerid, "Ban khong the su dung lenh nay tren xe.");
	
    if(CompareStrings(parametrs, "load")) 
	{
        // loading to a bobcat
        if (!CarryingLog[playerid]) return SendErrorMessage(playerid, "Ban khong mang theo mot khuc go.");
		new id = GetNearestVehicle(playerid);
		if (GetVehicleModel(id) != 422) return SendErrorMessage(playerid, "Ban khong o gan Bobcat.");
		new Float: x, Float: y, Float: z;
    	GetVehicleBoot(id, x, y, z);
    	if (!IsPlayerInRangeOfPoint(playerid, 3.0, x, y, z)) return SendErrorMessage(playerid, "Ban khong o gan lung cua Bobcat.");
    	if (Vehicle_LogCount(id) >= LOG_LIMIT) return SendErrorMessage(playerid, "Ban khong the tai them bat ky khuc go nao vao phuong tien nay.");
    	for(new i; i < LOG_LIMIT; i++)
    	{
    	    if (!IsValidDynamicObject(LogObjects[id][i]))
    	    {
    	        LogObjects[id][i] = CreateDynamicObject(19793, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
    			AttachDynamicObjectToVehicle(LogObjects[id][i], id, LogAttachOffsets[i][0], LogAttachOffsets[i][1], LogAttachOffsets[i][2], 0.0, 0.0, LogAttachOffsets[i][3]);
    			break;
    	    }
    	}
    	
    	Streamer_Update(playerid);
    	Player_RemoveLog(playerid);
		SendSyntaxMessage(playerid, "Loaded a log.");
    }
	if(CompareStrings(parametrs, "take")) 
	{
		if (IsPlayerAttachedObjectSlotUsed(playerid, ATTACH_HANDS) || IsPlayerHoldingWeapon(playerid)) return SendWarningMessage(playerid, "Tay ban dang cam mot vat pham ( Bam N ( inventory ) sau do cat vat pham ).");
        // taking from ground
        if (CarryingLog[playerid]) return SendErrorMessage(playerid, "Ban da mang theo mot khuc go.");
		new id = GetClosestLog(playerid);
		if (id == -1) return SendErrorMessage(playerid, "Ban khong o gan mot khuc go.");
		LogData[id][logSeconds] = 1;
		RemoveLog(id);
		
		Player_GiveLog(playerid);
		SendSyntaxMessage(playerid, "Ban da lay mot khuc go duoi mat dat.");
		// done
    }
	if(CompareStrings(parametrs, "car"))
	{
		new id = GetNearestVehicle(playerid), Float: x, Float: y, Float: z;
        // taking from a bobcat
        if (CarryingLog[playerid])
		{
			return SendErrorMessage(playerid, "Ban da mang theo mot khuc go.");
		} 
		if (GetVehicleModel(id) != 422)
		{
			return SendErrorMessage(playerid, "Ban khong dung gan Bobcat.");
		} 
    	GetVehicleBoot(id, x, y, z);
    	if (!IsPlayerInRangeOfPoint(playerid, 3.0, x, y, z))
		{
			return SendErrorMessage(playerid, "Ban khong o gan lung cua Bobcat.");
		} 
    	if (Vehicle_LogCount(id) < 1)
		{
			return SendErrorMessage(playerid, "Bobcat nay khong co bat ky khuc go nao.");
		} 
    	for(new i = (LOG_LIMIT - 1); i >= 0; i--)
    	{
    	    if (IsValidDynamicObject(LogObjects[id][i]))
    	    {
    	        DestroyDynamicObject(LogObjects[id][i]);
    	        LogObjects[id][i] = -1;
    			break;
    	    }
    	}

    	Streamer_Update(playerid);
    	Player_GiveLog(playerid);
		SendSyntaxMessage(playerid, "Ban da lay khuc go tu Bobcat.");
    }
	if(CompareStrings(parametrs, "tree")) 
	{
		
		new id = GetNearTree(playerid);
		if (IsPlayerAttachedObjectSlotUsed(playerid, ATTACH_HANDS) || IsPlayerHoldingWeapon(playerid)) return SendWarningMessage(playerid, "Tay ban dang cam mot vat pham ( Bam N ( inventory ) sau do cat vat pham ).");
		if (CarryingLog[playerid])
		{
			return SendErrorMessage(playerid, "Ban da mang theo mot khuc go.");
		} 
        if (id == -1)
		{
			return SendErrorMessage(playerid, "Ban khong dung gan tree.");
		} 
        if (TreeData[id][treeSeconds] < 1)
		{
			return SendErrorMessage(playerid, "Cay nay khong the cua.");
		} 
        if (TreeData[id][treeLogs] < 1)
		{
			return SendErrorMessage(playerid, "Cay nay chua co khuc go nao.");
		} 

        TreeData[id][treeLogs]--;
        Tree_UpdateLogLabel(id);
        
        Player_GiveLog(playerid);
        SendSyntaxMessage(playerid, "Ban dang cua khuc go tu than cay.");
    }
	if(CompareStrings(parametrs, "sell")) 
	{
		new id = GetNearBuyer(playerid);
		new RLOG_PRICE = random(50);
        if (!CarryingLog[playerid])
		{
			return SendErrorMessage(playerid, "Ban khong mang theo mot nhat ky.");
		} 
		if(id == -1)
		{
			return SendErrorMessage(playerid, "Ban khong o gan Log Buyer.");
		}
		Player_RemoveLog(playerid);
		GiveCash(playerid, RLOG_PRICE);
		SendSyntaxMessage(playerid, "Ban da ban khuc go voi gia {2ECC71}$%d.", RLOG_PRICE);

    }
	return 1;
}

// Admin Commands - Trees

CMD:alumber(playerid, params[])
{
	new option[16], secoption[128];

	if (!CheckAdmin(playerid, ADMIN_LEVEL_3))	return SendNotAdmin(playerid);
	
	if (sscanf(params, "s[16]S()[128]", option, secoption))
	{
		SendHelpMessage(playerid, "/alumber [create / remove / edit / goto]");
		return 1;
	}
	if (CompareStrings(option, "create"))
	{
		new id = -1, Float: x, Float: y, Float: z, Float: a;
		if ((id = GetNextTreeID()) == -1)	return SendErrorMessage(playerid, "The maximum number of trees has been reached.");
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, a);
		x += (3.0 * floatsin(-a, degrees));
		y += (3.0 * floatcos(-a, degrees));
		z -= 1.0;
		TreeData[id][treeX] = x;
		TreeData[id][treeY] = y;
		TreeData[id][treeZ] = z;
		TreeData[id][treeRX] = TreeData[id][treeRY] = TreeData[id][treeRZ] = 0.0;
		
		TreeData[id][treeObjID] = CreateDynamicObject(657, TreeData[id][treeX], TreeData[id][treeY], TreeData[id][treeZ], TreeData[id][treeRX], TreeData[id][treeRY], TreeData[id][treeRZ]);

		new label[96];
		format(label, sizeof(label), "Tree (%d)\n\n{FFFFFF}Press {F1C40F}Left Click {FFFFFF}to cut down.", id);
		TreeData[id][treeLabel] = CreateDynamic3DTextLabel(label, 0x2ECC71FF, TreeData[id][treeX], TreeData[id][treeY], TreeData[id][treeZ] + 1.5, 5.0);
		
		EditingTreeID[playerid] = id;
    	EditDynamicObject(playerid, TreeData[id][treeObjID]);
		
		new query[156];
		mysql_format(dbHandle, query, sizeof(query), "INSERT INTO `trees` (`PosX`,`PosY`,`PosZ`,`RotX`,`RotY`,`RotZ`) VALUES (%f,%f,%f,%f,%f,%f)", TreeData[id][treeX], TreeData[id][treeY], TreeData[id][treeZ], TreeData[id][treeRX], TreeData[id][treeRY], TreeData[id][treeRZ]);
		mysql_tquery(dbHandle, query, "OnInsertTrees", "i", id);

		SendSyntaxMessage(playerid, "You created a lumberjack tree [ID: %i]", id);
	}
	if (CompareStrings(option, "edit"))
	{
		new id;
		if ((id = GetNearTree(playerid)) == -1)					return SendErrorMessage(playerid, "There is no tree next to you.");
		if (TreeData[id][treeGettingCut]) 						return SendErrorMessage(playerid, "Can't edit the specified tree because its being cut down.");
		if (EditingTreeID[playerid] != -1) 						return SendErrorMessage(playerid, "You're already editing a tree.");
		
		EditingTreeID[playerid] = id;
		EditDynamicObject(playerid, TreeData[id][treeObjID]);
	}
	if (CompareStrings(option, "remove"))
	{
		new id;
		if ((id = GetNearTree(playerid)) == -1)					return SendErrorMessage(playerid, "There is no tree next to you.");
		if (TreeData[id][treeGettingCut]) 						return SendErrorMessage(playerid, "Can't remove specified tree because its getting cut down.");
		if (Tree_BeingEdited(id)) 								return SendErrorMessage(playerid, "Can't remove specified tree because its being edited.");

		DestroyDynamicObject(TreeData[id][treeObjID]);
		DestroyDynamic3DTextLabel(TreeData[id][treeLabel]);
		if (TreeData[id][treeTimer] != -1) KillTimer(TreeData[id][treeTimer]);
		
		TreeData[id][treeLogs] = TreeData[id][treeSeconds] = 0;
		TreeData[id][treeObjID] = TreeData[id][treeTimer] = -1;
		TreeData[id][treeLabel] = Text3D: -1;

		new query[128];
		mysql_format(dbHandle, query, sizeof(query), "DELETE FROM `trees` WHERE `id` = %i", id);
		mysql_tquery(dbHandle, query);

		SendSyntaxMessage(playerid, "You have removed a lumberjack tree [ID: %i]", id);
	}
	if (CompareStrings(option, "goto"))
	{
		new id;

		if (sscanf(secoption, "i", id))										return SendHelpMessage(playerid, "/alumber goto [Tree ID]");
		if (!TreeData[id][treeID]) 											return SendErrorMessage(playerid, "Tree not found.");

		SetPlayerPosEx(playerid, TreeData[id][treeX], TreeData[id][treeY], TreeData[id][treeZ]);

		SendSpecialMessage(playerid, "Teleported to a Tree [ID: %i].", id);
	}
	return 1;
}

CMD:alumberbuyer(playerid, params[])
{
	new option[16], secoption[128];

	if (!CheckAdmin(playerid, ADMIN_LEVEL_3))	return SendNotAdmin(playerid);
	if (sscanf(params, "s[16]S()[128]", option, secoption))
	{
		SendHelpMessage(playerid, "/alumberbuyer [create / remove / edit / goto]");
		return 1;
	}
	if (CompareStrings(option, "create"))
	{
		new skin, id = -1, Float:x, Float:z, Float:y, Float:a, query[156], label[250];
		if (sscanf(secoption, "i", skin))										return SendHelpMessage(playerid, "/alumberbuyer create [Skin ID]");
		if (!(0 <= skin <= 311))												return SendErrorMessage(playerid, "Invalid skin ID.");
		if ((id = GetNextBuyerID()) == -1)										return SendErrorMessage(playerid, "The maximum number of buyer has been reached.");

		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, a);
		BuyerData[id][buyerX] = x;
		BuyerData[id][buyerY] = y;
		BuyerData[id][buyerZ] = z;
		BuyerData[id][buyerA] = a;

		BuyerData[id][buyerActorID] = CreateActor(skin, BuyerData[id][buyerX], BuyerData[id][buyerY], BuyerData[id][buyerZ], BuyerData[id][buyerA]);
		SetActorInvulnerable(BuyerData[id][buyerActorID], 1);

		format(label, sizeof(label), "Log Buyer (%d)\n\n{FFFFFF}Use {F1C40F}/chainsaw {FFFFFF}to buy a chainsaw for {2ECC71}$%d.\n{FFFFFF}Use {F1C40F}/lumber sell {FFFFFF}to sell a log for as much as {2ECC71}$%d.", id, CSAW_PRICE, LOG_PRICE);
		BuyerData[id][buyerLabel] = CreateDynamic3DTextLabel(label, 0xF1C40FFF, BuyerData[id][buyerX], BuyerData[id][buyerY], BuyerData[id][buyerZ] + 0.25, 5.0, .testlos = 1);

		mysql_format(dbHandle, query, sizeof(query), "INSERT INTO `buyers` (`Skin`,`PosX`,`PosY`,`PosZ`,`PosA`) VALUES (%i,%f,%f,%f,%f)", skin, BuyerData[id][buyerX], BuyerData[id][buyerY], BuyerData[id][buyerZ], BuyerData[id][buyerA]);
		mysql_tquery(dbHandle, query, "OnInsertBuyers", "i", id);

		SetPlayerPos(playerid, BuyerData[id][buyerX] + (1.5 * floatsin(-BuyerData[id][buyerA], degrees)), BuyerData[id][buyerY] + (1.5 * floatcos(-BuyerData[id][buyerA], degrees)), BuyerData[id][buyerZ]);

		SendSyntaxMessage(playerid, "You created a Logs Buyer [ID: %i]", id);
	}
	if (CompareStrings(option, "remove"))
	{
		new id, query[128];
		if ((id = GetNearBuyer(playerid)) == -1)					return SendErrorMessage(playerid, "There is no buyer next to you.");

		DestroyActor(BuyerData[id][buyerActorID]);
		DestroyDynamic3DTextLabel(BuyerData[id][buyerLabel]);
		
		BuyerData[id][buyerActorID] = -1;
		BuyerData[id][buyerLabel] = Text3D: -1;
		
		mysql_format(dbHandle, query, sizeof(query), "DELETE FROM `buyers` WHERE `ID` = %i", id);
		mysql_tquery(dbHandle, query);

		SendSyntaxMessage(playerid, "You have removed a lumber buyer [ID: %i]", id);
	}
	if (CompareStrings(option, "edit"))
	{
		new id, parameters[16], arg[64];
		if (sscanf(secoption, "is[16]S()[64]", id, parameters, arg))
		{
			SendHelpMessage(playerid, "/alumberbuyer edit [buyer id] [options] [value]");
			SendSyntaxMessage(playerid, "skin / position");
			return 1;
		}
		if (id < 0 || id >= MAX_BUYERS || !BuyerData[id][buyerID]) return SendErrorMessage(playerid, "Buyer not found.");
		if (CompareStrings(parameters, "skin"))
		{
			new skinid, query[128];
			if (sscanf(arg, "i", skinid)) 		return SendHelpMessage(playerid, "/alumberbuyer edit [buyer id] skin [skin id]");
			if (!(0 <= skinid <= 311))			return SendErrorMessage(playerid, "Invalid skin ID.");

			BuyerData[id][buyerSkin] = skinid;
	
			DestroyActor(BuyerData[id][buyerActorID]);
			BuyerData[id][buyerActorID] = CreateActor(skinid, BuyerData[id][buyerX], BuyerData[id][buyerY], BuyerData[id][buyerZ], BuyerData[id][buyerA]);
			SetActorInvulnerable(BuyerData[id][buyerActorID], 1);

			mysql_format(dbHandle, query, sizeof(query), "UPDATE `buyers` SET `Skin`=%i WHERE `id` = %i", skinid, BuyerData[id][buyerX], BuyerData[id][buyerY], BuyerData[id][buyerZ], BuyerData[id][buyerA], id);
			mysql_tquery(dbHandle, query);

			SendSyntaxMessage(playerid, "You have edited a lumber buyer skin to %i, [ID: %i]",skinid, id);
		}
		if (CompareStrings(parameters, "position"))
		{
			new query[128];
			GetPlayerPos(playerid, BuyerData[id][buyerX], BuyerData[id][buyerY], BuyerData[id][buyerZ]);
			GetPlayerFacingAngle(playerid, BuyerData[id][buyerA]);

			DestroyActor(BuyerData[id][buyerActorID]);
			BuyerData[id][buyerActorID] = CreateActor(BuyerData[id][buyerSkin], BuyerData[id][buyerX], BuyerData[id][buyerY], BuyerData[id][buyerZ], BuyerData[id][buyerA]);
			SetActorInvulnerable(BuyerData[id][buyerActorID], 1);

			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, BuyerData[id][buyerLabel], E_STREAMER_X, BuyerData[id][buyerX]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, BuyerData[id][buyerLabel], E_STREAMER_Y, BuyerData[id][buyerY]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, BuyerData[id][buyerLabel], E_STREAMER_Z, BuyerData[id][buyerZ] + 0.25);

			SetPlayerPos(playerid, BuyerData[id][buyerX] + (1.5 * floatsin(-BuyerData[id][buyerA], degrees)), BuyerData[id][buyerY] + (1.5 * floatcos(-BuyerData[id][buyerA], degrees)), BuyerData[id][buyerZ]);

			mysql_format(dbHandle, query, sizeof(query), "UPDATE `buyers` SET `PosX`=%f,`PosY`=%f, `PosZ`=%f, `PosA`=%f WHERE `id` = %i", BuyerData[id][buyerX], BuyerData[id][buyerY], BuyerData[id][buyerZ], BuyerData[id][buyerA], id);
			mysql_tquery(dbHandle, query);

			SendSyntaxMessage(playerid, "You have edited the position of a lumber buyer [ID: %i]", id);
		}
	}
	return 1;
}