/// @desc Setup the Camera
/// Kamera Version 1.3.3
/// Feather disable GM2017

#region "DELETE" This region completely if you already have a "V1.4.0 KOYAN-STATE-SYSTEM" Set up on your project || https://koyan.itch.io/state
	/// @desc Used to create or define states || It has (Start, BeginStep, Step, EndStep, End) Events to control the created states
	/// @param {function} [__start]		This event will only works once when state is first summoned
	/// @param {function} [__beginstep] This event will work after Start and then will always be summoned before Step event
	/// @param {function} [__step]		This event will always be summoned between BeginStep and EndStep
	/// @param {function} [__endstep]	This event will be summoned after the Step is done
	/// @param {function} [__end]		This event will only be summoned if the current state ends its use
	function kState(__start = undefined, __beginstep = undefined, __step = undefined, __endstep = undefined, __end = undefined) constructor {
		Start		= __start;
		BeginStep	= __beginstep;
		Step		= __step;
		EndStep		= __endstep;
		End			= __end;
	}

	/// @desc The Machine every event and every system can and are controlled by this construct
	/// @param {bool} [_open_debug_panel] Allow to see local debug inside the output window
	function kStateMachine(_open_debug_panel = false) constructor {
		enum kTransition {_kNo_sprite, _kInstant, _kFinished, _kAsync};

		__LocalDebug = _open_debug_panel; // For writing analytics and datas of the states and events to output panel

		kBank	  = [];
		kPrevious = undefined;
		kCurrent  = undefined;
		kPaused	  = false;
		kTimer	  = 0;

		kSpriteIndex  = "sprite_index";
		kImageIndex	  = "image_index";
		kImageSpeed   = "image_speed";
		kObjectIndex  = other.object_index;
		kObjectId	  = other.id;
		kCurrentIndex = variable_instance_get(kObjectId, kImageIndex);

		/// @desc This function is local so you should not use this outside of this script 
		/// @returns {real}
		GetIndex = function(__StateName) {
			var _return = undefined;
			for (var i = 0; i < array_length(kBank); ++i) {_return = kBank[i][0] == __StateName ? i : _return;}

			return _return;
		}

		/// @desc This event should be redefined by self || This event is the starter setup of the machine its like an alternative Create event || This event will be summoned by the Update event
		/// @returns {undefined}
		static Initialize	  = function() {
			if (__LocalDebug) 
				{show_debug_message("|--| Machine START |" + object_get_name(kObjectIndex) + " |--|");}

			return undefined;
		}

		/// @desc This event should be redefined by self || This event will work before the target event's Start event || This event will be summoned by the Update event
		/// @returns {undefined}
		static BeforeStart = function() {
			return undefined;	
		}

		/// @desc This event should be redefined by self || This event will work before the target event's Begin Step event || This event will be summoned by the Update event
		/// @returns {undefined}
		static BeforeBeginStep = function() {
			return undefined;	
		}

		/// @desc This event should be redefined by self || This event will work before the target event's Step event || This event will be summoned by the Update event
		/// @returns {undefined}
		static BeforeStep = function() {
			return undefined;	
		}

		/// @desc This event should be redefined by self || This event will work before the target event's End Step event || This event will be summoned by the Update event
		/// @returns {undefined}
		static BeforeEndStep = function() {
			return undefined;	
		}

		/// @desc This event should be redefined by self || This event will work before the target event's End event || This event will be summoned by the Update event
		/// @returns {undefined}
		static BeforeEnd   = function() {
			return undefined;	
		}

		/// @desc This event is the heart of the system anything is setuped in here || This event should be placed in a Step or Draw event
		/// @returns {bool}
		static Update		  = function() {
			
			// (Auto) Debug Pause
			if (__LocalDebug && keyboard_check_pressed(vk_pause)) {AutoPause();}

			if (!kPaused && !is_undefined(kCurrent)) {
				kTimer += 1/60; // Event Timer

				if (!is_undefined(BeforeBeginStep()))				{BeforeBeginStep();}
				if (!is_undefined(kBank[kCurrent][1].BeginStep))	{kBank[kCurrent][1].BeginStep();}
				if (!instance_exists(other.id))						{return false;}

				if (!is_undefined(BeforeStep()))					{BeforeStep();}
				if (!is_undefined(kBank[kCurrent][1].Step))			{kBank[kCurrent][1].Step();}
				if (!instance_exists(other.id))						{return false;}

				if (!is_undefined(BeforeEndStep()))					{BeforeEndStep();}
				if (!is_undefined(kBank[kCurrent][1].EndStep))		{kBank[kCurrent][1].EndStep();}
				if (!instance_exists(other.id))						{return false;}

				return true;
			}

			// When machine is (Paused) This event will work
			Pause();

			return false;
		}

		/// @desc DEPRECIATED!!! || This event should be redefined by the user || This event is like a customizable empty event || This event should be placed in a Step or Draw event, below or above of the summoned .Update(); Event
		/// @returns {undefined}
		static Addition		  = function() {
			return undefined;
		}

		/// @desc This event should be redefined by self || This event will work when the State Machine is set to Pause
		/// @returns {undefined}
		static Pause		  = function() {
			return undefined;
		}

		/// @desc  This event is used to add states created by kState() to the kStateMachine() State bank so we can use them
		/// @param	 {string} __StateName State string name that created by kState()
		/// @param	 {struct} __StateToAdd State instance/constructor name that created by kState()
		/// @returns {bool}
		static AddState		  = function(__StateName, __StateToAdd) {
			kBank[array_length(kBank)] = [__StateName, __StateToAdd]; // (0) - (1)

			if (__LocalDebug)
				{show_debug_message("-Added State : " + string(__StateName) + " | " + object_get_name(kObjectIndex) + " | ");}
		}

		/// @desc This event is used to delete states created by kState() from the kStateMachine() State bank so we can erase them
		/// @param	 {string} __StateName State string name that created by kState()
		/// @returns {bool}
		static DeleteState	  = function(__StateName) {
			array_delete(kBank, GetIndex(__StateName), 1);
			array_sort(kBank, true);

			if (__LocalDebug)
				{show_debug_message("-Deleted State : " + string(__StateName) + " | " + object_get_name(kObjectIndex) + " | ");}
		}

		/// @desc This event when summoned will change kStateMachine() Pause status
		/// @returns {bool}
		static AutoPause	  = function() {
			kPaused = !GetPause();

			if (__LocalDebug)
				{show_debug_message("|--| Is Machine PAUSED | " + string(GetPause()) + " |--| " + object_get_name(kObjectIndex) + " |");}

			return kPaused;
		}

		/// @desc This event when summoned will change the currently used state to the targeted one
		/// @param   {string}	[__StateName] Target state's name
		/// @param	 {real}		[__StateTransition] Which transition type will it be || Default is kTransition._kInstant
		/// @returns {bool}
		static SetCurrent	  = function(__StateName, __StateTransition = kTransition._kInstant) {
			if (!instance_exists(other.id)) {return false;} // If the summoner object dont exist then exit

			// (Local) Function to change states accordingly
			var __changeState	= function(__EnterStateNameAgain) {
				if (!is_undefined(GetIndex(__EnterStateNameAgain))) {
					kPrevious = kCurrent;
					kCurrent  = GetIndex(__EnterStateNameAgain);
					kTimer	  = 0;

					// If All States have a common "END" Event Summon this (Global) "END" Event
					if (!is_undefined(BeforeEnd())) {BeforeEnd();}

					// First Summon (Previous) States (End) Event Once
					if (!is_undefined(kPrevious) && !is_undefined(kBank[kPrevious][1].End)) {kBank[kPrevious][1].End();}

					// If All States have a common "START" Event Summon this (Global) "START" Event
					if (!is_undefined(BeforeStart())) {BeforeStart();}

					// Then Summon (Current) States (Start) Event Once
					if (!is_undefined(kCurrent) && !is_undefined(kBank[kCurrent][1].Start)) {kBank[kCurrent][1].Start();}

					if (__LocalDebug)
						{show_debug_message("-Change to '" + string(kBank[kCurrent][0]) + "' state | " + object_get_name(kObjectIndex) + " |");}
				}
			}

			// (Shortcut)
			var __S_index = variable_instance_get(kObjectId, kSpriteIndex);
			var __I_index = variable_instance_get(kObjectId, kImageIndex);
			var __I_Spd	  = variable_instance_get(kObjectId, kImageSpeed);

			// (Change) States accordingly to their (Enum) Paramaters
			if		(!is_undefined(GetIndex(__StateName)) && !GetCurrent(__StateName)) {
				switch (__StateTransition) {
					case kTransition._kFinished :
						if (__I_index >= sprite_get_number(__S_index) - (sprite_get_speed(__S_index)/game_get_speed(gamespeed_fps))*__I_Spd) {
							__changeState(__StateName);

							// (Reset) The index number
							kCurrentIndex = 0;
							variable_instance_set(kObjectId, kImageIndex, kCurrentIndex);

							return true;
						}

						// (Add) To index number automaticly so animation can reach its end no matter where change state is summoned from
						variable_instance_set(kObjectId, kImageIndex, kCurrentIndex);
						kCurrentIndex += (sprite_get_speed(__S_index)/game_get_speed(gamespeed_fps))*__I_Spd;
					break;

					case kTransition._kInstant :
						__changeState(__StateName);

						// (Reset) The index number
						kCurrentIndex = 0;
						variable_instance_set(kObjectId, kImageIndex, kCurrentIndex);

						return true;
					break;

					case kTransition._kAsync :
						__changeState(__StateName);

						// (Set) Next state sprite's index number to current one so it will be (Asynced)
						variable_instance_set(kObjectId, kImageIndex, kCurrentIndex);

						return true;
					break;

					default :
						if (__LocalDebug)
							{show_debug_message("|--| NO SPRITE | " + object_get_name(kObjectIndex) + " | |--|");}

						// (Change) The state without touching the sprite stuff
						__changeState(__StateName);

						return true;
					break;
				}
			}
			else if (__LocalDebug) {
				show_debug_message("-Machine cannot find a state named | " + string(__StateName) + " | " + object_get_name(kObjectIndex) + " |");
			}

			return false;
		}

		/// @desc  This event is used to change the built-in kStateMachine() Variables
		/// @param {any} __varChanged Write the built-in variable that will change
		/// @param {any} [__varChangedTo] Write the built-in variable that will be changed to
		/// @returns {bool}
		static SetVariable    = function(__varChanged, __varChangedTo = undefined) {
			if (!instance_exists(other.id)) {return false;} // If the summoner object dont exist then exit

			if (!is_undefined(__varChangedTo)) {
				switch(__varChanged) {
					case "kImageIndex"  : case "kimageindex"  : case "image_index"  : kImageIndex  = __varChangedTo; break;
					case "kSpriteIndex" : case "kspriteindex" : case "sprite_index" : kSpriteIndex = __varChangedTo; break;
					case "kImageSpeed"  : case "kimagespeed"  : case "image_speed"  : kImageSpeed  = __varChangedTo; break;
					case "kObjectIndex" : case "kobjectindex" : case "object_index" : kObjectIndex = __varChangedTo; break;
					case "kObjectId"    : case "kobjectid"    : case "id"			: kObjectId	   = __varChangedTo; break;
				}

				if (__LocalDebug)
					{show_debug_message("-New variable type names | " + object_get_name(kObjectIndex) + " |\n| Sprite - " + string(kSpriteIndex) + " | Index - " + string(kImageIndex) + " | Speed - " + string(kImageSpeed) + " | Obj Index - " + string(kObjectIndex) + " | Obj ID - " + string(kObjectId))}

				return true;
			}

			return false;
		}

		/// @desc  This event is used to get the built-in kStateMachine() Variables
		/// @param	 {string} __varChanged Write the built-in variable name you want to get in string form
		/// @returns {any}
		static GetVariable    = function(__varChanged) {
			if (!instance_exists(other.id)) {return false;} // If the summoner object dont exist then exit

			switch(__varChanged) {
				case "kImageIndex"  : case "kimageindex"  : case "image_index"  : return kImageIndex;	break;
				case "kSpriteIndex" : case "kspriteindex" : case "sprite_index" : return kSpriteIndex;	break;
				case "kImageSpeed"  : case "kimagespeed"  : case "image_speed"  : return kImageSpeed;	break;
				case "kObjectIndex" : case "kobjectindex" : case "object_index" : return kObjectIndex;	break;
				case "kObjectId"    : case "kobjectid"    : case "id"			: return kObjectId;		break;
			}
		}

		/// @desc This event is to determine the Pause status of the kStateMachine()
		/// @param	 {bool} __boolean True for Pause || False for UnPause
		/// @returns {bool}
		static SetPause		  = function(__boolean) {
			kPaused = __boolean;

			return __boolean;
		}

		/// @desc This event lets us determine how much time has been passed since the state is started working as seconds
		/// @returns {real}
		static GetTimer		  = function() {
			//if (__LocalDebug) {show_debug_message("-State Timer : " + string(kTimer));}
			return kTimer;
		}

		/// @desc This event lets us get the Pause status of the kStateMachine()
		/// @returns {bool}
		static GetPause		  = function() {
			if (__LocalDebug)
				{show_debug_message("|--| Is Machine PAUSED | " + string(kPaused) + " |--| " + object_get_name(kObjectIndex) + " |");}

			return kPaused;
		}

		/// @desc This event lets us get the Previously used state's name
		/// @param	 {string} [__StateName] There is two ways of this one is string like GetPrevious("idle") and one is true/false for GetPrevious() == "idle" situations
		/// @returns {any}
		static GetPrevious	  = function(__StateName = undefined) {
			if (!instance_exists(other.id)) {return false;} // If the summoner object dont exist then exit

			if (!is_undefined(__StateName)) {if (kPrevious == GetIndex(__StateName)) {return true;} else {return false}} // (Alternative) Outcome

			if (__LocalDebug && is_undefined(kPrevious)) // (False) Outcome
				{show_debug_message("-Previous | UNDEFINED | " + object_get_name(kObjectIndex) + " |"); return undefined;}

			return kBank[kPrevious][0]; // (Main) Outcome
		}

		/// @desc This event lets us get the Currently used state's name
		/// @param	 {string} [__StateName] There is two ways of this one is string like GetCurrent("idle") and one is true/false for GetCurrent() == "idle" situations
		/// @returns {any}
		static GetCurrent	  = function(__StateName = undefined) {
			if (!instance_exists(other.id)) {return false;} // If the summoner object dont exist then exit

			if (!is_undefined(__StateName)) {if (kCurrent == GetIndex(__StateName)) {return true;} else {return false}} // (Alternative) Outcome

			if (__LocalDebug && is_undefined(kCurrent)) // (False) Outcome
				{show_debug_message("-Current | UNDEFINED | " + object_get_name(kObjectIndex) + " |"); return undefined;} 

			return kBank[kCurrent][0]; // (Main) Outcome
		}

		/// @desc This event is for debug purpose || Gets the object's kStateMachine(); State bank's data
		/// @param	 {real} [__type] If you want state name's as a string then it should be (0) || (1) Returns state function itself
		/// @returns {array}
		static GetStateBank	  = function(__type = 1) {
			if (!instance_exists(other.id)) {return false;} // If the summoner object dont exist then exit

			var __values = [];
			for (var i = 0; i < array_length(kBank); ++i) {__values[array_length(__values)] = kBank[i][__type];}

			return __values;
		}

		/// @desc This event is for debug purpose || Shows all from the object's kStateMachine(); Data to output log
		static GetDebug		  = function(_show_events = false)  {
			if (!instance_exists(other.id)) {return false;} // If the summoner object dont exist then exit

			show_debug_message($"|-----------({object_get_name(kObjectIndex)})-----------|");
				//show_debug_message("-How Many Machines Created : "	  + string(kAmountOfMachinesCreated));
				show_debug_message($"-Is Machine Paused | {string(GetPause())} |");
				show_debug_message($"-State Timer | {string(GetTimer())} |");
				show_debug_message($"-Previous | {(!is_undefined(kPrevious) ? kBank[kPrevious][0] : "no previous defined")} |");
				show_debug_message($"-Current | {(!is_undefined(kCurrent)  ? kBank[kCurrent][0]  : "no current defined")}  |");

				for (var i  = 0; i < array_length(kBank); ++i) {
					var _names = kBank[i][0], _events = kBank[i][1]; 
					if (!_show_events) {_events = "log closed";}

					show_debug_message($"-{i + 1}.State name : {string(_names)}\n-{i + 1}.Event list : {string(_events)}");
				}
		}

		// These are debug purposes only || Lets you keep track of how many kStateMachine(); Is created inside the project
		static kAmountOfMachinesCreated = 0;
		kAmountOfMachinesCreated++;
	}

	/// State Version 1.4.0
#endregion

// You can remove the (k_debug_def) In below its just a state system's debug output it has nothing to do with the camera object
machine	= new kStateMachine(k_debug_def);

wait_mode			= new kState();
follow_target		= new kState();
follow_mouse		= new kState();
peak_follow_target	= new kState();
pan_follow_target	= new kState();
drag_follow_mouse	= new kState();
border_follow_mouse	= new kState();
move_to_click		= new kState();
move_to_target		= new kState();
celeste_mode		= new kState();

machine.Initialize		 = function() {
	#region "NEVER" Touch or use this little region
		var picked;
		picked				= string_split(k_view_def, "x");
		k_view_def_edited	= [real(picked[0]), real(picked[1])];
		picked				= string_split(k_resolution_def, "x");
		k_res_def_edited	= [real(picked[0]), real(picked[1])];
		picked				= string_split(k_display_def, "x");
		k_disp_def_edited	= [real(picked[0]), real(picked[1])];
		picked				= string_split(k_gui_def, "x");
		k_gui_def_edited	= [real(picked[0]), real(picked[1])];
	#endregion

	k_res_w   = k_res_def_edited[0];
	k_res_h   = k_res_def_edited[1];

	k_disp_w  = k_disp_def_edited[0];
	k_disp_h  = k_disp_def_edited[1];

	k_gui_w	= k_gui_def_edited[0];
	k_gui_h	= k_gui_def_edited[1];

	k_view_w  = k_view_def_edited[0];
	k_view_h  = k_view_def_edited[1];

	k_spd		 = k_spd_def;
	k_mode		 = k_mode_def;
	k_zoom		 = k_zoom_def;
	k_free		 = k_freeroam_def;
	k_angle		 = k_angle_def;
	k_debug		 = k_debug_def;
	k_target	 = k_target_def;
	k_offset_x	 = k_offset_x_def;
	k_offset_y	 = k_offset_y_def;
	k_fullscreen = k_fullscreen_def;

	view_index			= 0;
	zoom_limit			= [0.1, 2]; // (Min) - (Max)
	debug_shortcut		= vk_end;
	fullscreen_shortcut = vk_f11;

	shake_Remain	= 0;
	shake_Length	= 0;
	shake_Magnitude = 0;

	target_lost = false;

	d_surf_width  = display_get_width()/2;
	d_surf_height = display_get_height()/2;
	debug_surface = surface_create(d_surf_width, d_surf_height);

	#region (Default) - Camera Setup
		kamera		  = camera_create_view(0, 0, k_view_w, k_view_h, k_angle, noone, k_spd, k_spd);
		global.kamera = kamera; // Outside Usage
	#endregion
	#region (Default) - Viewport Setup
		setup_view = function() {
    		room_set_camera(room, view_index, kamera);
			room_set_viewport(room, view_index, true, 0, 0, k_view_w, k_view_h);
			room_set_view_enabled(room, false);

			view_set_camera(view_index, kamera);
			view_set_visible(view_index, false);

			view_camera[view_index]  = kamera;
			view_visible[view_index] = true;
			view_enabled			 = true;
		}
		setup_view(); // (Summon)
	#endregion
	#region (Default) - Other Setup
		window_set_size(k_disp_w, k_disp_h);
		surface_resize(application_surface, k_res_w, k_res_h);
		display_set_gui_size(k_gui_w, k_gui_h);

		if (!window_get_fullscreen()) {window_center();}
		display_mouse_set(display_get_width()/2, display_get_height()/2);
	#endregion

	#region (Control) - Function Setup || Outside use
		global.k_set_view_size	 = function (_width, _height)								{camera_set_view_size(kamera, _width, _height);		k_view_w = _width;	k_view_h = _height;}
		global.k_set_disp_size	 = function (_width, _height)								{window_set_size(_width, _height);					k_disp_w = _width;	k_disp_h = _height;}
		global.k_set_gui_size	 = function (_width, _height)								{display_set_gui_size(_width, _height);				k_gui_w  = _width;	k_gui_h  = _height;}
		global.k_set_res_size	 = function (_width, _height, _surf = application_surface)	{surface_resize(_surf, _width, _height);				k_res_w  = _width;	k_res_h  = _height;}
		global.k_set_pos		 = function (_xx, _yy)										{camera_set_view_pos(kamera, _xx, _yy);				machine.SetCurrent("wait_mode", kTransition._kNo_sprite);}
		global.k_set_speed		 = function (_x_speed = k_spd, _y_speed = k_spd)			{camera_set_view_speed(kamera, _x_speed, _y_speed);	k_spd    = _x_speed;}
		global.k_set_angle		 = function (_angle)										{camera_set_view_angle(kamera, _angle);				k_angle  = _angle;}
		global.k_set_offset_x	 = function (_x_value)										{k_offset_x = _x_value;}
		global.k_set_offset_y	 = function (_y_value)										{k_offset_y = _y_value;}
		global.k_set_target		 = function (_target = undefined)							{
			if (_target != noone && !is_undefined(_target) && instance_exists(_target)) {k_target = _target;}
			else																		{k_target = k_target_def;}
		}
		global.k_set_mode		 = function (_mode)											{
			var _alert = true;
			for (var i = 0; i < array_length(machine.GetStateBank()[0]); ++i) {
				if (!is_undefined(_mode) && string(_mode) == string(machine.GetStateBank()[0][i]))
					{_alert = false;}
			}

			if (_alert) {
				show_debug_message("-Kamera Cant Find A Mode Named | " + string(_mode) + " | " + object_get_name(object_index) + " |");
			}
			else {
				k_mode = string(_mode);
				machine.SetCurrent(string(_mode), kTransition._kNo_sprite);
			}
		}
		global.k_set_zoom		 = function (_percentage = k_zoom)							{
			k_zoom		= clamp(k_zoom, zoom_limit[0], zoom_limit[1]);		// (Limit) Zoom
			_percentage = clamp(_percentage, zoom_limit[0], zoom_limit[1]);	// (Limit) Percentage

			var _value_w_pre = camera_get_view_width(kamera);
			var _value_h_pre = camera_get_view_height(kamera);

			var _value_w = round(k_view_w/_percentage);
			var _value_h = round(k_view_h/_percentage);

			camera_set_view_size(kamera, _value_w, _value_h);
			camera_set_view_pos(kamera, camera_get_view_x(kamera) - (_value_w - _value_w_pre)/2, camera_get_view_y(kamera) - (_value_h - _value_h_pre)/2);

			//if (k_debug) {show_debug_message("-Zoom : {0}%", round(k_zoom*100));}
		}
		global.k_set_fullscreen	 = function (_screen_mode, _center_window)					{
			window_set_fullscreen(_screen_mode);
			k_fullscreen = _screen_mode;

			if (!window_get_fullscreen()) {
				window_set_size(k_disp_w, k_disp_h);
				if (_center_window) {window_center();}
			}
		}
		global.k_auto_fullscreen = function ()												{
			window_set_fullscreen(!window_get_fullscreen());
			k_fullscreen = window_get_fullscreen();

			if (!window_get_fullscreen()) {
				window_set_size(k_disp_w, k_disp_h);
				if (!window_get_fullscreen()) {window_center();}
			}
		}
		global.k_screenshake	 = function (_magnitude, _length)							{
			if (_magnitude > shake_Remain) {
				shake_Magnitude = _magnitude;
				shake_Remain	= _magnitude;
				shake_Length	= _length;
			}
		}

		// (Summon) So "ZOOM" And "FULLSCREEN" Variable definition options be applied at the start
		global.k_set_zoom();
		global.k_set_fullscreen(k_fullscreen, true);
	#endregion

	// State (Bank)
	machine.AddState("wait_mode",			wait_mode);
	machine.AddState("follow_target",		follow_target);
	machine.AddState("follow_mouse",		follow_mouse);
	machine.AddState("peak_follow_target",	peak_follow_target);
	machine.AddState("pan_follow_target",	pan_follow_target);
	machine.AddState("drag_follow_mouse",	drag_follow_mouse);
	machine.AddState("border_follow_mouse",	border_follow_mouse);
	machine.AddState("move_to_click",		move_to_click);
	machine.AddState("move_to_target",		move_to_target);
	machine.AddState("celeste_mode",		celeste_mode);

	machine.SetCurrent(k_mode, kTransition._kNo_sprite); // (Start) The event
}
machine.BeforeStep		 = function() {
	visible = k_debug;	// (Debug) Draw Stuff (On & Off)

	// (Debug) Setting
	if (k_debug) {
		k_zoom += (mouse_wheel_up() - mouse_wheel_down())*0.1;
		if (mouse_wheel_up() || mouse_wheel_down()) {global.k_set_zoom(k_zoom);}

		// Debug (Angle)
		//k_zoom += (mouse_wheel_down() - mouse_wheel_up())*5;
		//if (mouse_wheel_up() || mouse_wheel_down())
		//	{global.k_set_angle(k_angle);}	
	}

	// (FreeRoam)
	if (!k_free) {
		var _zoom = k_zoom;	if (k_debug) {_zoom = 1;}
		camera_set_view_pos(kamera, clamp(camera_get_view_x(kamera), 0, (room_width - camera_get_view_width(kamera))), clamp(camera_get_view_y(kamera), 0, (room_height - camera_get_view_height(kamera))));
	}

	// (ScreenShake)
	if (shake_Remain > 0) {
		camera_set_view_pos(kamera, camera_get_view_x(kamera) + random_range(-shake_Remain, shake_Remain), camera_get_view_y(kamera) + random_range(-shake_Remain, shake_Remain));
		shake_Remain = max(0, shake_Remain - ((1 / shake_Length) * shake_Magnitude));
	}

	// When decided target object was (Lost) But it still exists inside the room
	if (target_lost && instance_exists(k_target)) {
		show_debug_message("-Target is no longer lost! Reverting back to previous '" + string (machine.GetPrevious()) + "' event");

		global.k_set_mode(machine.GetPrevious());
		target_lost = false;
	}

	if (keyboard_check_pressed(fullscreen_shortcut)) {global.k_auto_fullscreen();}	// (Fullscreen) || Can change the shortcut key in Initialize();
	if (keyboard_check_pressed(debug_shortcut))		 {k_debug = !k_debug;}			// (Debug)		|| Can change the shortcut key in Initialize();
}

wait_mode.Start			 = function() {
	show_debug_message("-" + string_upper(k_mode) + " is working! No target will be followed");
}
pan_follow_target.Start  = function() {
	dest_x = camera_get_view_x(kamera);
	dest_y = camera_get_view_y(kamera);

	mouse_x_pre = display_mouse_get_x();
	mouse_y_pre = display_mouse_get_y();
}
drag_follow_mouse.Start  = function() {
	dest_x = camera_get_view_x(kamera);
	dest_y = camera_get_view_y(kamera);

	mouse_x_pre = mouse_x;
	mouse_y_pre = mouse_y;
}
celeste_mode.Start		 = function() {
	lock_x = 0;
	lock_y = 0;

	bound_object = o_bound; // Pick the Bound Object
}

follow_target.Step		 = function() {
	if (instance_exists(k_target))	{
		var _dest_x = lerp(camera_get_view_x(kamera), round((k_target.x + k_offset_x) - camera_get_view_width(kamera)/2),  k_spd);
		var _dest_y = lerp(camera_get_view_y(kamera), round((k_target.y + k_offset_y) - camera_get_view_height(kamera)/2), k_spd);

		camera_set_view_pos(kamera, _dest_x, _dest_y);
	}
	else							{
		show_debug_message("-" + string_upper(k_mode) + " couldn't find the target object so reverting back to Wait Mode");

		global.k_set_mode("wait_mode");
		target_lost = true;
	}
}
follow_mouse.Step		 = function() {
	var _dest_x = lerp(camera_get_view_x(kamera), round(mouse_x - camera_get_view_width(kamera)/2),  k_spd/10);
	var _dest_y = lerp(camera_get_view_y(kamera), round(mouse_y - camera_get_view_height(kamera)/2), k_spd/10);

	camera_set_view_pos(kamera, _dest_x, _dest_y);
}
peak_follow_target.Step	 = function() {
	if (instance_exists(k_target))	{
		var _dest_x = lerp(k_target.x, round(device_mouse_x(0) + k_offset_x), k_spd) - camera_get_view_width(kamera)/2;
		var _dest_y = lerp(k_target.y, round(device_mouse_y(0) + k_offset_y), k_spd) - camera_get_view_height(kamera)/2;

		camera_set_view_pos(kamera, _dest_x, _dest_y);
	}
	else							{
		show_debug_message("-" + string_upper(k_mode) + " couldn't find the target object so reverting back to Wait Mode");
		global.k_set_mode("wait_mode");
		target_lost = true;
	}
}
pan_follow_target.Step	 = function() {
	if (instance_exists(k_target))	{
		if (mouse_check_button(mb_left)) {
			dest_x = camera_get_view_x(kamera);
			dest_y = camera_get_view_y(kamera);

			var _mouse_x = display_mouse_get_x() - mouse_x_pre;
			var _mouse_y = display_mouse_get_y() - mouse_y_pre;

			dest_x -= _mouse_x;	// You can add restrictions here
			dest_y -= _mouse_y;	// You can add restrictions here
		}
		else {
			dest_x = lerp(camera_get_view_x(kamera), round((k_target.x + k_offset_x) -  camera_get_view_width(kamera)/2), k_spd);
			dest_y = lerp(camera_get_view_y(kamera), round((k_target.y + k_offset_y) - camera_get_view_height(kamera)/2), k_spd);
		}

		camera_set_view_pos(kamera, dest_x, dest_y);

		mouse_x_pre = display_mouse_get_x();
		mouse_y_pre = display_mouse_get_y();
	}
	else							{
		show_debug_message("-" + string_upper(k_mode) + " couldn't find the target object so reverting back to Wait Mode");
		global.k_set_mode("wait_mode");
		target_lost = true;
	}
}
drag_follow_mouse.Step	 = function() {
	if		(mouse_check_button(mb_left))			{
		dest_x += (mouse_x_pre - mouse_x)*k_spd;
		dest_y += (mouse_y_pre - mouse_y)*k_spd;

		camera_set_view_pos(kamera, dest_x, dest_y);
	}
	else if (mouse_check_button_released(mb_left))	{
		camera_set_view_pos(kamera, round(camera_get_view_x(kamera)), round(camera_get_view_y(kamera)));
	}

	mouse_x_pre = mouse_x;
	mouse_y_pre = mouse_y;
}
border_follow_mouse.Step = function() {
	if (!point_in_rectangle(mouse_x, mouse_y, camera_get_view_x(kamera) + camera_get_view_width(kamera)*0.01, camera_get_view_y(kamera) + camera_get_view_height(kamera)*0.01, camera_get_view_x(kamera) + camera_get_view_width(kamera)*0.99, camera_get_view_y(kamera) + camera_get_view_height(kamera)*0.99)) {
		var _dest_x = lerp(camera_get_view_x(kamera), mouse_x -  camera_get_view_width(kamera)/2, k_spd/10);
		var _dest_y = lerp(camera_get_view_y(kamera), mouse_y - camera_get_view_height(kamera)/2, k_spd/10);

		camera_set_view_pos(kamera, _dest_x, _dest_y);
	}
}
move_to_click.Step		 = function() {
	if (mouse_check_button_pressed(mb_left))
		{camera_set_view_pos(kamera, mouse_x - camera_get_view_width(kamera)/2, mouse_y - camera_get_view_height(kamera)/2);}
}
move_to_target.Step		 = function() {
	if (instance_exists(k_target))	{
		var _dest_x = lerp(camera_get_view_x(kamera), k_target.x - camera_get_view_width(kamera)/2, k_spd/10);
		var _dest_y = lerp(camera_get_view_y(kamera), k_target.y - camera_get_view_height(kamera)/2, k_spd/10);

		camera_set_view_pos(kamera, _dest_x, _dest_y);

		if (point_distance(camera_get_view_x(kamera), camera_get_view_y(kamera), k_target.x - camera_get_view_width(kamera)/2, k_target.y - camera_get_view_height(kamera)/2) <= 1)
			{machine.SetCurrent("follow_target", kTransition._kNo_sprite);}
	}
	else							{
		show_debug_message("-" + string_upper(k_mode) + " couldn't find the target object so reverting back to Wait Mode");
		global.k_set_mode("wait_mode");
		target_lost = true;
	}
}
celeste_mode.Step		 = function() {
	var spd = 0;
	if (!is_undefined(k_target) && instance_exists(k_target)) {
		var CollidedBound  = instance_position(k_target.x, k_target.y, bound_object);
		if (CollidedBound != noone) {
			spd	   = k_spd/10;
			lock_x = clamp(lock_x, CollidedBound.bbox_left +  camera_get_view_width(kamera)/2, CollidedBound.bbox_right  - camera_get_view_width(kamera)/2);
			lock_y = clamp(lock_y, CollidedBound.bbox_top  + camera_get_view_height(kamera)/2, CollidedBound.bbox_bottom - camera_get_view_height(kamera)/2);
		}
		else {
			spd	   = k_spd;
			lock_x = k_target.x;
			lock_y = k_target.y;
		}

		var _dest_x = lerp(camera_get_view_x(kamera), (lock_x + k_offset_x) -  camera_get_view_width(kamera)/2, spd);
		var _dest_y = lerp(camera_get_view_y(kamera), (lock_y + k_offset_y) - camera_get_view_height(kamera)/2, spd);

		camera_set_view_pos(kamera, _dest_x, _dest_y);
	}
	else													  {
		show_debug_message("-" + string_upper(k_mode) + " couldn't find the target object so reverting back to Wait Mode");
		global.k_set_mode("wait_mode");
		target_lost = true;
	}
}

machine.Initialize(); // (Start) The machine

if(IS_DEBUG) room_goto(rm_debug);
else room_goto(rm_MainMenu);