function IInputManagerStrategy(_player_manager) constructor{	
	
	player_manager = _player_manager;
	
	InputCheckAction = function(){
		show_debug_message($"W: Attempting to get input from interface player manager state!");
		return false;
	}
	
	InputCheckMovement = function(){
		show_debug_message($"W: Attempting to get input from interface player manager state!");
		return false;
	}
}