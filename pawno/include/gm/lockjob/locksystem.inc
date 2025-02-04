new
    bool:LockPizza,
    bool:LockTruck,
    bool:LockTrash,
    bool:LockBank;

CMD:gglock(playerid,params[])
{

	new option[30];
    if (!CheckAdmin(playerid, ADMIN_LEVEL_1))	return SendNotAdmin(playerid);
	if (sscanf(params, "s[30]", option))
	{
		SendHelpMessage(playerid, "/lock [pizza / truck / trash / bank ]");
		return 1;
	}
    if (CompareStrings(option, "pizza"))
	{
        if(LockPizza == false) {
            LockPizza = true;
            SendClientMessageToAll(COLOR_YELLOW, "[Locked System] He thong 'cong viec' Pizza da bi khoa.");
        }
        else if(LockPizza == true) {
            LockPizza = false;
            SendClientMessageToAll(COLOR_YELLOW, "[Locked System] He thong 'cong viec' Pizza da mo khoa.");
        }
    }
    if (CompareStrings(option, "truck"))
	{
        if(LockTruck == false) {
            LockTruck = true;
            SendClientMessageToAll(COLOR_YELLOW, "[Locked System] He thong 'cong viec' Truck da bi khoa.");
        }
        else if(LockTruck == true) {
            LockTruck = false;
            SendClientMessageToAll(COLOR_YELLOW, "[Locked System] He thong 'cong viec' Truck da mo khoa.");
        }
    }
    if (CompareStrings(option, "trash"))
	{
        if(LockTrash == false) {
            LockTrash = true;
            SendClientMessageToAll(COLOR_YELLOW, "[Locked System] He thong 'cong viec' Trash da bi khoa.");
        }
        else if(LockTrash == true) {
            LockTrash = false;
            SendClientMessageToAll(COLOR_YELLOW, "[Locked System] He thong 'cong viec' Trash da mo khoa.");
        }
    }
    if (CompareStrings(option, "bank"))
	{
        if(LockBank == false) {
            LockBank = true;
            SendClientMessageToAll(COLOR_YELLOW, "[Locked System] He thong 'giao dich' Bank da bi khoa.");
        }
        else if(LockBank == true) {
            LockBank = false;
            SendClientMessageToAll(COLOR_YELLOW, "[Locked System] He thong 'giao dich' Bank da mo khoa.");
        }
    }
    return 1;
}