draw_self();

if(input_manager.controllable_type == InputTypes.LOCAL){
	if (active_stats[$ "charge"] == 100) {
		draw_set_font(fSubtitleFont);
		draw_text_scribble(x-35, y-22, "[rainbow]Ability Ready!!");
	}
}


