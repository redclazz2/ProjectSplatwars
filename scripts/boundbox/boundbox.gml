/// @description boundbox( color );
/// @param color
function boundbox(argument0) {

	// Displays the mask_index- great for debugging

	///	-----------------EXAMPLE-------------------///
	/*
		// Draw
		BoundBox( c_red );
	
		/////////////////////////////////////////////////
		Draws a Red outline of the object's hitbox/mask
	*/

	draw_set_color( argument0 );
	draw_rectangle( bbox_left, bbox_top, bbox_right, bbox_bottom, true );
	draw_set_color( c_white );



}
