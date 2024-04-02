function MobileInputStrategy(_player_manager):IInputManagerStrategy(_player_manager) constructor{	
	InputCheckLeft = function(){
		with(oJoyStickMovement){
		if((joy_x/radius) < -0.1){
			return true;
		}
		return false;
		}
	}

	InputCheckRight = function(){
		with(oJoyStickMovement){
		if((joy_x/radius) > 0.1){
			return true;
		}
		return false;
		}
	}

	InputCheckUp = function(){
		with(oJoyStickMovement){
		if((joy_y/radius) < -0.1){
			return true;
		}
		return false;
		}
	}

	InputCheckDown = function(){
		with(oJoyStickMovement){
		if((joy_y/radius) > 0.1){
			return true;
		}
		return false;
		}
	}
	
	InputCheckSpecialButton = function(){
		return keyboard_check_pressed(ord("E"));
	}
	
	InputCheckShootButtonOnPressed = function(){
		return mouse_check_button_pressed(mb_left);
	}
	
	InputCheckShootButtonPressed = function(){
		return mouse_check_button(mb_left);
	}
	
	InputCheckShootButtonOnReleased = function(){
		return mouse_check_button_released(mb_left);
	}
	
	InputCheckSubmergeButton = function(){
		return mouse_check_button(mb_right);
	}
	
	InputCheckAction = function(){
		var _return = {},
			movementInputPressed = InputCheckLeft() || InputCheckRight() || InputCheckUp() || InputCheckDown(),
			player_agent = player_manager.controllable_character;
		with(oJoyStickAim){
		_return[$ "aim"] = point_direction(player_agent.x,player_agent.y,player_agent.x + joy_x,player_agent.y + joy_y);
		}
		
		_return[$ "ShootOnPressed"] = InputCheckShootButtonPressed();
		_return[$ "ShootPressed"] = InputCheckShootButtonPressed();
		_return[$ "ShootOnReleased"] = InputCheckShootButtonOnReleased();
		
		_return[$ "SubmergeButton"] = InputCheckSubmergeButton();
		
		_return[$ "state"] = 1;
		
		switch (true) {
		    case movementInputPressed:
		        _return[$ "state"] = new AgentPlayerWalk(self.player_manager.controllable_character);
		        break;
		    // Add more cases if needed

		    // Default case for idle state
		    default:
		        _return[$ "state"] = new AgentPlayerIdle(self.player_manager.controllable_character);
		        break;
		}
		
		return _return;
	}
	
	InputCheckMovement = function(){
		var _return = {};
		
		_return[$ "Left"] = self.InputCheckLeft();
		_return[$ "Right"] = self.InputCheckRight()
		_return[$ "Up"] = self.InputCheckUp();
		_return[$ "Down"] = self.InputCheckDown();
		
		return _return;
	}
}