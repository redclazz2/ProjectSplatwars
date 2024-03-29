/// @description Controllable Characters's Definition
/*
  ___   ___   _  _  _____  ___   ___   _     _     ___  ___  _     ___        ___   ___  ___  _  _  _____ 
 / __| / _ \ | \| ||_   _|| _ \ / _ \ | |   | |   /   \| _ )| |   | __|      /   \ / __|| __|| \| ||_   _|
| (__ | (_) || .  |  | |  |   /| (_) || |__ | |__ | - || _ \| |__ | _|       | - || (_ || _| | .  |  | |  
 \___| \___/ |_|\_|  |_|  |_|_\ \___/ |____||____||_|_||___/|____||___|      |_|_| \___||___||_|\_|  |_|  

This is the representation of the player in the game world.
*/
#region Properties
	//Input Manager Link
	input_manager = self[$ "input_manager"] ?? undefined;
	strategy_position = self[$ "player_type"] == InputTypes.LOCAL ? 
		new ControllableAgentLocalPosition(self) : undefined;
	state_action = undefined;//new ControllableCharacterIdleAction(self);
	listen_to_input = false;
#endregion

#region Stats
	stats = self[$ "stats"] ?? {
		speed_walking						: 3,
		speed_unsubmerged					: 1,
		speed_submerged						: 5,
		speed_shooting						: 2.5,
		health_regen_unsubmerged			: 0.7,
		health_regen_submerged				: 4,
		health_regen_cooldown_unsubmerged	: 2,
		health_regen_cooldown_submerged		: 1
	};
	
	active_stats = {
		speed_active			: self.stats.speed_walking,
		health_regen			: self.stats.health_regen_unsubmerged,
		health_regen_cooldown	: self.stats.health_regen_cooldown_unsubmerged
	};
#endregion

#region Stats Functions
	GetActiveStat = function(stat){
		return self.active_stats[$ stat];
	}

	ModifyActiveStat = function(stat,value){
		self.active_stats[$ stat] = value;
	}
#endregion

#region Input Manager's Functions
	DestroyControllableCharacter = function(){
		if(self.strategy_position != undefined) delete self.strategy_position;
		if(self.state_action != undefined)  delete self.state_action;
		self.input_manager.DestroyControllableCharacter();
		self.input_manager = undefined;
		instance_destroy(self);
	}
	
	ToggleInputListening = function(){
		self.listen_to_input = self.listen_to_input ? false : true;
	}
#endregion	

#region Input Checking
	InputCheckMovement = function(){
		if (self.input_manager == undefined) return false;
		return self.input_manager.InputCheckMovement();
	}
	
	InputCheckAction = function(){
		if (self.input_manager == undefined) return false;
		return self.input_manager.InputCheckAction();
	}
#endregion

#region State Actions Functions
	ChangeStateAction = function(new_state){
		delete state_action;
		state_action = new_state;
	}
#endregion

#region Events
	//Step Event
	Step = function(){
		if(self.listen_to_input){
			strategy_position.Step();
			
			/*var _ActionData = self.InputCheckAction();
			ChangeStateAction(_ActionData[$ "state"]);
			struct_remove(_ActionData,"state");
			
			state_action.Step(_ActionData);*/
		}
	}
	
	Draw = function(){
		/*state_action.Draw();*/
	}
#endregion

//Execution
if(strategy_position == undefined || 
	//state_action == undefined || 
	input_manager == undefined) 
		DestroyControllableCharacter();
		
cam_follow(follow.mpeek,self);