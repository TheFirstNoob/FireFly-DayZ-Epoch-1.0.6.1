// Настройки сервера
dayZ_instance 		= 	24; 			// Инстанция (24 - Napf)
dayZ_serverName 	= 	"FireFly"; 		// Водяной знак
dayz_antihack		=	0;				// DayZ Antihack / 1 = Вкл / 0 = Выкл
dayz_REsec			=	0;				// DayZ RE Security / 1 = Вкл / 0 = Выкл

dayz_ForcefullmoonNights 	= 	false; 		// Луна ночью

enableRadio false;
enableSentences false;

#include "configVariables.sqf"

//DefaultMagazines = ["HandRoadFlare","ItemBandage","ItemPainkiller","8Rnd_9x18_Makarov","8Rnd_9x18_Makarov"];
//DefaultWeapons = ["Makarov_DZ","ItemFlashlight"];
//DefaultBackpack = "DZ_Patrol_Pack_EP1";
//DefaultBackpackItems = [];

dayz_POIs 						= 	false; 		// Только для Черно (Сажает ФПС).
dayz_infectiousWaterholes 		= 	false; 		// Только для Черно (Сажает ФПС).
dayz_townGenerator 				= 	false;		// Только для Черно (Сажает ФПС).
dayz_townGeneratorBlackList 	= 	[];

diag_log 'dayz_preloadFinished reset';
dayz_preloadFinished = nil;
onPreloadStarted "diag_log [diag_tickTime,'onPreloadStarted']; dayz_preloadFinished = false;";
onPreloadFinished "diag_log [diag_tickTime,'onPreloadFinished']; dayz_preloadFinished = true;";
with uiNameSpace do {RscDMSLoad = nil;};

_verCheck = (getText (configFile >> "CfgMods" >> "DayZ" >> "version") == "DayZ Epoch 1.0.6.1");		// Позже можно от этого избавиться!
if (!isDedicated) then
{
	enableSaving [false, false];
	startLoadingScreen ["","RscDisplayLoadCustom"];
	progressLoadingScreen 0;
	dayz_loadScreenMsg = localize 'str_login_missionFile';
	
	if (_verCheck) then
	{
		progress_monitor = [] execVM "DZE_Hotfix_1.0.6.1A\system\progress_monitor.sqf";
	}
	else
	{
		progress_monitor = [] execVM "\z\addons\dayz_code\system\progress_monitor.sqf";
	};
	
	0 cutText ['','BLACK',0];
	0 fadeSound 0;
	0 fadeMusic 0;
};

initialized = false;
call compile preprocessFileLineNumbers "\z\addons\dayz_code\init\variables.sqf";
progressLoadingScreen 0.05;
call compile preprocessFileLineNumbers "\z\addons\dayz_code\init\publicEH.sqf";
progressLoadingScreen 0.1;
call compile preprocessFileLineNumbers "\z\addons\dayz_code\medical\setup_functions_med.sqf";
progressLoadingScreen 0.15;
call compile preprocessFileLineNumbers "\z\addons\dayz_code\init\compiles.sqf";

if (_verCheck) then
{
	#include "DZE_Hotfix_1.0.6.1A\init\compiles.sqf"
};

progressLoadingScreen 0.25;

call compile preprocessFileLineNumbers "server_traders.sqf";

initialized = true;

setViewDistance 2000;
setTerrainGrid 25;

if (dayz_REsec == 1) then 
{
	call compile preprocessFileLineNumbers "\z\addons\dayz_code\system\REsec.sqf";
};

// Изменение погоды
// Смотри DynamicWeatherEffects.sqf для информации.
//DZE_WeatherVariables = [10, 20, 5, 10, 0, 0.2, 0, 0.7, 0, 0.6, 0, 8, 25, 30, 0, false];
//execVM "\z\addons\dayz_code\system\DynamicWeatherEffects.sqf";		// Динамичная погода

if (isServer) then
{
	call compile preprocessFileLineNumbers "\z\addons\dayz_server\system\dynamic_vehicle.sqf";
	call compile preprocessFileLineNumbers "\z\addons\dayz_server\system\server_monitor.sqf";
	execVM "\z\addons\dayz_server\traders\napf.sqf";
};

if (!isDedicated) then
{
	//execVM "\z\addons\dayz_code\system\antihack.sqf";
	
	execVM "Scripts\Snow\Snowstorm.sqf";	// Частицы снега
	execVM "Scripts\Snow\Filter.sqf";		// Фильтр "Синий холод"

	execFSM "\z\addons\dayz_code\system\player_monitor.fsm";

	if (DZE_R3F_WEIGHT) then
	{
		execVM "\z\addons\dayz_code\external\R3F_Realism\R3F_Realism_Init.sqf";
	};
	
	waitUntil {scriptDone progress_monitor};
	cutText ["","BLACK IN", 3];
	3 fadeSound 1;
	3 fadeMusic 1;
	endLoadingScreen;
};