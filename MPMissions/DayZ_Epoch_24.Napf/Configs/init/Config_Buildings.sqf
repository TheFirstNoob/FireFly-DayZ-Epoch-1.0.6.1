DZE_StaticConstructionCount 	= 	0; 			// Сколько шагов стройки. 0 = по умолчанию / 0 > Применяется ко всем.

DZE_requireplot 				= 	1; 			// Требуется ли Плот 1 - Да / 0 - Нет
DZE_PlotPole 					= 	[30,45]; 	// Радиус Плота для Базы [Сколько база, через сколько можно поставить новый плот]

DZE_BuildOnRoads 				= 	false; 		// Можно ли строить на дорогах?

DZE_BuildingLimit 				= 	150; 		// Сколько построек можно в зоне DZE_PlotPole

DZE_NoBuildNear 				= 	[]; 		// Рядом с какими Постройками НЕЛЬЗЯ строить. Пример: ["Land_Mil_ControlTower","Land_SS_hangar"].
DZE_NoBuildNearDistance 		= 	150; 		// Дистанция запрета.

DZE_GodModeBase 				= 	false; 		// Защита построенных баз от урона
DZE_GodModeBaseExclude 			= 	[]; 		// Что не будет защищено Бессмертием построек. Пример: ["VaultStorageLocked"].