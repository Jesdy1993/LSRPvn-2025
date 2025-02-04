#include <YSI_Coding\y_hooks>

new Tackle[MAX_PLAYERS],
	BeanBag[MAX_PLAYERS],
	BiBeanBag[MAX_PLAYERS],
	BiBeanbag2[MAX_PLAYERS],
	BeanbagAntiBH[MAX_PLAYERS];

new HandCuff[MAX_PLAYERS];
new DangBiTazer[MAX_PLAYERS];
hook OnPlayerConnect(playerid)
{
	BiBeanBag[playerid] = 0;
	BeanBag[playerid] = 0;
	BiBeanbag2[playerid] = 0;
	Tackle[playerid] = 0;
	BeanbagAntiBH[playerid] = 0;
	HandCuff[playerid] = 0;
	return 1;
}


hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys && KEY_JUMP && BeanbagAntiBH[playerid] >= 1)
    {
    	ApplyAnimation(playerid,"PED","FALL_collapse", 4.1, 0, 1, 1, 0, 0, 1);
    }
    if(newkeys && KEY_SPRINT && BeanbagAntiBH[playerid] >= 1)
    {
    	ApplyAnimation(playerid,"PED","FALL_collapse", 4.1, 0, 1, 1, 0, 0, 1);
    }
    if(newkeys && KEY_JUMP && BeanbagAntiBH[playerid] == 2) return 1;
    return 1;
}

hook OnPlayerUpdate(playerid)
{
	if(BeanbagAntiBH[playerid] == 2)
	{
		ApplyAnimation(playerid, "SWEET", "Sweet_injuredloop", 4.0, 0, 1, 1, 1, 0, 1);
	}
	return 1;
}

hook OnPlayerGiveDamage(playerid, damagedid, Float: amount, weaponid)
{
	new Float:hp, Float:armor, string[128];
    if(BeanBag[playerid] == 1 && IsACop(playerid))
    {
		if(PlayerInfo[damagedid][pInjured] == 0)
		{	
			if(weaponid == 25) 
			{
				if(BiBeanBag[damagedid] == 1)
				{
					GetPlayerHealth(damagedid, hp);
					GetPlayerArmour(damagedid, armor);
					SetPlayerHealth(damagedid, hp);
					SetPlayerArmour(damagedid, armor);
					SendErrorMessage(playerid, "  Nguoi choi nay dang bi choang.");
					ApplyAnimation(damagedid, "SWEET", "Sweet_injuredloop", 4.0, 0, 1, 1, 1, 0, 1);
					SetPlayerDrunkLevel(damagedid, 500000);
					return 1;
				}
				switch(random(100))
				{
					case 0 .. 10:
					{
					    GetPlayerHealth(damagedid, hp);
						GetPlayerArmour(damagedid, armor);
						SetPlayerHealth(damagedid, hp);
						SetPlayerArmour(damagedid, armor);
						SendClientMessageEx(damagedid, COLOR_CHAT, "{6084BD}[Beanbag]{9E9E9E} Ban da bi choang boi dan cao su.");
						format(string, sizeof(string), "{FF8000}*{C2A2DA} %s su dung khau Less-Lethal Shotgun ban vao %s.",GetPlayerNameEx(playerid), GetPlayerNameEx(damagedid));
						ProxDetector(10.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
						SetPlayerDrunkLevel(damagedid, 500000);
						if(IsPlayerInAnyVehicle(damagedid))
						{
							new Float:slx, Float:sly, Float:slz;
							GetPlayerPos(damagedid, slx, sly, slz);
							SetPlayerPos(damagedid, slx, sly, slz+1.5);
							PlayerPlaySound(damagedid, 1130, slx, sly, slz+1.5);
						}
						BiBeanbag2[damagedid] = 1;
						SetPlayerWeather(damagedid, -66);
						SetTimerEx("ShotBeanBag2",10000,false,"d",damagedid);
						BeanbagAntiBH[damagedid] = 1;
					}
					case 11 .. 100:
					{
						GetPlayerHealth(damagedid, hp);
						GetPlayerArmour(damagedid, armor);
						SetPlayerHealth(damagedid, hp);
						SetPlayerArmour(damagedid, armor);
						SendClientMessageEx(damagedid, COLOR_CHAT, "{6084BD}[Beanbag]{9E9E9E} Ban da bi choang va guc xuong boi dan cao su.");
                		format(string, sizeof(string), "{FF8000}*{C2A2DA} %s su dung khau Less-Lethal Shotgun ban vao %s.",GetPlayerNameEx(playerid), GetPlayerNameEx(damagedid));
						ProxDetector(10.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
						SetPlayerDrunkLevel(damagedid, 500000);
						if(IsPlayerInAnyVehicle(damagedid))
						{
							new Float:slx, Float:sly, Float:slz;
							GetPlayerPos(damagedid, slx, sly, slz);
							SetPlayerPos(damagedid, slx, sly, slz+1.5);
							PlayerPlaySound(damagedid, 1130, slx, sly, slz+1.5);
						}
						BiBeanBag[damagedid] = 1;
						SetPlayerWeather(damagedid, -66);
						ApplyAnimation(damagedid, "SWEET", "Sweet_injuredloop", 4.0, 0, 1, 1, 1, 0, 1);
						SetTimerEx("ShotBeanBag",10000,false,"d",damagedid);
						BeanbagAntiBH[damagedid] = 2;
					}
				}
			}	
		}
	}
    if (weaponid == 0 && Tackle[playerid] == 1)
	{
		GetPlayerHealth(damagedid, hp);
		GetPlayerArmour(damagedid, armor);
		SetPlayerHealth(damagedid, hp);
		SetPlayerArmour(damagedid, armor);
        new vehicle = GetPlayerVehicleID(damagedid);  
        if (vehicle && !IsABike(vehicle))	return 1; 
        if (vehicle)												RemovePlayerFromVehicle(damagedid);
        if (PlayerInfo[playerid][pInjured]) 		return SendClientMessageEx(playerid, COLOR_CHAT, "{6084BD}[LS:RP]{9E9E9E} Ban dang bi thuong.");
        format(string, sizeof(string), "{FF8000}*{C2A2DA} %s tien den bam chat nguoi %s de xuong co gang khong che.",GetPlayerNameEx(playerid), GetPlayerNameEx(damagedid));
		ProxDetector(10.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		SendClientMessageEx(damagedid, COLOR_CHAT, "{6084BD}[Tackle]{9E9E9E} Ban da bi khong che.");
        ApplyAnimation(damagedid, "PARACHUTE", "FALL_skyDive_DIE", 4.0, 0, 1, 1, 1, -1);
        ApplyAnimation(playerid, "ped", "EV_dive", 4.0, 0, 1, 1, 1, -1);
        Tackle[playerid] = 0;
        SetTimerEx("CountDownTackle",10000,false,"d",damagedid);
	}
	return 1;
}

forward CountDownTackle(playerid);
public CountDownTackle(playerid)
{
    SetPlayerDrunkLevel(playerid, 0);
    SetPlayerWeather(playerid, 2);
    Tackle[playerid] = 0;
    ApplyAnimation(playerid, "PARACHUTE", "FALL_skyDive_DIE", 4.0, 0, 1, 1, 1, -1);
}

forward ShotBeanBag(playerid);
public ShotBeanBag(playerid)
{
    SetPlayerDrunkLevel(playerid, 0);
    SetPlayerWeather(playerid, 2);
    BiBeanBag[playerid] = 0;
    ApplyAnimation(playerid, "SWEET", "Sweet_injuredloop", 4.0, 0, 1, 1, 0, 0, 1);
    SetPlayerDrunkLevel(playerid, 0);
    BeanbagAntiBH[playerid] = 0;
}

forward BrokenHandcuff(playerid);
public BrokenHandcuff(playerid)
{
	GameTextForPlayer(playerid, "~g~Thao cong", 2500, 3);
	RemovePlayerAttachedObject(playerid, 7);
	DeletePVar(playerid, "PlayerCuffed");
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	ClearAnimations(playerid);
	HandCuff[playerid] = 0;
}

forward ShotBeanBag2(playerid);
public ShotBeanBag2(playerid)
{
    SetPlayerDrunkLevel(playerid, 0);
    SetPlayerWeather(playerid, 2);
    BiBeanbag2[playerid] = 0;
    SetPlayerDrunkLevel(playerid, 0);
    BeanbagAntiBH[playerid] = 0;
}

CMD:beanbag(playerid, params[])
{	
	if (PlayerInfo[playerid][pDuty] == 0)
    {
        SendClientMessageEx(playerid, COLOR_LIGHTRED, "ERROR: Ban can phai trong gio lam viec.");
        return 1;
    }
	if(GetPVarInt(playerid, "Injured") == 1)
    {
        SendClientMessageEx(playerid, COLOR_LIGHTRED, "ERROR: Ban khong the lam dieu nay bay gio.");
        return 1;
	}
	if(IsACop(playerid))
	{
		
		if(GetPlayerWeapon(playerid) == 25)
		{
			new string[128];
			if(BeanBag[playerid] == 0)
			{
			      BeanBag[playerid] = 1;
			      format(string, sizeof(string), "{FF8000}*{C2A2DA} %s da lay dan cao su vao Shotgun.", GetPlayerNameEx(playerid));
		          ProxDetector(10.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			      ShowNotifyTextMain(playerid,  "Dan cao su: ~g~Bat~w~");
			}
			else if(BeanBag[playerid] == 1)
		    {
				  BeanBag[playerid] = 0;
			      format(string, sizeof(string), "{FF8000}*{C2A2DA} %s da thao dan cao su ra khoi sung Shotgun.", GetPlayerNameEx(playerid));
		          ProxDetector(10.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				  ShowNotifyTextMain(playerid,  "Dan cao su: ~r~Tat~w~");
			}
		} else return SendClientMessage(playerid, COLOR_LIGHTRED, "ERROR: Ban can phai co khau Shotgun tren tay.");
	}
	else
	{
		return SendClientMessage(playerid, COLOR_LIGHTRED, "ERROR: Ban khong phai nhan vien canh sat.");
	}
	return 1;
}

CMD:tackle(playerid, params[])
{
	if (!IsACop(playerid)) return SendClientMessage(playerid, COLOR_LIGHTRED, "ERROR: Ban khong phai nhan vien canh sat.");
	if (Tackle[playerid] == 0)
	{
		Tackle[playerid] = 1;
		ShowNotifyTextMain(playerid, "Che do tackle '~g~BAT~w~'");
	}
	else
	{
		Tackle[playerid] = 0;
		ShowNotifyTextMain(playerid, "Che do tackle '~r~TAT~w~'");
	}
	return 1;
}

CMD:handcuff1(playerid, params[])
{
	if(IsACop(playerid))
	{

		new string[128], giveplayerid;
		if(sscanf(params, "u", giveplayerid)) return SendUsageMessage(playerid, "  /handcuff1 [playerid]");
		if(IsPlayerConnected(giveplayerid))
		{
			if (ProxDetectorS(8.0, playerid, giveplayerid))
			{
				if(giveplayerid == playerid) return 1;
				if(HandCuff[giveplayerid] == 2) return ShowNotifyTextMain(playerid, "Nguoi choi nay da bi cong tay");
				if(IsPlayerInAnyVehicle(giveplayerid) == 1) return SendClientMessageEx(playerid, COLOR_LIGHTRED, "ERROR: Ban khong the cong khi nguoi choi dang o tren xe.");
				new Float:HP;
				GetPlayerHealth(playerid, HP);
				if(HP >= 1)
				{
					format(string, sizeof(string), "[Hand-Cuff] Ban da cong tay %s, hay su dung {FF6347}/unhandcuff{9E9E9E} de thao cong.", GetPlayerNameEx(giveplayerid));
					SendClientMessageEx(playerid, COLOR_BASIC, string);
					format(string, sizeof(string), "* %s da keo hai tay %s ve sau siet chat va cong lai.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
					SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 10.0, 4000);
					GameTextForPlayer(giveplayerid, "~r~Hand Cuff", 2500, 3);
					ClearAnimations(giveplayerid);
					SetPlayerSpecialAction(giveplayerid, SPECIAL_ACTION_CUFFED);
                    SetPlayerAttachedObject(giveplayerid, 7, 19418, 6, -0.011, 0.028, -0.022, -15.600012, -33.699977, -81.700035, 1.0, 1.0, 1.0);
					HandCuff[giveplayerid] = 2;
					SetPVarInt(giveplayerid, "PlayerCuffed", 2);
					PlayerCuffed[giveplayerid] = 2;
					DeletePVar(giveplayerid, "IsFrozen");
					TogglePlayerControllable(giveplayerid, 1);
				}
			}
			else return SendClientMessageEx(playerid, COLOR_LIGHTRED, "ERROR: Ban khong dung gan nguoi choi.");
		}
	}
	return 1;
}

CMD:keoday(playerid, params[])
{
	if(IsACop(playerid))
	{

		new giveplayerid;
		if(sscanf(params, "u", giveplayerid)) return SendUsageMessage(playerid, "  /keoday [playerid]");
		if(IsPlayerConnected(giveplayerid))
		{
			if (ProxDetectorS(8.0, playerid, giveplayerid))
			{
				if(giveplayerid == playerid) return 1;
				if(IsPlayerInAnyVehicle(giveplayerid) == 1) return SendErrorMessage(playerid, "  Ban khong the keo day khi nguoi choi dang o tren xe.");
				new Float:HP;
				GetPlayerHealth(playerid, HP);
				if(HP >= 1)
				{
					ClearAnimations(giveplayerid);
					DeletePVar(giveplayerid, "IsFrozen");
					TogglePlayerControllable(giveplayerid, 1);
				}
			}
			else return SendClientMessageEx(playerid, COLOR_LIGHTRED, "ERROR: Ban khong dung gan nguoi choi.");
		}
	}
	return 1;
}

CMD:handcuff2(playerid, params[])
{
	if(IsACop(playerid))
	{

		new string[128], giveplayerid;
		if(sscanf(params, "u", giveplayerid)) return SendUsageMessage(playerid, "  /handcuff2 [playerid]");
		if(IsPlayerConnected(giveplayerid))
		{
			if (ProxDetectorS(8.0, playerid, giveplayerid))
			{
				if(giveplayerid == playerid) return 1;
				if(HandCuff[giveplayerid] == 2) return ShowNotifyTextMain(playerid, "Nguoi choi nay da bi cong tay");
				if(IsPlayerInAnyVehicle(giveplayerid) == 1) return SendClientMessageEx(playerid, COLOR_LIGHTRED, "ERROR: Ban khong the cong khi nguoi choi dang o tren xe.");
				new Float:HP;
				GetPlayerHealth(playerid, HP);
				if(HP >= 1)
				{
					format(string, sizeof(string), "{58a7a4}[Hand-Cuff]{9E9E9E} Ban da cong tay %s, hay su dung {FF6347}/unhandcuff{9E9E9E} de thao cong.", GetPlayerNameEx(giveplayerid));
					SendClientMessageEx(playerid, COLOR_CHAT, string);
					format(string, sizeof(string), "{FF8000}*{C2A2DA} %s da keo hai tay %s ve sau siet chat va cong lai.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
					//ProxDetector(10.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
					SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 10.0, 4000);
					GameTextForPlayer(giveplayerid, "~r~Hand Cuff", 2500, 3);
					ClearAnimations(giveplayerid);
					SetPlayerSpecialAction(giveplayerid, SPECIAL_ACTION_CUFFED);
                    SetPlayerAttachedObject(giveplayerid, 7, 19418, 6, -0.011, 0.028, -0.022, -15.600012, -33.699977, -81.700035, 1.0, 1.0, 1.0);
					HandCuff[giveplayerid] = 2;
					SetPVarInt(giveplayerid, "PlayerCuffed", 2);
					PlayerCuffed[giveplayerid] = 2;
					DeletePVar(giveplayerid, "IsFrozen");
					PlayAnimEx(giveplayerid, "ped", "FLOOR_hit_f", 4.0, 0, 1, 1, 1, 0, 1);
				//TogglePlayerControllable(giveplayerid, 1);
				}
			}
			else return SendClientMessageEx(playerid, COLOR_LIGHTRED, "ERROR: Ban khong dung gan nguoi choi.");
		}
	}
	return 1;
}

CMD:unhandcuff(playerid, params[])
{
	if(IsACop(playerid))
	{
		new string[128], giveplayerid;
		if(sscanf(params, "u", giveplayerid)) return SendUsageMessage(playerid, "  /unhandcuff [Player]");

		if(IsPlayerConnected(giveplayerid))
		{
			if (ProxDetectorS(8.0, playerid, giveplayerid))
			{
				/*if(PlayerInfo[giveplayerid][pJailTime] >= 1) da mo khoa va thao cong tay cho
				{
					SendClientMessageEx(playerid, COLOR_WHITE, "You can't uncuff a jailed player.");
					return 1;
				} */
				if(giveplayerid == playerid) return 1;
				if(IsPlayerInAnyVehicle(giveplayerid) == 1) return SendClientMessageEx(playerid, COLOR_LIGHTRED, "ERROR: Ban khong the thao cong khi nguoi choi dang o tren xe.");
				if(HandCuff[giveplayerid]>1)
				{
					format(string, sizeof(string), "{58a7a4}[UNHANDCUFF]{9E9E9E} Ban da duoc thao cong tay boi Officer %s.", GetPlayerNameEx(playerid));
					SendClientMessageEx(giveplayerid, COLOR_CHAT, string);
					format(string, sizeof(string), "{58a7a4}[UNHANDCUFF]{9E9E9E} Ban da thao cong tay doi tuong %s.", GetPlayerNameEx(giveplayerid));
					SendClientMessageEx(playerid, COLOR_CHAT, string);
					format(string, sizeof(string), "{FF8000}*{C2A2DA} %s da mo khoa va thao cong tay cho %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
					ProxDetector(10.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
					GameTextForPlayer(giveplayerid, "~g~Thao cong", 2500, 3);
					RemovePlayerAttachedObject(giveplayerid, 7);
					DeletePVar(giveplayerid, "PlayerCuffed");
					SetPlayerSpecialAction(giveplayerid, SPECIAL_ACTION_NONE);
					PlayerCuffed[giveplayerid] = 0;
					ClearAnimations(giveplayerid);
					HandCuff[giveplayerid] = 0;
				}
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_LIGHTRED, "ERROR: Ban khong dung gan nguoi choi.");
				return 1;
			}
		}
	}
	return 1;
}

CMD:brokenhandcuffssssss(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] == 0) return 1;
	new string[128], giveplayerid;
	if(sscanf(params, "u", giveplayerid)) return SendUsageMessage(playerid, "  /unhandcuff [Player]");
	if(IsPlayerConnected(giveplayerid))
	{
		if (ProxDetectorS(8.0, playerid, giveplayerid))
		{
			/*if(PlayerInfo[giveplayerid][pJailTime] >= 1) da mo khoa va thao cong tay cho
			{
				SendClientMessageEx(playerid, COLOR_WHITE, "You can't uncuff a jailed player.");
				return 1;
			} */
			if(giveplayerid == playerid) return 1;
			if(IsPlayerInAnyVehicle(giveplayerid) == 1) return SendClientMessageEx(playerid, COLOR_LIGHTRED, "ERROR: Ban khong the thao cong khi nguoi choi dang o tren xe.");
			if(HandCuff[giveplayerid]>1)
			{
				format(string, sizeof(string), "{58a7a4}[BROKEN HANDCUFF]{9E9E9E} Cong tay cua ban dang duoc pha boi %s.", GetPlayerNameEx(playerid));
				SendClientMessageEx(giveplayerid, COLOR_CHAT, string);
				format(string, sizeof(string), "{58a7a4}[BROKEN HANDCUFF]{9E9E9E} Ban dang co gang pha cong tay cho %s.", GetPlayerNameEx(giveplayerid));
				SendClientMessageEx(playerid, COLOR_CHAT, string);
				format(string, sizeof(string), "{FF8000}*{C2A2DA} %s dang co gang pha cong tay cho %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
				ProxDetector(10.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				SetTimerEx("BrokenHandcuff",10000,false,"d",giveplayerid);
			}
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_LIGHTRED, "ERROR: Ban khong dung gan nguoi choi.");
			return 1;
		}
	}
	return 1;
}
