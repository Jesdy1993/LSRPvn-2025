#include <YSI\y_hooks>

hook OnPlayerConnect(playerid)
{
	DeletePVar(playerid,#InjuredCount);
    if(IsValidDynamic3DTextLabel(InjuredStatus[playerid] ))
    { 
    	DestroyDynamic3DTextLabel(InjuredStatus[playerid]);
    	InjuredStatus[playerid] = INVALID_3DTEXT_ID;
    }
	DeletePVar(playerid, "InjuredVW");
	DeletePVar(playerid, "InjuredInt");

  	playerHelpUp[playerid] = 0;
  	cancelDMG[playerid] = 0;
  	
}
hook OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid,bodypart)
{
	new Float:ArmourBroken, Float:Armour, Float:Health;
   
    GetPlayerHealth(playerid, Health);
    GetPlayerArmour(playerid, Armour);

 
    if(PlayerInfo[playerid][pInjured] == 0)
    {
        if(Armour >= amount ) {
        	print("testddd");
        	SetPlayerArmour(playerid, Armour-amount);
        }
        else if(Armour < amount ) {
            new Float:ar_last;
            ar_last = amount - Armour;
            SetPlayerArmour(playerid, 0);
            if(Health - amount <= 26 ) {
                SetPlayerInjured(playerid, 0, weaponid);
                return 1;
            }
            new Float:damge;
            damge = Health - amount;
            SetPlayerHealth(playerid,damge);
        }

    }
    else if(PlayerInfo[playerid][pInjured] != 0 && PlayerInfo[playerid][pInjured] != 3)
    {
    	if(weaponid != 0)  SetPVarInt(playerid, #InjuredCount, GetPVarInt(playerid,#InjuredCount) + 3);
    	else if(weaponid == 0)  SetPVarInt(playerid, #InjuredCount, GetPVarInt(playerid,#InjuredCount) + 1);
    	if(GetPVarInt(playerid,#InjuredCount) > 5) {
    		DeletePVar(playerid,#InjuredCount);
    		SetPlayerInjured(playerid, 3, weaponid);
    	}
    }
    new name[40];
    if(UseMask[playerid] == 2 ) {
    	format(name, sizeof(name), "Stranger(%d)",UseMaskCode[playerid]);
    }
    else {
    	format(name, sizeof(name), "%s(%i)", GetPlayerNameEx(playerid),playerid);
    }
    if(PlayerInfo[playerid][pToggleDamge] == false) {
        new bodystr[129];
        format(bodystr, sizeof bodystr, "[DAMAGE] Ban bi {e54343}%s{b4b4b4} su dung vu khi {e54343}%s{b4b4b4} gay sat thuong %.1f",name,GetWeaponNameEx(weaponid),amount);
        SendClientMessageEx(playerid,COLOR_BASIC,bodystr);
        format(bodystr, sizeof bodystr, "[DAMAGE] Ban da su dung vu khi {e54343}%s{b4b4b4} gay cho {e54343}%s{b4b4b4} sat thuong %.1f", GetWeaponNameEx(weaponid),GetPlayerNameEx(playerid),amount);
        SendClientMessageEx(issuerid,COLOR_BASIC,bodystr);    
    }

    return 1;
}
hook OnPlayerDisconnect(playerid)
{
	if(IsValidDynamic3DTextLabel(InjuredStatus[playerid] )) 
    { 
    	DestroyDynamic3DTextLabel(InjuredStatus[playerid]);
    	InjuredStatus[playerid] = INVALID_3DTEXT_ID;
    }
	DeletePVar(playerid, "InjuredVW");
	DeletePVar(playerid, "InjuredInt");


	playerHelpUp[playerid] = 0;
	cancelDMG[playerid] = 0;
    AcceptDeath[playerid] = 0;
}

hook OnPlayerUpdate(playerid)
{
	if((GetTickCount()-GetPVarInt(playerid, "mS_list_time")) > 800 ) {
    	new string[248];
    	if(PlayerInfo[playerid][pInjured] == 1 && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && gPlayerLogged{playerid} == 1 && PlayerBugging[playerid] != 1)
    	{  	   
    
            ShowNotifyTextMain(playerid,"Ban dang ~r~bi thuong~w~ hay goi cap cuu /dichvu medic hoac /chapnhan chet");
            format(string, sizeof(string), "(( Nguoi nay dang bi thuong nhe, su dung '/damages %i' de xem them tinh trang ))", playerid);
            if(IsPlayerEntering{playerid} == true) {
                format(string, sizeof(string), "( Nguoi choi dang duoc cap cuu )", playerid);
            }
        	UpdateDynamic3DTextLabelText(InjuredStatus[playerid], 0xFF6347FF, string);
   //     	TogglePlayerControllable(playerid,0);
    		ApplyAnimation(playerid, "SWEET", "Sweet_injuredloop", 4.1, 1, 0, 0, 1, 0, 1);

    		SetPlayerHealth(playerid, 100);
    	//	TogglePlayerControllable(playerid,0);
    	}
    	if(PlayerInfo[playerid][pInjured] == 2 && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && gPlayerLogged{playerid} == 1 && PlayerBugging[playerid] != 1)
    	{
            ShowNotifyTextMain(playerid,"Ban dang ~r~bi thuong rat nang~w~ hay goi cap cuu /dichvu medic hoac /chapnhan chet");
    		format(string, sizeof(string), "(( Nguoi nay dang bi thuong nang, su dung '/damages %i' de xem them tinh trang ))", playerid);
            if(IsPlayerEntering{playerid} == true) {
                format(string, sizeof(string), "(( Nguoi choi dang duoc cap cuu ))", playerid);
            }
            UpdateDynamic3DTextLabelText(InjuredStatus[playerid], 0xFF6347FF, string);
  //          TogglePlayerControllable(playerid,0);

    	    ApplyAnimation(playerid, "WUZI", "CS_Dead_Guy", 4.1, 0, 0,0, 1, 0, 1);
    	    SetPlayerHealth(playerid, 100);

    	}
    	if(PlayerInfo[playerid][pInjured] == 3 && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && gPlayerLogged{playerid} == 1 && PlayerBugging[playerid] != 1)
    	{
            ShowNotifyTextMain(playerid,"Ban da chet, su dung lenh ~r~/chapnhan chet~w~ de respawn");
            UpdateDynamic3DTextLabelText(InjuredStatus[playerid], 0xFF6347FF, "(( Nguoi choi da chet ))");
   //         TogglePlayerControllable(playerid,0);
    		ApplyAnimation(playerid, "WUZI", "CS_Dead_Guy", 4.1, 0, 0, 0, 1, 0, 1);
    		SetPlayerHealth(playerid, 100);
    		
    	}
        if(PlayerInfo[playerid][pInjured] == 4 && gPlayerLogged{playerid} == 1 && PlayerBugging[playerid] != 1)
        {
            ShowNotifyTextMain(playerid,"Ban dang kiet suc vi tut can xi");
            UpdateDynamic3DTextLabelText(InjuredStatus[playerid], 0xFF6347FF, "(( Nguoi choi dang bi kiet suc ))");
   //         TogglePlayerControllable(playerid,0);
            ApplyAnimation(playerid, "WUZI", "CS_Dead_Guy", 4.1, 0, 0, 0, 1, 0, 1);
            SetPlayerHealth(playerid, 100);
            
        }
    	if(PlayerInfo[playerid][pInjured] == 0 && gPlayerLogged{playerid} == 1)
    	{
    		if(IsValidDynamic3DTextLabel(InjuredStatus[playerid] )) 
    		{ 
    			DestroyDynamic3DTextLabel(InjuredStatus[playerid]);
    			InjuredStatus[playerid] = INVALID_3DTEXT_ID;
    		}
    	}
    
    	if(ConfigPlayerBleed == true && PlayerInfo[playerid][pInjured] == 0)
    	{
    		if(PlayerInfo[playerid][pFireLeg] != 0 && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
    	    {
    	    	new Float:PlayerX, Float:PlayerY, Float:PlayerZ;
    	    	GetPlayerVelocity(playerid, PlayerX, PlayerY, PlayerZ);
    	    	if((GetSpeed(PlayerX, PlayerY, PlayerZ) / 1.609344) > 13.0)
    	    	{
    	    		ShowNotifyTextMain(playerid, "~w~Ban ~r~khong the~w~ chay nhanh hoac nhay, vi chan ban dang ~r~trung dan~w~.",4);
    				ApplyAnimation(playerid,"PED","FALL_collapse", 4.1, 0, 1, 1, 0, 0, 1);
    	    	}
    	    }
	    }
	}
	return 1;
}
stock  Float:GetSpeed(Float:X, Float:Y, Float:Z)
{
	return floatsqroot(floatpower(X, 2.0) + floatpower(Y, 2.0) + floatpower(Z, 2.0)) * 180.0;
}

CMD:checkinj(playerid, params[])
{
    new string[128], giveplayerid;
    if(PlayerInfo[playerid][pAdmin] != 5) return 1;
    if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_BASIC, "{873D37}SU DUNG:{9E9E9E} /checkinj [player]");

    format(string, sizeof(string), "Player Injured = %d", PlayerInfo[giveplayerid][pInjured]);
    SendClientMessage(playerid, COLOR_BASIC, string);
    return 1;
}

stock SetPlayerInjured(playerid, type = 0, weaponid)
{
	new string[514];
	if(type == 0) // bị thương do cận chiến
	{
		if(IsValidDynamic3DTextLabel(InjuredStatus[playerid] )) DestroyDynamic3DTextLabel(InjuredStatus[playerid]);
        InjuredStatus[playerid] = CreateDynamic3DTextLabel(" ", COLOR_LIGHTRED, 0.0, 0.0, -0.95, NT_DISTANCE, .attachedplayer = playerid, .testlos = 1);

		UpdateDynamic3DTextLabelText(InjuredStatus[playerid], 0xFF6347FF, "(( Nguoi choi da bi danh trong thuong ))");



		ApplyAnimation(playerid, "SWEET", "Sweet_injuredloop", 4.1, 1, 0, 0, 1, 0, 1);

		TogglePlayerControllable(playerid,0);
	    SendClientMessage(playerid, COLOR_LIGHTRED, "Nhan vat cua ban da bi danh trong thuong, nhung nguoi khac co the do ban day (/helpup).");
	    PlayerInfo[playerid][pInjured] = 1;

    
    	SetPlayerArmour(playerid, 0);
	}
	if(type == 1) // bị thương do súng
	{
		if(weaponid == 24 || weaponid == 25)
		{
			SetPlayerPos(playerid, PlayerInfo[playerid][pPos_x], PlayerInfo[playerid][pPos_y], PlayerInfo[playerid][pPos_z]);
			SetPlayerInterior(playerid, GetPVarInt(playerid, "InjuredInt"));
			SetPlayerVirtualWorld(playerid, GetPVarInt(playerid, "InjuredVW"));
		}

		TogglePlayerControllable(playerid, 1);

		PlayerInfo[playerid][pFireTorso] = 0;
		PlayerInfo[playerid][pFireLeg] = 0;
		PlayerInfo[playerid][pFireHead] = 0;

		DeletePVar(playerid, "InjuredVW");
		DeletePVar(playerid, "InjuredInt");

	


	    SendClientMessage(playerid, COLOR_LIGHTRED, "(( Nhan vat cua ban da bi thuong rat nang, hay /ems hoac su dung /acceptdeath ))");
	    SendClientMessage(playerid, COLOR_LIGHTRED, "(( Neu ban dang trong tinh huong bat loi, ban su dung /acceptdeath se vi pham luat le may chu ))");
	    SendClientMessage(playerid, COLOR_LIGHTRED, "(( Khi /acceptdeath, nhan vat cua ban se mat $1,800 ))");
	    PlayerInfo[playerid][pInjured] = 2;

	    if(IsValidDynamic3DTextLabel(InjuredStatus[playerid] )) DestroyDynamic3DTextLabel(InjuredStatus[playerid]);
        InjuredStatus[playerid] = CreateDynamic3DTextLabel(" ", COLOR_LIGHTRED, 0.0, 0.0, -0.95, NT_DISTANCE, .attachedplayer = playerid, .testlos = 1);


	    format(string, sizeof(string), "(( Nguoi nay dang bi thuong nang, su dung '/damages %i' de xem them tinh trang ))", playerid);
	    DeathCooldown[playerid] = 300;

	    UpdateDynamic3DTextLabelText(InjuredStatus[playerid], 0xFF6347FF, "((Nguoi choi dang bi thuong nang))");

	    if (IsPlayerInAnyVehicle(playerid)) ApplyAnimation(playerid, "PED", "CAR_DEAD_LHS", 4.0, 1, 0, 0, 0, 0, 1);	
		else
		{ 
			ApplyAnimation(playerid, "WUZI", "CS_Dead_Guy", 4.1, 0, 0,0, 1, 0, 1);
			TogglePlayerControllable(playerid,0);
		}
		SetPlayerArmour(playerid, 0);
	}
	if(type == 3) // đang bị thương mà bị bắn thêm vài phát
	{
		//SetPlayerPos(playerid, PlayerInfo[playerid][pPos_x], PlayerInfo[playerid][pPos_y], PlayerInfo[playerid][pPos_z]);
		//SetPlayerInterior(playerid, GetPVarInt(playerid, "InjuredInt"));
		//SetPlayerVirtualWorld(playerid, GetPVarInt(playerid, "InjuredVW"));
		PlayerInfo[playerid][pFireTorso] = 0;
		PlayerInfo[playerid][pFireLeg] = 0;
		PlayerInfo[playerid][pFireHead] = 0;

		
		SendClientMessage(playerid, COLOR_LIGHTRED, "(( Nhan vat cua ban chet sau khi bi thuong nang ))");
	    PlayerInfo[playerid][pInjured] = 3;



	    ResetPlayerWeaponsEx(playerid);

	  
	    DeathCooldown[playerid] = 0;
	    if(IsValidDynamic3DTextLabel(InjuredStatus[playerid] )) DestroyDynamic3DTextLabel(InjuredStatus[playerid]);
        InjuredStatus[playerid] = CreateDynamic3DTextLabel(" ", COLOR_LIGHTRED, 0.0, 0.0, -0.95, NT_DISTANCE, .attachedplayer = playerid, .testlos = 1);

	    UpdateDynamic3DTextLabelText(InjuredStatus[playerid], 0xFF6347FF, "((Nguoi choi da chet))");
	    TogglePlayerControllable(playerid, 0);
	    ApplyAnimation(playerid, "WUZI", "CS_Dead_Guy", 4.1, 0, 0, 0, 1, 0, 1);

	    DeletePVar(playerid, "InjuredVW");
		DeletePVar(playerid, "InjuredInt");
		SetPlayerArmour(playerid, 0);
	}
    if(type == 4) // đang bị thương mà bị bắn thêm vài phát
    {
        //SetPlayerPos(playerid, PlayerInfo[playerid][pPos_x], PlayerInfo[playerid][pPos_y], PlayerInfo[playerid][pPos_z]);
        //SetPlayerInterior(playerid, GetPVarInt(playerid, "InjuredInt"));
        //SetPlayerVirtualWorld(playerid, GetPVarInt(playerid, "InjuredVW"));
        PlayerInfo[playerid][pFireTorso] = 0;
        PlayerInfo[playerid][pFireLeg] = 0;
        PlayerInfo[playerid][pFireHead] = 0;



        SendClientMessage(playerid, COLOR_LIGHTRED, "(( Nguoi choi dang bi kiet suc vi qua doi  ))");
        PlayerInfo[playerid][pInjured] = 4;



        ResetPlayerWeaponsEx(playerid);


        DeathCooldown[playerid] = 0;

        if(IsValidDynamic3DTextLabel(InjuredStatus[playerid] )) DestroyDynamic3DTextLabel(InjuredStatus[playerid]);
        InjuredStatus[playerid] = CreateDynamic3DTextLabel(" ", COLOR_LIGHTRED, 0.0, 0.0, -0.95, NT_DISTANCE, .attachedplayer = playerid, .testlos = 1);


        UpdateDynamic3DTextLabelText(InjuredStatus[playerid], 0xFF6347FF, "(( Nguoi choi kiet suc ma ngat xiu ))");
        TogglePlayerControllable(playerid, 0);


        DeletePVar(playerid, "InjuredVW");
        DeletePVar(playerid, "InjuredInt");
        SetPlayerArmour(playerid, 0);
    }
	return 1;
}

CMD:helpup(playerid, params[])
{
	new giveplayerid, string[214];
    if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_BASIC, "{873D37}SU DUNG:{9E9E9E} /helpup [playerid]");
    if(PlayerInfo[giveplayerid][pInjured] == 0) return ShowNotifyTextMain(playerid, "~w~Nguoi nay khong bi thuong.");
    if(PlayerInfo[giveplayerid][pInjured] > 1) return ShowNotifyTextMain(playerid, "~w~Nguoi nay bi thuong qua nang, ban khong the do ho dung day.");
    if(!ProxDetectorS(1.5, playerid, giveplayerid)) return ShowNotifyTextMain(playerid, "~w~Ban khong dung gan nguoi nay.");
    if(giveplayerid == playerid) return ShowNotifyTextMain(playerid, "Ban ~r~khong the thuc hien~w~ lenh nay voi chinh minh.");
    // if(PlayerInfo[playerid][pMedkit] != -1) return ShowNotifyTextMain(playerid, "Ban chua cam ~y~Medkit~w~ tren tay.");
    if(IsPlayerConnected(giveplayerid))
    {
    	format(string, sizeof(string), "* %s dang do %s dung day.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
   	 	ProxDetectorWrap(playerid, string, 92, 10.0, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
    	
    	format(string, sizeof(string), "* dang do %s dung day.", GetPlayerNameEx(giveplayerid));
    	SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 10.5, 5000);

    	format(string, sizeof(string), "* dang duoc %s do dung day.", GetPlayerNameEx(playerid));
    	SetPlayerChatBubble(giveplayerid, string, COLOR_PURPLE, 10.5, 5000);
			
		format(string, sizeof(string), "> Ban dang duoc %s do dung day, vui long cho mot lat...", GetPlayerNameEx(playerid));
		SendClientMessage(giveplayerid, COLOR_LIGHTBLUE, string);

		format(string, sizeof(string), "> Ban dang do %s dung day, vui long cho mot lat...", GetPlayerNameEx(giveplayerid));
		SendClientMessage(giveplayerid, COLOR_LIGHTBLUE, string);

		UpdateDynamic3DTextLabelText(InjuredStatus[giveplayerid], 0xFF6347FF, "(( Nguoi nay dang duoc do day ... ))");
		ApplyAnimation(playerid,"MEDIC","CPR",4.1,0,0,0,0,0);
		SetTimerEx("HelpUpProgress", 10000, 0, "i", giveplayerid);
	//	PlayerInfo[playerid][pMedkit] = 1;
	}
	return 1;
}


forward HelpUpProgress(playerid);
public HelpUpProgress(playerid)
{
	TogglePlayerControllable(playerid, 1);
    KillEMSQueue(playerid);
    ClearAnimations(playerid);
    SetPlayerHealth(playerid, 26);
    playerHelpUp[playerid] = 1;
    PlayerInfo[playerid][pInjured] = 0;
	return 1;
}

forward SetPlayerInjured1(playerid, weaponid);
public SetPlayerInjured1(playerid, weaponid)
{
	cancelDMG[playerid] = 0;
	SetPlayerInjured(playerid, 1, weaponid);
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	new Float:X, Float:Y, Float:Z;
	GetPlayerPos(playerid, X, Y, Z);
	if(ConfigPlayerBleed == true && PlayerInfo[playerid][pInjured] == 0)
	{
		if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && PlayerInfo[playerid][pFireLeg] != 0)
		{
			if(newkeys & KEY_SPRINT)
			{
				ShowNotifyTextMain(playerid, "~w~Ban ~r~khong the~w~ chay nhanh hoac nhay, vi chan ban dang ~r~trung dan~w~. (#2)");
				ApplyAnimation(playerid,"PED","FALL_collapse", 4.1, 0, 1, 1, 0, 0, 1);
			}
			if(newkeys & KEY_JUMP)
			{
				ShowNotifyTextMain(playerid, "~w~Ban ~r~khong the~w~ chay nhanh hoac nhay, vi chan ban dang ~r~trung dan~w~. (#3)");
				SetPlayerPos(playerid, X, Y, Z);
			}
		}
	}
	return 1;
}

task damageEffect[60000]()
{
	foreach(new i: Player)
	{
		if(IsPlayerConnected(i))
		{
			if(ConfigPlayerBleed == true && PlayerInfo[i][pInjured] == 0)
			{
				// =================================================== SILENCED PISTOL =================================================== //

				if(PlayerInfo[i][pFireHead] == 23 || PlayerInfo[i][pFireTorso] == 23)
				{
					if(PlayerInfo[i][pFireHead] == 23)
					{
						new Float:health;
						GetPlayerHealth(i, health);
						if((health - 5) < 20) return SetPlayerDeathbyBleed(i);
						else SetPlayerHealth(i, health-5);
						SendClientMessageEx(i, COLOR_LIGHTRED, "[Player Bleed] Nhan vat cua ban -5.0HP vi bi thuong ngay phan Dau, ban can so cuu gap...");
					}
					if(PlayerInfo[i][pFireTorso] == 23)
					{
						new Float:health;
						GetPlayerHealth(i, health);
						if((health - 2) < 20) return SetPlayerDeathbyBleed(i);
						else SetPlayerHealth(i, health-2);
						SendClientMessageEx(i, COLOR_LIGHTRED, "[Player Bleed] Nhan vat cua ban -2.0HP vi bi thuong ngay phan Nguc, ban can so cuu gap...");
					}
					return 1;
				}

				// =================================================== DESERT EAGLE =================================================== //

				if(PlayerInfo[i][pFireHead] == 24 || PlayerInfo[i][pFireTorso] == 24)
				{
					if(PlayerInfo[i][pFireHead] == 24)
					{
						new Float:health;
						GetPlayerHealth(i, health);
						if((health - 16) < 20) return SetPlayerDeathbyBleed(i);
						else SetPlayerHealth(i, health-16);
						SendClientMessageEx(i, COLOR_LIGHTRED, "[Player Bleed] Nhan vat cua ban -16.0HP vi bi thuong ngay phan Dau, ban can so cuu gap...");
					}
					if(PlayerInfo[i][pFireTorso] == 24)
					{
						new Float:health;
						GetPlayerHealth(i, health);
						if((health - 4) < 20) return SetPlayerDeathbyBleed(i);
						else SetPlayerHealth(i, health-4);
						SendClientMessageEx(i, COLOR_LIGHTRED, "[Player Bleed] Nhan vat cua ban -4.0HP vi bi thuong ngay phan Nguc, ban can so cuu gap...");
					}
					return 1;
				}

				// =================================================== SHOTGUN =================================================== //

				if(PlayerInfo[i][pFireHead] == 25 || PlayerInfo[i][pFireTorso] == 25)
				{
					if(PlayerInfo[i][pFireHead] == 25)
					{
						new Float:health;
						GetPlayerHealth(i, health);
						if((health - 25) < 20) return SetPlayerDeathbyBleed(i);
						else SetPlayerHealth(i, health-25);
						SendClientMessageEx(i, COLOR_LIGHTRED, "[Player Bleed] Nhan vat cua ban -25.0HP vi bi thuong ngay phan Dau, ban can so cuu gap...");
					}
					if(PlayerInfo[i][pFireTorso] == 25)
					{
						new Float:health;
						GetPlayerHealth(i, health);
						if((health - 14) < 20) return SetPlayerDeathbyBleed(i);
						else SetPlayerHealth(i, health-14);
						SendClientMessageEx(i, COLOR_LIGHTRED, "[Player Bleed] Nhan vat cua ban -14.0HP vi bi thuong ngay phan Nguc, ban can so cuu gap...");
					}
					return 1;
				}

				// =================================================== MAC-10 =================================================== //

				if(PlayerInfo[i][pFireHead] == 28 || PlayerInfo[i][pFireTorso] == 28)
				{
					if(PlayerInfo[i][pFireHead] == 28)
					{
						new Float:health;
						GetPlayerHealth(i, health);
						if((health - 15) < 20) return SetPlayerDeathbyBleed(i);
						else SetPlayerHealth(i, health-15);
						SendClientMessageEx(i, COLOR_LIGHTRED, "[Player Bleed] Nhan vat cua ban -15.0HP vi bi thuong ngay phan Dau, ban can so cuu gap...");
					}
					if(PlayerInfo[i][pFireTorso] == 28)
					{
						new Float:health;
						GetPlayerHealth(i, health);
						if((health - 8) < 20) return SetPlayerDeathbyBleed(i);
						else SetPlayerHealth(i, health-8);
						SendClientMessageEx(i, COLOR_LIGHTRED, "[Player Bleed] Nhan vat cua ban -8.0HP vi bi thuong ngay phan Nguc, ban can so cuu gap...");
					}
					return 1;
				}

				// =================================================== TEC-9 =================================================== //

				if(PlayerInfo[i][pFireHead] == 32 || PlayerInfo[i][pFireTorso] == 32)
				{
					if(PlayerInfo[i][pFireHead] == 32)
					{
						new Float:health;
						GetPlayerHealth(i, health);
						if((health - 15) < 20) return SetPlayerDeathbyBleed(i);
						else SetPlayerHealth(i, health-15);
						SendClientMessageEx(i, COLOR_LIGHTRED, "[Player Bleed] Nhan vat cua ban -15.0HP vi bi thuong ngay phan Dau, ban can so cuu gap...");
					}
					if(PlayerInfo[i][pFireTorso] == 32)
					{
						new Float:health;
						GetPlayerHealth(i, health);
						if((health - 8) < 20) return SetPlayerDeathbyBleed(i);
						else SetPlayerHealth(i, health-8);
						SendClientMessageEx(i, COLOR_LIGHTRED, "[Player Bleed] Nhan vat cua ban -8.0HP vi bi thuong ngay phan Nguc, ban can so cuu gap...");
					}
					return 1;
				}

				// =================================================== MP5 =================================================== //

				if(PlayerInfo[i][pFireHead] == 29 || PlayerInfo[i][pFireTorso] == 29)
				{
					if(PlayerInfo[i][pFireHead] == 29)
					{
						new Float:health;
						GetPlayerHealth(i, health);
						if((health - 23) < 20) return SetPlayerDeathbyBleed(i);
						else SetPlayerHealth(i, health-23);
						SendClientMessageEx(i, COLOR_LIGHTRED, "[Player Bleed] Nhan vat cua ban -23.0HP vi bi thuong ngay phan Dau, ban can so cuu gap...");
					}
					if(PlayerInfo[i][pFireTorso] == 29)
					{
						new Float:health;
						GetPlayerHealth(i, health);
						if((health - 19) < 20) return SetPlayerDeathbyBleed(i);
						else SetPlayerHealth(i, health-19);
						SendClientMessageEx(i, COLOR_LIGHTRED, "[Player Bleed] Nhan vat cua ban -19.0HP vi bi thuong ngay phan Nguc, ban can so cuu gap...");
					}
					return 1;
				}

				// =================================================== MP5 =================================================== //

				if(PlayerInfo[i][pFireHead] == 29 || PlayerInfo[i][pFireTorso] == 29)
				{
					if(PlayerInfo[i][pFireHead] == 29)
					{
						new Float:health;
						GetPlayerHealth(i, health);
						if((health - 23) < 20) return SetPlayerDeathbyBleed(i);
						else SetPlayerHealth(i, health-23);
						SendClientMessageEx(i, COLOR_LIGHTRED, "[Player Bleed] Nhan vat cua ban -23.0HP vi bi thuong ngay phan Dau, ban can so cuu gap...");
					}
					if(PlayerInfo[i][pFireTorso] == 29)
					{
						new Float:health;
						GetPlayerHealth(i, health);
						if((health - 19) < 20) return SetPlayerDeathbyBleed(i);
						else SetPlayerHealth(i, health-19);
						SendClientMessageEx(i, COLOR_LIGHTRED, "[Player Bleed] Nhan vat cua ban -19.0HP vi bi thuong ngay phan Nguc, ban can so cuu gap...");
					}
					return 1;
				}

				// =================================================== AK-47 =================================================== //

				if(PlayerInfo[i][pFireHead] == 30 || PlayerInfo[i][pFireTorso] == 30)
				{
					if(PlayerInfo[i][pFireHead] == 30)
					{
						new Float:health;
						GetPlayerHealth(i, health);
						if((health - 18) < 20) return SetPlayerDeathbyBleed(i);
						else SetPlayerHealth(i, health-18);
						SendClientMessageEx(i, COLOR_LIGHTRED, "[Player Bleed] Nhan vat cua ban -18.0HP vi bi thuong ngay phan Dau, ban can so cuu gap...");
					}
					if(PlayerInfo[i][pFireTorso] == 30)
					{
						new Float:health;
						GetPlayerHealth(i, health);
						if((health - 15) < 20) return SetPlayerDeathbyBleed(i);
						else SetPlayerHealth(i, health-15);
						SendClientMessageEx(i, COLOR_LIGHTRED, "[Player Bleed] Nhan vat cua ban -15.0HP vi bi thuong ngay phan Nguc, ban can so cuu gap...");
					}
					return 1;
				}

				// =================================================== M4 =================================================== //

				if(PlayerInfo[i][pFireHead] == 31 || PlayerInfo[i][pFireTorso] == 31)
				{
					if(PlayerInfo[i][pFireHead] == 31)
					{
						new Float:health;
						GetPlayerHealth(i, health);
						if((health - 25) < 20) return SetPlayerDeathbyBleed(i);
						else SetPlayerHealth(i, health-25);
						SendClientMessageEx(i, COLOR_LIGHTRED, "[Player Bleed] Nhan vat cua ban -25.0HP vi bi thuong ngay phan Dau, ban can so cuu gap...");
					}
					if(PlayerInfo[i][pFireTorso] == 31)
					{
						new Float:health;
						GetPlayerHealth(i, health);
						if((health - 20) < 20) return SetPlayerDeathbyBleed(i);
						else SetPlayerHealth(i, health-20);
						SendClientMessageEx(i, COLOR_LIGHTRED, "[Player Bleed] Nhan vat cua ban -20.0HP vi bi thuong ngay phan Nguc, ban can so cuu gap...");
					}
					return 1;
				}

				// =================================================== SNIPER RIFLE =================================================== //

				if(PlayerInfo[i][pFireHead] == 34 || PlayerInfo[i][pFireTorso] == 34)
				{
					if(PlayerInfo[i][pFireTorso] == 34)
					{
						new Float:health;
						GetPlayerHealth(i, health);
						if((health - 20) < 20) return SetPlayerDeathbyBleed(i);
						else SetPlayerHealth(i, health-20);
						SendClientMessageEx(i, COLOR_LIGHTRED, "[Player Bleed] Nhan vat cua ban -20.0HP vi bi thuong ngay phan Nguc, ban can so cuu gap...");
					}
					return 1;
				}
			}
		}
	}
	return 1;
}

stock SetPlayerDeathbyBleed(playerid)
{
	PlayerInfo[playerid][pFireTorso] = 0;
	PlayerInfo[playerid][pFireLeg] = 0;
	PlayerInfo[playerid][pFireHead] = 0;

   	SendClientMessage(playerid, COLOR_LIGHTRED, "Nhan vat cua ban da bi thuong rat nang, hay /ems hoac su dung /chapnhan chet.");
    PlayerInfo[playerid][pInjured] = 2;

    DeathCooldown[playerid] = 300;
 //   TextDrawShowForPlayer(playerid, playerdeath[playerid]);
    if (IsPlayerInAnyVehicle(playerid)) ApplyAnimation(playerid, "PED", "CAR_DEAD_LHS", 4.0, 1, 0, 0, 0, 0, 1);	
	else
	{ 
		ApplyAnimation(playerid, "WUZI", "CS_Dead_Guy", 4.1, 0, 0,0, 1, 0, 1);
	}
	return 1;
}