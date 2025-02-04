Biz_OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
    for(new i = 0; i < MAX_BIZ; i++)
	{
		if(!pickup_expire{playerid})
		{
			if (pickupid != BizInfo[i][bizPickUp] || 0 == BizInfo[i][bizID]) continue;

			new mes[128];

			if (BizInfo[i][bizFreeze] == 1) //����
			{
				format(mes, sizeof(mes), "%s, So huu: Nha nuoc, Phi vao cua: %i, %s.", BizInfo[i][bizName], BizInfo[i][bizEntrance], GetBusinessZone(i, 1));
				SendClientMessage(playerid, COLOR_GREEN, mes);
				SendClientMessage(playerid, COLOR_WHITE, "Lenh co san: /enter, /mua");
				pickup_expire{playerid} = 5;
			}
			else
			{
				if (BizInfo[i][bizOwnerID] == 0)
				{
					SendClientMessage(playerid, COLOR_WHITE, "Ban co muon mua cai nay khong?");
					format(mes, sizeof(mes), "TEN: %s [%i] GIA: $%i, %s.", BizInfo[i][bizName], i, BizInfo[i][bizPrice], GetBusinessZone(i, 1));
					SendClientMessage(playerid, COLOR_GREEN, mes);
					SendClientMessage(playerid, COLOR_WHITE, "Lenh co san: /enter, /mua, /biz buy.");
					pickup_expire{playerid} = 5;
				}
				else
				{
					format(mes, sizeof(mes), "%s, Phi vao cua: %i, %s.", BizInfo[i][bizName], BizInfo[i][bizEntrance], GetBusinessZone(i, 1));
					SendClientMessage(playerid, COLOR_GREEN, mes);
					SendClientMessage(playerid, COLOR_WHITE, "Lenh co san: /enter, /mua");
					pickup_expire{playerid} = 5;
				}
				return 1;
			}
		}
	}
    return 1;
}

Biz_OnGameModeInit()
{
    return mysql_tquery(dbHandle, "SELECT *, (SELECT name FROM users WHERE id = business.owner) as ownername, (SELECT last_login FROM users WHERE id = business.owner) as last_login FROM `business`", "LoadDynamicBiz");
}

Fo_OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid) 
{
    for(new i; i != 4; i++)
	{
	    if (playertextid != TD_restaurant_prod[playerid][i + 4])	continue;

        RestaurantMenuHide(playerid);

        if (pTemp[playerid][pFoodStand] != 0 || IsPlayerAttachedObjectSlotUsed(playerid, ATTACH_HANDS))	return SendWarningMessage(playerid, "Tay ban dang cam mot vat pham ( Bam N ( inventory ) sau do cat vat pham ).");

		new bizid;

		if ((bizid = GetNearInsideBiz(playerid)) == -1)	return SendErrorMessage(playerid, "Ban phai o ben trong doanh nghiep.");

		if (BizInfo[bizid][bizType] != BIZ_PIZZA && BizInfo[bizid][bizType] != BIZ_CLUCKIN && BizInfo[bizid][bizType] != BIZ_BURGER && BizInfo[bizid][bizType] != BIZ_DONUT)
		{
			return SendErrorMessage(playerid, "Ban khong o trong mot nha hang.");
		}

		new type = BizInfo[bizid][bizType] - BIZ_PIZZA;

		if (GetCash(playerid) < BizInfo[bizid][bizProductPrice][i])			return SendNotCash(playerid);
		if (BizInfo[bizid][bizOwnerID] != 0 && !BizInfo[bizid][bizProduct])	return SendErrorMessage(playerid, "Khong co du san pham cho doanh nghiep.");
		    
        cmd::server_ame(playerid, "dat do an.");

        SendSyntaxMessage(playerid, "Ban da dat {FF6347}%s{FFFFFF} voi gia {FF6347}$%s{FFFFFF}.", name_order[type][i], FormatNumber(BizInfo[bizid][bizProductPrice][i]));
		SendSyntaxMessage(playerid, "Co the dat thuc an tren ban {FF6347}/meal place{FFFFFF} hoac {FF6347}/meal throw{FFFFFF} de vut cai khay.");

		GiveCash(playerid, - BizInfo[bizid][bizProductPrice][i]);

		if (BizInfo[bizid][bizOwnerID] != 0)
		{
			BizInfo[bizid][bizProduct]--;
			GiveBizCash(bizid, BizInfo[bizid][bizProductPrice][i]);
		}
		
		OnPlayAnim(playerid,"CARRY","crry_prtial",4.1,1,1,1,1,1);
		SetPlayerAttachedObject(playerid, ATTACH_HANDS, model_order[type][i], 5, 0.091998, 0.021999, 0.409, -104.9, 27.6, 0, 1, 1, 1);
		pTemp[playerid][pFoodStand] = model_order[type][i];

		new Float: health;

		if (AntiCheatGetHealth(playerid, health))	SetPlayerHealth(playerid, health + 30.0 + (i * 10.0));
		if (health + 30.0 + (i * 10.0) > 150.0)		SetPlayerHealth(playerid, 150.0);

		return 1;
	}
    return 1;
}

Food_OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	new Float:oldX, Float:oldY, Float:oldZ, Float:oldRotX, Float:oldRotY, Float:oldRotZ;
	
	GetDynamicObjectPos(objectid, oldX, oldY, oldZ);
	GetDynamicObjectRot(objectid, oldRotX, oldRotY, oldRotZ);

    if (GetPVarInt(playerid, #edit_food) != 0 && (response == EDIT_RESPONSE_FINAL || response == EDIT_RESPONSE_CANCEL))
	{
	    new id = GetPVarInt(playerid, #edit_food)-1;
		
	    DeletePVar(playerid, #edit_food);

	    if (GetDistanceBetweenPoints(x, y, z, FoodDrop[id][foodPosX], FoodDrop[id][foodPosY], FoodDrop[id][foodPosZ]) > 10.0)
	    {
     		SetDynamicObjectPos(objectid, FoodDrop[id][foodPosX], FoodDrop[id][foodPosY], FoodDrop[id][foodPosZ]);
	        return SendErrorMessage(playerid, "Doi tuong qua xa so voi vi tri bat dau.");
	    }

	    if (objectid != FoodDrop[id][foodObject])	return SendErrorMessage(playerid, "Loi chinh sua vat pham.");
		SetDynamicObjectPos(objectid, x, y, z);
		SetDynamicObjectRot(objectid, rx, ry, rz);

        GetDynamicObjectPos(objectid, FoodDrop[id][foodPosX], FoodDrop[id][foodPosY], FoodDrop[id][foodPosZ]);
	    return 1;
	}
	return 1;
}