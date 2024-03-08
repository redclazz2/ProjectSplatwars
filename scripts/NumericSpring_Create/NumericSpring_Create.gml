/// @description NumericSpring_Create( num, val, vel, set, damp, freq, time );
/// @param n
/// @param val
/// @param vel
/// @param set
/// @param damp
/// @param freq
/// @param time
function NumericSpring_Create() {

	///	-----------------EXAMPLE-------------------///
	/*
		NumericSpringCreate( 0, 0, 0, 100, 0.15, 3, 1 );
	
		//////////////////////////////////////////////
		Initializes the arrays necessary for Numeric Springing
	*/

	var n = 0;
	var i = argument[ n ]; n++;
	nval[ i ]	= argument[ n ]; n++;
	nvel[ i ]	= argument[ n ]; n++;
	nset[ i ]	= argument[ n ]; n++;
	ndamp[ i ]	= argument[ n ]; n++;
	nfreq[ i ]	= argument[ n ]; n++;
	ntime[ i ]	= argument[ n ];



}
