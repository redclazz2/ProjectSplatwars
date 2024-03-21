/// @description System Definition
/*
	  ___                             _        __  __                    __ _           
	 / __| ___  _ _   ___  _ _  __ _ | |      |  \/  | __ _  _ _   __ _ / _` | ___  _ _ 
	| (_ |/ -_)| ' \ / -_)| '_|/ _` || |      | |\/| |/ _` || ' \ / _` |\__. |/ -_)| '_|
	 \___|\___||_||_|\___||_|  \__/_||_|      |_|  |_|\__/_||_||_|\__/_||___/ \___||_|  

	The general manager for this project is the entry point of all logic related to splatwars.
	The following are the most important utilities that this manager creates.
	
	Event System: Allows communication between objects in a scene.
	Scene System: Allows loading different game "screens".
	Game Configuration: Holds all the configuration data for the game.
	
	For detail description of these systems please check the game's
	dev manual.
*/

debug_views = [];

#region Event System
	enum ps_event{
		inst_id = 0,
		inst_func = 1
	}
		
	event_struct = {};
		
	subscribe = function(_id, _event, _func) {
		if (is_undefined(event_struct[$ _event])) {
			event_struct[$ _event] = [];
		} else if (is_subscribed(_id, _event) != -1) {
			return;
		} 
		array_push(event_struct[$ _event], [_id, _func]);
	}

	publish = function(_event, _data) {
		var _subscriber_array = event_struct[$ _event];
	
		if (is_undefined(_subscriber_array)) {
			return;
		}
	
		for (var i = (array_length(_subscriber_array) - 1); i >= 0; i -= 1) {
			if (instance_exists(_subscriber_array[i][ps_event.inst_id])) {
				_subscriber_array[i][ps_event.inst_func](_data);
			} else {
				array_delete(_subscriber_array, i, 1);
			}
		}
	}

	is_subscribed = function(_id, _event) {
		for (var i = 0; i < array_length(event_struct[$ _event]); i += 1) {
		    if (event_struct[$ _event][i][ps_event.inst_id] == _id) {
		        return i;
		    }
		}  
		return -1;
	}

	unsubscribe = function(_id, _event) {
		if (is_undefined(event_struct[$ _event])) return;
	  
		var _pos = is_subscribed(_id, _event);
		if (_pos != -1) {
			array_delete(event_struct[$ _event], _pos, 1);
		}
    
	}

	unsubscribe_all = function(_id) {
		var _keys_array = variable_struct_get_names(event_struct);
		for (var i = (array_length(_keys_array) - 1); i >= 0; i -= 1) {
			unsubscribe(_id, _keys_array[i]);
		}
	}

	remove_event = function(_event) {
		if (variable_struct_exists(event_struct, _event)) {
			variable_struct_remove(event_struct, _event);
		}
	}

	remove_all_events = function() {
		delete event_struct;
		event_struct = {};
	}

	remove_dead_instances = function() {
		var _keys_array = variable_struct_get_names(event_struct);
		for (var i = 0; i < array_length(_keys_array); i += 1) {
			var _keys_array_subs = event_struct[$ _keys_array[i]];
			for (var j = (array_length(_keys_array_subs) - 1); j >= 0; j -= 1) {
				if (!instance_exists(_keys_array_subs[j][0])) {
					array_delete(event_struct[$ _keys_array[i]], j, 1);
				}
			}
		}
	}
	
	event_system_cleanup = function(){
		self.remove_all_events();
		delete self.event_struct;
	}
#endregion

#region Scene System
	scene_struct = {
		current_scene: -1,
		previous_scene: ds_stack_create(),
		previous_scene_stack_limit: 3, //Greater than 2
		next_scene: -1,
		fallback_scene: rm_fallback,
		mid_transition: false,
		squence_layer: undefined
	};
	
	#region Scene Struct Gets & Sets
		/* Note: A set for current scene isn't declared
				since in no point during gameplay you should
				change the running scene. Instead move to
				next scene or in error, move to fallback. */
					
		function scene_get_current() {
		    return scene_struct.current_scene;
		}

		function scene_get_previous() {
		    return scene_struct.previous_scene;
		}

		function scene_set_previous(new_scene) {
		    scene_struct.previous_scene = new_scene;
		}

		function scene_get_next() {
		    return scene_struct.next_scene;
		}

		function scene_set_next(new_scene) {
		    scene_struct.next_scene = new_scene;
		}

		function scene_get_fallback() {
		    return scene_struct.fallback_scene;
		}

		function scene_set_fallback(new_scene) {
		    scene_struct.fallback_scene = new_scene;
		}	
	#endregion
	
	#region Scene Logic
		function scene_goto_target(){
			self.scene_struct.current_scene = 
					self.scene_struct.next_scene;
			room_goto(self.scene_struct.next_scene);
			self.scene_struct.next_scene = -1;
		}
		
		function scene_goto_previous(){
			var prvId = ds_stack_pop(self.scene_struct.previous_scene);
			
			if(prvId == undefined || prvId == -1){				
				logger(LOGLEVEL.ERROR, "Unable to go to previous scene. Fallback.", "Scene System");
				self.scene_struct.next_scene = 
					self.scene_struct.fallback_scene;
			}
			else self.scene_struct.next_scene = prvId;
			scene_goto_start();
		}
		
		function scene_goto_next(){
			var crId = self.scene_struct.current_scene,
				nxId = self.scene_struct.next_scene,
				stkMax = self.scene_struct.previous_scene_stack_limit,
				stk = self.scene_struct.previous_scene;
			//Stack full? Clear then push last.
			if(ds_stack_size(stk) == stkMax){	
				logger(LOGLEVEL.WARN,"Prev Stck full. Clean-up. Are resources being overused?","Scene System");
				var lstId = ds_stack_pop(stk);
				ds_stack_clear(stk);
				ds_stack_push(stk, lstId);
			}
			//Save to stack. Else fallback.	
			if(nxId != -1 && nxId != undefined)
				ds_stack_push(stk, crId);
			else
				logger(LOGLEVEL.ERROR,"Unable to move to next scene. Reference invalid. Fallback.","Scene System");			
			
			scene_goto_start();
		}
		
		function scene_goto_start(){
			scene_transition_start(self.scene_struct.next_scene,
				sqTransitionOut,sqTransitionIn);
		}
	#endregion
	
	#region Scene Transition
		function scene_transition_place_sequence(type){
			if (layer_exists("transition")) layer_destroy("transition")
			var _lay = layer_create(-9999,"transition")
			self.scene_struct.squence_layer = layer_sequence_create(_lay,0,0,type);	
		}
		
		function scene_transition_start(_roomObjective,_typeOut, _typeIn)
		{
			if (!self.scene_struct.mid_transition)
			{
				self.scene_struct.mid_transition = true;
				scene_transition_place_sequence(_typeOut);
				layer_set_target_room(_roomObjective)
				scene_transition_place_sequence(_typeIn);
				layer_reset_target_room();
				return true;
			}
			else return false
		}
	
		function scene_transition_finished()
		{
			layer_sequence_destroy(self.scene_struct.squence_layer);
			self.scene_struct.mid_transition = false;
		}
	#endregion
	
	#region Scene System Clean up
		function scene_previous_stack_cleanup(){
			logger(LOGLEVEL.INFO,"Cleaned Previous Scene Stack.","Scene System");
			ds_stack_clear(self.scene_struct.previous_scene);	
		}
		
		function scene_system_cleanup(){
			self.scene_previous_stack_cleanup();
			ds_stack_destroy(self.scene_struct.previous_scene);
			self.scene_struct.previous_scene = -1;
			delete self.scene_struct;
		}
	#endregion
	
	#region Scene System Debug
		var scnStc = ref_create(self,"scene_struct");
		var nxtScn = ref_create(scnStc,"next_scene");
		var crrScn = ref_create(scnStc,"current_scene");
		var fllbScn = ref_create(scnStc,"fallback_scene");
		
		array_push(self.debug_views,dbg_view("Scene System",false));
		
		//Watch
		array_push(self.debug_views,dbg_section("Scene Struct Watch:"));
		array_push(self.debug_views,dbg_watch(nxtScn,"Next Scene"));
		array_push(self.debug_views,dbg_watch(crrScn,"Current Scene"));
		array_push(self.debug_views,dbg_watch(fllbScn,"Fallback Scene"));
		
		//Pointers
		array_push(self.debug_views,dbg_section("Scene Pointers"));
		
		array_push(self.debug_views,dbg_drop_down(nxtScn,
			"Undefined:-1,Scene1:2,Scene2:3,Main menu:5","Next Scene:"));
		
		array_push(self.debug_views,dbg_section("Scene Actions"));
		
		var nxtScnBtn = ref_create(self,"scene_goto_next");
		array_push(self.debug_views,dbg_button("Goto Next",nxtScnBtn));
		
		var prvScnBtn = ref_create(self,"scene_goto_previous");
		array_push(self.debug_views,dbg_button("Goto Prev",prvScnBtn));
		
		var stckClnBtn = ref_create(self,"scene_previous_stack_cleanup");
		array_push(self.debug_views,dbg_button("Clean Prev. Stack",stckClnBtn));
	#endregion
#endregion

#region Game Configuration
	
#endregion

#region Debug Menu Activation
	if(IS_DEBUG) show_debug_overlay(true,true);
	else show_debug_overlay(false);
#endregion