function MobileInputStrategy(_player_manager):IInputManagerStrategy(_player_manager) constructor{	
	InputCheckLeft = function(){
		if(input_check("left") > 0){
			return true;
		}
		return false;
	}

	InputCheckRight = function(){
		if(input_check("right") > 0){
			return true;
		}
		return false;		
	}

	InputCheckUp = function(){
		if(input_check("up") > 0){
			return true;
		}
		return false;	
	}

	InputCheckDown = function(){
		if(input_check("down") > 0){
			return true;
		}
		return false;	
	}
	
	InputCheckSpecialButton = function(){
		return keyboard_check_pressed(ord("E"));
	}
	
	InputCheckShootButtonOnPressed = function(){
		return mouse_check_button_pressed(mb_left);
	}
	
	InputCheckShootButtonPressed = function(){
		return input_check("shoot")
	}
	
	InputCheckShootButtonOnReleased = function(){
		return mouse_check_button_released(mb_left);
	}
	
	InputCheckSubmergeButton = function(){
		return mouse_check_button(mb_right);
	}
	
	InputCheckAction = function(){
		var _return = {},
			movementInputPressed = InputCheckLeft() || InputCheckRight() || InputCheckUp() || InputCheckDown();
			
		_return[$ "aim"] = point_direction(
			0,0,
			oInputManager.vAimStick.get_x(),
			oInputManager.vAimStick.get_y());
		
		_return[$ "ShootPressed"] = InputCheckShootButtonPressed();
		
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