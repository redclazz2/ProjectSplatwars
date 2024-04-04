function surface_to_sampler(surface){
	var sampler,width,height,surfaceBuffer,surfey;
	sampler = ds_map_create();
	
	if !(surface_exists(surface))
	{
		surfey = surface_create(10,10);
	}
	else
	{
		surfey = surface;
	}
	
	width = surface_get_width(surfey);
	height = surface_get_height(surfey);
	
	ds_map_add(sampler,"width",width);
	ds_map_add(sampler,"height",height);
	
	surfaceBuffer = buffer_create(width*height*4,buffer_fixed,1);
	buffer_get_surface(surfaceBuffer,surfey,0);
	ds_map_add(sampler,"data",surfaceBuffer);
	
	return sampler;
}

/// @description
/// @param {real} ind
/// @param {real} x
/// @param {real} y
/// @param {real} width
/// @param {real} height
function buffer_getpixel_r(argument0, argument1, argument2, argument3, argument4) {
	var buff1 = argument0;
	if (argument1 >= argument3) || (argument2 >= argument4) return 0;

	var px = (argument1+(argument2*argument3))*4;
	var p1 = buffer_peek(buff1,px+2,buffer_u8);

	return (p1);
}