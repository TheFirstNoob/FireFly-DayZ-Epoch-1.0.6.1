private ["_position","_doLoiter","_unitTypes","_array","_agent","_type","_radius","_method","_rndx","_rndy","_counter","_amount","_wildsdone"];
_unitTypes 	= 	_this select 0;
_amount 	= 	_this select 1;
	// _doLoiter = true;
_wildsdone 	= 	true;
_counter 	= 	0;

while {_counter < _amount} do
{
	// _loot 	=	"";
	// _array 	=	[];
	_agent 	= 	objNull;
	_type 	= 	_unitTypes call BIS_fnc_selectRandom;

	// Создаем группу и заполняем ее
	/*
		Переведу и оставлю для Расширенной откладки, которую я сделаю позже.
		Переменная: Server_AdvancedDebug = true;

		diag_log ("[СЕРВЕР] - [zombie_Wildgenerate.sqf]: Отспавнено: " + _type);
	*/
	
	// _radius = 0;
	_method = "CAN_COLLIDE";
	
	_position = [getMarkerPos "center",1,6500,1] call fn_selectRandomLocation;
	
	// Создаем Зомби
	_agent = createAgent [_type, _position, [], 1, _method];
	
	// Дает рандомный угол поворота
	_agent setDir floor(random 360);
	
	// Создаем передвижение
	_agent setVariable ["doLoiter",true]; // Не может быть использован.
	
	// Позиция зомби
	if (random 1 > 0.7) then
	{
		_agent setUnitPos "Middle";
	};
	
	// Создаем место куда возвращаться зомби для передвижения
	_position = getPosATL _agent;
	_agent setVariable ["homePos",_position,true];
	
	// Храним _agentobject
	_agent setVariable ["agentObject",_agent,true];
	
	// Добавляем к счетчику
	_counter = _counter + 1;
	
	// Начинаем Симуляцию
	// _id = [_agent] execFSM "\z\AddOns\dayz_code\system\zombie_wildagent.fsm";
	// _agent setVariable [ "fsmid", _id ];
	
	// Отключаем Всю Симуляцию зомби
	_agent enableSimulation false;

	// Создаем группу и заполняем ее
	/*
		Переведу и оставлю для Расширенной откладки, которую я сделаю позже.
		Переменная: Server_AdvancedDebug = true;

		diag_log format["[СЕРВЕР] - [zombie_Wildgenerate.sqf]: СОЗДАНО: Активно: %1, Ждет: %2",_counter,(_amount - _counter)]
	*/
};

_wildsdone