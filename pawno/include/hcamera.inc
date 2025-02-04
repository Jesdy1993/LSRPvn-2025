// Mini include by hustrine. :)
// version 0.1 :)


#include    <  a_samp  >

stock firstPerson( playerid )
{
	new
	    objektas[ MAX_PLAYERS ]
	;
	objektas[ playerid ] = CreateObject( 19300, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0 );
	AttachObjectToPlayer( objektas[ playerid ], playerid, 0.0, 0.3, 0.7, 0, 0, 0 );
	AttachCameraToObject( playerid, objektas[ playerid ] );
	return objektas;
}

stock setCamera( playerid, on=0 )
{
	switch( on )
	{
	    case 0: firstPerson( playerid );
	    case 1: SetCameraBehindPlayer( playerid );
	}
}
