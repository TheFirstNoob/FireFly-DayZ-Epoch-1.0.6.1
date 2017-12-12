#include "\z\addons\dayz_server\compile\server_toggle_debug.hpp"

[] execVM "\z\addons\dayz_server\init\AH.sqf";
//[] call compile preprocessFileLineNumbers "\z\addons\dayz_server\scripts\Ultima_Admins\Ultima_Admins_Init.sqf";

waitUntil {!isNil "bis_fnc_init"};

BIS_MPF_remoteExecutionServer =
{
	if ((_this select 1) select 2 == "JIPrequest") then
	{
		[nil,(_this select 1) select 0,"loc",rJIPEXEC,[any,any,"per","execVM","ca\Modules\Functions\init.sqf"]] call RE;
	};
};

call compile preprocessFileLineNumbers "\z\addons\dayz_code\util\compile.sqf";
call compile preprocessFileLineNumbers "\z\addons\dayz_code\loot\compile.sqf";

BIS_Effects_Burn 		= 	{};
dayz_disconnectPlayers 	= 	[];

server_playerLogin 			= 	compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_playerLogin.sqf";
server_playerSetup 			= 	compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_playerSetup.sqf";
server_onPlayerDisconnect 	= 	compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_onPlayerDisconnect.sqf";
server_updateObject 		= 	compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_updateObject.sqf";
server_playerDied 			= 	compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_playerDied.sqf";
server_publishObj 			= 	compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_publishObject.sqf";			// Создает объекты в Базе Данных
server_deleteObj 			= 	compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_deleteObj.sqf"; 			// Удаляет объекты из Базы Данных
server_playerSync 			= 	compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_playerSync.sqf";
zombie_findOwner 			= 	compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\zombie_findOwner.sqf";
server_Wildgenerate 		= 	compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\zombie_Wildgenerate.sqf";
base_fireMonitor 			= 	compile preprocessFileLineNumbers "\z\addons\dayz_code\system\fire_monitor.sqf";
//server_systemCleanup 		= 	compile preprocessFileLineNumbers "\z\addons\dayz_server\system\server_cleanup.sqf";
spawnComposition 			= 	compile preprocessFileLineNumbers "ca\modules\dyno\data\scripts\objectMapper.sqf"; 					// "\z\addons\dayz_code\compile\object_mapper.sqf";
server_sendToClient 		= 	compile preprocessFileLineNumbers "\z\addons\dayz_server\eventHandlers\server_sendToClient.sqf";

server_addCargo 		= 	compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_addCargo.sqf";
server_swapObject 		= 	compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_swapObject.sqf"; 			// Для построек Epoch
server_publishVeh 		= 	compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_publishVehicle.sqf"; 		// Для рандомного спавна техники
server_publishVeh2 		= 	compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_publishVehicle2.sqf"; 		// Для покупки техники
server_publishVeh3 		= 	compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_publishVehicle3.sqf"; 		// Для Улучшения техники
server_tradeObj 		= 	compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_tradeObject.sqf";
server_traders 			= 	compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_traders.sqf";
server_spawnEvents 		= 	compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_spawnEvent.sqf";
server_deaths 			= 	compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_playerDeaths.sqf";
server_maintainArea 	= 	compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_maintainArea.sqf";
server_checkIfTowed 	= 	compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_checkIfTowed.sqf";
server_handleSafeGear 	= 	compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_handleSafeGear.sqf";
spawn_ammosupply 		= 	compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\spawn_ammosupply.sqf";
spawn_mineveins 		= 	compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\spawn_mineveins.sqf";
spawn_roadblocks 		= 	compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\spawn_roadblocks.sqf";
spawn_vehicles 			= 	compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\spawn_vehicles.sqf";

server_medicalSync =
{
	_player 	= 	_this select 0;
	_array 		= 	_this select 1;
	
	_player setVariable ["USEC_isDead",(_array select 0)]; //0
	_player setVariable ["NORRN_unconscious",(_array select 1)]; //1
	_player setVariable ["USEC_infected",(_array select 2)]; //2
	_player setVariable ["USEC_injured",(_array select 3)]; //3
	_player setVariable ["USEC_inPain",(_array select 4)]; //4
	_player setVariable ["USEC_isCardiac",(_array select 5)]; //5
	_player setVariable ["USEC_lowBlood",(_array select 6)]; //6
	_player setVariable ["USEC_BloodQty",(_array select 7)]; //7
	// _wounds; //8
	// [_legs,_arms]; //9
	_player setVariable ["unconsciousTime",(_array select 10)]; //10
	_player setVariable ["blood_type",(_array select 11)]; //11
	_player setVariable ["rh_factor",(_array select 12)]; //12
	_player setVariable ["messing",(_array select 13)]; //13
	_player setVariable ["blood_testdone",(_array select 14)]; //14
};
/*
dayz_Achievements = {
	_achievementID = (_this select 0) select 0;
	_player = (_this select 0) select 1;
	_playerOwnerID = owner _player;
	
	_achievements = _player getVariable "Achievements";
	_achievements set [_achievementID,1];
	_player setVariable ["Achievements",_achievements];
};
*/

// Отправляет Забор в Массив для синхронизации с Базой Данных, так будет быстрее чем обновлять при каждом получении урона.
server_addtoFenceUpdateArray =
{
	// Проблема: Не может точно сказать кто наносит урон
	if ((_this select 0) isKindOf "DZ_buildables") then
	{
		(_this select 0) setDamage (_this select 1);

		if !((_this select 0) in needUpdate_FenceObjects) then
		{
			needUpdate_FenceObjects set [count needUpdate_FenceObjects, (_this select 0)];
		};
	};
};


vehicle_handleServerKilled =
{
	private ["_unit","_killer"];
	_unit 		= 	_this select 0;
	_killer 	= 	_this select 1;

	[_unit, "killed"] call server_updateObject;	
	_unit removeAllMPEventHandlers "MPKilled";
	_unit removeAllEventHandlers "Killed";
	_unit removeAllEventHandlers "HandleDamage";
	_unit removeAllEventHandlers "GetIn";
	_unit removeAllEventHandlers "GetOut";
};

check_publishobject =
{
	private ["_saveObject","_allowed","_allowedObjects","_object","_playername"];

	_object 		= 	_this select 0;
	_playername 	= 	_this select 1;
	_allowed 		= 	false;

	#ifdef OBJECT_DEBUG
		diag_log format["[СЕРВЕР] - [server_functions.sqf]: ОТКЛАДКА: Проверяем! Если Объект: %1 разрешен, то опубликуем его от: %2",_object,_playername];
	#endif

	if ((typeOf _object) in DayZ_SafeObjects) then
	{
		_saveObject 	= 	"DayZ_SafeObjects";
		_allowed 		= 	true;
	};
	
	if (_object isKindOf "DZ_buildables") then
	{
		_saveObject = "DZ_buildables";
		_allowed = true;
	};
	
	#ifdef OBJECT_DEBUG
		diag_log format["[СЕРВЕР] - [server_functions.sqf]: ОТКЛАДКА: Объект: %1 Опубликован от: %2 Разрешен от: %3",_object,_playername,_saveObject];
	#endif

	_allowed
};

server_hiveWrite =
{
	private "_data";
	//diag_log ("ATTEMPT WRITE: " + _this);		// Позже
	_data = "HiveExt" callExtension _this;
	//diag_log ("WRITE: " +str(_data));			// Позже
};

server_hiveReadWrite =
{
	private ["_key","_resultArray","_data"];
	_key = _this;
	//diag_log ("ATTEMPT READ/WRITE: " + _key);			// Позже
	_data = "HiveExt" callExtension _key;
	//diag_log ("READ/WRITE: " +str(_data));			// Позже
	_resultArray = call compile str formatText["%1", _data];
	
	if (isNil "_resultArray") then
	{
		_resultArray = "HIVE CONNECTION ERROR";
	};
	_resultArray
};

onPlayerDisconnected "[_uid,_name] call server_onPlayerDisconnect;";

server_getDiff =
{
	private ["_variable","_object","_vNew","_vOld","_result"];
	_variable 	= 	_this select 0;
	_object 	= 	_this select 1;
	_vNew 		= 	_object getVariable [_variable,0];
	_vOld 		= 	_object getVariable [(_variable + "_CHK"),_vNew];
	_result 	= 	0;
	
	if (_vNew < _vOld) then
	{
		_vNew = _vNew + _vOld;
		_object getVariable [(_variable + "_CHK"),_vNew];
	}
	else
	{
		_result = _vNew - _vOld;
		_object setVariable [(_variable + "_CHK"),_vNew];
	};
	_result
};

server_getDiff2 =
{
	private ["_variable","_object","_vNew","_vOld","_result"];
	_variable 	= 	_this select 0;
	_object 	= 	_this select 1;
	_vNew 		= 	_object getVariable [_variable,0];
	_vOld 		= 	_object getVariable [(_variable + "_CHK"),_vNew];
	_result 	= 	_vNew - _vOld;
	_object setVariable [(_variable + "_CHK"),_vNew];
	_result
};

// Макс 19 цифр
dayz_objectUID2 =
{
    private["_position","_dir","_time" ,"_key"];
	_dir 	= 	_this select 0;
	_time 	= 	round diag_tickTime;
	
	if (_time > 99999) then
	{
		_time = round(random 99999);	// Убираем переполнение, если сервер не рестартиться
	};
	_key 		= 	"";
	_position 	= 	_this select 1;
	_key 		= 	format["%1%2%3%4", round(_time + abs(_position select 0)), round(_dir), round(abs(_position select 1)), _time];
	_key;
};

dayz_recordLogin =
{
	private ["_key","_status","_name"];
	_key = format["CHILD:103:%1:%2:%3:",_this select 0,_this select 1,_this select 2];
	_key call server_hiveWrite;
		
	_status = switch (1==1) do {
		case ((_this select 2) == 0): { "КЛИЕНТ ЗАГРУЖЕН И ИГРАЕТ!" };
		case ((_this select 2) == 1): { "ЛОГИН ОПУБЛИКОВАН, Локация: " +(_this select 4) };
		case ((_this select 2) == 2): { "ВХОД УСПЕШЕН" };
		case ((_this select 2) == 3): { "ВЫШЕЛ С СЕРВЕРА, Локация: " +(_this select 4) };
	};
	
	_name = if (typeName (_this select 3) == "ARRAY") then
	{
		toString (_this select 3)
	}
	else
	{
		_this select 3
	};
	
	diag_log format["[СЕРВЕР] - [server_functions.sqf]: ИНФОРМАЦИЯ - Игрок: %1(UID:%3/CID:%4) Статус: %2",_name,_status,(_this select 0),(_this select 1)];
};

generate_new_damage =
{
	private "_damage";
    _damage = ((random(DynamicVehicleDamageHigh-DynamicVehicleDamageLow))+DynamicVehicleDamageLow) / 100;
	_damage
};

server_hiveReadWriteLarge =
{
	private["_key","_resultArray","_data"];
	_key 			= 	_this;
	_data 			= 	"HiveExt" callExtension _key;
	_resultArray 	= 	call compile _data;
	_resultArray
};

// coor2str: Конвертация Позиции в GPS коодинаты
fa_coor2str =
{
	private["_pos","_res","_nearestCity","_town"];

	_pos = +(_this);
	if (count _pos < 1) then
	{
		_pos = [0,0];
	}
	else
	{
		if (count _pos < 2) then
		{
			_pos = [_pos select 0,0];
		};
	};
	
	_nearestCity = nearestLocations [_pos, ["NameCityCapital","NameCity","NameVillage","NameLocal"],1000];
	_town = "Wilderness";
	
	if (count _nearestCity > 0) then
	{
		_town = text (_nearestCity select 0)
	};
	_res = format["%1 [%2]", _town, mapGridPosition _pos];

	_res
};

// Пишем игрока, PID и имя. Если имя неизвестно пишем UID.
fa_plr2str =
{
	private["_x","_res","_name"];
	_x 		= 	_this;
	_res 	= 	"nobody";
	
	if (!isNil "_x") then
	{
		_name = _x getVariable ["bodyName", nil];
		
		if ((isNil "_name" OR {(_name == "")}) AND ({alive _x})) then
		{
			_name = name _x;
		};
		
		if (isNil "_name" OR {(_name == "")}) then
		{
			_name = "UID#"+(getPlayerUID _x);
		};
		
		_res = format["PID#%1(%2)", owner _x, _name ];
	};
	_res
};

array_reduceSize =
{
	private ["_array1","_array","_count","_num"];
	_array1 	= 	_this select 0;
	_array 		= 	_array1 - ["Hatchet_Swing","Crowbar_Swing","Machete_Swing","Bat_Swing","BatBarbed_Swing","BatNails_Swing","Fishing_Swing","Sledge_Swing","CSGAS"];
	_count 		= 	_this select 1;
	_num 		= 	count _array;
	
	if (_num > _count) then
	{
		_array resize _count;
	};
	_array
};

call compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\kk_functions.sqf";
#include "mission_check.sqf"
