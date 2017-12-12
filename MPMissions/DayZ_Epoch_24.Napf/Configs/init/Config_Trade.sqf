// Торговля
DZE_ConfigTrader 		= 	true; 		// Откуда брать конфиг торговли. True - Работает быстрее и использует Интернет-Трафик / False - Брать из Базы Данных.
DZE_serverLogTrades 	= 	true; 		// Логгировать Торговлю (Использует: publicVariableServer)

DZE_GemOccurance = 						// Редкость руды (Только цельное число)
[
	["ItemTopaz",10]
	, ["ItemObsidian",8]
	, ["ItemSapphire",6]
	, ["ItemAmethyst",4]
	, ["ItemEmerald",3]
	, ["ItemCitrine",2]
	, ["ItemRuby",1]
];

DZE_GemWorthArray =						// Цены руд. Используйте: DZE_GemWorthArray=[]; чтобы убрать настройки.
[
	["ItemTopaz",15000]
	, ["ItemObsidian",20000]
	, ["ItemSapphire",25000]
	, ["ItemAmethyst",30000]
	, ["ItemEmerald",35000]
	, ["ItemCitrine",40000]
	, ["ItemRuby",45000]
];

DZE_SaleRequiresKey 	= 	true; 				// Для продажи покупной техники всегда нужен ключ. Ключ должен быть или: Инветарь, Рюкзак, Техника.
DZE_TRADER_SPAWNMODE 	= 	false; 				// При покупке техники она появляется на парашюте

Z_VehicleDistance 				= 	30; 		// Дистанция продажи техники от торгоша (м)
Z_AllowTakingMoneyFromBackpack 	= 	true; 		// Брать деньги из Рюкзака.
Z_AllowTakingMoneyFromVehicle 	= 	true; 		// Брать деньги из Техники.

Z_SingleCurrency 			= 	false; 			// Используется ли ZSC?
CurrencyName 				= 	"Coins"; 		// Название валюты в ZSC.
Z_MoneyVariable 			= 	"cashMoney"; 	// Переменная валюты в ZSC.
DZE_MoneyStorageClasses 	= 	[]; 			// Если используется ZSC, то где можно хранить деньги.