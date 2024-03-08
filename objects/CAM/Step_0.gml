/// @description Camera Logic


#region Temp Variables
//Temp CU & CV values
if( c_timer>-1){
	c_timer--;
}else{
	if(c_temp){
	c_temp = false;
	cu = cu_old;
	cv = cv_old;
	}
}

//Temp In-Room
if( inroom_timer>-1){
	inroom_timer--;
}else{
	if(inroom_temp){
	inroom_temp = false;
	inroom = inroom_old;
	}
}

//Temp Zoom
if( zoom_timer>-1){
	zoom_timer--;
}else{
	if(zoom_temp){
	set_z  = zoom_old;
	zoom_temp=false;
	}
}



//Temp Follow
if(follow_timer>-1){
	follow_timer--;	
}else{
	if(follow_temp){
	follow_temp = false;
	MODE[ FOLLOW ] = follow_old;
	target			= target_old;
	}
}

#endregion


#region  Declare Variables
var mx			= mouse_x;
var my			= mouse_y;
var wx			= window_mouse_get_x();
var wy			= window_mouse_get_y();

var var_x		= view_x;
var var_y		= view_y;
var var_w		= view_w;
var var_h		= view_h;
var var_z		= view_z;
var var_a		= view_a;
var var_time	= global.TIME;

var var_x_set	= set_x;
var var_y_set	= set_y;
//var var_w_set	= set_w; //you dont need this bc View sizing stays constant ( unless you change it )
//var var_h_set	= set_h;
var var_z_set	= set_z;
var var_a_set	= set_a;
#endregion


///////////////////////////////
///---		Path		---///
/////////////////////////////
#region Path
if( isPath ){
	tx = x;
	ty = y;
	view_xoff = Tween_Smooth(view_xoff,set_xoff,3);
	view_yoff = Tween_Smooth(view_yoff,set_yoff,3);
	
	//////////////////////
	//---Path Speed---///
	////////////////////
	/*
	if( path_position >= 0.85 ){ path_speed = Approach(path_speed,1.,0.033 ); }
	else if ( path_position < 0.4 ){ path_speed = Approach( path_speed, 2.5, 0.033 ); }
	else { path_speed = Approach( path_speed, 5, 0.066 ); }
	
	if(keyboard_check_pressed(vk_space)){
		path_position = 1;
		//path_end();
	}*/
#endregion
} else { //Ignore Follow & Shake states 

#region Follow 
///--		Follow  the specified target object			--///
switch( MODE[ FOLLOW ] ){
	
	///////////////////////////////
	///---		Target		---///		General
	/////////////////////////////	Camera follows target object
	case follow.target: 
	if ( instance_exists( target )){
		tx		= target.x;
		ty		= target.y;
	}
	break;
	
	/////////////////////////////////////// 
	///---		Target BoundBox		---///			PLATFORMER
	/////////////////////////////////////  Target stays within the boundary box 
	case follow.bbox:
		var temp_target_x;
		var temp_target_y;
		if ( instance_exists( target )){
			temp_target_x	= target.x;
			temp_target_y	= target.y;
		} else {
			temp_target_x	= tx;
			temp_target_y	= ty;
		}
		
		var BBOX;
		var bx		= ( temp_target_x );
		var by		= ( temp_target_y );
		//var perc_w	= 0.1;
		//var perc_h	= 0.1;
		var off_left	= ( var_w * bbox_w[0] );
		var off_top		= ( var_h * bbox_h[0] );
		var off_right	= ( var_w * bbox_w[1] );
		var off_bottom	= ( var_h * bbox_h[1] );
		BBOX[0]	= var_x_set + ( off_left ); 
		BBOX[1]	= var_y_set + ( off_top );
		BBOX[2]	= var_x_set	+ ( var_w- off_right );
		BBOX[3]	= var_y_set	+ ( var_h- off_bottom );
		
		// Move camera when it's outside the collision box
		if ( !point_in_rectangle( bx,by, BBOX[0],BBOX[1],BBOX[2],BBOX[3] )){
			prevx	= clamp( temp_target_x, BBOX[0],BBOX[2] );
			prevy	= clamp( temp_target_y, BBOX[1], BBOX[3] );
			tx	+= (temp_target_x- prevx);
			ty	+= (temp_target_y- prevy);

		} else {
			prevx	= clamp( temp_target_x, BBOX[0],BBOX[2] );
			prevy	= clamp( temp_target_y, BBOX[1], BBOX[3] );
		}
		
		// Edit boundbox coords ( left, top, right, bottom )
		// ** update in later version **
		
	break;
	
	///////////////////////////////////////
	///---		Target + Mouse		---///		TOP-DOWN
	///////////////////////////////////// Camera is offset by the distance between the cursor and target
	case follow.mpeek: 
	if ( instance_exists( target )){
		tx		= target.x - ( (target.x- mouse_x)/5 );
		ty		= target.y - ( (target.y- mouse_y)/5 );
	}
	break;
	
	#region 3. Free Mouse Old
	/*
	///////////////////////////////////
	///---		Free Mouse		---///		RTS
	/////////////////////////////////
	// Move mouse around to move camera
	// Check if mouse is outside the boundbox
	
	case follow.mfree: //Free Mouse
		
		if ( 1 ){ //not hovering over button
		var BOX, PERC, WGAP, HGAP;
		PERC	= bbox_perc;
		WGAP	= global.WINDOW_W* PERC;
		HGAP	= global.WINDOW_H* PERC;
		BOX[0]	= WGAP;
		BOX[1]	= HGAP;
		BOX[2]	= global.WINDOW_W- WGAP;
		BOX[3]	= global.WINDOW_H- HGAP;
		
		if ( !point_in_rectangle( wx,wy, BOX[0],BOX[1],BOX[2],BOX[3] )){
			spd = Approach( spd, 6, 0.33 );
			dir	= point_direction( cx,cy, wx,wy );
		} else {
			spd = Approach( spd, 0, 0.5 ); //fric
		}
			tx += lengthdir_x( spd, dir );
			ty += lengthdir_y( spd, dir );
			tx = clamp( tx, 0, room_width );
			ty = clamp( ty, 0, room_height );
		}
		
	
	break;
	*/
	#endregion
	
	///////////////////////////////////
	///---		Drag Mouse		---///
	/////////////////////////////////
	case follow.mdrag:
		if ( mouse_check_button_pressed( mb_left )){
			prevx	= tx;
			prevy	= ty;
			prevmx	= wx;
			prevmy	= wy;
		} else if ( mouse_check_button( mb_left )){
			tx	= prevx- ( wx- prevmx );
			ty	= prevy- ( wy- prevmy );
			window_set_cursor( cr_drag );
		} 
	break;
	
	///////////////////////////////////
	///---		Super Smash		---///
	/////////////////////////////////
	case follow.supersmash:
		//If target<second, cu = 0.1..?
		//get an interpolated cu to average between the player & second
			var _target_secondx = target_second != noone ? target_second.x : 0;
			var temp_cu		= 0.5 + (( min(var_w, (target.x-_target_secondx)) /var_w)/2) //+( ( min(var_w, max(var_w*0.1,(abs(target.x- target_second.x))))/var_w) /2)
			temp_cu			= clamp(temp_cu,0.2,0.8);
			tx				= target.x;
			ty				= target.y;
			cu				= Tween_Smooth(cu,temp_cu,7);
			
			
			if( _target_secondx > (tx+ (view_w))){ 
				
			}
			
		set_z = 2
		//Notes.
		//Add more targets using arrays. Average based off the array size, and all the target coords.
		
	break;
	


}



#endregion

#region Shake
var vRand		= choose( 0,1 );
var var_shake	= shake_amount;
var var_shake_dir = shake_dir;
var var_shakex	= shakex;
var var_shakey	= shakey

switch( MODE[ SHAKE ] ){
	case shake.jitter:
		///////////////////////////////
		///---		Jitter		---///
		/////////////////////////////
		// Your typical chaotic screenshake!
		// Direction does not matter
		if ( vRand ){
			var_shakex	= ( var_shake )* choose( -1, 1 );
			var_shakey	*= ( -0.33 );
		} else {
			var_shakex	*= ( -0.33 );
			var_shakey	= ( var_shake )* choose( -1, 1 );
		}
	
	break;
	
	case shake.numeric: 
		///////////////////////////////////////
		///---		Numeric Spring		---///
		/////////////////////////////////////
		// Went for the hard landing feel (landing after traveling really fast).
		NumericSpring_Step( 0, global.TIME );
		var_shake	= NumericSpring_Get_Val( 0 );

	break;
	
	
	case shake.bounce:
		///////////////////////////////
		///---		Bounce		---///
		/////////////////////////////
		// Went for that 'post-explosion' feel
		Spring_Step( 0 );
		var_shake	= Spring_Get_Val( 0 );
	break;
	
}

///////////////////////////////////
///---		Apply Shake		---///
/////////////////////////////////
if ( shake_dir == -1 ) var_shake_dir = irandom(360);

if ( MODE[ SHAKE ] != 0 ){
var_shakex	= lengthdir_x( var_shake, var_shake_dir );
var_shakey	= lengthdir_y( var_shake, var_shake_dir );
}

shakex		= var_shakex;
shakey		= var_shakey;

///////////////////////////////////
///---		Reset Shake		---///
/////////////////////////////////
if ( shake_dur > 0 ){
	shake_dur--;
} else {
	shake_amount = Approach( shake_amount, 0, shake_damp );
}
		

#endregion

#region Flash
///////////////////////////////////
///--		Flash Logic		---///
/////////////////////////////////
if ( flash_timer > 0 ){
	flash_timer--;
} else {
	// Choose easing type
	switch( flash_state ){
		case 0:
			flash_alpha = Approach( flash_alpha, 0, flash_damp );
		break;
		case 1:
			
		break;
	}
}

#endregion

#region Black Bars

//Blackbars
if ( bar_toggle ){
	bar_perc_set	= bar_perc_fixed;
}else {
	bar_perc_set	= 0;
}

//Bar timers 
if(bar_toggle && bar_timer>-1){
	bar_timer-= var_time;
	bar_perc_set	= bar_perc_temp; //set inside script
}else{
	bar_perc_set = 0; bar_perc_temp=0;
	bar_toggle = false; bar_timer=0; //reset bar_toggle
}

bar_perc	= Tween_Weighted( bar_perc, bar_perc_set, 7 );

/*
//--	Toggle Bars		--//
if ( bar_toggle ){
	bar_perc_set	= bar_perc_fixed;
} else {
	bar_perc_set	= 0;
}

//--	Set percentage		--//
bar_perc	= Tween_Weighted( bar_perc, bar_perc_set, 7 );
*/
#endregion

} //End Path else statement ////////////////////////////////////////////////////////////////////

#region Set Camera variables


// Set cam coords relative to target
tx		= clamp( tx, 0, room_width );
ty		= clamp( ty, 0, room_height );
var_x_set	= tx- ( var_w* cu ); // +offx ** update in later version **
var_y_set	= ty- ( var_h* cv );


/////////////////////////////
//--		Clamp		--//
///////////////////////////
if ( inroom ){
	var_x_set	= clamp( var_x_set, 0, room_width-  var_w ); // Pos stays inside room
	var_y_set	= clamp( var_y_set, 0, room_height- var_h );

	// Check if the view is inside the room
	var prev_w = (set_w* var_z); //default views w/o clamping
	var prev_h = (set_h* var_z);
	
	var temp_z = ((prev_w>room_width) ? (room_width/set_w) : var_z ); //get clamped zoom value
	var temp_z = ((prev_h>room_height) ? (room_height/set_h) : var_z );
	
	var_w	= (set_w* temp_z); //apply new zoom value after passing through tenary statements!
	var_h	= (set_h* temp_z);
	
	// Version 3
	// You can see why the aspect ratio can get distorted when exceeding the room width/height!
	//var_w	= min( (set_w* var_z), room_width );
	//var_h	= min( (set_h* var_z), room_height );
} else {
	var_w	= ( set_w* var_z );
	var_h	= ( set_h* var_z );
}


///////////////////////////////////////////
///---		Finalize temp vars		---///
/////////////////////////////////////////
var_z_set	= shakez+ clamp( var_z_set, z_min, z_max ); 
var_z	= ( lerp( var_z, var_z_set, 0.1 ));
var_a	= ( lerp( var_a, var_a_set, 0.1 ));

var_x	= floor( var_x_set );
var_y	= floor( var_y_set );
/* Zooming is not perfect yet- I'll be updating this
var_x	= floor( Tween_Smooth( var_x, var_x_set, 3 ));
var_y	= floor( Tween_Smooth( var_y, var_y_set, 3 ));
*/

///////////////////////////////////////////////////////////////////////////////////////////////
///---		Set variables to values. Apply changes to the Camera in the End Step		---///
/////////////////////////////////////////////////////////////////////////////////////////////
view_x		= var_x;
view_y		= var_y;
view_w		= var_w;
view_h		= var_h;
view_z		= var_z;
view_a		= var_a;
set_x		= var_x_set;
set_y		= var_y_set;
set_z		= var_z_set;
set_a		= var_a_set;

#endregion
	
