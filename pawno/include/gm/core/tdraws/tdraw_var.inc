new PlayerText:spectate_TD[MAX_PLAYERS][2];

//new PlayerText: drug_effect[MAX_PLAYERS];

new Text: TD_vehicle_info[2];
new PlayerText: TD_vehicle_name[MAX_PLAYERS];

new Text: TD_restaurant[4];
new PlayerText: TD_restaurant_prod[MAX_PLAYERS][8]; //0-3 - название блюд, 4 - 7 - картинки


/* LABELS */

new Text:LableDraw[MAX_PLAYERS];
new Text:UsedDraw[MAX_PLAYERS];
new Text:TDEditor_TD[MAX_PLAYERS];

//new Text:errormsg[MAX_PLAYERS];
new PlayerText:TD_job_message[MAX_PLAYERS];
new Text:infotxt[MAX_PLAYERS];

new Text: zond_cam[11];

/////////////////////////////////////////////////////////////SPEED
enum SPEEDOMETR_DATA
{
	speedFont,
	Float:speedX,
    Float:speedY,
	Float:speedLX,
    Float:speedLY
};


new const speedSettings[4][SPEEDOMETR_DATA] =
{
// FONT         CORDS                   LetterSize      
    {1,     497.9165, 105.4813,     0.3199, 1.2999}, //сверху 1 фонт
    {1,     497.9165, 387.4053,     0.3199, 1.2999}, //снизу 1 фонт
    {2,     497.9165, 105.4813,     0.2899, 1.3500},
    {2,     497.9165, 387.4053,     0.2899, 1.3500}
};

new PlayerText:SpeedText[MAX_PLAYERS];
new PlayerText:FuelText[MAX_PLAYERS];