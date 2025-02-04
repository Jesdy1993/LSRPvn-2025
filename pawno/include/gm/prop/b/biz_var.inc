new biz_prod_types[22] =
	{-1, 2, 23, 21, 3, -1, 0, 11, -1, 4, 4, 4, 12, 15, -1, 1, 1, 1, 1, 1, 22, -1};
	
new biz_prod_point[22] =
	{0, 5, 5, 10, 5, 0, 10, 3, 0, 3, 3, 3, 10, 20, 0, 5, 5, 5, 5, 5, 10, 0};

#define MAX_BIZ_TYPES 26
new biz_types[MAX_BIZ_TYPES][120] = {
    "Khac",
    "Bar / Club",
    "Cua hang 24/7",
    "Cua hang vu khi",
    "Clothing store",
    "Tiem hot toc",
    "Cay xang",
    "Cua hang sua chua o to",
    "Ngan hang",
    "Dai ly xe hoi",
    "Dai ly thuyen",
    "Dai ly may bay",
    "Tiem sua chua",
    "Cong ty quang cao",
    "Giay phep",
    "Well Stacked Pizza",
    "Cluckin Bell",
    "Burger Shot",
    "Rusty Brown's Ring Donuts",
    "Nha hang",
    "Construction company",
    "Pharmacy",
    "Pawnshop",
    "Cua hang dien thoai",
    // "Warehouse",
    //"Laundry",
    "Hypermarket",
    "Toys Store"
};

#define LIMIT_MAX_PRODUCTS (12)
new const max_product[] =
	{4, 4, 4, 3, 12, 8, 12};

new const name_order[][][32] =
{
    /*
    {1579, ITEM_TYPE_REACT, 				ITEM_SIZE_MEDIUM, 	"������������ �������",		0,1,1, 108},
    {1579, ITEM_TYPE_REACT, 				ITEM_SIZE_MEDIUM, 	"�������",        	   		0,1,1, 112},
    */
    {"Buster", "Double D-Luxe", "Full Rack", "Salad Meal", "Trong", "Trong", "Trong", "Trong", "Trong", "Trong", "Trong", "Trong"},
    {"Clukin' Little Meal", "Clukin' Big Meal", "Clukin' Huge Meal", "Salad Meal", "Trong", "Trong", "Trong", "Trong", "Trong", "Trong", "Trong", "Trong"},
    {"Moo Kids Meal", "Beef Tower", "Meat Stack", "Salad Meal", "Trong", "Trong", "Trong", "Trong", "Trong", "Trong", "Trong", "Trong"},
    {"Small portion", "Medium portion", "Large portion", "Trong", "Trong", "Trong", "Trong", "Trong", "Trong", "Trong", "Trong", "Trong"},
    {"The SIM", "Bo dam", "Mat na", "Bat lua", "Thuoc la", "Xuc xac", "Binh Xang", "But", "Playing cards", "May anh", "Nhan dan xe", " Hoa "},
    {"Beer", "Vodka", "Cola", "Nuoc khoang", "Whiskey", "Brandy", "Soda", "Wine", "Trong", "Trong", "Trong", "Trong"},
    {"Can sa y te", "Bo so cuu", "Photpho do", "Methylbenzyl xeton", "Methylamine", "Heliotropin", "Ephedrine", "Mineral chameleon", "Chloroform", "Ether", "Hydrogen chloride", "Methanol"}
};

new const model_order[7][12] =
{
    {2218, 2219, 2220, 2355, 0, 0, 0, 0, 0, 0, 0, 0},
    {2215, 2216, 2217, 2353, 0, 0, 0, 0, 0, 0, 0, 0},
    {2213, 2214, 2212, 2354, 0, 0, 0, 0, 0, 0, 0, 0},
    {2221, 2223, 2222, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {19792, 19942, 19801, 19998, 19897, 1906, 1650, 3027, 11748, 367, 2656, 325}, // -sim -���� -INV_CARSOUND -
    {2958, 1668, 1546, 1455, 1520, 19820, 19346, 1664, 0, 0, 0, 0},
    {1578, 11736, 2709, 2709, 2709, 2709, 2709, 2709, 2709, 2709, 2709, 2709}
};

new const biz_prices[7][12] =
{
    {100, 100, 200, 300, 0, 0, 0, 0, 0, 0, 0, 0},
    {100, 100, 200, 300, 0, 0, 0, 0, 0, 0, 0, 0},
    {100, 100, 200, 300, 0, 0, 0, 0, 0, 0, 0, 0},
    {100, 100, 200, 300, 0, 0, 0, 0, 0, 0, 0, 0},
    {300, 500, 1500, 50, 100, 100, 1000, 50, 100, 1500, 3000, 150},
    {100, 200, 100, 50, 300, 500, 100, 300, 0, 0, 0, 0},
    {1000, 1500, 1000, 1000, 1500, 1000, 1500, 1000, 1000, 1000, 2000, 1500}
};