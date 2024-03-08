///@description cam_shake( type, shake, duration, direction );
/// @param type
/// @param shake 
/// @param duration
/// @param direction
function cam_shake(argument0, argument1, argument2, argument3) {


	//--	Example		--///
	// if ( keyboard_check_pressed( vk_space ))
	//	

	var _type		= argument0;
	var _shake		= argument1;
	var _duration	= argument2;
	var _direction	= argument3;

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

		shake_damp	= (_shake/ room_speed)* ( shake_damp_time/ room_speed );
	}



}
