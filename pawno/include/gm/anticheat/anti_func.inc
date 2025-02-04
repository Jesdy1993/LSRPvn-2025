// ������� �������� ������ � ���������� ����� ����-���� �� ���� ������
stock UploadAntiCheatSettings()  
{  
    mysql_tquery(dbHandle, "SELECT * FROM `anticheat_settings`", "UploadAntiCheat");
}

this::UploadAntiCheat()
{
    new rows = cache_num_rows(), tick = GetTickCount();

	if (!rows) {  
        print("[MySQL]: Anti-cheat settings were not found in the database. Loading of the mod stopped - configure anti-cheat. ");
        return GameModeExit();  
    }  

    for(new i = 0; i < AC_MAX_CODES; i++)
    {
        AC_CODE_TRIGGER_TYPE[i] = cache_get_field_content_int(i, "ac_code_trigger_type");

        if (AC_CODE_TRIGGER_TYPE[i] == AC_CODE_TRIGGER_TYPE_DISABLED) {
            EnableAntiCheat(i, 0);
        }
    }

    new mes[128];
    format(mes, sizeof(mes), "*** [ANTICHEAT]: Anti-cheat settings loaded successfully (loaded: %i). Time: %i ��.", rows, GetTickCount() - tick);  
    print(mes);

    return 1;  
}

stock Anticheat_OnPlayerConnect(playerid)
{
    /*
        � ����� ����������� �������� -1 ������ ������ �������, ������� �������� ��
        ����� ���������� ������������ ������� ���� ����-���� �� ������
    */
    for(new i = 0; i < AC_MAX_CODES; i++)
        pAntiCheatLastCodeTriggerTime[playerid][i] = -1;

    pAntiCheatSettingsPage{playerid} = 0; // ����������� �������� 0 ����������, �������� ����� �������� �������� ����-����, �� ������� ��������� �����
    pAntiCheatSettingsEditCodeId[playerid] = -1; // ����������� ����������, �������� ������������� (ID) ���� ����-����, ������� ����������� �����, �������� -1
    return 1;
} 

this::OnCheatDetected(playerid, ip_address[], type, code)
{
    if (type == AC_GLOBAL_TRIGGER_TYPE_PLAYER)
    {
        switch(code)
        {
            case 5, 6, 11, 22: 
            {
                return 1;
            }
            case 32: // CarJack
            {
                new 
                    Float:x, 
                    Float:y, 
                    Float:z;

                AntiCheatGetPos(playerid, x, y, z);
                return SetPlayerPos(playerid, x, y, z);
            }
            case 40: // Sandbox
            {
                SendClientMessage(playerid, -1, MAX_CONNECTS_MSG);
                return AntiCheatKickWithDesync(playerid, code);
            }
            case 41: // Invalid Version
            {
                SendClientMessage(playerid, -1, UNKNOWN_CLIENT_MSG);
                return AntiCheatKickWithDesync(playerid, code);
            }
            default:
            {
                if (gettime() - pAntiCheatLastCodeTriggerTime[playerid][code] < AC_TRIGGER_ANTIFLOOD_TIME)
                    return 1;

                pAntiCheatLastCodeTriggerTime[playerid][code] = gettime();
                AC_CODE_TRIGGERED_COUNT[code]++;

                new
                    string[88 - 10 + MAX_PLAYER_NAME + 5 + AC_MAX_CODE_NAME_LENGTH + AC_MAX_CODE_LENGTH],
                    trigger_type = AC_CODE_TRIGGER_TYPE[code];

                switch(trigger_type)
                {
                    case AC_CODE_TRIGGER_TYPE_DISABLED: return 1;
                    case AC_CODE_TRIGGER_TYPE_WARNING:
                    {
                        SendWarningMessage(playerid, "Ban dang bi nghi ngo su dung hack va ban da duoc canh cao: %s [code: %03d].", AC_CODE_NAME[code], code);
                        SendAdmMessage("%s[%d] suspected of using cheat programs: %s [code: %03d].", GetNameEx(playerid), playerid, AC_CODE_NAME[code], code);
                    }  
                    case AC_CODE_TRIGGER_TYPE_KICK: 
                    {
                        SendAdmMessage("%s[%d] was kicked on suspicion of using cheat programs: %s [code: %03d].", GetNameEx(playerid), playerid, AC_CODE_NAME[code], code);

                        format(string, sizeof(string), "Ban da bi moi ra may chu vi su dung cac phan mem cheat: %s [code: %03d].", AC_CODE_NAME[code], code);
                        SendClientMessage(playerid, -1, string);

                        AntiCheatKickWithDesync(playerid, code);
                    }
                } 
            }
        }
    }
    else // AC_GLOBAL_TRIGGER_TYPE_IP
    {
        AC_CODE_TRIGGERED_COUNT[code]++;

        SendAdmMessage("<AC-BAN-IP> IP address %s da bi cam: %s [code: %03d].", ip_address, AC_CODE_NAME[code], code);

        BlockIpAddress(ip_address, 0);
    }
    return 1;
} 
