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
	
	request = time_source_create(
		time_source_global,
		4,
		time_source_units_seconds,
		InitializeMatchmaking,
	)
	
	time_source_start(timeout);
	time_source_start(request);
	
	Step = function(){
		self.SquidInstances();
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
		
		if(time_source_exists(request)){
			time_source_stop(request);
			time_source_destroy(request);
		}
	}
}