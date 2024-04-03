/// @desc Debug UI
draw_set_font(-1);		 // (Font)  Change
draw_set_color(c_white); // (Color) Change

// Turn "TRUE" To "FALSE" If you don't wanna see debug UI even if the debug mode is (On)
if (true) {
	if (surface_exists(debug_surface))	{
		surface_set_target(debug_surface);
		draw_clear_alpha(c_black, 0);
			var _ybuffer = 8;
			var _xpad = 16, _ypad = 16;

			draw_text(_xpad, _ypad,				  "APP SURF	: " + string(surface_get_width(application_surface))	+ "x" + string(surface_get_height(application_surface)));
			draw_text(_xpad, _ypad + _ybuffer*2,  "DISPLAY	: " + string(display_get_width())						+ "x" + string(display_get_height()));
			draw_text(_xpad, _ypad + _ybuffer*4,  "WINDOW	: " + string(window_get_width())						+ "x" + string(window_get_height()));
			draw_text(_xpad, _ypad + _ybuffer*6,  "VIEW		: " + string(camera_get_view_width(kamera))				+ "x" + string(camera_get_view_height(kamera)));
			draw_text(_xpad, _ypad + _ybuffer*8,  "GUI		: " + string(display_get_gui_width())					+ "x" + string(display_get_gui_height()));

			draw_text(_xpad, _ypad + _ybuffer*12, "V-PORT CURRENT   : " + string(view_current) + "|" + string(view_enabled));
			draw_text(_xpad, _ypad + _ybuffer*14, "V-PORT VISIBLE	: " + string(view_get_visible(view_index)));
			draw_text(_xpad, _ypad + _ybuffer*16, "V-PORT ROOM		: " + string(room_get_viewport(room, view_index)));

			draw_text(_xpad, _ypad + _ybuffer*20, "CAM ID			: " + string(kamera));
			draw_text(_xpad, _ypad + _ybuffer*22, "ROOM CAM ID		: " + string(room_get_camera(room, view_index)));
			draw_text(_xpad, _ypad + _ybuffer*24, "V-PORT CAM ID	: " + string(view_get_camera(view_index)));
			draw_text(_xpad, _ypad + _ybuffer*26, "ACTIVE CAM ID	: " + string(camera_get_active()));

			draw_text(_xpad, _ypad + _ybuffer*30, "CAM X : " + string(camera_get_view_x(kamera)));
			draw_text(_xpad, _ypad + _ybuffer*32, "CAM Y : " + string(camera_get_view_y(kamera)));

			if (!is_undefined(k_target) && instance_exists(k_target))	{
				draw_text(_xpad, _ypad + _ybuffer*34, "TARGET X	: " + string(k_target.x));
				draw_text(_xpad, _ypad + _ybuffer*36, "TARGET Y	: " + string(k_target.y));
				draw_text(_xpad, _ypad + _ybuffer*40, "ZOOM		: " + string(round(k_zoom * 100)) + "%");
				draw_text(_xpad, _ypad + _ybuffer*42, "SPEED	: " + string(k_spd));
				draw_text(_xpad, _ypad + _ybuffer*44, "ANGLE	: " + string(k_angle));
				draw_text(_xpad, _ypad + _ybuffer*46, "MODE		: " + string(k_mode));
				draw_text(_xpad, _ypad + _ybuffer*48, "TARGET	: " + object_get_name(k_target.object_index));
			}
			else																			{
				draw_text(_xpad, 16 + _ybuffer*36, "ZOOM	: " + string(round(k_zoom * 100)) + "%");
				draw_text(_xpad, 16 + _ybuffer*38, "SPEED	: " + string(k_spd));
				draw_text(_xpad, 16 + _ybuffer*40, "ANGLE	: " + string(k_angle));
				draw_text(_xpad, 16 + _ybuffer*42, "MODE	: " + string(k_mode));
				draw_text(_xpad, 16 + _ybuffer*44, "TARGET  : " + "NO TARGET");
			}
		surface_reset_target();

		// (Draw) the surface
		draw_surface_ext(debug_surface, 0, 0, display_get_gui_width()/surface_get_width(debug_surface), display_get_gui_height()/surface_get_height(debug_surface), 0, -1, 1);
	}
	else								{
		debug_surface = surface_create(d_surf_width, d_surf_height); // (Create) the surface if its not created
	}
}

draw_set_color(c_white);
