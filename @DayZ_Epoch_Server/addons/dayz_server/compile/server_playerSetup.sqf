private ["_characterID","_playerObj","_spawnSelection","_inventory","_playerID","_dummy","_worldspace","_state","_doLoop","_key","_primary","_medical","_stats","_humanity","_randomSpot","_position","_distance","_fractures","_score","_findSpot","_mkr","_j","_isIsland","_w","_clientID","_lastInstance"];

_characterID 		= 	_this select 0;
_playerObj 			= 	_this select 1;
_spawnSelection 	= 	_this select 3;
_inventory 			= 	_this select 4;
_playerID 			= 	getPlayerUID _playerObj;

#include "\z\addons\dayz_server\compile\server_toggle_debug.hpp"

if (isNull _playerObj) exitWith
{
	diag_log ("[СЕРВЕР] - [server_playerSetup.sqf]: ОШИБКА ИНИЦИАЛИЗАЦИИ: Выход, объект игрок обнулен: " + str(_playerObj));
};

if (_playerID == "") then
{
	_playerID = getPlayerUID _playerObj;
};

if (_playerID == "") exitWith
{
	diag_log ("[СЕРВЕР] - [server_playerSetup.sqf]: ОШИБКА ИНИЦИАЛИЗАЦИИ: Выход, игрок не имеет ID: " + str(_playerObj));
};

private "_dummy";
_dummy = getPlayerUID _playerObj;
if (_playerID != _dummy) then
{ 
	diag_log format["[СЕРВЕР] - [server_playerSetup.sqf]: ОТКЛАДКА: _playerID не совпадает с UID! _playerID:%1",_playerID]; 
	
	_playerID = _dummy;
};

_worldspace 	= 	[];
_state 			= 	[];

// Попытка подключения
_doLoop = 0;
while {_doLoop < 5} do
{
	_key = format["CHILD:102: %1:",_characterID];
	_primary = _key call server_hiveReadWrite;
	
	if (count _primary > 0) then
	{
		if ((_primary select 0) != "ERROR") then
		{
			_doLoop = 9;
		};
	};
	_doLoop = _doLoop + 1;
};

if (isNull _playerObj or !isPlayer _playerObj) exitWith
{
	diag_log ("[СЕРВЕР] - [server_playerSetup.sqf]: ИНИЦИАЛИЗАЦИЯ РЕЗУЛЬТАТ: Выход, объект-игрок, обнулен: " + str(_playerObj));
};

// Ждем когда База Данных будет свободна
/*
	Переведу и оставлю для Расширенной БД откладки, которую я сделаю позже.
	Переменная: Server_AdvancedDBDebug = true;

	diag_log ("[СЕРВЕР] - [server_playerSetup.sqf]: ИНИЦИАЛИЗАЦИЯ РЕЗУЛЬТАТ: Успешно с " + str(_primary));
*/

_medical 		= 	_primary select 1;
_stats 			= 	_primary select 2;
_worldspace 	= 	_primary select 4;
_humanity 		= 	_primary select 5;
_lastInstance 	=	_primary select 6;
_randomSpot 	= 	false; 				// Установим позицию

_statearray = if (count _primary >= 4) then 
				{
					_primary select 3
				}
				else
				{
					[""]
				};
if (count _statearray == 0) then
{
	_statearray = [""];
}; 
/*
	Переведу и оставлю для Расширенной откладки, которую я сделаю позже.
	Переменная: Server_AdvancedDebug = true;

	diag_log ("[СЕРВЕР] - [server_playerSetup.sqf]: Состояние Новое: "+str(_statearray));
*/

if (typeName ((_statearray) select 0) == "STRING") then
{
	_statearray = [_statearray,[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]];
};
_state = (_statearray) select 0;
/*
	Переведу и оставлю для Расширенной откладки, которую я сделаю позже.
	Переменная: Server_AdvancedDebug = true;

	diag_log ("[СЕРВЕР] - [server_playerSetup.sqf]: Состояние: "+str(_state));
*/

_Achievements = (_statearray) select 1;
if (count _Achievements == 0) then
{
	_Achievements = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
};
/*
	Переведу и оставлю для Расширенной откладки, которую я сделаю позже.
	Переменная: Server_AdvancedDebug = true;

	diag_log ("[СЕРВЕР] - [server_playerSetup.sqf]: Достижения: "+str(_Achievements));
	
	diag_log ("[СЕРВЕР] - [server_playerSetup.sqf]: WORLDSPACE: "+str(_worldspace));
*/

if (count _worldspace > 0) then
{
	_position = _worldspace select 1;
	if (count _position < 3) exitWith
	{
		_randomSpot = true;		// Предотвращаем Дебаг зону!
	};
	
	_distance = respawn_west_original distance _position;
	if (_distance < 2000) then
	{
		_randomSpot = true;
	};
	
	_distance = [0,0,0] distance _position;
	if (_distance < 500) then
	{
		_randomSpot = true;
	};
	//_playerObj setPosATL _position;
	
	// Берем из другой Инстанции для случайного спавна
	if (_lastInstance != dayZ_instance) then
	{
		_randomSpot = true;
	};
}
else
{
	_randomSpot = true;
};

/*
	Переведу и оставлю для Расширенной откладки, которую я сделаю позже.
	Переменная: Server_AdvancedDebug = true;

	diag_log ("[СЕРВЕР] - [server_playerSetup.sqf]: ВХОД: Локация: " + str(_worldspace) + " doRnd?: " + str(_randomSpot));
*/

// Установим медицинские значения
if (count _medical > 0) then
{
	_playerObj setVariable ["USEC_isDead",(_medical select 0),true];
	_playerObj setVariable ["NORRN_unconscious",(_medical select 1),true];
	_playerObj setVariable ["USEC_infected",(_medical select 2),true];
	_playerObj setVariable ["USEC_injured",(_medical select 3),true];
	_playerObj setVariable ["USEC_inPain",(_medical select 4),true];
	_playerObj setVariable ["USEC_isCardiac",(_medical select 5),true];
	_playerObj setVariable ["USEC_lowBlood",(_medical select 6),true];
	_playerObj setVariable ["USEC_BloodQty",(_medical select 7),true];

	// Добавляем кровоточащие раны
	{
		_playerObj setVariable ["hit_"+_x,true,true];
	} forEach (_medical select 8);

	// Добавляем переломы
	_fractures = _medical select 9;
	_playerObj setVariable ["hit_legs",(_fractures select 0),true];
	_playerObj setVariable ["hit_hands",(_fractures select 1),true];
	_playerObj setVariable ["unconsciousTime",(_medical select 10),true];
	_playerObj setVariable ["messing",if (count _medical >= 14) then {(_medical select 13)} else {[0,0,0]},true];
	_playerObj setVariable ["blood_testdone",if (count _medical >= 15) then {(_medical select 14)} else {false},true];
	
	if (count _medical > 12 && {typeName (_medical select 11) == "STRING"}) then	// У старого персонажа не было "messing" или "messing" на месте blood_type
	{
		_playerObj setVariable ["blood_type",(_medical select 11),true];
		_playerObj setVariable ["rh_factor",(_medical select 12),true];
		/*
			Переведу и оставлю для Расширенной откладки, которую я сделаю позже.
			Переменная: Server_AdvancedDebug = true;

			diag_log ("[СЕРВЕР] - [server_playerSetup.sqf]: Данные игрока: blood_type,rh_factor,testdone=",_playerObj getVariable ["blood_type", "?"],_playerObj getVariable ["rh_factor", "?"], _playerObj getVariable ["blood_testdone", false]];
		*/
	}
	else
	{
		_playerObj call player_bloodCalc;
		diag_log ["[СЕРВЕР] - [server_playerSetup.sqf]: Данные игрока обновлены до 1.8.3: blood_type,rh_factor=",_playerObj getVariable ["blood_type", "?"],_playerObj getVariable ["rh_factor", "?"]];
	};
}
else
{
	// Сбросим кровоточащие раны
	call fnc_usec_resetWoundPoints;
	// Сбросим переломы
	_playerObj setVariable ["hit_legs",0,true];
	_playerObj setVariable ["hit_hands",0,true];
	_playerObj setVariable ["USEC_injured",false,true];
	_playerObj setVariable ["USEC_inPain",false,true];
	_playerObj call player_bloodCalc; // установим blood_type и rh_factor согласно статистике
	
	/*
		Переведу и оставлю для Расширенной откладки, которую я сделаю позже.
		Переменная: Server_AdvancedDebug = true;

		diag_log [ "Данные игрока Установка: blood_type,rh_factor=",_playerObj getVariable ["blood_type", "?"],_playerObj getVariable ["rh_factor", "?"]];
	*/
	
	_playerObj setVariable ["messing",[0,0,0],true];
	_playerObj setVariable ["blood_testdone",false,true];
};

if (count _stats > 0) then
{
	// Регистрируем статистику
	_playerObj setVariable ["zombieKills",(_stats select 0),true];
	_playerObj setVariable ["headShots",(_stats select 1),true];
	_playerObj setVariable ["humanKills",(_stats select 2),true];
	_playerObj setVariable ["banditKills",(_stats select 3),true];
	
	// Подтвержденные убийства
	_playerObj setVariable ["ConfirmedHumanKills",(_stats select 2),true];
	_playerObj setVariable ["ConfirmedBanditKills",(_stats select 3),true];
	
	_playerObj addScore (_stats select 1);
	
	// Сохраняем результат 
	_score = score _playerObj;
	_playerObj addScore ((_stats select 0) - _score);

	// Записываем на сервер JIP проверки
	_playerObj setVariable ["zombieKills_CHK",(_stats select 0)];
	_playerObj setVariable ["headShots_CHK",(_stats select 1)];

	if (count _stats > 4) then
	{
		if !(_stats select 3) then
		{
			_playerObj setVariable ["selectSex",true,true];
		};
	}
	else
	{
		_playerObj setVariable ["selectSex",true,true];
	};
}
else
{
	// Регистрируем статистику
	_playerObj setVariable ["zombieKills",0,true];
	_playerObj setVariable ["humanKills",0,true];
	_playerObj setVariable ["banditKills",0,true];
	_playerObj setVariable ["headShots",0,true];
	
	// Подтвержденные убийства
	_playerObj setVariable ["ConfirmedHumanKills",0,true];
	_playerObj setVariable ["ConfirmedBanditKills",0,true];

	// Записываем на сервер JIP проверки
	_playerObj setVariable ["zombieKills_CHK",0];
	_playerObj setVariable ["headShots_CHK",0];
};

if (_randomSpot) then
{
	private ["_counter","_position","_isNear","_isZero","_mkr"];
	if (!isDedicated) then
	{
		endLoadingScreen;
	};
	
	_IslandMap = (toLower worldName in ["caribou","cmr_ovaron","dayznogova","dingor","dzhg","fallujah","fapovo","fdf_isle1_a","isladuala","lingor","mbg_celle2","namalsk","napf","oring","panthera2","sara","sauerland","smd_sahrani_a2","tasmania2010","tavi","trinity","utes"]);

	// Спавним рандомно
	_findSpot 	= 	true;
	_mkr 		= 	[];
	_position 	= 	[0,0,0];
	for [{_j=0}, {_j<=100 && _findSpot}, {_j=_j+1}] do
	{
		if (_spawnSelection == 9) then
		{
			// Рандомная точка спавна выбрана, получаем маркер и спавним где-нибудь
			if (dayz_spawnselection == 1) then
			{
				_mkr = getMarkerPos ("spawn" + str(floor(random 6)));
			}
			else
			{
				_mkr = getMarkerPos ("spawn" + str(floor(random actualSpawnMarkerCount)));
			};
		}
		else
		{
			// Спавн не рандомный, спавним где было выбрано
			_mkr = getMarkerPos ("spawn" + str(_spawnSelection));
		};
		
		_position = ([_mkr,0,spawnArea,10,0,2,spawnShoremode] call BIS_fnc_findSafePos);
		if ((count _position >= 2) 		// !Плохая возвращаемая позиция
			&& {(_position distance _mkr < spawnArea)}) then 		// !Вне зоны
			{
				_position set [2, 0];
			
				if (((ATLtoASL _position) select 2 > 2.5) 		// !Игрок в воде
				&& {({alive _x} count (_position nearEntities ["CAManBase",150]) == 0)}) then	 // !Слишком близко к другим игрокам/зомби
				{
					_pos 		= 	+(_position);
					_isIsland 	= 	false; 			// Во время проверки может быть значение true
					
					// Проверяем 809-метров линии, с шагом в 5 метров
					for [{_w = 0}, {_w != 809}, {_w = ((_w + 17) % 811)}] do 
					{
						//if (_w < 17) then
						//{
						//	diag_log format[[СЕРВЕР] - [server_playerSetup.sqf]: "%1 цикл начат с _w=%2", __FILE__, _w];
						//};
					_pos = [((_pos select 0) - _w),((_pos select 1) + _w),(_pos select 2)];
					
					if ((surfaceisWater _pos) && !_IslandMap) exitWith
					{
						_isIsland = true;
					};
				};
				if (!_isIsland) then
				{
					_findSpot = false
				};
			};
		};
		
		/*
			Переведу и оставлю для Расширенной откладки, которую я сделаю позже.
			Переменная: Server_AdvancedDebug = true;

			diag_log format["[СЕРВЕР] - [server_playerSetup.sqf]: %1: Позиция:%2 _findSpot:%3", __FILE__, _position, _findSpot];
		*/
	};
	
	if (_findSpot && !_IslandMap) exitWith
	{
		diag_log format["[СЕРВЕР] - [server_playerSetup.sqf]: %1: Ошибка, Не удалось найти подходящее место для спавна игрока. Зона: %2",__FILE__, _mkr];
	};
	_worldspace = [0,_position];
};

// Запишем позицию игрока Локально для Проверок сервером
_playerObj setVariable ["characterID",_characterID,true];
_playerObj setVariable ["humanity",_humanity,true];
_playerObj setVariable ["humanity_CHK",_humanity];
_playerObj setVariable ["lastPos",getPosATL _playerObj];

PVCDZ_plr_Login2 = [_worldspace,_state];
_clientID = owner _playerObj;
_clientID publicVariableClient "PVCDZ_plr_Login2";

if (dayz_townGenerator) then
{
	_clientID publicVariableClient "PVCDZ_plr_plantSpawner";
};

// Запишем время старта
_playerObj setVariable ["lastTime",time];

// Установим на стороне сервера Переменную инвентаря чтобы мониторить лут игрока
if (count _inventory > 2) then
{
	_playerObj setVariable ["ServerMagArray",[_inventory select 1,_inventory select 2], false];
};


// Запишем Login/LogOut игрока
[_playerID,_characterID,1,(_playerObj call fa_plr2str),((_worldspace select 1) call fa_coor2str)] call dayz_recordLogin;

PVDZ_plr_Login1 = null;
[_playerObj] spawn Ultima_Proc_Server_Admin_Data;	// Строка для сервера FireFly (*/Scripts/Ultima_Admin/*). Если у вас Нет этого скрипта - Удалите строчку!
PVDZ_plr_Login2 = null;