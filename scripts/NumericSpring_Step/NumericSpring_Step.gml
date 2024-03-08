/// @description NumericSpring_Step( num, time );
/// @param num
/// @param time
function NumericSpring_Step(argument0, argument1) {

	// Time is not a consistant variable, so it must be passed as an arg

	/*
	
		///////////////////////////////////////////////////////
	
	*/

	var _n		= argument0;
	var _time	= argument1;

	var     SPRING;
	var		_X			= nval[@ _n ];		// value                    (input/output)
	var		_V			= nvel[@ _n ]* (room_speed/_time ); //velocity (input/output)
	var		_VT			= nset[@ _n ];		// target value             (input)
	var		_D			= ndamp[@ _n ];	// dampening ratio          (input)
	var		_F			= 2*pi* nfreq[@ _n ]; // angular frequency        (input)
	var		_T			= _time/room_speed; //time step            (input)


	var DELTA_V, DELTA_X, DELTA;
	/*
	    SPRING - Array containing the output and velocity values
	    ZETA   - Damping of the oscillation ( 0= no damping, 1= fully damped )
	    OMEGA  - Angular frequency, Oscillations per second
	    TIME   - How much of a second each step the script takes (1= norm, 2= twice as fast)
    
	*/

	DELTA       = (1+2* _T* _D* _F)+ power( _T,2 )* power( _F,2 );
	DELTA_X     = (1+2* _T* _D* _F)* _X+ _T* _V+power( _T,2 )* power( _F,2 )* _VT;
	DELTA_V     = _V+ _T* power( _F,2 )* (_VT-_X);

	// 
	SPRING[1]   = ( DELTA_V/DELTA )/( room_speed/_time );
	SPRING[0]   = ( DELTA_X/DELTA );

	// Set values back into main array
	nval[ _n ]	= SPRING[0];
	nvel[ _n ]	= SPRING[1];

	return SPRING;



}
