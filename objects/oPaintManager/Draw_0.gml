if(!surface_exists(paint_surface)){
	paint_surface_create();
}else{		
	if(paint_surface_refresh)
		paint_surface_apply_paint();
		
	shader_set(shPaintSurface);
	
	shader_set_uniform_f(colorTeamOne,paint_team_one_color[0],
								paint_team_one_color[1],
								paint_team_one_color[2]);
								
	shader_set_uniform_f(colorTeamTwo,paint_team_two_color[0],
								paint_team_two_color[1],
								paint_team_two_color[2]);
	
	draw_surface_stretched(
		paint_surface,
		paint_surface_position_x,
		paint_surface_position_y,
		surface_get_width(paint_surface) * paint_surface_to_room_scale_x,
		surface_get_height(paint_surface) * paint_surface_to_room_scale_y
	);
	
	shader_reset();
}

for (var i = 0; i < room_width; i += room_width/grid_cells_width)
    draw_line_color(i,0,i,room_height,c_red,c_red);


for (var i = 0; i < room_height; i += room_height/grid_cells_height)
    draw_line_color(0,i,room_width,i,c_red,c_red);