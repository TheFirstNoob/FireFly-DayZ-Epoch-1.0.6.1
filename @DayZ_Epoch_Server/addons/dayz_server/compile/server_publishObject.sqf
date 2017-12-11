#include "\z\addons\dayz_server\compile\server_toggle_debug.hpp"

private ["_type","_objectUID","_characterID","_object","_worldspace","_key","_ownerArray","_inventory"];

_characterID 	=	_this select 0;
_object 		=	_this select 1;
_worldspace 	=	_this select 2;
_inventory 		=	_this select 3;

if (typeName _inventory != "ARRAY") then
{
	_inventory = [];	// Временный фикс ошибки в player_build.sqf в 1.0.6 release
};

_type = typeOf _object;

if ([_object, "Server"] call check_publishobject) then
{
	//diag_log ("PUBLISH: Attempt " + str(_object));	// Позже

	_objectUID = _worldspace call dayz_objectUID2;
	_object setVariable ["ObjectUID", _objectUID, true];
	
	// Мы не можем использовать getVariable потому что Сервер знает только об создаваемом объекте (position,direction,variables еще не синхронизируются!)
	//_characterID 	= 	_object getVariable [ "characterID", 0 ];
	//_ownerArray 	= 	_object getVariable [ "ownerArray", [] ];
	//_key 			= 	format["CHILD:308:%1:%2:%3:%4:%5:%6:%7:%8:%9:", dayZ_instance, _type, 0, _characterID, _worldspace, _inventory, [], 0,_objectUID ];
	
	_key = format["CHILD:308:%1:%2:%3:%4:%5:%6:%7:%8:%9:",dayZ_instance, _type, 0 , _characterID, _worldspace call AN_fnc_formatWorldspace, _inventory, [], 0,_objectUID]; // KK_Functions.sqf

	_key call server_hiveWrite;

	if !(_object isKindOf "TrapItems") then
	{
		if (DZE_GodModeBase && {!(_type in DZE_GodModeBaseExclude)}) then
		{
			_object addEventHandler ["HandleDamage", {false}];
		}
		else
		{
			_object addMPEventHandler ["MPKilled",{_this call vehicle_handleServerKilled;}];
		};
	};
	
	// Попытка отключить Симуляцию для построек на Серверной стороне.
	_object enableSimulation false;

	dayz_serverObjectMonitor set [count dayz_serverObjectMonitor,_object];

	#ifdef OBJECT_DEBUG
		diag_log ["[СЕРВЕР] - [server_publishObject.sqf]: ПУБЛИЧНО: Создано ",_type,"ObjectUID", _objectUID,"characterID", _characterID, " с Переменной/Инвентарем:", _inventory ];
	#endif
}
else
{
	#ifdef OBJECT_DEBUG
		diag_log ("[СЕРВЕР] - [server_publishObject.sqf]: ПУБЛИЧНО: *НЕ* создан " + (_type ) + " (Нет разрешения!)");
	#endif
};
