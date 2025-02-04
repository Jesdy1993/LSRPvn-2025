ALTX:payphone("/pp");
CMD:payphone(playerid, params[])
{
    if (PlayerInfo[playerid][pInjured] != 0 || GetPVarInt(playerid, "Freeze") || pTemp[playerid][pTaserTime] || pTemp[playerid][pCuffed])
		return SendErrorMessage(playerid, "Ban khong the su dung tinh nang nay ngay bay gio.");

	new id = -1;
	if ((id = Payphone_Nearest(playerid)) == -1)
	    return SendErrorMessage(playerid, "Khong co dien thoai di dong gan ban. ");
	    
	if (PayphoneInfo[id][phUsed] != INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "Dien thoai di dong nay dang duoc su dung. ");
	    
	if (IsPlayerPhoneCreated(playerid))
	    return SendErrorMessage(playerid, "Ban dang su dung dien thoai di dong. ");
	
	if (pTemp[playerid][pCallLine] != INVALID_PLAYER_ID || pTemp[playerid][pEmergency])
	    return SendErrorMessage(playerid, "Ban co mot cuoc goi chua hoan thanh. Nhap /hangup de gac may. ");

	pTemp[playerid][pPayphone] = id;
	PayphoneInfo[id][phUsed] = playerid;
	pTemp[playerid][pUsingPayphone] = 1;

	new info[128];
	format(info, sizeof(info), "Nhap '~y~/pc~w~' de tra lai ~y~con tro~w~.~n~So dien thoai tra tien:~y~ %i", PayphoneInfo[id][phNumber]);
	InfoMSG(playerid, info, 5);

	SetPlayerFacingAngle(playerid, PayphoneInfo[id][phRZ]); 
	SetCameraBehindPlayer(playerid);
	
	if (PayphoneInfo[id][phState] == PAYPHONE_STATE_RINGING) 
	{
		PayphoneInfo[id][phState] = PAYPHONE_STATE_INCALL;

		new targetid = PayphoneInfo[id][phCaller];

		pTemp[playerid][pCallLine] = targetid;
		pTemp[targetid][pCallLine] = playerid;

		pTemp[playerid][pCallStatus] = 2;
		pTemp[playerid][pCallTime] = 0;

		pTemp[targetid][pCallStatus] = 2;
		pTemp[targetid][pCallTime] = 0;
		
		Update_Payphone(id); //��������

		if (0 == IsPlayerPhoneCreated(targetid))
	    	Phone_Show(targetid, PAGE_CALL);
		else
		{
			ph_showpage(targetid, PAGE_CALL);
		}

		SM2(playerid,"Ban da tra loi cuoc goi.");
		SM2(targetid,"Nguoi dang ky da tra loi cuoc goi.");
	}
	
	PlayerOnPayphone(playerid);
	return 1;
}
