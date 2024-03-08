/// @description Target Position

///--	Displays the target x and y positions to help visualize how it moves based on the follow mode  --//
#region hello to the cool person reading this 
if ( global.DEBUG ){
	if ( instance_exists( cam ))
	with( cam ){
		draw_set_color( c_red );
		draw_circle( tx,ty, 16, true );
		draw_set_color( c_white );
	}
}
#endregion