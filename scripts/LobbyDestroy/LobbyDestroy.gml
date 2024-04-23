function LobbyDestroy(_communicator,_id):IWriter(_communicator) constructor{
	lobby_to_destroy = _id;
	
	write = function(){
		var buffer = communicator.buffer;
			
		if(buffer_exists(buffer)){
			buffer_seek(buffer,buffer_seek_start,0);
			buffer_write(buffer,buffer_u16,4);
			buffer_write(buffer,buffer_u16,lobby_to_destroy);
			
			var socket = self.communicator.socket;
			
			network_send_raw(socket,buffer,buffer_tell(buffer));
			
			logger(LOGLEVEL.INFO,"Lobby destroy request sent to game server.","TCP - WRITER");
		}
	}
}