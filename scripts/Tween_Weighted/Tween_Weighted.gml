/// @description Tween_Weighted( value, set, slowFactor );
/// @param val
/// @param set
/// @param slo
function Tween_Weighted(argument0, argument1, argument2) {

	// Higher the slowFactor, the slower v approaches s

	///	-----------------EXAMPLE-------------------///
	/*
		// Step
		value = Tween_Weighted( value, 10, 2 );
	
		////////////////////////////////////
		Value approaches 10 with a slow-factor of 2 (quite fast).
	*/

	var v       = argument0;
	var set       = argument1;
	var N       = argument2;

	v = ((v * (N - 1)) + set) / N;

	return v;



}
