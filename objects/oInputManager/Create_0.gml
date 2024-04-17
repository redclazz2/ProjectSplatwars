///@description Input Manager's Definition
/*
 ___  _  _  ___  _   _  _____        __  __  ___  _  _  ___   ___  ___  ___ 
|_ _|| \| || _ \| | | ||_   _|      |  \/  |/   \| \| |/   \ / __|| __|| _ \
 | | | .  ||  _/| |_| |  | |        | |\/| || - || .  || - || (_ || _| |   /
|___||_|\_||_|   \___/   |_|        |_|  |_||_|_||_|\_||_|_| \___||___||_|_\

This object has the following GM options enabled:
	PERSISTENT

This object is in charge of reading player input. It can be
either configured to read local or remote input data.
*/

#region Functions
	function CreateControllableState(){
		var _return = undefined;
		
		if(controllable_type == InputTypes.LOCAL){
			_return = PLATFORM_TARGET == 0 ? new DesktopInputStrategy(self) : new MobileInputStrategy(self); 
			
			if(PLATFORM_TARGET == 1){
				vMovementStick = input_virtual_create()
				.circle(50,128,25)
				.thumbstick(undefined, "left", "right", "up", "down")
				.threshold(0.3,1.0)
				.follow(true)
				.release_behavior(INPUT_VIRTUAL_RELEASE.RESET_POSITION);
	
				vAimStick = input_virtual_create()
					.circle(265,128,25)
					.thumbstick("shoot",undefined, undefined, undefined, undefined)
					.threshold(0.3,1.0)
					.follow(true)
					.release_behavior(INPUT_VIRTUAL_RELEASE.RESET_POSITION);
			}
		}else if(InputTypes.REMOTE){
			//
		}
		return _return;
	}
	//current_local_player_instance
	function CreateDepthControllableCharacter(_x,_y,_depth,_team,_team_channel){
		if(controllable_character == undefined){
			var _config = new AgentControllableDescription(
				_team,
				_team_channel,
				self,
				self.controllable_type
			);
			
			//TODO CAMBIAR EL TIPO DE AGENTE QUE SE CREA
			controllable_character = instance_create_depth(_x,_y,_depth,oAgentPlayer,_config);
		}else{
			show_debug_message("W: Unable to create a controllable character. One is already instantiated!");
		}
	}

	function DestroyControllableCharacter(){
		if(controllable_character != undefined){
			instance_destroy(controllable_character);
			controllable_character = undefined;
			
			if(controllable_type == InputTypes.LOCAL) 
				configuration_set_gameplay_property("current_local_player_instance",noone);
		}else{
			show_debug_message("W: Unable to destroy a controllable character. None defined!");
		}
	}

	function DestroyInputManager(){
		DestroyControllableCharacter();
		delete controllable_state;
	}
#endregion

#region Input Management	
	function InputCheckMovement(){
		return controllable_state.InputCheckMovement();
	}
	
	function InputCheckAction(_MovementData){
		return controllable_state.InputCheckAction(_MovementData);
	}
#endregion

#region Properties Initialization
	controllable_id = self[$ "Id"] ?? undefined;
	controllable_type = self[$ "State"] ?? undefined;
	
	controllable_state = CreateControllableState();
	
	if(controllable_state == undefined ||
		controllable_id == -1
	) instance_destroy(self);

	controllable_character = undefined;
#endregion

#region Local Events
	function EventControllableCharacterCreate(_data){
		CreateDepthControllableCharacter(120,70,-1,_data[0],_data[1]);
		//Temporal code to spawn player in the oSpawnPosition
		with(oSpawnPosition){
			other.controllable_character.x = x;
			other.controllable_character.y = y;
		}
		
		configuration_set_gameplay_property("current_local_player_instance",
			self.controllable_character);
		
		CameraFocusOnTarget(
			configuration_get_gameplay_property("current_local_player_instance")
		);
	}
	
	function EventToggleInputListening(){
		if(controllable_character != undefined)	
			controllable_character.ToggleInputListening();
	}
	
	function EventControllableCharacterDestroy(){
		DestroyControllableCharacter();
	}
#endregion
