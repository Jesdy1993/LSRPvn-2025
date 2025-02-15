
#include <YSI\y_hooks>

hook OnPlayerConnect(playerid) {
	// PNJ
	RemoveBuildingForPlayer(playerid, 16359, 821.406, 862.078, 11.039, 0.250);
    RemoveBuildingForPlayer(playerid, 13066, 165.007, -35.648, 6.171, 0.250);
    RemoveBuildingForPlayer(playerid, 13067, 165.007, -35.648, 6.171, 0.250);
    RemoveBuildingForPlayer(playerid, 13077, 272.804, -239.046, 5.578, 0.250);
    RemoveBuildingForPlayer(playerid, 13079, 272.804, -239.046, 5.578, 0.250);
    RemoveBuildingForPlayer(playerid, 13065, 210.296, 20.476, -0.429, 0.250);
    RemoveBuildingForPlayer(playerid, 13068, 210.296, 20.476, -0.429, 0.250);
    RemoveBuildingForPlayer(playerid, 12941, 207.804, -46.843, 0.578, 0.250);
    RemoveBuildingForPlayer(playerid, 13069, 207.804, -46.843, 0.578, 0.250);
    RemoveBuildingForPlayer(playerid, 13190, 308.093, -168.727, 4.367, 0.250);
    RemoveBuildingForPlayer(playerid, 13203, 308.093, -168.727, 4.367, 0.250);
    RemoveBuildingForPlayer(playerid, 1294, 291.156, -171.500, 5.031, 0.250);
}

hook OnGameModeInit() {
	// PNJ
    new tmpobjid;
    tmpobjid = CreateDynamicObject(10831, 307.427886, -168.543060, 5.518121, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "ws_carpark2", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 10101, "2notherbuildsfe", "flatdoor01_law", 0x00000000);
    tmpobjid = CreateDynamicObject(19325, 321.070434, -178.875808, 4.258124, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 19962, "samproadsigns", "workzonesign", 0x00000000);
    tmpobjid = CreateDynamicObject(18764, 312.409179, -176.590148, -0.741875, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "metpat64", 0x00000000);
    tmpobjid = CreateDynamicObject(905, 311.126159, -175.475357, 1.958125, 0.000000, 0.000000, -102.099975, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 12870, "ce_ground03", "desclifftypebs", 0x00000000);
    tmpobjid = CreateDynamicObject(905, 313.342803, -178.290969, 1.986698, -16.499998, 0.000000, 35.000022, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 12870, "ce_ground03", "desmudtrail", 0x00000000);
    tmpobjid = CreateDynamicObject(2359, 314.128692, -178.349411, 1.968124, 0.000000, 0.000000, -116.100013, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 19071, "wssections", "wood1", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19071, "wssections", "wood1", 0x00000000);
    tmpobjid = CreateDynamicObject(2438, 312.562255, -176.497665, 2.748125, 540.000000, 180.000000, 87.099990, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 1, 3080, "adjumpx", "gen_chrome", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 16640, "a51", "a51_panels1", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 16640, "a51", "dam_gencon", 0x00000000);
    tmpobjid = CreateDynamicObject(18764, 301.429138, -176.590148, -0.741875, 0.000000, 0.000007, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "metpat64", 0x00000000);
    tmpobjid = CreateDynamicObject(905, 300.146118, -175.475357, 1.958125, -0.000007, -0.000001, -102.099952, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 12870, "ce_ground03", "desclifftypebs", 0x00000000);
    tmpobjid = CreateDynamicObject(905, 302.362762, -178.290969, 1.986698, -16.499992, 0.000006, 35.000015, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 12870, "ce_ground03", "desmudtrail", 0x00000000);
    tmpobjid = CreateDynamicObject(2359, 303.148651, -178.349411, 1.968124, -0.000006, -0.000003, -116.099990, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 19071, "wssections", "wood1", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19071, "wssections", "wood1", 0x00000000);
    tmpobjid = CreateDynamicObject(2438, 301.582214, -176.497665, 2.748125, 0.000000, 360.000000, -92.900016, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 1, 3080, "adjumpx", "gen_chrome", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 16640, "a51", "a51_panels1", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 16640, "a51", "dam_gencon", 0x00000000);
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    tmpobjid = CreateDynamicObject(18259, 828.762329, 890.094848, 13.775829, 0.000000, 0.000000, 99.599998, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(944, 834.552124, 887.439208, 14.741766, 0.000000, 0.000000, 12.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2670, 831.519592, 890.581970, 13.941762, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(905, 823.439697, 884.508422, 14.201766, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1728, 825.144409, 893.372741, 13.861766, 0.000000, 0.000000, 12.999998, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2237, 824.716979, 893.272888, 14.921573, -15.800001, 0.000000, -80.300003, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19631, 824.410400, 885.282775, 13.886448, 0.899999, -91.100036, -25.299999, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19631, 823.543395, 886.193481, 13.886323, 0.899999, -91.100036, 4.100008, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19631, 824.099975, 885.721557, 13.918166, 2.500017, -91.100036, -130.299896, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19626, 826.847534, 884.964477, 14.647152, -11.699999, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1441, 822.326171, 881.544555, 12.785875, 0.000000, 0.000000, -64.700004, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1415, 840.493103, 885.436462, 12.371562, 0.000000, 0.000000, 102.399971, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1812, 834.269226, 895.141845, 13.861766, 0.000000, 0.000000, -78.800003, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(13066, 165.007995, -35.648399, 6.171875, 0.000000, 0.000000, -89.999992, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(13077, 272.804992, -239.046997, 5.578125, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(13065, 210.296997, 20.476600, -0.429688, 0.000000, 0.000000, 0.102608, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(12941, 207.804992, -46.843799, 0.578125, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1294, 291.105102, -178.959793, 5.031250, 0.000000, 0.000000, -0.390942, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(939, 296.642456, -156.133865, 3.058124, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(939, 302.232330, -156.133865, 3.058124, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(939, 307.772277, -156.133865, 3.058124, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(3384, 318.852691, -181.830932, 1.948125, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(3384, 311.132720, -181.830932, 1.948125, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(3384, 303.242736, -181.830932, 1.948125, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(3788, 308.864990, -158.965438, 1.068125, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(905, 309.253356, -158.876327, 1.178125, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(3396, 320.473205, -158.446578, 0.608125, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(905, 311.138336, -177.591949, 1.958125, 0.000000, 0.000000, -39.999973, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(3931, 313.558349, -175.354690, 1.762137, 0.000000, 112.200019, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(18635, 314.102996, -177.331344, 1.738125, 90.000000, -61.800022, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(18635, 310.464630, -176.048156, 1.738125, 90.000000, -134.499984, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19631, 310.969757, -178.144577, 1.905605, -162.600006, 73.999977, -31.200004, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(3788, 309.108642, -180.306274, 1.068125, 0.000000, 0.000007, -24.700006, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(905, 309.498718, -180.387603, 1.178125, 0.000007, 0.000000, 65.299980, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(905, 300.158294, -177.591949, 1.958125, -0.000004, 0.000005, -39.999973, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(3931, 302.578308, -175.354690, 1.762137, 0.000000, 112.200027, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(18635, 303.122955, -177.331344, 1.738125, 89.999992, 28.199970, -89.999992, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19631, 299.989715, -178.144577, 1.905605, -17.399993, 253.999969, 148.799987, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1358, 319.761077, -171.604156, 1.778125, 0.000000, 0.000000, 90.600006, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1728, 314.165618, -155.090164, 0.498125, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1438, 319.420318, -162.015411, 0.578125, 0.000000, 0.000000, -92.000015, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(11713, 293.710754, -161.450195, 2.468125, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1663, 319.152252, -158.042495, 1.038125, 0.000000, 0.000000, 38.599998, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19815, 307.356628, -182.625656, 2.508125, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19903, 297.762786, -179.185241, 0.578125, 0.000000, 0.000000, 51.099994, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1438, 294.857147, -176.558868, 0.578125, 0.000000, 0.000000, 86.899986, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1438, 295.049591, -179.660018, 0.578125, 0.000000, 0.000000, 89.099967, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19904, 318.010559, -154.773757, 2.248124, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19904, 318.650573, -154.773757, 2.248124, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19904, 319.270538, -154.773757, 2.248124, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(11729, 320.817749, -155.588836, 0.558125, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2671, 315.222686, -158.290328, 0.578125, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(2670, 314.869995, -173.652679, 0.668124, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19868, 296.769500, -151.892837, 0.578125, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19868, 301.999511, -151.892837, 0.578125, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19868, 307.219421, -151.892837, 0.578125, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19868, 312.449462, -151.892837, 0.578125, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19868, 317.659454, -151.892837, 0.578125, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19868, 320.209472, -151.892837, 0.578125, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19868, 322.699371, -154.402786, 0.578125, 0.000000, 0.000000, 450.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19868, 322.699371, -159.602783, 0.578125, 0.000000, 0.000000, 450.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19868, 322.699371, -164.832809, 0.578125, 0.000000, 0.000000, 450.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19868, 322.699371, -170.062789, 0.578125, 0.000000, 0.000000, 450.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19868, 322.699371, -175.262756, 0.578125, 0.000000, 0.000000, 450.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19868, 322.699371, -180.472793, 0.578125, 0.000000, 0.000000, 450.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19868, 322.699371, -183.502868, 0.578125, 0.000000, 0.000000, 450.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19868, 302.969787, -186.102783, 0.578125, 0.000000, 0.000000, 720.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19868, 308.159912, -186.102783, 0.578125, 0.000000, 0.000000, 720.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19868, 313.350006, -186.102783, 0.578125, 0.000000, 0.000000, 720.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19868, 318.549987, -186.102783, 0.578125, 0.000000, 0.000000, 720.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19868, 320.110137, -186.102783, 0.578125, 0.000000, 0.000000, 720.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1331, 317.651306, -185.365066, 1.438125, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1440, 315.380554, -185.272247, 0.998125, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1338, 294.409179, -159.015930, 1.238125, 0.000000, 0.000000, 85.099990, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(1338, 295.698944, -157.963256, 1.238125, 0.000000, 0.000000, 10.499998, -1, -1, -1, 300.00, 300.00); 

}