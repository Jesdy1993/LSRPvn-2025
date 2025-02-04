SQL_OnQueryError(errorid, error[], callback[], query[])
{
    if (errorid == CR_SERVER_LOST)
	{
	    dbHandle = mysql_connect(SQL_HOST, SQL_USER, SQL_DB, SQL_PASS);
		mysql_log();
		if (mysql_errno() != 0) printf("[MySQL]: That bai khi ket noi toi %s", SQL_HOST);
		else
		{
			printf("[MySQL]: Ket noi lai toi %s voi tai khoan %s", SQL_HOST, SQL_USER);
			
			mysql_set_charset("cp1251");
		    mysql_query(dbHandle, "SET NAMES cp1251;", false);
			mysql_query(dbHandle, "SET SESSION character_set_server='utf8';", false);

		    new name[32];
			mysql_get_charset(name, dbHandle, 32);
			printf("[MySQL]: Encoding: %s", name);
		}
	}
	printf("[MySQL]: <|| error: %s | callback: %s | query: %s ||>", error, callback, query);
    return 1;
}

SQL_OnGameModeInit()
{
	dbHandle = mysql_connect(SQL_HOST, SQL_USER, SQL_DB, SQL_PASS);
	mysql_log();
	if (mysql_errno() != 0) print("[MySQL]: That bai khi ket noi voi MySQL");
	else
	{
        print("[MySQL]: Ket noi toi MySQL thanh cong.");

        mysql_set_charset("cp1251");
	    mysql_tquery(dbHandle, "SET NAMES cp1251;");
		mysql_tquery(dbHandle, "SET SESSION character_set_server='utf8';");

		/*mysql_tquery(dbHandle, "UPDATE `users` SET `online`=0 WHERE `online` = 1");*/
	}
	return 1;
}//î
