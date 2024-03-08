///@description cam_temp_inroom( bool, dur );
///@param bool
///@param dur
function cam_temp_inroom(argument0, argument1) {

	var _bool	= argument0;
	var _dur	= argument1; 


	if ( instance_exists( CAM ))
	with( CAM ){
		if(!inroom_temp){
			inroom_temp = true;
			inroom_old = inroom;
			inroom = _bool;
		}
		inroom_timer = _dur;
	}



}
