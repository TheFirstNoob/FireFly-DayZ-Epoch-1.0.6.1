private ["_position","_doLoiter","_unitTypes","_array","_agent","_type","_radius","_method","_rndx","_rndy","_counter","_amount","_wildsdone"];
_unitTypes 		= 	_this select 0;
_amount 		= 	_this select 1;
//_doLoiter 	= 	true;
_wildsdone 		= 	true;
_counter 		= 	0;

while {_counter < _amount} do {
	//_loot 	= 	"";
	//_array 	= 	[];
	_agent 		= 	objNull;
	_type 		= 	_unitTypes call BIS_fnc_selectRandom;

	// Создаем группу
	//diag_log ("Spawned: " + _type);	// Позже
	//_radius = 0;
	_method = "CAN_COLLIDE";
	
	_position = [getMarkerPos "center",1,6500,1] call fn_selectRandomLocation;
	
	// Создаем зомби
	_agent = createAgent [_type, _position, [], 1, _method];
	// Задаем угол
	_agent setDir floor(random 360);
	// Статус дейсвтия
	_agent setVariable ["doLoiter",true]; // Не может быть использован.
	
	// Позиция
	if (random 1 > 0.7) then
	{
		_agent setUnitPos "Middle";
	};
	// Радиус бесдействия (слоняться)
	_position = getPosATL _agent;
	_agent setVariable ["homePos",_position,true];
	// Храним _agentobject
	_agent setVariable["agentObject",_agent,true];
	
	// Добавим в значение
	_counter = _counter + 1;
	
	//Start behavior
	//_id = [_agent] execFSM "\z\AddOns\dayz_code\system\zombie_wildagent.fsm";
	//_agent setVariable [ "fsmid", _id ];
	
	// Отключаем всю Симуляцию у зомби
	_agent enableSimulation false;

	//diag_log format ["CREATE WILD: Active: %1, Waiting: %2",_counter,(_amount - _counter)]		// Позже
};

_wildsdone