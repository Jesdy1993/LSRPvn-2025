PP_OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	if (clickedid == PP_Framework[2])
	{
	    new hour, minute, second, str[64];
		gettime(hour, minute, second);
		format(str, sizeof(str), "%02d:%02d", hour, minute);

	    PlayerTextDrawSetString(playerid, PP_Btn[playerid][0], str);
  		pTemp[playerid][pPayphoneNumStr] = EOS;
		
		//PlayerTextDrawHide(playerid, PP_Btn[playerid][0]);
		//PlayerTextDrawShow(playerid, PP_Btn[playerid][0]);
  		return 1;
	}
	if (clickedid == PP_Framework[8])
	{		
		return cancelPayphone(playerid);
	}
	if (clickedid == PP_Framework[7])
	{
	    if (GetCash(playerid) < 2) return SendErrorMessage(playerid, "Ban khong du tien, ban can co $2 trong tay. ");
		if (pTemp[playerid][pCallLine] != INVALID_PLAYER_ID || pTemp[playerid][pEmergency])
	    	return SendCellMessage(playerid, "Ban co mot cuoc goi chua hoan thanh. Go '/hangup' de gac may.");

	    PlayerTextDrawSetString(playerid, PP_Btn[playerid][0], "Goi ..");
		
		cmd::server_ame(playerid, "nem mot dong xu vao dien thoai tra tien.");
		GiveCash(playerid,-2);
		GameTextForPlayer(playerid, "~r~-$2.", 3000, 1);

		CallNumber(playerid, pTemp[playerid][pPayphoneNumStr], 1);
		pTemp[playerid][pPayphoneNumStr] = EOS;
	    return 1;
	}
	return 1;
}

PP_OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
	if(pTemp[playerid][pUsingPayphone])
	{
		new qustr[128];
		for(new i = 1; i < 10; i ++)
		{
			if (playertextid == PP_Btn[playerid][i])
			{
				if (pTemp[playerid][pCallLine] != INVALID_PLAYER_ID || pTemp[playerid][pEmergency])
					return SendCellMessage(playerid, "Ban co mot cuoc goi chua hoan thanh. Go '/hangup' de gac may.");

				if (strlen(pTemp[playerid][pPayphoneNumStr]) >= 8) return 1;
				format(pTemp[playerid][pPayphoneNumStr], 64, "%s%d", pTemp[playerid][pPayphoneNumStr], i);
				format(qustr, sizeof(qustr), "%s", pTemp[playerid][pPayphoneNumStr]);
				PlayerTextDrawSetString(playerid, PP_Btn[playerid][0], qustr);
					
			}
		}
		if (playertextid == PP_Btn[playerid][10])
		{
			if (pTemp[playerid][pCallLine] != INVALID_PLAYER_ID || pTemp[playerid][pEmergency])
				return SendCellMessage(playerid, "Ban co mot cuoc goi chua hoan thanh. Go '/hangup' de gac may.");
			
			if (strlen(pTemp[playerid][pPayphoneNumStr]) >= 8) return 1;
			format(pTemp[playerid][pPayphoneNumStr], 64, "%s0", pTemp[playerid][pPayphoneNumStr]);
			format(qustr, sizeof(qustr), "%s", pTemp[playerid][pPayphoneNumStr]);
			PlayerTextDrawSetString(playerid, PP_Btn[playerid][0], qustr);
				
		}
	}
	return 1;
}	

PP_OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rz)
{
    if (GetPVarInt(playerid, #edit_pp) != 0 && (response == EDIT_RESPONSE_FINAL || response == EDIT_RESPONSE_CANCEL))
	{
		new Float:oldX, Float:oldY, Float:oldZ, Float:oldRotX, Float:oldRotY, Float:oldRotZ;

		GetDynamicObjectPos(objectid, oldX, oldY, oldZ);
		GetDynamicObjectRot(objectid, oldRotX, oldRotY, oldRotZ);
		
	    new id = GetPVarInt(playerid, #edit_pp)-1;
	    
		DeletePVar(playerid, #edit_pp);
	    if (id < 0 || id >= MAX_PAYPHONES || !PayphoneInfo[id][phID]) 	return SendErrorMessage(playerid, "Khong tim thay dien thoai di dong.");
	    if (objectid != PayphoneInfo[id][phObj])						return SendErrorMessage(playerid, "Loi khi chinh sua dien thoai.");

		SetDynamicObjectPos(objectid, x, y, z);
		SetDynamicObjectRot(objectid, 0.0, 0.0, rz);

        GetDynamicObjectPos(objectid, PayphoneInfo[id][phX], PayphoneInfo[id][phY], PayphoneInfo[id][phZ]);
       	PayphoneInfo[id][phRZ] = rz;

		Update_Payphone(id);
        
		new query[128];
		mysql_format(dbHandle, query, sizeof(query), "UPDATE `payphones` SET `x`=%f,`y`=%f,`z`=%f,`rz`=%f WHERE `id`=%i", x, y, z, rz, PayphoneInfo[id][phID]);
		mysql_tquery(dbHandle, query);

		SendAdmMessageToPlayer(playerid, "Vi tri dien thoai [ID: %i] da duoc thay doi.", id);
	}
    return 1;
}
