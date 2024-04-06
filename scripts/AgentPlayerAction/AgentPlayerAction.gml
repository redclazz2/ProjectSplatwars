function AgentPlayerAction(_character) constructor{
	controllable_character = _character;
	self.controllable_character.image_alpha = 1;
	current_optional_speed = 0;
	self.controllable_character.latest_action[$ "able_to_weapon"] = true;
	
	ModifySprite = function(_Movement){
		if(_Movement) self.controllable_character.sprite_index = sPlayerWalk;
		else self.controllable_character.sprite_index = sPlayerIdle;
	}
	
	ModifySpriteDirection = function(_aim){
		if(_aim > 90 && _aim < 270){
			controllable_character.image_xscale = -1;
		}else{
			controllable_character.image_xscale = 1;
		}
	}
	
	Step = function(args, movement){
		ModifySprite(movement[$ "Input"]);
		ModifySpriteDirection(args[$ "aim"]);
		
		var _currentSampler = configuration_get_gameplay_property("current_local_player_sampler"),
			_currentTeamChannel =	configuration_get_gameplay_property("current_team_channel");	
		_currentSampler = _currentSampler == 18 ? 20 : _currentSampler;
		
		if(_currentSampler == 255 || _currentTeamChannel == _currentSampler){
			controllable_character.active_stats[$ "speed_active"] = current_optional_speed;
		}else{
			self.controllable_character.active_stats[$ "speed_active"] =
			self.controllable_character.stats[$ "speed_enemy_ink"];
		}
		
		
	}
	
	Draw = function(){
		with(controllable_character){
			draw_self();
		}
	}
	
	DrawUI = function(){}
}