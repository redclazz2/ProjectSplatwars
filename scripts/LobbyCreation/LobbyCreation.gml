function LobbyCreation(_communicator):IWriter(_communicator) constructor{
	write = function(){
		var buffer = communicator.buffer;
		
		if(buffer_exists(buffer)){
			buffer_seek(buffer,buffer_seek_start,0);
			buffer_write(buffer,buffer_u16,1);
			buffer_write(buffer,buffer_u16,1);
			buffer_write(buffer,buffer_u16,1500);
			
			var socket = self.communicator.socket;
			
			network_send_raw(socket,buffer,buffer_tell(buffer));
			
			logger(LOGLEVEL.INFO,"Lobby creation request sent to game server.","TCP - WRITER");
		}
	}
}