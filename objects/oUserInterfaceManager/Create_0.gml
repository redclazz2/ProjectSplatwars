depth = -1;
_drawManager = new IUserInterface();

function ui_event_handler(_data) {
	_drawManager.ui_event_handler(_data);
}

pubsub_subscribe("UIEventChange", ui_event_handler);

// TODO: fix this shit, crashes on mouse click
// pubsub_subscribe("GetChargeData", ui_event_handler); 

change_user_interface = function(_new){
	if(_new != undefined) {
		_drawManager.CleanUp();
		delete _drawManager;
		_drawManager = _new;	
	}
}
