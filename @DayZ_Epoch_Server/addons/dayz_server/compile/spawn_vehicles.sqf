private ["_random","_lastIndex","_index","_vehicle","_velimit","_qty","_isAir","_isShip","_position","_dir","_istoomany","_veh","_objPosition","_iClass","_num","_allCfgLoots"];
// Не используйте _roadList или _buildingList в функции private
#include "\z\addons\dayz_code\util\Math.hpp"
#include "\z\addons\dayz_code\util\Vector.hpp"
#include "\z\addons\dayz_code\loot\Loot.hpp"

while {count AllowedVehiclesList > 0} do
{
	// BIS_fnc_selectRandom заменен потому что потому что индекс может понадобиться для удаления элемента
	_index 		= 	floor random count AllowedVehiclesList;
	_random 	= 	AllowedVehiclesList select _index;
	_vehicle 	= 	_random select 0;
	_velimit 	= 	_random select 1;

	_qty = {_x == _vehicle} count _serverVehicleCounter;
	if (_qty <= _velimit) exitWith {}; // Если меньше лимита, то можно продолжить

	// Лимит достигнут - убираем технику
	// Некотрые элементы не могут быть удалены из массива, перезапишите его последним элементом и вырезать последний элемент (пока порядок не важен)
	_lastIndex = (count AllowedVehiclesList) - 1;
	if (_lastIndex != _index) then {AllowedVehiclesList set [_index, AllowedVehiclesList select _lastIndex];};
	AllowedVehiclesList resize _lastIndex;
};

if (count AllowedVehiclesList == 0) then
{
	diag_log "[СЕРВЕР] - [spawn_vehicles.sqf]: ОТКЛАДКА: Неудается найти удобную позицию для спавна техники";
}
else
{
	// Добавляем значение к следущей сессии
	_serverVehicleCounter set [count _serverVehicleCounter,_vehicle];

	// Определяем тип техники
	_isAir = _vehicle isKindOf "Air";
	_isShip = _vehicle isKindOf "Ship";

	if (_isShip or _isAir) then
	{
		if (_isShip) then
		{
			// Спавним где-нибудь на берегу/на воде
			_position = [getMarkerPos "center",0,((getMarkerSize "center") select 1),10,1,2000,1] call BIS_fnc_findSafePos;
			//diag_log("DEBUG: spawning boat near coast " + str(_position));	// Позже
		}
		else
		{
			// Спавним где-нибудь где ровно
			_position = [getMarkerPos "center",0,((getMarkerSize "center") select 1),10,0,2000,0] call BIS_fnc_findSafePos;
			//diag_log("DEBUG: spawning air anywhere flat " + str(_position));	// Позже
		};
	}
	else
	{
		// Спавним рядом с постройками и 50% на дорогах
		if ((random 1) > 0.5) then
		{	
			_position = _roadList call BIS_fnc_selectRandom;	
			_position = _position modelToWorld [0,0,0];	
			_position = [_position,0,10,10,0,2000,0] call BIS_fnc_findSafePos;	
			//diag_log("DEBUG: spawning near road " + str(_position)); 	// Позже
		} else {
			_position = _buildingList call BIS_fnc_selectRandom;	
			_position = _position modelToWorld [0,0,0];
			_position = [_position,0,40,5,0,2000,0] call BIS_fnc_findSafePos;	
			//diag_log("DEBUG: spawning around buildings " + str(_position)); 	// Позже
		};
	};
	
	// только если два параметра, в противном случае BIS_fnc_findSafePos провалился и техника может появиться в воздухе
	if ((count _position) == 2) then
	{
		_position set [2,0];
		_dir 		= 	round(random 180);
		_istoomany 	= 	_position nearObjects ["AllVehicles",50];
		if ((count _istoomany) > 0) exitWith {};
	
		//_veh = createVehicle [_vehicle, _position, [], 0, "CAN_COLLIDE"];
		//_veh setPos _position;
		_veh = _vehicle createVehicle [0,0,0];
		_veh setDir _dir;
		_veh setPos _position;
		_objPosition = getPosATL _veh;
	
		clearWeaponCargoGlobal  _veh;
		clearMagazineCargoGlobal  _veh;

		// Добавляем лут в технику
		_num = floor(random 4);
		_allCfgLoots = ["Trash","Trash","Consumable","Consumable","Generic","Generic","MedicalLow","MedicalLow","clothes","tents","backpacks","Parts","pistols","AmmoCivilian"];
		
		for "_x" from 1 to _num do {
			_iClass 			= 	_allCfgLoots call BIS_fnc_selectRandom;
			_lootGroupIndex 	= 	dz_loot_groups find _iClass;
			Loot_InsertCargo(_veh, _lootGroupIndex, 1);
		};

		[_veh,[_dir,_objPosition],_vehicle,true,"0"] call server_publishVeh;
		
		if (_num > 0) then
		{
			_vehiclesToUpdate set [count _vehiclesToUpdate,_veh];
		};
	};
};