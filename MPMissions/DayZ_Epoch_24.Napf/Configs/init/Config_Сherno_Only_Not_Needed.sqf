// Не нужно Chernorus_only.sqf

dayz_POIs 						= 	false; 		// Только для Черно (Сажает ФПС).
dayz_infectiousWaterholes 		= 	false; 		// Только для Черно (Сажает ФПС).
dayz_townGenerator 				= 	false;		// Только для Черно (Сажает ФПС).
dayz_townGeneratorBlackList 	= 	[];

if (dayz_POIs && (toLower worldName == "chernarus")) then
{
	call compile preprocessFileLineNumbers "\z\addons\dayz_code\system\mission\chernarus\poi\init.sqf";
};

if (isServer) then
{
	if (dayz_infectiousWaterholes && (toLower worldName == "chernarus")) then
	{
		execVM "\z\addons\dayz_code\system\mission\chernarus\infectiousWaterholes\init.sqf";
	};
	
	if (dayz_townGenerator) then
	{
		execVM "\z\addons\dayz_code\system\mission\chernarus\MainLootableObjects.sqf";
	};
};

if (!isDedicated) then
{
	if (toLower(worldName) == "chernarus") then
	{
		diag_log "WARNING: Clearing annoying benches from Chernarus";
		
		([4654,9595,0] nearestObject 145259) setDamage 1;
		([4654,9595,0] nearestObject 145260) setDamage 1;
	};
	
	if (dayz_townGenerator) then
	{
		execVM "\z\addons\dayz_code\compile\client_plantSpawner.sqf";
	};
};