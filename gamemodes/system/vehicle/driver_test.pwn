#include <YSI\y_hooks>

new DMV_Index[MAX_PLAYERS];
new DMV_TestingB2[MAX_PLAYERS];

new XeDangThiB2[MAX_PLAYERS];


new Float:TestData_PointsB2[27][3] = {
{1168.69, -1742.07, 12.96},  // 1 // thong bao 60KM/H
{1102.87, -1712.09, 12.95},  // 2
{1037.55, -1752.72, 12.93},  // 3
{980.72, -1784.12, 13.64}, 	 // 4
{722.00, -1756.00, 13.98}, 	 // 5
{464.95, -1706.31, 10.53}, 	 // 6
{241.64, -1665.39, 10.32}, 	 // 7
{191.57, -1506.33, 12.13}, 	 // 8
{359.41, -1380.72, 13.93}, 	 // 9
{551.68, -1247.85, 16.42}, 	 // 10
{703.43, -1132.32, 16.34}, 	 // 11
{901.35, -983.78, 36.98}, 	 // 12
{1178.92, -947.95, 42.30}, 	 // 13
{1421.42, -950.23, 35.71}, 	 // 14
{1628.41, -851.85, 57.61}, 	 // 15 // Cthong bao 90 KM/H
{1668.72, -888.35, 60.58}, 	 // 16 // Start duong cao toc
{1624.36, -1173.64, 54.88},  // 17
{1581.82, -1403.33, 28.07},  // 18
{1571.75, -1493.16, 22.32},  // 19
{1694.73, -1537.26, 22.85},  // 20
{1862.54, -1518.18, 2.94}, 	 // 21 // thong bao 60 KM/H
{1820.01, -1595.34, 12.92},  // 22
{1818.76, -1729.87, 13.38},  // 23
{1515.42, -1729.74, 12.94},  // 24
{1336.38, -1729.88, 12.94},  // 25
{1216.57, -1712.06, 12.95},  // 26
{1104.16, -1740.82, 13.03} 	 // 27
};

hook OnGameModeInit()
{
    CreateDynamic3DTextLabel("< DRIVER TEST >\nSu dung '/thibanglai' de bat dau",COLOR_BASIC,1113.01, -1835.96, 16.60,6.0);
    CreateDynamicPickup(1239, 23, 1113.01, -1835.96, 16.60, -1);
}

hook OnPlayerConnect(playerid)
{
    if(XeDangThiB2[playerid] != INVALID_VEHICLE_ID)
	{
	    DestroyVehicle(XeDangThiB2[playerid]);
        XeDangThiB2[playerid] = INVALID_VEHICLE_ID;
	}
    DMV_TestingB2[playerid] = 0;
}

hook OnPlayerDisconnect(playerid, reason)
{  
    if(XeDangThiB2[playerid] != INVALID_VEHICLE_ID)
	{
	    DestroyVehicle(XeDangThiB2[playerid]);
        XeDangThiB2[playerid] = INVALID_VEHICLE_ID;
	}
    DMV_TestingB2[playerid] = 0;
}

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
    if(newstate == PLAYER_STATE_DRIVER) // BangB2
	{
		if(XeDangThiB2[playerid] != INVALID_VEHICLE_ID && DMV_TestingB2[playerid] == 10)
		{
			SetCameraBehindPlayer(playerid);
			SetPlayerWorldBounds(playerid, 20000.0000, -20000.0000, 20000.0000, -20000.0000);
			DMV_TestingB2[playerid] = 1;
			DMV_Index[playerid] = 0;

			SetPlayerRaceCheckpointEx(playerid, 0, TestData_PointsB2[DMV_Index[playerid]][0], TestData_PointsB2[DMV_Index[playerid]][1], TestData_PointsB2[DMV_Index[playerid]][2], TestData_PointsB2[DMV_Index[playerid]+1][0], TestData_PointsB2[DMV_Index[playerid]+1][1], TestData_PointsB2[DMV_Index[playerid]+1][2], 5.0);
		}
	}	
    return 1;
}

hook OnPlayerEnterRaceCheckpoint(playerid)
{
    if(XeDangThiB2[playerid] != INVALID_VEHICLE_ID && IsPlayerInAnyVehicle(playerid))
	{
		new car = XeDangThiB2[playerid];
		new speed = GetVehicleSpeed(car);

		if(speed > 60 && DMV_Index[playerid] > 21)
		{
	    	if(PlayerInfo[playerid][pDriverLicWarn] == 0)
			{
			  	ShowNotifyTextMain(playerid, "Loi vi pham ~r~1~w~/3~n~Hay giu toc do phuong tien duoi ~p~60 KM/H");
		  		PlayerInfo[playerid][pDriverLicWarn] = 1;
			}
			else if(PlayerInfo[playerid][pDriverLicWarn] == 1)
			{
				ShowNotifyTextMain(playerid, "Loi vi pham ~r~2~w~/3~n~Hay giu toc do phuong tien duoi ~p~60 KM/H");
				SendClientMessageEx(playerid, COLOR_WHITE, "{6CAD3D}[LICENSE TEST]{FFFFFF} Ban da vi pham qua 2 lan roi, mot lan nua ban se bi rot ky thi.");
			    PlayerInfo[playerid][pDriverLicWarn] = 2;
			}
			else if(PlayerInfo[playerid][pDriverLicWarn] == 2)
			{
				ShowNotifyTextMain(playerid, "Loi vi pham ~r~3~w~/3~n~Hay giu toc do phuong tien duoi ~p~60 KM/H");
			    RotBangB2(playerid);
			    return 1;
			}
		}

		if(DMV_Index[playerid] <= 14)
		{
			if(speed > 60)
			{
		  	  if(PlayerInfo[playerid][pDriverLicWarn] == 0)
				{
					ShowNotifyTextMain(playerid, "Loi vi pham ~r~1~w~/3~n~Hay giu toc do phuong tien duoi ~p~60 KM/H");
			  	    PlayerInfo[playerid][pDriverLicWarn] = 1;
				}
				else if(PlayerInfo[playerid][pDriverLicWarn] == 1)
				{
					ShowNotifyTextMain(playerid, "Loi vi pham ~r~2~w~/3~n~Hay giu toc do phuong tien duoi ~p~60 KM/H");
					SendClientMessageEx(playerid, COLOR_WHITE, "{6CAD3D}[LICENSE TEST]{FFFFFF} Ban da vi pham qua 2 lan roi, mot lan nua ban se bi rot ky thi.");
				    PlayerInfo[playerid][pDriverLicWarn] = 2;
				}
				else if(PlayerInfo[playerid][pDriverLicWarn] == 2)
				{
					ShowNotifyTextMain(playerid, "Loi vi pham ~r~3~w~/3~n~Hay giu toc do phuong tien duoi ~p~60 KM/H");
				    RotBangB2(playerid);
				    return 1;
				}
			}
			SendClientMessageEx(playerid, COLOR_WHITE, "{6CAD3D}[LICENSE TEST]{FFFFFF} Vi tri tiep theo ban phai giu toc do khong duoc cao hon {6CAD3D}60 KM/H{FFFFFF}.");
		}

		if(DMV_Index[playerid] == 14)
		{
			if(speed > 60)
			{
		  	  if(PlayerInfo[playerid][pDriverLicWarn] == 0)
				{
					ShowNotifyTextMain(playerid, "Loi vi pham ~r~1~w~/3~n~Hay giu toc do phuong tien duoi ~p~60 KM/H");
			  	    PlayerInfo[playerid][pDriverLicWarn] = 1;
				}
				else if(PlayerInfo[playerid][pDriverLicWarn] == 1)
				{
					ShowNotifyTextMain(playerid, "Loi vi pham ~r~2~w~/3~n~Hay giu toc do phuong tien duoi ~p~60 KM/H");
					SendClientMessageEx(playerid, COLOR_WHITE, "{6CAD3D}[LICENSE TEST]{FFFFFF} Ban da vi pham qua 2 lan roi, mot lan nua ban se bi rot ky thi.");
				    PlayerInfo[playerid][pDriverLicWarn] = 2;
				}
				else if(PlayerInfo[playerid][pDriverLicWarn] == 2)
				{
					ShowNotifyTextMain(playerid, "Loi vi pham ~r~3~w~/3~n~Hay giu toc do phuong tien duoi ~p~60 KM/H");
				    RotBangB2(playerid);
				    return 1;
				}
			}
			SendClientMessageEx(playerid, COLOR_WHITE, "{6CAD3D}[LICENSE TEST]{FFFFFF} Vi tri tiep theo ban phai giu toc do khong duoc cao hon {6CAD3D}90 KM/H{FFFFFF}.");
		}

		if(DMV_Index[playerid] == 15)
		{
			if(speed > 90)
			{
		  	    if(PlayerInfo[playerid][pDriverLicWarn] == 0)
			 	{
					ShowNotifyTextMain(playerid, "Loi vi pham ~r~1~w~/3~n~Hay giu toc do phuong tien duoi ~p~90 KM/H");
			  	    PlayerInfo[playerid][pDriverLicWarn] = 1;
				}
				else if(PlayerInfo[playerid][pDriverLicWarn] == 1)
				{
					ShowNotifyTextMain(playerid, "Loi vi pham ~r~2~w~/3~n~Hay giu toc do phuong tien duoi ~p~90 KM/H");
					SendClientMessageEx(playerid, COLOR_WHITE, "{6CAD3D}[LICENSE TEST]{FFFFFF} Ban da vi pham qua 2 lan roi, mot lan nua ban se bi rot ky thi.");
				    PlayerInfo[playerid][pDriverLicWarn] = 2;
				}
				else if(PlayerInfo[playerid][pDriverLicWarn] == 2)
				{
					ShowNotifyTextMain(playerid, "Loi vi pham ~r~3~w~/3~n~Hay giu toc do phuong tien duoi ~p~90 KM/H");
				    RotBangB2(playerid);
				    return 1;
				}
				SendClientMessageEx(playerid, COLOR_WHITE, "{6CAD3D}[LICENSE TEST]{FFFFFF} Vi tri tiep theo ban phai giu toc do khong duoc cao hon {6CAD3D}90 KM/H{FFFFFF}.");
			}
		}	

		if(DMV_Index[playerid] == 16)
		{
			if(speed > 90)
			{
		  	  if(PlayerInfo[playerid][pDriverLicWarn] == 0)
				{
					ShowNotifyTextMain(playerid, "Loi vi pham ~r~1~w~/3~n~Hay giu toc do phuong tien duoi ~p~90 KM/H");
			  	    PlayerInfo[playerid][pDriverLicWarn] = 1;
				}
				else if(PlayerInfo[playerid][pDriverLicWarn] == 1)
				{
					ShowNotifyTextMain(playerid, "Loi vi pham ~r~2~w~/3~n~Hay giu toc do phuong tien duoi ~p~90 KM/H");
					SendClientMessageEx(playerid, COLOR_WHITE, "{6CAD3D}[LICENSE TEST]{FFFFFF} Ban da vi pham qua 2 lan roi, mot lan nua ban se bi rot ky thi.");
				    PlayerInfo[playerid][pDriverLicWarn] = 2;
				}
				else if(PlayerInfo[playerid][pDriverLicWarn] == 2)
				{
					ShowNotifyTextMain(playerid, "Loi vi pham ~r~3~w~/3~n~Hay giu toc do phuong tien duoi ~p~90 KM/H");
				    RotBangB2(playerid);
				    return 1;
				}
			}
		}	

		if(DMV_Index[playerid] == 17)
		{
			if(speed > 90)
			{
		    	if(PlayerInfo[playerid][pDriverLicWarn] == 0)
				{
					ShowNotifyTextMain(playerid, "Loi vi pham ~r~1~w~/3~n~Hay giu toc do phuong tien duoi ~p~90 KM/H");
			  	    PlayerInfo[playerid][pDriverLicWarn] = 1;
				}
				else if(PlayerInfo[playerid][pDriverLicWarn] == 1)
				{
					ShowNotifyTextMain(playerid, "Loi vi pham ~r~2~w~/3~n~Hay giu toc do phuong tien duoi ~p~90 KM/H");
					SendClientMessageEx(playerid, COLOR_WHITE, "{6CAD3D}[LICENSE TEST]{FFFFFF} Ban da vi pham qua 2 lan roi, mot lan nua ban se bi rot ky thi.");
				    PlayerInfo[playerid][pDriverLicWarn] = 2;
				}
				else if(PlayerInfo[playerid][pDriverLicWarn] == 2)
				{
					ShowNotifyTextMain(playerid, "Loi vi pham ~r~3~w~/3~n~Hay giu toc do phuong tien duoi ~p~90 KM/H");
				    RotBangB2(playerid);
				    return 1;
				}
			}
		}	

		if(DMV_Index[playerid] == 18)
		{
			if(speed > 90)
			{
		    	if(PlayerInfo[playerid][pDriverLicWarn] == 0)
				{
					ShowNotifyTextMain(playerid, "Loi vi pham ~r~1~w~/3~n~Hay giu toc do phuong tien duoi ~p~90 KM/H");
			  	    PlayerInfo[playerid][pDriverLicWarn] = 1;
				}
				else if(PlayerInfo[playerid][pDriverLicWarn] == 1)
				{
					ShowNotifyTextMain(playerid, "Loi vi pham ~r~2~w~/3~n~Hay giu toc do phuong tien duoi ~p~90 KM/H");
					SendClientMessageEx(playerid, COLOR_WHITE, "{6CAD3D}[LICENSE TEST]{FFFFFF} Ban da vi pham qua 2 lan roi, mot lan nua ban se bi rot ky thi.");
				    PlayerInfo[playerid][pDriverLicWarn] = 2;
				}
				else if(PlayerInfo[playerid][pDriverLicWarn] == 2)
				{
					ShowNotifyTextMain(playerid, "Loi vi pham ~r~3~w~/3~n~Hay giu toc do phuong tien duoi ~p~90 KM/H");
				    RotBangB2(playerid);
				    return 1;
				}
			}
		}	

		if(DMV_Index[playerid] == 19)
		{
			if(speed > 90)
			{
		    	if(PlayerInfo[playerid][pDriverLicWarn] == 0)
				{
					ShowNotifyTextMain(playerid, "Loi vi pham ~r~1~w~/3~n~Hay giu toc do phuong tien duoi ~p~90 KM/H");
    			  	PlayerInfo[playerid][pDriverLicWarn] = 1;
				}
				else if(PlayerInfo[playerid][pDriverLicWarn] == 1)
				{
					ShowNotifyTextMain(playerid, "Loi vi pham ~r~2~w~/3~n~Hay giu toc do phuong tien duoi ~p~90 KM/H");
					SendClientMessageEx(playerid, COLOR_WHITE, "{6CAD3D}[LICENSE TEST]{FFFFFF} Ban da vi pham qua 2 lan roi, mot lan nua ban se bi rot ky thi.");
				    PlayerInfo[playerid][pDriverLicWarn] = 2;
				}
				else if(PlayerInfo[playerid][pDriverLicWarn] == 2)
				{
					ShowNotifyTextMain(playerid, "Loi vi pham ~r~3~w~/3~n~Hay giu toc do phuong tien duoi ~p~90 KM/H");
				    RotBangB2(playerid);
				    return 1;
				}
			}
		}	

		if(DMV_Index[playerid] == 20)
		{
			if(speed > 90)
			{
		    	if(PlayerInfo[playerid][pDriverLicWarn] == 0)
				{
					ShowNotifyTextMain(playerid, "Loi vi pham ~r~1~w~/3~n~Hay giu toc do phuong tien duoi ~p~90 KM/H");
			  	    PlayerInfo[playerid][pDriverLicWarn] = 1;
				}
				else if(PlayerInfo[playerid][pDriverLicWarn] == 1)
				{
					ShowNotifyTextMain(playerid, "Loi vi pham ~r~2~w~/3~n~Hay giu toc do phuong tien duoi ~p~90 KM/H");
					SendClientMessageEx(playerid, COLOR_WHITE, "{6CAD3D}[LICENSE TEST]{FFFFFF} Ban da vi pham qua 2 lan roi, mot lan nua ban se bi rot ky thi.");
				    PlayerInfo[playerid][pDriverLicWarn] = 2;
				}
				else if(PlayerInfo[playerid][pDriverLicWarn] == 2)
				{
					ShowNotifyTextMain(playerid, "Loi vi pham ~r~3~w~/3~n~Hay giu toc do phuong tien duoi ~p~90 KM/H");
				    RotBangB2(playerid);
				    return 1;
				}
			}
			SendClientMessageEx(playerid, COLOR_WHITE, "{6CAD3D}[LICENSE TEST]{FFFFFF} Vi tri tiep theo ban phai giu toc do khong duoc cao hon {6CAD3D}60 KM/H{FFFFFF}.");
		}


		DMV_Index[playerid] ++;
		if(DMV_Index[playerid] == 27)
		{
			new Float:HP;
			GetVehicleHealth(XeDangThiB2[playerid], HP);
			if(HP < 980)
			{
				FailBangB2(playerid);
			}
			else
			{
				PassBangB2(playerid);
			}
			return true;
		}

		if(DMV_Index[playerid] < 27 - 1)
		{
			SetPlayerRaceCheckpointEx(playerid, 0, TestData_PointsB2[DMV_Index[playerid]][0], TestData_PointsB2[DMV_Index[playerid]][1], TestData_PointsB2[DMV_Index[playerid]][2], TestData_PointsB2[DMV_Index[playerid]+1][0], TestData_PointsB2[DMV_Index[playerid]+1][1], TestData_PointsB2[DMV_Index[playerid]+1][2], 5.0);
		}
		if(DMV_Index[playerid] == 27 - 1)
		{
			SetPlayerRaceCheckpointEx(playerid, 0, TestData_PointsB2[DMV_Index[playerid]][0], TestData_PointsB2[DMV_Index[playerid]][1], TestData_PointsB2[DMV_Index[playerid]][2], 0.0, 0.0, 0.0, 5.0);
		}
		return true;
	}
    return 1;
}
stock PassBangB2(playerid)
{
 	if(DMV_TestingB2[playerid] == 0) return false;

	TogglePlayerControllable(playerid, 1);
 	SendClientMessageEx(playerid, COLOR_BASIC, "{6CAD3D}[HOAN THANH]{FFFFFF} Congrats!, Ban da hoan thanh phan thi lai xe thanh cong. (/my license)");
 	DestroyVehicle(XeDangThiB2[playerid]);
 	DisablePlayerRaceCheckpoint(playerid);
 	XeDangThiB2[playerid] = INVALID_VEHICLE_ID;
 	DMV_TestingB2[playerid] = 0;
 	DMV_Index[playerid] = 0;
    PlayerInfo[playerid][pDriverLicWarn] = 0;
 	SetPlayerPos(playerid, 1113.58, -1835.78, 16.60);
 	SetPlayerFacingAngle(playerid, 90.35);
 	SetPlayerVirtualWorld(playerid, 0);
 	PlayerInfo[playerid][pCarLic] = 1;
 	return true;
}	


stock FailBangB2(playerid)
{
 	if(DMV_TestingB2[playerid] == 0) return false;

 	TogglePlayerControllable(playerid, 1);
 	SendClientMessageEx(playerid, COLOR_LIGHTRED, "[THAT BAI]{FFFFFF} Ban da khong hoan thanh tot bai kiem tra lai xe.");
 	DestroyVehicle(XeDangThiB2[playerid]);
    XeDangThiB2[playerid] = INVALID_VEHICLE_ID;
 	DisablePlayerRaceCheckpoint(playerid);
 	DMV_TestingB2[playerid] = 0;
 	DMV_Index[playerid] = 0;
    PlayerInfo[playerid][pDriverLicWarn] = 0;
 	SetPlayerPos(playerid, 1113.58, -1835.78, 16.60);
 	SetPlayerFacingAngle(playerid, 90.35);
 	SetPlayerVirtualWorld(playerid, 0);
 	return true;
}

stock RotBangB2(playerid)
{
 	if(DMV_TestingB2[playerid] == 0) return false;

 	TogglePlayerControllable(playerid, 1);
    SendClientMessageEx(playerid, COLOR_LIGHTRED, "[THAT BAI]{FFFFFF} Ban da vi pham qua 3 lan, cho nen ban da that bai trong vong thi.");
 	//SendClientMessageEx(playerid, COLOR_LIGHTRED, "[THAT BAI]{FFFFFF} Ban da khong hoan thanh tot bai kiem tra lai xe.");
 	DestroyVehicle(XeDangThiB2[playerid]);
    XeDangThiB2[playerid] = INVALID_VEHICLE_ID;
 	DisablePlayerRaceCheckpoint(playerid);
 	DMV_TestingB2[playerid] = 0;
 	DMV_Index[playerid] = 0;
    PlayerInfo[playerid][pDriverLicWarn] = 0;
 	SetPlayerPos(playerid, 1113.58, -1835.78, 16.60);
 	SetPlayerFacingAngle(playerid, 90.35);
 	SetPlayerVirtualWorld(playerid, 0);
 	return true;
}	

Dialog:DRIVER_TEST(playerid, response, listitem, inputtext[]) {
    if (response) {    
        if(listitem == 0)
		{
		    new string[500];
			if(PlayerInfo[playerid][pCash] < 800) return ShowNotifyTextMain(playerid, "Ban khong co du ~y~$800~w~ de tien hanh thi bang lai");
		    if(!IsPlayerInRangeOfPoint(playerid, 5.0, 1113.01, -1835.96, 16.60)) return ShowNotifyTextMain(playerid, "Ban khong o dia diem thi bang lai");
			XeDangThiB2[playerid] = CreateVehicle(496, 1090.29, -1741.54, 13.49, 269.62, random(127), random(127), -1);
			SetPlayerInterior(playerid, 0);
			//SetPlayerVirtualWorld(playerid, 100 + playerid);
			DMV_TestingB2[playerid] = 10;
			VehicleFuel[XeDangThiB2[playerid]] = 100;
			SetPlayerPos(playerid, 1090.29, -1741.54, 13.49);
			format(string, sizeof(string), "Driving Test #%d", playerid);
			SetVehicleNumberPlate(XeDangThiB2[playerid], string);
			ShowNotifyTextMain(playerid, "Hay den diem danh dau mau do va vao phuong tien de tien hanh thi bang lai.");
			SetPlayerFacingAngle(playerid, 269.62);
			PutPlayerInVehicle(playerid, XeDangThiB2[playerid], 0);
			GivePlayerMoneyEx(playerid,-800);
			SetCameraBehindPlayer(playerid);
			format(string, sizeof(string), "\\cHAY DOC LUU Y THI BANG LAI\n\n\
										1. Hay luon doc thong bao o phia duoi man hinh khi di vao Checkpoint.\n\
										2. Neu di trong thanh pho, hay giu toc do duoi 60 KM/H khi di vao Checkpoint.\n\
										3. Neu di o duong cao toc hay di toc do duoi 90 KM/H khi di vao Checkpoint.\n\
										4. Neu vi pham qua 3 lan, ban se bi huy cuoc thi.\n\n\
										\\cHay di xe mot cach that can than va khong nen chay qua toc do. Good luck!");
    		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "LICENSE TEST - NEWS | Thi bang lai", string, "Seen!","");
		}  
    }
    return 1;
}

CMD:thibanglai(playerid, params[])
{ 
    if(PlayerInfo[playerid][pCarLic] == 0)
    {
		if(IsPlayerInRangeOfPoint(playerid, 5.0, 1113.01, -1835.96, 16.60))
		{
			Dialog_Show(playerid, DRIVER_TEST, DIALOG_STYLE_TABLIST_HEADERS, "Driver Test | LSRvn",
																	"#\tChi phi thi bang lai\n\
																	Bang lai xe\t$800","Lua chon", "Thoat");		
		}
	}
    return 1;
}

stock SetPlayerRaceCheckpointEx(playerid, type, Float:x, Float:y, Float:z, Float:nextx, Float:nexty, Float:nextz, Float:size)
{
	SetTimerEx("New_SetPlayerRaceCheckpoint", 200, 0, "ddfffffff", playerid, type, x, y, z, nextx, nexty, nextz, size);
}

forward New_SetPlayerRaceCheckpoint(playerid, type, Float:x, Float:y, Float:z, Float:nextx, Float:nexty, Float:nextz, Float:size);
public New_SetPlayerRaceCheckpoint(playerid, type, Float:x, Float:y, Float:z, Float:nextx, Float:nexty, Float:nextz, Float:size)
{
	DisablePlayerRaceCheckpoint(playerid);
	return SetPlayerRaceCheckpoint(playerid, type, x, y, z, nextx, nexty, nextz, size);
}


CMD:banglai(playerid, params[]) {
	return cmd_licenses(playerid, params);
}
CMD:licenses(playerid, params[])
{
	new string[128], text1[20], text2[20], text3[20], text4[20];
	if(PlayerInfo[playerid][pCarLic]) { text1 = "Acquired"; } else { text1 = "Not acquired"; }
	if(PlayerInfo[playerid][pFlyLic]) { text4 = "Acquired"; } else { text4 = "Not acquired"; }
	if(PlayerInfo[playerid][pBoatLic]) { text2 = "Acquired"; } else { text2 = "Not acquired"; }
	if(PlayerInfo[playerid][pTaxiLicense]) { text3 = "Acquired"; } else { text3 = "Not acquired"; }
	SendClientMessageEx(playerid, COLOR_WHITE, "Your licenses...");
	format(string, sizeof(string), "** Giay phep lai xe: %s.", text1);
	SendClientMessageEx(playerid, COLOR_GREY, string);
	format(string, sizeof(string), "** Giay phep may bay: %s.", text4);
	SendClientMessageEx(playerid, COLOR_GREY, string);
	format(string, sizeof(string), "** Giay phep thuyen: %s.", text2);
	SendClientMessageEx(playerid, COLOR_GREY, string);
	format(string, sizeof(string), "** Giay phep taxi: %s.", text3);
	SendClientMessageEx(playerid, COLOR_GREY, string);
	return 1;
}

CMD:showid(playerid, params[])
{
	return cmd_choxemgiayphep(playerid, params);
}

CMD:choxemgiayphep(playerid, params[])
{
	new string[128], giveplayerid;
	if(sscanf(params, "u", giveplayerid)) return SendUsageMessage(playerid, " /choxemgiayphep [player]");

	if(IsPlayerConnected(giveplayerid))
	{
		if (ProxDetectorS(8.0, playerid, giveplayerid))
		{
			if(giveplayerid == playerid) { SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the hien giay phep cho chinh ban - su dung /licenses cho rang."); return 1; }
			new text1[20], text2[20], text3[20], text4[20];
			if(PlayerInfo[playerid][pCarLic]) { text1 = "Acquired"; } else { text1 = "Not acquired"; }
			if(PlayerInfo[playerid][pFlyLic]) { text4 = "Acquired"; } else { text4 = "Not acquired"; }
			if(PlayerInfo[playerid][pBoatLic]) { text2 = "Acquired"; } else { text2 = "Not acquired"; }
			if(PlayerInfo[playerid][pTaxiLicense]) { text3 = "Acquired"; } else { text3 = "Not acquired"; }
			switch(PlayerInfo[playerid][pNation])
			{
				case 0:
				{
					SendClientMessageEx(giveplayerid, COLOR_WHITE, "** Cong dan cua Los Santos **");
				}
				case 1:
				{
					SendClientMessageEx(giveplayerid, COLOR_TR, "** Cong dan cua San Fierro  **");
				}
			}
			format(string, sizeof(string), "Listing %s's licenses...", GetPlayerNameEx(playerid));
			SendClientMessageEx(giveplayerid, COLOR_WHITE, string);
			format(string, sizeof(string), "Date of Birth: %s", PlayerInfo[playerid][pBirthDate]);
			SendClientMessageEx(giveplayerid, COLOR_WHITE, string);
			format(string, sizeof(string), "** Driver's license: %s.", text1);
			SendClientMessageEx(giveplayerid, COLOR_GREY, string);
			format(string, sizeof(string), "** Pilot license: %s.", text4);
			SendClientMessageEx(giveplayerid, COLOR_GREY, string);
			format(string, sizeof(string), "** Boating license: %s.", text2);
			SendClientMessageEx(giveplayerid, COLOR_GREY, string);
			format(string, sizeof(string), "** Taxi license: %s.", text3);
			SendClientMessageEx(giveplayerid, COLOR_GREY, string);
			format(string, sizeof(string), "* %s has shown their licenses to you.", GetPlayerNameEx(playerid));
			SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
			format(string, sizeof(string), "* You have shown your licenses to %s.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Nguoi choi do khong gan ban.");
			return 1;
		}

	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GREY, "Nguoi choi khong hop le.");
		return 1;
	}
	return 1;
}
