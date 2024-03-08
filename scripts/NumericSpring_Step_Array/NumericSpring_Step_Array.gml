/// @description NumericSpring_Step_Array( val, vel, target, damp, freq, timestep );
/// @param val
/// @param vel
/// @param target
/// @param damp
/// @param freq
/// @param timestep
function NumericSpring_Step_Array(argument0, argument1, argument2, argument3, argument4, argument5) {

	/*
		// Step
		var SHAKE_ARRAY	= NumericSpring( shake, shake_vel, set, shake_damp, shake_freq, var_time );
			shake		= SHAKE_ARRAY[0];
			shake_vel	= SHAKE_ARRAY[1];

		///////////////////////////////////////////////////////
		Setting up the 'shake' value to numerically spring.
		You can adjust the TARGET or VEL values to offset the values.
	*/


	var     SPRING;
	var     _X           = argument0;       // value                    (input/output)
	var     _V           = argument1*(room_speed/argument5); //velocity (input/output)
	var     _VT          = argument2;       // target value             (input)
	var     _D           = argument3;       // dampening ratio          (input)
	var     _F           = 2*pi* argument4; // angular frequency        (input)
	var     _T           = argument5/room_speed; //time step            (input)

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

	SPRING[1]   = ( DELTA_V/DELTA )/( room_speed/argument5 );
	SPRING[0]   = ( DELTA_X/DELTA );

	return SPRING;



}
