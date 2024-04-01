var _max_devices = 4;

for (var i = 0; i < _max_devices; i++)
{
	var _mouse_x = device_mouse_x_to_gui(i);
	var _mouse_y = device_mouse_y_to_gui(i);
	
	var _ui_at_pos = instance_position(_mouse_x, _mouse_y, IJoyStickUI);
	var _held = device_mouse_check_button(i, mb_left);
	
	if (_ui_at_pos != noone && _held)
	{
		_ui_at_pos.input(i, _mouse_x, _mouse_y);
	}
}