stock BillBoard_OnGameModeInit()
{
	return mysql_tquery(dbHandle, "SELECT * FROM `billboards`", "OnBillboardsLoad");
}

CheckDialogString(string[])
{
    if (strfind(string, "\n", true) != -1)  return 1;

    return 0;
}

this::OnBillboardsLoad()
{
	new rows = cache_num_rows(), time = GetTickCount(), total;

	if (!rows) return print("[BillBoards] Khong co du lieu duoc tim thay.");
	
	for(new i; i < rows; i++)
    {
        BillboardInfo[i][bbActive] = true;

        BillboardInfo[i][bbID] = cache_get_field_content_int(i, "id", dbHandle);
		cache_get_field_content(i, "text", BillboardInfo[i][bbText], dbHandle, 100);
		BillboardInfo[i][bbRentBy] = cache_get_field_content_int(i, "rentby", dbHandle);
		BillboardInfo[i][bbRentDate] = cache_get_field_content_int(i, "rentdate", dbHandle);
		BillboardInfo[i][bbRentCost] = cache_get_field_content_int(i, "cost", dbHandle);
        BillboardInfo[i][bbPosX] = cache_get_field_content_float(i, "posX", dbHandle);
        BillboardInfo[i][bbPosY] = cache_get_field_content_float(i, "posY", dbHandle);
        BillboardInfo[i][bbPosZ] = cache_get_field_content_float(i, "posZ", dbHandle);
        BillboardInfo[i][bbPosRX] = cache_get_field_content_float(i, "posRX", dbHandle);
        BillboardInfo[i][bbPosRY] = cache_get_field_content_float(i, "posRY", dbHandle);
        BillboardInfo[i][bbPosRZ] = cache_get_field_content_float(i, "posRZ", dbHandle);
        BillboardInfo[i][bbInt] = cache_get_field_content_int(i, "int", dbHandle);
        BillboardInfo[i][bbVW] = cache_get_field_content_int(i, "vw", dbHandle);
        BillboardInfo[i][bbModel] = cache_get_field_content_int(i, "model", dbHandle);
 
        BillboardInfo[i][bbObject] = CreateDynamicObject(BillboardInfo[i][bbModel], BillboardInfo[i][bbPosX], BillboardInfo[i][bbPosY], BillboardInfo[i][bbPosZ], BillboardInfo[i][bbPosRX], BillboardInfo[i][bbPosRY], BillboardInfo[i][bbPosRZ], BillboardInfo[i][bbInt], BillboardInfo[i][bbVW]);
		
		SetDynamicObjectMaterial(BillboardInfo[i][bbObject], 0, -1, "none", "none", 0xFFFFFFFF);
		SetDynamicObjectMaterialText(BillboardInfo[i][bbObject], 0, BillboardInfo[i][bbText], OBJECT_MATERIAL_SIZE_512x128,"Arial", 28, 0, 0xFF000000, 0x0FFFFFFF, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	}

    printf("[BillBoards] Rows - %i. Load - %i. Time: %i ms.", rows, total, GetTickCount()-time);
    return 1;
}

stock Save_BB(i)
{
	new query[526];
	mysql_format(dbHandle, query, sizeof(query), 
        "UPDATE `billboards` SET `text`='%e',`rentby`=%i,`cost`=%i,`rentdate`=%i,`posX`=%f,`posY`=%f,`posZ`=%f,`posRX`=%f,`posRY`=%f,`posRZ`=%f,`model`=%i,`int`=%i,`vw`=%i WHERE `id`=%i", 
        BillboardInfo[i][bbText], BillboardInfo[i][bbRentBy], BillboardInfo[i][bbRentCost], BillboardInfo[i][bbRentDate], 
		BillboardInfo[i][bbPosX], BillboardInfo[i][bbPosY], BillboardInfo[i][bbPosZ], 
        BillboardInfo[i][bbPosRX], BillboardInfo[i][bbPosRY], BillboardInfo[i][bbPosRZ], 
        BillboardInfo[i][bbModel], BillboardInfo[i][bbInt], BillboardInfo[i][bbVW], BillboardInfo[i][bbID]
    );
	return mysql_tquery(dbHandle, query);
}

CreateBillBoard(playerid, Float:X, Float:Y, Float:Z, Float:rotX, Float:rotY, Float:rotZ, Interior, VirtualWorld, bModel, Cost)
{
    new bbid = GetUnusedBillBoard();

    BillboardInfo[bbid][bbPosX] = X;
    BillboardInfo[bbid][bbPosY] = Y;
    BillboardInfo[bbid][bbPosZ] = Z;
    BillboardInfo[bbid][bbPosRX] = rotX;
    BillboardInfo[bbid][bbPosRY] = rotY;
    BillboardInfo[bbid][bbPosRZ] = rotZ;
    BillboardInfo[bbid][bbInt] = Interior;
    BillboardInfo[bbid][bbVW] = VirtualWorld;
    BillboardInfo[bbid][bbActive] = true;

	BillboardInfo[bbid][bbRentCost] = Cost;
	BillboardInfo[bbid][bbModel] = bModel;

    BillboardInfo[bbid][bbObject] = CreateDynamicObject(BillboardInfo[bbid][bbModel], BillboardInfo[bbid][bbPosX], BillboardInfo[bbid][bbPosY], BillboardInfo[bbid][bbPosZ], BillboardInfo[bbid][bbPosRX], BillboardInfo[bbid][bbPosRY], BillboardInfo[bbid][bbPosRZ], BillboardInfo[bbid][bbInt], BillboardInfo[bbid][bbVW]);
	
	format(BillboardInfo[bbid][bbText], 100, "QUANG CAO O DAY!\nBIEN QUANG CAO #%i\n{595959}Ph. 1-800-555", bbid+1);

	SetDynamicObjectMaterial(BillboardInfo[bbid][bbObject], 0, -1, "none", "none", 0xFFFFFFFF);
	SetDynamicObjectMaterialText(BillboardInfo[bbid][bbObject], 0, BillboardInfo[bbid][bbText], OBJECT_MATERIAL_SIZE_512x128,"Arial", 28, 0, 0xFF000000, 0x0FFFFFFF, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	
	new query[250+100];
	mysql_format(dbHandle, query, sizeof(query), "INSERT INTO `billboards` (`posX`,`posY`,`posZ`,`posRX`,`posRY`,`posRZ`,`int`,`vw`,`model`,`cost`,`text`) VALUES (%f,%f,%f,%f,%f,%f,%i,%i,%i,%i,'%e')", X, Y, Z, rotX, rotY, rotZ, Interior, VirtualWorld, bModel, Cost, BillboardInfo[bbid][bbText]);
	mysql_tquery(dbHandle, query, "GetIDforBillboard", "d", bbid);

	SendAdmMessageToPlayer(playerid, "Ban da tao mot bien quang cao #%i / gia - $%i / model - %i", bbid+1, Cost, bModel);
	return 1;
}

this::GetIDforBillboard(i) 
{
	BillboardInfo[i][bbID] = cache_insert_id();
	return 1;
}

stock DeleteBillBoard(bbid)
{
	new query[182];
	mysql_format(dbHandle, query, sizeof(query), "DELETE FROM `billboards` WHERE `ID` = %d", BillboardInfo[bbid][bbID]);
	mysql_tquery(dbHandle, query);

	DestroyDynamicObject(BillboardInfo[bbid][bbObject]);

    BillboardInfo[bbid][bbID] = 0;
	BillboardInfo[bbid][bbText] = EOS;
	BillboardInfo[bbid][bbRentDate] = 0;
	BillboardInfo[bbid][bbRentBy] = 0;
    BillboardInfo[bbid][bbPosX] = 0.0;
    BillboardInfo[bbid][bbPosY] = 0.0;
    BillboardInfo[bbid][bbPosZ] = 0.0;
    BillboardInfo[bbid][bbPosRX] = 0.0;
    BillboardInfo[bbid][bbPosRY] = 0.0;
    BillboardInfo[bbid][bbPosRZ] = 0.0;
    BillboardInfo[bbid][bbInt] = 0;
    BillboardInfo[bbid][bbVW] = 0;
    BillboardInfo[bbid][bbActive] = false;
	return 1;
}

stock IsAtBillBoard(playerid)
{
	for(new i = 0; i < MAX_BILLBOARDS; i++)
	{
	    if (BillboardInfo[i][bbActive] != true) continue;
	    if (IsPlayerInRangeOfPoint(playerid, 5.0, BillboardInfo[i][bbPosX], BillboardInfo[i][bbPosY], BillboardInfo[i][bbPosZ])) return 1;
	}
	return 0;
}

stock GetPlayerDistanceToPointEx(playerid,Float:sx,Float:sy,Float:sz) //By Sacky
{
	new Float:x1,Float:y1,Float:z1;
	new Float:tmpdis;
	GetPlayerPos(playerid,x1,y1,z1);
	tmpdis = floatsqroot(floatpower(floatabs(floatsub(sx,x1)),2)+floatpower(floatabs(floatsub(sy,y1)),2)+floatpower(floatabs(floatsub(sz,z1)),2));
	return floatround(tmpdis);
}

stock GetClosestBillBoard(playerid, Float:radius = 9999.0)
{
	new cl_ID = -1, Float:cl_DIST = radius;
	for(new i = 0; i < MAX_BILLBOARDS; i++)
	{
	    if (BillboardInfo[i][bbActive] != true) continue;
		if ( GetPlayerDistanceToPointEx(playerid, BillboardInfo[i][bbPosX], BillboardInfo[i][bbPosY], BillboardInfo[i][bbPosZ]) < cl_DIST )
		{
		    cl_ID = i;
		    cl_DIST = GetPlayerDistanceToPointEx(playerid, BillboardInfo[i][bbPosX], BillboardInfo[i][bbPosY], BillboardInfo[i][bbPosZ]);
		}
	}
	return cl_ID;
}
stock GetUnusedBillBoard()
{
	for(new i = 0; i < MAX_BILLBOARDS; i++)
	{
	    if (BillboardInfo[i][bbActive] != true) return i;
	}
	return -1;
}

this::MyBillBoard_Unrent(playerid, response)
{
	if (!response)    return DeletePVar(playerid, #BB_SELECT_ID);

	BillBoard_Unrent(GetPVarInt(playerid, #BB_SELECT_ID));
	DeletePVar(playerid, #BB_SELECT_ID);
	return 1;
}

BillBoard_Unrent(i)
{
	if (IsValidDynamicObject(BillboardInfo[i][bbObject])) DestroyDynamicObject(BillboardInfo[i][bbObject]);
	BillboardInfo[i][bbObject] = CreateDynamicObject(BillboardInfo[i][bbModel], BillboardInfo[i][bbPosX], BillboardInfo[i][bbPosY], BillboardInfo[i][bbPosZ], BillboardInfo[i][bbPosRX], BillboardInfo[i][bbPosRY], BillboardInfo[i][bbPosRZ], BillboardInfo[i][bbInt], BillboardInfo[i][bbVW]);

	BillboardInfo[i][bbRentDate] = 0;
	BillboardInfo[i][bbRentBy] = 0;
	format(BillboardInfo[i][bbText], 100, "QUANG CAO O DAY!\nBIEN QUANG CAO #%i\n{595959}Ph. 1-800-555", i+1);
	
	Save_BB(i);

	SetDynamicObjectMaterial(BillboardInfo[i][bbObject], 0, -1, "none", "none", 0xFFFFFFFF);
	SetDynamicObjectMaterialText(BillboardInfo[i][bbObject], 0, BillboardInfo[i][bbText], OBJECT_MATERIAL_SIZE_512x128,"Arial", 28, 0, 0xFF000000, 0x0FFFFFFF, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);

	return 1;
} //�