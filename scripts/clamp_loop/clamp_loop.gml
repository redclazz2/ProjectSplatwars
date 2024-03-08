/// @description clamp_loop( value, min, max );
/// @param value
/// @param min
/// @param max
function clamp_loop(argument0, argument1, argument2) {

	///	------------|				EXAMPLE				 |-------------- ///
	/*
		if ( mouse_wheel_up() ){
			value++;
			value = clamp_loop( value, 0, 10 );
		}
	
		/////////////////////////////////////////
		The value will go to 0 when it passes 10.
	*/



	var _val        = argument0;
	var _min        = argument1;
	var _max        = argument2;

	var _C = _val;

	if ( _val < _min ){
	    _C  = _max
	} else if ( _val > _max ){
	    _C  = _min;
	}

	return _C;


}
