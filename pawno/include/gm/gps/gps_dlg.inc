Dialog:DIALOG_GPS(playerid, response, listitem, inputtext[])
{
	if (!response) return 1;

	switch(listitem) 
	{
		case 0: 
		{ // Locations
			new substr[48],
                str[sizeof(substr)*20 + 20] = "Dia diem\t Khoang cach";

			for(new i; i < MAX_ENTRANCE; i++) 
			{
				if (isempty(EntranceInfo[i][gpsText]) || !EntranceInfo[i][entranceOn]) continue;

				format(substr, sizeof(substr), "%.32s\t{33CC33}%i m", EntranceInfo[i][gpsText], GetPlayerDistanceToPointEx(playerid, EntranceInfo[i][eEnterX], EntranceInfo[i][eEnterY], EntranceInfo[i][eEnterZ]));
                format(str, sizeof(str), "%s\n%s", str, substr);
            }
			
            if (isempty(substr)) format(str, sizeof(str), "%s\n{FF6347}KHONG TIM THAY", str);

			Dialog_Show(playerid, DIALOG_GPS_LOCATION, DIALOG_STYLE_TABLIST_HEADERS, "GPS > Dia diem", str, "Chon", "Quay lai");
		}
		case 1: 
		{ // biz
			new substr[80],
                str[sizeof(substr)*MAX_BIZ_TYPES+30] = "Loai\tTen\t Khoang cach", 
				id, 
				Float:radius;

			for(new i; i < MAX_BIZ_TYPES; i++) 
			{
				if ((id = GetClosestTypeBiz(playerid, i, radius)) == -1)	
				{
					format(substr, sizeof(substr), "%s\t{FF6347}KHONG TIM THAY", biz_types[i]);
				} 
				else 
				{
					format(substr, sizeof(substr), "%s\t%s\t{33CC33}%.0f m", biz_types[i], BizInfo[id][bizName], radius);
				}
                format(str, sizeof(str), "%s\n%s", str, substr);
			}

            if (isempty(substr)) format(str, sizeof(str), "%s\n{FF6347}KHONG TIM THAY", str);

			Dialog_Show(playerid, DIALOG_GPS_BIZ, DIALOG_STYLE_TABLIST_HEADERS, "GPS > Doanh nghiep", str, "Chon", "Quay lai");
		}
		case 2: 
		{ // Jobs
			new substr[64],
                str[sizeof(substr)*MAX_BIZ_TYPES+20] = "Cong viec\tKhoang cach", 
				Float:radius;

			for(new i = 1; i < MAX_JOBS_TYPES; i++) 
			{
				if (GetClosestTypeJob(playerid, i, radius) == -1) {
					format(substr, sizeof(substr), "%s\t{FF6347}KHONG TIM THAY", jobs_names[i]);
				} else {
					format(substr, sizeof(substr), "%s\t{33CC33}%.0f m", jobs_names[i], radius);
				}
                format(str, sizeof(str), "%s\n%s", str, substr);
			}

            if (isempty(substr)) format(str, sizeof(str), "%s\n{FF6347}KHONG TIM THAY", str);

			Dialog_Show(playerid, DIALOG_GPS_JOBS, DIALOG_STYLE_TABLIST_HEADERS, "GPS > Cong viec", str, "Chon", "Quay lai");
		}
		case 3: 
		{ // Apartments
			new substr[48],
                str[sizeof(substr)*20 + 20] = "Dia diem\t Khoang cach";

			for(new i; i < MAX_APART; i++) 
			{
				if (isempty(ApartInfo[i][aApartName]) || !ApartInfo[i][aApartOn]) continue;

				format(substr, sizeof(substr), "%.32s\t{33CC33}%i m", ApartInfo[i][aApartName], GetPlayerDistanceToPointEx(playerid, ApartInfo[i][aPosX], ApartInfo[i][aPosY], ApartInfo[i][aPosZ]));
                format(str, sizeof(str), "%s\n%s", str, substr);
            }
			
            if (isempty(substr)) format(str, sizeof(str), "%s\n{FF6347}KHONG TIM THAY", str);

			Dialog_Show(playerid, DIALOG_GPS_APARTMENT, DIALOG_STYLE_TABLIST_HEADERS, "GPS > Can ho", str, "Chon", "Quay lai");
		}
	}
	return 1;
}


Dialog:DIALOG_GPS_APARTMENT(playerid, response, listitem, inputtext[])
{
	if (!response) return cmd::gps(playerid, "");

	new id;
	for(new i; i < MAX_APART; i++) {
		if (isempty(ApartInfo[i][aApartName])) continue;
		
		if (listitem == id) {
			id = i;
			break;
		} else id++;
	}

	Waypoint_Set(playerid, ApartInfo[id][aPosX], ApartInfo[id][aPosY], ApartInfo[id][aPosZ]);
	SendClientMessageEx(playerid, COLOR_GREEN, "Dia diem '%s' da duoc danh dau tren ban do. (/rcp - de xoa diem danh dau)", ApartInfo[id][aApartName]);
	PlayerPlaySound(playerid, 21001, 0.0, 0.0, 0.0);
	return 1;
}

Dialog:DIALOG_GPS_LOCATION(playerid, response, listitem, inputtext[])
{
	if (!response) return cmd::gps(playerid, "");

	new id;
	for(new i; i < MAX_ENTRANCE; i++) {
		if (isempty(EntranceInfo[i][gpsText])) continue;
		
		if (listitem == id) {
			id = i;
			break;
		} else id++;
	}

	Waypoint_Set(playerid, EntranceInfo[id][eEnterX], EntranceInfo[id][eEnterY], EntranceInfo[id][eEnterZ]);
	SendClientMessageEx(playerid, COLOR_GREEN, "Dia diem '%s' da duoc danh dau tren ban do. (/rcp - de xoa diem danh dau)", EntranceInfo[id][gpsText]);
	PlayerPlaySound(playerid, 21001, 0.0, 0.0, 0.0);
	return 1;
}

Dialog:DIALOG_GPS_BIZ(playerid, response, listitem, inputtext[])
{
	if (!response) return cmd::gps(playerid, "");

	new id, Float:radius;
	if ((id = GetClosestTypeBiz(playerid, listitem, radius)) == -1) return cmd::gps(playerid, "");

	Waypoint_Set(playerid, BizInfo[id][bizPosX], BizInfo[id][bizPosY], BizInfo[id][bizPosZ]);
	SendClientMessageEx(playerid, COLOR_GREEN, "[%s] %s da duoc danh dau tren ban do. (/rcp - de xoa diem danh dau)", biz_types[listitem], BizInfo[id][bizName]);
	PlayerPlaySound(playerid, 21001, 0.0, 0.0, 0.0);
	return 1;
}

Dialog:DIALOG_GPS_JOBS(playerid, response, listitem, inputtext[])
{
	if (!response) return cmd::gps(playerid, "");
	
	listitem++;

	new id, Float:radius;
	if ((id = GetClosestTypeJob(playerid, listitem, radius)) == -1) return cmd::gps(playerid, "");
    if(JobsInfo[id][jobType] == JOB_TRUCKER) return SendErrorMessage(playerid,"Vui long su dung /truck");
	Waypoint_Set(playerid, JobsInfo[id][jobX], JobsInfo[id][jobY], JobsInfo[id][jobZ]);
	SendClientMessageEx(playerid, COLOR_GREEN, "Cong viec '%s' da duoc danh dau tren ban do. (/rcp - de xoa diem danh dau)", jobs_names[listitem]);
	PlayerPlaySound(playerid, 21001, 0.0, 0.0, 0.0);
	return 1;
}