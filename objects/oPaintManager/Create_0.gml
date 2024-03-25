/// @description Paint Manager Definition
#region Object Variables
	x = room_width / 2;
	y = room_height / 2;

	paint_surface_width = 86;
	paint_surface_height = 86;

	paint_surface_scale_x = 0;
	paint_surface_scale_y = 0;

	paint_surface_position_x = 0;
	paint_surface_position_y = 0;

	paint_surface = -1;
	paint_surface_refresh = false;
	paint_surface_refresh_time = 4;

	paint_queue = -1;
#endregion

function paint_surface_create(){
	paint_surface = surface_create(
		paint_surface_width,
		paint_surface_height,
		surface_r8unorm
	);	
		
	paint_surface_scale_x = paint_surface_width / room_width;
	paint_surface_scale_y = paint_surface_height / room_height;
	
	paint_surface_position_x = x - surface_get_width(paint_surface)/2;
	paint_surface_position_y = y - surface_get_height(paint_surface)/2;
	
	alarm[0] = 4;
	
	surface_set_target(paint_surface);
    draw_clear_alpha(c_white, 0);
    surface_reset_target();
}

function paint_surface_destroy(){
	if(surface_exists(paint_surface))
	surface_free(paint_surface);
	paint_surface = -1;
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
			sX = cItem[$ "wX"] * paint_surface_scale_x,
			sY = cItem[$ "wY"] * paint_surface_scale_y,
			width = cItem[$ "width"],
			height = cItem[$ "height"],
			image = cItem[$ "paintImage"],
			rotation = irandom_range(0,359),
			abstractColor = cItem[$ "abstractColor"];
			
			draw_sprite_ext(image,0,sX,sY,width,height,rotation,abstractColor,1);
	}
	
	surface_reset_target();
	paint_surface_refresh = false;
}

paint_queue_create();
paint_queue_insert(new PaintItemStructure(
	100,100,1,1,sSplat01,make_color_rgb(0,0,0)),0);
paint_queue_insert(new PaintItemStructure(
	250,100,1,1,sSplat01,make_color_rgb(20,0,0)),1);