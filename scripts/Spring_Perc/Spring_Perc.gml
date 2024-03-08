/// @description Spring_Perc( num );
/// @param num
function Spring_Perc(argument0) {

	// Returns a percentage of the value & its target value.
	// Great for scale tweening when multiplied.

	///	-----------------EXAMPLE-------------------///
	/*
		// Create
		Spring_Create( 0, 10, 10, 0.05, 0.05 );
	
		//Step
		Spring_Step( 0 );
		scale = 1* Spring_Perc( 0 );
	
		if ( 
		////////////////////////////////////////////
		Sets the scale to Spring 0's percentage relative to its target value ( set inside the create event );
	*/

	return sval[ argument0 ]/sset[ argument0 ];


}
