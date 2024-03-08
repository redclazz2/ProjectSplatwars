///@description cam_bars_toggle();
function cam_bars_toggle() {
	// Toggle BlackBars on/off

	if ( instance_exists( CAM ))
	with( CAM ){
		bar_toggle		= !bar_toggle;
	}


}
