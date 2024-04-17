/// @description User input behavior

// Checking pointer position to allow and disallow text input
if position_meeting(mouse_x, mouse_y, self) {  
	if device_mouse_check_button_pressed(0, mb_left) {
		canWrite = true;
		keyboard_virtual_show(kbv_type_default, kbv_returnkey_default, kbv_autocapitalize_none, false);
	}
}
else {
	if device_mouse_check_button_pressed(0, mb_left) {
		canWrite = false;
		keyboard_virtual_hide();
	}	
}

if canWrite {
	pointer = "|";
	inputUsername = string_copy(keyboard_string, 1, 12);  // 12 characters max
	
	if keyboard_check_pressed(13) {
		canWrite = false;
		keyboard_virtual_hide();
	}
}
else {
	pointer = "";
}










