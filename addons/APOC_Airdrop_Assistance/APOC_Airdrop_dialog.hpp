//Dialog Stuff for Airdrop Assistance
////Author: Apoc

#define true 1
#define false 0

#define APOC_AirdropMenuDIALOG_idd 6600
#define cbDropCategories_idc 6601
#define lbDropList_idc	6602
#define lbDropContentsList_idc 6603
#define btnOrderDrop_idc 6604
#define btnCloseDialog_idc 6605

class APOC_AirdropMenu {

	idd = APOC_AirdropMenuDIALOG_idd;
	movingEnable = true;
	enableSimulation = true;

	class controlsBackground {

		class MainBG : IGUIBack {
			idc = -1;
			colorText[] = {1, 1, 1, 1};
			colorBackground[] = {0,0,0,0.6};

			moving = true;
			x = 0.0; y = 0.1;
			w = .745; h = 0.65;
		};

		class TopBar: IGUIBack
		{
			idc = -1;
			colorText[] = {1, 1, 1, 1};
			colorBackground[] = {A3W_UICOLOR_R, A3W_UICOLOR_G, A3W_UICOLOR_B, 0.8};

			x = 0;
			y = 0.1;
			w = 0.745;
			h = 0.05;
		};

		class MainTitle : w_RscText {
			idc = -1;
			text = "AirDrop Menu";
			sizeEx = 0.04;
			shadow = 2;
			x = 0.260; y = 0.1;
			w = 0.3; h = 0.05;
		};
	};

	class controls {
		class cbDropCategories : w_RscCombo {  //[0.125,0.28,0.38,0.04]
			idc = cbDropCategories_idc;
			x = 0.125;
			y = 0.28;
			w = 0.38;
			h = 0.04;
		};

		class lbDropList : w_RscList { //[0.1125,0.32,0.38,0.28]
			idc = lbDropList_idc;
			x = 0.125;
			y = 0.32;
			w = 0.38;
			h = 0.28;
		};

		class lbDropContentList : w_RscList {  //[0.525,0.28,0.32,0.42]
			idc = lbDropContentsList_idc;
			x = 0.545;
			y = 0.28;
			w = 0.32;
			h = 0.42;
		};

		class btnOrderDrop : w_RscButton {  //[0.65,0.72,0.1,0.04]
			idc = btnOrderDrop_idc;
			x = 0.65;
			y = 0.72;
			w = 0.1;
			h = 0.04;
		};

		class btnCloseDialog : w_RscButton { //[0.775,0.72,0.1,0.04]
			idc = btnCloseDialog_idc;
			x = 0.775;
			y = 0.72;
			w = 0.1;
			h = 0.04;
		};
	};
};