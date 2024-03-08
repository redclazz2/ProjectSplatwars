function window_reset_dimension(argument0, argument1) {
	//Used to readjust the camera based on the given inputs: window preset, and resolution 
	///@description window_reset_dimension( window num, res );
	///@param window num
	///@param res

	global.WINDOW	= argument0;

	with( CAM ){
		res		= argument1;
		alarm[0]	= 2;
	}



}
