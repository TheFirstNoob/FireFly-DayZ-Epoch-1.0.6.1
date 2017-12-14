[] spawn
{
	while {true} do {
		
		while {(alive player) && (!dayz_inside)} do {
		
			_ran = ceil random 2;
			playsound format ["wind_%1",_ran];
			_pos = position player;
			_parray = [["\Ca\Data\ParticleEffects\Universal\Universal", 16, 12, 8, 1], "", "Billboard", 1, 4, [0,0,0], [0,0,0], 1, 0.000001, 0, 1.4, [0.05,0.05], [[1,1,1,1]], [0,1], 0.2, 1.2, "", "", vehicle player];
			_snow = "#particlesource" createVehicleLocal _pos;  
			_snow setParticleParams _parray;
			_snow setParticleRandom [0, [20, 20, 10], [0, 0, 0], 0, 0.01, [0, 0, 0, 0.1], 0, 0];
			_snow setParticleCircle [0.0, [0, 0, 0]];
			_snow setDropInterval 0.001;
			uiSleep (random 1);
			deleteVehicle _snow
		};
		_delay = 1 + random 3;
		uiSleep _delay;
	};
};