/*
	Случайно создает "Supply_Crate_DZE" по карте.
	Лутаемое! Ломаем и открываем Ломом (Crossbar).
	Определяет Вооружение для техники в Land_ammo_supply_wreck CfgVehicles класс.
*/

private ["_position","_veh","_istoomany"];
// Не требуется _roadList или _buildingList в секции Private для этой функции!

_position 	= 	_roadList call BIS_fnc_selectRandom;
_position 	= 	_position modelToWorld [0,0,0];
_position 	= 	[_position,5,20,5,0,2000,0] call BIS_fnc_findSafePos;

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