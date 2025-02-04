//Map Exported with Texture Studio By: [uL]Pottus, Crayder, Svyatoy, encoder, devhub/////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Map Information////////////////////////////////////////////////////////////////////////////////////////////////
/*
	Exported on "2020-07-19 13:24:57" by "samperas"
	Created by "samperas"
*/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Remove Buildings///////////////////////////////////////////////////////////////////////////////////////////////
Train_OnPlayerConnect(playerid)
{
	RemoveBuildingForPlayer(playerid, 12859, 173.516, -323.820, 0.515, 0.250);
	RemoveBuildingForPlayer(playerid, 13193, 173.516, -323.820, 0.515, 0.250);
	return 1;
}

Train_OnGameModeInit()
{
	new tmpobjid;
	tmpobjid = CreateDynamicObject(19445, 173.554260, -284.582458, 2.396725, 0.000000, 0.000022, 0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 12944, "ce_bankalley2", "newall5-2", 0x00000000);
	tmpobjid = CreateDynamicObject(19445, 173.554260, -294.192474, 2.396725, 0.000000, 0.000022, 0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 12944, "ce_bankalley2", "newall5-2", 0x00000000);
	tmpobjid = CreateDynamicObject(19445, 173.554260, -303.822509, 2.396725, 0.000000, 0.000022, 0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 12944, "ce_bankalley2", "newall5-2", 0x00000000);
	tmpobjid = CreateDynamicObject(19445, 173.554260, -313.402404, 2.396725, 0.000000, 0.000022, 0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 12944, "ce_bankalley2", "newall5-2", 0x00000000);
	tmpobjid = CreateDynamicObject(19445, 173.554260, -322.942352, 2.396725, 0.000000, 0.000022, 0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 12944, "ce_bankalley2", "newall5-2", 0x00000000);
	tmpobjid = CreateDynamicObject(19445, 173.554260, -332.542266, 2.396725, 0.000000, 0.000022, 0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 12944, "ce_bankalley2", "newall5-2", 0x00000000);
	tmpobjid = CreateDynamicObject(19445, 173.574249, -339.612335, 2.396725, 0.000000, 0.000022, 0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 12944, "ce_bankalley2", "newall5-2", 0x00000000);
	tmpobjid = CreateDynamicObject(19384, 192.471786, -331.388732, 2.453543, 0.000016, 0.000057, 92.399871, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 13014, "sw_block04", "sw_wallbrick_03", 0x00000000);
	tmpobjid = CreateDynamicObject(19354, 190.853286, -332.986297, 2.453152, 0.000071, -0.000016, -177.599914, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 13014, "sw_block04", "sw_wallbrick_03", 0x00000000);
	tmpobjid = CreateDynamicObject(19377, 189.769668, -341.010162, 5.943144, 0.000005, -0.000057, -87.599967, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 13014, "sw_block04", "sw_wallbrick_03", 0x00000000);
	tmpobjid = CreateDynamicObject(19445, 186.315658, -334.768035, 2.453152, -0.000016, -0.000064, -87.599952, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 13014, "sw_block04", "sw_wallbrick_03", 0x00000000);
	tmpobjid = CreateDynamicObject(19384, 186.184646, -334.773437, 5.933150, -0.000016, -0.000064, -87.599952, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 13014, "sw_block04", "sw_wallbrick_03", 0x00000000);
	tmpobjid = CreateDynamicObject(19384, 186.184646, -334.773437, 9.403140, -0.000016, -0.000064, -87.599952, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 13014, "sw_block04", "sw_wallbrick_03", 0x00000000);
	tmpobjid = CreateDynamicObject(19384, 186.184646, -334.773437, 12.883147, -0.000016, -0.000064, -87.599952, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 13014, "sw_block04", "sw_wallbrick_03", 0x00000000);
	tmpobjid = CreateDynamicObject(19353, 183.385269, -341.275451, 2.453152, -0.000016, -0.000064, -87.599952, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 13014, "sw_block04", "sw_wallbrick_03", 0x00000000);
	tmpobjid = CreateDynamicObject(19353, 181.802810, -339.811096, 2.453152, 0.000049, -0.000028, -177.599945, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 13014, "sw_block04", "sw_wallbrick_03", 0x00000000);
	tmpobjid = CreateDynamicObject(19353, 181.670181, -336.644256, 2.453152, 0.000049, -0.000028, -177.599945, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 13014, "sw_block04", "sw_wallbrick_03", 0x00000000);
	tmpobjid = CreateDynamicObject(19354, 189.373214, -334.639709, 5.933150, -0.000016, -0.000078, -87.600044, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 13014, "sw_block04", "sw_wallbrick_03", 0x00000000);
	tmpobjid = CreateDynamicObject(19354, 189.373214, -334.639709, 9.403140, -0.000016, -0.000078, -87.600044, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 13014, "sw_block04", "sw_wallbrick_03", 0x00000000);
	tmpobjid = CreateDynamicObject(19354, 189.373214, -334.639709, 12.883147, -0.000016, -0.000078, -87.600044, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 13014, "sw_block04", "sw_wallbrick_03", 0x00000000);
	tmpobjid = CreateDynamicObject(19400, 192.458908, -331.406616, 5.943156, 0.000016, 0.000057, 92.399871, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 13014, "sw_block04", "sw_wallbrick_03", 0x00000000);
	tmpobjid = CreateDynamicObject(19400, 192.458908, -331.406616, 9.433161, 0.000016, 0.000057, 92.399871, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 13014, "sw_block04", "sw_wallbrick_03", 0x00000000);
	tmpobjid = CreateDynamicObject(19400, 192.458908, -331.406616, 12.913161, 0.000016, 0.000057, 92.399871, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 13014, "sw_block04", "sw_wallbrick_03", 0x00000000);
	tmpobjid = CreateDynamicObject(19354, 190.853286, -332.986297, 5.943144, 0.000071, -0.000016, -177.599914, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 13014, "sw_block04", "sw_wallbrick_03", 0x00000000);
	tmpobjid = CreateDynamicObject(19354, 190.853286, -332.986297, 12.863154, 0.000071, -0.000016, -177.599914, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 13014, "sw_block04", "sw_wallbrick_03", 0x00000000);
	tmpobjid = CreateDynamicObject(19354, 190.853286, -332.986297, 9.413146, 0.000071, -0.000016, -177.599914, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 13014, "sw_block04", "sw_wallbrick_03", 0x00000000);
	tmpobjid = CreateDynamicObject(19354, 184.692947, -336.447998, 9.333132, -0.000086, 0.000016, 2.400298, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 13014, "sw_block04", "sw_wallbrick_03", 0x00000000);
	tmpobjid = CreateDynamicObject(19446, 194.339096, -336.084838, 12.863154, 0.000078, -0.000016, -177.599929, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 13014, "sw_block04", "sw_wallbrick_03", 0x00000000);
	tmpobjid = CreateDynamicObject(19354, 184.826034, -339.623779, 9.333132, -0.000086, 0.000016, 2.400298, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 13014, "sw_block04", "sw_wallbrick_03", 0x00000000);
	tmpobjid = CreateDynamicObject(19354, 184.692947, -336.447998, 12.823115, -0.000094, 0.000016, 2.400312, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 13014, "sw_block04", "sw_wallbrick_03", 0x00000000);
	tmpobjid = CreateDynamicObject(19354, 184.826034, -339.623779, 12.823115, -0.000094, 0.000016, 2.400312, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 13014, "sw_block04", "sw_wallbrick_03", 0x00000000);
	tmpobjid = CreateDynamicObject(19446, 189.535079, -336.404113, 4.143225, 0.000016, 90.000045, 92.399795, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "concretegroundl1_256", 0x00000000);
	tmpobjid = CreateDynamicObject(19384, 184.692947, -336.447998, 5.923140, -0.000071, 0.000016, 2.400253, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 13014, "sw_block04", "sw_wallbrick_03", 0x00000000);
	tmpobjid = CreateDynamicObject(19354, 184.826034, -339.623779, 5.923140, -0.000071, 0.000016, 2.400253, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 13014, "sw_block04", "sw_wallbrick_03", 0x00000000);
	tmpobjid = CreateDynamicObject(19446, 192.658462, -336.152954, 4.153227, 0.000057, 89.999961, -177.599945, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "concretegroundl1_256", 0x00000000);
	tmpobjid = CreateDynamicObject(19446, 189.535079, -336.404113, 7.603224, 0.000016, 90.000053, 92.399795, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "concretegroundl1_256", 0x00000000);
	tmpobjid = CreateDynamicObject(19446, 192.658462, -336.152954, 7.613226, 0.000064, 89.999961, -177.599975, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "concretegroundl1_256", 0x00000000);
	tmpobjid = CreateDynamicObject(19446, 189.535079, -336.404113, 11.083277, 0.000016, 90.000061, 92.399795, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "concretegroundl1_256", 0x00000000);
	tmpobjid = CreateDynamicObject(19446, 192.658462, -336.152954, 11.093279, 0.000071, 89.999961, -177.599990, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "concretegroundl1_256", 0x00000000);
	tmpobjid = CreateDynamicObject(19446, 189.535079, -336.404113, 14.553290, 0.000016, 90.000068, 92.399795, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "concretegroundl1_256", 0x00000000);
	tmpobjid = CreateDynamicObject(19446, 192.658462, -336.152954, 14.563292, 0.000078, 89.999961, -177.600021, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "concretegroundl1_256", 0x00000000);
	tmpobjid = CreateDynamicObject(19427, 186.182022, -334.002929, 7.603236, -0.000057, 90.000007, 2.400115, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "concretegroundl1_256", 0x00000000);
	tmpobjid = CreateDynamicObject(19446, 189.648452, -341.003784, 12.843207, 0.000016, 0.000086, 92.399871, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 13014, "sw_block04", "sw_wallbrick_03", 0x00000000);
	tmpobjid = CreateDynamicObject(19427, 186.182022, -334.002929, 11.083231, -0.000057, 90.000007, 2.400115, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "concretegroundl1_256", 0x00000000);
	tmpobjid = CreateDynamicObject(8614, 188.867416, -339.117126, 2.759175, -0.000057, 360.000000, 2.400222, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(8614, 188.817581, -339.119262, 6.389220, -0.000071, 360.000000, 2.400282, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(8614, 188.817581, -339.119262, 9.859232, -0.000078, 360.000000, 2.400298, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(8614, 188.817581, -339.119262, 13.329249, -0.000086, 360.000000, 2.400312, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19377, 194.325912, -336.045349, 5.943144, 0.000078, -0.000016, -177.599929, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 13014, "sw_block04", "sw_wallbrick_03", 0x00000000);
	tmpobjid = CreateDynamicObject(19480, 190.760726, -333.142150, 5.721304, 0.000057, -0.000016, -177.599868, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "flatdoor01_law", 0x00000000);
	SetDynamicObjectMaterialText(tmpobjid, 0, "2", 120, "Engravers MT", 80, 0, 0xFF000000, 0x00000000, 1);
	tmpobjid = CreateDynamicObject(19480, 190.760726, -333.142150, 9.511317, 0.000057, -0.000016, -177.599868, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "flatdoor01_law", 0x00000000);
	SetDynamicObjectMaterialText(tmpobjid, 0, "3", 120, "Engravers MT", 80, 0, 0xFF000000, 0x00000000, 1);
	tmpobjid = CreateDynamicObject(19480, 190.760726, -333.142150, 13.001318, 0.000057, -0.000016, -177.599868, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "flatdoor01_law", 0x00000000);
	SetDynamicObjectMaterialText(tmpobjid, 0, "4", 120, "Engravers MT", 80, 0, 0xFF000000, 0x00000000, 1);
	tmpobjid = CreateDynamicObject(19480, 189.347457, -334.513671, 5.721304, 0.000016, 0.000049, 92.399795, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "flatdoor01_law", 0x00000000);
	SetDynamicObjectMaterialText(tmpobjid, 0, "2", 120, "Engravers MT", 80, 0, 0xFF000000, 0x00000000, 1);
	tmpobjid = CreateDynamicObject(19480, 189.347457, -334.513671, 9.511317, 0.000016, 0.000049, 92.399795, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "flatdoor01_law", 0x00000000);
	SetDynamicObjectMaterialText(tmpobjid, 0, "3", 120, "Engravers MT", 80, 0, 0xFF000000, 0x00000000, 1);
	tmpobjid = CreateDynamicObject(19480, 189.347457, -334.513671, 13.001318, 0.000016, 0.000049, 92.399795, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "flatdoor01_law", 0x00000000);
	SetDynamicObjectMaterialText(tmpobjid, 0, "4", 120, "Engravers MT", 80, 0, 0xFF000000, 0x00000000, 1);
	tmpobjid = CreateDynamicObject(19427, 186.182022, -334.002929, 4.143225, -0.000057, 90.000007, 2.400115, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "concretegroundl1_256", 0x00000000);
	tmpobjid = CreateDynamicObject(19353, 183.198867, -336.629394, 4.143225, 0.000016, 90.000045, 92.399795, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "concretegroundl1_256", 0x00000000);
	tmpobjid = CreateDynamicObject(19353, 183.321945, -339.566650, 4.213229, 0.000016, 90.000045, 92.399795, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "concretegroundl1_256", 0x00000000);
	tmpobjid = CreateDynamicObject(19445, 198.360214, -307.785430, 2.431561, 0.000000, 0.000022, 0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "bigbrick", 0x00000000);
	tmpobjid = CreateDynamicObject(19445, 198.350219, -307.785430, 4.171561, 0.000000, 0.000022, 0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "bigbrick", 0x00000000);
	tmpobjid = CreateDynamicObject(19445, 193.630218, -303.035522, 4.171561, 0.000022, 0.000000, 89.999931, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "bigbrick", 0x00000000);
	tmpobjid = CreateDynamicObject(19445, 193.620223, -312.535461, 4.171561, -0.000022, 0.000000, -89.999931, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "bigbrick", 0x00000000);
	tmpobjid = CreateDynamicObject(19445, 193.620223, -312.525451, 2.441559, -0.000022, 0.000000, -89.999931, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "bigbrick", 0x00000000);
	tmpobjid = CreateDynamicObject(19445, 193.620223, -303.045654, 2.441559, -0.000022, 0.000000, -89.999931, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "bigbrick", 0x00000000);
	tmpobjid = CreateDynamicObject(19353, 198.390213, -310.075256, 2.431561, 0.000000, 0.000022, 0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6522, "cuntclub_law2", "marinadoor1_256", 0x00000000);
	tmpobjid = CreateDynamicObject(19353, 198.390213, -306.265167, 2.431561, 0.000000, 0.000022, 0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6522, "cuntclub_law2", "marinawindow1_256", 0x00000000);
	tmpobjid = CreateDynamicObject(19353, 198.370239, -305.445404, 2.431561, 0.000000, 0.000022, 0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6522, "cuntclub_law2", "marinawindow1_256", 0x00000000);
	tmpobjid = CreateDynamicObject(19353, 188.880249, -304.575256, 2.441559, -0.000000, 0.000022, -0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "bigbrick", 0x00000000);
	tmpobjid = CreateDynamicObject(19353, 188.880249, -310.965179, 2.441559, -0.000000, 0.000022, -0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "bigbrick", 0x00000000);
	tmpobjid = CreateDynamicObject(19353, 188.890243, -310.965179, 4.181559, -0.000000, 0.000022, -0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "bigbrick", 0x00000000);
	tmpobjid = CreateDynamicObject(19353, 188.890243, -304.585205, 4.181559, -0.000000, 0.000022, -0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "bigbrick", 0x00000000);
	tmpobjid = CreateDynamicObject(19353, 190.210205, -307.795166, 4.181559, -0.000000, 0.000022, -0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "bigbrick", 0x00000000);
	tmpobjid = CreateDynamicObject(19353, 190.190216, -307.795166, 2.421561, -0.000000, 0.000022, -0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 6522, "cuntclub_law2", "marinadoor1_256", 0x00000000);
	tmpobjid = CreateDynamicObject(19353, 190.420227, -306.105255, 2.441559, 0.000022, 0.000000, 89.999931, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "bigbrick", 0x00000000);
	tmpobjid = CreateDynamicObject(19353, 190.420227, -306.095245, 4.181559, 0.000022, 0.000000, 89.999931, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "bigbrick", 0x00000000);
	tmpobjid = CreateDynamicObject(19353, 190.420227, -309.455230, 4.181559, 0.000022, 0.000000, 89.999931, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "bigbrick", 0x00000000);
	tmpobjid = CreateDynamicObject(19353, 190.420227, -309.445220, 2.481560, 0.000022, 0.000000, 89.999931, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "bigbrick", 0x00000000);
	tmpobjid = CreateDynamicObject(19353, 190.600265, -304.555175, 5.851561, -0.000000, 90.000022, -0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ws_rooftarmac1", 0x00000000);
	tmpobjid = CreateDynamicObject(19353, 190.600265, -310.975036, 5.851561, -0.000000, 90.000022, -0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ws_rooftarmac1", 0x00000000);
	tmpobjid = CreateDynamicObject(19445, 191.920349, -307.805236, 5.861563, -0.000000, 90.000022, -0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ws_rooftarmac1", 0x00000000);
	tmpobjid = CreateDynamicObject(19445, 195.410400, -307.805236, 5.861563, -0.000000, 90.000022, -0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ws_rooftarmac1", 0x00000000);
	tmpobjid = CreateDynamicObject(19445, 196.690368, -307.805236, 5.871565, -0.000000, 90.000022, -0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ws_rooftarmac1", 0x00000000);
	tmpobjid = CreateDynamicObject(19482, 198.449615, -306.843933, 3.978313, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 2640, "cj_coin_op_2", "CJ_POKERSCREEN", 0x00000000);
	SetDynamicObjectMaterialText(tmpobjid, 0, "TRAINING CENTER ", 130, "Arial", 50, 0, 0xFF000000, 0x00000000, 0);
	tmpobjid = CreateDynamicObject(19482, 198.459609, -306.883972, 3.978313, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
	SetDynamicObjectMaterial(tmpobjid, 0, 2640, "cj_coin_op_2", "CJ_POKERSCREEN", 0x00000000);
	SetDynamicObjectMaterialText(tmpobjid, 0, "TRAINING CENTER ", 130, "Arial", 50, 0, 0xFFF0F8FF, 0x00000000, 0);
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	tmpobjid = CreateDynamicObject(997, 185.025405, -334.832000, 4.223216, 0.000049, 360.000000, -177.599945, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(997, 181.628646, -334.975158, 4.223216, -0.000016, 360.000000, -87.599952, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(997, 181.759170, -338.092010, 4.223216, -0.000016, 360.000000, -87.599952, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(738, 198.960250, -300.183837, 0.740096, 0.000000, 0.000022, 0.000000, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(738, 198.960250, -293.923828, 0.740096, 0.000022, 0.000000, 89.999931, -1, -1, -1, 300.00, 300.00); 
	tmpobjid = CreateDynamicObject(738, 198.960250, -315.023712, 0.740096, 0.000000, -0.000022, 179.999862, -1, -1, -1, 300.00, 300.00); 
	return 1;
}