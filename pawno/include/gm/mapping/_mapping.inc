///////////////////////////////////////
/////////	INTERIORS	///////////////
///////////////////////////////////////
#include <gm/mapping/interiors.inc>
///////////////////////////////////////
///////////////////////////////////////

///////////////////////////////////////
/////////	EXTERIORS	///////////////
///////////////////////////////////////
#include <gm/mapping/exteriors.inc>
///////////////////////////////////////
///////////////////////////////////////


Map_OnGameModeInit()
{
    Interiors_OnGameModeInitZ();
	Exteriors_OnGameModeInit();
    StreamerSettings();
    return 1;
}

Mapping_OnPlayerConnect(playerid) 
{
	Exteriors_OnPlayerConnect(playerid);
	return 1;
}

#define OTHER_OBJECT_STREAMER	30.0
StreamerSettings() 
{
	new slot;
	for( new o; o < Streamer_CountItems( STREAMER_TYPE_OBJECT ); o++ ) 
	{
		if (!IsValidDynamicObject(o)) continue;

		switch( Streamer_GetIntData( STREAMER_TYPE_OBJECT, o, E_STREAMER_MODEL_ID ) ) 
		{
			case 849, 850, 851, 852, 853, 854, 1220, 1221, 
				1264, 1265, 1328, 1449, 1455, 1484, 1485, 1486, 1487, 1509, 1510, 1512, 1517, 1520, 
				1543, 1544, 1546, 1551, 1664, 1665, 1667, 1668, 1669, 1672, 1886, 2055, 2056, 2057, 
				2059, 2102, 2103, 2114, 2221, 2222, 2223, 2342, 2345, 2353, 2354, 2355, 2384, 2386, 
				2396, 2397, 2398, 2399, 2401, 2611, 2612, 2615, 2619, 2670, 2671, 2672, 2673, 2674, 
				2675, 2676, 2677, 2690, 2812, 2814, 2816, 2819, 2820, 2821, 2823, 2824, 2825, 2826, 
				2827, 2829, 2830, 2831, 2832, 2684, 2685, 2686, 2687, 2702, 2703, 2726, 2749, 2750, 
				2751, 2752, 2753, 2767, 2768, 2769, 2828, 2856, 2857, 2858, 2859, 2860, 2861, 2866, 
				2867, 2894, 2913, 2915, 2916, 3042, 3675, 9831, 10984, 11707, 11745, 14842, 19792, 
				19804, 19808, 19807, 19811, 19813, 19814, 19818, 19819, 19820, 19821, 19822, 19823, 
				19824, 19826, 19827, 19828, 19829, 19835, 19836, 19847, 19873, 19874, 19883, 19892, 
				19893, 19896, 19897, 19898 : 
			{
				Streamer_SetFloatData( STREAMER_TYPE_OBJECT, o, E_STREAMER_DRAW_DISTANCE, OTHER_OBJECT_STREAMER );
				slot++;
			}
		}
	}
	
	printf( "[Streamer]: Objects are optimized. Total - %d", slot );
	
	return 1;
}
