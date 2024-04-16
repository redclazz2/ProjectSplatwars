function UserInterfaceDebug(_test_message) : IUserInterface() constructor{
	test_message = _test_message;
	
	DrawGUI = function(){
		draw_text(30,30,test_message);
	}
}

function UserInterfaceSquidDecored() : IUserInterface() constructor{
	squid_max_instances = 6;
	
	SquidInstances = function(){
		var _instance_squid_number = instance_number(obj_SquidDecor),
			_squid_creation_x = random_range(0,320),
			_squid_creation_y = 175;
			
		if(_instance_squid_number < squid_max_instances){
			instance_create_depth(_squid_creation_x,
				_squid_creation_y, 0, obj_SquidDecor);
		}
	}
}

function UserInterfaceMainMenu() : UserInterfaceSquidDecored() constructor{
	title_x = room_width / 2;
	title_y = (room_height / 2) - 15;
	
	instruction_text = scribble("[fGeneralFont][fa_center][blink]Tap to Start!");
	instruction_y = (room_height / 2) + 45;
	
	announcer_software_version = configuration_get_property("software_version_release");
	announcer_software_year = configuration_get_property("software_year_release");
	
	announcer_text = 
		scribble($"[fa_center][scale,0.25]v.{announcer_software_version},{announcer_software_year}");
	announcer_y = room_height - 5;
	
	Step = function(){
		self.SquidInstances();
		
		if device_mouse_check_button_pressed(0,mb_any){
			scene_system_set_target(2);
			scene_system_goto_next();
		}
	}
	
	DrawGUI = function(){
		draw_sprite_ext(sWhitePixel,0,0,instruction_y,320,22,0,c_black,0.6);
		draw_sprite_ext(sStudioLogo,0,15,170,0.2,0.2,0,c_white,1);
		draw_sprite(sMainLogo,0,title_x,title_y);
		
		
		instruction_text.draw(title_x, instruction_y);
		announcer_text.draw(title_x,announcer_y);
	}	
}

function UserInterfaceSetUsername() : UserInterfaceSquidDecored() constructor{
	title_x = room_width / 2;
	title_y = (room_height / 2) + 40;
	
	instruction_text = scribble("[fGeneralFont][fa_center]How'd you like to be called?");
	
	Step = function(){
		self.SquidInstances();
	}
	
	DrawGUI = function(){
		draw_sprite_ext(sWhitePixel,0,0,title_y,320,22,0,c_black,0.6);
		instruction_text.draw(title_x,title_y);
	}
}

function UserInterfaceTutorial() : IUserInterface() constructor{
	//Definición del tamaño de la pantalla
	x_screen = 320;
	y_screen = 180;
	
	//Llamado al jugador para verificar su instancia en el mapa
	player_instance = configuration_get_gameplay_property("current_local_player_instance");
	
	//Variables que manejan el stage del tutorial
	transition_stage = true;
	current_stage = 0;
	
	//Variables para manejar el dibujado de la UI
	title_text = noone;
	subtitle_text = noone;
	
	//Variables STAGE 1
	checkpoints_count = noone;
	
	DrawGUI = function(){
		//Switch-case para manejar los estados del tutorial
		switch (current_stage){
		//GUI: TUTORIAL DE MOVIMIENTO
		case 0:
		//Iniciar el setup de la GUI
		if(transition_stage){
			title_text =  scribble("[fGeneralFont][fa_center]Welcome to the Tutorial!");
			checkpoints_count = instance_number(oSpawnPosition)
			subtitle_text =  scribble("[fSubtitleFont][fa_center][rainbow]Stage 1:[/rainbow] use the joystick to [c_green]activate [c_white]the [c_orange](" + string(checkpoints_count) + ") [c_white]checkpoints");
			transition_stage = false;
		}
		//Dibujado de la GUI
		draw_sprite_ext(sWhitePixel,0,0,15,320,22,0,c_black,0.7);
		draw_sprite_ext(sWhitePixel,0,0,37,320,12,0,c_black,0.7);
		title_text.draw(160,15);
		subtitle_text.draw(160,37);
		break;
		}
	}
	
	Step = function(){
		//Switch-case para manejar los estados del tutorial
		switch(current_stage){
		//LÓGICA: TUTORIAL DE MOVIMIENTO
		case 0:
		
		break;
		}
	}
}