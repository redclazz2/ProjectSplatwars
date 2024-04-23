if(IS_DEBUG){
	draw_set_color(c_black);
	draw_rectangle(200,120,300,170,false);
	draw_set_color(c_white);
	draw_set_font(fGeneralFont);
	draw_text(210,140,$"H: {active_stats[$ "health_active"]}");
}

if(input_manager.controllable_type == InputTypes.LOCAL){
    opacity = clamp(1 - (active_stats[$ "health_active"] / 1000), 0, 1);
    draw_sprite_ext(sLowHealth, 0, 0, 0, 1, 1, 0, c_white, opacity);
	//Debug
	if (keyboard_check_pressed(vk_enter)) {
    active_stats[$ "health_active"] -= 100
    active_stats[$ "health_active"] = max(active_stats[$ "health_active"], 0);
	}
	
}



