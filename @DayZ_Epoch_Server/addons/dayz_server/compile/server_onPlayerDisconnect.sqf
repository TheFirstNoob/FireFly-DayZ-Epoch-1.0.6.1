/*
	ПРЕДУПРЕЖДЕНИЕ: Живые игроки будут удалены Arma вскоре после onPlayerDisconnected стрельбы
	потому что DayZ использует disabledAI = 1 https://community.bistudio.com/wiki/Description.ext#disabledAI
	
	Ссылаемся на игрока после того, как этот пункт вернет objNull, поэтому эта функция
	и server_playerSync должы пройти быстро или Игрок Не будет сохранен.
*/

private ["_playerObj","_playerUID","_playerPos","_playerName","_characterID","_inCombat","_Sepsis"];

_playerUID 		= 	_this select 0;
_playerName 	= 	_this select 1;
_playerObj 		= 	nil;

// Ищем всех Игроков по соотвествующему UID
// Если игрок умер, то новый Юнит, после спавна, будет найден (respawnDelay = 0 в description.ext)
{
	if ((getPlayerUID _x) == _playerUID) exitWith
	{
		_playerObj = _x; _playerPos = getPosATL _playerObj;
	};
} count playableUnits;

// Если playerObj не в playableUnits то выйдем из disconnect системы.
if (isNil "_playerObj") exitWith
{
	diag_log format["[СЕРВЕР] - [server_onPlayerDisconnect.sqf]: ИНФОРМАЦИЯ: OnPlayerDisconnect вышел. Игрок не в playableUnits. %1", _this];
};

// Игрок живой в Дебаг Зоне. (Игрок, скорее всего, просто только возродился).
if (_playerPos distance respawn_west_original < 1500) exitWith
{
	diag_log format["[СЕРВЕР] - [server_onPlayerDisconnect.sqf]: ИНФОРМАЦИЯ: OnPlayerDisconnect вышел. Игрок рядом с respawn_west. ЭТО НОРМАЛЬНО ПОСЛЕ СМЕРТИ! %1", _this];
	
	if (!isNull _playerObj) then
	{
		_playerObj call sched_co_deleteVehicle;
	};
};

/*
	Переведу и оставлю для Расширенной откладки, которую я сделаю позже.
	Переменная: Server_AdvancedDebug = true;
	
	diag_log format["[СЕРВЕР] - [server_onPlayerDisconnect.sqf]: Получено: %1 (%2), Отправлено: %3 (%4)",typeName (getPlayerUID _playerObj), getPlayerUID _playerObj, typeName _playerUID, _playerUID];
*/

// Если playerObj существует, то выполним все Синхронизации

_characterID 	= 	_playerObj getVariable["characterID", "?"];
_inCombat 		= 	_playerObj getVariable ["inCombat",false];
_Sepsis 		= 	_playerObj getVariable["USEC_Sepsis",false];

// Если Логин не синхронизируется
if (_playerUID in dayz_ghostPlayers) exitWith
{
	// Игрок жив (смотрим в dayz_ghostPlayers ниже)
	diag_log format["[СЕРВЕР] - [server_onPlayerDisconnect.sqf]: ОШИБКА: Невозможно синхронизировать игрока [%1,%2] Возможно все еще Логиниться",_playerName,_playerUID]; 

	// Удаляем объект.
	if (!isNull _playerObj) then
	{ 
		_playerObj call sched_co_deleteVehicle;
	};
};

// Проверяем что мы знаем ID игрока перед тем как будем синхронизировать информацию с Базой Данных
if (_characterID != "?") then
{
	// Проверяем был ли у Игрока Сепсис перед выходом и выдаем статус Заражён.
	if (_Sepsis) then
	{
		_playerObj setVariable["USEC_infected",true,true];
	};
	
	// Если player object жив, тогда синхронизируем игрока, удаляем тело и если ПРИЗРАК активно, то добавляем ID игрока в Массив
	if (alive _playerObj) then
	{
		// ГЛАВНЫЙ ПРИОРИТЕТ КОДА! Синхронизация ДОЛЖНА пройти прежде чем Игрок получит isNull
		[_playerObj,nil,true,[],_inCombat] call server_playerSync;
		
		/*
			С этого места Низкий приоритет кода где
			_playerObj больше не нужен и может быть Нуль(Null).
		*/
		
		// Проверка игрока "Вышел в Бою"
		if (_inCombat) then
		{
			// Посылает setVariables в server_playerSync поскольку он в Главном приоритете			
			// Сообщения - Низкий приоритет. Player object not needed
			diag_log format["[СЕРВЕР] - [server_onPlayerDisconnect.sqf]: ИГРОК ВЫШЕЛ В БОЮ: %1(%2) Позиция: %3",_playerName,_playerUID, _playerPos];
			[nil, nil, rTitleText, format["ИГРОК ВЫШЕЛ В БОЮ: %1",_playerName], "PLAIN"] call RE;
		};
		
		if (dayz_enableGhosting) then
		{
			/*
				Переведу и оставлю для Расширенной откладки, которую я сделаю позже.
				Переменная: Server_AdvancedDebug = true;
	
				diag_log format["[СЕРВЕР] - [server_onPlayerDisconnect.sqf]: НАБЛЮДАТЕЛЬ: %1, Живые игроки: %2",dayz_ghostPlayers,dayz_activePlayers];
			*/
			
			if (!(_playerUID in dayz_ghostPlayers)) then
			{ 
				dayz_ghostPlayers set [count dayz_ghostPlayers, _playerUID];
				dayz_activePlayers set [count dayz_activePlayers, [_playerUID,diag_ticktime]];
				
				/*
					Переведу и оставлю для Расширенной откладки, которую я сделаю позже.
					Переменная: Server_AdvancedDebug = true;
		
					diag_log format["[СЕРВЕР] - [server_onPlayerDisconnect.sqf]: playerID %1 добавлен в список Призраков",_playerUID];
				*/
			};
		};
	}
	else
	{
		// Успех в server_playerSync выше, если игрок жив
		{[_x,"gear"] call server_updateObject} count (nearestObjects [_playerPos,DayZ_GearedObjects,10]);
	};
	
	[_playerUID,_characterID,3,_playerName,(_playerPos call fa_coor2str)] call dayz_recordLogin;
};

if (alive _playerObj) then
{
	_playerObj call sched_co_deleteVehicle;
};