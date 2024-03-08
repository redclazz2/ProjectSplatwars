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
*/

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
#endregion

#region Scene System
	scene_struct = {
		current_scene: undefined,
		previous_scene: undefined,
		next_scene: undefined,
		fallback_scene: undefined
	};
	
	#region Scene Struct Gets & Sets
		/* Note: A set for current scene isn't declared
				since in no point during gameplay you should
				change the running scene. Instead move to
				next scene or in error, move to fallback.
				
		Getter function for current_scene*/		
		function get_current_scene() {
		    return scene_struct.current_scene;
		}

		// Getter function for previous_scene
		function get_previous_scene() {
		    return scene_struct.previous_scene;
		}

		// Setter function for previous_scene
		function set_previous_scene(new_scene) {
		    scene_struct.previous_scene = new_scene;
		}

		// Getter function for next_scene
		function get_next_scene() {
		    return scene_struct.next_scene;
		}

		// Setter function for next_scene
		function set_next_scene(new_scene) {
		    scene_struct.next_scene = new_scene;
		}

		// Getter function for fallback_scene
		function get_fallback_scene() {
		    return scene_struct.fallback_scene;
		}

		// Setter function for fallback_scene
		function set_fallback_scene(new_scene) {
		    scene_struct.fallback_scene = new_scene;
		}	
	#endregion
	
#endregion

#region Game Configuration
	
#endregion

#region Debug Menus
	if(IS_DEBUG) show_debug_overlay(true,true);
#endregion