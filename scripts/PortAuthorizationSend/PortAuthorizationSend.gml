function PortAuthorization(_communicator):IWriter(_communicator) constructor{
	write = function(){
		var buffer = communicator.buffer;
		
		if(buffer_exists(buffer)){
			buffer_seek(buffer,buffer_seek_start,1);
			buffer_write(buffer,buffer_u16,1);
			
			var socket = self.communicator.socket,
				url = "192.168.1.143",
				port = 8056;
			
			network_send_udp(socket,url,port,buffer,buffer_tell(buffer));
			
			logger(LOGLEVEL.INFO,"Sent Port Auth Request to main server UDP.","UDP - WRITER");
		}
	}
}