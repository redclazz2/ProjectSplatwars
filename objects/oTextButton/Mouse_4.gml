/// @description Button mouse click

if pressed {
	pressed = false;
}
else {
	pressed = true;
}

// Apparently this works for touch input as well?
global.playerName = oTextBox.inputUsername;  // TODO: Store variable in game config

show_debug_message("Your username is: " + global.playerName);










