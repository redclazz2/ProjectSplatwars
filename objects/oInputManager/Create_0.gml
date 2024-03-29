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
	CreateControllableState = function(){
		var _return = undefined;
		
		if(controllable_type == InputTypes.LOCAL){
			show_debug_message("estoy entrando");

			_return = PLATFORM_TARGET == 0 ? new DesktopInputStrategy(self) : undefined; 
		}else if(InputTypes.REMOTE){
			//
		}
		show_debug_message("OK, STATE.");
		show_debug_message(_return);
		return _return;
	}

	function CreateDepthControllableCharacter(_x,_y,_depth){
		if(controllable_character == undefined){
			var _config = {};
			_config[$ "input_manager"] = self;
			_config[$ "player_type"] = self.controllable_type; 
			
			//TODO CAMBIAR EL TIPO DE AGENTE QUE SE CREA
			controllable_character = instance_create_depth(_x,_y,_depth,oAgentControllable,_config);
		}else{
			show_debug_message("W: Unable to create a controllable character. One is already instantiated!");
		}
	}

	DestroyControllableCharacter =  function(){
		if(controllable_character != undefined){
			instance_destroy(controllable_character);
			controllable_character = undefined;
		}else{
			show_debug_message("W: Unable to destroy a controllable character. None defined!");
		}
	}

	DestroyInputManager = function(){
		delete controllable_state;
	}
#endregion

#region Input Management	
	InputCheckMovement = function(){
		return controllable_state.InputCheckMovement();
	}
	
	InputCheckAction = function(){
		return controllable_state.InputCheckAction();
	}
#endregion

#region Properties
	controllable_type = self[$ "State"] ?? undefined;
	controllable_state = CreateControllableState();
	if(controllable_state == undefined) instance_destroy(self);

	controllable_character = undefined;
#endregion

#region Events
	function EventControllableCharacterCreate(){
		show_debug_message("RECIBI EL EVENTO!")
		CreateDepthControllableCharacter(20,20,-1);
	}
	
	function EventToggleInputListening(){
		controllable_character.ToggleInputListening();
	}

	pubsub_subscribe("CreateLocalControllableCharacter",EventControllableCharacterCreate);
	pubsub_subscribe("EnableLocalInputListening",EventToggleInputListening);
#endregion

CreateDepthControllableCharacter(20,20,-1);
EventToggleInputListening();