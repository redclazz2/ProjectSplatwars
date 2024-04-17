function ServerAuthorization(_communicator):IWriter(_communicator) constructor{
	write = function(){
		var buffer = communicator.buffer,
			game_version = configuration_get_property("software_version_release"),
			framework_version =  communicator.manager.get_network_configuration("ConfigurationFrameworkVersion");
		
		if(buffer_exists(buffer)){
			buffer_seek(buffer,buffer_seek_start,0);
			buffer_write(buffer,buffer_u16,0);
			buffer_write(buffer,buffer_string,game_version);
			buffer_write(buffer,buffer_string,framework_version);
			
			var socket = self.communicator.socket;
			
			network_send_raw(socket,buffer,buffer_tell(buffer));
			
			logger(LOGLEVEL.INFO,"Sent authorization request to game server.","TCP - WRITER");
		}
	}
}