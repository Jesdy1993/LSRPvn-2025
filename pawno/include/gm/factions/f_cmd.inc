CMD:editspawn(playerid,params[])
{
	new factionid = PlayerInfo[playerid][pFaction];

	if (!isLeader(playerid) && !GetSpawnRight(playerid)) return SendErrorMessage(playerid, "Ban khong duoc phep thay doi vi tri cua faction xuat hien.");

    GetPlayerPos(playerid, Factions[factionid][fPosX], Factions[factionid][fPosY], Factions[factionid][fPosZ]);
	Factions[factionid][fSpawnInt] = GetInterior(playerid);
	Factions[factionid][fSpawnVW] = GetWorld(playerid);

    new query[128 + 56];
    mysql_format(dbHandle, query, sizeof(query), "UPDATE `factions` SET `spawnx`=%f, `spawny`=%f, `spawnz`=%f, `spawnint`=%i, `spawnvw`=%i WHERE `id`= %i", Factions[factionid][fPosX], Factions[factionid][fPosY], Factions[factionid][fPosZ], Factions[factionid][fSpawnInt], Factions[factionid][fSpawnVW], Factions[factionid][fID]);
	mysql_tquery(dbHandle, query);

	SendSyntaxMessage(playerid, "Ban da thiet lap to chuc %s xuat hien tai vi tri nay.", Factions[factionid][fName]);
	return 1;
}

CMD:editrankname(playerid, params[])
{
	new faction = PlayerInfo[playerid][pFaction], rank, name[32];

	if (!isLeader(playerid) && !GetRankNameRight(playerid))		return SendErrorMessage(playerid, "Ban khong duoc phep thay doi ten cap bac.");
	if (sscanf(params,"ds[31]", rank, name))					return SendHelpMessage(playerid, "/editrankname [rank] [name]");
	if (strlen(name) > 31)										return SendErrorMessage(playerid, "Ten cap bac khong duoc chua qua 31 ky tu.");
	if (rank < 1 || rank > Factions[faction][fRanks])			return SendErrorMessage(playerid, "Cap bac tu 1 den %i.", Factions[faction][fRanks]);
	
	format(FactionRanks[faction][rank-1], 32, "%s", name);
	UpdateFactionRank(faction, rank);
	SendSyntaxMessage(playerid, "Ban da thay doi ten cua cap bac [ID: %i] thanh '%s'.", rank, name);
	return 1;
}

CMD:fchat(playerid, params[])
{
	if (PlayerInfo[playerid][pFaction] == 0)			return SendErrorMessage(playerid, "Ban phai o trong to chuc.");
    if (!isLeader(playerid) && !GetChatRight(playerid))	return SendErrorMessage(playerid, "Ban khong phai la mot lanh dao to chuc.");

	new faction = PlayerInfo[playerid][pFaction];
	if (Factions[faction][fChatON] == 1)
	{
		SendFactionMessageF(faction, COLOR_LIGHTBLUE, " ** %s da vo hieu hoa tro chuyen to chuc.", GetNameEx(playerid));
		SendSyntaxMessage(playerid, "Ban da tat tro chuyen OOS cua to chuc. Bay gio chi ban co the tro chuyen.");
		Factions[faction][fChatON] = 0;
	}
	else
	{
		SendFactionMessageF(faction, COLOR_LIGHTBLUE, " ** %s da bat tro chuyen to chuc.", GetNameEx(playerid));
		SendSyntaxMessage(playerid, "Ban da bat tro chuyen OOS theo to chuc. Bay gio tat ca cac thanh vien cua to chuc co the tro chuyen. ");
		Factions[faction][fChatON] = 1;
	}
	SQL_SetInteger("factions", "chaton", Factions[faction][fChatON], faction);
	return 1;
}

CMD:invite(playerid, params[])
{
    if (PlayerInfo[playerid][pFaction] == 0)						return SendErrorMessage(playerid, "Ban phai o trong to chuc. ");
    if (!isLeader(playerid) && !GetInviteRight(playerid))			return SendErrorMessage(playerid, "Ban khong co quyen duoc moi vao to chuc.");
    if (Factions[PlayerInfo[playerid][pFaction]][fJoinRank] == 0)	return SendErrorMessage(playerid, "Vui long dat cap bac va muc luong trong he thong cua ban.");

	new userid;

	if (sscanf(params,"u",userid))									return SendHelpMessage(playerid, "/invite [ID/Ten]");
	if (!IsPlayerLogged(userid))									return SendNotConnected(playerid);
	if (userid == playerid)											return SendErrorMessage(playerid, "Ban da o trong mot to chuc.");
    if (PlayerInfo[userid][pFaction] != 0)							return SendErrorMessage(playerid, "Nguoi choi da o trong mot to chuc.");
    if (pTemp[userid][pFactionPlayer] == playerid)					return SendErrorMessage(playerid, "Ban da moi nguoi choi tham gia to chuc.");

	pTemp[userid][pFactionPlayer] = playerid;
	SetPVarInt(userid, #accept_time, gettime() + 30);

	SendSyntaxMessage(userid, "%s da moi ban tham gia to chuc %s (Nhan Y de chap nhan loi de nghi)", GetNameWithMask(playerid), Factions[PlayerInfo[playerid][pFaction]][fName]);
	SendSyntaxMessage(playerid, "Ban da moi %s tham gia to chuc cua minh.", GetNameWithMask(userid));
	return 1;
}

CMD:uninvite(playerid, params[])
{
    if (PlayerInfo[playerid][pFaction] == 0)						return SendErrorMessage(playerid, "Ban phai o trong to chuc.");
    if (!isLeader(playerid) && !GetUninviteRight(playerid))			return SendErrorMessage(playerid, "Ban khong co quyen loai tru khoi tu chuc.");
    if (Factions[PlayerInfo[playerid][pFaction]][fJoinRank] == 0)	return SendErrorMessage(playerid, "Vui long dat cap bac va muc luong trong he thong cua ban. ");

	new userid;

	if (sscanf(params,"u",userid))										return SendHelpMessage(playerid, "/uninvite [ID/Ten]");
	if (!IsPlayerLogged(userid))										return SendNotConnected(playerid);
	if (userid == playerid)												return SendErrorMessage(playerid, "Khong the sa thai chinh ban than.");
    if (PlayerInfo[userid][pFaction] != PlayerInfo[playerid][pFaction])	return SendErrorMessage(playerid, "Nguoi choi khong phai la thanh vien to chuc cua ban.");

	if (!isLeader(playerid) && GetUninviteRight(playerid) && (isLeader(userid) || PlayerInfo[userid][pRank] >= PlayerInfo[playerid][pRank]))
	{
		return SendErrorMessage(playerid, "Ban chi co the sa thai nguoi choi co cap bac thap hon ban.");
	}

	SendSyntaxMessage(userid, "%s da truc xuat ban khoi to chuc %s.", GetNameEx(playerid), Factions[PlayerInfo[playerid][pFaction]][fName]);
	SendSyntaxMessage(playerid, "Ban da truc xuat %s ra khoi to chuc cua ban.", GetNameEx(userid));

    RemovePlayerFaction(userid);
	SendFactionMessageF(PlayerInfo[playerid][pFaction], COLOR_LIGHTBLUE, "[To Chuc] %s da bi sa thai khoi to chuc boi lanh dao %s.", GetNameEx(userid), GetNameEx(playerid));
	return 1;
}

CMD:giverank(playerid, params[])
{
    if (PlayerInfo[playerid][pFaction] == 0)						return SendErrorMessage(playerid, "Ban phai o trong to chuc.");
    if (!isLeader(playerid) && !GetRankRight(playerid))				return SendErrorMessage(playerid, "Ban khong co quyen thay doi cap bac cua cac thanh vien trong to chuc.");
    if (Factions[PlayerInfo[playerid][pFaction]][fJoinRank] == 0)	return SendErrorMessage(playerid, "Vui long thiet lap cac cap bac trong he thong cua ban.");

	new userid, rank;

	if (sscanf(params,"ui",userid, rank))										return SendHelpMessage(playerid, "/giverank [ID/Ten] [rank]");
	if (!IsPlayerLogged(userid))												return SendNotConnected(playerid);
	if (userid == playerid)														return SendErrorMessage(playerid, "Ban khong the thay doi cap bac cua minh.");
    if (PlayerInfo[userid][pFaction] != PlayerInfo[playerid][pFaction])			return SendErrorMessage(playerid, "Nguoi choi khong phai la thanh vien to chuc cua ban.");
	if (rank < 1 || rank > Factions[PlayerInfo[playerid][pFaction]][fRanks])	return SendErrorMessage(playerid, "Cap bac tu 1 den %i.", Factions[PlayerInfo[playerid][pFaction]][fRanks]);
	if (!isLeader(playerid) && GetRankRight(playerid) && (isLeader(userid) || PlayerInfo[userid][pRank] >= PlayerInfo[playerid][pRank]))
	{
		return SendErrorMessage(playerid, "Ban chi co the thay doi cap bac cua nguoi choi co cap bac nho hon ban.");
	}
	if (PlayerInfo[playerid][pRank] < rank) return SendErrorMessage(playerid, "Ban khong the trao cap bac cho nguoi choi cap bac cao hon ban");
			 
	PlayerInfo[userid][pRank] = rank;
	SendSyntaxMessage(userid, "%s da trao cap bac '%s' cho ban.", GetNameEx(playerid), GetRankName(userid));
	SendSyntaxMessage(playerid, "Ban da trao cap bac '%s' cho %s.", GetRankName(userid), GetNameEx(userid));	
	return 1;
}

CMD:ranks(playerid, params[])
{
	new faction = PlayerInfo[playerid][pFaction], mes[1024] = "{FFFFFF}";

	if (!isLeader(playerid) && !GetRankRight(playerid))	return SendErrorMessage(playerid, "Ban khong duoc phep xem cap bac cua to chuc.");

	for(new i = 0; i != Factions[faction][fRanks]; i++)
	{
		format(mes, sizeof(mes), "%s%i. %s\n", mes, i+1, FactionRanks[faction][i]);
	}

	new title[32];
	format(title, sizeof(title), "{FFFFFF}Cap bac to chuc [%i]", Factions[faction][fRanks]);
	Dialog_Show(playerid, None, DIALOG_STYLE_LIST, title, mes, "Dong", "");
	return 1;
}

CMD:editrights(playerid, params[])
{
	if (!PlayerInfo[playerid][pFaction])					return SendErrorMessage(playerid, "Ban khong phai la thanh vien cua to chuc.");
	if (!isLeader(playerid) && !GetRightsRight(playerid)) 	return SendErrorMessage(playerid, "Ban khong duoc phep thay doi quyen cap bac.");

	new faction = PlayerInfo[playerid][pFaction];
	
	new	faction_ranks[1024] = EOS;
	for(new i = 0; i != Factions[faction][fRanks]; i++)
	{
		if (PlayerInfo[playerid][pRank] >= i && !isLeader(playerid))
		{
			format(faction_ranks, sizeof(faction_ranks), "%s%i\t%s\n", faction_ranks, i+1, FactionRanks[faction][i]);
		}
		else if (isLeader(playerid))
		{
			format(faction_ranks, sizeof(faction_ranks), "%s%i\t%s\n", faction_ranks, i+1, FactionRanks[faction][i]);
		}
	}
	Dialog_Show(playerid, FactionSettings, DIALOG_STYLE_TABLIST, "{FFFFFF}Cai dat Cap bac", faction_ranks, ">>>", "Huy bo");
	return 1;
}

CMD:myrights(playerid, params[])
{
	if (!PlayerInfo[playerid][pFaction])	return SendErrorMessage(playerid, "Ban khong phai la thanh vien cua to chuc.");
	return ShowMyRights(playerid);
}

CMD:towcars(playerid, params[])
{
	if (!isLeader(playerid) && !GetTowRight(playerid)) return SendErrorMessage(playerid, "Ban khong duoc phep hoi sinh phuong tien.");

	new faction = PlayerInfo[playerid][pFaction];

    SendFactionMessageF(faction, COLOR_LIGHTRED, "%s %s da hoi sinh tat ca phuong tien khong su dung.", GetRankName(playerid), GetNameEx(playerid));

    new vehicle, occupied[MAX_VEHICLES char];

    foreach(new i : Player)
	{
	    if ((vehicle = GetPlayerVehicleID(i)) == 0 || VehicleInfo[vehicle][carFaction] != faction) continue;

		occupied{vehicle} = 1;
	}

	for(new i; i < MAX_VEHICLES; i++)
	{
		if (occupied{i} == 1 || VehicleInfo[i][carFaction] != faction) continue;

		RespawnVehicle(i);
	}
	return 1;
}

ALTX:flist("/members");
CMD:flist(playerid, params[])
{
	if (PlayerInfo[playerid][pFaction] == 0)	return SendErrorMessage(playerid, "Ban khong phai la thanh vien cua to chuc.");

	new mes[3072] = "{FFFFFF}Ten\t{FFFFFF}ID\t{FFFFFF}Cap bac";

	foreach(new i : Player)
	{
		if (IsPlayerLogged(i) == 0 || PlayerInfo[i][pFaction] != PlayerInfo[playerid][pFaction])	continue;
		format(mes, sizeof(mes), "%s\n%s\t%i\t%s", mes, GetNameEx(i), i, GetRankName(i));	
	}

	Dialog_Show(playerid, None, DIALOG_STYLE_TABLIST_HEADERS, "{FFFFFF}Thanh vien to chuc truc tuyen", mes, "Dong", "");
	return 1;
}

ALTX:departments("/d");
CMD:departments(playerid, params[])
{
    if (PlayerInfo[playerid][pMutedTime] > 0)	return SendErrorMessage(playerid, "Tro chuyen cuc bo cua ban bi he thong chan.");

	new faction[23];

	if (isnull(params))								    return SendHelpMessage(playerid, "(/d)epartments [tin nhan]");
	if (!IsFactionLegal(PlayerInfo[playerid][pFaction])) return SendErrorMessage(playerid, "Nhom nay danh co cac co quan chinh phi.");
    if (!PlayerInfo[playerid][pOnDuty])				    return SendErrorMessage(playerid, "Dau tien ban can phai trong gio lam viec. ");
    if (!IsPlayerHasItem(playerid, INV_RADIO))	  	    return SendErrorMessage(playerid, "Ban khong co bo dam.");

	format(faction, sizeof(faction), "%s", GetInitials(Factions[PlayerInfo[playerid][pFaction]][fName]));

	foreach(new i : Player)
	{
		if(IsFactionLegal(PlayerInfo[i][pFaction]))
		{
			if (strlen(params) > MAXLEN)
			{
				new pos = MAXLEN;

				if (pos < MAXLEN-1) pos = MAXLEN;

				SendClientMessageEx(i, COLOR_ALLDEPT, "** [%s] %s %s: %.*s ...", faction, GetRankName(playerid), GetNameWithMask(playerid), pos, params);
				SendClientMessageEx(i, COLOR_ALLDEPT, "... %s **", params[pos]);
			}
			else
			{
				SendClientMessageEx(i, COLOR_ALLDEPT, "** [%s] %s %s: %s **", faction, GetRankName(playerid), GetNameWithMask(playerid), params);
			}
		}
	}
	return 1;
}
ALTX:factionon("/fon");
CMD:factionon(playerid, params[])
{
	new factionid = PlayerInfo[playerid][pFaction];

 	if (PlayerInfo[playerid][pFaction] == 0)	return SendErrorMessage(playerid, "Ban khong phai la thanh vien cua to chuc.");

	SendClientMessageEx(playerid, COLOR_GRAD1, "Thanh vien %s online:", Factions[PlayerInfo[playerid][pFaction]][fName]);

	foreach (new i : Player) if (PlayerInfo[i][pFaction] == factionid) {
	SendClientMessageEx(playerid, COLOR_GRAD2, "(ID: %i) {%s} %s %s", i, (PlayerInfo[i][pOnDuty]) ? (GetFactionColor(factionid)) : ("BFC0C2"), GetRankName(i), GetName(i));
	}
	return 1;
}


ALTX:faction("/f");
CMD:faction(playerid, params[])
{
	new faction = PlayerInfo[playerid][pFaction];
    
	if (PlayerInfo[playerid][pMutedTime] > 0)						return SendErrorMessage(playerid, "Tro chuyen cuc bo cua ban bi he thong chan.");
	if (isnull(params))												return SendHelpMessage(playerid, "(/f)action [OOC chat]");
	if (PlayerInfo[playerid][pFaction] == 0)						return SendErrorMessage(playerid, "Ban phai o trong to chuc. ");
	if (Factions[faction][fChatON] == 0 && !isLeader(playerid))		return SendErrorMessage(playerid, "Tro truyen to chuc OOC da bi tat.");
	if (PlayerInfo[playerid][pSettings] & togFaction)				return SendErrorMessage(playerid, "Ban da tat hien thi thong bao cua to chuc.");
	
	if (IsFactionLegal(faction))
	{
		if (strlen(params) > MAXLEN)
		{
			new pos = MAXLEN;

			if (pos < MAXLEN-1) pos = MAXLEN;

			SendFactionMessageF(PlayerInfo[playerid][pFaction], COLOR_WHITE, "{%06x}** (( %s %s: %.*s ... )) **", Factions[faction][fColor] >>> 8, GetRankName(playerid), GetNameEx(playerid), pos, params);
			SendFactionMessageF(PlayerInfo[playerid][pFaction], COLOR_WHITE, "{%06x}... %s )) **", Factions[faction][fColor] >>> 8, params[pos]);
		}
		else
		{
			SendFactionMessageF(PlayerInfo[playerid][pFaction], COLOR_WHITE, "{%06x}** (( %s %s: %s )) **", Factions[faction][fColor] >>> 8, GetRankName(playerid), GetNameEx(playerid), params);
		}
	}
	else
	{
		if (strlen(params) > MAXLEN)
		{
			new pos = MAXLEN;

			if (pos < MAXLEN-1) pos = MAXLEN;

			SendFactionMessageF(PlayerInfo[playerid][pFaction], COLOR_WHITE, "{%06x}** (( %s: %.*s ... )) **", Factions[faction][fColor] >>> 8, GetNameEx(playerid), pos, params);
			SendFactionMessageF(PlayerInfo[playerid][pFaction], COLOR_WHITE, "{%06x}... %s )) **", Factions[faction][fColor] >>> 8, params[pos]);
		}
		else
		{
			SendFactionMessageF(PlayerInfo[playerid][pFaction], COLOR_WHITE, "{%06x}** (( %s: %s )) **", Factions[faction][fColor] >>> 8, GetNameEx(playerid), params);
		}
	}
	return 1;
}

ALTX:factionattach("/fa");
CMD:factionattach(playerid, params[])
{
	if (GetNextToySlot(playerid) == -1)	return SendErrorMessage(playerid, "Tat ca cac vi tri quan ao da duoc su dung.");

	
	if (!IsFactionLegal(PlayerInfo[playerid][pFaction])) return 1;

    if (IsPlayerFactionMedic(playerid) || IsPlayerFactionFire(playerid))
	{
		new mes[sizeof(attach_fd_model)*64];
		for(new i = 0; i < sizeof(attach_fd_model); i++)
		{
			format(mes, sizeof(mes), "%s%i(0.0, 0.0, 0.0, 1.0)\t~w~%s\n", mes, attach_fd_model[i], attach_fd_name[i]); 
		}
		Dialog_Show(playerid, MODEL_SELECTION_FA, DIALOG_STYLE_PREVIEW_MODEL, "Phan dinh kem ", mes, "Chon", "Dong");
	}			
    else if (IsPlayerFactionCity(playerid))
	{
		new mes[sizeof(attach_city_model)*64];
		for(new i = 0; i < sizeof(attach_city_model); i++)
		{
			format(mes, sizeof(mes), "%s%i(0.0, 0.0, 0.0, 1.0)\t~w~%s\n", mes, attach_city_model[i], attach_city_name[i]); 
		}
		Dialog_Show(playerid, MODEL_SELECTION_FA, DIALOG_STYLE_PREVIEW_MODEL, "Phan dinh kem ", mes, "Chon", "Dong");
	}
	else if (IsPlayerFactionPolice(playerid))
	{
		new mes[sizeof(attach_police_model)*64];
		for(new i = 0; i < sizeof(attach_police_model); i++)
		{
			format(mes, sizeof(mes), "%s%i(0.0, 0.0, 0.0, 1.0)\t~w~%s\n", mes, attach_police_model[i], attach_police_name[i]); 
		}
		Dialog_Show(playerid, MODEL_SELECTION_FA, DIALOG_STYLE_PREVIEW_MODEL, "Phan dinh kem ", mes, "Chon", "Dong");
	}

	return 1;
}

CMD:changebadges(playerid, params[])
{
	new faction = PlayerInfo[playerid][pFaction];
	if (Factions[faction][fType] == FACTION_MAFIA || Factions[faction][fType] == FACTION_GANG)	return SendErrorMessage(playerid, "Ban phai la lanh dao cua to chuc.");
	if (PlayerInfo[playerid][pRank] < 11)														return SendErrorMessage(playerid, "Co san tu cap bac 11.");

    new userid, badge;
        
    if (sscanf(params, "ui", userid, badge))													return SendHelpMessage(playerid, "/changebadges [ID/Ten] [so]");
    if (!IsPlayerLogged(userid))																return SendNotConnected(playerid);
	if (badge < 1 || badge > 9999999)															return SendErrorMessage(playerid, "So nganh tu 1 den 9999999. ");

	PlayerInfo[userid][pBadgeNumber] = badge;
	SendSyntaxMessage(playerid, "Ban da thay doi nganh to chuc %s [%i].", GetNameEx(userid), badge);
	SendSyntaxMessage(userid, "%s da thay doi nganh to chuc ban [%i].", GetNameEx(playerid), badge);
	return 1;
}

CMD:carfix(playerid,params[])
{
	if (IsPlayerAtCarfix(playerid) == 0) return SendErrorMessage(playerid, "Ban phai o trong nha de xe / to chuc co tru so.");

	new vehicle = GetPlayerVehicleID(playerid);

	if (!vehicle || VehicleInfo[vehicle][carFaction] != PlayerInfo[playerid][pFaction])	return SendErrorMessage(playerid, "Ban khong o trong phuong tien to chuc.");
		
	FixVehicle(vehicle);
	VehicleInfo[vehicle][carFuel] = GetVehicleFuelCapacity(GetVehicleModel(vehicle));
	SendSyntaxMessage(playerid, "Phuong tien da duoc sua chua hoan chinh.");
	return 1;
}

ALTX:bortlist("/bl");
CMD:bortlist(playerid, params[])
{
    new faction = PlayerInfo[playerid][pFaction];

	if (!IsFactionLegal(faction))		return SendErrorMessage(playerid, "Ban phai la canh sat / nhan vien nha tu / nhan vien y te.");
    if (IsPlayerInAnyVehicle(playerid))	return SendErrorMessage(playerid, "Ban khong duoc o trong phuong tien. ");
    if (!PlayerInfo[playerid][pOnDuty])	return SendErrorMessage(playerid, "Dau tien ban phai trong gio lam viec. ");

    new count, str[512] = "- Xoa tat ca cac doi tuong\n";

    for (new i = 0; i != MAX_BORTES; i ++)
	{
		if (BortInfo[playerid][i][bortOn] == 0) continue;

        format(str, sizeof(str), "%s%i: %s\n", str, i+1, BortInfo[playerid][i][bortName]);
        count++;
	}

	if (!count) return SendErrorMessage(playerid, "Ban khong co doi tuong nao duoc tao.");

	Dialog_Show(playerid, BortList, DIALOG_STYLE_LIST, "{FFFFFF}Danh sach doi tuong", str, "Chon", "Huy bo");
	return 1;
}

CMD:bort(playerid, params[])
{
	if (PlayerInfo[playerid][pInjured] != 0 || GetPVarInt(playerid, "Freeze") || pTemp[playerid][pTaserTime] || pTemp[playerid][pCuffed] || PhoneInfo[playerid][current_page] == PAGE_NOTIFICATION || PlayerInfo[playerid][pJailed] != 0)
		return SendErrorMessage(playerid, "Ban khong the su dung tinh nang nay ngay bay gio.");
		
    new faction = PlayerInfo[playerid][pFaction];

	if (!IsFactionLegal(faction))		return SendErrorMessage(playerid, "Ban phai la canh sat / nhan vien nha tu / nhan vien y te.");
    if (IsPlayerInAnyVehicle(playerid))	return SendErrorMessage(playerid, "Ban khong duoc o trong phuong tien.");
    if (!PlayerInfo[playerid][pOnDuty])	return SendErrorMessage(playerid, "Dau tien ban can trong gio lam viec.");

	if (IsFactionMedic(faction) || IsFactionFire(faction))
    {
		new mes[sizeof(bort_list_fd)*128];
		for(new i = 0; i < sizeof(bort_list_fd); i++)
		{
			format(mes, sizeof(mes), "%s%i(0.0, 0.0, 0.0, 1.0)\t%s\n", mes, bort_list_fd[i], bort_names_fd[i]); 
		}
		Dialog_Show(playerid, MODEL_SELECTION_BORT, DIALOG_STYLE_PREVIEW_MODEL, "_", mes, "Chon", "Dong");
	}
	else if (IsFactionCity(faction))
	{
		new mes[sizeof(bort_list_city)*128];
		for(new i = 0; i < sizeof(bort_list_city); i++)
		{
			format(mes, sizeof(mes), "%s%i(0.0, 0.0, 0.0, 1.0)\t%s\n", mes, bort_list_city[i], bort_names_city[i]); 
		}
		Dialog_Show(playerid, MODEL_SELECTION_BORT, DIALOG_STYLE_PREVIEW_MODEL, "_", mes, "Chon", "Dong");
	}
	else
	{
		new mes[sizeof(bort_list)*128];
		for(new i = 0; i < sizeof(bort_list); i++)
		{
			format(mes, sizeof(mes), "%s%i(0.0, 0.0, 0.0, 1.0)\t%s\n", mes, bort_list[i], bort_names[i]); 
		}
		Dialog_Show(playerid, MODEL_SELECTION_BORT, DIALOG_STYLE_PREVIEW_MODEL, "_", mes, "Chon", "Dong");
	}

	return 1;
}

ALTX:megaphone("/m");
CMD:megaphone(playerid, params[])
{
	new faction = PlayerInfo[playerid][pFaction], vehicle = GetPlayerVehicleID(playerid);

    if (!IsFactionLegal(faction))															return SendErrorMessage(playerid, "Ban phai o trong to chuc.");
	if (vehicle == 0 || VehicleInfo[vehicle][carFaction] != PlayerInfo[playerid][pFaction])	return SendErrorMessage(playerid, "Ban phai o trong phuong tien to chuc.");
	if (isnull(params))																		return SendHelpMessage(playerid, "(/m)egaphone [van ban]");

	SendNearbyMessage(Range_VLong, playerid, COLOR_YELLOWG, "[ %s %s:o< %s ]", GetRankName(playerid), GetNameWithMask(playerid), params);
	return 1;
}

CMD:mdc(playerid, params[])
{	
	if (IsPlayerPhoneCreated(playerid))	return SendErrorMessage(playerid, "Thao dien thoai!");

	if (!IsPlayerFactionPolice(playerid) &&
		!IsPlayerFactionMedic(playerid) &&
		!IsPlayerFactionFire(playerid))	return SendErrorMessage(playerid, "Ban phai la canh sat / nhan vien y te.");

	new id = PlayerInfo[playerid][pFaction],
		vehicle = GetPlayerVehicleID(playerid);

	if (VehicleInfo[vehicle][carFaction] != id && 0 == IsPlayerInRangeOfPoint(playerid, 50.0, Factions[id][fPosX], Factions[id][fPosY], Factions[id][fPosZ]))
	{
		return SendErrorMessage(playerid, "Chi co san trong HQ hoac phuong tien. ");
	}

	if (IsPlayerFactionPolice(playerid))
	{
		if (!PlayerInfo[playerid][pOnDuty])	return SendErrorMessage(playerid, "Dau tien ban can trong gio lam viec.");

		if (IsPlayerUseMDC(playerid))
			return MDC_Hide(playerid);

		if (pTemp[playerid][pCCTV])
			return 1; // ������ ���� ��� ������������

		MdcInfo[playerid][mdcPage] = PAGE_NONE;

		MDC_Show(playerid);

		SelectTextDraw(playerid, 255);//-1 //0x6d856eFF //-1061109505
		return 1;
	}

	if (IsPlayerFactionMedic(playerid) || IsPlayerFactionFire(playerid))
	{
		if (!PlayerInfo[playerid][pOnDuty])	return SendErrorMessage(playerid, "Dau tien ban can trong gio lam viec. ");
		
		return Get_Calls(playerid);
	}
	return 1;
}

CMD:showbadge(playerid, params[])
{
	new userid;
	
	if (!PlayerInfo[playerid][pFaction] || !IsFactionLegal(PlayerInfo[playerid][pFaction]))	return SendErrorMessage(playerid, "Ban phai la thanh vien cua co cau quyen luc. ");
	if (sscanf(params, "u", userid))														return SendHelpMessage(playerid, "/showbadge [ID/Ten]");
	if (!IsPlayerLogged(userid))															return SendNotConnected(playerid);
	if (!PlayerNearPlayer(3.0, playerid, userid))											return SendNotNearPlayer(playerid);

	SCM(userid, COLOR_POLICECHAT, "_______________________");
	SendClientMessageEx(userid, COLOR_WHITE, Factions[PlayerInfo[playerid][pFaction]][fName]);
	SendClientMessageEx(userid, COLOR_WHITE, "%s - %s", GetRankName(playerid), GetNameWithMask(playerid));
	SendClientMessageEx(userid, COLOR_WHITE, "Dien thoai: %i", PlayerInfo[playerid][pBadgeNumber]);
	SCM(userid, COLOR_POLICECHAT, "_______________________");

	SendNearbyMessage(Range_Normal, playerid, COLOR_PURPLE, "* %s da cho %s thay ma nganh", GetNameWithMask(playerid), GetNameWithMask(userid));
	return 1;
}

CMD:pull(playerid, params[])
{
	new faction = PlayerInfo[playerid][pFaction], vehicle = GetPlayerVehicleID(playerid), userid, seat;

	if (!IsPlayerFactionPolice(playerid) &&
		!IsPlayerFactionMedic(playerid) &&
		!IsPlayerFactionFire(playerid))						return SendErrorMessage(playerid, "Ban phai la canh sat / nhan vien y te. ");
    if (!vehicle && IsABoat(vehicle) && IsABiker(vehicle))	return SendErrorMessage(playerid, "Ban can phai o trong mot chiec xe. ");

	new maxseat = GetMaxPassengers(GetVehicleModel(vehicle));

	if (sscanf(params,"ud", userid, seat))			return SendHelpMessage(playerid, "/pull [ID/Ten] [ghe (1-%i)]", maxseat);
	if (!IsPlayerLogged(userid))						return SendNotConnected(playerid);
	if (seat > maxseat || seat < 1)					return SendSyntaxMessage(playerid, "Ghe tu 1 den %i.", maxseat);
	if (userid == playerid)							return 1;
	if (!PlayerNearPlayer(10.0, playerid, userid))	return SendNotNearPlayer(playerid);
	if (PlayerInfo[userid][pInjured])				return SendErrorMessage(playerid, "Ban khong the cho nguoi bi thuong. ");
	if (IsPlayerInAnyVehicle(userid))				return SendErrorMessage(playerid,"Nguoi choi dang o trong xe.");
    if (!PutPlayerInVehicle(userid, vehicle, seat))	return SendErrorMessage(playerid, "Khong dua duoc nguoi choi vao xe.");

	if (IsFactionMedic(faction) || IsFactionFire(faction))
	{
		StopPlayerAnims(userid);
		SendSyntaxMessage(playerid, "Ban da dua %s vao chiec xe.", GetNameEx(userid));
		SendSyntaxMessage(userid, "%s da dua ban vaao chiec xe.", GetNameEx(playerid));
	}
	else
	{
	    SendSyntaxMessage(playerid, "Ban da keo %s vao chiec xe.", GetNameEx(userid));
		SendSyntaxMessage(userid, "%s da keo ban vao chiec xe.", GetNameEx(playerid));
	}
	return 1;
}

/*
CMD:pullout(playerid, params[])
{
	//new faction = PlayerInfo[playerid][pFaction], vehicle = GetPlayerVehicleID(playerid), userid, seat;
	//if (faction != LSPD && faction != SASD && faction != LSFD)	return SendErrorMessage(playerid, "�� ������ ���� �����������/�����������.");

	new userid;

	if (sscanf(params,"u", userid))					return SendHelpMessage(playerid, "/pullout [ID/Ten]");
	if (!IsPlayerLogged(userid))						return SendNotConnected(playerid);
	if (userid == playerid)							return 1;
	if (!PlayerNearPlayer(10.0, playerid, userid))	return SendNotNearPlayer(playerid);
	if (!IsPlayerInAnyVehicle(userid))				return SendErrorMessage(playerid, "����� �� ��������� � ����������.");
	if (PlayerInfo[userid][pInjured] == 0 &&
		pTemp[userid][pTaserTime] == 0)				return SendErrorMessage(playerid, "����� �� �����/�����/�����������.");
	
	new vehid = GetPlayerVehicleID(userid);
	if (VehicleInfo[vehid][carLock] != 0)			return SendErrorMessage(playerid, "�� �������. ����������� /ram !");

	new mes[128];
	format(mes, sizeof(mes), "������� %s �� ����������.", GetNameWithMask(userid));
	cmd::me(playerid, mes);
	
	SavePlayerPos(playerid);

	SetPlayerPosEx(userid, PlayerInfo[playerid][pPosX],PlayerInfo[playerid][pPosY],PlayerInfo[playerid][pPosZ]);
	SavePlayerPos(userid);

	ApplyAnimation(userid, "PED", "KO_SHOT_STOM", 4.0, 1, 0, 0, 0, 0, 1);

	UnFreezePlayer(userid);
	return 1;
}*/