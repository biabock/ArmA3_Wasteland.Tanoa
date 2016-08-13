// Isis Mission
// by Matt76 @ customcombatgaming.com
// original ideas by AgentRev and JoSchaap


if (!isServer) exitwith {};

#include "sideMissionDefines.sqf";

private ["_vehicles","_createVehicle","_veh1","_convoyVeh","_explosive","_explosivePos","_nbUnits", "_box1", "_box2", "_townName", "_missionPos", "_buildingRadius", "_putOnRoof", "_fillEvenly", "_drop_item", "_drugpilerandomizer", "_drugpile","_cash"];

_setupVars =
{
	_missionType = "ISIS incursion";
	_nbUnits = if (missionDifficultyHard) then { AI_GROUP_LARGE } else { AI_GROUP_MEDIUM };

	// settings for this mission
	_locArray = ((call cityList) call BIS_fnc_selectRandom);
	_missionPos = markerPos (_locArray select 0);
	_buildingRadius = _locArray select 1;
	_townName = _locArray select 2;

	//randomize amount of units
	_nbUnits = _nbUnits + round(random (_nbUnits*0.5));
	// reduce radius for larger towns. for example to avoid endless hide and seek in kavala ;)
	_buildingRadius = if (_buildingRadius > 201) then {(_buildingRadius*0.5)} else {_buildingRadius};
	// 25% change on AI not going on rooftops
	if (random 1 < 0.75) then { _putOnRoof = true } else { _putOnRoof = false };
	// 25% chance on AI trying to fit into a single building instead of spreading out
	if (random 1 < 0.75) then { _fillEvenly = true } else { _fillEvenly = false };
};

_setupObjects =
{
	// spawn some crates in the middle of town (Town marker position)
	_box1 = createVehicle ["Box_NATO_Wps_F", _missionPos, [], 5, "None"];
	_box1 setDir random 360;
	[_box1, "mission_USSpecial"] call fn_refillbox;
	_box1 allowDamage false; // just so the bomb doesnt destroy it

	_box2 = createVehicle ["Box_East_Wps_F", _missionPos, [], 5, "None"];
	_box2 setDir random 360;
	[_box2, "mission_USLaunchers"] call fn_refillbox;
	_box2 allowDamage false; // just so the bomb doesnt destroy it

	{ _x setVariable ["R3F_LOG_disabled", true, true] } forEach [_box1, _box2];


	
	// pick the vehicles
	_convoyVeh = if (missionDifficultyHard) then
	{
		["B_G_Offroad_01_armed_F"]
	}
	else
	{
		["B_G_Offroad_01_armed_F"]
	};

	_veh1 = _convoyVeh select 0;

	_createVehicle =
	{
		private ["_type", "_position", "_direction", "_vehicle"];

		_type = _this select 0;
		_position = _this select 1;
		_direction = _this select 2;

		_vehicle = createVehicle [_type, _position, [], 0, "None"];
		_vehicle setVariable ["R3F_LOG_disabled", true, true];
		_vehicle setVehicleLock "LOCKED";
		//[_vehicle] call vehicleSetup;

		_vehicle setDir _direction;

		switch (true) do
		{
			case (_type isKindOf "B_G_Offroad_01_armed_F"):
			{
				[_vehicle, "client\images\vehicleTextures\isis.paa", [0]] call applyVehicleTexture; 
			};
		};

		_vehicle
	};

	_vehiclePos = _missionPos;
	
	_vehicles =
	[
		[_veh1, _vehiclePos, 0] call _createVehicle
	];

	// spawn some rebels/enemies :)
	_aiGroup = createGroup CIVILIAN;
	[_aiGroup, _missionPos, _nbUnits] call createIsisGroup;

	// move them into buildings
	[_aiGroup, _missionPos, _buildingRadius, _fillEvenly, _putOnRoof] call moveIntoBuildings;

	_missionHintText = format ["A daesh uprising has taken over <br/><t size='1.25' color='%1'>%2</t><br/><br/>Indications are that <t color='%1'>%3 enemies</t> are lurking in that area. Eliminate them and claim their cash and drugs stash", sideMissionColor, _townName, _nbUnits];
};

_waitUntilMarkerPos = nil;
_waitUntilExec = nil;
_waitUntilCondition = nil;

_failedExec =
{
	// Mission failed
	{ deleteVehicle _x } forEach [_vehicle,_box1, _box2];
};



_successExec =
{

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

	// Mission completed
	playSound3D [call currMissionDir + "client\sounds\lastresort.ogg", _box1, false, _box1, 15, 1, 1500];
	{ _x setVariable ["R3F_LOG_disabled", false, true] } forEach [_box1, _box2];

	//Explode the pickup
	_explosivePos = getPosATL (_vehicles select 0);
	_explosive = createMine ["SatchelCharge_F", _explosivePos, [], 0];
	_explosive setDamage 1;


	_drugpilerandomizer = [8,12];
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


	for "_x" from 1 to 5 do
	{
		_cash = "Land_Money_F" createVehicle markerPos _marker;
		_cash setPos ((markerPos _marker) vectorAdd ([[2 + random 2,0,0], random 360] call BIS_fnc_rotateVector2D));
		_cash setDir random 360;
		_cash setVariable["cmoney",5000,true];
		_cash setVariable["owner","world",true];
	};

	_successHintMessage = format ["The last insurgent has take their own life<br/><br/><t color='%1'>%2</t><br/> is a safe place again!<br/> now collect that stash!", sideMissionColor, _townName];
	
};

_this call sideMissionProcessor;