enum    e_ores
{
	Name[16],
	Color,
	Float: Modifier,
	Amount, // how many of this ore spawns in a vein
	Value, // value of this ore
	Rate // successful mining rate
}

enum    e_veins
{
	Type,
	Amount,
	bool: BeingMined,
	VeinObject,
	Text3D: VeinLabel,
	bool: VeinExists
}

enum    e_droppedores
{
	Type,
	OreTimer,
	OreObject,
	Text3D: OreLabel,
	bool: OreExists
}

enum    e_droppoints
{
	Location[32],
	Float: PointX,
	Float: PointY,
	Float: PointZ,
	PointCP,
	Text3D: PointLabel
}

new
	OreData[MAX_ORE_TYPES][e_ores] = {
	// name, color, modifier, spawn amount, value, mining rate
	    {"Copper", 0xB87333FF, 0.75, 8, 15, 80},
	    {"Amethyst", 0x9B59B6FF, 0.60, 6, 30, 60},
	    {"Emerald", 0x2ECC71FF, 0.40, 4, 50, 55},
		{"Ruby", 0xD10056FF, 0.35, 3, 80, 50},
		{"Sapphire", 0x0F52BAFF, 0.30, 4, 100, 40},
        {"Gold", 0xFFD700FF, 0.25, 3, 500, 40}
	};
	
new
	VeinData[MAX_VEINS][e_veins],
	DroppedOres[MAX_ORES][e_droppedores];
	
new
	MiningVein[MAX_PLAYERS] = {-1, ...},
	MiningTimer[MAX_PLAYERS] = {-1, ...},
	CarryingOre[MAX_PLAYERS] = {-1, ...},
	LoadingPoint[MAX_PLAYERS] = {-1, ...},
	PlayerBar: MiningBar[MAX_PLAYERS] = {INVALID_PLAYER_BAR_ID, ...};

new
	LoadedOres[MAX_VEHICLES][MAX_ORE_TYPES];
	
new
	DropPoints[][e_droppoints] = 
    {
	// location, x, y, z
	    {"Palomino", 821.6732,858.3895,12.0469}
	};

new
    PointIcons[MAX_PLAYERS][sizeof(DropPoints)];