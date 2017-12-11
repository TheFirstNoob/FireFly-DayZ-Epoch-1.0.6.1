/*
	[_objectID,_objectUID,_activatingPlayer] call server_deleteObj;
*/

private ["_id","_uid","_key","_activatingPlayer"];
_id					= 	_this select 0;
_uid				= 	_this select 1;
_activatingPlayer	= 	_this select 2;

if (isServer) then
{
	// Удаляем из БД
	if (parseNumber _id > 0) then
	{
		// Посылаем запрос
		_key = format["CHILD:304:%1:",_id];
		_key call server_hiveWrite;
		
		diag_log format["[СЕРВЕР] - [server_deleteObj.sqf]: УДАЛЕНИЕ: Игрок %1 удалил объект с ID: %2",_activatingPlayer,_id];
	}
	else
	{
		// Посылаем запрос
		_key = format["CHILD:310:%1:",_uid];
		_key call server_hiveWrite;
		
		diag_log format["[СЕРВЕР] - [server_deleteObj.sqf]: УДАЛЕНИЕ: Игрок %1 удалил объект с UID: %2",_activatingPlayer,_uid];
	};
};
