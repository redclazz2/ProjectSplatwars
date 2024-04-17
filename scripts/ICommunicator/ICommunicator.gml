function ICommunicator(_manager) constructor{
	manager = _manager;
	port	= -1;
	state	= undefined;
	socket	= undefined;
	writer	= undefined;
	reader	= undefined;
	buffer	= undefined;
	
	change_writer = function(_writer){
		if(_writer != undefined) writer = _writer;
	}
	
	change_reader = function(_reader){
		if(_reader != undefined) reader = _reader;
	}
}