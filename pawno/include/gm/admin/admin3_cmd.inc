CMD:afaction(playerid, params[])
{
	new option[16], secoption[128];

	if (!CheckAdmin(playerid, ADMIN_LEVEL_3)) return SendNotAdmin(playerid);

	if (sscanf(params, "s[16]S()[128]", option, secoption))
	{
		SendHelpMessage(playerid, "/afaction [create / remove / edit / list / leader]");
		return 1;
	}

	if (CompareStrings(option, "create"))
	{
		new factionid = -1, name[32], shortname[8], type;

		if (sscanf(secoption, "is[8]S()[32]", type, shortname, name))
		{
			SendHelpMessage(playerid, "/afaction create [Loai] [shortname] [name]");
			SendHelpMessage(playerid, "Types: [1] Government [2] Police | [3] Medics | [4] Firefighters | [5] DOCS | [6] NEWS | [7] GANG | [8] MAFIA | [9] CIVIL [10] Mechanic");
			return 1;
		}

		for(new i = 1; i < MAX_FACTIONS; i++)
		{
			if (Factions[i][fON] != 0) continue;

			factionid = i;
			break;
		}

		if (factionid == -1) 						return SendErrorMessage(playerid, "Da dat den toi da so luong Faction duoc tao.");
		if (strlen(name) < 1 || strlen(name) > 30)	return SendErrorMessage(playerid, "Ten faction khong qua 30 ky tu.");
		if (type < 1 || type > 10)					return SendErrorMessage(playerid, "Loai faction chi tu 1 den 10.");

		format(Factions[factionid][fName], 32, "%s", name);
		format(Factions[factionid][fShortName], 8, "%s", shortname);
		Factions[factionid][fColor] = 0xFFFFFF00;
		Factions[factionid][fType] = type;
		Factions[factionid][fRanks] = 5;
		Factions[factionid][fChatON] = 1;
		Factions[factionid][fON] = 1;
		Factions[factionid][fJoinRank] = 1;
		Factions[factionid][fPointTime] = 604800 + gettime();

		if (type == FACTION_MAFIA)	Factions[factionid][fPoint] = 50;
		else 						Factions[factionid][fPoint] = 30;

		for(new i; i != 20; i++)
		{
			FactionRanks[factionid][i] = "None";
		}

		AddFactionToFile(factionid, shortname, name, Factions[factionid][fColor], type, 5, Factions[factionid][fPointTime]);
		SendAdmMessage("Administrator %s da tao faction %s [ID: %i].", GetAccName(playerid), name, factionid);
		SendHelpMessage(playerid, "Nhap '/afaction edit' de chinh sua.");

		return 1;
	}

	else if (CompareStrings(option, "remove"))
	{
		new id;

		if (sscanf(secoption, "i", id))							 return SendHelpMessage(playerid, "/afaction remove [ID factions]");
		if (id < 1 || id > MAX_FACTIONS-1 || !Factions[id][fON]) return SendErrorMessage(playerid, "ID faction khong tim thay.");
		//if (IsFactionLegal(id))									return SendErrorMessage(playerid, "������ ������� ���������� �������.");

		if (IsValidDynamicPickup(Factions[id][fPickUp])) DestroyDynamicPickup(Factions[id][fPickUp]);

		new query[256];

		mysql_format(dbHandle, query, sizeof(query), "DELETE FROM `factions` WHERE `id` = %i", Factions[id][fID]);
		mysql_tquery(dbHandle, query);
		mysql_format(dbHandle, query, sizeof(query), "UPDATE `users` SET `char`='0',`swat`='0',`swat_duty`='0',`duty`='0',`faction`='0',`rank`='0',`sidejob`='0',`spawntype`=0,`spawnpoint`=1 WHERE `faction`=%i", id);
		mysql_tquery(dbHandle, query);

		foreach(new i : Player)
		{
			if (!IsPlayerLogged(i) || PlayerInfo[i][pFaction] != id) continue;

			RemovePlayerFaction(i);
		}

		SendAdmMessageToPlayer(playerid, "Ban da thanh cong xoa faction %s [ID: %i].", Factions[id][fName], id);
		Factions[id][fON] = 0;
		Factions[id][fID] = 0;
	}

	else if (CompareStrings(option, "edit"))
	{
		new id, parameters[12], arg[36];

		if (sscanf(secoption, "is[12]S()[36]", id, parameters, arg))
		{
			SendHelpMessage(playerid, "/afaction edit [ID factions] [options] [value]");
			SendSyntaxMessage(playerid, "spawn / color / name / ranks / joinrank / rankname / type / locker / carfix");
			return 1;
		}
		if (id < 1 || id > MAX_FACTIONS-1 || !Factions[id][fON]) return SendErrorMessage(playerid, "ID faction khong tim thay.");

		if (CompareStrings(parameters, "spawn"))
		{
			GetPlayerPos(playerid, Factions[id][fPosX], Factions[id][fPosY], Factions[id][fPosZ]);
			Factions[id][fSpawnInt] = GetInterior(playerid);
			Factions[id][fSpawnVW] = GetWorld(playerid);

			new query[128 + 56];

			mysql_format(dbHandle, query, sizeof(query), "UPDATE `factions` SET `spawnx` = %f, `spawny` = %f, `spawnz` = %f, `spawnint` = %i, `spawnvw` = %i WHERE `id` = %i",
			Factions[id][fPosX], Factions[id][fPosY], Factions[id][fPosZ], Factions[id][fSpawnInt], Factions[id][fSpawnVW], Factions[id][fID]);
			mysql_tquery(dbHandle, query);
			
			SendAdmMessageToPlayer(playerid, "Ban da cai dat faction %s [ID: %i] vi tri spawn o day.", Factions[id][fName], id);
			return 1;
		}

		else if (CompareStrings(parameters, "color"))
		{
			new color;
			if (sscanf(arg, "h", color)) return SendHelpMessage(playerid, "/afaction edit [ID factions] color [HEX Color]");

			Factions[id][fColor] = color;
			SQL_SetInteger("factions", "color", Factions[id][fColor], Factions[id][fID]);
			SendAdmMessageToPlayer(playerid, "Ban da chinh sua thanh cong HEXCOLOR cho faction {%06x}%s{FF6347} [ID: %i].", color >>> 8, Factions[id][fName], Factions[id][fID]);
			return 1;
		}

		else if (CompareStrings(parameters, "name"))
		{			
			new factioname[32], shortname[8];

			if (sscanf(arg, "s[8]S()[32]", shortname, factioname)) 	return SendHelpMessage(playerid, "/afaction edit [ID factions] name [new reduction] [new name]");
			if (isnull(factioname) || strlen(factioname) > 32) 		return SendErrorMessage(playerid, "Ten faction khong qua 32 ky tu.");

			SendAdmMessageToPlayer(playerid, "Ban da thay doi ten faction %s [ID: %i] thanh %s [%s].", Factions[id][fName], id, factioname, shortname);
			
			format(Factions[id][fName], 32, "%s", factioname);
			format(Factions[id][fShortName], 8, "%s", shortname);

			SQL_SetString("factions", "name", Factions[id][fName], Factions[id][fID]);
			SQL_SetString("factions", "shortname", Factions[id][fShortName], Factions[id][fID]);
			return 1;
		}

		else if (CompareStrings(parameters, "ranks"))
		{
			if (isnull(arg))							return SendHelpMessage(playerid, "/afaction edit [ID factions] ranks [number of ranks]");
			if (strval(arg) < 1 || strval(arg) > 20)	return SendErrorMessage(playerid, "So luong rank chi 1 den 20.");

			Factions[id][fRanks] = strval(arg);
			SQL_SetInteger("factions", "ranks", Factions[id][fRanks], Factions[id][fID]);
			SendAdmMessageToPlayer(playerid, "Ban da chinh sua so rank cua faction %s [ID: %i] thanh %i.", Factions[id][fName], id, strval(arg));
			return 1;
		}

		else if (CompareStrings(parameters, "type"))
		{
			if (isnull(arg))
			{
				return SendHelpMessage(playerid, "/afaction edit [ID factions] type [type factions]");	 
			}
			if (strval(arg) < 1 || strval(arg) > 10)	return SendSyntaxMessage(playerid, "Types: [1] Government [2] Police | [3] Medics | [4] Firefighters | [5] DOCS | [6] NEWS | [7] GANG | [8] MAFIA | [9] CIVIL | [10] MECH");	

			new type_fr[10][40] = {"GOV", "POLICE", "MEDIC", "FIRE", "DOCS", "NEWS", "GANG", "MAFIA", "CIVIL", "MECH"};

			Factions[id][fType] = strval(arg);
			SQL_SetInteger("factions", "type", Factions[id][fType], Factions[id][fID]);
			SendAdmMessageToPlayer(playerid, "Ban da chinh sua loai cua faction %s [ID: %i] thanh %s [%i].", Factions[id][fName], id, type_fr[strval(arg)-1], strval(arg));

			if (IsFactionLegal(id))
			{
				Factions[id][fPickUp] = CreateDynamicPickup(1239, 1, Factions[id][fUniformX], Factions[id][fUniformY], Factions[id][fUniformZ], Factions[id][fUniformVW], Factions[id][fUniformInt], -1, 100.0);
			}
			else
			{
				if (IsValidDynamicPickup(Factions[id][fPickUp])) DestroyDynamicPickup(Factions[id][fPickUp]);
			}
			return 1;
		}

		else if (CompareStrings(parameters, "joinrank"))
		{
			if (isnull(arg))												return SendHelpMessage(playerid, "/afaction edit [ID factions] joinrank [rank at admission]");
			if (strval(arg) < 1 || strval(arg) > Factions[id][fRanks]-1)	return SendErrorMessage(playerid, "Rank tu 1 den %i.", Factions[id][fRanks]-1);

			Factions[id][fJoinRank] = strval(arg);
			SQL_SetInteger("factions", "joinrank", Factions[id][fJoinRank], Factions[id][fID]);
			SendAdmMessageToPlayer(playerid, "Ban da nang cap gioi han rank cua faction %s [ID: %i] len %i.", Factions[id][fName], id, strval(arg));
			return 1;
		}

		else if (CompareStrings(parameters, "locker"))
		{
			if (!IsFactionLegal(id)) return SendErrorMessage(playerid, "Phan nay khong duoc ho tro cho faction bat hop phap.");

			GetPlayerPos(playerid, Factions[id][fUniformX], Factions[id][fUniformY], Factions[id][fUniformZ]);
			Factions[id][fUniformInt] = GetInterior(playerid);
			Factions[id][fUniformVW] = GetWorld(playerid);
			SQL_SetFloat("factions", "uniform_x", Factions[id][fUniformX], Factions[id][fID]);
			SQL_SetFloat("factions", "uniform_y", Factions[id][fUniformY], Factions[id][fID]);
			SQL_SetFloat("factions", "uniform_z", Factions[id][fUniformZ], Factions[id][fID]);
			SQL_SetInteger("factions", "uniform_int", Factions[id][fUniformInt], Factions[id][fID]);
			SQL_SetInteger("factions", "uniform_vw", Factions[id][fUniformVW], Factions[id][fID]);

			if (IsValidDynamicPickup(Factions[id][fPickUp]))	DestroyDynamicPickup(Factions[id][fPickUp]);
			Factions[id][fPickUp] = CreateDynamicPickup(1239, 1, Factions[id][fUniformX], Factions[id][fUniformY], Factions[id][fUniformZ], Factions[id][fUniformVW], Factions[id][fUniformInt], -1, 100.0);
			SendAdmMessageToPlayer(playerid, "Ban da thay doi vi tri trang phuc cua faction %s [ID: %i].", Factions[id][fName], id);
			return 1;
		}
		else if (CompareStrings(parameters, "carfix"))
		{
			if (!IsFactionLegal(id)) return SendErrorMessage(playerid, "Phan nay khong duoc ho tro cho faction bat hop phap.");

			GetPlayerPos(playerid, Factions[id][Carfix][fixX], Factions[id][Carfix][fixY], Factions[id][Carfix][fixZ]);
			Factions[id][Carfix][fixInt] = GetInterior(playerid);
			Factions[id][Carfix][fixVW] = GetWorld(playerid);

			SQL_SetFloat("factions", "fix_X", Factions[id][Carfix][fixX], Factions[id][fID]);
			SQL_SetFloat("factions", "fix_Y", Factions[id][Carfix][fixY], Factions[id][fID]);
			SQL_SetFloat("factions", "fix_Z", Factions[id][Carfix][fixZ], Factions[id][fID]);
			SQL_SetInteger("factions", "fix_Int", Factions[id][Carfix][fixInt], Factions[id][fID]);
			SQL_SetInteger("factions", "fix_VW", Factions[id][Carfix][fixVW], Factions[id][fID]);

			if (IsValidDynamicPickup(Factions[id][Carfix][fixPickUp])) DestroyDynamicPickup(Factions[id][Carfix][fixPickUp]);

			Factions[id][Carfix][fixPickUp] = CreateDynamicPickup(1650, 1, Factions[id][Carfix][fixX], Factions[id][Carfix][fixY], Factions[id][Carfix][fixZ], Factions[id][Carfix][fixVW], Factions[id][Carfix][fixInt], -1, 20.0);
			SendAdmMessageToPlayer(playerid, "Ban da thay doi vi tri CARFIX cua faction %s [ID: %i].", Factions[id][fName], id);
			return 1;
		}

		else if (CompareStrings(parameters, "rankname"))
		{
			new rank, name[32];

			if (sscanf(arg, "is[32]", rank, name)) 			return SendHelpMessage(playerid, "/afaction edit [ID factions] rankname [rank] [name]");
			if (rank < 1 || rank > Factions[id][fRanks])	return SendSyntaxMessage(playerid, "Rank tu 1 den %i.", Factions[id][fRanks]);
			if (strlen(name) > 30)							return SendSyntaxMessage(playerid, "Ten rank khong qua 30 ky tu.");

			format(FactionRanks[id][rank-1], 32, "%s", name);
			UpdateFactionRank(id, rank);
			SendAdmMessageToPlayer(playerid, "Ban da thay doi rank cua facition %s [ID: %i] rank %i thanh %s.", Factions[id][fName], id, rank, name);
			return 1;
		}

		else 
		{
			SendHelpMessage(playerid, "/afaction edit [ID factions] [spawn/color/name/ranks/joinrank/rankname/type/uniform/carfix] [value]");
			return 1;
		}
	}
	else if (CompareStrings(option, "list"))
	{
		new faction_type[10][32] = {"GOV", "POLICE", "MEDIC", "FIRE", "DOCS", "NEWS", "GANG", "MAFIA", "CIVIL", "MECH"}, 
			faction_body[(30)+(2+2+2+32+3+8+2+(10))*MAX_FACTIONS] = "ID\tTen [Reduction]\tLoai",
			count;
	
		for(new i = 1; i != MAX_FACTIONS; i++)
		{
		    if (!Factions[i][fON]) continue;
			format(faction_body, sizeof(faction_body), "%s\n%i\t%s [%s]\t%s", faction_body, i, Factions[i][fName], Factions[i][fShortName], faction_type[Factions[i][fType]-1]); 
			count++;
		}

		if (!count)	return Dialog_Show(playerid, None, DIALOG_STYLE_LIST, "{FFFFFF}List of factions", "...", "Dong", "");
		
		Dialog_Show(playerid, None, DIALOG_STYLE_TABLIST_HEADERS, "{FFFFFF}List of factions", faction_body, "Dong", "");
		return 1;
	}
	else if (CompareStrings(option, "leader"))
	{
		new paramx[8], idx[64];

		if (sscanf(secoption, "s[8]S()[64]", paramx, idx))
		{
			SendHelpMessage(playerid, "/afaction leader [set / remove]");
			return 1;
		}

		if (CompareStrings(paramx, "set"))
		{
			new userid, faction;

			if (sscanf(idx, "iu", faction, userid)) 									return SendHelpMessage(playerid, "/afaction leader set [ID factions] [ID/Ten]");
			if (!IsPlayerLogged(userid))												return SendNotConnected(playerid);
			if (faction < 1 || faction > MAX_FACTIONS - 1 || !Factions[faction][fON])	return SendErrorMessage(playerid, "ID faction khong tim thay");

			RemovePlayerFaction(userid);

			PlayerInfo[userid][pFaction] = faction;
			SQL_SetInteger("users", "faction", PlayerInfo[userid][pFaction], PlayerInfo[userid][pID]);

			PlayerInfo[userid][pRank] = Factions[faction][fRanks];
			SQL_SetInteger("users", "rank", PlayerInfo[userid][pRank], PlayerInfo[userid][pID]);

			PlayerInfo[userid][pBadgeNumber] = randomEx(23456, 99999);
			SQL_SetInteger("users", "badgenumber", PlayerInfo[userid][pBadgeNumber], PlayerInfo[userid][pID]);

			SendAdmMessageToPlayer(playerid, "Ban da uy quyen %s lam leader cho faction %s [ID: %i].", GetNameEx(userid), Factions[faction][fName], faction);
			SendAdmMessageToPlayer(userid, "Administrator %s da uy quyen cho ban lam leader faction %s [ID: %i].", GetAccName(playerid), Factions[faction][fName], faction);
			SendAdmMessage("%s uy quyen %s lam leader faction %s [ID: %i].", GetAccName(playerid), GetNameEx(userid), Factions[faction][fName], faction);
			return 1;

		}

		else if (CompareStrings(paramx, "remove"))
		{
			new userid;

			if (sscanf(idx, "u", userid))	return SendHelpMessage(playerid, "/afaction leader remove [ID/Ten]");
			if (!IsPlayerLogged(userid))	return SendNotConnected(playerid);
			if (!isLeader(userid))			return SendErrorMessage(playerid, "Nguoi choi khong phai Leader.");

			new faction = PlayerInfo[userid][pFaction];

			SendAdmMessageToPlayer(playerid, "Ban da xoa leader faction cua %s tu %s [ID: %i].", GetNameEx(userid), Factions[faction][fName], faction);
			SendAdmMessageToPlayer(userid, "%s da xoa leader faction cua ban %s faction [ID: %i].", GetAccName(playerid), Factions[faction][fName], faction);
			SendAdmMessage("%s da xoa leader faction cua %s [ID: %i] tu %s.", GetAccName(playerid), GetNameEx(userid), Factions[faction][fName], faction);
			
			RemovePlayerFaction(userid);
			return 1;	
		}

		else 
		{
			SendHelpMessage(playerid, "/afaction leader [set / remove]");
			return 1;
		}
	}

	else 
	{
		SendHelpMessage(playerid, "/afaction [create / remove / edit / list / leader]");
	}
	return 1;
}

CMD:avehicle(playerid, params[])
{
	if (!CheckAdmin(playerid, ADMIN_LEVEL_3)) return SendNotAdmin(playerid);

	new option[16], secoption[128];
	
	if (sscanf(params, "s[16]S()[128]", option, secoption)) return SendHelpMessage(playerid, "/avehicle [create / remove / park / types]");

	if (CompareStrings(option, "create"))
	{
		new model, type, faction, plate[24], color1, color2, Float:x, Float:y, Float:z, Float:a, vw, interior;

		if (sscanf(secoption, "iiiiI(0)S()[24]", model, type, color1, color2, faction, plate)) {
			return SendHelpMessage(playerid, "/avehicle create [model] [Loai(0 - cho faction)] [color 1] [color 2] {c7c7c7}[Faction] [plates]");
		}
		
		if (model < 400 || model > 611) 													return SendErrorMessage(playerid, "Model 400 den 611.");
		if (color1 > 255 || color1 < 0 || color2 > 255 || color2 < 0)						return SendErrorMessage(playerid, "Colors tu 0 den 255.");
		if (model == 520 || model == 425 || model == 432 || model == 447 || model == 476)	return SendErrorMessage(playerid, "Phuong tien nay bi cam tren may chu.");

		if (isempty(plate)) format(plate, 24, "%s", GetVehicleNumber());

		GetXYInFrontOfPlayer(playerid, x, y, z, 5.0);
		GetPlayerFacingAngle(playerid, a);
		vw = GetWorld(playerid);
		interior = GetInterior(playerid);

		if (!CreateFactionVehicle(true, model, x, y, z, a, color1, color2, type, faction, plate, vw, interior)) return SendErrorMessage(playerid, "Phuong tien khong duoc tao ra.");
		SendAdmMessageToPlayer(playerid, "Da tao phuong tien [model %i] [plates %s] [type %i] [Faction %i] [vw %i] [int %i].", model, plate, type, faction, vw, interior);
	}

	else if (CompareStrings(option, "remove"))
	{
		new vehid;

		if (sscanf(secoption, "i", vehid))		 return SendHelpMessage(playerid, "/avehicle remove [Vehicle ID]");
    	if (!IsValidVehicle(vehid))				 return SendErrorMessage(playerid, "ID phuong tien khong tim thay.");
		if (VehicleInfo[vehid][carOwnerID] != 0) return SendErrorMessage(playerid, "Phuong tien nay ko the xoa.");

	    if (VehicleInfo[vehid][carAdmin] == 0)
		{
        	new query[128];
	    	mysql_format(dbHandle, query, sizeof(query), "DELETE FROM `cars` WHERE `id` = %i", VehicleInfo[vehid][carID]);
			mysql_tquery(dbHandle, query);
		}

		DestroyVehicle(vehid);
	}

	else if (CompareStrings(option, "park"))
	{
		new vehid;
		
		if (sscanf(secoption, "i", vehid))		return SendHelpMessage(playerid, "/avehicle park [Vehicle ID]");
		if (!IsValidVehicle(vehid))				return SendErrorMessage(playerid, "ID Phuong tien khong tim thay.");
		if (VehicleInfo[vehid][carOwnerID])		return SendErrorMessage(playerid, "Phuong tien nay ko the dau.");

		GetVehiclePos(vehid, VehicleInfo[vehid][carParkX], VehicleInfo[vehid][carParkY], VehicleInfo[vehid][carParkZ]);
		GetVehicleZAngle(vehid, VehicleInfo[vehid][carParkA]);

		SQL_SetFloat("cars", "x", VehicleInfo[vehid][carParkX], VehicleInfo[vehid][carID]);
		SQL_SetFloat("cars", "y", VehicleInfo[vehid][carParkY], VehicleInfo[vehid][carID]);
		SQL_SetFloat("cars", "z", VehicleInfo[vehid][carParkZ], VehicleInfo[vehid][carID]);
		SQL_SetFloat("cars", "fa", VehicleInfo[vehid][carParkA], VehicleInfo[vehid][carID]);

		new vehicle = CreateFactionVehicle(false, VehicleInfo[vehid][carModel], VehicleInfo[vehid][carParkX], VehicleInfo[vehid][carParkY], VehicleInfo[vehid][carParkZ], VehicleInfo[vehid][carParkA], VehicleInfo[vehid][carColor1],
		VehicleInfo[vehid][carColor2], VehicleInfo[vehid][carType], VehicleInfo[vehid][carFaction], VehicleInfo[vehid][carPlate], VehicleInfo[vehid][carVW], VehicleInfo[vehid][carInt], VehicleInfo[vehid][carID]);

		if (!vehicle) return SendErrorMessage(playerid, "Phuong tien chua duoc tao ra.");

		DestroyVehicle(vehid);
		SendAdmMessageToPlayer(playerid, "Phuong tien [ID: %i | NID: %i] da duoc dau va se spawn o vi tri nay.", vehid, vehicle);
	}

	else if (CompareStrings(option, "types"))
	{
		new dialog_header[64] = "{FFFFFF}Loai\t{FFFFFF}Ten\n", dialog_body[256];
		dialog_body[0] = EOS;

		format(dialog_body, sizeof(dialog_body), "%s0\tThong thuong\n1\tDMV car\n2\tDMV helicopter\n3\tVoi siren\n4\tDMV taxi\n5\tRent\n6\tPizzaboy\n7\tTaxi drivers\n8\tTruckers\n9\tMechanics\n10\tLumberJack\n11\tTrashmaster\n12\tMiner", dialog_header);
		Dialog_Show(playerid, None, DIALOG_STYLE_TABLIST_HEADERS, "{FFFFFF}Vehicle types", dialog_body, "Dong", "");
	}
	
	else return SendHelpMessage(playerid, "/avehicle [create / remove / park / types]");
	return 1;
}

ALTX:apayphone("/app");
CMD:apayphone(playerid, params[])
{
	if (!CheckAdmin(playerid, ADMIN_LEVEL_3))	return SendNotAdmin(playerid);

	new option[16], secoption[128];
	
	if (sscanf(params, "s[16]S()[128]", option, secoption)) return SendHelpMessage(playerid, "/apayphone [create / remove / edit / goto]");

	if (CompareStrings(option, "create"))
	{
		new number, type;
		if (sscanf(secoption,"iI(0)", number, type)) return SendHelpMessage(playerid, "/apayphone create [number] {c7c7c7}[ID model]");
		
		if (!type) type = 1216;

		new Float:x, Float:y, Float:z, Float:a, vw, interior;
		GetXYInFrontOfPlayer(playerid, x, y, z, 2.0);
		GetPlayerFacingAngle(playerid, a);
		vw = GetWorld(playerid);
		interior = GetInterior(playerid);
		
		new id;
		if ((id = CreatePayphone(true, type, number, x, y, z, 0.0, 0.0, 0.0, vw, interior)) == -1) return SendErrorMessage(playerid, "Da dat den toi da so luong payphone co the tao.");

		SetPVarInt(playerid, #edit_pp, id + 1);
		EditDynamicObject(playerid, PayphoneInfo[id][phObj]);

		SendAdmMessageToPlayer(playerid, "Ban da tao payphone: %i [ID: %i].", number, id);
		return 1;
	}

	else if (CompareStrings(option, "remove"))
	{
		new id;
		
		if (sscanf(secoption, "i", id))									return SendHelpMessage(playerid, "/apayphone remove [ID Payphone]");
		if (id < 0 || id >= MAX_PAYPHONES || !PayphoneInfo[id][phID])	return SendErrorMessage(playerid, "ID Payph ko tim thay.");

		if (IsValidDynamicObject(PayphoneInfo[id][phObj])) 			DestroyDynamicObject(PayphoneInfo[id][phObj]);
		if (IsValidDynamic3DTextLabel(PayphoneInfo[id][phLabel])) 	DestroyDynamic3DTextLabel(PayphoneInfo[id][phLabel]);

		new query[128];
		mysql_format(dbHandle, query, sizeof(query), "DELETE FROM `payphones` WHERE `id` = %i", PayphoneInfo[id][phID]);
		mysql_tquery(dbHandle, query);

		PayphoneInfo[id][phID] = 0;
		SendAdmMessageToPlayer(playerid, "Ban da xoa payphone [ID: %i].", id);
		return 1;
	}

	else if (CompareStrings(option, "edit"))
	{
		new id;

		if (sscanf(secoption, "d", id))								 return SendHelpMessage(playerid, "/apayphone edit [ID Payphone]");
		if (id < 0 || id > MAX_PAYPHONES || !PayphoneInfo[id][phID]) return SendErrorMessage(playerid, "ID Payph ko tim thay.");
		if (Payphone_Nearest(playerid) != id)						 return SendErrorMessage(playerid, "Ban can dung gan payphone");

		SetPVarInt(playerid, #edit_pp, id + 1);
		EditDynamicObject(playerid, PayphoneInfo[id][phObj]);
		return 1;
	}

	else if (CompareStrings(option, "goto"))
	{
		new id;

		if (sscanf(secoption, "i", id))								return SendHelpMessage(playerid, "/apayphone goto [ID Payphone]");
		if (id < 0 || id > MAX_PAYPHONES || !PayphoneInfo[id][phID])	return SendErrorMessage(playerid, "ID Payph ko tim thay.");

		SetPlayerPosEx(playerid, PayphoneInfo[id][phX], PayphoneInfo[id][phY], PayphoneInfo[id][phZ]);
		SetWorld(playerid, PayphoneInfo[id][phVW]);
		SetInterior(playerid, PayphoneInfo[id][phInt]);
		return 1;
	}
	
	else
	{
		SendHelpMessage(playerid, "/apayphone [create / remove / edit / goto]");
	}
	return 1;
}

ALTX:aparkmeter("/aparkm");
CMD:aparkmeter(playerid, params[])
{
	if (!CheckAdmin(playerid, ADMIN_LEVEL_3))	return SendNotAdmin(playerid);

	new option[16], secoption[128];
	
	if (sscanf(params, "s[16]S()[128]", option, secoption)) return SendHelpMessage(playerid, "/aparkm [create / remove / edit / goto]");

	if (CompareStrings(option, "create"))
	{
		if (ParkMeter_Nearest(playerid) != -1) return SendErrorMessage(playerid, "Qua gan de cai dat park meter.");

		new Float:x, Float:y, Float:z, Float:a;
		GetXYInFrontOfPlayer(playerid, x, y, z, 2.0);
		GetPlayerFacingAngle(playerid, a);

    	new id;
		if ((id = InsertParkMeters(playerid, x, y, z, a)) == -1) return SendErrorMessage(playerid, "Da dat den so luong toi da ma park meter ("#MAX_METERS") duoc tao.");	

		SetPVarInt(playerid, #edit_pm, id);
		EditDynamicObject(playerid, pMeter[id][parkObject]);
		
		SendAdmMessageToPlayer(playerid, "Ban da tao parking meter [ID: %i].", id);
		return 1;
	}

	else if (CompareStrings(option, "remove"))
	{
		new id;
		
		if (sscanf(secoption, "i", id))							return SendHelpMessage(playerid, "/aparkm remove [ID Parking meter]");
		if (id < 0 || !pMeter[id][parkID] || id >= MAX_METERS)	return SendErrorMessage(playerid, "Parking meter khong tim thay.");

		SendAdmMessageToPlayer(playerid, "Ban da xoa thanh cong parking meter [ID:%d].", id);	
    	EraseParkMeter(id);
		return 1;
	}

	else if (CompareStrings(option, "edit"))
	{
		new id;

		if (sscanf(secoption, "d", id))							return SendHelpMessage(playerid, "/aparkm edit [ID Parking meter]");
		if (id < 0 || !pMeter[id][parkID] || id >= MAX_METERS)	return SendErrorMessage(playerid, "Parking meter khong tim thay.");
		if (ParkMeter_Nearest(playerid) != id)					return SendErrorMessage(playerid, "Ban can dung gan park meter.");
		
		SetPVarInt(playerid, #edit_pm, id);
		EditDynamicObject(playerid, pMeter[id][parkObject]);
		return 1;
	}

	else if (CompareStrings(option, "goto"))
	{
		new id;

		if (sscanf(secoption, "i", id))							return SendHelpMessage(playerid, "/aparkm goto [ID parking meter]");
		if (id < 0 || !pMeter[id][parkID] || id >= MAX_METERS)	return SendErrorMessage(playerid, "Parking meter khong tim thay.");

		SetPlayerPosEx(playerid, pMeter[id][parkX], pMeter[id][parkY], pMeter[id][parkZ]);
		return 1;
	}
	
	else
	{
		SendHelpMessage(playerid, "/aparkm [create / remove / edit / goto]");
	}
	return 1;
}


CMD:givegunex(playerid, params[])
{
	new 
		userid, 
		weapon,
		ammo,
		ammotype, 
		serial
	;

	if (!CheckAdmin(playerid, ADMIN_LEVEL_3)) 							return SendNotAdmin(playerid);
	if (sscanf(params,"uiiii", userid, weapon, ammotype, ammo, serial))	return SendHelpMessage(playerid, "/givegunex [ID/Ten] [ID weapons] [loai dan(/ammohelp)] [ammo] [serial number (0 - 1)]");
	if (!IsPlayerLogged(userid))										return SendNotConnected(playerid);
	if (weapon >= 22 && weapon <= 34) if (!CompatAmmo(weapon, ammotype))return SendErrorMessage(playerid, "Loai dan nay khong phu hop voi vu khi nay. (/ammohelp)");
	if (serial)															serial = PlayerInfo[userid][pPlayerSerial];
	if (GiveInvItem(userid, weapon, ammo, ammotype, serial) == -1)		return SendErrorMessage(playerid, "Tui do da day.");

	SendSyntaxMessage(playerid, "Ban da cho %s %s [ammunition: %i])", GetNameEx(userid), inventory_items[weapon][itemName], ammo);
	SendSyntaxMessage(userid, "Administrator %s da cho ban %s [ammunition: %i].", GetAccName(playerid), inventory_items[weapon][itemName], ammo);
	SendAdmMessage("%s issued %s %s [ammunition: %i].", GetAccName(playerid), GetNameEx(userid), inventory_items[weapon][itemName], ammo);

    new mes[128];
	format(mes, sizeof(mes), "[/givegunex] %s da cho %s vu khi. (%s, Ammunition: %i)", GetAccName(playerid), GetNameEx(userid), inventory_items[weapon][itemName], ammo);
	insert_log(mes, ADMIN_LOG, 7, PlayerInfo[userid][pAccID], PlayerInfo[playerid][pAccID]);
	return 1;
}

CMD:acceptname(playerid, params[])
{
	new userid;

    if (!CheckAdmin(playerid, ADMIN_LEVEL_3))	return SendNotAdmin(playerid);
	if (sscanf(params, "u", userid))				return SendHelpMessage(playerid, "/acceptname [ID/Ten]");
	if (!IsPlayerLogged(userid))					return SendNotConnected(playerid);
	if (!strlen(pTemp[userid][pChangeNick]))		return SendErrorMessage(playerid, "Nguoi choi do khong co yeu cau doi ten.");

    new query[128];
    mysql_format(dbHandle, query, sizeof(query), "SELECT * FROM `users` WHERE `name` = '%e'", pTemp[userid][pChangeNick]);
	mysql_tquery(dbHandle, query, "OnChangeName", "iis", playerid, userid, pTemp[userid][pChangeNick]);
	return 1;
}

CMD:acceptnrn(playerid, params[])
{
	new userid;

    if (!CheckAdmin(playerid, ADMIN_LEVEL_3))	return SendNotAdmin(playerid);
	if (sscanf(params, "u", userid))				return SendHelpMessage(playerid, "/acceptname [ID/Ten]");
	if (!IsPlayerLogged(userid))					return SendNotConnected(playerid);
	if (!strlen(pTemp[userid][pChangeNick]))		return SendErrorMessage(playerid, "Nguoi choi do khong co yeu cau doi ten.");

    new query[128];
    mysql_format(dbHandle, query, sizeof(query), "SELECT * FROM `users` WHERE `name` = '%e'", pTemp[userid][pChangeNick]);
	mysql_tquery(dbHandle, query, "OnAdminNRN", "iis", playerid, userid, pTemp[userid][pChangeNick]);
	return 1;
}

CMD:nrn(playerid, params[])
{
	new userid;
    if (!CheckAdmin(playerid, ADMIN_LEVEL_3))		return SendNotAdmin(playerid);
	if (sscanf(params, "u", userid))				return SendHelpMessage(playerid, "/nrn [ID/Ten]");
	if (!IsPlayerLogged(userid))					return SendNotConnected(playerid);

	SendAdmMessage("%s da cho %s doi ten.", GetAccName(playerid), GetAccName(userid));
	Dialog_Show(userid, NRNNAME, DIALOG_STYLE_INPUT, "{FFFFFF}Nhap ten moi", "{FFFFFF}Nhap ten moi (Ho_Ten):", ">>>", "Huy");
	return 1;
}

CMD:itemlist(playerid, params[])
{
	if (!CheckAdmin(playerid, ADMIN_LEVEL_3)) return SendNotAdmin(playerid);

	new dialog_header[64] = "{FFFFFF}Ten\t{FFFFFF}ID item\n", dialog_body[3072];
	dialog_body[0] = EOS;

	format(dialog_body, sizeof(dialog_body), "%s", dialog_header);

	for(new i = 1; i != sizeof(inventory_items); i++)
	{
		format(dialog_body, sizeof(dialog_body), "%s%s\t%i\n", dialog_body, inventory_items[i][itemName], i);
	}

	Dialog_Show(playerid, None, DIALOG_STYLE_TABLIST_HEADERS, "{FFFFFF}List of items", dialog_body, "Dong", "");
	return 1;
}

CMD:giveitem(playerid, params[])
{
	if (!CheckAdmin(playerid, ADMIN_LEVEL_3)) return SendNotAdmin(playerid);

	new userid, item, amount;

	if (sscanf(params, "udd", userid, item, amount))	return SendHelpMessage(playerid, "/giveitem [ID/Ten] [ID item] [so luong]");
	if (!IsPlayerLogged(userid))						return SendNotConnected(playerid);
	if (item < 1 || item >= sizeof(inventory_items)) 	return SendErrorMessage(playerid, "ID Item khong tim thay.");
	if (amount < 1 || amount > 1000)					return SendErrorMessage(playerid, "So luong chi tu 1 den 1000");

	switch(item)
	{
		case 22..34: return SendErrorMessage(playerid, "Ban co the cho vu khi bang cach /givegun va /givegunex.");
		case INV_DRUG: return SendErrorMessage(playerid, "Ban co the cho drug bang cach su dung /givedrug.");
		case INV_GANJA, INV_MED_GANJA, 103 .. 118:
		{	
			if (GiveFloatInvItem(userid, item, float(amount)) == -1)	return SendErrorMessage(playerid, "Tui do da day.");

			SendAdmMessageToPlayer(userid, "Administrator %s da cho %s [%ig].", GetAccName(playerid), inventory_items[item][itemName], amount);
			SendAdmMessage("%s da cho ban %s %s [%ig].", GetAccName(playerid), GetNameEx(userid), inventory_items[item][itemName], amount);
		}
		default:
		{
			if (GiveInvItem(userid, item, amount) == -1) return SendErrorMessage(playerid, "Tui do da day.");
			
			SendAdmMessageToPlayer(userid, "Administrator %s da cho %s [%i manh].", GetAccName(playerid), inventory_items[item][itemName], amount);
			SendAdmMessage("%s da cho ban %s %s [%i manh].", GetAccName(playerid), GetNameEx(userid), inventory_items[item][itemName], amount);
		}
	}

	return 1;
}


CMD:givedrug(playerid, params[])
{
	if (!CheckAdmin(playerid, ADMIN_LEVEL_3)) return SendNotAdmin(playerid);

	new userid, type, Float:amount, quality, drugname[16];

	if (sscanf(params, "us[16]fdd", userid, drugname, amount, quality, type)) return SendHelpMessage(playerid, "/givedrug [ID/Ten] [Ten drug] [So luong] [Chat luong] [loai]");
	if (!IsPlayerLogged(userid))											  return SendNotConnected(playerid);
	if (isnull(drugname) || strlen(drugname) > 16)							  return SendErrorMessage(playerid, "Ky tu khong qua 16.");
	if (amount < 1.0 || amount > 1000.0)									  return SendErrorMessage(playerid, "So luong chi tu 1 den 1000.");
	if (quality < 1 || quality > 100)										  return SendErrorMessage(playerid, "Chat luong chi ti 1 den 100 (OAS).");
	if (type < 1 || type > 4)												  return SendErrorMessage(playerid, "Loai chi 1 den 4.");

	if (GiveDrugInvItem(playerid, drugname, amount, quality, type)  == -1)	return SendErrorMessage(playerid, "Tui do da day.");
	SendAdmMessageToPlayer(userid, "Administrator %s da cho %s [OAS:%i%%] (%.1fg) / %i Loai.", GetAccName(playerid), drugname, quality, amount, type);
	SendAdmMessage("%s da cho ban %s %s [OAS:%i%%] (%.1fg) / Loai %i.", GetAccName(playerid), GetNameEx(userid), drugname, quality, amount, type);

	return 1;
}

CMD:getgun(playerid, params[])
{
	new weapon, ammo = 999, serial = 0;

	if (!CheckAdmin(playerid, ADMIN_LEVEL_3))	return SendNotAdmin(playerid);
	if (sscanf(params,"d", weapon))				return SendHelpMessage(playerid, "/getgun [ID weapons]");

	new ammotype = GetDefaultAmmoType(weapon);

	if (serial)																serial = PlayerInfo[playerid][pPlayerSerial];
	if (GivePlayerWeaponEx(playerid, weapon, ammo, ammotype, serial) == 0)	return SendErrorMessage(playerid, "Weapon khong tim thay.");
	
	SendAdmMessage("(/getgun) %s da lay vu khi %s.", GetAccName(playerid), inventory_items[weapon][itemName]);

    new mes[128];
	format(mes, sizeof(mes), "[/getgun] %s da lay vu khi %s.", GetAccName(playerid), inventory_items[weapon][itemName]);
	insert_log(mes, ADMIN_LOG, 7, PlayerInfo[playerid][pAccID]);
	return 1;
}

CMD:alock(playerid, params[])
{
    if (!CheckAdmin(playerid, ADMIN_LEVEL_3)) return SendNotAdmin(playerid);

	for(new i; i != MAX_HOUSES; i++)
	{
	    if (HouseInfo[i][hID] == 0 || (0 == IsPlayerInsideHouse(playerid, i) && 0 == IsPlayerOutsideHouse(playerid, i))) continue;

        HouseInfo[i][hLocked] = !HouseInfo[i][hLocked];
		SQL_SetInteger("houses", "locked", HouseInfo[i][hLocked], HouseInfo[i][hID]);

        if (HouseInfo[i][hLocked] == 0)
        {
			SendAdmMessage("%s mo khoa cua can nha [ID: %i].", GetAccName(playerid), i);
			InfoMSG(playerid,  "~w~CUA ~g~MO", 5);
        }
        else
        {
			SendAdmMessage("%s khoa cua can nha [ID: %i].", GetAccName(playerid), i);
			InfoMSG(playerid,  "~w~CUA ~r~DONG", 5);
        }
        return 1;
	}

	for(new i = 0; i != MAX_BIZ; i++)
	{
	    if (BizInfo[i][bizID] == 0 || (0 == IsPlayerBizOutside(playerid, i) && 0 == IsPlayerBizInside(playerid, i)))	continue;

        BizInfo[i][bizLocked] = !BizInfo[i][bizLocked];
		SQL_SetInteger("business", "locked", BizInfo[i][bizLocked], BizInfo[i][bizID]);

		if (BizInfo[i][bizLocked] == 0)
		{
			SendAdmMessage("%s mo khoa cua doanh nghiep [ID: %i].", GetAccName(playerid), i);
			InfoMSG(playerid,  "~w~CUA ~g~MO", 5);
		}
		else
		{
			SendAdmMessage("%s khoa cua doanh nghiep [ID: %i].", GetAccName(playerid), i);
			InfoMSG(playerid,  "~w~CUA ~r~DONG", 5);
		}
		return 1;
	}

	for(new i = 0; i != MAX_ENTRANCE; i++)
	{
	    if (EntranceInfo[i][eFaction] == 0 || EntranceInfo[i][entranceOn] == 0 || (IsPlayerEntranceOutside(playerid, i) == 0 && IsPlayerEntranceInside(playerid, i) == 0)) continue;

        EntranceInfo[i][eLocked] = !EntranceInfo[i][eLocked];
        PlaySound(playerid, 1145);

        if (EntranceInfo[i][eLocked])
        {
			SendAdmMessage("%s khoa cua faction[ID doors: %i].", GetAccName(playerid), i);
			InfoMSG(playerid,  "~w~CUA ~r~DONG", 5);
		}
		else
		{
			SendAdmMessage("%s mo khoa cua faction [ID doors: %i].", GetAccName(playerid), i);
			InfoMSG(playerid,  "~w~CUA ~g~MO", 5);
		}
		break;
	}
	SendErrorMessage(playerid, "You must be near your home / business / entrance.");
	return 1;
}

CMD:ahouse(playerid, params[])
{
	if (!CheckAdmin(playerid, ADMIN_LEVEL_3)) return SendNotAdmin(playerid);
	
	new option[16], secoption[128];

	if (sscanf(params, "s[16]S()[128]", option, secoption))
	{
		SendHelpMessage(playerid, "/ahouse [create / remove / edit / sell / goto / backdoor]");
		return 1;
	}

	new houseid,
		level,
		price, 
		clases,
		classes_name[3][10] = {"Small", "Middle", "Large"};

	if (CompareStrings(option, "create"))
	{
		new Float:x, Float:y, Float:z, Float:newZ;

		if (sscanf(secoption, "iiF(0.0)", clases, price, newZ)) 	return SendHelpMessage(playerid, "/ahouse create [Loai (1 - trailer | 2 - nho | 3 - vua | 4 - to] [gia]");
		if (clases < 1 || clases > 4)				return SendErrorMessage(playerid, "Loai nha chi tu 1 den 4.");
		if (price < 1 || price > 2000000)			return SendErrorMessage(playerid, "Gia chi tu 1$ den 2000000$.");
		if ((houseid = GetNextHouseID()) == -1)		return SendErrorMessage(playerid, "Da dat den so luong nha co the tao.");

		new vw, interior;

		if (clases > 2) 	level = 1;
		else 			level = 0;

		GetPlayerPos(playerid, x, y, z);
		vw = GetWorld(playerid);
		interior = GetInterior(playerid);

		if (vw != 0 || interior != 0) HouseInfo[houseid][hApart] = GetNearApartmentInside(playerid);
		else 						 HouseInfo[houseid][hApart] = 0;

		HouseInfo[houseid][hPosX] = x;
		HouseInfo[houseid][hPosY] = y;
		HouseInfo[houseid][hPosZ] = z+newZ;
		HouseInfo[houseid][hPosVW] = vw;
		HouseInfo[houseid][hPosInt] = interior;

		HouseInfo[houseid][hExitX] = 
		HouseInfo[houseid][hExitY] = 
		HouseInfo[houseid][hExitZ] = 0.0;
		HouseInfo[houseid][hExitVW] = 5000 + houseid;

		if (clases == 1) 		SetHouseInterior(houseid, 0);
		else if (clases == 2)	SetHouseInteriorEx(houseid, 0);
		else if (clases == 3)	SetHouseInteriorEx(houseid, 1);
		else if (clases == 4)	SetHouseInteriorEx(houseid, 2);

		switch(clases)
		{
			case 1: clases = 0;
			case 2: clases = 0;
			case 3: clases = 1;
			case 4: clases = 2;
		}

		HouseInfo[houseid][hClass] = clases;

		for(new i = 0; i < 2; i++) {
			HouseInfo[houseid][hExtX][i] = 
			HouseInfo[houseid][hExtY][i] = 
			HouseInfo[houseid][hExtZ][i] = 0.0;
			HouseInfo[houseid][hExtVW][i] = 
			HouseInfo[houseid][hExtInt][i] = 0;
		}

		HouseInfo[houseid][hCheckPosX] = 
		HouseInfo[houseid][hCheckPosY] = 
		HouseInfo[houseid][hCheckPosZ] = 0.0;
		HouseInfo[houseid][hLevelbuy] = level;
		HouseInfo[houseid][hPrice] = price;
		HouseInfo[houseid][hLocked] = 1;
		HouseInfo[houseid][hFurnitureRadius] = 7.0;
		HouseInfo[houseid][hOwnerID] = 
		HouseInfo[houseid][hCash] = 
		HouseInfo[houseid][hRadio] = 
		HouseInfo[houseid][hHeal] = 
		HouseInfo[houseid][hHealAmount] =
		HouseInfo[houseid][hCupboard] = 0;

		new door[11];
		
		switch(HouseInfo[houseid][hDoor])
		{
			case 0: door = "Thuong";
			case 1: door = "Go";
			case 2: door = "Sat";
		}

		HouseInfo[houseid][hCheckPoint] = CreateDynamicCP(x, y, z+newZ, 1.0, HouseInfo[houseid][hPosVW], -1, -1, 2.0);
		AddHouseToFile(houseid, HouseInfo[houseid][hClass], level, price, HouseInfo[houseid][hApart], x, y, z+newZ, 5000 + houseid, vw, interior);

		SendAdmMessageToPlayer(playerid, "Ban da tao nha [ID: %i | Cap do: %i | Gia: %i | Loai: %s [%i] ].", houseid, level, price, classes_name[clases], clases);
		return 1;
	}
	else if (CompareStrings(option, "remove"))
	{
		if (sscanf(secoption, "i", houseid))
			return SendHelpMessage(playerid, "/ahouse remove [ID nha]");
			
		if (houseid < 0 || houseid >= MAX_HOUSES || !HouseInfo[houseid][hID])
			return SendErrorMessage(playerid, "Nha khong tim thay.");

		DestroyDynamicCP(HouseInfo[houseid][hCheckPoint]);

		if (IsValidDynamic3DTextLabel(HouseInfo[houseid][hLabelDDoor]))
		{
			DestroyDynamic3DTextLabel(HouseInfo[houseid][hLabelDDoor]);
			HouseInfo[houseid][hLabelDDoor] = Text3D:INVALID_3DTEXT_ID;
		}

		new query[128];
		mysql_format(dbHandle, query, sizeof(query), "DELETE FROM `houses` WHERE `id` = %i", HouseInfo[houseid][hID]);
		mysql_tquery(dbHandle, query);

		HouseInfo[houseid][hID] = 0;
		SendAdmMessageToPlayer(playerid, "Nha [ID: %i] da xoa.", houseid);
	}

	else if (CompareStrings(option, "edit"))
	{
		new parameters[12], arg[12];
		
		if (sscanf(secoption,"is[12]S()[12]", houseid, parameters, arg))
		{
			SendHelpMessage(playerid, "/ahouse edit [ID nha] [tuy chon] [so luong]");
			SendSyntaxMessage(playerid, "price / level / type / radius / int / enter / exit / extenter / extexit");
			return 1;
		}

		if (houseid < 0 || houseid > MAX_HOUSES || !HouseInfo[houseid][hID]) return SendErrorMessage(playerid, "House khong tim thay.");

		if (CompareStrings(parameters, "price"))
		{
			if (sscanf(arg, "i", price))		return SendHelpMessage(playerid, "/ahouse edit [ID nha] price [price]");
			if (price < 1 || price > 2000000)	return SendErrorMessage(playerid, "Gia chi tu $1 den $2000000.");

			HouseInfo[houseid][hPrice] = price;
			SQL_SetInteger("houses", "price", HouseInfo[houseid][hPrice], HouseInfo[houseid][hID]);
			SendAdmMessageToPlayer(playerid, "Ban da thay doi gia cua nha [ID: %i] thanh $%i.", houseid, HouseInfo[houseid][hPrice]);
		}

		else if (CompareStrings(parameters, "level"))
		{
			if (sscanf(arg, "i", level))	return SendHelpMessage(playerid, "/ahouse edit [ID nha] level [cap do]");
			if (level < 0 || level > 35)	return SendErrorMessage(playerid, "Cap do nha chi tu 1 den 35.");

			HouseInfo[houseid][hLevelbuy] = level;
			SQL_SetInteger("houses", "levelbuy", HouseInfo[houseid][hLevelbuy], HouseInfo[houseid][hID]);
			SendAdmMessageToPlayer(playerid, "Ban da thay doi cap do de co the mua can nha [ID: %i] thanh %i.", houseid, HouseInfo[houseid][hLevelbuy]);
		}

		else if (CompareStrings(parameters, "type"))
		{
			if (sscanf(arg, "i", clases))	return SendHelpMessage(playerid, "/ahouse edit [ID nha] type [Loai]");
			if (clases < 1 || clases > 3)	return SendErrorMessage(playerid, "Loai nha [1 - nho | 2 - vua | 3 - to.");

			HouseInfo[houseid][hClass] = clases - 1;
			SQL_SetInteger("houses", "class", HouseInfo[houseid][hClass], HouseInfo[houseid][hID]);
			SendAdmMessageToPlayer(playerid, "Ban co da thay doi loai nha [ID: %i] thanh %s [%i].", houseid, classes_name[clases-1], HouseInfo[houseid][hClass]);
		}

		else if (CompareStrings(parameters, "radius"))
		{
			new Float:radius;

			if (sscanf(arg, "f", radius))		return SendHelpMessage(playerid, "/ahouse edit [ID nha] radius [radius for placing the hardware outside].");
			if (radius < 0.0 || radius > 30.0)	return SendErrorMessage(playerid, "Radius from 0.0 to 30.0.");

			HouseInfo[houseid][hFurnitureRadius] = radius;
			SQL_SetFloat("houses", "furniture_radius", HouseInfo[houseid][hFurnitureRadius], HouseInfo[houseid][hID]);
			SendAdmMessageToPlayer(playerid, "You have changed the radius for your home hardware [ID: %i] on %.2f", houseid, HouseInfo[houseid][hFurnitureRadius]);
		}

		else if (CompareStrings(parameters, "int"))
		{
			new string[2048];
			
			for(new i = 0; i < MAX_INTERIORS; i++)
			{
				if (!AdminTeles[i][telesOn] || HouseInfo[houseid][hClass] != AdminTeles[i][telesType]) continue;
				format(string, sizeof(string), "%s\n<%i> {66FF66}%s", string, i, AdminTeles[i][telesMapName]);
			}

			if (isempty(string)) return SendErrorMessage(playerid, "Interiors cho nha nay khong tim thay.");

			SetPVarInt(playerid, "house_change", houseid);
			Dialog_Show(playerid, ChangeHouseInterior, DIALOG_STYLE_LIST, "{FFFFFF}House interior", string, "Select", "Huy");
		}

		else if (CompareStrings(parameters, "enter"))
		{
			if (IsValidDynamicCP(HouseInfo[houseid][hCheckPoint])) DestroyDynamicCP(HouseInfo[houseid][hCheckPoint]);

			GetPlayerPos(playerid, HouseInfo[houseid][hPosX], HouseInfo[houseid][hPosY], HouseInfo[houseid][hPosZ]);
			HouseInfo[houseid][hPosVW] = GetWorld(playerid);
			HouseInfo[houseid][hPosInt] = GetInterior(playerid);

			SQL_SetFloat("houses", "posx", HouseInfo[houseid][hPosX], HouseInfo[houseid][hID]);
			SQL_SetFloat("houses", "posy", HouseInfo[houseid][hPosY], HouseInfo[houseid][hID]);
			SQL_SetFloat("houses", "posz", HouseInfo[houseid][hPosZ], HouseInfo[houseid][hID]);
			SQL_SetInteger("houses", "posint", HouseInfo[houseid][hPosInt], HouseInfo[houseid][hID]);
			SQL_SetInteger("houses", "posvw", HouseInfo[houseid][hPosVW], HouseInfo[houseid][hID]);
			
			HouseInfo[houseid][hCheckPoint] = CreateDynamicCP(HouseInfo[houseid][hPosX], HouseInfo[houseid][hPosY], HouseInfo[houseid][hPosZ], 1.0, HouseInfo[houseid][hPosVW], HouseInfo[houseid][hPosInt], -1, 2.0);
			SendAdmMessageToPlayer(playerid, "You have moved the main entrance to the house [ID: %i].", houseid);
		}

		else if (CompareStrings(parameters, "exit"))
		{
			GetPlayerPos(playerid, HouseInfo[houseid][hExitX], HouseInfo[houseid][hExitY], HouseInfo[houseid][hExitZ]);
			HouseInfo[houseid][hExitInt] = GetInterior(playerid);

			SQL_SetFloat("houses", "exitx", HouseInfo[houseid][hExitX], HouseInfo[houseid][hID]);
			SQL_SetFloat("houses", "exity", HouseInfo[houseid][hExitY], HouseInfo[houseid][hID]);
			SQL_SetFloat("houses", "exitz", HouseInfo[houseid][hExitZ], HouseInfo[houseid][hID]);
			SQL_SetInteger("houses", "interior", HouseInfo[houseid][hExitInt], HouseInfo[houseid][hID]);
			SQL_SetInteger("houses", "exitvw", HouseInfo[houseid][hExitVW], HouseInfo[houseid][hID]);

			SendAdmMessageToPlayer(playerid, "You have moved your main exit from home [ID: %i].", houseid);
		}

		else if (CompareStrings(parameters, "extenter"))
		{
			if (IsValidDynamicCP(HouseInfo[houseid][hExtCheckPoint])) DestroyDynamicCP(HouseInfo[houseid][hExtCheckPoint]);

			GetPlayerPos(playerid, HouseInfo[houseid][hExtX][0], HouseInfo[houseid][hExtY][0], HouseInfo[houseid][hExtZ][0]);
			HouseInfo[houseid][hExtVW][0] = GetWorld(playerid);
			HouseInfo[houseid][hExtInt][0] = GetInterior(playerid);

			SQL_SetFloat("houses", "ext_ENposX", HouseInfo[houseid][hExtX][0], HouseInfo[houseid][hID]);
			SQL_SetFloat("houses", "ext_ENposY", HouseInfo[houseid][hExtY][0], HouseInfo[houseid][hID]);
			SQL_SetFloat("houses", "ext_ENposZ", HouseInfo[houseid][hExtZ][0], HouseInfo[houseid][hID]);
			SQL_SetInteger("houses", "ext_ENint", HouseInfo[houseid][hExtInt][0], HouseInfo[houseid][hID]);
			SQL_SetInteger("houses", "ext_ENvw", HouseInfo[houseid][hExtVW][0], HouseInfo[houseid][hID]);
			
			HouseInfo[houseid][hExtCheckPoint] = CreateDynamicCP(HouseInfo[houseid][hExtX][0], HouseInfo[houseid][hExtY][0], HouseInfo[houseid][hExtZ][0], 1.0, HouseInfo[houseid][hExtVW][0], HouseInfo[houseid][hExtInt][0], -1, 2.0);
			SendAdmMessageToPlayer(playerid, "You have moved an additional entrance to the house [ID: %i].", houseid);
		}

		else if (CompareStrings(parameters, "extexit"))
		{
			GetPlayerPos(playerid, HouseInfo[houseid][hExtX][1], HouseInfo[houseid][hExtY][1], HouseInfo[houseid][hExtZ][1]);
			HouseInfo[houseid][hExtInt][1] = GetInterior(playerid);

			SQL_SetFloat("houses", "ext_EXposX", HouseInfo[houseid][hExtX][1], HouseInfo[houseid][hID]);
			SQL_SetFloat("houses", "ext_EXposY", HouseInfo[houseid][hExtY][1], HouseInfo[houseid][hID]);
			SQL_SetFloat("houses", "ext_EXposZ", HouseInfo[houseid][hExtZ][1], HouseInfo[houseid][hID]);
			SQL_SetInteger("houses", "ext_EXint", HouseInfo[houseid][hExtInt][1], HouseInfo[houseid][hID]);
			SQL_SetInteger("houses", "ext_EXvw", HouseInfo[houseid][hExtVW][1], HouseInfo[houseid][hID]);

			SendAdmMessageToPlayer(playerid, "You have suffered an additional exit from home [ID: %i].", houseid);
		}

		else 
		{
			SendHelpMessage(playerid, "/ahouse edit [ID nha] [options] [value]");
			SendSyntaxMessage(playerid, "price / level / type / radius / int / enter / exit / extenter / extexit");
			return 1;
		}
	}
	
	else if (CompareStrings(option, "sell"))
	{
		if (sscanf(secoption, "i", houseid)) 									 return SendHelpMessage(playerid, "/ahouse sell [ID nha]");
		if (houseid < 0 || houseid > MAX_HOUSES - 1 || !HouseInfo[houseid][hID]) return SendErrorMessage(playerid, "House khong tim thay.");
		if (!HouseInfo[houseid][hOwnerID])										 return SendErrorMessage(playerid, "This house is already for sale.");

		new userid = GetIDByID(HouseInfo[houseid][hOwnerID]);

		if (IsPlayerLogged(userid)) {
			GiveCash(playerid, HouseInfo[houseid][hPrice]/2/* + GetFurniturePrice(0, houseid)*/);
			if (HouseInfo[houseid][hCash] > 0) GiveCash(playerid, HouseInfo[houseid][hCash]);

			SendAdmMessageToPlayer(userid, "Administrator %s sold your house. Returned to you $%i and from the safe $%i.", GetAccName(playerid), HouseInfo[houseid][hPrice]/2/* + GetFurniturePrice(0, houseid)*/, HouseInfo[houseid][hCash]);
		} else {
			new query[128];
			mysql_format(dbHandle, query, sizeof(query), "SELECT cash FROM `users` WHERE id=%i LIMIT 1", HouseInfo[houseid][hOwnerID]);
			new Cache:cache = mysql_query(dbHandle, query),
				money = cache_get_field_content_int(0, "cash", dbHandle);

			cache_delete(cache);

			money += HouseInfo[houseid][hPrice]/2/*+ GetFurniturePrice(0, houseid)*/ + HouseInfo[houseid][hCash];

			mysql_format(dbHandle, query, sizeof(query), "UPDATE `users` SET `cash`=%i WHERE id=%i LIMIT 1", money, HouseInfo[houseid][hOwnerID]);		
			mysql_query(dbHandle, query);
		}

		Sell_House(houseid);
		SendAdmMessageToPlayer(playerid, "You put the house out [ID: %i] for sale.", houseid);

	}

	else if (CompareStrings(option, "goto"))
	{
		if (sscanf(secoption, "i", houseid)) 									 return SendHelpMessage(playerid, "/ahouse goto [ID nha]");
		if (houseid < 0 || houseid > MAX_HOUSES - 1 || !HouseInfo[houseid][hID]) return SendErrorMessage(playerid, "House khong tim thay.");

		SetPlayerPosEx(playerid, HouseInfo[houseid][hPosX], HouseInfo[houseid][hPosY], HouseInfo[houseid][hPosZ]);
		SetInterior(playerid, HouseInfo[houseid][hPosInt]);
		SetWorld(playerid, HouseInfo[houseid][hPosVW]);
		SendSpecialMessage(playerid, "You teleported home [ID: %i].", houseid);
	}
	
	else if (CompareStrings(option, "backdoor")) {
		if (sscanf(secoption, "i", houseid))									 return SendHelpMessage(playerid, "/ahouse backdoor [ID nha]");
		if (houseid < 0 || houseid > MAX_HOUSES - 1 || !HouseInfo[houseid][hID]) return SendErrorMessage(playerid, "House khong tim thay.");
		if (HouseInfo[houseid][hApart])											 return SendErrorMessage(playerid, "Can't create rear Door for this house!");

		if (pTemp[playerid][pHouseEntered] == houseid) {
			new Float: posX, Float: posY, Float: posZ;
			GetPlayerPos(playerid, posX, posY, posZ);

			HouseInfo[houseid][hExtX][0] = posX;
			HouseInfo[houseid][hExtY][0] = posY;
			HouseInfo[houseid][hExtZ][0] = posZ;

			Save_House(houseid);

			HouseInfo[houseid][hExtVW][0] = GetPlayerVirtualWorld(playerid);
			HouseInfo[houseid][hExtInt][0] = GetPlayerInterior(playerid);

			return SendAdmMessageToPlayer(playerid, "You have successfully positioned an additional EXIT for home [ID:%i]", houseid);
		} else {
			new garageid = GetNearInsideGarage(playerid);
			if (garageid != -1) {
				if (HouseInfo[houseid][hID] == GarageInfo[garageid][garageHouse]) {
					if (IsValidDynamicCP(HouseInfo[houseid][hExtCheckPoint])) DestroyDynamicCP(HouseInfo[houseid][hExtCheckPoint]);
					
					new Float: posX, Float: posY, Float: posZ;
					GetPlayerPos(playerid, posX, posY, posZ);

					HouseInfo[houseid][hExtX][0] = posX;
					HouseInfo[houseid][hExtY][0] = posY;
					HouseInfo[houseid][hExtZ][0] = posZ;

					HouseInfo[houseid][hExtVW][0] = GetPlayerVirtualWorld(playerid);
					HouseInfo[houseid][hExtInt][0] = GetPlayerInterior(playerid);

					Save_House(houseid);

					HouseInfo[houseid][hExtCheckPoint] = CreateDynamicCP(HouseInfo[houseid][hExtX][0], HouseInfo[houseid][hExtY][0], HouseInfo[houseid][hExtZ][0], 1.0, HouseInfo[houseid][hExtVW][0], HouseInfo[houseid][hExtInt][0], -1, 2.0);
					return SendAdmMessageToPlayer(playerid, "You have successfully positioned an additional ENTANCE for home [ID:%i]", houseid);
				}
				else return SendErrorMessage(playerid, "You cannot create a back here Door!");
			}
			else if (GetNearOutsideHouse(playerid, 30)) {
				if (IsValidDynamicCP(HouseInfo[houseid][hExtCheckPoint])) DestroyDynamicCP(HouseInfo[houseid][hExtCheckPoint]);
				
				new Float: posX, Float: posY, Float: posZ;
				GetPlayerPos(playerid, posX, posY, posZ);

				HouseInfo[houseid][hExtX][0] = posX;
				HouseInfo[houseid][hExtY][0] = posY;
				HouseInfo[houseid][hExtZ][0] = posZ;

				HouseInfo[houseid][hExtVW][0] = GetPlayerVirtualWorld(playerid);
				HouseInfo[houseid][hExtInt][0] = GetPlayerInterior(playerid);

				Save_House(houseid);

				HouseInfo[houseid][hExtCheckPoint] = CreateDynamicCP(HouseInfo[houseid][hExtX][0], HouseInfo[houseid][hExtY][0], HouseInfo[houseid][hExtZ][0], 1.0, HouseInfo[houseid][hExtVW][0], HouseInfo[houseid][hExtInt][0], -1, 2.0);
				return SendAdmMessageToPlayer(playerid, "You have successfully positioned an additional ENTANCE for home [ID:%i]", houseid);
			}
			else return SendErrorMessage(playerid, "You cannot create a back here Door!");
		}
	}

	else 
	{
		SendHelpMessage(playerid, "/ahouse [options]");
		SendSyntaxMessage(playerid, "create / remove / edit / sell / goto / backdoor");	
	}

	return 1;
}

ALTX:abiz("/abusiness");
CMD:abiz(playerid, params[])
{
	if (!CheckAdmin(playerid, ADMIN_LEVEL_3))	return SendNotAdmin(playerid);

	new option[16], secoption[128];

	if (sscanf(params, "s[16]S()[128]", option, secoption))
	{
		SendHelpMessage(playerid, "/abiz [create / remove / edit / goto / sell / types / list]");
		return 1;
	}

	if (CompareStrings(option, "create"))
	{
		new bizid = -1, level, price, freeze, type, name[32];

		if (sscanf(secoption, "iI(0)I(0)S()[32]",type,freeze,price,name)) return SendHelpMessage(playerid, "/abiz create [type] {c7c7c7}[0 - can buy | 1 - can't buy] [price] [name]");
		if (freeze < 0 || freeze > 1)					  	 return SendErrorMessage(playerid, "Freezing from 0 to 1.");
		if (type > sizeof(biz_types) - 1 || type < 0) 	  	 return SendErrorMessage(playerid, "Business type from 0 to %i.", sizeof(biz_types) - 1);
		if ((bizid = GetNextBizID()) == -1)				 	 return SendErrorMessage(playerid, "The maximum number of businesses has been reached.");
		
		if (!price) 
		{
			switch(type) 
			{
				case 0:							 price = 5000000;
				case 1,2,4,5,15..19,21,22,23,24: price = 5000000;
				case 3,6,7,12,20: 				 price = 5000000;
				case 8,9,10,11,13: 				 price = 5000000;
				case 14: 						 price = 5000000;
			}
		}
		
		if (price < 2500 || price > 5000000) return SendErrorMessage(playerid, "Price business from $2500 to $5000000");

		level = 1;

		GetPlayerPos(playerid, BizInfo[bizid][bizPosX], BizInfo[bizid][bizPosY], BizInfo[bizid][bizPosZ]);
		BizInfo[bizid][bizPosInt] = GetInterior(playerid);
		BizInfo[bizid][bizPosVW] = GetWorld(playerid);

		GetPlayerPos(playerid, BizInfo[bizid][bizExitX], BizInfo[bizid][bizExitY], BizInfo[bizid][bizExitZ]);
		BizInfo[bizid][bizExitInt] = GetInterior(playerid);
		BizInfo[bizid][bizExitVW] = 5000 + bizid;

		BizInfo[bizid][bizMes] = EOS;
		BizInfo[bizid][bizType] = type;
		BizInfo[bizid][bizLevelbuy] = level;
		BizInfo[bizid][bizPrice] = price;
		BizInfo[bizid][bizFreeze] = freeze;
		BizInfo[bizid][bizOwnerID] = 
		BizInfo[bizid][bizLocked] = 
		BizInfo[bizid][bizCash] = 
		BizInfo[bizid][bizEntrance] = 
		BizInfo[bizid][bizRadioOn] = 
		BizInfo[bizid][bizRadio] = 0;
		
		new biztype = -1;

		/*switch(type)
		{
			case BIZ_PIZZA:		biztype = 0;
			case BIZ_CLUCKIN:	biztype = 1;
			case BIZ_BURGER:	biztype = 2;
			case BIZ_DONUT:		biztype = 3;
			case BIZ_STORE:		biztype = 4;
			case BIZ_BAR:		biztype = 5;
			case BIZ_PHARMACY:	biztype = 6;
		}*/

		if (biztype != -1) 
		{
			for (new i = 0; i < max_product[type]; i++) 
			{
				BizInfo[bizid][bizProductPrice][i] = biz_prices[biztype][i];
			}
		}
		
		BizInfo[bizid][bizProduct] = 400;
		BizInfo[bizid][bizBuyPrice] = price;
	
		format(BizInfo[bizid][bizOwner], MAX_PLAYER_NAME, "The State");
		
		if (isempty(name))	format(BizInfo[bizid][bizName], 32, "%s", biz_types[type]);
		else				format(BizInfo[bizid][bizName], 32, "%s", name);
		
		
		BizInfo[bizid][bizPickUp] = CreateDynamicPickup(1239, 1, BizInfo[bizid][bizPosX], BizInfo[bizid][bizPosY], BizInfo[bizid][bizPosZ], BizInfo[bizid][bizPosVW], BizInfo[bizid][bizPosInt], -1, 100.0);
		AddBizToFile(bizid, level, price, freeze, type, BizInfo[bizid][bizName], BizInfo[bizid][bizMes], BizInfo[bizid][bizPosX], BizInfo[bizid][bizPosY], BizInfo[bizid][bizPosZ], BizInfo[bizid][bizExitX], BizInfo[bizid][bizExitY],
		BizInfo[bizid][bizExitZ], BizInfo[bizid][bizPosInt], BizInfo[bizid][bizPosVW], BizInfo[bizid][bizExitInt], BizInfo[bizid][bizExitVW]);
		SendSyntaxMessage(playerid, "You created a business [ID: %i | Level: %i | Price: %i | Opportunity to buy: %s | Loai: %s].", bizid, level, price, (freeze) ? ("No") : ("Yes"), biz_types[BizInfo[bizid][bizType]]);

		if(BizInfo[bizid][bizType] == BIZ_AUTOSALON || BizInfo[bizid][bizType] == BIZ_BOATSALON || BizInfo[bizid][bizType] == BIZ_FLYSALON)  
		{
			SendHelpMessage(playerid, "You must set the position of the vehicle when purchasing '/abiz edit %i vehspawn'", bizid);
		}

		Save_Business(bizid);
	}

	else if (CompareStrings(option, "remove"))
	{
		new bizid;

		if (sscanf(secoption, "i", bizid))							return SendHelpMessage(playerid, "/abiz remove [ID business]");
		if (!BizInfo[bizid][bizID]) 								return SendErrorMessage(playerid, "Business khong tim thay.");

		if (IsValidDynamicPickup(BizInfo[bizid][bizPickUp]))	DestroyDynamicPickup(BizInfo[bizid][bizPickUp]);

		new ownerid = GetIDByID(BizInfo[bizid][bizOwnerID]), query[128];

		if (IsPlayerLogged(ownerid))
		{
			SendSyntaxMessage(ownerid, "Administrator %s da xoa doanh nghiep cua ban.", GetAccName(playerid));
			SendSyntaxMessage(ownerid, "Ban da duoc nhan [$%i] va tien tu ket sat cua doanh nghiep [$%i].", BizInfo[bizid][bizPrice], BizInfo[bizid][bizCash]);
			GiveCash(ownerid, BizInfo[bizid][bizPrice]);
			
			if (BizInfo[bizid][bizCash] > 0) GiveCash(ownerid, BizInfo[bizid][bizCash]);
		}
		else 
		{
			new biz_cost = BizInfo[bizid][bizPrice];
			
			if (BizInfo[bizid][bizCash] > 0) biz_cost += BizInfo[bizid][bizCash];

			mysql_format(dbHandle, query, sizeof(query), "SELECT `cash` FROM `users` WHERE `id` = %i", BizInfo[bizid][bizOwnerID]);
			mysql_tquery(dbHandle, query, "GivePlayerBizMoney", "ii", biz_cost, BizInfo[bizid][bizOwnerID]);
		}

		RemoveAllWorkers(bizid);

		mysql_format(dbHandle, query, sizeof(query), "DELETE FROM `business` WHERE `id` = %i", BizInfo[bizid][bizID]);
		mysql_tquery(dbHandle, query);

		BizInfo[bizid][bizID] = 
		BizInfo[bizid][bizOwnerID] = 0;
		SendSyntaxMessage(playerid, "Ban da xoa doanh nghiep [ID: %i].", bizid);
	}

	else if (CompareStrings(option, "edit"))
	{
		new id, parameters[16], arg[64];
		
		if (sscanf(secoption, "is[16]S()[64]", id, parameters, arg))
		{
			SendHelpMessage(playerid, "/abiz edit [ID business] [options] [value]");
			SendSyntaxMessage(playerid, "price / products / level / type / name / fee / cash / freeze / enter / exit / int / vehspawn");
			return 1;
		}
		
		if (id < 0 || id >= MAX_BIZ || !BizInfo[id][bizID]) return SendErrorMessage(playerid, "Business khong tim thay.");

		if (CompareStrings(parameters, "price"))
		{
			new price;
			
			if (sscanf(arg, "i", price)) 		return SendHelpMessage(playerid, "/abiz edit [ID business] price [price]");
			if (price < 2 || price > 5000000)	return SendErrorMessage(playerid, "Price business from $2 to $5000000.");

			BizInfo[id][bizPrice] = price;
			SQL_SetInteger("business", "price", BizInfo[id][bizPrice], BizInfo[id][bizID]);
			SendSyntaxMessage(playerid, "You have changed the price of your business [ID: %i] on $%i.", id, BizInfo[id][bizPrice]);
			return 1;
		}

		if (CompareStrings(parameters, "vehspawn"))
		{
			
			new Float: posX, Float: posY, Float: posZ, Float: posR;
			GetPlayerPos(playerid, posX, posY, posZ);
			GetPlayerFacingAngle(playerid, posR);

			GetPlayerPos(playerid, BizInfo[id][bizSpawn][0], BizInfo[id][bizSpawn][1], BizInfo[id][bizSpawn][2]);
			BizInfo[id][bizSpawnInt] = GetInterior(playerid);
			BizInfo[id][bizSpawnVW] = GetWorld(playerid);
			BizInfo[id][bizSpawn][3] = posR;

			SQL_SetFloat("business", "spawnX", BizInfo[id][bizSpawn][0], BizInfo[id][bizID]);
			SQL_SetFloat("business", "spawnY", BizInfo[id][bizSpawn][1], BizInfo[id][bizID]);
			SQL_SetFloat("business", "spawnZ", BizInfo[id][bizSpawn][2], BizInfo[id][bizID]);
			SQL_SetFloat("business", "spawnR", BizInfo[id][bizSpawn][3], BizInfo[id][bizID]);
			SQL_SetInteger("business", "spawnInt", BizInfo[id][bizSpawnInt], BizInfo[id][bizID]);
			SQL_SetInteger("business", "spawnVW", BizInfo[id][bizSpawnVW], BizInfo[id][bizID]);

			SendSyntaxMessage(playerid, "You have changed the price of the vehicle spawn position after purchasing in your salon [ID: %i].", id);
			return 1;
		}

		if (CompareStrings(parameters, "products"))
		{
			new products;
			
			if (sscanf(arg, "i", products)) 	return SendHelpMessage(playerid, "/abiz edit [ID business] products [quantity]");
			if (products < 1 || products > 500)	return SendErrorMessage(playerid, "Business products can be installed from 1 to 500.");

			BizInfo[id][bizProduct] = products;
			SQL_SetInteger("business", "product", BizInfo[id][bizProduct], BizInfo[id][bizID]);
			SendSyntaxMessage(playerid, "You have set the number of business products [ID: %i] %i.", id, BizInfo[id][bizProduct]);
		}

		else if (CompareStrings(parameters, "level"))
		{
			new level;

			if (sscanf(arg, "i", level))	return SendHelpMessage(playerid, "/abiz edit [ID business] level [level]");
			if (level < 0 || level > 35)	return SendErrorMessage(playerid, "Level from 0 to 35.");
			
			BizInfo[id][bizLevelbuy] = level;
			SQL_SetInteger("business", "levelbuy", BizInfo[id][bizLevelbuy], BizInfo[id][bizID]);
			SendSyntaxMessage(playerid, "You have changed your business purchase level [ID: %i] on %i.", id, BizInfo[id][bizLevelbuy]);
		}

		else if (CompareStrings(parameters, "type"))
		{
			new type;

			if (sscanf(arg, "i", type)) 					return SendHelpMessage(playerid, "/abiz edit [ID business] type [type]");
			if (type < 0 || type > sizeof(biz_types) - 1)	return SendErrorMessage(playerid, "Business type from 0 to %i.", sizeof(biz_types) - 1);

			BizInfo[id][bizType] = type;
			SQL_SetInteger("business", "type", BizInfo[id][bizType], BizInfo[id][bizID]);
			SendSyntaxMessage(playerid, "You have changed the type of business [ID: %i] on %s.", id, biz_types[BizInfo[id][bizType]]);
		}

		else if (CompareStrings(parameters, "name"))
		{
			new name[32];
			
			if (sscanf(arg, "s[32]", name))	return SendHelpMessage(playerid, "/abiz edit [ID business] name [text]");
			if (strlen(name) > 30)			return SendErrorMessage(playerid, "Business name to 30 characters.");
			if (CheckTextDrawString(name))	return SendErrorMessage(playerid, "Business name must not contain the character '~'.");

			format(BizInfo[id][bizName], 32, "%s", name);
			SQL_SetString("business", "name", BizInfo[id][bizName], BizInfo[id][bizID]);
			SendSyntaxMessage(playerid, "You have changed the name of the business [ID: %i] on %s.", id, BizInfo[id][bizName]);
		}

		else if (CompareStrings(parameters, "fee"))
		{
			new fee;

			if (sscanf(arg, "i", fee))		return SendHelpMessage(playerid, "/abiz edit [ID business] fee [price]");
			if (fee < 0 || fee > 100)		return SendErrorMessage(playerid, "Entrance fee from $0 to $100.");
			
			BizInfo[id][bizEntrance] = fee;
			SQL_SetInteger("business", "entrance", BizInfo[id][bizEntrance], BizInfo[id][bizID]);
			SendSyntaxMessage(playerid, "You have changed the entry price of the business [ID: %i] on $%i.", id, BizInfo[id][bizEntrance]);
		}

		else if (CompareStrings(parameters, "cash"))
		{
			new cash;

			if (sscanf(arg, "i", cash))		return SendHelpMessage(playerid, "/abiz edit [ID business] cash [money]");
			if (cash < 0 || cash > 5000000)	return SendErrorMessage(playerid, "Money from $0 to $5000000.");

			BizInfo[id][bizCash] = cash;
			SQL_SetInteger("business", "cash", BizInfo[id][bizCash], BizInfo[id][bizID]);
			SendSyntaxMessage(playerid, "You changed the money at the cash desk of the business [ID: %i] on $%i.", id, BizInfo[id][bizCash]);
		}

		else if (CompareStrings(parameters, "freeze"))
		{
			new freeze;

			if (sscanf(arg, "i", freeze))	return SendHelpMessage(playerid, "/abiz edit [ID business] freeze [freezing]");
			if (freeze < 0 || freeze > 1)	return SendErrorMessage(playerid, "Freezing from 0 �� 1.");

			BizInfo[id][bizFreeze] = freeze;
			SQL_SetInteger("business", "freeze", BizInfo[id][bizFreeze], BizInfo[id][bizID]);
			
			new freeze_naming[4];

			if (BizInfo[id][bizFreeze]) format(freeze_naming, sizeof(freeze_naming), "No");
			else 						format(freeze_naming, sizeof(freeze_naming), "Yes");
		
			SendSyntaxMessage(playerid, "You have changed the ability to buy a business [ID: %i] on - %s.", id, freeze_naming);
		}

		else if (CompareStrings(parameters, "enter"))
		{
			if (IsValidDynamicPickup(BizInfo[id][bizPickUp])) DestroyDynamicPickup(BizInfo[id][bizPickUp]);

			GetPlayerPos(playerid, BizInfo[id][bizPosX], BizInfo[id][bizPosY], BizInfo[id][bizPosZ]);
			BizInfo[id][bizPosInt] = GetInterior(playerid);
			BizInfo[id][bizPosVW] = GetWorld(playerid);

			UpdateBusinessDoor(id);
			BizInfo[id][bizPickUp] = CreateDynamicPickup(1239, 1, BizInfo[id][bizPosX], BizInfo[id][bizPosY], BizInfo[id][bizPosZ], BizInfo[id][bizPosVW], BizInfo[id][bizPosInt], -1, 100.0);

			SQL_SetFloat("business", "posx", BizInfo[id][bizPosX], BizInfo[id][bizID]);
			SQL_SetFloat("business", "posy", BizInfo[id][bizPosY], BizInfo[id][bizID]);
			SQL_SetFloat("business", "posz", BizInfo[id][bizPosZ], BizInfo[id][bizID]);
			SQL_SetInteger("business", "posvw", BizInfo[id][bizPosVW], BizInfo[id][bizID]);
			SQL_SetInteger("business", "posint", BizInfo[id][bizPosInt], BizInfo[id][bizID]);
			
			SendSyntaxMessage(playerid, "You have moved your business entry [ID: %i].", id);
		}

		else if (CompareStrings(parameters, "exit"))
		{
			GetPlayerPos(playerid, BizInfo[id][bizExitX], BizInfo[id][bizExitY], BizInfo[id][bizExitZ]);
			BizInfo[id][bizExitInt] = GetInterior(playerid);
			BizInfo[id][bizExitVW] = GetWorld(playerid);

			SQL_SetFloat("business", "exitx", BizInfo[id][bizExitX], BizInfo[id][bizID]);
			SQL_SetFloat("business", "exity", BizInfo[id][bizExitY], BizInfo[id][bizID]);
			SQL_SetFloat("business", "exitz", BizInfo[id][bizExitZ], BizInfo[id][bizID]);
			SQL_SetInteger("business", "exitint", BizInfo[id][bizExitInt], BizInfo[id][bizID]);
			SQL_SetInteger("business", "exitvw", BizInfo[id][bizExitVW], BizInfo[id][bizID]);

			SendSyntaxMessage(playerid, "You have moved out of business [ID: %i].", id);
		}

		else if (CompareStrings(parameters, "int"))
		{
			new string[3072];

			for(new i = 0; i < MAX_INTERIORS; i++)
			{
				if (!AdminTeles[i][telesOn] || BUSSINESS_INT_TYPE != AdminTeles[i][telesType]) continue;
				format(string, sizeof(string), "%s\n<%i> {66FF66}%s", string, i, AdminTeles[i][telesMapName]);
			}

			if (isempty(string)) SendErrorMessage(playerid, "Interiors for businesses khong tim thay.");

			SetPVarInt(playerid, "biz_change", id);
			Dialog_Show(playerid, ChangeBizInterior, DIALOG_STYLE_LIST, "{FFFFFF}Interior for business", string, "Select", "Huy");
		}

		else
		{
			SendHelpMessage(playerid, "/abiz edit [ID business] [options] [value]");
			SendSyntaxMessage(playerid, "price / products / level / type / name / fee / cash / freeze / enter / exit / int");
			return 1;
		}
	}

	else if (CompareStrings(option, "sell"))
	{
		new bizid;

		if (sscanf(secoption, "i", bizid))								return SendHelpMessage(playerid, "/abiz sell [ID business]");
		if (bizid < 0 || bizid > MAX_BIZ - 1 || !BizInfo[bizid][bizID])	return SendErrorMessage(playerid, "Doanh nghiep khong tim thay.");
		if (!BizInfo[bizid][bizOwnerID])								return SendErrorMessage(playerid, "Doanh nghiep nay dang ban.");

		new ownerid = GetIDByID(BizInfo[bizid][bizOwnerID]);

		if (IsPlayerLogged(ownerid))
		{
			SendSyntaxMessage(ownerid, "Administrator %s da ban doanh nghiep cua ban.", GetAccName(playerid));
			SendSyntaxMessage(ownerid, "Ban da duoc nhan [$%i] va tien tu ket sat doanh nghiep [$%i].", BizInfo[bizid][bizPrice], BizInfo[bizid][bizCash]);
			
			GiveCash(ownerid, BizInfo[bizid][bizPrice]);
			if (BizInfo[bizid][bizCash] > 0) GiveCash(ownerid, BizInfo[bizid][bizCash]);
		}
		else
		{
			new biz_cost = BizInfo[bizid][bizPrice];

			if (BizInfo[bizid][bizCash] > 0) biz_cost += BizInfo[bizid][bizCash];

			new query[128];
			mysql_format(dbHandle, query, sizeof(query), "SELECT `cash` FROM `users` WHERE `id` = %i", BizInfo[bizid][bizOwnerID]);
			mysql_tquery(dbHandle, query, "GivePlayerBizMoney", "ii", biz_cost, BizInfo[bizid][bizOwnerID]);	
		}

		Sell_Business(bizid);
		SendSyntaxMessage(playerid, "Ban da thiet lap doanh nghiep [ID: %i] de ban.", bizid);
	}

	else if (CompareStrings(option, "goto"))
	{
		new bizid; 

		if (sscanf(secoption, "i", bizid))								return SendHelpMessage(playerid, "/abiz goto [ID business]");
		if (bizid < 0 || bizid > MAX_BIZ - 1 || !BizInfo[bizid][bizID])	return SendErrorMessage(playerid, "Business khong tim thay.");

		SetPlayerPosEx(playerid, BizInfo[bizid][bizPosX], BizInfo[bizid][bizPosY], BizInfo[bizid][bizPosZ]);
		SetInterior(playerid, BizInfo[bizid][bizPosInt]);
		SetWorld(playerid, BizInfo[bizid][bizPosVW]);
		SendSpecialMessage(playerid, "Ban da dich chuyen toi doanh nhgiep [ID: %i].", bizid);
	}

	else if (CompareStrings(option, "types"))
	{
		new dialog_header[64] = "{FFFFFF}Ten\t{FFFFFF}ID\n", dialog_body[1024];

		format(dialog_body, sizeof(dialog_body), "%s", dialog_header);

		for(new i = 0; i != sizeof(biz_types); i++)
		{
			format(dialog_body, sizeof(dialog_body), "%s%s\t%i\n", dialog_body, biz_types[i], i);
		}

		Dialog_Show(playerid, None, DIALOG_STYLE_TABLIST_HEADERS, "{FFFFFF}Loai doanh nghiep", dialog_body, "Dong", "");
	}
	
	else if (CompareStrings(option, "list"))
	{
		pTemp[playerid][pDialogList] = 0;
		DisplayBizList(playerid);
	}

	else
	{
		SendHelpMessage(playerid, "/abiz [create / remove / edit / goto / sell / types / list]");
	}
	return 1;
}

CMD:aapart(playerid, params[])
{
	if (!CheckAdmin(playerid, ADMIN_LEVEL_3))	return SendNotAdmin(playerid);

	new option[16], secoption[128];

	if (sscanf(params, "s[16]S()[128]", option, secoption))
	{
		SendHelpMessage(playerid, "/aapart [create / remove / int / enter / exit / goto / gps]");
		return 1;
	}

	if (CompareStrings(option, "create"))
	{
		new apart;

		if ((apart = GetNextApartID()) == -1)	return SendErrorMessage(playerid, "Da dat den so luong toi da khong the tao them.");

		GetPlayerPos(playerid, ApartInfo[apart][aPosX], ApartInfo[apart][aPosY], ApartInfo[apart][aPosZ]);
		ApartInfo[apart][aPosInt] = GetInterior(playerid);
		ApartInfo[apart][aPosVW] = GetWorld(playerid);
		ApartInfo[apart][aApartOn] = 1;
		ApartInfo[apart][aExitVW] = apart + 1000;

		AddApartToFile(apart, ApartInfo[apart][aPosX], ApartInfo[apart][aPosY], ApartInfo[apart][aPosZ], ApartInfo[apart][aPosInt], ApartInfo[apart][aPosVW]);
		SetAparmentInterior(playerid, apart, 1);
		
		ApartInfo[apart][aCheckPoint] = CreateDynamicCP(ApartInfo[apart][aPosX], ApartInfo[apart][aPosY], ApartInfo[apart][aPosZ], 1.0, ApartInfo[apart][aPosVW], ApartInfo[apart][aPosInt], -1, 2.0);
	}

	else if (CompareStrings(option, "remove"))
	{
		new id; 

		if ((id = GetNearApartmentOutside(playerid)) == -1)	return SendErrorMessage(playerid, "Ban khong dung gan mot Apartment.");

		DestroyDynamicCP(ApartInfo[id][aCheckPoint]);

		new query[128];
		mysql_format(dbHandle, query, sizeof(query), "DELETE FROM `apartment` WHERE `id` = %i", ApartInfo[id][aID]);
		mysql_tquery(dbHandle, query, "OnApartRemove", "i", id);

		SendSyntaxMessage(playerid, "Apartment [ID: %i] da xoa.", id);
	}

	else if (CompareStrings(option, "int"))
	{
		new id, interior;

		if ((id = GetNearApartmentOutside(playerid)) == -1)	return SendErrorMessage(playerid, "Ban khong dung gan mot Apartment.");
		if (sscanf(secoption, "i", interior))
		{
			SendHelpMessage(playerid, "/aapart int [1-17]");
			//SendSyntaxMessage(playerid, "1: Ghetto Hotel 2: Ghetto Hotel(2) 3: Hotel 4: Hotel(2) 5: Apartment �1 (�����)");
			//SendSyntaxMessage(playerid, "6: Apartment �2 (�����) 7: Apartment �3 (�����) 8: Apartment �4 (��������� �����)");
			//SendSyntaxMessage(playerid, "9: Apartment �5 (�����) 10: Apartment �6 (����������) 11: Apartment �7 (�����) 12: Apartment �8 (�����)");
			SendSyntaxMessage(playerid, "13: Apartment �9 (Ghetto) 14: Apartment �10 (Elite) 15: Entrance (by Umka) 16: Motel 17: Motel (2)");
			return 1;
		}
		if (interior < 1 || interior > 17) return SendErrorMessage(playerid, "Interior ID tu 1 den 17.");

		SetAparmentInterior(playerid, id, interior);
	}

	else if (CompareStrings(option, "enter"))
	{
		new apartid;

		if (sscanf(secoption, "i", apartid))											return SendHelpMessage(playerid, "/aapart enter [Apartment ID]");
		if (apartid < 0 || apartid > MAX_APART - 1 || !ApartInfo[apartid][aApartOn])	return SendErrorMessage(playerid, "Apartment khong tim thay.");

		if (IsValidDynamicCP(ApartInfo[apartid][aCheckPoint]))	DestroyDynamicCP(ApartInfo[apartid][aCheckPoint]);

		GetPlayerPos(playerid, ApartInfo[apartid][aPosX], ApartInfo[apartid][aPosY], ApartInfo[apartid][aPosZ]);
		ApartInfo[apartid][aPosInt] = GetInterior(playerid);
		ApartInfo[apartid][aPosVW] = GetWorld(playerid);

		SQL_SetFloat("apartment", "posx", ApartInfo[apartid][aPosX], ApartInfo[apartid][aID]);
		SQL_SetFloat("apartment", "posy", ApartInfo[apartid][aPosY], ApartInfo[apartid][aID]);
		SQL_SetFloat("apartment", "posz", ApartInfo[apartid][aPosZ], ApartInfo[apartid][aID]);
		SQL_SetInteger("apartment", "posint", ApartInfo[apartid][aPosInt], ApartInfo[apartid][aID]);
		SQL_SetInteger("apartment", "posvw", ApartInfo[apartid][aPosVW], ApartInfo[apartid][aID]);

		ApartInfo[apartid][aCheckPoint] = CreateDynamicCP(ApartInfo[apartid][aPosX], ApartInfo[apartid][aPosY], ApartInfo[apartid][aPosZ], 1.0, ApartInfo[apartid][aPosVW], ApartInfo[apartid][aPosInt], -1, 2.0);
		SendSyntaxMessage(playerid, "You have transferred the entrance Apartment [ID: %i].", apartid);
	}

	else if (CompareStrings(option, "exit"))
	{
		new apartid;

		if (sscanf(secoption, "i", apartid)) 											return SendHelpMessage(playerid, "/aapart exit [Apartment ID]");
		if (apartid < 0 || apartid > MAX_APART - 1 || !ApartInfo[apartid][aApartOn])	return SendErrorMessage(playerid, "Apartment khong tim thay.");

		GetPlayerPos(playerid, ApartInfo[apartid][aExitX], ApartInfo[apartid][aExitY], ApartInfo[apartid][aExitZ]);
		ApartInfo[apartid][aExitInt] = GetInterior(playerid);
		ApartInfo[apartid][aExitVW] = GetWorld(playerid);

		SQL_SetFloat("apartment", "exitx", ApartInfo[apartid][aExitX], ApartInfo[apartid][aID]);
		SQL_SetFloat("apartment", "exity", ApartInfo[apartid][aExitY], ApartInfo[apartid][aID]);
		SQL_SetFloat("apartment", "exitz", ApartInfo[apartid][aExitZ], ApartInfo[apartid][aID]);
		SQL_SetInteger("apartment", "exitint", ApartInfo[apartid][aExitInt], ApartInfo[apartid][aID]);
		SQL_SetInteger("apartment", "exitvw", ApartInfo[apartid][aExitVW], ApartInfo[apartid][aID]);

		SendSyntaxMessage(playerid, "You moved the exit Apartment [ID: %i].", apartid);
	}

	else if (CompareStrings(option, "goto"))
	{
		new apartid;

		if (sscanf(secoption, "i", apartid))										 return SendHelpMessage(playerid, "/aapart goto [Apartment ID]");
		if (apartid < 0 || apartid > MAX_APART - 1 || !ApartInfo[apartid][aApartOn]) return SendErrorMessage(playerid, "Apartment khong tim thay.");

		SetPlayerPosEx(playerid, ApartInfo[apartid][aPosX], ApartInfo[apartid][aPosY], ApartInfo[apartid][aPosZ]);
		SetInterior(playerid, ApartInfo[apartid][aPosInt]);
		SetWorld(playerid, ApartInfo[apartid][aPosVW]);
		SendSpecialMessage(playerid, "Teleported to a Apartment [ID: %i].", apartid);
	}
	else if (CompareStrings(option, "gps"))
	{
		new apartid, text[128];

		if (sscanf(secoption, "is[128]", apartid, text)) return SendHelpMessage(playerid, "/aapart gps [Apartment ID] [GPS Title]");
		if (apartid < 0 || apartid > MAX_APART - 1 || !ApartInfo[apartid][aApartOn]) return SendErrorMessage(playerid, "Apartment khong tim thay.");
		if (strlen(text) < 1 || strlen(text) > 127)		 return SendErrorMessage(playerid, "Text length from 1 to 127.");

		format(ApartInfo[apartid][aApartName], 128, "%s", text);
		SQL_SetString("apartment", "apartname", ApartInfo[apartid][aApartName], ApartInfo[apartid][aID]);
		SendSyntaxMessage(playerid, "You have set the name of GPS Apartment [ID: %i] on %s.", apartid, ApartInfo[apartid][aApartName]);
		return 1;
	}
	
	else 
	{
		SendHelpMessage(playerid, "/aapart [create/remove/int/enter/exit/goto/gps]");
	}

	return 1;
}

CMD:changename(playerid, params[])
{
	new userid, newname[MAX_PLAYER_NAME];
	 
    if (!CheckAdmin(playerid, ADMIN_LEVEL_3)) 			return SendNotAdmin(playerid);
	if (sscanf(params,"us[24]", userid, newname))		return SendHelpMessage(playerid, "/changename [ID/Ten] [new name]");
	if (!IsPlayerLogged(userid))						return SendNotConnected(playerid);
    if (!IsValidPlayerName(newname))					return SendErrorMessage(playerid, "Ten sai dinh dang.");
	if (strlen(newname) < 4 || strlen(newname) > 24)	return SendErrorMessage(playerid, "Ten chi khong duoi 4 ky tu va tren 24");
	    
	new query[128];
    mysql_format(dbHandle, query, sizeof(query), "SELECT * FROM `users` WHERE `name` = '%e'", newname);
	mysql_tquery(dbHandle, query, "ChangeName", "iis", playerid, userid, newname);
	return 1;
}


CMD:adoor(playerid, params[])
{
	if (!CheckAdmin(playerid, ADMIN_LEVEL_3))	return SendNotAdmin(playerid);

	new option[16], secoption[128];

	if (sscanf(params, "s[16]S()[128]", option, secoption))
	{
		SendHelpMessage(playerid, "/adoor [create / remove / faction / vehicle / text / enter / exit / goto / namegps]");
		return 1;
	}

	if (CompareStrings(option, "create"))
	{
		new enterid = -1;

		for(new i = 0; i < MAX_ENTRANCE; i++)
		{
			if (EntranceInfo[i][entranceOn])	continue;

			enterid = i;
			break;
		}

		if (enterid == -1)	return SendErrorMessage(playerid, "Da dat den so luong toi da khong the tao.");

		GetPlayerPos(playerid, EntranceInfo[enterid][eEnterX], EntranceInfo[enterid][eEnterY], EntranceInfo[enterid][eEnterZ]);
		GetPlayerFacingAngle(playerid, EntranceInfo[enterid][eEnterA]);

	    EntranceInfo[enterid][eEnterInt] = GetInterior(playerid);
	    EntranceInfo[enterid][eEnterVW] = GetWorld(playerid);

	    GetPlayerPos(playerid, EntranceInfo[enterid][eExitX], EntranceInfo[enterid][eExitY], EntranceInfo[enterid][eExitZ]);
		GetPlayerFacingAngle(playerid, EntranceInfo[enterid][eExitA]);

	    EntranceInfo[enterid][eExitInt] = GetInterior(playerid);
	    EntranceInfo[enterid][eExitVW] = GetWorld(playerid);
   		EntranceInfo[enterid][eEnterPickup] = CreateDynamicPickup(1239, 1, EntranceInfo[enterid][eEnterX], EntranceInfo[enterid][eEnterY], EntranceInfo[enterid][eEnterZ], EntranceInfo[enterid][eEnterVW], EntranceInfo[enterid][eEnterInt], -1, 100.0);
		EntranceInfo[enterid][eExitPickup] = CreateDynamicPickup(1239, 1, EntranceInfo[enterid][eExitX], EntranceInfo[enterid][eExitY], EntranceInfo[enterid][eExitZ], EntranceInfo[enterid][eExitVW], EntranceInfo[enterid][eExitInt], -1, 100.0);
		EntranceInfo[enterid][entranceOn] = 1;

    	new query[156];
		mysql_format(dbHandle, query, sizeof(query), "INSERT INTO `entrance` (`enterx`,`entery`,`enterz`,`entera`,`entervw`,`enterint`) VALUES (%f,%f,%f,%f,%i,%i)", EntranceInfo[enterid][eEnterX], EntranceInfo[enterid][eEnterY], EntranceInfo[enterid][eEnterZ], EntranceInfo[enterid][eEnterA], EntranceInfo[enterid][eEnterVW], EntranceInfo[enterid][eEnterInt]);
		mysql_tquery(dbHandle, query, "OnInsertEntrance", "i", enterid);

    	SendSyntaxMessage(playerid, "Ban da tao Door [ID: %i].", enterid);
		return 1;
	}

	else if (CompareStrings(option, "remove"))
	{
		new enterid;

		if (sscanf(secoption, "i", enterid))	return SendHelpMessage(playerid, "/adoor remove [ID Door]");
		if (!EntranceInfo[enterid][entranceOn])	return SendErrorMessage(playerid, "Door khong tim thay.");

		if (IsValidDynamicPickup(EntranceInfo[enterid][eEnterPickup]))	DestroyDynamicPickup(EntranceInfo[enterid][eEnterPickup]);
		if (IsValidDynamicPickup(EntranceInfo[enterid][eExitPickup]))	DestroyDynamicPickup(EntranceInfo[enterid][eExitPickup]);

		EntranceInfo[enterid][entranceOn] = 0;

		new query[128];
		mysql_format(dbHandle, query, sizeof(query), "DELETE FROM `entrance` WHERE `id` = %i", EntranceInfo[enterid][eID]);
		mysql_tquery(dbHandle, query);

		SendSyntaxMessage(playerid, "Door [ID: %i] da xoa.", enterid);
		return 1;
	}

	else if (CompareStrings(option, "faction"))
	{
		new enterid, faction = 0;

		if (sscanf(secoption, "iI(0)", enterid, faction))										 return SendHelpMessage(playerid, "/adoor faction [ID Door] {c7c7c7}[Faction | Leave blank or specify 0, to free Door]");
		if (faction < 0 || faction >= MAX_FACTIONS || (faction != 0 && !Factions[faction][fON])) return SendErrorMessage(playerid, "ID faction khong tim thay.");
		if (!EntranceInfo[enterid][entranceOn])													 return SendErrorMessage(playerid, "Door khong tim thay.");

		EntranceInfo[enterid][eFaction] = faction;
		SQL_SetInteger("entrance", "faction", EntranceInfo[enterid][eFaction], EntranceInfo[enterid][eID]);
		SendSyntaxMessage(playerid, "Ban da thay doi Door cua Faction [ID: %i] thanh %i.", enterid, EntranceInfo[enterid][eFaction]);
		return 1;
	}

	else if (CompareStrings(option, "vehicle"))
	{
		new enterid, vehicle;

		if (sscanf(secoption, "ii", enterid, vehicle))	return SendHelpMessage(playerid, "/adoor vehicle [ID Door] [vehicle access (0 - closed | 1 - open)]");
		if (vehicle < 0 || vehicle > 1)					return SendErrorMessage(playerid, "Value from 0 to 1.");
		if (!EntranceInfo[enterid][entranceOn])			return SendErrorMessage(playerid, "Door khong tim thay.");

		EntranceInfo[enterid][eVehicle] = vehicle;
		SQL_SetInteger("entrance", "vehicle", EntranceInfo[enterid][eVehicle], EntranceInfo[enterid][eID]);

		new entrance_state[16];

		if (EntranceInfo[enterid][eVehicle])	format(entrance_state, sizeof(entrance_state), "allowed");
		else									format(entrance_state, sizeof(entrance_state), "banned");

		SendSyntaxMessage(playerid, "%s da co Door [ID: %i].", entrance_state, enterid);
		return 1;
	}
	
	else if (CompareStrings(option, "text"))
	{
		new enterid, text[128];

		if (sscanf(secoption, "is[128]", enterid, text)) return SendHelpMessage(playerid, "/adoor text [ID Door] [text]");
		if (!EntranceInfo[enterid][entranceOn])			 return SendErrorMessage(playerid, "Door khong tim thay.");
		if (strlen(text) < 1 || strlen(text) > 127)		 return SendErrorMessage(playerid, "Text length from 1 to 127.");

		format(EntranceInfo[enterid][eText], 128, "%s", text);
		SQL_SetString("entrance", "text", EntranceInfo[enterid][eText], EntranceInfo[enterid][eID]);
		SendSyntaxMessage(playerid, "Ban da thay doi van ban cua Door [ID: %i] thanh %s.", enterid, EntranceInfo[enterid][eText]);
		return 1;
	}

	else if (CompareStrings(option, "enter"))
	{
		new enterid;

		if (sscanf(secoption, "i", enterid))	return SendHelpMessage(playerid, "/adoor enter [ID Door]");
		if (!EntranceInfo[enterid][entranceOn])	return SendErrorMessage(playerid, "Door khong tim thay.");

		GetPlayerPos(playerid, EntranceInfo[enterid][eEnterX], EntranceInfo[enterid][eEnterY], EntranceInfo[enterid][eEnterZ]);
		GetPlayerFacingAngle(playerid, EntranceInfo[enterid][eEnterA]);

		EntranceInfo[enterid][eEnterInt] = GetInterior(playerid);
		EntranceInfo[enterid][eEnterVW] = GetWorld(playerid);

		if (IsValidDynamicPickup(EntranceInfo[enterid][eEnterPickup]))	DestroyDynamicPickup(EntranceInfo[enterid][eEnterPickup]);

		EntranceInfo[enterid][eEnterPickup] = CreateDynamicPickup(1239, 1, EntranceInfo[enterid][eEnterX], EntranceInfo[enterid][eEnterY], EntranceInfo[enterid][eEnterZ], EntranceInfo[enterid][eEnterVW], EntranceInfo[enterid][eEnterInt], -1, 100.0);

		SQL_SetFloat("entrance", "enterx", EntranceInfo[enterid][eEnterX], EntranceInfo[enterid][eID]);
		SQL_SetFloat("entrance", "entery", EntranceInfo[enterid][eEnterY], EntranceInfo[enterid][eID]);
		SQL_SetFloat("entrance", "enterz", EntranceInfo[enterid][eEnterZ], EntranceInfo[enterid][eID]);
		SQL_SetFloat("entrance", "entera", EntranceInfo[enterid][eEnterA], EntranceInfo[enterid][eID]);
		SQL_SetInteger("entrance", "entervw", EntranceInfo[enterid][eEnterVW], EntranceInfo[enterid][eID]);
		SQL_SetInteger("entrance", "enterint", EntranceInfo[enterid][eEnterInt], EntranceInfo[enterid][eID]);
		
		SendSyntaxMessage(playerid, "You have changed the entry position [ID: %i].", enterid);
		return 1;
	}

	else if (CompareStrings(option, "exit"))
	{
		new enterid;

		if (sscanf(secoption, "i", enterid))	return SendHelpMessage(playerid, "/adoor exit [ID Door]");
		if (!EntranceInfo[enterid][entranceOn])	return SendErrorMessage(playerid, "Door khong tim thay.");

		GetPlayerPos(playerid, EntranceInfo[enterid][eExitX], EntranceInfo[enterid][eExitY], EntranceInfo[enterid][eExitZ]);
		GetPlayerFacingAngle(playerid, EntranceInfo[enterid][eExitA]);

		EntranceInfo[enterid][eExitInt] = GetInterior(playerid);
		EntranceInfo[enterid][eExitVW] = GetWorld(playerid);

		if (IsValidDynamicPickup(EntranceInfo[enterid][eExitPickup]))	DestroyDynamicPickup(EntranceInfo[enterid][eExitPickup]);

		EntranceInfo[enterid][eExitPickup] = CreateDynamicPickup(1239, 1, EntranceInfo[enterid][eExitX], EntranceInfo[enterid][eExitY], EntranceInfo[enterid][eExitZ], EntranceInfo[enterid][eExitVW], EntranceInfo[enterid][eExitInt], -1, 100.0);

		SQL_SetFloat("entrance", "exitx", EntranceInfo[enterid][eExitX], EntranceInfo[enterid][eID]);
		SQL_SetFloat("entrance", "exity", EntranceInfo[enterid][eExitY], EntranceInfo[enterid][eID]);
		SQL_SetFloat("entrance", "exitz", EntranceInfo[enterid][eExitZ], EntranceInfo[enterid][eID]);
		SQL_SetFloat("entrance", "exita", EntranceInfo[enterid][eExitA], EntranceInfo[enterid][eID]);
		SQL_SetInteger("entrance", "exitvw", EntranceInfo[enterid][eExitVW], EntranceInfo[enterid][eID]);
		SQL_SetInteger("entrance", "exitint", EntranceInfo[enterid][eExitInt], EntranceInfo[enterid][eID]);
		
		SendSyntaxMessage(playerid, "You have changed the exit position [ID: %i].", enterid);
		return 1;
	}

	else if (CompareStrings(option, "goto"))
	{
		new enterid;

		if (sscanf(secoption, "i", enterid))		return SendHelpMessage(playerid, "/adoor goto [ID Door]");
		if (!EntranceInfo[enterid][entranceOn])		return SendErrorMessage(playerid, "Door khong tim thay.");
		if (enterid >= MAX_ENTRANCE || enterid < 0)	return SendErrorMessage(playerid, "From 0 to %i.", MAX_ENTRANCE);

		SetPlayerPosEx(playerid, EntranceInfo[enterid][eEnterX], EntranceInfo[enterid][eEnterY], EntranceInfo[enterid][eEnterZ]);
		SetInterior(playerid, EntranceInfo[enterid][eEnterInt]);
		SetWorld(playerid, EntranceInfo[enterid][eEnterVW]);
	}

	else if (CompareStrings(option, "namegps"))
	{
		new enterid, text[128];

		if (sscanf(secoption, "is[128]", enterid, text)) return SendHelpMessage(playerid, "/adoor namegps [ID Door] [text]");
		if (!EntranceInfo[enterid][entranceOn])			 return SendErrorMessage(playerid, "Door khong tim thay.");
		if (strlen(text) < 1 || strlen(text) > 127)		 return SendErrorMessage(playerid, "Text length from 1 to 127.");

		format(EntranceInfo[enterid][gpsText], 128, "%s", text);
		SQL_SetString("entrance", "gpsname", EntranceInfo[enterid][gpsText], EntranceInfo[enterid][eID]);
		SendSyntaxMessage(playerid, "You have changed the name in GPS Door [ID: %i] on %s.", enterid, EntranceInfo[enterid][gpsText]);
		return 1;
	}

	else 
	{
		SendHelpMessage(playerid, "/adoor [create / remove / faction / vehicle / text / enter / exit / goto / namegps]");
	}
	return 1;
}

