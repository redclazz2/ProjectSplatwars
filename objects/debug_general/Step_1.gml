
#region Debug
///////////////////////////////////////
///---		Tweens & Timers		---///
/////////////////////////////////////
global.sine_val	= Tween_Sine( 0, 1, sine_timer );
sine_timer	+= 4; //the rate at which the sine wave oscillates 
global.cos_val = Tween_Cos( 0,1, cos_timer );
cos_timer += 4;

global.debug_lerp_alpha = lerp( global.debug_lerp_alpha, debug_alpha_set, 0.2 ); //used for alpha lerping

NumericSpring_Step( 0, global.TIME );
global.debug_spring_val = NumericSpring_Get_Val( 0 ) //used for position offsetting 
#endregion

#region Time Dialation
global.TIME = lerp( global.TIME, global.TIME_SET, 0.07 );
gameTimer += global.TIME;

#endregion
