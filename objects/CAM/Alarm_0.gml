/// @description Reset Window, Views, and Variables

alarm[1]	= 1; //reposition debug stuff

// Params ( window num, res, );
//event_perform( ev_create, 0 );

#region Window & View 
//////////////////////////////
///--	Window & View	--///
////////////////////////////
global.WINDOW_W = global.WINDOW_DIM[ global.WINDOW, 0 ];  
global.WINDOW_H = global.WINDOW_DIM[ global.WINDOW, 1 ];
global.WVIEW	= global.WINDOW_W* res;
global.HVIEW	= global.WINDOW_H* res;

//-- Camera variables ---\\
view_w	= global.WVIEW;
view_h	= global.HVIEW;
view_x		= 0;
view_y		= 0;
view_z		= 1;
view_a		= 0;
	
//-- Set variables --\\
set_w		= view_w;
set_h		= view_h;
set_x		= view_x;
set_y		= view_y;
set_z		= view_z;
set_a		= view_a;

///////////////////////////////
cx	= global.WINDOW_W* cu;
cy	= global.WINDOW_H* cv;
#endregion

#region Camera Setup
//////////////////////////////
///--		Camera		--///
////////////////////////////
camera	= camera_create();
vm	= matrix_build_lookat(0,0, -10, 0,0,0,0,1,0 );
pm	= matrix_build_projection_ortho( global.WVIEW, global.HVIEW, 1, 3200 );
camera_set_view_mat( camera, vm );
camera_set_proj_mat( camera, pm );
camera_set_view_size( view_camera[0], view_w, view_h );
camera_set_view_pos(  view_camera[0], 0, 0 );

view_enabled	= true;
view_camera[0]	= camera;
view_visible[0]	= true;
///////////////////////////////


//////////////////////////
///--	Resizing	--///
////////////////////////
// Size of Window, App and GUI Surface
window_set_size( global.WINDOW_W, global.WINDOW_H );
surface_resize(  application_surface, global.WINDOW_W, global.WINDOW_H ); //set window size to the default size set in your editor
display_set_gui_size( global.WINDOW_W, global.WINDOW_H ); //set gpu size to the application surface ( 1:1 ratio )
///////////////////////////////
#endregion
