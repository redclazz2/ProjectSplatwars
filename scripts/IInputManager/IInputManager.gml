function IInputManagerStrategy(_player_manager) constructor{	
	
	player_manager = _player_manager;
	
	InputCheckLeft = function(){
		return false;
	}

	InputCheckRight = function(){
		return false;
	}

	InputCheckUp = function(){
		return false;
	}

	InputCheckDown = function(){
		return false;
	}
	
	InputCheckSpecialButton = function(){
		return input_check("special");
	}
	
	InputCheckShootButtonOnPressed = function(){
		return input_check_pressed("shoot");
	}
	
	InputCheckShootButtonPressed = function(){
		return input_check("shoot");
	}
	
	InputCheckShootButtonOnReleased = function(){
		return input_check_released("shoot");
	}
	
	InputCheckSubmergeButton = function(){
		return false;
	}

	InputCheckAimDirection = function(){
		return 0;
	}

	InputCheckAction = function(_MovementData){
		var _return = {},
			movementInputPressed = _MovementData[$ "Left"] || _MovementData[$ "Right"] || _MovementData[$ "Up"] || _MovementData[$ "Down"],
			shootInput = InputCheckShootButtonOnPressed() || InputCheckShootButtonPressed() || InputCheckShootButtonOnReleased();
		
		_return[$ "aim"] = InputCheckAimDirection();
		_return[$ "ShootOnPressed"] = InputCheckShootButtonPressed();
		_return[$ "ShootPressed"] = InputCheckShootButtonPressed();
		_return[$ "ShootOnReleased"] = InputCheckShootButtonOnReleased();
		_return[$ "SubmergeButton"] = InputCheckSubmergeButton();
		_return[$ "state"] = 1;
		
		switch (true) {
			case shootInput:
				_return[$ "state"] = new AgentPlayerShoot(self.player_manager.controllable_character);
				break;
			
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