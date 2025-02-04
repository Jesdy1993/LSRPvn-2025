#include <YSI_Coding\y_hooks>

#define MAX_FURNITURE 5500
#define DIALOG_ADD_FURN 20001
enum furnitures {
	FurnitureSet,
	FurnitureModelID,
	FurnitureObject,
	FurnitureHouse,
	FurnitureItem,
	Float:FurniturePos[3],
	Float:FurnitureRot[3],  

}
new Furniture[MAX_FURNITURE][furnitures];

enum e_furn {
	e_furn_creatory,
	e_furnobj,
	e_furnname[52],
	e_furn_price

}

new const fCategory[][] =
{
    "Thung rac", // 0
	"Giuong & ghe & ban", // 1
	"Trang tri nha & tranh", // 2
	"Giai tri", // 3
	"Den", // 4
	"Nha ve sinh", // 5
	"Tu & ban hoc", // 6
	"Tu & ban", // 7
	"Quan ao", // 8
	"Play station & Giai tri", // 9
	"Graffiti", // 10
	"Den quan bar", // 11
	"12", // 12
	"Tuong #1", // 13
	"Tuong #2", // 14
	"Tuong #3", // 15
	"Tuong #4", // 16
	"Tuong #5", // 17
	"Kinh & cau thang", // 18
	"Chai & Decor Coffee",  // 19
	"Cua", // 20
	"Thuc an & nuoc", // 21
	"Vat dung gia dung", // 22
	"Cot", // 23
	"Camera", // 24
	"Ban lam viec & ban TV", // 25
	"Do choi" // 226
};


new FurnitureItems[][e_furn] =
{
	{0, 1780, "Tu lanh cu", 700},
	{0, 2127, "Tu lanh cu do",800},
	{0, 2131, "Tu lanh",700},
	{0, 2147, "Tu lanh cu",800},
	{0, 2017, "Bep lo Co. Stove",700},
	{0, 2135, "Dong cu",500},
	{0, 2144, "Old Town Stove",200},
	{0, 2294, "LoveSet Stove",300},
	{0, 2340, "Creamy Metal Stove",200},
	{0, 1235, "Transparent Sides Trash Can", 50},
	{0, 1300, "Stone Trash Can", 140},
	{0, 1328, "Aluminum Lid Trash Can", 15},
	{0, 1329, "Ghetto Trash Can", 10},
	{0, 1330, "Trash Bag Covered Trash Can", 12},
	{0, 1337, "Tall Rolling Trash Can", 70},
	{0, 1339, "Light Blue Rolling Trash Can", 70},
	{0, 1347, "Street Trash Can", 15},
	{0, 1359, "Metal Plate Trash Can", 60},
	{0, 1371, "Hippo Trash Can", 70},
	{0, 1574, "White Trash Can", 80},
	{0, 2770, "Cluck n Bell Trash Can", 80},
	{0, 2149, "Microwave", 100},
	{0, 2426, "Toaster Oven", 150},
	{0, 1331, "Recycle Dumpster", 350},
	{0, 1332, "Glass Recycle Dumpster", 350},
	{0, 1333, "Orange Dumpster", 350},
	{0, 1334, "Blue Dumpster", 320},
	{0, 1335, "Clothes Recycle Dumpster", 360},
	{0, 1336, "Blue Compact Dumpster", 360},
	{0, 1372, "Regular Street Dumpster", 360},
	{0, 3035, "Black Compact Dumpster", 360},
	{0, 1415, "Packed Regular Street Dumpster", 360},
	{1, 1700, "Pink Queen Bed", 360},
	{1, 1701, "Royal Brown Queen Bed", 140},
	{1, 1745, "Green & White Backboard Queen Bed", 850},
	{1, 1793, "Stack of Mattresses", 2850},
	{1, 1794, "Brown Wooden Queen Bed", 850},
	{1, 1795, "Basic Beach Bed", 850},
	{1, 1796, "Brown Wooden Quilted Bed", 850},
	{1, 1797, "Basic Bed & Stylish Legs", 850},
	{1, 1798, "Basic Beach Single Bed", 850},
	{1, 1799, "Brown Quilted Yellow Queen Bed", 850},
	{1, 1800, "Metal Prison Bed", 200},
	{1, 1801, "White Wooden Queen Bed", 850},
	{1, 1802, "Floral Quilt Wooden Queen Bed", 850},
	{1, 1803, "Floral Quilt Wooden Queen Bed (Overhead)", 850},
	{1, 1812, "Shiny Metal Prison Bed", 850},
	{1, 2299, "Brown Quilted Queen Bed", 850},
	{1, 2302, "Cabin Bed", 750},
	{1, 2603, "White Police Cell Bed", 750},
	{1, 14866, "Tropical Sand Queen Bed", 750},
	{1, 14446, "King Size Zebra Styled Bed", 750},
	{1, 1663, "Swivel Chair", 200},
	{1, 1671, "Arms Rest Swivel Chair", 200},
	{1, 1720, "Wooden Chair", 150},
	{1, 1721, "Metallic Chair", 150},
	{1, 1739, "Dining Chair", 150},
	{1, 11685, "Brown Thick Silk Armchair", 560},
	{1, 2356, "Office Chair", 120},
	{1, 19996, "Fold Chair", 200},
	{1, 19994, "Oval Wooden Chair", 120},
	{1, 2079, "Green Wooden Dining Chair", 120},
	{1, 2120, "Black Wooden Dining Chair", 120},
	{1, 2121, "Foldable Red Chair", 400},
	{1, 2122, "White Dining Chair", 800},
	{1, 2123, "White Dining Chair Wooden Legs", 320},
	{1, 2124, "Light Brown Wooden Dining Chair", 320},
	{1, 19994, "Dark Color Wooden Chair Metallic Legs", 320},
	{1, 1806, "Navy Wheeled Office Chair", 320},
	{1, 2636, "Pizza Chair", 320},
	{1, 2724, "Black Metallic Strip Chair", 320},
	{1, 2777, "Black Metallic Strip Chair", 320},
	{1, 2788, "Red & Green Metallic Burger Chair", 320},
	{1, 1724, "Black Silk Arm Chair", 320},
	{1, 1705, "Brown Silk Arm Chair", 320},
	{1, 1707, "Chevy Arm Chair", 320},
	{1, 1708, "Blue Business Arm Chair", 320},
	{1, 1711, "Basic Arm Chair", 320},
	{1, 1727, "Black Leather Arm Chair", 320},
	{1, 1729, "Egg Shaped Basic Arm Chair", 320},
	{1, 1735, "Flowered Style Country Arm Chair", 400},
	{1, 1755, "Cold Autumn Styled Arm Chair", 400},
	{1, 1758, "Autumn Styled Arm Chair", 400},
	{1, 1759, "Basic Flower Styled Arm Chair", 400},
	{1, 1762, "Basic Wooden Arm Chair", 400},
	{1, 1765, "Basic Polyester Tiled Arm Chair", 400},
	{1, 1767, "Basic Indian Styled Arm Chair", 400},
	{1, 1769, "Blue Cotton Arm Chair", 400},
	{1, 2096, "Rocking Chair", 400},
	{1, 11682, "Brown Thick Silk Armchair", 400},
	{1, 1702, "Brown Silk Couch", 400},
	{1, 1703, "Black Silk Couch", 400},
	{1, 1706, "Purple Cotton Couch", 400},
	{1, 1710, "Long x2 Basic Couch", 400},
	{1, 1712, "Long Basic Couch", 400},
	{1, 1713, "Blue Business Couch", 585},
	{1, 1756, "Basic Indian Styled Couch", 380},
	{1, 1757, "Autumn Styled Couch", 360},
	{1, 1760, "Cold Autumn Styled Couch", 350},
	{1, 1761, "Basic Wooden Couch", 400},
	{1, 1763, "Basic Flower Styled Couch", 350},
	{1, 1764, "Basic Polyester Tiled Couch", 395},
	{1, 1768, "Blue Cotton Couch", 365},
	{1, 2290, "Thick Silk Couch", 665},
	{1, 11689, "Booth", 600},
	{1, 1716, "Metal Stool", 650},
	{1, 1805, "Short Red Cotton Stool", 525},
	{1, 2293, "Thick Silk Foot Stool", 100},
	{1, 2350, "Red Cotton Stool", 425},
	{1, 2723, "Retro Metal Stool", 700},
	{1, 2357, "Long Wooden Table", 250},
	{1, 2118, "Marble Top Table", 300},
	{1, 2117, "Pine Wood Table", 300},
	{1, 2115, "Oak Wood Table", 470},
	{1, 2110, "Basic Wood Table", 150},
	{1, 15037, "Table With TV", 400},
	// C eetables
	{1, 1813, "Basic Oak Coffee Table", 1750},
	{1, 1814, "Fancy Oak Coffee Table/Drawers", 1550},
	{1, 1815, "Oval Coffee Table", 3750},
	{1, 1817, "Fancy Oak Coffee Table	", 1500},
	{1, 1818, "Square Oak Coffee Table", 1350},
	{1, 1819, "Fancy Circle Coffee Table", 1500},
	{1, 1820, "Basic Circle Coffee Table", 1750},
	{1, 1822, "Mahogany Oval Coffee Table", 1750},
	{1, 1823, "Mahogany Square Coffee Table", 1500},
	{1, 2126, "Ebony Wood Basic Coffee Table", 1750},

	{2, 2558, "Green Curtains", 550},
	{2, 2561, "Wide Green Curtains", 200},
	{2, 2048, "Confederate Flag", 200},
	{2, 2614, "USA Flags", 200},
	{2, 11245, "USA Flags", 200},
	{2, 2914, "Green Flag", 200},
	{2, 2631, "Red Mat", 200},
	{2, 2632, "Turquoise Mat", 350},
	{2, 1828, "Tiger Rug", 200},
	{2, 2815, "Runway Rug", 510},
	{2, 2817, "Bubbles Rug", 300},
	{2, 2818, "Red & Orange Tile Bath Rug", 320},
	{2, 2833, "Royal Tan Rug", 550},
	{2, 2834, "Plain Tan Rug", 500},
	{2, 2835, "Ovan Tan Rug", 430},
	{2, 2836, "Royal Diamond Rug", 600},
	{2, 2841, "Oval Water Tile Rug", 372},
	{2, 2842, "Pink Diamond Rug", 323},
	{2, 2847, "Sand Styled Rug", 300},
	{2, 2743, "Crying Man Statue", 15000},
	{2, 1736, "Moose Head", 5000},
	{2, 1640, "Green Striped Towel", 250},
	{2, 1641, "Blue R* Towel", 200},
	{2, 1642, "White Sprinkled Red Towel", 300},
	{2, 1643, "Wayland Towel", 245},
	{2, 2289, "City Painting", 2250},
	{2, 2287, "Boats Painting", 1500},
	{2, 2286, "Ship Painting", 1000},
	{2, 2285, "Abstract Painting", 900},
	{2, 2284, "Building Painting", 600},
	{2, 2274, "Abstract Painting", 600},
	{2, 2282, "Landscape Painting", 300},
	{2, 2281, "Landscape Painting", 300},
	{2, 2280, "Landscape Painting", 300},
	{2, 2279, "Landscape Painting", 300},
	{2, 2278, "Boat Painting", 950},
	{2, 2277, "Cat Painting", 1000},
	{2, 2276, "Bridge Painting", 1200},
	{2, 2275, "Fruits Painting", 600},
	{2, 2274, "Flowers Painting", 1500},
	{2, 2273, "Flowers Painting", 600},
	{2, 2272, "Landscape Painting", 800},
	{2, 2271, "Abstract Painting", 750},
	{2, 2270, "Leaves Painting", 1250},
	{2, 2269, "Landscape Painting", 1100},
	{2, 2268, "Cat Painting", 1000},
	{2, 2267, "Ship Painting", 1000},
	{2, 2266, "City Painting", 850},
	{2, 2265, "Landscape Painting", 1400},
	{2, 2264, "Beach Painting", 1350},
	{2, 2263, "City Painting", 1500},
	{2, 2262, "City Painting", 1450},
	{2, 2261, "Bridge Painting", 1500},
	{2, 2260, "Boat Painting", 1000},
	{2, 2259, "Landscape Painting", 800},
	{2, 2258, "Landscape Painting", 2000},
	{2, 2257, "Abstract Painting", 1200},
	{2, 2256, "Landscape Painting	", 2250},
	{2, 2255, "Candy Suxx Painting", 4500},
	{2, 859, "Plant Top", 350}, //Decorations => Plants
	{2, 860, "Bushy Plant Top", 375},
	{2, 861, "Tall Plant Top", 345},
	{2, 862, "Tall Orange Plant Top", 400},
	{2, 863, "Cactus Top", 700},
	{2, 638, "Planted Bush", 2500},
	{2, 640, "Long Planted Bush", 1200},
	{2, 948, "Dry Plant Pot", 800},
	{2, 949, "Normal Plant Pot", 100},
	{2, 950, "Big Dry Plants Pot", 1200},
	{2, 2001, "Long Plants Pots", 1350},
	{2, 2010, "Long Plants Pot 2", 1400},
	{2, 2011, "Long Plants Pot 3", 1500},
	{2, 2194, "Short Plants Pot", 700},
	{2, 2195, "Short Plants Pot 2", 900},
	{2, 2203, "Empty Pot", 200},
	{2, 2240, "Weeds In Red Pot", 1350},
	{2, 2241, "Rusty Pottery Plant", 1200},
	{2, 2242, "Empty Red Pot", 350},
	{2, 2244, "Plants With Big Wooden Pot", 1500},
	{2, 2243, "Red Flowers With Wide Modern Pot", 1400},
	{2, 2246, "Empty White Vase", 2000},
	{2, 2247, "Oriental Plants In Glass Vase", 1650},
	{2, 2248, "Empty Tall Red Vase", 1000},
	{2, 2249, "Oriental Flowers In Glass Vase", 1500},
	{2, 2250, "Spring Flowers In Glass Vase", 1200},
	{2, 2251, "Oriental Flowers In blue Designer Glass", 1600},
	{2, 2252, "Small Bowl Plant", 1000},
	{2, 2253, "Red Flowers In Wooden Cube", 1500},
	{2, 2345, "Vines", 700},
	{2, 3802, "Hanging Red Flowers", 1250},
	{2, 3806, "Wall Mounted Flowers", 1500},
	{2, 3810, "Hanging Flowers", 1250},
	{2, 3811, "Wall Mounted Flowers With Dandelion", 1000},
	{2, 861, "Dark Exotic Plants", 1400},
	{2, 2195, "Potted Shrub", 1200},
	{2, 2049, "Shooting Target", 140},  //Decorations => Posters
	{2, 2050, "Shooting Targets", 140},
	{2, 2051, "Inverted Shooting Target", 140},
	{2, 2691, "Base 5 Poster", 140},
	{2, 2695, "Thin Bare 5 Poster", 70},
	{2, 2696, "Thin Bare 5 Dog Poster", 70},
	{2, 2692, "Wheelchairster cutout Poster", 200},
	{2, 2693, "Nino Cutout Poster", 200},
	{2, 19328, "Filthy Chicks Poster", 140},
	{2, 2646, "Candy Suxx Set Poster", 140},
	{3, 1985, "Punching Bag", 5000}, // Entertainment => Sporting Equipment
	{3, 2627, "Treadmill", 11200},
	{3, 2628, "Weight Lifting Bench", 7500},
	{3, 2629, "Weight Lifting Bench", 7500},
	{3, 2916, "One Dumbbell", 2500},
	{3, 2915, "Two Dumbells", 5000},
	{3, 2630, "Exercise Bike", 7600},
	{3, 2964, "Blue Pool Table", 6000},
	{3, 14651, "Green Pool Table", 4000},
	{3, 338, "Pool Cue", 700},
	{3, 3003, "Pool: Cue Ball", 1500},
	{3, 3106, "Pool: 8 Ball", 1000},
	{3, 3105, "Pool: Red Solid Ball", 700},
	{3, 3104, "Pool: Green Solid Ball", 700},
	{3, 3103, "Pool: Orange Solid Ball", 700},
	{3, 3101, "Pool: Red Solid Ball", 700},
	{3, 3100, "Pool: Blue Solid Ball", 700},
	{3, 3002, "Pool: Yellow Solid Ball", 700},
	{3, 2997, "Pool: Maroon Stripe Ball", 700},
	{3, 3000, "Pool: Green Stripe Ball", 700},
	{3, 2999, "Pool: Orange Stripe Ball", 700},
	{3, 2997, "Pool: Red Stripe Ball", 700},
	{3, 2996, "Pool: Blue Stripe Ball", 700},
	{3, 2995, "Pool: Yellow Stripe Ball	", 700},
	{3, 946, "Hanging Basketball Goal", 1200},
	{3, 3065, "Basketball", 1100},
	{3, 2316, "Small Black Television", 3800}, // Entertainment => Televisions
	{3, 2320, "Wooden Television", 2550},
	{3, 2317, "Rusty Television", 2000},
	{3, 2322, "Dark Wooden Television", 2500},
	{3, 1429, "Wooden White Television", 2550},
	{3, 1791, "Tall Black Television", 2000},
	{3, 2595, "Television On Top Of DVD", 2600},
	{3, 14532, "Rolling Television Stand", 2000},
	{3, 2596, "Mounted Black Television", 2300},
	{3, 1751, "White Metal Television", 2700},
	{3, 2648, "Tall Black Television", 2000},
	{3, 1781, "Slim Tall Black Television", 2300},
	{3, 1752, "Medium Black Television", 3200},
	{3, 2224, "Orange Sphere Television", 1200},
	{3, 1792, "Slim Grey Television", 3200},
	{3, 19787, "Large Wide Television", 3500},
	{3, 1515, "Triple Play Poker Machine", 8000}, // Entertainment => Gaming Machines
	{3, 2778, "Bee Be Gone Arcade Machine", 7500},
	{3, 2779, "Duality Arcade Machine", 7500},
	{3, 2028, "Xbox 360 Console	2028",8000},
	{3, 1782, "HI-DE DVD Player", 1200}, // Entertainment => Media Players
	{3, 1783, "DVR620 DVD Player", 1500},
	{3, 1785, "Sunny DVD Player", 1400},
	{3, 1787, "BD655 Blu-Ray Player", 1300},
	{3, 1788, "BD670 Blu-Ray Player", 1500},
	{3, 2100, "Stereo System & Speakers", 1025}, // Entertainment => Stereos
	{3, 2101, "Stereo System", 1500},
	{3, 2102, "Retro Boombox", 1800},
	{3, 2103, "White Boombox ", 1000},
	{3, 2104, "Stereo System Stand", 1400},
	{3, 2226, "Boombox", 1500},
	{3, 2229, "Metal Plate Speaker", 1300}, // Entertainment => Speakers
	{3, 2230, "Wooden Speaker", 1200},
	{3, 2231, "Wooden Speaker Amplifier", 4000},
	{3, 2232, "Metal Plate Speaker Amplifier", 5000},
	{3, 2233, "Futuristic Speaker", 8000},
	//L s
	{4, 2238, "Lava Lamp", 900},
	{4, 2196, "Work Lamp", 800},
	{4, 2026, "White Lamp", 860},
	{4, 2726, "Red Lamp", 860},
	{4, 3534, "Red Lamp Style 2", 860},
	//S ces
	{4, 1731, "Gray Sconce", 1500},
	{4, 3785, "Bulkhead Light", 1600},
	//C inglights
	{4, 2075, "Long Bulb Ceiling Light", 2500},
	{4, 2073, "Brown Threaded Ceiling Light", 3200},
	{4, 2074, "Hanging Light Bulb", 200},
	{4, 2075, "Romantic Red Ceiling Light", 3500},
	{4, 2076, "Hanging Bowl Ceiling Light", 1200},
	{4, 16779, "Wooden Ceiling Fan", 3300},
	//N lights
	{4, 18647, "Red Neon Light", 1200},
	{4, 18648, "Blue Neon Light", 1200},
	{4, 18649, "Green Neon Light", 1200},
	{4, 18650, "Yellow Neon Light", 1200},
	{4, 18651, "Pink Neon Light", 1200},
	{4, 18652, "White Neon Light", 1200},
	//T ets
	{5, 2514, "Plain Toilet", 1750},
	{5, 2521, "White Metal Toilet	", 2000},
	{5, 2525, "Sauna Toilet", 2000},
	{5, 2528, "Black Wooden Toilet", 2500},
	//S s
	{5, 2013, "Maggie's Co. Sink", 2850},
	{5, 2132, "Creamy Metal Sink", 2600},
	{5, 2136, "Sterlin Co. Metal Sink", 1000},
	{5, 2150, "Old Town Sink Pt.2", 500},
	{5, 2518, "Wooden Snow White Sink", 1850},
	{5, 2523, "Bathroom Sink With Pad", 1550},
	{5, 2739, "Bare Bathroom Sink", 1700},
	//S ers
	{5, 2517, "Silver Glass Shower", 8000},
	{5, 2520, "Dark Metal Shower	", 7550},
	{5, 2527, "Sauna Shower	", 4000},
	//B tubs
	{5, 2097, "Sprunk Bath Tub", 5000},
	{5, 2516, "Sparkly White Bath Tub", 1500},
	{5, 2519, "White Bath Tub", 4900},
	{5, 2522, "Dark Wooden Bath Tub", 4200},
	{5, 2526, "Sauna Wooden Bath Tub", 4500},
	//S 
	{6, 2332, "Sealed Safe", 8000},
	//B shelves
	{6, 1742, "Half Empty Book Shelf", 1200},
	{6, 14455, "Large Green Book Shelves", 1200},
	{6, 2608, "Three Wooden Level Book Shelf", 2500},
	//D sers
	{6, 2330, "Standard Wooden Dresser", 3250},
	{6, 2323, "Light Wooden Dresser Bottom Opening Legs", 3500},
	{6, 2088, "Long Light Wooden Dresser Legs", 4300},
	//F ing Cabinets
	{6, 2000, "Metal Filing Cabinet", 1500},
	{6, 2007, "Double Filing Cabinet", 1200},
	{6, 2163, "Wall Mounted Filing Cabinet", 900},
	{6, 2200, "Tall Wall Mounted Filing Cabinet", 1200},
	{6, 2197, "Brown Metal Filing CabinetAME", 1500},
	{6, 2167, "Big Oak Filing Cabinet", 1200},
	//P ries
	{6, 2128, "LoveSet Pantry", 1200},
	{6, 2140, "Sterlin Co. Pantry", 2000},
	{6, 2141, "Creamy Metal Pantry", 2500},
	{6, 2145, "Old Town Pantry", 2500},
	{6, 2153, "Wooden Snow White Pantry", 2000},
	{6, 2158, "Mahogany Green Wood Pantry", 2000},
	//D ngtables
	
	//C ters
	{7, 2014, "Maggie's Co. Counter Top", 950},
	{7, 2015, "Maggie's Co. Counter Right Handle", 1000},
	{7, 2016, "Maggie's Co. Counter Left Handle", 2000},
	{7, 2019, "Maggie's Co. Blank Counter Top", 4000},
	{7, 2022, "Maggie's Co. Corner Counter Top", 4000},
	{7, 2129, "LoveSet Counter Top", 2000},
	{7, 2133, "Creamy Metal Counter Top", 2000},
	{7, 2137, "Sterlin Co. Cabinet Top", 3500},
	{7, 2138, "Sterlin Co. Counter Top", 3500},
	{7, 2139, "Sterlin Co. Counter", 3500},
	{7, 2142, "Old Town Counter", 2000},
	{7, 2151, "Wooden Snow White Counter Top", 3250},
	{7, 2152, "Wooden Snow White Cabinete Counter", 2750},
	{7, 2153, "Wooden Snow White Counter", 1200},
	{7, 2156, "Mahogany Green Wood Counter", 2000},
	{7, 2159, "Mahogany Green Wood Cabinet Counter", 1200},
	{7, 2414, "Laguna Wooden Counter", 2200},
	{7, 2424, "Light Blue IceBox Counter", 2100},
	{7, 2423, "Light Blue IceBox Corner Counter	", 2100},
	{7, 2435, "November Wood Counter", 2100},
	{7, 2434, "November Wood Corner Counter", 2100},
	{7, 2439, "Dark Marble Diamond Counter", 4000},
	{7, 2440, "Dark Marble Diamond Corner Counter", 4000},
	{7, 2441, "Marble Zinc Top Counter", 4200},
	{7, 2442, "Marble Zinc Top Corner Counter", 6000},
	{7, 2445, "Marble Zinc Top Counter (Regular)", 2500},
	{7, 2444, "Marble Zinc Top Counter (Half Design)", 2500},
	{7, 2446, "Parlor Red Counter", 2000},
	{7, 2450, "Parlor Red Corner Counter", 2000},
	{7, 2455, "Parlor Red Checkered Counter", 2000},
	{7, 2454, "Parlor Red Checkered Corner Counter", 2000},
	//D laycabinets
	{7, 2046, "Basic Wooden Display Cabinet", 1450},
	{7, 2078, "Fancy Dark Wooden Display Cabinet", 2150},
	{7, 2385, "Glass Front Wooden Display Cabinet", 1750},
	{7, 2458, "Delicate Glass Wooden Display Cabinet", 1750},
	{7, 2459, "Long Delicate Glass Wooden Display Cabinet", 1750},
	{7, 2460, "Mini Delicate Glass Wooden Display Cabinet", 1750},
	{7, 2461, "Cubed Delicate Glass Wooden Display Cabinet", 1750},
	//D layshelves
	{7, 2063, "Industrial Display Shelf", 2450},
	{7, 2210, "Black Metal Glass Display Shelf", 2750},
	{7, 2211, "Wooden Glass Display Shelf", 2750},
	{7, 2403, "Very Large Wooden Display Shelf", 16750},
	{7, 2462, "Wall Mounted Thin Wooden Display Shelf", 2750},
	{7, 2463, "Wall Mounted Thin Wooden Display Shelf", 1200},
	{7, 2708, "Wooden Display Shelf With Bar", 3200},
	{7, 2367, "Modern White Counter Display Shelf", 3500},
	{7, 2368, "Wooden Counter Display Shelf", 3500},
	{7, 2376, "Wooden & Glass Table Display Shelf", 1200},
	{7, 2447, "Tall Parlor Red Display Shelf", 2300},
	{7, 2448, "Wide Parlor Red Display Shelf", 2500},
	{7, 2449, "Tall & Wide Parlor Red Display Shelf", 3700},
	{7, 2457, "Parlor Red Checkered Display Shelf", 4500},
	//T ands
	{7, 2306, "Three Level Wooden TV Stand", 1500},
	{7, 2321, "Small Two Level TV Stand", 1700},
	{7, 2319, "Antique Oak TV Stand", 1350},
	{7, 2314, "Light Wooden Small TV Stand", 1950},
	{7, 2315, "Small Wooden TV Stand", 1700},
	{7, 2313, "Light Wooden TV Stand With VCR", 2500},
	{7, 2236, "Dark Mahogany TV Stand", 2900},
	//M ellaneous
	//C hes
	{8, 2374, "Blue Plaid Shirts Rail", 200},
	{8, 2377, "Black Levis Jeans Rail", 400},
	{8, 2378, "Black Levis Jeans Rail", 400},
	{8, 2381, "Row of Sweat Pants", 560},
	{8, 2382, "Row of Levis Jeans	", 1000},
	{8, 2383, "Yellow Shirts Rail", 200},
	{8, 2384, "Stack of Khaki Pants", 300},
	{8, 2389, "Red And White Sports Jacket Rail", 680},
	{8, 2390, "Green Sweat Pants Rail", 240},
	{8, 2391, "Khaki Pants Rail", 300},
	{8, 2392, "Row of Khakis & Levis Jeans", 950},
	{8, 2394, "Row of Shirts", 850},
	{8, 2396, "Black and Red Blazers Rail ", 1200},
	{8, 2397, "Grey Jeans Rail", 340},
	{8, 2398, "Blue Sweat Pants Rail", 240},
	{8, 2399, "Grey Sweatshirt Rail", 240},
	{8, 2401, "Red Sweat Pants Rail", 240},

	//G ling
	{9, 1838, "Slot Machine", 6400},
	{9, 1831, "Slot Machine", 6400},
	{9, 1832, "Slot Machine", 6400},
	{9, 1833, "Slot Machine", 6400},
	{9, 1834, "Slot Machine", 6400},
	{9, 1835, "Slot Machine", 6400},
	{9, 1838, "Slot Machine", 6400},
	{9, 1978, "Roulette Table", 3000},
	{9, 1929, "Roulette Wheel", 3000},
	{9, 2188, "Blackjack Table",3000},
	{9, 19474, "Poker Table 2", 7200},

	//G tags
	{10, 18659, "Grove St. 4 Life", 1200},
	{10, 1528, "Seville B.L.V.D Families", 1200},
	{10, 1531, "Varrio Los Aztecas", 1200},
	{10, 1525, "Kilo", 1200},
	{10, 1526, "San Fiero Rifa", 1200},
	{10, 18664, "Temple Drive Ballas", 1200},
	{10, 1530, "Los Santos Vagos", 1200},
	{10, 18666, "Front Yard Balas", 1200},
	{10, 1527, "Rollin Heights Ballas", 1200},

	
	//f ion}
	{11, 19128, "Dance Floor", 15550},
	{11, 19129, "Large Dance Floor", 25000},
	{11, 19159, "Disco Ball", 2300},
	{11, 18656, "Club Lights ", 20000},
	{11, 19122, "Blue Bollard Light", 1200},
	{11, 19123, "Green Bollard Light", 1200},
	{11, 19126, "Light Blue Bollard Light", 1200},
	{11, 19127, "Purple Bollard Light", 1200},
	{11, 19124, "Red Bollard Light", 1200},
	{11, 19121, "White Bollard Light", 1200},
	{11, 19125, "Yellow Bollard Light", 1200},
	//E
	{11, 18864, "Snow Machine", 13500},
	{11, 18715, "Smoke Machine", 13500},
	{11, 19150, "Club Lights 1", 13500},
	{11, 19152, "Club Lights 2", 13500},
	//
	{12, 2694, "Shoebox PRO laps", 500},
	{12, 968, "cm_box", 500},
	{12, 19564, "cm_box", 500},
	{12, 19563, "cm_box", 500},
	{12, 19563, "cm_box", 500},
	{12, 19562, "cm_box", 500},
	{12, 19561, "cm_box", 500},
	{12, 19561, "cm_box", 500},
	
	
	//W s
	{13, 19353, "Ice Cream Parlor Wall", 1200},
	{13, 19354, "Leather Diamond Wall", 1200},
	{13, 19355, "Cement Think Brick Wall", 1500},
	{13, 19356, "Wooden Wall", 1200},
	{13, 19357, "Cement Wall", 1500},
	{13, 19358, "Grey & Black Cotton Wall", 1200},
	{13, 19359, "Plain Tan Wall", 1300},
	{13, 19360, "Tough Light Wood Wall", 1300},
	{13, 19361, "Tan & Red Wall", 1300},
	{13, 19362, "Road Textured Wall", 1200},
	{13, 19363, "Plain Dark Pastel Pink Wall", 1400},
	{13, 19364, "Cement Brick Wall", 1500},
	{13, 19365, "Plain Light Blue Wall", 1200},
	{13, 19366, "Thick Wood Wall", 2400},
	{13, 19367, "Light Blue Spring Themed Wall", 1400},
	{13, 19368, "Light Pink Spring Themed Wall", 1400},
	{13, 19369, "Light Yellow Spring Themed Wall", 1300},
	{13, 19370, "Bright Wooden Wall", 1400},
	{13, 19371, "Plain Cement Wall", 1100},
	{13, 19372, "Sand Wall", 1400},
	{13, 19373, "Grass Wall", 1300},
	{13, 19375, "Wavey Wooden Wall", 1400},
	{13, 19376, "Red Wooden Wall", 1300},
	{13, 19377, "Carpet Textured Wall", 1400},
	{13, 19378, "Dark Wooden Wall", 1400},
	{13, 19379, "Basic Light Wood Wall", 1400},
	{13, 19380, "Dark Sand Wall", 1400},
	{13, 19381, "Dark Grass Wall", 1300},
	//W sdoorway
	{14, 19383, "Ice Cream Parlor Wall (Doorway)", 1200},
	{14, 19384, "Leather Diamond Wall (Doorway)", 1200},
	{14, 19391, "Cement Think Brick Wall (Doorway)", 1200},
	{14, 19386, "Wooden Wall (Doorway)", 1200},
	{14, 19387, "Cement Wall (Doorway)	", 1200},
	{14, 19388, "Grey & Black Cotton Wall (Doorway)", 1200},
	{14, 19389, "Plain Tan Wall (Doorway)", 1200},
	{14, 19390, "Tan & Red Wall (Doorway)", 1200},
	{14, 19385, "Road Textured Wall (Doorway)", 1200},
	{14, 19392, "Plain Dark Pastel Pink Wall (Doorway)", 1200},
	{14, 19393, "Cement Brick Wall (Doorway)", 1200},
	{14, 19394, "Plain Light Blue Wall (Doorway)", 1200},
	{14, 19395, "Light Blue Spring Themed Wall (Doorway)", 1200},
	{14, 19396, "Light Pink Spring Themed Wall (Doorway)", 1200},
	{14, 19397, "Light Yellow Spring Themed Wall (Doorway)", 1200},
	{14, 19398, "Plain Cement Wall (Doorway)", 1200},
	//W sopenwindow
	{15, 19399, "Ice Cream Parlor Wall (Open Window)", 1200},
	{15, 19400, "Leather Diamond Wall (Open Window)", 1200},
	{15, 19401, "Cement Think Brick Wall (Open Window)", 3300},
	{15, 19402, "Wooden Wall (Open Window)", 1200},
	{15, 19403, "Cement Wall (Open Window)", 3200},
	{15, 19404, "Grey & Black Cotton Wall (Open Window)", 3200},
	{15, 19405, "Plain Tan Wall (Open Window)", 3300},
	{15, 19407, "Tan & Red Wall (Open Window)", 3200},
	{15, 19408, "Road Textured Wall (Open Window)", 3300},
	{15, 19409, "Plain Dark Pastel Pink Wall (Open Window)", 3300},
	{15, 19410, "Cement Brick Wall (Open Window)", 3200},
	{15, 19411, "Plain Light Blue Wall (Open Window)", 3300},
	{15, 19412, "Thick Wooden Wall (Open Window)", 3300},
	{15, 19413, "Light Blue Spring Themed Wall (Open Window)", 3300},
	{15, 19414, "Light Pink Spring Themed Wall (Open Window)", 3200},
	{15, 19415, "Light Yellow Spring Themed Wall (Open Window)", 3300},
	{15, 19416, "Basic Light Wood Wall (Open Window)", 3300},
	{15, 19417, "Plain Cement Wall (Open Window)", 3200},
	//W sthin
	{16, 19426, "Ice Cream Parlor Wall (Thin)", 2000},
	{16, 19427, "Leather Diamond Wall (Thin)", 2000},
	{16, 19428, "Cement Think Brick Wall (Thin)", 2000},
	{16, 19429, "Wooden Wall (Thin)", 2000},
	{16, 19430, "Cement Wall (Thin)", 2000},
	{16, 19431, "Grey & Black Cotton Wall (Thin)", 2000},
	{16, 19432, "Plain Tan Wall (Thin)", 2000},
	{16, 19433, "Tan & Red Wall (Thin)", 2200},
	{16, 19435, "Road Textured Wall (Thin)", 2200},
	{16, 19436, "Plain Dark Pastel Pink Wall (Thin)", 2200},
	{16, 19437, "Cement Brick Wall (Thin)", 2200},
	{16, 19438, "Plain Light Blue Wall (Thin)", 2200},
	{16, 19439, "Thick Wooden Wall (Thin)", 2300},
	{16, 19440, "Light Blue Spring Themed Wall (Thin)", 2300},
	{16, 19441, "Light Pink Spring Themed Wall (Thin)", 2300},
	{16, 19442, "Light Yellow Spring Themed Wall (Thin)", 2400},
	{16, 19443, "Basic Light Wood Wall (Thin)", 2400},
	{16, 19444, "Plain Cement Wall (Thin)", 2500},
	//W swide
	{17, 19445, "Ice Cream Parlor Wall (Wide)", 2300},
	{17, 19446, "Leather Diamond Wall (Wide)", 2300},
	{17, 19447, "Cement Think Brick Wall (Wide)", 2300},
	{17, 19448, "Wooden Wall (Wide)", 2300},
	{17, 19449, "Cement Wall (Wide)", 2300},
	{17, 19450, "Grey & Black Cotton Wall (Wide)", 2300},
	{17, 19451, "Plain Tan Wall (Wide)", 2300},
	{17, 19452, "Red Wooden Wall (Wide)", 2300},
	{17, 19453, "Tan & Red Wall (Wide) ", 2300},
	{17, 19454, "Carpet Textured Wall (Wide)	", 2300},
	{17, 19455, "Plain Dark Pastel Pink Wall (Wide)", 2300},
	{17, 19456, "Cement Brick Wall (Wide)", 2300},
	{17, 19457, "Plain Light Blue Wall (Wide)", 2300},
	{17, 19458, "Thick Wooden Wall (Wide)", 2300},
	{17, 19459, "Light Blue Spring Themed Wall (Wide)", 2300},
	{17, 19460, "Light Pink Spring Themed Wall (Wide)", 2300},
	{17, 19461, "Light Yellow Spring Themed Wall (Wide)", 2300},
	{17, 19462, "Basic Light Wood Wall (Wide)", 2300},
	{17, 19463, "Plain Cement Wall (Wide)", 2300},
	//G s
	{18,  19466, "Regular Glass", 1200},
	{18,  1651, "Glass", 1200},
	{18,  1649, "Long Glass", 6000},
	{18,  1651, "Tall Glass", 4000},
	{18,  19325, "Unbreakable Glass", 7000},
	//S rs
	{18,  3399, "Stairs 1", 1000},
	{18,  14411, "Stairs 2", 1000},
	{18,  14874, "Stairs 3", 1000},

		//C umables
	{19, 1487, "Bottle with alcohol", 20},
	{19, 19823, "Bottle with alcohol", 20},
	{19, 19998, "Zippo", 20},
	{19, 1546, "Sprite", 50},
	{19, 1950, "Beer Bottle", 50},
	{19, 2958, "Beer Bottle", 50},
	{19, 1486, "Beer Bottle", 50},
	{19, 1543, "Beer Bottle", 50},
	{19, 1544, "Beer Bottle", 50},
	{19, 1520, "Scotch Bottle", 100},
	{19, 1644, "Wine Bottle", 150},
	{19, 1669, "Wine Bottle", 150},
	{19, 19822, "Wine Bottle", 150},
	{19, 19820, "Wine Bottle", 150},
	{19, 1488, "Wine Bottle", 150},
	{19, 19821, "Wine Bottle", 150},
	{19, 1511, "Wine Bottle", 150},
	{19, 11743, "Wine Bottle", 150},
	{19, 19830, "Wine Bottle", 150},
	
	
	
	
	 // coffee
	
	//D s
	{20, 3109, "White Basic Door", 4000},
	{20, 19857, "Wooden Door With Small Window", 5500},
	{20, 3093, "Gate Door", 1200},
	{20, 2947, "Heavy Blue Door", 5750},
	{20, 2955, "White Basic Room Door", 4000},
	{20, 2946, "Golden Door", 5750},
	{20, 2930, "Small Cell Gate", 1200},
	{20, 977, "Old Office Door", 4000},
	{20, 1491, "Swinging Dark Wooden Door", 5000},
	{20, 1492, "White Wooden Door", 4500},
	{20, 1493, "Red Shop Door", 3500},
	{20, 1494, "Blue Wooden Door", 4500},
	{20, 1495, "Blue Wired Door", 3500},
	{20, 1496, "Metal Love Shop Door", 4500},
	{20, 1497, "Metal Door", 5000},
	{20, 1498, "Dirty White Door", 2600},
	{20, 1499, "Dirty Metal Door", 4700},
	{20, 1500, "Metal Screen Door", 4700},
	{20, 1501, "Wooden Screen Door", 4700},
	{20, 1502, "Swinging Wooden Door", 5000},
	{20, 1504, "Red Door", 4000},
	{20, 1505, "Blue Door", 4000},
	{20, 1506, "White Door", 4000},
	{20, 1507, "Yellow Door", 4000},
	{20, 1522, "Shop Door With Stickers", 3500},
	{20, 1532, "Shop Door With Stickers 2", 3500},
	{20, 1533, "Metal Shop Door", 4000},
	{20, 1523, "Swinging Metal Door With Window", 4500},
	{20, 1535, "Basic White Door", 4000},
	{20, 1569, "Modern Black Door", 4000},
	{20, 1559, "Modern Black Door Golden Frame", 5000},
	//M 
	{21, 2670, "Random Mess", 5},
	{21, 2671, "Random Mess", 5},
	{21, 2673, "Random Mess", 5},
	{21, 2674, "Random Mess", 5},
	{21, 2867, "Random Mess", 5},
	{21, 2672, "Burger Shot Mess", 8},
	{21, 2675, "Burger Shot Mess", 8},
	{21, 2677, "Burger Shot Mess", 8},
	{21, 2840, "Burger Shot Mess", 8},
	{21, 2676, "Newspapers & Burger Shot Mess", 13},
	{21, 2850, "Dishes", 20},
	{21, 2843, "Messy Clothes", 50},
	{21, 2844, "Messy Clothes", 50},
	{21, 2845, "Messy Clothes", 50},
	{21, 2846, "Messy Clothes", 50},
	{21, 2851, "Dishes", 20},
	{21, 2821, "Cereal Box & Cans", 10},
	{21, 2822, "Blue Dishes", 30},
	{21, 2829, "Colorful Dishes", 30},
	{21, 2830, "Dishes", 30},
	{21, 2831, "Dishes & Colorful Cups", 30},
	{21, 2832, "Colorful Dishes", 40},
	{21, 2837, "Cluck N Bell Mess", 8},
	{21, 2838, "Pizza Stack Mess", 10},
	{21, 2839, "Chinese Food Mess", 7},
	{21, 2848, "Dishes With Pizza", 12},
	{21, 2850, "Dishes With Pizzaz", 13},
	{21, 2849, "Colorful Dishes", 30},
	{21, 2851, "Dishes", 20},
	{21, 2856, "Crushed Milk", 5},
	{21, 2857, "Pizza Box Mess", 6},
	{21, 2861, "Empty Cookie Boxes", 2},
	{21, 2866, "Empty Cookie Boxes & Cans", 4},
	//M ellaneous
	{22, 2680, "Padlock", 700},
	{22, 1665, "Ashtray", 700},
	{22, 14774, "Electric Fly Killer", 2000},
	{22, 2961, "Fire Alarm Button", 900},
	{22, 2962, "Fire Alarm Button (Sign)", 700},
	{22, 2616, "Whiteboard", 3500},
	{22, 2611, "Blue Pinboard", 700},
	{22, 2612, "Blue Pinboard	", 700},
	{22, 2615, "Articles", 100},
	{22, 2896, "Casket", 10000},
	{22, 2404, "R* Surfboard", 2000},
	{22, 2405, "Red & Blue Surfboard", 2000},
	{22, 2406, "Vice City Surfboard", 2000},
	{22, 2410, "Wooden Surfboard", 2000},
	//P ars
	{23, 3494, "Stone Pillar", 5300},
	{23, 3498, "Tall Wooden Pillar", 5200},
	{23, 3499, "Fat Tall Wooden Pillar", 5300},
	{23, 3524, "Pillar Skull Head", 5240},
	{23, 3533, "Red Dragon Pillar", 5150},
	{23, 3529, "Brick Construction Pillar", 5500},
	{23, 3503, "Metal Pole", 1850},
	//S rity
	{24, 1622, "Security Camera", 1200},
	{24, 1616, "Security Camera", 1200},
	{24, 1886, "Security Camera", 1200},
	//O ce
	{25, 1808, "Ja Water Dispenser", 150},
	{25, 1998, "Office Desk & Equipment", 1300},
	{25, 1999, "Office Light Wooden Desk & Computer", 1000},
	{25, 2002, "Water Dispenser", 150},
	{25, 2008, "Office White Top Desk & Equipment", 1200},
	{25, 2009, "White Office Desk & Computer", 1250},
	{25, 2161, "Office Shelf & Files", 80},
	{25, 2162, "Wide Office Shelf & Files", 160},
	{25, 2164, "Wide and Tall Office Shelf & Files", 300},
	{25, 2165, "Oak Office Desk & Equipment", 4500},
	{25, 2166, "Oak Office Desk & Files", 3800},
	{25, 2169, "White Office Desk With Wood Top", 2200},
	{25, 2171, "Wood Top Desk With Backboard", 2400},
	{25, 2172, "Blue Office Desk & Equipment", 5600},
	{25, 2173, "Oak Office Desk", 5000},
	{25, 2174, "Wood Top Desk With Backboard & Equipment", 2800},
	{25, 2175, "Wood Top Desk Corner", 1900},
	{25, 2180, "Wide Wooden Desk", 2500},
	{25, 2181, "Office Desk With Backboard & Computer", 2500},
	{25, 2308, "Office Desk & Files", 2200},
	{25, 2183, "Four Divided Wooden Desks", 8500},
	{25, 2184, "Diagonal Wooden Desk", 2000},
	{25, 2185, "Open Wooden Desk & Computer", 1000},
	{25, 2186, "Office Printer", 4000},
	{25, 2187, "Blue Cubicle Divider", 1000},
	{25, 2190, "Computer", 760},
	//T 
	{26, 2511, "Toy Red Plane", 10},
	{26, 2471, "Three Train Toy Boxes", 20},
	{26, 2472, "Four Toy Red Planes", 40},
	{26, 2473, "Two Toy Red Planes", 20},
	{26, 2474, "Four Train Toys", 30},
	{26, 2477, "Three Hotwheels Stacked Boxes", 25},
	{26, 2480, "Four Hotwheels Stacked Boxes", 30},
	{26, 2481, "Hotwheels Box", 5},
	{26, 2483, "Train Model Box", 15},
	{26, 2484, "R* Boat Model", 25},
	{26, 2485, "Wooden Car Toy", 45},
	{26, 2487, "Tropical Diamond Kite", 30},
	{26, 2488, "Manhunt Toy Box Sets", 20},
	{26, 2490, "Vice City Toy Box Sets", 20},
	{26, 2497, "Pink Winged Box Kite", 35},
	{26, 2498, "Blue Winged Box Kite", 35},
	{26, 2499, "R* Diamond Kite", 30},
	{26, 2512, "Paper Wooden Plane", 30}
};

// 414	

Dialog:DIALOG_SEL_FURN(playerid, response, listitem, inputtext[]) {
	if(response) {
		new string[2129];
		new category = GetPVarInt(playerid,#CategoryS);
	    for(new i = 0 ; i < sizeof(FurnitureItems); i++) {
	    	if(FurnitureItems[i][e_furn_creatory] == listitem + ( category * 10)) {
                format(string, sizeof(string), "%s\n%d\t~g~$%s", string,FurnitureItems[i][e_furnobj],number_format(FurnitureItems[i][e_furn_price]));
	    	}
	    }

	    ShowPlayerDialog(playerid, DIALOG_ADD_FURN, DIALOG_STYLE_PREVIEW_MODEL, "#Furniture", string, "Mua", "Thoat");
	}
}
Dialog:DIALOG_OPTION_SFURN(playerid, response, listitem, inputtext[]) {
	if(response) {
		new choice = GetPVarInt(playerid,#SelFurniture);
		if(listitem == 0) {
			if(Furniture[choice][FurnitureSet] == 0) return SendErrorMessage(playerid, " ID Noi that chua duoc khoi tao.");
            if(Furniture[choice][FurnitureHouse] != PlayerInfo[playerid][pPhousekey]) return SendErrorMessage(playerid, " Noi that nay khong phai so huu cua nha ban.");
            if(!IsValidDynamicObject(Furniture[choice][FurnitureObject])) return SendErrorMessage(playerid, " Object chua duoc khoi tao.");
            EditDynamicObject(playerid, Furniture[choice][FurnitureObject]);
            SetPVarInt(playerid, #EditFurniture, 1);
            SetPVarInt(playerid, #EditFurnitureID, choice);
		}
		if(listitem == 1) {
			DeleteFurniture(playerid,choice);
		}
	}
	return 1;
}
Dialog:DIALOG_FURNITURE_LIST(playerid, response, listitem, inputtext[]) {
	if(response) {
		SetPVarInt(playerid,#SelFurniture,strval(inputtext));
		Dialog_Show(playerid, DIALOG_OPTION_SFURN, DIALOG_STYLE_LIST, "Furniture # Sel", "Chinh sua noi that\nXoa noi that", "Chon","Thoat");
		printf("%s",inputtext);
	
	}
}
stock GetIDFurn(objectid) {
	for(new i = 0 ; i < sizeof(FurnitureItems); i++) {
	    if(FurnitureItems[i][e_furnobj] == objectid) {
	    	return i;
	    }
	}
	return -1;
}
hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
	if(dialogid == DIALOG_ADD_FURN) {
		if(response) {
			new houseid = PlayerInfo[playerid][pPhousekey];
			if(!IsPlayerInRangeOfPoint(playerid, 40, HouseInfo[houseid][hInteriorX], HouseInfo[houseid][hInteriorY], HouseInfo[houseid][hInteriorZ])) return SendErrorMessage(playerid, " Ban khong o trong nha cua minh");
		    if(GetPlayerVirtualWorld(playerid) !=  HouseInfo[houseid][hIntVW] || GetPlayerInterior(playerid) !=  HouseInfo[houseid][hIntIW] ) return SendErrorMessage(playerid, " Ban khong o trong nha cua minh");
		    new furn_item = GetIDFurn(strval(inputtext));
		    if(furn_item == -1) return SendErrorMessage(playerid, " Da co loi xay ra.");
		    if(PlayerInfo[playerid][pCash] < FurnitureItems[furn_item][e_furn_price]) return SendErrorMessage(playerid," Ban khong du tien de mua vat pham nay.");
		    GivePlayerMoneyEx(playerid, -FurnitureItems[furn_item][e_furn_price]);
		    
		    new string[129];
		    format(string, sizeof(string), "%s da mua furniture ID #%d voi gia $%s.", GetPlayerNameEx(playerid), furn_item,number_format(FurnitureItems[furn_item][e_furn_price]));
	    	Log("logs/furniture.log", string);

		    AddFurniture(playerid,furn_item);

		}
	}
	return 1;
}

Dialog:MAIN_BUY_F(playerid, response, listitem, inputtext[]) {
	if(response) {
		SetPVarInt(playerid,#CategoryS,listitem);
		ShowCategoryF(playerid);

	}
}
stock ShowCategoryF(playerid) {
	new category = GetPVarInt(playerid,#CategoryS);
	new string[1529];
    for(new i = 0 + (category * 10) ; i < sizeof(fCategory); i++) {
       format(string, sizeof string, "%s%s\t#\n", string,fCategory[i]);
    }
	Dialog_Show(playerid,DIALOG_SEL_FURN,DIALOG_STYLE_TABLIST,"# Furniture",string,"Chon","Thoat");
	    
}
CMD:furniture(playerid,params[]) {
	new choice[32];
	new houseid = PlayerInfo[playerid][pPhousekey];
	if(!IsPlayerInRangeOfPoint(playerid, 40, HouseInfo[houseid][hInteriorX], HouseInfo[houseid][hInteriorY], HouseInfo[houseid][hInteriorZ])) return SendErrorMessage(playerid, " Ban khong o trong nha cua minh");
	if(GetPlayerVirtualWorld(playerid) !=  HouseInfo[houseid][hIntVW] || GetPlayerInterior(playerid) !=  HouseInfo[houseid][hIntIW] ) return SendErrorMessage(playerid, " Ban khong o trong nha cua minh");

    if(sscanf(params, "s[32]", choice))
    {
        SendClientMessageEx(playerid, COLOR_CHAT, " {c7d5d8}USE{ffffff}: /furniture [tuy chon]");
        SendClientMessageEx(playerid, COLOR_WHITE, "{c7d5d8}OPTION{ffffff}: buy - Mua noi that cho can nha.");
        SendClientMessageEx(playerid, COLOR_WHITE, "{c7d5d8}OPTION{ffffff}: list - danh sach noi that.");
        SendClientMessageEx(playerid, COLOR_WHITE, "{c7d5d8}OPTION{ffffff}: near - xem noi that ban dang dung gan.");
        SendClientMessageEx(playerid, COLOR_WHITE, "{c7d5d8}OPTION{ffffff}: reload - reset cac object chi su dung khi bi bug.");
        return 1;
    }
     if(strcmp(choice,"reload",true) == 0) {
    	new string[3220];
    	for(new i = 0 ; i < MAX_FURNITURE; i++) {
    		if( Furniture[i][FurnitureSet] != 0 && Furniture[i][FurnitureHouse] == PlayerInfo[playerid][pPhousekey]) {
    			if(IsValidDynamicObject(Furniture[i][FurnitureObject])) DestroyDynamicObject(Furniture[i][FurnitureObject]);
    			ReloadFurniture(i);
    		}
    	}
    	Dialog_Show(playerid,DIALOG_FURNITURE_LIST,DIALOG_STYLE_TABLIST,"Furniture # List",string,"Xac nhan","Thoat");
    } 
    if(strcmp(choice,"buy",true) == 0) {
    	
	    new string[1529];
        for(new i = 0 ; i < sizeof(fCategory); i++) {
            format(string, sizeof string, "%s%s\t#\n", string,fCategory[i]);
        } 
        Dialog_Show(playerid,DIALOG_SEL_FURN,DIALOG_STYLE_TABLIST,"# Furniture",string,"Chon","Thoat"); 
    	
    }

	if(strcmp(choice,"buy2",true) == 0) {
    	
	    Dialog_Show(playerid, MAIN_BUY_F,DIALOG_STYLE_LIST,"#Furniture", "Category #1\nCategory #2\nCategory #3" ,"Chon","Thoat");
    } 
    if(strcmp(choice,"near",true) == 0) {
    	new string[229];
        for(new i = 0 ; i < MAX_FURNITURE; i++) 
        {
    		if( Furniture[i][FurnitureSet] != 0 && Furniture[i][FurnitureHouse] == PlayerInfo[playerid][pPhousekey]) 
    		{
    			if(IsPlayerInRangeOfPoint(playerid, 5, Furniture[i][FurniturePos][0], Furniture[i][FurniturePos][1], Furniture[i][FurniturePos][2])) {
    				format(string,sizeof string,"[#FURNITURE] Furniture ID: {c52323}#%d{cdc3c3} Object: {c52323}#%d{cdc3c3} khoang cach: {c52323}#%.1f{cdc3c3}",
    					i,Furniture[i][FurnitureObject],GetPlayerDistanceFromPoint(playerid, Furniture[i][FurniturePos][0], Furniture[i][FurniturePos][1], Furniture[i][FurniturePos][2]));
    			    SendClientMessageEx(playerid,COLOR_WHITE2,string);
    			}
    		}
    	}
    } 
    if(strcmp(choice,"addmin",true) == 0) {
    	Dialog_Show(playerid, DIALOG_FADD_OBJECT, DIALOG_STYLE_INPUT, "Furniture # Add Object", "Vui long nhap ID-Object cua noi that:", "> Enter", "Exit");
    } 
    if(strcmp(choice,"list",true) == 0) {
    	new string[3220];
    	for(new i = 0 ; i < MAX_FURNITURE; i++) {
    		if( Furniture[i][FurnitureSet] != 0 && Furniture[i][FurnitureHouse] == PlayerInfo[playerid][pPhousekey]) {
    			printf("%d",i);
    			new item_f = Furniture[i][FurnitureItem];
    			format(string, sizeof string, "%s%d\t#\t%s\t#%d\n", string,i,FurnitureItems[item_f][e_furnname],Furniture[i][FurnitureModelID]);

    		}
    	}
    	Dialog_Show(playerid,DIALOG_FURNITURE_LIST,DIALOG_STYLE_TABLIST,"Furniture # List",string,"Xac nhan","Thoat");
    } 
    return 1;
}
CMD:editf(playerid,params[]) {
	new choice;
    if(sscanf(params, "d", choice))
    {
        SendClientMessageEx(playerid, COLOR_CHAT, " /editfurniture [furniture ID]");
        return 1;
    }
    if(choice < 0 || choice > MAX_FURNITURE) return SendErrorMessage(playerid, " ID noi that khong hop le.");
    if(Furniture[choice][FurnitureSet] == 0) return SendErrorMessage(playerid, " ID Noi that chua duoc khoi tao.");
    if(Furniture[choice][FurnitureHouse] != PlayerInfo[playerid][pPhousekey]) return SendErrorMessage(playerid, " Noi that nay khong phai so huu cua nha ban.");
    if(!IsValidDynamicObject(Furniture[choice][FurnitureObject])) return SendErrorMessage(playerid, " Object chua duoc khoi tao.");
    EditDynamicObject(playerid, Furniture[choice][FurnitureObject]);
    SetPVarInt(playerid, #EditFurniture, 1);
    SetPVarInt(playerid, #EditFurnitureID, choice);
    return 1;
}
stock EditFurnitureFunc(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz) {
	if(GetPVarInt(playerid, #EditFurniture) && objectid == Furniture[GetPVarInt(playerid,#EditFurnitureID)][FurnitureObject] ) {
		if(response == EDIT_RESPONSE_FINAL)
	    {
			new choice = GetPVarInt(playerid,#EditFurnitureID);
			SetDynamicObjectPos(Furniture[choice][FurnitureObject], x,y,z);
		    SetDynamicObjectRot(Furniture[choice][FurnitureObject],  rx,ry,rz);

		    // if(IsValidDynamicObject(Furniture[choice][FurnitureObject])) DestroyDynamicObject(Furniture[choice][FurnitureObject]);
		    // ReloadFurniture(choice);
		    Furniture[choice][FurniturePos][0] = x;
			Furniture[choice][FurniturePos][1] = y;
			Furniture[choice][FurniturePos][2] = z;
			Furniture[choice][FurnitureRot][0] = rx;
			Furniture[choice][FurnitureRot][1] = ry;
			Furniture[choice][FurnitureRot][2] = rz;
		    DeletePVar(playerid, #EditFurniture);
		    DeletePVar(playerid, #EditFurnitureID);
		    SaveFurniture(choice);
		    return 1;
	    }
	    else if(response == EDIT_RESPONSE_CANCEL) {
	    	new choice = GetPVarInt(playerid,#EditFurnitureID);
	    	SetDynamicObjectPos(Furniture[choice][FurnitureObject],  Furniture[choice][FurniturePos][0], Furniture[choice][FurniturePos][1], Furniture[choice][FurniturePos][2]);
		    SetDynamicObjectRot(Furniture[choice][FurnitureObject],  Furniture[choice][FurnitureRot][0], Furniture[choice][FurnitureRot][1], Furniture[choice][FurnitureRot][2]);
		    // if(IsValidDynamicObject(Furniture[choice][FurnitureObject])) DestroyDynamicObject(Furniture[choice][FurnitureObject]);
		    // ReloadFurniture(choice);
	    }

	}
	return 1;
	
}

Dialog:DIALOG_FADD_OBJECT(playerid, response, listitem, inputtext[])
{
	if(response) {
		AddFurniture(playerid,strval(inputtext));
		
	}
	return 1;
}
stock AddFurniture(playerid,furn_item) {
	for(new i = 0; i < MAX_FURNITURE; i++) {
		if(Furniture[i][FurnitureSet] == 0) {
			new string[129];
			new objectid = FurnitureItems[furn_item][e_furnobj];
			format(string, sizeof(string), "# FURNITURE # Tao thanh cong %s ID: %d Object ID: %d",FurnitureItems[furn_item][e_furnname],i,objectid);
			SendClientMessageEx(playerid,COLOR_WHITE2,string);
			new Float:Pos[3];
			GetPlayerPos(playerid, Pos[0],Pos[1],Pos[2]);
			Furniture[i][FurniturePos][0] = Pos[0];
			Furniture[i][FurniturePos][1] = Pos[1];
			Furniture[i][FurniturePos][2] = Pos[2];

			
            Furniture[i][FurnitureModelID] = objectid;
            
            
			Furniture[i][FurnitureObject] = CreateDynamicObject(Furniture[i][FurnitureModelID], Furniture[i][FurniturePos][0], Furniture[i][FurniturePos][1], Furniture[i][FurniturePos][2], Furniture[i][FurnitureRot][0], Furniture[i][FurnitureRot][1], Furniture[i][FurnitureRot][2], GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
            Furniture[i][FurnitureSet] = 1;
            Furniture[i][FurnitureItem] = furn_item;
			Furniture[i][FurnitureHouse] = PlayerInfo[playerid][pPhousekey];
			

			new strupdate[1024];

	        format(strupdate, sizeof strupdate, "INSERT INTO `furnitures` (`fid`,`FurnitureSet`,`FurnitureModelID`, `FurnitureHouse`, `FurnitureItem`) VALUES ( '%d','%d','%d','%d' ,'%d' )", 
	        i, Furniture[i][FurnitureSet],Furniture[i][FurnitureModelID],Furniture[i][FurnitureHouse], Furniture[i][FurnitureItem] );
	        mysql_function_query(MainPipeline, strupdate, true, "FurnitureQueri", "i", i);
	        SaveFurniture(i);
			break ;
		}
	}
}
stock LoadFurniture()
{

	mysql_function_query(MainPipeline, "SELECT * FROM furnitures", true, "OnLoadFurnitures", "");

}
stock DeleteFurniture(playerid,i)
{
	new str[129];
	format(str, sizeof(str), "# furniture # Ban da xoa thanh cong noi that #%d.", i);
	SendClientMessage(playerid, COLOR_WHITE2, str);
	if(IsValidDynamicObject(Furniture[i][FurnitureObject])) DestroyDynamicObject(Furniture[i][FurnitureObject]);
	Furniture[i][FurniturePos][0] = 0;
	Furniture[i][FurniturePos][1] = 0;
	Furniture[i][FurniturePos][2] = 0;
    Furniture[i][FurnitureSet] = 0;
    Furniture[i][FurnitureItem] = 0;
	Furniture[i][FurnitureHouse] = 0;
	Furniture[i][FurnitureModelID] = 0;
	SQLDeleteFurniture(i);
	return 1;
}
stock SQLDeleteFurniture(i)
{
	new strupdate[1024];
	format(strupdate, sizeof strupdate, "DELETE FROM `furnitures` WHERE `fid`= %d", i);
	mysql_function_query(MainPipeline, strupdate, true, "FurnitureQueri", "i", i);
    return 1;
}

stock SaveFurniture(i)
{
	new strupdate[1024];
	format(strupdate, sizeof strupdate, "UPDATE `furnitures` SET `FurnitureItem` = '%d' , `FurnitureSet`= '%d',`FurnitureModelID`= '%d',`FurnitureHouse`= '%d' \
	, `FurniturePos0`= '%f',`FurniturePos1`= '%f',`FurniturePos2`= '%f', `FurnitureRot0`= '%f',`FurnitureRot1`= '%f',`FurnitureRot2`= '%f' WHERE `fid`=%d", 
	Furniture[i][FurnitureItem],Furniture[i][FurnitureSet],Furniture[i][FurnitureModelID],Furniture[i][FurnitureHouse], 
	Furniture[i][FurniturePos][0],Furniture[i][FurniturePos][1],Furniture[i][FurniturePos][2],
	Furniture[i][FurnitureRot][0],Furniture[i][FurnitureRot][1],Furniture[i][FurnitureRot][2],i);
	mysql_function_query(MainPipeline, strupdate, true, "FurnitureQueri", "i", i);
    return 1;
}
forward FurnitureQueri(i);
public FurnitureQueri(i)
{
}
forward OnLoadFurnitures(i);
public OnLoadFurnitures(i)
{
	new fields, szResult[64],rows,str[129];
	cache_get_data(rows, fields, MainPipeline);

    new string_log[2229];
    format(string_log, sizeof(string_log), "[%s] %d", GetLogTime()); 

    new fid;
	for(new row;row < rows;row++)
	{
		cache_get_field_content(row,  "fid", szResult, MainPipeline); fid = strval(szResult);
		cache_get_field_content(row,  "FurnitureSet", szResult, MainPipeline); Furniture[fid][FurnitureSet] = strval(szResult);
		cache_get_field_content(row,  "FurnitureModelID", szResult, MainPipeline); Furniture[fid][FurnitureModelID]  = strval(szResult);
		cache_get_field_content(row,  "FurnitureHouse", szResult, MainPipeline); Furniture[fid][FurnitureHouse]  = strval(szResult);
		cache_get_field_content(row,  "FurnitureItem", szResult, MainPipeline); Furniture[fid][FurnitureItem]  = strval(szResult);
		cache_get_field_content(row,  "FurniturePos0", szResult, MainPipeline); Furniture[fid][FurniturePos][0]  = floatstr(szResult);
		cache_get_field_content(row,  "FurniturePos1", szResult, MainPipeline); Furniture[fid][FurniturePos][1]  = floatstr(szResult);
		cache_get_field_content(row,  "FurniturePos2", szResult, MainPipeline); Furniture[fid][FurniturePos][2]  = floatstr(szResult);
		cache_get_field_content(row,  "FurnitureRot0", szResult, MainPipeline); Furniture[fid][FurnitureRot][0]  = floatstr(szResult);
		cache_get_field_content(row,  "FurnitureRot1", szResult, MainPipeline); Furniture[fid][FurnitureRot][1]  = floatstr(szResult);
		cache_get_field_content(row,  "FurnitureRot2", szResult, MainPipeline); Furniture[fid][FurnitureRot][2]  = floatstr(szResult);
		ReloadFurniture(fid);
		printf(" fid: %d,%d ",fid ,row);

	}        

}
stock ReloadFurniture(i) {
	if(Furniture[i][FurnitureSet] != 0) {
		new Float:pos[3],Float:rot[3];
		pos[0] = Furniture[i][FurniturePos][0],pos[1] = Furniture[i][FurniturePos][1],pos[2] = Furniture[i][FurniturePos][2];
		rot[0] = Furniture[i][FurnitureRot][0],rot[1] = Furniture[i][FurnitureRot][1],rot[2] = Furniture[i][FurnitureRot][2];
		new vw = HouseInfo[Furniture[i][FurnitureHouse]][hIntVW];
		new int = HouseInfo[Furniture[i][FurnitureHouse]][hIntIW];
		Furniture[i][FurnitureObject] = CreateDynamicObject(Furniture[i][FurnitureModelID], pos[0],pos[1],pos[2],rot[0],rot[1],rot[2], vw,int);
	}
}


