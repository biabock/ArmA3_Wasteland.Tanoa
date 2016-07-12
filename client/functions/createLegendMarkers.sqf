// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: createLegendMarkers.sqf
//	@file Author: AgentRev

_markers =
[
	["Arma Brothers", "EmptyIcon", "ColorWhite", [1,1]],
	["wwww.armabrothers.com", "EmptyIcon", "ColorWhite", [1,1]],
	["", "EmptyIcon", "ColorWhite", [1,1]],
	["Legend:", "EmptyIcon", "ColorWhite", [1,1]],

	["Gun Store", "mil_dot", "ColorYellow", [1,1]],
	["Gun Store (Enemies)", "mil_dot", "ColorRed", [1,1]],
	["Gun Store (Allies)", "mil_dot", "ColorGreen", [1,1]],
	["General Store", "mil_dot", "ColorBlue", [1,1]],
	["Vehicle Store", "mil_dot", "ColorOrange", [1,1]]
];


if (["A3W_privateParking"] call isConfigOn) then
{
	_markers pushBack ["Personal Garage", "mil_box", "ColorCIV", [0.5,0.5]];
};

if (["A3W_privateStorage"] call isConfigOn) then
{
	_markers pushBack ["Personal Storage", "mil_box", "ColorUNKNOWN", [0.5,0.5]];
};

_mapSize = getNumber (configFile >> "CfgWorlds" >> worldName >> "mapSize");
_markerSpacing = 0.025 * _mapSize;
_legendMarginX = 0.035 * _mapSize;
_legendMarginY = 0.035 * _mapSize;
_markerX = _mapSize + _legendMarginX;
_legendTop = _legendMarginY + (_markerSpacing * (count _markers - 1));

{
	_x params ["_text", "_type", "_color", "_size"];

	_marker = format ["LegendMarker%1", _forEachIndex];
	_posX = _markerX - ([0, 0.02 * _mapSize] select (_type == "EmptyIcon"));
	_posY = _legendTop - (_forEachIndex * _markerSpacing);

	deleteMarkerLocal _marker;
	createMarkerLocal [_marker, [_posX, _posY]];

	_marker setMarkerTextLocal _text;
	_marker setMarkerTypeLocal _type;
	_marker setMarkerColorLocal _color;
	_marker setMarkerSizeLocal _size;
	_marker setMarkerShapeLocal "ICON";

} forEach _markers;
