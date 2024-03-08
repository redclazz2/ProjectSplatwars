///@description cam_flash( color, alpha, flash_dur, damp_dur **ease type?** );
///@param color
///@param alpha
///@param flash_dur
///@param damp_dur
function cam_flash(argument0, argument1, argument2, argument3) {


	var _col		= argument0;
	var _alpha		= argument1;
	var _flash_dur	= argument2;
	var _damp_dur	= argument3;

	if ( instance_exists( CAM ))
	with( CAM ){
		// Set Flash variables
		flash_damp	= ( _alpha )/ ( _damp_dur );

		flash_timer = _flash_dur;
		flash_alpha	= _alpha;
		flash_color	= _col;
	}


	/*
	Set screen to flash color
	Set alpha, duration, timer to dur, and ease dur

	Flash stays at current color and alpha
	Timer count down to 0
	at 0, ease flash alpha back to 0 using damp_value
	*/


}
