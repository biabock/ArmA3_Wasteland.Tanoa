// ******************************************************************************************
// * This script is licensed under the GNU Lesser GPL v3.
// ******************************************************************************************

//Configuration for Airdrop Assistance
//Author: Apoc
// https://github.com/osuapoc

#define RANDOM_BETWEEN(START,END) ((START) + floor random ((END) - (START) + 1))
#define RANDOM_ODDS(ODDS) ([0,1] select (random 1 < (ODDS))) // between 0.0 and 1.0

APOC_AA_DamageOnWhenLanded = false;		//Turn object allowDamage back on when object is on ground, instead of when in 'chute

APOC_AA_coolDownTime = 60; //Expressed in sec

APOC_AA_Drops =[
/*
	["Category Name",
		[
			["Text displayed to player",	"Name of vehicle or drop box",	cost, "vehicle or supply (use nothing but these two!"]  //This is an array, use commas between, DUH!
		] //If something breaks with your list of drops, you've likely messed up the nested arrays.
	]
*/

//Also, presently, these are NON-Persistant vehicles.  Meaning that they will not last over a restart.  Keep that in mind with prices.  Later updates I'll set that up, with pin code entry.
	["Vehicles",
		[
			["Quadbike (Civilian)", "C_Quadbike_01_F",					1000,	"vehicle"],
			["MH-9 Hummingbird",    "B_Heli_Light_01_F",				8000,	"vehicle"],
			["Strider",             "I_MRAP_03_F",						6000,	"vehicle"],
			["Strider HMG",         "I_MRAP_03_hmg_F",					20000,	"vehicle"],
			["Prowler HMG",         "B_T_LSV_01_armed_F",				15000,	"vehicle"],
			["MSE-3 Marid",         "O_APC_Wheeled_02_rcws_F",			50000,	"vehicle"],
			["AH-9 Pawnee",         "B_Heli_Light_01_armed_F",			35000,	"vehicle"],
			["ZSU-39 Tigris",       "O_APC_Tracked_02_AA_F",			60000,	"vehicle"],
			["MBT-52 Kuma",         "I_MBT_03_cannon_F",				90000,	"vehicle"]
		]
	],
	
	["Boats",
		[
			["Rescue Boat",			"C_Rubberboat",						1000,	"vehicle"],
			["Water Scooter", 		"C_Scooter_Transport_01_F",			1200,   "vehicle"],
			["Motorboat",			"C_Boat_Civil_01_F",				1500,	"vehicle"]
		]
	],

	["Weapons",
		[
			["Sniper Rifles", 		"airdrop_Snipers", 				50000, "supply"],
			["DLC Rifles", 			"airdrop_DLC_Rifles", 			45000, "supply"],
			["DLC LMGs", 			"airdrop_DLC_LMGs", 			45000, "supply"],
			["Launchers",           "airdrop_USLaunchers",          60000, "supply"],
			["Divers",				"airdrop_Divers",				15000, "supply"],
			["Ammo Box",			"airdrop_AMMO",					20000, "supply"]
		]
	]
];

APOC_AA_Drop_Contents =[
	["airdrop_Snipers",  //Name of the drop
		[
		// Item type, Item class(es), # of items, # of magazines per weapon
		// Valid item types: wep, itm, or bac.
			["wep", ["srifle_LRR_LRPS_F"],		1, 3],
			["wep", ["srifle_LRR_camo_LRPS_F"],	1, 3],
			["wep", ["srifle_GM6_LRPS_F"],		1, 3],
			["wep", ["srifle_GM6_camo_LRPS_F"],	1, 3],
			["wep", ["Binocular", "Rangefinder"],  3],
			["bac", ["B_Carryall_mcamo", "B_Kitbag_mcamo"], 2],
			["itm", ["optic_DMS","optic_AMS","optic_tws","optic_KHS_blk"], 8]
		]
	],

	["airdrop_DLC_Rifles",
		[
			["wep", ["srifle_DMR_03_multicam_F"],	1, 3],
			["wep", ["srifle_DMR_02_sniper_F"],		1, 3],
			["wep", ["srifle_DMR_05_hex_F"],		1, 3],
			["wep", ["srifle_DMR_04_Tan_F"],		1, 3],

			// ["ItemType",[Array of items/weps to choose from randomly], number of items]
			// If using wep, you need also number of mags to be included.
			["itm", ["V_PlateCarrierIAGL_dgtl", "V_TacVest_camo", "V_PlateCarrierGL_rgr"], 2],
			["itm", ["bipod_01_F_blk", "bipod_02_F_hex"], 3],
			["itm", ["optic_DMS","optic_AMS","optic_tws","optic_KHS_blk"], 2],
			["itm", ["muzzle_snds_B", "muzzle_snds_338_black", "muzzle_snds_338_sand", "muzzle_snds_93mmg"], 2],
			["bac", ["B_Carryall_mcamo", "B_Kitbag_mcamo"], 2]
		]
	],

	["airdrop_DLC_LMGs",
		[
			["wep", ["MMG_02_black_F", "MMG_02_camo_F","MMG_02_sand_F","MMG_01_hex_F","MMG_01_tan_F"], 4,4],
			["itm", ["V_PlateCarrierIAGL_dgtl", "V_TacVest_camo", "V_PlateCarrierGL_rgr"], 2],
			["bac", ["B_Carryall_mcamo", "B_Kitbag_mcamo"], 2],
			["itm", ["bipod_01_F_blk", "bipod_02_F_hex"], 2],
			["itm", ["optic_DMS","optic_AMS","optic_tws","optic_KHS_blk"], 2],
			["itm", ["muzzle_snds_338_black", "muzzle_snds_338_sand", "muzzle_snds_93mmg"], 2]
		]
	],
	["airdrop_USLaunchers",		
		[
			// Item type, Item class(es), # of items, # of magazines per weapon
			["wep", ["Laserdesignator", "Laserdesignator_02", "Laserdesignator_03"], 1],
			["wep", ["launch_RPG32_F", "launch_NLAW_F", "launch_Titan_short_F", "launch_Titan_F"], 8, 4],
			["mag", ["APERSTripMine_Wire_Mag", "APERSBoundingMine_Range_Mag", "APERSMine_Range_Mag", "ClaymoreDirectionalMine_Remote_Mag"], 5],
			["mag", ["SLAMDirectionalMine_Wire_Mag", "ATMine_Range_Mag", "DemoCharge_Remote_Mag", "SatchelCharge_Remote_Mag"], 5],
			["mag", ["HandGrenade"], 5],
			["mag", ["1Rnd_HE_Grenade_shell"], 10],
			["itm", ["H_HelmetB", "H_HelmetIA", "H_HelmetSpecB", "H_HelmetSpecO_ocamo", "H_HelmetLeaderO_ocamo"], 4],
			["itm", ["V_PlateCarrier1_rgr", "V_PlateCarrier1_blk", "V_PlateCarrierIA1_dgtl", "V_PlateCarrier2_rgr", "V_PlateCarrier2_blk", "V_PlateCarrierIA2_dgtl", "V_PlateCarrierSpec_rgr", "V_PlateCarrierSpec_blk", "V_PlateCarrierSpec_mtp"], 1], // Special
			["itm", ["V_PlateCarrierGL_rgr", "V_PlateCarrierGL_blk", "V_PlateCarrierGL_mtp", "V_PlateCarrierIAGL_dgtl", "V_PlateCarrierIAGL_oli"], 4]
		]
	],
	["airdrop_Divers",
		[
			// Item type, Item class(es), # of items, # of magazines per weapon
			["wep", ["arifle_SDAR_F"], 3, 3],
			["itm", ["V_RebreatherB"],  2],
			["itm", ["V_RebreatherIR"], 2],
			["itm", ["V_RebreatherIA"], 2],
			["itm", ["G_Diving"], 2],
			["itm", ["U_B_Wetsuit"], 2],
			["itm", ["U_O_Wetsuit"], 2],
			["itm", ["U_I_Wetsuit"], 2],
			["itm", ["Chemlight_red", "Chemlight_green", "Chemlight_yellow", "Chemlight_blue"], 9],
			["mag", ["SmokeShell", "SmokeShellRed", "SmokeShellgreen"], 9]
		]
	],
	["airdrop_AMMO",
		[
			// Item type, Item class(es), # of items, # of magazines per weapon
			["mag",["16Rnd_9x21_Mag", "30Rnd_9x21_Mag", "6Rnd_45ACP_Cylinder", "11Rnd_45ACP_Mag", "9Rnd_45ACP_Mag"], RANDOM_BETWEEN(15,20)],
			["mag",["30Rnd_45ACP_MAG_SMG_01", "30Rnd_45ACP_Mag_SMG_01_tracer_green"], RANDOM_BETWEEN(10,15)],
			["mag",["20Rnd_556x45_UW_mag","30Rnd_556x45_Stanag","30Rnd_556x45_Stanag_Tracer_Green"], RANDOM_BETWEEN(10,11)],
			["mag",["30Rnd_556x45_Stanag_Tracer_Yellow","30Rnd_556x45_Stanag_Tracer_Red"], RANDOM_BETWEEN(10,11)],
			["mag",["30Rnd_65x39_caseless_mag", "30Rnd_65x39_caseless_mag_Tracer"], RANDOM_BETWEEN(10,15)],
			["mag",["30Rnd_65x39_caseless_green", "30Rnd_65x39_caseless_green_mag_Tracer"], RANDOM_BETWEEN(10,15)],
			["mag",["100Rnd_65x39_caseless_mag", "100Rnd_65x39_caseless_mag_Tracer"], RANDOM_BETWEEN(7,10)],
			["mag",["200Rnd_65x39_cased_Box", "200Rnd_65x39_cased_Box_Tracer"], RANDOM_BETWEEN(7,10)],
			["mag",["10Rnd_762x54_Mag"], 10],
			["mag",["20Rnd_762x51_Mag"], 10],
			["mag",["150Rnd_762x54_Box","150Rnd_762x54_Box_Tracer"], 10],
			["mag",["10Rnd_338_Mag"], 10],
			["mag",["130Rnd_338_Mag"], 10], 
			["mag",["7Rnd_408_Mag"], 10],
			["mag",["10Rnd_93x64_DMR_05_Mag"], 10],
			["mag",["150Rnd_93x64_Mag"], 10], 
			["mag",["10Rnd_127x54_Mag"], 10], 
			["mag",["5Rnd_127x108_Mag","5Rnd_127x108_APDS_Mag"], RANDOM_BETWEEN(10,15)],
			["mag",["1Rnd_HE_Grenade_shell","1Rnd_Smoke_Grenade_shell","1Rnd_SmokePurple_Grenade_shell","1Rnd_SmokeBlue_Grenade_shell","1Rnd_SmokeGreen_Grenade_shell","1Rnd_SmokeYellow_Grenade_shell","1Rnd_SmokeOrange_Grenade_shell","1Rnd_SmokeRed_Grenade_shell"], RANDOM_BETWEEN(8,10)],
			["mag",["3Rnd_HE_Grenade_shell","3Rnd_Smoke_Grenade_shell","3Rnd_SmokePurple_Grenade_shell","3Rnd_SmokeBlue_Grenade_shell", "3Rnd_SmokeGreen_Grenade_shell", "3Rnd_SmokeYellow_Grenade_shell","3Rnd_SmokeOrange_Grenade_shell","3Rnd_SmokeRed_Grenade_shell"], RANDOM_BETWEEN(8,10)],
			["mag",["UGL_FlareWhite_F", "UGL_FlareGreen_F","UGL_FlareYellow_F","UGL_FlareRed_F","UGL_FlareCIR_F", "3Rnd_UGL_FlareWhite_F", "3Rnd_UGL_FlareGreen_F","3Rnd_UGL_FlareYellow_F", "3Rnd_UGL_FlareRed_F","3Rnd_UGL_FlareCIR_F"], RANDOM_BETWEEN(10,15)]
		]	
	]
];
