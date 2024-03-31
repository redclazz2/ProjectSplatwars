function DesktopInputStrategy(_player_manager):IInputManagerStrategy(_player_manager) constructor{	
	InputCheckLeft = function(){
		return keyboard_check(ord("A"));
	}

	InputCheckRight = function(){
		return keyboard_check(ord("D"));
	}

	InputCheckUp = function(){
		return keyboard_check(ord("W"));
	}

	InputCheckDown = function(){
		return keyboard_check(ord("S"));
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
			movementInputPressed = InputCheckLeft() || InputCheckRight() || InputCheckUp() || InputCheckDown();
		
		_return[$ "aim_x"] = mouse_x;	//IMPORTANT: CHANGE THIS
		_return[$ "aim_y"] = mouse_y;	//IMPORTANT: CHANGE THIS
		
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
		_return[$ "Right"] = self.InputCheckRight();
		_return[$ "Up"] = self.InputCheckUp();
		_return[$ "Down"] = self.InputCheckDown();
		
		return _return;
	}
}