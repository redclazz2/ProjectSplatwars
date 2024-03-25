if(!surface_exists(paint_surface)){
	paint_surface_create();
}else{		
	if(paint_surface_refresh)
		paint_surface_apply_paint();
		
	shader_set(shPaintSurface);
		draw_surface(
			paint_surface,
			paint_surface_position_x,
			paint_surface_position_y
		);
	shader_reset();
}
