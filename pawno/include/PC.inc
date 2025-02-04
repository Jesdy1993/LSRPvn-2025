/*
================================================================================
                               Phanto's Script
________________________________________________________________________________
•Script: PCaricamento         •Scripter: Phanto90
•Tipo: INC                    •Dimesione: 4 Kb
•Righe: 129                   •Versione: 1.0v
________________________________________________________________________________
                              * Descrizione *
Questo include vi permetterà di effetuare caricamenti per player modificandone
tempo e colore. (Per maggiori informazioni vedi gli screen)

Nota:
E' necessario aggiungere alla gamemode in OnGameModeInit la seguente riga:
 PCaricamentoInit();
 
E' fondamentale per il corretto funzionamento dell'include.

E' possibile anche modificare la durata inserendo il tempo in millisec tenendo
conto che sarà eseguito circa 200 volte.
Dunque se mettiamo ad esempio 50 millisec dobbiamo tenere conto che il tempo
reale di termine del caricamento sarà 50*200 millisec -> 10000 millisec.HTTP
Potrete inoltre modificare il colore del caricamento secondo le vostre esigenze.



              Grazie per aver scelto un prodotto Pawnoscripter!
                     http://pawnoscripter.forumfree.it

																	  Phanto90
________________________________________________________________________________

Vi preghiamo di non rimuovere i crediti.
================================================================================
*/
#include <a_samp>

new Text:Textdraw0;
new Text:Textdraw1;
new Text:Textdraw2[MAX_PLAYERS];
new Text:Textdraw3;
new Float:Conteggio[MAX_PLAYERS];

//==============================================================================
forward AggiornamentoCaricamento(playerid,tempo);
public AggiornamentoCaricamento(playerid,tempo)
{
 if(Conteggio[playerid]>409.0)
 {
 Conteggio[playerid]=220.0;
 TogglePlayerControllable(playerid,1);
 TextDrawHideForPlayer(playerid,Textdraw0);
 TextDrawHideForPlayer(playerid,Textdraw1);
 TextDrawHideForPlayer(playerid,Textdraw2[playerid]);
 TextDrawHideForPlayer(playerid,Textdraw3);
 return 1;
 }
 Conteggio[playerid]+=1.0;
 TextDrawTextSize(Textdraw2[playerid], Conteggio[playerid], 0.0);
 TextDrawShowForPlayer(playerid,Textdraw2[playerid]);
 SetTimerEx("AggiornamentoCaricamento",tempo,false,"dd",playerid,tempo);
 return 1;
}
//==============================================================================
stock CaricamentoForPlayer(playerid,tempo,colore)
{
 TogglePlayerControllable(playerid,0);
 TextDrawTextSize(Textdraw2[playerid], 220.0, 0.0);
 TextDrawBoxColor(Textdraw2[playerid], colore);
 TextDrawShowForPlayer(playerid,Textdraw0);
 TextDrawShowForPlayer(playerid,Textdraw1);
 TextDrawShowForPlayer(playerid,Textdraw2[playerid]);
 TextDrawShowForPlayer(playerid,Textdraw3);
 SetTimerEx("AggiornamentoCaricamento",50,false,"dd",playerid,tempo);
 return 1;
}
//==============================================================================
stock PCaricamentoInit()
{
Textdraw0 = TextDrawCreate(224.000000, 372.000000, "background");
TextDrawBackgroundColor(Textdraw0, 0);
TextDrawFont(Textdraw0, 1);
TextDrawLetterSize(Textdraw0, 0.500000, 4.299999);
TextDrawColor(Textdraw0, 0);
TextDrawSetOutline(Textdraw0, 0);
TextDrawSetProportional(Textdraw0, 1);
TextDrawSetShadow(Textdraw0, 1);
TextDrawUseBox(Textdraw0, 1);
TextDrawBoxColor(Textdraw0, 255);
TextDrawTextSize(Textdraw0, 412.000000, 0.000000);

Textdraw1 = TextDrawCreate(226.000000, 375.000000, "background");
TextDrawBackgroundColor(Textdraw1, 0);
TextDrawFont(Textdraw1, 1);
TextDrawLetterSize(Textdraw1, 0.500000, 3.700000);
TextDrawColor(Textdraw1, 0);
TextDrawSetOutline(Textdraw1, 0);
TextDrawSetProportional(Textdraw1, 1);
TextDrawSetShadow(Textdraw1, 1);
TextDrawUseBox(Textdraw1, 1);
TextDrawBoxColor(Textdraw1, 1010580680);
TextDrawTextSize(Textdraw1, 409.000000, 0.000000);

for(new i=0;i<MAX_PLAYERS;i++)
{
Textdraw2[i] = TextDrawCreate(226.000000, 375.000000, "White");
TextDrawBackgroundColor(Textdraw2[i], 0);
TextDrawFont(Textdraw2[i], 1);
TextDrawLetterSize(Textdraw2[i], 0.500000, 3.700000);
TextDrawColor(Textdraw2[i], 0);
TextDrawSetOutline(Textdraw2[i], 0);
TextDrawSetProportional(Textdraw2[i], 1);
TextDrawSetShadow(Textdraw2[i], 1);
TextDrawUseBox(Textdraw2[i], 1);
TextDrawBoxColor(Textdraw2[i], -56);
TextDrawTextSize(Textdraw2[i], 409.000000, 0.000000);

Conteggio[i]=220.0;
}

Textdraw3 = TextDrawCreate(285.000000, 349.000000, "Loading...");
TextDrawBackgroundColor(Textdraw3, 255);
TextDrawFont(Textdraw3, 0);
TextDrawLetterSize(Textdraw3, 0.529999, 2.599999);
TextDrawColor(Textdraw3, -1);
TextDrawSetOutline(Textdraw3, 0);
TextDrawSetProportional(Textdraw3, 1);
TextDrawSetShadow(Textdraw3, 1);
} 