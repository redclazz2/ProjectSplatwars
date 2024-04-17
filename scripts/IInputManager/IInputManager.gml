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
		return input_check("transform");
	}

	InputCheckAimDirection = function(){
		return 0;
	}
		
	InputCheckAction = function(_MovementData){
		var _return = {};
		
		_return[$ "aim"] = InputCheckAimDirection();
		_return[$ "ShootOnPressed"] = InputCheckShootButtonPressed();
		_return[$ "ShootPressed"] = InputCheckShootButtonPressed();
		_return[$ "ShootOnReleased"] = InputCheckShootButtonOnReleased();
		_return[$ "SubmergeButton"] = InputCheckSubmergeButton();
		_return[$ "SpecialButton"] = InputCheckSpecialButton();
		_return[$ "state"] = 1;
		
		var	movementInputPressed = _MovementData[$ "Left"] || _MovementData[$ "Right"] || _MovementData[$ "Up"] || _MovementData[$ "Down"],
			shootInput = _return[$ "ShootOnPressed"] || _return[$ "ShootPressed"] || _return[$ "ShootOnReleased"],
			submergeInput = _return[$ "SubmergeButton"];
		
		switch (true) {
			case submergeInput:
				var	_currentSampler = configuration_get_gameplay_property("current_local_player_sampler"),
					_currentTeamChannel =	configuration_get_gameplay_property("current_team_channel");
				
				_currentSampler = _currentSampler == 18 ? 20 : _currentSampler;

				if(_currentSampler == _currentTeamChannel){
					_return[$ "state"] = new AgentPlayerSubmerged(self.player_manager.controllable_character);
					break;
				}
			
			case shootInput:
				_return[$ "state"] = new AgentPlayerShoot(self.player_manager.controllable_character);
				break;
			
		    case movementInputPressed:
		        _return[$ "state"] = new AgentPlayerWalk(self.player_manager.controllable_character);
		        break;

		    default:
		        _return[$ "state"] = new AgentPlayerAction(self.player_manager.controllable_character);
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
		_return[$ "Input"] = _return[$ "Left"] || _return[$ "Right"] || _return[$ "Up"] || _return[$ "Down"]
		return _return;
	}
}