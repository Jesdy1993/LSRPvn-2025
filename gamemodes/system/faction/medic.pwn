CMD:medics(playerid,params[]) {
	if(!IsAMedic(playerid)) return SendErrorMessage(playerid," Ban khong phai bac si");
	new string[1229],zone[32];
	foreach(new i : Player) {
		if(PlayerInfo[playerid][pInjured] != 0 && GetPVarInt(i,"1EMSAttempt") == 0) {
			GetPlayer3DZone(i,zone,sizeof(zone));
            format(string, sizeof string, "%d\t%s\t%s\n", i,GetPlayerNameEx(i),zone);
		}
	}
	Dialog_Show(playerid, DIALOG_MEDICS, DIALOG_STYLE_TABLIST, "Medic calls", string, "Xac nhan", "Thoat");
	return 1;
}

CMD:medicfind(playerid, params[])
{
	if (IsAMedic(playerid))
	{
	    if(GetPVarType(playerid, "hFind"))
		{
	   		SendClientMessageEx(playerid, COLOR_GRAD2, "(-) Ban dung dung viec tim kiem");
	        DeletePVar(playerid, "hFind");
	        DisablePlayerCheckpoint(playerid);
		}
		else
		{
			new	iTargetID;

			if(sscanf(params, "u", iTargetID)) {
				return SendUsageMessage(playerid, " /hfind [player]");
			}
			else if(iTargetID == playerid) {
				return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the su dung lenh nay cho ban.");
			}

			else if(!IsPlayerConnected(iTargetID)) {
				return SendClientMessageEx(playerid, COLOR_GREY, "Nguoi choi khong hop le.");
			}
			else if(GetPlayerInterior(iTargetID) != 0) {
				return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the su dung lenh nay trong khi dang o trong mot noi that.");
			}
			else if(PlayerInfo[iTargetID][pAdmin] >= 99999)
			{
				return SendClientMessageEx(playerid, COLOR_GREY, "Ban Khong The Tim Kiem Admin");
			}
			else if (GetPVarInt(playerid, "_SwimmingActivity") >= 1)
			{
				return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong the tim thay nguoi nay trong khi dang boi loi.");
			}
			if (GetPVarInt(playerid, "_SwimmingActivity") >= 1)
			{
			SendClientMessageEx(playerid, COLOR_GRAD2, "  Ban phai dung boi! (/stopswimming)");
			return 1;
			}
			new
				szZone[MAX_ZONE_NAME],
				szMessage[108];

			new Float:X, Float:Y, Float:Z;
			GetPlayerPos(iTargetID, X, Y, Z);
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid, X, Y, Z, 4.0);
			GetPlayer3DZone(iTargetID, szZone, sizeof(szZone));
			format(szMessage, sizeof(szMessage), "Theo doi tren %s, nhin thay o %s.", GetPlayerNameEx(iTargetID), szZone);
			SendClientMessageEx(playerid, COLOR_GRAD2, szMessage);
			SetPVarInt(playerid, "hFind", iTargetID);
		}
	}
	else SendErrorMessage(playerid, "Ban khong the su dung lenh nay");
	return 1;
}
Dialog:DIALOG_MEDICS(playerid, response, listitem, inputtext[]) {
	if(response) {
		cmd_getpt(playerid,inputtext);
	}

}