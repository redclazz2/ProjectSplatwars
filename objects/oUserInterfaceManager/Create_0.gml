depth = -1;
_drawManager = new IUserInterface();

function ui_event_handler(_data) {
	_drawManager.ui_event_handler(_data);
}

pubsub_subscribe("UIEventChange", ui_event_handler);