enum LABEL_ENUM
{
	tID,
	tText[128],
	Float:tPosX,
	Float:tPosY,
	Float:tPosZ,
	//tColor,
	tVW,
	tInt,
	tGameText,
	tPickupModel,

	tLabelOn,
	Text3D:tLabel,
	tPickUp,

	tCreateDate[64],
	tCreator[32],

	tEdited,
	tEditDate[64],
	tEditor[32]
}
new LabelsInfo[MAX_LABELS][LABEL_ENUM];

forward LoadDynamicLabels();
forward OnLabelInsert(LabelID);

public LoadDynamicLabels()
{
	new rows = cache_num_rows(), time = GetTickCount(), total;

	if (!rows)
	{
	    print("[Labels] Khong co du lieu duoc tim thay.");
	    return 1;
	}

	for(new i; i < rows; i++)
	{
		if (i >= MAX_LABELS)	break;

	    LabelsInfo[i][tID] = cache_get_field_content_int(i, "id");
		LabelsInfo[i][tPosX] = cache_get_field_content_float(i, "posx");
		LabelsInfo[i][tPosY] = cache_get_field_content_float(i, "posy");
		LabelsInfo[i][tPosZ] = cache_get_field_content_float(i, "posz");
		//LabelsInfo[i][tColor] = cache_get_field_content_int(i, "color");
		LabelsInfo[i][tVW] = cache_get_field_content_int(i, "vw");
		LabelsInfo[i][tInt] = cache_get_field_content_int(i, "interior");
		cache_get_field_content(i, "labeltext", LabelsInfo[i][tText], dbHandle, 128);
		LabelsInfo[i][tGameText] = cache_get_field_content_int(i, "gametext");
		LabelsInfo[i][tPickupModel] = cache_get_field_content_int(i, "pickup");
		cache_get_field_content(i, "c_date", LabelsInfo[i][tCreateDate], dbHandle, 64);
		cache_get_field_content(i, "creator", LabelsInfo[i][tCreator], dbHandle, 32);
		LabelsInfo[i][tEdited] = cache_get_field_content_int(i, "edited");
		cache_get_field_content(i, "e_date", LabelsInfo[i][tEditDate], dbHandle, 64);
		cache_get_field_content(i, "editor", LabelsInfo[i][tEditor], dbHandle, 32);
		LabelsInfo[i][tLabelOn] = 1;

		if (!LabelsInfo[i][tGameText]) LabelsInfo[i][tLabel] = CreateDynamic3DTextLabel(LabelsInfo[i][tText], 0xFFFFFFFF, LabelsInfo[i][tPosX], LabelsInfo[i][tPosY], LabelsInfo[i][tPosZ], 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, LabelsInfo[i][tVW], LabelsInfo[i][tInt], -1, 100.0);
		else LabelsInfo[i][tLabel] = Text3D:INVALID_3DTEXT_ID;

		LabelsInfo[i][tPickUp] = CreateDynamicPickup(LabelsInfo[i][tPickupModel], 1, LabelsInfo[i][tPosX], LabelsInfo[i][tPosY], LabelsInfo[i][tPosZ], LabelsInfo[i][tVW], LabelsInfo[i][tInt], -1, 100.0);
		total++;
	}
	printf("[Labels] Rows - %i. Load - %i. Time: %i ms.", rows, total, GetTickCount()-time);
	return 1;
}

public OnLabelInsert(LabelID)
{
	return LabelsInfo[LabelID][tID] = cache_insert_id();
}

AddLabelToFile(LabelID, LabelInfo[], virworld, color, gametext, Float:LX, Float:LY, Float:LZ, pickup, interior, date[], creator[])
{
    new query[512];

	mysql_format(dbHandle,query, sizeof(query), "INSERT INTO `labels` (posx,posy,posz,color,labeltext,vw,gametext,pickup,interior,c_date,creator,edited,e_date,editor) VALUES (%f,%f,%f,%i,'%e',%i,%i,%i,%i,'%s','%e',0,'NULL','NULL')", 
	LX, LY, LZ, color, LabelInfo, virworld, gametext, pickup, interior, date, creator);
	mysql_tquery(dbHandle, query, "OnLabelInsert", "d", LabelID);
	return 1;
}

GetFreeLabelSlot()
{
	for(new i; i < MAX_LABELS; i++)
	{
		if (i >= MAX_LABELS) break;
		
		if (LabelsInfo[i][tLabelOn]) continue;

		return i;
	}
	return -1;
}

Label_Nearest(playerid)
{
	for(new i; i < MAX_LABELS; i++)
	{
		if (!LabelsInfo[i][tLabelOn]) continue;

		if (IsPlayerInRangeOfPoint(playerid, 5.0, LabelsInfo[i][tPosX], LabelsInfo[i][tPosY], LabelsInfo[i][tPosZ]) && GetInterior(playerid) == LabelsInfo[i][tInt] && GetWorld(playerid) == LabelsInfo[i][tVW])
		{
			return i;
		}
	}
	return -1;
}

CMD:alabel(playerid, params[]) //vova
{
	new option[16], secoption, thirdoption[128], fouroption, lab_text[80];

	if (!CheckAdmin(playerid, HIGH_ADMIN_LEVEL)) return SendErrorMessage(playerid, "Ban khong the su dung lenh nay.");
	if (sscanf(params, "s[16]S()[127]", option, thirdoption))
	{
		SendHelpMessage(playerid, "/alabel [create / remove / edit / goto / info]");
		return 1;
	}
	
	if (CompareStrings(option, "create"))
	{
		if (sscanf(thirdoption, "iis[79]", secoption, fouroption, lab_text)) return SendHelpMessage(playerid, "/label create [pickup model] [0 - 3DText | 1 - GameText] [text] EXAMPLE COLOR: ~FFFF00~");
		if (fouroption < 0 || fouroption > 1) 	return SendErrorMessage(playerid, "[0 - 3DText | 1 - GameText]");
		if (strlen(lab_text) > 127) 				return SendErrorMessage(playerid, "To da so ky tu la 127. ");

		new labelid = GetFreeLabelSlot();

		if (labelid == -1) return SendErrorMessage(playerid, "Da dat den so lan nhan hang co nhan toi da.");

		GetPlayerPos(playerid, LabelsInfo[labelid][tPosX], LabelsInfo[labelid][tPosY], LabelsInfo[labelid][tPosZ]);
		LabelsInfo[labelid][tVW] = GetWorld(playerid);
		LabelsInfo[labelid][tInt] = GetInterior(playerid);
		LabelsInfo[labelid][tGameText] = fouroption;
		LabelsInfo[labelid][tPickupModel] = secoption;
		LabelsInfo[labelid][tLabelOn] = 1;
		format(LabelsInfo[labelid][tText], 128, "%s", lab_text);
		format(LabelsInfo[labelid][tCreateDate], 64, "%s", GetFullDate());
		format(LabelsInfo[labelid][tCreator], 32, "%s", GetAccName(playerid));

		if (!fouroption)
		{
			place_color(LabelsInfo[labelid][tText]);
			LabelsInfo[labelid][tLabel] = CreateDynamic3DTextLabel(LabelsInfo[labelid][tText], 0xFFFFFFFF, LabelsInfo[labelid][tPosX], LabelsInfo[labelid][tPosY], LabelsInfo[labelid][tPosZ], 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, LabelsInfo[labelid][tVW], LabelsInfo[labelid][tInt], -1, 100.0);
		}
		else
		{
			LabelsInfo[labelid][tLabel] = Text3D:INVALID_3DTEXT_ID;
		}

		LabelsInfo[labelid][tPickUp] = CreateDynamicPickup(secoption, 1, LabelsInfo[labelid][tPosX], LabelsInfo[labelid][tPosY], LabelsInfo[labelid][tPosZ], LabelsInfo[labelid][tVW], LabelsInfo[labelid][tInt], -1, 100.0);
		AddLabelToFile(labelid, LabelsInfo[labelid][tText], GetWorld(playerid), 1, fouroption, LabelsInfo[labelid][tPosX], LabelsInfo[labelid][tPosY], LabelsInfo[labelid][tPosZ], secoption, GetInterior(playerid), GetFullDate(), GetAccName(playerid));
		SendSyntaxMessage(playerid, "New pickup decal [ID: %i] added. Text: %s. Pickup model: %i.", labelid, lab_text, secoption);
		return 1;

	}
	else if (CompareStrings(option, "remove"))
	{
		if (sscanf(thirdoption, "i", secoption)) 										return SendHelpMessage(playerid, "/label remove [label ID]");
		if (secoption < 0 || secoption > MAX_LABELS || !LabelsInfo[secoption][tLabelOn])	return SendErrorMessage(playerid, "An inscription with this ID was not found.");

		if (IsValidDynamic3DTextLabel(LabelsInfo[secoption][tLabel]))
		{
			DestroyDynamic3DTextLabel(LabelsInfo[secoption][tLabel]);
			LabelsInfo[secoption][tLabel] = Text3D:INVALID_3DTEXT_ID;
		}
		
		if (IsValidDynamicPickup(LabelsInfo[secoption][tPickUp]))
		{
			DestroyDynamicPickup(LabelsInfo[secoption][tPickUp]);
		}

		new query[128];

		mysql_format(dbHandle, query, sizeof(query), "DELETE FROM `labels` WHERE `id` = %i", LabelsInfo[secoption][tID]);
		mysql_tquery(dbHandle, query);

		LabelsInfo[secoption][tID] = 
		LabelsInfo[secoption][tLabelOn] = 0;
		SendSyntaxMessage(playerid, "Inscription [ID: %i] deleted.", secoption);
		return 1;
	}
	else if (CompareStrings(option, "edit"))
	{
		if (sscanf(thirdoption, "iiS()[127]", secoption, fouroption, lab_text))		return SendHelpMessage(playerid, "/label edit [ID] [type (1 - text | 2 - position) [value (for text)]");
		if (secoption < 0 || secoption > MAX_LABELS || !LabelsInfo[secoption][tLabelOn])	return SendErrorMessage(playerid, "An inscription with this ID was not found.");
		if (fouroption < 1 || fouroption > 2)											return SendErrorMessage(playerid, "[1 - text | 2 - position]");


		if (fouroption == 1)
		{
			if (strlen(lab_text) < 0) return SendErrorMessage(playerid, "You have not entered new text.");

			format(LabelsInfo[secoption][tText], 128, "%s", lab_text);

			if (LabelsInfo[secoption][tGameText] == 0 && IsValidDynamic3DTextLabel(LabelsInfo[secoption][tLabel]))
			{
				place_color(LabelsInfo[secoption][tText]);
				UpdateDynamic3DTextLabelText(LabelsInfo[secoption][tLabel], 0xFFFFFFFF, LabelsInfo[secoption][tText]);
			}

			new query[156];
			
			mysql_format(dbHandle, query, sizeof(query), "UPDATE `labels` SET `labeltext` = '%e', `edited` = '1', `e_date` = '%s', `editor` = '%e' WHERE `id` = %i", 
			LabelsInfo[secoption][tText], GetFullDate(), GetAccName(playerid), LabelsInfo[secoption][tID]);
			mysql_tquery(dbHandle, query);
			
			LabelsInfo[secoption][tEdited] = 1;
			format(LabelsInfo[secoption][tEditDate], 64, "%s", GetFullDate());
			format(LabelsInfo[secoption][tEditor], 32, "%s", GetAccName(playerid));
			return 1;
		}
		if (fouroption == 2)
		{
			GetPlayerPos(playerid, LabelsInfo[secoption][tPosX], LabelsInfo[secoption][tPosY], LabelsInfo[secoption][tPosZ]);
			LabelsInfo[secoption][tVW] = GetWorld(playerid);
			LabelsInfo[secoption][tInt] = GetInterior(playerid);

			new query[384];

			mysql_format(dbHandle, query, sizeof(query), "UPDATE `labels` SET `posx` = %f, `posy` = %f, `posz` = %f, `interior` =%i, `vw` =%i, `edited` = '1', `e_date` = '%s', `editor` = '%e' WHERE `id` = %i", 
			LabelsInfo[secoption][tPosX], LabelsInfo[secoption][tPosY], LabelsInfo[secoption][tPosZ], LabelsInfo[secoption][tInt], LabelsInfo[secoption][tVW], GetFullDate(), GetAccName(playerid), LabelsInfo[secoption][tID]);
			mysql_tquery(dbHandle, query);

			LabelsInfo[secoption][tEdited] = 1;
			format(LabelsInfo[secoption][tEditDate], 64, "%s", GetFullDate());
			format(LabelsInfo[secoption][tEditor], 32, "%s", GetAccName(playerid));

			if (IsValidDynamic3DTextLabel(LabelsInfo[secoption][tLabel]))
			{
				DestroyDynamic3DTextLabel(LabelsInfo[secoption][tLabel]);
				LabelsInfo[secoption][tLabel] = Text3D:INVALID_3DTEXT_ID;
			}

			if (IsValidDynamicPickup(LabelsInfo[secoption][tPickUp])) DestroyDynamicPickup(LabelsInfo[secoption][tPickUp]);

			if (LabelsInfo[secoption][tGameText] == 0)
			{
				LabelsInfo[secoption][tLabel] = CreateDynamic3DTextLabel(LabelsInfo[secoption][tText], 0xFFFFFFFF, LabelsInfo[secoption][tPosX], LabelsInfo[secoption][tPosY], LabelsInfo[secoption][tPosZ], 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, LabelsInfo[secoption][tVW], LabelsInfo[secoption][tInt], -1, 100.0);
			}
			LabelsInfo[secoption][tPickUp] = CreateDynamicPickup(LabelsInfo[secoption][tPickupModel], 1, LabelsInfo[secoption][tPosX], LabelsInfo[secoption][tPosY], LabelsInfo[secoption][tPosZ], LabelsInfo[secoption][tVW], LabelsInfo[secoption][tInt], -1, 100.0);
		}
		return 1;
	}
	else if (CompareStrings(option, "goto"))
	{
		if (sscanf(thirdoption, "i", secoption)) return SendHelpMessage(playerid, "/label goto [label ID]");
		if (secoption < 0 || secoption > MAX_LABELS || !LabelsInfo[secoption][tLabelOn]) return SendErrorMessage(playerid, "An inscription with this ID was not found. ");

		SetPlayerPosEx(playerid, LabelsInfo[secoption][tPosX], LabelsInfo[secoption][tPosY], LabelsInfo[secoption][tPosZ]);
		SetWorld(playerid, LabelsInfo[secoption][tVW]);
		SetInterior(playerid, LabelsInfo[secoption][tInt]);
		return 1;
	}
	else if (CompareStrings(option, "info"))
	{
		new labelid = Label_Nearest(playerid);
		
		if (labelid == -1) return SendErrorMessage(playerid, "Khong co dong chu nao gan ban. ");
		
		new label_txt[256], label_type[10];

		if (LabelsInfo[labelid][tGameText])	label_type = "GameText";
		else								label_type = "3DText";

		if (LabelsInfo[labelid][tEdited])
		{

			format(label_txt, sizeof(label_txt), "ID label\t%i\nLabel type\t%s\nPickup\t%i [ID: %i]\n	\ndate of creation\t%s\n Creator\t%s\n	\nLast editing\t%s\nEditor\t%s", 
			labelid, label_type, LabelsInfo[labelid][tPickupModel], LabelsInfo[labelid][tPickUp], LabelsInfo[labelid][tCreateDate], LabelsInfo[labelid][tCreator], LabelsInfo[labelid][tEditDate], LabelsInfo[labelid][tEditor]);
		}
		else
		{
			format(label_txt, sizeof(label_txt), "ID label\t%i\nLabel type\t%s\nPickup\t%i [ID: %i]\n	\ndate of creation\t%s\n Creator\t%s",
			labelid, label_type, LabelsInfo[labelid][tPickupModel], LabelsInfo[labelid][tPickUp], LabelsInfo[labelid][tCreateDate], LabelsInfo[labelid][tCreator]);
		}

		Dialog_Show(playerid, None, DIALOG_STYLE_TABLIST, "{FFFFFF}Label information", label_txt, "Close", "");
	}
	else 
	{
		SendHelpMessage(playerid, "/label [options]");
		SendSyntaxMessage(playerid, "create / remove / edit / goto info");	
	}
	return 1;
}

Lab_OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
    for(new i = 0; i != MAX_LABELS; i++)
	{
	    if (LabelsInfo[i][tLabelOn] == 0 || pickupid != LabelsInfo[i][tPickUp] || LabelsInfo[i][tGameText] != 1) continue;

		GameTextForPlayer(playerid, LabelsInfo[i][tText], 4000, 4);
	}
	return 1;
}

Label_OnGameModeInit()
{
    return mysql_tquery(dbHandle, "SELECT * FROM `labels`", "LoadDynamicLabels");
}
