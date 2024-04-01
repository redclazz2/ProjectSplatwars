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
			_return = PLATFORM_TARGET == 0 ? new DesktopInputStrategy(self) : new  MobileInputStrategy(self); 
		}else if(InputTypes.REMOTE){
			//
		}
		return _return;
	}

	function CreateDepthControllableCharacter(_x,_y,_depth){
		if(controllable_character == undefined){
			var _config = new AgentControllableDescription(
				AgentTeamTypes.ALPHA,
				AgentTeamChannelTypes.ALPHA,
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
	
	function InputCheckAction(){
		return controllable_state.InputCheckAction();
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

#region Events
	function EventControllableCharacterCreate(_id){
		if(_id == controllable_id) 
			CreateDepthControllableCharacter(20,20,-1);
	}
	
	function EventToggleInputListening(_id){
		if(_id == controllable_id && controllable_character != undefined)	
			controllable_character.ToggleInputListening();
	}
	
	function EventControllableCharacterDestroy(_id){
		if(_id == controllable_id) 
			DestroyControllableCharacter();
	}
#endregion
