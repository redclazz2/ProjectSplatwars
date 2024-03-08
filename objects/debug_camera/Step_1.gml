
if ( instance_exists( cam ))
with( cam ){
#region Buttons (wip)

////////////////////////////////////////////////////////
///---		Set Hover, Reset other Buttons		---	///
//////////////////////////////////////////////////////
if ( global.DEBUG ){
var wx	= window_mouse_get_x();
var wy	= window_mouse_get_y();
bhover	= -1;


for( var i=0; i< bc; i++; ){ //Loop through all buttons
	var BB;
	BB[0]	= bx[ i ];
	BB[1]	= by[ i ];
	BB[2]	= bx[ i ]+ bw[ i ];
	BB[3]	= by[ i ]+ bh[ i ];
	
	if ( point_in_rectangle( wx, wy, BB[0],BB[1],BB[2],BB[3] )){
		bhover = i;
	} else if ( bbool[ i ] ){ //'active' buttons
		btween[ i ]		= Tween_Smooth( btween[ i ],	1, 3 );
		bxoff[ i ]		= Tween_Smooth( bxoff[ i ],		0, 3 );
		byoff[ i ]		= Tween_Smooth( byoff[ i ],		-15, 2 );
		balpha[ i ]		= Tween_Smooth( balpha[ i ],	0.1,5 );
		bscale[ i ]		= lerp( bscale[ i ],			3, 0.2 );
	} else { // reset values that are changed when hovered/selected
		btween[ i ]		= Approach( btween[ i ],		0,0.05 );
		bxoff[ i ]		= Tween_Smooth( bxoff[ i ],		0, 3 );
		byoff[ i ]		= Tween_Smooth( byoff[ i ],		0, 3 );
		balpha[ i ]		= Tween_Smooth( balpha[ i ],	0.05,5 );
		bscale[ i ]		= lerp( bscale[ i ],			2, 0.2 );
	}
}

////////////////////////////////////////
///---		Select Button		---	///
//////////////////////////////////////
if ( mouse_check_button_pressed( mb_left )){
	if ( bhover != -1 ){
		bbool[ bhover ]		= !bbool[ bhover ];
		btween[ bhover]		= 0;
		byoff[ bhover ]		= 0;
		
		if ( bbool[ bhover ] ){		// Locked the button! 
			locked		= true;
			locked_x	= window_mouse_get_x();
			locked_y	= window_mouse_get_y();
		}
		
	}
}


////////////////////////////////
///---		Hover		---	///
//////////////////////////////
// Adjust the hovered button's values here
if ( bhover != -1 && !bbool[ bhover ] ){
	window_set_cursor( cr_drag ); // drag cursor sprite
	btween[ bhover ]	= Tween_Smooth( btween[ bhover ], 1, 3 );
	bxoff[ bhover ]		= Tween_Smooth( bxoff[ bhover ], 0, 3 );
	byoff[ bhover ]		= Tween_Smooth( byoff[ bhover ], -15, 2 );
	balpha[ bhover ]	= Tween_Smooth( balpha[ bhover ], 1 ,5 );
	bscale[ bhover ]	= lerp( bscale[ bhover ], 3, 0.2 );
	
	// Change hovered button value
	var var_scroll	= 0;
	if ( mouse_wheel_down() ){
		var_scroll	= 1;
	} else if ( mouse_wheel_up() ){
		var_scroll	= -1;
	}
	
	if ( var_scroll != 0 ){ //scrolled
		switch( bhover ){
			case 0://Shake
				MODE[ SHAKE ]	= Approach_Loop( MODE[ SHAKE ], array_length_1d( shake_string )-1, var_scroll );
			cam_shake( MODE[ SHAKE ], 20, 4, 0 ); 
		
			break;
			case 1://Follow
				MODE[ FOLLOW ]	= Approach_Loop( MODE[ FOLLOW ], array_length_1d( follow_string )-1, var_scroll );
			break;
			case 2://Angle
				var_scroll *= 5;
				set_a		= (  (set_a+ ( var_scroll )>360) ? 0 : set_a+( var_scroll ) ); //Angle values go to negatives. Not perfect but gets the job done
			break;
		}
	}
	
	// An extra variable to control the alpha of the Black backdrop + Shake/Follow states
	hover_tween_set	= 1;
} else {
	window_set_cursor( cr_default );// reset cursor sprite
	hover_tween_set	= 0;
}

hover_tween_value	= Approach( hover_tween_value, hover_tween_set, 0.033 );



///////////////////////////////
///---		LOCKED		---///
/////////////////////////////
if ( locked ){
	if ( locked_timer < room_speed ){
		locked_timer++;
		locked_yoff	= Tween_Weighted( locked_yoff, room_speed, 3 );
	} else {
		locked_yoff		= 0;
		locked_timer	= 0;
		locked			= false;
	}
}




#region Old 

/*
////////////////////////////////////////
///---		Select Button		---	///
//////////////////////////////////////
if ( mouse_check_button_pressed( mb_left )){
	if ( bhover != -1 ){
		if ( bselect == bhover )
			bselect = -1; //deselect
		else
			bselect	= bhover; //select hovered button
	} else {
//		bselect = -1; //deselect 
	}
}

////////////////////////////////
///---		Select		---	///
//////////////////////////////
// Determine the outcome of 'pressing/selecting' a button
if ( bselect != -1 ){
	// Apply to selected buttons
	switch( bselect ){
		case 0://Shake
		MODE[ SHAKE ]	= Approach_Loop( MODE[ SHAKE ], array_length_1d( shake_string )-1, 1 );
		cam_shake( MODE[ SHAKE ], 24, 4, 0 ); 
		
		break;
		case 1://Follow
		MODE[ FOLLOW ]	= Approach_Loop( MODE[ FOLLOW ], array_length_1d( follow_string )-1, 1 );
		break;
	}
	
	// Apply to any button
	bbool[ bselect ]	= !bbool[ bselect ]; //toggle on/off
	byoff[ bselect ]	= 20;
	bscale[ bselect ]	*= 0.75;
	balpha[ bselect ]	= 0.8;
	btween[ bselect ]	= 0;
	bselect = -1;
}


////////////////////////////////
///---		Hover		---	///
//////////////////////////////
// Adjust the hovered button's values here
if ( bhover != -1 ){
	window_set_cursor( cr_drag ); // drag cursor sprite
	btween[ bhover ]	= Tween_Smooth( btween[ bhover ], 1, 3 );
	bxoff[ bhover ]		= Tween_Smooth( bxoff[ bhover ], 0, 3 );
	byoff[ bhover ]		= Tween_Smooth( byoff[ bhover ], -15, 2 );
	balpha[ bhover ]	= Tween_Smooth( balpha[ bhover ],1 ,5 );
	bscale[ bhover ]	= lerp( bscale[ bhover ], 3, 0.2 );
} else {
	window_set_cursor( cr_default );// reset cursor sprite
}
*/
#endregion

}

#endregion
}
