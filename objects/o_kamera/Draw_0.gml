/// @desc Debug Border

// Turn "TRUE" To "FALSE" If you don't wanna see that even if debug mode is (On)
if (true) {
	var _col1 = c_blue, _col2 = c_red;

	// (View) Border
	if (!is_undefined(k_target) && instance_exists(k_target)) {draw_rectangle_color((k_target.x + k_offset_x) - k_view_w/2 + 0.1, (k_target.y + k_offset_y) - k_view_h/2 + 0.1, (k_target.x + k_offset_x) + k_view_w/2 - 1.1, (k_target.y + k_offset_y) + k_view_h/2 - 1.1, _col1, _col1, _col1, _col1, true);}
	else													  {draw_rectangle_color((camera_get_view_x(kamera) + k_offset_x) + 0.1, (camera_get_view_y(kamera) + k_offset_y) + 0.1, (camera_get_view_x(kamera) + k_offset_x) + k_view_w - 1.1, (camera_get_view_y(kamera) + k_offset_y) + k_view_h - 1.1, _col1, _col1, _col1, _col1, true);}

	// (Room) Border
	draw_rectangle_color(0, 0, room_width, room_height, _col2, _col2, _col2, _col2, true);
}
