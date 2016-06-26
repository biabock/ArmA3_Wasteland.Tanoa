//Configuration for Airdrop Assistance
//Author: Apoc

APOC_AA_coolDownTime = 30; //Expressed in sec

APOC_AA_VehOptions =
[ // ["Menu Text",		ItemClassname,				Price,	"Drop Type"]
["Quadbike (Civilian)",	"C_Quadbike_01_F",			1000, 	"vehicle"],
["Offroad Camo",		"B_G_Offroad_01_F",			5000, 	"vehicle"],
["Strider",				"I_MRAP_03_F",				8000, 	"vehicle"],
["MH-9 Hummingbird",	"B_Heli_Light_01_F",		10000, 	"vehicle"],
["MB 4WD",				"C_Offroad_02_unarmed_F",	2000,	"vehicle"],
["Prowler",				"B_T_LSV_01_unarmed_F",		4000,	"vehicle"],
["Qilin",				"O_T_LSV_02_unarmed_F",		4000,	"vehicle"],
["Hunter",				"B_MRAP_01_F",				7000, 	"vehicle"],
["Ifrit",				"O_MRAP_02_F",				7000,	"vehicle"],
["Strider",				"I_MRAP_03_F",				7000,	"vehicle"],
["Water Scooter",		"C_Scooter_Transport_01_F",	1000,	"vehicle"],
["Rescue Boat",			"C_Rubberboat",				1000,	"vehicle"],
["Motorboat",			"C_Boat_Civil_01_F",		1500,	"vehicle"]
];

APOC_AA_SupOptions =
[// ["stringItemName", 	"Crate Type for fn_refillBox	,Price," drop type"]
["Launchers", 			"mission_USLaunchers",		35000, "supply"],
["Assault Rifle", 		"mission_USSpecial",		35000, "supply"],
["Sniper Rifles", 		"airdrop_Snipers",			50000, "supply"],
["DLC Rifles", 			"airdrop_DLC_Rifles",		45000, "supply"],
["DLC LMGs", 			"airdrop_DLC_LMGs",			45000, "supply"]

//"Menu Text",			"Crate Type", 			"Cost", 			"drop type"
//["Food",				"Land_Sacks_goods_F",	10000, 	"picnic"],
//["Water",				"Land_BarrelWater_F",	10000, 	"picnic"]
];