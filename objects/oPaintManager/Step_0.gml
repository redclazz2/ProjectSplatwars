/// @description Debug Mouse Draw
if(debug_draw_mouse_enable){
	paint_queue_insert(new PaintItemStructure(
		mouse_x,mouse_y,1,1,sSplat01,debug_draw_mouse_team
	) ,delta_time);	
}