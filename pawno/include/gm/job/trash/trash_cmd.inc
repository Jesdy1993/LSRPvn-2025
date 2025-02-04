ALTX:pickuptrash("/ptrash");
CMD:pickuptrash(playerid, params[])
{
    if(LockTrash == true) return SendErrorMessage(playerid,"He thong nay dang bi khoa");
    if (PlayerInfo[playerid][pJob] != JOB_TRASHMASTER)	return SendErrorMessage(playerid, "Ban khong phai la Trashmaster."); //����������
	if (IsPlayerInAnyVehicle(playerid))                  return SendErrorMessage(playerid, "Ban khong the su dung lenh nay tren phuong tien giao thong! ");
    if (HasTrash[playerid])                              return SendErrorMessage(playerid, "Ban da co mot tui rac trong tay! ");

	if (!pTemp[playerid][pRentveh])  return SendErrorMessage(playerid, "Dau tien ban phai thue mot chiec xe lam viec! (/rcj)");
    if (!pTemp[playerid][pJob])      return SendErrorMessage(playerid, "Dau tien ban phai thue mot chiec xe lam viec! (/rcj)");
    
    new vehicleid = pTemp[playerid][pRentveh];
    if (!IsTrashMasterCar(vehicleid) || !IsATrashTruck(vehicleid)) return SendErrorMessage(playerid, "Ban da khong den bang mot chiec xe tai cho rac!");

    new id = Trash_Nearest(playerid);
	if (id == -1)                      return SendErrorMessage(playerid, "Khong co thung rac nao ben canh ban! ");
	if (TrashData[id][TrashLevel] < 1) return SendErrorMessage(playerid, "Thung rac trong!");

    new Float: x, Float: y, Float: z;
    GetVehicleBoot(vehicleid, x, y, z);
    if (GetPlayerDistanceFromPoint(playerid, x, y, z) >= 30.0) return SendErrorMessage(playerid, "Khong co xe rac nao gan ban!");

    TrashData[id][TrashLevel]--;
	KillTimer(TrashData[id][TrashTimer]);
    
    TrashData[id][TrashTimer] = SetTimerEx("FillTrash", REFILL_TIME * 1000, false, "i", id);
	
    TrashCP[playerid] = CreateDynamicCP(x, y, z, 3.0, .playerid = playerid);
	HasTrash[playerid] = true;
	
    ApplyAnimation(playerid, "CARRY", "liftup105", 4.1, 0, 0, 0, 0, 0);
	SetPlayerAttachedObject(playerid, ATTACHMENT_INDEX, 1264, 6, 0.222, 0.024, 0.128, 1.90, -90.0, 0.0, 0.5,0.5, 0.5);
	
    Streamer_SetIntData(STREAMER_TYPE_3D_TEXT_LABEL, TrashData[id][TrashLabel], E_STREAMER_COLOR, (TrashData[id][TrashLevel] == 0) ? 0xE74C3CFF : 0xF39C12FF);
	
    InfoMSG(playerid, "Lay ~h~~g~bao rac ~w~va dua no vao thung chua rac.~n~ Ban co the nem bao rac - ~r~~k~~CONVERSATION_NO~.", 5);
	return 1;
}