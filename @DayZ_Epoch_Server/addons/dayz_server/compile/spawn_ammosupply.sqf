private ["_position","_veh","_istoomany"];
// Не используйте _roadList или _buildingList в функции private

_position = _roadList call BIS_fnc_selectRandom;
_position = _position modelToWorld [0,0,0];
_position = [_position,5,20,5,0,2000,0] call BIS_fnc_findSafePos;

if ((count _position) == 2) then
{
	_istoomany = _position nearObjects ["All",5];
	if ((count _istoomany) > 0) exitWith {};
	
	//_veh = createVehicle ["Supply_Crate_DZE",_position, [], 0, "CAN_COLLIDE"];
	_veh = "Supply_Crate_DZE" createVehicle [0,0,0];
	_veh enableSimulation false;
	_veh setDir round(random 360);
	_veh setPos _position;
	_veh setVariable ["ObjectID","1",true];
};