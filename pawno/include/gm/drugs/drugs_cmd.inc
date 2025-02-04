CMD:plant(playerid, params[])
{
	new option[16], secoption[6];
	
	if (sscanf(params, "s[16]S()[6]", option, secoption))
	{
		SendHelpMessage(playerid, "/plant [tuy chon]");
		SendSyntaxMessage(playerid, "add / take");
		return 1;
	}

	if (CompareStrings(option, "add"))
	{
		new drugname[16];

		if (sscanf(secoption, "s[6]", drugname))
		{
			SendHelpMessage(playerid, "/plant add [ganja/coca/seeds]");
			return 1;
		}

		new type;
		if (CompareStrings(drugname, "ganja"))
		{
			if (!IsPlayerHasItem(playerid, INV_SEED_GANJA)) return SendErrorMessage(playerid, "Ban khong co hat giong can sa.");
			type = 1;
		}
		else if (CompareStrings(drugname, "coca"))
		{
			if (!IsPlayerHasItem(playerid, INV_SEED_COCA)) return SendErrorMessage(playerid, "Ban khong co hat cocaine.");
			type = 2;
		}
		else if (CompareStrings(drugname, "poppy"))
		{
			if (!IsPlayerHasItem(playerid, INV_SEED_POPPY)) return SendErrorMessage(playerid, "Ban khong co hat thuoc phien.");
			type = 3;
		}
		else 
		{
			SendHelpMessage(playerid, "/plant add [ganja/coca/seeds]");
			return 1;
		}		
		
		if (Plant_Nearest(playerid, 2.0) != -1)	return SendErrorMessage(playerid, "Mot cai cay da duoc trong ben canh ban.");
		if (pTemp[playerid][pPlantTime] > 0)	return SendErrorMessage(playerid, "Ban da trong mot cai cay roi. ");
	
		pTemp[playerid][pPlantTime] = 15;

		switch(type)
		{
			case 1: format(drugname, sizeof(drugname), "marijuana");
			case 2: format(drugname, sizeof(drugname), "coke");
			case 3: format(drugname, sizeof(drugname), "trouble");
		}

		pTemp[playerid][pPlantType] = type;
		
		SendSyntaxMessage(playerid, "Ban da bat dau trong mot bui %s. Su dung {FF6347}/stop{FFFFFF}, neu ban muon hoan tac hanh dong nay.", drugname);
		
		FreezePlayer(playerid);
		OnPlayAnim(playerid, "BOMBER","BOM_Plant_Loop", 4.0, 1, 0, 0, 0, 0);
		return 1;
	}
	
	else if (CompareStrings(option, "take"))
	{
		new plant = -1;
		if ((plant = Plant_Nearest(playerid)) == -1)			return SendErrorMessage(playerid, "Khong co cay nao gan ban.");
		if (CropsInfo[plant][pGrowTime] > gettime())			return SendErrorMessage(playerid, "Cay chua phat trien.");

		new drugname[16],
			type,
			Float: gPlant;


		switch(CropsInfo[plant][pType])
		{
			case 1:
			{
				gPlant = float(randomEx(10, 30)) / 10.0;
				type = INV_GANJA;
				format(drugname, sizeof(drugname), "la can sa");
			}
			case 2:
			{
				gPlant = float(randomEx(70, 300)) / 10.0;
				type = INV_COCA;
				format(drugname, sizeof(drugname), "la coca");
			}
			case 3:
			{
				gPlant = float(randomEx(50, 90)) / 10.0;
				type = INV_POPPY;
				format(drugname, sizeof(drugname), "la thuoc phien");
			}
		}
		if (GiveFloatInvItem(playerid, type, gPlant) == -1) return SendErrorMessage(playerid, "Tui do da day.");

		DestroyCrop(plant);
		OnPlayAnim(playerid, "BOMBER", "BOM_Plant_Loop", 4.0, 0, 0, 0, 0, 0);

		SendNearbyMessage(Range_Normal, playerid, COLOR_PURPLE, "* %s thu thap tu cay.", GetNameWithMask(playerid));
		SendSyntaxMessage(playerid, "Ban da thu thap %.1fg %s.", gPlant, drugname);
	}
	else 
	{
		SendHelpMessage(playerid, "/plant [add / take]");
	}
	return 1;
}

CMD:mixdrug(playerid, params[])
{
	if (PlayerInfo[playerid][pInjured] != 0 || GetPVarInt(playerid, "Freeze") || pTemp[playerid][pTaserTime] || pTemp[playerid][pCuffed]) return SendErrorMessage(playerid, "Ban khong the su dung tinh nang nay ngay bay gio.");

	new b_type = GetNearBuilding(playerid);
	if (b_type == -1) return SendErrorMessage(playerid,"Ban phai o trong phong thi nghiem");

	new building = GetNearInBuilding(playerid, b_type);
	if (building == -1) return SendErrorMessage(playerid, "Ban phai o trong phong thi nghiem!");

	new f = GetClosestFurniture(playerid, 1.5, CENTRIFUGE_OBJECT, DRUG_LAB);
    if (f == -1) return SendErrorMessage(playerid, "Khong co may ly tam ben canh ban.");

	new i;
	switch(b_type) {
		case 0: i = HFurn[building][f][ChemIdx];
		case 1: i = BFurn[building][f][ChemIdx];
		case 2: i = GFurn[building][f][ChemIdx];
	}

	if (i == -1 && ShowMixingDialog(playerid, Part_Mixing)) return SendHelpMessage(playerid,"Chon 3 thuoc thu ma ban muon tao ra mot loai thuoc tu do. {FF6347} (chung khong nen duoc lap lai)");
	else if (Chemistry[i][IsWorking] == true) 				return SendErrorMessage(playerid, "May ly tam dang hoat dong");
	else if (Chemistry[i][IsWorking] == false && Chemistry[i][Amount] > 0.0)
	{
		if (GetPVarInt(playerid, "CarryingDrugCrate"))  return SendWarningMessage(playerid, "Ban dang thuc hien.");

		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
		SetPlayerAttachedObject(playerid, 9, 1575, 1, -0.039999, 0.414759, -0.042998, -31.400018, 92.117507, 112.900047);
		
		SetPlayerHoldingCrate(playerid,
			Chemistry[i][Type],
			Chemistry[i][Amount],
			Chemistry[i][Quality],
			Chemistry[i][Extra][0],
			Chemistry[i][Extra][1],
			Chemistry[i][Extra][2],
			Chemistry[i][Material]
		);
		
		SendHelpMessage(playerid, "Dua hon hop thuoc thu vao lo phan ung {ffc46a}/reactor{FFFFFF}. Roi xuong san -{ffc46a}/dropmix{FFFFFF}.");
		ClearFurnitureData(f, i);

		ApplyAnimation(playerid, "carry", "liftup", 1, 0, 1, 1, 0, 1000);
		//ApplyAnimation(playerid, "carry", "liftup", 1, 0, 1, 1, 0, 1000);
	}
	return 1;
}

CMD:drydrug(playerid, params[])
{
	if (PlayerInfo[playerid][pInjured] != 0 || GetPVarInt(playerid, "Freeze") || pTemp[playerid][pTaserTime] || pTemp[playerid][pCuffed]) return SendErrorMessage(playerid, "Ban khong the su dung tinh nang nay ngay bay gio.");

	new b_type = GetNearBuilding(playerid);
	if (b_type == -1) return SendErrorMessage(playerid, "Ban khong o trong phong thi nghiem!");

	new building = GetNearInBuilding(playerid, b_type);
	if (building == -1) return SendErrorMessage(playerid, "Ban phai o trong phong thi nghiem!");

	new f = GetClosestFurniture(playerid, 1.5, DRYER_OBJECT, DRUG_LAB);
    if (f == -1) return SendErrorMessage(playerid, "Khong co nha may say kho nao gan ban. ");

	new i;
	switch(b_type) {
		case 0: i = HFurn[building][f][ChemIdx];
		case 1: i = BFurn[building][f][ChemIdx];
		case 2: i = GFurn[building][f][ChemIdx];
	}

	if (i == -1) 
	{
		for(new g = 0; g < MAX_INV_SLOTS; g++) P_CHEMICAL[playerid][g][pSlot] = 0;

		new pickDialog[MAX_INV_SLOTS*64 + 64] = "Chon mot vat pham de lam kho:",
			count = 0;
		
		for(new g = 0; g < MAX_INV_SLOTS; g++)
		{
			if (Inventory[playerid][g][pInvItem] == 0)												continue;
			if (Inventory[playerid][g][pInvItem] != 116 && Inventory[playerid][g][pInvItem] != 115)	continue;

			format(gString, sizeof(gString), "\n%s (%.1fg)", 
				E_CHEMICAL[Inventory[playerid][g][pInvItem]-103][NAME], 
				Inventory[playerid][g][pInvQFloat]
			);
			strcat(pickDialog, gString);
			
			P_CHEMICAL[playerid][count][pSlot] = g;
			count++;
		}

		if (count <= 0)
		{
			Dialog_Show(playerid, None, DIALOG_STYLE_LIST, "Nha may say kho", "Ban khong co la cay thuoc phien hay cay coca..", ">>", ""); //LackOfMaterial
			return 0;
		}
		else Dialog_Show(playerid, ConfDryer, DIALOG_STYLE_TABLIST_HEADERS, "Nha may say kho", pickDialog, "Chon", "<<");
	} 
	else if (Chemistry[i][IsWorking] == true) return SendErrorMessage(playerid, "May say dang hoat dong!");
	else if (Chemistry[i][IsWorking] == false && Chemistry[i][Amount] > 0.0)
	{
		switch(Chemistry[i][Material])
		{
			case 12: if (GiveFloatInvItem(playerid, 117, Chemistry[i][Amount]) == -1) return SendErrorMessage(playerid, "Tui do da day.");
			case 13: if (GiveFloatInvItem(playerid, 118, Chemistry[i][Amount]) == -1) return SendErrorMessage(playerid, "Tui do da day.");
		}
		SM2(playerid, "Them vao tui do cua ban %s (%.1f).", E_CHEMICAL[Chemistry[i][Material]][NAME], Chemistry[i][Amount]);
		ClearFurnitureData(f, i);		
	}
	return 1;
}

CMD:reactor(playerid, params[])
{
	if (PlayerInfo[playerid][pInjured] != 0 || GetPVarInt(playerid, "Freeze") || pTemp[playerid][pTaserTime] || pTemp[playerid][pCuffed]) return SendErrorMessage(playerid, "Ban khong the su dung tinh nang nay ngay bay gio.");

	new b_type = GetNearBuilding(playerid);
	if (b_type == -1) return SendErrorMessage(playerid, "Ban phai o trong phong thi nghiem!");

	new building = GetNearInBuilding(playerid, b_type);
	if (building == -1) return SendErrorMessage(playerid, "Ban phai o trong phong thi nghiem!");

	new f = GetClosestFurniture(playerid, 1.5, REACTOR_OBJECT, DRUG_LAB);
    if (f == -1) return SendErrorMessage(playerid, "Khong co lo phan ung nao gan ban.");
	
	if (GetClosestFurniture(playerid, 2.5, PUMP_OBJECT, DRUG_LAB) == -1) return SendErrorMessage(playerid, "Mot tram bom phai duoc ket noi voi lo phan ung.");
	
	new i;
	switch(b_type) {
		case 0: i = HFurn[building][f][ChemIdx];
		case 1: i = BFurn[building][f][ChemIdx];
		case 2: i = GFurn[building][f][ChemIdx];
	}
	if (i == -1) {
		if (!GetPVarInt(playerid, "CarryingDrugCrate")) return SendErrorMessage(playerid, "Ban khong co hon hop thuoc thu trong tay.");
		else {
			if ((i = GetFreeChemistyIndex()) == -1)	return SendErrorMessage(playerid, "Vuot qua gioi han! Lien he voi quan tri vien ky thuat");

			SendHelpMessage(playerid, "De bat dau qua trinh tong hop thuoc, hay su dung {ffc46a}/reactor{FFFFFF}.");

			ReactDrug(i, GetPVarInt(playerid, "nativeCAS"), GetPVarFloat(playerid, "tdrug_Amount"), GetPVarFloat(playerid, "tdrug_Quality"),  GetPVarInt(playerid, "BreakingBad_1"),  GetPVarInt(playerid, "BreakingBad_2"),  GetPVarInt(playerid, "BreakingBad_3"), GetPVarInt(playerid, "tdrug_Type"), b_type, building, f);
			ResetDrugCrate(playerid);

			ApplyAnimation(playerid, "carry", "putdwn", 1, 0, 1, 1, 0, 1000);
			//ApplyAnimation(playerid, "carry", "putdwn", 1, 0, 1, 1, 0, 1000);
		}
	} else if (Chemistry[i][IsWorking] == true) {
		static str_size[] = "> GIA TRI HIEN TAI: %s%.0f 'C\n\n\
					{FFFFFF}Cac che do:\n\n\
					1.\t{8fbfd0} Lam amt{FFFFFF}\t( x < 0 ) \n\
					2.\t{FF6347} Suoi{FFFFFF}\t( x > 0 )\n\n\
					{FFFFFF}Dat nhiet do(x) tren cam bien:";
		new mes[sizeof(str_size) + 6];

		format(mes, sizeof(mes), str_size, (Chemistry[i][Temperature] > 0) ? ("+") : (""), Chemistry[i][Temperature]);
		Dialog_Show(playerid, ControlSelect, DIALOG_STYLE_INPUT, "cam bien nhiet do", mes, ">>>", "Huy bo");
	} else {
		if (Chemistry[i][Amount] == -1)	return SendErrorMessage(playerid, "Khong co gi trong lo phan ung."); 

		new title[32];
		format(title, sizeof(title), "%s", E_CHEMICAL[Chemistry[i][Material]][NAME]);
		format(gString, sizeof(gString), "{FFFFFF}Cau truc phan tu - %s\nOAS: {FFFF00}%.1f%%{FFFFFF}\n\n\tPhan tich: %.1f / g", E_CHEMICAL[Chemistry[i][Material]][CODE], Chemistry[i][Quality], Chemistry[i][Amount]);
				
		Dialog_Show(playerid, Purification, DIALOG_STYLE_MSGBOX, title, gString, ">>", "Huy bo");
	}
	return 1;
}

CMD:pickupmix(playerid, params[])
{
	if (PlayerInfo[playerid][pInjured] != 0 || GetPVarInt(playerid, "Freeze") || pTemp[playerid][pTaserTime] || pTemp[playerid][pCuffed]) return SendErrorMessage(playerid, "Ban khong the su dung tinh nang nay ngay bay gio.");

	new dropid = MixDrop_Nearest(playerid);
	if (dropid == -1) 								return SendErrorMessage(playerid, "Khong co mot hon hop thuoc thu nao gan ban.");
	if (GetPVarInt(playerid, #pDelay))				return 1;
	if (GetPVarInt(playerid, "CarryingDrugCrate"))  	return SendWarningMessage(playerid, "Ban dang thuc hien.");

	SetPlayerChatBubble(playerid, "* tang hon hop thuoc thuoc thu *", COLOR_PURPLE, Range_Normal, 10000);

	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
	SetPlayerAttachedObject(playerid, 9, 1575, 1, -0.039999, 0.414759, -0.042998, -31.400018, 92.117507, 112.900047);

	SetPlayerHoldingCrate(playerid,
		DropChemistry[dropid][Type],
		DropChemistry[dropid][Amount],
		DropChemistry[dropid][Quality],
		DropChemistry[dropid][Extra][0],
		DropChemistry[dropid][Extra][1],
		DropChemistry[dropid][Extra][2],
		DropChemistry[dropid][Material]
	);
		
	DropChemistry_Delete(dropid);
	
	ApplyAnimation(playerid, "carry", "liftup", 1, 0, 1, 1, 0, 1000);
	//ApplyAnimation(playerid, "carry", "liftup", 1, 0, 1, 1, 0, 1000);
	return 1;
}

CMD:dropmix(playerid, params[])
{
	if (GetPVarInt(playerid, "CarryingDrugCrate") == 0) return SendErrorMessage(playerid, "Ban khong co thuoc thu hon hop nao trong tay!"); 

	for(new i; i != MAX_CHEM_DROPS; i++)
	{
	    if (DropChemistry[i][temp_ID] != 0) continue;

		DropChemistry[i][Material] = GetPVarInt(playerid, "nativeCAS");
		DropChemistry[i][Type] = GetPVarInt(playerid, "tdrug_Type");
		DropChemistry[i][Amount] = GetPVarFloat(playerid, "tdrug_Amount");
		DropChemistry[i][Quality] = GetPVarFloat(playerid, "tdrug_Quality");
		DropChemistry[i][Extra][0] = GetPVarInt(playerid, "BreakingBad_1");
		DropChemistry[i][Extra][1] = GetPVarInt(playerid, "BreakingBad_2");
		DropChemistry[i][Extra][2] = GetPVarInt(playerid, "BreakingBad_3");
		DropChemistry[i][dropInt] = GetInterior(playerid);
		DropChemistry[i][dropVW] = GetWorld(playerid);
		DropChemistry[i][dropTime] = gettime();

		GetXYInFrontOfPlayer(playerid, DropChemistry[i][dropPosX], DropChemistry[i][dropPosY], DropChemistry[i][dropPosZ], 1.5);
		DropChemistry[i][dropPosZ] -= 1.0;
		DropChemistry[i][dropPosRZ] = 90.0;

		new query[350];
		mysql_format(dbHandle, query, sizeof(query), 
			"INSERT INTO `drop_chemistry` (`Material`,`Amount`,`Quality`,`Extra0`,`Extra1`,`Extra2`,`dropPosX`,`dropPosY`,`dropPosZ`,`dropPosRX`,`dropPosRY`,`dropPosRZ`,`dropInt`,`dropVW`,`dropTime`) VALUES (%i,%f,%f,%i,%i,%i,%f,%f,%f,%f,%f,%f,%i,%i,%i)",
			DropChemistry[i][Material],
			DropChemistry[i][Amount],
			DropChemistry[i][Quality],
			DropChemistry[i][Extra][0],
			DropChemistry[i][Extra][1],
			DropChemistry[i][Extra][2],
			DropChemistry[i][dropPosX], DropChemistry[i][dropPosY], DropChemistry[i][dropPosZ],
			DropChemistry[i][dropPosRX], DropChemistry[i][dropPosRY], DropChemistry[i][dropPosRZ],
			DropChemistry[i][dropInt],
			DropChemistry[i][dropVW],
			DropChemistry[i][dropTime]
		);
		mysql_tquery(dbHandle, query, "GetIDforChemistryDrop", "d", i);

		SetPlayerChatBubble(playerid, "* nem ra mot hon hop thuoc thu *", COLOR_PURPLE, 20.0, 4000); //���������
		SendSyntaxMessage(playerid, "Ban da vut bo hon hop thuoc thu. Nhap {ffc46a}/pickupmix{FFFFFF} hoac ngoi xuong va nhan {ffc46a}H{FFFFFF} de nhat.");

		DropChemistry[i][dropObject] = CreateDynamicObject(1575, DropChemistry[i][dropPosX], DropChemistry[i][dropPosY], DropChemistry[i][dropPosZ], 93.7, 120.0, 120.0, GetWorld(playerid), GetInterior(playerid));
		EditDynamicObject(playerid, DropChemistry[i][dropObject]);
		SetPVarInt(playerid, #edit_drug, i+1);

		ResetDrugCrate(playerid);
		break;
	}
	return 1;
}

