CMD:avm(playerid, params[])
{
	if (!CheckAdmin(playerid, HIGH_ADMIN_LEVEL))	return SendNotAdmin(playerid);

	new option[16], secoption[128];

	if (sscanf(params, "s[16]S()[128]", option, secoption))
	{
		SendHelpMessage(playerid, "/avm [options]");
		SendSyntaxMessage(playerid, "create / remove / goto / sell");
		return 1;
	}

	if (CompareStrings(option, "create"))
	{
        new vendingid = -1, type, price;
		if (sscanf(secoption, "ii", type, price))    						return SendHelpMessage(playerid, "/avm create [1 - Food Stand | 2 - Sprunk] [Price]");
		if (type < 1 || type > 2)		    								return SendErrorMessage(playerid, "You can only choose between 1 to 2 types.");
        if ((vendingid = GetNextVendingMachineID()) == -1)				 	return SendErrorMessage(playerid, "The maximum number of vending machines has been reached.");
		
		GetPlayerPos(playerid, VendingInfo[vendingid][vendingX], VendingInfo[vendingid][vendingY], VendingInfo[vendingid][vendingZ]);
		
		VendingInfo[vendingid][vendingPrice] = price;
		VendingInfo[vendingid][vendingVault] = 0;
		VendingInfo[vendingid][vendingType] = (type == 1) ? (TYPE_FOOD) : (TYPE_SPRUNK);
		VendingInfo[vendingid][vendingRX] = 0.0;
		VendingInfo[vendingid][vendingRY] = 0.0;
		VendingInfo[vendingid][vendingRZ] = 0.0;
		VendingInfo[vendingid][vendingVW] = GetWorld(playerid);
		VendingInfo[vendingid][vendingInt] = GetInterior(playerid);

		new vendingModel = (VendingInfo[vendingid][vendingType] == TYPE_FOOD) ? 1776 : 1775;
		VendingInfo[vendingid][vendingObject] = CreateDynamicObject(vendingModel, VendingInfo[vendingid][vendingX], VendingInfo[vendingid][vendingY], VendingInfo[vendingid][vendingZ], 0.0, 0.0, 0.0, VendingInfo[vendingid][vendingVW], VendingInfo[vendingid][vendingInt], -1, 200.0);

		new label[100];
        format(label, sizeof(label), "Vending %i\nPrice: %i", vendingid, VendingInfo[vendingid][vendingPrice]);
		VendingInfo[vendingid][vendingLabel] = CreateDynamic3DTextLabel(label, COLOR_GOLD, VendingInfo[vendingid][vendingX], VendingInfo[vendingid][vendingY], VendingInfo[vendingid][vendingZ]+1.3, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, VendingInfo[vendingid][vendingVW], VendingInfo[vendingid][vendingInt], -1, 50.0);

		SetPVarInt(playerid, #edit_vm, vendingid + 1);
		EditDynamicObject(playerid, VendingInfo[vendingid][vendingObject]);

		AddVendingInfoToFile(vendingid, VendingInfo[vendingid][vendingType], VendingInfo[vendingid][vendingX], VendingInfo[vendingid][vendingY], VendingInfo[vendingid][vendingZ], VendingInfo[vendingid][vendingVW], VendingInfo[vendingid][vendingInt], VendingInfo[vendingid][vendingPrice]);
		SendAdmMessageToPlayer(playerid, "You created a vending machine [ID: %i].", vendingid);
		return 1;
	}

	else if (CompareStrings(option, "remove"))
	{
		new vendingid;

		if (sscanf(secoption, "i", vendingid))											return SendHelpMessage(playerid, "/avm [Vendor ID]");
		if (!VendingInfo[vendingid][vendingID]) 										return SendErrorMessage(playerid, "Vending Machine not found.");

		new ownerid = GetIDByID(VendingInfo[vendingid][vendingOwnerID]), query[128];

		if (IsPlayerLogged(ownerid))
		{
			SendSyntaxMessage(ownerid, "Administrator %s deleted your Vending Machine.", GetAccName(playerid));
			if (VendingInfo[vendingid][vendingVault] > 0)
			{
				SendSyntaxMessage(ownerid, "%i added in your bank account. This is the money that the vending machine vault have.", VendingInfo[vendingid][vendingVault]);
				GiveCash(ownerid, VendingInfo[vendingid][vendingVault]);
			} 
		}

		if (IsValidDynamicObject(VendingInfo[vendingid][vendingObject]))
		{
			DestroyDynamicObject(VendingInfo[vendingid][vendingObject]);
			VendingInfo[vendingid][vendingObject] = INVALID_OBJECT_ID;
		}
        
        if (IsValidDynamic3DTextLabel(VendingInfo[vendingid][vendingLabel]))
		{
			DestroyDynamic3DTextLabel(VendingInfo[vendingid][vendingLabel]);
			VendingInfo[vendingid][vendingLabel] = Text3D:INVALID_3DTEXT_ID;
		}

		mysql_format(dbHandle, query, sizeof(query), "DELETE FROM `vendingmachine` WHERE `id` = %i", VendingInfo[vendingid][vendingID]);
		mysql_tquery(dbHandle, query);

		VendingInfo[vendingid][vendingID] = 0;
		SendAdmMessageToPlayer(playerid, "Vending Machine [ID: %i] deleted.", vendingid);
		return 1;
	}

	else if (CompareStrings(option, "goto"))
	{
		new vendingid; 

		if (sscanf(secoption, "i", vendingid))											return SendHelpMessage(playerid, "/avm goto [vendingid]");
		if (vendingid < 0 || vendingid > MAX_VENDINGMACHINE - 1 || !VendingInfo[vendingid][vendingID])	return SendErrorMessage(playerid, "Vending Machine not found.");

		SetPlayerPosEx(playerid, VendingInfo[vendingid][vendingX], VendingInfo[vendingid][vendingY], VendingInfo[vendingid][vendingZ]);
		SetInterior(playerid, VendingInfo[vendingid][vendingInt]);
		SetWorld(playerid, VendingInfo[vendingid][vendingVW]);
		SendSpecialMessage(playerid, "You teleported to Vending Machine [ID: %i].", vendingid);
	}

	else if (CompareStrings(option, "sell"))
	{
		new vendingid; 

		if (sscanf(secoption, "i", vendingid))															return SendHelpMessage(playerid, "/avm goto [vendingid]");
		if (vendingid < 0 || vendingid > MAX_VENDINGMACHINE - 1 || !VendingInfo[vendingid][vendingID])	return SendErrorMessage(playerid, "Vending Machine not found.");

		new ownerid = GetIDByID(VendingInfo[vendingid][vendingOwnerID]);

		if (IsPlayerLogged(ownerid))
		{
			SendSyntaxMessage(ownerid, "Administrator %s sold your Vending Machine.", GetAccName(playerid));
			if (VendingInfo[vendingid][vendingVault] > 0)
			{
				SendSyntaxMessage(ownerid, "%i added in your bank account. This is the money that the vending machine vault have.", VendingInfo[vendingid][vendingVault]);
				GiveCash(ownerid, VendingInfo[vendingid][vendingVault]);
			} 
		}
		
		VendingInfo[vendingid][vendingOwnerID] = 
		VendingInfo[vendingid][vendingVault] =
		VendingInfo[vendingid][vendingAlarm] =
		VendingInfo[vendingid][vendingLock] = 0;
		strmid(VendingInfo[vendingid][vendingOwner], "The State", 0, strlen("The State"), MAX_PLAYER_NAME);
		SendSpecialMessage(playerid, "You have sold the Vending Machine [ID: %i].", vendingid);
		Save_VM(vendingid);
	}
	else if (CompareStrings(option, "edit"))
	{
		new id, parameters[16], arg[64];
		
		if (sscanf(secoption, "is[16]S()[64]", id, parameters, arg))
		{
			SendHelpMessage(playerid, "/avm edit [ID] [options] [value]");
			SendSyntaxMessage(playerid, "pos / price");
			return 1;
		}
		
		if (id < 0 || id > MAX_VENDINGMACHINE || !VendingInfo[id][vendingID])		return SendErrorMessage(playerid, "Vending Machine not found.");

		if (CompareStrings(parameters, "pos"))
		{
			if (Vending_Nearest(playerid) != id)						    			return SendErrorMessage(playerid, "You should be near the trash can.");

			SetPVarInt(playerid, #edit_vm, id + 1);
			EditDynamicObject(playerid, VendingInfo[id][vendingObject]);
			return 1;
		}
		if (CompareStrings(parameters, "price"))
		{
			new price;
			if (sscanf(arg, "i", price))													return SendHelpMessage(playerid, "/avm edit [ID] price [money]");
			if (Vending_Nearest(playerid) != id)						    			return SendErrorMessage(playerid, "You should be near the vending machine.");
			VendingInfo[id][vendingPrice] = price;
			if (IsValidDynamic3DTextLabel(VendingInfo[id][vendingLabel]))
			{
				DestroyDynamic3DTextLabel(VendingInfo[id][vendingLabel]);
				new label[100];
				format(label, sizeof(label), "Vending %i\nPrice: %i", id, VendingInfo[id][vendingPrice]);
				VendingInfo[id][vendingLabel] = CreateDynamic3DTextLabel(label, COLOR_GOLD, VendingInfo[id][vendingX], VendingInfo[id][vendingY], VendingInfo[id][vendingZ]+1.3, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, VendingInfo[id][vendingVW], VendingInfo[id][vendingInt], -1, 50.0);
			}
			SQL_SetInteger("vendingmachines", "price", VendingInfo[id][vendingPrice], VendingInfo[id][vendingID]);
			SendSyntaxMessage(playerid, "You have edited the price of Vending Machine ID: %i for %i", id, VendingInfo[id][vendingPrice]);
			return 1;
		}
	}
	return 1;
}

ALTX:vendingmenu("/vm");
CMD:vendingmenu(playerid, params[])
{
	new option[16], secoption[128];

	if (sscanf(params, "s[16]S()[128]", option, secoption))
	{
		SendHelpMessage(playerid, "/vm [options]");
		SendSyntaxMessage(playerid, "buy | sell | upgrade | repair | withdraw | deposit");	
		return 1;
	}

	if (CompareStrings(option, "buy"))
	{
		new id;

		if ((id = Vending_Nearest(playerid)) == -1)							return SendErrorMessage(playerid, "Ban khong o gan bat ky may ban hang tu dong nao.");
		if (VendingInfo[id][vendingOwnerID])								return SendErrorMessage(playerid, "May ban hang tu dong nay da duoc mua boi nhung nguoi choi khac");
		if (GetCash(playerid) < VendingInfo[id][vendingPrice])				return SendNotCash(playerid);

		VendingInfo[id][vendingOwnerID] = PlayerInfo[playerid][pID];
		VendingInfo[id][vendingVault] = 0;

		format(VendingInfo[id][vendingOwner], MAX_PLAYER_NAME, GetNameEx(playerid));

		new money = PlayerInfo[playerid][pCash];

		GiveCash(playerid, -VendingInfo[id][vendingPrice]);
		SendSyntaxMessage(playerid, "Ban da mua mot may ban hang tu dong [ID: %i] voi gia $%i.", id, VendingInfo[id][vendingPrice]);

		SendHelpMessage(playerid, "Su dung /vendingmenu de giup ban quan ly may cua minh.");

		if (IsValidDynamic3DTextLabel(VendingInfo[id][vendingLabel]))
		{
			DestroyDynamic3DTextLabel(VendingInfo[id][vendingLabel]);
			new label[100];
			format(label, sizeof(label), "May %i");
			VendingInfo[id][vendingLabel] = CreateDynamic3DTextLabel(label, COLOR_GOLD, VendingInfo[id][vendingX], VendingInfo[id][vendingY], VendingInfo[id][vendingZ]+1.3, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, VendingInfo[id][vendingVW], VendingInfo[id][vendingInt], -1, 50.0);
		}

		Save_VM(id);

		new mes[256];
		format(mes, sizeof(mes), "%s [MYSQL: %i | IP: %s | Money(WAS): %i | Money(BECOME): %i] bought a vending machine [VM_MYSQL: %i] for -- $%i", GetName(playerid), PlayerInfo[playerid][pID], q_GetPlayerIP(playerid), money, GetCash(playerid), 
		VendingInfo[id][vendingID], VendingInfo[id][vendingPrice]);
    	insert_log(mes, PROPERTY_LOG, 3, PlayerInfo[playerid][pAccID]);
		return 1;
	}
	else if (CompareStrings(option, "upgrade"))
	{
		new id;

		if ((id = Vending_Nearest(playerid)) == -1)					return SendErrorMessage(playerid, "Ban phai o gan may ban hang tu dong cua minh.");
		if (VendingInfo[id][vendingOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "May ban hang tu dong nay khong thuoc ve ban.");

		new parameters[16], arg[112];

		if (sscanf(secoption, "s[16]S()[112]", parameters, arg))
		{
			SendHelpMessage(playerid, "/vendingmenu upgrade [options]");
			SendSyntaxMessage(playerid, "lock | alarm ");
			return 1;
		}

		else if (CompareStrings(parameters, "lock"))
		{
			new level;

			if (sscanf(arg, "i", level))
			{
				SendHelpMessage(playerid, "/vendingmenu upgrade lock [level (1-5)]");
				SendSyntaxMessage(playerid, "Moi cap do dat hon 250 do la so voi cap do truoc [1 cap do - $250 | 5 cap - $1250].");
				return 1;
			}
			if (level < 1 || level > 5)				return SendErrorMessage(playerid, "Ban chi co the chon giua cap do 1 den 5.");
			if (GetCash(playerid) < 250 * level)	return SendErrorMessage(playerid, "The price of a level %i lock is $%i.", level, level * 250);
			if (VendingInfo[id][vendingLock] >= level)	return SendErrorMessage(playerid, "You already have a lock %i level.", VendingInfo[id][vendingLock]);

			VendingInfo[id][vendingLock] = level;
			SQL_SetInteger("vendingmachines", "lock", VendingInfo[id][vendingLock], VendingInfo[id][vendingID]);
			GiveCash(playerid, -level * 250);
			SendSyntaxMessage(playerid, "You purchased a lock level %i for $%i.", VendingInfo[id][vendingLock], level * 250);
			return 1;
		}

		else if (CompareStrings(parameters, "alarm"))
		{
			if (GetCash(playerid) < 1500)				return SendErrorMessage(playerid, "You dont have enough money to install an alarm on this vending machine. [$1500]");
			if (VendingInfo[id][vendingAlarm])			return SendErrorMessage(playerid, "You have already installed an alarm.");

			VendingInfo[id][vendingAlarm] = 1;
			SQL_SetInteger("vendingmachines", "alarm", VendingInfo[id][vendingAlarm], VendingInfo[id][vendingID]);
			GiveCash(playerid, -1500);
			SendSyntaxMessage(playerid, "You installed alarm on this vending machine for $1,500");
			return 1;
		}
	}

	else if (CompareStrings(option, "withdraw"))
	{
		new id; 

		if ((id = Vending_Nearest(playerid)) == -1)							return SendErrorMessage(playerid, "You must be near to your own vending machine.");
		if (VendingInfo[id][vendingOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "This vending machine does not belong to you.");

		new amount;

		if (sscanf(secoption, "i", amount))
		{
			SendHelpMessage(playerid, "/vendingmenu withdraw [money]");
			SendSyntaxMessage(playerid, "Vault: $%i.", VendingInfo[id][vendingVault]);
			return 1;
		}
		if (amount > VendingInfo[id][vendingVault])	return SendErrorMessage(playerid, "There is not enough money in the safe.");

		VendingInfo[id][vendingVault] -= amount;
		SQL_SetInteger("vendingmachines", "vault", VendingInfo[id][vendingVault], VendingInfo[id][vendingID]);
		GiveCash(playerid, amount);
		SendSyntaxMessage(playerid, "You withrawed $%i from the safe. Balance: $%i.", amount, VendingInfo[id][vendingVault]);
		return 1;
	}

	else if (CompareStrings(option, "deposit"))
	{
		new id;
		if ((id = Vending_Nearest(playerid)) == -1)							return SendErrorMessage(playerid, "You must be near to your own vending machine.");
		if (VendingInfo[id][vendingOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "This vending machine does not belong to you.");

		new amount;

		if (sscanf(secoption, "i", amount))
		{
			SendHelpMessage(playerid, "/vendingmenu deposit [money]");
			SendSyntaxMessage(playerid, "Vault: $%i.", VendingInfo[id][vendingVault]);
			return 1;
		}
		if (amount > GetCash(playerid) || amount < 1)	return SendNotCash(playerid);

		GiveCash(playerid, -amount);
		VendingInfo[id][vendingVault] += amount;
		SQL_SetInteger("vendingmachines", "vault", VendingInfo[id][vendingVault], VendingInfo[id][vendingID]);
		SendSyntaxMessage(playerid, "You put $%i in the safe. Balance: $%i.", amount, VendingInfo[id][vendingVault]);
		return 1;
	}

	else if (CompareStrings(option, "sell"))
	{
		new userid, price;

		if (sscanf(secoption, "ui", userid, price))			return SendHelpMessage(playerid, "/house sell [ID/Part Of Name] [cost]");

		new id;

		if ((id = Vending_Nearest(playerid)) == -1)							return SendErrorMessage(playerid, "You must be near to your own vending machine.");
		if (VendingInfo[id][vendingOwnerID] != PlayerInfo[playerid][pID])	return SendErrorMessage(playerid, "This vending machine does not belong to you.");
		if (!IsPlayerLogged(userid))										return SendNotConnected(playerid);
		if (!PlayerNearPlayer(3.0, playerid, userid))						return SendNotNearPlayer(playerid);
		if (price < 0 || price > 100000000)									return SendErrorMessage(playerid, "Sales price from $0 to $100000000.");

		pTemp[userid][pVendingPrice] = price;
		pTemp[userid][pVendingPlayer] = playerid;
		pTemp[userid][pVendingVending] = id;
		SetPVarInt(userid, #accept_time, gettime() + 30);
		SendSyntaxMessage(playerid, "You suggested %s to buy your vending machine for $%i.", GetNameEx(userid), price);
		SendSyntaxMessage(userid, "%s wants to sell you a vending machine for $%i. Press Y to buy.", GetNameEx(playerid), price);
	}
	return 1;
}