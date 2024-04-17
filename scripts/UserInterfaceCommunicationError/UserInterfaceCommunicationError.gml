function UserInterfaceCommunicationError():UserInterfaceSquidDecored() constructor{
	title_x = room_width / 2;
	title_y = (room_height / 2) - 10;
	
	instruction_text = scribble("[fGeneralFont][fa_center]A communication error has ocurred.");
	
	Step = function(){
		if device_mouse_check_button_pressed(0,mb_any){
			scene_system_set_target(5);
			scene_system_goto_next();
		}
	}
	
	DrawGUI = function(){
		draw_sprite_ext(sWhitePixel,0,0,title_y,320,22,0,c_black,0.6);
		instruction_text.draw(title_x,title_y);
	}
}