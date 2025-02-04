//////////////////////////////// MISC ////////////////////////////////
#define SetInterior(%0,%1) \
	SetPlayerInterior(%0,%1)

#define GetInterior(%0) \
	GetPlayerInterior(%0)

#define SetWorld(%0,%1) \
	SetPlayerVirtualWorld(%0,%1)

#define GetWorld(%0) \
	GetPlayerVirtualWorld(%0)

#define PlayerToPoint(%0,%1,%2,%3,%4) \
	IsPlayerInRangeOfPoint(%1,%0,%2,%3,%4)

#define GetName(%0) \
	PlayerInfo[%0][pUsername]

#define GetNameEx(%0) \
	PlayerInfo[%0][pUsername_]

#define GetNameWithMask(%0) \
	PlayerInfo[%0][pMaskname]

#define GetAccName(%0) \
	PlayerInfo[%0][pAccname]

//////////////////////////////////////////////////////////////////////
//////////////////////////////// TEXT DEFINES ////////////////////////

#define SCM \
	SendClientMessage

#define SCMALL \
	SendClientMessageToAll

#define SendServerMessage(%0,%1) \
	SendClientMessageEx(%0, COLOR_YELLOWMY, "MAY CHU:{FFFFFF} "%1)

#define SendSyntaxMessage(%0,%1) \
	SendClientMessageEx(%0, COLOR_SERVER2, "THONG TIN:{FFFFFF} "%1)

#define SendMedicMessage(%0,%1) \
	SendClientMessageEx(%0, 0xFF8282AA, "THONG TIN:{FFFFFF} "%1)

#define SendHelpMessage(%0,%1) \
	SendClientMessageEx(%0, COLOR_GREY, "GOI Y:{FFFFFF} "%1)

#define SendSpecialMessage(%0,%1) \
	SendClientMessageEx(%0, COLOR_YELLOWMY, "--> "%1)

#define SendErrorMessage(%0,%1) \
	SendClientMessageEx(%0, COLOR_LIGHTRED, "[ ! ]{FFFFFF} "%1)
	
#define SendWarningMessage(%0,%1) \
	SendClientMessageEx(%0, COLOR_LIGHTRED, "[ ! ]{FFFFFF} "%1)

#define SM1(%0,%1) \
	SendClientMessageEx(%0, COLOR_LIGHTRED, ">{FFFFFF} "%1)	
	
#define SM2(%0,%1) \
	SendClientMessageEx(%0, COLOR_SERVER2, ">{FFFFFF} "%1)	
	
#define SM3(%0,%1) \
	SendClientMessageEx(%0, COLOR_LIGHTRED, "-> "%1)

#define SM4(%0,%1) \
	SendClientMessageEx(%0, COLOR_WHITE, "> "%1)	

#define SendBlackMarketMessage(%0,%1) \
	SendClientMessageEx(%0, COLOR_SERVER2, "[BLACK MARKET] "%1)	
///PHONE && PAYPHONE && RADIO///
#define SendCellMessage(%0,%1) \
	SendClientMessageEx(%0, COLOR_GRAD2, "[ ! ] "%1)

#define SendPhoneMessage(%0,%1) \
	SendClientMessageEx(%0, COLOR_YELLOWG, "Nguoi la (dien thoai): "%1)

#define SendRadioMsg(%0,%1) \
	SendClientMessageEx(%0, COLOR_YELLOWMY, "Radio: "%1)

//////////////////////////////////////////////////////////////////////
/////////////////////////////////////////// ADM CMD //////////////////

#define SendAdmMessage(%0) \          
	AMSG(COLOR_LIGHTRED, "AdmCmd: "%0) 
	// Всем Админам

#define SAM \
	SendAdmMessage

#define SendAdmMessageToAll(%0) \
	SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: "%0)
	// Всем игрокам

#define SAMALL \
	SendAdmMessageToAll

#define SendAdmMessageToPlayer(%0,%1) \
	SendClientMessageEx(%0, COLOR_LIGHTRED, "AdmCmd: "%1)
	// Игроку

#define SAMPL\
	SendAdmMessageToPlayer

//////////////////////////////////////////////////////////////////////
/////////////////////////////////////////// ERRORS ///////////////////
#define SendCuffedMessage(%0)	SendClientMessageEx(%0, COLOR_LIGHTRED, "[ ! ] {FFFFFF}Ban dang bi cong tay.")
#define SendNotConnected(%0)	SendClientMessageEx(%0, COLOR_LIGHTRED, "[ ! ] {FFFFFF}Nguoi choi dang ngoai tuyen.")
#define SendNotNearPlayer(%0)	SendClientMessageEx(%0, COLOR_LIGHTRED, "[ ! ] {FFFFFF}Nguoi choi o qua xa ban.")
#define SendNotInVehicle(%0)	SendClientMessageEx(%0, COLOR_LIGHTRED, "[ ! ] {FFFFFF}Ban phai o trong xe.")
#define SendNotCash(%0)			SendClientMessageEx(%0, COLOR_LIGHTRED, "[ ! ] {FFFFFF}Ban khong co du tien.")
#define SendNotAdmin(%0)		SendClientMessageEx(%0, COLOR_LIGHTRED, "[ ! ] {FFFFFF}Ban khong co quyen su dung lenh nay.")
///////////////////////////////////////////////////////////////////////
/////////////////////////////////////////// OTHER ///////////////////

#define SendNoteMessage(%0,%1) \
	SendClientMessageEx(%0, -1, "[NOTE] "%1)

#define SendErrorRadioMessage(%0,%1) \
	SendClientMessageEx(%0, 0xAFAFAFFF, "[RADIO]:{DADADA} "%1)

#define SendFishMessage(%0,%1) \
	SendClientMessageEx(%0, -1, "[FISHING] "%1)

#define PRESSING(%0,%1) \
	(%0 & (%1))

#define HOLDING(%0) \
	((newkeys & (%0)) == (%0))

#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

#define RELEASED(%0) \
	(((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))