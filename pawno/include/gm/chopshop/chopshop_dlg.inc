Dialog:DIALOG_CHOPSHOP(playerid, response, listitem, inputtext[])
{
    if (!response) return 1;

    switch(listitem)
    {
        case 0: {
            if (GetChopshopID(playerid) == -1) {
                new idx = -1;
                for(new i = 0; i < MAX_CHOPSHOP; i++)
                {
                    if (chopshop_data[i][chopshop_exist] == true) continue;

                    idx = i;
                    break;
                }
                if (idx == -1)   return SendErrorMessage(playerid, "Tat ca cac vi tri phan xuong deu da co nguoi su dung!");
                
                new Float: x, Float: y, Float: z;
                GetPlayerPos(playerid, x, y, z);
                
                new faction = 0;

                if (!CheckAdmin(playerid, ADMIN_LEVEL_2) && !IsAdminDuty(playerid)) { 
                    faction = PlayerInfo[playerid][pFaction];
                }

                SetPVarInt(playerid, #EditChopShop, 1);
		        SetPVarInt(playerid, #ChopShop_Faction, faction);

                new temp_object = CreateDynamicObject(3077, x+1.0, y+1.0, z, 0.0, 0.0, 0.0);
				EditDynamicObject(playerid, temp_object);

                return 1;
            } else {
                SendSyntaxMessage(playerid, "Ban da xoa thanh cong [ID:%i].", GetChopshopID(playerid));
                RemoveChopShop(GetChopshopID(playerid));
            }            
        }
        case 1: {
            if (chopshop_data[GetChopshopID(playerid)][chopshop_timer] < 30) return SendErrorMessage(playerid, "Danh sach da duoc cap nhat gan day!");
            GetRandomModel( GetChopshopID(playerid) );
        }
        case 2: ShowChopShopInfo(playerid, GetChopshopID(playerid));
        case 3: {
            new msg[256];
            format(msg, sizeof(msg), "{FFFFFF}Bay gio ty le phan tram ma ban lay tu moi chiec xe mang lai cho ban la {FF6347}%i%%\n\n{FFFFFF}Nhap mot ty le phan tram moi {C3C3C3}(so nguyen):\t\t{FF6347}(1%%-85%%)", chopshop_data[GetChopshopID(playerid)][chopshop_procent]);
            Dialog_Show(playerid, ChopShopProcent, DIALOG_STYLE_INPUT, "Thay doi phan tram", msg, "Chinh sua", "Thay doi");
        }
        case 4: EditChopShop(playerid, GetChopshopID(playerid));
    }
    return 1;
}

Dialog:ChopShopInfo(playerid, response, listitem, inputtext[])
{
     return cmd::chopshop(playerid, "");
}

//ChopShîð
Dialog:ChopShopProcent(playerid, response, listitem, inputtext[])
{
    if (!response) return cmd::chopshop(playerid, "");

    if (isnull(inputtext) || strval(inputtext) < 1 || strval(inputtext) > 85) {
        new msg[256];
        format(msg, sizeof(msg), "{FFFFFF}Bay gio ty le phan tram ma ban lay tu moi chiec xe mang lai cho ban la {FF6347}%i%%\n\n{FFFFFF}Nhap mot ty le phan tram moi {C3C3C3}(so nguyen):\t\t{FF6347}(1%%-85%%)", chopshop_data[GetChopshopID(playerid)][chopshop_procent]);
        Dialog_Show(playerid, ChopShopProcent, DIALOG_STYLE_INPUT, "Phan tram", msg, "Chinh sua", "Thay doi");
    }

    SendSyntaxMessage(playerid, "Ban da cai dat phan tram 'thue thu nhap' {FF6347}%i{FFFFFF} phan tram cua ChopShop.", strval(inputtext));

    chopshop_data[GetChopshopID(playerid)][chopshop_procent] = strval(inputtext);
    SQL_SetInteger("chopshop", "procent", chopshop_data[GetChopshopID(playerid)][chopshop_procent], chopshop_data[GetChopshopID(playerid)][chopshop_id]);
    return 1;
}