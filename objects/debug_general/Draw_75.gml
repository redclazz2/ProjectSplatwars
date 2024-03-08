/// @description Debug Text
// You can delete this all if you don't need the info or clutters your existing UI.

#region Variables
//////////////////////
///--	Debug	--///
////////////////////
var wx		= window_mouse_get_x();
var wy		= window_mouse_get_y();
var starth	= ( -130 +( 150* global.debug_spring_val) );
var startv	= 35+ (global.sine_val* 8);
var vgap	= 20;
var v		= 0;
var _title_scale = /*(global.sine_val/4)+ */ 2;

//////////////////////////////////
///--	Window Resolution	--///
////////////////////////////////
var startx	= display_get_gui_width()-15;
var starty	= 30;
var gapy	= 25;
var _window_count = array_height_2d( global.WINDOW_DIM );
///--	
#endregion

if ( global.debug_lerp_alpha > 0  ){
#region Shade
// Shade the top and bottom of the screen
/////////////////////
//--	Top		--//
///////////////////
var _sw	= sprite_get_width( sShade );
var _c	= round( display_get_gui_width()/_sw );
for ( var i=0; i<_c; i++; ){
	draw_sprite_ext( sShade,0, (i* _sw), display_get_gui_height(), 1,1, 0,c_white, global.debug_lerp_alpha );
}
////////////////////////
//--	Bottom		-//
//////////////////////
for ( var i=0; i<_c; i++; ){
	draw_sprite_ext( sShade,0, (i* _sw), 0, 1,-1, 0,c_white, global.debug_lerp_alpha );
}
#endregion

#region Text
//draw_set_font( global.font[ FONT.jasontomlee ] ); //example of setting a font
draw_set_halign( fa_center );
draw_set_valign( fa_center );
draw_set_alpha( global.debug_lerp_alpha );
draw_set_color( c_white );
show_debug_overlay( global.DEBUG );

draw_text_transformed(  60, startv+ (vgap* v)- global.sine_val* 8, "DEBUG", _title_scale,_title_scale, 0 ); v++; //title

//////////////////////////////
///--	General Info	--///
////////////////////////////
draw_set_halign( fa_left );
draw_text( starth,startv+ (vgap* v), "TIME: x"+string( global.TIME ) ); v++;
draw_text( starth,startv+ (vgap* v), "Room: "+string( room_string ) ); v++;
draw_text( starth,startv+ (vgap* v), "Objects: "+string( instance_count ) ); v++;
draw_text( starth,startv+ (vgap* v), "FPS: "+string( round(fps_real) ) ); v++;
draw_text( starth,startv+ (vgap* v), "Room Speed: "+string( room_speed ) ); v++;

#endregion

#region Resize Window
draw_set_halign( fa_right ); // Window Size 
//draw_text( display_get_gui_width()-15, 50, string( global.WINDOW_DIM[ global.WINDOW, 0 ] )+" x "+ string( global.WINDOW_DIM[ global.WINDOW, 1 ] ));

if ( global.DEBUG ){
for( var i=0; i<_window_count; i++; ){
	draw_set_alpha( global.debug_lerp_alpha* 0.33 );
	var _str	= string( global.WINDOW_DIM[ i, 0 ] )+" x "+ string( global.WINDOW_DIM[ i, 1 ] );
	
	///////////////////////////////////
	///--	Collision Rectangle	 --///
	/////////////////////////////////
	if ( 1 ){
	var _tw		= -2/*+ global.cos_val* 3;*/
	var _w		= string_width( _str );
	var _x1		= startx- _w-5- _tw;
	var _x2		= startx+ _tw;
	var _y1		= starty+ (i* gapy)-10- _tw;
	var _y2		= starty+ (i* gapy)+ gapy-10+ _tw;
	
		if ( point_in_rectangle( wx,wy,_x1,_y1,_x2,_y2 )){ //collision check
			draw_set_alpha( global.debug_lerp_alpha );
			window_set_cursor( cr_drag ); //set mouse sprite
			
			if ( mouse_check_button_pressed( mb_left )){
				global.WINDOW = i;
				window_reset_dimension( global.WINDOW,1 );
			}
		}
		draw_rectangle( _x1,_y1,_x2,_y2, true ); //draw collision rectangle
	}
		draw_text( startx,starty+ (i* gapy), _str ); //Dimension text
	}
	
}

/*
draw_set_halign( fa_right );
draw_text( starth,startv+ (vgap* v), string_hash_to_newline("CPU Usage: "+string(cpu_usage())+"%") ); v++;
draw_text( starth,startv+ (vgap* v), string_hash_to_newline("RAM installed: "+string(ram_installed()/1024/1024)+" MB") ); v++;
draw_text( starth,startv+ (vgap* v), string_hash_to_newline("RAM used: "+string(ram_used()/1024/1024)+" MB") ); v++;
draw_text( starth,startv+ (vgap* v), "RAM available: "+string(ram_available()/1024/1024)+" MB" ); v++;
draw_text( starth,startv+ (vgap* v), string_hash_to_newline("RAM used by this application: "+string(ram_application()/1024/1024)+" MB") ); v++;
*/

#endregion

}

draw_set_alpha( 1 );
