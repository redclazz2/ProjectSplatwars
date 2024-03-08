/// @description pause( milliseconds );
///@param milliseconds
function pause(argument0) {

	// Pause game for a set amount of time 


	///	------------|				EXAMPLE				 |-------------- ///
	/*
		if ( keyboard_check_pressed( vk_space )) pause( 150 );
	
		////////////////////////////////////////////////////
		Game pauses for 150 mil seconds
	
	*/


	var time = current_time , ms = argument0;
	do { } until( ( current_time - time ) >= round( ms ) ) {};
	return ( current_time - time );


}
