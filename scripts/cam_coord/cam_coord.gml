///@description cam_coord( cu, cv );
///@param cu
///@param cv
function cam_coord(argument0, argument1) {


	if ( instance_exists( CAM ))
	with( CAM ){
		cu		= argument0;
		cv		= argument1;
		cx		= cu* window_get_width();
		cy		= cv* window_get_height();
	}



}
