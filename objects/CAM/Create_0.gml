//////////////////////////////////////////////
///---			CAMERA- Basic			--///
////////////////////////////////////////////
/*
		Learn the fundamentals of the Gamemaker Camera!
		Import into your projects whether it be a Top-Down, Isometric, Platformer, etc! 
		A variety of features will be added in future versions.

		Uses for this Camera:
		1) Resizing Windows, GUI/Application surfaces, and Views
		2) Camera Shake ( Jitter, Spring, and Recoil )
		3) Follow Modes 
		4) Zoom
		
		***VERSION 5 NOTES***
		5) Paths camera movement
		-Temp script variables
		-CAM_BLACKBAR example using temp variables
		
		***Future Versions***
		-Simple post-processing shaders
		-Transition effects
		-Super-smash follow mode
		-Cinema shake mode
		-Recoil, Offsetting ( for platformers )
*/

#region General
	//event_user( 0 );
	global.TIME		= 1; //used for dialation 
						 //controled inside the 'GAME' object
						 
	if ( !instance_exists( CONTROLLER )){
		global.WINDOW		= 0; //which size preset to choose 
		window_create_dimension( 0, 960, 720 );
		window_create_dimension( 1, 640, 360 );
		window_create_dimension( 2, 1024, 768 );
	}
	
	///////////////////////////////
	///---		Camera		---///
	/////////////////////////////
	res				= 1; //resolution 
	global.WINDOW_W = global.WINDOW_DIM[ global.WINDOW, 0 ];  
	global.WINDOW_H = global.WINDOW_DIM[ global.WINDOW, 1 ];
	global.WVIEW	= global.WINDOW_W* res;
	global.HVIEW	= global.WINDOW_H* res;

	camera	= camera_create();
	vm	= matrix_build_lookat(0,0, -10, 0,0,0,0,1,0 );
	pm	= matrix_build_projection_ortho( global.WVIEW, global.HVIEW, 1, 3200 );
	camera_set_proj_mat( camera, pm );
	camera_set_view_mat( camera, vm );
	
	//--	Set Values	--\\
	z_max	= 2;
	z_min	= 0.5;
	z_x		= 0; //Offset camera x/y depending on scale
	z_y		= 0;
	
	//-- Camera variables ---\\
	view_w	= global.WVIEW;
	view_h	= global.HVIEW;
	view_x		= 0; view_xoff = 0;
	view_y		= 0; view_yoff = 0;
	view_z		= 1;
	view_a		= 0;
	
	//-- Set variables --\\
	set_w		= view_w;
	set_h		= view_h;
	set_x		= view_x;
	set_y		= view_y;
	set_z		= view_z;
	set_a		= view_a;
	set_xoff	= view_xoff;
	set_yoff	= view_yoff;
	
#endregion

#region Modes
	///////////////////////////////
	///---		MACROS		---///
	/////////////////////////////
	#macro FOLLOW 0
	#macro SHAKE 1 
	
	///////////////////////////////
	///---		FOLLOW 		---///
	/////////////////////////////
	MODE[ FOLLOW ]		= 0; 
	enum follow {
		target,
		bbox,
		mpeek,
//		mfree,
		mdrag,
		supersmash,
		count
	}
	
	///////////////////////////////////////////////////
	///---		Strings and Descriptions		---///
	/////////////////////////////////////////////////
	follow_string[ 0 ]	= "target"; //follow target
	follow_string[ 1 ]	= "boundbox";
	follow_string[ 2 ]	= "target mouse"; //top-down
//	follow_string[ 3 ]	= "mouse-free"; 
	follow_string[ 3 ]	= "mouse-drag";
	follow_string[ 4 ]  = "super-smash";
	
	follow_desc[ 0 ]	= "Aligns 'target' object to the center coords( cv & cu ). Set target object inside Player object. Make sure CAM is created before the Player.";
	follow_desc[ 1 ]	= "When the specified target is outside the white boundary lines, the camera moves in the TARGET's direction. Does not move if no TARGET is specified.";
	follow_desc[ 2 ]	= "Camera follows the TARGET instance with an offset based on the cursor's distance from the center of the window.";
	follow_desc[ 3 ]	= "Hold the Left-Mouse button to drag the Camera";
	follow_desc[ 4 ]	= "Averages the center coords between target & target_second.";

	
	target		= noone; //target object to follow
	target_second = noone; //second target (used in supersmash follow mode) Change to array in the future.
	tx			= 0;	 // coords of target
	ty			= 0;
	spd			= 0; //used in 'mouse free'
	dir			= 0; 
	bbox_perc	= 0.05; // used in 'mouse free'
	
	bbox_w[0]	= 0.1; // Used in 'target boundbox' 
	bbox_w[1]	= 0.1; // Determines the borders of the boundbox ( multipied by the view width/height )
	bbox_h[0]	= 0.1; 
	bbox_h[1]	= 0.1;
	prevx		= mouse_x; //used in 'mouse drag' and 'target boundbox'
	prevy		= mouse_y; 
	prevmx		= mouse_x;
	prevmy		= mouse_y;
	inroom		= true;
	
	/////////////////////////////
	////--	Center Points	--//
	///////////////////////////
	cu	= 0.5; //0 = left 1 = right
	cv	= 0.5; //0 = top  1 = bottom
	cx	= global.WINDOW_W* cu;
	cy	= global.WINDOW_H* cv;
	
	
	///////////////////////////////
	///---		SHAKE		---///
	/////////////////////////////
	MODE[ SHAKE ] = 0; 
	enum shake {
		jitter,
		numeric,
		bounce,
		count
	}
	///////////////////////////////////////////////////
	///---		Strings and Descriptions		---///
	/////////////////////////////////////////////////
	shake_string[ 0 ]	= "jitter";
	shake_string[ 1 ]	= "numeric";
	shake_string[ 2 ]	= "bounce";
	
	shake_desc[ 0 ]		= "Jitter ";
	shake_desc[ 1 ]		= "numeric";
	shake_desc[ 2 ]		= "bounce";
	
	
	
	shake_amount= 0; //shake intensity
	shake_dur	= 0; //shake duration
	shake_dir	= 0; //0-360 angle, -1 will randomize the angle
	
	shake_damp_time = room_speed* 2; //how long it'll take to reset 'shake_amount' back to 0
	shake_damp		= 1;		  //the value used to 
	
	shakex	= 0;
	shakey	= 0;
	shakea	= 0;  //angle
	shakez	= 0; //zoom (add/subtract zoom)
	NumericSpring_Create( 0, 0,0,0, 0.22, 3, 1 ); //numeric shake
	Spring_Create( 0, 0,0, 0.3, 0.1 ); //bounce shake
	
#endregion

#region Screen Effects
///////////////////////////////
///---		Flash		---///
/////////////////////////////
flash_color		= c_white;
flash_alpha		= 0; flash_alpha_set	= 0;
flash_timer		= 0; //flash_dur		= 0;	

flash_damp_time	= 0; flash_damp		= 0;
flash_state		= 0; /* later version */


///////////////////////////////
///---		Bars		---///
/////////////////////////////
//Version 5
bar_alpha  = 1;
bar_toggle = false;
bar_timer = 0;
bar_perc = 0;		 bar_perc_set = 0; 
bar_perc_fixed = 0.1; bar_perc_temp = 0.1;

/* Version 3
bar_toggle		= false;

bar_alpha		= 1;	bar_alpha_set	= 0;	
bar_perc		= 0;	bar_perc_set	= 0;	bar_perc_fixed = 0.3;
bar_dur			= 0;	bar_dur_set		= 0;	
*/

#endregion

#region Temp Variables **NEW**
//Follow
follow_temp = false; follow_timer = 0; follow_old = 0; target_old = noone;

//Center Coord
c_temp = 0; cu_old = 0; cv_old = 0; c_timer = 0;

//InRoom
inroom_temp = inroom; inroom_timer = 0; inroom_old  = inroom; 

//Zoom
zoom_timer = 0; zoom_temp = false; zoom_old  = 1;

#endregion


#region Paths **NEW**
isPath		= false; //automatically set the Camera's follow state to 'Target' & target id to self
					 //reset when path ends (after a set delay?)
#endregion


#region Debug 
	// Copy follow and shake script
	copy		= false; copyalpha		= 0;
	centershift	= false;
	clickedx	= mouse_x;
	clickedy	= mouse_y;
	locked		= false; //Locked string that pops up when you press a button
	locked_x	= 0;     //Locking prevents you from accidently mouse wheeling over the button
	locked_y	= 0;
	locked_timer	= 0;
	locked_yoff		= 0;
	color_desc		= 0;
	
	///////////////////////////////////
	///---		Mini-map		---///
	/////////////////////////////////
	map_w	= 125;
	map_margin	= 35;
	
	///////////////////////////////
	///---		Buttons		---///
	/////////////////////////////
	bc	= 0;
	bhover	= -1; //hovered button
	bselect = -1; //selected button
	
	hover_tween_value	= 0;
	hover_tween_set		= 0;
	boverlay_xoff_select		= 0; NumericSpring_Create( 1, 0, 0, 100, 0.33, 8, 1 ); //Offset of the currently set Shake/Follow mode.
	boverlay_xoff_other			= 0; 
	
	alarm[1]	= 0;// Set all debug buttons in Alarm[1].
					// This is so the positional values are reset when resizing the window-size
#endregion
