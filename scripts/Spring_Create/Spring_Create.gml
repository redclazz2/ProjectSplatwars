/// @description Spring_Create( num, set, val, ten, damp );
/// @param num
/// @param set
/// @param val
/// @param ten
/// @param damp
function Spring_Create() {

	// Don't set speed or time- they're set elsewhere


	///	-----------------EXAMPLE-------------------///
	/*
		// Create
		Spring_Create( 0, 10, 10, 0.05, 0.05 );
	
	*/

	var n	= 0;
	var i = argument[ n ]; n++;
	sset[ i ]	= argument[ n ]; n++;
	sval[ i ]	= argument[ n ]; n++;
	sten[ i ]	= argument[ n ]; n++;
	sdamp[ i ]	= argument[ n ]; 
	sspd[ i ]	= 0;



}
