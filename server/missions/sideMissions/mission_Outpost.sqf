// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: mission_VehicleCapture.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, JoSchaap, AgentRev
//	@file Created: 08/12/2012 15:19

if (!isServer) exitwith {};
#include "sideMissionDefines.sqf";

private ["_nbUnits", "_outpost", "_objects", "_drop_item", "_drugpilerandomizer", "_drugpile"];

_setupVars =
{
	_missionType = "Enemy Outpost";
	_locationsArray = MissionSpawnMarkers;
	_nbUnits = AI_GROUP_MEDIUM;
};

_setupObjects =
{
	_missionPos = markerPos _missionLocation;

	_outpost = (call compile preprocessFileLineNumbers "server\missions\outposts\outpostsList.sqf") call BIS_fnc_selectRandom;
	_objects = [_outpost, _missionPos, 0] call createOutpost;

	_aiGroup = createGroup CIVILIAN;
	[_aiGroup, _missionPos, _nbUnits, 5] call createCustomGroup;

	_missionHintText = format ["An armed <t color='%1'>outpost</t> containing weapon crates has been spotted near the marker, go capture it!", sideMissionColor]
};

_waitUntilMarkerPos = nil;
_waitUntilExec = nil;
_waitUntilCondition = nil;

_failedExec =
{
	// Mission failed
	{ deleteVehicle _x } forEach _objects;
};

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

_successExec =
{
	// Mission completed
	_drugpilerandomizer = [8,10,12];
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
	
	// Mission complete
	{ _x setVariable ["R3F_LOG_disabled", false, true] } forEach _objects;
	[_locationsArray, _missionLocation, _objects] call setLocationObjects;

	_successHintMessage = "The outpost has been captured, good work.";
};

_this call sideMissionProcessor;
