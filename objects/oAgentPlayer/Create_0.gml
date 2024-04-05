/// @description Player Definition
/*
 ___  _  ___ __   __ ___  ___        ___   ___  _____   ___   ___ 
| _ \| |/   \\ \ / /| __|| _ \      /   \ / __||_   _| / _ \ | _ \
|  _/| || - | \   / | _| |   /      | - || (__   | |  | (_) ||   /
|_|  |_||_|_|  |_|  |___||_|_\      |_|_| \___|  |_|   \___/ |_|_\

*/

event_inherited();

state_action = new AgentPlayerIdle(self);

#region Stats
	stats = {
		speed_walking						: 1.5,
		speed_unsubmerged					: 1,
		speed_submerged						: 5,
		speed_shooting						: 0,
		health_regen_unsubmerged			: 70,
		health_regen_submerged				: 200,
		health_regen_cooldown_unsubmerged	: 2,
		health_regen_cooldown_submerged		: 1
	};
	
	active_stats = {
		speed_active			: self.stats.speed_walking,
		health_active			: 1000,
		health_regen			: self.stats.health_regen_unsubmerged,
		health_regen_cooldown	: self.stats.health_regen_cooldown_unsubmerged,
	};
	
	latest_action = {
		aim_direction			: 0,
		shoot_pressed			: 0,
		shoot					: 0,
		shoot_released			: 0
	}
#endregion

#region Step Functions
	InputCheckMovement = function(){
		if (self.input_manager == undefined) return false;
		return self.input_manager.InputCheckMovement();
	}
	
	InputCheckAction = function(_MovementData){
		if (self.input_manager == undefined) return false;
		return self.input_manager.InputCheckAction(_MovementData);
	}

	ChangeStateAction = function(new_state){
		delete state_action;
		state_action = new_state;
	}
#endregion

#region Events
	//Step Event
	Step = function(){
		if(self.listen_to_input){
			var _MovementData = self.InputCheckMovement();
			strategy_position.Step(_MovementData);
			
			var _ActionData = self.InputCheckAction(_MovementData);
			ChangeStateAction(_ActionData[$ "state"]);
			
			latest_action[$ "aim_direction"]  = _ActionData[$ "aim"];
			latest_action[$ "shoot_pressed"]  = _ActionData[$ "ShootOnPressed"];
			latest_action[$ "shoot"]		  = _ActionData[$ "ShootPressed"];
			latest_action[$ "shoot_released"] = _ActionData[$ "ShootOnReleased"];
			
			state_action.Step(_ActionData);
		}
	}
	
	Draw = function(){
		state_action.Draw();
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
#endregion

#region Main Weapon
	var _team = configuration_get_gameplay_property("current_team"),
		_team_channel = configuration_get_gameplay_property("current_team_channel");

	main_weapon = instance_create_depth(
		x,y,depth - 1, oAgentWeaponShooter,
		{
			Team:			_team,
			TeamChannel:	_team_channel,
			WeaponConfig:	new AgentWeaponShooter(
								input_manager,
								input_manager.controllable_type,
								_team,
								_team_channel,
								generate_weapon(
									configuration_get_gameplay_property("current_weapon_index")
								),self
							)
		}
		
	);
	
	
	
#endregion

//Execution
if(strategy_position == undefined || 
	//state_action == undefined || 
	input_manager == undefined) 
		DestroyControllableCharacter();