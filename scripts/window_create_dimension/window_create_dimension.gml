/// @description window_create_dimension( num, width, height );
/// @param num
/// @param width
/// @param height
function window_create_dimension(argument0, argument1, argument2) {

	var _n		= argument0;
	var _w		= argument1;
	var _h		= argument2;

	// Save window size as a preset
	global.WINDOW_DIM[ _n, 0 ]	= _w;
	global.WINDOW_DIM[ _n, 1 ]	= _h;



}
