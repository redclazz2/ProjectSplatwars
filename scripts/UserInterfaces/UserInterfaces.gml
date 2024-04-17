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
			change_manager_user_interface(new UserInterfaceConnecting());		
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

function TeamStatusIcon() constructor{
	current_sprite = sPlayer
	
	draw = function(x,y){
		draw_sprite(current_sprite,0,x,y);
	}
	
	update_sprite = function(sprite){
		current_sprite = sprite;
	}
}

function UserInterfaceTeamStatus() : IUserInterface() constructor{
	
	team_alpha = [
		new TeamStatusIcon(),
		new TeamStatusIcon(),
		new TeamStatusIcon(),
		new TeamStatusIcon(),
	];
	
	team_bravo = [
		new TeamStatusIcon(),
		new TeamStatusIcon(),
		new TeamStatusIcon(),
		new TeamStatusIcon(),
	];
	
	Step = function(){
	
		if keyboard_check_pressed(vk_enter)
		{
			UpdateIconStatus (1,0,sPlayerDead);
		}
		if keyboard_check_pressed(vk_enter)
		{
			UpdateIconStatus (1,1,sPlayerOffline);
		}
		
	}
	
	DrawGUI = function(){
		
		draw_sprite(sBar,0,160,16)
		
		team_alpha[0].draw(120,16);
		team_alpha[1].draw(104,16);
		team_alpha[2].draw(88,16);
		team_alpha[3].draw(72,16);
		
		team_bravo[0].draw(200,16);
		team_bravo[1].draw(216,16);
		team_bravo[2].draw(232,16);
		team_bravo[3].draw(248,16);
		
	}
	
	UpdateIconStatus = function(team,team_pos,sprite){
		var _list = team == AgentTeamTypes.ALPHA ? team_alpha : team_bravo;
		
		_list[team_pos].update_sprite(sprite);
	}
}


function UserInterfaceTimer() : IUserInterface() constructor{
	timer_x = 160;
	timer_y = 5; 
	t = ""
	t_min = 3 // Minutes
	t_sec = 0 // Seconds

	function DestroyTimerMatch(){
		time_source_stop(TimerMatch);
		time_source_destroy(TimerMatch);
	}

	function LogicTimer(_Parent){
		if (_Parent.t_sec == 0 && _Parent.t_min == 0){
		 //pubsub_publish()
		 _Parent.DestroyTimerMatch()
		}else{
			_Parent.t_sec -= 1
			if _Parent.t_sec = -1 { 
				_Parent.t_sec = 59
				_Parent.t_min -= 1
			}
		}
	}
	
	TimerMatch = time_source_create(time_source_global, 1, time_source_units_seconds, LogicTimer, [self], -1);
	time_source_start(TimerMatch);
	
	Step = function(){
		t = "";
		t += string(t_min);
		t += ":";
		if t_sec > 9 {t += ""+string(t_sec)}
		if t_sec < 10 {t += "0"+string(t_sec)}
	}
	
	DrawGUI = function(){
    draw_set_font(fGeneralFont);

    draw_set_colour(c_dkgray);
    draw_set_halign(fa_center);
    draw_text(timer_x, timer_y+1, t);
    draw_set_halign(fa_left);

    draw_set_color(c_white);

    draw_set_colour(c_black);
    draw_set_halign(fa_center);
    draw_text(timer_x, timer_y, t);
    draw_set_halign(fa_left);
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
	
	//Variables para saltarse el tutorial
	time_in_screen = room_speed * 15;
	time_to_skip = 3 * room_speed;
	elapsed_time_to_skip = 0;
	
	//Variables que manejan el stage del tutorial
	transition_stage = true;
	current_stage = 0;
	
	//Variables para manejar el dibujado de la UI
	title_text = noone;
	subtitle_text = noone;
	
	//Variables STAGE 1
	checkpoints_count = noone;
	
	//Variables STAGE 2
	training_dummies_count = noone;
	
	//Variables STAGE 3 && 4
	time_remains = room_speed * 10;
	
	DrawGUI = function(){
		//Funcionalidad para saltar el tutorial
		if(time_in_screen>0){
			draw_sprite_ext(sWhitePixel,0,(x_screen/2)-75,y_screen-12,150,12,0,c_black,0.7);
			skip_text = scribble("[fSubtitleFont][fa_center][blink][c_yellow]Hold anywhere " + string(ceil((time_to_skip/room_speed) - (elapsed_time_to_skip/room_speed))) + " secs to skip");
			skip_text.draw(x_screen/2,y_screen-10);
		}
		
		//Switch-case para manejar los estados del tutorial
		switch (current_stage){
		//GUI: TUTORIAL DE MOVIMIENTO
		case 0:
		//Iniciar el setup de la GUI
		if(transition_stage){
			title_text =  scribble("[fGeneralFont][fa_center]Welcome to the Tutorial!");
			checkpoints_count = instance_number(oCheckpointInactive)
			transition_stage = false;
		}
		//Dynamic GUI
		subtitle_text =  scribble("[fSubtitleFont][fa_center][rainbow]Stage 1:[/rainbow] use the left joystick to [c_green]activate [c_white]the [c_orange](" + string(checkpoints_count) + ") [c_white]checkpoints");
		break;
		
		//GUI: TUTORIAL DE DISPARO
		case 1:
		//Iniciar el setup de la GUI
		if(transition_stage){
			title_text =  scribble("[fGeneralFont][fa_center]That's what I'm talking about!");
			training_dummies_count = instance_number(oAgentTrainingDummie);
			transition_stage = false;
		}
		//Dynamic GUI
		subtitle_text =  scribble("[fSubtitleFont][fa_center][rainbow]Stage 2:[/rainbow] use the right joystick to [c_red]shoot [c_white]the [c_orange](" + string(training_dummies_count) + ") [c_white]dummies");
		break;
		
		//GUI: TUTORIAL DE PINTURA
		case 2:
		//Iniciar el setup de la GUI
		if(transition_stage){
			title_text =  scribble("[fGeneralFont][fa_center]Now YOU are the artist!");
			transition_stage = false;
			pubsub_publish("PaintSurfaceApply",new PaintItemStructure(275,500,10,10,sSplat01,make_color_rgb(20,0,0)));
			
		}
		//Dynamic GUI
		subtitle_text =  scribble("[fSubtitleFont][fa_center][rainbow]Stage 3:[/rainbow] shoot the enemy paint to gain [c_yellow]Control [c_white]within [c_orange](" + string(ceil(time_remains / room_speed)) + ") [c_white]seconds");
		break;
		
		//GUI: TUTORIAL DE ESCONDERSE
		case 3:
		//Iniciar el setup de la GUI
		if(transition_stage){
			title_text =  scribble("[fGeneralFont][fa_center]It's time to hide and seek!");
			transition_stage = false;
			pubsub_publish("PaintSurfaceApply",new PaintItemStructure(700,500,10,10,sSplat01,make_color_rgb(0,0,0)));
		}
		//Dynamic GUI
		subtitle_text =  scribble("[fSubtitleFont][fa_center][rainbow]Stage 4:[/rainbow] press and hold the [c_teal]Submerge button [c_white]for [c_orange](" + string(ceil(time_remains / room_speed)) + ") [c_white]secs");
		break;
		
		//GUI: TUTORIAL FINALIZADO
		case 4:
		if(transition_stage){
			title_text =  scribble("[fGeneralFont][fa_center]SplatWars Time!");
			subtitle_text =  scribble("[fSubtitleFont][fa_center][rainbow]Press any button to continue...[/rainbow]");
			transition_stage = false;
		}
		}
		
		//Dibujado de la GUI - ALWAYS
		draw_sprite_ext(sWhitePixel,0,0,y_screen-165,x_screen,22,0,c_black,0.7);
		draw_sprite_ext(sWhitePixel,0,0,y_screen-143,x_screen,12,0,c_black,0.7);
		title_text.draw(x_screen/2,y_screen-165);
		subtitle_text.draw(x_screen/2,y_screen-143);
	}
	
	Step = function(){
		//Funcionalidad para saltar el tutorial
		if(time_in_screen>0){
		time_in_screen--;
		if device_mouse_check_button(0,mb_any){
			elapsed_time_to_skip++;
		}else{
			elapsed_time_to_skip = 0;
		}
		
		if(elapsed_time_to_skip>=time_to_skip){
			time_in_screen = 0;
			scene_system_set_target(5);
			scene_system_goto_next();
		}
		}
		
		//Switch-case para manejar los estados del tutorial
		switch(current_stage){
			
		//LÓGICA: TUTORIAL DE MOVIMIENTO
		case 0:
		 //Workflow
		 checkpoints_count = instance_number(oCheckpointInactive)
		 
		 //Conditional next stage
		 if(checkpoints_count == 0){
			transition_stage = true;
			current_stage++;
			//Delete line sefcheck
			player_instance = configuration_get_gameplay_property("current_local_player_instance");
			//Teleport player next stage
			player_instance.x = 480;
			player_instance.y = 800;
		 }
		break;
		
		//LÓGICA: TUTORIAL DE DISPARO
		case 1:
		//Workflow
		training_dummies_count = instance_number(oAgentTrainingDummie);
		
		//Conditional next stage
		if(training_dummies_count = 0){
			transition_stage = true;
			current_stage++;
			//Teleport player next stage
			player_instance.x = 200;
			player_instance.y = 500;
		}
		break;
		
		//LÓGICA: TUTORIAL DE PINTURA
		case 2:
		//Workflow
		if input_check("shoot") {
		time_remains--;
		}
		
		//Conditional next stage
		if(time_remains <= 0){
			transition_stage = true;
			current_stage++;
			time_remains = room_speed * 10;
			//Teleport player next stage
			player_instance.x = 700;
			player_instance.y = 500;
		}
		break;
		
		//LÓGICA: TUTORIAL DE ESCONDERSE
		case 3:
		//Workflow
		if input_check("transform") {
		time_remains--;
		}
		
		//Conditional next stage
		if(time_remains <= 0){
			transition_stage = true;
			current_stage++;
		}
		break;
		
		//LÓGICA: TUTORIAL FINALIZADO
		case 4:
			if device_mouse_check_button_pressed(0,mb_any){
			scene_system_set_target(5);
			scene_system_goto_next();
		}
		break;
		}
	}
}