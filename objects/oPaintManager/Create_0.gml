/// @description Paint Manager Definition
#region Object Variables
	x = room_width / 2;
	y = room_height / 2;
	
	// Sets the grid size values per room
	grid_cells_width = room_width / 12.8;
	grid_cells_height = room_height / 12;
	
	// Create grid for charging up special
	paint_grid = ds_grid_create(grid_cells_width, grid_cells_height);
	
	paint_surface_fidelity = 0;
	
	paint_surface_width = 0;
	paint_surface_height = 0;

	paint_room_to_surface_scale_x = 0;
	paint_room_to_surface_scale_y = 0;

	paint_surface_to_room_scale_x = 0;
	paint_surface_to_room_scale_y = 0;

	paint_surface_position_x = 0;
	paint_surface_position_y = 0;

	paint_surface = -1;
	paint_surface_refresh = false;
	paint_surface_refresh_time = 
		configuration_get_paint_property("paint_surface_refresh_time") ?? 4;

	paint_queue = -1;
	
	paint_team_one_color = c_white;
	paint_team_two_color = c_white;
	
	paint_team_one_color_abstract = 
		configuration_get_paint_property("paint_color_abstract_channel_r_team_one") ?? 0;
	paint_team_two_color_abstract = 
		configuration_get_paint_property("paint_color_abstract_channel_r_team_two") ?? 20;
	
	colorTeamOne = shader_get_uniform(shPaintSurface,"colorTeamOne");
	colorTeamTwo = shader_get_uniform(shPaintSurface,"colorTeamTwo");
	
	//Debug
	debug_draw_mouse_enable = false;
	debug_draw_mouse_team = paint_team_one_color_abstract;
	
	function debug_draw_mouse_toggle(){
		debug_draw_mouse_enable = debug_draw_mouse_enable ? false : true;
	}
	
	function debug_draw_change_team(){
		if(debug_draw_mouse_team == paint_team_one_color_abstract)
			debug_draw_mouse_team = paint_team_two_color_abstract;
		else debug_draw_mouse_team = paint_team_one_color_abstract;
	}	
#endregion

#region paint_grid behavior
	function get_grid_value(_x, _y) {
		return ds_grid_get(paint_grid, _x, _y);
	}
	
	function get_grid_coordinates(_x, _y) {
		return [_x / (room_width/grid_cells_width), _y / (room_height/grid_cells_height)];
	}
	
	function set_grid_value(_data) {
		var _x = _data[0];
		var _y = _data[1];
		var _val = _data[2];
		var _is_local = _data[3];
		
		var _charge = 0,  // Added charge to special meter
		_arr = get_grid_coordinates(_x, _y),
		current_val = get_grid_value(floor(_arr[0]), floor(_arr[1]));
		
		if current_val == 0 {
			_charge = 0.5;
		} else if current_val != configuration_get_gameplay_property("current_team") {
			_charge = 0.55;
		}
		
		ds_grid_set(paint_grid, floor(_arr[0]), floor(_arr[1]), _val);
		
		// Sends the value in _charge to its subscribers
		if (_is_local == 0) {  
			pubsub_publish("GetChargeData", _charge);
		}
		
		return _charge;
	}
#endregion

function update_local_player_sampler(manager){
	var local_player = configuration_get_gameplay_property("current_local_player_instance"),
		_return = 1;
		
	if(local_player != noone && surface_exists(manager.paint_surface)){	

		var surface = manager.paint_surface, 
			ccr = surface_getpixel(surface,
				local_player.x * manager.paint_room_to_surface_scale_x,
				local_player.y * manager.paint_room_to_surface_scale_y);
				
		_return = ccr;
		
	}
	
	configuration_set_gameplay_property("current_local_player_sampler",_return)
}

RefreshPlayerSamplerTimer = time_source_create(time_source_global,12,time_source_units_frames,
	update_local_player_sampler,[self],-1);

function paint_team_color_refresh(){
	paint_team_one_color = [
		configuration_get_paint_property("paint_color_team_one_hue"),
		configuration_get_paint_property("paint_color_team_one_saturation"),
		configuration_get_paint_property("paint_color_team_one_brightness")
	];
	
	paint_team_two_color = [
		configuration_get_paint_property("paint_color_team_two_hue"),
		configuration_get_paint_property("paint_color_team_two_saturation"),
		configuration_get_paint_property("paint_color_team_two_brightness")
	];
}

function paint_surface_create(){
	paint_surface_fidelity = 
		configuration_get_paint_property("paint_surface_fidelity") ?? 0.75;
	
	paint_surface_width = room_width * paint_surface_fidelity;
	paint_surface_height = room_height * paint_surface_fidelity;
	
	paint_surface = surface_create(
		paint_surface_width,
		paint_surface_height,
		surface_r8unorm
	);	
		
	paint_room_to_surface_scale_x = paint_surface_width / room_width;
	paint_room_to_surface_scale_y = paint_surface_height /room_height;
	
	paint_surface_to_room_scale_x = room_width / paint_surface_width;
	paint_surface_to_room_scale_y = room_height / paint_surface_height;
	
	paint_surface_position_x = x - (surface_get_width(paint_surface) / 2) * paint_surface_to_room_scale_x;
	paint_surface_position_y = y - (surface_get_height(paint_surface) / 2) * paint_surface_to_room_scale_y;
	
	alarm[0] = paint_surface_refresh_time;
	
	surface_set_target(paint_surface);
    draw_clear_alpha(c_white, 0);
    surface_reset_target();
	
	time_source_start(RefreshPlayerSamplerTimer);
}

function paint_surface_destroy(){
	if(surface_exists(paint_surface)){
		alarm[0] = -1;
		paint_surface_refresh = false;
		surface_free(paint_surface);
		paint_surface = -1;
	}
}

function paint_queue_create(){
	paint_queue = ds_priority_create();
}

function paint_queue_destroy(){
	if(ds_exists(paint_queue,ds_type_priority)){
		ds_priority_empty(paint_queue);
		ds_priority_destroy(paint_queue);	
		paint_queue = -1;
	}
}

function paint_queue_insert(item,stamp){
	ds_priority_add(paint_queue,item,stamp);
}

function paint_surface_apply_paint(){	
	surface_set_target(paint_surface);
	
	while(!ds_priority_empty(paint_queue))
	{
		var cItem = ds_priority_delete_min(paint_queue),
			sX = cItem[$ "wX"] * paint_room_to_surface_scale_x,
			sY = cItem[$ "wY"] * paint_room_to_surface_scale_y,
			width = cItem[$ "width"],
			height = cItem[$ "height"],
			image = cItem[$ "paintImage"],
			rotation = irandom_range(0,359),
			abstractColor = cItem[$ "abstractColor"];
			
			draw_sprite_ext(image,0,sX,sY,width,height,rotation,abstractColor,1);
		
		delete cItem;
	}
	
	surface_reset_target();
	paint_surface_refresh = false;
}
