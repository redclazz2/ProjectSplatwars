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
		//TODO: change to UI btn
		return keyboard_check_pressed(ord("E"));
	}
	
	InputCheckShootButton = function(){
		//TODO: change to UI btn
		return mouse_check_button(mb_left);
	}
	
	InputCheckSubmergeButton = function(){
		//TODO: change to UI btn
		return mouse_check_button(mb_right);
	}
	
	InputCheckAction = function(){
		var _return = {},
			movementInputPressed = InputCheckLeft() || InputCheckRight() || InputCheckUp() || InputCheckDown();
		
		_return[$ "aim_x"] = mouse_x;	//IMPORTANT: CHANGE THIS
		_return[$ "aim_y"] = mouse_y;	//IMPORTANT: CHANGE THIS
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