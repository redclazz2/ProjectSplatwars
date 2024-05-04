function NATRequest(_request,_ip,_port,_communicator):IWriter(_communicator) constructor{
	/*
		5 - Firewall Breaker
		6 - Join Procedure
	*/
	request = _request;
	ip		= _ip;
	port	= _port;
	
	write = function(_request,_ip,_port){
		var buffer = communicator.buffer;
		
		if(buffer_exists(buffer)){
			buffer_seek(buffer,buffer_seek_start,0);
			buffer_write(buffer,buffer_u16,request);
			buffer_write(buffer,buffer_string,ip);
			buffer_write(buffer,buffer_u16,port);
			buffer_write(buffer,buffer_u16,communicator.manager.communicator_udp.port);
			
			var socket = self.communicator.socket;
			
			network_send_raw(socket,buffer,buffer_tell(buffer));
		}
	}
}