/// @description Tween_Sine( min, max, position );
/// @param min
/// @param max
/// @param position
function Tween_Sine() {

	///	-----------------EXAMPLE-------------------///
	/*
		// Step
		timer+= 2;
		value = Tween_Sine( -10,10, timer );
	
		////////////////////////////////////////////
		'Value' oscillates between -10 and 10.
		Increase the timer increments ( timer+= 5) to increase oscillation speed.
	*/

	return((argument[1]-argument[0])/2 * dsin(argument[2]) + (argument[1]+argument[0])/2);


}
