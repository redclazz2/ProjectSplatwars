function LobbyCreation(_communicator):IWriter(_communicator) constructor{
	write = function(){
		var buffer = communicator.buffer,
			port = communicator.manager.communicator_udp.port,
			rtt = 1500.0;
			
		if(buffer_exists(buffer)){
			buffer_seek(buffer,buffer_seek_start,0);
			buffer_write(buffer,buffer_u16,2);
			buffer_write(buffer,buffer_f32,rtt);
			buffer_write(buffer,buffer_u16,port);
			
			var socket = self.communicator.socket;
			
			network_send_raw(socket,buffer,buffer_tell(buffer));
			
			logger(LOGLEVEL.INFO,"Lobby creation request sent to game server.","TCP - WRITER");
		}
	}
}