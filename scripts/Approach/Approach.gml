/// @description  Approach(start, end, shift);
/// @param start
/// @param  end
/// @param  shift
function Approach(argument0, argument1, argument2) {

	///	-----------------EXAMPLE-------------------///
	/*
		// Step
		if ( keyboard_check( vk_right )){
			spd = Approach( spd, 5, 0.5 );
		} else if ( keyboard_check( vk_left )){
			spd = Approach( spd, -5, 0.5 );
		} else {
			spd = Approach( spd, 0, 1 );
		}
	
		//////////////////////////////////////////
		Pressing the Left or Right key will set your speed to 5 at the rate of 0.5 per step.
		If not, spd will be reset back to 0 at the rate of 1 per step.
	
	*/

	if (argument0 < argument1)
	    return min(argument0 + argument2, argument1); 
	else
	    return max(argument0 - argument2, argument1);


}
