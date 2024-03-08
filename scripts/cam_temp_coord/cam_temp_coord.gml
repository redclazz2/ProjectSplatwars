///@description cam_temp_coord( dur, cu, cv );
///@param dur 
///@param cu
///@param cv
function cam_temp_coord(argument0, argument1, argument2) {

	var _dur = argument0;
	var _cu	= argument1;
	var _cv	= argument2;


	if ( instance_exists( CAM ))
	with( CAM ){
		if(!c_temp){ //trigger once to save
		c_temp	= true;
		cu_old		= cu;
		cv_old		= cv;
	
		cu		= _cu;
		cv		= _cv;
		cx		= cu* window_get_width();
		cy		= cv* window_get_height();
		}
		c_timer = _dur;
	}



}
