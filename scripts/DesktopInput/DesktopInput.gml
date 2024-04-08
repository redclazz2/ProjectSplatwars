function DesktopInputStrategy(_player_manager):IInputManagerStrategy(_player_manager) constructor{	
	InputCheckLeft = function(){
		return input_check("left");
	}

	InputCheckRight = function(){
		return input_check("right");
	}

	InputCheckUp = function(){
		return input_check("up");
	}

	InputCheckDown = function(){
		return input_check("down");
	}
	
	InputCheckAimDirection = function(){
		var player_agent = configuration_get_gameplay_property("current_local_player_instance"),
			_return = 0;
			
		if(player_agent != noone)
			_return = point_direction(player_agent.x,player_agent.y,mouse_x,mouse_y);
			
		return _return;
	}
}