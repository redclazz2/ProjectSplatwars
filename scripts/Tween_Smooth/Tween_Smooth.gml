/// @descripton Tween_Smooth( value, set, slow );
/// @param val
/// @param set
/// @param slo
function Tween_Smooth(argument0, argument1, argument2) {

	// Higher the slowFactor, the slower V approaches W

	///	-----------------EXAMPLE-------------------///
	/*
		value = Tween_Smooth( value, 5, 3 );
	
		////////////////////////////////////
		Tweens 'value' to 5.
	*/


	var v       = argument0;
	var set     = argument1;
	var N       = argument2;

	var A       = v;
	var B       = set;

	for (var i = 0; i < N; i++)
	{
	  v = i / N;
	  v = ((v) * (v) * (3 - 2 * (v))); 

	var X = (A * v) + (B * (1 - v));
	} 

	return X;





}
