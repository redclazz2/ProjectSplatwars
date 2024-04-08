/// @description Controllable Characters's Definition
/*
  ___   ___   _  _  _____  ___   ___   _     _     ___  ___  _     ___        ___   ___  ___  _  _  _____ 
 / __| / _ \ | \| ||_   _|| _ \ / _ \ | |   | |   /   \| _ )| |   | __|      /   \ / __|| __|| \| ||_   _|
| (__ | (_) || .  |  | |  |   /| (_) || |__ | |__ | - || _ \| |__ | _|       | - || (_ || _| | .  |  | |  
 \___| \___/ |_|\_|  |_|  |_|_\ \___/ |____||____||_|_||___/|____||___|      |_|_| \___||___||_|\_|  |_|  

This is the representation of the player in the game world.
*/

event_inherited();

#region Properties
	//Input Manager Link
	input_manager = self[$ "InputManager"] ?? undefined;
	strategy_position = self[$ "ControllableType"] == InputTypes.LOCAL ? 
		new ControllableAgentLocalPosition(self) : undefined;
	listen_to_input = false;
#endregion

#region Stats
	stats = {
		speed_walking						: 3,
		speed_unsubmerged					: 1,
		speed_submerged						: 5,
		speed_shooting						: 2.5,
	};
	
	active_stats = {
		speed_active			: self.stats.speed_walking,
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
		self.input_manager.DestroyControllableCharacter();
		self.input_manager = undefined;
		instance_destroy(self);
	}
	
	ToggleInputListening = function(){
		self.listen_to_input = self.listen_to_input ? false : true;
	}
	
	GetInputListening = function(){
		return self.listen_to_input;
	}
#endregion	

#region Input Checking
	InputCheckMovement = function(){
		if (self.input_manager == undefined) return false;
		return self.input_manager.InputCheckMovement();
	}
#endregion

#region Events
	//Step Event
	Step = function(){
		if(self.listen_to_input){
			strategy_position.Step();
		}
	}
#endregion

//Execution
if(strategy_position == undefined ||  
	input_manager == undefined) 
		DestroyControllableCharacter();