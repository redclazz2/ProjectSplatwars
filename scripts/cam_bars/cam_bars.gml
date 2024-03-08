/// @description cam_bars( duration, perc );
/// @param dur
///@param perc
function cam_bars(argument0, argument1) {

	var _dur = argument0;
	var _perc = argument1;

	if(instance_exists(CAM)){
	with(CAM)
		{
			bar_toggle = true;
			bar_timer = _dur;
			bar_perc_temp = _perc;
		}
	}




}
