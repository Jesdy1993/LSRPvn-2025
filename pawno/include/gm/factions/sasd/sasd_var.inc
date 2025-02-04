new attach_police_model[] = {19904, 18637, 19142, 19515, 18636, 19161, 19162, 19521, 19098, 19200, 19141, 19514, 19138, 19783, 19784, 19778, 19785, 19781, 19782, 19779, 19780, 19775, 19774, 11745, 11738, 19096};

new bort_list[23] = {978, 979, 3091, 19972, 19970, 19971, 18728, 18725, 18690, 1425, 19944, 19995, 19834, 19836, 1238, 1228, 1459, 1423, 1237, 19425, 346, 355, 352};

new attach_police_name[][] =
{
	"Orange vest",
	"Police Shield",
	"Black body armor",
	"Gray bulletproof vest",
	"Cap number 1",
	"Cap number 2",
	"Cap number 3",
	"Cap",
	"Hat",
	"Motorcycle helmet",
	"Black SWAT helmet",
	"Gray SWAT helmet",
	"Balaklava",
	"Patch No. 1",
	"Patch P-III",
	"Detective I Patch",
	"Patch P-III + 1",
	"Sergeant I Patch",
	"Sergeant II Patch",
	"Detective II Patch",
	"Detective III Patch",
	"Detective's Token",
	"Policeman's Token",
	"Bag with things",
	"BLS bag",
	"Black hat"
};

new bort_names[23][32] =
{
	"Long bright fence",
	"Long bright fence 2",
	"Fence 'Line Closed'",
	"Fence 'Road Closed'",
	"Fence 'One Way - Left'",
	"Fence 'One Way - Right'",
	"Signal Torch",
	"Smoke particles",
	"Particles of Fire",
	"Detour Road Barrier",
	"Package with a corpse",
	"Score",
	"Tape",
	"Blood stain",
	"Cone",
	"Barrier",
	"Barrier 2",
	"Barrier 3",
	"Barrier 4",
	"Speed ??bump",
	"Colt",
	"AK-47",
	"UZI"
};

new Float: prison_palomino[2][3] =
{
	{1580.4144,-1667.6445,2982.2800},
	{1580.4646,-1677.9987,2982.2800}
};

new Float: prison_sadoc[20][3] =
{
	{529.2821,-462.5329,919.3973},
	{533.9864,-462.7558,919.3973},
	{538.7690,-462.5498,919.3973},
	{543.5073,-462.6223,919.3973},
	{548.3173,-462.2971,919.3973},
	{553.0486,-462.5840,919.3973},
	{529.3326,-481.8497,919.4027},
	{534.1647,-482.1199,919.4027},
	{538.8668,-482.2083,919.4027},
	{543.5774,-482.1175,919.4027},
	{548.4084,-482.4462,919.4027},
	{553.0802,-482.2829,919.4027},
	{538.6510,-461.6799,915.6733},
	{543.4929,-462.0461,915.6733},
	{548.2507,-461.4220,915.6733},
	{552.9613,-461.2717,915.6733},
	{538.8630,-483.5457,915.6733},
	{543.5722,-483.2266,915.6733},
	{548.3820,-483.2058,915.6733},
	{553.1059,-482.8833,915.6733}
};

new Float: prison_isolate[10][3] =
{
	{-1765.3180,-497.4885,621.1163},
	{-1769.2893,-497.9387,621.1163},
	{-1773.2601,-497.4489,621.1163},
	{-1777.2761,-497.9054,621.1163},
	{-1781.2529,-497.7102,621.1163},
	{-1765.5096,-497.7450,624.7874},
	{-1769.3136,-497.8934,624.7874},
	{-1773.2543,-497.4081,624.7874},
	{-1777.1084,-497.5620,624.7874},
	{-1781.1655,-498.0222,624.7874}
};

new police_skins[] = {265, 266, 267, 280, 281, 282, 284, 286, 300, 301, 302, 303, 304, 305, 306, 307, 283, 288, 309};

new Text3D:PrisonLabel[MAX_PLAYERS];