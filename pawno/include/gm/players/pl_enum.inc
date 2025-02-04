enum PLAYER_DATA_ENUM
{
	pUsername[MAX_PLAYER_NAME+1],
	pUsername_[MAX_PLAYER_NAME+1],
    pMaskname[32],
    pGoogle[17],
	pSlot1,
	pSlot2,
	pSlot3,
	pID,
	pAccID,
	pAccname[MAX_PLAYER_NAME+1],
	pCash,
	pBank,
	pSkin,
	pSex,
	pBirthdate[24],
	pAge,
	pAppearance[168],
	pLevel,
	//pExp,
	pHours,
	pAdmin,
	pAdminCode[MAX_HASH_LENGTH],
	pAdminHide,
	pHelper,
	pInt,
	pWorld,

	pDrugLabAccess,

	pAJailed,
	pAJailTime,

	pJailed,
	pIsolateTime,
	pJailTime,
	pWarns,

	pPremium,
	pPremiumTime,
	pDonate,
	pNameChanges,
	pNumberChanges,
	
	pCarLic,
	pWepLic,
	pFlyLic,
	pTaxiLic,
	pPrescribe,
	pGanjaTime,
	pFightStyle,
	pHud,
	pPayCheckMoney,
	pPayDayTime,
	pSavings,
	pRentKey,
	pRentPrice,
	pChannel,
	pOwnedChannel,
	pAuthed,
	pCarKey,
	pSpareKey,
	pWorkOn,
	pWalk,
	Float:pArmour,
	pFaction,
	pRank,
	pBadgeNumber,
	pDriveWarns,
	pWepWarns,
	pWepCount,
	pArrested,
	pTalk,
	pAuthwep,
	pSwat,
	pSwatDuty,
	pSlot,
	pJob,
	pCareer,
	pSideJob,
	pSpawnType,
	pSpawnPoint,
	pPrisoned,
	pInjured,
	pDeathReason,
	pOnDuty,
	pChar,
	
	//pWeap[MAX_WEAP],
	//pAmmo[MAX_WEAP],
	//pAmmoType[MAX_WEAP],
    pHideWeap[MAX_WEAP-1],

	pCopItem[MAX_INV_SLOTS],
	pCopQ[MAX_INV_SLOTS],
	pCopEx[MAX_INV_SLOTS],
	pCopS[MAX_INV_SLOTS],

	pFishCount,
	pWeaponBone[3],
	Float:pWeaponX[3],
    Float:pWeaponY[3],
    Float:pWeaponZ[3],
    Float:pWeaponRX[3],
    Float:pWeaponRY[3],
    Float:pWeaponRZ[3],
	pMutedTime,
	Float:pPosX,
	Float:pPosY,
	Float:pPosZ,
	Float:pPosA,
	Float:pLocationPos[3],
	pTog[3],
	
	pNumber,
	pPhoneAirplane,
	pPhoneSound,
	pPhoneStyle,
	pPhoneOff,
	pPhoneModel,
	pPhoneRingtone,

	pLastPrim,
	pLastSec,
	pLastMelee,

	pPlayerWeapon,
    pPlayerAmmo,
	pAmmoType,
	pWepSerial,
	pPlayerSerial,

	InMission,
	MissionTime,
	MissionTarget[2],
	MissionReward,
	
	pForbid,

	pDescribe[PAME_MAX_LEN],
	pDescribe2[PAME_MAX_LEN],
	
    pFishRod,
	pBait,
	pFish[MAX_FISH_SLOT],

	pSettings,
	pDependence,
	pDemolition,
	pFishTime,
	pMark[MAX_PLAYER_MARKS],
	pTutorial
}
new PlayerInfo[MAX_PLAYERS][PLAYER_DATA_ENUM];

enum ENUM_INVENTORY
{
	//pInvID,
	//pInvType,
	pInvItem,
	pInvQ,
	pInvEx,
	pInvS,
	Float:pInvQFloat,
	pInvName[16]
}
new Inventory[MAX_PLAYERS][MAX_INV_SLOTS][ENUM_INVENTORY];
new CarInventory[MAX_VEHICLES][MAX_CAR_INVENTORY][ENUM_INVENTORY];
new TrunkInventory[MAX_VEHICLES][MAX_TRUNK_INVENTORY][ENUM_INVENTORY];
new HouseInventory[MAX_HOUSES][MAX_HOUSE_INVENTORY][ENUM_INVENTORY];

enum PLAYER_TEMP_ENUM
{
	pLogged,
	pLoggedTime,
	pLoggedTry,
	pLoggedScreen,
	pPMPlayer,
	pHealPlayer,
	pFactionPlayer,
	pInterview,
	pInterviewPlayer,
	pRentPlayer,
	pRentPrice,
	pWepPlayer,
	pWepPrice,
	pHouseHouse,
	pHousePrice,
	pHousePlayer,
	pBizPlayer,
	pBizPrice,
	pBizID,
	pFriskPlayer,
	pSpecPlayer,
	pHirePlayer,
	pTaser,
	pTaserTime,
	pFreezeTime,
	Float:pInvulnerable,
	pEditBort,
	pCCTV,
	pZond,
	pZondActor,
	pZondObj,
	Text3D:pZondLabel,
	pDarkAFK,
	pFlashTime,
	pCarPrice,
	pCarPlayer,
	pFurniture,
	pFurnitureB,
	p3DMenu,
	pHealTime,
	pBuildHouse,
	pRamType,
    pRamTime,
    pRamHouse,
	pRamGarage,
	pRamVeh,
    pRamBiz,
    pRamObj,
    pInjuredLegTime,
    pInjuredTime,
	pHelpUp3dText,
    pDamagesCount,
    pCallLine,
    pCallStatus,
    pCallIncoming,
	pCallTime,
	pCallName[26],

	pJob,
	pJobTime,

	pUnscrambleID,
	pScrambleFailed,
	pScrambleSuccess,

	//JackingTime,
	//JackingVehID,
	//JackingCP,

	JackingType,
	JackingWarnings,
	
	pEmergency,
    pTracePlayer,
    pTraceGZ,
    pTraceStage,
    Float:pTraceDist[3],
    pDialogList,
    pDriver,
    pCargoID,
	pCargoListed[MAX_TRUCK_PRODUCT],
	pWeaponListed[30],
	pListed[5],
	pWaypoint,
	pPDAListed[MAX_TRUCK_CARGO],
	pMDCPlayer,
	pPatrol,

	pPoliceCalls,
	pPoliceJails,
	pPoliceFines,

	pCallOn,
	Float:pCallPosX,
	Float:pCallPosY,
	Float:pCallPosZ,
    pFishTime,
    
	Float:editPos[6],

	pPlantTime,
	pPlantType,

	pFireTime,

    pCuffed,
	pNews,
	pHouseEntered,
	pBizEntered,
	pApartEntered,
	pDMLog,

	pGreetPlayer,
	pGreetType,
	pFoodStand,
	pReportTime,
	pServePlayer,
	pServeType,
	pAdminDuty,
	pTesterDuty,
	pBoombox,
	pBoombox_house,
	pBoombox_biz,
	pRentveh,
	pLicenseExam,
	pMDCWepPlayer,
	pMDCWepName[MAX_PLAYER_NAME+1],
	
	pDrugUse,
	pDrugTime,
	pDrugChgWeather,
    pDemolitionTime,
    pChangeNick[MAX_PLAYER_NAME+1],
	pGoogle[17],
	pPizzaBoy,
	pInteriorObj,
	pInteriorID,
	pInteriorHouse,
	pInteriorBiz,

	MyCarSpawn[5],
	MyCars[5],
	
	pPayphoneNumStr[10],
	pPayphone,

	tempItem,
	tempEx,
	tempQ,

	tempStatus,

	UsingCorpse,
	UsingBort,
	pNotAndroid,
	pPoolTable,
	pAiming,
	pPlayingPool,
	pSpamTime,
	pInHospitalBed,
	pHospitalBed,

	pVendingVending,
	pVendingPrice,
	pVendingPlayer,

	pRegisterScreen,
	pCharacterScreen,
	pVehicleScreen,
	pUsingPayphone
}

new pTemp[MAX_PLAYERS][PLAYER_TEMP_ENUM];


new RefuelTimer[MAX_PLAYERS] = {-1, ...},
	Text3D:status_upd[MAX_PLAYERS];


enum (<<= 1)
{
	togName = 1, // +
	togOOC, // +
	togJoin, // +
	togAdv, // +
	togGov, // +
	togPM, // +
	togAdmCmds, // +
	togNews, // +
	togAFK, // +
	togHUD, // +
	togFaction, // +
	togTester, 
	togEnter, // +
	togService
}

new Text3D:CustomNametag[MAX_PLAYERS];