sched_sync =
{
	private ["_result","_outcome","_date","_hour","_minute"];
	// КАЖДЫЕ 15 МИНУТ
	// СИНХРАНИЗИРУЕМ ВРЕМЯ ДЛЯ БАЗЫ ДАННЫХ DLL

	_result 	= 	"CHILD:307:" call server_hiveReadWrite;
	_outcome 	= 	_result select 0;
	
	if (_outcome == "PASS") then
	{
	        _date 		= 	_result select 1;
	        _hour 		= 	_date select 3;
	        _minute 	= 	_date select 4;

	        if (dayz_ForcefullmoonNights) then
			{
	                _date = [2012,8,2,_hour,_minute];
	        };

	        setDate _date;
	        dayzSetDate = _date;
	        publicVariable "dayzSetDate";
	        diag_log [ __FILE__, "СИНХРОНИЗАЦИЯ ВРЕМЕНИ: Локальное время установлено:", _date, "Fullmoon:",dayz_ForcefullmoonNights, "Дата выдана для HiveExt.dll:", _result select 1];
	};

	objNull
};	
