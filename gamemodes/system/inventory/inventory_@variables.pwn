
#define MAX_SLOT_INVENTORY 16 * 2
#define MAX_ITEM_INVENTORY 16 * 2
#define INVENTORY_MAX_PAGE 2
#define MAX_SPAM_OBJECT 100
new PlayerInventoryItem[MAX_PLAYERS][MAX_SLOT_INVENTORY];
new PlayerInventoryAmount[MAX_PLAYERS][MAX_SLOT_INVENTORY];
enum ItemSpam {
	@ItemObjectID,
   @ItemObject,
   @ItemID,
   @ItemAmount,
   Float:@ItemPostion[3],
   Text3D:@ItemText
}
new ObjectInv[MAX_SPAM_OBJECT][ItemSpam];

enum Item_@Str {
	ItemID,
	ItemMaxAmount,
	ItemObject,
	ItemName[52],
	ItemInfor[125],

}
new ItemInfo[][Item_@Str] = {
	{0,1,19804,"Empty",""},
	{1,1,0,"Empty",""},
	{2,1,18874,"Dien thoai","Vat pham dien thoai dung de lien lac"},
	{3,1,330,"GPS","Vat pham GPS dung de dinh vi, tim duong v.v"},
	{4,5,19896,"Thuoc la","Dung de hut thuoc"},
	{5,1,19804,"Khoa xe","Khoa xe dien tu, dung de lap dat cho xe, chong trom"},
	{6,1,2680,"Khoa xe 2","Khoa xe thuong, dung de lap dat cho xe, chong trom"},
	{7,1,19776,"Bang lai xe","Dung de xac thuc trinh do lai xe"},
	{8,1,1581,"ID Card","Mot the gan chip chua thong tin ca nhan cua ban"},
	{9,1,19792,"The ATM","The ATM dung de giao dich tai cac quay ATM hoac ngan hang"},
	{10,10,19579,"Banh mi","Su dung de an, giup ban no bung hon"},
	{11,50,2703,"Hambuger","Su dung de an, giup ban no bung hon"},
	{12,50,19580,"Pizza","Su dung de an, giup ban no bung hon"},
	{13,50,1666,"Ca phe sua","Thuc uong, su dung giup giai khat"},
	{14,50,2601,"Ca phe sua","Thuc uong, su dung giup giai khat"},
	{15,10,2601,"Thoi sat","Dung lam nguyen lieu cho che tao dan, vu khi"},
	{16,10,2601,"Thoi dong","Dung lam nguyen lieu de che tao dan, vu khi"},
	{17,10,2601,"Thoi bac","Dung lam nguyen lieu de che tao dan, vu khi"},
	{18,10,2601,"Thoi vang","Dung de giao dich, buon ban, che tao trang suc"},
	{19,10,365,"Spraycan","Dung de son len tuong"},
	{20,100,19793,"Wood","Dung de ban va che tao noi that"},


	// wweapons lục
	{21,1,346,"Colt-45","Sung Colt-45"}, // id wp: 22
	{22,1,346,"Silenced 9mm","Silenced 9mm"}, // 23
	{23,1,348,"Desert Eagle","Desert Eagle"}, // id wp 24

	{24,1,349,"Shotgun","Shotgun"}, // id wp 25
	{25,1,351,"Combat Shotgun","Combat Shotgun"}, // 27

	{26,1,352,"Micro SMG/Uzi","Micro SMG/Uzi"}, // 28
	{27,1,353,"MP5","MP5"}, // 29
	
	{28,1,355,"AK-47","AK-47"}, // 30.
	{29,1,356,"M4","M4"},

	// ammo sung luc
	{30,100,19995,"Dan sung luc","Dan danh cho cac loai sung Sdpistol, Deagle, Colt-45"},
	// ammo shotgun
	{31,100,19995,"Dan shotgun","Dan danh cho cac loai sung Combat shotgun, Shotgun"},
	// ammo MP
	{32,100,19995,"Dan tieu lien","Dan danh cho cac loai sung MP5,Uzi,Tec"},
	// ammo sung truong
	{33,100,19995,"Dan sung truong","Dan danh cho cac loai sung M4,AK47"},

	// 34 35
	{34,50,2601,"Lon nuoc Sprite","Lon nuoc ngot"},
	{35,50,19822,"Chai bia","Chai bia"},
	{36,5,19918,"Dung cu sua xe","Dung cu sua xe"},
	{37,10,18911,"Mat na","Mat na"},
	{38,10,1650,"Binh xang","Binh xang"},
	{39,10,1579,"Codein","Codein"},
	{40,30,2958,"Purple Lean","Purple Lean"}


	 // 31
};


/*
list vũ khí hiện tại
Colt-45 ID: 22 - Model: 346
Silenced 9mm ID: 23 - Model: 347
Desert Eagle ID: 24 - Model: 348

Shotgun ID 25 Model 349
Combat Shotgun	27 Model 351

Micro SMG/Uzi 28 model 352
MP5 ID: 29 Model 353

AK-47 30 Model 355
m4 31 model 356
*/
/* LIST ITEM


   Thuốc lá: 
   Khóa xe 1:
   Khóa xe 2:
   Vũ khí cận chiến 
   Điện thoại
   thẻ ATM
   ID-card


*/