// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: mission_ArmedDiversquad.sqf
//	@file Author: JoSchaap, AgentRev

if (!isServer) exitwith {};
#include "mainMissionDefines.sqf";

private ["_box1", "_box2", "_boxPos", "_vehicleClass", "_vehicle", "_wreck", "_drop_item", "_drugPos", "_explosivePos", "_explosive"];

_setupVars =
{
	_missionType = "Jaws Wreck";
	_locationsArray = SunkenMissionMarkers;
};

_setupObjects =
{
	_missionPos = markerPos _missionLocation;

	_wreck = createVehicle ["Land_UWreck_FishingBoat_F", _missionPos, [], 5, "None"];
	_wreck setDir random 360;

	_box1 = createVehicle ["Box_IND_WpsSpecial_F", _missionPos, [], 5, "None"];
	_box1 setDir random 360;
	[_box1, "apex_bounty"] call fn_refillbox;

	_box2 = createVehicle ["Box_NATO_WpsSpecial_F", _missionPos, [], 5, "None"];
	_box2 setDir random 360;
	[_box2, "mission_USSpecial2"] call fn_refillbox;

	{
		_boxPos = getPosASL _x;
		_boxPos set [2, getTerrainHeightASL _boxPos + 1];
		_x setPos _boxPos;
		_x setVariable ["R3F_LOG_disabled", true, true];
	} forEach [_box1, _box2, _wreck];

	_vehicleClass = ["B_Boat_Armed_01_minigun_F", "O_Boat_Armed_01_hmg_F", "I_Boat_Armed_01_minigun_F"] call BIS_fnc_selectRandom;

	// Vehicle Class, Position, Fuel, Ammo, Damage, Special
	_vehicle = [_vehicleClass, _missionPos] call createMissionVehicle2;
	_vehicle setPosASL _missionPos;
	_vehicle lockDriver true;

	[_vehicle, [
		["itm", "U_B_Wetsuit", 2],
		["itm", "U_O_Wetsuit", 2],
		["itm", "U_I_Wetsuit", 2],
		["itm", "V_RebreatherB", 2],
		["itm", "G_Diving", 2],
		["wep", "arifle_SDAR_F", 2],
		["mag", "20Rnd_556x45_UW_mag", 8]
	]] call processItems;

	_aiGroup = createGroup CIVILIAN;
	[_aiGroup, _missionPos] call createLargeDivers;

	[_vehicle, _aiGroup] spawn checkMissionVehicleLock;

	_missionPicture = getText (configFile >> "CfgVehicles" >> _vehicleClass >> "picture");
	_missionHintText = "We are going to need a Bigger Boat.<br/>Enemy divers are trying to recover arms and loot, go kill them and claim the loot.";
};

_waitUntilMarkerPos = nil;
_waitUntilExec = nil;
_waitUntilCondition = nil;

_failedExec =
{
	// Mission failed
	{ deleteVehicle _x } forEach [_box1, _box2, _wreck];
};

// _vehicle is automatically deleted or unlocked in missionProcessor depending on the outcome

_successExec =
{
	// Mission complete

	playSound3D [call currMissionDir + "client\sounds\scarface.ogg", _box1, false, _box1, 15, 1, 1500];

	{ _x setVariable ["R3F_LOG_disabled", false, true] } forEach [_box1, _box2];
	{ deleteVehicle _x } forEach [_wreck];
	_vehicle lockDriver false;
	_vehicle setDamage 1;

	//Explode the boat
	_explosive = "SatchelCharge_F" createVehicle (getPos _vehicle);
	_explosive setDamage 1;


_drop_item = 
{
	private["_item", "_pos"];
	_item = _this select 0;
	_pos = _this select 1;

	if (isNil "_item" || {typeName _item != typeName [] || {count(_item) != 2}}) exitWith {};
	if (isNil "_pos" || {typeName _pos != typeName [] || {count(_pos) != 3}}) exitWith {};

	private["_id", "_class"];
	_id = _item select 0;
	_class = _item select 1;

	private["_obj"];
	_obj = createVehicle [_class, _pos, [], 5, "None"];
	_obj setPos ([_pos, [[2 + random 3,0,0], random 360] call BIS_fnc_rotateVector2D] call BIS_fnc_vectorAdd);
	_obj setVariable ["mf_item_id", _id, true];
};

	_drugpilerandomizer = [8,12,16];
	_drugpile = _drugpilerandomizer call BIS_fnc_SelectRandom;
	
	for "_i" from 1 to _drugpile do 
	{
	  private["_item"];
	  _item = [
	          ["lsd", "Land_WaterPurificationTablets_F"],
	          ["marijuana", "Land_VitaminBottle_F"],
	          ["cocaine","Land_PowderedMilk_F"],
	          ["heroin", "Land_PainKillers_F"]
	        ] call BIS_fnc_selectRandom;
	  [_item, _missionPos] call _drop_item;
	};

	_successHintMessage = "The sunken loot has been captured, well done.";
};

_this call mainMissionProcessor;
