new VehicleNames[212][] = 
{
   "Landstalker",  "Bravura",  "Buffalo", "Linerunner", "Perennial", "Sentinel",
   "Dumper",  "Firetruck" ,  "Trashmaster" ,  "Stretch",  "Manana",  "Infernus",
   "Voodoo", "Pony",  "Mule", "Cheetah", "Ambulance",  "Leviathan",  "Moonbeam",
   "Esperanto", "Taxi",  "Washington",  "Bobcat",  "Mr Whoopee", "BF Injection",
   "Hunter", "Premier",  "Enforcer",  "Securicar", "Banshee", "Predator", "Bus",
   "Rhino",  "Barracks",  "Hotknife",  "Trailer",  "Previon", "Coach", "Cabbie",
   "Stallion", "Rumpo", "RC Bandit",  "Romero", "Packer", "Monster",  "Admiral",
   "Squalo", "Seasparrow", "Pizzaboy", "Tram", "Trailer",  "Turismo", "Speeder",
   "Reefer", "Tropic", "Flatbed","Yankee", "Caddy", "Solair","Berkley's RC Van",
   "Skimmer", "PCJ-600", "Faggio", "Freeway", "RC Baron","RC Raider","Glendale",
   "Oceanic", "Sanchez", "Sparrow",  "Patriot", "Quad",  "Coastguard", "Dinghy",
   "Hermes", "Sabre", "Rustler", "ZR-350", "Walton",  "Regina",  "Comet", "BMX",
   "Burrito", "Camper", "Marquis", "Baggage", "Dozer","Maverick","News Chopper",
   "Rancher", "FBI Rancher", "Virgo", "Greenwood","Jetmax","Hotring","Sandking",
   "Blista Compact", "Police Maverick", "Boxville", "Benson","Mesa","RC Goblin",
   "Hotring Racer", "Hotring Racer", "Bloodring Banger", "Rancher",  "Super GT",
   "Elegant", "Journey", "Bike", "Mountain Bike", "Beagle", "Cropdust", "Stunt",
   "Tanker", "RoadTrain", "Nebula", "Majestic", "Buccaneer", "Shamal",  "Hydra",
   "FCR-900","NRG-500","HPV1000","Cement Truck","Tow Truck","Fortune","Cadrona",
   "FBI Truck", "Willard", "Forklift","Tractor","Combine","Feltzer","Remington",
   "Slamvan", "Blade", "Freight", "Streak","Vortex","Vincent","Bullet","Clover",
   "Sadler",  "Firetruck", "Hustler", "Intruder", "Primo", "Cargobob",  "Tampa",
   "Sunrise", "Merit",  "Utility Truck",  "Nevada", "Yosemite", "Windsor",  "Monster",
   "Monster","Uranus","Jester","Sultan","Stratum","Elegy","Raindance","RCTiger",
   "Flash","Tahoma","Savanna", "Bandito", "Freight", "Trailer", "Kart", "Mower",
   "Dune", "Sweeper", "Broadway", "Tornado", "AT-400",  "DFT-30", "Huntley",
   "Stafford", "BF-400", "Newsvan","Tug","Trailer","Emperor","Wayfarer","Euros",
   "Hotdog", "Club", "Trailer", "Trailer","Andromada","Dodo","RC Cam", "Launch",
   "LSPD Cruiser", "LSPD Cruiser","Police Car (LVPD)","Police Ranger",
   "Picador",   "S.W.A.T. Van",  "Alpha",   "Phoenix",   "Glendale",   "Sadler",
   "Luggage Trailer","Luggage Trailer","Stair Trailer", "Boxville", "Farm Plow",
   "Utility Trailer"
};

new Text3D:status_update[MAX_VEHICLES];

new VehicleColoursTableRGBA[256] = 
{
    0x000000FF, 0xF5F5F5FF, 0x2A77A1FF, 0x840410FF, 0x263739FF, 0x86446EFF, 0xD78E10FF, 0x4C75B7FF, 0xBDBEC6FF, 0x5E7072FF,
    0x46597AFF, 0x656A79FF, 0x5D7E8DFF, 0x58595AFF, 0xD6DAD6FF, 0x9CA1A3FF, 0x335F3FFF, 0x730E1AFF, 0x7B0A2AFF, 0x9F9D94FF,
    0x3B4E78FF, 0x732E3EFF, 0x691E3BFF, 0x96918CFF, 0x515459FF, 0x3F3E45FF, 0xA5A9A7FF, 0x635C5AFF, 0x3D4A68FF, 0x979592FF,
    0x421F21FF, 0x5F272BFF, 0x8494ABFF, 0x767B7CFF, 0x646464FF, 0x5A5752FF, 0x252527FF, 0x2D3A35FF, 0x93A396FF, 0x6D7A88FF,
    0x221918FF, 0x6F675FFF, 0x7C1C2AFF, 0x5F0A15FF, 0x193826FF, 0x5D1B20FF, 0x9D9872FF, 0x7A7560FF, 0x989586FF, 0xADB0B0FF, 
    0x848988FF, 0x304F45FF, 0x4D6268FF, 0x162248FF, 0x272F4BFF, 0x7D6256FF, 0x9EA4ABFF, 0x9C8D71FF, 0x6D1822FF, 0x4E6881FF,
    0x9C9C98FF, 0x917347FF, 0x661C26FF, 0x949D9FFF, 0xA4A7A5FF, 0x8E8C46FF, 0x341A1EFF, 0x6A7A8CFF, 0xAAAD8EFF, 0xAB988FFF,
    0x851F2EFF, 0x6F8297FF, 0x585853FF, 0x9AA790FF, 0x601A23FF, 0x20202CFF, 0xA4A096FF, 0xAA9D84FF, 0x78222BFF, 0x0E316DFF,
    0x722A3FFF, 0x7B715EFF, 0x741D28FF, 0x1E2E32FF, 0x4D322FFF, 0x7C1B44FF, 0x2E5B20FF, 0x395A83FF, 0x6D2837FF, 0xA7A28FFF,
    0xAFB1B1FF, 0x364155FF, 0x6D6C6EFF, 0x0F6A89FF, 0x204B6BFF, 0x2B3E57FF, 0x9B9F9DFF, 0x6C8495FF, 0x4D8495FF, 0xAE9B7FFF,
    0x406C8FFF, 0x1F253BFF, 0xAB9276FF, 0x134573FF, 0x96816CFF, 0x64686AFF, 0x105082FF, 0xA19983FF, 0x385694FF, 0x525661FF,
    0x7F6956FF, 0x8C929AFF, 0x596E87FF, 0x473532FF, 0x44624FFF, 0x730A27FF, 0x223457FF, 0x640D1BFF, 0xA3ADC6FF, 0x695853FF,
    0x9B8B80FF, 0x620B1CFF, 0x5B5D5EFF, 0x624428FF, 0x731827FF, 0x1B376DFF, 0xEC6AAEFF, 0x000000FF,
    0x177517FF, 0x210606FF, 0x125478FF, 0x452A0DFF, 0x571E1EFF, 0x010701FF, 0x25225AFF, 0x2C89AAFF, 0x8A4DBDFF, 0x35963AFF,
    0xB7B7B7FF, 0x464C8DFF, 0x84888CFF, 0x817867FF, 0x817A26FF, 0x6A506FFF, 0x583E6FFF, 0x8CB972FF, 0x824F78FF, 0x6D276AFF,
    0x1E1D13FF, 0x1E1306FF, 0x1F2518FF, 0x2C4531FF, 0x1E4C99FF, 0x2E5F43FF, 0x1E9948FF, 0x1E9999FF, 0x999976FF, 0x7C8499FF,
    0x992E1EFF, 0x2C1E08FF, 0x142407FF, 0x993E4DFF, 0x1E4C99FF, 0x198181FF, 0x1A292AFF, 0x16616FFF, 0x1B6687FF, 0x6C3F99FF,
    0x481A0EFF, 0x7A7399FF, 0x746D99FF, 0x53387EFF, 0x222407FF, 0x3E190CFF, 0x46210EFF, 0x991E1EFF, 0x8D4C8DFF, 0x805B80FF,
    0x7B3E7EFF, 0x3C1737FF, 0x733517FF, 0x781818FF, 0x83341AFF, 0x8E2F1CFF, 0x7E3E53FF, 0x7C6D7CFF, 0x020C02FF, 0x072407FF,
    0x163012FF, 0x16301BFF, 0x642B4FFF, 0x368452FF, 0x999590FF, 0x818D96FF, 0x99991EFF, 0x7F994CFF, 0x839292FF, 0x788222FF,
    0x2B3C99FF, 0x3A3A0BFF, 0x8A794EFF, 0x0E1F49FF, 0x15371CFF, 0x15273AFF, 0x375775FF, 0x060820FF, 0x071326FF, 0x20394BFF,
    0x2C5089FF, 0x15426CFF, 0x103250FF, 0x241663FF, 0x692015FF, 0x8C8D94FF, 0x516013FF, 0x090F02FF, 0x8C573AFF, 0x52888EFF,
    0x995C52FF, 0x99581EFF, 0x993A63FF, 0x998F4EFF, 0x99311EFF, 0x0D1842FF, 0x521E1EFF, 0x42420DFF, 0x4C991EFF, 0x082A1DFF,
    0x96821DFF, 0x197F19FF, 0x3B141FFF, 0x745217FF, 0x893F8DFF, 0x7E1A6CFF, 0x0B370BFF, 0x27450DFF, 0x071F24FF, 0x784573FF,
    0x8A653AFF, 0x732617FF, 0x319490FF, 0x56941DFF, 0x59163DFF, 0x1B8A2FFF, 0x38160BFF, 0x041804FF, 0x355D8EFF, 0x2E3F5BFF,
    0x561A28FF, 0x4E0E27FF, 0x706C67FF, 0x3B3E42FF, 0x2E2D33FF, 0x7B7E7DFF, 0x4A4442FF, 0x28344EFF
};

new Float:GetVehicleMaxSpeed[] = {
	157.0, 147.0, 186.0, 110.0, 133.0, 164.0, 110.0, 148.0, 100.0, 158.0, 129.0, 221.0, 168.0, 110.0, 105.0, 192.0, 154.0, 270.0, 115.0, 149.0,
	145.0, 154.0, 140.0, 99.0,  135.0, 270.0, 173.0, 165.0, 157.0, 201.0, 190.0, 130.0, 94.0,  110.0, 167.0, 0.0,   149.0, 158.0, 142.0, 168.0,
	136.0, 145.0, 139.0, 126.0, 110.0, 164.0, 270.0, 270.0, 111.0, 0.0,   0.0,   193.0, 270.0, 60.0,  135.0, 157.0, 106.0, 95.0,  157.0, 136.0,
	270.0, 160.0, 111.0, 142.0, 145.0, 145.0, 147.0, 140.0, 144.0, 270.0, 157.0, 110.0, 190.0, 190.0, 149.0, 173.0, 270.0, 186.0, 117.0, 140.0,
	184.0, 73.0,  156.0, 122.0, 190.0, 99.0,  64.0,  270.0, 270.0, 139.0, 157.0, 149.0, 140.0, 270.0, 214.0, 176.0, 162.0, 270.0, 108.0, 123.0,
	140.0, 145.0, 216.0, 216.0, 173.0, 140.0, 179.0, 166.0, 108.0, 79.0,  101.0, 270.0,	270.0, 270.0, 120.0, 142.0, 157.0, 157.0, 164.0, 270.0, 
	270.0, 160.0, 176.0, 151.0, 130.0, 160.0, 158.0, 149.0, 176.0, 149.0, 60.0,  70.0,  110.0, 167.0, 168.0, 158.0, 173.0, 0.0,   0.0,   270.0,
	149.0, 203.0, 164.0, 151.0, 150.0, 147.0, 149.0, 142.0, 270.0, 153.0, 145.0, 157.0, 121.0, 270.0, 144.0, 158.0, 113.0, 113.0, 156.0, 178.0,
	169.0, 154.0, 178.0, 270.0, 145.0, 165.0, 160.0, 173.0, 146.0, 0.0,   0.0,   93.0,  60.0,  110.0, 60.0,  158.0, 158.0, 270.0, 130.0, 158.0,
	153.0, 151.0, 136.0, 85.0,  0.0,   153.0, 142.0, 165.0, 108.0, 162.0, 0.0,   0.0,   270.0, 270.0, 130.0, 190.0, 175.0, 175.0, 175.0, 158.0,
	151.0, 110.0, 169.0, 171.0, 148.0, 152.0, 0.0,   0.0,   0.0,   108.0, 0.0,   0.0
};

new price_reg[2] = {0, 300};
new price_lock[6] = {0, 700, 1400, 2800, 5400, 8500};
new price_alarm[5] = {0, 600, 1600, 3500, 6200};
new price_immob[5] = {0, 800, 2200, 4600, 9100};
new price_radio[2] = {0, 400};
new price_gps[2] = {0, 1000};
	
new price_mod_lock[] = {900, 1500, 2400, 3600, 5100};
new price_mod_alarm[] = {700, 1800, 3200, 5000};
new price_mod_immob[] = {800, 2000, 4300, 8500};

new JackingEngine[MAX_PLAYERS];
new JackingLock[MAX_PLAYERS];
new JackingVehicle[MAX_PLAYERS];
new BreakingHouse[MAX_PLAYERS];

new max_vehicle_components[8] = {17, 20, 4, 17, 21, 29, 23, 22};

new veh_int[MAX_VEHICLES], veh_vw[MAX_VEHICLES];

new PlayerText:VehSpawn[MAX_PLAYERS][6];

CreateVehicleMenu(playerid)
{
	VehSpawn[playerid][0] = CreatePlayerTextDraw(playerid, 540.000000, 126.000000, "_");
	PlayerTextDrawFont(playerid, VehSpawn[playerid][0], 1);
	PlayerTextDrawLetterSize(playerid, VehSpawn[playerid][0], 0.600000, 10.300003);
	PlayerTextDrawTextSize(playerid, VehSpawn[playerid][0], 298.500000, 75.000000);
	PlayerTextDrawSetOutline(playerid, VehSpawn[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, VehSpawn[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, VehSpawn[playerid][0], 2);
	PlayerTextDrawColor(playerid, VehSpawn[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, VehSpawn[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, VehSpawn[playerid][0], -741092473);
	PlayerTextDrawUseBox(playerid, VehSpawn[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, VehSpawn[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, VehSpawn[playerid][0], 0);

	VehSpawn[playerid][1] = CreatePlayerTextDraw(playerid, 508.000000, 133.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, VehSpawn[playerid][1], 5);
	PlayerTextDrawLetterSize(playerid, VehSpawn[playerid][1], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, VehSpawn[playerid][1], 64.500000, 78.000000);
	PlayerTextDrawSetOutline(playerid, VehSpawn[playerid][1], 0);
	PlayerTextDrawSetShadow(playerid, VehSpawn[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, VehSpawn[playerid][1], 1);
	PlayerTextDrawColor(playerid, VehSpawn[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, VehSpawn[playerid][1], 125);
	PlayerTextDrawBoxColor(playerid, VehSpawn[playerid][1], 255);
	PlayerTextDrawUseBox(playerid, VehSpawn[playerid][1], 0);
	PlayerTextDrawSetProportional(playerid, VehSpawn[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, VehSpawn[playerid][1], 1);
	PlayerTextDrawSetPreviewModel(playerid, VehSpawn[playerid][1], 560);
	PlayerTextDrawSetPreviewRot(playerid, VehSpawn[playerid][1], -10.000000, 0.000000, -63.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, VehSpawn[playerid][1], 1, 1);

	VehSpawn[playerid][2] = CreatePlayerTextDraw(playerid, 574.000000, 160.000000, "ld_beat:right");
	PlayerTextDrawFont(playerid, VehSpawn[playerid][2], 4);
	PlayerTextDrawLetterSize(playerid, VehSpawn[playerid][2], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, VehSpawn[playerid][2], 19.500000, 21.500000);
	PlayerTextDrawSetOutline(playerid, VehSpawn[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, VehSpawn[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, VehSpawn[playerid][2], 1);
	PlayerTextDrawColor(playerid, VehSpawn[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, VehSpawn[playerid][2], 255);
	PlayerTextDrawBoxColor(playerid, VehSpawn[playerid][2], 50);
	PlayerTextDrawUseBox(playerid, VehSpawn[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, VehSpawn[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, VehSpawn[playerid][2], 1);

	VehSpawn[playerid][3] = CreatePlayerTextDraw(playerid, 488.000000, 160.000000, "ld_beat:left");
	PlayerTextDrawFont(playerid, VehSpawn[playerid][3], 4);
	PlayerTextDrawLetterSize(playerid, VehSpawn[playerid][3], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, VehSpawn[playerid][3], 19.500000, 21.500000);
	PlayerTextDrawSetOutline(playerid, VehSpawn[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, VehSpawn[playerid][3], 0);
	PlayerTextDrawAlignment(playerid, VehSpawn[playerid][3], 1);
	PlayerTextDrawColor(playerid, VehSpawn[playerid][3], -1);
	PlayerTextDrawBackgroundColor(playerid, VehSpawn[playerid][3], 255);
	PlayerTextDrawBoxColor(playerid, VehSpawn[playerid][3], 50);
	PlayerTextDrawUseBox(playerid, VehSpawn[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, VehSpawn[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, VehSpawn[playerid][3], 1);

	VehSpawn[playerid][4] = CreatePlayerTextDraw(playerid, 541.000000, 135.000000, "Chon phuong tien cua ban.");
	PlayerTextDrawFont(playerid, VehSpawn[playerid][4], 2);
	PlayerTextDrawLetterSize(playerid, VehSpawn[playerid][4], 0.100000, 1.000001);
	PlayerTextDrawTextSize(playerid, VehSpawn[playerid][4], 400.000000, 72.000000);
	PlayerTextDrawSetOutline(playerid, VehSpawn[playerid][4], 0);
	PlayerTextDrawSetShadow(playerid, VehSpawn[playerid][4], 0);
	PlayerTextDrawAlignment(playerid, VehSpawn[playerid][4], 2);
	PlayerTextDrawColor(playerid, VehSpawn[playerid][4], 255);
	PlayerTextDrawBackgroundColor(playerid, VehSpawn[playerid][4], 255);
	PlayerTextDrawBoxColor(playerid, VehSpawn[playerid][4], 50);
	PlayerTextDrawUseBox(playerid, VehSpawn[playerid][4], 0);
	PlayerTextDrawSetProportional(playerid, VehSpawn[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid, VehSpawn[playerid][4], 0);

	VehSpawn[playerid][5] = CreatePlayerTextDraw(playerid, 556.000000, 200.000000, "Sultan");
	PlayerTextDrawFont(playerid, VehSpawn[playerid][5], 3);
	PlayerTextDrawLetterSize(playerid, VehSpawn[playerid][5], 0.266666, 1.000001);
	PlayerTextDrawTextSize(playerid, VehSpawn[playerid][5], 400.000000, 72.000000);
	PlayerTextDrawSetOutline(playerid, VehSpawn[playerid][5], 0);
	PlayerTextDrawSetShadow(playerid, VehSpawn[playerid][5], 0);
	PlayerTextDrawAlignment(playerid, VehSpawn[playerid][5], 2);
	PlayerTextDrawColor(playerid, VehSpawn[playerid][5], 255);
	PlayerTextDrawBackgroundColor(playerid, VehSpawn[playerid][5], 255);
	PlayerTextDrawBoxColor(playerid, VehSpawn[playerid][5], 50);
	PlayerTextDrawUseBox(playerid, VehSpawn[playerid][5], 0);
	PlayerTextDrawSetProportional(playerid, VehSpawn[playerid][5], 1);
	PlayerTextDrawSetSelectable(playerid, VehSpawn[playerid][5], 0);
	
	return 1;
}

enum E_UNSCRAMBLER_DATA
{
	//eUnscrambleLevel,
	eScrambledWord[60],
	eUnscrambledWord[60]
}

new UnscrambleInfo[][E_UNSCRAMBLER_DATA] = 
{
	{"ARC", "CAR"},
	{"RDOW", "WORD"},
	{"PMA", "MAP"},
	{"����", "����"},
	{"LTSA", "SALT"},
	{"EXTT", "TEXT"},
	{"ATC", "CAT"}
};

/*
new Float: Jacking_CP[8][3] = {
	{2216.8882,-2404.0046,13.5469},
	{2873.8855,893.4097,10.7500},
	{1032.4172,2344.1072,10.8203},
	{425.3987,2546.8647,16.2877},
	{-1869.1023,-1681.6959,21.7500},
	{-1561.9364,-2721.1296,48.5408},
	{22.7649,-2653.4316,40.5005},
	{-259.2915,-2182.3169,29.0084}
};*/