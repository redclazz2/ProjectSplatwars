
if ( instance_exists( cam ))
with( cam ){
#region Debug Controls 
if ( global.DEBUG ){
centershift		= false;
copy			= false;
var wx			= window_mouse_get_x();
var wy			= window_mouse_get_y();

NumericSpring_Step( 1, 1 ); // for the overlay xoffset ( springing effect )

/*
//////////////////////
///--	Flash	--///
////////////////////
//-- Determine the color, alpha and duration of the flash	--//
//-- 'damp_dur' is how long it takes for the flash to dissipate back to 0 --//
if ( mouse_check_button( mb_left )){
	cam_flash( c_white, 0.8, 1, 10 );
} 

//////////////////////////
///--	Black Bars	--///
////////////////////////
if ( mouse_check_button_pressed( mb_right )){
	cam_bars_toggle();
}
*/

///////////////////////////////
///---		Shake		---///
/////////////////////////////
//--	Shake intensity is based on the mouse's distance from the center of the window	--// (further = larger shake)
//--	Shake angle is relative to the center point's direction to your mouse	--//
if ( mouse_check_button_pressed( mb_right ) || keyboard_check_pressed( vk_tab )){
	var centerx	= global.WINDOW_W/2; //can change it to cx & cy as a reference point!
	var centery	= global.WINDOW_H/2;
	var mdir	= point_direction( centerx, centery, wx,wy );
	var mdist	= point_distance(  centerx, centery, wx,wy )/centerx;
	cam_shake( MODE[ SHAKE ], 64* mdist, 4, mdir );
}


///////////////////////////////////////
///---		Center Offset		---///
/////////////////////////////////////
//--	Determine the center point of the Camera	--//
if ( keyboard_check( vk_shift) ){
	cx	= wx;
	cy	= wy;
	cu	= (wx/window_get_width());
	cv	= (wy/window_get_height());
	centershift	= true;
}


///////////////////////////////
///---		Zoom		---///
/////////////////////////////
//--	Zoom In/Out using the mouse wheel & when the mouse is not hovered over any button	--//
if ( bhover == -1 )		//mouse is not hovering over debug buttons
if ( mouse_wheel_up() ){
	set_z = Approach( set_z, z_min, 0.05 );
} else if ( mouse_wheel_down() ){
	set_z = Approach( set_z, z_max, 0.05 );
}


///////////////////////////////
///---		Angle		---///
/////////////////////////////
//-- Change the Cam Angle using the mouse wheel while your mouse is hovered over the mini-map --//
//-- INSIDE 'BEGIN-STEP'

///////////////////////////////////////////////////////////////////
///---		Copy Shake and Follow scripts to clipboard		---///
/////////////////////////////////////////////////////////////////
if ( keyboard_check_pressed( ord("C")) || mouse_check_button_pressed(mb_right) ){
	copy	= true;
	copyalpha = 1;
} else {
	copyalpha = lerp( copyalpha, 0, 0.1 );
}

if ( copy ){
	// Convert data into string values.
	var str_shake = "cam_shake( "+string(MODE[SHAKE])+", "+string(shake_amount)+", "+string(shake_dur)+", "+string(shake_dir)+" );";
	var str_shake_ext = "cam_shake( "+string(MODE[SHAKE])+", "+string(shake_amount)+", "+string(shake_dur)+", "+string(shake_dir)+ ", "+string( shake_damp_time )+" );";
	var str_follow  = "cam_follow( "+string(MODE[FOLLOW])+", "+string(target)+" );";
	var str_zoom   = "cam_zoom( "+string( set_z )+" );";
	var str_coord	= "cam_coord( "+string( cu )+", "+string( cv )+" );";
	var str_ang		= "cam_angle( "+string( shakea )+" );";
	
	// Copy to clipboard
	clipboard_set_text( 
str_follow+ @"
" +str_shake+ @"
" +str_shake_ext+ @"
" +str_zoom+ @"
"+ str_coord+ @"
"+ str_ang
	);

}

///---		Display copy data in Follow Button hover text	---///
	// Convert data into string values.
	var str_shake = "cam_shake( "+string(MODE[SHAKE])+", "+string(shake_amount)+", "+string(shake_dur)+", "+string(shake_dir)+" );";
	var str_shake_ext = "cam_shake( "+string(MODE[SHAKE])+", "+string(shake_amount)+", "+string(shake_dur)+", "+string(shake_dir)+ ", "+string( shake_damp_time )+" );";
	var str_follow  = "cam_follow( "+string(MODE[FOLLOW])+", "+string(target)+" );";
	var str_zoom   = "cam_zoom( "+string( set_z )+" );";
	var str_coord	= "cam_coord( "+string( cu )+", "+string( cv )+" );";
	var str_ang		= "cam_angle( "+string( set_a )+"  ); ";
	
	// Copy to clipboard
	var str_clipboard = ( 
str_follow+ @"
" +str_shake+ @"
" +str_shake_ext+ @"
" +str_zoom+ @"
"+ str_coord+ @"
"+ str_ang
	);

shake_desc[ 0 ]		= str_clipboard;
	

} //end debug
#endregion
}

