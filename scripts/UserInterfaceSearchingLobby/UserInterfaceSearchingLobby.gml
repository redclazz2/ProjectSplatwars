function UserInterfaceSearchingLobby():UserInterfaceSquidDecored() constructor{
	title_x = room_width / 2;
	title_y = (room_height / 2) - 10;
	
	scribble_anim_pulse(0.2,0.05);
	instruction_text = scribble("[fGeneralFont][pulse][fa_center]Searching for a battle to join...");
	
	timeout = time_source_create(
		time_source_global,
		120,
		time_source_units_seconds,
		change_manager_user_interface,
		[new UserInterfaceCommunicationError()]
	)
	
	time_source_start(timeout);
	
	Step = function(){
		self.SquidInstances();
		if device_mouse_check_button_pressed(0,mb_any){	
			change_manager_user_interface(new UserInterfaceLobby());
		}
	}
	
	DrawGUI = function(){
		draw_sprite_ext(sWhitePixel,0,0,title_y,320,22,0,c_black,0.6);
		instruction_text.draw(title_x,title_y);
	}
	
	CleanUp = function(){
		if(time_source_exists(timeout)){
			time_source_stop(timeout);
			time_source_destroy(timeout);
		}
	}
}