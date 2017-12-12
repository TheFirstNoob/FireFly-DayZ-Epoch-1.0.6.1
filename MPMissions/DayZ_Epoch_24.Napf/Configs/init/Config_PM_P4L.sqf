// Plot Management и Plot for Life
DZE_permanentPlot 				= 	true; 		// Использовать Plot Management и P4L?
DZE_plotManagementMustBeClose 	= 	true; 		// Чтобы добавить игрока в Плот он должен быть рядом (10м)
DZE_PlotManagementAdmins 		= 	[]; 		// UID Администрации для доступа ко всем Плотам.
DZE_MaxPlotFriends 				= 	10; 		// Всего друзей за 1 плот. Меньше - лучше для Базы Данных (setVariable)
DZE_maintainCurrencyRate 		= 	100; 		// Множитель Оплаты построек: Если 100, то при 10 Постройках будет 1000 (1 10oz gold или 1k coins). Смотрите actions/maintain_area.sqf для большей инфы.

/*
	Предметы которые могут быть убраны без Хозяев или Доступа.
	(Обратное: DZE_restrictRemoval)
	
	Нет необходимости добавлять ID что уже хранятся в 'BuiltItems'
*/
DZE_isRemovable =
[
	"Plastic_Pole_EP1_DZ"
];

/*
	Предметы которые могут быть убраны только с Хозяеами или Доступом.
	(Обратное: DZE_isRemovable)
	
	Нет необходимости добавлять ID что уже хранятся в 'ModularItems'
	Элементы из 'BuiltItems' можно добавить сюда при необходимости
*/
DZE_restrictRemoval =
[
	"Fence_corrugated_DZ"
	,"M240Nest_DZ"
	,"ParkBench_DZ"
	,"FireBarrel_DZ"
	,"Scaffolding_DZ"
	,"CanvasHut_DZ"
	,"LightPole_DZ"
	,"DeerStand_DZ"
	,"MetalGate_DZ"
	,"StickFence_DZ"
];