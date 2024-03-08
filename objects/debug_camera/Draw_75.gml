//		** THIS IS SOLELY FOR DEBUGGING PURPOSES **		//
//		** Delete it all if you don't need it!   **		//

if ( instance_exists( cam ))
with( cam ){
#region Debug Info


#region Temp Variables

///////////////////////////////////////
///---		Temp Variables		---///
/////////////////////////////////////
var debug_alpha  = global.debug_lerp_alpha;
var debug_spring = global.debug_spring_val;
var debug_sine	 = global.sine_val;
var wx			 = window_mouse_get_x();
var wy			 = window_mouse_get_y();


if ( debug_alpha > 0 ){

draw_set_halign( fa_left );
draw_set_valign( fa_center );
draw_set_alpha( debug_alpha );
draw_set_color( c_white );
show_debug_overlay( global.DEBUG );


var starth_left	= -200 + ( 225* debug_spring ) +(debug_sine* 12);
var starth_right = map_coord[0]-120- (debug_sine* 6);
var startv	= global.WINDOW_H- 25;
var vgap	= 20;
var hgap	= 50;
var v		= 0;
var h		= 0;



color_desc		= make_color_hsv( (255* debug_sine*0.66)* 0.33, 45, 100 );


#endregion

#region Button backdrop for Follow/Shake states
if ( bhover != -1 && !bbool[ bhover ] ){
	///////////////////////////
	///---	Backdrop	---///
	/////////////////////////
	var prev_alpha	= draw_get_alpha();
	var prev_col	= draw_get_color();
	draw_set_alpha( (hover_tween_value* 0.88)* debug_alpha ); //btween tweens from 0-1 when hovering over a button
	draw_set_color( c_black );
	draw_rectangle( 0,0, display_get_gui_width(), display_get_gui_height(), false );
	
	draw_set_color( c_white );
	var B_ARRAY = [];
	var B_DESC	= [];
	var B_VAL	= -1;
	
	switch( bhover ){
		case 0:
			for( var q=0; q< shake.count; q++; ){
				B_ARRAY[ q ]	= shake_string[ q ]; //copy the state's strings to draw it in your new temp array
				B_DESC[  q ]	= /*shake_desc[ q ]*/ shake_desc[ 0 ]; //description
			}
			B_VAL		= MODE[ SHAKE ]; //get what 'shake-mode' you're on
		break;
		case 1:
			for( var z=0; z< follow.count; z++; ){
				B_ARRAY[ z ]	= follow_string[ z ];;
				B_DESC[  z ]	= follow_desc[ z ];
			}
			B_VAL		= MODE[ FOLLOW ];//get 'follow-mode' value 
		break;
	}


	/////////////////////////////
	//-- Draw Overlay Text	--//
	///////////////////////////
	if ( B_VAL != -1 ){ //if you're hovering over the SHAKE or FOLLOW button...
		var _v_off	= 50;
		var _h_off	= 0;
		boverlay_xoff_select	= NumericSpring_Get_Val( 1 );
		boverlay_xoff_other		= Tween_Weighted( boverlay_xoff_other, -20, 5 );
		
		if ( mouse_wheel_up() || mouse_wheel_down() ){
			NumericSpring_Set_Val( 1, 0 );//reset selected offset value
			boverlay_xoff_other		= 0; //reset other
		}
		
		for ( var a =0; a< array_length_1d( B_ARRAY ); a++; ){
			if ( a == B_VAL ){ _h_off	= boverlay_xoff_select; draw_set_alpha( 0.9 ) }else{ _h_off = boverlay_xoff_other; draw_set_alpha( 0.2 ); }
			
			draw_text_transformed( display_get_gui_width()/2.2- _h_off, display_get_gui_height()/2- ( _v_off* (B_VAL-a)), string(B_ARRAY[a]),3,3,0 ); // Draw all the possible 'States' of the hovered button
			if ( a == B_VAL ){ var prev_halign = draw_get_halign(); var prev_valign = draw_get_valign(); draw_set_halign( fa_center ); draw_set_valign( fa_top );
				//draw_text_transformed( display_get_gui_width()/2, 80, string( B_DESC[a] ), 1.5,1.5, 0 ); // Description of how to use the selected state. Aka mini-tutorial!
				//draw_text_ext( display_get_gui_width()/2, 80, string( B_DESC[a] ), 28, display_get_gui_width()* 0.8 );
				draw_text_ext_transformed_colour(  display_get_gui_width()/2, 70, string( B_DESC[a] ), 20, display_get_gui_width()* 0.5, 1.5,1.5, 0, c_white ,c_white,color_desc,color_desc, 1 );
				draw_set_halign( prev_halign ); draw_set_valign( prev_valign );
			} 
		}
	}
	draw_set_alpha( prev_alpha );
	draw_set_color( prev_col );
}

#endregion

#region Button Text 
///////////////////////////////////
///---		Draw Text		---///
/////////////////////////////////
// Display Debug buttons on the bottom left. Determine what text will be displayed.
for( var i=0; i< bc; i++; ){
	var BB;
	BB[0]	= bx[ i ]+ bxoff[ i ];
	BB[1]	= by[ i ]+ (byoff[ i ]* bbool[ i ]);
	BB[2]	= bx[ i ]+ bw[ i ]+ bxoff[ i ];
	BB[3]	= by[ i ]+ bh[ i ]+ (byoff[ i ]* bbool[ i ]);
	
	draw_set_alpha( balpha[ i ]* debug_alpha + 0.1 ); //set main button text alpha
	draw_text_transformed( BB[0], BB[1]+ bh[ i ]/2, bstr[ i ], bscale[ i ], bscale[ i ], 0 ); //main button text
	draw_set_alpha( balpha[ i ]* debug_alpha* 0.5 );
	draw_rectangle( BB[0],BB[1],BB[2],BB[3], true ); //box
	
	
	// You could calculate this statement outside this for-loop for better optimisation
	// But oh well ¯\_(ツ)_/¯
	if ( bhover == i || bbool[ i ] ){	//if the button is hovered or active
	var l = i;
	
	var _v	= 0; 
	var _vgap = -25* btween[ l ];
	draw_set_alpha( btween[ l ]* debug_alpha );

	var _sca	= bscale[ l ]* 0.5;
	var _x	=  bx[ l ]+ bxoff[ l ];
	var _y	=  by[ l ]+  bh[ l ]/2- 50;
	
	var BB;
	BB[0]	= bx[ l ];
	BB[1]	= by[ l ];
	BB[2]	= bx[ l ]+ bw[ l ];
	BB[3]	= by[ l ]+ bh[ l ];
	
	draw_set_alpha( balpha[ l ]* debug_alpha );
	draw_rectangle( BB[0],BB[1],BB[2],BB[3], true ); //draw text collision box 
	

	
	/////////////////////////////////
	//--	Draw Button text	--//
	///////////////////////////////
	switch( i ){
		case 0: //Shake
			draw_text_transformed( _x, _y+ ( _v* _vgap), "DAMP: "+ string( (shake_damp_time/room_speed) )+" sec", _sca,_sca, 0 ); _v++;
			draw_text_transformed( _x, _y+ ( _v* _vgap), "DIR: "+ string( round(shake_dir) ), _sca,_sca, 0 ); _v++;
			draw_text_transformed( _x, _y+ ( _v* _vgap), "AMOUNT: "+string( round(shake_amount) ), _sca,_sca, 0 ); _v++;
			draw_text_transformed( _x, _y+ ( _v* _vgap), "TYPE: "+ string( shake_string[ MODE[ SHAKE ]] ), _sca,_sca, 0 ); _v++;
			
		break;
		case 1: //Follow
			draw_text_transformed( _x, _y+ ( _v* _vgap), "TARGET: " + string( object_get_name(target) ),_sca,_sca, 0); _v++;
			draw_text_transformed( _x, _y+ ( _v* _vgap), "TYPE: " + string( follow_string[ MODE[ FOLLOW ]] ),_sca,_sca, 0); _v++;
			
		break;
		case 2:
			var _x2	= _x - (120* btween[ l ]); 
			_v-=3;
			var _inroom = (inroom ? "true" : "false");
			draw_text_transformed( _x2, _y- ( _v* _vgap), "ZOOM: " + string( view_z ),_sca,_sca, 0); _v++;
			draw_text_transformed( _x2, _y- ( _v* _vgap), "VIEWW: " + string( round(view_w) ),_sca,_sca, 0); _v++;
			draw_text_transformed( _x2, _y- ( _v* _vgap), "VIEWH: " + string( round(view_h) ),_sca,_sca, 0); _v++;
			
			draw_text_transformed( _x2, _y- ( _v* _vgap), "ANGLE: " + string( round(view_a) ),_sca,_sca, 0); _v++;
			draw_text_transformed( _x2, _y- ( _v* _vgap), "RES: " + string( res ),_sca,_sca, 0); _v++;
			draw_text_transformed( _x2, _y- ( _v* _vgap), "CU: " + string( cu ),_sca,_sca, 0); _v++;
			draw_text_transformed( _x2, _y- ( _v* _vgap), "CV: " + string( cv ),_sca,_sca, 0); _v++;
			draw_text_transformed( _x2, _y- ( _v* _vgap), "INROOM: " + _inroom,_sca,_sca, 0); _v++;
			
		break;
	}
}

}

#endregion

#region Visualize Info 

// Adjusting center offset
if ( centershift ){
	draw_set_alpha( 1 );
	draw_line_width( wx, 0, wx, global.WINDOW_H, 2 );
	draw_line_width( 0, wy, global.WINDOW_W, wy, 2 );
	draw_text_transformed( wx+ 50, wy+15, "CU: "+string( cu ),2,2,0 );
	draw_text_transformed( wx,wy+ 50, "CV: "+string( cv ),   2,2,0 );
}

//--	 Copy to Clipboard		--//
draw_set_alpha( copyalpha );
draw_text_transformed( wx+20,wy+20, "copied!",1+copyalpha,1+copyalpha, 0 );


//--	 Visuals based on Follow Modes		--//
draw_set_alpha( debug_alpha );
switch( MODE[ FOLLOW ] ){
	/*
	case follow.mfree:
		var BOX, PERC, WGAP, HGAP;
		PERC	= bbox_perc;
		WGAP	= global.WINDOW_W* PERC;
		HGAP	= global.WINDOW_H* PERC;
		BOX[0]	= WGAP;
		BOX[1]	= HGAP;
		BOX[2]	= global.WINDOW_W- WGAP;
		BOX[3]	= global.WINDOW_H- HGAP;
		draw_rectangle( BOX[0],BOX[1],BOX[2],BOX[3], true );
		
	break;
	*/
	
	case follow.bbox:
		var BOX, PERC, WGAP, HGAP;
		PERC	= bbox_perc;
		WGAP	= global.WINDOW_W* PERC;
		HGAP	= global.WINDOW_H* PERC;
		BOX[0]	= WGAP;
		BOX[1]	= HGAP;
		BOX[2]	= global.WINDOW_W* (1-PERC);
		BOX[3]	= global.WINDOW_H* (1-PERC);
		draw_rectangle( BOX[0],BOX[1],BOX[2],BOX[3], true );
	break;
}

//--		Zoom Values			--//
var h_gap	= 9; //gap between the right edge of the mini-map & window border.
var v_gap	= 15; //
var z_perc	= ((map_coord[3]- v_gap) - (map_coord[1]+ v_gap))* ( view_z- z_min )/( z_max- z_min );

draw_rectangle( map_coord[2]+h_gap, map_coord[3]- v_gap- z_perc, global.WINDOW_W- h_gap,map_coord[3]- v_gap, false ); //fill
draw_rectangle( map_coord[2]+h_gap, map_coord[1]+ v_gap, global.WINDOW_W- h_gap,map_coord[3]- v_gap, true );  //outline
draw_sprite_ext( splus, 0, map_coord[2]+ map_margin/2, map_coord[1], 1,1,0,c_white, debug_alpha );
draw_sprite_ext( sminus, 0, map_coord[2]+ map_margin/2, map_coord[3], 1,1,0,c_white, debug_alpha );

if ( view_z != set_z ){
	draw_text( wx+10,wy+15, string( view_z ));
}

#endregion

#region Mini-Map
///////////////////////////////////
///---		Mini-Map		---///
/////////////////////////////////
// Display View position and size relative to the room 


//////////////////////////////////////////////////////////////////////

var _y1		= map_coord[1]
var _y2		= map_coord[3];
var _hoff   = (debug_alpha* 60)- 60;
draw_set_alpha( 0.2+ debug_alpha* debug_sine );
draw_rectangle( map_coord[0]- _hoff, _y1- _hoff ,map_coord[2]+ _hoff, _y2+ _hoff, true ); // room
draw_set_alpha( debug_alpha );

var ratio_w	= ( map_w / room_width );
var ratio_h	= ( map_h / room_height );
var VAR_VIEW; //arrays 
var VAR_ZOOM;
var VAR_ALPHA;
VAR_ZOOM[0]		= z_max;
VAR_ZOOM[1]		= view_z;
VAR_ZOOM[2]		= z_min;
VAR_ALPHA[0]	= 0.66* (debug_alpha* debug_sine)* 0.5;
VAR_ALPHA[1]	= 0.66* (debug_alpha* debug_sine)* 0.5;
VAR_ALPHA[2]	= debug_alpha;


for( var i = 0; i< 3; i++; ){	//draw view rectangles 
var temp_z		= VAR_ZOOM[ i ]* debug_alpha;
var temp_x1		= ratio_w* ( tx- ( ( set_w* temp_z )* cu) );
var temp_y1		= ratio_h* ( ty- ( ( set_h* temp_z )* cv) );
var temp_w		= ratio_w* (set_w* temp_z);
var temp_h		= ratio_h* (set_h* temp_z);

temp_x1 = clamp( temp_x1, 0, map_w- temp_w );
temp_y1	= clamp( temp_y1, 0, map_h );

VAR_VIEW[0]		= max( map_coord[0]+ (  temp_x1 ), map_coord[0] );
VAR_VIEW[1]		= max( map_coord[1]+ (  temp_y1 ), map_coord[1] );
VAR_VIEW[2]		= min( VAR_VIEW[0]+ (  temp_w ), map_coord[2] );
VAR_VIEW[3]		= min( VAR_VIEW[1]+ (  temp_h ), map_coord[3] );



draw_set_alpha( VAR_ALPHA[i] );
if ( i == 0 ){
	draw_rectangle( VAR_VIEW[0],VAR_VIEW[1],VAR_VIEW[2],VAR_VIEW[3], false ); // view rectangles scaled to size
	draw_set_alpha( 1 );
	draw_rectangle( VAR_VIEW[0],VAR_VIEW[1],VAR_VIEW[2],VAR_VIEW[3], true );
} else if ( i == 1 ){
	gpu_set_blendmode(bm_subtract);
	draw_rectangle( VAR_VIEW[0],VAR_VIEW[1],VAR_VIEW[2],VAR_VIEW[3], false ); // view rectangles scaled to size
	gpu_set_blendmode(bm_normal);
	draw_set_alpha( 1 );
	draw_rectangle( VAR_VIEW[0],VAR_VIEW[1],VAR_VIEW[2],VAR_VIEW[3], true );
} else {
	draw_rectangle( VAR_VIEW[0],VAR_VIEW[1],VAR_VIEW[2],VAR_VIEW[3], true ); // view rectangles scaled to size
}

}

///////////////////////////////////////////////////////////////
#endregion

#region Target coords
////////////////////////////////////
///---	 Target Coords		---////
//////////////////////////////////
draw_set_alpha( debug_alpha* 0.7 );
draw_set_color( c_maroon );
var var_tx	= map_coord[0]+ (tx* ratio_w); //top left + position in room 
var var_ty	= map_coord[1]+ (ty* ratio_h); 
draw_circle( var_tx, var_ty, 3+ (debug_sine), true ); // target coords

///////////////////////////////
///--		Angle		---///
/////////////////////////////
var ang_line_x	= var_tx+ lengthdir_x( (tx*ratio_w), view_a );
var ang_line_y	= var_ty+ lengthdir_y( (ty*ratio_h), view_a );
draw_line( var_tx, var_ty, ang_line_x, ang_line_y );


///-- Center coords	--//
draw_set_color( c_white );
draw_sprite( scenter, 0, cx, cy );

#endregion

#region Locked
draw_text_transformed_color( locked_x, locked_y- locked_yoff, string( "LOCKED" ), 2,2, 0 , c_white,c_white,c_white,c_white, locked_yoff/room_speed );


#endregion


} //end debug statement

#endregion

}

draw_set_alpha( 1 );
