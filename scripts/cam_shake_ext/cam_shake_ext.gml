///@description cam_shake_ext( type, shake, duration, direction, damp_time );
/// @param type
/// @param shake 
/// @param duration
/// @param direction
/// @param damp_time
function cam_shake_ext(argument0, argument1, argument2, argument3, argument4) {

	// Same as cam_shake but you're able to control how long it takes for the screenshake to reset back to 0.
	// 

	var _type		= argument0;
	var _shake		= argument1;
	var _duration	= argument2;
	var _direction	= argument3;
	var _d_time		= argument4;

	if ( instance_exists( CAM ))
	with( CAM ){
		shake_amount = _shake;
		shake_dur	= _duration;
		shake_dir	= _direction;
		MODE[ SHAKE ]	= _type;

	switch( MODE[ SHAKE ] ){
		case 1:
			NumericSpring_Set_Spd( 0, _shake );
		break;
		 case 2:
			Spring_Set_Spd( 0, _shake );
		 break;
	}
		shake_damp_time	= _d_time;
		shake_damp	= (_shake/ room_speed)* ( shake_damp_time/ room_speed );
	}



}
