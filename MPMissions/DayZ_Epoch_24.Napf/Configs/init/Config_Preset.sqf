// Пресет
dayz_presets = "Custom"; //"Custom","Classic","Vanilla","Elite"

if (dayz_presets == "Custom") then
{
	dayz_enableGhosting 					= false;		// Спектатор при смерти.
	dayz_ghostTimer 						= 60; 			// Время спектатора (после autologin).
	dayz_spawnselection 					= 0; 			// Выбор спавна (Только для черно). Мне это нахрен не надо
	dayz_spawncarepkgs_clutterCutter 		= 0; 			// Ящики: 0 = лут в траве, 1 = поднят, 2 = без травы
	dayz_spawnCrashSite_clutterCutter 		= 0;			// ХелиКраш: 0 = лут в траве, 1 = поднят, 2 = без травы
	dayz_spawnInfectedSite_clutterCutter 	= 0; 			// Зараж. лагеря: 0 = лут в траве, 1 = поднят, 2 = без травы
	dayz_bleedingeffect 					= 2; 			// Эффект крови: 1 = кровь на земле (Сажает ФПС), 2 = только частицы, 3 = Оба
	dayz_OpenTarget_TimerTicks 				= 60 * 10; 		// Как долго можно свободно атаковать игрока, который был не спровоцирован (В БОЮ!).
	dayz_nutritionValuesSystem 				= true; 		// Система питания.
	dayz_classicBloodBagSystem 				= false; 		// Исп. старую систему крови (без групп)
	dayz_enableFlies 						= false; 		// Добавлять Мух на трупы (Сажает ФПС). Надо потестить.
};