Dialog:ANTICHEAT_SETTINGS(playerid, response, listitem, inputtext[]) // Главное меню настроект анти-чита 
{ 
    if (!response) // Если игрок закрыл диалог 
    { 
        pAntiCheatSettingsPage{playerid} = 0; // Присваиваем значение 0 переменной, хранящей номер страницы настроек анти-чита, на которой находится игрок 
        return 1; // Закрываем диалог 
    } 

    if (!strcmp(inputtext, AC_DIALOG_NEXT_PAGE_TEXT)) // Если игрок нажал на кнопку перелистывания на следующую страницу 
    { 
        pAntiCheatSettingsPage{playerid}++; // Инкрементируем (прибавляем 1) значение переменной, хранящей номер страницы настроек анти-чита, на которой находится игрок 
    } 
    else if (!strcmp(inputtext, AC_DIALOG_PREVIOUS_PAGE_TEXT)) // Если игрок нажал на кнопку перелистывания на предыдущую страницу 
    { 
        pAntiCheatSettingsPage{playerid}--; // Декрементируем (убавляем 1) значение переменной, хранящей номер страницы настроек анти-чита, на которой находится игрок 
    } 
    else // Если игрко выбрал какой-либо из кодов анти-чита 
    { 
        pAntiCheatSettingsEditCodeId[playerid] = pAntiCheatSettingsMenuListData[playerid][listitem]; // Присваиваем переменной, хранящей номер кода анти-чита, который редактирует игрок, номер кода, который он выбрал 
        return ShowPlayer_AntiCheatEditCode(playerid, pAntiCheatSettingsEditCodeId[playerid]); // Показываем игроку диалог настройки кода анти-чита 
    } 
    return ShowPlayer_AntiCheatSettings(playerid); // Относится к выбору следующей и предыдущей страницы. Заново показываем игроку главное меню настройки анти-чита. 
} 

Dialog:ANTICHEAT_EDIT_CODE(playerid, response, listitem, inputtext[]) // Меню настройки определённого кода анти-чита 
{ 
    if (!response) // Если игрок закрыл диалог 
    { 
        pAntiCheatSettingsEditCodeId[playerid] = -1; // Присваиваем переменной, хранящей идентификатор (ID) кода анти-чита, который редактирует игрок, занчение -1 
        return ShowPlayer_AntiCheatSettings(playerid); // Показываем игроку главное меню настроек анти-чита 
    } 

    new
        item = pAntiCheatSettingsEditCodeId[playerid]; // Создаём локальную переменную item, которая примет значение кода анти-чита, который редактирует игрок

    if (AC_CODE_TRIGGER_TYPE[item] == listitem) // Если игрок пытается присвоить коду уже присвоенный ему тип срабатывания
        return ShowPlayer_AntiCheatSettings(playerid); // Показываем главное меню настроек анти-чита

    if (AC_CODE_TRIGGER_TYPE[item] == AC_CODE_TRIGGER_TYPE_DISABLED && listitem != AC_CODE_TRIGGER_TYPE_DISABLED)
        EnableAntiCheat(item, 1);

    AC_CODE_TRIGGER_TYPE[item] = listitem; // Если же игрок выбрал другой тип срабатывания - присваиваем его переменной

    new 
        sql_query[101 - 4 + 1 + 2]; 

    // Форматируем запрос об обновлении данных указаного кода анти-чита в базу данных 
    format(sql_query, sizeof(sql_query), "UPDATE "AC_TABLE_SETTINGS" SET `"AC_TABLE_FIELD_TRIGGER"` = '%d' WHERE `"AC_TABLE_FIELD_CODE"` = '%d'", 
        listitem, 
        item); 

    mysql_function_query(dbHandle, sql_query, false, "", ""); // Отправляем запрос в базу данных 
    return ShowPlayer_AntiCheatSettings(playerid); // Показываем главное меню настроек анти-чита 
} 