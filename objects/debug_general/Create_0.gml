/// @description Used to display debugging info 

#region		 Debugging 
// Used for text tweening effects. The values range from 0 to 1.
global.DEBUG				= true;
global.debug_lerp_alpha		= 0;	
global.sine_val	= 0;
global.cos_val	= 0;
global.debug_spring_val		= 0; 
gameTimer		= 0;

///		Set Values		///
//global.sine_val	= 0; // A value 0-1 reused as a tweening variable
sine_timer			= 0;
cos_timer			= 0;
debug_alpha_set		= 1;
NumericSpring_Create( 0, 0,0, debug_alpha_set, 0.2, 6, 1.0 ); 

room_string = ""; //displays current room

#endregion