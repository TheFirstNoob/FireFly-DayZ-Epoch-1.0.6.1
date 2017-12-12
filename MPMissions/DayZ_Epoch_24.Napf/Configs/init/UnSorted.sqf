DZE_NameTags 				= 	2; 			// Отображать ник когда игрок рядом:  0 = Выкл, 1 = Вкл, 2 = Игрок сам выбирает
DZE_ForceNameTagsInTrader 	= 	true; 		// Отображать ник в торговой зоне (Игнорирует выбор игрока).
DZE_HumanityTargetDistance 	= 	10; 		// Дистанция отображения имени (Красный - Бандит, Синий - Герой, Зеленый - Друг)

DZE_RestrictSkins = []; 		// Запрещенные скины для переодевания.

DZE_UI = "vanilla"; 				// "vanilla","epoch","dark"  UI Иконки. "dark" ночью плохо видно.
DZE_VanillaUICombatIcon = true; 	// Спрятать Иконку (в бою!) (Если DZE_UI = "vanilla"; Не сработает).

timezoneswitch = 0; 				// Не трогать лучше.

DZE_SafeZonePosArray 			= 	[]; 			// Предотвращать убийство игроков в торг. зонах, если их автомобиль уничтожен. Пример: [[[3D POS], RADIUS],[[3D POS], RADIUS]]; Ex. DZE_SafeZonePosArray = [[[6325.6772,7807.7412,0],150],[[4063.4226,11664.19,0],150]];
DZE_SafeZoneNoBuildItems 		= 	[]; 		// Что нельзя размещать в торг. зонах. Пример: ["VaultStorageLocked","LockboxStorageLocked","Plastic_Pole_EP1_DZ"].
DZE_SafeZoneNoBuildDistance 	= 	150; 	// Дистанция запрета.

DZE_DisabledChannels = [(localize "str_channel_side"),(localize "str_channel_global"),(localize "str_channel_command")]; // Список отключенных каналов: "str_channel_group","str_channel_direct","str_channel_vehicle"