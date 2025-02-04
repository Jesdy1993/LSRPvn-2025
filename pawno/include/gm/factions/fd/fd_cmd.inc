CMD:stretcher(playerid, params[])
{
	new faction = PlayerInfo[playerid][pFaction];

	if (!IsFactionMedic(faction) && !IsFactionFire(faction))	return SendErrorMessage(playerid,"Ban phai la nhan vien y te hoac linh cuu hoa.");
	if (IsPlayerInAnyVehicle(playerid))						return SendErrorMessage(playerid, "Ban khong duoc o trong xe.");

	if (pTemp[playerid][UsingBort]) {
		new idx = pTemp[playerid][UsingBort]-1, modelid = GetDynamicObjectModel(BortInfo[playerid][idx][bortObject]);

		DestroyDynamicObject(BortInfo[playerid][idx][bortObject]);

		new Float:x, Float:y, Float:z, Float:R;
		GetPlayerFacingAngle(playerid, R);
	  	GetXYInFrontOfPlayer(playerid, x, y, z, 1.5);
		BortInfo[playerid][idx][bortObject] = CreateDynamicObject(modelid, x, y, z - 0.5, 0.0, 0.0, 0.0, GetWorld(playerid), GetInterior(playerid));
		
		if (pTemp[playerid][UsingCorpse]) {
			new actorid = pTemp[playerid][UsingCorpse];
			SetActorPos(actorid, x, y, z + 0.60);
			SetActorFacingAngle(actorid, R);
			pTemp[playerid][UsingCorpse] = 0;
		}

		BortInfo[playerid][idx][bortUsing] = 0;
		pTemp[playerid][UsingBort] = 0;

		SendMedicMessage(playerid, "Ban buong tay khoi chiec xe lan");
		return 1;
	}

    if (!PlayerInfo[playerid][pOnDuty])	return SendErrorMessage(playerid, "Dau tien ban can phai trong gio lam viec.");

	new idx = -1;
	for(new i = 0; i < MAX_BORTES; i++)
	{
	    if (!BortInfo[playerid][i][bortOn]) continue;
		if (BortInfo[playerid][i][bortUsing] != 0) continue;

		new Float: x, Float: y, Float: z;
		GetDynamicObjectPos(BortInfo[playerid][i][bortObject], x, y, z);

		if (GetPlayerDistanceFromPoint(playerid, x, y, z) > 1.5) continue;

		new modelid = GetDynamicObjectModel(BortInfo[playerid][i][bortObject]);
		if (modelid != 1997 && modelid != 2146) continue;

		idx = i;
		break;
	}
	
	if (idx == -1) return SendErrorMessage(playerid, "Ban khong co xe lan ben canh! (/ bort) ");

	BortInfo[playerid][idx][bortUsing] = playerid+1;
	pTemp[playerid][UsingBort] = idx+1;
	pTemp[playerid][UsingCorpse] = 0;

	AttachDynamicObjectToPlayer(BortInfo[playerid][idx][bortObject], playerid, 0.00, 1.50, -0.50, 0.0, 0.0, 0.0);

    SendMedicMessage(playerid, "Ban da di xe lan.");
	return 1;
}

CMD:therapy(playerid, params[])
{
	new faction = PlayerInfo[playerid][pFaction], userid;

	if (!IsFactionMedic(faction))					return SendErrorMessage(playerid, "Ban phai la mot nhan vien y te.");
	if (PlayerInfo[playerid][pRank] < 3)				return SendErrorMessage(playerid, "Cap bac co san tu 3.");
	if (!PlayerInfo[playerid][pOnDuty])				return SendErrorMessage(playerid, "Dau tien ban can phai trong gio lam viec.");
	if (sscanf(params, "u", userid))					return SendHelpMessage(playerid, "/therapy [ID/Ten]");
	if (!IsPlayerLogged(userid))						return SendNotConnected(playerid);
	if (userid == playerid)							return SendErrorMessage(playerid, "ID khong hop le.");
	if (!PlayerNearPlayer(3.0, playerid, userid))	return SendNotNearPlayer(playerid);
	if (PlayerInfo[userid][pDependence] == 0)		return SendErrorMessage(playerid, "Nguoi choi khong nghien ma tuy. ");

    PlayerInfo[userid][pDependence] -= (PlayerInfo[userid][pDependence] < 20) ? (PlayerInfo[userid][pDependence]) : (20);
    pTemp[userid][pDemolitionTime] = 0;
	SetPlayerCurrentTimeAndWeather(userid);
	
	SendMedicMessage(userid, "%s %s giam con nghien cua ban xuong 20 diem.", GetRankName(playerid), GetNameWithMask(playerid));
    SendMedicMessage(playerid, "Ban da giam con nghien cua %s's.", GetNameWithMask(userid));

	return 1;
}

CMD:prescribe(playerid, params[])
{
	new faction = PlayerInfo[playerid][pFaction], userid, days;

	if (!IsFactionMedic(faction))					return SendErrorMessage(playerid, "Ban phai la mot nhan vien y te.");
	if (PlayerInfo[playerid][pRank] < 3)				return SendErrorMessage(playerid, "Cap bac co san tu 3.");
	if (!PlayerInfo[playerid][pOnDuty])				return SendErrorMessage(playerid, "Dau tien ban can phai trong gio lam viec. ");	
	if (sscanf(params,"uI(0)",userid, days))			return SendHelpMessage(playerid, "/prescribe [ID/Ten] [so ngay 1-93]");
	if (!IsPlayerLogged(userid))						return SendNotConnected(playerid);
	if (!PlayerNearPlayer(3.0, playerid, userid))	return SendNotNearPlayer(playerid);	
	if (PlayerInfo[userid][pPrescribe] < gettime())
	{
	    if (days < 1 || days > 93)					return SendErrorMessage(playerid, "Ngay het han theo toa khong hop le. ");
	        
	    PlayerInfo[userid][pPrescribe] = gettime() + days * 86400;
	    SendMedicMessage(userid, "%s %s da cho ban mot don thuoc can sa y te.", GetRankName(playerid), GetNameWithMask(playerid));
		SendHelpMessage(userid, "Su dung /showprescribe de hien thi cong thuc.");
        SendMedicMessage(playerid, "Ban da cap cho %s don thuoc can sa y te ", GetNameWithMask(userid));
	}
	else
	{
	    PlayerInfo[userid][pPrescribe] = 0;
	    SendMedicMessage(userid, "%s %s da lay can sa y te theo toa cua ban.", GetRankName(playerid), GetNameWithMask(playerid));
        SendMedicMessage(playerid, "Ban da lay tu %s mot don thuoc can sa y te.", GetNameWithMask(userid));
	}
	return 1;
}

CMD:operation(playerid, params[])
{
	new faction = PlayerInfo[playerid][pFaction], userid;

	if (!IsFactionMedic(faction) && !IsFactionFire(faction))	return SendErrorMessage(playerid, "Ban phai la nhan vien y te hoac linh cuu hoa.");
	if (!PlayerInfo[playerid][pOnDuty])					return SendErrorMessage(playerid, "Dau tien ban can phai trong gio lam viec. ");
	if (sscanf(params, "u", userid))					return SendHelpMessage(playerid, "/operation [ID/Ten]");
	if (!IsPlayerLogged(userid))						return SendNotConnected(playerid);
	if (userid == playerid)								return SendErrorMessage(playerid, "Khong the tu chua khoi. ");
	if (!PlayerNearPlayer(3.0, playerid, userid))		return SendNotNearPlayer(playerid);
	if (PlayerInfo[userid][pInjured] != 1)				return SendErrorMessage(playerid, "Nguoi choi khong bi thuong. ");
	if (pTemp[userid][pInvulnerable] != 0.0)			return SendErrorMessage(playerid, "Thu lai sau!");
    ResetDamages(userid);
    SetPlayerHealth(userid, 100.0);
	StopPlayerAnims(userid);
	UnFreezePlayer(userid);

	SendMedicMessage(playerid, "Ban da dua %s ra khoi giai doan bi thuong.", GetNameWithMask(userid));
	SendMedicMessage(userid, "%s %s da dua ban ra khoi giai doan bi thuong.", GetRankName(playerid), GetNameWithMask(playerid));
	return 1;
}

CMD:hpc(playerid, params[])
{
	new faction = PlayerInfo[playerid][pFaction], id, vehicle = GetPlayerVehicleID(playerid);

	if (!IsFactionMedic(faction) && !IsFactionFire(faction))	return SendErrorMessage(playerid, "Ban phai la nhan vien y te hoac linh cuu hoa.");
	if (sscanf(params,"u",id))							return SendHelpMessage(playerid, "/hpc [ID/Ten]");
	if (!IsPlayerLogged(id))								return SendNotConnected(playerid);
	if (VehicleInfo[vehicle][carFaction] != faction)		return SendErrorMessage(playerid, "Ban phai o trong xe to chuc cua ban");

	SendMedicMessage(playerid, "Thong Tin - %s", GetFullDate());
	SendMedicMessage(playerid, "Ten day du: %s, Ngay sinh: %s, Dien thoai: %i.", GetNameEx(id), PlayerInfo[id][pBirthdate], PlayerInfo[id][pNumber]);

	new count;
    for(new i; i < MAX_HOUSES; i++)
	{
	    if (HouseInfo[i][hID] == 0 || HouseInfo[i][hOwnerID] != PlayerInfo[id][pID])	continue;

		SendMedicMessage(playerid, "Dia chi dang ki: %s.", (!HouseInfo[i][hApart])?(GetHouseZone(i)):(GetApartmentZone(HouseInfo[i][hApart])));
		count++;
		if (count > 4) break;
	}

	if (!count) SendMedicMessage(playerid, "Dia chi dang ky khong xac dinh.");

	return 1;
}

CMD:choke(playerid, params[])
{
	new faction = PlayerInfo[playerid][pFaction];

	if (!IsFactionFire(faction))			return SendErrorMessage(playerid, "Ban phai la mot nguoi linh cuu hoa.");
	if (!PlayerInfo[playerid][pOnDuty])	return SendErrorMessage(playerid, "Dau tien ban can phai trong gio lam viec.");
    if (DeleteNearFire(playerid)) 		return SM1(playerid, "Ban da dua lua. ");
	
	SM2(playerid, "Khong co lua gan ban ");
	return 1;
}

CMD:fireshape(playerid, params[])
{
	new faction = PlayerInfo[playerid][pFaction];
	
	if (!IsFactionFire(faction)) 		return SendErrorMessage(playerid,"Ban phai la mot nguoi linh cuu hoa.");
	if (!PlayerInfo[playerid][pOnDuty])	return SendErrorMessage(playerid, "Dau tien ban can phai trong gio lam viec. ");
	if (!PlayerInfo[playerid][pChar])	return SendErrorMessage(playerid, "Ban phai mac dong phuc chinh thuc.");

	if (GetPlayerSkin(playerid) == PlayerInfo[playerid][pChar])
	{
		if (PlayerInfo[playerid][pChar] == 277 || PlayerInfo[playerid][pChar] == 278 
		|| PlayerInfo[playerid][pChar] == 279 || PlayerInfo[playerid][pChar] == 191) return SendErrorMessage(playerid, "Ban da mac dong phuc cuu hoa roi! ");
		Dialog_Show(playerid, MODEL_SELECTION_SHAPE, DIALOG_STYLE_PREVIEW_MODEL, "Lua chon trang phuc", "277\tID: 277\n278\tID: 278\n279\tID: 279\n191\tID: 191", "Chon", "Dong");
	} else {
		SetPlayerSkin(playerid, PlayerInfo[playerid][pChar]);
	}
	return 1;
}
