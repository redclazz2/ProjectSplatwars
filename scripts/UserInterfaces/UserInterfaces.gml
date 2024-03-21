function UserInterfaceDebug(_test_message) : IUserInterface() constructor{
	test_message = _test_message;
	
	DrawGUI = function(){
		draw_text(30,30,test_message);
	}
}

function UserInterfaceMainMenu() : IUserInterface() constructor{
	title_x = room_width / 2;
	title_y = (room_height / 2) - 40;
	
	instruction_text = scribble("[fGeneralFont][fa_center][blink]Tap to Start!");
	instruction_y = (room_height / 2) + 15;
	
	squid_max_instances = 8;
	
	Step = function(){
		var _instance_squid_number = instance_number(obj_SquidDecor),
			_squid_creation_x = random_range(0,320),
			_squid_creation_y = 175;
			
		if(_instance_squid_number < squid_max_instances){
			instance_create_depth(_squid_creation_x,
				_squid_creation_y, 0, obj_SquidDecor);
		}
	}
	
	DrawGUI = function(){
		draw_sprite(sMainLogo,0,title_x,title_y);
		instruction_text.draw(title_x, instruction_y);
	}	
}