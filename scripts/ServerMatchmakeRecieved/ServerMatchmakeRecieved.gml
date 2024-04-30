function ServerMatchmakeRecieved(_communicator):IReader(_communicator) constructor{
	read = function(_ip,_port,_buffer){
		var status = buffer_read(_buffer,buffer_u16),
			result = -1,
			data = undefined;
		
		if(status == 0)
			result = CommunicatorTCPNotificationCommands.ServerNoLobbyFound;
		else{
			result = CommunicatorTCPNotificationCommands.ServerLobbyFound;
			data = [];
			array_push(data,buffer_read(_buffer,buffer_u16));
			array_push(data,buffer_read(_buffer,buffer_u16));
			array_push(data,buffer_read(_buffer,buffer_string));
			array_push(data,buffer_read(_buffer,buffer_u16));
		}
		
		communicator.notify_manager(result,data);
	}
}