function UserInterfaceDebug(_test_message) : IUserInterface() constructor{
	test_message = _test_message;
	
	DrawGUI = function(){
		draw_text(30,30,test_message);
	}
}

function UserInterfaceMainMenu() : IUserInterface() constructor{
	title_x = room_width / 2;
	title_y = (room_height / 2) - 15;
	
	instruction_text = scribble("[fGeneralFont][fa_center][blink]Tap to Start!");
	instruction_y = (room_height / 2) + 45;
	
	squid_max_instances = 6;
	
	announcer_software_version = configuration_get_property("software_version_release");
	announcer_software_year = configuration_get_property("software_year_release");
	
	announcer_text = 
		scribble($"[fa_center][scale,0.25]v.{announcer_software_version},{announcer_software_year}");
	announcer_y = room_height - 5;
	
	
	Step = function(){
		var _instance_squid_number = instance_number(obj_SquidDecor),
			_squid_creation_x = random_range(0,320),
			_squid_creation_y = 175;
			
		if(_instance_squid_number < squid_max_instances){
			instance_create_depth(_squid_creation_x,
				_squid_creation_y, 0, obj_SquidDecor);
		}
		
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

function UserInterfaceTimer() : IUserInterface() constructor{
	timer_x = 160;
	timer_y = 5; 
	t = ""
	t_min = 0 // Minutes
	t_sec = 10 // Seconds

	function DestroyTimerMatch(){
		time_source_stop(TimerMatch)
		time_source_destroy(TimerMatch)
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
		t = ""
		t += string(t_min)
		t += ":"
		if t_sec > 9 {t += ""+string(t_sec)}
		if t_sec < 10 {t += "0"+string(t_sec)}
	}
	
	DrawGUI = function(){
	draw_set_colour(c_white)
	draw_set_font(fGeneralFont)
	draw_set_halign(fa_center)
	draw_text(timer_x, timer_y, t)
	draw_set_halign(fa_left)
	}
}