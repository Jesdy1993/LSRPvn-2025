//=====================INCLUDES=====================

#include 	<a_samp>
#include	<sscanf2>
#include <YSI\y_hooks>

//=====================DIALOGS======================

#define	DIALOG_DAMAGE 1927

//==================CONTROL PANEL===================

#define	MAX_DAMAGES	1000

//===================ENUMERATORS====================

enum dmgInfo
{
	Float:dmgDamage,
	dmgWeapon,
	dmgBodypart,
	dmgKevlarhit,
	dmgSeconds,
}
new DamageInfo[MAX_PLAYERS][MAX_DAMAGES][dmgInfo];

hook OnPlayerConnect(playerid)
{
	ResetPlayerDamages(playerid);
	return 1;
}

CMD:damages(playerid, params[])
{
	new id;
	
	if(sscanf(params, "u", id)) return SendClientMessage(playerid, 0xFF6347FF, "SU DUNG: {9E9E9E}/damages [playerid]");
	if(!ProxDetectorS(4.0, id, playerid)) return ShowNotifyTextMain(playerid, "~w~Ban ~r~khong o gan~w~ nguoi choi nay.");
	ShowPlayerDamages(id, playerid);
	return 1;
}

/*
GetBodyPartName(bodypart)
{
	new part[32];
	switch(bodypart)
	{
		case BODY_PART_TORSO: 		part = "Than (Torso)";		
		case BODY_PART_GROIN: 		part = "Hang (Groin)";			
		case BODY_PART_LEFT_ARM: 	part = "Tay phai";	
		case BODY_PART_RIGHT_ARM: 	part = "Tay trai";	
		case BODY_PART_LEFT_LEG: 	part = "Chan trai";	
		case BODY_PART_RIGHT_LEG: 	part = "CHAN phai";	
		case BODY_PART_HEAD: 		part = "Dau";		
		default: 					part = "Khong xac dinh";	
	}
	return part;
}*/

stock ResetPlayerDamages(playerid)
{
	for(new id = 0; id < MAX_DAMAGES; id++)
	{
		if(DamageInfo[playerid][id][dmgDamage] != 0)
		{
			DamageInfo[playerid][id][dmgDamage] = 0.0;
			DamageInfo[playerid][id][dmgWeapon] = 0;
			DamageInfo[playerid][id][dmgBodypart] = 0;
			DamageInfo[playerid][id][dmgKevlarhit] = 0;
			DamageInfo[playerid][id][dmgSeconds] = 0;
		}
	}
	return 1;
}

stock ShowPlayerDamages(playerid, toid)
{
	new str[5024], str1[5024], count = 0, name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));

	for(new id = 0; id < MAX_DAMAGES; id++)
	{
		if(DamageInfo[playerid][id][dmgDamage] != 0) count++;
	}

	if(count == 0) return ShowPlayerDialog(toid, DIALOG_DAMAGE, DIALOG_STYLE_LIST, name, "Nguoi nay khong co sat thuong nao duoc gay len...", "<", "");
	else if(count > 0)
	{
		for(new id = 0; id < MAX_DAMAGES; id++)
		{
			if(DamageInfo[playerid][id][dmgDamage] != 0)
			{
				new part[100];
				switch(DamageInfo[playerid][id][dmgBodypart])
				{
					case 3:  part = "Than (Torso)";		
					case 4:  part = "Hang (Groin)";			
					case 5:  part = "Tay phai";	
					case 6:  part = "Tay trai";	
					case 7:  part = "Chan trai";	
					case 8:  part = "Chan phai";	
					case 9:  part = "Dau";		
					default: part = "Khong xac dinh";	

				}

				new WeaponName[64];
				if(DamageInfo[playerid][id][dmgWeapon] == 0) format(WeaponName, sizeof(WeaponName), "Nam dam");
				else format(WeaponName, sizeof(WeaponName), "%s", GetWeaponNameEx(DamageInfo[playerid][id][dmgWeapon]));

				format(str1, sizeof str1, "{607699}[%0.1f DMG] {31435e}[%s] {607699}[Vi tri: %s] {31435e}[Trung giap: %d vien] {607699}[%d giay truoc]\n", 
					DamageInfo[playerid][id][dmgDamage], 
					WeaponName, 
					part, 
					DamageInfo[playerid][id][dmgKevlarhit], gettime() - DamageInfo[playerid][id][dmgSeconds]
				);	

				strcat(str, str1);
			}
		}
		ShowPlayerDialog(toid, DIALOG_DAMAGE, DIALOG_STYLE_LIST, name, str, "<", "");

	}
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
	if (dialogid == DIALOG_DAMAGE) {
		if (response || !response)
			return 1;
	}
	return 1;
}