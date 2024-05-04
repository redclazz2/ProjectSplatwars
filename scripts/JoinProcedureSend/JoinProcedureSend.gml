function JoinProcedureSend(_community_id,_community_key,_host,_communicator):IWriter(_communicator) constructor{
	community_id	= _community_id;
	community_key	= _community_key;
	host			= _host;
	
	write = function(){
		var buffer = communicator.buffer;
		
		if(buffer_exists(buffer)){
			buffer_seek(buffer,buffer_seek_start,0);
			buffer_write(buffer,buffer_u16,0);
			buffer_write(buffer,buffer_u16,6);
			buffer_write(buffer,buffer_u16,community_id);
			buffer_write(buffer,buffer_u16,community_key);
			
			var socket = self.communicator.socket,
				url = host.get_station_data("ip"),
				port = host.get_station_data("port");
			
			network_send_udp(socket,url,port,buffer,buffer_tell(buffer));
			
			logger(LOGLEVEL.INFO,"Attemped to join a server ...");
		}
	}
}