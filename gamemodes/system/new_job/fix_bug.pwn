// task UpdateBugLabel[30000]()
// {
// 	for(new i = 0 ; i < MAX_PLAYERS; i++) {
// 		if(!IsPlayerConnected(i)) {
// 			if(IsValidVehicle(PlayerVehicleRent[i]) ) DestroyVehicle(PlayerVehicleRent[i] );
//             PlayerVehicleRent[i] = INVALID_VEHICLE_ID;
//             if(Trash_TextVehicle[i] != INVALID_3DTEXT_ID) Delete3DTextLabel(Trash_TextVehicle[i]);
//             if(Pizza_TextVehicle[i] != INVALID_3DTEXT_ID) Delete3DTextLabel(Pizza_TextVehicle[i]);
//             Trash_TextVehicle[i]= INVALID_3DTEXT_ID;
//             Pizza_TextVehicle[i]= INVALID_3DTEXT_ID;
//             for(new j = 0 ; j < 5; j++) {
//             	if(IsValidDynamicObject(MinerObjVehicle[i][j])) DestroyDynamicObject(MinerObjVehicle[i][j]);

//             }
//             for(new j = 0 ; j < 6 ; j++) { 
//             	if(IsValidDynamicObject(BoxInTruckObj[i][j])) DestroyDynamicObject(BoxInTruckObj[i][j]);
//             }

// 		}
		
// 	}
// 	return 1;
// }