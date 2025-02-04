#define IsPlayerPhoneCreated(%0) PhoneInfo[%0][phoneCreated]

#define PAGE_NONE						-1
#define PAGE_HOME						0
#define PAGE_MENU_DEFAULT				1
#define PAGE_MENU_CONTACTS				2
#define PAGE_MENU_CALLS					3
#define PAGE_MENU_SMS 					4
#define PAGE_MENU_SETTINGS				5
#define PAGE_LIST_CONTACTS				6
#define PAGE_CONTACT_INFO 				7
#define PAGE_LIST_CALLS 				8
#define PAGE_LIST_SMS 					9
#define PAGE_LIST_ARCH 					10
#define PAGE_LIST_CONTACTS_FOR_CALL 	11
#define PAGE_LIST_CONTACTS_FOR_SMS		12
#define PAGE_NEW_MESSAGES 				13

#define PAGE_PHONE_STYLE 				14
#define PAGE_PHONE_MELODY 				15

#define PAGE_INCOMING_CALL 				16
#define PAGE_OUTCOMING_CALL 			17
#define PAGE_CALL						18

#define PAGE_NOTIFICATION 				19


#define MAX_PHONE_STR 24

new month_name[12][12] = {"Thang 1","Thang 2","Thang 3","Thang 4","Thang 5","Thang 6","Thang 7","Thang 8","Thang 9","Thang 10","Thang 11","Thang 12"};

enum PHONE_ENUM
{
	phoneCreated,
	phoneState,
	current_page,
	phoneCallBox
};
new PhoneInfo[MAX_PLAYERS][PHONE_ENUM];


enum PHLIST_ENUM
{
	phoneListedStr[31],
	phoneListed
};
new phListMenu[MAX_PLAYERS][MAX_PLAYER_CONTACTS][PHLIST_ENUM];

enum CONTACTS_ENUM
{
	contactID,
	contactName[24],
	contactNumber,
	contactOn
}
new PlayerContacts[MAX_PLAYERS][MAX_PLAYER_CONTACTS][CONTACTS_ENUM];

new phone_ringtons[4] = 
{
    23000,
    20804,
    20600,
    19600
};

new phone_model[] = 
{
	18868,
	18866,
	18870,
	18871,
	18873
	//18869 pink
	//18874 white
};

new phone_window[5] = 
{
    -1061109505,
    0xFFCC66FF,
    0x66B3FFFF,
	0xFFC0CBFF,
	COLOR_LIGHTGREEN // + green
};

new phone_panel[5] = 
{
    COLOR_GRAD2,//-2139062017, //1717986817,
    0xE69900FF,
    0x1A8CFFFF,
	0xF98C9FFF,
	COLOR_LIGHTGREEN // + green
};

new phone_model_color[] = 
{
	-1,			// black
 	0x68D5FFFF, //456290303,	// blue
 	0xFF325BFF, //1225921279,	// red
 	0x00FF85FF, //0x006400FF,	// dark green	
 	0xFFFF00FF	//0xFFD700FF	// dark orange
};

new phone_display_color[] =
{
	255,
	456290303,
	1225921279,
	0x024907FF, //0x215407FF
	0xB06100FF	//0xA74814FF  //0x994613FF//0xCC7B00FF
};

new phone_btns_color[] =
{
	-1717986817, //black
	-1717986817, //blue
	-1717986817, //red
	-1717986817, //green
	0x494949FF
};