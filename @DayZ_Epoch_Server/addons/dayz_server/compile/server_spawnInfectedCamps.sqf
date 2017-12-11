#include "\z\addons\dayz_code\util\Math.hpp"
#include "\z\addons\dayz_code\loot\Loot.hpp"

// Число инфекционных лагерей
#define CAMP_NUM 3

// Минимальное расстояние между лагерями
#define CAMP_MIN_DIST 300

// Основной класс для лута
#define CAMP_CONTAINER_BASE "IC_Tent"

// Кол-во лута в палатке
#define LOOT_MIN 10
#define LOOT_MAX 20

// Кол-во Рандомных объектов в лагере
#define OBJECT_MIN 4
#define OBJECT_MAX 12

// Радиус между объектами
#define OBJECT_RADIUS_MIN 8
#define OBJECT_RADIUS_MAX 13

#define SEARCH_CENTER getMarkerPos "center"
#define SEARCH_RADIUS (getMarkerSize "center") select 0
#define SEARCH_EXPRESSION "(5 * forest) + (4 * trees) + (3 * meadow) - (20 * houses) - (30 * sea)"
#define SEARCH_PRECISION 30
#define SEARCH_ATTEMPTS 10

private
[
	"_typeGroup",
	"_lootGroup",
	"_objectGroup",
	"_type",
	"_position",
	"_composition",
	"_compositionObjects",
	"_objectPos"
];

_typeGroup = Loot_GetGroup("InfectedCampType");
_lootGroup = Loot_GetGroup("InfectedCamp");
_objectGroup = Loot_GetGroup("InfectedCampObject");

for "_i" from 1 to (CAMP_NUM) do
{
	// Выбираем тим лагеря
	_type = Loot_SelectSingle(_typeGroup);
	_composition = _type select 1;
	
	// Ищем позицию
	for "_j" from 1 to (SEARCH_ATTEMPTS) do
	{
		_position = ((selectBestPlaces [SEARCH_CENTER, SEARCH_RADIUS, SEARCH_EXPRESSION, SEARCH_PRECISION, 1]) select 0) select 0;
		_position set [2, 0];
		
		// Проверьте, существует ли лагерь на минимальном расстоянии
		if (count (_position nearObjects [CAMP_CONTAINER_BASE,CAMP_MIN_DIST]) < 1) exitWith {};
	};
	
	diag_log format ["[СЕРВЕР] - [server_spawnInfectedCamps.sqf]: ОТКЛАДКА: Спавним Зараженный Лагерь (%1) на %2", _composition, _position];
	
	// Спавним
	_compositionObjects = [_position, random 360,_composition] call spawnComposition;
	
	// Добавляем лут в постройки
	{
		if (_x isKindOf (CAMP_CONTAINER_BASE)) then
		{
			Loot_InsertCargo(_x, _lootGroup, round Math_RandomRange(LOOT_MIN, LOOT_MAX));
		};
	} forEach _compositionObjects;
	
	// Спавним постройки
	{
		_objectPos = [_position, OBJECT_RADIUS_MIN, OBJECT_RADIUS_MAX, 5] call fn_selectRandomLocation;
		
		Loot_Spawn(_x, _objectPos);
		
	} forEach Loot_Select(_objectGroup, round Math_RandomRange(OBJECT_MIN, OBJECT_MAX));
};