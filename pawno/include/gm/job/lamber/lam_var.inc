enum    E_TREE
{
	treeID,
	Float: treeX,
	Float: treeY,
	Float: treeZ,
	Float: treeRX,
	Float: treeRY,
	Float: treeRZ,
	// temp
	treeLogs,
	treeSeconds,
	bool: treeGettingCut,
	treeObjID,
	Text3D: treeLabel,
	treeTimer
}
new TreeData[MAX_TREES][E_TREE];

enum    E_LOG
{
	// temp
	logDroppedBy[MAX_PLAYER_NAME],
	logSeconds,
	logObjID,
	logTimer,
	Text3D: logLabel
}
new LogData[MAX_LOGS][E_LOG];

enum    E_BUYER
{
	buyerID,
	buyerSkin,
	Float: buyerX,
	Float: buyerY,
	Float: buyerZ,
	Float: buyerA,
	// temp
	buyerActorID,
	Text3D: buyerLabel
}
new BuyerData[MAX_BUYERS][E_BUYER];

	
	
	
new
	Iterator: Trees<MAX_TREES>,
	Iterator: TreeLogs<MAX_LOGS>,
	Iterator: Buyers<MAX_BUYERS>;

new
	LogObjects[MAX_VEHICLES][LOG_LIMIT];
	
new
	CuttingTreeID[MAX_PLAYERS] = {-1, ...},
	CuttingTimer[MAX_PLAYERS] = {-1, ...},
	PlayerBar: CuttingBar[MAX_PLAYERS] = {INVALID_PLAYER_BAR_ID, ...},
	bool: CarryingLog[MAX_PLAYERS],
	EditingTreeID[MAX_PLAYERS] = {-1, ...};

new
	Float: LogAttachOffsets[LOG_LIMIT][4] = {
	    {-0.223, -1.089, -0.230, -90.399},
		{-0.056, -1.091, -0.230, 90.399},
		{0.116, -1.092, -0.230, -90.399},
		{0.293, -1.088, -0.230, 90.399},
		{-0.123, -1.089, -0.099, -90.399},
		{0.043, -1.090, -0.099, 90.399},
		{0.216, -1.092, -0.099, -90.399},
		{-0.033, -1.090, 0.029, -90.399},
		{0.153, -1.089, 0.029, 90.399},
		{0.066, -1.091, 0.150, -90.399}
	};