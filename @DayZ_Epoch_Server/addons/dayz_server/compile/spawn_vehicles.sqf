private ["_random","_lastIndex","_index","_vehicle","_velimit","_qty","_isAir","_isShip","_position","_dir","_istoomany","_veh","_objPosition","_iClass","_num","_allCfgLoots"];
// Не требуется _roadList, _buildingList или _serverVehicleCounter в секции Private для этой функции!
#include "\z\addons\dayz_code\util\Math.hpp"
#include "\z\addons\dayz_code\util\Vector.hpp"
#include "\z\addons\dayz_code\loot\Loot.hpp"

while {count AllowedVehiclesList > 0} do
{
	// BIS_fnc_selectRandom заменен потому что Индекс может понадобиться для удаления элемента
	_index 		= 	floor random count AllowedVehiclesList;
	_random 	= 	AllowedVehiclesList select _index;
	_vehicle 	= 	_random select 0;
	_velimit 	= 	_random select 1;

	_qty = {_x == _vehicle} count _serverVehicleCounter;
	if (_qty <= _velimit) exitWith {}; // Если меньше лимита, то можно продолжить

	// Если лимит техники доступен, то удаляем из списка
	// Поскольку элементы не могут быть удалены из массива, переписать его последним элементом и вырезать последний элемент (пока порядок не важен)
	_lastIndex = (count AllowedVehiclesList) - 1;
	if (_lastIndex != _index) then
	{
		AllowedVehiclesList set [_index, AllowedVehiclesList select _lastIndex];
	};
	AllowedVehiclesList resize _lastIndex;
};

if (count AllowedVehiclesList == 0) then
{
	diag_log "[СЕРВЕР] - [spawn_vehicle.sqf]: ОТКЛАДКА: Невозможно найти подходящую случайную Технику для Спавна!";
}
else
{
	// Добавим Технику к Счетчику для следующей процедуры
	_serverVehicleCounter set [count _serverVehicleCounter,_vehicle];

	// Получим Тип техники чтобы лучше контролировать процесс Спавна
	_isAir 		= 	_vehicle isKindOf "Air";
	_isShip 	= 	_vehicle isKindOf "Ship";

	if (_isShip or _isAir) then
	{
		if (_isShip) then
		{
			// Спавним Лодку рядом с берегом на воде
			_position = [getMarkerPos "center",0,((getMarkerSize "center") select 1),10,1,2000,1] call BIS_fnc_findSafePos;
			
			/*
				Переведу и оставлю для Расширенной откладки, которую я сделаю позже.
				Переменная: Server_AdvancedDebug = true;

				diag_log ("[СЕРВЕР] - [spawn_vehicle.sqf]: ОТКЛАДКА: Спавним Лодку у берега на позиции: " + str(_position));
			*/
		}
		else
		{
			// Спавним Воздушную технику на равнине
			_position = [getMarkerPos "center",0,((getMarkerSize "center") select 1),10,0,2000,0] call BIS_fnc_findSafePos;
			
			/*
				Переведу и оставлю для Расширенной откладки, которую я сделаю позже.
				Переменная: Server_AdvancedDebug = true;

				diag_log ("[СЕРВЕР] - [spawn_vehicle.sqf]: ОТКЛАДКА: Спавним Воздушную технику на равнине на позиции: " + str(_position));
			*/
		};
	}
	else
	{
		// Спавним Технику рядом с Постройками и 50% рядом с дорогой
		if ((random 1) > 0.5) then
		{	
			_position 	= 	_roadList call BIS_fnc_selectRandom;	
			_position 	= 	_position modelToWorld [0,0,0];	
			_position 	= 	[_position,0,10,10,0,2000,0] call BIS_fnc_findSafePos;	
			
			/*
				Переведу и оставлю для Расширенной откладки, которую я сделаю позже.
				Переменная: Server_AdvancedDebug = true;

				diag_log ("[СЕРВЕР] - [spawn_vehicle.sqf]: ОТКЛАДКА: Спавним технику рядом с Дорогой на позиции: " + str(_position));
			*/
		}
		else
		{
			_position 	= 	_buildingList call BIS_fnc_selectRandom;	
			_position 	= 	_position modelToWorld [0,0,0];
			_position 	= 	[_position,0,40,5,0,2000,0] call BIS_fnc_findSafePos;

			/*
				Переведу и оставлю для Расширенной откладки, которую я сделаю позже.
				Переменная: Server_AdvancedDebug = true;

				diag_log ("[СЕРВЕР] - [spawn_vehicle.sqf]: ОТКЛАДКА: Спавним технику рядом с Постройкой на позиции: " + str(_position));
			*/	
		};
	};
	
	// Только если Два параметра, если нет, то BIS_fnc_findSafePos выдаст ошибку и Спавн будет в Воздухе
	if ((count _position) == 2) then
	{
		_position set [2,0];
		_dir 		= 	round(random 180);
		_istoomany 	=	_position nearObjects ["AllVehicles",50];
		
		if ((count _istoomany) > 0) exitWith {};
	
		// _veh = createVehicle [_vehicle, _position, [], 0, "CAN_COLLIDE"];
		// _veh setPos _position;
		_veh = _vehicle createVehicle [0,0,0];
		_veh setDir _dir;
		_veh setPos _position;
		_objPosition = getPosATL _veh;
	
		clearWeaponCargoGlobal _veh;
		clearMagazineCargoGlobal _veh;

		// Добавляем 0-3 лута в технику. Используем следующие группы _allCfgLoots(Рандомно!)
		_num = floor(random 4);
		_allCfgLoots = ["Trash","Trash","Consumable","Consumable","Generic","Generic","MedicalLow","MedicalLow","clothes","tents","backpacks","Parts","pistols","AmmoCivilian"];
		
		for "_x" from 1 to _num do
		{
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