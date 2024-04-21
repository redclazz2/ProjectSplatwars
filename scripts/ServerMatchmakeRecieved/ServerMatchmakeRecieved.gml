function ServerMatchmakeRecieved(_communicator):IReader(_communicator) constructor{
	read = function(_ip,_port,_buffer){
		var status = buffer_read(_buffer,buffer_u16),
			result = -1;
		
		if(status == 0)
			result = CommunicatorTCPNotificationCommands.ServerNoLobbyFound;
		else
			result = CommunicatorTCPNotificationCommands.ServerLobbyFound;
		
		communicator.notify_manager(result);
	}
}