Corpse_OnPlayerEdit(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rz)
{
    if (GetPVarInt(playerid, #CorpsEdit) != 0 && (response == EDIT_RESPONSE_FINAL || response == EDIT_RESPONSE_CANCEL))
	{
		new Float:oldX, Float:oldY, Float:oldZ, Float:oldRotX, Float:oldRotY, Float:oldRotZ;

		GetDynamicObjectPos(objectid, oldX, oldY, oldZ);
		GetDynamicObjectRot(objectid, oldRotX, oldRotY, oldRotZ);
		
	    new id = GetPVarInt(playerid, #CorpsEdit)-1;
		DeletePVar(playerid, #CorpsEdit);

	    if (id < 0 || id >= sizeof(CorpInfo) || !CorpInfo[id][cUsed]) 	return SendErrorMessage(playerid, "Thi the khong duoc tim thay.");
	    if (objectid != CorpInfo[id][cBody])							return SendErrorMessage(playerid, "Loi chinh sua thi the.");

		SetDynamicObjectPos(objectid, x, y, z);
		SetDynamicObjectRot(objectid, 0.0, 0.0, rz);

        GetDynamicObjectPos(objectid, CorpInfo[id][cX], CorpInfo[id][cY], CorpInfo[id][cZ]);

        if (IsValidDynamic3DTextLabel(CorpInfo[id][cText])) DestroyDynamic3DTextLabel(CorpInfo[id][cText]);
        CorpInfo[id][cText]=CreateDynamic3DTextLabel("(( XAC CHET ))\nnhan '~k~~GROUP_CONTROL_BWD~'", COLOR_LIGHTRED, CorpInfo[id][cX], CorpInfo[id][cY], CorpInfo[id][cZ]-0.5, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, 50.0);
	}
    return 1;
}

Corpse_OnPlayerUpdate(playerid)
{
    if (pTemp[playerid][UsingBort] && pTemp[playerid][UsingCorpse]) 
	{
        new Float:X, Float:Y, Float:Z, Float:R;
        GetPlayerPos(playerid, X, Y, Z);
        GetPlayerFacingAngle(playerid, R);
        GetXYInFrontOfPlayer(playerid, X, Y, Z, 1.8);

        new idx = pTemp[playerid][UsingCorpse];
        CorpInfo[idx][cX]=X;
        CorpInfo[idx][cY]=Y;
        CorpInfo[idx][cZ]=Z;
        SetActorPos(CorpInfo[idx][cBody], X, Y, Z + 0.60);
        SetActorFacingAngle(CorpInfo[idx][cBody], R);
    }
    return 1;
}

Corpse_OnPlayerEnterVehicle(playerid)
{
    if (pTemp[playerid][UsingBort]) {
        new Float:x, Float:y, Float:z;
        GetPlayerPos(playerid, x, y, z);
        SetPlayerPos(playerid,x,y,z);
        SendErrorMessage(playerid, "Ban khong the vao xe khi dang cam xe lan.");
    }
    return 1;
}

CreateCorpse(playerid, weaponid)
{
    if (weaponid == 53) return 1;

    new 
        found = 0, 
        foundid = 0, 
        Float:x, 
        Float:y, 
        Float:z, 
        sex[8],
        age
    ;

    GetPlayerPos(playerid, x, y, z);

	for(new o = 0; o < sizeof(CorpInfo); o++)
	{
		if (o != 0)
		{
	        if (CorpInfo[o][cUsed] == 0 && found == 0)
		    {
		        found++;
			    foundid=o;
                break;
            }
        }
    }
    if (found == 0) return 1;

    CorpInfo[foundid][cUsed]=1;
    CorpInfo[foundid][cVeh]=0;
    
    format(CorpInfo[foundid][cName], 25, "%s", GetName(playerid));
    CorpInfo[foundid][cType] = 0;
    CorpInfo[foundid][cTime] = gettime();
    
    CorpInfo[foundid][cX]=x;
    CorpInfo[foundid][cY]=y;
    CorpInfo[foundid][cZ]=z;
    
    if (weaponid == 54) CorpInfo[foundid][cX] -= 0.5;
    
	CorpInfo[foundid][cSkin]=GetPlayerSkin(playerid);
	CorpInfo[foundid][cBody]=CreateActor(GetPlayerSkin(playerid), x, y, z, 0.0);
	SetActorInvulnerable(CorpInfo[foundid][cBody], true);
	ApplyActorAnimation(CorpInfo[foundid][cBody], "PED", "KO_shot_stom", 4.0, 0, 0, 0, 1, 0);
    SetActorVirtualWorld(CorpInfo[foundid][cBody], GetPlayerVirtualWorld(playerid));

	if (PlayerInfo[playerid][pSex] == 1)	format(sex, sizeof(sex), "Nam");
	else 			                        format(sex, sizeof(sex), "Nu");

    age = PlayerInfo[playerid][pAge] + random(7) - random(5);
    
    format(CorpInfo[foundid][cNote], 200, "{FFFFFF}(( Ten: %s ))\n\nTuoi khoang:\t %d\nGioi tinh nan nhan:\t %s\n\n", GetNameEx(playerid), age, sex);

    new count;
    for(new i = 0; i != MAX_DAMAGES; i++)
    {
        if (DamageInfo[playerid][i][damageOn] != 1) continue;    
        count++;
    }

    if (count > 0) format(CorpInfo[foundid][cNote], 200, "%sNan nhan bi thuong: %d lan(s)\n\n", CorpInfo[foundid][cNote], count);
    else  format(CorpInfo[foundid][cNote], 200, "%sKhong co vet thuong / bong tren co the.\n\n", CorpInfo[foundid][cNote]);

    switch(weaponid)
    {
        case 0: format(CorpInfo[foundid][cNote], 200, "%sNguyen nhan tu vong: Da bi danh.", CorpInfo[foundid][cNote]);
        case 1 .. 16: format(CorpInfo[foundid][cNote], 200, "%sNguyen nhan tu vong: Da bi danh dap bang mot do vat.", CorpInfo[foundid][cNote]);
        case 22 .. 34: format(CorpInfo[foundid][cNote], 200, "%sNguyen nhan tu vong: Bi ban tu %s.", CorpInfo[foundid][cNote], inventory_items[weaponid][itemName]);
        case 17, 41 .. 42: format(CorpInfo[foundid][cNote], 200, "%sNguyen nhan tu vong: Nghet tho.", CorpInfo[foundid][cNote]);
        case 49: format(CorpInfo[foundid][cNote], 200, "%sNguyen nhan tu vong: Bi tong boi mot phuong tien.", CorpInfo[foundid][cNote]);
        case 50: format(CorpInfo[foundid][cNote], 200, "%sNguyen nhan tu vong: Bi xe nat boi canh may bay.", CorpInfo[foundid][cNote]);
        case 18: format(CorpInfo[foundid][cNote], 200, "%sNguyen nhan tu vong: Nhieu vet bong.", CorpInfo[foundid][cNote]);
        case 51: format(CorpInfo[foundid][cNote], 200, "%sNguyen nhan tu vong: Chet vi mot vu no.", CorpInfo[foundid][cNote]);
        case 53: format(CorpInfo[foundid][cNote], 200, "%sNguyen nhan tu vong: Bi sac nuoc.", CorpInfo[foundid][cNote]);
        case 54: format(CorpInfo[foundid][cNote], 200, "%sNguyen nhan tu vong: Nga tu tren cao.", CorpInfo[foundid][cNote]);
        default: format(CorpInfo[foundid][cNote], 200, "%sNguyen nhan tu vong: Khong ro.", CorpInfo[foundid][cNote]);
    }

    CorpInfo[foundid][cText]=CreateDynamic3DTextLabel("(( XAC CHET ))\nnhan '~k~~GROUP_CONTROL_BWD~'", COLOR_LIGHTRED, x, y, z-0.5, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, 50.0);
	return 1;
}

Dialog:CorpseInfo(playerid, response, listitem, inputtext[])
{
	if (!response)	return 1;

    new dlg[90], i = GetNearestCorpse(playerid);

    switch(CorpInfo[i][cType]) {
        case 0: {//������� = 0
            dlg="Keo vao xe\nCho vao tui\nChon";
        }
        case 1: { //�������
            dlg="Dua xac ra khoi xe lan";
        }
        case 2: { //����� �����
            dlg="Keo vao xe\nLay xac ra khoi tui";
        }
        case 3:{ //����������
            dlg="Khai quat mot xac chet";
        }
    }

    if (!CorpInfo[i][cType] && PlayerInfo[playerid][pOnDuty] == 1 && (IsPlayerFactionMedic(playerid) || IsPlayerFactionFire(playerid)))
        strcat(dlg,"\nDat len cang");

    if (CheckAdmin(playerid, ADMIN_LEVEL_1) || (PlayerInfo[playerid][pOnDuty] == 1 && (IsPlayerFactionMedic(playerid) || IsPlayerFactionFire(playerid) || IsPlayerFactionPolice(playerid))))
        strcat(dlg,"\nXoa doi tuong xac chet");

    Dialog_Show(playerid, CorpseInfo2, DIALOG_STYLE_LIST, "XAC CHET", dlg, "Chon", "Quay lai"); 
    return 1;
}

Dialog:CorpseInfo2(playerid, response, listitem, inputtext[])
{
	if (!response)	return cmd::corpse(playerid, "");

    if (PlayerInfo[playerid][pInjured] != 0 || GetPVarInt(playerid, "Freeze") || pTemp[playerid][pTaserTime] || pTemp[playerid][pCuffed])
	    return SendErrorMessage(playerid, "Ban khong the su dung tinh nang nay ngay bay gio.");

    if (!IsPlayerLogged(playerid)) return SendNotConnected(playerid);

	new i = GetNearestCorpse(playerid);

    switch(listitem) {
        case 0: {
            switch(CorpInfo[i][cType]) {
                case 0: listitem=0;
                case 1: listitem=1;
                case 2: listitem=0;
                case 3: listitem=2;
            }
        }
        case 1: {
            switch(CorpInfo[i][cType]) {
                case 0: listitem=5;
                case 1: listitem=7;
                case 2: listitem=2;
                case 3: listitem=7;
            }
        }
        case 2: {
            switch(CorpInfo[i][cType]) {
                case 0: listitem=6;
                case 2: listitem=7;
            }
        }
        case 3: listitem=4;
        case 4: listitem=7;
    }

    switch(listitem)
    {
        case 0:
        {
            new vehicle = GetNearVehicle(playerid, 4.0);
            if (vehicle == -1)                         return SendErrorMessage(playerid, "Ban khong o gan mot phuong.");
            if (!IsNearTrunk(vehicle, playerid, 2.0))  return SendErrorMessage(playerid, "Ban khong o gan cop xe! ");
            if (!VehicleInfo[vehicle][carTrunkLock])   return SendErrorMessage(playerid, "Cop xe phai mo.");

            if (VehicleInfo[vehicle][vCorp] > 0 && CorpInfo[VehicleInfo[vehicle][vCorp]][cUsed] == 1) 
                return SendWarningMessage(playerid, "Da co mot xac chet trong cop xe!");
            
            new mes[128];
            format(mes, sizeof(mes), "keo mot xac chet %s trong cop xe.", CorpInfo[i][cName]);
            cmd::me(playerid, mes);

            SendSyntaxMessage(playerid, "Ban da dat xac chet trong cop xe. (( /v xac nhan - de lay ra ))");
                    
            CorpInfo[i][cTime] = gettime();
            CorpInfo[i][cVeh]=vehicle;
            VehicleInfo[vehicle][vCorp]=i+1;

            CorpInfo[i][cX] =
            CorpInfo[i][cY] =
            CorpInfo[i][cZ] = 0.0;
                    

            DestroyDynamic3DTextLabel(CorpInfo[i][cText]);
            if (!CorpInfo[i][cType] && IsValidActor(CorpInfo[i][cBody])) DestroyActor(CorpInfo[i][cBody]);
            else if (CorpInfo[i][cType] && IsValidDynamicObject(CorpInfo[i][cBody])) DestroyDynamicObject(CorpInfo[i][cBody]);
        }
        case 1: {
            new Float:x, Float:y, Float:z;
            GetPlayerPos(playerid, x, y, z);

            CorpInfo[i][cType] = 0;
            CorpInfo[i][cX] = x+0.75;
            CorpInfo[i][cY] = y;
            CorpInfo[i][cZ] = z-0.5;
            CorpInfo[i][cTime] = gettime();

            CorpInfo[i][cText]=CreateDynamic3DTextLabel("(( XAC CHET ))\nnhan '~k~~GROUP_CONTROL_BWD~'", COLOR_LIGHTRED, CorpInfo[i][cX], CorpInfo[i][cY], CorpInfo[i][cZ]-0.5, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, 50.0);

            pTemp[playerid][UsingCorpse] = 0;

            SetActorPos(CorpInfo[i][cBody], CorpInfo[i][cX], CorpInfo[i][cY], CorpInfo[i][cZ]);
            SendSyntaxMessage(playerid, "Ban da lay xac chet ra khoi xe lan.");
        }
        case 2: {
            if (IsValidDynamicObject(CorpInfo[i][cBody]))        DestroyDynamicObject(CorpInfo[i][cBody]);
            if (IsValidDynamic3DTextLabel(CorpInfo[i][cText]))   DestroyDynamic3DTextLabel(CorpInfo[i][cText]);

            new Float:x, Float:y, Float:z;
            GetPlayerPos(playerid, x, y, z);

            CorpInfo[i][cType] = 0;
            CorpInfo[i][cX] = x+0.75; 
            CorpInfo[i][cY] = y;
            CorpInfo[i][cZ] = z-0.5;
            CorpInfo[i][cTime] = gettime();

            CorpInfo[i][cBody]=CreateActor(CorpInfo[i][cSkin], x+0.75-0.5, y, z, 0.0);
            SetActorInvulnerable(CorpInfo[i][cBody], true);
            ApplyActorAnimation(CorpInfo[i][cBody], "PED", "KO_shot_stom", 4.0, 0, 0, 0, 1, 0);

            CorpInfo[i][cText]=CreateDynamic3DTextLabel("(( XAC CHET ))\nnhan '~k~~GROUP_CONTROL_BWD~'", COLOR_LIGHTRED, CorpInfo[i][cX], CorpInfo[i][cY], CorpInfo[i][cZ]-0.5, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, 50.0);

            if (CorpInfo[i][cType] == 3) SendSyntaxMessage(playerid, "Ban da khat quat duoc thi the.");
            else                        SendSyntaxMessage(playerid, "Ban da lay xac ra khoi tui.");
        }
        case 4: //�������
        {
            if (!pTemp[playerid][UsingBort])  return SendErrorMessage(playerid, "Di xe lan truoc! (/stretcher)");
            if (pTemp[playerid][UsingCorpse]) return SendErrorMessage(playerid, "Ban da co mot co the tren cang!");

            if (IsValidDynamic3DTextLabel(CorpInfo[i][cText]))   DestroyDynamic3DTextLabel(CorpInfo[i][cText]);
           
            pTemp[playerid][UsingCorpse] = i;
            CorpInfo[i][cType] = 1;   

            SendSyntaxMessage(playerid, "Ban dat mot co the tren chiec xe lan.");
        }
        case 5: //�����
        {
            if (!IsPlayerHasItem(playerid, INV_BODYBAG)) return SendErrorMessage(playerid, "Ban khong co tui dung thi the.");

            new Float:posZ;
            GetActorFacingAngle(CorpInfo[i][cBody], posZ);

            if (IsValidActor(CorpInfo[i][cBody]))  DestroyActor(CorpInfo[i][cBody]);

            SetPVarInt(playerid, #CorpsEdit, i+1);

            CorpInfo[i][cType] = 2;
            CorpInfo[i][cBody]=CreateDynamicObject(19944, CorpInfo[i][cX], CorpInfo[i][cY], CorpInfo[i][cZ]-0.5, 0.0, 0.0, posZ, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
            
            EditDynamicObject(playerid, CorpInfo[i][cBody]);
            
            SM1(playerid, "Ban da dat mot thi the vao chiec tui. [ID:%i]", i);
            cmd::me(playerid, "goi xac vao mot cai tui.");
        }
        case 6: //��������
        {
            if (GetWorld(playerid) || GetInterior(playerid)) return SendErrorMessage(playerid, "Ban khong the chon xac o day");
            //if (!IsPlayerHasItem(playerid, 6))            return SendErrorMessage(playerid, "� ��� ��� ������."); 
            if (PlayerInfo[playerid][pPlayerWeapon] != 6) return SendErrorMessage(playerid, "Ban nen cam mot cai xeng!");
 
            new Float:posZ;
            GetActorFacingAngle(CorpInfo[i][cBody], posZ);

            if (IsValidActor(CorpInfo[i][cBody]))  DestroyActor(CorpInfo[i][cBody]);
            if (IsValidDynamicObject(CorpInfo[i][cBody]))  DestroyDynamicObject(CorpInfo[i][cBody]);
            
            SetPVarInt(playerid, #CorpsEdit, i+1);

            CorpInfo[i][cType] = 3;
            CorpInfo[i][cBody]=CreateDynamicObject(19944 , CorpInfo[i][cX], CorpInfo[i][cY], CorpInfo[i][cZ]-0.5, 0.0, 0.0, posZ, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
            SetObjectMaterial(CorpInfo[i][cBody], 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);

            EditDynamicObject(playerid, CorpInfo[i][cBody]);

            SM1(playerid, "Ban da chon cai xac. [ID:%i]", i);
            cmd::me(playerid, "da chon xac.");
        }
        case 7: //�������
        {
            SM1(playerid, "Ban da xoa doi tuong xac chet. [ID:%i]", i);
            RemoveCorpse(i);
            return 1;
        }
    }
	return 1;
}

GetNearestCorpse(playerid, Float:corpse_range = 2.0)
{
    if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER) return -1;

	for(new i = 0; i < sizeof(CorpInfo); i++)
    {
        if (CorpInfo[i][cUsed] == 1)
        {
            if (IsPlayerInRangeOfPoint(playerid, corpse_range, CorpInfo[i][cX], CorpInfo[i][cY], CorpInfo[i][cZ]))
            {
                return i;
            }
        }
    }
    return -1;
}

RemoveCorpse(id)
{
	if (id == 0) return 1;
	if (CorpInfo[id][cUsed] == 1)
	{
	    CorpInfo[id][cUsed]=0;
        CorpInfo[id][cType]=0;
	    CorpInfo[id][cX]=0;
        CorpInfo[id][cY]=0;
        CorpInfo[id][cZ]=0;
		CorpInfo[id][cSkin]=0;

		if (IsValidActor(CorpInfo[id][cBody]))           DestroyActor(CorpInfo[id][cBody]);
        if (IsValidDynamicObject(CorpInfo[id][cBody]))   DestroyDynamicObject(CorpInfo[id][cBody]);
		
        if (CorpInfo[id][cVeh] > 0 && GetVehicleModel(CorpInfo[id][cVeh]) > 0) {
		    VehicleInfo[CorpInfo[id][cVeh]][vCorp]=0;
		} else { DestroyDynamic3DTextLabel(CorpInfo[id][cText]); }
        
        for(new i; i < GetPlayerPoolSize(); i++) {
            if (pTemp[i][UsingCorpse] == id) {
                pTemp[i][UsingCorpse] = 0;
                break;
            }
        }
	}
	return 1;
}