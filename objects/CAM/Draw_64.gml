/// @description Post-process effects

#region Shader 
//For shaders effects
/*
surface_set_target( global.AppSurf );
draw_surface( application_surface, 0,0 );
surface_reset_target();
*/
var prev_alpha = draw_get_alpha();

draw_set_color( flash_color );
draw_set_alpha( flash_alpha );
draw_rectangle( 0,0, display_get_gui_width(), display_get_gui_height(), false );

//////////////////////////
///--	Blackbars	--///
////////////////////////
var perc_height = bar_perc* display_get_gui_height();

draw_set_color( c_black );
draw_set_alpha( bar_alpha );
draw_rectangle( 0,0, display_get_gui_width(), perc_height, false );
draw_rectangle( 0, display_get_gui_height(), display_get_gui_width(), (display_get_gui_height()-perc_height), false );


draw_set_alpha( prev_alpha );

#endregion
