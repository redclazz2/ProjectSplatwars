/// @description Button mouse click

if pressed {
	pressed = false;
}
else {
	pressed = true;
}

configuration_set_gameplay_property(
	"current_local_player_username",
	oTextBox.inputUsername);

scene_system_set_target(5);
scene_system_goto_next();