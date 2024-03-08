///@description cam_mode_follow( mode, target );
///@param mode
///@param target
function cam_follow(argument0, argument1) {


	if ( instance_exists( CAM ))
	with( CAM ){
		target			= argument1;
		MODE[ FOLLOW ]	= argument0;
	}



}
