///@description cam_temp_zoom( zoom, dur );
///@param zoom
///@param dur
function cam_temp_zoom(argument0, argument1) {

	var _zoom	= argument0;
	var _dur	= argument1;

	if ( instance_exists( CAM ))
	with( CAM ){
		if(!zoom_temp){
			zoom_temp = true;
			zoom_old = set_z;
			set_z		= _zoom;
		}
		zoom_timer  = _dur;
	}



}
