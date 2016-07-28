//Client Function for Airdrop Assistance (not really a function, as it is called via ExecVM from command menu)
//This takes values from command menu, and some passed variables, and interacts with client and sends commands to server
//Author: Apoc
//Credits: Some methods taken from Cre4mpie's airdrop scripts, props for the idea!
#define APOC_coolDownTimer (["APOC_coolDownTimer", 900] call getPublicVar)
scriptName "APOC_cli_startAirdrop";
disableSerialization;

private ["_display","_cbDropCategories","_lbDropList","_lbDropContentList","_btnOrderDrop","_GoBackBtn","_Category","_DropCategories"];

closeDialog 2001; //Close Player settings dialog
createDialog "APOC_AirdropMenu";
_display = findDisplay 6600;

//Custom Code In Here //

_cbDropCategories = _display displayCtrl 6601;
_cbDropCategories ctrlSetEventHandler ["LBSelChanged", "_this call fn_DropCategory_Load;"];

_lbDropList = _display displayCtrl 6602;
_lbDropList ctrlSetEventHandler ["LBSelChanged", "_this call fn_DropContents_Load;"];

_lbDropContentList = _display displayCtrl 6603;

_btnOrderDrop = _display displayCtrl 6604;
_btnOrderDrop ctrlSetText "Order";
_btnOrderDrop ctrlSetEventHandler ["ButtonClick", "_this call fn_OrderDrop;"];

_GoBackBtn = _display displayCtrl 6605;
_GoBackBtn ctrlSetText "Close";
_GoBackBtn ctrlSetEventHandler ["ButtonClick", "closeDialog 6600;"];


// Establish Category List from config file
  _DropCategories = []; //Clear the array
  /*diag_log format ["AAA - Config Count is %1",count APOC_AA_Drops];*/
  for "_i" from 0 to (count APOC_AA_Drops)-1 do {
    _Category = (APOC_AA_Drops select _i) select 0; //Grabs the string of the drop category ie: "Vehicles" or "Supplies" or "Lawn Gnomes"
    /*diag_log format ["AAA - Config Category is %1", _Category];*/
    _DropCategories pushBack _Category;
    /*diag_log format ["AAA - Config Category is %1", _DropCategories];*/
  };

  {
    (_display displayCtrl 6601) lbAdd Format["%1",_x];
    (_display displayCtrl 6601) lbSetData [_forEachIndex,_x];
  } foreach _DropCategories;
(_display displayCtrl 6601) lbSetCurSel 0; //Try and select the first value from the newly populated listbox, should force the downstream listbox to populate as well, due to EH firing


//APOC_Airdrop_Assistance Functions
fn_DropCategory_Load = {
  _display = findDisplay 6600;
  lbClear 6602; //Clear Drop List lb
  lbClear 6603; //Clear Drop Content lb

  _ctrl = _this select 0;
  _Selection = _ctrl lbData (lbCurSel _ctrl);

    //Initializing some variables
  _Category = "";
  _Drop = "";
  _DropID = "";
  _DropDesc = "";
  _DropPrice  = 0;

  _playerMoney = 0;
  _playerMoney = player getVariable ["bmoney",0];

  //Load in the Drops under this category
  for "_i" from 0 to (count APOC_AA_Drops)-1 do {
    _Category = (APOC_AA_Drops select _i) select 0; //Grabs the string of the drop category ie: "Vehicles" or "Supplies" or "Lawn Gnomes"

    if (_Category == _Selection) then
    {
      {
        _DropDesc =  _x select 0;
        _DropID = _x select 1;
        _DropPrice = _x select 2;

        _Drop = format ["%1 - Cost: $ %2", _DropDesc, _DropPrice];

        (_display displayCtrl 6602) lbAdd Format["%1",_Drop];
        (_display displayCtrl 6602) lbSetData [_forEachIndex,_DropID];

        if (_DropPrice > _playerMoney) then {
            (_display displayCtrl 6602) lbSetColor [_forEachIndex,[1,0,0,1]]; //Set drop text to red if too expensive for player
        };

      } forEach ((APOC_AA_Drops select _i) select 1);
    };
  };
};

fn_DropContents_Load = {
  _display = findDisplay 6600;
  lbClear 6603; //Clear Drop Content lb
  _ctrl = _this select 0;
  _Selection = _ctrl lbData (lbCurSel _ctrl);

  //Initializing some variables
  _Drop = "";
  _DropID = "";
  _DropDesc = "";
  _DropPrice  = 0;
  //Load in the Drop contents under this DropID
  for "_i" from 0 to (count APOC_AA_Drop_Contents)-1 do {
    _DropID = (APOC_AA_Drop_Contents select _i) select 0;

    if (_DropID == _Selection) then
    {
      {
        _DropContentItemName = (_x select 1) select 0; //Only grab the first if multiple in the items
        _DropContentDisplayName = getText (configfile >> "CfgMagazines" >> _DropContentItemName >> "displayName");
        if (_DropContentDisplayName == "") then
        {
          _DropContentDisplayName = getText (configfile >> "CfgWeapons" >> _DropContentItemName >> "displayName");
            if (_DropContentDisplayName =="") then
            {
              _DropContentDisplayName = getText (configfile >> "CfgVehicles" >> _DropContentItemName >> "displayName");
            };
        };
        _DropContentQuantity = _x select 2;
        /*diag_log format["AAA - Diagnostic - DropContentItemName=%1, DisplayName=%2",_DropContentItemName,_DropContentDisplayName];*/
        _DropContent = format ["%1 - %2", _DropContentQuantity,_DropContentDisplayName];

        (_display displayCtrl 6603) lbAdd Format["%1",_DropContent];

      } forEach ((APOC_AA_Drop_Contents select _i) select 1);
    };
  };
};

fn_OrderDrop = {
  private ["_DropDesc", "_DropPrice", "_DropType", "_CategorySelection", "_DropSelection","_playerMoney","_coolDownTimer","_confirmMsg","_heliDirection"];
  diag_log format["AAA - fn_OrderDrop Called"];
  _display = findDisplay 6600;
  _ctrl = (_display displayCtrl 6601);
  _CategorySelection = _ctrl lbData (lbCurSel _ctrl);
  _ctrl = (_display displayCtrl 6602);
  _DropSelection = _ctrl lbData (lbCurSel _ctrl);  //_DropId

  //Initializing some variables
  _Drop = "";
  _DropID = "";
  _DropDesc = "";
  _DropPrice  = "";

  //Very convoluted system to extract the price from the arrays
    for "_i" from 0 to (count APOC_AA_Drops)-1 do {
      _Category = (APOC_AA_Drops select _i) select 0; //Grabs the string of the drop category ie: "Vehicles" or "Supplies" or "Lawn Gnomes"
      if (_Category == _CategorySelection) then
      {
        //diag_log format["AAA - _Category line 179 = %1",_Category];
        {
          _Selection = _x select 1;
          if (_DropSelection == _Selection) then
          {
            //diag_log format["AAA - _Selection line 184 = %1",_Selection];
            _DropDesc = _x select 0;
            _DropPrice = _x select 2;
            _DropType = _x select 3;

          };
        } forEach ((APOC_AA_Drops select _i) select 1);
      };
    };
    diag_log format ["AAA - _DropPrice = %1", _DropPrice];
    //Dive out of the tree if an empty order is selected (or not)
    If (isNil "_DropType") exitWith {diag_log "AAA - _DropType Not Specified, cannot place order";};
    If (isNil "_DropDesc") exitWith {diag_log "AAA - _DropDesc Not Specified, cannot place order";};
    If (isNil "_DropPrice") exitWith {diag_log "AAA - _DropPrice Not Specified, cannot place order";};
/////////////  Cooldown Timer ////////////////////////
if (!isNil "APOC_AA_lastUsedTime") then
{
if (isNil {_coolDownTimer}) then
{
	_coolDownTimer = APOC_coolDownTimer;
};

_timeRemainingReuse = _coolDownTimer - (diag_tickTime - APOC_AA_lastUsedTime); //time is still in s
if ((_timeRemainingReuse) > 0) then
	{
		hint format["Negative. Airdrop Offline. Online ETA: %1", _timeRemainingReuse call fn_formatTimer];
		playSound "FD_CP_Not_Clear_F";
		player groupChat format ["Negative. Airdrop Offline. Online ETA: %1",_timeRemainingReuse call fn_formatTimer];
		breakOut "APOC_cli_startAirdrop";
	};
};
////////////////////////////////////////////////////////
_playerMoney = 0;
_playerMoney = player getVariable ["bmoney", 0];

diag_log format ["AAA - Line 194 - playermoney = %1, price = %2",_playerMoney, _DropPrice];

if (_DropPrice > _playerMoney) exitWith
	{
		hint format["You don't have enough money in the bank to request this airdrop!"];
		playSound "FD_CP_Not_Clear_F";
	};

//_confirmMsg = format ["This airdrop will deduct $%1 from your bank account upon delivery<br/>",_DropPrice call fn_numbersText];
//_confirmMsg = _confirmMsg + format ["<br/><t font='EtelkaMonospaceProBold'>1</t> x %1",_DropSelection];

	// Display confirm message
  _heliDirection = random 360;

    	//if ([parseText _confirmMsg, "Confirm", "DROP!", true] call BIS_fnc_guiMessage) then
    	//{
      	[[_DropType,_DropSelection,player,_heliDirection],"APOC_srv_startAirdrop",false,false,false] call BIS_fnc_MP;
      	APOC_AA_lastUsedTime = diag_tickTime;
        [_heliDirection,_DropDesc] spawn {
            _heliDirection = _this select 0;
            _DropDesc = _this select 1;
      	    playSound3D ["a3\sounds_f\sfx\radio\ambient_radio17.wss",player,false,getPosASL player,1,1,25];
      	    sleep 1;
          	hint format ["Inbound Airdrop %2 Heading: %1 ETA: 40s",ceil _heliDirection,_DropDesc];
          	player groupChat format ["Inbound Airdrop %2 Heading: %1 ETA: 40s",ceil _heliDirection,_DropDesc];
          	sleep 20;
          	hint format ["Inbound Airdrop %2 Heading: %1 ETA: 20s",ceil _heliDirection,_DropDesc];
          	player groupChat format ["Inbound Airdrop %2 Heading: %1 ETA: 20s",ceil _heliDirection,_DropDesc];
      };
      //};

};
