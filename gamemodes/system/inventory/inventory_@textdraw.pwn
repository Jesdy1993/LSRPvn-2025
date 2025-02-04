new PlayerText:Inventory_@Slot[MAX_PLAYERS][16];
new PlayerText:Inventory_@Amount[MAX_PLAYERS][16];
new PlayerText:Inventory_@Main[MAX_PLAYERS][14];
new PlayerText:Inventory_@CharacterSlot[MAX_PLAYERS][4];
new PlayerText:Inventory_Weapon[MAX_PLAYERS][4];

stock CreateInventoryTD(playerid) {
 
    Inventory_@Main[playerid][0] = CreatePlayerTextDraw(playerid, 478.3334, 135.9924, "Box"); // ïóñòî
    PlayerTextDrawLetterSize(playerid, Inventory_@Main[playerid][0], 0.0000, 24.5832);
    PlayerTextDrawTextSize(playerid, Inventory_@Main[playerid][0], 625.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, Inventory_@Main[playerid][0], 1);
    PlayerTextDrawColor(playerid, Inventory_@Main[playerid][0], -1);
    PlayerTextDrawUseBox(playerid, Inventory_@Main[playerid][0], 1);
    PlayerTextDrawBoxColor(playerid, Inventory_@Main[playerid][0], 117901805);
    PlayerTextDrawBackgroundColor(playerid, Inventory_@Main[playerid][0], 255);
    PlayerTextDrawFont(playerid, Inventory_@Main[playerid][0], 1);
    PlayerTextDrawSetProportional(playerid, Inventory_@Main[playerid][0], 1);
    PlayerTextDrawSetShadow(playerid, Inventory_@Main[playerid][0], 0);
    
    Inventory_@Main[playerid][1] = CreatePlayerTextDraw(playerid, 551.5822, 136.2109, "INVENTORY"); // ïóñòî
    PlayerTextDrawLetterSize(playerid, Inventory_@Main[playerid][1], 0.2549, 1.4548);
    PlayerTextDrawTextSize(playerid, Inventory_@Main[playerid][1], 0.0000, 147.0000);
    PlayerTextDrawAlignment(playerid, Inventory_@Main[playerid][1], 2);
    PlayerTextDrawColor(playerid, Inventory_@Main[playerid][1], -1);
    PlayerTextDrawUseBox(playerid, Inventory_@Main[playerid][1], 1);
    PlayerTextDrawBoxColor(playerid, Inventory_@Main[playerid][1], -1523963234);
    PlayerTextDrawBackgroundColor(playerid, Inventory_@Main[playerid][1], 255);
    PlayerTextDrawFont(playerid, Inventory_@Main[playerid][1], 3);
    PlayerTextDrawSetProportional(playerid, Inventory_@Main[playerid][1], 1);
    PlayerTextDrawSetShadow(playerid, Inventory_@Main[playerid][1], 0);
    
    
    Inventory_@Main[playerid][2] = CreatePlayerTextDraw(playerid, 496.3334, 343.7738, ">"); // ïóñòî
    PlayerTextDrawLetterSize(playerid, Inventory_@Main[playerid][2], 0.1864, 1.3666);
    PlayerTextDrawTextSize(playerid, Inventory_@Main[playerid][2], 15.0000, 34.0000);
    PlayerTextDrawAlignment(playerid, Inventory_@Main[playerid][2], 2);
    PlayerTextDrawColor(playerid, Inventory_@Main[playerid][2], -1);
    PlayerTextDrawUseBox(playerid, Inventory_@Main[playerid][2], 1);
    PlayerTextDrawBoxColor(playerid, Inventory_@Main[playerid][2], 522133194);
    PlayerTextDrawBackgroundColor(playerid, Inventory_@Main[playerid][2], 255);
    PlayerTextDrawFont(playerid, Inventory_@Main[playerid][2], 1);
    PlayerTextDrawSetProportional(playerid, Inventory_@Main[playerid][2], 1);
    PlayerTextDrawSetShadow(playerid, Inventory_@Main[playerid][2], 0);
    PlayerTextDrawSetSelectable(playerid, Inventory_@Main[playerid][2], true);
    
    Inventory_@Main[playerid][3] = CreatePlayerTextDraw(playerid, 607.0670, 343.7738, "<"); // ïóñòî
    PlayerTextDrawLetterSize(playerid, Inventory_@Main[playerid][3], 0.1864, 1.3666);
    PlayerTextDrawTextSize(playerid, Inventory_@Main[playerid][3], 15.0000, 34.0000);
    PlayerTextDrawAlignment(playerid, Inventory_@Main[playerid][3], 2);
    PlayerTextDrawColor(playerid, Inventory_@Main[playerid][3], -1);
    PlayerTextDrawUseBox(playerid, Inventory_@Main[playerid][3], 1);
    PlayerTextDrawBoxColor(playerid, Inventory_@Main[playerid][3], 522133194);
    PlayerTextDrawBackgroundColor(playerid, Inventory_@Main[playerid][3], 255);
    PlayerTextDrawFont(playerid, Inventory_@Main[playerid][3], 1);
    PlayerTextDrawSetProportional(playerid, Inventory_@Main[playerid][3], 1);
    PlayerTextDrawSetShadow(playerid, Inventory_@Main[playerid][3], 0);
    PlayerTextDrawSetSelectable(playerid, Inventory_@Main[playerid][3], true);
    
    Inventory_@Main[playerid][4] = CreatePlayerTextDraw(playerid, 545.4166, 344.5184, "10/10"); // ïóñòî
    PlayerTextDrawLetterSize(playerid, Inventory_@Main[playerid][4], 0.1615, 1.2474);
    PlayerTextDrawAlignment(playerid, Inventory_@Main[playerid][4], 1);
    PlayerTextDrawColor(playerid, Inventory_@Main[playerid][4], -1);
    PlayerTextDrawBackgroundColor(playerid, Inventory_@Main[playerid][4], 255);
    PlayerTextDrawFont(playerid, Inventory_@Main[playerid][4], 1);
    PlayerTextDrawSetProportional(playerid, Inventory_@Main[playerid][4], 1);
    PlayerTextDrawSetShadow(playerid, Inventory_@Main[playerid][4], 0);
    
    Inventory_@Main[playerid][5] = CreatePlayerTextDraw(playerid, 361.2499, 135.9924, "Box"); // ïóñòî
    PlayerTextDrawLetterSize(playerid, Inventory_@Main[playerid][5], 0.0000, 16.1665);
    PlayerTextDrawTextSize(playerid, Inventory_@Main[playerid][5], 475.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, Inventory_@Main[playerid][5], 1);
    PlayerTextDrawColor(playerid, Inventory_@Main[playerid][5], -1);
    PlayerTextDrawUseBox(playerid, Inventory_@Main[playerid][5], 1);
    PlayerTextDrawBoxColor(playerid, Inventory_@Main[playerid][5], 117901805);
    PlayerTextDrawBackgroundColor(playerid, Inventory_@Main[playerid][5], 255);
    PlayerTextDrawFont(playerid, Inventory_@Main[playerid][5], 1);
    PlayerTextDrawSetProportional(playerid, Inventory_@Main[playerid][5], 1);
    PlayerTextDrawSetShadow(playerid, Inventory_@Main[playerid][5], 0);
    
    Inventory_@Main[playerid][6] = CreatePlayerTextDraw(playerid, 369.6163, 150.8518, ""); // ïóñòî
    PlayerTextDrawTextSize(playerid, Inventory_@Main[playerid][6], 90.0000, 90.0000);
    PlayerTextDrawAlignment(playerid, Inventory_@Main[playerid][6], 1);
    PlayerTextDrawColor(playerid, Inventory_@Main[playerid][6], -1);
    PlayerTextDrawBackgroundColor(playerid, Inventory_@Main[playerid][6], 1);
    PlayerTextDrawFont(playerid, Inventory_@Main[playerid][6], 5);
    PlayerTextDrawSetProportional(playerid, Inventory_@Main[playerid][6], 0);
    PlayerTextDrawSetShadow(playerid, Inventory_@Main[playerid][6], 0);
    PlayerTextDrawSetPreviewModel(playerid, Inventory_@Main[playerid][6], 52);
    PlayerTextDrawSetPreviewRot(playerid, Inventory_@Main[playerid][6], 0.0000, 0.0000, 0.0000, 1.0000);
    
    Inventory_@Main[playerid][7] = CreatePlayerTextDraw(playerid, 417.7323, 136.2478, "CHARACTER"); // ïóñòî
    PlayerTextDrawLetterSize(playerid, Inventory_@Main[playerid][7], 0.2549, 1.4548);
    PlayerTextDrawTextSize(playerid, Inventory_@Main[playerid][7], 0.0000, 114.0000);
    PlayerTextDrawAlignment(playerid, Inventory_@Main[playerid][7], 2);
    PlayerTextDrawColor(playerid, Inventory_@Main[playerid][7], -1);
    PlayerTextDrawUseBox(playerid, Inventory_@Main[playerid][7], 1);
    PlayerTextDrawBoxColor(playerid, Inventory_@Main[playerid][7], 2125030826);
    PlayerTextDrawBackgroundColor(playerid, Inventory_@Main[playerid][7], 255);
    PlayerTextDrawFont(playerid, Inventory_@Main[playerid][7], 3);
    PlayerTextDrawSetProportional(playerid, Inventory_@Main[playerid][7], 1);
    PlayerTextDrawSetShadow(playerid, Inventory_@Main[playerid][7], 0);
    

    
 
    Inventory_@Main[playerid][8] = CreatePlayerTextDraw(playerid, 450.8328, 288.5184, "USE"); // ïóñòî
    PlayerTextDrawLetterSize(playerid, Inventory_@Main[playerid][8], 0.1961, 1.2884);
    PlayerTextDrawTextSize(playerid, Inventory_@Main[playerid][8], 5.0000, 46.0000);
    PlayerTextDrawAlignment(playerid, Inventory_@Main[playerid][8], 2);
    PlayerTextDrawColor(playerid, Inventory_@Main[playerid][8], -1);
    PlayerTextDrawUseBox(playerid, Inventory_@Main[playerid][8], 1);
    PlayerTextDrawBoxColor(playerid, Inventory_@Main[playerid][8], 1269132279);
    PlayerTextDrawBackgroundColor(playerid, Inventory_@Main[playerid][8], 255);
    PlayerTextDrawFont(playerid, Inventory_@Main[playerid][8], 1);
    PlayerTextDrawSetProportional(playerid, Inventory_@Main[playerid][8], 1);
    PlayerTextDrawSetShadow(playerid, Inventory_@Main[playerid][8], 0);
    PlayerTextDrawSetSelectable(playerid, Inventory_@Main[playerid][8], true);
    
    Inventory_@Main[playerid][9] = CreatePlayerTextDraw(playerid, 450.9162, 305.0379, "DROP"); // ïóñòî
    PlayerTextDrawLetterSize(playerid, Inventory_@Main[playerid][9], 0.2319, 1.1743);
    PlayerTextDrawTextSize(playerid, Inventory_@Main[playerid][9], 10.0000, 46.0000);
    PlayerTextDrawAlignment(playerid, Inventory_@Main[playerid][9], 2);
    PlayerTextDrawColor(playerid, Inventory_@Main[playerid][9], -1);
    PlayerTextDrawUseBox(playerid, Inventory_@Main[playerid][9], 1);
    PlayerTextDrawBoxColor(playerid, Inventory_@Main[playerid][9], -1521923585);
    PlayerTextDrawBackgroundColor(playerid, Inventory_@Main[playerid][9], 255);
    PlayerTextDrawFont(playerid, Inventory_@Main[playerid][9], 1);
    PlayerTextDrawSetProportional(playerid, Inventory_@Main[playerid][9], 1);
    PlayerTextDrawSetShadow(playerid, Inventory_@Main[playerid][9], 0);
    PlayerTextDrawSetSelectable(playerid, Inventory_@Main[playerid][9], true);
    
    Inventory_@Main[playerid][10] = CreatePlayerTextDraw(playerid, 450.9162, 320.0388, "INFORMATION"); // ïóñòî
    PlayerTextDrawLetterSize(playerid, Inventory_@Main[playerid][10], 0.1907, 1.1899);
    PlayerTextDrawTextSize(playerid, Inventory_@Main[playerid][10], 10.0000, 46.0000);
    PlayerTextDrawAlignment(playerid, Inventory_@Main[playerid][10], 2);
    PlayerTextDrawColor(playerid, Inventory_@Main[playerid][10], -1);
    PlayerTextDrawUseBox(playerid, Inventory_@Main[playerid][10], 1);
    PlayerTextDrawBoxColor(playerid, Inventory_@Main[playerid][10], -1061109505);
    PlayerTextDrawBackgroundColor(playerid, Inventory_@Main[playerid][10], 255);
    PlayerTextDrawFont(playerid, Inventory_@Main[playerid][10], 1);
    PlayerTextDrawSetProportional(playerid, Inventory_@Main[playerid][10], 1);
    PlayerTextDrawSetShadow(playerid, Inventory_@Main[playerid][10], 0);
    PlayerTextDrawSetSelectable(playerid, Inventory_@Main[playerid][10], true);
    
    Inventory_@Main[playerid][11] = CreatePlayerTextDraw(playerid, 450.9162, 335.2397, "MOVE"); // ïóñòî
    PlayerTextDrawLetterSize(playerid, Inventory_@Main[playerid][11], 0.1907, 1.1899);
    PlayerTextDrawTextSize(playerid, Inventory_@Main[playerid][11], 10.0000, 46.0000);
    PlayerTextDrawAlignment(playerid, Inventory_@Main[playerid][11], 2);
    PlayerTextDrawColor(playerid, Inventory_@Main[playerid][11], -1);
    PlayerTextDrawUseBox(playerid, Inventory_@Main[playerid][11], 1);
    PlayerTextDrawBoxColor(playerid, Inventory_@Main[playerid][11], -1061109505);
    PlayerTextDrawBackgroundColor(playerid, Inventory_@Main[playerid][11], 255);
    PlayerTextDrawFont(playerid, Inventory_@Main[playerid][11], 1);
    PlayerTextDrawSetProportional(playerid, Inventory_@Main[playerid][11], 1);
    PlayerTextDrawSetShadow(playerid, Inventory_@Main[playerid][11], 0);
    PlayerTextDrawSetSelectable(playerid, Inventory_@Main[playerid][11], true);



    Inventory_@Main[playerid][12] = CreatePlayerTextDraw(playerid, 619.0499, 137.5110, "X"); // ïóñòî
    PlayerTextDrawLetterSize(playerid, Inventory_@Main[playerid][12], 0.2962, 1.0865);
    PlayerTextDrawTextSize(playerid, Inventory_@Main[playerid][12], 10.0000, 8.0000);
    PlayerTextDrawAlignment(playerid, Inventory_@Main[playerid][12], 2);
    PlayerTextDrawColor(playerid, Inventory_@Main[playerid][12], -1);
    PlayerTextDrawUseBox(playerid, Inventory_@Main[playerid][12], 1);
    PlayerTextDrawBoxColor(playerid, Inventory_@Main[playerid][12], -1523963137);
    PlayerTextDrawBackgroundColor(playerid, Inventory_@Main[playerid][12], 255);
    PlayerTextDrawFont(playerid, Inventory_@Main[playerid][12], 1);
    PlayerTextDrawSetProportional(playerid, Inventory_@Main[playerid][12], 1);
    PlayerTextDrawSetShadow(playerid, Inventory_@Main[playerid][12], 0);
    PlayerTextDrawSetSelectable(playerid, Inventory_@Main[playerid][12], true);
    
    Inventory_@Main[playerid][13] = CreatePlayerTextDraw(playerid, 417.0831, 252.7407, "cuozg_nguyen"); // ïóñòî
    PlayerTextDrawLetterSize(playerid, Inventory_@Main[playerid][13], 0.4070, 1.9524);
    PlayerTextDrawAlignment(playerid, Inventory_@Main[playerid][13], 2);
    PlayerTextDrawColor(playerid, Inventory_@Main[playerid][13], -1);
    PlayerTextDrawBackgroundColor(playerid, Inventory_@Main[playerid][13], 255);
    PlayerTextDrawFont(playerid, Inventory_@Main[playerid][13], 0);
    PlayerTextDrawSetProportional(playerid, Inventory_@Main[playerid][13], 1);
    PlayerTextDrawSetShadow(playerid, Inventory_@Main[playerid][13], 0);


    Inventory_Weapon[playerid][0] = CreatePlayerTextDraw(playerid, 363.4833, 155.0997, ""); // ïóñòî
    PlayerTextDrawTextSize(playerid, Inventory_Weapon[playerid][0], 36.0000, 46.0000);
    PlayerTextDrawAlignment(playerid, Inventory_Weapon[playerid][0], 1);
    PlayerTextDrawColor(playerid, Inventory_Weapon[playerid][0], -1);
    PlayerTextDrawBackgroundColor(playerid, Inventory_Weapon[playerid][0], 522133194);
    PlayerTextDrawFont(playerid, Inventory_Weapon[playerid][0], 5);
    PlayerTextDrawSetProportional(playerid, Inventory_Weapon[playerid][0], 0);
    PlayerTextDrawSetShadow(playerid, Inventory_Weapon[playerid][0], 0);
    PlayerTextDrawSetSelectable(playerid, Inventory_Weapon[playerid][0], true);
    PlayerTextDrawSetPreviewModel(playerid, Inventory_Weapon[playerid][0], 1721);
    PlayerTextDrawSetPreviewRot(playerid, Inventory_Weapon[playerid][0], 0.0000, 0.0000, 0.0000, 1.0000);
    
    Inventory_Weapon[playerid][1] = CreatePlayerTextDraw(playerid, 363.4833, 202.1221, ""); // ïóñòî
    PlayerTextDrawTextSize(playerid, Inventory_Weapon[playerid][1], 36.0000, 46.0000);
    PlayerTextDrawAlignment(playerid, Inventory_Weapon[playerid][1], 1);
    PlayerTextDrawColor(playerid, Inventory_Weapon[playerid][1], -1);
    PlayerTextDrawBackgroundColor(playerid, Inventory_Weapon[playerid][1], 522133194);
    PlayerTextDrawFont(playerid, Inventory_Weapon[playerid][1], 5);
    PlayerTextDrawSetProportional(playerid, Inventory_Weapon[playerid][1], 0);
    PlayerTextDrawSetShadow(playerid, Inventory_Weapon[playerid][1], 0);
    PlayerTextDrawSetSelectable(playerid, Inventory_Weapon[playerid][1], true);
    PlayerTextDrawSetPreviewModel(playerid, Inventory_Weapon[playerid][1], 1721);
    PlayerTextDrawSetPreviewRot(playerid, Inventory_Weapon[playerid][1], 0.0000, 0.0000, 0.0000, 1.0000);
    
    Inventory_Weapon[playerid][2] = CreatePlayerTextDraw(playerid, 435.9830, 155.4553, ""); // ïóñòî
    PlayerTextDrawTextSize(playerid, Inventory_Weapon[playerid][2], 36.0000, 46.0000);
    PlayerTextDrawAlignment(playerid, Inventory_Weapon[playerid][2], 1);
    PlayerTextDrawColor(playerid, Inventory_Weapon[playerid][2], -1);
    PlayerTextDrawBackgroundColor(playerid, Inventory_Weapon[playerid][2], 522133194);
    PlayerTextDrawFont(playerid, Inventory_Weapon[playerid][2], 5);
    PlayerTextDrawSetProportional(playerid, Inventory_Weapon[playerid][2], 0);
    PlayerTextDrawSetShadow(playerid, Inventory_Weapon[playerid][2], 0);
    PlayerTextDrawSetSelectable(playerid, Inventory_Weapon[playerid][2], true);
    PlayerTextDrawSetPreviewModel(playerid, Inventory_Weapon[playerid][2], 1721);
    PlayerTextDrawSetPreviewRot(playerid, Inventory_Weapon[playerid][2], 0.0000, 0.0000, 0.0000, 1.0000);
    
    Inventory_Weapon[playerid][3] = CreatePlayerTextDraw(playerid, 435.8663, 202.7776, ""); // ïóñòî
    PlayerTextDrawTextSize(playerid, Inventory_Weapon[playerid][3], 36.0000, 46.0000);
    PlayerTextDrawAlignment(playerid, Inventory_Weapon[playerid][3], 1);
    PlayerTextDrawColor(playerid, Inventory_Weapon[playerid][3], -1);
    PlayerTextDrawBackgroundColor(playerid, Inventory_Weapon[playerid][3], 522133194);
    PlayerTextDrawFont(playerid, Inventory_Weapon[playerid][3], 5);
    PlayerTextDrawSetProportional(playerid, Inventory_Weapon[playerid][3], 0);
    PlayerTextDrawSetShadow(playerid, Inventory_Weapon[playerid][3], 0);
    PlayerTextDrawSetSelectable(playerid, Inventory_Weapon[playerid][3], true);
    PlayerTextDrawSetPreviewModel(playerid, Inventory_Weapon[playerid][3], 1721);
    PlayerTextDrawSetPreviewRot(playerid, Inventory_Weapon[playerid][3], 0.0000, 0.0000, 0.0000, 1.0000);


    Inventory_@Slot[playerid][0] = CreatePlayerTextDraw(playerid, 478.0668, 153.0258, ""); // ïóñòî
    PlayerTextDrawTextSize(playerid, Inventory_@Slot[playerid][0], 36.0000, 46.0000);
    PlayerTextDrawAlignment(playerid, Inventory_@Slot[playerid][0], 1);
    PlayerTextDrawColor(playerid, Inventory_@Slot[playerid][0], -1);
    PlayerTextDrawBackgroundColor(playerid, Inventory_@Slot[playerid][0], 522133194);
    PlayerTextDrawFont(playerid, Inventory_@Slot[playerid][0], 5);
    PlayerTextDrawSetProportional(playerid, Inventory_@Slot[playerid][0], 0);
    PlayerTextDrawSetShadow(playerid, Inventory_@Slot[playerid][0], 0);
    PlayerTextDrawSetSelectable(playerid, Inventory_@Slot[playerid][0], true);
    PlayerTextDrawSetPreviewModel(playerid, Inventory_@Slot[playerid][0], 1721);
    PlayerTextDrawSetPreviewRot(playerid, Inventory_@Slot[playerid][0], 0.0000, 0.0000, 0.0000, 1.0000);
    
    Inventory_@Slot[playerid][1] = CreatePlayerTextDraw(playerid, 515.2667, 153.0444, ""); // ïóñòî
    PlayerTextDrawTextSize(playerid, Inventory_@Slot[playerid][1], 36.0000, 46.0000);
    PlayerTextDrawAlignment(playerid, Inventory_@Slot[playerid][1], 1);
    PlayerTextDrawColor(playerid, Inventory_@Slot[playerid][1], -1);
    PlayerTextDrawBackgroundColor(playerid, Inventory_@Slot[playerid][1], 522133194);
    PlayerTextDrawFont(playerid, Inventory_@Slot[playerid][1], 5);
    PlayerTextDrawSetProportional(playerid, Inventory_@Slot[playerid][1], 0);
    PlayerTextDrawSetShadow(playerid, Inventory_@Slot[playerid][1], 0);
    PlayerTextDrawSetSelectable(playerid, Inventory_@Slot[playerid][1], true);
    PlayerTextDrawSetPreviewModel(playerid, Inventory_@Slot[playerid][1], 1721);
    PlayerTextDrawSetPreviewRot(playerid, Inventory_@Slot[playerid][1], 0.0000, 0.0000, 0.0000, 1.0000);
    
    Inventory_@Slot[playerid][2] = CreatePlayerTextDraw(playerid, 552.3499, 153.0812, ""); // ïóñòî
    PlayerTextDrawTextSize(playerid, Inventory_@Slot[playerid][2], 36.0000, 46.0000);
    PlayerTextDrawAlignment(playerid, Inventory_@Slot[playerid][2], 1);
    PlayerTextDrawColor(playerid, Inventory_@Slot[playerid][2], -1);
    PlayerTextDrawBackgroundColor(playerid, Inventory_@Slot[playerid][2], 522133194);
    PlayerTextDrawFont(playerid, Inventory_@Slot[playerid][2], 5);
    PlayerTextDrawSetProportional(playerid, Inventory_@Slot[playerid][2], 0);
    PlayerTextDrawSetShadow(playerid, Inventory_@Slot[playerid][2], 0);
    PlayerTextDrawSetSelectable(playerid, Inventory_@Slot[playerid][2], true);
    PlayerTextDrawSetPreviewModel(playerid, Inventory_@Slot[playerid][2], 1721);
    PlayerTextDrawSetPreviewRot(playerid, Inventory_@Slot[playerid][2], 0.0000, 0.0000, 0.0000, 1.0000);
    
    Inventory_@Slot[playerid][3] = CreatePlayerTextDraw(playerid, 589.3004, 152.9627, ""); // ïóñòî
    PlayerTextDrawTextSize(playerid, Inventory_@Slot[playerid][3], 36.0000, 46.0000);
    PlayerTextDrawAlignment(playerid, Inventory_@Slot[playerid][3], 1);
    PlayerTextDrawColor(playerid, Inventory_@Slot[playerid][3], -1);
    PlayerTextDrawBackgroundColor(playerid, Inventory_@Slot[playerid][3], 522133194);
    PlayerTextDrawFont(playerid, Inventory_@Slot[playerid][3], 5);
    PlayerTextDrawSetProportional(playerid, Inventory_@Slot[playerid][3], 0);
    PlayerTextDrawSetShadow(playerid, Inventory_@Slot[playerid][3], 0);
    PlayerTextDrawSetSelectable(playerid, Inventory_@Slot[playerid][3], true);
    PlayerTextDrawSetPreviewModel(playerid, Inventory_@Slot[playerid][3], 1721);
    PlayerTextDrawSetPreviewRot(playerid, Inventory_@Slot[playerid][3], 0.0000, 0.0000, 0.0000, 1.0000);
    
    Inventory_@Slot[playerid][4] = CreatePlayerTextDraw(playerid, 478.0003, 200.1219, ""); // ïóñòî
    PlayerTextDrawTextSize(playerid, Inventory_@Slot[playerid][4], 36.0000, 46.0000);
    PlayerTextDrawAlignment(playerid, Inventory_@Slot[playerid][4], 1);
    PlayerTextDrawColor(playerid, Inventory_@Slot[playerid][4], -1);
    PlayerTextDrawBackgroundColor(playerid, Inventory_@Slot[playerid][4], 522133194);
    PlayerTextDrawFont(playerid, Inventory_@Slot[playerid][4], 5);
    PlayerTextDrawSetProportional(playerid, Inventory_@Slot[playerid][4], 0);
    PlayerTextDrawSetShadow(playerid, Inventory_@Slot[playerid][4], 0);
    PlayerTextDrawSetSelectable(playerid, Inventory_@Slot[playerid][4], true);
    PlayerTextDrawSetPreviewModel(playerid, Inventory_@Slot[playerid][4], 1721);
    PlayerTextDrawSetPreviewRot(playerid, Inventory_@Slot[playerid][4], 0.0000, 0.0000, 0.0000, 1.0000);
    
    Inventory_@Slot[playerid][5] = CreatePlayerTextDraw(playerid, 515.1837, 200.2220, ""); // ïóñòî
    PlayerTextDrawTextSize(playerid, Inventory_@Slot[playerid][5], 36.0000, 46.0000);
    PlayerTextDrawAlignment(playerid, Inventory_@Slot[playerid][5], 1);
    PlayerTextDrawColor(playerid, Inventory_@Slot[playerid][5], -1);
    PlayerTextDrawBackgroundColor(playerid, Inventory_@Slot[playerid][5], 522133194);
    PlayerTextDrawFont(playerid, Inventory_@Slot[playerid][5], 5);
    PlayerTextDrawSetProportional(playerid, Inventory_@Slot[playerid][5], 0);
    PlayerTextDrawSetShadow(playerid, Inventory_@Slot[playerid][5], 0);
    PlayerTextDrawSetSelectable(playerid, Inventory_@Slot[playerid][5], true);
    PlayerTextDrawSetPreviewModel(playerid, Inventory_@Slot[playerid][5], 1721);
    PlayerTextDrawSetPreviewRot(playerid, Inventory_@Slot[playerid][5], 0.0000, 0.0000, 0.0000, 1.0000);
    
    Inventory_@Slot[playerid][6] = CreatePlayerTextDraw(playerid, 552.2678, 200.4219, ""); // ïóñòî
    PlayerTextDrawTextSize(playerid, Inventory_@Slot[playerid][6], 36.0000, 46.0000);
    PlayerTextDrawAlignment(playerid, Inventory_@Slot[playerid][6], 1);
    PlayerTextDrawColor(playerid, Inventory_@Slot[playerid][6], -1);
    PlayerTextDrawBackgroundColor(playerid, Inventory_@Slot[playerid][6], 522133194);
    PlayerTextDrawFont(playerid, Inventory_@Slot[playerid][6], 5);
    PlayerTextDrawSetProportional(playerid, Inventory_@Slot[playerid][6], 0);
    PlayerTextDrawSetShadow(playerid, Inventory_@Slot[playerid][6], 0);
    PlayerTextDrawSetSelectable(playerid, Inventory_@Slot[playerid][6], true);
    PlayerTextDrawSetPreviewModel(playerid, Inventory_@Slot[playerid][6], 1721);
    PlayerTextDrawSetPreviewRot(playerid, Inventory_@Slot[playerid][6], 0.0000, 0.0000, 0.0000, 1.0000);
    
    Inventory_@Slot[playerid][7] = CreatePlayerTextDraw(playerid, 589.2340, 200.5590, ""); // ïóñòî
    PlayerTextDrawTextSize(playerid, Inventory_@Slot[playerid][7], 36.0000, 46.0000);
    PlayerTextDrawAlignment(playerid, Inventory_@Slot[playerid][7], 1);
    PlayerTextDrawColor(playerid, Inventory_@Slot[playerid][7], -1);
    PlayerTextDrawBackgroundColor(playerid, Inventory_@Slot[playerid][7], 522133194);
    PlayerTextDrawFont(playerid, Inventory_@Slot[playerid][7], 5);
    PlayerTextDrawSetProportional(playerid, Inventory_@Slot[playerid][7], 0);
    PlayerTextDrawSetShadow(playerid, Inventory_@Slot[playerid][7], 0);
    PlayerTextDrawSetSelectable(playerid, Inventory_@Slot[playerid][7], true);
    PlayerTextDrawSetPreviewModel(playerid, Inventory_@Slot[playerid][7], 1721);
    PlayerTextDrawSetPreviewRot(playerid, Inventory_@Slot[playerid][7], 0.0000, 0.0000, 0.0000, 1.0000);
    
    Inventory_@Slot[playerid][8] = CreatePlayerTextDraw(playerid, 478.1174, 247.4071, ""); // ïóñòî
    PlayerTextDrawTextSize(playerid, Inventory_@Slot[playerid][8], 36.0000, 46.0000);
    PlayerTextDrawAlignment(playerid, Inventory_@Slot[playerid][8], 1);
    PlayerTextDrawColor(playerid, Inventory_@Slot[playerid][8], -1);
    PlayerTextDrawBackgroundColor(playerid, Inventory_@Slot[playerid][8], 522133194);
    PlayerTextDrawFont(playerid, Inventory_@Slot[playerid][8], 5);
    PlayerTextDrawSetProportional(playerid, Inventory_@Slot[playerid][8], 0);
    PlayerTextDrawSetShadow(playerid, Inventory_@Slot[playerid][8], 0);
    PlayerTextDrawSetSelectable(playerid, Inventory_@Slot[playerid][8], true);
    PlayerTextDrawSetPreviewModel(playerid, Inventory_@Slot[playerid][8], 1721);
    PlayerTextDrawSetPreviewRot(playerid, Inventory_@Slot[playerid][8], 0.0000, 0.0000, 0.0000, 1.0000);
    
    Inventory_@Slot[playerid][9] = CreatePlayerTextDraw(playerid, 515.0006, 247.4626, ""); // ïóñòî
    PlayerTextDrawTextSize(playerid, Inventory_@Slot[playerid][9], 36.0000, 46.0000);
    PlayerTextDrawAlignment(playerid, Inventory_@Slot[playerid][9], 1);
    PlayerTextDrawColor(playerid, Inventory_@Slot[playerid][9], -1);
    PlayerTextDrawBackgroundColor(playerid, Inventory_@Slot[playerid][9], 522133194);
    PlayerTextDrawFont(playerid, Inventory_@Slot[playerid][9], 5);
    PlayerTextDrawSetProportional(playerid, Inventory_@Slot[playerid][9], 0);
    PlayerTextDrawSetShadow(playerid, Inventory_@Slot[playerid][9], 0);
    PlayerTextDrawSetSelectable(playerid, Inventory_@Slot[playerid][9], true);
    PlayerTextDrawSetPreviewModel(playerid, Inventory_@Slot[playerid][9], 1721);
    PlayerTextDrawSetPreviewRot(playerid, Inventory_@Slot[playerid][9], 0.0000, 0.0000, 0.0000, 1.0000);
    
    Inventory_@Slot[playerid][10] = CreatePlayerTextDraw(playerid, 552.1511, 247.6811, ""); // ïóñòî
    PlayerTextDrawTextSize(playerid, Inventory_@Slot[playerid][10], 36.0000, 46.0000);
    PlayerTextDrawAlignment(playerid, Inventory_@Slot[playerid][10], 1);
    PlayerTextDrawColor(playerid, Inventory_@Slot[playerid][10], -1);
    PlayerTextDrawBackgroundColor(playerid, Inventory_@Slot[playerid][10], 522133194);
    PlayerTextDrawFont(playerid, Inventory_@Slot[playerid][10], 5);
    PlayerTextDrawSetProportional(playerid, Inventory_@Slot[playerid][10], 0);
    PlayerTextDrawSetShadow(playerid, Inventory_@Slot[playerid][10], 0);
    PlayerTextDrawSetSelectable(playerid, Inventory_@Slot[playerid][10], true);
    PlayerTextDrawSetPreviewModel(playerid, Inventory_@Slot[playerid][10], 1721);
    PlayerTextDrawSetPreviewRot(playerid, Inventory_@Slot[playerid][10], 0.0000, 0.0000, 0.0000, 1.0000);
    
    Inventory_@Slot[playerid][11] = CreatePlayerTextDraw(playerid, 589.3681, 247.7810, ""); // ïóñòî
    PlayerTextDrawTextSize(playerid, Inventory_@Slot[playerid][11], 36.0000, 46.0000);
    PlayerTextDrawAlignment(playerid, Inventory_@Slot[playerid][11], 1);
    PlayerTextDrawColor(playerid, Inventory_@Slot[playerid][11], -1);
    PlayerTextDrawBackgroundColor(playerid, Inventory_@Slot[playerid][11], 522133194);
    PlayerTextDrawFont(playerid, Inventory_@Slot[playerid][11], 5);
    PlayerTextDrawSetProportional(playerid, Inventory_@Slot[playerid][11], 0);
    PlayerTextDrawSetShadow(playerid, Inventory_@Slot[playerid][11], 0);
    PlayerTextDrawSetSelectable(playerid, Inventory_@Slot[playerid][11], true);
    PlayerTextDrawSetPreviewModel(playerid, Inventory_@Slot[playerid][11], 1721);
    PlayerTextDrawSetPreviewRot(playerid, Inventory_@Slot[playerid][11], 0.0000, 0.0000, 0.0000, 1.0000);
    
    Inventory_@Slot[playerid][12] = CreatePlayerTextDraw(playerid, 478.0014, 294.6661, ""); // ïóñòî
    PlayerTextDrawTextSize(playerid, Inventory_@Slot[playerid][12], 36.0000, 46.0000);
    PlayerTextDrawAlignment(playerid, Inventory_@Slot[playerid][12], 1);
    PlayerTextDrawColor(playerid, Inventory_@Slot[playerid][12], -1);
    PlayerTextDrawBackgroundColor(playerid, Inventory_@Slot[playerid][12], 522133194);
    PlayerTextDrawFont(playerid, Inventory_@Slot[playerid][12], 5);
    PlayerTextDrawSetProportional(playerid, Inventory_@Slot[playerid][12], 0);
    PlayerTextDrawSetShadow(playerid, Inventory_@Slot[playerid][12], 0);
    PlayerTextDrawSetSelectable(playerid, Inventory_@Slot[playerid][12], true);
    PlayerTextDrawSetPreviewModel(playerid, Inventory_@Slot[playerid][12], 1721);
    PlayerTextDrawSetPreviewRot(playerid, Inventory_@Slot[playerid][12], 0.0000, 0.0000, 0.0000, 1.0000);
    
    Inventory_@Slot[playerid][13] = CreatePlayerTextDraw(playerid, 514.9353, 294.6664, ""); // ïóñòî
    PlayerTextDrawTextSize(playerid, Inventory_@Slot[playerid][13], 36.0000, 46.0000);
    PlayerTextDrawAlignment(playerid, Inventory_@Slot[playerid][13], 1);
    PlayerTextDrawColor(playerid, Inventory_@Slot[playerid][13], -1);
    PlayerTextDrawBackgroundColor(playerid, Inventory_@Slot[playerid][13], 522133194);
    PlayerTextDrawFont(playerid, Inventory_@Slot[playerid][13], 5);
    PlayerTextDrawSetProportional(playerid, Inventory_@Slot[playerid][13], 0);
    PlayerTextDrawSetShadow(playerid, Inventory_@Slot[playerid][13], 0);
    PlayerTextDrawSetSelectable(playerid, Inventory_@Slot[playerid][13], true);
    PlayerTextDrawSetPreviewModel(playerid, Inventory_@Slot[playerid][13], 1721);
    PlayerTextDrawSetPreviewRot(playerid, Inventory_@Slot[playerid][13], 0.0000, 0.0000, 0.0000, 1.0000);
    
    Inventory_@Slot[playerid][14] = CreatePlayerTextDraw(playerid, 552.1522, 294.6849, ""); // ïóñòî
    PlayerTextDrawTextSize(playerid, Inventory_@Slot[playerid][14], 36.0000, 46.0000);
    PlayerTextDrawAlignment(playerid, Inventory_@Slot[playerid][14], 1);
    PlayerTextDrawColor(playerid, Inventory_@Slot[playerid][14], -1);
    PlayerTextDrawBackgroundColor(playerid, Inventory_@Slot[playerid][14], 522133194);
    PlayerTextDrawFont(playerid, Inventory_@Slot[playerid][14], 5);
    PlayerTextDrawSetProportional(playerid, Inventory_@Slot[playerid][14], 0);
    PlayerTextDrawSetShadow(playerid, Inventory_@Slot[playerid][14], 0);
    PlayerTextDrawSetSelectable(playerid, Inventory_@Slot[playerid][14], true);
    PlayerTextDrawSetPreviewModel(playerid, Inventory_@Slot[playerid][14], 1721);
    PlayerTextDrawSetPreviewRot(playerid, Inventory_@Slot[playerid][14], 0.0000, 0.0000, 0.0000, 1.0000);
    
    Inventory_@Slot[playerid][15] = CreatePlayerTextDraw(playerid, 589.1682, 294.8403, ""); // ïóñòî
    PlayerTextDrawTextSize(playerid, Inventory_@Slot[playerid][15], 36.0000, 46.0000);
    PlayerTextDrawAlignment(playerid, Inventory_@Slot[playerid][15], 1);
    PlayerTextDrawColor(playerid, Inventory_@Slot[playerid][15], -1);
    PlayerTextDrawBackgroundColor(playerid, Inventory_@Slot[playerid][15], 522133194);
    PlayerTextDrawFont(playerid, Inventory_@Slot[playerid][15], 5);
    PlayerTextDrawSetProportional(playerid, Inventory_@Slot[playerid][15], 0);
    PlayerTextDrawSetShadow(playerid, Inventory_@Slot[playerid][15], 0);
    PlayerTextDrawSetSelectable(playerid, Inventory_@Slot[playerid][15], true);
    PlayerTextDrawSetPreviewModel(playerid, Inventory_@Slot[playerid][15], 1721);
    PlayerTextDrawSetPreviewRot(playerid, Inventory_@Slot[playerid][15], 0.0000, 0.0000, 0.0000, 1.0000);
    
    
    
    
    
   
    Inventory_@Amount[playerid][0] = CreatePlayerTextDraw(playerid, 478.7832, 153.4405, "Lon_nuoc~n~(100)"); // ïóñòî
    PlayerTextDrawLetterSize(playerid, Inventory_@Amount[playerid][0], 0.1423, 0.8895);
    PlayerTextDrawTextSize(playerid, Inventory_@Amount[playerid][0], 503.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, Inventory_@Amount[playerid][0], 1);
    PlayerTextDrawColor(playerid, Inventory_@Amount[playerid][0], -1);
    PlayerTextDrawBackgroundColor(playerid, Inventory_@Amount[playerid][0], 255);
    PlayerTextDrawFont(playerid, Inventory_@Amount[playerid][0], 1);
    PlayerTextDrawSetProportional(playerid, Inventory_@Amount[playerid][0], 1);
    PlayerTextDrawSetShadow(playerid, Inventory_@Amount[playerid][0], 0);
    
    Inventory_@Amount[playerid][1] = CreatePlayerTextDraw(playerid, 516.2833, 153.4591, "Lon_nuoc~n~(100)"); // ïóñòî
    PlayerTextDrawLetterSize(playerid, Inventory_@Amount[playerid][1], 0.1423, 0.8895);
    PlayerTextDrawTextSize(playerid, Inventory_@Amount[playerid][1], 543.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, Inventory_@Amount[playerid][1], 1);
    PlayerTextDrawColor(playerid, Inventory_@Amount[playerid][1], -1);
    PlayerTextDrawBackgroundColor(playerid, Inventory_@Amount[playerid][1], 255);
    PlayerTextDrawFont(playerid, Inventory_@Amount[playerid][1], 1);
    PlayerTextDrawSetProportional(playerid, Inventory_@Amount[playerid][1], 1);
    PlayerTextDrawSetShadow(playerid, Inventory_@Amount[playerid][1], 0);
    
    Inventory_@Amount[playerid][2] = CreatePlayerTextDraw(playerid, 553.3505, 153.4591, "Lon_nuoc~n~(100)"); // ïóñòî
    PlayerTextDrawLetterSize(playerid, Inventory_@Amount[playerid][2], 0.1423, 0.8895);
    PlayerTextDrawTextSize(playerid, Inventory_@Amount[playerid][2], 577.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, Inventory_@Amount[playerid][2], 1);
    PlayerTextDrawColor(playerid, Inventory_@Amount[playerid][2], -1);
    PlayerTextDrawBackgroundColor(playerid, Inventory_@Amount[playerid][2], 255);
    PlayerTextDrawFont(playerid, Inventory_@Amount[playerid][2], 1);
    PlayerTextDrawSetProportional(playerid, Inventory_@Amount[playerid][2], 1);
    PlayerTextDrawSetShadow(playerid, Inventory_@Amount[playerid][2], 0);
    
    Inventory_@Amount[playerid][3] = CreatePlayerTextDraw(playerid, 590.3170, 153.4591, "Lon_nuoc~n~(100)"); // ïóñòî
    PlayerTextDrawLetterSize(playerid, Inventory_@Amount[playerid][3], 0.1423, 0.8895);
    PlayerTextDrawTextSize(playerid, Inventory_@Amount[playerid][3], 611.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, Inventory_@Amount[playerid][3], 1);
    PlayerTextDrawColor(playerid, Inventory_@Amount[playerid][3], -1);
    PlayerTextDrawBackgroundColor(playerid, Inventory_@Amount[playerid][3], 255);
    PlayerTextDrawFont(playerid, Inventory_@Amount[playerid][3], 1);
    PlayerTextDrawSetProportional(playerid, Inventory_@Amount[playerid][3], 1);
    PlayerTextDrawSetShadow(playerid, Inventory_@Amount[playerid][3], 0);
    
    Inventory_@Amount[playerid][4] = CreatePlayerTextDraw(playerid, 478.9338, 200.1257, "Lon_nuoc~n~(100)"); // ïóñòî
    PlayerTextDrawLetterSize(playerid, Inventory_@Amount[playerid][4], 0.1423, 0.8895);
    PlayerTextDrawTextSize(playerid, Inventory_@Amount[playerid][4], 500.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, Inventory_@Amount[playerid][4], 1);
    PlayerTextDrawColor(playerid, Inventory_@Amount[playerid][4], -1);
    PlayerTextDrawBackgroundColor(playerid, Inventory_@Amount[playerid][4], 255);
    PlayerTextDrawFont(playerid, Inventory_@Amount[playerid][4], 1);
    PlayerTextDrawSetProportional(playerid, Inventory_@Amount[playerid][4], 1);
    PlayerTextDrawSetShadow(playerid, Inventory_@Amount[playerid][4], 0);
    
    Inventory_@Amount[playerid][5] = CreatePlayerTextDraw(playerid, 516.0172, 199.8441, "Lon_nuoc~n~(100)"); // ïóñòî
    PlayerTextDrawLetterSize(playerid, Inventory_@Amount[playerid][5], 0.1423, 0.8895);
    PlayerTextDrawTextSize(playerid, Inventory_@Amount[playerid][5], 540.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, Inventory_@Amount[playerid][5], 1);
    PlayerTextDrawColor(playerid, Inventory_@Amount[playerid][5], -1);
    PlayerTextDrawBackgroundColor(playerid, Inventory_@Amount[playerid][5], 255);
    PlayerTextDrawFont(playerid, Inventory_@Amount[playerid][5], 1);
    PlayerTextDrawSetProportional(playerid, Inventory_@Amount[playerid][5], 1);
    PlayerTextDrawSetShadow(playerid, Inventory_@Amount[playerid][5], 0);
    
    Inventory_@Amount[playerid][6] = CreatePlayerTextDraw(playerid, 553.0839, 200.4998, "Lon_nuoc~n~(100)"); // ïóñòî
    PlayerTextDrawLetterSize(playerid, Inventory_@Amount[playerid][6], 0.1423, 0.8895);
    PlayerTextDrawTextSize(playerid, Inventory_@Amount[playerid][6], 576.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, Inventory_@Amount[playerid][6], 1);
    PlayerTextDrawColor(playerid, Inventory_@Amount[playerid][6], -1);
    PlayerTextDrawBackgroundColor(playerid, Inventory_@Amount[playerid][6], 255);
    PlayerTextDrawFont(playerid, Inventory_@Amount[playerid][6], 1);
    PlayerTextDrawSetProportional(playerid, Inventory_@Amount[playerid][6], 1);
    PlayerTextDrawSetShadow(playerid, Inventory_@Amount[playerid][6], 0);
    
    Inventory_@Amount[playerid][7] = CreatePlayerTextDraw(playerid, 590.2009, 201.0182, "Lon_nuoc~n~(100)"); // ïóñòî
    PlayerTextDrawLetterSize(playerid, Inventory_@Amount[playerid][7], 0.1423, 0.8895);
    PlayerTextDrawTextSize(playerid, Inventory_@Amount[playerid][7], 609.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, Inventory_@Amount[playerid][7], 1);
    PlayerTextDrawColor(playerid, Inventory_@Amount[playerid][7], -1);
    PlayerTextDrawBackgroundColor(playerid, Inventory_@Amount[playerid][7], 255);
    PlayerTextDrawFont(playerid, Inventory_@Amount[playerid][7], 1);
    PlayerTextDrawSetProportional(playerid, Inventory_@Amount[playerid][7], 1);
    PlayerTextDrawSetShadow(playerid, Inventory_@Amount[playerid][7], 0);
    
    Inventory_@Amount[playerid][8] = CreatePlayerTextDraw(playerid, 478.9508, 247.7032, "Lon_nuoc~n~(100)"); // ïóñòî
    PlayerTextDrawLetterSize(playerid, Inventory_@Amount[playerid][8], 0.1423, 0.8895);
    PlayerTextDrawTextSize(playerid, Inventory_@Amount[playerid][8], 501.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, Inventory_@Amount[playerid][8], 1);
    PlayerTextDrawColor(playerid, Inventory_@Amount[playerid][8], -1);
    PlayerTextDrawBackgroundColor(playerid, Inventory_@Amount[playerid][8], 255);
    PlayerTextDrawFont(playerid, Inventory_@Amount[playerid][8], 1);
    PlayerTextDrawSetProportional(playerid, Inventory_@Amount[playerid][8], 1);
    PlayerTextDrawSetShadow(playerid, Inventory_@Amount[playerid][8], 0);
    
    Inventory_@Amount[playerid][9] = CreatePlayerTextDraw(playerid, 515.4848, 247.3663, "Lon_nuoc~n~(100)"); // ïóñòî
    PlayerTextDrawLetterSize(playerid, Inventory_@Amount[playerid][9], 0.1423, 0.8895);
    PlayerTextDrawTextSize(playerid, Inventory_@Amount[playerid][9], 540.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, Inventory_@Amount[playerid][9], 1);
    PlayerTextDrawColor(playerid, Inventory_@Amount[playerid][9], -1);
    PlayerTextDrawBackgroundColor(playerid, Inventory_@Amount[playerid][9], 255);
    PlayerTextDrawFont(playerid, Inventory_@Amount[playerid][9], 1);
    PlayerTextDrawSetProportional(playerid, Inventory_@Amount[playerid][9], 1);
    PlayerTextDrawSetShadow(playerid, Inventory_@Amount[playerid][9], 0);
    
    Inventory_@Amount[playerid][10] = CreatePlayerTextDraw(playerid, 552.9351, 247.5032, "Lon_nuoc~n~(100)"); // ïóñòî
    PlayerTextDrawLetterSize(playerid, Inventory_@Amount[playerid][10], 0.1423, 0.8895);
    PlayerTextDrawTextSize(playerid, Inventory_@Amount[playerid][10], 578.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, Inventory_@Amount[playerid][10], 1);
    PlayerTextDrawColor(playerid, Inventory_@Amount[playerid][10], -1);
    PlayerTextDrawBackgroundColor(playerid, Inventory_@Amount[playerid][10], 255);
    PlayerTextDrawFont(playerid, Inventory_@Amount[playerid][10], 1);
    PlayerTextDrawSetProportional(playerid, Inventory_@Amount[playerid][10], 1);
    PlayerTextDrawSetShadow(playerid, Inventory_@Amount[playerid][10], 0);
    
    Inventory_@Amount[playerid][11] = CreatePlayerTextDraw(playerid, 590.1350, 247.8217, "Lon_nuoc~n~(100)"); // ïóñòî
    PlayerTextDrawLetterSize(playerid, Inventory_@Amount[playerid][11], 0.1423, 0.8895);
    PlayerTextDrawTextSize(playerid, Inventory_@Amount[playerid][11], 610.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, Inventory_@Amount[playerid][11], 1);
    PlayerTextDrawColor(playerid, Inventory_@Amount[playerid][11], -1);
    PlayerTextDrawBackgroundColor(playerid, Inventory_@Amount[playerid][11], 255);
    PlayerTextDrawFont(playerid, Inventory_@Amount[playerid][11], 1);
    PlayerTextDrawSetProportional(playerid, Inventory_@Amount[playerid][11], 1);
    PlayerTextDrawSetShadow(playerid, Inventory_@Amount[playerid][11], 0);
    
    Inventory_@Amount[playerid][12] = CreatePlayerTextDraw(playerid, 477.6184, 294.8886, "Lon_nuoc~n~(100)"); // ïóñòî
    PlayerTextDrawLetterSize(playerid, Inventory_@Amount[playerid][12], 0.1423, 0.8895);
    PlayerTextDrawTextSize(playerid, Inventory_@Amount[playerid][12], 499.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, Inventory_@Amount[playerid][12], 1);
    PlayerTextDrawColor(playerid, Inventory_@Amount[playerid][12], -1);
    PlayerTextDrawBackgroundColor(playerid, Inventory_@Amount[playerid][12], 255);
    PlayerTextDrawFont(playerid, Inventory_@Amount[playerid][12], 1);
    PlayerTextDrawSetProportional(playerid, Inventory_@Amount[playerid][12], 1);
    PlayerTextDrawSetShadow(playerid, Inventory_@Amount[playerid][12], 0);
    
    Inventory_@Amount[playerid][13] = CreatePlayerTextDraw(playerid, 515.7188, 294.5885, "Lon_nuoc~n~(100)"); // ïóñòî
    PlayerTextDrawLetterSize(playerid, Inventory_@Amount[playerid][13], 0.1423, 0.8895);
    PlayerTextDrawTextSize(playerid, Inventory_@Amount[playerid][13], 532.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, Inventory_@Amount[playerid][13], 1);
    PlayerTextDrawColor(playerid, Inventory_@Amount[playerid][13], -1);
    PlayerTextDrawBackgroundColor(playerid, Inventory_@Amount[playerid][13], 255);
    PlayerTextDrawFont(playerid, Inventory_@Amount[playerid][13], 1);
    PlayerTextDrawSetProportional(playerid, Inventory_@Amount[playerid][13], 1);
    PlayerTextDrawSetShadow(playerid, Inventory_@Amount[playerid][13], 0);
    
    Inventory_@Amount[playerid][14] = CreatePlayerTextDraw(playerid, 553.4188, 294.5885, "Lon_nuoc~n~(100)"); // ïóñòî
    PlayerTextDrawLetterSize(playerid, Inventory_@Amount[playerid][14], 0.1423, 0.8895);
    PlayerTextDrawTextSize(playerid, Inventory_@Amount[playerid][14], 577.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, Inventory_@Amount[playerid][14], 1);
    PlayerTextDrawColor(playerid, Inventory_@Amount[playerid][14], -1);
    PlayerTextDrawBackgroundColor(playerid, Inventory_@Amount[playerid][14], 255);
    PlayerTextDrawFont(playerid, Inventory_@Amount[playerid][14], 1);
    PlayerTextDrawSetProportional(playerid, Inventory_@Amount[playerid][14], 1);
    PlayerTextDrawSetShadow(playerid, Inventory_@Amount[playerid][14], 0);
    
    Inventory_@Amount[playerid][15] = CreatePlayerTextDraw(playerid, 589.8519, 294.5885, "Lon_nuoc~n~(100)"); // ïóñòî
    PlayerTextDrawLetterSize(playerid, Inventory_@Amount[playerid][15], 0.1423, 0.8895);
    PlayerTextDrawTextSize(playerid, Inventory_@Amount[playerid][15], 617.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, Inventory_@Amount[playerid][15], 1);
    PlayerTextDrawColor(playerid, Inventory_@Amount[playerid][15], -1);
    PlayerTextDrawBackgroundColor(playerid, Inventory_@Amount[playerid][15], 255);
    PlayerTextDrawFont(playerid, Inventory_@Amount[playerid][15], 1);
    PlayerTextDrawSetProportional(playerid, Inventory_@Amount[playerid][15], 1);
    PlayerTextDrawSetShadow(playerid, Inventory_@Amount[playerid][15], 0);
    
    
    //

    Inventory_@CharacterSlot[playerid][0] = CreatePlayerTextDraw(playerid, 363.4833, 155.0997, ""); // ïóñòî
    PlayerTextDrawTextSize(playerid, Inventory_@CharacterSlot[playerid][0], 36.0000, 46.0000);
    PlayerTextDrawAlignment(playerid, Inventory_@CharacterSlot[playerid][0], 1);
    PlayerTextDrawColor(playerid, Inventory_@CharacterSlot[playerid][0], -1);
    PlayerTextDrawBackgroundColor(playerid, Inventory_@CharacterSlot[playerid][0], 522133194);
    PlayerTextDrawFont(playerid, Inventory_@CharacterSlot[playerid][0], 5);
    PlayerTextDrawSetProportional(playerid, Inventory_@CharacterSlot[playerid][0], 0);
    PlayerTextDrawSetShadow(playerid, Inventory_@CharacterSlot[playerid][0], 0);
    PlayerTextDrawSetSelectable(playerid, Inventory_@CharacterSlot[playerid][0], true);
    PlayerTextDrawSetPreviewModel(playerid, Inventory_@CharacterSlot[playerid][0], 1721);
    PlayerTextDrawSetPreviewRot(playerid, Inventory_@CharacterSlot[playerid][0], 0.0000, 0.0000, 0.0000, 1.0000);
    
    Inventory_@CharacterSlot[playerid][1] = CreatePlayerTextDraw(playerid, 363.4833, 202.1221, ""); // ïóñòî
    PlayerTextDrawTextSize(playerid, Inventory_@CharacterSlot[playerid][1], 36.0000, 46.0000);
    PlayerTextDrawAlignment(playerid, Inventory_@CharacterSlot[playerid][1], 1);
    PlayerTextDrawColor(playerid, Inventory_@CharacterSlot[playerid][1], -1);
    PlayerTextDrawBackgroundColor(playerid, Inventory_@CharacterSlot[playerid][1], 522133194);
    PlayerTextDrawFont(playerid, Inventory_@CharacterSlot[playerid][1], 5);
    PlayerTextDrawSetProportional(playerid, Inventory_@CharacterSlot[playerid][1], 0);
    PlayerTextDrawSetShadow(playerid, Inventory_@CharacterSlot[playerid][1], 0);
    PlayerTextDrawSetSelectable(playerid, Inventory_@CharacterSlot[playerid][1], true);
    PlayerTextDrawSetPreviewModel(playerid, Inventory_@CharacterSlot[playerid][1], 1721);
    PlayerTextDrawSetPreviewRot(playerid, Inventory_@CharacterSlot[playerid][1], 0.0000, 0.0000, 0.0000, 1.0000);
    
    Inventory_@CharacterSlot[playerid][2] = CreatePlayerTextDraw(playerid, 435.9830, 155.4553, ""); // ïóñòî
    PlayerTextDrawTextSize(playerid, Inventory_@CharacterSlot[playerid][2], 36.0000, 46.0000);
    PlayerTextDrawAlignment(playerid, Inventory_@CharacterSlot[playerid][2], 1);
    PlayerTextDrawColor(playerid, Inventory_@CharacterSlot[playerid][2], -1);
    PlayerTextDrawBackgroundColor(playerid, Inventory_@CharacterSlot[playerid][2], 522133194);
    PlayerTextDrawFont(playerid, Inventory_@CharacterSlot[playerid][2], 5);
    PlayerTextDrawSetProportional(playerid, Inventory_@CharacterSlot[playerid][2], 0);
    PlayerTextDrawSetShadow(playerid, Inventory_@CharacterSlot[playerid][2], 0);
    PlayerTextDrawSetSelectable(playerid, Inventory_@CharacterSlot[playerid][2], true);
    PlayerTextDrawSetPreviewModel(playerid, Inventory_@CharacterSlot[playerid][2], 1721);
    PlayerTextDrawSetPreviewRot(playerid, Inventory_@CharacterSlot[playerid][2], 0.0000, 0.0000, 0.0000, 1.0000);
    
    Inventory_@CharacterSlot[playerid][3] = CreatePlayerTextDraw(playerid, 435.8663, 202.7776, ""); // ïóñòî
    PlayerTextDrawTextSize(playerid, Inventory_@CharacterSlot[playerid][3], 36.0000, 46.0000);
    PlayerTextDrawAlignment(playerid, Inventory_@CharacterSlot[playerid][3], 1);
    PlayerTextDrawColor(playerid, Inventory_@CharacterSlot[playerid][3], -1);
    PlayerTextDrawBackgroundColor(playerid, Inventory_@CharacterSlot[playerid][3], 522133194);
    PlayerTextDrawFont(playerid, Inventory_@CharacterSlot[playerid][3], 5);
    PlayerTextDrawSetProportional(playerid, Inventory_@CharacterSlot[playerid][3], 0);
    PlayerTextDrawSetShadow(playerid, Inventory_@CharacterSlot[playerid][3], 0);
    PlayerTextDrawSetSelectable(playerid, Inventory_@CharacterSlot[playerid][3], true);
    PlayerTextDrawSetPreviewModel(playerid, Inventory_@CharacterSlot[playerid][3], 1721);
    PlayerTextDrawSetPreviewRot(playerid, Inventory_@CharacterSlot[playerid][3], 0.0000, 0.0000, 0.0000, 1.0000);
}


