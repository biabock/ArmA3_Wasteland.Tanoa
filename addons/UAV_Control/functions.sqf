//	@file Name: functions.sqf
//	@file Author: IvanMMM, micovery, AgentRev

scopeName "UAV_Control";
private ["_perm", "_uav", "_uavTerminal", "_currUav"];
_perm = ["A3W_uavControl", "side"] call getPublicVar;

if (_perm == "side") then
{
	if (playerSide in [BLUFOR,OPFOR]) exitWith
	{
		breakOut "UAV_Control";
	};

	_perm = "group"; // always enforce group-only for indies if A3W_uavControl is side
};

while {true} do
{
	waitUntil {sleep 0.1; _uav = getConnectedUAV player; !isNull _uav};

	// ignore remote designators and autoturrets unless indie
	if (!(_uav isKindOf "StaticWeapon") || !(playerSide in [BLUFOR,OPFOR])) then
	{
		_ownerUID = _uav getVariable ["ownerUID", "0"];

		if (_ownerUID in ["","0"]) exitWith {}; // UAV not owned by anyone

		_ownerGroup = _uav getVariable ["ownerGroupUAV", grpNull];

		if (getPlayerUID player == _ownerUID) exitWith
		{
			if (_ownerGroup != group player) then
			{
				_ownerGroup = group player;
				_uav setVariable ["ownerGroupUAV", _ownerGroup, true]; // not currently used
			};
		};

		if (_perm == "group" && {_ownerUID in ((units player) apply {getPlayerUID _x})}) exitWith {};

		switch (playerSide) do
		{
			case BLUFOR: { _uavTerminal = "B_UavTerminal" };
			case OPFOR:	 { _uavTerminal = "O_UavTerminal" };
			default	     { _uavTerminal = "I_UavTerminal" };
		};
		player connectTerminalToUAV objNull;
		{ player unassignItem _x } forEach ["B_UavTerminal", "O_UavTerminal", "I_UavTerminal"]; // unassign uav terminal
		{ player removeItem _x } forEach ["B_UavTerminal", "O_UavTerminal", "I_UavTerminal"]; // remove the uav terminal
		playSound "FD_CP_Not_Clear_F";
		["You are not allowed to connect to this unmanned vehicle. Your terminal will be replaced.", 5] call mf_notify_client;
		sleep 5;
		player linkItem _uavTerminal;
	};

	if (alive _uav && _uav == getConnectedUAV player) then
	{
		_uav call fn_forceSaveVehicle;

		/*if (group _currUav != group player) then
		{
			(crew _currUav) joinSilent group player;
		};*/
	};

	waitUntil {sleep 0.1; _uav != getConnectedUAV player};
};
