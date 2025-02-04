enum fishvari {
	fishname[32],
	fishtype[40],
	fishprice,
}

enum fishpoint {
    Float:FishX,
    Float:FishY,
    Float:FishZ,
}

new FishingStr[][fishvari] =
{
	{"None","None", 1}, // 0
	{"Ca ro","Nho", 10}, // 0
	{"Ca sac","Nho", 12}, // 1
	{"Ca linh","Nho", 15}, // 2
	{"Ca Loc","vua", 20}, // 2
	{"Ca Tra","Vua", 25}, // 2
	{"Ca map","Lon", 30} // 2
};

new FishingPoint[MAX_POINT_FISH][fishpoint] =
{
    {403.8940,-2088.0002,7.8359},
    {398.7163,-2087.9131,7.8359},
    {390.9532,-2087.1594,7.8359},
    {383.5158,-2087.3835,7.8359},
    {375.1824,-2087.6235,7.8359},
    {369.8861,-2088.1230,7.8359},
    {362.0632,-2087.4780,7.8359},
    {354.6935,-2087.1758,7.8359}
};

new ActorFish;