//native IsValidVehicle(vehicleid);
native WP_Hash(buffer[], len, const str[]);

stock ConfirmDialog(playerid, caption[], info[], callback[], ...)
{
	new n = numargs(), 		// number of arguments, static + optional
		szParamHash[64];	// variable where the passed arguments will be stored
	for(new arg = 4; arg < n; arg++){	// loop all additional arguments
		format(szParamHash, sizeof(szParamHash), "%s%d|", szParamHash, getarg(arg)); // store them in szParamHash
	}
	SetPVarInt(playerid, "confDialogArgs", n -4);			// store the amount of additional arguments
	SetPVarString(playerid, "confDialCallback", callback);	// store the callback that needs to be called after response
	SetPVarString(playerid, "confDialog_arg", szParamHash);	// store the additional arguments
	
	ShowPlayerDialog(playerid, DIALOG_CONFIRM_SYS, DIALOG_STYLE_MSGBOX, caption, info, ">>>", "Cancel"); // display the dialog message itself
	
	return 1;
}

stock ConfirmDialog_Response(playerid, response)
{
	new szCallback[33],		// variable to fetch our callback to
		szParamHash[64], 	// variable to check raw compressed argument string
		n,					// variable to fetch the amount of additional arguments
		szForm[12];			// variable to generate the CallLocalFunction() "format" argument
		
	n = GetPVarInt(playerid, "confDialogArgs");	// Fetch the amount of additional arguments
	GetPVarString(playerid, "confDialCallback", szCallback, sizeof(szCallback));	// fetch the callback
	GetPVarString(playerid, "confDialog_arg", szParamHash, sizeof(szParamHash));	// fetch the raw compressed additional arguments
	
	new hashDecoded[12];	// variable to store extracted additional arguments from the ConfirmDialog() generated string
	
	sscanf(szParamHash, "p<|>A<d>(0)[12]", hashDecoded);	// extraction of the additional arguments
	
	new args, 	// amount of cells passed to CallLocalFunction
		addr, 	// pointer address variable for later use
		i;		// i
		
	format(szForm, sizeof(szForm), "dd");	// static parameters for the callback, "playerid" and "response"
	
	#emit ADDR.pri hashDecoded	// get pointer address of the extracted additional arguments
	#emit STOR.S.pri addr		// store the pointer address in variable 'addr'
	if (n){	// if there's any additional arguments
		for(i = addr + ((n-1) * 4); i >= addr; i-=4){ // loops all additional arguments by their addresses
			format(szForm, sizeof(szForm), "%sd", szForm); // adds an aditional specifier to the "format" parameter of CallLocalFunction
			#emit load.s.pri i	// load the argument at the current address
			#emit push.pri		// push it to the CallLocalFunction argument list
			args+=4;			// increase used cell number by 4
		}
	}
	
	
	args+=16;	// preserve 4 more arguments for CallLocalFunction (16 cause 4 args by 4 cells (4*4))
	
	#emit ADDR.pri response				// fetch "response" pointer address to the primary buffer
	#emit push.pri						// push it to the argument list
	
	#emit ADDR.pri playerid				// fetch "playerid" pointer address to the primary buffer
	#emit push.pri						// push it to the argument list
	
	#emit push.adr szForm				// push the szForm ("format") to the argument list by its referenced address
	#emit push.adr szCallback			// push the szCallback (custom callback) to the argument list by its referenced address
	#emit push.s args					// push the amount of arguments
	#emit sysreq.c CallLocalFunction	// call the function
	
	// Clear used data
	#emit LCTRL 4
	#emit LOAD.S.ALT args
	#emit ADD.C 4
	#emit ADD
	#emit SCTRL 4
	
	// Clear used PVars
	DeletePVar(playerid, "confDialCallback");
	DeletePVar(playerid, "confDialog_arg");
	DeletePVar(playerid, "confDialogArgs");
	
	return 1;
}

this::Float:GetDistanceBetweenPoints(Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2)
{
    return VectorSize(x1-x2, y1-y2, z1-z2);
}

insert_log(const string[], type, subtype, playerid = 0, secondid = 0)
{
    new query[1024];
	mysql_format(dbHandle, query, sizeof(query), "INSERT INTO `logs` (userid,secondid,text,data,type,subtype) VALUES (%i,%i,'%s','%s',%i,%i)", 
	playerid, secondid, string, GetFullDate(), type, subtype);
	mysql_tquery(dbHandle, query);
	return 1;
}

isNumeric(const string[])
{
	new length = strlen(string);
	
	if (length == 0) return 0;

  	for (new i = 0; i < length; i++)
  	{
    	if ((string[i] > '9' || string[i] < '0' && string[i] != '-' && string[i] != '+') || (string[i] == '-' && i != 0) || (string[i] == '+' && i != 0)) return false;
	}
  	
	if (length==1 && (string[0]=='-' || string[0]=='+')) return false;

  	return true;
}

IsAnIP(str[])
{
	if (!str[0] || str[0] == '\1')	return 0;

	for (new i = 0, l = strlen(str); i != l; i ++)
	{
	    if ((str[i] < '0' || str[i] > '9') && str[i] != '.') 				return 0;
	    if (0 < ((i == 0) ? (strval(str)) : (strval(str[i + 1]))) > 255)	return 0;
	}
	return 1;
}

place_color(string[])
{
	for(new i=0; string[i]; i++)
	{
		if (string[i] != '~') continue;

        if (string[i + 7] == '~')
		{
			string[i + 7] = '}';
            string[i] = '{';
		}

		if (string[i + 1] == 'n' && string[i + 2] == '~')
        {
            strdel(string, i, i + 2);
            strins(string, "\n", i, 3);
            strdel(string, i + 1, i + 2);
            strins(string, "", i + 1, 1);
		}
	}
	return 1;
}

strreplace(string[], find, replace)
{
	for(new i=0; string[i]; i++)
	{
		if (string[i] != find) continue;

		string[i] = replace;
	}
	return 1;
}

GetMonthName(month)
{
	new name[32];
	switch(month)
	{
		case 1: format(name,32,"Thang 1");
		case 2: format(name,32,"Thang 2");
		case 3: format(name,32,"Thang 3");
		case 4: format(name,32,"Thang 4");
		case 5: format(name,32,"Thang 5");
		case 6: format(name,32,"Thang 6");
		case 7: format(name,32,"Thang 7");
		case 8: format(name,32,"Thang 8");
		case 9: format(name,32,"Thang 9");
		case 10: format(name,32,"Thang 10");
		case 11: format(name,32,"Thang 11");
		case 12: format(name,32,"Thang 12");
	}
	return name;
}

GetInitials(const string[])
{
	new ret[64], index = 0;

	for (new i = 0, l = strlen(string); i != l; i ++)
	{
	    if (('A' <= string[i] <= 'Z') && (i == 0 || string[i - 1] == ' '))	ret[index++] = string[i];
	}
	return ret;
}

StringHasSymbols(string[])
{
	for(new i = 0; i < strlen(string); i++)
	{
		switch(string[i])
		{
			case '!', '@', '#', '$','%','^','&','*','(',')','_','+','=','|','[',']','{','}','-','.','`','~','<','>','?',',','/': return 1;
			default: continue;
		}
	}
	return 0;
}

CompareStrings(string[], string2[])
{
	return (!strcmp(string, string2, true))?(1):(0);
}

ConvertSecond(time)
{
	new mes[9];

	if (time < 60) format(mes, sizeof(mes), "00:%02i", time);
	else if (time == 60) mes = "01:00";
	else if (time > 60 && time < 3600)
	{
		new Float: minutes = time / 60, seconds = time % 60;

		format(mes, sizeof(mes), "%02.0f:%02i", minutes, seconds);
	}
	else if (time == 3600) mes = "01:00:00";
	else if (time > 3600)
	{
		new Float: hours = time / 3600, minutes_int = time % 3600, Float: minutes = minutes_int / 60, seconds = minutes_int % 60;

		format(mes, sizeof(mes), "%02.0f:%02.0f:%02i", hours, minutes, seconds);
	}
	return mes;
}

FormatNumber(number)
{
	new value[32], length;

	format(value, sizeof(value), "%i", (number < 0) ? (-number) : (number));

	if ((length = strlen(value)) > 3)
	{
		for (new i = length, l = 0; --i >= 0; l ++) 
		{
		    if ((l > 0) && (l % 3 == 0)) strins(value, ",", i + 1);
		}
	}

	if (number < 0)	strins(value, "-", 0);

	return value;
}

GetFullDate()
{
	new date[56], year, month, day, hour, minute, second;

	getdate(year, month, day);
	gettime(hour, minute, second);
	format(date, sizeof(date), "%02d/%02d/%i, %02d:%02d:%02d", day, month, year, hour, minute, second);
	return date;
}

SetCurrentTime()
{
	gettime(server_hour);
	SetWorldTime(server_hour);
	return 1;
}

randomEx(min, max)
{
	new rand = random(max-min)+min;
	return rand;
}

RemoveAlpha(color)
{
    return (color & ~0xFF);
}

ClearChatbox(playerid, lines)
{
	for(new i=0; i<lines; i++)
	{
		SCM(playerid, COLOR_GREY, " ");
	}
	return 1;
}

ClearChatboxForAll(lines)
{
	for(new i=0; i<lines; i++)
	{
		SCMALL(COLOR_GREY, " ");
	}
	return 1;
}

SaveAllPlayers() //сохранение всех
{
	foreach(new i : Player)
	{
		KickEx(i);
	}
	return 1;
}

